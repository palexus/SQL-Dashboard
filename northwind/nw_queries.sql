
/*

Throughout the week write SQL queries to answer the questions below

    Get the names and the quantities in stock for each product.

    Get a list of current products (Product ID and name).

    Get a list of the most and least expensive products (name and unit price).

    Get products that cost less than $20.

    Get products that cost between $15 and $25.

    Get products above average price.

    Find the ten most expensive products.

    Get a list of discontinued products (Product ID and name).

    Count current and discontinued products.

    Find products with less units in stock than the quantity on order.

    Find the customer who had the highest order amount

    Get orders for a given employee and the according customer

    Find the hiring age of each employee

    Create views and/or named queries for some of these queries

*/


-- 1. Get the names and the quantities in stock for each product.

SELECT productname, unitsinstock
  FROM products
  LIMIT 5;


-- 2. Get a list of current products (Product ID and name).

SELECT productid, productname FROM products;


-- 3. Get a list of the most and least expensive products (name and unit price).

SELECT * FROM products
	ORDER BY unitprice DESC;


-- 4. Get products that cost less than $20.

SELECT * FROM products
	WHERE unitprice < 20;


-- 5. Get products that cost between $15 and $25.

SELECT * FROM products
	WHERE 15 < unitprice AND unitprice < 25;


-- 6. Get products above average price.

SELECT * FROM products
	WHERE unitprice > (SELECT avg(unitprice) FROM products);


-- 7. Find the ten most expensive products.

SELECT * FROM products
	ORDER BY unitprice DESC
    LIMIT 10;


-- 8. Get a list of discontinued products (Product ID and name).

SELECT productid, productname FROM products
	WHERE discontinued=1;


-- 9. Count current and discontinued products.

SELECT (count(discontinued) - sum(discontinued)) current, sum(discontinued) discontinued FROM products;


-- 10. Find products with less units in stock than the quantity on order.

SELECT p1.productname, p1.unitsinstock, p1.unitsonorder FROM products p1
	JOIN products p2
        ON p1.unitsinstock < p1.unitsonorder;


-- 11. Find the customer who had the highest order amount	

SELECT max(number.count) FROM                   -- FRAGE: Wie bekommt man den Namen dazu?
        (SELECT count(customerid), customerid nam FROM orders 
            GROUP BY customerid) AS number;


-- 11. Find the customer who had the highest order amount	
            
SELECT count(customerid) count, customerid FROM orders 
            GROUP BY customerid
            ORDER BY count DESC
            LIMIT 1;


-- 12. Get orders for a given employee and the according customer.

CREATE VIEW empl_cust_ord AS (
    SELECT employeeid, customerid, orderid FROM orders 
        GROUP BY employeeid, customerid, orderid 
        ORDER BY employeeid, customerid
    );

-- This is how to view it: SELECT * FROM empl_cust_ord;

-- 13. Find the hiring age of each employee

SELECT employeeid, lastname, firstname, hiredate FROM employees;