@echo off

REM Define variables
set "PROJECT_DIR=..\zipgenerator\zipgenerator\zipgenerator" 
set "MAIN_CLASS=com.bahiasoftware.ZipGenerator"
set "JAVA_HOME=C:\Program Files\Java\jdk1.8.0_65" 
set "PATH=%JAVA_HOME%\bin;%PATH%"      
set "OUTPUT_JAR=%PROJECT_DIR%\target\zipgenerator.jar"  
               
echo [INFO] Usando o JDK existente en: %JAVA_HOME%. 

if not exist "%JAVA_HOME%" (       
    echo [ERROR] O jdk que compila a aplicacion non existe en "%JAVA_HOME%".
    exit /b 1
)

REM Cambia ao directorio do proxecto
cd /d "%PROJECT_DIR%" || (
    echo [ERROR] Non se pode atopar o directorio: %PROJECT_DIR%.
    exit /b 1
)

REM Limpa, compila e empaqueta o proxecto nun JAR
echo [INFO] Xerando o jar da aplicacion...
mvn clean package
if errorlevel 1 (
    echo [ERROR] Erro ao xerar o jar.
    exit /b 1
)

REM Verifica que o JAR foi xerado
if not exist "%OUTPUT_JAR%" (
    echo [ERROR] O arquivo jar non foi atopado en "%OUTPUT_JAR%".
    exit /b 1
)
