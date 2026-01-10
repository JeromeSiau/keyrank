// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTagline => 'Verfolgen Sie Ihre App Store-Rankings';

  @override
  String get auth_welcomeBack => 'Willkommen zurück';

  @override
  String get auth_signInSubtitle => 'Melden Sie sich bei Ihrem Konto an';

  @override
  String get auth_createAccount => 'Konto erstellen';

  @override
  String get auth_createAccountSubtitle =>
      'Beginnen Sie mit der Verfolgung Ihrer Rankings';

  @override
  String get auth_emailLabel => 'E-Mail';

  @override
  String get auth_passwordLabel => 'Passwort';

  @override
  String get auth_nameLabel => 'Name';

  @override
  String get auth_confirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get auth_signInButton => 'Anmelden';

  @override
  String get auth_signUpButton => 'Konto erstellen';

  @override
  String get auth_noAccount => 'Sie haben noch kein Konto?';

  @override
  String get auth_hasAccount => 'Sie haben bereits ein Konto?';

  @override
  String get auth_signUpLink => 'Registrieren';

  @override
  String get auth_signInLink => 'Anmelden';

  @override
  String get auth_emailRequired => 'Bitte geben Sie Ihre E-Mail ein';

  @override
  String get auth_emailInvalid => 'Ungültige E-Mail';

  @override
  String get auth_passwordRequired => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get auth_enterPassword => 'Bitte geben Sie ein Passwort ein';

  @override
  String get auth_nameRequired => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get auth_passwordMinLength =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get auth_passwordsNoMatch => 'Passwörter stimmen nicht überein';

  @override
  String get auth_errorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get common_retry => 'Erneut versuchen';

  @override
  String common_error(String message) {
    return 'Fehler: $message';
  }

  @override
  String get common_loading => 'Wird geladen...';

  @override
  String get common_add => 'Hinzufügen';

  @override
  String get common_filter => 'Filtern';

  @override
  String get common_sort => 'Sortieren';

  @override
  String get common_refresh => 'Aktualisieren';

  @override
  String get common_settings => 'Einstellungen';

  @override
  String get dashboard_title => 'Dashboard';

  @override
  String get dashboard_addApp => 'App hinzufügen';

  @override
  String get dashboard_appsTracked => 'Verfolgte Apps';

  @override
  String get dashboard_keywords => 'Schlüsselwörter';

  @override
  String get dashboard_avgPosition => 'Durchschn. Position';

  @override
  String get dashboard_top10 => 'Top 10';

  @override
  String get dashboard_trackedApps => 'Verfolgte Apps';

  @override
  String get dashboard_quickActions => 'Schnellaktionen';

  @override
  String get dashboard_addNewApp => 'Neue App hinzufügen';

  @override
  String get dashboard_searchKeywords => 'Schlüsselwörter suchen';

  @override
  String get dashboard_viewAllApps => 'Alle Apps anzeigen';

  @override
  String get dashboard_noAppsYet => 'Noch keine Apps verfolgt';

  @override
  String get dashboard_addAppToStart =>
      'Fügen Sie eine App hinzu, um Keywords zu verfolgen';

  @override
  String get dashboard_noAppsMatchFilter => 'Keine Apps entsprechen dem Filter';

  @override
  String get dashboard_changeFilterCriteria =>
      'Versuchen Sie, die Filterkriterien zu ändern';

  @override
  String get apps_title => 'Meine Apps';

  @override
  String apps_appCount(int count) {
    return '$count Apps';
  }

  @override
  String get apps_tableApp => 'APP';

  @override
  String get apps_tableDeveloper => 'ENTWICKLER';

  @override
  String get apps_tableKeywords => 'SCHLÜSSELWÖRTER';

  @override
  String get apps_tablePlatform => 'PLATTFORM';

  @override
  String get apps_tableRating => 'BEWERTUNG';

  @override
  String get apps_tableBestRank => 'BESTER RANG';

  @override
  String get apps_noAppsYet => 'Noch keine Apps verfolgt';

  @override
  String get apps_addAppToStart =>
      'Fügen Sie eine App hinzu, um ihre Rankings zu verfolgen';

  @override
  String get addApp_title => 'App hinzufügen';

  @override
  String get addApp_searchAppStore => 'Im App Store suchen...';

  @override
  String get addApp_searchPlayStore => 'Im Play Store suchen...';

  @override
  String get addApp_searchForApp => 'Nach einer App suchen';

  @override
  String get addApp_enterAtLeast2Chars => 'Geben Sie mindestens 2 Zeichen ein';

  @override
  String get addApp_noResults => 'Keine Ergebnisse gefunden';

  @override
  String addApp_addedSuccess(String name) {
    return '$name erfolgreich hinzugefügt';
  }

  @override
  String get settings_title => 'Einstellungen';

  @override
  String get settings_language => 'Sprache';

  @override
  String get settings_appearance => 'Erscheinungsbild';

  @override
  String get settings_theme => 'Thema';

  @override
  String get settings_themeSystem => 'System';

  @override
  String get settings_themeDark => 'Dunkel';

  @override
  String get settings_themeLight => 'Hell';

  @override
  String get settings_account => 'Konto';

  @override
  String get settings_memberSince => 'Mitglied seit';

  @override
  String get settings_logout => 'Abmelden';

  @override
  String get settings_languageSystem => 'System';

  @override
  String get filter_all => 'Alle';

  @override
  String get filter_allApps => 'Alle Apps';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'Nur iOS';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Nur Android';

  @override
  String get filter_favorites => 'Favoriten';

  @override
  String get sort_recent => 'Aktuell';

  @override
  String get sort_recentlyAdded => 'Kürzlich hinzugefügt';

  @override
  String get sort_nameAZ => 'Name A-Z';

  @override
  String get sort_nameZA => 'Name Z-A';

  @override
  String get sort_keywords => 'Schlüsselwörter';

  @override
  String get sort_mostKeywords => 'Meiste Schlüsselwörter';

  @override
  String get sort_bestRank => 'Bester Rang';

  @override
  String get userMenu_logout => 'Abmelden';
}
