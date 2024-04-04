
Connect-AzAccount -SubscriptionId "24490b86-506a-4fb7-9b5e-b070a5674daa" -TenantId "72f988bf-86f1-41af-91ab-2d7cd011db47"
Write-Output ("Connected to the Account")
$Subscriptions = $(Get-AzSubscription | Where-Object { ($_.Name.StartsWith("Microsoft")) -and ($_.Name -match $Environment) -and (($_.State -ieq "Enabled") -or ($_.State -ieq "Active")) })

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

                    if ($VirtualNetworkPeering.peeringSyncLevel -contains "LocalNotInSync") {
                
                        Write-Output ("VirtualNetworkPeeringRemoteVirtualNetwork:    " + $VirtualNetworkPeering.RemoteVirtualNetworkText )                         
                        Write-Output ("                                   " + "RESYNCing......" )
                        Sync-AzVirtualNetworkPeering -Name $VirtualNetworkPeering.Name -VirtualNetworkName $Resource.Name -ResourceGroupName $ResourceGroup.ResourceGroupName
                        Write-Output ("                                   " + "RESYNCing......" )

                    }
                    elseif ($VirtualNetworkPeering.peeringSyncLevel -contains "RemoteNotInSync") {
                        Connect-AzAccount -SubscriptionId "7e5b80fe-60bb-41e4-bc5a-298da03b2364" -TenantId "7f887fb7-19a5-45f9-aa78-3beda0ca1858"
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
                    Write-Output ("")
                }
            }
        }
    }

}
