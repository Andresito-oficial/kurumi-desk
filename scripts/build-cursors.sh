#!/bin/bash
# build-cursors.sh — genera cursors_scalable con formato GNOME 51

SRC="$HOME/.local/share/icons/Luka_Static/cursors_scalable"
cd "$SRC" || exit 1

# Cada carpeta nueva lleva: metadata.json + la imagen
# Mapeo: PNG origen → lista de nombres GNOME que debe tener
declare -A MAP=(
    [Normal]="default left_ptr arrow"
    [Link]="pointer hand2"
    [Handwriting]="text xterm"
    [Busy]="wait"
    [Alternate]="progress half-busy"
    [Precision]="crosshair cross"
    [Help]="help question_arrow"
    [Unavailable]="not-allowed crossed_circle forbidden"
    [Move]="move fleur"
    [Diagonal1]="nw-resize se-resize fd_double_arrow"
    [Diagonal2]="ne-resize sw-resize bd_double_arrow"
    [Horizontal]="ew-resize h-resize sb_h_double_arrow"
    [Vertical]="ns-resize v-resize sb_v_double_arrow"
    [Person]="person"
    [Pin]="dnd-none dnd-move"
    [Working]="progress"
    [Text]="text"
)

# Hotspot según cursor (ajusta si ves que el punto del ratón sale desplazado)
declare -A HOTSPOT=(
    [default]="4 4"     # esquina superior izquierda
    [pointer]="6 2"     # dedo índice
    [text]="16 16"      # centro
    [crosshair]="16 16"
    [wait]="16 16"
)

for src in *.png; do
    base="${src%.png}"
    if [ -z "${MAP[$base]}" ]; then
        echo "⚠ Sin mapeo: $base"
        continue
    fi

    for target in ${MAP[$base]}; do
        # Crear carpeta
        mkdir -p "$target"

        # Copiar PNG con el nombre que apunta el metadata
        cp "$src" "$target/$target.png"

        # Hotspot: por defecto 4 4, ajusta según tabla
        hs="${HOTSPOT[$target]:-4 4}"
        hx="${hs% *}"
        hy="${hs#* }"

        # metadata.json
        cat > "$target/metadata.json" << EOF
[
    {
        "filename": "$target.png",
        "hotspot_x": $hx,
        "hotspot_y": $hy,
        "nominal_size": 32
    }
]
EOF
    done
done

# Borrar los PNG sueltos de la raíz (ya están dentro de sus carpetas)
rm -f *.png

echo "✅ Estructura creada. Total carpetas: $(find . -maxdepth 1 -type d | wc -l)"
