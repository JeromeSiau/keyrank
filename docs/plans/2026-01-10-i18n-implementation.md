# i18n Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement multilingual support for 10 languages (EN, FR, DE, ES, PT, IT, JA, KO, ZH, TR) with locale persistence via backend API.

**Architecture:** Flutter standard i18n with ARB files + `flutter_localizations`. Locale managed via Riverpod provider, persisted in backend database. User can override system locale in Settings.

**Tech Stack:** flutter_localizations, intl, Riverpod, Dio (existing API client)

---

## Task 1: Setup i18n Infrastructure

**Files:**
- Create: `app/l10n.yaml`
- Modify: `app/pubspec.yaml`

**Step 1: Add flutter_localizations dependency to pubspec.yaml**

In `app/pubspec.yaml`, add under `dependencies:`:

```yaml
  flutter_localizations:
    sdk: flutter
```

**Step 2: Create l10n.yaml configuration**

Create `app/l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

**Step 3: Run flutter pub get**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter pub get
```

**Step 4: Commit**

```bash
git add app/pubspec.yaml app/l10n.yaml && git commit -m "feat(i18n): add flutter_localizations and l10n config"
```

---

## Task 2: Create English ARB File (Source of Truth)

**Files:**
- Create: `app/lib/l10n/app_en.arb`

**Step 1: Create l10n directory**

```bash
mkdir -p /Users/jerome/Projets/web/flutter/ranking/app/lib/l10n
```

**Step 2: Create app_en.arb with all strings**

Create `app/lib/l10n/app_en.arb`:

```json
{
  "@@locale": "en",

  "appTagline": "Track your App Store rankings",

  "auth_welcomeBack": "Welcome back",
  "auth_signInSubtitle": "Sign in to your account",
  "auth_createAccount": "Create account",
  "auth_createAccountSubtitle": "Start tracking your rankings",
  "auth_emailLabel": "Email",
  "auth_passwordLabel": "Password",
  "auth_nameLabel": "Name",
  "auth_confirmPasswordLabel": "Confirm password",
  "auth_signInButton": "Sign in",
  "auth_signUpButton": "Create account",
  "auth_noAccount": "Don't have an account?",
  "auth_hasAccount": "Already have an account?",
  "auth_signUpLink": "Sign up",
  "auth_signInLink": "Sign in",
  "auth_emailRequired": "Please enter your email",
  "auth_emailInvalid": "Invalid email",
  "auth_passwordRequired": "Please enter your password",
  "auth_enterPassword": "Please enter a password",
  "auth_nameRequired": "Please enter your name",
  "auth_passwordMinLength": "Password must be at least 8 characters",
  "auth_passwordsNoMatch": "Passwords do not match",
  "auth_errorOccurred": "An error occurred",

  "common_retry": "Retry",
  "common_error": "Error: {message}",
  "@common_error": {
    "placeholders": {
      "message": { "type": "String" }
    }
  },
  "common_loading": "Loading...",
  "common_add": "Add",
  "common_filter": "Filter",
  "common_sort": "Sort",
  "common_refresh": "Refresh",
  "common_settings": "Settings",

  "dashboard_title": "Dashboard",
  "dashboard_addApp": "Add App",
  "dashboard_appsTracked": "Apps Tracked",
  "dashboard_keywords": "Keywords",
  "dashboard_avgPosition": "Avg Position",
  "dashboard_top10": "Top 10",
  "dashboard_trackedApps": "Tracked Apps",
  "dashboard_quickActions": "Quick Actions",
  "dashboard_addNewApp": "Add a new app",
  "dashboard_searchKeywords": "Search keywords",
  "dashboard_viewAllApps": "View all apps",
  "dashboard_noAppsYet": "No apps tracked yet",
  "dashboard_addAppToStart": "Add an app to start tracking keywords",
  "dashboard_noAppsMatchFilter": "No apps match filter",
  "dashboard_changeFilterCriteria": "Try changing the filter criteria",

  "apps_title": "My Apps",
  "apps_appCount": "{count} apps",
  "@apps_appCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },
  "apps_tableApp": "APP",
  "apps_tableDeveloper": "DEVELOPER",
  "apps_tableKeywords": "KEYWORDS",
  "apps_tablePlatform": "PLATFORM",
  "apps_tableRating": "RATING",
  "apps_tableBestRank": "BEST RANK",
  "apps_noAppsYet": "No apps tracked yet",
  "apps_addAppToStart": "Add an app to start tracking its rankings",

  "addApp_title": "Add App",
  "addApp_searchAppStore": "Search App Store...",
  "addApp_searchPlayStore": "Search Play Store...",
  "addApp_searchForApp": "Search for an app",
  "addApp_enterAtLeast2Chars": "Enter at least 2 characters",
  "addApp_noResults": "No results found",
  "addApp_addedSuccess": "{name} added successfully",
  "@addApp_addedSuccess": {
    "placeholders": {
      "name": { "type": "String" }
    }
  },

  "settings_title": "Settings",
  "settings_language": "Language",
  "settings_appearance": "Appearance",
  "settings_theme": "Theme",
  "settings_themeSystem": "System",
  "settings_themeDark": "Dark",
  "settings_themeLight": "Light",
  "settings_account": "Account",
  "settings_memberSince": "Member since",
  "settings_logout": "Log out",
  "settings_languageSystem": "System",

  "filter_all": "All",
  "filter_allApps": "All Apps",
  "filter_ios": "iOS",
  "filter_iosOnly": "iOS Only",
  "filter_android": "Android",
  "filter_androidOnly": "Android Only",
  "filter_favorites": "Favorites",

  "sort_recent": "Recent",
  "sort_recentlyAdded": "Recently Added",
  "sort_nameAZ": "Name A-Z",
  "sort_nameZA": "Name Z-A",
  "sort_keywords": "Keywords",
  "sort_mostKeywords": "Most Keywords",
  "sort_bestRank": "Best Rank",

  "userMenu_logout": "Log out"
}
```

**Step 3: Generate localizations**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter gen-l10n
```

**Step 4: Commit**

```bash
git add app/lib/l10n/ && git commit -m "feat(i18n): add English ARB file with all strings"
```

---

## Task 3: Create Translation ARB Files

**Files:**
- Create: `app/lib/l10n/app_fr.arb`
- Create: `app/lib/l10n/app_de.arb`
- Create: `app/lib/l10n/app_es.arb`
- Create: `app/lib/l10n/app_pt.arb`
- Create: `app/lib/l10n/app_it.arb`
- Create: `app/lib/l10n/app_ja.arb`
- Create: `app/lib/l10n/app_ko.arb`
- Create: `app/lib/l10n/app_zh.arb`
- Create: `app/lib/l10n/app_tr.arb`

**Step 1: Create app_fr.arb (French)**

```json
{
  "@@locale": "fr",
  "appTagline": "Suivez vos classements App Store",
  "auth_welcomeBack": "Bon retour",
  "auth_signInSubtitle": "Connectez-vous a votre compte",
  "auth_createAccount": "Creer un compte",
  "auth_createAccountSubtitle": "Commencez a suivre vos classements",
  "auth_emailLabel": "Email",
  "auth_passwordLabel": "Mot de passe",
  "auth_nameLabel": "Nom",
  "auth_confirmPasswordLabel": "Confirmer le mot de passe",
  "auth_signInButton": "Se connecter",
  "auth_signUpButton": "Creer un compte",
  "auth_noAccount": "Pas encore de compte ?",
  "auth_hasAccount": "Deja un compte ?",
  "auth_signUpLink": "S'inscrire",
  "auth_signInLink": "Se connecter",
  "auth_emailRequired": "Veuillez entrer votre email",
  "auth_emailInvalid": "Email invalide",
  "auth_passwordRequired": "Veuillez entrer votre mot de passe",
  "auth_enterPassword": "Veuillez entrer un mot de passe",
  "auth_nameRequired": "Veuillez entrer votre nom",
  "auth_passwordMinLength": "Le mot de passe doit contenir au moins 8 caracteres",
  "auth_passwordsNoMatch": "Les mots de passe ne correspondent pas",
  "auth_errorOccurred": "Une erreur est survenue",
  "common_retry": "Reessayer",
  "common_error": "Erreur : {message}",
  "common_loading": "Chargement...",
  "common_add": "Ajouter",
  "common_filter": "Filtrer",
  "common_sort": "Trier",
  "common_refresh": "Actualiser",
  "common_settings": "Parametres",
  "dashboard_title": "Tableau de bord",
  "dashboard_addApp": "Ajouter une app",
  "dashboard_appsTracked": "Apps suivies",
  "dashboard_keywords": "Mots-cles",
  "dashboard_avgPosition": "Position moy.",
  "dashboard_top10": "Top 10",
  "dashboard_trackedApps": "Apps suivies",
  "dashboard_quickActions": "Actions rapides",
  "dashboard_addNewApp": "Ajouter une nouvelle app",
  "dashboard_searchKeywords": "Rechercher des mots-cles",
  "dashboard_viewAllApps": "Voir toutes les apps",
  "dashboard_noAppsYet": "Aucune app suivie",
  "dashboard_addAppToStart": "Ajoutez une app pour commencer a suivre les mots-cles",
  "dashboard_noAppsMatchFilter": "Aucune app ne correspond au filtre",
  "dashboard_changeFilterCriteria": "Essayez de modifier les criteres de filtre",
  "apps_title": "Mes Apps",
  "apps_appCount": "{count} apps",
  "apps_tableApp": "APP",
  "apps_tableDeveloper": "DEVELOPPEUR",
  "apps_tableKeywords": "MOTS-CLES",
  "apps_tablePlatform": "PLATEFORME",
  "apps_tableRating": "NOTE",
  "apps_tableBestRank": "MEILLEUR RANG",
  "apps_noAppsYet": "Aucune app suivie",
  "apps_addAppToStart": "Ajoutez une app pour suivre ses classements",
  "addApp_title": "Ajouter une app",
  "addApp_searchAppStore": "Rechercher sur l'App Store...",
  "addApp_searchPlayStore": "Rechercher sur le Play Store...",
  "addApp_searchForApp": "Rechercher une app",
  "addApp_enterAtLeast2Chars": "Entrez au moins 2 caracteres",
  "addApp_noResults": "Aucun resultat",
  "addApp_addedSuccess": "{name} ajoutee avec succes",
  "settings_title": "Parametres",
  "settings_language": "Langue",
  "settings_appearance": "Apparence",
  "settings_theme": "Theme",
  "settings_themeSystem": "Systeme",
  "settings_themeDark": "Sombre",
  "settings_themeLight": "Clair",
  "settings_account": "Compte",
  "settings_memberSince": "Membre depuis",
  "settings_logout": "Se deconnecter",
  "settings_languageSystem": "Systeme",
  "filter_all": "Tous",
  "filter_allApps": "Toutes les apps",
  "filter_ios": "iOS",
  "filter_iosOnly": "iOS uniquement",
  "filter_android": "Android",
  "filter_androidOnly": "Android uniquement",
  "filter_favorites": "Favoris",
  "sort_recent": "Recent",
  "sort_recentlyAdded": "Recemment ajoutees",
  "sort_nameAZ": "Nom A-Z",
  "sort_nameZA": "Nom Z-A",
  "sort_keywords": "Mots-cles",
  "sort_mostKeywords": "Plus de mots-cles",
  "sort_bestRank": "Meilleur rang",
  "userMenu_logout": "Se deconnecter"
}
```

**Step 2: Create app_de.arb (German)**

```json
{
  "@@locale": "de",
  "appTagline": "Verfolgen Sie Ihre App Store Rankings",
  "auth_welcomeBack": "Willkommen zuruck",
  "auth_signInSubtitle": "Melden Sie sich bei Ihrem Konto an",
  "auth_createAccount": "Konto erstellen",
  "auth_createAccountSubtitle": "Beginnen Sie mit der Verfolgung Ihrer Rankings",
  "auth_emailLabel": "E-Mail",
  "auth_passwordLabel": "Passwort",
  "auth_nameLabel": "Name",
  "auth_confirmPasswordLabel": "Passwort bestatigen",
  "auth_signInButton": "Anmelden",
  "auth_signUpButton": "Konto erstellen",
  "auth_noAccount": "Noch kein Konto?",
  "auth_hasAccount": "Bereits ein Konto?",
  "auth_signUpLink": "Registrieren",
  "auth_signInLink": "Anmelden",
  "auth_emailRequired": "Bitte geben Sie Ihre E-Mail ein",
  "auth_emailInvalid": "Ungultige E-Mail",
  "auth_passwordRequired": "Bitte geben Sie Ihr Passwort ein",
  "auth_enterPassword": "Bitte geben Sie ein Passwort ein",
  "auth_nameRequired": "Bitte geben Sie Ihren Namen ein",
  "auth_passwordMinLength": "Passwort muss mindestens 8 Zeichen haben",
  "auth_passwordsNoMatch": "Passworter stimmen nicht uberein",
  "auth_errorOccurred": "Ein Fehler ist aufgetreten",
  "common_retry": "Erneut versuchen",
  "common_error": "Fehler: {message}",
  "common_loading": "Laden...",
  "common_add": "Hinzufugen",
  "common_filter": "Filtern",
  "common_sort": "Sortieren",
  "common_refresh": "Aktualisieren",
  "common_settings": "Einstellungen",
  "dashboard_title": "Dashboard",
  "dashboard_addApp": "App hinzufugen",
  "dashboard_appsTracked": "Verfolgte Apps",
  "dashboard_keywords": "Keywords",
  "dashboard_avgPosition": "Durchschn. Position",
  "dashboard_top10": "Top 10",
  "dashboard_trackedApps": "Verfolgte Apps",
  "dashboard_quickActions": "Schnellaktionen",
  "dashboard_addNewApp": "Neue App hinzufugen",
  "dashboard_searchKeywords": "Keywords suchen",
  "dashboard_viewAllApps": "Alle Apps anzeigen",
  "dashboard_noAppsYet": "Noch keine Apps verfolgt",
  "dashboard_addAppToStart": "Fugen Sie eine App hinzu, um Keywords zu verfolgen",
  "dashboard_noAppsMatchFilter": "Keine Apps entsprechen dem Filter",
  "dashboard_changeFilterCriteria": "Versuchen Sie, die Filterkriterien zu andern",
  "apps_title": "Meine Apps",
  "apps_appCount": "{count} Apps",
  "apps_tableApp": "APP",
  "apps_tableDeveloper": "ENTWICKLER",
  "apps_tableKeywords": "KEYWORDS",
  "apps_tablePlatform": "PLATTFORM",
  "apps_tableRating": "BEWERTUNG",
  "apps_tableBestRank": "BESTER RANG",
  "apps_noAppsYet": "Noch keine Apps verfolgt",
  "apps_addAppToStart": "Fugen Sie eine App hinzu, um ihre Rankings zu verfolgen",
  "addApp_title": "App hinzufugen",
  "addApp_searchAppStore": "Im App Store suchen...",
  "addApp_searchPlayStore": "Im Play Store suchen...",
  "addApp_searchForApp": "Nach einer App suchen",
  "addApp_enterAtLeast2Chars": "Mindestens 2 Zeichen eingeben",
  "addApp_noResults": "Keine Ergebnisse gefunden",
  "addApp_addedSuccess": "{name} erfolgreich hinzugefugt",
  "settings_title": "Einstellungen",
  "settings_language": "Sprache",
  "settings_appearance": "Erscheinungsbild",
  "settings_theme": "Theme",
  "settings_themeSystem": "System",
  "settings_themeDark": "Dunkel",
  "settings_themeLight": "Hell",
  "settings_account": "Konto",
  "settings_memberSince": "Mitglied seit",
  "settings_logout": "Abmelden",
  "settings_languageSystem": "System",
  "filter_all": "Alle",
  "filter_allApps": "Alle Apps",
  "filter_ios": "iOS",
  "filter_iosOnly": "Nur iOS",
  "filter_android": "Android",
  "filter_androidOnly": "Nur Android",
  "filter_favorites": "Favoriten",
  "sort_recent": "Neueste",
  "sort_recentlyAdded": "Zuletzt hinzugefugt",
  "sort_nameAZ": "Name A-Z",
  "sort_nameZA": "Name Z-A",
  "sort_keywords": "Keywords",
  "sort_mostKeywords": "Meiste Keywords",
  "sort_bestRank": "Bester Rang",
  "userMenu_logout": "Abmelden"
}
```

**Step 3: Create app_es.arb (Spanish)**

```json
{
  "@@locale": "es",
  "appTagline": "Rastrea tus rankings de App Store",
  "auth_welcomeBack": "Bienvenido de nuevo",
  "auth_signInSubtitle": "Inicia sesion en tu cuenta",
  "auth_createAccount": "Crear cuenta",
  "auth_createAccountSubtitle": "Comienza a rastrear tus rankings",
  "auth_emailLabel": "Correo electronico",
  "auth_passwordLabel": "Contrasena",
  "auth_nameLabel": "Nombre",
  "auth_confirmPasswordLabel": "Confirmar contrasena",
  "auth_signInButton": "Iniciar sesion",
  "auth_signUpButton": "Crear cuenta",
  "auth_noAccount": "No tienes cuenta?",
  "auth_hasAccount": "Ya tienes cuenta?",
  "auth_signUpLink": "Registrarse",
  "auth_signInLink": "Iniciar sesion",
  "auth_emailRequired": "Por favor ingresa tu correo",
  "auth_emailInvalid": "Correo invalido",
  "auth_passwordRequired": "Por favor ingresa tu contrasena",
  "auth_enterPassword": "Por favor ingresa una contrasena",
  "auth_nameRequired": "Por favor ingresa tu nombre",
  "auth_passwordMinLength": "La contrasena debe tener al menos 8 caracteres",
  "auth_passwordsNoMatch": "Las contrasenas no coinciden",
  "auth_errorOccurred": "Ocurrio un error",
  "common_retry": "Reintentar",
  "common_error": "Error: {message}",
  "common_loading": "Cargando...",
  "common_add": "Agregar",
  "common_filter": "Filtrar",
  "common_sort": "Ordenar",
  "common_refresh": "Actualizar",
  "common_settings": "Configuracion",
  "dashboard_title": "Panel",
  "dashboard_addApp": "Agregar App",
  "dashboard_appsTracked": "Apps Rastreadas",
  "dashboard_keywords": "Palabras clave",
  "dashboard_avgPosition": "Posicion Prom.",
  "dashboard_top10": "Top 10",
  "dashboard_trackedApps": "Apps Rastreadas",
  "dashboard_quickActions": "Acciones Rapidas",
  "dashboard_addNewApp": "Agregar nueva app",
  "dashboard_searchKeywords": "Buscar palabras clave",
  "dashboard_viewAllApps": "Ver todas las apps",
  "dashboard_noAppsYet": "Sin apps rastreadas",
  "dashboard_addAppToStart": "Agrega una app para comenzar a rastrear palabras clave",
  "dashboard_noAppsMatchFilter": "Ninguna app coincide con el filtro",
  "dashboard_changeFilterCriteria": "Intenta cambiar los criterios del filtro",
  "apps_title": "Mis Apps",
  "apps_appCount": "{count} apps",
  "apps_tableApp": "APP",
  "apps_tableDeveloper": "DESARROLLADOR",
  "apps_tableKeywords": "PALABRAS CLAVE",
  "apps_tablePlatform": "PLATAFORMA",
  "apps_tableRating": "CALIFICACION",
  "apps_tableBestRank": "MEJOR RANGO",
  "apps_noAppsYet": "Sin apps rastreadas",
  "apps_addAppToStart": "Agrega una app para rastrear sus rankings",
  "addApp_title": "Agregar App",
  "addApp_searchAppStore": "Buscar en App Store...",
  "addApp_searchPlayStore": "Buscar en Play Store...",
  "addApp_searchForApp": "Buscar una app",
  "addApp_enterAtLeast2Chars": "Ingresa al menos 2 caracteres",
  "addApp_noResults": "Sin resultados",
  "addApp_addedSuccess": "{name} agregada exitosamente",
  "settings_title": "Configuracion",
  "settings_language": "Idioma",
  "settings_appearance": "Apariencia",
  "settings_theme": "Tema",
  "settings_themeSystem": "Sistema",
  "settings_themeDark": "Oscuro",
  "settings_themeLight": "Claro",
  "settings_account": "Cuenta",
  "settings_memberSince": "Miembro desde",
  "settings_logout": "Cerrar sesion",
  "settings_languageSystem": "Sistema",
  "filter_all": "Todos",
  "filter_allApps": "Todas las apps",
  "filter_ios": "iOS",
  "filter_iosOnly": "Solo iOS",
  "filter_android": "Android",
  "filter_androidOnly": "Solo Android",
  "filter_favorites": "Favoritos",
  "sort_recent": "Reciente",
  "sort_recentlyAdded": "Agregadas recientemente",
  "sort_nameAZ": "Nombre A-Z",
  "sort_nameZA": "Nombre Z-A",
  "sort_keywords": "Palabras clave",
  "sort_mostKeywords": "Mas palabras clave",
  "sort_bestRank": "Mejor rango",
  "userMenu_logout": "Cerrar sesion"
}
```

**Step 4: Create remaining ARB files (PT, IT, JA, KO, ZH, TR)**

Create each file with the same structure, translated appropriately. Files to create:
- `app_pt.arb` - Portuguese
- `app_it.arb` - Italian
- `app_ja.arb` - Japanese
- `app_ko.arb` - Korean
- `app_zh.arb` - Chinese Simplified
- `app_tr.arb` - Turkish

**Step 5: Regenerate localizations**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter gen-l10n
```

**Step 6: Commit**

```bash
git add app/lib/l10n/ && git commit -m "feat(i18n): add translations for all 10 languages"
```

---

## Task 4: Create Locale Provider

**Files:**
- Create: `app/lib/core/providers/locale_provider.dart`

**Step 1: Create locale_provider.dart**

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';

const supportedLocales = [
  Locale('en'),
  Locale('fr'),
  Locale('de'),
  Locale('es'),
  Locale('pt'),
  Locale('it'),
  Locale('ja'),
  Locale('ko'),
  Locale('zh'),
  Locale('tr'),
];

const localeNames = {
  'system': 'System',
  'en': 'English',
  'fr': 'Francais',
  'de': 'Deutsch',
  'es': 'Espanol',
  'pt': 'Portugues',
  'it': 'Italiano',
  'ja': '日本語',
  'ko': '한국어',
  'zh': '中文',
  'tr': 'Turkce',
};

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier(ref);
});

final localePreferenceProvider = StateProvider<String>((ref) => 'system');

class LocaleNotifier extends StateNotifier<Locale?> {
  final Ref _ref;

  LocaleNotifier(this._ref) : super(null);

  void init(String? savedPreference) {
    final preference = savedPreference ?? 'system';
    _ref.read(localePreferenceProvider.notifier).state = preference;
    _updateLocale(preference);
  }

  void _updateLocale(String preference) {
    if (preference == 'system') {
      state = _getSystemLocale();
    } else {
      state = Locale(preference);
    }
  }

  Locale _getSystemLocale() {
    final systemLocale = Platform.localeName.split('_').first;
    final supported = supportedLocales.map((l) => l.languageCode).toList();
    if (supported.contains(systemLocale)) {
      return Locale(systemLocale);
    }
    return const Locale('en');
  }

  Future<void> setLocale(String localeCode) async {
    _ref.read(localePreferenceProvider.notifier).state = localeCode;
    _updateLocale(localeCode);

    // Save to backend
    try {
      final dio = _ref.read(dioProvider);
      await dio.put('/user/preferences', data: {'locale': localeCode});
    } catch (_) {
      // Silently fail - locale is already applied locally
    }
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/core/providers/locale_provider.dart && git commit -m "feat(i18n): add locale provider with backend persistence"
```

---

## Task 5: Integrate i18n in main.dart

**Files:**
- Modify: `app/lib/main.dart`

**Step 1: Update imports and MaterialApp**

Replace content of `app/lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'keyrank.app',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/main.dart && git commit -m "feat(i18n): integrate localization in MaterialApp"
```

---

## Task 6: Add Localization Extension Helper

**Files:**
- Create: `app/lib/core/utils/l10n_extension.dart`

**Step 1: Create extension file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

**Step 2: Commit**

```bash
git add app/lib/core/utils/l10n_extension.dart && git commit -m "feat(i18n): add context.l10n extension helper"
```

---

## Task 7: Update Settings Screen with Language Selector

**Files:**
- Modify: `app/lib/features/settings/presentation/settings_screen.dart`

**Step 1: Add language selector section and update all strings**

The settings screen needs:
1. Import l10n extension and locale_provider
2. Add Language section before Appearance
3. Replace all hardcoded French strings with l10n calls
4. Update date formatting to use current locale

Key changes:
- Add `import '../../../core/utils/l10n_extension.dart';`
- Add `import '../../../core/providers/locale_provider.dart';`
- Replace `'Settings'` with `context.l10n.settings_title`
- Replace `'Apparence'` with `context.l10n.settings_appearance`
- Replace `'Theme'` with `context.l10n.settings_theme`
- Replace `'Compte'` with `context.l10n.settings_account`
- Replace `'Membre depuis'` with `context.l10n.settings_memberSince`
- Replace `'Se deconnecter'` with `context.l10n.settings_logout`
- Replace theme labels with l10n calls
- Add `_LanguageSelector` widget

**Step 2: Commit**

```bash
git add app/lib/features/settings/presentation/settings_screen.dart && git commit -m "feat(i18n): add language selector and localize settings screen"
```

---

## Task 8: Localize Auth Screens

**Files:**
- Modify: `app/lib/features/auth/presentation/login_screen.dart`
- Modify: `app/lib/features/auth/presentation/register_screen.dart`

**Step 1: Update login_screen.dart**

- Add import for l10n extension
- Replace all hardcoded strings with l10n calls:
  - `'Track your App Store rankings'` -> `context.l10n.appTagline`
  - `'Welcome back'` -> `context.l10n.auth_welcomeBack`
  - `'Sign in to your account'` -> `context.l10n.auth_signInSubtitle`
  - `'Email'` -> `context.l10n.auth_emailLabel`
  - `'Password'` -> `context.l10n.auth_passwordLabel`
  - `'Sign in'` -> `context.l10n.auth_signInButton`
  - `"Don't have an account? "` -> `context.l10n.auth_noAccount`
  - `'Sign up'` -> `context.l10n.auth_signUpLink`
  - Validation messages with l10n calls

**Step 2: Update register_screen.dart**

Similar pattern to login_screen.dart.

**Step 3: Commit**

```bash
git add app/lib/features/auth/presentation/ && git commit -m "feat(i18n): localize auth screens"
```

---

## Task 9: Localize Dashboard Screen

**Files:**
- Modify: `app/lib/features/dashboard/presentation/dashboard_screen.dart`

**Step 1: Update all hardcoded strings**

Replace:
- `'Dashboard'` -> `context.l10n.dashboard_title`
- `'Add App'` -> `context.l10n.dashboard_addApp`
- `'Apps Tracked'` -> `context.l10n.dashboard_appsTracked`
- `'Keywords'` -> `context.l10n.dashboard_keywords`
- `'Avg Position'` -> `context.l10n.dashboard_avgPosition`
- `'Top 10'` -> `context.l10n.dashboard_top10`
- `'Tracked Apps'` -> `context.l10n.dashboard_trackedApps`
- `'Quick Actions'` -> `context.l10n.dashboard_quickActions`
- All filter/sort labels
- All empty state messages

**Step 2: Commit**

```bash
git add app/lib/features/dashboard/presentation/dashboard_screen.dart && git commit -m "feat(i18n): localize dashboard screen"
```

---

## Task 10: Localize Remaining Screens

**Files:**
- Modify: `app/lib/features/apps/presentation/apps_list_screen.dart`
- Modify: `app/lib/features/apps/presentation/add_app_screen.dart`
- Modify: `app/lib/shared/widgets/states.dart`
- Modify: `app/lib/core/widgets/user_menu.dart`

**Step 1: Update apps_list_screen.dart**

Replace all hardcoded strings.

**Step 2: Update add_app_screen.dart**

Replace all hardcoded strings.

**Step 3: Update states.dart**

Replace `'Retry'` and error format.

**Step 4: Update user_menu.dart**

Replace `'Settings'` and `'Se deconnecter'`.

**Step 5: Commit**

```bash
git add app/lib/features/apps/presentation/ app/lib/shared/widgets/states.dart app/lib/core/widgets/user_menu.dart && git commit -m "feat(i18n): localize apps screens and shared widgets"
```

---

## Task 11: Final Verification

**Step 1: Regenerate localizations**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter gen-l10n
```

**Step 2: Run build to check for errors**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter build macos --debug
```

**Step 3: Test the app**

Run the app and verify:
- Language selector appears in Settings
- Changing language updates all UI text
- System locale detection works
- All screens display correctly in each language

**Step 4: Final commit if needed**

```bash
git add -A && git commit -m "feat(i18n): complete multilingual implementation"
```

---

## Summary

Total tasks: 11
Key files created: 12 (l10n.yaml, 10 ARB files, locale_provider.dart)
Key files modified: 10+ (main.dart, settings, auth, dashboard, apps screens, widgets)

Languages supported: EN, FR, DE, ES, PT, IT, JA, KO, ZH, TR
