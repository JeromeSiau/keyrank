<?php

namespace Database\Seeders;

use App\Models\AlertRule;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppReview;
use App\Models\Keyword;
use App\Models\Tag;
use App\Models\Team;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DemoSeeder extends Seeder
{
    /**
     * Realistic demo apps data
     */
    private array $demoApps = [
        [
            'platform' => 'ios',
            'store_id' => '1234567890',
            'bundle_id' => 'com.demo.fitnesstracker',
            'name' => 'FitTrack Pro',
            'developer' => 'Demo Apps Inc.',
            'rating' => 4.7,
            'rating_count' => 12543,
            'storefront' => 'US',
            'icon_url' => 'https://placehold.co/100x100/FF6B6B/white?text=FT',
        ],
        [
            'platform' => 'ios',
            'store_id' => '1234567891',
            'bundle_id' => 'com.demo.taskmanager',
            'name' => 'TaskFlow',
            'developer' => 'Demo Apps Inc.',
            'rating' => 4.5,
            'rating_count' => 8921,
            'storefront' => 'US',
            'icon_url' => 'https://placehold.co/100x100/4ECDC4/white?text=TF',
        ],
        [
            'platform' => 'ios',
            'store_id' => '1234567892',
            'bundle_id' => 'com.demo.meditation',
            'name' => 'ZenMind',
            'developer' => 'Demo Apps Inc.',
            'rating' => 4.8,
            'rating_count' => 25678,
            'storefront' => 'US',
            'icon_url' => 'https://placehold.co/100x100/9B59B6/white?text=ZM',
        ],
    ];

    /**
     * Keywords grouped by app type
     */
    private array $keywordsByCategory = [
        'fitness' => [
            ['keyword' => 'fitness tracker', 'popularity' => 72],
            ['keyword' => 'workout app', 'popularity' => 68],
            ['keyword' => 'calorie counter', 'popularity' => 65],
            ['keyword' => 'step counter', 'popularity' => 58],
            ['keyword' => 'exercise tracker', 'popularity' => 52],
            ['keyword' => 'gym workout', 'popularity' => 61],
            ['keyword' => 'weight loss app', 'popularity' => 55],
            ['keyword' => 'running tracker', 'popularity' => 48],
        ],
        'productivity' => [
            ['keyword' => 'task manager', 'popularity' => 62],
            ['keyword' => 'todo list', 'popularity' => 71],
            ['keyword' => 'productivity app', 'popularity' => 54],
            ['keyword' => 'project management', 'popularity' => 47],
            ['keyword' => 'time tracker', 'popularity' => 43],
            ['keyword' => 'reminder app', 'popularity' => 51],
            ['keyword' => 'habit tracker', 'popularity' => 58],
        ],
        'meditation' => [
            ['keyword' => 'meditation app', 'popularity' => 76],
            ['keyword' => 'sleep sounds', 'popularity' => 69],
            ['keyword' => 'mindfulness', 'popularity' => 63],
            ['keyword' => 'relaxation app', 'popularity' => 55],
            ['keyword' => 'breathing exercises', 'popularity' => 48],
            ['keyword' => 'stress relief', 'popularity' => 52],
            ['keyword' => 'calm music', 'popularity' => 44],
        ],
    ];

    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->command->info('🌱 Creating demo environment...');

        // Create demo user and team
        $user = $this->createDemoUser();
        $team = $this->createDemoTeam($user);

        // Create apps
        $apps = $this->createDemoApps($team, $user);

        // Create keywords and track them
        $this->createKeywordsAndTrack($team, $apps);

        // Create ranking history
        $this->createRankingHistory($apps);

        // Create reviews
        $this->createReviews($apps);

        // Create tags
        $this->createTags($team);

        // Create alert rules
        $this->createAlertRules($team, $apps);

        $this->command->info('✅ Demo environment created successfully!');
        $this->command->info('');
        $this->command->info('📧 Login credentials:');
        $this->command->info('   Email: demo@keyrank.io');
        $this->command->info('   Password: demo123456');
    }

    private function createDemoUser(): User
    {
        $this->command->info('👤 Creating demo user...');

        return User::updateOrCreate(
            ['email' => 'demo@keyrank.io'],
            [
                'name' => 'Demo User',
                'password' => Hash::make('demo123456'),
                'email_verified_at' => now(),
            ]
        );
    }

    private function createDemoTeam(User $owner): Team
    {
        $this->command->info('👥 Creating demo team...');

        $team = Team::updateOrCreate(
            ['slug' => 'demo-team'],
            [
                'name' => 'Demo Team',
                'description' => 'Demo team for testing Keyrank features',
                'owner_id' => $owner->id,
            ]
        );

        // Add owner as member if not already
        if (!$team->hasMember($owner)) {
            $team->members()->attach($owner->id, ['role' => Team::ROLE_OWNER]);
        }

        // Set as current team
        $owner->update(['current_team_id' => $team->id]);

        // Create additional team members
        $this->createTeamMembers($team);

        return $team;
    }

    private function createTeamMembers(Team $team): void
    {
        $members = [
            ['name' => 'Alice Martin', 'email' => 'alice@demo.io', 'role' => Team::ROLE_ADMIN],
            ['name' => 'Bob Wilson', 'email' => 'bob@demo.io', 'role' => Team::ROLE_EDITOR],
            ['name' => 'Carol Davis', 'email' => 'carol@demo.io', 'role' => Team::ROLE_VIEWER],
        ];

        foreach ($members as $memberData) {
            $user = User::updateOrCreate(
                ['email' => $memberData['email']],
                [
                    'name' => $memberData['name'],
                    'password' => Hash::make('demo123456'),
                    'email_verified_at' => now(),
                    'current_team_id' => $team->id,
                ]
            );

            if (!$team->hasMember($user)) {
                $team->members()->attach($user->id, ['role' => $memberData['role']]);
            }
        }
    }

    private function createDemoApps(Team $team, User $addedBy): array
    {
        $this->command->info('📱 Creating demo apps...');

        $apps = [];
        foreach ($this->demoApps as $appData) {
            $app = App::updateOrCreate(
                ['store_id' => $appData['store_id'], 'platform' => $appData['platform']],
                $appData
            );

            // Attach to team if not already
            if (!$team->apps()->where('app_id', $app->id)->exists()) {
                $team->apps()->attach($app->id, [
                    'added_by' => $addedBy->id,
                    'is_owner' => true,
                    'ownership_type' => 'manual',
                ]);
            }

            $apps[] = $app;
        }

        return $apps;
    }

    private function createKeywordsAndTrack(Team $team, array $apps): void
    {
        $this->command->info('🔑 Creating keywords...');

        $categories = ['fitness', 'productivity', 'meditation'];

        foreach ($apps as $index => $app) {
            $category = $categories[$index] ?? 'fitness';
            $keywordsData = $this->keywordsByCategory[$category];

            foreach ($keywordsData as $keywordData) {
                // Create or get keyword
                $keyword = Keyword::updateOrCreate(
                    ['keyword' => $keywordData['keyword'], 'storefront' => 'US'],
                    [
                        'popularity' => $keywordData['popularity'],
                        'popularity_updated_at' => now(),
                    ]
                );

                // Track keyword for app
                TrackedKeyword::updateOrCreate(
                    [
                        'team_id' => $team->id,
                        'app_id' => $app->id,
                        'keyword_id' => $keyword->id,
                    ],
                    [
                        'difficulty' => fake()->numberBetween(30, 80),
                        'difficulty_label' => fake()->randomElement(['Easy', 'Medium', 'Hard']),
                        'competition' => fake()->numberBetween(20, 90),
                        'is_favorite' => fake()->boolean(20),
                        'favorited_at' => fake()->boolean(20) ? now() : null,
                        'created_at' => now()->subDays(fake()->numberBetween(1, 60)),
                    ]
                );
            }
        }
    }

    private function createRankingHistory(array $apps): void
    {
        $this->command->info('📊 Creating ranking history (30 days)...');

        foreach ($apps as $app) {
            $trackedKeywords = TrackedKeyword::where('app_id', $app->id)->with('keyword')->get();

            foreach ($trackedKeywords as $tracked) {
                // Generate 30 days of ranking data with realistic fluctuations
                $basePosition = fake()->numberBetween(10, 80);

                for ($day = 30; $day >= 0; $day--) {
                    $date = now()->subDays($day)->toDateString();

                    // Skip if ranking already exists
                    if (AppRanking::where('app_id', $app->id)
                        ->where('keyword_id', $tracked->keyword_id)
                        ->where('recorded_at', $date)
                        ->exists()) {
                        continue;
                    }

                    // Simulate realistic position changes
                    $change = fake()->numberBetween(-3, 3);
                    $basePosition = max(1, min(200, $basePosition + $change));

                    // Occasionally have bigger movements
                    if (fake()->boolean(10)) {
                        $basePosition = max(1, min(200, $basePosition + fake()->numberBetween(-10, 10)));
                    }

                    AppRanking::create([
                        'app_id' => $app->id,
                        'keyword_id' => $tracked->keyword_id,
                        'position' => $basePosition,
                        'recorded_at' => $date,
                    ]);
                }
            }
        }
    }

    private function createReviews(array $apps): void
    {
        $this->command->info('⭐ Creating app reviews...');

        $reviewTemplates = [
            'positive' => [
                ['title' => 'Amazing app!', 'content' => 'This app has completely changed my routine. Highly recommended!', 'rating' => 5],
                ['title' => 'Love it', 'content' => 'Simple, effective, and beautiful design. Exactly what I needed.', 'rating' => 5],
                ['title' => 'Great features', 'content' => 'The features are well thought out and the app is very intuitive.', 'rating' => 4],
                ['title' => 'Very helpful', 'content' => 'Has helped me stay on track with my goals. Worth every penny.', 'rating' => 5],
                ['title' => 'Best in class', 'content' => 'Tried many similar apps but this one stands out from the rest.', 'rating' => 5],
            ],
            'neutral' => [
                ['title' => 'Good but needs work', 'content' => 'Solid app overall but could use some UI improvements.', 'rating' => 3],
                ['title' => 'Decent', 'content' => 'Does what it says but nothing special. Gets the job done.', 'rating' => 3],
                ['title' => 'Average experience', 'content' => 'Some features are great, others need polish.', 'rating' => 3],
            ],
            'negative' => [
                ['title' => 'Crashes frequently', 'content' => 'App keeps crashing on my iPhone. Please fix!', 'rating' => 1],
                ['title' => 'Not working', 'content' => 'Sync feature is broken. Lost all my data.', 'rating' => 2],
                ['title' => 'Disappointing', 'content' => 'Expected more based on the description. Basic features are missing.', 'rating' => 2],
            ],
        ];

        foreach ($apps as $app) {
            // Create mix of reviews (more positive, some neutral, few negative)
            $reviewCounts = ['positive' => 8, 'neutral' => 4, 'negative' => 2];

            foreach ($reviewCounts as $sentiment => $count) {
                for ($i = 0; $i < $count; $i++) {
                    $template = fake()->randomElement($reviewTemplates[$sentiment]);

                    AppReview::factory()->create([
                        'app_id' => $app->id,
                        'title' => $template['title'],
                        'content' => $template['content'],
                        'rating' => $template['rating'],
                        'sentiment' => $sentiment,
                        'reviewed_at' => fake()->dateTimeBetween('-30 days', 'now'),
                    ]);
                }
            }
        }
    }

    private function createTags(Team $team): void
    {
        $this->command->info('🏷️ Creating tags...');

        $tags = [
            ['name' => 'Brand', 'color' => '#3B82F6'],
            ['name' => 'Competitor', 'color' => '#EF4444'],
            ['name' => 'High Priority', 'color' => '#F59E0B'],
            ['name' => 'Long Tail', 'color' => '#10B981'],
            ['name' => 'Trending', 'color' => '#8B5CF6'],
        ];

        foreach ($tags as $tagData) {
            Tag::updateOrCreate(
                ['team_id' => $team->id, 'name' => $tagData['name']],
                ['color' => $tagData['color']]
            );
        }
    }

    private function createAlertRules(Team $team, array $apps): void
    {
        $this->command->info('🔔 Creating alert rules...');

        // Global alert for position changes
        AlertRule::updateOrCreate(
            ['team_id' => $team->id, 'name' => 'Major Position Changes'],
            [
                'type' => 'position_change',
                'scope_type' => 'global',
                'conditions' => ['threshold' => 10, 'direction' => 'both'],
                'is_active' => true,
            ]
        );

        // Alert for first app
        if (!empty($apps)) {
            AlertRule::updateOrCreate(
                ['team_id' => $team->id, 'name' => 'FitTrack Top 10 Alert'],
                [
                    'type' => 'position_change',
                    'scope_type' => 'app',
                    'scope_id' => $apps[0]->id,
                    'conditions' => ['threshold' => 5, 'direction' => 'drop'],
                    'is_active' => true,
                ]
            );
        }

        // Review alert
        AlertRule::updateOrCreate(
            ['team_id' => $team->id, 'name' => 'Negative Reviews Alert'],
            [
                'type' => 'review_keyword',
                'scope_type' => 'global',
                'conditions' => ['keywords' => ['bug', 'crash', 'broken', 'fix']],
                'is_active' => true,
            ]
        );
    }
}
