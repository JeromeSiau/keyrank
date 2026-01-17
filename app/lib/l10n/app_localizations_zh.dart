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
  String get dashboard_reviews => '评论';

  @override
  String get dashboard_avgRating => '平均评分';

  @override
  String get dashboard_topPerformingApps => '表现最佳的应用';

  @override
  String get dashboard_topCountries => '主要国家';

  @override
  String get dashboard_sentimentOverview => '情感概览';

  @override
  String get dashboard_overallSentiment => '整体情感';

  @override
  String get dashboard_positive => '正面';

  @override
  String get dashboard_positiveReviews => '正面';

  @override
  String get dashboard_negativeReviews => '负面';

  @override
  String get dashboard_viewReviews => '查看评论';

  @override
  String get dashboard_tableApp => '应用';

  @override
  String get dashboard_tableKeywords => '关键词';

  @override
  String get dashboard_tableAvgRank => '平均排名';

  @override
  String get dashboard_tableTrend => '趋势';

  @override
  String get dashboard_connectYourStores => '连接您的商店';

  @override
  String get dashboard_connectStoresDescription =>
      '连接 App Store Connect 或 Google Play 以导入您的应用并回复评论。';

  @override
  String get dashboard_connect => '连接';

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
  String get insights_title => '分析';

  @override
  String insights_titleWithApp(String appName) {
    return '分析 - $appName';
  }

  @override
  String get insights_allApps => '分析（所有应用）';

  @override
  String get insights_noInsightsYet => '暂无洞察';

  @override
  String get insights_selectAppToGenerate => '选择一个应用以从评论生成分析';

  @override
  String insights_appsWithInsights(int count) {
    return '$count 个应用有分析';
  }

  @override
  String get insights_errorLoading => '加载分析时出错';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '已分析 $count 条评论';
  }

  @override
  String get insights_avgScore => '平均得分';

  @override
  String insights_updatedOn(String date) {
    return '更新于 $date';
  }

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
    return '已添加关键词「$keyword」（$flag）';
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
  String get keywordSuggestions_categoryAll => '全部';

  @override
  String get keywordSuggestions_categoryHighOpportunity => '机会';

  @override
  String get keywordSuggestions_categoryCompetitor => '竞争对手关键词';

  @override
  String get keywordSuggestions_categoryLongTail => '长尾词';

  @override
  String get keywordSuggestions_categoryTrending => '趋势';

  @override
  String get keywordSuggestions_categoryRelated => '相关';

  @override
  String get keywordSuggestions_generating => '正在生成建议...';

  @override
  String get keywordSuggestions_generatingSubtitle => '这可能需要几分钟。稍后再来查看。';

  @override
  String get keywordSuggestions_checkAgain => '再次检查';

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
  String get discover_title => '发现';

  @override
  String get discover_tabKeywords => '关键词';

  @override
  String get discover_tabCategories => '分类';

  @override
  String get discover_selectCategory => '选择分类';

  @override
  String get discover_topFree => '免费';

  @override
  String get discover_topPaid => '付费';

  @override
  String get discover_topGrossing => '畅销';

  @override
  String get discover_noResults => '无结果';

  @override
  String get discover_loadingTopApps => '正在加载热门应用...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return '$category 热门$collection应用';
  }

  @override
  String discover_appsCount(int count) {
    return '$count 个应用';
  }

  @override
  String get discover_allCategories => '所有分类';

  @override
  String get category_games => '游戏';

  @override
  String get category_business => '商务';

  @override
  String get category_education => '教育';

  @override
  String get category_entertainment => '娱乐';

  @override
  String get category_finance => '财务';

  @override
  String get category_food_drink => '美食佳饮';

  @override
  String get category_health_fitness => '健康健美';

  @override
  String get category_lifestyle => '生活';

  @override
  String get category_medical => '医疗';

  @override
  String get category_music => '音乐';

  @override
  String get category_navigation => '导航';

  @override
  String get category_news => '新闻';

  @override
  String get category_photo_video => '摄影与录像';

  @override
  String get category_productivity => '效率';

  @override
  String get category_reference => '参考资料';

  @override
  String get category_shopping => '购物';

  @override
  String get category_social => '社交';

  @override
  String get category_sports => '体育';

  @override
  String get category_travel => '旅游';

  @override
  String get category_utilities => '工具';

  @override
  String get category_weather => '天气';

  @override
  String get category_books => '图书';

  @override
  String get category_developer_tools => '开发工具';

  @override
  String get category_graphics_design => '图形和设计';

  @override
  String get category_magazines => '杂志和报纸';

  @override
  String get category_stickers => '贴纸';

  @override
  String get category_catalogs => '目录';

  @override
  String get category_art_design => '艺术与设计';

  @override
  String get category_auto_vehicles => '汽车与车辆';

  @override
  String get category_beauty => '美妆';

  @override
  String get category_comics => '漫画';

  @override
  String get category_communication => '通讯';

  @override
  String get category_dating => '约会交友';

  @override
  String get category_events => '活动';

  @override
  String get category_house_home => '家居';

  @override
  String get category_libraries => '图书馆';

  @override
  String get category_maps_navigation => '地图和导航';

  @override
  String get category_music_audio => '音乐与音频';

  @override
  String get category_news_magazines => '新闻和杂志';

  @override
  String get category_parenting => '育儿';

  @override
  String get category_personalization => '个性化';

  @override
  String get category_photography => '摄影';

  @override
  String get category_tools => '工具';

  @override
  String get category_video_players => '视频播放器';

  @override
  String get category_all_apps => '所有应用';

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
  String get appDetail_store => '商店';

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
  String get nav_engagement => '互动';

  @override
  String get nav_reviewsInbox => '收件箱';

  @override
  String get nav_notifications => '通知';

  @override
  String get nav_optimization => '优化';

  @override
  String get nav_keywordInspector => '关键词检查器';

  @override
  String get nav_ratingsAnalysis => '评分分析';

  @override
  String get nav_intelligence => '智能分析';

  @override
  String get nav_topCharts => '排行榜';

  @override
  String get nav_competitors => '竞争对手';

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
  String get appDetail_currentTags => '当前标签';

  @override
  String get appDetail_noTagsOnKeyword => '此关键词没有标签';

  @override
  String get appDetail_addExistingTag => '添加现有标签';

  @override
  String get appDetail_allTagsUsed => '所有标签均已使用';

  @override
  String get appDetail_createNewTag => '创建新标签';

  @override
  String get appDetail_tagNameHint => '标签名称...';

  @override
  String get appDetail_note => '笔记';

  @override
  String get appDetail_noteHint => '添加关于此关键词的笔记...';

  @override
  String get appDetail_saveNote => '保存笔记';

  @override
  String get appDetail_done => '完成';

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
  String get keywords_difficultyFilter => '难度：';

  @override
  String get keywords_difficultyAll => '全部';

  @override
  String get keywords_difficultyEasy => '简单 < 40';

  @override
  String get keywords_difficultyMedium => '中等 40-70';

  @override
  String get keywords_difficultyHard => '困难 > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => '应用详情';

  @override
  String get appPreview_notFound => '未找到应用';

  @override
  String get appPreview_screenshots => '截图';

  @override
  String get appPreview_description => '描述';

  @override
  String get appPreview_details => '详情';

  @override
  String get appPreview_version => '版本';

  @override
  String get appPreview_updated => '更新时间';

  @override
  String get appPreview_released => '发布日期';

  @override
  String get appPreview_size => '大小';

  @override
  String get appPreview_minimumOs => '系统要求';

  @override
  String get appPreview_price => '价格';

  @override
  String get appPreview_free => '免费';

  @override
  String get appPreview_openInStore => '在商店中打开';

  @override
  String get appPreview_addToMyApps => '添加到我的应用';

  @override
  String get appPreview_added => '已添加';

  @override
  String get appPreview_showMore => '显示更多';

  @override
  String get appPreview_showLess => '收起';

  @override
  String get appPreview_keywordsPlaceholder => '将此应用添加到追踪列表以启用关键词追踪';

  @override
  String get notifications_title => '通知';

  @override
  String get notifications_markAllRead => '全部标为已读';

  @override
  String get notifications_empty => '暂无通知';

  @override
  String get alerts_title => '警报规则';

  @override
  String get alerts_templatesTitle => '快速模板';

  @override
  String get alerts_templatesSubtitle => '一键激活常用警报';

  @override
  String get alerts_myRulesTitle => '我的规则';

  @override
  String get alerts_createRule => '创建规则';

  @override
  String get alerts_editRule => '编辑规则';

  @override
  String get alerts_noRulesYet => '暂无规则';

  @override
  String get alerts_deleteConfirm => '删除规则？';

  @override
  String get alerts_createCustomRule => '创建自定义规则';

  @override
  String alerts_ruleActivated(String name) {
    return '$name 已激活！';
  }

  @override
  String alerts_deleteMessage(String name) {
    return '这将删除 \"$name\"。';
  }

  @override
  String get alerts_noRulesDescription => '激活模板或创建您自己的规则！';

  @override
  String get alerts_create => '创建';

  @override
  String get settings_notifications => '通知';

  @override
  String get settings_manageAlerts => '管理警报规则';

  @override
  String get settings_manageAlertsDesc => '配置您收到的警报';

  @override
  String get settings_storeConnections => '商店连接';

  @override
  String get settings_storeConnectionsDesc => '连接您的 App Store 和 Google Play 账户';

  @override
  String get settings_alertDelivery => '警报推送';

  @override
  String get settings_team => '团队';

  @override
  String get settings_teamManagement => '团队管理';

  @override
  String get settings_teamManagementDesc =>
      'Invite members, manage roles & permissions';

  @override
  String get settings_integrations => '集成';

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
  String get storeConnections_title => '商店连接';

  @override
  String get storeConnections_description =>
      '连接您的 App Store 和 Google Play 账户以启用高级功能，如销售数据和应用分析。';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc => '连接您的 Apple 开发者账户';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc => '连接您的 Google Play 账户';

  @override
  String get storeConnections_connect => '连接';

  @override
  String get storeConnections_disconnect => '断开连接';

  @override
  String get storeConnections_connected => '已连接';

  @override
  String get storeConnections_disconnectConfirm => '断开连接？';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return '确定要断开此 $platform 账户的连接吗？';
  }

  @override
  String get storeConnections_disconnectSuccess => '已成功断开连接';

  @override
  String storeConnections_lastSynced(String date) {
    return '上次同步：$date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return '连接于 $date';
  }

  @override
  String get storeConnections_syncApps => '同步应用';

  @override
  String get storeConnections_syncing => '同步中...';

  @override
  String get storeConnections_syncDescription => '同步将把此账户的应用标记为已拥有，从而可以回复评论。';

  @override
  String storeConnections_syncedApps(int count) {
    return '已同步 $count 个应用为已拥有';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return '同步失败：$error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return '加载连接时出错：$error';
  }

  @override
  String get reviewsInbox_title => '收件箱';

  @override
  String get reviewsInbox_filterUnanswered => '未回复';

  @override
  String get reviewsInbox_filterNegative => '负面';

  @override
  String get reviewsInbox_noReviews => '未找到评论';

  @override
  String get reviewsInbox_noReviewsDesc => '尝试调整您的筛选条件';

  @override
  String get reviewsInbox_reply => '回复';

  @override
  String get reviewsInbox_responded => '已回复';

  @override
  String reviewsInbox_respondedAt(String date) {
    return '回复于 $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => '回复评论';

  @override
  String get reviewsInbox_generateAi => '生成 AI 建议';

  @override
  String get reviewsInbox_generating => '生成中...';

  @override
  String get reviewsInbox_sendReply => '发送回复';

  @override
  String get reviewsInbox_sending => '发送中...';

  @override
  String get reviewsInbox_replyPlaceholder => '撰写您的回复...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 字符';
  }

  @override
  String get reviewsInbox_replySent => '回复发送成功';

  @override
  String reviewsInbox_replyError(String error) {
    return '发送回复失败：$error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return '生成建议失败：$error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count 星';
  }

  @override
  String get reviewsInbox_totalReviews => '评论总数';

  @override
  String get reviewsInbox_unanswered => '未回复';

  @override
  String get reviewsInbox_positive => '正面';

  @override
  String get reviewsInbox_avgRating => '平均评分';

  @override
  String get reviewsInbox_sentimentOverview => '情感概览';

  @override
  String get reviewsInbox_aiSuggestions => 'AI 建议';

  @override
  String get reviewsInbox_regenerate => '重新生成';

  @override
  String get reviewsInbox_toneProfessional => '专业';

  @override
  String get reviewsInbox_toneEmpathetic => '同理心';

  @override
  String get reviewsInbox_toneBrief => '简洁';

  @override
  String get reviewsInbox_selectTone => '选择语气：';

  @override
  String get reviewsInbox_detectedIssues => '检测到的问题：';

  @override
  String get reviewsInbox_aiPrompt => '点击「生成 AI 建议」以获取3种不同语气的回复建议';

  @override
  String get reviewIntelligence_title => '评论智能';

  @override
  String get reviewIntelligence_featureRequests => '功能请求';

  @override
  String get reviewIntelligence_bugReports => '问题报告';

  @override
  String get reviewIntelligence_sentimentByVersion => '各版本情感';

  @override
  String get reviewIntelligence_openFeatures => '待处理功能';

  @override
  String get reviewIntelligence_openBugs => '待处理问题';

  @override
  String get reviewIntelligence_highPriority => '高优先级';

  @override
  String get reviewIntelligence_total => '总计';

  @override
  String get reviewIntelligence_mentions => '提及';

  @override
  String get reviewIntelligence_noData => '暂无洞察';

  @override
  String get reviewIntelligence_noDataHint => '分析评论后将显示洞察';

  @override
  String get analytics_title => '分析';

  @override
  String get analytics_downloads => '下载';

  @override
  String get analytics_revenue => '收入';

  @override
  String get analytics_proceeds => '收益';

  @override
  String get analytics_subscribers => '订阅者';

  @override
  String get analytics_downloadsOverTime => '下载趋势';

  @override
  String get analytics_revenueOverTime => '收入趋势';

  @override
  String get analytics_byCountry => '按国家';

  @override
  String get analytics_noData => '无可用数据';

  @override
  String get analytics_noDataTitle => '无分析数据';

  @override
  String get analytics_noDataDescription =>
      '连接您的 App Store Connect 或 Google Play 账户以查看真实的销售和下载数据。';

  @override
  String analytics_dataDelay(String date) {
    return '数据截至 $date。Apple 数据有 24-48 小时延迟。';
  }

  @override
  String get analytics_export => '导出 CSV';

  @override
  String get funnel_title => '转化漏斗';

  @override
  String get funnel_impressions => '展示次数';

  @override
  String get funnel_pageViews => '页面浏览';

  @override
  String get funnel_downloads => '下载';

  @override
  String get funnel_overallCvr => '整体转化率';

  @override
  String get funnel_categoryAvg => '分类平均';

  @override
  String get funnel_vsCategory => '对比分类';

  @override
  String get funnel_bySource => '按来源';

  @override
  String get funnel_noData => '无漏斗数据';

  @override
  String get funnel_noDataHint =>
      '漏斗数据将从 App Store Connect 或 Google Play Console 自动同步。';

  @override
  String get funnel_insight => '洞察';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return '$bestSource 流量的转化率是 $worstSource 的 $ratio 倍。$recommendation';
  }

  @override
  String get funnel_insightRecommendSearch => '专注于关键词优化以增加搜索展示。';

  @override
  String get funnel_insightRecommendBrowse => '通过优化分类和推荐位置提高应用在浏览中的可见度。';

  @override
  String get funnel_insightRecommendReferral => '利用推荐计划和合作伙伴关系带来更多流量。';

  @override
  String get funnel_insightRecommendAppReferrer => '考虑与互补应用进行交叉推广策略。';

  @override
  String get funnel_insightRecommendWebReferrer => '优化您的网站和落地页以促进下载。';

  @override
  String get funnel_insightRecommendDefault => '分析此来源表现良好的原因并加以复制。';

  @override
  String get funnel_trendTitle => '转化率趋势';

  @override
  String get funnel_connectStore => '连接商店';

  @override
  String get nav_chat => 'AI 助手';

  @override
  String get chat_title => 'AI 助手';

  @override
  String get chat_newConversation => '新对话';

  @override
  String get chat_loadingConversations => '正在加载对话...';

  @override
  String get chat_loadingMessages => '正在加载消息...';

  @override
  String get chat_noConversations => '暂无对话';

  @override
  String get chat_noConversationsDesc => '开始新对话以获取关于您应用的 AI 洞察';

  @override
  String get chat_startConversation => '开始对话';

  @override
  String get chat_deleteConversation => '删除对话';

  @override
  String get chat_deleteConversationConfirm => '确定要删除此对话吗？';

  @override
  String get chat_askAnything => '向我提问';

  @override
  String get chat_askAnythingDesc => '我可以帮助您了解应用的评论、排名和分析';

  @override
  String get chat_typeMessage => '输入您的问题...';

  @override
  String get chat_suggestedQuestions => '推荐问题';

  @override
  String get chatActionConfirm => '确认';

  @override
  String get chatActionCancel => '取消';

  @override
  String get chatActionExecuting => '执行中...';

  @override
  String get chatActionExecuted => '已完成';

  @override
  String get chatActionFailed => '失败';

  @override
  String get chatActionCancelled => '已取消';

  @override
  String get chatActionDownload => '下载';

  @override
  String get chatActionReversible => '此操作可以撤销';

  @override
  String get chatActionAddKeywords => '添加关键词';

  @override
  String get chatActionRemoveKeywords => '移除关键词';

  @override
  String get chatActionCreateAlert => '创建警报';

  @override
  String get chatActionAddCompetitor => '添加竞争对手';

  @override
  String get chatActionExportData => '导出数据';

  @override
  String get chatActionKeywords => '关键词';

  @override
  String get chatActionCountry => '国家';

  @override
  String get chatActionAlertCondition => '条件';

  @override
  String get chatActionNotifyVia => '通知方式';

  @override
  String get chatActionCompetitor => '竞争对手';

  @override
  String get chatActionExportType => '导出类型';

  @override
  String get chatActionDateRange => '日期范围';

  @override
  String get chatActionKeywordsLabel => '关键词';

  @override
  String get chatActionAnalyticsLabel => '分析数据';

  @override
  String get chatActionReviewsLabel => '评论';

  @override
  String get common_cancel => '取消';

  @override
  String get common_delete => '删除';

  @override
  String get appDetail_tabOverview => '概览';

  @override
  String get appDetail_tabKeywords => '关键词';

  @override
  String get appDetail_tabReviews => '评论';

  @override
  String get appDetail_tabRatings => '评分';

  @override
  String get appDetail_tabInsights => '分析';

  @override
  String get dateRange_title => '日期范围';

  @override
  String get dateRange_today => '今天';

  @override
  String get dateRange_yesterday => '昨天';

  @override
  String get dateRange_last7Days => '最近7天';

  @override
  String get dateRange_last30Days => '最近30天';

  @override
  String get dateRange_thisMonth => '本月';

  @override
  String get dateRange_lastMonth => '上月';

  @override
  String get dateRange_last90Days => '最近90天';

  @override
  String get dateRange_yearToDate => '年初至今';

  @override
  String get dateRange_allTime => '全部';

  @override
  String get dateRange_custom => '自定义...';

  @override
  String get dateRange_compareToPrevious => '与上一周期对比';

  @override
  String get export_keywordsTitle => '导出关键词';

  @override
  String get export_reviewsTitle => '导出评论';

  @override
  String get export_analyticsTitle => '导出分析数据';

  @override
  String get export_columnsToInclude => '包含的列：';

  @override
  String get export_button => '导出';

  @override
  String get export_keyword => '关键词';

  @override
  String get export_position => '排名';

  @override
  String get export_change => '变化';

  @override
  String get export_popularity => '热度';

  @override
  String get export_difficulty => '难度';

  @override
  String get export_tags => '标签';

  @override
  String get export_notes => '笔记';

  @override
  String get export_trackedSince => '追踪时间';

  @override
  String get export_date => '日期';

  @override
  String get export_rating => '评分';

  @override
  String get export_author => '作者';

  @override
  String get export_title => '标题';

  @override
  String get export_content => '内容';

  @override
  String get export_country => '国家';

  @override
  String get export_version => '版本';

  @override
  String get export_sentiment => '情感';

  @override
  String get export_response => '我们的回复';

  @override
  String get export_responseDate => '回复日期';

  @override
  String export_keywordsCount(int count) {
    return '将导出 $count 个关键词';
  }

  @override
  String export_reviewsCount(int count) {
    return '将导出 $count 条评论';
  }

  @override
  String export_success(String filename) {
    return '导出已保存：$filename';
  }

  @override
  String export_error(String error) {
    return '导出失败：$error';
  }

  @override
  String get metadata_editor => '元数据编辑器';

  @override
  String get metadata_selectLocale => '选择要编辑的语言';

  @override
  String get metadata_refreshed => '元数据已从商店刷新';

  @override
  String get metadata_connectRequired => '需要连接才能编辑';

  @override
  String get metadata_connectDescription =>
      '连接您的 App Store Connect 账户以直接从 Keyrank 编辑应用元数据。';

  @override
  String get metadata_connectStore => '连接 App Store';

  @override
  String get metadata_publishTitle => '发布元数据';

  @override
  String metadata_publishConfirm(String locale) {
    return '发布 $locale 的更改？这将更新您在 App Store 上的应用列表。';
  }

  @override
  String get metadata_publish => '发布';

  @override
  String get metadata_publishSuccess => '元数据发布成功';

  @override
  String get metadata_saveDraft => '保存草稿';

  @override
  String get metadata_draftSaved => '草稿已保存';

  @override
  String get metadata_discardChanges => '放弃更改';

  @override
  String get metadata_title => '标题';

  @override
  String metadata_titleHint(int limit) {
    return '应用名称（最多 $limit 字符）';
  }

  @override
  String get metadata_subtitle => '副标题';

  @override
  String metadata_subtitleHint(int limit) {
    return '简短标语（最多 $limit 字符）';
  }

  @override
  String get metadata_keywords => '关键词';

  @override
  String metadata_keywordsHint(int limit) {
    return '用逗号分隔的关键词（最多 $limit 字符）';
  }

  @override
  String get metadata_description => '描述';

  @override
  String metadata_descriptionHint(int limit) {
    return '应用完整描述（最多 $limit 字符）';
  }

  @override
  String get metadata_promotionalText => '推广文案';

  @override
  String metadata_promotionalTextHint(int limit) {
    return '简短推广信息（最多 $limit 字符）';
  }

  @override
  String get metadata_whatsNew => '新功能';

  @override
  String metadata_whatsNewHint(int limit) {
    return '版本说明（最多 $limit 字符）';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => '有未保存的更改';

  @override
  String get metadata_noChanges => '无更改';

  @override
  String get metadata_keywordAnalysis => '关键词分析';

  @override
  String get metadata_keywordPresent => '存在';

  @override
  String get metadata_keywordMissing => '缺失';

  @override
  String get metadata_inTitle => '在标题中';

  @override
  String get metadata_inSubtitle => '在副标题中';

  @override
  String get metadata_inKeywords => '在关键词中';

  @override
  String get metadata_inDescription => '在描述中';

  @override
  String get metadata_history => '修改历史';

  @override
  String get metadata_noHistory => '无修改记录';

  @override
  String get metadata_localeComplete => '完整';

  @override
  String get metadata_localeIncomplete => '不完整';

  @override
  String get metadata_shortDescription => '简短描述';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return '搜索中显示的标语（最多 $limit 字符）';
  }

  @override
  String get metadata_fullDescription => '完整描述';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return '应用完整描述（最多 $limit 字符）';
  }

  @override
  String get metadata_releaseNotes => '版本说明';

  @override
  String metadata_releaseNotesHint(int limit) {
    return '此版本的新功能（最多 $limit 字符）';
  }

  @override
  String get metadata_selectAppFirst => '请选择应用';

  @override
  String get metadata_selectAppHint => '使用侧边栏中的应用选择器或连接商店以开始。';

  @override
  String get metadata_noStoreConnection => '需要商店连接';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return '连接您的 $storeName 账户以获取和编辑应用元数据。';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return '连接 $storeName';
  }

  @override
  String get metadataLocalization => '本地化';

  @override
  String get metadataLive => '已上线';

  @override
  String get metadataDraft => '草稿';

  @override
  String get metadataEmpty => '空';

  @override
  String metadataCoverageInsight(int count) {
    return '$count 个语言需要内容。考虑为您的主要市场进行本地化。';
  }

  @override
  String get metadataFilterAll => '全部';

  @override
  String get metadataFilterLive => '已上线';

  @override
  String get metadataFilterDraft => '草稿';

  @override
  String get metadataFilterEmpty => '空';

  @override
  String get metadataBulkActions => '批量操作';

  @override
  String get metadataCopyTo => '复制到所选';

  @override
  String get metadataTranslateTo => '翻译到所选';

  @override
  String get metadataPublishSelected => '发布所选';

  @override
  String get metadataDeleteDrafts => '删除草稿';

  @override
  String get metadataSelectSource => '选择源语言';

  @override
  String get metadataSelectTarget => '选择目标语言';

  @override
  String metadataCopySuccess(int count) {
    return '内容已复制到 $count 个语言';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return '已翻译到 $count 个语言';
  }

  @override
  String get metadataTranslating => '正在翻译...';

  @override
  String get metadataNoSelection => '请先选择语言';

  @override
  String get metadataSelectAll => '全选';

  @override
  String get metadataDeselectAll => '取消全选';

  @override
  String metadataSelected(int count) {
    return '已选择 $count 个';
  }

  @override
  String get metadataTableView => '表格视图';

  @override
  String get metadataListView => '列表视图';

  @override
  String get metadataStatus => '状态';

  @override
  String get metadataCompletion => '完成度';

  @override
  String get common_back => '返回';

  @override
  String get common_next => '下一步';

  @override
  String get common_edit => '编辑';

  @override
  String get metadata_aiOptimize => 'AI 优化';

  @override
  String get wizard_title => 'AI 优化向导';

  @override
  String get wizard_step => '步骤';

  @override
  String get wizard_of => '/';

  @override
  String get wizard_stepTitle => '标题';

  @override
  String get wizard_stepSubtitle => '副标题';

  @override
  String get wizard_stepKeywords => '关键词';

  @override
  String get wizard_stepDescription => '描述';

  @override
  String get wizard_stepReview => '审核并保存';

  @override
  String get wizard_skip => '跳过';

  @override
  String get wizard_saveDrafts => '保存草稿';

  @override
  String get wizard_draftsSaved => '草稿保存成功';

  @override
  String get wizard_exitTitle => '退出向导？';

  @override
  String get wizard_exitMessage => '您有未保存的更改。确定要退出吗？';

  @override
  String get wizard_exitConfirm => '退出';

  @override
  String get wizard_aiSuggestions => 'AI 建议';

  @override
  String get wizard_chooseSuggestion => '选择 AI 生成的建议或自行编写';

  @override
  String get wizard_currentValue => '当前值';

  @override
  String get wizard_noCurrentValue => '未设置值';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return '基于 $keywordsCount 个追踪的关键词和 $competitorsCount 个竞争对手';
  }

  @override
  String get wizard_writeOwn => '自行编写';

  @override
  String get wizard_customPlaceholder => '输入您的自定义值...';

  @override
  String get wizard_useCustom => '使用自定义';

  @override
  String get wizard_keepCurrent => '保留当前';

  @override
  String get wizard_recommended => '推荐';

  @override
  String get wizard_characters => '字符';

  @override
  String get wizard_reviewTitle => '审核更改';

  @override
  String get wizard_reviewDescription => '在保存为草稿之前审核您的优化';

  @override
  String get wizard_noChanges => '未选择更改';

  @override
  String get wizard_noChangesHint => '返回并选择要优化的字段的建议';

  @override
  String wizard_changesCount(int count) {
    return '已更新 $count 个字段';
  }

  @override
  String get wizard_changesSummary => '这些更改将保存为草稿';

  @override
  String get wizard_before => '之前';

  @override
  String get wizard_after => '之后';

  @override
  String get wizard_nextStepsTitle => '接下来会发生什么？';

  @override
  String get wizard_nextStepsWithChanges => '您的更改将保存为草稿。您可以在元数据编辑器中审核并发布它们。';

  @override
  String get wizard_nextStepsNoChanges => '没有要保存的更改。返回并选择建议以优化您的元数据。';

  @override
  String get team_title => '团队管理';

  @override
  String get team_createTeam => '创建团队';

  @override
  String get team_teamName => '团队名称';

  @override
  String get team_teamNameHint => '输入团队名称';

  @override
  String get team_description => '描述（可选）';

  @override
  String get team_descriptionHint => '这个团队是做什么的？';

  @override
  String get team_teamNameRequired => '团队名称是必需的';

  @override
  String get team_teamNameMinLength => '团队名称至少需要2个字符';

  @override
  String get team_inviteMember => '邀请团队成员';

  @override
  String get team_emailAddress => '电子邮件地址';

  @override
  String get team_emailHint => 'colleague@example.com';

  @override
  String get team_emailRequired => '电子邮件是必需的';

  @override
  String get team_emailInvalid => '请输入有效的电子邮件地址';

  @override
  String team_invitationSent(String email) {
    return '已向 $email 发送邀请';
  }

  @override
  String get team_members => '成员';

  @override
  String get team_invite => '邀请';

  @override
  String get team_pendingInvitations => '待处理的邀请';

  @override
  String get team_noPendingInvitations => '没有待处理的邀请';

  @override
  String get team_teamSettings => '团队设置';

  @override
  String team_changeRole(String name) {
    return '更改 $name 的角色';
  }

  @override
  String get team_removeMember => '移除成员';

  @override
  String team_removeMemberConfirm(String name) {
    return '确定要将 $name 从此团队中移除吗？';
  }

  @override
  String get team_remove => '移除';

  @override
  String get team_leaveTeam => '离开团队';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return '确定要离开「$teamName」吗？';
  }

  @override
  String get team_leave => '离开';

  @override
  String get team_deleteTeam => '删除团队';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return '确定要删除「$teamName」吗？此操作无法撤消。';
  }

  @override
  String get team_yourTeams => '您的团队';

  @override
  String get team_failedToLoadTeam => '无法加载团队';

  @override
  String get team_failedToLoadMembers => '无法加载成员';

  @override
  String get team_failedToLoadInvitations => '无法加载邀请';

  @override
  String team_memberCount(int count) {
    return '$count个成员';
  }

  @override
  String team_invitedAs(String role) {
    return '邀请为$role';
  }

  @override
  String team_joinedTeam(String teamName) {
    return '已加入$teamName';
  }

  @override
  String get team_invitationDeclined => '邀请已拒绝';

  @override
  String get team_noTeamsYet => '还没有团队';

  @override
  String get team_noTeamsDescription => '创建团队以与他人协作开发应用';

  @override
  String get team_createFirstTeam => '创建您的第一个团队';

  @override
  String get integrations_title => '集成';

  @override
  String integrations_syncFailed(String error) {
    return '同步失败: $error';
  }

  @override
  String get integrations_disconnectConfirm => '断开连接？';

  @override
  String get integrations_disconnectedSuccess => '已成功断开连接';

  @override
  String get integrations_connectGooglePlay => '连接 Google Play Console';

  @override
  String get integrations_connectAppStore => '连接 App Store Connect';

  @override
  String integrations_connectedApps(int count) {
    return '已连接！导入了 $count 个应用。';
  }

  @override
  String integrations_syncedApps(int count) {
    return '已同步 $count 个应用为所有者';
  }

  @override
  String get integrations_appStoreConnected => 'App Store Connect 连接成功！';

  @override
  String get integrations_googlePlayConnected => 'Google Play Console 连接成功！';

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
  String get alertBuilder_nameYourRule => '命名您的规则';

  @override
  String get alertBuilder_nameDescription => '为您的警报规则起一个描述性的名称';

  @override
  String get alertBuilder_nameHint => '例如：每日排名警报';

  @override
  String get alertBuilder_summary => '摘要';

  @override
  String get alertBuilder_saveAlertRule => '保存警报规则';

  @override
  String get alertBuilder_selectAlertType => '选择警报类型';

  @override
  String get alertBuilder_selectAlertTypeDescription => '选择您要创建的警报类型';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return '这将删除「$ruleName」。';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate => '还没有规则。激活模板或创建您自己的规则！';

  @override
  String get billing_cancelSubscription => '取消订阅';

  @override
  String get billing_keepSubscription => '保留订阅';

  @override
  String get billing_billingPortal => '账单门户';

  @override
  String get billing_resume => '恢复';

  @override
  String get keywords_noCompetitorsFound => '未找到竞争者。请先添加竞争者。';

  @override
  String get keywords_noCompetitorsForApp => '此应用没有竞争者。请先添加竞争者。';

  @override
  String keywords_failedToAddKeywords(String error) {
    return '添加关键词失败：$error';
  }

  @override
  String get keywords_bulkAddHint => '预算追踪器\n支出管理器\n理财应用';

  @override
  String get appOverview_urlCopied => '商店 URL 已复制到剪贴板';

  @override
  String get country_us => '美国';

  @override
  String get country_gb => '英国';

  @override
  String get country_fr => '法国';

  @override
  String get country_de => '德国';

  @override
  String get country_ca => '加拿大';

  @override
  String get country_au => '澳大利亚';

  @override
  String get country_jp => '日本';

  @override
  String get country_cn => '中国';

  @override
  String get country_kr => '韩国';

  @override
  String get country_br => '巴西';

  @override
  String get country_es => '西班牙';

  @override
  String get country_it => '意大利';

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
  String get alertBuilder_type => '类型';

  @override
  String get alertBuilder_scope => '范围';

  @override
  String get alertBuilder_name => '名称';

  @override
  String get alertBuilder_scopeGlobal => '所有应用';

  @override
  String get alertBuilder_scopeApp => '特定应用';

  @override
  String get alertBuilder_scopeCategory => '分类';

  @override
  String get alertBuilder_scopeKeyword => '关键词';

  @override
  String get alertType_positionChange => '排名变动';

  @override
  String get alertType_positionChangeDesc => '当应用排名发生显著变化时提醒';

  @override
  String get alertType_ratingChange => '评分变动';

  @override
  String get alertType_ratingChangeDesc => '当应用评分变动时提醒';

  @override
  String get alertType_reviewSpike => '评论激增';

  @override
  String get alertType_reviewSpikeDesc => '当出现异常评论活动时提醒';

  @override
  String get alertType_reviewKeyword => '评论关键词';

  @override
  String get alertType_reviewKeywordDesc => '当关键词出现在评论中时提醒';

  @override
  String get alertType_newCompetitor => '新竞争者';

  @override
  String get alertType_newCompetitorDesc => '当新应用进入您的领域时提醒';

  @override
  String get alertType_competitorPassed => '超越竞争者';

  @override
  String get alertType_competitorPassedDesc => '当您超越竞争者时提醒';

  @override
  String get alertType_massMovement => '大规模变动';

  @override
  String get alertType_massMovementDesc => '当排名发生大规模变动时提醒';

  @override
  String get alertType_keywordTrend => '关键词趋势';

  @override
  String get alertType_keywordTrendDesc => '当关键词热度变动时提醒';

  @override
  String get alertType_opportunity => '机会';

  @override
  String get alertType_opportunityDesc => '当出现新的排名机会时提醒';

  @override
  String get billing_title => '账单与套餐';

  @override
  String get billing_subscriptionActivated => '订阅已成功激活！';

  @override
  String get billing_changePlan => '更换套餐';

  @override
  String get billing_choosePlan => '选择套餐';

  @override
  String get billing_cancelMessage => '您的订阅将在当前计费周期结束前保持有效。之后，您将失去高级功能的访问权限。';

  @override
  String get billing_currentPlan => '当前套餐';

  @override
  String get billing_trial => '试用';

  @override
  String get billing_canceling => '取消中';

  @override
  String billing_accessUntil(String date) {
    return '访问有效期至 $date';
  }

  @override
  String billing_renewsOn(String date) {
    return '$date 续订';
  }

  @override
  String get billing_manageSubscription => '管理订阅';

  @override
  String get billing_monthly => '月付';

  @override
  String get billing_yearly => '年付';

  @override
  String billing_savePercent(int percent) {
    return '节省 $percent%';
  }

  @override
  String get billing_current => '当前';

  @override
  String get billing_apps => '应用';

  @override
  String get billing_unlimited => '无限制';

  @override
  String get billing_keywordsPerApp => '每应用关键词';

  @override
  String get billing_history => '历史';

  @override
  String billing_days(int count) {
    return '$count 天';
  }

  @override
  String get billing_exports => '导出';

  @override
  String get billing_aiInsights => 'AI 分析';

  @override
  String get billing_apiAccess => 'API 访问';

  @override
  String get billing_yes => '是';

  @override
  String get billing_no => '否';

  @override
  String get billing_currentPlanButton => '当前套餐';

  @override
  String billing_upgradeTo(String planName) {
    return '升级到 $planName';
  }

  @override
  String get billing_cancel => '取消';

  @override
  String get keywords_compareWithCompetitor => '与竞争者比较';

  @override
  String get keywords_selectCompetitorToCompare => '选择要比较关键词的竞争者：';

  @override
  String get keywords_addToCompetitor => '添加到竞争者';

  @override
  String keywords_addKeywordsTo(int count) {
    return '添加 $count 个关键词到：';
  }

  @override
  String get keywords_avgPosition => '平均排名';

  @override
  String get keywords_declined => '下降';

  @override
  String get keywords_total => '总计';

  @override
  String get keywords_ranked => '已排名';

  @override
  String get keywords_improved => '上升';

  @override
  String get onboarding_skip => '跳过';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_getStarted => '开始';

  @override
  String get onboarding_welcomeToKeyrank => '欢迎使用 Keyrank';

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
  String get team_you => '你';

  @override
  String get team_changeRoleButton => 'Change Role';

  @override
  String get team_removeButton => 'Remove';

  @override
  String get competitors_removeTitle => 'Remove Competitor';

  @override
  String competitors_removeConfirm(String name) {
    return '确定要将「$name」从竞争对手中移除吗？';
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
    return '添加竞争对手失败：$error';
  }

  @override
  String get competitors_searchForCompetitor => 'Search for a competitor';

  @override
  String get appPreview_back => 'Back';

  @override
  String get alerts_edit => '编辑';

  @override
  String get alerts_scopeGlobal => '全局';

  @override
  String get alerts_scopeApp => '应用';

  @override
  String get alerts_scopeCategory => '分类';

  @override
  String get alerts_scopeKeyword => '关键词';

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
    return '查看更多 $count 条洞察';
  }

  @override
  String get insights_noInsightsDesc => '当我们发现您应用的优化机会时，洞察将在此显示。';

  @override
  String get insights_loadFailed => '加载洞察失败';

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
