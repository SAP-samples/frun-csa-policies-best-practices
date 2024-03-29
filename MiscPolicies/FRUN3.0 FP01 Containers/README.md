# Description

The folder frun-csa-policies-best-practices/MiscPolicies/FRUN3.0 FP01 Container provides so called CSA Containers. These containers are a collection of policies related to the topic in a binary version. 
Starting with FRUN 3.0 FP01 Configuration & Security Analytics - Policy Management offers to import these CSA containers and thus get the policies added to CSA.

## Note
To download a CSA Container from GitHub please display the file and press "Raw". The file is displayed in 'Raw' mode and the url is starting with https://raw.github...   e.g. https://raw.githubusercontent.com/SAP-samples/frun-csa-policies-best-practices/main/MiscPolicies/FRUN3.0%20FP01%20Containers/CsaCont...
From context menu select 'Save as..' to get the file stored on local disk.


The import is done in Policy Management -> Configuration 
Open tray 'Import CSA Container' and 'Select file..'
The container files are starting with 'CsaCont'. 
After a container file had been selected a dialog is displayed that offers to select or deselect single policies.
'Import' applies the selected policies.

In Case the Message E VSCAN 034 stops the import, please apply the note
3067015-Collective Corrections for CSA Application in FRUN 3.00 FP01

## Attention
Already existing policies - if selected for import - are overwritten.

## Recommendation
Scheduling is offered for Composite Policies (-> Configure). We recommend setting the 'Validation Run Interval' to DAILY.
This configuration triggers a daily precalculation of the validation results and makes the composite policy and its policies available for Trend Analysis.


# How to obtain support
Please report issues in _Focused Run Advanced Configuration Monitoring_ using SAP's product support channels.  
For questions regarding the provided policies please use [Issues](https://github.com/SAP/frun-csa-policies-best-practices/issues) on GitHub.  





