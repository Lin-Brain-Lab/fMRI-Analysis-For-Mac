## Event-Related fMRI Analysis (https://github.com/fahsuanlin/labmanual/wiki/11.-fMRI-analysis)
### Map fMRI time series from EPI volumnes on cortical surfaces
NOTE: You should begin this analysis with steps from the 'fMRI Pre-Processing' page
1. There should be a register.dat file from the co-registration step in your subjects fmri_data/unpack folder
2. `tcsh`
3. `source .cshrc`
4. `setenv SUBJECTS_DIR /Users/jessica/data_analysis/seeg/subjects`
5. `cd /Users/jessica/data_analysis/seeg/s025/fmri_data/unpack` to get to unpack folder of subject
6. `cat register.dat` to see contents of register.dat file, should look like image below

<img width="416" alt="Screen Shot 2024-03-12 at 12 07 11 PM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/3ca48404-0143-49cd-83e0-9b3e1516c77b">

7. Download MatLab script file from step 0.1 called s026_vol2surf.m (on FH GitHib page 11) and add the file to your fhlin_toolbox/seeg_s025 folder (can also change file name from s026 to respective subject number)
8. `/Applications/MATLAB_R2023b.app/bin/matlab &` open Matlab (in terminal so that MatLab knows FreeSurfer environment) 
9. Run your startup.m (contents of which are in the setting up environment page)
10. `setenv ('SUBJECTS_DIR','/Users/jessica/data_analysis/seeg/subjects');`
11. `pathtool` add fhlin_toolbox and all subfolders to path
12. Download MatLab script file from step 0.1 called s026_vol2surf.m (on FH GitHib page 11) and add the file to you fhlin_toolbox/seeg_s025 folder
13. Double-click to open the file in MatLab and change lines 14, 18 to your corresponding subject and bold number. Make sure you are in your subjects unpack folder directory in MatLab then run s025_vol2surf.m 
14. If you get an error `/Users/jessica/data_analysis/seeg/subjects/fsaverage/surf/lh.inflated : No such file or directory` try duplicating and putting the fsaverage folder from the FreeSurfer application into your Subjects folder
15. If done succesfully, you should recieve a message "I think I responded favorably to all your requests. Good bye." and there should be a "sfmcprstc-rh.stc" and "sfmcprstc-lh.stc" file in /Users/jessica/data_analysis/seeg/s025/fmri_data/unpack/bold/028

### Transform fMRI time series from individual's native space to MNI305 template
1. Download MatLab script file from step 0.2 called s026_vol2vol.m (on FH GitHib page 11) and add the file to your fhlin_toolbox/seeg_s025 folder
2. Change line 12 (to the location of your subject folder, /Users/jessica/data_analysis/seeg/s025), 14, and 18. Make sure you are in the unpack directory and run. If done succesfully, the output should be "mri_vol2vol done" 

### Get Confound Information
#### Get confound information from motion correction
1. Download MatLab script file from step 1.1 called get_mc_regressor.m (on FH GitHib page 11) and add file to your fhlin_toolbox/seeg_s025 folder and double click on the file for it to open in MatLab
2. Change line 5 `bold_dir='/space_lin2/fhlin/7t_music_skku/LAM_AUD_BHC_simple/unpack';` to the location of your subjects unpack folder `bold_dir='/Users/jessica/data_analysis/seeg/s025/fmri_data/unpack';`
3. Change line 8 `dirs={
'bold/007';
'bold/008';
'bold/009';
'bold/018';
'bold/019';
'bold/020';
'bold/021';
};
`
to the bold number (will change depending on subject), in this case it is 28
`dirs={
'bold/028'
};` 
5. Make sure you are in the unpack directory and run. If done succesfully, the output should be "get_mc_regressor done" 

#### Get confound information from non-gray matter time series
1. Download MatLab script file from step 1.2 get_ventricle_wm_regressor.m (on FH GitHib page 11) and add file to your fhlin_toolbox/seeg_s025 folder and double click on the file for it to open in MatLab
2. Change line 3 `target_subject='s006';` to `target_subject='s025';` (the subject ID you are working on)
3. Change lines 5 & 9 `'../resting_data/unpack/bold/005/fmcprstc.nii.gz';` to `'./bold/028/fmcprstc.nii.gz';` (location of your fmcprstc.nii.gz file) 
4. Change lines 17 and 21 `'aparc+aseg_fmcprstc_005.nii'` to `'aparc+aseg_fmcprstc_028.nii'` your respective dicom scan number 
6. Make sure you are in the unpack directory and run. If done successfully, output should be "DONE!" and you should have a aparc+aseg_fmcprstc_028.nii and regressor_wm_ventrical_028.mat file in your unpack folder

### Prepare Stimulus Onset
1. Download MatLab script file from step 2 called make_soa.m (on FH GitHib page 11) and add file to your fhlin_toolbox/seeg_s025 folder 
2. Also download 'SOA_s025.mat' from FH Github (or from server /space_lin2/fhlin/seeg/s025/fmri_analysis/SOA_s025.mat) and put into unpack folder for subject you are working on
3. Change line 2 `file_soa='SOA_s026.mat';` to your subjects respective SOA file `file_soa='SOA_s025.mat';` and run. If done successfully, you should have files 'fmri_soa_01.para' and 'fmri_soa_02.para' in your subjects unpack folder

### General Linear Modeling of the fMRI Time Series
1. Download MatLab script file from step 3 called fmri_surf_soa_glm.m (on FH GitHib page 11) and add file to your fhlin_toolbox/seeg_s025 folder 
2. Line 7 under 'file_stc' make sure the only line there is the path to your s025_2_fsaverage_sfmcprstc file, `'../unpack/bold/028/s025_2_fsaverage_sfmcprstc';` you can comment out or delete other paths there if present. NOTE: Pathing error occurs when doing absolute path (Ex. `/Users/jessica/Subjects/s026/mri/orig/unpack/bold/032/s026_2_fsaverage_sfmcprstc`), try to avoid doing so
3. Line 24 under 'erfmri_para' comment out `%    'fmri_soa_01.para';` since you are only analysing one run ('../unpack/bold/028/s025_2_fsaverage_sfmcprstc';) you only need one stimulus paramater file (if doing 2 then you would need both files)
4. Line 30 under 'file_ventrical_wm' make sure only the file you created in the previous step is there, `'regressor_wm_ventrical_028.mat';`
6. Make sure you are in the unpack directory and run. If done successfully, output should be "DONE!"
7. Download MatLab script file from step 3 called fmri_vol_soa_glm.m (on FH GitHib page 11) and add file to your fhlin_toolbox/seeg_s025 folder and double click on the file for it to open in MatLab
8. Change line 9 ` '../fmri_data/unpack/bold/030/sfmcprstc.nii';` to ` '../unpack/bold/028/sfmcprstc.nii';` make sure the only line there is to the location of your sfmcprstc.nii file
9. Comment out line 24 `%    'fmri_soa_01.para';` so there is only one file `'fmri_soa_02.para';`
10. Change line 32 `'regressor_wm_ventrical_028.mat';` to the proper dicom number for the file you are working on (comment out or delete lines to other files)
11. If you get an error "Unrecognized function or variable 'load_untouch_nii'." try downloading the toolbox from https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image and adding it to your fhlin_toolbox folder
12. If done successfully, output should be "DONE!" and a window called "Figure 1: fmri_fig_overlay) should pop-up. The activation patterns may not make sense in this image but the next step is done to prepare the overlay volume and surfaces matched to the anatomical volume and surfaces

<img width="442" alt="Screen Shot 2024-03-12 at 12 40 02 PM" src="https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/assets/157174338/35230d85-92f8-49b1-8ada-9cd8c7bd4501">

### Render Results Over the Brain 
1. Download MatLab script file from step 4 called show_mri.m (on FH GitHib page 11) and add file to your fhlin_toolbox/seeg_s025 folder and double click on the file for it to open in MatLab
2. Change line 3 `subject='s031';` to your subject number `'subject='s025';`
3. Change line 8 `file_overlay_register='../fmri_data/unpack/register.dat';` to the location of your register.dat file `file_overlay_register='../unpack/register.dat';` NOTE: Error can occur when starting pathing with fmri_data
4. Change line 9 `file_overlay_vol='../fmri_data/unpack/bold/006/f.mgz';` to the location of your f.mgz file `file_overlay_vol='../unpack/bold/028/f.mgz';`, If you only have a f.nii file, exit MatLab (or in terminal CTRL Z then `bg` to put matlab in background) then `cd /Users/jessica/data_analysis/seeg/s025/fmri_data/unpack/bold/028` then `mri_convert f.nii f.mgz` to convert the f.nii file to f.mgz
5. Change line 13 `setenv('SUBJECTS_DIR','/Users/fhlin/workspace/seeg/subjects/');` to the location of your subjects folder `setenv('SUBJECTS_DIR','/Users/jessica/data_analysis/seeg/subjects/');` 
6. Change line 16 `mri=MRIread(sprintf('/Users/fhlin/workspace/seeg/subjects/%s/mri/orig.mgz',subject));` to the location of your orig.mgz file `mri=MRIread(sprintf('/Users/jessica/data_analysis/seeg/subjects/%s/mri/orig.mgz',subject));` and run
7. If done successfully, you should have a output of a pop-up titled "Figure 1," if you click on the image you should get another pop-up of "Figure 2". You should also have files STC files 'fmri_surf_soa_glm_h0?_beta-?h.stc' and 'fmri_surf_soa_glm_h0?_tstat-?h.stc' in your unpack folder
<img width="559" alt="Screen Shot 2024-02-21 at 3 18 17 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/81096134-6085-41f2-a3f5-94f2f4c75231">
<img width="1104" alt="Screen Shot 2024-02-21 at 3 36 15 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/51737a08-0575-4c25-b03a-06f5c05b50a9">


8. To visualize the results enter the code

`[stc,v]=inverse_read_stc('fmri_surf_soa_glm_h01_tstat-lh.stc');`

`etc_render_fsbrain('hemi','lh','overlay_stc',stc,'overlay_vertex',v,'overlay_threshold',[2 3]);` 

in the MatLab command window. You should get a pop-up "Figure 2," and if you click on the image you should get another pop-up "Figure 3" and "Figure 4". Change lime 4 in MatLab code and code above to 'rh' to see right hemisphere . If you experience an error at this point or the image is not expected try `clear global etc_render_fsbrain` 

<img width="538" alt="Screen Shot 2024-03-06 at 2 02 17 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/20745e96-4d0c-48e4-90ee-fbea01585429">
<img width="794" alt="Screen Shot 2024-02-21 at 3 41 44 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/30a689f4-0d1d-4f55-922a-b9704e037604">
<img width="696" alt="Screen Shot 2024-02-21 at 3 42 13 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/cc42a8e4-1e88-43c1-8e7d-183430bc8a7b">

10. To view a heatmap of expected fMRI activity `imagesc(contrast)` where the X-axis is condition and Y-axis is time scale. Compare all the columns iteratively across all brain locations to see what columns match and get a map of how much the observed brain dynamics match the hypothesized model.

<img width="546" alt="Screen Shot 2024-02-27 at 11 38 00 AM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/eb2d8f96-fdaf-4561-bca8-b0bb356e9f69">

11. Repeat for other subjects for group-level analysis, and this is the end of event-realted analysis
