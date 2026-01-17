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
  String get dashboard_reviews => 'Reviews';

  @override
  String get dashboard_avgRating => 'Avg Rating';

  @override
  String get dashboard_topPerformingApps => 'Top Performing Apps';

  @override
  String get dashboard_topCountries => 'Top Countries';

  @override
  String get dashboard_sentimentOverview => 'Sentiment Overview';

  @override
  String get dashboard_overallSentiment => 'Overall Sentiment';

  @override
  String get dashboard_positive => 'Positive';

  @override
  String get dashboard_positiveReviews => 'Positive';

  @override
  String get dashboard_negativeReviews => 'Negative';

  @override
  String get dashboard_viewReviews => 'View reviews';

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
  String get keywordSuggestions_categoryAll => 'All';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'High Opportunity';

  @override
  String get keywordSuggestions_categoryCompetitor => 'Competitor Keywords';

  @override
  String get keywordSuggestions_categoryLongTail => 'Long-tail';

  @override
  String get keywordSuggestions_categoryTrending => 'Trending';

  @override
  String get keywordSuggestions_categoryRelated => 'Related';

  @override
  String get keywordSuggestions_generating => 'Generating suggestions...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      'This may take a few minutes. Please check back later.';

  @override
  String get keywordSuggestions_checkAgain => 'Check again';

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
  String get discover_title => 'Discover';

  @override
  String get discover_tabKeywords => 'Keywords';

  @override
  String get discover_tabCategories => 'Categories';

  @override
  String get discover_selectCategory => 'Select a category';

  @override
  String get discover_topFree => 'Free';

  @override
  String get discover_topPaid => 'Paid';

  @override
  String get discover_topGrossing => 'Grossing';

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
  String get nav_discover => 'Discover';

  @override
  String get nav_engagement => 'ENGAGEMENT';

  @override
  String get nav_reviewsInbox => 'Reviews Inbox';

  @override
  String get nav_notifications => 'Alerts';

  @override
  String get nav_optimization => 'OPTIMIZATION';

  @override
  String get nav_keywordInspector => 'Keyword Inspector';

  @override
  String get nav_ratingsAnalysis => 'Ratings Analysis';

  @override
  String get nav_intelligence => 'INTELLIGENCE';

  @override
  String get nav_topCharts => 'Top Charts';

  @override
  String get nav_competitors => 'Competitors';

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
  String get appDetail_currentTags => 'Current Tags';

  @override
  String get appDetail_noTagsOnKeyword => 'No tags on this keyword';

  @override
  String get appDetail_addExistingTag => 'Add Existing Tag';

  @override
  String get appDetail_allTagsUsed => 'All tags already added';

  @override
  String get appDetail_createNewTag => 'Create New Tag';

  @override
  String get appDetail_tagNameHint => 'Tag name...';

  @override
  String get appDetail_note => 'Note';

  @override
  String get appDetail_noteHint => 'Add a note about this keyword...';

  @override
  String get appDetail_saveNote => 'Save Note';

  @override
  String get appDetail_done => 'Done';

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
  String get keywords_difficultyFilter => 'Difficulty:';

  @override
  String get keywords_difficultyAll => 'All';

  @override
  String get keywords_difficultyEasy => 'Easy < 40';

  @override
  String get keywords_difficultyMedium => 'Medium 40-70';

  @override
  String get keywords_difficultyHard => 'Hard > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'App Details';

  @override
  String get appPreview_notFound => 'App not found';

  @override
  String get appPreview_screenshots => 'Screenshots';

  @override
  String get appPreview_description => 'Description';

  @override
  String get appPreview_details => 'Details';

  @override
  String get appPreview_version => 'Version';

  @override
  String get appPreview_updated => 'Updated';

  @override
  String get appPreview_released => 'Released';

  @override
  String get appPreview_size => 'Size';

  @override
  String get appPreview_minimumOs => 'Requires';

  @override
  String get appPreview_price => 'Price';

  @override
  String get appPreview_free => 'Free';

  @override
  String get appPreview_openInStore => 'Open in Store';

  @override
  String get appPreview_addToMyApps => 'Add to My Apps';

  @override
  String get appPreview_added => 'Added';

  @override
  String get appPreview_showMore => 'Show more';

  @override
  String get appPreview_showLess => 'Show less';

  @override
  String get appPreview_keywordsPlaceholder =>
      'Add this app to your tracked apps to enable keyword tracking';

  @override
  String get notifications_title => 'Notifications';

  @override
  String get notifications_markAllRead => 'Mark all read';

  @override
  String get notifications_empty => 'No notifications yet';

  @override
  String get alerts_title => 'Alert Rules';

  @override
  String get alerts_templatesTitle => 'Quick Templates';

  @override
  String get alerts_templatesSubtitle => 'Activate common alerts with one tap';

  @override
  String get alerts_myRulesTitle => 'My Rules';

  @override
  String get alerts_createRule => 'Create rule';

  @override
  String get alerts_editRule => 'Edit rule';

  @override
  String get alerts_noRulesYet => 'No rules yet';

  @override
  String get alerts_deleteConfirm => 'Delete rule?';

  @override
  String get settings_notifications => 'NOTIFICATIONS';

  @override
  String get settings_manageAlerts => 'Manage Alert Rules';

  @override
  String get settings_manageAlertsDesc => 'Configure what alerts you receive';

  @override
  String get settings_storeConnections => 'Store Connections';

  @override
  String get settings_storeConnectionsDesc =>
      'Connect your App Store and Google Play accounts';

  @override
  String get storeConnections_title => 'Store Connections';

  @override
  String get storeConnections_description =>
      'Connect your App Store and Google Play accounts to enable advanced features like sales data and app analytics.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Connect your Apple Developer account';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Connect your Google Play account';

  @override
  String get storeConnections_connect => 'Connect';

  @override
  String get storeConnections_disconnect => 'Disconnect';

  @override
  String get storeConnections_connected => 'Connected';

  @override
  String get storeConnections_disconnectConfirm => 'Disconnect?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'Are you sure you want to disconnect this $platform account?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Disconnected successfully';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Last synced: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return 'Connected on $date';
  }

  @override
  String get reviewsInbox_title => 'Reviews Inbox';

  @override
  String get reviewsInbox_filterUnanswered => 'Unanswered';

  @override
  String get reviewsInbox_filterNegative => 'Negative';

  @override
  String get reviewsInbox_noReviews => 'No reviews found';

  @override
  String get reviewsInbox_noReviewsDesc => 'Try adjusting your filters';

  @override
  String get reviewsInbox_reply => 'Reply';

  @override
  String get reviewsInbox_responded => 'Response';

  @override
  String reviewsInbox_respondedAt(String date) {
    return 'Responded $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Reply to Review';

  @override
  String get reviewsInbox_generateAi => 'Generate AI suggestion';

  @override
  String get reviewsInbox_generating => 'Generating...';

  @override
  String get reviewsInbox_sendReply => 'Send Reply';

  @override
  String get reviewsInbox_sending => 'Sending...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Write your response...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 characters';
  }

  @override
  String get reviewsInbox_replySent => 'Reply sent successfully';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Failed to send reply: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Failed to generate suggestion: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count stars';
  }

  @override
  String get reviewsInbox_totalReviews => 'Total Reviews';

  @override
  String get reviewsInbox_unanswered => 'Unanswered';

  @override
  String get reviewsInbox_positive => 'Positive';

  @override
  String get reviewsInbox_avgRating => 'Avg Rating';

  @override
  String get reviewsInbox_sentimentOverview => 'Sentiment Overview';

  @override
  String get reviewsInbox_aiSuggestions => 'AI Suggested Replies';

  @override
  String get reviewsInbox_regenerate => 'Regenerate';

  @override
  String get reviewsInbox_toneProfessional => 'Professional';

  @override
  String get reviewsInbox_toneEmpathetic => 'Empathetic';

  @override
  String get reviewsInbox_toneBrief => 'Brief';

  @override
  String get reviewsInbox_selectTone => 'Select tone:';

  @override
  String get reviewsInbox_detectedIssues => 'Issues detected:';

  @override
  String get reviewsInbox_aiPrompt =>
      'Click \'Generate AI suggestion\' to get reply suggestions in 3 different tones';

  @override
  String get analytics_title => 'Analytics';

  @override
  String get analytics_downloads => 'Downloads';

  @override
  String get analytics_revenue => 'Revenue';

  @override
  String get analytics_proceeds => 'Proceeds';

  @override
  String get analytics_subscribers => 'Subscribers';

  @override
  String get analytics_downloadsOverTime => 'Downloads Over Time';

  @override
  String get analytics_revenueOverTime => 'Revenue Over Time';

  @override
  String get analytics_byCountry => 'By Country';

  @override
  String get analytics_noData => 'No data available';

  @override
  String get analytics_noDataTitle => 'No Analytics Data';

  @override
  String get analytics_noDataDescription =>
      'Connect your App Store Connect or Google Play account to see real sales and download data.';

  @override
  String analytics_dataDelay(String date) {
    return 'Data as of $date. Apple data has a 24-48h delay.';
  }

  @override
  String get analytics_export => 'Export CSV';

  @override
  String get funnel_title => 'Conversion Funnel';

  @override
  String get funnel_impressions => 'Impressions';

  @override
  String get funnel_pageViews => 'Page Views';

  @override
  String get funnel_downloads => 'Downloads';

  @override
  String get funnel_overallCvr => 'Overall CVR';

  @override
  String get funnel_categoryAvg => 'Category avg';

  @override
  String get funnel_vsCategory => 'vs category';

  @override
  String get funnel_bySource => 'By Source';

  @override
  String get funnel_noData => 'No funnel data available';

  @override
  String get funnel_noDataHint =>
      'Funnel data will be synced automatically from App Store Connect or Google Play Console.';

  @override
  String get funnel_insight => 'INSIGHT';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return '$bestSource traffic converts ${ratio}x better than $worstSource. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'Focus on keyword optimization to increase Search impressions.';

  @override
  String get funnel_insightRecommendBrowse =>
      'Improve your app\'s visibility in Browse by optimizing categories and featured placement.';

  @override
  String get funnel_insightRecommendReferral =>
      'Leverage referral programs and partnerships to drive more traffic.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      'Consider cross-promotion strategies with complementary apps.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'Optimize your website and landing pages for app downloads.';

  @override
  String get funnel_insightRecommendDefault =>
      'Analyze what makes this source perform well and replicate it.';

  @override
  String get funnel_trendTitle => 'Conversion Rate Trend';

  @override
  String get funnel_connectStore => 'Connect Store';

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
  String get chatActionConfirm => 'Confirm';

  @override
  String get chatActionCancel => 'Cancel';

  @override
  String get chatActionExecuting => 'Executing...';

  @override
  String get chatActionExecuted => 'Done';

  @override
  String get chatActionFailed => 'Failed';

  @override
  String get chatActionCancelled => 'Cancelled';

  @override
  String get chatActionDownload => 'Download';

  @override
  String get chatActionReversible => 'This action can be undone';

  @override
  String get chatActionAddKeywords => 'Add Keywords to Tracking';

  @override
  String get chatActionRemoveKeywords => 'Remove Keywords';

  @override
  String get chatActionCreateAlert => 'Create Alert Rule';

  @override
  String get chatActionAddCompetitor => 'Add Competitor';

  @override
  String get chatActionExportData => 'Export Data';

  @override
  String get chatActionKeywords => 'Keywords';

  @override
  String get chatActionCountry => 'Country';

  @override
  String get chatActionAlertCondition => 'Condition';

  @override
  String get chatActionNotifyVia => 'Notify via';

  @override
  String get chatActionCompetitor => 'Competitor';

  @override
  String get chatActionExportType => 'Export type';

  @override
  String get chatActionDateRange => 'Date range';

  @override
  String get chatActionKeywordsLabel => 'Keywords';

  @override
  String get chatActionAnalyticsLabel => 'Analytics';

  @override
  String get chatActionReviewsLabel => 'Reviews';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get appDetail_tabOverview => 'Overview';

  @override
  String get appDetail_tabKeywords => 'Keywords';

  @override
  String get appDetail_tabReviews => 'Reviews';

  @override
  String get appDetail_tabRatings => 'Ratings';

  @override
  String get appDetail_tabInsights => 'Insights';

  @override
  String get dateRange_title => 'Date Range';

  @override
  String get dateRange_today => 'Today';

  @override
  String get dateRange_yesterday => 'Yesterday';

  @override
  String get dateRange_last7Days => 'Last 7 Days';

  @override
  String get dateRange_last30Days => 'Last 30 Days';

  @override
  String get dateRange_thisMonth => 'This Month';

  @override
  String get dateRange_lastMonth => 'Last Month';

  @override
  String get dateRange_last90Days => 'Last 90 Days';

  @override
  String get dateRange_yearToDate => 'Year to Date';

  @override
  String get dateRange_allTime => 'All Time';

  @override
  String get dateRange_custom => 'Custom...';

  @override
  String get dateRange_compareToPrevious => 'Compare to previous period';

  @override
  String get export_keywordsTitle => 'Export Keywords';

  @override
  String get export_reviewsTitle => 'Export Reviews';

  @override
  String get export_analyticsTitle => 'Export Analytics';

  @override
  String get export_columnsToInclude => 'Columns to include:';

  @override
  String get export_button => 'Export';

  @override
  String get export_keyword => 'Keyword';

  @override
  String get export_position => 'Position';

  @override
  String get export_change => 'Change';

  @override
  String get export_popularity => 'Popularity';

  @override
  String get export_difficulty => 'Difficulty';

  @override
  String get export_tags => 'Tags';

  @override
  String get export_notes => 'Notes';

  @override
  String get export_trackedSince => 'Tracked Since';

  @override
  String get export_date => 'Date';

  @override
  String get export_rating => 'Rating';

  @override
  String get export_author => 'Author';

  @override
  String get export_title => 'Title';

  @override
  String get export_content => 'Content';

  @override
  String get export_country => 'Country';

  @override
  String get export_version => 'Version';

  @override
  String get export_sentiment => 'Sentiment';

  @override
  String get export_response => 'Our Response';

  @override
  String get export_responseDate => 'Response Date';

  @override
  String export_keywordsCount(int count) {
    return '$count keywords will be exported';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count reviews will be exported';
  }

  @override
  String export_success(String filename) {
    return 'Export saved: $filename';
  }

  @override
  String export_error(String error) {
    return 'Export failed: $error';
  }

  @override
  String get metadata_editor => 'Metadata Editor';

  @override
  String get metadata_selectLocale => 'Select a locale to edit';

  @override
  String get metadata_refreshed => 'Metadata refreshed from store';

  @override
  String get metadata_connectRequired => 'Connect to edit metadata';

  @override
  String get metadata_connectDescription =>
      'Connect your App Store Connect account to edit your app\'s metadata directly from Keyrank.';

  @override
  String get metadata_connectStore => 'Connect App Store';

  @override
  String get metadata_publishTitle => 'Publish Metadata';

  @override
  String metadata_publishConfirm(String locale) {
    return 'Publish changes to $locale? This will update your app\'s listing on the App Store.';
  }

  @override
  String get metadata_publish => 'Publish';

  @override
  String get metadata_publishSuccess => 'Metadata published successfully';

  @override
  String get metadata_saveDraft => 'Save Draft';

  @override
  String get metadata_draftSaved => 'Draft saved';

  @override
  String get metadata_discardChanges => 'Discard Changes';

  @override
  String get metadata_title => 'Title';

  @override
  String metadata_titleHint(int limit) {
    return 'App name (max $limit chars)';
  }

  @override
  String get metadata_subtitle => 'Subtitle';

  @override
  String metadata_subtitleHint(int limit) {
    return 'Brief tagline (max $limit chars)';
  }

  @override
  String get metadata_keywords => 'Keywords';

  @override
  String metadata_keywordsHint(int limit) {
    return 'Comma-separated keywords (max $limit chars)';
  }

  @override
  String get metadata_description => 'Description';

  @override
  String metadata_descriptionHint(int limit) {
    return 'Full app description (max $limit chars)';
  }

  @override
  String get metadata_promotionalText => 'Promotional Text';

  @override
  String metadata_promotionalTextHint(int limit) {
    return 'Short promotional message (max $limit chars)';
  }

  @override
  String get metadata_whatsNew => 'What\'s New';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'Release notes (max $limit chars)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => 'Has unsaved changes';

  @override
  String get metadata_noChanges => 'No changes';

  @override
  String get metadata_keywordAnalysis => 'Keyword Analysis';

  @override
  String get metadata_keywordPresent => 'Present';

  @override
  String get metadata_keywordMissing => 'Missing';

  @override
  String get metadata_inTitle => 'In Title';

  @override
  String get metadata_inSubtitle => 'In Subtitle';

  @override
  String get metadata_inKeywords => 'In Keywords';

  @override
  String get metadata_inDescription => 'In Description';

  @override
  String get metadata_history => 'Change History';

  @override
  String get metadata_noHistory => 'No changes recorded';

  @override
  String get metadata_localeComplete => 'Complete';

  @override
  String get metadata_localeIncomplete => 'Incomplete';

  @override
  String get metadata_shortDescription => 'Short Description';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return 'Brief tagline shown in search (max $limit chars)';
  }

  @override
  String get metadata_fullDescription => 'Full Description';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'Complete app description (max $limit chars)';
  }

  @override
  String get metadata_releaseNotes => 'Release Notes';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'What\'s new in this version (max $limit chars)';
  }

  @override
  String get metadata_selectAppFirst => 'Select an app to edit metadata';

  @override
  String get metadata_selectAppHint =>
      'Use the app selector in the sidebar to choose an app, or connect a store to get started.';

  @override
  String get metadata_noStoreConnection => 'Store connection required';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return 'Connect your $storeName account to fetch and edit your app\'s metadata.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return 'Connect $storeName';
  }

  @override
  String get metadataLocalization => 'Localizations';

  @override
  String get metadataLive => 'Live';

  @override
  String get metadataDraft => 'Draft';

  @override
  String get metadataEmpty => 'Empty';

  @override
  String metadataCoverageInsight(int count) {
    return '$count locales need content. Consider localizing for your top markets.';
  }

  @override
  String get metadataFilterAll => 'All';

  @override
  String get metadataFilterLive => 'Live';

  @override
  String get metadataFilterDraft => 'Drafts';

  @override
  String get metadataFilterEmpty => 'Empty';

  @override
  String get metadataBulkActions => 'Bulk Actions';

  @override
  String get metadataCopyTo => 'Copy to selected';

  @override
  String get metadataTranslateTo => 'Translate to selected';

  @override
  String get metadataPublishSelected => 'Publish selected';

  @override
  String get metadataDeleteDrafts => 'Delete drafts';

  @override
  String get metadataSelectSource => 'Select source locale';

  @override
  String get metadataSelectTarget => 'Select target locales';

  @override
  String metadataCopySuccess(int count) {
    return 'Content copied to $count locales';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return 'Translated to $count locales';
  }

  @override
  String get metadataTranslating => 'Translating...';

  @override
  String get metadataNoSelection => 'Select locales first';

  @override
  String get metadataSelectAll => 'Select all';

  @override
  String get metadataDeselectAll => 'Deselect all';

  @override
  String metadataSelected(int count) {
    return '$count selected';
  }

  @override
  String get metadataTableView => 'Table view';

  @override
  String get metadataListView => 'List view';

  @override
  String get metadataStatus => 'Status';

  @override
  String get metadataCompletion => 'Completion';
}
