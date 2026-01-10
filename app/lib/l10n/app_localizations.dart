import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Track your App Store rankings'**
  String get appTagline;

  /// No description provided for @auth_welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get auth_welcomeBack;

  /// No description provided for @auth_signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get auth_signInSubtitle;

  /// No description provided for @auth_createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get auth_createAccount;

  /// No description provided for @auth_createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your rankings'**
  String get auth_createAccountSubtitle;

  /// No description provided for @auth_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_emailLabel;

  /// No description provided for @auth_passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_passwordLabel;

  /// No description provided for @auth_nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get auth_nameLabel;

  /// No description provided for @auth_confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get auth_confirmPasswordLabel;

  /// No description provided for @auth_signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_signInButton;

  /// No description provided for @auth_signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get auth_signUpButton;

  /// No description provided for @auth_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get auth_noAccount;

  /// No description provided for @auth_hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get auth_hasAccount;

  /// No description provided for @auth_signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get auth_signUpLink;

  /// No description provided for @auth_signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_signInLink;

  /// No description provided for @auth_emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get auth_emailRequired;

  /// No description provided for @auth_emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get auth_emailInvalid;

  /// No description provided for @auth_passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get auth_passwordRequired;

  /// No description provided for @auth_enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get auth_enterPassword;

  /// No description provided for @auth_nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get auth_nameRequired;

  /// No description provided for @auth_passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get auth_passwordMinLength;

  /// No description provided for @auth_passwordsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get auth_passwordsNoMatch;

  /// No description provided for @auth_errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get auth_errorOccurred;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String common_error(String message);

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get common_add;

  /// No description provided for @common_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get common_filter;

  /// No description provided for @common_sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get common_sort;

  /// No description provided for @common_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get common_refresh;

  /// No description provided for @common_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get common_settings;

  /// No description provided for @dashboard_title.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard_title;

  /// No description provided for @dashboard_addApp.
  ///
  /// In en, this message translates to:
  /// **'Add App'**
  String get dashboard_addApp;

  /// No description provided for @dashboard_appsTracked.
  ///
  /// In en, this message translates to:
  /// **'Apps Tracked'**
  String get dashboard_appsTracked;

  /// No description provided for @dashboard_keywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get dashboard_keywords;

  /// No description provided for @dashboard_avgPosition.
  ///
  /// In en, this message translates to:
  /// **'Avg Position'**
  String get dashboard_avgPosition;

  /// No description provided for @dashboard_top10.
  ///
  /// In en, this message translates to:
  /// **'Top 10'**
  String get dashboard_top10;

  /// No description provided for @dashboard_trackedApps.
  ///
  /// In en, this message translates to:
  /// **'Tracked Apps'**
  String get dashboard_trackedApps;

  /// No description provided for @dashboard_quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboard_quickActions;

  /// No description provided for @dashboard_addNewApp.
  ///
  /// In en, this message translates to:
  /// **'Add a new app'**
  String get dashboard_addNewApp;

  /// No description provided for @dashboard_searchKeywords.
  ///
  /// In en, this message translates to:
  /// **'Search keywords'**
  String get dashboard_searchKeywords;

  /// No description provided for @dashboard_viewAllApps.
  ///
  /// In en, this message translates to:
  /// **'View all apps'**
  String get dashboard_viewAllApps;

  /// No description provided for @dashboard_noAppsYet.
  ///
  /// In en, this message translates to:
  /// **'No apps tracked yet'**
  String get dashboard_noAppsYet;

  /// No description provided for @dashboard_addAppToStart.
  ///
  /// In en, this message translates to:
  /// **'Add an app to start tracking keywords'**
  String get dashboard_addAppToStart;

  /// No description provided for @dashboard_noAppsMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No apps match filter'**
  String get dashboard_noAppsMatchFilter;

  /// No description provided for @dashboard_changeFilterCriteria.
  ///
  /// In en, this message translates to:
  /// **'Try changing the filter criteria'**
  String get dashboard_changeFilterCriteria;

  /// No description provided for @apps_title.
  ///
  /// In en, this message translates to:
  /// **'My Apps'**
  String get apps_title;

  /// No description provided for @apps_appCount.
  ///
  /// In en, this message translates to:
  /// **'{count} apps'**
  String apps_appCount(int count);

  /// No description provided for @apps_tableApp.
  ///
  /// In en, this message translates to:
  /// **'APP'**
  String get apps_tableApp;

  /// No description provided for @apps_tableDeveloper.
  ///
  /// In en, this message translates to:
  /// **'DEVELOPER'**
  String get apps_tableDeveloper;

  /// No description provided for @apps_tableKeywords.
  ///
  /// In en, this message translates to:
  /// **'KEYWORDS'**
  String get apps_tableKeywords;

  /// No description provided for @apps_tablePlatform.
  ///
  /// In en, this message translates to:
  /// **'PLATFORM'**
  String get apps_tablePlatform;

  /// No description provided for @apps_tableRating.
  ///
  /// In en, this message translates to:
  /// **'RATING'**
  String get apps_tableRating;

  /// No description provided for @apps_tableBestRank.
  ///
  /// In en, this message translates to:
  /// **'BEST RANK'**
  String get apps_tableBestRank;

  /// No description provided for @apps_noAppsYet.
  ///
  /// In en, this message translates to:
  /// **'No apps tracked yet'**
  String get apps_noAppsYet;

  /// No description provided for @apps_addAppToStart.
  ///
  /// In en, this message translates to:
  /// **'Add an app to start tracking its rankings'**
  String get apps_addAppToStart;

  /// No description provided for @addApp_title.
  ///
  /// In en, this message translates to:
  /// **'Add App'**
  String get addApp_title;

  /// No description provided for @addApp_searchAppStore.
  ///
  /// In en, this message translates to:
  /// **'Search App Store...'**
  String get addApp_searchAppStore;

  /// No description provided for @addApp_searchPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Search Play Store...'**
  String get addApp_searchPlayStore;

  /// No description provided for @addApp_searchForApp.
  ///
  /// In en, this message translates to:
  /// **'Search for an app'**
  String get addApp_searchForApp;

  /// No description provided for @addApp_enterAtLeast2Chars.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 2 characters'**
  String get addApp_enterAtLeast2Chars;

  /// No description provided for @addApp_noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get addApp_noResults;

  /// No description provided for @addApp_addedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} added successfully'**
  String addApp_addedSuccess(String name);

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearance;

  /// No description provided for @settings_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme;

  /// No description provided for @settings_themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_themeSystem;

  /// No description provided for @settings_themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_themeDark;

  /// No description provided for @settings_themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_themeLight;

  /// No description provided for @settings_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_account;

  /// No description provided for @settings_memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get settings_memberSince;

  /// No description provided for @settings_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settings_logout;

  /// No description provided for @settings_languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_languageSystem;

  /// No description provided for @filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filter_all;

  /// No description provided for @filter_allApps.
  ///
  /// In en, this message translates to:
  /// **'All Apps'**
  String get filter_allApps;

  /// No description provided for @filter_ios.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get filter_ios;

  /// No description provided for @filter_iosOnly.
  ///
  /// In en, this message translates to:
  /// **'iOS Only'**
  String get filter_iosOnly;

  /// No description provided for @filter_android.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get filter_android;

  /// No description provided for @filter_androidOnly.
  ///
  /// In en, this message translates to:
  /// **'Android Only'**
  String get filter_androidOnly;

  /// No description provided for @filter_favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get filter_favorites;

  /// No description provided for @sort_recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get sort_recent;

  /// No description provided for @sort_recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get sort_recentlyAdded;

  /// No description provided for @sort_nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name A-Z'**
  String get sort_nameAZ;

  /// No description provided for @sort_nameZA.
  ///
  /// In en, this message translates to:
  /// **'Name Z-A'**
  String get sort_nameZA;

  /// No description provided for @sort_keywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get sort_keywords;

  /// No description provided for @sort_mostKeywords.
  ///
  /// In en, this message translates to:
  /// **'Most Keywords'**
  String get sort_mostKeywords;

  /// No description provided for @sort_bestRank.
  ///
  /// In en, this message translates to:
  /// **'Best Rank'**
  String get sort_bestRank;

  /// No description provided for @userMenu_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get userMenu_logout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
