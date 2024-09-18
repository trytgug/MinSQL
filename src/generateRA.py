import argparse
import json
import time
import openai
import re
import os
import sqlite3
from tqdm import tqdm

# add your openai api key
openai.api_key = "YOUR OPENAI API-KEY"

chat_prompt = [
    {
        "role": "system",
        "content": '''You are an excellent relational database expert and you should write relational algebra expressions for the question. \
        You should just output the final expression including all the involved relational algebra operators.
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
        messages=messages,
        n=n
    )
    # print(completions)
    mes = completions.choices[0].message.content
    all_p_sqls = []
    for i in range(n):
        all_p_sqls.append(completions.choices[i].message.content.replace("\n", " "))
    return all_p_sqls



if __name__ == '__main__':
    replys = []
    with open("C3_dev.json") as f:
        data = json.load(f)
    for i, item in enumerate(tqdm(data)):
        messages = []
        messages = chat_prompt.copy()
        input = item['input_sequence']
        messages.append({"role": "user", "content": input})
        reply = None
        while reply is None:
            try:
                reply = generate_reply(messages, 1)
                text = reply[0]
                print(reply)
                pattern = re.compile(r'\((.*?)\)')
                matches = re.findall(pattern, text)

                for i, match in enumerate(matches, start=1):
                    placeholder = f'N{i}'
                    text = text.replace(f'({match})', placeholder)



            except Exception as e:
                print(e)
                print(f"api error, wait for 3 seconds and retry...")
                time.sleep(3)
                pass

        replys.append(text)

    with open("result.json", 'w') as f:
        json.dump(replys, f, indent=2)