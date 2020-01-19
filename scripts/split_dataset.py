#!/usr/bin/env python3

import argparse
import os


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', type=str, default=None,
                        help='Input file or folder: if folder all .txt files will be processed')
    parser.add_argument('-o', '--output_folder', type=str, default=None,
                        help='Output folder')
    args = parser.parse_args()

    return args


def split_file(input_folder, input_file, output_folder):
    print(f'Splitting {input_file}')

    src_file = input_file.replace('.txt', '_src.txt')
    tgt_file = input_file.replace('.txt', '_tgt.txt')

    with open(os.path.join(input_folder, input_file), 'r') as f:
        # WARNING readlines does NOT remove the newline character which
        # will then be used when writelines will save the output file,  
        # writelines() does NOT add newline on its now
        lines = f.readlines()

    with open(os.path.join(output_folder, src_file), 'w') as f:
        f.writelines(lines[::2])

    with open(os.path.join(output_folder, tgt_file), 'w') as f:
        f.writelines(lines[1::2])


def main(args):
    # Check if output folder exists
    if not os.path.isdir(args.output_folder):
        print(f'Creating output folder {args.output_folder}')
        os.makedirs(args.output_folder)

    # Process all files in a folder
    if os.path.isdir(args.input):
        for file in os.listdir(args.input):
            if file.endswith('.txt'):
                split_file(args.input, file, args.output_folder)
    # Process single file
    elif os.path.isfile(args.input) and args.input.endswith('.txt'):
        folder, f = os.path.split(args.input)
        split_file(folder, f, args.output_folder)
    else:
        print(f'The input provided is neither a folder nor a file: {args.input}')


if __name__ == '__main__':
    args = parse_args()
    main(args)
