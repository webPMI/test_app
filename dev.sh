#!/usr/bin/env bash

# Colores para salida en consola
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

# Asegurar permisos de ejecución en los scripts modulares
chmod +x ./scripts/analyze_code.sh 2>/dev/null
chmod +x ./scripts/run_tests.sh 2>/dev/null
chmod +x ./scripts/run_e2e.sh 2>/dev/null

show_help() {
    echo -e "${CYAN}${BOLD}=== Script de Automatización de Desarrollo y Calidad (dev.sh) ===${NC}"
    echo -e "Uso: ./dev.sh [comando]"
    echo -e ""
    echo -e "${BOLD}Comandos Disponibles:${NC}"
    echo -e "  ${GREEN}analyze${NC}     Ejecuta linter (flutter analyze) y valida formateo de código."
    echo -e "  ${GREEN}test${NC}        Ejecuta pruebas unitarias/widgets y genera reporte de cobertura."
    echo -e "  ${GREEN}e2e${NC} [device] Ejecuta pruebas E2E. Auto-detecta dispositivos si no se especifica."
    echo -e "  ${GREEN}all${NC}         Ejecuta el flujo de calidad completo (analyze -> test -> e2e)."
    echo -e "  ${GREEN}help${NC}        Muestra esta pantalla de ayuda."
    echo -e ""
    echo -e "Ejemplos:"
    echo -e "  ./dev.sh test"
    echo -e "  ./dev.sh e2e chrome"
    exit 0
}

COMMAND="$1"

case "$COMMAND" in
    analyze|lint|format)
        ./scripts/analyze_code.sh
        exit $?
        ;;
    test|unit)
        ./scripts/run_tests.sh
        exit $?
        ;;
    e2e|integration)
        ./scripts/run_e2e.sh "$2"
        exit $?
        ;;
    all)
        echo -e "${CYAN}${BOLD}>>> Iniciando Pipeline Completo de Calidad (ALL) <<<${NC}\n"
        
        ./scripts/analyze_code.sh
        if [ $? -ne 0 ]; then
            echo -e "\n${RED}${BOLD}Pipeline abortado: Falló el análisis estático.${NC}"
            exit 1
        fi
        
        echo -e "\n"
        ./scripts/run_tests.sh
        if [ $? -ne 0 ]; then
            echo -e "\n${RED}${BOLD}Pipeline abortado: Fallaron las pruebas unitarias.${NC}"
            exit 1
        fi
        
        echo -e "\n"
        ./scripts/run_e2e.sh "$2"
        if [ $? -ne 0 ]; then
            echo -e "\n${RED}${BOLD}Pipeline abortado: Fallaron las pruebas de extremo a extremo (E2E).${NC}"
            exit 1
        fi
        
        echo -e "\n${GREEN}${BOLD}¡Pipeline Completado Exitosamente! Código 100% verificado.${NC}"
        exit 0
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        if [ -n "$COMMAND" ]; then
            echo -e "${RED}Comando desconocido: $COMMAND${NC}\n"
        fi
        show_help
        ;;
esac
