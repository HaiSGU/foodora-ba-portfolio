-- SAP ERP (Mock) O2C — SQL Showcase (SQL Server)
-- Dialect: Microsoft SQL Server (2019+ recommended)
-- Note: This is NOT SAP proprietary schema; it's a mock schema inspired by O2C concepts.

-- =========================
-- 1) Core schema (DDL)
-- =========================

IF OBJECT_ID('dbo.Customer', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customer (
        CustomerId    BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Customer PRIMARY KEY,
        CustomerCode  NVARCHAR(50) NOT NULL,
        Name          NVARCHAR(200) NOT NULL,
        CreditLimit   DECIMAL(14,2) NOT NULL CONSTRAINT DF_Customer_CreditLimit DEFAULT (0),
        CONSTRAINT UQ_Customer_Code UNIQUE (CustomerCode)
    );
END;

IF OBJECT_ID('dbo.SalesOrder', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SalesOrder (
        SoId       BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_SalesOrder PRIMARY KEY,
        SoNumber   NVARCHAR(50) NOT NULL,
        CustomerId BIGINT NOT NULL,
        CreatedAt  DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_SalesOrder_CreatedAt DEFAULT SYSDATETIMEOFFSET(),
        Status     NVARCHAR(20) NOT NULL,
        NetValue   DECIMAL(14,2) NOT NULL,
        CONSTRAINT UQ_SalesOrder_Number UNIQUE (SoNumber),
        CONSTRAINT CK_SalesOrder_Status CHECK (Status IN ('OPEN','BLOCKED','RELEASED','CANCELLED','COMPLETED')),
        CONSTRAINT CK_SalesOrder_NetValue CHECK (NetValue >= 0),
        CONSTRAINT FK_SalesOrder_Customer FOREIGN KEY (CustomerId) REFERENCES dbo.Customer(CustomerId)
    );
END;

IF OBJECT_ID('dbo.Delivery', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Delivery (
        DeliveryId   BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Delivery PRIMARY KEY,
        SoId         BIGINT NOT NULL,
        DeliveredAt  DATETIMEOFFSET(0) NULL,
        Status       NVARCHAR(20) NOT NULL,
        CONSTRAINT CK_Delivery_Status CHECK (Status IN ('OPEN','POSTED','CANCELLED')),
        CONSTRAINT FK_Delivery_SalesOrder FOREIGN KEY (SoId) REFERENCES dbo.SalesOrder(SoId)
    );
END;

IF OBJECT_ID('dbo.Billing', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Billing (
        BillingId      BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Billing PRIMARY KEY,
        SoId           BIGINT NOT NULL,
        BillingNumber  NVARCHAR(50) NOT NULL,
        BilledAt       DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_Billing_BilledAt DEFAULT SYSDATETIMEOFFSET(),
        Amount         DECIMAL(14,2) NOT NULL,
        CONSTRAINT UQ_Billing_Number UNIQUE (BillingNumber),
        CONSTRAINT CK_Billing_Amount CHECK (Amount >= 0),
        CONSTRAINT FK_Billing_SalesOrder FOREIGN KEY (SoId) REFERENCES dbo.SalesOrder(SoId)
    );
END;

IF OBJECT_ID('dbo.Payment', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Payment (
        PaymentId   BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Payment PRIMARY KEY,
        BillingId   BIGINT NOT NULL,
        PaidAt      DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_Payment_PaidAt DEFAULT SYSDATETIMEOFFSET(),
        Amount      DECIMAL(14,2) NOT NULL,
        CONSTRAINT CK_Payment_Amount CHECK (Amount >= 0),
        CONSTRAINT FK_Payment_Billing FOREIGN KEY (BillingId) REFERENCES dbo.Billing(BillingId)
    );
END;

IF OBJECT_ID('dbo.CreditBlock', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CreditBlock (
        BlockId      BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CreditBlock PRIMARY KEY,
        SoId         BIGINT NOT NULL,
        BlockReason  NVARCHAR(200) NOT NULL,
        BlockedAt    DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_CreditBlock_BlockedAt DEFAULT SYSDATETIMEOFFSET(),
        ReleasedAt   DATETIMEOFFSET(0) NULL,
        ReleasedBy   NVARCHAR(100) NULL,
        CONSTRAINT FK_CreditBlock_SalesOrder FOREIGN KEY (SoId) REFERENCES dbo.SalesOrder(SoId) ON DELETE CASCADE
    );
END;

IF OBJECT_ID('dbo.ApprovalLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ApprovalLog (
        ApprovalId  BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ApprovalLog PRIMARY KEY,
        ObjectType  NVARCHAR(20) NOT NULL,
        ObjectKey   NVARCHAR(50) NOT NULL,
        Action      NVARCHAR(20) NOT NULL,
        Actor       NVARCHAR(100) NOT NULL,
        ActedAt     DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_ApprovalLog_ActedAt DEFAULT SYSDATETIMEOFFSET(),
        Comment     NVARCHAR(400) NULL,
        CONSTRAINT CK_ApprovalLog_ObjectType CHECK (ObjectType IN ('SO','PRICING')),
        CONSTRAINT CK_ApprovalLog_Action CHECK (Action IN ('SUBMIT','APPROVE','REJECT'))
    );
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SalesOrder_CustomerStatusTime' AND object_id = OBJECT_ID('dbo.SalesOrder'))
    CREATE INDEX IX_SalesOrder_CustomerStatusTime ON dbo.SalesOrder (CustomerId, Status, CreatedAt);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Billing_SoBilledAt' AND object_id = OBJECT_ID('dbo.Billing'))
    CREATE INDEX IX_Billing_SoBilledAt ON dbo.Billing (SoId, BilledAt);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Payment_BillingPaidAt' AND object_id = OBJECT_ID('dbo.Payment'))
    CREATE INDEX IX_Payment_BillingPaidAt ON dbo.Payment (BillingId, PaidAt);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CreditBlock_SoTime' AND object_id = OBJECT_ID('dbo.CreditBlock'))
    CREATE INDEX IX_CreditBlock_SoTime ON dbo.CreditBlock (SoId, BlockedAt);


-- =========================
-- 1.5) Tiny seed data (optional)
-- =========================
-- Goal: provide a small dataset so the queries below return rows in SSMS.
-- Safe to re-run: uses unique keys + existence checks.

-- Customers
IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE CustomerCode IN ('CUST-0001','CUST-0002','CUST-0003'))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE CustomerCode = 'CUST-0001')
        INSERT INTO dbo.Customer (CustomerCode, Name, CreditLimit) VALUES ('CUST-0001', N'An Phat Trading', 5000.00);

    IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE CustomerCode = 'CUST-0002')
        INSERT INTO dbo.Customer (CustomerCode, Name, CreditLimit) VALUES ('CUST-0002', N'Binh Minh Retail', 12000.00);

    IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE CustomerCode = 'CUST-0003')
        INSERT INTO dbo.Customer (CustomerCode, Name, CreditLimit) VALUES ('CUST-0003', N'Coastal Foods Co.', 8000.00);
END;

DECLARE @C1 BIGINT = (SELECT CustomerId FROM dbo.Customer WHERE CustomerCode = 'CUST-0001');
DECLARE @C2 BIGINT = (SELECT CustomerId FROM dbo.Customer WHERE CustomerCode = 'CUST-0002');
DECLARE @C3 BIGINT = (SELECT CustomerId FROM dbo.Customer WHERE CustomerCode = 'CUST-0003');

-- Sales orders (include SO-000123 for the traceability query)
IF NOT EXISTS (SELECT 1 FROM dbo.SalesOrder WHERE SoNumber IN ('SO-000123','SO-000124','SO-000200','SO-000201'))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.SalesOrder WHERE SoNumber = 'SO-000123')
        INSERT INTO dbo.SalesOrder (SoNumber, CustomerId, CreatedAt, Status, NetValue)
        VALUES ('SO-000123', @C2, DATEADD(day, -20, SYSDATETIMEOFFSET()), 'BLOCKED', 1500.00);

    IF NOT EXISTS (SELECT 1 FROM dbo.SalesOrder WHERE SoNumber = 'SO-000124')
        INSERT INTO dbo.SalesOrder (SoNumber, CustomerId, CreatedAt, Status, NetValue)
        VALUES ('SO-000124', @C2, DATEADD(day, -10, SYSDATETIMEOFFSET()), 'RELEASED', 2200.00);

    IF NOT EXISTS (SELECT 1 FROM dbo.SalesOrder WHERE SoNumber = 'SO-000200')
        INSERT INTO dbo.SalesOrder (SoNumber, CustomerId, CreatedAt, Status, NetValue)
        VALUES ('SO-000200', @C1, DATEADD(day, -40, SYSDATETIMEOFFSET()), 'COMPLETED', 980.00);

    IF NOT EXISTS (SELECT 1 FROM dbo.SalesOrder WHERE SoNumber = 'SO-000201')
        INSERT INTO dbo.SalesOrder (SoNumber, CustomerId, CreatedAt, Status, NetValue)
        VALUES ('SO-000201', @C3, DATEADD(day,  -5, SYSDATETIMEOFFSET()), 'OPEN',  600.00);
END;

DECLARE @So123 BIGINT = (SELECT SoId FROM dbo.SalesOrder WHERE SoNumber = 'SO-000123');
DECLARE @So124 BIGINT = (SELECT SoId FROM dbo.SalesOrder WHERE SoNumber = 'SO-000124');
DECLARE @So200 BIGINT = (SELECT SoId FROM dbo.SalesOrder WHERE SoNumber = 'SO-000200');

-- Credit block (keep ReleasedAt NULL so query B returns it)
IF @So123 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.CreditBlock WHERE SoId = @So123 AND ReleasedAt IS NULL)
BEGIN
    INSERT INTO dbo.CreditBlock (SoId, BlockReason, BlockedAt, ReleasedAt, ReleasedBy)
    VALUES (@So123, N'Credit exposure exceeded limit', DATEADD(day, -19, SYSDATETIMEOFFSET()), NULL, NULL);
END;

-- Approval log for traceability query C (SO-000123)
IF NOT EXISTS (
    SELECT 1 FROM dbo.ApprovalLog
    WHERE ObjectType = 'SO' AND ObjectKey = 'SO-000123'
)
BEGIN
    INSERT INTO dbo.ApprovalLog (ObjectType, ObjectKey, Action, Actor, ActedAt, Comment)
    VALUES
        ('SO', 'SO-000123', 'SUBMIT',  'Sales Rep 1',  DATEADD(day, -20, DATEADD(minute, 10, SYSDATETIMEOFFSET())), N'Submitted for credit release'),
        ('SO', 'SO-000123', 'REJECT',  'Credit Ctrl',  DATEADD(day, -20, DATEADD(minute, 50, SYSDATETIMEOFFSET())), N'Reject: outstanding balance too high'),
        ('SO', 'SO-000123', 'SUBMIT',  'Sales Rep 1',  DATEADD(day, -19, DATEADD(minute, 15, SYSDATETIMEOFFSET())), N'Resubmitted with payment commitment');
END;

-- Billing + payments (create open AR so aging query returns rows)
IF NOT EXISTS (SELECT 1 FROM dbo.Billing WHERE BillingNumber IN ('BILL-9001','BILL-9002'))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Billing WHERE BillingNumber = 'BILL-9001')
        INSERT INTO dbo.Billing (SoId, BillingNumber, BilledAt, Amount)
        VALUES (@So123, 'BILL-9001', DATEADD(day, -45, SYSDATETIMEOFFSET()), 1500.00);

    IF NOT EXISTS (SELECT 1 FROM dbo.Billing WHERE BillingNumber = 'BILL-9002')
        INSERT INTO dbo.Billing (SoId, BillingNumber, BilledAt, Amount)
        VALUES (@So124, 'BILL-9002', DATEADD(day, -15, SYSDATETIMEOFFSET()), 2200.00);
END;

DECLARE @Bill9001 BIGINT = (SELECT BillingId FROM dbo.Billing WHERE BillingNumber = 'BILL-9001');
DECLARE @Bill9002 BIGINT = (SELECT BillingId FROM dbo.Billing WHERE BillingNumber = 'BILL-9002');

IF @Bill9001 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payment WHERE BillingId = @Bill9001)
BEGIN
    -- Partial payment to keep it OPEN
    INSERT INTO dbo.Payment (BillingId, PaidAt, Amount)
    VALUES (@Bill9001, DATEADD(day, -20, SYSDATETIMEOFFSET()), 400.00);
END;

IF @Bill9002 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payment WHERE BillingId = @Bill9002)
BEGIN
    -- Fully paid (won't appear in open aging)
    INSERT INTO dbo.Payment (BillingId, PaidAt, Amount)
    VALUES (@Bill9002, DATEADD(day,  -5, SYSDATETIMEOFFSET()), 2200.00);
END;


-- =====================================
-- 2) O2C monitoring / analytics queries
-- =====================================

-- A) AR aging (open billed amount not yet paid)
WITH Paid AS (
    SELECT BillingId, SUM(Amount) AS PaidAmount
    FROM dbo.Payment
    GROUP BY BillingId
), OpenItems AS (
    SELECT
        b.BillingId,
        b.BillingNumber,
        b.SoId,
        b.BilledAt,
        b.Amount AS BilledAmount,
        COALESCE(p.PaidAmount, 0) AS PaidAmount,
        (b.Amount - COALESCE(p.PaidAmount, 0)) AS OpenAmount
    FROM dbo.Billing b
    LEFT JOIN Paid p ON p.BillingId = b.BillingId
)
SELECT
    c.CustomerCode,
    c.Name AS Customer,
    oi.BillingNumber,
    CAST(oi.BilledAt AS date) AS BilledDate,
    oi.OpenAmount,
    CASE
        WHEN oi.OpenAmount <= 0 THEN 'CLOSED'
        WHEN DATEDIFF(day, oi.BilledAt, SYSDATETIMEOFFSET()) <= 30 THEN '0-30'
        WHEN DATEDIFF(day, oi.BilledAt, SYSDATETIMEOFFSET()) <= 60 THEN '31-60'
        WHEN DATEDIFF(day, oi.BilledAt, SYSDATETIMEOFFSET()) <= 90 THEN '61-90'
        ELSE '90+'
    END AS AgingBucket
FROM OpenItems oi
JOIN dbo.SalesOrder so ON so.SoId = oi.SoId
JOIN dbo.Customer c ON c.CustomerId = so.CustomerId
WHERE oi.OpenAmount > 0
ORDER BY oi.OpenAmount DESC, oi.BilledAt;

-- B) Currently credit-blocked sales orders + how long blocked
SELECT
    so.SoNumber,
    c.CustomerCode,
    c.Name AS Customer,
    cb.BlockReason,
    cb.BlockedAt,
    CAST(DATEDIFF(SECOND, cb.BlockedAt, SYSDATETIMEOFFSET()) AS float) / 3600.0 AS HoursBlocked,
    so.NetValue
FROM dbo.CreditBlock cb
JOIN dbo.SalesOrder so ON so.SoId = cb.SoId
JOIN dbo.Customer c ON c.CustomerId = so.CustomerId
WHERE cb.ReleasedAt IS NULL
  AND so.Status IN ('BLOCKED','OPEN')
ORDER BY HoursBlocked DESC;

-- C) Traceability: approvals performed on a given Sales Order
SELECT
    al.ObjectKey AS SoNumber,
    al.Action,
    al.Actor,
    al.ActedAt,
    al.Comment
FROM dbo.ApprovalLog al
WHERE al.ObjectType = 'SO'
  AND al.ObjectKey = 'SO-000123'
ORDER BY al.ActedAt;


-- ============================
-- 3) Data quality checks (DQ)
-- ============================

-- Billing should not exceed sales order NetValue (simple control)
SELECT so.SoNumber, so.NetValue, SUM(b.Amount) AS BilledTotal
FROM dbo.SalesOrder so
JOIN dbo.Billing b ON b.SoId = so.SoId
GROUP BY so.SoNumber, so.NetValue
HAVING SUM(b.Amount) > so.NetValue + 0.01;
