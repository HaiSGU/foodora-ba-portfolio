-- Retail Operations Backoffice — SQL Showcase (SQL Server)
-- Dialect: Microsoft SQL Server (2019+ recommended)
-- Note: Portfolio / illustrative schema aligned to the Logical ERD conceptually.

-- =========================
-- 1) Core schema (DDL)
-- =========================

IF OBJECT_ID('dbo.Branch', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Branch (
        BranchId   BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Branch PRIMARY KEY,
        Code       NVARCHAR(20) NOT NULL,
        Name       NVARCHAR(200) NOT NULL,
        CONSTRAINT UQ_Branch_Code UNIQUE (Code)
    );
END;

IF OBJECT_ID('dbo.Product', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Product (
        ProductId  BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Product PRIMARY KEY,
        Sku        NVARCHAR(50) NOT NULL,
        Name       NVARCHAR(250) NOT NULL,
        Uom        NVARCHAR(10) NOT NULL CONSTRAINT DF_Product_Uom DEFAULT ('EA'),
        CONSTRAINT UQ_Product_Sku UNIQUE (Sku)
    );
END;

IF OBJECT_ID('dbo.InventoryMovement', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.InventoryMovement (
        MovementId    BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_InventoryMovement PRIMARY KEY,
        BranchId      BIGINT NOT NULL,
        ProductId     BIGINT NOT NULL,
        MovementType  NVARCHAR(20) NOT NULL,
        Qty           DECIMAL(12,3) NOT NULL,
        UnitCost      DECIMAL(12,2) NULL,
        ReasonCode    NVARCHAR(50) NULL,
        CreatedBy     NVARCHAR(100) NULL,
        CreatedAt     DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_InventoryMovement_CreatedAt DEFAULT SYSDATETIMEOFFSET(),
        CONSTRAINT CK_InventoryMovement_Type CHECK (MovementType IN ('RECEIPT','SALE','TRANSFER_OUT','TRANSFER_IN','ADJUSTMENT')),
        CONSTRAINT FK_InventoryMovement_Branch FOREIGN KEY (BranchId) REFERENCES dbo.Branch(BranchId),
        CONSTRAINT FK_InventoryMovement_Product FOREIGN KEY (ProductId) REFERENCES dbo.Product(ProductId)
    );
END;

IF OBJECT_ID('dbo.Stocktake', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Stocktake (
        StocktakeId   BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Stocktake PRIMARY KEY,
        BranchId      BIGINT NOT NULL,
        StocktakeDate date NOT NULL,
        CreatedBy     NVARCHAR(100) NULL,
        CreatedAt     DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_Stocktake_CreatedAt DEFAULT SYSDATETIMEOFFSET(),
        CONSTRAINT UQ_Stocktake UNIQUE (BranchId, StocktakeDate),
        CONSTRAINT FK_Stocktake_Branch FOREIGN KEY (BranchId) REFERENCES dbo.Branch(BranchId)
    );
END;

IF OBJECT_ID('dbo.StocktakeLine', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.StocktakeLine (
        StocktakeLineId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_StocktakeLine PRIMARY KEY,
        StocktakeId     BIGINT NOT NULL,
        ProductId       BIGINT NOT NULL,
        CountedQty      DECIMAL(12,3) NOT NULL,
        CONSTRAINT UQ_StocktakeLine UNIQUE (StocktakeId, ProductId),
        CONSTRAINT FK_StocktakeLine_Stocktake FOREIGN KEY (StocktakeId) REFERENCES dbo.Stocktake(StocktakeId) ON DELETE CASCADE,
        CONSTRAINT FK_StocktakeLine_Product FOREIGN KEY (ProductId) REFERENCES dbo.Product(ProductId)
    );
END;

IF OBJECT_ID('dbo.PriceOverride', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.PriceOverride (
        OverrideId   BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PriceOverride PRIMARY KEY,
        BranchId     BIGINT NOT NULL,
        ProductId    BIGINT NOT NULL,
        OldPrice     DECIMAL(12,2) NOT NULL,
        NewPrice     DECIMAL(12,2) NOT NULL,
        ApprovedBy   NVARCHAR(100) NULL,
        Reason       NVARCHAR(400) NULL,
        ChangedBy    NVARCHAR(100) NULL,
        ChangedAt    DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_PriceOverride_ChangedAt DEFAULT SYSDATETIMEOFFSET(),
        CONSTRAINT FK_PriceOverride_Branch FOREIGN KEY (BranchId) REFERENCES dbo.Branch(BranchId),
        CONSTRAINT FK_PriceOverride_Product FOREIGN KEY (ProductId) REFERENCES dbo.Product(ProductId)
    );
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_InventoryMovement_BranchProductTime' AND object_id = OBJECT_ID('dbo.InventoryMovement'))
    CREATE INDEX IX_InventoryMovement_BranchProductTime ON dbo.InventoryMovement (BranchId, ProductId, CreatedAt);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Stocktake_BranchDate' AND object_id = OBJECT_ID('dbo.Stocktake'))
    CREATE INDEX IX_Stocktake_BranchDate ON dbo.Stocktake (BranchId, StocktakeDate);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PriceOverride_BranchTime' AND object_id = OBJECT_ID('dbo.PriceOverride'))
    CREATE INDEX IX_PriceOverride_BranchTime ON dbo.PriceOverride (BranchId, ChangedAt);


-- =========================
-- 1.5) Tiny seed data (optional)
-- =========================
-- Goal: provide a small dataset so the queries below return rows in SSMS.
-- Safe to re-run: uses unique keys + a marker ReasonCode='SEED'.

IF NOT EXISTS (SELECT 1 FROM dbo.Branch WHERE Code IN ('HCM-01','HN-01'))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Branch WHERE Code = 'HCM-01')
        INSERT INTO dbo.Branch (Code, Name) VALUES ('HCM-01', N'Ho Chi Minh - District 1');

    IF NOT EXISTS (SELECT 1 FROM dbo.Branch WHERE Code = 'HN-01')
        INSERT INTO dbo.Branch (Code, Name) VALUES ('HN-01', N'Ha Noi - Ba Dinh');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Product WHERE Sku IN ('SKU-COF-001','SKU-MLK-001','SKU-BRD-001'))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Product WHERE Sku = 'SKU-COF-001')
        INSERT INTO dbo.Product (Sku, Name, Uom) VALUES ('SKU-COF-001', N'Coffee Beans 1kg', 'BAG');

    IF NOT EXISTS (SELECT 1 FROM dbo.Product WHERE Sku = 'SKU-MLK-001')
        INSERT INTO dbo.Product (Sku, Name, Uom) VALUES ('SKU-MLK-001', N'Fresh Milk 1L', 'BOT');

    IF NOT EXISTS (SELECT 1 FROM dbo.Product WHERE Sku = 'SKU-BRD-001')
        INSERT INTO dbo.Product (Sku, Name, Uom) VALUES ('SKU-BRD-001', N'Sandwich Bread', 'EA');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.InventoryMovement WHERE ReasonCode = 'SEED')
BEGIN
    DECLARE @BranchHcm BIGINT = (SELECT BranchId FROM dbo.Branch WHERE Code = 'HCM-01');
    DECLARE @BranchHn  BIGINT = (SELECT BranchId FROM dbo.Branch WHERE Code = 'HN-01');

    DECLARE @ProdCoffee BIGINT = (SELECT ProductId FROM dbo.Product WHERE Sku = 'SKU-COF-001');
    DECLARE @ProdMilk   BIGINT = (SELECT ProductId FROM dbo.Product WHERE Sku = 'SKU-MLK-001');
    DECLARE @ProdBread  BIGINT = (SELECT ProductId FROM dbo.Product WHERE Sku = 'SKU-BRD-001');

    INSERT INTO dbo.InventoryMovement
        (BranchId, ProductId, MovementType, Qty, UnitCost, ReasonCode, CreatedBy, CreatedAt)
    VALUES
        (@BranchHcm, @ProdCoffee, 'RECEIPT',       30.000, 8.50, 'SEED', 'system', DATEADD(day, -12, SYSDATETIMEOFFSET())),
        (@BranchHcm, @ProdCoffee, 'SALE',           6.000, NULL, 'SEED', 'pos',    DATEADD(day,  -2, SYSDATETIMEOFFSET())),
        (@BranchHcm, @ProdMilk,   'RECEIPT',       40.000, 1.10, 'SEED', 'system', DATEADD(day, -10, SYSDATETIMEOFFSET())),
        (@BranchHcm, @ProdMilk,   'SALE',          15.000, NULL, 'SEED', 'pos',    DATEADD(day,  -1, SYSDATETIMEOFFSET())),
        (@BranchHcm, @ProdBread,  'RECEIPT',       50.000, 0.60, 'SEED', 'system', DATEADD(day,  -9, SYSDATETIMEOFFSET())),
        (@BranchHcm, @ProdBread,  'ADJUSTMENT',    -2.000, NULL, 'SEED', 'manager',DATEADD(day,  -6, SYSDATETIMEOFFSET())),
        (@BranchHn,  @ProdCoffee, 'RECEIPT',       20.000, 8.70, 'SEED', 'system', DATEADD(day, -11, SYSDATETIMEOFFSET())),
        (@BranchHn,  @ProdCoffee, 'TRANSFER_OUT',   3.000, NULL, 'SEED', 'staff',  DATEADD(day,  -5, SYSDATETIMEOFFSET())),
        (@BranchHcm, @ProdCoffee, 'TRANSFER_IN',    3.000, NULL, 'SEED', 'staff',  DATEADD(day,  -5, SYSDATETIMEOFFSET()));
END;

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Stocktake st
    JOIN dbo.StocktakeLine sl ON sl.StocktakeId = st.StocktakeId
    WHERE st.CreatedBy = 'seed'
)
BEGIN
    DECLARE @SeedBranch BIGINT = (SELECT BranchId FROM dbo.Branch WHERE Code = 'HCM-01');
    DECLARE @SeedDate date = DATEADD(day, -3, CAST(GETDATE() AS date));

    IF NOT EXISTS (SELECT 1 FROM dbo.Stocktake WHERE BranchId = @SeedBranch AND StocktakeDate = @SeedDate)
        INSERT INTO dbo.Stocktake (BranchId, StocktakeDate, CreatedBy, CreatedAt)
        VALUES (@SeedBranch, @SeedDate, 'seed', DATEADD(day, -3, SYSDATETIMEOFFSET()));

    DECLARE @StId BIGINT = (SELECT StocktakeId FROM dbo.Stocktake WHERE BranchId = @SeedBranch AND StocktakeDate = @SeedDate);
    DECLARE @ProdCoffee2 BIGINT = (SELECT ProductId FROM dbo.Product WHERE Sku = 'SKU-COF-001');
    DECLARE @ProdMilk2   BIGINT = (SELECT ProductId FROM dbo.Product WHERE Sku = 'SKU-MLK-001');
    DECLARE @ProdBread2  BIGINT = (SELECT ProductId FROM dbo.Product WHERE Sku = 'SKU-BRD-001');

    IF NOT EXISTS (SELECT 1 FROM dbo.StocktakeLine WHERE StocktakeId = @StId AND ProductId = @ProdCoffee2)
        INSERT INTO dbo.StocktakeLine (StocktakeId, ProductId, CountedQty) VALUES (@StId, @ProdCoffee2, 23.000);

    IF NOT EXISTS (SELECT 1 FROM dbo.StocktakeLine WHERE StocktakeId = @StId AND ProductId = @ProdMilk2)
        INSERT INTO dbo.StocktakeLine (StocktakeId, ProductId, CountedQty) VALUES (@StId, @ProdMilk2, 24.000);

    IF NOT EXISTS (SELECT 1 FROM dbo.StocktakeLine WHERE StocktakeId = @StId AND ProductId = @ProdBread2)
        INSERT INTO dbo.StocktakeLine (StocktakeId, ProductId, CountedQty) VALUES (@StId, @ProdBread2, 47.000);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.PriceOverride WHERE Reason LIKE 'SEED:%')
BEGIN
    DECLARE @BranchOverride BIGINT = (SELECT BranchId FROM dbo.Branch WHERE Code = 'HCM-01');
    DECLARE @ProdOverride BIGINT = (SELECT ProductId FROM dbo.Product WHERE Sku = 'SKU-MLK-001');

    INSERT INTO dbo.PriceOverride
        (BranchId, ProductId, OldPrice, NewPrice, ApprovedBy, Reason, ChangedBy, ChangedAt)
    VALUES
        (@BranchOverride, @ProdOverride, 1.50, 1.35, 'Supervisor A', 'SEED: promo match competitor', 'Manager B', DATEADD(day, -14, SYSDATETIMEOFFSET()));
END;


-- ===================================
-- 2) Operations / control reporting
-- ===================================

-- A) Stock on hand as-of now (net movements)
WITH Net AS (
    SELECT
        BranchId,
        ProductId,
        SUM(CASE
            WHEN MovementType IN ('RECEIPT','TRANSFER_IN') THEN Qty
            WHEN MovementType IN ('SALE','TRANSFER_OUT')   THEN -Qty
            WHEN MovementType = 'ADJUSTMENT'               THEN Qty
            ELSE 0
        END) AS OnHand
    FROM dbo.InventoryMovement
    GROUP BY BranchId, ProductId
)
SELECT
    b.Code AS Branch,
    p.Sku,
    p.Name,
    n.OnHand
FROM Net n
JOIN dbo.Branch b  ON b.BranchId = n.BranchId
JOIN dbo.Product p ON p.ProductId = n.ProductId
ORDER BY b.Code, p.Sku;

-- B) Stocktake variance report (system vs counted)
WITH SOH AS (
    SELECT
        BranchId,
        ProductId,
        SUM(CASE
            WHEN MovementType IN ('RECEIPT','TRANSFER_IN') THEN Qty
            WHEN MovementType IN ('SALE','TRANSFER_OUT')   THEN -Qty
            WHEN MovementType = 'ADJUSTMENT'               THEN Qty
            ELSE 0
        END) AS SystemQty
    FROM dbo.InventoryMovement
    GROUP BY BranchId, ProductId
)
SELECT
    b.Code AS Branch,
    st.StocktakeDate,
    p.Sku,
    p.Name,
    COALESCE(soh.SystemQty, 0) AS SystemQty,
    sl.CountedQty,
    (sl.CountedQty - COALESCE(soh.SystemQty, 0)) AS VarianceQty
FROM dbo.Stocktake st
JOIN dbo.StocktakeLine sl ON sl.StocktakeId = st.StocktakeId
JOIN dbo.Branch b         ON b.BranchId = st.BranchId
JOIN dbo.Product p        ON p.ProductId = sl.ProductId
LEFT JOIN SOH soh         ON soh.BranchId = st.BranchId AND soh.ProductId = sl.ProductId
WHERE st.StocktakeDate >= DATEADD(day, -30, CAST(GETDATE() AS date))
ORDER BY st.StocktakeDate DESC, b.Code, ABS(sl.CountedQty - COALESCE(soh.SystemQty, 0)) DESC;

-- C) Price override audit (who/when/why + approvals)
SELECT
    b.Code AS Branch,
    p.Sku,
    p.Name,
    po.OldPrice,
    po.NewPrice,
    (po.NewPrice - po.OldPrice) AS Delta,
    po.Reason,
    po.ApprovedBy,
    po.ChangedBy,
    po.ChangedAt
FROM dbo.PriceOverride po
JOIN dbo.Branch b  ON b.BranchId = po.BranchId
JOIN dbo.Product p ON p.ProductId = po.ProductId
WHERE po.ChangedAt >= DATEADD(day, -90, SYSDATETIMEOFFSET())
ORDER BY po.ChangedAt DESC;


-- ============================
-- 3) Data quality checks (DQ)
-- ============================

-- Negative on-hand should not happen (control check)
WITH Net AS (
    SELECT
        BranchId,
        ProductId,
        SUM(CASE
            WHEN MovementType IN ('RECEIPT','TRANSFER_IN') THEN Qty
            WHEN MovementType IN ('SALE','TRANSFER_OUT')   THEN -Qty
            WHEN MovementType = 'ADJUSTMENT'               THEN Qty
            ELSE 0
        END) AS OnHand
    FROM dbo.InventoryMovement
    GROUP BY BranchId, ProductId
)
SELECT b.Code, p.Sku, p.Name, n.OnHand
FROM Net n
JOIN dbo.Branch b  ON b.BranchId = n.BranchId
JOIN dbo.Product p ON p.ProductId = n.ProductId
WHERE n.OnHand < 0
ORDER BY n.OnHand;
