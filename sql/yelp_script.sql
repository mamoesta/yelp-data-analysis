/* Your basic SELECT * STATEMENT */
SELECT * FROM business
LIMIT 1000;


/* Sorting cities by number of entries*/
SELECT COUNT(*) as ct, city, state FROM business
GROUP BY city
ORDER BY ct DESC;

### Look at table metadata/readme.

/* All the different types of categories */
SELECT Distinct category FROM category;

/* Create a table with the count of companies in each category, sorted in descending order*/
SELECT  COUNT(*) as ct, category FROM category WHERE category LIKE '%auto%'
GROUP BY category  
ORDER BY ct DESC
LIMIT 10;

/* Wildcard search*/
SELECT distinct category FROM category WHERE category LIKE '%auto%';

/* Category averages for automotive */
SELECT c1.category, ROUND(AVG(b1.stars),2) AS avg_stars 
FROM business b1 inner join category c1 on b1.id = c1.business_id
WHERE c1.category IN ('Auto Repair','Auto Parts & Supplies', 'Auto Detailing', 'Auto Glass Services', 'Auto Customization')
GROUP BY category;


/* Create table schema for auto category */
##drop TABLE auto;
CREATE TABLE auto (
	auto_id serial PRIMARY KEY,
	bus_id varchar(255) NOT NULL,
	name VARCHAR(255) NOT NULL,
    cat VARCHAR(155),
    city VARCHAR(155),
    state VARCHAR(155),
    stars float(8,4),
    avg_stars float(8,4),
    review_count int(10),
    is_open int(10),
    diff float (8,4));

/* Filling auto table with data */
INSERT INTO auto (name, bus_id, stars, cat, city,state, review_count,is_open)
SELECT b1.name, b1.id, b1.stars, c1.category, b1.city,b1.state, b1.review_count, b1.is_open
FROM business b1 inner join category c1 on b1.id = c1.business_id
WHERE c1.category IN ('Auto Repair','Auto Parts & Supplies', 'Auto Detailing', 'Auto Glass Services', 'Auto Customization');


/* Strongest peformers in auto, relative to their sub category*/
SELECT auto.name,auto.city,auto.state, auto.review_count, auto.is_open,
combo.avg_stars AS avg_stars, auto.stars, auto.cat, auto.stars - combo.avg_stars as diff
FROM auto INNER JOIN(
SELECT c1.category, ROUND(AVG(b1.stars),2) AS avg_stars 
FROM business b1 inner join category c1 on b1.id = c1.business_id
WHERE category IN ('Auto Repair','Auto Parts & Supplies', 'Auto Detailing', 'Auto Glass Services', 'Auto Customization')
GROUP BY category) as combo ON auto.cat = combo.category
WHERE auto.review_count > 50 AND auto.is_open = 1
ORDER BY diff desc;


/* Top 50 reviewers on Yelp */
SELECT * FROM user
ORDER BY review_count DESC
LIMIT 50;

/* Do top 50 yelp reviewers critique differently than the rest of yelp? */
SELECT ROUND(AVG(average_stars),3) as a_s,
	CASE
		WHEN review_count >= 2650 THEN 'top reviewer'
        else 'not top reviewer'
	END AS top_50
FROM user
GROUP BY top_50;


/* Do elite users have a higher average star rating compared to non-elite users?*/
SELECT  ROUND(AVG(user.average_stars),3) as a_s, 
 CASE
	WHEN elite_years.year IS NOT NULL THEN 'elite'
    ELSE 'not elite'
    END AS elite
 FROM user LEFT JOIN elite_years ON user.id = elite_years.user_id
 GROUP BY elite;
 
