import json
import argparse

def parse_option():
    parser = argparse.ArgumentParser("command line arguments for generate prompt")
    parser.add_argument("--input_dataset_path", type=str)
    parser.add_argument("--output_dataset_path", type=str)

    opt = parser.parse_args()

    return opt


if __name__ == "__main__":
    opt = parse_option()
    print(opt)
    with open("column_recall.json") as f:
        data_all = json.load(f)
    temp = []
    for id, data in enumerate(data_all):
        data['input_sequence'] = "### Write relational algebra expressions for the question: " 
        data['input_sequence'] += data['question']
        data['input_sequence'] += "\n ### Tables, with their properties: \n#\n"
        schema = ""
        for tab, cols in data['schema'].items():
            schema += '# ' + tab + ' ( '
            for i, col in enumerate(cols):
                schema += col
                if data['db_contents'][tab][i]:
                    schema += '("'
                    for value in data['db_contents'][tab][i]:
                        schema += value + '", "'
                    schema = schema[:-4] + '")'
                schema += ', '
            schema = schema[:-2] + ' )\n'
        data['input_sequence'] += schema[:-1]
        for fk in data['fk']:
            data['input_sequence'] += '\n# ' + fk
    with open("C3_dev.json", 'w') as f:
        json.dump(data_all, f, indent=2)