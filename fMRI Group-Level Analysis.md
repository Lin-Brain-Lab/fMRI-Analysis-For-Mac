#fMRI Group-Level Analysis
>[!NOTE]
> Begin analysis by starting with steps from the [Event-Related fMRI Analysis page](https://github.com/Lin-Brain-Lab/fMRI-Analysis-For-Mac/blob/main/fMRI%20Event-Related%20Analysis.md)

1. Download [show_individual_surf](https://github.com/fahsuanlin/labmanual/blob/master/scripts/show_individual_surf_031324.m)
2. List starting from line 4 the subjects you want to include
3. Change line 35 to your root directory
4. Change line 49 to the location of the stc files for your subjects `'%s/%s/fmri_data/unpack/ %s-%s.stc'`
5. If done successfully, you should have 12 images in the folder directory you choose (line , in this case fhlin toolbox)


6. Download [average_surf change lines](https://github.com/fahsuanlin/labmanual/blob/master/scripts/average_surf_031324.m) 
