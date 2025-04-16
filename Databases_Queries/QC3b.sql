-- QC 3b

-- Dirigo
WITH IdentifiedTruck AS (
  SELECT Object_id AS TruckID
  FROM OCEL_Truck
  WHERE LPT = '926VFT'
),
LastDropTime AS (
  SELECT MIN(Timestamp) AS DroppedAt
  FROM OCEL_O2O
  WHERE Source_object_id = (SELECT TruckID FROM IdentifiedTruck)
    AND O2O_qualifier = 'Dropped truck from pickup plan'
),
NextAssignedPickup AS (
  SELECT Target_object_id AS AssignedPickupPlan, Timestamp
  FROM OCEL_O2O
  WHERE Source_object_id = (SELECT TruckID FROM IdentifiedTruck)
    AND O2O_qualifier = 'Assigned truck for pickup plan'
    AND Timestamp > (SELECT DroppedAt FROM LastDropTime)
  ORDER BY Timestamp ASC
  LIMIT 1
)
SELECT AssignedPickupPlan
FROM NextAssignedPickup;
-- Pcp16 (is the one assigned to the truck with the license plate no '926VFT' after the first pickup plan (Pcp18))


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
TruckFirstAssignTime AS (
  SELECT MIN(Timestamp) AS FirstTime
  FROM TruckEvents
  WHERE Activity = 'Assign Truck'
  ORDER BY Timestamp
),
SecondAssignEvent AS (
  SELECT *
  FROM TruckEvents
  WHERE Activity = 'Assign Truck'
  AND Timestamp > (SELECT FirstTime FROM TruckFirstAssignTime)
  ORDER BY Timestamp
  LIMIT 1
)
SELECT json_extract(jc.value, '$.NewValue') AS NewStatus
FROM SecondAssignEvent, json_each(REPLACE(ObjectChanges, '''', '"')) AS jc
WHERE json_extract(jc.value, '$.Attribute') = 'Pickup Plan ID';
 -- Pcp16
 
 
 -- DOCEL
 WITH IdentifiedTruck AS (
  SELECT ObjectID AS TruckID
  FROM DOCEL_Truck_Static
  WHERE LPT = '926VFT'
),
TruckPickupPlans AS (
  SELECT "Pickup Plan ID", eventID
  FROM DOCEL_TruckPickupplanID
  WHERE objectID = (SELECT TruckID FROM IdentifiedTruck)
),
AssignedPlans AS (
SELECT e.eventID, Timestamp, tp."Pickup Plan ID", ROW_NUMBER() OVER (ORDER BY e.Timestamp) AS rn
FROM DOCEL_Events e
JOIN TruckPickupPlans tp on e.eventID = tp.eventID
ORDER BY Timestamp
)
SELECT "Pickup Plan ID"
FROM AssignedPlans
WHERE rn = 2;
 -- Pcp16
 
 
 
 