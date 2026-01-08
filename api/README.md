# Keyrank API (Laravel)

## Prerequisites

- PHP 8.2+
- Composer
- A database (MySQL or SQLite)

## Setup

```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
```

## Run

```bash
php artisan serve
```

## Local services (MySQL, Redis, scraper)

From the repository root:

```bash
docker-compose up -d
```

## Useful env vars

- `APP_URL`
- `DB_CONNECTION`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`
- `GPLAY_SCRAPER_URL` (default: http://localhost:3001)

## Tests

```bash
php artisan test
```
