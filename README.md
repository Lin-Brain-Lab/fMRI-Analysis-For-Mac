# Useful commands and help with common errors 

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

