@props(['url'])
<tr>
<td class="header">
<a href="{{ $url }}" style="display: inline-flex; align-items: center; gap: 10px; text-decoration: none;">
<img src="{{ config('app.url') }}/images/logo.png" width="40" height="40" alt="{{ $slot }}" style="border-radius: 8px;">
<span style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 22px; font-weight: 700; color: #18181b; letter-spacing: -0.5px;">{{ $slot }}</span>
</a>
</td>
</tr>
