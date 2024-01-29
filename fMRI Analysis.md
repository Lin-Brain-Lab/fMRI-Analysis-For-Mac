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
1. Download MNE
2. `tcsh`
3. `vi .cshrc` make sure you have the correct environment set up that looks like this (ensure MNE roots are correct for you computer):

`setenv FREESURFER_HOME /Applications/freesurfer/7.4.1`

`source $FREESURFER_HOME/SetUpFreeSurfer.csh`

`source $FREESURFER_HOME/FreeSurferEnv.csh`

`setenv MATLAB_ROOT /Applications/MATLAB_R2023b.app`

`setenv MNE_ROOT /Applications/MNE-2.7.4-3378-MacOSX-x86_64`

`source $MNE_ROOT/bin/mne_setup`

`setenv DYLD_LIBRARY_PATH /Applications/MNE-2.7.4-3378-MacOSX-x86_64/lib:/opt/X11/lib/flat_namespace`

`set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/bin )`

`set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/lib )`

`set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/include )`

`set path = ( $path /Applications/MRIcron.app/Contents/Resources )`

`alias MATLAB /Applications/MATLAB_R2023b.app/bin/matlab`

`setenv SUBJECTS_DIR /Users/jessica/Subjects`

`alias robin ssh 142.76.1.189 -l fhlin`

`alias robinsri ssh 172.20.151.238 -l fhlin`

4. `source .cshrc`
5. `mne_make_movie` output should be mne_make_movie options
6. `git clone https://github.com/fahsuanlin/fhlin_toolbox.git` to get Fa-Hsuans toolbox if not already installed or updated ([fahsuanlin GitHub page](https://github.com/fahsuanlin/labmanual/wiki/15.-Use-toolbox-by-git)https://github.com/fahsuanlin/labmanual/wiki/15.-Use-toolbox-by-git) output should be 'done'
7. In fhlin_toolbox directory `git remote update` then `git status` to update, should say 'Your branch is up to date with 'origin/master'' if not updates avaliable. If there is an update (output after git remote update which mentions file and type of update) `git pull` to receive update.
### In MatLab
1. `setenv('SUBJECTS_DIR','/Users/jessica/Subjects')`
2. You should be in the fhlin_toolbox folder. On the side tab bar 'current folder' select and add the 'codes,' 'images,' and 'scripts' folder, right click then 'add to path' then 'selected folders and subfolders'
<img width="664" alt="Screen Shot 2024-01-29 at 4 13 02 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/d0d96933-6b5a-4f3c-a825-5bb01f2add26">

3. `etc_render_fsbrain('subject','s026')`
4. If there is a error at this step try `ls /Applications/freesurfer/7.4.1/matlab/fr*.m` should show files required (can add these to path)

   i. Or click 'browse for folder' in top left and click file path for freesurfer -> matlab
<img width="385" alt="Screen Shot 2024-01-29 at 4 36 06 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/9de35622-ae4e-4110-a6cf-5a739c1bf812">

   ii. Alternatively, can copy 'matlab' folder from freesurfer folder into fhlin_toolbox folder and add this to the path as well

<img width="490" alt="Screen Shot 2024-01-29 at 4 50 27 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/9d72f5bf-ac0f-46eb-9dec-e2500b0eb11b">


5. If done successfully, a 'Figure 1' tab should come up with a brain slice. If you click on a point in Figure 1, a 'Figure 2' window should come up. Press 'p' key to have a subject, volume, and, surface window to have different views. Press 'w' for coordinates.
