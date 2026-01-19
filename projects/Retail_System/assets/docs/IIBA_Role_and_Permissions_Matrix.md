# Roles & Permissions Matrix (IIBA / BABOK-style)

**Project:** Retail Operations Backoffice (Hệ thống quản lý bán hàng) — Multi-branch (nhiều chi nhánh)  
**Source docs:** UC Descriptions (DOCX, Vietnamese — “VI source”) + module diagrams (UC / Sequence / Activity)  
**Version:** 0.1 (English-first)  
**Owner:** Business Analyst  
**Date:** 2026-01-19  

---

## 1) Purpose
Define a clear permissions model by role to support:
- Security (least privilege)
- Governance (approval rights)
- Testability (UAT and controls)

---

## 2) Roles
- **CA** = Cashier (Nhân viên bán hàng)
- **INV** = Inventory staff (Nhân viên kho)
- **WH** = Warehouse staff (Thủ kho)
- **BM** = Branch manager (Quản lý chi nhánh)
- **CB** = Cashbook clerk (Sổ quỹ)
- **ADM** = System admin (Quản trị hệ thống)
- **OPS** = HQ operations (Quản lý vận hành)

Permission levels:
- View = read-only
- Create/Update = can create or edit records
- Approve = can approve/override
- Admin = can configure master data / system settings

---

## 3) Permission matrix by module
### 3.1 Sales — Bán hàng
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Create sale invoice | Create/Update | View | View | Approve (override) | View | View | View |
| Apply promotions at POS | Create/Update | View | View | Approve (override) | View | View | View |
| Cancel/return invoice | Create/Update (if allowed) | View | View | Approve | View | View | View |
| View sales reports (branch) | View | View | View | View | View | View | View |

### 3.2 Promotions — Quản lý khuyến mại
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| View promotions | View | View | View | View | View | View | View |
| Create/update promotions | View | View | View | Create/Update (branch scope) | View | View | Create/Update (global scope) |
| Approve promotions | View | View | View | Approve (branch) | View | View | Approve (global) |

### 3.3 Product catalog — Quản lý hàng hóa
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| View products and prices | View | View | View | View | View | View | View |
| Create/update products | View | Create/Update (operational fields) | View | Approve (if required) | View | Admin | Admin |
| Manage price lists | View | View | View | Approve (branch if allowed) | View | Admin | Admin |

### 3.4 Receiving — Nhập hàng
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Create receiving record | View | Create/Update | Create/Update (if warehouse-managed) | Approve (if required) | View | View | View |
| Correct receiving | View | Create/Update | Create/Update | Approve | View | View | View |

### 3.5 Stocktake — Kiểm kho
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Create stocktake session | View | Create/Update | View | View | View | View | View |
| Submit stocktake results | View | Create/Update | View | View | View | View | View |
| Approve stock adjustments | View | View | View | Approve | View | View | Consult |

### 3.6 Transfers — Chuyển hàng / Nhận hàng
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Create transfer order | View | Create/Update (request) | Create/Update | Approve | View | View | View |
| Dispatch transfer (source) | View | View | Create/Update | Approve (if required) | View | View | View |
| Receive transfer (destination) | View | Create/Update | Create/Update | Approve discrepancies | View | View | View |
| Approve discrepancy | View | View | View | Approve | View | View | Consult/Approve (policy) |

### 3.7 Write-off — Xuất hủy
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Create write-off request | View | Create/Update | Create/Update | Approve | View | View | View |
| Approve write-off | View | View | View | Approve | View | View | Consult/Approve (threshold) |

### 3.8 Cashbook — Sổ quỹ
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Record cashbook entry | View | View | View | Approve (supervision) | Create/Update | View | View |
| End-of-day close & reconciliation | View | View | View | Approve | Create/Update | View | View |

### 3.9 Admin — Accounts/Staff/Branches
| Action | CA | INV | WH | BM | CB | ADM | OPS |
|---|---|---|---|---|---|---|---|
| Manage user accounts | View | View | View | View | View | Admin | Consult |
| Manage staff records | View | View | View | Create/Update (branch staff) | View | Admin | Consult |
| Manage branches | View | View | View | View | View | Admin | Consult/Admin |

---

## 4) Notes and policy hooks
- Approval thresholds (value/quantity) should be defined in Business Rules.
- Override actions must create audit logs (who approved, reason).
- Promotions and price changes should follow change control (OPS/ADM governance).

---

## 5) Glossary / Terminology mapping
| Vietnamese (VI source) | English |
|---|---|
| Quản lý tài khoản người dùng | User accounts |
| Quản lý nhân viên | Staff management |
| Quản lý chi nhánh | Branch management |
| Thủ kho | Warehouse staff |
| Nhân viên kho | Inventory staff |
