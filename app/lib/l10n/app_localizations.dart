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

  /// No description provided for @dashboard_reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get dashboard_reviews;

  /// No description provided for @dashboard_avgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get dashboard_avgRating;

  /// No description provided for @dashboard_topPerformingApps.
  ///
  /// In en, this message translates to:
  /// **'Top Performing Apps'**
  String get dashboard_topPerformingApps;

  /// No description provided for @dashboard_topCountries.
  ///
  /// In en, this message translates to:
  /// **'Top Countries'**
  String get dashboard_topCountries;

  /// No description provided for @dashboard_sentimentOverview.
  ///
  /// In en, this message translates to:
  /// **'Sentiment Overview'**
  String get dashboard_sentimentOverview;

  /// No description provided for @dashboard_overallSentiment.
  ///
  /// In en, this message translates to:
  /// **'Overall Sentiment'**
  String get dashboard_overallSentiment;

  /// No description provided for @dashboard_positive.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get dashboard_positive;

  /// No description provided for @dashboard_positiveReviews.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get dashboard_positiveReviews;

  /// No description provided for @dashboard_negativeReviews.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get dashboard_negativeReviews;

  /// No description provided for @dashboard_viewReviews.
  ///
  /// In en, this message translates to:
  /// **'View reviews'**
  String get dashboard_viewReviews;

  /// No description provided for @dashboard_tableApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get dashboard_tableApp;

  /// No description provided for @dashboard_tableKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get dashboard_tableKeywords;

  /// No description provided for @dashboard_tableAvgRank.
  ///
  /// In en, this message translates to:
  /// **'Avg Rank'**
  String get dashboard_tableAvgRank;

  /// No description provided for @dashboard_tableTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get dashboard_tableTrend;

  /// No description provided for @dashboard_connectYourStores.
  ///
  /// In en, this message translates to:
  /// **'Connect Your Stores'**
  String get dashboard_connectYourStores;

  /// No description provided for @dashboard_connectStoresDescription.
  ///
  /// In en, this message translates to:
  /// **'Link App Store Connect or Google Play to import your apps and reply to reviews.'**
  String get dashboard_connectStoresDescription;

  /// No description provided for @dashboard_connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get dashboard_connect;

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

  /// No description provided for @insights_title.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights_title;

  /// No description provided for @insights_titleWithApp.
  ///
  /// In en, this message translates to:
  /// **'Insights - {appName}'**
  String insights_titleWithApp(String appName);

  /// No description provided for @insights_allApps.
  ///
  /// In en, this message translates to:
  /// **'Insights (All Apps)'**
  String get insights_allApps;

  /// No description provided for @insights_noInsightsYet.
  ///
  /// In en, this message translates to:
  /// **'No insights yet'**
  String get insights_noInsightsYet;

  /// No description provided for @insights_selectAppToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Select an app to generate insights from reviews'**
  String get insights_selectAppToGenerate;

  /// No description provided for @insights_appsWithInsights.
  ///
  /// In en, this message translates to:
  /// **'{count} apps with insights'**
  String insights_appsWithInsights(int count);

  /// No description provided for @insights_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading insights'**
  String get insights_errorLoading;

  /// No description provided for @insights_reviewsAnalyzed.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews analyzed'**
  String insights_reviewsAnalyzed(int count);

  /// No description provided for @insights_avgScore.
  ///
  /// In en, this message translates to:
  /// **'avg score'**
  String get insights_avgScore;

  /// No description provided for @insights_updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String insights_updatedOn(String date);

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

  /// No description provided for @keywordSuggestions_categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get keywordSuggestions_categoryAll;

  /// No description provided for @keywordSuggestions_categoryHighOpportunity.
  ///
  /// In en, this message translates to:
  /// **'High Opportunity'**
  String get keywordSuggestions_categoryHighOpportunity;

  /// No description provided for @keywordSuggestions_categoryCompetitor.
  ///
  /// In en, this message translates to:
  /// **'Competitor Keywords'**
  String get keywordSuggestions_categoryCompetitor;

  /// No description provided for @keywordSuggestions_categoryLongTail.
  ///
  /// In en, this message translates to:
  /// **'Long-tail'**
  String get keywordSuggestions_categoryLongTail;

  /// No description provided for @keywordSuggestions_categoryTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get keywordSuggestions_categoryTrending;

  /// No description provided for @keywordSuggestions_categoryRelated.
  ///
  /// In en, this message translates to:
  /// **'Related'**
  String get keywordSuggestions_categoryRelated;

  /// No description provided for @keywordSuggestions_generating.
  ///
  /// In en, this message translates to:
  /// **'Generating suggestions...'**
  String get keywordSuggestions_generating;

  /// No description provided for @keywordSuggestions_generatingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This may take a few minutes. Please check back later.'**
  String get keywordSuggestions_generatingSubtitle;

  /// No description provided for @keywordSuggestions_checkAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get keywordSuggestions_checkAgain;

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

  /// No description provided for @nav_optimization.
  ///
  /// In en, this message translates to:
  /// **'OPTIMIZATION'**
  String get nav_optimization;

  /// No description provided for @nav_keywordInspector.
  ///
  /// In en, this message translates to:
  /// **'Keyword Inspector'**
  String get nav_keywordInspector;

  /// No description provided for @nav_ratingsAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Ratings Analysis'**
  String get nav_ratingsAnalysis;

  /// No description provided for @nav_intelligence.
  ///
  /// In en, this message translates to:
  /// **'INTELLIGENCE'**
  String get nav_intelligence;

  /// No description provided for @nav_topCharts.
  ///
  /// In en, this message translates to:
  /// **'Top Charts'**
  String get nav_topCharts;

  /// No description provided for @nav_competitors.
  ///
  /// In en, this message translates to:
  /// **'Competitors'**
  String get nav_competitors;

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

  /// No description provided for @appDetail_currentTags.
  ///
  /// In en, this message translates to:
  /// **'Current Tags'**
  String get appDetail_currentTags;

  /// No description provided for @appDetail_noTagsOnKeyword.
  ///
  /// In en, this message translates to:
  /// **'No tags on this keyword'**
  String get appDetail_noTagsOnKeyword;

  /// No description provided for @appDetail_addExistingTag.
  ///
  /// In en, this message translates to:
  /// **'Add Existing Tag'**
  String get appDetail_addExistingTag;

  /// No description provided for @appDetail_allTagsUsed.
  ///
  /// In en, this message translates to:
  /// **'All tags already added'**
  String get appDetail_allTagsUsed;

  /// No description provided for @appDetail_createNewTag.
  ///
  /// In en, this message translates to:
  /// **'Create New Tag'**
  String get appDetail_createNewTag;

  /// No description provided for @appDetail_tagNameHint.
  ///
  /// In en, this message translates to:
  /// **'Tag name...'**
  String get appDetail_tagNameHint;

  /// No description provided for @appDetail_note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get appDetail_note;

  /// No description provided for @appDetail_noteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note about this keyword...'**
  String get appDetail_noteHint;

  /// No description provided for @appDetail_saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get appDetail_saveNote;

  /// No description provided for @appDetail_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get appDetail_done;

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

  /// No description provided for @keywords_difficultyFilter.
  ///
  /// In en, this message translates to:
  /// **'Difficulty:'**
  String get keywords_difficultyFilter;

  /// No description provided for @keywords_difficultyAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get keywords_difficultyAll;

  /// No description provided for @keywords_difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy < 40'**
  String get keywords_difficultyEasy;

  /// No description provided for @keywords_difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium 40-70'**
  String get keywords_difficultyMedium;

  /// No description provided for @keywords_difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard > 70'**
  String get keywords_difficultyHard;

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

  /// No description provided for @alerts_createCustomRule.
  ///
  /// In en, this message translates to:
  /// **'Create custom rule'**
  String get alerts_createCustomRule;

  /// No description provided for @alerts_ruleActivated.
  ///
  /// In en, this message translates to:
  /// **'{name} activated!'**
  String alerts_ruleActivated(String name);

  /// No description provided for @alerts_deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete \"{name}\".'**
  String alerts_deleteMessage(String name);

  /// No description provided for @alerts_noRulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Activate a template or create your own!'**
  String get alerts_noRulesDescription;

  /// No description provided for @alerts_create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get alerts_create;

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

  /// No description provided for @settings_alertDelivery.
  ///
  /// In en, this message translates to:
  /// **'ALERT DELIVERY'**
  String get settings_alertDelivery;

  /// No description provided for @settings_team.
  ///
  /// In en, this message translates to:
  /// **'TEAM'**
  String get settings_team;

  /// No description provided for @settings_teamManagement.
  ///
  /// In en, this message translates to:
  /// **'Team Management'**
  String get settings_teamManagement;

  /// No description provided for @settings_teamManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Invite members, manage roles & permissions'**
  String get settings_teamManagementDesc;

  /// No description provided for @settings_integrations.
  ///
  /// In en, this message translates to:
  /// **'INTEGRATIONS'**
  String get settings_integrations;

  /// No description provided for @settings_manageIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Manage Integrations'**
  String get settings_manageIntegrations;

  /// No description provided for @settings_manageIntegrationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect App Store Connect & Google Play Console'**
  String get settings_manageIntegrationsDesc;

  /// No description provided for @settings_billing.
  ///
  /// In en, this message translates to:
  /// **'BILLING'**
  String get settings_billing;

  /// No description provided for @settings_plansBilling.
  ///
  /// In en, this message translates to:
  /// **'Plans & Billing'**
  String get settings_plansBilling;

  /// No description provided for @settings_plansBillingDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your subscription and payment'**
  String get settings_plansBillingDesc;

  /// No description provided for @settings_rememberApp.
  ///
  /// In en, this message translates to:
  /// **'Remember selected app'**
  String get settings_rememberApp;

  /// No description provided for @settings_rememberAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Restore app selection when you open the app'**
  String get settings_rememberAppDesc;

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

  /// No description provided for @storeConnections_syncApps.
  ///
  /// In en, this message translates to:
  /// **'Sync Apps'**
  String get storeConnections_syncApps;

  /// No description provided for @storeConnections_syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get storeConnections_syncing;

  /// No description provided for @storeConnections_syncDescription.
  ///
  /// In en, this message translates to:
  /// **'Sync will mark your apps from this account as owned, enabling review replies.'**
  String get storeConnections_syncDescription;

  /// No description provided for @storeConnections_syncedApps.
  ///
  /// In en, this message translates to:
  /// **'Synced {count} apps as owned'**
  String storeConnections_syncedApps(int count);

  /// No description provided for @storeConnections_syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {error}'**
  String storeConnections_syncFailed(String error);

  /// No description provided for @storeConnections_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading connections: {error}'**
  String storeConnections_errorLoading(String error);

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

  /// No description provided for @reviewsInbox_totalReviews.
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get reviewsInbox_totalReviews;

  /// No description provided for @reviewsInbox_unanswered.
  ///
  /// In en, this message translates to:
  /// **'Unanswered'**
  String get reviewsInbox_unanswered;

  /// No description provided for @reviewsInbox_positive.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get reviewsInbox_positive;

  /// No description provided for @reviewsInbox_avgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get reviewsInbox_avgRating;

  /// No description provided for @reviewsInbox_sentimentOverview.
  ///
  /// In en, this message translates to:
  /// **'Sentiment Overview'**
  String get reviewsInbox_sentimentOverview;

  /// No description provided for @reviewsInbox_aiSuggestions.
  ///
  /// In en, this message translates to:
  /// **'AI Suggested Replies'**
  String get reviewsInbox_aiSuggestions;

  /// No description provided for @reviewsInbox_regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get reviewsInbox_regenerate;

  /// No description provided for @reviewsInbox_toneProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get reviewsInbox_toneProfessional;

  /// No description provided for @reviewsInbox_toneEmpathetic.
  ///
  /// In en, this message translates to:
  /// **'Empathetic'**
  String get reviewsInbox_toneEmpathetic;

  /// No description provided for @reviewsInbox_toneBrief.
  ///
  /// In en, this message translates to:
  /// **'Brief'**
  String get reviewsInbox_toneBrief;

  /// No description provided for @reviewsInbox_selectTone.
  ///
  /// In en, this message translates to:
  /// **'Select tone:'**
  String get reviewsInbox_selectTone;

  /// No description provided for @reviewsInbox_detectedIssues.
  ///
  /// In en, this message translates to:
  /// **'Issues detected:'**
  String get reviewsInbox_detectedIssues;

  /// No description provided for @reviewsInbox_aiPrompt.
  ///
  /// In en, this message translates to:
  /// **'Click \'Generate AI suggestion\' to get reply suggestions in 3 different tones'**
  String get reviewsInbox_aiPrompt;

  /// No description provided for @reviewIntelligence_title.
  ///
  /// In en, this message translates to:
  /// **'Review Intelligence'**
  String get reviewIntelligence_title;

  /// No description provided for @reviewIntelligence_featureRequests.
  ///
  /// In en, this message translates to:
  /// **'Feature Requests'**
  String get reviewIntelligence_featureRequests;

  /// No description provided for @reviewIntelligence_bugReports.
  ///
  /// In en, this message translates to:
  /// **'Bug Reports'**
  String get reviewIntelligence_bugReports;

  /// No description provided for @reviewIntelligence_sentimentByVersion.
  ///
  /// In en, this message translates to:
  /// **'Sentiment by Version'**
  String get reviewIntelligence_sentimentByVersion;

  /// No description provided for @reviewIntelligence_openFeatures.
  ///
  /// In en, this message translates to:
  /// **'Open Features'**
  String get reviewIntelligence_openFeatures;

  /// No description provided for @reviewIntelligence_openBugs.
  ///
  /// In en, this message translates to:
  /// **'Open Bugs'**
  String get reviewIntelligence_openBugs;

  /// No description provided for @reviewIntelligence_highPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get reviewIntelligence_highPriority;

  /// No description provided for @reviewIntelligence_total.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get reviewIntelligence_total;

  /// No description provided for @reviewIntelligence_mentions.
  ///
  /// In en, this message translates to:
  /// **'mentions'**
  String get reviewIntelligence_mentions;

  /// No description provided for @reviewIntelligence_noData.
  ///
  /// In en, this message translates to:
  /// **'No insights yet'**
  String get reviewIntelligence_noData;

  /// No description provided for @reviewIntelligence_noDataHint.
  ///
  /// In en, this message translates to:
  /// **'Insights will appear after reviews are analyzed'**
  String get reviewIntelligence_noDataHint;

  /// No description provided for @analytics_title.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics_title;

  /// No description provided for @analytics_downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get analytics_downloads;

  /// No description provided for @analytics_revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get analytics_revenue;

  /// No description provided for @analytics_proceeds.
  ///
  /// In en, this message translates to:
  /// **'Proceeds'**
  String get analytics_proceeds;

  /// No description provided for @analytics_subscribers.
  ///
  /// In en, this message translates to:
  /// **'Subscribers'**
  String get analytics_subscribers;

  /// No description provided for @analytics_downloadsOverTime.
  ///
  /// In en, this message translates to:
  /// **'Downloads Over Time'**
  String get analytics_downloadsOverTime;

  /// No description provided for @analytics_revenueOverTime.
  ///
  /// In en, this message translates to:
  /// **'Revenue Over Time'**
  String get analytics_revenueOverTime;

  /// No description provided for @analytics_byCountry.
  ///
  /// In en, this message translates to:
  /// **'By Country'**
  String get analytics_byCountry;

  /// No description provided for @analytics_noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get analytics_noData;

  /// No description provided for @analytics_noDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No Analytics Data'**
  String get analytics_noDataTitle;

  /// No description provided for @analytics_noDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect your App Store Connect or Google Play account to see real sales and download data.'**
  String get analytics_noDataDescription;

  /// No description provided for @analytics_dataDelay.
  ///
  /// In en, this message translates to:
  /// **'Data as of {date}. Apple data has a 24-48h delay.'**
  String analytics_dataDelay(String date);

  /// No description provided for @analytics_export.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get analytics_export;

  /// No description provided for @funnel_title.
  ///
  /// In en, this message translates to:
  /// **'Conversion Funnel'**
  String get funnel_title;

  /// No description provided for @funnel_impressions.
  ///
  /// In en, this message translates to:
  /// **'Impressions'**
  String get funnel_impressions;

  /// No description provided for @funnel_pageViews.
  ///
  /// In en, this message translates to:
  /// **'Page Views'**
  String get funnel_pageViews;

  /// No description provided for @funnel_downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get funnel_downloads;

  /// No description provided for @funnel_overallCvr.
  ///
  /// In en, this message translates to:
  /// **'Overall CVR'**
  String get funnel_overallCvr;

  /// No description provided for @funnel_categoryAvg.
  ///
  /// In en, this message translates to:
  /// **'Category avg'**
  String get funnel_categoryAvg;

  /// No description provided for @funnel_vsCategory.
  ///
  /// In en, this message translates to:
  /// **'vs category'**
  String get funnel_vsCategory;

  /// No description provided for @funnel_bySource.
  ///
  /// In en, this message translates to:
  /// **'By Source'**
  String get funnel_bySource;

  /// No description provided for @funnel_noData.
  ///
  /// In en, this message translates to:
  /// **'No funnel data available'**
  String get funnel_noData;

  /// No description provided for @funnel_noDataHint.
  ///
  /// In en, this message translates to:
  /// **'Funnel data will be synced automatically from App Store Connect or Google Play Console.'**
  String get funnel_noDataHint;

  /// No description provided for @funnel_insight.
  ///
  /// In en, this message translates to:
  /// **'INSIGHT'**
  String get funnel_insight;

  /// No description provided for @funnel_insightText.
  ///
  /// In en, this message translates to:
  /// **'{bestSource} traffic converts {ratio}x better than {worstSource}. {recommendation}'**
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  );

  /// No description provided for @funnel_insightRecommendSearch.
  ///
  /// In en, this message translates to:
  /// **'Focus on keyword optimization to increase Search impressions.'**
  String get funnel_insightRecommendSearch;

  /// No description provided for @funnel_insightRecommendBrowse.
  ///
  /// In en, this message translates to:
  /// **'Improve your app\'s visibility in Browse by optimizing categories and featured placement.'**
  String get funnel_insightRecommendBrowse;

  /// No description provided for @funnel_insightRecommendReferral.
  ///
  /// In en, this message translates to:
  /// **'Leverage referral programs and partnerships to drive more traffic.'**
  String get funnel_insightRecommendReferral;

  /// No description provided for @funnel_insightRecommendAppReferrer.
  ///
  /// In en, this message translates to:
  /// **'Consider cross-promotion strategies with complementary apps.'**
  String get funnel_insightRecommendAppReferrer;

  /// No description provided for @funnel_insightRecommendWebReferrer.
  ///
  /// In en, this message translates to:
  /// **'Optimize your website and landing pages for app downloads.'**
  String get funnel_insightRecommendWebReferrer;

  /// No description provided for @funnel_insightRecommendDefault.
  ///
  /// In en, this message translates to:
  /// **'Analyze what makes this source perform well and replicate it.'**
  String get funnel_insightRecommendDefault;

  /// No description provided for @funnel_trendTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversion Rate Trend'**
  String get funnel_trendTitle;

  /// No description provided for @funnel_connectStore.
  ///
  /// In en, this message translates to:
  /// **'Connect Store'**
  String get funnel_connectStore;

  /// No description provided for @nav_chat.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get nav_chat;

  /// No description provided for @chat_title.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get chat_title;

  /// No description provided for @chat_newConversation.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get chat_newConversation;

  /// No description provided for @chat_loadingConversations.
  ///
  /// In en, this message translates to:
  /// **'Loading conversations...'**
  String get chat_loadingConversations;

  /// No description provided for @chat_loadingMessages.
  ///
  /// In en, this message translates to:
  /// **'Loading messages...'**
  String get chat_loadingMessages;

  /// No description provided for @chat_noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get chat_noConversations;

  /// No description provided for @chat_noConversationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation to get AI-powered insights about your apps'**
  String get chat_noConversationsDesc;

  /// No description provided for @chat_startConversation.
  ///
  /// In en, this message translates to:
  /// **'Start Conversation'**
  String get chat_startConversation;

  /// No description provided for @chat_deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get chat_deleteConversation;

  /// No description provided for @chat_deleteConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation?'**
  String get chat_deleteConversationConfirm;

  /// No description provided for @chat_askAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything'**
  String get chat_askAnything;

  /// No description provided for @chat_askAnythingDesc.
  ///
  /// In en, this message translates to:
  /// **'I can help you understand your app\'s reviews, rankings, and analytics'**
  String get chat_askAnythingDesc;

  /// No description provided for @chat_typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your question...'**
  String get chat_typeMessage;

  /// No description provided for @chat_suggestedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Suggested Questions'**
  String get chat_suggestedQuestions;

  /// No description provided for @chatActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get chatActionConfirm;

  /// No description provided for @chatActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatActionCancel;

  /// No description provided for @chatActionExecuting.
  ///
  /// In en, this message translates to:
  /// **'Executing...'**
  String get chatActionExecuting;

  /// No description provided for @chatActionExecuted.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get chatActionExecuted;

  /// No description provided for @chatActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get chatActionFailed;

  /// No description provided for @chatActionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get chatActionCancelled;

  /// No description provided for @chatActionDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get chatActionDownload;

  /// No description provided for @chatActionReversible.
  ///
  /// In en, this message translates to:
  /// **'This action can be undone'**
  String get chatActionReversible;

  /// No description provided for @chatActionAddKeywords.
  ///
  /// In en, this message translates to:
  /// **'Add Keywords to Tracking'**
  String get chatActionAddKeywords;

  /// No description provided for @chatActionRemoveKeywords.
  ///
  /// In en, this message translates to:
  /// **'Remove Keywords'**
  String get chatActionRemoveKeywords;

  /// No description provided for @chatActionCreateAlert.
  ///
  /// In en, this message translates to:
  /// **'Create Alert Rule'**
  String get chatActionCreateAlert;

  /// No description provided for @chatActionAddCompetitor.
  ///
  /// In en, this message translates to:
  /// **'Add Competitor'**
  String get chatActionAddCompetitor;

  /// No description provided for @chatActionExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get chatActionExportData;

  /// No description provided for @chatActionKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get chatActionKeywords;

  /// No description provided for @chatActionCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get chatActionCountry;

  /// No description provided for @chatActionAlertCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get chatActionAlertCondition;

  /// No description provided for @chatActionNotifyVia.
  ///
  /// In en, this message translates to:
  /// **'Notify via'**
  String get chatActionNotifyVia;

  /// No description provided for @chatActionCompetitor.
  ///
  /// In en, this message translates to:
  /// **'Competitor'**
  String get chatActionCompetitor;

  /// No description provided for @chatActionExportType.
  ///
  /// In en, this message translates to:
  /// **'Export type'**
  String get chatActionExportType;

  /// No description provided for @chatActionDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get chatActionDateRange;

  /// No description provided for @chatActionKeywordsLabel.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get chatActionKeywordsLabel;

  /// No description provided for @chatActionAnalyticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get chatActionAnalyticsLabel;

  /// No description provided for @chatActionReviewsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get chatActionReviewsLabel;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @appDetail_tabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get appDetail_tabOverview;

  /// No description provided for @appDetail_tabKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get appDetail_tabKeywords;

  /// No description provided for @appDetail_tabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get appDetail_tabReviews;

  /// No description provided for @appDetail_tabRatings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get appDetail_tabRatings;

  /// No description provided for @appDetail_tabInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get appDetail_tabInsights;

  /// No description provided for @dateRange_title.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange_title;

  /// No description provided for @dateRange_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateRange_today;

  /// No description provided for @dateRange_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateRange_yesterday;

  /// No description provided for @dateRange_last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get dateRange_last7Days;

  /// No description provided for @dateRange_last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get dateRange_last30Days;

  /// No description provided for @dateRange_thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get dateRange_thisMonth;

  /// No description provided for @dateRange_lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get dateRange_lastMonth;

  /// No description provided for @dateRange_last90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 Days'**
  String get dateRange_last90Days;

  /// No description provided for @dateRange_yearToDate.
  ///
  /// In en, this message translates to:
  /// **'Year to Date'**
  String get dateRange_yearToDate;

  /// No description provided for @dateRange_allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get dateRange_allTime;

  /// No description provided for @dateRange_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom...'**
  String get dateRange_custom;

  /// No description provided for @dateRange_compareToPrevious.
  ///
  /// In en, this message translates to:
  /// **'Compare to previous period'**
  String get dateRange_compareToPrevious;

  /// No description provided for @export_keywordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Keywords'**
  String get export_keywordsTitle;

  /// No description provided for @export_reviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Reviews'**
  String get export_reviewsTitle;

  /// No description provided for @export_analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Analytics'**
  String get export_analyticsTitle;

  /// No description provided for @export_columnsToInclude.
  ///
  /// In en, this message translates to:
  /// **'Columns to include:'**
  String get export_columnsToInclude;

  /// No description provided for @export_button.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export_button;

  /// No description provided for @export_keyword.
  ///
  /// In en, this message translates to:
  /// **'Keyword'**
  String get export_keyword;

  /// No description provided for @export_position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get export_position;

  /// No description provided for @export_change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get export_change;

  /// No description provided for @export_popularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get export_popularity;

  /// No description provided for @export_difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get export_difficulty;

  /// No description provided for @export_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get export_tags;

  /// No description provided for @export_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get export_notes;

  /// No description provided for @export_trackedSince.
  ///
  /// In en, this message translates to:
  /// **'Tracked Since'**
  String get export_trackedSince;

  /// No description provided for @export_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get export_date;

  /// No description provided for @export_rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get export_rating;

  /// No description provided for @export_author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get export_author;

  /// No description provided for @export_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get export_title;

  /// No description provided for @export_content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get export_content;

  /// No description provided for @export_country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get export_country;

  /// No description provided for @export_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get export_version;

  /// No description provided for @export_sentiment.
  ///
  /// In en, this message translates to:
  /// **'Sentiment'**
  String get export_sentiment;

  /// No description provided for @export_response.
  ///
  /// In en, this message translates to:
  /// **'Our Response'**
  String get export_response;

  /// No description provided for @export_responseDate.
  ///
  /// In en, this message translates to:
  /// **'Response Date'**
  String get export_responseDate;

  /// No description provided for @export_keywordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} keywords will be exported'**
  String export_keywordsCount(int count);

  /// No description provided for @export_reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews will be exported'**
  String export_reviewsCount(int count);

  /// No description provided for @export_success.
  ///
  /// In en, this message translates to:
  /// **'Export saved: {filename}'**
  String export_success(String filename);

  /// No description provided for @export_error.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String export_error(String error);

  /// No description provided for @metadata_editor.
  ///
  /// In en, this message translates to:
  /// **'Metadata Editor'**
  String get metadata_editor;

  /// No description provided for @metadata_selectLocale.
  ///
  /// In en, this message translates to:
  /// **'Select a locale to edit'**
  String get metadata_selectLocale;

  /// No description provided for @metadata_refreshed.
  ///
  /// In en, this message translates to:
  /// **'Metadata refreshed from store'**
  String get metadata_refreshed;

  /// No description provided for @metadata_connectRequired.
  ///
  /// In en, this message translates to:
  /// **'Connect to edit metadata'**
  String get metadata_connectRequired;

  /// No description provided for @metadata_connectDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect your App Store Connect account to edit your app\'s metadata directly from Keyrank.'**
  String get metadata_connectDescription;

  /// No description provided for @metadata_connectStore.
  ///
  /// In en, this message translates to:
  /// **'Connect App Store'**
  String get metadata_connectStore;

  /// No description provided for @metadata_publishTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish Metadata'**
  String get metadata_publishTitle;

  /// No description provided for @metadata_publishConfirm.
  ///
  /// In en, this message translates to:
  /// **'Publish changes to {locale}? This will update your app\'s listing on the App Store.'**
  String metadata_publishConfirm(String locale);

  /// No description provided for @metadata_publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get metadata_publish;

  /// No description provided for @metadata_publishSuccess.
  ///
  /// In en, this message translates to:
  /// **'Metadata published successfully'**
  String get metadata_publishSuccess;

  /// No description provided for @metadata_saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get metadata_saveDraft;

  /// No description provided for @metadata_draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get metadata_draftSaved;

  /// No description provided for @metadata_discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get metadata_discardChanges;

  /// No description provided for @metadata_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get metadata_title;

  /// No description provided for @metadata_titleHint.
  ///
  /// In en, this message translates to:
  /// **'App name (max {limit} chars)'**
  String metadata_titleHint(int limit);

  /// No description provided for @metadata_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get metadata_subtitle;

  /// No description provided for @metadata_subtitleHint.
  ///
  /// In en, this message translates to:
  /// **'Brief tagline (max {limit} chars)'**
  String metadata_subtitleHint(int limit);

  /// No description provided for @metadata_keywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get metadata_keywords;

  /// No description provided for @metadata_keywordsHint.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated keywords (max {limit} chars)'**
  String metadata_keywordsHint(int limit);

  /// No description provided for @metadata_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get metadata_description;

  /// No description provided for @metadata_descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Full app description (max {limit} chars)'**
  String metadata_descriptionHint(int limit);

  /// No description provided for @metadata_promotionalText.
  ///
  /// In en, this message translates to:
  /// **'Promotional Text'**
  String get metadata_promotionalText;

  /// No description provided for @metadata_promotionalTextHint.
  ///
  /// In en, this message translates to:
  /// **'Short promotional message (max {limit} chars)'**
  String metadata_promotionalTextHint(int limit);

  /// No description provided for @metadata_whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get metadata_whatsNew;

  /// No description provided for @metadata_whatsNewHint.
  ///
  /// In en, this message translates to:
  /// **'Release notes (max {limit} chars)'**
  String metadata_whatsNewHint(int limit);

  /// No description provided for @metadata_charCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/{limit}'**
  String metadata_charCount(int count, int limit);

  /// No description provided for @metadata_hasChanges.
  ///
  /// In en, this message translates to:
  /// **'Has unsaved changes'**
  String get metadata_hasChanges;

  /// No description provided for @metadata_noChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes'**
  String get metadata_noChanges;

  /// No description provided for @metadata_keywordAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Keyword Analysis'**
  String get metadata_keywordAnalysis;

  /// No description provided for @metadata_keywordPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get metadata_keywordPresent;

  /// No description provided for @metadata_keywordMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get metadata_keywordMissing;

  /// No description provided for @metadata_inTitle.
  ///
  /// In en, this message translates to:
  /// **'In Title'**
  String get metadata_inTitle;

  /// No description provided for @metadata_inSubtitle.
  ///
  /// In en, this message translates to:
  /// **'In Subtitle'**
  String get metadata_inSubtitle;

  /// No description provided for @metadata_inKeywords.
  ///
  /// In en, this message translates to:
  /// **'In Keywords'**
  String get metadata_inKeywords;

  /// No description provided for @metadata_inDescription.
  ///
  /// In en, this message translates to:
  /// **'In Description'**
  String get metadata_inDescription;

  /// No description provided for @metadata_history.
  ///
  /// In en, this message translates to:
  /// **'Change History'**
  String get metadata_history;

  /// No description provided for @metadata_noHistory.
  ///
  /// In en, this message translates to:
  /// **'No changes recorded'**
  String get metadata_noHistory;

  /// No description provided for @metadata_localeComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get metadata_localeComplete;

  /// No description provided for @metadata_localeIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get metadata_localeIncomplete;

  /// No description provided for @metadata_shortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get metadata_shortDescription;

  /// No description provided for @metadata_shortDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Brief tagline shown in search (max {limit} chars)'**
  String metadata_shortDescriptionHint(int limit);

  /// No description provided for @metadata_fullDescription.
  ///
  /// In en, this message translates to:
  /// **'Full Description'**
  String get metadata_fullDescription;

  /// No description provided for @metadata_fullDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Complete app description (max {limit} chars)'**
  String metadata_fullDescriptionHint(int limit);

  /// No description provided for @metadata_releaseNotes.
  ///
  /// In en, this message translates to:
  /// **'Release Notes'**
  String get metadata_releaseNotes;

  /// No description provided for @metadata_releaseNotesHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in this version (max {limit} chars)'**
  String metadata_releaseNotesHint(int limit);

  /// No description provided for @metadata_selectAppFirst.
  ///
  /// In en, this message translates to:
  /// **'Select an app to edit metadata'**
  String get metadata_selectAppFirst;

  /// No description provided for @metadata_selectAppHint.
  ///
  /// In en, this message translates to:
  /// **'Use the app selector in the sidebar to choose an app, or connect a store to get started.'**
  String get metadata_selectAppHint;

  /// No description provided for @metadata_noStoreConnection.
  ///
  /// In en, this message translates to:
  /// **'Store connection required'**
  String get metadata_noStoreConnection;

  /// No description provided for @metadata_noStoreConnectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect your {storeName} account to fetch and edit your app\'s metadata.'**
  String metadata_noStoreConnectionDesc(String storeName);

  /// No description provided for @metadata_connectStoreButton.
  ///
  /// In en, this message translates to:
  /// **'Connect {storeName}'**
  String metadata_connectStoreButton(String storeName);

  /// No description provided for @metadataLocalization.
  ///
  /// In en, this message translates to:
  /// **'Localizations'**
  String get metadataLocalization;

  /// No description provided for @metadataLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get metadataLive;

  /// No description provided for @metadataDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get metadataDraft;

  /// No description provided for @metadataEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get metadataEmpty;

  /// No description provided for @metadataCoverageInsight.
  ///
  /// In en, this message translates to:
  /// **'{count} locales need content. Consider localizing for your top markets.'**
  String metadataCoverageInsight(int count);

  /// No description provided for @metadataFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get metadataFilterAll;

  /// No description provided for @metadataFilterLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get metadataFilterLive;

  /// No description provided for @metadataFilterDraft.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get metadataFilterDraft;

  /// No description provided for @metadataFilterEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get metadataFilterEmpty;

  /// No description provided for @metadataBulkActions.
  ///
  /// In en, this message translates to:
  /// **'Bulk Actions'**
  String get metadataBulkActions;

  /// No description provided for @metadataCopyTo.
  ///
  /// In en, this message translates to:
  /// **'Copy to selected'**
  String get metadataCopyTo;

  /// No description provided for @metadataTranslateTo.
  ///
  /// In en, this message translates to:
  /// **'Translate to selected'**
  String get metadataTranslateTo;

  /// No description provided for @metadataPublishSelected.
  ///
  /// In en, this message translates to:
  /// **'Publish selected'**
  String get metadataPublishSelected;

  /// No description provided for @metadataDeleteDrafts.
  ///
  /// In en, this message translates to:
  /// **'Delete drafts'**
  String get metadataDeleteDrafts;

  /// No description provided for @metadataSelectSource.
  ///
  /// In en, this message translates to:
  /// **'Select source locale'**
  String get metadataSelectSource;

  /// No description provided for @metadataSelectTarget.
  ///
  /// In en, this message translates to:
  /// **'Select target locales'**
  String get metadataSelectTarget;

  /// No description provided for @metadataCopySuccess.
  ///
  /// In en, this message translates to:
  /// **'Content copied to {count} locales'**
  String metadataCopySuccess(int count);

  /// No description provided for @metadataTranslateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Translated to {count} locales'**
  String metadataTranslateSuccess(int count);

  /// No description provided for @metadataTranslating.
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get metadataTranslating;

  /// No description provided for @metadataNoSelection.
  ///
  /// In en, this message translates to:
  /// **'Select locales first'**
  String get metadataNoSelection;

  /// No description provided for @metadataSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get metadataSelectAll;

  /// No description provided for @metadataDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get metadataDeselectAll;

  /// No description provided for @metadataSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String metadataSelected(int count);

  /// No description provided for @metadataTableView.
  ///
  /// In en, this message translates to:
  /// **'Table view'**
  String get metadataTableView;

  /// No description provided for @metadataListView.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get metadataListView;

  /// No description provided for @metadataStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get metadataStatus;

  /// No description provided for @metadataCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get metadataCompletion;

  /// No description provided for @common_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// No description provided for @common_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get common_next;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @metadata_aiOptimize.
  ///
  /// In en, this message translates to:
  /// **'AI Optimize'**
  String get metadata_aiOptimize;

  /// No description provided for @wizard_title.
  ///
  /// In en, this message translates to:
  /// **'AI Optimization Wizard'**
  String get wizard_title;

  /// No description provided for @wizard_step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get wizard_step;

  /// No description provided for @wizard_of.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get wizard_of;

  /// No description provided for @wizard_stepTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get wizard_stepTitle;

  /// No description provided for @wizard_stepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get wizard_stepSubtitle;

  /// No description provided for @wizard_stepKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get wizard_stepKeywords;

  /// No description provided for @wizard_stepDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get wizard_stepDescription;

  /// No description provided for @wizard_stepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & Save'**
  String get wizard_stepReview;

  /// No description provided for @wizard_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get wizard_skip;

  /// No description provided for @wizard_saveDrafts.
  ///
  /// In en, this message translates to:
  /// **'Save Drafts'**
  String get wizard_saveDrafts;

  /// No description provided for @wizard_draftsSaved.
  ///
  /// In en, this message translates to:
  /// **'Drafts saved successfully'**
  String get wizard_draftsSaved;

  /// No description provided for @wizard_exitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Wizard?'**
  String get wizard_exitTitle;

  /// No description provided for @wizard_exitMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to exit?'**
  String get wizard_exitMessage;

  /// No description provided for @wizard_exitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get wizard_exitConfirm;

  /// No description provided for @wizard_aiSuggestions.
  ///
  /// In en, this message translates to:
  /// **'AI Suggestions'**
  String get wizard_aiSuggestions;

  /// No description provided for @wizard_chooseSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Choose one of the AI-generated suggestions or write your own'**
  String get wizard_chooseSuggestion;

  /// No description provided for @wizard_currentValue.
  ///
  /// In en, this message translates to:
  /// **'Current Value'**
  String get wizard_currentValue;

  /// No description provided for @wizard_noCurrentValue.
  ///
  /// In en, this message translates to:
  /// **'No current value set'**
  String get wizard_noCurrentValue;

  /// No description provided for @wizard_contextInfo.
  ///
  /// In en, this message translates to:
  /// **'Based on {keywordsCount} tracked keywords and {competitorsCount} competitors'**
  String wizard_contextInfo(int keywordsCount, int competitorsCount);

  /// No description provided for @wizard_writeOwn.
  ///
  /// In en, this message translates to:
  /// **'Write my own'**
  String get wizard_writeOwn;

  /// No description provided for @wizard_customPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your custom value...'**
  String get wizard_customPlaceholder;

  /// No description provided for @wizard_useCustom.
  ///
  /// In en, this message translates to:
  /// **'Use Custom'**
  String get wizard_useCustom;

  /// No description provided for @wizard_keepCurrent.
  ///
  /// In en, this message translates to:
  /// **'Keep Current'**
  String get wizard_keepCurrent;

  /// No description provided for @wizard_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get wizard_recommended;

  /// No description provided for @wizard_characters.
  ///
  /// In en, this message translates to:
  /// **'characters'**
  String get wizard_characters;

  /// No description provided for @wizard_reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Changes'**
  String get wizard_reviewTitle;

  /// No description provided for @wizard_reviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Review your optimizations before saving them as drafts'**
  String get wizard_reviewDescription;

  /// No description provided for @wizard_noChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes selected'**
  String get wizard_noChanges;

  /// No description provided for @wizard_noChangesHint.
  ///
  /// In en, this message translates to:
  /// **'Go back and select suggestions for the fields you want to optimize'**
  String get wizard_noChangesHint;

  /// No description provided for @wizard_changesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} fields updated'**
  String wizard_changesCount(int count);

  /// No description provided for @wizard_changesSummary.
  ///
  /// In en, this message translates to:
  /// **'These changes will be saved as drafts'**
  String get wizard_changesSummary;

  /// No description provided for @wizard_before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get wizard_before;

  /// No description provided for @wizard_after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get wizard_after;

  /// No description provided for @wizard_nextStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'What happens next?'**
  String get wizard_nextStepsTitle;

  /// No description provided for @wizard_nextStepsWithChanges.
  ///
  /// In en, this message translates to:
  /// **'Your changes will be saved as drafts. You can review and publish them from the Metadata Editor.'**
  String get wizard_nextStepsWithChanges;

  /// No description provided for @wizard_nextStepsNoChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes to save. Go back and select suggestions to optimize your metadata.'**
  String get wizard_nextStepsNoChanges;

  /// No description provided for @team_title.
  ///
  /// In en, this message translates to:
  /// **'Team Management'**
  String get team_title;

  /// No description provided for @team_createTeam.
  ///
  /// In en, this message translates to:
  /// **'Create Team'**
  String get team_createTeam;

  /// No description provided for @team_teamName.
  ///
  /// In en, this message translates to:
  /// **'Team Name'**
  String get team_teamName;

  /// No description provided for @team_teamNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter team name'**
  String get team_teamNameHint;

  /// No description provided for @team_description.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get team_description;

  /// No description provided for @team_descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is this team for?'**
  String get team_descriptionHint;

  /// No description provided for @team_teamNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Team name is required'**
  String get team_teamNameRequired;

  /// No description provided for @team_teamNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Team name must be at least 2 characters'**
  String get team_teamNameMinLength;

  /// No description provided for @team_inviteMember.
  ///
  /// In en, this message translates to:
  /// **'Invite Team Member'**
  String get team_inviteMember;

  /// No description provided for @team_emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get team_emailAddress;

  /// No description provided for @team_emailHint.
  ///
  /// In en, this message translates to:
  /// **'colleague@example.com'**
  String get team_emailHint;

  /// No description provided for @team_emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get team_emailRequired;

  /// No description provided for @team_emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get team_emailInvalid;

  /// No description provided for @team_invitationSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent to {email}'**
  String team_invitationSent(String email);

  /// No description provided for @team_members.
  ///
  /// In en, this message translates to:
  /// **'MEMBERS'**
  String get team_members;

  /// No description provided for @team_invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get team_invite;

  /// No description provided for @team_pendingInvitations.
  ///
  /// In en, this message translates to:
  /// **'PENDING INVITATIONS'**
  String get team_pendingInvitations;

  /// No description provided for @team_noPendingInvitations.
  ///
  /// In en, this message translates to:
  /// **'No pending invitations'**
  String get team_noPendingInvitations;

  /// No description provided for @team_teamSettings.
  ///
  /// In en, this message translates to:
  /// **'Team Settings'**
  String get team_teamSettings;

  /// No description provided for @team_changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change Role for {name}'**
  String team_changeRole(String name);

  /// No description provided for @team_removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get team_removeMember;

  /// No description provided for @team_removeMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from this team?'**
  String team_removeMemberConfirm(String name);

  /// No description provided for @team_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get team_remove;

  /// No description provided for @team_leaveTeam.
  ///
  /// In en, this message translates to:
  /// **'Leave Team'**
  String get team_leaveTeam;

  /// No description provided for @team_leaveTeamConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave \"{teamName}\"?'**
  String team_leaveTeamConfirm(String teamName);

  /// No description provided for @team_leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get team_leave;

  /// No description provided for @team_deleteTeam.
  ///
  /// In en, this message translates to:
  /// **'Delete Team'**
  String get team_deleteTeam;

  /// No description provided for @team_deleteTeamConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{teamName}\"? This action cannot be undone.'**
  String team_deleteTeamConfirm(String teamName);

  /// No description provided for @team_yourTeams.
  ///
  /// In en, this message translates to:
  /// **'YOUR TEAMS'**
  String get team_yourTeams;

  /// No description provided for @team_failedToLoadTeam.
  ///
  /// In en, this message translates to:
  /// **'Failed to load team'**
  String get team_failedToLoadTeam;

  /// No description provided for @team_failedToLoadMembers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load members'**
  String get team_failedToLoadMembers;

  /// No description provided for @team_failedToLoadInvitations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load invitations'**
  String get team_failedToLoadInvitations;

  /// No description provided for @team_memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String team_memberCount(int count);

  /// No description provided for @team_invitedAs.
  ///
  /// In en, this message translates to:
  /// **'Invited as {role}'**
  String team_invitedAs(String role);

  /// No description provided for @team_joinedTeam.
  ///
  /// In en, this message translates to:
  /// **'Joined {teamName}'**
  String team_joinedTeam(String teamName);

  /// No description provided for @team_invitationDeclined.
  ///
  /// In en, this message translates to:
  /// **'Invitation declined'**
  String get team_invitationDeclined;

  /// No description provided for @team_noTeamsYet.
  ///
  /// In en, this message translates to:
  /// **'No Teams Yet'**
  String get team_noTeamsYet;

  /// No description provided for @team_noTeamsDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a team to collaborate with others on your apps'**
  String get team_noTeamsDescription;

  /// No description provided for @team_createFirstTeam.
  ///
  /// In en, this message translates to:
  /// **'Create Your First Team'**
  String get team_createFirstTeam;

  /// No description provided for @integrations_title.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get integrations_title;

  /// No description provided for @integrations_syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {error}'**
  String integrations_syncFailed(String error);

  /// No description provided for @integrations_disconnectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Disconnect?'**
  String get integrations_disconnectConfirm;

  /// No description provided for @integrations_disconnectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Disconnected successfully'**
  String get integrations_disconnectedSuccess;

  /// No description provided for @integrations_connectGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Play Console'**
  String get integrations_connectGooglePlay;

  /// No description provided for @integrations_connectAppStore.
  ///
  /// In en, this message translates to:
  /// **'Connect App Store Connect'**
  String get integrations_connectAppStore;

  /// No description provided for @integrations_connectedApps.
  ///
  /// In en, this message translates to:
  /// **'Connected! Imported {count} apps.'**
  String integrations_connectedApps(int count);

  /// No description provided for @integrations_syncedApps.
  ///
  /// In en, this message translates to:
  /// **'Synced {count} apps as owned'**
  String integrations_syncedApps(int count);

  /// No description provided for @integrations_appStoreConnected.
  ///
  /// In en, this message translates to:
  /// **'App Store Connect connected successfully!'**
  String get integrations_appStoreConnected;

  /// No description provided for @integrations_googlePlayConnected.
  ///
  /// In en, this message translates to:
  /// **'Google Play Console connected successfully!'**
  String get integrations_googlePlayConnected;

  /// No description provided for @integrations_description.
  ///
  /// In en, this message translates to:
  /// **'Connect your store accounts to import apps, reply to reviews, and access analytics.'**
  String get integrations_description;

  /// No description provided for @integrations_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading integrations: {error}'**
  String integrations_errorLoading(String error);

  /// No description provided for @integrations_syncedAppsDetails.
  ///
  /// In en, this message translates to:
  /// **'Synced {imported} apps ({discovered} discovered)'**
  String integrations_syncedAppsDetails(int imported, int discovered);

  /// No description provided for @integrations_appStoreConnect.
  ///
  /// In en, this message translates to:
  /// **'App Store Connect'**
  String get integrations_appStoreConnect;

  /// No description provided for @integrations_connectAppleAccount.
  ///
  /// In en, this message translates to:
  /// **'Connect your Apple Developer account'**
  String get integrations_connectAppleAccount;

  /// No description provided for @integrations_googlePlayConsole.
  ///
  /// In en, this message translates to:
  /// **'Google Play Console'**
  String get integrations_googlePlayConsole;

  /// No description provided for @integrations_connectGoogleAccount.
  ///
  /// In en, this message translates to:
  /// **'Connect your Google Play account'**
  String get integrations_connectGoogleAccount;

  /// No description provided for @integrations_disconnectConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect {type}? This will remove {count} imported apps.'**
  String integrations_disconnectConfirmMessage(String type, int count);

  /// No description provided for @integrations_disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get integrations_disconnect;

  /// No description provided for @integrations_connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get integrations_connect;

  /// No description provided for @integrations_connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get integrations_connected;

  /// No description provided for @integrations_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get integrations_error;

  /// No description provided for @integrations_syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get integrations_syncing;

  /// No description provided for @integrations_refreshApps.
  ///
  /// In en, this message translates to:
  /// **'Refresh Apps'**
  String get integrations_refreshApps;

  /// No description provided for @integrations_lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced: {date}'**
  String integrations_lastSynced(String date);

  /// No description provided for @integrations_connectedOn.
  ///
  /// In en, this message translates to:
  /// **'Connected on {date}'**
  String integrations_connectedOn(String date);

  /// No description provided for @integrations_appsImported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app imported} other{{count} apps imported}}'**
  String integrations_appsImported(int count);

  /// No description provided for @alertBuilder_nameYourRule.
  ///
  /// In en, this message translates to:
  /// **'NAME YOUR RULE'**
  String get alertBuilder_nameYourRule;

  /// No description provided for @alertBuilder_nameDescription.
  ///
  /// In en, this message translates to:
  /// **'Give your alert rule a descriptive name'**
  String get alertBuilder_nameDescription;

  /// No description provided for @alertBuilder_nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Daily Position Alert'**
  String get alertBuilder_nameHint;

  /// No description provided for @alertBuilder_summary.
  ///
  /// In en, this message translates to:
  /// **'SUMMARY'**
  String get alertBuilder_summary;

  /// No description provided for @alertBuilder_saveAlertRule.
  ///
  /// In en, this message translates to:
  /// **'Save Alert Rule'**
  String get alertBuilder_saveAlertRule;

  /// No description provided for @alertBuilder_selectAlertType.
  ///
  /// In en, this message translates to:
  /// **'SELECT ALERT TYPE'**
  String get alertBuilder_selectAlertType;

  /// No description provided for @alertBuilder_selectAlertTypeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose what kind of alert you want to create'**
  String get alertBuilder_selectAlertTypeDescription;

  /// No description provided for @alertBuilder_deleteRuleConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will delete \"{ruleName}\".'**
  String alertBuilder_deleteRuleConfirm(String ruleName);

  /// No description provided for @alertBuilder_activateTemplateOrCreate.
  ///
  /// In en, this message translates to:
  /// **'No rules yet. Activate a template or create your own!'**
  String get alertBuilder_activateTemplateOrCreate;

  /// No description provided for @billing_cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get billing_cancelSubscription;

  /// No description provided for @billing_keepSubscription.
  ///
  /// In en, this message translates to:
  /// **'Keep Subscription'**
  String get billing_keepSubscription;

  /// No description provided for @billing_billingPortal.
  ///
  /// In en, this message translates to:
  /// **'Billing Portal'**
  String get billing_billingPortal;

  /// No description provided for @billing_resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get billing_resume;

  /// No description provided for @keywords_noCompetitorsFound.
  ///
  /// In en, this message translates to:
  /// **'No competitors found. Add competitors first.'**
  String get keywords_noCompetitorsFound;

  /// No description provided for @keywords_noCompetitorsForApp.
  ///
  /// In en, this message translates to:
  /// **'No competitors for this app. Add a competitor first.'**
  String get keywords_noCompetitorsForApp;

  /// No description provided for @keywords_failedToAddKeywords.
  ///
  /// In en, this message translates to:
  /// **'Failed to add keywords: {error}'**
  String keywords_failedToAddKeywords(String error);

  /// No description provided for @keywords_bulkAddHint.
  ///
  /// In en, this message translates to:
  /// **'budget tracker\nexpense manager\nmoney app'**
  String get keywords_bulkAddHint;

  /// No description provided for @appOverview_urlCopied.
  ///
  /// In en, this message translates to:
  /// **'Store URL copied to clipboard'**
  String get appOverview_urlCopied;

  /// No description provided for @country_us.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get country_us;

  /// No description provided for @country_gb.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get country_gb;

  /// No description provided for @country_fr.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get country_fr;

  /// No description provided for @country_de.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get country_de;

  /// No description provided for @country_ca.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get country_ca;

  /// No description provided for @country_au.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get country_au;

  /// No description provided for @country_jp.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get country_jp;

  /// No description provided for @country_cn.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get country_cn;

  /// No description provided for @country_kr.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get country_kr;

  /// No description provided for @country_br.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get country_br;

  /// No description provided for @country_es.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get country_es;

  /// No description provided for @country_it.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get country_it;

  /// No description provided for @countryCode_us.
  ///
  /// In en, this message translates to:
  /// **'🇺🇸 US'**
  String get countryCode_us;

  /// No description provided for @countryCode_gb.
  ///
  /// In en, this message translates to:
  /// **'🇬🇧 UK'**
  String get countryCode_gb;

  /// No description provided for @countryCode_fr.
  ///
  /// In en, this message translates to:
  /// **'🇫🇷 FR'**
  String get countryCode_fr;

  /// No description provided for @countryCode_de.
  ///
  /// In en, this message translates to:
  /// **'🇩🇪 DE'**
  String get countryCode_de;

  /// No description provided for @countryCode_ca.
  ///
  /// In en, this message translates to:
  /// **'🇨🇦 CA'**
  String get countryCode_ca;

  /// No description provided for @countryCode_au.
  ///
  /// In en, this message translates to:
  /// **'🇦🇺 AU'**
  String get countryCode_au;

  /// No description provided for @alertBuilder_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get alertBuilder_type;

  /// No description provided for @alertBuilder_scope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get alertBuilder_scope;

  /// No description provided for @alertBuilder_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get alertBuilder_name;

  /// No description provided for @alertBuilder_scopeGlobal.
  ///
  /// In en, this message translates to:
  /// **'All Apps'**
  String get alertBuilder_scopeGlobal;

  /// No description provided for @alertBuilder_scopeApp.
  ///
  /// In en, this message translates to:
  /// **'Specific App'**
  String get alertBuilder_scopeApp;

  /// No description provided for @alertBuilder_scopeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get alertBuilder_scopeCategory;

  /// No description provided for @alertBuilder_scopeKeyword.
  ///
  /// In en, this message translates to:
  /// **'Keyword'**
  String get alertBuilder_scopeKeyword;

  /// No description provided for @alertType_positionChange.
  ///
  /// In en, this message translates to:
  /// **'Position Change'**
  String get alertType_positionChange;

  /// No description provided for @alertType_positionChangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert when app rank changes significantly'**
  String get alertType_positionChangeDesc;

  /// No description provided for @alertType_ratingChange.
  ///
  /// In en, this message translates to:
  /// **'Rating Change'**
  String get alertType_ratingChange;

  /// No description provided for @alertType_ratingChangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert when app rating changes'**
  String get alertType_ratingChangeDesc;

  /// No description provided for @alertType_reviewSpike.
  ///
  /// In en, this message translates to:
  /// **'Review Spike'**
  String get alertType_reviewSpike;

  /// No description provided for @alertType_reviewSpikeDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert on unusual review activity'**
  String get alertType_reviewSpikeDesc;

  /// No description provided for @alertType_reviewKeyword.
  ///
  /// In en, this message translates to:
  /// **'Review Keyword'**
  String get alertType_reviewKeyword;

  /// No description provided for @alertType_reviewKeywordDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert when keywords appear in reviews'**
  String get alertType_reviewKeywordDesc;

  /// No description provided for @alertType_newCompetitor.
  ///
  /// In en, this message translates to:
  /// **'New Competitor'**
  String get alertType_newCompetitor;

  /// No description provided for @alertType_newCompetitorDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert when new apps enter your space'**
  String get alertType_newCompetitorDesc;

  /// No description provided for @alertType_competitorPassed.
  ///
  /// In en, this message translates to:
  /// **'Competitor Passed'**
  String get alertType_competitorPassed;

  /// No description provided for @alertType_competitorPassedDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert when you overtake a competitor'**
  String get alertType_competitorPassedDesc;

  /// No description provided for @alertType_massMovement.
  ///
  /// In en, this message translates to:
  /// **'Mass Movement'**
  String get alertType_massMovement;

  /// No description provided for @alertType_massMovementDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert on large ranking shifts'**
  String get alertType_massMovementDesc;

  /// No description provided for @alertType_keywordTrend.
  ///
  /// In en, this message translates to:
  /// **'Keyword Trend'**
  String get alertType_keywordTrend;

  /// No description provided for @alertType_keywordTrendDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert when keyword popularity changes'**
  String get alertType_keywordTrendDesc;

  /// No description provided for @alertType_opportunity.
  ///
  /// In en, this message translates to:
  /// **'Opportunity'**
  String get alertType_opportunity;

  /// No description provided for @alertType_opportunityDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert on new ranking opportunities'**
  String get alertType_opportunityDesc;

  /// No description provided for @billing_title.
  ///
  /// In en, this message translates to:
  /// **'Billing & Plans'**
  String get billing_title;

  /// No description provided for @billing_subscriptionActivated.
  ///
  /// In en, this message translates to:
  /// **'Subscription activated successfully!'**
  String get billing_subscriptionActivated;

  /// No description provided for @billing_changePlan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get billing_changePlan;

  /// No description provided for @billing_choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a Plan'**
  String get billing_choosePlan;

  /// No description provided for @billing_cancelMessage.
  ///
  /// In en, this message translates to:
  /// **'Your subscription will remain active until the end of the current billing period. After that, you will lose access to premium features.'**
  String get billing_cancelMessage;

  /// No description provided for @billing_currentPlan.
  ///
  /// In en, this message translates to:
  /// **'CURRENT PLAN'**
  String get billing_currentPlan;

  /// No description provided for @billing_trial.
  ///
  /// In en, this message translates to:
  /// **'TRIAL'**
  String get billing_trial;

  /// No description provided for @billing_canceling.
  ///
  /// In en, this message translates to:
  /// **'CANCELING'**
  String get billing_canceling;

  /// No description provided for @billing_accessUntil.
  ///
  /// In en, this message translates to:
  /// **'Access until {date}'**
  String billing_accessUntil(String date);

  /// No description provided for @billing_renewsOn.
  ///
  /// In en, this message translates to:
  /// **'Renews {date}'**
  String billing_renewsOn(String date);

  /// No description provided for @billing_manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'MANAGE SUBSCRIPTION'**
  String get billing_manageSubscription;

  /// No description provided for @billing_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get billing_monthly;

  /// No description provided for @billing_yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get billing_yearly;

  /// No description provided for @billing_savePercent.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String billing_savePercent(int percent);

  /// No description provided for @billing_current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get billing_current;

  /// No description provided for @billing_apps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get billing_apps;

  /// No description provided for @billing_unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get billing_unlimited;

  /// No description provided for @billing_keywordsPerApp.
  ///
  /// In en, this message translates to:
  /// **'Keywords per app'**
  String get billing_keywordsPerApp;

  /// No description provided for @billing_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get billing_history;

  /// No description provided for @billing_days.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String billing_days(int count);

  /// No description provided for @billing_exports.
  ///
  /// In en, this message translates to:
  /// **'Exports'**
  String get billing_exports;

  /// No description provided for @billing_aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get billing_aiInsights;

  /// No description provided for @billing_apiAccess.
  ///
  /// In en, this message translates to:
  /// **'API Access'**
  String get billing_apiAccess;

  /// No description provided for @billing_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get billing_yes;

  /// No description provided for @billing_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get billing_no;

  /// No description provided for @billing_currentPlanButton.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get billing_currentPlanButton;

  /// No description provided for @billing_upgradeTo.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to {planName}'**
  String billing_upgradeTo(String planName);

  /// No description provided for @billing_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get billing_cancel;

  /// No description provided for @keywords_compareWithCompetitor.
  ///
  /// In en, this message translates to:
  /// **'Compare with Competitor'**
  String get keywords_compareWithCompetitor;

  /// No description provided for @keywords_selectCompetitorToCompare.
  ///
  /// In en, this message translates to:
  /// **'Select a competitor to compare keywords:'**
  String get keywords_selectCompetitorToCompare;

  /// No description provided for @keywords_addToCompetitor.
  ///
  /// In en, this message translates to:
  /// **'Add to Competitor'**
  String get keywords_addToCompetitor;

  /// No description provided for @keywords_addKeywordsTo.
  ///
  /// In en, this message translates to:
  /// **'Add {count} keyword(s) to:'**
  String keywords_addKeywordsTo(int count);

  /// No description provided for @keywords_avgPosition.
  ///
  /// In en, this message translates to:
  /// **'Avg Position'**
  String get keywords_avgPosition;

  /// No description provided for @keywords_declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get keywords_declined;

  /// No description provided for @keywords_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get keywords_total;

  /// No description provided for @keywords_ranked.
  ///
  /// In en, this message translates to:
  /// **'Ranked'**
  String get keywords_ranked;

  /// No description provided for @keywords_improved.
  ///
  /// In en, this message translates to:
  /// **'Improved'**
  String get keywords_improved;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @onboarding_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboarding_back;

  /// No description provided for @onboarding_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboarding_continue;

  /// No description provided for @onboarding_getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_getStarted;

  /// No description provided for @onboarding_welcomeToKeyrank.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Keyrank'**
  String get onboarding_welcomeToKeyrank;

  /// No description provided for @onboarding_welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your app rankings, manage reviews, and optimize your ASO strategy.'**
  String get onboarding_welcomeSubtitle;

  /// No description provided for @onboarding_connectStore.
  ///
  /// In en, this message translates to:
  /// **'Connect Your Store'**
  String get onboarding_connectStore;

  /// No description provided for @onboarding_connectStoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional: Connect to import apps and reply to reviews.'**
  String get onboarding_connectStoreSubtitle;

  /// No description provided for @onboarding_couldNotLoadIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Could not load integrations'**
  String get onboarding_couldNotLoadIntegrations;

  /// No description provided for @onboarding_tapToConnect.
  ///
  /// In en, this message translates to:
  /// **'Tap to connect'**
  String get onboarding_tapToConnect;

  /// No description provided for @onboarding_allSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re All Set!'**
  String get onboarding_allSet;

  /// No description provided for @onboarding_allSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by adding an app to track, or explore the keyword inspector.'**
  String get onboarding_allSetSubtitle;

  /// No description provided for @team_you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get team_you;

  /// No description provided for @team_changeRoleButton.
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get team_changeRoleButton;

  /// No description provided for @team_removeButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get team_removeButton;

  /// No description provided for @competitors_removeTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Competitor'**
  String get competitors_removeTitle;

  /// No description provided for @competitors_removeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{name}\" from your competitors?'**
  String competitors_removeConfirm(String name);

  /// No description provided for @competitors_removed.
  ///
  /// In en, this message translates to:
  /// **'{name} removed'**
  String competitors_removed(String name);

  /// No description provided for @competitors_removeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove competitor: {error}'**
  String competitors_removeFailed(String error);

  /// No description provided for @competitors_addCompetitor.
  ///
  /// In en, this message translates to:
  /// **'Add competitor'**
  String get competitors_addCompetitor;

  /// No description provided for @competitors_filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get competitors_filterAll;

  /// No description provided for @competitors_filterGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get competitors_filterGlobal;

  /// No description provided for @competitors_filterContextual.
  ///
  /// In en, this message translates to:
  /// **'Contextual'**
  String get competitors_filterContextual;

  /// No description provided for @competitors_noCompetitorsYet.
  ///
  /// In en, this message translates to:
  /// **'No competitors tracked yet'**
  String get competitors_noCompetitorsYet;

  /// No description provided for @competitors_noGlobalCompetitors.
  ///
  /// In en, this message translates to:
  /// **'No global competitors'**
  String get competitors_noGlobalCompetitors;

  /// No description provided for @competitors_noContextualCompetitors.
  ///
  /// In en, this message translates to:
  /// **'No contextual competitors'**
  String get competitors_noContextualCompetitors;

  /// No description provided for @competitors_emptySubtitleAll.
  ///
  /// In en, this message translates to:
  /// **'Search for apps and add them as competitors to track their rankings'**
  String get competitors_emptySubtitleAll;

  /// No description provided for @competitors_emptySubtitleGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global competitors appear across all your apps'**
  String get competitors_emptySubtitleGlobal;

  /// No description provided for @competitors_emptySubtitleContextual.
  ///
  /// In en, this message translates to:
  /// **'Contextual competitors are linked to specific apps'**
  String get competitors_emptySubtitleContextual;

  /// No description provided for @competitors_searchForCompetitors.
  ///
  /// In en, this message translates to:
  /// **'Search for competitors'**
  String get competitors_searchForCompetitors;

  /// No description provided for @competitors_viewKeywords.
  ///
  /// In en, this message translates to:
  /// **'View Keywords'**
  String get competitors_viewKeywords;

  /// No description provided for @common_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get common_remove;

  /// No description provided for @competitors_addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Competitor'**
  String get competitors_addTitle;

  /// No description provided for @competitors_addedAsCompetitor.
  ///
  /// In en, this message translates to:
  /// **'{name} added as competitor'**
  String competitors_addedAsCompetitor(String name);

  /// No description provided for @competitors_addFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add competitor: {error}'**
  String competitors_addFailed(String error);

  /// No description provided for @competitors_searchForCompetitor.
  ///
  /// In en, this message translates to:
  /// **'Search for a competitor'**
  String get competitors_searchForCompetitor;

  /// No description provided for @appPreview_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get appPreview_back;

  /// No description provided for @alerts_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get alerts_edit;

  /// No description provided for @alerts_scopeGlobal.
  ///
  /// In en, this message translates to:
  /// **'All apps'**
  String get alerts_scopeGlobal;

  /// No description provided for @alerts_scopeApp.
  ///
  /// In en, this message translates to:
  /// **'Specific app'**
  String get alerts_scopeApp;

  /// No description provided for @alerts_scopeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get alerts_scopeCategory;

  /// No description provided for @alerts_scopeKeyword.
  ///
  /// In en, this message translates to:
  /// **'Keyword'**
  String get alerts_scopeKeyword;

  /// No description provided for @ratings_showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more ({count} remaining)'**
  String ratings_showMore(int count);

  /// No description provided for @ratings_showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get ratings_showLess;

  /// No description provided for @insights_aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get insights_aiInsights;

  /// No description provided for @insights_viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get insights_viewAll;

  /// No description provided for @insights_viewMore.
  ///
  /// In en, this message translates to:
  /// **'View {count} more insights'**
  String insights_viewMore(int count);

  /// No description provided for @insights_noInsightsDesc.
  ///
  /// In en, this message translates to:
  /// **'AI-powered insights will appear here as we analyze your apps'**
  String get insights_noInsightsDesc;

  /// No description provided for @insights_loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load insights'**
  String get insights_loadFailed;

  /// No description provided for @chat_createFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create conversation: {error}'**
  String chat_createFailed(String error);

  /// No description provided for @chat_deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String chat_deleteFailed(String error);

  /// No description provided for @notifications_manageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage alerts'**
  String get notifications_manageAlerts;
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
