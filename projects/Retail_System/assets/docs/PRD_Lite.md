# PRD-lite — Retail Operations Backoffice

## 1) Summary
Retail stores often operate with fragmented tools (spreadsheets, manual approvals, inconsistent workflows). This project defines a consistent backoffice workflow for multi-branch retail operations.

## 2) Goals (what success looks like)
- Reduce stock variance by standardizing receiving, transfer, stocktake, and write-off flows.
- Improve traceability with role-based permissions and audit events.
- Make reporting faster and more reliable for managers.

## 3) In scope (MVP)
- Sales (Bán hàng)
- Purchasing/Receiving (Nhập hàng)
- Transfers (Chuyển hàng, Nhập hàng chi nhánh khác)
- Stocktake (Kiểm kho)
- Write-off (Xuất hủy)
- Promotions (Quản lý khuyến mại)
- Master data (Quản lý hàng hóa)
- Organization & access (Quản lý chi nhánh, Quản lý nhân viên, Quản lý tài khoản)
- Cashbook (Sổ quỹ)
- Reporting (Thống kê tổng quan)

## 4) Out of scope (for now)
- Online ordering / e-commerce integration
- Accounting system integration
- Advanced forecasting / ML

## 5) Primary users
- Cashier
- Inventory staff
- Warehouse staff
- Branch manager
- System admin

## 6) Key assumptions
- Each transaction is tied to a branch.
- All stock movements are tracked with reason codes.
- Permissions restrict sensitive actions (price override, write-off approval, adjustments).

## 7) Non-functional requirements (starter set)
- Auditability: every create/update/cancel action logs who/when/what.
- Security: role-based access control, least privilege.
- Performance: common screens respond quickly under normal store load.
- Usability: workflows are optimized for repetitive daily operations.

## 8) Key scenarios to validate
1. Receive goods → update stock → manager review
2. Transfer goods between branches → receiving confirmation
3. Promotion setup → sale applies correct discount rules
4. Stocktake → variance reconciliation → adjustments logged

## 9) Traceability (recommended)
Link:
- UC IDs (diagrams) → user stories → acceptance criteria → test cases

