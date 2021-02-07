/*Finding total sales associated with each sales rep*/
WITH t1 AS(
SELECT r.name region,s.name sales_rep,SUM(o.total_amt_usd) total_sales
  FROM region r
  JOIN sales_reps s
  ON r.id=s.region_id
  JOIN accounts a
  ON a.sales_rep_id=s.id
  JOIN orders o
  ON o.account_id=a.id
  GROUP BY r.name,s.name
  ),
/*Finding max sales for each region*/
t2 AS
(SELECT region,MAX(total_sales) sales FROM t1
GROUP BY region)
/* Finding people associated with highest sales*/
SELECT t2.region,t1.sales_rep,t2.sales
FROM t1
JOIN t2
ON t1.total_sales=t2.sales

/*For the region with the largest sales total_amt_usd, how many total orders were placed?*/
SELECT r.name region,SUM(o.total_amt_usd) tot_usd,SUM(o.total) tot_qty
FROM region r
JOIN sales_reps s
ON s.region_id=r.id
JOIN accounts a
ON a.sales_rep_id=s.id
JOIN orders o
ON o.account_id=a.id
GROUP BY r.name
ORDER BY tot_usd DESC
LIMIT 1

/*How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?*/
WITH t1 AS(
SELECT a.name acc,SUM(o.standard_qty) stan_qty,
  SUM(o.total) tot
FROM accounts a
JOIN orders o
ON o.account_id=a.id
GROUP BY a.name
ORDER BY stan_QTY DESC
LIMIT 1),

t2 AS
(SELECT a.name,SUM(o.total)
FROM accounts a
JOIN orders o
ON o.account_id=a.id
GROUP BY a.name
HAVING SUM(o.total)>
(SELECT tot FROM t1)
 )
 SELECT COUNT(*) FROM t2

/*For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?*/
WITH t1 AS
(SELECT a.name cust,SUM(o.total_amt_usd) amt_spent
FROM accounts a
JOIN orders o
ON o.account_id=a.id
GROUP BY a.name
ORDER BY amt_spent DESC
LIMIT 1)

SELECT a.name,w.channel c1,COUNT(w.id) n_events
FROM web_events w
JOIN accounts a
ON w.account_id=a.id
WHERE a.name=(SELECT cust FROM t1)
GROUP BY a.name,w.channel

/*What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?*/
WITH t1 AS
(SELECT a.name acc,SUM(o.total_amt_usd) amt_spent
FROM accounts a
JOIN orders o
ON o.account_id=a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10)

SELECT AVG(amt_spent) FROM t1

/*What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.*/
WITH t1 AS
(SELECT a.name cust,AVG(o.total_amt_usd) average
FROM accounts a
JOIN orders o
ON o.account_id=a.id
GROUP BY a.name
HAVING AVG(o.total_amt_usd)>
(SELECT AVG(total_amt_usd) FROM orders)
 )
 SELECT AVG(average) FROM t1