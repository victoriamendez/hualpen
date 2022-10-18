{{ config(materialized='view') }}

with tb_ta_vehiculo_caracteristica as (

    select * 
 from {{ source('taller', 'tb_ta_vehiculo_caracteristica') }} 

)

, tb_ta_caracteristica 
as (

    select * 
 from {{ source('taller', 'tb_ta_caracteristica') }} 

)
, tb_ta_caracteristica_dominio 
as (

    select * 
 from {{ source('taller', 'tb_ta_caracteristica_dominio') }} 

)
, tb_ta_caracteristica_opcion
as (

    select * 
 from {{ source('taller', 'tb_ta_caracteristica_opcion') }} 

)

, final as (

select tb_ta_vehiculo_caracteristica.id_vehiculo,
       tb_ta_caracteristica.car_nombre,
       tb_ta_caracteristica.car_id,
       case when tb_ta_caracteristica.cad_id = 2 and tb_ta_vehiculo_caracteristica.vec_valor = '1' then 'SI'
           when tb_ta_caracteristica.cad_id = 2 and tb_ta_vehiculo_caracteristica.vec_valor = '0' then 'NO'
           when tb_ta_caracteristica.cad_id = 1 or tb_ta_caracteristica.cad_id = 4 then tb_ta_vehiculo_caracteristica.vec_valor
           when tb_ta_caracteristica.cad_id = 3  then ( select  upper(tb_ta_caracteristica_opcion.cao_nombre) cao_nombre
                                                           from tb_ta_caracteristica_opcion 
                                                           where tb_ta_caracteristica_opcion.car_id =  tb_ta_vehiculo_caracteristica.car_id 
                                                            and  tb_ta_caracteristica_opcion.cao_id = tb_ta_vehiculo_caracteristica.vec_valor::int
           )
           end valor
from tb_ta_vehiculo_caracteristica  
left join tb_ta_caracteristica             on   tb_ta_vehiculo_caracteristica.car_id = tb_ta_caracteristica.car_id
left join tb_ta_caracteristica_dominio     on   tb_ta_caracteristica.cad_id   =  tb_ta_caracteristica_dominio.cad_id
where tb_ta_caracteristica.car_id in(32,18,8,45,17,42,23)
)

, final_columnas as(

select final.id_vehiculo, 
       case when final.car_id = 32 then valor else null end traccion ,
       case when final.car_id = 18 then valor else null end N_butacas ,
       case when final.car_id = 8 then valor else  null end cinturon_pasajero ,
       case when final.car_id = 45 then valor else null end largo ,
       case when final.car_id = 17 then valor else null end baño ,
       case when final.car_id = 42 then valor else null end tipo_combustible ,
       case when final.car_id = 23 then valor else null end N_pisos 
    from final
)

select *
from final_columnas  

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null