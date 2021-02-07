SELECT occured_at,account_id,channel
FROM web_events
LIMIT 15

/* Practice Question Using WHERE with Non-Numeric Data
 Filter the accounts table to include the company name, website, 
 and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
*/
SELECT name,website,primary_poc FROM accounts
WHERE name='Exxon Mobil'

/*Create a column that divides the standard_amt_usd by the standard_qty to find the unit price 
for standard paper for each order. Limit the results to the first 10 orders, and include the id 
and account_id fields.*/
SELECT id,account_id,  (standard_amt_usd/standard_qty) AS unit_price
FROM orders
LIMIT 10

/*Write a query that finds the percentage of revenue that comes from poster paper for each order.
 You will need to use only the columns that end with _usd.
  (Try to do this without using the total column.) 
  Display the id and account_id fields also*/
  
  /*Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'. */
SELECT name FROM accounts
WHERE name LIKE 'C%' OR name LIKE 'W%'
AND primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana' 
AND primary_poc NOT LIKE '%eana%'

/*Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.*/
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

/* Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.*/
SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;
/*------------------------------------------------------*/
/*Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

/*Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

/*Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.*/
SELECT r.name region,s.name sales_rep,a.name account
FROM sales_reps s 
JOIN region r 
ON s.region_id=r.id
JOIN accounts a
ON s.id=a.sales_rep_id
WHERE r.name='Midwest' AND s.name LIKE '% K%'
ORDER BY a.name

/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).*/
SELECT r.name region,a.name account,o.total_amt_usd/(o.total+0.01) unit_price
FROM orders o
JOIN accounts a 
ON o.account_id=a.id
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN region r 
ON s.region_id=r.id 
WHERE o.standard_qty>100

/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). */

SELECT r.name region,a.name account,o.total_amt_usd/(o.total+0.01) unit_price
FROM orders o
JOIN accounts a 
ON o.account_id=a.id
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN region r 
ON s.region_id=r.id 
WHERE o.standard_qty>100 AND o.poster_qty>50
ORDER BY unit_price

/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01)*/

SELECT r.name region,a.name account,o.total_amt_usd/(o.total+0.01) unit_price
FROM orders o
JOIN accounts a 
ON o.account_id=a.id
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN region r 
ON s.region_id=r.id 
WHERE o.standard_qty>100 AND o.poster_qty>50
ORDER BY unit_price DESC

/*What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.*/
SELECT DISTINCT a.id, w.channel 
FROM accounts a 
JOIN web_events w 
ON a.id=w.account_id
WHERE a.id=1001

/*Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd*/
SELECT w.occurred_at,a.name,o.total,o.total_amt_usd
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
JOIN orders o 
ON a.id=o.account_id
WHERE w.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
