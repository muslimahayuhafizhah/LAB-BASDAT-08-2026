SET search_path TO classicmodels, public;

SELECT * FROM products;
SELECT * FROM orders;

-- soal 1
SELECT c.contactfirstname, c.customername, o.city, CONCAT(e.firstname,' ', e.lastname) AS "sales_rep_name" 
FROM customers as c
JOIN employees as e
ON c.salesrepemployeenumber = e.employeenumber
JOIN offices as o
ON e.officecode = o.officecode
WHERE c.contactfirstname ILIKE 'a%' AND o.city != 'NYC'
ORDER BY c.customername ASC;

-- soal 2
SELECT c.customername, SUM(p.amount) AS "total_payment", MAX(p.amount) AS "max_single_payment"
FROM customers AS c
JOIN payments AS p
ON c.customernumber = p.customernumber
GROUP BY c.customername
HAVING SUM(p.amount) > 50000
ORDER BY total_payment DESC;

-- soal 3
SELECT c.customername, COUNT(DISTINCT(o.ordernumber)) AS "total_order", ROUND(AVG(od.quantityordered), 2) AS "avg_quantity_per_order"
FROM customers AS c
JOIN orders AS o
ON c.customernumber = o.customernumber
JOIN orderdetails AS od
ON o.ordernumber = od.ordernumber
GROUP BY c.customername
HAVING COUNT(DISTINCT(o.ordernumber)) > 3 AND ROUND(AVG(od.quantityordered), 2) > 35
ORDER BY total_order DESC , avg_quantity_per_order DESC;

-- soal 4
SELECT  p.productline, SUM(od.quantityordered) AS "total_terjual", ROUND(AVG(od.priceeach), 2) AS "ratarata_harga", ROUND(AVG(p.msrp - od.priceeach / p.msrp * 100), 2) AS "avg_discount_percentage" 
FROM products AS p
JOIN orderdetails AS od
ON p.productcode = od.productcode
GROUP BY p.productline
HAVING SUM(od.quantityordered) > 3000 AND AVG(od.priceeach) > 80
ORDER BY total_terjual DESC;

-- soal 5
SELECT c.customername, SUM(od.quantityordered * od.priceeach) AS "total_transaksi", COUNT(DISTINCT(o.ordernumber)) AS "total_shipped_orders", ROUND(AVG(od.priceeach), 2) AS "avg_transaction_per_order"
FROM customers c
JOIN orders o
ON c.customernumber = o.customernumber
JOIN orderdetails od
ON o.ordernumber = od.ordernumber
WHERE o.status = 'Shipped'
GROUP BY c.customernumber, c.customername
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 1
ORDER BY total_transaksi DESC
LIMIT 5;

-- soaal 6
SELECT c.customername, c.city AS "customer_city", ofc.city "office_city", SUM(od.quantityordered) AS "total_unit_terjual", 
ROUND(SUM(od.quantityordered * od.priceeach) / COUNT (DISTINCT o.ordernumber), 2) AS "avg_nilai_perorder"
FROM customers c
INNER JOIN employees e
ON c.salesrepemployeenumber = e.employeenumber
INNER JOIN offices AS ofc
ON e.officecode = ofc.officecode
INNER JOIN orders o
ON c.customernumber = o.customernumber
INNER JOIN orderdetails od
ON o.ordernumber = od.ordernumber
WHERE ofc.territory = 'EMEA'
GROUP BY c.customernumber, c.customername, c.city, ofc.city
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 2
AND SUM(od.quantityordered) > 1000 
AND SUM(od.quantityordered * od.priceeach) / COUNT (DISTINCT o.ordernumber) > 10000
ORDER BY avg_nilai_perorder DESC;




