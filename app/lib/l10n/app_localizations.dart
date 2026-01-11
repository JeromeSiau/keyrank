import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('tr'),
    Locale('zh'),
  ];

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

  /// No description provided for @common_search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get common_search;

  /// No description provided for @common_noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get common_noResults;

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

  /// No description provided for @insights_compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare Insights'**
  String get insights_compareTitle;

  /// No description provided for @insights_analyzingReviews.
  ///
  /// In en, this message translates to:
  /// **'Analyzing reviews...'**
  String get insights_analyzingReviews;

  /// No description provided for @insights_noInsightsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No insights available'**
  String get insights_noInsightsAvailable;

  /// No description provided for @insights_strengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get insights_strengths;

  /// No description provided for @insights_weaknesses.
  ///
  /// In en, this message translates to:
  /// **'Weaknesses'**
  String get insights_weaknesses;

  /// No description provided for @insights_scores.
  ///
  /// In en, this message translates to:
  /// **'Scores'**
  String get insights_scores;

  /// No description provided for @insights_opportunities.
  ///
  /// In en, this message translates to:
  /// **'Opportunities'**
  String get insights_opportunities;

  /// No description provided for @insights_categoryUx.
  ///
  /// In en, this message translates to:
  /// **'UX'**
  String get insights_categoryUx;

  /// No description provided for @insights_categoryPerf.
  ///
  /// In en, this message translates to:
  /// **'Perf'**
  String get insights_categoryPerf;

  /// No description provided for @insights_categoryFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get insights_categoryFeatures;

  /// No description provided for @insights_categoryPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get insights_categoryPricing;

  /// No description provided for @insights_categorySupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get insights_categorySupport;

  /// No description provided for @insights_categoryOnboard.
  ///
  /// In en, this message translates to:
  /// **'Onboard'**
  String get insights_categoryOnboard;

  /// No description provided for @insights_categoryUxFull.
  ///
  /// In en, this message translates to:
  /// **'UX / Interface'**
  String get insights_categoryUxFull;

  /// No description provided for @insights_categoryPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get insights_categoryPerformance;

  /// No description provided for @insights_categoryOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get insights_categoryOnboarding;

  /// No description provided for @insights_reviewInsights.
  ///
  /// In en, this message translates to:
  /// **'Review Insights'**
  String get insights_reviewInsights;

  /// No description provided for @insights_generateFirst.
  ///
  /// In en, this message translates to:
  /// **'Generate insights first'**
  String get insights_generateFirst;

  /// No description provided for @insights_compareWithOther.
  ///
  /// In en, this message translates to:
  /// **'Compare with other apps'**
  String get insights_compareWithOther;

  /// No description provided for @insights_compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get insights_compare;

  /// No description provided for @insights_generateAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Generate Analysis'**
  String get insights_generateAnalysis;

  /// No description provided for @insights_period.
  ///
  /// In en, this message translates to:
  /// **'Period:'**
  String get insights_period;

  /// No description provided for @insights_3months.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get insights_3months;

  /// No description provided for @insights_6months.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get insights_6months;

  /// No description provided for @insights_12months.
  ///
  /// In en, this message translates to:
  /// **'12 months'**
  String get insights_12months;

  /// No description provided for @insights_analyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get insights_analyze;

  /// No description provided for @insights_reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String insights_reviewsCount(int count);

  /// No description provided for @insights_analyzedAgo.
  ///
  /// In en, this message translates to:
  /// **'Analyzed {time}'**
  String insights_analyzedAgo(String time);

  /// No description provided for @insights_yourNotes.
  ///
  /// In en, this message translates to:
  /// **'Your Notes'**
  String get insights_yourNotes;

  /// No description provided for @insights_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get insights_save;

  /// No description provided for @insights_clickToAddNotes.
  ///
  /// In en, this message translates to:
  /// **'Click to add notes...'**
  String get insights_clickToAddNotes;

  /// No description provided for @insights_noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get insights_noteSaved;

  /// No description provided for @insights_noteHint.
  ///
  /// In en, this message translates to:
  /// **'Add your notes about this insight analysis...'**
  String get insights_noteHint;

  /// No description provided for @insights_categoryScores.
  ///
  /// In en, this message translates to:
  /// **'Category Scores'**
  String get insights_categoryScores;

  /// No description provided for @insights_emergentThemes.
  ///
  /// In en, this message translates to:
  /// **'Emergent Themes'**
  String get insights_emergentThemes;

  /// No description provided for @insights_exampleQuotes.
  ///
  /// In en, this message translates to:
  /// **'Example quotes:'**
  String get insights_exampleQuotes;

  /// No description provided for @insights_selectCountryFirst.
  ///
  /// In en, this message translates to:
  /// **'Select at least one country'**
  String get insights_selectCountryFirst;

  /// No description provided for @compare_selectAppsToCompare.
  ///
  /// In en, this message translates to:
  /// **'Select up to 3 apps to compare with {appName}'**
  String compare_selectAppsToCompare(String appName);

  /// No description provided for @compare_searchApps.
  ///
  /// In en, this message translates to:
  /// **'Search apps...'**
  String get compare_searchApps;

  /// No description provided for @compare_noOtherApps.
  ///
  /// In en, this message translates to:
  /// **'No other apps to compare'**
  String get compare_noOtherApps;

  /// No description provided for @compare_noMatchingApps.
  ///
  /// In en, this message translates to:
  /// **'No matching apps'**
  String get compare_noMatchingApps;

  /// No description provided for @compare_appsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} of 3 apps selected'**
  String compare_appsSelected(int count);

  /// No description provided for @compare_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get compare_cancel;

  /// No description provided for @compare_button.
  ///
  /// In en, this message translates to:
  /// **'Compare {count} Apps'**
  String compare_button(int count);

  /// No description provided for @appDetail_deleteAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete app?'**
  String get appDetail_deleteAppTitle;

  /// No description provided for @appDetail_deleteAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get appDetail_deleteAppConfirm;

  /// No description provided for @appDetail_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get appDetail_cancel;

  /// No description provided for @appDetail_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get appDetail_delete;

  /// No description provided for @appDetail_exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting rankings...'**
  String get appDetail_exporting;

  /// No description provided for @appDetail_savedFile.
  ///
  /// In en, this message translates to:
  /// **'Saved: {filename}'**
  String appDetail_savedFile(String filename);

  /// No description provided for @appDetail_showInFinder.
  ///
  /// In en, this message translates to:
  /// **'Show in Finder'**
  String get appDetail_showInFinder;

  /// No description provided for @appDetail_exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String appDetail_exportFailed(String error);

  /// No description provided for @appDetail_importedKeywords.
  ///
  /// In en, this message translates to:
  /// **'Imported {imported} keywords ({skipped} skipped)'**
  String appDetail_importedKeywords(int imported, int skipped);

  /// No description provided for @appDetail_favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get appDetail_favorite;

  /// No description provided for @appDetail_ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get appDetail_ratings;

  /// No description provided for @appDetail_insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get appDetail_insights;

  /// No description provided for @appDetail_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get appDetail_import;

  /// No description provided for @appDetail_export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get appDetail_export;

  /// No description provided for @appDetail_reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String appDetail_reviewsCount(int count);

  /// No description provided for @appDetail_keywords.
  ///
  /// In en, this message translates to:
  /// **'keywords'**
  String get appDetail_keywords;

  /// No description provided for @appDetail_addKeyword.
  ///
  /// In en, this message translates to:
  /// **'Add keyword'**
  String get appDetail_addKeyword;

  /// No description provided for @appDetail_keywordHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., fitness tracker'**
  String get appDetail_keywordHint;

  /// No description provided for @appDetail_trackedKeywords.
  ///
  /// In en, this message translates to:
  /// **'Tracked Keywords'**
  String get appDetail_trackedKeywords;

  /// No description provided for @appDetail_selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String appDetail_selectedCount(int count);

  /// No description provided for @appDetail_allKeywords.
  ///
  /// In en, this message translates to:
  /// **'All Keywords'**
  String get appDetail_allKeywords;

  /// No description provided for @appDetail_hasTags.
  ///
  /// In en, this message translates to:
  /// **'Has Tags'**
  String get appDetail_hasTags;

  /// No description provided for @appDetail_hasNotes.
  ///
  /// In en, this message translates to:
  /// **'Has Notes'**
  String get appDetail_hasNotes;

  /// No description provided for @appDetail_position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get appDetail_position;

  /// No description provided for @appDetail_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get appDetail_select;

  /// No description provided for @appDetail_suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get appDetail_suggestions;

  /// No description provided for @appDetail_deleteKeywordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Keywords'**
  String get appDetail_deleteKeywordsTitle;

  /// No description provided for @appDetail_deleteKeywordsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} keywords?'**
  String appDetail_deleteKeywordsConfirm(int count);

  /// No description provided for @appDetail_tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get appDetail_tag;

  /// No description provided for @appDetail_keywordAdded.
  ///
  /// In en, this message translates to:
  /// **'Keyword \"{keyword}\" added ({flag})'**
  String appDetail_keywordAdded(String keyword, String flag);

  /// No description provided for @appDetail_tagsAdded.
  ///
  /// In en, this message translates to:
  /// **'Tags added to {count} keywords'**
  String appDetail_tagsAdded(int count);

  /// No description provided for @appDetail_keywordsAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Keywords added successfully'**
  String get appDetail_keywordsAddedSuccess;

  /// No description provided for @appDetail_noTagsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tags available. Create tags first.'**
  String get appDetail_noTagsAvailable;

  /// No description provided for @appDetail_tagged.
  ///
  /// In en, this message translates to:
  /// **'Tagged'**
  String get appDetail_tagged;

  /// No description provided for @appDetail_withNotes.
  ///
  /// In en, this message translates to:
  /// **'With Notes'**
  String get appDetail_withNotes;

  /// No description provided for @appDetail_nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name A-Z'**
  String get appDetail_nameAZ;

  /// No description provided for @appDetail_nameZA.
  ///
  /// In en, this message translates to:
  /// **'Name Z-A'**
  String get appDetail_nameZA;

  /// No description provided for @appDetail_bestPosition.
  ///
  /// In en, this message translates to:
  /// **'Best Position'**
  String get appDetail_bestPosition;

  /// No description provided for @appDetail_recentlyTracked.
  ///
  /// In en, this message translates to:
  /// **'Recently Tracked'**
  String get appDetail_recentlyTracked;

  /// No description provided for @keywordSuggestions_title.
  ///
  /// In en, this message translates to:
  /// **'Keyword Suggestions'**
  String get keywordSuggestions_title;

  /// No description provided for @keywordSuggestions_appInCountry.
  ///
  /// In en, this message translates to:
  /// **'{appName} in {country}'**
  String keywordSuggestions_appInCountry(String appName, String country);

  /// No description provided for @keywordSuggestions_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh suggestions'**
  String get keywordSuggestions_refresh;

  /// No description provided for @keywordSuggestions_search.
  ///
  /// In en, this message translates to:
  /// **'Search suggestions...'**
  String get keywordSuggestions_search;

  /// No description provided for @keywordSuggestions_selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get keywordSuggestions_selectAll;

  /// No description provided for @keywordSuggestions_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get keywordSuggestions_clear;

  /// No description provided for @keywordSuggestions_analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing app metadata...'**
  String get keywordSuggestions_analyzing;

  /// No description provided for @keywordSuggestions_mayTakeFewSeconds.
  ///
  /// In en, this message translates to:
  /// **'This may take a few seconds'**
  String get keywordSuggestions_mayTakeFewSeconds;

  /// No description provided for @keywordSuggestions_noSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions available'**
  String get keywordSuggestions_noSuggestions;

  /// No description provided for @keywordSuggestions_noMatchingSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No matching suggestions'**
  String get keywordSuggestions_noMatchingSuggestions;

  /// No description provided for @keywordSuggestions_headerKeyword.
  ///
  /// In en, this message translates to:
  /// **'KEYWORD'**
  String get keywordSuggestions_headerKeyword;

  /// No description provided for @keywordSuggestions_headerDifficulty.
  ///
  /// In en, this message translates to:
  /// **'DIFFICULTY'**
  String get keywordSuggestions_headerDifficulty;

  /// No description provided for @keywordSuggestions_headerApps.
  ///
  /// In en, this message translates to:
  /// **'APPS'**
  String get keywordSuggestions_headerApps;

  /// No description provided for @keywordSuggestions_rankedAt.
  ///
  /// In en, this message translates to:
  /// **'Ranked #{position}'**
  String keywordSuggestions_rankedAt(int position);

  /// No description provided for @keywordSuggestions_keywordsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} keywords selected'**
  String keywordSuggestions_keywordsSelected(int count);

  /// No description provided for @keywordSuggestions_addKeywords.
  ///
  /// In en, this message translates to:
  /// **'Add {count} Keywords'**
  String keywordSuggestions_addKeywords(int count);

  /// No description provided for @keywordSuggestions_errorAdding.
  ///
  /// In en, this message translates to:
  /// **'Error adding keywords: {error}'**
  String keywordSuggestions_errorAdding(String error);

  /// No description provided for @sidebar_favorites.
  ///
  /// In en, this message translates to:
  /// **'FAVORITES'**
  String get sidebar_favorites;

  /// No description provided for @sidebar_tooManyFavorites.
  ///
  /// In en, this message translates to:
  /// **'Consider keeping 5 or fewer favorites'**
  String get sidebar_tooManyFavorites;

  /// No description provided for @sidebar_iphone.
  ///
  /// In en, this message translates to:
  /// **'iPHONE'**
  String get sidebar_iphone;

  /// No description provided for @sidebar_android.
  ///
  /// In en, this message translates to:
  /// **'ANDROID'**
  String get sidebar_android;

  /// No description provided for @keywordSearch_title.
  ///
  /// In en, this message translates to:
  /// **'Keyword Research'**
  String get keywordSearch_title;

  /// No description provided for @keywordSearch_searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search keywords...'**
  String get keywordSearch_searchPlaceholder;

  /// No description provided for @keywordSearch_searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search for a keyword'**
  String get keywordSearch_searchTitle;

  /// No description provided for @keywordSearch_searchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover which apps rank for any keyword'**
  String get keywordSearch_searchSubtitle;

  /// No description provided for @keywordSearch_appsRanked.
  ///
  /// In en, this message translates to:
  /// **'{count} apps ranked'**
  String keywordSearch_appsRanked(int count);

  /// No description provided for @keywordSearch_popularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get keywordSearch_popularity;

  /// No description provided for @keywordSearch_results.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String keywordSearch_results(int count);

  /// No description provided for @keywordSearch_headerRank.
  ///
  /// In en, this message translates to:
  /// **'RANK'**
  String get keywordSearch_headerRank;

  /// No description provided for @keywordSearch_headerApp.
  ///
  /// In en, this message translates to:
  /// **'APP'**
  String get keywordSearch_headerApp;

  /// No description provided for @keywordSearch_headerRating.
  ///
  /// In en, this message translates to:
  /// **'RATING'**
  String get keywordSearch_headerRating;

  /// No description provided for @keywordSearch_headerTrack.
  ///
  /// In en, this message translates to:
  /// **'TRACK'**
  String get keywordSearch_headerTrack;

  /// No description provided for @keywordSearch_trackApp.
  ///
  /// In en, this message translates to:
  /// **'Track this app'**
  String get keywordSearch_trackApp;

  /// No description provided for @discover_title.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover_title;

  /// No description provided for @discover_tabKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get discover_tabKeywords;

  /// No description provided for @discover_tabCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get discover_tabCategories;

  /// No description provided for @discover_selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get discover_selectCategory;

  /// No description provided for @discover_topFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get discover_topFree;

  /// No description provided for @discover_topPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get discover_topPaid;

  /// No description provided for @discover_topGrossing.
  ///
  /// In en, this message translates to:
  /// **'Grossing'**
  String get discover_topGrossing;

  /// No description provided for @discover_noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get discover_noResults;

  /// No description provided for @discover_loadingTopApps.
  ///
  /// In en, this message translates to:
  /// **'Loading top apps...'**
  String get discover_loadingTopApps;

  /// No description provided for @discover_topAppsIn.
  ///
  /// In en, this message translates to:
  /// **'Top {collection} in {category}'**
  String discover_topAppsIn(String collection, String category);

  /// No description provided for @discover_appsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} apps'**
  String discover_appsCount(int count);

  /// No description provided for @discover_allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get discover_allCategories;

  /// No description provided for @category_games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get category_games;

  /// No description provided for @category_business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get category_business;

  /// No description provided for @category_education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get category_education;

  /// No description provided for @category_entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get category_entertainment;

  /// No description provided for @category_finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get category_finance;

  /// No description provided for @category_food_drink.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get category_food_drink;

  /// No description provided for @category_health_fitness.
  ///
  /// In en, this message translates to:
  /// **'Health & Fitness'**
  String get category_health_fitness;

  /// No description provided for @category_lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get category_lifestyle;

  /// No description provided for @category_medical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get category_medical;

  /// No description provided for @category_music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get category_music;

  /// No description provided for @category_navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get category_navigation;

  /// No description provided for @category_news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get category_news;

  /// No description provided for @category_photo_video.
  ///
  /// In en, this message translates to:
  /// **'Photo & Video'**
  String get category_photo_video;

  /// No description provided for @category_productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get category_productivity;

  /// No description provided for @category_reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get category_reference;

  /// No description provided for @category_shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get category_shopping;

  /// No description provided for @category_social.
  ///
  /// In en, this message translates to:
  /// **'Social Networking'**
  String get category_social;

  /// No description provided for @category_sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get category_sports;

  /// No description provided for @category_travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get category_travel;

  /// No description provided for @category_utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get category_utilities;

  /// No description provided for @category_weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get category_weather;

  /// No description provided for @category_books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get category_books;

  /// No description provided for @category_developer_tools.
  ///
  /// In en, this message translates to:
  /// **'Developer Tools'**
  String get category_developer_tools;

  /// No description provided for @category_graphics_design.
  ///
  /// In en, this message translates to:
  /// **'Graphics & Design'**
  String get category_graphics_design;

  /// No description provided for @category_magazines.
  ///
  /// In en, this message translates to:
  /// **'Magazines & Newspapers'**
  String get category_magazines;

  /// No description provided for @category_stickers.
  ///
  /// In en, this message translates to:
  /// **'Stickers'**
  String get category_stickers;

  /// No description provided for @category_catalogs.
  ///
  /// In en, this message translates to:
  /// **'Catalogs'**
  String get category_catalogs;

  /// No description provided for @category_art_design.
  ///
  /// In en, this message translates to:
  /// **'Art & Design'**
  String get category_art_design;

  /// No description provided for @category_auto_vehicles.
  ///
  /// In en, this message translates to:
  /// **'Auto & Vehicles'**
  String get category_auto_vehicles;

  /// No description provided for @category_beauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get category_beauty;

  /// No description provided for @category_comics.
  ///
  /// In en, this message translates to:
  /// **'Comics'**
  String get category_comics;

  /// No description provided for @category_communication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get category_communication;

  /// No description provided for @category_dating.
  ///
  /// In en, this message translates to:
  /// **'Dating'**
  String get category_dating;

  /// No description provided for @category_events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get category_events;

  /// No description provided for @category_house_home.
  ///
  /// In en, this message translates to:
  /// **'House & Home'**
  String get category_house_home;

  /// No description provided for @category_libraries.
  ///
  /// In en, this message translates to:
  /// **'Libraries & Demo'**
  String get category_libraries;

  /// No description provided for @category_maps_navigation.
  ///
  /// In en, this message translates to:
  /// **'Maps & Navigation'**
  String get category_maps_navigation;

  /// No description provided for @category_music_audio.
  ///
  /// In en, this message translates to:
  /// **'Music & Audio'**
  String get category_music_audio;

  /// No description provided for @category_news_magazines.
  ///
  /// In en, this message translates to:
  /// **'News & Magazines'**
  String get category_news_magazines;

  /// No description provided for @category_parenting.
  ///
  /// In en, this message translates to:
  /// **'Parenting'**
  String get category_parenting;

  /// No description provided for @category_personalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get category_personalization;

  /// No description provided for @category_photography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get category_photography;

  /// No description provided for @category_tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get category_tools;

  /// No description provided for @category_video_players.
  ///
  /// In en, this message translates to:
  /// **'Video Players & Editors'**
  String get category_video_players;

  /// No description provided for @category_all_apps.
  ///
  /// In en, this message translates to:
  /// **'All Apps'**
  String get category_all_apps;

  /// No description provided for @reviews_reviewsFor.
  ///
  /// In en, this message translates to:
  /// **'Reviews for {appName}'**
  String reviews_reviewsFor(String appName);

  /// No description provided for @reviews_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading reviews...'**
  String get reviews_loading;

  /// No description provided for @reviews_noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews'**
  String get reviews_noReviews;

  /// No description provided for @reviews_noReviewsFor.
  ///
  /// In en, this message translates to:
  /// **'No reviews found for {countryName}'**
  String reviews_noReviewsFor(String countryName);

  /// No description provided for @reviews_showingRecent.
  ///
  /// In en, this message translates to:
  /// **'Showing the {count} most recent reviews from the App Store.'**
  String reviews_showingRecent(int count);

  /// No description provided for @reviews_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get reviews_today;

  /// No description provided for @reviews_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get reviews_yesterday;

  /// No description provided for @reviews_daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String reviews_daysAgo(int count);

  /// No description provided for @reviews_weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String reviews_weeksAgo(int count);

  /// No description provided for @reviews_monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String reviews_monthsAgo(int count);

  /// No description provided for @ratings_byCountry.
  ///
  /// In en, this message translates to:
  /// **'Ratings by Country'**
  String get ratings_byCountry;

  /// No description provided for @ratings_noRatingsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No ratings available'**
  String get ratings_noRatingsAvailable;

  /// No description provided for @ratings_noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'This app has no ratings yet'**
  String get ratings_noRatingsYet;

  /// No description provided for @ratings_totalRatings.
  ///
  /// In en, this message translates to:
  /// **'Total Ratings'**
  String get ratings_totalRatings;

  /// No description provided for @ratings_averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get ratings_averageRating;

  /// No description provided for @ratings_countriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} countries'**
  String ratings_countriesCount(int count);

  /// No description provided for @ratings_updated.
  ///
  /// In en, this message translates to:
  /// **'Updated: {date}'**
  String ratings_updated(String date);

  /// No description provided for @ratings_headerCountry.
  ///
  /// In en, this message translates to:
  /// **'COUNTRY'**
  String get ratings_headerCountry;

  /// No description provided for @ratings_headerRatings.
  ///
  /// In en, this message translates to:
  /// **'RATINGS'**
  String get ratings_headerRatings;

  /// No description provided for @ratings_headerAverage.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE'**
  String get ratings_headerAverage;

  /// No description provided for @time_minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String time_minutesAgo(int count);

  /// No description provided for @time_hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String time_hoursAgo(int count);

  /// No description provided for @time_daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String time_daysAgo(int count);

  /// No description provided for @appDetail_noKeywordsTracked.
  ///
  /// In en, this message translates to:
  /// **'No keywords tracked'**
  String get appDetail_noKeywordsTracked;

  /// No description provided for @appDetail_addKeywordHint.
  ///
  /// In en, this message translates to:
  /// **'Add a keyword above to start tracking'**
  String get appDetail_addKeywordHint;

  /// No description provided for @appDetail_noKeywordsMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No keywords match filter'**
  String get appDetail_noKeywordsMatchFilter;

  /// No description provided for @appDetail_tryChangingFilter.
  ///
  /// In en, this message translates to:
  /// **'Try changing the filter criteria'**
  String get appDetail_tryChangingFilter;

  /// No description provided for @appDetail_addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get appDetail_addTag;

  /// No description provided for @appDetail_addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get appDetail_addNote;

  /// No description provided for @appDetail_positionHistory.
  ///
  /// In en, this message translates to:
  /// **'Position History'**
  String get appDetail_positionHistory;

  /// No description provided for @appDetail_store.
  ///
  /// In en, this message translates to:
  /// **'STORE'**
  String get appDetail_store;

  /// No description provided for @nav_overview.
  ///
  /// In en, this message translates to:
  /// **'OVERVIEW'**
  String get nav_overview;

  /// No description provided for @nav_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get nav_dashboard;

  /// No description provided for @nav_myApps.
  ///
  /// In en, this message translates to:
  /// **'My Apps'**
  String get nav_myApps;

  /// No description provided for @nav_research.
  ///
  /// In en, this message translates to:
  /// **'RESEARCH'**
  String get nav_research;

  /// No description provided for @nav_keywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get nav_keywords;

  /// No description provided for @nav_discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get nav_discover;

  /// No description provided for @nav_engagement.
  ///
  /// In en, this message translates to:
  /// **'ENGAGEMENT'**
  String get nav_engagement;

  /// No description provided for @nav_reviewsInbox.
  ///
  /// In en, this message translates to:
  /// **'Reviews Inbox'**
  String get nav_reviewsInbox;

  /// No description provided for @nav_notifications.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get nav_notifications;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @appDetail_manageTags.
  ///
  /// In en, this message translates to:
  /// **'Manage Tags'**
  String get appDetail_manageTags;

  /// No description provided for @appDetail_newTagHint.
  ///
  /// In en, this message translates to:
  /// **'New tag name...'**
  String get appDetail_newTagHint;

  /// No description provided for @appDetail_availableTags.
  ///
  /// In en, this message translates to:
  /// **'Available Tags'**
  String get appDetail_availableTags;

  /// No description provided for @appDetail_noTagsYet.
  ///
  /// In en, this message translates to:
  /// **'No tags yet. Create one above.'**
  String get appDetail_noTagsYet;

  /// No description provided for @appDetail_addTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Tags'**
  String get appDetail_addTagsTitle;

  /// No description provided for @appDetail_selectTagsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select tags to add to selected keywords:'**
  String get appDetail_selectTagsDescription;

  /// No description provided for @appDetail_addTagsCount.
  ///
  /// In en, this message translates to:
  /// **'Add {count} {count, plural, =1{Tag} other{Tags}}'**
  String appDetail_addTagsCount(int count);

  /// No description provided for @appDetail_importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String appDetail_importFailed(String error);

  /// No description provided for @appDetail_importKeywordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Keywords'**
  String get appDetail_importKeywordsTitle;

  /// No description provided for @appDetail_pasteKeywordsHint.
  ///
  /// In en, this message translates to:
  /// **'Paste keywords below, one per line:'**
  String get appDetail_pasteKeywordsHint;

  /// No description provided for @appDetail_keywordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'keyword one\nkeyword two\nkeyword three'**
  String get appDetail_keywordPlaceholder;

  /// No description provided for @appDetail_storefront.
  ///
  /// In en, this message translates to:
  /// **'Storefront:'**
  String get appDetail_storefront;

  /// No description provided for @appDetail_keywordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} keywords'**
  String appDetail_keywordsCount(int count);

  /// No description provided for @appDetail_importKeywordsCount.
  ///
  /// In en, this message translates to:
  /// **'Import {count} Keywords'**
  String appDetail_importKeywordsCount(int count);

  /// No description provided for @appDetail_period7d.
  ///
  /// In en, this message translates to:
  /// **'7d'**
  String get appDetail_period7d;

  /// No description provided for @appDetail_period30d.
  ///
  /// In en, this message translates to:
  /// **'30d'**
  String get appDetail_period30d;

  /// No description provided for @appDetail_period90d.
  ///
  /// In en, this message translates to:
  /// **'90d'**
  String get appDetail_period90d;

  /// No description provided for @reviews_version.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String reviews_version(String version);

  /// No description provided for @appPreview_title.
  ///
  /// In en, this message translates to:
  /// **'App Details'**
  String get appPreview_title;

  /// No description provided for @appPreview_notFound.
  ///
  /// In en, this message translates to:
  /// **'App not found'**
  String get appPreview_notFound;

  /// No description provided for @appPreview_screenshots.
  ///
  /// In en, this message translates to:
  /// **'Screenshots'**
  String get appPreview_screenshots;

  /// No description provided for @appPreview_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get appPreview_description;

  /// No description provided for @appPreview_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get appPreview_details;

  /// No description provided for @appPreview_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appPreview_version;

  /// No description provided for @appPreview_updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get appPreview_updated;

  /// No description provided for @appPreview_released.
  ///
  /// In en, this message translates to:
  /// **'Released'**
  String get appPreview_released;

  /// No description provided for @appPreview_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get appPreview_size;

  /// No description provided for @appPreview_minimumOs.
  ///
  /// In en, this message translates to:
  /// **'Requires'**
  String get appPreview_minimumOs;

  /// No description provided for @appPreview_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get appPreview_price;

  /// No description provided for @appPreview_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get appPreview_free;

  /// No description provided for @appPreview_openInStore.
  ///
  /// In en, this message translates to:
  /// **'Open in Store'**
  String get appPreview_openInStore;

  /// No description provided for @appPreview_addToMyApps.
  ///
  /// In en, this message translates to:
  /// **'Add to My Apps'**
  String get appPreview_addToMyApps;

  /// No description provided for @appPreview_added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get appPreview_added;

  /// No description provided for @appPreview_showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get appPreview_showMore;

  /// No description provided for @appPreview_showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get appPreview_showLess;

  /// No description provided for @appPreview_keywordsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add this app to your tracked apps to enable keyword tracking'**
  String get appPreview_keywordsPlaceholder;

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @notifications_markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifications_markAllRead;

  /// No description provided for @notifications_empty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifications_empty;

  /// No description provided for @alerts_title.
  ///
  /// In en, this message translates to:
  /// **'Alert Rules'**
  String get alerts_title;

  /// No description provided for @alerts_templatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Templates'**
  String get alerts_templatesTitle;

  /// No description provided for @alerts_templatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Activate common alerts with one tap'**
  String get alerts_templatesSubtitle;

  /// No description provided for @alerts_myRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Rules'**
  String get alerts_myRulesTitle;

  /// No description provided for @alerts_createRule.
  ///
  /// In en, this message translates to:
  /// **'Create rule'**
  String get alerts_createRule;

  /// No description provided for @alerts_editRule.
  ///
  /// In en, this message translates to:
  /// **'Edit rule'**
  String get alerts_editRule;

  /// No description provided for @alerts_noRulesYet.
  ///
  /// In en, this message translates to:
  /// **'No rules yet'**
  String get alerts_noRulesYet;

  /// No description provided for @alerts_deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete rule?'**
  String get alerts_deleteConfirm;

  /// No description provided for @settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settings_notifications;

  /// No description provided for @settings_manageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage Alert Rules'**
  String get settings_manageAlerts;

  /// No description provided for @settings_manageAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure what alerts you receive'**
  String get settings_manageAlertsDesc;

  /// No description provided for @settings_storeConnections.
  ///
  /// In en, this message translates to:
  /// **'Store Connections'**
  String get settings_storeConnections;

  /// No description provided for @settings_storeConnectionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect your App Store and Google Play accounts'**
  String get settings_storeConnectionsDesc;

  /// No description provided for @storeConnections_title.
  ///
  /// In en, this message translates to:
  /// **'Store Connections'**
  String get storeConnections_title;

  /// No description provided for @storeConnections_description.
  ///
  /// In en, this message translates to:
  /// **'Connect your App Store and Google Play accounts to enable advanced features like sales data and app analytics.'**
  String get storeConnections_description;

  /// No description provided for @storeConnections_appStoreConnect.
  ///
  /// In en, this message translates to:
  /// **'App Store Connect'**
  String get storeConnections_appStoreConnect;

  /// No description provided for @storeConnections_appStoreConnectDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect your Apple Developer account'**
  String get storeConnections_appStoreConnectDesc;

  /// No description provided for @storeConnections_googlePlayConsole.
  ///
  /// In en, this message translates to:
  /// **'Google Play Console'**
  String get storeConnections_googlePlayConsole;

  /// No description provided for @storeConnections_googlePlayConsoleDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect your Google Play account'**
  String get storeConnections_googlePlayConsoleDesc;

  /// No description provided for @storeConnections_connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get storeConnections_connect;

  /// No description provided for @storeConnections_disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get storeConnections_disconnect;

  /// No description provided for @storeConnections_connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get storeConnections_connected;

  /// No description provided for @storeConnections_disconnectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Disconnect?'**
  String get storeConnections_disconnectConfirm;

  /// No description provided for @storeConnections_disconnectMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect this {platform} account?'**
  String storeConnections_disconnectMessage(String platform);

  /// No description provided for @storeConnections_disconnectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Disconnected successfully'**
  String get storeConnections_disconnectSuccess;

  /// No description provided for @storeConnections_lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced: {date}'**
  String storeConnections_lastSynced(String date);

  /// No description provided for @storeConnections_connectedOn.
  ///
  /// In en, this message translates to:
  /// **'Connected on {date}'**
  String storeConnections_connectedOn(String date);

  /// No description provided for @reviewsInbox_title.
  ///
  /// In en, this message translates to:
  /// **'Reviews Inbox'**
  String get reviewsInbox_title;

  /// No description provided for @reviewsInbox_filterUnanswered.
  ///
  /// In en, this message translates to:
  /// **'Unanswered'**
  String get reviewsInbox_filterUnanswered;

  /// No description provided for @reviewsInbox_filterNegative.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get reviewsInbox_filterNegative;

  /// No description provided for @reviewsInbox_noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews found'**
  String get reviewsInbox_noReviews;

  /// No description provided for @reviewsInbox_noReviewsDesc.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get reviewsInbox_noReviewsDesc;

  /// No description provided for @reviewsInbox_reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reviewsInbox_reply;

  /// No description provided for @reviewsInbox_responded.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get reviewsInbox_responded;

  /// No description provided for @reviewsInbox_respondedAt.
  ///
  /// In en, this message translates to:
  /// **'Responded {date}'**
  String reviewsInbox_respondedAt(String date);

  /// No description provided for @reviewsInbox_replyModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Reply to Review'**
  String get reviewsInbox_replyModalTitle;

  /// No description provided for @reviewsInbox_generateAi.
  ///
  /// In en, this message translates to:
  /// **'Generate AI suggestion'**
  String get reviewsInbox_generateAi;

  /// No description provided for @reviewsInbox_generating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get reviewsInbox_generating;

  /// No description provided for @reviewsInbox_sendReply.
  ///
  /// In en, this message translates to:
  /// **'Send Reply'**
  String get reviewsInbox_sendReply;

  /// No description provided for @reviewsInbox_sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get reviewsInbox_sending;

  /// No description provided for @reviewsInbox_replyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write your response...'**
  String get reviewsInbox_replyPlaceholder;

  /// No description provided for @reviewsInbox_charLimit.
  ///
  /// In en, this message translates to:
  /// **'{count}/5970 characters'**
  String reviewsInbox_charLimit(int count);

  /// No description provided for @reviewsInbox_replySent.
  ///
  /// In en, this message translates to:
  /// **'Reply sent successfully'**
  String get reviewsInbox_replySent;

  /// No description provided for @reviewsInbox_replyError.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reply: {error}'**
  String reviewsInbox_replyError(String error);

  /// No description provided for @reviewsInbox_aiError.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate suggestion: {error}'**
  String reviewsInbox_aiError(String error);

  /// No description provided for @reviewsInbox_stars.
  ///
  /// In en, this message translates to:
  /// **'{count} stars'**
  String reviewsInbox_stars(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
