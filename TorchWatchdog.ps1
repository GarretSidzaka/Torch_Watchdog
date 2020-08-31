Write-host "Starting Watchdog..."
	# Get a list of non-responding processes
	$testps = Get-Process
    $testht = @{}
    foreach($p in $testps) {
        $o = new-object psobject -Property @{ "name"=$p.name; "path"=$p.path; "status"=$p.responding; "time"=get-date; "pid"=$p.id }
        $testht.Add($o.path, $o)
    }
    Write-Output @testht | Select-Object
    Write-Host " "
    Read-Host -Prompt "Press Enter to start loop."
while($true){

    Write-Host "Checking for non-responding process."
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

    Write-Host "Beginning delay to see if process stays in degraded state."
    Write-Host " "
for ($i = 1; $i -le 5; $i++ )
{
    Write-Progress -Activity "Waiting to recheck process, press control-C to cancel" -PercentComplete $i;
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
    start-sleep -s 5
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
				start-sleep -s 15
				$p.kill()
				Write-Host "Starting up $p.path"
				Write-Host "Please type control-C to cancel server startup and end script."
				start-sleep -s 15			
				start-process $p.path
            }
        }
    }
}
Read-Host -Prompt "Press Enter to exit"
