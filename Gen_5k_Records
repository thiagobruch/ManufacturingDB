
## 5,000 IoT readings with smoother time-series behavior.
```
USE ManufacturingDB;
GO

SET NOCOUNT ON;

;WITH Numbers AS (
    SELECT TOP (5000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
),
SensorPool AS (
    SELECT
        s.SensorID,
        s.MachineID,
        s.SensorType,
        s.MinAcceptableValue,
        s.MaxAcceptableValue,
        s.UnitOfMeasure,
        ROW_NUMBER() OVER (ORDER BY s.SensorID) AS SensorRowNum
    FROM MachineSensors s
    WHERE s.IsActive = 1
),
SensorCount AS (
    SELECT COUNT(*) AS TotalSensors
    FROM SensorPool
),
BaseSeries AS (
    SELECT
        n.n,
        sp.SensorID,
        sp.MachineID,
        sp.SensorType,
        sp.MinAcceptableValue,
        sp.MaxAcceptableValue,
        sp.UnitOfMeasure,

        -- Which reading number this is for a given sensor
        ((n.n - 1) / sc.TotalSensors) + 1 AS StepNum,

        -- Distribute rows across sensors
        DATEADD(
            MINUTE,
            -5 * (((n.n - 1) / sc.TotalSensors) + 1),
            SYSDATETIME()
        ) AS ReadingTime
    FROM Numbers n
    CROSS JOIN SensorCount sc
    JOIN SensorPool sp
        ON sp.SensorRowNum = ((n.n - 1) % sc.TotalSensors) + 1
),
CalculatedReadings AS (
    SELECT
        b.n,
        b.SensorID,
        b.MachineID,
        b.SensorType,
        b.MinAcceptableValue,
        b.MaxAcceptableValue,
        b.UnitOfMeasure,
        b.StepNum,
        b.ReadingTime,

        CAST(
            CASE b.SensorType
                WHEN 'Temperature' THEN
                    62.0
                    + 9.5 * SIN((b.StepNum / 8.0) + (b.SensorID * 0.35))
                    + 2.0 * COS((b.StepNum / 19.0) + (b.SensorID * 0.11))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 15) - 7) / 10.0
                    + CASE WHEN b.StepNum % 47 = 0 THEN 14.0 ELSE 0 END

                WHEN 'Vibration' THEN
                    4.2
                    + 1.6 * SIN((b.StepNum / 6.5) + (b.SensorID * 0.28))
                    + 0.7 * COS((b.StepNum / 13.0) + (b.SensorID * 0.17))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 9) - 4) / 20.0
                    + CASE WHEN b.StepNum % 53 = 0 THEN 5.5 ELSE 0 END

                WHEN 'Pressure' THEN
                    138.0
                    + 18.0 * SIN((b.StepNum / 7.0) + (b.SensorID * 0.22))
                    + 9.0 * COS((b.StepNum / 16.0) + (b.SensorID * 0.09))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 21) - 10) / 5.0
                    + CASE WHEN b.StepNum % 61 = 0 THEN 48.0 ELSE 0 END

                WHEN 'Humidity' THEN
                    52.0
                    + 7.5 * SIN((b.StepNum / 10.0) + (b.SensorID * 0.18))
                    + 3.2 * COS((b.StepNum / 24.0) + (b.SensorID * 0.10))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 11) - 5) / 5.0
                    + CASE WHEN b.StepNum % 73 = 0 THEN 12.0 ELSE 0 END

                WHEN 'Power' THEN
                    92.0
                    + 15.0 * SIN((b.StepNum / 5.5) + (b.SensorID * 0.31))
                    + 7.0 * COS((b.StepNum / 14.0) + (b.SensorID * 0.13))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 19) - 9) / 4.0
                    + CASE WHEN b.StepNum % 45 = 0 THEN 36.0 ELSE 0 END

                WHEN 'Current' THEN
                    18.0
                    + 3.8 * SIN((b.StepNum / 6.0) + (b.SensorID * 0.26))
                    + 1.6 * COS((b.StepNum / 17.0) + (b.SensorID * 0.08))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 9) - 4) / 6.0
                    + CASE WHEN b.StepNum % 52 = 0 THEN 9.0 ELSE 0 END

                WHEN 'Voltage' THEN
                    236.0
                    + 8.0 * SIN((b.StepNum / 11.0) + (b.SensorID * 0.14))
                    + 4.0 * COS((b.StepNum / 22.0) + (b.SensorID * 0.05))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 13) - 6) / 3.0
                    + CASE WHEN b.StepNum % 89 = 0 THEN 18.0 ELSE 0 END

                WHEN 'RPM' THEN
                    2150.0
                    + 280.0 * SIN((b.StepNum / 5.0) + (b.SensorID * 0.30))
                    + 120.0 * COS((b.StepNum / 12.0) + (b.SensorID * 0.15))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 31) - 15) * 3.0
                    + CASE WHEN b.StepNum % 57 = 0 THEN 750.0 ELSE 0 END

                WHEN 'Flow' THEN
                    78.0
                    + 10.5 * SIN((b.StepNum / 7.5) + (b.SensorID * 0.21))
                    + 4.0 * COS((b.StepNum / 18.0) + (b.SensorID * 0.07))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 13) - 6) / 4.0
                    + CASE WHEN b.StepNum % 64 = 0 THEN 22.0 ELSE 0 END

                WHEN 'OilLevel' THEN
                    71.0
                    + 4.0 * SIN((b.StepNum / 15.0) + (b.SensorID * 0.12))
                    + 2.0 * COS((b.StepNum / 29.0) + (b.SensorID * 0.04))
                    - (b.StepNum * 0.045)  -- slow consumption trend
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 7) - 3) / 5.0
                    + CASE WHEN b.StepNum % 80 = 0 THEN -18.0 ELSE 0 END

                ELSE 0.0
            END
        AS DECIMAL(18,4)) AS ReadingValueRaw
    FROM BaseSeries b
),
FinalReadings AS (
    SELECT
        c.SensorID,
        c.MachineID,
        c.ReadingTime,

        -- Clamp to non-negative values
        CAST(
            CASE
                WHEN c.ReadingValueRaw < 0 THEN 0
                ELSE c.ReadingValueRaw
            END
        AS DECIMAL(18,4)) AS ReadingValue,

        c.MinAcceptableValue,
        c.MaxAcceptableValue,

        CASE
            WHEN c.StepNum % 97 = 0 THEN 'Estimated'
            ELSE 'Good'
        END AS QualityFlag
    FROM CalculatedReadings c
)
INSERT INTO MachineSensorReadings (
    SensorID,
    MachineID,
    ReadingTime,
    ReadingValue,
    Status,
    QualityFlag
)
SELECT
    f.SensorID,
    f.MachineID,
    f.ReadingTime,
    f.ReadingValue,
    CASE
        WHEN f.MinAcceptableValue IS NOT NULL
             AND f.ReadingValue < f.MinAcceptableValue * 0.90 THEN 'Critical'
        WHEN f.MaxAcceptableValue IS NOT NULL
             AND f.ReadingValue > f.MaxAcceptableValue * 1.10 THEN 'Critical'
        WHEN f.MinAcceptableValue IS NOT NULL
             AND f.ReadingValue < f.MinAcceptableValue THEN 'Warning'
        WHEN f.MaxAcceptableValue IS NOT NULL
             AND f.ReadingValue > f.MaxAcceptableValue THEN 'Warning'
        ELSE 'Normal'
    END AS Status,
    f.QualityFlag
FROM FinalReadings f;
GO
