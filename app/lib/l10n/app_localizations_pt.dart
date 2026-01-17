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
  String get dashboard_reviews => 'Avaliações';

  @override
  String get dashboard_avgRating => 'Nota média';

  @override
  String get dashboard_topPerformingApps => 'Apps com melhor desempenho';

  @override
  String get dashboard_topCountries => 'Principais países';

  @override
  String get dashboard_sentimentOverview => 'Visão geral do sentimento';

  @override
  String get dashboard_overallSentiment => 'Sentimento geral';

  @override
  String get dashboard_positive => 'Positivo';

  @override
  String get dashboard_positiveReviews => 'Positivo';

  @override
  String get dashboard_negativeReviews => 'Negativo';

  @override
  String get dashboard_viewReviews => 'Ver avaliações';

  @override
  String get dashboard_tableApp => 'APP';

  @override
  String get dashboard_tableKeywords => 'PALAVRAS-CHAVE';

  @override
  String get dashboard_tableAvgRank => 'POSIÇÃO MÉD.';

  @override
  String get dashboard_tableTrend => 'TENDÊNCIA';

  @override
  String get dashboard_connectYourStores => 'Conecte suas lojas';

  @override
  String get dashboard_connectStoresDescription =>
      'Vincule o App Store Connect ou Google Play para importar seus apps e responder avaliações.';

  @override
  String get dashboard_connect => 'Conectar';

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
  String get insights_compareTitle => 'Comparar análises';

  @override
  String get insights_analyzingReviews => 'Analisando avaliações...';

  @override
  String get insights_noInsightsAvailable => 'Nenhuma análise disponível';

  @override
  String get insights_strengths => 'Pontos fortes';

  @override
  String get insights_weaknesses => 'Pontos fracos';

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
  String get insights_reviewInsights => 'Análises de avaliações';

  @override
  String get insights_generateFirst => 'Gere as análises primeiro';

  @override
  String get insights_compareWithOther => 'Comparar com outros apps';

  @override
  String get insights_compare => 'Comparar';

  @override
  String get insights_generateAnalysis => 'Gerar análise';

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
  String get insights_yourNotes => 'Suas notas';

  @override
  String get insights_save => 'Salvar';

  @override
  String get insights_clickToAddNotes => 'Clique para adicionar notas...';

  @override
  String get insights_noteSaved => 'Nota salva';

  @override
  String get insights_noteHint => 'Adicione suas notas sobre esta análise...';

  @override
  String get insights_categoryScores => 'Pontuações por categoria';

  @override
  String get insights_emergentThemes => 'Temas emergentes';

  @override
  String get insights_exampleQuotes => 'Exemplos de citações:';

  @override
  String get insights_selectCountryFirst => 'Selecione pelo menos um país';

  @override
  String get insights_title => 'Análises';

  @override
  String insights_titleWithApp(String appName) {
    return 'Análises - $appName';
  }

  @override
  String get insights_allApps => 'Análises (Todos os apps)';

  @override
  String get insights_noInsightsYet => 'Ainda não há insights';

  @override
  String get insights_selectAppToGenerate =>
      'Selecione um app para gerar análises a partir das avaliações';

  @override
  String insights_appsWithInsights(int count) {
    return '$count apps com análises';
  }

  @override
  String get insights_errorLoading => 'Erro ao carregar análises';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '$count avaliações analisadas';
  }

  @override
  String get insights_avgScore => 'pontuação média';

  @override
  String insights_updatedOn(String date) {
    return 'Atualizado em $date';
  }

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
    return 'Comparar $count apps';
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
    return '$imported palavras-chave importadas ($skipped ignoradas)';
  }

  @override
  String get appDetail_favorite => 'Favorito';

  @override
  String get appDetail_ratings => 'Notas';

  @override
  String get appDetail_insights => 'Análises';

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
  String get appDetail_trackedKeywords => 'Palavras-chave acompanhadas';

  @override
  String appDetail_selectedCount(int count) {
    return '$count selecionado(s)';
  }

  @override
  String get appDetail_allKeywords => 'Todas as palavras-chave';

  @override
  String get appDetail_hasTags => 'Com tags';

  @override
  String get appDetail_hasNotes => 'Com notas';

  @override
  String get appDetail_position => 'Posição';

  @override
  String get appDetail_select => 'Selecionar';

  @override
  String get appDetail_suggestions => 'Sugestões';

  @override
  String get appDetail_deleteKeywordsTitle => 'Excluir palavras-chave';

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
  String get appDetail_tagged => 'Com tag';

  @override
  String get appDetail_withNotes => 'Com notas';

  @override
  String get appDetail_nameAZ => 'Nome A-Z';

  @override
  String get appDetail_nameZA => 'Nome Z-A';

  @override
  String get appDetail_bestPosition => 'Melhor posição';

  @override
  String get appDetail_recentlyTracked => 'Acompanhado recentemente';

  @override
  String get keywordSuggestions_title => 'Sugestões de palavras-chave';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$appName em $country';
  }

  @override
  String get keywordSuggestions_refresh => 'Atualizar sugestões';

  @override
  String get keywordSuggestions_search => 'Buscar sugestões...';

  @override
  String get keywordSuggestions_selectAll => 'Selecionar tudo';

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
    return 'Adicionar $count palavras-chave';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Erro ao adicionar palavras-chave: $error';
  }

  @override
  String get keywordSuggestions_categoryAll => 'Todos';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'Oportunidades';

  @override
  String get keywordSuggestions_categoryCompetitor =>
      'Palavras-chave de concorrentes';

  @override
  String get keywordSuggestions_categoryLongTail => 'Long-tail';

  @override
  String get keywordSuggestions_categoryTrending => 'Em alta';

  @override
  String get keywordSuggestions_categoryRelated => 'Relacionadas';

  @override
  String get keywordSuggestions_generating => 'Gerando sugestões...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      'Isso pode levar alguns minutos. Volte mais tarde.';

  @override
  String get keywordSuggestions_checkAgain => 'Verificar novamente';

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
  String get keywordSearch_title => 'Pesquisa de palavras-chave';

  @override
  String get keywordSearch_searchPlaceholder => 'Buscar palavras-chave...';

  @override
  String get keywordSearch_searchTitle => 'Buscar uma palavra-chave';

  @override
  String get keywordSearch_searchSubtitle =>
      'Descubra quais apps estão ranqueados para uma palavra-chave';

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
  String get discover_title => 'Descobrir';

  @override
  String get discover_tabKeywords => 'Palavras-chave';

  @override
  String get discover_tabCategories => 'Categorias';

  @override
  String get discover_selectCategory => 'Selecionar uma categoria';

  @override
  String get discover_topFree => 'Gratuitos';

  @override
  String get discover_topPaid => 'Pagos';

  @override
  String get discover_topGrossing => 'Receita';

  @override
  String get discover_noResults => 'Nenhum resultado';

  @override
  String get discover_loadingTopApps => 'Carregando top apps...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return 'Top $collection em $category';
  }

  @override
  String discover_appsCount(int count) {
    return '$count apps';
  }

  @override
  String get discover_allCategories => 'Todas as categorias';

  @override
  String get category_games => 'Jogos';

  @override
  String get category_business => 'Negócios';

  @override
  String get category_education => 'Educação';

  @override
  String get category_entertainment => 'Entretenimento';

  @override
  String get category_finance => 'Finanças';

  @override
  String get category_food_drink => 'Comida e bebida';

  @override
  String get category_health_fitness => 'Saúde e fitness';

  @override
  String get category_lifestyle => 'Estilo de vida';

  @override
  String get category_medical => 'Medicina';

  @override
  String get category_music => 'Música';

  @override
  String get category_navigation => 'Navegação';

  @override
  String get category_news => 'Notícias';

  @override
  String get category_photo_video => 'Foto e vídeo';

  @override
  String get category_productivity => 'Produtividade';

  @override
  String get category_reference => 'Referência';

  @override
  String get category_shopping => 'Compras';

  @override
  String get category_social => 'Redes sociais';

  @override
  String get category_sports => 'Esportes';

  @override
  String get category_travel => 'Viagens';

  @override
  String get category_utilities => 'Utilitários';

  @override
  String get category_weather => 'Clima';

  @override
  String get category_books => 'Livros';

  @override
  String get category_developer_tools => 'Ferramentas de desenvolvimento';

  @override
  String get category_graphics_design => 'Gráficos e design';

  @override
  String get category_magazines => 'Revistas e jornais';

  @override
  String get category_stickers => 'Adesivos';

  @override
  String get category_catalogs => 'Catálogos';

  @override
  String get category_art_design => 'Arte e design';

  @override
  String get category_auto_vehicles => 'Automóveis';

  @override
  String get category_beauty => 'Beleza';

  @override
  String get category_comics => 'Quadrinhos';

  @override
  String get category_communication => 'Comunicação';

  @override
  String get category_dating => 'Encontros';

  @override
  String get category_events => 'Eventos';

  @override
  String get category_house_home => 'Casa';

  @override
  String get category_libraries => 'Bibliotecas';

  @override
  String get category_maps_navigation => 'Mapas e navegação';

  @override
  String get category_music_audio => 'Música e áudio';

  @override
  String get category_news_magazines => 'Notícias e revistas';

  @override
  String get category_parenting => 'Maternidade e paternidade';

  @override
  String get category_personalization => 'Personalização';

  @override
  String get category_photography => 'Fotografia';

  @override
  String get category_tools => 'Ferramentas';

  @override
  String get category_video_players => 'Reprodutores de vídeo';

  @override
  String get category_all_apps => 'Todos os apps';

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
    return 'Há $count dias';
  }

  @override
  String reviews_weeksAgo(int count) {
    return 'Há $count semanas';
  }

  @override
  String reviews_monthsAgo(int count) {
    return 'Há $count meses';
  }

  @override
  String get ratings_byCountry => 'Notas por país';

  @override
  String get ratings_noRatingsAvailable => 'Nenhuma nota disponível';

  @override
  String get ratings_noRatingsYet => 'Este app ainda não tem notas';

  @override
  String get ratings_totalRatings => 'Total de notas';

  @override
  String get ratings_averageRating => 'Nota média';

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
  String get ratings_headerRatings => 'NOTAS';

  @override
  String get ratings_headerAverage => 'MÉDIA';

  @override
  String time_minutesAgo(int count) {
    return 'Há ${count}min';
  }

  @override
  String time_hoursAgo(int count) {
    return 'Há ${count}h';
  }

  @override
  String time_daysAgo(int count) {
    return 'Há ${count}d';
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
  String get appDetail_positionHistory => 'Histórico de posições';

  @override
  String get appDetail_store => 'LOJA';

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
  String get nav_engagement => 'ENGAJAMENTO';

  @override
  String get nav_reviewsInbox => 'Caixa de entrada';

  @override
  String get nav_notifications => 'Alertas';

  @override
  String get nav_optimization => 'OTIMIZAÇÃO';

  @override
  String get nav_keywordInspector => 'Inspetor de palavras-chave';

  @override
  String get nav_ratingsAnalysis => 'Análise de notas';

  @override
  String get nav_intelligence => 'INTELIGÊNCIA';

  @override
  String get nav_topCharts => 'Top Charts';

  @override
  String get nav_competitors => 'Concorrentes';

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
      'Selecione as tags para adicionar às palavras-chave selecionadas:';

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
  String get appDetail_currentTags => 'Tags atuais';

  @override
  String get appDetail_noTagsOnKeyword => 'Nenhuma tag nesta palavra-chave';

  @override
  String get appDetail_addExistingTag => 'Adicionar uma tag existente';

  @override
  String get appDetail_allTagsUsed => 'Todas as tags já estão em uso';

  @override
  String get appDetail_createNewTag => 'Criar uma nova tag';

  @override
  String get appDetail_tagNameHint => 'Nome da tag...';

  @override
  String get appDetail_note => 'Nota';

  @override
  String get appDetail_noteHint =>
      'Adicione uma nota sobre esta palavra-chave...';

  @override
  String get appDetail_saveNote => 'Salvar nota';

  @override
  String get appDetail_done => 'Concluído';

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
  String get keywords_difficultyFilter => 'Dificuldade:';

  @override
  String get keywords_difficultyAll => 'Todas';

  @override
  String get keywords_difficultyEasy => 'Fácil < 40';

  @override
  String get keywords_difficultyMedium => 'Média 40-70';

  @override
  String get keywords_difficultyHard => 'Difícil > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'Detalhes do app';

  @override
  String get appPreview_notFound => 'Aplicativo não encontrado';

  @override
  String get appPreview_screenshots => 'Capturas de tela';

  @override
  String get appPreview_description => 'Descrição';

  @override
  String get appPreview_details => 'Detalhes';

  @override
  String get appPreview_version => 'Versão';

  @override
  String get appPreview_updated => 'Atualização';

  @override
  String get appPreview_released => 'Lançamento';

  @override
  String get appPreview_size => 'Tamanho';

  @override
  String get appPreview_minimumOs => 'Requisito';

  @override
  String get appPreview_price => 'Preço';

  @override
  String get appPreview_free => 'Grátis';

  @override
  String get appPreview_openInStore => 'Abrir na loja';

  @override
  String get appPreview_addToMyApps => 'Adicionar aos meus apps';

  @override
  String get appPreview_added => 'Adicionado';

  @override
  String get appPreview_showMore => 'Ver mais';

  @override
  String get appPreview_showLess => 'Ver menos';

  @override
  String get appPreview_keywordsPlaceholder =>
      'Adicione este app aos seus apps acompanhados para ativar o rastreamento de palavras-chave';

  @override
  String get notifications_title => 'Notificações';

  @override
  String get notifications_markAllRead => 'Marcar tudo como lido';

  @override
  String get notifications_empty => 'Nenhuma notificação ainda';

  @override
  String get alerts_title => 'Regras de alerta';

  @override
  String get alerts_templatesTitle => 'Modelos rápidos';

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
  String get alerts_createCustomRule => 'Criar regra personalizada';

  @override
  String alerts_ruleActivated(String name) {
    return '$name ativado!';
  }

  @override
  String alerts_deleteMessage(String name) {
    return 'Isso excluirá \"$name\".';
  }

  @override
  String get alerts_noRulesDescription => 'Ative um modelo ou crie o seu!';

  @override
  String get alerts_create => 'Criar';

  @override
  String get settings_notifications => 'NOTIFICAÇÕES';

  @override
  String get settings_manageAlerts => 'Gerenciar regras de alerta';

  @override
  String get settings_manageAlertsDesc => 'Configure quais alertas você recebe';

  @override
  String get settings_storeConnections => 'Conexões de lojas';

  @override
  String get settings_storeConnectionsDesc =>
      'Conecte suas contas do App Store e Google Play';

  @override
  String get settings_alertDelivery => 'ENTREGA DE ALERTAS';

  @override
  String get settings_team => 'EQUIPE';

  @override
  String get settings_teamManagement => 'Gerenciamento de equipe';

  @override
  String get settings_teamManagementDesc =>
      'Invite members, manage roles & permissions';

  @override
  String get settings_integrations => 'Integrações';

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
  String get storeConnections_title => 'Conexões com lojas';

  @override
  String get storeConnections_description =>
      'Conecte suas contas do App Store e Google Play para ativar recursos avançados como dados de vendas e análises de aplicativos.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Conecte sua conta de desenvolvedor Apple';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Conecte sua conta do Google Play';

  @override
  String get storeConnections_connect => 'Conectar';

  @override
  String get storeConnections_disconnect => 'Desconectar';

  @override
  String get storeConnections_connected => 'Conectado';

  @override
  String get storeConnections_disconnectConfirm => 'Desconectar?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'Tem certeza que deseja desconectar esta conta $platform?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Desconectado com sucesso';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Última sincronização: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return 'Conectado em $date';
  }

  @override
  String get storeConnections_syncApps => 'Sincronizar apps';

  @override
  String get storeConnections_syncing => 'Sincronizando...';

  @override
  String get storeConnections_syncDescription =>
      'A sincronização marcará seus apps como próprios, permitindo responder avaliações.';

  @override
  String storeConnections_syncedApps(int count) {
    return '$count apps sincronizados como próprios';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return 'Falha na sincronização: $error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return 'Erro ao carregar conexões: $error';
  }

  @override
  String get reviewsInbox_title => 'Caixa de entrada';

  @override
  String get reviewsInbox_filterUnanswered => 'Sem resposta';

  @override
  String get reviewsInbox_filterNegative => 'Negativo';

  @override
  String get reviewsInbox_noReviews => 'Nenhuma avaliação encontrada';

  @override
  String get reviewsInbox_noReviewsDesc => 'Tente ajustar seus filtros';

  @override
  String get reviewsInbox_reply => 'Responder';

  @override
  String get reviewsInbox_responded => 'Resposta';

  @override
  String reviewsInbox_respondedAt(String date) {
    return 'Respondido em $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Responder à avaliação';

  @override
  String get reviewsInbox_generateAi => 'Gerar sugestão com IA';

  @override
  String get reviewsInbox_generating => 'Gerando...';

  @override
  String get reviewsInbox_sendReply => 'Enviar resposta';

  @override
  String get reviewsInbox_sending => 'Enviando...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Escreva sua resposta...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 caracteres';
  }

  @override
  String get reviewsInbox_replySent => 'Resposta enviada com sucesso';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Falha ao enviar resposta: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Falha ao gerar sugestão: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count estrelas';
  }

  @override
  String get reviewsInbox_totalReviews => 'Total de avaliações';

  @override
  String get reviewsInbox_unanswered => 'Sem resposta';

  @override
  String get reviewsInbox_positive => 'Positivas';

  @override
  String get reviewsInbox_avgRating => 'Nota média';

  @override
  String get reviewsInbox_sentimentOverview => 'Visão geral do sentimento';

  @override
  String get reviewsInbox_aiSuggestions => 'Sugestões de IA';

  @override
  String get reviewsInbox_regenerate => 'Regenerar';

  @override
  String get reviewsInbox_toneProfessional => 'Profissional';

  @override
  String get reviewsInbox_toneEmpathetic => 'Empático';

  @override
  String get reviewsInbox_toneBrief => 'Breve';

  @override
  String get reviewsInbox_selectTone => 'Selecione o tom:';

  @override
  String get reviewsInbox_detectedIssues => 'Problemas detectados:';

  @override
  String get reviewsInbox_aiPrompt =>
      'Clique em \'Gerar sugestão com IA\' para obter sugestões de resposta em 3 tons diferentes';

  @override
  String get reviewIntelligence_title => 'Inteligência de avaliações';

  @override
  String get reviewIntelligence_featureRequests => 'Solicitações de recursos';

  @override
  String get reviewIntelligence_bugReports => 'Relatórios de bugs';

  @override
  String get reviewIntelligence_sentimentByVersion => 'Sentimento por versão';

  @override
  String get reviewIntelligence_openFeatures => 'Recursos em aberto';

  @override
  String get reviewIntelligence_openBugs => 'Bugs em aberto';

  @override
  String get reviewIntelligence_highPriority => 'Alta prioridade';

  @override
  String get reviewIntelligence_total => 'total';

  @override
  String get reviewIntelligence_mentions => 'menções';

  @override
  String get reviewIntelligence_noData => 'Ainda sem insights';

  @override
  String get reviewIntelligence_noDataHint =>
      'Os insights aparecerão após a análise das avaliações';

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
  String get analytics_noDataTitle => 'Sem dados de análise';

  @override
  String get analytics_noDataDescription =>
      'Conecte sua conta do App Store Connect ou Google Play para ver dados reais de vendas e downloads.';

  @override
  String analytics_dataDelay(String date) {
    return 'Dados de $date. Dados da Apple têm atraso de 24-48h.';
  }

  @override
  String get analytics_export => 'Exportar CSV';

  @override
  String get funnel_title => 'Funil de conversão';

  @override
  String get funnel_impressions => 'Impressões';

  @override
  String get funnel_pageViews => 'Visualizações de página';

  @override
  String get funnel_downloads => 'Downloads';

  @override
  String get funnel_overallCvr => 'CVR geral';

  @override
  String get funnel_categoryAvg => 'Média da categoria';

  @override
  String get funnel_vsCategory => 'vs categoria';

  @override
  String get funnel_bySource => 'Por origem';

  @override
  String get funnel_noData => 'Nenhum dado de funil disponível';

  @override
  String get funnel_noDataHint =>
      'Os dados do funil serão sincronizados automaticamente do App Store Connect ou Google Play Console.';

  @override
  String get funnel_insight => 'INSIGHT';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return 'O tráfego de $bestSource converte ${ratio}x melhor que $worstSource. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'Concentre-se na otimização de palavras-chave para aumentar as impressões de pesquisa.';

  @override
  String get funnel_insightRecommendBrowse =>
      'Melhore a visibilidade do seu app na navegação otimizando categorias e posicionamento em destaque.';

  @override
  String get funnel_insightRecommendReferral =>
      'Aproveite programas de indicação e parcerias para gerar mais tráfego.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      'Considere estratégias de promoção cruzada com apps complementares.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'Otimize seu site e landing pages para downloads.';

  @override
  String get funnel_insightRecommendDefault =>
      'Analise o que torna essa fonte eficaz e replique.';

  @override
  String get funnel_trendTitle => 'Tendência da taxa de conversão';

  @override
  String get funnel_connectStore => 'Conectar loja';

  @override
  String get nav_chat => 'Assistente IA';

  @override
  String get chat_title => 'Assistente IA';

  @override
  String get chat_newConversation => 'Nova conversa';

  @override
  String get chat_loadingConversations => 'Carregando conversas...';

  @override
  String get chat_loadingMessages => 'Carregando mensagens...';

  @override
  String get chat_noConversations => 'Nenhuma conversa';

  @override
  String get chat_noConversationsDesc =>
      'Inicie uma nova conversa para obter insights de IA sobre seus apps';

  @override
  String get chat_startConversation => 'Iniciar conversa';

  @override
  String get chat_deleteConversation => 'Excluir conversa';

  @override
  String get chat_deleteConversationConfirm =>
      'Tem certeza que deseja excluir esta conversa?';

  @override
  String get chat_askAnything => 'Pergunte-me algo';

  @override
  String get chat_askAnythingDesc =>
      'Posso ajudar você a entender as avaliações, rankings e análises do seu app';

  @override
  String get chat_typeMessage => 'Digite sua pergunta...';

  @override
  String get chat_suggestedQuestions => 'Perguntas sugeridas';

  @override
  String get chatActionConfirm => 'Confirmar';

  @override
  String get chatActionCancel => 'Cancelar';

  @override
  String get chatActionExecuting => 'Executando...';

  @override
  String get chatActionExecuted => 'Concluído';

  @override
  String get chatActionFailed => 'Falhou';

  @override
  String get chatActionCancelled => 'Cancelado';

  @override
  String get chatActionDownload => 'Baixar';

  @override
  String get chatActionReversible => 'Esta ação pode ser desfeita';

  @override
  String get chatActionAddKeywords => 'Adicionar palavras-chave';

  @override
  String get chatActionRemoveKeywords => 'Remover palavras-chave';

  @override
  String get chatActionCreateAlert => 'Criar alerta';

  @override
  String get chatActionAddCompetitor => 'Adicionar concorrente';

  @override
  String get chatActionExportData => 'Exportar dados';

  @override
  String get chatActionKeywords => 'Palavras-chave';

  @override
  String get chatActionCountry => 'País';

  @override
  String get chatActionAlertCondition => 'Condição';

  @override
  String get chatActionNotifyVia => 'Notificar via';

  @override
  String get chatActionCompetitor => 'Concorrente';

  @override
  String get chatActionExportType => 'Tipo de exportação';

  @override
  String get chatActionDateRange => 'Período';

  @override
  String get chatActionKeywordsLabel => 'Palavras-chave';

  @override
  String get chatActionAnalyticsLabel => 'Estatísticas';

  @override
  String get chatActionReviewsLabel => 'Avaliações';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_delete => 'Excluir';

  @override
  String get appDetail_tabOverview => 'Visão geral';

  @override
  String get appDetail_tabKeywords => 'Palavras-chave';

  @override
  String get appDetail_tabReviews => 'Avaliações';

  @override
  String get appDetail_tabRatings => 'Notas';

  @override
  String get appDetail_tabInsights => 'Análises';

  @override
  String get dateRange_title => 'Período';

  @override
  String get dateRange_today => 'Hoje';

  @override
  String get dateRange_yesterday => 'Ontem';

  @override
  String get dateRange_last7Days => 'Últimos 7 dias';

  @override
  String get dateRange_last30Days => 'Últimos 30 dias';

  @override
  String get dateRange_thisMonth => 'Este mês';

  @override
  String get dateRange_lastMonth => 'Mês passado';

  @override
  String get dateRange_last90Days => 'Últimos 90 dias';

  @override
  String get dateRange_yearToDate => 'Ano até agora';

  @override
  String get dateRange_allTime => 'Todo o período';

  @override
  String get dateRange_custom => 'Personalizado...';

  @override
  String get dateRange_compareToPrevious => 'Comparar com período anterior';

  @override
  String get export_keywordsTitle => 'Exportar palavras-chave';

  @override
  String get export_reviewsTitle => 'Exportar avaliações';

  @override
  String get export_analyticsTitle => 'Exportar análises';

  @override
  String get export_columnsToInclude => 'Colunas a incluir:';

  @override
  String get export_button => 'Exportar';

  @override
  String get export_keyword => 'Palavra-chave';

  @override
  String get export_position => 'Posição';

  @override
  String get export_change => 'Variação';

  @override
  String get export_popularity => 'Popularidade';

  @override
  String get export_difficulty => 'Dificuldade';

  @override
  String get export_tags => 'Tags';

  @override
  String get export_notes => 'Notas';

  @override
  String get export_trackedSince => 'Acompanhado desde';

  @override
  String get export_date => 'Data';

  @override
  String get export_rating => 'Nota';

  @override
  String get export_author => 'Autor';

  @override
  String get export_title => 'Título';

  @override
  String get export_content => 'Conteúdo';

  @override
  String get export_country => 'País';

  @override
  String get export_version => 'Versão';

  @override
  String get export_sentiment => 'Sentimento';

  @override
  String get export_response => 'Nossa resposta';

  @override
  String get export_responseDate => 'Data da resposta';

  @override
  String export_keywordsCount(int count) {
    return '$count palavras-chave serão exportadas';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count avaliações serão exportadas';
  }

  @override
  String export_success(String filename) {
    return 'Exportação salva: $filename';
  }

  @override
  String export_error(String error) {
    return 'Falha na exportação: $error';
  }

  @override
  String get metadata_editor => 'Editor de metadados';

  @override
  String get metadata_selectLocale => 'Selecione um idioma para editar';

  @override
  String get metadata_refreshed => 'Metadados atualizados da loja';

  @override
  String get metadata_connectRequired => 'Conexão necessária para editar';

  @override
  String get metadata_connectDescription =>
      'Conecte sua conta do App Store Connect para editar os metadados do seu app diretamente do Keyrank.';

  @override
  String get metadata_connectStore => 'Conectar App Store';

  @override
  String get metadata_publishTitle => 'Publicar metadados';

  @override
  String metadata_publishConfirm(String locale) {
    return 'Publicar alterações para $locale? Isso atualizará a página do seu app na App Store.';
  }

  @override
  String get metadata_publish => 'Publicar';

  @override
  String get metadata_publishSuccess => 'Metadados publicados com sucesso';

  @override
  String get metadata_saveDraft => 'Salvar rascunho';

  @override
  String get metadata_draftSaved => 'Rascunho salvo';

  @override
  String get metadata_discardChanges => 'Descartar alterações';

  @override
  String get metadata_title => 'Título';

  @override
  String metadata_titleHint(int limit) {
    return 'Nome do app (máx. $limit car.)';
  }

  @override
  String get metadata_subtitle => 'Subtítulo';

  @override
  String metadata_subtitleHint(int limit) {
    return 'Frase de efeito curta (máx. $limit car.)';
  }

  @override
  String get metadata_keywords => 'Palavras-chave';

  @override
  String metadata_keywordsHint(int limit) {
    return 'Palavras-chave separadas por vírgulas (máx. $limit car.)';
  }

  @override
  String get metadata_description => 'Descrição';

  @override
  String metadata_descriptionHint(int limit) {
    return 'Descrição completa do app (máx. $limit car.)';
  }

  @override
  String get metadata_promotionalText => 'Texto promocional';

  @override
  String metadata_promotionalTextHint(int limit) {
    return 'Mensagem promocional curta (máx. $limit car.)';
  }

  @override
  String get metadata_whatsNew => 'Novidades';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'Notas de versão (máx. $limit car.)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => 'Alterações não salvas';

  @override
  String get metadata_noChanges => 'Nenhuma alteração';

  @override
  String get metadata_keywordAnalysis => 'Análise de palavras-chave';

  @override
  String get metadata_keywordPresent => 'Presente';

  @override
  String get metadata_keywordMissing => 'Ausente';

  @override
  String get metadata_inTitle => 'No título';

  @override
  String get metadata_inSubtitle => 'No subtítulo';

  @override
  String get metadata_inKeywords => 'Nas palavras-chave';

  @override
  String get metadata_inDescription => 'Na descrição';

  @override
  String get metadata_history => 'Histórico de alterações';

  @override
  String get metadata_noHistory => 'Nenhuma alteração registrada';

  @override
  String get metadata_localeComplete => 'Completo';

  @override
  String get metadata_localeIncomplete => 'Incompleto';

  @override
  String get metadata_shortDescription => 'Descrição curta';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return 'Frase exibida na pesquisa (máx. $limit car.)';
  }

  @override
  String get metadata_fullDescription => 'Descrição completa';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'Descrição completa do app (máx. $limit car.)';
  }

  @override
  String get metadata_releaseNotes => 'Notas de versão';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'Novidades desta versão (máx. $limit car.)';
  }

  @override
  String get metadata_selectAppFirst => 'Selecione um aplicativo';

  @override
  String get metadata_selectAppHint =>
      'Use o seletor de app na barra lateral ou conecte uma loja para começar.';

  @override
  String get metadata_noStoreConnection => 'Conexão com a loja necessária';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return 'Conecte sua conta $storeName para recuperar e editar os metadados do seu app.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return 'Conectar $storeName';
  }

  @override
  String get metadataLocalization => 'Localizações';

  @override
  String get metadataLive => 'Online';

  @override
  String get metadataDraft => 'Rascunho';

  @override
  String get metadataEmpty => 'Vazio';

  @override
  String metadataCoverageInsight(int count) {
    return '$count idiomas precisam de conteúdo. Considere localizar para seus principais mercados.';
  }

  @override
  String get metadataFilterAll => 'Todos';

  @override
  String get metadataFilterLive => 'Online';

  @override
  String get metadataFilterDraft => 'Rascunhos';

  @override
  String get metadataFilterEmpty => 'Vazios';

  @override
  String get metadataBulkActions => 'Ações em massa';

  @override
  String get metadataCopyTo => 'Copiar para seleção';

  @override
  String get metadataTranslateTo => 'Traduzir para seleção';

  @override
  String get metadataPublishSelected => 'Publicar seleção';

  @override
  String get metadataDeleteDrafts => 'Excluir rascunhos';

  @override
  String get metadataSelectSource => 'Selecionar idioma de origem';

  @override
  String get metadataSelectTarget => 'Selecionar idiomas de destino';

  @override
  String metadataCopySuccess(int count) {
    return 'Conteúdo copiado para $count idiomas';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return 'Traduzido para $count idiomas';
  }

  @override
  String get metadataTranslating => 'Traduzindo...';

  @override
  String get metadataNoSelection => 'Selecione idiomas primeiro';

  @override
  String get metadataSelectAll => 'Selecionar tudo';

  @override
  String get metadataDeselectAll => 'Desmarcar tudo';

  @override
  String metadataSelected(int count) {
    return '$count selecionado(s)';
  }

  @override
  String get metadataTableView => 'Visualização em tabela';

  @override
  String get metadataListView => 'Visualização em lista';

  @override
  String get metadataStatus => 'Status';

  @override
  String get metadataCompletion => 'Conclusão';

  @override
  String get common_back => 'Voltar';

  @override
  String get common_next => 'Próximo';

  @override
  String get common_edit => 'Editar';

  @override
  String get metadata_aiOptimize => 'Otimizar com IA';

  @override
  String get wizard_title => 'Assistente de otimização com IA';

  @override
  String get wizard_step => 'Etapa';

  @override
  String get wizard_of => 'de';

  @override
  String get wizard_stepTitle => 'Título';

  @override
  String get wizard_stepSubtitle => 'Subtítulo';

  @override
  String get wizard_stepKeywords => 'Palavras-chave';

  @override
  String get wizard_stepDescription => 'Descrição';

  @override
  String get wizard_stepReview => 'Revisão e salvamento';

  @override
  String get wizard_skip => 'Pular';

  @override
  String get wizard_saveDrafts => 'Salvar rascunhos';

  @override
  String get wizard_draftsSaved => 'Rascunhos salvos com sucesso';

  @override
  String get wizard_exitTitle => 'Sair do assistente?';

  @override
  String get wizard_exitMessage =>
      'Você tem alterações não salvas. Tem certeza que deseja sair?';

  @override
  String get wizard_exitConfirm => 'Sair';

  @override
  String get wizard_aiSuggestions => 'Sugestões de IA';

  @override
  String get wizard_chooseSuggestion =>
      'Escolha uma sugestão gerada pela IA ou escreva a sua';

  @override
  String get wizard_currentValue => 'Valor atual';

  @override
  String get wizard_noCurrentValue => 'Nenhum valor definido';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return 'Baseado em $keywordsCount palavras-chave acompanhadas e $competitorsCount concorrentes';
  }

  @override
  String get wizard_writeOwn => 'Escrever o meu';

  @override
  String get wizard_customPlaceholder => 'Digite seu valor personalizado...';

  @override
  String get wizard_useCustom => 'Usar personalizado';

  @override
  String get wizard_keepCurrent => 'Manter atual';

  @override
  String get wizard_recommended => 'Recomendado';

  @override
  String get wizard_characters => 'caracteres';

  @override
  String get wizard_reviewTitle => 'Revisar alterações';

  @override
  String get wizard_reviewDescription =>
      'Revise suas otimizações antes de salvá-las como rascunhos';

  @override
  String get wizard_noChanges => 'Nenhuma alteração selecionada';

  @override
  String get wizard_noChangesHint =>
      'Volte e selecione sugestões para os campos que deseja otimizar';

  @override
  String wizard_changesCount(int count) {
    return '$count campos atualizados';
  }

  @override
  String get wizard_changesSummary =>
      'Essas alterações serão salvas como rascunhos';

  @override
  String get wizard_before => 'Antes';

  @override
  String get wizard_after => 'Depois';

  @override
  String get wizard_nextStepsTitle => 'O que acontece a seguir?';

  @override
  String get wizard_nextStepsWithChanges =>
      'Suas alterações serão salvas como rascunhos. Você pode revisá-las e publicá-las no editor de metadados.';

  @override
  String get wizard_nextStepsNoChanges =>
      'Nenhuma alteração para salvar. Volte e selecione sugestões para otimizar seus metadados.';

  @override
  String get team_title => 'Gestão de equipes';

  @override
  String get team_createTeam => 'Criar equipe';

  @override
  String get team_teamName => 'Nome da equipe';

  @override
  String get team_teamNameHint => 'Digite o nome da equipe';

  @override
  String get team_description => 'Descrição (opcional)';

  @override
  String get team_descriptionHint => 'Para que é esta equipe?';

  @override
  String get team_teamNameRequired => 'Nome da equipe é obrigatório';

  @override
  String get team_teamNameMinLength =>
      'Nome da equipe deve ter pelo menos 2 caracteres';

  @override
  String get team_inviteMember => 'Convidar membro';

  @override
  String get team_emailAddress => 'Endereço de e-mail';

  @override
  String get team_emailHint => 'colega@exemplo.com';

  @override
  String get team_emailRequired => 'E-mail é obrigatório';

  @override
  String get team_emailInvalid => 'Digite um e-mail válido';

  @override
  String team_invitationSent(String email) {
    return 'Convite enviado para $email';
  }

  @override
  String get team_members => 'MEMBROS';

  @override
  String get team_invite => 'Convidar';

  @override
  String get team_pendingInvitations => 'CONVITES PENDENTES';

  @override
  String get team_noPendingInvitations => 'Sem convites pendentes';

  @override
  String get team_teamSettings => 'Configurações da equipe';

  @override
  String team_changeRole(String name) {
    return 'Alterar função de $name';
  }

  @override
  String get team_removeMember => 'Remover membro';

  @override
  String team_removeMemberConfirm(String name) {
    return 'Tem certeza que deseja remover $name desta equipe?';
  }

  @override
  String get team_remove => 'Remover';

  @override
  String get team_leaveTeam => 'Sair da equipe';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return 'Tem certeza que deseja sair de \"$teamName\"?';
  }

  @override
  String get team_leave => 'Sair';

  @override
  String get team_deleteTeam => 'Excluir equipe';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return 'Tem certeza que deseja excluir \"$teamName\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get team_yourTeams => 'SUAS EQUIPES';

  @override
  String get team_failedToLoadTeam => 'Falha ao carregar equipe';

  @override
  String get team_failedToLoadMembers => 'Falha ao carregar membros';

  @override
  String get team_failedToLoadInvitations => 'Falha ao carregar convites';

  @override
  String team_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String team_invitedAs(String role) {
    return 'Convidado como $role';
  }

  @override
  String team_joinedTeam(String teamName) {
    return 'Entrou em $teamName';
  }

  @override
  String get team_invitationDeclined => 'Convite recusado';

  @override
  String get team_noTeamsYet => 'Nenhuma equipe ainda';

  @override
  String get team_noTeamsDescription =>
      'Crie uma equipe para colaborar com outros nos seus apps';

  @override
  String get team_createFirstTeam => 'Criar sua primeira equipe';

  @override
  String get integrations_title => 'Integrações';

  @override
  String integrations_syncFailed(String error) {
    return 'Falha na sincronização: $error';
  }

  @override
  String get integrations_disconnectConfirm => 'Desconectar?';

  @override
  String get integrations_disconnectedSuccess => 'Desconectado com sucesso';

  @override
  String get integrations_connectGooglePlay => 'Conectar Google Play Console';

  @override
  String get integrations_connectAppStore => 'Conectar App Store Connect';

  @override
  String integrations_connectedApps(int count) {
    return 'Conectado! $count apps importados.';
  }

  @override
  String integrations_syncedApps(int count) {
    return '$count apps sincronizados como proprietário';
  }

  @override
  String get integrations_appStoreConnected =>
      'App Store Connect conectado com sucesso!';

  @override
  String get integrations_googlePlayConnected =>
      'Google Play Console conectado com sucesso!';

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
  String get alertBuilder_nameYourRule => 'NOMEIE SUA REGRA';

  @override
  String get alertBuilder_nameDescription =>
      'Dê um nome descritivo à sua regra de alerta';

  @override
  String get alertBuilder_nameHint => 'ex: Alerta de posição diária';

  @override
  String get alertBuilder_summary => 'RESUMO';

  @override
  String get alertBuilder_saveAlertRule => 'Salvar regra de alerta';

  @override
  String get alertBuilder_selectAlertType => 'SELECIONAR TIPO DE ALERTA';

  @override
  String get alertBuilder_selectAlertTypeDescription =>
      'Escolha que tipo de alerta deseja criar';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return 'Isso excluirá \"$ruleName\".';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate =>
      'Sem regras ainda. Ative um modelo ou crie a sua!';

  @override
  String get billing_cancelSubscription => 'Cancelar assinatura';

  @override
  String get billing_keepSubscription => 'Manter assinatura';

  @override
  String get billing_billingPortal => 'Portal de cobrança';

  @override
  String get billing_resume => 'Retomar';

  @override
  String get keywords_noCompetitorsFound =>
      'Nenhum concorrente encontrado. Adicione concorrentes primeiro.';

  @override
  String get keywords_noCompetitorsForApp =>
      'Nenhum concorrente para este app. Adicione um concorrente primeiro.';

  @override
  String keywords_failedToAddKeywords(String error) {
    return 'Falha ao adicionar palavras-chave: $error';
  }

  @override
  String get keywords_bulkAddHint =>
      'rastreador de orçamento\ngerenciador de despesas\napp de dinheiro';

  @override
  String get appOverview_urlCopied =>
      'URL da loja copiada para a área de transferência';

  @override
  String get country_us => 'Estados Unidos';

  @override
  String get country_gb => 'Reino Unido';

  @override
  String get country_fr => 'França';

  @override
  String get country_de => 'Alemanha';

  @override
  String get country_ca => 'Canadá';

  @override
  String get country_au => 'Austrália';

  @override
  String get country_jp => 'Japão';

  @override
  String get country_cn => 'China';

  @override
  String get country_kr => 'Coreia do Sul';

  @override
  String get country_br => 'Brasil';

  @override
  String get country_es => 'Espanha';

  @override
  String get country_it => 'Itália';

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
  String get alertBuilder_type => 'Tipo';

  @override
  String get alertBuilder_scope => 'Escopo';

  @override
  String get alertBuilder_name => 'Nome';

  @override
  String get alertBuilder_scopeGlobal => 'Todos os apps';

  @override
  String get alertBuilder_scopeApp => 'App específico';

  @override
  String get alertBuilder_scopeCategory => 'Categoria';

  @override
  String get alertBuilder_scopeKeyword => 'Palavra-chave';

  @override
  String get alertType_positionChange => 'Mudança de posição';

  @override
  String get alertType_positionChangeDesc =>
      'Alerta quando o ranking muda significativamente';

  @override
  String get alertType_ratingChange => 'Mudança de avaliação';

  @override
  String get alertType_ratingChangeDesc => 'Alerta quando a avaliação muda';

  @override
  String get alertType_reviewSpike => 'Pico de avaliações';

  @override
  String get alertType_reviewSpikeDesc =>
      'Alerta por atividade incomum de avaliações';

  @override
  String get alertType_reviewKeyword => 'Palavra-chave em avaliações';

  @override
  String get alertType_reviewKeywordDesc =>
      'Alerta quando palavras-chave aparecem em avaliações';

  @override
  String get alertType_newCompetitor => 'Novo concorrente';

  @override
  String get alertType_newCompetitorDesc =>
      'Alerta quando novos apps entram no seu espaço';

  @override
  String get alertType_competitorPassed => 'Concorrente ultrapassado';

  @override
  String get alertType_competitorPassedDesc =>
      'Alerta quando você ultrapassa um concorrente';

  @override
  String get alertType_massMovement => 'Movimento em massa';

  @override
  String get alertType_massMovementDesc =>
      'Alerta por grandes mudanças de ranking';

  @override
  String get alertType_keywordTrend => 'Tendência de palavra-chave';

  @override
  String get alertType_keywordTrendDesc =>
      'Alerta quando a popularidade de uma palavra-chave muda';

  @override
  String get alertType_opportunity => 'Oportunidade';

  @override
  String get alertType_opportunityDesc =>
      'Alerta sobre novas oportunidades de ranking';

  @override
  String get billing_title => 'Faturamento e Planos';

  @override
  String get billing_subscriptionActivated => 'Assinatura ativada com sucesso!';

  @override
  String get billing_changePlan => 'Alterar plano';

  @override
  String get billing_choosePlan => 'Escolher um plano';

  @override
  String get billing_cancelMessage =>
      'Sua assinatura permanecerá ativa até o final do período de faturamento atual. Depois disso, você perderá acesso aos recursos premium.';

  @override
  String get billing_currentPlan => 'PLANO ATUAL';

  @override
  String get billing_trial => 'TESTE';

  @override
  String get billing_canceling => 'CANCELANDO';

  @override
  String billing_accessUntil(String date) {
    return 'Acesso até $date';
  }

  @override
  String billing_renewsOn(String date) {
    return 'Renova em $date';
  }

  @override
  String get billing_manageSubscription => 'GERENCIAR ASSINATURA';

  @override
  String get billing_monthly => 'Mensal';

  @override
  String get billing_yearly => 'Anual';

  @override
  String billing_savePercent(int percent) {
    return 'Economize $percent%';
  }

  @override
  String get billing_current => 'Atual';

  @override
  String get billing_apps => 'Apps';

  @override
  String get billing_unlimited => 'Ilimitado';

  @override
  String get billing_keywordsPerApp => 'Palavras-chave por app';

  @override
  String get billing_history => 'Histórico';

  @override
  String billing_days(int count) {
    return '$count dias';
  }

  @override
  String get billing_exports => 'Exportações';

  @override
  String get billing_aiInsights => 'Análises IA';

  @override
  String get billing_apiAccess => 'Acesso API';

  @override
  String get billing_yes => 'Sim';

  @override
  String get billing_no => 'Não';

  @override
  String get billing_currentPlanButton => 'Plano atual';

  @override
  String billing_upgradeTo(String planName) {
    return 'Atualizar para $planName';
  }

  @override
  String get billing_cancel => 'Cancelar';

  @override
  String get keywords_compareWithCompetitor => 'Comparar com concorrente';

  @override
  String get keywords_selectCompetitorToCompare =>
      'Selecione um concorrente para comparar palavras-chave:';

  @override
  String get keywords_addToCompetitor => 'Adicionar a concorrente';

  @override
  String keywords_addKeywordsTo(int count) {
    return 'Adicionar $count palavra(s)-chave a:';
  }

  @override
  String get keywords_avgPosition => 'Posição média';

  @override
  String get keywords_declined => 'Em queda';

  @override
  String get keywords_total => 'Total';

  @override
  String get keywords_ranked => 'Classificados';

  @override
  String get keywords_improved => 'Melhorados';

  @override
  String get onboarding_skip => 'Pular';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_getStarted => 'Começar';

  @override
  String get onboarding_welcomeToKeyrank => 'Bem-vindo ao Keyrank';

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
  String get team_you => 'Você';

  @override
  String get team_changeRoleButton => 'Change Role';

  @override
  String get team_removeButton => 'Remove';

  @override
  String get competitors_removeTitle => 'Remove Competitor';

  @override
  String competitors_removeConfirm(String name) {
    return 'Tem certeza de que deseja remover \"$name\" dos seus concorrentes?';
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
    return 'Falha ao adicionar concorrente: $error';
  }

  @override
  String get competitors_searchForCompetitor => 'Search for a competitor';

  @override
  String get appPreview_back => 'Back';

  @override
  String get alerts_edit => 'Editar';

  @override
  String get alerts_scopeGlobal => 'Global';

  @override
  String get alerts_scopeApp => 'App';

  @override
  String get alerts_scopeCategory => 'Categoria';

  @override
  String get alerts_scopeKeyword => 'Palavra-chave';

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
    return 'Ver mais $count insights';
  }

  @override
  String get insights_noInsightsDesc =>
      'Os insights aparecerão quando descobrirmos oportunidades de otimização para seu app.';

  @override
  String get insights_loadFailed => 'Falha ao carregar insights';

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
