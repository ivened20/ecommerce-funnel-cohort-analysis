-- Повторные покупатели: покупки минимум в 2 разных дня
WITH b AS (
    SELECT user_id, COUNT(DISTINCT event_time::DATE) AS buy_days
    FROM events_clean
    WHERE event_type = 'purchase'
    GROUP BY 1
)
SELECT COUNT(*) AS buyers,
       COUNT(*) FILTER (WHERE buy_days >= 2) AS repeat_buyers
FROM b
