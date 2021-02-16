Created on 2020-01-06
 ----- GENERAL INFORMATION -----
DATA TITLE: Distance, environmental, and habitat data for breeding marsh birds surveyed in Iowa wetlands.
PROJECT TITLE: Detection and density of breeding marsh birds in Iowa wetlands
DATA ABSTRACT: This data set includes information from surveys conducted for breeding marsh birds in restored and soon-to-be-restored shallow lakes in Iowa. These shallow lakes are managed by the Iowa Department of Natural Resources (DNR). We conducted point counts at shallow lakes during the summers of 2016 and 2017. We recorded the distance between the observer and the individual birds in order to calculate density estimates using distance sampling techniques. We also recorded environmental and habitat variables that may influence the detection of these species. Detection-adjusted estimates were used to assess changes in breeding bird density across shallow lakes in three restoration states: not restored, 1-5 years after restoration, and 6-11 years after restoration.  These values can be used by the Iowa DNR to assess the impact of restoration on the density of breeding marsh birds. 

AUTHORS: 
Author: Rachel A. Vanausdall
ORCID: https://orcid.org/0000-0003-2649-0602
Institution: Colorado State University 
Email: rachel.vanausdall@colostate.edu

Author: Stephen J. Dinsmore
Institution: Iowa State University
Email: cootjr@iastate.edu

Corresponding author: Rachel A. Vanausdall

ASSOCIATED PUBLICATIONS: Vanausdall, R. A. and S. J. Dinsmore. Detection and density of breeding marsh birds in Iowa wetlands. PloS ONE, in press.

COLLECTION INFORMATION:
	Time period(s):  Summers 2016-2017
	Location(s): North-central and north western Iowa (list of properties included)

----- FILE DIRECTORY -----
BreedingMarshBirds_codebook.csv
VIRA_PBGR_Data.csv
MAWR_YHBL_RWBL_COYE_SWSP_Data.csv
BreedingMarshBirds_SpeciesInfo.csv
BreedingMarshBirds_SurveyedSites.csv

----- FILE LIST----- 
A. BreedingMarshBirds_codebook – defines variables for the 2 data files.
B. VIRA_PBGR_Data – distance, environmental, and habitat variables from surveys for secretive marsh birds (Virginia Rail, Pied-billed Grebe)
C. MAWR_YHBL_RWBL_COYE_SWSP_Data - distance, environmental, and habitat variables from surveys for marsh passerines (Marsh Wren, Yellow-headed Blackbird, Red-winged Blackbird, Common Yellowthroat, Swamp Sparrow)
D. BreedingMarshBirds_SpeciesInfo – provides scientific names and a link to the Integrated Taxonomic Information System for each bird species.
E. BreedingMarshBirds_SurveyedSites – the names, UTM coordinates, and counties of surveyed sites. Site names marked with an * represent restored sites.

----- METHODS AND MATERIALS -----  

---------- DATA COLLECTION METHODS ----------
We conducted unlimited-radius 10-min point counts throughout each wetland. Points were situated randomly in wetlands, and the number of points depended on the size of the wetland. We estimated cloud cover using four categories: (0) few or no clouds, (1) partly cloudy, (2) overcast, and (3) fog. Upon initial detection, the observer recorded the exact distance (m) to the bird using a laser range-finder. To improve the detection of secretive marsh birds (e.g., rails, bitterns), we incorporated call-broadcasts into the survey period according to methods described by the North American Marsh Bird Monitoring Protocol. The first 5 min of each survey was a passive period (i.e., no recordings) followed by 5 min of recorded calls. Each minute corresponded to a species; the first 30 s included a recording of the particular species, followed by 30 s of silence. The sequence of calls we used, from first to last, was Least Bittern, Sora (Porzana carolina), Virginia Rail (Rallus limicola), King Rail (Rallus elegans), and Pied-billed Grebe (Podilymbus podiceps). Except for the King Rail, these are regular breeders in Iowa. In previous call-broadcast surveys conducted in Iowa, the King Rail did not have many detections, but Sora and Virginia Rail tended to respond to King Rail calls as readily as they responded to intraspecific calls. We used an MP3 player (SanDisk Sansa Clip 1GB, SanDisk Corporation, Milpitas, California) attached to portable speakers (JBL Flip 3, Harman International Industries, Inc., Stamford, Connecticut) and broadcast at 90 dB from a distance of 1 m in front of the speakers. The speaker faced the interior of the wetland and was 0.5 m from the ground or water surface. Our methods for recording detections of secretive marsh birds were the same as for marsh passerines, but we also recorded the call types of detected secretive marsh birds.
	After each survey at every point we recorded seven habitat covariates following methods suggested by and similar to. Within 50 m of each point, we visually estimated the percent cover of the dominant vegetation types, which tended to include cattail (Typha sp.), bulrush (Schoenoplectus sp.), river bulrush (Bulboschoenus fluviatilis), or reed canary grass (Phalaris arundinacea) to the nearest 5%. We also estimated the percent cover of open water. Other less dominant vegetation types were grouped into a single category and were not used for analysis. Together these values summed to 100%.

---------- DATA PROCESSING METHODS ----------
We used the provided csv files and included all surveys, even if a species of interest was not detected at a survey. Each row with a species represents an individual detected during a survey.

---------- SOFTWARE ----------
Name: R
Version: 3.6.2
System Requirements: Windows 10, 256 MB of RAM
URL: http://www.rproject.org/
Developer: R Foundation for Statistical Computing

Name: Distance Sampling in R
Version: Issue 1
System Requirements: R, Windows 10, 256 MB of RAM
URL: http://doi.org/10.18637/jss.v089.i01
Developer: David L. Miller, Eric Rexstad, Len Thomas, Laura Marshall, Jeffrey L. Laake

------- LICENSING -------
This work is licensed under a Creative Commons Attribution 4.0 International License.
https://creativecommons.org/licenses/by/4.0/ 
