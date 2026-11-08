-- Структура событий
SELECT event_type, COUNT(*) AS cnt
FROM events
GROUP BY 1
ORDER BY 2 DESC
