## Preparing fMRI Data for Pre-Processing 
1. Make a folder on your local computer as such: data_analysis/seeg/s025/fmri_data/dicom (It is important to make a seperate fMRI folder to house this dicom folder as the mri folder would have another dicom folder with structural data in it)
2. Download the dicom data folder from /space_lin2/fhlin/seeg/s026/fmri_data/dicom into /Users/jessica/data_analysis/seeg/s025/fmri_data/dicom. Download the remaining data from /space_lin2/fhlin/seeg/subjects/s026 to /Users/jessica/data_analysis/seeg/subjects/s026
<details>

<summary>Example folder path</summary>
   
<img width="1219" alt="Screen Shot 2024-03-11 at 11 33 58 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/f7146fc1-5c61-49e7-a5c8-f5165e3851f9">
<img width="1208" alt="Screen Shot 2024-03-08 at 2 31 56 PM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/06a4a4e1-3a81-439a-996e-746ccbdc20b4">

</details>

3. `tcsh`
4. `source .cshrc`
5. `vi .cshrc` make sure you have the correct environment set up (seen in the [setting up environment page](https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/blob/main/Setting%20Up%20Environment.md))
6. `mri_info` checks if all freesurfer items are there
7. `setenv SUBJECTS_DIR $PWD`
8. `setenv SUBJECTS_DIR /Users/jessica/data_analysis/seeg/subjects` sets your subject directory
9. `echo $SUBJECTS_DIR` checks what path your subject directory is in
10. `cd /Users/jessica/data_analysis/seeg/s025/fmri_data` get into right directory 
11. `mkdir unpack` creates empty folder called unpack (in fmri_data folder)
12. `cd unpack/`
13. `vi unpack.rule` write “28 bold nii f.nii” where number changes based on run and is given based on the dicom scan number which can be found in the file path /Users/jessica/data_analysis/seeg/s025/fmri_data/dicom/180723_TZENG.MR.NISSEN_FMRI.0028.0001.2018.07.23.17.58.46.593750.849028.IMA, here is it 28 (from FMRI.0028) NOTE: 
14. `unpacksdcmdir -src ../dicom -targ . -cfg ./unpack.rule` make sure you are in the unpack folder (this step may take some time as unpacksdcmdir converts individual slices of dicom file into volume to one file). If done successfully, the output should be "unpacksdcmdir Done"
    
## Pre-processing fMRI Data 
### Setting up Folders & Environment 
1. `vi sessid` folder name, type "unpack" into editor (press A key to edit, then ESC + :wq to save), make sure your current directory is in the unpack folder
2. `vi sessdir` give path to unpack folder "/Users/jessica/data_analysis/seeg/s025/fmri_data"
3. `ls bold/028` double checks if all three files (f.nii, f.nii-infodump.dat, flf) are in the bold folder
4. `mktemplate-sess -sf sessid -df sessdir` output should be "mktemplate-sess completed"
### Motion Correction 
1. `mc-sess -sf sessid -df sessdir -per-run` output should be "mc-sess completed SUCCESSFULLY"
2. `ls bold/028` should have more fmcpr files for motion correction
3. `freeview bold/028/f.nii` can open f.nii (before motion correction) and fmcpr.nii.gz (after motion correction) in freeview. `Control + Z` to suspend in freeview, then `bg` to keep in background
<details>
<summary>Motion corrected image</summary>
<img width="1209" alt="Screen Shot 2024-03-10 at 12 08 51 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/fe13f4f5-7ebb-4716-b857-acb820caeb28">
</details>

### Slice-Timing Correction 
1. `stc-sess -sf sessid -df sessdir -i fmcpr -o fmcprstc -so siemens` output should be "stc-sess Done"
### Spatial Smoothing
1. `spatialsmooth-sess -sf sessid -df sessdir -i fmcprstc -o sfmcprstc -fwhm 8 -no-mask -outfmt nii` term fwhm (full width half mass) determines how much smoothing there is, we set it at 8 mm which is standard. Output should be "spatiallysmooth-sess Done"
2. `freeview bold/028/sfmcprstc.nii` to view image in freeview (get file name from output: Saving to 028/sfmcprstc.nii)
<details>
<summary>Spatially smoothed image</summary>
<img width="1209" alt="Screen Shot 2024-03-10 at 12 15 15 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/328bff77-3a6d-49e1-8c8d-c5df2095a44f">
</details>

## Co-Registration
1. `fslregister --s s025 --mov bold/028/fmcprstc.nii.gz --reg ./register.dat --maxangle 70 --initxfm` output should be "fslregister Done
 To check results, run: `tkregisterfv --mov bold/028/fmcprstc.nii.gz --reg ./register.dat --surf orig`"

## Map fMRI Time Series Onto Indiviudal Cortical Surfaces (Convert Native to Template Space)
1. If you have not already, [download MNE-C](https://mne.tools/stable/install/mne_c.html)
2. `mne_make_movie` output should be mne_make_movie options. If you have an error at this point, try updating your [fhlin_toolbox](https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/blob/main/README.md) 
### Render Brain In MatLab
1. `/Applications/MATLAB_R2023b.app/bin/matlab &` open MatLab in terminal
2. Run startup.m script (seen in the [setting up environment page](https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/blob/main/Setting%20Up%20Environment.md)
4. `setenv('SUBJECTS_DIR','/Users/jessica/data_analysis/seeg/subjects')`
5. `etc_render_fsbrain('subject','s025')` If done successfully, a 'Figure 1' tab should come up with a brain slice. If you click on a point in Figure 1, a 'Figure 2' window should come up. Press 'p' key to have a subject, volume, and, surface window to have different views. Press 'w' for coordinates.
<details>
<summary>Figure 1</summary>
<img width="491" alt="Screen Shot 2024-03-12 at 11 09 14 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/2b85ad5d-5682-4397-a935-1b3974b2d9c0">
</details>
<details>
<summary>Figure 2</summary>
<img width="727" alt="Screen Shot 2024-03-12 at 11 10 33 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/063ab6f9-09fe-4fb5-bb08-535215bdb21d">
</details>
