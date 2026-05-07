<?php

namespace App\Services;

use App\Models\EmailTemplate;
use App\Models\User;

class EmailTemplateService
{
    /**
     * Render a template for a given user and key.
     * Falls back to the system-default template if the user has no override.
     *
     * @param  User|int $user
     * @param  string   $key       e.g. 'invite', 'digest', 'quota_warning'
     * @param  array    $variables e.g. ['{{user_name}}' => 'Alice', ...]
     * @return array{ subject: string, html_body: string, text_body: string }|null
     */
    public function render(User|int $user, string $key, array $variables): ?array
    {
        $userId   = $user instanceof User ? $user->id : $user;
        $template = EmailTemplate::forUser($userId, $key);

        if (! $template) {
            return null;
        }

        return $template->render($variables);
    }

    /**
     * List of all supported template keys.
     */
    public function availableKeys(): array
    {
        return array_keys(EmailTemplate::TEMPLATES);
    }

    /**
     * Variables available for a given key.
     */
    public function variablesFor(string $key): array
    {
        return EmailTemplate::TEMPLATES[$key] ?? [];
    }

    /**
     * Seed system-default templates (called from a seeder or migration).
     */
    public function seedDefaults(): void
    {
        $defaults = [
            'invite' => [
                'subject'   => 'You\'ve been invited to {{app_name}}',
                'html_body' => <<<HTML
<p>Hi {{user_name}},</p>
<p>You've been invited to join <strong>{{app_name}}</strong>.</p>
<p><a href="{{invite_url}}">Accept Invitation</a> — expires in {{expires_in}}.</p>
HTML,
                'text_body' => "Hi {{user_name}},\n\nYou've been invited to join {{app_name}}.\n\nAccept: {{invite_url}}\nExpires in: {{expires_in}}",
            ],
            'digest' => [
                'subject'   => '{{app_name}} — Weekly link digest ({{week_start}} to {{week_end}})',
                'html_body' => <<<HTML
<p>Hi {{user_name}},</p>
<p>Here's your weekly summary of shared link activity from <strong>{{week_start}}</strong> to <strong>{{week_end}}</strong>.</p>
<p>Total views this week: <strong>{{total_views}}</strong></p>
{{link_rows}}
<p>— The {{app_name}} Team</p>
HTML,
                'text_body' => "Hi {{user_name}},\n\nWeekly link digest ({{week_start}} to {{week_end}})\nTotal views: {{total_views}}\n\n{{link_rows}}",
            ],
            'quota_warning' => [
                'subject'   => '{{app_name}} — Storage at {{used_percent}}%',
                'html_body' => <<<HTML
<p>Hi {{user_name}},</p>
<p>You've used <strong>{{used_human}}</strong> of your <strong>{{limit_human}}</strong> storage quota ({{used_percent}}%).</p>
<p><a href="{{upgrade_url}}">Upgrade your plan</a> to get more space.</p>
HTML,
                'text_body' => "Hi {{user_name}},\n\nYou've used {{used_human}} of {{limit_human}} ({{used_percent}}%).\nUpgrade: {{upgrade_url}}",
            ],
        ];

        foreach ($defaults as $key => $data) {
            EmailTemplate::firstOrCreate(
                ['key' => $key, 'user_id' => null],
                $data
            );
        }
    }
}