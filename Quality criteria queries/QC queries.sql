USE PortUseCase;

-- QC2.a static
SELECT Cargo_Type 
FROM Object_Cargo 
WHERE object_id = 'Cid1';
-- Cargo_Type: Rice


-- QC2.a dynamic 
WITH CurrentPickup AS (
    SELECT e.timestamp AS PickupTimestamp
    FROM E2O_Relations er
    JOIN Events e ON er.EventId = e.EventId
    WHERE e.Activity = 'Lodge Pickup Plan' AND er.object_id = 'Cid1'
),
PreviousStockWeights AS (
    SELECT Cargo_stock_weight, timestamp
    FROM Object_Cargo
    WHERE object_id = 'Cid1'
      AND timestamp < (SELECT PickupTimestamp FROM CurrentPickup)
)
SELECT Cargo_stock_weight
FROM PreviousStockWeights
WHERE timestamp IN (SELECT MAX(timestamp) FROM PreviousStockWeights);
-- Cargo_stock_weight is 8.30


-- QC 2.b
SELECT e.Timestamp
FROM Events e
JOIN E2O_Relations er ON e.EventId = er.EventId
JOIN Object_Truck ot ON er.object_id = ot.object_id
WHERE e.Activity = 'Weigh the Empty Truck' AND ot.LPT = '841DKJ';
-- t4


-- QC 3.a static
SELECT Silo_ID
FROM Object_Cargo
WHERE object_id = 'Cid1';
-- Sid1

-- QC 3.a dynamic
WITH TruckID AS (
    SELECT object_id
    FROM Object_Truck
    WHERE LPT = '841DKJ'
    LIMIT 1
),
TruckPickupRecord AS (
SELECT object_id, timestamp, Pickup_Plan_ID
FROM Object_Truck
WHERE object_id IN (SELECT object_id FROM TruckID)
AND Pickup_Plan_ID IS NOT NULL
)
SELECT object_id,Pickup_Plan_ID
FROM TruckPickupRecord
WHERE timestamp = (
	SELECT MAX(timestamp) 
    FROM TruckPickupRecord);
-- Pcp3


-- QC 3.b
WITH TruckID AS (
    SELECT object_id
    FROM Object_Truck
    WHERE LPT = '841DKJ'
),
PickupPlan AS (
    SELECT o2o.source_object_id AS Pickup_Plan_ID
    FROM O2O_Relations o2o
    WHERE o2o.target_object_id = 'Cid1'
),
RelationTime AS (
    SELECT timestamp AS RelationTimestamp
    FROM O2O_Relations
    WHERE source_object_id IN (SELECT object_id FROM TruckID)
      AND target_object_id IN (SELECT Pickup_Plan_ID FROM PickupPlan)
    LIMIT 1
),
WeighEventsAfter AS (
    SELECT e.EventId, e.Activity, e.Timestamp
    FROM Events e
    JOIN E2O_Relations er ON e.EventId = er.EventId
    WHERE er.object_id IN (SELECT object_id FROM TruckID)
      AND e.Activity = 'Weigh the Empty Truck'
      AND e.Timestamp > (SELECT RelationTimestamp FROM RelationTime)
)
SELECT ot.object_id, ot.Truck_Weight
FROM Object_Truck ot
JOIN WeighEventsAfter we ON ot.timestamp = we.Timestamp
WHERE ot.object_id IN (SELECT object_id FROM TruckID);
-- Tr1, 12.60



-- Qc4.a
WITH TruckID AS (
    SELECT object_id
    FROM Object_Truck
    WHERE LPT = '841DKJ'
),
TruckPickupRecord AS (
SELECT object_id, timestamp, Pickup_Plan_ID
FROM Object_Truck
WHERE object_id IN (SELECT object_id FROM TruckID)
AND Pickup_Plan_ID IS NOT NULL
),
RelationTime AS (
    SELECT timestamp AS RelationTimestamp
    FROM O2O_Relations
    WHERE source_object_id IN (SELECT object_id FROM TruckID)
      AND target_object_id IN (SELECT Pickup_Plan_ID FROM TruckPickupRecord)
    LIMIT 1
)
SELECT ot.Timestamp
FROM Object_Truck ot
WHERE ot.object_id IN (SELECT object_id FROM TruckID)
AND ot.Truck_Status = 'Available'
AND ot.Timestamp > (SELECT RelationTimestamp FROM RelationTime);
-- t8



-- QC4.b
WITH TruckID AS (
    SELECT object_id
    FROM Object_Truck
    WHERE LPT = '841DKJ'
)
SELECT object_id, timestamp, Truck_Status
FROM object_truck
WHERE object_id = (SELECT object_id FROM TruckID)
AND Truck_Status IN ('Occupied', 'Available')
ORDER BY timestamp;











