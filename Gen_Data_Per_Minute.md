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
### Option A: ### 
SQL Server Agent (if available)<BR>
Open SQL Server Agent<BR>
Create new job:<BR>
Name: IoT_Data_Generator<BR>
On the Left, click on Steps and click New:<BR>
Step Name: IoT <BR>
Type: T-SQL<BR>
Command: EXEC InsertIoTBatch;<BR>
Click OK<BR>
Go to Schedule and click New:<BR>
Name: Create_IoT_Data<BR>
Recurring Every 1 minute<BR>

### Option B: ###
```
USE msdb;
GO

-------------------------------------------------------------------
-- Create Job
-------------------------------------------------------------------
EXEC dbo.sp_add_job
    @job_name = N'IoT_Data_Generator',
    @enabled = 1,
    @description = N'Runs InsertIoTBatch every minute';
GO

-------------------------------------------------------------------
-- Add Job Step
-------------------------------------------------------------------
EXEC dbo.sp_add_jobstep
    @job_name = N'IoT_Data_Generator',
    @step_name = N'IoT',
    @subsystem = N'TSQL',
    @database_name = N'ManufacturingDB',
    @command = N'EXEC InsertIoTBatch;';
GO

-------------------------------------------------------------------
-- Create Schedule
-------------------------------------------------------------------
EXEC dbo.sp_add_schedule
    @schedule_name = N'Create_IoT_Data',
    @enabled = 1,
    @freq_type = 4,              -- daily
    @freq_interval = 1,
    @freq_subday_type = 4,       -- minutes
    @freq_subday_interval = 1,   -- every 1 minute
    @active_start_time = 000000;
GO

-------------------------------------------------------------------
-- Attach Schedule to Job
-------------------------------------------------------------------
EXEC dbo.sp_attach_schedule
    @job_name = N'IoT_Data_Generator',
    @schedule_name = N'Create_IoT_Data';
GO

-------------------------------------------------------------------
-- Add Job to Local Server
-------------------------------------------------------------------
EXEC dbo.sp_add_jobserver
    @job_name = N'IoT_Data_Generator';
GO
```

Step 3 — Done 🎉

Now your table will:
continuously receive 5–10 rows/min and simulate real IoT ingestion

## To temporarily disable the Job ##
```
EXEC msdb.dbo.sp_update_job
    @job_name = 'IoT_Data_Generator',
    @enabled = 0;
```

## To delete it the Job and Drop the Store Procedure ##
```
EXEC msdb.dbo.sp_delete_job
    @job_name = N'IoT_Data_Generator';
DROP PROCEDURE dbo.InsertIoTBatch;
```
