import mysql.connector
import csv
# Connect to the database
mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="PASSWORD", #replace with your actual password
  database="music"
)
mycursor = mydb.cursor()
#Tracks
mycursor.execute("SELECT * FROM Tracks")

# Fetch all the results
results = mycursor.fetchall()

csv_file_path = 'tracks.csv'

# Write the results to a CSV file
with open(csv_file_path, mode='w', newline='', encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["TrackID","TrackName","TrackUri","Labels","ReleaseDate","Duration","PlayCount"])
    for row in results:
        writer.writerow(row)


#creditors
mycursor.execute("SELECT * FROM Creditors")

# Fetch all the results
results = mycursor.fetchall()

csv_file_path = 'creditors.csv'

# Write the results to a CSV file
with open(csv_file_path, mode='w', newline='', encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["CreditorID","Name","Role"])
    for row in results:
        writer.writerow(row)

#TrackCreditors
mycursor.execute("SELECT * FROM TrackCreditors")

# Fetch all the results
results = mycursor.fetchall()

csv_file_path = 'track_creditors.csv'

# Write the results to a CSV file
with open(csv_file_path, mode='w', newline='', encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["TrackID","CreditorID"])
    for row in results:
        writer.writerow(row)

#ContentRating
mycursor.execute("SELECT * FROM ContentRating")

# Fetch all the results
results = mycursor.fetchall()

csv_file_path = 'content_rating.csv'

# Write the results to a CSV file
with open(csv_file_path, mode='w', newline='', encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["contentRatingID","contentRatingName"])
    for row in results:
        writer.writerow(row)

#TrackContentRating
mycursor.execute("SELECT * FROM TrackContentRating")

# Fetch all the results
results = mycursor.fetchall()

csv_file_path = 'track_content_rating.csv'

# Write the results to a CSV file
with open(csv_file_path, mode='w', newline='', encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["TrackID","contentRatingID"])
    for row in results:
        writer.writerow(row)


#TrackInsertionLog
mycursor.execute("SELECT * FROM TrackInsertionLog")

# Fetch all the results
results = mycursor.fetchall()

csv_file_path = 'track_insertion_log.csv'

# Write the results to a CSV file
with open(csv_file_path, mode='w', newline='', encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["LogID","TrackID","TrackName","InsertionTimestam"])
    for row in results:
        writer.writerow(row)

mydb.close()