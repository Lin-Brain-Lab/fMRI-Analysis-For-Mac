# FreeSurfer-Reconstruction-For-Mac-Locally
### Setting up environment: 
1. Download subject data from server to your local drive.
2. `tcsh`
3. `vi. cshrc`
4. Copy the following into vi editor (NOTE: Change lines 1, 4, 14, 15 to your respective MatLab version and FreeSurfer and Subject folder location):

`setenv FREESURFER_HOME /Applications/freesurfer`

`source $FREESURFER_HOME/SetUpFreeSurfer.csh`

`source $FREESURFER_HOME/FreeSurferEnv.csh`

`setenv MATLAB_ROOT /Applications/MATLAB_R2023b.app`

`#setenv MNE_ROOT /Applications/MNE-2.7.3-3268-MacOSX-i386`

`#setenv MNE_ROOT /Applications/MNE-2.7.4-3378-MacOSX-x86_64`

`#source $MNE_ROOT/bin/mne_setup`

`#setenv DYLD_LIBRARY_PATH /Applications/MNE-2.7.3-3268-MacOSX-i386/lib:/opt/X11/lib/flat_namespace`

`setenv DYLD_LIBRARY_PATH /Applicationss/MNE-2.7.4-3378-MacOSX-x86_64/lib:/opt/X11/lib/flat_namespace`

`set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/bin )`

`set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/lib )`

`set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/include )`

`set path = ( $path /Applications/MRIcron.app/Contents/Resources )`

`alias MATLAB /Applications/MATLAB_R2023b.app/bin/matlab`

`setenv SUBJECTS_DIR /Users/jessica/Subjects`

`alias robin ssh 142.76.1.189 -l fhlin`

`alias robinsri ssh 172.20.151.238 -l fhlin`

6. ESC + wq:
7. `source .cshrc`
8. `freeview &`

#### Freeview should now open.

## Freesurfer Reconstruction

1. `tcsh` 

2. `source .cshrc`

3. Download the dicom folder to your drive from the subject folder located on the server.

4. Make a folder path as follows: Subjects/s004/mri/orig add the dicom folder into the orig folder 

5. `mri_info` checks if all freesurfer items are there
6. `echo $SUBJECTS_DIR` sees what path your subjects are in 
7. `unpacksdcmdir` converts individual slices of dicom file into volume to one file
8. `cd /Users/jessica/Subjects/s004/mri/orig` get into right directory in orig folder
9. `setenv SUBJECTS_DIR $PWD`
10. `setenv SUBJECTS_DIR /Users/jessica/Subjects`
11. `mkdir unpack` creates empty folder called unpack (in orig folder)
12. `cd unpack/`
13. `unpacksdcmdir -src ../dicom -targ . -scanonly ./info`
14. Make text file in textedit (format → plain text) and enter "37 3danat COR blah", name the file unpack.rule. (Output of the previous step shows what number it should be, in this case 37) and put in unpack folder
15. `mri_convert -all-info`
16. `mv unpack.rule.txt unpack.rule` to rename unpack.rule.txt to unpack.rule
17. `unpacksdcmdir -src ../dicom -targ . -cfg ./unpack.rule` make sure you are in the unpack folder (this step may take some time) 
18. `cd ../` make sure in orig file for next step (going back one folder) 
19. `mri_convert unpack/3danat/037/COR-.info ./001.mgz` after this step there should be a 001.mgz in the orig folder
20. `recon-all`
