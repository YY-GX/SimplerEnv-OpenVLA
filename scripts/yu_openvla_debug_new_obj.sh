gpu_id=0
policy_model=openvla

declare -a arr=("openvla/openvla-7b")

scene_name=google_pick_coke_can_1_v4
rgb_overlay_path=./ManiSkill2_real2sim/data/real_inpainting/google_coke_can_real_eval_1.png

seeds=(0)


#yy: add for loop ckpt
for seed in "${seeds[@]}"; do
  for ckpt_path in "${arr[@]}"; do
    CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --policy-model ${policy_model} --ckpt-path ${ckpt_path} \
      --robot google_robot_static \
      --control-freq 3 --sim-freq 513 --max-episode-steps 10 \
      --env-name GraspSingleCupInScene-v0 --scene-name ${scene_name} \
      --rgb-overlay-path ${rgb_overlay_path} \
      --robot-init-x 0.35 0.35 1 --robot-init-y 0.20 0.20 1 --obj-variation-mode episode --obj-episode-range 0 1 \
      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 --instruction "Pick up the cup" \
      --seed "$seed" --additional-env-build-kwargs urdf_version="recolor_tabletop_visual_matching_1";
  done
done
