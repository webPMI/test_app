#!/usr/bin/env bash

# Colores para salida en consola
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}=== Ejecutando Pruebas de Integración (E2E) ===${NC}"

# 1. Determinar el dispositivo a utilizar
DEVICE_ID="$1"

if [ -z "$DEVICE_ID" ]; then
    echo -e "${YELLOW}Detectando dispositivos activos...${NC}"
    DEVICES_OUTPUT=$(flutter devices)
    
    # Intentar buscar un emulador Android activo (ej. emulator-5554)
    DEVICE_ID=$(echo "$DEVICES_OUTPUT" | grep -o -E "emulator-[0-9]+" | head -n 1)
    
    if [ -z "$DEVICE_ID" ]; then
        # Intentar buscar Chrome
        if echo "$DEVICES_OUTPUT" | grep -q -i "chrome"; then
            DEVICE_ID="chrome"
        # Intentar buscar Windows
        elif echo "$DEVICES_OUTPUT" | grep -q -i "windows"; then
            DEVICE_ID="windows"
        fi
    fi
fi

if [ -z "$DEVICE_ID" ]; then
    echo -e "${RED}✘ Error: No se detectó ningún dispositivo o emulador activo.${NC}"
    echo -e "Por favor, inicia un simulador o conecta un dispositivo y vuelve a intentarlo."
    echo -e "Dispositivos detectados por Flutter:"
    flutter devices
    exit 1
fi

echo -e "${GREEN}✔ Dispositivo seleccionado para la ejecución: ${BOLD}${DEVICE_ID}${NC}"
echo -e "${YELLOW}Ejecutando 'flutter test integration_test/app_test.dart -d ${DEVICE_ID}'...${NC}"

flutter test integration_test/app_test.dart -d "$DEVICE_ID"
E2E_RESULT=$?

if [ $E2E_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}✔ ¡Pruebas E2E completadas con éxito en el dispositivo: ${DEVICE_ID}!${NC}"
    exit 0
else
    echo -e "\n${RED}${BOLD}✘ Pruebas E2E fallidas en el dispositivo: ${DEVICE_ID}.${NC}"
    exit $E2E_RESULT
fi
