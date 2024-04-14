
//1 A basic search query on an attribute value.
MATCH (t:track {TrackName: 'Beautiful Things'})
RETURN t;
//First try: took 24 ms.
//With indexes: took 6 ms.





//2 A query that provides some aggregate data (i.e. number of entities satisfying a criteria)
// For counting the number of tracks that have a PlayCount greater than 1000:

MATCH (t:track)
WHERE t.PlayCount > 1000
RETURN count(t) AS NumberOfTracks;
//First try: took 16 ms.
//With indexes: took 20 ms.





//3 Find top n entities satisfying a criteria, sorted by an attribute.
// Find the top 5 tracks with the highest play count:

MATCH (t:track)
WHERE t.PlayCount IS NOT NULL
RETURN t
ORDER BY t.PlayCount DESC
LIMIT 5;
// first try: took 35 ms.
//With indexes: took 6 ms.




//4 Simulate a relational group by query in NoSQL (aggregate per category).
// calculate the average PlayCount for each Label

MATCH (t:track)
WHERE t.PlayCount IS NOT NULL AND t.Labels IS NOT NULL
RETURN t.Labels as LabelNames, avg(t.PlayCount) AS AveragePlayCount
//First try: took 30 ms.
//With indexes: took 31 ms.



//5 Creating indexes 
CREATE INDEX FOR (t:track) ON (t.TrackName);
CREATE INDEX FOR (t:track) ON (t.PlayCount);
CREATE INDEX FOR (t:track) ON (t.Labels);
// Clearing the cache to have a fair comparison, then we recompare the time it takes for each query
CALL db.clearQueryCaches()

