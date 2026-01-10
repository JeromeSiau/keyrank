// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTagline => 'Monitora le tue classifiche App Store';

  @override
  String get auth_welcomeBack => 'Bentornato';

  @override
  String get auth_signInSubtitle => 'Accedi al tuo account';

  @override
  String get auth_createAccount => 'Crea account';

  @override
  String get auth_createAccountSubtitle =>
      'Inizia a monitorare le tue classifiche';

  @override
  String get auth_emailLabel => 'Email';

  @override
  String get auth_passwordLabel => 'Password';

  @override
  String get auth_nameLabel => 'Nome';

  @override
  String get auth_confirmPasswordLabel => 'Conferma password';

  @override
  String get auth_signInButton => 'Accedi';

  @override
  String get auth_signUpButton => 'Crea account';

  @override
  String get auth_noAccount => 'Non hai un account?';

  @override
  String get auth_hasAccount => 'Hai già un account?';

  @override
  String get auth_signUpLink => 'Registrati';

  @override
  String get auth_signInLink => 'Accedi';

  @override
  String get auth_emailRequired => 'Inserisci la tua email';

  @override
  String get auth_emailInvalid => 'Email non valida';

  @override
  String get auth_passwordRequired => 'Inserisci la tua password';

  @override
  String get auth_enterPassword => 'Inserisci una password';

  @override
  String get auth_nameRequired => 'Inserisci il tuo nome';

  @override
  String get auth_passwordMinLength =>
      'La password deve contenere almeno 8 caratteri';

  @override
  String get auth_passwordsNoMatch => 'Le password non corrispondono';

  @override
  String get auth_errorOccurred => 'Si è verificato un errore';

  @override
  String get common_retry => 'Riprova';

  @override
  String common_error(String message) {
    return 'Errore: $message';
  }

  @override
  String get common_loading => 'Caricamento...';

  @override
  String get common_add => 'Aggiungi';

  @override
  String get common_filter => 'Filtra';

  @override
  String get common_sort => 'Ordina';

  @override
  String get common_refresh => 'Aggiorna';

  @override
  String get common_settings => 'Impostazioni';

  @override
  String get dashboard_title => 'Dashboard';

  @override
  String get dashboard_addApp => 'Aggiungi app';

  @override
  String get dashboard_appsTracked => 'App monitorate';

  @override
  String get dashboard_keywords => 'Parole chiave';

  @override
  String get dashboard_avgPosition => 'Posizione media';

  @override
  String get dashboard_top10 => 'Top 10';

  @override
  String get dashboard_trackedApps => 'App monitorate';

  @override
  String get dashboard_quickActions => 'Azioni rapide';

  @override
  String get dashboard_addNewApp => 'Aggiungi una nuova app';

  @override
  String get dashboard_searchKeywords => 'Cerca parole chiave';

  @override
  String get dashboard_viewAllApps => 'Visualizza tutte le app';

  @override
  String get dashboard_noAppsYet => 'Nessuna app monitorata ancora';

  @override
  String get dashboard_addAppToStart =>
      'Aggiungi un\'app per iniziare a monitorare le parole chiave';

  @override
  String get dashboard_noAppsMatchFilter => 'Nessuna app corrisponde al filtro';

  @override
  String get dashboard_changeFilterCriteria =>
      'Prova a modificare i criteri del filtro';

  @override
  String get apps_title => 'Le mie App';

  @override
  String apps_appCount(int count) {
    return '$count app';
  }

  @override
  String get apps_tableApp => 'APP';

  @override
  String get apps_tableDeveloper => 'SVILUPPATORE';

  @override
  String get apps_tableKeywords => 'PAROLE CHIAVE';

  @override
  String get apps_tablePlatform => 'PIATTAFORMA';

  @override
  String get apps_tableRating => 'VALUTAZIONE';

  @override
  String get apps_tableBestRank => 'MIGLIOR POSIZIONE';

  @override
  String get apps_noAppsYet => 'Nessuna app monitorata ancora';

  @override
  String get apps_addAppToStart =>
      'Aggiungi un\'app per iniziare a monitorare le sue classifiche';

  @override
  String get addApp_title => 'Aggiungi App';

  @override
  String get addApp_searchAppStore => 'Cerca nell\'App Store...';

  @override
  String get addApp_searchPlayStore => 'Cerca nel Play Store...';

  @override
  String get addApp_searchForApp => 'Cerca un\'app';

  @override
  String get addApp_enterAtLeast2Chars => 'Inserisci almeno 2 caratteri';

  @override
  String get addApp_noResults => 'Nessun risultato trovato';

  @override
  String addApp_addedSuccess(String name) {
    return '$name aggiunto con successo';
  }

  @override
  String get settings_title => 'Impostazioni';

  @override
  String get settings_language => 'Lingua';

  @override
  String get settings_appearance => 'Aspetto';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_themeSystem => 'Sistema';

  @override
  String get settings_themeDark => 'Scuro';

  @override
  String get settings_themeLight => 'Chiaro';

  @override
  String get settings_account => 'Account';

  @override
  String get settings_memberSince => 'Membro dal';

  @override
  String get settings_logout => 'Esci';

  @override
  String get settings_languageSystem => 'Sistema';

  @override
  String get filter_all => 'Tutti';

  @override
  String get filter_allApps => 'Tutte le app';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'Solo iOS';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Solo Android';

  @override
  String get filter_favorites => 'Preferiti';

  @override
  String get sort_recent => 'Recente';

  @override
  String get sort_recentlyAdded => 'Aggiunto di recente';

  @override
  String get sort_nameAZ => 'Nome A-Z';

  @override
  String get sort_nameZA => 'Nome Z-A';

  @override
  String get sort_keywords => 'Parole chiave';

  @override
  String get sort_mostKeywords => 'Più parole chiave';

  @override
  String get sort_bestRank => 'Miglior posizione';

  @override
  String get userMenu_logout => 'Esci';
}
