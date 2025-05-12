# Chesapeake Bay Watershed Analysis

## Overview

This project examines the Chesapeake Bay watershed between the years 1985
and 2023 and identifies land cover trends and the effects of runoff pollution. Our
intended audience is policymakers, conservationists, and environmental scientists, as
our intention is to raise awareness of runoff pollution, and how this can affect both
human developments and the watershed itself. We determined the runoff coefficient of
different land cover types, which can be used to describe the amount of runoff that
would enter the bay from these locations. We used this data to determine the runoff risk
data, which was quantified by multiplying the coefficient by the topographic slope of any
given area. This is directly correlated to the amount of pollution that those areas would
contribute to the watershed – as such, we were able to determine which areas of the
watershed would be most likely to feel the effects of runoff-based pollution.

## Data

This project used two datasets. One, a 30 meter digital elevation model, was
obtained from Google Earth Engine; the other was a land cover dataset obtained from
the NLCD for years 1985 through 2023. We had a 30 meter land cover raster for each
year in 1985 through 2023, so including the DEM in total we had 39 rasters clipped to
the extent of the Chesapeake Bay Watershed for a total of over 13 GB.

There were no preparation steps needed to make the data usable — both
datasets were clipped to the extent of the Chesapeake Bay Watershed by the data
source. However, given the size of the data, we did have to alter the scale of the project
when analyzing trends across the 1985-2023 land cover data. To solve this problem, we
mostly used a Jupyter Notebook in Arc to have more control over the environment.

## Methods

The first step in this analysis was to create a slope raster; this is important to
calculate the runoff potential throughout the watershed. To create the slope raster we
used the slope tool in Arc to create the slope from the DEM. After this, we mostly
worked in a Jupyter Notebook with Arc.
Given that we had about 12.5 GB in land cover data, we decided to load in each
year’s land cover raster individually with a goal of calculating the runoff potential, zonal
statistics, and summarizing the year as best as possible, then move on to the next year.

### Calculating Runoff Potential

First we loaded in
the packages, only using
arcpy for this part of the
project. Adjacent is the
function used to calculate
runoff potential. After
running this function, we were left with a raster, runoff potential, and zonal statistics summary tables for that year.

### Land Cover analysis

We would use multiple methods to examine land cover trends more specifically.
We used a change detection method where we reclassified 1985 and 2023 into two
broad groups, manmade and natural, to see the change in these groups over time. We
also looked at changes in
land cover types from
1985 to 2004 to 2023. We
achieved this by turning
the rasters into numpy
arrays, then stacking
them and counting the
combinations to analyze
more minute land cover
transitions. The code is
provided here.

## Results

## Discussion

## Conclusion





