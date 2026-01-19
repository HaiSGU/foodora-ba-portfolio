# Stakeholder Engagement & RACI (SAP ERP (Mock) — BA Case Study)

**Scenario:** Order-to-Cash (O2C) with credit/pricing controls  
**Target system:** Mock SAP ERP (example reference: SAP S/4HANA SD + FI-AR + FSCM Credit Management)  
**Version:** 0.1 (English-first)  
**Date:** 2026-01-19  

---

## 1) Purpose
Define who the stakeholders are, how they will be engaged, and who is responsible/accountable for key business activities.

---

## 2) Stakeholder register
| Stakeholder / Role | Department | Responsibilities | Pain points / interests | Influence | Engagement |
|---|---|---|---|---:|---|
| Sales rep | Sales | Create sales orders, negotiate pricing | Fast entry, flexible pricing within policy | High | Collaborate |
| Sales manager | Sales | Approve pricing exceptions, review pipeline | Control margin, manage overrides | High | Collaborate |
| Credit controller | Finance | Manage credit blocks and approvals | Reduce bad debt, enforce credit limits | Very High | Collaborate |
| Warehouse clerk | Logistics | Pick/pack, goods issue, delivery updates | Accurate inventory & delivery status | Medium | Consult |
| Billing accountant | Finance | Billing, credit memos, reconciliation | Correct invoices, audit trail | High | Collaborate |
| AR specialist | Finance | Payment posting, dunning follow-up | Fast matching, fewer disputes | Medium | Consult |
| Customer service | Customer Ops | Handle cancellations/returns, complaints | Clear policy & case tracking | Medium | Consult |
| Internal audit | Audit | Compliance checks | Traceability, segregation of duties | High | Consult |
| SAP functional consultant | IT/ERP | Configure processes and rules | Clear requirements, stable scope | High | Collaborate |
| System admin | IT | Roles/authorizations, access management | Least privilege, low support load | High | Collaborate |
| Executive sponsor | Leadership | Business outcomes and risk acceptance | ROI, compliance | Very High | Sponsor |

---

## 3) Communication plan
| Group | Cadence | Format | Purpose | Owner |
|---|---:|---|---|---|
| Sales + Finance leads | Weekly | Workshop (60 min) | Validate pricing + credit policies | BA |
| Logistics reps | Bi-weekly | Walkthrough (45 min) | Delivery exceptions, status updates | BA |
| Audit + Admin | Milestone | Review (30 min) | SoD, audit logging requirements | BA |
| Sponsor | Milestone | Exec summary (30 min) | Scope and risk sign-off | BA/PM |

---

## 4) RACI matrix
Legend: R = Responsible, A = Accountable, C = Consulted, I = Informed

Roles:
- **SR** = Sales rep
- **SM** = Sales manager
- **CC** = Credit controller
- **WH** = Warehouse clerk
- **BA** = Billing accountant
- **AR** = Accounts receivable
- **CS** = Customer service
- **AUD** = Internal audit
- **IT** = ERP consultant
- **ADM** = System admin

### 4.1 Core O2C flow
| Activity | SR | SM | CC | WH | BA | AR | CS | AUD | IT | ADM |
|---|---|---|---|---|---|---|---|---|---|---|
| Create sales order | R | A | C | I | I | I | C | I | C | I |
| Pricing override request | R | A | I | I | I | I | C | I | C | I |
| Credit check / credit block | I | I | A/R | I | I | I | I | C | C | I |
| Release credit block | I | I | A/R | I | I | I | I | C | C | I |
| Create delivery / goods issue | I | I | I | A/R | I | I | I | I | C | I |
| Create billing invoice | I | I | I | I | A/R | I | I | C | C | I |
| Post payment | I | I | I | I | I | A/R | I | C | I | I |
| Create credit memo (return/cancellation) | C | A | C | C | R | I | R | C | C | I |

### 4.2 Governance & control
| Activity | SR | SM | CC | WH | BA | AR | CS | AUD | IT | ADM |
|---|---|---|---|---|---|---|---|---|---|---|
| Define approval thresholds | I | C | C | I | C | C | I | A | C | C |
| Maintain roles/permissions | I | I | I | I | I | I | I | C | C | A/R |
| Audit logging requirements | I | I | I | I | C | C | I | A/R | C | C |

---

## 5) Open questions
1. Who is accountable for pricing policy: Sales manager or Finance?
2. Does credit release require dual-control (CC + SM) for high-risk customers?
