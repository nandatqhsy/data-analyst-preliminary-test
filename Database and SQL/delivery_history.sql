SELECT *
FROM ku_order_status
WHERE status = 'SUCCESS'
AND delivery_date BETWEEN '2025-09-01' AND '2025-09-30';

SELECT
    u.user_id,
    u.name,
    ks.delivery_date
FROM ku_order_status ks
JOIN orders o ON ks.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id
WHERE ks.status = 'SUCCESS'
AND ks.delivery_date BETWEEN '2025-09-01' AND '2025-09-30';

SELECT
    u.user_id,
    u.name,
    ks.delivery_date,
    p.product_name,
    od.quantity
FROM ku_order_status ks
JOIN orders o ON ks.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE ks.status = 'SUCCESS'
AND ks.delivery_date BETWEEN '2025-09-01' AND '2025-09-30';

SELECT
    u.user_id,
    u.name,
    ks.delivery_date,
    p.product_name,
    GROUP_CONCAT(c.category_name SEPARATOR ', ') AS product_categories,
    od.quantity
FROM ku_order_status ks
JOIN orders o ON ks.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN product_categories pc ON p.product_id = pc.product_id
JOIN categories c ON pc.category_id = c.category_id
WHERE ks.status = 'SUCCESS'
AND ks.delivery_date BETWEEN '2025-09-01' AND '2025-09-30'
GROUP BY
    u.user_id,
    u.name,
    ks.delivery_date,
    p.product_name,
    od.quantity;

SELECT
    u.user_id,
    u.name,
    ks.delivery_date,
    p.product_name,
    GROUP_CONCAT(c.category_name SEPARATOR ', ') AS product_categories,
    od.quantity,
    a.full_address
FROM ku_order_status ks
JOIN orders o ON ks.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN product_categories pc ON p.product_id = pc.product_id
JOIN categories c ON pc.category_id = c.category_id
JOIN addresses a ON ks.address_id = a.address_id
WHERE ks.status = 'SUCCESS'
AND ks.delivery_date BETWEEN '2025-09-01' AND '2025-09-30'
GROUP BY
    u.user_id,
    u.name,
    ks.delivery_date,
    p.product_name,
    od.quantity,
    a.full_address;

SELECT
    u.user_id,
    u.name AS user_name,
    u.email,
    u.phone,
    ks.delivery_date,
    p.product_name,
    GROUP_CONCAT(DISTINCT c.category_name SEPARATOR ', ') AS product_categories,
    od.quantity,
    a.full_address AS delivery_address,

    SUM(od.quantity) OVER (
        PARTITION BY u.user_id
        ORDER BY ks.delivery_date
    ) AS total

FROM ku_order_status ks
JOIN orders o ON ks.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN product_categories pc ON p.product_id = pc.product_id
JOIN categories c ON pc.category_id = c.category_id
JOIN addresses a ON ks.address_id = a.address_id

WHERE ks.status = 'SUCCESS'
AND ks.delivery_date BETWEEN '2025-09-01' AND '2025-09-30'

GROUP BY
    u.user_id,
    u.name,
    u.email,
    u.phone,
    ks.delivery_date,
    p.product_name,
    od.quantity,
    a.full_address

ORDER BY
    ks.delivery_date,
    u.user_id;
