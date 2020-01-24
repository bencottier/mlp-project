# MLP Project Notes

## High-level plan

Initial thoughts

- The first step that we can reliably take, regardless of our idea, is to reproduce the experiment of [Saxton et al.](https://arxiv.org/abs/1904.01557)
    - We don't have to get as-good results, but at least a respectable baseline for our own purposes
    - If we are struggling to model the full dataset we can resort to the `easy` folder, or specific maths subjects that Saxton et al. got the highest accuracy on
    - Start with a minimal working example: just get the preprocessing right, then train some small, default seq2seq model, and iterate until we can get the accuracy up to at least 10%

Baseline

- Write script to separate a text file from the mathematics dataset into two files: questions and answers.
- Run OpenNMT preprocess command to preprocess (e.g. tokenize, binarize?) the question and answer files as input and output
- Run OpenNMT train command locally
    - Transformer architecture
    - Initially, a small model size
    - Check for errors and debug
    - Once debugged, run for a while to see if accuracy improves over time
- Write Slurm script for training
    - Understand the available resources and write SBATCH commands at the top
    - Understand file system sync and write rsync commands to transfer data to and from worker nodes, back up persistent data
    - Add OpenNMT train command
- Transfer files to cluster and execute initial experiment
    - Initially smaller model, trained for a moderate time (a few hours?)
    - Assess the performance of the smaller model, debug if necessary
    - Train a larger model for a long time (a day?)

## Ideas

- Probing embeddings
    - E.g. pick a problem with (x + y) and a problem with, say, (x + y) * z, and look at how the embeddings (e.g. encoder output) relate

Ben's

- It's common to use pretrained word embeddings, or at least train an embedding as the first module of the model. What can we do with math embeddings? Is an Embedding module already part of standard architectures?
- Explore further how strength-by-subject distribution varies with model architecture - e.g. can we get outsized performance on a narrow domain by making large changes to the architecture?
- Tokenise English words as whole words, and math symbols as characters
- Use similar techniques to "BERTology" to understand the mathematical reasoning occurring
- Apply a simple decomposition, use iterated distillation and amplification on it
- Try Neural Module Networks
- Put expressions in SymPy to simplify intermediate steps.
- Apply DeepDream to the model: what question maximises a given answer?

Meeting 17/1

- Linguistic aspects of questions e.g. full-stop
    - Train an LM on some other corpus, transfer to this dataset
- Distinguish maths operators from non-maths operators
- Embeddings of symbols
- POS tags on the English
- Just train on the maths
    - Same output label? If so, there are problems where you can't distinguish the task
    - Unsupervised or semi-supervised method: train on simplification steps e.g. feed expression into SymPy, do some operation to get a new expression, and train on the pair of expressions
- Curriculum learning
    - Sort the training data by difficulty
- Embeddings tell you about interpolation vs. extrapolation
- Use knowledge graph with mathematical reasoning. Get model to consult that knowledge graph. 
- Iterated distillation and amplification
    - Decompose maths into subproblems

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
