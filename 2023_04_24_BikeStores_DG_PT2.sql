SELECT 
	ord.order_id,
	CONCAT(cus.first_name, ' ', cus.last_name) AS customers,
	cus.city,
	cus.state,
	CAST(ord.order_date AS DATE) AS order_date,
	SUM(ite.quantity) AS 'total units',
	SUM(ite.quantity * ite.list_price) AS 'revenue',
	pro.product_name,
	cat.category_name,
	sto.store_name,
	brnd.brand_name,
	CONCAT(rep.first_name, ' ', rep.last_name) AS sales_rep
FROM sales.orders AS ord
JOIN sales.customers AS cus
ON ord.customer_id = cus.customer_id
JOIN sales.order_items AS ite
ON ord.order_id = ite.order_id
JOIN production.products AS pro
ON ite.product_id = pro.product_id
JOIN production.categories AS cat
ON cat.category_id = pro.category_id
JOIN sales.stores as sto
ON ord.store_id = sto.store_id
JOIN sales.staffs AS rep
ON ord.staff_id = rep.staff_id
JOIN production.brands AS brnd
ON pro.brand_id = brnd.brand_id
GROUP BY 
	ord.order_id,
	CONCAT(cus.first_name, ' ', cus.last_name),
	cus.city,
	cus.state,
	ord.order_date,
	pro.product_name,
	category_name,
	sto.store_name,
	brnd.brand_name,
	CONCAT(rep.first_name, ' ', rep.last_name)
ORDER BY 1