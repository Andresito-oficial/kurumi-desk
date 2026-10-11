#!/bin/bash
# vscode-doki-kurumi-v6.sh — asegura TODAS las claves de menús, popups y paletas

set -e

EXT_DIR=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" | sort -V | tail -1)
GEN="$EXT_DIR/generatedThemes"
LIGHT="$GEN/Tokisaki Kurumi.theme.json"
DARK="$GEN/Tokisaki Kurumi Dark.theme.json"

cp "$LIGHT" "$LIGHT.bak.v6"
cp "$DARK"  "$DARK.bak.v6"

# ─── LIGHT ───
jq '
  .colors["quickInput.background"]              = "#fdf5f7" |
  .colors["quickInput.foreground"]              = "#8b0d47" |
  .colors["quickInputList.focusBackground"]     = "#f5dce5" |
  .colors["quickInputList.focusForeground"]     = "#8b0d47" |
  .colors["quickInputList.focusHighlightForeground"] = "#c2185b" |
  .colors["quickInputList.focusIconForeground"] = "#8b0d47" |
  .colors["quickInputTitle.background"]         = "#f2e6d9" |
  .colors["menu.background"]                    = "#fdf5f7" |
  .colors["menu.foreground"]                    = "#8b0d47" |
  .colors["menu.border"]                        = "#ecd0da" |
  .colors["menu.selectionBackground"]           = "#f5dce5" |
  .colors["menu.selectionForeground"]           = "#8b0d47" |
  .colors["menu.selectionBorder"]               = "#c2185b" |
  .colors["menu.separatorBackground"]           = "#ecd0da" |
  .colors["menu.shadow"]                        = "#00000020" |
  .colors["menubar.selectionBackground"]        = "#f5dce5" |
  .colors["menubar.selectionForeground"]        = "#8b0d47" |
  .colors["menubar.selectionBorder"]            = "#c2185b" |
  .colors["listFilterWidget.background"]        = "#fdf5f7" |
  .colors["listFilterWidget.outline"]           = "#c2185b" |
  .colors["listFilterWidget.noMatchesOutline"]  = "#b3003c" |
  .colors["listFilterWidget.shadow"]            = "#00000020" |
  .colors["dropdown.background"]                = "#fdf5f7" |
  .colors["dropdown.foreground"]                = "#8b0d47" |
  .colors["dropdown.border"]                    = "#ecd0da" |
  .colors["dropdown.listBackground"]            = "#fdf5f7" |
  .colors["editorSuggestWidget.background"]     = "#fdf5f7" |
  .colors["editorSuggestWidget.border"]         = "#ecd0da" |
  .colors["editorSuggestWidget.foreground"]     = "#8b0d47" |
  .colors["editorSuggestWidget.selectedBackground"] = "#f5dce5" |
  .colors["editorSuggestWidget.selectedForeground"] = "#8b0d47" |
  .colors["editorSuggestWidget.highlightForeground"] = "#c2185b" |
  .colors["editorSuggestWidget.focusHighlightForeground"] = "#c2185b" |
  .colors["editorSuggestWidget.selectedIconForeground"] = "#8b0d47" |
  .colors["editorSuggestWidgetStatus.foreground"] = "#b98a9c" |
  .colors["editorHoverWidget.background"]       = "#fdf5f7" |
  .colors["editorHoverWidget.foreground"]       = "#8b0d47" |
  .colors["editorHoverWidget.border"]           = "#ecd0da" |
  .colors["editorHoverWidget.highlightForeground"] = "#c2185b" |
  .colors["editorHoverWidget.statusBarBackground"] = "#f9e0e6" |
  .colors["editorWidget.background"]            = "#fdf5f7" |
  .colors["editorWidget.foreground"]            = "#8b0d47" |
  .colors["editorWidget.border"]                = "#c2185b" |
  .colors["editorWidget.resizeBorder"]          = "#c2185b" |
  .colors["editorActionList.background"]        = "#fdf5f7" |
  .colors["editorActionList.foreground"]        = "#8b0d47" |
  .colors["editorActionList.focusBackground"]   = "#f5dce5" |
  .colors["editorActionList.focusForeground"]   = "#8b0d47" |
  .colors["list.activeSelectionIconForeground"] = "#8b0d47" |
  .colors["list.inactiveSelectionIconForeground"] = "#b98a9c" |
  .colors["list.focusOutline"]                  = "#c2185b" |
  .colors["list.focusAndSelectionOutline"]      = "#c2185b"
' "$LIGHT" > "$LIGHT.tmp" && mv "$LIGHT.tmp" "$LIGHT"

# ─── DARK ───
jq '
  .colors["quickInput.background"]              = "#0d0003" |
  .colors["quickInput.foreground"]              = "#ffb8c6" |
  .colors["quickInputList.focusBackground"]     = "#1f0008" |
  .colors["quickInputList.focusForeground"]     = "#ffb8c6" |
  .colors["quickInputList.focusHighlightForeground"] = "#ff003c" |
  .colors["quickInputList.focusIconForeground"] = "#ffb8c6" |
  .colors["quickInputTitle.background"]         = "#0d0003" |
  .colors["menu.background"]                    = "#0d0003" |
  .colors["menu.foreground"]                    = "#ffb8c6" |
  .colors["menu.border"]                        = "#1f0008" |
  .colors["menu.selectionBackground"]           = "#1f0008" |
  .colors["menu.selectionForeground"]           = "#ffb8c6" |
  .colors["menu.selectionBorder"]               = "#ff003c" |
  .colors["menu.separatorBackground"]           = "#1f0008" |
  .colors["menu.shadow"]                        = "#00000040" |
  .colors["menubar.selectionBackground"]        = "#1f0008" |
  .colors["menubar.selectionForeground"]        = "#ffb8c6" |
  .colors["menubar.selectionBorder"]            = "#ff003c" |
  .colors["listFilterWidget.background"]        = "#0d0003" |
  .colors["listFilterWidget.outline"]           = "#ff003c" |
  .colors["listFilterWidget.noMatchesOutline"]  = "#ff003c" |
  .colors["listFilterWidget.shadow"]            = "#00000040" |
  .colors["dropdown.background"]                = "#0d0003" |
  .colors["dropdown.foreground"]                = "#ffb8c6" |
  .colors["dropdown.border"]                    = "#1f0008" |
  .colors["dropdown.listBackground"]            = "#0d0003" |
  .colors["editorSuggestWidget.background"]     = "#0d0003" |
  .colors["editorSuggestWidget.border"]         = "#1f0008" |
  .colors["editorSuggestWidget.foreground"]     = "#ffb8c6" |
  .colors["editorSuggestWidget.selectedBackground"] = "#1f0008" |
  .colors["editorSuggestWidget.selectedForeground"] = "#ffb8c6" |
  .colors["editorSuggestWidget.highlightForeground"] = "#ff003c" |
  .colors["editorSuggestWidget.focusHighlightForeground"] = "#ff003c" |
  .colors["editorSuggestWidget.selectedIconForeground"] = "#ffb8c6" |
  .colors["editorSuggestWidgetStatus.foreground"] = "#6b0018" |
  .colors["editorHoverWidget.background"]       = "#0d0003" |
  .colors["editorHoverWidget.foreground"]       = "#ffb8c6" |
  .colors["editorHoverWidget.border"]           = "#1f0008" |
  .colors["editorHoverWidget.highlightForeground"] = "#ff003c" |
  .colors["editorHoverWidget.statusBarBackground"] = "#1f0008" |
  .colors["editorWidget.background"]            = "#0d0003" |
  .colors["editorWidget.foreground"]            = "#ffb8c6" |
  .colors["editorWidget.border"]                = "#ff003c" |
  .colors["editorWidget.resizeBorder"]          = "#ff003c" |
  .colors["editorActionList.background"]        = "#0d0003" |
  .colors["editorActionList.foreground"]        = "#ffb8c6" |
  .colors["editorActionList.focusBackground"]   = "#1f0008" |
  .colors["editorActionList.focusForeground"]   = "#ffb8c6" |
  .colors["list.activeSelectionIconForeground"] = "#ffb8c6" |
  .colors["list.inactiveSelectionIconForeground"] = "#6b0018" |
  .colors["list.focusOutline"]                  = "#ff003c" |
  .colors["list.focusAndSelectionOutline"]      = "#ff003c"
' "$DARK" > "$DARK.tmp" && mv "$DARK.tmp" "$DARK"

echo "══ LIGHT menu/quickInput keys ══"
jq -r '.colors | to_entries[] | select(.key | test("menu|quickInput|listFilter|dropdown")) | "\(.key) = \(.value)"' "$LIGHT"

echo ""
echo "══ DARK menu/quickInput keys ══"
jq -r '.colors | to_entries[] | select(.key | test("menu|quickInput|listFilter|dropdown")) | "\(.key) = \(.value)"' "$DARK"

pkill -f code 2>/dev/null || true
sleep 2
code &
