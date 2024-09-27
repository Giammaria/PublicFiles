-- Date
Begin
 DROP TABLE IF EXISTS #itemCount;
    SELECT
        *
    INTO #itemCount
    FROM (
        SELECT [item] = 'Months Back', [ct] = 24
    ) u;

    DROP TABLE IF EXISTS #date;
    SELECT
		[Date] = CAST(CAST(MONTH(DATEADD(MONTH, -([n]-1), CAST(GETDATE() AS DATE))) AS VARCHAR(10)) + '/15/' + CAST(YEAR(DATEADD(MONTH, -([n]-1), CAST(GETDATE() AS DATE)))  AS VARCHAR(10)) AS DATE)
    INTO #date
    FROM #itemCount c
    CROSS APPLY (
        SELECT 
            n
        FROM (
            SELECT 
                ROW_NUMBER() OVER(ORDER BY 1/0) AS n
            FROM master..spt_values s1
            ) AS s
            WHERE
                s.n <= c.ct
    ) ca
END
GO

-- location
BEGIN
	DROP TABLE IF EXISTS #location;
	SELECT
	*
	INTO #location
	FROM (VALUES
		(1, 'Buckley Space Force Base')
		, (2, 'Peterson Space Force Base')
		, (3, 'Schriever Space Force Base')
		, (4, 'Los Angeles Air Force Base')
		, (5, 'Patrick Space Force Base')
		, (6, 'Vandenberg Space Force Base')
		, (7, 'Cheyenne Mountain Space Force Station')
		, (8, 'Cape Cod Space Force Station')
		, (9, 'New Boston Space Force Station')
	) l(id,[location])
END

-- Field Comms
BEGIN
    DROP TABLE IF EXISTS #itemCount;
    SELECT
        *
    INTO #itemCount
    FROM (
        SELECT [item] = 'Field Comm', [ct] = 3
    ) u

    DROP TABLE IF EXISTS #fieldComms;
    SELECT
        id = ROW_NUMBER() OVER(ORDER BY [item])
        , [item]
        , [name] = [Item] + ' ' + CAST(n AS VARCHAR(10))
    INTO #fieldComms
    FROM #itemCount c
    CROSS APPLY (
        SELECT 
            n
        FROM (
            SELECT 
                ROW_NUMBER() OVER(ORDER BY 1/0) AS n
            FROM master..spt_values s1
            ) AS s
            WHERE
                s.n <= c.ct
    ) ca
END
GO

-- capability
BEGIN
	DROP TABLE IF EXISTS #capability;
	SELECT
	*
	INTO #capability
	FROM (VALUES
		(1, 'Del 2 SDA')
		, (2, 'Del 3 Electromagnetic Warfare')
		, (3, 'Del 4 Missile Warning')
		, (4, 'Del 5 AOC')
		, (5, 'Del 6 Cyber')
		, (6, 'Del 7 ISR')
		, (7, 'Del 8 SATCOM')
		, (8, 'Del 9 OW')
		, (9, 'NSIC')
	) l(id,[capability])
END

-- Field Comms
BEGIN
    DROP TABLE IF EXISTS #itemCount;
    SELECT
        *
    INTO #itemCount
    FROM (
        SELECT [item] = 'Field Comm', [ct] = 3
    ) u

    DROP TABLE IF EXISTS #fieldComms;
    SELECT
        id = ROW_NUMBER() OVER(ORDER BY [item])
        , [item]
        , [name] = [Item] + ' ' + CAST(n AS VARCHAR(10))
    INTO #fieldComms
    FROM #itemCount c
    CROSS APPLY (
        SELECT 
            n
        FROM (
            SELECT 
                ROW_NUMBER() OVER(ORDER BY 1/0) AS n
            FROM master..spt_values s1
            ) AS s
            WHERE
                s.n <= c.ct
    ) ca
END
GO

-- component
BEGIN
	DROP TABLE IF EXISTS #component;
	SELECT
	*
	INTO #component
	FROM (VALUES
		(1, 'Active')
		, (2, 'Guard')
		, (3, 'Reserve')
	) l(id,[component])
END

-- Field Comms
BEGIN
    DROP TABLE IF EXISTS #itemCount;
    SELECT
        *
    INTO #itemCount
    FROM (
        SELECT [item] = 'Field Comm', [ct] = 3
    ) u

    DROP TABLE IF EXISTS #fieldComms;
    SELECT
        id = ROW_NUMBER() OVER(ORDER BY [item])
        , [item]
        , [name] = [Item] + ' ' + CAST(n AS VARCHAR(10))
    INTO #fieldComms
    FROM #itemCount c
    CROSS APPLY (
        SELECT 
            n
        FROM (
            SELECT 
                ROW_NUMBER() OVER(ORDER BY 1/0) AS n
            FROM master..spt_values s1
            ) AS s
            WHERE
                s.n <= c.ct
    ) ca
END
GO

-- component
BEGIN
	DROP TABLE IF EXISTS #component;
	SELECT
	*
	INTO #component
	FROM (VALUES
		(1, 'Active')
		, (2, 'Guard')
		, (3, 'Reserve')
	) l(id,[component])
END

-- mission
BEGIN
    DROP TABLE IF EXISTS #itemCount;
    SELECT
        *
    INTO #itemCount
    FROM (
        SELECT [item] = 'Mission', [ct] = 9
    ) u

    DROP TABLE IF EXISTS #mission;
    SELECT
        id = ROW_NUMBER() OVER(ORDER BY [item])
        , [item]
        , [name] = CASE 
			WHEN ROW_NUMBER() OVER(ORDER BY [item]) = 1 THEN 'CORE'
			ELSE [Item] + ' ' + CAST((n-1) AS VARCHAR(10))
		END
    INTO #mission
    FROM #itemCount c
    CROSS APPLY (
        SELECT 
            n
        FROM (
            SELECT 
                ROW_NUMBER() OVER(ORDER BY 1/0) AS n
            FROM master..spt_values s1
            ) AS s
            WHERE
                s.n <= c.ct
    ) ca
END
GO

--SELECT * FROM #fieldComms;

-- Deltas
BEGIN
    DROP TABLE IF EXISTS #itemCount;
    SELECT
        *
    INTO #itemCount
    FROM (
        SELECT [item] = 'Delta', [ct] = 52
    ) u

    DROP TABLE IF EXISTS #deltas;
    SELECT
        id = ROW_NUMBER() OVER(ORDER BY [item])
        , [item]
        , [name] = [Item] + ' ' + RIGHT('0' +CAST(n AS VARCHAR(10)), 2)
        , fieldCommId = ABS(CHECKSUM(NEWID()) % (SELECT COUNT(*) FROM #fieldComms)) + 1
    INTO #deltas
    FROM #itemCount c
    CROSS APPLY (
        SELECT 
            n
        FROM (
            SELECT 
                ROW_NUMBER() OVER(ORDER BY 1/0) AS n
            FROM master..spt_values s1
            ) AS s
            WHERE
                s.n <= c.ct
    ) ca
END
GO

-- Reporting Units
BEGIN
    DROP TABLE IF EXISTS #itemCount;
    SELECT
        *
    INTO #itemCount
    FROM (
        SELECT [item] = 'Unit', [ct] = 800
    ) u

    DROP TABLE IF EXISTS #reportingUnits;
    SELECT
        id = ROW_NUMBER() OVER(ORDER BY [item])
        , [item]
        , [name] = [Item] + ' ' + RIGHT('00' +CAST(n AS VARCHAR(10)), 3)
        , deltaId = ABS(CHECKSUM(NEWID()) % (SELECT COUNT(*) FROM #deltas)) + 1
		, locationId = ABS(CHECKSUM(NEWID())% (SELECT COUNT(*) FROM #location)) + 1
		, capabilityId = ABS(CHECKSUM(NEWID())% (SELECT COUNT(*) FROM #capability)) + 1
		, componentId = CASE 
			WHEN ABS(CHECKSUM(NEWID()))%26 < 15 THEN 1
			WHEN ABS(CHECKSUM(NEWID()))%26 < 22 THEN 2
			ELSE 3
		END
		, [Squadron Type] = CASE 
			WHEN ABS(CHECKSUM(NEWID()))%6 <= 4 THEN 'Force Generation'
			ELSE 'Combat'
		END
    INTO #reportingUnits
    FROM #itemCount c
    CROSS APPLY (
        SELECT 
            n
        FROM (
            SELECT 
                ROW_NUMBER() OVER(ORDER BY 1/0) AS n
            FROM master..spt_values s1
            ) AS s
            WHERE
                s.n <= c.ct
    ) ca
END
GO

DROP TABLE IF EXISTS #ratings
SELECT
	[Field Comm]
	, [Delta]
	, [Reporting Unit]
	, [Location]
	, [Capability]
	, [Component]
	, [Squadron Type]
	, [Mission]
	, [Date]
	, [P]
	, [S]
	, [R]
	, [T]
	, [OVL] = (SELECT MAX(R) FROM (VALUES ([P]), ([S]), ([R]), ([T])) v(R))
	, [Primary Degraders] = CASE
			WHEN (SELECT MAX(R) FROM (VALUES ([P]), ([S]), ([R]), ([T])) v(R)) >= 3
				THEN (
					SELECT STRING_AGG([pillar], ', ') 
					FROM (
						VALUES 
							('P', [P]), 
							('R', [R]), 
							('S', [S]), 
							('T', [T])
					) AS tbl([pillar], [value])
					WHERE [value] = (SELECT MAX(R) FROM (VALUES ([P]), ([S]), ([R]), ([T])) v(R))
				)
			ELSE NULL
		END	
		, [Secondary Degraders] = CASE
			WHEN (SELECT MAX(R) FROM (VALUES ([P]), ([S]), ([R]), ([T])) v(R)) >= 3
				THEN (
					SELECT STRING_AGG([pillar], ', ') 
					FROM (
						VALUES 
							('P', [P]), 
							('R', [R]), 
							('S', [S]), 
							('T', [T])
					) AS tbl([pillar], [value])
					WHERE [value] >= 3 AND [value] <> (SELECT MAX(R) FROM (VALUES ([P]), ([S]), ([R]), ([T])) v(R))
				)
			ELSE NULL
		END
	, fid
	, did
	, rid
	, mid
INTO #ratings
FROM (
	SELECT 
		[Field Comm] = f.[name]
		, [Delta] = d.[name]
		, [Reporting Unit] = r.[name]
		, [Location] = l.[location]
		, [Capability] = cap.[capability]
		, [Component] = comp.component
		, [Squadron Type] = r.[Squadron Type]
		, [Mission] = m.[name]
		, [Date] = dt.[Date]
		, [P] = CASE 
			-- High chance of 1 or 2 closer to today
            WHEN ABS(CHECKSUM(NEWID())) % 100 > (DATEDIFF(MONTH, dt.[Date], GETDATE()) * 4) THEN ABS(CHECKSUM(NEWID())) % 2 + 1
			-- Slight chance of 3 or worse further from today
            WHEN ABS(CHECKSUM(NEWID())) % 100 > 50 THEN ABS(CHECKSUM(NEWID())) % 3 + 1
			-- Default chance of a 1 to 5 if none of the above conditions are met
            ELSE ABS(CHECKSUM(NEWID())) % 5 + 1
          END
		
		, [S] = CASE 
			WHEN ABS(CHECKSUM(NEWID())) % 100 > (DATEDIFF(MONTH, dt.[Date], GETDATE()) * 4) THEN ABS(CHECKSUM(NEWID())) % 2 + 1
			WHEN ABS(CHECKSUM(NEWID())) % 100 > 50 THEN ABS(CHECKSUM(NEWID())) % 3 + 1
			ELSE ABS(CHECKSUM(NEWID())) % 5 + 1
          END
		
		, [R] = CASE 
			WHEN ABS(CHECKSUM(NEWID())) % 100 > (DATEDIFF(MONTH, dt.[Date], GETDATE()) * 4) THEN ABS(CHECKSUM(NEWID())) % 2 + 1
			WHEN ABS(CHECKSUM(NEWID())) % 100 > 50 THEN ABS(CHECKSUM(NEWID())) % 3 + 1
			ELSE ABS(CHECKSUM(NEWID())) % 5 + 1
          END
		
		, [T] = CASE 
			WHEN ABS(CHECKSUM(NEWID())) % 100 > (DATEDIFF(MONTH, dt.[Date], GETDATE()) * 4) THEN ABS(CHECKSUM(NEWID())) % 2 + 1
			WHEN ABS(CHECKSUM(NEWID())) % 100 > 50 THEN ABS(CHECKSUM(NEWID())) % 3 + 1
			ELSE ABS(CHECKSUM(NEWID())) % 5 + 1
          END
		, fid = f.id
		, did = d.id
		, rid = r.id
		, mid = m.id
	FROM #reportingUnits r
	INNER JOIN #deltas d 
		ON r.deltaId = d.id
	INNER JOIN #fieldComms f
		ON d.fieldCommId = f.id
	INNER JOIN #location l
		ON r.locationId = l.id
	INNER JOIN #capability cap
		ON r.capabilityId = cap.id
	INNER JOIN #component comp
		ON r.componentId = comp.id
	CROSS JOIN #mission m
	CROSS JOIN #date dt
) s

SELECT
	[Field Comm]
	, [Delta]
	, [Reporting Unit]
	, [Location]
	, [Capability]
	, [Component]
	, [Squadron Type]
	, [Mission]
	, [Date]
	, [P]
	, [S]
	, [R]
	, [T]
	, [OVL]
	, [Assessment] = CASE
		WHEN [OVL] < 3 THEN 'Y'
		WHEN [OVL] = 3 THEN 'Q'
		ELSE 'N'
	END
	, [Primary Degraders]
	, [Secondary Degraders]
FROM #ratings
ORDER BY
	fid
	, did
	, rid
	, mid
	, [Date]

