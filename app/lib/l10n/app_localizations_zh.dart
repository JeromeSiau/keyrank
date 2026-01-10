// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTagline => '追踪您的 App Store 排名';

  @override
  String get auth_welcomeBack => '欢迎回来';

  @override
  String get auth_signInSubtitle => '登录您的账户';

  @override
  String get auth_createAccount => '创建账户';

  @override
  String get auth_createAccountSubtitle => '开始追踪您的排名';

  @override
  String get auth_emailLabel => '邮箱';

  @override
  String get auth_passwordLabel => '密码';

  @override
  String get auth_nameLabel => '姓名';

  @override
  String get auth_confirmPasswordLabel => '确认密码';

  @override
  String get auth_signInButton => '登录';

  @override
  String get auth_signUpButton => '创建账户';

  @override
  String get auth_noAccount => '还没有账户？';

  @override
  String get auth_hasAccount => '已有账户？';

  @override
  String get auth_signUpLink => '注册';

  @override
  String get auth_signInLink => '登录';

  @override
  String get auth_emailRequired => '请输入您的邮箱';

  @override
  String get auth_emailInvalid => '邮箱格式无效';

  @override
  String get auth_passwordRequired => '请输入您的密码';

  @override
  String get auth_enterPassword => '请输入密码';

  @override
  String get auth_nameRequired => '请输入您的姓名';

  @override
  String get auth_passwordMinLength => '密码至少需要8个字符';

  @override
  String get auth_passwordsNoMatch => '密码不匹配';

  @override
  String get auth_errorOccurred => '发生错误';

  @override
  String get common_retry => '重试';

  @override
  String common_error(String message) {
    return '错误：$message';
  }

  @override
  String get common_loading => '加载中...';

  @override
  String get common_add => '添加';

  @override
  String get common_filter => '筛选';

  @override
  String get common_sort => '排序';

  @override
  String get common_refresh => '刷新';

  @override
  String get common_settings => '设置';

  @override
  String get common_search => '搜索...';

  @override
  String get common_noResults => '无结果';

  @override
  String get dashboard_title => '仪表盘';

  @override
  String get dashboard_addApp => '添加应用';

  @override
  String get dashboard_appsTracked => '追踪的应用';

  @override
  String get dashboard_keywords => '关键词';

  @override
  String get dashboard_avgPosition => '平均排名';

  @override
  String get dashboard_top10 => '前10名';

  @override
  String get dashboard_trackedApps => '追踪的应用';

  @override
  String get dashboard_quickActions => '快捷操作';

  @override
  String get dashboard_addNewApp => '添加新应用';

  @override
  String get dashboard_searchKeywords => '搜索关键词';

  @override
  String get dashboard_viewAllApps => '查看所有应用';

  @override
  String get dashboard_noAppsYet => '暂无追踪的应用';

  @override
  String get dashboard_addAppToStart => '添加应用以开始追踪关键词';

  @override
  String get dashboard_noAppsMatchFilter => '没有符合筛选条件的应用';

  @override
  String get dashboard_changeFilterCriteria => '尝试更改筛选条件';

  @override
  String get apps_title => '我的应用';

  @override
  String apps_appCount(int count) {
    return '$count 个应用';
  }

  @override
  String get apps_tableApp => '应用';

  @override
  String get apps_tableDeveloper => '开发者';

  @override
  String get apps_tableKeywords => '关键词';

  @override
  String get apps_tablePlatform => '平台';

  @override
  String get apps_tableRating => '评分';

  @override
  String get apps_tableBestRank => '最佳排名';

  @override
  String get apps_noAppsYet => '暂无追踪的应用';

  @override
  String get apps_addAppToStart => '添加应用以开始追踪其排名';

  @override
  String get addApp_title => '添加应用';

  @override
  String get addApp_searchAppStore => '在 App Store 中搜索...';

  @override
  String get addApp_searchPlayStore => '在 Play Store 中搜索...';

  @override
  String get addApp_searchForApp => '搜索应用';

  @override
  String get addApp_enterAtLeast2Chars => '请输入至少2个字符';

  @override
  String get addApp_noResults => '未找到结果';

  @override
  String addApp_addedSuccess(String name) {
    return '$name 添加成功';
  }

  @override
  String get settings_title => '设置';

  @override
  String get settings_language => '语言';

  @override
  String get settings_appearance => '外观';

  @override
  String get settings_theme => '主题';

  @override
  String get settings_themeSystem => '跟随系统';

  @override
  String get settings_themeDark => '深色';

  @override
  String get settings_themeLight => '浅色';

  @override
  String get settings_account => '账户';

  @override
  String get settings_memberSince => '注册时间';

  @override
  String get settings_logout => '退出登录';

  @override
  String get settings_languageSystem => '跟随系统';

  @override
  String get filter_all => '全部';

  @override
  String get filter_allApps => '所有应用';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => '仅 iOS';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => '仅 Android';

  @override
  String get filter_favorites => '收藏';

  @override
  String get sort_recent => '最近';

  @override
  String get sort_recentlyAdded => '最近添加';

  @override
  String get sort_nameAZ => '名称 A-Z';

  @override
  String get sort_nameZA => '名称 Z-A';

  @override
  String get sort_keywords => '关键词';

  @override
  String get sort_mostKeywords => '最多关键词';

  @override
  String get sort_bestRank => '最佳排名';

  @override
  String get userMenu_logout => '退出登录';

  @override
  String get insights_compareTitle => '对比分析';

  @override
  String get insights_analyzingReviews => '正在分析评论...';

  @override
  String get insights_noInsightsAvailable => '暂无分析数据';

  @override
  String get insights_strengths => '优势';

  @override
  String get insights_weaknesses => '劣势';

  @override
  String get insights_scores => '评分';

  @override
  String get insights_opportunities => '机会';

  @override
  String get insights_categoryUx => '用户体验';

  @override
  String get insights_categoryPerf => '性能';

  @override
  String get insights_categoryFeatures => '功能';

  @override
  String get insights_categoryPricing => '定价';

  @override
  String get insights_categorySupport => '支持';

  @override
  String get insights_categoryOnboard => '引导';

  @override
  String get insights_categoryUxFull => '用户体验/界面';

  @override
  String get insights_categoryPerformance => '性能';

  @override
  String get insights_categoryOnboarding => '新手引导';

  @override
  String get insights_reviewInsights => '评论洞察';

  @override
  String get insights_generateFirst => '请先生成分析';

  @override
  String get insights_compareWithOther => '与其他应用对比';

  @override
  String get insights_compare => '对比';

  @override
  String get insights_generateAnalysis => '生成分析';

  @override
  String get insights_period => '时间范围：';

  @override
  String get insights_3months => '3个月';

  @override
  String get insights_6months => '6个月';

  @override
  String get insights_12months => '12个月';

  @override
  String get insights_analyze => '分析';

  @override
  String insights_reviewsCount(int count) {
    return '$count 条评论';
  }

  @override
  String insights_analyzedAgo(String time) {
    return '$time前分析';
  }

  @override
  String get insights_yourNotes => '您的笔记';

  @override
  String get insights_save => '保存';

  @override
  String get insights_clickToAddNotes => '点击添加笔记...';

  @override
  String get insights_noteSaved => '笔记已保存';

  @override
  String get insights_noteHint => '添加您对此分析的笔记...';

  @override
  String get insights_categoryScores => '分类评分';

  @override
  String get insights_emergentThemes => '热门主题';

  @override
  String get insights_exampleQuotes => '示例引用：';

  @override
  String get insights_selectCountryFirst => '请至少选择一个国家';

  @override
  String compare_selectAppsToCompare(String appName) {
    return '选择最多3个应用与 $appName 进行对比';
  }

  @override
  String get compare_searchApps => '搜索应用...';

  @override
  String get compare_noOtherApps => '没有其他应用可对比';

  @override
  String get compare_noMatchingApps => '没有匹配的应用';

  @override
  String compare_appsSelected(int count) {
    return '已选择 $count/3 个应用';
  }

  @override
  String get compare_cancel => '取消';

  @override
  String compare_button(int count) {
    return '对比 $count 个应用';
  }

  @override
  String get appDetail_deleteAppTitle => '删除应用？';

  @override
  String get appDetail_deleteAppConfirm => '此操作无法撤销。';

  @override
  String get appDetail_cancel => '取消';

  @override
  String get appDetail_delete => '删除';

  @override
  String get appDetail_exporting => '正在导出排名...';

  @override
  String appDetail_savedFile(String filename) {
    return '已保存：$filename';
  }

  @override
  String get appDetail_showInFinder => '在访达中显示';

  @override
  String appDetail_exportFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return '已导入 $imported 个关键词（跳过 $skipped 个）';
  }

  @override
  String get appDetail_favorite => '收藏';

  @override
  String get appDetail_ratings => '评分';

  @override
  String get appDetail_insights => '洞察';

  @override
  String get appDetail_import => '导入';

  @override
  String get appDetail_export => '导出';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count 条评论';
  }

  @override
  String get appDetail_keywords => '关键词';

  @override
  String get appDetail_addKeyword => '添加关键词';

  @override
  String get appDetail_keywordHint => '例如：健身追踪器';

  @override
  String get appDetail_trackedKeywords => '追踪的关键词';

  @override
  String appDetail_selectedCount(int count) {
    return '已选择 $count 个';
  }

  @override
  String get appDetail_allKeywords => '所有关键词';

  @override
  String get appDetail_hasTags => '有标签';

  @override
  String get appDetail_hasNotes => '有笔记';

  @override
  String get appDetail_position => '排名';

  @override
  String get appDetail_select => '选择';

  @override
  String get appDetail_suggestions => '建议';

  @override
  String get appDetail_deleteKeywordsTitle => '删除关键词';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return '确定要删除 $count 个关键词吗？';
  }

  @override
  String get appDetail_tag => '标签';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return '已添加关键词 \"$keyword\"（$flag）';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return '已为 $count 个关键词添加标签';
  }

  @override
  String get appDetail_keywordsAddedSuccess => '关键词添加成功';

  @override
  String get appDetail_noTagsAvailable => '暂无可用标签，请先创建标签。';

  @override
  String get appDetail_tagged => '已标记';

  @override
  String get appDetail_withNotes => '有笔记';

  @override
  String get appDetail_nameAZ => '名称 A-Z';

  @override
  String get appDetail_nameZA => '名称 Z-A';

  @override
  String get appDetail_bestPosition => '最佳排名';

  @override
  String get appDetail_recentlyTracked => '最近追踪';

  @override
  String get keywordSuggestions_title => '关键词建议';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$appName（$country）';
  }

  @override
  String get keywordSuggestions_refresh => '刷新建议';

  @override
  String get keywordSuggestions_search => '搜索建议...';

  @override
  String get keywordSuggestions_selectAll => '全选';

  @override
  String get keywordSuggestions_clear => '清除';

  @override
  String get keywordSuggestions_analyzing => '正在分析应用元数据...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds => '这可能需要几秒钟';

  @override
  String get keywordSuggestions_noSuggestions => '暂无建议';

  @override
  String get keywordSuggestions_noMatchingSuggestions => '没有匹配的建议';

  @override
  String get keywordSuggestions_headerKeyword => '关键词';

  @override
  String get keywordSuggestions_headerDifficulty => '难度';

  @override
  String get keywordSuggestions_headerApps => '应用数';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return '排名第 $position';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '已选择 $count 个关键词';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return '添加 $count 个关键词';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return '添加关键词时出错：$error';
  }

  @override
  String get sidebar_favorites => '收藏';

  @override
  String get sidebar_tooManyFavorites => '建议保留5个或更少的收藏';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => '关键词研究';

  @override
  String get keywordSearch_searchPlaceholder => '搜索关键词...';

  @override
  String get keywordSearch_searchTitle => '搜索关键词';

  @override
  String get keywordSearch_searchSubtitle => '发现哪些应用在特定关键词上排名';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count 个应用上榜';
  }

  @override
  String get keywordSearch_popularity => '热度';

  @override
  String keywordSearch_results(int count) {
    return '$count 个结果';
  }

  @override
  String get keywordSearch_headerRank => '排名';

  @override
  String get keywordSearch_headerApp => '应用';

  @override
  String get keywordSearch_headerRating => '评分';

  @override
  String get keywordSearch_headerTrack => '追踪';

  @override
  String get keywordSearch_trackApp => '追踪此应用';

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
    return '$appName 的评论';
  }

  @override
  String get reviews_loading => '正在加载评论...';

  @override
  String get reviews_noReviews => '暂无评论';

  @override
  String reviews_noReviewsFor(String countryName) {
    return '未找到 $countryName 的评论';
  }

  @override
  String reviews_showingRecent(int count) {
    return '显示 App Store 最近的 $count 条评论。';
  }

  @override
  String get reviews_today => '今天';

  @override
  String get reviews_yesterday => '昨天';

  @override
  String reviews_daysAgo(int count) {
    return '$count 天前';
  }

  @override
  String reviews_weeksAgo(int count) {
    return '$count 周前';
  }

  @override
  String reviews_monthsAgo(int count) {
    return '$count 个月前';
  }

  @override
  String get ratings_byCountry => '各国评分';

  @override
  String get ratings_noRatingsAvailable => '暂无评分数据';

  @override
  String get ratings_noRatingsYet => '此应用暂无评分';

  @override
  String get ratings_totalRatings => '总评分数';

  @override
  String get ratings_averageRating => '平均评分';

  @override
  String ratings_countriesCount(int count) {
    return '$count 个国家';
  }

  @override
  String ratings_updated(String date) {
    return '更新时间：$date';
  }

  @override
  String get ratings_headerCountry => '国家';

  @override
  String get ratings_headerRatings => '评分数';

  @override
  String get ratings_headerAverage => '平均分';

  @override
  String time_minutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String time_hoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String time_daysAgo(int count) {
    return '$count天前';
  }

  @override
  String get appDetail_noKeywordsTracked => '暂无追踪的关键词';

  @override
  String get appDetail_addKeywordHint => '在上方添加关键词以开始追踪';

  @override
  String get appDetail_noKeywordsMatchFilter => '没有符合筛选条件的关键词';

  @override
  String get appDetail_tryChangingFilter => '尝试更改筛选条件';

  @override
  String get appDetail_addTag => '添加标签';

  @override
  String get appDetail_addNote => '添加笔记';

  @override
  String get appDetail_positionHistory => '排名历史';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => '概览';

  @override
  String get nav_dashboard => '仪表盘';

  @override
  String get nav_myApps => '我的应用';

  @override
  String get nav_research => '研究';

  @override
  String get nav_keywords => '关键词';

  @override
  String get nav_discover => '发现';

  @override
  String get nav_notifications => '通知';

  @override
  String get common_save => '保存';

  @override
  String get appDetail_manageTags => '管理标签';

  @override
  String get appDetail_newTagHint => '新标签名称...';

  @override
  String get appDetail_availableTags => '可用标签';

  @override
  String get appDetail_noTagsYet => '还没有标签。在上方创建一个。';

  @override
  String get appDetail_addTagsTitle => '添加标签';

  @override
  String get appDetail_selectTagsDescription => '选择要添加到所选关键词的标签：';

  @override
  String appDetail_addTagsCount(int count) {
    return '添加 $count 个标签';
  }

  @override
  String appDetail_importFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get appDetail_importKeywordsTitle => '导入关键词';

  @override
  String get appDetail_pasteKeywordsHint => '在下方粘贴关键词，每行一个：';

  @override
  String get appDetail_keywordPlaceholder => '关键词一\n关键词二\n关键词三';

  @override
  String get appDetail_storefront => '商店：';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count 个关键词';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return '导入 $count 个关键词';
  }

  @override
  String get appDetail_period7d => '7天';

  @override
  String get appDetail_period30d => '30天';

  @override
  String get appDetail_period90d => '90天';

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
}
