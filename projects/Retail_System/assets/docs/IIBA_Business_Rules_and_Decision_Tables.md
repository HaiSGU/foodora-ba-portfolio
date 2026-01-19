# Business Rules & Decision Tables (IIBA / BABOK-style)

**Project:** Retail Operations Backoffice (Hệ thống quản lý bán hàng) — Multi-branch (nhiều chi nhánh)  
**Source docs:** UC Descriptions (DOCX, Vietnamese — “VI source”) + module diagrams (UC / Sequence / Activity)  
**Version:** 0.2 (English-first, locked policies)  
**Owner:** Business Analyst  
**Date:** 2026-01-19  

---

## 1) Purpose
Provide a recruiter-friendly, BABOK-aligned **Business Rules** pack for a multi-branch retail backoffice system:
- Rule catalog (what rules exist and why)
- Decision tables (clear, testable logic)
- Governance & approval (who can change which rules)

---

## 2) Scope
### 2.1 Modules covered (traceable to VI source UC DOCX)
- Sales — Bán hàng
- Promotions — Quản lý khuyến mại
- Product catalog — Quản lý hàng hóa
- Receiving — Nhập hàng
- Stocktake — Kiểm kho
- Inter-branch transfer — Chuyển hàng
- Receive transfer — Nhận hàng từ chi nhánh khác
- Write-off — Xuất hủy
- Cashbook — Sổ quỹ
- Reporting — Thống kê tổng quan

### 2.2 Out of scope (for this document)
- UI design details (handled by screen flows / diagrams)
- Technical architecture and integrations

---

## 3) Rule categories
- Inventory integrity (negative stock, adjustments, write-off)
- Promotion eligibility and conflicts
- Approval & override controls (thresholds)
- Inter-branch transfer integrity (dispatch/receipt, discrepancies)
- Cashbook controls (end-of-day reconciliation)

---

## 4) Business Rule Catalog
Format: **Rule ID**, statement, rationale, impacted modules, owner/approval.

### 4.0 Locked policy decisions (baseline)
To make this portfolio “production-ready”, the following baseline policies are **locked** for consistency across Rules → RTM → UAT:
- **Negative stock:** Block by default. Allow override only by **Branch manager (BM)**, only for **Sales** and **Transfer Dispatch**, and always with reason + audit log.
- **Promotion conflict resolution:** Use an explicit **priority** field. Tie-break order: (1) highest discount value, (2) earliest created.
- **Transfer discrepancy tolerance:** Per SKU tolerance = **max(2 units, 0.5% of dispatched qty rounded up)**. Discrepancies above tolerance require BM approval and a discrepancy record.
- **Evidence/attachments:** Required for high-risk inventory actions above thresholds (see BR-INV-005).

### 4.1 Inventory integrity
**BR-INV-001 — Branch-level stock is the single source of truth**  
- Statement: All inventory movements must be recorded against a **Branch (chi nhánh)** and a product SKU.
- Rationale: Supports auditability and multi-branch reporting.
- Modules: Stocktake (Kiểm kho), Receiving (Nhập hàng), Transfer (Chuyển hàng), Write-off (Xuất hủy), Sales (Bán hàng)
- Owner/Approval: OPS + ADM (policy), BM (operational enforcement)

**BR-INV-002 — Negative stock policy**  
- Statement: The system shall **block** transactions that would result in negative stock.
- Exception: **BM override** is allowed for Sales and Transfer Dispatch only, with a mandatory reason and audit trail.
- Modules: Sales, Transfer dispatch
- Owner/Approval: OPS (policy), ADM (implementation), BM (override usage)

**BR-INV-003 — Stock adjustments require reason codes**  
- Statement: Any adjustment after Stocktake must have a reason code and reference stocktake session.
- Modules: Stocktake
- Owner/Approval: OPS (reason codes), BM (approval), ADM (permissions)

**BR-INV-004 — Write-off requires mandatory evidence fields**  
- Statement: Write-off (Xuất hủy) requires: reason code + notes, and optional attachment reference (if used).
- Modules: Write-off
- Owner/Approval: BM + OPS

**BR-INV-005 — Evidence thresholds for inventory risk controls**  
- Statement: Evidence/attachment becomes mandatory when inventory actions exceed thresholds.
- Default thresholds (configurable):
  - Write-off: qty ≥ 5 units **or** estimated value ≥ 1,000,000 VND
  - Stock adjustment after stocktake: abs(qty delta) ≥ 10 units **or** estimated value ≥ 2,000,000 VND
- Modules: Stocktake, Write-off
- Owner/Approval: OPS (threshold policy), ADM (config), BM (enforcement)

### 4.2 Promotions
**BR-PROMO-001 — Promotion eligibility**  
- Statement: A promotion applies only if all eligibility criteria are satisfied (date range, branch scope, product scope, customer type if any).
- Modules: Promotions, Sales
- Owner/Approval: OPS

**BR-PROMO-002 — Promotion conflict resolution**  
- Statement: When multiple promotions match, system must apply a deterministic conflict rule.
- Locked baseline: priority (manual) > highest discount amount > earliest created.
- Modules: Promotions, Sales
- Owner/Approval: OPS (policy), ADM (implementation)

**BR-PROMO-003 — Promotion change control**  
- Statement: Creating/updating promotions requires approval (at least BM or OPS depending on scope).
- Modules: Promotions
- Owner/Approval: OPS + BM

### 4.3 Transfer integrity
**BR-TRF-001 — Transfer is a two-step lifecycle**  
- Statement: Inter-branch transfer includes at minimum: Create/Dispatch (source) and Receive/Confirm (destination).
- Modules: Transfer, Receive transfer
- Owner/Approval: OPS

**BR-TRF-002 — Discrepancy handling**  
- Statement: If received quantity differs from dispatched quantity, the system must capture discrepancy reason and approval.
- Modules: Transfer, Receive transfer
- Owner/Approval: BM + OPS

**BR-TRF-003 — Discrepancy tolerance (locked baseline)**  
- Statement: Per SKU tolerance = max(2 units, 0.5% of dispatched qty rounded up). Above tolerance requires BM approval.
- Modules: Transfer, Receive transfer
- Owner/Approval: OPS (policy), BM (approval)

### 4.4 Cashbook controls
**BR-CASH-001 — Cashbook entries are traceable to sales and adjustments**  
- Statement: Cashbook entries must reconcile with sales receipts, refunds, and approved cash adjustments.
- Modules: Cashbook, Sales
- Owner/Approval: BM

**BR-CASH-002 — End-of-day close requires reconciliation**  
- Statement: Daily close requires reconciliation outcome: Balanced / Short / Over with reason.
- Modules: Cashbook, Reporting
- Owner/Approval: BM

---

## 5) Decision Tables
Decision tables below translate key policies into testable logic.

### 5.1 DT-INV-NEG-001 — Negative stock handling
**Trigger:** A transaction reduces available stock below 0.

Inputs:
- Transaction type = Sale / Transfer Dispatch / Write-off
- Product allows negative stock? (Yes/No)
- User role = Cashier / Inventory / Warehouse / Branch manager
- Override permitted? (Yes/No)

Outputs:
- Allow transaction? (Yes/No)
- Require override? (Yes/No)
- Log event for audit? (Yes/No)

| Condition / Rule | R1 | R2 | R3 | R4 |
|---|---|---|---|---|
| Transaction type is Sales or Transfer Dispatch | Yes | Yes | Yes | Yes |
| Negative stock would occur | Yes | Yes | Yes | Yes |
| User role is Branch manager (BM) | No | Yes | No | Yes |
| Override permitted (policy) | N/A | Yes | N/A | Yes |
| **Allow transaction** | No | Yes | No | Yes |
| **Require override** | N/A | Yes | N/A | Yes |
| **Audit log** | Yes | Yes | Yes | Yes |

Notes:
- Locked baseline: Negative stock is blocked unless BM override is used.
- R4 represents a branch manager using override; R1/R3 represent non-BM attempts.

### 5.2 DT-PROMO-001 — Promotion selection (conflict resolution)
**Trigger:** Multiple promotions match the basket.

Inputs:
- Promotions matched count (0/1/Many)
- Has priority field? (Yes/No)
- Discount type = % / fixed amount / buy X get Y

Outputs:
- Selected promotion
- Explanation text for receipt/audit

| Condition / Rule | R1 | R2 | R3 |
|---|---|---|---|
| Promotions matched | 0 | 1 | Many |
| Has priority field | N/A | N/A | Yes |
| **Selected promotion** | None | The one matched | Highest priority (tie-break by max discount) |
| **Explain selection** | N/A | “Single match” | “Priority + tie-break” |

### 5.3 DT-TRF-001 — Transfer discrepancy handling
**Trigger:** Destination confirms receipt.

Inputs:
- Received qty equals dispatched qty? (Yes/No)
- Discrepancy within tolerance? (Yes/No)
- Approval provided? (Yes/No)

Outputs:
- Close transfer? (Yes/No)
- Create discrepancy record? (Yes/No)

| Condition / Rule | R1 | R2 | R3 | R4 |
|---|---|---|---|---|
| Qty matches | Yes | No | No | No |
| Within tolerance | N/A | Yes | Yes | No |
| Approval provided | N/A | No | Yes | Yes |
| **Close transfer** | Yes | No | Yes | Yes |
| **Discrepancy record** | No | Yes | Yes | Yes |

Notes:
- “Within tolerance” uses BR-TRF-003 baseline: max(2 units, 0.5% of dispatched qty rounded up).

### 5.4 DT-CASH-001 — End-of-day cash reconciliation
Inputs:
- Expected cash (from system)
- Counted cash (physical)
- Difference = counted - expected

Outputs:
- Status = Balanced / Short / Over
- Require manager note? (Yes/No)

| Condition / Rule | R1 | R2 | R3 |
|---|---|---|---|
| Difference | 0 | < 0 | > 0 |
| **Status** | Balanced | Short | Over |
| **Require manager note** | No | Yes | Yes |

---

## 6) Governance (rule ownership & change control)
- OPS owns: policy-level rules (promotion conflicts, negative stock baseline, reason codes).
- ADM owns: permission model and enforcement implementation.
- BM owns: branch-level approvals and exception handling.

Change control recommendation:
- Any rule change impacting cash or inventory integrity requires OPS + ADM approval.
- Any threshold/override change requires BM concurrence (operational impact).

---

## 7) Open Questions (next iteration)
These are not required to keep the baseline consistent, but can further strengthen realism:
1. Should BM override require dual control (BM + OPS) for some cases?
2. Should tolerance vary by product category (fragile/high-value vs standard)?
3. Should write-off thresholds be quantity-based only, value-based only, or both?

---

## 8) Glossary / Terminology mapping
| Vietnamese (VI source) | English (used in this doc) |
|---|---|
| Chi nhánh | Branch |
| Bán hàng | Sales |
| Chuyển hàng | Inter-branch transfer |
| Kiểm kho | Stocktake |
| Nhập hàng | Receiving |
| Nhận hàng từ chi nhánh khác | Receive transfer |
| Trả hàng nhập | Return to supplier |
| Xuất hủy | Write-off |
| Sổ quỹ | Cashbook |
| Quản lý hàng hóa | Product catalog |
| Quản lý khuyến mại | Promotions |
| Thống kê tổng quan | Reporting |

Abbreviations:
- BR = Business Rule
- DT = Decision Table
- OPS = HQ operations
- ADM = System admin
- BM = Branch manager
