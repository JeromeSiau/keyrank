// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTagline => 'Rastree sus rankings en App Store';

  @override
  String get auth_welcomeBack => 'Bienvenido de nuevo';

  @override
  String get auth_signInSubtitle => 'Inicie sesión en su cuenta';

  @override
  String get auth_createAccount => 'Crear cuenta';

  @override
  String get auth_createAccountSubtitle => 'Comience a rastrear sus rankings';

  @override
  String get auth_emailLabel => 'Correo electrónico';

  @override
  String get auth_passwordLabel => 'Contraseña';

  @override
  String get auth_nameLabel => 'Nombre';

  @override
  String get auth_confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get auth_signInButton => 'Iniciar sesión';

  @override
  String get auth_signUpButton => 'Crear cuenta';

  @override
  String get auth_noAccount => '¿No tiene una cuenta?';

  @override
  String get auth_hasAccount => '¿Ya tiene una cuenta?';

  @override
  String get auth_signUpLink => 'Regístrese';

  @override
  String get auth_signInLink => 'Iniciar sesión';

  @override
  String get auth_emailRequired => 'Por favor ingrese su correo electrónico';

  @override
  String get auth_emailInvalid => 'Correo electrónico inválido';

  @override
  String get auth_passwordRequired => 'Por favor ingrese su contraseña';

  @override
  String get auth_enterPassword => 'Por favor ingrese una contraseña';

  @override
  String get auth_nameRequired => 'Por favor ingrese su nombre';

  @override
  String get auth_passwordMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get auth_passwordsNoMatch => 'Las contraseñas no coinciden';

  @override
  String get auth_errorOccurred => 'Ha ocurrido un error';

  @override
  String get common_retry => 'Reintentar';

  @override
  String common_error(String message) {
    return 'Error: $message';
  }

  @override
  String get common_loading => 'Cargando...';

  @override
  String get common_add => 'Agregar';

  @override
  String get common_filter => 'Filtrar';

  @override
  String get common_sort => 'Ordenar';

  @override
  String get common_refresh => 'Actualizar';

  @override
  String get common_settings => 'Configuración';

  @override
  String get common_search => 'Buscar...';

  @override
  String get common_noResults => 'Sin resultados';

  @override
  String get dashboard_title => 'Panel de control';

  @override
  String get dashboard_addApp => 'Agregar app';

  @override
  String get dashboard_appsTracked => 'Apps rastreadas';

  @override
  String get dashboard_keywords => 'Palabras clave';

  @override
  String get dashboard_avgPosition => 'Posición promedio';

  @override
  String get dashboard_top10 => 'Top 10';

  @override
  String get dashboard_trackedApps => 'Apps rastreadas';

  @override
  String get dashboard_quickActions => 'Acciones rápidas';

  @override
  String get dashboard_addNewApp => 'Agregar una nueva app';

  @override
  String get dashboard_searchKeywords => 'Buscar palabras clave';

  @override
  String get dashboard_viewAllApps => 'Ver todas las apps';

  @override
  String get dashboard_noAppsYet => 'Aún no hay apps rastreadas';

  @override
  String get dashboard_addAppToStart =>
      'Agregue una app para comenzar a rastrear palabras clave';

  @override
  String get dashboard_noAppsMatchFilter =>
      'Ninguna app coincide con el filtro';

  @override
  String get dashboard_changeFilterCriteria =>
      'Intente cambiar los criterios del filtro';

  @override
  String get dashboard_reviews => 'Reseñas';

  @override
  String get dashboard_avgRating => 'Calificación promedio';

  @override
  String get dashboard_topPerformingApps => 'Apps con mejor rendimiento';

  @override
  String get dashboard_topCountries => 'Principales países';

  @override
  String get dashboard_sentimentOverview => 'Resumen de sentimiento';

  @override
  String get dashboard_overallSentiment => 'Sentimiento general';

  @override
  String get dashboard_positive => 'Positivo';

  @override
  String get dashboard_positiveReviews => 'Positivo';

  @override
  String get dashboard_negativeReviews => 'Negativo';

  @override
  String get dashboard_viewReviews => 'Ver reseñas';

  @override
  String get dashboard_tableApp => 'APP';

  @override
  String get dashboard_tableKeywords => 'PALABRAS CLAVE';

  @override
  String get dashboard_tableAvgRank => 'RANG. PROM.';

  @override
  String get dashboard_tableTrend => 'TENDENCIA';

  @override
  String get dashboard_connectYourStores => 'Conecte sus tiendas';

  @override
  String get dashboard_connectStoresDescription =>
      'Vincule App Store Connect o Google Play para importar sus apps y responder a las reseñas.';

  @override
  String get dashboard_connect => 'Conectar';

  @override
  String get apps_title => 'Mis Apps';

  @override
  String apps_appCount(int count) {
    return '$count apps';
  }

  @override
  String get apps_tableApp => 'APP';

  @override
  String get apps_tableDeveloper => 'DESARROLLADOR';

  @override
  String get apps_tableKeywords => 'PALABRAS CLAVE';

  @override
  String get apps_tablePlatform => 'PLATAFORMA';

  @override
  String get apps_tableRating => 'CALIFICACIÓN';

  @override
  String get apps_tableBestRank => 'MEJOR POSICIÓN';

  @override
  String get apps_noAppsYet => 'Aún no hay apps rastreadas';

  @override
  String get apps_addAppToStart =>
      'Agregue una app para comenzar a rastrear sus rankings';

  @override
  String get addApp_title => 'Agregar App';

  @override
  String get addApp_searchAppStore => 'Buscar en App Store...';

  @override
  String get addApp_searchPlayStore => 'Buscar en Play Store...';

  @override
  String get addApp_searchForApp => 'Buscar una app';

  @override
  String get addApp_enterAtLeast2Chars => 'Ingrese al menos 2 caracteres';

  @override
  String get addApp_noResults => 'No se encontraron resultados';

  @override
  String addApp_addedSuccess(String name) {
    return '$name agregado exitosamente';
  }

  @override
  String get settings_title => 'Configuración';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_appearance => 'Apariencia';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_themeSystem => 'Sistema';

  @override
  String get settings_themeDark => 'Oscuro';

  @override
  String get settings_themeLight => 'Claro';

  @override
  String get settings_account => 'Cuenta';

  @override
  String get settings_memberSince => 'Miembro desde';

  @override
  String get settings_logout => 'Cerrar sesión';

  @override
  String get settings_languageSystem => 'Sistema';

  @override
  String get filter_all => 'Todos';

  @override
  String get filter_allApps => 'Todas las apps';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'Solo iOS';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Solo Android';

  @override
  String get filter_favorites => 'Favoritos';

  @override
  String get sort_recent => 'Reciente';

  @override
  String get sort_recentlyAdded => 'Agregado recientemente';

  @override
  String get sort_nameAZ => 'Nombre A-Z';

  @override
  String get sort_nameZA => 'Nombre Z-A';

  @override
  String get sort_keywords => 'Palabras clave';

  @override
  String get sort_mostKeywords => 'Más palabras clave';

  @override
  String get sort_bestRank => 'Mejor posición';

  @override
  String get userMenu_logout => 'Cerrar sesión';

  @override
  String get insights_compareTitle => 'Comparar análisis';

  @override
  String get insights_analyzingReviews => 'Analizando reseñas...';

  @override
  String get insights_noInsightsAvailable => 'No hay análisis disponibles';

  @override
  String get insights_strengths => 'Fortalezas';

  @override
  String get insights_weaknesses => 'Debilidades';

  @override
  String get insights_scores => 'Puntuaciones';

  @override
  String get insights_opportunities => 'Oportunidades';

  @override
  String get insights_categoryUx => 'UX';

  @override
  String get insights_categoryPerf => 'Rend.';

  @override
  String get insights_categoryFeatures => 'Funciones';

  @override
  String get insights_categoryPricing => 'Precios';

  @override
  String get insights_categorySupport => 'Soporte';

  @override
  String get insights_categoryOnboard => 'Inicio';

  @override
  String get insights_categoryUxFull => 'UX / Interfaz';

  @override
  String get insights_categoryPerformance => 'Rendimiento';

  @override
  String get insights_categoryOnboarding => 'Incorporación';

  @override
  String get insights_reviewInsights => 'Análisis de reseñas';

  @override
  String get insights_generateFirst => 'Genere primero los análisis';

  @override
  String get insights_compareWithOther => 'Comparar con otras apps';

  @override
  String get insights_compare => 'Comparar';

  @override
  String get insights_generateAnalysis => 'Generar análisis';

  @override
  String get insights_period => 'Período:';

  @override
  String get insights_3months => '3 meses';

  @override
  String get insights_6months => '6 meses';

  @override
  String get insights_12months => '12 meses';

  @override
  String get insights_analyze => 'Analizar';

  @override
  String insights_reviewsCount(int count) {
    return '$count reseñas';
  }

  @override
  String insights_analyzedAgo(String time) {
    return 'Analizado $time';
  }

  @override
  String get insights_yourNotes => 'Sus notas';

  @override
  String get insights_save => 'Guardar';

  @override
  String get insights_clickToAddNotes => 'Haga clic para agregar notas...';

  @override
  String get insights_noteSaved => 'Nota guardada';

  @override
  String get insights_noteHint => 'Agregue sus notas sobre este análisis...';

  @override
  String get insights_categoryScores => 'Puntuaciones por categoría';

  @override
  String get insights_emergentThemes => 'Temas emergentes';

  @override
  String get insights_exampleQuotes => 'Citas de ejemplo:';

  @override
  String get insights_selectCountryFirst => 'Seleccione al menos un país';

  @override
  String get insights_title => 'Análisis';

  @override
  String insights_titleWithApp(String appName) {
    return 'Análisis - $appName';
  }

  @override
  String get insights_allApps => 'Análisis (Todas las apps)';

  @override
  String get insights_noInsightsYet => 'Aún no hay insights';

  @override
  String get insights_selectAppToGenerate =>
      'Seleccione una app para generar análisis a partir de las reseñas';

  @override
  String insights_appsWithInsights(int count) {
    return '$count apps con análisis';
  }

  @override
  String get insights_errorLoading => 'Error al cargar los análisis';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '$count reseñas analizadas';
  }

  @override
  String get insights_avgScore => 'puntuación promedio';

  @override
  String insights_updatedOn(String date) {
    return 'Actualizado el $date';
  }

  @override
  String compare_selectAppsToCompare(String appName) {
    return 'Seleccione hasta 3 apps para comparar con $appName';
  }

  @override
  String get compare_searchApps => 'Buscar apps...';

  @override
  String get compare_noOtherApps => 'No hay otras apps para comparar';

  @override
  String get compare_noMatchingApps => 'No hay apps que coincidan';

  @override
  String compare_appsSelected(int count) {
    return '$count de 3 apps seleccionadas';
  }

  @override
  String get compare_cancel => 'Cancelar';

  @override
  String compare_button(int count) {
    return 'Comparar $count apps';
  }

  @override
  String get appDetail_deleteAppTitle => '¿Eliminar app?';

  @override
  String get appDetail_deleteAppConfirm => 'Esta acción no se puede deshacer.';

  @override
  String get appDetail_cancel => 'Cancelar';

  @override
  String get appDetail_delete => 'Eliminar';

  @override
  String get appDetail_exporting => 'Exportando rankings...';

  @override
  String appDetail_savedFile(String filename) {
    return 'Guardado: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Mostrar en Finder';

  @override
  String appDetail_exportFailed(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return '$imported palabras clave importadas ($skipped omitidas)';
  }

  @override
  String get appDetail_favorite => 'Favorito';

  @override
  String get appDetail_ratings => 'Calificaciones';

  @override
  String get appDetail_insights => 'Análisis';

  @override
  String get appDetail_import => 'Importar';

  @override
  String get appDetail_export => 'Exportar';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count reseñas';
  }

  @override
  String get appDetail_keywords => 'palabras clave';

  @override
  String get appDetail_addKeyword => 'Agregar palabra clave';

  @override
  String get appDetail_keywordHint => 'ej.: rastreador fitness';

  @override
  String get appDetail_trackedKeywords => 'Palabras clave rastreadas';

  @override
  String appDetail_selectedCount(int count) {
    return '$count seleccionadas';
  }

  @override
  String get appDetail_allKeywords => 'Todas las palabras clave';

  @override
  String get appDetail_hasTags => 'Con etiquetas';

  @override
  String get appDetail_hasNotes => 'Con notas';

  @override
  String get appDetail_position => 'Posición';

  @override
  String get appDetail_select => 'Seleccionar';

  @override
  String get appDetail_suggestions => 'Sugerencias';

  @override
  String get appDetail_deleteKeywordsTitle => 'Eliminar palabras clave';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return '¿Está seguro de que desea eliminar $count palabras clave?';
  }

  @override
  String get appDetail_tag => 'Etiqueta';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return 'Palabra clave \"$keyword\" agregada ($flag)';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return 'Etiquetas agregadas a $count palabras clave';
  }

  @override
  String get appDetail_keywordsAddedSuccess =>
      'Palabras clave agregadas exitosamente';

  @override
  String get appDetail_noTagsAvailable =>
      'No hay etiquetas disponibles. Cree etiquetas primero.';

  @override
  String get appDetail_tagged => 'Etiquetadas';

  @override
  String get appDetail_withNotes => 'Con notas';

  @override
  String get appDetail_nameAZ => 'Nombre A-Z';

  @override
  String get appDetail_nameZA => 'Nombre Z-A';

  @override
  String get appDetail_bestPosition => 'Mejor posición';

  @override
  String get appDetail_recentlyTracked => 'Rastreadas recientemente';

  @override
  String get keywordSuggestions_title => 'Sugerencias de palabras clave';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$appName en $country';
  }

  @override
  String get keywordSuggestions_refresh => 'Actualizar sugerencias';

  @override
  String get keywordSuggestions_search => 'Buscar en sugerencias...';

  @override
  String get keywordSuggestions_selectAll => 'Seleccionar todo';

  @override
  String get keywordSuggestions_clear => 'Limpiar';

  @override
  String get keywordSuggestions_analyzing =>
      'Analizando metadatos de la app...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds =>
      'Esto puede tardar unos segundos';

  @override
  String get keywordSuggestions_noSuggestions =>
      'No hay sugerencias disponibles';

  @override
  String get keywordSuggestions_noMatchingSuggestions =>
      'No hay sugerencias que coincidan';

  @override
  String get keywordSuggestions_headerKeyword => 'PALABRA CLAVE';

  @override
  String get keywordSuggestions_headerDifficulty => 'DIFICULTAD';

  @override
  String get keywordSuggestions_headerApps => 'APPS';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return 'Posición #$position';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count palabras clave seleccionadas';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return 'Agregar $count palabras clave';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Error al agregar palabras clave: $error';
  }

  @override
  String get keywordSuggestions_categoryAll => 'Todas';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'Oportunidades';

  @override
  String get keywordSuggestions_categoryCompetitor =>
      'Palabras clave de competidores';

  @override
  String get keywordSuggestions_categoryLongTail => 'Long-tail';

  @override
  String get keywordSuggestions_categoryTrending => 'Tendencias';

  @override
  String get keywordSuggestions_categoryRelated => 'Relacionadas';

  @override
  String get keywordSuggestions_generating => 'Generando sugerencias...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      'Esto puede tardar unos minutos. Vuelva más tarde.';

  @override
  String get keywordSuggestions_checkAgain => 'Verificar de nuevo';

  @override
  String get sidebar_favorites => 'FAVORITOS';

  @override
  String get sidebar_tooManyFavorites =>
      'Considere mantener 5 o menos favoritos';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Búsqueda de palabras clave';

  @override
  String get keywordSearch_searchPlaceholder => 'Buscar palabras clave...';

  @override
  String get keywordSearch_searchTitle => 'Buscar una palabra clave';

  @override
  String get keywordSearch_searchSubtitle =>
      'Descubra qué apps se posicionan para cualquier palabra clave';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count apps posicionadas';
  }

  @override
  String get keywordSearch_popularity => 'Popularidad';

  @override
  String keywordSearch_results(int count) {
    return '$count resultados';
  }

  @override
  String get keywordSearch_headerRank => 'POSICIÓN';

  @override
  String get keywordSearch_headerApp => 'APP';

  @override
  String get keywordSearch_headerRating => 'CALIFICACIÓN';

  @override
  String get keywordSearch_headerTrack => 'RASTREAR';

  @override
  String get keywordSearch_trackApp => 'Rastrear esta app';

  @override
  String get discover_title => 'Descubrir';

  @override
  String get discover_tabKeywords => 'Palabras clave';

  @override
  String get discover_tabCategories => 'Categorías';

  @override
  String get discover_selectCategory => 'Seleccionar una categoría';

  @override
  String get discover_topFree => 'Gratuitas';

  @override
  String get discover_topPaid => 'De pago';

  @override
  String get discover_topGrossing => 'Más rentables';

  @override
  String get discover_noResults => 'Sin resultados';

  @override
  String get discover_loadingTopApps => 'Cargando top apps...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return 'Top $collection en $category';
  }

  @override
  String discover_appsCount(int count) {
    return '$count apps';
  }

  @override
  String get discover_allCategories => 'Todas las categorías';

  @override
  String get category_games => 'Juegos';

  @override
  String get category_business => 'Negocios';

  @override
  String get category_education => 'Educación';

  @override
  String get category_entertainment => 'Entretenimiento';

  @override
  String get category_finance => 'Finanzas';

  @override
  String get category_food_drink => 'Comida y bebida';

  @override
  String get category_health_fitness => 'Salud y fitness';

  @override
  String get category_lifestyle => 'Estilo de vida';

  @override
  String get category_medical => 'Medicina';

  @override
  String get category_music => 'Música';

  @override
  String get category_navigation => 'Navegación';

  @override
  String get category_news => 'Noticias';

  @override
  String get category_photo_video => 'Foto y video';

  @override
  String get category_productivity => 'Productividad';

  @override
  String get category_reference => 'Referencia';

  @override
  String get category_shopping => 'Compras';

  @override
  String get category_social => 'Redes sociales';

  @override
  String get category_sports => 'Deportes';

  @override
  String get category_travel => 'Viajes';

  @override
  String get category_utilities => 'Utilidades';

  @override
  String get category_weather => 'Clima';

  @override
  String get category_books => 'Libros';

  @override
  String get category_developer_tools => 'Herramientas de desarrollo';

  @override
  String get category_graphics_design => 'Gráficos y diseño';

  @override
  String get category_magazines => 'Revistas y periódicos';

  @override
  String get category_stickers => 'Stickers';

  @override
  String get category_catalogs => 'Catálogos';

  @override
  String get category_art_design => 'Arte y diseño';

  @override
  String get category_auto_vehicles => 'Auto y vehículos';

  @override
  String get category_beauty => 'Belleza';

  @override
  String get category_comics => 'Cómics';

  @override
  String get category_communication => 'Comunicación';

  @override
  String get category_dating => 'Citas';

  @override
  String get category_events => 'Eventos';

  @override
  String get category_house_home => 'Casa y hogar';

  @override
  String get category_libraries => 'Bibliotecas';

  @override
  String get category_maps_navigation => 'Mapas y navegación';

  @override
  String get category_music_audio => 'Música y audio';

  @override
  String get category_news_magazines => 'Noticias y revistas';

  @override
  String get category_parenting => 'Paternidad';

  @override
  String get category_personalization => 'Personalización';

  @override
  String get category_photography => 'Fotografía';

  @override
  String get category_tools => 'Herramientas';

  @override
  String get category_video_players => 'Reproductores de video';

  @override
  String get category_all_apps => 'Todas las apps';

  @override
  String reviews_reviewsFor(String appName) {
    return 'Reseñas de $appName';
  }

  @override
  String get reviews_loading => 'Cargando reseñas...';

  @override
  String get reviews_noReviews => 'Sin reseñas';

  @override
  String reviews_noReviewsFor(String countryName) {
    return 'No se encontraron reseñas para $countryName';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'Mostrando las $count reseñas más recientes de App Store.';
  }

  @override
  String get reviews_today => 'Hoy';

  @override
  String get reviews_yesterday => 'Ayer';

  @override
  String reviews_daysAgo(int count) {
    return 'Hace $count días';
  }

  @override
  String reviews_weeksAgo(int count) {
    return 'Hace $count semanas';
  }

  @override
  String reviews_monthsAgo(int count) {
    return 'Hace $count meses';
  }

  @override
  String get ratings_byCountry => 'Calificaciones por país';

  @override
  String get ratings_noRatingsAvailable => 'No hay calificaciones disponibles';

  @override
  String get ratings_noRatingsYet => 'Esta app aún no tiene calificaciones';

  @override
  String get ratings_totalRatings => 'Total de calificaciones';

  @override
  String get ratings_averageRating => 'Calificación promedio';

  @override
  String ratings_countriesCount(int count) {
    return '$count países';
  }

  @override
  String ratings_updated(String date) {
    return 'Actualizado: $date';
  }

  @override
  String get ratings_headerCountry => 'PAÍS';

  @override
  String get ratings_headerRatings => 'CALIFICACIONES';

  @override
  String get ratings_headerAverage => 'PROMEDIO';

  @override
  String time_minutesAgo(int count) {
    return 'Hace ${count}m';
  }

  @override
  String time_hoursAgo(int count) {
    return 'Hace ${count}h';
  }

  @override
  String time_daysAgo(int count) {
    return 'Hace ${count}d';
  }

  @override
  String get appDetail_noKeywordsTracked => 'No hay palabras clave rastreadas';

  @override
  String get appDetail_addKeywordHint =>
      'Agregue una palabra clave arriba para comenzar a rastrear';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Ninguna palabra clave coincide con el filtro';

  @override
  String get appDetail_tryChangingFilter =>
      'Intente cambiar los criterios del filtro';

  @override
  String get appDetail_addTag => 'Agregar etiqueta';

  @override
  String get appDetail_addNote => 'Agregar nota';

  @override
  String get appDetail_positionHistory => 'Historial de posiciones';

  @override
  String get appDetail_store => 'TIENDA';

  @override
  String get nav_overview => 'RESUMEN';

  @override
  String get nav_dashboard => 'Panel de control';

  @override
  String get nav_myApps => 'Mis Apps';

  @override
  String get nav_research => 'INVESTIGACIÓN';

  @override
  String get nav_keywords => 'Palabras clave';

  @override
  String get nav_discover => 'Descubrir';

  @override
  String get nav_engagement => 'INTERACCIÓN';

  @override
  String get nav_reviewsInbox => 'Bandeja de entrada';

  @override
  String get nav_notifications => 'Alertas';

  @override
  String get nav_optimization => 'OPTIMIZACIÓN';

  @override
  String get nav_keywordInspector => 'Inspector de palabras clave';

  @override
  String get nav_ratingsAnalysis => 'Análisis de calificaciones';

  @override
  String get nav_intelligence => 'INTELIGENCIA';

  @override
  String get nav_topCharts => 'Top Charts';

  @override
  String get nav_competitors => 'Competidores';

  @override
  String get common_save => 'Guardar';

  @override
  String get appDetail_manageTags => 'Gestionar etiquetas';

  @override
  String get appDetail_newTagHint => 'Nombre de nueva etiqueta...';

  @override
  String get appDetail_availableTags => 'Etiquetas disponibles';

  @override
  String get appDetail_noTagsYet => 'Sin etiquetas aún. Cree una arriba.';

  @override
  String get appDetail_addTagsTitle => 'Agregar etiquetas';

  @override
  String get appDetail_selectTagsDescription =>
      'Seleccione las etiquetas para agregar a las palabras clave seleccionadas:';

  @override
  String appDetail_addTagsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'etiquetas',
      one: 'etiqueta',
    );
    return 'Agregar $count $_temp0';
  }

  @override
  String get appDetail_currentTags => 'Etiquetas actuales';

  @override
  String get appDetail_noTagsOnKeyword => 'Sin etiquetas en esta palabra clave';

  @override
  String get appDetail_addExistingTag => 'Agregar etiqueta existente';

  @override
  String get appDetail_allTagsUsed => 'Todas las etiquetas ya están en uso';

  @override
  String get appDetail_createNewTag => 'Crear nueva etiqueta';

  @override
  String get appDetail_tagNameHint => 'Nombre de etiqueta...';

  @override
  String get appDetail_note => 'Nota';

  @override
  String get appDetail_noteHint =>
      'Agregar una nota sobre esta palabra clave...';

  @override
  String get appDetail_saveNote => 'Guardar nota';

  @override
  String get appDetail_done => 'Listo';

  @override
  String appDetail_importFailed(String error) {
    return 'Error en importación: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Importar palabras clave';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Pegue las palabras clave abajo, una por línea:';

  @override
  String get appDetail_keywordPlaceholder =>
      'palabra clave uno\npalabra clave dos\npalabra clave tres';

  @override
  String get appDetail_storefront => 'Tienda:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count palabras clave';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return 'Importar $count palabras clave';
  }

  @override
  String get appDetail_period7d => '7d';

  @override
  String get appDetail_period30d => '30d';

  @override
  String get appDetail_period90d => '90d';

  @override
  String get keywords_difficultyFilter => 'Dificultad:';

  @override
  String get keywords_difficultyAll => 'Todas';

  @override
  String get keywords_difficultyEasy => 'Fácil < 40';

  @override
  String get keywords_difficultyMedium => 'Media 40-70';

  @override
  String get keywords_difficultyHard => 'Difícil > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'Detalles de la app';

  @override
  String get appPreview_notFound => 'Aplicación no encontrada';

  @override
  String get appPreview_screenshots => 'Capturas de pantalla';

  @override
  String get appPreview_description => 'Descripción';

  @override
  String get appPreview_details => 'Detalles';

  @override
  String get appPreview_version => 'Versión';

  @override
  String get appPreview_updated => 'Actualización';

  @override
  String get appPreview_released => 'Lanzamiento';

  @override
  String get appPreview_size => 'Tamaño';

  @override
  String get appPreview_minimumOs => 'Requisitos';

  @override
  String get appPreview_price => 'Precio';

  @override
  String get appPreview_free => 'Gratis';

  @override
  String get appPreview_openInStore => 'Abrir en la tienda';

  @override
  String get appPreview_addToMyApps => 'Agregar a mis apps';

  @override
  String get appPreview_added => 'Agregada';

  @override
  String get appPreview_showMore => 'Ver más';

  @override
  String get appPreview_showLess => 'Ver menos';

  @override
  String get appPreview_keywordsPlaceholder =>
      'Agregue esta app a sus apps rastreadas para activar el seguimiento de palabras clave';

  @override
  String get notifications_title => 'Notificaciones';

  @override
  String get notifications_markAllRead => 'Marcar todo como leído';

  @override
  String get notifications_empty => 'Aún no hay notificaciones';

  @override
  String get alerts_title => 'Reglas de alerta';

  @override
  String get alerts_templatesTitle => 'Plantillas rápidas';

  @override
  String get alerts_templatesSubtitle => 'Active alertas comunes con un clic';

  @override
  String get alerts_myRulesTitle => 'Mis reglas';

  @override
  String get alerts_createRule => 'Crear regla';

  @override
  String get alerts_editRule => 'Editar regla';

  @override
  String get alerts_noRulesYet => 'Aún no hay reglas';

  @override
  String get alerts_deleteConfirm => '¿Eliminar regla?';

  @override
  String get alerts_createCustomRule => 'Crear regla personalizada';

  @override
  String alerts_ruleActivated(String name) {
    return '¡$name activado!';
  }

  @override
  String alerts_deleteMessage(String name) {
    return 'Esto eliminará \"$name\".';
  }

  @override
  String get alerts_noRulesDescription =>
      '¡Activa una plantilla o crea la tuya!';

  @override
  String get alerts_create => 'Crear';

  @override
  String get settings_notifications => 'NOTIFICACIONES';

  @override
  String get settings_manageAlerts => 'Gestionar reglas de alerta';

  @override
  String get settings_manageAlertsDesc => 'Configure las alertas que recibe';

  @override
  String get settings_storeConnections => 'Conexiones de tiendas';

  @override
  String get settings_storeConnectionsDesc =>
      'Conecte sus cuentas de App Store y Google Play';

  @override
  String get settings_alertDelivery => 'ENTREGA DE ALERTAS';

  @override
  String get settings_team => 'EQUIPO';

  @override
  String get settings_teamManagement => 'Gestión del equipo';

  @override
  String get settings_teamManagementDesc =>
      'Invite members, manage roles & permissions';

  @override
  String get settings_integrations => 'Integraciones';

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
  String get storeConnections_title => 'Conexiones a tiendas';

  @override
  String get storeConnections_description =>
      'Conecte sus cuentas de App Store y Google Play para activar funciones avanzadas como datos de ventas y análisis de aplicaciones.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Conecte su cuenta de desarrollador de Apple';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Conecte su cuenta de Google Play';

  @override
  String get storeConnections_connect => 'Conectar';

  @override
  String get storeConnections_disconnect => 'Desconectar';

  @override
  String get storeConnections_connected => 'Conectado';

  @override
  String get storeConnections_disconnectConfirm => '¿Desconectar?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return '¿Está seguro de que desea desconectar esta cuenta de $platform?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Desconectado exitosamente';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Última sincronización: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return 'Conectado el $date';
  }

  @override
  String get storeConnections_syncApps => 'Sincronizar apps';

  @override
  String get storeConnections_syncing => 'Sincronizando...';

  @override
  String get storeConnections_syncDescription =>
      'La sincronización marcará tus apps como propias, permitiendo responder a reseñas.';

  @override
  String storeConnections_syncedApps(int count) {
    return '$count apps sincronizadas como propias';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return 'Error de sincronización: $error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return 'Error al cargar conexiones: $error';
  }

  @override
  String get reviewsInbox_title => 'Bandeja de entrada';

  @override
  String get reviewsInbox_filterUnanswered => 'Sin responder';

  @override
  String get reviewsInbox_filterNegative => 'Negativas';

  @override
  String get reviewsInbox_noReviews => 'No se encontraron reseñas';

  @override
  String get reviewsInbox_noReviewsDesc => 'Intente ajustar sus filtros';

  @override
  String get reviewsInbox_reply => 'Responder';

  @override
  String get reviewsInbox_responded => 'Respondida';

  @override
  String reviewsInbox_respondedAt(String date) {
    return 'Respondida el $date';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Responder a la reseña';

  @override
  String get reviewsInbox_generateAi => 'Generar sugerencia con IA';

  @override
  String get reviewsInbox_generating => 'Generando...';

  @override
  String get reviewsInbox_sendReply => 'Enviar respuesta';

  @override
  String get reviewsInbox_sending => 'Enviando...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Escriba su respuesta...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 caracteres';
  }

  @override
  String get reviewsInbox_replySent => 'Respuesta enviada exitosamente';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Error al enviar la respuesta: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Error al generar sugerencia: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count estrellas';
  }

  @override
  String get reviewsInbox_totalReviews => 'Total de reseñas';

  @override
  String get reviewsInbox_unanswered => 'Sin responder';

  @override
  String get reviewsInbox_positive => 'Positivas';

  @override
  String get reviewsInbox_avgRating => 'Calificación promedio';

  @override
  String get reviewsInbox_sentimentOverview => 'Resumen de sentimiento';

  @override
  String get reviewsInbox_aiSuggestions => 'Sugerencias IA';

  @override
  String get reviewsInbox_regenerate => 'Regenerar';

  @override
  String get reviewsInbox_toneProfessional => 'Profesional';

  @override
  String get reviewsInbox_toneEmpathetic => 'Empático';

  @override
  String get reviewsInbox_toneBrief => 'Breve';

  @override
  String get reviewsInbox_selectTone => 'Seleccione el tono:';

  @override
  String get reviewsInbox_detectedIssues => 'Problemas detectados:';

  @override
  String get reviewsInbox_aiPrompt =>
      'Haga clic en \'Generar sugerencia con IA\' para obtener sugerencias de respuesta en 3 tonos diferentes';

  @override
  String get reviewIntelligence_title => 'Inteligencia de reseñas';

  @override
  String get reviewIntelligence_featureRequests => 'Solicitudes de funciones';

  @override
  String get reviewIntelligence_bugReports => 'Reportes de errores';

  @override
  String get reviewIntelligence_sentimentByVersion => 'Sentimiento por versión';

  @override
  String get reviewIntelligence_openFeatures => 'Funciones pendientes';

  @override
  String get reviewIntelligence_openBugs => 'Errores pendientes';

  @override
  String get reviewIntelligence_highPriority => 'Alta prioridad';

  @override
  String get reviewIntelligence_total => 'total';

  @override
  String get reviewIntelligence_mentions => 'menciones';

  @override
  String get reviewIntelligence_noData => 'Aún no hay información';

  @override
  String get reviewIntelligence_noDataHint =>
      'La información aparecerá después de analizar las reseñas';

  @override
  String get analytics_title => 'Analíticas';

  @override
  String get analytics_downloads => 'Descargas';

  @override
  String get analytics_revenue => 'Ingresos';

  @override
  String get analytics_proceeds => 'Ganancias';

  @override
  String get analytics_subscribers => 'Suscriptores';

  @override
  String get analytics_downloadsOverTime => 'Descargas a lo largo del tiempo';

  @override
  String get analytics_revenueOverTime => 'Ingresos a lo largo del tiempo';

  @override
  String get analytics_byCountry => 'Por país';

  @override
  String get analytics_noData => 'No hay datos disponibles';

  @override
  String get analytics_noDataTitle => 'Sin datos analíticos';

  @override
  String get analytics_noDataDescription =>
      'Conecte su cuenta de App Store Connect o Google Play para ver datos reales de ventas y descargas.';

  @override
  String analytics_dataDelay(String date) {
    return 'Datos a partir del $date. Los datos de Apple tienen un retraso de 24-48h.';
  }

  @override
  String get analytics_export => 'Exportar CSV';

  @override
  String get funnel_title => 'Embudo de conversión';

  @override
  String get funnel_impressions => 'Impresiones';

  @override
  String get funnel_pageViews => 'Vistas de página';

  @override
  String get funnel_downloads => 'Descargas';

  @override
  String get funnel_overallCvr => 'CVR global';

  @override
  String get funnel_categoryAvg => 'Prom. categoría';

  @override
  String get funnel_vsCategory => 'vs categoría';

  @override
  String get funnel_bySource => 'Por fuente';

  @override
  String get funnel_noData => 'No hay datos del embudo disponibles';

  @override
  String get funnel_noDataHint =>
      'Los datos del embudo se sincronizarán automáticamente desde App Store Connect o Google Play Console.';

  @override
  String get funnel_insight => 'INFORMACIÓN';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return 'El tráfico de $bestSource convierte ${ratio}x mejor que $worstSource. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'Concéntrese en la optimización de palabras clave para aumentar las impresiones de búsqueda.';

  @override
  String get funnel_insightRecommendBrowse =>
      'Mejore la visibilidad de su app en la navegación optimizando categorías y ubicación destacada.';

  @override
  String get funnel_insightRecommendReferral =>
      'Aproveche los programas de referidos y alianzas para generar más tráfico.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      'Considere estrategias de promoción cruzada con apps complementarias.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'Optimice su sitio web y páginas de destino para descargas.';

  @override
  String get funnel_insightRecommendDefault =>
      'Analice qué hace que esta fuente sea efectiva y replíquelo.';

  @override
  String get funnel_trendTitle => 'Tendencia de tasa de conversión';

  @override
  String get funnel_connectStore => 'Conectar tienda';

  @override
  String get nav_chat => 'Asistente IA';

  @override
  String get chat_title => 'Asistente IA';

  @override
  String get chat_newConversation => 'Nueva conversación';

  @override
  String get chat_loadingConversations => 'Cargando conversaciones...';

  @override
  String get chat_loadingMessages => 'Cargando mensajes...';

  @override
  String get chat_noConversations => 'Sin conversaciones';

  @override
  String get chat_noConversationsDesc =>
      'Inicie una nueva conversación para obtener información de IA sobre sus apps';

  @override
  String get chat_startConversation => 'Iniciar conversación';

  @override
  String get chat_deleteConversation => 'Eliminar conversación';

  @override
  String get chat_deleteConversationConfirm =>
      '¿Está seguro de que desea eliminar esta conversación?';

  @override
  String get chat_askAnything => 'Pregúnteme algo';

  @override
  String get chat_askAnythingDesc =>
      'Puedo ayudarle a entender las reseñas, rankings y análisis de su app';

  @override
  String get chat_typeMessage => 'Escriba su pregunta...';

  @override
  String get chat_suggestedQuestions => 'Preguntas sugeridas';

  @override
  String get chatActionConfirm => 'Confirmar';

  @override
  String get chatActionCancel => 'Cancelar';

  @override
  String get chatActionExecuting => 'Ejecutando...';

  @override
  String get chatActionExecuted => 'Completado';

  @override
  String get chatActionFailed => 'Fallido';

  @override
  String get chatActionCancelled => 'Cancelado';

  @override
  String get chatActionDownload => 'Descargar';

  @override
  String get chatActionReversible => 'Esta acción se puede deshacer';

  @override
  String get chatActionAddKeywords => 'Agregar palabras clave';

  @override
  String get chatActionRemoveKeywords => 'Eliminar palabras clave';

  @override
  String get chatActionCreateAlert => 'Crear alerta';

  @override
  String get chatActionAddCompetitor => 'Agregar competidor';

  @override
  String get chatActionExportData => 'Exportar datos';

  @override
  String get chatActionKeywords => 'Palabras clave';

  @override
  String get chatActionCountry => 'País';

  @override
  String get chatActionAlertCondition => 'Condición';

  @override
  String get chatActionNotifyVia => 'Notificar vía';

  @override
  String get chatActionCompetitor => 'Competidor';

  @override
  String get chatActionExportType => 'Tipo de exportación';

  @override
  String get chatActionDateRange => 'Período';

  @override
  String get chatActionKeywordsLabel => 'Palabras clave';

  @override
  String get chatActionAnalyticsLabel => 'Estadísticas';

  @override
  String get chatActionReviewsLabel => 'Reseñas';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_delete => 'Eliminar';

  @override
  String get appDetail_tabOverview => 'Resumen';

  @override
  String get appDetail_tabKeywords => 'Palabras clave';

  @override
  String get appDetail_tabReviews => 'Reseñas';

  @override
  String get appDetail_tabRatings => 'Calificaciones';

  @override
  String get appDetail_tabInsights => 'Análisis';

  @override
  String get dateRange_title => 'Período';

  @override
  String get dateRange_today => 'Hoy';

  @override
  String get dateRange_yesterday => 'Ayer';

  @override
  String get dateRange_last7Days => 'Últimos 7 días';

  @override
  String get dateRange_last30Days => 'Últimos 30 días';

  @override
  String get dateRange_thisMonth => 'Este mes';

  @override
  String get dateRange_lastMonth => 'Mes anterior';

  @override
  String get dateRange_last90Days => 'Últimos 90 días';

  @override
  String get dateRange_yearToDate => 'Desde inicio del año';

  @override
  String get dateRange_allTime => 'Todo';

  @override
  String get dateRange_custom => 'Personalizado...';

  @override
  String get dateRange_compareToPrevious => 'Comparar con período anterior';

  @override
  String get export_keywordsTitle => 'Exportar palabras clave';

  @override
  String get export_reviewsTitle => 'Exportar reseñas';

  @override
  String get export_analyticsTitle => 'Exportar analíticas';

  @override
  String get export_columnsToInclude => 'Columnas a incluir:';

  @override
  String get export_button => 'Exportar';

  @override
  String get export_keyword => 'Palabra clave';

  @override
  String get export_position => 'Posición';

  @override
  String get export_change => 'Cambio';

  @override
  String get export_popularity => 'Popularidad';

  @override
  String get export_difficulty => 'Dificultad';

  @override
  String get export_tags => 'Etiquetas';

  @override
  String get export_notes => 'Notas';

  @override
  String get export_trackedSince => 'Rastreado desde';

  @override
  String get export_date => 'Fecha';

  @override
  String get export_rating => 'Calificación';

  @override
  String get export_author => 'Autor';

  @override
  String get export_title => 'Título';

  @override
  String get export_content => 'Contenido';

  @override
  String get export_country => 'País';

  @override
  String get export_version => 'Versión';

  @override
  String get export_sentiment => 'Sentimiento';

  @override
  String get export_response => 'Nuestra respuesta';

  @override
  String get export_responseDate => 'Fecha de respuesta';

  @override
  String export_keywordsCount(int count) {
    return '$count palabras clave serán exportadas';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count reseñas serán exportadas';
  }

  @override
  String export_success(String filename) {
    return 'Exportación guardada: $filename';
  }

  @override
  String export_error(String error) {
    return 'Error en la exportación: $error';
  }

  @override
  String get metadata_editor => 'Editor de metadatos';

  @override
  String get metadata_selectLocale =>
      'Seleccione una configuración regional para editar';

  @override
  String get metadata_refreshed => 'Metadatos actualizados desde la tienda';

  @override
  String get metadata_connectRequired => 'Conexión requerida para editar';

  @override
  String get metadata_connectDescription =>
      'Conecte su cuenta de App Store Connect para editar los metadatos de su app directamente desde Keyrank.';

  @override
  String get metadata_connectStore => 'Conectar App Store';

  @override
  String get metadata_publishTitle => 'Publicar metadatos';

  @override
  String metadata_publishConfirm(String locale) {
    return '¿Publicar los cambios para $locale? Esto actualizará la ficha de su app en App Store.';
  }

  @override
  String get metadata_publish => 'Publicar';

  @override
  String get metadata_publishSuccess => 'Metadatos publicados exitosamente';

  @override
  String get metadata_saveDraft => 'Guardar borrador';

  @override
  String get metadata_draftSaved => 'Borrador guardado';

  @override
  String get metadata_discardChanges => 'Descartar cambios';

  @override
  String get metadata_title => 'Título';

  @override
  String metadata_titleHint(int limit) {
    return 'Nombre de la app (máx. $limit car.)';
  }

  @override
  String get metadata_subtitle => 'Subtítulo';

  @override
  String metadata_subtitleHint(int limit) {
    return 'Descripción corta (máx. $limit car.)';
  }

  @override
  String get metadata_keywords => 'Palabras clave';

  @override
  String metadata_keywordsHint(int limit) {
    return 'Palabras clave separadas por comas (máx. $limit car.)';
  }

  @override
  String get metadata_description => 'Descripción';

  @override
  String metadata_descriptionHint(int limit) {
    return 'Descripción completa de la app (máx. $limit car.)';
  }

  @override
  String get metadata_promotionalText => 'Texto promocional';

  @override
  String metadata_promotionalTextHint(int limit) {
    return 'Mensaje promocional corto (máx. $limit car.)';
  }

  @override
  String get metadata_whatsNew => 'Novedades';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'Notas de la versión (máx. $limit car.)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => 'Cambios sin guardar';

  @override
  String get metadata_noChanges => 'Sin cambios';

  @override
  String get metadata_keywordAnalysis => 'Análisis de palabras clave';

  @override
  String get metadata_keywordPresent => 'Presente';

  @override
  String get metadata_keywordMissing => 'Faltante';

  @override
  String get metadata_inTitle => 'En el título';

  @override
  String get metadata_inSubtitle => 'En el subtítulo';

  @override
  String get metadata_inKeywords => 'En las palabras clave';

  @override
  String get metadata_inDescription => 'En la descripción';

  @override
  String get metadata_history => 'Historial de cambios';

  @override
  String get metadata_noHistory => 'Sin cambios registrados';

  @override
  String get metadata_localeComplete => 'Completo';

  @override
  String get metadata_localeIncomplete => 'Incompleto';

  @override
  String get metadata_shortDescription => 'Descripción corta';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return 'Descripción mostrada en la búsqueda (máx. $limit car.)';
  }

  @override
  String get metadata_fullDescription => 'Descripción completa';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'Descripción completa de la app (máx. $limit car.)';
  }

  @override
  String get metadata_releaseNotes => 'Notas de la versión';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'Novedades de esta versión (máx. $limit car.)';
  }

  @override
  String get metadata_selectAppFirst => 'Seleccione una aplicación';

  @override
  String get metadata_selectAppHint =>
      'Use el selector de apps en la barra lateral o conecte una tienda para comenzar.';

  @override
  String get metadata_noStoreConnection => 'Conexión a tienda requerida';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return 'Conecte su cuenta de $storeName para obtener y editar los metadatos de su app.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return 'Conectar $storeName';
  }

  @override
  String get metadataLocalization => 'Localizaciones';

  @override
  String get metadataLive => 'En línea';

  @override
  String get metadataDraft => 'Borrador';

  @override
  String get metadataEmpty => 'Vacío';

  @override
  String metadataCoverageInsight(int count) {
    return '$count configuraciones regionales necesitan contenido. Considere localizar para sus mercados principales.';
  }

  @override
  String get metadataFilterAll => 'Todos';

  @override
  String get metadataFilterLive => 'En línea';

  @override
  String get metadataFilterDraft => 'Borradores';

  @override
  String get metadataFilterEmpty => 'Vacíos';

  @override
  String get metadataBulkActions => 'Acciones masivas';

  @override
  String get metadataCopyTo => 'Copiar a selección';

  @override
  String get metadataTranslateTo => 'Traducir a selección';

  @override
  String get metadataPublishSelected => 'Publicar selección';

  @override
  String get metadataDeleteDrafts => 'Eliminar borradores';

  @override
  String get metadataSelectSource =>
      'Seleccionar configuración regional de origen';

  @override
  String get metadataSelectTarget =>
      'Seleccionar configuraciones regionales de destino';

  @override
  String metadataCopySuccess(int count) {
    return 'Contenido copiado a $count configuraciones regionales';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return 'Traducido a $count configuraciones regionales';
  }

  @override
  String get metadataTranslating => 'Traduciendo...';

  @override
  String get metadataNoSelection =>
      'Primero seleccione configuraciones regionales';

  @override
  String get metadataSelectAll => 'Seleccionar todo';

  @override
  String get metadataDeselectAll => 'Deseleccionar todo';

  @override
  String metadataSelected(int count) {
    return '$count seleccionadas';
  }

  @override
  String get metadataTableView => 'Vista de tabla';

  @override
  String get metadataListView => 'Vista de lista';

  @override
  String get metadataStatus => 'Estado';

  @override
  String get metadataCompletion => 'Completado';

  @override
  String get common_back => 'Volver';

  @override
  String get common_next => 'Siguiente';

  @override
  String get common_edit => 'Editar';

  @override
  String get metadata_aiOptimize => 'Optimizar con IA';

  @override
  String get wizard_title => 'Asistente de optimización IA';

  @override
  String get wizard_step => 'Paso';

  @override
  String get wizard_of => 'de';

  @override
  String get wizard_stepTitle => 'Título';

  @override
  String get wizard_stepSubtitle => 'Subtítulo';

  @override
  String get wizard_stepKeywords => 'Palabras clave';

  @override
  String get wizard_stepDescription => 'Descripción';

  @override
  String get wizard_stepReview => 'Revisión y guardado';

  @override
  String get wizard_skip => 'Omitir';

  @override
  String get wizard_saveDrafts => 'Guardar borradores';

  @override
  String get wizard_draftsSaved => 'Borradores guardados exitosamente';

  @override
  String get wizard_exitTitle => '¿Salir del asistente?';

  @override
  String get wizard_exitMessage =>
      'Tiene cambios sin guardar. ¿Está seguro de que desea salir?';

  @override
  String get wizard_exitConfirm => 'Salir';

  @override
  String get wizard_aiSuggestions => 'Sugerencias IA';

  @override
  String get wizard_chooseSuggestion =>
      'Elija una sugerencia generada por IA o escriba la suya';

  @override
  String get wizard_currentValue => 'Valor actual';

  @override
  String get wizard_noCurrentValue => 'Sin valor definido';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return 'Basado en $keywordsCount palabras clave rastreadas y $competitorsCount competidores';
  }

  @override
  String get wizard_writeOwn => 'Escribir el mío';

  @override
  String get wizard_customPlaceholder => 'Ingrese su valor personalizado...';

  @override
  String get wizard_useCustom => 'Usar personalizado';

  @override
  String get wizard_keepCurrent => 'Mantener actual';

  @override
  String get wizard_recommended => 'Recomendado';

  @override
  String get wizard_characters => 'caracteres';

  @override
  String get wizard_reviewTitle => 'Revisar cambios';

  @override
  String get wizard_reviewDescription =>
      'Revise sus optimizaciones antes de guardarlas como borradores';

  @override
  String get wizard_noChanges => 'Sin cambios seleccionados';

  @override
  String get wizard_noChangesHint =>
      'Vuelva atrás y seleccione sugerencias para los campos a optimizar';

  @override
  String wizard_changesCount(int count) {
    return '$count campos actualizados';
  }

  @override
  String get wizard_changesSummary =>
      'Estos cambios se guardarán como borradores';

  @override
  String get wizard_before => 'Antes';

  @override
  String get wizard_after => 'Después';

  @override
  String get wizard_nextStepsTitle => '¿Qué sigue?';

  @override
  String get wizard_nextStepsWithChanges =>
      'Sus cambios se guardarán como borradores. Puede revisarlos y publicarlos desde el editor de metadatos.';

  @override
  String get wizard_nextStepsNoChanges =>
      'No hay cambios que guardar. Vuelva atrás y seleccione sugerencias para optimizar sus metadatos.';

  @override
  String get team_title => 'Gestión de equipos';

  @override
  String get team_createTeam => 'Crear equipo';

  @override
  String get team_teamName => 'Nombre del equipo';

  @override
  String get team_teamNameHint => 'Ingrese el nombre del equipo';

  @override
  String get team_description => 'Descripción (opcional)';

  @override
  String get team_descriptionHint => '¿Para qué es este equipo?';

  @override
  String get team_teamNameRequired => 'El nombre del equipo es requerido';

  @override
  String get team_teamNameMinLength =>
      'El nombre del equipo debe tener al menos 2 caracteres';

  @override
  String get team_inviteMember => 'Invitar miembro';

  @override
  String get team_emailAddress => 'Dirección de correo';

  @override
  String get team_emailHint => 'colega@ejemplo.com';

  @override
  String get team_emailRequired => 'El correo es requerido';

  @override
  String get team_emailInvalid => 'Ingrese un correo válido';

  @override
  String team_invitationSent(String email) {
    return 'Invitación enviada a $email';
  }

  @override
  String get team_members => 'MIEMBROS';

  @override
  String get team_invite => 'Invitar';

  @override
  String get team_pendingInvitations => 'INVITACIONES PENDIENTES';

  @override
  String get team_noPendingInvitations => 'Sin invitaciones pendientes';

  @override
  String get team_teamSettings => 'Configuración del equipo';

  @override
  String team_changeRole(String name) {
    return 'Cambiar rol de $name';
  }

  @override
  String get team_removeMember => 'Eliminar miembro';

  @override
  String team_removeMemberConfirm(String name) {
    return '¿Está seguro de eliminar a $name de este equipo?';
  }

  @override
  String get team_remove => 'Eliminar';

  @override
  String get team_leaveTeam => 'Abandonar equipo';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return '¿Está seguro de abandonar \"$teamName\"?';
  }

  @override
  String get team_leave => 'Abandonar';

  @override
  String get team_deleteTeam => 'Eliminar equipo';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return '¿Está seguro de eliminar \"$teamName\"? Esta acción no se puede deshacer.';
  }

  @override
  String get team_yourTeams => 'SUS EQUIPOS';

  @override
  String get team_failedToLoadTeam => 'Error al cargar equipo';

  @override
  String get team_failedToLoadMembers => 'Error al cargar miembros';

  @override
  String get team_failedToLoadInvitations => 'Error al cargar invitaciones';

  @override
  String team_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String team_invitedAs(String role) {
    return 'Invitado como $role';
  }

  @override
  String team_joinedTeam(String teamName) {
    return 'Te uniste a $teamName';
  }

  @override
  String get team_invitationDeclined => 'Invitación rechazada';

  @override
  String get team_noTeamsYet => 'Sin equipos aún';

  @override
  String get team_noTeamsDescription =>
      'Crea un equipo para colaborar con otros en tus apps';

  @override
  String get team_createFirstTeam => 'Crear tu primer equipo';

  @override
  String get integrations_title => 'Integraciones';

  @override
  String integrations_syncFailed(String error) {
    return 'Error de sincronización: $error';
  }

  @override
  String get integrations_disconnectConfirm => '¿Desconectar?';

  @override
  String get integrations_disconnectedSuccess => 'Desconectado exitosamente';

  @override
  String get integrations_connectGooglePlay => 'Conectar Google Play Console';

  @override
  String get integrations_connectAppStore => 'Conectar App Store Connect';

  @override
  String integrations_connectedApps(int count) {
    return '¡Conectado! $count apps importadas.';
  }

  @override
  String integrations_syncedApps(int count) {
    return '$count apps sincronizadas como propietario';
  }

  @override
  String get integrations_appStoreConnected =>
      '¡App Store Connect conectado exitosamente!';

  @override
  String get integrations_googlePlayConnected =>
      '¡Google Play Console conectado exitosamente!';

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
  String get alertBuilder_nameYourRule => 'NOMBRE DE SU REGLA';

  @override
  String get alertBuilder_nameDescription =>
      'Dé un nombre descriptivo a su regla de alerta';

  @override
  String get alertBuilder_nameHint => 'ej: Alerta de posición diaria';

  @override
  String get alertBuilder_summary => 'RESUMEN';

  @override
  String get alertBuilder_saveAlertRule => 'Guardar regla de alerta';

  @override
  String get alertBuilder_selectAlertType => 'SELECCIONAR TIPO DE ALERTA';

  @override
  String get alertBuilder_selectAlertTypeDescription =>
      'Elija qué tipo de alerta desea crear';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return 'Esto eliminará \"$ruleName\".';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate =>
      'Aún no hay reglas. ¡Active una plantilla o cree la suya!';

  @override
  String get billing_cancelSubscription => 'Cancelar suscripción';

  @override
  String get billing_keepSubscription => 'Mantener suscripción';

  @override
  String get billing_billingPortal => 'Portal de facturación';

  @override
  String get billing_resume => 'Reanudar';

  @override
  String get keywords_noCompetitorsFound =>
      'No se encontraron competidores. Añade competidores primero.';

  @override
  String get keywords_noCompetitorsForApp =>
      'No hay competidores para esta app. Añade un competidor primero.';

  @override
  String keywords_failedToAddKeywords(String error) {
    return 'Error al añadir palabras clave: $error';
  }

  @override
  String get keywords_bulkAddHint =>
      'rastreador de gastos\ngestor de presupuesto\napp de dinero';

  @override
  String get appOverview_urlCopied =>
      'URL de la tienda copiada al portapapeles';

  @override
  String get country_us => 'Estados Unidos';

  @override
  String get country_gb => 'Reino Unido';

  @override
  String get country_fr => 'Francia';

  @override
  String get country_de => 'Alemania';

  @override
  String get country_ca => 'Canadá';

  @override
  String get country_au => 'Australia';

  @override
  String get country_jp => 'Japón';

  @override
  String get country_cn => 'China';

  @override
  String get country_kr => 'Corea del Sur';

  @override
  String get country_br => 'Brasil';

  @override
  String get country_es => 'España';

  @override
  String get country_it => 'Italia';

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
  String get alertBuilder_scope => 'Alcance';

  @override
  String get alertBuilder_name => 'Nombre';

  @override
  String get alertBuilder_scopeGlobal => 'Todas las apps';

  @override
  String get alertBuilder_scopeApp => 'App específica';

  @override
  String get alertBuilder_scopeCategory => 'Categoría';

  @override
  String get alertBuilder_scopeKeyword => 'Palabra clave';

  @override
  String get alertType_positionChange => 'Cambio de posición';

  @override
  String get alertType_positionChangeDesc =>
      'Alerta cuando el ranking cambia significativamente';

  @override
  String get alertType_ratingChange => 'Cambio de calificación';

  @override
  String get alertType_ratingChangeDesc =>
      'Alerta cuando cambia la calificación';

  @override
  String get alertType_reviewSpike => 'Pico de reseñas';

  @override
  String get alertType_reviewSpikeDesc =>
      'Alerta por actividad inusual de reseñas';

  @override
  String get alertType_reviewKeyword => 'Palabra clave en reseñas';

  @override
  String get alertType_reviewKeywordDesc =>
      'Alerta cuando aparecen palabras clave en reseñas';

  @override
  String get alertType_newCompetitor => 'Nuevo competidor';

  @override
  String get alertType_newCompetitorDesc =>
      'Alerta cuando nuevas apps entran en tu espacio';

  @override
  String get alertType_competitorPassed => 'Competidor superado';

  @override
  String get alertType_competitorPassedDesc =>
      'Alerta cuando superas a un competidor';

  @override
  String get alertType_massMovement => 'Movimiento masivo';

  @override
  String get alertType_massMovementDesc =>
      'Alerta por grandes cambios en el ranking';

  @override
  String get alertType_keywordTrend => 'Tendencia de palabra clave';

  @override
  String get alertType_keywordTrendDesc =>
      'Alerta cuando cambia la popularidad de una palabra clave';

  @override
  String get alertType_opportunity => 'Oportunidad';

  @override
  String get alertType_opportunityDesc =>
      'Alerta sobre nuevas oportunidades de ranking';

  @override
  String get billing_title => 'Facturación y Planes';

  @override
  String get billing_subscriptionActivated =>
      '¡Suscripción activada con éxito!';

  @override
  String get billing_changePlan => 'Cambiar plan';

  @override
  String get billing_choosePlan => 'Elegir un plan';

  @override
  String get billing_cancelMessage =>
      'Tu suscripción permanecerá activa hasta el final del período de facturación actual. Después, perderás acceso a las funciones premium.';

  @override
  String get billing_currentPlan => 'PLAN ACTUAL';

  @override
  String get billing_trial => 'PRUEBA';

  @override
  String get billing_canceling => 'CANCELANDO';

  @override
  String billing_accessUntil(String date) {
    return 'Acceso hasta $date';
  }

  @override
  String billing_renewsOn(String date) {
    return 'Se renueva el $date';
  }

  @override
  String get billing_manageSubscription => 'GESTIONAR SUSCRIPCIÓN';

  @override
  String get billing_monthly => 'Mensual';

  @override
  String get billing_yearly => 'Anual';

  @override
  String billing_savePercent(int percent) {
    return 'Ahorra $percent%';
  }

  @override
  String get billing_current => 'Actual';

  @override
  String get billing_apps => 'Apps';

  @override
  String get billing_unlimited => 'Ilimitado';

  @override
  String get billing_keywordsPerApp => 'Palabras clave por app';

  @override
  String get billing_history => 'Historial';

  @override
  String billing_days(int count) {
    return '$count días';
  }

  @override
  String get billing_exports => 'Exportaciones';

  @override
  String get billing_aiInsights => 'Análisis IA';

  @override
  String get billing_apiAccess => 'Acceso API';

  @override
  String get billing_yes => 'Sí';

  @override
  String get billing_no => 'No';

  @override
  String get billing_currentPlanButton => 'Plan actual';

  @override
  String billing_upgradeTo(String planName) {
    return 'Actualizar a $planName';
  }

  @override
  String get billing_cancel => 'Cancelar';

  @override
  String get keywords_compareWithCompetitor => 'Comparar con competidor';

  @override
  String get keywords_selectCompetitorToCompare =>
      'Selecciona un competidor para comparar palabras clave:';

  @override
  String get keywords_addToCompetitor => 'Añadir a competidor';

  @override
  String keywords_addKeywordsTo(int count) {
    return 'Añadir $count palabra(s) clave a:';
  }

  @override
  String get keywords_avgPosition => 'Posición prom.';

  @override
  String get keywords_declined => 'En descenso';

  @override
  String get keywords_total => 'Total';

  @override
  String get keywords_ranked => 'Clasificados';

  @override
  String get keywords_improved => 'Mejorados';

  @override
  String get onboarding_skip => 'Omitir';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_getStarted => 'Empezar';

  @override
  String get onboarding_welcomeToKeyrank => 'Bienvenido a Keyrank';

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
  String get team_you => 'Tú';

  @override
  String get team_changeRoleButton => 'Change Role';

  @override
  String get team_removeButton => 'Remove';

  @override
  String get competitors_removeTitle => 'Remove Competitor';

  @override
  String competitors_removeConfirm(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\" de tus competidores?';
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
    return 'Error al añadir competidor: $error';
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
  String get alerts_scopeCategory => 'Categoría';

  @override
  String get alerts_scopeKeyword => 'Palabra clave';

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
    return 'Ver $count insights más';
  }

  @override
  String get insights_noInsightsDesc =>
      'Los insights aparecerán cuando descubramos oportunidades de optimización para tu app.';

  @override
  String get insights_loadFailed => 'Error al cargar insights';

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
