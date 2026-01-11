<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppVoiceSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VoiceSettingsController extends Controller
{
    public function show(App $app): JsonResponse
    {
        $settings = $app->getVoiceSettingForUser(Auth::id());

        return response()->json([
            'data' => $settings ? [
                'tone_description' => $settings->tone_description,
                'default_language' => $settings->default_language,
                'signature' => $settings->signature,
            ] : null,
        ]);
    }

    public function update(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'tone_description' => 'nullable|string|max:500',
            'default_language' => 'nullable|string|max:10',
            'signature' => 'nullable|string|max:100',
        ]);

        // Only include fields that were actually present in the request
        $updateData = array_intersect_key(
            $validated,
            array_flip(['tone_description', 'default_language', 'signature'])
        );

        $settings = AppVoiceSetting::updateOrCreate(
            ['app_id' => $app->id, 'user_id' => Auth::id()],
            $updateData
        );

        return response()->json([
            'data' => [
                'tone_description' => $settings->tone_description,
                'default_language' => $settings->default_language,
                'signature' => $settings->signature,
            ],
        ]);
    }
}
