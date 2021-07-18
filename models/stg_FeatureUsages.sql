{{
  config(
    materialized='view'
  )
}}

SELECT
    date AS Date,
    application_id AS ApplicationID,
    feature AS Feature,
    usage AS Usage
FROM AlgoliaDB.Feature_usages
