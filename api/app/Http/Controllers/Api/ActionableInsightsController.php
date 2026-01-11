<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ActionableInsight;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ActionableInsightsController extends Controller
{
    /**
     * List insights for the current user
     */
    public function index(Request $request): JsonResponse
    {
        $user = Auth::user();

        $query = ActionableInsight::forUser($user->id)
            ->active()
            ->with('app:id,name,icon_url,platform')
            ->orderByRaw("FIELD(priority, 'high', 'medium', 'low')")
            ->orderByDesc('generated_at');

        // Filter by type
        if ($request->has('type')) {
            $query->ofType($request->input('type'));
        }

        // Filter by app
        if ($request->has('app_id')) {
            $query->forApp($request->input('app_id'));
        }

        // Filter by read status
        if ($request->has('unread') && $request->boolean('unread')) {
            $query->unread();
        }

        // Filter by priority
        if ($request->has('priority')) {
            $query->where('priority', $request->input('priority'));
        }

        $insights = $query->paginate($request->input('per_page', 20));

        return response()->json([
            'data' => $insights->map(fn($i) => $this->formatInsight($i)),
            'meta' => [
                'current_page' => $insights->currentPage(),
                'last_page' => $insights->lastPage(),
                'per_page' => $insights->perPage(),
                'total' => $insights->total(),
            ],
        ]);
    }

    /**
     * Get a single insight
     */
    public function show(ActionableInsight $insight): JsonResponse
    {
        $user = Auth::user();

        if ($insight->user_id !== $user->id) {
            return response()->json(['error' => 'Insight not found.'], 404);
        }

        $insight->load('app:id,name,icon_url,platform');

        return response()->json([
            'data' => $this->formatInsight($insight),
        ]);
    }

    /**
     * Mark insight as read
     */
    public function markAsRead(ActionableInsight $insight): JsonResponse
    {
        $user = Auth::user();

        if ($insight->user_id !== $user->id) {
            return response()->json(['error' => 'Insight not found.'], 404);
        }

        $insight->markAsRead();

        return response()->json([
            'data' => $this->formatInsight($insight->fresh()),
        ]);
    }

    /**
     * Dismiss an insight
     */
    public function dismiss(ActionableInsight $insight): JsonResponse
    {
        $user = Auth::user();

        if ($insight->user_id !== $user->id) {
            return response()->json(['error' => 'Insight not found.'], 404);
        }

        $insight->dismiss();

        return response()->json(null, 204);
    }

    /**
     * Mark all insights as read
     */
    public function markAllAsRead(Request $request): JsonResponse
    {
        $user = Auth::user();

        $query = ActionableInsight::forUser($user->id)
            ->unread();

        if ($request->has('app_id')) {
            $query->forApp($request->input('app_id'));
        }

        $count = $query->update(['is_read' => true]);

        return response()->json([
            'data' => [
                'marked_count' => $count,
            ],
        ]);
    }

    /**
     * Get unread count
     */
    public function unreadCount(Request $request): JsonResponse
    {
        $user = Auth::user();

        $query = ActionableInsight::forUser($user->id)
            ->active()
            ->unread();

        if ($request->has('app_id')) {
            $query->forApp($request->input('app_id'));
        }

        $total = $query->count();
        $highPriority = (clone $query)->highPriority()->count();

        return response()->json([
            'data' => [
                'total' => $total,
                'high_priority' => $highPriority,
            ],
        ]);
    }

    /**
     * Get insights summary for dashboard
     */
    public function summary(): JsonResponse
    {
        $user = Auth::user();

        $insights = ActionableInsight::forUser($user->id)
            ->active()
            ->recent(7)
            ->with('app:id,name,icon_url,platform')
            ->orderByRaw("FIELD(priority, 'high', 'medium', 'low')")
            ->orderByDesc('generated_at')
            ->limit(5)
            ->get();

        $unreadCount = ActionableInsight::forUser($user->id)
            ->active()
            ->unread()
            ->count();

        $byType = ActionableInsight::forUser($user->id)
            ->active()
            ->recent(7)
            ->selectRaw('type, count(*) as count')
            ->groupBy('type')
            ->pluck('count', 'type')
            ->toArray();

        return response()->json([
            'data' => [
                'insights' => $insights->map(fn($i) => $this->formatInsight($i)),
                'unread_count' => $unreadCount,
                'by_type' => $byType,
            ],
        ]);
    }

    private function formatInsight(ActionableInsight $insight): array
    {
        return [
            'id' => $insight->id,
            'type' => $insight->type,
            'priority' => $insight->priority,
            'title' => $insight->title,
            'description' => $insight->description,
            'action_text' => $insight->action_text,
            'action_url' => $insight->action_url,
            'data_refs' => $insight->data_refs,
            'is_read' => $insight->is_read,
            'is_dismissed' => $insight->is_dismissed,
            'generated_at' => $insight->generated_at->toIso8601String(),
            'expires_at' => $insight->expires_at?->toIso8601String(),
            'app' => $insight->app ? [
                'id' => $insight->app->id,
                'name' => $insight->app->name,
                'icon_url' => $insight->app->icon_url,
                'platform' => $insight->app->platform,
            ] : null,
        ];
    }
}
