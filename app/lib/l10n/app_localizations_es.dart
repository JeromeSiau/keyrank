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
}
