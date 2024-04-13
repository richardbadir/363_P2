// clear data
MATCH (n)
DETACH DELETE n;
// load track nodes
LOAD CSV WITH HEADERS FROM 'file:///tracks.csv' AS row
MERGE (t:track {
  TrackID: toInteger(row.TrackID)
})
ON CREATE SET
  t.TrackName = CASE WHEN trim(row.TrackName) = '' THEN NULL ELSE row.TrackName END,
  t.TrackUri = CASE WHEN trim(row.TrackUri) = '' THEN NULL ELSE row.TrackUri END,
  t.Labels = CASE WHEN trim(row.Labels) = '' THEN NULL ELSE row.Labels END,
  t.Duration = CASE WHEN trim(row.Duration) = '' THEN NULL ELSE row.Duration END,
  t.PlayCount = CASE WHEN trim(row.PlayCount) = '' THEN NULL ELSE toInteger(row.PlayCount) END,
  t.Image = CASE WHEN trim(row.Image) = '' THEN NULL ELSE 'file:///images/' + row.Image END
RETURN count(t);


// load creditors
LOAD CSV WITH HEADERS FROM 'file:///creditors.csv' AS row
MERGE (c:creditor { CreditorID: toInteger(row.CreditorID) })
ON CREATE SET
  c.Name = row.Name,
  c.Role = row.Role
ON MATCH SET
  c.Name = row.Name,
  c.Role = row.Role
RETURN count(c);


// load content_rating
LOAD CSV WITH HEADERS FROM 'file:///content_rating.csv' AS row
MERGE (cr:content_rating { contentRatingID: toInteger(row.contentRatingID) })
ON CREATE SET
  cr.contentRatingName = row.contentRatingName
ON MATCH SET
  cr.contentRatingName = row.contentRatingName
RETURN count(cr);

// load trending_dates
LOAD CSV WITH HEADERS FROM 'file:///trending_dates.csv' AS row
MERGE (td:trending_date {TrendingID: row.TrendingID})
ON CREATE SET
  td.PeakRank = row.PeakRank,
  td.AppearancesOnChart = row.AppearancesOnChart,
  td.ConsecutiveAppearancesOnChart = row.ConsecutiveAppearancesOnChart,
  td.TrendingDate = CASE WHEN trim(row.TrendingDate) = "" THEN null ELSE row.TrendingDate END
ON MATCH SET
  td.PeakRank = row.PeakRank,
  td.AppearancesOnChart = row.AppearancesOnChart,
  td.ConsecutiveAppearancesOnChart = row.ConsecutiveAppearancesOnChart,
  td.TrendingDate = CASE WHEN trim(row.TrendingDate) = "" THEN null ELSE row.TrendingDate END
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
