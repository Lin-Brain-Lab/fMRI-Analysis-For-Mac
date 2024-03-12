## Preparing fMRI Data for Pre-Processing 
1. Make a folder on your local computer as such: data_analysis/seeg/s025/fmri_data/dicom (It is important to make a seperate fMRI folder to house this dicom folder as the mri folder would have another dicom folder with structural data in it)
2. Download the dicom folder data from /space_lin2/fhlin/seeg/s026/fmri_data/dicom into /Users/jessica/data_analysis/seeg/s025/fmri_data/dicom
   
<img width="1219" alt="Screen Shot 2024-03-11 at 11 33 58 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/f7146fc1-5c61-49e7-a5c8-f5165e3851f9">

Download the remaining data from /space_lin2/fhlin/seeg/subjects/s026 to /Users/jessica/data_analysis/seeg/subjects/s026

<img width="1208" alt="Screen Shot 2024-03-08 at 2 31 56 PM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/06a4a4e1-3a81-439a-996e-746ccbdc20b4">

3. `tcsh`
4. `source .cshrc`
5. `mri_info` checks if all freesurfer items are there
6. `setenv SUBJECTS_DIR $PWD`
7. `setenv SUBJECTS_DIR /Users/jessica/data_analysis/seeg/subjects` set your subject directory to the path your subject folder is in 
8. `echo $SUBJECTS_DIR` checks what path your subject directory is in
9. `cd /Users/jessica/data_analysis/seeg/s025/fmri_data` get into right directory 
10. `mkdir unpack` creates empty folder called unpack (in fmri_data folder)
11. `cd unpack/`
12. Create a unpack.rule text document and write in plain text, “28 bold nii f.nii” where number changes based on run and is given based on the dicom scan number which can be found in the file path /Users/jessica/data_analysis/seeg/s025/fmri_data/dicom/180723_TZENG.MR.NISSEN_FMRI.0028.0001.2018.07.23.17.58.46.593750.849028.IMA, here is it 28 (from FMRI.0028)
13. `mv unpack.rule.txt unpack.rule` to rename unpack.rule.txt to unpack.rule
14. `unpacksdcmdir -src ../dicom -targ . -cfg ./unpack.rule` make sure you are in the unpack folder (this step may take some time, NOTE: `unpacksdcmdir` converts individual slices of dicom file into volume to one file). If done successfully, the output should be "unpacksdcmdir Done"
    
## Pre-processing fMRI Data 
### Setting up Folders & Environment 
1. `vi sessid` folder name, type "unpack" into editor (press A key to edit, then ESC + :wq to save), make sure your current directory is in the unpack folder
2. `vi sessdir` give path to unpack folder /Users/jessica/data_analysis/seeg/s025/fmri_data
3. `ls bold/028` double check if all three files (f.nii, f.nii-infodump.dat, flf) are in the bold folder
4. `mktemplate-sess -sf sessid -df sessdir` output should be "mktemplate-sess completed"
### Motion Correction 
1. `mc-sess -sf sessid -df sessdir -per-run` output should be "mc-sess completed SUCCESSFULLY"
2. `ls bold/028` should have more fmcpr files for motion correction
3. `freeview bold/028/f.nii` can open f.nii (before motion correction) and fmcpr.nii.gz (after motion correction) in freeview
4. `Control + Z` to suspend in freeview, then `bg` to keep in background
   
<img width="1209" alt="Screen Shot 2024-03-10 at 12 08 51 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/fe13f4f5-7ebb-4716-b857-acb820caeb28">

### Slice-Timing Correction 
1. `stc-sess -sf sessid -df sessdir -i fmcpr -o fmcprstc -so siemens` output should be "stc-sess Done"
### Spatial Smoothing
1. `spatialsmooth-sess -sf sessid -df sessdir -i fmcprstc -o sfmcprstc -fwhm 8 -no-mask -outfmt nii` term fwhm (full width half mass) determines how much smoothing there is, we set it at 8 mm which is standard. Output should be "spatiallysmooth-sess Done"
2. `freeview bold/028/sfmcprstc.nii` to view image in freeview (get file name from output: Saving to 028/sfmcprstc.nii)
   
<img width="1209" alt="Screen Shot 2024-03-10 at 12 15 15 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/328bff77-3a6d-49e1-8c8d-c5df2095a44f">

## Co-Registration
1. `fslregister --s s025 --mov bold/028/fmcprstc.nii.gz --reg ./register.dat --maxangle 70 --initxfm` output should be "fslregister Done
 To check results, run: `tkregisterfv --mov bold/028/fmcprstc.nii.gz --reg ./register.dat --surf orig`"

## Map fMRI Time Series Onto Indiviudal Cortical Surfaces (Convert Native to Template Space)
1. If you have not already, download MNE-C
2. `tcsh`
3. `vi .cshrc` make sure you have the correct environment set up that looks like this:

NOTE: Change lines 1, 4, 14, 15 to your respective MatLab version and FreeSurfer and Subject folder location (also seen in setting up environment page):

    setenv FREESURFER_HOME /Applications/freesurfer/7.4.1
    source $FREESURFER_HOME/SetUpFreeSurfer.csh
    source $FREESURFER_HOME/FreeSurferEnv.csh

    setenv MATLAB_ROOT /Applications/MATLAB_R2023b.app
    setenv MNE_ROOT /Applications/MNE-2.7.4-3378-MacOSX-x86_64
    source $MNE_ROOT/bin/mne_setup
    
    setenv DYLD_LIBRARY_PATH /Applications/MNE-2.7.4-3378-MacOSX-x86_64/lib:/opt/X11/lib/flat_namespace
    #setenv DYLD_LIBRARY_PATH /usr/local/lib/libquicktime.dylib

    set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/bin )
    set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/lib )
    set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/include )
    set path = ( $path /Applications/MRIcron.app/Contents/Resources )

    alias MATLAB /Applications/MATLAB_R2023b.app/bin/matlab
    setenv SUBJECTS_DIR /Users/jessica/Subjects

    alias robin ssh 142.76.1.189 -l fhlin
    alias robinsri ssh 172.20.151.238 -l fhlin


4. `source .cshrc`
5. `mne_make_movie` output should be mne_make_movie options
7. If you have an error at this point, try updating your toolbox by going to the fhlin_toolbox directory `git remote update` then `git status` to update, should say 'Your branch is up to date with 'origin/master'' if not updates avaliable. If there is an update (output after git remote update which mentions file and type of update) `git pull` to receive update.
### Render Brain In MatLab
1. `/Applications/MATLAB_R2023b.app/bin/matlab &` open MatLab in terminal
2. `setenv('SUBJECTS_DIR','/Users/jessica/data_analysis/seeg/subjects')`
3. `pathtool` add with subfolders the fhlin_toolbox, save and close.

<img width="799" alt="Screen Shot 2024-03-12 at 10 48 38 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/e9912564-0901-4a5a-b535-4bfb111c23d2">

5. `etc_render_fsbrain('subject','s025')` If done successfully, a 'Figure 1' tab should come up with a brain slice. If you click on a point in Figure 1, a 'Figure 2' window should come up. Press 'p' key to have a subject, volume, and, surface window to have different views. Press 'w' for coordinates.

<img width="491" alt="Screen Shot 2024-03-12 at 11 09 14 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/2b85ad5d-5682-4397-a935-1b3974b2d9c0">

<img width="727" alt="Screen Shot 2024-03-12 at 11 10 33 AM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/063ab6f9-09fe-4fb5-bb08-535215bdb21d">

6. If there is a error at this step try `ls /Applications/freesurfer/7.4.1/matlab/fr*.m` should show files required (can add these to path). Or click 'browse for folder' in top left and click file path for freesurfer -> matlab

<img width="385" alt="Screen Shot 2024-01-29 at 4 36 06 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/9de35622-ae4e-4110-a6cf-5a739c1bf812">


Alternatively, can copy 'matlab' folder from freesurfer folder into fhlin_toolbox folder and add this to the path as well (recommended for a swifter future analysis).

<img width="490" alt="Screen Shot 2024-01-29 at 4 50 27 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/9d72f5bf-ac0f-46eb-9dec-e2500b0eb11b">

