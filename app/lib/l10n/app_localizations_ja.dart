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
  String get dashboard_reviews => 'レビュー';

  @override
  String get dashboard_avgRating => '平均評価';

  @override
  String get dashboard_topPerformingApps => '高パフォーマンスのアプリ';

  @override
  String get dashboard_topCountries => '上位の国';

  @override
  String get dashboard_sentimentOverview => 'センチメント概要';

  @override
  String get dashboard_overallSentiment => '総合センチメント';

  @override
  String get dashboard_positive => 'ポジティブ';

  @override
  String get dashboard_positiveReviews => 'ポジティブ';

  @override
  String get dashboard_negativeReviews => 'ネガティブ';

  @override
  String get dashboard_viewReviews => 'レビューを見る';

  @override
  String get dashboard_tableApp => 'アプリ';

  @override
  String get dashboard_tableKeywords => 'キーワード';

  @override
  String get dashboard_tableAvgRank => '平均順位';

  @override
  String get dashboard_tableTrend => 'トレンド';

  @override
  String get dashboard_connectYourStores => 'ストアを接続';

  @override
  String get dashboard_connectStoresDescription =>
      'App Store ConnectまたはGoogle Playを連携して、アプリのインポートとレビューへの返信を有効にします。';

  @override
  String get dashboard_connect => '接続';

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
  String get insights_title => 'インサイト';

  @override
  String insights_titleWithApp(String appName) {
    return 'インサイト - $appName';
  }

  @override
  String get insights_allApps => 'インサイト（すべてのアプリ）';

  @override
  String get insights_noInsightsYet => 'まだインサイトがありません';

  @override
  String get insights_selectAppToGenerate => 'アプリを選択してレビューからインサイトを生成';

  @override
  String insights_appsWithInsights(int count) {
    return '$count個のアプリにインサイトあり';
  }

  @override
  String get insights_errorLoading => 'インサイトの読み込みエラー';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '$count件のレビューを分析済み';
  }

  @override
  String get insights_avgScore => '平均スコア';

  @override
  String insights_updatedOn(String date) {
    return '$dateに更新';
  }

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
  String get keywordSuggestions_categoryAll => 'すべて';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'チャンス';

  @override
  String get keywordSuggestions_categoryCompetitor => '競合キーワード';

  @override
  String get keywordSuggestions_categoryLongTail => 'ロングテール';

  @override
  String get keywordSuggestions_categoryTrending => 'トレンド';

  @override
  String get keywordSuggestions_categoryRelated => '関連';

  @override
  String get keywordSuggestions_generating => '候補を生成中...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      '数分かかる場合があります。後でまたご確認ください。';

  @override
  String get keywordSuggestions_checkAgain => '再確認';

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
  String get discover_title => 'ディスカバー';

  @override
  String get discover_tabKeywords => 'キーワード';

  @override
  String get discover_tabCategories => 'カテゴリ';

  @override
  String get discover_selectCategory => 'カテゴリを選択';

  @override
  String get discover_topFree => '無料';

  @override
  String get discover_topPaid => '有料';

  @override
  String get discover_topGrossing => '売上';

  @override
  String get discover_noResults => '結果がありません';

  @override
  String get discover_loadingTopApps => 'トップアプリを読み込み中...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return '$categoryの$collectionトップ';
  }

  @override
  String discover_appsCount(int count) {
    return '$count個のアプリ';
  }

  @override
  String get discover_allCategories => 'すべてのカテゴリ';

  @override
  String get category_games => 'ゲーム';

  @override
  String get category_business => 'ビジネス';

  @override
  String get category_education => '教育';

  @override
  String get category_entertainment => 'エンターテインメント';

  @override
  String get category_finance => 'ファイナンス';

  @override
  String get category_food_drink => 'フード＆ドリンク';

  @override
  String get category_health_fitness => 'ヘルスケア＆フィットネス';

  @override
  String get category_lifestyle => 'ライフスタイル';

  @override
  String get category_medical => 'メディカル';

  @override
  String get category_music => 'ミュージック';

  @override
  String get category_navigation => 'ナビゲーション';

  @override
  String get category_news => 'ニュース';

  @override
  String get category_photo_video => '写真＆ビデオ';

  @override
  String get category_productivity => '仕事効率化';

  @override
  String get category_reference => '辞書＆辞典';

  @override
  String get category_shopping => 'ショッピング';

  @override
  String get category_social => 'ソーシャルネットワーキング';

  @override
  String get category_sports => 'スポーツ';

  @override
  String get category_travel => '旅行';

  @override
  String get category_utilities => 'ユーティリティ';

  @override
  String get category_weather => '天気';

  @override
  String get category_books => 'ブック';

  @override
  String get category_developer_tools => '開発ツール';

  @override
  String get category_graphics_design => 'グラフィック＆デザイン';

  @override
  String get category_magazines => '雑誌＆新聞';

  @override
  String get category_stickers => 'ステッカー';

  @override
  String get category_catalogs => 'カタログ';

  @override
  String get category_art_design => 'アート＆デザイン';

  @override
  String get category_auto_vehicles => '自動車';

  @override
  String get category_beauty => '美容';

  @override
  String get category_comics => 'マンガ';

  @override
  String get category_communication => 'コミュニケーション';

  @override
  String get category_dating => '出会い';

  @override
  String get category_events => 'イベント';

  @override
  String get category_house_home => '住まい＆インテリア';

  @override
  String get category_libraries => 'ライブラリ';

  @override
  String get category_maps_navigation => '地図＆ナビ';

  @override
  String get category_music_audio => '音楽＆オーディオ';

  @override
  String get category_news_magazines => 'ニュース＆雑誌';

  @override
  String get category_parenting => '出産＆育児';

  @override
  String get category_personalization => 'カスタマイズ';

  @override
  String get category_photography => '写真';

  @override
  String get category_tools => 'ツール';

  @override
  String get category_video_players => '動画プレーヤー';

  @override
  String get category_all_apps => 'すべてのアプリ';

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
  String get nav_discover => 'ディスカバー';

  @override
  String get nav_engagement => 'エンゲージメント';

  @override
  String get nav_reviewsInbox => '受信トレイ';

  @override
  String get nav_notifications => 'アラート';

  @override
  String get nav_optimization => '最適化';

  @override
  String get nav_keywordInspector => 'キーワードインスペクター';

  @override
  String get nav_ratingsAnalysis => '評価分析';

  @override
  String get nav_intelligence => 'インテリジェンス';

  @override
  String get nav_topCharts => 'トップチャート';

  @override
  String get nav_competitors => '競合';

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
  String get appDetail_currentTags => '現在のタグ';

  @override
  String get appDetail_noTagsOnKeyword => 'このキーワードにタグはありません';

  @override
  String get appDetail_addExistingTag => '既存のタグを追加';

  @override
  String get appDetail_allTagsUsed => 'すべてのタグが使用中です';

  @override
  String get appDetail_createNewTag => '新しいタグを作成';

  @override
  String get appDetail_tagNameHint => 'タグ名...';

  @override
  String get appDetail_note => 'メモ';

  @override
  String get appDetail_noteHint => 'このキーワードについてのメモを追加...';

  @override
  String get appDetail_saveNote => 'メモを保存';

  @override
  String get appDetail_done => '完了';

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
  String get keywords_difficultyFilter => '難易度:';

  @override
  String get keywords_difficultyAll => 'すべて';

  @override
  String get keywords_difficultyEasy => '簡単 < 40';

  @override
  String get keywords_difficultyMedium => '普通 40-70';

  @override
  String get keywords_difficultyHard => '難しい > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'アプリ詳細';

  @override
  String get appPreview_notFound => 'アプリが見つかりません';

  @override
  String get appPreview_screenshots => 'スクリーンショット';

  @override
  String get appPreview_description => '説明';

  @override
  String get appPreview_details => '詳細';

  @override
  String get appPreview_version => 'バージョン';

  @override
  String get appPreview_updated => '更新日';

  @override
  String get appPreview_released => 'リリース日';

  @override
  String get appPreview_size => 'サイズ';

  @override
  String get appPreview_minimumOs => '必要条件';

  @override
  String get appPreview_price => '価格';

  @override
  String get appPreview_free => '無料';

  @override
  String get appPreview_openInStore => 'ストアで開く';

  @override
  String get appPreview_addToMyApps => 'マイアプリに追加';

  @override
  String get appPreview_added => '追加済み';

  @override
  String get appPreview_showMore => 'もっと見る';

  @override
  String get appPreview_showLess => '閉じる';

  @override
  String get appPreview_keywordsPlaceholder => 'このアプリを追跡中のアプリに追加してキーワード追跡を有効化';

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
  String get alerts_createCustomRule => 'カスタムルールを作成';

  @override
  String alerts_ruleActivated(String name) {
    return '$nameを有効化しました！';
  }

  @override
  String alerts_deleteMessage(String name) {
    return '「$name」を削除します。';
  }

  @override
  String get alerts_noRulesDescription => 'テンプレートを有効化するか、独自のルールを作成してください！';

  @override
  String get alerts_create => '作成';

  @override
  String get settings_notifications => '通知';

  @override
  String get settings_manageAlerts => 'アラートルールを管理';

  @override
  String get settings_manageAlertsDesc => '受け取るアラートを設定';

  @override
  String get settings_storeConnections => 'ストア接続';

  @override
  String get settings_storeConnectionsDesc => 'App StoreとGoogle Playアカウントを接続';

  @override
  String get settings_alertDelivery => 'アラート配信';

  @override
  String get settings_team => 'チーム';

  @override
  String get settings_teamManagement => 'チーム管理';

  @override
  String get settings_teamManagementDesc =>
      'Invite members, manage roles & permissions';

  @override
  String get settings_integrations => 'インテグレーション';

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
  String get storeConnections_title => 'ストア接続';

  @override
  String get storeConnections_description =>
      'App StoreとGoogle Playアカウントを接続して、売上データやアプリ分析などの高度な機能を有効にします。';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc => 'Apple開発者アカウントを接続';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc => 'Google Playアカウントを接続';

  @override
  String get storeConnections_connect => '接続';

  @override
  String get storeConnections_disconnect => '切断';

  @override
  String get storeConnections_connected => '接続済み';

  @override
  String get storeConnections_disconnectConfirm => '切断しますか？';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'この$platformアカウントを切断してもよろしいですか？';
  }

  @override
  String get storeConnections_disconnectSuccess => '切断しました';

  @override
  String storeConnections_lastSynced(String date) {
    return '最終同期: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return '$dateに接続';
  }

  @override
  String get storeConnections_syncApps => 'アプリを同期';

  @override
  String get storeConnections_syncing => '同期中...';

  @override
  String get storeConnections_syncDescription =>
      '同期により、このアカウントのアプリが所有アプリとしてマークされ、レビューへの返信が可能になります。';

  @override
  String storeConnections_syncedApps(int count) {
    return '$count個のアプリを所有として同期しました';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return '同期に失敗しました: $error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return '接続の読み込みエラー: $error';
  }

  @override
  String get reviewsInbox_title => '受信トレイ';

  @override
  String get reviewsInbox_filterUnanswered => '未回答';

  @override
  String get reviewsInbox_filterNegative => 'ネガティブ';

  @override
  String get reviewsInbox_noReviews => 'レビューが見つかりません';

  @override
  String get reviewsInbox_noReviewsDesc => 'フィルターを調整してみてください';

  @override
  String get reviewsInbox_reply => '返信';

  @override
  String get reviewsInbox_responded => '返信済み';

  @override
  String reviewsInbox_respondedAt(String date) {
    return '$dateに返信';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'レビューに返信';

  @override
  String get reviewsInbox_generateAi => 'AI提案を生成';

  @override
  String get reviewsInbox_generating => '生成中...';

  @override
  String get reviewsInbox_sendReply => '返信を送信';

  @override
  String get reviewsInbox_sending => '送信中...';

  @override
  String get reviewsInbox_replyPlaceholder => '返信を入力...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970文字';
  }

  @override
  String get reviewsInbox_replySent => '返信を送信しました';

  @override
  String reviewsInbox_replyError(String error) {
    return '返信の送信に失敗しました: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return '提案の生成に失敗しました: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$countつ星';
  }

  @override
  String get reviewsInbox_totalReviews => 'レビュー総数';

  @override
  String get reviewsInbox_unanswered => '未回答';

  @override
  String get reviewsInbox_positive => 'ポジティブ';

  @override
  String get reviewsInbox_avgRating => '平均評価';

  @override
  String get reviewsInbox_sentimentOverview => 'センチメント概要';

  @override
  String get reviewsInbox_aiSuggestions => 'AI提案';

  @override
  String get reviewsInbox_regenerate => '再生成';

  @override
  String get reviewsInbox_toneProfessional => 'プロフェッショナル';

  @override
  String get reviewsInbox_toneEmpathetic => '共感的';

  @override
  String get reviewsInbox_toneBrief => '簡潔';

  @override
  String get reviewsInbox_selectTone => 'トーンを選択:';

  @override
  String get reviewsInbox_detectedIssues => '検出された問題:';

  @override
  String get reviewsInbox_aiPrompt => '「AI提案を生成」をクリックして、3つの異なるトーンで返信の提案を取得します';

  @override
  String get reviewIntelligence_title => 'レビューインテリジェンス';

  @override
  String get reviewIntelligence_featureRequests => '機能リクエスト';

  @override
  String get reviewIntelligence_bugReports => 'バグ報告';

  @override
  String get reviewIntelligence_sentimentByVersion => 'バージョン別センチメント';

  @override
  String get reviewIntelligence_openFeatures => 'オープンな機能';

  @override
  String get reviewIntelligence_openBugs => 'オープンなバグ';

  @override
  String get reviewIntelligence_highPriority => '高優先度';

  @override
  String get reviewIntelligence_total => '合計';

  @override
  String get reviewIntelligence_mentions => '言及';

  @override
  String get reviewIntelligence_noData => 'インサイトがまだありません';

  @override
  String get reviewIntelligence_noDataHint => 'レビューを分析するとインサイトが表示されます';

  @override
  String get analytics_title => '分析';

  @override
  String get analytics_downloads => 'ダウンロード';

  @override
  String get analytics_revenue => '収益';

  @override
  String get analytics_proceeds => '売上';

  @override
  String get analytics_subscribers => '登録者';

  @override
  String get analytics_downloadsOverTime => 'ダウンロード推移';

  @override
  String get analytics_revenueOverTime => '収益推移';

  @override
  String get analytics_byCountry => '国別';

  @override
  String get analytics_noData => 'データがありません';

  @override
  String get analytics_noDataTitle => '分析データがありません';

  @override
  String get analytics_noDataDescription =>
      'App Store ConnectまたはGoogle Playアカウントを接続して、実際の売上とダウンロードデータを確認してください。';

  @override
  String analytics_dataDelay(String date) {
    return '$date時点のデータ。Appleデータは24-48時間の遅延があります。';
  }

  @override
  String get analytics_export => 'CSVエクスポート';

  @override
  String get funnel_title => 'コンバージョンファネル';

  @override
  String get funnel_impressions => 'インプレッション';

  @override
  String get funnel_pageViews => 'ページビュー';

  @override
  String get funnel_downloads => 'ダウンロード';

  @override
  String get funnel_overallCvr => '全体CVR';

  @override
  String get funnel_categoryAvg => 'カテゴリ平均';

  @override
  String get funnel_vsCategory => '対カテゴリ';

  @override
  String get funnel_bySource => 'ソース別';

  @override
  String get funnel_noData => 'ファネルデータがありません';

  @override
  String get funnel_noDataHint =>
      'ファネルデータはApp Store ConnectまたはGoogle Play Consoleから自動的に同期されます。';

  @override
  String get funnel_insight => 'インサイト';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return '$bestSourceのトラフィックは$worstSourceより$ratio倍高いコンバージョン率です。$recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'キーワード最適化に注力して検索インプレッションを増やしましょう。';

  @override
  String get funnel_insightRecommendBrowse =>
      'カテゴリ最適化とおすすめ配置を改善してブラウズでの露出を高めましょう。';

  @override
  String get funnel_insightRecommendReferral =>
      '紹介プログラムやパートナーシップを活用してトラフィックを増やしましょう。';

  @override
  String get funnel_insightRecommendAppReferrer =>
      '補完的なアプリとのクロスプロモーション戦略を検討しましょう。';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'ウェブサイトやランディングページをダウンロード向けに最適化しましょう。';

  @override
  String get funnel_insightRecommendDefault => 'このソースが効果的な理由を分析し、再現しましょう。';

  @override
  String get funnel_trendTitle => 'コンバージョン率のトレンド';

  @override
  String get funnel_connectStore => 'ストアを接続';

  @override
  String get nav_chat => 'AIアシスタント';

  @override
  String get chat_title => 'AIアシスタント';

  @override
  String get chat_newConversation => '新しい会話';

  @override
  String get chat_loadingConversations => '会話を読み込み中...';

  @override
  String get chat_loadingMessages => 'メッセージを読み込み中...';

  @override
  String get chat_noConversations => '会話がありません';

  @override
  String get chat_noConversationsDesc => '新しい会話を開始してアプリについてのAIインサイトを取得しましょう';

  @override
  String get chat_startConversation => '会話を開始';

  @override
  String get chat_deleteConversation => '会話を削除';

  @override
  String get chat_deleteConversationConfirm => 'この会話を削除してもよろしいですか？';

  @override
  String get chat_askAnything => '何でも聞いてください';

  @override
  String get chat_askAnythingDesc => 'アプリのレビュー、ランキング、分析について理解するお手伝いをします';

  @override
  String get chat_typeMessage => '質問を入力...';

  @override
  String get chat_suggestedQuestions => 'おすすめの質問';

  @override
  String get chatActionConfirm => '確認';

  @override
  String get chatActionCancel => 'キャンセル';

  @override
  String get chatActionExecuting => '実行中...';

  @override
  String get chatActionExecuted => '完了';

  @override
  String get chatActionFailed => '失敗';

  @override
  String get chatActionCancelled => 'キャンセル済み';

  @override
  String get chatActionDownload => 'ダウンロード';

  @override
  String get chatActionReversible => 'この操作は元に戻せます';

  @override
  String get chatActionAddKeywords => 'キーワードを追加';

  @override
  String get chatActionRemoveKeywords => 'キーワードを削除';

  @override
  String get chatActionCreateAlert => 'アラートを作成';

  @override
  String get chatActionAddCompetitor => '競合を追加';

  @override
  String get chatActionExportData => 'データをエクスポート';

  @override
  String get chatActionKeywords => 'キーワード';

  @override
  String get chatActionCountry => '国';

  @override
  String get chatActionAlertCondition => '条件';

  @override
  String get chatActionNotifyVia => '通知方法';

  @override
  String get chatActionCompetitor => '競合';

  @override
  String get chatActionExportType => 'エクスポート形式';

  @override
  String get chatActionDateRange => '期間';

  @override
  String get chatActionKeywordsLabel => 'キーワード';

  @override
  String get chatActionAnalyticsLabel => '統計';

  @override
  String get chatActionReviewsLabel => 'レビュー';

  @override
  String get common_cancel => 'キャンセル';

  @override
  String get common_delete => '削除';

  @override
  String get appDetail_tabOverview => '概要';

  @override
  String get appDetail_tabKeywords => 'キーワード';

  @override
  String get appDetail_tabReviews => 'レビュー';

  @override
  String get appDetail_tabRatings => '評価';

  @override
  String get appDetail_tabInsights => 'インサイト';

  @override
  String get dateRange_title => '期間';

  @override
  String get dateRange_today => '今日';

  @override
  String get dateRange_yesterday => '昨日';

  @override
  String get dateRange_last7Days => '過去7日間';

  @override
  String get dateRange_last30Days => '過去30日間';

  @override
  String get dateRange_thisMonth => '今月';

  @override
  String get dateRange_lastMonth => '先月';

  @override
  String get dateRange_last90Days => '過去90日間';

  @override
  String get dateRange_yearToDate => '年初から今日まで';

  @override
  String get dateRange_allTime => 'すべて';

  @override
  String get dateRange_custom => 'カスタム...';

  @override
  String get dateRange_compareToPrevious => '前の期間と比較';

  @override
  String get export_keywordsTitle => 'キーワードをエクスポート';

  @override
  String get export_reviewsTitle => 'レビューをエクスポート';

  @override
  String get export_analyticsTitle => '分析をエクスポート';

  @override
  String get export_columnsToInclude => '含める列:';

  @override
  String get export_button => 'エクスポート';

  @override
  String get export_keyword => 'キーワード';

  @override
  String get export_position => '順位';

  @override
  String get export_change => '変動';

  @override
  String get export_popularity => '人気度';

  @override
  String get export_difficulty => '難易度';

  @override
  String get export_tags => 'タグ';

  @override
  String get export_notes => 'メモ';

  @override
  String get export_trackedSince => '追跡開始日';

  @override
  String get export_date => '日付';

  @override
  String get export_rating => '評価';

  @override
  String get export_author => '著者';

  @override
  String get export_title => 'タイトル';

  @override
  String get export_content => '内容';

  @override
  String get export_country => '国';

  @override
  String get export_version => 'バージョン';

  @override
  String get export_sentiment => 'センチメント';

  @override
  String get export_response => '返信';

  @override
  String get export_responseDate => '返信日';

  @override
  String export_keywordsCount(int count) {
    return '$count個のキーワードがエクスポートされます';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count件のレビューがエクスポートされます';
  }

  @override
  String export_success(String filename) {
    return 'エクスポートを保存しました: $filename';
  }

  @override
  String export_error(String error) {
    return 'エクスポート失敗: $error';
  }

  @override
  String get metadata_editor => 'メタデータエディター';

  @override
  String get metadata_selectLocale => '編集するロケールを選択';

  @override
  String get metadata_refreshed => 'ストアからメタデータを更新しました';

  @override
  String get metadata_connectRequired => '編集するには接続が必要です';

  @override
  String get metadata_connectDescription =>
      'App Store Connectアカウントを接続して、Keyrankから直接アプリのメタデータを編集できます。';

  @override
  String get metadata_connectStore => 'App Storeに接続';

  @override
  String get metadata_publishTitle => 'メタデータを公開';

  @override
  String metadata_publishConfirm(String locale) {
    return '$localeの変更を公開しますか？これによりApp Storeのアプリ掲載情報が更新されます。';
  }

  @override
  String get metadata_publish => '公開';

  @override
  String get metadata_publishSuccess => 'メタデータを公開しました';

  @override
  String get metadata_saveDraft => '下書きを保存';

  @override
  String get metadata_draftSaved => '下書きを保存しました';

  @override
  String get metadata_discardChanges => '変更を破棄';

  @override
  String get metadata_title => 'タイトル';

  @override
  String metadata_titleHint(int limit) {
    return 'アプリ名（最大$limit文字）';
  }

  @override
  String get metadata_subtitle => 'サブタイトル';

  @override
  String metadata_subtitleHint(int limit) {
    return '短いキャッチフレーズ（最大$limit文字）';
  }

  @override
  String get metadata_keywords => 'キーワード';

  @override
  String metadata_keywordsHint(int limit) {
    return 'カンマ区切りのキーワード（最大$limit文字）';
  }

  @override
  String get metadata_description => '説明';

  @override
  String metadata_descriptionHint(int limit) {
    return 'アプリの詳細説明（最大$limit文字）';
  }

  @override
  String get metadata_promotionalText => 'プロモーションテキスト';

  @override
  String metadata_promotionalTextHint(int limit) {
    return '短いプロモーションメッセージ（最大$limit文字）';
  }

  @override
  String get metadata_whatsNew => '新機能';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'リリースノート（最大$limit文字）';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => '未保存の変更があります';

  @override
  String get metadata_noChanges => '変更なし';

  @override
  String get metadata_keywordAnalysis => 'キーワード分析';

  @override
  String get metadata_keywordPresent => 'あり';

  @override
  String get metadata_keywordMissing => 'なし';

  @override
  String get metadata_inTitle => 'タイトル内';

  @override
  String get metadata_inSubtitle => 'サブタイトル内';

  @override
  String get metadata_inKeywords => 'キーワード内';

  @override
  String get metadata_inDescription => '説明内';

  @override
  String get metadata_history => '変更履歴';

  @override
  String get metadata_noHistory => '変更履歴がありません';

  @override
  String get metadata_localeComplete => '完了';

  @override
  String get metadata_localeIncomplete => '未完了';

  @override
  String get metadata_shortDescription => '短い説明';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return '検索に表示されるキャッチフレーズ（最大$limit文字）';
  }

  @override
  String get metadata_fullDescription => '詳細説明';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'アプリの詳細説明（最大$limit文字）';
  }

  @override
  String get metadata_releaseNotes => 'リリースノート';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'このバージョンの新機能（最大$limit文字）';
  }

  @override
  String get metadata_selectAppFirst => 'アプリを選択してください';

  @override
  String get metadata_selectAppHint => 'サイドバーのアプリセレクターを使用するか、ストアを接続して開始してください。';

  @override
  String get metadata_noStoreConnection => 'ストア接続が必要です';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return '$storeNameアカウントを接続して、アプリのメタデータを取得・編集できます。';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return '$storeNameに接続';
  }

  @override
  String get metadataLocalization => 'ローカライゼーション';

  @override
  String get metadataLive => '公開中';

  @override
  String get metadataDraft => '下書き';

  @override
  String get metadataEmpty => '空';

  @override
  String metadataCoverageInsight(int count) {
    return '$count個のロケールにコンテンツが必要です。主要市場向けにローカライズを検討してください。';
  }

  @override
  String get metadataFilterAll => 'すべて';

  @override
  String get metadataFilterLive => '公開中';

  @override
  String get metadataFilterDraft => '下書き';

  @override
  String get metadataFilterEmpty => '空';

  @override
  String get metadataBulkActions => '一括操作';

  @override
  String get metadataCopyTo => '選択にコピー';

  @override
  String get metadataTranslateTo => '選択に翻訳';

  @override
  String get metadataPublishSelected => '選択を公開';

  @override
  String get metadataDeleteDrafts => '下書きを削除';

  @override
  String get metadataSelectSource => 'ソースロケールを選択';

  @override
  String get metadataSelectTarget => 'ターゲットロケールを選択';

  @override
  String metadataCopySuccess(int count) {
    return '$count個のロケールにコピーしました';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return '$count個のロケールに翻訳しました';
  }

  @override
  String get metadataTranslating => '翻訳中...';

  @override
  String get metadataNoSelection => 'まずロケールを選択してください';

  @override
  String get metadataSelectAll => 'すべて選択';

  @override
  String get metadataDeselectAll => 'すべて解除';

  @override
  String metadataSelected(int count) {
    return '$count個選択';
  }

  @override
  String get metadataTableView => 'テーブル表示';

  @override
  String get metadataListView => 'リスト表示';

  @override
  String get metadataStatus => 'ステータス';

  @override
  String get metadataCompletion => '完成度';

  @override
  String get common_back => '戻る';

  @override
  String get common_next => '次へ';

  @override
  String get common_edit => '編集';

  @override
  String get metadata_aiOptimize => 'AIで最適化';

  @override
  String get wizard_title => 'AI最適化ウィザード';

  @override
  String get wizard_step => 'ステップ';

  @override
  String get wizard_of => '/';

  @override
  String get wizard_stepTitle => 'タイトル';

  @override
  String get wizard_stepSubtitle => 'サブタイトル';

  @override
  String get wizard_stepKeywords => 'キーワード';

  @override
  String get wizard_stepDescription => '説明';

  @override
  String get wizard_stepReview => '確認して保存';

  @override
  String get wizard_skip => 'スキップ';

  @override
  String get wizard_saveDrafts => '下書きを保存';

  @override
  String get wizard_draftsSaved => '下書きを保存しました';

  @override
  String get wizard_exitTitle => 'ウィザードを終了しますか？';

  @override
  String get wizard_exitMessage => '未保存の変更があります。本当に終了しますか？';

  @override
  String get wizard_exitConfirm => '終了';

  @override
  String get wizard_aiSuggestions => 'AI提案';

  @override
  String get wizard_chooseSuggestion => 'AIが生成した提案を選択するか、自分で入力してください';

  @override
  String get wizard_currentValue => '現在の値';

  @override
  String get wizard_noCurrentValue => '値が設定されていません';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return '$keywordsCount個の追跡キーワードと$competitorsCount個の競合に基づく';
  }

  @override
  String get wizard_writeOwn => '自分で入力';

  @override
  String get wizard_customPlaceholder => 'カスタム値を入力...';

  @override
  String get wizard_useCustom => 'カスタムを使用';

  @override
  String get wizard_keepCurrent => '現在の値を維持';

  @override
  String get wizard_recommended => 'おすすめ';

  @override
  String get wizard_characters => '文字';

  @override
  String get wizard_reviewTitle => '変更を確認';

  @override
  String get wizard_reviewDescription => '下書きとして保存する前に最適化内容を確認してください';

  @override
  String get wizard_noChanges => '変更が選択されていません';

  @override
  String get wizard_noChangesHint => '戻って最適化するフィールドの提案を選択してください';

  @override
  String wizard_changesCount(int count) {
    return '$count個のフィールドを更新';
  }

  @override
  String get wizard_changesSummary => 'これらの変更は下書きとして保存されます';

  @override
  String get wizard_before => '変更前';

  @override
  String get wizard_after => '変更後';

  @override
  String get wizard_nextStepsTitle => '次のステップ';

  @override
  String get wizard_nextStepsWithChanges =>
      '変更は下書きとして保存されます。メタデータエディターで確認して公開できます。';

  @override
  String get wizard_nextStepsNoChanges =>
      '保存する変更がありません。戻って提案を選択し、メタデータを最適化してください。';

  @override
  String get team_title => 'チーム管理';

  @override
  String get team_createTeam => 'チームを作成';

  @override
  String get team_teamName => 'チーム名';

  @override
  String get team_teamNameHint => 'チーム名を入力';

  @override
  String get team_description => '説明（任意）';

  @override
  String get team_descriptionHint => 'このチームは何のためですか？';

  @override
  String get team_teamNameRequired => 'チーム名は必須です';

  @override
  String get team_teamNameMinLength => 'チーム名は2文字以上必要です';

  @override
  String get team_inviteMember => 'メンバーを招待';

  @override
  String get team_emailAddress => 'メールアドレス';

  @override
  String get team_emailHint => 'colleague@example.com';

  @override
  String get team_emailRequired => 'メールアドレスは必須です';

  @override
  String get team_emailInvalid => '有効なメールアドレスを入力してください';

  @override
  String team_invitationSent(String email) {
    return '$emailに招待を送信しました';
  }

  @override
  String get team_members => 'メンバー';

  @override
  String get team_invite => '招待';

  @override
  String get team_pendingInvitations => '保留中の招待';

  @override
  String get team_noPendingInvitations => '保留中の招待はありません';

  @override
  String get team_teamSettings => 'チーム設定';

  @override
  String team_changeRole(String name) {
    return '$nameの役割を変更';
  }

  @override
  String get team_removeMember => 'メンバーを削除';

  @override
  String team_removeMemberConfirm(String name) {
    return '$nameをこのチームから削除しますか？';
  }

  @override
  String get team_remove => '削除';

  @override
  String get team_leaveTeam => 'チームを退出';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return '「$teamName」を退出しますか？';
  }

  @override
  String get team_leave => '退出';

  @override
  String get team_deleteTeam => 'チームを削除';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return '「$teamName」を削除しますか？この操作は取り消せません。';
  }

  @override
  String get team_yourTeams => 'あなたのチーム';

  @override
  String get team_failedToLoadTeam => 'チームの読み込みに失敗しました';

  @override
  String get team_failedToLoadMembers => 'メンバーの読み込みに失敗しました';

  @override
  String get team_failedToLoadInvitations => '招待の読み込みに失敗しました';

  @override
  String team_memberCount(int count) {
    return '$count人のメンバー';
  }

  @override
  String team_invitedAs(String role) {
    return '$roleとして招待';
  }

  @override
  String team_joinedTeam(String teamName) {
    return '$teamNameに参加しました';
  }

  @override
  String get team_invitationDeclined => '招待を辞退しました';

  @override
  String get team_noTeamsYet => 'チームがありません';

  @override
  String get team_noTeamsDescription => 'チームを作成して他のメンバーと協力しましょう';

  @override
  String get team_createFirstTeam => '最初のチームを作成';

  @override
  String get integrations_title => '連携';

  @override
  String integrations_syncFailed(String error) {
    return '同期に失敗しました: $error';
  }

  @override
  String get integrations_disconnectConfirm => '接続を解除しますか？';

  @override
  String get integrations_disconnectedSuccess => '正常に接続解除されました';

  @override
  String get integrations_connectGooglePlay => 'Google Play Consoleに接続';

  @override
  String get integrations_connectAppStore => 'App Store Connectに接続';

  @override
  String integrations_connectedApps(int count) {
    return '接続完了！$count個のアプリをインポートしました。';
  }

  @override
  String integrations_syncedApps(int count) {
    return '$count個のアプリを所有者として同期しました';
  }

  @override
  String get integrations_appStoreConnected => 'App Store Connectに正常に接続しました！';

  @override
  String get integrations_googlePlayConnected =>
      'Google Play Consoleに正常に接続しました！';

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
  String get alertBuilder_nameYourRule => 'ルールに名前を付ける';

  @override
  String get alertBuilder_nameDescription => 'アラートルールにわかりやすい名前を付けてください';

  @override
  String get alertBuilder_nameHint => '例: 毎日の順位アラート';

  @override
  String get alertBuilder_summary => '概要';

  @override
  String get alertBuilder_saveAlertRule => 'アラートルールを保存';

  @override
  String get alertBuilder_selectAlertType => 'アラートタイプを選択';

  @override
  String get alertBuilder_selectAlertTypeDescription => '作成するアラートの種類を選択してください';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return '「$ruleName」が削除されます。';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate =>
      'ルールがまだありません。テンプレートを有効にするか、独自のルールを作成してください！';

  @override
  String get billing_cancelSubscription => 'サブスクリプションをキャンセル';

  @override
  String get billing_keepSubscription => 'サブスクリプションを維持';

  @override
  String get billing_billingPortal => '請求ポータル';

  @override
  String get billing_resume => '再開';

  @override
  String get keywords_noCompetitorsFound => '競合が見つかりません。先に競合を追加してください。';

  @override
  String get keywords_noCompetitorsForApp => 'このアプリに競合がありません。先に競合を追加してください。';

  @override
  String keywords_failedToAddKeywords(String error) {
    return 'キーワードの追加に失敗: $error';
  }

  @override
  String get keywords_bulkAddHint => '予算トラッカー\n支出管理\nマネーアプリ';

  @override
  String get appOverview_urlCopied => 'ストアURLをクリップボードにコピーしました';

  @override
  String get country_us => 'アメリカ合衆国';

  @override
  String get country_gb => 'イギリス';

  @override
  String get country_fr => 'フランス';

  @override
  String get country_de => 'ドイツ';

  @override
  String get country_ca => 'カナダ';

  @override
  String get country_au => 'オーストラリア';

  @override
  String get country_jp => '日本';

  @override
  String get country_cn => '中国';

  @override
  String get country_kr => '韓国';

  @override
  String get country_br => 'ブラジル';

  @override
  String get country_es => 'スペイン';

  @override
  String get country_it => 'イタリア';

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
  String get alertBuilder_type => 'タイプ';

  @override
  String get alertBuilder_scope => 'スコープ';

  @override
  String get alertBuilder_name => '名前';

  @override
  String get alertBuilder_scopeGlobal => '全てのアプリ';

  @override
  String get alertBuilder_scopeApp => '特定のアプリ';

  @override
  String get alertBuilder_scopeCategory => 'カテゴリ';

  @override
  String get alertBuilder_scopeKeyword => 'キーワード';

  @override
  String get alertType_positionChange => '順位変動';

  @override
  String get alertType_positionChangeDesc => 'アプリのランキングが大きく変動した時にアラート';

  @override
  String get alertType_ratingChange => '評価変動';

  @override
  String get alertType_ratingChangeDesc => 'アプリの評価が変動した時にアラート';

  @override
  String get alertType_reviewSpike => 'レビュー急増';

  @override
  String get alertType_reviewSpikeDesc => '異常なレビュー活動があった時にアラート';

  @override
  String get alertType_reviewKeyword => 'レビューキーワード';

  @override
  String get alertType_reviewKeywordDesc => 'レビューにキーワードが出現した時にアラート';

  @override
  String get alertType_newCompetitor => '新規競合';

  @override
  String get alertType_newCompetitorDesc => '新しいアプリが参入した時にアラート';

  @override
  String get alertType_competitorPassed => '競合を追い越し';

  @override
  String get alertType_competitorPassedDesc => '競合を追い越した時にアラート';

  @override
  String get alertType_massMovement => '大規模変動';

  @override
  String get alertType_massMovementDesc => 'ランキングの大規模な変動があった時にアラート';

  @override
  String get alertType_keywordTrend => 'キーワードトレンド';

  @override
  String get alertType_keywordTrendDesc => 'キーワードの人気度が変動した時にアラート';

  @override
  String get alertType_opportunity => '機会';

  @override
  String get alertType_opportunityDesc => '新しいランキング機会があった時にアラート';

  @override
  String get billing_title => '請求とプラン';

  @override
  String get billing_subscriptionActivated => 'サブスクリプションが正常に有効化されました！';

  @override
  String get billing_changePlan => 'プラン変更';

  @override
  String get billing_choosePlan => 'プランを選択';

  @override
  String get billing_cancelMessage =>
      'サブスクリプションは現在の請求期間の終了まで有効です。その後、プレミアム機能へのアクセスが失われます。';

  @override
  String get billing_currentPlan => '現在のプラン';

  @override
  String get billing_trial => 'トライアル';

  @override
  String get billing_canceling => 'キャンセル中';

  @override
  String billing_accessUntil(String date) {
    return '$dateまでアクセス可能';
  }

  @override
  String billing_renewsOn(String date) {
    return '$dateに更新';
  }

  @override
  String get billing_manageSubscription => 'サブスクリプション管理';

  @override
  String get billing_monthly => '月額';

  @override
  String get billing_yearly => '年額';

  @override
  String billing_savePercent(int percent) {
    return '$percent%お得';
  }

  @override
  String get billing_current => '現在';

  @override
  String get billing_apps => 'アプリ';

  @override
  String get billing_unlimited => '無制限';

  @override
  String get billing_keywordsPerApp => 'アプリあたりのキーワード';

  @override
  String get billing_history => '履歴';

  @override
  String billing_days(int count) {
    return '$count日間';
  }

  @override
  String get billing_exports => 'エクスポート';

  @override
  String get billing_aiInsights => 'AI分析';

  @override
  String get billing_apiAccess => 'APIアクセス';

  @override
  String get billing_yes => 'はい';

  @override
  String get billing_no => 'いいえ';

  @override
  String get billing_currentPlanButton => '現在のプラン';

  @override
  String billing_upgradeTo(String planName) {
    return '$planNameにアップグレード';
  }

  @override
  String get billing_cancel => 'キャンセル';

  @override
  String get keywords_compareWithCompetitor => '競合と比較';

  @override
  String get keywords_selectCompetitorToCompare => 'キーワードを比較する競合を選択:';

  @override
  String get keywords_addToCompetitor => '競合に追加';

  @override
  String keywords_addKeywordsTo(int count) {
    return '$count個のキーワードを追加:';
  }

  @override
  String get keywords_avgPosition => '平均順位';

  @override
  String get keywords_declined => '下降';

  @override
  String get keywords_total => '合計';

  @override
  String get keywords_ranked => 'ランク済み';

  @override
  String get keywords_improved => '上昇';

  @override
  String get onboarding_skip => 'スキップ';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_getStarted => '始める';

  @override
  String get onboarding_welcomeToKeyrank => 'Keyrankへようこそ';

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
  String get team_you => 'あなた';

  @override
  String get team_changeRoleButton => 'Change Role';

  @override
  String get team_removeButton => 'Remove';

  @override
  String get competitors_removeTitle => 'Remove Competitor';

  @override
  String competitors_removeConfirm(String name) {
    return '「$name」を競合から削除してもよろしいですか？';
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
    return '競合の追加に失敗: $error';
  }

  @override
  String get competitors_searchForCompetitor => 'Search for a competitor';

  @override
  String get appPreview_back => 'Back';

  @override
  String get alerts_edit => '編集';

  @override
  String get alerts_scopeGlobal => 'グローバル';

  @override
  String get alerts_scopeApp => 'アプリ';

  @override
  String get alerts_scopeCategory => 'カテゴリ';

  @override
  String get alerts_scopeKeyword => 'キーワード';

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
    return 'さらに$count件のインサイトを表示';
  }

  @override
  String get insights_noInsightsDesc => 'アプリの最適化機会を発見したときにインサイトが表示されます。';

  @override
  String get insights_loadFailed => 'インサイトの読み込みに失敗しました';

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
