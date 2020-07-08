/* 
Reliable domains of news articles for Task 3.1
*/
SELECT domainURL
FROM Domain
WHERE domainID in (
    SELECT domainID
    FROM Webpage
    Where articleID in (
        SELECT articleID 
        FROM typelinks
        WHERE typeID = 8 
        AND articleID in (
            SELECT articleID
            FROM Article
            WHERE scrapedAt >= to_timestamp(2018-1-15)
        )
    )
);

/* 
Most prolific authors of fake type news articles for Task 3.2
*/
SELECT authorName, COUNT(w.authorid) 
FROM writtenby w, typelinks t, author a 
WHERE w.articleid = t.articleid 
    AND t.typeid = 7 
    AND w.authorID = a.authorID
GROUP BY a.authorName, w.authorid 
ORDER BY count DESC
LIMIT 20; 

/* 
Pairs of article ids with the exact same set of keywords for Task 3.3
*/
WITH tags_small AS (SELECT * from tags where articleID <= 500),
     article_small AS (SELECT DISTINCT articleID FROM tags_small)
SELECT COUNT(DISTINCT t1.articleID) / 2
FROM tags_small t1
INNER JOIN tags_small t2 
ON t1.articleID <> t2.articleID AND t1.keywordID = t2.keywordID;

SELECT domainURL, typeValue, COUNT(w.domainID)
FROM Webpage w, Domain d, typelinks tl, Types t
WHERE w.domainID in (
    SELECT domainID
    FROM Webpage
    Where articleID in (
        SELECT articleID 
        FROM typelinks
        WHERE typeID = 2 
        )
    ) 
AND w.domainID = d.domainID
AND w.articleID = tl.articleID
AND tl.typeID = t.typeID
GROUP BY d.domainURL, typeValue
ORDER BY count DESC;


SELECT typeValue, COUNT(articleID)
FROM Types t, typelinks tl
WHERE t.typeID = tl.typeID
GROUP BY typeValue
ORDER BY count DESC;


SELECT authorName, COUNT(w.articleID)
FROM Writtenby w, Author a 
WHERE w.authorID = a.authorID
GROUP BY authorName
ORDER BY count DESC
LIMIT 100;

SELECT authorName, typeValue, COUNT(a.authorID)
FROM Author a, Writtenby w, typelinks tl, Types t
WHERE w.articleID = tl.articleID AND a.authorID = w.authorID AND tl.typeID = t.typeID
GROUP BY authorName, typeValue
ORDER BY count DESC
LIMIT 100;

