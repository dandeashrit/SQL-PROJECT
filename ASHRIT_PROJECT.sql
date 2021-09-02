use orders;
show tables;

# 7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]

SELECT CARTON_ID AS "carton id", C.LEN*C.WIDTH*C.HEIGHT AS "carton_vol"
FROM PRODUCT P, ORDER_ITEMS OI, CARTON C
WHERE OI.PRODUCT_ID = P.PRODUCT_ID
AND C.LEN*C.WIDTH*C.HEIGHT >= (P.LEN*P.WIDTH*P.HEIGHT*OI.PRODUCT_QUANTITY)
AND OI.ORDER_ID = 10006
GROUP BY OI.ORDER_ID;

# 8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order. (11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]

SELECT OC.CUSTOMER_ID AS 'CUSTOMER ID', concat(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME) AS "CUSTOMER FULLNAME", 
OH.ORDER_ID AS 'ORDER ID', sum(OI.PRODUCT_QUANTITY) as "Product Quantity" 
FROM online_customer OC
INNER JOIN order_header OH ON OC.customer_id = OH.customer_id
INNER JOIN order_items OI on OH.order_id = OI.order_id
WHERE OH.ORDER_STATUS = "Shipped" 
group by OH.ORDER_ID
having SUM(OI.PRODUCT_QUANTITY) > 10;

# 9. Write a query to display the order_id, customer id and cutomer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]

SELECT OH.ORDER_ID AS 'ORDER_ID', OC.CUSTOMER_ID, CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME) AS "CUSTOMER FULLNAME", 
OI.PRODUCT_QUANTITY AS "TOTAL QUANTITY OF PRODUCTS SHIPPED"  
FROM ONLINE_CUSTOMER OC 
INNER JOIN ORDER_HEADER OH ON OC.CUSTOMER_ID = OH.CUSTOMER_ID 
INNER JOIN ORDER_ITEMS OI ON OH.ORDER_ID = OI.ORDER_ID 
WHERE OH.ORDER_STATUS = "Shipped"
group by OH.ORDER_ID
HAVING OH.ORDER_ID > 10060;

# 10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]

SELECT PRODUCT_CLASS_DESC AS "PRODUCT CLASS DESCRIPTION", SUM(product_quantity) 'total quantity',
SUM(product_quantity* product_price) 'total value'
FROM PRODUCT P, ADDRESS A,  ONLINE_CUSTOMER OC, ORDER_HEADER OH ,ORDER_ITEMS OI, PRODUCT_CLASS PC
WHERE OC.ADDRESS_ID = A.ADDRESS_ID 
AND OH.CUSTOMER_ID = OC.CUSTOMER_ID 
AND OI.PRODUCT_ID = P.PRODUCT_ID
AND OC.ADDRESS_ID = A.ADDRESS_ID 
AND OI.ORDER_ID = OH.ORDER_ID
AND PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE 
AND A.COUNTRY NOT IN ('INDIA', 'USA')
group by PRODUCT_CLASS_DESC
order by product_quantity DESC limit 1;