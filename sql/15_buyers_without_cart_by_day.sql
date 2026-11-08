-- Покупатели без корзины перед первой покупкой, по дню первой покупки
WITH u AS (
    SELECT user_id,
           MIN(event_time) FILTER (WHERE event_type = 'cart')     AS t_cart,
           MIN(event_time) FILTER (WHERE event_type = 'purchase') AS t_purchase
    FROM events_clean
    GROUP BY 1
)
SELECT t_purchase::DATE AS day,
       COUNT(*) AS buyers,
       COUNT(*) FILTER (WHERE t_cart IS NULL OR t_cart > t_purchase) AS buyers_no_cart_before
FROM u
WHERE t_purchase IS NOT NULL
GROUP BY 1
ORDER BY 1
