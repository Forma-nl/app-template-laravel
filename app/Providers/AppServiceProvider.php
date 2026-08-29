<?php

namespace App\Providers;

use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        // TLS terminates at the ingress, so the application sees plain HTTP and
        // would otherwise generate http:// links on an https:// site.
        if ($this->app->environment('production')) {
            URL::forceScheme('https');
        }
    }
}
