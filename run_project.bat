@echo off

REM Define variables
set "COMPILAR=auxiliar\generar_jar.bat"
set "ORIGEN=%~dp0"
set "PROJECT_DIR=..\zipgenerator\zipgenerator\zipgenerator\target" 
set "MAIN_CLASS=com.bahiasoftware.ZipGenerator"         

REM Lanzamos antes o script de compilación
echo [INFO] Iniciando a compilacion dende o script generar_jar...
call %COMPILAR%

REM Cambia ao directorio do proxecto
cd /d "%ORIGEN%" || (
    echo [ERROR] Non se pode atopar o directorio: %ORIGEN%
    exit /b 1
)

REM Posicionase na carpeta donde vai executar o jar
cd /d "%PROJECT_DIR%" || (
    echo [ERROR] Non se pode atopar o directorio: %PROJECT_DIR%
    exit /b 1
)

REM Executa a clase principal
echo [INFO] Executando a clase principal: %MAIN_CLASS%
mvn exec:java -Dexec.mainClass="%MAIN_CLASS%"
if errorlevel 1 (
    echo [ERROR] Erro ao executar a clase principal.
    exit /b 1
)

REM Volvemos a posicionarnos na carpeta donde estan estos scripts, por si é necesario volver a lanzar a aplicación
cd /d "%ORIGEN%" || (
    echo [ERROR] Non se pode atopar o directorio: %ORIGEN%
    exit /b 1
)

echo [INFO] Execución rematada con éxito!
