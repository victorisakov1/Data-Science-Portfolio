-- Dropping the wedding_cost_data if it exists
DROP TABLE IF EXISTS wedding_cost_data;

-- Creating a temporary table for wedding_cost_data
CREATE TEMPORARY TABLE wedding_cost_data (
    category VARCHAR(50),
    vendor_name VARCHAR(50),
    budget_level VARCHAR(50),
    item_name VARCHAR(50),
    price_per_item VARCHAR(50),
    quantity VARCHAR(50),
    subtotal VARCHAR(50)
);

-- Inserting data for the flowers: bouquets
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('flowers',
		'dragonfly floristic',
        'moderate',
        'bouquets',
        199.00,
        3,
        597.00);

-- Inserting data for the flowers: centerpieces
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('flowers',
		'dragonfly floristic',
        'moderate',
        'centerpieces',
        169.00,
        18,
        3042.00);

-- Inserting data for the flowers: flowerbox
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('flowers',
		'dragonfly floristic',
        'moderate',
        'flowerbox',
        215.00,
        2,
        430.00);

-- Inserting data for the flowers: flower arrangement
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('flowers',
		'dragonfly floristic',
        'moderate',
        'flower arrangement',
        239.00,
        2,
        478.00);
        
-- Inserting data for the venue
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('venues',
		'half moon bay golf links',
        'luxury',
        'venue',
        17000.00,
        1,
        17000.00);

-- Inserting data for the music: dj set + equipment
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('music',
		'sf deejays',
        'luxury',
        'dj set + equipment',
        4825.00,
        1,
        4825.00);

-- Inserting data for the jewelry: necklace
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('jewelry',
		'sausolito jewelers',
        'luxury',
        'necklace',
        995.00,
        1,
        995.00);

-- Inserting data for the photo and video
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('photo and video',
		'silver seas',
        'luxury',
        'photo and video',
        5791.00,
        1,
        5791.00);

-- Inserting data for the hair and makeup: bridal makeup
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('hair and makeup',
		'shannon le',
        'luxury',
        'bridal makeup',
        271.64,
        1,
        271.64);

-- Inserting data for the dress and attire: bridal dress
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('dress and attire',
		'casablanca bridal',
        'luxury',
        'bridal dress',
        1750.00,
        1,
        1750.00);

-- Inserting data for the catering: buffet
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('catering',
		'fraiche catering',
        'luxury',
        'buffet',
        150.00,
        85,
        12750.00);

-- Inserting data for the catering: hors d'ouvres
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('catering',
		'fraiche catering',
        'luxury',
        "hors d'ouvres",
        100.00,
        70,
        7000.00);

-- Inserting data for the catering: drinks
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('catering',
		'fraiche catering',
        'luxury',
        'drinks',
        42.00,
        30,
        1260.00);

-- Inserting data for the rental: tables
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'tables',
        20.00,
        9,
        180.00);
        
-- Inserting data for the rental: buffet tables
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'buffet tables',
        12.50,
        6,
        75.00);
        
-- Inserting data for the rental: chair
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'chair',
        8.50,
        85,
        722.50);

-- Inserting data for the rental: plates
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'plates',
        0.75,
        85,
        63.75);

-- Inserting data for the rental: cutlery
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'cutlery',
        1.00,
        85,
        85.00);

-- Inserting data for the rental: glassware
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'glassware',
        2.40,
        85,
        204.00);

-- Inserting data for the rental: waterpitcher
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'waterpitcher',
        5.00,
        27,
        135.00);

-- Inserting data for the rental: serving bowl
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'serving bowl',
        4.00,
        85,
        340.00);

-- Inserting data for the rental: round platter
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'round platter',
        8.00,
        27,
        216.00);
        
-- Inserting data for the rental: rectangle platter
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'rectangle platter',
        9.50,
        27,
        256.50);

-- Inserting data for the rental: cupcake towers
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'cupcake towers',
        50.00,
        2,
        100.00);
        
-- Inserting data for the rental: cake stand
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'cake stand',
        45.00,
        2,
        90.00);

-- Inserting data for the rental: lighting
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'lighting',
        75.00,
        9,
        675.00);

-- Inserting data for the rental: candles
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'candles',
        5.00,
        71,
        355.00);

-- Inserting data for the rental: candle stands
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('rental',
		'all seasons event rental',
        'moderate',
        'candle stands',
        6.00,
        14,
        84.00);

-- Inserting data for the invitations: RSVP
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('invitations',
		'coffee n cream press',
        'luxury',
        'RSVP',
        7.00,
        85,
        595.00);

-- Inserting data for the invitations: invitation
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('invitations',
		'coffee n cream press',
        'luxury',
        'invitation',
        2.85,
        85,
        242.25);

-- Inserting data for the invitations: details
INSERT INTO wedding_cost_data (category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES ('invitations',
		'coffee n cream press',
        'luxury',
        "details",
        3.00,
        85,
        255.00);

-- Final query to select all data from the table
SELECT *
FROM wedding_cost_data;