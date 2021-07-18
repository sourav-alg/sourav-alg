{{
  config(
    materialized='view'
  )
}}

WITH FeatureUsages AS
(
    SELECT * FROM {{ ref('stg_FeatureUsages') }}
),

Usage AS
(
    SELECT Date, ApplicationID,
    CASE WHEN(SUM(CASE WHEN Feature='query_suggestions' THEN Usage ELSE 0 END)>=1000) THEN 'Yes' ELSE 'No' END AS QuerySuggestions,
	CASE WHEN(SUM(CASE WHEN Feature='query_rules' THEN Usage ELSE 0 END)>=100) THEN 'Yes' ELSE 'No' END AS QueryRules,
	CASE WHEN(SUM(CASE WHEN Feature='visual_editor' THEN Usage ELSE 0 END)>=10) THEN 'Yes' ELSE 'No' END AS VisualEditor
    FROM FeatureUsages
    GROUP BY Date, ApplicationID
),

UsedCount AS
(
    SELECT Date,SUM(QSCnt) AS QSCnt,SUM(QRCnt) AS QRCnt,SUM(VECNt) AS VECNt
	FROM
    (
        SELECT Date, ApplicationID,
        CASE WHEN(SUM(CASE WHEN Feature='query_suggestions' THEN Usage ELSE 0 END)>=1000) THEN 1 ELSE 0 END AS QSCnt,
        CASE WHEN(SUM(CASE WHEN Feature='query_rules' THEN Usage ELSE 0 END)>=100) THEN 1 ELSE 0 END AS QRCnt,
        CASE WHEN(SUM(CASE WHEN Feature='visual_editor' THEN Usage ELSE 0 END)>=10) THEN 1 ELSE 0 END AS VECNt
        FROM FeatureUsages
        GROUP BY Date, ApplicationID
    ) SUB
	GROUP BY Date
)

SELECT Usage.Date,QuerySuggestions,QSCnt AS QuerySuggestions_Count,
QueryRules,QRCnt AS QueryRules_Count,
VisualEditor,VECnt AS VisualEditor_Count
FROM Usage
LEFT JOIN UsedCount USING (Date)
ORDER BY 1





