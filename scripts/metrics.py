#!/usr/bin/python3
"""
metrics.py

Compute performance metrics on model predictions.
"""
import argparse
import nltk
import numpy as np


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-ref', type=str, default=None,
                        help='Reference filename: contains ground-truth sequences')
    parser.add_argument('-hyp', type=str, default=None,
                        help='Hypothesis filename: contains predicted sequences')
    args = parser.parse_args()

    return args


def main(ref_file, hyp_file):
    print(f'Reference file: {ref_file}')
    print(f'Hypothesis file: {hyp_file}')

    with open(ref_file, 'r') as f:
        ref_lines = f.readlines()

    with open(hyp_file, 'r') as f:
        hyp_lines = f.readlines()

    bleus = np.zeros(len(ref_lines))
    accs = np.zeros(len(ref_lines))
    for i, (ref_line, hyp_line) in enumerate(zip(ref_lines, hyp_lines)):
        ref = ref_line.strip().split(' ')
        refs = [ref]
        hyp = hyp_line.strip().split(' ')
        bleu = nltk.translate.bleu_score.sentence_bleu(refs, hyp)
        bleus[i] = bleu
        accs[i] = np.allclose(bleu, 1.0)
        # print(i)
        # print(ref)
        # print(hyp)
        # print(bleu)
        # print('')

    list_of_references = [[s.strip().split(' ')] for s in ref_lines]
    hypotheses = [s.strip().split(' ') for s in hyp_lines]
    corpus_bleu = nltk.translate.bleu_score.corpus_bleu(list_of_references, hypotheses)

    print(f'Average sentence BLEU: {bleus.mean():.4f}')
    print(f'Corpus BLEU: {corpus_bleu:.4f}')
    print(f'Average accuracy: {accs.mean():.4f}')


if __name__ == '__main__':
    args = parse_args()
    main(args.ref, args.hyp)
