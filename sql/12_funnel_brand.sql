-- Конверсия по брендам (пустой бренд выделен в группу «не указан»)
WITH ev AS (
    SELECT user_id, event_type, event_time, price,
           COALESCE(brand, 'не указан') AS brand
    FROM events_clean
    WHERE event_type IN ('view', 'purchase')
),
v AS (
    SELECT user_id, brand, MIN(event_time) AS first_view
    FROM ev WHERE event_type = 'view' GROUP BY 1, 2
),
p AS (
    SELECT user_id, brand, MAX(event_time) AS last_purchase,
           SUM(price) FILTER (WHERE price > 0) AS revenue
    FROM ev WHERE event_type = 'purchase' GROUP BY 1, 2
)
SELECT v.brand,
       COUNT(*) AS viewers,
       COUNT(*) FILTER (WHERE p.last_purchase >= v.first_view) AS viewer_buyers,
       SUM(p.revenue) AS revenue
FROM v LEFT JOIN p ON v.user_id = p.user_id AND v.brand = p.brand
GROUP BY 1
