#!/bin/bash
export PYTHONFAULTHANDLER=1
export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
pretrained_model_name_or_path=resolution_512_model_cosine_ep2_sdxl
ori_model_name_or_path=resolution_512_model_cosine_ep2_sdxl
train_data_jsonl=mixed_mask_free_1M_6_29.jsonl # mix the redion-basd and free-form image editing data
resolution=512
train_batch_size=18
gradient_accumulation_steps=2
checkpointing_steps=500
validation_step=500
# max_train_samples=1
epoch=2
lr=1e-05
output_dir="resolution_${resolution}_model_cosine_ep{epoch}_sdxl"
accelerate launch --mixed_precision="fp16" --multi_gpu --main_process_port=29555 training/train_sdxl_pix2pix.py \
 --pretrained_model_name_or_path ${pretrained_model_name_or_path} \
 --use_ema \
 --output_dir ${output_dir} \
 --train_data_jsonl ${train_data_jsonl} \
 --resolution ${resolution} \
 --do_mask \
 --num_train_epochs ${epoch} \
 --random_flip \
 --train_batch_size ${train_batch_size} \
 --gradient_accumulation_steps ${gradient_accumulation_steps} \
 --checkpointing_steps ${checkpointing_steps}  \
 --checkpoints_total_limit 2 \
 --learning_rate ${lr} \
 --lr_warmup_steps 500 \
 --conditioning_dropout_prob 0.05 \
 --mixed_precision fp16 \
 --seed 42 \
 --gradient_checkpointing \
 --num_validation_images 4 \
 --val_image_url input.png \
 --validation_prompt "What if the horse wears a hat?" \
 --val_mask_url mask_img.png \
 --validation_step ${validation_step} \
 --lr_scheduler cosine \
 --ori_model_name_or_path ${ori_model_name_or_path} \
 --enable_xformers_memory_efficient_attention \
 --dataloader_num_workers 16 \
 --gradient_checkpointing \

