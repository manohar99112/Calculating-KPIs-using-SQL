create database marketing_db;
use marketing_db;
select * from marketing;

alter table marketing
modify clicks  float;

alter table marketing
modify revenue  int;

-- Marketing Rate of investment(ROI)
SELECT 
    campaign_name,
   sum(revenue)AS total_revenue,
    round(sum(mark_spent),2) AS total_spent,
    ROUND(((SUM(revenue) - SUM(mark_spent)) / SUM(mark_spent)) * 100, 2) AS ROI
FROM marketing
GROUP BY campaign_name;

-- Click-through Rate(CTR)
SELECT 
    campaign_name,
    SUM(clicks) AS total_clicks,
    SUM(impressions) AS total_impressions,
    ROUND((SUM(clicks) / SUM(impressions)) * 100, 2) AS CTR
FROM marketing
WHERE impressions > 0
GROUP BY campaign_name;

--  Cost Per click
alter table marketing
modify mark_spent float;

select campaign_name, round(sum(mark_spent),2),sum(clicks),
round((sum(mark_spent)/sum(clicks)),2) as CPC
from marketing
where clicks>0
group by campaign_name
order by CPC desc;

-- Cost per lead(CPL)
SELECT mark_spent, leads, round(CAST(mark_spent AS FLOAT) / leads,2)AS CPL FROM marketing
 WHERE leads > 0
 order by CPL desc ;

-- Revenue Per click (RPC)
select revenue,clicks, round(revenue/clicks,2) as RPC from marketing
order by RPC desc;

-- Average Order value
SELECT campaign_name, SUM(revenue) AS total_revenue, 
SUM(orders) AS total_orders, SUM(revenue) / NULLIF(SUM(orders), 0) AS average_order_value 
FROM marketing 
GROUP BY campaign_name;

-- Multi-touch Attribution(MTA)
SELECT campaign_name, SUM(revenue) AS total_revenue, SUM(orders) AS total_orders, 
SUM(revenue) / NULLIF(SUM(orders), 0) AS average_order_value FROM marketing 
GROUP BY campaign_name;

-- Customer segment profitability(CSP)
SELECT category, SUM(revenue) AS total_revenue, 
round(SUM(mark_spent),2) AS total_marketing_spent, 
round(SUM(revenue) - SUM(mark_spent),2) AS profit, 
round((SUM(revenue) - SUM(mark_spent)) * 1.0 / NULLIF(SUM(mark_spent), 0),2) AS roi FROM marketing 
GROUP BY category ORDER BY profit DESC;