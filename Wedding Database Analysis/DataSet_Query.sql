USE Wedding_database;

#Getting the dataset of vendor sustainability and cost efficiency level.
SELECT vendor_sustainable, price_ce 
FROM vendors AS v
JOIN products AS p
ON v.vendor_id = p.vendor_id
LIMIT 1000;

#finding how many sustainable vendors vs not-sustainable
SELECT vendor_sustainable, COUNT(vendor_sustainable)
FROM vendors
GROUP BY vendor_sustainable
LIMIT 2;

#looking for the amount of products from sustainable vendors and the average price index as well as unsustainable ones
SELECT vendor_sustainable, COUNT(vendor_sustainable), AVG(price_ce)
FROM vendors AS v
JOIN products AS p
ON v.vendor_id = p.vendor_id
WHERE price_ce != 0 AND price_ce IS NOT NULL
GROUP BY vendor_sustainable
LIMIT 2; 

#calculating how many sustainable vendors sell products
SELECT COUNT(DISTINCT(v.vendor_id))
FROM vendors AS v
RIGHT JOIN products AS p
ON v.vendor_id = p.vendor_id
WHERE price_ce IS NOT NULL AND price_ce != 0 AND vendor_sustainable = 1
LIMIT 1;

#choosing relevant data and joining the shared tables
SELECT v.vendor_id, product_id, vendor_depart, vendor_name, vendor_location, vendor_sustainable, vendor_rating, price_unit, price_ce
FROM vendors AS v
RIGHT JOIN products AS p
ON v.vendor_id = p.vendor_id
WHERE price_ce IS NOT NULL AND price_ce != 0 #where price is NOT NULL and is not 0
LIMIT 1000; 