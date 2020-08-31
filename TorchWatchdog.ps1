# Get a list of non-responding processes
function Get-Funky{
    param([string]$Text)

    # Use a random colour for each character
    $Text.ToCharArray() | ForEach-Object{
        switch -Regex ($_){
            # Ignore new line characters
            "`r"{
                break
            }
            # Start a new line
            "`n"{
                Write-Host " ";break
            }
            # Use random colours for displaying this non-space character
            "[^ ]"{
                # Splat the colours to write-host
                $writeHostOptions = @{
                    ForegroundColor = ([system.enum]::GetValues([system.consolecolor])) | get-random
                    # BackgroundColor = ([system.enum]::GetValues([system.consolecolor])) | get-random
                    NoNewLine = $true
                }
                Write-Host $_ @writeHostOptions
                break
            }
            " "{Write-Host " " -NoNewline}

        } 
    }
}
$testps = Get-Process
$testht = @{}
foreach($p in $testps) {
    $o = new-object psobject -Property @{ "name"=$p.name; "path"=$p.path; "status"=$p.responding; "time"=get-date; "pid"=$p.id }
    $testht.Add($o.path, $o)
}
Write-Output @testht
$text = @"
  _____           _     __      __    _      _       _           
 |_   _|__ _ _ __| |_   \ \    / /_ _| |_ __| |_  __| |___  __ _ 
   | |/ _ \ '_/ _| ' \   \ \/\/ / _\ |  _/ _| ' \/ _\ / _ \/ _\ |
   |_|\___/_| \__|_||_|   \_/\_/\__,_|\__\__|_||_\__,_\___/\__, |
                                                           |___/ 
"@  
Get-Funky $text
Write-host " "
Write-Host "Author: GarretSidzaka https://expanse.2enp.comparison"
Write-Host "Special Thanks: Princess Kenny and vonPryz (stack exchange)"
Write-host "Starting Torch Watchdog..."
Write-Host " "
start-sleep -s 2
while($true){
    Write-Host "Starting at top of loop"
    Write-Host "Checking for non-responding processes."
    start-sleep -s 2
    Write-Host " "
    $ps = get-process | ?  { $_.responding -eq $false }
    $ht = @{}

    if ( $ps -eq $null ) {
        Write-Host "Good news! No problematic processes found."
        Write-Host "Beginning 30 second delay before checking again."
        Write-Host " "
        for ($a=0; $a -le 30; $a++) {
            Write-Host -NoNewLine "`r0$a"
            Start-Sleep -Seconds 1
        }
    Write-Host " "
    }
    Else {
        Write-Host "Problematic processes are $ps"
        Write-Host " "
        # Store process info in a hash table.
        foreach($p in $ps) {
            #Write-host $p
            $o = new-object psobject -Property @{ "name"=$p.name; "path"=$p.path; "status"=$p.responding; "time"=get-date; "pid"=$p.id }
            $ht.Add($o.pid, $o)
            #Write-host $o
        }
	    
        # sleep for a while
	    
        Write-Host "Beginning 150 second delay period to see if any processes stay in the degraded state."
        Write-Host " "
        for ($a=0; $a -le 150; $a++) {
            Write-Host -NoNewLine "`r0$a"
            Start-Sleep -Seconds 1
        }
        Write-Host " "
	    
        # Get a list of non-responding processes, again
        $ps = get-process | ?  { $_.responding -eq $false }
	    
        if ( $ps -eq $null ) {
            Write-Host "Good news! There are no longer problematic processes to be found."
            Write-Host " "
        }
        else {
            Write-Host "Processes that continue to be problematic and should be stopped are $ps"
            Write-Host " "
        
            start-sleep -s 2
		    
            #Write-Host $ps
            #Read-Host -Prompt "Press Enter to continue"
            foreach($p in $ps) {
                # Check if process already is in the hash table
                #Write-Host $ht[$p.id]	
                #Write-Host $p.id	
                #Write-Host $p.path
                Write-Host "About to start the comparison"	
                #Read-Host -Prompt "Press Enter to continue"
				
                if($ht.ContainsKey($p.id)) {
					$runpath=$p.path
					#Write-Host $runpath
                    $cleanpath = $runpath.replace("\","\\").replace('"',"")
                    #Write-Host $cleanpath
                    Write-Host "Comparison matched process id"				
                    # Actual killing
                    Write-host $p.path
                    #Write-host $ps
                    Write-Host "Cancel with control-C, otherwise I'm killing Process: $ps"
                    Start-Sleep -Seconds 5
                    Write-Host " "
	        		$p.kill()
                    Write-host "Cancel with control-C, otherwise I'm starting up: $ps"
                    Start-Sleep -Seconds 5
                    Write-Host " "
	        		start-process $cleanpath
                    #Read-Host -Prompt "Press Enter to continue"
                }
            }
        }
    }
}

Read-Host -Prompt "Press Enter to exit"
