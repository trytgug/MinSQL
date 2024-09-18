# MinSQL
The code for the paper Text-to-SQL Generation through Decomposing Minimum Operating Unit (https://openreview.net/forum?id=4VM7K4Sa2t)

## Prepare

Download [data](https://drive.google.com/uc?export=download&id=1TqleXec_OykOYFREKKtschzY29dUcVAQ) and database and then unzip them:
```shell
mkdir data 
unzip spider.zip 
mv spider/database . 
mv spider data
```

Download [evaluation scripts](https://github.com/taoyds/test-suite-sql-eval)
```shell
mkdir third_party
cd third_party
git clone https://github.com/taoyds/test-suite-sql-eval
cd ..
```


## Run inference

Add your openai key in the *table_recall.py*, *column_recall.py*, *generateRA.py* files. 
```shell
run inference.sh
```

## Run translate

Coming soon...


## Run evaluation 

Put the '**output.sql**' in the current directory. 

Then you can run evaluation with following command, and you will see the results on dev data.  
For testing, you just need to replace '**dev_gold.sql**' with your test data, folder '**database**' with your database and '**spider/tables.json**' with your test tables.json. 
```shell
python third_party/test-suite-sql-eval/evaluation.py --gold dev_gold.sql --pred predicted_sql.txt --db database --table data/spider/tables.json --etype all 
```
