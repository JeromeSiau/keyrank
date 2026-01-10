<?php

namespace Tests\Feature;

use App\Models\Notification;
use App\Models\User;
use App\Services\NotificationService;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class NotificationServiceTest extends TestCase
{
    use RefreshDatabase;

    private NotificationService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new NotificationService();
    }

    public function test_creates_notification_for_user(): void
    {
        $user = User::factory()->create();

        $notification = $this->service->create($user, [
            'type' => 'position_change',
            'title' => 'Position dropped',
            'body' => 'Your app dropped 5 positions',
            'data' => ['app_id' => 1],
        ]);

        $this->assertInstanceOf(Notification::class, $notification);
        $this->assertEquals($user->id, $notification->user_id);
        $this->assertEquals('Position dropped', $notification->title);
    }

    public function test_is_quiet_hours_returns_true_during_quiet_period(): void
    {
        $user = User::factory()->create([
            'timezone' => 'Europe/Paris',
            'quiet_hours_start' => '22:00:00',
            'quiet_hours_end' => '08:00:00',
        ]);

        // Test at 23:00 Paris time (should be quiet)
        Carbon::setTestNow(Carbon::parse('2026-01-10 23:00:00', 'Europe/Paris'));
        $this->assertTrue($this->service->isQuietHours($user));

        // Test at 03:00 Paris time (should be quiet)
        Carbon::setTestNow(Carbon::parse('2026-01-11 03:00:00', 'Europe/Paris'));
        $this->assertTrue($this->service->isQuietHours($user));

        Carbon::setTestNow(); // Reset
    }

    public function test_is_quiet_hours_returns_false_outside_quiet_period(): void
    {
        $user = User::factory()->create([
            'timezone' => 'Europe/Paris',
            'quiet_hours_start' => '22:00:00',
            'quiet_hours_end' => '08:00:00',
        ]);

        // Test at 12:00 Paris time (should not be quiet)
        Carbon::setTestNow(Carbon::parse('2026-01-10 12:00:00', 'Europe/Paris'));
        $this->assertFalse($this->service->isQuietHours($user));

        Carbon::setTestNow(); // Reset
    }

    public function test_aggregates_multiple_notifications_of_same_type(): void
    {
        $user = User::factory()->create();

        $alerts = collect([
            ['type' => 'position_change', 'title' => 'App 1 dropped', 'body' => 'Details 1', 'data' => ['app_id' => 1]],
            ['type' => 'position_change', 'title' => 'App 2 dropped', 'body' => 'Details 2', 'data' => ['app_id' => 2]],
            ['type' => 'position_change', 'title' => 'App 3 dropped', 'body' => 'Details 3', 'data' => ['app_id' => 3]],
        ]);

        $aggregated = $this->service->aggregate($alerts);

        $this->assertCount(1, $aggregated);
        $this->assertEquals('aggregated', $aggregated->first()['type']);
        $this->assertStringContainsString('3', $aggregated->first()['title']);
    }

    public function test_does_not_aggregate_single_notification(): void
    {
        $alerts = collect([
            ['type' => 'position_change', 'title' => 'App dropped', 'body' => 'Details', 'data' => ['app_id' => 1]],
        ]);

        $aggregated = $this->service->aggregate($alerts);

        $this->assertCount(1, $aggregated);
        $this->assertEquals('position_change', $aggregated->first()['type']);
    }
}
