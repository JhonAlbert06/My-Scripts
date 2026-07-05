#!/bin/bash

# ==============================
# CONFIGURACIÓN
# ==============================
SIMULACION=true   # true = NO borra | false = BORRA de verdad
TOTAL_KB=0


echo "🚨 LIMPIEZA AUTOMÁTICA DE HUÉRFANOS (SEGURO)"
echo "------------------------------------------"
echo "🧪 Modo simulación: $SIMULACION"

# Apps instaladas
APPS=$(ls /Applications 2>/dev/null; ls ~/Applications 2>/dev/null)

# 🛡️ Carpetas PROTEGIDAS (nunca borrar)
PROTEGIDOS=(
  "Docker"
  "com.docker.docker"
  "group.com.docker"
  "com.docker.helper"
  "com.docker.vmnetd"

  # 🌐 Navegadores (NO TOCAR)
  "Chrome"
  "Google Chrome"
  "com.google.Chrome"
  "Firefox"
  "org.mozilla.firefox"
  "Safari"
  "com.apple.Safari"
  "Edge"
  "Microsoft Edge"
  "com.microsoft.edgemac"
  "Brave"
  "com.brave.Browser"
  "Opera"
  "com.operasoftware.Opera"
)


function esta_protegido() {
  local name="$1"
  for p in "${PROTEGIDOS[@]}"; do
    [[ "$name" == *"$p"* ]] && return 0
  done
  return 1
}

function borrar() {
  local dir="$1"

  # Calcular tamaño en KB
  size=$(du -sk "$dir" 2>/dev/null | awk '{print $1}')
  size=${size:-0}

  TOTAL_KB=$((TOTAL_KB + size))

  if [ "$SIMULACION" = true ]; then
    echo "🧪 [SIMULACIÓN] Se eliminaría: $dir ($(du -sh "$dir" 2>/dev/null | cut -f1))"
  else
    echo "🗑️  Eliminando: $dir ($(du -sh "$dir" 2>/dev/null | cut -f1))"
    sudo rm -rf "$dir"
  fi
}

function limpiar_directorio() {
  local BASE="$1"
  echo ""
  echo "🔍 Revisando $BASE"

  for dir in "$BASE"/*; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")

    # ⛔ Nunca borrar protegidos
    if esta_protegido "$name"; then
      echo "🛡️  PROTEGIDO: $name"
      continue
    fi

    if ! echo "$APPS" | grep -iq "$name"; then
      borrar "$dir"
    else
      echo "✅ Conservado: $name"
    fi
  done
}

# ==============================
# EJECUCIÓN
# ==============================
limpiar_directorio "$HOME/Library/Application Support"
limpiar_directorio "$HOME/Library/Containers"

echo ""
echo "🔥 Limpieza completada (Docker intacto)"


echo ""
echo "📊 Calculando espacio total..."

# Convertir a formato legible
TOTAL_MB=$((TOTAL_KB / 1024))
TOTAL_GB=$(echo "scale=2; $TOTAL_MB/1024" | bc)

echo "💾 Espacio potencial a liberar:"
echo "➡️  ${TOTAL_MB} MB (~${TOTAL_GB} GB)"

