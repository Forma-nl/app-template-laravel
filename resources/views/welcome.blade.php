<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ config('app.name') }}</title>
    <style>
        body { font: 16px/1.6 system-ui, sans-serif; margin: 0; display: grid; place-items: center; min-height: 100vh; background: #F4F5F6; color: #1B202B; }
        main { text-align: center; }
        code { background: #fff; border: 1px solid #E4E6E9; border-radius: 6px; padding: 2px 6px; }
    </style>
</head>
<body>
<main>
    <h1>{{ config('app.name') }}</h1>
    <p>Running on CloudApps in the <b>{{ app()->environment() }}</b> environment.</p>
    <p>Push to this branch and it deploys. Health is at <code>/up</code>.</p>
</main>
</body>
</html>
