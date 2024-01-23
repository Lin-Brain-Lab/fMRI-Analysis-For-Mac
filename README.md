## Introduction
FreeSurfer recontruction locally for mac starts from the beginning of setting up your FreeSurfer environment. Prerequsites of this include having access to the server (Via Cisco ANYconnect and Cyberduck) to access files, and having FreeSurfer with the appropriate licence installed.

## Making screens 
Some commands are important for making screens to process data remotely as it often takes hours for a reconstruction to complete.

`screen -ls` checks to see if there are any open screens associated with your login

`screen` opens a new screen

`screen -r` enter screen number, to reconnect to screen 

CTRL + A then D to exit from screen

CTRL + A then K to kill the screen

## Common Errors 
If an error occurs with reading the dicom files (Ex. ERROR: reading ../dicom/EEGFMRI_WM_S004.MR.RESEARCH_FHLIN.0037.0001.2023.02.24.17.53.54.227018.233311136.IMA tag 28 30) try installing XQuartz.
