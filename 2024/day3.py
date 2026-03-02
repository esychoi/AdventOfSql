import os
import xml.etree.ElementTree as ET

import mysql.connector
from dotenv import load_dotenv
from tqdm import tqdm

load_dotenv("../.env")

version2guests = {"1.0": "total_count", "2.0": "total_guests", "3.0": "total_present"}
guest_insert_sql = "INSERT INTO christmas_dinner (id, number_of_guests) VALUES (%s, %s)"
food_insert_sql = "INSERT INTO christmas_dinner_food (event_id, food_item_id) VALUES (%s, %s)"

# Connect to MySQL database
conn = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST"),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
    database=os.getenv("MYSQL_DATABASE"),
)
cursor = conn.cursor()

# Create tables
cursor.execute("DROP TABLE IF EXISTS christmas_dinner")
cursor.execute("DROP TABLE IF EXISTS christmas_dinner_food")
cursor.execute("CREATE TABLE christmas_dinner (id INT PRIMARY KEY, number_of_guests INT)")
cursor.execute("CREATE TABLE christmas_dinner_food (id SERIAL PRIMARY KEY, event_id INT, food_item_id INT)")

# Fetch raw XML data
cursor.execute("SELECT * FROM christmas_menus")
christmas_menus = cursor.fetchall()

# Process data
for row_id, xml_data in tqdm(christmas_menus):
    root = ET.fromstring(xml_data)
    version = root.attrib["version"]

    guests = (row_id, int(list(root.iter(version2guests[version]))[0].text))
    food_item_ids = [(row_id, fid) for fid in map(int, [fid.text for fid in root.iter("food_item_id")])]

    cursor.execute(guest_insert_sql, guests)
    cursor.executemany(food_insert_sql, food_item_ids)

conn.commit()
conn.close()
