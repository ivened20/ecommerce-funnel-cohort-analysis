-- Конверсия по ценовым диапазонам просмотренного товара.
-- Границы диапазонов заданы в единицах цены из данных (валюта в датасете не указана).
WITH ev AS (
    SELECT user_id, event_type, event_time, price,
           CASE WHEN price < 50  THEN '1: до 50'
                WHEN price < 100 THEN '2: 50–100'
                WHEN price < 250 THEN '3: 100–250'
                WHEN price < 500 THEN '4: 250–500'
                ELSE                  '5: от 500' END AS price_band
    FROM events_clean
    WHERE event_type IN ('view', 'purchase') AND price > 0
),
v AS (
    SELECT user_id, price_band, MIN(event_time) AS first_view
    FROM ev WHERE event_type = 'view' GROUP BY 1, 2
),
p AS (
    SELECT user_id, price_band, MAX(event_time) AS last_purchase, SUM(price) AS revenue
    FROM ev WHERE event_type = 'purchase' GROUP BY 1, 2
)
SELECT v.price_band,
       COUNT(*) AS viewers,
       COUNT(*) FILTER (WHERE p.last_purchase >= v.first_view) AS viewer_buyers,
       SUM(p.revenue) AS revenue
FROM v LEFT JOIN p ON v.user_id = p.user_id AND v.price_band = p.price_band
GROUP BY 1
ORDER BY 1
