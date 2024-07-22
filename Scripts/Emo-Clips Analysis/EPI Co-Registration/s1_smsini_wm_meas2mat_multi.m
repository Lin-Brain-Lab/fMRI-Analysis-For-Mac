close all; clear all;
%this script creates a acc.mat and ref.mat for each run from meas files
pdir=pwd;


addpath('/Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/codes/tool_mb_recon/VD');
addpath('/Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/codes/tool_mb_recon/');

%path_dat_source={'/Users/jessica/data_analysis/emoclips/s001/fmri_raw/meas/';
%};
path_dat_source={'/Users/jessica/data_analysis/emoclips/s014/fmri_raw/meas/';
};

path_mat_destination='/Users/jessica/data_analysis/emoclips/s014/fmri_analysis/';

n_dummy=0; %number of dummy scans

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(~exist('n_dummy')) n_dummy=0; end;
if(isempty(n_dummy)) n_dummy=0; end;

for f_idx=1:length(path_dat_source)
        ref_files=dir(sprintf('%s/*MBSIREPI*ref*.dat',path_dat_source{f_idx}));
        acc_files=dir(sprintf('%s/*MBSIREPI*acc*.dat',path_dat_source{f_idx}));

        for i=1:length(acc_files)
                [ ref,EPInew ] = MBrecon_VE( [path_dat_source{f_idx},ref_files(i).name],[path_dat_source{f_idx},acc_files(i).name],0.0005 );

                %[ ref,EPInew ] = MBrecon( [path_dat_source{f_idx},ref_files(i).name],[path_dat_source{f_idx},acc_files(i).name],0.0005 );
                acc=abs(EPInew(:,:,:,n_dummy+1:end));
                %acc=abs(EPInew);
                save(sprintf('%s/mb_run_%s_ref.mat',path_mat_destination,num2str(i)),'ref','-v7.3');
                save(sprintf('%s/mb_run_%s_acc.mat',path_mat_destination,num2str(i)),'acc','-v7.3');
        end
end;
