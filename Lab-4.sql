CREATE TABLE airlines (
    airline_id SERIAL PRIMARY KEY,
    airline_name VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE airports (
    airport_id SERIAL PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(20),
    airline_id INT REFERENCES airlines(airline_id),
    scheduled_arrival_time TIMESTAMP,
    actual_arrival_time TIMESTAMP
);

CREATE TABLE passengers (
    passenger_id SERIAL PRIMARY KEY,
    passenger_name VARCHAR(100),
    birth_date DATE
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    passenger_id INT REFERENCES passengers(passenger_id),
    flight_id INT REFERENCES flights(flight_id),
    price NUMERIC(10,2)
);

INSERT INTO airlines (airline_name, country) VALUES
('Air Kazakhstan', 'Kazakhstan'),
('Air Astana', 'Kazakhstan'),
('Regional Air', 'USA'),
('Sky Wings', 'UK'),
('AeroFly', 'Germany');

INSERT INTO airports (airport_name, city) VALUES
('Almaty International Airport', 'Almaty'),
('Astana Regional Air Hub', 'Astana'),
('New York Regional Airport', 'New York'),
('Heathrow International', 'London');

INSERT INTO passengers (passenger_name, birth_date) VALUES
('Ali Khan', '1998-03-15'),
('Maria Petrova', '1985-07-22'),
('John Smith', '1970-12-05'),
('Aidar Tursyn', '2000-05-10'),
('Samantha Green', '1990-10-02');

INSERT INTO flights (flight_number, airline_id, scheduled_arrival_time, actual_arrival_time) VALUES
('AK101', 1, '2025-10-07 12:00', '2025-10-07 12:45'),
('AK202', 2, '2025-10-07 14:00', '2025-10-07 14:00'),
('RA303', 3, '2025-10-07 16:30', '2025-10-07 17:00'),
('SW404', 4, '2025-10-07 18:00', '2025-10-07 18:20'),
('AF505', 5, '2025-10-07 20:00', '2025-10-07 20:00'),
('AK606', 1, '2025-10-07 10:00', '2025-10-07 10:30');

INSERT INTO tickets (passenger_id, flight_id, price) VALUES
(1, 1, 80),
(2, 2, 250),
(3, 3, 450),
(4, 4, 120),
(5, 5, 320),
(1, 6, 90);

-- 1 
SELECT UPPER(airline_name) AS airline_name_upper
FROM airlines;

-- 2 
SELECT REPLACE(airline_name, 'Air', 'Aero') AS modified_airline_name
FROM airlines;

-- 3 
SELECT flight_number
FROM flights
WHERE airline_id IN (1, 2)
GROUP BY flight_number
HAVING COUNT(DISTINCT airline_id) = 2;

-- 4 
SELECT airport_name
FROM airports
WHERE airport_name ILIKE '%Regional%'
  AND airport_name ILIKE '%Air%';

-- 5 
SELECT 
    passenger_name,
    TO_CHAR(birth_date, 'Month DD, YYYY') AS formatted_birth_date
FROM passengers;

-- 6 
SELECT flight_number
FROM flights
WHERE actual_arrival_time > scheduled_arrival_time;

-- 7 
SELECT 
    passenger_name,
    CASE 
        WHEN AGE(birth_date) BETWEEN INTERVAL '18 years' AND INTERVAL '35 years' THEN 'Young'
        WHEN AGE(birth_date) BETWEEN INTERVAL '36 years' AND INTERVAL '55 years' THEN 'Adult'
        ELSE 'Other'
    END AS age_group
FROM passengers;

-- 8 
SELECT 
    ticket_id,
    price,
    CASE
        WHEN price < 100 THEN 'Cheap'
        WHEN price BETWEEN 100 AND 300 THEN 'Medium'
        ELSE 'Expensive'
    END AS price_category
FROM tickets;

-- 9 
SELECT 
    country,
    COUNT(airline_name) AS total_airlines
FROM airlines
GROUP BY country
ORDER BY total_airlines DESC;

-- 10 
SELECT 
    flight_number,
    scheduled_arrival_time,
    actual_arrival_time,
    (actual_arrival_time - scheduled_arrival_time) AS delay_duration
FROM flights
WHERE actual_arrival_time > scheduled_arrival_time;
