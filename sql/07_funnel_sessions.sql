-- Конверсия по сессиям: покупка в той же сессии после первого просмотра
WITH s AS (
    SELECT user_session,
           MIN(event_time) FILTER (WHERE event_type = 'view')     AS first_view,
           MAX(event_time) FILTER (WHERE event_type = 'purchase') AS last_purchase
    FROM events_clean
    GROUP BY 1
)
SELECT COUNT(first_view) AS sessions_with_view,
       COUNT(*) FILTER (WHERE first_view IS NOT NULL AND last_purchase >= first_view) AS sessions_view_purchase
FROM s
