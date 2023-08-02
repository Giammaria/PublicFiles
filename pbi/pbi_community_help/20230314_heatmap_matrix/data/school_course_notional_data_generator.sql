DROP TABLE IF EXISTS #schoolStudent
SELECT
	[School] 
	, [Student ID]
INTO #schoolStudent
FROM (
	VALUES ('School A', 20), ('School B', 15), ('School C', 7), ('School D', 25), ('School E', 8), ('School F', 20), ('School G', 20)
) v([School], [Student Count])
CROSS APPLY (
	SELECT 
		[Student ID]
	FROM (
		SELECT 
			RIGHT(v.[School], 1) + RIGHT('000' + CAST(ROW_NUMBER() OVER(PARTITION BY v.School ORDER BY 1/0) AS VARCHAR(4)), 3) AS [Student ID]
			, ROW_NUMBER() OVER(PARTITION BY v.School ORDER BY 1/0) AS n
		FROM master..spt_values s1
		) AS s
		WHERE
			s.n <= v.[Student Count]
) ca;

DECLARE @probabilityMax AS INT = 3;
SELECT
	*
	, [List of Classes] =  
		REPLACE(' ' 
			+ CASE [Class 1] WHEN 1 THEN ',Class 1' ELSE '' END
			+ CASE [Class 2] WHEN 1 THEN ',Class 2' ELSE '' END
			+ CASE [Class 3] WHEN 1 THEN ',Class 3' ELSE '' END
			+ CASE [Class 4] WHEN 1 THEN ',Class 4' ELSE '' END
			+ CASE [Class 5] WHEN 1 THEN ',Class 5' ELSE '' END
			+ CASE [Class 6] WHEN 1 THEN ',Class 6' ELSE '' END
			+ CASE [Class 7] WHEN 1 THEN ',Class 7' ELSE '' END
			+ CASE [Class 8] WHEN 1 THEN ',Class 8' ELSE '' END
			+ CASE [Class 9] WHEN 1 THEN ',Class 9' ELSE '' END
			+ CASE [Class 10] WHEN 1 THEN ',Class 10' ELSE '' END
			+ CASE [Class 11] WHEN 1 THEN ',Class 11' ELSE '' END
			+ CASE [Class 12] WHEN 1 THEN ',Class 12' ELSE '' END
			+ CASE [Class 13] WHEN 1 THEN ',Class 13' ELSE '' END
			+ CASE [Class 14] WHEN 1 THEN ',Class 14' ELSE '' END
			+ CASE [Class 15] WHEN 1 THEN ',Class 15' ELSE '' END
		, ' ,', '')
FROM (
	SELECT
		[School]
		, [Student ID]
		, [Class 1] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 2] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 3] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 4] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 5] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 6] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 7] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 8] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 9] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 10] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 11] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 12] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 13] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 14] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
		, [Class 15] = CASE ABS(CHECKSUM(NEWID()))%@probabilityMax+1 WHEN 1 THEN 1 ELSE NULL END
	FROM #schoolStudent
) s