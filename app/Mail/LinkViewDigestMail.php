<?php

namespace App\Mail;

use App\Models\User;
use App\Services\EmailTemplateService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Collection;

class LinkViewDigestMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public string $renderedSubject;
    public string $renderedHtml;
    public string $renderedText;

    public function __construct(
        public readonly User       $user,
        public readonly Collection $linkStats,
        public readonly \Carbon\Carbon $weekStart,
        public readonly \Carbon\Carbon $weekEnd,
    ) {
        $this->buildContent();
    }

    public function envelope(): Envelope
    {
        return new Envelope(subject: $this->renderedSubject);
    }

    public function content(): Content
    {
        return new Content(
            htmlString: $this->renderedHtml,
            textString: $this->renderedText,
        );
    }

    private function buildContent(): void
    {
        $totalViews = $this->linkStats->sum('view_count');

        // Build the {{link_rows}} replacement
        $htmlRows = $this->linkStats->map(function ($stat) {
            $url      = url('/share/' . $stat->token);
            $countries = $stat->countries
                ? implode(', ', array_filter(explode(',', $stat->countries)))
                : '—';

            return "<tr>
                <td><a href=\"{$url}\">{$url}</a></td>
                <td>{$stat->view_count}</td>
                <td>{$countries}</td>
            </tr>";
        })->join("\n");

        $htmlLinkRows = <<<HTML
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%">
    <thead>
        <tr><th>Link</th><th>Views</th><th>Top Countries</th></tr>
    </thead>
    <tbody>
        {$htmlRows}
    </tbody>
</table>
HTML;

        $textRows = $this->linkStats->map(function ($stat) {
            return url('/share/' . $stat->token) . " — {$stat->view_count} views";
        })->join("\n");

        $variables = [
            '{{user_name}}'  => $this->user->name,
            '{{app_name}}'   => config('app.name'),
            '{{week_start}}' => $this->weekStart->toFormattedDateString(),
            '{{week_end}}'   => $this->weekEnd->toFormattedDateString(),
            '{{total_views}}'=> (string) $totalViews,
            '{{link_rows}}'  => $htmlLinkRows,
        ];

        $textVariables = array_merge($variables, ['{{link_rows}}' => $textRows]);

        $service  = app(EmailTemplateService::class);
        $rendered = $service->render($this->user, 'digest', $variables);

        if ($rendered) {
            $this->renderedSubject = $rendered['subject'];
            $this->renderedHtml    = $rendered['html_body'];
            $this->renderedText    = str_replace(
                array_keys($textVariables),
                array_values($textVariables),
                $rendered['text_body']
            );
        } else {
            // Hard fallback — no template found
            $this->renderedSubject = config('app.name') . ' — Weekly digest';
            $this->renderedHtml    = "<p>Hi {$this->user->name}, here is your weekly digest.</p>{$htmlLinkRows}";
            $this->renderedText    = "Hi {$this->user->name}, weekly digest:\n\n{$textRows}";
        }
    }
}