-- Конверсия по верхнему уровню категории.
-- Покупка засчитывается, если пользователь купил в той же категории не раньше первого просмотра этой категории.
WITH ev AS (
    SELECT user_id, event_type, event_time, price,
           COALESCE(split_part(category_code, '.', 1), 'не указана') AS category
    FROM events_clean
    WHERE event_type IN ('view', 'purchase')
),
v AS (
    SELECT user_id, category, MIN(event_time) AS first_view
    FROM ev WHERE event_type = 'view' GROUP BY 1, 2
),
p AS (
    SELECT user_id, category, MAX(event_time) AS last_purchase,
           SUM(price) FILTER (WHERE price > 0) AS revenue
    FROM ev WHERE event_type = 'purchase' GROUP BY 1, 2
)
SELECT COALESCE(v.category, p.category) AS category,
       COUNT(v.user_id) AS viewers,
       COUNT(*) FILTER (WHERE v.first_view IS NOT NULL AND p.last_purchase >= v.first_view) AS viewer_buyers,
       COUNT(p.user_id) AS buyers_all,
       COUNT(*) FILTER (WHERE v.first_view IS NULL AND p.user_id IS NOT NULL) AS buyers_without_category_view,
       SUM(p.revenue) AS revenue
FROM v FULL OUTER JOIN p ON v.user_id = p.user_id AND v.category = p.category
GROUP BY 1
