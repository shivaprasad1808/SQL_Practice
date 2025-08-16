###SQL_Project_Patient_Database_Analysis
SQL project featuring 50 hands-on practice queries based on a healthcare (patient-admission-doctor) database.
This project allows users to strengthen SQL skills and explore real-world data scenarios, such as patient admissions and medical analytics.

###💡 Overview
This repository contains structured SQL exercises and solutions designed for interview prep and hands-on learning.
All queries were created and tested using Learn SQL - Online SQL Terminal - Practice SQL Querys and are compatible with popular RDBMS like SQL Server (T-SQL).

###🏥 Database Schema
The database is made up of the following tables:

patients: Patient details (name, gender, birth date, city, province, allergies, height, weight).

doctors: Doctor details (name, specialty).

admissions: Admission records (dates, diagnosis, attending doctor), linked to patients and doctors.

province_names: Province code and full province name.

###Relationships:

Each patient is assigned to a province via province_id.

Each admission logs the patient_id and attending_doctor_id.

Each doctor may attend multiple admissions.
