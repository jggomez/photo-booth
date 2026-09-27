#!/usr/bin/env bash
set -e

# Colores para la consola
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

PORT="${PORT:-8080}"

echo -e "${CYAN}=====================================================${NC}"
echo -e "${CYAN}       📸 EventBooth — Generic & Configurable        ${NC}"
echo -e "${CYAN}=====================================================${NC}"
echo ""

# 1. Verificar instalación de Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}❌ Flutter no está instalado o no se encuentra en el PATH.${NC}"
    exit 1
fi

# 2. Liberar puerto si está en uso
OCCUPIED_PID=$(lsof -ti :"$PORT" || true)
if [ -n "$OCCUPIED_PID" ]; then
    echo -e "${YELLOW}⚠️  El puerto $PORT ya está en uso por el proceso $OCCUPIED_PID. Liberándolo...${NC}"
    kill -9 "$OCCUPIED_PID" 2>/dev/null || true
    sleep 1
fi

# 3. Asegurar dependencias al día
echo -e "${GREEN}📦 Verificando paquetes con flutter pub get...${NC}"
flutter pub get

echo ""
echo -e "${GREEN}🚀 Iniciando Flutter Web en Google Chrome (Puerto: $PORT)...${NC}"
echo ""
echo -e "   🌐 ${PURPLE}Photobooth Público:${NC}  http://localhost:${PORT}/"
echo -e "   ⚙️  ${PURPLE}Admin Secreto:${NC}       http://localhost:${PORT}/#/admin"
echo -e "   🔑 ${PURPLE}PIN por Defecto:${NC}     2026"
echo ""
echo -e "${CYAN}-----------------------------------------------------${NC}"

# 4. Ejecutar Flutter Web
exec flutter run -d chrome --web-port "$PORT"
