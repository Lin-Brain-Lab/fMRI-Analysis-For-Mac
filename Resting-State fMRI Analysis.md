# Resting-State fMRI Analysis
Single-subject resting-state fMRI analysis using seed-based correlation. fMRI time series at a given seed (such as the mPFC for the DMN) brain location is used to correlate with the fMRI time series at other brain locations. The distribution of brain regions showing significant correlation to the chosen seed consists of a resting-state network. Here we chose the hippocampus as the seed region for its functional role in memory.

## Pre-processing 
1. Pre-process the data following steps up to co-registeration from the [fMRI Pre-Processing page](https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/blob/main/fMRI%20Pre-Processing.md)

## Co-registeration 
For this this pre-processing, fMRI data should be co-registered to structural MRI with FreeSurfer reconstruction
1. `/Applications/MATLAB_R2023b.app/bin/matlab &` open MatLab through terminal
2. Run startup.m
3. `setenv ('SUBJECTS_DIR','/Users/jessica/data_analysis/seeg/subjects');` set your subject directory
4. 
