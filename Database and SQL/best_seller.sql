SELECT
    p.product_name,
    SUM(p.price * od.quantity) AS total_gmv,
    SUM(od.quantity) AS total_quantity,
    COUNT(DISTINCT o.user_id) AS unique_user_count
FROM ku_order_status ks
JOIN orders o ON ks.order_id = o.order_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE ks.status = 'SUCCESS'
AND ks.delivery_date BETWEEN '2025-07-01' AND '2025-09-30'
GROUP BY p.product_name
ORDER BY total_gmv DESC, total_quantity DESC;
