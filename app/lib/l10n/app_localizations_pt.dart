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
  String get common_search => 'Pesquisar...';

  @override
  String get common_noResults => 'Nenhum resultado';

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
  String get dashboard_reviews => 'Reviews';

  @override
  String get dashboard_avgRating => 'Avg Rating';

  @override
  String get dashboard_topPerformingApps => 'Top Performing Apps';

  @override
  String get dashboard_topCountries => 'Top Countries';

  @override
  String get dashboard_sentimentOverview => 'Sentiment Overview';

  @override
  String get dashboard_overallSentiment => 'Overall Sentiment';

  @override
  String get dashboard_positive => 'Positive';

  @override
  String get dashboard_positiveReviews => 'Positive';

  @override
  String get dashboard_negativeReviews => 'Negative';

  @override
  String get dashboard_viewReviews => 'View reviews';

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

  @override
  String get insights_compareTitle => 'Comparar Insights';

  @override
  String get insights_analyzingReviews => 'Analisando avaliações...';

  @override
  String get insights_noInsightsAvailable => 'Nenhum insight disponível';

  @override
  String get insights_strengths => 'Pontos Fortes';

  @override
  String get insights_weaknesses => 'Pontos Fracos';

  @override
  String get insights_scores => 'Pontuações';

  @override
  String get insights_opportunities => 'Oportunidades';

  @override
  String get insights_categoryUx => 'UX';

  @override
  String get insights_categoryPerf => 'Perf';

  @override
  String get insights_categoryFeatures => 'Recursos';

  @override
  String get insights_categoryPricing => 'Preços';

  @override
  String get insights_categorySupport => 'Suporte';

  @override
  String get insights_categoryOnboard => 'Onboard';

  @override
  String get insights_categoryUxFull => 'UX / Interface';

  @override
  String get insights_categoryPerformance => 'Desempenho';

  @override
  String get insights_categoryOnboarding => 'Onboarding';

  @override
  String get insights_reviewInsights => 'Insights de Avaliações';

  @override
  String get insights_generateFirst => 'Gere os insights primeiro';

  @override
  String get insights_compareWithOther => 'Compare com outros apps';

  @override
  String get insights_compare => 'Comparar';

  @override
  String get insights_generateAnalysis => 'Gerar Análise';

  @override
  String get insights_period => 'Período:';

  @override
  String get insights_3months => '3 meses';

  @override
  String get insights_6months => '6 meses';

  @override
  String get insights_12months => '12 meses';

  @override
  String get insights_analyze => 'Analisar';

  @override
  String insights_reviewsCount(int count) {
    return '$count avaliações';
  }

  @override
  String insights_analyzedAgo(String time) {
    return 'Analisado $time';
  }

  @override
  String get insights_yourNotes => 'Suas Notas';

  @override
  String get insights_save => 'Salvar';

  @override
  String get insights_clickToAddNotes => 'Clique para adicionar notas...';

  @override
  String get insights_noteSaved => 'Nota salva';

  @override
  String get insights_noteHint =>
      'Adicione suas notas sobre esta análise de insights...';

  @override
  String get insights_categoryScores => 'Pontuações por Categoria';

  @override
  String get insights_emergentThemes => 'Temas Emergentes';

  @override
  String get insights_exampleQuotes => 'Citações de exemplo:';

  @override
  String get insights_selectCountryFirst => 'Selecione pelo menos um país';

  @override
  String compare_selectAppsToCompare(String appName) {
    return 'Selecione até 3 apps para comparar com $appName';
  }

  @override
  String get compare_searchApps => 'Buscar apps...';

  @override
  String get compare_noOtherApps => 'Nenhum outro app para comparar';

  @override
  String get compare_noMatchingApps => 'Nenhum app correspondente';

  @override
  String compare_appsSelected(int count) {
    return '$count de 3 apps selecionados';
  }

  @override
  String get compare_cancel => 'Cancelar';

  @override
  String compare_button(int count) {
    return 'Comparar $count Apps';
  }

  @override
  String get appDetail_deleteAppTitle => 'Excluir app?';

  @override
  String get appDetail_deleteAppConfirm => 'Esta ação não pode ser desfeita.';

  @override
  String get appDetail_cancel => 'Cancelar';

  @override
  String get appDetail_delete => 'Excluir';

  @override
  String get appDetail_exporting => 'Exportando rankings...';

  @override
  String appDetail_savedFile(String filename) {
    return 'Salvo: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Mostrar no Finder';

  @override
  String appDetail_exportFailed(String error) {
    return 'Falha na exportação: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return 'Importadas $imported palavras-chave ($skipped ignoradas)';
  }

  @override
  String get appDetail_favorite => 'Favorito';

  @override
  String get appDetail_ratings => 'Avaliações';

  @override
  String get appDetail_insights => 'Insights';

  @override
  String get appDetail_import => 'Importar';

  @override
  String get appDetail_export => 'Exportar';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count avaliações';
  }

  @override
  String get appDetail_keywords => 'palavras-chave';

  @override
  String get appDetail_addKeyword => 'Adicionar palavra-chave';

  @override
  String get appDetail_keywordHint => 'ex: rastreador fitness';

  @override
  String get appDetail_trackedKeywords => 'Palavras-chave Acompanhadas';

  @override
  String appDetail_selectedCount(int count) {
    return '$count selecionadas';
  }

  @override
  String get appDetail_allKeywords => 'Todas as Palavras-chave';

  @override
  String get appDetail_hasTags => 'Com Tags';

  @override
  String get appDetail_hasNotes => 'Com Notas';

  @override
  String get appDetail_position => 'Posição';

  @override
  String get appDetail_select => 'Selecionar';

  @override
  String get appDetail_suggestions => 'Sugestões';

  @override
  String get appDetail_deleteKeywordsTitle => 'Excluir Palavras-chave';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return 'Tem certeza que deseja excluir $count palavras-chave?';
  }

  @override
  String get appDetail_tag => 'Tag';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return 'Palavra-chave \"$keyword\" adicionada ($flag)';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return 'Tags adicionadas a $count palavras-chave';
  }

  @override
  String get appDetail_keywordsAddedSuccess =>
      'Palavras-chave adicionadas com sucesso';

  @override
  String get appDetail_noTagsAvailable =>
      'Nenhuma tag disponível. Crie tags primeiro.';

  @override
  String get appDetail_tagged => 'Com Tag';

  @override
  String get appDetail_withNotes => 'Com Notas';

  @override
  String get appDetail_nameAZ => 'Nome A-Z';

  @override
  String get appDetail_nameZA => 'Nome Z-A';

  @override
  String get appDetail_bestPosition => 'Melhor Posição';

  @override
  String get appDetail_recentlyTracked => 'Acompanhadas Recentemente';

  @override
  String get keywordSuggestions_title => 'Sugestões de Palavras-chave';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$appName em $country';
  }

  @override
  String get keywordSuggestions_refresh => 'Atualizar sugestões';

  @override
  String get keywordSuggestions_search => 'Buscar sugestões...';

  @override
  String get keywordSuggestions_selectAll => 'Selecionar Tudo';

  @override
  String get keywordSuggestions_clear => 'Limpar';

  @override
  String get keywordSuggestions_analyzing => 'Analisando metadados do app...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds =>
      'Isso pode levar alguns segundos';

  @override
  String get keywordSuggestions_noSuggestions => 'Nenhuma sugestão disponível';

  @override
  String get keywordSuggestions_noMatchingSuggestions =>
      'Nenhuma sugestão correspondente';

  @override
  String get keywordSuggestions_headerKeyword => 'PALAVRA-CHAVE';

  @override
  String get keywordSuggestions_headerDifficulty => 'DIFICULDADE';

  @override
  String get keywordSuggestions_headerApps => 'APPS';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return 'Posição #$position';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count palavras-chave selecionadas';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return 'Adicionar $count Palavras-chave';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Erro ao adicionar palavras-chave: $error';
  }

  @override
  String get sidebar_favorites => 'FAVORITOS';

  @override
  String get sidebar_tooManyFavorites =>
      'Considere manter 5 ou menos favoritos';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Pesquisa de Palavras-chave';

  @override
  String get keywordSearch_searchPlaceholder => 'Buscar palavras-chave...';

  @override
  String get keywordSearch_searchTitle => 'Buscar uma palavra-chave';

  @override
  String get keywordSearch_searchSubtitle =>
      'Descubra quais apps ranqueiam para qualquer palavra-chave';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count apps ranqueados';
  }

  @override
  String get keywordSearch_popularity => 'Popularidade';

  @override
  String keywordSearch_results(int count) {
    return '$count resultados';
  }

  @override
  String get keywordSearch_headerRank => 'POSIÇÃO';

  @override
  String get keywordSearch_headerApp => 'APP';

  @override
  String get keywordSearch_headerRating => 'AVALIAÇÃO';

  @override
  String get keywordSearch_headerTrack => 'ACOMPANHAR';

  @override
  String get keywordSearch_trackApp => 'Acompanhar este app';

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
    return 'Avaliações de $appName';
  }

  @override
  String get reviews_loading => 'Carregando avaliações...';

  @override
  String get reviews_noReviews => 'Sem avaliações';

  @override
  String reviews_noReviewsFor(String countryName) {
    return 'Nenhuma avaliação encontrada para $countryName';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'Mostrando as $count avaliações mais recentes da App Store.';
  }

  @override
  String get reviews_today => 'Hoje';

  @override
  String get reviews_yesterday => 'Ontem';

  @override
  String reviews_daysAgo(int count) {
    return '$count dias atrás';
  }

  @override
  String reviews_weeksAgo(int count) {
    return '$count semanas atrás';
  }

  @override
  String reviews_monthsAgo(int count) {
    return '$count meses atrás';
  }

  @override
  String get ratings_byCountry => 'Avaliações por País';

  @override
  String get ratings_noRatingsAvailable => 'Nenhuma avaliação disponível';

  @override
  String get ratings_noRatingsYet => 'Este app ainda não tem avaliações';

  @override
  String get ratings_totalRatings => 'Total de Avaliações';

  @override
  String get ratings_averageRating => 'Avaliação Média';

  @override
  String ratings_countriesCount(int count) {
    return '$count países';
  }

  @override
  String ratings_updated(String date) {
    return 'Atualizado: $date';
  }

  @override
  String get ratings_headerCountry => 'PAÍS';

  @override
  String get ratings_headerRatings => 'AVALIAÇÕES';

  @override
  String get ratings_headerAverage => 'MÉDIA';

  @override
  String time_minutesAgo(int count) {
    return '${count}m atrás';
  }

  @override
  String time_hoursAgo(int count) {
    return '${count}h atrás';
  }

  @override
  String time_daysAgo(int count) {
    return '${count}d atrás';
  }

  @override
  String get appDetail_noKeywordsTracked => 'Nenhuma palavra-chave acompanhada';

  @override
  String get appDetail_addKeywordHint =>
      'Adicione uma palavra-chave acima para começar a acompanhar';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Nenhuma palavra-chave corresponde ao filtro';

  @override
  String get appDetail_tryChangingFilter =>
      'Tente mudar os critérios do filtro';

  @override
  String get appDetail_addTag => 'Adicionar tag';

  @override
  String get appDetail_addNote => 'Adicionar nota';

  @override
  String get appDetail_positionHistory => 'Historico de Posicoes';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => 'VISÃO GERAL';

  @override
  String get nav_dashboard => 'Painel';

  @override
  String get nav_myApps => 'Meus Apps';

  @override
  String get nav_research => 'PESQUISA';

  @override
  String get nav_keywords => 'Palavras-chave';

  @override
  String get nav_discover => 'Descobrir';

  @override
  String get nav_engagement => 'ENGAGEMENT';

  @override
  String get nav_reviewsInbox => 'Reviews Inbox';

  @override
  String get nav_notifications => 'Alertas';

  @override
  String get nav_optimization => 'OPTIMIZATION';

  @override
  String get nav_keywordInspector => 'Keyword Inspector';

  @override
  String get nav_ratingsAnalysis => 'Ratings Analysis';

  @override
  String get nav_intelligence => 'INTELLIGENCE';

  @override
  String get nav_topCharts => 'Top Charts';

  @override
  String get nav_competitors => 'Competitors';

  @override
  String get common_save => 'Salvar';

  @override
  String get appDetail_manageTags => 'Gerenciar tags';

  @override
  String get appDetail_newTagHint => 'Nome da nova tag...';

  @override
  String get appDetail_availableTags => 'Tags disponíveis';

  @override
  String get appDetail_noTagsYet => 'Nenhuma tag ainda. Crie uma acima.';

  @override
  String get appDetail_addTagsTitle => 'Adicionar tags';

  @override
  String get appDetail_selectTagsDescription =>
      'Selecione tags para adicionar às palavras-chave:';

  @override
  String appDetail_addTagsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tags',
      one: 'tag',
    );
    return 'Adicionar $count $_temp0';
  }

  @override
  String appDetail_importFailed(String error) {
    return 'Falha na importação: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Importar palavras-chave';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Cole as palavras-chave abaixo, uma por linha:';

  @override
  String get appDetail_keywordPlaceholder =>
      'palavra-chave um\npalavra-chave dois\npalavra-chave três';

  @override
  String get appDetail_storefront => 'Loja:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count palavras-chave';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return 'Importar $count palavras-chave';
  }

  @override
  String get appDetail_period7d => '7d';

  @override
  String get appDetail_period30d => '30d';

  @override
  String get appDetail_period90d => '90d';

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
  String get appPreview_keywordsPlaceholder =>
      'Add this app to your tracked apps to enable keyword tracking';

  @override
  String get notifications_title => 'Notificacoes';

  @override
  String get notifications_markAllRead => 'Marcar tudo como lido';

  @override
  String get notifications_empty => 'Nenhuma notificacao ainda';

  @override
  String get alerts_title => 'Regras de alerta';

  @override
  String get alerts_templatesTitle => 'Modelos rapidos';

  @override
  String get alerts_templatesSubtitle => 'Ative alertas comuns com um toque';

  @override
  String get alerts_myRulesTitle => 'Minhas regras';

  @override
  String get alerts_createRule => 'Criar regra';

  @override
  String get alerts_editRule => 'Editar regra';

  @override
  String get alerts_noRulesYet => 'Nenhuma regra ainda';

  @override
  String get alerts_deleteConfirm => 'Excluir regra?';

  @override
  String get settings_notifications => 'NOTIFICACOES';

  @override
  String get settings_manageAlerts => 'Gerenciar regras de alerta';

  @override
  String get settings_manageAlertsDesc => 'Configure quais alertas voce recebe';

  @override
  String get settings_storeConnections => 'Store Connections';

  @override
  String get settings_storeConnectionsDesc =>
      'Connect your App Store and Google Play accounts';

  @override
  String get storeConnections_title => 'Store Connections';

  @override
  String get storeConnections_description =>
      'Connect your App Store and Google Play accounts to enable advanced features like sales data and app analytics.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Connect your Apple Developer account';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Connect your Google Play account';

  @override
  String get storeConnections_connect => 'Connect';

  @override
  String get storeConnections_disconnect => 'Disconnect';

  @override
  String get storeConnections_connected => 'Connected';

  @override
  String get storeConnections_disconnectConfirm => 'Disconnect?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'Are you sure you want to disconnect this $platform account?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Disconnected successfully';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Last synced: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return 'Connected on $date';
  }

  @override
  String get reviewsInbox_title => 'Reviews Inbox';

  @override
  String get reviewsInbox_filterUnanswered => 'Unanswered';

  @override
  String get reviewsInbox_filterNegative => 'Negative';

  @override
  String get reviewsInbox_noReviews => 'No reviews found';

  @override
  String get reviewsInbox_noReviewsDesc => 'Try adjusting your filters';

  @override
  String get reviewsInbox_reply => 'Reply';

  @override
  String get reviewsInbox_responded => 'Response';

  @override
  String reviewsInbox_respondedAt(String date) {
    return 'Responded $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Reply to Review';

  @override
  String get reviewsInbox_generateAi => 'Generate AI suggestion';

  @override
  String get reviewsInbox_generating => 'Generating...';

  @override
  String get reviewsInbox_sendReply => 'Send Reply';

  @override
  String get reviewsInbox_sending => 'Sending...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Write your response...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 characters';
  }

  @override
  String get reviewsInbox_replySent => 'Reply sent successfully';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Failed to send reply: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Failed to generate suggestion: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count stars';
  }

  @override
  String get reviewsInbox_totalReviews => 'Total Reviews';

  @override
  String get reviewsInbox_unanswered => 'Unanswered';

  @override
  String get reviewsInbox_positive => 'Positive';

  @override
  String get reviewsInbox_avgRating => 'Avg Rating';

  @override
  String get reviewsInbox_sentimentOverview => 'Sentiment Overview';

  @override
  String get analytics_title => 'Análises';

  @override
  String get analytics_downloads => 'Downloads';

  @override
  String get analytics_revenue => 'Receita';

  @override
  String get analytics_proceeds => 'Lucros';

  @override
  String get analytics_subscribers => 'Assinantes';

  @override
  String get analytics_downloadsOverTime => 'Downloads ao longo do tempo';

  @override
  String get analytics_revenueOverTime => 'Receita ao longo do tempo';

  @override
  String get analytics_byCountry => 'Por país';

  @override
  String get analytics_noData => 'Nenhum dado disponível';

  @override
  String get analytics_noDataTitle => 'Sem dados analíticos';

  @override
  String get analytics_noDataDescription =>
      'Conecte sua conta App Store Connect ou Google Play para ver dados reais de vendas e downloads.';

  @override
  String analytics_dataDelay(String date) {
    return 'Dados de $date. Dados da Apple têm atraso de 24-48h.';
  }

  @override
  String get analytics_export => 'Exportar CSV';

  @override
  String get nav_chat => 'AI Assistant';

  @override
  String get chat_title => 'AI Assistant';

  @override
  String get chat_newConversation => 'New Chat';

  @override
  String get chat_loadingConversations => 'Loading conversations...';

  @override
  String get chat_loadingMessages => 'Loading messages...';

  @override
  String get chat_noConversations => 'No conversations yet';

  @override
  String get chat_noConversationsDesc =>
      'Start a new conversation to get AI-powered insights about your apps';

  @override
  String get chat_startConversation => 'Start Conversation';

  @override
  String get chat_deleteConversation => 'Delete Conversation';

  @override
  String get chat_deleteConversationConfirm =>
      'Are you sure you want to delete this conversation?';

  @override
  String get chat_askAnything => 'Ask me anything';

  @override
  String get chat_askAnythingDesc =>
      'I can help you understand your app\'s reviews, rankings, and analytics';

  @override
  String get chat_typeMessage => 'Type your question...';

  @override
  String get chat_suggestedQuestions => 'Suggested Questions';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get appDetail_tabOverview => 'Overview';

  @override
  String get appDetail_tabKeywords => 'Keywords';

  @override
  String get appDetail_tabReviews => 'Reviews';

  @override
  String get appDetail_tabRatings => 'Ratings';

  @override
  String get appDetail_tabInsights => 'Insights';
}
