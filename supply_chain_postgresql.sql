SELECT
    sku,
    product_type,
    stock_levels,
    ROUND(revenue_generated::NUMERIC, 2)   AS revenue_generated,
    lead_times,
    availability,
    CASE
        WHEN stock_levels = 0                THEN 'Out of stock'
        WHEN stock_levels BETWEEN 1 AND 5   THEN 'Critical'
        WHEN stock_levels BETWEEN 6 AND 10  THEN 'High risk'
        WHEN stock_levels BETWEEN 11 AND 20 THEN 'Medium risk'
        ELSE 'Healthy'
    END AS stock_risk_level
FROM supply_chain
WHERE stock_levels < 20
ORDER BY revenue_generated DESC;

SELECT
    product_type,
    COUNT(*)                                                    AS total_skus,
    SUM(CASE WHEN stock_levels < 20 THEN 1 ELSE 0 END)        AS at_risk_skus,
    ROUND(100.0 * SUM(CASE WHEN stock_levels < 20
                      THEN 1 ELSE 0 END) / COUNT(*), 1)        AS risk_percentage,
    ROUND(AVG(stock_levels), 1)                                AS avg_stock,
    ROUND(SUM(revenue_generated)::NUMERIC, 2)                 AS total_revenue
FROM supply_chain
GROUP BY product_type
ORDER BY risk_percentage DESC;

SELECT
    product_type,
    ROUND(SUM(CASE WHEN stock_levels < 20
              THEN revenue_generated ELSE 0 END)::NUMERIC, 2)  AS revenue_at_risk,
    ROUND(SUM(revenue_generated)::NUMERIC, 2)                  AS total_revenue,
    ROUND(100.0 * SUM(CASE WHEN stock_levels < 20
              THEN revenue_generated ELSE 0 END)
          / SUM(revenue_generated), 1)                          AS pct_revenue_at_risk
FROM supply_chain
GROUP BY product_type
ORDER BY revenue_at_risk DESC;

SELECT
    supplier_name,
    COUNT(*)                                                AS total_skus,
    ROUND(AVG(lead_times), 1)                              AS avg_lead_time_days,
    ROUND(AVG(defect_rates)::NUMERIC, 3)                   AS avg_defect_rate,
    ROUND(AVG(manufacturing_costs)::NUMERIC, 2)            AS avg_manufacturing_cost,
    ROUND(AVG(production_volumes))                         AS avg_production_volume,
    ROUND(SUM(revenue_generated)::NUMERIC, 2)              AS total_revenue,
    ROUND(AVG(availability), 1)                            AS avg_availability_pct,
    SUM(CASE WHEN inspection_results = 'Pass'
             THEN 1 ELSE 0 END)                            AS passed_inspections,
    SUM(CASE WHEN inspection_results = 'Fail'
             THEN 1 ELSE 0 END)                            AS failed_inspections
FROM supply_chain
GROUP BY supplier_name
ORDER BY avg_defect_rate ASC;

SELECT
    supplier_name,
    COUNT(*)                                                    AS total_orders,
    SUM(CASE WHEN lead_times <= 15 THEN 1 ELSE 0 END)         AS on_time_deliveries,
    ROUND(100.0 * SUM(CASE WHEN lead_times <= 15
                      THEN 1 ELSE 0 END) / COUNT(*), 1)        AS on_time_rate_pct,
    ROUND(AVG(lead_times), 1)                                  AS avg_lead_time
FROM supply_chain
GROUP BY supplier_name
ORDER BY on_time_rate_pct DESC;

SELECT
    product_type,
    supplier_name,
    ROUND(AVG(defect_rates)::NUMERIC, 3)       AS avg_defect_rate,
    ROUND(AVG(lead_times), 1)                  AS avg_lead_time,
    ROUND(SUM(revenue_generated)::NUMERIC, 2)  AS total_revenue,
    COUNT(*)                                   AS sku_count
FROM supply_chain
GROUP BY product_type, supplier_name
ORDER BY product_type, avg_defect_rate ASC;

SELECT
    shipping_carriers,
    COUNT(*)                                        AS total_shipments,
    ROUND(AVG(shipping_times), 1)                  AS avg_shipping_days,
    ROUND(AVG(shipping_costs)::NUMERIC, 2)         AS avg_shipping_cost,
    ROUND(MIN(shipping_costs)::NUMERIC, 2)         AS min_cost,
    ROUND(MAX(shipping_costs)::NUMERIC, 2)         AS max_cost,
    ROUND((AVG(shipping_costs)
          / NULLIF(AVG(shipping_times), 0))::NUMERIC, 2) AS cost_per_day
FROM supply_chain
GROUP BY shipping_carriers
ORDER BY avg_shipping_cost ASC;

SELECT
    transportation_modes,
    COUNT(*)                                        AS usage_count,
    ROUND(AVG(shipping_times), 1)                  AS avg_shipping_days,
    ROUND(AVG(shipping_costs)::NUMERIC, 2)         AS avg_cost,
    ROUND(AVG(defect_rates)::NUMERIC, 3)           AS avg_defect_rate,
    ROUND(SUM(revenue_generated)::NUMERIC, 2)      AS total_revenue
FROM supply_chain
GROUP BY transportation_modes
ORDER BY avg_cost ASC;

SELECT
    routes,
    COUNT(*)                                        AS shipment_count,
    ROUND(AVG(shipping_times), 1)                  AS avg_days,
    ROUND(AVG(shipping_costs)::NUMERIC, 2)         AS avg_cost,
    ROUND(AVG(costs)::NUMERIC, 2)                  AS avg_total_cost,
    ROUND(SUM(revenue_generated)::NUMERIC, 2)      AS total_revenue
FROM supply_chain
GROUP BY routes
ORDER BY avg_cost ASC;

SELECT
    shipping_carriers,
    routes,
    COUNT(*)                                        AS count,
    ROUND(AVG(shipping_times), 1)                  AS avg_days,
    ROUND(AVG(shipping_costs)::NUMERIC, 2)         AS avg_cost
FROM supply_chain
GROUP BY shipping_carriers, routes
ORDER BY avg_cost ASC;

SELECT
    product_type,
    ROUND(AVG(defect_rates)::NUMERIC, 3)        AS avg_defect_rate,
    ROUND(MIN(defect_rates)::NUMERIC, 3)        AS min_defect_rate,
    ROUND(MAX(defect_rates)::NUMERIC, 3)        AS max_defect_rate,
    COUNT(*)                                    AS sku_count,
    SUM(CASE WHEN inspection_results = 'Fail'
             THEN 1 ELSE 0 END)                AS failed_inspections
FROM supply_chain
GROUP BY product_type
ORDER BY avg_defect_rate DESC;

SELECT
    inspection_results,
    COUNT(*)                                        AS count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*))
          OVER (), 1)                               AS percentage,
    ROUND(AVG(defect_rates)::NUMERIC, 3)           AS avg_defect_rate,
    ROUND(AVG(revenue_generated)::NUMERIC, 2)      AS avg_revenue
FROM supply_chain
GROUP BY inspection_results
ORDER BY count DESC;

SELECT
    sku,
    product_type,
    supplier_name,
    location,
    ROUND(defect_rates::NUMERIC, 3)                AS defect_rate,
    inspection_results,
    ROUND(revenue_generated::NUMERIC, 2)           AS revenue_generated,
    stock_levels
FROM supply_chain
ORDER BY defect_rates DESC
LIMIT 10;

SELECT
    location,
    COUNT(*)                                        AS sku_count,
    ROUND(AVG(defect_rates)::NUMERIC, 3)           AS avg_defect_rate,
    ROUND(AVG(manufacturing_costs)::NUMERIC, 2)    AS avg_mfg_cost,
    ROUND(SUM(revenue_generated)::NUMERIC, 2)      AS total_revenue
FROM supply_chain
GROUP BY location
ORDER BY avg_defect_rate DESC;

SELECT
    COUNT(*)                                                    AS total_skus,
    ROUND(SUM(revenue_generated)::NUMERIC, 2)                  AS total_revenue,
    ROUND(AVG(revenue_generated)::NUMERIC, 2)                  AS avg_revenue_per_sku,
    SUM(number_of_products_sold)                               AS total_units_sold,
    ROUND(AVG(lead_times), 1)                                  AS avg_lead_time_days,
    ROUND(AVG(availability), 1)                                AS avg_availability_pct,
    ROUND(AVG(defect_rates)::NUMERIC, 3)                       AS avg_defect_rate,
    SUM(CASE WHEN stock_levels < 20 THEN 1 ELSE 0 END)        AS stockout_risk_skus,
    ROUND(AVG(shipping_costs)::NUMERIC, 2)                     AS avg_shipping_cost,
    SUM(CASE WHEN inspection_results = 'Fail'
             THEN 1 ELSE 0 END)                                AS total_failed_inspections
FROM supply_chain;
