import argparse
import json
import time
import openai
import re
import os
import sqlite3
from tqdm import tqdm

# add your openai api key
openai.api_key = "YOUR OPENAI KEY"


chat_prompt = [
    {
        "role": "system",
        "content": '''You are an excellent relational database expert and you should write relational algebra expressions for the question.'''
    }
]
#  \
        # You should just output the final expression including all the involved relational algebra operators.

chat_prompt_json = [
    {
        "role": "system",
        "content": '''You are an excellent relational database expert and you need to convert the provided relational algebra expressions into the corresponding JSON format. \
        '''
    }
]

def parse_option():
    parser = argparse.ArgumentParser("command line arguments for generate sqls")
    parser.add_argument("--input_dataset_path", type=str)
    parser.add_argument("--self_consistent", type=bool, default=True)
    parser.add_argument("--n", type=int, default=1,
                        help="Size of self-consistent set")
    parser.add_argument("--output_dataset_path", type=str)
    parser.add_argument("--db_dir", type=str, default="./data/database")

    opt = parser.parse_args()

    return opt


def generate_reply(messages, n):
    completions = openai.ChatCompletion.create(
        model="gpt-4-turbo",
        # model = "gpt-4",
        messages=messages,
        n=n
    )
    # print(f"completions->{completions}")
    mes = completions.choices[0].message.content
    all_p_sqls = []
    for i in range(n):
        all_p_sqls.append(completions.choices[i].message.content.replace("\n", " "))
    return all_p_sqls

def generate_json(text):
    messages = []
    messages = chat_prompt_json.copy()
    input = "### Write the corresponding JSON for the relational algebra expression in this text:"
    input +=f"\n    {text}"
    input +="### Below is the response guide: \n#"
    input +="\n# 1.You only need to output a JSON, without providing any additional explanations"
    # input +="\n# 2.You only need to focus on the relational algebra expressions. If there is any content other than the relational algebra expressions in the provided material, please ignore it."
    input +="\n# 2.I would like the value of the 'operation' field in the JSON to be one of the elements from the following array: [selection, projection, union, difference, cartesian_product, rename, join, intersection, division, aggregation, extension].Please note that group_by is a subclass of aggregation. The sort and order_by belong to extension."
    input +="\n### Here is the output format:\n"
    input +='''
    {
        "operation": "projection",
        "attributes": ["name", "COUNT(petid)"],
        "input": {
        "operation": "extension",
        "order_by": {
            "attributes":["age"],
            "order": "desc"
        },
        "input": {
            "operation": "aggregation",
            "group_by": ["name"],
            "aggregates": [
                {
                "type": "count",
                "field": "petid"
                }
            ],
            "input": {
                "operation": "join",
                "condition": "student.id = pet.student_id",
                "left": {
                    "type": "table",
                    "name": "student"
                },
                "right": {
                    "type": "table",
                    "name": "pet"
                }
            }
        }
        }
    }'''
    messages.append({"role": "user", "content": input})
    reply = generate_reply(messages, 1)
    response = reply[0]
    return response

if __name__ == '__main__':
    replys = []
    with open("result_gpt-4-turbo.json") as f:
        replys = json.load(f)
    # texts = []
    # with open("text_gpt-4-turbo.json") as f:
    #     texts = json.load(f)
    with open("C3_plan4.json") as f:
        data = json.load(f)
        # data = data[836:]
        # data = data[836:]
        # data = data[:5]
    num = 858
    item = data[num]
    messages = []
    messages = chat_prompt.copy()
    input = item['input_sequence']
    messages.append({"role": "user", "content": input})
    reply = None
    while reply is None:
        try:
            reply = generate_reply(messages, 1)
            text = reply[0]
            print(f"\nquestion{num+1}:")
            print(f"\n  step1 generate relational algebra->\n       {text}")
            reply2 = None
            while reply2 is None:
                try:
                    reply2 = generate_json(text)
                    # text = generate_json(text)
                    print(reply2)
                    reply2 = re.sub(r'```json|```', '', reply2).strip()
                    reply2 = json.loads(reply2)
                    print(f"\n  step2 convert json format->\n       {reply2}")
                except Exception as e:
                    print(e)
                    print(f"api error, wait for 3 seconds and retry...")
                    time.sleep(3)
                    pass
        except Exception as e:
            print(e)
            print(f"api error, wait for 3 seconds and retry...")
            time.sleep(3)
            pass
    replys[num] = reply2
    with open("result_gpt-4-turbo.json", 'w') as f:
      json.dump(replys, f, indent=2)