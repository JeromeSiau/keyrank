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

  @override
  String get insights_compareTitle => 'Erkenntnisse vergleichen';

  @override
  String get insights_analyzingReviews => 'Bewertungen werden analysiert...';

  @override
  String get insights_noInsightsAvailable => 'Keine Erkenntnisse verfügbar';

  @override
  String get insights_strengths => 'Stärken';

  @override
  String get insights_weaknesses => 'Schwächen';

  @override
  String get insights_scores => 'Bewertungen';

  @override
  String get insights_opportunities => 'Chancen';

  @override
  String get insights_categoryUx => 'UX';

  @override
  String get insights_categoryPerf => 'Perf';

  @override
  String get insights_categoryFeatures => 'Funktionen';

  @override
  String get insights_categoryPricing => 'Preise';

  @override
  String get insights_categorySupport => 'Support';

  @override
  String get insights_categoryOnboard => 'Onboard';

  @override
  String get insights_categoryUxFull => 'UX / Oberfläche';

  @override
  String get insights_categoryPerformance => 'Leistung';

  @override
  String get insights_categoryOnboarding => 'Einführung';

  @override
  String get insights_reviewInsights => 'Bewertungs-Erkenntnisse';

  @override
  String get insights_generateFirst => 'Zuerst Erkenntnisse generieren';

  @override
  String get insights_compareWithOther => 'Mit anderen Apps vergleichen';

  @override
  String get insights_compare => 'Vergleichen';

  @override
  String get insights_generateAnalysis => 'Analyse generieren';

  @override
  String get insights_period => 'Zeitraum:';

  @override
  String get insights_3months => '3 Monate';

  @override
  String get insights_6months => '6 Monate';

  @override
  String get insights_12months => '12 Monate';

  @override
  String get insights_analyze => 'Analysieren';

  @override
  String insights_reviewsCount(int count) {
    return '$count Bewertungen';
  }

  @override
  String insights_analyzedAgo(String time) {
    return 'Analysiert $time';
  }

  @override
  String get insights_yourNotes => 'Ihre Notizen';

  @override
  String get insights_save => 'Speichern';

  @override
  String get insights_clickToAddNotes => 'Klicken, um Notizen hinzuzufügen...';

  @override
  String get insights_noteSaved => 'Notiz gespeichert';

  @override
  String get insights_noteHint =>
      'Fügen Sie Ihre Notizen zu dieser Erkenntnisanalyse hinzu...';

  @override
  String get insights_categoryScores => 'Kategorie-Bewertungen';

  @override
  String get insights_emergentThemes => 'Aufkommende Themen';

  @override
  String get insights_exampleQuotes => 'Beispielzitate:';

  @override
  String get insights_selectCountryFirst =>
      'Wählen Sie mindestens ein Land aus';

  @override
  String compare_selectAppsToCompare(String appName) {
    return 'Wählen Sie bis zu 3 Apps zum Vergleichen mit $appName';
  }

  @override
  String get compare_searchApps => 'Apps suchen...';

  @override
  String get compare_noOtherApps => 'Keine anderen Apps zum Vergleichen';

  @override
  String get compare_noMatchingApps => 'Keine passenden Apps';

  @override
  String compare_appsSelected(int count) {
    return '$count von 3 Apps ausgewählt';
  }

  @override
  String get compare_cancel => 'Abbrechen';

  @override
  String compare_button(int count) {
    return '$count Apps vergleichen';
  }

  @override
  String get appDetail_deleteAppTitle => 'App löschen?';

  @override
  String get appDetail_deleteAppConfirm =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get appDetail_cancel => 'Abbrechen';

  @override
  String get appDetail_delete => 'Löschen';

  @override
  String get appDetail_exporting => 'Rankings werden exportiert...';

  @override
  String appDetail_savedFile(String filename) {
    return 'Gespeichert: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Im Finder anzeigen';

  @override
  String appDetail_exportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return '$imported Schlüsselwörter importiert ($skipped übersprungen)';
  }

  @override
  String get appDetail_favorite => 'Favorit';

  @override
  String get appDetail_ratings => 'Bewertungen';

  @override
  String get appDetail_insights => 'Erkenntnisse';

  @override
  String get appDetail_import => 'Importieren';

  @override
  String get appDetail_export => 'Exportieren';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count Bewertungen';
  }

  @override
  String get appDetail_keywords => 'Schlüsselwörter';

  @override
  String get appDetail_addKeyword => 'Schlüsselwort hinzufügen';

  @override
  String get appDetail_keywordHint => 'z.B. Fitness-Tracker';

  @override
  String get appDetail_trackedKeywords => 'Verfolgte Schlüsselwörter';

  @override
  String appDetail_selectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get appDetail_allKeywords => 'Alle Schlüsselwörter';

  @override
  String get appDetail_hasTags => 'Mit Tags';

  @override
  String get appDetail_hasNotes => 'Mit Notizen';

  @override
  String get appDetail_position => 'Position';

  @override
  String get appDetail_select => 'Auswählen';

  @override
  String get appDetail_suggestions => 'Vorschläge';

  @override
  String get appDetail_deleteKeywordsTitle => 'Schlüsselwörter löschen';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return 'Sind Sie sicher, dass Sie $count Schlüsselwörter löschen möchten?';
  }

  @override
  String get appDetail_tag => 'Tag';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return 'Schlüsselwort \"$keyword\" hinzugefügt ($flag)';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return 'Tags zu $count Schlüsselwörtern hinzugefügt';
  }

  @override
  String get appDetail_keywordsAddedSuccess =>
      'Schlüsselwörter erfolgreich hinzugefügt';

  @override
  String get appDetail_noTagsAvailable =>
      'Keine Tags verfügbar. Erstellen Sie zuerst Tags.';

  @override
  String get appDetail_tagged => 'Mit Tags';

  @override
  String get appDetail_withNotes => 'Mit Notizen';

  @override
  String get appDetail_nameAZ => 'Name A-Z';

  @override
  String get appDetail_nameZA => 'Name Z-A';

  @override
  String get appDetail_bestPosition => 'Beste Position';

  @override
  String get appDetail_recentlyTracked => 'Kürzlich verfolgt';

  @override
  String get keywordSuggestions_title => 'Schlüsselwort-Vorschläge';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$appName in $country';
  }

  @override
  String get keywordSuggestions_refresh => 'Vorschläge aktualisieren';

  @override
  String get keywordSuggestions_search => 'Vorschläge suchen...';

  @override
  String get keywordSuggestions_selectAll => 'Alle auswählen';

  @override
  String get keywordSuggestions_clear => 'Leeren';

  @override
  String get keywordSuggestions_analyzing =>
      'App-Metadaten werden analysiert...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds =>
      'Dies kann einige Sekunden dauern';

  @override
  String get keywordSuggestions_noSuggestions => 'Keine Vorschläge verfügbar';

  @override
  String get keywordSuggestions_noMatchingSuggestions =>
      'Keine passenden Vorschläge';

  @override
  String get keywordSuggestions_headerKeyword => 'SCHLÜSSELWORT';

  @override
  String get keywordSuggestions_headerDifficulty => 'SCHWIERIGKEIT';

  @override
  String get keywordSuggestions_headerApps => 'APPS';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return 'Rang #$position';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count Schlüsselwörter ausgewählt';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return '$count Schlüsselwörter hinzufügen';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Fehler beim Hinzufügen von Schlüsselwörtern: $error';
  }

  @override
  String get sidebar_favorites => 'FAVORITEN';

  @override
  String get sidebar_tooManyFavorites =>
      'Wir empfehlen, 5 oder weniger Favoriten zu behalten';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Schlüsselwort-Recherche';

  @override
  String get keywordSearch_searchPlaceholder => 'Schlüsselwörter suchen...';

  @override
  String get keywordSearch_searchTitle => 'Nach einem Schlüsselwort suchen';

  @override
  String get keywordSearch_searchSubtitle =>
      'Entdecken Sie, welche Apps für beliebige Schlüsselwörter ranken';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count Apps gerankt';
  }

  @override
  String get keywordSearch_popularity => 'Beliebtheit';

  @override
  String keywordSearch_results(int count) {
    return '$count Ergebnisse';
  }

  @override
  String get keywordSearch_headerRank => 'RANG';

  @override
  String get keywordSearch_headerApp => 'APP';

  @override
  String get keywordSearch_headerRating => 'BEWERTUNG';

  @override
  String get keywordSearch_headerTrack => 'VERFOLGEN';

  @override
  String get keywordSearch_trackApp => 'Diese App verfolgen';

  @override
  String reviews_reviewsFor(String appName) {
    return 'Bewertungen für $appName';
  }

  @override
  String get reviews_loading => 'Bewertungen werden geladen...';

  @override
  String get reviews_noReviews => 'Keine Bewertungen';

  @override
  String reviews_noReviewsFor(String countryName) {
    return 'Keine Bewertungen für $countryName gefunden';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'Zeigt die $count neuesten Bewertungen aus dem App Store.';
  }

  @override
  String get reviews_today => 'Heute';

  @override
  String get reviews_yesterday => 'Gestern';

  @override
  String reviews_daysAgo(int count) {
    return 'Vor $count Tagen';
  }

  @override
  String reviews_weeksAgo(int count) {
    return 'Vor $count Wochen';
  }

  @override
  String reviews_monthsAgo(int count) {
    return 'Vor $count Monaten';
  }

  @override
  String get ratings_byCountry => 'Bewertungen nach Land';

  @override
  String get ratings_noRatingsAvailable => 'Keine Bewertungen verfügbar';

  @override
  String get ratings_noRatingsYet => 'Diese App hat noch keine Bewertungen';

  @override
  String get ratings_totalRatings => 'Gesamtbewertungen';

  @override
  String get ratings_averageRating => 'Durchschnittsbewertung';

  @override
  String ratings_countriesCount(int count) {
    return '$count Länder';
  }

  @override
  String ratings_updated(String date) {
    return 'Aktualisiert: $date';
  }

  @override
  String get ratings_headerCountry => 'LAND';

  @override
  String get ratings_headerRatings => 'BEWERTUNGEN';

  @override
  String get ratings_headerAverage => 'DURCHSCHNITT';

  @override
  String time_minutesAgo(int count) {
    return 'Vor $count Min.';
  }

  @override
  String time_hoursAgo(int count) {
    return 'Vor $count Std.';
  }

  @override
  String time_daysAgo(int count) {
    return 'Vor $count T.';
  }

  @override
  String get appDetail_noKeywordsTracked => 'Keine Schlüsselwörter verfolgt';

  @override
  String get appDetail_addKeywordHint =>
      'Fügen Sie oben ein Schlüsselwort hinzu, um mit der Verfolgung zu beginnen';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Keine Schlüsselwörter entsprechen dem Filter';

  @override
  String get appDetail_tryChangingFilter =>
      'Versuchen Sie, die Filterkriterien zu ändern';

  @override
  String get appDetail_addTag => 'Tag hinzufügen';

  @override
  String get appDetail_addNote => 'Notiz hinzufügen';

  @override
  String get appDetail_positionHistory => 'Positionsverlauf';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => 'ÜBERSICHT';

  @override
  String get nav_dashboard => 'Dashboard';

  @override
  String get nav_myApps => 'Meine Apps';

  @override
  String get nav_research => 'RECHERCHE';

  @override
  String get nav_keywords => 'Schlüsselwörter';
}
