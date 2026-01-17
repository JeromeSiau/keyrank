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
  String get dashboard_reviews => 'Reviews';

  @override
  String get dashboard_avgRating => 'Avg Rating';

  @override
  String get dashboard_topPerformingApps => 'Top Performing Apps';

  @override
  String get dashboard_topCountries => 'Top Countries';

  @override
  String get dashboard_sentimentOverview => 'Sentiment Overview';

  @override
  String get dashboard_overallSentiment => 'Overall Sentiment';

  @override
  String get dashboard_positive => 'Positive';

  @override
  String get dashboard_positiveReviews => 'Positive';

  @override
  String get dashboard_negativeReviews => 'Negative';

  @override
  String get dashboard_viewReviews => 'View reviews';

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
  String get keywordSuggestions_categoryAll => 'All';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'High Opportunity';

  @override
  String get keywordSuggestions_categoryCompetitor => 'Competitor Keywords';

  @override
  String get keywordSuggestions_categoryLongTail => 'Long-tail';

  @override
  String get keywordSuggestions_categoryTrending => 'Trending';

  @override
  String get keywordSuggestions_categoryRelated => 'Related';

  @override
  String get keywordSuggestions_generating => 'Generating suggestions...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      'This may take a few minutes. Please check back later.';

  @override
  String get keywordSuggestions_checkAgain => 'Check again';

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
  String get discover_title => 'Discover';

  @override
  String get discover_tabKeywords => 'Keywords';

  @override
  String get discover_tabCategories => 'Categories';

  @override
  String get discover_selectCategory => 'Select a category';

  @override
  String get discover_topFree => 'Free';

  @override
  String get discover_topPaid => 'Paid';

  @override
  String get discover_topGrossing => 'Grossing';

  @override
  String get discover_noResults => 'No results';

  @override
  String get discover_loadingTopApps => 'Loading top apps...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return 'Top $collection in $category';
  }

  @override
  String discover_appsCount(int count) {
    return '$count apps';
  }

  @override
  String get discover_allCategories => 'All categories';

  @override
  String get category_games => 'Games';

  @override
  String get category_business => 'Business';

  @override
  String get category_education => 'Education';

  @override
  String get category_entertainment => 'Entertainment';

  @override
  String get category_finance => 'Finance';

  @override
  String get category_food_drink => 'Food & Drink';

  @override
  String get category_health_fitness => 'Health & Fitness';

  @override
  String get category_lifestyle => 'Lifestyle';

  @override
  String get category_medical => 'Medical';

  @override
  String get category_music => 'Music';

  @override
  String get category_navigation => 'Navigation';

  @override
  String get category_news => 'News';

  @override
  String get category_photo_video => 'Photo & Video';

  @override
  String get category_productivity => 'Productivity';

  @override
  String get category_reference => 'Reference';

  @override
  String get category_shopping => 'Shopping';

  @override
  String get category_social => 'Social Networking';

  @override
  String get category_sports => 'Sports';

  @override
  String get category_travel => 'Travel';

  @override
  String get category_utilities => 'Utilities';

  @override
  String get category_weather => 'Weather';

  @override
  String get category_books => 'Books';

  @override
  String get category_developer_tools => 'Developer Tools';

  @override
  String get category_graphics_design => 'Graphics & Design';

  @override
  String get category_magazines => 'Magazines & Newspapers';

  @override
  String get category_stickers => 'Stickers';

  @override
  String get category_catalogs => 'Catalogs';

  @override
  String get category_art_design => 'Art & Design';

  @override
  String get category_auto_vehicles => 'Auto & Vehicles';

  @override
  String get category_beauty => 'Beauty';

  @override
  String get category_comics => 'Comics';

  @override
  String get category_communication => 'Communication';

  @override
  String get category_dating => 'Dating';

  @override
  String get category_events => 'Events';

  @override
  String get category_house_home => 'House & Home';

  @override
  String get category_libraries => 'Libraries & Demo';

  @override
  String get category_maps_navigation => 'Maps & Navigation';

  @override
  String get category_music_audio => 'Music & Audio';

  @override
  String get category_news_magazines => 'News & Magazines';

  @override
  String get category_parenting => 'Parenting';

  @override
  String get category_personalization => 'Personalization';

  @override
  String get category_photography => 'Photography';

  @override
  String get category_tools => 'Tools';

  @override
  String get category_video_players => 'Video Players & Editors';

  @override
  String get category_all_apps => 'All Apps';

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
  String get nav_reviewsInbox => 'Reviews Inbox';

  @override
  String get nav_notifications => 'Benachr.';

  @override
  String get nav_optimization => 'OPTIMIZATION';

  @override
  String get nav_keywordInspector => 'Keyword Inspector';

  @override
  String get nav_ratingsAnalysis => 'Ratings Analysis';

  @override
  String get nav_intelligence => 'INTELLIGENCE';

  @override
  String get nav_topCharts => 'Top Charts';

  @override
  String get nav_competitors => 'Competitors';

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
  String get appDetail_currentTags => 'Current Tags';

  @override
  String get appDetail_noTagsOnKeyword => 'No tags on this keyword';

  @override
  String get appDetail_addExistingTag => 'Add Existing Tag';

  @override
  String get appDetail_allTagsUsed => 'All tags already added';

  @override
  String get appDetail_createNewTag => 'Create New Tag';

  @override
  String get appDetail_tagNameHint => 'Tag name...';

  @override
  String get appDetail_note => 'Note';

  @override
  String get appDetail_noteHint => 'Add a note about this keyword...';

  @override
  String get appDetail_saveNote => 'Save Note';

  @override
  String get appDetail_done => 'Done';

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
  String get keywords_difficultyFilter => 'Difficulty:';

  @override
  String get keywords_difficultyAll => 'All';

  @override
  String get keywords_difficultyEasy => 'Easy < 40';

  @override
  String get keywords_difficultyMedium => 'Medium 40-70';

  @override
  String get keywords_difficultyHard => 'Hard > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'App Details';

  @override
  String get appPreview_notFound => 'App not found';

  @override
  String get appPreview_screenshots => 'Screenshots';

  @override
  String get appPreview_description => 'Description';

  @override
  String get appPreview_details => 'Details';

  @override
  String get appPreview_version => 'Version';

  @override
  String get appPreview_updated => 'Updated';

  @override
  String get appPreview_released => 'Released';

  @override
  String get appPreview_size => 'Size';

  @override
  String get appPreview_minimumOs => 'Requires';

  @override
  String get appPreview_price => 'Price';

  @override
  String get appPreview_free => 'Free';

  @override
  String get appPreview_openInStore => 'Open in Store';

  @override
  String get appPreview_addToMyApps => 'Add to My Apps';

  @override
  String get appPreview_added => 'Added';

  @override
  String get appPreview_showMore => 'Show more';

  @override
  String get appPreview_showLess => 'Show less';

  @override
  String get appPreview_keywordsPlaceholder =>
      'Add this app to your tracked apps to enable keyword tracking';

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
      'Aktivieren Sie haufige Alarme mit einem Tippen';

  @override
  String get alerts_myRulesTitle => 'Meine Regeln';

  @override
  String get alerts_createRule => 'Regel erstellen';

  @override
  String get alerts_editRule => 'Regel bearbeiten';

  @override
  String get alerts_noRulesYet => 'Noch keine Regeln';

  @override
  String get alerts_deleteConfirm => 'Regel loschen?';

  @override
  String get settings_notifications => 'BENACHRICHTIGUNGEN';

  @override
  String get settings_manageAlerts => 'Alarmregeln verwalten';

  @override
  String get settings_manageAlertsDesc =>
      'Konfigurieren Sie, welche Alarme Sie erhalten';

  @override
  String get settings_storeConnections => 'Store Connections';

  @override
  String get settings_storeConnectionsDesc =>
      'Connect your App Store and Google Play accounts';

  @override
  String get storeConnections_title => 'Store Connections';

  @override
  String get storeConnections_description =>
      'Connect your App Store and Google Play accounts to enable advanced features like sales data and app analytics.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Connect your Apple Developer account';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Connect your Google Play account';

  @override
  String get storeConnections_connect => 'Connect';

  @override
  String get storeConnections_disconnect => 'Disconnect';

  @override
  String get storeConnections_connected => 'Connected';

  @override
  String get storeConnections_disconnectConfirm => 'Disconnect?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'Are you sure you want to disconnect this $platform account?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Disconnected successfully';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Last synced: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return 'Connected on $date';
  }

  @override
  String get reviewsInbox_title => 'Reviews Inbox';

  @override
  String get reviewsInbox_filterUnanswered => 'Unanswered';

  @override
  String get reviewsInbox_filterNegative => 'Negative';

  @override
  String get reviewsInbox_noReviews => 'No reviews found';

  @override
  String get reviewsInbox_noReviewsDesc => 'Try adjusting your filters';

  @override
  String get reviewsInbox_reply => 'Reply';

  @override
  String get reviewsInbox_responded => 'Response';

  @override
  String reviewsInbox_respondedAt(String date) {
    return 'Responded $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Reply to Review';

  @override
  String get reviewsInbox_generateAi => 'Generate AI suggestion';

  @override
  String get reviewsInbox_generating => 'Generating...';

  @override
  String get reviewsInbox_sendReply => 'Send Reply';

  @override
  String get reviewsInbox_sending => 'Sending...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Write your response...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 characters';
  }

  @override
  String get reviewsInbox_replySent => 'Reply sent successfully';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Failed to send reply: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Failed to generate suggestion: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count stars';
  }

  @override
  String get reviewsInbox_totalReviews => 'Total Reviews';

  @override
  String get reviewsInbox_unanswered => 'Unanswered';

  @override
  String get reviewsInbox_positive => 'Positive';

  @override
  String get reviewsInbox_avgRating => 'Avg Rating';

  @override
  String get reviewsInbox_sentimentOverview => 'Sentiment Overview';

  @override
  String get reviewsInbox_aiSuggestions => 'AI Suggested Replies';

  @override
  String get reviewsInbox_regenerate => 'Regenerate';

  @override
  String get reviewsInbox_toneProfessional => 'Professional';

  @override
  String get reviewsInbox_toneEmpathetic => 'Empathetic';

  @override
  String get reviewsInbox_toneBrief => 'Brief';

  @override
  String get reviewsInbox_selectTone => 'Select tone:';

  @override
  String get reviewsInbox_detectedIssues => 'Issues detected:';

  @override
  String get reviewsInbox_aiPrompt =>
      'Click \'Generate AI suggestion\' to get reply suggestions in 3 different tones';

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
  String get funnel_title => 'Conversion Funnel';

  @override
  String get funnel_impressions => 'Impressions';

  @override
  String get funnel_pageViews => 'Page Views';

  @override
  String get funnel_downloads => 'Downloads';

  @override
  String get funnel_overallCvr => 'Overall CVR';

  @override
  String get funnel_categoryAvg => 'Category avg';

  @override
  String get funnel_vsCategory => 'vs category';

  @override
  String get funnel_bySource => 'By Source';

  @override
  String get funnel_noData => 'No funnel data available';

  @override
  String get funnel_noDataHint =>
      'Funnel data will be synced automatically from App Store Connect or Google Play Console.';

  @override
  String get funnel_insight => 'INSIGHT';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return '$bestSource traffic converts ${ratio}x better than $worstSource. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'Focus on keyword optimization to increase Search impressions.';

  @override
  String get funnel_insightRecommendBrowse =>
      'Improve your app\'s visibility in Browse by optimizing categories and featured placement.';

  @override
  String get funnel_insightRecommendReferral =>
      'Leverage referral programs and partnerships to drive more traffic.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      'Consider cross-promotion strategies with complementary apps.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'Optimize your website and landing pages for app downloads.';

  @override
  String get funnel_insightRecommendDefault =>
      'Analyze what makes this source perform well and replicate it.';

  @override
  String get funnel_trendTitle => 'Conversion Rate Trend';

  @override
  String get funnel_connectStore => 'Connect Store';

  @override
  String get nav_chat => 'AI Assistant';

  @override
  String get chat_title => 'AI Assistant';

  @override
  String get chat_newConversation => 'New Chat';

  @override
  String get chat_loadingConversations => 'Loading conversations...';

  @override
  String get chat_loadingMessages => 'Loading messages...';

  @override
  String get chat_noConversations => 'No conversations yet';

  @override
  String get chat_noConversationsDesc =>
      'Start a new conversation to get AI-powered insights about your apps';

  @override
  String get chat_startConversation => 'Start Conversation';

  @override
  String get chat_deleteConversation => 'Delete Conversation';

  @override
  String get chat_deleteConversationConfirm =>
      'Are you sure you want to delete this conversation?';

  @override
  String get chat_askAnything => 'Ask me anything';

  @override
  String get chat_askAnythingDesc =>
      'I can help you understand your app\'s reviews, rankings, and analytics';

  @override
  String get chat_typeMessage => 'Type your question...';

  @override
  String get chat_suggestedQuestions => 'Suggested Questions';

  @override
  String get chatActionConfirm => 'Confirm';

  @override
  String get chatActionCancel => 'Cancel';

  @override
  String get chatActionExecuting => 'Executing...';

  @override
  String get chatActionExecuted => 'Done';

  @override
  String get chatActionFailed => 'Failed';

  @override
  String get chatActionCancelled => 'Cancelled';

  @override
  String get chatActionDownload => 'Download';

  @override
  String get chatActionReversible => 'This action can be undone';

  @override
  String get chatActionAddKeywords => 'Add Keywords to Tracking';

  @override
  String get chatActionRemoveKeywords => 'Remove Keywords';

  @override
  String get chatActionCreateAlert => 'Create Alert Rule';

  @override
  String get chatActionAddCompetitor => 'Add Competitor';

  @override
  String get chatActionExportData => 'Export Data';

  @override
  String get chatActionKeywords => 'Keywords';

  @override
  String get chatActionCountry => 'Country';

  @override
  String get chatActionAlertCondition => 'Condition';

  @override
  String get chatActionNotifyVia => 'Notify via';

  @override
  String get chatActionCompetitor => 'Competitor';

  @override
  String get chatActionExportType => 'Export type';

  @override
  String get chatActionDateRange => 'Date range';

  @override
  String get chatActionKeywordsLabel => 'Keywords';

  @override
  String get chatActionAnalyticsLabel => 'Analytics';

  @override
  String get chatActionReviewsLabel => 'Reviews';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get appDetail_tabOverview => 'Overview';

  @override
  String get appDetail_tabKeywords => 'Keywords';

  @override
  String get appDetail_tabReviews => 'Reviews';

  @override
  String get appDetail_tabRatings => 'Ratings';

  @override
  String get appDetail_tabInsights => 'Insights';

  @override
  String get dateRange_title => 'Date Range';

  @override
  String get dateRange_today => 'Today';

  @override
  String get dateRange_yesterday => 'Yesterday';

  @override
  String get dateRange_last7Days => 'Last 7 Days';

  @override
  String get dateRange_last30Days => 'Last 30 Days';

  @override
  String get dateRange_thisMonth => 'This Month';

  @override
  String get dateRange_lastMonth => 'Last Month';

  @override
  String get dateRange_last90Days => 'Last 90 Days';

  @override
  String get dateRange_yearToDate => 'Year to Date';

  @override
  String get dateRange_allTime => 'All Time';

  @override
  String get dateRange_custom => 'Custom...';

  @override
  String get dateRange_compareToPrevious => 'Compare to previous period';

  @override
  String get export_keywordsTitle => 'Export Keywords';

  @override
  String get export_reviewsTitle => 'Export Reviews';

  @override
  String get export_analyticsTitle => 'Export Analytics';

  @override
  String get export_columnsToInclude => 'Columns to include:';

  @override
  String get export_button => 'Export';

  @override
  String get export_keyword => 'Keyword';

  @override
  String get export_position => 'Position';

  @override
  String get export_change => 'Change';

  @override
  String get export_popularity => 'Popularity';

  @override
  String get export_difficulty => 'Difficulty';

  @override
  String get export_tags => 'Tags';

  @override
  String get export_notes => 'Notes';

  @override
  String get export_trackedSince => 'Tracked Since';

  @override
  String get export_date => 'Date';

  @override
  String get export_rating => 'Rating';

  @override
  String get export_author => 'Author';

  @override
  String get export_title => 'Title';

  @override
  String get export_content => 'Content';

  @override
  String get export_country => 'Country';

  @override
  String get export_version => 'Version';

  @override
  String get export_sentiment => 'Sentiment';

  @override
  String get export_response => 'Our Response';

  @override
  String get export_responseDate => 'Response Date';

  @override
  String export_keywordsCount(int count) {
    return '$count keywords will be exported';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count reviews will be exported';
  }

  @override
  String export_success(String filename) {
    return 'Export saved: $filename';
  }

  @override
  String export_error(String error) {
    return 'Export failed: $error';
  }

  @override
  String get metadata_editor => 'Metadata Editor';

  @override
  String get metadata_selectLocale => 'Select a locale to edit';

  @override
  String get metadata_refreshed => 'Metadata refreshed from store';

  @override
  String get metadata_connectRequired => 'Connect to edit metadata';

  @override
  String get metadata_connectDescription =>
      'Connect your App Store Connect account to edit your app\'s metadata directly from Keyrank.';

  @override
  String get metadata_connectStore => 'Connect App Store';

  @override
  String get metadata_publishTitle => 'Publish Metadata';

  @override
  String metadata_publishConfirm(String locale) {
    return 'Publish changes to $locale? This will update your app\'s listing on the App Store.';
  }

  @override
  String get metadata_publish => 'Publish';

  @override
  String get metadata_publishSuccess => 'Metadata published successfully';

  @override
  String get metadata_saveDraft => 'Save Draft';

  @override
  String get metadata_draftSaved => 'Draft saved';

  @override
  String get metadata_discardChanges => 'Discard Changes';

  @override
  String get metadata_title => 'Title';

  @override
  String metadata_titleHint(int limit) {
    return 'App name (max $limit chars)';
  }

  @override
  String get metadata_subtitle => 'Subtitle';

  @override
  String metadata_subtitleHint(int limit) {
    return 'Brief tagline (max $limit chars)';
  }

  @override
  String get metadata_keywords => 'Keywords';

  @override
  String metadata_keywordsHint(int limit) {
    return 'Comma-separated keywords (max $limit chars)';
  }

  @override
  String get metadata_description => 'Description';

  @override
  String metadata_descriptionHint(int limit) {
    return 'Full app description (max $limit chars)';
  }

  @override
  String get metadata_promotionalText => 'Promotional Text';

  @override
  String metadata_promotionalTextHint(int limit) {
    return 'Short promotional message (max $limit chars)';
  }

  @override
  String get metadata_whatsNew => 'What\'s New';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'Release notes (max $limit chars)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => 'Has unsaved changes';

  @override
  String get metadata_noChanges => 'No changes';

  @override
  String get metadata_keywordAnalysis => 'Keyword Analysis';

  @override
  String get metadata_keywordPresent => 'Present';

  @override
  String get metadata_keywordMissing => 'Missing';

  @override
  String get metadata_inTitle => 'In Title';

  @override
  String get metadata_inSubtitle => 'In Subtitle';

  @override
  String get metadata_inKeywords => 'In Keywords';

  @override
  String get metadata_inDescription => 'In Description';

  @override
  String get metadata_history => 'Change History';

  @override
  String get metadata_noHistory => 'No changes recorded';

  @override
  String get metadata_localeComplete => 'Complete';

  @override
  String get metadata_localeIncomplete => 'Incomplete';

  @override
  String get metadata_shortDescription => 'Short Description';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return 'Brief tagline shown in search (max $limit chars)';
  }

  @override
  String get metadata_fullDescription => 'Full Description';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'Complete app description (max $limit chars)';
  }

  @override
  String get metadata_releaseNotes => 'Release Notes';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'What\'s new in this version (max $limit chars)';
  }

  @override
  String get metadata_selectAppFirst => 'Select an app to edit metadata';

  @override
  String get metadata_selectAppHint =>
      'Use the app selector in the sidebar to choose an app, or connect a store to get started.';

  @override
  String get metadata_noStoreConnection => 'Store connection required';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return 'Connect your $storeName account to fetch and edit your app\'s metadata.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return 'Connect $storeName';
  }

  @override
  String get metadataLocalization => 'Localizations';

  @override
  String get metadataLive => 'Live';

  @override
  String get metadataDraft => 'Draft';

  @override
  String get metadataEmpty => 'Empty';

  @override
  String metadataCoverageInsight(int count) {
    return '$count locales need content. Consider localizing for your top markets.';
  }

  @override
  String get metadataFilterAll => 'All';

  @override
  String get metadataFilterLive => 'Live';

  @override
  String get metadataFilterDraft => 'Drafts';

  @override
  String get metadataFilterEmpty => 'Empty';

  @override
  String get metadataBulkActions => 'Bulk Actions';

  @override
  String get metadataCopyTo => 'Copy to selected';

  @override
  String get metadataTranslateTo => 'Translate to selected';

  @override
  String get metadataPublishSelected => 'Publish selected';

  @override
  String get metadataDeleteDrafts => 'Delete drafts';

  @override
  String get metadataSelectSource => 'Select source locale';

  @override
  String get metadataSelectTarget => 'Select target locales';

  @override
  String metadataCopySuccess(int count) {
    return 'Content copied to $count locales';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return 'Translated to $count locales';
  }

  @override
  String get metadataTranslating => 'Translating...';

  @override
  String get metadataNoSelection => 'Select locales first';

  @override
  String get metadataSelectAll => 'Select all';

  @override
  String get metadataDeselectAll => 'Deselect all';

  @override
  String metadataSelected(int count) {
    return '$count selected';
  }

  @override
  String get metadataTableView => 'Table view';

  @override
  String get metadataListView => 'List view';

  @override
  String get metadataStatus => 'Status';

  @override
  String get metadataCompletion => 'Completion';
}
