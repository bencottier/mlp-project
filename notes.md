# MLP Project Notes

## High-level plan

Thinking

- The first step that we can reliably take, regardless of our idea, is to reproduce the experiment of [Saxton et al.](https://arxiv.org/abs/1904.01557)
    - We don't have to get as-good results, but at least a respectable baseline for our own purposes
    - If we are struggling to model the full dataset we can resort to the `easy` folder, or specific maths subjects that Saxton et al. got the highest accuracy on
    - Start with a minimal working example: just get the preprocessing right, then train some small, default seq2seq model, and iterate until we can get the accuracy up to at least 10%

## Ideas

- Probing embeddings
    - E.g. pick a problem with (x + y) and a problem with, say, (x + y) * z, and look at how the embeddings (e.g. encoder output) relate

## Implementation

- We are happy with PyTorch as the base ML library
- Potential libraries to make life easier
    - [fairseq](https://github.com/pytorch/fairseq)
        - According to a Reddit user: slightly faster, more modular, more readable than OpenNMT
    - [OpenNMT](https://github.com/OpenNMT/OpenNMT-py)
        - Ashwani has experience
    - Both fairseq and OpenNMT sound good in terms of ease of debugging, and suitability for research

## Data and preprocessing 

- [Dataset](https://github.com/deepmind/mathematics_dataset)
- The raw data format is question-answer pairs, line by line, in the same file. To work with standard machine translation APIs we will need to separate the questions and answers into separate files.
    - Straightforward Python script should do this
- For character-level tokens, we need to investigate the right format for e.g. OpenNMT or fairseq
