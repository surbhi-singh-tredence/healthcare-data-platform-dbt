{{ config(materialized='table') }}
select
    row_number() over(order by lot_name) as batch_key,
    lot_name,
    lot_number
from (
    select distinct
        lot_name,
        lot_number
    from {{ ref('int_lab_results_cleaned') }}
)