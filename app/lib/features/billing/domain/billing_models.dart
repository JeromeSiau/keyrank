class PlanLimits {
  final int apps;
  final int keywordsPerApp;
  final int competitorsPerApp;
  final int historyDays;
  final bool exports;
  final bool apiAccess;
  final bool prioritySupport;
  final bool aiInsights;
  final int aiChatMessagesPerDay;

  const PlanLimits({
    required this.apps,
    required this.keywordsPerApp,
    required this.competitorsPerApp,
    required this.historyDays,
    required this.exports,
    required this.apiAccess,
    required this.prioritySupport,
    required this.aiInsights,
    required this.aiChatMessagesPerDay,
  });

  factory PlanLimits.fromJson(Map<String, dynamic> json) {
    return PlanLimits(
      apps: json['apps'] as int? ?? 0,
      keywordsPerApp: json['keywords_per_app'] as int? ?? 0,
      competitorsPerApp: json['competitors_per_app'] as int? ?? 0,
      historyDays: json['history_days'] as int? ?? 0,
      exports: json['exports'] as bool? ?? false,
      apiAccess: json['api_access'] as bool? ?? false,
      prioritySupport: json['priority_support'] as bool? ?? false,
      aiInsights: json['ai_insights'] as bool? ?? false,
      aiChatMessagesPerDay: json['ai_chat_messages_per_day'] as int? ?? 0,
    );
  }

  bool get hasUnlimitedApps => apps == -1;
  bool get hasUnlimitedKeywords => keywordsPerApp == -1;
  bool get hasUnlimitedHistory => historyDays == -1;
  bool get hasUnlimitedChat => aiChatMessagesPerDay == -1;
}

class SubscriptionPlan {
  final String key;
  final String name;
  final PlanLimits limits;
  final bool hasMonthly;
  final bool hasYearly;

  const SubscriptionPlan({
    required this.key,
    required this.name,
    required this.limits,
    required this.hasMonthly,
    required this.hasYearly,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      key: json['key'] as String,
      name: json['name'] as String,
      limits: PlanLimits.fromJson(json['limits'] as Map<String, dynamic>),
      hasMonthly: json['has_monthly'] as bool? ?? false,
      hasYearly: json['has_yearly'] as bool? ?? false,
    );
  }

  bool get isFree => key == 'free';
  bool get isPro => key == 'pro';
  bool get isBusiness => key == 'business';
}

class SubscriptionStatus {
  final String plan;
  final String planName;
  final PlanLimits limits;
  final bool isSubscribed;
  final bool onTrial;
  final bool onGracePeriod;
  final DateTime? endsAt;
  final DateTime? trialEndsAt;

  const SubscriptionStatus({
    required this.plan,
    required this.planName,
    required this.limits,
    required this.isSubscribed,
    required this.onTrial,
    required this.onGracePeriod,
    this.endsAt,
    this.trialEndsAt,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      plan: json['plan'] as String,
      planName: json['plan_name'] as String,
      limits: PlanLimits.fromJson(json['limits'] as Map<String, dynamic>),
      isSubscribed: json['is_subscribed'] as bool? ?? false,
      onTrial: json['on_trial'] as bool? ?? false,
      onGracePeriod: json['on_grace_period'] as bool? ?? false,
      endsAt: json['ends_at'] != null ? DateTime.parse(json['ends_at'] as String) : null,
      trialEndsAt: json['trial_ends_at'] != null ? DateTime.parse(json['trial_ends_at'] as String) : null,
    );
  }

  bool get isFree => plan == 'free';
  bool get isPro => plan == 'pro';
  bool get isBusiness => plan == 'business';
  bool get isPaid => isSubscribed && !isFree;
  bool get canResume => onGracePeriod;
  bool get isCanceled => endsAt != null && !onGracePeriod;
}

class CheckoutResponse {
  final String checkoutUrl;

  const CheckoutResponse({required this.checkoutUrl});

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      checkoutUrl: json['checkout_url'] as String,
    );
  }
}

class PortalResponse {
  final String portalUrl;

  const PortalResponse({required this.portalUrl});

  factory PortalResponse.fromJson(Map<String, dynamic> json) {
    return PortalResponse(
      portalUrl: json['portal_url'] as String,
    );
  }
}
