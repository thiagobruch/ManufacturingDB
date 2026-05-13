Manufacturing Database with Plans, Machine, Machine Sensors, etc.

Diagram can be found at [Diagram.png](https://github.com/thiagobruch/ManufacturingDB/blob/main/Diagram.png)

## How to use ##
* The Files here are to be used with SQL Server.
  
1 - Use the file Create_DB.sql to create the DB and the tables.

2 - Use Insert_Data.sql to Insert basic data to the DB.

3 - Use one fo the instructions to generate data:

3.1 - Generate 500 IoT Records in MachineSensorReadings<BR>
Use the instructions on [Gen_500_Records.md](https://github.com/thiagobruch/ManufacturingDB/blob/main/Gen_500_Records.md)

3.2 - Generate 5000 IoT Records in MachineSensorReadings<BR>
Use the instructions on [Gen_5k_Records.md](https://github.com/thiagobruch/ManufacturingDB/blob/main/Gen_5k_Records.md)

3.3 - Generate few records per minute in MachineSensorReadings<BR> with Store Procedure and Scheduled Job<BR>
Use the instructions on [Gen_Data_Per_Minute.md](https://github.com/thiagobruch/ManufacturingDB/blob/main/Gen_Data_Per_Minute.md)

3.4 - Add several "crtitical" entries in MachineSensorReadings<BR>
Use the instructions on [Add_Critical_Data.md](https://github.com/thiagobruch/ManufacturingDB/blob/main/Add_Critical_Data.md)


