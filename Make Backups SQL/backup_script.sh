#!/bin/bash

# Configuración de la base de datos
DB_USER="root"
DB_PASSWORD="asd343dd)ksd3dd{][dw[dapsdpw]dp2454{d45wdfPDGRDeP[#d"
DB_NAME="caregiver"

# Directorio de respaldo
BACKUP_DIR="/home/deploy/backups"

# Nombre del archivo de respaldo con fecha y hora actual
BACKUP_FILE="$BACKUP_DIR/caregiver-$(date +\%Y\%m\%d-\%H\%M\%S).sql"

# Comando mysqldump para realizar el respaldo
mysqldump -u$DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_FILE

# Verificar si el respaldo se realizó correctamente
if [ $? -eq 0 ]; then
    echo "Respaldo exitoso. Archivo: $BACKUP_FILE"
else
    echo "Error al realizar el respaldo."
fi
