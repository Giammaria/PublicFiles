DROP TABLE IF EXISTS #systems
SELECT 
	[System ID] = [Index]
	, [System] = LEFT(CAST(NEWID() AS VARCHAR(36)), 8)
	, [Sub Category Count] = ABS(CHECKSUM(NEWID()))%5
	INTO #systems
FROM (
	SELECT 
		ROW_NUMBER() OVER(ORDER BY 1/0) AS [Index]
	FROM master..spt_values s1
) AS s
WHERE
	s.[Index] <= 100;

DROP TABLE IF EXISTS #syssc;
SELECT
	[System ID]
	, [System]
	, [Sub Category] = LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST(NEWID() AS VARCHAR(36)), '1', ''), '2', ''), '3', ''), '4', ''), '5', ''), '6', ''), '7', ''), '8', ''), '9', ''), '-', ''), 4)
INTO #syssc
FROM #systems s
CROSS APPLY (
	SELECT 
		ROW_NUMBER() OVER(ORDER BY 1/0) AS [Index]
	FROM master..spt_values s1
) AS sn
WHERE
	sn.[Index] <= s.[Sub Category Count]
ORDER BY [System ID]

DROP TABLE IF EXISTS #sysscra;
SELECT
	[System ID]
	, [System]
	, [Sub Category] 
	, r.[Role]
	, r.[Role Sort]
	, a.Activity
	, a.[Activity Sort]
	, [Same RACI] = CASE WHEN ABS(CHECKSUM(NEWID()))%10+1 = 1 THEN 0 ELSE 1 END
	, [Initial RACI] = CASE 
		WHEN a.Activity = 'Identify' AND ABS(CHECKSUM(NEWID()))%20+1 >10 THEN 'I'
		WHEN  a.Activity = 'Identify' AND ABS(CHECKSUM(NEWID()))%20+1 >= 6 THEN 'C'
		WHEN  a.Activity = 'Identify' AND ABS(CHECKSUM(NEWID()))%20+1 >= 4 THEN 'A'
		WHEN  a.Activity = 'Identify' AND ABS(CHECKSUM(NEWID()))%20+1 >= 1 THEN 'R'
	END
INTO #sysscra
FROM #syssc s
CROSS JOIN (
	SELECT
		[Role]
		, [Role Sort]
	FROM (VALUES
		('MIPM', 1)
		, ('Service Desk', 2)
		, ('2nd Line', 3)
		, ('EUC', 4)
		, ('Collaboration', 5)
		, ('Network Services', 6)
		, ('Business Applications', 7)
		, ('Functional Architects', 8)
		, ('Data Centre', 9)
		, ('Security Operations', 10)
		, ('Information Security', 11)
	) AS r([Role], [Role Sort])
) r
CROSS JOIN (
	SELECT
		[Activity]
		, [Activity Sort]
	FROM (VALUES
		('Identify', 1)
		, ('Alert', 2)
		, ('Investigate', 3)
		, ('Technical Update', 4)
		, ('Business Update', 5)
		, ('Resolve', 6)
		, ('Review', 7)
	) AS r([Activity], [Activity Sort])
) a
ORDER BY [System ID]

SELECT
	s.[System ID]
	, s.[System]
	, s.[Sub Category]
	, s.[Role]
	, s.[Role Sort] 
	, s.[Activity] 
	, s.[Activity Sort]
	, [RACI] = CASE
		WHEN s.[Initial RACI] IS NULL THEN 
			CASE WHEN s.[Same RACI] = 1 THEN  s2.[Initial RACI]
			ELSE 
				 CASE 
					WHEN ABS(CHECKSUM(NEWID()))%20+1 >10 THEN 'I'
					WHEN ABS(CHECKSUM(NEWID()))%20+1 >= 6 THEN 'C'
					WHEN ABS(CHECKSUM(NEWID()))%20+1 >= 4 THEN 'A'
					WHEN ABS(CHECKSUM(NEWID()))%20+1 >= 1 THEN 'R'
					ELSE s2.[Initial RACI]
				END
			END
		ELSE s.[Initial RACI]
	END
FROM #sysscra s
CROSS APPLY (
	SELECT
		s2.[Initial RACI]
	FROM #sysscra s2
	WHERE
		s2.[Initial RACI] IS NOT NULL
		AND
		s.[System ID] = s2.[System ID]
		AND
		s.[Sub Category] = s2.[Sub Category]
		AND
		s.[Role] = s2.[Role]
) s2

ORDER BY s.[System ID], s.[Sub Category], s.[Role Sort], s.[Activity Sort]