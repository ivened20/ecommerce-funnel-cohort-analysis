-- Сколько проходит от первого просмотра до первой покупки (только для купивших после просмотра).
-- Ограничение: у тех, кто впервые появился в конце месяца, окно наблюдения короче,
-- поэтому быстрые покупки в этой выборке видны лучше, чем долгие.
WITH u AS (
    SELECT user_id,
           MIN(event_time) FILTER (WHERE event_type = 'view')     AS first_view,
           MIN(event_time) FILTER (WHERE event_type = 'purchase') AS first_purchase
    FROM events_clean
    GROUP BY 1
)
SELECT CASE WHEN date_diff('minute', first_view, first_purchase) < 60    THEN '1: до 1 часа'
            WHEN date_diff('minute', first_view, first_purchase) < 1440  THEN '2: 1–24 часа'
            WHEN date_diff('minute', first_view, first_purchase) < 10080 THEN '3: 1–7 дней'
            ELSE                                                              '4: больше 7 дней' END AS time_to_purchase,
       COUNT(*) AS buyers
FROM u
WHERE first_view IS NOT NULL AND first_purchase >= first_view
GROUP BY 1
ORDER BY 1
