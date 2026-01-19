# Stakeholder Engagement Approach & RACI (IIBA / BABOK-style)

**Project:** Retail Operations Backoffice (Hệ thống quản lý bán hàng) — Multi-branch (nhiều chi nhánh)  
**Source docs:** UC Descriptions (DOCX, Vietnamese — “VI source”) + module diagrams (UC / Sequence / Activity)  
**Version:** 0.2 (English-first)  
**Owner:** Business Analyst  
**Date:** 2026-01-19  

---

## 1) Purpose
Define how stakeholders will be identified and engaged, how decisions will be governed, and who is responsible/accountable for key activities.

This document is written in a BABOK-aligned style (Stakeholder Engagement + Governance) for a **multi-branch** retail backoffice system.

---

## 2) Scope
### 2.1 In-scope modules (traceable to VI source UC DOCX)
- Bán hàng (Sales)
- Chuyển hàng (Inter-branch transfer)
- Kiểm kho (Stocktake)
- Nhập hàng (Receiving / Purchase receiving)
- Nhận hàng từ chi nhánh khác (Receive transfer)
- Trả hàng nhập (Return to supplier)
- Xuất hủy (Write-off)
- Quản lý hàng hóa (Product catalog)
- Quản lý khuyến mại (Promotions)
- Quản lý tài khoản người dùng (User accounts)
- Quản lý nhân viên (Staff management)
- Quản lý chi nhánh (Branch management)
- Sổ quỹ (Cashbook)
- Thống kê tổng quan (Reporting)

### 2.2 Multi-branch assumptions
- Every transaction is tied to a **Branch (chi nhánh)**.
- Certain actions require **approval / override** (e.g., write-off, stock adjustments, promotion setup).
- Some users operate at **Branch level**, others at **HQ/Admin level**.

---

## 3) Stakeholder Register (Stakeholder Identification)
Use this table as the “single source of truth” for who matters, what they care about, and how we engage them.

| Stakeholder / Role | Level | Key responsibilities | Pain points / interests | Influence | Engagement level (Current → Target) |
|---|---|---|---|---|---|
| Cashier (Nhân viên bán hàng) | Branch | Create invoices, apply promotions, handle returns/cancellations per policy | Speed at POS, pricing accuracy, promotion correctness | Medium | Consult → Consult |
| Inventory staff (Nhân viên kho) | Branch | Receiving support, stocktake, adjustments (with reason codes) | Stock accuracy, clear procedures, auditability | Medium | Consult → Collaborate |
| Warehouse staff (Thủ kho / kho tổng) | Branch/HQ | Prepare transfers, dispatch goods, manage stock movements | Clear transfer status, fewer discrepancies | Medium | Consult → Collaborate |
| Branch manager (Quản lý cửa hàng / Quản lý chi nhánh) | Branch | Approvals, overrides, local performance/reporting | Controls, audit trail, operational visibility | High | Consult → Empower (for approvals) |
| Cashbook clerk (Sổ quỹ / Kế toán cửa hàng) | Branch | Record cashbook entries, reconcile daily cash | Accurate cashbook, reconciliation support | Medium | Consult → Consult |
| System admin (Quản trị hệ thống) | HQ | User/account management, permissions, branch setup | Security, low support burden, least privilege | High | Consult → Collaborate |
| HQ operations (Quản lý vận hành) | HQ | Policies across branches, governance, reporting | Standardization, compliance, roll-out constraints | High | Consult → Collaborate |
| Executive sponsor (Chủ cửa hàng / Ban giám đốc) | HQ | Business outcomes, risk acceptance | ROI, compliance, control | Very High | Consult → Sponsor |

Notes (for review):
- Confirm whether “Kế toán cửa hàng” is in-scope beyond “Sổ quỹ (Cashbook)”.
- Confirm whether transfers are executed by Warehouse staff (Thủ kho) or Inventory staff (Nhân viên kho) per branch.

---

## 4) Communication Plan (Stakeholder Engagement)
| Stakeholder group | Cadence | Format | Purpose | Owner |
|---|---:|---|---|---|
| Branch manager representatives (2–3 branches) | Weekly | 45–60 min workshop | Validate workflows, approvals, exceptions | BA |
| Cashiers + Inventory staff (sample users) | Bi-weekly | 60 min walkthrough | Validate screen flows + operational details | BA + Designer |
| System admin + HQ operations | Weekly | 30–45 min sync | Permissions, governance rules, rollout constraints | BA |
| Executive sponsor | Milestone-based | 30 min review | Scope decisions + risk sign-off | BA/PM |

Artifacts used in sessions:
- UC diagrams (per module)
- Sequence diagrams (key scenarios)
- Activity diagrams (rules/decision points)
- PRD-lite scope + assumptions

---

## 5) Governance & Decision Rights (BABOK-aligned)
### 5.1 Decision areas
- Scope and MVP boundaries
- Business rules (negative stock, promotion conflicts, approvals)
- Role permissions and approval thresholds
- UAT acceptance / release readiness

### 5.2 Approval rules (draft)
- Any rule impacting cash, inventory valuation, or fraud risk requires concurrence from **Branch manager** and **HQ operations / System admin**.
- Any permission change requires **System admin** approval.

---

## 6) RACI Matrix (Multi-branch)
Legend: R = Responsible, A = Accountable, C = Consulted, I = Informed

Roles:
- **CA** = Cashier (Nhân viên bán hàng)
- **INV** = Inventory staff (Nhân viên kho)
- **WH** = Warehouse staff (Thủ kho)
- **BM** = Branch manager (Quản lý chi nhánh)
- **CB** = Cashbook clerk (Sổ quỹ)
- **ADM** = System admin (Quản trị hệ thống)
- **OPS** = HQ operations (Quản lý vận hành)

### 6.1 Core operational flows
| Activity / Decision | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Create sale invoice — Bán hàng (Sales) | R | I | I | A | I | C | I |
| Apply promotion rules — Quản lý khuyến mại (Promotions) | R | I | I | A | I | C | C |
| Create purchase receiving — Nhập hàng (Receiving) | I | R | C | A | I | C | I |
| Approve stock adjustment after stocktake — Kiểm kho (Stocktake) | I | R | I | A | I | C | C |
| Create inter-branch transfer — Chuyển hàng (Transfer) | I | C | R | A | I | C | C |
| Confirm receiving from other branch — Nhận hàng từ chi nhánh khác (Receive transfer) | I | R | C | A | I | C | I |
| Execute write-off — Xuất hủy (Write-off) | I | R | C | A | I | C | C |
| Record cashbook entry — Sổ quỹ (Cashbook) | I | I | I | A | R | C | I |

### 6.2 Administration & control
| Activity / Decision | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Create/update user accounts — Quản lý tài khoản người dùng (User accounts) | I | I | I | C | I | A/R | C |
| Define roles & permissions | I | I | I | C | I | A/R | C |
| Add/update branch configuration — Quản lý chi nhánh (Branch management) | I | I | I | C | I | A/R | C |
| Maintain product catalog — Quản lý hàng hóa (Product catalog) | I | C | C | A | I | C | C |
| Run management reporting — Thống kê tổng quan (Reporting) | I | I | I | R | C | C | A |

Notes (for review):
- Confirm whether product catalog changes are centrally controlled (OPS/ADM) or branch-controlled (BM).
- Confirm approval thresholds (e.g., adjustment/write-off value limits).

---

## 7) Open Questions (for your approval)
1. Do we model **HQ vs Branch** explicitly in this project, or keep a simpler single-level view?
2. For transfers: does the **source branch** or **warehouse** own dispatch? Who is accountable for discrepancies?
3. For promotions: who is accountable—Branch manager (BM) or HQ operations (OPS)?

---

## 8) Glossary / Terminology mapping
This glossary is included so recruiters can read the document in English while you keep traceability to Vietnamese course artifacts.

| Vietnamese (VI source) | English (used in this doc) |
|---|---|
| Chi nhánh | Branch |
| Bán hàng | Sales |
| Chuyển hàng | Inter-branch transfer |
| Kiểm kho | Stocktake |
| Nhập hàng | Receiving / Purchase receiving |
| Trả hàng nhập | Return to supplier |
| Xuất hủy | Write-off |
| Sổ quỹ | Cashbook |
| Quản lý hàng hóa | Product catalog |
| Quản lý khuyến mại | Promotions |
| Quản lý tài khoản người dùng | User accounts |
| Quản lý nhân viên | Staff management |
| Quản lý chi nhánh | Branch management |
| Thống kê tổng quan | Reporting |

Abbreviations:
- RACI = Responsible / Accountable / Consulted / Informed
- HQ = Headquarter

---

## 9) Approval
Status: Draft (Pending your review)

If approved, next IIBA-style document to create (one at a time):
- **Business Rules + Decision Tables** (multi-branch: negative stock, promotion conflicts, approvals, cancellations)
