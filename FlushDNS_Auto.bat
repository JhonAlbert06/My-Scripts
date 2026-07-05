@echo off
echo ================================
echo  Limpiando cache de DNS en Windows
echo ================================

:: Detener servicio de cache DNS
net stop dnscache

:: Iniciar servicio de cache DNS
net start dnscache

:: Limpiar cache DNS
ipconfig /flushdns

echo ================================
echo  Proceso completado correctamente
echo ================================
pause