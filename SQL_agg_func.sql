/*Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. This is the average of 2483.16 and 2482.55. This gives the median of 2482.855. This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change the limit. SQL didn't even calculate the median for us. The above used a SUBQUERY, but you could use any method to find the two necessary values, and then you just need the average of them*/
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/*Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.*/
SELECT a.name,o.occurred_at FROM 
accounts a
JOIN orders o
ON a.id=o.account_id
ORDER BY occurred_at
LIMIT 1

/*Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.*/
SELECT a.name,SUM(o.total_amt_usd) 
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name


/*Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.*/
SELECT a.name,w.occurred_at,w.channel
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1


/*Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.*/
SELECT channel, COUNT(channel) c1 FROM web_events
GROUP BY channel
ORDER BY c1

/*Who was the primary contact associated with the earliest web_event?*/
SELECT a.primary_poc,w.occurred_at
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
ORDER BY w.occurred_at
LIMIT 1

/*What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.*/
SELECT a.name,SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
ORDER BY total

/*Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.*/
SELECT COUNT(s.id) s_count,r.name
FROM sales_reps s
JOIN region r
ON s.region_id=r.id
GROUP BY r.name
ORDER By s_count

/*For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.*/
SELECT a.name,AVG(o.standard_qty) standard,AVG(o.gloss_qty) gloss,AVG(o.poster_qty) poster
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name

/*For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.*/
SELECT a.name,SUM(o.standard_amt_usd)/(SUM(standard_qty )+0.05) standard,SUM(o.gloss_amt_usd)/(SUM(gloss_qty )+0.05) gloss,SUM(o.poster_amt_usd)/(SUM(poster_qty )+0.05) poster
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name

/*Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.*/
SELECT w.channel,s.name,COUNT(w.channel) freq
FROM web_events w
JOIN accounts a
ON w.account_id=a.id
JOIN sales_reps s
ON s.id=a.sales_rep_id
GROUP BY w.channel,s.name
ORDER BY freq DESC


/*Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.*/
SELECT r.name,w.channel,COUNT(w.channel) freq
FROM web_events w
JOIN accounts a 
ON w.account_id=a.id
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN region r
ON s.region_id=r.id
GROUP BY r.name,w.channel
ORDER BY freq DESC

/* Use DISTINCT to test if there are any accounts associated with more than one region.
The below two queries have the same number of resulting rows (351), so we know that every account is associated with only one region. If each account was associated with more than one region, the first query should have returned more rows than the second query.*/

SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;
/* AND*/
SELECT DISTINCT id, name
FROM accounts;

/*Have any sales reps worked on more than one account?
Actually all of the sales reps have worked on more than one account. The fewest number of accounts any sales rep works on is 3. There are 50 sales reps, and they all have more than one account. Using DISTINCT in the second query assures that all of the sales reps are accounted for in the first query.
*/
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

/*AND*/
SELECT DISTINCT id, name
FROM sales_reps;

/****************************************** HAVING *****************************************/
/*How many accounts have more than 20 orders?*/

SELECT a.name,COUNT(o.id)
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
HAVING COUNT(o.id)>20
ORDER BY COUNT(o.id) DESC

/* Which account has the most orders? */
SELECT a.name,COUNT(o.id)
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
ORDER BY COUNT(o.id) DESC
LIMIT 1

/* Which accounts spent more than 30,000 usd total across all orders? */
SELECT a.name,SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd)>30000

/* Which accounts spent less than 1,000 usd total across all orders? */
SELECT a.name,SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd)<1000

/* Which account has spent the most with us? */
SELECT a.name,SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC
LIMIT 1

/* Which account has spent the least with us? */
SELECT a.name,SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) ASC
LIMIT 1
/* Which accounts used facebook as a channel to contact customers more than 6 times? */
SELECT a.name,COUNT(w.id)
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
WHERE w.channel='facebook'
GROUP BY a.name
HAVING COUNT(w.id)>6
/* Which account used facebook most as a channel? */

SELECT a.name,COUNT(w.id)
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
WHERE w.channel='facebook'
GROUP BY a.name
ORDER BY COUNT(w.id) DESC

/* Which channel was most frequently used by most accounts? */

SELECT w.channel,COUNT(a.id)
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
GROUP BY w.channel
ORDER BY COUNT(a.id) DESC


