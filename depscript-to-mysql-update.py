import requests
import json
import csv
import pandas as pd
import schedule
import time
import numpy as np
import pymysql


## create inital data path and objects

#datapath = 'C:/University of Chicago/Data Engineering Platforms/Project/Files for upload/'
currency_list = []
value = []
#conn = pymysql.connect(host="127.0.0.1", port=3306, user="root", password="root", database="deprelational")
conn = pymysql.connect(host="127.0.0.1", port=3306, user="root", password="root")
x = conn.cursor()

## function that creates the list of currencies from the original csv

#def CurrencyList():
with open('currency_list.csv', newline=None) as datafile:
    for line in datafile:
        currency_list.append(line.strip())
print ("done reading currency list")
len_currency_list = len(currency_list)
key = list(range(1, len_currency_list+2))

## function that pulls the data from the API

def DataPull():
    for i in range(len(currency_list)):
        cur = str(currency_list[i])
        api_url = "https://currencyconverterapi.com/api/v5/convert?q=" + cur + "_USD&compact=ultra&apiKey=3d35a29e-8031-4cea-aea1-5db8bd50215c"
        response = requests.get(api_url)
        output = json.loads(response.content.decode('utf-8'))
        value.append(output[str(currency_list[i]) + "_USD"])
        SaveToMysql(key[i],currency_list[i],value[i])
    i = len_currency_list
    currency_list.append('SSP')
    value.append(0.0076767534)
    SaveToMysql(key[i],currency_list[i],value[i])
    print ("Data Pull")
    conn.close()

def SaveToMysql(currency_id,currency,conversion_rate):
    try:
        #sql = "INSERT into deprelational.Conversion_Rate (currency_id, currency, conversion_rate) VALUES ("+str(currency_id)+  ",'" +currency+"'," + '%.5f' %conversion_rate + ")"
        #x.execute(sql)
        sql = "UPDATE deprelational.Conversion_Rate SET conversion_rate = %.5f" %conversion_rate + " WHERE currency_id =" +str(currency_id)+  " AND currency= '" +currency +"';"
        print (sql)
        x.execute(sql)
        sql = "UPDATE depdimensional.dim_currency SET conversion_rate = %.5f" %conversion_rate + " WHERE currency_id =" +str(currency_id)+  " AND currency= '" +currency +"';"
        print (sql)
        x.execute(sql)
        conn.commit()
    except:
        conn.rollback()
        print("Failed...")

## function to create the table in pandas and write to csv

#def CreateTable():
 #   currency_rate = pd.DataFrame(
  #      {'key': key,
   #      'currency': currency_list,
    #     'value': value
     #   })
    #currency_rate.to_csv('Conversion_Rate_v2.csv', sep=',', encoding='utf-8', index = False)
    #print ("done CreateTable")

## function to reset values before the next iteration
def Reset():
    currency_list.clear()
    value.clear()
    #key = list(range(1, len_currency_list + 2))

## function to run all of the above malfunctions
def Job():
    #CurrencyList()
    DataPull()
    CreateTable()
    Reset()

if __name__ == '__main__':
    Job()
    #schedule.every(1).hour.do(Job)
    while True:
        schedule.run_pending()
        time.sleep(1)
