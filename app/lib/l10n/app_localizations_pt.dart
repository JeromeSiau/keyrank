// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTagline => 'Acompanhe seus rankings na App Store';

  @override
  String get auth_welcomeBack => 'Bem-vindo de volta';

  @override
  String get auth_signInSubtitle => 'Entre na sua conta';

  @override
  String get auth_createAccount => 'Criar conta';

  @override
  String get auth_createAccountSubtitle => 'Comece a acompanhar seus rankings';

  @override
  String get auth_emailLabel => 'E-mail';

  @override
  String get auth_passwordLabel => 'Senha';

  @override
  String get auth_nameLabel => 'Nome';

  @override
  String get auth_confirmPasswordLabel => 'Confirmar senha';

  @override
  String get auth_signInButton => 'Entrar';

  @override
  String get auth_signUpButton => 'Criar conta';

  @override
  String get auth_noAccount => 'Não tem uma conta?';

  @override
  String get auth_hasAccount => 'Já tem uma conta?';

  @override
  String get auth_signUpLink => 'Cadastre-se';

  @override
  String get auth_signInLink => 'Entrar';

  @override
  String get auth_emailRequired => 'Por favor, insira seu e-mail';

  @override
  String get auth_emailInvalid => 'E-mail inválido';

  @override
  String get auth_passwordRequired => 'Por favor, insira sua senha';

  @override
  String get auth_enterPassword => 'Por favor, insira uma senha';

  @override
  String get auth_nameRequired => 'Por favor, insira seu nome';

  @override
  String get auth_passwordMinLength =>
      'A senha deve ter pelo menos 8 caracteres';

  @override
  String get auth_passwordsNoMatch => 'As senhas não coincidem';

  @override
  String get auth_errorOccurred => 'Ocorreu um erro';

  @override
  String get common_retry => 'Tentar novamente';

  @override
  String common_error(String message) {
    return 'Erro: $message';
  }

  @override
  String get common_loading => 'Carregando...';

  @override
  String get common_add => 'Adicionar';

  @override
  String get common_filter => 'Filtrar';

  @override
  String get common_sort => 'Ordenar';

  @override
  String get common_refresh => 'Atualizar';

  @override
  String get common_settings => 'Configurações';

  @override
  String get dashboard_title => 'Painel';

  @override
  String get dashboard_addApp => 'Adicionar app';

  @override
  String get dashboard_appsTracked => 'Apps acompanhados';

  @override
  String get dashboard_keywords => 'Palavras-chave';

  @override
  String get dashboard_avgPosition => 'Posição média';

  @override
  String get dashboard_top10 => 'Top 10';

  @override
  String get dashboard_trackedApps => 'Apps acompanhados';

  @override
  String get dashboard_quickActions => 'Ações rápidas';

  @override
  String get dashboard_addNewApp => 'Adicionar um novo app';

  @override
  String get dashboard_searchKeywords => 'Buscar palavras-chave';

  @override
  String get dashboard_viewAllApps => 'Ver todos os apps';

  @override
  String get dashboard_noAppsYet => 'Nenhum app acompanhado ainda';

  @override
  String get dashboard_addAppToStart =>
      'Adicione um app para começar a acompanhar palavras-chave';

  @override
  String get dashboard_noAppsMatchFilter => 'Nenhum app corresponde ao filtro';

  @override
  String get dashboard_changeFilterCriteria =>
      'Tente mudar os critérios do filtro';

  @override
  String get apps_title => 'Meus Apps';

  @override
  String apps_appCount(int count) {
    return '$count apps';
  }

  @override
  String get apps_tableApp => 'APP';

  @override
  String get apps_tableDeveloper => 'DESENVOLVEDOR';

  @override
  String get apps_tableKeywords => 'PALAVRAS-CHAVE';

  @override
  String get apps_tablePlatform => 'PLATAFORMA';

  @override
  String get apps_tableRating => 'AVALIAÇÃO';

  @override
  String get apps_tableBestRank => 'MELHOR POSIÇÃO';

  @override
  String get apps_noAppsYet => 'Nenhum app acompanhado ainda';

  @override
  String get apps_addAppToStart =>
      'Adicione um app para começar a acompanhar seus rankings';

  @override
  String get addApp_title => 'Adicionar App';

  @override
  String get addApp_searchAppStore => 'Buscar na App Store...';

  @override
  String get addApp_searchPlayStore => 'Buscar na Play Store...';

  @override
  String get addApp_searchForApp => 'Buscar um app';

  @override
  String get addApp_enterAtLeast2Chars => 'Digite pelo menos 2 caracteres';

  @override
  String get addApp_noResults => 'Nenhum resultado encontrado';

  @override
  String addApp_addedSuccess(String name) {
    return '$name adicionado com sucesso';
  }

  @override
  String get settings_title => 'Configurações';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_appearance => 'Aparência';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_themeSystem => 'Sistema';

  @override
  String get settings_themeDark => 'Escuro';

  @override
  String get settings_themeLight => 'Claro';

  @override
  String get settings_account => 'Conta';

  @override
  String get settings_memberSince => 'Membro desde';

  @override
  String get settings_logout => 'Sair';

  @override
  String get settings_languageSystem => 'Sistema';

  @override
  String get filter_all => 'Todos';

  @override
  String get filter_allApps => 'Todos os apps';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'Apenas iOS';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Apenas Android';

  @override
  String get filter_favorites => 'Favoritos';

  @override
  String get sort_recent => 'Recente';

  @override
  String get sort_recentlyAdded => 'Adicionado recentemente';

  @override
  String get sort_nameAZ => 'Nome A-Z';

  @override
  String get sort_nameZA => 'Nome Z-A';

  @override
  String get sort_keywords => 'Palavras-chave';

  @override
  String get sort_mostKeywords => 'Mais palavras-chave';

  @override
  String get sort_bestRank => 'Melhor posição';

  @override
  String get userMenu_logout => 'Sair';
}
