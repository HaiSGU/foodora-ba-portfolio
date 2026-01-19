# Requirements, Scope & NFRs (SAP ERP (Mock) — BA Case Study)

**Scenario:** Order-to-Cash (O2C) with credit and pricing controls  
**Target system:** Mock SAP ERP (example reference: SAP S/4HANA SD + FI-AR + FSCM Credit Management)  
**Version:** 0.1 (English-first)  
**Date:** 2026-01-19  

---

## 1) Scope
### In scope
- Sales order management (create/change/cancel)
- Pricing conditions and overrides (with approvals)
- Credit checks and credit blocks (with release workflow)
- Delivery and goods issue status (high level)
- Billing (invoice / credit memo)
- Payment posting and simple dispute tracking
- Auditability and role-based access control (RBAC)

### Out of scope
- Full warehouse management (WM/EWM) detail
- Detailed tax localization rules
- Integration to external payment gateways
- Complex revenue recognition

---

## 2) Assumptions
- Single company code, multiple sales areas (configurable)
- Pricing is condition-based; some conditions are approval-controlled
- Credit exposure is calculated using open orders + open invoices

---

## 3) Functional requirements (FR)
| FR ID | Requirement | Priority | Acceptance notes |
|---|---|---:|---|
| FR-O2C-001 | The system shall create a sales order with customer, items, requested delivery date, and pricing conditions. | High | Order has unique ID and audit trail. |
| FR-O2C-002 | The system shall support pricing overrides and capture the override reason. | High | Override requires approval per policy. |
| FR-O2C-003 | The system shall perform credit check at order save and block if credit is exceeded. | High | Block reason is visible and reportable. |
| FR-O2C-004 | The system shall allow authorized users to release a credit block with reason and audit log. | High | Segregation of duties enforced. |
| FR-O2C-005 | The system shall create delivery status for logistics and update goods issue outcome. | Medium | Status is traceable to order. |
| FR-O2C-006 | The system shall create billing invoices from delivered items and support credit memos. | High | Billing is auditable and linked. |
| FR-O2C-007 | The system shall post payments against invoices and show open/cleared status. | Medium | Supports partial payment. |
| FR-O2C-008 | The system shall support cancellations/returns with reason codes and credit memo creation. | High | Approval required above threshold. |
| FR-CTRL-001 | The system shall provide audit logs for critical actions (pricing override, block release, credit memo). | High | Who/what/when/before-after. |
| FR-SEC-001 | The system shall enforce RBAC and least privilege with role separation. | High | Prevents same user from approving own override if configured. |

---

## 4) Non-functional requirements (NFR)
| NFR ID | Category | Requirement |
|---|---|---|
| NFR-001 | Security | RBAC enforced; privileged actions require approval and are audited. |
| NFR-002 | Auditability | Critical actions must record before/after values and reason codes. |
| NFR-003 | Performance | Sales order save should be responsive in peak hours. |
| NFR-004 | Availability | System available during business hours; graceful error messaging. |
| NFR-005 | Data integrity | Credit exposure and pricing calculations are consistent and reproducible. |

---

## 5) Glossary
- O2C = Order-to-Cash
- SoD = Segregation of Duties
