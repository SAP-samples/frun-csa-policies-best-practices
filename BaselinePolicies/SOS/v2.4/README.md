# Description

This folder provides policies for automating the requirements of the SAP Security Baseline Template v2.4 for the use with Focused Run - Advanced Configuration Monitoring - Configuration and Security Analysis.
Publishing Date:  28th April 2023


CHANGE: Check rules adapted to SAP Security Baseline Template Version 2.4
CHANGE: Some minor adaptions of check syntax 
CHANGE: Policies are consistently divided by topic section of the SAP Security Baseline Template and by check priority (CRITICAL/STANDARD/EXTENDED)
CHANGE: Checks that require customers to create a customizable store are put into separate policies (Suffix: ~CSTO).
ADD: Policies BTP (SAP Cloud Connector) and SAP WebDispatcher 
ADD: A Container is provided to upload all policies at once.


INFO: The Baseline Template is available in the media library at https://support.sap.com/sos
INFO: Check rules follow the implementation guidance of there-published  document 
      Configration_Validation_Template_V2.4_CV-1.docx.
In some cases additional features of SAP Focused Run are applied for extending the scope of checks or to make check rules more accurate.
INFO: For all policies that refer to customizable stores (e.g. 1ACRITA_CSTO, 3AFILE_CSTO, 1CRITAU) a manual adaption of policies is mandatory:
configstore name and sci_id must be changed to the actual values in your system!
INFO: Checks for Password Hashes and Switchable Authorizations are put in separate policies, because multiple noncompliant item may hide noncompliant parameters

INFO: Primary Channel for Issues and Feedback: SV-FRN-APP-CSA 
