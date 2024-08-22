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

## Using the Server
### Accessing the Server
1. Connect to VPN Via Cisco AnyConnect
2. `ssh -L 2222:142.76.25.154:22 jdin@142.76.1.189` enter your password when prompted
3. Open a new terminal window `ssh -p 2222 jdin@127.0.0.1 ` enter your password when prompted
4. `ls /` then `ls /space_lin2` you can now `cd /space_lin2` then you can `cd` to a folder location
### Opening MatLab in the Server
1. Connect to VPN Via Cisco AnyConnect
2. `ssh -L 2222:142.76.25.154:22 jdin@142.76.1.189` enter your password when prompted
3. `kinit` if 'no such file or directory'
4. `ssh lin2`
5. `pwd` should be /home/jdin (this command tells you your current directory)
6. `tcsh`
7. `matlab -nodisplay`
### Copying Files To and From the Server
### Server to Local
1. Enter the server in one terminal window
2. Open a second terminal window and cd to the location you want the file to download to
3. `scp -r -P 2222 jdin@localhost:/folders/server/location/path/* .` copys a file from the server to your local computer (Note: this is a bash command, change your terminal settings from defult to run properly)
### Local to Server
4. Enter the server in one terminal window
5. Open a second terminal window and cd to the parent folder of the folder you want copied
6. `scp -r -P 2222 /folder/* jdin@localhost:/folders/server/location/path/` copys a file from your local computer to the server
   
