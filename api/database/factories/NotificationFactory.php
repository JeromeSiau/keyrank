<?php

namespace Database\Factories;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class NotificationFactory extends Factory
{
    protected $model = Notification::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'alert_rule_id' => null,
            'type' => 'position_change',
            'title' => $this->faker->sentence(4),
            'body' => $this->faker->sentence(10),
            'data' => null,
            'is_read' => false,
            'read_at' => null,
            'sent_at' => now(),
            'created_at' => now(),
        ];
    }

    public function read(): self
    {
        return $this->state([
            'is_read' => true,
            'read_at' => now(),
        ]);
    }

    public function unsent(): self
    {
        return $this->state(['sent_at' => null]);
    }
}
