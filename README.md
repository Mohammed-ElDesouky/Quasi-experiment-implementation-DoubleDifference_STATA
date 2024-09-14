# Quasi-experiment-implementation-DoubleDifference_STATA
This is a showcase code from a real quasi-experiment (Diff-in-Diff) evaluation I led with Save the children US in Iraq to estimate the effect of changes in caregiver perception on child rearing practices and early childhood development. 

#### Study objectives 
The goal of the objectives is to understand the relationship between changes in caregivers’ practices and children’s early learning and development; Specifically: 
- Caregiver participants’ at home practices, positive parenting practices, play-based interactions, self-care and regulation over the course of the intervention
- Male caregivers behavior that fosters non-violent, positive home environment
- Children’s learning and development outcomes measured by CREDI (0-3) and IDELA (3-5)

#### Data and target group
This study used a longitudinal mixed-methods approach to document changes in perceptions and practices around early child development and caregivers’ practices in communities implementing the ECD Toxic Stress Mitigation Toolkit. The study focused on caregivers and parents of young children, and children aged zero to six years old.

- ##### Iraq Sample
  The baseline sample in Iraq include 495 caregivers and 218 3 to 6 year old children children. At endline, 302 caregivers were matched.

#### Findings
The study results displayed a significant and positive correlation (effect size) with four caregiver outcome indicators: caregiver child relationship, learning and playing, caregiver resilience, caregiver self-efficacy. On the other hand, the findings were insignificant for the remaining three outcomes: gender-based attitudes, gender-based practices and caregiver perceived stress, suggesting no program effect on these three outcomes. In addition, the heterogenous effect estimates, exploration of effect size by gender, showed that male caregivers had a larger and statistically significant effect size for: caregiver-child relationship, caregiver resilience and caregiver self-efficacy. Female caregivers displayed a higher effect size on only one outcome-- learning and playing activities. Moreover, educational level was a significant predictor of the seven outcomes. family size was, as well, a strong predictor of caregiver perceived stress.


# **GEPD Data Workflow: Step-by-Step Guide**

**A guide for going from raw Global Education Policy Dashboard (GEPD) data to a set of key microdata files and indicators.**

Created: December 2023  
Last Updated: September 2024
Last updated by: Mohammed EL-Desouky

**Content**
[About this guide 1](#about-this-guide)

[[Step 1]: Cloning the GitHub folder to your local device 2](#step-1-cloning-the-github-folder-to-your-local-device)

[Adding local repository (recommended) 2.1](#adding-local-repository-recommended)

[Clone the GitHub repository 2.2](#clone-the-github-repository)

[[Step 2]: Downloading the raw data from Survey Solutions to the cloned folder 3](#step-2-downloading-the-raw-data-from-survey-solutions-to-the-cloned-folder)

[[Step 3]: Merging teachers' modules 4](#step-3-merging-teachers-modules)

[[Step 4]: Running the initialization do-files 5](#step-4-running-the-initialization-do-files)

[[Step 5]: Running the cleaning and processing do-files 6](#step-5-running-the-cleaning-and-processing-do-files)

[[Step 6]: Cleaning public officials' data 7](#step-6-cleaning-public-officials-data)

[[Step 7]: Cleaning policy (experts) survey data 8](#step-7-cleaning-policy-experts-survey-data)

[[Step 8]: Producing the GEPD key indicators 9](#step-8-producing-the-gepd-key-indicators)


## **About this guide**

This is a step-by-step guide on how to process the GEPD raw survey data and produce a set of key microdata files and indicators. This guide details the sequence of operations and steps, as well as the inputs and the expected outputs files for each step.

The GEPD collects country-level data through administering a survey with a set of modules:  

1. School modules (school-level questionnaire, student-level questionnaire for Grades 4 and 1, and teacher-level questionnaire);  
2. Public officials' module (Survey of Public Officials); and 
3. Policy module (Policy Survey).  

This guide provides instructions on how to go from the raw data extracted from Survey Solutions, a software for data collection and survey management, to the production of a set of data and files essential for assessing national educational outcomes, specifically:  

1. Combined and cleaned datasets for different modules; 
2. GEPD key indicators’ list; 

**Main language**: Stata 17 and higher (note that older versions of Stata are not compatible)

**Assisting language & tools**: R, RStudio and GitHub Desktop

_Ensure that both software installations are installed and updated before running the code._

## **[Step 1]: Cloning the GitHub folder to your local device**

The raw data is downloaded from the survey solution and is saved on OneDrive; inside the respective country folder. These folders are added to GitHub as repositories to facilitate country collaboration and version control.

Inside each country’s folder/repository, the data workflow is organized across four sub-folders:

1. **01_GEPD_raw_data**; contains the raw data files downloaded from the GEPD Survey Solutions Server.  This folder contains three subfolders: a `School` folder for school data, a `Public_Officials` folder for data from the Survey of Public Officials, and a `Policy_Survey` folder for data from the expert Policy Survey.   
2. **02_programs**; contains the scripts that will be used to clean and process the raw data. There are separate sub-folders for each of the three data sources: `School`, `Public_Officials`, and `Policy_Survey`.    
3. **03_GEPD_processed_data**; contains the cleaned and anonymized data files. There are separate sub-folders for each of the three data sources: `School`, `Public_Officials`, and `Policy_Survey`.  
4. **04_GEPD_Indicators**; contains the set of final GEPD indicators.

_Before working with the data, the user must first set-up the GitHub’s country folder/repository on the local machine either as “local repository” or “cloned repository”._

### **Adding local repository (recommended)**
This is the recommended process If using a WB machine/VDI and having access rights to OneDrive where the data is stored.

On GitHub Desktop, click <<**File**\>>, <<**Add local repository**\>>, choose the country folder on OneDrive, then <<**Add repository**\>>.

### **Clone the GitHub repository**
Alternatively, if the above-mentioned case is not applicable, a user could clone the GitHub’s country folder to their local device.

1. On the internet browser, go to the country’s repo on GitHub.
2. At the top right of the [GitHub page](https://github.com/GEPD-Production), right click on the <<**Code**\>> tab, then select the option to open the folder with GitHub Desktop.
3. Set the directory path to where you would like the clone to be placed, then click <<**Clone**\>>.

These steps will create an exact copy of this GitHub folder on your local computer with all the necessary folder structure, Stata code files and the template files needed to reproduce the GEPD indicators.

## **[Step 2]: Downloading the raw data from Survey Solutions to the cloned folder**

After the GitHub folder is cloned, the sub-folder `**01_GEPD_raw_data**` would be sub-divided into folders corresponding to the survey level: `School`, `Public_Officials`, `Policy_Survey`, and `Sampling`. The user must download and place the raw data files, from survey solution, into the corresponding sub-folder. Please note: these raw data files are loaded once into Stata, and any processing to it will be saved as a copy into a different `Cleaned folder` as we are going to explain later —**the user must avoid altering or overwriting the raw files**.

The user must download all the data files related to:

1. school, teachers, Grade 1, and Grade 4 students into the `**School**` sub-folder.   
2. public officials into the `**Public_Officials**` sub-folder.  
3. Policy survey into `**Policy_Survey**` sub-folder.  
4. Sampling and weights into `**Sampling**` sub-folder. 

The process of downloading the data is as straightforward as: (a) signing in to the administrator account on the [GEPD server](http://etri.gepd.solutions/) on Survey Solutions with the relevant credentials, (b) selecting to the relevant country workspace (in the top left corner), (c) navigating to _Data Export_ at the top panel and selected the survey template to export as well as the status _Approved by HQ_,  and, (d) downloading all relevant questionnaire data (school survey and survey of public officials) related to this country. Typically, the data is exported in Stata 14 format and includes meta information.  

To guide the user on which modules are being administered in each country, one can create a pdf download of the questionnaire in [Survey Solutions Designer](https://designer.mysurvey.solutions/) Open the questionnaire and select ‘Download PDF’ from the buttons in the top right corner of the interface. This will produce an HTML document containing questions divided by module, together with the variable names, answer options and skip patterns/constraints.  

A list is provided in the annex of what raw data files a user is expected to see downloaded into the raw data folder. A user may also note that the provided list is only a guidance, and it is not intended to be an exhaustive list of all raw data files that must exist across all countries.  

_Note: If you do not have a Survey Solutions account, please get in touch with the GEPD team at <educationdashboard@worldbank.org>_

## **[Step 3]: Merging teachers' modules**

Teachers are being surveyed in different modules (hence different datasets) and all the teachers’ data can be downloaded as separate data files from Survey Solutions. However, for the processing do-files to work as intended, teachers' modules must be combined into a single data file. A heritage procedure attempts to do that using a fuzzy matching technique, which was developed to overcome the issue of the same teacher with different IDs across modules. Note that this step is unnecessary for present implementations of the GEPD (as well as for the Punjab and Sindh provinces of Pakistan, and Edo State in Nigeria), since the teachers in these surveys have consistent IDs across modules. Nonetheless, more information on fuzzy matching can be found in the annex. 

To combine teachers’ modules, a user would need to execute a “joinby” command, or similar commands, which matches all modules based on two key variables “interview_key” and “teachers_id”.

The Stata scrip that merges teachers’ modules is titled <<**02_school_data_merge.do**>>. More information on this is provided int Step no.5 below.

Once the teachers' modules are merged, the resulting teachers file is saved in the `School` sub-folder under `**01_GEPD_raw_data**` with the title “**Country_teacher_level_test.dta**” 


## **[Step 4]: Running the initialization do-files**

Before running any of the processing code files, a user must run the initialization do-files located in the main folder titled `GEPD_CountryX`. These do-files will set the parameters and file paths for the code to run. 

1. `**GEPD_parameters.do**` allows the user to set the parameters specific to the country by specifying country name, year, strata, weight variables and file names, etc. Please adjust if needed for each country as some parameters may differ. 

2. `**profile_GEPD.do**` should be opened in the same Stata console as `parameters.do` and allows for setting up file paths and data directories. Please note that this do-file would prompt the user to select on-screen the `run_GEPD.do` inside the countries folder. Ensure to select the correct `run_GEPD.do` which is inside the country folder where the data is stored.  

## **[Step 5]: Running the cleaning and processing do-files**

After executing the previous step, **_on the same opened STATA console_**, run the processing do-files. The folder `**02_programs\School**` include three do-files needed to produce the necessary cleaned and merged datasets, which a user can either run at once by running the master script `01_school_run`, or individually. Either case, please ensure that the following do-files are loaded in the same Stata session/console that ran the `parameters` and `profile` do-files:

1. `**01_school_run**` is the master do-file which runs all the three following scripts.   

2. `**02_school_data_merge**` runs a program to merge variables from the sampling frame (weights, strata and other observable characteristics such as the location of the school) to each of the school-level datasets (g1 students, g4 students, teachers and school modules). In addition, it merges teachers’ modules and includes all the possible corrections for data entry mistakes in the school-level datasets. The input data is the downloaded raw data which is prespecified in the script. The outcome is four data files for each of those groups and are saved automatically in `**03_GEPD_processed \School\Confidential\Merged**`.  

3. `**03_school_data_cleaner**` cleans the data produced from the previous step and aggregates correlated variables to produce the GEPD indicators. The outcome is the four data files, as above, but cleaned, for each of those groups and are stored automatically in `**03_GEPD_processed \School\Confidential\Cleaned**\` folder.

_Note: These datasets are only meant to be used by the WB team and not meant to be shared publicly since they are not yet anonymized._  

4. `**04_school_data_anonymizer**` anonymizes the data files produced from the previous step and stores the anonymized version of the four cleaned school-level data files in `**03_GEPD_processed\School\Confidential\Cleaned\Anonymized**`. A user would need to tweak this do-file for each country before running it, this is an inevitable process, since part of the anonymization is country-specific. Information on what to tweak is listed inside the do-file. 

## **[Step 6]: Cleaning public officials' data**

The process to clean public official data is nearly identical to cleaning the school-level data (Step 5). School data must be cleaned before the public officials' files are cleaned. This is because the public officials are asked about teacher absence in the system and the answers are verified by checking against the GEPD teacher data.  

The raw data files downloaded from Survey Solutions are located in `**01_GEPD_raw_data/Public_Officials/public_officials.dta**`.  

To clean the data, a user would need to execute two do files located in <<**02_programs/Public_Officials/Stata**\>>:

1. The “01_public_officials_run.do”  which will serve two functions:

1.1. verify if the `profile.do` is loaded to set up the macros and paths, and if not loaded then; the user will be asked to first run the `profile.do` on the same opened Stata console, then;

1.2. Will run and execute the second do-file to process the public officials’ raw data `02_public_officials_data_cleaner.do` 

2. Once the cleaning script is run successfully, the cleaned data can be found in <<**03_GEPD_processed_data\\Public_Officials\\Confidential**>>.

## **[Step 7]: Cleaning policy (experts) survey data**

Meanwhile, expert data can only be processed using an R-script `policy_survey.Rmd` in `**/02_programs/Policy_Survey/R**`. At the top of the script, user would need to customize the information under “Country name and year of survey”. Detailed guidance on each step is given directly within the R-script. Note: to avoid problems with running any R script caused by directory set up, including the policy survey script, please open scripts using the Rstudio project titled `GEPD_Production-countryname.Rproj`, and found in the country’s folder. 

Once the cleaning script is run successfully, the cleaned data can be found in <<**03_GEPD_processed_data/Policy_Survey**\>>.

## **[Step 8]: Producing the GEPD key indicators**

The GEPD’s indicators are contained in an Excel file along with a unique key for each indicator. This file's purpose is to cstore the set of indicators published on the GEPD website and used for populating the standard GEPD PowerPoint slides. In addition, these are the indicators available on the World Bank API. See <https://databank.worldbank.org/source/education-policy>.

Once the data (school – public officials – policy survey) has been processed from the previous steps, a user may proceed with running the indicators’ R-script which pulls all the cleaned datasets, aggregates them and produce a list of standard GEPD indicators. The R-script also organizes and stores this standard list of indicators into an (.xlsx) file and saves it under `**04_GEPD_Indicators**`.  

Prior to running the R-script, a user must make sure that three template files are already part of the cloned folder:

1. GEPD_indicator_template.csv; under sub-folder  
    <<**04_GEPD_Indicators**\>>
2. Finance_scoring.xlsx; under  
    <<**03_GEPD_processed_data/Other_Indicators**\>>
3. Learners_defacto_indicators.xlsx; under  
    <<**03_GEPD_processed_data/Other_Indicators**\>>

The R-script is titled `GEPD_indicators.R` and can be found in `**02_programs/GEPD_Indicators**`. Users need to edit the information the top of the script under “Country name and year of survey”. Detailed guidance on each step is given directly within the R-script.
