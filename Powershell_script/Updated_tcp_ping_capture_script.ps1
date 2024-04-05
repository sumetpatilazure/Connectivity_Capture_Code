# Get all the required information from the user
$FQDN = Read-Host -prompt 'Enter the FQDN. Skip if you don't know the FQDN and know the IP address'
$IP_address = Read-Host -prompt 'Enter the IP address'
$port_numner = Read-Host -prompt 'Enter the destination port number'
$Interval = Read-Host -prompt 'Enter the number of seconds between retries'
[int]$count = 0
$Filepath = Read-Host -prompt 'Enter the file path where you want to save the file'

# Run try and catch to handle the exceptions gracefully when the script is stopped
Try {	
	# File name to capture the sessions
	$pcappath = Read-Host -prompt 'Enter the file path where you want to save the pcap file'
	# Capturing the sessions starts here 													
	netsh trace start capture=yes tracefile=$pcappath.etl maxsize=500 filemode=circular report=no													
        if($FQDN){
		
     		Get-TimeZone | Out-File $Filepath -Append
		# Loop with conditions to run the TCP connections																		
        	while($True){
			Test-NetConnection -ComputerName $FQDN -Port $port_numner | Out-File $Filepath -Append	
			# capturing the time in the UTC format											
        		"UTC TCP Ping Time $((get-date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss:ffffff"))" | Out-File $Filepath -Append
        		Start-Sleep -Seconds $Interval
			# Appending the output to the file
        		Write-Output $arg | Out-File $Filepath -Append
			# Counting the number of the sessions																	
        		$count+=1																					
	        	$count_number = Write-Output "####################################################'TCP_PING_NUMBER = $count'################################################################"
        		$count_number | Out-File $Filepath -Append
	        	 }
          	}
 	elseif($IP_address){	
		# Repeating the above if IP address is entered instead of FQDN																					
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
	   # stopping the capture
	   $netsh_stop = netsh trace stop
	   $netsh_stop | Out-File $Filepath -Append																		        
	}
