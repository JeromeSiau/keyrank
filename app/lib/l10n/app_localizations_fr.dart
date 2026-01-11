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
  String get dashboard_sentimentOverview => 'Apercu du sentiment';

  @override
  String get dashboard_overallSentiment => 'Sentiment global';

  @override
  String get dashboard_positive => 'Positif';

  @override
  String get dashboard_positiveReviews => 'Positif';

  @override
  String get dashboard_negativeReviews => 'Negatif';

  @override
  String get dashboard_viewReviews => 'Voir les avis';

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
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get appDetail_tabOverview => 'Apercu';

  @override
  String get appDetail_tabKeywords => 'Mots-cles';

  @override
  String get appDetail_tabReviews => 'Avis';

  @override
  String get appDetail_tabRatings => 'Notes';

  @override
  String get appDetail_tabInsights => 'Analyses';
}
