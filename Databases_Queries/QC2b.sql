-- QC 2b

-- Dirigo
WITH FirstPickup AS (
    SELECT MIN(e.timestamp) AS PickupTimestamp
    FROM OCEL_E2O er
    JOIN OCEL_Events e ON er.Event_id = e.Event_id
    WHERE e.Activity = 'Lodge Pickup Plan'
      AND er.object_id = 'Cr1'
)
SELECT "Cargo stock weight(scheduled)"
FROM OCEL_Cargo
WHERE object_id = 'Cr1'
  AND timestamp < (SELECT PickupTimestamp FROM FirstPickup)
  AND timestamp = (
    SELECT MAX(timestamp)
    FROM OCEL_Cargo
    WHERE object_id = 'Cr1'
      AND timestamp < (SELECT PickupTimestamp FROM FirstPickup)
);
-- 120122.9

