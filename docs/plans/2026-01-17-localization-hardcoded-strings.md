# Localization: Migrate Hardcoded Strings

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Migrate ~50 hardcoded user-facing strings to the ARB localization files and update Dart files to use `context.l10n`.

**Architecture:** Add missing keys to `app_en.arb` (source), then sync to all other language ARB files. Update Dart presentation files to use `context.l10n.keyName` instead of hardcoded strings.

**Tech Stack:** Flutter l10n with ARB files, `AppLocalizations` via `context.l10n` extension.

---

## Pre-requisites

- Convention: Keys use `feature_keyName` format (e.g., `settings_manageAlerts`)
- Placeholders use `@keyName` annotations with `placeholders` object
- After ARB changes, run: `flutter gen-l10n` (auto-runs on build)

---

## Task 1: Settings Screen - Missing Keys

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/settings/presentation/settings_screen.dart`

**Step 1: Add keys to app_en.arb**

Add after `settings_manageAlertsDesc`:

```json
  "settings_alertDelivery": "ALERT DELIVERY",
  "settings_team": "TEAM",
  "settings_teamManagement": "Team Management",
  "settings_teamManagementDesc": "Invite members, manage roles & permissions",
  "settings_integrations": "INTEGRATIONS",
  "settings_manageIntegrations": "Manage Integrations",
  "settings_manageIntegrationsDesc": "Connect App Store Connect & Google Play Console",
  "settings_billing": "BILLING",
  "settings_plansBilling": "Plans & Billing",
  "settings_plansBillingDesc": "Manage your subscription and payment",
```

**Step 2: Update settings_screen.dart**

Replace hardcoded strings:
- `'NOTIFICATIONS'` → `context.l10n.settings_notifications`
- `'ALERT DELIVERY'` → `context.l10n.settings_alertDelivery`
- `'TEAM'` → `context.l10n.settings_team`
- `'Team Management'` → `context.l10n.settings_teamManagement`
- `'Invite members, manage roles & permissions'` → `context.l10n.settings_teamManagementDesc`
- `'Manage Integrations'` → `context.l10n.settings_manageIntegrations`
- `'Connect App Store Connect & Google Play Console'` → `context.l10n.settings_manageIntegrationsDesc`
- `'Plans & Billing'` → `context.l10n.settings_plansBilling`
- `'Manage your subscription and payment'` → `context.l10n.settings_plansBillingDesc`

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/settings/presentation/settings_screen.dart
git commit -m "i18n: localize settings screen hardcoded strings"
```

---

## Task 2: Onboarding Screen

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/onboarding/presentation/onboarding_screen.dart`

**Step 1: Add keys to app_en.arb**

```json
  "onboarding_welcomeToKeyrank": "Welcome to Keyrank",
  "onboarding_skip": "Skip",
  "onboarding_back": "Back",
  "onboarding_continue": "Continue",
  "onboarding_getStarted": "Get Started",
```

**Step 2: Update onboarding_screen.dart**

Replace:
- `'Welcome to Keyrank'` → `context.l10n.onboarding_welcomeToKeyrank`
- `'Skip'` → `context.l10n.onboarding_skip`
- `'Back'` → `context.l10n.onboarding_back`
- `'Get Started'` → `context.l10n.onboarding_getStarted`
- `'Continue'` → `context.l10n.onboarding_continue`

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/onboarding/presentation/onboarding_screen.dart
git commit -m "i18n: localize onboarding screen"
```

---

## Task 3: Team Feature - Member Tile

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/team/presentation/widgets/member_list_tile.dart`

**Step 1: Add keys to app_en.arb**

```json
  "team_you": "You",
  "team_changeRoleButton": "Change Role",
  "team_removeButton": "Remove",
```

**Step 2: Update member_list_tile.dart**

Replace:
- `'You'` → `context.l10n.team_you`
- `'Change Role'` → `context.l10n.team_changeRoleButton`
- `'Remove'` → `context.l10n.team_removeButton`

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/team/presentation/widgets/member_list_tile.dart
git commit -m "i18n: localize team member list tile"
```

---

## Task 4: Competitors Screen - Dialogs

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/keywords/presentation/competitors_screen.dart`

**Step 1: Add keys to app_en.arb**

```json
  "competitors_removeTitle": "Remove Competitor",
  "competitors_removeConfirm": "Are you sure you want to remove \"{name}\" from your competitors?",
  "@competitors_removeConfirm": {
    "placeholders": {
      "name": { "type": "String" }
    }
  },
  "competitors_removed": "{name} removed",
  "@competitors_removed": {
    "placeholders": {
      "name": { "type": "String" }
    }
  },
  "competitors_removeFailed": "Failed to remove competitor: {error}",
  "@competitors_removeFailed": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
```

**Step 2: Update competitors_screen.dart**

Replace:
- `'Remove Competitor'` → `context.l10n.competitors_removeTitle`
- `'Are you sure you want to remove "${competitor.name}" from your competitors?'` → `context.l10n.competitors_removeConfirm(name: competitor.name)`
- `'Cancel'` → `context.l10n.common_cancel`
- `'Remove'` → `context.l10n.team_removeButton` (or create `common_remove`)
- `'${competitor.name} removed'` → `context.l10n.competitors_removed(name: competitor.name)`
- `'Failed to remove competitor: $e'` → `context.l10n.competitors_removeFailed(error: e.toString())`

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/keywords/presentation/competitors_screen.dart
git commit -m "i18n: localize competitors removal dialogs"
```

---

## Task 5: Add Competitor Screen - Success/Error Messages

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/competitors/presentation/add_competitor_screen.dart`

**Step 1: Add keys to app_en.arb**

```json
  "competitors_addedAsCompetitor": "{name} added as competitor",
  "@competitors_addedAsCompetitor": {
    "placeholders": {
      "name": { "type": "String" }
    }
  },
  "competitors_addFailed": "Failed to add competitor: {error}",
  "@competitors_addFailed": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
```

**Step 2: Update add_competitor_screen.dart**

Replace:
- `'${app.name} added as competitor'` → `context.l10n.competitors_addedAsCompetitor(name: app.name)`
- `'Failed to add competitor: $e'` → `context.l10n.competitors_addFailed(error: e.toString())`

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/competitors/presentation/add_competitor_screen.dart
git commit -m "i18n: localize add competitor messages"
```

---

## Task 6: App Preview Screen - Success/Error Messages

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/apps/presentation/app_preview_screen.dart`

**Step 1: Add keys to app_en.arb**

```json
  "appPreview_addedToApps": "{name} added to your apps",
  "@appPreview_addedToApps": {
    "placeholders": {
      "name": { "type": "String" }
    }
  },
  "appPreview_addFailed": "Failed to add app: {error}",
  "@appPreview_addFailed": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
```

**Step 2: Update app_preview_screen.dart**

Replace:
- `'${widget.preview.name} added to your apps'` → `context.l10n.appPreview_addedToApps(name: widget.preview.name)`
- `'Failed to add app: $e'` → `context.l10n.appPreview_addFailed(error: e.toString())`
- `'${widget.preview.name} added as competitor'` → `context.l10n.competitors_addedAsCompetitor(name: widget.preview.name)`
- `'Failed to add competitor: $e'` → `context.l10n.competitors_addFailed(error: e.toString())`

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/apps/presentation/app_preview_screen.dart
git commit -m "i18n: localize app preview success/error messages"
```

---

## Task 7: Alerts - Edit/Delete Labels

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/alerts/presentation/widgets/alert_rule_tile.dart`

**Step 1: Add keys to app_en.arb**

```json
  "alerts_edit": "Edit",
  "alerts_delete": "Delete",
  "alerts_scopeAll": "All apps",
  "alerts_scopeApp": "Specific app",
  "alerts_scopeCategory": "Category",
  "alerts_scopeKeyword": "Keyword",
```

**Step 2: Update alert_rule_tile.dart**

Replace:
- `'Edit'` → `context.l10n.alerts_edit` (or use `context.l10n.common_edit`)
- `'Delete'` → `context.l10n.alerts_delete` (or use `context.l10n.common_delete`)
- `'All apps'` → `context.l10n.alerts_scopeAll`
- etc.

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/alerts/presentation/widgets/alert_rule_tile.dart
git commit -m "i18n: localize alert rule tile labels"
```

---

## Task 8: Ratings Analysis - Pagination

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/ratings/presentation/ratings_analysis_screen.dart`

**Step 1: Add keys to app_en.arb**

```json
  "ratings_showMore": "Show more ({count} remaining)",
  "@ratings_showMore": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },
  "ratings_showLess": "Show less",
```

**Step 2: Update ratings_analysis_screen.dart**

Replace:
- `'Show more (${filteredRatings.length - pageSize} remaining)'` → `context.l10n.ratings_showMore(count: filteredRatings.length - pageSize)`
- `'Show less'` → `context.l10n.ratings_showLess`

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/ratings/presentation/ratings_analysis_screen.dart
git commit -m "i18n: localize ratings pagination"
```

---

## Task 9: Competitor Keywords Tab

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/competitors/presentation/widgets/competitor_keywords_tab.dart`

**Step 1: Add keys to app_en.arb**

```json
  "competitors_addKeywordTitle": "Add Keyword to Competitor",
  "competitors_addKeywordPrompt": "Enter keywords to track for this competitor (one per line):",
  "competitors_addKeywordHint": "budget tracker\nexpense manager\nmoney app",
  "competitors_nowTracking": "Now tracking \"{keyword}\"",
  "@competitors_nowTracking": {
    "placeholders": {
      "keyword": { "type": "String" }
    }
  },
  "competitors_trackFailed": "Failed to track keyword: {error}",
  "@competitors_trackFailed": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
```

**Step 2: Update competitor_keywords_tab.dart**

Replace hardcoded strings with localized versions.

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/competitors/presentation/widgets/competitor_keywords_tab.dart
git commit -m "i18n: localize competitor keywords tab"
```

---

## Task 10: Competitor Metadata History Tab

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/competitors/presentation/widgets/competitor_metadata_history_tab.dart`

**Step 1: Add keys to app_en.arb**

```json
  "competitors_exportedCsv": "Exported {bytes} bytes of CSV data",
  "@competitors_exportedCsv": {
    "placeholders": {
      "bytes": { "type": "int" }
    }
  },
  "competitors_exportFailed": "Export failed: {error}",
  "@competitors_exportFailed": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "competitors_analyzingStrategy": "Analyzing competitor strategy...",
```

**Step 2: Update competitor_metadata_history_tab.dart**

Replace hardcoded strings.

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/competitors/presentation/widgets/competitor_metadata_history_tab.dart
git commit -m "i18n: localize competitor metadata history tab"
```

---

## Task 11: Chat Screen - Error Messages

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/chat/presentation/chat_screen.dart`

**Step 1: Add keys to app_en.arb**

```json
  "chat_createFailed": "Failed to create conversation: {error}",
  "@chat_createFailed": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "chat_deleteFailed": "Failed to delete: {error}",
  "@chat_deleteFailed": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
```

**Step 2: Update chat_screen.dart**

Replace hardcoded error messages.

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/chat/presentation/chat_screen.dart
git commit -m "i18n: localize chat error messages"
```

---

## Task 12: Actionable Insights - View All

**Files:**
- Modify: `app/lib/l10n/app_en.arb`
- Modify: `app/lib/features/actionable_insights/presentation/widgets/insights_dashboard_section.dart`

**Step 1: Add keys to app_en.arb**

```json
  "actionableInsights_viewAll": "View all",
  "actionableInsights_viewMore": "View {count} more insights",
  "@actionableInsights_viewMore": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },
```

**Step 2: Update insights_dashboard_section.dart**

Replace:
- `'View all'` → `context.l10n.actionableInsights_viewAll`
- `'View ${summary.insights.length - 3} more insights'` → `context.l10n.actionableInsights_viewMore(count: summary.insights.length - 3)`

**Step 3: Commit**

```bash
git add app/lib/l10n/app_en.arb app/lib/features/actionable_insights/presentation/widgets/insights_dashboard_section.dart
git commit -m "i18n: localize actionable insights section"
```

---

## Task 13: Notifications Screen Title

**Files:**
- Modify: `app/lib/features/notifications/presentation/notifications_screen.dart`

**Step 1: Update notifications_screen.dart**

Replace:
- `'Notifications'` → `context.l10n.notifications_title`

(Key already exists in ARB)

**Step 2: Commit**

```bash
git add app/lib/features/notifications/presentation/notifications_screen.dart
git commit -m "i18n: use localized notifications title"
```

---

## Task 14: Sync All Translations to Other Languages

**Files:**
- Modify: `app/lib/l10n/app_fr.arb`
- Modify: `app/lib/l10n/app_de.arb`
- Modify: `app/lib/l10n/app_es.arb`
- Modify: `app/lib/l10n/app_it.arb`
- Modify: `app/lib/l10n/app_ja.arb`
- Modify: `app/lib/l10n/app_ko.arb`
- Modify: `app/lib/l10n/app_pt.arb`
- Modify: `app/lib/l10n/app_tr.arb`
- Modify: `app/lib/l10n/app_zh.arb`

**Step 1: Add French translations to app_fr.arb**

Add French translations for all new keys.

**Step 2: Add German translations to app_de.arb**

**Step 3: Add Spanish translations to app_es.arb**

**Step 4: Add other language translations**

(For non-English languages, use professional translations or AI-assisted translations)

**Step 5: Commit**

```bash
git add app/lib/l10n/
git commit -m "i18n: add translations for new keys in all languages"
```

---

## Task 15: Regenerate Localizations and Test

**Step 1: Regenerate localizations**

```bash
cd app && flutter gen-l10n
```

**Step 2: Run build to verify**

```bash
cd app && flutter analyze
```

**Step 3: Test app startup**

```bash
cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api
```

**Step 4: Commit generated files**

```bash
git add app/lib/l10n/app_localizations*.dart
git commit -m "i18n: regenerate localization files"
```

---

## Summary

Total: ~50 hardcoded strings across 15 tasks
- 13 tasks for Dart file updates
- 1 task for syncing translations
- 1 task for regeneration and testing

Each task is independent and can be done incrementally with commits.
