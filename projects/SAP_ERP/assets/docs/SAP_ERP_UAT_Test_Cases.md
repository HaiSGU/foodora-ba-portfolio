# UAT Test Cases — SAP ERP (Mock) BA Case Study (O2C)

**Standard:** UAT mini-pack aligned to recruiter-friendly evidence and traceability (IEEE 829 not required here)  
**Target system:** Mock SAP ERP (example reference: SAP S/4HANA SD + FI-AR + FSCM Credit Management)  
**Version:** 0.1 (English-first)  
**Date:** 2026-01-19

---

## 1) UAT scope
- In-scope: Sales Order, Pricing override, Credit check/block & release, Billing (invoice/credit memo), Audit logging, RBAC.
- Out-of-scope: Full FI/CO postings detail, EDI integrations, tax engines.

---

## 2) Roles
- **Sales Rep**: creates orders, cannot override pricing beyond tolerance.
- **Sales Manager**: approves pricing override within policy.
- **Credit Analyst**: reviews and releases credit blocks.
- **Billing Clerk**: creates invoices and credit memos.
- **Auditor**: read-only access to logs and documents.

---

## 3) Test cases
### TC-O2C-001 — Create Sales Order (baseline)
**Preconditions:** Customer exists; material exists; Sales Rep role assigned.

**Steps**
1. Create Sales Order with customer + material + quantity.
2. Save.

**Expected**
- Order saved with unique ID.
- Pricing determined automatically.

**Evidence**
- Screenshot of saved order header and pricing condition screen.

---

### TC-O2C-002 — Pricing Override requires reason + approval
**Preconditions:** Sales Rep attempts override beyond tolerance; approval workflow enabled.

**Steps**
1. Sales Rep attempts manual price change beyond allowed tolerance.
2. Enter override reason.
3. Submit for approval.
4. Sales Manager reviews and approves.

**Expected**
- Sales Rep cannot finalize without reason.
- Order status shows “Pending Approval”.
- After approval, order becomes “Approved” and retains audit trail.

**Evidence**
- Screenshot showing pending approval status.
- Screenshot showing approval decision.

---

### TC-CRD-001 — Credit Check blocks order when limit exceeded
**Preconditions:** Customer credit exposure exceeds limit; credit check active.

**Steps**
1. Create Sales Order for customer with exposure > limit.
2. Save.

**Expected**
- Order is blocked for delivery/billing.
- Block reason indicates credit limit exceeded.

**Evidence**
- Screenshot showing credit block reason.

---

### TC-CRD-002 — Credit Block release enforces SoD
**Preconditions:** Sales Rep created blocked order; Credit Analyst role assigned.

**Steps**
1. Sales Rep attempts to release credit block.
2. Credit Analyst releases credit block.

**Expected**
- Sales Rep action is denied.
- Credit Analyst can release.
- Release action is logged.

**Evidence**
- Screenshot of denied access for Sales Rep.
- Screenshot of successful release + audit log entry.

---

### TC-BIL-001 — Billing Invoice created after prerequisites
**Preconditions:** Order approved; credit block cleared.

**Steps**
1. Billing Clerk creates invoice for the order.
2. Post/save invoice.

**Expected**
- Invoice created successfully and linked to Sales Order.
- Posting status indicates completed (or simulated posted).

**Evidence**
- Screenshot of invoice document flow.

---

### TC-BIL-002 — Credit Memo requires reason code and approval (if configured)
**Preconditions:** Invoice exists; credit memo policy active.

**Steps**
1. Billing Clerk creates credit memo referencing invoice.
2. Enter reason code.
3. Submit and (if required) obtain approval.

**Expected**
- Credit memo cannot be posted without reason.
- Approval status tracked.
- Document flow links credit memo to invoice.

**Evidence**
- Screenshot of reason code field + status.

---

### TC-AUD-001 — Audit log captures pricing override
**Preconditions:** TC-O2C-002 executed.

**Steps**
1. Open audit log for the order.

**Expected**
- Log contains: who/when/what (old vs new value), reason, approval ID.

**Evidence**
- Screenshot of audit log record.

---

### TC-AUD-002 — Audit log captures credit release
**Preconditions:** TC-CRD-002 executed.

**Steps**
1. Open audit log for the order.

**Expected**
- Log contains: release actor, timestamp, release outcome, block reason.

**Evidence**
- Screenshot of audit log record.

---

### TC-SEC-001 — RBAC prevents unauthorized billing
**Preconditions:** Sales Rep role assigned; Billing Clerk role not assigned.

**Steps**
1. Sales Rep attempts to create invoice.

**Expected**
- Access denied / authorization failure.
- No invoice created.

**Evidence**
- Screenshot of authorization error.
