#!/bin/bash

# ==============================================
# Script de Instalación de OSPOS para Easypanel
# ==============================================

set -e

echo "🚀 Iniciando instalación de OSPOS para Easypanel..."
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para generar contraseñas seguras
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Función para generar clave de encriptación
generate_encryption_key() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

echo -e "${BLUE}📋 Configuración de OSPOS${NC}"
echo ""

# Solicitar información básica
read -p "🏢 Nombre de tu empresa: " COMPANY_NAME
read -p "🌐 Dominio para OSPOS (ej: ospos.tudominio.com): " DOMAIN
read -p "🕐 Zona horaria (ej: America/Mexico_City): " TIMEZONE
read -p "🗣️  Idioma (spanish/english): " LANGUAGE

echo ""
echo -e "${YELLOW}🔐 Generando credenciales seguras...${NC}"

# Generar credenciales automáticamente
MYSQL_ROOT_PASSWORD=$(generate_password)
MYSQL_PASSWORD=$(generate_password)
ENCRYPTION_KEY=$(generate_encryption_key)

echo -e "${GREEN}✅ Credenciales generadas exitosamente${NC}"
echo ""

# Crear archivo docker-compose.yml personalizado
echo -e "${BLUE}📝 Creando docker-compose.yml personalizado...${NC}"

cat > docker-compose.yml << EOF
version: '3.8'

services:
  ospos-db:
    image: mysql:8.0
    container_name: ospos-mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ospos
      MYSQL_USER: ospos_user
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - ospos_mysql_data:/var/lib/mysql
    networks:
      - ospos-network
    command: --default-authentication-plugin=mysql_native_password

  ospos-app:
    image: opensourcepos/opensourcepos:latest
    container_name: ospos-web
    restart: unless-stopped
    depends_on:
      - ospos-db
    environment:
      # Database Configuration
      DB_HOST: ospos-db
      DB_NAME: ospos
      DB_USER: ospos_user
      DB_PASSWORD: ${MYSQL_PASSWORD}
      DB_PORT: 3306
      
      # Application Configuration
      OSPOS_TIMEZONE: ${TIMEZONE}
      OSPOS_LANGUAGE: ${LANGUAGE}
      
      # Security
      OSPOS_ENCRYPTION_KEY: ${ENCRYPTION_KEY}
    volumes:
      - ospos_uploads:/var/www/html/application/uploads
      - ospos_logs:/var/www/html/application/logs
    networks:
      - ospos-network
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.ospos.rule=Host(\`${DOMAIN}\`)"
      - "traefik.http.routers.ospos.tls=true"
      - "traefik.http.routers.ospos.tls.certresolver=letsencrypt"
      - "traefik.http.services.ospos.loadbalancer.server.port=80"

volumes:
  ospos_mysql_data:
    driver: local
  ospos_uploads:
    driver: local
  ospos_logs:
    driver: local

networks:
  ospos-network:
    driver: bridge
EOF

echo -e "${GREEN}✅ docker-compose.yml creado exitosamente${NC}"
echo ""

# Crear archivo de credenciales
echo -e "${BLUE}🔑 Guardando credenciales...${NC}"

cat > credenciales.txt << EOF
==============================================
CREDENCIALES DE OSPOS - ${COMPANY_NAME}
==============================================

📊 INFORMACIÓN GENERAL:
Empresa: ${COMPANY_NAME}
Dominio: ${DOMAIN}
Zona Horaria: ${TIMEZONE}
Idioma: ${LANGUAGE}

🔐 CREDENCIALES DE BASE DE DATOS:
Usuario Root MySQL: root
Contraseña Root MySQL: ${MYSQL_ROOT_PASSWORD}

Usuario OSPOS: ospos_user
Contraseña OSPOS: ${MYSQL_PASSWORD}

🔒 SEGURIDAD:
Clave de Encriptación: ${ENCRYPTION_KEY}

🌐 ACCESO A LA APLICACIÓN:
URL: https://${DOMAIN}
Usuario por defecto: admin
Contraseña por defecto: pointofsale

⚠️  IMPORTANTE:
- Cambia la contraseña del usuario admin después del primer acceso
- Guarda este archivo en un lugar seguro
- No compartas estas credenciales

==============================================
Generado el: $(date)
==============================================
EOF

echo -e "${GREEN}✅ Credenciales guardadas en credenciales.txt${NC}"
echo ""

echo -e "${GREEN}🎉 ¡Instalación completada!${NC}"
echo ""
echo -e "${YELLOW}📋 PRÓXIMOS PASOS:${NC}"
echo "1. Copia el contenido de docker-compose.yml"
echo "2. Ve a tu Easypanel → Services → Create Service → Compose"
echo "3. Pega el contenido y despliega"
echo "4. Accede a https://${DOMAIN} con las credenciales por defecto"
echo "5. Cambia inmediatamente la contraseña del administrador"
echo ""
echo -e "${RED}⚠️  IMPORTANTE: Revisa el archivo credenciales.txt para todas las contraseñas${NC}"
echo ""
echo -e "${BLUE}📚 Documentación completa: https://github.com/damballa212/ospos-easypanel-compose${NC}"
echo ""