-- QC 2a

-- Dirigo
SELECT "Cargo Type"
FROM OCEL_Cargo
WHERE Object_id = 'Cr1' AND "Cargo Type" IS NOT NULL;
-- (RICE)


-- ACEL
SELECT "Cargo Type"
FROM ACEL_Objects
WHERE Objectid = 'Cr1';
-- (RICE)



-- DOCEL
SELECT "Cargo Type"
FROM DOCEL_Cargo_Static
WHERE objectID = 'Cr1';
-- (RICE)