-- В каких типах событий встречается цена <= 0
SELECT event_type, COUNT(*) AS cnt
FROM events
WHERE price <= 0
GROUP BY 1
ORDER BY 2 DESC
