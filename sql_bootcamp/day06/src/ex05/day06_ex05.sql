COMMENT ON TABLE person_discounts IS 'Цель таблицы - показать цены и скидки, 
которые пиццерии могли бы предложить своим клиентам, сделавших хоть один заказ';
COMMENT ON COLUMN person_discounts.id IS 'Нумерация строк в таблице';
COMMENT ON COLUMN person_discounts.pizzeria_id IS 'Индификационный номер пиццерии';
COMMENT ON COLUMN person_discounts.person_id IS 'Индификационный номер человека';
COMMENT ON COLUMN person_discounts.discount IS 'Размер скидки в процентах';