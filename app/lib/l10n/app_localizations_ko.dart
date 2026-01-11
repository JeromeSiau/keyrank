// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTagline => 'App Store 순위를 추적하세요';

  @override
  String get auth_welcomeBack => '다시 오신 것을 환영합니다';

  @override
  String get auth_signInSubtitle => '계정에 로그인하세요';

  @override
  String get auth_createAccount => '계정 만들기';

  @override
  String get auth_createAccountSubtitle => '순위 추적을 시작하세요';

  @override
  String get auth_emailLabel => '이메일';

  @override
  String get auth_passwordLabel => '비밀번호';

  @override
  String get auth_nameLabel => '이름';

  @override
  String get auth_confirmPasswordLabel => '비밀번호 확인';

  @override
  String get auth_signInButton => '로그인';

  @override
  String get auth_signUpButton => '계정 만들기';

  @override
  String get auth_noAccount => '계정이 없으신가요?';

  @override
  String get auth_hasAccount => '이미 계정이 있으신가요?';

  @override
  String get auth_signUpLink => '가입하기';

  @override
  String get auth_signInLink => '로그인';

  @override
  String get auth_emailRequired => '이메일을 입력해 주세요';

  @override
  String get auth_emailInvalid => '유효하지 않은 이메일';

  @override
  String get auth_passwordRequired => '비밀번호를 입력해 주세요';

  @override
  String get auth_enterPassword => '비밀번호를 입력해 주세요';

  @override
  String get auth_nameRequired => '이름을 입력해 주세요';

  @override
  String get auth_passwordMinLength => '비밀번호는 최소 8자 이상이어야 합니다';

  @override
  String get auth_passwordsNoMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get auth_errorOccurred => '오류가 발생했습니다';

  @override
  String get common_retry => '다시 시도';

  @override
  String common_error(String message) {
    return '오류: $message';
  }

  @override
  String get common_loading => '로딩 중...';

  @override
  String get common_add => '추가';

  @override
  String get common_filter => '필터';

  @override
  String get common_sort => '정렬';

  @override
  String get common_refresh => '새로고침';

  @override
  String get common_settings => '설정';

  @override
  String get common_search => '검색...';

  @override
  String get common_noResults => '결과 없음';

  @override
  String get dashboard_title => '대시보드';

  @override
  String get dashboard_addApp => '앱 추가';

  @override
  String get dashboard_appsTracked => '추적 중인 앱';

  @override
  String get dashboard_keywords => '키워드';

  @override
  String get dashboard_avgPosition => '평균 순위';

  @override
  String get dashboard_top10 => '상위 10';

  @override
  String get dashboard_trackedApps => '추적 중인 앱';

  @override
  String get dashboard_quickActions => '빠른 작업';

  @override
  String get dashboard_addNewApp => '새 앱 추가';

  @override
  String get dashboard_searchKeywords => '키워드 검색';

  @override
  String get dashboard_viewAllApps => '모든 앱 보기';

  @override
  String get dashboard_noAppsYet => '아직 추적 중인 앱이 없습니다';

  @override
  String get dashboard_addAppToStart => '앱을 추가하여 키워드 추적을 시작하세요';

  @override
  String get dashboard_noAppsMatchFilter => '필터와 일치하는 앱이 없습니다';

  @override
  String get dashboard_changeFilterCriteria => '필터 조건을 변경해 보세요';

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
  String get apps_title => '내 앱';

  @override
  String apps_appCount(int count) {
    return '$count개의 앱';
  }

  @override
  String get apps_tableApp => '앱';

  @override
  String get apps_tableDeveloper => '개발자';

  @override
  String get apps_tableKeywords => '키워드';

  @override
  String get apps_tablePlatform => '플랫폼';

  @override
  String get apps_tableRating => '평점';

  @override
  String get apps_tableBestRank => '최고 순위';

  @override
  String get apps_noAppsYet => '아직 추적 중인 앱이 없습니다';

  @override
  String get apps_addAppToStart => '앱을 추가하여 순위 추적을 시작하세요';

  @override
  String get addApp_title => '앱 추가';

  @override
  String get addApp_searchAppStore => 'App Store 검색...';

  @override
  String get addApp_searchPlayStore => 'Play Store 검색...';

  @override
  String get addApp_searchForApp => '앱 검색';

  @override
  String get addApp_enterAtLeast2Chars => '2자 이상 입력하세요';

  @override
  String get addApp_noResults => '결과를 찾을 수 없습니다';

  @override
  String addApp_addedSuccess(String name) {
    return '$name 추가 완료';
  }

  @override
  String get settings_title => '설정';

  @override
  String get settings_language => '언어';

  @override
  String get settings_appearance => '외관';

  @override
  String get settings_theme => '테마';

  @override
  String get settings_themeSystem => '시스템';

  @override
  String get settings_themeDark => '다크';

  @override
  String get settings_themeLight => '라이트';

  @override
  String get settings_account => '계정';

  @override
  String get settings_memberSince => '가입일';

  @override
  String get settings_logout => '로그아웃';

  @override
  String get settings_languageSystem => '시스템';

  @override
  String get filter_all => '전체';

  @override
  String get filter_allApps => '모든 앱';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'iOS만';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Android만';

  @override
  String get filter_favorites => '즐겨찾기';

  @override
  String get sort_recent => '최근';

  @override
  String get sort_recentlyAdded => '최근 추가됨';

  @override
  String get sort_nameAZ => '이름 A-Z';

  @override
  String get sort_nameZA => '이름 Z-A';

  @override
  String get sort_keywords => '키워드';

  @override
  String get sort_mostKeywords => '키워드 많은 순';

  @override
  String get sort_bestRank => '최고 순위';

  @override
  String get userMenu_logout => '로그아웃';

  @override
  String get insights_compareTitle => '인사이트 비교';

  @override
  String get insights_analyzingReviews => '리뷰 분석 중...';

  @override
  String get insights_noInsightsAvailable => '이용 가능한 인사이트가 없습니다';

  @override
  String get insights_strengths => '강점';

  @override
  String get insights_weaknesses => '약점';

  @override
  String get insights_scores => '점수';

  @override
  String get insights_opportunities => '기회';

  @override
  String get insights_categoryUx => 'UX';

  @override
  String get insights_categoryPerf => '성능';

  @override
  String get insights_categoryFeatures => '기능';

  @override
  String get insights_categoryPricing => '가격';

  @override
  String get insights_categorySupport => '지원';

  @override
  String get insights_categoryOnboard => '온보딩';

  @override
  String get insights_categoryUxFull => 'UX / 인터페이스';

  @override
  String get insights_categoryPerformance => '성능';

  @override
  String get insights_categoryOnboarding => '온보딩';

  @override
  String get insights_reviewInsights => '리뷰 인사이트';

  @override
  String get insights_generateFirst => '먼저 인사이트를 생성하세요';

  @override
  String get insights_compareWithOther => '다른 앱과 비교';

  @override
  String get insights_compare => '비교';

  @override
  String get insights_generateAnalysis => '분석 생성';

  @override
  String get insights_period => '기간:';

  @override
  String get insights_3months => '3개월';

  @override
  String get insights_6months => '6개월';

  @override
  String get insights_12months => '12개월';

  @override
  String get insights_analyze => '분석';

  @override
  String insights_reviewsCount(int count) {
    return '$count개 리뷰';
  }

  @override
  String insights_analyzedAgo(String time) {
    return '$time 전 분석됨';
  }

  @override
  String get insights_yourNotes => '내 메모';

  @override
  String get insights_save => '저장';

  @override
  String get insights_clickToAddNotes => '클릭하여 메모 추가...';

  @override
  String get insights_noteSaved => '메모가 저장되었습니다';

  @override
  String get insights_noteHint => '이 인사이트 분석에 대한 메모를 추가하세요...';

  @override
  String get insights_categoryScores => '카테고리 점수';

  @override
  String get insights_emergentThemes => '주요 테마';

  @override
  String get insights_exampleQuotes => '예시 인용:';

  @override
  String get insights_selectCountryFirst => '최소 한 개의 국가를 선택하세요';

  @override
  String compare_selectAppsToCompare(String appName) {
    return '$appName과(와) 비교할 앱을 최대 3개까지 선택하세요';
  }

  @override
  String get compare_searchApps => '앱 검색...';

  @override
  String get compare_noOtherApps => '비교할 다른 앱이 없습니다';

  @override
  String get compare_noMatchingApps => '일치하는 앱이 없습니다';

  @override
  String compare_appsSelected(int count) {
    return '3개 중 $count개 앱 선택됨';
  }

  @override
  String get compare_cancel => '취소';

  @override
  String compare_button(int count) {
    return '$count개 앱 비교';
  }

  @override
  String get appDetail_deleteAppTitle => '앱을 삭제하시겠습니까?';

  @override
  String get appDetail_deleteAppConfirm => '이 작업은 취소할 수 없습니다.';

  @override
  String get appDetail_cancel => '취소';

  @override
  String get appDetail_delete => '삭제';

  @override
  String get appDetail_exporting => '순위 내보내는 중...';

  @override
  String appDetail_savedFile(String filename) {
    return '저장됨: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Finder에서 보기';

  @override
  String appDetail_exportFailed(String error) {
    return '내보내기 실패: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return '$imported개 키워드 가져옴 ($skipped개 건너뜀)';
  }

  @override
  String get appDetail_favorite => '즐겨찾기';

  @override
  String get appDetail_ratings => '평점';

  @override
  String get appDetail_insights => '인사이트';

  @override
  String get appDetail_import => '가져오기';

  @override
  String get appDetail_export => '내보내기';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count개 리뷰';
  }

  @override
  String get appDetail_keywords => '키워드';

  @override
  String get appDetail_addKeyword => '키워드 추가';

  @override
  String get appDetail_keywordHint => '예: 피트니스 트래커';

  @override
  String get appDetail_trackedKeywords => '추적 중인 키워드';

  @override
  String appDetail_selectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get appDetail_allKeywords => '모든 키워드';

  @override
  String get appDetail_hasTags => '태그 있음';

  @override
  String get appDetail_hasNotes => '메모 있음';

  @override
  String get appDetail_position => '순위';

  @override
  String get appDetail_select => '선택';

  @override
  String get appDetail_suggestions => '추천';

  @override
  String get appDetail_deleteKeywordsTitle => '키워드 삭제';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return '$count개의 키워드를 삭제하시겠습니까?';
  }

  @override
  String get appDetail_tag => '태그';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return '키워드 \"$keyword\" 추가됨 ($flag)';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return '$count개 키워드에 태그 추가됨';
  }

  @override
  String get appDetail_keywordsAddedSuccess => '키워드가 성공적으로 추가되었습니다';

  @override
  String get appDetail_noTagsAvailable => '사용 가능한 태그가 없습니다. 먼저 태그를 만드세요.';

  @override
  String get appDetail_tagged => '태그됨';

  @override
  String get appDetail_withNotes => '메모 있음';

  @override
  String get appDetail_nameAZ => '이름 A-Z';

  @override
  String get appDetail_nameZA => '이름 Z-A';

  @override
  String get appDetail_bestPosition => '최고 순위';

  @override
  String get appDetail_recentlyTracked => '최근 추적됨';

  @override
  String get keywordSuggestions_title => '키워드 추천';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$country의 $appName';
  }

  @override
  String get keywordSuggestions_refresh => '추천 새로고침';

  @override
  String get keywordSuggestions_search => '추천 검색...';

  @override
  String get keywordSuggestions_selectAll => '전체 선택';

  @override
  String get keywordSuggestions_clear => '지우기';

  @override
  String get keywordSuggestions_analyzing => '앱 메타데이터 분석 중...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds => '몇 초 정도 소요될 수 있습니다';

  @override
  String get keywordSuggestions_noSuggestions => '추천이 없습니다';

  @override
  String get keywordSuggestions_noMatchingSuggestions => '일치하는 추천이 없습니다';

  @override
  String get keywordSuggestions_headerKeyword => '키워드';

  @override
  String get keywordSuggestions_headerDifficulty => '난이도';

  @override
  String get keywordSuggestions_headerApps => '앱';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return '$position위';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count개 키워드 선택됨';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return '$count개 키워드 추가';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return '키워드 추가 오류: $error';
  }

  @override
  String get sidebar_favorites => '즐겨찾기';

  @override
  String get sidebar_tooManyFavorites => '즐겨찾기는 5개 이하로 유지하는 것을 권장합니다';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => '키워드 리서치';

  @override
  String get keywordSearch_searchPlaceholder => '키워드 검색...';

  @override
  String get keywordSearch_searchTitle => '키워드 검색';

  @override
  String get keywordSearch_searchSubtitle => '모든 키워드에 대해 순위를 차지하고 있는 앱을 확인하세요';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count개 앱 순위';
  }

  @override
  String get keywordSearch_popularity => '인기도';

  @override
  String keywordSearch_results(int count) {
    return '$count개 결과';
  }

  @override
  String get keywordSearch_headerRank => '순위';

  @override
  String get keywordSearch_headerApp => '앱';

  @override
  String get keywordSearch_headerRating => '평점';

  @override
  String get keywordSearch_headerTrack => '추적';

  @override
  String get keywordSearch_trackApp => '이 앱 추적하기';

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
    return '$appName 리뷰';
  }

  @override
  String get reviews_loading => '리뷰 로딩 중...';

  @override
  String get reviews_noReviews => '리뷰 없음';

  @override
  String reviews_noReviewsFor(String countryName) {
    return '$countryName에 대한 리뷰를 찾을 수 없습니다';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'App Store에서 가장 최근 $count개의 리뷰를 표시합니다.';
  }

  @override
  String get reviews_today => '오늘';

  @override
  String get reviews_yesterday => '어제';

  @override
  String reviews_daysAgo(int count) {
    return '$count일 전';
  }

  @override
  String reviews_weeksAgo(int count) {
    return '$count주 전';
  }

  @override
  String reviews_monthsAgo(int count) {
    return '$count개월 전';
  }

  @override
  String get ratings_byCountry => '국가별 평점';

  @override
  String get ratings_noRatingsAvailable => '이용 가능한 평점이 없습니다';

  @override
  String get ratings_noRatingsYet => '이 앱은 아직 평점이 없습니다';

  @override
  String get ratings_totalRatings => '총 평점 수';

  @override
  String get ratings_averageRating => '평균 평점';

  @override
  String ratings_countriesCount(int count) {
    return '$count개 국가';
  }

  @override
  String ratings_updated(String date) {
    return '업데이트: $date';
  }

  @override
  String get ratings_headerCountry => '국가';

  @override
  String get ratings_headerRatings => '평점 수';

  @override
  String get ratings_headerAverage => '평균';

  @override
  String time_minutesAgo(int count) {
    return '$count분 전';
  }

  @override
  String time_hoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String time_daysAgo(int count) {
    return '$count일 전';
  }

  @override
  String get appDetail_noKeywordsTracked => '추적 중인 키워드 없음';

  @override
  String get appDetail_addKeywordHint => '위에 키워드를 추가하여 추적을 시작하세요';

  @override
  String get appDetail_noKeywordsMatchFilter => '필터와 일치하는 키워드 없음';

  @override
  String get appDetail_tryChangingFilter => '필터 조건을 변경해 보세요';

  @override
  String get appDetail_addTag => '태그 추가';

  @override
  String get appDetail_addNote => '메모 추가';

  @override
  String get appDetail_positionHistory => '순위 기록';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => '개요';

  @override
  String get nav_dashboard => '대시보드';

  @override
  String get nav_myApps => '내 앱';

  @override
  String get nav_research => '리서치';

  @override
  String get nav_keywords => '키워드';

  @override
  String get nav_discover => '탐색';

  @override
  String get nav_engagement => 'ENGAGEMENT';

  @override
  String get nav_reviewsInbox => 'Reviews Inbox';

  @override
  String get nav_notifications => '알림';

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
  String get common_save => '저장';

  @override
  String get appDetail_manageTags => '태그 관리';

  @override
  String get appDetail_newTagHint => '새 태그 이름...';

  @override
  String get appDetail_availableTags => '사용 가능한 태그';

  @override
  String get appDetail_noTagsYet => '아직 태그가 없습니다. 위에서 만드세요.';

  @override
  String get appDetail_addTagsTitle => '태그 추가';

  @override
  String get appDetail_selectTagsDescription => '선택한 키워드에 추가할 태그 선택:';

  @override
  String appDetail_addTagsCount(int count) {
    return '$count개 태그 추가';
  }

  @override
  String appDetail_importFailed(String error) {
    return '가져오기 실패: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => '키워드 가져오기';

  @override
  String get appDetail_pasteKeywordsHint => '아래에 키워드를 붙여넣기 (줄당 하나씩):';

  @override
  String get appDetail_keywordPlaceholder => '키워드 하나\n키워드 둘\n키워드 셋';

  @override
  String get appDetail_storefront => '스토어프론트:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count개 키워드';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return '$count개 키워드 가져오기';
  }

  @override
  String get appDetail_period7d => '7일';

  @override
  String get appDetail_period30d => '30일';

  @override
  String get appDetail_period90d => '90일';

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
  String get notifications_title => '알림';

  @override
  String get notifications_markAllRead => '모두 읽음으로 표시';

  @override
  String get notifications_empty => '아직 알림이 없습니다';

  @override
  String get alerts_title => '알림 규칙';

  @override
  String get alerts_templatesTitle => '빠른 템플릿';

  @override
  String get alerts_templatesSubtitle => '한 번 탭으로 일반 알림 활성화';

  @override
  String get alerts_myRulesTitle => '내 규칙';

  @override
  String get alerts_createRule => '규칙 만들기';

  @override
  String get alerts_editRule => '규칙 편집';

  @override
  String get alerts_noRulesYet => '아직 규칙이 없습니다';

  @override
  String get alerts_deleteConfirm => '규칙을 삭제하시겠습니까?';

  @override
  String get settings_notifications => '알림';

  @override
  String get settings_manageAlerts => '알림 규칙 관리';

  @override
  String get settings_manageAlertsDesc => '받을 알림 설정';

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
  String get analytics_title => '분석';

  @override
  String get analytics_downloads => '다운로드';

  @override
  String get analytics_revenue => '수익';

  @override
  String get analytics_proceeds => '수입';

  @override
  String get analytics_subscribers => '구독자';

  @override
  String get analytics_downloadsOverTime => '시간별 다운로드';

  @override
  String get analytics_revenueOverTime => '시간별 수익';

  @override
  String get analytics_byCountry => '국가별';

  @override
  String get analytics_noData => '데이터 없음';

  @override
  String get analytics_noDataTitle => '분석 데이터 없음';

  @override
  String get analytics_noDataDescription =>
      '실제 판매 및 다운로드 데이터를 보려면 App Store Connect 또는 Google Play 계정을 연결하세요.';

  @override
  String analytics_dataDelay(String date) {
    return '$date 기준 데이터. Apple 데이터는 24-48시간 지연됩니다.';
  }

  @override
  String get analytics_export => 'CSV 내보내기';

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
  String get appDetail_tabOverview => 'Overview';

  @override
  String get appDetail_tabKeywords => 'Keywords';

  @override
  String get appDetail_tabReviews => 'Reviews';

  @override
  String get appDetail_tabRatings => 'Ratings';

  @override
  String get appDetail_tabInsights => 'Insights';
}
