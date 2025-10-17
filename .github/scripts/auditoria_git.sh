#!/bin/bash
# ================================================
# Script: auditoria_git.sh
# Descripción: Genera un registro de los cambios entre commits
# Formato de salida:
#   [Modificado] Ruta: <carpeta> | Fichero: <archivo>
# ================================================

FECHA=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="auditoria_git.log"

echo "=== Auditoría - $FECHA ===" > "$LOG_FILE"

# Verificar si existe un commit anterior
if git rev-parse HEAD~1 >/dev/null 2>&1; then
  CAMBIOS=$(git diff --name-status HEAD~1 HEAD)
else
  echo "[Repositorio con un solo commit]" >> "$LOG_FILE"
  CAMBIOS=$(git diff-tree --no-commit-id --name-status -r HEAD)
fi

if [ -z "$CAMBIOS" ]; then
  echo "[Sin cambios detectados]" >> "$LOG_FILE"
else
  while read -r linea; do
    tipo=$(echo "$linea" | awk '{print $1}')
    archivo=$(echo "$linea" | awk '{print $2}')
    carpeta=$(dirname "$archivo")

    case "$tipo" in
      M) accion="Modificado" ;;
      A) accion="Agregado" ;;
      D) accion="Eliminado" ;;
      *) accion="Otro cambio ($tipo)" ;;
    esac

    echo "[$accion] Ruta: $carpeta | Fichero: $archivo" >> "$LOG_FILE"
  done <<< "$CAMBIOS"
fi

# Mostrar el resultado en consola
cat "$LOG_FILE"

# En entorno GitHub Actions, publicar el log como output
if [ -n "$GITHUB_OUTPUT" ]; then
  {
    echo "auditoria<<EOF"
    cat "$LOG_FILE"
    echo "EOF"
  } >> "$GITHUB_OUTPUT"
fi
