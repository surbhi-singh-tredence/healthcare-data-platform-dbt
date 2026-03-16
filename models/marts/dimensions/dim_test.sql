{{ config(materialized='table') }}
select
    row_number() over(order by test_number) as test_key,
    test_number,
    test_name as name,
    item_description,
    reported_name
from (
    select distinct
        test_number,
        test_name,
        item_description,
        reported_name
    from {{ ref('int_lab_results_cleaned') }}
)