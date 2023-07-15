@echo off

REM 1. El script comienza estableciendo la variable DOWNLOADS_DIRECTORY con la ruta del directorio de descargas del usuario (%USERPROFILE%\Downloads).
set DOWNLOADS_DIRECTORY=%USERPROFILE%\Downloads

REM 2. Luego, el script verifica si los directorios Images, Documents, Videos, Music y Others existen en el directorio de descargas. Si no existen, el script los crea utilizando el comando mkdir.
if not exist "%DOWNLOADS_DIRECTORY%\Images\" mkdir "%DOWNLOADS_DIRECTORY%\Images"
if not exist "%DOWNLOADS_DIRECTORY%\Documents\" mkdir "%DOWNLOADS_DIRECTORY%\Documents"
if not exist "%DOWNLOADS_DIRECTORY%\Videos\" mkdir "%DOWNLOADS_DIRECTORY%\Videos"
if not exist "%DOWNLOADS_DIRECTORY%\Music\" mkdir "%DOWNLOADS_DIRECTORY%\Music"
if not exist "%DOWNLOADS_DIRECTORY%\Others\" mkdir "%DOWNLOADS_DIRECTORY%\Others"
if not exist "%DOWNLOADS_DIRECTORY%\Iso\" mkdir "%DOWNLOADS_DIRECTORY%\Iso"
if not exist "%DOWNLOADS_DIRECTORY%\Compressed\" mkdir "%DOWNLOADS_DIRECTORY%\Compressed"

REM 3. Luego, el script utiliza un bucle for para iterar a través de todos los archivos en el directorio de descargas. Para cada archivo, el script verifica si es un archivo regular utilizando el comando if exist.

REM 4. Si el archivo es un archivo regular, el script utiliza la expansión de parámetros ${file##*.} para extraer la extensión del archivo y la guarda en la variable extension.

REM 5. A continuación, el script utiliza una sentencia if-else para verificar la extensión del archivo y moverlo al directorio correspondiente según su extensión. Si la extensión no coincide con ninguno de los casos definidos, se mueve al directorio Others.

REM 6. El script utiliza el comando move para mover los archivos a sus respectivos directorios.

for %%F in ("%DOWNLOADS_DIRECTORY%\*") do (
    if exist "%%F" (
        set "file=%%~F"
        set "extension=!file:~-3!"
        if /i "!extension!"=="jpg" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Images\%%~nxF"
        ) else if /i "!extension!"=="png" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Images\%%~nxF"
        ) else if /i "!extension!"=="gif" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Images\%%~nxF"
        ) else if /i "!extension!"=="pdf" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Documents\%%~nxF"
        ) else if /i "!extension!"=="doc" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Documents\%%~nxF"
        ) else if /i "!extension!"=="docx" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Documents\%%~nxF"
        ) else if /i "!extension!"=="txt" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Documents\%%~nxF"
        ) else if /i "!extension!"=="ppt" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Documents\%%~nxF"
        ) else if /i "!extension!"=="pptx" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Documents\%%~nxF"
        ) else if /i "!extension!"=="mp4" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Videos\%%~nxF"
        ) else if /i "!extension!"=="avi" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Videos\%%~nxF"
        ) else if /i "!extension!"=="mov" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Videos\%%~nxF"
        ) else if /i "!extension!"=="wmv" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Videos\%%~nxF"
        ) else if /i "!extension!"=="mp3" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Music\%%~nxF"
        ) else if /i "!extension!"=="wav" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Music\%%~nxF"
        ) else if /i "!extension!"=="flac" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Music\%%~nxF"
        ) else if /i "!extension!"=="aac" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Music\%%~nxF"
        ) else if /i "!extension!"=="img" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Iso\%%~nxF"
        ) else if /i "!extension!"=="iso" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Iso\%%~nxF"
        ) else if /i "!extension!"=="rar" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Compressed\%%~nxF"
        ) else if /i "!extension!"=="zip" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Compressed\%%~nxF"
        ) else if /i "!extension!"=="7z" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Compressed\%%~nxF"
        ) else if /i "!extension!"=="gz" (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Compressed\%%~nxF"
        ) else (
            move /-Y "%%F" "%DOWNLOADS_DIRECTORY%\Others\%%~nxF"
        )
    )
)

REM Para ejecutar este script, simplemente guárdalo con una extensión .bat y ejecútalo haciendo doble clic en el archivo.
