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
  String get common_search => 'Cerca...';

  @override
  String get common_noResults => 'Nessun risultato';

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

  @override
  String get insights_compareTitle => 'Confronta Insights';

  @override
  String get insights_analyzingReviews => 'Analisi delle recensioni...';

  @override
  String get insights_noInsightsAvailable => 'Nessun insight disponibile';

  @override
  String get insights_strengths => 'Punti di forza';

  @override
  String get insights_weaknesses => 'Punti deboli';

  @override
  String get insights_scores => 'Punteggi';

  @override
  String get insights_opportunities => 'Opportunità';

  @override
  String get insights_categoryUx => 'UX';

  @override
  String get insights_categoryPerf => 'Perf';

  @override
  String get insights_categoryFeatures => 'Funzionalità';

  @override
  String get insights_categoryPricing => 'Prezzi';

  @override
  String get insights_categorySupport => 'Supporto';

  @override
  String get insights_categoryOnboard => 'Onboard';

  @override
  String get insights_categoryUxFull => 'UX / Interfaccia';

  @override
  String get insights_categoryPerformance => 'Prestazioni';

  @override
  String get insights_categoryOnboarding => 'Onboarding';

  @override
  String get insights_reviewInsights => 'Insights recensioni';

  @override
  String get insights_generateFirst => 'Prima genera gli insights';

  @override
  String get insights_compareWithOther => 'Confronta con altre app';

  @override
  String get insights_compare => 'Confronta';

  @override
  String get insights_generateAnalysis => 'Genera analisi';

  @override
  String get insights_period => 'Periodo:';

  @override
  String get insights_3months => '3 mesi';

  @override
  String get insights_6months => '6 mesi';

  @override
  String get insights_12months => '12 mesi';

  @override
  String get insights_analyze => 'Analizza';

  @override
  String insights_reviewsCount(int count) {
    return '$count recensioni';
  }

  @override
  String insights_analyzedAgo(String time) {
    return 'Analizzato $time';
  }

  @override
  String get insights_yourNotes => 'Le tue note';

  @override
  String get insights_save => 'Salva';

  @override
  String get insights_clickToAddNotes => 'Clicca per aggiungere note...';

  @override
  String get insights_noteSaved => 'Nota salvata';

  @override
  String get insights_noteHint => 'Aggiungi le tue note su questa analisi...';

  @override
  String get insights_categoryScores => 'Punteggi per categoria';

  @override
  String get insights_emergentThemes => 'Temi emergenti';

  @override
  String get insights_exampleQuotes => 'Citazioni di esempio:';

  @override
  String get insights_selectCountryFirst => 'Seleziona almeno un paese';

  @override
  String compare_selectAppsToCompare(String appName) {
    return 'Seleziona fino a 3 app da confrontare con $appName';
  }

  @override
  String get compare_searchApps => 'Cerca app...';

  @override
  String get compare_noOtherApps => 'Nessun\'altra app da confrontare';

  @override
  String get compare_noMatchingApps => 'Nessuna app corrispondente';

  @override
  String compare_appsSelected(int count) {
    return '$count di 3 app selezionate';
  }

  @override
  String get compare_cancel => 'Annulla';

  @override
  String compare_button(int count) {
    return 'Confronta $count app';
  }

  @override
  String get appDetail_deleteAppTitle => 'Eliminare l\'app?';

  @override
  String get appDetail_deleteAppConfirm =>
      'Questa azione non può essere annullata.';

  @override
  String get appDetail_cancel => 'Annulla';

  @override
  String get appDetail_delete => 'Elimina';

  @override
  String get appDetail_exporting => 'Esportazione classifiche...';

  @override
  String appDetail_savedFile(String filename) {
    return 'Salvato: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Mostra nel Finder';

  @override
  String appDetail_exportFailed(String error) {
    return 'Esportazione fallita: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return 'Importate $imported parole chiave ($skipped saltate)';
  }

  @override
  String get appDetail_favorite => 'Preferito';

  @override
  String get appDetail_ratings => 'Valutazioni';

  @override
  String get appDetail_insights => 'Insights';

  @override
  String get appDetail_import => 'Importa';

  @override
  String get appDetail_export => 'Esporta';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count recensioni';
  }

  @override
  String get appDetail_keywords => 'parole chiave';

  @override
  String get appDetail_addKeyword => 'Aggiungi parola chiave';

  @override
  String get appDetail_keywordHint => 'es. fitness tracker';

  @override
  String get appDetail_trackedKeywords => 'Parole chiave monitorate';

  @override
  String appDetail_selectedCount(int count) {
    return '$count selezionate';
  }

  @override
  String get appDetail_allKeywords => 'Tutte le parole chiave';

  @override
  String get appDetail_hasTags => 'Con tag';

  @override
  String get appDetail_hasNotes => 'Con note';

  @override
  String get appDetail_position => 'Posizione';

  @override
  String get appDetail_select => 'Seleziona';

  @override
  String get appDetail_suggestions => 'Suggerimenti';

  @override
  String get appDetail_deleteKeywordsTitle => 'Elimina parole chiave';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return 'Sei sicuro di voler eliminare $count parole chiave?';
  }

  @override
  String get appDetail_tag => 'Tag';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return 'Parola chiave \"$keyword\" aggiunta ($flag)';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return 'Tag aggiunti a $count parole chiave';
  }

  @override
  String get appDetail_keywordsAddedSuccess =>
      'Parole chiave aggiunte con successo';

  @override
  String get appDetail_noTagsAvailable =>
      'Nessun tag disponibile. Prima crea dei tag.';

  @override
  String get appDetail_tagged => 'Con tag';

  @override
  String get appDetail_withNotes => 'Con note';

  @override
  String get appDetail_nameAZ => 'Nome A-Z';

  @override
  String get appDetail_nameZA => 'Nome Z-A';

  @override
  String get appDetail_bestPosition => 'Miglior posizione';

  @override
  String get appDetail_recentlyTracked => 'Monitorati di recente';

  @override
  String get keywordSuggestions_title => 'Suggerimenti parole chiave';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$appName in $country';
  }

  @override
  String get keywordSuggestions_refresh => 'Aggiorna suggerimenti';

  @override
  String get keywordSuggestions_search => 'Cerca suggerimenti...';

  @override
  String get keywordSuggestions_selectAll => 'Seleziona tutto';

  @override
  String get keywordSuggestions_clear => 'Cancella';

  @override
  String get keywordSuggestions_analyzing => 'Analisi metadati app...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds =>
      'Potrebbero volerci alcuni secondi';

  @override
  String get keywordSuggestions_noSuggestions =>
      'Nessun suggerimento disponibile';

  @override
  String get keywordSuggestions_noMatchingSuggestions =>
      'Nessun suggerimento corrispondente';

  @override
  String get keywordSuggestions_headerKeyword => 'PAROLA CHIAVE';

  @override
  String get keywordSuggestions_headerDifficulty => 'DIFFICOLTÀ';

  @override
  String get keywordSuggestions_headerApps => 'APP';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return 'Posizione #$position';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count parole chiave selezionate';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return 'Aggiungi $count parole chiave';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Errore nell\'aggiunta delle parole chiave: $error';
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
  String get sidebar_favorites => 'PREFERITI';

  @override
  String get sidebar_tooManyFavorites =>
      'Considera di mantenere 5 o meno preferiti';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Ricerca parole chiave';

  @override
  String get keywordSearch_searchPlaceholder => 'Cerca parole chiave...';

  @override
  String get keywordSearch_searchTitle => 'Cerca una parola chiave';

  @override
  String get keywordSearch_searchSubtitle =>
      'Scopri quali app si posizionano per qualsiasi parola chiave';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count app posizionate';
  }

  @override
  String get keywordSearch_popularity => 'Popolarità';

  @override
  String keywordSearch_results(int count) {
    return '$count risultati';
  }

  @override
  String get keywordSearch_headerRank => 'POSIZIONE';

  @override
  String get keywordSearch_headerApp => 'APP';

  @override
  String get keywordSearch_headerRating => 'VALUTAZIONE';

  @override
  String get keywordSearch_headerTrack => 'MONITORA';

  @override
  String get keywordSearch_trackApp => 'Monitora questa app';

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
    return 'Recensioni per $appName';
  }

  @override
  String get reviews_loading => 'Caricamento recensioni...';

  @override
  String get reviews_noReviews => 'Nessuna recensione';

  @override
  String reviews_noReviewsFor(String countryName) {
    return 'Nessuna recensione trovata per $countryName';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'Visualizzazione delle $count recensioni più recenti dall\'App Store.';
  }

  @override
  String get reviews_today => 'Oggi';

  @override
  String get reviews_yesterday => 'Ieri';

  @override
  String reviews_daysAgo(int count) {
    return '$count giorni fa';
  }

  @override
  String reviews_weeksAgo(int count) {
    return '$count settimane fa';
  }

  @override
  String reviews_monthsAgo(int count) {
    return '$count mesi fa';
  }

  @override
  String get ratings_byCountry => 'Valutazioni per paese';

  @override
  String get ratings_noRatingsAvailable => 'Nessuna valutazione disponibile';

  @override
  String get ratings_noRatingsYet => 'Questa app non ha ancora valutazioni';

  @override
  String get ratings_totalRatings => 'Valutazioni totali';

  @override
  String get ratings_averageRating => 'Valutazione media';

  @override
  String ratings_countriesCount(int count) {
    return '$count paesi';
  }

  @override
  String ratings_updated(String date) {
    return 'Aggiornato: $date';
  }

  @override
  String get ratings_headerCountry => 'PAESE';

  @override
  String get ratings_headerRatings => 'VALUTAZIONI';

  @override
  String get ratings_headerAverage => 'MEDIA';

  @override
  String time_minutesAgo(int count) {
    return '${count}m fa';
  }

  @override
  String time_hoursAgo(int count) {
    return '${count}h fa';
  }

  @override
  String time_daysAgo(int count) {
    return '${count}g fa';
  }

  @override
  String get appDetail_noKeywordsTracked => 'Nessuna parola chiave monitorata';

  @override
  String get appDetail_addKeywordHint =>
      'Aggiungi una parola chiave sopra per iniziare il monitoraggio';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Nessuna parola chiave corrisponde al filtro';

  @override
  String get appDetail_tryChangingFilter =>
      'Prova a modificare i criteri del filtro';

  @override
  String get appDetail_addTag => 'Aggiungi tag';

  @override
  String get appDetail_addNote => 'Aggiungi nota';

  @override
  String get appDetail_positionHistory => 'Storico posizioni';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => 'PANORAMICA';

  @override
  String get nav_dashboard => 'Dashboard';

  @override
  String get nav_myApps => 'Le mie App';

  @override
  String get nav_research => 'RICERCA';

  @override
  String get nav_keywords => 'Parole chiave';

  @override
  String get nav_discover => 'Scopri';

  @override
  String get nav_engagement => 'ENGAGEMENT';

  @override
  String get nav_reviewsInbox => 'Reviews Inbox';

  @override
  String get nav_notifications => 'Avvisi';

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
  String get common_save => 'Salva';

  @override
  String get appDetail_manageTags => 'Gestisci tag';

  @override
  String get appDetail_newTagHint => 'Nome nuovo tag...';

  @override
  String get appDetail_availableTags => 'Tag disponibili';

  @override
  String get appDetail_noTagsYet => 'Nessun tag ancora. Creane uno sopra.';

  @override
  String get appDetail_addTagsTitle => 'Aggiungi tag';

  @override
  String get appDetail_selectTagsDescription =>
      'Seleziona i tag da aggiungere alle parole chiave:';

  @override
  String appDetail_addTagsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tag',
      one: 'tag',
    );
    return 'Aggiungi $count $_temp0';
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
    return 'Importazione fallita: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Importa parole chiave';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Incolla le parole chiave sotto, una per riga:';

  @override
  String get appDetail_keywordPlaceholder =>
      'parola chiave uno\nparola chiave due\nparola chiave tre';

  @override
  String get appDetail_storefront => 'Storefront:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count parole chiave';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return 'Importa $count parole chiave';
  }

  @override
  String get appDetail_period7d => '7g';

  @override
  String get appDetail_period30d => '30g';

  @override
  String get appDetail_period90d => '90g';

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
  String get notifications_title => 'Notifiche';

  @override
  String get notifications_markAllRead => 'Segna tutto come letto';

  @override
  String get notifications_empty => 'Nessuna notifica ancora';

  @override
  String get alerts_title => 'Regole di avviso';

  @override
  String get alerts_templatesTitle => 'Modelli rapidi';

  @override
  String get alerts_templatesSubtitle => 'Attiva avvisi comuni con un tocco';

  @override
  String get alerts_myRulesTitle => 'Le mie regole';

  @override
  String get alerts_createRule => 'Crea regola';

  @override
  String get alerts_editRule => 'Modifica regola';

  @override
  String get alerts_noRulesYet => 'Nessuna regola ancora';

  @override
  String get alerts_deleteConfirm => 'Eliminare la regola?';

  @override
  String get settings_notifications => 'NOTIFICHE';

  @override
  String get settings_manageAlerts => 'Gestisci regole di avviso';

  @override
  String get settings_manageAlertsDesc => 'Configura quali avvisi ricevi';

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
  String get reviewIntelligence_title => 'Review Intelligence';

  @override
  String get reviewIntelligence_featureRequests => 'Feature Requests';

  @override
  String get reviewIntelligence_bugReports => 'Bug Reports';

  @override
  String get reviewIntelligence_sentimentByVersion => 'Sentiment by Version';

  @override
  String get reviewIntelligence_openFeatures => 'Open Features';

  @override
  String get reviewIntelligence_openBugs => 'Open Bugs';

  @override
  String get reviewIntelligence_highPriority => 'High Priority';

  @override
  String get reviewIntelligence_total => 'total';

  @override
  String get reviewIntelligence_mentions => 'mentions';

  @override
  String get reviewIntelligence_noData => 'No insights yet';

  @override
  String get reviewIntelligence_noDataHint =>
      'Insights will appear after reviews are analyzed';

  @override
  String get analytics_title => 'Analisi';

  @override
  String get analytics_downloads => 'Download';

  @override
  String get analytics_revenue => 'Ricavi';

  @override
  String get analytics_proceeds => 'Proventi';

  @override
  String get analytics_subscribers => 'Abbonati';

  @override
  String get analytics_downloadsOverTime => 'Download nel tempo';

  @override
  String get analytics_revenueOverTime => 'Ricavi nel tempo';

  @override
  String get analytics_byCountry => 'Per paese';

  @override
  String get analytics_noData => 'Nessun dato disponibile';

  @override
  String get analytics_noDataTitle => 'Nessun dato analitico';

  @override
  String get analytics_noDataDescription =>
      'Collega il tuo account App Store Connect o Google Play per vedere i dati reali di vendite e download.';

  @override
  String analytics_dataDelay(String date) {
    return 'Dati al $date. I dati Apple hanno un ritardo di 24-48h.';
  }

  @override
  String get analytics_export => 'Esporta CSV';

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
