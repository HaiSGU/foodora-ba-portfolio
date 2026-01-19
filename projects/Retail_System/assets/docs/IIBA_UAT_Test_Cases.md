# UAT Mini Pack — Test Scenarios & Test Cases (BA/UAT)

**Project:** Retail Operations Backoffice (Hệ thống quản lý bán hàng) — Multi-branch (nhiều chi nhánh)  
**Source docs:** UC Descriptions (DOCX, Vietnamese — “VI source”) + module diagrams (UC / Sequence / Activity)  
**Version:** 0.2 (English-first, aligned to locked policies)  
**Owner:** Business Analyst  
**Date:** 2026-01-19  

---

## 1) Purpose
Provide a small but credible UAT pack that validates:
- Critical end-to-end flows (sales, inventory movements, transfers, cashbook)
- Key controls (approvals, reason codes, audit logs)
- Multi-branch correctness

This is intentionally “mini”: enough to demonstrate BA test thinking without being a full QA test suite.

---

## 2) UAT approach
- Focus: business acceptance, not technical testing.
- Evidence: screenshots or exported reports may be attached during actual UAT.
- Entry criteria: roles/branches configured; sample products and promotions exist.
- Exit criteria: all High priority tests pass; critical defects resolved or accepted.

---

## 3) Test data (baseline)
Branches:
- B1 = Branch A (chi nhánh A)
- B2 = Branch B (chi nhánh B)

Products:
- P1 = SKU-001 (normal item)
- P2 = SKU-002 (promo eligible)

Users:
- U-CA = Cashier at B1
- U-INV = Inventory staff at B1
- U-WH = Warehouse staff at B1
- U-BM = Branch manager at B1
- U-ADM = System admin

---

## 4) Test cases
Format: ID, objective, preconditions, steps, expected results.

### 4.1 Sales
**TC-SALES-001 — Create sales invoice with branch attribution**
- Preconditions: U-CA logged in at B1; P1 exists and is in stock at B1.
- Steps:
  1) Create a new sale invoice at B1.
  2) Add P1 quantity 1.
  3) Complete payment.
- Expected:
  - Invoice is created with Branch=B1, user=U-CA, timestamp.
  - Stock at B1 decreases by 1.
  - Audit/event log exists for invoice creation.

**TC-SALES-002 — Return/cancel requires reason and permission**
- Preconditions: TC-SALES-001 invoice exists.
- Steps:
  1) Attempt return/cancel as U-CA.
  2) If blocked, request approval by U-BM.
  3) Enter reason code and confirm.
- Expected:
  - System enforces configured permission/approval.
  - Reason code is mandatory.
  - Stock and cashbook reflect the return per policy.

### 4.2 Promotions
**TC-PROMO-001 — Promotion eligibility applies at POS**
- Preconditions: Promotion exists for P2 at B1 within date range.
- Steps:
  1) Create invoice and add P2.
  2) Observe discount applied.
- Expected:
  - Promotion applies only if eligible.
  - Invoice records applied promotion ID and discount amount.

**TC-PROMO-002 — Promotion conflict resolution is deterministic**
- Preconditions: Two promotions match P2; conflict rule configured (e.g., priority).
- Steps:
  1) Create invoice with P2.
  2) Validate which promotion is selected.
- Expected:
  - Selection follows policy and is explainable (priority + tie-break).

### 4.3 Receiving and stocktake
**TC-INV-REC-001 — Receiving increases branch stock**
- Preconditions: U-INV logged in at B1.
- Steps:
  1) Create receiving record for P1 quantity +10.
  2) Confirm/submit.
- Expected:
  - Stock at B1 increases by 10.
  - Receiving record is auditable.

**TC-STK-001 — Stocktake lifecycle**
- Preconditions: U-INV at B1.
- Steps:
  1) Create stocktake session.
  2) Enter counted quantities.
  3) Submit.
  4) Approve adjustment as U-BM.
- Expected:
  - Stocktake status transitions correctly.
  - Adjustments require approval and reason codes.

### 4.4 Negative stock control
**TC-INV-NEG-001 — Negative stock policy enforced (sale)**
- Preconditions: Stock of P1 at B1 = 0; negative stock policy is locked: block by default, BM override allowed for Sales/Transfer Dispatch.
- Steps:
  1) Attempt sale of P1 quantity 1.
  2) Request U-BM override.
  3) Provide override reason.
- Expected:
  - Transaction is blocked for U-CA.
  - With BM override, transaction completes.
  - Override is recorded with reason and audit log.

### 4.5 Transfers
**TC-TRF-001 — Create transfer order B1 → B2**
- Preconditions: U-WH at B1; stock available.
- Steps:
  1) Create transfer order from B1 to B2 for P1 quantity 5.
- Expected:
  - Transfer order created with correct source/destination.

**TC-TRF-002 — Dispatch transfer decreases source stock**
- Preconditions: Transfer order exists.
- Steps:
  1) Dispatch transfer at B1.
- Expected:
  - Stock at B1 decreases.
  - Dispatch is audited.

**TC-TRF-003 — Receive transfer increases destination stock**
- Preconditions: Transfer dispatched.
- Steps:
  1) Receive transfer at B2.
- Expected:
  - Stock at B2 increases.
  - Transfer status becomes closed/received.

**TC-TRF-004 — Discrepancy handling requires reason and approval**
- Preconditions: Transfer dispatched.
- Steps:
  1) Receive at B2 with quantity != dispatched.
  2) Enter discrepancy reason.
  3) Approve as U-BM (or per policy).
- Expected:
  - Discrepancy record is created.
  - Approval is captured.

**TC-TRF-005 — Discrepancy within tolerance does not require approval**
- Preconditions: Transfer dispatched with P1 dispatched qty = 100.
- Steps:
  1) Receive at B2 with received qty = 99 (discrepancy = 1).
  2) Submit receipt.
- Expected:
  - System treats discrepancy as within tolerance (max(2 units, 0.5% rounded up) = 2).
  - Transfer can be closed without BM approval.
  - Discrepancy record is still captured for audit.

### 4.6 Write-off
**TC-WO-001 — Write-off requires reason code**
- Preconditions: U-INV at B1.
- Steps:
  1) Create write-off for P1 quantity 1.
  2) Try to submit without reason.
  3) Provide reason and submit.
- Expected:
  - Reason is mandatory.
  - Record is auditable.

**TC-WO-002 — Write-off approval enforced**
- Preconditions: Write-off request exists.
- Steps:
  1) Attempt to approve as U-INV.
  2) Approve as U-BM.
- Expected:
  - Only permitted role can approve.
  - Approval is audited.

**TC-WO-003 — High-risk write-off requires evidence (threshold)**
- Preconditions: Threshold policy exists: write-off qty ≥ 5 units or estimated value ≥ 1,000,000 VND requires attachment/evidence.
- Steps:
  1) Create write-off for P1 quantity 5.
  2) Try to submit without attachment/evidence reference.
  3) Provide attachment/evidence reference and submit.
- Expected:
  - Submission is blocked without evidence.
  - With evidence, submission proceeds and is audited.

### 4.7 Cashbook and reporting
**TC-CASH-001 — End-of-day reconciliation status**
- Preconditions: Sales exist for the day.
- Steps:
  1) Perform end-of-day close.
  2) Enter counted cash != expected.
- Expected:
  - Status becomes Short/Over.
  - Manager note required.

**TC-REP-001 — Reporting by branch/date**
- Preconditions: Data exists in B1 and B2.
- Steps:
  1) Run summary report by date range.
  2) Filter by branch.
- Expected:
  - Totals are correct and scoped per branch.

---

## 5) Traceability
Refer to the Requirements Traceability Matrix (RTM) to ensure each High priority FR is covered.
