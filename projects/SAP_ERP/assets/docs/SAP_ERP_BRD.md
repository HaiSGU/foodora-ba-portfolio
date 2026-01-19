# Business Requirements Document (BRD) — SAP ERP (Mock) BA Case Study (O2C)

**Domain:** Sales, Credit, Billing controls (Order-to-Cash)  
**Target system:** Mock SAP ERP (example reference: SAP S/4HANA SD + FI-AR + FSCM Credit Management; terminology only)  
**Version:** 0.1 (English-first)  
**Date:** 2026-01-19  

---

## 1) Executive Summary
This BRD defines business requirements for standardizing Order-to-Cash (O2C) execution with stronger governance over pricing overrides, credit control, billing controls, and auditability.

---

## 2) Business Objectives
- Reduce revenue leakage due to uncontrolled pricing overrides.
- Reduce financial risk through consistent credit policy enforcement.
- Improve compliance via auditable approvals and role-based segregation of duties.
- Improve operational clarity: clear statuses, blocks, and release actions.

---

## 3) Business Scope
### 3.1 In scope
- Sales order governance
- Pricing override governance
- Credit control enforcement
- Billing governance (invoice and credit memo)
- Audit evidence and reporting

### 3.2 Out of scope
- Accounting close processes
- Integration interfaces (IDoc/EDI)
- Advanced warehouse processes

---

## 4) Stakeholders (summary)
- Sales Operations
- Sales Management
- Credit & Risk
- Billing/Finance Operations
- Internal Audit / Compliance
- IT / ERP Support

---

## 5) Current State vs Future State (high level)
### Current state (typical issues)
- Manual pricing overrides without consistent reasons/approvals.
- Credit checks applied inconsistently.
- Billing sometimes proceeds before prerequisites.
- Limited audit evidence for overrides and releases.

### Future state (target)
- Controlled override workflow with mandatory reason and approval.
- Standardized credit checks with enforced blocks and controlled releases.
- Billing gated by prerequisite statuses.
- Full audit trail for critical actions and access controls.

---

## 6) Business Requirements
| BR ID | Requirement | Priority | Rationale |
|---|---|---|---|
| BR-001 | Enforce pricing override governance (reason + approval) | High | Prevent revenue leakage and disputes |
| BR-002 | Enforce credit check and credit block when limit exceeded | High | Reduce financial risk |
| BR-003 | Enforce SoD for credit release | High | Compliance and control |
| BR-004 | Gate billing based on prerequisite statuses | High | Reduce billing errors |
| BR-005 | Provide auditability for critical actions | High | Audit readiness |
| BR-006 | Provide clear statuses and user guidance | Medium | Operational efficiency |

---

## 7) Business Rules (reference)
Business rules are documented in the dedicated Business Rules + Decision Tables deliverable.

---

## 8) Constraints & Assumptions
- Role model exists and is approved by business and audit.
- Approval workflow is configured.
- Audit log retention meets policy.

---

## 9) Risks & Mitigations
- Risk: Users bypass process with workarounds → Mitigation: enforce system gating + monitoring.
- Risk: Approval delays → Mitigation: SLA targets + escalation paths.
- Risk: Role creep breaks SoD → Mitigation: periodic access review.
