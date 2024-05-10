EEG pre-processing includes

suppress gradient and pulse artifacts.
calculate event-related potentials (for event-related design).
To do EEG source analysis, follow the procedure here.

## Create Evoked Fields 
1. Download [read_erp_041019.m](https://github.com/fahsuanlin/labmanual/blob/master/scripts/read_erp_041019.m) and add it to your subjects eeg_raw folder. This script calculates evoked potentials.
2. Change the header file to your .vhdr file location
```
headerFile = {
    '../eeg_raw/SSVEP_epi_1.vhdr'
```
3. Change the marker file to your .vmrk file location associated with your header file. It is important to have only one file listed as the script expects only one.
```
markerFile={
    '../eeg_raw/SSVEP_epi_1.vmrk'
```

## Prepare Brain/Head Geometries
1. Open a new terminal window
2. `tcsh`
3. `source .cshrc`
4. `setenv SUBJECTS_DIR /Users/jessica/data_analysis/eegfmri/subjects`
5.  `cd /Users/jessica/data_analysis/eegfmri/subjects` to your subject folder
6. `mne_setup_mri --subject 180330_SYH` (there is a strong possibility that this file already exists)
7. `mne_setup_source_space --subject 180330_SYH --spacing 5` (there is a strong possibility that this file already exists)
8. `mne_watershed_bem --subject 180330_SYH` (there is a strong possibility that this file already exists)
9. `cd $SUBJECTS_DIR/180330_SYH/bem`
10. `ln -s watershed/041019_inner_skull_surface inner_skull.surf` (there is a strong possibility that this file already exists)
11. `ln -s watershed/041019_outer_skull_surface outer_skull.surf` (there is a strong possibility that this file already exists)
12. `ln -s watershed/041019_outer_skin_surface outer_skin.surf` (there is a strong possibility that this file already exists)

### High-Resolution Head Surface
1. `setenv SUBJECTS_DIR /Users/jessica/data_analysis/eegfmri/subjects`
2. `mkheadsurf -subjid 180330_SYH` if done successfully, output should be "mkheadsurf done" and a lh.seghead file should be in /Users/jessica/data_analysis/eegfmri/subjects/180330_SYH/surf
<details><summary>If Error "mkheadsurf: Command not found"</summary>

  1. `cd home`
  2. `tcsh`
  3. `source .cshrc`
  4. `cd /Users/jessica/data_analysis/eegfmri/subjects`
  5. `setenv SUBJECTS_DIR /Users/jessica/data_analysis/eegfmri/subjects`
  6. `setenv FREESURFER_HOME /Applications/freesurfer/7.4.1`
  7. `source $FREESURFER_HOME/SetUpFreeSurfer.csh`
  8. `setenv FSL_DIR /Users/jessica/fsl`
  9. `echo $SUBJECTS_DIR /Users/jessica/data_analysis/eegfmri/subjects` make sure you are in the correct subject directory
  10. `cd /Users/jessica/data_analysis/eegfmri/subjects`
  11. `mkheadsurf -subjid 180330_SYH` should now work
</details>

3. `cd /Users/jessica/data_analysis/eegfmri/subjects/180330_SYH/surf` to the location of your lh.seghead file
4. `mris_convert lh.seghead lh.seghead.tri` if done successfully, output should be "Saving lh.seghead.tri as a surface in TKREGISTER space"

## Co-register between MRI and EEG sensors
1. Download 



## Examine Evoked Fields
1. Download [show_erp.m](https://github.com/fahsuanlin/labmanual/blob/master/scripts/show_erp.m) and add it to your subjects eeg_raw folder to show the evoked potentials (This step should only be done when you have the eeg_fwd_prep_042319.mat file)

