#!/usr/bin/env python3
import argparse
import os


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', type=str, default=None,
                        help='Name of the task')
    parser.add_argument('-f', '--folder', type=str, default=None,
                        help='Base folder of the dataset')
    parser.add_argument('-o', '--output_path', type=str, default=None,
                        help='Output path')
    args = parser.parse_args()

    return args


def merge_files(files, f_type, output_folder):
    files_to_merge = [f for f in files if f_type in f]

    if len(files_to_merge) == 0:
        return

    print('Merging...', sorted(files_to_merge))

    for i, file_ in enumerate(sorted(files_to_merge)):
        with open(file_, 'r') as f:
            lines = f.readlines()
        
        mode = 'w' if i == 0 else 'a'
        with open(os.path.join(output_folder, 'merged_'+f_type+'.txt'), mode) as f:
            f.writelines(lines)


def main(args):
    files = []

    for dirpath, _, filenames in os.walk(os.path.abspath(args.folder)):
        for filename in [f for f in filenames if f.endswith(".txt") and args.input in f]:
            files.append(os.path.abspath(os.path.join(dirpath, filename)))

    output_folder = os.path.abspath(args.output_path)
    merge_files(files, 'src_train', output_folder)
    merge_files(files, 'tgt_train', output_folder)
    merge_files(files, 'src_valid', output_folder)
    merge_files(files, 'tgt_valid', output_folder)
    merge_files(files, 'src_test', output_folder)
    merge_files(files, 'tgt_test', output_folder)


if __name__ == '__main__':
    args = parse_args()
    main(args)
