-- Проверка события cart: был ли у покупателя вообще «корзинный» след до покупки
WITH u AS (
    SELECT user_id,
           MIN(event_time) FILTER (WHERE event_type = 'cart')     AS t_cart,
           MIN(event_time) FILTER (WHERE event_type = 'purchase') AS t_purchase
    FROM events_clean
    GROUP BY 1
)
SELECT COUNT(*) FILTER (WHERE t_purchase IS NOT NULL AND t_cart IS NOT NULL AND t_cart <= t_purchase) AS cart_before_purchase,
       COUNT(*) FILTER (WHERE t_purchase IS NOT NULL AND t_cart IS NULL)                              AS never_added_to_cart,
       COUNT(*) FILTER (WHERE t_purchase IS NOT NULL AND t_cart > t_purchase)                         AS cart_only_after_purchase,
       COUNT(*) FILTER (WHERE t_cart IS NOT NULL)     AS carters,
       COUNT(*) FILTER (WHERE t_purchase IS NOT NULL) AS buyers
FROM u
