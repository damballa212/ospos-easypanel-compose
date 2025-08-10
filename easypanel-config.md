# Configuración Específica para Easypanel

Esta guía contiene configuraciones específicas y optimizaciones para desplegar OSPOS en Easypanel de manera eficiente.

## 🎯 Configuración del Servicio en Easypanel

### Información del Servicio

- **Tipo de Servicio**: Compose
- **Fuente**: Git Repository
- **URL del Repositorio**: `https://github.com/damballa212/ospos-easypanel-compose.git`
- **Rama**: `main`
- **Ruta de Compilación**: `/`
- **Archivo Docker Compose**: `docker-compose.yml`

### Variables de Entorno Obligatorias

```bash
# Base de Datos MySQL
MYSQL_ROOT_PASSWORD=tu_password_root_muy_seguro_32_chars
MYSQL_PASSWORD=tu_password_ospos_muy_seguro_32_chars
MYSQL_DATABASE=ospos
MYSQL_USER=ospos_user

# Aplicación OSPOS
OSPOS_ENCRYPTION_KEY=tu-clave-de-encriptacion-32-caracteres
```

### Variables de Entorno Opcionales

```bash
# Configuración Regional
OSPOS_TIMEZONE=America/Mexico_City
OSPOS_LANGUAGE=spanish

# Email (SMTP)
OSPOS_MAIL_PROTOCOL=smtp
OSPOS_MAIL_HOST=smtp.gmail.com
OSPOS_MAIL_PORT=587
OSPOS_MAIL_USERNAME=tu-email@empresa.com
OSPOS_MAIL_PASSWORD=tu-app-password
OSPOS_MAIL_CRYPTO=tls

# Dominio (si usas dominio personalizado)
VIRTUAL_HOST=ospos.tudominio.com
LETSENCRYPT_HOST=ospos.tudominio.com
```

## 🔧 Configuración de Red y Volúmenes

### Red Interna

El docker-compose crea una red interna `ospos-network` que:
- Aísla los servicios de OSPOS
- Permite comunicación entre `ospos-app` y `ospos-db`
- Es compatible con otros servicios en Easypanel

### Volúmenes Persistentes

| Volumen | Propósito | Backup Recomendado |
|---------|-----------|--------------------|
| `ospos_mysql_data` | Datos de MySQL | ✅ Crítico - Diario |
| `ospos_uploads` | Archivos subidos | ✅ Importante - Diario |
| `ospos_logs` | Logs de aplicación | ⚠️ Opcional - Semanal |

## 🌐 Configuración de Dominio y SSL

### Opción 1: Subdominio de Easypanel (Automático)

Easypanel asignará automáticamente:
- URL: `https://tu-servicio.tu-panel.easypanel.host`
- SSL: Certificado automático
- Sin configuración adicional requerida

### Opción 2: Dominio Personalizado

1. **Configurar DNS**:
   ```
   Tipo: CNAME
   Nombre: ospos
   Valor: tu-panel.easypanel.host
   ```

2. **Agregar variables de entorno**:
   ```bash
   VIRTUAL_HOST=ospos.tudominio.com
   LETSENCRYPT_HOST=ospos.tudominio.com
   ```

3. **Configurar en Easypanel**:
   - Ve a **Services** → **ospos** → **Domains**
   - Agrega tu dominio personalizado
   - Habilita SSL automático

## 📊 Recursos Recomendados

### Configuración Mínima

- **CPU**: 1 vCPU
- **RAM**: 1 GB
- **Almacenamiento**: 10 GB
- **Usuarios concurrentes**: 5-10

### Configuración Recomendada

- **CPU**: 2 vCPU
- **RAM**: 2 GB
- **Almacenamiento**: 20 GB
- **Usuarios concurrentes**: 20-50

### Configuración para Alto Tráfico

- **CPU**: 4 vCPU
- **RAM**: 4 GB
- **Almacenamiento**: 50 GB
- **Usuarios concurrentes**: 100+

## 🔍 Health Checks y Monitoreo

### Health Checks Incluidos

El docker-compose incluye health checks para:

- **MySQL**: Verifica conectividad cada 30 segundos
- **OSPOS App**: Verifica respuesta HTTP cada 30 segundos

### Monitoreo en Easypanel

1. **Métricas de Recursos**:
   - CPU y memoria en tiempo real
   - Uso de almacenamiento
   - Tráfico de red

2. **Logs Centralizados**:
   - Logs de aplicación
   - Logs de base de datos
   - Logs de sistema

3. **Alertas Recomendadas**:
   - CPU > 80% por 5 minutos
   - Memoria > 90% por 5 minutos
   - Servicio no disponible por 2 minutos

## 💾 Estrategia de Backup

### Backup Automático en Easypanel

1. **Configurar Backup**:
   - Ve a **Services** → **ospos** → **Backups**
   - Habilita backup automático
   - Selecciona todos los volúmenes

2. **Configuración Recomendada**:
   ```
   Frecuencia: Diaria a las 2:00 AM
   Retención: 7 días (mínimo)
   Compresión: Habilitada
   Notificaciones: Email en fallos
   ```

### Backup Manual de Base de Datos

```bash
# Desde la terminal de Easypanel
docker exec ospos-db mysqldump -u root -p ospos > backup_$(date +%Y%m%d).sql
```

## 🚀 Proceso de Despliegue Paso a Paso

### 1. Preparación

- [ ] VPS con Easypanel funcionando
- [ ] Dominio configurado (opcional)
- [ ] Variables de entorno preparadas

### 2. Crear Servicio

1. **Easypanel Dashboard** → **Services** → **Create Service**
2. **Template**: Compose
3. **Name**: `ospos`
4. **Source**: Git Repository

### 3. Configurar Git

1. **Repository URL**: `https://github.com/damballa212/ospos-easypanel-compose.git`
2. **Branch**: `main`
3. **Build Path**: `/`
4. **Compose File**: `docker-compose.yml`

### 4. Variables de Entorno

Copia y pega las variables obligatorias, modificando los valores:

```bash
MYSQL_ROOT_PASSWORD=tu_password_root_muy_seguro_32_chars
MYSQL_PASSWORD=tu_password_ospos_muy_seguro_32_chars
MYSQL_DATABASE=ospos
MYSQL_USER=ospos_user
OSPOS_ENCRYPTION_KEY=tu-clave-de-encriptacion-32-caracteres
OSPOS_TIMEZONE=America/Mexico_City
OSPOS_LANGUAGE=spanish
```

### 5. Desplegar

1. **Deploy** → Esperar descarga de imágenes
2. **Verificar** → Ambos contenedores corriendo
3. **Acceder** → URL proporcionada por Easypanel

### 6. Configuración Post-Despliegue

1. **Login inicial**: admin / pointofsale
2. **Cambiar contraseña** inmediatamente
3. **Configurar empresa** y datos fiscales
4. **Configurar backup** automático

## 🔧 Troubleshooting Específico de Easypanel

### Problemas de Despliegue

1. **Error: "Repository not found"**
   - Verifica la URL del repositorio
   - Asegúrate de que el repositorio sea público

2. **Error: "Compose file not found"**
   - Verifica que `docker-compose.yml` esté en la raíz
   - Revisa la ruta de compilación (`/`)

3. **Error: "Environment variable missing"**
   - Verifica que todas las variables obligatorias estén configuradas
   - Revisa que no haya espacios en los nombres de variables

### Problemas de Conectividad

1. **No se puede acceder a la aplicación**
   - Verifica que el servicio esté corriendo
   - Revisa los logs del contenedor `ospos-app`
   - Verifica la configuración de dominio

2. **Error de base de datos**
   - Verifica que `ospos-db` esté corriendo
   - Revisa las credenciales de MySQL
   - Verifica la conectividad de red interna

### Problemas de Rendimiento

1. **Aplicación lenta**
   - Aumenta recursos de CPU/RAM
   - Verifica uso de almacenamiento
   - Revisa logs por errores

2. **Timeouts frecuentes**
   - Aumenta límites de memoria
   - Verifica configuración de health checks
   - Considera optimización de base de datos

## 📈 Optimizaciones Avanzadas

### Optimización de MySQL

Agregar variables de entorno para MySQL:

```bash
# Optimizaciones de rendimiento
MYSQL_INNODB_BUFFER_POOL_SIZE=256M
MYSQL_INNODB_LOG_FILE_SIZE=64M
MYSQL_MAX_CONNECTIONS=100
MYSQL_QUERY_CACHE_SIZE=32M
```

### Optimización de PHP

Agregar variables para la aplicación:

```bash
# Límites de PHP
PHP_MEMORY_LIMIT=256M
PHP_MAX_EXECUTION_TIME=300
PHP_UPLOAD_MAX_FILESIZE=10M
PHP_POST_MAX_SIZE=10M
```

### Caché y Sesiones

```bash
# Configuración de sesiones
SESSION_SAVE_HANDLER=files
SESSION_SAVE_PATH=/var/lib/php/sessions

# Caché de aplicación
CACHE_DRIVER=file
CACHE_PATH=/var/www/html/application/cache
```

## 🔄 Actualizaciones y Mantenimiento

### Actualización de OSPOS

1. **Backup completo** antes de actualizar
2. **Services** → **ospos** → **Redeploy**
3. **Verificar** funcionamiento post-actualización
4. **Rollback** si hay problemas

### Mantenimiento Regular

- **Semanal**: Revisar logs y métricas
- **Mensual**: Verificar backups y espacio en disco
- **Trimestral**: Actualizar contraseñas y revisar seguridad

---

**💡 Tip**: Mantén este archivo actualizado con tus configuraciones específicas y personalizaciones para futuras referencias.