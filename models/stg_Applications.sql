{{
  config(
    materialized='view'
  )
}}

SELECT
  id AS ApplicationID,
  Name AS ApplicationName
FROM AlgoliaDB.Applications