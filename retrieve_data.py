import mysql.connector
import csv
# Connect to the database
mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="richardbad11",
  database="music"
)
mycursor = mydb.cursor()
# Check if the connection was successful
mycursor.execute("SELECT * FROM Tracks")

# Fetch all the results
results = mycursor.fetchall()

csv_file_path = 'tracks.csv'

# Write the results to a CSV file
with open(csv_file_path, mode='w', newline='', encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow("TrackName,TrackUri,Labels,ReleaseDate,Duration,PlayCount")
    for row in results:
        writer.writerow(row)

mydb.close()