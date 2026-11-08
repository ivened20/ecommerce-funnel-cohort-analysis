-- Проверки качества сырых данных
SELECT COUNT(*) AS rows_cnt,
       COUNT(*) FILTER (WHERE category_code IS NULL) AS null_category_code,
       COUNT(*) FILTER (WHERE brand IS NULL)         AS null_brand,
       COUNT(*) FILTER (WHERE user_session IS NULL)  AS null_session,
       COUNT(*) FILTER (WHERE price IS NULL)         AS null_price,
       COUNT(*) FILTER (WHERE price <= 0)            AS nonpositive_price
FROM events
