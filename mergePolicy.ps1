<#
.SYNOPSIS
This powershell script merges several FRUN CSA policies into a new policy

.DESCRIPTION
This powershell script merges several FRUN CSA policies into a new policy. 
In case you want to merge policies into one new policies this scripts copies all the checks of the provided policies into a single one.


.EXAMPLE
mergePolicy.ps1 -Desc "SNotes of 201701 to 201706" -Id "SNOTES_201701-06" -files $(Get-ChildItem C:\Users\MyUser\Documents\policy\patchday\ABAP*2017-0[1-6]*.xml|sort) -NewPolicy "C:\Users\MyUser\Documents\policy\patchday\test_merge001.xml"


.NOTES
Version 001 / 25.08.2018 / Please email questions to rene.muth@sap.com

.LINK
http://www.sap.com
https://www.sap.com/documents/2016/10/c2659de6-907c-0010-82c7-eda71af511fa.html

#>
param(  [String[]]$Policies,
        [string]$NewPolicy="test_merge.xml",
        [String]$Desc="New merged Policy 001",
        [String]$Id="NewMergedPol0001"
        )

# start tag: xml header
$finalXml = "<targetsystem desc=`"$Desc`" id=`"$Id`" multisql=`"Yes`">"

# loop over files and copy content into new policy
foreach ($file in $Policies) {
    [xml]$xml = Get-Content $file
    $finalXml = $finalXml + $xml.targetsystem.InnerXml
}
# close tag
$finalXml += "</targetsystem>"

# write new policy
([xml]$finalXml).Save("$NewPolicy")

# status message
Write-Output "Succceded: New merged policy written to: " $NewPolicy
