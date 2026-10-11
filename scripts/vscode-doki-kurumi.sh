#!/bin/bash
# vscode-doki-kurumi.sh — añade Tokisaki Kurumi a VSCode Doki Theme

set -e

EXT_DIR=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" | sort -V | tail -1)
if [ -z "$EXT_DIR" ]; then
    echo "❌ No encuentro Doki Theme en VSCode"
    exit 1
fi

echo "Extensión: $EXT_DIR"
GEN="$EXT_DIR/generatedThemes"
PKG="$EXT_DIR/package.json"

if [ ! -d "$GEN" ]; then
    echo "❌ No existe $GEN"
    exit 1
fi

# Backup
cp "$PKG" "$PKG.bak-$(date +%Y%m%d-%H%M%S)"

# ─── Nombres de archivo nuevos ───────────────────────────────
LIGHT_FILE="$GEN/Tokisaki Kurumi.theme.json"
DARK_FILE="$GEN/Tokisaki Kurumi Dark.theme.json"

# IDs únicos (los mismos de Hyper/Vim para coherencia)
KURUMI_ID="7a8c3e21-4b5f-4d9a-8e2c-1f6b3a9d7c04"
KURUMI_DARK_ID="9d2f6b14-7e3a-4c81-b5d2-8a1e4c7f9035"

# ─── Copiar las plantillas base ──────────────────────────────
echo ""
echo "══ Copiando plantillas base ══"
cp "$GEN/Zero Two Light Sakura.theme.json" "$LIGHT_FILE"
cp "$GEN/Zero Two Dark Rose.theme.json"    "$DARK_FILE"
echo "✅ $LIGHT_FILE"
echo "✅ $DARK_FILE"

# ─── Reemplazar los colores de Kurumi con jq ─────────────────
echo ""
echo "══ Aplicando paleta Kurumi a los JSONs ══"

# --- LIGHT: Tokisaki Kurumi ---
# Base: #faf4ec (fondo), #c2185b (acento), #8b0d47 (texto)
jq '
  .colors["editor.background"]      = "#faf4ec" |
  .colors["foreground"]             = "#8b0d47" |
  .colors["editor.foreground"]      = "#8b0d47" |
  .colors["sideBar.background"]     = "#faf4ec" |
  .colors["activityBar.background"] = "#f2e6d9" |
  .colors["activityBar.foreground"] = "#c2185b" |
  .colors["activityBar.inactiveForeground"] = "#b98a9c" |
  .colors["activityBarBadge.background"]    = "#c2185b" |
  .colors["activityBarBadge.foreground"]    = "#ffffff" |
  .colors["statusBar.background"]   = "#c2185b" |
  .colors["statusBar.foreground"]   = "#ffffff" |
  .colors["statusBar.noFolderBackground"] = "#c2185b" |
  .colors["statusBar.debuggingBackground"] = "#a01453" |
  .colors["titleBar.activeBackground"]   = "#f2e6d9" |
  .colors["titleBar.inactiveBackground"] = "#f2e6d9" |
  .colors["titleBar.activeForeground"]   = "#8b0d47" |
  .colors["titleBar.inactiveForeground"] = "#b98a9c" |
  .colors["tab.activeBackground"]   = "#fdf5f7" |
  .colors["tab.inactiveBackground"] = "#faf4ec" |
  .colors["tab.activeBorder"]       = "#c2185b" |
  .colors["tab.border"]             = "#ecd0da" |
  .colors["editorGroupHeader.tabsBackground"] = "#f2e6d9" |
  .colors["panel.background"]       = "#faf4ec" |
  .colors["panel.border"]           = "#ecd0da" |
  .colors["dropdown.background"]    = "#fdf5f7" |
  .colors["dropdown.foreground"]    = "#8b0d47" |
  .colors["dropdown.border"]        = "#ecd0da" |
  .colors["input.background"]       = "#ffffff" |
  .colors["input.foreground"]       = "#8b0d47" |
  .colors["input.border"]           = "#ecd0da" |
  .colors["button.background"]      = "#c2185b" |
  .colors["button.foreground"]      = "#ffffff" |
  .colors["button.hoverBackground"] = "#a01453" |
  .colors["focusBorder"]            = "#c2185b" |
  .colors["editorLineNumber.foreground"]        = "#b98a9c" |
  .colors["editorLineNumber.activeForeground"]  = "#c2185b" |
  .colors["editorCursor.foreground"] = "#c2185b" |
  .colors["list.activeSelectionBackground"] = "#f5dce5" |
  .colors["list.activeSelectionForeground"] = "#8b0d47" |
  .colors["list.hoverBackground"]   = "#f5dce5" |
  .colors["list.focusBackground"]   = "#f5dce5" |
  .colors["list.highlightForeground"] = "#c2185b" |
  .colors["editor.lineHighlightBackground"] = "#f5dce5aa" |
  .colors["editor.selectionBackground"]     = "#f5dce5" |
  .colors["editor.findMatchBackground"]     = "#ecd0da" |
  .colors["editor.findMatchBorder"]         = "#c2185b" |
  .colors["editorWidget.background"]        = "#fdf5f7" |
  .colors["editorWidget.border"]            = "#c2185b" |
  .colors["textLink.foreground"]            = "#c2185b" |
  .colors["textLink.activeForeground"]      = "#a01453" |
  .colors["badge.background"]               = "#c2185b" |
  .colors["badge.foreground"]               = "#ffffff" |
  .colors["progressBar.background"]         = "#c2185b" |
  .colors["scrollbarSlider.background"]     = "#c2185b55" |
  .colors["scrollbarSlider.hoverBackground"]     = "#c2185b88" |
  .colors["scrollbarSlider.activeBackground"]    = "#c2185baa" |
  .colors["terminal.ansiRed"]    = "#b3003c" |
  .colors["terminal.ansiGreen"]  = "#1a7a3d" |
  .colors["terminal.ansiYellow"] = "#c2185b" |
  .colors["terminal.ansiBlue"]   = "#8b0d47" |
  .colors["terminal.ansiMagenta"]= "#c2185b" |
  .colors["terminal.ansiCyan"]   = "#8b0d47" |
  .colors["terminalCursor.foreground"] = "#c2185b" |
  .colors["terminalCursor.background"] = "#faf4ec" |
  .colors["editorSuggestWidget.background"] = "#fdf5f7" |
  .colors["editorSuggestWidget.border"]     = "#ecd0da" |
  .colors["peekView.border"]     = "#c2185b" |
  .colors["peekViewEditor.background"]   = "#f5dce5" |
  .colors["peekViewResult.background"]   = "#faf4ec" |
  .colors["peekViewTitle.background"]    = "#f2e6d9" |
  .colors["notifications.background"]    = "#faf4ec" |
  .colors["notificationCenter.border"]   = "#ecd0da" |
  .colors["notifications.border"]        = "#ecd0da" |
  .colors["errorForeground"]             = "#b3003c" |
  .colors["editorError.foreground"]      = "#b3003c" |
  .colors["editorWarning.foreground"]    = "#c2185b" |
  .colors["gitDecoration.modifiedResourceForeground"] = "#c2185b" |
  .colors["gitDecoration.deletedResourceForeground"]  = "#b3003c" |
  .colors["gitDecoration.untrackedResourceForeground"]= "#1a7a3d" |
  .colors["symbolIcon.functionForeground"] = "#c2185b" |
  .colors["symbolIcon.classForeground"]    = "#8b0d47" |
  .colors["symbolIcon.methodForeground"]   = "#c2185b" |
  .colors["charts.red"]    = "#c2185b" |
  .colors["charts.blue"]   = "#8b0d47" |
  .colors["charts.green"]  = "#1a7a3d" |
  .colors["charts.purple"] = "#a01453" |
  .colors["charts.orange"] = "#c2185b" |
  .colors["charts.yellow"] = "#c2185b"
' "$LIGHT_FILE" > "$LIGHT_FILE.tmp" && mv "$LIGHT_FILE.tmp" "$LIGHT_FILE"

# --- DARK: Tokisaki Kurumi Dark ---
# Base: #050000 (fondo), #ff003c (acento), #ffb8c6 (texto)
jq '
  .colors["editor.background"]      = "#050000" |
  .colors["foreground"]             = "#ffb8c6" |
  .colors["editor.foreground"]      = "#ffb8c6" |
  .colors["sideBar.background"]     = "#050000" |
  .colors["activityBar.background"] = "#0d0003" |
  .colors["activityBar.foreground"] = "#ff003c" |
  .colors["activityBar.inactiveForeground"] = "#6b0018" |
  .colors["activityBarBadge.background"]    = "#ff003c" |
  .colors["activityBarBadge.foreground"]    = "#050000" |
  .colors["statusBar.background"]   = "#ff003c" |
  .colors["statusBar.foreground"]   = "#050000" |
  .colors["statusBar.noFolderBackground"] = "#ff003c" |
  .colors["statusBar.debuggingBackground"] = "#b3002a" |
  .colors["titleBar.activeBackground"]   = "#0d0003" |
  .colors["titleBar.inactiveBackground"] = "#0d0003" |
  .colors["titleBar.activeForeground"]   = "#ffb8c6" |
  .colors["titleBar.inactiveForeground"] = "#6b0018" |
  .colors["tab.activeBackground"]   = "#0d0003" |
  .colors["tab.inactiveBackground"] = "#050000" |
  .colors["tab.activeBorder"]       = "#ff003c" |
  .colors["tab.border"]             = "#1f0008" |
  .colors["editorGroupHeader.tabsBackground"] = "#0d0003" |
  .colors["panel.background"]       = "#050000" |
  .colors["panel.border"]           = "#1f0008" |
  .colors["dropdown.background"]    = "#0d0003" |
  .colors["dropdown.foreground"]    = "#ffb8c6" |
  .colors["dropdown.border"]        = "#1f0008" |
  .colors["input.background"]       = "#0d0003" |
  .colors["input.foreground"]       = "#ffb8c6" |
  .colors["input.border"]           = "#1f0008" |
  .colors["button.background"]      = "#ff003c" |
  .colors["button.foreground"]      = "#050000" |
  .colors["button.hoverBackground"] = "#ff6b8a" |
  .colors["focusBorder"]            = "#ff003c" |
  .colors["editorLineNumber.foreground"]        = "#6b0018" |
  .colors["editorLineNumber.activeForeground"]  = "#ff003c" |
  .colors["editorCursor.foreground"] = "#ff003c" |
  .colors["list.activeSelectionBackground"] = "#1f0008" |
  .colors["list.activeSelectionForeground"] = "#ffb8c6" |
  .colors["list.hoverBackground"]   = "#1f0008" |
  .colors["list.focusBackground"]   = "#1f0008" |
  .colors["list.highlightForeground"] = "#ff003c" |
  .colors["editor.lineHighlightBackground"] = "#1f000877" |
  .colors["editor.selectionBackground"]     = "#ff003c55" |
  .colors["editor.findMatchBackground"]     = "#1f0008" |
  .colors["editor.findMatchBorder"]         = "#ff003c" |
  .colors["editorWidget.background"]        = "#0d0003" |
  .colors["editorWidget.border"]            = "#ff003c" |
  .colors["textLink.foreground"]            = "#ff003c" |
  .colors["textLink.activeForeground"]      = "#ff6b8a" |
  .colors["badge.background"]               = "#ff003c" |
  .colors["badge.foreground"]               = "#050000" |
  .colors["progressBar.background"]         = "#ff003c" |
  .colors["scrollbarSlider.background"]     = "#ff003c55" |
  .colors["scrollbarSlider.hoverBackground"]     = "#ff003c88" |
  .colors["scrollbarSlider.activeBackground"]    = "#ff003caa" |
  .colors["terminal.ansiRed"]    = "#ff003c" |
  .colors["terminal.ansiGreen"]  = "#5fff9f" |
  .colors["terminal.ansiYellow"] = "#ff6b8a" |
  .colors["terminal.ansiBlue"]   = "#ffb8c6" |
  .colors["terminal.ansiMagenta"]= "#ff6b8a" |
  .colors["terminal.ansiCyan"]   = "#ffb8c6" |
  .colors["terminalCursor.foreground"] = "#ff003c" |
  .colors["terminalCursor.background"] = "#050000" |
  .colors["editorSuggestWidget.background"] = "#0d0003" |
  .colors["editorSuggestWidget.border"]     = "#1f0008" |
  .colors["peekView.border"]     = "#ff003c" |
  .colors["peekViewEditor.background"]   = "#1f0008" |
  .colors["peekViewResult.background"]   = "#0d0003" |
  .colors["peekViewTitle.background"]    = "#0d0003" |
  .colors["notifications.background"]    = "#0d0003" |
  .colors["notificationCenter.border"]   = "#1f0008" |
  .colors["notifications.border"]        = "#1f0008" |
  .colors["errorForeground"]             = "#ff003c" |
  .colors["editorError.foreground"]      = "#ff003c" |
  .colors["editorWarning.foreground"]    = "#ff6b8a" |
  .colors["gitDecoration.modifiedResourceForeground"] = "#ff6b8a" |
  .colors["gitDecoration.deletedResourceForeground"]  = "#ff003c" |
  .colors["gitDecoration.untrackedResourceForeground"]= "#5fff9f" |
  .colors["symbolIcon.functionForeground"] = "#ff6b8a" |
  .colors["symbolIcon.classForeground"]    = "#ffb8c6" |
  .colors["symbolIcon.methodForeground"]   = "#ff003c" |
  .colors["charts.red"]    = "#ff003c" |
  .colors["charts.blue"]   = "#ffb8c6" |
  .colors["charts.green"]  = "#5fff9f" |
  .colors["charts.purple"] = "#ff6b8a" |
  .colors["charts.orange"] = "#ff003c" |
  .colors["charts.yellow"] = "#ff6b8a"
' "$DARK_FILE" > "$DARK_FILE.tmp" && mv "$DARK_FILE.tmp" "$DARK_FILE"

echo "✅ Paleta aplicada a los dos JSON"

# ─── Registrar en package.json ───────────────────────────────
echo ""
echo "══ Registrando en package.json ══"

# Comprobar si ya están registrados
if grep -q "$KURUMI_ID" "$PKG"; then
    echo "⚠ Los temas ya están registrados, saltando"
else
    jq --arg id "$KURUMI_ID" \
       --arg label "Doki Theme: Date A Live:  Tokisaki Kurumi" \
       --arg path "./generatedThemes/Tokisaki Kurumi.theme.json" \
       '.contributes.themes += [{"id": $id, "label": $label, "path": $path, "uiTheme": "vs"}]' \
       "$PKG" > "$PKG.tmp" && mv "$PKG.tmp" "$PKG"

    jq --arg id "$KURUMI_DARK_ID" \
       --arg label "Doki Theme: Date A Live:  Tokisaki Kurumi Dark" \
       --arg path "./generatedThemes/Tokisaki Kurumi Dark.theme.json" \
       '.contributes.themes += [{"id": $id, "label": $label, "path": $path, "uiTheme": "vs-dark"}]' \
       "$PKG" > "$PKG.tmp" && mv "$PKG.tmp" "$PKG"

    echo "✅ Registrados"
fi

# ─── Verificar ───────────────────────────────────────────────
echo ""
echo "══ Verificación ══"
jq '.contributes.themes[] | select(.label | test("Tokisaki"))' "$PKG"

echo ""
echo "✅ Hecho."
echo ""
echo "Reinicia VSCode y busca los temas:"
echo "  Ctrl+K Ctrl+T → busca 'Tokisaki Kurumi'"
