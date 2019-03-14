<#
.SYNOPSIS
This Powershell script reads the SAP Security Notes Advisory excel file and creates for a specific Advisory Release date a policy for Focus RUN Configuration and Security Analytics. Currently, only SAP Notes for Systems of type "ABAP" are extracted.

.DESCRIPTION
The SAP Security Notes Advisory excel file contains SAP Notes for ABAP including the component dependencies of the notes. Based on this list a policy for Focus RUN Configuration and Security Analytics can be created which allows to check if those SAP notes have been applied into the managed system or if still missing using FRUN CSA. The SAP Security Notes Advisory ZIP file is available in Media Libray of the SAP Security Optimization Services Portfolio. AdvisoryRelease timestamp must match the timestamp used within the SAP Security Notes Advisory excel file, it's column "Advisory Release" of worksheet Advisory Security Notes <mm.yyyy>.

.EXAMPLE
CreatePolicy.ps1 -AdvisoryRelease "2017-07" -InputExcelFile "C:\Users\MyUser\Downloads\SAP Security Notes Advisory - July 2017.xlsx" -OutPutPolicy ".\ABAP_Notes_PatchDay_2017-7.xml"

.NOTES
Version 002 / 25.08.2017 / Please email questions to rene.muth@sap.com

.LINK
http://www.sap.com
http://support.sap.com/sos
https://www.sap.com/documents/2016/10/c2659de6-907c-0010-82c7-eda71af511fa.html


#>
param ([string]$AdvisoryRelease="$(get-date -Format yyyy)-$(((get-date).AddMonths(-1))|get-date -format MM)", 
       [string]$InputExcelFile="C:\Users\$env:USERNAME\Downloads\SAP Security Notes Advisory - $($($($((get-date).AddMonths(-1))|get-date -format M).split(" "))[1]) $(get-date -format yyyy).xlsx",
       [string]$OutPutPolicy=""
      )

# ------- functions start -------#
function get-NoteNumberIn10Chars {
Param([string]$NoteShort)

$NoteLong = ''

 $DiffLengthOfTen = 10 - $NoteShort.Length
  for ($i=$DiffLengthOfTen;$i -gt 0; $i--) { 
 $NoteLong = $NoteLong + "0"
}

$NoteLong = $NoteLong + $NoteShort

return "$NoteLong"
}

function get-SPValidityOfABAPNote {
param([string[]]$VciArray,[string]$SingleValidity,[string]$Version)
       for($i=0;$i -lt $VciArray.Length; $i++ ) {
        if( $VciArray[$i] -eq $SingleValidity ){
          $Version = $Version + $VciArray[$i+1] 
          return $Version
        }       
       }
return $Version
}

function get-ValidityCorrectionInstructionArray{
param([string]$ValidityCorrectionInstruction)

$ValidityCorrectionInstructionArray = $ValidityCorrectionInstruction.split([System.Environment]::NewLine)

foreach ($Line in $ValidityCorrectionInstructionArray)
{

    if ( $Line -ne "" ) {
        $VersionTmp = $Line.substring(0,3)
        $Line = $Line.substring(4)
        $match = $Line -match "$VersionTmp(?<content>[0-9]{2}).*"
        if ($match -eq "True") {
          $SPLow = $matches['content']
          $Index = $Line.IndexOf("$VersionTmp") + 2
          $Line = $Line.substring("$Index")
          $match = $Line -match "$VersionTmp(?<content>[0-9]{2}).*" 
          if ($match -eq "True") {
            $SPHigh = $matches['content']
            if ($SPHigh -eq "" -or $SPHigh -eq $SPLow ){
                $SPSql = "and to_integer( replace_regexpr ('^$' IN SP WITH '0' ) ) &lt;= $SPLow"
            } else {
                $SPSql = "and to_integer( replace_regexpr ('^$' IN SP WITH '0' ) ) between $SPLow and $SPHigh"
            }
            $VciArray += @(,("$VersionTmp"),($SPSql))
          }
        }
        $SPHigh = ""
        $SPLow = ""
        $Line = ""
    }
}

return $VciArray
}

function get-ValidityOfABAPNote {
Param([string]$ValidityNote,[string]$ValidityCorrectionInstruction)

$NonCompliantRule = ''

$ValidityArray = $ValidityNote.split([System.Environment]::NewLine)

$VciArray = get-ValidityCorrectionInstructionArray -ValidityCorrectionInstruction $ValidityCorrectionInstruction

foreach ($Line in $ValidityArray)
{

    if ( $Line -ne "" ) {
       if ( $NonCompliantRule.Length -ne 0 ) { 
            $NonCompliantRule = $NonCompliantRule + ' OR '  
       }
       $SingleValidity = $Line.split(" ")
       $Component = $SingleValidity[0]
       $Version = $SingleValidity[1]

       if ( $Version.contains("-") ) {
        $MultiVersions = $Version.split("-")
        for ($i=0;$i -lt 2; $i++) {
            $Version = "VERSION = '" 
            $Version = $Version + $MultiVersions[$i] + "' "
            $Version = get-SPValidityOfABAPNote -VciArray $VciArray -SingleValidity $MultiVersions[$i] -Version $Version
            $NonCompliantRule = $NonCompliantRule + "( COMPONENT = '$Component' AND $Version )" 
            if ( $i -eq 0 ){ $NonCompliantRule = $NonCompliantRule + " OR " }
        }  
       } 
       else {
        $Version = "VERSION = '" 
        $Version = $Version + $SingleValidity[1] + "' "
        $Version = get-SPValidityOfABAPNote -VciArray $VciArray -SingleValidity $SingleValidity[1] -Version $Version
        $NonCompliantRule = $NonCompliantRule + "( COMPONENT = '$Component' AND $Version )"   
       }       
    }
}
return "$NonCompliantRule"
}

function Write-Policy {
Param([boolean]$Overwrite,[string]$XmlOutput)

if ( $OutPutPolicy -eq "" ) {
    Write-Output $XmlOutput;
}
else {
    if ( $Overwrite -eq $false ) {
        out-file -FilePath $OutPutPolicy -Append -InputObject $XmlOutput
    }
    else {
        out-file -FilePath $OutPutPolicy -InputObject $XmlOutput
    }
}
}
# ------- functions end -------#

#------- script start -------#

# check file location first
if ( $InputExcelFile -eq '' ){
    Write-Error "file path is empty, use: -InputExcelFile <notes.xlsx>;"
    return;
} 

if ( ![System.IO.File]::Exists($InputExcelFile) ) {
    Write-Error "file with path $InputExcelFile doesn't exist";
    return;
}


# creating excel object
$objExcel=new-object -com excel.application
$objExcel.Visible = $True 

# open excel with notes
$NotesWorkBook=$objExcel.workbooks.open($InputExcelFile)

# currently, notes are specified in worksheet 5 (Advisory Security Notes MM.YYYY)
$UserWorksheet = $NotesWorkBook.Worksheets.Item(5)

# there is a header row
$intRow = 2

# xml template strings
$XmlHeader = '<?xml version="1.0" encoding="utf-16"?>'
$XmlHeader =  $XmlHeader + '<targetsystem desc="'
$XmlHeader =  $XmlHeader + "SNotes of PatchDay: $AdvisoryRelease" + '" id="PatchDay_'
$XmlHeader =  $XmlHeader + "$AdvisoryRelease" + '" multisql="Yes">'
$XmlFooter = '</targetsystem>'

Write-Policy $true $XmlHeader

Do {

# reading the note number
$PatchDay = $UserWorksheet.Cells.Item($intRow, 1).Value()
$NoteNumberShort = $UserWorksheet.Cells.Item($intRow, 3).Value()
$NoteVersion = $UserWorksheet.Cells.Item($intRow, 4).Value()
$SystemType = $UserWorksheet.Cells.Item($intRow, 11).Value()
$CorrectionType = $UserWorksheet.Cells.Item($intRow, 35).Value()
$ValidityOfSapNote = $UserWorksheet.Cells.Item($intRow, 40).Value()
$ValidityOfCorrection = $UserWorksheet.Cells.Item($intRow, 41).Value()
$ValidityOfKernelCorrection = $UserWorksheet.Cells.Item($intRow, 42).Value()

$NoteNumber = get-NoteNumberIn10Chars -NoteShort $NoteNumberShort 

if ($SystemType -eq "ABAP" -and $PatchDay -eq "$AdvisoryRelease" -and $CorrectionType -match "SNOTE") {
  Write-Policy $false '<configstore name="ABAP_NOTES">'
  $TmpLine = '<checkitem desc="Note ' + "$NoteNumber exists" + '" ' + "id=`"$NoteNumber`"" + ' operator="check_note">'
  Write-Policy $false $TmpLine
  $TmpLine = '<compliant>NOTE = ' + "'" + "$NoteNumber" + "'" + '</compliant>'
  Write-Policy $false $TmpLine
  Write-Policy $false '<noncompliant/>'
  Write-Policy $false '</checkitem>'
  Write-Policy $false '</configstore>'
  Write-Policy $false '<configstore name="COMP_LEVEL">'
  $TmpLine = '<checkitem desc="Note ' + "$NoteNumber missing and applicable" + '" ' + "id=`"$NoteNumber`"" + ' operator="check_note:' + "$NoteNumber" + '">'
  Write-Policy $false $TmpLine
  Write-Policy $false '<compliant/>'
  Write-Policy $false '<noncompliant>( ' 
  $TmpLine = get-ValidityOfABAPNote -ValidityNote $ValidityOfSapNote  -ValidityCorrectionInstruction $ValidityOfCorrection 
  Write-Policy $false $TmpLine
  Write-Policy $false ' )</noncompliant>'
  Write-Policy $false '</checkitem>'
  Write-Policy $false '</configstore>'
}

 $intRow++

} While ($UserWorksheet.Cells.Item($intRow,1).Value() -ne $null)

Write-Policy $false $XmlFooter;

# exiting excel object
$objExcel.Workbooks.close()
$objExcel.Quit( )
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)|out-null
Remove-Variable objExcel|out-null
# exit message in case output is written to a file
if ( $OutPutPolicy -ne "" ) { Write-Output "Done with $OutPutPolicy $AdvisoryRelease $InputExcelFile" }