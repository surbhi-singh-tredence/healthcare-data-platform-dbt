{{ config(materialized='table') }}
select
    row_number() over(order by product) as product_key,
    product,
    product_grade
from (
    select distinct
        product,
        product_grade
    from {{ ref('int_lab_results_cleaned') }}
)