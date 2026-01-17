# Team-Centric Architecture & Permissions Design

## Overview

Refactor the application from user-centric to team-centric data ownership. All tracked resources (apps, keywords, competitors, etc.) belong to teams, not individual users. Permissions are enforced based on the user's role within the team.

## Data Model Changes

### Tables migrating to team_id

| Table | Change | New Unique Constraint |
|-------|--------|----------------------|
| `user_apps` | DELETE (use `team_apps`) | - |
| `tracked_keywords` | `user_id` → `team_id` | `(team_id, app_id, keyword_id)` |
| `app_competitors` | `user_id` → `team_id` | `(team_id, owner_app_id, competitor_app_id)` |
| `alert_rules` | `user_id` → `team_id` | `(team_id, type, scope_type, scope_id)` |
| `tags` | `user_id` → `team_id` | `(team_id, name)` |
| `app_voice_settings` | `user_id` → `team_id` | `(team_id, app_id)` |
| `app_metadata_drafts` | `user_id` → `team_id` | `(team_id, app_id, locale)` |
| `subscriptions` | `user_id` → `team_id` | - |

### Tables remaining user-based

| Table | Reason |
|-------|--------|
| `store_connections` | Apple/Google credentials are personal to user |
| `notifications` | Notifications are per-user |
| `chat_conversations` | Chat history is personal |
| `chat_usage` | AI quotas are per-user |
| `integrations` | Could be either, keeping user for now |

### Note on store_connections

Store connections remain user-based (credentials belong to the user), but the data fetched through them is visible to all team members. The user who connected their Apple/Google account shares access to the data with their team.

## Permission Enforcement

### Roles and Permissions (existing)

```
owner  → all permissions + manage_team, manage_billing, delete_team
admin  → all except billing/delete + invite_members, remove_members
editor → manage_apps, manage_keywords, edit_metadata, manage_alerts, view_analytics, export_data
viewer → view_apps, view_keywords, view_analytics, export_data (READ-ONLY)
```

### Backend Implementation

Create a helper trait for controllers:

```php
// app/Http/Controllers/Concerns/AuthorizesTeamActions.php
trait AuthorizesTeamActions
{
    protected function currentTeam(): Team
    {
        $team = auth()->user()->currentTeam;
        if (!$team) {
            abort(403, 'No team selected');
        }
        return $team;
    }

    protected function authorizeTeamAction(string $permission): void
    {
        $user = auth()->user();
        $team = $this->currentTeam();

        if (!$team->userHasPermission($user, $permission)) {
            abort(403, 'You do not have permission to perform this action');
        }
    }
}
```

Usage in controllers:

```php
class AppController extends Controller
{
    use AuthorizesTeamActions;

    public function index()
    {
        return $this->currentTeam()->apps()->get();
    }

    public function store(Request $request)
    {
        $this->authorizeTeamAction('manage_apps');
        // ... create app tracking
    }

    public function destroy(App $app)
    {
        $this->authorizeTeamAction('manage_apps');
        // ... remove app from team
    }
}
```

### Controllers to Update

| Controller | Read (team filter) | Write (permission check) |
|------------|-------------------|-------------------------|
| `AppController` | `currentTeam()->apps()` | `manage_apps` |
| `KeywordController` | `where('team_id', ...)` | `manage_keywords` |
| `CompetitorController` | `where('team_id', ...)` | `manage_competitors` |
| `AlertRulesController` | `where('team_id', ...)` | `manage_alerts` |
| `MetadataController` | `where('team_id', ...)` | `edit_metadata` |
| `TagsController` | `where('team_id', ...)` | `manage_apps` |

## Flutter Changes

### Permission-based UI

The backend returns permissions in the team response. Flutter uses these to show/hide UI elements:

```dart
// Already available via TeamModel
final team = ref.watch(currentTeamProvider);
final canEdit = team.valueOrNull?.role.canEditApps ?? false;

// Hide edit buttons for viewers
if (canEdit) FloatingActionButton(...)
```

### Team Switching

When user switches teams, invalidate all team-dependent providers:

```dart
Future<void> switchTeam(int teamId) async {
  await _repository.switchTeam(teamId);
  _ref.invalidate(appsProvider);
  _ref.invalidate(keywordsProvider);
  _ref.invalidate(competitorsProvider);
  _ref.invalidate(alertsProvider);
  // etc.
}
```

### No API Changes Needed

The Flutter app doesn't need to send `team_id` in requests. The backend automatically uses the user's `current_team_id` to filter data.

## Migration Strategy

Since this is a development environment with only local data:

1. Create a single migration that:
   - Drops `user_apps` table
   - Adds `team_id` column to all affected tables
   - Drops `user_id` column from those tables
   - Updates unique constraints

2. Update all Eloquent models to use `team_id` instead of `user_id`

3. Update all controllers to:
   - Use `AuthorizesTeamActions` trait
   - Filter by `currentTeam()` instead of `auth()->user()`
   - Check permissions before write operations

4. Update Flutter screens to conditionally show edit controls based on role

## Implementation Order

1. **Migration** - Schema changes (single migration)
2. **Models** - Update relationships and scopes
3. **Trait** - Create `AuthorizesTeamActions`
4. **Controllers** - Update one by one:
   - AppController
   - KeywordController
   - CompetitorController
   - AlertRulesController
   - MetadataController
   - TagsController
5. **Flutter** - Add permission checks to UI

## Testing

After implementation:
- Create a team with owner
- Invite a viewer
- Login as viewer → verify read-only access
- Login as owner → verify full access
- Switch teams → verify data changes
