# Configuración Específica para Easypanel

Este documento contiene configuraciones específicas y optimizaciones para desplegar OSPOS en Easypanel.

## 🎯 Configuración Recomendada en Easypanel

### 1. Configuración del Servicio

**Nombre del Servicio**: `ospos`
**Tipo**: Compose
**Descripción**: Sistema de Punto de Venta Open Source

### 2. Variables de Entorno en Easypanel

Easypanel permite configurar variables de entorno directamente en la interfaz. Configura las siguientes:

```bash
# Base de Datos
MYSQL_ROOT_PASSWORD=tu_password_root_seguro
MYSQL_DATABASE=ospos
MYSQL_USER=ospos_user
MYSQL_PASSWORD=tu_password_ospos_seguro

# Aplicación
DB_HOST=ospos-db
DB_NAME=ospos
DB_USER=ospos_user
DB_PASSWORD=tu_password_ospos_seguro
DB_PORT=3306

# Configuración Regional
OSPOS_TIMEZONE=America/Mexico_City
OSPOS_LANGUAGE=spanish

# Seguridad
OSPOS_ENCRYPTION_KEY=tu-clave-de-32-caracteres-aqui
```

### 3. Configuración de Red

**Red Interna**: Easypanel creará automáticamente una red interna para la comunicación entre contenedores.

**Puertos**: Los puertos se asignan automáticamente. Easypanel proporcionará:
- URL pública para acceder a OSPOS
- Puerto interno para MySQL (no expuesto públicamente)

### 4. Configuración de Volúmenes

Easypanel gestionará automáticamente los volúmenes persistentes:

- **ospos_mysql_data**: Datos de MySQL
- **ospos_uploads**: Archivos subidos
- **ospos_logs**: Logs de la aplicación

### 5. Configuración de Dominio

#### Opción A: Subdominio de Easypanel
Easypanel proporcionará automáticamente un subdominio como:
`https://ospos-[random].easypanel.host`

#### Opción B: Dominio Personalizado
Para usar tu propio dominio:

1. Ve a **Settings** → **Domains**
2. Añade tu dominio: `ospos.tudominio.com`
3. Configura los registros DNS:
   ```
   Type: CNAME
   Name: ospos
   Value: [tu-servidor-easypanel].easypanel.host
   ```

### 6. Configuración SSL

Easypanel configurará automáticamente SSL usando Let's Encrypt:
- Certificado SSL automático
- Renovación automática
- Redirección HTTP → HTTPS

## 🔧 Optimizaciones para Easypanel

### 1. Recursos Recomendados

**Para uso básico (1-5 usuarios concurrentes):**
- CPU: 1 vCore
- RAM: 1GB
- Almacenamiento: 10GB

**Para uso medio (5-20 usuarios concurrentes):**
- CPU: 2 vCores
- RAM: 2GB
- Almacenamiento: 20GB

**Para uso intensivo (20+ usuarios concurrentes):**
- CPU: 4 vCores
- RAM: 4GB
- Almacenamiento: 50GB

### 2. Configuración de Health Checks

Easypanel incluye health checks automáticos, pero puedes personalizar:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost/index.php"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 60s
```

### 3. Configuración de Logs

Easypanel centraliza los logs automáticamente. Puedes acceder a ellos desde:
- **Dashboard** → **Services** → **ospos** → **Logs**

### 4. Backup Automático

Configura backups automáticos en Easypanel:

1. Ve a **Settings** → **Backups**
2. Configura backup diario de volúmenes
3. Retención recomendada: 7 días

## 🚀 Proceso de Despliegue Paso a Paso

### Paso 1: Preparación
1. Accede a tu panel de Easypanel
2. Asegúrate de tener suficientes recursos disponibles
3. Ten listas las credenciales que vas a usar

### Paso 2: Crear el Servicio
1. **Services** → **Create Service**
2. Selecciona **Compose**
3. Nombre: `ospos`
4. Descripción: `Sistema POS Open Source`

### Paso 3: Configurar el Compose
1. Copia el contenido de `docker-compose.yml`
2. Pégalo en el editor de Easypanel
3. Revisa que no haya errores de sintaxis

### Paso 4: Configurar Variables
1. Ve a la pestaña **Environment**
2. Añade todas las variables necesarias
3. **¡IMPORTANTE!** Cambia todas las contraseñas por defecto

### Paso 5: Desplegar
1. Haz clic en **Deploy**
2. Espera a que se descarguen las imágenes
3. Verifica que ambos contenedores estén corriendo

### Paso 6: Verificación
1. Accede a la URL proporcionada por Easypanel
2. Verifica que OSPOS carga correctamente
3. Inicia sesión con credenciales por defecto
4. **¡CRÍTICO!** Cambia inmediatamente la contraseña de admin

## 🔍 Monitoreo y Mantenimiento

### Métricas Importantes
- **CPU Usage**: Debe mantenerse < 80%
- **Memory Usage**: Debe mantenerse < 85%
- **Disk Usage**: Monitorear crecimiento de la base de datos
- **Response Time**: Debe ser < 2 segundos

### Logs a Monitorear
- **ospos-web**: Errores de aplicación
- **ospos-mysql**: Errores de base de datos
- **Easypanel**: Errores de infraestructura

### Mantenimiento Regular
- **Semanal**: Revisar logs de errores
- **Mensual**: Verificar uso de recursos
- **Trimestral**: Actualizar imágenes Docker
- **Semestral**: Revisar y optimizar base de datos

## 🆘 Solución de Problemas Específicos de Easypanel

### Problema: Servicio no inicia
**Solución**:
1. Revisa los logs en **Services** → **ospos** → **Logs**
2. Verifica que las variables de entorno estén correctas
3. Asegúrate de que no hay conflictos de puertos

### Problema: Error de conexión a base de datos
**Solución**:
1. Verifica que el contenedor MySQL esté corriendo
2. Revisa las credenciales de base de datos
3. Verifica la conectividad de red interna

### Problema: SSL no funciona
**Solución**:
1. Verifica la configuración del dominio
2. Revisa los registros DNS
3. Espera hasta 24 horas para propagación DNS

### Problema: Rendimiento lento
**Solución**:
1. Aumenta los recursos asignados
2. Optimiza la base de datos
3. Revisa los logs para identificar cuellos de botella

## 📞 Soporte

Para soporte específico de Easypanel:
- **Documentación**: [Easypanel Docs](https://easypanel.io/docs)
- **Comunidad**: [Discord de Easypanel](https://discord.gg/easypanel)

Para soporte de OSPOS:
- **GitHub**: [OSPOS Issues](https://github.com/opensourcepos/opensourcepos/issues)
- **Wiki**: [OSPOS Wiki](https://github.com/opensourcepos/opensourcepos/wiki)