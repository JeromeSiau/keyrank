<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Symfony\Component\HttpFoundation\Response;

class LoginRateLimiter
{
    public function handle(Request $request, Closure $next): Response
    {
        $key = 'login:' . $request->ip();

        if (RateLimiter::tooManyAttempts($key, 5)) {
            $seconds = RateLimiter::availableIn($key);
            return response()->json([
                'message' => "Too many login attempts. Please try again in {$seconds} seconds.",
            ], 429);
        }

        $response = $next($request);

        // Only count failed attempts
        if ($response->getStatusCode() === 422 || $response->getStatusCode() === 401) {
            RateLimiter::hit($key, 300); // 5 minute decay
        } else {
            RateLimiter::clear($key);
        }

        return $response;
    }
}
