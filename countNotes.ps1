<#
.SYNOPSIS
This powershell counts the number of note defintions within a policy.

.DESCRIPTION
This powershell counts the number of note defintions within a policy.
It counts all notes checks with the pattern "Note <Note Number> exists"

.EXAMPLE
countNotes.ps1 -Policy C:\Users\MyUser\Documents\policy\patchday\test_merge001.xml

.NOTES
Version 001 / 25.08.2018 / Please email questions to rene.muth@sap.com

.LINK
http://www.sap.com
https://www.sap.com/documents/2016/10/c2659de6-907c-0010-82c7-eda71af511fa.html

#>
param ([string]$Policy ="")


 # Create XML document from file
[xml]$XMLPolicy = (get-content $Policy)

# Get all checkitem elements
$CheckItems = $XMLPolicy.GetElementsByTagName("checkitem")

#use hashtable
$NotesArray=@{} 

# loop over all items
Foreach ($CheckItem in $CheckItems){
         # check if check item description match for ABAP SNote / ABAP kernel note / HANA security note
        $match = $CheckItem.desc -match "Note .{10} exists|kernel version|Note .{10} vulnerability exists"
        if ($match -eq "True") {
           # increase counter via note number 
           if ( $NotesArray.Contains($Checkitem.id) -eq $True ) {
                ++$NotesArray.($CheckItem.id)
           } else {
                $NotesArray.Add($CheckItem.id,1)
           }
        }
}

# print the results
foreach ($Note in $NotesArray.GetEnumerator()) {
    Write-Output "$($Note.Name): $($Note.Value)"
}
