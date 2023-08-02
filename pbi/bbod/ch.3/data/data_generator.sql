-- generate number rows based off of column value

DROP TABLE IF EXISTS #initialDataset
	SELECT
		*
	INTO #initialDataset
	FROM (
		SELECT [ct] = 114
	) u

DROP TABLE IF EXISTS #speaker
SELECT
	ca.id
	, session_count = ABS(CHECKSUM(NEWID()))%150+5
	, [quartile] = COALESCE(CASE id%9
		WHEN 1 THEN 1
		WHEN 2 THEN 2
		WHEN 3 THEN 2
		WHEN 4 THEN 2
		WHEN 5 THEN 3
		WHEN 6 THEN 3
		WHEN 7 THEN 3
		WHEN 8 THEN 4
	END, 2)
INTO #speaker 
FROM #initialDataset d
CROSS APPLY (
	SELECT 
		id
	FROM (
		SELECT 
			ROW_NUMBER() OVER(ORDER BY 1/0) AS id
		FROM master..spt_values s1
		) AS s
		WHERE
			s.id <= d.ct
) ca

;WITH cte
AS
(
SELECT
	s.[id]
	, s.session_count
	, c.category
	, c.category_sort
	, rating = CAST(CASE c.category
		WHEN 'Overall' THEN null
		ELSE CASE
			WHEN s.quartile = 1 THEN CASE ABS(CHECKSUM(NEWID()))%3+1 WHEN 1 THEN ABS(CHECKSUM(NEWID()))%100+350 ELSE ABS(CHECKSUM(NEWID()))%65+410 END
			WHEN s.quartile = 2 THEN CASE ABS(CHECKSUM(NEWID()))%3+1 WHEN 1 THEN ABS(CHECKSUM(NEWID()))%50+250 ELSE ABS(CHECKSUM(NEWID()))%100+350 END
			WHEN s.quartile = 3 THEN CASE ABS(CHECKSUM(NEWID()))%3+1 WHEN 1 THEN ABS(CHECKSUM(NEWID()))%100+225 ELSE ABS(CHECKSUM(NEWID()))%100+250 END
			WHEN s.quartile = 4 THEN ABS(CHECKSUM(NEWID()))%100+225
		END
	END AS FLOAT)/100
FROM #speaker s
CROSS JOIN (
	SELECT
	*
	FROM (
		VALUES ('Overall', 1), ('Content', 2), ('Speaker presentation', 3), ('Relevance', 4)
	)
	AS c(category, category_sort)
)  c
)

SELECT
	s.id
	, s.session_count
	, s.category
	, s.category_sort
	, rating = CASE s.category
		WHEN 'Overall' THEN ov.ovl
		ELSE s.rating
	END
FROM cte s
INNER JOIN (
	SELECT
		id
		, [ovl] = ROUND(AVG(rating),2)
	FROM cte
	WHERE 
		rating IS NOT NULL
	GROUP BY 
		id
) ov
	ON s.id = ov.id
ORDER BY s.id, s.category_sort 
