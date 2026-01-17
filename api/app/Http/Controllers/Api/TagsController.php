<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Concerns\AuthorizesTeamActions;
use App\Models\Tag;
use App\Models\TrackedKeyword;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Validation\Rule;

class TagsController extends Controller
{
    use AuthorizesTeamActions;

    public function index(Request $request): JsonResponse
    {
        $team = $this->currentTeam();

        $tags = Tag::where('team_id', $team->id)
            ->orderBy('name')
            ->get();

        return response()->json(['data' => $tags]);
    }

    public function store(Request $request): JsonResponse
    {
        $this->authorizeTeamAction('manage_tags');

        $team = $this->currentTeam();

        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:50',
                Rule::unique('tags')->where('team_id', $team->id),
            ],
            'color' => 'nullable|string|regex:/^#[0-9a-fA-F]{6}$/',
        ]);

        $tag = Tag::create([
            'team_id' => $team->id,
            'name' => $validated['name'],
            'color' => $validated['color'] ?? '#6366f1',
        ]);

        return response()->json(['data' => $tag], 201);
    }

    public function destroy(Request $request, Tag $tag): Response
    {
        $this->authorizeTeamAction('manage_tags');

        $team = $this->currentTeam();

        if ($tag->team_id !== $team->id) {
            abort(403);
        }

        $tag->delete();

        return response()->noContent();
    }

    public function addToKeyword(Request $request): JsonResponse
    {
        $this->authorizeTeamAction('manage_keywords');

        $validated = $request->validate([
            'tag_id' => 'required|exists:tags,id',
            'tracked_keyword_id' => 'required|exists:tracked_keywords,id',
        ]);

        $team = $this->currentTeam();
        $tag = Tag::findOrFail($validated['tag_id']);
        $tracked = TrackedKeyword::findOrFail($validated['tracked_keyword_id']);

        // Verify ownership
        if ($tag->team_id !== $team->id || $tracked->team_id !== $team->id) {
            abort(403);
        }

        $tracked->tags()->syncWithoutDetaching([$tag->id]);

        return response()->json([
            'data' => $tracked->load('tags'),
        ]);
    }

    public function removeFromKeyword(Request $request): JsonResponse
    {
        $this->authorizeTeamAction('manage_keywords');

        $validated = $request->validate([
            'tag_id' => 'required|exists:tags,id',
            'tracked_keyword_id' => 'required|exists:tracked_keywords,id',
        ]);

        $team = $this->currentTeam();
        $tag = Tag::findOrFail($validated['tag_id']);
        $tracked = TrackedKeyword::findOrFail($validated['tracked_keyword_id']);

        // Verify ownership
        if ($tag->team_id !== $team->id || $tracked->team_id !== $team->id) {
            abort(403);
        }

        $tracked->tags()->detach($tag->id);

        return response()->json([
            'data' => $tracked->load('tags'),
        ]);
    }
}
