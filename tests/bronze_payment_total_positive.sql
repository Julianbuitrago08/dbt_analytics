select
    id,
    sum(amount) as total_amount
from {{ ref('bronze_payment') }}
group by 1
having total_amount < 0