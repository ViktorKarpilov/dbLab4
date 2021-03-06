import sys  
sys.path.append("KPI_DB_Migrations")  
from initial import GetSection, GetStructure 
import psycopg2
import csv
import os

def populateDatabase(yearToStart = 2019):
    root_folder = GetSection("root_dataset_folder")
    fileNames = GetSection('file_names')

    conn_string = GetSection("connection_string")

    conn = psycopg2.connect(conn_string)
    cur = conn.cursor()

    structure = list(GetStructure().keys())

    for year in range(int(yearToStart)+2-len(fileNames), 2021):
        with open(os.path.join(root_folder, fileNames[str(year)]+".csv"), encoding='windows-1251') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=';')
            csv_reader.__next__()

            cur.execute("SELECT COUNT(*) FROM zno_persons")
            records_count = cur.fetchall()[0][0]

            added = 0

            for line in csv_reader:
                
                command_header = "INSERT INTO zno_persons"
                column_names = "( "
                values_header = "VALUES"
                values_body = "( "

                if records_count > 0:
                    records_count -= 1
                    continue

                if(len(line) + 1 != len(structure)):
                    print("Whoops ... ¯\_(ツ)_/¯")
                    return 0

                for i in range(len(line)):

                    line[i] = line[i].replace('"', '')
                    line[i] = line[i].replace("'", "")
                    line[i] = line[i].replace(",0", "")
                    line[i] = line[i].replace(",5", "")

                    column_names += structure[i] +", "
                    if(line[i] != "null"):
                        values_body += "'"+line[i]+"'" + ", "
                    else:
                        values_body += "DEFAULT " + ", " 
                
                column_names += "year" + ")" 
                values_body += "'"+str(year)+"'" + ")"

                command = command_header + column_names + values_header + values_body

                cur.execute(command)
                added += 1
                if(added%100 == 0):
                    conn.commit() 
                    added = 0

def getCompare():
    if not os.path.exists("result.csv"):
        f = open("result.csv","w+")
        f.close()

    conn_string = GetSection("connection_string")

    conn = psycopg2.connect(conn_string)
    cur = conn.cursor()
    
    with open('result.csv', mode='w') as res_file:
        fieldnames = ['2019AvgResult', '2020AvgResult']
        cur.execute("""select 
                        (select 
                        avg(mathball100)
                    from zno_persons
                    where 
                        year=2019
                        and mathteststatus = 'Зараховано'),
                        (select 
                        avg(mathball100)
                    from zno_persons
                    where 
                        year=2020
                        and mathteststatus = 'Зараховано')""")
        writer = csv.DictWriter(res_file, fieldnames=fieldnames)
        writer.writeheader()
        res = cur.fetchall()
        writer.writerow({"2019AvgResult":res[0][0], "2020AvgResult":res[0][1]})
        return (res[0][0], res[0][1])