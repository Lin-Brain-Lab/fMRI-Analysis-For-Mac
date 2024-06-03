# Useful commands and common errors 

## Making Screens 
Some commands are important for making screens to process data remotely as it often takes hours for a reconstruction to complete.

`screen -ls` checks to see if there are any open screens associated with your login

`screen` opens a new screen

`screen -r XXXXX` to reconnect to screen, where XXXXX is the screen number

CTRL + a then d to exit from screen

CTRL + a then k to kill the screen

## Remote Update fhlin_toolbox
1. `git clone https://github.com/fahsuanlin/fhlin_toolbox.git` to get Fa-Hsuans toolbox if not already installed or updated ([fahsuanlin GitHub page](https://github.com/fahsuanlin/labmanual/wiki/15.-Use-toolbox-by-git)https://github.com/fahsuanlin/labmanual/wiki/15.-Use-toolbox-by-git) output should be 'done'
2. In fhlin_toolbox directory `git remote update` then `git status` to update, should say 'Your branch is up to date with 'origin/master'' if not updates avaliable. If there is an update (output after git remote update which mentions file and type of update) `git pull` to receive update.

## Copying Folders Using Terminal
`cp -r /Applications/freesurfer/7.4.1/subjects/fsaverage* /Users/jessica/Subjects/` the first term is current folder location, the second is where you want it to go. This is useful when trying to avoid softlinking as that can cause pathing errors downstream.

## Accessing the Server
1. `ssh -L 2222:142.76.25.154:22 username@142.76.1.189` to connect to the server remotely, enter your password when prompted
   
