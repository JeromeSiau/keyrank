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
}
