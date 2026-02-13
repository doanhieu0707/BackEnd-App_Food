-- Create Database
DROP DATABASE IF EXISTS food_app;
CREATE DATABASE food_app;
USE food_app;

-- Table User
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(100)
);

-- Table Restaurant
CREATE TABLE restaurant (
    res_id INT AUTO_INCREMENT PRIMARY KEY,
    res_name VARCHAR(100),
    image VARCHAR(255),
    `desc` VARCHAR(255)
);

-- Table Type Food
CREATE TABLE food_type (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100)
);

-- Table Food
CREATE TABLE food (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    food_name VARCHAR(100),
    image VARCHAR(255),
    price FLOAT,
    `desc` VARCHAR(255),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

-- Table Sub Food
CREATE TABLE sub_food (
    sub_id INT AUTO_INCREMENT PRIMARY KEY,
    sub_name VARCHAR(100),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Table Order
CREATE TABLE `order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(50),
    arr_sub_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Table Like Restaurant
CREATE TABLE like_res (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Table Rate Restaurant
CREATE TABLE rate_res (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);


-- INSERT DATA
INSERT INTO user (full_name, email, password) VALUES
('Nguyen Van A', 'a@gmail.com', '123'),
('Nguyen Van B', 'b@gmail.com', '123'),
('Nguyen Van C', 'c@gmail.com', '123'),
('Nguyen Van D', 'd@gmail.com', '123'),
('Nguyen Van E', 'e@gmail.com', '123'),
('Nguyen Van F', 'f@gmail.com', '123');

INSERT INTO restaurant (res_name, image, `desc`) VALUES
('KFC', 'kfc.jpg', 'Fast food'),
('Lotteria', 'lotteria.jpg', 'Fast food'),
('Pizza Hut', 'pizza.jpg', 'Pizza restaurant');

INSERT INTO food_type (type_name) VALUES
('Chicken'),
('Burger'),
('Pizza');

INSERT INTO food (food_name, image, price, `desc`, type_id) VALUES
('Fried Chicken', 'fc.jpg', 50000, 'Crispy chicken', 1),
('Beef Burger', 'bb.jpg', 45000, 'Delicious burger', 2),
('Seafood Pizza', 'sp.jpg', 80000, 'Tasty pizza', 3);

INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES
('Extra Cheese', 10000, 3),
('Spicy Sauce', 5000, 1),
('Big Size', 20000, 2);

INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id) VALUES
(1,1,2,'ORD001','2'),
(1,2,1,'ORD002','3'),
(2,3,1,'ORD003','1'),
(3,1,3,'ORD004','2'),
(4,2,2,'ORD005','3');

INSERT INTO like_res (user_id, res_id, date_like) VALUES
(1,1,NOW()),
(1,2,NOW()),
(2,1,NOW()),
(3,1,NOW()),
(3,2,NOW()),
(4,3,NOW()),
(5,1,NOW());

INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES
(1,1,5,NOW()),
(2,1,4,NOW()),
(3,2,5,NOW()),
(4,3,3,NOW());


-- 1. 5 người like nhiều nhất
SELECT u.user_id, u.full_name, COUNT(l.res_id) AS total_like
FROM like_res l
JOIN user u ON l.user_id = u.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_like DESC
LIMIT 5;

-- 2. 2 nhà hàng có lượt like nhiều nhất
SELECT r.res_id, r.res_name, COUNT(l.user_id) AS total_like
FROM like_res l
JOIN restaurant r ON l.res_id = r.res_id
GROUP BY r.res_id, r.res_name
ORDER BY total_like DESC
LIMIT 2;

-- 3. Người đặt hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(o.order_id) AS total_order
FROM `order` o
JOIN user u ON o.user_id = u.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_order DESC
LIMIT 1;

-- 4. Người dùng không hoạt động
SELECT u.user_id, u.full_name
FROM user u
LEFT JOIN `order` o ON u.user_id = o.user_id
LEFT JOIN like_res l ON u.user_id = l.user_id
LEFT JOIN rate_res r ON u.user_id = r.user_id
WHERE o.user_id IS NULL
AND l.user_id IS NULL
AND r.user_id IS NULL;
