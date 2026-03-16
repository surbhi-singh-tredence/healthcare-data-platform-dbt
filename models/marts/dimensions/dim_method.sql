{{ config(materialized='table') }}
select
    row_number() over(order by method) as method_key,
    method as x_method,
    stage,
    units
from (
    select distinct
        method,
        stage,
        units
    from {{ ref('int_lab_results_cleaned') }}
)