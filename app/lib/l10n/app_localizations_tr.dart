// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTagline => 'App Store sıralamalarınızı takip edin';

  @override
  String get auth_welcomeBack => 'Tekrar hoş geldiniz';

  @override
  String get auth_signInSubtitle => 'Hesabınıza giriş yapın';

  @override
  String get auth_createAccount => 'Hesap oluştur';

  @override
  String get auth_createAccountSubtitle =>
      'Sıralamalarınızı takip etmeye başlayın';

  @override
  String get auth_emailLabel => 'E-posta';

  @override
  String get auth_passwordLabel => 'Şifre';

  @override
  String get auth_nameLabel => 'İsim';

  @override
  String get auth_confirmPasswordLabel => 'Şifreyi onayla';

  @override
  String get auth_signInButton => 'Giriş yap';

  @override
  String get auth_signUpButton => 'Hesap oluştur';

  @override
  String get auth_noAccount => 'Hesabınız yok mu?';

  @override
  String get auth_hasAccount => 'Zaten hesabınız var mı?';

  @override
  String get auth_signUpLink => 'Kayıt ol';

  @override
  String get auth_signInLink => 'Giriş yap';

  @override
  String get auth_emailRequired => 'Lütfen e-postanızı girin';

  @override
  String get auth_emailInvalid => 'Geçersiz e-posta';

  @override
  String get auth_passwordRequired => 'Lütfen şifrenizi girin';

  @override
  String get auth_enterPassword => 'Lütfen bir şifre girin';

  @override
  String get auth_nameRequired => 'Lütfen adınızı girin';

  @override
  String get auth_passwordMinLength => 'Şifre en az 8 karakter olmalıdır';

  @override
  String get auth_passwordsNoMatch => 'Şifreler eşleşmiyor';

  @override
  String get auth_errorOccurred => 'Bir hata oluştu';

  @override
  String get common_retry => 'Tekrar dene';

  @override
  String common_error(String message) {
    return 'Hata: $message';
  }

  @override
  String get common_loading => 'Yükleniyor...';

  @override
  String get common_add => 'Ekle';

  @override
  String get common_filter => 'Filtrele';

  @override
  String get common_sort => 'Sırala';

  @override
  String get common_refresh => 'Yenile';

  @override
  String get common_settings => 'Ayarlar';

  @override
  String get dashboard_title => 'Kontrol Paneli';

  @override
  String get dashboard_addApp => 'Uygulama ekle';

  @override
  String get dashboard_appsTracked => 'Takip edilen uygulamalar';

  @override
  String get dashboard_keywords => 'Anahtar kelimeler';

  @override
  String get dashboard_avgPosition => 'Ort. Sıralama';

  @override
  String get dashboard_top10 => 'İlk 10';

  @override
  String get dashboard_trackedApps => 'Takip edilen uygulamalar';

  @override
  String get dashboard_quickActions => 'Hızlı işlemler';

  @override
  String get dashboard_addNewApp => 'Yeni uygulama ekle';

  @override
  String get dashboard_searchKeywords => 'Anahtar kelime ara';

  @override
  String get dashboard_viewAllApps => 'Tüm uygulamaları görüntüle';

  @override
  String get dashboard_noAppsYet => 'Henüz takip edilen uygulama yok';

  @override
  String get dashboard_addAppToStart =>
      'Anahtar kelimeleri takip etmeye başlamak için bir uygulama ekleyin';

  @override
  String get dashboard_noAppsMatchFilter => 'Filtreyle eşleşen uygulama yok';

  @override
  String get dashboard_changeFilterCriteria =>
      'Filtre kriterlerini değiştirmeyi deneyin';

  @override
  String get apps_title => 'Uygulamalarım';

  @override
  String apps_appCount(int count) {
    return '$count uygulama';
  }

  @override
  String get apps_tableApp => 'UYGULAMA';

  @override
  String get apps_tableDeveloper => 'GELİŞTİRİCİ';

  @override
  String get apps_tableKeywords => 'ANAHTAR KELİMELER';

  @override
  String get apps_tablePlatform => 'PLATFORM';

  @override
  String get apps_tableRating => 'PUAN';

  @override
  String get apps_tableBestRank => 'EN İYİ SIRALAMA';

  @override
  String get apps_noAppsYet => 'Henüz takip edilen uygulama yok';

  @override
  String get apps_addAppToStart =>
      'Sıralamalarını takip etmeye başlamak için bir uygulama ekleyin';

  @override
  String get addApp_title => 'Uygulama Ekle';

  @override
  String get addApp_searchAppStore => 'App Store\'da ara...';

  @override
  String get addApp_searchPlayStore => 'Play Store\'da ara...';

  @override
  String get addApp_searchForApp => 'Uygulama ara';

  @override
  String get addApp_enterAtLeast2Chars => 'En az 2 karakter girin';

  @override
  String get addApp_noResults => 'Sonuç bulunamadı';

  @override
  String addApp_addedSuccess(String name) {
    return '$name başarıyla eklendi';
  }

  @override
  String get settings_title => 'Ayarlar';

  @override
  String get settings_language => 'Dil';

  @override
  String get settings_appearance => 'Görünüm';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_themeSystem => 'Sistem';

  @override
  String get settings_themeDark => 'Koyu';

  @override
  String get settings_themeLight => 'Açık';

  @override
  String get settings_account => 'Hesap';

  @override
  String get settings_memberSince => 'Üyelik tarihi';

  @override
  String get settings_logout => 'Çıkış yap';

  @override
  String get settings_languageSystem => 'Sistem';

  @override
  String get filter_all => 'Tümü';

  @override
  String get filter_allApps => 'Tüm uygulamalar';

  @override
  String get filter_ios => 'iOS';

  @override
  String get filter_iosOnly => 'Sadece iOS';

  @override
  String get filter_android => 'Android';

  @override
  String get filter_androidOnly => 'Sadece Android';

  @override
  String get filter_favorites => 'Favoriler';

  @override
  String get sort_recent => 'Son';

  @override
  String get sort_recentlyAdded => 'Son eklenen';

  @override
  String get sort_nameAZ => 'İsim A-Z';

  @override
  String get sort_nameZA => 'İsim Z-A';

  @override
  String get sort_keywords => 'Anahtar kelimeler';

  @override
  String get sort_mostKeywords => 'En çok anahtar kelime';

  @override
  String get sort_bestRank => 'En iyi sıralama';

  @override
  String get userMenu_logout => 'Çıkış yap';
}
