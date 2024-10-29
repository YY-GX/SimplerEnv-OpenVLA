import os

import numpy as np
import tensorflow as tf

from simpler_env.evaluation.argparse import get_args
from simpler_env.evaluation.maniskill2_evaluator import maniskill2_evaluator
from simpler_env.policies.octo.octo_server_model import OctoServerInference
from simpler_env.policies.rt1.rt1_model import RT1Inference
from simpler_env.policies.openvla.openvla_model import OpenVLAInference
import random
import numpy as np
import torch
import tensorflow as tf


try:
    from simpler_env.policies.octo.octo_model import OctoInference
except ImportError as e:
    print("Octo is not correctly imported.")
    print(e)



def set_random_seed(seed):
    """
    Set the random seed for reproducibility across different libraries.

    Args:
        seed (int): The seed value to set for randomness.
    """
    # Set seed for Python's built-in random module
    random.seed(seed)

    # Set seed for NumPy
    np.random.seed(seed)

    # Set seed for PyTorch
    torch.manual_seed(seed)  # CPU
    if torch.cuda.is_available():
        torch.cuda.manual_seed(seed)  # GPU
        torch.cuda.manual_seed_all(seed)  # All GPUs

    # Set seed for TensorFlow
    tf.random.set_seed(seed)

    # # Optionally, you can set additional flags for PyTorch if needed
    # torch.backends.cudnn.deterministic = True
    # torch.backends.cudnn.benchmark = False

    print(f"Random seed set to {seed} for all relevant libraries.")


# Example usage
set_random_seed(42)

if __name__ == "__main__":
    args = get_args()

    os.environ["DISPLAY"] = ""
    # prevent a single jax process from taking up all the GPU memory
    os.environ["XLA_PYTHON_CLIENT_PREALLOCATE"] = "false"
    gpus = tf.config.list_physical_devices("GPU")
    if len(gpus) > 0:
        # prevent a single tf process from taking up all the GPU memory
        tf.config.set_logical_device_configuration(
            gpus[0],
            [tf.config.LogicalDeviceConfiguration(memory_limit=args.tf_memory_limit)],
        )
    print(f"**** {args.policy_model} ****")

    # set random seed - added by yy
    set_random_seed(args.seed)

    # policy model creation; update this if you are using a new policy model
    if args.policy_model == "rt1":
        assert args.ckpt_path is not None
        model = RT1Inference(
            saved_model_path=args.ckpt_path,
            policy_setup=args.policy_setup,
            action_scale=args.action_scale,
        )
    elif "octo" in args.policy_model:
        if args.ckpt_path is None or args.ckpt_path == "None":
            args.ckpt_path = args.policy_model
        if "server" in args.policy_model:
            model = OctoServerInference(
                model_type=args.ckpt_path,
                policy_setup=args.policy_setup,
                action_scale=args.action_scale,
            )
        else:
            model = OctoInference(
                model_type=args.ckpt_path,
                policy_setup=args.policy_setup,
                init_rng=args.octo_init_rng,
                action_scale=args.action_scale,
            )
    elif args.policy_model == "openvla":
        assert args.ckpt_path is not None
        model = OpenVLAInference(
            saved_model_path=args.ckpt_path,
            policy_setup=args.policy_setup,
            action_scale=args.action_scale,
        )
    else:
        raise NotImplementedError()

    # run real-to-sim evaluation
    success_arr = maniskill2_evaluator(model, args)
    print(args)
    print(" " * 10, "Average success", np.mean(success_arr))
