{{
  config(
    materialized='view'
  )
}}

SELECT
    date AS Date,
    plan_id AS PlanID,
    query_suggestions AS QuerySuggestions,
    query_rules AS QueryRules,
    visual_editor AS VisualEditor
FROM AlgoliaDB.Plans_history