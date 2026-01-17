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
  String get common_search => 'Suchen...';

  @override
  String get common_noResults => 'Keine Ergebnisse gefunden';

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
  String get dashboard_reviews => 'Bewertungen';

  @override
  String get dashboard_avgRating => 'Durchschn. Bewertung';

  @override
  String get dashboard_topPerformingApps => 'Top-Apps';

  @override
  String get dashboard_topCountries => 'Top-Länder';

  @override
  String get dashboard_sentimentOverview => 'Stimmungsübersicht';

  @override
  String get dashboard_overallSentiment => 'Gesamtstimmung';

  @override
  String get dashboard_positive => 'Positiv';

  @override
  String get dashboard_positiveReviews => 'Positiv';

  @override
  String get dashboard_negativeReviews => 'Negativ';

  @override
  String get dashboard_viewReviews => 'Bewertungen anzeigen';

  @override
  String get dashboard_tableApp => 'APP';

  @override
  String get dashboard_tableKeywords => 'SCHLÜSSELWÖRTER';

  @override
  String get dashboard_tableAvgRank => 'DURCHSCHN. RANG';

  @override
  String get dashboard_tableTrend => 'TREND';

  @override
  String get dashboard_connectYourStores => 'Verbinden Sie Ihre Stores';

  @override
  String get dashboard_connectStoresDescription =>
      'Verbinden Sie App Store Connect oder Google Play, um Ihre Apps zu importieren und auf Bewertungen zu antworten.';

  @override
  String get dashboard_connect => 'Verbinden';

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
  String get insights_title => 'Erkenntnisse';

  @override
  String insights_titleWithApp(String appName) {
    return 'Erkenntnisse - $appName';
  }

  @override
  String get insights_allApps => 'Erkenntnisse (Alle Apps)';

  @override
  String get insights_noInsightsYet => 'Noch keine Einblicke';

  @override
  String get insights_selectAppToGenerate =>
      'Wählen Sie eine App aus, um Erkenntnisse aus Bewertungen zu generieren';

  @override
  String insights_appsWithInsights(int count) {
    return '$count Apps mit Erkenntnissen';
  }

  @override
  String get insights_errorLoading => 'Fehler beim Laden der Erkenntnisse';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '$count Bewertungen analysiert';
  }

  @override
  String get insights_avgScore => 'durchschn. Bewertung';

  @override
  String insights_updatedOn(String date) {
    return 'Aktualisiert am $date';
  }

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
  String get keywordSuggestions_categoryAll => 'Alle';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'Hohe Chance';

  @override
  String get keywordSuggestions_categoryCompetitor => 'Wettbewerber-Keywords';

  @override
  String get keywordSuggestions_categoryLongTail => 'Long-tail';

  @override
  String get keywordSuggestions_categoryTrending => 'Trending';

  @override
  String get keywordSuggestions_categoryRelated => 'Verwandt';

  @override
  String get keywordSuggestions_generating => 'Vorschläge werden generiert...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      'Dies kann einige Minuten dauern. Bitte schauen Sie später wieder vorbei.';

  @override
  String get keywordSuggestions_checkAgain => 'Erneut prüfen';

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
  String get discover_title => 'Entdecken';

  @override
  String get discover_tabKeywords => 'Schlüsselwörter';

  @override
  String get discover_tabCategories => 'Kategorien';

  @override
  String get discover_selectCategory => 'Kategorie auswählen';

  @override
  String get discover_topFree => 'Kostenlos';

  @override
  String get discover_topPaid => 'Bezahlt';

  @override
  String get discover_topGrossing => 'Umsatz';

  @override
  String get discover_noResults => 'Keine Ergebnisse';

  @override
  String get discover_loadingTopApps => 'Top-Apps werden geladen...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return 'Top $collection in $category';
  }

  @override
  String discover_appsCount(int count) {
    return '$count Apps';
  }

  @override
  String get discover_allCategories => 'Alle Kategorien';

  @override
  String get category_games => 'Spiele';

  @override
  String get category_business => 'Business';

  @override
  String get category_education => 'Bildung';

  @override
  String get category_entertainment => 'Unterhaltung';

  @override
  String get category_finance => 'Finanzen';

  @override
  String get category_food_drink => 'Essen & Trinken';

  @override
  String get category_health_fitness => 'Gesundheit & Fitness';

  @override
  String get category_lifestyle => 'Lifestyle';

  @override
  String get category_medical => 'Medizin';

  @override
  String get category_music => 'Musik';

  @override
  String get category_navigation => 'Navigation';

  @override
  String get category_news => 'Nachrichten';

  @override
  String get category_photo_video => 'Foto & Video';

  @override
  String get category_productivity => 'Produktivität';

  @override
  String get category_reference => 'Nachschlagewerke';

  @override
  String get category_shopping => 'Shopping';

  @override
  String get category_social => 'Soziale Netzwerke';

  @override
  String get category_sports => 'Sport';

  @override
  String get category_travel => 'Reisen';

  @override
  String get category_utilities => 'Dienstprogramme';

  @override
  String get category_weather => 'Wetter';

  @override
  String get category_books => 'Bücher';

  @override
  String get category_developer_tools => 'Entwicklertools';

  @override
  String get category_graphics_design => 'Grafik & Design';

  @override
  String get category_magazines => 'Magazine & Zeitungen';

  @override
  String get category_stickers => 'Sticker';

  @override
  String get category_catalogs => 'Kataloge';

  @override
  String get category_art_design => 'Kunst & Design';

  @override
  String get category_auto_vehicles => 'Auto & Fahrzeuge';

  @override
  String get category_beauty => 'Schönheit';

  @override
  String get category_comics => 'Comics';

  @override
  String get category_communication => 'Kommunikation';

  @override
  String get category_dating => 'Dating';

  @override
  String get category_events => 'Veranstaltungen';

  @override
  String get category_house_home => 'Haus & Garten';

  @override
  String get category_libraries => 'Bibliotheken';

  @override
  String get category_maps_navigation => 'Karten & Navigation';

  @override
  String get category_music_audio => 'Musik & Audio';

  @override
  String get category_news_magazines => 'Nachrichten & Magazine';

  @override
  String get category_parenting => 'Eltern';

  @override
  String get category_personalization => 'Personalisierung';

  @override
  String get category_photography => 'Fotografie';

  @override
  String get category_tools => 'Tools';

  @override
  String get category_video_players => 'Videoplayer';

  @override
  String get category_all_apps => 'Alle Apps';

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

  @override
  String get nav_discover => 'Entdecken';

  @override
  String get nav_engagement => 'ENGAGEMENT';

  @override
  String get nav_reviewsInbox => 'Bewertungs-Posteingang';

  @override
  String get nav_notifications => 'Benachrichtigungen';

  @override
  String get nav_optimization => 'OPTIMIERUNG';

  @override
  String get nav_keywordInspector => 'Keyword-Inspektor';

  @override
  String get nav_ratingsAnalysis => 'Bewertungsanalyse';

  @override
  String get nav_intelligence => 'INTELLIGENCE';

  @override
  String get nav_topCharts => 'Top Charts';

  @override
  String get nav_competitors => 'Wettbewerber';

  @override
  String get common_save => 'Speichern';

  @override
  String get appDetail_manageTags => 'Tags verwalten';

  @override
  String get appDetail_newTagHint => 'Neuer Tag-Name...';

  @override
  String get appDetail_availableTags => 'Verfügbare Tags';

  @override
  String get appDetail_noTagsYet =>
      'Noch keine Tags. Erstellen Sie oben einen.';

  @override
  String get appDetail_addTagsTitle => 'Tags hinzufügen';

  @override
  String get appDetail_selectTagsDescription =>
      'Wählen Sie Tags für die ausgewählten Keywords:';

  @override
  String appDetail_addTagsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tags',
      one: 'Tag',
    );
    return '$count $_temp0 hinzufügen';
  }

  @override
  String get appDetail_currentTags => 'Aktuelle Tags';

  @override
  String get appDetail_noTagsOnKeyword => 'Keine Tags auf diesem Schlüsselwort';

  @override
  String get appDetail_addExistingTag => 'Vorhandenen Tag hinzufügen';

  @override
  String get appDetail_allTagsUsed => 'Alle Tags bereits verwendet';

  @override
  String get appDetail_createNewTag => 'Neuen Tag erstellen';

  @override
  String get appDetail_tagNameHint => 'Tag-Name...';

  @override
  String get appDetail_note => 'Notiz';

  @override
  String get appDetail_noteHint =>
      'Notiz zu diesem Schlüsselwort hinzufügen...';

  @override
  String get appDetail_saveNote => 'Notiz speichern';

  @override
  String get appDetail_done => 'Fertig';

  @override
  String appDetail_importFailed(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Keywords importieren';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Keywords hier einfügen, eines pro Zeile:';

  @override
  String get appDetail_keywordPlaceholder =>
      'keyword eins\nkeyword zwei\nkeyword drei';

  @override
  String get appDetail_storefront => 'Storefront:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count Keywords';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return '$count Keywords importieren';
  }

  @override
  String get appDetail_period7d => '7T';

  @override
  String get appDetail_period30d => '30T';

  @override
  String get appDetail_period90d => '90T';

  @override
  String get keywords_difficultyFilter => 'Schwierigkeit:';

  @override
  String get keywords_difficultyAll => 'Alle';

  @override
  String get keywords_difficultyEasy => 'Leicht < 40';

  @override
  String get keywords_difficultyMedium => 'Mittel 40-70';

  @override
  String get keywords_difficultyHard => 'Schwer > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'App-Details';

  @override
  String get appPreview_notFound => 'App nicht gefunden';

  @override
  String get appPreview_screenshots => 'Screenshots';

  @override
  String get appPreview_description => 'Beschreibung';

  @override
  String get appPreview_details => 'Details';

  @override
  String get appPreview_version => 'Version';

  @override
  String get appPreview_updated => 'Aktualisiert';

  @override
  String get appPreview_released => 'Veröffentlicht';

  @override
  String get appPreview_size => 'Größe';

  @override
  String get appPreview_minimumOs => 'Erfordert';

  @override
  String get appPreview_price => 'Preis';

  @override
  String get appPreview_free => 'Kostenlos';

  @override
  String get appPreview_openInStore => 'Im Store öffnen';

  @override
  String get appPreview_addToMyApps => 'Zu meinen Apps hinzufügen';

  @override
  String get appPreview_added => 'Hinzugefügt';

  @override
  String get appPreview_showMore => 'Mehr anzeigen';

  @override
  String get appPreview_showLess => 'Weniger anzeigen';

  @override
  String get appPreview_keywordsPlaceholder =>
      'Fügen Sie diese App zu Ihren verfolgten Apps hinzu, um das Keyword-Tracking zu aktivieren';

  @override
  String get notifications_title => 'Benachrichtigungen';

  @override
  String get notifications_markAllRead => 'Alle als gelesen markieren';

  @override
  String get notifications_empty => 'Noch keine Benachrichtigungen';

  @override
  String get alerts_title => 'Alarmregeln';

  @override
  String get alerts_templatesTitle => 'Schnellvorlagen';

  @override
  String get alerts_templatesSubtitle =>
      'Aktivieren Sie häufige Alarme mit einem Tippen';

  @override
  String get alerts_myRulesTitle => 'Meine Regeln';

  @override
  String get alerts_createRule => 'Regel erstellen';

  @override
  String get alerts_editRule => 'Regel bearbeiten';

  @override
  String get alerts_noRulesYet => 'Noch keine Regeln';

  @override
  String get alerts_deleteConfirm => 'Regel löschen?';

  @override
  String get alerts_createCustomRule => 'Benutzerdefinierte Regel erstellen';

  @override
  String alerts_ruleActivated(String name) {
    return '$name aktiviert!';
  }

  @override
  String alerts_deleteMessage(String name) {
    return 'Dies wird \"$name\" löschen.';
  }

  @override
  String get alerts_noRulesDescription =>
      'Aktivieren Sie eine Vorlage oder erstellen Sie Ihre eigene!';

  @override
  String get alerts_create => 'Erstellen';

  @override
  String get settings_notifications => 'BENACHRICHTIGUNGEN';

  @override
  String get settings_manageAlerts => 'Alarmregeln verwalten';

  @override
  String get settings_manageAlertsDesc =>
      'Konfigurieren Sie, welche Alarme Sie erhalten';

  @override
  String get settings_storeConnections => 'Store-Verbindungen';

  @override
  String get settings_storeConnectionsDesc =>
      'Verbinden Sie Ihre App Store und Google Play Konten';

  @override
  String get settings_alertDelivery => 'ALARMZUSTELLUNG';

  @override
  String get settings_team => 'TEAM';

  @override
  String get settings_teamManagement => 'Teamverwaltung';

  @override
  String get settings_teamManagementDesc =>
      'Invite members, manage roles & permissions';

  @override
  String get settings_integrations => 'Integrationen';

  @override
  String get settings_manageIntegrations => 'Manage Integrations';

  @override
  String get settings_manageIntegrationsDesc =>
      'Connect App Store Connect & Google Play Console';

  @override
  String get settings_billing => 'BILLING';

  @override
  String get settings_plansBilling => 'Plans & Billing';

  @override
  String get settings_plansBillingDesc =>
      'Manage your subscription and payment';

  @override
  String get settings_rememberApp => 'Remember selected app';

  @override
  String get settings_rememberAppDesc =>
      'Restore app selection when you open the app';

  @override
  String get storeConnections_title => 'Store-Verbindungen';

  @override
  String get storeConnections_description =>
      'Verbinden Sie Ihre App Store und Google Play Konten, um erweiterte Funktionen wie Verkaufsdaten und App-Analysen zu aktivieren.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Verbinden Sie Ihr Apple Developer-Konto';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Verbinden Sie Ihr Google Play-Konto';

  @override
  String get storeConnections_connect => 'Verbinden';

  @override
  String get storeConnections_disconnect => 'Trennen';

  @override
  String get storeConnections_connected => 'Verbunden';

  @override
  String get storeConnections_disconnectConfirm => 'Trennen?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'Möchten Sie dieses $platform-Konto wirklich trennen?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Erfolgreich getrennt';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Zuletzt synchronisiert: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return 'Verbunden am $date';
  }

  @override
  String get storeConnections_syncApps => 'Apps synchronisieren';

  @override
  String get storeConnections_syncing => 'Synchronisiere...';

  @override
  String get storeConnections_syncDescription =>
      'Die Synchronisierung markiert Ihre Apps als Eigentum und ermöglicht das Beantworten von Bewertungen.';

  @override
  String storeConnections_syncedApps(int count) {
    return '$count Apps als Eigentum synchronisiert';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return 'Synchronisierung fehlgeschlagen: $error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return 'Fehler beim Laden der Verbindungen: $error';
  }

  @override
  String get reviewsInbox_title => 'Bewertungs-Posteingang';

  @override
  String get reviewsInbox_filterUnanswered => 'Unbeantwortet';

  @override
  String get reviewsInbox_filterNegative => 'Negativ';

  @override
  String get reviewsInbox_noReviews => 'Keine Bewertungen gefunden';

  @override
  String get reviewsInbox_noReviewsDesc =>
      'Versuchen Sie, Ihre Filter anzupassen';

  @override
  String get reviewsInbox_reply => 'Antworten';

  @override
  String get reviewsInbox_responded => 'Antwort';

  @override
  String reviewsInbox_respondedAt(String date) {
    return 'Beantwortet am $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Auf Bewertung antworten';

  @override
  String get reviewsInbox_generateAi => 'KI-Vorschlag generieren';

  @override
  String get reviewsInbox_generating => 'Generiere...';

  @override
  String get reviewsInbox_sendReply => 'Antwort senden';

  @override
  String get reviewsInbox_sending => 'Sende...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Schreiben Sie Ihre Antwort...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 Zeichen';
  }

  @override
  String get reviewsInbox_replySent => 'Antwort erfolgreich gesendet';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Antwort konnte nicht gesendet werden: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Vorschlag konnte nicht generiert werden: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count Sterne';
  }

  @override
  String get reviewsInbox_totalReviews => 'Gesamtbewertungen';

  @override
  String get reviewsInbox_unanswered => 'Unbeantwortet';

  @override
  String get reviewsInbox_positive => 'Positiv';

  @override
  String get reviewsInbox_avgRating => 'Durchschn. Bewertung';

  @override
  String get reviewsInbox_sentimentOverview => 'Stimmungsübersicht';

  @override
  String get reviewsInbox_aiSuggestions => 'KI-Vorschläge';

  @override
  String get reviewsInbox_regenerate => 'Neu generieren';

  @override
  String get reviewsInbox_toneProfessional => 'Professionell';

  @override
  String get reviewsInbox_toneEmpathetic => 'Einfühlsam';

  @override
  String get reviewsInbox_toneBrief => 'Kurz';

  @override
  String get reviewsInbox_selectTone => 'Ton auswählen:';

  @override
  String get reviewsInbox_detectedIssues => 'Erkannte Probleme:';

  @override
  String get reviewsInbox_aiPrompt =>
      'Klicken Sie auf \'KI-Vorschlag generieren\', um Antwortvorschläge in 3 verschiedenen Tönen zu erhalten';

  @override
  String get reviewIntelligence_title => 'Bewertungs-Intelligence';

  @override
  String get reviewIntelligence_featureRequests => 'Feature-Anfragen';

  @override
  String get reviewIntelligence_bugReports => 'Bug-Reports';

  @override
  String get reviewIntelligence_sentimentByVersion => 'Stimmung nach Version';

  @override
  String get reviewIntelligence_openFeatures => 'Offene Features';

  @override
  String get reviewIntelligence_openBugs => 'Offene Bugs';

  @override
  String get reviewIntelligence_highPriority => 'Hohe Priorität';

  @override
  String get reviewIntelligence_total => 'gesamt';

  @override
  String get reviewIntelligence_mentions => 'Erwähnungen';

  @override
  String get reviewIntelligence_noData => 'Noch keine Erkenntnisse';

  @override
  String get reviewIntelligence_noDataHint =>
      'Erkenntnisse erscheinen nach der Analyse von Bewertungen';

  @override
  String get analytics_title => 'Analytik';

  @override
  String get analytics_downloads => 'Downloads';

  @override
  String get analytics_revenue => 'Umsatz';

  @override
  String get analytics_proceeds => 'Erlöse';

  @override
  String get analytics_subscribers => 'Abonnenten';

  @override
  String get analytics_downloadsOverTime => 'Downloads im Zeitverlauf';

  @override
  String get analytics_revenueOverTime => 'Umsatz im Zeitverlauf';

  @override
  String get analytics_byCountry => 'Nach Land';

  @override
  String get analytics_noData => 'Keine Daten verfügbar';

  @override
  String get analytics_noDataTitle => 'Keine Analysedaten';

  @override
  String get analytics_noDataDescription =>
      'Verbinden Sie Ihr App Store Connect oder Google Play Konto, um echte Verkaufs- und Download-Daten zu sehen.';

  @override
  String analytics_dataDelay(String date) {
    return 'Daten vom $date. Apple-Daten haben eine Verzögerung von 24-48h.';
  }

  @override
  String get analytics_export => 'CSV exportieren';

  @override
  String get funnel_title => 'Conversion-Trichter';

  @override
  String get funnel_impressions => 'Impressionen';

  @override
  String get funnel_pageViews => 'Seitenaufrufe';

  @override
  String get funnel_downloads => 'Downloads';

  @override
  String get funnel_overallCvr => 'Gesamt-CVR';

  @override
  String get funnel_categoryAvg => 'Kategorie-Durchschn.';

  @override
  String get funnel_vsCategory => 'vs Kategorie';

  @override
  String get funnel_bySource => 'Nach Quelle';

  @override
  String get funnel_noData => 'Keine Trichterdaten verfügbar';

  @override
  String get funnel_noDataHint =>
      'Trichterdaten werden automatisch von App Store Connect oder Google Play Console synchronisiert.';

  @override
  String get funnel_insight => 'ERKENNTNIS';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return '$bestSource-Traffic konvertiert ${ratio}x besser als $worstSource. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'Konzentrieren Sie sich auf Keyword-Optimierung, um Such-Impressionen zu erhöhen.';

  @override
  String get funnel_insightRecommendBrowse =>
      'Verbessern Sie die Sichtbarkeit Ihrer App durch Kategorieoptimierung und Featured-Platzierung.';

  @override
  String get funnel_insightRecommendReferral =>
      'Nutzen Sie Empfehlungsprogramme und Partnerschaften, um mehr Traffic zu generieren.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      'Erwägen Sie Cross-Promotion-Strategien mit ergänzenden Apps.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'Optimieren Sie Ihre Website und Landing-Pages für App-Downloads.';

  @override
  String get funnel_insightRecommendDefault =>
      'Analysieren Sie, was diese Quelle erfolgreich macht, und replizieren Sie es.';

  @override
  String get funnel_trendTitle => 'Conversion-Rate-Trend';

  @override
  String get funnel_connectStore => 'Store verbinden';

  @override
  String get nav_chat => 'KI-Assistent';

  @override
  String get chat_title => 'KI-Assistent';

  @override
  String get chat_newConversation => 'Neue Konversation';

  @override
  String get chat_loadingConversations => 'Konversationen werden geladen...';

  @override
  String get chat_loadingMessages => 'Nachrichten werden geladen...';

  @override
  String get chat_noConversations => 'Keine Konversationen';

  @override
  String get chat_noConversationsDesc =>
      'Starten Sie eine neue Konversation, um KI-gestützte Erkenntnisse über Ihre Apps zu erhalten';

  @override
  String get chat_startConversation => 'Konversation starten';

  @override
  String get chat_deleteConversation => 'Konversation löschen';

  @override
  String get chat_deleteConversationConfirm =>
      'Möchten Sie diese Konversation wirklich löschen?';

  @override
  String get chat_askAnything => 'Fragen Sie mich alles';

  @override
  String get chat_askAnythingDesc =>
      'Ich kann Ihnen helfen, die Bewertungen, Rankings und Analysen Ihrer App zu verstehen';

  @override
  String get chat_typeMessage => 'Geben Sie Ihre Frage ein...';

  @override
  String get chat_suggestedQuestions => 'Vorgeschlagene Fragen';

  @override
  String get chatActionConfirm => 'Bestätigen';

  @override
  String get chatActionCancel => 'Abbrechen';

  @override
  String get chatActionExecuting => 'Ausführen...';

  @override
  String get chatActionExecuted => 'Fertig';

  @override
  String get chatActionFailed => 'Fehlgeschlagen';

  @override
  String get chatActionCancelled => 'Abgebrochen';

  @override
  String get chatActionDownload => 'Herunterladen';

  @override
  String get chatActionReversible =>
      'Diese Aktion kann rückgängig gemacht werden';

  @override
  String get chatActionAddKeywords => 'Keywords hinzufügen';

  @override
  String get chatActionRemoveKeywords => 'Keywords entfernen';

  @override
  String get chatActionCreateAlert => 'Alarm erstellen';

  @override
  String get chatActionAddCompetitor => 'Wettbewerber hinzufügen';

  @override
  String get chatActionExportData => 'Daten exportieren';

  @override
  String get chatActionKeywords => 'Keywords';

  @override
  String get chatActionCountry => 'Land';

  @override
  String get chatActionAlertCondition => 'Bedingung';

  @override
  String get chatActionNotifyVia => 'Benachrichtigen via';

  @override
  String get chatActionCompetitor => 'Wettbewerber';

  @override
  String get chatActionExportType => 'Export-Typ';

  @override
  String get chatActionDateRange => 'Zeitraum';

  @override
  String get chatActionKeywordsLabel => 'Keywords';

  @override
  String get chatActionAnalyticsLabel => 'Statistiken';

  @override
  String get chatActionReviewsLabel => 'Bewertungen';

  @override
  String get common_cancel => 'Abbrechen';

  @override
  String get common_delete => 'Löschen';

  @override
  String get appDetail_tabOverview => 'Übersicht';

  @override
  String get appDetail_tabKeywords => 'Schlüsselwörter';

  @override
  String get appDetail_tabReviews => 'Bewertungen';

  @override
  String get appDetail_tabRatings => 'Bewertungen';

  @override
  String get appDetail_tabInsights => 'Erkenntnisse';

  @override
  String get dateRange_title => 'Zeitraum';

  @override
  String get dateRange_today => 'Heute';

  @override
  String get dateRange_yesterday => 'Gestern';

  @override
  String get dateRange_last7Days => 'Letzte 7 Tage';

  @override
  String get dateRange_last30Days => 'Letzte 30 Tage';

  @override
  String get dateRange_thisMonth => 'Dieser Monat';

  @override
  String get dateRange_lastMonth => 'Letzter Monat';

  @override
  String get dateRange_last90Days => 'Letzte 90 Tage';

  @override
  String get dateRange_yearToDate => 'Jahresbeginn bis heute';

  @override
  String get dateRange_allTime => 'Alle';

  @override
  String get dateRange_custom => 'Benutzerdefiniert...';

  @override
  String get dateRange_compareToPrevious =>
      'Mit vorherigem Zeitraum vergleichen';

  @override
  String get export_keywordsTitle => 'Keywords exportieren';

  @override
  String get export_reviewsTitle => 'Bewertungen exportieren';

  @override
  String get export_analyticsTitle => 'Analysen exportieren';

  @override
  String get export_columnsToInclude => 'Einzuschließende Spalten:';

  @override
  String get export_button => 'Exportieren';

  @override
  String get export_keyword => 'Keyword';

  @override
  String get export_position => 'Position';

  @override
  String get export_change => 'Änderung';

  @override
  String get export_popularity => 'Beliebtheit';

  @override
  String get export_difficulty => 'Schwierigkeit';

  @override
  String get export_tags => 'Tags';

  @override
  String get export_notes => 'Notizen';

  @override
  String get export_trackedSince => 'Verfolgt seit';

  @override
  String get export_date => 'Datum';

  @override
  String get export_rating => 'Bewertung';

  @override
  String get export_author => 'Autor';

  @override
  String get export_title => 'Titel';

  @override
  String get export_content => 'Inhalt';

  @override
  String get export_country => 'Land';

  @override
  String get export_version => 'Version';

  @override
  String get export_sentiment => 'Stimmung';

  @override
  String get export_response => 'Unsere Antwort';

  @override
  String get export_responseDate => 'Antwortdatum';

  @override
  String export_keywordsCount(int count) {
    return '$count Keywords werden exportiert';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count Bewertungen werden exportiert';
  }

  @override
  String export_success(String filename) {
    return 'Export gespeichert: $filename';
  }

  @override
  String export_error(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get metadata_editor => 'Metadaten-Editor';

  @override
  String get metadata_selectLocale => 'Wählen Sie eine Sprache zum Bearbeiten';

  @override
  String get metadata_refreshed => 'Metadaten vom Store aktualisiert';

  @override
  String get metadata_connectRequired =>
      'Verbindung zum Bearbeiten erforderlich';

  @override
  String get metadata_connectDescription =>
      'Verbinden Sie Ihr App Store Connect-Konto, um die Metadaten Ihrer App direkt von Keyrank aus zu bearbeiten.';

  @override
  String get metadata_connectStore => 'App Store verbinden';

  @override
  String get metadata_publishTitle => 'Metadaten veröffentlichen';

  @override
  String metadata_publishConfirm(String locale) {
    return 'Änderungen für $locale veröffentlichen? Dies aktualisiert den Eintrag Ihrer App im App Store.';
  }

  @override
  String get metadata_publish => 'Veröffentlichen';

  @override
  String get metadata_publishSuccess => 'Metadaten erfolgreich veröffentlicht';

  @override
  String get metadata_saveDraft => 'Entwurf speichern';

  @override
  String get metadata_draftSaved => 'Entwurf gespeichert';

  @override
  String get metadata_discardChanges => 'Änderungen verwerfen';

  @override
  String get metadata_title => 'Titel';

  @override
  String metadata_titleHint(int limit) {
    return 'App-Name (max. $limit Zeichen)';
  }

  @override
  String get metadata_subtitle => 'Untertitel';

  @override
  String metadata_subtitleHint(int limit) {
    return 'Kurze Beschreibung (max. $limit Zeichen)';
  }

  @override
  String get metadata_keywords => 'Schlüsselwörter';

  @override
  String metadata_keywordsHint(int limit) {
    return 'Kommagetrennte Schlüsselwörter (max. $limit Zeichen)';
  }

  @override
  String get metadata_description => 'Beschreibung';

  @override
  String metadata_descriptionHint(int limit) {
    return 'Vollständige App-Beschreibung (max. $limit Zeichen)';
  }

  @override
  String get metadata_promotionalText => 'Werbetext';

  @override
  String metadata_promotionalTextHint(int limit) {
    return 'Kurze Werbebotschaft (max. $limit Zeichen)';
  }

  @override
  String get metadata_whatsNew => 'Neuheiten';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'Versionshinweise (max. $limit Zeichen)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => 'Ungespeicherte Änderungen';

  @override
  String get metadata_noChanges => 'Keine Änderungen';

  @override
  String get metadata_keywordAnalysis => 'Keyword-Analyse';

  @override
  String get metadata_keywordPresent => 'Vorhanden';

  @override
  String get metadata_keywordMissing => 'Fehlt';

  @override
  String get metadata_inTitle => 'Im Titel';

  @override
  String get metadata_inSubtitle => 'Im Untertitel';

  @override
  String get metadata_inKeywords => 'In Keywords';

  @override
  String get metadata_inDescription => 'In Beschreibung';

  @override
  String get metadata_history => 'Änderungsverlauf';

  @override
  String get metadata_noHistory => 'Keine Änderungen aufgezeichnet';

  @override
  String get metadata_localeComplete => 'Vollständig';

  @override
  String get metadata_localeIncomplete => 'Unvollständig';

  @override
  String get metadata_shortDescription => 'Kurzbeschreibung';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return 'Kurze Beschreibung in der Suche (max. $limit Zeichen)';
  }

  @override
  String get metadata_fullDescription => 'Vollständige Beschreibung';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'Vollständige App-Beschreibung (max. $limit Zeichen)';
  }

  @override
  String get metadata_releaseNotes => 'Versionshinweise';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'Neuheiten in dieser Version (max. $limit Zeichen)';
  }

  @override
  String get metadata_selectAppFirst => 'Wählen Sie eine App aus';

  @override
  String get metadata_selectAppHint =>
      'Verwenden Sie die App-Auswahl in der Seitenleiste oder verbinden Sie einen Store, um zu beginnen.';

  @override
  String get metadata_noStoreConnection => 'Store-Verbindung erforderlich';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return 'Verbinden Sie Ihr $storeName-Konto, um die Metadaten Ihrer App abzurufen und zu bearbeiten.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return '$storeName verbinden';
  }

  @override
  String get metadataLocalization => 'Lokalisierungen';

  @override
  String get metadataLive => 'Live';

  @override
  String get metadataDraft => 'Entwurf';

  @override
  String get metadataEmpty => 'Leer';

  @override
  String metadataCoverageInsight(int count) {
    return '$count Sprachen benötigen Inhalte. Erwägen Sie die Lokalisierung für Ihre Top-Märkte.';
  }

  @override
  String get metadataFilterAll => 'Alle';

  @override
  String get metadataFilterLive => 'Live';

  @override
  String get metadataFilterDraft => 'Entwürfe';

  @override
  String get metadataFilterEmpty => 'Leer';

  @override
  String get metadataBulkActions => 'Massenaktionen';

  @override
  String get metadataCopyTo => 'Zur Auswahl kopieren';

  @override
  String get metadataTranslateTo => 'Zur Auswahl übersetzen';

  @override
  String get metadataPublishSelected => 'Auswahl veröffentlichen';

  @override
  String get metadataDeleteDrafts => 'Entwürfe löschen';

  @override
  String get metadataSelectSource => 'Quellsprache auswählen';

  @override
  String get metadataSelectTarget => 'Zielsprachen auswählen';

  @override
  String metadataCopySuccess(int count) {
    return 'Inhalt in $count Sprachen kopiert';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return 'In $count Sprachen übersetzt';
  }

  @override
  String get metadataTranslating => 'Übersetze...';

  @override
  String get metadataNoSelection => 'Wählen Sie zuerst Sprachen aus';

  @override
  String get metadataSelectAll => 'Alle auswählen';

  @override
  String get metadataDeselectAll => 'Alle abwählen';

  @override
  String metadataSelected(int count) {
    return '$count ausgewählt';
  }

  @override
  String get metadataTableView => 'Tabellenansicht';

  @override
  String get metadataListView => 'Listenansicht';

  @override
  String get metadataStatus => 'Status';

  @override
  String get metadataCompletion => 'Vollständigkeit';

  @override
  String get common_back => 'Zurück';

  @override
  String get common_next => 'Weiter';

  @override
  String get common_edit => 'Bearbeiten';

  @override
  String get metadata_aiOptimize => 'Mit KI optimieren';

  @override
  String get wizard_title => 'KI-Optimierungsassistent';

  @override
  String get wizard_step => 'Schritt';

  @override
  String get wizard_of => 'von';

  @override
  String get wizard_stepTitle => 'Titel';

  @override
  String get wizard_stepSubtitle => 'Untertitel';

  @override
  String get wizard_stepKeywords => 'Schlüsselwörter';

  @override
  String get wizard_stepDescription => 'Beschreibung';

  @override
  String get wizard_stepReview => 'Überprüfen & Speichern';

  @override
  String get wizard_skip => 'Überspringen';

  @override
  String get wizard_saveDrafts => 'Entwürfe speichern';

  @override
  String get wizard_draftsSaved => 'Entwürfe erfolgreich gespeichert';

  @override
  String get wizard_exitTitle => 'Assistent beenden?';

  @override
  String get wizard_exitMessage =>
      'Sie haben ungespeicherte Änderungen. Möchten Sie wirklich beenden?';

  @override
  String get wizard_exitConfirm => 'Beenden';

  @override
  String get wizard_aiSuggestions => 'KI-Vorschläge';

  @override
  String get wizard_chooseSuggestion =>
      'Wählen Sie einen KI-generierten Vorschlag oder schreiben Sie Ihren eigenen';

  @override
  String get wizard_currentValue => 'Aktueller Wert';

  @override
  String get wizard_noCurrentValue => 'Kein aktueller Wert gesetzt';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return 'Basierend auf $keywordsCount verfolgten Keywords und $competitorsCount Wettbewerbern';
  }

  @override
  String get wizard_writeOwn => 'Eigenen schreiben';

  @override
  String get wizard_customPlaceholder =>
      'Geben Sie Ihren benutzerdefinierten Wert ein...';

  @override
  String get wizard_useCustom => 'Benutzerdefinierten verwenden';

  @override
  String get wizard_keepCurrent => 'Aktuellen behalten';

  @override
  String get wizard_recommended => 'Empfohlen';

  @override
  String get wizard_characters => 'Zeichen';

  @override
  String get wizard_reviewTitle => 'Änderungen überprüfen';

  @override
  String get wizard_reviewDescription =>
      'Überprüfen Sie Ihre Optimierungen, bevor Sie sie als Entwürfe speichern';

  @override
  String get wizard_noChanges => 'Keine Änderungen ausgewählt';

  @override
  String get wizard_noChangesHint =>
      'Gehen Sie zurück und wählen Sie Vorschläge für die zu optimierenden Felder';

  @override
  String wizard_changesCount(int count) {
    return '$count Felder aktualisiert';
  }

  @override
  String get wizard_changesSummary =>
      'Diese Änderungen werden als Entwürfe gespeichert';

  @override
  String get wizard_before => 'Vorher';

  @override
  String get wizard_after => 'Nachher';

  @override
  String get wizard_nextStepsTitle => 'Was passiert als Nächstes?';

  @override
  String get wizard_nextStepsWithChanges =>
      'Ihre Änderungen werden als Entwürfe gespeichert. Sie können sie im Metadaten-Editor überprüfen und veröffentlichen.';

  @override
  String get wizard_nextStepsNoChanges =>
      'Keine Änderungen zum Speichern. Gehen Sie zurück und wählen Sie Vorschläge, um Ihre Metadaten zu optimieren.';

  @override
  String get team_title => 'Teamverwaltung';

  @override
  String get team_createTeam => 'Team erstellen';

  @override
  String get team_teamName => 'Teamname';

  @override
  String get team_teamNameHint => 'Teamname eingeben';

  @override
  String get team_description => 'Beschreibung (optional)';

  @override
  String get team_descriptionHint => 'Wofür ist dieses Team?';

  @override
  String get team_teamNameRequired => 'Teamname ist erforderlich';

  @override
  String get team_teamNameMinLength =>
      'Teamname muss mindestens 2 Zeichen haben';

  @override
  String get team_inviteMember => 'Teammitglied einladen';

  @override
  String get team_emailAddress => 'E-Mail-Adresse';

  @override
  String get team_emailHint => 'kollege@beispiel.com';

  @override
  String get team_emailRequired => 'E-Mail ist erforderlich';

  @override
  String get team_emailInvalid => 'Geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String team_invitationSent(String email) {
    return 'Einladung an $email gesendet';
  }

  @override
  String get team_members => 'MITGLIEDER';

  @override
  String get team_invite => 'Einladen';

  @override
  String get team_pendingInvitations => 'AUSSTEHENDE EINLADUNGEN';

  @override
  String get team_noPendingInvitations => 'Keine ausstehenden Einladungen';

  @override
  String get team_teamSettings => 'Teameinstellungen';

  @override
  String team_changeRole(String name) {
    return 'Rolle für $name ändern';
  }

  @override
  String get team_removeMember => 'Mitglied entfernen';

  @override
  String team_removeMemberConfirm(String name) {
    return 'Möchten Sie $name wirklich aus diesem Team entfernen?';
  }

  @override
  String get team_remove => 'Entfernen';

  @override
  String get team_leaveTeam => 'Team verlassen';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return 'Möchten Sie \"$teamName\" wirklich verlassen?';
  }

  @override
  String get team_leave => 'Verlassen';

  @override
  String get team_deleteTeam => 'Team löschen';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return 'Möchten Sie \"$teamName\" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get team_yourTeams => 'IHRE TEAMS';

  @override
  String get team_failedToLoadTeam => 'Team konnte nicht geladen werden';

  @override
  String get team_failedToLoadMembers =>
      'Mitglieder konnten nicht geladen werden';

  @override
  String get team_failedToLoadInvitations =>
      'Einladungen konnten nicht geladen werden';

  @override
  String team_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String team_invitedAs(String role) {
    return 'Eingeladen als $role';
  }

  @override
  String team_joinedTeam(String teamName) {
    return '$teamName beigetreten';
  }

  @override
  String get team_invitationDeclined => 'Einladung abgelehnt';

  @override
  String get team_noTeamsYet => 'Noch keine Teams';

  @override
  String get team_noTeamsDescription =>
      'Erstellen Sie ein Team, um mit anderen an Ihren Apps zusammenzuarbeiten';

  @override
  String get team_createFirstTeam => 'Erstes Team erstellen';

  @override
  String get integrations_title => 'Integrationen';

  @override
  String integrations_syncFailed(String error) {
    return 'Synchronisierung fehlgeschlagen: $error';
  }

  @override
  String get integrations_disconnectConfirm => 'Trennen?';

  @override
  String get integrations_disconnectedSuccess => 'Erfolgreich getrennt';

  @override
  String get integrations_connectGooglePlay => 'Google Play Console verbinden';

  @override
  String get integrations_connectAppStore => 'App Store Connect verbinden';

  @override
  String integrations_connectedApps(int count) {
    return 'Verbunden! $count Apps importiert.';
  }

  @override
  String integrations_syncedApps(int count) {
    return '$count Apps als Eigentümer synchronisiert';
  }

  @override
  String get integrations_appStoreConnected =>
      'App Store Connect erfolgreich verbunden!';

  @override
  String get integrations_googlePlayConnected =>
      'Google Play Console erfolgreich verbunden!';

  @override
  String get integrations_description =>
      'Connect your store accounts to import apps, reply to reviews, and access analytics.';

  @override
  String integrations_errorLoading(String error) {
    return 'Error loading integrations: $error';
  }

  @override
  String integrations_syncedAppsDetails(int imported, int discovered) {
    return 'Synced $imported apps ($discovered discovered)';
  }

  @override
  String get integrations_appStoreConnect => 'App Store Connect';

  @override
  String get integrations_connectAppleAccount =>
      'Connect your Apple Developer account';

  @override
  String get integrations_googlePlayConsole => 'Google Play Console';

  @override
  String get integrations_connectGoogleAccount =>
      'Connect your Google Play account';

  @override
  String integrations_disconnectConfirmMessage(String type, int count) {
    return 'Are you sure you want to disconnect $type? This will remove $count imported apps.';
  }

  @override
  String get integrations_disconnect => 'Disconnect';

  @override
  String get integrations_connect => 'Connect';

  @override
  String get integrations_connected => 'Connected';

  @override
  String get integrations_error => 'Error';

  @override
  String get integrations_syncing => 'Syncing...';

  @override
  String get integrations_refreshApps => 'Refresh Apps';

  @override
  String integrations_lastSynced(String date) {
    return 'Last synced: $date';
  }

  @override
  String integrations_connectedOn(String date) {
    return 'Connected on $date';
  }

  @override
  String integrations_appsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps imported',
      one: '1 app imported',
    );
    return '$_temp0';
  }

  @override
  String get alertBuilder_nameYourRule => 'REGEL BENENNEN';

  @override
  String get alertBuilder_nameDescription =>
      'Geben Sie Ihrer Alarmregel einen beschreibenden Namen';

  @override
  String get alertBuilder_nameHint => 'z.B. Täglicher Positionsalarm';

  @override
  String get alertBuilder_summary => 'ZUSAMMENFASSUNG';

  @override
  String get alertBuilder_saveAlertRule => 'Alarmregel speichern';

  @override
  String get alertBuilder_selectAlertType => 'ALARMTYP AUSWÄHLEN';

  @override
  String get alertBuilder_selectAlertTypeDescription =>
      'Wählen Sie, welche Art von Alarm Sie erstellen möchten';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return '\"$ruleName\" wird gelöscht.';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate =>
      'Noch keine Regeln. Aktivieren Sie eine Vorlage oder erstellen Sie Ihre eigene!';

  @override
  String get billing_cancelSubscription => 'Abonnement kündigen';

  @override
  String get billing_keepSubscription => 'Abonnement behalten';

  @override
  String get billing_billingPortal => 'Abrechnungsportal';

  @override
  String get billing_resume => 'Fortsetzen';

  @override
  String get keywords_noCompetitorsFound =>
      'Keine Wettbewerber gefunden. Fügen Sie zuerst Wettbewerber hinzu.';

  @override
  String get keywords_noCompetitorsForApp =>
      'Keine Wettbewerber für diese App. Fügen Sie zuerst einen Wettbewerber hinzu.';

  @override
  String keywords_failedToAddKeywords(String error) {
    return 'Fehler beim Hinzufügen der Suchbegriffe: $error';
  }

  @override
  String get keywords_bulkAddHint =>
      'Budget-Tracker\nAusgaben-Manager\nGeld-App';

  @override
  String get appOverview_urlCopied => 'Store-URL in die Zwischenablage kopiert';

  @override
  String get country_us => 'Vereinigte Staaten';

  @override
  String get country_gb => 'Vereinigtes Königreich';

  @override
  String get country_fr => 'Frankreich';

  @override
  String get country_de => 'Deutschland';

  @override
  String get country_ca => 'Kanada';

  @override
  String get country_au => 'Australien';

  @override
  String get country_jp => 'Japan';

  @override
  String get country_cn => 'China';

  @override
  String get country_kr => 'Südkorea';

  @override
  String get country_br => 'Brasilien';

  @override
  String get country_es => 'Spanien';

  @override
  String get country_it => 'Italien';

  @override
  String get countryCode_us => '🇺🇸 US';

  @override
  String get countryCode_gb => '🇬🇧 UK';

  @override
  String get countryCode_fr => '🇫🇷 FR';

  @override
  String get countryCode_de => '🇩🇪 DE';

  @override
  String get countryCode_ca => '🇨🇦 CA';

  @override
  String get countryCode_au => '🇦🇺 AU';

  @override
  String get alertBuilder_type => 'Typ';

  @override
  String get alertBuilder_scope => 'Bereich';

  @override
  String get alertBuilder_name => 'Name';

  @override
  String get alertBuilder_scopeGlobal => 'Alle Apps';

  @override
  String get alertBuilder_scopeApp => 'Bestimmte App';

  @override
  String get alertBuilder_scopeCategory => 'Kategorie';

  @override
  String get alertBuilder_scopeKeyword => 'Suchbegriff';

  @override
  String get alertType_positionChange => 'Positionsänderung';

  @override
  String get alertType_positionChangeDesc =>
      'Warnung bei signifikanter Rangänderung';

  @override
  String get alertType_ratingChange => 'Bewertungsänderung';

  @override
  String get alertType_ratingChangeDesc => 'Warnung bei Bewertungsänderung';

  @override
  String get alertType_reviewSpike => 'Bewertungsspitze';

  @override
  String get alertType_reviewSpikeDesc =>
      'Warnung bei ungewöhnlicher Bewertungsaktivität';

  @override
  String get alertType_reviewKeyword => 'Bewertungs-Suchbegriff';

  @override
  String get alertType_reviewKeywordDesc =>
      'Warnung wenn Suchbegriffe in Bewertungen erscheinen';

  @override
  String get alertType_newCompetitor => 'Neuer Wettbewerber';

  @override
  String get alertType_newCompetitorDesc =>
      'Warnung wenn neue Apps in Ihrem Bereich erscheinen';

  @override
  String get alertType_competitorPassed => 'Wettbewerber überholt';

  @override
  String get alertType_competitorPassedDesc =>
      'Warnung wenn Sie einen Wettbewerber überholen';

  @override
  String get alertType_massMovement => 'Massenbewegung';

  @override
  String get alertType_massMovementDesc =>
      'Warnung bei großen Rangverschiebungen';

  @override
  String get alertType_keywordTrend => 'Suchbegriff-Trend';

  @override
  String get alertType_keywordTrendDesc =>
      'Warnung bei Änderung der Suchbegriff-Popularität';

  @override
  String get alertType_opportunity => 'Gelegenheit';

  @override
  String get alertType_opportunityDesc => 'Warnung bei neuen Rangmöglichkeiten';

  @override
  String get billing_title => 'Abrechnung & Pläne';

  @override
  String get billing_subscriptionActivated =>
      'Abonnement erfolgreich aktiviert!';

  @override
  String get billing_changePlan => 'Plan ändern';

  @override
  String get billing_choosePlan => 'Plan wählen';

  @override
  String get billing_cancelMessage =>
      'Ihr Abonnement bleibt bis zum Ende des aktuellen Abrechnungszeitraums aktiv. Danach verlieren Sie den Zugang zu Premium-Funktionen.';

  @override
  String get billing_currentPlan => 'AKTUELLER PLAN';

  @override
  String get billing_trial => 'TESTVERSION';

  @override
  String get billing_canceling => 'WIRD GEKÜNDIGT';

  @override
  String billing_accessUntil(String date) {
    return 'Zugang bis $date';
  }

  @override
  String billing_renewsOn(String date) {
    return 'Verlängerung am $date';
  }

  @override
  String get billing_manageSubscription => 'ABONNEMENT VERWALTEN';

  @override
  String get billing_monthly => 'Monatlich';

  @override
  String get billing_yearly => 'Jährlich';

  @override
  String billing_savePercent(int percent) {
    return '$percent% sparen';
  }

  @override
  String get billing_current => 'Aktuell';

  @override
  String get billing_apps => 'Apps';

  @override
  String get billing_unlimited => 'Unbegrenzt';

  @override
  String get billing_keywordsPerApp => 'Suchbegriffe pro App';

  @override
  String get billing_history => 'Verlauf';

  @override
  String billing_days(int count) {
    return '$count Tage';
  }

  @override
  String get billing_exports => 'Exporte';

  @override
  String get billing_aiInsights => 'KI-Einblicke';

  @override
  String get billing_apiAccess => 'API-Zugang';

  @override
  String get billing_yes => 'Ja';

  @override
  String get billing_no => 'Nein';

  @override
  String get billing_currentPlanButton => 'Aktueller Plan';

  @override
  String billing_upgradeTo(String planName) {
    return 'Auf $planName upgraden';
  }

  @override
  String get billing_cancel => 'Abbrechen';

  @override
  String get keywords_compareWithCompetitor => 'Mit Wettbewerber vergleichen';

  @override
  String get keywords_selectCompetitorToCompare =>
      'Wählen Sie einen Wettbewerber zum Vergleichen der Suchbegriffe:';

  @override
  String get keywords_addToCompetitor => 'Zu Wettbewerber hinzufügen';

  @override
  String keywords_addKeywordsTo(int count) {
    return '$count Suchbegriff(e) hinzufügen zu:';
  }

  @override
  String get keywords_avgPosition => 'Durchschn. Position';

  @override
  String get keywords_declined => 'Gesunken';

  @override
  String get keywords_total => 'Gesamt';

  @override
  String get keywords_ranked => 'Platziert';

  @override
  String get keywords_improved => 'Verbessert';

  @override
  String get onboarding_skip => 'Überspringen';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_getStarted => 'Loslegen';

  @override
  String get onboarding_welcomeToKeyrank => 'Willkommen bei Keyrank';

  @override
  String get onboarding_welcomeSubtitle =>
      'Track your app rankings, manage reviews, and optimize your ASO strategy.';

  @override
  String get onboarding_connectStore => 'Connect Your Store';

  @override
  String get onboarding_connectStoreSubtitle =>
      'Optional: Connect to import apps and reply to reviews.';

  @override
  String get onboarding_couldNotLoadIntegrations =>
      'Could not load integrations';

  @override
  String get onboarding_tapToConnect => 'Tap to connect';

  @override
  String get onboarding_allSet => 'You\'re All Set!';

  @override
  String get onboarding_allSetSubtitle =>
      'Start by adding an app to track, or explore the keyword inspector.';

  @override
  String get team_you => 'Sie';

  @override
  String get team_changeRoleButton => 'Change Role';

  @override
  String get team_removeButton => 'Remove';

  @override
  String get competitors_removeTitle => 'Remove Competitor';

  @override
  String competitors_removeConfirm(String name) {
    return 'Möchten Sie \"$name\" wirklich aus Ihren Konkurrenten entfernen?';
  }

  @override
  String competitors_removed(String name) {
    return '$name removed';
  }

  @override
  String competitors_removeFailed(String error) {
    return 'Failed to remove competitor: $error';
  }

  @override
  String get competitors_addCompetitor => 'Add competitor';

  @override
  String get competitors_filterAll => 'All';

  @override
  String get competitors_filterGlobal => 'Global';

  @override
  String get competitors_filterContextual => 'Contextual';

  @override
  String get competitors_noCompetitorsYet => 'No competitors tracked yet';

  @override
  String get competitors_noGlobalCompetitors => 'No global competitors';

  @override
  String get competitors_noContextualCompetitors => 'No contextual competitors';

  @override
  String get competitors_emptySubtitleAll =>
      'Search for apps and add them as competitors to track their rankings';

  @override
  String get competitors_emptySubtitleGlobal =>
      'Global competitors appear across all your apps';

  @override
  String get competitors_emptySubtitleContextual =>
      'Contextual competitors are linked to specific apps';

  @override
  String get competitors_searchForCompetitors => 'Search for competitors';

  @override
  String get competitors_viewKeywords => 'View Keywords';

  @override
  String get common_remove => 'Remove';

  @override
  String get competitors_addTitle => 'Add Competitor';

  @override
  String competitors_addedAsCompetitor(String name) {
    return '$name added as competitor';
  }

  @override
  String competitors_addFailed(String error) {
    return 'Hinzufügen des Konkurrenten fehlgeschlagen: $error';
  }

  @override
  String get competitors_searchForCompetitor => 'Search for a competitor';

  @override
  String get appPreview_back => 'Back';

  @override
  String get alerts_edit => 'Bearbeiten';

  @override
  String get alerts_scopeGlobal => 'Global';

  @override
  String get alerts_scopeApp => 'App';

  @override
  String get alerts_scopeCategory => 'Kategorie';

  @override
  String get alerts_scopeKeyword => 'Keyword';

  @override
  String ratings_showMore(int count) {
    return 'Show more ($count remaining)';
  }

  @override
  String get ratings_showLess => 'Show less';

  @override
  String get insights_aiInsights => 'AI Insights';

  @override
  String get insights_viewAll => 'View all';

  @override
  String insights_viewMore(int count) {
    return '$count weitere Einblicke anzeigen';
  }

  @override
  String get insights_noInsightsDesc =>
      'Einblicke werden angezeigt, wenn wir Optimierungsmöglichkeiten für Ihre App entdecken.';

  @override
  String get insights_loadFailed => 'Einblicke konnten nicht geladen werden';

  @override
  String chat_createFailed(String error) {
    return 'Failed to create conversation: $error';
  }

  @override
  String chat_deleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String get notifications_manageAlerts => 'Manage alerts';
}
