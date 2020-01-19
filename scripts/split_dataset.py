#!/usr/bin/env python3

import argparse
import os


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', type=str, default=None,
                        help='Input file or folder: if folder all .txt files will be processed')
    parser.add_argument('-o', '--output_folder', type=str, default=None,
                        help='Output folder')
    parser.add_argument('-s', '--train_split', type=float, default=None,
                        help='Proportion 0..1 of lines to use for training: if specified, splits files further into training and validation sets.')
    parser.add_argument('-t', '--token', type=str, default=None,
                        help='Type of tokenisation: word (default), char, hybrid (not implemented)')
    args = parser.parse_args()

    return args


def split_file(input_folder, input_file, output_folder, split=None, token=None):
    print(f'Splitting {input_file}')

    if split is None:
        split = 1.0

    with open(os.path.join(input_folder, input_file), 'r') as f:
        # WARNING readlines does NOT remove the newline character which
        # will then be used when writelines will save the output file,  
        # writelines() does NOT add newline on its now
        if token == 'char':
            lines = [' '.join(line.replace(' ', '_')) for line in f.readlines()]
        else:
            lines = f.readlines()

    # Separate into source and target data
    src_lines = lines[::2]
    tgt_lines = lines[1::2]

    def write_data(src_lines, tgt_lines, name='train'):
        src_file = input_file.replace('.txt', f'_src_{name}.txt')
        tgt_file = input_file.replace('.txt', f'_tgt_{name}.txt')

        with open(os.path.join(output_folder, src_file), 'w') as f:
            f.writelines(src_lines)

        with open(os.path.join(output_folder, tgt_file), 'w') as f:
            f.writelines(tgt_lines)

    # Split into training and optional validation sets, then write
    if split < 1.0:
        num_train = int(len(src_lines) * split)
        write_data(src_lines[:num_train], tgt_lines[:num_train], 'train')
        write_data(src_lines[num_train:], tgt_lines[num_train:], 'valid')
    else:
        write_data(src_lines, tgt_lines, 'test')


def main(args):
    if args.train_split is not None:
        assert args.train_split > 0 and args.train_split <= 1.0, \
            f'invalid training split: {args.train_split}'

    # Check if output folder exists
    if not os.path.isdir(args.output_folder):
        print(f'Creating output folder {args.output_folder}')
        os.makedirs(args.output_folder)

    # Process all files in a folder
    if os.path.isdir(args.input):
        for file in os.listdir(args.input):
            if file.endswith('.txt'):
                split_file(args.input, file, args.output_folder, 
                    args.train_split, args.token)
    # Process single file
    elif os.path.isfile(args.input) and args.input.endswith('.txt'):
        folder, f = os.path.split(args.input)
        split_file(folder, f, args.output_folder, args.train_split, args.token)
    else:
        print(f'The input provided is neither a folder nor a file: {args.input}')


if __name__ == '__main__':
    args = parse_args()
    main(args)
