-- QC 2c

-- Dirigo
WITH IdentifiedTruck AS (
  SELECT Object_id AS TruckID
  FROM OCEL_Truck
  WHERE LPT = '926VFT'
),
PickupTimestamp AS (
  SELECT MIN(Timestamp) AS FirstPickupTime
  FROM OCEL_Truck
  WHERE Object_id = (SELECT TruckID FROM IdentifiedTruck)
    AND "Cargo ID" = 'Cr1'
),
TruckForPickupPlan AS (
  SELECT "Pickup Plan ID"
  FROM OCEL_Truck
  WHERE Object_id = (SELECT TruckID FROM IdentifiedTruck)
  AND Timestamp = (SELECT FirstPickupTime FROM PickupTimestamp)
  AND "Pickup Plan ID" IS NOT NULL
  ),
PickupPlanEventWindow AS (
  SELECT MIN(Timestamp) AS StartTime, MAX(Timestamp) AS EndTime
  FROM OCEL_O2O 
  WHERE Source_object_id = (SELECT TruckID FROM IdentifiedTruck)
  AND Target_object_id = (SELECT "Pickup Plan ID" FROM TruckForPickupPlan)
),
TruckWeightEventsInPickupWindow AS (
  SELECT *
  FROM OCEL_Truck
  WHERE object_id = (SELECT TruckID FROM IdentifiedTruck)
    AND Ocel_changed_field = 'Truck Weight'
    AND Timestamp BETWEEN 
        (SELECT StartTime FROM PickupPlanEventWindow)
        AND 
        (SELECT EndTime FROM PickupPlanEventWindow)
)
SELECT MIN(Timestamp) AS TruckWeightEventsInPickupWindow
FROM TruckWeightEventsInPickupWindow;
-- 2024-05-01 08:51:25

-- ACEL
WITH IdentifiedTruck AS (
  SELECT ObjectId AS TruckID
  FROM ACEL_Objects
  WHERE LPT = '926VFT'
),
TruckEvents AS (
SELECT e.*
FROM ACEL_Events e
WHERE EXISTS (
  SELECT 1
  FROM json_each(REPLACE(e.Objects, '''', '"'))
  WHERE json_each.value = (SELECT TruckID FROM IdentifiedTruck))
 ),
 TruckPickupRelation As (
SELECT Relations
FROM TruckEvents
WHERE EXISTS (
   SELECT 1
   FROM json_each(REPLACE(ObjectChanges, '''', '"')) AS jc
  WHERE json_extract(jc.value, '$.Attribute') = 'Cargo ID'
    AND json_extract(jc.value, '$.NewValue') = 'Cr1')
),
FilteredEvents As (
SELECT * 
FROM ACEL_Events
WHERE Relations = (SELECT Relations FROM TruckPickupRelation)
),
Timerange AS (
SELECT
  MIN(Timestamp) AS StartTime,
  MAX(Timestamp) AS EndTime
  FROM FilteredEvents
 )
 SELECT Timestamp
 FROM TruckEvents
 WHERE Activity = 'Weigh the Empty Truck'
 AND Timestamp Between 
 (SELECT StartTime FROM Timerange)
  AND 
 (SELECT EndTime FROM Timerange);
-- 2024-05-01 08:51:25

-- DOCEL
WITH IdentifiedTruck AS (
  SELECT ObjectID AS TruckID
  FROM DOCEL_Truck_Static
  WHERE LPT = '926VFT'
),
TruckEvents AS (
  SELECT * 
  FROM DOCEL_Events
 WHERE EXISTS (
  SELECT 1
  FROM json_each(REPLACE(Truck, '''', '"'))
  WHERE json_each.value = (SELECT TruckID FROM IdentifiedTruck))
  ORDER BY Timestamp
 ),
 TruckAssignEvent AS (
 SELECT eventID
 FROM DOCEL_TruckCargoID
 WHERE objectID = (SELECT TruckID FROM IdentifiedTruck)
 AND "Cargo ID" = 'Cr1'
 ),
 AssignEventTime AS (
  SELECT Timestamp
  FROM DOCEL_Events
  WHERE eventID = (SELECT eventID FROM TruckAssignEvent)
),
 NextAssignment AS (
SELECT e.eventID, e.Timestamp
  FROM DOCEL_Events e
  WHERE e.Activity = 'Assign Truck'
    AND EXISTS (
      SELECT 1
      FROM json_each(REPLACE(e.Truck, '''', '"'))
      WHERE json_each.value = (SELECT TruckID FROM IdentifiedTruck)
    )
    AND e.Timestamp > (SELECT Timestamp FROM AssignEventTime)
  ORDER BY e.Timestamp ASC
  LIMIT 1
  )
 SELECT Timestamp
 FROM TruckEvents
 WHERE Activity = 'Weigh the Empty Truck'
 AND Timestamp BETWEEN
  (SELECT Timestamp FROM AssignEventTime)
  AND 
 (SELECT Timestamp FROM NextAssignment);
 -- 2024-05-01 08:51:25
 
 
