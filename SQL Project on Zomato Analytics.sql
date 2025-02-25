
------------------CREATING ZOMATO TABLE SCRIPT----------------------

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;



---(Q1) what is total amount each customer spent on zomato ?---


select a.userid, sum(b.price) as total_amt_spent
from sales a inner join product b
on a.product_id = b.product_id
group by a.userid






---(Q2) How many days has each customer visited zomato?---
Select userid, count(distinct created_at ) as distinct_days
from sales
group by userid;






---(Q3) what was the first product purchased by each customers---
SELECT s1.userid, s1.product_id, s1.created_at
FROM sales s1
WHERE s1.created_at = (
    SELECT MIN(s2.created_at) 
    FROM sales s2 
    WHERE s1.userid = s2.userid
);









---(Q4) what is the most purchased item on the menu and  how many times was it purchased by all the customers ---
SELECT product_id, COUNT(*) AS purchase_count
FROM sales
GROUP BY product_id
ORDER BY purchase_count DESC
LIMIT 1;






---(Q5)  which item was most popular for each customer?---
SELECT s1.userid, s1.product_id
FROM sales s1
WHERE s1.product_id = (
    SELECT s2.product_id
    FROM sales s2
    WHERE s1.userid = s2.userid
    GROUP BY s2.product_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);




--- (Q6) Which item was purchased first by customer after they become a member ? ---
SELECT s1.userid, s1.product_id, s1.created_at
FROM sales s1
JOIN goldusers_signup g ON s1.userid = g.user_id
WHERE s1.created_at >= g.gold_signup_date
AND s1.created_at = (
    SELECT MIN(s2.created_at)
    FROM sales s2
    WHERE s1.userid = s2.userid
    AND s2.created_at >= g.gold_signup_date
);






--- (Q7) Which item was purchased just before customer became a member? ---
SELECT s1.userid, s1.product_id, s1.created_at
FROM sales s1
JOIN goldusers_signup g ON s1.userid = g.user_id
WHERE s1.created_at < g.gold_signup_date
AND s1.created_at = (
    SELECT MAX(s2.created_at)
    FROM sales s2
    WHERE s1.userid = s2.userid
    AND s2.created_at < g.gold_signup_date
);








---(Q8) what is total orders and amount spent for each member before they become a member ?---
SELECT s.userid, COUNT(*) AS total_orders, SUM(p.price) AS total_spent
FROM sales s
JOIN product p USING (product_id)
JOIN goldusers_signup g ON s.userid = g.user_id
WHERE s.created_at < g.gold_signup_date
GROUP BY s.userid;




---(Q9)Rank all the transactions of the customers---
SELECT s1.userid, s1.product_id, s1.created_at, 
       (SELECT COUNT(*) 
        FROM sales s2 
        WHERE s1.userid = s2.userid 
        AND s2.created_at <= s1.created_at) AS transaction_rank
FROM sales s1
ORDER BY s1.userid, transaction_rank;








 







