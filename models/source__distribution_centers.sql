SELECT
	id
	,name
	,latitude
	,longitude

FROM {{ source('thelook_ecommerce', 'distribution_centers') }}w