## Generate 500 Records IoT Table: ##
```
USE ManufacturingDB;
GO

SET NOCOUNT ON;

;WITH Numbers AS (
    SELECT TOP (500)
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
    sp.SensorID,
    sp.MachineID,
    DATEADD(
        MINUTE,
        -1 * (n.n * 3),
        SYSDATETIME()
    ) AS ReadingTime,

    CAST(
        CASE sp.SensorType
            WHEN 'Temperature' THEN
                CASE
                    WHEN n.n % 25 = 0 THEN 92.5
                    WHEN n.n % 11 = 0 THEN 86.8
                    ELSE 42.0 + ((n.n % 280) / 10.0)
                END

            WHEN 'Vibration' THEN
                CASE
                    WHEN n.n % 27 = 0 THEN 14.2
                    WHEN n.n % 9 = 0 THEN 11.4
                    ELSE 2.2 + ((n.n % 55) / 10.0)
                END

            WHEN 'Pressure' THEN
                CASE
                    WHEN n.n % 23 = 0 THEN 224.0
                    WHEN n.n % 10 = 0 THEN 205.0
                    ELSE 95.0 + ((n.n % 850) / 10.0)
                END

            WHEN 'Humidity' THEN
                CASE
                    WHEN n.n % 19 = 0 THEN 88.0
                    WHEN n.n % 8 = 0 THEN 76.0
                    ELSE 40.0 + ((n.n % 250) / 10.0)
                END

            WHEN 'Power' THEN
                CASE
                    WHEN n.n % 21 = 0 THEN 265.0
                    WHEN n.n % 7 = 0 THEN 235.0
                    ELSE 35.0 + ((n.n % 1400) / 10.0)
                END

            WHEN 'Current' THEN
                CASE
                    WHEN n.n % 22 = 0 THEN 48.0
                    WHEN n.n % 8 = 0 THEN 41.0
                    ELSE 12.0 + ((n.n % 220) / 10.0)
                END

            WHEN 'Voltage' THEN
                CASE
                    WHEN n.n % 24 = 0 THEN 510.0
                    WHEN n.n % 9 = 0 THEN 485.0
                    ELSE 220.0 + ((n.n % 1400) / 10.0)
                END

            WHEN 'RPM' THEN
                CASE
                    WHEN n.n % 20 = 0 THEN 5200.0
                    WHEN n.n % 6 = 0 THEN 4700.0
                    ELSE 1200.0 + ((n.n % 1800))
                END

            WHEN 'Flow' THEN
                CASE
                    WHEN n.n % 18 = 0 THEN 145.0
                    WHEN n.n % 7 = 0 THEN 128.0
                    ELSE 45.0 + ((n.n % 500) / 10.0)
                END

            WHEN 'OilLevel' THEN
                CASE
                    WHEN n.n % 17 = 0 THEN 18.0
                    WHEN n.n % 6 = 0 THEN 24.0
                    ELSE 55.0 + ((n.n % 350) / 10.0)
                END

            ELSE 0.0
        END
    AS DECIMAL(18,4)) AS ReadingValue,

    CASE
        WHEN n.n % 25 = 0 THEN 'Critical'
        WHEN n.n % 7 = 0 THEN 'Warning'
        ELSE 'Normal'
    END AS Status,

    CASE
        WHEN n.n % 20 = 0 THEN 'Estimated'
        ELSE 'Good'
    END AS QualityFlag

FROM Numbers n
CROSS JOIN SensorCount sc
JOIN SensorPool sp
    ON sp.SensorRowNum = ((n.n - 1) % sc.TotalSensors) + 1;
GO
