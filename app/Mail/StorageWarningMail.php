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

class StorageWarningMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public string $renderedSubject;
    public string $renderedHtml;
    public string $renderedText;

    public function __construct(
        public readonly User  $user,
        public readonly int   $threshold,   // 70 or 90
        public readonly float $actualPercent,
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
        $usedHuman  = $this->formatBytes($this->user->storage_used ?? 0);
        $limitHuman = $this->formatBytes($this->user->storage_limit ?? 0);

        $variables = [
            '{{user_name}}'    => $this->user->name,
            '{{app_name}}'     => config('app.name'),
            '{{used_percent}}' => (string) round($this->actualPercent, 1),
            '{{used_human}}'   => $usedHuman,
            '{{limit_human}}'  => $limitHuman,
            '{{upgrade_url}}'  => url('/plans'),
        ];

        $service  = app(EmailTemplateService::class);
        $rendered = $service->render($this->user, 'quota_warning', $variables);

        if ($rendered) {
            $this->renderedSubject = $rendered['subject'];
            $this->renderedHtml    = $rendered['html_body'];
            $this->renderedText    = $rendered['text_body'];
        } else {
            $this->renderedSubject = config('app.name') . " — Storage at {$this->threshold}%";
            $this->renderedHtml    = "<p>Hi {$this->user->name}, you've used {$usedHuman} of {$limitHuman}.</p>";
            $this->renderedText    = "Hi {$this->user->name}, you've used {$usedHuman} of {$limitHuman}.";
        }
    }

    private function formatBytes(int $bytes): string
    {
        if ($bytes === 0) return '0 B';
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        $i     = min((int) floor(log($bytes) / log(1024)), count($units) - 1);
        return round($bytes / pow(1024, $i), 2) . ' ' . $units[$i];
    }
}