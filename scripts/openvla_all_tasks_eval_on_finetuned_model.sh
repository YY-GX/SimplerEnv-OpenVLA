#!/bin/bash
# Declare GPU IDs for each set
declare -a gpu_ids=(0 1 2 3 4)

# Declare environment names
#declare -a arr=("openvla/openvla-7b")
#declare -a env_names=(
#    PutCarrotOnPlateInScene-v0
#    StackGreenCubeOnYellowCubeBakedTexInScene-v0
#    PutSpoonOnTableClothInScene-v0
#    PutEggplantInBasketScene-v0
#    PlaceIntoClosedTopDrawerCustomInScene-v0
#    PlaceIntoClosedMiddleDrawerCustomInScene-v0
#    PlaceIntoClosedBottomDrawerCustomInScene-v0
#    GraspSingleOpenedCokeCanInScene-v0
#    OpenTopDrawerCustomInScene-v0
#    OpenMiddleDrawerCustomInScene-v0
#    OpenBottomDrawerCustomInScene-v0
#    CloseTopDrawerCustomInScene-v0
#    CloseMiddleDrawerCustomInScene-v0
#    CloseBottomDrawerCustomInScene-v0
#    MoveNearGoogleBakedTexInScene-v0
#)

# Declare additional variables
declare -a coke_can_options_arr=("lr_switch=True" "upright=True" "laid_vertically=True")
declare -a urdf_version_arr=(None "recolor_tabletop_visual_matching_1" "recolor_tabletop_visual_matching_2" "recolor_cabinet_visual_matching_1")
urdf_version=${urdf_version_arr[0]} # Defaulting to None if not defined earlier
policy_model="openvla" # Ensure you set this to the correct value
#@Yu: ckpt_path is where you wanna to replace
#ckpt_path="openvla/openvla-7b"
#ckpt_path="/mnt/bum/yufang/projects/openvla/runs/coke/openvla-7b+droid+b8+lr-0.0005+lora-r32+dropout-0.0"
#ckpt_path="/mnt/bum/yufang/projects/openvla/runs/coke-long/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--image_aug/step2000"
#ckpt_path="/mnt/bum/yufang/projects/openvla/runs/coke-long/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0/step2000"
ckpt_path="/mnt/bum/yufang/projects/openvla/runs/1.0.3/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--image_aug--1000_chkpt"
#ckpt_path="/mnt/bum/yufang/projects/openvla/runs/1.0.3/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--1000_chkpt"

# Define each set of environment names
set_1=(
    "PutCarrotOnPlateInScene-v0"
    "StackGreenCubeOnYellowCubeBakedTexInScene-v0"
    "PutSpoonOnTableClothInScene-v0"
    "PutEggplantInBasketScene-v0"
)

set_2=(
    "PlaceIntoClosedTopDrawerCustomInScene-v0"
    "PlaceIntoClosedMiddleDrawerCustomInScene-v0"
    "PlaceIntoClosedBottomDrawerCustomInScene-v0"
)

set_3=(
    "GraspSingleOpenedCokeCanInScene-v0"
)

set_4=(
    "OpenTopDrawerCustomInScene-v0"
    "OpenMiddleDrawerCustomInScene-v0"
    "OpenBottomDrawerCustomInScene-v0"
    "CloseTopDrawerCustomInScene-v0"
    "CloseMiddleDrawerCustomInScene-v0"
    "CloseBottomDrawerCustomInScene-v0"
)

set_5=(
    "MoveNearGoogleBakedTexInScene-v0"
)


## Start each set in parallel
## Set 1
#(
#  scene_name=bridge_table_1_v1
#  for env_name in "${set_1[@]}"; do
#    if [[ "$env_name" == "PutEggplantInBasketScene-v0" ]]; then
#      robot=widowx_sink_camera_setup
#      robot_init_x=0.127
#      robot_init_y=0.06
#      overlay_img_list=("ManiSkill2_real2sim/data/real_inpainting/bridge_sink.png")
#      CUDA_VISIBLE_DEVICES=0 python simpler_env/main_inference.py --policy-model ${policy_model} --ckpt-path ${ckpt_path} \
#      --robot ${robot} --policy-setup widowx_bridge \
#      --control-freq 5 --sim-freq 500 --max-episode-steps 120 \
#      --env-name ${env_name} --scene-name ${scene_name} \
#      --robot-init-x ${robot_init_x} ${robot_init_x} 1 --robot-init-y ${robot_init_y} ${robot_init_y} 1 --obj-episode-range 0 24 \
#      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 --overlay_img_ls "${overlay_img_list[@]}";
#    else
#      robot=widowx
#      robot_init_x=0.147
#      robot_init_y=0.028
#      overlay_img_list=("ManiSkill2_real2sim/data/real_inpainting/bridge_sink.png")
#      CUDA_VISIBLE_DEVICES=0 python simpler_env/main_inference.py --policy-model ${policy_model} --ckpt-path ${ckpt_path} \
#      --robot ${robot} --policy-setup widowx_bridge \
#      --control-freq 5 --sim-freq 500 --max-episode-steps 60 \
#      --env-name ${env_name} --scene-name ${scene_name} \
#      --robot-init-x ${robot_init_x} ${robot_init_x} 1 --robot-init-y ${robot_init_y} ${robot_init_y} 1 --obj-episode-range 0 24 \
#      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 --overlay_img_ls "${overlay_img_list[@]}";
#    fi
#  done
#) &
#
## Set 2
#(
#  scene_name=frl_apartment_stage_simple
#  for env_name in "${set_2[@]}"; do
#    overlay_img_list=("./ManiSkill2_real2sim/data/real_inpainting/open_drawer_a0.png" "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_b0.png" "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_c0.png")
#    CUDA_VISIBLE_DEVICES=1 python simpler_env/main_inference.py --policy-model openvla --ckpt-path ${ckpt_path} \
#    --robot google_robot_static \
#    --control-freq 3 --sim-freq 513 --max-episode-steps 200 \
#    --env-name ${env_name} --scene-name dummy_drawer \
#    --robot-init-x 0.644 0.644 1 --robot-init-y -0.179 -0.179 1 \
#    --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 -0.03 -0.03 1 \
#    --obj-init-x-range -0.08 -0.02 3 --obj-init-y-range -0.02 0.08 3 --enable-raytracing\
#    --additional-env-build-kwargs urdf_version="recolor_tabletop_visual_matching_1" station_name=mk_station_recolor light_mode=simple disable_bad_material=True model_ids=baked_apple_v2 --overlay_img_ls "${overlay_img_list[@]}";
#  done
#) &


# Set 3
(
  scene_name=google_pick_coke_can_1_v4
  for env_name in "${set_3[@]}"; do
    overlay_img_list=("./ManiSkill2_real2sim/data/real_inpainting/google_coke_can_real_eval_1.png")
#    @Yu: gpu id: CUDA_VISIBLE_DEVICES=3
    CUDA_VISIBLE_DEVICES=1 python simpler_env/main_inference.py --my_folder "evaluate_on_finetuned_models" --policy-model openvla --ckpt-path ${ckpt_path} \
    --robot google_robot_static \
    --control-freq 3 --sim-freq 513 --max-episode-steps 120 \
    --env-name ${env_name} --scene-name ${scene_name} \
    --robot-init-x 0.35 0.35 1 --robot-init-y 0.20 0.20 1 --obj-init-x -0.35 -0.12 5 --obj-init-y -0.02 0.42 5 \
    --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 \
    --additional-env-build-kwargs "${coke_can_options_arr[@]}" urdf_version=${urdf_version} --overlay_img_ls "${overlay_img_list[@]}";
  done
) &

## Set 4
#(
#  for env_name in "${set_4[@]}"; do
#    overlay_img_list=("./ManiSkill2_real2sim/data/real_inpainting/open_drawer_a0.png"
#                      "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_a1.png"
#                      "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_a2.png"
#                      "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_b0.png"
#                      "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_b1.png"
#                      "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_b2.png"
#                      "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_c0.png"
#                      "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_c1.png"
#                      "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_c2.png")
#    CUDA_VISIBLE_DEVICES=3 python simpler_env/main_inference.py --policy-model openvla --ckpt-path ${ckpt_path} \
#    --robot google_robot_static \
#    --control-freq 3 --sim-freq 513 --max-episode-steps 113 \
#    --env-name ${env_name} --scene-name dummy_drawer \
#    --robot-init-x 0.644 0.644 1 --robot-init-y -0.179 -0.179 1 \
#    --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 -0.03 -0.03 1 \
#    --obj-init-x-range 0 0 1 --obj-init-y-range 0 0 1 --enable-raytracing \
#    --additional-env-build-kwargs urdf_version=${urdf_version} station_name=mk_station_recolor light_mode=simple disable_bad_material=True --overlay_img_ls "${overlay_img_list[@]}";
#  done
#) &
#
## Set 5
#(
#  for env_name in "${set_5[@]}"; do
#  scene_name=google_pick_coke_can_1_v4
#      overlay_img_list=("./ManiSkill2_real2sim/data/real_inpainting/google_move_near_real_eval_1.png")
#      CUDA_VISIBLE_DEVICES=2 python simpler_env/main_inference.py --policy-model openvla --ckpt-path ${ckpt_path} \
#      --robot google_robot_static \
#      --control-freq 3 --sim-freq 513 --max-episode-steps 80 \
#      --env-name ${env_name} --scene-name ${scene_name} \
#      --robot-init-x 0.35 0.35 1 --robot-init-y 0.21 0.21 1 --obj-episode-range 0 60 \
#      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 -0.09 -0.09 1 \
#      --additional-env-build-kwargs urdf_version=${urdf_version} \
#      --additional-env-save-tags baked_except_bpb_orange --overlay_img_ls "${overlay_img_list[@]}";
#  done
#) &

# Wait for all background processes to finish
wait
