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
}
