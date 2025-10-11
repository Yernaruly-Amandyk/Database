DROP TABLE IF EXISTS passengers, booking, luggage, airport CASCADE;
CREATE TABLE passenger (
    passenger_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    birth_date DATE,
    country_of_citizenship VARCHAR(50)
);

CREATE TABLE booking (
    booking_id SERIAL PRIMARY KEY,
    passenger_id INT REFERENCES passenger(passenger_id),
    booking_price DECIMAL(10,2),
    created_at DATE
);

CREATE TABLE luggage (
    luggage_id SERIAL PRIMARY KEY,
    passenger_id INT REFERENCES passenger(passenger_id),
    luggage_weight DECIMAL(5,2)
);

CREATE TABLE airport (
    airport_id SERIAL PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

-- 1

ALTER TABLE passenger
ADD CONSTRAINT chk_passenger_age_min10
CHECK (EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) >= 10);

-- 2

ALTER TABLE booking
ADD CONSTRAINT chk_booking_price_range
CHECK (booking_price >= 0 AND booking_price <= 50000);

-- 3

ALTER TABLE luggage
ADD CONSTRAINT chk_luggage_weight_range
CHECK (luggage_weight BETWEEN 1 AND 23);

-- 4

ALTER TABLE airport
ADD CONSTRAINT chk_airport_name_length
CHECK (LENGTH(airport_name) >= 10);

-- 5

ALTER TABLE passenger
ADD CONSTRAINT uq_passenger_name UNIQUE (first_name, last_name, birth_date);

ALTER TABLE booking
ADD CONSTRAINT uq_booking_unique UNIQUE (passenger_id, created_at);

ALTER TABLE luggage
ADD CONSTRAINT uq_luggage_passenger UNIQUE (passenger_id, luggage_id);

ALTER TABLE airport
ADD CONSTRAINT uq_airport_name UNIQUE (airport_name);

-- 6

ALTER TABLE passenger
ADD CONSTRAINT chk_gender_age_rule
CHECK (
    (gender = 'Male' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) >= 18)
    OR
    (gender = 'Female' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) >= 19)
    OR
    (gender NOT IN ('Male', 'Female')) 
);

-- 7

ALTER TABLE passenger
ADD CONSTRAINT chk_country_age_rule
CHECK (
    (country_of_citizenship = 'Kazakhstan' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) >= 18)
    OR
    (country_of_citizenship = 'France' AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) >= 17)
    OR
    (country_of_citizenship NOT IN ('Kazakhstan', 'France') AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) >= 19)
);

-- 8

ALTER TABLE booking
ADD COLUMN ticket_discount DECIMAL(5,2);

ALTER TABLE booking
ADD CONSTRAINT chk_ticket_discount_rule
CHECK (
    (created_at > DATE '2024-01-01' AND ticket_discount = 5)
    OR
    (created_at < DATE '2024-01-01' AND ticket_discount = 10)
);