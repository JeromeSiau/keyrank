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
  String get common_search => 'Ara...';

  @override
  String get common_noResults => 'Sonuç bulunamadı';

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

  @override
  String get insights_compareTitle => 'İçgörüleri Karşılaştır';

  @override
  String get insights_analyzingReviews => 'Yorumlar analiz ediliyor...';

  @override
  String get insights_noInsightsAvailable => 'İçgörü mevcut değil';

  @override
  String get insights_strengths => 'Güçlü Yönler';

  @override
  String get insights_weaknesses => 'Zayıf Yönler';

  @override
  String get insights_scores => 'Puanlar';

  @override
  String get insights_opportunities => 'Fırsatlar';

  @override
  String get insights_categoryUx => 'KD';

  @override
  String get insights_categoryPerf => 'Perf';

  @override
  String get insights_categoryFeatures => 'Özellikler';

  @override
  String get insights_categoryPricing => 'Fiyatlandırma';

  @override
  String get insights_categorySupport => 'Destek';

  @override
  String get insights_categoryOnboard => 'Başlangıç';

  @override
  String get insights_categoryUxFull => 'KD / Arayüz';

  @override
  String get insights_categoryPerformance => 'Performans';

  @override
  String get insights_categoryOnboarding => 'İlk Kullanım';

  @override
  String get insights_reviewInsights => 'Yorum İçgörüleri';

  @override
  String get insights_generateFirst => 'Önce içgörü oluşturun';

  @override
  String get insights_compareWithOther => 'Diğer uygulamalarla karşılaştır';

  @override
  String get insights_compare => 'Karşılaştır';

  @override
  String get insights_generateAnalysis => 'Analiz Oluştur';

  @override
  String get insights_period => 'Dönem:';

  @override
  String get insights_3months => '3 ay';

  @override
  String get insights_6months => '6 ay';

  @override
  String get insights_12months => '12 ay';

  @override
  String get insights_analyze => 'Analiz Et';

  @override
  String insights_reviewsCount(int count) {
    return '$count yorum';
  }

  @override
  String insights_analyzedAgo(String time) {
    return '$time önce analiz edildi';
  }

  @override
  String get insights_yourNotes => 'Notlarınız';

  @override
  String get insights_save => 'Kaydet';

  @override
  String get insights_clickToAddNotes => 'Not eklemek için tıklayın...';

  @override
  String get insights_noteSaved => 'Not kaydedildi';

  @override
  String get insights_noteHint =>
      'Bu içgörü analizi hakkında notlarınızı ekleyin...';

  @override
  String get insights_categoryScores => 'Kategori Puanları';

  @override
  String get insights_emergentThemes => 'Öne Çıkan Temalar';

  @override
  String get insights_exampleQuotes => 'Örnek alıntılar:';

  @override
  String get insights_selectCountryFirst => 'En az bir ülke seçin';

  @override
  String compare_selectAppsToCompare(String appName) {
    return '$appName ile karşılaştırmak için en fazla 3 uygulama seçin';
  }

  @override
  String get compare_searchApps => 'Uygulama ara...';

  @override
  String get compare_noOtherApps => 'Karşılaştırılacak başka uygulama yok';

  @override
  String get compare_noMatchingApps => 'Eşleşen uygulama yok';

  @override
  String compare_appsSelected(int count) {
    return '3 uygulamadan $count tanesi seçildi';
  }

  @override
  String get compare_cancel => 'İptal';

  @override
  String compare_button(int count) {
    return '$count Uygulamayı Karşılaştır';
  }

  @override
  String get appDetail_deleteAppTitle => 'Uygulama silinsin mi?';

  @override
  String get appDetail_deleteAppConfirm => 'Bu işlem geri alınamaz.';

  @override
  String get appDetail_cancel => 'İptal';

  @override
  String get appDetail_delete => 'Sil';

  @override
  String get appDetail_exporting => 'Sıralamalar dışa aktarılıyor...';

  @override
  String appDetail_savedFile(String filename) {
    return 'Kaydedildi: $filename';
  }

  @override
  String get appDetail_showInFinder => 'Finder\'da Göster';

  @override
  String appDetail_exportFailed(String error) {
    return 'Dışa aktarma başarısız: $error';
  }

  @override
  String appDetail_importedKeywords(int imported, int skipped) {
    return '$imported anahtar kelime içe aktarıldı ($skipped atlandı)';
  }

  @override
  String get appDetail_favorite => 'Favori';

  @override
  String get appDetail_ratings => 'Puanlar';

  @override
  String get appDetail_insights => 'İçgörüler';

  @override
  String get appDetail_import => 'İçe Aktar';

  @override
  String get appDetail_export => 'Dışa Aktar';

  @override
  String appDetail_reviewsCount(int count) {
    return '$count yorum';
  }

  @override
  String get appDetail_keywords => 'anahtar kelimeler';

  @override
  String get appDetail_addKeyword => 'Anahtar kelime ekle';

  @override
  String get appDetail_keywordHint => 'örn. fitness takipçisi';

  @override
  String get appDetail_trackedKeywords => 'Takip Edilen Anahtar Kelimeler';

  @override
  String appDetail_selectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get appDetail_allKeywords => 'Tüm Anahtar Kelimeler';

  @override
  String get appDetail_hasTags => 'Etiketli';

  @override
  String get appDetail_hasNotes => 'Notlu';

  @override
  String get appDetail_position => 'Sıralama';

  @override
  String get appDetail_select => 'Seç';

  @override
  String get appDetail_suggestions => 'Öneriler';

  @override
  String get appDetail_deleteKeywordsTitle => 'Anahtar Kelimeleri Sil';

  @override
  String appDetail_deleteKeywordsConfirm(int count) {
    return '$count anahtar kelimeyi silmek istediğinizden emin misiniz?';
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
      'Anahtar kelimeler başarıyla eklendi';

  @override
  String get appDetail_noTagsAvailable =>
      'Etiket mevcut değil. Önce etiket oluşturun.';

  @override
  String get appDetail_tagged => 'Etiketli';

  @override
  String get appDetail_withNotes => 'Notlu';

  @override
  String get appDetail_nameAZ => 'İsim A-Z';

  @override
  String get appDetail_nameZA => 'İsim Z-A';

  @override
  String get appDetail_bestPosition => 'En İyi Sıralama';

  @override
  String get appDetail_recentlyTracked => 'Son Takip Edilen';

  @override
  String get keywordSuggestions_title => 'Anahtar Kelime Önerileri';

  @override
  String keywordSuggestions_appInCountry(String appName, String country) {
    return '$country için $appName';
  }

  @override
  String get keywordSuggestions_refresh => 'Önerileri yenile';

  @override
  String get keywordSuggestions_search => 'Önerilerde ara...';

  @override
  String get keywordSuggestions_selectAll => 'Tümünü Seç';

  @override
  String get keywordSuggestions_clear => 'Temizle';

  @override
  String get keywordSuggestions_analyzing =>
      'Uygulama meta verileri analiz ediliyor...';

  @override
  String get keywordSuggestions_mayTakeFewSeconds =>
      'Bu birkaç saniye sürebilir';

  @override
  String get keywordSuggestions_noSuggestions => 'Öneri mevcut değil';

  @override
  String get keywordSuggestions_noMatchingSuggestions => 'Eşleşen öneri yok';

  @override
  String get keywordSuggestions_headerKeyword => 'ANAHTAR KELİME';

  @override
  String get keywordSuggestions_headerDifficulty => 'ZORLUK';

  @override
  String get keywordSuggestions_headerApps => 'UYGULAMALAR';

  @override
  String keywordSuggestions_rankedAt(int position) {
    return '#$position. sırada';
  }

  @override
  String keywordSuggestions_keywordsSelected(int count) {
    return '$count anahtar kelime seçildi';
  }

  @override
  String keywordSuggestions_addKeywords(int count) {
    return '$count Anahtar Kelime Ekle';
  }

  @override
  String keywordSuggestions_errorAdding(String error) {
    return 'Anahtar kelime eklenirken hata oluştu: $error';
  }

  @override
  String get sidebar_favorites => 'FAVORİLER';

  @override
  String get sidebar_tooManyFavorites =>
      '5 veya daha az favori tutmayı düşünün';

  @override
  String get sidebar_iphone => 'iPHONE';

  @override
  String get sidebar_android => 'ANDROID';

  @override
  String get keywordSearch_title => 'Anahtar Kelime Araştırması';

  @override
  String get keywordSearch_searchPlaceholder => 'Anahtar kelime ara...';

  @override
  String get keywordSearch_searchTitle => 'Anahtar kelime ara';

  @override
  String get keywordSearch_searchSubtitle =>
      'Hangi uygulamaların anahtar kelimeler için sıralandığını keşfedin';

  @override
  String keywordSearch_appsRanked(int count) {
    return '$count uygulama sıralandı';
  }

  @override
  String get keywordSearch_popularity => 'Popülerlik';

  @override
  String keywordSearch_results(int count) {
    return '$count sonuç';
  }

  @override
  String get keywordSearch_headerRank => 'SIRALAMA';

  @override
  String get keywordSearch_headerApp => 'UYGULAMA';

  @override
  String get keywordSearch_headerRating => 'PUAN';

  @override
  String get keywordSearch_headerTrack => 'TAKİP';

  @override
  String get keywordSearch_trackApp => 'Bu uygulamayı takip et';

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
    return '$appName için yorumlar';
  }

  @override
  String get reviews_loading => 'Yorumlar yükleniyor...';

  @override
  String get reviews_noReviews => 'Yorum yok';

  @override
  String reviews_noReviewsFor(String countryName) {
    return '$countryName için yorum bulunamadı';
  }

  @override
  String reviews_showingRecent(int count) {
    return 'App Store\'dan en son $count yorum gösteriliyor.';
  }

  @override
  String get reviews_today => 'Bugün';

  @override
  String get reviews_yesterday => 'Dün';

  @override
  String reviews_daysAgo(int count) {
    return '$count gün önce';
  }

  @override
  String reviews_weeksAgo(int count) {
    return '$count hafta önce';
  }

  @override
  String reviews_monthsAgo(int count) {
    return '$count ay önce';
  }

  @override
  String get ratings_byCountry => 'Ülkeye Göre Puanlar';

  @override
  String get ratings_noRatingsAvailable => 'Puan mevcut değil';

  @override
  String get ratings_noRatingsYet => 'Bu uygulamanın henüz puanı yok';

  @override
  String get ratings_totalRatings => 'Toplam Puanlar';

  @override
  String get ratings_averageRating => 'Ortalama Puan';

  @override
  String ratings_countriesCount(int count) {
    return '$count ülke';
  }

  @override
  String ratings_updated(String date) {
    return 'Güncellendi: $date';
  }

  @override
  String get ratings_headerCountry => 'ÜLKE';

  @override
  String get ratings_headerRatings => 'PUANLAR';

  @override
  String get ratings_headerAverage => 'ORTALAMA';

  @override
  String time_minutesAgo(int count) {
    return '${count}dk önce';
  }

  @override
  String time_hoursAgo(int count) {
    return '${count}sa önce';
  }

  @override
  String time_daysAgo(int count) {
    return '${count}g önce';
  }

  @override
  String get appDetail_noKeywordsTracked => 'Takip edilen anahtar kelime yok';

  @override
  String get appDetail_addKeywordHint =>
      'Takibe başlamak için yukarıya bir anahtar kelime ekleyin';

  @override
  String get appDetail_noKeywordsMatchFilter =>
      'Filtreyle eşleşen anahtar kelime yok';

  @override
  String get appDetail_tryChangingFilter =>
      'Filtre kriterlerini değiştirmeyi deneyin';

  @override
  String get appDetail_addTag => 'Etiket ekle';

  @override
  String get appDetail_addNote => 'Not ekle';

  @override
  String get appDetail_positionHistory => 'Sıralama Gecmisi';

  @override
  String get appDetail_store => 'STORE';

  @override
  String get nav_overview => 'GENEL BAKIŞ';

  @override
  String get nav_dashboard => 'Kontrol Paneli';

  @override
  String get nav_myApps => 'Uygulamalarım';

  @override
  String get nav_research => 'ARAŞTIRMA';

  @override
  String get nav_keywords => 'Anahtar Kelimeler';

  @override
  String get nav_discover => 'Keşfet';

  @override
  String get nav_engagement => 'ENGAGEMENT';

  @override
  String get nav_reviewsInbox => 'Reviews Inbox';

  @override
  String get nav_notifications => 'Bildirim';

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
  String get common_save => 'Kaydet';

  @override
  String get appDetail_manageTags => 'Etiketleri Yönet';

  @override
  String get appDetail_newTagHint => 'Yeni etiket adı...';

  @override
  String get appDetail_availableTags => 'Mevcut Etiketler';

  @override
  String get appDetail_noTagsYet =>
      'Henüz etiket yok. Yukarıda bir tane oluşturun.';

  @override
  String get appDetail_addTagsTitle => 'Etiket Ekle';

  @override
  String get appDetail_selectTagsDescription =>
      'Seçili anahtar kelimelere eklenecek etiketleri seçin:';

  @override
  String appDetail_addTagsCount(int count) {
    return '$count Etiket Ekle';
  }

  @override
  String appDetail_importFailed(String error) {
    return 'İçe aktarma başarısız: $error';
  }

  @override
  String get appDetail_importKeywordsTitle => 'Anahtar Kelimeleri İçe Aktar';

  @override
  String get appDetail_pasteKeywordsHint =>
      'Anahtar kelimeleri aşağıya yapıştırın, her satıra bir tane:';

  @override
  String get appDetail_keywordPlaceholder =>
      'anahtar kelime bir\nanahtar kelime iki\nanahtar kelime üç';

  @override
  String get appDetail_storefront => 'Mağaza:';

  @override
  String appDetail_keywordsCount(int count) {
    return '$count anahtar kelime';
  }

  @override
  String appDetail_importKeywordsCount(int count) {
    return '$count Anahtar Kelime İçe Aktar';
  }

  @override
  String get appDetail_period7d => '7g';

  @override
  String get appDetail_period30d => '30g';

  @override
  String get appDetail_period90d => '90g';

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
  String get notifications_title => 'Bildirimler';

  @override
  String get notifications_markAllRead => 'Tumunu okundu olarak isaretle';

  @override
  String get notifications_empty => 'Henuz bildirim yok';

  @override
  String get alerts_title => 'Uyari Kurallari';

  @override
  String get alerts_templatesTitle => 'Hizli Sablonlar';

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
  String get settings_notifications => 'BILDIRIMLER';

  @override
  String get settings_manageAlerts => 'Uyari kurallarini yonet';

  @override
  String get settings_manageAlertsDesc =>
      'Hangi uyarilari alacaginizi yapilandirin';

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
  String get analytics_title => 'Analitik';

  @override
  String get analytics_downloads => 'İndirmeler';

  @override
  String get analytics_revenue => 'Gelir';

  @override
  String get analytics_proceeds => 'Kazanç';

  @override
  String get analytics_subscribers => 'Aboneler';

  @override
  String get analytics_downloadsOverTime => 'Zaman İçinde İndirmeler';

  @override
  String get analytics_revenueOverTime => 'Zaman İçinde Gelir';

  @override
  String get analytics_byCountry => 'Ülkeye Göre';

  @override
  String get analytics_noData => 'Veri yok';

  @override
  String get analytics_noDataTitle => 'Analitik Verisi Yok';

  @override
  String get analytics_noDataDescription =>
      'Gerçek satış ve indirme verilerini görmek için App Store Connect veya Google Play hesabınızı bağlayın.';

  @override
  String analytics_dataDelay(String date) {
    return '$date itibariyle veriler. Apple verileri 24-48 saat gecikmelidir.';
  }

  @override
  String get analytics_export => 'CSV Dışa Aktar';

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
}
