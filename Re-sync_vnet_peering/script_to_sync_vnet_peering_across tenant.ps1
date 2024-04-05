#Connecting to the account where you want to perform the task
Write-Output ("Please connect to the correct Az Account once the browser pops up with your account")
Connect-AzAccount 																			
Write-Output ("Connected to the Account")

Getting the list of the Subscriptions in your tenant
$Subscriptions = $(Get-AzSubscription | Where-Object { ($_.Name.StartsWith("Microsoft")) -and ($_.Name -match $Environment) -and (($_.State -ieq "Enabled") -or ($_.State -ieq "Active")) })

# Checking all the subscription one by one in the list by selecting them
foreach ($Subscription in $Subscriptions) {
    Select-AzSubscription -SubscriptionId $Subscription.Id | Out-Null
    Set-AzContext -Subscription $Subscription.Id | Out-Null

    #Get all ARM resources from all resource groups
    $ResourceGroups = Get-AzResourceGroup
    foreach ($ResourceGroup in $ResourceGroups) {
       	
        $Resources = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName
        foreach ($Resource in $Resources) {
            if ($Resource.ResourceType -eq "Microsoft.Network/virtualNetworks" ) {
            	
		#Pulling the Vnet peering information
                $VirtualNetworkPeerings = Get-AzVirtualNetworkPeering -VirtualNetworkName $Resource.Name -ResourceGroupName $ResourceGroup.ResourceGroupName
                foreach ($VirtualNetworkPeering in $VirtualNetworkPeerings) {
                    Write-Output ("SubscriptionName:                  " + $Subscription.Name)
                    Write-Output ("SubscriptionId:                    " + $Subscription.Id)
                    Write-Output ("SubscriptionState:                 " + $Subscription.State)
                    Write-Output ("ResourceGroup:                     " + $ResourceGroup.ResourceGroupName)
                    Write-Output ("ResourceType:                      " + $Resource.ResourceType)
                    Write-Output ("ResourceName:                      " + $Resource.Name)
                    Write-Output ("VirtualNetworkPeeringName:         " + $VirtualNetworkPeering.Name)
                    Write-Output ("VirtualNetworkPeeringState:        " + $VirtualNetworkPeering.PeeringState )
                    Write-Output ("VirtualNetworkPeeringSyncLevel:    " + $VirtualNetworkPeering.peeringSyncLevel )
		    
		    # checking the peeering status to re-sync the peering 
                    if ($VirtualNetworkPeering.peeringSyncLevel -contains "LocalNotInSync") {
                
                        Write-Output ("VirtualNetworkPeeringRemoteVirtualNetwork:    " + $VirtualNetworkPeering.RemoteVirtualNetworkText )                         
                        Write-Output ("                                   " + "RESYNCing......" )
                        Sync-AzVirtualNetworkPeering -Name $VirtualNetworkPeering.Name -VirtualNetworkName $Resource.Name -ResourceGroupName $ResourceGroup.ResourceGroupName
                        Write-Output ("                                   " + "RESYNCing......" )

                    }
                    elseif ($VirtualNetworkPeering.peeringSyncLevel -contains "RemoteNotInSync") {
			
                        #Connecting to the account where you want to perform the task
			 Write-Output ("Please connect to the correct Az Account once the browser pops up with your account")
			 Connect-AzAccount 																			
			 Write-Output ("Connected to the Account")
                         $Subscriptions = $(Get-AzSubscription | Where-Object { ($_.Name.StartsWith("Azure")) -and ($_.Name -match $Environment) -and (($_.State -ieq "Enabled") -or ($_.State -ieq "Active")) })

                        foreach ($Subscription in $Subscriptions) {
                            Select-AzSubscription -SubscriptionId $Subscription.Id | Out-Null
                            Set-AzContext -Subscription $Subscription.Id | Out-Null

                            #Get all ARM resources from all resource groups
                            $ResourceGroups = Get-AzResourceGroup
                            foreach ($ResourceGroup in $ResourceGroups) {
       
                                $Resources = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName
                                foreach ($Resource in $Resources) {
                                    if ($Resource.ResourceType -eq "Microsoft.Network/virtualNetworks" ) {
            				
                                        $VirtualNetworkPeerings = Get-AzVirtualNetworkPeering -VirtualNetworkName $Resource.Name -ResourceGroupName $ResourceGroup.ResourceGroupName
                                        foreach ($VirtualNetworkPeering in $VirtualNetworkPeerings) {
                                            Write-Output ("SubscriptionName:                  " + $Subscription.Name)
                                            Write-Output ("SubscriptionId:                    " + $Subscription.Id)
                                            Write-Output ("SubscriptionState:                 " + $Subscription.State)
                                            Write-Output ("ResourceGroup:                     " + $ResourceGroup.ResourceGroupName)
                                            Write-Output ("ResourceType:                      " + $Resource.ResourceType)
                                            Write-Output ("ResourceName:                      " + $Resource.Name)
                                            Write-Output ("VirtualNetworkPeeringName:         " + $VirtualNetworkPeering.Name)
                                            Write-Output ("VirtualNetworkPeeringState:        " + $VirtualNetworkPeering.PeeringState )
                                            Write-Output ("VirtualNetworkPeeringSyncLevel:    " + $VirtualNetworkPeering.peeringSyncLevel )


                	                
                                            Write-Output ("VirtualNetworkPeeringRemoteVirtualNetwork:    " + $VirtualNetworkPeering.RemoteVirtualNetworkText )                         
                                            Write-Output ("                                   " + "RESYNCing......" )
                                            Sync-AzVirtualNetworkPeering -Name $VirtualNetworkPeering.Name -VirtualNetworkName $Resource.Name -ResourceGroupName $ResourceGroup.ResourceGroupName
                                            Write-Output ("                                   " + "RESYNCing......" )

                                        }
                                    }
                                }
                            }
                        }
                    }
                    Write-Output ("Script ended")
                }
            }
        }
    }

}
