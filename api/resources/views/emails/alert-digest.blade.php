<x-mail::message>
# Your {{ ucfirst($period) }} Alert Digest

Hi {{ $user->name ?? 'there' }},

You have **{{ $count }}** alert{{ $count > 1 ? 's' : '' }} from the past {{ $period === 'weekly' ? 'week' : '24 hours' }}.

---

@foreach($groupedByType as $type => $typeNotifications)
## {{ ucfirst(str_replace('_', ' ', $type)) }} ({{ $typeNotifications->count() }})

@foreach($typeNotifications as $notification)
### {{ $notification->title }}
{{ $notification->body }}

@if($notification->data)
@php $data = $notification->data; @endphp
@if(isset($data['app_name']))
- **App:** {{ $data['app_name'] }}
@endif
@if(isset($data['keyword']))
- **Keyword:** {{ $data['keyword'] }}
@endif
@if(isset($data['old_position']) && isset($data['new_position']))
- **Position:** {{ $data['old_position'] }} → {{ $data['new_position'] }}
@endif
@endif

@endforeach

---

@endforeach

<x-mail::button :url="$appUrl . '/notifications'">
View All Notifications
</x-mail::button>

---

You received this digest because you have digest notifications enabled.

To manage your notification preferences, visit [Settings]({{ $appUrl }}/settings).

Thanks,<br>
{{ config('app.name') }}
</x-mail::message>
