Write-host Starting Watchdog...
Write-host Press control-C to cancel startup.
start-sleep -seconds -5
while($true){
    Write-Host "Checking for non-responding process."
	# Get a list of non-responding processes
    $ps = get-process | ?  { $_.responding -eq $false }
    $ht = @{}
    Write-Host "Problematic processes are $ps"
    # Store process info in a hash table.
    foreach($p in $ps) {
        $o = new-object psobject -Property @{ "name"=$p.name; "path"=$p.path; "status"=$p.responding; "time"=get-date; "pid"=$p.id }
        $ht.Add($o.pid, $o)
    }

    # sleep for a while
	Write-Host "Please type control-C to cancel process validation and end script."
    start-sleep -minutes 3

    # Get a list of non-responding processes, again
    $ps = get-process | ?  { $_.responding -eq $false }

    foreach($p in $ps) {
        # Check if process already is in the hash table
        if($ht.ContainsKey($p.id)) {
            # Calculate time difference, in minutes for 
            # process' start time and current time
            # If start time's older than 3 minutes, kill it
            if( ((get-date)-$ht[$p.id].Time).TotalMinutes -ge 3 ) {
                # Actuall killing
                Write-Host "Killing Process: $p.name"
				Write-Host "Please type control-C to cancel killing process"
				start-sleep -seconds 15
				$p.kill()
				Write-Host "Starting up $p.path"
				Write-Host "Please type control-C to cancel server startup and end script."
				start-sleep -seconds 15			
				start-process $p.path
            }
        }
    }
}
