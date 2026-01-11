// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTagline => 'Rastrea tus rankings en App Store';

  @override
  String get auth_welcomeBack => 'Bienvenido de nuevo';

  @override
  String get auth_signInSubtitle => 'Inicia sesión en tu cuenta';

  @override
  String get auth_createAccount => 'Crear cuenta';

  @override
  String get auth_createAccountSubtitle => 'Comienza a rastrear tus rankings';

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
  String get auth_noAccount => '¿No tienes una cuenta?';

  @override
  String get auth_hasAccount => '¿Ya tienes una cuenta?';

  @override
  String get auth_signUpLink => 'Regístrate';

  @override
  String get auth_signInLink => 'Iniciar sesión';

  @override
  String get auth_emailRequired => 'Por favor ingresa tu correo electrónico';

  @override
  String get auth_emailInvalid => 'Correo electrónico inválido';

  @override
  String get auth_passwordRequired => 'Por favor ingresa tu contraseña';

  @override
  String get auth_enterPassword => 'Por favor ingresa una contraseña';

  @override
  String get auth_nameRequired => 'Por favor ingresa tu nombre';

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
      'Agrega una app para comenzar a rastrear palabras clave';

  @override
  String get dashboard_noAppsMatchFilter =>
      'Ninguna app coincide con el filtro';

  @override
  String get dashboard_changeFilterCriteria =>
      'Intenta cambiar los criterios del filtro';

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
      'Agrega una app para comenzar a rastrear sus rankings';

  @override
  String get addApp_title => 'Agregar App';

  @override
  String get addApp_searchAppStore => 'Buscar en App Store...';

  @override
  String get addApp_searchPlayStore => 'Buscar en Play Store...';

  @override
  String get addApp_searchForApp => 'Buscar una app';

  @override
  String get addApp_enterAtLeast2Chars => 'Ingresa al menos 2 caracteres';

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
  String get insights_compareTitle => 'Comparar Insights';

  @override
  String get insights_analyzingReviews => 'Analizando reseñas...';

  @override
  String get insights_noInsightsAvailable => 'No hay insights disponibles';

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
  String get insights_reviewInsights => 'Insights de reseñas';

  @override
  String get insights_generateFirst => 'Genera insights primero';

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
  String get insights_yourNotes => 'Tus notas';

  @override
  String get insights_save => 'Guardar';

  @override
  String get insights_clickToAddNotes => 'Haz clic para agregar notas...';

  @override
  String get insights_noteSaved => 'Nota guardada';

  @override
  String get insights_noteHint =>
      'Agrega tus notas sobre este análisis de insights...';

  @override
  String get insights_categoryScores => 'Puntuaciones por categoría';

  @override
  String get insights_emergentThemes => 'Temas emergentes';

  @override
  String get insights_exampleQuotes => 'Citas de ejemplo:';

  @override
  String get insights_selectCountryFirst => 'Selecciona al menos un país';

  @override
  String compare_selectAppsToCompare(String appName) {
    return 'Selecciona hasta 3 apps para comparar con $appName';
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
  String get appDetail_insights => 'Insights';

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
  String get appDetail_keywordHint => 'ej., rastreador fitness';

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
    return '¿Estás seguro de que deseas eliminar $count palabras clave?';
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
      'No hay etiquetas disponibles. Crea etiquetas primero.';

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
  String get keywordSuggestions_search => 'Buscar sugerencias...';

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
  String get sidebar_favorites => 'FAVORITOS';

  @override
  String get sidebar_tooManyFavorites =>
      'Considera mantener 5 o menos favoritos';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Investigación de palabras clave';

  @override
  String get keywordSearch_searchPlaceholder => 'Buscar palabras clave...';

  @override
  String get keywordSearch_searchTitle => 'Buscar una palabra clave';

  @override
  String get keywordSearch_searchSubtitle =>
      'Descubre qué apps rankean para cualquier palabra clave';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count apps rankeadas';
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
      'Agrega una palabra clave arriba para comenzar a rastrear';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Ninguna palabra clave coincide con el filtro';

  @override
  String get appDetail_tryChangingFilter =>
      'Intenta cambiar los criterios del filtro';

  @override
  String get appDetail_addTag => 'Agregar etiqueta';

  @override
  String get appDetail_addNote => 'Agregar nota';

  @override
  String get appDetail_positionHistory => 'Historial de posiciones';

  @override
  String get appDetail_store => 'STORE';

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
  String get nav_notifications => 'Alertas';

  @override
  String get common_save => 'Guardar';

  @override
  String get appDetail_manageTags => 'Gestionar etiquetas';

  @override
  String get appDetail_newTagHint => 'Nombre de nueva etiqueta...';

  @override
  String get appDetail_availableTags => 'Etiquetas disponibles';

  @override
  String get appDetail_noTagsYet => 'Sin etiquetas aún. Crea una arriba.';

  @override
  String get appDetail_addTagsTitle => 'Añadir etiquetas';

  @override
  String get appDetail_selectTagsDescription =>
      'Selecciona etiquetas para añadir a las palabras clave:';

  @override
  String appDetail_addTagsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'etiquetas',
      one: 'etiqueta',
    );
    return 'Añadir $count $_temp0';
  }

  @override
  String appDetail_importFailed(String error) {
    return 'Error en importación: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Importar palabras clave';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Pega las palabras clave abajo, una por línea:';

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
  String get notifications_title => 'Notificaciones';

  @override
  String get notifications_markAllRead => 'Marcar todo como leido';

  @override
  String get notifications_empty => 'Aun no hay notificaciones';

  @override
  String get alerts_title => 'Reglas de alerta';

  @override
  String get alerts_templatesTitle => 'Plantillas rapidas';

  @override
  String get alerts_templatesSubtitle => 'Activa alertas comunes con un toque';

  @override
  String get alerts_myRulesTitle => 'Mis reglas';

  @override
  String get alerts_createRule => 'Crear regla';

  @override
  String get alerts_editRule => 'Editar regla';

  @override
  String get alerts_noRulesYet => 'Aun no hay reglas';

  @override
  String get alerts_deleteConfirm => 'Eliminar regla?';

  @override
  String get settings_notifications => 'NOTIFICACIONES';

  @override
  String get settings_manageAlerts => 'Gestionar reglas de alerta';

  @override
  String get settings_manageAlertsDesc => 'Configura que alertas recibes';

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
}
