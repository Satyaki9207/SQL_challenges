/* calculate avgerage number of events per channel*/
SELECT channel,AVG(freq) avg
FROM
(SELECT w.channel,DATE_TRUNC('day',occurred_at) d1,COUNT(*) freq
FROM web_events w
GROUP BY w.channel,d1
)sub
GROUP BY channel
ORDER BY avg DESC

/**/
SELECT 
DATE_TRUNC('month',o.occurred_at) m1,AVG(standard_qty) stan,AVG(poster_qty) poster,AVG(gloss_qty) gloss, SUM(total_amt_usd) tot
FROM orders o
JOIN accounts a
ON o.account_id=a.id
WHERE DATE_TRUNC('month',o.occurred_at)=
	(SELECT DATE_TRUNC('month',MIN(occurred_at)) 
	FROM orders)
GROUP BY m1

/*Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

/*For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?*/
SELECT r.name region,SUM(o.total_amt_usd) usd_total,COUNT(o.id) total_qty
FROM region r
JOIN sales_reps s
On s.region_id=r.id
JOIN accounts a
ON a.sales_rep_id=s.id
JOIN orders o
ON o.account_id=a.id
GROUP BY r.name
ORDER BY usd_total DESC

/*How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?*/
SELECT a.name comp_name,SUM(o.total) tot_qty
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
HAVING SUM(o.total)>
    (SELECT total_qty 
    FROM
        (SELECT a.name n1,SUM(o.standard_qty) std_qty,SUM(total) total_qty 
        FROM accounts a
        JOIN orders o
        ON o.account_id=a.id
        GROUP BY a.name
        ORDER BY std_qty DESC
        LIMIT 1)t1
    )
/*For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?*/
SELECT COUNT(w.id)
FROM web_events w
JOIN accounts a
ON w.account_id=a.id
WHERE a.name=
    (SELECT cust_name FROM
		(SELECT a.name cust_name,SUM(o.total_amt_usd) tot
		FROM accounts a
		JOIN orders o
		ON o.account_id=a.id
		GROUP BY a.name
		ORDER BY tot DESC
		LIMIT 1) t1
	)
/*What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
*/
SELECT AVG(tot) FROM
	(SELECT a.name cust_name,SUM(o.total_amt_usd) tot
	FROM accounts a 
	JOIN orders o
	ON o.account_id=a.id
	GROUP BY a.name 
	ORDER BY tot DESC
	LIMIT 10) t1


/*What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders*/
SELECT AVG(tot) FROM
	(SELECT a.name cust,AVG(o.total_amt_usd) tot
	FROM accounts a
	JOIN orders o
	ON a.id=o.account_id
	GROUP BY a.name
	HAVING AVG(o.total_amt_usd)>
		(SELECT AVG(tot)
		FROM
			(SELECT a.name n1,AVG(o.total_amt_usd) 					tot
				FROM accounts a
				JOIN orders o
				ON o.account_id=a.id
				GROUP BY a.name) t1
			 )
 		)t2


