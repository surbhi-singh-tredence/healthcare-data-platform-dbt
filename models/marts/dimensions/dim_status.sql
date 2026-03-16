{{ config(materialized='table') }}
select
    row_number() over(order by status) as status_key,
    status,
    reportable,
    disposed as x_disposed
from (
    select distinct
        status,
        reportable,
        disposed
    from {{ ref('int_lab_results_cleaned') }}
)