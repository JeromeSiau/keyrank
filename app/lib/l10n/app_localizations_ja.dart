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
  String get common_search => '検索...';

  @override
  String get common_noResults => '結果がありません';

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

  @override
  String get insights_compareTitle => 'インサイトを比較';

  @override
  String get insights_analyzingReviews => 'レビューを分析中...';

  @override
  String get insights_noInsightsAvailable => 'インサイトがありません';

  @override
  String get insights_strengths => '強み';

  @override
  String get insights_weaknesses => '弱み';

  @override
  String get insights_scores => 'スコア';

  @override
  String get insights_opportunities => '機会';

  @override
  String get insights_categoryUx => 'UX';

  @override
  String get insights_categoryPerf => '性能';

  @override
  String get insights_categoryFeatures => '機能';

  @override
  String get insights_categoryPricing => '価格';

  @override
  String get insights_categorySupport => 'サポート';

  @override
  String get insights_categoryOnboard => '導入';

  @override
  String get insights_categoryUxFull => 'UX / インターフェース';

  @override
  String get insights_categoryPerformance => 'パフォーマンス';

  @override
  String get insights_categoryOnboarding => 'オンボーディング';

  @override
  String get insights_reviewInsights => 'レビューインサイト';

  @override
  String get insights_generateFirst => 'まずインサイトを生成してください';

  @override
  String get insights_compareWithOther => '他のアプリと比較';

  @override
  String get insights_compare => '比較';

  @override
  String get insights_generateAnalysis => '分析を生成';

  @override
  String get insights_period => '期間:';

  @override
  String get insights_3months => '3ヶ月';

  @override
  String get insights_6months => '6ヶ月';

  @override
  String get insights_12months => '12ヶ月';

  @override
  String get insights_analyze => '分析';

  @override
  String insights_reviewsCount(int count) {
    return '$count件のレビュー';
  }

  @override
  String insights_analyzedAgo(String time) {
    return '$time前に分析';
  }

  @override
  String get insights_yourNotes => 'メモ';

  @override
  String get insights_save => '保存';

  @override
  String get insights_clickToAddNotes => 'クリックしてメモを追加...';

  @override
  String get insights_noteSaved => 'メモを保存しました';

  @override
  String get insights_noteHint => 'この分析に関するメモを追加...';

  @override
  String get insights_categoryScores => 'カテゴリスコア';

  @override
  String get insights_emergentThemes => '浮上するテーマ';

  @override
  String get insights_exampleQuotes => '引用例:';

  @override
  String get insights_selectCountryFirst => '少なくとも1つの国を選択してください';

  @override
  String compare_selectAppsToCompare(String appName) {
    return '$appNameと比較する最大3つのアプリを選択';
  }

  @override
  String get compare_searchApps => 'アプリを検索...';

  @override
  String get compare_noOtherApps => '比較するアプリがありません';

  @override
  String get compare_noMatchingApps => '一致するアプリがありません';

  @override
  String compare_appsSelected(int count) {
    return '$count/3個のアプリを選択';
  }

  @override
  String get compare_cancel => 'キャンセル';

  @override
  String compare_button(int count) {
    return '$count個のアプリを比較';
  }

  @override
  String get appDetail_deleteAppTitle => 'アプリを削除しますか？';

  @override
  String get appDetail_deleteAppConfirm => 'この操作は元に戻せません。';

  @override
  String get appDetail_cancel => 'キャンセル';

  @override
  String get appDetail_delete => '削除';

  @override
  String get appDetail_exporting => 'ランキングをエクスポート中...';

  @override
  String appDetail_savedFile(String filename) {
    return '保存完了: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Finderで表示';

  @override
  String appDetail_exportFailed(String error) {
    return 'エクスポート失敗: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return '$imported個のキーワードをインポート（$skipped個スキップ）';
  }

  @override
  String get appDetail_favorite => 'お気に入り';

  @override
  String get appDetail_ratings => '評価';

  @override
  String get appDetail_insights => 'インサイト';

  @override
  String get appDetail_import => 'インポート';

  @override
  String get appDetail_export => 'エクスポート';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count件のレビュー';
  }

  @override
  String get appDetail_keywords => 'キーワード';

  @override
  String get appDetail_addKeyword => 'キーワードを追加';

  @override
  String get appDetail_keywordHint => '例: フィットネストラッカー';

  @override
  String get appDetail_trackedKeywords => '追跡中のキーワード';

  @override
  String appDetail_selectedCount(int count) {
    return '$count個選択';
  }

  @override
  String get appDetail_allKeywords => 'すべてのキーワード';

  @override
  String get appDetail_hasTags => 'タグあり';

  @override
  String get appDetail_hasNotes => 'メモあり';

  @override
  String get appDetail_position => '順位';

  @override
  String get appDetail_select => '選択';

  @override
  String get appDetail_suggestions => '候補';

  @override
  String get appDetail_deleteKeywordsTitle => 'キーワードを削除';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return '$count個のキーワードを削除しますか？';
  }

  @override
  String get appDetail_tag => 'タグ';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return 'キーワード「$keyword」を追加しました（$flag）';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return '$count個のキーワードにタグを追加しました';
  }

  @override
  String get appDetail_keywordsAddedSuccess => 'キーワードを追加しました';

  @override
  String get appDetail_noTagsAvailable => 'タグがありません。まずタグを作成してください。';

  @override
  String get appDetail_tagged => 'タグ付き';

  @override
  String get appDetail_withNotes => 'メモ付き';

  @override
  String get appDetail_nameAZ => '名前 A-Z';

  @override
  String get appDetail_nameZA => '名前 Z-A';

  @override
  String get appDetail_bestPosition => '最高順位';

  @override
  String get appDetail_recentlyTracked => '最近追跡';

  @override
  String get keywordSuggestions_title => 'キーワード候補';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$countryの$appName';
  }

  @override
  String get keywordSuggestions_refresh => '候補を更新';

  @override
  String get keywordSuggestions_search => '候補を検索...';

  @override
  String get keywordSuggestions_selectAll => 'すべて選択';

  @override
  String get keywordSuggestions_clear => 'クリア';

  @override
  String get keywordSuggestions_analyzing => 'アプリのメタデータを分析中...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds => '数秒かかる場合があります';

  @override
  String get keywordSuggestions_noSuggestions => '候補がありません';

  @override
  String get keywordSuggestions_noMatchingSuggestions => '一致する候補がありません';

  @override
  String get keywordSuggestions_headerKeyword => 'キーワード';

  @override
  String get keywordSuggestions_headerDifficulty => '難易度';

  @override
  String get keywordSuggestions_headerApps => 'アプリ数';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return '#$position位';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count個のキーワードを選択';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return '$count個のキーワードを追加';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'キーワード追加エラー: $error';
  }

  @override
  String get sidebar_favorites => 'お気に入り';

  @override
  String get sidebar_tooManyFavorites => 'お気に入りは5個以下をお勧めします';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'キーワード調査';

  @override
  String get keywordSearch_searchPlaceholder => 'キーワードを検索...';

  @override
  String get keywordSearch_searchTitle => 'キーワードを検索';

  @override
  String get keywordSearch_searchSubtitle => '任意のキーワードでランクインしているアプリを発見';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count個のアプリがランクイン';
  }

  @override
  String get keywordSearch_popularity => '人気度';

  @override
  String keywordSearch_results(int count) {
    return '$count件の結果';
  }

  @override
  String get keywordSearch_headerRank => '順位';

  @override
  String get keywordSearch_headerApp => 'アプリ';

  @override
  String get keywordSearch_headerRating => '評価';

  @override
  String get keywordSearch_headerTrack => '追跡';

  @override
  String get keywordSearch_trackApp => 'このアプリを追跡';

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
    return '$appNameのレビュー';
  }

  @override
  String get reviews_loading => 'レビューを読み込み中...';

  @override
  String get reviews_noReviews => 'レビューなし';

  @override
  String reviews_noReviewsFor(String countryName) {
    return '$countryNameのレビューがありません';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'App Storeから最新の$count件のレビューを表示中。';
  }

  @override
  String get reviews_today => '今日';

  @override
  String get reviews_yesterday => '昨日';

  @override
  String reviews_daysAgo(int count) {
    return '$count日前';
  }

  @override
  String reviews_weeksAgo(int count) {
    return '$count週間前';
  }

  @override
  String reviews_monthsAgo(int count) {
    return '$countヶ月前';
  }

  @override
  String get ratings_byCountry => '国別評価';

  @override
  String get ratings_noRatingsAvailable => '評価がありません';

  @override
  String get ratings_noRatingsYet => 'このアプリにはまだ評価がありません';

  @override
  String get ratings_totalRatings => '総評価数';

  @override
  String get ratings_averageRating => '平均評価';

  @override
  String ratings_countriesCount(int count) {
    return '$countヶ国';
  }

  @override
  String ratings_updated(String date) {
    return '更新日: $date';
  }

  @override
  String get ratings_headerCountry => '国';

  @override
  String get ratings_headerRatings => '評価数';

  @override
  String get ratings_headerAverage => '平均';

  @override
  String time_minutesAgo(int count) {
    return '$count分前';
  }

  @override
  String time_hoursAgo(int count) {
    return '$count時間前';
  }

  @override
  String time_daysAgo(int count) {
    return '$count日前';
  }

  @override
  String get appDetail_noKeywordsTracked => '追跡中のキーワードがありません';

  @override
  String get appDetail_addKeywordHint => '上のフィールドにキーワードを追加して追跡を開始';

  @override
  String get appDetail_noKeywordsMatchFilter => 'フィルターに一致するキーワードがありません';

  @override
  String get appDetail_tryChangingFilter => 'フィルター条件を変更してください';

  @override
  String get appDetail_addTag => 'タグを追加';

  @override
  String get appDetail_addNote => 'メモを追加';

  @override
  String get appDetail_positionHistory => '順位履歴';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => '概要';

  @override
  String get nav_dashboard => 'ダッシュボード';

  @override
  String get nav_myApps => 'マイアプリ';

  @override
  String get nav_research => 'リサーチ';

  @override
  String get nav_keywords => 'キーワード';

  @override
  String get nav_discover => '発見';

  @override
  String get nav_notifications => '通知';

  @override
  String get common_save => '保存';

  @override
  String get appDetail_manageTags => 'タグを管理';

  @override
  String get appDetail_newTagHint => '新しいタグ名...';

  @override
  String get appDetail_availableTags => '利用可能なタグ';

  @override
  String get appDetail_noTagsYet => 'タグがまだありません。上で作成してください。';

  @override
  String get appDetail_addTagsTitle => 'タグを追加';

  @override
  String get appDetail_selectTagsDescription => '選択したキーワードに追加するタグを選択:';

  @override
  String appDetail_addTagsCount(int count) {
    return '$count個のタグを追加';
  }

  @override
  String appDetail_importFailed(String error) {
    return 'インポート失敗: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'キーワードをインポート';

  @override
  String get appDetail_pasteKeywordsHint => '以下にキーワードを貼り付け（1行に1つ）:';

  @override
  String get appDetail_keywordPlaceholder => 'キーワード1\nキーワード2\nキーワード3';

  @override
  String get appDetail_storefront => 'ストアフロント:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count個のキーワード';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return '$count個のキーワードをインポート';
  }

  @override
  String get appDetail_period7d => '7日';

  @override
  String get appDetail_period30d => '30日';

  @override
  String get appDetail_period90d => '90日';

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
  String get notifications_title => '通知';

  @override
  String get notifications_markAllRead => 'すべて既読にする';

  @override
  String get notifications_empty => 'まだ通知がありません';

  @override
  String get alerts_title => 'アラートルール';

  @override
  String get alerts_templatesTitle => 'クイックテンプレート';

  @override
  String get alerts_templatesSubtitle => 'ワンタップで一般的なアラートを有効化';

  @override
  String get alerts_myRulesTitle => 'マイルール';

  @override
  String get alerts_createRule => 'ルールを作成';

  @override
  String get alerts_editRule => 'ルールを編集';

  @override
  String get alerts_noRulesYet => 'まだルールがありません';

  @override
  String get alerts_deleteConfirm => 'ルールを削除しますか？';

  @override
  String get settings_notifications => '通知';

  @override
  String get settings_manageAlerts => 'アラートルールを管理';

  @override
  String get settings_manageAlertsDesc => '受け取るアラートを設定';
}
