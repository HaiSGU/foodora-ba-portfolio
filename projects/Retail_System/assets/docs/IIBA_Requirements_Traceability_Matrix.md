# Requirements Traceability Matrix (RTM)

**Project:** Retail Operations Backoffice (Hệ thống quản lý bán hàng) — Multi-branch (nhiều chi nhánh)  
**Source docs:** UC Descriptions (DOCX, Vietnamese — “VI source”) + module diagrams (UC / Sequence / Activity)  
**Version:** 0.2 (English-first, aligned to locked policies)  
**Owner:** Business Analyst  
**Date:** 2026-01-19  

---

## 1) Purpose
Provide end-to-end traceability from:
- Functional Requirements (FR)
- Use Case modules (VI source)
- Business Rules (BR)
- Decision Tables (DT)
- UAT test cases (TC)

This supports auditability and shows BA rigor to recruiters.

---

## 2) References
Documents in this project:
- Requirements spec: IIBA_Requirements_Scope_and_NFRs
- Stakeholders + RACI: IIBA_Stakeholder_Engagement_Approach_and_RACI
- Business rules + decision tables: IIBA_Business_Rules_and_Decision_Tables
- UAT mini pack: IIBA_UAT_Test_Cases

---

## 3) Traceability table (sample baseline)
Note: UC module names are kept in Vietnamese for alignment with VI source.

| FR ID | FR summary | UC module (VI) | Related BR/DT | UAT TC IDs |
|---|---|---|---|---|
| FR-SALES-001 | Create sales invoice with branch/user/timestamp and totals | Bán hàng | BR-INV-001 | TC-SALES-001, TC-AUD-001 |
| FR-SALES-002 | Apply promotions and record selected promotion | Quản lý khuyến mại; Bán hàng | BR-PROMO-001, BR-PROMO-002; DT-PROMO-001 | TC-PROMO-001, TC-PROMO-002 |
| FR-INV-001 | Record receiving and increase branch stock | Nhập hàng | BR-INV-001 | TC-INV-REC-001 |
| FR-INV-002 | Stocktake sessions with lifecycle | Kiểm kho | BR-INV-003 | TC-STK-001 |
| FR-INV-003 | Adjust stock after stocktake with reason + approval | Kiểm kho | BR-INV-003, BR-INV-005 | TC-STK-002, TC-AUD-002 |
| FR-INV-004 | Write-off with reason codes and approval | Xuất hủy | BR-INV-004, BR-INV-005 | TC-WO-001, TC-WO-002 |
| FR-TRF-001 | Create transfer order between branches | Chuyển hàng | BR-TRF-001 | TC-TRF-001 |
| FR-TRF-002 | Dispatch transfer and decrease stock | Chuyển hàng | BR-TRF-001; DT-INV-NEG-001 | TC-TRF-002, TC-INV-NEG-001 |
| FR-TRF-003 | Receive transfer and increase stock | Nhận hàng từ chi nhánh khác | BR-TRF-001 | TC-TRF-003 |
| FR-TRF-004 | Handle discrepancy with reason + approval | Nhận hàng từ chi nhánh khác | BR-TRF-002, BR-TRF-003; DT-TRF-001 | TC-TRF-004 |
| FR-ADM-001 | Manage user accounts and permissions | Quản lý tài khoản người dùng | (Policy) Role & permissions matrix | TC-ADM-001 |
| FR-ADM-003 | Manage branches and configuration | Quản lý chi nhánh | BR-INV-001 (branch binding) | TC-ADM-002 |
| FR-CASH-001 | Cashbook entries + end-of-day reconciliation | Sổ quỹ | BR-CASH-001, BR-CASH-002; DT-CASH-001 | TC-CASH-001, TC-CASH-002 |
| FR-REP-001 | Summary reporting by branch/date | Thống kê tổng quan | (N/A) | TC-REP-001 |

---

## 4) Maintenance notes
- Add new FR rows whenever scope expands.
- Keep BR/DT references stable; do not reuse IDs.
- Use the UAT pack to ensure every High priority FR has at least one TC.
