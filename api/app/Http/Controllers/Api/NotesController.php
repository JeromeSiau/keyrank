<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Note;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class NotesController extends Controller
{
    /**
     * Get or create note for a tracked keyword
     */
    public function forKeyword(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'tracked_keyword_id' => 'required|exists:tracked_keywords,id',
        ]);

        $note = Note::firstOrNew([
            'user_id' => $request->user()->id,
            'tracked_keyword_id' => $validated['tracked_keyword_id'],
        ]);

        return response()->json(['data' => $note->exists ? $note : null]);
    }

    /**
     * Get or create note for an insight
     */
    public function forInsight(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'app_insight_id' => 'required|exists:app_insights,id',
        ]);

        $note = Note::firstOrNew([
            'user_id' => $request->user()->id,
            'app_insight_id' => $validated['app_insight_id'],
        ]);

        return response()->json(['data' => $note->exists ? $note : null]);
    }

    /**
     * Create or update a note
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'tracked_keyword_id' => 'nullable|exists:tracked_keywords,id',
            'app_insight_id' => 'nullable|exists:app_insights,id',
            'content' => 'required|string|max:5000',
        ]);

        // Must have exactly one of tracked_keyword_id or app_insight_id
        if (empty($validated['tracked_keyword_id']) && empty($validated['app_insight_id'])) {
            abort(422, 'Either tracked_keyword_id or app_insight_id is required');
        }
        if (!empty($validated['tracked_keyword_id']) && !empty($validated['app_insight_id'])) {
            abort(422, 'Cannot set both tracked_keyword_id and app_insight_id');
        }

        $user = $request->user();

        // Upsert the note
        $note = Note::updateOrCreate(
            [
                'user_id' => $user->id,
                'tracked_keyword_id' => $validated['tracked_keyword_id'] ?? null,
                'app_insight_id' => $validated['app_insight_id'] ?? null,
            ],
            [
                'content' => $validated['content'],
            ]
        );

        return response()->json(['data' => $note], $note->wasRecentlyCreated ? 201 : 200);
    }

    /**
     * Delete a note
     */
    public function destroy(Request $request, Note $note): Response
    {
        if ($note->user_id !== $request->user()->id) {
            abort(403);
        }

        $note->delete();

        return response()->noContent();
    }
}
