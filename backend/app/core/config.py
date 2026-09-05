from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    Configuración de la aplicación, cargada desde variables de entorno.

    Nunca colocar secretos reales aquí (regla 94.16 del brief). Los valores
    por defecto solo sirven para desarrollo local; en producción deben
    sobrescribirse mediante variables de entorno reales (sección 62).
    """

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    PROJECT_NAME: str = "Marketing Predictivo API"
    API_V1_PREFIX: str = "/api"

    DATABASE_URL: str = "postgresql+psycopg2://postgres:postgres@localhost:5432/marketing_predictivo"

    SECRET_KEY: str = "CHANGE_ME_IN_PRODUCTION_USE_ENV_VAR"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 8  # 8 horas

    REDIS_URL: str = "redis://localhost:6379/0"

    # Credenciales opcionales de canales externos (sección 91): mientras
    # estén vacías, el sistema usa MockProvider automáticamente.
    EMAIL_API_KEY: str = ""
    WHATSAPP_API_KEY: str = ""
    SMS_API_KEY: str = ""
    OPENAI_API_KEY: str = ""

    CORS_ORIGINS: list[str] = ["http://localhost:5173", "http://127.0.0.1:5173"]

    # Límites de importación (sección 36: límites de tamaño de archivos)
    MAX_IMPORT_FILE_SIZE_MB: int = 10
    MAX_IMPORT_ROWS: int = 50_000

    # Paginación (sección 53)
    DEFAULT_PAGE_SIZE: int = 20
    MAX_PAGE_SIZE: int = 100

    ENV: str = "development"


settings = Settings()
