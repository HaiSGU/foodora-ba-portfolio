# Product Requirements Document (PRD) — SAP ERP (Mock) BA Case Study (O2C)

**Product / Module:** Mock SAP ERP — Order-to-Cash (O2C)  
**Example reference platform:** SAP S/4HANA (SD + FI-AR + FSCM Credit Management)  
**Simulation note:** Portfolio mock; terminology references S/4HANA to be concrete; no proprietary SAP content  
**Version:** 0.1 (English-first)  
**Date:** 2026-01-19  

---

## 1) Problem Statement
Mid-size companies running O2C often suffer from inconsistent pricing overrides, weak credit control enforcement, and limited auditability. These gaps increase revenue leakage, disputes, and compliance risk.

---

## 2) Goals & Success Metrics
### 2.1 Goals
- Standardize Sales Order creation and pricing determination.
- Enforce pricing override governance (reason + approval).
- Enforce credit control (block/release) with proper segregation of duties.
- Ensure auditability for critical business actions.

### 2.2 Success metrics (examples)
- Reduction in unauthorized pricing overrides.
- Reduction in credit-related bad debt incidents.
- Audit findings reduced for O2C controls.
- Faster approval cycle time for overrides.

---

## 3) Scope
### 3.1 In scope
- Sales Order creation (baseline)
- Pricing override request + approval
- Credit check, credit block and release
- Billing: invoice creation and credit memo controls
- RBAC and SoD controls
- Audit logging and evidence capture

### 3.2 Out of scope
- Full FI/CO accounting postings and reconciliation
- EDI/IDoc, external tax engines, and downstream integrations
- Warehouse execution details

---

## 4) Users & Personas (high-level)
- **Sales Rep:** creates orders; cannot override price beyond tolerance.
- **Sales Manager:** approves pricing overrides.
- **Credit Analyst:** reviews and releases credit blocks.
- **Billing Clerk:** creates invoices and credit memos.
- **Auditor:** read-only access to documents and logs.

---

## 5) Key Use Scenarios
- Create Sales Order with automatic pricing.
- Request pricing override with reason; manager approves.
- Credit check blocks order; credit analyst releases after review.
- Billing creates invoice after prerequisites.
- Create credit memo with reason (and approval if configured).

---

## 6) High-level Requirements (PRD view)
### 6.1 Functional overview
- System shall support Sales Order creation with pricing conditions.
- System shall require reason + approval for out-of-tolerance pricing overrides.
- System shall block processing when customer exposure exceeds credit limit.
- System shall enforce SoD: Sales cannot release credit block.
- System shall produce an audit trail for critical actions.

### 6.2 Non-functional overview
- Security: RBAC, least privilege, SoD.
- Auditability: immutable logs for critical actions.
- Usability: clear error messages and actionable statuses.

---

## 7) Acceptance Criteria (at product level)
- Pricing override cannot be completed without reason and approval.
- Credit block triggers correctly when limit exceeded.
- Only authorized role can release credit block.
- Billing is prevented when prerequisites are not met.
- Audit log captures who/when/what and approval references.

---

## 8) Dependencies & Assumptions
- Roles and authorizations are provisioned for UAT.
- Test data exists (customers, materials, credit exposures).
- Approval workflow engine is available (simulated).

---

## 9) Risks
- Over-customization increases long-term maintenance risk.
- Poor role design can break SoD controls.
- Missing evidence capture weakens audit readiness.
