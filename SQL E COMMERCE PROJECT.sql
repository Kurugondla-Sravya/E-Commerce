USE Olist_store;

# 1 - KPI
#weekday vs weekend (order_purchase_timestamp) Payment statistics

 SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) IN (1, 7) 
        THEN 'weekend' 
        ELSE 'weekday' 
    END AS DayType,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    ROUND(SUM(p.payment_value), 2) AS TotalPayments,
    ROUND(AVG(p.payment_value), 2) AS AveragePayment
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_payments_dataset p 
ON 
    o.order_id = p.order_id
GROUP BY 
    DayType;

# KPI - 2: Number Of Orders with review score 5 and payment type as credit card.

SELECT 
    COUNT(pmt.order_id) AS Total_orders
FROM
    olist_order_payments_dataset pmt
        INNER JOIN
    olist_order_reviews_dataset rev ON pmt.order_id = rev.order_id
WHERE
    rev.review_score = 5
        AND pmt.payment_type = 'credit_card';
        

# KPI -3 :Average number of days taken for order_delivered_customer_date for pet_shop

SELECT 
    p.Product_Category_Name,
    ROUND(AVG(DATEDIFF(Order_Delivered_Customer_Date, Order_Purchase_Timestamp)), 2) AS avg_delivery_time
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_items_dataset i ON i.order_id = o.order_id
JOIN 
    olist_products_dataset p ON p.product_id = i.product_id
WHERE 
    p.Product_Category_Name = 'pet_shop'
    AND o.Order_Delivered_Customer_Date IS NOT NULL;
    
    
#KPI -4 :Average price and payment values from customers of sao paulo city

SELECT 
    ROUND(AVG(i.Price), 2) AS average_price,
    ROUND(AVG(p.Payment_value), 2) AS average_payment
FROM 
    olist_customers_dataset c
JOIN 
    olist_orders_dataset o ON c.Customer_id = o.Customer_id
JOIN 
    olist_order_items_dataset i ON o.Order_id = i.Order_id
JOIN 
    olist_order_payments_dataset p ON o.Order_id = p.Order_id
WHERE 
    customer_city = 'Sao Paulo';
    
#KPI -5 Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT 
    ROUND(AVG(DATEDIFF(Order_Delivered_Customer_Date, Order_Purchase_Timestamp)), 0) AS AvgShippingDays,
    Review_Score
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_reviews_dataset r ON o.Order_id = r.Order_id
WHERE 
    Order_Delivered_Customer_Date IS NOT NULL
    AND Order_Purchase_Timestamp IS NOT NULL
GROUP BY 
    Review_Score;