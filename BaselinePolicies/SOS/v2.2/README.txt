DECRIPTION

This folder provides policies for automating the requirements of the SAP Security Baseline Template v2 for the use with Focused Run - Advanced Configuration Monitoring - Configuration and Security Analytics. Corrections and minor version updates of the Baseline Template or will be published by replacing or adding files. The Baseline Template is available in the 
media library 
  SAP CoE Security Services - Security Baseline Template Version 2.2 (including ConfigVal Package CV-2)

under https://support.sap.com/sos

NOTE
All policies follow closely the practices documented for SAP Solution Manager Target systems (see document: Configuration_Validation_Template_V2.2_CV-2.docx). 
In cases where the technology of Focused Run supports a more accurate translation of Baseline Template requirements, the validation rules are adapted. This applies e.g to:
+ Dependencies of requirements (e.g. release dependency of parameter settings). Use of joins. 
+ Avoid "no data found": Check existence of a parameter and then check further details only if the first check is positive.

FURTHER NOTE
+ For adoption it is recommended to define policies on a quite granular level. As of FRUN 3.0 FP00 you can select multiple policies for validation and have them run together.
+ As of FRUN 3.0 FP00 parameters for WebDispatcher are also available in table stores, so that checks from AS APAP can be easily reused. For earlier FRUN versions the rules need to be adapted to text stores.  

ATTENTION:
Some policies check in Config Stores that may not exist in your Focused Run system:
+ Shipment in a later Feature Pack, e.g. Transport Parameters for BL2_CHANGE-A (FRUN 3.0 FP 00)
+ Customizable Stores used in BL2_CRITAU-A (available also in FRUN 2.0 but only after manual configuration by customer)

# How to obtain support
Please report issues in Focused Run Advanced Configuration Monitoring using SAP's product support channels.
For questions regarding the provided policies please use  https://github.com/SAP/frun-csa-policies-best-practices/issues   .





