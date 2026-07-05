@echo off
echo =====================================
echo  REPARANDO Y LIMPIANDO CONFIGURACION DE RED
echo =====================================

:: Limpiar cache DNS
echo [1/6] Limpiando cache DNS...
ipconfig /flushdns

:: Reiniciar servicio DNS (si aplica)
echo [2/6] Reiniciando servicio Cliente DNS...
net stop dnscache
net start dnscache

:: Limpiar cache ARP
echo [3/6] Limpiando cache ARP...
arp -d *

:: Limpiar cache NetBIOS
echo [4/6] Limpiando cache NetBIOS...
nbtstat -R
nbtstat -RR

:: Resetear Winsock
echo [5/6] Reiniciando Winsock...
netsh winsock reset

:: Resetear configuracion TCP/IP
echo [6/6] Reiniciando configuracion TCP/IP...
netsh int ip reset

:: Renovar direccion IP
echo Renovando direccion IP...
ipconfig /release
ipconfig /renew

echo =====================================
echo  PROCESO FINALIZADO
echo  El sistema se reiniciara automaticamente en 10 segundos...
echo =====================================

timeout /t 10 /nobreak >nul
shutdown /r /f /t 0