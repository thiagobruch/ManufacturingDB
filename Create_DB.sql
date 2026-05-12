-- Create database
IF DB_ID('ManufacturingDB') IS NOT NULL
BEGIN
    ALTER DATABASE ManufacturingDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ManufacturingDB;
END;
GO

CREATE DATABASE ManufacturingDB;
GO

USE ManufacturingDB;
GO

-- =========================
-- 1. Plants
-- =========================
CREATE TABLE Plants (
    PlantID INT IDENTITY(1,1) PRIMARY KEY,
    PlantName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(150) NOT NULL,
    PlantCode NVARCHAR(20) NOT NULL UNIQUE,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- =========================
-- 2. Departments
-- =========================
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
    DepartmentCode NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Departments_Plants FOREIGN KEY (PlantID) REFERENCES Plants(PlantID),
    CONSTRAINT UQ_Department UNIQUE (PlantID, DepartmentCode)
);
GO

-- =========================
-- 3. Employees
-- =========================
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(100) NOT NULL,
    HireDate DATE NOT NULL,
    Shift NVARCHAR(20) NOT NULL CHECK (Shift IN ('Day', 'Night', 'Rotating')),
    Salary DECIMAL(12,2) NOT NULL CHECK (Salary >= 0),
    Email NVARCHAR(120) NULL UNIQUE,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Employees_Departments FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

-- =========================
-- 4. Suppliers
-- =========================
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(150) NOT NULL,
    ContactName NVARCHAR(100) NULL,
    Phone NVARCHAR(30) NULL,
    Email NVARCHAR(120) NULL,
    City NVARCHAR(100) NULL,
    Country NVARCHAR(100) NULL,
    IsPreferred BIT NOT NULL DEFAULT 0
);
GO

-- =========================
-- 5. Raw Materials
-- =========================
CREATE TABLE RawMaterials (
    MaterialID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialCode NVARCHAR(30) NOT NULL UNIQUE,
    MaterialName NVARCHAR(120) NOT NULL,
    UnitOfMeasure NVARCHAR(20) NOT NULL,
    StandardCost DECIMAL(12,2) NOT NULL CHECK (StandardCost >= 0),
    ReorderLevel DECIMAL(12,2) NOT NULL DEFAULT 0
);
GO

-- =========================
-- 6. Supplier Materials (many-to-many)
-- =========================
CREATE TABLE SupplierMaterials (
    SupplierID INT NOT NULL,
    MaterialID INT NOT NULL,
    LeadTimeDays INT NOT NULL CHECK (LeadTimeDays >= 0),
    LastPurchasePrice DECIMAL(12,2) NOT NULL CHECK (LastPurchasePrice >= 0),
    PRIMARY KEY (SupplierID, MaterialID),
    CONSTRAINT FK_SupplierMaterials_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT FK_SupplierMaterials_RawMaterials FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);
GO

-- =========================
-- 7. Products
-- =========================
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductCode NVARCHAR(30) NOT NULL UNIQUE,
    ProductName NVARCHAR(120) NOT NULL,
    ProductCategory NVARCHAR(50) NOT NULL,
    StandardCost DECIMAL(12,2) NOT NULL CHECK (StandardCost >= 0),
    ListPrice DECIMAL(12,2) NOT NULL CHECK (ListPrice >= 0),
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- =========================
-- 8. Bill of Materials
-- =========================
CREATE TABLE BillOfMaterials (
    BOMID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    MaterialID INT NOT NULL,
    QuantityRequired DECIMAL(12,4) NOT NULL CHECK (QuantityRequired > 0),
    ScrapFactorPercent DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (ScrapFactorPercent >= 0),
    CONSTRAINT FK_BOM_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_BOM_Materials FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID),
    CONSTRAINT UQ_BOM UNIQUE (ProductID, MaterialID)
);
GO

-- =========================
-- 9. Machines
-- =========================
CREATE TABLE Machines (
    MachineID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT NOT NULL,
    MachineCode NVARCHAR(30) NOT NULL UNIQUE,
    MachineName NVARCHAR(100) NOT NULL,
    MachineType NVARCHAR(50) NOT NULL,
    PurchaseDate DATE NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Running', 'Stopped', 'Maintenance', 'Retired')),
    CONSTRAINT FK_Machines_Plants FOREIGN KEY (PlantID) REFERENCES Plants(PlantID)
);
GO

-- =========================
-- 10. Work Orders
-- =========================
CREATE TABLE WorkOrders (
    WorkOrderID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    PlantID INT NOT NULL,
    MachineID INT NULL,
    SupervisorID INT NULL,
    WorkOrderNumber NVARCHAR(30) NOT NULL UNIQUE,
    PlannedQuantity INT NOT NULL CHECK (PlannedQuantity > 0),
    ProducedQuantity INT NOT NULL DEFAULT 0 CHECK (ProducedQuantity >= 0),
    ScrapQuantity INT NOT NULL DEFAULT 0 CHECK (ScrapQuantity >= 0),
    StartDate DATETIME2 NOT NULL,
    EndDate DATETIME2 NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Planned', 'In Progress', 'Completed', 'Cancelled')),
    CONSTRAINT FK_WorkOrders_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_WorkOrders_Plants FOREIGN KEY (PlantID) REFERENCES Plants(PlantID),
    CONSTRAINT FK_WorkOrders_Machines FOREIGN KEY (MachineID) REFERENCES Machines(MachineID),
    CONSTRAINT FK_WorkOrders_Employees FOREIGN KEY (SupervisorID) REFERENCES Employees(EmployeeID)
);
GO

-- =========================
-- 11. Inventory
-- =========================
CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT NOT NULL,
    MaterialID INT NULL,
    ProductID INT NULL,
    QuantityOnHand DECIMAL(14,2) NOT NULL DEFAULT 0,
    WarehouseLocation NVARCHAR(50) NULL,
    LastUpdated DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Inventory_Plants FOREIGN KEY (PlantID) REFERENCES Plants(PlantID),
    CONSTRAINT FK_Inventory_Materials FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID),
    CONSTRAINT FK_Inventory_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT CK_Inventory_OneItemType CHECK (
        (MaterialID IS NOT NULL AND ProductID IS NULL) OR
        (MaterialID IS NULL AND ProductID IS NOT NULL)
    )
);
GO

-- =========================
-- 12. Purchase Orders
-- =========================
CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    PlantID INT NOT NULL,
    PONumber NVARCHAR(30) NOT NULL UNIQUE,
    OrderDate DATE NOT NULL,
    ExpectedDate DATE NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Open', 'Received', 'Cancelled')),
    TotalAmount DECIMAL(14,2) NOT NULL DEFAULT 0 CHECK (TotalAmount >= 0),
    CONSTRAINT FK_PurchaseOrders_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT FK_PurchaseOrders_Plants FOREIGN KEY (PlantID) REFERENCES Plants(PlantID)
);
GO

-- =========================
-- 13. Purchase Order Lines
-- =========================
CREATE TABLE PurchaseOrderLines (
    PurchaseOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseOrderID INT NOT NULL,
    MaterialID INT NOT NULL,
    OrderedQty DECIMAL(12,2) NOT NULL CHECK (OrderedQty > 0),
    ReceivedQty DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (ReceivedQty >= 0),
    UnitPrice DECIMAL(12,2) NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT FK_POLines_PO FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID),
    CONSTRAINT FK_POLines_Material FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);
GO

-- =========================
-- 14. Quality Inspections
-- =========================
CREATE TABLE QualityInspections (
    InspectionID INT IDENTITY(1,1) PRIMARY KEY,
    WorkOrderID INT NOT NULL,
    InspectorID INT NOT NULL,
    InspectionDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    PassedQty INT NOT NULL CHECK (PassedQty >= 0),
    FailedQty INT NOT NULL CHECK (FailedQty >= 0),
    DefectRate AS (
        CASE 
            WHEN (PassedQty + FailedQty) = 0 THEN 0
            ELSE CAST(FailedQty * 100.0 / (PassedQty + FailedQty) AS DECIMAL(5,2))
        END
    ),
    Notes NVARCHAR(500) NULL,
    CONSTRAINT FK_QualityInspections_WorkOrders FOREIGN KEY (WorkOrderID) REFERENCES WorkOrders(WorkOrderID),
    CONSTRAINT FK_QualityInspections_Employees FOREIGN KEY (InspectorID) REFERENCES Employees(EmployeeID)
);
GO

-- =========================
-- 15. Maintenance Logs
-- =========================
CREATE TABLE MaintenanceLogs (
    MaintenanceID INT IDENTITY(1,1) PRIMARY KEY,
    MachineID INT NOT NULL,
    TechnicianID INT NOT NULL,
    MaintenanceDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    MaintenanceType NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500) NULL,
    DowntimeHours DECIMAL(8,2) NOT NULL DEFAULT 0 CHECK (DowntimeHours >= 0),
    Cost DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (Cost >= 0),
    CONSTRAINT FK_MaintenanceLogs_Machines FOREIGN KEY (MachineID) REFERENCES Machines(MachineID),
    CONSTRAINT FK_MaintenanceLogs_Employees FOREIGN KEY (TechnicianID) REFERENCES Employees(EmployeeID)
);
GO
-- ========================================
-- 16. Machine Sensors
-- ========================================
CREATE TABLE MachineSensors (
    SensorID INT IDENTITY(1,1) PRIMARY KEY,
    MachineID INT NOT NULL,
    SensorCode NVARCHAR(50) NOT NULL UNIQUE,
    SensorName NVARCHAR(100) NOT NULL,
    SensorType NVARCHAR(50) NOT NULL CHECK (
        SensorType IN (
            'Temperature',
            'Vibration',
            'Pressure',
            'Humidity',
            'Power',
            'Current',
            'Voltage',
            'RPM',
            'Flow',
            'OilLevel'
        )
    ),
    UnitOfMeasure NVARCHAR(20) NOT NULL,
    MinAcceptableValue DECIMAL(18,4) NULL,
    MaxAcceptableValue DECIMAL(18,4) NULL,
    InstalledDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_MachineSensors_Machines
        FOREIGN KEY (MachineID) REFERENCES Machines(MachineID)
);
GO

-- ========================================
-- 17. Machine Sensor Readings
-- ========================================
CREATE TABLE MachineSensorReadings (
    ReadingID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SensorID INT NOT NULL,
    MachineID INT NOT NULL,
    ReadingTime DATETIME2 NOT NULL,
    ReadingValue DECIMAL(18,4) NOT NULL,
    Status NVARCHAR(20) NOT NULL CHECK (
        Status IN ('Normal', 'Warning', 'Critical', 'Offline')
    ),
    QualityFlag NVARCHAR(20) NOT NULL DEFAULT 'Good' CHECK (
        QualityFlag IN ('Good', 'Estimated', 'Bad', 'Missing')
    ),
    RecordedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_MachineSensorReadings_Sensors
        FOREIGN KEY (SensorID) REFERENCES MachineSensors(SensorID),
    CONSTRAINT FK_MachineSensorReadings_Machines
        FOREIGN KEY (MachineID) REFERENCES Machines(MachineID)
);
GO

CREATE INDEX IX_MachineSensorReadings_MachineID_ReadingTime
    ON MachineSensorReadings (MachineID, ReadingTime DESC);
GO

CREATE INDEX IX_MachineSensorReadings_SensorID_ReadingTime
    ON MachineSensorReadings (SensorID, ReadingTime DESC);
GO

CREATE INDEX IX_MachineSensors_MachineID
    ON MachineSensors (MachineID);
GO

ALTER TABLE MachineSensors
ADD CONSTRAINT UQ_MachineSensors_SensorID_MachineID
UNIQUE (SensorID, MachineID);
GO

ALTER TABLE MachineSensorReadings
ADD CONSTRAINT FK_MachineSensorReadings_SensorMachine
FOREIGN KEY (SensorID, MachineID)
REFERENCES MachineSensors (SensorID, MachineID);
GO
