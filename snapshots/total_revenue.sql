with payments as ( 
    select 
        * 
    from {{ ref('bronze_payment') }} 
), 
aggregated as ( 
    select 
        sum(amount) as total_revenue 
    from payments 
    where status = 'success' 
) 
select * from aggregated