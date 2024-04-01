
$FQDN = Read-Host -prompt 'Enter the FQDN'
$IP_address = Read-Host -prompt 'Enter the IP address'
$port_numner = Read-Host -prompt 'Enter the destination port number'
$Interval = Read-Host -prompt 'Enter the number of seconds between retries'
[int]$count = 0
$Filepath = Read-Host -prompt 'Enter the file path where you want to save the file'

Try {
	$pcappath = Read-Host -prompt 'Enter the file path where you want to save the pcap file'
	netsh trace start capture=yes tracefile=$pcappath.etl maxsize=500 filemode=circular report=no
        if($FQDN){
     		Get-TimeZone | Out-File $Filepath -Append
        	while($True){
			Test-NetConnection -ComputerName $FQDN -Port $port_numner | Out-File $Filepath -Append
        		"UTC TCP Ping Time $((get-date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffffff"))" | Out-File $Filepath -Append
        		Start-Sleep -Seconds $Interval
        		Write-Output $arg | Out-File $Filepath -Append
        		$count+=1
	        	$count_number = Write-Output "####################################################'TCP_PING_NUMBER = $count'################################################################"
        		$count_number | Out-File $Filepath -Append
	        	 }
          	}
 	elseif($IP_address){
    		Get-TimeZone | Out-File $Filepath -Append
		while($True){
			Test-NetConnection $IP_address -Port $port_numner
        		"UTC TCP Ping Time $((get-date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffffff"))"
        		Start-Sleep -Seconds $Interval
        		Write-Output $arg
        		$count+=1
        		$count_number = Write-Output "####################################################'TCP_PING_NUMBER = $count'################################################################"

        		$count_number | Out-File $Filepath -Append
	  	  	    }
		    	      }
	else{
		Write-Output "Something went wrong try again"
		Break
		}
   }

catch{
	Write-Host "Stopping the trace"

	}

finally{   
	   
	   $netsh_stop = netsh trace stop
	   $netsh_stop | Out-File $Filepath -Append	
	}
