import torch

# path = 'data/demo/algebra__linear_1d/data.vocab.pt'
path = 'data/demo/calculus__differentiate/data.vocab.pt'
processors = torch.load(path)

for name in ['src', 'tgt']:
    processor = processors[name]
    vocab = processor.fields[0][1].vocab
    freqs = vocab.freqs
    total = sum(freqs.values())
    print(f'\n{name}\n')
    print('vocab freq-abs freq-rel')
    for tok, freq in sorted(freqs.items()):
        print(f'{tok:4}\t{freq:4}\t{freq / total:4.4f}')
