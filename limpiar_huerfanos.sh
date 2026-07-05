#!/bin/bash
set -o pipefail

# ==============================
# CONFIGURACIÓN
# ==============================
DRY_RUN=true
ASSUME_YES=false
CLEAN_LOGS=false
TOTAL_KB=0
HUERFANOS=()
LOGS_TARGETS=()

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/limpiar_huerfanos.log"

APP_DIRS=("/Applications" "$HOME/Applications" "/System/Applications")

# 🛡️ Carpetas PROTEGIDAS (nunca borrar), además de com.apple.* (ver esta_protegido)
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

  # 🍎 Soporte del sistema sin prefijo com.apple.* (no son "apps" instalables)
  "iCloud"
  "icdd"
  "iLifeMediaBrowser"
  "locationaccessstored"
  "networkserviceproxy"

  # 🛠️ Cachés de herramientas de desarrollo (se recrean solas, pero por prudencia)
  "kotlin"
  "ngrok"
)

INSTALLED_BUNDLE_IDS=()
INSTALLED_NAMES=()

to_lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

# ==============================
# ARGUMENTOS
# ==============================
uso() {
  cat <<EOF
Uso: $(basename "$0") [opciones]

  --delete         Borra de verdad (por defecto solo simula)
  --dry-run        Fuerza modo simulación (por defecto)
  --logs           También limpia ~/Library/Logs (logs de usuario, no requiere sudo)
  -y, --yes        No pedir confirmación antes de borrar
  --log <archivo>  Ruta del log (por defecto: $LOG_FILE)
  -h, --help       Muestra esta ayuda
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --delete) DRY_RUN=false ;;
    --dry-run) DRY_RUN=true ;;
    --logs) CLEAN_LOGS=true ;;
    -y|--yes) ASSUME_YES=true ;;
    --log) LOG_FILE="$2"; shift ;;
    -h|--help) uso; exit 0 ;;
    *) echo "Opción desconocida: $1"; uso; exit 1 ;;
  esac
  shift
done

log() {
  echo "$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

# ==============================
# DETECCIÓN DE APPS INSTALADAS
# ==============================
recolectar_apps() {
  local base app plist bid name
  for base in "${APP_DIRS[@]}"; do
    [ -d "$base" ] || continue
    while IFS= read -r -d '' app; do
      plist="$app/Contents/Info.plist"
      [ -f "$plist" ] || continue
      bid=$(plutil -extract CFBundleIdentifier raw -o - "$plist" 2>/dev/null)
      name=$(basename "$app" .app)
      [ -n "$bid" ] && INSTALLED_BUNDLE_IDS+=("$bid")
      INSTALLED_NAMES+=("$name")
    done < <(find "$base" -maxdepth 1 -iname "*.app" -print0 2>/dev/null)
  done
}

# ⛔ com.apple.* son componentes del sistema, no "apps que instalaste": siempre protegidos
esta_protegido() {
  local name="$1"
  [[ "$name" == com.apple.* ]] && return 0
  local p
  for p in "${PROTEGIDOS[@]}"; do
    [[ "$name" == *"$p"* ]] && return 0
  done
  return 1
}

esta_instalado() {
  local name="$1" lower_name lower_app app_name bid

  # Coincidencia exacta de bundle id (típico en ~/Library/Containers)
  for bid in "${INSTALLED_BUNDLE_IDS[@]}"; do
    [ "$name" = "$bid" ] && return 0
  done

  lower_name=$(to_lower "$name")
  for app_name in "${INSTALLED_NAMES[@]}"; do
    lower_app=$(to_lower "$app_name")
    if [[ "$lower_name" == "$lower_app" || "$lower_name" == *"$lower_app"* || "$lower_app" == *"$lower_name"* ]]; then
      return 0
    fi
  done
  return 1
}

detectar_huerfanos() {
  local BASE="$1" dir name
  echo ""
  echo "🔍 Revisando $BASE"

  for dir in "$BASE"/*; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")

    if esta_protegido "$name"; then
      echo "🛡️  PROTEGIDO: $name"
      continue
    fi

    if esta_instalado "$name"; then
      echo "✅ Conservado: $name"
    else
      HUERFANOS+=("$dir")
    fi
  done
}

# ==============================
# LOGS DE USUARIO (--logs)
# ==============================
detectar_logs() {
  local BASE="$HOME/Library/Logs" entry
  [ -d "$BASE" ] || return
  echo ""
  echo "🔍 Revisando $BASE"
  for entry in "$BASE"/*; do
    [ -e "$entry" ] || continue
    LOGS_TARGETS+=("$entry")
  done
}

# ==============================
# EJECUCIÓN
# ==============================
echo "🚨 LIMPIEZA DE HUÉRFANOS"
echo "------------------------------------------"
echo "🧪 Modo simulación: $DRY_RUN"

recolectar_apps
detectar_huerfanos "$HOME/Library/Application Support"
detectar_huerfanos "$HOME/Library/Containers"
[ "$CLEAN_LOGS" = true ] && detectar_logs

echo ""
echo "📦 Huérfanos detectados: ${#HUERFANOS[@]}"
[ "$CLEAN_LOGS" = true ] && echo "🧹 Logs detectados: ${#LOGS_TARGETS[@]}"

for dir in "${HUERFANOS[@]}"; do
  size=$(du -sk "$dir" 2>/dev/null | awk '{print $1}')
  size=${size:-0}
  TOTAL_KB=$((TOTAL_KB + size))
  human=$(du -sh "$dir" 2>/dev/null | cut -f1)
  log "🧪 Candidato: $dir ($human)"
done

for dir in "${LOGS_TARGETS[@]}"; do
  size=$(du -sk "$dir" 2>/dev/null | awk '{print $1}')
  size=${size:-0}
  TOTAL_KB=$((TOTAL_KB + size))
  human=$(du -sh "$dir" 2>/dev/null | cut -f1)
  log "🧹 Log: $dir ($human)"
done

TOTAL_MB=$((TOTAL_KB / 1024))
if command -v bc >/dev/null 2>&1; then
  TOTAL_GB=$(echo "scale=2; $TOTAL_MB/1024" | bc)
else
  TOTAL_GB=$(awk -v mb="$TOTAL_MB" 'BEGIN{printf "%.2f", mb/1024}')
fi

echo ""
log "💾 Espacio potencial a liberar: ${TOTAL_MB} MB (~${TOTAL_GB} GB)"

TOTAL_ITEMS=$((${#HUERFANOS[@]} + ${#LOGS_TARGETS[@]}))

if [ "$TOTAL_ITEMS" -eq 0 ]; then
  log "✅ Nada que borrar."
  exit 0
fi

if [ "$DRY_RUN" = true ]; then
  log "🧪 Modo simulación: no se eliminó nada. Usa --delete para borrar de verdad."
  exit 0
fi

if [ "$ASSUME_YES" = false ]; then
  read -r -p "¿Eliminar $TOTAL_ITEMS elementos (~${TOTAL_GB} GB)? [s/N] " resp
  case "$resp" in
    [sS]|[sS][iI]) ;;
    *) echo "Cancelado."; exit 0 ;;
  esac
fi

for dir in "${HUERFANOS[@]}"; do
  log "🗑️  Eliminando: $dir"
  rm -rf "$dir"
done

for dir in "${LOGS_TARGETS[@]}"; do
  log "🗑️  Eliminando log: $dir"
  rm -rf "$dir"
done

log "🔥 Limpieza completada"
