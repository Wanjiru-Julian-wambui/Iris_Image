<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\EmailTemplate;
use App\Services\EmailTemplateService;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class EmailTemplateController extends Controller
{
    public function __construct(
        protected EmailTemplateService $templateService,
    ) {}

    public function index(): Response
    {
        $templates = EmailTemplate::whereNull('user_id')
            ->orderBy('key')
            ->get()
            ->keyBy('key');

        // Ensure all system templates exist
        $this->templateService->seedDefaults();

        $templates = EmailTemplate::whereNull('user_id')
            ->orderBy('key')
            ->get()
            ->map(fn($t) => [
                'id'        => $t->id,
                'key'       => $t->key,
                'subject'   => $t->subject,
                'html_body' => $t->html_body,
                'text_body' => $t->text_body,
                'variables' => $this->templateService->variablesFor($t->key),
            ]);

        return Inertia::render('Admin/EmailTemplates/Index', [
            'templates' => $templates,
        ]);
    }

    public function update(Request $request, EmailTemplate $emailTemplate): \Illuminate\Http\RedirectResponse
    {
        // Only system templates (no user_id) are editable here
        abort_unless($emailTemplate->user_id === null, 403);

        $data = $request->validate([
            'subject'   => ['required', 'string', 'max:255'],
            'html_body' => ['required', 'string'],
            'text_body' => ['required', 'string'],
        ]);

        $emailTemplate->update($data);

        return back()->with('success', ucfirst($emailTemplate->key) . ' template saved.');
    }

    public function preview(Request $request, EmailTemplate $emailTemplate): \Illuminate\Http\Response
    {
        abort_unless($emailTemplate->user_id === null, 403);

        // Render with dummy variable values so admin can preview layout
        $dummyVars = collect($this->templateService->variablesFor($emailTemplate->key))
            ->mapWithKeys(fn($v) => [$v => ltrim(rtrim($v, '}}'), '{{')])
            ->toArray();

        $rendered = $emailTemplate->render($dummyVars);

        return response($rendered['html_body'])->header('Content-Type', 'text/html');
    }

    public function reset(EmailTemplate $emailTemplate): \Illuminate\Http\RedirectResponse
    {
        abort_unless($emailTemplate->user_id === null, 403);

        // Re-seed just this template
        $defaults = [
            'invite' => [
                'subject'   => 'You\'ve been invited to {{app_name}}',
                'html_body' => "<p>Hi {{user_name}},</p>\n<p>You've been invited to join <strong>{{app_name}}</strong>.</p>\n<p><a href=\"{{invite_url}}\">Accept Invitation</a> — expires in {{expires_in}}.</p>",
                'text_body' => "Hi {{user_name}},\n\nYou've been invited to join {{app_name}}.\n\nAccept: {{invite_url}}\nExpires in: {{expires_in}}",
            ],
            'digest' => [
                'subject'   => '{{app_name}} — Weekly link digest ({{week_start}} to {{week_end}})',
                'html_body' => "<p>Hi {{user_name}},</p>\n<p>Here's your weekly summary from <strong>{{week_start}}</strong> to <strong>{{week_end}}</strong>.</p>\n<p>Total views: <strong>{{total_views}}</strong></p>\n{{link_rows}}\n<p>— The {{app_name}} Team</p>",
                'text_body' => "Hi {{user_name}},\n\nWeekly digest ({{week_start}} to {{week_end}})\nTotal views: {{total_views}}\n\n{{link_rows}}",
            ],
            'quota_warning' => [
                'subject'   => '{{app_name}} — Storage at {{used_percent}}%',
                'html_body' => "<p>Hi {{user_name}},</p>\n<p>You've used <strong>{{used_human}}</strong> of your <strong>{{limit_human}}</strong> storage quota ({{used_percent}}%).</p>\n<p><a href=\"{{upgrade_url}}\">Upgrade your plan</a> to get more space.</p>",
                'text_body' => "Hi {{user_name}},\n\nYou've used {{used_human}} of {{limit_human}} ({{used_percent}}%).\nUpgrade: {{upgrade_url}}",
            ],
        ];

        if (isset($defaults[$emailTemplate->key])) {
            $emailTemplate->update($defaults[$emailTemplate->key]);
        }

        return back()->with('success', ucfirst($emailTemplate->key) . ' template reset to default.');
    }
}