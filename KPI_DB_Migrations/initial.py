import json
import csv
import os
import psycopg2
import sys

def GetStructure():
    root_folder = GetSection("root_dataset_folder")
    fileNames = GetSection('file_names')

    with open(os.path.join(root_folder, fileNames["2019"]+".csv"), encoding='koi8_u') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        csv_reader = csv_reader.__next__()
        result = {
            csv_reader[0]:"uuid",
            csv_reader[1]:"int4"
            }
        
        for cell in csv_reader[2:16]:
            result[cell] = "text"
        for i in range(16,len(csv_reader),10):
            result[csv_reader[i+0]] = "text"
            if(csv_reader[i+1].__contains__("Lang")):
               result[csv_reader[i+1]] = "text"
               i += 1 
            result[csv_reader[i+1]] = "text"
            result[csv_reader[i+2]] = "int4"
            result[csv_reader[i+3]] = "int4"
            if(csv_reader[i+4].__contains__("DPALevel")):
               result[csv_reader[i+4]] = "text"
               i += 1 
            result[csv_reader[i+4]] = "int4"
            result[csv_reader[i+5]] = "text"
            result[csv_reader[i+6]] = "text"
            result[csv_reader[i+7]] = "text"
            result[csv_reader[i+8]] = "text"
            try:
                result[csv_reader[i+9]] = "text"
            except:
                print("one filed was unnecessary :) ")

        result["year"] = "int4"

    return result

def GetSection(section_name):
    f = open('appsettings.json')
    data = json.load(f)
    f.close()
    return data[section_name]

def CreateDatabaseByStructure(structure, env=""):
    request = "CREATE TABLE zno_persons("

    for column in structure:
        request += column + " " + structure[column] + ", "

    request += "PRIMARY KEY(OUTID));"
    conn_string = GetSection("connection_string")

    if(env != ""):
        conn_string = conn_string.replace(conn_string[conn_string.find("=")+1: conn_string.find(" ")], env)

    conn = psycopg2.connect(conn_string)
    cur = conn.cursor()
    cur.execute(request)
    conn.commit()
    conn.close()
    cur.close()
    print("created")

if __name__ == "__main__":
    env_name = ""
    if len(sys.argv) > 1:
        env_name = sys.argv[1]

    structure = GetStructure()
    CreateDatabaseByStructure(structure, env_name)