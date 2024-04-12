// clear data
MATCH (n)
DETACH DELETE n;
// load track nodes
LOAD CSV WITH HEADERS FROM 'file:///tracks.csv' AS row
MERGE (t:track{TrackID: row.TrackID, Duration:row.Duration, PlayCount:row.PlayCount})
SET t.TrackURI = CASE trim(row.TrackURI) WHEN "" THEN null ELSE row.TrackURI END
SET t.ReleaseDate = CASE trim(row.ReleaseDate) WHEN "" THEN null ELSE row.ReleaseDate END
SET t.Labels = CASE trim(row.Labels) WHEN "" THEN null ELSE row.Labels END
RETURN count(t);
// load creditors
LOAD CSV WITH HEADERS FROM 'file:///creditors.csv' AS row
MERGE (c:creditor{CreditorID: row.CreditorID, Name: row.Name, Role: row.Role})
RETURN count(c);

// load content_rating
LOAD CSV WITH HEADERS FROM 'file:///content_rating.csv' AS row
MERGE (cr:content_rating{contentRatingID: row.contentRatingID, contentRatingName: row.contentRatingName})
RETURN count(cr);

// load trending_dates
LOAD CSV WITH HEADERS FROM 'file:///trending_dates.csv' AS row
MERGE (td:trending_date{TrendingID: row.TrendingID, PeakRank: row.PeakRank, AppearancesOnChart:row.AppearancesOnChart, ConsecutiveAppearancesOnChart:row.ConsecutiveAppearancesOnChart})
SET td.TrendingDate = CASE trim(row.TrendingDate) WHEN "" THEN null ELSE row.TrendingDate END
RETURN count(td);

// load insertion_log
LOAD CSV WITH HEADERS FROM 'file:///track_insertion_log.csv' AS row
WITH row WHERE row.InsertionTimeStamp IS NOT NULL
MERGE (il:insertion_log{LogID: row.LogID, TrackID: row.TrackID, TrackName:row.TrackName, InsertionTimeStamp:row.InsertionTimeStamp})
RETURN count(il);



// create content_rating relationships
LOAD CSV WITH HEADERS FROM 'file:///track_content_rating.csv' AS row
MATCH (t:track {TrackID: row.TrackID})
MATCH (cr:content_rating {contentRatingID: row.contentRatingID})
MERGE (t)-[:HAS_RATING]->(cr)
RETURN *;


// create creditors relationships
LOAD CSV WITH HEADERS FROM 'file:///track_creditors.csv' AS row
MATCH (t:track {TrackID: row.TrackID})
MATCH (c:creditor{CreditorID: row.CreditorID})
MERGE (c)-[:CONTRIBUTED_TO]->(t)
RETURN *;


// create trending dates relationships
LOAD CSV WITH HEADERS FROM 'file:///track_trending_dates.csv' AS row
MATCH (t:track {TrackID: row.TrackID})
MATCH (td:trending_date{TrendingID: row.TrendingID})
MERGE (t)-[:TRENDING]->(td)
RETURN *;
