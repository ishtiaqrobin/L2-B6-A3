# Vehicle Rental System - Database Design & SQL Queries

## 📋 Project Overview

এই প্রজেক্টটি একটি **Vehicle Rental System** এর ডাটাবেস ডিজাইন এবং SQL queries এর সমাধান নিয়ে কাজ করে। এখানে Users, Vehicles এবং Bookings এর মধ্যে সম্পর্ক স্থাপন করে একটি সম্পূর্ণ রেন্টাল সিস্টেম তৈরি করা হয়েছে।

### 🎯 Assignment Objectives

- **ERD Design**: One-to-One, One-to-Many এবং Many-to-One relationships সহ Entity Relationship Diagram তৈরি
- **Database Schema**: Primary Keys এবং Foreign Keys সহ সম্পূর্ণ database schema ডিজাইন
- **SQL Queries**: JOIN, EXISTS, WHERE, GROUP BY এবং HAVING clauses ব্যবহার করে বিভিন্ন queries লেখা

---

## 🗂️ Database Schema

### Tables Overview

এই সিস্টেমে তিনটি প্রধান টেবিল রয়েছে:

1. **Users** - সিস্টেমের ব্যবহারকারীদের তথ্য সংরক্ষণ করে
2. **Vehicles** - ভাড়ার জন্য উপলব্ধ গাড়ির তথ্য সংরক্ষণ করে
3. **Bookings** - ব্যবহারকারী এবং গাড়ির বুকিং তথ্য সংরক্ষণ করে

### 1️⃣ Users Table

```sql
CREATE TYPE user_role AS ENUM('Admin', 'Customer');

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    phone VARCHAR(16) NOT NULL,
    role user_role NOT NULL
);
```

**Fields Explanation:**

- `user_id`: Primary Key, auto-increment
- `email`: Unique constraint যাতে duplicate account তৈরি না হয়
- `role`: ENUM type (Admin/Customer)

### 2️⃣ Vehicles Table

```sql
CREATE TYPE vehicle_type AS ENUM('car', 'bike', 'truck');
CREATE TYPE vehicle_status AS ENUM('available', 'rented', 'maintenance');

CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type vehicle_type NOT NULL,
    model VARCHAR(50) NOT NULL,
    registration_number VARCHAR(10) UNIQUE NOT NULL,
    rental_price DECIMAL(10, 2) NOT NULL,
    status vehicle_status NOT NULL
);
```

**Fields Explanation:**

- `vehicle_id`: Primary Key
- `registration_number`: Unique constraint
- `type`: ENUM type (car/bike/truck)
- `status`: ENUM type (available/rented/maintenance)

### 3️⃣ Bookings Table

```sql
CREATE TYPE booking_status AS ENUM('pending', 'confirmed', 'completed', 'cancelled');

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) NOT NULL,
    vehicle_id INT REFERENCES vehicles(vehicle_id) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status booking_status NOT NULL,
    total_cost DECIMAL(10, 2) NOT NULL
);
```

**Relationships:**

- `user_id`: Foreign Key → users table (Many-to-One)
- `vehicle_id`: Foreign Key → vehicles table (Many-to-One)

---

## 🔗 ERD Relationships

### Relationship Types

1. **One-to-Many**: User → Bookings
   - একজন user একাধিক booking করতে পারে
2. **Many-to-One**: Bookings → Vehicle
   - একাধিক booking একই vehicle এর জন্য হতে পারে
3. **One-to-One (Logical)**: Each Booking
   - প্রতিটি booking ঠিক একজন user এবং একটি vehicle এর সাথে সংযুক্ত

---

## 📝 SQL Queries & Solutions

### Query 1: JOIN - Booking Information with Customer and Vehicle Names

**Requirement:** বুকিং এর তথ্যের সাথে Customer এবং Vehicle এর নাম retrieve করতে হবে।

**SQL Query:**

```sql
SELECT
    b.booking_id,
    u.name AS customer_name,
    v.name AS vehicle_name,
    b.start_date,
    b.end_date,
    b.status
FROM
    bookings AS b
    INNER JOIN users AS u USING (user_id)
    INNER JOIN vehicles AS v USING (vehicle_id);
```

**Explanation:**

- `INNER JOIN` ব্যবহার করে bookings table কে users এবং vehicles table এর সাথে join করা হয়েছে
- `USING (user_id)` এবং `USING (vehicle_id)` দিয়ে common column এর উপর ভিত্তি করে join করা হয়েছে
- `AS` keyword দিয়ে column এর alias তৈরি করা হয়েছে

**Expected Output:**
| booking_id | customer_name | vehicle_name | start_date | end_date | status |
|------------|---------------|--------------|------------|----------|---------|
| 1 | Alice | Honda Civic | 2023-10-01 | 2023-10-05 | completed |
| 2 | Alice | Honda Civic | 2023-11-01 | 2023-11-03 | completed |
| 3 | Charlie | Honda Civic | 2023-12-01 | 2023-12-02 | confirmed |
| 4 | Alice | Toyota Corolla | 2023-12-10 | 2023-12-12 | pending |

---

### Query 2: EXISTS - Find Vehicles Never Booked

**Requirement:** যেসব vehicles কখনো book করা হয়নি সেগুলো খুঁজে বের করতে হবে।

**SQL Query:**

```sql
SELECT
    *
FROM
    vehicles AS v
WHERE
    NOT EXISTS (
        SELECT *
        FROM bookings AS b
        WHERE b.vehicle_id = v.vehicle_id
    );
```

**Explanation:**

- `NOT EXISTS` subquery ব্যবহার করা হয়েছে
- Subquery check করে যে bookings table এ কোনো matching vehicle_id আছে কিনা
- যদি না থাকে তাহলে সেই vehicle return হবে

**Expected Output:**
| vehicle_id | name | type | model | registration_number | rental_price | status |
|------------|------|------|-------|---------------------|--------------|---------|
| 3 | Yamaha R15 | bike | 2023 | GHI-789 | 30 | available |
| 4 | Ford F-150 | truck | 2020 | JKL-012 | 100 | maintenance |

---

### Query 3: WHERE - Available Vehicles of Specific Type

**Requirement:** নির্দিষ্ট type এর (যেমন: cars) সব available vehicles retrieve করতে হবে।

**SQL Query:**

```sql
SELECT
    *
FROM
    vehicles
WHERE
    vehicles.status = 'available'
    AND vehicles.type = 'car';
```

**Explanation:**

- `WHERE` clause এ দুইটি condition দেওয়া হয়েছে
- `AND` operator দিয়ে দুইটি condition একসাথে check করা হয়েছে
- শুধুমাত্র 'available' status এবং 'car' type এর vehicles return হবে

**Expected Output:**
| vehicle_id | name | type | model | registration_number | rental_price | status |
|------------|------|------|-------|---------------------|--------------|---------|
| 1 | Toyota Corolla | car | 2022 | ABC-123 | 50 | available |

---

### Query 4: GROUP BY and HAVING - Vehicles with More Than 2 Bookings

**Requirement:** প্রতিটি vehicle এর জন্য মোট bookings সংখ্যা বের করতে হবে এবং শুধুমাত্র সেই vehicles দেখাতে হবে যাদের 2 এর বেশি bookings আছে।

**SQL Query:**

```sql
SELECT
    v.name AS vehicle_name,
    COUNT(*) AS total_bookings
FROM
    bookings AS b
    INNER JOIN vehicles AS v USING (vehicle_id)
GROUP BY
    v.name
HAVING
    COUNT(*) > 2;
```

**Explanation:**

- `INNER JOIN` দিয়ে bookings এবং vehicles table join করা হয়েছে
- `GROUP BY` দিয়ে vehicle name অনুযায়ী group করা হয়েছে
- `COUNT(*)` দিয়ে প্রতিটি group এর মোট bookings count করা হয়েছে
- `HAVING` clause দিয়ে শুধুমাত্র 2 এর বেশি bookings আছে এমন groups filter করা হয়েছে

**Expected Output:**
| vehicle_name | total_bookings |
|--------------|----------------|
| Honda Civic | 3 |

---

## 🎓 Key Concepts Used

### 1. **INNER JOIN**

- দুই বা ততোধিক tables এর মধ্যে matching rows খুঁজে বের করে
- শুধুমাত্র common data return করে

### 2. **NOT EXISTS**

- Subquery ব্যবহার করে check করে যে কোনো row exist করে কিনা
- Performance efficient for checking non-existence

### 3. **WHERE Clause**

- Rows filter করার জন্য ব্যবহৃত হয়
- Grouping এর আগে কাজ করে

### 4. **GROUP BY**

- Rows কে groups এ ভাগ করে
- Aggregate functions (COUNT, SUM, AVG) এর সাথে ব্যবহৃত হয়

### 5. **HAVING Clause**

- Grouped data filter করার জন্য ব্যবহৃত হয়
- WHERE এর মতো কিন্তু groups এর জন্য

---

## 📊 Sample Data

### Users

| user_id | name    | email               | phone      | role     |
| ------- | ------- | ------------------- | ---------- | -------- |
| 1       | Alice   | alice@example.com   | 1234567890 | Customer |
| 2       | Bob     | bob@example.com     | 0987654321 | Admin    |
| 3       | Charlie | charlie@example.com | 1122334455 | Customer |

### Vehicles

| vehicle_id | name           | type  | model | registration_number | rental_price | status      |
| ---------- | -------------- | ----- | ----- | ------------------- | ------------ | ----------- |
| 1          | Toyota Corolla | car   | 2022  | ABC-123             | 50           | available   |
| 2          | Honda Civic    | car   | 2021  | DEF-456             | 60           | rented      |
| 3          | Yamaha R15     | bike  | 2023  | GHI-789             | 30           | available   |
| 4          | Ford F-150     | truck | 2020  | JKL-012             | 100          | maintenance |

### Bookings

| booking_id | user_id | vehicle_id | start_date | end_date   | status    | total_cost |
| ---------- | ------- | ---------- | ---------- | ---------- | --------- | ---------- |
| 1          | 1       | 2          | 2023-10-01 | 2023-10-05 | completed | 240        |
| 2          | 1       | 2          | 2023-11-01 | 2023-11-03 | completed | 120        |
| 3          | 3       | 2          | 2023-12-01 | 2023-12-02 | confirmed | 60         |
| 4          | 1       | 1          | 2023-12-10 | 2023-12-12 | pending   | 100        |

---

## 📁 Project Files

- **[queries.sql](queries.sql)** - সম্পূর্ণ database schema এবং সব SQL queries

---

## 🚀 How to Use

1. PostgreSQL database তৈরি করুন
2. `queries.sql` file এর সব queries run করুন
3. প্রতিটি query test করুন

---

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL JOIN Types](https://www.w3schools.com/sql/sql_join.asp)
- [SQL Aggregate Functions](https://www.w3schools.com/sql/sql_count_avg_sum.asp)

---

## ✅ Assignment Completion

- ✅ ERD Design with proper relationships
- ✅ Database schema with Primary and Foreign Keys
- ✅ Query 1: JOIN implementation
- ✅ Query 2: EXISTS implementation
- ✅ Query 3: WHERE clause implementation
- ✅ Query 4: GROUP BY and HAVING implementation

---

**Developed by:** Ishtiaq Robin  
**Course:** Level 2 - Batch 6 - Mission 4  
**Assignment:** Vehicle Rental System Database Design
