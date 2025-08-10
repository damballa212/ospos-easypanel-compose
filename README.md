# OSPOS en Easypanel - Configuración Docker Compose

Este repositorio contiene la configuración necesaria para instalar **Open Source Point of Sale (OSPOS)** en tu VPS de Hostinger usando Easypanel con la plantilla "Compose" desde Git.

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

### Paso 2: Configurar el Repositorio Git

1. **URL del repositorio**: `https://github.com/damballa212/ospos-easypanel-compose.git`
2. **Rama**: `main`
3. **Ruta de compilación**: `/` (raíz del repositorio)
4. **Archivo Docker Compose**: `docker-compose.yml`

### Paso 3: Configurar Variables de Entorno

En la sección **Environment** de Easypanel, configura las siguientes variables:

#### Variables Obligatorias:
```bash
# Credenciales de Base de Datos (CAMBIAR POR SEGURIDAD)
MYSQL_ROOT_PASSWORD=tu_password_root_muy_seguro
MYSQL_PASSWORD=tu_password_ospos_muy_seguro
MYSQL_DATABASE=ospos
MYSQL_USER=ospos_user

# Clave de Encriptación (32 caracteres - CRÍTICO)
OSPOS_ENCRYPTION_KEY=tu-clave-de-32-caracteres-unica
```

#### Variables Opcionales:
```bash
# Configuración Regional
OSPOS_TIMEZONE=America/Mexico_City
OSPOS_LANGUAGE=spanish

# Configuración de Email (opcional)
OSPOS_MAIL_PROTOCOL=smtp
OSPOS_MAIL_HOST=smtp.gmail.com
OSPOS_MAIL_PORT=587
OSPOS_MAIL_USERNAME=tu-email@gmail.com
OSPOS_MAIL_PASSWORD=tu-password-de-aplicacion
OSPOS_MAIL_CRYPTO=tls
```

### Paso 4: Desplegar el Servicio

1. Haz clic en **Deploy** en Easypanel
2. Espera a que se clone el repositorio
3. Espera a que se descarguen las imágenes Docker
4. Verifica que ambos servicios estén corriendo:
   - `ospos-db` (Base de datos MySQL)
   - `ospos-app` (Aplicación web OSPOS)

## 🔧 Configuración Post-Instalación

### Acceso Inicial

1. Una vez desplegado, Easypanel te proporcionará una URL para acceder a OSPOS
2. Las credenciales por defecto son:
   - **Usuario**: `admin`
   - **Contraseña**: `pointofsale`

### ⚠️ Configuración Crítica de Seguridad

**INMEDIATAMENTE después del primer acceso:**

1. **Cambiar credenciales de administrador**:
   - Ve a `Empleados` → `Administrar Empleados`
   - Edita el usuario admin y cambia la contraseña

2. **Verificar clave de encriptación**:
   - Asegúrate de haber configurado `OSPOS_ENCRYPTION_KEY` con 32 caracteres únicos
   - Nunca uses la clave por defecto en producción

### Configuración Inicial Recomendada

1. **Configurar información de la empresa**:
   - Ve a `Configuración` → `Información de la Empresa`
   - Completa todos los datos de tu negocio

2. **Configurar impuestos y moneda**:
   - Ve a `Configuración` → `Configuración de Impuestos`
   - Configura según las leyes fiscales de tu país

3. **Configurar backup automático**:
   - Configura backups regulares desde Easypanel
   - Frecuencia recomendada: diaria

## 🔒 Consideraciones de Seguridad

### Variables de Entorno Críticas

- **OSPOS_ENCRYPTION_KEY**: Debe ser única, de 32 caracteres, y nunca compartida
- **MYSQL_ROOT_PASSWORD**: Contraseña fuerte para el usuario root de MySQL
- **MYSQL_PASSWORD**: Contraseña fuerte para el usuario de OSPOS

### Generación de Claves Seguras

Puedes generar claves seguras usando:

```bash
# Para la clave de encriptación (32 caracteres)
openssl rand -base64 32 | tr -d "=+/" | cut -c1-32

# Para contraseñas (25 caracteres)
openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
```

## 📊 Servicios Existentes Considerados

Este docker-compose ha sido optimizado para Easypanel y es compatible con tus servicios existentes:

- n8n
- Chatwoot
- Evolution API
- PostgreSQL
- pgAdmin
- Redis
- Qdrant

**Características de compatibilidad:**
- Sin `container_name` para evitar conflictos
- Sin `version` (obsoleto en Docker Compose)
- Sin puertos específicos (Easypanel asigna automáticamente)
- Red interna aislada

## 🗄️ Gestión de Datos

### Volúmenes Persistentes

El compose crea los siguientes volúmenes para persistir datos:

- `ospos_mysql_data`: Datos de la base de datos MySQL
- `ospos_uploads`: Archivos subidos (imágenes de productos, etc.)
- `ospos_logs`: Logs de la aplicación

### Backup desde Easypanel

1. Ve a **Services** → **ospos** → **Backups**
2. Configura backup automático de volúmenes
3. Frecuencia recomendada: diaria
4. Retención recomendada: 7-30 días

## 🔧 Solución de Problemas

### Problemas Comunes

1. **Error de conexión a la base de datos**:
   - Verifica que las variables `MYSQL_PASSWORD` y `DB_PASSWORD` coincidan
   - Revisa los logs del servicio `ospos-db`

2. **Error 500 en la aplicación**:
   - Verifica que `OSPOS_ENCRYPTION_KEY` esté configurada
   - Revisa los logs del servicio `ospos-app`

3. **Problemas de despliegue**:
   - Verifica que la URL del repositorio Git sea correcta
   - Asegúrate de que todas las variables obligatorias estén configuradas

### Acceso a Logs

Desde Easypanel:
1. Ve a **Services** → **ospos**
2. Selecciona el contenedor específico
3. Ve a la pestaña **Logs**

### Reiniciar Servicios

Si necesitas reiniciar:
1. Ve a **Services** → **ospos**
2. Haz clic en **Restart**
3. Espera a que ambos contenedores se reinicien

## 🔄 Actualizaciones

### Actualizar OSPOS

1. Ve a **Services** → **ospos**
2. Haz clic en **Redeploy**
3. Easypanel descargará la imagen más reciente

### Actualizar Configuración

1. Modifica las variables de entorno en Easypanel
2. Haz clic en **Redeploy**
3. Los cambios se aplicarán automáticamente

## 📞 Soporte

- **Documentación oficial de OSPOS**: [https://github.com/opensourcepos/opensourcepos](https://github.com/opensourcepos/opensourcepos)
- **Wiki de OSPOS**: [https://github.com/opensourcepos/opensourcepos/wiki](https://github.com/opensourcepos/opensourcepos/wiki)
- **Documentación de Easypanel**: [https://easypanel.io/docs](https://easypanel.io/docs)

## 📝 Licencia

Este proyecto de configuración está bajo licencia MIT. OSPOS tiene su propia licencia GPL v3.

---

**⚠️ IMPORTANTE:** 
- Cambia TODAS las contraseñas por defecto antes de usar en producción
- Configura backups automáticos
- Mantén actualizada la aplicación
- Monitorea regularmente los logs de seguridad