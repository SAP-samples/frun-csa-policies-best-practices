<#
.SYNOPSIS
This powershell script reads node definitions from several policies and stores all of them into a new policy

.DESCRIPTION
This powershell script reads node definition from several policies and stores all of them into a new policy
It copies the node definition (3x rules) into a new policy.


.EXAMPLE
getNotes.ps1 -Policies C:\Users\MyUser\Documents\policy\patchday\test_merge_2017_all.xml -Notes 2389578,2407670,2401265,2408558,2418209,2418823,2424671,2450979,2592069,2051336,2604054,2633180 -NewPolicy C:\Users\MyUser\Documents\policy\patchday\test_getNotes_001.xml -Desc "test get notes" -id "GetNotes0001"

.NOTES
Version 001 / 25.08.2018 / Please email questions to rene.muth@sap.com

.LINK
http://www.sap.com
https://www.sap.com/documents/2016/10/c2659de6-907c-0010-82c7-eda71af511fa.html

#>

param(  [String[]]$Policies,
        [String[]]$Notes,
        [string]$NewPolicy="test_merge.xml",
        [String]$Desc="New merged Policy 001",
        [String]$Id="NewMergedPol0001"
        )

# track if notes have been found
[hashtable]$NotesFound = @{} 
    # start with false for all
    foreach($NoteNumber in $Notes) { 
        if ( $NoteNumber[0] -ne "0" ) { $NoteNumber = "000" + $NoteNumber }
        $NotesFound.($NoteNumber) = $false
    }

# start tag: xml header
$finalXml = "<targetsystem desc=`"$Desc`" id=`"$Id`" multisql=`"Yes`">"

# loop over files and copy content into new policy
foreach ($file in $Policies) {
    [xml]$xml = Get-Content $file
    foreach($NoteNumber in $Notes) {
    if ( $NoteNumber[0] -ne "0" ) { $NoteNumber = "000" + $NoteNumber } 
    $CopyNotes = ($xml.targetsystem.configstore.checkitem | where-object {$_.ID -eq $NoteNumber})
    if($CopyNotes.length -gt 0)
    {
        for($i = 0; $i -lt $CopyNotes.length; $i++)
        {
            $element = $CopyNotes[$i]
            # search for the checkitem node using the description to get all the different ones
            $xpath = "//targetsystem/configstore/checkitem[@desc=" + '"' + $element.Desc + '"' + "]"
            $nodeToAdd = $xml.SelectSingleNode($xpath)
            if ( $null -ne $nodeToAdd ) {
                # move up one level to get a complete xml ouput definition
                $parentToAdd = $nodeToAdd.ParentNode
                $finalXml += $parentToAdd.OuterXML
                $NotesFound.($NoteNumber) = $true
            }
        }
    } 
  }
}
# close tag
$finalXml += "</targetsystem>"

# write new policy
([xml]$finalXml).Save("$NewPolicy")

# status message
Write-Output "Succceded: New policy written to: " $NewPolicy

# print those notes which were not copied 
foreach($NoteNumber in $Notes) { 
    if ( $NoteNumber[0] -ne "0" ) { $NoteNumber = "000" + $NoteNumber }
    if ( $NotesFound.($NoteNumber) -eq $false ) {
      $TmpMsg = "Note: " + $NoteNumber + " was not found"
      Write-Output $TmpMsg
    }
}

