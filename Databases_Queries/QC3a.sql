-- QC 3a

-- Dirigo
SELECT Timestamp
FROM OCEL_O2O
WHERE Source_object_id = 'Pcp53' AND Target_object_id = 'Cr1';
-- 2024-04-29 11:17:06

-- ACEL
SELECT Timestamp
FROM ACEL_Events
WHERE EXISTS (
  SELECT 1
  FROM json_each(REPLACE(Objects, '''', '"'))
  WHERE json_each.value = 'Pcp53'
)
AND EXISTS (
  SELECT 1
  FROM json_each(REPLACE(Objects, '''', '"'))
  WHERE json_each.value = 'Cr1'
);
-- 2024-04-29 11:17:06


-- DOCEL
SELECT Timestamp
FROM DOCEL_Events
WHERE eventID = (
SELECT eventID
FROM DOCEL_PickupplanCargo
WHERE "Cargo ID" = 'Cr1' AND objectID = 'Pcp53');
-- 2024-04-29 11:17:06