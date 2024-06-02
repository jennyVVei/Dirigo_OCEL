# _Dirigo_: A Method to Generate Event Logs for Object-Centric Processes

This is the supplementary repository for the paper Dirigo: A Method to Generate Event Logs for Object-Centric Processes. In this paper, we address existing research gaps by proposing a novel method, namely Dirigo, to generate event logs for object-centric processes. We employ object-role modelling (ORM), a conceptual data modelling technique, to precisely capture the required data structure in OCEL. To validate the applicability of the proposed method, we apply it to a real-life use case and generate a simulated event log using the Coloured Petri net. We also propose a set of assessment criteria to evaluate the quality of the generated event log against existing OCEL-compliant event log representations.

## This repository includes three main sections:

### 1. CPN-Models:
- object_initialise: Contains a CPN model for initializing objects involved in the process. The resulting object tables for each type include both static and dynamic attributes, with dynamic attributes initially set to NULL or 0.0.
- CargoPickupBP: Features a CPN model for capturing the cargo pickup process and a collection of CSV files. These files include an object table for each object type, an event table for each event type, and E2O (Event-to-Object) and O2O (Object-to-Object) relations tables.

### 2. OCEL-Log:
- Includes the generated OCEL log representation for the cargo pickup process, consisting of the following files: OCEL_Event.csv, OCEL_Cargo.csv, OCEL_Truck.csv, OCEL_PickupPlan.csv, OCEL_O2O.csv, and OCEL_E2O.csv.
- csv_to_sqlite.ipynb: A Jupyter notebook detailing the process of transforming CSV files into an OCEL log in SQLite Database format.
- CSVs_to_OCEL_log_schema.ipynb: A Jupyter notebook for data preprocessing to generate the OCEL log following the _Dirigo_ schema.

### 3.Quality-Criteria-Queries:
- createdb.sql: Contains queries for generating a sample OCEL log as per the Dirigo schema.
- QC queries.sql: Provides data queries for evaluating each proposed quality criterion.


