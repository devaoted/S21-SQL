create table person_discounts
( id serial primary key,
  person_id bigint, --FOREIGN KEY fk_person_discounts_person_id REFERENCES person(id),
  pizzeria_id bigint ,
  discount float, 
  
  CONSTRAINT fk_person_discounts_pizzeria_id 
  FOREIGN KEY (pizzeria_id) REFERENCES pizzeria(id),
  CONSTRAINT fk_person_discounts_person_id 
  FOREIGN KEY (person_id) REFERENCES person(id)
);

-- DROP table person_discounts;
