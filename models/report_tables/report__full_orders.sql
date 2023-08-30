WITH
	dist_centers AS(
		SELECT DISTINCT
			order_id
			,COUNT(product_distribution_center_id) AS dist_centers_involved
		FROM {{ source('thelook_ecommerce', 'order_items') }} AS order_items

		LEFT JOIN {{ source('thelook_ecommerce', 'inventory_items') }} AS inventory_items
		ON order_items.inventory_item_id = inventory_items.id

		GROUP BY 1
	)
	,order_totals AS(
		SELECT
			order_id
			,SUM(sale_price) AS total_order_value

		FROM {{ source('thelook_ecommerce', 'order_items') }} AS order_items

		GROUP BY 1
	)

SELECT
  orders.order_id AS order_id
  ,users.id AS user_id
  ,users.first_name AS user_first_name
  ,users.last_name AS user_last_name
  ,CONCAT(users.first_name, ' ', users.last_name) AS user_full_name
  ,users.email AS user_email
  ,users.age AS user_age
  ,users.gender AS user_gender
  ,users.state AS user_state
  ,users.street_address AS user_street_address
  ,users.postal_code AS user_postal_code
  ,users.city AS user_city
  ,users.country AS user_country
  ,users.latitude AS user_latitude
  ,users.longitude AS user_longitude
  ,users.traffic_source AS user_traffic_source
  ,users.created_at AS user_created_at
  ,orders.status AS order_status
  ,orders.gender AS order_gender
  ,orders.created_at AS order_created_at
  ,orders.returned_at AS order_returned_at
  ,orders.shipped_at AS order_shipped_at
  ,orders.delivered_at AS order_delivered_at
  ,orders.num_of_item AS order_num_of_item
  ,ROUND(order_totals.total_order_value, 2) AS total_order_value
  ,dist_centers.dist_centers_involved AS dist_centers_involved

FROM {{ source('thelook_ecommerce', 'orders') }} AS orders

LEFT JOIN {{ source('thelook_ecommerce', 'users') }} AS users
ON orders.user_id = users.id

LEFT JOIN order_totals
USING (order_id)

LEFT JOIN dist_centers
USING (order_id)