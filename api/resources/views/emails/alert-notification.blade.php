<x-mail::message>
# {{ $notification->title }}

{{ $notification->body }}

@if($notification->data)
@php
$data = $notification->data;
@endphp

@if(isset($data['app_name']))
**App:** {{ $data['app_name'] }}
@endif

@if(isset($data['keyword']))
**Keyword:** {{ $data['keyword'] }}
@endif

@if(isset($data['old_position']) && isset($data['new_position']))
**Position:** {{ $data['old_position'] }} → {{ $data['new_position'] }}
@endif

@if(isset($data['change']))
**Change:** {{ $data['change'] > 0 ? '+' : '' }}{{ $data['change'] }}
@endif
@endif

<x-mail::button :url="$appUrl">
View in Keyrank
</x-mail::button>

---

You received this alert because you have email notifications enabled for {{ $notification->type }} alerts.

To manage your notification preferences, visit [Settings]({{ $appUrl }}/settings).

Thanks,<br>
{{ config('app.name') }}
</x-mail::message>
