param(  [String[]]$ExcelFilePath,
        [string]$NewPolicy="CreatePolicy.xml",
        [String]$Desc="Age of ABAP SAP Basis",
        [String]$Id="AgeOfSAPBasis"
        )

#------- script start -------#

# creating excel object
$objExcel=new-object -com excel.application
$objExcel.Visible = $True 

if ($ExcelFilePath.Length -gt 0) {
    $ExcelFilesLocation = $ExcelFilePath
    $NotesWorkBook=$objExcel.workbooks.open($ExcelFilesLocation)
} else {
    $ExcelFilesLocation = 'C:\Users\<user>\Documents\'
    $NotesWorkBook=$objExcel.workbooks.open($ExcelFilesLocation + 'age_of_support_packages.xlsx')
}

#Currently, notes are specified in worksheet 5 (Advisory Security Notes MM.YYYY)
$UserWorksheet = $NotesWorkBook.Worksheets.Item(1)

# there is a header row
$intRow = 2

$XmlHeader = '<?xml version="1.0" encoding="utf-8"?>'
$XmlHeader =  $XmlHeader + '<targetsystem desc="'+ $Desc + '" id="' + $Id + '"' + ' multisql="Yes">'
$XmlHeader =  $XmlHeader + '<configstore name="COMP_LEVEL" system_type="ABAP">'
$XmlHeader =  $XmlHeader + '<checkitem desc="SAP Basis Component released more than 24 months ago" id="age_of_sap_basis">'
$XmlHeader =  $XmlHeader + '<compliant>'

$TmpLineNonComp = '<noncompliant>'

# XML output starts here
Write-Output $XmlHeader;
$ReleasedOnDate = Get-Date

Do {

    # Reading the items from excel
    $Basis = $UserWorksheet.Cells.Item($intRow, 1).Value()
    $Stack = $UserWorksheet.Cells.Item($intRow, 2).Value()
    $ReleasedOnDate = $UserWorksheet.Cells.Item($intRow, 6).Value()
    # Adapt Release Stack and value for the SQL condition
    $ReleasedOn = $ReleasedOnDate.year.ToString()
    $ReleasedOn = $ReleasedOn + "-"
    # Month needs to have 2 digits
    $ReleaseMonth = $ReleasedOnDate.month.ToString()
    for($i=$ReleaseMonth.Length;$i -lt 2;$i++) { $ReleaseMonth = '0' + $ReleaseMonth }
    $ReleasedOn += $ReleaseMonth + "-"
    # Day needs to have 2 digits
    $ReleaseDay = $ReleasedOnDate.day.ToString()
    for($i=$ReleaseDay.Length;$i -lt 2;$i++) { $ReleaseDay = '0' + $ReleaseDay }
    $ReleasedOn += $ReleaseDay
    
    # SP(Stack) needs to have 4 digits
    for($i=$Stack.ToString().Length;$i -lt 4;$i++) { $Stack = '0' + $Stack }

    # Or not for the first entry
    if( $intRow -gt 2 ) { 
        $TmpLineComp = ' OR ' 
        $TmpLineNonComp = $TmpLineNonComp  + ' OR '
    }
    $TmpLineComp = $TmpLineComp + "(COMPONENT = 'SAP_BASIS' and VERSION = '"+ $Basis + "' and 1 = (CASE WHEN SP = '"+ $Stack + "' THEN ( CASE WHEN DAYS_BETWEEN(TO_DATE('"+ $ReleasedOn +"','YYYY-MM-DD'),CURRENT_DATE) &lt;= 730 THEN 1 ELSE 0 END) ELSE 0 END ) ) "
    $TmpLineNonComp = $TmpLineNonComp + "(COMPONENT = 'SAP_BASIS' and VERSION = '"+ $Basis + "' and 1 = (CASE WHEN SP = '"+ $Stack + "' THEN ( CASE WHEN DAYS_BETWEEN(TO_DATE('"+ $ReleasedOn +"','YYYY-MM-DD'),CURRENT_DATE) &gt; 730 THEN 1 ELSE 0 END) ELSE 0 END ) ) `r`n"

    Write-Output $TmpLineComp
    $TmpLineComp = ""

    $intRow++

} While ($UserWorksheet.Cells.Item($intRow,1).Value() -ne $null)

# Close compliant rule
write-output '</compliant>'

# Add the noncompliant rule
Write-Output $TmpLineNonComp
Write-Output '</noncompliant>'

# Close checkitem, store and target tag
write-output '</checkitem>'  
write-output '</configstore>'  
Write-output '</targetsystem>'

#Exiting excel object
$objExcel.Workbooks.close()
$objExcel.Quit( )
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)|out-null
Remove-Variable objExcel|out-null