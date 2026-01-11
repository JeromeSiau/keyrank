<?php

namespace Database\Factories;

use App\Models\StoreConnection;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class StoreConnectionFactory extends Factory
{
    protected $model = StoreConnection::class;

    public function definition(): array
    {
        $platform = $this->faker->randomElement(['ios', 'android']);

        return [
            'user_id' => User::factory(),
            'platform' => $platform,
            'credentials' => $this->makeCredentials($platform),
            'connected_at' => now(),
            'last_sync_at' => null,
            'status' => 'active',
        ];
    }

    public function ios(): self
    {
        return $this->state([
            'platform' => 'ios',
            'credentials' => $this->makeCredentials('ios'),
        ]);
    }

    public function android(): self
    {
        return $this->state([
            'platform' => 'android',
            'credentials' => $this->makeCredentials('android'),
        ]);
    }

    public function expired(): self
    {
        return $this->state(['status' => 'expired']);
    }

    public function revoked(): self
    {
        return $this->state(['status' => 'revoked']);
    }

    private function makeCredentials(string $platform): array
    {
        if ($platform === 'ios') {
            return [
                'name' => $this->faker->company() . ' iOS',
                'key_id' => $this->faker->regexify('[A-Z0-9]{10}'),
                'issuer_id' => $this->faker->uuid(),
                'private_key' => "-----BEGIN PRIVATE KEY-----\nFAKE_KEY_FOR_TESTING\n-----END PRIVATE KEY-----",
            ];
        }

        return [
            'name' => $this->faker->company() . ' Android',
            'client_id' => $this->faker->regexify('[0-9]{12}') . '.apps.googleusercontent.com',
            'client_secret' => $this->faker->regexify('[A-Za-z0-9_-]{24}'),
            'refresh_token' => $this->faker->regexify('[A-Za-z0-9_-]{64}'),
        ];
    }
}
