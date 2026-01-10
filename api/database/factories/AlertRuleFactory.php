<?php

namespace Database\Factories;

use App\Models\AlertRule;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class AlertRuleFactory extends Factory
{
    protected $model = AlertRule::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'name' => $this->faker->words(3, true),
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'scope_type' => AlertRule::SCOPE_GLOBAL,
            'scope_id' => null,
            'conditions' => ['direction' => 'down', 'threshold' => 10],
            'is_template' => false,
            'is_active' => true,
            'priority' => 0,
        ];
    }

    public function inactive(): self
    {
        return $this->state(['is_active' => false]);
    }

    public function template(): self
    {
        return $this->state(['is_template' => true]);
    }

    public function forApp(int $appId): self
    {
        return $this->state([
            'scope_type' => AlertRule::SCOPE_APP,
            'scope_id' => $appId,
        ]);
    }
}
