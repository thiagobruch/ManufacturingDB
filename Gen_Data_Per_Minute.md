-- Job every Minute:

## Step 1 — Create a stored procedure ##

This will insert 5–10 rows per execution
```
CREATE OR ALTER PROCEDURE InsertIoTBatch
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RowCount INT = 5 + ABS(CHECKSUM(NEWID())) % 6; -- 5 to 10 rows

    INSERT INTO MachineSensorReadings (
        SensorID,
        MachineID,
        ReadingTime,
        ReadingValue,
        Status,
        QualityFlag
    )
    SELECT TOP (@RowCount)
        s.SensorID,
        s.MachineID,
        SYSDATETIME(),

        CAST(
            CASE s.SensorType
                WHEN 'Temperature' THEN 50 + (ABS(CHECKSUM(NEWID())) % 3000) / 100.0
                WHEN 'Vibration'   THEN 2 + (ABS(CHECKSUM(NEWID())) % 500) / 100.0
                WHEN 'Pressure'    THEN 100 + (ABS(CHECKSUM(NEWID())) % 8000) / 100.0
                WHEN 'Power'       THEN 30 + (ABS(CHECKSUM(NEWID())) % 10000) / 100.0
                WHEN 'RPM'         THEN 1000 + (ABS(CHECKSUM(NEWID())) % 2000)
                ELSE 10
            END
        AS DECIMAL(18,4)),

        'Normal',
        'Good'

    FROM MachineSensors s
    ORDER BY NEWID(); -- random sensors
END;
GO
```
## Step 2 — Schedule it every minute ##
Option A: SQL Server Agent (if available)
Open SQL Server Agent
Create new job:
Name: IoT_Data_Generator
Add step:
Type: T-SQL
Command:
EXEC InsertIoTBatch;
Schedule: Recurring Every 1 minute

Step 3 — Done 🎉

Now your table will:
continuously receive 5–10 rows/min
simulate real IoT ingestion
