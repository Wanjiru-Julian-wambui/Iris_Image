<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>You're invited to Iris</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #f4f4f5;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            color: #18181b;
        }
        .wrapper {
            max-width: 560px;
            margin: 40px auto;
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
        }
        .header {
            background: linear-gradient(135deg, #7B2FFF 0%, #00E5FF 100%);
            padding: 40px 40px 32px;
            text-align: center;
        }
        .header img {
            width: 64px;
            height: 64px;
            object-fit: contain;
        }
        .header h1 {
            margin: 16px 0 0;
            color: #ffffff;
            font-size: 24px;
            font-weight: 700;
            letter-spacing: -0.3px;
        }
        .body {
            padding: 40px;
        }
        .body p {
            margin: 0 0 16px;
            font-size: 15px;
            line-height: 1.7;
            color: #3f3f46;
        }
        .body p strong {
            color: #18181b;
        }
        .btn-wrap {
            text-align: center;
            margin: 32px 0;
        }
        .btn {
            display: inline-block;
            padding: 14px 32px;
            background: linear-gradient(135deg, #7B2FFF 0%, #00E5FF 100%);
            color: #ffffff !important;
            text-decoration: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            letter-spacing: 0.1px;
        }
        .url-fallback {
            margin-top: 24px;
            font-size: 13px;
            color: #71717a;
            word-break: break-all;
        }
        .url-fallback a {
            color: #7B2FFF;
        }
        .expiry {
            background: #fafafa;
            border: 1px solid #e4e4e7;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 13px;
            color: #71717a;
            margin-top: 8px;
        }
        .footer {
            border-top: 1px solid #f4f4f5;
            padding: 24px 40px;
            text-align: center;
            font-size: 12px;
            color: #a1a1aa;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="header">
            <img src="{{ url('/favicon.png') }}" alt="Iris" />
            <h1>You're invited to Iris</h1>
        </div>

        <div class="body">
            <p>
                <strong>{{ $invitedBy }}</strong> has invited you to join
                <strong>Iris</strong> — a powerful image platform for teams.
            </p>

            <p>
                Click the button below to create your account and get started.
            </p>

            <div class="btn-wrap">
                <a href="{{ $inviteUrl }}" class="btn">Accept Invitation</a>
            </div>

            <div class="expiry">
                ⏳ This invitation expires on <strong>{{ $expiresAt }}</strong>.
            </div>

            <p class="url-fallback">
                If the button doesn't work, copy and paste this link into your browser:<br/>
                <a href="{{ $inviteUrl }}">{{ $inviteUrl }}</a>
            </p>
        </div>

        <div class="footer">
            If you weren't expecting this invitation, you can safely ignore this email.<br/>
            &copy; {{ date('Y') }} Iris. All rights reserved.
        </div>
    </div>
</body>
</html>