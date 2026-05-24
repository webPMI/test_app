#!/usr/bin/env bash

# Colores para salida en consola
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${CYAN}${BOLD}=== Iniciando Análisis Estático y Formateo ===${NC}"

# 1. Verificar formateo de código
echo -e "\n${YELLOW}1. Comprobando formateo de código (dart format)...${NC}"
dart format --output=none --set-exit-if-changed .
FORMAT_RESULT=$?

if [ $FORMAT_RESULT -eq 0 ]; then
    echo -e "${GREEN}✔ Formateo de código correcto.${NC}"
else
    echo -e "${RED}✘ Código no formateado. Ejecuta 'dart format .' para corregirlo.${NC}"
fi

# 2. Análisis estático (Linter)
echo -e "\n${YELLOW}2. Ejecutando análisis estático (flutter analyze)...${NC}"
flutter analyze
ANALYZE_RESULT=$?

if [ $ANALYZE_RESULT -eq 0 ]; then
    echo -e "${GREEN}✔ Análisis estático completado sin errores.${NC}"
else
    echo -e "${RED}✘ Se encontraron advertencias o errores del linter.${NC}"
fi

# Resultado acumulado
echo -e "\n${CYAN}${BOLD}=== Resumen del Análisis ===${NC}"
if [ $FORMAT_RESULT -eq 0 ] && [ $ANALYZE_RESULT -eq 0 ]; then
    echo -e "${GREEN}${BOLD}¡Todo correcto! El código cumple con las directrices de calidad y formato.${NC}"
    exit 0
else
    echo -e "${RED}${BOLD}Fallo en el control de calidad. Por favor revisa los errores superiores.${NC}"
    exit 1
fi
