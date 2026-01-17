<?php

namespace App\Http\Middleware;

use App\Models\App;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserOwnsApp
{
    public function handle(Request $request, Closure $next): Response
    {
        $appParam = $request->route('app') ?? $request->route('id');

        if ($appParam) {
            // In Laravel 12, route model binding resolves before middleware
            // So $appParam might already be an App model
            if ($appParam instanceof App) {
                $app = $appParam;
            } else {
                $app = App::find($appParam);
            }

            if (!$app) {
                return response()->json(['message' => 'App not found'], 404);
            }

            // Check if user's team has access to this app via pivot table
            $team = $request->user()->currentTeam;
            if (!$team || !$app->teams()->where('teams.id', $team->id)->exists()) {
                return response()->json(['message' => 'Unauthorized'], 403);
            }

            // Make app available to controller
            $request->merge(['validated_app' => $app]);
        }

        return $next($request);
    }
}
