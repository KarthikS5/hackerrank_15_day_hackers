CREATE DATABASE hackerrank_15_day_hackers;
USE hackerrank_15_day_hackers;


create table hackers (
hacker_id int, 
name varchar(40)
);

create table submissions (
submission_date date, 
submission_id int, 
hacker_id int, 
score int);


insert into hackers 
values 
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonnie'),
(79722, 'Michael');


insert into submissions values (date_format('2016-03-01', '%y-%m-%d'), 8494,    20703,	 0	);
insert into submissions values (date_format('2016-03-01', '%y-%m-%d'), 22403, 	53473,	 15	);
insert into submissions values (date_format('2016-03-01', '%y-%m-%d'), 23965, 	79722,	 60	);
insert into submissions values (date_format('2016-03-01', '%y-%m-%d'), 30173, 	36396,	 70	);
insert into submissions values (date_format('2016-03-02', '%y-%m-%d'), 34928, 	20703,	 0	);
insert into submissions values (date_format('2016-03-02', '%y-%m-%d'), 38740, 	15758,	 60	);
insert into submissions values (date_format('2016-03-02', '%y-%m-%d'), 42769, 	79722,	 25	);
insert into submissions values (date_format('2016-03-02', '%y-%m-%d'), 44364, 	79722,	 60	);
insert into submissions values (date_format('2016-03-03', '%y-%m-%d'), 45440, 	20703,	 0	);
insert into submissions values (date_format('2016-03-03', '%y-%m-%d'), 49050, 	36396,	 70	);
insert into submissions values (date_format('2016-03-03', '%y-%m-%d'), 50273, 	79722,	 5	);
insert into submissions values (date_format('2016-03-04', '%y-%m-%d'), 50344, 	20703,	 0	);
insert into submissions values (date_format('2016-03-04', '%y-%m-%d'), 51360, 	44065,	 90	);
insert into submissions values (date_format('2016-03-04', '%y-%m-%d'), 54404, 	53473,	 65	);
insert into submissions values (date_format('2016-03-04', '%y-%m-%d'), 61533, 	79722,	 45	);
insert into submissions values (date_format('2016-03-05', '%y-%m-%d'), 72852, 	20703,	 0	);
insert into submissions values (date_format('2016-03-05', '%y-%m-%d'), 74546, 	38289,	 0	);
insert into submissions values (date_format('2016-03-05', '%y-%m-%d'), 76487, 	62529,	 0	);
insert into submissions values (date_format('2016-03-05', '%y-%m-%d'), 82439, 	36396,	 10	);
insert into submissions values (date_format('2016-03-05', '%y-%m-%d'), 90006, 	36396,	 40	);
insert into submissions values (date_format('2016-03-06', '%y-%m-%d'), 90404, 	20703,	 0	);

-- Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest), 
-- and find the hacker_id and name of the hacker who made maximum number of submissions each day. 
-- If more than one such hacker has a maximum number of submissions, print thelowest hacker_id. The query should print this information for each day of the contest, sorted by the date.


-- part one find recursive cte total number of unique hacker_act in each day
with recursive cte as(
SELECT 
    submission_date, hacker_id
FROM
    submissions
WHERE
    submission_date = (SELECT MIN(submission_date) FROM submissions) 
UNION ALL 
SELECT 
    s.submission_date, s.hacker_id
FROM
    submissions s
        INNER JOIN
    cte c ON s.hacker_id = c.hacker_id
WHERE
    s.submission_date = (SELECT MIN(submission_date) FROM submissions
								WHERE submission_date > c.submission_date)
) , 
-- part 2 find the minimum number of hacker present o each day
cte2 as(
SELECT 
    submission_date, COUNT(DISTINCT hacker_id) AS hac_cnt
FROM
    cte
GROUP BY 1
), 
cte3 as(
SELECT 
    submission_date, hacker_id, COUNT(1) AS total
FROM
    submissions
GROUP BY 1 , 2),
cte4 as(
SELECT 
    submission_date, MAX(total) AS max_sub
FROM
    cte3
GROUP BY 1),
cte5 as(
SELECT 
    cte3.submission_date, MIN(hacker_id) AS hacker
FROM
    cte3
        INNER JOIN
    cte4 ON cte3.submission_date = cte4.submission_date
        AND cte3.total = cte4.max_sub
GROUP BY 1),
-- part 3 join with part 1 and part 2 with submission_date
cte6 as (
SELECT 
    cte5.submission_date, hac_cnt, hacker
FROM
    cte2
        LEFT JOIN
    cte5 ON cte2.submission_date = cte5.submission_date)
-- part 4 join with hackers name with hacker_table from part 3 cte6
    
SELECT 
    submission_date, hac_cnt, hacker, name
FROM
    cte6
        INNER JOIN
    hackers ON cte6.hacker = hackers.hacker_id
ORDER BY submission_date;

;

with cte1 as(
SELECT submission_date, hacker_id
   , DENSE_RANK() OVER(ORDER BY submission_date) AS date_rank
   , DENSE_RANK() OVER(PARTITION BY hacker_id ORDER BY submission_date) AS hacker_rank 
FROM submissions ), 
 part_one AS(
SELECT 
    submission_date, COUNT(DISTINCT hacker_id) AS cnt
FROM
    cte1
WHERE
    date_rank = hacker_rank
GROUP BY 1)
 , cte AS(
 SELECT 
    submission_date, hacker_id, COUNT(1) AS hacker_cnt
FROM
    submissions
GROUP BY 1 , 2),
cte2 AS(
SELECT 
    submission_date, MAX(hacker_cnt) AS max_cnt
FROM
    cte
GROUP BY 1
), 
cte4 AS(
SELECT 
    cte2.submission_date, MIN(hacker_id) AS hacker
FROM
    cte
        INNER JOIN
    cte2 ON cte.submission_date = cte2.submission_date
        AND hacker_cnt = max_cnt
GROUP BY 1)
SELECT 
    part_one.submission_date, cnt, hacker, name
FROM
    part_one
        INNER JOIN
    cte4 ON part_one.submission_date = cte4.submission_date
        INNER JOIN
    hackers h ON h.hacker_id = cte4.hacker;
    
