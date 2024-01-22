# FreeSurfer-Reconstruction-For-Mac-Locally
Setting up environment: 
1. Download subject data from server to your local drive

In terminal:
2. tcsh
3. vi. cshrc
4. Copy the following into vi editor (NOTE: Change lines 1, 4, 14, 15 to your respective MatLab version and FreeSurfer and Subject folder location):
setenv FREESURFER_HOME /Applications/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.csh
source $FREESURFER_HOME/FreeSurferEnv.csh
setenv MATLAB_ROOT /Applications/MATLAB_R2023b.app
#setenv MNE_ROOT /Applications/MNE-2.7.3-3268-MacOSX-i386
#setenv MNE_ROOT /Applications/MNE-2.7.4-3378-MacOSX-x86_64
#source $MNE_ROOT/bin/mne_setup
#setenv DYLD_LIBRARY_PATH /Applications/MNE-2.7.3-3268-MacOSX-i386/lib:/opt/X11/lib/flat_namespace
setenv DYLD_LIBRARY_PATH /Applicationss/MNE-2.7.4-3378-MacOSX-x86_64/lib:/opt/X11/lib/flat_namespace
set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/bin )
set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/lib )
set path = ( $path /Users/fhlin/toolbox/OpenMEEG-2.4.1-MacOSX/include )
set path = ( $path /Applications/MRIcron.app/Contents/Resources )
alias MATLAB /Applications/MATLAB_R2023b.app/bin/matlab
setenv SUBJECTS_DIR /Users/jessica/Subjects
alias robin ssh 142.76.1.189 -l fhlin
alias robinsri ssh 172.20.151.238 -l fhlin
5. ESC + wq:
6. source .cshrc
7. freeview &

Freeview should now open.

