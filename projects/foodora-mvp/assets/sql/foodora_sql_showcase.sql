-- Foodora MVP — SQL Showcase (SQL Server)
-- Dialect: Microsoft SQL Server (2019+ recommended)
-- Note: Portfolio / illustrative schema aligned to the project ERD conceptually.

-- =========================
-- 1) Core schema (DDL)
-- =========================

IF OBJECT_ID('dbo.Restaurant', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Restaurant (
        RestaurantId   BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Restaurant PRIMARY KEY,
        Name           NVARCHAR(200) NOT NULL,
        Phone          NVARCHAR(50) NULL,
        Address        NVARCHAR(400) NULL,
        CreatedAt      DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_Restaurant_CreatedAt DEFAULT SYSDATETIMEOFFSET()
    );
END;

IF OBJECT_ID('dbo.Customer', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customer (
        CustomerId     BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Customer PRIMARY KEY,
        FullName       NVARCHAR(200) NOT NULL,
        Email          NVARCHAR(254) NULL,
        Phone          NVARCHAR(50) NULL,
        CreatedAt      DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_Customer_CreatedAt DEFAULT SYSDATETIMEOFFSET(),
        CONSTRAINT UQ_Customer_Email UNIQUE (Email)
    );
END;

IF OBJECT_ID('dbo.MenuItem', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MenuItem (
        MenuItemId     BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MenuItem PRIMARY KEY,
        RestaurantId   BIGINT NOT NULL,
        Name           NVARCHAR(200) NOT NULL,
        Price          DECIMAL(12,2) NOT NULL,
        IsActive       BIT NOT NULL CONSTRAINT DF_MenuItem_IsActive DEFAULT (1),
        CONSTRAINT CK_MenuItem_Price CHECK (Price >= 0),
        CONSTRAINT FK_MenuItem_Restaurant FOREIGN KEY (RestaurantId) REFERENCES dbo.Restaurant(RestaurantId) ON DELETE CASCADE
    );
END;

IF OBJECT_ID('dbo.[Order]', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.[Order] (
        OrderId        BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Order PRIMARY KEY,
        RestaurantId   BIGINT NOT NULL,
        CustomerId     BIGINT NOT NULL,
        OrderStatus    NVARCHAR(20) NOT NULL,
        PlacedAt       DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_Order_PlacedAt DEFAULT SYSDATETIMEOFFSET(),
        ReadyAt        DATETIMEOFFSET(0) NULL,
        PickedUpAt     DATETIMEOFFSET(0) NULL,
        TotalAmount    DECIMAL(12,2) NOT NULL,
        CONSTRAINT CK_Order_Status CHECK (OrderStatus IN ('PLACED','ACCEPTED','PREPARING','READY','PICKED_UP','CANCELLED')),
        CONSTRAINT CK_Order_TotalAmount CHECK (TotalAmount >= 0),
        CONSTRAINT FK_Order_Restaurant FOREIGN KEY (RestaurantId) REFERENCES dbo.Restaurant(RestaurantId),
        CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerId) REFERENCES dbo.Customer(CustomerId)
    );
END;

IF OBJECT_ID('dbo.OrderItem', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OrderItem (
        OrderItemId    BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_OrderItem PRIMARY KEY,
        OrderId        BIGINT NOT NULL,
        MenuItemId     BIGINT NOT NULL,
        Quantity       INT NOT NULL,
        UnitPrice      DECIMAL(12,2) NOT NULL,
        CONSTRAINT CK_OrderItem_Quantity CHECK (Quantity > 0),
        CONSTRAINT CK_OrderItem_UnitPrice CHECK (UnitPrice >= 0),
        CONSTRAINT FK_OrderItem_Order FOREIGN KEY (OrderId) REFERENCES dbo.[Order](OrderId) ON DELETE CASCADE,
        CONSTRAINT FK_OrderItem_MenuItem FOREIGN KEY (MenuItemId) REFERENCES dbo.MenuItem(MenuItemId)
    );
END;

-- Helpful indexes for common queries
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Order_Restaurant_PlacedAt' AND object_id = OBJECT_ID('dbo.[Order]'))
    CREATE INDEX IX_Order_Restaurant_PlacedAt ON dbo.[Order] (RestaurantId, PlacedAt);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Order_Customer_PlacedAt' AND object_id = OBJECT_ID('dbo.[Order]'))
    CREATE INDEX IX_Order_Customer_PlacedAt ON dbo.[Order] (CustomerId, PlacedAt);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Order_Status_PlacedAt' AND object_id = OBJECT_ID('dbo.[Order]'))
    CREATE INDEX IX_Order_Status_PlacedAt ON dbo.[Order] (OrderStatus, PlacedAt);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_OrderItem_OrderId' AND object_id = OBJECT_ID('dbo.OrderItem'))
    CREATE INDEX IX_OrderItem_OrderId ON dbo.OrderItem (OrderId);


-- =========================
-- 1.5) Tiny seed data (optional)
-- =========================
-- Goal: provide a small dataset so the queries below return rows in SSMS.
-- Safe to re-run: only inserts when there are no orders yet.

IF NOT EXISTS (SELECT 1 FROM dbo.[Order])
BEGIN
    -- Restaurants
    IF NOT EXISTS (SELECT 1 FROM dbo.Restaurant WHERE Name = N'Foodora Demo - Saigon')
        INSERT INTO dbo.Restaurant (Name, Phone, Address, CreatedAt)
        VALUES (N'Foodora Demo - Saigon', '0900-000-001', N'1 Le Loi, District 1, HCMC', DATEADD(day, -60, SYSDATETIMEOFFSET()));

    IF NOT EXISTS (SELECT 1 FROM dbo.Restaurant WHERE Name = N'Foodora Demo - Hanoi')
        INSERT INTO dbo.Restaurant (Name, Phone, Address, CreatedAt)
        VALUES (N'Foodora Demo - Hanoi', '0900-000-002', N'10 Kim Ma, Ba Dinh, Hanoi', DATEADD(day, -55, SYSDATETIMEOFFSET()));

    DECLARE @ResSaigon BIGINT = (SELECT TOP (1) RestaurantId FROM dbo.Restaurant WHERE Name = N'Foodora Demo - Saigon');
    DECLARE @ResHanoi  BIGINT = (SELECT TOP (1) RestaurantId FROM dbo.Restaurant WHERE Name = N'Foodora Demo - Hanoi');

    -- Customers
    IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE Email = 'alice@example.com')
        INSERT INTO dbo.Customer (FullName, Email, Phone, CreatedAt)
        VALUES (N'Alice Nguyen', 'alice@example.com', '0901-111-111', DATEADD(day, -40, SYSDATETIMEOFFSET()));

    IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE Email = 'minh.tran@example.com')
        INSERT INTO dbo.Customer (FullName, Email, Phone, CreatedAt)
        VALUES (N'Minh Tran', 'minh.tran@example.com', '0902-222-222', DATEADD(day, -35, SYSDATETIMEOFFSET()));

    IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE Email = 'thao.le@example.com')
        INSERT INTO dbo.Customer (FullName, Email, Phone, CreatedAt)
        VALUES (N'Thao Le', 'thao.le@example.com', '0903-333-333', DATEADD(day, -20, SYSDATETIMEOFFSET()));

    DECLARE @CustAlice BIGINT = (SELECT CustomerId FROM dbo.Customer WHERE Email = 'alice@example.com');
    DECLARE @CustMinh  BIGINT = (SELECT CustomerId FROM dbo.Customer WHERE Email = 'minh.tran@example.com');
    DECLARE @CustThao  BIGINT = (SELECT CustomerId FROM dbo.Customer WHERE Email = 'thao.le@example.com');

    -- Menu items (per restaurant)
    IF NOT EXISTS (SELECT 1 FROM dbo.MenuItem WHERE RestaurantId = @ResSaigon AND Name = N'Pho Bo')
        INSERT INTO dbo.MenuItem (RestaurantId, Name, Price, IsActive) VALUES (@ResSaigon, N'Pho Bo', 3.50, 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.MenuItem WHERE RestaurantId = @ResSaigon AND Name = N'Banh Mi')
        INSERT INTO dbo.MenuItem (RestaurantId, Name, Price, IsActive) VALUES (@ResSaigon, N'Banh Mi', 1.80, 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.MenuItem WHERE RestaurantId = @ResSaigon AND Name = N'Milk Tea')
        INSERT INTO dbo.MenuItem (RestaurantId, Name, Price, IsActive) VALUES (@ResSaigon, N'Milk Tea', 2.20, 1);

    IF NOT EXISTS (SELECT 1 FROM dbo.MenuItem WHERE RestaurantId = @ResHanoi AND Name = N'Bun Cha')
        INSERT INTO dbo.MenuItem (RestaurantId, Name, Price, IsActive) VALUES (@ResHanoi, N'Bun Cha', 3.80, 1);
    IF NOT EXISTS (SELECT 1 FROM dbo.MenuItem WHERE RestaurantId = @ResHanoi AND Name = N'Nem Ran')
        INSERT INTO dbo.MenuItem (RestaurantId, Name, Price, IsActive) VALUES (@ResHanoi, N'Nem Ran', 2.90, 1);

    DECLARE @MiPho BIGINT = (SELECT TOP (1) MenuItemId FROM dbo.MenuItem WHERE RestaurantId = @ResSaigon AND Name = N'Pho Bo');
    DECLARE @MiBanhMi BIGINT = (SELECT TOP (1) MenuItemId FROM dbo.MenuItem WHERE RestaurantId = @ResSaigon AND Name = N'Banh Mi');
    DECLARE @MiMilkTea BIGINT = (SELECT TOP (1) MenuItemId FROM dbo.MenuItem WHERE RestaurantId = @ResSaigon AND Name = N'Milk Tea');
    DECLARE @MiBunCha BIGINT = (SELECT TOP (1) MenuItemId FROM dbo.MenuItem WHERE RestaurantId = @ResHanoi AND Name = N'Bun Cha');
    DECLARE @MiNemRan BIGINT = (SELECT TOP (1) MenuItemId FROM dbo.MenuItem WHERE RestaurantId = @ResHanoi AND Name = N'Nem Ran');

    -- Orders + items (keep TotalAmount consistent with items)
    DECLARE @o1 BIGINT, @o2 BIGINT, @o3 BIGINT, @o4 BIGINT, @o5 BIGINT, @o6 BIGINT, @o7 BIGINT, @o8 BIGINT;

    INSERT INTO dbo.[Order] (RestaurantId, CustomerId, OrderStatus, PlacedAt, ReadyAt, PickedUpAt, TotalAmount)
    VALUES (@ResSaigon, @CustAlice, 'PICKED_UP', DATEADD(day, -9,  SYSDATETIMEOFFSET()), DATEADD(day, -9,  DATEADD(minute, 18, SYSDATETIMEOFFSET())), DATEADD(day, -9,  DATEADD(minute, 32, SYSDATETIMEOFFSET())), 0.00);
    SET @o1 = SCOPE_IDENTITY();

    INSERT INTO dbo.[Order] (RestaurantId, CustomerId, OrderStatus, PlacedAt, ReadyAt, PickedUpAt, TotalAmount)
    VALUES (@ResSaigon, @CustMinh, 'READY',     DATEADD(day, -7,  SYSDATETIMEOFFSET()), DATEADD(day, -7,  DATEADD(minute, 22, SYSDATETIMEOFFSET())), NULL, 0.00);
    SET @o2 = SCOPE_IDENTITY();

    INSERT INTO dbo.[Order] (RestaurantId, CustomerId, OrderStatus, PlacedAt, ReadyAt, PickedUpAt, TotalAmount)
    VALUES (@ResSaigon, @CustThao, 'CANCELLED', DATEADD(day, -6,  SYSDATETIMEOFFSET()), NULL, NULL, 0.00);
    SET @o3 = SCOPE_IDENTITY();

    INSERT INTO dbo.[Order] (RestaurantId, CustomerId, OrderStatus, PlacedAt, ReadyAt, PickedUpAt, TotalAmount)
    VALUES (@ResSaigon, @CustAlice, 'PICKED_UP', DATEADD(day, -3,  SYSDATETIMEOFFSET()), DATEADD(day, -3,  DATEADD(minute, 15, SYSDATETIMEOFFSET())), DATEADD(day, -3,  DATEADD(minute, 27, SYSDATETIMEOFFSET())), 0.00);
    SET @o4 = SCOPE_IDENTITY();

    INSERT INTO dbo.[Order] (RestaurantId, CustomerId, OrderStatus, PlacedAt, ReadyAt, PickedUpAt, TotalAmount)
    VALUES (@ResHanoi, @CustMinh,  'PICKED_UP', DATEADD(day, -10, SYSDATETIMEOFFSET()), DATEADD(day, -10, DATEADD(minute, 20, SYSDATETIMEOFFSET())), DATEADD(day, -10, DATEADD(minute, 33, SYSDATETIMEOFFSET())), 0.00);
    SET @o5 = SCOPE_IDENTITY();

    INSERT INTO dbo.[Order] (RestaurantId, CustomerId, OrderStatus, PlacedAt, ReadyAt, PickedUpAt, TotalAmount)
    VALUES (@ResHanoi, @CustThao,  'PICKED_UP', DATEADD(day, -4,  SYSDATETIMEOFFSET()), DATEADD(day, -4,  DATEADD(minute, 26, SYSDATETIMEOFFSET())), DATEADD(day, -4,  DATEADD(minute, 41, SYSDATETIMEOFFSET())), 0.00);
    SET @o6 = SCOPE_IDENTITY();

    INSERT INTO dbo.[Order] (RestaurantId, CustomerId, OrderStatus, PlacedAt, ReadyAt, PickedUpAt, TotalAmount)
    VALUES (@ResHanoi, @CustAlice, 'PLACED',    DATEADD(day, -1,  SYSDATETIMEOFFSET()), NULL, NULL, 0.00);
    SET @o7 = SCOPE_IDENTITY();

    INSERT INTO dbo.[Order] (RestaurantId, CustomerId, OrderStatus, PlacedAt, ReadyAt, PickedUpAt, TotalAmount)
    VALUES (@ResSaigon, @CustMinh, 'PICKED_UP', DATEADD(day, -2,  SYSDATETIMEOFFSET()), DATEADD(day, -2,  DATEADD(minute, 19, SYSDATETIMEOFFSET())), DATEADD(day, -2,  DATEADD(minute, 31, SYSDATETIMEOFFSET())), 0.00);
    SET @o8 = SCOPE_IDENTITY();

    INSERT INTO dbo.OrderItem (OrderId, MenuItemId, Quantity, UnitPrice)
    VALUES
        (@o1, @MiPho,     1, 3.50),
        (@o1, @MiMilkTea, 1, 2.20),
        (@o2, @MiBanhMi,  2, 1.80),
        (@o2, @MiMilkTea, 1, 2.20),
        (@o3, @MiPho,     1, 3.50),
        (@o4, @MiPho,     2, 3.50),
        (@o4, @MiBanhMi,  1, 1.80),
        (@o5, @MiBunCha,  1, 3.80),
        (@o5, @MiNemRan,  1, 2.90),
        (@o6, @MiNemRan,  2, 2.90),
        (@o7, @MiBunCha,  1, 3.80),
        (@o8, @MiPho,     1, 3.50),
        (@o8, @MiMilkTea, 2, 2.20);

    -- Backfill TotalAmount from items to satisfy DQ check
    UPDATE o
    SET o.TotalAmount = x.Computed
    FROM dbo.[Order] o
    JOIN (
        SELECT oi.OrderId, SUM(CAST(oi.Quantity AS decimal(18,4)) * oi.UnitPrice) AS Computed
        FROM dbo.OrderItem oi
        GROUP BY oi.OrderId
    ) x ON x.OrderId = o.OrderId;
END;


-- ==========================================
-- 2) Reporting queries recruiters care about
-- ==========================================

-- A) Daily sales + order count by restaurant (dashboard KPI query)
WITH Daily AS (
    SELECT
        o.RestaurantId,
        CAST(o.PlacedAt AS date) AS [Day],
        COUNT_BIG(*) AS Orders,
        SUM(o.TotalAmount) AS Revenue
    FROM dbo.[Order] o
    WHERE o.OrderStatus <> 'CANCELLED'
      AND o.PlacedAt >= DATEADD(day, -30, SYSDATETIMEOFFSET())
    GROUP BY o.RestaurantId, CAST(o.PlacedAt AS date)
)
SELECT
    r.Name AS Restaurant,
    d.[Day],
    d.Orders,
    d.Revenue
FROM Daily d
JOIN dbo.Restaurant r ON r.RestaurantId = d.RestaurantId
ORDER BY d.[Day] DESC, d.Revenue DESC;

-- B) Top items per restaurant (window function)
WITH ItemSales AS (
    SELECT
        o.RestaurantId,
        mi.Name AS ItemName,
        SUM(CAST(oi.Quantity AS BIGINT)) AS Qty
    FROM dbo.[Order] o
    JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
    JOIN dbo.MenuItem mi  ON mi.MenuItemId = oi.MenuItemId
    WHERE o.OrderStatus <> 'CANCELLED'
      AND o.PlacedAt >= DATEADD(day, -30, SYSDATETIMEOFFSET())
    GROUP BY o.RestaurantId, mi.Name
), Ranked AS (
    SELECT
        RestaurantId,
        ItemName,
        Qty,
        ROW_NUMBER() OVER (PARTITION BY RestaurantId ORDER BY Qty DESC) AS rn
    FROM ItemSales
)
SELECT
    r.Name AS Restaurant,
    Ranked.ItemName,
    Ranked.Qty
FROM Ranked
JOIN dbo.Restaurant r ON r.RestaurantId = Ranked.RestaurantId
WHERE Ranked.rn <= 5
ORDER BY Restaurant, Ranked.Qty DESC;

-- C) Pickup SLA: median minutes from PLACED -> READY (PERCENTILE_CONT)
WITH Base AS (
    SELECT
        o.RestaurantId,
        r.Name AS Restaurant,
        CAST(DATEDIFF(SECOND, o.PlacedAt, o.ReadyAt) AS float) / 60.0 AS MinutesToReady
    FROM dbo.[Order] o
    JOIN dbo.Restaurant r ON r.RestaurantId = o.RestaurantId
    WHERE o.ReadyAt IS NOT NULL
      AND o.OrderStatus IN ('READY','PICKED_UP')
      AND o.PlacedAt >= DATEADD(day, -30, SYSDATETIMEOFFSET())
)
SELECT DISTINCT
    b.Restaurant,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY b.MinutesToReady)
        OVER (PARTITION BY b.RestaurantId) AS MedianMinutesToReady,
    COUNT(*) OVER (PARTITION BY b.RestaurantId) AS SampleSize
FROM Base b
ORDER BY MedianMinutesToReady;


-- ============================
-- 3) Data quality checks (DQ)
-- ============================

-- Orders marked READY must have ReadyAt
SELECT o.OrderId
FROM dbo.[Order] o
WHERE o.OrderStatus IN ('READY','PICKED_UP')
  AND o.ReadyAt IS NULL;

-- TotalAmount should match sum(order_items) (tolerate small rounding)
SELECT
    o.OrderId,
    o.TotalAmount,
    SUM(CAST(oi.Quantity AS decimal(18,4)) * oi.UnitPrice) AS ComputedTotal
FROM dbo.[Order] o
JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
GROUP BY o.OrderId, o.TotalAmount
HAVING ABS(o.TotalAmount - SUM(CAST(oi.Quantity AS decimal(18,4)) * oi.UnitPrice)) > 0.01;
