<?php

return [
    'project_id' => env('FCM_PROJECT_ID'),
    'credentials' => env('FCM_CREDENTIALS', storage_path('app/firebase-credentials.json')),
];
