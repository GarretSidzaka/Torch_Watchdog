Write-host "Starting Watchdog..."
    start-sleep -s 1
	# Get a list of non-responding processes
	$testps = Get-Process
    $testht = @{}
    foreach($p in $testps) {
        $o = new-object psobject -Property @{ "name"=$p.name; "path"=$p.path; "status"=$p.responding; "time"=get-date; "pid"=$p.id }
        $testht.Add($o.path, $o)
    }
    Write-Output @testht
    Write-Host " "
    Read-Host -Prompt "Press Enter to start loop"
while($true){
    Write-Host "Starting at top of loop"
    Write-Host "Checking for non-responding processes."
    start-sleep -s 2
    Write-Host " "
    $ps = get-process | ?  { $_.responding -eq $false }
    $ht = @{}
    Write-Host "Problematic processes are $ps"
    Write-Host " "
    if ( $ps -eq $null ) {
    Write-Host "...Good news! No problematic processes found."
    Write-Host " "
    }
    # Store process info in a hash table.
    foreach($p in $ps) {
        $o = new-object psobject -Property @{ "name"=$p.name; "path"=$p.path; "status"=$p.responding; "time"=get-date; "pid"=$p.id }
        $ht.Add($o.pid, $o)
    }

    # sleep for a while

    Write-Host "Beginning 3 minute delay period to see if any processes stay in the degraded state."
    Write-Host " "
for ($i = 180; $i -gt 0; $i-- )
{
    Write-Progress -Activity "Waiting to recheck process for 3 minutes, press control-C to cancel" -SecondsRemaining $i;
    start-sleep -s 1
}

    # Get a list of non-responding processes, again
    $ps = get-process | ?  { $_.responding -eq $false }
    Write-Host "Processes that continue to be problematic and should be stopped are $ps"
    Write-Host " "
    if ( $ps -eq $null ) {
    Write-Host "...Good news! Still no problematic processes found."
    Write-Host " "
    }
    start-sleep -s 2
    foreach($p in $ps) {
        # Check if process already is in the hash table
        if($ht.ContainsKey($p.id)) {
            # Calculate time difference, in minutes for 
            # process' start time and current time
            # If start time's older than 3 minutes, kill it
            if( ((get-date)-$ht[$p.id].Time).TotalMinutes -ge 3 ) {
                # Actuall killing
                Write-Host "Killing Process: $p.path"
                for ($i = 10; $i -gt 0; $i-- )
                 {
                     Write-Progress -Activity "Please type control-C to cancel killing process and end script." -SecondsRemaining $i;
                     start-sleep -s 1
                 }
				$p.kill()
                Write-host "Starting up: $p.path"
                for ($i = 10; $i -gt 0; $i-- )
                 {
                     Write-Progress -Activity "Starting up $p.path" -SecondsRemaining $i;
                     start-sleep -s 1
                 }		
				start-process $p.path
            }
        }
    }
}
Read-Host -Prompt "Press Enter to exit"
