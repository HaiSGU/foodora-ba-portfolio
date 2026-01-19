# Business Rules & Decision Tables (SAP ERP (Mock) — BA Case Study)

**Scenario:** Order-to-Cash (O2C) with credit and pricing controls  
**Target system:** Mock SAP ERP (example reference: SAP S/4HANA SD + FI-AR + FSCM Credit Management)  
**Version:** 0.1 (English-first, locked baseline)  
**Date:** 2026-01-19  

---

## 1) Locked baseline policies
To keep the case study consistent end-to-end:
- Pricing override requires approval when discount exceeds threshold.
- Credit block occurs when exposure exceeds credit limit.
- Credit memo requires approval above threshold.
- All approvals require reason codes and audit logs.

Default thresholds (configurable):
- Discount override threshold: 10% line discount or 5% order discount
- Credit memo approval threshold: 1,000 USD (or equivalent)

---

## 2) Rule catalog
**BR-PRC-001 — Discount override approval**
- If requested discount exceeds threshold, approval by Sales manager is required.

**BR-CRD-001 — Credit block on limit exceed**
- If credit exposure > credit limit, sales order is blocked for delivery/billing until released.

**BR-CRD-002 — Credit block release SoD**
- A user cannot release their own credit block decision when SoD is enabled.

**BR-BIL-001 — Credit memo approval**
- Credit memo above threshold requires Billing manager/Finance approval.

**BR-AUD-001 — Audit trail mandatory**
- Pricing override, credit release, and credit memo must capture reason + before/after.

---

## 3) Decision tables
### DT-PRC-001 — Pricing override approval
Inputs:
- Discount %
- Threshold exceeded? (Yes/No)
- Approver available? (Yes/No)

Outputs:
- Allow save? (Yes/No)
- Approval required? (Yes/No)

| Condition / Rule | R1 | R2 | R3 |
|---|---|---|---|
| Threshold exceeded | No | Yes | Yes |
| Approver available | N/A | Yes | No |
| **Allow save** | Yes | Yes (pending approval) | No |
| **Approval required** | No | Yes | Yes |

### DT-CRD-001 — Credit block
Inputs:
- Exposure > limit? (Yes/No)
- Customer risk rating high? (Yes/No)

Outputs:
- Block? (Yes/No)

| Condition / Rule | R1 | R2 | R3 | R4 |
|---|---|---|---|---|
| Exposure > limit | No | No | Yes | Yes |
| High risk rating | No | Yes | No | Yes |
| **Block** | No | No | Yes | Yes |

### DT-BIL-001 — Credit memo approval
Inputs:
- Credit memo amount
- Above threshold? (Yes/No)

Outputs:
- Approval required? (Yes/No)

| Condition / Rule | R1 | R2 |
|---|---|---|
| Above threshold | No | Yes |
| **Approval required** | No | Yes |

---

## 4) Notes
- Threshold values should be configurable by policy.
- All approvals must be recorded (who/when/reason).
