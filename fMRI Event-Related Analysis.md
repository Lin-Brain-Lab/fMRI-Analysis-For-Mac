## Event-Related fMRI Analysis (https://github.com/fahsuanlin/labmanual/wiki/11.-fMRI-analysis)
### Map fMRI time series from EPI volumnes on cortical surfaces
NOTE: You should begin this analysis with steps from the 'fMRI Pre-Processing' page
1. There should be a register.dat file from the co-registration step for your subject
2. `tcsh`
3. `source .cshrc`
4. `setenv SUBJECTS_DIR /Users/jessica/Subjects`
5. `cd /Users/jessica/Subjects/s026/mri/orig/unpack` to get to unpack folder of subject
6. `cat register.dat` to see contents of register.dat file
<img width="425" alt="Screen Shot 2024-02-12 at 12 31 18 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/5f03dc50-c02e-480f-b3f9-dc4362c669c7">


7. `/Applications/MATLAB_R2023b.app/bin/matlab &` open Matlab (in terminal so that MatLab knows FreeSurfer environment) 
8. Create a startup file in matlab to set environment and run (no need to comment out fsl part if you have it)

<img width="462" alt="Screen Shot 2024-02-14 at 12 38 21 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/d648a7df-6d3f-41fd-85ad-70b6bc39802d">

9. In MatLab `setenv ('SUBJECTS_DIR','/Users/jessica/Subjects');`
10. Download MatLab script file from step 0.1 called s026_vol2surf.m (on FH GitHib page 11) and add file to fhlin_toolbox folder (in Matlab scripts Jessica folder)
11. In MatLab command window type `pathtool` and add fhlin_toolbox and all subfolders to path
12. Make sure you are in /Users/jessica/Subjects/s026/mri/orig/unpack folder then run
13. If you get an error `/Users/jessica/Subjects/fsaverage/surf/lh.inflated : No such file or directory` try duplicating and putting the fsaverage folder from the FreeSurfer application into your Subjects folder
14. If done succesfully, you should recieve a message "I think I responded favorably to all your requests. Good bye." and there should be a "sfmcprstc-rh.stc" and "sfmcprstc-lh.stc" file in /Users/jessica/Subjects/s026/mri/orig/unpack/bold/032

### Transform fMRI time series from individual's native space to MNI305 template
1. Download MatLab script file from step 0.2 called s026_vol2vol.m (on FH GitHib page 11) and add file to fhlin_toolbox folder (in Matlab scripts Jessica folder)
2. Double click on the file for it to open in MatLab (but remember you opened the MatLab application in terminal) and change `target_dir='/Users/fhlin/workspace/seeg/s026/fmri_analysis';` to `target_dir='/Users/jessica/Subjects/s026';`
3. Make sure you are in the unpack directory
4. Should say "mri_vol2vol done" when complete

### Get Confound Information
#### Get confound information from motion correction
1. Download MatLab script file from step 1.1 called get_mc_regressor.m (on FH GitHib page 11) and add file to fhlin_toolbox folder and double click on the file for it to open in MatLab
2. Change `bold_dir='/space_lin2/fhlin/7t_music_skku/LAM_AUD_BHC_simple/unpack';` to `bold_dir='/Users/jessica/Subjects/s026/mri/orig/unpack';`
3. Change `dirs={
'bold/007';
'bold/008';
'bold/009';
'bold/018';
'bold/019';
'bold/020';
'bold/021';
};
`
to 
`dirs={
'bold/032'
};` the bold number will change depending on subject, in this case it is 32
4. Should say "get_mc_regressor done" when complete

#### Get confound information from non-gray matter time series
1. Download MatLab script file from step 1.2 get_ventricle_wm_regressor.m (on FH GitHib page 11) and add file to fhlin_toolbox folder and double click on the file for it to open in MatLab
2. Change `target_subject='s006';` to `target_subject='s026';` (the subject ID you are working on)
3. Change `'../resting_data/unpack/bold/005/fmcprstc.nii.gz';` to `'./bold/032/fmcprstc.nii.gz';` (location of your fmcprstc.nii.gz file) for file_register_source and file_regression_source (lines 5 & 9)
4. Change `'aparc+aseg_fmcprstc_005.nii'` to `'aparc+aseg_fmcprstc_032.nii'` (dicom scan number, which is shown in bold folder)
5. Change `'regressor_wm_ventrical_005.mat';` to `'regressor_wm_ventrical_032.mat';`
6. Make sure your directory in matlab is in your subjects unpack folder & run
7. If done successfully, output should be "DONE!" and you should have a aparc+aseg_fmcprstc_026.nii and regressor_wm_ventrical_026.mat in your unpack folder

### Prepare Stimulus Onset
1. Download MatLab script file from step 2 called make_soa.m (on FH GitHib page 11) and add file to fhlin_toolbox folder 
2. On the right hand side under scripts also download 'SOA_s026.mat' from FH Github and put into unpack folder for subject you are working on
3. Double click on the 'make_soa.m' file in the fhlin_toolbox folder for it to open in MatLab
4. If done successfully, you should have a file 'fmri_soa_01.para' and 'fmri_soa_02.para' in your subjects unpack folder

### General Linear Modeling of the fMRI Time Series
1. Download MatLab script file from step 3 called fmri_surf_soa_glm.m (on FH GitHib page 11) and add file to fhlin_toolbox folder and double click on the file for it to open in MatLab
2. Under 'file_stc' make sure the only line there is the path to your s026_2_fsaverage_sfmcprstc file, `'../unpack/bold/032/s026_2_fsaverage_sfmcprstc';` you can comment out or delete other paths there if present (Ex. `%    '../fmri_data/unpack/bold/030/s026_2_fsaverage_sfmcprstc';`) Note: Pathing error occurs when doing absolute path (Ex. `/Users/jessica/Subjects/s026/mri/orig/unpack/bold/032/s026_2_fsaverage_sfmcprstc`), try to avoid doing so
3. Under 'file_ventrical_wm' make sure only the file you created in the previous step is there, `'regressor_wm_ventrical_032.mat';`
4. In line 24 under 'erfmri_para' comment out `%    'fmri_soa_01.para';` since you are only analysing one run ('../unpack/bold/032/s026_2_fsaverage_sfmcprstc';) you only need one stimulus paramater file (if doing 2 then you would need both files)
5. If done successfully, output should be "DONE!"
6. Download MatLab script file from step 3 called fmri_vol_soa_glm.m (on FH GitHib page 11) and add file to fhlin_toolbox folder and double click on the file for it to open in MatLab
7. Change ` '../fmri_data/unpack/bold/030/sfmcprstc.nii';` to ` '../unpack/bold/032/sfmcprstc.nii';` make sure the only line there is to the location of your sfmcprstc.nii file
8. Make sure `'regressor_wm_ventrical_032.mat';` is the proper dicom number for the file you are working on (032 in this case) 
9. Comment out `%    'fmri_soa_01.para';` under under 'erfmri_para' (line 24) and `%    'regressor_wm_ventrical_030.mat';` under file_ventrical_wm (line 31) so there is only one file called under erfmri_para and file_ventrical_wm
10. If you get an error "Unrecognized function or variable 'load_untouch_nii'." try downloading the toolbox from https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image and adding it to your fhlin_toolbox folder
11. If done successfully, output should be "DONE!" and a window called "Figure 1: fmri_fig_overlay) should pop-up. The activation patterns may not make sense in this image but the next step is done to prepare the overlay volume and surfaces matched to the anatomical volume and surfaces

### Render Results Over the Brain 
1. Download MatLab script file from step 4 called show_mri.m (on FH GitHib page 11) and add file to fhlin_toolbox folder and double click on the file for it to open in MatLab
2. Change `subject='s031';` to `'subject='s026';`
3. Change `file_overlay_register='../fmri_data/unpack/register.dat';` to `file_overlay_register='../unpack/register.dat';` (location of your register.dat file)
4. Change `file_overlay_vol='../fmri_data/unpack/bold/006/f.mgz';` to `file_overlay_vol='../unpack/bold/032/f.mgz';` (location of your f.mgz file). If you only have a f.nii file, exit MatLab (or in terminal CTRL Z then `bg` to put matlab in background) then `cd /Users/jessica/Subjects/s026/mri/orig/unpack/bold/032` then `mri_convert f.nii f.mgz` to convert the f.nii file to f.mgz
5. Change `setenv('SUBJECTS_DIR','/Users/fhlin/workspace/seeg/subjects/');` to `setenv('SUBJECTS_DIR','/Users/jessica/Subjects/');` (location of your subjects folder)
6. Change `mri=MRIread(sprintf('/Users/fhlin/workspace/seeg/subjects/%s/mri/orig.mgz',subject));` to `mri=MRIread(sprintf('/Users/jessica/Subjects/%s/mri/orig.mgz',subject));` (location of your orig.mgz file) and run
7. If done successfully, you should have a output of a pop-up titled "Figure 1," if you click on the image you should get another pop-up of "Figure 2". You should also have files STC files 'fmri_surf_soa_glm_h0?_beta-?h.stc' and 'fmri_surf_soa_glm_h0?_tstat-?h.stc' in your unpack folder
<img width="559" alt="Screen Shot 2024-02-21 at 3 18 17 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/81096134-6085-41f2-a3f5-94f2f4c75231">
<img width="1104" alt="Screen Shot 2024-02-21 at 3 36 15 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/51737a08-0575-4c25-b03a-06f5c05b50a9">


8. To visualize the results enter the code

`[stc,v]=inverse_read_stc('fmri_surf_soa_glm_h01_tstat-lh.stc');`

`etc_render_fsbrain('hemi','lh','overlay_stc',stc,'overlay_vertex',v,'overlay_threshold',[2 3]);` 

in the MatLab command window. You should get a pop-up "Figure 2," and if you click on the image you should get another pop-up "Figure 3" and "Figure 4". Change lime 4 in MatLab code and code above to 'rh' to see right hemisphere.  

<img width="538" alt="Screen Shot 2024-03-06 at 2 02 17 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/20745e96-4d0c-48e4-90ee-fbea01585429">
<img width="794" alt="Screen Shot 2024-02-21 at 3 41 44 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/30a689f4-0d1d-4f55-922a-b9704e037604">
<img width="696" alt="Screen Shot 2024-02-21 at 3 42 13 PM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/cc42a8e4-1e88-43c1-8e7d-183430bc8a7b">

10. To view a heatmap of expected fMRI activity `imagesc(contrast)` where the X-axis is condition and Y-axis is time scale. Compare all the columns iteratively across all brain locations to see what columns match and get a map of how much the observed brain dynamics match the hypothesized model.

<img width="546" alt="Screen Shot 2024-02-27 at 11 38 00 AM" src="https://github.com/Lin-Brain-Lab/FreeSurfer-Reconstruction-For-Mac/assets/157174338/eb2d8f96-fdaf-4561-bca8-b0bb356e9f69">
