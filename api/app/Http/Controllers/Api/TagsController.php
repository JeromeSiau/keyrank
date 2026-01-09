<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tag;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Validation\Rule;

class TagsController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $tags = Tag::where('user_id', $request->user()->id)
            ->orderBy('name')
            ->get();

        return response()->json(['data' => $tags]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:50',
                Rule::unique('tags')->where('user_id', $request->user()->id),
            ],
            'color' => 'nullable|string|regex:/^#[0-9a-fA-F]{6}$/',
        ]);

        $tag = Tag::create([
            'user_id' => $request->user()->id,
            'name' => $validated['name'],
            'color' => $validated['color'] ?? '#6366f1',
        ]);

        return response()->json(['data' => $tag], 201);
    }

    public function destroy(Request $request, Tag $tag): Response
    {
        if ($tag->user_id !== $request->user()->id) {
            abort(403);
        }

        $tag->delete();

        return response()->noContent();
    }
}
