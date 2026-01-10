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
}
