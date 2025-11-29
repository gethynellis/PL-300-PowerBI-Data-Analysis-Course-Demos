<#I need to delete the CSV file if it exists otherwise it will append a whole bunch of duplicate rows #>
$Filename = "C:\Users\GethynEllis\OneDrive - GRE Solutions Limited\PHIT Football\Data\PLayerDataLoopTest.csv"
If (Test-Path $Filename ) {
Remove-Item -Path $Filename
}



<# Section 1
 This first section makes a call to the bootstrap API which will give you highlevel summary information for the players
 We use this to get a list of the player IDs that we can then pass into a loop to write out a detailed season history 
 into a CSV file
 #>

$FPLData = Invoke-RestMethod -Uri https://fantasy.premierleague.com/api/bootstrap-static/
 #$FPLData | Get-Member
 #$FPLData.elements | Select-Object -Property Id
  #$FPLData.elements |  Export-Csv -Path C:\Fpl\PLayerDataSummary.csv

 #$PlayerIDs = $FPLData.elements | Format-Table -Property id

 $PlayerIDs = $FPLData.elements | Select-Object -Property Id
 #$PlayerIDs

 

 <#Section 2 the FOR EACH LOOp
 With an Array  of Player IDs that we can use to pass into FOREACH 
 This first loop simply writes out the PLayerIDs to screen. This will be commented out 
 #>

 ##Loop Around and invoke Detail API Call - This is Test
 <#
 ForEach ($i in $PlayerIDs) {
    Write-Host $i.id 
   #Invoke-RestMethod -Uri https://fantasy.premierleague.com/api/element-summary/$id/
}

##ForLoop Around and invoke API Call
#>

<#
So we build the URI here contructing the API call we pass in the element summary URI, 
then we append  the Array ID value to it
then we append the final "/"

The we set a $data variable to call the URI using the Invoke-RestMethod and passing in the URI
We then select the history properly from the results
We use Select-Object * to return everything then we use an expression to add the player ID to each row of the results
we need this to tie the data with a a player from the summary data. 
We then write the whole this to CSV
From here we can then consume without issue in Power BI
We will use this data to build a more granualr fact table so we can analyse player performance across the season
This will help forecasting scores and also identifying players who have tailed off etc
#>


 ForEach ($i in $PlayerIDs) {
    #Write-Host $i.id 
$Uri = "https://fantasy.premierleague.com/api/element-summary/"
$Uri = $Uri +$i.id
$Uri = $Uri +"/"
    #Write-Host $Uri
   $pdata = Invoke-RestMethod -Uri $Uri
   $pdata.history | Select-Object *, @{Name ='ID';Expression={$i.id}} |Export-Csv -Path "C:\Users\GethynEllis\OneDrive - GRE Solutions Limited\PHIT Football\Data\PLayerDataLoopTest.csv"  -Append
}


<#

This is me showing my workings

 $PLayerData =  Invoke-RestMethod -Uri https://fantasy.premierleague.com/api/element-summary/689/
 $PlayerData | Get-Member
 $PLayerData.history 
$PLayerData.history | Select-Object *, @{Name ='ID';Expression={'689'}} | Export-Csv -Path C:\Fpl\PLayerDataHistory.csv

| Export-Csv -Path C:\Fpl\PLayerDataHistory.csv

  $PLayerData.history | Export-Csv -Path C:\Fpl\PLayerDataHistory.csv -Append

  #>
  
  

