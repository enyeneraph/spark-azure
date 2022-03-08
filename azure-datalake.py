import pyspark 
import sys 
from pyspark import SparkContext, SparkConf  
from pyspark.sql import SparkSession  
from delta import *  

container_name = sys.argv[1]
storage_account_name = sys.argv[2]
account_access_key = sys.argv[3]

builder = SparkSession.builder \
    .master("local") \
    .config("spark.jars.packages", "org.apache.hadoop:hadoop-azure-datalake:3.3.1") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
    .config(f"spark.hadoop.fs.azure.account.auth.type.{storage_account_name}.dfs.core.windows.net", "SharedKey")\
    .config(f"spark.hadoop.fs.azure.account.key.{storage_account_name}.dfs.core.windows.net",f"{account_access_key}")

spark = configure_spark_with_delta_pip(builder).getOrCreate()

spark.range(5).write.format("delta").save(f"abfss://{container_name}@{storage_account_name}.dfs.core.windows.net/<filename>")
print("Successfully written")
df = spark.read.format("delta").load(f"abfss://{container_name}@{storage_account_name}.dfs.core.windows.net/<filename>")

df.show()

#instruction to run docker 
#docker run -it test:four <container_name> <storage_account_name> <account_access_key>