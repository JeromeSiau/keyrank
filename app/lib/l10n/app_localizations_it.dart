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
  String get discover_topFree => 'Top Free';

  @override
  String get discover_topPaid => 'Top Paid';

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
  String get nav_discover => 'Discover';

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
  String reviews_version(String version) {
    return 'v$version';
  }
}
