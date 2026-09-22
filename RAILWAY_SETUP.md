# 🚀 Guía de Despliegue en Railway

## ✅ Progreso Actual

Ya completamos:
- ✅ Login en Railway CLI (`railway login`)
- ✅ Proyecto creado: **chambasional**
- ✅ PostgreSQL añadido y en ejecución
- ✅ Redis añadido y en ejecución
- ✅ Variables de entorno configuradas en servicio Postgres

**URL del Proyecto**: https://railway.com/project/13e45590-58c6-4f2f-960b-d4c730f1779e

---

## 📋 Pasos Siguientes (Completar Manualmente)

### 1. Crear Servicio Backend

Abre el proyecto en Railway: https://railway.com/project/13e45590-58c6-4f2f-960b-d4c730f1779e

#### Opción A: Desde la UI Web (Recomendado)

1. Click en **"+ New Service"**
2. Selecciona **"Empty Service"**
3. Nombra el servicio: `backend`
4. Click en el servicio **backend** recién creado
5. Ve a **"Settings"** → **"Source"**
6. Click en **"Connect Repo"** y selecciona tu repositorio
   - Si no está en GitHub, usa el CLI para desplegar (ver Opción B)
7. Configura **Root Directory**: `backend`
8. Railway detectará automáticamente el `Dockerfile`

#### Opción B: Desde el CLI (Si no tienes GitHub conectado)

Desde la carpeta backend, ejecuta:
```powershell
cd backend

# Crear el servicio primero mediante la UI o usar este comando
railway link

# Seleccionar el proyecto chambasional y crear un nuevo servicio llamado "backend"

# Luego desplegar
railway up
```

---

### 2. Configurar Variables de Entorno del Backend

En la UI de Railway, dentro del servicio **backend**:

1. Ve a **"Variables"**
2. Agrega las siguientes variables:

```env
SECRET_KEY=pq1rucFHOBmKd2UxwY6XnSRhVeQ3oTlavMfy0J9WDEzINtkPiGs7L5gbZC48Aj
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=480
ENV=production

# Referencias a otros servicios (Railway las resolverá automáticamente)
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}

# CORS - actualizar con el dominio del frontend cuando esté disponible
CORS_ORIGINS=["https://*.railway.app","https://*.up.railway.app"]

# Opcionales (dejar vacío para usar MockProvider)
MAX_IMPORT_FILE_SIZE_MB=10
MAX_IMPORT_ROWS=50000
DEFAULT_PAGE_SIZE=20
MAX_PAGE_SIZE=100
OPENAI_API_KEY=
EMAIL_API_KEY=
WHATSAPP_API_KEY=
```

**IMPORTANTE**: Railway automáticamente provee `DATABASE_URL` del servicio Postgres. Usa la referencia `${{Postgres.DATABASE_URL}}` pero asegúrate de modificarla para SQLAlchemy.

Para el DATABASE_URL, Railway provee algo como:
```
postgresql://postgres:PASSWORD@postgres.railway.internal:5432/railway
```

Pero necesitamos cambiarla a:
```
postgresql+psycopg2://postgres:PASSWORD@postgres.railway.internal:5432/railway
```

---

### 3. Configurar el Dockerfile del Backend

El backend ya tiene un `Dockerfile`, pero necesitamos asegurarnos de que las migraciones se ejecuten:

Railway ya detectará el `Dockerfile`. En **Settings** → **Deploy**, configura:

**Start Command** (opcional, solo si no usa el CMD del Dockerfile):
```bash
sh -c 'alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port $PORT'
```

---

### 4. Habilitar Dominio Público para Backend

1. En el servicio **backend**, ve a **"Settings"** → **"Networking"**
2. Click en **"Generate Domain"**
3. Copia la URL generada (algo como `https://backend-production-xxxx.up.railway.app`)
4. Guarda esta URL para usarla en el frontend

---

### 5. Crear Servicio Frontend

1. Click en **"+ New Service"**
2. Selecciona **"Empty Service"**
3. Nombra el servicio: `frontend`
4. Configura **Root Directory**: `frontend`
5. Railway detectará automáticamente el `Dockerfile`

---

### 6. Configurar Variables de Entorno del Frontend

En el servicio **frontend**, agrega:

```env
# Reemplazar con la URL real del backend del paso 4
VITE_API_URL=https://backend-production-xxxx.up.railway.app/api
VITE_USE_MOCK=false
```

---

### 7. Configurar Build Args del Frontend

En **Settings** → **Build**, configura los **Build Arguments**:

```
VITE_API_URL=https://backend-production-xxxx.up.railway.app/api
VITE_USE_MOCK=false
```

---

### 8. Habilitar Dominio Público para Frontend

1. En el servicio **frontend**, ve a **"Settings"** → **"Networking"**
2. Click en **"Generate Domain"**
3. Copia la URL generada (algo como `https://frontend-production-xxxx.up.railway.app`)

---

### 9. Actualizar CORS en Backend

Vuelve al servicio **backend** y actualiza la variable `CORS_ORIGINS` para incluir el dominio exacto del frontend:

```env
CORS_ORIGINS=["https://frontend-production-xxxx.up.railway.app","https://*.railway.app"]
```

---

### 10. Monitorear el Despliegue

En cada servicio, puedes ver:
- **Deployments**: Estado del build y deployment
- **Logs**: Logs en tiempo real
- **Metrics**: Uso de CPU/memoria

---

## 🔧 Comandos CLI Útiles

```powershell
# Ver estado del proyecto
railway status

# Ver logs en tiempo real
railway logs

# Desplegar cambios
railway up

# Abrir el proyecto en el navegador
railway open

# Ver variables de entorno
railway variables

# Ejecutar comandos en el contenedor
railway run <comando>
```

---

## 🗄️ Base de Datos

### Conectarse a PostgreSQL

```powershell
# Ver la URL de conexión
railway variables

# Conectarse desde local
railway run psql $DATABASE_URL
```

### Ejecutar Migraciones Manualmente

```powershell
# Desde el servicio backend
railway run alembic upgrade head
```

### Seed de Datos (Opcional)

```powershell
# Ejecutar script de seed
railway run python seed_database.py
```

---

## 📊 Monitoreo Post-Despliegue

### 1. Verificar Backend

```bash
# Health check
curl https://backend-production-xxxx.up.railway.app/api/health

# Documentación API
https://backend-production-xxxx.up.railway.app/docs
```

### 2. Verificar Frontend

Abre en el navegador:
```
https://frontend-production-xxxx.up.railway.app
```

### 3. Probar el Flujo Completo

1. Registrar un usuario
2. Crear una empresa
3. Agregar productos
4. Registrar ventas
5. Ver dashboard

---

## 🐛 Troubleshooting

### Backend no inicia

1. Revisa los logs: `railway logs --service backend`
2. Verifica que las variables de entorno estén configuradas
3. Asegúrate de que DATABASE_URL usa `postgresql+psycopg2://`
4. Verifica que las migraciones se ejecutaron: busca `alembic upgrade head` en logs

### Frontend no se conecta al Backend

1. Verifica que `VITE_API_URL` en el frontend tenga la URL correcta del backend
2. Verifica CORS en el backend
3. Asegúrate de que el backend tenga un dominio público habilitado
4. Revisa la consola del navegador para errores de CORS

### Errores de Base de Datos

1. Verifica la conexión: `railway run psql $DATABASE_URL`
2. Revisa las migraciones: `railway run alembic current`
3. Ejecuta migraciones si es necesario: `railway run alembic upgrade head`

### Redis no conecta

1. Verifica que la variable `REDIS_URL` esté configurada como `${{Redis.REDIS_URL}}`
2. Revisa los logs de Redis: `railway logs --service Redis`

---

## 🎯 Checklist Final

- [ ] Backend desplegado y corriendo
- [ ] Frontend desplegado y corriendo
- [ ] PostgreSQL conectado al backend
- [ ] Redis conectado al backend
- [ ] Migraciones ejecutadas (`alembic upgrade head`)
- [ ] Dominios públicos generados para backend y frontend
- [ ] CORS configurado correctamente
- [ ] Variables de entorno configuradas
- [ ] Health check del backend funciona
- [ ] Frontend carga correctamente
- [ ] Login funciona
- [ ] API docs accesibles (`/docs`)

---

## 🔄 Despliegues Futuros

Para desplegar cambios:

```powershell
# Backend
cd backend
railway up

# Frontend
cd frontend
railway up
```

O simplemente haz push a tu repositorio si conectaste GitHub.

---

## 💰 Costos

Railway ofrece:
- **Hobby Plan**: $5/mes de crédito gratis
- **Pricing**: Por uso (RAM, CPU, almacenamiento)
- Este proyecto debería caber en el plan gratis para desarrollo/testing

---

## 📚 Recursos

- [Railway Docs](https://docs.railway.com/)
- [Railway CLI](https://docs.railway.com/guides/cli)
- [PostgreSQL en Railway](https://docs.railway.com/databases/postgresql)
- [Redis en Railway](https://docs.railway.com/databases/redis)
- [Variables de Entorno](https://docs.railway.com/guides/variables)

---

## 🆘 Soporte

Si tienes problemas:
1. Revisa los logs en Railway UI o con `railway logs`
2. Verifica el status con `railway status`
3. Consulta la documentación de Railway
4. Revisa los archivos `ARCHITECTURE.md` y `DEPLOYMENT.md` del proyecto
