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
  String get auth_emailInvalid => '유효하지 않은 이메일입니다';

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
  String get dashboard_reviews => '리뷰';

  @override
  String get dashboard_avgRating => '평균 평점';

  @override
  String get dashboard_topPerformingApps => '최고 성과 앱';

  @override
  String get dashboard_topCountries => '상위 국가';

  @override
  String get dashboard_sentimentOverview => '감성 분석 개요';

  @override
  String get dashboard_overallSentiment => '전체 감성';

  @override
  String get dashboard_positive => '긍정';

  @override
  String get dashboard_positiveReviews => '긍정';

  @override
  String get dashboard_negativeReviews => '부정';

  @override
  String get dashboard_viewReviews => '리뷰 보기';

  @override
  String get dashboard_tableApp => '앱';

  @override
  String get dashboard_tableKeywords => '키워드';

  @override
  String get dashboard_tableAvgRank => '평균 순위';

  @override
  String get dashboard_tableTrend => '추세';

  @override
  String get dashboard_connectYourStores => '스토어 연결';

  @override
  String get dashboard_connectStoresDescription =>
      'App Store Connect 또는 Google Play를 연결하여 앱을 가져오고 리뷰에 응답하세요.';

  @override
  String get dashboard_connect => '연결';

  @override
  String get apps_title => '내 앱';

  @override
  String apps_appCount(int count) {
    return '$count개 앱';
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
  String get insights_noteHint => '이 분석에 대한 메모를 추가하세요...';

  @override
  String get insights_categoryScores => '카테고리 점수';

  @override
  String get insights_emergentThemes => '주요 테마';

  @override
  String get insights_exampleQuotes => '예시 인용:';

  @override
  String get insights_selectCountryFirst => '최소 한 개의 국가를 선택하세요';

  @override
  String get insights_title => '인사이트';

  @override
  String insights_titleWithApp(String appName) {
    return '인사이트 - $appName';
  }

  @override
  String get insights_allApps => '인사이트 (모든 앱)';

  @override
  String get insights_noInsightsYet => '아직 인사이트가 없습니다';

  @override
  String get insights_selectAppToGenerate => '앱을 선택하여 리뷰에서 인사이트를 생성하세요';

  @override
  String insights_appsWithInsights(int count) {
    return '인사이트가 있는 앱 $count개';
  }

  @override
  String get insights_errorLoading => '인사이트 로딩 오류';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '$count개 리뷰 분석됨';
  }

  @override
  String get insights_avgScore => '평균 점수';

  @override
  String insights_updatedOn(String date) {
    return '$date에 업데이트됨';
  }

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
  String get keywordSuggestions_categoryAll => '전체';

  @override
  String get keywordSuggestions_categoryHighOpportunity => '기회';

  @override
  String get keywordSuggestions_categoryCompetitor => '경쟁사 키워드';

  @override
  String get keywordSuggestions_categoryLongTail => '롱테일';

  @override
  String get keywordSuggestions_categoryTrending => '트렌드';

  @override
  String get keywordSuggestions_categoryRelated => '관련';

  @override
  String get keywordSuggestions_generating => '추천 생성 중...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      '몇 분 정도 소요될 수 있습니다. 나중에 다시 확인하세요.';

  @override
  String get keywordSuggestions_checkAgain => '다시 확인';

  @override
  String get sidebar_favorites => '즐겨찾기';

  @override
  String get sidebar_tooManyFavorites => '즐겨찾기는 5개 이하로 유지하는 것을 권장합니다';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => '키워드 검색';

  @override
  String get keywordSearch_searchPlaceholder => '키워드 검색...';

  @override
  String get keywordSearch_searchTitle => '키워드 검색';

  @override
  String get keywordSearch_searchSubtitle => '특정 키워드에 대해 순위를 차지하고 있는 앱을 확인하세요';

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
  String get discover_title => '탐색';

  @override
  String get discover_tabKeywords => '키워드';

  @override
  String get discover_tabCategories => '카테고리';

  @override
  String get discover_selectCategory => '카테고리 선택';

  @override
  String get discover_topFree => '무료';

  @override
  String get discover_topPaid => '유료';

  @override
  String get discover_topGrossing => '수익';

  @override
  String get discover_noResults => '결과 없음';

  @override
  String get discover_loadingTopApps => '인기 앱 로딩 중...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return '$category의 $collection 상위 앱';
  }

  @override
  String discover_appsCount(int count) {
    return '$count개 앱';
  }

  @override
  String get discover_allCategories => '모든 카테고리';

  @override
  String get category_games => '게임';

  @override
  String get category_business => '비즈니스';

  @override
  String get category_education => '교육';

  @override
  String get category_entertainment => '엔터테인먼트';

  @override
  String get category_finance => '금융';

  @override
  String get category_food_drink => '음식 및 음료';

  @override
  String get category_health_fitness => '건강 및 피트니스';

  @override
  String get category_lifestyle => '라이프스타일';

  @override
  String get category_medical => '의료';

  @override
  String get category_music => '음악';

  @override
  String get category_navigation => '내비게이션';

  @override
  String get category_news => '뉴스';

  @override
  String get category_photo_video => '사진 및 비디오';

  @override
  String get category_productivity => '생산성';

  @override
  String get category_reference => '참고';

  @override
  String get category_shopping => '쇼핑';

  @override
  String get category_social => '소셜 네트워킹';

  @override
  String get category_sports => '스포츠';

  @override
  String get category_travel => '여행';

  @override
  String get category_utilities => '유틸리티';

  @override
  String get category_weather => '날씨';

  @override
  String get category_books => '도서';

  @override
  String get category_developer_tools => '개발자 도구';

  @override
  String get category_graphics_design => '그래픽 및 디자인';

  @override
  String get category_magazines => '잡지 및 신문';

  @override
  String get category_stickers => '스티커';

  @override
  String get category_catalogs => '카탈로그';

  @override
  String get category_art_design => '아트 및 디자인';

  @override
  String get category_auto_vehicles => '자동차';

  @override
  String get category_beauty => '뷰티';

  @override
  String get category_comics => '만화';

  @override
  String get category_communication => '커뮤니케이션';

  @override
  String get category_dating => '데이팅';

  @override
  String get category_events => '이벤트';

  @override
  String get category_house_home => '주거';

  @override
  String get category_libraries => '라이브러리';

  @override
  String get category_maps_navigation => '지도 및 내비게이션';

  @override
  String get category_music_audio => '음악 및 오디오';

  @override
  String get category_news_magazines => '뉴스 및 잡지';

  @override
  String get category_parenting => '육아';

  @override
  String get category_personalization => '맞춤 설정';

  @override
  String get category_photography => '사진';

  @override
  String get category_tools => '도구';

  @override
  String get category_video_players => '동영상 플레이어';

  @override
  String get category_all_apps => '모든 앱';

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
  String get appDetail_store => '스토어';

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
  String get nav_engagement => '참여';

  @override
  String get nav_reviewsInbox => '리뷰 받은편지함';

  @override
  String get nav_notifications => '알림';

  @override
  String get nav_optimization => '최적화';

  @override
  String get nav_keywordInspector => '키워드 검사기';

  @override
  String get nav_ratingsAnalysis => '평점 분석';

  @override
  String get nav_intelligence => '인텔리전스';

  @override
  String get nav_topCharts => '인기 차트';

  @override
  String get nav_competitors => '경쟁사';

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
  String get appDetail_selectTagsDescription => '선택한 키워드에 추가할 태그를 선택하세요:';

  @override
  String appDetail_addTagsCount(int count) {
    return '$count개 태그 추가';
  }

  @override
  String get appDetail_currentTags => '현재 태그';

  @override
  String get appDetail_noTagsOnKeyword => '이 키워드에 태그가 없습니다';

  @override
  String get appDetail_addExistingTag => '기존 태그 추가';

  @override
  String get appDetail_allTagsUsed => '모든 태그가 이미 사용 중입니다';

  @override
  String get appDetail_createNewTag => '새 태그 만들기';

  @override
  String get appDetail_tagNameHint => '태그 이름...';

  @override
  String get appDetail_note => '메모';

  @override
  String get appDetail_noteHint => '이 키워드에 대한 메모 추가...';

  @override
  String get appDetail_saveNote => '메모 저장';

  @override
  String get appDetail_done => '완료';

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
  String get keywords_difficultyFilter => '난이도:';

  @override
  String get keywords_difficultyAll => '전체';

  @override
  String get keywords_difficultyEasy => '쉬움 < 40';

  @override
  String get keywords_difficultyMedium => '보통 40-70';

  @override
  String get keywords_difficultyHard => '어려움 > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => '앱 상세 정보';

  @override
  String get appPreview_notFound => '앱을 찾을 수 없습니다';

  @override
  String get appPreview_screenshots => '스크린샷';

  @override
  String get appPreview_description => '설명';

  @override
  String get appPreview_details => '상세 정보';

  @override
  String get appPreview_version => '버전';

  @override
  String get appPreview_updated => '업데이트';

  @override
  String get appPreview_released => '출시일';

  @override
  String get appPreview_size => '크기';

  @override
  String get appPreview_minimumOs => '요구 사항';

  @override
  String get appPreview_price => '가격';

  @override
  String get appPreview_free => '무료';

  @override
  String get appPreview_openInStore => '스토어에서 열기';

  @override
  String get appPreview_addToMyApps => '내 앱에 추가';

  @override
  String get appPreview_added => '추가됨';

  @override
  String get appPreview_showMore => '더 보기';

  @override
  String get appPreview_showLess => '접기';

  @override
  String get appPreview_keywordsPlaceholder =>
      '키워드 추적을 활성화하려면 이 앱을 추적 중인 앱에 추가하세요';

  @override
  String get notifications_title => '알림';

  @override
  String get notifications_markAllRead => '모두 읽음 표시';

  @override
  String get notifications_empty => '아직 알림이 없습니다';

  @override
  String get alerts_title => '알림 규칙';

  @override
  String get alerts_templatesTitle => '빠른 템플릿';

  @override
  String get alerts_templatesSubtitle => '한 번의 클릭으로 일반 알림 활성화';

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
  String get alerts_createCustomRule => '사용자 정의 규칙 만들기';

  @override
  String alerts_ruleActivated(String name) {
    return '$name 활성화됨!';
  }

  @override
  String alerts_deleteMessage(String name) {
    return '\"$name\"이(가) 삭제됩니다.';
  }

  @override
  String get alerts_noRulesDescription => '템플릿을 활성화하거나 직접 만드세요!';

  @override
  String get alerts_create => '만들기';

  @override
  String get settings_notifications => '알림';

  @override
  String get settings_manageAlerts => '알림 규칙 관리';

  @override
  String get settings_manageAlertsDesc => '받을 알림을 설정합니다';

  @override
  String get settings_storeConnections => '스토어 연결';

  @override
  String get settings_storeConnectionsDesc =>
      'App Store 및 Google Play 계정을 연결합니다';

  @override
  String get settings_alertDelivery => '알림 전달';

  @override
  String get settings_team => '팀';

  @override
  String get settings_teamManagement => '팀 관리';

  @override
  String get settings_teamManagementDesc =>
      'Invite members, manage roles & permissions';

  @override
  String get settings_integrations => '연동';

  @override
  String get settings_manageIntegrations => 'Manage Integrations';

  @override
  String get settings_manageIntegrationsDesc =>
      'Connect App Store Connect & Google Play Console';

  @override
  String get settings_billing => 'BILLING';

  @override
  String get settings_plansBilling => 'Plans & Billing';

  @override
  String get settings_plansBillingDesc =>
      'Manage your subscription and payment';

  @override
  String get settings_rememberApp => 'Remember selected app';

  @override
  String get settings_rememberAppDesc =>
      'Restore app selection when you open the app';

  @override
  String get storeConnections_title => '스토어 연결';

  @override
  String get storeConnections_description =>
      'App Store 및 Google Play 계정을 연결하여 판매 데이터 및 앱 분석과 같은 고급 기능을 활성화하세요.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc => 'Apple 개발자 계정 연결';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc => 'Google Play 계정 연결';

  @override
  String get storeConnections_connect => '연결';

  @override
  String get storeConnections_disconnect => '연결 해제';

  @override
  String get storeConnections_connected => '연결됨';

  @override
  String get storeConnections_disconnectConfirm => '연결을 해제하시겠습니까?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return '이 $platform 계정의 연결을 해제하시겠습니까?';
  }

  @override
  String get storeConnections_disconnectSuccess => '연결이 해제되었습니다';

  @override
  String storeConnections_lastSynced(String date) {
    return '마지막 동기화: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return '$date에 연결됨';
  }

  @override
  String get storeConnections_syncApps => '앱 동기화';

  @override
  String get storeConnections_syncing => '동기화 중...';

  @override
  String get storeConnections_syncDescription =>
      '동기화하면 이 계정의 앱이 소유로 표시되어 리뷰에 답변할 수 있습니다.';

  @override
  String storeConnections_syncedApps(int count) {
    return '$count개 앱을 소유로 동기화함';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return '동기화 실패: $error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return '연결 로드 오류: $error';
  }

  @override
  String get reviewsInbox_title => '리뷰 받은편지함';

  @override
  String get reviewsInbox_filterUnanswered => '미답변';

  @override
  String get reviewsInbox_filterNegative => '부정';

  @override
  String get reviewsInbox_noReviews => '리뷰를 찾을 수 없습니다';

  @override
  String get reviewsInbox_noReviewsDesc => '필터를 조정해 보세요';

  @override
  String get reviewsInbox_reply => '답변';

  @override
  String get reviewsInbox_responded => '답변됨';

  @override
  String reviewsInbox_respondedAt(String date) {
    return '$date에 답변됨';
  }

  @override
  String get reviewsInbox_replyModalTitle => '리뷰에 답변';

  @override
  String get reviewsInbox_generateAi => 'AI 제안 생성';

  @override
  String get reviewsInbox_generating => '생성 중...';

  @override
  String get reviewsInbox_sendReply => '답변 보내기';

  @override
  String get reviewsInbox_sending => '전송 중...';

  @override
  String get reviewsInbox_replyPlaceholder => '답변을 작성하세요...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970자';
  }

  @override
  String get reviewsInbox_replySent => '답변이 전송되었습니다';

  @override
  String reviewsInbox_replyError(String error) {
    return '답변 전송 실패: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return '제안 생성 실패: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count점';
  }

  @override
  String get reviewsInbox_totalReviews => '총 리뷰';

  @override
  String get reviewsInbox_unanswered => '미답변';

  @override
  String get reviewsInbox_positive => '긍정';

  @override
  String get reviewsInbox_avgRating => '평균 평점';

  @override
  String get reviewsInbox_sentimentOverview => '감성 분석 개요';

  @override
  String get reviewsInbox_aiSuggestions => 'AI 제안';

  @override
  String get reviewsInbox_regenerate => '다시 생성';

  @override
  String get reviewsInbox_toneProfessional => '전문적';

  @override
  String get reviewsInbox_toneEmpathetic => '공감적';

  @override
  String get reviewsInbox_toneBrief => '간결함';

  @override
  String get reviewsInbox_selectTone => '톤 선택:';

  @override
  String get reviewsInbox_detectedIssues => '감지된 문제:';

  @override
  String get reviewsInbox_aiPrompt =>
      '\'AI 제안 생성\'을 클릭하여 3가지 다른 톤의 답변 제안을 받으세요';

  @override
  String get reviewIntelligence_title => '리뷰 인텔리전스';

  @override
  String get reviewIntelligence_featureRequests => '기능 요청';

  @override
  String get reviewIntelligence_bugReports => '버그 리포트';

  @override
  String get reviewIntelligence_sentimentByVersion => '버전별 감성';

  @override
  String get reviewIntelligence_openFeatures => '미결 기능';

  @override
  String get reviewIntelligence_openBugs => '미결 버그';

  @override
  String get reviewIntelligence_highPriority => '높은 우선순위';

  @override
  String get reviewIntelligence_total => '총계';

  @override
  String get reviewIntelligence_mentions => '언급';

  @override
  String get reviewIntelligence_noData => '아직 인사이트가 없습니다';

  @override
  String get reviewIntelligence_noDataHint => '리뷰 분석 후 인사이트가 표시됩니다';

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
    return '$date 기준 데이터입니다. Apple 데이터는 24-48시간 지연됩니다.';
  }

  @override
  String get analytics_export => 'CSV 내보내기';

  @override
  String get funnel_title => '전환 퍼널';

  @override
  String get funnel_impressions => '노출';

  @override
  String get funnel_pageViews => '페이지 조회';

  @override
  String get funnel_downloads => '다운로드';

  @override
  String get funnel_overallCvr => '전체 CVR';

  @override
  String get funnel_categoryAvg => '카테고리 평균';

  @override
  String get funnel_vsCategory => 'vs 카테고리';

  @override
  String get funnel_bySource => '소스별';

  @override
  String get funnel_noData => '퍼널 데이터가 없습니다';

  @override
  String get funnel_noDataHint =>
      '퍼널 데이터는 App Store Connect 또는 Google Play Console에서 자동으로 동기화됩니다.';

  @override
  String get funnel_insight => '인사이트';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return '$bestSource 트래픽이 $worstSource보다 $ratio배 더 잘 전환됩니다. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch => '검색 노출을 늘리기 위해 키워드 최적화에 집중하세요.';

  @override
  String get funnel_insightRecommendBrowse =>
      '카테고리와 추천 배치를 최적화하여 탐색 가시성을 높이세요.';

  @override
  String get funnel_insightRecommendReferral =>
      '추천 프로그램과 파트너십을 활용하여 더 많은 트래픽을 유도하세요.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      '보완적인 앱들과의 교차 프로모션 전략을 고려하세요.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      '웹사이트와 랜딩 페이지를 다운로드에 최적화하세요.';

  @override
  String get funnel_insightRecommendDefault => '이 소스의 성공 요인을 분석하고 재현하세요.';

  @override
  String get funnel_trendTitle => '전환율 추세';

  @override
  String get funnel_connectStore => '스토어 연결';

  @override
  String get nav_chat => 'AI 어시스턴트';

  @override
  String get chat_title => 'AI 어시스턴트';

  @override
  String get chat_newConversation => '새 대화';

  @override
  String get chat_loadingConversations => '대화 로딩 중...';

  @override
  String get chat_loadingMessages => '메시지 로딩 중...';

  @override
  String get chat_noConversations => '대화 없음';

  @override
  String get chat_noConversationsDesc => '새 대화를 시작하여 앱에 대한 AI 인사이트를 얻으세요';

  @override
  String get chat_startConversation => '대화 시작';

  @override
  String get chat_deleteConversation => '대화 삭제';

  @override
  String get chat_deleteConversationConfirm => '이 대화를 삭제하시겠습니까?';

  @override
  String get chat_askAnything => '무엇이든 물어보세요';

  @override
  String get chat_askAnythingDesc => '앱의 리뷰, 순위 및 분석을 이해하는 데 도움을 드릴 수 있습니다';

  @override
  String get chat_typeMessage => '질문을 입력하세요...';

  @override
  String get chat_suggestedQuestions => '추천 질문';

  @override
  String get chatActionConfirm => '확인';

  @override
  String get chatActionCancel => '취소';

  @override
  String get chatActionExecuting => '실행 중...';

  @override
  String get chatActionExecuted => '완료';

  @override
  String get chatActionFailed => '실패';

  @override
  String get chatActionCancelled => '취소됨';

  @override
  String get chatActionDownload => '다운로드';

  @override
  String get chatActionReversible => '이 작업은 취소할 수 있습니다';

  @override
  String get chatActionAddKeywords => '키워드 추가';

  @override
  String get chatActionRemoveKeywords => '키워드 삭제';

  @override
  String get chatActionCreateAlert => '알림 생성';

  @override
  String get chatActionAddCompetitor => '경쟁사 추가';

  @override
  String get chatActionExportData => '데이터 내보내기';

  @override
  String get chatActionKeywords => '키워드';

  @override
  String get chatActionCountry => '국가';

  @override
  String get chatActionAlertCondition => '조건';

  @override
  String get chatActionNotifyVia => '알림 방법';

  @override
  String get chatActionCompetitor => '경쟁사';

  @override
  String get chatActionExportType => '내보내기 유형';

  @override
  String get chatActionDateRange => '기간';

  @override
  String get chatActionKeywordsLabel => '키워드';

  @override
  String get chatActionAnalyticsLabel => '통계';

  @override
  String get chatActionReviewsLabel => '리뷰';

  @override
  String get common_cancel => '취소';

  @override
  String get common_delete => '삭제';

  @override
  String get appDetail_tabOverview => '개요';

  @override
  String get appDetail_tabKeywords => '키워드';

  @override
  String get appDetail_tabReviews => '리뷰';

  @override
  String get appDetail_tabRatings => '평점';

  @override
  String get appDetail_tabInsights => '인사이트';

  @override
  String get dateRange_title => '기간';

  @override
  String get dateRange_today => '오늘';

  @override
  String get dateRange_yesterday => '어제';

  @override
  String get dateRange_last7Days => '최근 7일';

  @override
  String get dateRange_last30Days => '최근 30일';

  @override
  String get dateRange_thisMonth => '이번 달';

  @override
  String get dateRange_lastMonth => '지난 달';

  @override
  String get dateRange_last90Days => '최근 90일';

  @override
  String get dateRange_yearToDate => '올해';

  @override
  String get dateRange_allTime => '전체';

  @override
  String get dateRange_custom => '사용자 지정...';

  @override
  String get dateRange_compareToPrevious => '이전 기간과 비교';

  @override
  String get export_keywordsTitle => '키워드 내보내기';

  @override
  String get export_reviewsTitle => '리뷰 내보내기';

  @override
  String get export_analyticsTitle => '분석 내보내기';

  @override
  String get export_columnsToInclude => '포함할 열:';

  @override
  String get export_button => '내보내기';

  @override
  String get export_keyword => '키워드';

  @override
  String get export_position => '순위';

  @override
  String get export_change => '변화';

  @override
  String get export_popularity => '인기도';

  @override
  String get export_difficulty => '난이도';

  @override
  String get export_tags => '태그';

  @override
  String get export_notes => '메모';

  @override
  String get export_trackedSince => '추적 시작일';

  @override
  String get export_date => '날짜';

  @override
  String get export_rating => '평점';

  @override
  String get export_author => '작성자';

  @override
  String get export_title => '제목';

  @override
  String get export_content => '내용';

  @override
  String get export_country => '국가';

  @override
  String get export_version => '버전';

  @override
  String get export_sentiment => '감성';

  @override
  String get export_response => '답변';

  @override
  String get export_responseDate => '답변 날짜';

  @override
  String export_keywordsCount(int count) {
    return '$count개 키워드가 내보내집니다';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count개 리뷰가 내보내집니다';
  }

  @override
  String export_success(String filename) {
    return '내보내기 저장됨: $filename';
  }

  @override
  String export_error(String error) {
    return '내보내기 실패: $error';
  }

  @override
  String get metadata_editor => '메타데이터 편집기';

  @override
  String get metadata_selectLocale => '편집할 로케일 선택';

  @override
  String get metadata_refreshed => '스토어에서 메타데이터가 새로고침되었습니다';

  @override
  String get metadata_connectRequired => '편집하려면 연결이 필요합니다';

  @override
  String get metadata_connectDescription =>
      'App Store Connect 계정을 연결하여 Keyrank에서 직접 앱 메타데이터를 편집하세요.';

  @override
  String get metadata_connectStore => 'App Store 연결';

  @override
  String get metadata_publishTitle => '메타데이터 게시';

  @override
  String metadata_publishConfirm(String locale) {
    return '$locale에 대한 변경 사항을 게시하시겠습니까? App Store의 앱 목록이 업데이트됩니다.';
  }

  @override
  String get metadata_publish => '게시';

  @override
  String get metadata_publishSuccess => '메타데이터가 성공적으로 게시되었습니다';

  @override
  String get metadata_saveDraft => '임시 저장';

  @override
  String get metadata_draftSaved => '임시 저장됨';

  @override
  String get metadata_discardChanges => '변경 사항 취소';

  @override
  String get metadata_title => '제목';

  @override
  String metadata_titleHint(int limit) {
    return '앱 이름 (최대 $limit자)';
  }

  @override
  String get metadata_subtitle => '부제목';

  @override
  String metadata_subtitleHint(int limit) {
    return '짧은 설명 (최대 $limit자)';
  }

  @override
  String get metadata_keywords => '키워드';

  @override
  String metadata_keywordsHint(int limit) {
    return '쉼표로 구분된 키워드 (최대 $limit자)';
  }

  @override
  String get metadata_description => '설명';

  @override
  String metadata_descriptionHint(int limit) {
    return '앱 전체 설명 (최대 $limit자)';
  }

  @override
  String get metadata_promotionalText => '프로모션 텍스트';

  @override
  String metadata_promotionalTextHint(int limit) {
    return '짧은 프로모션 메시지 (최대 $limit자)';
  }

  @override
  String get metadata_whatsNew => '새로운 기능';

  @override
  String metadata_whatsNewHint(int limit) {
    return '릴리스 노트 (최대 $limit자)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => '저장되지 않은 변경 사항';

  @override
  String get metadata_noChanges => '변경 사항 없음';

  @override
  String get metadata_keywordAnalysis => '키워드 분석';

  @override
  String get metadata_keywordPresent => '있음';

  @override
  String get metadata_keywordMissing => '없음';

  @override
  String get metadata_inTitle => '제목에';

  @override
  String get metadata_inSubtitle => '부제목에';

  @override
  String get metadata_inKeywords => '키워드에';

  @override
  String get metadata_inDescription => '설명에';

  @override
  String get metadata_history => '변경 기록';

  @override
  String get metadata_noHistory => '기록된 변경 사항 없음';

  @override
  String get metadata_localeComplete => '완료';

  @override
  String get metadata_localeIncomplete => '미완료';

  @override
  String get metadata_shortDescription => '짧은 설명';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return '검색에 표시되는 설명 (최대 $limit자)';
  }

  @override
  String get metadata_fullDescription => '전체 설명';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return '앱 전체 설명 (최대 $limit자)';
  }

  @override
  String get metadata_releaseNotes => '릴리스 노트';

  @override
  String metadata_releaseNotesHint(int limit) {
    return '이 버전의 새로운 기능 (최대 $limit자)';
  }

  @override
  String get metadata_selectAppFirst => '앱을 선택하세요';

  @override
  String get metadata_selectAppHint => '사이드바의 앱 선택기를 사용하거나 스토어를 연결하여 시작하세요.';

  @override
  String get metadata_noStoreConnection => '스토어 연결 필요';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return '$storeName 계정을 연결하여 앱 메타데이터를 가져오고 편집하세요.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return '$storeName 연결';
  }

  @override
  String get metadataLocalization => '로컬라이제이션';

  @override
  String get metadataLive => '게시됨';

  @override
  String get metadataDraft => '임시 저장';

  @override
  String get metadataEmpty => '비어 있음';

  @override
  String metadataCoverageInsight(int count) {
    return '$count개 로케일에 콘텐츠가 필요합니다. 주요 시장에 대한 로컬라이제이션을 고려하세요.';
  }

  @override
  String get metadataFilterAll => '전체';

  @override
  String get metadataFilterLive => '게시됨';

  @override
  String get metadataFilterDraft => '임시 저장';

  @override
  String get metadataFilterEmpty => '비어 있음';

  @override
  String get metadataBulkActions => '일괄 작업';

  @override
  String get metadataCopyTo => '선택 항목에 복사';

  @override
  String get metadataTranslateTo => '선택 항목에 번역';

  @override
  String get metadataPublishSelected => '선택 항목 게시';

  @override
  String get metadataDeleteDrafts => '임시 저장 삭제';

  @override
  String get metadataSelectSource => '소스 로케일 선택';

  @override
  String get metadataSelectTarget => '대상 로케일 선택';

  @override
  String metadataCopySuccess(int count) {
    return '$count개 로케일에 콘텐츠 복사됨';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return '$count개 로케일로 번역됨';
  }

  @override
  String get metadataTranslating => '번역 중...';

  @override
  String get metadataNoSelection => '먼저 로케일을 선택하세요';

  @override
  String get metadataSelectAll => '전체 선택';

  @override
  String get metadataDeselectAll => '전체 선택 해제';

  @override
  String metadataSelected(int count) {
    return '$count개 선택됨';
  }

  @override
  String get metadataTableView => '표 보기';

  @override
  String get metadataListView => '목록 보기';

  @override
  String get metadataStatus => '상태';

  @override
  String get metadataCompletion => '완성도';

  @override
  String get common_back => '뒤로';

  @override
  String get common_next => '다음';

  @override
  String get common_edit => '편집';

  @override
  String get metadata_aiOptimize => 'AI로 최적화';

  @override
  String get wizard_title => 'AI 최적화 마법사';

  @override
  String get wizard_step => '단계';

  @override
  String get wizard_of => '/';

  @override
  String get wizard_stepTitle => '제목';

  @override
  String get wizard_stepSubtitle => '부제목';

  @override
  String get wizard_stepKeywords => '키워드';

  @override
  String get wizard_stepDescription => '설명';

  @override
  String get wizard_stepReview => '검토 및 저장';

  @override
  String get wizard_skip => '건너뛰기';

  @override
  String get wizard_saveDrafts => '임시 저장';

  @override
  String get wizard_draftsSaved => '임시 저장이 완료되었습니다';

  @override
  String get wizard_exitTitle => '마법사를 종료하시겠습니까?';

  @override
  String get wizard_exitMessage => '저장되지 않은 변경 사항이 있습니다. 종료하시겠습니까?';

  @override
  String get wizard_exitConfirm => '종료';

  @override
  String get wizard_aiSuggestions => 'AI 제안';

  @override
  String get wizard_chooseSuggestion => 'AI가 생성한 제안을 선택하거나 직접 작성하세요';

  @override
  String get wizard_currentValue => '현재 값';

  @override
  String get wizard_noCurrentValue => '설정된 값 없음';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return '$keywordsCount개 추적 중인 키워드와 $competitorsCount개 경쟁사 기반';
  }

  @override
  String get wizard_writeOwn => '직접 작성';

  @override
  String get wizard_customPlaceholder => '사용자 정의 값을 입력하세요...';

  @override
  String get wizard_useCustom => '사용자 정의 사용';

  @override
  String get wizard_keepCurrent => '현재 값 유지';

  @override
  String get wizard_recommended => '추천';

  @override
  String get wizard_characters => '자';

  @override
  String get wizard_reviewTitle => '변경 사항 검토';

  @override
  String get wizard_reviewDescription => '임시 저장하기 전에 최적화 내용을 검토하세요';

  @override
  String get wizard_noChanges => '선택된 변경 사항 없음';

  @override
  String get wizard_noChangesHint => '돌아가서 최적화할 필드의 제안을 선택하세요';

  @override
  String wizard_changesCount(int count) {
    return '$count개 필드 업데이트됨';
  }

  @override
  String get wizard_changesSummary => '이 변경 사항은 임시 저장으로 저장됩니다';

  @override
  String get wizard_before => '이전';

  @override
  String get wizard_after => '이후';

  @override
  String get wizard_nextStepsTitle => '다음 단계';

  @override
  String get wizard_nextStepsWithChanges =>
      '변경 사항이 임시 저장으로 저장됩니다. 메타데이터 편집기에서 검토하고 게시할 수 있습니다.';

  @override
  String get wizard_nextStepsNoChanges =>
      '저장할 변경 사항이 없습니다. 돌아가서 메타데이터를 최적화할 제안을 선택하세요.';

  @override
  String get team_title => '팀 관리';

  @override
  String get team_createTeam => '팀 만들기';

  @override
  String get team_teamName => '팀 이름';

  @override
  String get team_teamNameHint => '팀 이름 입력';

  @override
  String get team_description => '설명 (선택)';

  @override
  String get team_descriptionHint => '이 팀은 무엇을 위한 것인가요?';

  @override
  String get team_teamNameRequired => '팀 이름은 필수입니다';

  @override
  String get team_teamNameMinLength => '팀 이름은 2자 이상이어야 합니다';

  @override
  String get team_inviteMember => '팀원 초대';

  @override
  String get team_emailAddress => '이메일 주소';

  @override
  String get team_emailHint => 'colleague@example.com';

  @override
  String get team_emailRequired => '이메일은 필수입니다';

  @override
  String get team_emailInvalid => '유효한 이메일 주소를 입력하세요';

  @override
  String team_invitationSent(String email) {
    return '$email로 초대장을 보냈습니다';
  }

  @override
  String get team_members => '멤버';

  @override
  String get team_invite => '초대';

  @override
  String get team_pendingInvitations => '대기 중인 초대';

  @override
  String get team_noPendingInvitations => '대기 중인 초대가 없습니다';

  @override
  String get team_teamSettings => '팀 설정';

  @override
  String team_changeRole(String name) {
    return '$name의 역할 변경';
  }

  @override
  String get team_removeMember => '멤버 제거';

  @override
  String team_removeMemberConfirm(String name) {
    return '이 팀에서 $name를 제거하시겠습니까?';
  }

  @override
  String get team_remove => '제거';

  @override
  String get team_leaveTeam => '팀 나가기';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return '\"$teamName\"에서 나가시겠습니까?';
  }

  @override
  String get team_leave => '나가기';

  @override
  String get team_deleteTeam => '팀 삭제';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return '\"$teamName\"을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get team_yourTeams => '내 팀';

  @override
  String get team_failedToLoadTeam => '팀을 불러오지 못했습니다';

  @override
  String get team_failedToLoadMembers => '멤버를 불러오지 못했습니다';

  @override
  String get team_failedToLoadInvitations => '초대를 불러오지 못했습니다';

  @override
  String team_memberCount(int count) {
    return '$count명의 멤버';
  }

  @override
  String team_invitedAs(String role) {
    return '$role로 초대됨';
  }

  @override
  String team_joinedTeam(String teamName) {
    return '$teamName에 가입했습니다';
  }

  @override
  String get team_invitationDeclined => '초대가 거절되었습니다';

  @override
  String get team_noTeamsYet => '팀이 없습니다';

  @override
  String get team_noTeamsDescription => '팀을 만들어 다른 사람들과 협업하세요';

  @override
  String get team_createFirstTeam => '첫 번째 팀 만들기';

  @override
  String get integrations_title => '연동';

  @override
  String integrations_syncFailed(String error) {
    return '동기화 실패: $error';
  }

  @override
  String get integrations_disconnectConfirm => '연결을 해제하시겠습니까?';

  @override
  String get integrations_disconnectedSuccess => '연결이 해제되었습니다';

  @override
  String get integrations_connectGooglePlay => 'Google Play Console 연결';

  @override
  String get integrations_connectAppStore => 'App Store Connect 연결';

  @override
  String integrations_connectedApps(int count) {
    return '연결 완료! $count개 앱을 가져왔습니다.';
  }

  @override
  String integrations_syncedApps(int count) {
    return '$count개 앱을 소유자로 동기화했습니다';
  }

  @override
  String get integrations_appStoreConnected => 'App Store Connect가 연결되었습니다!';

  @override
  String get integrations_googlePlayConnected =>
      'Google Play Console이 연결되었습니다!';

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
  String get alertBuilder_nameYourRule => '규칙 이름 지정';

  @override
  String get alertBuilder_nameDescription => '알림 규칙에 설명이 포함된 이름을 지정하세요';

  @override
  String get alertBuilder_nameHint => '예: 일일 순위 알림';

  @override
  String get alertBuilder_summary => '요약';

  @override
  String get alertBuilder_saveAlertRule => '알림 규칙 저장';

  @override
  String get alertBuilder_selectAlertType => '알림 유형 선택';

  @override
  String get alertBuilder_selectAlertTypeDescription => '만들고 싶은 알림 종류를 선택하세요';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return '\"$ruleName\"이 삭제됩니다.';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate =>
      '아직 규칙이 없습니다. 템플릿을 활성화하거나 직접 만들어보세요!';

  @override
  String get billing_cancelSubscription => '구독 취소';

  @override
  String get billing_keepSubscription => '구독 유지';

  @override
  String get billing_billingPortal => '결제 포털';

  @override
  String get billing_resume => '재개';

  @override
  String get keywords_noCompetitorsFound => '경쟁자를 찾을 수 없습니다. 먼저 경쟁자를 추가하세요.';

  @override
  String get keywords_noCompetitorsForApp => '이 앱에 경쟁자가 없습니다. 먼저 경쟁자를 추가하세요.';

  @override
  String keywords_failedToAddKeywords(String error) {
    return '키워드 추가 실패: $error';
  }

  @override
  String get keywords_bulkAddHint => '예산 추적기\n지출 관리자\n머니 앱';

  @override
  String get appOverview_urlCopied => '스토어 URL이 클립보드에 복사되었습니다';

  @override
  String get country_us => '미국';

  @override
  String get country_gb => '영국';

  @override
  String get country_fr => '프랑스';

  @override
  String get country_de => '독일';

  @override
  String get country_ca => '캐나다';

  @override
  String get country_au => '호주';

  @override
  String get country_jp => '일본';

  @override
  String get country_cn => '중국';

  @override
  String get country_kr => '대한민국';

  @override
  String get country_br => '브라질';

  @override
  String get country_es => '스페인';

  @override
  String get country_it => '이탈리아';

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
  String get alertBuilder_type => '유형';

  @override
  String get alertBuilder_scope => '범위';

  @override
  String get alertBuilder_name => '이름';

  @override
  String get alertBuilder_scopeGlobal => '모든 앱';

  @override
  String get alertBuilder_scopeApp => '특정 앱';

  @override
  String get alertBuilder_scopeCategory => '카테고리';

  @override
  String get alertBuilder_scopeKeyword => '키워드';

  @override
  String get alertType_positionChange => '순위 변동';

  @override
  String get alertType_positionChangeDesc => '앱 순위가 크게 변동될 때 알림';

  @override
  String get alertType_ratingChange => '평점 변동';

  @override
  String get alertType_ratingChangeDesc => '앱 평점이 변동될 때 알림';

  @override
  String get alertType_reviewSpike => '리뷰 급증';

  @override
  String get alertType_reviewSpikeDesc => '비정상적인 리뷰 활동 시 알림';

  @override
  String get alertType_reviewKeyword => '리뷰 키워드';

  @override
  String get alertType_reviewKeywordDesc => '리뷰에 키워드가 나타날 때 알림';

  @override
  String get alertType_newCompetitor => '새 경쟁자';

  @override
  String get alertType_newCompetitorDesc => '새로운 앱이 진입할 때 알림';

  @override
  String get alertType_competitorPassed => '경쟁자 추월';

  @override
  String get alertType_competitorPassedDesc => '경쟁자를 추월할 때 알림';

  @override
  String get alertType_massMovement => '대규모 변동';

  @override
  String get alertType_massMovementDesc => '순위의 대규모 변동 시 알림';

  @override
  String get alertType_keywordTrend => '키워드 트렌드';

  @override
  String get alertType_keywordTrendDesc => '키워드 인기도가 변동될 때 알림';

  @override
  String get alertType_opportunity => '기회';

  @override
  String get alertType_opportunityDesc => '새로운 순위 기회 시 알림';

  @override
  String get billing_title => '결제 및 플랜';

  @override
  String get billing_subscriptionActivated => '구독이 성공적으로 활성화되었습니다!';

  @override
  String get billing_changePlan => '플랜 변경';

  @override
  String get billing_choosePlan => '플랜 선택';

  @override
  String get billing_cancelMessage =>
      '구독은 현재 결제 기간이 끝날 때까지 활성 상태로 유지됩니다. 그 후 프리미엄 기능에 대한 액세스 권한을 잃게 됩니다.';

  @override
  String get billing_currentPlan => '현재 플랜';

  @override
  String get billing_trial => '체험판';

  @override
  String get billing_canceling => '취소 중';

  @override
  String billing_accessUntil(String date) {
    return '$date까지 액세스 가능';
  }

  @override
  String billing_renewsOn(String date) {
    return '$date에 갱신';
  }

  @override
  String get billing_manageSubscription => '구독 관리';

  @override
  String get billing_monthly => '월간';

  @override
  String get billing_yearly => '연간';

  @override
  String billing_savePercent(int percent) {
    return '$percent% 절약';
  }

  @override
  String get billing_current => '현재';

  @override
  String get billing_apps => '앱';

  @override
  String get billing_unlimited => '무제한';

  @override
  String get billing_keywordsPerApp => '앱당 키워드';

  @override
  String get billing_history => '기록';

  @override
  String billing_days(int count) {
    return '$count일';
  }

  @override
  String get billing_exports => '내보내기';

  @override
  String get billing_aiInsights => 'AI 분석';

  @override
  String get billing_apiAccess => 'API 액세스';

  @override
  String get billing_yes => '예';

  @override
  String get billing_no => '아니오';

  @override
  String get billing_currentPlanButton => '현재 플랜';

  @override
  String billing_upgradeTo(String planName) {
    return '$planName으로 업그레이드';
  }

  @override
  String get billing_cancel => '취소';

  @override
  String get keywords_compareWithCompetitor => '경쟁자와 비교';

  @override
  String get keywords_selectCompetitorToCompare => '키워드를 비교할 경쟁자 선택:';

  @override
  String get keywords_addToCompetitor => '경쟁자에 추가';

  @override
  String keywords_addKeywordsTo(int count) {
    return '$count개의 키워드 추가:';
  }

  @override
  String get keywords_avgPosition => '평균 순위';

  @override
  String get keywords_declined => '하락';

  @override
  String get keywords_total => '전체';

  @override
  String get keywords_ranked => '순위';

  @override
  String get keywords_improved => '상승';

  @override
  String get onboarding_skip => '건너뛰기';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_getStarted => '시작하기';

  @override
  String get onboarding_welcomeToKeyrank => 'Keyrank에 오신 것을 환영합니다';

  @override
  String get onboarding_welcomeSubtitle =>
      'Track your app rankings, manage reviews, and optimize your ASO strategy.';

  @override
  String get onboarding_connectStore => 'Connect Your Store';

  @override
  String get onboarding_connectStoreSubtitle =>
      'Optional: Connect to import apps and reply to reviews.';

  @override
  String get onboarding_couldNotLoadIntegrations =>
      'Could not load integrations';

  @override
  String get onboarding_tapToConnect => 'Tap to connect';

  @override
  String get onboarding_allSet => 'You\'re All Set!';

  @override
  String get onboarding_allSetSubtitle =>
      'Start by adding an app to track, or explore the keyword inspector.';

  @override
  String get team_you => '나';

  @override
  String get team_changeRoleButton => 'Change Role';

  @override
  String get team_removeButton => 'Remove';

  @override
  String get competitors_removeTitle => 'Remove Competitor';

  @override
  String competitors_removeConfirm(String name) {
    return '\"$name\"을(를) 경쟁사에서 제거하시겠습니까?';
  }

  @override
  String competitors_removed(String name) {
    return '$name removed';
  }

  @override
  String competitors_removeFailed(String error) {
    return 'Failed to remove competitor: $error';
  }

  @override
  String get competitors_addCompetitor => 'Add competitor';

  @override
  String get competitors_filterAll => 'All';

  @override
  String get competitors_filterGlobal => 'Global';

  @override
  String get competitors_filterContextual => 'Contextual';

  @override
  String get competitors_noCompetitorsYet => 'No competitors tracked yet';

  @override
  String get competitors_noGlobalCompetitors => 'No global competitors';

  @override
  String get competitors_noContextualCompetitors => 'No contextual competitors';

  @override
  String get competitors_emptySubtitleAll =>
      'Search for apps and add them as competitors to track their rankings';

  @override
  String get competitors_emptySubtitleGlobal =>
      'Global competitors appear across all your apps';

  @override
  String get competitors_emptySubtitleContextual =>
      'Contextual competitors are linked to specific apps';

  @override
  String get competitors_searchForCompetitors => 'Search for competitors';

  @override
  String get competitors_viewKeywords => 'View Keywords';

  @override
  String get common_remove => 'Remove';

  @override
  String get competitors_addTitle => 'Add Competitor';

  @override
  String competitors_addedAsCompetitor(String name) {
    return '$name added as competitor';
  }

  @override
  String competitors_addFailed(String error) {
    return '경쟁사 추가 실패: $error';
  }

  @override
  String get competitors_searchForCompetitor => 'Search for a competitor';

  @override
  String get appPreview_back => 'Back';

  @override
  String get alerts_edit => '편집';

  @override
  String get alerts_scopeGlobal => '전역';

  @override
  String get alerts_scopeApp => '앱';

  @override
  String get alerts_scopeCategory => '카테고리';

  @override
  String get alerts_scopeKeyword => '키워드';

  @override
  String ratings_showMore(int count) {
    return 'Show more ($count remaining)';
  }

  @override
  String get ratings_showLess => 'Show less';

  @override
  String get insights_aiInsights => 'AI Insights';

  @override
  String get insights_viewAll => 'View all';

  @override
  String insights_viewMore(int count) {
    return '$count개의 인사이트 더 보기';
  }

  @override
  String get insights_noInsightsDesc => '앱의 최적화 기회를 발견하면 인사이트가 표시됩니다.';

  @override
  String get insights_loadFailed => '인사이트 로딩 실패';

  @override
  String chat_createFailed(String error) {
    return 'Failed to create conversation: $error';
  }

  @override
  String chat_deleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String get notifications_manageAlerts => 'Manage alerts';
}
