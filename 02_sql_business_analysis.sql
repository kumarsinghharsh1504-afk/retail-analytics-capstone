SELECT
    COUNT(*) AS transaction_rows,
    COUNT(DISTINCT invoice) AS total_orders,
    COUNT(DISTINCT customer_id) AS identified_customers,
    ROUND(SUM(line_revenue), 2) AS total_revenue,
    ROUND(AVG(line_revenue), 2) AS average_transaction_value,
    SUM(quantity) AS units_sold,
    MIN(invoice_date) AS first_sale,
    MAX(invoice_date) AS last_sale
FROM public.clean_sales_transactions;
SELECT
    invoice_year,
    COUNT(DISTINCT invoice) AS total_orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM public.clean_sales_transactions
GROUP BY invoice_year
ORDER BY invoice_year;
SELECT
    DATE_TRUNC(
        'month',
        invoice_date
    )::date AS sales_month,
    COUNT(
        DISTINCT invoice
    ) AS total_orders,
    SUM(
        quantity
    ) AS units_sold,
    ROUND(
        SUM(line_revenue),
        2
    ) AS total_revenue,
    ROUND(
        SUM(line_revenue)
        / NULLIF(
            COUNT(DISTINCT invoice),
            0
        ),
        2
    ) AS average_order_value
FROM public.clean_sales_transactions
GROUP BY
    DATE_TRUNC(
        'month',
        invoice_date
    )
ORDER BY
    sales_month;
	WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            invoice_date
        )::date AS sales_month,
        COUNT(
            DISTINCT invoice
        ) AS total_orders,
        SUM(
            quantity
        ) AS units_sold,
        ROUND(
            SUM(line_revenue),
            2
        ) AS total_revenue,
        ROUND(
            SUM(line_revenue)
            / NULLIF(
                COUNT(DISTINCT invoice),
                0
            ),
            2
        ) AS average_order_value
    FROM public.clean_sales_transactions
    GROUP BY
        DATE_TRUNC(
            'month',
            invoice_date
        )
)

SELECT
    sales_month,
    total_orders,
    units_sold,
    total_revenue,
    average_order_value
FROM monthly_sales
ORDER BY
    total_revenue DESC
LIMIT 5;
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            invoice_date
        )::date AS sales_month,
        COUNT(
            DISTINCT invoice
        ) AS total_orders,
        SUM(
            quantity
        ) AS units_sold,
        ROUND(
            SUM(line_revenue),
            2
        ) AS total_revenue,
        ROUND(
            SUM(line_revenue)
            / NULLIF(
                COUNT(DISTINCT invoice),
                0
            ),
            2
        ) AS average_order_value
    FROM public.clean_sales_transactions
    GROUP BY
        DATE_TRUNC(
            'month',
            invoice_date
        )
)

SELECT
    sales_month,
    total_orders,
    units_sold,
    total_revenue,
    average_order_value
FROM monthly_sales
WHERE sales_month NOT IN (
    DATE '2009 12 01',
    DATE '2011 12 01'
)
ORDER BY
    total_revenue ASC
LIMIT 5;
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            invoice_date
        )::date AS sales_month,
        COUNT(
            DISTINCT invoice
        ) AS total_orders,
        SUM(
            quantity
        ) AS units_sold,
        ROUND(
            SUM(line_revenue),
            2
        ) AS total_revenue,
        ROUND(
            SUM(line_revenue)
            / NULLIF(
                COUNT(DISTINCT invoice),
                0
            ),
            2
        ) AS average_order_value
    FROM public.clean_sales_transactions
    GROUP BY
        DATE_TRUNC(
            'month',
            invoice_date
        )
)

SELECT
    sales_month,
    total_orders,
    units_sold,
    total_revenue,
    average_order_value
FROM monthly_sales
ORDER BY
    total_revenue DESC
LIMIT 5;
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            invoice_date
        )::date AS sales_month,
        COUNT(
            DISTINCT invoice
        ) AS total_orders,
        SUM(
            quantity
        ) AS units_sold,
        SUM(
            line_revenue
        ) AS total_revenue
    FROM public.clean_sales_transactions
    GROUP BY
        DATE_TRUNC(
            'month',
            invoice_date
        )
),

monthly_growth AS (
    SELECT
        sales_month,
        total_orders,
        units_sold,
        ROUND(
            total_revenue,
            2
        ) AS total_revenue,
        LAG(
            total_revenue
        ) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    total_orders,
    units_sold,
    total_revenue,
    ROUND(
        (
            total_revenue
            - previous_month_revenue
        )
        / NULLIF(
            previous_month_revenue,
            0
        )
        * 100,
        2
    ) AS monthly_revenue_growth_percent
FROM monthly_growth
ORDER BY sales_month;
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            invoice_date
        )::date AS sales_month,
        SUM(
            line_revenue
        ) AS total_revenue
    FROM public.clean_sales_transactions
    GROUP BY
        DATE_TRUNC(
            'month',
            invoice_date
        )
),

monthly_growth AS (
    SELECT
        sales_month,
        total_revenue,
        LAG(
            total_revenue
        ) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    ROUND(
        total_revenue,
        2
    ) AS total_revenue,
    ROUND(
        (
            total_revenue
            - previous_month_revenue
        )
        / NULLIF(
            previous_month_revenue,
            0
        )
        * 100,
        2
    ) AS monthly_revenue_growth_percent
FROM monthly_growth
WHERE previous_month_revenue IS NOT NULL
ORDER BY monthly_revenue_growth_percent DESC
LIMIT 5;
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            invoice_date
        )::date AS sales_month,
        SUM(
            line_revenue
        ) AS total_revenue
    FROM public.clean_sales_transactions
    GROUP BY
        DATE_TRUNC(
            'month',
            invoice_date
        )
),

monthly_growth AS (
    SELECT
        sales_month,
        total_revenue,
        LAG(
            total_revenue
        ) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    ROUND(
        total_revenue,
        2
    ) AS total_revenue,
    ROUND(
        (
            total_revenue
            - previous_month_revenue
        )
        / NULLIF(
            previous_month_revenue,
            0
        )
        * 100,
        2
    ) AS monthly_revenue_growth_percent
FROM monthly_growth
WHERE
    previous_month_revenue IS NOT NULL
    AND sales_month <> DATE '2011-12-01'
ORDER BY
    monthly_revenue_growth_percent ASC
LIMIT 5;
SELECT
    stock_code,
    MAX(description) AS product_description,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice) AS orders_containing_product,
    ROUND(
        SUM(line_revenue),
        2
    ) AS total_revenue
FROM public.clean_sales_transactions
GROUP BY stock_code
ORDER BY total_revenue DESC
LIMIT 15;
SELECT
    invoice,
    invoice_date,
    customer_id,
    country,
    stock_code,
    description,
    quantity,
    unit_price,
    line_revenue
FROM public.clean_sales_transactions
WHERE stock_code = '23843'
ORDER BY line_revenue DESC;
SELECT
    stock_code,
    MAX(description) AS description,
    COUNT(DISTINCT invoice) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM public.clean_sales_transactions
WHERE
    UPPER(stock_code) IN (
        'M',
        'DOT',
        'POST',
        'D',
        'C2',
        'BANK CHARGES',
        'AMAZONFEE',
        'ADJUST',
        'ADJUST2'
    )
    OR UPPER(description) LIKE '%POSTAGE%'
    OR UPPER(description) LIKE '%BANK CHARGE%'
    OR UPPER(description) LIKE '%AMAZON FEE%'
    OR UPPER(description) LIKE '%ADJUSTMENT%'
GROUP BY stock_code
ORDER BY total_revenue DESC;
SELECT
    stock_code,
    MAX(description) AS product_description,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice) AS orders_containing_product,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM public.clean_sales_transactions
WHERE
    UPPER(stock_code) NOT IN (
        'M',
        'DOT',
        'POST',
        'D',
        'C2',
        'BANK CHARGES',
        'AMAZONFEE',
        'ADJUST',
        'ADJUST2'
    )
    AND UPPER(description) NOT LIKE '%POSTAGE%'
    AND UPPER(description) NOT LIKE '%BANK CHARGE%'
    AND UPPER(description) NOT LIKE '%AMAZON FEE%'
    AND UPPER(description) NOT LIKE '%ADJUSTMENT%'
GROUP BY stock_code
ORDER BY total_revenue DESC
LIMIT 15;
WITH product_performance AS (
    SELECT
        stock_code,
        MAX(description) AS product_description,
        COUNT(DISTINCT invoice) AS total_orders,
        SUM(quantity) AS units_sold,
        SUM(line_revenue) AS total_revenue
    FROM public.clean_sales_transactions
    WHERE
        UPPER(stock_code) NOT IN (
            'M',
            'DOT',
            'POST',
            'D',
            'C2',
            'BANK CHARGES',
            'AMAZONFEE',
            'ADJUST',
            'ADJUST2'
        )
        AND UPPER(description) NOT LIKE '%POSTAGE%'
        AND UPPER(description) NOT LIKE '%BANK CHARGE%'
        AND UPPER(description) NOT LIKE '%AMAZON FEE%'
        AND UPPER(description) NOT LIKE '%ADJUSTMENT%'
    GROUP BY stock_code
)

SELECT
    stock_code,
    product_description,
    total_orders,
    units_sold,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue
        / NULLIF(total_orders, 0),
        2
    ) AS revenue_per_order
FROM product_performance
WHERE total_orders >= 100
ORDER BY total_revenue DESC
LIMIT 15;
WITH product_performance AS (
    SELECT
        stock_code,
        MAX(description) AS product_description,
        COUNT(DISTINCT invoice) AS total_orders,
        SUM(quantity) AS units_sold,
        SUM(line_revenue) AS total_revenue
    FROM public.clean_sales_transactions
    WHERE
        UPPER(stock_code) NOT IN (
            'M',
            'DOT',
            'POST',
            'D',
            'C2',
            'BANK CHARGES',
            'AMAZONFEE',
            'ADJUST',
            'ADJUST2'
        )
    GROUP BY stock_code
)

SELECT
    stock_code,
    product_description,
    total_orders,
    units_sold,
    ROUND(total_revenue, 2) AS total_revenue
FROM product_performance
WHERE
    total_orders <= 5
    AND total_revenue >= 50000
ORDER BY total_revenue DESC;
WITH customer_performance AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS total_orders,
        SUM(quantity) AS units_purchased,
        SUM(line_revenue) AS total_revenue,
        MIN(invoice_date)::date AS first_purchase,
        MAX(invoice_date)::date AS last_purchase
    FROM public.clean_sales_transactions
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_orders,
    units_purchased,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue
        / NULLIF(total_orders, 0),
        2
    ) AS average_order_value,
    first_purchase,
    last_purchase
FROM customer_performance
ORDER BY total_revenue DESC
LIMIT 15;
SELECT
    COUNT(*) AS identified_customer_rows,
    COUNT(DISTINCT customer_id) AS identified_customers,
    ROUND(
        SUM(line_revenue),
        2
    ) AS identified_customer_revenue,
    ROUND(
        SUM(line_revenue)
        / (
            SELECT SUM(line_revenue)
            FROM public.clean_sales_transactions
        )
        * 100,
        2
    ) AS identified_revenue_percent
FROM public.clean_sales_transactions
WHERE customer_id IS NOT NULL;
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(line_revenue) AS total_revenue
    FROM public.clean_sales_transactions
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,
        SUM(total_revenue) OVER () AS identified_revenue
    FROM customer_revenue
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN revenue_rank <= 10
                THEN total_revenue
                ELSE 0
            END
        )
        / MAX(identified_revenue)
        * 100,
        2
    ) AS top_10_customer_share_percent,
    ROUND(
        SUM(
            CASE
                WHEN revenue_rank <= 100
                THEN total_revenue
                ELSE 0
            END
        )
        / MAX(identified_revenue)
        * 100,
        2
    ) AS top_100_customer_share_percent
FROM ranked_customers;
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS total_orders,
        SUM(line_revenue) AS total_revenue
    FROM public.clean_sales_transactions
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        total_orders,
        total_revenue,
        CASE
            WHEN total_orders = 1
                THEN 'One order'
            WHEN total_orders BETWEEN 2 AND 5
                THEN '2 to 5 orders'
            WHEN total_orders BETWEEN 6 AND 10
                THEN '6 to 10 orders'
            ELSE 'More than 10 orders'
        END AS order_frequency_segment
    FROM customer_orders
)

SELECT
    order_frequency_segment,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percent,
    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue,
    ROUND(
        SUM(total_revenue) * 100.0
        / SUM(SUM(total_revenue)) OVER (),
        2
    ) AS revenue_percent,
    ROUND(
        AVG(total_revenue),
        2
    ) AS average_customer_revenue
FROM customer_segments
GROUP BY order_frequency_segment
ORDER BY
    MIN(total_orders);
	WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS total_orders
    FROM public.clean_sales_transactions
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE total_orders = 1
    ) AS one_order_customers,
    COUNT(*) FILTER (
        WHERE total_orders > 1
    ) AS repeat_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE total_orders = 1
        ) * 100.0
        / COUNT(*),
        2
    ) AS one_order_customer_percent,
    ROUND(
        COUNT(*) FILTER (
            WHERE total_orders > 1
        ) * 100.0
        / COUNT(*),
        2
    ) AS repeat_customer_percent
FROM customer_orders;
WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS total_orders,
        ROUND(SUM(line_revenue), 2) AS total_revenue,
        MAX(invoice_date)::date AS last_purchase,
        (
            SELECT
                MAX(invoice_date)::date + 1
            FROM public.clean_sales_transactions
        ) - MAX(invoice_date)::date AS recency_days
    FROM public.clean_sales_transactions
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),

recency_segments AS (
    SELECT
        customer_id,
        total_orders,
        total_revenue,
        last_purchase,
        recency_days,
        CASE
            WHEN recency_days <= 30
                THEN 'Recent'
            WHEN recency_days <= 90
                THEN 'Warm'
            WHEN recency_days <= 180
                THEN 'At risk'
            ELSE 'Inactive'
        END AS recency_segment
    FROM customer_metrics
)

SELECT
    recency_segment,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percent,
    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue,
    ROUND(
        SUM(total_revenue) * 100.0
        / SUM(SUM(total_revenue)) OVER (),
        2
    ) AS revenue_percent,
    ROUND(
        AVG(recency_days),
        2
    ) AS average_recency_days
FROM recency_segments
GROUP BY recency_segment
ORDER BY
    MIN(recency_days);
	CREATE OR REPLACE VIEW customer_rfm_segments AS

WITH customer_metrics AS (
    SELECT
        customer_id,
        MAX(invoice_date)::date AS last_purchase,
        COUNT(DISTINCT invoice) AS total_orders,
        ROUND(
            SUM(line_revenue),
            2
        ) AS total_revenue
    FROM public.clean_sales_transactions
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        last_purchase,
        total_orders,
        total_revenue,
        NTILE(5) OVER (
            ORDER BY last_purchase
        ) AS recency_score,
        NTILE(5) OVER (
            ORDER BY total_orders
        ) AS frequency_score,
        NTILE(5) OVER (
            ORDER BY total_revenue
        ) AS monetary_score
    FROM customer_metrics
)

SELECT
    customer_id,
    last_purchase,
    total_orders,
    total_revenue,
    recency_score,
    frequency_score,
    monetary_score,
    CASE
        WHEN recency_score >= 4
            AND frequency_score >= 4
            AND monetary_score >= 4
            THEN 'Champions'

        WHEN recency_score >= 3
            AND frequency_score >= 3
            AND monetary_score >= 3
            THEN 'Loyal customers'

        WHEN recency_score >= 4
            AND frequency_score <= 2
            THEN 'New or promising'

        WHEN recency_score <= 2
            AND monetary_score >= 4
            THEN 'At risk high value'

        WHEN recency_score <= 2
            AND frequency_score <= 2
            THEN 'Hibernating'

        ELSE 'Needs attention'
    END AS customer_segment
FROM rfm_scores;
SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percent,
    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue,
    ROUND(
        SUM(total_revenue) * 100.0
        / SUM(SUM(total_revenue)) OVER (),
        2
    ) AS revenue_percent,
    ROUND(
        AVG(total_orders),
        2
    ) AS average_orders,
    ROUND(
        AVG(total_revenue),
        2
    ) AS average_customer_revenue
FROM customer_rfm_segments
GROUP BY customer_segment
ORDER BY total_revenue DESC;
WITH country_performance AS (
    SELECT
        country,
        COUNT(DISTINCT invoice) AS total_orders,
        COUNT(DISTINCT customer_id) AS identified_customers,
        SUM(quantity) AS units_sold,
        SUM(line_revenue) AS total_revenue
    FROM public.clean_sales_transactions
    GROUP BY country
)

SELECT
    country,
    total_orders,
    identified_customers,
    units_sold,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue
        / NULLIF(total_orders, 0),
        2
    ) AS average_order_value,
    ROUND(
        total_revenue * 100.0
        / SUM(total_revenue) OVER (),
        2
    ) AS revenue_share_percent
FROM country_performance
ORDER BY total_revenue DESC;
WITH country_performance AS (
    SELECT
        country,
        COUNT(DISTINCT invoice) AS total_orders,
        COUNT(DISTINCT customer_id) AS identified_customers,
        SUM(quantity) AS units_sold,
        SUM(line_revenue) AS total_revenue
    FROM public.clean_sales_transactions
    WHERE country <> 'United Kingdom'
    GROUP BY country
)

SELECT
    country,
    total_orders,
    identified_customers,
    units_sold,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue
        / NULLIF(total_orders, 0),
        2
    ) AS average_order_value
FROM country_performance
ORDER BY total_revenue DESC
LIMIT 15;
CREATE OR REPLACE VIEW public.powerbi_fact_sales AS

SELECT
    invoice,
    invoice_date,
    invoice_date::date AS sales_date,
    stock_code,
    customer_id,
    country,
    quantity,
    unit_price,
    line_revenue,
    invoice_hour,
    source_year,
    CASE
        WHEN UPPER(stock_code) IN (
            'M',
            'DOT',
            'POST',
            'D',
            'C2',
            'BANK CHARGES',
            'AMAZONFEE',
            'ADJUST',
            'ADJUST2'
        )
        OR UPPER(description) LIKE '%POSTAGE%'
        OR UPPER(description) LIKE '%BANK CHARGE%'
        OR UPPER(description) LIKE '%AMAZON FEE%'
        OR UPPER(description) LIKE '%ADJUSTMENT%'
        THEN 'Administrative'
        ELSE 'Merchandise'
    END AS sale_type
FROM public.clean_sales_transactions;
CREATE OR REPLACE VIEW public.powerbi_dim_product AS

WITH latest_product AS (
    SELECT DISTINCT ON (stock_code)
        stock_code,
        description
    FROM public.clean_sales_transactions
    WHERE description IS NOT NULL
    ORDER BY
        stock_code,
        invoice_date DESC
)

SELECT
    stock_code,
    description AS product_description,
    CASE
        WHEN UPPER(stock_code) IN (
            'M',
            'DOT',
            'POST',
            'D',
            'C2',
            'BANK CHARGES',
            'AMAZONFEE',
            'ADJUST',
            'ADJUST2'
        )
        OR UPPER(description) LIKE '%POSTAGE%'
        OR UPPER(description) LIKE '%BANK CHARGE%'
        OR UPPER(description) LIKE '%AMAZON FEE%'
        OR UPPER(description) LIKE '%ADJUSTMENT%'
        THEN 'Administrative'
        ELSE 'Merchandise'
    END AS product_type
FROM latest_product;
CREATE OR REPLACE VIEW public.powerbi_dim_customer AS

WITH customer_metrics AS (
    SELECT
        customer_id,
        MIN(invoice_date)::date AS first_purchase,
        MAX(invoice_date)::date AS last_purchase,
        COUNT(DISTINCT invoice) AS total_orders,
        SUM(quantity) AS units_purchased,
        ROUND(SUM(line_revenue), 2) AS total_revenue,
        ROUND(
            SUM(line_revenue)
            / NULLIF(COUNT(DISTINCT invoice), 0),
            2
        ) AS average_order_value,
        (
            SELECT
                MAX(invoice_date)::date + 1
            FROM public.clean_sales_transactions
        ) - MAX(invoice_date)::date AS recency_days
    FROM public.clean_sales_transactions
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)

SELECT
    metrics.customer_id,
    metrics.first_purchase,
    metrics.last_purchase,
    metrics.total_orders,
    metrics.units_purchased,
    metrics.total_revenue,
    metrics.average_order_value,
    metrics.recency_days,
    segments.recency_score,
    segments.frequency_score,
    segments.monetary_score,
    segments.customer_segment
FROM customer_metrics AS metrics
LEFT JOIN public.customer_rfm_segments AS segments
    ON metrics.customer_id = segments.customer_id;
	CREATE OR REPLACE VIEW public.powerbi_dim_country AS

SELECT DISTINCT
    country,
    CASE
        WHEN country = 'United Kingdom'
        THEN 'United Kingdom'
        ELSE 'International'
    END AS market_scope
FROM public.clean_sales_transactions;
CREATE OR REPLACE VIEW public.powerbi_dim_date AS

SELECT
    calendar_date::date AS date,
    EXTRACT(YEAR FROM calendar_date)::integer AS year,
    EXTRACT(QUARTER FROM calendar_date)::integer AS quarter,
    EXTRACT(MONTH FROM calendar_date)::integer AS month_number,
    TRIM(
        TO_CHAR(calendar_date, 'Month')
    ) AS month_name,
    TO_CHAR(
        calendar_date,
        'YYYYMM'
    ) AS year_month,
    DATE_TRUNC(
        'month',
        calendar_date
    )::date AS month_start,
    EXTRACT(ISODOW FROM calendar_date)::integer AS day_number,
    TRIM(
        TO_CHAR(calendar_date, 'Day')
    ) AS day_name,
    CASE
        WHEN EXTRACT(ISODOW FROM calendar_date) IN (6, 7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type
FROM GENERATE_SERIES(
    (
        SELECT MIN(invoice_date)::date
        FROM public.clean_sales_transactions
    ),
    (
        SELECT MAX(invoice_date)::date
        FROM public.clean_sales_transactions
    ),
    INTERVAL '1 day'
) AS calendar_date;
SELECT
    table_name
FROM information_schema.views
WHERE
    table_schema = 'public'
    AND table_name LIKE 'powerbi_%'
ORDER BY table_name;
SELECT
    'powerbi_fact_sales' AS object_name,
    COUNT(*) AS row_count
FROM public.powerbi_fact_sales

UNION ALL

SELECT
    'powerbi_dim_product',
    COUNT(*)
FROM public.powerbi_dim_product

UNION ALL

SELECT
    'powerbi_dim_customer',
    COUNT(*)
FROM public.powerbi_dim_customer

UNION ALL

SELECT
    'powerbi_dim_country',
    COUNT(*)
FROM public.powerbi_dim_country

UNION ALL

SELECT
    'powerbi_dim_date',
    COUNT(*)
FROM public.powerbi_dim_date;
SELECT
    'powerbi_fact_sales' AS object_name,
    COUNT(*) AS row_count
FROM public.powerbi_fact_sales

UNION ALL

SELECT
    'powerbi_dim_product',
    COUNT(*)
FROM public.powerbi_dim_product

UNION ALL

SELECT
    'powerbi_dim_customer',
    COUNT(*)
FROM public.powerbi_dim_customer

UNION ALL

SELECT
    'powerbi_dim_country',
    COUNT(*)
FROM public.powerbi_dim_country

UNION ALL

SELECT
    'powerbi_dim_date',
    COUNT(*)
FROM public.powerbi_dim_date;