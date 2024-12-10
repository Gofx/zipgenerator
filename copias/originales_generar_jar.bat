@echo off
REM Define variables
set "PROJECT_DIR=..\zipgenerator\zipgenerator\zipgenerator" 
set "MAIN_CLASS=com.bahiasoftware.ZipGenerator"
set "JAVA_HOME=C:\Program Files\Java\jdk1.8.0_65" 
set "PATH=%JAVA_HOME%\bin;%PATH%"      
set "OUTPUT_JAR=%PROJECT_DIR%\target\zipgenerator.jar"                  

echo Usando JDK en: %JAVA_HOME%         

REM Cambia ao directorio do proxecto
cd /d "%PROJECT_DIR%" || (
    echo Non se pode atopar o directorio: %PROJECT_DIR%
    exit /b 1
)

REM Limpa, compila e empaqueta o proxecto nun JAR
echo Xerando o arquivo JAR...
mvn clean package
if errorlevel 1 (
    echo Erro ao xerar o arquivo JAR.
    exit /b 1
)

REM Verifica que o JAR foi xerado
if not exist "%OUTPUT_JAR%" (
    echo Erro: O arquivo JAR non foi atopado en "%OUTPUT_JAR%".
    exit /b 1
)

REM echo Lanza a aplicación desde o JAR xerado
REM Lanzando a aplicación desde o JAR... Non o executa, porque a propia compilación pecha a execución
REM java -cp "%OUTPUT_JAR%" %MAIN_CLASS%
REM if errorlevel 1 (
REM    echo Erro ao executar a aplicación.
REM    exit /b 1
REM )



echo Execución rematada con éxito!
