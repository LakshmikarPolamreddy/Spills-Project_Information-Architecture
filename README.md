# Analysis of Spill incidents in New York state

# Project Steps

Step1: Sourcing files and uploading to Github repository
We have sourced datasets of Spills in NY state, Income of people in NY state and list of manufacturing companies in NY state from below links. We have uploaded these files into our Github repository - "https://github.com/LakshmikarPolamreddy/Spills-Project_Information-Architecture"

Data sourced from below websites
https://data.ny.gov/Energy-Environment/Spill-Incidents/u44d-k5fk
https://data.census.gov/table

Step2: Data profiling in Python
We have loaded these 3 files into python from Github and cleaned the files in terms of data types, handled missing values, removed unnecessary columns etc. and then uploaded these cleaned files to 's3' bucket.
python file: Spills incidents in NY_Jupyter_file

Step3: ETL process using MySQL and AWS resources
Created OLTP database in AWS
Created Star schema data model for OLAP
Created OLAP database using MySQL
Implemented Stored procedures and triggers for automatic updates
DDL file:
ER Diagram:
Bus matrix: 

Step4: EDA and Data visualization steps done in python file
Step5: Data visulaization in Tableau to answer our research questions (Clearly shown in the project ppt - saved as 'A project on analyzing spill incidents in NY state'.pdf in this repository)

