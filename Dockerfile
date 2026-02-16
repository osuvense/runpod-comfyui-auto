FROM runpod/comfyui:latest

RUN cat > /setup_symlinks.sh << 'SCRIPT'
#!/bin/bash
echo "🔧 Configurando symlinks automáticos..."

while [ ! -d "/workspace/runpod-slim/ComfyUI/models" ]; do
    sleep 2
done

COMFY_PATH="/workspace/runpod-slim/ComfyUI"

rm -rf $COMFY_PATH/models/checkpoints 2>/dev/null || true
rm -rf $COMFY_PATH/models/diffusion_models 2>/dev/null || true
rm -rf $COMFY_PATH/models/vae 2>/dev/null || true
rm -rf $COMFY_PATH/models/loras 2>/dev/null || true
rm -rf $COMFY_PATH/models/controlnet 2>/dev/null || true
rm -rf $COMFY_PATH/models/text_encoders 2>/dev/null || true
rm -rf $COMFY_PATH/output 2>/dev/null || true

ln -sf /workspace/checkpoints $COMFY_PATH/models/checkpoints
ln -sf /workspace/diffusion_models $COMFY_PATH/models/diffusion_models
ln -sf /workspace/vae $COMFY_PATH/models/vae
ln -sf /workspace/loras $COMFY_PATH/models/loras
ln -sf /workspace/controlnet $COMFY_PATH/models/controlnet
ln -sf /workspace/text_encoders $COMFY_PATH/models/text_encoders

mkdir -p $COMFY_PATH/user/default
ln -sf /workspace/workflows/comfyui $COMFY_PATH/user/default/workflows

ln -sf /workspace/outputs/images $COMFY_PATH/output

echo "✅ Symlinks configurados correctamente"
SCRIPT

RUN chmod +x /setup_symlinks.sh

RUN mv /start.sh /start_original.sh && \
    cat > /start.sh << 'SCRIPT'
#!/bin/bash
/setup_symlinks.sh &
exec /start_original.sh "$@"
SCRIPT

RUN chmod +x /start.sh

CMD ["/start.sh"]
