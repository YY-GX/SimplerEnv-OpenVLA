#!/bin/bash

gpu_id=2
declare -a ckpt_paths=("openvla/openvla-7b")
declare -a env_names=(
    PutCarrotOnPlateInScene-v0
    StackGreenCubeOnYellowCubeBakedTexInScene-v0
    PutSpoonOnTableClothInScene-v0
    PutEggplantInBasketScene-v0
    PlaceIntoClosedTopDrawerCustomInScene-v0
    PlaceIntoClosedMiddleDrawerCustomInScene-v0
    PlaceIntoClosedBottomDrawerCustomInScene-v0
    GraspSingleOpenedCokeCanInScene-v0
    OpenTopDrawerCustomInScene-v0
    OpenMiddleDrawerCustomInScene-v0
    OpenBottomDrawerCustomInScene-v0
    CloseTopDrawerCustomInScene-v0
    CloseMiddleDrawerCustomInScene-v0
    CloseBottomDrawerCustomInScene-v0
    MoveNearGoogleBakedTexInScene-v0
)

declare -a coke_can_options_arr=("lr_switch=True" "upright=True" "laid_vertically=True")
declare -a urdf_version_arr=(None "recolor_tabletop_visual_matching_1" "recolor_tabletop_visual_matching_2" "recolor_cabinet_visual_matching_1")
EXTRA_ARGS="--enable-raytracing --additional-env-build-kwargs station_name=mk_station_recolor light_mode=simple disable_bad_material=True urdf_version=${urdf_version} model_ids=baked_apple_v2"
scene_name=evaluate_all_tasks

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

# Combine all sets into one for easy checking
combined_sets=("${set_1[@]}" "${set_2[@]}" "${set_3[@]}" "${set_4[@]}" "${set_5[@]}")

for ckpt_path in "${ckpt_paths[@]}"; do
  for env_name in "${env_names[@]}"; do
    if [[ " ${set_1[*]} " == *"$env_name"* ]]; then
        if [[ "$env_name" == "PutEggplantInBasketScene-v0" ]]; then
          robot=widowx_sink_camera_setup
          robot_init_x=0.127
          robot_init_y=0.06
          overlay_img_list=("ManiSkill2_real2sim/data/real_inpainting/bridge_sink.png")
          CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --policy-model ${policy_model} --ckpt-path ${ckpt_path} \
          --robot ${robot} --policy-setup widowx_bridge \
          --control-freq 5 --sim-freq 500 --max-episode-steps 120 \
          --env-name ${env_name} --scene-name ${scene_name} \
          --robot-init-x ${robot_init_x} ${robot_init_x} 1 --robot-init-y ${robot_init_y} ${robot_init_y} 1 --obj-variation-mode episode --obj-episode-range 0 24 \
          --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 --overlay_img_ls "${overlay_img_list[@]}";
        else
          robot=widowx
          robot_init_x=0.147
          robot_init_y=0.028
          overlay_img_list=("ManiSkill2_real2sim/data/real_inpainting/bridge_sink.png")
          CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --policy-model ${policy_model} --ckpt-path ${ckpt_path} \
          --robot ${robot} --policy-setup widowx_bridge \
          --control-freq 5 --sim-freq 500 --max-episode-steps 60 \
          --env-name ${env_name} --scene-name ${scene_name} \
          --robot-init-x ${robot_init_x} ${robot_init_x} 1 --robot-init-y ${robot_init_y} ${robot_init_y} 1 --obj-variation-mode episode --obj-episode-range 0 24 \
          --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 --overlay_img_ls "${overlay_img_list[@]}";
        fi
    elif [[ " ${set_2[*]} " == *"$env_name"* ]]; then
        overlay_img_list=("./ManiSkill2_real2sim/data/real_inpainting/open_drawer_a0.png" "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_b0.png" "./ManiSkill2_real2sim/data/real_inpainting/open_drawer_c0.png")
        CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --policy-model openvla --ckpt-path ${ckpt_path} \
        --robot google_robot_static \
        --control-freq 3 --sim-freq 513 --max-episode-steps 200 \
        --env-name ${env_name} --scene-name dummy_drawer \
        --robot-init-x 0.644 0.644 1 --robot-init-y -0.179 -0.179 1 \
        --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 -0.03 -0.03 1 \
        --obj-init-x-range -0.08 -0.02 3 --obj-init-y-range -0.02 0.08 3 \
        ${EXTRA_ARGS} --overlay_img_ls "${overlay_img_list[@]}";
    elif [[ " ${set_3[*]} " == *"$env_name"* ]]; then
      overlay_img_list=("./ManiSkill2_real2sim/data/real_inpainting/google_coke_can_real_eval_1.png")
      CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --policy-model openvla --ckpt-path ${ckpt_path} \
      --robot google_robot_static \
      --control-freq 3 --sim-freq 513 --max-episode-steps 80 \
      --env-name ${env_name} --scene-name ${scene_name} \
      --robot-init-x 0.35 0.35 1 --robot-init-y 0.20 0.20 1 --obj-init-x -0.35 -0.12 5 --obj-init-y -0.02 0.42 5 \
      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 \
      --additional-env-build-kwargs ${coke_can_option} urdf_version=${urdf_version} --overlay_img_ls "${overlay_img_list[@]}";
    elif [[ " ${set_4[*]} " == *"$env_name"* ]]; then
      overlay_img_list=("rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_a0.png"
                        "rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_a1.png"
                        "rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_a2.png"
                        "rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_b0.png"
                        "rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_b1.png"
                        "rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_b2.png"
                        "rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_c0.png"
                        "rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_c1.png"
                        "rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/open_drawer_c2.png")
      CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --policy-model openvla --ckpt-path ${ckpt_path} \
      --robot google_robot_static \
      --control-freq 3 --sim-freq 513 --max-episode-steps 113 \
      --env-name ${env_name} --scene-name dummy_drawer \
      --robot-init-x 0.644 0.644 1 --robot-init-y -0.179 -0.179 1 \
      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 -0.03 -0.03 1 \
      --obj-init-x-range 0 0 1 --obj-init-y-range 0 0 1 \
      --additional-env-build-kwargs urdf_version=${urdf_version} ${EXTRA_ARGS} --overlay_img_ls "${overlay_img_list[@]}";
    elif [[ " ${set_5[*]} " == *"$env_name"* ]]; then
      overlay_img_list=("rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/google_move_near_real_eval_1.png")
      CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --policy-model openvla --ckpt-path ${ckpt_path} \
      --robot google_robot_static \
      --control-freq 3 --sim-freq 513 --max-episode-steps 80 \
      --env-name ${env_name} --scene-name ${scene_name} \
      --robot-init-x 0.35 0.35 1 --robot-init-y 0.21 0.21 1 --obj-variation-mode episode --obj-episode-range 0 60 \
      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 -0.09 -0.09 1 \
      --additional-env-build-kwargs urdf_version=${urdf_version} \
      --additional-env-save-tags baked_except_bpb_orange --overlay_img_ls "${overlay_img_list[@]}";
    else
      echo "No env found"
    fi
  done
done



