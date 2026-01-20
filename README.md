# BA Portfolio

Business Analyst portfolio hub with case studies covering discovery, requirements, solution design, and UAT validation.

## View the portfolio site

- Open [index.html](index.html) in a browser (or use VS Code Live Server)
- Download artifacts from each project’s Deliverables page:
	- Foodora: [projects/foodora-mvp/deliverables.html](projects/foodora-mvp/deliverables.html)
	- Retail System: [projects/Retail_System/deliverables.html](projects/Retail_System/deliverables.html)
	- SAP ERP (O2C): [projects/SAP_ERP/deliverables.html](projects/SAP_ERP/deliverables.html)

## Online links (recommended for recruiters)

- Prototype site (Figma Sites): [https://verify-curry-15074315.figma.site/](https://verify-curry-15074315.figma.site/)
- Figma design file: [https://www.figma.com/design/NQueQnkRGx1mzjQSiJAmkZ/FOODORA](https://www.figma.com/design/NQueQnkRGx1mzjQSiJAmkZ/FOODORA)
- Jira backlog: [https://nguyennhathai031004.atlassian.net/jira/software/projects/SCRUM/boards/1/backlog](https://nguyennhathai031004.atlassian.net/jira/software/projects/SCRUM/boards/1/backlog)

## Case studies

- Foodora — Order & Pick-up (MVP): [projects/foodora-mvp/project-overview.html](projects/foodora-mvp/project-overview.html)
- Retail Operations Backoffice: [projects/Retail_System/project-overview.html](projects/Retail_System/project-overview.html)
- SAP ERP — Order-to-Cash (O2C): [projects/SAP_ERP/project-overview.html](projects/SAP_ERP/project-overview.html)

## Standards-based BA checklists (BABOK v3 + ISO/IEC/IEEE 29148)

Project-specific checklists:

- Foodora: [assets/docs/BA_Checklist_Foodora_MVP.xlsx](assets/docs/BA_Checklist_Foodora_MVP.xlsx)
- Retail System: [assets/docs/BA_Checklist_Retail_System.xlsx](assets/docs/BA_Checklist_Retail_System.xlsx)
- SAP ERP (O2C): [assets/docs/BA_Checklist_SAP_ERP.xlsx](assets/docs/BA_Checklist_SAP_ERP.xlsx)

Reference/template files:

- Template: [assets/docs/BA_Checklist_Template_BABOK_ISO.xlsx](assets/docs/BA_Checklist_Template_BABOK_ISO.xlsx)
- Combined (filled): [assets/docs/BA_Checklist_BABOK_ISO_Filled.xlsx](assets/docs/BA_Checklist_BABOK_ISO_Filled.xlsx)

## SQL showcase (SQL Server / T-SQL)

Each project includes a canonical SQL showcase script with seed data so the queries return results:

- Foodora: [projects/foodora-mvp/assets/sql/foodora_sql_showcase.sql](projects/foodora-mvp/assets/sql/foodora_sql_showcase.sql)
- Retail System: [projects/Retail_System/assets/sql/retail_sql_showcase.sql](projects/Retail_System/assets/sql/retail_sql_showcase.sql)
- SAP ERP (O2C): [projects/SAP_ERP/assets/sql/sap_o2c_sql_showcase.sql](projects/SAP_ERP/assets/sql/sap_o2c_sql_showcase.sql)

To avoid forced downloads in the browser, the portfolio uses an in-browser SQL viewer:

- Viewer page: [pages/sql-viewer.html](pages/sql-viewer.html)

## Repository name

Recommended GitHub repo name: `BA-portfolio`.

## Selected deliverables (Foodora)

- Backlog (documented): [projects/foodora-mvp/assets/docs/Jira%20Backlog%20and%20Technical%20Stories.docx](projects/foodora-mvp/assets/docs/Jira%20Backlog%20and%20Technical%20Stories.docx)

**Design**

- BPMN: [projects/foodora-mvp/assets/images/diagrams/BPMN.drawio](projects/foodora-mvp/assets/images/diagrams/BPMN.drawio) (also viewable online via diagrams.net from the Deliverables page)
- ERD: [projects/foodora-mvp/assets/images/diagrams/ERD%20-%20Foodora%20MVP.drawio](projects/foodora-mvp/assets/images/diagrams/ERD%20-%20Foodora%20MVP.drawio) (also viewable online via diagrams.net)
- Wireflow: [projects/foodora-mvp/assets/images/diagrams/Wireflow%20-%20Screen%20Flow%20Diagram.drawio](projects/foodora-mvp/assets/images/diagrams/Wireflow%20-%20Screen%20Flow%20Diagram.drawio) (also viewable online via diagrams.net)

**Validation (UAT)**

- UAT Test Cases (execution template): [projects/foodora-mvp/assets/docs/UAT_Test_Cases_Template.xlsx](projects/foodora-mvp/assets/docs/UAT_Test_Cases_Template.xlsx)
- Traceability Matrix (IEEE 829 aligned): [projects/foodora-mvp/assets/docs/Foodora_Traceability_Matrix.xlsx](projects/foodora-mvp/assets/docs/Foodora_Traceability_Matrix.xlsx)
- Test Summary Report + Sign-off (IEEE 829 aligned): [projects/foodora-mvp/assets/docs/Foodora_UAT_Signoff_Form.docx](projects/foodora-mvp/assets/docs/Foodora_UAT_Signoff_Form.docx)

## Repository structure

```
projects/                   Case-study websites (one folder per project)
projects/foodora-mvp/assets/docs/                Foodora documents (DOCX/XLSX/MD)
projects/foodora-mvp/assets/images/diagrams/     Foodora diagrams (.drawio)
projects/foodora-mvp/assets/images/deliverables/ Foodora preview images used by the website
projects/foodora-mvp/assets/images/screenshots/  Foodora prototype/wireflow screenshots
pages/                      Redirect stubs (backward compatibility)
css/                        Shared styles
assets/docs/                Shared portfolio artifacts (e.g., standards-based BA checklists)
tools/                      Optional scripts used to generate checklist workbooks
```

## Notes

- This is a portfolio project; the company/product is conceptual.
- The site is static (HTML/CSS/JS) and is designed to be recruiter-friendly (viewable PDFs/SQL, plus downloads).