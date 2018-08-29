<#
.SYNOPSIS
This powershell script prints all check definition for a note within a policy

.DESCRIPTION
This powershell script prints all check definition for a note within a policy which allows to check the definition without searching through the policy. To find a note the note description is used which supports wildcards.


.EXAMPLE
printNote.ps1 -Policy "C:\Users\MyUser\Documents\patchday\ABAP_snotes_patchday_2017-01.xml" -Note "0002179233"
.EXAMPLE
printNote.ps1 -Policy "C:\Users\MyUser\Documents\patchday\ABAP_snotes_patchday_2017-01.xml" -Note "0002179233.*Correct"


.NOTES
Version 001 / 25.08.2018 / Please email questions to rene.muth@sap.com

.LINK
http://www.sap.com
https://www.sap.com/documents/2016/10/c2659de6-907c-0010-82c7-eda71af511fa.html

#>
param ([string]$Policy ="patchday_2016-01.xml", [string]$Note="")


 # Create XML document from file
[xml]$XMLPolicy = (get-content $Policy)

# Get all configstores 
$CheckItems = $XMLPolicy.GetElementsByTagName("checkitem")

# search the desc of check item and print it in case it matches
Foreach ($CheckItem in $CheckItems){
        $match = $CheckItem.desc -match $Note
        if ($match -eq "True") {
        # print check item and compliant and non-compliant rule
        Write-Output $CheckItem
        Write-Output "Compliant" $CheckItem.compliant.'#text'
        Write-Output "Noncompliant "$CheckItem.noncompliant.'#text'
        }
}

