## Introduction
FreeSurfer recontruction locally for mac starts from the beginning of setting up your FreeSurfer environment. Prerequsites of this include having access to the server (Via Cisco ANYconnect and Cyberduck) to access files, having FreeSurfer with the appropriate licence installed, and installing the fhlin_toolbox.

## Setting up environment: 

1. `tcsh`
2. `vi .cshrc`
3. Copy the following into vi editor (NOTE: Change lines 1, 4, 14, 15 to your respective MatLab version and FreeSurfer and Subject folder location):

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

4. ESC + wq:
5. `source .cshrc`
6. `freeview &`

#### Freeview should now open.

## Making screens 
Some commands are important for making screens to process data remotely as it often takes hours for a reconstruction to complete.

`screen -ls` checks to see if there are any open screens associated with your login

`screen` opens a new screen

`screen -r` enter screen number, to reconnect to screen 

CTRL + A then D to exit from screen

CTRL + A then K to kill the screen

## Common Errors 
If an error occurs with reading the dicom files (Ex. ERROR: reading ../dicom/EEGFMRI_WM_S004.MR.RESEARCH_FHLIN.0037.0001.2023.02.24.17.53.54.227018.233311136.IMA tag 28 30) try installing XQuartz.

## Remote Update fhlin_toolbox
1. `git clone https://github.com/fahsuanlin/fhlin_toolbox.git` to get Fa-Hsuans toolbox if not already installed or updated ([fahsuanlin GitHub page](https://github.com/fahsuanlin/labmanual/wiki/15.-Use-toolbox-by-git)https://github.com/fahsuanlin/labmanual/wiki/15.-Use-toolbox-by-git) output should be 'done'
2. In fhlin_toolbox directory `git remote update` then `git status` to update, should say 'Your branch is up to date with 'origin/master'' if not updates avaliable. If there is an update (output after git remote update which mentions file and type of update) `git pull` to receive update.

## Copying Folders Using Terminal
`cp -r /Applications/freesurfer/7.4.1/subjects/fsaverage* /Users/jessica/Subjects/` the first term is current folder location, the second is where you want it to go. This is useful when trying to avoid softlinking as that can cause pathing errors downstream.
