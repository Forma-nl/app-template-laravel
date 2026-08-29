<?php

use Illuminate\Support\Facades\Schedule;

// Everything scheduled here is run by the scheduler process the chart starts;
// there is no crontab on the node to keep in sync.
Schedule::command('queue:prune-batches --hours=48')->daily();
