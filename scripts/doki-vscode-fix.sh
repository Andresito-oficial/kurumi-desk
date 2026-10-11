#!/bin/bash
set -e

EXT=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" | sort -V | tail -1)
DEFS="$EXT/out/DokiThemeDefinitions.js"

cp "$DEFS" "$DEFS.bak-$(date +%s)"

node << 'NODE_EOF'
const fs = require("fs");
const DEFS = process.env.DEFS;

const content = fs.readFileSync(DEFS, "utf8");
const match = content.match(/exports\.default\s*=\s*(\[[\s\S]*\]);/);
if (!match) { console.error("❌ No se pudo parsear"); process.exit(1); }
const defs = eval("(" + match[1] + ")");

const KURUMI_ID      = "7a8c3e21-4b5f-4d9a-8e2c-1f6b3a9d7c04";
const KURUMI_DARK_ID = "9d2f6b14-7e3a-4c81-b5d2-8a1e4c7f9035";

// Si ya están, no duplicar
const yaExiste = defs.some(t => t.themeDefinition?.information?.id === KURUMI_ID);
if (yaExiste) {
    console.log("⚠ Los temas ya están registrados");
    process.exit(0);
}

const kurumiEntry = (id, name, displayName, dark, stickerPath) => ({
    extensionNames: [
        `doki-theme.theme.${name}`,
        `doki-theme.theme.wallpaper.${name}`
    ],
    themeDefinition: {
        information: {
            id: id,
            name: name,
            displayName: displayName,
            dark: dark,
            author: "Andrés",
            group: "Date A Live",
            stickers: {
                default: {
                    name: "kurumi.png",
                    anchor: "right",
                    opacity: 10
                }
            },
            characterId: "00000000-0000-0000-0000-000000000001"
        },
        stickers: {
            default: {
                path: stickerPath,
                name: "kurumi.png",
                anchoring: "right"
            }
        }
    }
});

defs.push(kurumiEntry(
    KURUMI_ID,
    "Tokisaki Kurumi",
    "Tokisaki Kurumi",
    false,
    "/dateALive/kurumi/light/kurumi.png"
));

defs.push(kurumiEntry(
    KURUMI_DARK_ID,
    "Tokisaki Kurumi Dark",
    "Tokisaki Kurumi Dark",
    true,
    "/dateALive/kurumi/dark/kurumi.png"
));

const banner = '"use strict";\n' +
  'Object.defineProperty(exports, "__esModule", { value: true });\n' +
  'exports.default = ';
fs.writeFileSync(DEFS, banner + JSON.stringify(defs) + ";", "utf8");
console.log("✅ Añadidos 2 temas. Total ahora:", defs.length);
NODE_EOF

# Verificar
echo ""
echo "=== Verificación ==="
grep -c "Tokisaki Kurumi" "$DEFS" || echo "No encontrado"
grep -c "7a8c3e21-4b5f-4d9a-8e2c-1f6b3a9d7c04" "$DEFS" || echo "No encontrado"

echo ""
echo "✅ Reinicia VSCode:"
echo "  pkill -f code; sleep 2; code &"
