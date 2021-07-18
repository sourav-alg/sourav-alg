{{
  config(
    materialized='view'
  )
}}

WITH FeatureUsages AS
(
    SELECT * FROM {{ ref('stg_FeatureUsages') }}
),

ActivatedCount AS
(
    SELECT Date,
    SUM(CASE WHEN Feature='query_suggestions' THEN 1 ELSE 0 END) AS QSCnt,
	SUM(CASE WHEN Feature='query_rules' THEN 1 ELSE 0 END) AS QRCnt,
	SUM(CASE WHEN Feature='visual_editor' THEN 1 ELSE 0 END) AS VECnt 
    FROM FeatureUsages
    GROUP BY Date
)

SELECT 
FeatureUsages.Date,FeatureUsages.ApplicationID,
CASE WHEN FeatureUsages.feature='query_suggestions' THEN 'Yes' ELSE 'No' END AS QuerySuggestions,
QSCnt AS QuerySuggestions_Count,
CASE WHEN FeatureUsages.feature='query_rules' THEN 'Yes' ELSE 'No' END AS QueryRules,
QRCnt AS QueryRules_Count,
CASE WHEN FeatureUsages.feature='visual_editor' THEN 'Yes' ELSE 'No' END AS VisualEditor,
VECnt AS VisualEditor_Count
FROM FeatureUsages
LEFT JOIN ActivatedCount USING (Date)
ORDER BY 1




