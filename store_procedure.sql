----------------------------------------------------------------------
-- GetProductCountsAndIDs จะสร้างตารางเพื่อแสดงว่าลูกค้าแต่ละคนซื้อสินค้าแตะละชนิด
-- ไปเป็นจำนวนกี่ชิ้น โดยมีคอลัมน์ดังนี้
-- 1. รหัสลูกค้า (custID)
-- 2. รายการรหัสสินค้าทั้งหมด (1,2,3,..)
----------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductCountsAndIDs`()
BEGIN
    SET SESSION group_concat_max_len = 1000000;

    SET @DynamicSQL = '';

    SELECT GROUP_CONCAT(
        'SUM(CASE WHEN p.productID = ''', productID, ''' THEN od.quantity ELSE 0 END) AS `', productID, '`'
        SEPARATOR ', '
    )
    INTO @DynamicSQL
    FROM (
        SELECT DISTINCT productID FROM product
    ) AS product_ids;

    SET @DynamicSQL = CONCAT('
    SELECT
        c.custID,
        ', @DynamicSQL, '
    FROM
        customer c
    LEFT JOIN
        orders o ON c.custID = o.custID
    LEFT JOIN
        orderdetail od ON o.orderID = od.orderID
    LEFT JOIN
        product p ON od.productID = p.productID
    GROUP BY
        c.custID
    ');

    PREPARE stmt FROM @DynamicSQL;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$


----------------------------------------------------------------------
-- GetProductCountsAndNames จะสร้างตารางเพื่อแสดงว่าลูกค้าแต่ละคนซื้อสินค้าแตะละชนิด
-- ไปเป็นจำนวนกี่ชิ้น โดยมีคอลัมน์ดังนี้
-- 1. รหัสลูกค้า (custID)
-- 2. รายการชื่อสินค้าทั้งหมด (เสื้อแขนยาว,เสื้อแขนสั้น,กางเกงขายาว,...)
----------------------------------------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductCountsAndNames`()
BEGIN
    SET SESSION group_concat_max_len = 1000000;

    SET @DynamicSQL = '';

    SELECT GROUP_CONCAT(
        'SUM(CASE WHEN p.productName = ''', productName, ''' THEN od.quantity ELSE 0 END) AS `', productName, '`'
        SEPARATOR ', '
    )
    INTO @DynamicSQL
    FROM (
        SELECT DISTINCT productName FROM product
    ) AS product_names;

    SET @DynamicSQL = CONCAT('
    SELECT
        c.custID,
        ', @DynamicSQL, '
    FROM
        customer c
    LEFT JOIN
        orders o ON c.custID = o.custID
    LEFT JOIN
        orderdetail od ON o.orderID = od.orderID
    LEFT JOIN
        product p ON od.productID = p.productID
    GROUP BY
        c.custID
    ');

    PREPARE stmt FROM @DynamicSQL;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

----------------------------------------------------------------------
-- GetProductCountsAndIDs จะสร้างและรันคำสั่ง SQL ดังต่อไปนี้
----------------------------------------------------------------------
-- SELECT
-- 	c.custID,
-- 	SUM(CASE WHEN p.productID = '1' THEN od.quantity ELSE 0 END) AS `1`,
-- 	SUM(CASE WHEN p.productID = '2' THEN od.quantity ELSE 0 END) AS `2`,
-- 	SUM(CASE WHEN p.productID = '3' THEN od.quantity ELSE 0 END) AS `3`,
-- 	SUM(CASE WHEN p.productID = '4' THEN od.quantity ELSE 0 END) AS `4`,
-- 	SUM(CASE WHEN p.productID = '5' THEN od.quantity ELSE 0 END) AS `5`,
-- 	SUM(CASE WHEN p.productID = '6' THEN od.quantity ELSE 0 END) AS `6`,
-- 	SUM(CASE WHEN p.productID = '7' THEN od.quantity ELSE 0 END) AS `7`,
-- 	SUM(CASE WHEN p.productID = '8' THEN od.quantity ELSE 0 END) AS `8`,
-- 	SUM(CASE WHEN p.productID = '9' THEN od.quantity ELSE 0 END) AS `9`,
-- 	SUM(CASE WHEN p.productID = '10' THEN od.quantity ELSE 0 END) AS `10`
-- FROM
-- 	customer c
-- LEFT JOIN
-- 	orders o ON c.custID = o.custID
-- LEFT JOIN
-- 	orderdetail od ON o.orderID = od.orderID
-- LEFT JOIN
-- 	product p ON od.productID = p.productID
-- GROUP BY
-- 	c.custID;

----------------------------------------------------------------------
-- GetProductCountsAndNames จะสร้างและรันคำสั่ง SQL ดังต่อไปนี้
----------------------------------------------------------------------
-- SELECT
-- 	c.custID,
-- 	SUM(CASE WHEN p.productName = 'เสื้อแขนยาว' THEN od.quantity ELSE 0 END) AS `เสื้อแขนยาว`, 
-- 	SUM(CASE WHEN p.productName = 'เสื้อแขนสั้น' THEN od.quantity ELSE 0 END) AS `เสื้อแขนสั้น`, 
-- 	SUM(CASE WHEN p.productName = 'กางเกงขายาว' THEN od.quantity ELSE 0 END) AS `กางเกงขายาว`, 
-- 	SUM(CASE WHEN p.productName = 'กางเกงขาสั้น' THEN od.quantity ELSE 0 END) AS `กางเกงขาสั้น`, 
-- 	SUM(CASE WHEN p.productName = 'หมวกแก็บ' THEN od.quantity ELSE 0 END) AS `หมวกแก็บ`, 
-- 	SUM(CASE WHEN p.productName = 'หมวกไหมพรม' THEN od.quantity ELSE 0 END) AS `หมวกไหมพรม`, 
-- 	SUM(CASE WHEN p.productName = 'ร้องเท้าผ้าใบ' THEN od.quantity ELSE 0 END) AS `ร้องเท้าผ้าใบ`, 
-- 	SUM(CASE WHEN p.productName = 'รองเท้าแตะ' THEN od.quantity ELSE 0 END) AS `รองเท้าแตะ`, 
-- 	SUM(CASE WHEN p.productName = 'ถุงเท้ายาว' THEN od.quantity ELSE 0 END) AS `ถุงเท้ายาว`, 
-- 	SUM(CASE WHEN p.productName = 'ถุงเท้าสั้น' THEN od.quantity ELSE 0 END) AS `ถุงเท้าสั้น`
-- FROM
-- 	customer c
-- LEFT JOIN
-- 	orders o ON c.custID = o.custID
-- LEFT JOIN
-- 	orderdetail od ON o.orderID = od.orderID
-- LEFT JOIN
-- 	product p ON od.productID = p.productID
-- GROUP BY
-- 	c.custID;    