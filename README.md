Vehicle Rental System - Database Design & SQL Queries
Overview & Objectives

This assignment is designed to evaluate your understanding of database table design, ERD relationships and SQL queries. You will work with a simplified Vehicle Rental System database.

By completing this assignment, you will be able to:

• Design an ERD with 1 to 1, 1 to Many and Many to 1 relationships
• Understand primary keys and foreign keys
• Write SQL queries using JOIN, EXISTS and WHERE

Database Design & Business Logic
The system manages:

• Users
• Vehicles
• Bookings

Business Logic - What Your Database Must Handle
Your database design should support these real world scenarios:

Users Table Must Store:

• User role (Admin or Customer)
• Name, email, password, phone number
• Each email must be unique (no duplicate accounts)

Vehicles Table Must Store:

• Vehicle name, type (car/bike/truck), model
• Registration number (must be unique)
• Rental price per day
• Availability status (available/rented/maintenance)

Bookings Table Must Store:

• Which user made the booking (link to Users table)
• Which vehicle was booked (link to Vehicles table)
• Start date and end date of rental
• Booking status (pending/confirmed/completed/cancelled)
• Total cost of the booking

Part 1: ERD Design (Mandatory)

| Note: You must submit your ERD in the submission otherwise you will get 0 marks.

Design an Entity Relationship Diagram (ERD) for the Vehicle Rental System.

Required Tables
You must include the following tables:

• Users
• Vehicles
• Bookings

Relationship Requirements
Your ERD must clearly show:

• One to Many: User → Bookings
• Many to One: Bookings → Vehicle
• One to One (logical): Each booking connects exactly one user and one vehicle

ERD Must Include
• Primary Keys (PK)
• Foreign Keys (FK)
• Relationship cardinality
• Status fields (e.g. booking status, vehicle availability)

Submission Format
You need to submit your ERD as:

• Lucidchart ERD Tool
• Submit a public, shareable ERD link.

Part 2: SQL Queries
Write SQL queries based on your designed schema.

| Check Sample Input/Output: To understand the expected results for each query, please refer to the Sample Query Results (QUERY.md) file.

Query 1: JOIN
Retrieve booking information along with:

• Customer name
• Vehicle name
• Booking status

Concepts used: INNER JOIN

Query 2: EXISTS
Find all vehicles that have never been booked.

Concepts used: NOT EXISTS

Query 3: WHERE
Retrieve all available vehicles of a specific type (e.g. cars).

Concepts used: SELECT, WHERE

Query 4: GROUP BY and HAVING
Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

Concepts used: GROUP BY, HAVING, COUNT

Part 3: Theory Questions (Viva Practice - Progress, Not Perfection)

| Note: Answer the questions in your own words and record them on camera in Bengali or English. Spend about two minutes on each question.

| "This video is a safe space to practice - confidence grows every time you speak."

Question 1
What is a foreign key and why is it important in relational databases?

Question 2
What is the difference between WHERE and HAVING clauses in SQL?

Question 3
What is a primary key and what are its characteristics?

Question 4
What is the difference between INNER JOIN and LEFT JOIN in SQL?
