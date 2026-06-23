CREATE DATABASE ecommerce_olist;
USE ecommerce_olist;

select * from customers;
select * from orders;
select * from order_items;
select * from products;
select * from category_translation;
select * from payments;
select * from reviews;
SHOW TABLES;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM category_translation;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM reviews;
SELECT COUNT(*) FROM sellers;

USE ecommerce_olist;

SELECT 'customers' AS table_name, COUNT(*) AS rows_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers;



/* ------------1st Business problem -------------*/

SELECT
  COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
  ROUND(SUM(CAST(oi.price AS DECIMAL(10,2))), 2) AS product_revenue,
  ROUND(SUM(CAST(oi.price AS DECIMAL(10,2)) + CAST(oi.freight_value AS DECIMAL(10,2))), 2) AS gross_revenue,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  COUNT(*) AS total_items_sold,
  ROUND(SUM(CAST(oi.price AS DECIMAL(10,2))) / COUNT(DISTINCT oi.order_id), 2) AS aov
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
  ON p.product_category_name = ct.product_category_name
GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name)
ORDER BY product_revenue DESC
LIMIT 10;

/* ---------------revenue contribution %----------------*/

WITH category_sales AS (
  SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
    SUM(CAST(oi.price AS DECIMAL(10,2))) AS product_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
  FROM order_items oi
  JOIN products p
    ON oi.product_id = p.product_id
  LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
  GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name)
)

SELECT
  category,
  ROUND(product_revenue, 2) AS product_revenue,
  total_orders,
  ROUND(product_revenue * 100 / SUM(product_revenue) OVER(), 2) AS revenue_share_pct
FROM category_sales
ORDER BY product_revenue DESC
LIMIT 10;

/*-----------repeat customer % -------------------------*/

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS repeat_customer_pct
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t;

/*-------------------------------------------------------------------------*/

DESC orders;
SELECT order_purchase_timestamp
FROM orders
LIMIT 10;

SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders;

/*--------------RFM first task-------------*/

SELECT
    c.customer_unique_id,
    MAX(
        STR_TO_DATE(
            o.order_purchase_timestamp,
            '%Y-%m-%d %H:%i:%s'
        )
    ) AS last_purchase_date,

    COUNT(DISTINCT o.order_id) AS frequency,

    ROUND(
        SUM(
            CAST(oi.price AS DECIMAL(10,2))
        ),
        2
    ) AS monetary
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
LIMIT 10;

/*--------------------------frequency distribution ---------------------*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS frequency
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    frequency,
    COUNT(*) AS customers
FROM customer_orders
GROUP BY frequency
ORDER BY frequency;

/*------------high value customer --------------------*/

WITH customer_revenue AS
(
    SELECT
        c.customer_unique_id,
        ROUND(
            SUM(CAST(oi.price AS DECIMAL(10,2))),
            2
        ) AS total_spend
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    MIN(total_spend) AS min_spend,
    MAX(total_spend) AS max_spend,
    ROUND(AVG(total_spend),2) AS avg_spend
FROM customer_revenue;

/*-------------------------------------------------------------------*/

WITH customer_revenue AS
(
    SELECT
        c.customer_unique_id,
        ROUND(
            SUM(CAST(oi.price AS DECIMAL(10,2))),
            2
        ) AS total_spend
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT *
FROM customer_revenue
ORDER BY total_spend DESC
LIMIT 10;

/*------------------------------------------------------------*/

SELECT
    DATE_FORMAT(
        STR_TO_DATE(order_purchase_timestamp,'%Y-%m-%d %H:%i:%s'),
        '%Y-%m'
    ) AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

/*--------------average delivery time ---------------------*/

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                STR_TO_DATE(order_delivered_customer_date,'%Y-%m-%d %H:%i:%s'),
                STR_TO_DATE(order_purchase_timestamp,'%Y-%m-%d %H:%i:%s')
            )
        ),
        2
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/*---------last delivery kitni thi -----------*/

SELECT
    COUNT(*) AS total_delivered_orders,

    SUM(
        CASE
            WHEN STR_TO_DATE(order_delivered_customer_date,'%Y-%m-%d %H:%i:%s')
                 >
                 STR_TO_DATE(order_estimated_delivery_date,'%Y-%m-%d %H:%i:%s')
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        SUM(
            CASE
                WHEN STR_TO_DATE(order_delivered_customer_date,'%Y-%m-%d %H:%i:%s')
                     >
                     STR_TO_DATE(order_estimated_delivery_date,'%Y-%m-%d %H:%i:%s')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_pct

FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/*----------------order analyssis status--------------------*/

SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS pct
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

/*---------seller performance-------------*/

SELECT
    seller_id,
    ROUND(
        SUM(CAST(price AS DECIMAL(10,2))),
        2
    ) AS revenue,
    COUNT(DISTINCT order_id) AS orders
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;

/*----------------revenue analysis------------------*/

WITH seller_revenue AS
(
    SELECT
        seller_id,
        SUM(CAST(price AS DECIMAL(10,2))) AS revenue
    FROM order_items
    GROUP BY seller_id
)

SELECT
    COUNT(*) AS total_sellers,
    ROUND(SUM(revenue),2) AS total_revenue
FROM seller_revenue;

/*-----------------top 10 revenue------------------------------*/

WITH seller_revenue AS
(
    SELECT
        seller_id,
        SUM(CAST(price AS DECIMAL(10,2))) AS revenue
    FROM order_items
    GROUP BY seller_id
)

SELECT
    ROUND(SUM(revenue),2) AS top10_revenue
FROM
(
    SELECT revenue
    FROM seller_revenue
    ORDER BY revenue DESC
    LIMIT 10
) t;


/*---------------- RFM BASE TABLE --------------------------*/

WITH rfm_base AS
(
    SELECT
        c.customer_unique_id,

        MAX(
            STR_TO_DATE(
                o.order_purchase_timestamp,
                '%Y-%m-%d %H:%i:%s'
            )
        ) AS last_purchase,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(
            SUM(
                CAST(oi.price AS DECIMAL(10,2))
            ),
            2
        ) AS monetary

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,

    DATEDIFF(
        '2018-10-17',
        last_purchase
    ) AS recency,

    frequency,

    monetary

FROM rfm_base;

/*---------------------save as view ---------------------*/

CREATE VIEW rfm_base AS

WITH temp AS
(
    SELECT
        c.customer_unique_id,

        MAX(
            STR_TO_DATE(
                o.order_purchase_timestamp,
                '%Y-%m-%d %H:%i:%s'
            )
        ) AS last_purchase,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(
            SUM(CAST(oi.price AS DECIMAL(10,2))),
            2
        ) AS monetary

    FROM customers c
    JOIN orders o
        ON c.customer_id=o.customer_id
    JOIN order_items oi
        ON o.order_id=oi.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,

    DATEDIFF(
        '2018-10-17',
        last_purchase
    ) AS recency,

    frequency,

    monetary

FROM temp;

/*------------------------------------*/
SELECT
    MIN(recency),
    MAX(recency),
    AVG(recency)
FROM rfm_base;


SELECT
    MIN(frequency),
    MAX(frequency),
    AVG(frequency)
FROM rfm_base;


SELECT
    MIN(monetary),
    MAX(monetary),
    AVG(monetary)
FROM rfm_base;


/*-----------revenue by toop 20% csutomer---------*/

WITH ranked_customers AS
(
    SELECT
        customer_unique_id,
        monetary,

        NTILE(5) OVER(
            ORDER BY monetary DESC
        ) AS monetary_group

    FROM rfm_base
)

SELECT
    monetary_group,
    COUNT(*) AS customers,
    ROUND(SUM(monetary),2) AS revenue
FROM ranked_customers
GROUP BY monetary_group
ORDER BY monetary_group;

