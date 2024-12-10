@echo off
REM Define variables
set "PROJECT_DIR=..\zipgenerator\zipgenerator\zipgenerator" 
set "MAIN_CLASS=com.bahiasoftware.ZipGenerator"         

REM Cambia ao directorio do proxecto
cd /d "%PROJECT_DIR%" || (
    echo Non se pode atopar o directorio: %PROJECT_DIR%
    exit /b 1
)

REM Executa a clase principal
echo Executando a clase principal: %MAIN_CLASS%
mvn exec:java -Dexec.mainClass="%MAIN_CLASS%"
if errorlevel 1 (
    echo Erro ao executar a clase principal.
    exit /b 1
)

echo Execución rematada con éxito!
