USE ManufacturingDB;
GO

SET NOCOUNT ON;
GO

------------------------------------------------------------
-- 1) PLANTS
------------------------------------------------------------
INSERT INTO Plants (PlantName, Location, PlantCode)
SELECT v.PlantName, v.Location, v.PlantCode
FROM (VALUES
    ('Midwest Components Plant', 'Cleveland, Ohio, USA', 'PLT-CLV'),
    ('Gulf Coast Fabrication Plant', 'Houston, Texas, USA', 'PLT-HOU'),
    ('Southeast Assembly Center', 'Greenville, South Carolina, USA', 'PLT-GVL'),
    ('Great Lakes Machining Plant', 'Grand Rapids, Michigan, USA', 'PLT-GRP'),
    ('Southwest Plastics Plant', 'Mesa, Arizona, USA', 'PLT-MSA'),
    ('Northern Valve Works', 'Milwaukee, Wisconsin, USA', 'PLT-MKE'),
    ('Precision Motion Plant', 'Indianapolis, Indiana, USA', 'PLT-IND'),
    ('Industrial Controls Facility', 'Charlotte, North Carolina, USA', 'PLT-CLT')
) v(PlantName, Location, PlantCode)
WHERE NOT EXISTS (
    SELECT 1 FROM Plants p WHERE p.PlantCode = v.PlantCode
);
GO

------------------------------------------------------------
-- 2) DEPARTMENTS FOR PLANTS
------------------------------------------------------------
INSERT INTO Departments (PlantID, DepartmentName, DepartmentCode)
SELECT p.PlantID, d.DepartmentName, d.DepartmentCode
FROM Plants p
CROSS JOIN (VALUES
    ('Production', 'PROD'),
    ('Quality Control', 'QC'),
    ('Maintenance', 'MNT'),
    ('Warehouse', 'WH'),
    ('Engineering', 'ENG'),
    ('Planning', 'PLAN')
) d(DepartmentName, DepartmentCode)
WHERE NOT EXISTS (
    SELECT 1
    FROM Departments x
    WHERE x.PlantID = p.PlantID
      AND x.DepartmentCode = d.DepartmentCode
);
GO

------------------------------------------------------------
-- 3) SUPPLIERS
------------------------------------------------------------
INSERT INTO Suppliers (SupplierName, ContactName, Phone, Email, City, Country, IsPreferred)
SELECT s.SupplierName, s.ContactName, s.Phone, s.Email, s.City, s.Country, s.IsPreferred
FROM (VALUES
    ('Arcelor Metals North America', 'Monica Reyes', '216-555-1001', 'mreyes@arcelormetalsna.com', 'Cleveland', 'USA', 1),
    ('Great Lakes Fastener Co.', 'Brian O''Connell', '313-555-1002', 'boconnell@glfastener.com', 'Detroit', 'USA', 1),
    ('PolyChem Resins LLC', 'Nina Patel', '713-555-1003', 'npatel@polychemresins.com', 'Houston', 'USA', 1),
    ('Tri-State Industrial Coatings', 'Victor Alvarez', '414-555-1004', 'valvarez@tscoatings.com', 'Milwaukee', 'USA', 0),
    ('Midwest Seals & Gaskets', 'Erin Walsh', '317-555-1005', 'ewalsh@mwseals.com', 'Indianapolis', 'USA', 1),
    ('Blue Ridge Electronics Supply', 'Kevin Turner', '704-555-1006', 'kturner@br-electronics.com', 'Charlotte', 'USA', 0),
    ('Precision Bearing Partners', 'Laura Simmons', '616-555-1007', 'lsimmons@pbpartners.com', 'Grand Rapids', 'USA', 1),
    ('Sunbelt Packaging Group', 'David Morales', '602-555-1008', 'dmorales@sunbeltpkg.com', 'Phoenix', 'USA', 0),
    ('Allied Pneumatics Inc.', 'Rachel Kim', '248-555-1009', 'rkim@alliedpneumatics.com', 'Auburn Hills', 'USA', 1),
    ('Southern Steel Service Center', 'Anthony Brooks', '864-555-1010', 'abrooks@southernsteelservice.com', 'Greenville', 'USA', 1),
    ('Continental Machined Parts', 'Heather Cole', '312-555-1011', 'hcole@continentalmp.com', 'Chicago', 'USA', 0),
    ('Industrial Lubricants Group', 'Mark Jensen', '414-555-1012', 'mjensen@indlube.com', 'Milwaukee', 'USA', 0)
) s(SupplierName, ContactName, Phone, Email, City, Country, IsPreferred)
WHERE NOT EXISTS (
    SELECT 1 FROM Suppliers x WHERE x.SupplierName = s.SupplierName
);
GO

------------------------------------------------------------
-- 4) RAW MATERIALS
------------------------------------------------------------
INSERT INTO RawMaterials (MaterialCode, MaterialName, UnitOfMeasure, StandardCost, ReorderLevel)
SELECT m.MaterialCode, m.MaterialName, m.UnitOfMeasure, m.StandardCost, m.ReorderLevel
FROM (VALUES
    ('RM-STEEL-1018', '1018 Carbon Steel Bar', 'KG', 2.85, 1800),
    ('RM-STEEL-SS304', '304 Stainless Steel Sheet', 'KG', 5.90, 1200),
    ('RM-AL-6061', '6061 Aluminum Billet', 'KG', 4.75, 900),
    ('RM-BRASS-C360', 'C360 Brass Rod', 'KG', 6.20, 700),
    ('RM-BOLT-M8', 'M8 Zinc-Plated Hex Bolt', 'EA', 0.18, 15000),
    ('RM-BOLT-M10', 'M10 Zinc-Plated Hex Bolt', 'EA', 0.24, 12000),
    ('RM-NUT-M8', 'M8 Hex Nut', 'EA', 0.08, 18000),
    ('RM-NUT-M10', 'M10 Hex Nut', 'EA', 0.11, 15000),
    ('RM-WASH-M8', 'M8 Flat Washer', 'EA', 0.03, 25000),
    ('RM-SEAL-NBR', 'Nitrile Rubber Seal', 'EA', 0.65, 6000),
    ('RM-SEAL-VITON', 'Viton High-Temp Seal', 'EA', 1.15, 4000),
    ('RM-BEAR-6205', '6205 Deep Groove Bearing', 'EA', 4.90, 2500),
    ('RM-SHAFT-4140', '4140 Alloy Steel Shaft Blank', 'EA', 11.50, 1200),
    ('RM-COPPER-18AWG', '18 AWG Copper Wire', 'M', 0.42, 5000),
    ('RM-PCB-CTRL', 'Control PCB Board', 'EA', 14.80, 1500),
    ('RM-SENSOR-PRES', 'Pressure Sensor Module', 'EA', 18.50, 900),
    ('RM-RESIN-ABS', 'ABS Plastic Resin', 'KG', 2.10, 2200),
    ('RM-RESIN-NYLON', 'Nylon 6 Resin', 'KG', 2.85, 1700),
    ('RM-PAINT-EPOXY', 'Epoxy Industrial Coating', 'L', 13.40, 450),
    ('RM-LUBE-HYD', 'Hydraulic Oil ISO 46', 'L', 5.25, 600),
    ('RM-PACK-BOX-L', 'Large Corrugated Shipping Box', 'EA', 1.05, 3000),
    ('RM-PACK-FOAM', 'Protective Foam Insert', 'EA', 0.72, 3000),
    ('RM-LABEL-SAFETY', 'Safety Compliance Label', 'EA', 0.09, 8000),
    ('RM-SOLENOID-24V', '24V Solenoid Coil', 'EA', 9.60, 900),
    ('RM-VALVE-BODY', 'Forged Valve Body Blank', 'EA', 16.25, 950)
) m(MaterialCode, MaterialName, UnitOfMeasure, StandardCost, ReorderLevel)
WHERE NOT EXISTS (
    SELECT 1 FROM RawMaterials x WHERE x.MaterialCode = m.MaterialCode
);
GO

------------------------------------------------------------
-- 5) PRODUCTS
------------------------------------------------------------
INSERT INTO Products (ProductCode, ProductName, ProductCategory, StandardCost, ListPrice, IsActive)
SELECT p.ProductCode, p.ProductName, p.ProductCategory, p.StandardCost, p.ListPrice, 1
FROM (VALUES
    ('FG-PMP-100', 'Hydraulic Pump Assembly 100 Series', 'Fluid Power', 118.00, 189.00),
    ('FG-PMP-200', 'Hydraulic Pump Assembly 200 Series', 'Fluid Power', 142.00, 229.00),
    ('FG-VAL-110', 'Industrial Control Valve 1.5in', 'Flow Control', 84.00, 139.00),
    ('FG-VAL-210', 'Industrial Control Valve 2in', 'Flow Control', 109.00, 174.00),
    ('FG-ACT-050', 'Linear Actuator 50mm Stroke', 'Motion Control', 96.00, 158.00),
    ('FG-ACT-100', 'Linear Actuator 100mm Stroke', 'Motion Control', 122.00, 198.00),
    ('FG-HSG-ABS', 'ABS Equipment Housing', 'Enclosures', 28.00, 54.00),
    ('FG-HSG-NYL', 'Nylon Reinforced Equipment Housing', 'Enclosures', 34.00, 64.00),
    ('FG-PNL-CTRL', 'Control Panel Assembly', 'Electrical', 156.00, 269.00),
    ('FG-MNF-REG', 'Pressure Regulator Module', 'Flow Control', 74.00, 124.00),
    ('FG-SKD-DRV', 'Pump Drive Skid', 'Systems', 460.00, 720.00),
    ('FG-MTR-MNT', 'Motor Mount Bracket', 'Mechanical', 22.00, 45.00)
) p(ProductCode, ProductName, ProductCategory, StandardCost, ListPrice)
WHERE NOT EXISTS (
    SELECT 1 FROM Products x WHERE x.ProductCode = p.ProductCode
);
GO

------------------------------------------------------------
-- 6) SUPPLIER-MATERIAL MAPPINGS
------------------------------------------------------------
INSERT INTO SupplierMaterials (SupplierID, MaterialID, LeadTimeDays, LastPurchasePrice)
SELECT s.SupplierID, m.MaterialID, sm.LeadTimeDays, sm.LastPurchasePrice
FROM (
    VALUES
    ('Arcelor Metals North America', '1018 Carbon Steel Bar', 7, 2.74),
    ('Arcelor Metals North America', '304 Stainless Steel Sheet', 9, 5.72),
    ('Arcelor Metals North America', '6061 Aluminum Billet', 8, 4.66),
    ('Southern Steel Service Center', '1018 Carbon Steel Bar', 6, 2.79),
    ('Southern Steel Service Center', '4140 Alloy Steel Shaft Blank', 8, 11.20),
    ('Great Lakes Fastener Co.', 'M8 Zinc-Plated Hex Bolt', 5, 0.17),
    ('Great Lakes Fastener Co.', 'M10 Zinc-Plated Hex Bolt', 5, 0.23),
    ('Great Lakes Fastener Co.', 'M8 Hex Nut', 4, 0.07),
    ('Great Lakes Fastener Co.', 'M10 Hex Nut', 4, 0.10),
    ('Great Lakes Fastener Co.', 'M8 Flat Washer', 4, 0.03),
    ('PolyChem Resins LLC', 'ABS Plastic Resin', 6, 2.03),
    ('PolyChem Resins LLC', 'Nylon 6 Resin', 7, 2.74),
    ('Tri-State Industrial Coatings', 'Epoxy Industrial Coating', 10, 12.95),
    ('Midwest Seals & Gaskets', 'Nitrile Rubber Seal', 8, 0.61),
    ('Midwest Seals & Gaskets', 'Viton High-Temp Seal', 9, 1.09),
    ('Precision Bearing Partners', '6205 Deep Groove Bearing', 6, 4.76),
    ('Blue Ridge Electronics Supply', 'Control PCB Board', 12, 14.25),
    ('Blue Ridge Electronics Supply', 'Pressure Sensor Module', 11, 17.95),
    ('Blue Ridge Electronics Supply', '24V Solenoid Coil', 10, 9.32),
    ('Allied Pneumatics Inc.', '24V Solenoid Coil', 9, 9.40),
    ('Allied Pneumatics Inc.', 'Pressure Sensor Module', 10, 18.05),
    ('Industrial Lubricants Group', 'Hydraulic Oil ISO 46', 5, 5.04),
    ('Sunbelt Packaging Group', 'Large Corrugated Shipping Box', 6, 0.99),
    ('Sunbelt Packaging Group', 'Protective Foam Insert', 7, 0.68),
    ('Sunbelt Packaging Group', 'Safety Compliance Label', 4, 0.08),
    ('Continental Machined Parts', 'Forged Valve Body Blank', 10, 15.80),
    ('Continental Machined Parts', '4140 Alloy Steel Shaft Blank', 9, 11.35),
    ('Blue Ridge Electronics Supply', '18 AWG Copper Wire', 8, 0.39),
    ('Arcelor Metals North America', 'C360 Brass Rod', 7, 6.05)
) sm(SupplierName, MaterialName, LeadTimeDays, LastPurchasePrice)
JOIN Suppliers s ON s.SupplierName = sm.SupplierName
JOIN RawMaterials m ON m.MaterialName = sm.MaterialName
WHERE NOT EXISTS (
    SELECT 1
    FROM SupplierMaterials x
    WHERE x.SupplierID = s.SupplierID
      AND x.MaterialID = m.MaterialID
);
GO

------------------------------------------------------------
-- 7) BILL OF MATERIALS
-- Product-to-product subassembly rows excluded because this schema only supports Product -> RawMaterial.
------------------------------------------------------------
INSERT INTO BillOfMaterials (ProductID, MaterialID, QuantityRequired, ScrapFactorPercent)
SELECT p.ProductID, m.MaterialID, b.QuantityRequired, b.ScrapFactorPercent
FROM (
    VALUES
    ('Hydraulic Pump Assembly 100 Series', '1018 Carbon Steel Bar', 9.5000, 2.50),
    ('Hydraulic Pump Assembly 100 Series', 'M8 Zinc-Plated Hex Bolt', 12.0000, 1.00),
    ('Hydraulic Pump Assembly 100 Series', 'M8 Hex Nut', 12.0000, 1.00),
    ('Hydraulic Pump Assembly 100 Series', 'M8 Flat Washer', 12.0000, 1.00),
    ('Hydraulic Pump Assembly 100 Series', 'Nitrile Rubber Seal', 2.0000, 0.50),
    ('Hydraulic Pump Assembly 100 Series', '6205 Deep Groove Bearing', 2.0000, 0.50),
    ('Hydraulic Pump Assembly 100 Series', 'Hydraulic Oil ISO 46', 0.7500, 1.00),
    ('Hydraulic Pump Assembly 200 Series', '1018 Carbon Steel Bar', 12.5000, 2.50),
    ('Hydraulic Pump Assembly 200 Series', '4140 Alloy Steel Shaft Blank', 1.0000, 1.50),
    ('Hydraulic Pump Assembly 200 Series', 'M10 Zinc-Plated Hex Bolt', 16.0000, 1.00),
    ('Hydraulic Pump Assembly 200 Series', 'M10 Hex Nut', 16.0000, 1.00),
    ('Hydraulic Pump Assembly 200 Series', 'Viton High-Temp Seal', 2.0000, 0.50),
    ('Hydraulic Pump Assembly 200 Series', '6205 Deep Groove Bearing', 2.0000, 0.50),
    ('Hydraulic Pump Assembly 200 Series', 'Hydraulic Oil ISO 46', 1.1000, 1.00),
    ('Industrial Control Valve 1.5in', 'Forged Valve Body Blank', 1.0000, 1.00),
    ('Industrial Control Valve 1.5in', 'M8 Zinc-Plated Hex Bolt', 8.0000, 1.00),
    ('Industrial Control Valve 1.5in', 'M8 Hex Nut', 8.0000, 1.00),
    ('Industrial Control Valve 1.5in', 'Nitrile Rubber Seal', 1.0000, 0.50),
    ('Industrial Control Valve 1.5in', '24V Solenoid Coil', 1.0000, 0.25),
    ('Industrial Control Valve 2in', 'Forged Valve Body Blank', 1.0000, 1.00),
    ('Industrial Control Valve 2in', 'M10 Zinc-Plated Hex Bolt', 10.0000, 1.00),
    ('Industrial Control Valve 2in', 'M10 Hex Nut', 10.0000, 1.00),
    ('Industrial Control Valve 2in', 'Viton High-Temp Seal', 1.0000, 0.50),
    ('Industrial Control Valve 2in', '24V Solenoid Coil', 1.0000, 0.25),
    ('Linear Actuator 50mm Stroke', '6061 Aluminum Billet', 4.0000, 2.00),
    ('Linear Actuator 50mm Stroke', '4140 Alloy Steel Shaft Blank', 1.0000, 1.00),
    ('Linear Actuator 50mm Stroke', '6205 Deep Groove Bearing', 2.0000, 0.50),
    ('Linear Actuator 50mm Stroke', 'M8 Zinc-Plated Hex Bolt', 6.0000, 1.00),
    ('Linear Actuator 50mm Stroke', 'Pressure Sensor Module', 1.0000, 0.25),
    ('Linear Actuator 100mm Stroke', '6061 Aluminum Billet', 5.5000, 2.00),
    ('Linear Actuator 100mm Stroke', '4140 Alloy Steel Shaft Blank', 1.0000, 1.00),
    ('Linear Actuator 100mm Stroke', '6205 Deep Groove Bearing', 2.0000, 0.50),
    ('Linear Actuator 100mm Stroke', 'M10 Zinc-Plated Hex Bolt', 8.0000, 1.00),
    ('Linear Actuator 100mm Stroke', 'Pressure Sensor Module', 1.0000, 0.25),
    ('ABS Equipment Housing', 'ABS Plastic Resin', 3.8000, 3.00),
    ('ABS Equipment Housing', 'Epoxy Industrial Coating', 0.2200, 1.00),
    ('ABS Equipment Housing', 'Safety Compliance Label', 1.0000, 0.00),
    ('Nylon Reinforced Equipment Housing', 'Nylon 6 Resin', 4.1000, 3.00),
    ('Nylon Reinforced Equipment Housing', 'Epoxy Industrial Coating', 0.2500, 1.00),
    ('Nylon Reinforced Equipment Housing', 'Safety Compliance Label', 1.0000, 0.00),
    ('Control Panel Assembly', 'Control PCB Board', 1.0000, 0.25),
    ('Control Panel Assembly', 'Pressure Sensor Module', 2.0000, 0.25),
    ('Control Panel Assembly', '18 AWG Copper Wire', 6.5000, 1.00),
    ('Control Panel Assembly', 'ABS Plastic Resin', 2.2000, 2.50),
    ('Control Panel Assembly', 'M8 Zinc-Plated Hex Bolt', 8.0000, 1.00),
    ('Control Panel Assembly', 'Safety Compliance Label', 2.0000, 0.00),
    ('Pressure Regulator Module', 'Forged Valve Body Blank', 1.0000, 1.00),
    ('Pressure Regulator Module', 'Pressure Sensor Module', 1.0000, 0.25),
    ('Pressure Regulator Module', '24V Solenoid Coil', 1.0000, 0.25),
    ('Pressure Regulator Module', 'Nitrile Rubber Seal', 1.0000, 0.50),
    ('Pump Drive Skid', '1018 Carbon Steel Bar', 22.0000, 2.50),
    ('Motor Mount Bracket', '1018 Carbon Steel Bar', 2.5000, 2.00),
    ('Motor Mount Bracket', 'M10 Zinc-Plated Hex Bolt', 4.0000, 1.00),
    ('Motor Mount Bracket', 'M10 Hex Nut', 4.0000, 1.00),
    ('Motor Mount Bracket', 'Epoxy Industrial Coating', 0.1000, 1.00)
) b(ProductName, MaterialName, QuantityRequired, ScrapFactorPercent)
JOIN Products p ON p.ProductName = b.ProductName
JOIN RawMaterials m ON m.MaterialName = b.MaterialName
WHERE NOT EXISTS (
    SELECT 1
    FROM BillOfMaterials x
    WHERE x.ProductID = p.ProductID
      AND x.MaterialID = m.MaterialID
);
GO

------------------------------------------------------------
-- 8) MACHINES
------------------------------------------------------------
INSERT INTO Machines (PlantID, MachineCode, MachineName, MachineType, PurchaseDate, Status)
SELECT p.PlantID, v.MachineCode, v.MachineName, v.MachineType, v.PurchaseDate, v.Status
FROM (VALUES
    ('PLT-CLV', 'MC-CNC-01', 'CNC Cutter 01', 'CNC', '2020-01-15', 'Running'),
    ('PLT-CLV', 'MC-CLV-CNC-01', 'Mazak CNC Cell 01', 'CNC', '2019-03-15', 'Running'),
    ('PLT-CLV', 'MC-CLV-CNC-02', 'Haas VF-4 Mill 02', 'CNC', '2020-07-18', 'Running'),
    ('PLT-CLV', 'MC-CLV-ASM-01', 'Pump Assembly Line A', 'Assembly', '2021-02-10', 'Running'),
    ('PLT-HOU', 'MC-HOU-PRS-01', '400T Hydraulic Press 01', 'Press', '2018-11-05', 'Running'),
    ('PLT-HOU', 'MC-HOU-VLV-01', 'Valve Body Machining Cell', 'CNC', '2020-05-20', 'Running'),
    ('PLT-GVL', 'MC-GVL-ASM-01', 'Actuator Assembly Line 1', 'Assembly', '2022-01-14', 'Running'),
    ('PLT-GVL', 'MC-GVL-QC-01', 'Vision Inspection Station', 'Inspection', '2022-06-09', 'Running'),
    ('PLT-GRP', 'MC-GRP-CNC-01', 'Okuma Turning Center', 'CNC', '2019-08-30', 'Maintenance'),
    ('PLT-GRP', 'MC-GRP-GRD-01', 'Surface Grinder 01', 'Grinding', '2017-09-11', 'Running'),
    ('PLT-MSA', 'MC-MSA-INJ-01', 'ABS Injection Molder 01', 'Injection Molding', '2021-04-28', 'Running'),
    ('PLT-MSA', 'MC-MSA-INJ-02', 'Nylon Injection Molder 02', 'Injection Molding', '2022-03-17', 'Running'),
    ('PLT-MKE', 'MC-MKE-VLV-01', 'Valve Assembly Bench 01', 'Assembly', '2020-10-07', 'Running'),
    ('PLT-IND', 'MC-IND-WEL-01', 'Skid Weld Station 01', 'Welding', '2018-12-13', 'Running'),
    ('PLT-IND', 'MC-IND-PNT-01', 'Powder Coat Booth 01', 'Coating', '2019-06-21', 'Running'),
    ('PLT-CLT', 'MC-CLT-CTRL-01', 'Control Panel Build Line', 'Electrical Assembly', '2021-08-04', 'Running')
) v(PlantCode, MachineCode, MachineName, MachineType, PurchaseDate, Status)
JOIN Plants p ON p.PlantCode = v.PlantCode
WHERE NOT EXISTS (
    SELECT 1 FROM Machines x WHERE x.MachineCode = v.MachineCode
);
GO

------------------------------------------------------------
-- 9) EMPLOYEES
------------------------------------------------------------
;WITH EmployeeSeed AS (
    SELECT *
    FROM (VALUES
        ('Production', 'Daniel', 'Murphy', 'Production Supervisor', 'Day', 78000),
        ('Production', 'Angela', 'Foster', 'Production Planner', 'Day', 71000),
        ('Production', 'Luis', 'Martinez', 'Machine Operator', 'Day', 52000),
        ('Production', 'Tyler', 'Bennett', 'Machine Operator', 'Night', 54000),
        ('Production', 'Jasmine', 'Reed', 'Assembly Technician', 'Rotating', 49500),
        ('Quality Control', 'Olivia', 'Parker', 'Quality Engineer', 'Day', 76000),
        ('Quality Control', 'Sean', 'Mitchell', 'Quality Inspector', 'Day', 56000),
        ('Quality Control', 'Maya', 'Hughes', 'Quality Inspector', 'Night', 57500),
        ('Maintenance', 'Corey', 'Sanders', 'Maintenance Technician', 'Night', 61000),
        ('Maintenance', 'Peter', 'Nguyen', 'Reliability Technician', 'Day', 66000),
        ('Warehouse', 'Alicia', 'Ward', 'Warehouse Coordinator', 'Day', 51500),
        ('Warehouse', 'Brandon', 'Price', 'Forklift Operator', 'Rotating', 47000),
        ('Engineering', 'Ethan', 'Collins', 'Manufacturing Engineer', 'Day', 86000),
        ('Engineering', 'Sophia', 'Bryant', 'Process Engineer', 'Day', 89500),
        ('Planning', 'Grace', 'Diaz', 'Production Scheduler', 'Day', 69000)
    ) e(DepartmentName, FirstName, LastName, JobTitle, Shift, Salary)
),
TargetPlants AS (
    SELECT PlantID, PlantCode
    FROM Plants
    WHERE PlantCode IN ('PLT-CLV','PLT-HOU','PLT-GVL','PLT-GRP','PLT-MSA','PLT-MKE','PLT-IND','PLT-CLT')
)
INSERT INTO Employees (DepartmentID, FirstName, LastName, JobTitle, HireDate, Shift, Salary, Email, IsActive)
SELECT
    d.DepartmentID,
    e.FirstName,
    e.LastName + CASE WHEN tp.PlantCode = 'PLT-CLV' THEN '' ELSE ' ' + RIGHT(tp.PlantCode,3) END,
    e.JobTitle,
    DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 2200), CAST(GETDATE() AS DATE)),
    e.Shift,
    e.Salary + ((ABS(CHECKSUM(NEWID())) % 9) * 750),
    LOWER(e.FirstName + '.' + REPLACE(e.LastName, ' ', '') + '.' + RIGHT(tp.PlantCode,3) + '@factoryops.com'),
    1
FROM EmployeeSeed e
JOIN TargetPlants tp ON 1 = 1
JOIN Departments d ON d.PlantID = tp.PlantID AND d.DepartmentName = e.DepartmentName
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees x
    WHERE x.Email = LOWER(e.FirstName + '.' + REPLACE(e.LastName, ' ', '') + '.' + RIGHT(tp.PlantCode,3) + '@factoryops.com')
);
GO

------------------------------------------------------------
-- 10) INVENTORY - RAW MATERIALS
------------------------------------------------------------
INSERT INTO Inventory (PlantID, MaterialID, ProductID, QuantityOnHand, WarehouseLocation, LastUpdated)
SELECT
    p.PlantID,
    m.MaterialID,
    NULL,
    CASE
        WHEN m.UnitOfMeasure = 'EA' THEN 1000 + (ABS(CHECKSUM(NEWID())) % 18000)
        WHEN m.UnitOfMeasure = 'KG' THEN 300 + (ABS(CHECKSUM(NEWID())) % 4500)
        WHEN m.UnitOfMeasure = 'L'  THEN 100 + (ABS(CHECKSUM(NEWID())) % 900)
        WHEN m.UnitOfMeasure = 'M'  THEN 500 + (ABS(CHECKSUM(NEWID())) % 5000)
        ELSE 100 + (ABS(CHECKSUM(NEWID())) % 1000)
    END,
    CASE
        WHEN m.UnitOfMeasure = 'EA' THEN 'FAST-' + RIGHT('00' + CAST((ABS(CHECKSUM(NEWID())) % 12) + 1 AS VARCHAR(2)), 2)
        WHEN m.UnitOfMeasure = 'KG' THEN 'BULK-' + RIGHT('00' + CAST((ABS(CHECKSUM(NEWID())) % 8) + 1 AS VARCHAR(2)), 2)
        WHEN m.UnitOfMeasure = 'L'  THEN 'CHEM-' + RIGHT('00' + CAST((ABS(CHECKSUM(NEWID())) % 5) + 1 AS VARCHAR(2)), 2)
        ELSE 'GEN-' + RIGHT('00' + CAST((ABS(CHECKSUM(NEWID())) % 10) + 1 AS VARCHAR(2)), 2)
    END,
    DATEADD(HOUR, -1 * (ABS(CHECKSUM(NEWID())) % 240), SYSDATETIME())
FROM Plants p
CROSS JOIN RawMaterials m
WHERE p.PlantCode IN ('PLT-CLV','PLT-HOU','PLT-GVL','PLT-GRP','PLT-MSA','PLT-MKE','PLT-IND','PLT-CLT')
  AND NOT EXISTS (
      SELECT 1
      FROM Inventory x
      WHERE x.PlantID = p.PlantID
        AND x.MaterialID = m.MaterialID
        AND x.ProductID IS NULL
  );
GO

------------------------------------------------------------
-- 11) INVENTORY - FINISHED GOODS
------------------------------------------------------------
INSERT INTO Inventory (PlantID, MaterialID, ProductID, QuantityOnHand, WarehouseLocation, LastUpdated)
SELECT
    p.PlantID,
    NULL,
    pr.ProductID,
    20 + (ABS(CHECKSUM(NEWID())) % 700),
    'FG-' + RIGHT('00' + CAST((ABS(CHECKSUM(NEWID())) % 20) + 1 AS VARCHAR(2)), 2),
    DATEADD(HOUR, -1 * (ABS(CHECKSUM(NEWID())) % 96), SYSDATETIME())
FROM Plants p
CROSS JOIN Products pr
WHERE p.PlantCode IN ('PLT-CLV','PLT-HOU','PLT-GVL','PLT-GRP','PLT-MSA','PLT-MKE','PLT-IND','PLT-CLT')
  AND NOT EXISTS (
      SELECT 1
      FROM Inventory x
      WHERE x.PlantID = p.PlantID
        AND x.ProductID = pr.ProductID
        AND x.MaterialID IS NULL
  );
GO

------------------------------------------------------------
-- 12) PURCHASE ORDERS
------------------------------------------------------------
;WITH SupplierPlant AS (
    SELECT
        s.SupplierID,
        p.PlantID,
        ROW_NUMBER() OVER (ORDER BY s.SupplierID, p.PlantID) AS rn
    FROM Suppliers s
    CROSS JOIN Plants p
    WHERE p.PlantCode IN ('PLT-CLV','PLT-HOU','PLT-GVL','PLT-GRP','PLT-MSA','PLT-MKE','PLT-IND','PLT-CLT')
),
POs AS (
    SELECT TOP (60)
        SupplierID,
        PlantID,
        ROW_NUMBER() OVER (ORDER BY rn) AS SeqNo
    FROM SupplierPlant
)
INSERT INTO PurchaseOrders (SupplierID, PlantID, PONumber, OrderDate, ExpectedDate, Status, TotalAmount)
SELECT
    SupplierID,
    PlantID,
    CONCAT('PO-2026-', RIGHT('0000' + CAST(SeqNo AS VARCHAR(4)), 4)),
    DATEADD(DAY, -1 * (SeqNo % 75), CAST(GETDATE() AS DATE)),
    DATEADD(DAY, 7 + (SeqNo % 12), DATEADD(DAY, -1 * (SeqNo % 75), CAST(GETDATE() AS DATE))),
    CASE
        WHEN SeqNo % 7 = 0 THEN 'Received'
        WHEN SeqNo % 11 = 0 THEN 'Cancelled'
        ELSE 'Open'
    END,
    CAST(0 AS DECIMAL(14,2))
FROM POs
WHERE NOT EXISTS (
    SELECT 1
    FROM PurchaseOrders x
    WHERE x.PONumber = CONCAT('PO-2026-', RIGHT('0000' + CAST(SeqNo AS VARCHAR(4)), 4))
);
GO

------------------------------------------------------------
-- 13) PURCHASE ORDER LINES - FIXED
------------------------------------------------------------
;WITH POBase AS (
    SELECT PurchaseOrderID, SupplierID, Status
    FROM PurchaseOrders
    WHERE PONumber LIKE 'PO-2026-%'
),
CandidateLines AS (
    SELECT
        po.PurchaseOrderID,
        sm.MaterialID,
        po.Status,
        ROW_NUMBER() OVER (
            PARTITION BY po.PurchaseOrderID
            ORDER BY sm.MaterialID
        ) AS rn,
        sm.LastPurchasePrice
    FROM POBase po
    JOIN SupplierMaterials sm ON sm.SupplierID = po.SupplierID
)
INSERT INTO PurchaseOrderLines (
    PurchaseOrderID,
    MaterialID,
    OrderedQty,
    ReceivedQty,
    UnitPrice
)
SELECT
    cl.PurchaseOrderID,
    cl.MaterialID,
    CASE
        WHEN m.UnitOfMeasure = 'EA' THEN 500 + (ABS(CHECKSUM(NEWID())) % 5000)
        WHEN m.UnitOfMeasure = 'KG' THEN 200 + (ABS(CHECKSUM(NEWID())) % 2500)
        WHEN m.UnitOfMeasure = 'L'  THEN 50 + (ABS(CHECKSUM(NEWID())) % 500)
        WHEN m.UnitOfMeasure = 'M'  THEN 200 + (ABS(CHECKSUM(NEWID())) % 2000)
        ELSE 100
    END,
    CASE
        WHEN cl.Status = 'Received' THEN
            CASE
                WHEN m.UnitOfMeasure = 'EA' THEN 500 + (ABS(CHECKSUM(NEWID())) % 5000)
                WHEN m.UnitOfMeasure = 'KG' THEN 200 + (ABS(CHECKSUM(NEWID())) % 2500)
                WHEN m.UnitOfMeasure = 'L'  THEN 50 + (ABS(CHECKSUM(NEWID())) % 500)
                WHEN m.UnitOfMeasure = 'M'  THEN 200 + (ABS(CHECKSUM(NEWID())) % 2000)
                ELSE 100
            END
        ELSE 0
    END,
    CAST(cl.LastPurchasePrice + ((ABS(CHECKSUM(NEWID())) % 15) * 0.01) AS DECIMAL(12,2))
FROM CandidateLines cl
JOIN RawMaterials m ON m.MaterialID = cl.MaterialID
WHERE cl.rn <= 3
  AND NOT EXISTS (
      SELECT 1
      FROM PurchaseOrderLines x
      WHERE x.PurchaseOrderID = cl.PurchaseOrderID
        AND x.MaterialID = cl.MaterialID
  );
GO

------------------------------------------------------------
-- 14) UPDATE PO TOTALS
------------------------------------------------------------
UPDATE po
SET TotalAmount = x.TotalAmount
FROM PurchaseOrders po
JOIN (
    SELECT
        pol.PurchaseOrderID,
        SUM(pol.OrderedQty * pol.UnitPrice) AS TotalAmount
    FROM PurchaseOrderLines pol
    GROUP BY pol.PurchaseOrderID
) x ON x.PurchaseOrderID = po.PurchaseOrderID;
GO

------------------------------------------------------------
-- 15) WORK ORDERS - FIXED
------------------------------------------------------------
;WITH WOSeed AS (
    SELECT *
    FROM (VALUES
        ('FG-PMP-100', 'PLT-CLV', 'Pump Assembly Line A'),
        ('FG-PMP-200', 'PLT-CLV', 'Pump Assembly Line A'),
        ('FG-VAL-110', 'PLT-HOU', 'Valve Body Machining Cell'),
        ('FG-VAL-210', 'PLT-HOU', 'Valve Body Machining Cell'),
        ('FG-ACT-050', 'PLT-GVL', 'Actuator Assembly Line 1'),
        ('FG-ACT-100', 'PLT-GVL', 'Actuator Assembly Line 1'),
        ('FG-HSG-ABS', 'PLT-MSA', 'ABS Injection Molder 01'),
        ('FG-HSG-NYL', 'PLT-MSA', 'Nylon Injection Molder 02'),
        ('FG-PNL-CTRL', 'PLT-CLT', 'Control Panel Build Line'),
        ('FG-MNF-REG', 'PLT-MKE', 'Valve Assembly Bench 01'),
        ('FG-SKD-DRV', 'PLT-IND', 'Skid Weld Station 01'),
        ('FG-MTR-MNT', 'PLT-IND', 'Powder Coat Booth 01')
    ) v(ProductCode, PlantCode, MachineName)
),
Seq AS (
    SELECT TOP (80)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
),
WOData AS (
    SELECT
        s.ProductCode,
        s.PlantCode,
        s.MachineName,
        q.n
    FROM WOSeed s
    CROSS JOIN Seq q
    WHERE q.n <= 8
),
PreparedWorkOrders AS (
    SELECT
        pr.ProductID,
        pl.PlantID,
        mc.MachineID,
        sup.EmployeeID AS SupervisorID,
        CONCAT(
            'WO-',
            YEAR(GETDATE()),
            '-',
            RIGHT('00000' + CAST(ROW_NUMBER() OVER (ORDER BY pl.PlantID, pr.ProductID, wd.n) AS VARCHAR(5)), 5)
        ) AS WorkOrderNumber,
        CASE
            WHEN pr.ProductCategory IN ('Systems','Electrical') THEN 40 + (ABS(CHECKSUM(NEWID())) % 80)
            WHEN pr.ProductCategory IN ('Fluid Power','Flow Control','Motion Control') THEN 120 + (ABS(CHECKSUM(NEWID())) % 260)
            ELSE 200 + (ABS(CHECKSUM(NEWID())) % 500)
        END AS PlannedQuantity,
        DATEADD(DAY, -1 * (wd.n * 3), DATEADD(HOUR, 7, CAST(CAST(GETDATE() AS DATE) AS DATETIME2))) AS StartDate,
        CASE
            WHEN wd.n <= 2 THEN 'Completed'
            WHEN wd.n <= 5 THEN 'In Progress'
            ELSE 'Planned'
        END AS Status
    FROM WOData wd
    JOIN Products pr ON pr.ProductCode = wd.ProductCode
    JOIN Plants pl ON pl.PlantCode = wd.PlantCode
    JOIN Machines mc ON mc.PlantID = pl.PlantID AND mc.MachineName = wd.MachineName
    OUTER APPLY (
        SELECT TOP 1 e.EmployeeID
        FROM Employees e
        JOIN Departments d ON d.DepartmentID = e.DepartmentID
        WHERE d.PlantID = pl.PlantID
          AND e.JobTitle IN ('Production Supervisor', 'Assembly Lead', 'Production Planner')
        ORDER BY e.EmployeeID
    ) sup
)
INSERT INTO WorkOrders (
    ProductID,
    PlantID,
    MachineID,
    SupervisorID,
    WorkOrderNumber,
    PlannedQuantity,
    ProducedQuantity,
    ScrapQuantity,
    StartDate,
    EndDate,
    Status
)
SELECT
    pwo.ProductID,
    pwo.PlantID,
    pwo.MachineID,
    pwo.SupervisorID,
    pwo.WorkOrderNumber,
    pwo.PlannedQuantity,
    0,
    0,
    pwo.StartDate,
    NULL,
    pwo.Status
FROM PreparedWorkOrders pwo
WHERE NOT EXISTS (
    SELECT 1
    FROM WorkOrders x
    WHERE x.WorkOrderNumber = pwo.WorkOrderNumber
);
GO

------------------------------------------------------------
-- 16) UPDATE PRODUCED / SCRAP / END DATES FOR SOME WOs
------------------------------------------------------------
UPDATE wo
SET
    ProducedQuantity =
        CASE
            WHEN wo.Status = 'Completed' THEN wo.PlannedQuantity - (1 + ABS(CHECKSUM(NEWID())) % 8)
            WHEN wo.Status = 'In Progress' THEN (wo.PlannedQuantity / 2) + (ABS(CHECKSUM(NEWID())) % NULLIF(wo.PlannedQuantity / 3, 0))
            ELSE 0
        END,
    ScrapQuantity =
        CASE
            WHEN wo.Status IN ('Completed', 'In Progress') THEN ABS(CHECKSUM(NEWID())) % 12
            ELSE 0
        END,
    EndDate =
        CASE
            WHEN wo.Status = 'Completed' THEN DATEADD(HOUR, 8 + (ABS(CHECKSUM(NEWID())) % 36), wo.StartDate)
            ELSE NULL
        END
FROM WorkOrders wo
WHERE wo.WorkOrderNumber LIKE CONCAT('WO-', YEAR(GETDATE()), '-%');
GO

------------------------------------------------------------
-- 17) QUALITY INSPECTIONS
------------------------------------------------------------
INSERT INTO QualityInspections (WorkOrderID, InspectorID, InspectionDate, PassedQty, FailedQty, Notes)
SELECT
    wo.WorkOrderID,
    insp.EmployeeID,
    DATEADD(HOUR, 2 + (ABS(CHECKSUM(NEWID())) % 24), wo.StartDate),
    CASE WHEN wo.ProducedQuantity > 0 THEN wo.ProducedQuantity - (ABS(CHECKSUM(NEWID())) % 6) ELSE 0 END,
    CASE WHEN wo.ProducedQuantity > 0 THEN ABS(CHECKSUM(NEWID())) % 6 ELSE 0 END,
    CASE
        WHEN ABS(CHECKSUM(NEWID())) % 10 = 0 THEN 'Minor cosmetic defects observed on batch sample.'
        WHEN ABS(CHECKSUM(NEWID())) % 9 = 0 THEN 'Dimensional variance within rework tolerance.'
        ELSE 'Inspection passed within specification.'
    END
FROM WorkOrders wo
OUTER APPLY (
    SELECT TOP 1 e.EmployeeID
    FROM Employees e
    JOIN Departments d ON d.DepartmentID = e.DepartmentID
    WHERE d.PlantID = wo.PlantID
      AND d.DepartmentName = 'Quality Control'
    ORDER BY e.EmployeeID
) insp
WHERE wo.Status IN ('Completed', 'In Progress')
  AND insp.EmployeeID IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM QualityInspections x
      WHERE x.WorkOrderID = wo.WorkOrderID
  );
GO

------------------------------------------------------------
-- 18) MAINTENANCE LOGS
------------------------------------------------------------
INSERT INTO MaintenanceLogs (MachineID, TechnicianID, MaintenanceDate, MaintenanceType, Description, DowntimeHours, Cost)
SELECT
    m.MachineID,
    tech.EmployeeID,
    DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 120), SYSDATETIME()),
    CASE
        WHEN ABS(CHECKSUM(NEWID())) % 4 = 0 THEN 'Corrective'
        WHEN ABS(CHECKSUM(NEWID())) % 4 = 1 THEN 'Preventive'
        WHEN ABS(CHECKSUM(NEWID())) % 4 = 2 THEN 'Inspection'
        ELSE 'Calibration'
    END,
    CASE
        WHEN m.MachineType = 'CNC' THEN 'Spindle alignment, coolant check, and axis verification.'
        WHEN m.MachineType = 'Injection Molding' THEN 'Heater band inspection and mold changeover verification.'
        WHEN m.MachineType = 'Assembly' THEN 'Torque tool calibration and conveyor lubrication.'
        WHEN m.MachineType = 'Electrical Assembly' THEN 'ESD station validation and bench power supply check.'
        ELSE 'Routine equipment inspection and service.'
    END,
    CAST((ABS(CHECKSUM(NEWID())) % 80) / 10.0 AS DECIMAL(8,2)),
    CAST(120 + (ABS(CHECKSUM(NEWID())) % 2400) AS DECIMAL(12,2))
FROM Machines m
OUTER APPLY (
    SELECT TOP 1 e.EmployeeID
    FROM Employees e
    JOIN Departments d ON d.DepartmentID = e.DepartmentID
    WHERE d.PlantID = m.PlantID
      AND d.DepartmentName = 'Maintenance'
    ORDER BY e.EmployeeID
) tech
WHERE tech.EmployeeID IS NOT NULL;
GO

------------------------------------------------------------
-- 19) ADD MORE REALISTIC EMPLOYEES
------------------------------------------------------------
;WITH FirstNames AS (
    SELECT * FROM (VALUES
        ('James'),('Emma'),('Noah'),('Ava'),('Liam'),('Isabella'),('Mason'),('Mia'),
        ('Logan'),('Charlotte'),('Lucas'),('Amelia'),('Elijah'),('Harper'),('Benjamin'),('Evelyn'),
        ('Alexander'),('Abigail'),('Henry'),('Ella'),('Jacob'),('Sofia'),('Michael'),('Avery')
    ) v(FirstName)
),
LastNames AS (
    SELECT * FROM (VALUES
        ('Anderson'),('Thompson'),('Ramirez'),('Campbell'),('Stewart'),('Russell'),
        ('Flores'),('Perry'),('Powell'),('Long'),('Patterson'),('Hughes'),
        ('Washington'),('Butler'),('Simmons'),('Foster'),('Gonzales'),('Bryant'),
        ('Alexander'),('Griffin'),('Diaz'),('Hayes'),('Myers'),('Ford')
    ) v(LastName)
),
Roles AS (
    SELECT * FROM (VALUES
        ('Production','Machine Operator',48000,'Day'),
        ('Production','Assembly Technician',46500,'Rotating'),
        ('Warehouse','Forklift Operator',45500,'Rotating'),
        ('Quality Control','Quality Inspector',55000,'Day'),
        ('Maintenance','Maintenance Technician',62000,'Night'),
        ('Engineering','Manufacturing Engineer',84000,'Day'),
        ('Planning','Production Scheduler',68000,'Day')
    ) v(DepartmentName, JobTitle, Salary, Shift)
),
PlantsX AS (
    SELECT PlantID, PlantCode
    FROM Plants
    WHERE PlantCode IN ('PLT-CLV','PLT-HOU','PLT-GVL','PLT-GRP','PLT-MSA','PLT-MKE','PLT-IND','PLT-CLT')
),
Combos AS (
    SELECT TOP (120)
        f.FirstName,
        l.LastName,
        r.DepartmentName,
        r.JobTitle,
        r.Salary,
        r.Shift,
        px.PlantID,
        px.PlantCode,
        ROW_NUMBER() OVER (ORDER BY px.PlantCode, l.LastName, f.FirstName) AS rn
    FROM FirstNames f
    CROSS JOIN LastNames l
    CROSS JOIN Roles r
    CROSS JOIN PlantsX px
)
INSERT INTO Employees (DepartmentID, FirstName, LastName, JobTitle, HireDate, Shift, Salary, Email, IsActive)
SELECT
    d.DepartmentID,
    c.FirstName,
    c.LastName,
    c.JobTitle,
    DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 1800), CAST(GETDATE() AS DATE)),
    c.Shift,
    c.Salary + ((ABS(CHECKSUM(NEWID())) % 6) * 500),
    LOWER(c.FirstName + '.' + c.LastName + CAST(c.rn AS VARCHAR(4)) + '@factoryops.com'),
    1
FROM Combos c
JOIN Departments d ON d.PlantID = c.PlantID AND d.DepartmentName = c.DepartmentName
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees x
    WHERE x.Email = LOWER(c.FirstName + '.' + c.LastName + CAST(c.rn AS VARCHAR(4)) + '@factoryops.com')
);
GO

------------------------------------------------------------
-- 20) MACHINE SENSORS
------------------------------------------------------------
INSERT INTO MachineSensors
    (MachineID, SensorCode, SensorName, SensorType, UnitOfMeasure, MinAcceptableValue, MaxAcceptableValue, InstalledDate)
SELECT MachineID, CONCAT(MachineCode, '-TEMP-01'), 'Bearing Temperature Sensor', 'Temperature', 'C', 15, 85, '2025-01-15'
FROM Machines
WHERE NOT EXISTS (
    SELECT 1 FROM MachineSensors s WHERE s.SensorCode = CONCAT(Machines.MachineCode, '-TEMP-01')
);

INSERT INTO MachineSensors
    (MachineID, SensorCode, SensorName, SensorType, UnitOfMeasure, MinAcceptableValue, MaxAcceptableValue, InstalledDate)
SELECT MachineID, CONCAT(MachineCode, '-VIB-01'), 'Main Spindle Vibration Sensor', 'Vibration', 'mm/s', 0, 12, '2025-01-15'
FROM Machines
WHERE MachineType IN ('CNC', 'Press', 'Grinding', 'Injection Molding')
  AND NOT EXISTS (
    SELECT 1 FROM MachineSensors s WHERE s.SensorCode = CONCAT(Machines.MachineCode, '-VIB-01')
);

INSERT INTO MachineSensors
    (MachineID, SensorCode, SensorName, SensorType, UnitOfMeasure, MinAcceptableValue, MaxAcceptableValue, InstalledDate)
SELECT MachineID, CONCAT(MachineCode, '-PWR-01'), 'Power Consumption Meter', 'Power', 'kW', 0, 250, '2025-01-15'
FROM Machines
WHERE NOT EXISTS (
    SELECT 1 FROM MachineSensors s WHERE s.SensorCode = CONCAT(Machines.MachineCode, '-PWR-01')
);

INSERT INTO MachineSensors
    (MachineID, SensorCode, SensorName, SensorType, UnitOfMeasure, MinAcceptableValue, MaxAcceptableValue, InstalledDate)
SELECT MachineID, CONCAT(MachineCode, '-RPM-01'), 'Rotational Speed Sensor', 'RPM', 'RPM', 0, 5000, '2025-01-15'
FROM Machines
WHERE MachineType IN ('CNC', 'Grinding', 'Injection Molding')
  AND NOT EXISTS (
    SELECT 1 FROM MachineSensors s WHERE s.SensorCode = CONCAT(Machines.MachineCode, '-RPM-01')
);

INSERT INTO MachineSensors
    (MachineID, SensorCode, SensorName, SensorType, UnitOfMeasure, MinAcceptableValue, MaxAcceptableValue, InstalledDate)
SELECT MachineID, CONCAT(MachineCode, '-PRS-01'), 'Hydraulic Pressure Sensor', 'Pressure', 'bar', 40, 210, '2025-01-15'
FROM Machines
WHERE MachineType IN ('Press', 'Hydraulic', 'Injection Molding')
  AND NOT EXISTS (
    SELECT 1 FROM MachineSensors s WHERE s.SensorCode = CONCAT(Machines.MachineCode, '-PRS-01')
);

INSERT INTO MachineSensors
    (MachineID, SensorCode, SensorName, SensorType, UnitOfMeasure, MinAcceptableValue, MaxAcceptableValue, InstalledDate)
SELECT MachineID, CONCAT(MachineCode, '-OIL-01'), 'Hydraulic Oil Level Sensor', 'OilLevel', '%', 25, 100, '2025-01-15'
FROM Machines
WHERE MachineType IN ('Press', 'Hydraulic', 'Injection Molding')
  AND NOT EXISTS (
    SELECT 1 FROM MachineSensors s WHERE s.SensorCode = CONCAT(Machines.MachineCode, '-OIL-01')
);
GO

------------------------------------------------------------
-- 21) 5,000 SMOOTH IOT MACHINE SENSOR READINGS
------------------------------------------------------------
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
        ((n.n - 1) / sc.TotalSensors) + 1 AS StepNum,
        DATEADD(MINUTE, -5 * (((n.n - 1) / sc.TotalSensors) + 1), SYSDATETIME()) AS ReadingTime
    FROM Numbers n
    CROSS JOIN SensorCount sc
    JOIN SensorPool sp
        ON sp.SensorRowNum = ((n.n - 1) % sc.TotalSensors) + 1
),
CalculatedReadings AS (
    SELECT
        b.SensorID,
        b.MachineID,
        b.SensorType,
        b.MinAcceptableValue,
        b.MaxAcceptableValue,
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
                WHEN 'Power' THEN
                    92.0
                    + 15.0 * SIN((b.StepNum / 5.5) + (b.SensorID * 0.31))
                    + 7.0 * COS((b.StepNum / 14.0) + (b.SensorID * 0.13))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 19) - 9) / 4.0
                    + CASE WHEN b.StepNum % 45 = 0 THEN 36.0 ELSE 0 END
                WHEN 'RPM' THEN
                    2150.0
                    + 280.0 * SIN((b.StepNum / 5.0) + (b.SensorID * 0.30))
                    + 120.0 * COS((b.StepNum / 12.0) + (b.SensorID * 0.15))
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 31) - 15) * 3.0
                    + CASE WHEN b.StepNum % 57 = 0 THEN 750.0 ELSE 0 END
                WHEN 'OilLevel' THEN
                    71.0
                    + 4.0 * SIN((b.StepNum / 15.0) + (b.SensorID * 0.12))
                    + 2.0 * COS((b.StepNum / 29.0) + (b.SensorID * 0.04))
                    - (b.StepNum * 0.045)
                    + ((ABS(CHECKSUM(b.SensorID, b.StepNum)) % 7) - 3) / 5.0
                    + CASE WHEN b.StepNum % 80 = 0 THEN -18.0 ELSE 0 END
                ELSE 0.0
            END AS DECIMAL(18,4)
        ) AS ReadingValueRaw
    FROM BaseSeries b
),
FinalReadings AS (
    SELECT
        SensorID,
        MachineID,
        ReadingTime,
        CAST(CASE WHEN ReadingValueRaw < 0 THEN 0 ELSE ReadingValueRaw END AS DECIMAL(18,4)) AS ReadingValue,
        MinAcceptableValue,
        MaxAcceptableValue,
        CASE WHEN StepNum % 97 = 0 THEN 'Estimated' ELSE 'Good' END AS QualityFlag
    FROM CalculatedReadings
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
        WHEN f.MinAcceptableValue IS NOT NULL AND f.ReadingValue < f.MinAcceptableValue * 0.90 THEN 'Critical'
        WHEN f.MaxAcceptableValue IS NOT NULL AND f.ReadingValue > f.MaxAcceptableValue * 1.10 THEN 'Critical'
        WHEN f.MinAcceptableValue IS NOT NULL AND f.ReadingValue < f.MinAcceptableValue THEN 'Warning'
        WHEN f.MaxAcceptableValue IS NOT NULL AND f.ReadingValue > f.MaxAcceptableValue THEN 'Warning'
        ELSE 'Normal'
    END,
    f.QualityFlag
FROM FinalReadings f;
GO

------------------------------------------------------------
-- 22) 200 BAD READINGS FOR CNC CUTTER 01
------------------------------------------------------------
;WITH Numbers AS (
    SELECT TOP (200)
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
        ROW_NUMBER() OVER (ORDER BY s.SensorID) AS SensorRowNum
    FROM Machines m
    JOIN MachineSensors s ON s.MachineID = m.MachineID
    WHERE m.MachineName = 'CNC Cutter 01'
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
    DATEADD(MINUTE, -1 * n.n, SYSDATETIME()),
    CAST(
        CASE sp.SensorType
            WHEN 'Temperature' THEN ISNULL(sp.MaxAcceptableValue, 85) + 20
            WHEN 'Vibration'   THEN ISNULL(sp.MaxAcceptableValue, 12) + 5
            WHEN 'Pressure'    THEN ISNULL(sp.MaxAcceptableValue, 210) + 50
            WHEN 'Power'       THEN ISNULL(sp.MaxAcceptableValue, 250) + 40
            WHEN 'RPM'         THEN ISNULL(sp.MaxAcceptableValue, 5000) + 800
            WHEN 'OilLevel'    THEN ISNULL(sp.MinAcceptableValue, 25) - 15
            ELSE 999
        END AS DECIMAL(18,4)
    ),
    'Critical',
    'Good'
FROM Numbers n
CROSS JOIN SensorCount sc
JOIN SensorPool sp
    ON sp.SensorRowNum = ((n.n - 1) % NULLIF(sc.TotalSensors, 0)) + 1
WHERE sc.TotalSensors > 0;
GO

------------------------------------------------------------
-- 23) VIEW FOR POWER BI / FABRIC REPORTING
------------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_MachineSensorReadings AS
SELECT
    r.ReadingID,
    r.ReadingTime,
    r.ReadingValue,
    r.Status,
    r.QualityFlag,
    s.SensorID,
    s.SensorCode,
    s.SensorName,
    s.SensorType,
    s.UnitOfMeasure,
    m.MachineID,
    m.MachineCode,
    m.MachineName,
    m.MachineType,
    m.PlantID
FROM dbo.MachineSensorReadings r
JOIN dbo.MachineSensors s
    ON r.SensorID = s.SensorID
JOIN dbo.Machines m
    ON r.MachineID = m.MachineID;
GO

------------------------------------------------------------
-- 24) OPTIONAL STORED PROCEDURE: INSERT 5-10 IOT READINGS PER EXECUTION
------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.InsertIoTBatch
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RowCount INT = 5 + ABS(CHECKSUM(NEWID())) % 6;

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
                WHEN 'OilLevel'    THEN 55 + (ABS(CHECKSUM(NEWID())) % 3500) / 100.0
                ELSE 10
            END AS DECIMAL(18,4)
        ),
        'Normal',
        'Good'
    FROM MachineSensors s
    WHERE s.IsActive = 1
    ORDER BY NEWID();
END;
GO
