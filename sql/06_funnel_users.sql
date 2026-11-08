-- Воронка по пользователям за месяц.
-- viewer_buyers: купили не раньше первого просмотра. buyers_all: купили вообще.
WITH u AS (
    SELECT user_id,
           MIN(event_time) FILTER (WHERE event_type = 'view')     AS first_view,
           MAX(event_time) FILTER (WHERE event_type = 'purchase') AS last_purchase
    FROM events_clean
    GROUP BY 1
)
SELECT COUNT(*)                AS all_users,
       COUNT(first_view)       AS viewers,
       COUNT(last_purchase)    AS buyers_all,
       COUNT(*) FILTER (WHERE first_view IS NOT NULL AND last_purchase >= first_view) AS viewer_buyers,
       COUNT(*) FILTER (WHERE first_view IS NULL AND last_purchase IS NOT NULL)       AS buyers_without_view
FROM u
