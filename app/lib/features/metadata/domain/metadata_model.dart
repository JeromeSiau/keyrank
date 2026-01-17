// Metadata models for app store metadata editing

class AppMetadataResponse {
  final int appId;
  final String platform;
  final bool isOwner;
  final bool canEdit;
  final List<MetadataLocale> locales;
  final MetadataLimits limits;

  AppMetadataResponse({
    required this.appId,
    required this.platform,
    required this.isOwner,
    required this.canEdit,
    required this.locales,
    required this.limits,
  });

  factory AppMetadataResponse.fromJson(Map<String, dynamic> json) {
    return AppMetadataResponse(
      appId: json['app_id'] as int,
      platform: json['platform'] as String,
      isOwner: json['is_owner'] as bool? ?? false,
      canEdit: json['can_edit'] as bool? ?? false,
      locales: (json['locales'] as List<dynamic>?)
              ?.map((e) => MetadataLocale.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      limits: MetadataLimits.fromJson(
          json['limits'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class MetadataLocale {
  final String locale;
  final MetadataContent? live;
  final MetadataDraft? draft;
  final bool isComplete;
  final int completionPercentage;
  final MetadataLimits? limits;
  final AscIds? ascIds;

  MetadataLocale({
    required this.locale,
    this.live,
    this.draft,
    this.isComplete = false,
    this.completionPercentage = 0,
    this.limits,
    this.ascIds,
  });

  factory MetadataLocale.fromJson(Map<String, dynamic> json) {
    return MetadataLocale(
      locale: json['locale'] as String,
      live: json['live'] != null
          ? MetadataContent.fromJson(json['live'] as Map<String, dynamic>)
          : null,
      draft: json['draft'] != null
          ? MetadataDraft.fromJson(json['draft'] as Map<String, dynamic>)
          : null,
      isComplete: json['is_complete'] as bool? ?? false,
      completionPercentage: json['completion_percentage'] as int? ?? 0,
      limits: json['limits'] != null
          ? MetadataLimits.fromJson(json['limits'] as Map<String, dynamic>)
          : null,
      ascIds: json['asc_ids'] != null
          ? AscIds.fromJson(json['asc_ids'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Get the effective content (draft if exists, otherwise live)
  MetadataContent? get effective {
    if (draft != null) {
      return MetadataContent(
        title: draft!.title ?? live?.title,
        subtitle: draft!.subtitle ?? live?.subtitle,
        keywords: draft!.keywords ?? live?.keywords,
        description: draft!.description ?? live?.description,
        promotionalText: draft!.promotionalText ?? live?.promotionalText,
        whatsNew: draft!.whatsNew ?? live?.whatsNew,
      );
    }
    return live;
  }

  bool get hasDraft => draft != null;
  bool get hasChanges => draft?.changedFields.isNotEmpty ?? false;
}

class MetadataContent {
  final String? title;
  final String? subtitle;
  final String? keywords;
  final String? description;
  final String? promotionalText;
  final String? whatsNew;
  final DateTime? fetchedAt;

  MetadataContent({
    this.title,
    this.subtitle,
    this.keywords,
    this.description,
    this.promotionalText,
    this.whatsNew,
    this.fetchedAt,
  });

  factory MetadataContent.fromJson(Map<String, dynamic> json) {
    return MetadataContent(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      keywords: json['keywords'] as String?,
      description: json['description'] as String?,
      promotionalText: json['promotional_text'] as String?,
      whatsNew: json['whats_new'] as String?,
      fetchedAt: json['fetched_at'] != null
          ? DateTime.parse(json['fetched_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (subtitle != null) 'subtitle': subtitle,
        if (keywords != null) 'keywords': keywords,
        if (description != null) 'description': description,
        if (promotionalText != null) 'promotional_text': promotionalText,
        if (whatsNew != null) 'whats_new': whatsNew,
      };

  MetadataContent copyWith({
    String? title,
    String? subtitle,
    String? keywords,
    String? description,
    String? promotionalText,
    String? whatsNew,
  }) {
    return MetadataContent(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      keywords: keywords ?? this.keywords,
      description: description ?? this.description,
      promotionalText: promotionalText ?? this.promotionalText,
      whatsNew: whatsNew ?? this.whatsNew,
      fetchedAt: fetchedAt,
    );
  }
}

class MetadataDraft {
  final int id;
  final String? title;
  final String? subtitle;
  final String? keywords;
  final String? description;
  final String? promotionalText;
  final String? whatsNew;
  final String status;
  final List<String> changedFields;
  final DateTime? updatedAt;

  MetadataDraft({
    required this.id,
    this.title,
    this.subtitle,
    this.keywords,
    this.description,
    this.promotionalText,
    this.whatsNew,
    required this.status,
    this.changedFields = const [],
    this.updatedAt,
  });

  factory MetadataDraft.fromJson(Map<String, dynamic> json) {
    return MetadataDraft(
      id: json['id'] as int,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      keywords: json['keywords'] as String?,
      description: json['description'] as String?,
      promotionalText: json['promotional_text'] as String?,
      whatsNew: json['whats_new'] as String?,
      status: json['status'] as String? ?? 'draft',
      changedFields: (json['changed_fields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  bool get isDraft => status == 'draft';
  bool get isPendingReview => status == 'pending_review';
  bool get isPublished => status == 'published';
}

class MetadataLimits {
  final int title;
  final int subtitle;
  final int keywords;
  final int description;
  final int promotionalText;
  final int whatsNew;

  MetadataLimits({
    this.title = 30,
    this.subtitle = 30,
    this.keywords = 100,
    this.description = 4000,
    this.promotionalText = 170,
    this.whatsNew = 4000,
  });

  factory MetadataLimits.fromJson(Map<String, dynamic> json) {
    return MetadataLimits(
      title: json['title'] as int? ?? 30,
      subtitle: json['subtitle'] as int? ?? 30,
      keywords: json['keywords'] as int? ?? 100,
      description: json['description'] as int? ?? 4000,
      promotionalText: json['promotional_text'] as int? ?? 170,
      whatsNew: json['whats_new'] as int? ?? 4000,
    );
  }

  static MetadataLimits forPlatform(String platform) {
    if (platform == 'android') {
      return MetadataLimits(
        title: 30, // Google Play title limit
        subtitle: 80, // Short description
        keywords: 0, // Android doesn't have keywords field
        description: 4000,
        promotionalText: 0, // Android doesn't have promotional text
        whatsNew: 500, // Release notes limit
      );
    }
    return MetadataLimits(); // iOS defaults
  }

  /// Check if a field is applicable for the given limits
  bool hasField(String field) {
    switch (field) {
      case 'keywords':
        return keywords > 0;
      case 'promotionalText':
        return promotionalText > 0;
      default:
        return true;
    }
  }
}

class AscIds {
  final String? appInfoLocalizationId;
  final String? versionLocalizationId;

  AscIds({
    this.appInfoLocalizationId,
    this.versionLocalizationId,
  });

  factory AscIds.fromJson(Map<String, dynamic> json) {
    return AscIds(
      appInfoLocalizationId: json['app_info_localization_id'] as String?,
      versionLocalizationId: json['version_localization_id'] as String?,
    );
  }
}

class KeywordAnalysis {
  final String keyword;
  final bool inTitle;
  final bool inSubtitle;
  final bool inKeywords;
  final bool inDescription;
  final bool present;
  final int? popularity;
  final int? position;

  KeywordAnalysis({
    required this.keyword,
    this.inTitle = false,
    this.inSubtitle = false,
    this.inKeywords = false,
    this.inDescription = false,
    this.present = false,
    this.popularity,
    this.position,
  });

  factory KeywordAnalysis.fromJson(Map<String, dynamic> json) {
    return KeywordAnalysis(
      keyword: json['keyword'] as String,
      inTitle: json['in_title'] as bool? ?? false,
      inSubtitle: json['in_subtitle'] as bool? ?? false,
      inKeywords: json['in_keywords'] as bool? ?? false,
      inDescription: json['in_description'] as bool? ?? false,
      present: json['present'] as bool? ?? false,
      popularity: json['popularity'] as int?,
      position: json['position'] as int?,
    );
  }

  int get presenceCount {
    int count = 0;
    if (inTitle) count++;
    if (inSubtitle) count++;
    if (inKeywords) count++;
    if (inDescription) count++;
    return count;
  }
}

class MetadataLocaleDetail {
  final String locale;
  final MetadataContent? live;
  final MetadataDraft? draft;
  final List<KeywordAnalysis> keywordAnalysis;
  final MetadataLimits limits;
  final AscIds? ascIds;

  MetadataLocaleDetail({
    required this.locale,
    this.live,
    this.draft,
    this.keywordAnalysis = const [],
    required this.limits,
    this.ascIds,
  });

  factory MetadataLocaleDetail.fromJson(Map<String, dynamic> json) {
    return MetadataLocaleDetail(
      locale: json['locale'] as String,
      live: json['live'] != null
          ? MetadataContent.fromJson(json['live'] as Map<String, dynamic>)
          : null,
      draft: json['draft'] != null
          ? MetadataDraft.fromJson(json['draft'] as Map<String, dynamic>)
          : null,
      keywordAnalysis: (json['keyword_analysis'] as List<dynamic>?)
              ?.map((e) => KeywordAnalysis.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      limits:
          MetadataLimits.fromJson(json['limits'] as Map<String, dynamic>? ?? {}),
      ascIds: json['asc_ids'] != null
          ? AscIds.fromJson(json['asc_ids'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Get effective content (draft values override live)
  MetadataContent? get effective {
    if (draft != null) {
      return MetadataContent(
        title: draft!.title ?? live?.title,
        subtitle: draft!.subtitle ?? live?.subtitle,
        keywords: draft!.keywords ?? live?.keywords,
        description: draft!.description ?? live?.description,
        promotionalText: draft!.promotionalText ?? live?.promotionalText,
        whatsNew: draft!.whatsNew ?? live?.whatsNew,
      );
    }
    return live;
  }
}

class MetadataHistoryEntry {
  final int id;
  final String locale;
  final String field;
  final String? oldValue;
  final String? newValue;
  final DateTime changedAt;

  MetadataHistoryEntry({
    required this.id,
    required this.locale,
    required this.field,
    this.oldValue,
    this.newValue,
    required this.changedAt,
  });

  factory MetadataHistoryEntry.fromJson(Map<String, dynamic> json) {
    return MetadataHistoryEntry(
      id: json['id'] as int,
      locale: json['locale'] as String? ?? 'unknown',
      field: json['field'] as String,
      oldValue: json['old_value'] as String?,
      newValue: json['new_value'] as String?,
      changedAt: DateTime.parse(json['changed_at'] as String),
    );
  }
}
