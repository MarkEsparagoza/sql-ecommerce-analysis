-- ============================================================
-- E-COMMERCE SALES ANALYSIS
-- Author: Mark Jesson Esparagoza
-- Description: SQL queries answering key business questions
--              using a simulated e-commerce dataset.
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Total Revenue by Product Category
-- Business Question: Which categories drive the most revenue?
-- ------------------------------------------------------------
SELECT
    p.category,
        COUNT(oi.order_item_id)         AS total_items_sold,
            SUM(oi.quantity * oi.unit_price) AS total_revenue,
                ROUND(AVG(oi.unit_price), 2)    AS avg_unit_price
                FROM order_items oi
                JOIN products p ON oi.product_id = p.product_id
                JOIN orders o ON oi.order_id = o.order_id
                WHERE o.status != 'Refunded'
                GROUP BY p.category
                ORDER BY total_revenue DESC;


                -- ------------------------------------------------------------
                -- QUERY 2: Top 10 Customers by Lifetime Value
                -- Business Question: Who are our most valuable customers?
                -- ------------------------------------------------------------
                SELECT
                    c.customer_id,
                        c.name,
                            c.email,
                                COUNT(DISTINCT o.order_id)           AS total_orders,
                                    SUM(oi.quantity * oi.unit_price)     AS lifetime_value,
                                        ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_order_value,
                                            MAX(o.order_date)                    AS last_order_date
                                            FROM customers c
                                            JOIN orders o ON c.customer_id = o.customer_id
                                            JOIN order_items oi ON o.order_id = oi.order_id
                                            WHERE o.status != 'Refunded'
                                            GROUP BY c.customer_id, c.name, c.email
                                            ORDER BY lifetime_value DESC
                                            LIMIT 10;


                                            -- ------------------------------------------------------------
                                            -- QUERY 3: Monthly Revenue Trend
                                            -- Business Question: How has revenue trended month over month?
                                            -- ------------------------------------------------------------
                                            SELECT
                                                DATE_TRUNC('month', o.order_date)    AS month,
                                                    COUNT(DISTINCT o.order_id)           AS total_orders,
                                                        SUM(oi.quantity * oi.unit_price)     AS monthly_revenue,
                                                            ROUND(
                                                                    (SUM(oi.quantity * oi.unit_price) -
                                                                             LAG(SUM(oi.quantity * oi.unit_price)) OVER (ORDER BY DATE_TRUNC('month', o.order_date)))
                                                                                     / NULLIF(LAG(SUM(oi.quantity * oi.unit_price)) OVER (ORDER BY DATE_TRUNC('month', o.order_date)), 0) * 100
                                                                                         , 1) AS mom_growth_pct
                                                                                         FROM orders o
                                                                                         JOIN order_items oi ON o.order_id = oi.order_id
                                                                                         WHERE o.status != 'Refunded'
                                                                                         GROUP BY DATE_TRUNC('month', o.order_date)
                                                                                         ORDER BY month;


                                                                                         -- ------------------------------------------------------------
                                                                                         -- QUERY 4: Products with Highest Refund Rate
                                                                                         -- Business Question: Which products are getting returned most?
                                                                                         -- ------------------------------------------------------------
                                                                                         SELECT
                                                                                             p.product_id,
                                                                                                 p.name           AS product_name,
                                                                                                     p.category,
                                                                                                         COUNT(CASE WHEN o.status = 'Refunded' THEN 1 END) AS refund_count,
                                                                                                             COUNT(oi.order_item_id)                           AS total_sold,
                                                                                                                 ROUND(
                                                                                                                         COUNT(CASE WHEN o.status = 'Refunded' THEN 1 END) * 100.0
                                                                                                                                 / NULLIF(COUNT(oi.order_item_id), 0)
                                                                                                                                     , 1) AS refund_rate_pct
                                                                                                                                     FROM order_items oi
                                                                                                                                     JOIN products p ON oi.product_id = p.product_id
                                                                                                                                     JOIN orders o ON oi.order_id = o.order_id
                                                                                                                                     GROUP BY p.product_id, p.name, p.category
                                                                                                                                     HAVING COUNT(oi.order_item_id) > 5
                                                                                                                                     ORDER BY refund_rate_pct DESC
                                                                                                                                     LIMIT 15;
                                                                                                                                     
                                                                                                                                     
                                                                                                                                     -- ------------------------------------------------------------
                                                                                                                                     -- QUERY 5: Average Order Value by Acquisition Channel
                                                                                                                                     -- Business Question: Which marketing channels bring the
                                                                                                                                     --                    highest-value customers?
                                                                                                                                     -- ------------------------------------------------------------
                                                                                                                                     SELECT
                                                                                                                                         c.acquisition_channel,
                                                                                                                                             COUNT(DISTINCT o.order_id)               AS total_orders,
                                                                                                                                                 ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_order_value,
                                                                                                                                                     SUM(oi.quantity * oi.unit_price)         AS total_revenue
                                                                                                                                                     FROM customers c
                                                                                                                                                     JOIN orders o ON c.customer_id = o.customer_id
                                                                                                                                                     JOIN order_items oi ON o.order_id = oi.order_id
                                                                                                                                                     WHERE o.status != 'Refunded'
                                                                                                                                                     GROUP BY c.acquisition_channel
                                                                                                                                                     ORDER BY avg_order_value DESC;
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     -- ------------------------------------------------------------
                                                                                                                                                     -- QUERY 6: Churn Risk - Customers with No Orders in 90 Days
                                                                                                                                                     -- Business Question: Which customers are at risk of churning?
                                                                                                                                                     -- ------------------------------------------------------------
                                                                                                                                                     SELECT
                                                                                                                                                         c.customer_id,
                                                                                                                                                             c.name,
                                                                                                                                                                 c.email,
                                                                                                                                                                     c.acquisition_channel,
                                                                                                                                                                         MAX(o.order_date)                        AS last_order_date,
                                                                                                                                                                             CURRENT_DATE - MAX(o.order_date)         AS days_since_last_order,
                                                                                                                                                                                 COUNT(DISTINCT o.order_id)               AS total_orders,
                                                                                                                                                                                     SUM(oi.quantity * oi.unit_price)         AS lifetime_value
                                                                                                                                                                                     FROM customers c
                                                                                                                                                                                     JOIN orders o ON c.customer_id = o.customer_id
                                                                                                                                                                                     JOIN order_items oi ON o.order_id = oi.order_id
                                                                                                                                                                                     GROUP BY c.customer_id, c.name, c.email, c.acquisition_channel
                                                                                                                                                                                     HAVING MAX(o.order_date) < CURRENT_DATE - INTERVAL '90 days'
                                                                                                                                                                                     ORDER BY days_since_last_order DESC;
