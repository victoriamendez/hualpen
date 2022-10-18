{{ config(materialized='view') }}

with final as (

    select * , now() fecha_de_actualizacion
 from {{ source('taller', 'tb_ta_marca_vehiculo') }} 

)

select *
from final 

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
