## Introduction
FreeSurfer recontruction locally for mac starts from the beginning of setting up your environment. 

## Installation prerequsites 
1. Access to the server: Cisco ANYconnect https://www.cisco.com/c/en/us/support/security/anyconnect-secure-mobility-client-v4-x/model.html and Cyberduck https://cyberduck.io
2. FreeSurfer https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall
3. FSL https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation
4. MNE https://mne.tools/stable/install/mne_c.html
5. fhlin_toolbox https://github.com/fahsuanlin/fhlin_toolbox
6. Mango: https://mangoviewer.com
7. XQuartz: https://www.xquartz.org

Ensure the appropriate license is intalled (if applicable)

## Setting up environment: 

1. `tcsh`
2. `vi .cshrc`
3. Copy the following into vi editor 

NOTE: Change lines 1, 4, 14, 15 to your respective MatLab version and FreeSurfer and Subject folder location):

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

5. ESC + wq:
6. `source .cshrc`
7. `freeview &` freeview should now open

## MatLab startup document 
In the matlab folder on your computer create a startup.m file with the following content (change location of FSL based on where your folder is)

    %------------ FreeSurfer -----------------------------%
    fshome = getenv('FREESURFER_HOME');
    fsmatlab = sprintf('%s/matlab',fshome);
    if (exist(fsmatlab) == 7)
        addpath(genpath(fsmatlab));  
    end
    clear fshome fsmatlab;

    %-----------------------------------------------------%

    %------------ FreeSurfer FAST ------------------------%
    fsfasthome = getenv('FSFAST_HOME');
    fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);
    if (exist(fsfasttoolbox) == 7)
        path(path,fsfasttoolbox);
    end
    clear fsfasthome fsfasttoolbox;


    %---------------------MNE Home-------------------------%
    mnehome = getenv('MNE_ROOT');
    mnematlab = sprintf('%s/share/matlab',mnehome);
    if (exist(mnematlab) == 7)
        path(path,mnematlab);
    end
    clear mnehome mnematlab;


    %---------------------FSL Setup-----------------------%
    setenv( 'FSLDIR', '/Users/jessica/fsl' );
    setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
    fsldir = getenv('FSLDIR');
    fsldirmpath = sprintf('%s/etc/matlab',fsldir);
    path(path, fsldirmpath);
    clear fsldir fsldirmpath;

<img width="790" alt="Screen Shot 2024-03-11 at 2 00 49 PM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/79e4c8b6-5eb0-4d21-ad19-5f344125d9ff">
