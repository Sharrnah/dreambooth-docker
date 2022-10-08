#!/bin/bash
export MODEL_NAME="CompVis/stable-diffusion-v1-4"
export INSTANCE_DIR="instance_images"
export CLASS_DIR="class_images"
export OUTPUT_DIR="output"

# the prompt that gives the trained image
export INSTANCE_PROMPT="a photo of sks dog"

# prior-preservation loss prompt. - should be a prompt to generate something similar of the training images to prevent overfitting
export CLASS_PROMPT="a photo of dog"

export ACCELERATE_CONFIG="/app/examples/dreambooth/accelerate-config.yaml"

# basic
#accelerate launch --config_file=$ACCELERATE_CONFIG train_dreambooth.py \
#    --pretrained_model_name_or_path="$MODEL_NAME" \
#    --instance_data_dir="$INSTANCE_DIR" \
#    --output_dir="$OUTPUT_DIR" \
#    --instance_prompt="$INSTANCE_PROMPT" \
#    --resolution=512 \
#    --train_batch_size=1 \
#    --gradient_accumulation_steps=1 \
#    --gradient_checkpointing \
#    --learning_rate=5e-6 \
#    --lr_scheduler="constant" \
#    --lr_warmup_steps=0 \
#    --max_train_steps=400

# with prior-preservation loss _to prevent overfitting and language-drift_
# it's recommended to generate num_epochs * num_samples images for prior-preservation. 200-300 works well for most cases.
# add: --class_data_dir=$CLASS_DIR --with_prior_preservation --prior_loss_weight=1.0 --class_prompt="xyz"
accelerate launch --config_file=$ACCELERATE_CONFIG train_dreambooth.py \
    --pretrained_model_name_or_path="$MODEL_NAME" \
    --instance_data_dir="$INSTANCE_DIR" \
    --class_data_dir="$CLASS_DIR" \
    --output_dir="$OUTPUT_DIR" \
    --with_prior_preservation --prior_loss_weight=1.0 \
    --instance_prompt="$INSTANCE_PROMPT" \
    --class_prompt="$CLASS_PROMPT" \
    --resolution=512 \
    --train_batch_size=1 \
    --gradient_accumulation_steps=1 \
    --learning_rate=5e-6 \
    --lr_scheduler="constant" \
    --lr_warmup_steps=0 \
    --num_class_images=200 \
    --max_train_steps=800

# with prior-preservation loss and gradient checkpointing and 8-bit optimizer _for 16GB GPU_
# add: --gradient_checkpointing --use_8bit_adam
#accelerate launch --config_file=$ACCELERATE_CONFIG train_dreambooth.py \
#    --pretrained_model_name_or_path="$MODEL_NAME" \
#    --instance_data_dir="$INSTANCE_DIR" \
#    --class_data_dir="$CLASS_DIR" \
#    --output_dir="$OUTPUT_DIR" \
#    --with_prior_preservation --prior_loss_weight=1.0 \
#    --instance_prompt="$INSTANCE_PROMPT" \
#    --class_prompt="$CLASS_PROMPT" \
#    --resolution=512 \
#    --train_batch_size=1 \
#    --gradient_accumulation_steps=2 --gradient_checkpointing \
#    --use_8bit_adam \
#    --learning_rate=5e-6 \
#    --lr_scheduler="constant" \
#    --lr_warmup_steps=0 \
#    --num_class_images=200 \
#    --max_train_steps=800


echo "converting to checkpoint file"

python ./convert_diffusers_to_sd.py --model_path="output" --checkpoint_path="checkpoint_output/model.ckpt"
