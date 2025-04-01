cd /sd-repo/stable-diffusion-webui
ln -s /ssdshare/share/lab5/repositories repositories
ln -s /ssdshare/share/lab5/interrogate interrogate

cd models
rm -rf Lora && ln -s /ssdshare/share/lab5/SD-WebUI-models/Lora Lora
rm -rf BLIP && ln -s /ssdshare/share/lab5/SD-WebUI-models/BLIP BLIP
rm -rf Stable-diffusion && ln -s /ssdshare/share/lab5/SD-WebUI-models/Stable-diffusion Stable-diffusion
rm -rf torch_deepdanbooru && ln -s /ssdshare/share/lab5/SD-WebUI-models/torch_deepdanbooru torch_deepdanbooru
rm -rf CLIP && ln -s /ssdshare/share/lab5/SD-WebUI-models/CLIP CLIP
rm -rf VAE && ln -s /ssdshare/share/lab5/SD-WebUI-models/VAE VAE
rm -rf VAE-approx && ln -s /ssdshare/share/lab5/SD-WebUI-models/VAE-approx VAE-approx
cd ..

HF_ENDPOINT="http://hf-mirror.com" /usr/bin/python launch.py --no-download-sd-model --skip-prepare-environment --clip-models-path /ssdshare/share/lab5/clip-vit-l-14
