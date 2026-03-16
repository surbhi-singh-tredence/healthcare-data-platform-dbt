{{ config(materialized='view') }}
select

    label_id,
    sample_number,
    lot_name,
    lot_number,
    item_description,

    cast(date_completed as date) as date_completed,

    test_number,
    name as test_name,

    lower(product) as product,

    status,
    entry,
    product_grade,
    units,
    stage,

    x_method as method,

    reported_name,

    cast(sampled_date as date) as sampled_date,

    description,

    reportable,

    x_disposed as disposed,

    result_number

from {{ ref('healthcare_lab_dataset') }}