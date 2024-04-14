
//1 A basic search query on an attribute value.
MATCH (t:track {TrackName: 'Beautiful Things'})
RETURN t;
//First try: took 27 ms.
//With indexes: took 7 ms.





//2 A query that provides some aggregate data (i.e. number of entities satisfying a criteria)
// For counting the number of tracks that have a PlayCount greater than 1000:

MATCH (t:track)
WHERE t.PlayCount > 1000
RETURN count(t) AS NumberOfTracks;
//First try: took 16 ms.
//With indexes: took 10 ms.





//3 Find top n entities satisfying a criteria, sorted by an attribute.
// Find the top 5 tracks with the highest play count:

MATCH (t:track)
WHERE t.PlayCount IS NOT NULL
RETURN t
ORDER BY t.PlayCount DESC
LIMIT 5;
// first try: took 18 ms.
//With indexes: took 26 ms.




//4 Simulate a relational group by query in NoSQL (aggregate per category).
// calculate the average PlayCount for each Label

MATCH (t:track)
WHERE t.PlayCount IS NOT NULL AND t.Labels IS NOT NULL
RETURN t.Labels as LabelNames, avg(t.PlayCount) AS AveragePlayCount
//First try: took 23 ms.
//With indexes: took 26 ms.



//5 Creating indexes 
CREATE INDEX FOR (t:track) ON (t.TrackName);
CREATE INDEX FOR (t:track) ON (t.PlayCount);
CREATE INDEX FOR (t:track) ON (t.Labels);
// Clearing the cache to have a fair comparison, then we recompare the time it takes for each query
CALL db.clearQueryCaches()


//6 Demonstrate a full text search. Show the performance improvement by using indexes.
// We use PROFILE to see the performance
CREATE FULLTEXT INDEX tracksFullText FOR (n:track) ON EACH [n.TrackName, n.Labels]

PROFILE CALL db.index.fulltext.queryNodes("tracksFullText", "Love") YIELD node
RETURN node.TrackName, node.Labels
// Results : Started streaming 189 records after 85 ms and completed after 145 ms.


