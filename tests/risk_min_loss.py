from __future__ import division
import torch
import torch.nn as nn
import torch.nn.functional as F


class Cast(nn.Module):
    """
    Basic layer that casts its input to a specific data type. The same tensor
    is returned if the data type is already correct.
    """

    def __init__(self, dtype):
        super(Cast, self).__init__()
        self._dtype = dtype

    def forward(self, x):
        return x.to(self._dtype)


class LabelSmoothingLoss(nn.Module):
    """
    With label smoothing,
    KL-divergence between q_{smoothed ground truth prob.}(w)
    and p_{prob. computed by model}(w) is minimized.
    """
    def __init__(self, label_smoothing, tgt_vocab_size, ignore_index=-100):
        assert 0.0 < label_smoothing <= 1.0
        self.ignore_index = ignore_index
        super(LabelSmoothingLoss, self).__init__()

        smoothing_value = label_smoothing / (tgt_vocab_size - 2)
        one_hot = torch.full((tgt_vocab_size,), smoothing_value)
        one_hot[self.ignore_index] = 0
        self.register_buffer('one_hot', one_hot.unsqueeze(0))

        self.confidence = 1.0 - label_smoothing

    def forward(self, output, target):
        """
        output (FloatTensor): batch_size x n_classes
        target (LongTensor): batch_size
        """
        model_prob = self.one_hot.repeat(target.size(0), 1)
        model_prob.scatter_(1, target.unsqueeze(1), self.confidence)
        model_prob.masked_fill_((target == self.ignore_index).unsqueeze(1), 0)

        return F.kl_div(output, model_prob, reduction='sum')


class IRMLoss(LabelSmoothingLoss):
    """
    Invariant Risk Minimization (Arjovsky et al. 2019)
    
    Given a set of training environments (datasets), loss is the sum of 
    regularised loss on each environment. The regularisation is designed to 
    induce a predictor that is invariant to environment-specific features, 
    to improve generalisation.

    This class implements the regularised loss for one dataset. The 
    sum over datasets must be computed elsewhere.
    """
    def __init__(self, num_envs, penalty_weight, penalty_anneal_steps,
        label_smoothing, tgt_vocab_size, ignore_index=-100, device="cpu"):
        super(IRMLoss, self).__init__(label_smoothing, tgt_vocab_size, 
            ignore_index=ignore_index)
        self.device = device
        self.num_envs = num_envs
        self.penalty_weight = penalty_weight
        self.penalty_anneal_steps = penalty_anneal_steps
        self.step = 0  # TODO for scheduling penalty weight
        # Create partial generator assuming no copy_attn and softmax
        # Outputs passed to forward() will already be logits
        self.generator = nn.Sequential(
            Cast(torch.float32),
            nn.LogSoftmax(dim=-1)
        )

    def base_loss(self, logits, target):
        # Base loss function takes probabilities as input
        # prob = self.generator(logits)
        # return super(IRMLoss, self).forward(prob, target)
        # TODO restore to above
        # For testing CMNIST example
        return torch.nn.functional.binary_cross_entropy_with_logits(logits, target)

    def penalty(self, logits, target):
        # Dummy classifier model
        scale = torch.tensor(1.).to(self.device).requires_grad_()
        # Map from logits to loss via classifier
        scaled_logits = logits * scale
        loss = self.base_loss(scaled_logits, target)
        # Compute gradient of loss w.r.t. classifier
        grad = torch.autograd.grad(loss, [scale], create_graph=True)[0]
        # Penalty is squared norm of gradients
        return torch.sum(grad**2)

    def get_penalty_weight(self):
        # TODO try other scheduling functions
        # Step-change schedule for penalty weighting
        return (self.penalty_weight 
            if self.step >= self.penalty_anneal_steps else 1.0)

    def forward(self, logits, target):
        loss = self.base_loss(logits, target).clone()
        penalty = self.penalty(logits, target)
        # TODO remove
        print("actual penalty", penalty)
        penalty_weight = self.get_penalty_weight()
        loss += penalty_weight * penalty
        if penalty_weight > 1.0:
            # Rescale the entire loss to keep gradients in a reasonable range
            loss /= penalty_weight
        # Normalise to give average over environments when summed later
        loss /= self.num_envs
        return loss


if __name__ == '__main__':
    # torch.manual_seed(20200305)

    # train_steps = 5
    # num_envs = 2
    # penalty_weight = 10000.0
    # penalty_steps = 3
    # label_smoothing = 0.1
    # batch_size = 4
    # tgt_vocab_size = 5
    # criterion = IRMLoss(num_envs, penalty_weight, penalty_steps, 
    #     label_smoothing, tgt_vocab_size, ignore_index=-1)

    # for _ in range(train_steps):
    #     scores = 5. + 3. * torch.randn(batch_size, tgt_vocab_size)
    #     gtruth = torch.empty(batch_size, dtype=torch.long).bernoulli_(p=0.5)
    #     loss = criterion(scores, gtruth)
    #     print(loss)
    #     criterion.step += 1

    # CMNIST
    logits = torch.Tensor([
        [
            [[ 10.3747], [-13.2813], [ 13.6204]],
            [[-11.2135], [  9.9567], [-12.1133]],
        ],
        [
            [[ 11.7400], [-13.7171], [ 14.6639]],
            [[-11.6892], [ 10.8570], [-12.5615]],
        ],
    ])
    targets = torch.Tensor([
        [
            [[1], [0], [1]],
            [[0], [1], [0]],
        ],
        [
            [[1], [0], [1]],
            [[0], [1], [0]], 
        ],

    ])
    true_penalties = torch.Tensor([
        [
            1.4635e-08,
            5.2920e-08,
        ],
        [
            1.4924e-09,
            1.3743e-08,
        ],
    ])
    true_loss = torch.Tensor([
        1.6782e-05,
        8.2952e-09,
    ])

    train_steps = 2
    num_envs = 2
    penalty_weight = 10000.0
    penalty_steps = 1
    label_smoothing = 0.1
    batch_size = 3
    tgt_vocab_size = 1
    criterion = IRMLoss(num_envs, penalty_weight, penalty_steps, 
        label_smoothing, tgt_vocab_size, ignore_index=-1)
    
    for step in range(train_steps):
        print("\nstep", step)
        total_loss = 0.
        for env in range(num_envs):
            print("env", env)
            print("true penalty", true_penalties[step, env])
            loss = criterion(logits[step, env], targets[step, env])
            print("env loss", loss)
            total_loss += loss
        criterion.step += 1
        print("true loss", true_loss[step])
        print(total_loss)

'''
# before penalty step up (50)

====

tensor([[ 9.1161],
        [ 7.8235],
        [12.4232]], grad_fn=<AddmmBackward>)
tensor([[1.],
        [1.],
        [1.]])
tensor([[-8.1500],
        [ 9.5855],
        [-7.6368]], grad_fn=<AddmmBackward>)
tensor([[0.],
        [1.],
        [0.]])
tensor(1.9430e-06, grad_fn=<SumBackward0>) # env0 penalty
tensor(4.9770e-06, grad_fn=<SumBackward0>) # env1 penalty
tensor(0.2406, grad_fn=<AddBackward0>) # overall weighted loss

====

tensor([[ 10.3747],
        [-13.2813],
        [ 13.6204]], grad_fn=<AddmmBackward>)
tensor([[1.],
        [0.],
        [1.]])
tensor([[-11.2135],
        [  9.9567],
        [-12.1133]], grad_fn=<AddmmBackward>)
tensor([[0.],
        [1.],
        [0.]])
tensor(1.4635e-08, grad_fn=<SumBackward0>)
tensor(5.2920e-08, grad_fn=<SumBackward0>)
tensor(1.6782e-05, grad_fn=<AddBackward0>)

====

# after penalty step up (100)

====

tensor([[7.2625],
        [6.7215],
        [9.6973]], grad_fn=<AddmmBackward>)
tensor([[1.],
        [1.],
        [1.]])
tensor([[-6.5572],
        [ 7.7701],
        [-6.2575]], grad_fn=<AddmmBackward>)
tensor([[0.],
        [1.],
        [0.]])
tensor(2.1078e-05, grad_fn=<SumBackward0>)
tensor(6.6927e-05, grad_fn=<SumBackward0>)
tensor(5.6498e-05, grad_fn=<DivBackward0>)

====

====

tensor([[ 11.7400],
        [-13.7171],
        [ 14.6639]], grad_fn=<AddmmBackward>)
tensor([[1.],
        [0.],
        [1.]])
tensor([[-11.6892],
        [ 10.8570],
        [-12.5615]], grad_fn=<AddmmBackward>)
tensor([[0.],
        [1.],
        [0.]])
tensor(1.4924e-09, grad_fn=<SumBackward0>)
tensor(1.3743e-08, grad_fn=<SumBackward0>)
tensor(8.2952e-09, grad_fn=<DivBackward0>)

====

'''
