<?php

namespace App\Http\Controllers\Concerns;

use Illuminate\Http\JsonResponse;

/**
 * Trait for consistent API response formatting
 */
trait ApiResponse
{
    /**
     * Return a successful response with data
     */
    protected function success(mixed $data = null, int $status = 200): JsonResponse
    {
        return response()->json(['data' => $data], $status);
    }

    /**
     * Return a successful response with paginated data
     */
    protected function paginated($paginator): JsonResponse
    {
        return response()->json([
            'data' => $paginator->items(),
            'meta' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ],
        ]);
    }

    /**
     * Return a created response (201)
     */
    protected function created(mixed $data = null): JsonResponse
    {
        return $this->success($data, 201);
    }

    /**
     * Return an error response
     */
    protected function error(string $message, int $status = 400, array $errors = []): JsonResponse
    {
        $response = ['error' => $message];

        if (!empty($errors)) {
            $response['errors'] = $errors;
        }

        return response()->json($response, $status);
    }

    /**
     * Return a not found error
     */
    protected function notFound(string $message = 'Resource not found.'): JsonResponse
    {
        return $this->error($message, 404);
    }

    /**
     * Return an unauthorized error
     */
    protected function unauthorized(string $message = 'Unauthorized.'): JsonResponse
    {
        return $this->error($message, 401);
    }

    /**
     * Return a forbidden error
     */
    protected function forbidden(string $message = 'Forbidden.'): JsonResponse
    {
        return $this->error($message, 403);
    }

    /**
     * Return a validation error
     */
    protected function validationError(array $errors, string $message = 'Validation failed.'): JsonResponse
    {
        return $this->error($message, 422, $errors);
    }

    /**
     * Return a no content response (204)
     */
    protected function noContent(): JsonResponse
    {
        return response()->json(null, 204);
    }
}
