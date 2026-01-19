# Requirements Traceability Matrix (RTM) — SAP ERP (Mock) BA Case Study

**Scenario:** Order-to-Cash (O2C) with credit and pricing controls  
**Target system:** Mock SAP ERP (example reference: SAP S/4HANA SD + FI-AR + FSCM Credit Management)  
**Version:** 0.1 (English-first)  
**Date:** 2026-01-19  

---

## 1) Purpose
Traceability from Requirements → Business Rules/Decision Tables → UAT tests.

---

## 2) Traceability table
| FR ID | FR summary | Related BR/DT | UAT TC IDs |
|---|---|---|---|
| FR-O2C-001 | Create sales order with pricing conditions | BR-AUD-001 | TC-O2C-001 |
| FR-O2C-002 | Pricing override with reason and approval | BR-PRC-001; DT-PRC-001; BR-AUD-001 | TC-O2C-002, TC-AUD-001 |
| FR-O2C-003 | Credit check and block | BR-CRD-001; DT-CRD-001 | TC-CRD-001 |
| FR-O2C-004 | Release credit block with SoD | BR-CRD-002; BR-AUD-001 | TC-CRD-002, TC-AUD-002 |
| FR-O2C-006 | Billing invoice + credit memo | BR-BIL-001; DT-BIL-001; BR-AUD-001 | TC-BIL-001, TC-BIL-002 |
| FR-CTRL-001 | Audit logging for critical actions | BR-AUD-001 | TC-AUD-001, TC-AUD-002 |
| FR-SEC-001 | RBAC and role separation | (Roles/Permissions) | TC-SEC-001 |
