#!/bin/bash
cd /app/examples/dreambooth/

echo -n "${TOKEN}" > /root/.huggingface/token


chmod +x /app/examples/dreambooth/train.sh

#accelerate config --config_file=/app/examples/dreambooth/accelerate-config.yaml

accelerate test --config_file=/app/examples/dreambooth/accelerate-config.yaml

chmod -R 0777 ./

echo "installation finished.."

# keep container running
sleep infinity
