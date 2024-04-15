
//1 A basic search query on an attribute value.
MATCH (t:track {TrackName: 'Beautiful Things'})
RETURN t;
//First try: took 27 ms.
//With indexes: took 7 ms.





//2 A query that provides some aggregate data (i.e. number of entities satisfying a criteria)
// For counting the number of tracks that have a PlayCount greater than 1000:

MATCH (t:track)
WHERE t.PlayCount > 10000000
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

//Step 1: Create a Full-Text Index
CREATE TEXT INDEX trackNameSearch FOR (t:track) ON (t.TrackName);
//Added 1 index, completed after 11 ms.


//Step 2: Perform a Full-Text Search
MATCH (t:track)
WHERE t.TrackName CONTAINS 'love'
RETURN t.TrackName AS TrackName
ORDER BY t.TrackName
LIMIT 5;
//Started streaming 5 records after 9 ms and completed after 58 ms.


//DEMONSTRATING PERFORMANCE IMPROVEMENT 

//Before creating indexes:
PROFILE
MATCH (t:track)
WHERE t.TrackName CONTAINS 'love'
RETURN t.TrackName AS TrackName
LIMIT 5;

//After Creating Indexes:
PROFILE
MATCH (t:track)
WHERE t.TrackName CONTAINS 'love'
RETURN t.TrackName AS TrackName
ORDER BY t.TrackName
LIMIT 5;

//**Ensure fair comparison by clearing the query cache between tests:
CALL db.clearQueryCaches();


