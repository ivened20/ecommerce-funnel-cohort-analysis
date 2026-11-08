-- Очистка: убираем события без сессии и полные дубли.
-- Пустые category_code / brand и цену <= 0 оставляем (см. ноутбук, раздел 3).
CREATE OR REPLACE TABLE events_clean AS
SELECT DISTINCT *
FROM events
WHERE user_session IS NOT NULL
