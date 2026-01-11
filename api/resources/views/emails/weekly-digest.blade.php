<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weekly ASO Digest</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #f5f5f7;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
        }
        .header {
            background: linear-gradient(135deg, #007AFF 0%, #5856D6 100%);
            color: white;
            padding: 32px 24px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }
        .header p {
            margin: 8px 0 0;
            opacity: 0.9;
            font-size: 14px;
        }
        .content {
            padding: 24px;
        }
        .section {
            margin-bottom: 32px;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #1a1a1a;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }
        .stat-card {
            background: #f5f5f7;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
        }
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #007AFF;
        }
        .stat-label {
            font-size: 12px;
            color: #8e8e93;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .insight-card {
            background: #f5f5f7;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 12px;
        }
        .insight-header {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }
        .insight-badge {
            font-size: 11px;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 4px;
            text-transform: uppercase;
        }
        .badge-high { background: #FF3B30; color: white; }
        .badge-medium { background: #FF9500; color: white; }
        .badge-low { background: #34C759; color: white; }
        .insight-title {
            font-weight: 600;
            margin-left: 8px;
        }
        .insight-description {
            font-size: 14px;
            color: #3a3a3c;
        }
        .insight-app {
            font-size: 12px;
            color: #8e8e93;
            margin-top: 8px;
        }
        .app-card {
            display: flex;
            align-items: center;
            background: #f5f5f7;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 12px;
        }
        .app-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            margin-right: 16px;
        }
        .app-info {
            flex: 1;
        }
        .app-name {
            font-weight: 600;
            margin-bottom: 4px;
        }
        .app-stats {
            font-size: 13px;
            color: #8e8e93;
        }
        .app-rating {
            text-align: right;
        }
        .rating-value {
            font-size: 20px;
            font-weight: 600;
        }
        .rating-change {
            font-size: 12px;
        }
        .positive { color: #34C759; }
        .negative { color: #FF3B30; }
        .neutral { color: #8e8e93; }
        .cta-button {
            display: inline-block;
            background: #007AFF;
            color: white;
            text-decoration: none;
            padding: 14px 28px;
            border-radius: 12px;
            font-weight: 600;
            margin-top: 16px;
        }
        .footer {
            text-align: center;
            padding: 24px;
            background: #f5f5f7;
            font-size: 12px;
            color: #8e8e93;
        }
        .footer a {
            color: #007AFF;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Your Weekly ASO Digest</h1>
            <p>{{ $digest['period']['start'] }} - {{ $digest['period']['end'] }}</p>
        </div>

        <div class="content">
            <!-- Stats Overview -->
            <div class="section">
                <h2 class="section-title">This Week at a Glance</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value">{{ $digest['stats']['total_reviews'] }}</div>
                        <div class="stat-label">New Reviews</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">{{ $digest['stats']['total_apps'] }}</div>
                        <div class="stat-label">Apps Tracked</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value {{ $digest['stats']['keywords_improved'] > 0 ? 'positive' : '' }}">
                            +{{ $digest['stats']['keywords_improved'] }}
                        </div>
                        <div class="stat-label">Keywords Improved</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value {{ $digest['stats']['keywords_declined'] > 0 ? 'negative' : '' }}">
                            -{{ $digest['stats']['keywords_declined'] }}
                        </div>
                        <div class="stat-label">Keywords Declined</div>
                    </div>
                </div>
            </div>

            <!-- Top Insights -->
            @if(count($digest['insights']) > 0)
            <div class="section">
                <h2 class="section-title">Top Insights</h2>
                @foreach($digest['insights'] as $insight)
                <div class="insight-card">
                    <div class="insight-header">
                        <span class="insight-badge badge-{{ $insight['priority'] }}">
                            {{ $insight['priority'] }}
                        </span>
                        <span class="insight-title">{{ $insight['title'] }}</span>
                    </div>
                    <div class="insight-description">{{ $insight['description'] }}</div>
                    @if($insight['app_name'])
                    <div class="insight-app">{{ $insight['app_name'] }}</div>
                    @endif
                </div>
                @endforeach
            </div>
            @endif

            <!-- App Summaries -->
            @if(count($digest['app_summaries']) > 0)
            <div class="section">
                <h2 class="section-title">Your Apps</h2>
                @foreach($digest['app_summaries'] as $app)
                <div class="app-card">
                    @if($app['icon_url'])
                    <img src="{{ $app['icon_url'] }}" alt="{{ $app['name'] }}" class="app-icon">
                    @else
                    <div class="app-icon" style="background: #e5e5ea;"></div>
                    @endif
                    <div class="app-info">
                        <div class="app-name">{{ $app['name'] }}</div>
                        <div class="app-stats">
                            {{ $app['reviews_count'] }} reviews this week
                            @if($app['unanswered_count'] > 0)
                            &bull; <span class="negative">{{ $app['unanswered_count'] }} need reply</span>
                            @endif
                        </div>
                    </div>
                    <div class="app-rating">
                        @if($app['current_rating'])
                        <div class="rating-value">{{ number_format($app['current_rating'], 1) }}</div>
                        @if($app['rating_change'] !== null)
                        <div class="rating-change {{ $app['rating_change'] > 0 ? 'positive' : ($app['rating_change'] < 0 ? 'negative' : 'neutral') }}">
                            {{ $app['rating_change'] > 0 ? '+' : '' }}{{ number_format($app['rating_change'], 2) }}
                        </div>
                        @endif
                        @endif
                    </div>
                </div>
                @endforeach
            </div>
            @endif

            <!-- CTA -->
            <div style="text-align: center; margin-top: 32px;">
                <a href="{{ config('app.url') }}/dashboard" class="cta-button">
                    View Full Dashboard
                </a>
            </div>
        </div>

        <div class="footer">
            <p>
                You're receiving this because you have apps tracked in Keyrank.<br>
                <a href="{{ config('app.url') }}/settings/notifications">Manage email preferences</a>
            </p>
            <p style="margin-top: 16px;">
                &copy; {{ date('Y') }} Keyrank. All rights reserved.
            </p>
        </div>
    </div>
</body>
</html>
