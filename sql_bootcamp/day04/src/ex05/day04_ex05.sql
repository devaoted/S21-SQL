CREATE VIEW v_price_with_discount AS
SELECT name, pizza_name, price,
    (price * 0.9)::integer AS discount_price
FROM person_order
JOIN menu ON menu.id = person_order.menu_id
JOIN person ON person.id = person_order.person_id
ORDER BY name, pizza_name
