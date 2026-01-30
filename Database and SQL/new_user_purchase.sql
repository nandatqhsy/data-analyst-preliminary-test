WITH new_user_orders AS (
    SELECT
        u.user_id,
        u.name AS user_name,
        o.order_id,
        ks.delivery_date
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN ku_order_status ks ON o.order_id = ks.order_id
    WHERE ks.status = 'SUCCESS'
      AND ks.delivery_date BETWEEN u.registration_date
      AND DATE_ADD(u.registration_date, INTERVAL 7 DAY)
)
SELECT
    nuo.user_id,
    nuo.user_name,
    nuo.order_id,
    nuo.delivery_date,
    p.product_name,
    p.price,
    od.quantity
FROM new_user_orders nuo
JOIN order_details od ON nuo.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY nuo.user_id, nuo.delivery_date;
