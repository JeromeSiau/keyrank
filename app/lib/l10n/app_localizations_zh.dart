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
}
