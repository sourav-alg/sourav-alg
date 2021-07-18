{{
  config(
    materialized='view'
  )
}}

WITH Applications AS
(
    SELECT * FROM {{ ref('stg_Applications') }}
),

Plans AS 
(
    SELECT * FROM {{ ref('stg_Plans') }}
),

FeatureUsages AS 
(
    SELECT * FROM {{ ref('stg_FeatureUsages') }} WHERE Feature='query_rules'
),


FeatureUsagesUsed AS 
(
    SELECT * FROM {{ ref('stg_FeatureUsages') }} WHERE Feature='query_rules' AND Date>(current_date-16)
)


SELECT 
current_date AS CurrentDate,
Applications.ApplicationID,
CASE WHEN Plans.QuerySuggestions='TRUE' THEN 'Yes' ELSE 'No' END AS Available,
CASE WHEN (SUM(FeatureUsages.usage))>0 THEN 'Yes' ELSE 'No' END AS Activated, 
CASE WHEN (SUM(FeatureUsagesUsed.usage))>100 THEN 'Yes' ELSE 'No' END AS Used,
FROM Applications
LEFT JOIN Plans USING (ApplicationID)
LEFT JOIN FeatureUsages USING (ApplicationID) 
LEFT JOIN FeatureUsagesUsed USING (ApplicationID) 
GROUP BY 
Applications.ApplicationID,
CASE WHEN Plans.QuerySuggestions='TRUE' THEN 'Yes' ELSE 'No' END