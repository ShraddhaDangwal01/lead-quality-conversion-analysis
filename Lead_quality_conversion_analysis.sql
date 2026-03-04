

SET SQL_SAFE_UPDATES = 0;

USE olist_funnel;

-------------------------------------------------------
-- Rebuild Clean Funnel Base
-------------------------------------------------------

DROP TABLE IF EXISTS funnel_base;

CREATE TABLE funnel_base AS
SELECT 
    l.mql_id,
    l.first_contact_date,
    l.origin,
    d.won_date,

    CASE
        WHEN d.mql_id IS NOT NULL THEN 1
        ELSE 0
    END AS converted,

    d.business_segment,
    d.lead_type,
    d.lead_behaviour_profile,
    d.has_company,
    d.has_gtin,
    d.average_stock,
    d.declared_product_catalog_size,
    d.declared_monthly_revenue

FROM leads l
LEFT JOIN closed_deals d
    ON l.mql_id = d.mql_id;

-------------------------------------------------------
-- Add Structural Quality Metrics
-------------------------------------------------------

ALTER TABLE funnel_base
ADD COLUMN missing_fields_count INT;

UPDATE funnel_base
SET missing_fields_count =
(
    (CASE WHEN declared_product_catalog_size IS NULL OR declared_product_catalog_size = 0 THEN 1 ELSE 0 END)
  + (CASE WHEN declared_monthly_revenue IS NULL OR declared_monthly_revenue = 0 THEN 1 ELSE 0 END)
  + (CASE WHEN has_company IS NULL OR has_company = 0 THEN 1 ELSE 0 END)
  + (CASE WHEN average_stock IS NULL OR average_stock = 0 THEN 1 ELSE 0 END)
);

-------------------------------------------------------
-- Add Lead Readiness Score
-------------------------------------------------------

ALTER TABLE funnel_base
ADD COLUMN readiness_score INT;

UPDATE funnel_base
SET readiness_score =
(
    (CASE WHEN declared_product_catalog_size > 0 THEN 1 ELSE 0 END)
  + (CASE WHEN declared_monthly_revenue > 0 THEN 1 ELSE 0 END)
  + (CASE WHEN has_company = 1 THEN 1 ELSE 0 END)
  + (CASE WHEN average_stock > 0 THEN 1 ELSE 0 END)
);

-------------------------------------------------------
-- Add Friction Score (Inverse Readiness)
-------------------------------------------------------

ALTER TABLE funnel_base
ADD COLUMN friction_score INT;

UPDATE funnel_base
SET friction_score = 4 - readiness_score;

-------------------------------------------------------
-- Add Completeness Level Category
-------------------------------------------------------

ALTER TABLE funnel_base
ADD COLUMN completeness_level VARCHAR(30);

UPDATE funnel_base
SET completeness_level =
CASE
    WHEN missing_fields_count <= 1 THEN 'HIGH_COMPLETENESS'
    ELSE 'LOW_COMPLETENESS'
END;

-------------------------------------------------------
-- Add Behaviour Cleaned Column
-------------------------------------------------------

ALTER TABLE funnel_base
ADD COLUMN behaviour_profile_clean VARCHAR(100);

UPDATE funnel_base
SET behaviour_profile_clean =
CASE
    WHEN lead_behaviour_profile IS NULL OR TRIM(lead_behaviour_profile) = ''
    THEN 'UNKNOWN'
    ELSE lead_behaviour_profile
END;

-------------------------------------------------------
--  Final Validation Check
-------------------------------------------------------

SELECT 
    COUNT(*) AS total_leads,
    SUM(converted) AS converted_leads,
    ROUND(SUM(converted)*1.0/COUNT(*),3) AS overall_conversion_rate
FROM funnel_base;


USE olist_funnel;

CREATE VIEW origin_quality_metrics AS
SELECT
    origin,
    COUNT(*) AS total_leads,
    SUM(converted) AS converted_leads,
    COUNT(*) - SUM(converted) AS dropped_leads,
    ROUND(SUM(converted) * 1.0 / COUNT(*), 3) AS conversion_rate,
    ROUND(
        SUM(
            CASE 
                WHEN declared_product_catalog_size IS NULL 
                     OR declared_product_catalog_size = 0 
                THEN 1
                ELSE 0
            END
        ) * 1.0 / COUNT(*),
        3
    ) AS low_intent_share
FROM funnel_base
GROUP BY origin;

SHOW FULL TABLES;
SELECT * FROM origin_quality_metrics;