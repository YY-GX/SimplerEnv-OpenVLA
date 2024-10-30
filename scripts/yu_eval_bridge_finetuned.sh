#!/bin/zsh

# Declare additional variables
declare -a coke_can_options_arr=("lr_switch=True" "upright=True" "laid_vertically=True")
declare -a urdf_version_arr=(None "recolor_tabletop_visual_matching_1" "recolor_tabletop_visual_matching_2" "recolor_cabinet_visual_matching_1")
urdf_version=${urdf_version_arr[0]} # Defaulting to None if not defined earlier
policy_model="openvla" # Ensure you set this to the correct value



gpu_id=4
ckpt_path="/mnt/bum/yufang/projects/openvla/runs/1.0.3/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--image_aug--1000_chkpt"
ckpt_path="/mnt/bum/yufang/projects/openvla/runs/1.0.3/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--image_aug--4000_chkpt"



set_1=(
    "PutCarrotOnPlateInScene-v0"
    "StackGreenCubeOnYellowCubeBakedTexInScene-v0"
    "PutSpoonOnTableClothInScene-v0"
    "PutEggplantInBasketScene-v0"
)
seeds=(0 1 2 3 4)


scene_name=bridge_table_1_v1
for seed in "${seeds[@]}"; do
  for env_name in "${set_1[@]}"; do
    if [[ "$env_name" == "PutEggplantInBasketScene-v0" ]]; then
      robot=widowx_sink_camera_setup
      robot_init_x=0.127
      robot_init_y=0.06
      overlay_img_list=("ManiSkill2_real2sim/data/real_inpainting/bridge_sink.png")
      CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --my_folder "evaluate_on_finetuned_openvla" --policy-model ${policy_model} --ckpt-path ${ckpt_path} \
      --robot ${robot} --policy-setup widowx_bridge \
      --control-freq 5 --sim-freq 500 --max-episode-steps 120 \
      --env-name ${env_name} --scene-name ${scene_name} \
      --robot-init-x ${robot_init_x} ${robot_init_x} 1 --robot-init-y ${robot_init_y} ${robot_init_y} 1 --obj-episode-range 0 24 \
      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 --overlay_img_ls "${overlay_img_list[@]}"  \
      --seed "$seed";  # Pass the seed as an argument
    else
      robot=widowx
      robot_init_x=0.147
      robot_init_y=0.028
      overlay_img_list=("ManiSkill2_real2sim/data/real_inpainting/bridge_sink.png")
      CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --my_folder "evaluate_on_finetuned_openvla" --policy-model ${policy_model} --ckpt-path ${ckpt_path} \
      --robot ${robot} --policy-setup widowx_bridge \
      --control-freq 5 --sim-freq 500 --max-episode-steps 120 \
      --env-name ${env_name} --scene-name ${scene_name} \
      --robot-init-x ${robot_init_x} ${robot_init_x} 1 --robot-init-y ${robot_init_y} ${robot_init_y} 1 --obj-episode-range 0 24 \
      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 --overlay_img_ls "${overlay_img_list[@]}"  \
      --seed "$seed";  # Pass the seed as an argument
    fi
  done
done
