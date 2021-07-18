{{
  config(
    materialized='view'
  )
}}

SELECT
    id AS PlanID,
    application_id AS ApplicationID,
    query_suggestions AS QuerySuggestions,
    query_rules AS QueryRules,
    visual_editor AS VisualEditor
FROM AlgoliaDB.Plans