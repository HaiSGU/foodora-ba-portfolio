# Requirements, Scope & NFRs (IIBA / BABOK-style)

**Project:** Retail Operations Backoffice (Hệ thống quản lý bán hàng) — Multi-branch (nhiều chi nhánh)  
**Source docs:** UC Descriptions (DOCX, Vietnamese — “VI source”) + module diagrams (UC / Sequence / Activity)  
**Version:** 0.1 (English-first)  
**Owner:** Business Analyst  
**Date:** 2026-01-19  

---

## 1) Purpose
Define a clear, testable set of requirements and boundaries for the system, in a recruiter-friendly BABOK/IIBA documentation style.

---

## 2) Business context
A multi-branch retail organization needs a backoffice system to standardize:
- Sales processing, pricing and promotions
- Inventory movements across branches (receiving, stocktake, transfers, write-off)
- Cashbook recording and daily reconciliation
- Role-based access control and governance
- Summary reporting for branch managers and HQ operations

---

## 3) Stakeholders (summary)
Primary user roles (aligned to VI source actors):
- Cashier (Nhân viên bán hàng)
- Inventory staff (Nhân viên kho)
- Warehouse staff (Thủ kho)
- Branch manager (Quản lý chi nhánh)
- Cashbook clerk (Sổ quỹ / Kế toán cửa hàng)
- System admin (Quản trị hệ thống)
- HQ operations (Quản lý vận hành)

---

## 4) Goals & success criteria
### 4.1 Goals
- G1: Reduce errors and fraud risk via approvals, reason codes, audit logs.
- G2: Improve inventory accuracy per branch through structured stocktake + adjustments.
- G3: Make transfers trackable end-to-end (dispatch → receive) with discrepancy handling.
- G4: Enable consistent promotions with deterministic conflict resolution.
- G5: Provide branch and HQ reporting for operational visibility.

### 4.2 Success criteria (examples)
- SC1: 100% inventory movements are traceable to branch, user, timestamp.
- SC2: Transfers cannot be “lost”: every dispatch has a receiving outcome.
- SC3: Promotions applied at POS are explainable (why selected).

---

## 5) Scope
### 5.1 In scope modules (traceable to VI source UC DOCX)
- Sales — Bán hàng
- Receiving — Nhập hàng
- Stocktake — Kiểm kho
- Inter-branch transfer — Chuyển hàng
- Receive transfer — Nhận hàng từ chi nhánh khác
- Return to supplier — Trả hàng nhập
- Write-off — Xuất hủy
- Product catalog — Quản lý hàng hóa
- Promotions — Quản lý khuyến mại
- User accounts — Quản lý tài khoản người dùng
- Staff management — Quản lý nhân viên
- Branch management — Quản lý chi nhánh
- Cashbook — Sổ quỹ
- Reporting — Thống kê tổng quan

### 5.2 Out of scope
- Accounting integration (ERP), e-invoice, payment gateway integration
- Supplier EDI and automated procurement workflows
- Advanced analytics/BI data warehouse

---

## 6) Assumptions & constraints
### 6.1 Assumptions
- A1: Each transaction belongs to one branch.
- A2: A user is assigned to one or more branches and one role.
- A3: Certain high-risk actions require branch manager approval.

### 6.2 Constraints
- C1: Must support Vietnamese labels and local workflows (course artifacts are Vietnamese).
- C2: Must support multi-branch reporting and role separation (Branch vs HQ).

---

## 7) Functional requirements (FR)
Format: FR-ID, statement, priority, rationale, acceptance notes.

### 7.1 Sales (Bán hàng)
| FR ID | Requirement | Priority | Acceptance notes |
|---|---|---:|---|
| FR-SALES-001 | The system shall create a sales invoice with branch, cashier, timestamp, line items, totals, and payment method. | High | Invoice is uniquely identifiable and auditable. |
| FR-SALES-002 | The system shall apply eligible promotions to a basket and record which promotion(s) were applied. | High | Receipt/audit shows “why applied”. |
| FR-SALES-003 | The system shall support cancellation/return flows according to permissions and policy. | High | Return requires reason code; manager approval if configured. |

### 7.2 Promotions (Quản lý khuyến mại)
| FR ID | Requirement | Priority | Acceptance notes |
|---|---|---:|---|
| FR-PROMO-001 | The system shall create and maintain promotions with date range, branch scope, and product scope. | High | Validation prevents invalid date ranges. |
| FR-PROMO-002 | The system shall resolve promotion conflicts deterministically (e.g., priority then tie-break). | High | Same inputs produce same result. |

### 7.3 Inventory & stock movements
| FR ID | Requirement | Priority | Acceptance notes |
|---|---|---:|---|
| FR-INV-001 | The system shall record receiving (Nhập hàng) to increase stock at a branch. | High | Receiving requires supplier reference or reason. |
| FR-INV-002 | The system shall support stocktake sessions and capture counted quantities per SKU. | High | Stocktake has lifecycle: Draft → Submitted → Approved. |
| FR-INV-003 | The system shall support stock adjustments after stocktake with reason codes and approval. | High | Adjustment is linked to a stocktake session. |
| FR-INV-004 | The system shall record write-off (Xuất hủy) with reason codes and approvals per policy. | High | Audit log required. |

### 7.4 Inter-branch transfer
| FR ID | Requirement | Priority | Acceptance notes |
|---|---|---:|---|
| FR-TRF-001 | The system shall create a transfer order from source branch to destination branch with items and quantities. | High | Transfer ID is unique. |
| FR-TRF-002 | The system shall support dispatch at source branch and decrease stock accordingly. | High | Dispatch recorded with user + timestamp. |
| FR-TRF-003 | The system shall support receiving at destination branch and increase stock accordingly. | High | Receiving confirms quantities. |
| FR-TRF-004 | The system shall capture discrepancies (short/over/damaged) and require approval per policy. | Medium | Discrepancy record created. |

### 7.5 Administration (accounts, staff, branches)
| FR ID | Requirement | Priority | Acceptance notes |
|---|---|---:|---|
| FR-ADM-001 | The system shall manage user accounts and assign roles/permissions. | High | Least-privilege defaults. |
| FR-ADM-002 | The system shall manage staff records and link them to user accounts (if applicable). | Medium | Staff status = active/inactive. |
| FR-ADM-003 | The system shall manage branches and branch configuration for multi-branch operations. | High | Branch code is unique. |

### 7.6 Cashbook & reporting
| FR ID | Requirement | Priority | Acceptance notes |
|---|---|---:|---|
| FR-CASH-001 | The system shall record cashbook entries and reconcile end-of-day cash status. | High | Balanced/Short/Over captured with reason. |
| FR-REP-001 | The system shall provide summary reporting for sales, inventory, and cash by branch and date. | Medium | Filters include branch/date range. |

---

## 8) Non-functional requirements (NFR)
| NFR ID | Category | Requirement |
|---|---|---|
| NFR-001 | Usability | POS flows must support fast operation: common sale flow ≤ 5 primary steps on-screen. |
| NFR-002 | Auditability | All critical actions (adjustment, write-off, promotion change, permission change) must have audit logs: who/what/when/before-after. |
| NFR-003 | Security | Enforce role-based access control; approvals must be attributable to a user. |
| NFR-004 | Availability | System should be available during store operating hours; graceful handling for network issues. |
| NFR-005 | Performance | Sale invoice creation should complete within an acceptable response time for busy periods. |
| NFR-006 | Data integrity | Branch stock cannot be corrupted by partial updates (transactions must be consistent). |

---

## 9) Glossary / Terminology mapping
| Vietnamese (VI source) | English (used in this doc) |
|---|---|
| Chi nhánh | Branch |
| Bán hàng | Sales |
| Kiểm kho | Stocktake |
| Chuyển hàng | Inter-branch transfer |
| Nhập hàng | Receiving |
| Xuất hủy | Write-off |
| Sổ quỹ | Cashbook |
| Khuyến mại | Promotions |

Abbreviations:
- FR = Functional Requirement
- NFR = Non-functional Requirement
- HQ = Headquarter
