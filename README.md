[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/frun-csa-policies-best-practices)](https://api.reuse.software/info/github.com/SAP-samples/frun-csa-policies-best-practices)

# Description
This project provides policies for Focused Run - Advanced Configuration Monitoring - Configuration and Security Analytics. Those policies are the basis for validating configuration items of systems which are stored centrally in Focused Run. Policies comprise a set of rules which are ideally derived from a  hardening guide or a system baseline documention. Those policies are used to calculate compliance status of configuration items using application FRUN CSA Validation.


# Requirements
To use those policies you need [SAP Focused Run](https://support.sap.com/en/alm/focused-solutions/focused-run.html)

# Download and Installation
Installation steps will be found at the [SAP Focused Run](https://support.sap.com/en/alm/focused-solutions/focused-run.html) web site.
Review the information in the tabs on that page titled, "Get SAP Focused Run" and "Implement SAP Focused Run". 

Usually a SAP Focused Run Architecture and Project Setup Workshop is performed to install and configure the Focused Run infrastructure in close cooperation with the customer team: technical deployment, landscape discovery, as well as network settings will need to be covered in such meetings. Some managed systems will be connected to SAP Focused Run, including activation of some use cases.

After connecting the managed systems to SAP Focused Run (FRUN), you can start to configure FRUN CSA Validation using policies provided in this repository. Those policies could be uploaded in FRUN CSA Policy Management (start FRUN Launchpad / Advanced Configuration Monitoring / tile Configuration and Security Analytics - Policy Management) and generated. When creating a new policy, you many use the Policy Id and Policy Descr of the XML policy as input (\<targetsystem desc="Policy Descr" id="Policy Id"\>) to have consistency between what is stored in FRUN CSA and the XML policy. You need to copy and paste the content of the XML policy from the repository into the text editor of FRUN CSA policy management. Navigate in GitHub until you see the content of the policy you want to copy, you may use button RAW to get only the source of the policy displayed which supports to copy the content using keyboard shourtcuts CTRL-A and CTRL-C.

If you are using an editor of your choice to create and edit a policy, you may use the XSF file in Schema to support you with further XML syntax checks and input help. Also here you need to copy and paste the file content into the editor of FRUN CSA policy management finally.
  

# Configuration
Use the baseline policies as a template for your own policies reflecting the requirements of your corporate hardening guides and security policies. Demo: [Configuration and Security Analytics ](https://sapvideoa35699dc5.hana.ondemand.com/?entry_id=1_ce0ht4id)
In many cases the check ids of the provided SAP Baseline Policies must adapted to match requirement ids of customer corporate hardening guide. Re-Use or adapt the check rules when matching the corporate guide. 
The policies in BaselinePolicies/SOS are based on the recommendations of [SAP Security Optimization Services Portfolio](https://support.sap.com/sos). In the media library there you will find the archive "SAP CoE Security Services - Security Baseline Template Version 1.9" and "SAP CoE Security Services - Security Baseline Template Version 2.3" which provide details about each single check. The baseline SOS policies 2.x are organised in a different way to the target systems mentioned in the "SAP Security Baseline Template" document (provided as part of the archive). The policies cover the same checks as target systems for solution manager.

To get transparency about the implementation status of security notes (currently for systems of type ABAP and for SAP HANA database) use the notes policies in NotesPolicies. Those are defined per SAP patchday and contain rules for all notes which are measurable using FRUN CSA. It's possible to upload each single patchday individually as FRUN CSA policy. It would be also possible to merge single patch days into new a policy. 
As of FRUN 3.0 FP01 please use the feature 'Composite' policy instead, add those policies for which an overall result should be displayed. 
For the ABAP patchdays in 2018 you find policy ABAP_snotes_patchday_2018-0**1_12**.xml which contains all notes of 2018 in one policy next to policies organized by patch day date (like ABAP_snotes_patchday_2018-**01**.xml for patch day in Jan 2018). You are going to choose the policy id in FRUN CSA validation to start the compliance checks, so the policy content defines the number of checks you see in one run.  

In MiscPolicies/ABAPSPStackAge the policy age_of_sap_basis.xml is provided which is able to measure if a SAP Basis component of an ABAP system is older than 24 month to understand if the support with SAP security notes is still guaranteed. 
As of FRUN 3.0 FP01 the policy 'Age of component level 3.0 FP01.xml' in subfolder 'FRUN3.0 FP01 AgeOfComponents' provides this information for the SAP softwarecompents of a system.
As of FRUN 3.0 FP01 there is a feature provided to 'Import CSA Container'. A containers include a Composite Policy. The import provides the composite policy and its single policies. The folder 'FRUN3.0 FP01 Containers' offers those containers that can be downloaded and imported into FRUNs CSA Policy Management. More information in the README file of this folder.

# Limitations
The number of check items is not limited per policy, however, as a rule of thumb you should not add more than approximately 100 check items to a single policy.
# Known Issues
Within the compliant and non-compliant element text you need to escape the operators ">" and "<" 
```
> &gt;
< &lt;
```
Example (ABAP password length parameter rule - compliant if greater equal 8)
```
   <compliant>
       NAME = 'login/min_password_lng' and VALUE &gt;= 8
   </compliant>
```
# How to obtain support
Please report issues in Focused Run Advanced Configuration Monitoring using SAP's product support channels.
For questions regarding the provided policies or scripts please use this [issue template](https://github.com/SAP/frun-csa-policies-best-practices/issues).

# To-Do (upcoming changes)
Updates will be provided monthly to cover security note checks.

# License
Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.

