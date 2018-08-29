<#
.SYNOPSIS
This powershell script deletes duplicate note defintions in a policy.

.DESCRIPTION
This powershell script deletes duplicate note defintions in a policy. 
It can be done for all notes having duplicates or for a specific single note.
It keeps the first node definition (3x rules) and deletes all subsequent ones.


.EXAMPLE
deleteDuplicates.ps1 -Policy C:\Users\MyUser\Documents\policy\patchday\test_merge001.xml
.EXAMPLE
deleteDuplicates.ps1 -Policy C:\Users\MyUser\Documents\policy\patchday\test_merge_001.xml -NoteNumber 0002189781

.NOTES
Version 001 / 25.08.2018 / Please email questions to rene.muth@sap.com

.LINK
http://www.sap.com
https://www.sap.com/documents/2016/10/c2659de6-907c-0010-82c7-eda71af511fa.html

#>
param ([string]$Policy="..\__tmp\test_merge_del_test.xml",[String]$NoteNumber)

# ------- functions start -------#
function del-Duplicates {
Param([Object[]]$Duplicates)
    [hashtable]$Return = @{} 
    # A security note has normaly three checks: 1x ABAP_NOTES and 2x COMP_LEVEL: 1x Correction Instruction + 1x SupportPackage
    if($Duplicates.length -gt 3)
    {
        for($i = 3; $i -lt $Duplicates.length; $i++)
        {
            $element = $Duplicates[$i]
            # search for the checkitem node
            $xpath = "//targetsystem/configstore/checkitem[@id=" + $element.ID + "]"
            $nodeToRemove = $xml.SelectSingleNode($xpath)
            if ( $nodeToRemove -ne $null ) {
                #remove the entire configstore/checkitem node, not only the checkitem node
                $parentToRemove = $nodeToRemove.ParentNode
                $parentToRemove.ParentNode.RemoveChild($parentToRemove)
                $Return.Messages += $element.Desc + "/"
            }
        }
        $Return.Success = $true
        Return $Return
    }
    $Return.Success = $false
    $Return.Messages = @()
    Return $Return
}
# ------- functions end -------#

# Load XML file
$xml = [xml](Get-Content $Policy)
$messages = ""
$found = $false

# Parse the document and delete the duplicate nodes with the exception of the first occurrence

# check if a specific note should be stripped only
if ($NoteNumber)
{
   $duplicates = ($xml.targetsystem.configstore.checkitem | where {$_.ID -eq $NoteNumber})
   $ret = del-Duplicates -Duplicates $duplicates
   if ( $ret.Success -eq $true ) { 
       $found = $true 
       $messages += $ret.Messages
   }
}
else
{
    # loop over all nodes
    foreach($node in $xml.targetsystem.configstore.checkitem)
    {  
        $duplicates = ($xml.targetsystem.configstore.checkitem | where {$_.ID -eq $node.ID})
        $ret = del-Duplicates -Duplicates $duplicates
        if ( $ret.Success -eq $true ) { 
           $found = $true 
           $messages += $ret.Messages
       }
    }
}

# Update the file
$xml.Save($Policy)

# Status message
if ( $found -eq $true ) {
    $messageArray = $messages.split("/")
    Write-Output "Succceded: Removed duplicates from: " $Policy $messageArray
} else {
    Write-Output "No duplicates found in: " $Policy 
}