/*
  =====================
  PROOF OF CONCEPT ONLY
  =====================
 */
CREATE DATABASE capmetro;

USE capmetro;

-- The path in the LOAD DATA statements should be wherever
--   google_transit.zip is unzipped into
--   (source: https://data.texas.gov/download/r4v4-vz24/application/zip)

/*
  -----
  Stops
  -----
 */

CREATE TABLE stops (
  stop_id SMALLINT UNSIGNED NOT NULL,
  stop_code SMALLINT UNSIGNED NOT NULL,
  stop_name VARCHAR(50),
  stop_desc VARCHAR(100),
  stop_lat DECIMAL(10,8),
  stop_lon DECIMAL(11,8),
  zone_id VARCHAR(50),
  stop_url VARCHAR(100),
  location_type VARCHAR(1),
  parent_station VARCHAR(1),
  stop_timezone VARCHAR(1),
  wheelchair_boarding TINYINT,

  PRIMARY KEY (stop_id)
);

LOAD DATA INFILE '/www/sites/nextbus/stops.txt'
  INTO TABLE stops
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;

ALTER TABLE stops
  DROP zone_id,
  DROP location_type,
  DROP parent_station,
  DROP stop_timezone;

/*
  ------
  Routes
  ------
 */

CREATE TABLE routes (
  route_id SMALLINT UNSIGNED NOT NULL,
  agency_id VARCHAR(1),
  route_short_name SMALLINT UNSIGNED NOT NULL,
  route_long_name VARCHAR(50),
  route_desc VARCHAR(1),
  route_type TINYINT UNSIGNED,
  route_url VARCHAR(255),
  route_color VARCHAR(6),
  route_text_color VARCHAR(6),

  PRIMARY KEY (route_id)
);

LOAD DATA INFILE '/www/sites/nextbus/routes.txt'
  INTO TABLE routes
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;

ALTER TABLE routes
  DROP agency_id,
  DROP route_short_name,
  DROP route_desc,
  DROP route_type,
  DROP route_color,
  DROP route_text_color;

/*
  --------
  Calendar
  --------
 */

CREATE TABLE calendar (
  service_id VARCHAR(5),
  monday TINYINT UNSIGNED,
  tuesday TINYINT UNSIGNED,
  wednesday TINYINT UNSIGNED,
  thursday TINYINT UNSIGNED,
  friday TINYINT UNSIGNED,
  saturday TINYINT UNSIGNED,
  sunday TINYINT UNSIGNED,
  start_date DATE,
  end_date DATE,

  PRIMARY KEY (service_id)
);

LOAD DATA INFILE '/www/sites/nextbus/calendar.txt'
  INTO TABLE calendar
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;

/*
  -----
  Trips
  -----
 */

CREATE TABLE trips (
  route_id SMALLINT UNSIGNED NOT NULL,
  service_id VARCHAR(5),
  trip_id MEDIUMINT UNSIGNED NOT NULL,
  trip_headsign VARCHAR(20),
  trip_short_name VARCHAR(1),
  direction_id TINYINT,
  block_id VARCHAR(8),
  shape_id MEDIUMINT UNSIGNED,
  wheelchair_accessible TINYINT,

  PRIMARY KEY (trip_id),
  FOREIGN KEY (route_id)
    REFERENCES routes (route_id),
  FOREIGN KEY (service_id)
    REFERENCES calendar (service_id)
    ON DELETE CASCADE
);

LOAD DATA INFILE '/www/sites/nextbus/trips.txt'
  INTO TABLE trips
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;

ALTER TABLE trips
  DROP trip_short_name,
  DROP block_id;

/*
  ----------
  Stop Times
  ----------
 */

CREATE TABLE stop_times (
  trip_id MEDIUMINT UNSIGNED NOT NULL,
  arrival_time TIME,
  departure_time TIME,
  stop_id SMALLINT UNSIGNED NOT NULL,
  stop_sequence TINYINT UNSIGNED,
  stop_headsign VARCHAR(1),
  pickup_type VARCHAR(1),
  drop_off_type VARCHAR(1),
  shape_dist_traveled VARCHAR(1),

  FOREIGN KEY (trip_id)
    REFERENCES trips (trip_id),
  FOREIGN KEY (stop_id)
    REFERENCES stops (stop_id)
);

LOAD DATA INFILE '/www/sites/nextbus/stop_times.txt'
  INTO TABLE stop_times
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES;

ALTER TABLE stop_times
  DROP stop_sequence,
  DROP stop_headsign,
  DROP pickup_type,
  DROP drop_off_type,
  DROP shape_dist_traveled;

/*
  --------------------
  Delete old schedules
    (the hacky way)
  --------------------
 */

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM calendar WHERE end_date < CURRENT_DATE();
SET FOREIGN_KEY_CHECKS = 1;

