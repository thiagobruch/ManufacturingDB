## Push a few random rows into Critical for realism ##

```
WITH RandomCritical AS (
    SELECT TOP (200) r.ReadingID
    FROM MachineSensorReadings r
    ORDER BY NEWID()
)
UPDATE r
SET Status = 'Critical'
FROM MachineSensorReadings r
JOIN RandomCritical c
    ON r.ReadingID = c.ReadingID;
GO
```
