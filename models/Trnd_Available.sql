{{
  config(
    materialized='view'
  )
}}

WITH PlansHistory AS
(
    SELECT * FROM {{ ref('stg_PlansHistory') }}
),

Plans AS 
(
    SELECT * FROM {{ ref('stg_Plans') }}
),

AvailableCount AS
(
    SELECT Date,
    SUM(CASE WHEN QuerySuggestions='TRUE' THEN 1 ELSE 0 END) AS QS_Cnt,
    SUM(CASE WHEN QueryRules='TRUE' THEN 1 ELSE 0 END) AS QR_Cnt,
    SUM(CASE WHEN VisualEditor='TRUE' THEN 1 ELSE 0 END) AS VE_Cnt,
    FROM PlansHistory
    GROUP BY Date
)

SELECT PlansHistory.Date,Plans.ApplicationID,
CASE WHEN PlansHistory.QuerySuggestions='TRUE' THEN 'Yes' ELSE 'No' END AS QuerySuggestions,
AvailableCount.QS_Cnt AS QuerySuggestions_Count,
CASE WHEN PlansHistory.QueryRules='TRUE' THEN 'Yes' ELSE 'No' END AS QueryRules,
AvailableCount.QR_Cnt AS QueryRules_Count,
CASE WHEN PlansHistory.VisualEditor='TRUE' THEN 'Yes' ELSE 'No' END AS VisualEditor,
AvailableCount.VE_Cnt AS VisualEditor_Count
FROM PlansHistory
LEFT JOIN Plans USING(PlanID)
LEFT JOIN AvailableCount USING(Date)
ORDER BY 1

