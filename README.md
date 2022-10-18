# Docker for Dreambooth Stable Diffusion
This is a Docker Setup for Dreambooth to train personalized stable diffusion models.

See [wsl2-setup.md](readme/wsl2-setup.md) for infos about setting up WSL2 and Docker under Windows.

## Install
- clone repo
- Build with: `docker compose -f docker-compose.build.yaml build`

## One-Time Setup
- register on huggingface and create a new Access Token here: https://huggingface.co/settings/tokens
- copy the token and set it in a file named `.env` in the form `TOKEN=yourtoken`. (see also `example.env`)

## Configuration
- make sure the folders `checkpoint_output/`, `class_images` and `output/` are empty before training a new checkpoint.

  _(if they don't exist, they are created on the first start)_
- put training images into `instance_images/` directory.
- edit `app/train.sh` file in a text editor.
  - only uncomment the type of training you want to use.
  - edit `INSTANCE_PROMPT` and `CLASS_PROMPT`
- Edit settings in accelerate-config.yaml or run `docker compose -f docker-compose.build.yaml exec dreambooth accelerate config --config_file=/app/examples/dreambooth/accelerate-config.yaml`
  to configure training acceleration settings.

## Training
- run container with `docker compose -f docker-compose.build.yaml up -d`
- run `docker compose -f docker-compose.build.yaml exec dreambooth ./train.sh`
- get the generated checkpoint file to use with most SD UIs (like https://github.com/AUTOMATIC1111/stable-diffusion-webui) from `checkpoint_output/model.ckpt`.

## Helper
- open shell into container with: `docker compose -f docker-compose.build.yaml exec dreambooth bash`

### _Sources_
- https://github.com/ShivamShrirao/diffusers/tree/main/examples/dreambooth
- https://gist.github.com/jachiam/8a5c0b607e38fcc585168b90c686eb05
