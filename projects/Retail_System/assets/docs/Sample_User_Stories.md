# Sample User Stories — Retail Operations Backoffice

These are examples to make the project recruiter-friendly by showing testable requirements.

## Sales (Bán hàng)

### US-SALES-001 — Create a sale invoice
As a cashier, I want to create a sale invoice so that customers can pay and receive a receipt.

**Acceptance criteria**
- Given I have permission to sell, when I add items and confirm the invoice, then the system creates an invoice with a unique number.
- Given an item is out of stock and negative stock is disallowed, when I try to add the item, then the system blocks the action and shows an error.

### US-SALES-002 — Apply promotions automatically
As a cashier, I want promotions to apply automatically so that pricing is consistent.

**Acceptance criteria**
- Given a promotion is active and eligible, when the invoice contains eligible items, then the discount is applied according to the promotion rules.
- Given two promotions conflict, when both are eligible, then the system uses the configured conflict rule (e.g., best discount wins).

## Inventory (Kiểm kho)

### US-INV-001 — Perform a stocktake
As an inventory staff member, I want to record counted quantities so that variance can be identified.

**Acceptance criteria**
- Given a stocktake session is open, when I input counted quantity, then the system calculates variance vs. system quantity.
- Given a variance exceeds a threshold, when I request adjustment, then the system requires manager approval.

## Transfers (Chuyển hàng)

### US-TRANSFER-001 — Create an inter-branch transfer
As warehouse staff, I want to create a transfer request so that stock can move between branches.

**Acceptance criteria**
- When I submit a transfer, then the system sets status to "Pending" and records source/target branches.
- When the target branch confirms receiving, then the system updates inventory in both branches and records audit entries.

