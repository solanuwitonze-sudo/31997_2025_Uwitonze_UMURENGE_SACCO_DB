# Umurenge SACCO Savings & Loan Management System

**Student:** Uwitonze Solange
**Student ID:** 31997/2025
**Course:** DPR400210 – Database Programming
**Instructor:** Eric Maniraguza
**Academic Year:** 2025-2026

## Project Overview
This is a complete Oracle Database system designed to automate operations for a local SACCO (Savings and Credit Cooperative Organization). The system manages members, savings deposits, loans, interest calculations, repayments, and financial reporting.

## Features
- Automated interest calculation using PL/SQL triggers
- Loan approval and repayment tracking
- Overdue loan blocking
- Audit logging for all changes
- Weekend and public holiday transaction blocking
- Dynamic HTML dashboard for real-time reporting

## Folder Structure
- `/Docs` – Phase I, II, III documents, ERD, and Final Report
- `/SQL` – All SQL scripts for creating the database, tables, and inserting data
- `/PLSQL` – All PL/SQL scripts (functions, procedures, packages, triggers)
- `/Screenshots` – All screenshots for each phase
- `/Innovation` – HTML dashboard and generation script

## Technologies Used
- Oracle Database 21c
- PL/SQL
- SQL*Plus
- HTML/CSS (for dashboard)
- GitHub

## How to Run
1. Connect to your Oracle database.
2. Run the scripts in `/SQL` folder to create the schema.
3. Run the scripts in `/PLSQL` folder to create functions, procedures, and triggers.
4. Insert sample data using the scripts in `/SQL`.
5. Generate the dashboard by running `31997_2025_Solange_Generate_Dashboard.sql`.
