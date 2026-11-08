-- Выручка и приблизительное число заказов. Цена <= 0 в выручку не входит.
SELECT COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchase_events,
       SUM(price) FILTER (WHERE event_type = 'purchase' AND price > 0) AS revenue,
       COUNT(DISTINCT user_session) FILTER (WHERE event_type = 'purchase') AS approx_orders
FROM events_clean
