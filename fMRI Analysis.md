## Preparing fMRI Data for Pre-Processing 
1. Make a folder on your local computer as such: Subjects/s026/fmri_data/dicom. It is important to make a seperate fMRI folder to house this dicom folder as the mri folder would have another dicom folder with structural data in it
2. Start with steps 1-10 from the "FreeSurfer Reconstruction" page
3. Create a unpack.rule text document and write “32 bold nii f.nii” where number changes based on run and is given based on the output of the previous steps
4. `unpacksdcmdir -src ../dicom -targ . -cfg ./unpack.rule` make sure you are in the unpack folder (this step may take some time)
## Pre-processing fMRI Data 
### Setting up Folders & Environment 
1. `cd cd /Users/jessica/Subjects/s026/mri/orig/unpack` go to unpack folder for the subject you are working on
2. `vi sessid` folder name, type "unpack" into editor (ESC + :wq to save)
3. `vi sessdir` give path to unpack folder /Users/jessica/Subjects/s026/mri/orig (in this case it is in mri and orig folder but should be in its own fmri folder)
4. `ls bold/032` double check if all three files (f.nii, f.nii-infodump.dat, flf) are in the bold folder
5. `mktemplate-sess -sf sessid -df sessdir` output should be "mktemplate-sess completed"
### Motion Correction 
1. `mc-sess -sf sessid -df sessdir -per-run` output should be "mc-sess completed SUCCESSFULLY"
2. `ls bold/032` should have more fmcpr files for motion correction
3. `freeview bold/032/f.nii` can open f.nii (before motion correction) and fmcpr.nii.gz (after motion correction) in freeview
4. `Control + Z` to suspend in freeview, then `bg` to keep in background
### Slice-Timing Correction 
1. `stc-sess -sf sessid -df sessdir -i fmcpr -o fmcprstc -so siemens` output should be "stc-sess Done"
### Spatial Smoothing
1. `spatialsmooth-sess -sf sessid -df sessdir -i fmcprstc -o sfmcprstc -fwhm 8 -no-mask -outfmt nii` term fwhm (full width half mass) determines how much smoothing there is, we set it at 8 mm which is standard. Output should be "spatiallysmooth-sess Done"
2. `freeview bold/032/sfmcprstc.nii` to view image in freeview (get file name from output: Saving to 032/sfmcprstc.nii)

## Co-Registration
1. `fslregister --s s026 --mov bold/032/fmcprstc.nii.gz --reg ./register.dat --maxangle 70 --initxfm`
2. Output from previous step: to check results, run: tkregisterfv --mov bold/032/fmcprstc.nii.gz --reg ./register.dat --surf orig
3. Run `tkregisterfv --mov bold/032/fmcprstc.nii.gz --reg ./register.dat --surf orig` and freeview should open

## Map fMRI Time Series Onto Indiviudal Cortical Surfaces (Convert Native to Template Space)
1. 
