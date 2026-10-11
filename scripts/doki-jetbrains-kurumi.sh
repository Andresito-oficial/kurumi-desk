#!/bin/bash
set -e

WORKDIR=/tmp/doki-jetbrains
cd "$WORKDIR"

SRC="extracted/doki/themes/darling_in_the_franxx"
DEST="extracted/doki/themes/date_a_live"
mkdir -p "$DEST"

UUID_L="7a8c3e21-4b5f-4d9a-8e2c-1f6b3a9d7c04"
UUID_D="9d2f6b14-7e3a-4c81-b5d2-8a1e4c7f9035"

echo "══ Copiando archivos base ══"
for ext in theme.json theme.meta.json xml; do
    cp "${SRC}/Zero_Two_Light_Sakura.${ext}" "${DEST}/Tokisaki_Kurumi.${ext}"
    cp "${SRC}/Zero_Two_Dark_Rose.${ext}"    "${DEST}/Tokisaki_Kurumi_Dark.${ext}"
done
echo "✅ 6 archivos copiados"

echo ""
echo "══ Modificando LIGHT ══"

L_THEME="${DEST}/Tokisaki_Kurumi.theme.json"
L_META="${DEST}/Tokisaki_Kurumi.theme.meta.json"
L_XML="${DEST}/Tokisaki_Kurumi.xml"

# 1. Metadata básica
for f in "$L_THEME" "$L_META"; do
    jq --arg id "$UUID_L" \
       --arg name "Date A Live: Tokisaki Kurumi" \
       --arg display "Tokisaki Kurumi" \
       --arg scheme "/doki/themes/date_a_live/Tokisaki_Kurumi.xml" \
       '.id = $id | .name = $name | .displayName = $display |
        .author = "Andrés" | .editorScheme = $scheme |
        .group = "Date A Live" |
        del(.stickers) | del(.backgrounds)' \
       "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done

# 2. Colores en theme.json
jq '
  .colors["accentColor"]          = "#c2185b" |
  .colors["accentColorTransparent"] = "#c2185b5A" |
  .colors["accentColorLessTransparent"] = "#c2185b9A" |
  .colors["accentColorMoreTransparent"] = "#c2185b2A" |
  .colors["accentContrastColor"]  = "#ffffff" |
  .colors["baseBackground"]       = "#faf4ec" |
  .colors["textEditorBackground"] = "#ffffff" |
  .colors["headerColor"]          = "#f2e6d9" |
  .colors["secondaryBackground"]  = "#f2e6d9" |
  .colors["caretRow"]             = "#f5dce5" |
  .colors["highlightColor"]       = "#f5dce5" |
  .colors["foldedTextBackground"] = "#ecd0da" |
  .colors["borderColor"]          = "#ecd0da" |
  .colors["buttonColor"]          = "#fceef3" |
  .colors["buttonFont"]           = "#8b0d47" |
  .colors["foregroundColor"]      = "#8b0d47" |
  .colors["foregroundColorEditor"]= "#8b0d47" |
  .colors["selectionForeground"]  = "#8b0d47" |
  .colors["selectionBackground"]  = "#f5dce5" |
  .colors["selectionBackgroundTransparent"] = "#f5dce533" |
  .colors["selectionInactive"]    = "#f5dce5" |
  .colors["identifierHighlight"]  = "#f5dce5" |
  .colors["comments"]             = "#b98a9c" |
  .colors["classNameColor"]       = "#a01453" |
  .colors["editorAccentColor"]    = "#c2185b" |
  .colors["constantColor"]        = "#8b0d47" |
  .colors["htmlTagColor"]         = "#c2185b" |
  .colors["keywordColor"]         = "#c2185b" |
  .colors["stringColor"]          = "#a01453" |
  .colors["keyColor"]             = "#8b0d47" |
  .colors["infoForeground"]       = "#b98a9c" |
  .colors["lineNumberColor"]      = "#b98a9c" |
  .colors["unusedColor"]          = "#d9a3b6" |
  .colors["disabledColor"]        = "#b98a9c" |
  .colors["baseIconColor"]        = "#b98a9c" |
  .colors["dokiLogoAccent"]       = "#c2185b" |
  .colors["dokiLogoAccentContrast"] = "#8b0d47" |
  .colors["startColor"]           = "#c2185b" |
  .colors["stopColor"]            = "#a01453" |
  .colors["errorColor"]           = "#b3003c" |
  .colors["contrastColor"]        = "#f5dce5" |
  .colors["breakpointActiveColor"]= "#c8f0c8" |
  .colors["breakpointColor"]      = "#fcf2c5" |
  .colors["codeBlock"]            = "#f2e6d9" |
  .colors["testScopeColor"]       = "#faf4ec" |
  .colors["nonProjectFileScopeColor"] = "#faf4ec" |
  .colors["diff.conflict"]        = "#f4b3c3" |
  .colors["diff.deleted"]         = "#ecd9e0" |
  .colors["diff.inserted"]        = "#c8f0c8" |
  .colors["diff.modified"]        = "#c4e6f6" |
  .colors["lightEditorColor"]     = "#f5eef2" |
  .colors["popupMask"]            = "#fbf3f230" |
  .colors["searchBackground"]     = "#c2185b" |
  .colors["searchForeground"]     = "#ffffff" |
  .colors["tagColor"]             = "#7A7A7A" |
  .colors["ghostColor"]           = "#FFFFFF00" |
  .colors["terminal.ansiRed"]     = "#b3003c" |
  .colors["terminal.ansiGreen"]   = "#1a7a3d" |
  .colors["terminal.ansiYellow"]  = "#c2185b" |
  .colors["terminal.ansiBlue"]    = "#8b0d47" |
  .colors["terminal.ansiMagenta"] = "#c2185b" |
  .colors["terminal.ansiCyan"]    = "#8b0d47" |
  .colors["fileBlue"]             = "#d4e3f8" |
  .colors["fileGray"]             = "#e4dddd" |
  .colors["fileOrange"]           = "#f7d1b1" |
  .colors["filePurple"]           = "#d2b3ea" |
  .colors["fileRed"]              = "#f0b4b3" |
  .colors["fileRose"]             = "#f3c9db" |
  .colors["fileViolet"]           = "#efd8f5" |
  .colors["fileYellow"]           = "#f1e9b8" |
  .colors["iconAccent"]           = "#c2185b" |
  .colors["iconAccentCompliment"] = "#a01453" |
  .colors["iconBaseBlend"]        = "#b98a9c" |
  .colors["iconBlendCompliment"]  = "#c2185b" |
  .colors["iconBlendContrast"]    = "#faf4ec" |
  .colors["iconDiversification"]  = "#c2185b" |
  .colors["iconError"]            = "#b3003c" |
  .colors["iconSecondaryBlend"]   = "#a01453"
' "$L_THEME" > "$L_THEME.tmp" && mv "$L_THEME.tmp" "$L_THEME"

# 3. Reemplazar colores hardcoded en ui de theme.json
sed -i \
  -e 's/#CBFFCE/#c8f0c8/g' \
  -e 's/#ffffff/#ffffff/g' \
  -e 's/#a67a21/#c2185b/g' \
  -e 's/#704745/#8b0d47/g' \
  -e 's/#33412e/#8b0d47/g' \
  -e 's/#5a5221/#8b0d47/g' \
  "$L_THEME"

# 4. Reemplazar en meta.json (mismos colors)
cp "$L_THEME" /tmp/light_colors.json
jq --slurpfile src /tmp/light_colors.json '.colors = $src[0].colors' \
   "$L_META" > "$L_META.tmp" && mv "$L_META.tmp" "$L_META"

# 5. Reemplazar en el XML
sed -i \
  -e 's/name="Zero Two Light Sakura"/name="Tokisaki Kurumi"/' \
  -e 's/A62210/c2185b/g' \
  -e 's/ffeaf2/faf4ec/g' \
  -e 's/ffe6ee/ffffff/g' \
  -e 's/ffe5ef/f2e6d9/g' \
  -e 's/ffdeeb/f2e6d9/g' \
  -e 's/ffdbe5/f5dce5/g' \
  -e 's/ffdce7/f5dce5/g' \
  -e 's/ffcfde/ecd0da/g' \
  -e 's/f6c2d5/ecd0da/g' \
  -e 's/ffd1e2/fceef3/g' \
  -e 's/252427/8b0d47/g' \
  -e 's/4D4D4A/8b0d47/g' \
  -e 's/393d45/8b0d47/g' \
  -e 's/c1e9d4/f5dce5/g' \
  -e 's/e2e7e2/f5dce5/g' \
  -e 's/E3E8DE/f5dce5/g' \
  -e 's/99717E/b98a9c/g' \
  -e 's/0F9497/a01453/g' \
  -e 's/109757/c2185b/g' \
  -e 's/0d5fa6/8b0d47/g' \
  -e 's/117aa6/c2185b/g' \
  -e 's/5236B4/c2185b/g' \
  -e 's/E356A7/a01453/g' \
  -e 's/42a373/b98a9c/g' \
  -e 's/BB9BB1/b98a9c/g' \
  -e 's/B69DA2/d9a3b6/g' \
  -e 's/d9abbb/b98a9c/g' \
  -e 's/93727c/b98a9c/g' \
  -e 's/38a879/c2185b/g' \
  -e 's/185a3d/8b0d47/g' \
  -e 's/a01618/c2185b/g' \
  -e 's/ec081e/a01453/g' \
  -e 's/ff5555/b3003c/g' \
  -e 's/cff5de/f5dce5/g' \
  -e 's/e3ead1/c8f0c8/g' \
  -e 's/ffe8dd/fcf2c5/g' \
  -e 's/f1e4f6/f2e6d9/g' \
  -e 's/ecf5e6/faf4ec/g' \
  -e 's/F89DA6/f4b3c3/g' \
  -e 's/ECDDE6/ecd9e0/g' \
  -e 's/CBFFCE/c8f0c8/g' \
  -e 's/9FE5FF/c4e6f6/g' \
  -e 's/f5f1f8/f5eef2/g' \
  -e 's/faf5e0/faf4ec/g' \
  -e 's/F1B0E7/c2185b/g' \
  -e 's/0896AD/8b0d47/g' \
  -e 's/3ab55b/1a7a3d/g' \
  -e 's/9B6BDF/8b0d47/g' \
  -e 's/db974d/c2185b/g' \
  -e 's/E64747/c2185b/g' \
  "$L_XML"

echo "✅ Light modificado"

echo ""
echo "══ Modificando DARK ══"

D_THEME="${DEST}/Tokisaki_Kurumi_Dark.theme.json"
D_META="${DEST}/Tokisaki_Kurumi_Dark.theme.meta.json"
D_XML="${DEST}/Tokisaki_Kurumi_Dark.xml"

for f in "$D_THEME" "$D_META"; do
    jq --arg id "$UUID_D" \
       --arg name "Date A Live: Tokisaki Kurumi Dark" \
       --arg display "Tokisaki Kurumi Dark" \
       --arg scheme "/doki/themes/date_a_live/Tokisaki_Kurumi_Dark.xml" \
       '.id = $id | .name = $name | .displayName = $display |
        .author = "Andrés" | .editorScheme = $scheme |
        .group = "Date A Live" |
        del(.stickers) | del(.backgrounds)' \
       "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done

jq '
  .colors["accentColor"]          = "#ff003c" |
  .colors["accentColorTransparent"] = "#ff003c5A" |
  .colors["accentColorLessTransparent"] = "#ff003c9A" |
  .colors["accentColorMoreTransparent"] = "#ff003c2A" |
  .colors["accentContrastColor"]  = "#050000" |
  .colors["baseBackground"]       = "#050000" |
  .colors["textEditorBackground"] = "#0d0003" |
  .colors["headerColor"]          = "#0d0003" |
  .colors["secondaryBackground"]  = "#0d0003" |
  .colors["caretRow"]             = "#1f0008" |
  .colors["highlightColor"]       = "#1f0008" |
  .colors["foldedTextBackground"] = "#140005" |
  .colors["borderColor"]          = "#1f0008" |
  .colors["buttonColor"]          = "#140005" |
  .colors["buttonFont"]           = "#ffb8c6" |
  .colors["foregroundColor"]      = "#ffb8c6" |
  .colors["foregroundColorEditor"]= "#ffb8c6" |
  .colors["selectionForeground"]  = "#050000" |
  .colors["selectionBackground"]  = "#1f0008" |
  .colors["selectionBackgroundTransparent"] = "#1f000833" |
  .colors["selectionInactive"]    = "#1f0008" |
  .colors["identifierHighlight"]  = "#1f0008" |
  .colors["comments"]             = "#6b0018" |
  .colors["classNameColor"]       = "#ffb8c6" |
  .colors["editorAccentColor"]    = "#5fff9f" |
  .colors["constantColor"]        = "#ffb8c6" |
  .colors["htmlTagColor"]         = "#ffb8c6" |
  .colors["keywordColor"]         = "#ff003c" |
  .colors["stringColor"]          = "#ff6b8a" |
  .colors["keyColor"]             = "#ffb8c6" |
  .colors["infoForeground"]       = "#ff6b8a" |
  .colors["lineNumberColor"]      = "#6b0018" |
  .colors["unusedColor"]          = "#6b0018" |
  .colors["disabledColor"]        = "#6b0018" |
  .colors["baseIconColor"]        = "#6b0018" |
  .colors["dokiLogoAccent"]       = "#ff003c" |
  .colors["dokiLogoAccentContrast"] = "#ff6b8a" |
  .colors["startColor"]           = "#ff003c" |
  .colors["stopColor"]            = "#ff6b8a" |
  .colors["errorColor"]           = "#ff003c" |
  .colors["contrastColor"]        = "#1f0008" |
  .colors["breakpointActiveColor"]= "#0a2a10" |
  .colors["breakpointColor"]      = "#1a0005" |
  .colors["codeBlock"]            = "#0d0003" |
  .colors["testScopeColor"]       = "#0a0002" |
  .colors["nonProjectFileScopeColor"] = "#0a0002" |
  .colors["diff.conflict"]        = "#3d000f" |
  .colors["diff.deleted"]         = "#1a0005" |
  .colors["diff.inserted"]        = "#001a08" |
  .colors["diff.modified"]        = "#001a3d" |
  .colors["lightEditorColor"]     = "#0d0003" |
  .colors["popupMask"]            = "#8d7fc109" |
  .colors["searchBackground"]     = "#ff003c" |
  .colors["searchForeground"]     = "#050000" |
  .colors["tagColor"]             = "#7A7A7A" |
  .colors["ghostColor"]           = "#FFFFFF00" |
  .colors["terminal.ansiRed"]     = "#ff003c" |
  .colors["terminal.ansiGreen"]   = "#5fff9f" |
  .colors["terminal.ansiYellow"]  = "#ff6b8a" |
  .colors["terminal.ansiBlue"]    = "#ffb8c6" |
  .colors["terminal.ansiMagenta"] = "#ff6b8a" |
  .colors["terminal.ansiCyan"]    = "#ffb8c6" |
  .colors["fileBlue"]             = "#1a1a3d" |
  .colors["fileGray"]             = "#1a0a0a" |
  .colors["fileOrange"]           = "#3d1a0a" |
  .colors["filePurple"]           = "#2a0a2a" |
  .colors["fileRed"]              = "#3d0a0a" |
  .colors["fileRose"]             = "#3d0a1a" |
  .colors["fileViolet"]           = "#2a0a3d" |
  .colors["fileYellow"]           = "#3d3a0a" |
  .colors["iconAccent"]           = "#ff003c" |
  .colors["iconAccentCompliment"] = "#ff6b8a" |
  .colors["iconBaseBlend"]        = "#6b0018" |
  .colors["iconBlendCompliment"]  = "#ff6b8a" |
  .colors["iconBlendContrast"]    = "#050000" |
  .colors["iconDiversification"]  = "#ff6b8a" |
  .colors["iconError"]            = "#ff003c" |
  .colors["iconSecondaryBlend"]   = "#ff6b8a"
' "$D_THEME" > "$D_THEME.tmp" && mv "$D_THEME.tmp" "$D_THEME"

sed -i \
  -e 's/#CBFFCE/#001a08/g' \
  -e 's/#a67a21/#ff6b8a/g' \
  -e 's/#704745/#ffb8c6/g' \
  -e 's/#33412e/#ffb8c6/g' \
  -e 's/#5a5221/#ffb8c6/g' \
  "$D_THEME"

# Copiar colors al meta
cp "$D_THEME" /tmp/dark_colors.json
jq --slurpfile src /tmp/dark_colors.json '.colors = $src[0].colors' \
   "$D_META" > "$D_META.tmp" && mv "$D_META.tmp" "$D_META"

sed -i \
  -e 's/name="Zero Two Dark Rose"/name="Tokisaki Kurumi Dark"/' \
  -e 's/e4dad4/ff003c/g' \
  -e 's/310f0f/050000/g' \
  -e 's/300d0e/0d0003/g' \
  -e 's/330f10/0d0003/g' \
  -e 's/330e0e/0d0003/g' \
  -e 's/3c1616/0d0003/g' \
  -e 's/481818/1f0008/g' \
  -e 's/531e1e/1f0008/g' \
  -e 's/461819/1f0008/g' \
  -e 's/3c1414/1f0008/g' \
  -e 's/271c21/ffb8c6/g' \
  -e 's/F8F8F2/ffb8c6/g' \
  -e 's/fbfbfb/050000/g' \
  -e 's/efefef/ffb8c6/g' \
  -e 's/b19e78/ff6b8a/g' \
  -e 's/a87975/6b0018/g' \
  -e 's/6f4f4a/6b0018/g' \
  -e 's/815f59/6b0018/g' \
  -e 's/a47272/6b0018/g' \
  -e 's/34a7d1/ffb8c6/g' \
  -e 's/FFB86C/ffb8c6/g' \
  -e 's/C04750/ff003c/g' \
  -e 's/efa2da/ff6b8a/g' \
  -e 's/39e6a6/5fff9f/g' \
  -e 's/e2d9bd/ffb8c6/g' \
  -e 's/FF5555/ff003c/g' \
  -e 's/1ecd86/ff003c/g' \
  -e 's/26ee65/ff6b8a/g' \
  -e 's/268B61/ff003c/g' \
  -e 's/3c1818/1f0008/g' \
  -e 's/102d0e/001a08/g' \
  -e 's/1c2331/001a3d/g' \
  -e 's/412a2b/1a0005/g' \
  -e 's/57171a/3d000f/g' \
  -e 's/6a539a/ff003c/g' \
  -e 's/42E66C/5fff9f/g' \
  -e 's/75D7EC/ffb8c6/g' \
  -e 's/9B6BDF/ffb8c6/g' \
  -e 's/E356A7/ff6b8a/g' \
  -e 's/E64747/ff003c/g' \
  -e 's/EFA554/ff6b8a/g' \
  "$D_XML"

echo "✅ Dark modificado"

echo ""
echo "══ Reempaquetando JAR ══"

JAR_ORIG=~/.local/share/JetBrains/IntelliJIdea2026.2/doki-theme-jetbrains/lib/doki-theme-jetbrains-88.5-1.16.5.jar
JAR_BACKUP="${JAR_ORIG}.bak-$(date +%Y%m%d-%H%M%S)"
cp "$JAR_ORIG" "$JAR_BACKUP"
echo "✅ Backup: $JAR_BACKUP"

# Añadir los nuevos archivos al JAR
cd extracted
zip -r "$JAR_ORIG" doki/themes/date_a_live/
cd ..

echo ""
echo "══ Verificando ══"
unzip -l "$JAR_ORIG" | grep -i "date_a_live"

echo ""
echo "✅ Hecho."
echo ""
echo "Reinicia IntelliJ y busca los temas en:"
echo "  Settings → Appearance & Behavior → Appearance → Theme"
echo "  Deberían aparecer 'Tokisaki Kurumi' y 'Tokisaki Kurumi Dark'"
