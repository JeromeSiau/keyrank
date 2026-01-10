// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTagline => 'App Storeのランキングを追跡';

  @override
  String get auth_welcomeBack => 'おかえりなさい';

  @override
  String get auth_signInSubtitle => 'アカウントにサインイン';

  @override
  String get auth_createAccount => 'アカウント作成';

  @override
  String get auth_createAccountSubtitle => 'ランキングの追跡を開始';

  @override
  String get auth_emailLabel => 'メールアドレス';

  @override
  String get auth_passwordLabel => 'パスワード';

  @override
  String get auth_nameLabel => '名前';

  @override
  String get auth_confirmPasswordLabel => 'パスワードを確認';

  @override
  String get auth_signInButton => 'サインイン';

  @override
  String get auth_signUpButton => 'アカウント作成';

  @override
  String get auth_noAccount => 'アカウントをお持ちでないですか？';

  @override
  String get auth_hasAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get auth_signUpLink => '登録';

  @override
  String get auth_signInLink => 'サインイン';

  @override
  String get auth_emailRequired => 'メールアドレスを入力してください';

  @override
  String get auth_emailInvalid => '無効なメールアドレス';

  @override
  String get auth_passwordRequired => 'パスワードを入力してください';

  @override
  String get auth_enterPassword => 'パスワードを入力してください';

  @override
  String get auth_nameRequired => '名前を入力してください';

  @override
  String get auth_passwordMinLength => 'パスワードは8文字以上必要です';

  @override
  String get auth_passwordsNoMatch => 'パスワードが一致しません';

  @override
  String get auth_errorOccurred => 'エラーが発生しました';

  @override
  String get common_retry => '再試行';

  @override
  String common_error(String message) {
    return 'エラー: $message';
  }

  @override
  String get common_loading => '読み込み中...';

  @override
  String get common_add => '追加';

  @override
  String get common_filter => 'フィルター';

  @override
  String get common_sort => '並び替え';

  @override
  String get common_refresh => '更新';

  @override
  String get common_settings => '設定';

  @override
  String get dashboard_title => 'ダッシュボード';

  @override
  String get dashboard_addApp => 'アプリを追加';

  @override
  String get dashboard_appsTracked => '追跡中のアプリ';

  @override
  String get dashboard_keywords => 'キーワード';

  @override
  String get dashboard_avgPosition => '平均順位';

  @override
  String get dashboard_top10 => 'トップ10';

  @override
  String get dashboard_trackedApps => '追跡中のアプリ';

  @override
  String get dashboard_quickActions => 'クイックアクション';

  @override
  String get dashboard_addNewApp => '新しいアプリを追加';

  @override
  String get dashboard_searchKeywords => 'キーワードを検索';

  @override
  String get dashboard_viewAllApps => 'すべてのアプリを表示';

  @override
  String get dashboard_noAppsYet => 'まだ追跡中のアプリがありません';

  @override
  String get dashboard_addAppToStart => 'アプリを追加してキーワードの追跡を開始';

  @override
  String get dashboard_noAppsMatchFilter => 'フィルターに一致するアプリがありません';

  @override
  String get dashboard_changeFilterCriteria => 'フィルター条件を変更してください';

  @override
  String get apps_title => 'マイアプリ';

  @override
  String apps_appCount(int count) {
    return '$count個のアプリ';
  }

  @override
  String get apps_tableApp => 'アプリ';

  @override
  String get apps_tableDeveloper => '開発者';

  @override
  String get apps_tableKeywords => 'キーワード';

  @override
  String get apps_tablePlatform => 'プラットフォーム';

  @override
  String get apps_tableRating => '評価';

  @override
  String get apps_tableBestRank => '最高順位';

  @override
  String get apps_noAppsYet => 'まだ追跡中のアプリがありません';

  @override
  String get apps_addAppToStart => 'アプリを追加してランキングの追跡を開始';

  @override
  String get addApp_title => 'アプリを追加';

  @override
  String get addApp_searchAppStore => 'App Storeで検索...';

  @override
  String get addApp_searchPlayStore => 'Play Storeで検索...';

  @override
  String get addApp_searchForApp => 'アプリを検索';

  @override
  String get addApp_enterAtLeast2Chars => '2文字以上入力してください';

  @override
  String get addApp_noResults => '結果が見つかりません';

  @override
  String addApp_addedSuccess(String name) {
    return '$nameを追加しました';
  }

  @override
  String get settings_title => '設定';

  @override
  String get settings_language => '言語';

  @override
  String get settings_appearance => '外観';

  @override
  String get settings_theme => 'テーマ';

  @override
  String get settings_themeSystem => 'システム';

  @override
  String get settings_themeDark => 'ダーク';

  @override
  String get settings_themeLight => 'ライト';

  @override
  String get settings_account => 'アカウント';

  @override
  String get settings_memberSince => '登録日';

  @override
  String get settings_logout => 'ログアウト';

  @override
  String get settings_languageSystem => 'システム';

  @override
  String get filter_all => 'すべて';

  @override
  String get filter_allApps => 'すべてのアプリ';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'iOSのみ';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Androidのみ';

  @override
  String get filter_favorites => 'お気に入り';

  @override
  String get sort_recent => '最近';

  @override
  String get sort_recentlyAdded => '最近追加';

  @override
  String get sort_nameAZ => '名前 A-Z';

  @override
  String get sort_nameZA => '名前 Z-A';

  @override
  String get sort_keywords => 'キーワード';

  @override
  String get sort_mostKeywords => 'キーワード数順';

  @override
  String get sort_bestRank => '最高順位';

  @override
  String get userMenu_logout => 'ログアウト';
}
