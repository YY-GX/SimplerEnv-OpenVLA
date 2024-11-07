gpu_id=3
policy_model=openvla
#ckpt_path="openvla/openvla-7b"
#declare -a arr=("/mnt/bum/yufang/projects/openvla/runs/1.0.3/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--image_aug--1000_chkpt" "/mnt/bum/yufang/projects/openvla/runs/1.0.3-v2/openvla-7b+droid+b8+lr-0.0001+lora-r32+dropout-0.0--4000_chkpt")
#carrot
#declare -a arr=("/mnt/bum/yufang/projects/openvla/runs/1.1.0/openvla-7b+droid+b8+lr-0.0005+lora-r32+dropout-0.0--image_aug--20000_chkpt")
#declare -a arr=("/mnt/bum/yufang/projects/openvla/runs/1.1.0/openvla-7b+droid+b8+lr-0.0005+lora-r32+dropout-0.0--20000_chkpt")
#spoon
#declare -a arr=("/mnt/bum/yufang/projects/openvla/runs/1.1.1/openvla-7b+droid+b8+lr-0.0005+lora-r32+dropout-0.0--image_aug--20000_chkpt")

#declare -a arr=("/mnt/bum/yufang/projects/openvla/runs/1.1.2-bs64/openvla-7b+droid+b8+lr-0.0005+lora-r32+dropout-0.0--100000_chkpt")
#declare -a arr=("/mnt/bum/yufang/projects/openvla/runs/1.1.2/openvla-7b+droid+b8+lr-0.0005+lora-r32+dropout-0.0--image_aug--100000_chkpt")
#RT-1 rollouts
#declare -a arr=("/mnt/bum/yufang/projects/openvla/runs/rollout/openvla-7b+simpler_env+b8+lr-0.0005+lora-r32+dropout-0.0--image_aug--2000_chkpt")
declare -a arr=("/mnt/bum/yufang/projects/openvla/runs/rollout-noaug/openvla-7b+simpler_env+b8+lr-0.0005+lora-r32+dropout-0.0--1000_chkpt")

scene_name=bridge_table_1_v1
robot=widowx
rgb_overlay_path=ManiSkill2_real2sim/data/real_inpainting/bridge_real_eval_1.png
robot_init_x=0.147
robot_init_y=0.028
seeds=(0)


#yy: add for loop ckpt
for seed in "${seeds[@]}"; do
  for ckpt_path in "${arr[@]}"; do
    CUDA_VISIBLE_DEVICES=${gpu_id} python simpler_env/main_inference.py --policy-model ${policy_model} --ckpt-path ${ckpt_path} \
      --robot ${robot} --policy-setup widowx_bridge \
      --control-freq 5 --sim-freq 500 --max-episode-steps 100 \
      --env-name PutSpoonOnTableClothInScene-v0 --scene-name ${scene_name} \
      --rgb-overlay-path ${rgb_overlay_path} \
      --robot-init-x ${robot_init_x} ${robot_init_x} 1 --robot-init-y ${robot_init_y} ${robot_init_y} 1 --obj-variation-mode episode --obj-episode-range 0 24 \
      --robot-init-rot-quat-center 0 0 0 1 --robot-init-rot-rpy-range 0 0 1 0 0 1 0 0 1 --instruction "Pick up the spoon and place it on the towel" --seed "$seed";
  done
done
