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


Reproducing the GEPD indicators using STATA software

Created: December 2023  
Last Updated: March 2024  
Last updated by: Mohammed EL-Desouky

[About this guide [1](#about-this-guide)](#about-this-guide)[\[Step 1\]:
Cloning the GitHub folder to your local device
[2](#step-1-cloning-the-github-folder-to-your-local-device)](#step-1-cloning-the-github-folder-to-your-local-device)
[\[Step2\]: Downloading the raw school data from the survey solution to the
cloned folder
[2](#step-2-downloading-the-raw-school-data-from-the-survey-solution-to-the-cloned-folder)](#step-2-downloading-the-raw-school-data-from-the-survey-solution-to-the-cloned-folder)
[\[Step3\]: Merging teachers' modules
[3](#step-3-merging-teachers-modules)](#step-3-merging-teachers-modules)[Fuzzy
matching [3](#fuzzy-matching)](#fuzzy-matching)
[\[Step 4\]: Running the initialization do-files
[4](#step-4-running-the-initialization-do-files)](#step-4-running-the-initialization-do-files)
[\[Step5\]: Running the cleaning and processing do-files
[4](#step-5-running-the-cleaning-and-processing-do-files)](#step-5-running-the-cleaning-and-processing-do-files)
[\[Step6\]: Cleaning public officials' data
[5](#step-6-cleaning-public-officials-data)](#step-6-cleaning-public-officials-data)[\[Step
7\]: Cleaning experts’ (policy) survey data
[6](#step-7-cleaning-experts-policy-survey-data)](#step-7-cleaning-experts-policy-survey-data)[\[Step
8\]: Running the indicators R-script
[6](#step-8-running-the-indicators-r-script)](#step-8-running-the-indicators-r-script)[\[Step
9\]: Running the visualization R-script
[7](#step-9-running-the-visualization-r-script)](#step-9-running-the-visualization-r-script)[\[On-demand
requests\]: additional notes
[7](#on-demand-requests-additional-notes)](#on-demand-requests-additional-notes)

# 

# **About this guide**

This is a step-by-step guide on how to implement the procedures for the
GEPD’s country raw data processing. It details the sequence of
operations and steps, as well as the inputs and the expected outputs
files for each step. Moreover, this guide will provide instructions on
how to produce an “.xls” file with country indicators and the production
of standard visuals to be used for the PowerPoint slideshow.

**Main language**: <u>Stata 17 and +</u> (note that older versions of
Stata are not compatible)

**Assisting language**: <u>R + RStudio</u>

*Ensure that both software installations are installed and updated
before commencing.*

# **\[Step 1\]: Cloning the GitHub folder to your local device**

This is an important step to ensure that the directory settings
specified in the .do files work with no issues. Users must first clone
this GitHub folder to their local devices. <u>Make sure that GitHub
Desktop application is installed on your Mac or Windows machines</u>,
then you can proceed as follows:

1.  At the top right of the GitHub page, right click on the
    \<\<**Code**\>\> tab, then select the option to open the folder with
    GitHub Desktop.

2.  Set the directory path to where you would like the clone to be
    placed, then click \<\<**Clone**\>\>.

If everything is done correctly you should have an exact copy of this
GitHub folder on your local computer with all the necessary folder
structure, Stata code files and the temp files needed to reproduce the
GEPD indicators.

Throughout this document, we will be referring to the structure of the
cloned folder which is divided into sub-folders as follows:

**01_GEPD_raw_data**; where raw data is downloaded into from survey
solution  
**02_programs**; where all the processing scripts exists  
**03_GEPD_processed_data**; where the merged, cleaned and anonymized
datasets are saved.  
**04_GEPD_Indicators**; where the standard list of GEPD indicators is
saved.

*Note that this structure is standard, regardless of the country of
implementation.*

# **\[Step 2\]: Downloading the raw school data from the survey solution to the cloned folder**

Once you have cloned the file successfully, you will notice that the
sub-folder \<\<01_GEPD_raw_data\School\>\> is empty. The user will need
to download all the raw data files for schools into this folder from the
survey solution. Please note that: the data files will be downloaded
into the previously specified path, opened by Stata once, then they will
never be touched again along the process to avoid being altered.

A user must download all the data files related to school, teachers,
grade-1, grade-4, public officials and policy survey into that folder.

*Note: If you do not have a survey solution account, please get in touch
with the technical team of the GEPD.*

# **\[Step 3\]: Merging teachers' modules**

Teachers are being surveyed in different modules (hence different
datasets) and all can be downloaded as separate data files from the
survey solution. However, for the processing do-files to work as
intended, teachers' modules must be combined into a single data file. A
heritage procedure attempts to do that using a fuzzy matching technique,
which was developed to overcome the issue of having the same teacher
given different IDs across modules. Nonetheless, a researcher may find
it unnecessary to use that technique since for present and future
implementations, having consistent teacher IDs across all the modules is
being addressed.

To combine teachers’ modules, a user would need to execute a “joinby”
command, or similar commands, which matches all modules based on two key
variables “school_code” and “teacher_id”.

In case a user may need to use the fuzzy matching procedure, below are
some detailed instructions on how to perform it.

## **Fuzzy matching** 

Fuzzy matching is used instead of a typical unique ID matching due to
the fact that, in certain occasions, “**teacher name - teacher id -
school code”** combinations are not consistent across all modules. For
example, teacher A can have teacher ID1 in our roster but teacher ID 2
in our pedagogy module. To match as many teachers as possible, we use a
fuzzy match process.

The general idea of this process is that we start with our roster data.
The roster should be the most complete list of teachers you can have. We
then match each module, pedagogy, assessment and questionnaire, to
roster on “**teacher name - teacher id - school code”**”. [You can find
all scripts for the fuzzy match
here.](https://worldbankgroup.sharepoint.com/:f:/r/sites/HEDGEFiles/Shared%20Documents/GEPD-Confidential/General/LEGO_Teacher_Paper/1_code/1_cleaning?csf=1&web=1&e=wlHSLP)

Please note that: The fuzzy match is not a perfect process. In most
cases, there is a certain percentage of observations that a user would
need to match manually, by checking out teachers’ information (name, ID,
school code) in a given module, and see how those incidences are listed
against the raster (confirming that the teachers indeed exist in the
raster file and copy and paste their correct IDs).

Please note: part of the fuzzy matching codes include some processing in
Python language, so make sure you have it installed on your drive. The
Python (.py) script could be called and executed from within the Stata
do.file.  
  
<span class="mark">There are</span> <span class="mark">three sequential
steps involved while undertaking the fuzzy matching:</span>

1.  line on first step (python script) -- what it does.

2.  line on the merging script (Stata script) -- what it does.

3.  lline on the cleaning script (Stata script) -- what it does.

Once the teachers' modules are merged, the resulting teachers file can
be saved in the same raw data directory under the title
“**teachers.dta**”

# **\[Step 4\]: Running the initialization do-files**

Before running any of the processing code files, a user must run the
initialization do-files **\<\<parameters\>\> and**
\<\<**profile_GEPD**\>\> in the path
\<\<**..\GitHub\GEPD_Production**\>\>. These do-files will set the
parameters and directories for Stata to ensure consistency across
different users. A user must run them in order as follows:

1.  Run the parameters do-file, then on the same opened Stata console;

2.  Run the profile_GEPD.do

3.  The profile_GEPD will run and prompt the user to manually select
    another parameters do-file namely “Run_GEPD.do” in the same
    directory as the other two do-files.

If they all run successfully, the do-file will terminate without any
error displayed.

# **\[Step 5\]: Running the cleaning and processing do-files**

After running the previous step, <u>on the same opened STATA
console</u>, run the processing do-files. The folder
\<\<**02_programs\School**\>\> include the four do-files needed to
produce the necessary cleaned and merged datasets, and they must be run
in order: -

1.  <u>01_school_run:</u> This is the master do-file which runs initial
    checks, defines some global parameters and directories, and runs all
    the following do-files.

2.  <u>02_school_data_merge:</u> runs a program to merge (g1 students,
    g4 students, teachers and school modules) with weights, strata and
    other observable characteristics such as the location of the school
    (e.g. urban/rural). The input data is the downloaded raw data which
    are prespecified in the script (a user would not need to select them
    manually). The outcome is four data files for each of those groups
    and are saved automatically in \<\<**03_GEPD_processed
    \School\Confidential\Merged**\>\>.

3.  <u>03_school_data_cleaner</u>: This do-file cleans the data produced
    from the previous step and aggregates correlated variables to
    produce the GEPD indicators. The outcome is the four data files, as
    above, but cleaned, for each of those groups and are stored
    automatically in \<\<**03_GEPD_processed
    \School\Confidential\Cleaned**\>\> folder.  
      
    *<u>Note: These datasets are only meant to be used by the WB team
    and not meant to be shared publicly since they are not yet
    anonymized.</u>*

4.  <u>04_school_data_anonymizer:</u> This do-file anonymizes the data
    files produced from the previous step and stores the anonymized
    version of the cleaned four school-level data files
    in\<\<**03_GEPD_processed\School\Confidential\Cleaned\Anonymized**\>\>.

    *Note (1): this step is fundamental before enabling the data
    publicly or sharing them outside/beyond the operational and central
    GEPD team. These datasets can be shared publicly in accordance with
    the World Bank’s policies and statistical disclaimer guidelines.*

    *Note (2): the anonymization do-file details the steps and codes
    required to anonymize each of the four files, nonetheless, some of
    the anonymization procedure requires some customization and tailored
    changes because it relies on the underlying distribution of some
    variables; which changes for each country. Therefore, it is highly
    recommended to execute this do-file outside the data processing
    workflow highlighted above and, in a line-by-line fashion. Detailed
    information on how to carry out those customizations is provided in
    the do-file.*

    *Note (3): Anonymization may affect the distribution and variability
    of some variables. Therefore, to ensure accurate estimates and
    analysis, it is recommended to use the confidential version of the
    data for the analysis, and the anonymized version only for public
    sharing.*

    *Note (4): Because of its sensitive nature, public officials' data
    is not part of the anonymization procedure, therefore, it is
    forbidden to share them publicly to preserve the confidentiality of
    the interviewed officials.*

# **\[Step 6\]: Cleaning public officials' data**

The process to clean public official data is nearly identical to
cleaning school-level data mentioned previously. The input data (raw
data files downloaded from survey solution) is located in
\<\<**01_GEPD_raw_data/Public_Officials/public_officials.dta**\>\>.

To clean the data, a user would need to execute two do files located in
\<\<**02_programs/Public_Officials/Stata**\>\>:

1.  The parameters and master do “01_public_officials_run.do” then;

2.  Run the cleaning do-file “02_public_officials_data_cleaner.do"

Once the cleaning script is run successfully, the cleaned data can be
found in
\<\<**03_GEPD_processed_data\Public_Officials\Confidential**\>\>.

# **\[Step 7\]: Cleaning experts’ (policy) survey data**

Policy (expert) survey is being revamped; therefore, the technical team
has decided to refrain from developing a Stata script to process this
data until the revamp has been concluded to ensure that the coding
script is consistent with the most up-to-date questionnaire and
questions.

Meanwhile, expert data can only be processed using an R-script
“policy_survey.Rmd**”**. The script is found in
\<\<**/02_programs/Policy_Survey/R**\>\>. This script is pre-written and
data directories are defined and sat and can be run once without a need
to customize any parts of the codes.

<u>The only part of the script that would require changes is located at
the top of the script, under the subtitle “Country name and year of
survey”. A user must adapt the country information based on the
information of the country of the current GEPD implementation. Detailed
guidance on each step is given directly within the R-script.</u>

Once the cleaning script is run successfully, the cleaned data can be
found in \<\<**03_GEPD_processed_data/Policy_Survey**\>\>.

# **\[Step 8\]: Running the indicators R-script**

Once the data (school – public officials – policy survey) has been
merged and cleaned from the previous steps, a user may proceed with
running the indicators’ R-script which pulls all the cleaned datasets,
aggregates them and produce a list of standard and ready-to-report on
GEPD indicators. The R-script also organizes this standard list on
indicators into an (.xlsx) file and saves it to
\<\<**04_GEPD_Indicators**\>\>.

Prior to running the r-script, a user must make sure that three
temp-files are already part of the cloned folder:

1.  GEPD_indicator_template; which shall exist in  
    \<\<**04_GEPD_Indicators**\>\>

2.  Finance_scoring; which shall exist in  
    \<\<**03_GEPD_processed_data/Other_Indicators**\>\>

3.  Learners_defacto_indicators; which shall exist in  
    \<\<**03_GEPD_processed_data/Other_Indicators**\>\>

The R-script is titled “GEPD_indicators.R” and can be found in
\<\<**02_programs/GEPD_Indicators**\>\>. This script is pre-written and
data directories are defined and sat and can be run once without a need
to customize any parts of the codes. However, in certain incidences, the
script may fail to execute because of how the directories are specified.
If this is the case, a user can easily troubleshoot that by redefining
the directories for the input-data files. The resulting (.xlsx) file can
be used to populate the GEPD country’s PowerPoint slides.  
  
<u>The only part of the script that would require changes is located at
the top of the script, under the subtitle “Country name and year of
survey”. A user must adapt the country information based on the
information of the country of the current GEPD implementation. Detailed
guidance on each step is given directly within the R-script.</u>

# **\[Step 9\]: Running the visualization R-script**

The final step that completes the data processing workflow is to produce
visualizations to be used for demonstration within the country’s
PowerPoint slides. Inherently, there are a set of standard
visualizations/graphs that are being used across all countries, and
these standard graphs are produced using R-package “ggplot2”.

The script to produce those graphs is titled “GEPD_powerpoint.qmd” and
it is an R Markdown-based script that is located in
\<\<**2_programs/GEPD_Indicators** \>\>. Similar to the other previous
R-Script, this script can be executed all at once without a need to
customize the codes. However, <u>the only part of the script that would
require changes is located at the top of the script, under the subtitle
“Country name and year of survey”. A user must adapt the country
information based on the information of the country of the current GEPD
implementation. Detailed guidance on each step is given directly within
the R-script.</u>

This script produces a set of graphs, and the user could opt to export
them individually, then import them into the country’s PowerPoint
slides.

# **\[On-demand requests\]: additional notes**

The procedure detailed through the above-mentioned steps shall suffice
to produce the standard country analysis, which is required to present
the results to country teams and national governments to assess
educational system quality and obtain the necessary validations to
publish the results. In certain occasions, additional analysis and/or
disaggregation are demanded by country teams or national governments. In
this case, the GEPD team has authored an additional Stata coding script
to automate the generation of some of these analytical requests, and to
reduce the time needed to respond to them, compared to coding the
analysis from scratch every time a request emerges.

Currently, this script exists only for Chad, but it can be generalized
to other country-implementations. The script is called
“Chad_additional_analysis” and is located in
\<\<**GEPD_Production-Chad/05_Additional_Analysis**\>\>.

In the meantime, the technical team is looking for ways to integrate
this analysis into the data processing workflow, so that a user could
run the same scripts in the steps from 1 to 9 and obtain all the desired
outcomes (cleaned datasets, indicators, visualizations and on-demand
analysis), without needing to call the on-demand analysis do-file
separately. This shall streamline the production of those analytical
products and prevent confusions of which scripts need to be run and for
which reasons. <u>Once this has been finalized, this section on
on-demand requests will be readdressed and updated.</u>






