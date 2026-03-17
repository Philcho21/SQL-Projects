
--Phase 1 : Data Cleaining
--In this project I am going to exploring data from a ecommerce retailer to bring out the story behind the data.
--Lets start by cleaning the data
--1.1 We find duplicates from the customer table using the email column as each ustomer should have a unique email address.

SELECT 
	email, COUNT(*) AS duplicates,
	MIN(customer_id) AS first_id,
	MAX(customer_id) AS last_id
	FROM customers GROUP BY email HAVING COUNT(*) > 1
	ORDER BY duplicates DESC;

--1.2 Check all order stutueses from Orders table for invalid orders(null, unknown, etc)

SELECT
	status, COUNT(*) AS order_count FROM orders
	GROUP BY status ORDER BY order_count DESC;

--Now we filter the invalid orders
SELECT *
	FROM orders WHERE status NOT IN ('completed', 'cancelled', 'returned')
	OR status IS NULL
	OR TRIM(status) ='';

--1.3 We check for error pricing by removing items with negative unit price
SELECT * FROM products WHERE price <= 0;

--Order items with invalid prices
SELECT 
	oi.item_id,
	oi.order_id,
	p.name AS product_name,
	oi.unit_price,
	oi.quantity FROM order_items oi
	JOIN products p ON oi.product_id = p.product_id
	WHERE oi.unit_price <=0
	ORDER BY oi.unit_price ASC;

--1.4 Inactive Customers(customers tht did not make a purchase)
SELECT 
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email,
	c.signup_date
	FROM customers c
	LEFT JOIN orders o ON c.customer_id = o.customer_id
	WHERE o.order_id IS NULL 
	ORDER BY c.signup_date DESC;

--Now, we count the inactive customers
SELECT COUNT(*) AS nerver_ordered FROM customers c
	LEFT JOIN orders o ON c.customer_id =o.customer_id
	WHERE o.order_id IS NULL;

--Phase 2 : Business Analysis and SQL Querries
--Onward we are going to be focusing only on completed orders with items that have a valid price(price >0)
-- 2.1 Now we look at monthly revenue base on completed orders with valid prices
SELECT 
	TO_CHAR(o.order_date, 'YYYY-MM') AS month,
	COUNT(DISTINCT o.order_id) AS total_orders,
	ROUND(SUM(oi.quantity *oi.unit_price), 2) AS revenue
	FROM orders o
	JOIN order_items oi ON o.order_id = oi.order_id
	WHERE o.status ='completed' AND oi.unit_price > 0
	GROUP BY month ORDER BY month;

--2.2 Average spent per order(ie AVerage order value)
SELECT 
	ROUND(AVG(order_total), 2) AS avg_order_value
	FROM (
	SELECT
		o.order_id,
		SUM(oi.quantity * oi.unit_price) AS order_total
		FROM orders o
		JOIN order_items oi ON o.order_id =oi.order_id
		WHERE status = 'completed'
		AND oi.unit_price > 0
		GROUP BY o.order_id
	)order_totals;

--2.3 Break down average order value by country

SELECT
    c.country,
    ROUND(AVG(order_total), 2) AS avg_order_value,
    COUNT(DISTINCT o.order_id)  AS total_orders
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
	JOIN (
	    SELECT order_id,
	           SUM(quantity * unit_price) AS order_total
	    FROM order_items
	    WHERE unit_price > 0
	    GROUP BY order_id
	) totals ON o.order_id = totals.order_id
	WHERE o.status = 'completed'
	GROUP BY c.country
	ORDER BY avg_order_value DESC;

-- We look at the revenue by product category
SELECT
    p.category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
	    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p  ON oi.product_id = p.product_id
JOIN orders o    ON oi.order_id   = o.order_id
WHERE o.status = 'completed'
  AND oi.unit_price > 0
GROUP BY p.category
ORDER BY total_revenue DESC;

--2.4 Top 10 customers by lifetime
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.country,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS lifetime_value
	FROM customers c
	JOIN orders o ON c.customer_id  = o.customer_id
	JOIN order_items oi ON o.order_id = oi.order_id
	WHERE o.status = 'completed'
	  AND oi.unit_price > 0
	GROUP BY c.customer_id
	ORDER BY lifetime_value DESC
	LIMIT 10;

-- 2.5 Overall return & cancellation rate
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'returned'   THEN 1 ELSE 0 END) AS returned,
    SUM(CASE WHEN status = 'cancelled'  THEN 1 ELSE 0 END) AS cancelled,
    ROUND(100.0 * SUM(CASE WHEN status IN ('returned','cancelled') THEN 1 ELSE 0 END)
          / COUNT(*), 2) AS pct_not_completed
FROM orders
WHERE status IN ('completed','returned','cancelled');

-- Return rate by product category
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(CASE WHEN o.status = 'returned' THEN 1 ELSE 0 END) AS returned,
    ROUND(100.0 * SUM(CASE WHEN o.status = 'returned' THEN 1 ELSE 0 END)
          / COUNT(DISTINCT o.order_id), 2) AS return_rate_pct
FROM orders o
JOIN order_items oi ON o.order_id   = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.status IN ('completed','returned','cancelled')
GROUP BY p.category
ORDER BY return_rate_pct DESC;


--Phase 3: Advance SQL and Depper insights

-- 3.1 Customers at churn risk (no order in 90+ days)
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    MAX(o.order_date) AS last_order_date,
    DATE '2023-12-31' - MAX(o.order_date) AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING DATE '2023-12-31' - MAX(o.order_date) >= 90
ORDER BY days_since_last_order DESC;

-- 3.2 Month-over-month revenue growth
WITH monthly AS (
    SELECT
        TO_CHAR(o.order_date, 'YYYY-MM') AS month,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
      AND oi.unit_price > 0
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month), 2
    ) AS growth_pct
FROM monthly
ORDER BY month;

-- 3.3 Top 10 products by revenue
SELECT
    p.product_id,
    p.name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o   ON oi.order_id   = o.order_id
WHERE o.status = 'completed'
  AND oi.unit_price > 0
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 3.4 Products with high stock but low sales volume
SELECT
    p.product_id,
    p.name,
    p.category,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0) AS units_sold
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id  = o.order_id
    AND o.status = 'completed'
    AND oi.unit_price > 0
GROUP BY p.product_id
HAVING p.stock_quantity > 100
   AND COALESCE(SUM(oi.quantity), 0) < 50
ORDER BY p.stock_quantity DESC;









