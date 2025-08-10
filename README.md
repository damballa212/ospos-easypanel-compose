# OSPOS en Easypanel - Configuración Docker Compose

Este repositorio contiene la configuración necesaria para instalar **Open Source Point of Sale (OSPOS)** en tu VPS de Hostinger usando Easypanel con la plantilla "Compose" desde Git.

## 🐳 Imágenes Docker Utilizadas

Este proyecto utiliza las **imágenes oficiales de OSPOS**:
- **ospos-app**: `jekkos/opensourcepos:master` - Aplicación principal OSPOS
- **ospos-db**: `mysql:8.0` - Base de datos MySQL
- **ospos-sql-init**: `jekkos/opensourcepos:sql-master` - Inicialización de base de datos

> ⚠️ **Nota importante**: Las imágenes `opensourcepos/opensourcepos` no existen en Docker Hub. Este repositorio ha sido corregido para usar las imágenes oficiales mantenidas por el proyecto OSPOS.

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
MYSQL_DB_NAME=ospos
MYSQL_USERNAME=admin

# Configuración de la Aplicación
CI_ENVIRONMENT=production
FORCE_HTTPS=false
PHP_TIMEZONE=UTC
```

#### Variables Opcionales:
```bash
# Configuración Regional
PHP_TIMEZONE=America/Mexico_City
CI_ENVIRONMENT=development  # Para desarrollo
FORCE_HTTPS=true  # Si usas HTTPS
```

### Paso 4: Desplegar el Servicio

1. Haz clic en **Deploy** en Easypanel
2. Espera a que se clone el repositorio
3. Espera a que se descarguen las imágenes Docker:
   - `jekkos/opensourcepos:master`
   - `mysql:8.0`
   - `jekkos/opensourcepos:sql-master`
4. Verifica que los servicios estén corriendo:
   - `ospos-app` (Aplicación web OSPOS)
   - `ospos-db` (Base de datos MySQL)
   - `ospos-sql-init` (Inicialización completada)

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

2. **Configurar variables de entorno seguras**:
   - Cambia `MYSQL_ROOT_PASSWORD` y `MYSQL_PASSWORD`
   - Usa contraseñas fuertes y únicas

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

- **MYSQL_ROOT_PASSWORD**: Contraseña fuerte para el usuario root de MySQL
- **MYSQL_PASSWORD**: Contraseña fuerte para el usuario de OSPOS
- **CI_ENVIRONMENT**: Usar `production` en producción

### Generación de Contraseñas Seguras

Puedes generar contraseñas seguras usando:

```bash
# Para contraseñas (25 caracteres)
openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
```

## 🛠️ Solución del Error "pull access denied"

Si encuentras el error:
```
pull access denied for opensourcepos/opensourcepos, repository does not exist
```

**Solución**: Este repositorio ya está corregido con las imágenes oficiales:
- ✅ `jekkos/opensourcepos:master` (en lugar de `opensourcepos/opensourcepos`)
- ✅ `mysql:8.0`
- ✅ `jekkos/opensourcepos:sql-master`

Simplemente redespliega el servicio desde Easypanel y el error se resolverá.

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
- Red interna aislada (`ospos-network`)

## 🗄️ Gestión de Datos

### Volúmenes Persistentes

El compose crea los siguientes volúmenes para persistir datos:

- `ospos-db-data`: Datos de la base de datos MySQL
- `ospos-db-init`: Scripts de inicialización de base de datos
- `ospos-uploads`: Archivos subidos (imágenes de productos, etc.)
- `ospos-logs`: Logs de la aplicación

### Backup desde Easypanel

1. Ve a **Services** → **ospos** → **Backups**
2. Configura backup automático de volúmenes
3. Frecuencia recomendada: diaria
4. Retención recomendada: 7-30 días

## 🔧 Solución de Problemas

### Problemas Comunes

1. **Error "pull access denied"**:
   - ✅ **Solucionado**: Este repositorio usa las imágenes oficiales correctas
   - Redespliega el servicio desde Easypanel

2. **Error de conexión a la base de datos**:
   - Verifica que las variables `MYSQL_PASSWORD` y `MYSQL_USERNAME` estén configuradas
   - Revisa los logs del servicio `ospos-db`

3. **Error 500 en la aplicación**:
   - Verifica que `CI_ENVIRONMENT` esté configurada
   - Revisa los logs del servicio `ospos-app`

4. **Problemas de despliegue**:
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
3. Espera a que todos los contenedores se reinicien

## 🔄 Actualizaciones

### Actualizar OSPOS

1. Ve a **Services** → **ospos**
2. Haz clic en **Redeploy**
3. Easypanel descargará las imágenes más recientes:
   - `jekkos/opensourcepos:master`
   - `jekkos/opensourcepos:sql-master`

### Actualizar Configuración

1. Modifica las variables de entorno en Easypanel
2. Haz clic en **Redeploy**
3. Los cambios se aplicarán automáticamente

## 📞 Soporte

- **Documentación oficial de OSPOS**: [https://github.com/opensourcepos/opensourcepos](https://github.com/opensourcepos/opensourcepos)
- **Wiki de OSPOS**: [https://github.com/opensourcepos/opensourcepos/wiki](https://github.com/opensourcepos/opensourcepos/wiki)
- **Documentación de Easypanel**: [https://easypanel.io/docs](https://easypanel.io/docs)
- **Imágenes Docker oficiales**: [https://hub.docker.com/u/jekkos](https://hub.docker.com/u/jekkos)

## 📝 Licencia

Este proyecto de configuración está bajo licencia MIT. OSPOS tiene su propia licencia GPL v3.

---

**⚠️ IMPORTANTE:** 
- Cambia TODAS las contraseñas por defecto antes de usar en producción
- Configura backups automáticos
- Mantén actualizada la aplicación
- Monitorea regularmente los logs de seguridad
- Este repositorio corrige el error "pull access denied" usando imágenes oficiales