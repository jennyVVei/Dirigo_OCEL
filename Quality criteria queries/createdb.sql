CREATE DATABASE PortUseCase;
USE PortUseCase;

CREATE TABLE Events (
    EventId VARCHAR(10) PRIMARY KEY,
    Activity VARCHAR(50),
    Timestamp VARCHAR(10),
    ResourceName VARCHAR(50) NULL
);

INSERT INTO Events (EventId, Activity, Timestamp, ResourceName) VALUES
('e1', 'Lodge Pickup Plan', 't1', NULL),
('e2', 'Assign Trucks', 't2', NULL),
('e3', 'Lodge Pickup Plan', 't3', NULL),
('e4', 'Weigh the Empty Truck', 't4', 'WS001'),
('e5', 'Load Truck', 't5', 'WI001'),
('e6', 'Weigh the Loaded Truck', 't6', 'WS001'),
('e7', 'Input the Tally Sheet', 't7', NULL),
('e8', 'Print the Weighing Ticket', 't7', NULL),
('e9', 'Evaluate the truck exit', 't8', 'SO1'),
('e10', 'Assign Trucks', 't9', NULL);


CREATE TABLE Object_Truck (
    object_id VARCHAR(10),
    timestamp VARCHAR(10),
    ocel_changed_field VARCHAR(50),
    Pickup_Plan_ID VARCHAR(10),
    Cargo_ID VARCHAR(10),
    LPT VARCHAR(20),
    Axles INT,
    Scheduled_Pickup_Weight DECIMAL(10, 2),
    Truck_Status VARCHAR(20),
    Truck_Weight DECIMAL(10, 2),
    PRIMARY KEY (object_id, timestamp, ocel_changed_field)
);

INSERT INTO Object_Truck (
    object_id, timestamp, ocel_changed_field, Pickup_Plan_ID, Cargo_ID, LPT, Axles, 
    Scheduled_Pickup_Weight, Truck_Status, Truck_Weight
) VALUES
('Tr1', 't0', 'NULL', NULL, NULL,'841DKJ', 2, 0.0, 'Available', 0.0),
('Tr1', 't2', 'Truck Status', NULL, NULL, NULL, NULL, NULL, 'Occupied', NULL),
('Tr1', 't2', 'Pickup Plan ID', 'Pcp1', NULL, NULL,NULL, NULL, NULL, NULL),
('Tr1', 't2', 'Scheduled Pickup Weight', NULL, NULL, NULL, NULL, 2.2, NULL, NULL),
('Tr1', 't2', 'Cargo ID', NULL, 'Cid1', NULL, NULL, NULL, NULL, NULL),
('Tr1', 't4', 'Truck Weight', NULL, NULL, NULL, NULL, NULL, NULL, 12.6),
('Tr1', 't6', 'Truck Weight', NULL, NULL, NULL, NULL, NULL, NULL, 14.8),
('Tr1', 't8', 'Truck Status', NULL, NULL, NULL, NULL, NULL, 'Available', NULL),
('Tr1', 't9', 'Truck Status', NULL, NULL, NULL, NULL, NULL, 'Occupied', NULL),
('Tr1', 't9', 'Pickup Plan ID', 'Pcp3', NULL, NULL, NULL, NULL, NULL, NULL),
('Tr1', 't9', 'Scheduled Pickup Weight', NULL, NULL, NULL, NULL, 3.1, NULL, NULL),
('Tr1', 't9', 'Cargo ID', NULL, 'Cid4', NULL, NULL, NULL, NULL, NULL);


CREATE TABLE Object_Cargo (
    object_id VARCHAR(10),
    timestamp VARCHAR(10),
    ocel_changed_field VARCHAR(50),
    Cargo_Type VARCHAR(50) NULL,
    Cargo_stock_weight DECIMAL(10, 2) NULL,
    Silo_ID VARCHAR(10) NULL,
    PRIMARY KEY (object_id, timestamp, ocel_changed_field)
);

INSERT INTO Object_Cargo (
	object_id, timestamp, ocel_changed_field, Cargo_Type, Cargo_stock_weight, Silo_ID
) VALUES
('Cid1', 't0', 'NULL', 'Rice', 8.3, 'Sid1'),
('Cid1', 't1', 'Cargo stock weight', NULL, 6.1, NULL);

CREATE TABLE Object_Silo (
    object_id VARCHAR(10),
    Silo_Status VARCHAR(10),
    PRIMARY KEY (object_id)
);

INSERT INTO Object_Silo (
	object_Id, Silo_Status
) VALUES
('Sid1', 'Occupied');

CREATE TABLE E2O_Relations (
    EventId VARCHAR(10),
    object_id VARCHAR(10),
    e2o_qualifier VARCHAR(100)
);

INSERT INTO E2O_Relations (
   EventId, object_id, e2o_qualifier
) VALUES
('e1', 'Pcp1', 'lodged pickup plan'),
('e1', 'Cid1', 'cargo scheduled to be pickup'),
('e2', 'Tr1', 'Pickup plan trucks assignment'),
('e4', 'Tr1', 'Truck weighed'),
('e5', 'Tr1', 'cargo load for truck'),
('e6', 'Tr1', 'Truck weighed'),
('e7', 'Tr1', 'Tally Sheet for pickup'),
('e8', 'Tr1', 'Printed weighing ticket for pickup'),
('e9', 'Tr1', 'Exit evaluation for truck'),
('e10', 'Tr1', 'Pickup plan trucks assignment');


CREATE TABLE O2O_Relations (
    source_object_id VARCHAR(10),
    target_object_id VARCHAR(10),
    timestamp VARCHAR(10),
    o2o_qualifier VARCHAR(100)
);

INSERT INTO O2O_Relations (
    source_object_id, target_object_id, timestamp, o2o_qualifier
) VALUES
('Pcp1', 'Cid1', 't1', ' Lodged Pickup Plan for Cargo'),
('Pcp3', 'Cid4', 't3', 'Lodged Pickup Plan for Cargo'),
('Tr1', 'Pcp1', 't2', 'Assigned Truck for Pickup Plan'),
('Tr1', 'Pcp1', 't8', 'Dropped Truck from Pickup Plan'),
('Tr3', 'Pcp3', 't9', 'Assigned Truck for Pickup Plan');


CREATE TABLE Object_PickupPlan (
    object_id VARCHAR(10),
    timestamp VARCHAR(10),
    Cargo_ID VARCHAR(10) NULL,
    Num_of_trucks INT NULL,
    Total_pickup_weight DECIMAL(10, 2) NULL,
    PRIMARY KEY (object_id)
);

INSERT INTO Object_PickupPlan (
    object_id, timestamp, Cargo_ID, Num_of_trucks, Total_pickup_weight
) VALUES
('Pcp1', 't1', 'Cid1', 2, 5.2),
('Pcp3', 't3', 'Cid4', 1, 3.1);
