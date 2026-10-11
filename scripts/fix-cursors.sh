#!/bin/bash
# fix-cursors.sh — mete cada PNG en un SVG con base64, colores intactos

SRC="$HOME/.local/share/icons/Luka_Static/cursors_scalable"
cd "$SRC" || exit 1

# Para cada carpeta de cursor
for dir in */; do
    dir="${dir%/}"
    png="$dir.png"
    
    if [ ! -f "$dir/$png" ]; then
        echo "⚠ Sin PNG en $dir/"
        continue
    fi
    
    # Base64 del PNG original
    b64=$(base64 -w0 "$dir/$png")
    
    # Generar el SVG con el PNG embebido
    cat > "$dir/$dir.svg" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
     width="32" height="32" viewBox="0 0 32 32">
  <image width="32" height="32" xlink:href="data:image/png;base64,$b64"/>
</svg>
EOF

    # Actualizar el metadata.json para apuntar al SVG
    cat > "$dir/metadata.json" << EOF
[
    {
        "filename": "$dir.svg",
        "hotspot_x": 4,
        "hotspot_y": 4,
        "nominal_size": 32
    }
]
EOF

    # Borrar el PNG de dentro de la carpeta (ya está embebido en el SVG)
    rm -f "$dir/$png"
done

echo "✅ Listo. Carpetas procesadas: $(find . -maxdepth 1 -type d | wc -l)"
echo "Verifica: ls default/"
