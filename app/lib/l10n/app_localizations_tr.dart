// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTagline => 'App Store siralamalarinizi takip edin';

  @override
  String get auth_welcomeBack => 'Tekrar hos geldiniz';

  @override
  String get auth_signInSubtitle => 'Hesabiniza giris yapin';

  @override
  String get auth_createAccount => 'Hesap olustur';

  @override
  String get auth_createAccountSubtitle =>
      'Siralamalarinizi takip etmeye baslayin';

  @override
  String get auth_emailLabel => 'E-posta';

  @override
  String get auth_passwordLabel => 'Sifre';

  @override
  String get auth_nameLabel => 'Ad';

  @override
  String get auth_confirmPasswordLabel => 'Sifreyi onayla';

  @override
  String get auth_signInButton => 'Giris yap';

  @override
  String get auth_signUpButton => 'Hesap olustur';

  @override
  String get auth_noAccount => 'Hesabiniz yok mu?';

  @override
  String get auth_hasAccount => 'Zaten hesabiniz var mi?';

  @override
  String get auth_signUpLink => 'Kayit ol';

  @override
  String get auth_signInLink => 'Giris yap';

  @override
  String get auth_emailRequired => 'Lutfen e-postanizi girin';

  @override
  String get auth_emailInvalid => 'Gecersiz e-posta';

  @override
  String get auth_passwordRequired => 'Lutfen sifrenizi girin';

  @override
  String get auth_enterPassword => 'Lutfen bir sifre girin';

  @override
  String get auth_nameRequired => 'Lutfen adinizi girin';

  @override
  String get auth_passwordMinLength => 'Sifre en az 8 karakter olmalidir';

  @override
  String get auth_passwordsNoMatch => 'Sifreler eslesmiyor';

  @override
  String get auth_errorOccurred => 'Bir hata olustu';

  @override
  String get common_retry => 'Tekrar dene';

  @override
  String common_error(String message) {
    return 'Hata: $message';
  }

  @override
  String get common_loading => 'Yukleniyor...';

  @override
  String get common_add => 'Ekle';

  @override
  String get common_filter => 'Filtrele';

  @override
  String get common_sort => 'Sirala';

  @override
  String get common_refresh => 'Yenile';

  @override
  String get common_settings => 'Ayarlar';

  @override
  String get common_search => 'Ara...';

  @override
  String get common_noResults => 'Sonuc bulunamadi';

  @override
  String get dashboard_title => 'Kontrol Paneli';

  @override
  String get dashboard_addApp => 'Uygulama ekle';

  @override
  String get dashboard_appsTracked => 'Takip edilen uygulamalar';

  @override
  String get dashboard_keywords => 'Anahtar kelimeler';

  @override
  String get dashboard_avgPosition => 'Ortalama siralama';

  @override
  String get dashboard_top10 => 'Ilk 10';

  @override
  String get dashboard_trackedApps => 'Takip edilen uygulamalar';

  @override
  String get dashboard_quickActions => 'Hizli islemler';

  @override
  String get dashboard_addNewApp => 'Yeni uygulama ekle';

  @override
  String get dashboard_searchKeywords => 'Anahtar kelime ara';

  @override
  String get dashboard_viewAllApps => 'Tum uygulamalari goruntule';

  @override
  String get dashboard_noAppsYet => 'Henuz takip edilen uygulama yok';

  @override
  String get dashboard_addAppToStart =>
      'Anahtar kelimeleri takip etmeye baslamak icin bir uygulama ekleyin';

  @override
  String get dashboard_noAppsMatchFilter => 'Filtreyle eslesen uygulama yok';

  @override
  String get dashboard_changeFilterCriteria =>
      'Filtre kriterlerini degistirmeyi deneyin';

  @override
  String get dashboard_reviews => 'Yorumlar';

  @override
  String get dashboard_avgRating => 'Ortalama puan';

  @override
  String get dashboard_topPerformingApps => 'En basarili uygulamalar';

  @override
  String get dashboard_topCountries => 'En onemli ulkeler';

  @override
  String get dashboard_sentimentOverview => 'Duygu analizi ozeti';

  @override
  String get dashboard_overallSentiment => 'Genel duygu';

  @override
  String get dashboard_positive => 'Olumlu';

  @override
  String get dashboard_positiveReviews => 'Olumlu';

  @override
  String get dashboard_negativeReviews => 'Olumsuz';

  @override
  String get dashboard_viewReviews => 'Yorumlari goruntule';

  @override
  String get dashboard_tableApp => 'UYGULAMA';

  @override
  String get dashboard_tableKeywords => 'ANAHTAR KELIMELER';

  @override
  String get dashboard_tableAvgRank => 'ORT. SIRALAMA';

  @override
  String get dashboard_tableTrend => 'EGILIM';

  @override
  String get dashboard_connectYourStores => 'Magazalarinizi baglayiniz';

  @override
  String get dashboard_connectStoresDescription =>
      'Uygulamalarinizi ice aktarmak ve yorumlara yanit vermek icin App Store Connect veya Google Play hesabinizi baglayiniz.';

  @override
  String get dashboard_connect => 'Bagla';

  @override
  String get apps_title => 'Uygulamalarim';

  @override
  String apps_appCount(int count) {
    return '$count uygulama';
  }

  @override
  String get apps_tableApp => 'UYGULAMA';

  @override
  String get apps_tableDeveloper => 'GELISTIRICI';

  @override
  String get apps_tableKeywords => 'ANAHTAR KELIMELER';

  @override
  String get apps_tablePlatform => 'PLATFORM';

  @override
  String get apps_tableRating => 'PUAN';

  @override
  String get apps_tableBestRank => 'EN IYI SIRALAMA';

  @override
  String get apps_noAppsYet => 'Henuz takip edilen uygulama yok';

  @override
  String get apps_addAppToStart =>
      'Siralamalari takip etmeye baslamak icin bir uygulama ekleyin';

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
  String get addApp_noResults => 'Sonuc bulunamadi';

  @override
  String addApp_addedSuccess(String name) {
    return '$name basariyla eklendi';
  }

  @override
  String get settings_title => 'Ayarlar';

  @override
  String get settings_language => 'Dil';

  @override
  String get settings_appearance => 'Gorunum';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_themeSystem => 'Sistem';

  @override
  String get settings_themeDark => 'Koyu';

  @override
  String get settings_themeLight => 'Acik';

  @override
  String get settings_account => 'Hesap';

  @override
  String get settings_memberSince => 'Uyelik tarihi';

  @override
  String get settings_logout => 'Cikis yap';

  @override
  String get settings_languageSystem => 'Sistem';

  @override
  String get filter_all => 'Tumu';

  @override
  String get filter_allApps => 'Tum uygulamalar';

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
  String get sort_nameAZ => 'Ad A-Z';

  @override
  String get sort_nameZA => 'Ad Z-A';

  @override
  String get sort_keywords => 'Anahtar kelimeler';

  @override
  String get sort_mostKeywords => 'En cok anahtar kelime';

  @override
  String get sort_bestRank => 'En iyi siralama';

  @override
  String get userMenu_logout => 'Cikis yap';

  @override
  String get insights_compareTitle => 'Analizleri karsilastir';

  @override
  String get insights_analyzingReviews => 'Yorumlar analiz ediliyor...';

  @override
  String get insights_noInsightsAvailable => 'Analiz mevcut degil';

  @override
  String get insights_strengths => 'Guclu yonler';

  @override
  String get insights_weaknesses => 'Zayif yonler';

  @override
  String get insights_scores => 'Puanlar';

  @override
  String get insights_opportunities => 'Firsatlar';

  @override
  String get insights_categoryUx => 'KD';

  @override
  String get insights_categoryPerf => 'Perf';

  @override
  String get insights_categoryFeatures => 'Ozellikler';

  @override
  String get insights_categoryPricing => 'Fiyatlandirma';

  @override
  String get insights_categorySupport => 'Destek';

  @override
  String get insights_categoryOnboard => 'Baslangic';

  @override
  String get insights_categoryUxFull => 'KD / Arayuz';

  @override
  String get insights_categoryPerformance => 'Performans';

  @override
  String get insights_categoryOnboarding => 'Ilk Kullanim';

  @override
  String get insights_reviewInsights => 'Yorum analizleri';

  @override
  String get insights_generateFirst => 'Once analiz olusturun';

  @override
  String get insights_compareWithOther => 'Diger uygulamalarla karsilastir';

  @override
  String get insights_compare => 'Karsilastir';

  @override
  String get insights_generateAnalysis => 'Analiz olustur';

  @override
  String get insights_period => 'Donem:';

  @override
  String get insights_3months => '3 ay';

  @override
  String get insights_6months => '6 ay';

  @override
  String get insights_12months => '12 ay';

  @override
  String get insights_analyze => 'Analiz et';

  @override
  String insights_reviewsCount(int count) {
    return '$count yorum';
  }

  @override
  String insights_analyzedAgo(String time) {
    return '$time once analiz edildi';
  }

  @override
  String get insights_yourNotes => 'Notlariniz';

  @override
  String get insights_save => 'Kaydet';

  @override
  String get insights_clickToAddNotes => 'Not eklemek icin tiklayin...';

  @override
  String get insights_noteSaved => 'Not kaydedildi';

  @override
  String get insights_noteHint => 'Bu analiz hakkinda notlarinizi ekleyin...';

  @override
  String get insights_categoryScores => 'Kategori puanlari';

  @override
  String get insights_emergentThemes => 'One cikan temalar';

  @override
  String get insights_exampleQuotes => 'Ornek alintilar:';

  @override
  String get insights_selectCountryFirst => 'En az bir ulke secin';

  @override
  String get insights_title => 'Analizler';

  @override
  String insights_titleWithApp(String appName) {
    return 'Analizler - $appName';
  }

  @override
  String get insights_allApps => 'Analizler (Tum uygulamalar)';

  @override
  String get insights_noInsightsYet => 'Henüz içgörü yok';

  @override
  String get insights_selectAppToGenerate =>
      'Yorumlardan analiz olusturmak icin bir uygulama secin';

  @override
  String insights_appsWithInsights(int count) {
    return '$count uygulama analizli';
  }

  @override
  String get insights_errorLoading => 'Analizler yuklenirken hata olustu';

  @override
  String insights_reviewsAnalyzed(int count) {
    return '$count yorum analiz edildi';
  }

  @override
  String get insights_avgScore => 'ortalama puan';

  @override
  String insights_updatedOn(String date) {
    return '$date tarihinde guncellendi';
  }

  @override
  String compare_selectAppsToCompare(String appName) {
    return '$appName ile karsilastirmak icin en fazla 3 uygulama secin';
  }

  @override
  String get compare_searchApps => 'Uygulama ara...';

  @override
  String get compare_noOtherApps => 'Karsilastirilacak baska uygulama yok';

  @override
  String get compare_noMatchingApps => 'Eslesen uygulama yok';

  @override
  String compare_appsSelected(int count) {
    return '3 uygulamadan $count tanesi secildi';
  }

  @override
  String get compare_cancel => 'Iptal';

  @override
  String compare_button(int count) {
    return '$count uygulamayi karsilastir';
  }

  @override
  String get appDetail_deleteAppTitle => 'Uygulama silinsin mi?';

  @override
  String get appDetail_deleteAppConfirm => 'Bu islem geri alinamaz.';

  @override
  String get appDetail_cancel => 'Iptal';

  @override
  String get appDetail_delete => 'Sil';

  @override
  String get appDetail_exporting => 'Siralamalar disa aktariliyor...';

  @override
  String appDetail_savedFile(String filename) {
    return 'Kaydedildi: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Finder\'da goster';

  @override
  String appDetail_exportFailed(String error) {
    return 'Disa aktarma basarisiz: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return '$imported anahtar kelime ice aktarildi ($skipped atlandi)';
  }

  @override
  String get appDetail_favorite => 'Favori';

  @override
  String get appDetail_ratings => 'Puanlar';

  @override
  String get appDetail_insights => 'Analizler';

  @override
  String get appDetail_import => 'Ice aktar';

  @override
  String get appDetail_export => 'Disa aktar';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count yorum';
  }

  @override
  String get appDetail_keywords => 'anahtar kelimeler';

  @override
  String get appDetail_addKeyword => 'Anahtar kelime ekle';

  @override
  String get appDetail_keywordHint => 'orn. fitness takipcisi';

  @override
  String get appDetail_trackedKeywords => 'Takip edilen anahtar kelimeler';

  @override
  String appDetail_selectedCount(int count) {
    return '$count secildi';
  }

  @override
  String get appDetail_allKeywords => 'Tum anahtar kelimeler';

  @override
  String get appDetail_hasTags => 'Etiketli';

  @override
  String get appDetail_hasNotes => 'Notlu';

  @override
  String get appDetail_position => 'Siralama';

  @override
  String get appDetail_select => 'Sec';

  @override
  String get appDetail_suggestions => 'Oneriler';

  @override
  String get appDetail_deleteKeywordsTitle => 'Anahtar kelimeleri sil';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return '$count anahtar kelimeyi silmek istediginizden emin misiniz?';
  }

  @override
  String get appDetail_tag => 'Etiket';

  @override
  String appDetail_keywordAdded(String keyword, String flag) {
    return '\"$keyword\" anahtar kelimesi eklendi ($flag)';
  }

  @override
  String appDetail_tagsAdded(int count) {
    return '$count anahtar kelimeye etiket eklendi';
  }

  @override
  String get appDetail_keywordsAddedSuccess =>
      'Anahtar kelimeler basariyla eklendi';

  @override
  String get appDetail_noTagsAvailable =>
      'Etiket mevcut degil. Once etiket olusturun.';

  @override
  String get appDetail_tagged => 'Etiketli';

  @override
  String get appDetail_withNotes => 'Notlu';

  @override
  String get appDetail_nameAZ => 'Ad A-Z';

  @override
  String get appDetail_nameZA => 'Ad Z-A';

  @override
  String get appDetail_bestPosition => 'En iyi siralama';

  @override
  String get appDetail_recentlyTracked => 'Son takip edilen';

  @override
  String get keywordSuggestions_title => 'Anahtar kelime onerileri';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$country icin $appName';
  }

  @override
  String get keywordSuggestions_refresh => 'Onerileri yenile';

  @override
  String get keywordSuggestions_search => 'Onerilerde ara...';

  @override
  String get keywordSuggestions_selectAll => 'Tumunu sec';

  @override
  String get keywordSuggestions_clear => 'Temizle';

  @override
  String get keywordSuggestions_analyzing =>
      'Uygulama meta verileri analiz ediliyor...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds =>
      'Bu birkac saniye surebilir';

  @override
  String get keywordSuggestions_noSuggestions => 'Oneri mevcut degil';

  @override
  String get keywordSuggestions_noMatchingSuggestions => 'Eslesen oneri yok';

  @override
  String get keywordSuggestions_headerKeyword => 'ANAHTAR KELIME';

  @override
  String get keywordSuggestions_headerDifficulty => 'ZORLUK';

  @override
  String get keywordSuggestions_headerApps => 'UYGULAMALAR';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return '#$position. sirada';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count anahtar kelime secildi';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return '$count anahtar kelime ekle';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Anahtar kelime eklenirken hata olustu: $error';
  }

  @override
  String get keywordSuggestions_categoryAll => 'Tumu';

  @override
  String get keywordSuggestions_categoryHighOpportunity => 'Firsatlar';

  @override
  String get keywordSuggestions_categoryCompetitor =>
      'Rakip anahtar kelimeleri';

  @override
  String get keywordSuggestions_categoryLongTail => 'Uzun kuyruk';

  @override
  String get keywordSuggestions_categoryTrending => 'Trendler';

  @override
  String get keywordSuggestions_categoryRelated => 'Iliskili';

  @override
  String get keywordSuggestions_generating => 'Oneriler olusturuluyor...';

  @override
  String get keywordSuggestions_generatingSubtitle =>
      'Bu birkac dakika surebilir. Daha sonra tekrar kontrol edin.';

  @override
  String get keywordSuggestions_checkAgain => 'Tekrar kontrol et';

  @override
  String get sidebar_favorites => 'FAVORILER';

  @override
  String get sidebar_tooManyFavorites =>
      '5 veya daha az favori tutmaya calisin';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Anahtar kelime arastirmasi';

  @override
  String get keywordSearch_searchPlaceholder => 'Anahtar kelime ara...';

  @override
  String get keywordSearch_searchTitle => 'Anahtar kelime ara';

  @override
  String get keywordSearch_searchSubtitle =>
      'Hangi uygulamalarin anahtar kelimeler icin siralandigini kesfet';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count uygulama siralandi';
  }

  @override
  String get keywordSearch_popularity => 'Populerlik';

  @override
  String keywordSearch_results(int count) {
    return '$count sonuc';
  }

  @override
  String get keywordSearch_headerRank => 'SIRALAMA';

  @override
  String get keywordSearch_headerApp => 'UYGULAMA';

  @override
  String get keywordSearch_headerRating => 'PUAN';

  @override
  String get keywordSearch_headerTrack => 'TAKIP';

  @override
  String get keywordSearch_trackApp => 'Bu uygulamayi takip et';

  @override
  String get discover_title => 'Kesfet';

  @override
  String get discover_tabKeywords => 'Anahtar kelimeler';

  @override
  String get discover_tabCategories => 'Kategoriler';

  @override
  String get discover_selectCategory => 'Bir kategori secin';

  @override
  String get discover_topFree => 'Ucretsiz';

  @override
  String get discover_topPaid => 'Ucretli';

  @override
  String get discover_topGrossing => 'En cok kazanan';

  @override
  String get discover_noResults => 'Sonuc yok';

  @override
  String get discover_loadingTopApps => 'En iyi uygulamalar yukleniyor...';

  @override
  String discover_topAppsIn(String collection, String category) {
    return '$category kategorisinde en iyi $collection';
  }

  @override
  String discover_appsCount(int count) {
    return '$count uygulama';
  }

  @override
  String get discover_allCategories => 'Tum kategoriler';

  @override
  String get category_games => 'Oyunlar';

  @override
  String get category_business => 'Is';

  @override
  String get category_education => 'Egitim';

  @override
  String get category_entertainment => 'Eglence';

  @override
  String get category_finance => 'Finans';

  @override
  String get category_food_drink => 'Yiyecek ve Icecek';

  @override
  String get category_health_fitness => 'Saglik ve Fitness';

  @override
  String get category_lifestyle => 'Yasam Tarzi';

  @override
  String get category_medical => 'Tip';

  @override
  String get category_music => 'Muzik';

  @override
  String get category_navigation => 'Navigasyon';

  @override
  String get category_news => 'Haberler';

  @override
  String get category_photo_video => 'Foto ve Video';

  @override
  String get category_productivity => 'Verimlilik';

  @override
  String get category_reference => 'Referans';

  @override
  String get category_shopping => 'Alisveris';

  @override
  String get category_social => 'Sosyal';

  @override
  String get category_sports => 'Spor';

  @override
  String get category_travel => 'Seyahat';

  @override
  String get category_utilities => 'Yardimci Programlar';

  @override
  String get category_weather => 'Hava Durumu';

  @override
  String get category_books => 'Kitaplar';

  @override
  String get category_developer_tools => 'Gelistirici Araclari';

  @override
  String get category_graphics_design => 'Grafik ve Tasarim';

  @override
  String get category_magazines => 'Dergiler ve Gazeteler';

  @override
  String get category_stickers => 'Cikartmalar';

  @override
  String get category_catalogs => 'Kataloglar';

  @override
  String get category_art_design => 'Sanat ve Tasarim';

  @override
  String get category_auto_vehicles => 'Otomotiv';

  @override
  String get category_beauty => 'Guzellik';

  @override
  String get category_comics => 'Cizgi Roman';

  @override
  String get category_communication => 'Iletisim';

  @override
  String get category_dating => 'Arkadas Bulma';

  @override
  String get category_events => 'Etkinlikler';

  @override
  String get category_house_home => 'Ev';

  @override
  String get category_libraries => 'Kutuphaneler';

  @override
  String get category_maps_navigation => 'Haritalar ve Navigasyon';

  @override
  String get category_music_audio => 'Muzik ve Ses';

  @override
  String get category_news_magazines => 'Haberler ve Dergiler';

  @override
  String get category_parenting => 'Ebeveynlik';

  @override
  String get category_personalization => 'Kisisellistirme';

  @override
  String get category_photography => 'Fotograf';

  @override
  String get category_tools => 'Araclar';

  @override
  String get category_video_players => 'Video Oynaticilar';

  @override
  String get category_all_apps => 'Tum uygulamalar';

  @override
  String reviews_reviewsFor(String appName) {
    return '$appName icin yorumlar';
  }

  @override
  String get reviews_loading => 'Yorumlar yukleniyor...';

  @override
  String get reviews_noReviews => 'Yorum yok';

  @override
  String reviews_noReviewsFor(String countryName) {
    return '$countryName icin yorum bulunamadi';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'App Store\'dan en son $count yorum gosteriliyor.';
  }

  @override
  String get reviews_today => 'Bugun';

  @override
  String get reviews_yesterday => 'Dun';

  @override
  String reviews_daysAgo(int count) {
    return '$count gun once';
  }

  @override
  String reviews_weeksAgo(int count) {
    return '$count hafta once';
  }

  @override
  String reviews_monthsAgo(int count) {
    return '$count ay once';
  }

  @override
  String get ratings_byCountry => 'Ulkeye gore puanlar';

  @override
  String get ratings_noRatingsAvailable => 'Puan mevcut degil';

  @override
  String get ratings_noRatingsYet => 'Bu uygulamanin henuz puani yok';

  @override
  String get ratings_totalRatings => 'Toplam puan';

  @override
  String get ratings_averageRating => 'Ortalama puan';

  @override
  String ratings_countriesCount(int count) {
    return '$count ulke';
  }

  @override
  String ratings_updated(String date) {
    return 'Guncellendi: $date';
  }

  @override
  String get ratings_headerCountry => 'ULKE';

  @override
  String get ratings_headerRatings => 'PUANLAR';

  @override
  String get ratings_headerAverage => 'ORTALAMA';

  @override
  String time_minutesAgo(int count) {
    return '${count}dk once';
  }

  @override
  String time_hoursAgo(int count) {
    return '${count}sa once';
  }

  @override
  String time_daysAgo(int count) {
    return '${count}g once';
  }

  @override
  String get appDetail_noKeywordsTracked => 'Takip edilen anahtar kelime yok';

  @override
  String get appDetail_addKeywordHint =>
      'Takibe baslamak icin yukariya bir anahtar kelime ekleyin';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Filtreyle eslesen anahtar kelime yok';

  @override
  String get appDetail_tryChangingFilter =>
      'Filtre kriterlerini degistirmeyi deneyin';

  @override
  String get appDetail_addTag => 'Etiket ekle';

  @override
  String get appDetail_addNote => 'Not ekle';

  @override
  String get appDetail_positionHistory => 'Siralama gecmisi';

  @override
  String get appDetail_store => 'MAGAZA';

  @override
  String get nav_overview => 'GENEL BAKIS';

  @override
  String get nav_dashboard => 'Kontrol Paneli';

  @override
  String get nav_myApps => 'Uygulamalarim';

  @override
  String get nav_research => 'ARASTIRMA';

  @override
  String get nav_keywords => 'Anahtar Kelimeler';

  @override
  String get nav_discover => 'Kesfet';

  @override
  String get nav_engagement => 'ETKILESIM';

  @override
  String get nav_reviewsInbox => 'Gelen Kutusu';

  @override
  String get nav_notifications => 'Uyarilar';

  @override
  String get nav_optimization => 'OPTIMIZASYON';

  @override
  String get nav_keywordInspector => 'Anahtar Kelime Denetleyicisi';

  @override
  String get nav_ratingsAnalysis => 'Puan Analizi';

  @override
  String get nav_intelligence => 'ISTIHBARAT';

  @override
  String get nav_topCharts => 'Populer Listeler';

  @override
  String get nav_competitors => 'Rakipler';

  @override
  String get common_save => 'Kaydet';

  @override
  String get appDetail_manageTags => 'Etiketleri yonet';

  @override
  String get appDetail_newTagHint => 'Yeni etiket adi...';

  @override
  String get appDetail_availableTags => 'Mevcut etiketler';

  @override
  String get appDetail_noTagsYet =>
      'Henuz etiket yok. Yukarida bir tane olusturun.';

  @override
  String get appDetail_addTagsTitle => 'Etiket ekle';

  @override
  String get appDetail_selectTagsDescription =>
      'Secili anahtar kelimelere eklenecek etiketleri secin:';

  @override
  String appDetail_addTagsCount(int count) {
    return '$count etiket ekle';
  }

  @override
  String get appDetail_currentTags => 'Mevcut etiketler';

  @override
  String get appDetail_noTagsOnKeyword => 'Bu anahtar kelimede etiket yok';

  @override
  String get appDetail_addExistingTag => 'Mevcut etiket ekle';

  @override
  String get appDetail_allTagsUsed => 'Tum etiketler zaten kullaniliyor';

  @override
  String get appDetail_createNewTag => 'Yeni etiket olustur';

  @override
  String get appDetail_tagNameHint => 'Etiket adi...';

  @override
  String get appDetail_note => 'Not';

  @override
  String get appDetail_noteHint =>
      'Bu anahtar kelime hakkinda bir not ekleyin...';

  @override
  String get appDetail_saveNote => 'Notu kaydet';

  @override
  String get appDetail_done => 'Tamamlandi';

  @override
  String appDetail_importFailed(String error) {
    return 'Ice aktarma basarisiz: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Anahtar kelimeleri ice aktar';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Anahtar kelimeleri asagiya yapistirin, her satira bir tane:';

  @override
  String get appDetail_keywordPlaceholder =>
      'anahtar kelime bir\nanahtar kelime iki\nanahtar kelime uc';

  @override
  String get appDetail_storefront => 'Magaza:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count anahtar kelime';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return '$count anahtar kelime ice aktar';
  }

  @override
  String get appDetail_period7d => '7g';

  @override
  String get appDetail_period30d => '30g';

  @override
  String get appDetail_period90d => '90g';

  @override
  String get keywords_difficultyFilter => 'Zorluk:';

  @override
  String get keywords_difficultyAll => 'Tumu';

  @override
  String get keywords_difficultyEasy => 'Kolay < 40';

  @override
  String get keywords_difficultyMedium => 'Orta 40-70';

  @override
  String get keywords_difficultyHard => 'Zor > 70';

  @override
  String reviews_version(String version) {
    return 'v$version';
  }

  @override
  String get appPreview_title => 'Uygulama detaylari';

  @override
  String get appPreview_notFound => 'Uygulama bulunamadi';

  @override
  String get appPreview_screenshots => 'Ekran goruntuleri';

  @override
  String get appPreview_description => 'Aciklama';

  @override
  String get appPreview_details => 'Detaylar';

  @override
  String get appPreview_version => 'Surum';

  @override
  String get appPreview_updated => 'Guncelleme';

  @override
  String get appPreview_released => 'Yayınlanma';

  @override
  String get appPreview_size => 'Boyut';

  @override
  String get appPreview_minimumOs => 'Gereksinim';

  @override
  String get appPreview_price => 'Fiyat';

  @override
  String get appPreview_free => 'Ücretsiz';

  @override
  String get appPreview_openInStore => 'Magazada ac';

  @override
  String get appPreview_addToMyApps => 'Uygulamalarima ekle';

  @override
  String get appPreview_added => 'Eklendi';

  @override
  String get appPreview_showMore => 'Daha fazla goster';

  @override
  String get appPreview_showLess => 'Daha az goster';

  @override
  String get appPreview_keywordsPlaceholder =>
      'Anahtar kelime takibini etkinlestirmek icin bu uygulamayi takip edilen uygulamalariniza ekleyin';

  @override
  String get notifications_title => 'Bildirimler';

  @override
  String get notifications_markAllRead => 'Tümünü okundu işaretle';

  @override
  String get notifications_empty => 'Henuz bildirim yok';

  @override
  String get alerts_title => 'Uyari kurallari';

  @override
  String get alerts_templatesTitle => 'Hizli sablonlar';

  @override
  String get alerts_templatesSubtitle =>
      'Yaygin uyarilari tek dokunusla etkinlestirin';

  @override
  String get alerts_myRulesTitle => 'Kurallarim';

  @override
  String get alerts_createRule => 'Kural olustur';

  @override
  String get alerts_editRule => 'Kurali duzenle';

  @override
  String get alerts_noRulesYet => 'Henuz kural yok';

  @override
  String get alerts_deleteConfirm => 'Kural silinsin mi?';

  @override
  String get alerts_createCustomRule => 'Ozel kural olustur';

  @override
  String alerts_ruleActivated(String name) {
    return '$name etkinlestirildi!';
  }

  @override
  String alerts_deleteMessage(String name) {
    return '\"$name\" silinecek.';
  }

  @override
  String get alerts_noRulesDescription =>
      'Bir sablon etkinlestirin veya kendinizinkini olusturun!';

  @override
  String get alerts_create => 'Olustur';

  @override
  String get settings_notifications => 'BILDIRIMLER';

  @override
  String get settings_manageAlerts => 'Uyari kurallarini yonet';

  @override
  String get settings_manageAlertsDesc =>
      'Hangi uyarilari alacaginizi yapilandirin';

  @override
  String get settings_storeConnections => 'Mağaza bağlantıları';

  @override
  String get settings_storeConnectionsDesc =>
      'App Store ve Google Play hesaplarinizi baglayiniz';

  @override
  String get settings_alertDelivery => 'UYARI TESLİMATI';

  @override
  String get settings_team => 'EKİP';

  @override
  String get settings_teamManagement => 'Ekip yönetimi';

  @override
  String get settings_teamManagementDesc =>
      'Invite members, manage roles & permissions';

  @override
  String get settings_integrations => 'Entegrasyonlar';

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
  String get storeConnections_title => 'Magaza baglantilari';

  @override
  String get storeConnections_description =>
      'Satis verileri ve uygulama analizleri gibi gelismis ozellikleri etkinlestirmek icin App Store ve Google Play hesaplarinizi baglayiniz.';

  @override
  String get storeConnections_appStoreConnect => 'App Store Connect';

  @override
  String get storeConnections_appStoreConnectDesc =>
      'Apple gelistirici hesabinizi baglayiniz';

  @override
  String get storeConnections_googlePlayConsole => 'Google Play Console';

  @override
  String get storeConnections_googlePlayConsoleDesc =>
      'Google Play hesabinizi baglayiniz';

  @override
  String get storeConnections_connect => 'Bagla';

  @override
  String get storeConnections_disconnect => 'Baglantisini kes';

  @override
  String get storeConnections_connected => 'Baglandi';

  @override
  String get storeConnections_disconnectConfirm => 'Baglanti kesilsin mi?';

  @override
  String storeConnections_disconnectMessage(String platform) {
    return 'Bu $platform hesabinin baglantisini kesmek istediginizden emin misiniz?';
  }

  @override
  String get storeConnections_disconnectSuccess => 'Baglanti basariyla kesildi';

  @override
  String storeConnections_lastSynced(String date) {
    return 'Son senkronizasyon: $date';
  }

  @override
  String storeConnections_connectedOn(String date) {
    return '$date tarihinde baglandi';
  }

  @override
  String get storeConnections_syncApps => 'Uygulamalari Senkronize Et';

  @override
  String get storeConnections_syncing => 'Senkronize ediliyor...';

  @override
  String get storeConnections_syncDescription =>
      'Senkronizasyon, bu hesaptaki uygulamalarinizi sahipli olarak isaretleyerek yorum yanitlamayi etkinlestirir.';

  @override
  String storeConnections_syncedApps(int count) {
    return '$count uygulama sahipli olarak senkronize edildi';
  }

  @override
  String storeConnections_syncFailed(String error) {
    return 'Senkronizasyon basarisiz: $error';
  }

  @override
  String storeConnections_errorLoading(String error) {
    return 'Baglantilar yuklenirken hata: $error';
  }

  @override
  String get reviewsInbox_title => 'Gelen kutusu';

  @override
  String get reviewsInbox_filterUnanswered => 'Yanitlanmamis';

  @override
  String get reviewsInbox_filterNegative => 'Olumsuz';

  @override
  String get reviewsInbox_noReviews => 'Yorum bulunamadi';

  @override
  String get reviewsInbox_noReviewsDesc => 'Filtrelerinizi ayarlamayi deneyin';

  @override
  String get reviewsInbox_reply => 'Yanitla';

  @override
  String get reviewsInbox_responded => 'Yanitlandi';

  @override
  String reviewsInbox_respondedAt(String date) {
    return '$date tarihinde yanitlandi';
  }

  @override
  String get reviewsInbox_replyModalTitle => 'Yorumu yanitla';

  @override
  String get reviewsInbox_generateAi => 'Yapay zeka onerisi olustur';

  @override
  String get reviewsInbox_generating => 'Olusturuluyor...';

  @override
  String get reviewsInbox_sendReply => 'Yaniti gonder';

  @override
  String get reviewsInbox_sending => 'Gonderiliyor...';

  @override
  String get reviewsInbox_replyPlaceholder => 'Yanitinizi yazin...';

  @override
  String reviewsInbox_charLimit(int count) {
    return '$count/5970 karakter';
  }

  @override
  String get reviewsInbox_replySent => 'Yanit basariyla gonderildi';

  @override
  String reviewsInbox_replyError(String error) {
    return 'Yanit gonderilemedi: $error';
  }

  @override
  String reviewsInbox_aiError(String error) {
    return 'Oneri olusturulamadi: $error';
  }

  @override
  String reviewsInbox_stars(int count) {
    return '$count yildiz';
  }

  @override
  String get reviewsInbox_totalReviews => 'Toplam yorum';

  @override
  String get reviewsInbox_unanswered => 'Yanitlanmamis';

  @override
  String get reviewsInbox_positive => 'Olumlu';

  @override
  String get reviewsInbox_avgRating => 'Ortalama puan';

  @override
  String get reviewsInbox_sentimentOverview => 'Duygu analizi ozeti';

  @override
  String get reviewsInbox_aiSuggestions => 'Yapay zeka onerileri';

  @override
  String get reviewsInbox_regenerate => 'Yeniden olustur';

  @override
  String get reviewsInbox_toneProfessional => 'Profesyonel';

  @override
  String get reviewsInbox_toneEmpathetic => 'Empatik';

  @override
  String get reviewsInbox_toneBrief => 'Kisa';

  @override
  String get reviewsInbox_selectTone => 'Ton secin:';

  @override
  String get reviewsInbox_detectedIssues => 'Tespit edilen sorunlar:';

  @override
  String get reviewsInbox_aiPrompt =>
      'Farkli 3 tonda yanit onerileri almak icin \'Yapay zeka onerisi olustur\' dugmesine tiklayin';

  @override
  String get reviewIntelligence_title => 'Yorum istihbarati';

  @override
  String get reviewIntelligence_featureRequests => 'Ozellik istekleri';

  @override
  String get reviewIntelligence_bugReports => 'Hata raporlari';

  @override
  String get reviewIntelligence_sentimentByVersion =>
      'Surume gore duygu analizi';

  @override
  String get reviewIntelligence_openFeatures => 'Acik ozellikler';

  @override
  String get reviewIntelligence_openBugs => 'Acik hatalar';

  @override
  String get reviewIntelligence_highPriority => 'Yuksek oncelik';

  @override
  String get reviewIntelligence_total => 'toplam';

  @override
  String get reviewIntelligence_mentions => 'bahsedilme';

  @override
  String get reviewIntelligence_noData => 'Henuz icerik yok';

  @override
  String get reviewIntelligence_noDataHint =>
      'Icerikler yorumlar analiz edildikten sonra gorunecek';

  @override
  String get analytics_title => 'Analitik';

  @override
  String get analytics_downloads => 'Indirmeler';

  @override
  String get analytics_revenue => 'Gelir';

  @override
  String get analytics_proceeds => 'Kazanc';

  @override
  String get analytics_subscribers => 'Aboneler';

  @override
  String get analytics_downloadsOverTime => 'Zaman icinde indirmeler';

  @override
  String get analytics_revenueOverTime => 'Zaman icinde gelir';

  @override
  String get analytics_byCountry => 'Ulkeye gore';

  @override
  String get analytics_noData => 'Veri yok';

  @override
  String get analytics_noDataTitle => 'Analitik verisi yok';

  @override
  String get analytics_noDataDescription =>
      'Gercek satis ve indirme verilerini gormek icin App Store Connect veya Google Play hesabinizi baglayiniz.';

  @override
  String analytics_dataDelay(String date) {
    return '$date itibariyle veriler. Apple verileri 24-48 saat gecikmeli olabilir.';
  }

  @override
  String get analytics_export => 'CSV disa aktar';

  @override
  String get funnel_title => 'Donusum hunisi';

  @override
  String get funnel_impressions => 'Gosterimler';

  @override
  String get funnel_pageViews => 'Sayfa goruntulemeler';

  @override
  String get funnel_downloads => 'Indirmeler';

  @override
  String get funnel_overallCvr => 'Genel CVR';

  @override
  String get funnel_categoryAvg => 'Kategori ort.';

  @override
  String get funnel_vsCategory => 'kategoriye kiyasla';

  @override
  String get funnel_bySource => 'Kaynaga gore';

  @override
  String get funnel_noData => 'Huni verisi mevcut degil';

  @override
  String get funnel_noDataHint =>
      'Huni verileri App Store Connect veya Google Play Console\'dan otomatik olarak senkronize edilecektir.';

  @override
  String get funnel_insight => 'BILGI';

  @override
  String funnel_insightText(
    String bestSource,
    String ratio,
    String worstSource,
    String recommendation,
  ) {
    return '$bestSource trafigi $worstSource trafikinden ${ratio}x daha iyi donusturuyor. $recommendation';
  }

  @override
  String get funnel_insightRecommendSearch =>
      'Arama gosterimlerini artirmak icin anahtar kelime optimizasyonuna odaklanin.';

  @override
  String get funnel_insightRecommendBrowse =>
      'Kategorileri ve one cikan yerlesimleri optimize ederek uygulamanizin gozetim gorunurlugunu artirin.';

  @override
  String get funnel_insightRecommendReferral =>
      'Daha fazla trafik ceknek icin tavsiye programlarindan ve ortakliklardan yararlanin.';

  @override
  String get funnel_insightRecommendAppReferrer =>
      'Tamamlayici uygulamalarla capraz tanitim stratejileri dusunun.';

  @override
  String get funnel_insightRecommendWebReferrer =>
      'Web sitenizi ve hedef sayfalarinizi indirmeler icin optimize edin.';

  @override
  String get funnel_insightRecommendDefault =>
      'Bu kaynagi basarili yapan seyleri analiz edin ve tekrarlayin.';

  @override
  String get funnel_trendTitle => 'Donusum orani trendi';

  @override
  String get funnel_connectStore => 'Magazayi bagla';

  @override
  String get nav_chat => 'Yapay Zeka Asistani';

  @override
  String get chat_title => 'Yapay Zeka Asistani';

  @override
  String get chat_newConversation => 'Yeni konusma';

  @override
  String get chat_loadingConversations => 'Konusmalar yukleniyor...';

  @override
  String get chat_loadingMessages => 'Mesajlar yukleniyor...';

  @override
  String get chat_noConversations => 'Konusma yok';

  @override
  String get chat_noConversationsDesc =>
      'Uygulamalariniz hakkinda yapay zeka icerikleri almak icin yeni bir konusma baslatiniz';

  @override
  String get chat_startConversation => 'Konusma baslat';

  @override
  String get chat_deleteConversation => 'Konusmayi sil';

  @override
  String get chat_deleteConversationConfirm =>
      'Bu konusmayi silmek istediginizden emin misiniz?';

  @override
  String get chat_askAnything => 'Bana bir soru sorun';

  @override
  String get chat_askAnythingDesc =>
      'Uygulamanizin yorumlarini, siralamalarini ve analizlerini anlamaniza yardimci olabilirim';

  @override
  String get chat_typeMessage => 'Sorunuzu yazin...';

  @override
  String get chat_suggestedQuestions => 'Onerilen sorular';

  @override
  String get chatActionConfirm => 'Onayla';

  @override
  String get chatActionCancel => 'Iptal';

  @override
  String get chatActionExecuting => 'Yurutuluyur...';

  @override
  String get chatActionExecuted => 'Tamamlandi';

  @override
  String get chatActionFailed => 'Basarisiz';

  @override
  String get chatActionCancelled => 'Iptal edildi';

  @override
  String get chatActionDownload => 'Indir';

  @override
  String get chatActionReversible => 'Bu islem geri alinabilir';

  @override
  String get chatActionAddKeywords => 'Anahtar kelime ekle';

  @override
  String get chatActionRemoveKeywords => 'Anahtar kelime kaldir';

  @override
  String get chatActionCreateAlert => 'Uyari olustur';

  @override
  String get chatActionAddCompetitor => 'Rakip ekle';

  @override
  String get chatActionExportData => 'Verileri disa aktar';

  @override
  String get chatActionKeywords => 'Anahtar kelimeler';

  @override
  String get chatActionCountry => 'Ulke';

  @override
  String get chatActionAlertCondition => 'Kosul';

  @override
  String get chatActionNotifyVia => 'Bildirim yontemi';

  @override
  String get chatActionCompetitor => 'Rakip';

  @override
  String get chatActionExportType => 'Disa aktarma turu';

  @override
  String get chatActionDateRange => 'Tarih araligi';

  @override
  String get chatActionKeywordsLabel => 'Anahtar kelimeler';

  @override
  String get chatActionAnalyticsLabel => 'Istatistikler';

  @override
  String get chatActionReviewsLabel => 'Yorumlar';

  @override
  String get common_cancel => 'Iptal';

  @override
  String get common_delete => 'Sil';

  @override
  String get appDetail_tabOverview => 'Genel bakis';

  @override
  String get appDetail_tabKeywords => 'Anahtar kelimeler';

  @override
  String get appDetail_tabReviews => 'Yorumlar';

  @override
  String get appDetail_tabRatings => 'Puanlar';

  @override
  String get appDetail_tabInsights => 'Analizler';

  @override
  String get dateRange_title => 'Tarih araligi';

  @override
  String get dateRange_today => 'Bugun';

  @override
  String get dateRange_yesterday => 'Dun';

  @override
  String get dateRange_last7Days => 'Son 7 gun';

  @override
  String get dateRange_last30Days => 'Son 30 gun';

  @override
  String get dateRange_thisMonth => 'Bu ay';

  @override
  String get dateRange_lastMonth => 'Gecen ay';

  @override
  String get dateRange_last90Days => 'Son 90 gun';

  @override
  String get dateRange_yearToDate => 'Yil basindan itibaren';

  @override
  String get dateRange_allTime => 'Tum zamanlar';

  @override
  String get dateRange_custom => 'Ozel...';

  @override
  String get dateRange_compareToPrevious => 'Onceki donemle karsilastir';

  @override
  String get export_keywordsTitle => 'Anahtar kelimeleri disa aktar';

  @override
  String get export_reviewsTitle => 'Yorumlari disa aktar';

  @override
  String get export_analyticsTitle => 'Analitikleri disa aktar';

  @override
  String get export_columnsToInclude => 'Dahil edilecek sutunlar:';

  @override
  String get export_button => 'Disa aktar';

  @override
  String get export_keyword => 'Anahtar kelime';

  @override
  String get export_position => 'Siralama';

  @override
  String get export_change => 'Degisim';

  @override
  String get export_popularity => 'Populerlik';

  @override
  String get export_difficulty => 'Zorluk';

  @override
  String get export_tags => 'Etiketler';

  @override
  String get export_notes => 'Notlar';

  @override
  String get export_trackedSince => 'Takip baslangici';

  @override
  String get export_date => 'Tarih';

  @override
  String get export_rating => 'Puan';

  @override
  String get export_author => 'Yazar';

  @override
  String get export_title => 'Baslik';

  @override
  String get export_content => 'Icerik';

  @override
  String get export_country => 'Ulke';

  @override
  String get export_version => 'Surum';

  @override
  String get export_sentiment => 'Duygu';

  @override
  String get export_response => 'Yanitimiz';

  @override
  String get export_responseDate => 'Yanit tarihi';

  @override
  String export_keywordsCount(int count) {
    return '$count anahtar kelime disa aktarilacak';
  }

  @override
  String export_reviewsCount(int count) {
    return '$count yorum disa aktarilacak';
  }

  @override
  String export_success(String filename) {
    return 'Disa aktarma kaydedildi: $filename';
  }

  @override
  String export_error(String error) {
    return 'Disa aktarma basarisiz: $error';
  }

  @override
  String get metadata_editor => 'Meta veri duzenleyicisi';

  @override
  String get metadata_selectLocale => 'Duzenlenecek bir yerel ayar secin';

  @override
  String get metadata_refreshed => 'Meta veriler magazadan yenilendi';

  @override
  String get metadata_connectRequired => 'Duzenleme icin baglanti gerekli';

  @override
  String get metadata_connectDescription =>
      'Uygulama meta verilerinizi dogrudan Keyrank\'ten duzenlemek icin App Store Connect hesabinizi baglayiniz.';

  @override
  String get metadata_connectStore => 'App Store\'u bagla';

  @override
  String get metadata_publishTitle => 'Meta verileri yayinla';

  @override
  String metadata_publishConfirm(String locale) {
    return '$locale icin degisiklikler yayinlansin mi? Bu, App Store\'daki uygulama listenizi guncelleyecektir.';
  }

  @override
  String get metadata_publish => 'Yayinla';

  @override
  String get metadata_publishSuccess => 'Meta veriler basariyla yayinlandi';

  @override
  String get metadata_saveDraft => 'Taslagi kaydet';

  @override
  String get metadata_draftSaved => 'Taslak kaydedildi';

  @override
  String get metadata_discardChanges => 'Degisiklikleri iptal et';

  @override
  String get metadata_title => 'Baslik';

  @override
  String metadata_titleHint(int limit) {
    return 'Uygulama adi (maks. $limit karakter)';
  }

  @override
  String get metadata_subtitle => 'Alt baslik';

  @override
  String metadata_subtitleHint(int limit) {
    return 'Kisa aciklama (maks. $limit karakter)';
  }

  @override
  String get metadata_keywords => 'Anahtar kelimeler';

  @override
  String metadata_keywordsHint(int limit) {
    return 'Virgullerle ayrilmis anahtar kelimeler (maks. $limit karakter)';
  }

  @override
  String get metadata_description => 'Aciklama';

  @override
  String metadata_descriptionHint(int limit) {
    return 'Tam uygulama aciklamasi (maks. $limit karakter)';
  }

  @override
  String get metadata_promotionalText => 'Tanitim metni';

  @override
  String metadata_promotionalTextHint(int limit) {
    return 'Kisa tanitim mesaji (maks. $limit karakter)';
  }

  @override
  String get metadata_whatsNew => 'Yenilikler';

  @override
  String metadata_whatsNewHint(int limit) {
    return 'Surum notlari (maks. $limit karakter)';
  }

  @override
  String metadata_charCount(int count, int limit) {
    return '$count/$limit';
  }

  @override
  String get metadata_hasChanges => 'Kaydedilmemis degisiklikler';

  @override
  String get metadata_noChanges => 'Degisiklik yok';

  @override
  String get metadata_keywordAnalysis => 'Anahtar kelime analizi';

  @override
  String get metadata_keywordPresent => 'Mevcut';

  @override
  String get metadata_keywordMissing => 'Eksik';

  @override
  String get metadata_inTitle => 'Baslikta';

  @override
  String get metadata_inSubtitle => 'Alt baslikta';

  @override
  String get metadata_inKeywords => 'Anahtar kelimelerde';

  @override
  String get metadata_inDescription => 'Aciklamada';

  @override
  String get metadata_history => 'Degisiklik gecmisi';

  @override
  String get metadata_noHistory => 'Kaydedilmis degisiklik yok';

  @override
  String get metadata_localeComplete => 'Tamamlandi';

  @override
  String get metadata_localeIncomplete => 'Tamamlanmadi';

  @override
  String get metadata_shortDescription => 'Kisa aciklama';

  @override
  String metadata_shortDescriptionHint(int limit) {
    return 'Aramada gorunen aciklama (maks. $limit karakter)';
  }

  @override
  String get metadata_fullDescription => 'Tam aciklama';

  @override
  String metadata_fullDescriptionHint(int limit) {
    return 'Tam uygulama aciklamasi (maks. $limit karakter)';
  }

  @override
  String get metadata_releaseNotes => 'Surum notlari';

  @override
  String metadata_releaseNotesHint(int limit) {
    return 'Bu surumde yenilikler (maks. $limit karakter)';
  }

  @override
  String get metadata_selectAppFirst => 'Bir uygulama secin';

  @override
  String get metadata_selectAppHint =>
      'Baslamak icin kenar cubugundaki uygulama seciciyi kullanin veya bir magaza baglayiniz.';

  @override
  String get metadata_noStoreConnection => 'Magaza baglantisi gerekli';

  @override
  String metadata_noStoreConnectionDesc(String storeName) {
    return 'Uygulama meta verilerinizi almak ve duzenlemek icin $storeName hesabinizi baglayiniz.';
  }

  @override
  String metadata_connectStoreButton(String storeName) {
    return '$storeName bagla';
  }

  @override
  String get metadataLocalization => 'Yerellestirilmeler';

  @override
  String get metadataLive => 'Yayinda';

  @override
  String get metadataDraft => 'Taslak';

  @override
  String get metadataEmpty => 'Bos';

  @override
  String metadataCoverageInsight(int count) {
    return '$count yerel ayar icin icerik gerekiyor. Ana pazarlariniz icin yerleslestirme yapmayidusunebiliniz.';
  }

  @override
  String get metadataFilterAll => 'Tumu';

  @override
  String get metadataFilterLive => 'Yayinda';

  @override
  String get metadataFilterDraft => 'Taslaklar';

  @override
  String get metadataFilterEmpty => 'Boslar';

  @override
  String get metadataBulkActions => 'Toplu islemler';

  @override
  String get metadataCopyTo => 'Secime kopyala';

  @override
  String get metadataTranslateTo => 'Secime cevir';

  @override
  String get metadataPublishSelected => 'Secimi yayinla';

  @override
  String get metadataDeleteDrafts => 'Taslaklari sil';

  @override
  String get metadataSelectSource => 'Kaynak yerel ayari secin';

  @override
  String get metadataSelectTarget => 'Hedef yerel ayarlari secin';

  @override
  String metadataCopySuccess(int count) {
    return 'Icerik $count yerel ayara kopyalandi';
  }

  @override
  String metadataTranslateSuccess(int count) {
    return '$count yerel ayara cevirildi';
  }

  @override
  String get metadataTranslating => 'Ceviriliyor...';

  @override
  String get metadataNoSelection => 'Once yerel ayar secin';

  @override
  String get metadataSelectAll => 'Tumunu sec';

  @override
  String get metadataDeselectAll => 'Secimi kaldir';

  @override
  String metadataSelected(int count) {
    return '$count secildi';
  }

  @override
  String get metadataTableView => 'Tablo gorunumu';

  @override
  String get metadataListView => 'Liste gorunumu';

  @override
  String get metadataStatus => 'Durum';

  @override
  String get metadataCompletion => 'Tamamlanma';

  @override
  String get common_back => 'Geri';

  @override
  String get common_next => 'Ileri';

  @override
  String get common_edit => 'Duzenle';

  @override
  String get metadata_aiOptimize => 'Yapay zeka ile optimize et';

  @override
  String get wizard_title => 'Yapay zeka optimizasyon sihirbazi';

  @override
  String get wizard_step => 'Adim';

  @override
  String get wizard_of => '/';

  @override
  String get wizard_stepTitle => 'Baslik';

  @override
  String get wizard_stepSubtitle => 'Alt baslik';

  @override
  String get wizard_stepKeywords => 'Anahtar kelimeler';

  @override
  String get wizard_stepDescription => 'Aciklama';

  @override
  String get wizard_stepReview => 'Gozden gecir ve kaydet';

  @override
  String get wizard_skip => 'Atla';

  @override
  String get wizard_saveDrafts => 'Taslaklari kaydet';

  @override
  String get wizard_draftsSaved => 'Taslaklar basariyla kaydedildi';

  @override
  String get wizard_exitTitle => 'Sihirbazdan cik?';

  @override
  String get wizard_exitMessage =>
      'Kaydedilmemis degisiklikleriniz var. Cikmak istediginizden emin misiniz?';

  @override
  String get wizard_exitConfirm => 'Cik';

  @override
  String get wizard_aiSuggestions => 'Yapay zeka onerileri';

  @override
  String get wizard_chooseSuggestion =>
      'Yapay zeka tarafindan olusturulan bir oneri secin veya kendiniz yazin';

  @override
  String get wizard_currentValue => 'Mevcut deger';

  @override
  String get wizard_noCurrentValue => 'Deger belirlenmemis';

  @override
  String wizard_contextInfo(int keywordsCount, int competitorsCount) {
    return '$keywordsCount takip edilen anahtar kelime ve $competitorsCount rakibe dayali';
  }

  @override
  String get wizard_writeOwn => 'Kendim yaz';

  @override
  String get wizard_customPlaceholder => 'Ozel degerinizi girin...';

  @override
  String get wizard_useCustom => 'Ozeli kullan';

  @override
  String get wizard_keepCurrent => 'Mevcut olanai koru';

  @override
  String get wizard_recommended => 'Onerilen';

  @override
  String get wizard_characters => 'karakter';

  @override
  String get wizard_reviewTitle => 'Degisiklikleri gozden gecir';

  @override
  String get wizard_reviewDescription =>
      'Taslak olarak kaydetmeden once optimizasyonlarinizi gozden gecirin';

  @override
  String get wizard_noChanges => 'Secili degisiklik yok';

  @override
  String get wizard_noChangesHint =>
      'Geri donun ve optimize edilecek alanlar icin oneriler secin';

  @override
  String wizard_changesCount(int count) {
    return '$count alan guncellendi';
  }

  @override
  String get wizard_changesSummary =>
      'Bu degisiklikler taslak olarak kaydedilecek';

  @override
  String get wizard_before => 'Once';

  @override
  String get wizard_after => 'Sonra';

  @override
  String get wizard_nextStepsTitle => 'Sirada ne var?';

  @override
  String get wizard_nextStepsWithChanges =>
      'Degisiklikleriniz taslak olarak kaydedilecek. Meta veri duzenleyicisinden gozden gecirebilir ve yayinlayabilirsiniz.';

  @override
  String get wizard_nextStepsNoChanges =>
      'Kaydedilecek degisiklik yok. Geri donun ve meta verilerinizi optimize etmek icin oneriler secin.';

  @override
  String get team_title => 'Takim Yonetimi';

  @override
  String get team_createTeam => 'Takim Olustur';

  @override
  String get team_teamName => 'Takim Adi';

  @override
  String get team_teamNameHint => 'Takim adini girin';

  @override
  String get team_description => 'Aciklama (istege bagli)';

  @override
  String get team_descriptionHint => 'Bu takim ne icin?';

  @override
  String get team_teamNameRequired => 'Takim adi gereklidir';

  @override
  String get team_teamNameMinLength => 'Takim adi en az 2 karakter olmalidir';

  @override
  String get team_inviteMember => 'Uye Davet Et';

  @override
  String get team_emailAddress => 'E-posta Adresi';

  @override
  String get team_emailHint => 'meslektas@ornek.com';

  @override
  String get team_emailRequired => 'E-posta gereklidir';

  @override
  String get team_emailInvalid => 'Gecerli bir e-posta adresi girin';

  @override
  String team_invitationSent(String email) {
    return '$email adresine davet gonderildi';
  }

  @override
  String get team_members => 'UYELER';

  @override
  String get team_invite => 'Davet Et';

  @override
  String get team_pendingInvitations => 'BEKLEYEN DAVETLER';

  @override
  String get team_noPendingInvitations => 'Bekleyen davet yok';

  @override
  String get team_teamSettings => 'Takim Ayarlari';

  @override
  String team_changeRole(String name) {
    return '$name icin rol degistir';
  }

  @override
  String get team_removeMember => 'Uyeyi Kaldir';

  @override
  String team_removeMemberConfirm(String name) {
    return '$name adli uyeyi bu takimdan kaldirmak istediginizden emin misiniz?';
  }

  @override
  String get team_remove => 'Kaldir';

  @override
  String get team_leaveTeam => 'Takimdan Ayril';

  @override
  String team_leaveTeamConfirm(String teamName) {
    return '\"$teamName\" takimindan ayrilmak istediginizden emin misiniz?';
  }

  @override
  String get team_leave => 'Ayril';

  @override
  String get team_deleteTeam => 'Takimi Sil';

  @override
  String team_deleteTeamConfirm(String teamName) {
    return '\"$teamName\" takimini silmek istediginizden emin misiniz? Bu islem geri alinamaz.';
  }

  @override
  String get team_yourTeams => 'TAKIMLARINIZ';

  @override
  String get team_failedToLoadTeam => 'Takim yuklenemedi';

  @override
  String get team_failedToLoadMembers => 'Uyeler yuklenemedi';

  @override
  String get team_failedToLoadInvitations => 'Davetler yuklenemedi';

  @override
  String team_memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uye',
      one: '1 uye',
    );
    return '$_temp0';
  }

  @override
  String team_invitedAs(String role) {
    return '$role olarak davet edildi';
  }

  @override
  String team_joinedTeam(String teamName) {
    return '$teamName takimina katildiniz';
  }

  @override
  String get team_invitationDeclined => 'Davet reddedildi';

  @override
  String get team_noTeamsYet => 'Henuz takim yok';

  @override
  String get team_noTeamsDescription =>
      'Uygulamalarinizda baskalariyla isbirligi yapmak icin bir takim olusturun';

  @override
  String get team_createFirstTeam => 'Ilk takiminizi olusturun';

  @override
  String get integrations_title => 'Entegrasyonlar';

  @override
  String integrations_syncFailed(String error) {
    return 'Senkronizasyon basarisiz: $error';
  }

  @override
  String get integrations_disconnectConfirm => 'Baglanti kesilsin mi?';

  @override
  String get integrations_disconnectedSuccess => 'Baglanti basariyla kesildi';

  @override
  String get integrations_connectGooglePlay => 'Google Play Console Bagla';

  @override
  String get integrations_connectAppStore => 'App Store Connect Bagla';

  @override
  String integrations_connectedApps(int count) {
    return 'Baglandi! $count uygulama iceri aktarildi.';
  }

  @override
  String integrations_syncedApps(int count) {
    return '$count uygulama sahip olarak senkronize edildi';
  }

  @override
  String get integrations_appStoreConnected =>
      'App Store Connect basariyla baglandi!';

  @override
  String get integrations_googlePlayConnected =>
      'Google Play Console basariyla baglandi!';

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
  String get alertBuilder_nameYourRule => 'KURALINIZI ADLANDIRIN';

  @override
  String get alertBuilder_nameDescription =>
      'Uyari kuraliniza aciklayici bir ad verin';

  @override
  String get alertBuilder_nameHint => 'orn: Gunluk Pozisyon Uyarisi';

  @override
  String get alertBuilder_summary => 'OZET';

  @override
  String get alertBuilder_saveAlertRule => 'Uyari Kuralini Kaydet';

  @override
  String get alertBuilder_selectAlertType => 'UYARI TURUNU SECIN';

  @override
  String get alertBuilder_selectAlertTypeDescription =>
      'Ne tur bir uyari olusturmak istediginizi secin';

  @override
  String alertBuilder_deleteRuleConfirm(String ruleName) {
    return '\"$ruleName\" silinecek.';
  }

  @override
  String get alertBuilder_activateTemplateOrCreate =>
      'Henuz kural yok. Bir sablon etkinlestirin veya kendiniz olusturun!';

  @override
  String get billing_cancelSubscription => 'Aboneligi Iptal Et';

  @override
  String get billing_keepSubscription => 'Aboneligi Koru';

  @override
  String get billing_billingPortal => 'Fatura Portali';

  @override
  String get billing_resume => 'Devam Et';

  @override
  String get keywords_noCompetitorsFound =>
      'Rakip bulunamadı. Önce rakip ekleyin.';

  @override
  String get keywords_noCompetitorsForApp =>
      'Bu uygulama için rakip yok. Önce bir rakip ekleyin.';

  @override
  String keywords_failedToAddKeywords(String error) {
    return 'Anahtar kelimeler eklenemedi: $error';
  }

  @override
  String get keywords_bulkAddHint =>
      'butce takipcisi\nharcama yoneticisi\npara uygulamasi';

  @override
  String get appOverview_urlCopied => 'Magaza URL\'si panoya kopyalandi';

  @override
  String get country_us => 'Amerika Birlesik Devletleri';

  @override
  String get country_gb => 'Birlesik Krallik';

  @override
  String get country_fr => 'Fransa';

  @override
  String get country_de => 'Almanya';

  @override
  String get country_ca => 'Kanada';

  @override
  String get country_au => 'Avustralya';

  @override
  String get country_jp => 'Japonya';

  @override
  String get country_cn => 'Cin';

  @override
  String get country_kr => 'Guney Kore';

  @override
  String get country_br => 'Brezilya';

  @override
  String get country_es => 'Ispanya';

  @override
  String get country_it => 'Italya';

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
  String get alertBuilder_type => 'Tür';

  @override
  String get alertBuilder_scope => 'Kapsam';

  @override
  String get alertBuilder_name => 'Ad';

  @override
  String get alertBuilder_scopeGlobal => 'Tüm uygulamalar';

  @override
  String get alertBuilder_scopeApp => 'Belirli uygulama';

  @override
  String get alertBuilder_scopeCategory => 'Kategori';

  @override
  String get alertBuilder_scopeKeyword => 'Anahtar kelime';

  @override
  String get alertType_positionChange => 'Sıralama değişikliği';

  @override
  String get alertType_positionChangeDesc =>
      'Uygulama sıralaması önemli ölçüde değiştiğinde uyarı';

  @override
  String get alertType_ratingChange => 'Puan değişikliği';

  @override
  String get alertType_ratingChangeDesc => 'Uygulama puanı değiştiğinde uyarı';

  @override
  String get alertType_reviewSpike => 'Yorum artışı';

  @override
  String get alertType_reviewSpikeDesc => 'Olağandışı yorum etkinliğinde uyarı';

  @override
  String get alertType_reviewKeyword => 'Yorum anahtar kelimesi';

  @override
  String get alertType_reviewKeywordDesc =>
      'Yorumlarda anahtar kelimeler göründüğünde uyarı';

  @override
  String get alertType_newCompetitor => 'Yeni rakip';

  @override
  String get alertType_newCompetitorDesc =>
      'Yeni uygulamalar alanınıza girdiğinde uyarı';

  @override
  String get alertType_competitorPassed => 'Rakip geçildi';

  @override
  String get alertType_competitorPassedDesc => 'Bir rakibi geçtiğinizde uyarı';

  @override
  String get alertType_massMovement => 'Toplu hareket';

  @override
  String get alertType_massMovementDesc =>
      'Büyük sıralama değişikliklerinde uyarı';

  @override
  String get alertType_keywordTrend => 'Anahtar kelime trendi';

  @override
  String get alertType_keywordTrendDesc =>
      'Anahtar kelime popülaritesi değiştiğinde uyarı';

  @override
  String get alertType_opportunity => 'Fırsat';

  @override
  String get alertType_opportunityDesc => 'Yeni sıralama fırsatlarında uyarı';

  @override
  String get billing_title => 'Faturalandırma ve Planlar';

  @override
  String get billing_subscriptionActivated =>
      'Abonelik başarıyla etkinleştirildi!';

  @override
  String get billing_changePlan => 'Plan değiştir';

  @override
  String get billing_choosePlan => 'Plan seç';

  @override
  String get billing_cancelMessage =>
      'Aboneliğiniz mevcut faturalandırma döneminin sonuna kadar aktif kalacaktır. Bundan sonra premium özelliklere erişiminizi kaybedeceksiniz.';

  @override
  String get billing_currentPlan => 'MEVCUT PLAN';

  @override
  String get billing_trial => 'DENEME';

  @override
  String get billing_canceling => 'İPTAL EDİLİYOR';

  @override
  String billing_accessUntil(String date) {
    return '$date tarihine kadar erişim';
  }

  @override
  String billing_renewsOn(String date) {
    return '$date tarihinde yenilenir';
  }

  @override
  String get billing_manageSubscription => 'ABONELİĞİ YÖNET';

  @override
  String get billing_monthly => 'Aylık';

  @override
  String get billing_yearly => 'Yıllık';

  @override
  String billing_savePercent(int percent) {
    return '%$percent tasarruf';
  }

  @override
  String get billing_current => 'Mevcut';

  @override
  String get billing_apps => 'Uygulamalar';

  @override
  String get billing_unlimited => 'Sınırsız';

  @override
  String get billing_keywordsPerApp => 'Uygulama başına anahtar kelime';

  @override
  String get billing_history => 'Geçmiş';

  @override
  String billing_days(int count) {
    return '$count gün';
  }

  @override
  String get billing_exports => 'Dışa aktarma';

  @override
  String get billing_aiInsights => 'AI analizleri';

  @override
  String get billing_apiAccess => 'API erişimi';

  @override
  String get billing_yes => 'Evet';

  @override
  String get billing_no => 'Hayır';

  @override
  String get billing_currentPlanButton => 'Mevcut plan';

  @override
  String billing_upgradeTo(String planName) {
    return '$planName\'a yükselt';
  }

  @override
  String get billing_cancel => 'İptal';

  @override
  String get keywords_compareWithCompetitor => 'Rakiple karşılaştır';

  @override
  String get keywords_selectCompetitorToCompare =>
      'Anahtar kelimeleri karşılaştırmak için bir rakip seçin:';

  @override
  String get keywords_addToCompetitor => 'Rakibe ekle';

  @override
  String keywords_addKeywordsTo(int count) {
    return '$count anahtar kelime ekle:';
  }

  @override
  String get keywords_avgPosition => 'Ort. Sıralama';

  @override
  String get keywords_declined => 'Düştü';

  @override
  String get keywords_total => 'Toplam';

  @override
  String get keywords_ranked => 'Sıralanmış';

  @override
  String get keywords_improved => 'Yükselen';

  @override
  String get onboarding_skip => 'Atla';

  @override
  String get onboarding_back => 'Back';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_getStarted => 'Başla';

  @override
  String get onboarding_welcomeToKeyrank => 'Keyrank\'e hoş geldiniz';

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
  String get team_you => 'Sen';

  @override
  String get team_changeRoleButton => 'Change Role';

  @override
  String get team_removeButton => 'Remove';

  @override
  String get competitors_removeTitle => 'Remove Competitor';

  @override
  String competitors_removeConfirm(String name) {
    return '\"$name\" adlı rakibi kaldırmak istediğinizden emin misiniz?';
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
    return 'Rakip eklenemedi: $error';
  }

  @override
  String get competitors_searchForCompetitor => 'Search for a competitor';

  @override
  String get appPreview_back => 'Back';

  @override
  String get alerts_edit => 'Düzenle';

  @override
  String get alerts_scopeGlobal => 'Global';

  @override
  String get alerts_scopeApp => 'Uygulama';

  @override
  String get alerts_scopeCategory => 'Kategori';

  @override
  String get alerts_scopeKeyword => 'Anahtar kelime';

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
    return '$count içgörü daha görüntüle';
  }

  @override
  String get insights_noInsightsDesc =>
      'Uygulamanız için optimizasyon fırsatları keşfettiğimizde içgörüler görünecektir.';

  @override
  String get insights_loadFailed => 'İçgörüler yüklenemedi';

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
