
## 2020.01.06

Installing mathematics dataset

- Example generate command: `python -m mathematics_dataset.generate --filter=linear_1d`
- Get an error from `python -m mathematics_dataset.generate`:
    ```
    train/calculus__differentiate_composed
    Traceback (most recent call last):
    File "/home/ben/miniconda3/envs/nlp/lib/python3.7/site-packages/sympy/core/compatibility.py", line 419, in as_int
        raise TypeError
    TypeError

    During handling of the above exception, another exception occurred:
    ...
    ```
    - `sympy` is 1.5.1, their `setup.py` says `sympy>=1.2`
        - Downgraded to 1.2
        - Now it works

## 2020.01.08

How does BERT work?

- Some or all of it is an encoder. It encodes a sequence of tokens into some tensor.
- Maybe the decoder is the part that is fine-tuned and the encoder is just the pretrained part that ships

Is `transformers` the right library?

- So far isn't really meant for "seq2seq" tasks, which is what we're doing here
- `fairseq` is for seq2seq but gets a worse wrap

https://github.com/pytorch/fairseq/blob/master/fairseq/tasks/translation.py

## 2020.01.09

`fairseq` translation example

- Read through it. It extends the general training API so it's not what I was looking for.

Installing `fairseq` from source so we can use examples

Executing "training a new model" preprocessing

- https://fairseq.readthedocs.io/en/latest/getting_started.html#training-a-new-model
- Preprocessing looks complicated
- I need to know what the final format should be, and how I can get there
    - The mathematics dataset repo may have insight
    - They have a pregenerated data tar
    - Files are `.txt`

Preprocessing math data

- Use `fairseq-preprocess` to pre-process and binarise text files, e.g.

```
fairseq-preprocess \
--trainpref math/train-easy --validpref math/valid-easy --testpref math/interpolate \
--source-lang question --target-lang answer \
--destdir math-bin --dataset-impl raw
```

- Character-level example: https://fairseq.readthedocs.io/en/latest/tutorial_classifying_names.html
    - Data space-separates the characters. Will we be able to do this? We want spaces to be recognised, but for the model to still be character-level.
- Tentative plan to preprocess math data
    - Original file format is `difficulty/subject.txt`
    - Each `.txt` has a series of pairs of lines of text. First line in pair is question - space-separated words. Second line in pair is answer - space-separated words (not sure if it's ever more than one word).
    - Separate out questions from answers
        - Read each text file line-by-line
        - Every first line written to source file
        - Every second line written to target file
    - Prepare for tokenization
        - Space-separate
    - Tokenize
    - Organise the data files
    - Access the data files (e.g. by subclassing `FairseqTask`)

How to build upon original work

- Use multi-modal data: Tokenise English by words, but symbols by characters

## 2020.01.17

Ideas

- It's common to use pretrained word embeddings, or at least train an embedding as the first module of the model. What can we do with math embeddings? Is an Embedding module already part of standard architectures?

Learning

- Attention
    - Focus on a particular part of the input at a given step of the forward pass
    - Encoder passes every hidden state to the decoder, rather than just the last one
    - For each decoder step, a weight (softmaxed attention score) is assigned to each hidden state
    - The context vector for a decoder step is the weighted sum of encoder hidden states
    - Multi-headed: expands ability to focus on different positions, and gives multiple "representation subspaces"

Mechanics

- We can guarantee that spaces are included in the character tokenisation by converting them to underscores

## 2020.01.19

Spinning up a minimal working example with OpenNMT

- Preprocess
    - OpenNMT command default
        ```
        onmt_preprocess -train_src data/src-train.txt -train_tgt data/tgt-train.txt -valid_src data/src-val.txt -valid_tgt data/tgt-val.txt -save_data data/demo
        ```
    - Split our data
        ```
        python split_dataset.sh
        ```
    - SRC file is ~19 MiB, TGT file is ~1.6 MiB
    - Modifying `split_dataset.py` to further split into train and valid
    - Adapting preprocess command
        ```
        onmt_preprocess -train_src data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_src_train.txt -train_tgt data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_tgt_train.txt -valid_src data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_src_valid.txt -valid_tgt data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_tgt_valid.txt -save_data data/demo/demo
        ```
        - Executed
    - Ok we also should add the option for character-level split in the script. Or it might be a good idea to write a separate script that overwrites the files.
        - Underscores for spaces: `line = line.replace(' ', '_')`
        - Space separation: `line = ' '.join(line)`
        - The above ops do not affect single-character lines
- Training
    - OpenNMT command default
        ```
        onmt_train -data data/demo -save_model demo-model
        ```
    - Our command
        ```
        onmt_train -data data/demo/demo -save_model demo-model -train_steps 250
        ```
- Inference
    - OpenNMT command default
        ```
        onmt_translate -model demo-model_XYZ.pt -src data/src-test.txt -output pred.txt -replace_unk -verbose
        ```
    - Our command
        ```
        onmt_translate -model demo-model_step_250.pt -src data/mathematics_dataset-v1.0/interpolate-split/algebra__linear_1d_src_test.txt -output data/demo/pred.txt -replace_unk -verbose
        ```
    - 1000 step model: predicts 4 every time!
    - 250 step model: predicts 3 every time!
        - 3 is only about 7% of the validation set answers.
    - Either it needs more training, or it's not working at all.

## 2020.01.23

Diagnosing degenerate model

- Last time we found with a default command that the model (apparently) learns a degenerate solution of the same output (a single digit) no matter what the input is.
- Possible causes
    - The data is not being preprocessed as expected (e.g. character-level tokens)
    - Overfitting / model too large
        - But how could it achieve ~55% training accuracy with the same single digit?
    - Something wrong with transfer to the test/inference regime
        - Is the data in the same format?
        - It would be good to see input/output examples during training, to check that it is in fact outputting the same digit
- Unknowns
    - Whether the stdout for training report training or validation accuracy
        - Most likely training, because validation is reported at end of epoch (but how is an epoch defined? The number of epochs argument is deprecated)
            - Use `-valid_steps` argument: perform validation every X steps
- The first thing I'm going to try is a smaller model. The model previously used was ~10M parameters, which I think is very excessive relative to the single file of training data.
    - Assume each model parameter is FP32 -> 4 bytes. `algebra__linear_1d_src_train.txt` is 35770113 bytes. To memorise the data you thus need ~9M parameters.
    - Reducing RNN hidden states size from 500 to 50, which reduces to 300k parameters.
    - I think a critical oversight I may have had is just how few training steps were performed. Sounds like training batch size is dynamic with "sents"---sentences?---but validation batch size is 32. So 250 steps is not nearly enough to cover 600k samples (600k/32 = 18750)
    - Now trying 10k train steps with validation every 1k steps.
        - Validation accuracy % is (46 vs. 64) then (60 vs. 62) then (62 vs 62). So if this model ends up still outputting the same digit, the accuracy metric is not doing what I think it's doing.
        - Yep, tested inference on checkpoint 5000 and it always outputs 2.
        - Woah, hang on a tick. **Checkpoint 10000 outputs different digits!**
        - So it initially learns to output the same digit, then diversifies? I've never seen that kind of learning. From experience with image generation nets, once it learns to output the same thing every time there's no hope. Maybe outputting the same digit is just a product of the parameters still being somewhat random and small from initialisation? I need to understand sequence models better...
        - 5000 performance: `PRED AVG SCORE: -2.1865, PRED PPL: 8.9042`
        - 10000 performance: `PRED AVG SCORE: -2.0108, PRED PPL: 7.4691`
        - 15000: `PRED AVG SCORE: -1.7671, PRED PPL: 5.8539`
            - Validation accuracy 54%
        - 20000: `PRED AVG SCORE: -1.9983, PRED PPL: 7.3768`
            - Validation accuracy 68%, yet worse...
        - Although the output diversifies, it still doesn't show any sign of understanding the input (i.e. getting correct answers). This highlights the need to change the performance metrics to suit the task, and/or change the preprocessing.
- Is it because there are start and end tokens, and they are included in the accuracy? Or perhaps the space character is included?
    - The inference predictions in `pred.txt` don't have any whitespace
- It would be insightful to try a set of problems that require longer answers!
    - In DeepMind paper, `calculus__differentiate` is one of the best-performing: P(correct) ~= 93% for Simple LSTM. It has long answers with symbols, e.g. `8*d**3 - 70*d`
- We need to look into how accuracy is measured, because it is clearly not what we expect. Is there a way to have custom metrics?

Next

- Try `calculus__differentiate` data

## 2020.01.24

Reviewing `calculus__differentiate` size 100 model

- Latest checkpoint 85000
- It has learned syntax well
- Occasionally it produces an answer with partial mathematical correctness
    - The correctness is more in terms of getting some of the correct digits in order, but producing too few digits (based on BLEU evaluation, length ratio is very low, e.g. ~20% at step 85000)
        - **Length ratio was due to a mismatch in the BLEU command; ignore**
    - Made up example to illustrate the kind of thing it does: `Differentiate 814530*x**2 -> 16291*x`. So it does some kind of doubling of the coefficient, but misses some of the digits.
- Run BLEU evaluation
    ```
    perl /home/ben/projects/nlp/OpenNMT-py/tools/multi-bleu.perl <path/to/reference/file> < <path/to/prediction/file>
    ```
- Create smaller validation data (1000 lines)
    ```
    head -1000 data/mathematics_dataset-v1.0/train-easy-split/calculus__differentiate_tgt_valid.txt > data/mathematics_dataset-v1.0/train-easy-split/calculus__differentiate_tgt_valid_1000.txt
    ```
- We don't think `omnt-translate` compares to the test answers - you don't specify a reference file. It just computes the model's log likelihood (PRED SCORE) and perplexity (PPL)
- We ran the BLEU Perl command wrong -- mismatching src with tgt. It turns out that BLEU is pretty good relative to the amount of training and model size. So we are basically ready to run on the cluster!
