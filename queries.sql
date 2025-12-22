-- Create users table
-- Create the custom user_role type 
CREATE TYPE
  user_role AS ENUM('Admin', 'Customer');

CREATE TABLE
  users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(150) not null,
    email VARCHAR(150) UNIQUE not null,
    password TEXT not null,
    phone VARCHAR(16) not null,
    role user_role not null
  );

-- Create the custom vehicle_type type
CREATE TYPE
  vehicle_type AS ENUM('car', 'bike', 'truck');

-- Create the custom vehicle_status type 
CREATE TYPE
  vehicle_status AS ENUM('available', 'rented', 'maintenance');

-- Create vehicle table
create table
  vehicles (
    vehicle_id serial primary key,
    name varchar(50) not null,
    type
      vehicle_type not null,
      model varchar(50) not null,
      registration_number varchar(10) unique not null,
      rental_price decimal(10, 2) not null,
      status vehicle_status not null
  );

--  Create the custom booking_status type 
CREATE TYPE
  booking_status AS ENUM('pending', 'confirmed', 'completed', 'cancelled');

-- Create bookings table
create table
  bookings (
    booking_id serial primary key,
    user_id int references users (user_id) not null,
    vehicle_id int references vehicles (vehicle_id) not null,
    start_date date not null,
    end_date date not null,
    status booking_status not null,
    total_cost decimal(10, 2) not null
  );
