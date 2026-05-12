
CREATE DATABASE ManufacturingDB;
GO

USE ManufacturingDB;
GO

CREATE TABLE Plants (
    PlantID INT IDENTITY(1,1) PRIMARY KEY,
    PlantName NVARCHAR(100),
    Location NVARCHAR(150),
    PlantCode NVARCHAR(20) UNIQUE,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT,
    DepartmentName NVARCHAR(100),
    DepartmentCode NVARCHAR(20),
    FOREIGN KEY (PlantID) REFERENCES Plants(PlantID)
);
GO

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    JobTitle NVARCHAR(100),
    HireDate DATE,
    Shift NVARCHAR(20),
    Salary DECIMAL(12,2),
    Email NVARCHAR(120),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(150),
    ContactName NVARCHAR(100),
    Phone NVARCHAR(30),
    Email NVARCHAR(120),
    City NVARCHAR(100),
    Country NVARCHAR(100),
    IsPreferred BIT DEFAULT 0
);
GO

CREATE TABLE RawMaterials (
    MaterialID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialCode NVARCHAR(30) UNIQUE,
    MaterialName NVARCHAR(120),
    UnitOfMeasure NVARCHAR(20),
    StandardCost DECIMAL(12,2),
    ReorderLevel DECIMAL(12,2)
);
GO

CREATE TABLE SupplierMaterials (
    SupplierID INT,
    MaterialID INT,
    LeadTimeDays INT,
    LastPurchasePrice DECIMAL(12,2),
    PRIMARY KEY (SupplierID, MaterialID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);
GO

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductCode NVARCHAR(30) UNIQUE,
    ProductName NVARCHAR(120),
    ProductCategory NVARCHAR(50),
    StandardCost DECIMAL(12,2),
    ListPrice DECIMAL(12,2),
    IsActive BIT DEFAULT 1
);
GO

CREATE TABLE BillOfMaterials (
    BOMID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    MaterialID INT,
    QuantityRequired DECIMAL(12,4),
    ScrapFactorPercent DECIMAL(5,2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);
GO

CREATE TABLE Machines (
    MachineID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT,
    MachineCode NVARCHAR(30) UNIQUE,
    MachineName NVARCHAR(100),
    MachineType NVARCHAR(50),
    PurchaseDate DATE,
    Status NVARCHAR(20),
    FOREIGN KEY (PlantID) REFERENCES Plants(PlantID)
);
GO

CREATE TABLE WorkOrders (
    WorkOrderID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    PlantID INT,
    MachineID INT,
    SupervisorID INT,
    WorkOrderNumber NVARCHAR(30) UNIQUE,
    PlannedQuantity INT,
    ProducedQuantity INT,
    ScrapQuantity INT,
    StartDate DATETIME2,
    EndDate DATETIME2,
    Status NVARCHAR(20),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (PlantID) REFERENCES Plants(PlantID),
    FOREIGN KEY (MachineID) REFERENCES Machines(MachineID),
    FOREIGN KEY (SupervisorID) REFERENCES Employees(EmployeeID)
);
GO

CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT,
    MaterialID INT NULL,
    ProductID INT NULL,
    QuantityOnHand DECIMAL(14,2),
    WarehouseLocation NVARCHAR(50),
    LastUpdated DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (PlantID) REFERENCES Plants(PlantID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    PlantID INT,
    PONumber NVARCHAR(30) UNIQUE,
    OrderDate DATE,
    ExpectedDate DATE,
    Status NVARCHAR(20),
    TotalAmount DECIMAL(14,2),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (PlantID) REFERENCES Plants(PlantID)
);
GO

CREATE TABLE PurchaseOrderLines (
    PurchaseOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseOrderID INT,
    MaterialID INT,
    OrderedQty DECIMAL(12,2),
    ReceivedQty DECIMAL(12,2),
    UnitPrice DECIMAL(12,2),
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);
GO

CREATE TABLE QualityInspections (
    InspectionID INT IDENTITY(1,1) PRIMARY KEY,
    WorkOrderID INT,
    InspectorID INT,
    InspectionDate DATETIME2,
    PassedQty INT,
    FailedQty INT,
    Notes NVARCHAR(500),
    FOREIGN KEY (WorkOrderID) REFERENCES WorkOrders(WorkOrderID),
    FOREIGN KEY (InspectorID) REFERENCES Employees(EmployeeID)
);
GO

CREATE TABLE MaintenanceLogs (
    MaintenanceID INT IDENTITY(1,1) PRIMARY KEY,
    MachineID INT,
    TechnicianID INT,
    MaintenanceDate DATETIME2,
    MaintenanceType NVARCHAR(50),
    Description NVARCHAR(500),
    DowntimeHours DECIMAL(8,2),
    Cost DECIMAL(12,2),
    FOREIGN KEY (MachineID) REFERENCES Machines(MachineID),
    FOREIGN KEY (TechnicianID) REFERENCES Employees(EmployeeID)
);
GO

CREATE TABLE MachineSensors (
    SensorID INT IDENTITY(1,1) PRIMARY KEY,
    MachineID INT,
    SensorCode NVARCHAR(50) UNIQUE,
    SensorName NVARCHAR(100),
    SensorType NVARCHAR(50),
    UnitOfMeasure NVARCHAR(20),
    MinAcceptableValue DECIMAL(18,4),
    MaxAcceptableValue DECIMAL(18,4),
    InstalledDate DATE DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (MachineID) REFERENCES Machines(MachineID)
);
GO

CREATE TABLE MachineSensorReadings (
    ReadingID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SensorID INT,
    MachineID INT,
    ReadingTime DATETIME2,
    ReadingValue DECIMAL(18,4),
    Status NVARCHAR(20),
    QualityFlag NVARCHAR(20),
    RecordedAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (SensorID) REFERENCES MachineSensors(SensorID),
    FOREIGN KEY (MachineID) REFERENCES Machines(MachineID)
);
GO

CREATE INDEX IX_MachineSensorReadings_MachineID_ReadingTime
ON MachineSensorReadings (MachineID, ReadingTime DESC);
GO

CREATE INDEX IX_MachineSensorReadings_SensorID_ReadingTime
ON MachineSensorReadings (SensorID, ReadingTime DESC);
GO
