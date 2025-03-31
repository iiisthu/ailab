cd /comfyui-repo/ComfyUI/models
rm -rf checkpoints && ln -s /ssdshare/share/lab5/ComfyUI-models/checkpoints checkpoints
rm -rf clip && ln -s /ssdshare/share/lab5/ComfyUI-models/clip clip
rm -rf controlnet && ln -s /ssdshare/share/lab5/ComfyUI-models/controlnet controlnet
rm -rf gligen && ln -s /ssdshare/share/lab5/ComfyUI-models/gligen gligen
rm -rf loras && ln -s /ssdshare/share/lab5/ComfyUI-models/loras loras
rm -rf upscale_models && ln -s /ssdshare/share/lab5/ComfyUI-models/upscale_models upscale_models
rm -rf vae && ln -s /ssdshare/share/lab5/ComfyUI-models/vae vae

cd ..

cd custom_nodes
ln -s /ssdshare/share/lab5/custom_nodes/ComfyUI-Manager ComfyUI-Manager

cd ..
/usr/bin/python main.py