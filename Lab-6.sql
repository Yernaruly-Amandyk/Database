DROP TABLE IF EXISTS baggage_checks, baggage, tickets, bookings, airlines, flights, passengers CASCADE;

CREATE TABLE passengers (
    passenger_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    birth_date DATE
);

CREATE TABLE airlines (
    airline_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(50),
    airline_code VARCHAR(20),
    created_at DATE
);

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(10),
    airline_id INT REFERENCES airlines(airline_id),
    origin_airport VARCHAR(50),
    destination_country VARCHAR(50),
    created_at DATE
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    passenger_id INT REFERENCES passengers(passenger_id),
    flight_id INT REFERENCES flights(flight_id),
    platform VARCHAR(50),
    price NUMERIC(10,2),
    check_result VARCHAR(50),
    created_at DATE
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES bookings(booking_id),
    price NUMERIC(10,2),
    created_at DATE
);

CREATE TABLE baggage (
    baggage_id SERIAL PRIMARY KEY,
    passenger_id INT REFERENCES passengers(passenger_id),
    weight NUMERIC(6,2)
);

CREATE TABLE baggage_checks (
    check_id SERIAL PRIMARY KEY,
    baggage_id INT REFERENCES baggage(baggage_id),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO passengers (first_name, last_name, gender, birth_date) VALUES
('Бауыржан',   'Тлеубеков',   'Male',   '1997-03-22'),
('Жанар',      'Мусабаева',   'Female', '1993-07-11'),
('Асхат',      'Смагулов',    'Male',   '2010-11-30'),
('Мадина',     'Калиева',     'Female', '2006-12-25'),
('Асыл',       'Ибраимов',    'Male',   '1994-05-09'),
('Самат',      'Кулжанов',    'Male',   '1991-02-14'),
('Назгуль',    'Ергалиева',   'Female', '1998-08-08');

INSERT INTO airlines (name, country, airline_code, created_at) VALUES
('Portugal Air',     'Portugal',   'PA22',   '2024-01-10'), 
('Poland Wings',     'Poland',     'PW',     '2024-03-20'), 
('SCAT Airlines',    'Kazakhstan', 'DV123',  '2024-01-15'),
('Turkistan Wings',  'Kazakhstan', 'TW9',    '2024-02-10'),
('EuroAsia Air',     'Kazakhstan', 'EA2025', '2025-04-01'),
('Steppe Air',       'Kazakhstan', 'S1',     '2025-07-20'),
('Nur-Sultan Air',   'Kazakhstan', 'NS9',    '2025-09-20');

INSERT INTO flights (flight_number, airline_id, origin_airport, destination_country, created_at) VALUES
('KZ300', 1, 'Lisbon',        'China',      '2024-06-05'),
('KZ400', 2, 'Warsaw',        'France',     '2024-07-12'),
('KZ500', 3, 'Almaty',        'Kazakhstan', '2024-08-01'),
('KZ600', 4, 'Nur-Sultan',    'China',      '2025-01-15'),
('KZ700', 5, 'Shymkent',      'France',     '2025-02-20'),
('KZ800', 6, 'Astana',        'Portugal',   '2025-03-05'),
('KZ900', 7, 'Almaty',        'Poland',     '2025-04-10');

INSERT INTO bookings (passenger_id, flight_id, platform, price, check_result, created_at) VALUES
(1, 1, 'Web',    250.00, 'Checked', '2024-07-12'),
(2, 1, 'Mobile', 180.00, 'Pending', '2025-02-28'),
(3, 2, 'Agency', 220.00, 'Checked', '2023-06-05'),
(4, 3, 'Web',    120.00, 'Pending', '2025-03-05'),
(5, 4, 'Mobile', 95.50,  'Not Checked', '2025-04-12'),
(6, 5, 'Agency', 310.00, 'Pending', '2024-10-10'),
(7, 6, 'Web',    280.00, 'Checked', '2025-05-01');

INSERT INTO tickets (booking_id, price, created_at) VALUES
(1, 250.00, '2024-07-12'),
(2, 180.00, '2025-02-28'),
(3, 220.00, '2023-06-05'),
(4, 120.00, '2025-03-05'),
(5, 95.50, '2025-04-12'),
(6, 310.00, '2024-10-10'),
(7, 280.00, '2025-05-01');

INSERT INTO baggage (passenger_id, weight) VALUES
(1, 22.00),
(2, 18.50),
(3, 35.70),
(4, 20.00),
(5, 28.10),
(6, 26.00),
(7, 11.50);

INSERT INTO baggage_checks (baggage_id, created_at, updated_at) VALUES
(1, '2023-07-12 16:00:00', '2023-07-12 15:30:00'),
(2, '2025-02-28 11:00:00', '2025-02-28 10:45:00'),
(3, '2023-06-05 18:00:00', '2023-06-05 17:30:00'),
(4, '2025-03-05 10:00:00', '2025-03-05 09:30:00'),
(5, '2025-04-01 09:00:00', '2025-04-01 08:45:00'),
(6, '2024-10-10 14:00:00', '2024-10-10 13:50:00'),
(7, '2025-05-01 15:00:00', '2025-05-01 14:45:00');

-- 1
SELECT f.flight_number, f.origin_airport, f.destination_country, a.name AS airline
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
WHERE a.name = 'SCAT Airlines';

-- 2
SELECT f.flight_number, f.origin_airport AS departure_airport, f.destination_country, a.name AS airline
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id;

-- 3
SELECT a.name
FROM airlines a
LEFT JOIN flights f ON a.airline_id = f.airline_id
    AND f.created_at BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '1 month'
WHERE f.flight_id IS NULL;

-- 4
SELECT p.first_name, p.last_name, b.platform, b.price
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN flights f ON b.flight_id = f.flight_id
WHERE f.flight_number = 'KZ300';

-- 5
SELECT f.flight_number,
       AVG(t.price) AS avg_price,
       SUM(t.price) AS total_price,
       MAX(t.price) AS max_price,
       MIN(t.price) AS min_price
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
JOIN tickets t ON b.booking_id = t.booking_id
GROUP BY f.flight_number;

-- 6
SELECT f.flight_number, f.origin_airport, f.destination_country, a.name AS airline
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
WHERE f.destination_country = 'China';

-- 7
SELECT p.first_name, p.last_name, f.destination_country AS arrival_country
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN flights f ON b.flight_id = f.flight_id
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.birth_date)) < 18;

-- 8
SELECT p.first_name || ' ' || p.last_name AS full_name, 
       CURRENT_TIMESTAMP AS arrival_time
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN flights f ON b.flight_id = f.flight_id;

-- 9
SELECT f.flight_number, a.name AS airline, a.country AS airline_country, f.origin_airport
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
WHERE a.country = 'Kazakhstan'
GROUP BY f.flight_number, a.name, a.country, f.origin_airport;