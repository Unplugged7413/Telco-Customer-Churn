-- ============================================================
-- SECTION 1: OVERALL STATISTICS
-- ============================================================

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS overall_churn_rate,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS revenue_at_risk
FROM customers;


-- ============================================================
-- SECTION 2: CHURN RATE BY SEGMENTS
-- ============================================================

-- Churn rate by Contract Type
SELECT
    Contract,
    COUNT(*) AS customer_count,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate
FROM customers
GROUP BY Contract
ORDER BY churn_rate DESC;

-- Churn rate by Tenure Group
SELECT
    TenureGroup,
    COUNT(*) AS customer_count,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate
FROM customers
GROUP BY TenureGroup
ORDER BY TenureGroup;

-- Churn rate by Payment Method
SELECT
    PaymentMethod,
    COUNT(*) AS customer_count,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- Churn rate by Internet Service
SELECT
    InternetService,
    COUNT(*) AS customer_count,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate
FROM customers
GROUP BY InternetService
ORDER BY churn_rate DESC;


-- ============================================================
-- SECTION 3: REVENUE AT RISK
-- ============================================================

-- Revenue at risk by Contract
SELECT
    Contract,
    COUNT(*) AS customer_count,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS revenue_at_risk,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate
FROM customers
GROUP BY Contract
ORDER BY revenue_at_risk DESC;

-- Revenue at risk by Tenure Group
SELECT
    TenureGroup,
    COUNT(*) AS customer_count,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS revenue_at_risk
FROM customers
GROUP BY TenureGroup
ORDER BY revenue_at_risk DESC;


-- ============================================================
-- SECTION 4: ADVANCED SEGMENTATION
-- ============================================================

-- Churn rate and revenue at risk by Contract + Payment Method
SELECT
    Contract || ' + ' || PaymentMethod AS segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS revenue_at_risk
FROM customers
GROUP BY Contract, PaymentMethod
HAVING customer_count >= 50
ORDER BY revenue_at_risk DESC
LIMIT 15;

-- Churn rate by number of subscribed services
SELECT
    TotalServices,
    COUNT(*) AS customer_count,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate
FROM customers
GROUP BY TotalServices
ORDER BY TotalServices;

-- Churn rate: New vs Existing customers
SELECT
    IsNewCustomer,
    COUNT(*) AS customer_count,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate
FROM customers
GROUP BY IsNewCustomer;


-- ============================================================
-- SECTION 5: TOP RISKY SEGMENTS
-- ============================================================

-- Top segments with highest revenue at risk (Contract + PaymentMethod)
SELECT
    Contract || ' + ' || PaymentMethod AS segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS revenue_at_risk,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS churn_rate
FROM customers
GROUP BY Contract, PaymentMethod
HAVING customer_count >= 30
ORDER BY revenue_at_risk DESC
LIMIT 10;