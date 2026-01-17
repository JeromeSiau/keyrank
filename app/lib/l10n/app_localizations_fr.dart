// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTagline => 'Suivez vos classements App Store';

  @override
  String get auth_welcomeBack => 'Bon retour';

  @override
  String get auth_signInSubtitle => 'Connectez-vous à votre compte';

  @override
  String get auth_createAccount => 'Créer un compte';

  @override
  String get auth_createAccountSubtitle => 'Commencez à suivre vos classements';

  @override
  String get auth_emailLabel => 'E-mail';

  @override
  String get auth_passwordLabel => 'Mot de passe';

  @override
  String get auth_nameLabel => 'Nom';

  @override
  String get auth_confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get auth_signInButton => 'Se connecter';

  @override
  String get auth_signUpButton => 'Créer un compte';

  @override
  String get auth_noAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get auth_hasAccount => 'Vous avez déjà un compte ?';

  @override
  String get auth_signUpLink => 'S\'inscrire';

  @override
  String get auth_signInLink => 'Se connecter';

  @override
  String get auth_emailRequired => 'Veuillez entrer votre e-mail';

  @override
  String get auth_emailInvalid => 'E-mail invalide';

  @override
  String get auth_passwordRequired => 'Veuillez entrer votre mot de passe';

  @override
  String get auth_enterPassword => 'Veuillez entrer un mot de passe';

  @override
  String get auth_nameRequired => 'Veuillez entrer votre nom';

  @override
  String get auth_passwordMinLength =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get auth_passwordsNoMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get auth_errorOccurred => 'Une erreur s\'est produite';

  @override
  String get common_retry => 'Réessayer';

  @override
  String common_error(String message) {
    return 'Erreur : $message';
  }

  @override
  String get common_loading => 'Chargement...';

  @override
  String get common_add => 'Ajouter';

  @override
  String get common_filter => 'Filtrer';

  @override
  String get common_sort => 'Trier';

  @override
  String get common_refresh => 'Actualiser';

  @override
  String get common_settings => 'Paramètres';

  @override
  String get common_search => 'Rechercher...';

  @override
  String get common_noResults => 'Aucun résultat';

  @override
  String get dashboard_title => 'Tableau de bord';

  @override
  String get dashboard_addApp => 'Ajouter une app';

  @override
  String get dashboard_appsTracked => 'Apps suivies';

  @override
  String get dashboard_keywords => 'Mots-clés';

  @override
  String get dashboard_avgPosition => 'Position moyenne';

  @override
  String get dashboard_top10 => 'Top 10';

  @override
  String get dashboard_trackedApps => 'Apps suivies';

  @override
  String get dashboard_quickActions => 'Actions rapides';

  @override
  String get dashboard_addNewApp => 'Ajouter une nouvelle app';

  @override
  String get dashboard_searchKeywords => 'Rechercher des mots-clés';

  @override
  String get dashboard_viewAllApps => 'Voir toutes les apps';

  @override
  String get dashboard_noAppsYet => 'Aucune app suivie pour le moment';

  @override
  String get dashboard_addAppToStart =>
      'Ajoutez une app pour commencer à suivre les mots-clés';

  @override
  String get dashboard_noAppsMatchFilter =>
      'Aucune app ne correspond au filtre';

  @override
  String get dashboard_changeFilterCriteria =>
      'Essayez de modifier les critères de filtre';

  @override
  String get dashboard_reviews => 'Avis';

  @override
  String get dashboard_avgRating => 'Note moyenne';

  @override
  String get dashboard_topPerformingApps => 'Apps les plus performantes';

  @override
  String get dashboard_topCountries => 'Principaux pays';

  @override
  String get dashboard_sentimentOverview => 'Aperçu du sentiment';

  @override
  String get dashboard_overallSentiment => 'Sentiment global';

  @override
  String get dashboard_positive => 'Positif';

  @override
  String get dashboard_positiveReviews => 'Positif';

  @override
  String get dashboard_negativeReviews => 'Négatif';

  @override
  String get dashboard_viewReviews => 'Voir les avis';

  @override
  String get dashboard_tableApp => 'APP';

  @override
  String get dashboard_tableKeywords => 'MOTS-CLÉS';

  @override
  String get dashboard_tableAvgRank => 'RANG MOY.';

  @override
  String get dashboard_tableTrend => 'TENDANCE';

  @override
  String get dashboard_connectYourStores => 'Connectez vos stores';

  @override
  String get dashboard_connectStoresDescription =>
      'Liez App Store Connect ou Google Play pour importer vos apps et répondre aux avis.';

  @override
  String get dashboard_connect => 'Connecter';

  @override
  String get apps_title => 'Mes Apps';

  @override
  String apps_appCount(int count) {
    return '$count apps';
  }

  @override
  String get apps_tableApp => 'APP';

  @override
  String get apps_tableDeveloper => 'DÉVELOPPEUR';

  @override
  String get apps_tableKeywords => 'MOTS-CLÉS';

  @override
  String get apps_tablePlatform => 'PLATEFORME';

  @override
  String get apps_tableRating => 'NOTE';

  @override
  String get apps_tableBestRank => 'MEILLEUR RANG';

  @override
  String get apps_noAppsYet => 'Aucune app suivie pour le moment';

  @override
  String get apps_addAppToStart =>
      'Ajoutez une app pour commencer à suivre ses classements';

  @override
  String get addApp_title => 'Ajouter une App';

  @override
  String get addApp_searchAppStore => 'Rechercher sur l\'App Store...';

  @override
  String get addApp_searchPlayStore => 'Rechercher sur le Play Store...';

  @override
  String get addApp_searchForApp => 'Rechercher une app';

  @override
  String get addApp_enterAtLeast2Chars => 'Entrez au moins 2 caractères';

  @override
  String get addApp_noResults => 'Aucun résultat trouvé';

  @override
  String addApp_addedSuccess(String name) {
    return '$name ajouté avec succès';
  }

  @override
  String get settings_title => 'Paramètres';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_appearance => 'Apparence';

  @override
  String get settings_theme => 'Thème';

  @override
  String get settings_themeSystem => 'Système';

  @override
  String get settings_themeDark => 'Sombre';

  @override
  String get settings_themeLight => 'Clair';

  @override
  String get settings_account => 'Compte';

  @override
  String get settings_memberSince => 'Membre depuis';

  @override
  String get settings_logout => 'Se déconnecter';

  @override
  String get settings_languageSystem => 'Système';

  @override
  String get filter_all => 'Tout';

  @override
  String get filter_allApps => 'Toutes les apps';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'iOS uniquement';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Android uniquement';

  @override
  String get filter_favorites => 'Favoris';

  @override
  String get sort_recent => 'Récent';

  @override
  String get sort_recentlyAdded => 'Ajouté récemment';

  @override
  String get sort_nameAZ => 'Nom A-Z';

  @override
  String get sort_nameZA => 'Nom Z-A';

  @override
  String get sort_keywords => 'Mots-clés';

  @override
  String get sort_mostKeywords => 'Plus de mots-clés';

  @override
  String get sort_bestRank => 'Meilleur rang';

  @override
  String get userMenu_logout => 'Se déconnecter';

  @override
  String get insights_compareTitle => 'Comparer les analyses';

  @override
  String get insights_analyzingReviews => 'Analyse des avis en cours...';

  @override
  String get insights_noInsightsAvailable => 'Aucune analyse disponible';

  @override
  String get insights_strengths => 'Points forts';

  @override
  String get insights_weaknesses => 'Points faibles';

  @override
  String get insights_scores => 'Scores';

  @override
  String get insights_opportunities => 'Opportunités';

  @override
  String get insights_categoryUx => 'UX';

  @override
  String get insights_categoryPerf => 'Perf';

  @override
  String get insights_categoryFeatures => 'Fonctionnalités';

  @override
  String get insights_categoryPricing => 'Tarifs';

  @override
  String get insights_categorySupport => 'Support';

  @override
  String get insights_categoryOnboard => 'Onboard';

  @override
  String get insights_categoryUxFull => 'UX / Interface';

  @override
  String get insights_categoryPerformance => 'Performance';

  @override
  String get insights_categoryOnboarding => 'Onboarding';

  @override
  String get insights_reviewInsights => 'Analyses des avis';

  @override
  String get insights_generateFirst => 'Générez d\'abord les analyses';

  @override
  String get insights_compareWithOther => 'Comparer avec d\'autres apps';

  @override
  String get insights_compare => 'Comparer';

  @override
  String get insights_generateAnalysis => 'Générer l\'analyse';

  @override
  String get insights_period => 'Période :';

  @override
  String get insights_3months => '3 mois';

  @override
  String get insights_6months => '6 mois';

  @override
  String get insights_12months => '12 mois';

  @override
  String get insights_analyze => 'Analyser';

  @override
  String insights_reviewsCount(int count) {
    return '$count avis';
  }

  @override
  String insights_analyzedAgo(String time) {
    return 'Analysé $time';
  }

  @override
  String get insights_yourNotes => 'Vos notes';

  @override
  String get insights_save => 'Enregistrer';

  @override
  String get insights_clickToAddNotes => 'Cliquez pour ajouter des notes...';

  @override
  String get insights_noteSaved => 'Note enregistrée';

  @override
  String get insights_noteHint => 'Ajoutez vos notes sur cette analyse...';

  @override
  String get insights_categoryScores => 'Scores par catégorie';

  @override
  String get insights_emergentThemes => 'Thèmes émergents';

  @override
  String get insights_exampleQuotes => 'Exemples de citations :';

  @override
  String get insights_selectCountryFirst => 'Sélectionnez au moins un pays';

  @override
  String get insights_title => 'Analyses';

  @override
  String insights_titleWithApp(String appName) {
    return 'Analyses - $appName';
  }

  @override
  String get insights_allApps => 'Analyses (Toutes les apps)';

  @override
  String get insights_noInsightsYet => 'Pas encore d\'analyses';

  @override
  String get insights_selectAppToGenerate =>
      'Sélectionnez une app pour générer des analyses à partir des avis';

  @override
  String insights_appsWithInsights(int count) {
    return '$count apps avec analyses';
  }

  @override
  String get insights_errorLoading => 'Erreur de chargement des analyses';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '$count avis analysés';
  }

  @override
  String get insights_avgScore => 'score moyen';

  @override
  String insights_updatedOn(String date) {
    return 'Mis à jour le $date';
  }

  @override
  String compare_selectAppsToCompare(String appName) {
    return 'Sélectionnez jusqu\'à 3 apps à comparer avec $appName';
  }

  @override
  String get compare_searchApps => 'Rechercher des apps...';

  @override
  String get compare_noOtherApps => 'Aucune autre app à comparer';

  @override
  String get compare_noMatchingApps => 'Aucune app correspondante';

  @override
  String compare_appsSelected(int count) {
    return '$count sur 3 apps sélectionnées';
  }

  @override
  String get compare_cancel => 'Annuler';

  @override
  String compare_button(int count) {
    return 'Comparer $count apps';
  }

  @override
  String get appDetail_deleteAppTitle => 'Supprimer l\'app ?';

  @override
  String get appDetail_deleteAppConfirm => 'Cette action est irréversible.';

  @override
  String get appDetail_cancel => 'Annuler';

  @override
  String get appDetail_delete => 'Supprimer';

  @override
  String get appDetail_exporting => 'Export des classements...';

  @override
  String appDetail_savedFile(String filename) {
    return 'Enregistré : $filename';
  }

  @override
  String get appDetail_showInFinder => 'Afficher dans le Finder';

  @override
  String appDetail_exportFailed(String error) {
    return 'Échec de l\'export : $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return '$imported mots-clés importés ($skipped ignorés)';
  }

  @override
  String get appDetail_favorite => 'Favori';

  @override
  String get appDetail_ratings => 'Notes';

  @override
  String get appDetail_insights => 'Analyses';

  @override
  String get appDetail_import => 'Importer';

  @override
  String get appDetail_export => 'Exporter';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count avis';
  }

  @override
  String get appDetail_keywords => 'mots-clés';

  @override
  String get appDetail_addKeyword => 'Ajouter un mot-clé';

  @override
  String get appDetail_keywordHint => 'ex : suivi fitness';

  @override
  String get appDetail_trackedKeywords => 'Mots-clés suivis';

  @override
  String appDetail_selectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get appDetail_allKeywords => 'Tous les mots-clés';

  @override
  String get appDetail_hasTags => 'Avec tags';

  @override
  String get appDetail_hasNotes => 'Avec notes';

  @override
  String get appDetail_position => 'Position';

  @override
  String get appDetail_select => 'Sélectionner';

  @override
  String get appDetail_suggestions => 'Suggestions';

  @override
  String get appDetail_deleteKeywordsTitle => 'Supprimer les mots-clés';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return 'Voulez-vous vraiment supprimer $count mots-clés ?';
  }

  @override
  String get appDetail_tag => 'Tag';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return 'Mot-clé « $keyword » ajouté ($flag)';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return 'Tags ajoutés à $count mots-clés';
  }

  @override
  String get appDetail_keywordsAddedSuccess => 'Mots-clés ajoutés avec succès';

  @override
  String get appDetail_noTagsAvailable =>
      'Aucun tag disponible. Créez d\'abord des tags.';

  @override
  String get appDetail_tagged => 'Tagué';

  @override
  String get appDetail_withNotes => 'Avec notes';

  @override
  String get appDetail_nameAZ => 'Nom A-Z';

  @override
  String get appDetail_nameZA => 'Nom Z-A';

  @override
  String get appDetail_bestPosition => 'Meilleure position';

  @override
  String get appDetail_recentlyTracked => 'Récemment suivi';

  @override
  String get keywordSuggestions_title => 'Suggestions de mots-clés';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$appName en $country';
  }

  @override
  String get keywordSuggestions_refresh => 'Actualiser les suggestions';

  @override
  String get keywordSuggestions_search => 'Rechercher dans les suggestions...';

  @override
  String get keywordSuggestions_selectAll => 'Tout sélectionner';

  @override
  String get keywordSuggestions_clear => 'Effacer';

  @override
  String get keywordSuggestions_analyzing =>
      'Analyse des métadonnées de l\'app...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds =>
      'Cela peut prendre quelques secondes';

  @override
  String get keywordSuggestions_noSuggestions => 'Aucune suggestion disponible';

  @override
  String get keywordSuggestions_noMatchingSuggestions =>
      'Aucune suggestion correspondante';

  @override
  String get keywordSuggestions_headerKeyword => 'MOT-CLÉ';

  @override
  String get keywordSuggestions_headerDifficulty => 'DIFFICULTÉ';

  @override
  String get keywordSuggestions_headerApps => 'APPS';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return 'Classé #$position';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count mots-clés sélectionnés';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return 'Ajouter $count mots-clés';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Erreur lors de l\'ajout des mots-clés : $error';
  }

  @override
  String get keywordSuggestions_categoryAll => 'Tout';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'Opportunités';

  @override
  String get keywordSuggestions_categoryCompetitor => 'Mots-clés concurrents';

  @override
  String get keywordSuggestions_categoryLongTail => 'Long-tail';

  @override
  String get keywordSuggestions_categoryTrending => 'Tendances';

  @override
  String get keywordSuggestions_categoryRelated => 'Associés';

  @override
  String get keywordSuggestions_generating => 'Génération des suggestions...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      'Cela peut prendre quelques minutes. Revenez plus tard.';

  @override
  String get keywordSuggestions_checkAgain => 'Vérifier à nouveau';

  @override
  String get sidebar_favorites => 'FAVORIS';

  @override
  String get sidebar_tooManyFavorites => 'Essayez de garder 5 favoris ou moins';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Recherche de mots-clés';

  @override
  String get keywordSearch_searchPlaceholder => 'Rechercher des mots-clés...';

  @override
  String get keywordSearch_searchTitle => 'Rechercher un mot-clé';

  @override
  String get keywordSearch_searchSubtitle =>
      'Découvrez quelles apps sont classées pour un mot-clé';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count apps classées';
  }

  @override
  String get keywordSearch_popularity => 'Popularité';

  @override
  String keywordSearch_results(int count) {
    return '$count résultats';
  }

  @override
  String get keywordSearch_headerRank => 'RANG';

  @override
  String get keywordSearch_headerApp => 'APP';

  @override
  String get keywordSearch_headerRating => 'NOTE';

  @override
  String get keywordSearch_headerTrack => 'SUIVRE';

  @override
  String get keywordSearch_trackApp => 'Suivre cette app';

  @override
  String get discover_title => 'Découvrir';

  @override
  String get discover_tabKeywords => 'Mots-clés';

  @override
  String get discover_tabCategories => 'Catégories';

  @override
  String get discover_selectCategory => 'Sélectionner une catégorie';

  @override
  String get discover_topFree => 'Gratuit';

  @override
  String get discover_topPaid => 'Payant';

  @override
  String get discover_topGrossing => 'Revenus';

  @override
  String get discover_noResults => 'Aucun résultat';

  @override
  String get discover_loadingTopApps => 'Chargement des top apps...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return 'Top $collection en $category';
  }

  @override
  String discover_appsCount(int count) {
    return '$count apps';
  }

  @override
  String get discover_allCategories => 'Toutes les catégories';

  @override
  String get category_games => 'Jeux';

  @override
  String get category_business => 'Affaires';

  @override
  String get category_education => 'Éducation';

  @override
  String get category_entertainment => 'Divertissement';

  @override
  String get category_finance => 'Finance';

  @override
  String get category_food_drink => 'Alimentation';

  @override
  String get category_health_fitness => 'Santé et forme';

  @override
  String get category_lifestyle => 'Style de vie';

  @override
  String get category_medical => 'Médecine';

  @override
  String get category_music => 'Musique';

  @override
  String get category_navigation => 'Navigation';

  @override
  String get category_news => 'Actualités';

  @override
  String get category_photo_video => 'Photo et vidéo';

  @override
  String get category_productivity => 'Productivité';

  @override
  String get category_reference => 'Référence';

  @override
  String get category_shopping => 'Shopping';

  @override
  String get category_social => 'Réseaux sociaux';

  @override
  String get category_sports => 'Sports';

  @override
  String get category_travel => 'Voyage';

  @override
  String get category_utilities => 'Utilitaires';

  @override
  String get category_weather => 'Météo';

  @override
  String get category_books => 'Livres';

  @override
  String get category_developer_tools => 'Outils de développement';

  @override
  String get category_graphics_design => 'Graphisme et design';

  @override
  String get category_magazines => 'Magazines et journaux';

  @override
  String get category_stickers => 'Autocollants';

  @override
  String get category_catalogs => 'Catalogues';

  @override
  String get category_art_design => 'Art et design';

  @override
  String get category_auto_vehicles => 'Auto et véhicules';

  @override
  String get category_beauty => 'Beauté';

  @override
  String get category_comics => 'BD';

  @override
  String get category_communication => 'Communication';

  @override
  String get category_dating => 'Rencontres';

  @override
  String get category_events => 'Événements';

  @override
  String get category_house_home => 'Maison';

  @override
  String get category_libraries => 'Bibliothèques';

  @override
  String get category_maps_navigation => 'Cartes et navigation';

  @override
  String get category_music_audio => 'Musique et audio';

  @override
  String get category_news_magazines => 'Actualités et magazines';

  @override
  String get category_parenting => 'Parentalité';

  @override
  String get category_personalization => 'Personnalisation';

  @override
  String get category_photography => 'Photographie';

  @override
  String get category_tools => 'Outils';

  @override
  String get category_video_players => 'Lecteurs vidéo';

  @override
  String get category_all_apps => 'Toutes les apps';

  @override
  String reviews_reviewsFor(String appName) {
    return 'Avis pour $appName';
  }

  @override
  String get reviews_loading => 'Chargement des avis...';

  @override
  String get reviews_noReviews => 'Aucun avis';

  @override
  String reviews_noReviewsFor(String countryName) {
    return 'Aucun avis trouvé pour $countryName';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'Affichage des $count avis les plus récents de l\'App Store.';
  }

  @override
  String get reviews_today => 'Aujourd\'hui';

  @override
  String get reviews_yesterday => 'Hier';

  @override
  String reviews_daysAgo(int count) {
    return 'Il y a $count jours';
  }

  @override
  String reviews_weeksAgo(int count) {
    return 'Il y a $count semaines';
  }

  @override
  String reviews_monthsAgo(int count) {
    return 'Il y a $count mois';
  }

  @override
  String get ratings_byCountry => 'Notes par pays';

  @override
  String get ratings_noRatingsAvailable => 'Aucune note disponible';

  @override
  String get ratings_noRatingsYet => 'Cette app n\'a pas encore de notes';

  @override
  String get ratings_totalRatings => 'Total des notes';

  @override
  String get ratings_averageRating => 'Note moyenne';

  @override
  String ratings_countriesCount(int count) {
    return '$count pays';
  }

  @override
  String ratings_updated(String date) {
    return 'Mis à jour : $date';
  }

  @override
  String get ratings_headerCountry => 'PAYS';

  @override
  String get ratings_headerRatings => 'NOTES';

  @override
  String get ratings_headerAverage => 'MOYENNE';

  @override
  String time_minutesAgo(int count) {
    return 'Il y a ${count}m';
  }

  @override
  String time_hoursAgo(int count) {
    return 'Il y a ${count}h';
  }

  @override
  String time_daysAgo(int count) {
    return 'Il y a ${count}j';
  }

  @override
  String get appDetail_noKeywordsTracked => 'Aucun mot-clé suivi';

  @override
  String get appDetail_addKeywordHint =>
      'Ajoutez un mot-clé ci-dessus pour commencer le suivi';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Aucun mot-clé ne correspond au filtre';

  @override
  String get appDetail_tryChangingFilter =>
      'Essayez de modifier les critères du filtre';

  @override
  String get appDetail_addTag => 'Ajouter un tag';

  @override
  String get appDetail_addNote => 'Ajouter une note';

  @override
  String get appDetail_positionHistory => 'Historique des positions';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => 'VUE D\'ENSEMBLE';

  @override
  String get nav_dashboard => 'Tableau de bord';

  @override
  String get nav_myApps => 'Mes Apps';

  @override
  String get nav_research => 'RECHERCHE';

  @override
  String get nav_keywords => 'Mots-clés';

  @override
  String get nav_discover => 'Découvrir';

  @override
  String get nav_engagement => 'ENGAGEMENT';

  @override
  String get nav_reviewsInbox => 'Boîte de réception';

  @override
  String get nav_notifications => 'Alertes';

  @override
  String get nav_optimization => 'OPTIMISATION';

  @override
  String get nav_keywordInspector => 'Inspecteur de mots-clés';

  @override
  String get nav_ratingsAnalysis => 'Analyse des notes';

  @override
  String get nav_intelligence => 'INTELLIGENCE';

  @override
  String get nav_topCharts => 'Top Charts';

  @override
  String get nav_competitors => 'Concurrents';

  @override
  String get common_save => 'Enregistrer';

  @override
  String get appDetail_manageTags => 'Gérer les tags';

  @override
  String get appDetail_newTagHint => 'Nom du nouveau tag...';

  @override
  String get appDetail_availableTags => 'Tags disponibles';

  @override
  String get appDetail_noTagsYet =>
      'Aucun tag pour l\'instant. Créez-en un ci-dessus.';

  @override
  String get appDetail_addTagsTitle => 'Ajouter des tags';

  @override
  String get appDetail_selectTagsDescription =>
      'Sélectionnez les tags à ajouter aux mots-clés sélectionnés :';

  @override
  String appDetail_addTagsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tags',
      one: 'tag',
    );
    return 'Ajouter $count $_temp0';
  }

  @override
  String get appDetail_currentTags => 'Tags actuels';

  @override
  String get appDetail_noTagsOnKeyword => 'Aucun tag sur ce mot-clé';

  @override
  String get appDetail_addExistingTag => 'Ajouter un tag existant';

  @override
  String get appDetail_allTagsUsed => 'Tous les tags sont déjà utilisés';

  @override
  String get appDetail_createNewTag => 'Créer un nouveau tag';

  @override
  String get appDetail_tagNameHint => 'Nom du tag...';

  @override
  String get appDetail_note => 'Note';

  @override
  String get appDetail_noteHint => 'Ajouter une note sur ce mot-clé...';

  @override
  String get appDetail_saveNote => 'Enregistrer la note';

  @override
  String get appDetail_done => 'Terminé';

  @override
  String appDetail_importFailed(String error) {
    return 'Échec de l\'import : $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Importer des mots-clés';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Collez les mots-clés ci-dessous, un par ligne :';

  @override
  String get appDetail_keywordPlaceholder =>
      'mot-clé un\nmot-clé deux\nmot-clé trois';

  @override
  String get appDetail_storefront => 'Storefront :';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count mots-clés';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return 'Importer $count mots-clés';
  }

  @override
  String get appDetail_period7d => '7j';

  @override
  String get appDetail_period30d => '30j';

  @override
  String get appDetail_period90d => '90j';

  @override
  String get keywords_difficultyFilter => 'Difficulté :';

  @override
  String get keywords_difficultyAll => 'Toutes';

  @override
  String get keywords_difficultyEasy => 'Facile < 40';

  @override
  String get keywords_difficultyMedium => 'Moyen 40-70';

  @override
  String get keywords_difficultyHard => 'Difficile > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'Détails de l\'app';

  @override
  String get appPreview_notFound => 'Application introuvable';

  @override
  String get appPreview_screenshots => 'Captures d\'écran';

  @override
  String get appPreview_description => 'Description';

  @override
  String get appPreview_details => 'Détails';

  @override
  String get appPreview_version => 'Version';

  @override
  String get appPreview_updated => 'Mise à jour';

  @override
  String get appPreview_released => 'Sortie';

  @override
  String get appPreview_size => 'Taille';

  @override
  String get appPreview_minimumOs => 'Requis';

  @override
  String get appPreview_price => 'Prix';

  @override
  String get appPreview_free => 'Gratuit';

  @override
  String get appPreview_openInStore => 'Ouvrir dans le Store';

  @override
  String get appPreview_addToMyApps => 'Ajouter à mes apps';

  @override
  String get appPreview_added => 'Ajouté';

  @override
  String get appPreview_showMore => 'Voir plus';

  @override
  String get appPreview_showLess => 'Voir moins';

  @override
  String get appPreview_keywordsPlaceholder =>
      'Ajoutez cette app à vos apps suivies pour activer le suivi des mots-clés';

  @override
  String get notifications_title => 'Notifications';

  @override
  String get notifications_markAllRead => 'Tout marquer comme lu';

  @override
  String get notifications_empty => 'Aucune notification pour le moment';

  @override
  String get alerts_title => 'Règles d\'alerte';

  @override
  String get alerts_templatesTitle => 'Modèles rapides';

  @override
  String get alerts_templatesSubtitle =>
      'Activez les alertes courantes en un clic';

  @override
  String get alerts_myRulesTitle => 'Mes règles';

  @override
  String get alerts_createRule => 'Créer une règle';

  @override
  String get alerts_editRule => 'Modifier la règle';

  @override
  String get alerts_noRulesYet => 'Aucune règle pour le moment';

  @override
  String get alerts_deleteConfirm => 'Supprimer la règle ?';

  @override
  String get alerts_createCustomRule => 'Créer une règle personnalisée';

  @override
  String alerts_ruleActivated(String name) {
    return '$name activé !';
  }

  @override
  String alerts_deleteMessage(String name) {
    return 'Cela supprimera \"$name\".';
  }

  @override
  String get alerts_noRulesDescription =>
      'Activez un modèle ou créez le vôtre !';

  @override
  String get alerts_create => 'Créer';

  @override
  String get settings_notifications => 'NOTIFICATIONS';

  @override
  String get settings_manageAlerts => 'Gérer les règles d\'alerte';

  @override
  String get settings_manageAlertsDesc =>
      'Configurez les alertes que vous recevez';

  @override
  String get settings_storeConnections => 'Connexions aux stores';

  @override
  String get settings_storeConnectionsDesc =>
      'Connectez vos comptes App Store et Google Play';

  @override
  String get settings_alertDelivery => 'LIVRAISON DES ALERTES';

  @override
  String get settings_team => 'ÉQUIPE';

  @override
  String get settings_teamManagement => 'Gestion de l\'équipe';

  @override
  String get settings_teamManagementDesc =>
      'Inviter des membres, gérer les rôles et permissions';

  @override
  String get settings_integrations => 'INTÉGRATIONS';

  @override
  String get settings_manageIntegrations => 'Gérer les intégrations';

  @override
  String get settings_manageIntegrationsDesc =>
      'Connecter App Store Connect et Google Play Console';

  @override
  String get settings_billing => 'FACTURATION';

  @override
  String get settings_plansBilling => 'Plans et facturation';

  @override
  String get settings_plansBillingDesc => 'Gérer votre abonnement et paiement';

  @override
  String get settings_rememberApp => 'Mémoriser l\'app sélectionnée';

  @override
  String get settings_rememberAppDesc =>
      'Restaurer la sélection d\'app au lancement';

  @override
  String get storeConnections_title => 'Connexions aux stores';

  @override
  String get storeConnections_description =>
      'Connectez vos comptes App Store et Google Play pour activer des fonctionnalités avancées comme les données de ventes et les analyses d\'applications.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Connectez votre compte développeur Apple';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Connectez votre compte Google Play';

  @override
  String get storeConnections_connect => 'Connecter';

  @override
  String get storeConnections_disconnect => 'Déconnecter';

  @override
  String get storeConnections_connected => 'Connecté';

  @override
  String get storeConnections_disconnectConfirm => 'Déconnecter ?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'Êtes-vous sûr de vouloir déconnecter ce compte $platform ?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Déconnecté avec succès';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Dernière sync : $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return 'Connecté le $date';
  }

  @override
  String get storeConnections_syncApps => 'Synchroniser les apps';

  @override
  String get storeConnections_syncing => 'Synchronisation...';

  @override
  String get storeConnections_syncDescription =>
      'La synchronisation marquera vos apps de ce compte comme possédées, permettant de répondre aux avis.';

  @override
  String storeConnections_syncedApps(int count) {
    return '$count apps synchronisées comme possédées';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return 'Échec de la synchronisation : $error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return 'Erreur de chargement des connexions : $error';
  }

  @override
  String get reviewsInbox_title => 'Boîte de réception';

  @override
  String get reviewsInbox_filterUnanswered => 'Sans réponse';

  @override
  String get reviewsInbox_filterNegative => 'Négatif';

  @override
  String get reviewsInbox_noReviews => 'Aucun avis trouvé';

  @override
  String get reviewsInbox_noReviewsDesc => 'Essayez d\'ajuster vos filtres';

  @override
  String get reviewsInbox_reply => 'Répondre';

  @override
  String get reviewsInbox_responded => 'Réponse';

  @override
  String reviewsInbox_respondedAt(String date) {
    return 'Répondu le $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Répondre à l\'avis';

  @override
  String get reviewsInbox_generateAi => 'Générer une suggestion IA';

  @override
  String get reviewsInbox_generating => 'Génération...';

  @override
  String get reviewsInbox_sendReply => 'Envoyer la réponse';

  @override
  String get reviewsInbox_sending => 'Envoi...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Écrivez votre réponse...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 caractères';
  }

  @override
  String get reviewsInbox_replySent => 'Réponse envoyée avec succès';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Échec de l\'envoi de la réponse : $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Échec de la génération de suggestion : $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count étoiles';
  }

  @override
  String get reviewsInbox_totalReviews => 'Total des avis';

  @override
  String get reviewsInbox_unanswered => 'Sans réponse';

  @override
  String get reviewsInbox_positive => 'Positifs';

  @override
  String get reviewsInbox_avgRating => 'Note moyenne';

  @override
  String get reviewsInbox_sentimentOverview => 'Aperçu du sentiment';

  @override
  String get reviewsInbox_aiSuggestions => 'Suggestions IA';

  @override
  String get reviewsInbox_regenerate => 'Régénérer';

  @override
  String get reviewsInbox_toneProfessional => 'Professionnel';

  @override
  String get reviewsInbox_toneEmpathetic => 'Empathique';

  @override
  String get reviewsInbox_toneBrief => 'Bref';

  @override
  String get reviewsInbox_selectTone => 'Sélectionnez le ton :';

  @override
  String get reviewsInbox_detectedIssues => 'Problèmes détectés :';

  @override
  String get reviewsInbox_aiPrompt =>
      'Cliquez sur \'Générer une suggestion IA\' pour obtenir des suggestions de réponse en 3 tons différents';

  @override
  String get reviewIntelligence_title => 'Intelligence des avis';

  @override
  String get reviewIntelligence_featureRequests =>
      'Demandes de fonctionnalités';

  @override
  String get reviewIntelligence_bugReports => 'Rapports de bugs';

  @override
  String get reviewIntelligence_sentimentByVersion => 'Sentiment par version';

  @override
  String get reviewIntelligence_openFeatures => 'Fonctionnalités ouvertes';

  @override
  String get reviewIntelligence_openBugs => 'Bugs ouverts';

  @override
  String get reviewIntelligence_highPriority => 'Haute priorité';

  @override
  String get reviewIntelligence_total => 'total';

  @override
  String get reviewIntelligence_mentions => 'mentions';

  @override
  String get reviewIntelligence_noData => 'Pas encore d\'insights';

  @override
  String get reviewIntelligence_noDataHint =>
      'Les insights apparaîtront après l\'analyse des avis';

  @override
  String get analytics_title => 'Analytiques';

  @override
  String get analytics_downloads => 'Téléchargements';

  @override
  String get analytics_revenue => 'Revenus';

  @override
  String get analytics_proceeds => 'Bénéfices';

  @override
  String get analytics_subscribers => 'Abonnés';

  @override
  String get analytics_downloadsOverTime => 'Téléchargements au fil du temps';

  @override
  String get analytics_revenueOverTime => 'Revenus au fil du temps';

  @override
  String get analytics_byCountry => 'Par pays';

  @override
  String get analytics_noData => 'Aucune donnée disponible';

  @override
  String get analytics_noDataTitle => 'Pas de données analytiques';

  @override
  String get analytics_noDataDescription =>
      'Connectez votre compte App Store Connect ou Google Play pour voir les données de ventes et téléchargements réels.';

  @override
  String analytics_dataDelay(String date) {
    return 'Données au $date. Les données Apple ont un délai de 24-48h.';
  }

  @override
  String get analytics_export => 'Exporter CSV';

  @override
  String get funnel_title => 'Entonnoir de conversion';

  @override
  String get funnel_impressions => 'Impressions';

  @override
  String get funnel_pageViews => 'Pages vues';

  @override
  String get funnel_downloads => 'Téléchargements';

  @override
  String get funnel_overallCvr => 'CVR global';

  @override
  String get funnel_categoryAvg => 'Moy. catégorie';

  @override
  String get funnel_vsCategory => 'vs catégorie';

  @override
  String get funnel_bySource => 'Par source';

  @override
  String get funnel_noData => 'Aucune donnée d\'entonnoir disponible';

  @override
  String get funnel_noDataHint =>
      'Les données d\'entonnoir seront synchronisées automatiquement depuis App Store Connect ou Google Play Console.';

  @override
  String get funnel_insight => 'INSIGHT';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return 'Le trafic $bestSource convertit ${ratio}x mieux que $worstSource. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'Concentrez-vous sur l\'optimisation des mots-clés pour augmenter les impressions de recherche.';

  @override
  String get funnel_insightRecommendBrowse =>
      'Améliorez la visibilité de votre app dans la navigation en optimisant les catégories et le placement en vedette.';

  @override
  String get funnel_insightRecommendReferral =>
      'Exploitez les programmes de parrainage et les partenariats pour générer plus de trafic.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      'Envisagez des stratégies de promotion croisée avec des apps complémentaires.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'Optimisez votre site web et vos pages de destination pour les téléchargements.';

  @override
  String get funnel_insightRecommendDefault =>
      'Analysez ce qui rend cette source performante et reproduisez-le.';

  @override
  String get funnel_trendTitle => 'Tendance du taux de conversion';

  @override
  String get funnel_connectStore => 'Connecter le store';

  @override
  String get nav_chat => 'Assistant IA';

  @override
  String get chat_title => 'Assistant IA';

  @override
  String get chat_newConversation => 'Nouvelle conversation';

  @override
  String get chat_loadingConversations => 'Chargement des conversations...';

  @override
  String get chat_loadingMessages => 'Chargement des messages...';

  @override
  String get chat_noConversations => 'Aucune conversation';

  @override
  String get chat_noConversationsDesc =>
      'Démarrez une nouvelle conversation pour obtenir des insights IA sur vos apps';

  @override
  String get chat_startConversation => 'Démarrer une conversation';

  @override
  String get chat_deleteConversation => 'Supprimer la conversation';

  @override
  String get chat_deleteConversationConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette conversation ?';

  @override
  String get chat_askAnything => 'Posez-moi une question';

  @override
  String get chat_askAnythingDesc =>
      'Je peux vous aider à comprendre les avis, classements et analyses de votre app';

  @override
  String get chat_typeMessage => 'Tapez votre question...';

  @override
  String get chat_suggestedQuestions => 'Questions suggérées';

  @override
  String get chatActionConfirm => 'Confirmer';

  @override
  String get chatActionCancel => 'Annuler';

  @override
  String get chatActionExecuting => 'Exécution...';

  @override
  String get chatActionExecuted => 'Terminé';

  @override
  String get chatActionFailed => 'Échec';

  @override
  String get chatActionCancelled => 'Annulé';

  @override
  String get chatActionDownload => 'Télécharger';

  @override
  String get chatActionReversible => 'Cette action peut être annulée';

  @override
  String get chatActionAddKeywords => 'Ajouter des mots-clés';

  @override
  String get chatActionRemoveKeywords => 'Supprimer des mots-clés';

  @override
  String get chatActionCreateAlert => 'Créer une alerte';

  @override
  String get chatActionAddCompetitor => 'Ajouter un concurrent';

  @override
  String get chatActionExportData => 'Exporter les données';

  @override
  String get chatActionKeywords => 'Mots-clés';

  @override
  String get chatActionCountry => 'Pays';

  @override
  String get chatActionAlertCondition => 'Condition';

  @override
  String get chatActionNotifyVia => 'Notifier via';

  @override
  String get chatActionCompetitor => 'Concurrent';

  @override
  String get chatActionExportType => 'Type d\'export';

  @override
  String get chatActionDateRange => 'Période';

  @override
  String get chatActionKeywordsLabel => 'Mots-clés';

  @override
  String get chatActionAnalyticsLabel => 'Statistiques';

  @override
  String get chatActionReviewsLabel => 'Avis';

  @override
  String get common_cancel => 'Annuler';

  @override
  String get common_delete => 'Supprimer';

  @override
  String get appDetail_tabOverview => 'Aperçu';

  @override
  String get appDetail_tabKeywords => 'Mots-clés';

  @override
  String get appDetail_tabReviews => 'Avis';

  @override
  String get appDetail_tabRatings => 'Notes';

  @override
  String get appDetail_tabInsights => 'Analyses';

  @override
  String get dateRange_title => 'Période';

  @override
  String get dateRange_today => 'Aujourd\'hui';

  @override
  String get dateRange_yesterday => 'Hier';

  @override
  String get dateRange_last7Days => '7 derniers jours';

  @override
  String get dateRange_last30Days => '30 derniers jours';

  @override
  String get dateRange_thisMonth => 'Ce mois';

  @override
  String get dateRange_lastMonth => 'Mois dernier';

  @override
  String get dateRange_last90Days => '90 derniers jours';

  @override
  String get dateRange_yearToDate => 'Depuis le début de l\'année';

  @override
  String get dateRange_allTime => 'Tout';

  @override
  String get dateRange_custom => 'Personnalisé...';

  @override
  String get dateRange_compareToPrevious => 'Comparer à la période précédente';

  @override
  String get export_keywordsTitle => 'Exporter les mots-clés';

  @override
  String get export_reviewsTitle => 'Exporter les avis';

  @override
  String get export_analyticsTitle => 'Exporter les analytiques';

  @override
  String get export_columnsToInclude => 'Colonnes à inclure :';

  @override
  String get export_button => 'Exporter';

  @override
  String get export_keyword => 'Mot-clé';

  @override
  String get export_position => 'Position';

  @override
  String get export_change => 'Changement';

  @override
  String get export_popularity => 'Popularité';

  @override
  String get export_difficulty => 'Difficulté';

  @override
  String get export_tags => 'Tags';

  @override
  String get export_notes => 'Notes';

  @override
  String get export_trackedSince => 'Suivi depuis';

  @override
  String get export_date => 'Date';

  @override
  String get export_rating => 'Note';

  @override
  String get export_author => 'Auteur';

  @override
  String get export_title => 'Titre';

  @override
  String get export_content => 'Contenu';

  @override
  String get export_country => 'Pays';

  @override
  String get export_version => 'Version';

  @override
  String get export_sentiment => 'Sentiment';

  @override
  String get export_response => 'Notre réponse';

  @override
  String get export_responseDate => 'Date de réponse';

  @override
  String export_keywordsCount(int count) {
    return '$count mots-clés seront exportés';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count avis seront exportés';
  }

  @override
  String export_success(String filename) {
    return 'Export enregistré : $filename';
  }

  @override
  String export_error(String error) {
    return 'Échec de l\'export : $error';
  }

  @override
  String get metadata_editor => 'Éditeur de métadonnées';

  @override
  String get metadata_selectLocale => 'Sélectionnez une locale à modifier';

  @override
  String get metadata_refreshed => 'Métadonnées actualisées depuis le store';

  @override
  String get metadata_connectRequired => 'Connexion requise pour modifier';

  @override
  String get metadata_connectDescription =>
      'Connectez votre compte App Store Connect pour modifier les métadonnées de votre app directement depuis Keyrank.';

  @override
  String get metadata_connectStore => 'Connecter App Store';

  @override
  String get metadata_publishTitle => 'Publier les métadonnées';

  @override
  String metadata_publishConfirm(String locale) {
    return 'Publier les modifications pour $locale ? Cela mettra à jour la fiche de votre app sur l\'App Store.';
  }

  @override
  String get metadata_publish => 'Publier';

  @override
  String get metadata_publishSuccess => 'Métadonnées publiées avec succès';

  @override
  String get metadata_saveDraft => 'Enregistrer le brouillon';

  @override
  String get metadata_draftSaved => 'Brouillon enregistré';

  @override
  String get metadata_discardChanges => 'Annuler les modifications';

  @override
  String get metadata_title => 'Titre';

  @override
  String metadata_titleHint(int limit) {
    return 'Nom de l\'app (max $limit car.)';
  }

  @override
  String get metadata_subtitle => 'Sous-titre';

  @override
  String metadata_subtitleHint(int limit) {
    return 'Accroche courte (max $limit car.)';
  }

  @override
  String get metadata_keywords => 'Mots-clés';

  @override
  String metadata_keywordsHint(int limit) {
    return 'Mots-clés séparés par des virgules (max $limit car.)';
  }

  @override
  String get metadata_description => 'Description';

  @override
  String metadata_descriptionHint(int limit) {
    return 'Description complète de l\'app (max $limit car.)';
  }

  @override
  String get metadata_promotionalText => 'Texte promotionnel';

  @override
  String metadata_promotionalTextHint(int limit) {
    return 'Message promotionnel court (max $limit car.)';
  }

  @override
  String get metadata_whatsNew => 'Nouveautés';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'Notes de version (max $limit car.)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => 'Modifications non enregistrées';

  @override
  String get metadata_noChanges => 'Aucune modification';

  @override
  String get metadata_keywordAnalysis => 'Analyse des mots-clés';

  @override
  String get metadata_keywordPresent => 'Présent';

  @override
  String get metadata_keywordMissing => 'Manquant';

  @override
  String get metadata_inTitle => 'Dans le titre';

  @override
  String get metadata_inSubtitle => 'Dans le sous-titre';

  @override
  String get metadata_inKeywords => 'Dans les mots-clés';

  @override
  String get metadata_inDescription => 'Dans la description';

  @override
  String get metadata_history => 'Historique des modifications';

  @override
  String get metadata_noHistory => 'Aucune modification enregistrée';

  @override
  String get metadata_localeComplete => 'Complet';

  @override
  String get metadata_localeIncomplete => 'Incomplet';

  @override
  String get metadata_shortDescription => 'Description courte';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return 'Accroche affichée dans la recherche (max $limit car.)';
  }

  @override
  String get metadata_fullDescription => 'Description complète';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'Description complète de l\'app (max $limit car.)';
  }

  @override
  String get metadata_releaseNotes => 'Notes de version';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'Nouveautés de cette version (max $limit car.)';
  }

  @override
  String get metadata_selectAppFirst => 'Sélectionnez une application';

  @override
  String get metadata_selectAppHint =>
      'Utilisez le sélecteur d\'app dans la barre latérale ou connectez un store pour commencer.';

  @override
  String get metadata_noStoreConnection => 'Connexion au store requise';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return 'Connectez votre compte $storeName pour récupérer et modifier les métadonnées de votre app.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return 'Connecter $storeName';
  }

  @override
  String get metadataLocalization => 'Localisations';

  @override
  String get metadataLive => 'En ligne';

  @override
  String get metadataDraft => 'Brouillon';

  @override
  String get metadataEmpty => 'Vide';

  @override
  String metadataCoverageInsight(int count) {
    return '$count locales nécessitent du contenu. Pensez à localiser pour vos marchés principaux.';
  }

  @override
  String get metadataFilterAll => 'Tous';

  @override
  String get metadataFilterLive => 'En ligne';

  @override
  String get metadataFilterDraft => 'Brouillons';

  @override
  String get metadataFilterEmpty => 'Vides';

  @override
  String get metadataBulkActions => 'Actions groupées';

  @override
  String get metadataCopyTo => 'Copier vers la sélection';

  @override
  String get metadataTranslateTo => 'Traduire vers la sélection';

  @override
  String get metadataPublishSelected => 'Publier la sélection';

  @override
  String get metadataDeleteDrafts => 'Supprimer les brouillons';

  @override
  String get metadataSelectSource => 'Sélectionner la locale source';

  @override
  String get metadataSelectTarget => 'Sélectionner les locales cibles';

  @override
  String metadataCopySuccess(int count) {
    return 'Contenu copié vers $count locales';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return 'Traduit vers $count locales';
  }

  @override
  String get metadataTranslating => 'Traduction en cours...';

  @override
  String get metadataNoSelection => 'Sélectionnez d\'abord des locales';

  @override
  String get metadataSelectAll => 'Tout sélectionner';

  @override
  String get metadataDeselectAll => 'Tout désélectionner';

  @override
  String metadataSelected(int count) {
    return '$count sélectionnée(s)';
  }

  @override
  String get metadataTableView => 'Vue tableau';

  @override
  String get metadataListView => 'Vue liste';

  @override
  String get metadataStatus => 'Statut';

  @override
  String get metadataCompletion => 'Complétion';

  @override
  String get common_back => 'Retour';

  @override
  String get common_next => 'Suivant';

  @override
  String get common_edit => 'Modifier';

  @override
  String get metadata_aiOptimize => 'Optimiser avec l\'IA';

  @override
  String get wizard_title => 'Assistant d\'optimisation IA';

  @override
  String get wizard_step => 'Étape';

  @override
  String get wizard_of => 'sur';

  @override
  String get wizard_stepTitle => 'Titre';

  @override
  String get wizard_stepSubtitle => 'Sous-titre';

  @override
  String get wizard_stepKeywords => 'Mots-clés';

  @override
  String get wizard_stepDescription => 'Description';

  @override
  String get wizard_stepReview => 'Révision et enregistrement';

  @override
  String get wizard_skip => 'Passer';

  @override
  String get wizard_saveDrafts => 'Enregistrer les brouillons';

  @override
  String get wizard_draftsSaved => 'Brouillons enregistrés avec succès';

  @override
  String get wizard_exitTitle => 'Quitter l\'assistant ?';

  @override
  String get wizard_exitMessage =>
      'Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir quitter ?';

  @override
  String get wizard_exitConfirm => 'Quitter';

  @override
  String get wizard_aiSuggestions => 'Suggestions IA';

  @override
  String get wizard_chooseSuggestion =>
      'Choisissez une suggestion générée par l\'IA ou écrivez la vôtre';

  @override
  String get wizard_currentValue => 'Valeur actuelle';

  @override
  String get wizard_noCurrentValue => 'Aucune valeur définie';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return 'Basé sur $keywordsCount mots-clés suivis et $competitorsCount concurrents';
  }

  @override
  String get wizard_writeOwn => 'Écrire le mien';

  @override
  String get wizard_customPlaceholder => 'Entrez votre valeur personnalisée...';

  @override
  String get wizard_useCustom => 'Utiliser personnalisé';

  @override
  String get wizard_keepCurrent => 'Garder l\'actuel';

  @override
  String get wizard_recommended => 'Recommandé';

  @override
  String get wizard_characters => 'caractères';

  @override
  String get wizard_reviewTitle => 'Réviser les modifications';

  @override
  String get wizard_reviewDescription =>
      'Révisez vos optimisations avant de les enregistrer comme brouillons';

  @override
  String get wizard_noChanges => 'Aucune modification sélectionnée';

  @override
  String get wizard_noChangesHint =>
      'Revenez en arrière et sélectionnez des suggestions pour les champs à optimiser';

  @override
  String wizard_changesCount(int count) {
    return '$count champs mis à jour';
  }

  @override
  String get wizard_changesSummary =>
      'Ces modifications seront enregistrées comme brouillons';

  @override
  String get wizard_before => 'Avant';

  @override
  String get wizard_after => 'Après';

  @override
  String get wizard_nextStepsTitle => 'Que se passe-t-il ensuite ?';

  @override
  String get wizard_nextStepsWithChanges =>
      'Vos modifications seront enregistrées comme brouillons. Vous pouvez les réviser et les publier depuis l\'éditeur de métadonnées.';

  @override
  String get wizard_nextStepsNoChanges =>
      'Aucune modification à enregistrer. Revenez en arrière et sélectionnez des suggestions pour optimiser vos métadonnées.';

  @override
  String get team_title => 'Gestion d\'équipe';

  @override
  String get team_createTeam => 'Créer une équipe';

  @override
  String get team_teamName => 'Nom de l\'équipe';

  @override
  String get team_teamNameHint => 'Entrez le nom de l\'équipe';

  @override
  String get team_description => 'Description (optionnel)';

  @override
  String get team_descriptionHint => 'À quoi sert cette équipe ?';

  @override
  String get team_teamNameRequired => 'Le nom de l\'équipe est requis';

  @override
  String get team_teamNameMinLength =>
      'Le nom de l\'équipe doit contenir au moins 2 caractères';

  @override
  String get team_inviteMember => 'Inviter un membre';

  @override
  String get team_emailAddress => 'Adresse e-mail';

  @override
  String get team_emailHint => 'collegue@exemple.com';

  @override
  String get team_emailRequired => 'L\'e-mail est requis';

  @override
  String get team_emailInvalid => 'Entrez une adresse e-mail valide';

  @override
  String team_invitationSent(String email) {
    return 'Invitation envoyée à $email';
  }

  @override
  String get team_members => 'MEMBRES';

  @override
  String get team_invite => 'Inviter';

  @override
  String get team_pendingInvitations => 'INVITATIONS EN ATTENTE';

  @override
  String get team_noPendingInvitations => 'Aucune invitation en attente';

  @override
  String get team_teamSettings => 'Paramètres de l\'équipe';

  @override
  String team_changeRole(String name) {
    return 'Changer le rôle de $name';
  }

  @override
  String get team_removeMember => 'Retirer le membre';

  @override
  String team_removeMemberConfirm(String name) {
    return 'Êtes-vous sûr de vouloir retirer $name de cette équipe ?';
  }

  @override
  String get team_remove => 'Retirer';

  @override
  String get team_leaveTeam => 'Quitter l\'équipe';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return 'Êtes-vous sûr de vouloir quitter « $teamName » ?';
  }

  @override
  String get team_leave => 'Quitter';

  @override
  String get team_deleteTeam => 'Supprimer l\'équipe';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return 'Êtes-vous sûr de vouloir supprimer « $teamName » ? Cette action est irréversible.';
  }

  @override
  String get team_yourTeams => 'VOS ÉQUIPES';

  @override
  String get team_failedToLoadTeam => 'Échec du chargement de l\'équipe';

  @override
  String get team_failedToLoadMembers => 'Échec du chargement des membres';

  @override
  String get team_failedToLoadInvitations =>
      'Échec du chargement des invitations';

  @override
  String team_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String team_invitedAs(String role) {
    return 'Invité en tant que $role';
  }

  @override
  String team_joinedTeam(String teamName) {
    return 'Rejoint $teamName';
  }

  @override
  String get team_invitationDeclined => 'Invitation refusée';

  @override
  String get team_noTeamsYet => 'Pas encore d\'équipes';

  @override
  String get team_noTeamsDescription =>
      'Créez une équipe pour collaborer avec d\'autres sur vos applications';

  @override
  String get team_createFirstTeam => 'Créer votre première équipe';

  @override
  String get integrations_title => 'Intégrations';

  @override
  String integrations_syncFailed(String error) {
    return 'Échec de la synchronisation : $error';
  }

  @override
  String get integrations_disconnectConfirm => 'Déconnecter ?';

  @override
  String get integrations_disconnectedSuccess => 'Déconnecté avec succès';

  @override
  String get integrations_connectGooglePlay => 'Connecter Google Play Console';

  @override
  String get integrations_connectAppStore => 'Connecter App Store Connect';

  @override
  String integrations_connectedApps(int count) {
    return 'Connecté ! $count apps importées.';
  }

  @override
  String integrations_syncedApps(int count) {
    return '$count apps synchronisées comme propriétaire';
  }

  @override
  String get integrations_appStoreConnected =>
      'App Store Connect connecté avec succès !';

  @override
  String get integrations_googlePlayConnected =>
      'Google Play Console connecté avec succès !';

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
  String get alertBuilder_nameYourRule => 'NOMMEZ VOTRE RÈGLE';

  @override
  String get alertBuilder_nameDescription =>
      'Donnez un nom descriptif à votre règle d\'alerte';

  @override
  String get alertBuilder_nameHint => 'ex : Alerte position quotidienne';

  @override
  String get alertBuilder_summary => 'RÉSUMÉ';

  @override
  String get alertBuilder_saveAlertRule => 'Enregistrer la règle d\'alerte';

  @override
  String get alertBuilder_selectAlertType => 'SÉLECTIONNER LE TYPE D\'ALERTE';

  @override
  String get alertBuilder_selectAlertTypeDescription =>
      'Choisissez le type d\'alerte que vous souhaitez créer';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return 'Cela supprimera « $ruleName ».';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate =>
      'Aucune règle pour le moment. Activez un modèle ou créez la vôtre !';

  @override
  String get billing_cancelSubscription => 'Annuler l\'abonnement';

  @override
  String get billing_keepSubscription => 'Conserver l\'abonnement';

  @override
  String get billing_billingPortal => 'Portail de facturation';

  @override
  String get billing_resume => 'Reprendre';

  @override
  String get keywords_noCompetitorsFound =>
      'Aucun concurrent trouvé. Ajoutez d\'abord des concurrents.';

  @override
  String get keywords_noCompetitorsForApp =>
      'Aucun concurrent pour cette app. Ajoutez d\'abord un concurrent.';

  @override
  String keywords_failedToAddKeywords(String error) {
    return 'Échec de l\'ajout des mots-clés : $error';
  }

  @override
  String get keywords_bulkAddHint =>
      'suivi budget\ngestionnaire dépenses\napp argent';

  @override
  String get appOverview_urlCopied =>
      'URL du store copiée dans le presse-papiers';

  @override
  String get country_us => 'États-Unis';

  @override
  String get country_gb => 'Royaume-Uni';

  @override
  String get country_fr => 'France';

  @override
  String get country_de => 'Allemagne';

  @override
  String get country_ca => 'Canada';

  @override
  String get country_au => 'Australie';

  @override
  String get country_jp => 'Japon';

  @override
  String get country_cn => 'Chine';

  @override
  String get country_kr => 'Corée du Sud';

  @override
  String get country_br => 'Brésil';

  @override
  String get country_es => 'Espagne';

  @override
  String get country_it => 'Italie';

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
  String get alertBuilder_type => 'Type';

  @override
  String get alertBuilder_scope => 'Portée';

  @override
  String get alertBuilder_name => 'Nom';

  @override
  String get alertBuilder_scopeGlobal => 'Toutes les apps';

  @override
  String get alertBuilder_scopeApp => 'App spécifique';

  @override
  String get alertBuilder_scopeCategory => 'Catégorie';

  @override
  String get alertBuilder_scopeKeyword => 'Mot-clé';

  @override
  String get alertType_positionChange => 'Changement de position';

  @override
  String get alertType_positionChangeDesc =>
      'Alerte quand le rang de l\'app change significativement';

  @override
  String get alertType_ratingChange => 'Changement de note';

  @override
  String get alertType_ratingChangeDesc =>
      'Alerte quand la note de l\'app change';

  @override
  String get alertType_reviewSpike => 'Pic d\'avis';

  @override
  String get alertType_reviewSpikeDesc =>
      'Alerte lors d\'une activité inhabituelle d\'avis';

  @override
  String get alertType_reviewKeyword => 'Mot-clé dans les avis';

  @override
  String get alertType_reviewKeywordDesc =>
      'Alerte quand des mots-clés apparaissent dans les avis';

  @override
  String get alertType_newCompetitor => 'Nouveau concurrent';

  @override
  String get alertType_newCompetitorDesc =>
      'Alerte quand de nouvelles apps entrent dans votre espace';

  @override
  String get alertType_competitorPassed => 'Concurrent dépassé';

  @override
  String get alertType_competitorPassedDesc =>
      'Alerte quand vous dépassez un concurrent';

  @override
  String get alertType_massMovement => 'Mouvement de masse';

  @override
  String get alertType_massMovementDesc =>
      'Alerte lors de grands changements de classement';

  @override
  String get alertType_keywordTrend => 'Tendance mot-clé';

  @override
  String get alertType_keywordTrendDesc =>
      'Alerte quand la popularité d\'un mot-clé change';

  @override
  String get alertType_opportunity => 'Opportunité';

  @override
  String get alertType_opportunityDesc =>
      'Alerte sur de nouvelles opportunités de classement';

  @override
  String get billing_title => 'Facturation & Plans';

  @override
  String get billing_subscriptionActivated => 'Abonnement activé avec succès !';

  @override
  String get billing_changePlan => 'Changer de plan';

  @override
  String get billing_choosePlan => 'Choisir un plan';

  @override
  String get billing_cancelMessage =>
      'Votre abonnement restera actif jusqu\'à la fin de la période de facturation actuelle. Après cela, vous perdrez l\'accès aux fonctionnalités premium.';

  @override
  String get billing_currentPlan => 'PLAN ACTUEL';

  @override
  String get billing_trial => 'ESSAI';

  @override
  String get billing_canceling => 'ANNULATION';

  @override
  String billing_accessUntil(String date) {
    return 'Accès jusqu\'au $date';
  }

  @override
  String billing_renewsOn(String date) {
    return 'Renouvellement le $date';
  }

  @override
  String get billing_manageSubscription => 'GÉRER L\'ABONNEMENT';

  @override
  String get billing_monthly => 'Mensuel';

  @override
  String get billing_yearly => 'Annuel';

  @override
  String billing_savePercent(int percent) {
    return 'Économisez $percent%';
  }

  @override
  String get billing_current => 'Actuel';

  @override
  String get billing_apps => 'Apps';

  @override
  String get billing_unlimited => 'Illimité';

  @override
  String get billing_keywordsPerApp => 'Mots-clés par app';

  @override
  String get billing_history => 'Historique';

  @override
  String billing_days(int count) {
    return '$count jours';
  }

  @override
  String get billing_exports => 'Exports';

  @override
  String get billing_aiInsights => 'Analyses IA';

  @override
  String get billing_apiAccess => 'Accès API';

  @override
  String get billing_yes => 'Oui';

  @override
  String get billing_no => 'Non';

  @override
  String get billing_currentPlanButton => 'Plan actuel';

  @override
  String billing_upgradeTo(String planName) {
    return 'Passer à $planName';
  }

  @override
  String get billing_cancel => 'Annuler';

  @override
  String get keywords_compareWithCompetitor => 'Comparer avec un concurrent';

  @override
  String get keywords_selectCompetitorToCompare =>
      'Sélectionnez un concurrent pour comparer les mots-clés :';

  @override
  String get keywords_addToCompetitor => 'Ajouter au concurrent';

  @override
  String keywords_addKeywordsTo(int count) {
    return 'Ajouter $count mot(s)-clé(s) à :';
  }

  @override
  String get keywords_avgPosition => 'Position moy.';

  @override
  String get keywords_declined => 'En baisse';

  @override
  String get keywords_total => 'Total';

  @override
  String get keywords_ranked => 'Classés';

  @override
  String get keywords_improved => 'En hausse';

  @override
  String get onboarding_skip => 'Passer';

  @override
  String get onboarding_back => 'Retour';

  @override
  String get onboarding_continue => 'Continuer';

  @override
  String get onboarding_getStarted => 'Commencer';

  @override
  String get onboarding_welcomeToKeyrank => 'Bienvenue sur Keyrank';

  @override
  String get onboarding_welcomeSubtitle =>
      'Suivez le classement de vos apps, gérez les avis et optimisez votre stratégie ASO.';

  @override
  String get onboarding_connectStore => 'Connectez votre Store';

  @override
  String get onboarding_connectStoreSubtitle =>
      'Optionnel : connectez-vous pour importer des apps et répondre aux avis.';

  @override
  String get onboarding_couldNotLoadIntegrations =>
      'Impossible de charger les intégrations';

  @override
  String get onboarding_tapToConnect => 'Appuyez pour connecter';

  @override
  String get onboarding_allSet => 'Vous êtes prêt !';

  @override
  String get onboarding_allSetSubtitle =>
      'Commencez par ajouter une app à suivre ou explorez l\'inspecteur de mots-clés.';

  @override
  String get team_you => 'Vous';

  @override
  String get team_changeRoleButton => 'Changer le rôle';

  @override
  String get team_removeButton => 'Supprimer';

  @override
  String get competitors_removeTitle => 'Supprimer le concurrent';

  @override
  String competitors_removeConfirm(String name) {
    return 'Êtes-vous sûr de vouloir supprimer « $name » de vos concurrents ?';
  }

  @override
  String competitors_removed(String name) {
    return '$name supprimé';
  }

  @override
  String competitors_removeFailed(String error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String get competitors_addCompetitor => 'Ajouter un concurrent';

  @override
  String get competitors_filterAll => 'Tous';

  @override
  String get competitors_filterGlobal => 'Globaux';

  @override
  String get competitors_filterContextual => 'Contextuels';

  @override
  String get competitors_noCompetitorsYet => 'Aucun concurrent suivi';

  @override
  String get competitors_noGlobalCompetitors => 'Aucun concurrent global';

  @override
  String get competitors_noContextualCompetitors =>
      'Aucun concurrent contextuel';

  @override
  String get competitors_emptySubtitleAll =>
      'Recherchez des apps et ajoutez-les comme concurrents pour suivre leurs classements';

  @override
  String get competitors_emptySubtitleGlobal =>
      'Les concurrents globaux apparaissent pour toutes vos apps';

  @override
  String get competitors_emptySubtitleContextual =>
      'Les concurrents contextuels sont liés à des apps spécifiques';

  @override
  String get competitors_searchForCompetitors => 'Rechercher des concurrents';

  @override
  String get competitors_viewKeywords => 'Voir les mots-clés';

  @override
  String get common_remove => 'Supprimer';

  @override
  String get competitors_addTitle => 'Ajouter un concurrent';

  @override
  String competitors_addedAsCompetitor(String name) {
    return '$name ajouté comme concurrent';
  }

  @override
  String competitors_addFailed(String error) {
    return 'Échec de l\'ajout du concurrent : $error';
  }

  @override
  String get competitors_searchForCompetitor => 'Rechercher un concurrent';

  @override
  String get appPreview_back => 'Retour';

  @override
  String get alerts_edit => 'Modifier';

  @override
  String get alerts_scopeGlobal => 'Toutes les apps';

  @override
  String get alerts_scopeApp => 'App spécifique';

  @override
  String get alerts_scopeCategory => 'Catégorie';

  @override
  String get alerts_scopeKeyword => 'Mot-clé';

  @override
  String ratings_showMore(int count) {
    return 'Afficher plus ($count restants)';
  }

  @override
  String get ratings_showLess => 'Afficher moins';

  @override
  String get insights_aiInsights => 'Analyses IA';

  @override
  String get insights_viewAll => 'Tout voir';

  @override
  String insights_viewMore(int count) {
    return 'Voir $count analyses de plus';
  }

  @override
  String get insights_noInsightsDesc =>
      'Les analyses IA apparaîtront ici au fur et à mesure de l\'analyse de vos apps';

  @override
  String get insights_loadFailed => 'Échec du chargement des analyses';

  @override
  String chat_createFailed(String error) {
    return 'Échec de la création de la conversation : $error';
  }

  @override
  String chat_deleteFailed(String error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String get notifications_manageAlerts => 'Gérer les alertes';
}
