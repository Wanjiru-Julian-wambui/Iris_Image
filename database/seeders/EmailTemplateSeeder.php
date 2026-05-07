<?php

namespace Database\Seeders;

use App\Services\EmailTemplateService;
use Illuminate\Database\Seeder;

class EmailTemplateSeeder extends Seeder
{
    public function run(EmailTemplateService $service): void
    {
        $service->seedDefaults();

        $this->command->info('System email templates seeded.');
    }
}