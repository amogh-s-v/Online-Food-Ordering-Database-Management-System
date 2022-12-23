-- JOIN Queries

-- 1) If a customer wants to know the total price present in the cart
SELECT SUM(quantity_chosen * cost) AS total_payable , cart_id
FROM food_items AS p JOIN cart_items AS c 
ON p.food_id = c.food_id 
WHERE c.food_id in (SELECT 
                       food_id from cart_items where cart_id in (SELECT 
                                                                cart_id from customer where customer_id='CUS002'));

-- 2) If a customer wants to know the total price to be paid after applying coupon code. 
SELECT (total_payable - total_payable*discount/100) as total_with_discount, coupon_code, cart_id
FROM coupon as cp JOIN (SELECT SUM(quantity_chosen * cost) AS total_payable, cart_id 
						FROM food_items AS p JOIN cart_items AS c 
						ON p.food_id = c.food_id 
						WHERE c.food_id in (SELECT 
                       						food_id from cart_items where cart_id in (SELECT 
                                                                					  cart_id from customer where customer_id='CUS002'))) as tp

WHERE cp.coupon_code in (SELECT coupon_code from cart
                         WHERE cart.cart_id = tp.cart_id);

--3) Items in a cart
SELECT  f.food_name as Name, c.quantity_chosen as Quantity, f.cost*c.quantity_chosen as Cost
FROM cart_items as c JOIN food_items as f
ON c.food_id = f.food_id
WHERE c.cart_id = 'C004';

--4) Users who have used a coupon code
SELECT customer_name, cart_id, coupon_code
FROM cart NATURAL JOIN customer
WHERE cart.coupon_code IS NOT NULL 


-- Aggregate Queries

--1) How much food was sold on the particular date.
SELECT COUNT(food_id), SUM(quantity_chosen), date_added 
FROM cart_items 
GROUP BY date_added;

--2) How many items the customer has in their cart.
SELECT c.customer_id, COUNT(cr.cart_id)
FROM customer as c JOIN cart_items as cr
ON c.cart_id = cr.cart_id
GROUP BY c.customer_id;

--3) How many restaurants are there in the customer's area
SELECT c.customer_id, COUNT(r.restaurant_id)
FROM customer as c JOIN restaurant as r
ON c.pincode = r.pincode
GROUP BY (c.customer_id);


--4) How many Rice items are there in each restaurant
SELECT COUNT(food_items.category) as '# Of Rice Items', restaurant.restaurant_name
FROM food_items JOIN restaurant 
ON food_items.restaurant_id = restaurant.restaurant_id
WHERE category = "Rice"
GROUP BY food_items.restaurant_id;

-- Set Opeartions

--1) Food itmes which serve 2 people and cost less than 150 Rs
SELECT food_items.food_name, food_items.serves, food_items.cost, food_items.restaurant_id
FROM food_items 
WHERE food_items.serves = 2
INTERSECT
SELECT food_items.food_name, food_items.serves, food_items.cost, food_items.restaurant_id
FROM food_items 
WHERE food_items.cost <= 150

--2) Food itmes which serve only 1 person and cost less than 200 Rs
SELECT food_items.food_name, food_items.serves, food_items.cost, food_items.restaurant_id
FROM food_items 
WHERE food_items.serves = 1
EXCEPT
SELECT food_items.food_name, food_items.serves, food_items.cost, food_items.restaurant_id
FROM food_items 
WHERE food_items.cost >= 200

--3) Food items bought before and after certain dates.
SELECT * 
FROM cart_items
WHERE date_added >'2022-11-20'
UNION
SELECT * 
FROM cart_items
WHERE date_added <'2022-11-15' 

--4) Food items which cost less than 100 Rs or more than 200 Rs
SELECT food_items.food_name, food_items.serves, food_items.cost, food_items.restaurant_id
FROM food_items 
WHERE food_items.cost <= 100
UNION ALL
SELECT food_items.food_name, food_items.serves, food_items.cost, food_items.restaurant_id
FROM food_items 
WHERE food_items.cost >= 200


-- Functions
-- Function which returns total number of products which a particular restaurant sells

DELIMITER $$
CREATE FUNCTION totalProducts(rid varchar(255))
RETURNS INT(11)
BEGIN
	DECLARE total INT(11);
	select COUNT(*) into total
    from food_items
	where restaurant_id=rid;
    RETURN total;
END
$$

DELIMITER ;

SELECT totalProducts("RS001");

-- Procedure
-- Procedure which returns the total quantity of product with the given ID

DELIMITER //
CREATE PROCEDURE prod_details (IN fid VARCHAR(25), OUT food_stock INT(5))
BEGIN
	SELECT stock into food_stock
    FROM food_items 
    WHERE food_id = fid;
END;
//

DELIMITER ;

CALL prod_details ("F001", @FoodStock);
SELECT @FoodStock;

--Trigger
--Clear Cart items foe the user who made the payment

DELIMITER //
CREATE TRIGGER clear_cart_after_payment
AFTER INSERT ON animals
FOR EACH ROW
BEGIN
	DELETE FROM cart_items WHERE cart_id = NEW.cart_id;
END; //

--Cursor
--Cursor to fetch 5 cheapest food items
DELIMITER $$
create PROCEDURE getCheapest()
BEGIN

declare name varchar(50);
declare id varchar(50);
declare f_cost int;
declare counter int default 0;
DECLARE done INT DEFAULT FALSE;

DECLARE c CURSOR FOR SELECT food_items.food_name, food_items.cost FROM food_items ORDER BY food_items.cost ASC LIMIT 5;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;

open c;

read_loop: LOOP
    FETCH c into name, f_cost;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SELECT name, f_cost;
  END LOOP;

close c;
END
DELIMITER ;