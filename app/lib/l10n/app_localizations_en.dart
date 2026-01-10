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
  String get common_search => 'Search...';

  @override
  String get common_noResults => 'No results found';

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

  @override
  String get insights_compareTitle => 'Compare Insights';

  @override
  String get insights_analyzingReviews => 'Analyzing reviews...';

  @override
  String get insights_noInsightsAvailable => 'No insights available';

  @override
  String get insights_strengths => 'Strengths';

  @override
  String get insights_weaknesses => 'Weaknesses';

  @override
  String get insights_scores => 'Scores';

  @override
  String get insights_opportunities => 'Opportunities';

  @override
  String get insights_categoryUx => 'UX';

  @override
  String get insights_categoryPerf => 'Perf';

  @override
  String get insights_categoryFeatures => 'Features';

  @override
  String get insights_categoryPricing => 'Pricing';

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
  String get insights_reviewInsights => 'Review Insights';

  @override
  String get insights_generateFirst => 'Generate insights first';

  @override
  String get insights_compareWithOther => 'Compare with other apps';

  @override
  String get insights_compare => 'Compare';

  @override
  String get insights_generateAnalysis => 'Generate Analysis';

  @override
  String get insights_period => 'Period:';

  @override
  String get insights_3months => '3 months';

  @override
  String get insights_6months => '6 months';

  @override
  String get insights_12months => '12 months';

  @override
  String get insights_analyze => 'Analyze';

  @override
  String insights_reviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String insights_analyzedAgo(String time) {
    return 'Analyzed $time';
  }

  @override
  String get insights_yourNotes => 'Your Notes';

  @override
  String get insights_save => 'Save';

  @override
  String get insights_clickToAddNotes => 'Click to add notes...';

  @override
  String get insights_noteSaved => 'Note saved';

  @override
  String get insights_noteHint =>
      'Add your notes about this insight analysis...';

  @override
  String get insights_categoryScores => 'Category Scores';

  @override
  String get insights_emergentThemes => 'Emergent Themes';

  @override
  String get insights_exampleQuotes => 'Example quotes:';

  @override
  String get insights_selectCountryFirst => 'Select at least one country';

  @override
  String compare_selectAppsToCompare(String appName) {
    return 'Select up to 3 apps to compare with $appName';
  }

  @override
  String get compare_searchApps => 'Search apps...';

  @override
  String get compare_noOtherApps => 'No other apps to compare';

  @override
  String get compare_noMatchingApps => 'No matching apps';

  @override
  String compare_appsSelected(int count) {
    return '$count of 3 apps selected';
  }

  @override
  String get compare_cancel => 'Cancel';

  @override
  String compare_button(int count) {
    return 'Compare $count Apps';
  }

  @override
  String get appDetail_deleteAppTitle => 'Delete app?';

  @override
  String get appDetail_deleteAppConfirm => 'This action cannot be undone.';

  @override
  String get appDetail_cancel => 'Cancel';

  @override
  String get appDetail_delete => 'Delete';

  @override
  String get appDetail_exporting => 'Exporting rankings...';

  @override
  String appDetail_savedFile(String filename) {
    return 'Saved: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Show in Finder';

  @override
  String appDetail_exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return 'Imported $imported keywords ($skipped skipped)';
  }

  @override
  String get appDetail_favorite => 'Favorite';

  @override
  String get appDetail_ratings => 'Ratings';

  @override
  String get appDetail_insights => 'Insights';

  @override
  String get appDetail_import => 'Import';

  @override
  String get appDetail_export => 'Export';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String get appDetail_keywords => 'keywords';

  @override
  String get appDetail_addKeyword => 'Add keyword';

  @override
  String get appDetail_keywordHint => 'e.g., fitness tracker';

  @override
  String get appDetail_trackedKeywords => 'Tracked Keywords';

  @override
  String appDetail_selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get appDetail_allKeywords => 'All Keywords';

  @override
  String get appDetail_hasTags => 'Has Tags';

  @override
  String get appDetail_hasNotes => 'Has Notes';

  @override
  String get appDetail_position => 'Position';

  @override
  String get appDetail_select => 'Select';

  @override
  String get appDetail_suggestions => 'Suggestions';

  @override
  String get appDetail_deleteKeywordsTitle => 'Delete Keywords';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return 'Are you sure you want to delete $count keywords?';
  }

  @override
  String get appDetail_tag => 'Tag';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return 'Keyword \"$keyword\" added ($flag)';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return 'Tags added to $count keywords';
  }

  @override
  String get appDetail_keywordsAddedSuccess => 'Keywords added successfully';

  @override
  String get appDetail_noTagsAvailable =>
      'No tags available. Create tags first.';

  @override
  String get appDetail_tagged => 'Tagged';

  @override
  String get appDetail_withNotes => 'With Notes';

  @override
  String get appDetail_nameAZ => 'Name A-Z';

  @override
  String get appDetail_nameZA => 'Name Z-A';

  @override
  String get appDetail_bestPosition => 'Best Position';

  @override
  String get appDetail_recentlyTracked => 'Recently Tracked';

  @override
  String get keywordSuggestions_title => 'Keyword Suggestions';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$appName in $country';
  }

  @override
  String get keywordSuggestions_refresh => 'Refresh suggestions';

  @override
  String get keywordSuggestions_search => 'Search suggestions...';

  @override
  String get keywordSuggestions_selectAll => 'Select All';

  @override
  String get keywordSuggestions_clear => 'Clear';

  @override
  String get keywordSuggestions_analyzing => 'Analyzing app metadata...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds =>
      'This may take a few seconds';

  @override
  String get keywordSuggestions_noSuggestions => 'No suggestions available';

  @override
  String get keywordSuggestions_noMatchingSuggestions =>
      'No matching suggestions';

  @override
  String get keywordSuggestions_headerKeyword => 'KEYWORD';

  @override
  String get keywordSuggestions_headerDifficulty => 'DIFFICULTY';

  @override
  String get keywordSuggestions_headerApps => 'APPS';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return 'Ranked #$position';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count keywords selected';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return 'Add $count Keywords';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Error adding keywords: $error';
  }

  @override
  String get sidebar_favorites => 'FAVORITES';

  @override
  String get sidebar_tooManyFavorites =>
      'Consider keeping 5 or fewer favorites';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Keyword Research';

  @override
  String get keywordSearch_searchPlaceholder => 'Search keywords...';

  @override
  String get keywordSearch_searchTitle => 'Search for a keyword';

  @override
  String get keywordSearch_searchSubtitle =>
      'Discover which apps rank for any keyword';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count apps ranked';
  }

  @override
  String get keywordSearch_popularity => 'Popularity';

  @override
  String keywordSearch_results(int count) {
    return '$count results';
  }

  @override
  String get keywordSearch_headerRank => 'RANK';

  @override
  String get keywordSearch_headerApp => 'APP';

  @override
  String get keywordSearch_headerRating => 'RATING';

  @override
  String get keywordSearch_headerTrack => 'TRACK';

  @override
  String get keywordSearch_trackApp => 'Track this app';

  @override
  String reviews_reviewsFor(String appName) {
    return 'Reviews for $appName';
  }

  @override
  String get reviews_loading => 'Loading reviews...';

  @override
  String get reviews_noReviews => 'No reviews';

  @override
  String reviews_noReviewsFor(String countryName) {
    return 'No reviews found for $countryName';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'Showing the $count most recent reviews from the App Store.';
  }

  @override
  String get reviews_today => 'Today';

  @override
  String get reviews_yesterday => 'Yesterday';

  @override
  String reviews_daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String reviews_weeksAgo(int count) {
    return '$count weeks ago';
  }

  @override
  String reviews_monthsAgo(int count) {
    return '$count months ago';
  }

  @override
  String get ratings_byCountry => 'Ratings by Country';

  @override
  String get ratings_noRatingsAvailable => 'No ratings available';

  @override
  String get ratings_noRatingsYet => 'This app has no ratings yet';

  @override
  String get ratings_totalRatings => 'Total Ratings';

  @override
  String get ratings_averageRating => 'Average Rating';

  @override
  String ratings_countriesCount(int count) {
    return '$count countries';
  }

  @override
  String ratings_updated(String date) {
    return 'Updated: $date';
  }

  @override
  String get ratings_headerCountry => 'COUNTRY';

  @override
  String get ratings_headerRatings => 'RATINGS';

  @override
  String get ratings_headerAverage => 'AVERAGE';

  @override
  String time_minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String time_hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String time_daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get appDetail_noKeywordsTracked => 'No keywords tracked';

  @override
  String get appDetail_addKeywordHint =>
      'Add a keyword above to start tracking';

  @override
  String get appDetail_noKeywordsMatchFilter => 'No keywords match filter';

  @override
  String get appDetail_tryChangingFilter => 'Try changing the filter criteria';

  @override
  String get appDetail_addTag => 'Add tag';

  @override
  String get appDetail_addNote => 'Add note';

  @override
  String get appDetail_positionHistory => 'Position History';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => 'OVERVIEW';

  @override
  String get nav_dashboard => 'Dashboard';

  @override
  String get nav_myApps => 'My Apps';

  @override
  String get nav_research => 'RESEARCH';

  @override
  String get nav_keywords => 'Keywords';

  @override
  String get common_save => 'Save';

  @override
  String get appDetail_manageTags => 'Manage Tags';

  @override
  String get appDetail_newTagHint => 'New tag name...';

  @override
  String get appDetail_availableTags => 'Available Tags';

  @override
  String get appDetail_noTagsYet => 'No tags yet. Create one above.';

  @override
  String get appDetail_addTagsTitle => 'Add Tags';

  @override
  String get appDetail_selectTagsDescription =>
      'Select tags to add to selected keywords:';

  @override
  String appDetail_addTagsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tags',
      one: 'Tag',
    );
    return 'Add $count $_temp0';
  }

  @override
  String appDetail_importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Import Keywords';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Paste keywords below, one per line:';

  @override
  String get appDetail_keywordPlaceholder =>
      'keyword one\nkeyword two\nkeyword three';

  @override
  String get appDetail_storefront => 'Storefront:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count keywords';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return 'Import $count Keywords';
  }

  @override
  String get appDetail_period7d => '7d';

  @override
  String get appDetail_period30d => '30d';

  @override
  String get appDetail_period90d => '90d';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }
}
