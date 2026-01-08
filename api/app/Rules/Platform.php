<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class Platform implements ValidationRule
{
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (!in_array($value, ['ios', 'android'])) {
            $fail('The :attribute must be either ios or android.');
        }
    }
}
