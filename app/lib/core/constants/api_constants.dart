class ApiConstants {
  // ============================================
  // CONFIGURE YOUR API URL HERE
  // ============================================
  // Dev local (Valet/Herd): http://ranking.test/api
  // Dev localhost: http://localhost:8000/api
  // Production: https://api.yourapp.com/api
  // ============================================
  static const String baseUrl = 'http://ranking.test/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Apps endpoints
  static const String apps = '/apps';
  static const String appsSearch = '/apps/search';

  // Keywords endpoints
  static const String keywordsSearch = '/keywords/search';

  // Dashboard endpoints
  static const String dashboardOverview = '/dashboard/overview';

  // Rankings
  static const String rankingsMovers = '/rankings/movers';

  // Countries
  static const String countries = '/countries';
}
