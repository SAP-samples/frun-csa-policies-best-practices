# Description

This folder provides policies for automating the requirements of the _SAP Security Baseline Template v2_ for the use with _Focused Run - Advanced Configuration Monitoring - Configuration and Security Analytics_. Corrections and minor version updates of the Baseline Template or these policies will be published by replacing or adding files. The Baseline Template is available in the media library at https://support.sap.com/sos  
[SAP CoE Security Services - Security Baseline Template Version 2.2 (including ConfigVal Package CV-2)](https://support.sap.com/content/dam/support/en_us/library/ssp/offerings-and-programs/support-services/sap-security-optimization-services-portfolio/Security_Baseline_Template_V2.zip)

## Note
All policies follow closely the target systems for application Configuration Validatation in the SAP Solution Manager (see document: `Configuration_Validation_Template_V2.2_CV-2.docx`).  
In cases where the technology of Focused Run supports a more accurate translation of Baseline Template requirements, the validation rules are adapted. This applies e.g. to:
* Dependencies of requirements (e.g. release dependency of parameter settings) by using joins. 
* Avoidance of "no data found" results by checking the existence of a parameter and then check further details only if the first check is positive.

## Further Note
* For adoption it is recommended to define policies on a quite granular level. As of FRUN 3.0 FP00 you can select multiple policies for validation and have them run together.
* As of FRUN 3.0 FP00 parameters for WebDispatcher are also available in table stores, so that checks from AS APAP can be easily reused. For earlier FRUN versions the rules need to be adapted to text stores.  

## Attention
Some policies check Configuration Stores that may not exist in your Focused Run system because of various reasons:
* Shipment in a later Feature Pack, e.g. Transport Parameters for `BL2_CHANGE-A` (FRUN 3.0 FP 00)
* Customizable Stores used in `BL2_CRITAU-A` (available also in FRUN 2.0 but only after manual configuration by customer)

# How to obtain support
Please report issues in _Focused Run Advanced Configuration Monitoring_ using SAP's product support channels.  
For questions regarding the provided policies please use [Issues](https://github.com/SAP/frun-csa-policies-best-practices/issues) on GitHub.  
