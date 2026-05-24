#!/usr/bin/env bash

# Colores para salida en consola
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}=== Ejecutando Pruebas Unitarias y de Widgets con Cobertura ===${NC}"

# Limpiar cobertura anterior
if [ -d "coverage" ]; then
    rm -rf coverage
fi

# Ejecutar las pruebas con flag de cobertura
echo -e "${YELLOW}Corriendo 'flutter test --coverage'...${NC}"
flutter test --coverage
TEST_RESULT=$?

if [ $TEST_RESULT -eq 0 ]; then
    echo -e "\n${GREEN}✔ Todas las pruebas unitarias y de widgets pasaron correctamente.${NC}"
    
    # Procesar archivo de cobertura de manera simple con herramientas estándar
    if [ -f "coverage/lcov.info" ]; then
        echo -e "\n${CYAN}${BOLD}=== Reporte de Cobertura de Código ===${NC}"
        # Sumar todas las líneas encontradas (LF: Lines Found)
        TOTAL_LF=$(grep "LF:" coverage/lcov.info | cut -d':' -f2 | awk '{sum+=$1} END {print sum}')
        # Sumar todas las líneas ejecutadas/tocadas (LH: Lines Hit)
        TOTAL_LH=$(grep "LH:" coverage/lcov.info | cut -d':' -f2 | awk '{sum+=$1} END {print sum}')
        
        if [ ! -z "$TOTAL_LF" ] && [ "$TOTAL_LF" -gt 0 ]; then
            PERCENTAGE=$(awk "BEGIN {print ($TOTAL_LH/$TOTAL_LF)*100}")
            PERCENTAGE_ROUNDED=$(printf "%.2f" "$PERCENTAGE")
            echo -e "${GREEN}✔ Cobertura de Líneas: ${BOLD}${PERCENTAGE_ROUNDED}%${NC} (${TOTAL_LH} de ${TOTAL_LF} líneas probadas)"
            echo -e "${CYAN}Nota: Reporte detallado guardado en: coverage/lcov.info${NC}"
        else
            echo -e "${YELLOW}⚠ Reporte lcov.info generado pero no se detectaron líneas de cobertura.${NC}"
        fi
    else
        echo -e "${RED}✘ No se generó el archivo de cobertura coverage/lcov.info.${NC}"
    fi
    exit 0
else
    echo -e "\n${RED}✘ Algunas pruebas fallaron. Revisa el log de errores superior.${NC}"
    exit $TEST_RESULT
fi
