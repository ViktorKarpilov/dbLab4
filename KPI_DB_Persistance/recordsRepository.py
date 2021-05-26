import sys  
sys.path.append("KPI_DB_Migrations")  
import psycopg2
import csv
import os
from pymongo import MongoClient
import datetime
import urllib

conn_string = "mongodb://root:" + "example" + "@127.0.0.1:28017/"
client = MongoClient(conn_string)
db = client.db_zno

def populateDatabase(yearToStart = 2019, fileName = "Odata2019File.csv"):
	batch_size = 1000

	with open(fileName, "r", encoding="cp1251") as csv_file:
		i = 0
		batches_num = 0
		start_time = datetime.datetime.now()
		csv_reader = csv.DictReader(csv_file, delimiter=';')
		document_bundle = []
		num_inserted = db.inserted_docs.find_one({"yearToStart": yearToStart})
		if num_inserted == None:
			num_inserted = 0
		else:
			num_inserted = num_inserted["num_docs"]
		for row in csv_reader:
			if batches_num * batch_size + i < num_inserted:
				i += 1
				if i == batch_size:
					i = 0
					batches_num += 1
				continue
			document = row
			document['yearToStart'] = yearToStart
			document_bundle.append(document)
			i += 1
			if i == batch_size:
				i = 0
				batches_num += 1
				db.collection_zno_data.insert_many(document_bundle)
				document_bundle = []
				if batches_num == 1:
					db.inserted_docs.insert_one({"num_docs": batch_size, "yearToStart": yearToStart})
				else:
					db.inserted_docs.update_one({
						"yearToStart": yearToStart, "num_docs": (batches_num - 1) * batch_size}, 
						{"$inc": {
							"num_docs": batch_size
						}  })
		if i != 0 and document_bundle:
			db.inserted_docs.update_one({
				"yearToStart": yearToStart, "num_docs": batches_num * batch_size}, 
				{"$inc": {
					"num_docs": i
				}  })
			db.collection_zno_data.insert_many(document_bundle)
		end_time = datetime.datetime.now()
		print('time:', end_time - start_time)
    
def getCompare():
	result = {
		"2019":0,
		"2020":0
	}
	pipeline = [
    {
        u"$match": {
            u"mathTestStatus": u"\u0417\u0430\u0440\u0430\u0445\u043E\u0432\u0430\u043D\u043E"
        }
    }, 
    {
        u"$group": {
            u"_id": {
                u"year": u"$yearToStart"
            },
            u"avg_score": {
                u"$avg": {
                    u"$toInt": {
                        u"$substr": [
                            u"$mathBall100",
                            0.0,
                            3.0
                        ]
                    }
                }
            }
        }
    }
	]

	for res in db.collection_zno_data.aggregate(pipeline):
		result[res["_id"]["year"]] = res["avg_score"]

	return result;

