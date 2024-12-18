#!/bin/zsh

# Declare additional variables
declare -a coke_can_options_arr=("lr_switch=True" "upright=True" "laid_vertically=True")
declare -a urdf_version_arr=(None "recolor_tabletop_visual_matching_1" "recolor_tabletop_visual_matching_2" "recolor_cabinet_visual_matching_1")
urdf_version=${urdf_version_arr[0]} # Defaulting to None if not defined earlier
policy_model="openvla" # Ensure you set this to the correct value



gpu_id=3
ckpt_path="/mnt/bum/yufang/projects/openvla/runs/1.0.3/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--image_aug--1000_chkpt"
ckpt_path="/mnt/bum/yufang/projects/openvla/runs/1.0.3-v2/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--image_aug--4000_chkpt"
ckpt_path="/mnt/bum/yufang/projects/openvla/runs/1.0.3-v2/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--4000_chkpt"


set_5=(
    "MoveNearGoogleBakedTexInScene-v0"
)
seeds=(0 1 2 3 4)

scene_name=google_pick_coke_can_1_v4
for seed in "${seeds[@]}"; do
  for env_name in "${set_5[@]}"; do
      overlay_img_list=("./ManiSkill2_real2sim/data/real_inpainting/google_move_near_real_eval_1.png")
      CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --my_folder "evaluate_on_finetuned_openvla" --policy-model openvla --ckpt-path ${ckpt_path} \
      --robot google_robot_static \
      --control-freq 3 --sim-freq 513 --max-episode-steps 120 \
      --env-name ${env_name} --scene-name ${scene_name} \
      --robot-init-x 0.35 0.35 1 --robot-init-y 0.21 0.21 1 --obj-episode-range 0 60 \
      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 -0.09 -0.09 1 \
      --additional-env-build-kwargs urdf_version=${urdf_version} \
      --additional-env-save-tags baked_except_bpb_orange --overlay_img_ls "${overlay_img_list[@]}" \
      --seed "$seed";  # Pass the seed as an argument
  done
done

