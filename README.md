# MinSQL
The code for the paper Text-to-SQL Generation through Decomposing Minimum Operating Unit (https://openreview.net/forum?id=4VM7K4Sa2t)

## Run evaluation 
Add your openai key in the *generate_sqls_by_gpt3.5.py*, *column_recall.py*, *table_recall.py* files. 
```shell
openai.api_key = "your_api_key"
```

Clone evaluation scripts (test-suite-sql-eval:[https://github.com/taoyds/test-suite-sql-eval](https://github.com/taoyds/test-suite-sql-eval)): 

```shell
mkdir third_party
cd third_party
git clone https://github.com/taoyds/test-suite-sql-eval
cd ..
```


Put the 'predicted_sql.txt' in the current directory. 

Then you can run evaluation with following command, and you will see the results on dev data.  
For testing, you just need to replace '**dev_gold.sql**' with your test data, folder '**database**' with your database and '**spider/tables.json**' with your test tables.json. 
```shell
python third_party/test-suite-sql-eval/evaluation.py --gold dev_gold.sql --pred predicted_sql.txt --db database --table data/spider/tables.json --etype all 
```
