{{ config(materialized='incremental') }}
select

    s.sample_number as test_id,

    p.product_key,
    m.method_key,
    st.status_key,
    b.batch_key,
    t.test_key,

    s.label_id,
    s.sample_number,
    s.entry,
    s.result_number,
    s.description,
    s.date_completed,
    s.sampled_date

from {{ ref('int_lab_results_cleaned') }} s

left join {{ ref('dim_product') }} p
on s.product = p.product
and s.product_grade = p.product_grade

left join {{ ref('dim_method') }} m
on s.method = m.x_method
and s.stage = m.stage
and s.units = m.units

left join {{ ref('dim_status') }} st
on s.status = st.status
and s.reportable = st.reportable
and s.disposed = st.x_disposed

left join {{ ref('dim_batch') }} b
on s.lot_name = b.lot_name
and s.lot_number = b.lot_number

left join {{ ref('dim_test') }} t
on s.test_number = t.test_number
and s.test_name = t.name
and s.item_description = t.item_description
and s.reported_name = t.reported_name