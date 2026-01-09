<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Keyrank - Track Your App Store Rankings</title>
    <meta name="description" content="The complete ASO tool to track your keyword positions on iOS and Android across 25+ countries. AI-powered suggestions, review analysis, and automated insights.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --bg: #fafafa;
            --surface: #ffffff;
            --text: #0f172a;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            --border: #e2e8f0;
            --indigo-dark: #4f46e5;
            --indigo: #6366f1;
            --indigo-light: #818cf8;
            --indigo-lighter: #a5b4fc;
            --accent: #6366f1;
            --accent-dark: #4f46e5;
            --green: #22c55e;
            --red: #ef4444;
            --orange: #f97316;
            --purple: #a855f7;
        }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
        }

        a { color: inherit; text-decoration: none; }

        .container {
            max-width: 1140px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            width: 32px;
            height: 32px;
            flex-shrink: 0;
        }

        .logo-text {
            font-family: 'Sora', sans-serif;
            font-size: 20px;
            font-weight: 700;
            color: var(--text);
            letter-spacing: -0.5px;
        }

        .nav {
            padding: 16px 0;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-inner {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-menu {
            display: flex;
            align-items: center;
            gap: 32px;
        }

        .nav-link {
            font-size: 14px;
            font-weight: 500;
            color: var(--text-secondary);
            transition: color 0.15s;
        }

        .nav-link:hover { color: var(--text); }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 8px 16px;
            font-family: inherit;
            font-size: 14px;
            font-weight: 500;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            transition: all 0.15s;
        }

        .btn-ghost {
            background: transparent;
            color: var(--text-secondary);
        }

        .btn-ghost:hover { color: var(--text); }

        .btn-primary {
            background: var(--accent);
            color: white;
        }

        .btn-primary:hover { background: var(--accent-dark); }

        .btn-secondary {
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--text);
        }

        .btn-secondary:hover { background: var(--bg); }

        .btn-lg {
            padding: 12px 24px;
            font-size: 15px;
        }

        .hero {
            padding: 80px 0 60px;
        }

        .hero-inner {
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 60px;
            align-items: center;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            background: #eef2ff;
            border: 1px solid #c7d2fe;
            border-radius: 100px;
            font-size: 13px;
            font-weight: 500;
            color: var(--indigo-dark);
            margin-bottom: 24px;
        }

        .badge-new {
            background: var(--accent);
            color: white;
            padding: 2px 8px;
            border-radius: 100px;
            font-size: 11px;
            font-weight: 600;
        }

        .hero-title {
            font-size: 48px;
            font-weight: 800;
            line-height: 1.1;
            letter-spacing: -0.02em;
            margin-bottom: 20px;
        }

        .hero-title span {
            background: linear-gradient(135deg, var(--indigo-dark), var(--indigo-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-desc {
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 32px;
            line-height: 1.7;
        }

        .hero-actions {
            display: flex;
            gap: 12px;
            margin-bottom: 40px;
        }

        .hero-metrics {
            display: flex;
            gap: 40px;
        }

        .metric {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .metric-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .metric-icon.indigo { background: #eef2ff; color: var(--indigo); }
        .metric-icon.green { background: #f0fdf4; color: var(--green); }
        .metric-icon.orange { background: #fff7ed; color: var(--orange); }

        .metric-value {
            font-size: 24px;
            font-weight: 700;
        }

        .metric-label {
            font-size: 13px;
            color: var(--text-muted);
        }

        .hero-visual {
            position: relative;
        }

        .browser-frame {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.1);
        }

        .browser-bar {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 16px;
            background: #f8fafc;
            border-bottom: 1px solid var(--border);
        }

        .browser-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }

        .dot-red { background: #fca5a5; }
        .dot-yellow { background: #fcd34d; }
        .dot-green { background: #86efac; }

        .browser-url {
            flex: 1;
            margin-left: 12px;
            padding: 6px 12px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 12px;
            color: var(--text-muted);
        }

        .browser-content {
            padding: 20px;
        }

        .dash-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .dash-title {
            font-size: 16px;
            font-weight: 600;
        }

        .dash-filters {
            display: flex;
            gap: 8px;
        }

        .filter-btn {
            padding: 6px 12px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .filter-btn.active {
            background: var(--accent);
            border-color: var(--accent);
            color: white;
        }

        .dash-cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-bottom: 20px;
        }

        .dash-card {
            padding: 16px;
            background: var(--bg);
            border-radius: 8px;
        }

        .dash-card-label {
            font-size: 11px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            margin-bottom: 8px;
        }

        .dash-card-value {
            font-size: 24px;
            font-weight: 700;
        }

        .dash-card-value.green { color: var(--green); }
        .dash-card-value.accent { color: var(--accent); }

        .dash-table {
            background: var(--bg);
            border-radius: 8px;
            overflow: hidden;
        }

        .table-row {
            display: grid;
            grid-template-columns: auto 1fr auto auto;
            gap: 16px;
            padding: 12px 16px;
            align-items: center;
            border-bottom: 1px solid var(--border);
        }

        .table-row:last-child { border-bottom: none; }

        .table-row.header {
            background: #f1f5f9;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
        }

        .app-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .app-avatar {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 700;
            color: white;
        }

        .app-avatar.g1 { background: linear-gradient(135deg, #6366f1, #8b5cf6); }
        .app-avatar.g2 { background: linear-gradient(135deg, #10b981, #34d399); }

        .app-info-name {
            font-size: 13px;
            font-weight: 500;
        }

        .app-info-dev {
            font-size: 11px;
            color: var(--text-muted);
        }

        .rank-badge {
            padding: 4px 10px;
            background: #eef2ff;
            border-radius: 100px;
            font-size: 13px;
            font-weight: 600;
            color: var(--accent);
        }

        .change-badge {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            font-weight: 500;
            color: var(--green);
        }

        .features {
            padding: 80px 0;
            background: var(--surface);
        }

        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-label {
            display: inline-block;
            padding: 6px 14px;
            background: #eef2ff;
            border-radius: 100px;
            font-size: 12px;
            font-weight: 600;
            color: var(--accent);
            margin-bottom: 16px;
        }

        .section-title {
            font-size: 36px;
            font-weight: 800;
            letter-spacing: -0.02em;
            margin-bottom: 16px;
        }

        .section-desc {
            font-size: 18px;
            color: var(--text-secondary);
            max-width: 600px;
            margin: 0 auto;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .feature-card {
            padding: 32px;
            background: var(--bg);
            border-radius: 12px;
            transition: all 0.2s;
        }

        .feature-card:hover {
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.06);
            transform: translateY(-4px);
        }

        .feature-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .feature-icon.indigo { background: #e0e7ff; color: var(--indigo-dark); }
        .feature-icon.green { background: #dcfce7; color: var(--green); }
        .feature-icon.orange { background: #ffedd5; color: var(--orange); }
        .feature-icon.purple { background: #f3e8ff; color: var(--purple); }
        .feature-icon.red { background: #fee2e2; color: var(--red); }
        .feature-icon.blue { background: #dbeafe; color: #2563eb; }

        .feature-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .feature-desc {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.7;
            margin-bottom: 16px;
        }

        .feature-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .feature-tag {
            padding: 4px 10px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 100px;
            font-size: 11px;
            font-weight: 500;
            color: var(--text-muted);
        }

        .platforms {
            padding: 80px 0;
        }

        .platforms-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 80px;
            align-items: center;
        }

        .platforms-content h2 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 16px;
            letter-spacing: -0.02em;
        }

        .platforms-content p {
            font-size: 16px;
            color: var(--text-secondary);
            margin-bottom: 24px;
            line-height: 1.7;
        }

        .platform-list {
            list-style: none;
            margin-bottom: 24px;
        }

        .platform-list li {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid var(--border);
            font-size: 15px;
        }

        .platform-list .icon {
            width: 32px;
            height: 32px;
            background: var(--bg);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .country-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .country-tag {
            padding: 8px 14px;
            background: var(--bg);
            border-radius: 100px;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .platforms-visual {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 32px;
        }

        .platform-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .platform-stat {
            padding: 24px;
            background: var(--bg);
            border-radius: 12px;
            text-align: center;
        }

        .platform-stat-icon {
            margin-bottom: 12px;
        }

        .platform-stat-name {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .platform-stat-desc {
            font-size: 13px;
            color: var(--text-muted);
        }

        .how-it-works {
            padding: 80px 0;
            background: var(--surface);
        }

        .steps {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 32px;
            margin-top: 60px;
        }

        .step {
            text-align: center;
            position: relative;
        }

        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            top: 28px;
            right: -16px;
            width: 32px;
            height: 2px;
            background: var(--border);
        }

        .step-number {
            width: 56px;
            height: 56px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, var(--indigo-dark), var(--indigo-light));
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 700;
            color: white;
        }

        .step-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .step-desc {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.6;
        }

        .pricing {
            padding: 80px 0;
        }

        .pricing-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            max-width: 960px;
            margin: 0 auto;
        }

        .pricing-card {
            padding: 32px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            position: relative;
        }

        .pricing-card.featured {
            background: var(--text);
            color: white;
            border: none;
        }

        .pricing-card.featured .pricing-desc,
        .pricing-card.featured .pricing-period,
        .pricing-card.featured .pricing-features li {
            color: #94a3b8;
        }

        .pricing-card.featured .check {
            color: #4ade80;
        }

        .pricing-badge {
            position: absolute;
            top: -12px;
            left: 50%;
            transform: translateX(-50%);
            padding: 6px 16px;
            background: linear-gradient(135deg, var(--indigo-dark), var(--indigo-light));
            border-radius: 100px;
            font-size: 12px;
            font-weight: 600;
            color: white;
        }

        .pricing-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .pricing-desc {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 24px;
        }

        .pricing-price {
            font-size: 48px;
            font-weight: 800;
            line-height: 1;
            margin-bottom: 4px;
        }

        .pricing-price span {
            font-size: 18px;
            font-weight: 500;
        }

        .pricing-period {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 24px;
        }

        .pricing-features {
            list-style: none;
            margin-bottom: 24px;
        }

        .pricing-features li {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 0;
            font-size: 14px;
            color: var(--text-secondary);
        }

        .pricing-features .check { color: var(--green); }

        .pricing-card .btn { width: 100%; }

        .pricing-card.featured .btn-primary {
            background: white;
            color: var(--text);
        }

        .cta {
            padding: 80px 0;
            background: var(--surface);
        }

        .cta-box {
            background: linear-gradient(135deg, var(--indigo-dark), var(--indigo-light));
            border-radius: 24px;
            padding: 64px;
            text-align: center;
            color: white;
        }

        .cta h2 {
            font-size: 36px;
            font-weight: 800;
            margin-bottom: 16px;
            letter-spacing: -0.02em;
        }

        .cta p {
            font-size: 18px;
            opacity: 0.9;
            margin-bottom: 32px;
        }

        .cta .btn-primary {
            background: white;
            color: var(--indigo-dark);
        }

        .cta .btn-primary:hover {
            background: #f0f9ff;
        }

        .footer {
            padding: 24px 0;
            border-top: 1px solid var(--border);
        }

        .footer-inner {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .footer-links {
            display: flex;
            gap: 24px;
        }

        .footer-link {
            font-size: 13px;
            color: var(--text-muted);
            transition: color 0.15s;
        }

        .footer-link:hover { color: var(--text); }

        .footer-copy {
            font-size: 13px;
            color: var(--text-muted);
        }

        @media (max-width: 1024px) {
            .hero-inner { grid-template-columns: 1fr; }
            .hero-visual { display: none; }
            .hero { text-align: center; }
            .hero-actions { justify-content: center; }
            .hero-metrics { justify-content: center; }
            .features-grid { grid-template-columns: 1fr 1fr; }
            .platforms-grid { grid-template-columns: 1fr; }
            .steps { grid-template-columns: 1fr 1fr; }
            .step:not(:last-child)::after { display: none; }
            .pricing-grid { grid-template-columns: 1fr; max-width: 380px; }
        }

        @media (max-width: 768px) {
            .nav-menu { display: none; }
            .hero-title { font-size: 36px; }
            .features-grid { grid-template-columns: 1fr; }
            .hero-metrics { flex-direction: column; gap: 20px; }
            .steps { grid-template-columns: 1fr; }
            .footer-inner { flex-direction: column; gap: 16px; text-align: center; }
        }
    </style>
</head>
<body>
    <!-- NAV -->
    <nav class="nav">
        <div class="container">
            <div class="nav-inner">
                <a href="/" class="logo">
                    <svg class="logo-icon" viewBox="0 0 56 56" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="2" y="2" width="52" height="52" rx="14" fill="#18181b" stroke="#27272a" stroke-width="1"/>
                        <rect x="10" y="34" width="10" height="14" rx="2" fill="#4f46e5"/>
                        <rect x="23" y="26" width="10" height="22" rx="2" fill="#6366f1"/>
                        <rect x="36" y="16" width="10" height="32" rx="2" fill="#818cf8"/>
                        <path d="M46 8L46 14" stroke="#a5b4fc" stroke-width="2" stroke-linecap="round"/>
                        <path d="M43 11L46 8L49 11" stroke="#a5b4fc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <span class="logo-text">keyrank</span>
                </a>
                <div class="nav-menu">
                    <a href="#features" class="nav-link">Features</a>
                    <a href="#pricing" class="nav-link">Pricing</a>
                    <a href="#" class="nav-link">Documentation</a>
                    <a href="#" class="nav-link">Blog</a>
                </div>
                <div class="nav-actions">
                    @if (Route::has('login'))
                        @auth
                            <a href="{{ url('/dashboard') }}" class="btn btn-ghost">Dashboard</a>
                        @else
                            <a href="{{ route('login') }}" class="btn btn-ghost">Sign In</a>
                            @if (Route::has('register'))
                                <a href="{{ route('register') }}" class="btn btn-primary">Get Started</a>
                            @else
                                <button class="btn btn-primary">Get Started</button>
                            @endif
                        @endauth
                    @else
                        <button class="btn btn-ghost">Sign In</button>
                        <button class="btn btn-primary">Get Started</button>
                    @endif
                </div>
            </div>
        </div>
    </nav>

    <!-- HERO -->
    <section class="hero">
        <div class="container">
            <div class="hero-inner">
                <div class="hero-content">
                    <div class="hero-badge">
                        <span class="badge-new">New</span>
                        AI suggestions & review analysis
                    </div>
                    <h1 class="hero-title">
                        Boost your <span>rankings</span> on the App Store
                    </h1>
                    <p class="hero-desc">
                        The complete ASO tool to track your keyword positions, discover new opportunities with AI, and turn your reviews into actionable insights.
                    </p>
                    <div class="hero-actions">
                        <button class="btn btn-primary btn-lg">Start for free</button>
                        <button class="btn btn-secondary btn-lg">Watch demo</button>
                    </div>
                    <div class="hero-metrics">
                        <div class="metric">
                            <div class="metric-icon indigo">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/>
                                    <path d="M2 12h20"/>
                                    <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
                                </svg>
                            </div>
                            <div>
                                <div class="metric-value">27+</div>
                                <div class="metric-label">Countries</div>
                            </div>
                        </div>
                        <div class="metric">
                            <div class="metric-icon green">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="2" y="3" width="20" height="14" rx="2"/>
                                    <line x1="8" y1="21" x2="16" y2="21"/>
                                    <line x1="12" y1="17" x2="12" y2="21"/>
                                </svg>
                            </div>
                            <div>
                                <div class="metric-value">2</div>
                                <div class="metric-label">Platforms</div>
                            </div>
                        </div>
                        <div class="metric">
                            <div class="metric-icon orange">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M12 20V10"/>
                                    <path d="M18 20V4"/>
                                    <path d="M6 20v-4"/>
                                </svg>
                            </div>
                            <div>
                                <div class="metric-value">90d</div>
                                <div class="metric-label">History</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="hero-visual">
                    <div class="browser-frame">
                        <div class="browser-bar">
                            <div class="browser-dot dot-red"></div>
                            <div class="browser-dot dot-yellow"></div>
                            <div class="browser-dot dot-green"></div>
                            <div class="browser-url">app.keyrank.io/dashboard</div>
                        </div>
                        <div class="browser-content">
                            <div class="dash-header">
                                <div class="dash-title">Dashboard</div>
                                <div class="dash-filters">
                                    <button class="filter-btn active">7d</button>
                                    <button class="filter-btn">30d</button>
                                    <button class="filter-btn">90d</button>
                                </div>
                            </div>
                            <div class="dash-cards">
                                <div class="dash-card">
                                    <div class="dash-card-label">Apps</div>
                                    <div class="dash-card-value">12</div>
                                </div>
                                <div class="dash-card">
                                    <div class="dash-card-label">Keywords</div>
                                    <div class="dash-card-value accent">248</div>
                                </div>
                                <div class="dash-card">
                                    <div class="dash-card-label">Top 10</div>
                                    <div class="dash-card-value green">+34</div>
                                </div>
                            </div>
                            <div class="dash-table">
                                <div class="table-row header">
                                    <span></span>
                                    <span>Application</span>
                                    <span>Position</span>
                                    <span>Change</span>
                                </div>
                                <div class="table-row">
                                    <span></span>
                                    <div class="app-cell">
                                        <div class="app-avatar g1">M</div>
                                        <div>
                                            <div class="app-info-name">My App</div>
                                            <div class="app-info-dev">My Studio</div>
                                        </div>
                                    </div>
                                    <span class="rank-badge">#3</span>
                                    <span class="change-badge">+12</span>
                                </div>
                                <div class="table-row">
                                    <span></span>
                                    <div class="app-cell">
                                        <div class="app-avatar g2">S</div>
                                        <div>
                                            <div class="app-info-name">Super Game</div>
                                            <div class="app-info-dev">Game Studio</div>
                                        </div>
                                    </div>
                                    <span class="rank-badge">#7</span>
                                    <span class="change-badge">+5</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FEATURES -->
    <section class="features" id="features">
        <div class="container">
            <div class="section-header">
                <div class="section-label">Features</div>
                <h2 class="section-title">Everything to dominate ASO</h2>
                <p class="section-desc">Powerful tools to track your rankings, discover opportunities, and understand your users.</p>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon indigo">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 20V10"/><path d="M18 20V4"/><path d="M6 20v-4"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">Rank Tracking</h3>
                    <p class="feature-desc">Monitor your positions for each keyword with interactive charts over 7, 30, or 90 days. Visualize trends at a glance.</p>
                    <div class="feature-tags">
                        <span class="feature-tag">Interactive charts</span>
                        <span class="feature-tag">Multi-period</span>
                    </div>
                </div>

                <div class="feature-card">
                    <div class="feature-icon purple">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">AI Suggestions</h3>
                    <p class="feature-desc">Generate 50+ suggestions per country with difficulty scores, competition levels, and analysis of top 3 competitors.</p>
                    <div class="feature-tags">
                        <span class="feature-tag">Difficulty score</span>
                        <span class="feature-tag">Competitor analysis</span>
                    </div>
                </div>

                <div class="feature-card">
                    <div class="feature-icon green">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/><path d="M2 12h20"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">27+ Countries</h3>
                    <p class="feature-desc">Track your positions in all major markets: US, UK, DE, FR, JP, BR, AU, and 20+ other regions.</p>
                    <div class="feature-tags">
                        <span class="feature-tag">Global coverage</span>
                        <span class="feature-tag">Per storefront</span>
                    </div>
                </div>

                <div class="feature-card">
                    <div class="feature-icon orange">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">Review Analysis</h3>
                    <p class="feature-desc">Automatically collect reviews by country. AI extracts emerging themes and identifies strengths & weaknesses.</p>
                    <div class="feature-tags">
                        <span class="feature-tag">Emerging themes</span>
                        <span class="feature-tag">Key quotes</span>
                    </div>
                </div>

                <div class="feature-card">
                    <div class="feature-icon red">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">6-Dimension Insights</h3>
                    <p class="feature-desc">Automatic scoring on: UX, Performance, Features, Pricing, Support, and Onboarding. Each with AI summary.</p>
                    <div class="feature-tags">
                        <span class="feature-tag">Auto scoring</span>
                        <span class="feature-tag">Recommendations</span>
                    </div>
                </div>

                <div class="feature-card">
                    <div class="feature-icon blue">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">Competitive Research</h3>
                    <p class="feature-desc">Search any keyword to see who ranks for it. Get popularity scores and add to tracking in one click.</p>
                    <div class="feature-tags">
                        <span class="feature-tag">Popularity</span>
                        <span class="feature-tag">Top competitors</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- PLATFORMS -->
    <section class="platforms">
        <div class="container">
            <div class="platforms-grid">
                <div class="platforms-content">
                    <h2>Two platforms, one interface</h2>
                    <p>Manage your iOS and Android apps from a single dashboard. Compare cross-platform performance and optimize your global strategy.</p>

                    <ul class="platform-list">
                        <li>
                            <span class="icon">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                                </svg>
                            </span>
                            App Store - iOS & iPadOS
                        </li>
                        <li>
                            <span class="icon">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M17.523 2.008c-.324.005-.636.072-.934.189L5.47 7.172l7.76 4.37 4.293-9.534zm1.464 1.247l-3.812 8.514 4.66 2.626c.656.372 1.165.174 1.165-.733V4.18c0-.736-.41-1.116-.88-1.116-.04 0-.09.003-.133.008v-.001zM3.008 8.094v7.812c0 .907.509 1.105 1.165.733l.14-.079 4.553-2.567-5.858-5.899zM13.97 12.5l-7.76 4.37 11.119 4.975c.298.117.61.184.934.19.04.004.093.007.133.007.47 0 .88-.38.88-1.116v-.486L13.97 12.5z"/>
                                </svg>
                            </span>
                            Google Play - Android
                        </li>
                    </ul>

                    <div class="country-tags">
                        <span class="country-tag">USA</span>
                        <span class="country-tag">UK</span>
                        <span class="country-tag">Germany</span>
                        <span class="country-tag">France</span>
                        <span class="country-tag">Japan</span>
                        <span class="country-tag">Brazil</span>
                        <span class="country-tag">+20 more</span>
                    </div>
                </div>

                <div class="platforms-visual">
                    <div class="platform-stats">
                        <div class="platform-stat">
                            <div class="platform-stat-icon">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="#6366f1">
                                    <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                                </svg>
                            </div>
                            <div class="platform-stat-name">App Store</div>
                            <div class="platform-stat-desc">iOS & iPadOS</div>
                        </div>
                        <div class="platform-stat">
                            <div class="platform-stat-icon">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="#22c55e">
                                    <path d="M17.523 2.008c-.324.005-.636.072-.934.189L5.47 7.172l7.76 4.37 4.293-9.534zm1.464 1.247l-3.812 8.514 4.66 2.626c.656.372 1.165.174 1.165-.733V4.18c0-.736-.41-1.116-.88-1.116-.04 0-.09.003-.133.008v-.001zM3.008 8.094v7.812c0 .907.509 1.105 1.165.733l.14-.079 4.553-2.567-5.858-5.899zM13.97 12.5l-7.76 4.37 11.119 4.975c.298.117.61.184.934.19.04.004.093.007.133.007.47 0 .88-.38.88-1.116v-.486L13.97 12.5z"/>
                                </svg>
                            </div>
                            <div class="platform-stat-name">Google Play</div>
                            <div class="platform-stat-desc">Android</div>
                        </div>
                        <div class="platform-stat">
                            <div class="platform-stat-icon">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#f97316" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/><path d="M2 12h20"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
                                </svg>
                            </div>
                            <div class="platform-stat-name">27+ Countries</div>
                            <div class="platform-stat-desc">Global coverage</div>
                        </div>
                        <div class="platform-stat">
                            <div class="platform-stat-icon">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#a855f7" stroke-width="2">
                                    <path d="M12 20V10"/><path d="M18 20V4"/><path d="M6 20v-4"/>
                                </svg>
                            </div>
                            <div class="platform-stat-name">Real-time</div>
                            <div class="platform-stat-desc">24h updates</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- HOW IT WORKS -->
    <section class="how-it-works">
        <div class="container">
            <div class="section-header">
                <div class="section-label">How it works</div>
                <h2 class="section-title">Up and running in 4 steps</h2>
                <p class="section-desc">Start tracking your rankings in minutes.</p>
            </div>

            <div class="steps">
                <div class="step">
                    <div class="step-number">1</div>
                    <h3 class="step-title">Add your app</h3>
                    <p class="step-desc">Search for your iOS or Android app and add it in one click.</p>
                </div>
                <div class="step">
                    <div class="step-number">2</div>
                    <h3 class="step-title">Choose your keywords</h3>
                    <p class="step-desc">Add manually or use AI-powered suggestions.</p>
                </div>
                <div class="step">
                    <div class="step-number">3</div>
                    <h3 class="step-title">Select countries</h3>
                    <p class="step-desc">Choose your target markets from 27+ countries.</p>
                </div>
                <div class="step">
                    <div class="step-number">4</div>
                    <h3 class="step-title">Analyze & optimize</h3>
                    <p class="step-desc">Track your progress and read AI insights.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- PRICING -->
    <section class="pricing" id="pricing">
        <div class="container">
            <div class="section-header">
                <div class="section-label">Pricing</div>
                <h2 class="section-title">Simple and transparent</h2>
                <p class="section-desc">Start for free, scale when you're ready.</p>
            </div>

            <div class="pricing-grid">
                <div class="pricing-card">
                    <div class="pricing-name">Starter</div>
                    <div class="pricing-desc">To get started</div>
                    <div class="pricing-price">$0<span>USD</span></div>
                    <div class="pricing-period">Free forever</div>
                    <ul class="pricing-features">
                        <li><span class="check">&#10003;</span> 1 application</li>
                        <li><span class="check">&#10003;</span> 10 keywords</li>
                        <li><span class="check">&#10003;</span> 3 countries</li>
                        <li><span class="check">&#10003;</span> 30 days history</li>
                    </ul>
                    <button class="btn btn-secondary">Get started</button>
                </div>

                <div class="pricing-card featured">
                    <div class="pricing-badge">Popular</div>
                    <div class="pricing-name">Pro</div>
                    <div class="pricing-desc">To grow</div>
                    <div class="pricing-price">$29<span>USD</span></div>
                    <div class="pricing-period">per month</div>
                    <ul class="pricing-features">
                        <li><span class="check">&#10003;</span> 10 applications</li>
                        <li><span class="check">&#10003;</span> 100 keywords / app</li>
                        <li><span class="check">&#10003;</span> All countries</li>
                        <li><span class="check">&#10003;</span> 90 days history</li>
                        <li><span class="check">&#10003;</span> AI suggestions</li>
                        <li><span class="check">&#10003;</span> Review insights</li>
                    </ul>
                    <button class="btn btn-primary">14-day free trial</button>
                </div>

                <div class="pricing-card">
                    <div class="pricing-name">Business</div>
                    <div class="pricing-desc">For teams</div>
                    <div class="pricing-price">$99<span>USD</span></div>
                    <div class="pricing-period">per month</div>
                    <ul class="pricing-features">
                        <li><span class="check">&#10003;</span> Unlimited apps</li>
                        <li><span class="check">&#10003;</span> Unlimited keywords</li>
                        <li><span class="check">&#10003;</span> Unlimited history</li>
                        <li><span class="check">&#10003;</span> API access</li>
                        <li><span class="check">&#10003;</span> Priority support</li>
                        <li><span class="check">&#10003;</span> Data export</li>
                    </ul>
                    <button class="btn btn-secondary">Contact us</button>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="cta">
        <div class="container">
            <div class="cta-box">
                <h2>Ready to boost your rankings?</h2>
                <p>Join the developers already optimizing their ASO with Keyrank.</p>
                <button class="btn btn-primary btn-lg">Start for free</button>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="container">
            <div class="footer-inner">
                <a href="/" class="logo">
                    <svg class="logo-icon" width="24" height="24" viewBox="0 0 56 56" fill="none">
                        <rect x="2" y="2" width="52" height="52" rx="14" fill="#18181b" stroke="#27272a" stroke-width="1"/>
                        <rect x="10" y="34" width="10" height="14" rx="2" fill="#4f46e5"/>
                        <rect x="23" y="26" width="10" height="22" rx="2" fill="#6366f1"/>
                        <rect x="36" y="16" width="10" height="32" rx="2" fill="#818cf8"/>
                        <path d="M46 8L46 14" stroke="#a5b4fc" stroke-width="2" stroke-linecap="round"/>
                        <path d="M43 11L46 8L49 11" stroke="#a5b4fc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <span class="logo-text" style="font-size: 16px;">keyrank</span>
                </a>
                <div class="footer-links">
                    <a href="#" class="footer-link">Documentation</a>
                    <a href="#" class="footer-link">Blog</a>
                    <a href="#" class="footer-link">Support</a>
                    <a href="#" class="footer-link">Privacy</a>
                </div>
                <div class="footer-copy">&copy; {{ date('Y') }} Keyrank. All rights reserved.</div>
            </div>
        </div>
    </footer>
</body>
</html>
