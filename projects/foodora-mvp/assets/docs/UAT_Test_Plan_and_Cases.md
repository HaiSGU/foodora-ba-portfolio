# 4.1 — UAT Test Plan & Cases (FOODORA Pickup MVP)

## 1) Overview
**Project:** FOODORA — Order & Pick-up (MVP)  
**Release:** v1.0 (Pay-at-counter)  
**UAT Goal:** Validate that core customer pickup ordering flow and cashier operations meet business requirements before release.

## 2) Scope
**In scope (MVP):**
- Customer: browse menu → add to cart → select pickup slot → place order (pay at counter) → track status
- Customer cancellation: allowed only when order status = `PLACED`
- Cashier: confirm or reject (with reason), update status through lifecycle
- Payment: recorded as pay-at-counter; payment record can be created on paid
- Slot rules: show only valid future slots; optional capacity constraint

**Out of scope (not in MVP):**
- Online payments, delivery, refunds to card, loyalty/points, complex promos

## 3) Roles & Responsibilities
- **UAT Owner (BA):** Prepare cases, run briefing, consolidate results, manage sign-off.
- **Business Approver (Restaurant Owner/Manager):** Execute/approve UAT scenarios.
- **Cashier (End user):** Execute cashier scenarios.
- **Observer (Dev/QA):** Support environment/test data, log defects.

## 4) Entry / Exit Criteria
**Entry criteria:**
- Demo environment stable, seeded with at least 1 restaurant, 1 menu, 10+ items, and configured business hours
- Test accounts available for customer + cashier
- Known critical defects fixed or acceptable workarounds documented

**Exit criteria:**
- All test cases executed
- No unresolved **Critical/High** defects on in-scope flows
- Business approver signs off (see 4.2)

## 5) Test Environment & Data
**Environment:** Staging/UAT
- Web (Cashier dashboard): Chrome (latest)
- Mobile (Customer): Android/iOS prototype or web demo

**Test data setup:**
- Restaurant open today with business hours configured
- Pickup slot interval set (e.g., 15 minutes)
- Capacity test (optional): set `max_orders_per_slot` and ensure one slot can become “Full”

## 6) Scenarios Covered
1. **S1 — Place Pickup Order (Happy Path)**
2. **S2 — Cancel/Reject Rules**
3. **S3 — Status Updates + Pay-at-counter Completion**

## 7) Test Cases
The detailed test cases are maintained in (template-style sheet):
- `assets/docs/UAT_Test_Cases_Template.xlsx`

How to use (matches the template):
- Fill header: **Module Code**, **Test requirement**, **Tester**
- Execute each case and update: **Result** (Pass/Fail/Untested/N/A), **Test date**, **Note**
- Use **Inter-test case Dependence** to ensure prerequisites are completed

Tip:
- You can upload this `.xlsx` to Google Drive and open with Google Sheets (formatting may slightly vary).

## 8) Defect Logging (lightweight)
If a case fails, log:
- Case ID + steps to reproduce
- Expected vs actual
- Screenshot/video
- Severity (Critical/High/Medium/Low)

---

### Files in this repo
- `assets/docs/UAT_Test_Plan_and_Cases.md` (this file)
- `assets/docs/UAT_Test_Cases_Template.xlsx` (test cases sheet — template)
