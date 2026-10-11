#!/bin/bash
# doki-vscode-sticker.sh — añade sticker Kurumi a VSCode Doki Theme

set -e

EXT=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" | sort -V | tail -1)
DEFS="$EXT/out/DokiThemeDefinitions.js"
ASSETS=~/.config/Code/User/globalStorage/unthrottled.doki-theme/stickers
SRC_PNG=~/.doki-theme-hyper-config/stickers/dateALive/kurumi/light/kurumi.png

# ─── 1. Copiar PNG al cache de VSCode ───────────────────────
mkdir -p "$ASSETS/dateALive/kurumi/light"
mkdir -p "$ASSETS/dateALive/kurumi/dark"

cp "$SRC_PNG" "$ASSETS/dateALive/kurumi/light/kurumi.png"
cp "$SRC_PNG" "$ASSETS/dateALive/kurumi/dark/kurumi.png"

echo "✅ PNGs copiados a $ASSETS/dateALive/kurumi/"

# ─── 2. Ver qué formato tiene el DokiThemeDefinitions ──────
echo ""
echo "=== Estructura de un themeDefinition (Zero Two) ==="
grep -o '"themeDefinition":{[^}]*}' "$DEFS" | head -1 | head -c 500
echo ""
echo "..."

# ─── 3. Parchear el DokiThemeDefinitions ───────────────────
cp "$DEFS" "$DEFS.bak-$(date +%s)"

node << 'NODE_EOF'
const fs = require("fs");
const path = process.env.DEFS_PATH;
const content = fs.readFileSync(path, "utf8");

// El archivo es: "use strict";\nObject.defineProperty...;\nexports.default = [...];\n//# sourceMappingURL=...
// Extraer el array
const match = content.match(/exports\.default\s*=\s*(\[[\s\S]*\]);?\s*\/\/# sourceMappingURL/);
if (!match) {
    console.error("❌ No se pudo parsear DokiThemeDefinitions.js");
    process.exit(1);
}

const defs = eval("(" + match[1] + ")");

const KURUMI      = "7a8c3e21-4b5f-4d9a-8e2c-1f6b3a9d7c04";
const KURUMI_DARK = "9d2f6b14-7e3a-4c81-b5d2-8a1e4c7f9035";

const stickerPaths = {
  [KURUMI]:      { path: "/dateALive/kurumi/light/kurumi.png", name: "kurumi.png" },
  [KURUMI_DARK]: { path: "/dateALive/kurumi/dark/kurumi.png",  name: "kurumi.png" },
};

let fixed = 0;
for (const theme of defs) {
    const td = theme.themeDefinition;
    if (!td || !td.information) continue;
    const id = td.information.id;
    if (!stickerPaths[id]) continue;

    const cfg = stickerPaths[id];

    // En information: metadata del sticker (lo que se muestra en la UI)
    td.information.stickers = {
        default: { name: cfg.name, anchor: "right", opacity: 10 }
    };

    // En la raíz: ruta real del PNG
    td.stickers = {
        default: {
            path: cfg.path,
            name: cfg.name,
            anchoring: "right",
        }
    };

    console.log("✅ Parcheado: " + td.information.name + " → " + cfg.path);
    fixed++;
}

if (fixed === 0) {
    console.error("❌ No se encontraron los temas Kurumi");
    process.exit(1);
}

// Regenerar
const banner = "\"use strict\";\n" +
  "Object.defineProperty(exports, \"__esModule\", { value: true });\n" +
  "exports.default = ";
const footer = ";\n//# sourceMappingURL=DokiThemeDefinitions.js.map\n";
fs.writeFileSync(path, banner + JSON.stringify(defs) + footer, "utf8");
console.log("✅ DokiThemeDefinitions.js actualizado");
NODE_EOF

# ─── 4. Verificar ──────────────────────────────────────────
echo ""
echo "=== Verificar que se guardó ==="
node -e '
const fs = require("fs");
const c = fs.readFileSync(process.env.DEFS_PATH, "utf8");
const m = c.match(/exports\.default\s*=\s*(\[[\s\S]*\]);?\s*\/\/# sourceMappingURL/);
const defs = eval("(" + m[1] + ")");
const k = defs.find(t => t.themeDefinition.information.id === "9d2f6b14-7e3a-4c81-b5d2-8a1e4c7f9035");
console.log("Stickers default:", JSON.stringify(k.themeDefinition.stickers, null, 2));
console.log("Info stickers:", JSON.stringify(k.themeDefinition.information.stickers, null, 2));
'

echo ""
echo "✅ Hecho. Reinicia VSCode:"
echo "  pkill -f code; sleep 2; code &"
