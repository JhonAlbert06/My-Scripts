#!/bin/bash

# Dirección IP o nombre de host del servidor
SERVER="direccion_del_servidor"

# Nombre de usuario para acceder al servidor
USERNAME="nombre_de_usuario"

# Carpetas en el servidor que deseas copiar
FOLDERS=("backups" "files" "script")

# Ruta local donde deseas copiar las carpetas
LOCAL_FOLDER="/ruta/a/la/carpeta/local"

# Copiar cada carpeta desde el servidor al local
for folder in "${FOLDERS[@]}"; do
    scp -r "$USERNAME@$SERVER:/home/deploy/$folder" "$LOCAL_FOLDER"
    if [ $? -eq 0 ]; then
        echo "La carpeta $folder se copió exitosamente desde el servidor."
    else
        echo "Hubo un error al copiar la carpeta $folder desde el servidor."
    fi
done
