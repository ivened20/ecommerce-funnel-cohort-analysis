-- Метрики по дням. Заказ приравнен к сессии с покупкой (order_id в данных нет).
SELECT event_time::DATE AS day,
       COUNT(*) FILTER (WHERE event_type = 'view')     AS views,
       COUNT(*) FILTER (WHERE event_type = 'cart')     AS carts,
       COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchase_events,
       COUNT(DISTINCT user_id)                                           AS active_users,
       COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'view')        AS viewers,
       COUNT(DISTINCT user_id) FILTER (WHERE event_type = 'purchase')    AS buyers,
       COUNT(DISTINCT user_session) FILTER (WHERE event_type = 'purchase') AS approx_orders,
       SUM(price) FILTER (WHERE event_type = 'purchase' AND price > 0)   AS revenue
FROM events_clean
GROUP BY 1
ORDER BY 1
