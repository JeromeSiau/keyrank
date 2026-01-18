from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .core.config import settings
from .gplay import router as gplay_router
from .revenue import router as revenue_router

app = FastAPI(
    title="Keyrank Scraper",
    description="Unified scraper for Google Play and revenue marketplaces",
    version="0.1.0",
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    from datetime import datetime
    return {"status": "ok", "timestamp": datetime.utcnow().isoformat()}


# Include routers
app.include_router(gplay_router)
app.include_router(revenue_router)


def main():
    """Run the server."""
    import uvicorn
    uvicorn.run(
        "src.main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.debug,
    )


if __name__ == "__main__":
    main()
