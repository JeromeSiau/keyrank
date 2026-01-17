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
  String get auth_signInSubtitle => 'Accedi al Suo account';

  @override
  String get auth_createAccount => 'Crea account';

  @override
  String get auth_createAccountSubtitle =>
      'Inizi a monitorare le Sue classifiche';

  @override
  String get auth_emailLabel => 'E-mail';

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
  String get auth_noAccount => 'Non ha un account?';

  @override
  String get auth_hasAccount => 'Ha già un account?';

  @override
  String get auth_signUpLink => 'Registrati';

  @override
  String get auth_signInLink => 'Accedi';

  @override
  String get auth_emailRequired => 'Inserisca la Sua e-mail';

  @override
  String get auth_emailInvalid => 'E-mail non valida';

  @override
  String get auth_passwordRequired => 'Inserisca la Sua password';

  @override
  String get auth_enterPassword => 'Inserisca una password';

  @override
  String get auth_nameRequired => 'Inserisca il Suo nome';

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
      'Aggiunga un\'app per iniziare a monitorare le parole chiave';

  @override
  String get dashboard_noAppsMatchFilter => 'Nessuna app corrisponde al filtro';

  @override
  String get dashboard_changeFilterCriteria =>
      'Provi a modificare i criteri del filtro';

  @override
  String get dashboard_reviews => 'Recensioni';

  @override
  String get dashboard_avgRating => 'Valutazione media';

  @override
  String get dashboard_topPerformingApps => 'App con le migliori performance';

  @override
  String get dashboard_topCountries => 'Principali paesi';

  @override
  String get dashboard_sentimentOverview => 'Panoramica del sentiment';

  @override
  String get dashboard_overallSentiment => 'Sentiment generale';

  @override
  String get dashboard_positive => 'Positivo';

  @override
  String get dashboard_positiveReviews => 'Positivo';

  @override
  String get dashboard_negativeReviews => 'Negativo';

  @override
  String get dashboard_viewReviews => 'Visualizza recensioni';

  @override
  String get dashboard_tableApp => 'APP';

  @override
  String get dashboard_tableKeywords => 'PAROLE CHIAVE';

  @override
  String get dashboard_tableAvgRank => 'POS. MEDIA';

  @override
  String get dashboard_tableTrend => 'TENDENZA';

  @override
  String get dashboard_connectYourStores => 'Collega i Suoi store';

  @override
  String get dashboard_connectStoresDescription =>
      'Colleghi App Store Connect o Google Play per importare le Sue app e rispondere alle recensioni.';

  @override
  String get dashboard_connect => 'Collega';

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
      'Aggiunga un\'app per iniziare a monitorare le sue classifiche';

  @override
  String get addApp_title => 'Aggiungi App';

  @override
  String get addApp_searchAppStore => 'Cerca nell\'App Store...';

  @override
  String get addApp_searchPlayStore => 'Cerca nel Play Store...';

  @override
  String get addApp_searchForApp => 'Cerca un\'app';

  @override
  String get addApp_enterAtLeast2Chars => 'Inserisca almeno 2 caratteri';

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
  String get filter_all => 'Tutto';

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
  String get insights_compareTitle => 'Confronta analisi';

  @override
  String get insights_analyzingReviews =>
      'Analisi delle recensioni in corso...';

  @override
  String get insights_noInsightsAvailable => 'Nessuna analisi disponibile';

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
  String get insights_reviewInsights => 'Analisi delle recensioni';

  @override
  String get insights_generateFirst => 'Prima generi le analisi';

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
  String get insights_yourNotes => 'Le Sue note';

  @override
  String get insights_save => 'Salva';

  @override
  String get insights_clickToAddNotes => 'Clicchi per aggiungere note...';

  @override
  String get insights_noteSaved => 'Nota salvata';

  @override
  String get insights_noteHint => 'Aggiunga le Sue note su questa analisi...';

  @override
  String get insights_categoryScores => 'Punteggi per categoria';

  @override
  String get insights_emergentThemes => 'Temi emergenti';

  @override
  String get insights_exampleQuotes => 'Citazioni di esempio:';

  @override
  String get insights_selectCountryFirst => 'Selezioni almeno un paese';

  @override
  String get insights_title => 'Analisi';

  @override
  String insights_titleWithApp(String appName) {
    return 'Analisi - $appName';
  }

  @override
  String get insights_allApps => 'Analisi (Tutte le app)';

  @override
  String get insights_noInsightsYet => 'Nessun insight ancora';

  @override
  String get insights_selectAppToGenerate =>
      'Selezioni un\'app per generare analisi dalle recensioni';

  @override
  String insights_appsWithInsights(int count) {
    return '$count app con analisi';
  }

  @override
  String get insights_errorLoading => 'Errore nel caricamento delle analisi';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '$count recensioni analizzate';
  }

  @override
  String get insights_avgScore => 'punteggio medio';

  @override
  String insights_updatedOn(String date) {
    return 'Aggiornato il $date';
  }

  @override
  String compare_selectAppsToCompare(String appName) {
    return 'Selezioni fino a 3 app da confrontare con $appName';
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
    return '$imported parole chiave importate ($skipped ignorate)';
  }

  @override
  String get appDetail_favorite => 'Preferito';

  @override
  String get appDetail_ratings => 'Valutazioni';

  @override
  String get appDetail_insights => 'Analisi';

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
    return 'È sicuro di voler eliminare $count parole chiave?';
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
      'Nessun tag disponibile. Prima crei dei tag.';

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
  String get keywordSuggestions_categoryAll => 'Tutto';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'Opportunità';

  @override
  String get keywordSuggestions_categoryCompetitor =>
      'Parole chiave concorrenti';

  @override
  String get keywordSuggestions_categoryLongTail => 'Long-tail';

  @override
  String get keywordSuggestions_categoryTrending => 'Tendenze';

  @override
  String get keywordSuggestions_categoryRelated => 'Correlate';

  @override
  String get keywordSuggestions_generating => 'Generazione suggerimenti...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      'Potrebbero volerci alcuni minuti. Torni più tardi.';

  @override
  String get keywordSuggestions_checkAgain => 'Verifica di nuovo';

  @override
  String get sidebar_favorites => 'PREFERITI';

  @override
  String get sidebar_tooManyFavorites =>
      'Consideri di mantenere 5 o meno preferiti';

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
      'Scopra quali app si posizionano per una parola chiave';

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
  String get discover_title => 'Scopri';

  @override
  String get discover_tabKeywords => 'Parole chiave';

  @override
  String get discover_tabCategories => 'Categorie';

  @override
  String get discover_selectCategory => 'Seleziona una categoria';

  @override
  String get discover_topFree => 'Gratuite';

  @override
  String get discover_topPaid => 'A pagamento';

  @override
  String get discover_topGrossing => 'Maggiori incassi';

  @override
  String get discover_noResults => 'Nessun risultato';

  @override
  String get discover_loadingTopApps => 'Caricamento top app...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return 'Top $collection in $category';
  }

  @override
  String discover_appsCount(int count) {
    return '$count app';
  }

  @override
  String get discover_allCategories => 'Tutte le categorie';

  @override
  String get category_games => 'Giochi';

  @override
  String get category_business => 'Affari';

  @override
  String get category_education => 'Istruzione';

  @override
  String get category_entertainment => 'Intrattenimento';

  @override
  String get category_finance => 'Finanza';

  @override
  String get category_food_drink => 'Cibo e bevande';

  @override
  String get category_health_fitness => 'Salute e fitness';

  @override
  String get category_lifestyle => 'Lifestyle';

  @override
  String get category_medical => 'Medicina';

  @override
  String get category_music => 'Musica';

  @override
  String get category_navigation => 'Navigazione';

  @override
  String get category_news => 'Notizie';

  @override
  String get category_photo_video => 'Foto e video';

  @override
  String get category_productivity => 'Produttività';

  @override
  String get category_reference => 'Consultazione';

  @override
  String get category_shopping => 'Shopping';

  @override
  String get category_social => 'Social network';

  @override
  String get category_sports => 'Sport';

  @override
  String get category_travel => 'Viaggi';

  @override
  String get category_utilities => 'Utility';

  @override
  String get category_weather => 'Meteo';

  @override
  String get category_books => 'Libri';

  @override
  String get category_developer_tools => 'Strumenti per sviluppatori';

  @override
  String get category_graphics_design => 'Grafica e design';

  @override
  String get category_magazines => 'Riviste e giornali';

  @override
  String get category_stickers => 'Sticker';

  @override
  String get category_catalogs => 'Cataloghi';

  @override
  String get category_art_design => 'Arte e design';

  @override
  String get category_auto_vehicles => 'Auto e veicoli';

  @override
  String get category_beauty => 'Bellezza';

  @override
  String get category_comics => 'Fumetti';

  @override
  String get category_communication => 'Comunicazione';

  @override
  String get category_dating => 'Incontri';

  @override
  String get category_events => 'Eventi';

  @override
  String get category_house_home => 'Casa';

  @override
  String get category_libraries => 'Biblioteche';

  @override
  String get category_maps_navigation => 'Mappe e navigazione';

  @override
  String get category_music_audio => 'Musica e audio';

  @override
  String get category_news_magazines => 'Notizie e riviste';

  @override
  String get category_parenting => 'Genitori';

  @override
  String get category_personalization => 'Personalizzazione';

  @override
  String get category_photography => 'Fotografia';

  @override
  String get category_tools => 'Strumenti';

  @override
  String get category_video_players => 'Lettori video';

  @override
  String get category_all_apps => 'Tutte le app';

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
      'Aggiunga una parola chiave sopra per iniziare il monitoraggio';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Nessuna parola chiave corrisponde al filtro';

  @override
  String get appDetail_tryChangingFilter =>
      'Provi a modificare i criteri del filtro';

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
  String get nav_reviewsInbox => 'Posta in arrivo';

  @override
  String get nav_notifications => 'Avvisi';

  @override
  String get nav_optimization => 'OTTIMIZZAZIONE';

  @override
  String get nav_keywordInspector => 'Ispettore parole chiave';

  @override
  String get nav_ratingsAnalysis => 'Analisi valutazioni';

  @override
  String get nav_intelligence => 'INTELLIGENCE';

  @override
  String get nav_topCharts => 'Top Charts';

  @override
  String get nav_competitors => 'Concorrenti';

  @override
  String get common_save => 'Salva';

  @override
  String get appDetail_manageTags => 'Gestisci tag';

  @override
  String get appDetail_newTagHint => 'Nome nuovo tag...';

  @override
  String get appDetail_availableTags => 'Tag disponibili';

  @override
  String get appDetail_noTagsYet => 'Nessun tag ancora. Ne crei uno sopra.';

  @override
  String get appDetail_addTagsTitle => 'Aggiungi tag';

  @override
  String get appDetail_selectTagsDescription =>
      'Selezioni i tag da aggiungere alle parole chiave selezionate:';

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
  String get appDetail_currentTags => 'Tag attuali';

  @override
  String get appDetail_noTagsOnKeyword => 'Nessun tag su questa parola chiave';

  @override
  String get appDetail_addExistingTag => 'Aggiungi un tag esistente';

  @override
  String get appDetail_allTagsUsed => 'Tutti i tag sono già utilizzati';

  @override
  String get appDetail_createNewTag => 'Crea nuovo tag';

  @override
  String get appDetail_tagNameHint => 'Nome del tag...';

  @override
  String get appDetail_note => 'Nota';

  @override
  String get appDetail_noteHint =>
      'Aggiunga una nota su questa parola chiave...';

  @override
  String get appDetail_saveNote => 'Salva nota';

  @override
  String get appDetail_done => 'Fatto';

  @override
  String appDetail_importFailed(String error) {
    return 'Importazione fallita: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Importa parole chiave';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Incolli le parole chiave qui sotto, una per riga:';

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
  String get keywords_difficultyFilter => 'Difficoltà:';

  @override
  String get keywords_difficultyAll => 'Tutte';

  @override
  String get keywords_difficultyEasy => 'Facile < 40';

  @override
  String get keywords_difficultyMedium => 'Media 40-70';

  @override
  String get keywords_difficultyHard => 'Difficile > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'Dettagli app';

  @override
  String get appPreview_notFound => 'Applicazione non trovata';

  @override
  String get appPreview_screenshots => 'Screenshot';

  @override
  String get appPreview_description => 'Descrizione';

  @override
  String get appPreview_details => 'Dettagli';

  @override
  String get appPreview_version => 'Versione';

  @override
  String get appPreview_updated => 'Aggiornamento';

  @override
  String get appPreview_released => 'Rilascio';

  @override
  String get appPreview_size => 'Dimensione';

  @override
  String get appPreview_minimumOs => 'Requisiti';

  @override
  String get appPreview_price => 'Prezzo';

  @override
  String get appPreview_free => 'Gratis';

  @override
  String get appPreview_openInStore => 'Apri nello Store';

  @override
  String get appPreview_addToMyApps => 'Aggiungi alle mie app';

  @override
  String get appPreview_added => 'Aggiunta';

  @override
  String get appPreview_showMore => 'Mostra di più';

  @override
  String get appPreview_showLess => 'Mostra meno';

  @override
  String get appPreview_keywordsPlaceholder =>
      'Aggiunga questa app alle Sue app monitorate per attivare il monitoraggio delle parole chiave';

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
  String get alerts_templatesSubtitle => 'Attivi avvisi comuni con un tocco';

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
  String get alerts_createCustomRule => 'Crea regola personalizzata';

  @override
  String alerts_ruleActivated(String name) {
    return '$name attivato!';
  }

  @override
  String alerts_deleteMessage(String name) {
    return 'Questo eliminerà \"$name\".';
  }

  @override
  String get alerts_noRulesDescription => 'Attiva un modello o crea il tuo!';

  @override
  String get alerts_create => 'Crea';

  @override
  String get settings_notifications => 'NOTIFICHE';

  @override
  String get settings_manageAlerts => 'Gestisci regole di avviso';

  @override
  String get settings_manageAlertsDesc => 'Configuri quali avvisi ricevere';

  @override
  String get settings_storeConnections => 'Connessioni store';

  @override
  String get settings_storeConnectionsDesc =>
      'Colleghi i Suoi account App Store e Google Play';

  @override
  String get settings_alertDelivery => 'CONSEGNA AVVISI';

  @override
  String get settings_team => 'TEAM';

  @override
  String get settings_teamManagement => 'Gestione team';

  @override
  String get settings_teamManagementDesc =>
      'Invite members, manage roles & permissions';

  @override
  String get settings_integrations => 'Integrazioni';

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
  String get storeConnections_title => 'Connessioni agli store';

  @override
  String get storeConnections_description =>
      'Colleghi i Suoi account App Store e Google Play per abilitare funzionalità avanzate come i dati di vendita e le analisi delle app.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Colleghi il Suo account sviluppatore Apple';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Colleghi il Suo account Google Play';

  @override
  String get storeConnections_connect => 'Collega';

  @override
  String get storeConnections_disconnect => 'Scollega';

  @override
  String get storeConnections_connected => 'Collegato';

  @override
  String get storeConnections_disconnectConfirm => 'Scollegare?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'È sicuro di voler scollegare questo account $platform?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Scollegato con successo';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Ultima sincronizzazione: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return 'Collegato il $date';
  }

  @override
  String get storeConnections_syncApps => 'Sincronizza app';

  @override
  String get storeConnections_syncing => 'Sincronizzazione...';

  @override
  String get storeConnections_syncDescription =>
      'La sincronizzazione contrassegnerà le tue app come di proprietà, abilitando le risposte alle recensioni.';

  @override
  String storeConnections_syncedApps(int count) {
    return '$count app sincronizzate come di proprietà';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return 'Sincronizzazione fallita: $error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return 'Errore caricamento connessioni: $error';
  }

  @override
  String get reviewsInbox_title => 'Posta in arrivo';

  @override
  String get reviewsInbox_filterUnanswered => 'Senza risposta';

  @override
  String get reviewsInbox_filterNegative => 'Negativo';

  @override
  String get reviewsInbox_noReviews => 'Nessuna recensione trovata';

  @override
  String get reviewsInbox_noReviewsDesc => 'Provi a modificare i filtri';

  @override
  String get reviewsInbox_reply => 'Rispondi';

  @override
  String get reviewsInbox_responded => 'Risposta';

  @override
  String reviewsInbox_respondedAt(String date) {
    return 'Risposta il $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Rispondi alla recensione';

  @override
  String get reviewsInbox_generateAi => 'Genera suggerimento IA';

  @override
  String get reviewsInbox_generating => 'Generazione...';

  @override
  String get reviewsInbox_sendReply => 'Invia risposta';

  @override
  String get reviewsInbox_sending => 'Invio...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Scriva la Sua risposta...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 caratteri';
  }

  @override
  String get reviewsInbox_replySent => 'Risposta inviata con successo';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Invio risposta fallito: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Generazione suggerimento fallita: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count stelle';
  }

  @override
  String get reviewsInbox_totalReviews => 'Recensioni totali';

  @override
  String get reviewsInbox_unanswered => 'Senza risposta';

  @override
  String get reviewsInbox_positive => 'Positive';

  @override
  String get reviewsInbox_avgRating => 'Valutazione media';

  @override
  String get reviewsInbox_sentimentOverview => 'Panoramica sentiment';

  @override
  String get reviewsInbox_aiSuggestions => 'Suggerimenti IA';

  @override
  String get reviewsInbox_regenerate => 'Rigenera';

  @override
  String get reviewsInbox_toneProfessional => 'Professionale';

  @override
  String get reviewsInbox_toneEmpathetic => 'Empatico';

  @override
  String get reviewsInbox_toneBrief => 'Breve';

  @override
  String get reviewsInbox_selectTone => 'Selezioni il tono:';

  @override
  String get reviewsInbox_detectedIssues => 'Problemi rilevati:';

  @override
  String get reviewsInbox_aiPrompt =>
      'Clicchi su \'Genera suggerimento IA\' per ottenere suggerimenti di risposta in 3 toni diversi';

  @override
  String get reviewIntelligence_title => 'Intelligence recensioni';

  @override
  String get reviewIntelligence_featureRequests => 'Richieste di funzionalità';

  @override
  String get reviewIntelligence_bugReports => 'Segnalazioni di bug';

  @override
  String get reviewIntelligence_sentimentByVersion => 'Sentiment per versione';

  @override
  String get reviewIntelligence_openFeatures => 'Funzionalità aperte';

  @override
  String get reviewIntelligence_openBugs => 'Bug aperti';

  @override
  String get reviewIntelligence_highPriority => 'Alta priorità';

  @override
  String get reviewIntelligence_total => 'totale';

  @override
  String get reviewIntelligence_mentions => 'menzioni';

  @override
  String get reviewIntelligence_noData => 'Nessun insight ancora';

  @override
  String get reviewIntelligence_noDataHint =>
      'Gli insight appariranno dopo l\'analisi delle recensioni';

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
      'Colleghi il Suo account App Store Connect o Google Play per vedere i dati reali di vendite e download.';

  @override
  String analytics_dataDelay(String date) {
    return 'Dati al $date. I dati Apple hanno un ritardo di 24-48h.';
  }

  @override
  String get analytics_export => 'Esporta CSV';

  @override
  String get funnel_title => 'Funnel di conversione';

  @override
  String get funnel_impressions => 'Impressioni';

  @override
  String get funnel_pageViews => 'Visualizzazioni pagina';

  @override
  String get funnel_downloads => 'Download';

  @override
  String get funnel_overallCvr => 'CVR complessivo';

  @override
  String get funnel_categoryAvg => 'Media categoria';

  @override
  String get funnel_vsCategory => 'vs categoria';

  @override
  String get funnel_bySource => 'Per fonte';

  @override
  String get funnel_noData => 'Nessun dato del funnel disponibile';

  @override
  String get funnel_noDataHint =>
      'I dati del funnel verranno sincronizzati automaticamente da App Store Connect o Google Play Console.';

  @override
  String get funnel_insight => 'INSIGHT';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return 'Il traffico $bestSource converte ${ratio}x meglio di $worstSource. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'Si concentri sull\'ottimizzazione delle parole chiave per aumentare le impressioni di ricerca.';

  @override
  String get funnel_insightRecommendBrowse =>
      'Migliori la visibilità della Sua app nella navigazione ottimizzando le categorie e il posizionamento in evidenza.';

  @override
  String get funnel_insightRecommendReferral =>
      'Sfrutti i programmi di referral e le partnership per generare più traffico.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      'Consideri strategie di promozione incrociata con app complementari.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'Ottimizzi il Suo sito web e le landing page per i download.';

  @override
  String get funnel_insightRecommendDefault =>
      'Analizzi cosa rende questa fonte performante e la replichi.';

  @override
  String get funnel_trendTitle => 'Tendenza del tasso di conversione';

  @override
  String get funnel_connectStore => 'Collega store';

  @override
  String get nav_chat => 'Assistente IA';

  @override
  String get chat_title => 'Assistente IA';

  @override
  String get chat_newConversation => 'Nuova conversazione';

  @override
  String get chat_loadingConversations => 'Caricamento conversazioni...';

  @override
  String get chat_loadingMessages => 'Caricamento messaggi...';

  @override
  String get chat_noConversations => 'Nessuna conversazione';

  @override
  String get chat_noConversationsDesc =>
      'Avvii una nuova conversazione per ottenere insight IA sulle Sue app';

  @override
  String get chat_startConversation => 'Avvia una conversazione';

  @override
  String get chat_deleteConversation => 'Elimina conversazione';

  @override
  String get chat_deleteConversationConfirm =>
      'È sicuro di voler eliminare questa conversazione?';

  @override
  String get chat_askAnything => 'Mi faccia una domanda';

  @override
  String get chat_askAnythingDesc =>
      'Posso aiutarLa a comprendere le recensioni, le classifiche e le analisi della Sua app';

  @override
  String get chat_typeMessage => 'Scriva la Sua domanda...';

  @override
  String get chat_suggestedQuestions => 'Domande suggerite';

  @override
  String get chatActionConfirm => 'Conferma';

  @override
  String get chatActionCancel => 'Annulla';

  @override
  String get chatActionExecuting => 'Esecuzione...';

  @override
  String get chatActionExecuted => 'Completato';

  @override
  String get chatActionFailed => 'Fallito';

  @override
  String get chatActionCancelled => 'Annullato';

  @override
  String get chatActionDownload => 'Scarica';

  @override
  String get chatActionReversible => 'Questa azione può essere annullata';

  @override
  String get chatActionAddKeywords => 'Aggiungi parole chiave';

  @override
  String get chatActionRemoveKeywords => 'Rimuovi parole chiave';

  @override
  String get chatActionCreateAlert => 'Crea avviso';

  @override
  String get chatActionAddCompetitor => 'Aggiungi concorrente';

  @override
  String get chatActionExportData => 'Esporta dati';

  @override
  String get chatActionKeywords => 'Parole chiave';

  @override
  String get chatActionCountry => 'Paese';

  @override
  String get chatActionAlertCondition => 'Condizione';

  @override
  String get chatActionNotifyVia => 'Notifica tramite';

  @override
  String get chatActionCompetitor => 'Concorrente';

  @override
  String get chatActionExportType => 'Tipo di esportazione';

  @override
  String get chatActionDateRange => 'Periodo';

  @override
  String get chatActionKeywordsLabel => 'Parole chiave';

  @override
  String get chatActionAnalyticsLabel => 'Statistiche';

  @override
  String get chatActionReviewsLabel => 'Recensioni';

  @override
  String get common_cancel => 'Annulla';

  @override
  String get common_delete => 'Elimina';

  @override
  String get appDetail_tabOverview => 'Panoramica';

  @override
  String get appDetail_tabKeywords => 'Parole chiave';

  @override
  String get appDetail_tabReviews => 'Recensioni';

  @override
  String get appDetail_tabRatings => 'Valutazioni';

  @override
  String get appDetail_tabInsights => 'Analisi';

  @override
  String get dateRange_title => 'Periodo';

  @override
  String get dateRange_today => 'Oggi';

  @override
  String get dateRange_yesterday => 'Ieri';

  @override
  String get dateRange_last7Days => 'Ultimi 7 giorni';

  @override
  String get dateRange_last30Days => 'Ultimi 30 giorni';

  @override
  String get dateRange_thisMonth => 'Questo mese';

  @override
  String get dateRange_lastMonth => 'Mese scorso';

  @override
  String get dateRange_last90Days => 'Ultimi 90 giorni';

  @override
  String get dateRange_yearToDate => 'Dall\'inizio dell\'anno';

  @override
  String get dateRange_allTime => 'Tutto';

  @override
  String get dateRange_custom => 'Personalizzato...';

  @override
  String get dateRange_compareToPrevious =>
      'Confronta con il periodo precedente';

  @override
  String get export_keywordsTitle => 'Esporta parole chiave';

  @override
  String get export_reviewsTitle => 'Esporta recensioni';

  @override
  String get export_analyticsTitle => 'Esporta analisi';

  @override
  String get export_columnsToInclude => 'Colonne da includere:';

  @override
  String get export_button => 'Esporta';

  @override
  String get export_keyword => 'Parola chiave';

  @override
  String get export_position => 'Posizione';

  @override
  String get export_change => 'Variazione';

  @override
  String get export_popularity => 'Popolarità';

  @override
  String get export_difficulty => 'Difficoltà';

  @override
  String get export_tags => 'Tag';

  @override
  String get export_notes => 'Note';

  @override
  String get export_trackedSince => 'Monitorata dal';

  @override
  String get export_date => 'Data';

  @override
  String get export_rating => 'Valutazione';

  @override
  String get export_author => 'Autore';

  @override
  String get export_title => 'Titolo';

  @override
  String get export_content => 'Contenuto';

  @override
  String get export_country => 'Paese';

  @override
  String get export_version => 'Versione';

  @override
  String get export_sentiment => 'Sentiment';

  @override
  String get export_response => 'La nostra risposta';

  @override
  String get export_responseDate => 'Data risposta';

  @override
  String export_keywordsCount(int count) {
    return '$count parole chiave verranno esportate';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count recensioni verranno esportate';
  }

  @override
  String export_success(String filename) {
    return 'Esportazione salvata: $filename';
  }

  @override
  String export_error(String error) {
    return 'Esportazione fallita: $error';
  }

  @override
  String get metadata_editor => 'Editor metadati';

  @override
  String get metadata_selectLocale => 'Selezioni una lingua da modificare';

  @override
  String get metadata_refreshed => 'Metadati aggiornati dallo store';

  @override
  String get metadata_connectRequired => 'Connessione richiesta per modificare';

  @override
  String get metadata_connectDescription =>
      'Colleghi il Suo account App Store Connect per modificare i metadati della Sua app direttamente da Keyrank.';

  @override
  String get metadata_connectStore => 'Collega App Store';

  @override
  String get metadata_publishTitle => 'Pubblica metadati';

  @override
  String metadata_publishConfirm(String locale) {
    return 'Pubblicare le modifiche per $locale? Questo aggiornerà la scheda della Sua app sull\'App Store.';
  }

  @override
  String get metadata_publish => 'Pubblica';

  @override
  String get metadata_publishSuccess => 'Metadati pubblicati con successo';

  @override
  String get metadata_saveDraft => 'Salva bozza';

  @override
  String get metadata_draftSaved => 'Bozza salvata';

  @override
  String get metadata_discardChanges => 'Annulla modifiche';

  @override
  String get metadata_title => 'Titolo';

  @override
  String metadata_titleHint(int limit) {
    return 'Nome dell\'app (max $limit car.)';
  }

  @override
  String get metadata_subtitle => 'Sottotitolo';

  @override
  String metadata_subtitleHint(int limit) {
    return 'Slogan breve (max $limit car.)';
  }

  @override
  String get metadata_keywords => 'Parole chiave';

  @override
  String metadata_keywordsHint(int limit) {
    return 'Parole chiave separate da virgole (max $limit car.)';
  }

  @override
  String get metadata_description => 'Descrizione';

  @override
  String metadata_descriptionHint(int limit) {
    return 'Descrizione completa dell\'app (max $limit car.)';
  }

  @override
  String get metadata_promotionalText => 'Testo promozionale';

  @override
  String metadata_promotionalTextHint(int limit) {
    return 'Messaggio promozionale breve (max $limit car.)';
  }

  @override
  String get metadata_whatsNew => 'Novità';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'Note di versione (max $limit car.)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => 'Modifiche non salvate';

  @override
  String get metadata_noChanges => 'Nessuna modifica';

  @override
  String get metadata_keywordAnalysis => 'Analisi parole chiave';

  @override
  String get metadata_keywordPresent => 'Presente';

  @override
  String get metadata_keywordMissing => 'Mancante';

  @override
  String get metadata_inTitle => 'Nel titolo';

  @override
  String get metadata_inSubtitle => 'Nel sottotitolo';

  @override
  String get metadata_inKeywords => 'Nelle parole chiave';

  @override
  String get metadata_inDescription => 'Nella descrizione';

  @override
  String get metadata_history => 'Cronologia modifiche';

  @override
  String get metadata_noHistory => 'Nessuna modifica registrata';

  @override
  String get metadata_localeComplete => 'Completo';

  @override
  String get metadata_localeIncomplete => 'Incompleto';

  @override
  String get metadata_shortDescription => 'Descrizione breve';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return 'Slogan visualizzato nella ricerca (max $limit car.)';
  }

  @override
  String get metadata_fullDescription => 'Descrizione completa';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'Descrizione completa dell\'app (max $limit car.)';
  }

  @override
  String get metadata_releaseNotes => 'Note di versione';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'Novità di questa versione (max $limit car.)';
  }

  @override
  String get metadata_selectAppFirst => 'Selezioni un\'applicazione';

  @override
  String get metadata_selectAppHint =>
      'Utilizzi il selettore app nella barra laterale o colleghi uno store per iniziare.';

  @override
  String get metadata_noStoreConnection => 'Connessione allo store richiesta';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return 'Colleghi il Suo account $storeName per recuperare e modificare i metadati della Sua app.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return 'Collega $storeName';
  }

  @override
  String get metadataLocalization => 'Localizzazioni';

  @override
  String get metadataLive => 'Online';

  @override
  String get metadataDraft => 'Bozza';

  @override
  String get metadataEmpty => 'Vuoto';

  @override
  String metadataCoverageInsight(int count) {
    return '$count lingue necessitano di contenuti. Consideri la localizzazione per i Suoi mercati principali.';
  }

  @override
  String get metadataFilterAll => 'Tutti';

  @override
  String get metadataFilterLive => 'Online';

  @override
  String get metadataFilterDraft => 'Bozze';

  @override
  String get metadataFilterEmpty => 'Vuoti';

  @override
  String get metadataBulkActions => 'Azioni di gruppo';

  @override
  String get metadataCopyTo => 'Copia nella selezione';

  @override
  String get metadataTranslateTo => 'Traduci nella selezione';

  @override
  String get metadataPublishSelected => 'Pubblica selezione';

  @override
  String get metadataDeleteDrafts => 'Elimina bozze';

  @override
  String get metadataSelectSource => 'Seleziona lingua di origine';

  @override
  String get metadataSelectTarget => 'Seleziona lingue di destinazione';

  @override
  String metadataCopySuccess(int count) {
    return 'Contenuto copiato in $count lingue';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return 'Tradotto in $count lingue';
  }

  @override
  String get metadataTranslating => 'Traduzione in corso...';

  @override
  String get metadataNoSelection => 'Prima selezioni delle lingue';

  @override
  String get metadataSelectAll => 'Seleziona tutto';

  @override
  String get metadataDeselectAll => 'Deseleziona tutto';

  @override
  String metadataSelected(int count) {
    return '$count selezionate';
  }

  @override
  String get metadataTableView => 'Vista tabella';

  @override
  String get metadataListView => 'Vista elenco';

  @override
  String get metadataStatus => 'Stato';

  @override
  String get metadataCompletion => 'Completamento';

  @override
  String get common_back => 'Indietro';

  @override
  String get common_next => 'Avanti';

  @override
  String get common_edit => 'Modifica';

  @override
  String get metadata_aiOptimize => 'Ottimizza con IA';

  @override
  String get wizard_title => 'Assistente di ottimizzazione IA';

  @override
  String get wizard_step => 'Passo';

  @override
  String get wizard_of => 'di';

  @override
  String get wizard_stepTitle => 'Titolo';

  @override
  String get wizard_stepSubtitle => 'Sottotitolo';

  @override
  String get wizard_stepKeywords => 'Parole chiave';

  @override
  String get wizard_stepDescription => 'Descrizione';

  @override
  String get wizard_stepReview => 'Revisione e salvataggio';

  @override
  String get wizard_skip => 'Salta';

  @override
  String get wizard_saveDrafts => 'Salva bozze';

  @override
  String get wizard_draftsSaved => 'Bozze salvate con successo';

  @override
  String get wizard_exitTitle => 'Uscire dall\'assistente?';

  @override
  String get wizard_exitMessage =>
      'Ha delle modifiche non salvate. È sicuro di voler uscire?';

  @override
  String get wizard_exitConfirm => 'Esci';

  @override
  String get wizard_aiSuggestions => 'Suggerimenti IA';

  @override
  String get wizard_chooseSuggestion =>
      'Scelga un suggerimento generato dall\'IA o scriva il Suo';

  @override
  String get wizard_currentValue => 'Valore attuale';

  @override
  String get wizard_noCurrentValue => 'Nessun valore impostato';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return 'Basato su $keywordsCount parole chiave monitorate e $competitorsCount concorrenti';
  }

  @override
  String get wizard_writeOwn => 'Scrivi il mio';

  @override
  String get wizard_customPlaceholder =>
      'Inserisca il Suo valore personalizzato...';

  @override
  String get wizard_useCustom => 'Usa personalizzato';

  @override
  String get wizard_keepCurrent => 'Mantieni attuale';

  @override
  String get wizard_recommended => 'Consigliato';

  @override
  String get wizard_characters => 'caratteri';

  @override
  String get wizard_reviewTitle => 'Rivedi le modifiche';

  @override
  String get wizard_reviewDescription =>
      'Riveda le Sue ottimizzazioni prima di salvarle come bozze';

  @override
  String get wizard_noChanges => 'Nessuna modifica selezionata';

  @override
  String get wizard_noChangesHint =>
      'Torni indietro e selezioni suggerimenti per i campi da ottimizzare';

  @override
  String wizard_changesCount(int count) {
    return '$count campi aggiornati';
  }

  @override
  String get wizard_changesSummary =>
      'Queste modifiche verranno salvate come bozze';

  @override
  String get wizard_before => 'Prima';

  @override
  String get wizard_after => 'Dopo';

  @override
  String get wizard_nextStepsTitle => 'Cosa succede dopo?';

  @override
  String get wizard_nextStepsWithChanges =>
      'Le Sue modifiche verranno salvate come bozze. Potrà rivederle e pubblicarle dall\'editor dei metadati.';

  @override
  String get wizard_nextStepsNoChanges =>
      'Nessuna modifica da salvare. Torni indietro e selezioni suggerimenti per ottimizzare i Suoi metadati.';

  @override
  String get team_title => 'Gestione team';

  @override
  String get team_createTeam => 'Crea team';

  @override
  String get team_teamName => 'Nome del team';

  @override
  String get team_teamNameHint => 'Inserisci il nome del team';

  @override
  String get team_description => 'Descrizione (opzionale)';

  @override
  String get team_descriptionHint => 'A cosa serve questo team?';

  @override
  String get team_teamNameRequired => 'Il nome del team è obbligatorio';

  @override
  String get team_teamNameMinLength =>
      'Il nome del team deve avere almeno 2 caratteri';

  @override
  String get team_inviteMember => 'Invita membro';

  @override
  String get team_emailAddress => 'Indirizzo email';

  @override
  String get team_emailHint => 'collega@esempio.com';

  @override
  String get team_emailRequired => 'L\'email è obbligatoria';

  @override
  String get team_emailInvalid => 'Inserisci un indirizzo email valido';

  @override
  String team_invitationSent(String email) {
    return 'Invito inviato a $email';
  }

  @override
  String get team_members => 'MEMBRI';

  @override
  String get team_invite => 'Invita';

  @override
  String get team_pendingInvitations => 'INVITI IN ATTESA';

  @override
  String get team_noPendingInvitations => 'Nessun invito in attesa';

  @override
  String get team_teamSettings => 'Impostazioni team';

  @override
  String team_changeRole(String name) {
    return 'Cambia ruolo per $name';
  }

  @override
  String get team_removeMember => 'Rimuovi membro';

  @override
  String team_removeMemberConfirm(String name) {
    return 'Sei sicuro di voler rimuovere $name da questo team?';
  }

  @override
  String get team_remove => 'Rimuovi';

  @override
  String get team_leaveTeam => 'Lascia team';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return 'Sei sicuro di voler lasciare \"$teamName\"?';
  }

  @override
  String get team_leave => 'Lascia';

  @override
  String get team_deleteTeam => 'Elimina team';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return 'Sei sicuro di voler eliminare \"$teamName\"? Questa azione non può essere annullata.';
  }

  @override
  String get team_yourTeams => 'I TUOI TEAM';

  @override
  String get team_failedToLoadTeam => 'Impossibile caricare il team';

  @override
  String get team_failedToLoadMembers => 'Impossibile caricare i membri';

  @override
  String get team_failedToLoadInvitations => 'Impossibile caricare gli inviti';

  @override
  String team_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membri',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String team_invitedAs(String role) {
    return 'Invitato come $role';
  }

  @override
  String team_joinedTeam(String teamName) {
    return 'Ti sei unito a $teamName';
  }

  @override
  String get team_invitationDeclined => 'Invito rifiutato';

  @override
  String get team_noTeamsYet => 'Nessun team ancora';

  @override
  String get team_noTeamsDescription =>
      'Crea un team per collaborare con altri sulle tue app';

  @override
  String get team_createFirstTeam => 'Crea il tuo primo team';

  @override
  String get integrations_title => 'Integrazioni';

  @override
  String integrations_syncFailed(String error) {
    return 'Sincronizzazione fallita: $error';
  }

  @override
  String get integrations_disconnectConfirm => 'Disconnettere?';

  @override
  String get integrations_disconnectedSuccess => 'Disconnesso con successo';

  @override
  String get integrations_connectGooglePlay => 'Connetti Google Play Console';

  @override
  String get integrations_connectAppStore => 'Connetti App Store Connect';

  @override
  String integrations_connectedApps(int count) {
    return 'Connesso! $count app importate.';
  }

  @override
  String integrations_syncedApps(int count) {
    return '$count app sincronizzate come proprietario';
  }

  @override
  String get integrations_appStoreConnected =>
      'App Store Connect connesso con successo!';

  @override
  String get integrations_googlePlayConnected =>
      'Google Play Console connesso con successo!';

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
  String get alertBuilder_nameYourRule => 'DAI UN NOME ALLA TUA REGOLA';

  @override
  String get alertBuilder_nameDescription =>
      'Dai un nome descrittivo alla tua regola di avviso';

  @override
  String get alertBuilder_nameHint => 'es: Avviso posizione giornaliero';

  @override
  String get alertBuilder_summary => 'RIEPILOGO';

  @override
  String get alertBuilder_saveAlertRule => 'Salva regola di avviso';

  @override
  String get alertBuilder_selectAlertType => 'SELEZIONA TIPO DI AVVISO';

  @override
  String get alertBuilder_selectAlertTypeDescription =>
      'Scegli che tipo di avviso vuoi creare';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return 'Questo eliminerà \"$ruleName\".';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate =>
      'Nessuna regola ancora. Attiva un modello o crea la tua!';

  @override
  String get billing_cancelSubscription => 'Annulla abbonamento';

  @override
  String get billing_keepSubscription => 'Mantieni abbonamento';

  @override
  String get billing_billingPortal => 'Portale fatturazione';

  @override
  String get billing_resume => 'Riprendi';

  @override
  String get keywords_noCompetitorsFound =>
      'Nessun concorrente trovato. Aggiungi prima dei concorrenti.';

  @override
  String get keywords_noCompetitorsForApp =>
      'Nessun concorrente per questa app. Aggiungi prima un concorrente.';

  @override
  String keywords_failedToAddKeywords(String error) {
    return 'Impossibile aggiungere le parole chiave: $error';
  }

  @override
  String get keywords_bulkAddHint =>
      'tracker budget\ngestore spese\napp denaro';

  @override
  String get appOverview_urlCopied => 'URL dello store copiato negli appunti';

  @override
  String get country_us => 'Stati Uniti';

  @override
  String get country_gb => 'Regno Unito';

  @override
  String get country_fr => 'Francia';

  @override
  String get country_de => 'Germania';

  @override
  String get country_ca => 'Canada';

  @override
  String get country_au => 'Australia';

  @override
  String get country_jp => 'Giappone';

  @override
  String get country_cn => 'Cina';

  @override
  String get country_kr => 'Corea del Sud';

  @override
  String get country_br => 'Brasile';

  @override
  String get country_es => 'Spagna';

  @override
  String get country_it => 'Italia';

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
  String get alertBuilder_type => 'Tipo';

  @override
  String get alertBuilder_scope => 'Ambito';

  @override
  String get alertBuilder_name => 'Nome';

  @override
  String get alertBuilder_scopeGlobal => 'Tutte le app';

  @override
  String get alertBuilder_scopeApp => 'App specifica';

  @override
  String get alertBuilder_scopeCategory => 'Categoria';

  @override
  String get alertBuilder_scopeKeyword => 'Parola chiave';

  @override
  String get alertType_positionChange => 'Cambio posizione';

  @override
  String get alertType_positionChangeDesc =>
      'Avviso quando il ranking cambia significativamente';

  @override
  String get alertType_ratingChange => 'Cambio valutazione';

  @override
  String get alertType_ratingChangeDesc =>
      'Avviso quando cambia la valutazione';

  @override
  String get alertType_reviewSpike => 'Picco recensioni';

  @override
  String get alertType_reviewSpikeDesc =>
      'Avviso per attività recensioni insolita';

  @override
  String get alertType_reviewKeyword => 'Parola chiave nelle recensioni';

  @override
  String get alertType_reviewKeywordDesc =>
      'Avviso quando parole chiave appaiono nelle recensioni';

  @override
  String get alertType_newCompetitor => 'Nuovo concorrente';

  @override
  String get alertType_newCompetitorDesc =>
      'Avviso quando nuove app entrano nel tuo spazio';

  @override
  String get alertType_competitorPassed => 'Concorrente superato';

  @override
  String get alertType_competitorPassedDesc =>
      'Avviso quando superi un concorrente';

  @override
  String get alertType_massMovement => 'Movimento di massa';

  @override
  String get alertType_massMovementDesc =>
      'Avviso per grandi spostamenti di ranking';

  @override
  String get alertType_keywordTrend => 'Trend parola chiave';

  @override
  String get alertType_keywordTrendDesc =>
      'Avviso quando cambia la popolarità di una parola chiave';

  @override
  String get alertType_opportunity => 'Opportunità';

  @override
  String get alertType_opportunityDesc =>
      'Avviso su nuove opportunità di ranking';

  @override
  String get billing_title => 'Fatturazione e Piani';

  @override
  String get billing_subscriptionActivated =>
      'Abbonamento attivato con successo!';

  @override
  String get billing_changePlan => 'Cambia piano';

  @override
  String get billing_choosePlan => 'Scegli un piano';

  @override
  String get billing_cancelMessage =>
      'Il tuo abbonamento rimarrà attivo fino alla fine del periodo di fatturazione corrente. Dopo, perderai l\'accesso alle funzionalità premium.';

  @override
  String get billing_currentPlan => 'PIANO ATTUALE';

  @override
  String get billing_trial => 'PROVA';

  @override
  String get billing_canceling => 'IN CANCELLAZIONE';

  @override
  String billing_accessUntil(String date) {
    return 'Accesso fino al $date';
  }

  @override
  String billing_renewsOn(String date) {
    return 'Rinnovo il $date';
  }

  @override
  String get billing_manageSubscription => 'GESTISCI ABBONAMENTO';

  @override
  String get billing_monthly => 'Mensile';

  @override
  String get billing_yearly => 'Annuale';

  @override
  String billing_savePercent(int percent) {
    return 'Risparmia $percent%';
  }

  @override
  String get billing_current => 'Attuale';

  @override
  String get billing_apps => 'App';

  @override
  String get billing_unlimited => 'Illimitato';

  @override
  String get billing_keywordsPerApp => 'Parole chiave per app';

  @override
  String get billing_history => 'Cronologia';

  @override
  String billing_days(int count) {
    return '$count giorni';
  }

  @override
  String get billing_exports => 'Esportazioni';

  @override
  String get billing_aiInsights => 'Analisi IA';

  @override
  String get billing_apiAccess => 'Accesso API';

  @override
  String get billing_yes => 'Sì';

  @override
  String get billing_no => 'No';

  @override
  String get billing_currentPlanButton => 'Piano attuale';

  @override
  String billing_upgradeTo(String planName) {
    return 'Passa a $planName';
  }

  @override
  String get billing_cancel => 'Annulla';

  @override
  String get keywords_compareWithCompetitor => 'Confronta con concorrente';

  @override
  String get keywords_selectCompetitorToCompare =>
      'Seleziona un concorrente per confrontare le parole chiave:';

  @override
  String get keywords_addToCompetitor => 'Aggiungi a concorrente';

  @override
  String keywords_addKeywordsTo(int count) {
    return 'Aggiungi $count parola/e chiave a:';
  }

  @override
  String get keywords_avgPosition => 'Posizione media';

  @override
  String get keywords_declined => 'In calo';

  @override
  String get keywords_total => 'Totale';

  @override
  String get keywords_ranked => 'Classificati';

  @override
  String get keywords_improved => 'Migliorati';

  @override
  String get onboarding_skip => 'Salta';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_getStarted => 'Inizia';

  @override
  String get onboarding_welcomeToKeyrank => 'Benvenuto su Keyrank';

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
  String get team_you => 'Tu';

  @override
  String get team_changeRoleButton => 'Change Role';

  @override
  String get team_removeButton => 'Remove';

  @override
  String get competitors_removeTitle => 'Remove Competitor';

  @override
  String competitors_removeConfirm(String name) {
    return 'Sei sicuro di voler rimuovere \"$name\" dai tuoi concorrenti?';
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
    return 'Impossibile aggiungere il concorrente: $error';
  }

  @override
  String get competitors_searchForCompetitor => 'Search for a competitor';

  @override
  String get appPreview_back => 'Back';

  @override
  String get alerts_edit => 'Modifica';

  @override
  String get alerts_scopeGlobal => 'Globale';

  @override
  String get alerts_scopeApp => 'App';

  @override
  String get alerts_scopeCategory => 'Categoria';

  @override
  String get alerts_scopeKeyword => 'Parola chiave';

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
    return 'Visualizza altri $count insight';
  }

  @override
  String get insights_noInsightsDesc =>
      'Gli insight appariranno quando scopriremo opportunità di ottimizzazione per la tua app.';

  @override
  String get insights_loadFailed => 'Impossibile caricare gli insight';

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
