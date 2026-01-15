# Keyrank V1 Spec (Agences + Indés)

## 1. Résumé
Keyrank V1 transforme la donnée ASO iOS + Google Play en décisions actionnables. La promesse : « en moins de 5 minutes, je sais quoi faire pour améliorer mes rankings ». Le produit se concentre sur 4 piliers : opportunités mots‑clés, suivi de positions/alertes, analyse concurrents, insights reviews.

## 2. Objectifs
- Time‑to‑Insight < 5 minutes après onboarding.
- 1 opportunité actionnable/app suivie.
- 1 alerte utile/semaine/utilisateur (éviter fatigue).
- Dashboard principal consulté ≥ 3x/semaine.

## 3. Non‑objectifs
- Couverture mondiale exhaustive dès V1.
- Modèles ML avancés (start rules‑based).
- Actions automatiques sur metadata.

## 4. Personas
- **Agence ASO** : reporting client, alertes fiables, gain de temps.
- **Indé** : guidance simple, priorisation claire, faible effort.

## 5. Plateformes & marchés
- iOS App Store + Google Play.
- Marchés initiaux : FR, US, UK, DE, ES, IT.
- Extension via crawl à la demande (apps/keywords suivis).

## 6. Parcours utilisateur
1) Import d’apps (iOS/GP) → 2) Ajout 5–10 keywords → 3) Choix pays → 4) Dashboard “Opportunités / Risques / Concurrents”.

## 7. Fonctionnalités V1
### 7.1 Opportunity Engine
- Liste priorisée d’opportunités par app/pays.
- Explication : « pourquoi c’est une opportunité » (trend, concurrence, gap).
- CTA : suivre keyword, ajuster metadata, monitorer concurrent.

### 7.2 Tracking positions & alertes
- Historique des positions par keyword/pays.
- Alertes : pertes rapides, gains anormaux, entrée concurrent top 10.
- Fréquence configurable (quotidien/hebdo) + priorité d’impact.

### 7.3 Analyse concurrents
- Top concurrents par keyword + catégorie.
- Alertes sur concurrents en hausse et nouveaux entrants.

### 7.4 Reviews insights
- Sentiment global par langue/pays.
- Thèmes récurrents (problèmes UX, features demandées).
- Alerte sur chute rating.

## 8. Scoring d’opportunité (V1)
Score final sur 0–100, pondéré et normalisé. Objectif : prioriser les keywords avec fort potentiel et faible friction.

### 8.1 Inputs
- **Search Volume (SV)** : popularité relative (0–100).
- **Difficulty (DIFF)** : densité de concurrents + force des apps en top 10 (0–100, élevé = dur).
- **Rank Gap (GAP)** : distance entre rang actuel et top 10 (0–100, élevé = loin).
- **Trend (TR)** : variation sur 7–30 jours (‑50 à +50, normalisé 0–100).
- **App Fit (FIT)** : similarité sémantique app/keyword (0–100) basée sur metadata + catégories.
- **Conversion Signal (CVR)** : proxy via rating + reviews récentes (0–100).

### 8.2 Formule
- **Opportunity Score = 0.30×SV + 0.20×TR + 0.20×FIT + 0.15×CVR + 0.10×(100‑DIFF) + 0.05×(100‑GAP)**
- Seuils :
  - **≥ 75** = opportunité prioritaire
  - **60–74** = opportunité secondaire
  - **< 60** = ignorer (pour V1)

### 8.3 Règles d’explication
- Afficher 2–3 facteurs dominants (ex : “Trend +25%” + “faible concurrence”).
- Étiquettes simples : `En hausse`, `Facile`, `Très pertinent`, `Fort potentiel`.

## 9. Data collection & fréquence
- Collecte quotidienne des keywords suivis (priorité haute).
- Collecte hebdo des mots‑clés non suivis.
- App metadata : hebdo (ou à chaque release détectée).
- Reviews : quotidien pour apps suivies.

## 10. Modèle de données (simplifié)
- **App** (store, store_id, name, category, rating, locale)
- **Keyword** (text, locale)
- **AppKeyword** (app_id, keyword_id, country, current_rank)
- **RankingHistory** (app_keyword_id, date, rank)
- **Competitor** (app_id, competitor_app_id, keyword_id)
- **Review** (app_id, rating, text, locale, date)
- **Opportunity** (app_id, keyword_id, score, factors)

## 11. APIs / Endpoints (V1)
- `GET /apps` / `POST /apps/import`
- `GET /apps/{id}/keywords`
- `GET /apps/{id}/opportunities`
- `GET /apps/{id}/rankings` (timeseries)
- `GET /apps/{id}/competitors`
- `GET /apps/{id}/reviews/insights`
- `GET /alerts`

## 12. UX & IA
- Home = 3 cartes : Opportunités / Risques / Concurrents.
- Détails keyword = ranking timeline + explication score.
- Détails app = résumé + alertes + insights reviews.

## 13. Notifications
- Email/Slack pour agences, push/app pour indés.
- Suppression bruit : max 1 alert “haute priorité”/jour.

## 14. Performance & fiabilité
- Dashboard < 2s (cache côté API).
- Freshness données : 24h max pour keywords suivis.
- Error budget : < 1% d’échecs de crawl critiques.

## 15. Observabilité
- Taux de crawl, latence API, freshness.
- Alertes infra si crawl > 5% en échec.

## 16. Tests
- Unit tests scoring opportunités.
- Tests API endpoints critiques.
- Tests UI sur dashboard principal.

## 17. Risques
- Coût de crawl élevé si pas de priorisation.
- Alertes trop fréquentes → fatigue.
- Différences iOS/GP dans la structure des keywords.

## 18. Roadmap 30/60/90 jours (détaillée)
### 18.1 J+30 — Valeur immédiate
**Objectifs**
- Lancer un cockpit actionnable pour agences + indés.
- Prouver la valeur des opportunités et alertes simples.

**Livrables**
- Onboarding rapide (import apps, 5–10 keywords, pays).
- Dashboard 3 cartes (Opportunités / Risques / Concurrents).
- Opportunity Engine V1 (scoring basique, explication).
- Alertes rank drops + concurrents top 10.
- Collecte quotidienne keywords suivis.

**Métriques de succès**
- 70% des nouveaux comptes voient ≥ 1 opportunité.
- Time‑to‑Insight < 5 minutes.
- NPS onboarding ≥ 30.

**Risques & mitigations**
- Risque : données insuffisantes → Mitigation : enrichir via crawl à la demande.
- Risque : alertes trop fréquentes → Mitigation : priorité haute uniquement.

### 18.2 J+60 — Différenciation
**Objectifs**
- Améliorer la précision des opportunités.
- Ajouter insights reviews et suggestions d’actions.

**Livrables**
- Scoring multi‑facteurs (fit + trend + concurrence).
- Insights reviews (thèmes + rating dips).
- Suggestions d’actions (keywords à tester, metadata hints).
- Reporting simple pour agences (exports snapshots).
- Alertes gains anormaux et churn concurrent.

**Métriques de succès**
- 40% des utilisateurs suivent ≥ 1 opportunité/semaine.
- Taux d’ouverture alertes ≥ 35%.
- ≥ 2 actions suivies par app active.

**Risques & mitigations**
- Risque : scoring perçu comme « opaque » → Mitigation : explication 2–3 facteurs.
- Risque : effort reporting trop élevé → Mitigation : templates simples.

### 18.3 J+90 — Avantage défensif
**Objectifs**
- Relier actions → impact pour prouver la valeur.
- Stabiliser infra et maîtriser coûts.

**Livrables**
- Corrélation actions → variations ranking.
- Alertes intelligentes (priorité, fréquence adaptative).
- Segmentation agences (multi‑clients, quotas).
- Monitoring infra (freshness, crawl failures, latence).

**Métriques de succès**
- 25% des actions montrent un impact mesurable.
- Freshness < 24h pour 90% des keywords suivis.
- CAC payback < 3 mois (agences).

**Risques & mitigations**
- Risque : corrélation bruitée → Mitigation : seuils de confiance.
- Risque : coûts infra → Mitigation : backoff + quotas par plan.

## 19. Open questions
- Pondération finale du scoring (valider avec données réelles).
- Marchés initiaux exacts (FR/US/UK/DE/ES/IT à confirmer).
- Limites par plan (quotas de keywords/apps).

## 20. Addendum V1 "tightened" (definitions + rules + fallback)
Objectif: clarifier les definitions de metriques, les regles d alertes, et l experience utilisateur avant que la collecte soit complete.

### 20.1 Definitions operationnelles des metriques
- **SV (Search Volume)**: moyenne mobile 30j par keyword/pays, normalisee 0-100 par percentile au sein du pays (p10=10, p90=90), puis clamp.
- **DIFF (Difficulty)**: score 0-100 base sur densite top 10 (nombre d apps uniques) + force moyenne des apps top 10 (rating + installs proxy + nombre de reviews). 0 = facile.
- **GAP (Rank Gap)**: distance au top 10. 0 si rank <= 10, 100 si rank >= 100 ou inconnu.
- **TR (Trend)**: variation 7j vs 30j en %, normalisee 0-100 avec 50 = stable.
- **FIT (App Fit)**: similarite semantique keyword vs metadata (titre, sous-titre, description, categories). Score cosine 0-100.
- **CVR (Conversion Signal)**: proxy simple base sur rating (poids fort) + volume de reviews 30j (poids moyen) + variation rating (poids faible).

**Regles de donnees minimales**
- Si SV ou DIFF manquant: ne pas scorer et marquer "donnees insuffisantes".
- Si TR manquant: fixer TR=50 (neutre) + marquer facteur "trend indisponible".
- FIT ou CVR manquant: remplacer par mediane du pays/categorie et afficher un badge "estime".

### 20.2 Regles d alertes (priorite + arbitrage)
- **Haute priorite** (max 1/jour/utilisateur): chute rank >= 15 places en 24h OU concurrent entre en top 10 sur keyword suivi.
- **Moyenne priorite**: gain rapide >= 10 places en 7j, ou trend keyword >= +20%.
- **Basse priorite**: nouveaux concurrents top 50, ou variations mineures.

**Arbitrage**
- Si > 1 haute priorite: choisir celle avec impact score le plus eleve (SV*0.4 + DIFF*0.3 + GAP*0.3).
- Si 0 haute priorite: envoyer 1 moyenne priorite/semaine max.
- Cooldown par keyword: 7 jours entre alertes similaires.

### 20.3 Fallback UX (premier login sans data complete)
- Afficher un "Snapshot provisoire": top keywords par categorie + 3 opportunites estimees.
- Bannieres de statut: "Collecte en cours (x% termine)" + ETA.
- CTA direct: "Suivre ces keywords" pour accelerer la collecte.

## 21. Recommandations prioritaires
1) **Stabiliser les definitions de metriques** avant de coder le scoring, sinon le score changera chaque sprint.
2) **Ajouter un mode fallback** pour eviter un onboarding vide si la collecte prend > 1h.
3) **Limiter les alertes** a une logique stricte de priorite pour eviter fatigue des agences.
4) **Tracer l explication du score** des le debut (2-3 facteurs dominants) pour eviter l effet "boite noire".
5) **Prevoir un job de recalibrage** hebdo des normalisations (percentiles) par pays.
