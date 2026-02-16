#!/bin/bash
echo "🔧 Configurando symlinks automáticos..."

# Esperar a que ComfyUI se instale
while [ ! -d "/workspace/runpod-slim/ComfyUI/models" ]; do
    sleep 2
done

COMFY_PATH="/workspace/runpod-slim/ComfyUI"

# Eliminar carpetas vacías
rm -rf $COMFY_PATH/models/checkpoints 2>/dev/null || true
rm -rf $COMFY_PATH/models/vae 2>/dev/null || true
rm -rf $COMFY_PATH/models/loras 2>/dev/null || true
rm -rf $COMFY_PATH/models/controlnet 2>/dev/null || true
rm -rf $COMFY_PATH/models/text_encoders 2>/dev/null || true
rm -rf $COMFY_PATH/output 2>/dev/null || true

# Crear symlinks
ln -sf /workspace/checkpoints $COMFY_PATH/models/checkpoints
ln -sf /workspace/vae $COMFY_PATH/models/vae
ln -sf /workspace/loras $COMFY_PATH/models/loras
ln -sf /workspace/controlnet $COMFY_PATH/models/controlnet
ln -sf /workspace/text_encoders $COMFY_PATH/models/text_encoders

# Workflows
mkdir -p $COMFY_PATH/user/default
ln -sf /workspace/workflows/comfyui $COMFY_PATH/user/default/workflows

# Output
ln -sf /workspace/outputs/images $COMFY_PATH/output

echo "✅ Symlinks configurados correctamente"
