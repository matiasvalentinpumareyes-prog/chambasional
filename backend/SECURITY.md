# SECURITY.md — Seguridad

## Autenticación

- JWT (HS256), expiración configurable (`ACCESS_TOKEN_EXPIRE_MINUTES`,
  8 horas por defecto).
- Contraseñas hasheadas con bcrypt (`passlib`). Nunca se almacenan en
  texto plano (verificado: la tabla `usuarios` solo tiene `hashed_password`).
- El `SECRET_KEY` se lee de variable de entorno, nunca hardcodeado en el
  código fuente. `.env.example` usa un placeholder explícito
  (`CHANGE_ME_...`), nunca un secreto real.

## Autorización
  (`/api/settings`, `/api/models/*`) requieren `admin` explícitamente vía
  la dependencia `require_admin`.

## Aislamiento multi-tenant

- Cada repositorio recibe `emp_id` como parámetro obligatorio y lo
  aplica en cada consulta.

## Validación de inputs

- Todos los payloads de entrada pasan por schemas Pydantic con
  validación de tipos, longitudes y rangos (`Field(gt=0)`, `EmailStr`, etc.).
- SQL injection: mitigado por diseño, ya que todo el acceso a datos usa
  el ORM de SQLAlchemy con queries parametrizadas — nunca se concatenan
  strings SQL en este proyecto.
- Importación de archivos: validación de columnas, tipos, fechas,
  duplicados y referencias antes de escribir cualquier dato (sección 10).

## CORS

Configurado explícitamente en `app/core/config.py` (`CORS_ORIGINS`),
restringido a los orígenes del frontend — no se usa `allow_origins=["*"]`
en producción.

## Manejo de errores

Formato de error consistente (sección 52); nunca se expone un stack
trace al cliente (`app/main.py`, manejador de excepción genérica).

## Auditoría

Tabla `audit_logs` registra acciones sensibles (registro de negocio,
login, creación/cambio de estado de campañas, confirmación de
importaciones), con usuario, entidad y resultado — nunca contraseñas ni
secretos.

## Pendiente para producción (fuera del alcance de este MVP)

- Rate limiting a nivel de proxy/gateway (no implementado en la
  aplicación misma).
- Rotación de `SECRET_KEY` y almacenamiento en un vault (Secrets Manager,
  Vault, etc.) en vez de variable de entorno plana.
- HTTPS/TLS: se asume terminado en el proxy inverso de despliegue (Nginx,
  Railway, etc.), no en la aplicación FastAPI directamente.
