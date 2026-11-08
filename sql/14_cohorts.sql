-- Недельные когорты: 7-дневные периоды от 1 октября, только полные недели (wk <= {last_full_week}).
-- week_n = неделя после недели первого появления. Параметр подставляется из ноутбука.
WITH d AS (
    SELECT user_id,
           date_diff('day', DATE '2019-10-01', event_time::DATE) // 7 AS wk,
           bool_or(event_type = 'purchase') AS bought
    FROM events_clean
    GROUP BY 1, 2
),
f AS (
    SELECT user_id, MIN(wk) AS cohort FROM d GROUP BY 1
),
x AS (
    SELECT d.user_id, f.cohort, d.wk - f.cohort AS week_n, d.bought
    FROM d JOIN f USING (user_id)
    WHERE d.wk <= {last_full_week}
),
b0 AS (
    SELECT user_id FROM x WHERE week_n = 0 AND bought
)
SELECT cohort, week_n,
       COUNT(*) AS active_users,
       COUNT(*) FILTER (WHERE bought) AS purchasing_users,
       COUNT(*) FILTER (WHERE bought AND user_id IN (SELECT user_id FROM b0)) AS repeat_buyers
FROM x
GROUP BY 1, 2
ORDER BY 1, 2
