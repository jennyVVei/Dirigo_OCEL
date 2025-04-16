-- QC 4b

-- Dirigo
WITH IdentifiedTruck AS (
  SELECT Object_id AS TruckID
  FROM OCEL_Truck
  WHERE LPT = '926VFT'
),
EventTime AS (
SELECT Timestamp
FROM OCEL_O2O
WHERE Source_object_id = (SELECT TruckID FROM IdentifiedTruck)
AND O2O_qualifier LIKE 'dropped%'
AND Target_object_id = 'Pcp18'
),
EventID AS (
SELECT Event_id
FROM OCEL_Events
WHERE Timestamp = (SELECT Timestamp FROM EventTime)
)
SELECT E2O_qualifier
FROM OCEL_E2O
WHERE Event_id = (SELECT Event_id FROM EventID)
AND Object_id = (SELECT TruckID FROM IdentifiedTRuck);
-- Truck being evaluated for exit

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
RelationsE2O AS (
SELECT Relations
FROM TruckEvents, json_each(REPLACE(ObjectChanges, '''', '"')) AS jc
WHERE json_extract(jc.value, '$.Attribute') = 'Pickup Plan ID'
AND json_extract(jc.value, '$.NewValue') = 'Pcp18'
),
SELECTEDEvents AS (
SELECT * 
FROM ACEL_Events 
WHERE Relations = (SELECT Relations FROM RelationsE2O)
)
SELECT json_extract(jc.value, '$.NewValue') 
FROM SELECTEDEvents, json_each(REPLACE(ObjectChanges, '''', '"')) AS jc
WHERE json_extract(jc.value, '$.Attribute') = 'lifecycle'
AND Activity = 'Evaluate the Truck Exit';
-- released
 