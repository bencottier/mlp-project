# Improving Extrapolation in Neural Mathematical Reasoning

## Abstract

- [Recent work](https://arxiv.org/abs/1904.01557) applying neural networks to mathematical reasoning shows “interpolation” data (statistics inside the range of the training data) is much easier than “extrapolation” data (statistics far outside the training range).
- However the extrapolation is straightforward mathematically, e.g. increasing the magnitude of numbers, and thus seems feasible to solve. This work aims to understand and address the performance gap.
- We used worded mathematics problems from the [DeepMind mathematics dataset](https://github.com/deepmind/mathematics_dataset) (just the modules that have a corresponding extrapolation test set) using a conventional Transformer architecture.
- Our baseline character-level model, based directly on prior work, achieves 44% exact-match accuracy on an interpolation set and 27% on extrapolation, a gap of 17%.
- Simply by parsing words as whole units instead of characters, we improve this to 58% and 39% respectively, though the gap increases to 18%.
- Adding [Invariant Risk Minimisation](https://arxiv.org/abs/1907.02893) (IRM), a method to improve generalisation, reduces the gap to 15%. However, accuracy worsens to 52% and 37% respectively. It remains uncertain whether IRM operated as intended. Since it is a very new approach, more work is needed to understand "best practice", and adapt it to this domain.

## Content

This repository consists mostly of:

- Configuration files (`config` folder) and scripts (`scripts` folder) for use with the [OpenNMT-Py](https://github.com/OpenNMT/OpenNMT-py) API.
- Scripts and notebooks for pre- and post-processing the data and results.

## Linked repositories

[OpenNMT-Py](https://github.com/filippoferrari/OpenNMT-py). Fork of OpenNMT-Py implementing [invariant risk minimization](https://arxiv.org/abs/1907.02893) via gradient accumulation.

[OpenNMT_visual-py](https://github.com/ashwanitanwar/OpenNMT_visual-py). Implements attention visualisation.

