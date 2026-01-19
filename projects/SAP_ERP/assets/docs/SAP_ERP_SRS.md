# Software Requirements Specification (SRS) — SAP ERP (Mock) BA Case Study (O2C)

**Standard:** IEEE 29148-aligned SRS structure (English-first)  
**Project / Scenario:** Mock SAP ERP — Order-to-Cash (O2C) controls  
**Example reference platform:** SAP S/4HANA (SD + FI-AR + FSCM Credit Management)  
**Simulation note:** Portfolio mock; terminology references S/4HANA to be concrete; no proprietary SAP content  
**Version:** 0.2  
**Date:** 2026-01-19

---

## 1. Scope
### 1.1 Purpose
This SRS specifies functional and quality requirements for an ERP Order-to-Cash (O2C) scope with pricing override governance, credit control, billing controls, role-based access control (RBAC), segregation of duties (SoD), and audit logging.

### 1.2 System / Product Scope
In scope:
- Sales Order creation and pricing determination
- Pricing override request, approval, and auditability
- Credit check, credit block, and controlled release
- Billing: invoice creation and credit memo controls
- Audit evidence and reporting views

Out of scope:
- Full FI/CO posting and reconciliation detail
- EDI/IDoc integrations and external tax engines
- Warehouse execution specifics

### 1.3 Intended Audience
- Business stakeholders (Sales Ops, Credit/Risk, Billing)
- QA/UAT participants
- ERP solution owner / implementers

---

## 2. Normative and Informative References
- PRD: `SAP_ERP_PRD`
- BRD: `SAP_ERP_BRD`
- Business Rules & Decision Tables: `SAP_ERP_Business_Rules_Decision_Tables`
- Roles & Permissions Matrix: `SAP_ERP_Roles_Permissions`
- RTM: `SAP_ERP_RTM`
- UAT Test Cases: `SAP_ERP_UAT_Test_Cases`
- UAT Test Summary + Sign-off (IEEE 829): `SAP_ERP_UAT_Test_Summary_Report_IEEE829`

---

## 3. Terms, Definitions, and Abbreviations
| Term | Definition |
|---|---|
| O2C | Order-to-Cash process from order entry to billing and payment |
| RBAC | Role-based access control |
| SoD | Segregation of Duties to prevent conflicting permissions |
| Credit block | System status preventing further processing due to credit policy |
| Pricing override | Manual change to pricing beyond configured tolerance |
| Audit log | Immutable record of critical actions (who/when/what) |

---

## 4. System Overview
The system supports controlled O2C execution with governance controls to reduce revenue leakage (pricing overrides), reduce financial risk (credit control), and improve compliance (auditability and SoD).

---

## 5. System Context and Operating Environment
### 5.1 Users / External Actors
- Sales Rep
- Sales Manager (approver)
- Credit Analyst
- Billing Clerk
- Auditor

### 5.2 Operating Environment (assumptions)
- ERP UI (example: SAP Fiori apps and/or SAP GUI screens), simulated for portfolio purposes
- Test data available (customers, materials, pricing, credit exposure)

---

## 6. Requirements
### 6.1 Requirement statement conventions
- Requirements use “shall” statements.
- Each requirement has an ID, priority, and verification method.

### 6.2 Functional requirements
| ID | Requirement (shall) | Priority | Verification |
|---|---|---|---|
| FR-O2C-001 | The system shall allow a Sales Rep to create a Sales Order with automatic pricing determination. | High | Test |
| FR-O2C-002 | The system shall require a reason code/text when a pricing override is requested. | High | Test |
| FR-O2C-003 | The system shall route pricing overrides to approver(s) and persist the approval decision and approver identity. | High | Test |
| FR-O2C-004 | The system shall perform a credit check and apply a credit block when the customer exposure exceeds the credit limit. | High | Test |
| FR-O2C-005 | The system shall allow only authorized Credit roles to release a credit block and shall record the release action. | High | Test |
| FR-O2C-006 | The system shall allow invoice creation only when prerequisite statuses are satisfied (e.g., approvals complete, no credit block). | High | Test |
| FR-O2C-007 | The system shall require a reason code for credit memo creation and enforce approval if configured by policy. | Medium | Test |
| FR-SEC-001 | The system shall enforce RBAC for sensitive actions (billing creation, credit release, override approval). | High | Test |
| FR-CTRL-001 | The system shall record audit logs for critical actions including actor, timestamp, object ID, and old/new values where applicable. | High | Test |

### 6.3 Business rules (normative reference)
Business rules and decision tables are defined in `SAP_ERP_Business_Rules_Decision_Tables` and are treated as normative constraints for this SRS.

### 6.4 Data requirements
- Customer master data: credit limit, exposure
- Material master data: pricing applicability
- Documents: Sales Order, Invoice, Credit Memo
- Audit log records for critical actions

### 6.5 External interface requirements (high level)
- User interface shall display statuses (Pending Approval, Credit Blocked) and actionable messages.
- Reporting interface shall allow viewing audit log records by document.

### 6.6 Quality (non-functional) requirements
| ID | Requirement (shall) | Priority | Verification |
|---|---|---|---|
| NFR-SEC-001 | The system shall enforce least privilege and prevent users from performing actions outside assigned roles. | High | Test |
| NFR-AUD-001 | The system shall capture audit evidence for pricing override and credit release actions sufficient for internal audit review. | High | Test |
| NFR-USA-001 | The system shall provide clear error messages when actions are blocked (e.g., credit block, missing approval). | Medium | Test |
| NFR-REL-001 | The system shall prevent inconsistent states such as billing while the order is credit-blocked. | High | Test |

### 6.7 Constraints
- Segregation of duties: Sales roles must not release credit blocks.
- Audit trail must be available for critical actions.

---

## 7. Verification and Validation
Primary verification method for this portfolio case study is **UAT / functional testing** with evidence capture.

| Requirement IDs | Validation approach |
|---|---|
| FR-O2C-001..007 | Execute UAT test cases for O2C flows and capture screenshots/status evidence |
| FR-SEC-001 | Execute negative authorization tests (access denied) |
| FR-CTRL-001 | Review audit log entries for completeness |
| NFR-* | Validate through UAT evidence and scenario checks |

---

## 8. Traceability
Traceability to business rules and UAT tests is maintained in the RTM: `SAP_ERP_RTM`.
