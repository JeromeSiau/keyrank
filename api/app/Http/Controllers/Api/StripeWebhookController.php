<?php

namespace App\Http\Controllers\Api;

use Laravel\Cashier\Http\Controllers\WebhookController as CashierController;
use Illuminate\Support\Facades\Log;

class StripeWebhookController extends CashierController
{
    /**
     * Handle customer subscription created.
     */
    protected function handleCustomerSubscriptionCreated(array $payload): void
    {
        parent::handleCustomerSubscriptionCreated($payload);

        $subscription = $payload['data']['object'] ?? null;
        if ($subscription) {
            Log::info('Subscription created', [
                'customer_id' => $subscription['customer'],
                'subscription_id' => $subscription['id'],
                'status' => $subscription['status'],
            ]);
        }
    }

    /**
     * Handle customer subscription updated.
     */
    protected function handleCustomerSubscriptionUpdated(array $payload): void
    {
        parent::handleCustomerSubscriptionUpdated($payload);

        $subscription = $payload['data']['object'] ?? null;
        if ($subscription) {
            Log::info('Subscription updated', [
                'customer_id' => $subscription['customer'],
                'subscription_id' => $subscription['id'],
                'status' => $subscription['status'],
                'cancel_at_period_end' => $subscription['cancel_at_period_end'] ?? false,
            ]);
        }
    }

    /**
     * Handle customer subscription deleted.
     */
    protected function handleCustomerSubscriptionDeleted(array $payload): void
    {
        parent::handleCustomerSubscriptionDeleted($payload);

        $subscription = $payload['data']['object'] ?? null;
        if ($subscription) {
            Log::info('Subscription deleted', [
                'customer_id' => $subscription['customer'],
                'subscription_id' => $subscription['id'],
            ]);
        }
    }

    /**
     * Handle invoice payment succeeded.
     */
    protected function handleInvoicePaymentSucceeded(array $payload): void
    {
        $invoice = $payload['data']['object'] ?? null;
        if ($invoice) {
            Log::info('Invoice payment succeeded', [
                'customer_id' => $invoice['customer'],
                'invoice_id' => $invoice['id'],
                'amount_paid' => $invoice['amount_paid'] / 100,
                'currency' => $invoice['currency'],
            ]);
        }
    }

    /**
     * Handle invoice payment failed.
     */
    protected function handleInvoicePaymentFailed(array $payload): void
    {
        $invoice = $payload['data']['object'] ?? null;
        if ($invoice) {
            Log::warning('Invoice payment failed', [
                'customer_id' => $invoice['customer'],
                'invoice_id' => $invoice['id'],
                'attempt_count' => $invoice['attempt_count'] ?? 1,
            ]);

            // TODO: Send notification to user about failed payment
        }
    }
}
