# Settings Page & Light Mode Design

## Overview

Add a settings page accessible via a user menu dropdown, with theme switching (system/light/dark) and account information display.

## Requirements

- Default theme: system
- User can change theme in settings
- Theme preference persisted across sessions
- Light mode with glassmorphism style matching dark mode

## Architecture

### Theme Provider

New file: `core/providers/theme_provider.dart`

- `StateNotifierProvider<ThemeNotifier, ThemeMode>`
- Persistence with `shared_preferences` (key: `theme_mode`)
- On startup, reads saved preference (default: `system`)
- Method `setThemeMode(ThemeMode)` saves and updates state

### Color Palette

New class `AppColorsLight` in `app_colors.dart`:

| Element | Dark | Light |
|---------|------|-------|
| bgBase | `#0a0a0a` | `#f5f5f7` |
| bgSurface | `#111111` | `#ffffff` |
| glassPanel | `#1a1a1a` | `#ffffff` (80% opacity) |
| glassBorder | `#2d2d2d` | `#e0e0e0` |
| textPrimary | `#f0f0f0` | `#1a1a1a` |
| textSecondary | `#a0a0a0` | `#6b6b6b` |
| textMuted | `#6a6a6a` | `#9a9a9a` |
| border | `#2d2d2d` | `#e5e5e5` |
| accent | `#3b82f6` | `#2563eb` |

### User Menu Dropdown

Located in sidebar, replaces current user block.

Content:
- Email (non-clickable, muted text)
- "Settings" link → navigates to `/settings`
- "Se déconnecter" → calls `authNotifier.logout()`

Style:
- Glassmorphism (semi-transparent + blur)
- Rounded corners (14px)
- Fade-in animation
- Closes on outside click

### Settings Page

Route: `/settings` (protected)

Sections:
1. **Apparence**
   - Theme selector: `SegmentedButton` with 3 options (Système, Sombre, Clair)
   - Immediate change, persisted

2. **Compte**
   - Email display
   - Member since date

3. **Actions**
   - Logout button

## Files

### New Files
- `core/providers/theme_provider.dart`
- `features/settings/presentation/screens/settings_screen.dart`
- `core/widgets/user_menu.dart`

### Modified Files
- `core/theme/app_colors.dart` - add `AppColorsLight`
- `core/theme/app_theme.dart` - add `lightTheme`, adapt `GlassContainer`
- `core/router/app_router.dart` - add `/settings` route
- `core/router/main_shell.dart` - replace user block with `UserMenu`
- `main.dart` - connect `themeProvider`

## Dependencies

None new - `shared_preferences` already in pubspec.yaml.
