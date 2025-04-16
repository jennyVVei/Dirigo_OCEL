# _Dirigo_: A Method to Extract Event Logs for Object-Centric Processes

This repository contains the supplementary materials for the paper **_Dirigo: A Method to Extract Event Logs for Object-Centric Processes_**. In this work, we introduce **Dirigo**, a novel method for generating event logs tailored for object-centric processes. Dirigo leverages **Object-Role Modeling (ORM)**, a conceptual data modeling technique, to accurately define the data structure required in **Object-Centric Event Logs (OCEL)**.

To demonstrate the practical applicability of Dirigo, we applied it to a real-world use case involving:
- 100 pickup plans
- 50 trucks
- 20 cargoes

  Using this dataset, we instantiated schemas based on Dirigo, as well as two existing OCEL schemas: ACEL and DOCEL. By using a consistent dataset across all schemas, we enabled a direct and fair comparison of schema design choices and their implications on data storage and query performance.
---
We evaluate the schemas based on:
1. **Database Storage Efficiency**
2. **Schema Quality**, assessed through established quality criteria:
   - Schema expressiveness for supporting queries
   - Query processing performance (execution time)

## **Repository Structure**
### 1. Dirigo:
Contains an OCEL log based on the **Dirigo schema**, including:
- **Object type tables**:  
  - `OCEL_Cargo.csv`  
  - `OCEL_Truck.csv`  
  - `OCEL_PickupPlan.csv`
- **Events table**:  
  - `OCEL_Events.csv`
- **Object-to-object relationship table**:  
  - `OCEL_O2O.csv`
- **Event-to-object relationship table**:  
  - `OCEL_E2O.csv`

---

### **2. ACEL**
Contains an OCEL log based on the **ACEL schema**, including:
- `ACEL_Events.csv`
- `ACEL_Objects.csv`
- `ACEL_Relations.csv`

---
### **3. DOCEL**
Contains an OCEL log based on the **DOCEL schema**, including:

- **Static object attributes**:
  - `DOCEL_Truck_Static.csv`
  - `DOCEL_Cargo_Statics.csv`

- **Dynamic object attributes**:
  - `DOCEL_CargoStock.csv`
  - `DOCEL_PickupplanCargo.csv`
  - `DOCEL_PickupplanNotrs.csv`
  - `DOCEL_PickupplanTotalWeight.csv`
  - `DOCEL_TruckCargoID.csv`
  - `DOCEL_TruckPickupplanID.csv`
  - `DOCEL_TruckScheduledPickupWeight.csv`
  - `DOCEL_TruckStatus.csv`
  - `DOCEL_TruckWeight.csv`

- **Events table**:
  - `DOCEL_Events.csv`

---
### **4. Database_Processing**
Includes Jupyter notebooks to populate ACEL and DOCEL logs from the base dataset and convert the logs into SQLite databases:

- `Dirigo_ACEL.ipynb`: Converts the dataset into an ACEL-formatted OCEL log.
- `Dirigo_DOCEL.ipynb`: Converts the dataset into a DOCEL-formatted OCEL log.
- `CSVs_to_SQLites.ipynb`: Transforms all log tables into corresponding SQLite databases.

---

### **5. EvaluationCriteria**
Contains Jupyter notebooks used to evaluate schema quality across various metrics. Each notebook corresponds to a specific criterion and includes detailed computations.

---

### **6. Databases_Queries**
Includes:
1. SQLite databases for all three schemas:  
   - `ACEL.sqlite`  
   - `Dirigo.sqlite`  
   - `DOCEL.sqlite`
2. Example SQL queries used to evaluate each criterion.
3. Jupyter notebooks for measuring the query processing time across the schemas.

