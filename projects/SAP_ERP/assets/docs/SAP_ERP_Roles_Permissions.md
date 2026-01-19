# Roles & Permissions Matrix (SAP ERP (Mock) — BA Case Study)

**Scenario:** Order-to-Cash (O2C) with credit and pricing controls  
**Target system:** Mock SAP ERP (example reference: SAP S/4HANA SD + FI-AR + FSCM Credit Management)  
**Version:** 0.1 (English-first)  
**Date:** 2026-01-19  

---

## 1) Roles
- SR = Sales rep
- SM = Sales manager
- CC = Credit controller
- WH = Warehouse clerk
- BA = Billing accountant
- AR = Accounts receivable
- AUD = Internal audit
- ADM = System admin

Permission levels:
- View
- Create/Update
- Approve/Release
- Admin

---

## 2) Permission matrix
| Module / Action | SR | SM | CC | WH | BA | AR | AUD | ADM |
|---|---|---|---|---|---|---|---|---|
| Create/change sales order | Create/Update | View | View | View | View | View | View | View |
| Approve pricing override | View | Approve/Release | View | View | View | View | View | View |
| View credit exposure | View | View | View | View | View | View | View | View |
| Release credit block | View | View | Approve/Release | View | View | View | View | View |
| Create delivery status update | View | View | View | Create/Update | View | View | View | View |
| Create billing invoice | View | View | View | View | Create/Update | View | View | View |
| Create credit memo | View | View | View | View | Create/Update | View | View | View |
| Approve credit memo (above threshold) | View | View | Approve/Release | View | View | View | View | View |
| Post payments | View | View | View | View | View | Create/Update | View | View |
| View audit logs | View | View | View | View | View | View | View | View |
| Manage roles/authorizations | View | View | View | View | View | View | View | Admin |

---

## 3) Notes
- SoD: prevent same user from requesting and approving the same override when enabled.
- Audit role should be read-only.
