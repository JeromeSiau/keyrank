from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    # Server
    host: str = "0.0.0.0"
    port: int = 3001
    debug: bool = False

    # Proxy configuration
    # Format: url|country,url|country (country optional)
    # Example: http://user:pass@proxy1.com:8080|us,http://user:pass@proxy2.com:8080
    proxy_list: str = ""

    # Rate limiting
    rate_limit_delay_ms: int = 200  # Delay between requests in ms

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


settings = Settings()
