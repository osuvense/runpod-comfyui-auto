# Partir de la imagen oficial de RunPod ComfyUI
FROM runpod/comfyui:latest

# Crear script de setup de symlinks
RUN cat > /setup_symlinks.sh << 'EOF'
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
rm -rf $COMFY_PATH/output 2>/dev/null || true

# Crear symlinks
ln -sf /workspace/checkpoints $COMFY_PATH/models/checkpoints
ln -sf /workspace/vae $COMFY_PATH/models/vae
ln -sf /workspace/loras $COMFY_PATH/models/loras
ln -sf /workspace/controlnet $COMFY_PATH/models/controlnet

# Workflows
mkdir -p $COMFY_PATH/user/default
ln -sf /workspace/workflows/comfyui $COMFY_PATH/user/default/workflows

# Output
ln -sf /workspace/outputs/images $COMFY_PATH/output

echo "✅ Symlinks configurados correctamente"
EOF

# Dar permisos de ejecución
RUN chmod +x /setup_symlinks.sh

# Modificar el start.sh original para que ejecute nuestro setup
RUN mv /start.sh /start_original.sh && \
    cat > /start.sh << 'EOF'
#!/bin/bash

# Ejecutar setup de symlinks en background
/setup_symlinks.sh &

# Ejecutar start original
exec /start_original.sh "$@"
EOF

RUN chmod +x /start.sh

# Mantener el resto igual
CMD ["/start.sh"]
