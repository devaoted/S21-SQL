WITH temp AS (
     SELECT b.user_id
          , b.type                                    AS type
          , SUM(b.money)                              AS volume
          , c.name                                    AS currency_name
          , COALESCE(c.rate_to_usd, 1)                AS last_rate_to_usd
          , SUM(b.money * COALESCE(c.rate_to_usd, 1)) AS total_volume_in_usd
     FROM balance b
     LEFT JOIN currency c 
          ON b.currency_id = c.id AND c.updated = (
               SELECT MAX(updated)
               FROM currency
               WHERE id = b.currency_id)
     GROUP BY b.user_id, type, currency_name, last_rate_to_usd
     ORDER BY 1, 3
)

SELECT COALESCE(u.name, 'not defined') AS name
     , COALESCE(u.lastname, 'not defined') AS lastname
     , temp.type
     , temp.volume
     , COALESCE(temp.currency_name, 'not defined') AS currency_name
     , temp.last_rate_to_usd
     , temp.total_volume_in_usd
FROM temp
     LEFT JOIN "user" u ON temp.user_id = u.id
ORDER BY
    name desc, lastname, temp.type;
