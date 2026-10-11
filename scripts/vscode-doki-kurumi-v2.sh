#!/bin/bash
# vscode-doki-kurumi-v2.sh — reemplazo por CLAVE (no por hex)

set -e

EXT_DIR=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" | sort -V | tail -1)
GEN="$EXT_DIR/generatedThemes"

LIGHT="$GEN/Tokisaki Kurumi.theme.json"
DARK="$GEN/Tokisaki Kurumi Dark.theme.json"

# Restaurar desde backup si existe
[ -f "$LIGHT.bak" ] && cp "$LIGHT.bak" "$LIGHT"
[ -f "$DARK.bak" ]  && cp "$DARK.bak"  "$DARK"

if [ ! -f "$LIGHT" ]; then
    # Si no existe, crear desde plantillas
    cp "$GEN/Zero Two Light Sakura.theme.json" "$LIGHT"
    cp "$GEN/Zero Two Dark Rose.theme.json"    "$DARK"
fi

# ─── LIGHT — mapeo por clave ──────────────────────────────
jq '
  .colors["editor.background"]                  = "#faf4ec" |
  .colors["editor.foreground"]                  = "#8b0d47" |
  .colors["foreground"]                         = "#8b0d47" |
  .colors["sideBar.background"]                 = "#faf4ec" |
  .colors["sideBar.foreground"]                 = "#8b0d47" |
  .colors["activityBar.background"]             = "#f2e6d9" |
  .colors["activityBar.foreground"]             = "#c2185b" |
  .colors["activityBar.inactiveForeground"]     = "#b98a9c" |
  .colors["activityBarBadge.background"]        = "#c2185b" |
  .colors["activityBarBadge.foreground"]        = "#ffffff" |
  .colors["statusBar.background"]               = "#c2185b" |
  .colors["statusBar.foreground"]               = "#ffffff" |
  .colors["statusBar.noFolderBackground"]       = "#c2185b" |
  .colors["statusBar.debuggingBackground"]      = "#a01453" |
  .colors["titleBar.activeBackground"]          = "#f2e6d9" |
  .colors["titleBar.inactiveBackground"]        = "#f2e6d9" |
  .colors["titleBar.activeForeground"]          = "#8b0d47" |
  .colors["titleBar.inactiveForeground"]        = "#b98a9c" |
  .colors["tab.activeBackground"]               = "#fdf5f7" |
  .colors["tab.inactiveBackground"]             = "#faf4ec" |
  .colors["tab.activeForeground"]               = "#8b0d47" |
  .colors["tab.inactiveForeground"]             = "#b98a9c" |
  .colors["tab.activeBorder"]                   = "#c2185b" |
  .colors["tab.activeBorderTop"]                = "#c2185b" |
  .colors["tab.border"]                         = "#ecd0da" |
  .colors["editorGroup.border"]                 = "#ecd0da" |
  .colors["editorGroupHeader.tabsBackground"]   = "#f2e6d9" |
  .colors["panel.background"]                   = "#faf4ec" |
  .colors["panel.border"]                       = "#ecd0da" |
  .colors["panelTitle.activeForeground"]        = "#8b0d47" |
  .colors["panelTitle.inactiveForeground"]      = "#b98a9c" |
  .colors["panelTitle.activeBorder"]            = "#c2185b" |
  .colors["dropdown.background"]                = "#fdf5f7" |
  .colors["dropdown.foreground"]                = "#8b0d47" |
  .colors["dropdown.border"]                    = "#ecd0da" |
  .colors["input.background"]                   = "#ffffff" |
  .colors["input.foreground"]                   = "#8b0d47" |
  .colors["input.border"]                       = "#ecd0da" |
  .colors["input.placeholderForeground"]        = "#b98a9c" |
  .colors["inputOption.activeBorder"]           = "#c2185b" |
  .colors["button.background"]                  = "#c2185b" |
  .colors["button.foreground"]                  = "#ffffff" |
  .colors["button.hoverBackground"]             = "#a01453" |
  .colors["button.secondaryBackground"]         = "#f2e6d9" |
  .colors["button.secondaryForeground"]         = "#8b0d47" |
  .colors["focusBorder"]                        = "#c2185b" |
  .colors["widget.shadow"]                      = "#00000020" |
  .colors["scrollbar.shadow"]                   = "#00000015" |
  .colors["scrollbarSlider.background"]         = "#c2185b40" |
  .colors["scrollbarSlider.hoverBackground"]    = "#c2185b70" |
  .colors["scrollbarSlider.activeBackground"]   = "#c2185b99" |
  .colors["editorLineNumber.foreground"]        = "#b98a9c" |
  .colors["editorLineNumber.activeForeground"]  = "#c2185b" |
  .colors["editorCursor.foreground"]            = "#c2185b" |
  .colors["editorCursor.background"]            = "#faf4ec" |
  .colors["editor.lineHighlightBackground"]     = "#f5dce5" |
  .colors["editor.lineHighlightBorder"]         = "#f5dce500" |
  .colors["editor.selectionBackground"]         = "#f5dce5" |
  .colors["editor.selectionHighlightBackground"]= "#f5dce5" |
  .colors["editor.findMatchBackground"]         = "#ecd0da" |
  .colors["editor.findMatchHighlightBackground"]= "#ecd0da" |
  .colors["editor.findMatchBorder"]             = "#c2185b" |
  .colors["editor.wordHighlightBackground"]     = "#f5dce5" |
  .colors["editor.wordHighlightStrongBackground"]= "#f5dce5" |
  .colors["editorIndentGuide.background"]       = "#ecd0da" |
  .colors["editorIndentGuide.activeBackground"] = "#d9a3b6" |
  .colors["editorGutter.background"]            = "#00000000" |
  .colors["editorGutter.addedBackground"]       = "#1a7a3d" |
  .colors["editorGutter.modifiedBackground"]    = "#c2185b" |
  .colors["editorGutter.deletedBackground"]     = "#b3003c" |
  .colors["editorWidget.background"]            = "#fdf5f7" |
  .colors["editorWidget.border"]                = "#c2185b" |
  .colors["editorHoverWidget.background"]       = "#fdf5f7" |
  .colors["editorHoverWidget.border"]           = "#ecd0da" |
  .colors["editorSuggestWidget.background"]     = "#fdf5f7" |
  .colors["editorSuggestWidget.border"]         = "#ecd0da" |
  .colors["editorSuggestWidget.foreground"]     = "#8b0d47" |
  .colors["editorSuggestWidget.selectedBackground"] = "#f5dce5" |
  .colors["list.activeSelectionBackground"]     = "#f5dce5" |
  .colors["list.activeSelectionForeground"]     = "#8b0d47" |
  .colors["list.inactiveSelectionBackground"]   = "#f5dce5" |
  .colors["list.hoverBackground"]               = "#f5dce5" |
  .colors["list.focusBackground"]               = "#f5dce5" |
  .colors["list.focusForeground"]               = "#8b0d47" |
  .colors["list.highlightForeground"]           = "#c2185b" |
  .colors["list.invalidItemForeground"]         = "#b3003c" |
  .colors["list.errorForeground"]               = "#b3003c" |
  .colors["textLink.foreground"]                = "#c2185b" |
  .colors["textLink.activeForeground"]          = "#a01453" |
  .colors["badge.background"]                   = "#c2185b" |
  .colors["badge.foreground"]                   = "#ffffff" |
  .colors["progressBar.background"]             = "#c2185b" |
  .colors["errorForeground"]                    = "#b3003c" |
  .colors["editorError.foreground"]             = "#b3003c" |
  .colors["editorError.border"]                 = "#b3003c00" |
  .colors["editorWarning.foreground"]           = "#c2185b" |
  .colors["editorWarning.border"]               = "#c2185b00" |
  .colors["gitDecoration.modifiedResourceForeground"]  = "#c2185b" |
  .colors["gitDecoration.deletedResourceForeground"]   = "#b3003c" |
  .colors["gitDecoration.untrackedResourceForeground"] = "#1a7a3d" |
  .colors["gitDecoration.ignoredResourceForeground"]   = "#b98a9c" |
  .colors["terminal.foreground"]                = "#8b0d47" |
  .colors["terminal.background"]                = "#faf4ec" |
  .colors["terminal.ansiRed"]                   = "#b3003c" |
  .colors["terminal.ansiGreen"]                 = "#1a7a3d" |
  .colors["terminal.ansiYellow"]                = "#c2185b" |
  .colors["terminal.ansiBlue"]                  = "#8b0d47" |
  .colors["terminal.ansiMagenta"]               = "#c2185b" |
  .colors["terminal.ansiCyan"]                  = "#8b0d47" |
  .colors["terminalCursor.foreground"]          = "#c2185b" |
  .colors["terminalCursor.background"]          = "#faf4ec" |
  .colors["peekView.border"]                    = "#c2185b" |
  .colors["peekViewEditor.background"]          = "#f5dce5" |
  .colors["peekViewEditorGutter.background"]    = "#f5dce5" |
  .colors["peekViewResult.background"]          = "#faf4ec" |
  .colors["peekViewResult.selectionBackground"] = "#f5dce5" |
  .colors["peekViewTitle.background"]           = "#f2e6d9" |
  .colors["notifications.background"]           = "#fdf5f7" |
  .colors["notifications.border"]               = "#ecd0da" |
  .colors["notificationCenter.border"]          = "#ecd0da" |
  .colors["notificationToast.border"]           = "#ecd0da" |
  .colors["diffEditor.insertedTextBackground"]  = "#c8f0c850" |
  .colors["diffEditor.removedTextBackground"]   = "#ecd9e050" |
  .colors["symbolIcon.functionForeground"]      = "#c2185b" |
  .colors["symbolIcon.classForeground"]         = "#8b0d47" |
  .colors["symbolIcon.methodForeground"]        = "#c2185b" |
  .colors["symbolIcon.fileForeground"]          = "#b98a9c" |
  .colors["symbolIcon.folderForeground"]        = "#b98a9c" |
  .colors["charts.red"]                         = "#c2185b" |
  .colors["charts.blue"]                        = "#8b0d47" |
  .colors["charts.green"]                       = "#1a7a3d" |
  .colors["charts.purple"]                      = "#a01453" |
  .colors["charts.orange"]                      = "#c2185b" |
  .colors["charts.yellow"]                      = "#c2185b"
' "$LIGHT" > "$LIGHT.tmp" && mv "$LIGHT.tmp" "$LIGHT"

# ─── DARK ─────────────────────────────────────────────────
jq '
  .colors["editor.background"]                  = "#050000" |
  .colors["editor.foreground"]                  = "#ffb8c6" |
  .colors["foreground"]                         = "#ffb8c6" |
  .colors["sideBar.background"]                 = "#050000" |
  .colors["sideBar.foreground"]                 = "#ffb8c6" |
  .colors["activityBar.background"]             = "#0d0003" |
  .colors["activityBar.foreground"]             = "#ff003c" |
  .colors["activityBar.inactiveForeground"]     = "#6b0018" |
  .colors["activityBarBadge.background"]        = "#ff003c" |
  .colors["activityBarBadge.foreground"]        = "#050000" |
  .colors["statusBar.background"]               = "#ff003c" |
  .colors["statusBar.foreground"]               = "#050000" |
  .colors["statusBar.noFolderBackground"]       = "#ff003c" |
  .colors["statusBar.debuggingBackground"]      = "#b3002a" |
  .colors["titleBar.activeBackground"]          = "#0d0003" |
  .colors["titleBar.inactiveBackground"]        = "#0d0003" |
  .colors["titleBar.activeForeground"]          = "#ffb8c6" |
  .colors["titleBar.inactiveForeground"]        = "#6b0018" |
  .colors["tab.activeBackground"]               = "#0d0003" |
  .colors["tab.inactiveBackground"]             = "#050000" |
  .colors["tab.activeForeground"]               = "#ffb8c6" |
  .colors["tab.inactiveForeground"]             = "#6b0018" |
  .colors["tab.activeBorder"]                   = "#ff003c" |
  .colors["tab.activeBorderTop"]                = "#ff003c" |
  .colors["tab.border"]                         = "#1f0008" |
  .colors["editorGroup.border"]                 = "#1f0008" |
  .colors["editorGroupHeader.tabsBackground"]   = "#0d0003" |
  .colors["panel.background"]                   = "#050000" |
  .colors["panel.border"]                       = "#1f0008" |
  .colors["panelTitle.activeForeground"]        = "#ffb8c6" |
  .colors["panelTitle.inactiveForeground"]      = "#6b0018" |
  .colors["panelTitle.activeBorder"]            = "#ff003c" |
  .colors["dropdown.background"]                = "#0d0003" |
  .colors["dropdown.foreground"]                = "#ffb8c6" |
  .colors["dropdown.border"]                    = "#1f0008" |
  .colors["input.background"]                   = "#0d0003" |
  .colors["input.foreground"]                   = "#ffb8c6" |
  .colors["input.border"]                       = "#1f0008" |
  .colors["input.placeholderForeground"]        = "#6b0018" |
  .colors["inputOption.activeBorder"]           = "#ff003c" |
  .colors["button.background"]                  = "#ff003c" |
  .colors["button.foreground"]                  = "#050000" |
  .colors["button.hoverBackground"]             = "#ff6b8a" |
  .colors["button.secondaryBackground"]         = "#1f0008" |
  .colors["button.secondaryForeground"]         = "#ffb8c6" |
  .colors["focusBorder"]                        = "#ff003c" |
  .colors["widget.shadow"]                      = "#00000040" |
  .colors["scrollbar.shadow"]                   = "#00000030" |
  .colors["scrollbarSlider.background"]         = "#ff003c40" |
  .colors["scrollbarSlider.hoverBackground"]    = "#ff003c70" |
  .colors["scrollbarSlider.activeBackground"]   = "#ff003c99" |
  .colors["editorLineNumber.foreground"]        = "#6b0018" |
  .colors["editorLineNumber.activeForeground"]  = "#ff003c" |
  .colors["editorCursor.foreground"]            = "#ff003c" |
  .colors["editorCursor.background"]            = "#050000" |
  .colors["editor.lineHighlightBackground"]     = "#1f0008" |
  .colors["editor.lineHighlightBorder"]         = "#1f000800" |
  .colors["editor.selectionBackground"]         = "#ff003c55" |
  .colors["editor.selectionHighlightBackground"]= "#ff003c33" |
  .colors["editor.findMatchBackground"]         = "#1f0008" |
  .colors["editor.findMatchHighlightBackground"]= "#1f0008" |
  .colors["editor.findMatchBorder"]             = "#ff003c" |
  .colors["editor.wordHighlightBackground"]     = "#1f0008" |
  .colors["editor.wordHighlightStrongBackground"]= "#1f0008" |
  .colors["editorIndentGuide.background"]       = "#1f0008" |
  .colors["editorIndentGuide.activeBackground"] = "#3d000f" |
  .colors["editorGutter.background"]            = "#00000000" |
  .colors["editorGutter.addedBackground"]       = "#5fff9f" |
  .colors["editorGutter.modifiedBackground"]    = "#ff6b8a" |
  .colors["editorGutter.deletedBackground"]     = "#ff003c" |
  .colors["editorWidget.background"]            = "#0d0003" |
  .colors["editorWidget.border"]                = "#ff003c" |
  .colors["editorHoverWidget.background"]       = "#0d0003" |
  .colors["editorHoverWidget.border"]           = "#1f0008" |
  .colors["editorSuggestWidget.background"]     = "#0d0003" |
  .colors["editorSuggestWidget.border"]         = "#1f0008" |
  .colors["editorSuggestWidget.foreground"]     = "#ffb8c6" |
  .colors["editorSuggestWidget.selectedBackground"] = "#1f0008" |
  .colors["list.activeSelectionBackground"]     = "#1f0008" |
  .colors["list.activeSelectionForeground"]     = "#ffb8c6" |
  .colors["list.inactiveSelectionBackground"]   = "#1f0008" |
  .colors["list.hoverBackground"]               = "#1f0008" |
  .colors["list.focusBackground"]               = "#1f0008" |
  .colors["list.focusForeground"]               = "#ffb8c6" |
  .colors["list.highlightForeground"]           = "#ff003c" |
  .colors["list.invalidItemForeground"]         = "#ff003c" |
  .colors["list.errorForeground"]               = "#ff003c" |
  .colors["textLink.foreground"]                = "#ff003c" |
  .colors["textLink.activeForeground"]          = "#ff6b8a" |
  .colors["badge.background"]                   = "#ff003c" |
  .colors["badge.foreground"]                   = "#050000" |
  .colors["progressBar.background"]             = "#ff003c" |
  .colors["errorForeground"]                    = "#ff003c" |
  .colors["editorError.foreground"]             = "#ff003c" |
  .colors["editorWarning.foreground"]           = "#ff6b8a" |
  .colors["gitDecoration.modifiedResourceForeground"]  = "#ff6b8a" |
  .colors["gitDecoration.deletedResourceForeground"]   = "#ff003c" |
  .colors["gitDecoration.untrackedResourceForeground"] = "#5fff9f" |
  .colors["gitDecoration.ignoredResourceForeground"]   = "#6b0018" |
  .colors["terminal.foreground"]                = "#ffb8c6" |
  .colors["terminal.background"]                = "#050000" |
  .colors["terminal.ansiRed"]                   = "#ff003c" |
  .colors["terminal.ansiGreen"]                 = "#5fff9f" |
  .colors["terminal.ansiYellow"]                = "#ff6b8a" |
  .colors["terminal.ansiBlue"]                  = "#ffb8c6" |
  .colors["terminal.ansiMagenta"]               = "#ff6b8a" |
  .colors["terminal.ansiCyan"]                  = "#ffb8c6" |
  .colors["terminalCursor.foreground"]          = "#ff003c" |
  .colors["terminalCursor.background"]          = "#050000" |
  .colors["peekView.border"]                    = "#ff003c" |
  .colors["peekViewEditor.background"]          = "#1f0008" |
  .colors["peekViewEditorGutter.background"]    = "#1f0008" |
  .colors["peekViewResult.background"]          = "#0d0003" |
  .colors["peekViewResult.selectionBackground"] = "#1f0008" |
  .colors["peekViewTitle.background"]           = "#0d0003" |
  .colors["notifications.background"]           = "#0d0003" |
  .colors["notifications.border"]               = "#1f0008" |
  .colors["notificationCenter.border"]          = "#1f0008" |
  .colors["notificationToast.border"]           = "#1f0008" |
  .colors["diffEditor.insertedTextBackground"]  = "#001a0850" |
  .colors["diffEditor.removedTextBackground"]   = "#1a000550" |
  .colors["symbolIcon.functionForeground"]      = "#ff6b8a" |
  .colors["symbolIcon.classForeground"]         = "#ffb8c6" |
  .colors["symbolIcon.methodForeground"]        = "#ff003c" |
  .colors["symbolIcon.fileForeground"]          = "#6b0018" |
  .colors["symbolIcon.folderForeground"]        = "#6b0018" |
  .colors["charts.red"]                         = "#ff003c" |
  .colors["charts.blue"]                        = "#ffb8c6" |
  .colors["charts.green"]                       = "#5fff9f" |
  .colors["charts.purple"]                      = "#ff6b8a" |
  .colors["charts.orange"]                      = "#ff003c" |
  .colors["charts.yellow"]                      = "#ff6b8a"
' "$DARK" > "$DARK.tmp" && mv "$DARK.tmp" "$DARK"

# ─── tokenColors (sintaxis) ────────────────────────────────
# Para el LIGHT: sobreescribir los colores de cada scope con Kurumi
jq '
  (.tokenColors[] | select(.scope != null) | .settings.foreground) |= (
    if . == null then null
    elif . == "#4D4D4A" then "#8b0d47"
    elif . == "#0EAAAF" then "#8b0d47"
    elif . == "#0da661" then "#c2185b"
    elif . == "#117aa6" then "#8b0d47"
    elif . == "#5236B4" then "#c2185b"
    elif . == "#A62210" then "#c2185b"
    elif . == "#E356A7" then "#a01453"
    elif . == "#0d5fa6" then "#8b0d47"
    elif . == "#6272A4" then "#b98a9c"
    elif . == "#5282a2" then "#a01453"
    elif . == "#FF5555" then "#b3003c"
    else . end
  )
' "$LIGHT" > "$LIGHT.tmp" && mv "$LIGHT.tmp" "$LIGHT"

# Para el DARK
jq '
  (.tokenColors[] | select(.scope != null) | .settings.foreground) |= (
    if . == null then null
    elif . == "#F8F8F2" then "#ffb8c6"
    elif . == "#e2d9bd" then "#ffb8c6"
    elif . == "#39e6a6" then "#5fff9f"
    elif . == "#FFB86C" then "#ffb8c6"
    elif . == "#C04750" then "#ff003c"
    elif . == "#efa2da" then "#ff6b8a"
    elif . == "#34a7d1" then "#ffb8c6"
    elif . == "#a47272" then "#6b0018"
    elif . == "#b19e78" then "#6b0018"
    elif . == "#FF5555" then "#ff003c"
    else . end
  )
' "$DARK" > "$DARK.tmp" && mv "$DARK.tmp" "$DARK"

echo "✅ Temas reconstruidos con jq (por clave, sin romper transparencias)"

# Reiniciar VSCode
pkill -f "code" 2>/dev/null || true
sleep 2
code &
