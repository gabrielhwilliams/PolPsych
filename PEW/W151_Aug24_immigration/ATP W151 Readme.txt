PEW RESEARCH CENTER
Wave 151 American Trends Panel 
Dates: Aug. 5 to Aug. 11, 2024
Mode: Web and CATI
Sample: Full panel
Language: English and Spanish
N=9,201 

***************************************************************************************************************************
NOTES

This dataset contains the variables corresponding to questions asked in the survey. It also contains administrative data, such as the main production weight and completion date. There are several types of additional variables that we can typically provide upon request, if they were created for published reporting: 
(1) Researcher-created variable(s) reflecting how we categorized responses to open-ended questions. We do not release verbatim answers to open-ended questions, in the interest of protecting panelist anonymity.
(2) Researcher-created variables needed to replicate published analysis (e.g., an index using several questions).
(3) Special weights needed to replicate published analysis. The main production weight is included in the public dataset. Special weights refer to those used for unusual, bespoke analysis. We can provide existing special weights upon request so long as the analysis they support does not pose a risk to panelist anonymity.

For a small number of respondents with high risk of identification, certain values have been randomly swapped with those of lower risk cases with similar characteristics.

VOTEGEN24/VOTE_MOTIV
In the dataset, VOTEGEN24_W151 and VOTE_MOTIV are filtered on those who say they are registered to vote (F_REG=1).

HORSE_W149/HORSE_W151
The W151 dataset contains two created variables indicating 2024 presidential vote preference. HORSE_W151 comes from ATP W151, and HORSE_W149 is a measurement from ATP W149, which fielded from July 1 to July 7, 2024. 

NATIVITY_W151/IMMGEN_W151
The W151 dataset contains two created variables indicating respondent's nativity (NATIVITY) and immigrant generation (IMMGEN). 

MOTHERNAT/FATHERNAT 
Responses to MOTHERNAT and FATHERNAT have been back coded in the dataset. 


***************************************************************************************************************************
WEIGHTS 

WEIGHT_W151 is the weight for the sample. Data for all Pew Research Center reports are analyzed using this weight.
WEIGHT_W149_W151 is a special weight that should be used to replicate findings from the report, "Harris Energizes Democrats in Transformed Presidential Race"

***************************************************************************************************************************
Releases from this survey:

August 14, 2024. “Harris Energizes Democrats in Transformed Presidential Race.” 
https://www.pewresearch.org/politics/2024/08/14/harris-energizes-democrats-in-transformed-presidential-race/ 

August 26, 2024. “The Political Values of Harris and Trump supporters.” 
https://www.pewresearch.org/politics/2024/08/26/the-political-values-of-harris-and-trump-supporters/ 

September 27, 2024, "Trump and Harris Supporters Differ on Mass Deportations but Favor Border Security, High-Skilled Immigration"
https://www.pewresearch.org/race-and-ethnicity/2024/09/27/trump-and-harris-supporters-differ-on-mass-deportations-but-favor-border-security-high-skilled-immigration/

October 21, 2024, "Most U.S. voters say immigrants – no matter their legal status – mostly take jobs citizens don’t want"
https://www.pewresearch.org/short-reads/2024/10/21/most-us-voters-say-immigrants-no-matter-their-legal-status-mostly-take-jobs-citizens-dont-want/

November 22, 2024, "Most Americans say undocumented immigrants should be able to stay legally under certain conditions"
https://www.pewresearch.org/short-reads/2024/11/22/most-americans-say-undocumented-immigrants-should-be-able-to-stay-legally-under-certain-conditions/

December 19, 2024, "Americans lean toward keeping legal immigration steady, see high-skilled workers as a priority"
https://www.pewresearch.org/short-reads/2024/12/19/americans-lean-toward-keeping-legal-immigration-steady-see-high-skilled-workers-as-a-priority/

March 17, 2025, "How Americans feel about making English the official language of the U.S."
https://www.pewresearch.org/short-reads/2025/03/17/how-americans-feel-about-making-english-the-official-language-of-the-us/

June 10, 2025, "U.S. public is split on birthright citizenship for people whose parents immigrated illegally"
https://www.pewresearch.org/short-reads/2025/06/10/us-public-is-split-on-birthright-citizenship-for-people-whose-parents-immigrated-illegally/

***************************************************************************************************************************

SYNTAX

**HORSE variable syntax**

compute HORSE_W151 = $sysmis.
do if F_REG=1.
if (VOTEGEN24_W151=1 or VOTEGEN24_LEAN_W151=1) HORSE_W151 = 1.
if (VOTEGEN24_W151=2 or VOTEGEN24_LEAN_W151=2) HORSE_W151 = 2.
if (VOTEGEN24_W151=3 or VOTEGEN24_LEAN_W151=3) HORSE_W151 = 3.
if (VOTEGEN24_LEAN_W151=4) HORSE_W151 = 4.
if (VOTEGEN24_LEAN_W151=99) HORSE_W151 =99.
end if.
VARIABLE LABELS HORSE_W151 'Combined horserace variable for W151'.
VALUE LABELS HORSE_W151 1 'Trump/Lean Trump' 2 'Harris/Lean Harris' 3 'Kennedy/Lean Kennedy' 4 'Lean toward none' 99 'Refused VOTEGEN24_LEAN'.
EXECUTE.


**IMMGEN variable syntax**

compute fathernat2=99.
if (FATHERNAT_W151=1 or FATHERNAT_W151=2 OR FATHERNAT_W151=3) fathernat2=1.
if FATHERNAT_W151=4 fathernat2=2.
compute mothernat2=99.
if (MOTHERNAT_W151=1 or MOTHERNAT_W151=2 OR MOTHERNAT_W151=3) mothernat2=1.
if MOTHERNAT_W151=4 mothernat2=2.
EXECUTE.
 
compute IMMGEN_W151=99.
if NATIVITY_W151=2 IMMGEN_W151=1.
do if NATIVITY_W151=1.
if (MOTHERNAT_W151=4 OR FATHERNAT_W151=4) IMMGEN_W151=2.
if (mothernat2=1 AND fathernat2=1) IMMGEN_W151=3.
end if.
VARIABLE LABELS IMMGEN_W151 'Immigrant generations, including P.R. and other territories as U.S. born'.
VALUE LABELS IMMGEN_W151 1 'Foreign born w/o P.R. and other territories' 2 'Second generation' 3 'Third generation' 99 'No answer'.
EXECUTE.


**NATIVITY variable syntax**

* Create a new variable NATIVITY and initialize to 0.
COMPUTE NATIVITY = 0.

* Assign 1 to NATIVITY if F_BIRTHPLACE is 1, 2, or 3.
IF (F_BIRTHPLACE = 1 OR F_BIRTHPLACE = 2 OR F_BIRTHPLACE = 3) NATIVITY = 1.

* Assign 2 to NATIVITY if F_BIRTHPLACE is 4.
IF (F_BIRTHPLACE = 4) NATIVITY = 2.

* Assign 99 to NATIVITY if F_BIRTHPLACE is 99.
IF (F_BIRTHPLACE = 99) NATIVITY = 99.

* Add labels for the variable NATIVITY.
VARIABLE LABELS NATIVITY "Nativity".

* Add value labels for NATIVITY categories.
VALUE LABELS NATIVITY
    1 "U.S. born"
    2 "Immigrant"
    99 "Refused".

