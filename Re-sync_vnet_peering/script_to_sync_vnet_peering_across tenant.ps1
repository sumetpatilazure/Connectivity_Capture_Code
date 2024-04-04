
Connect-AzAccount -SubscriptionId ""#####"" -TenantId ""#####""
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
                        Connect-AzAccount -SubscriptionId ""#####"" -TenantId ""#####"
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
