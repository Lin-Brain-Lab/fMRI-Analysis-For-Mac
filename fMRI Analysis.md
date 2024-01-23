1. Make a folder on your local computer as such: Subjects/s026/fmri_data/dicom. It is important to make a seperate fMRI folder to house this dicom folder as the mri folder would have another dicom folder with structural data in it
2. Start with steps 1-10 from the "FreeSurfer Reconstruction" page
3. Create a unpack.rule text document and write “32 bold nii f.nii” where number changes based on run and is given based on the output of the previous steps
4. `unpacksdcmdir -src ../dicom -targ . -cfg ./unpack.rule` make sure you are in the unpack folder (this step may take some time)
