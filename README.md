# OSPOS en Easypanel - Configuración Docker Compose

Este repositorio contiene la configuración necesaria para instalar **Open Source Point of Sale (OSPOS)** en tu VPS de Hostinger usando Easypanel con la plantilla "Compose".

## 📋 Requisitos Previos

- VPS con Hostinger
- Easypanel instalado y configurado
- Acceso a tu panel de Easypanel
- Dominio configurado (opcional pero recomendado)

## 🚀 Instalación en Easypanel

### Paso 1: Crear el Servicio en Easypanel

1. Accede a tu panel de Easypanel
2. Ve a **Services** → **Create Service**
3. Selecciona **Compose** como plantilla
4. Asigna un nombre al servicio: `ospos`

### Paso 2: Configurar el Docker Compose

1. Copia el contenido del archivo `docker-compose.yml` de este repositorio
2. Pégalo en el editor de Easypanel
3. **Importante**: Los puertos han sido eliminados para que Easypanel asigne automáticamente puertos disponibles

### Paso 3: Configurar Variables de Entorno

Antes de desplegar, **DEBES** modificar las siguientes variables en el archivo docker-compose.yml:

```yaml
# Cambiar estas credenciales por seguridad
MYSQL_ROOT_PASSWORD: tu_password_root_seguro
MYSQL_PASSWORD: tu_password_ospos_seguro
DB_PASSWORD: tu_password_ospos_seguro  # Debe coincidir con MYSQL_PASSWORD

# Generar una clave de encriptación de 32 caracteres
OSPOS_ENCRYPTION_KEY: tu-clave-de-32-caracteres-aqui

# Configurar tu zona horaria
OSPOS_TIMEZONE: America/Mexico_City  # Ajustar según tu ubicación

# Configurar dominio (opcional)
traefik.http.routers.ospos.rule=Host(`ospos.tudominio.com`)
```

### Paso 4: Desplegar el Servicio

1. Haz clic en **Deploy** en Easypanel
2. Espera a que se descarguen las imágenes y se inicien los contenedores
3. Verifica que ambos servicios estén corriendo:
   - `ospos-mysql` (Base de datos)
   - `ospos-web` (Aplicación web)

## 🔧 Configuración Post-Instalación

### Acceso Inicial

1. Una vez desplegado, Easypanel te proporcionará una URL para acceder a OSPOS
2. Las credenciales por defecto son:
   - **Usuario**: `admin`
   - **Contraseña**: `pointofsale`

### Configuración Inicial Recomendada

1. **Cambiar credenciales de administrador**:
   - Ve a `Empleados` → `Administrar Empleados`
   - Edita el usuario admin y cambia la contraseña

2. **Configurar información de la empresa**:
   - Ve a `Configuración` → `Información de la Empresa`
   - Completa todos los datos de tu negocio

3. **Configurar impuestos y moneda**:
   - Ve a `Configuración` → `Configuración de Impuestos`
   - Configura según las leyes fiscales de tu país

## 🔒 Consideraciones de Seguridad

### Variables de Entorno Críticas

- **OSPOS_ENCRYPTION_KEY**: Genera una clave única de 32 caracteres
- **Contraseñas de MySQL**: Usa contraseñas fuertes y únicas
- **Credenciales de administrador**: Cambia inmediatamente después de la instalación

### Recomendaciones Adicionales

- Configura un dominio personalizado con SSL
- Realiza backups regulares de la base de datos
- Mantén actualizada la imagen de OSPOS
- Configura un firewall adecuado

## 📊 Servicios Existentes Considerados

Este docker-compose ha sido diseñado considerando que ya tienes los siguientes servicios en tu Easypanel:

- n8n
- Chatwoot
- Evolution API
- PostgreSQL
- pgAdmin
- Redis
- Qdrant

**Los puertos han sido eliminados** para evitar conflictos y permitir que Easypanel asigne automáticamente puertos disponibles.

## 🗄️ Gestión de Datos

### Volúmenes Persistentes

El compose crea los siguientes volúmenes para persistir datos:

- `ospos_mysql_data`: Datos de la base de datos MySQL
- `ospos_uploads`: Archivos subidos (imágenes de productos, etc.)
- `ospos_logs`: Logs de la aplicación

### Backup de Base de Datos

Para hacer backup de la base de datos:

```bash
# Desde el contenedor MySQL
docker exec ospos-mysql mysqldump -u ospos_user -p ospos > backup_ospos.sql
```

## 🔧 Solución de Problemas

### Problemas Comunes

1. **Error de conexión a la base de datos**:
   - Verifica que las credenciales coincidan entre los servicios
   - Asegúrate de que el servicio MySQL esté corriendo

2. **Problemas de permisos**:
   - Verifica que los volúmenes tengan los permisos correctos

3. **Error 500 en la aplicación**:
   - Revisa los logs del contenedor: `docker logs ospos-web`
   - Verifica la configuración de la clave de encriptación

### Logs

Para revisar los logs de los servicios:

```bash
# Logs de la aplicación web
docker logs ospos-web

# Logs de la base de datos
docker logs ospos-mysql
```

## 📞 Soporte

- **Documentación oficial de OSPOS**: [https://github.com/opensourcepos/opensourcepos](https://github.com/opensourcepos/opensourcepos)
- **Wiki de OSPOS**: [https://github.com/opensourcepos/opensourcepos/wiki](https://github.com/opensourcepos/opensourcepos/wiki)

## 📝 Licencia

Este proyecto de configuración está bajo licencia MIT. OSPOS tiene su propia licencia GPL v3.

---

**¡Importante!** Recuerda cambiar todas las contraseñas y claves por defecto antes de usar en producción.