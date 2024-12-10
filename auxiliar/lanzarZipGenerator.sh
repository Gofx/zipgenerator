#!/bin/bash

# Cambia al directorio del proyecto Maven
cd /../../../../zipgenerator/zipgenerator

# Ejecuta la aplicación Maven
mvn exec:java -D"exec.mainClass=com.bahiasoftware.ZipGenerator"