-- Query 1: JOIN
-- Retrieve booking information along with:
-- Concepts used: INNER JOIN
select
  b.booking_id,
  u.name as customer_name,
  v.name as vehicle_name,
  b.start_date,
  b.end_date,
  b.status
from
  bookings as b
  inner join users as u using (user_id)
  inner join vehicles as v using (vehicle_id);

-- Query 2: EXISTS
-- Find all vehicles that have never been booked.
-- Concepts used: NOT EXISTS
select
  *
from
  vehicles as v
where
  not exists (
    select
      *
    from
      bookings as b
    where
      b.vehicle_id = v.vehicle_id
  );

-- Query 3: WHERE
-- Retrieve all available vehicles of a specific type (e.g. cars).
-- Concepts used: SELECT, WHERE
select
  *
from
  vehicles
where
  vehicles.status = 'available'
  and vehicles.type = 'car';

-- Query 4: GROUP BY and HAVING
-- Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
-- Concepts used: GROUP BY, HAVING, COUNT
select
  name,
  count(*)
from
  bookings as b
  inner join vehicles as v using (vehicle_id)
group by
  name
having
  count(*) > 2;