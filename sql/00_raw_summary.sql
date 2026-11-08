-- Общая сводка по сырой таблице
SELECT COUNT(*) AS rows_cnt,
       MIN(event_time) AS first_event,
       MAX(event_time) AS last_event,
       COUNT(DISTINCT user_id) AS users
FROM events
