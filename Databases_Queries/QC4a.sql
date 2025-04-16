-- QC 4a

-- Dirigo
 WITH IdentifiedTruck AS (
  SELECT Object_id AS TruckID
  FROM OCEL_Truck
  WHERE LPT = '926VFT'
)
  SELECT *
  FROM OCEL_O2O
  WHERE Source_object_id = (SELECT TruckID FROM IdentifiedTruck)
    AND Target_object_id = 'Pcp18';
-- tr18	Pcp18	Assigned truck for pickup plan	2024-05-01 08:47:38
-- tr18 Pcp18	Dropped truck from pickup plan	2024-05-01 09:33:07


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
RelationID As (
  SELECT 
    rel.value AS RelationId
  FROM TruckEvents e,
       json_each(REPLACE(e.ObjectChanges, '''', '"')) obj_change,
       json_each(REPLACE(e.Relations, '''', '"')) rel
  WHERE json_extract(obj_change.value, '$.Attribute') = 'Pickup Plan ID'
  AND json_extract(obj_change.value, '$.NewValue') = 'Pcp18' 
),
Qualifiers AS (
SELECT *
FROM ACEL_Relations 
WHERE RelationId = (SELECT RelationId FROM RelationID)
),
SELECTEDTruckEvents AS(
SELECT * 
FROM TruckEvents, json_each(REPLACE(Relations, '''', '"')) AS jc
WHERE jc.value = (SELECT RelationId FROM RelationID)
)
SELECT 
	r.Source,
  CASE 
      WHEN json_extract(rc.value, '$.ChangeStatus') = 'addedTarget' THEN 'is assigned to'
      WHEN json_extract(rc.value, '$.ChangeStatus') = 'deletedTarget' THEN 'is dropped from'
  END AS Qualifier,
  e.Timestamp,
	json_extract(rc.value, '$.Target') AS 'Target'
FROM 
    SELECTEDTruckEvents e,
    json_each(REPLACE(e.RelationChanges, '''', '"')) AS rc
JOIN 
    Qualifiers r
    ON r.RelationId = json_extract(rc.value, '$.RelationId')
    AND r.Type = CASE 
                    WHEN json_extract(rc.value, '$.ChangeStatus') = 'addedTarget' THEN 'is assigned to'
                    WHEN json_extract(rc.value, '$.ChangeStatus') = 'deletedTarget' THEN 'is dropped from'
                END
WHERE 
    json_extract(rc.value, '$.RelationId') IN (
        SELECT RelationId FROM SELECTEDTruckEvents
    );
-- Pcp18	is assigned to	2024-05-01 08:47:38	tr18
-- Pcp18	is dropped from	2024-05-01 09:33:07	tr18
  



 