# Daily Data Refresh - Implementation Plan

## Overview

Mise à jour quotidienne automatique de toutes les données ASO.

### Scope Complet

| Feature | Fréquence | iOS | Android |
|---------|-----------|-----|---------|
| Top 100 par catégorie | Quotidien | RSS (gratuit) | Proxy requis |
| App details (users) | Quotidien | API (gratuit) | Proxy requis |
| Keywords suggestions | Cache 12h | API (gratuit) | Proxy requis |
| Rankings mots-clés | Quotidien | API (gratuit) | Proxy requis |
| AI Analysis | À la demande | GPT-5 Nano | GPT-5 Nano |

---

## Paliers de Pricing

### Variables par Palier

| Palier | Users | Apps trackées | Keywords/app | Total Keywords |
|--------|-------|---------------|--------------|----------------|
| **MVP** | 10 | 50 | 20 | 1,000 |
| **Starter** | 50 | 250 | 20 | 5,000 |
| **Growth** | 200 | 1,000 | 25 | 25,000 |
| **Scale** | 1,000 | 5,000 | 30 | 150,000 |
| **Enterprise** | 5,000+ | 25,000+ | 30 | 750,000+ |

### Calcul des Requêtes Quotidiennes

#### Opérations fixes (tous paliers)
- Top 100 iOS: 27 requêtes RSS → **Gratuit**
- Top 100 Android: 34 requêtes → **Proxy**

#### Opérations variables (par palier)
- App details: ~1 req/app/jour (50% Android)
- Rankings: 1 req/keyword unique (50% Android, dédupliqués)

### Estimation Requêtes Android/Jour

| Palier | Top 100 | App Details | Rankings* | **Total/jour** |
|--------|---------|-------------|-----------|----------------|
| MVP | 34 | 25 | 400 | **~460** |
| Starter | 34 | 125 | 1,500 | **~1,660** |
| Growth | 34 | 500 | 7,500 | **~8,000** |
| Scale | 34 | 2,500 | 25,000 | **~27,500** |
| Enterprise | 34 | 12,500 | 100,000+ | **~112,500+** |

*Rankings dédupliqués : même keyword pour plusieurs apps = 1 seule requête

### Coûts Mensuels par Palier

#### Proxy (Decodo Residential)

| Palier | GB/mois | Plan Decodo | **Coût Proxy** |
|--------|---------|-------------|----------------|
| **MVP** | ~7 | 8 GB | **$22/mois** |
| **Starter** | ~25 | 25 GB | **$65/mois** |
| **Growth** | ~120 | 50 GB × 2.5 | **$300/mois** |
| **Scale** | ~415 | 100 GB × 4 | **$900/mois** |
| **Enterprise** | ~1,700+ | Custom | **$3,000+/mois** |

#### Infrastructure Totale

| Palier | Proxy | Serveur* | Total Infra | Revenu cible** |
|--------|-------|----------|-------------|----------------|
| **MVP** | $22 | $20 | **$42/mois** | $0 (beta) |
| **Starter** | $65 | $50 | **$115/mois** | $500/mois |
| **Growth** | $300 | $100 | **$400/mois** | $2,000/mois |
| **Scale** | $900 | $300 | **$1,200/mois** | $10,000/mois |
| **Enterprise** | $3,000+ | $500+ | **$3,500+/mois** | $50,000+/mois |

*Serveur : VPS/Cloud pour API + DB + Scraper
**Revenu cible : 5x les coûts infra minimum

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    DAILY REFRESH (3:00 AM)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐            │
│  │  Top 100    │   │  User Apps  │   │  Rankings   │            │
│  │  Refresh    │   │  Refresh    │   │  Sync       │            │
│  └──────┬──────┘   └──────┬──────┘   └──────┬──────┘            │
│         │                 │                 │                    │
│    ┌────┴────┐       ┌────┴────┐       ┌────┴────┐              │
│    ▼         ▼       ▼         ▼       ▼         ▼              │
│  ┌───┐   ┌─────┐   ┌───┐   ┌─────┐   ┌───┐   ┌─────┐           │
│  │iOS│   │Andr.│   │iOS│   │Andr.│   │iOS│   │Andr.│           │
│  │RSS│   │Proxy│   │API│   │Proxy│   │API│   │Proxy│           │
│  └───┘   └─────┘   └───┘   └─────┘   └───┘   └─────┘           │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    Keywords Suggestions                      ││
│  │              (Lazy load, cache 12h, on-demand)              ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Database Schema

### Table: `top_app_entries`

```php
Schema::create('top_app_entries', function (Blueprint $table) {
    $table->id();
    $table->string('platform', 10)->index();
    $table->string('category_id', 50)->index();
    $table->string('collection', 20)->default('top_free');
    $table->string('country', 5)->default('us');
    $table->string('store_id');
    $table->string('name');
    $table->string('developer')->nullable();
    $table->string('icon_url')->nullable();
    $table->decimal('rating', 2, 1)->nullable();
    $table->unsignedInteger('rating_count')->nullable();
    $table->unsignedSmallInteger('position');
    $table->date('recorded_at')->index();
    $table->timestamps();

    $table->unique([
        'platform', 'category_id', 'collection',
        'country', 'store_id', 'recorded_at'
    ], 'unique_entry');
});
```

---

## Commands Artisan

### 1. Refresh Top 100
```php
// aso:refresh-top-apps
// Récupère le top 100 de chaque catégorie
Schedule::command('aso:refresh-top-apps')->dailyAt('03:00');
```

### 2. Refresh User Apps
```php
// aso:refresh-user-apps
// Met à jour les détails des apps trackées par les users
Schedule::command('aso:refresh-user-apps')->dailyAt('03:30');
```

### 3. Sync Rankings (existe déjà)
```php
// aso:sync-rankings
// Synchronise les positions pour tous les keywords trackés
Schedule::command('aso:sync-rankings')->dailyAt('04:00');
```

### 4. Refresh Keywords Suggestions
```php
// aso:refresh-suggestions
// Régénère les suggestions pour les apps dont le cache expire
Schedule::command('aso:refresh-suggestions')->dailyAt('05:00');
```

### Scheduler Complet
```php
// routes/console.php

// Daily refresh sequence
Schedule::command('aso:refresh-top-apps')->dailyAt('03:00');
Schedule::command('aso:refresh-user-apps')->dailyAt('03:30');
Schedule::command('aso:sync-rankings')->dailyAt('04:00');
Schedule::command('aso:refresh-suggestions --expired-only')->dailyAt('05:00');

// Weekly cleanup
Schedule::command('aso:cleanup --days=90')->weeklyOn(0, '02:00');
Schedule::command('categories:sync')->weeklyOn(0, '03:00');
```

---

## Proxy Configuration

### Provider Recommandé: Decodo (ex-Smartproxy)

| Plan | GB | Prix/mois | Prix/GB | Recommandé pour |
|------|-----|-----------|---------|-----------------|
| 2 GB | 2 | $6 | $3.00 | Tests |
| **8 GB** | 8 | **$22** | $2.75 | **MVP** |
| **25 GB** | 25 | **$65** | $2.60 | **Starter** |
| **50 GB** | 50 | **$123** | $2.45 | Growth (×2-3) |
| 100 GB | 100 | $225 | $2.25 | Scale |
| Pay-as-you-go | - | - | $3.50 | Overflow |

### Configuration

```env
# .env
PROXY_ENABLED=true
PROXY_PROVIDER=decodo
PROXY_HOST=gate.decodo.com
PROXY_PORT=10001
PROXY_USERNAME=spXXXXXX
PROXY_PASSWORD=your_password
```

```php
// config/services.php
'proxy' => [
    'enabled' => env('PROXY_ENABLED', false),
    'host' => env('PROXY_HOST'),
    'port' => env('PROXY_PORT'),
    'username' => env('PROXY_USERNAME'),
    'password' => env('PROXY_PASSWORD'),
],
```

---

## Optimisations Critiques

### 1. Déduplication des Rankings
```php
// Au lieu de chercher chaque keyword pour chaque app séparément,
// grouper par keyword unique et distribuer les résultats

$uniqueKeywords = TrackedKeyword::query()
    ->select('keyword_id')
    ->distinct()
    ->with('keyword')
    ->get();

foreach ($uniqueKeywords as $trackedKeyword) {
    $results = $this->searchKeyword($trackedKeyword->keyword->keyword);

    // Mettre à jour TOUTES les apps qui trackent ce keyword
    TrackedKeyword::where('keyword_id', $trackedKeyword->keyword_id)
        ->each(fn($tk) => $this->updateRanking($tk, $results));
}
```

### 2. Cache Intelligent
```php
// Ne pas re-fetcher si données < 24h
$app = App::find($id);
if ($app->details_fetched_at > now()->subHours(24)) {
    continue; // Skip
}
```

### 3. Batch Processing avec Rate Limiting
```php
// Traiter par lots avec délais
$apps->chunk(100, function ($chunk) {
    foreach ($chunk as $app) {
        $this->refreshApp($app);
        usleep(200_000); // 200ms entre chaque
    }
    sleep(5); // 5s entre chaque lot de 100
});
```

### 4. Prioritisation
```php
// Apps premium/actives en premier
$apps = App::query()
    ->orderByDesc('is_premium')
    ->orderByDesc('last_viewed_at')
    ->get();
```

---

## Temps d'Exécution Estimés

| Palier | Top 100 | User Apps | Rankings | Suggestions | **Total** |
|--------|---------|-----------|----------|-------------|-----------|
| MVP | 5 min | 2 min | 10 min | 5 min | **~22 min** |
| Starter | 5 min | 5 min | 30 min | 15 min | **~55 min** |
| Growth | 5 min | 15 min | 2h | 30 min | **~3h** |
| Scale | 5 min | 45 min | 6h | 1h | **~8h** |

*Avec 5 workers parallèles, diviser par ~4*

---

## Monitoring

### Métriques à Tracker
- [ ] Nombre d'apps refreshed vs erreurs
- [ ] Temps d'exécution par commande
- [ ] Bande passante proxy consommée
- [ ] Taux de cache hit

### Alertes
```php
// Si > 10% d'erreurs
if ($errorRate > 0.1) {
    Notification::send($admins, new RefreshFailedNotification($errors));
}

// Si temps > 2x normal
if ($duration > $expectedDuration * 2) {
    Log::warning('Refresh taking longer than expected', compact('duration'));
}
```

---

## Roadmap d'Implémentation

### Phase 1: MVP ($42/mois)
- [x] Top 100 iOS (RSS)
- [ ] Top 100 Android (proxy)
- [ ] Table `top_app_entries`
- [ ] Command `aso:refresh-top-apps`
- [ ] Setup proxy Decodo 8GB

### Phase 2: User Apps
- [ ] Command `aso:refresh-user-apps`
- [ ] Optimisation cache 24h
- [ ] Prioritisation apps actives

### Phase 3: Rankings
- [ ] Déduplication keywords
- [ ] Batch processing
- [ ] Historique positions

### Phase 4: Scale
- [ ] Workers parallèles (Laravel Horizon)
- [ ] Queue pour gros volumes
- [ ] Monitoring avancé

---

## Risques & Mitigations

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| Google Play ban | Haut | Moyen | Proxy résidentiel + rate limiting |
| Coût proxy explosion | Moyen | Faible | Monitoring + alertes budget |
| Timeout jobs | Moyen | Moyen | Chunking + retry |
| DB overload | Haut | Faible | Index + cleanup régulier |

---

## Résumé Coûts par Palier

| Palier | Users | Proxy | Infra | **Total/mois** | Break-even* |
|--------|-------|-------|-------|----------------|-------------|
| **MVP** | 10 | $22 | $20 | **$42** | Beta gratuit |
| **Starter** | 50 | $65 | $50 | **$115** | 12 users @ $10 |
| **Growth** | 200 | $300 | $100 | **$400** | 40 users @ $10 |
| **Scale** | 1,000 | $900 | $300 | **$1,200** | 120 users @ $10 |

*Break-even = nombre minimum d'utilisateurs payants pour couvrir les coûts
