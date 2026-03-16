{{ config(materialized='table') }}
select distinct

    label_id,

    regexp_replace(sample_number, '_err', '') as sample_number,

    lot_name,
    lot_number,
    item_description,

    date_completed,

    test_number,
    test_name,

    coalesce(product, 'unknown') as product,

    trim(coalesce(status, 'unknown')) as status,

    entry,
    product_grade,
    units,
    stage,
    method,
    reported_name,
    sampled_date,
    description,
    reportable,
    disposed,
    result_number

from {{ ref('stg_lab_results') }}