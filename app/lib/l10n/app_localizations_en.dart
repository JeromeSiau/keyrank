// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Track your App Store rankings';

  @override
  String get auth_welcomeBack => 'Welcome back';

  @override
  String get auth_signInSubtitle => 'Sign in to your account';

  @override
  String get auth_createAccount => 'Create account';

  @override
  String get auth_createAccountSubtitle => 'Start tracking your rankings';

  @override
  String get auth_emailLabel => 'Email';

  @override
  String get auth_passwordLabel => 'Password';

  @override
  String get auth_nameLabel => 'Name';

  @override
  String get auth_confirmPasswordLabel => 'Confirm password';

  @override
  String get auth_signInButton => 'Sign in';

  @override
  String get auth_signUpButton => 'Create account';

  @override
  String get auth_noAccount => 'Don\'t have an account?';

  @override
  String get auth_hasAccount => 'Already have an account?';

  @override
  String get auth_signUpLink => 'Sign up';

  @override
  String get auth_signInLink => 'Sign in';

  @override
  String get auth_emailRequired => 'Please enter your email';

  @override
  String get auth_emailInvalid => 'Invalid email';

  @override
  String get auth_passwordRequired => 'Please enter your password';

  @override
  String get auth_enterPassword => 'Please enter a password';

  @override
  String get auth_nameRequired => 'Please enter your name';

  @override
  String get auth_passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get auth_passwordsNoMatch => 'Passwords do not match';

  @override
  String get auth_errorOccurred => 'An error occurred';

  @override
  String get common_retry => 'Retry';

  @override
  String common_error(String message) {
    return 'Error: $message';
  }

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_add => 'Add';

  @override
  String get common_filter => 'Filter';

  @override
  String get common_sort => 'Sort';

  @override
  String get common_refresh => 'Refresh';

  @override
  String get common_settings => 'Settings';

  @override
  String get dashboard_title => 'Dashboard';

  @override
  String get dashboard_addApp => 'Add App';

  @override
  String get dashboard_appsTracked => 'Apps Tracked';

  @override
  String get dashboard_keywords => 'Keywords';

  @override
  String get dashboard_avgPosition => 'Avg Position';

  @override
  String get dashboard_top10 => 'Top 10';

  @override
  String get dashboard_trackedApps => 'Tracked Apps';

  @override
  String get dashboard_quickActions => 'Quick Actions';

  @override
  String get dashboard_addNewApp => 'Add a new app';

  @override
  String get dashboard_searchKeywords => 'Search keywords';

  @override
  String get dashboard_viewAllApps => 'View all apps';

  @override
  String get dashboard_noAppsYet => 'No apps tracked yet';

  @override
  String get dashboard_addAppToStart => 'Add an app to start tracking keywords';

  @override
  String get dashboard_noAppsMatchFilter => 'No apps match filter';

  @override
  String get dashboard_changeFilterCriteria =>
      'Try changing the filter criteria';

  @override
  String get apps_title => 'My Apps';

  @override
  String apps_appCount(int count) {
    return '$count apps';
  }

  @override
  String get apps_tableApp => 'APP';

  @override
  String get apps_tableDeveloper => 'DEVELOPER';

  @override
  String get apps_tableKeywords => 'KEYWORDS';

  @override
  String get apps_tablePlatform => 'PLATFORM';

  @override
  String get apps_tableRating => 'RATING';

  @override
  String get apps_tableBestRank => 'BEST RANK';

  @override
  String get apps_noAppsYet => 'No apps tracked yet';

  @override
  String get apps_addAppToStart => 'Add an app to start tracking its rankings';

  @override
  String get addApp_title => 'Add App';

  @override
  String get addApp_searchAppStore => 'Search App Store...';

  @override
  String get addApp_searchPlayStore => 'Search Play Store...';

  @override
  String get addApp_searchForApp => 'Search for an app';

  @override
  String get addApp_enterAtLeast2Chars => 'Enter at least 2 characters';

  @override
  String get addApp_noResults => 'No results found';

  @override
  String addApp_addedSuccess(String name) {
    return '$name added successfully';
  }

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_appearance => 'Appearance';

  @override
  String get settings_theme => 'Theme';

  @override
  String get settings_themeSystem => 'System';

  @override
  String get settings_themeDark => 'Dark';

  @override
  String get settings_themeLight => 'Light';

  @override
  String get settings_account => 'Account';

  @override
  String get settings_memberSince => 'Member since';

  @override
  String get settings_logout => 'Log out';

  @override
  String get settings_languageSystem => 'System';

  @override
  String get filter_all => 'All';

  @override
  String get filter_allApps => 'All Apps';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'iOS Only';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Android Only';

  @override
  String get filter_favorites => 'Favorites';

  @override
  String get sort_recent => 'Recent';

  @override
  String get sort_recentlyAdded => 'Recently Added';

  @override
  String get sort_nameAZ => 'Name A-Z';

  @override
  String get sort_nameZA => 'Name Z-A';

  @override
  String get sort_keywords => 'Keywords';

  @override
  String get sort_mostKeywords => 'Most Keywords';

  @override
  String get sort_bestRank => 'Best Rank';

  @override
  String get userMenu_logout => 'Log out';
}
