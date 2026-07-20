close all; clear all;

% this script averaging 3 BETA.stc files (one/ run) into one

subject={
    % 's001';
    's002'; %added, subsequent ratings
    % 's004';
    % 's006';
    % 's007';
    % 's008';
    % 's009';
    's010'; %added, subsequent ratings
    's011';
    's013';
    's014';
    's015';
    's017';
    's018';
    %'s019';
    %'s020';
    's021';
    };

file_stc={
    'Group_norm_run1_fmri_surf_soa_glm_h01_beta'
    'Group_norm_run2_fmri_surf_soa_glm_h01_beta'
    'Group_norm_run3_fmri_surf_soa_glm_h01_beta'

    };

root_dir='/Users/jessica/data_analysis/emoclips';


output_stem='Group_Signed_July20';


hemispeheres={
    'lh';
    'rh'
    };

stc_all=[];
stc_avg=[];

fprintf('analyzing data...\n');
for h_idx = 1:2 % hemisphere index, 1:2 because there are 2 hemispheres
    for subj_idx=1:length(subject)
        for f_idx = 1:length(file_stc) % file index for legnth of the # of .stc files in file_stc
            disp(f_idx)
            fn_in = sprintf('%s/%s/fmri_analysis/%s-%s.stc', root_dir, subject{subj_idx}, file_stc{f_idx}, hemispeheres{h_idx});  % file name is the name from file_stc variable then a dash then the hemisphere from hemispheres variable
            [stc_tmp, v_tmp, cc, dd] = inverse_read_stc(fn_in); % reads the stc file
            if f_idx == 1 % if you are on the first iteration there is only 1 .stc file so stc_sum = stc_tmp because there is nothing to average
                stc_all = stc_tmp;
            else
                stc_all = [stc_all stc_tmp]; % adding stc_tmp where the values of the .stc file are temporarily stored to the sum that will include the values from all listed .stc files
            end
        end
        stc_sum = sum(stc_all, 2);
        stc_avg = stc_sum ./size(stc_all, 2); % ./ mean to do the operation to each element in the matrix individually, this line averages the stc_sum by the number of .stc files inputed (in this case 3)
        fn_out = sprintf('%s/%s/fmri_analysis/%s-%s.stc', root_dir, subject{subj_idx}, output_stem, hemispeheres{h_idx}); % fn_out is the output name where the beginning is from the output stem and hemisphere from the h_idx
        inverse_write_stc(stc_avg, v_tmp, cc, dd, fn_out); % this saves the averaged .stc to a .stc file
    end
end
etc_render_fsbrain_stc({output_stem},[3 6],'flag_overlay_pos_only',1);
print('-dpng',sprintf('%s.png', output_stem));

fprintf('data save complete...\n');




output_stem='oct18_face_3runavg_fmri_surf_soa_glm';

hemispeheres={
    'lh';
    'rh'
    };

stc_sum=[];
stc_avg=[];

fprintf('analyzing data...\n');
for h_idx = 1:2 % hemisphere index, 1:2 because there are 2 hemispheres
    for f_idx = 1:length(file_stc) % file index for legnth of the # of .stc files in file_stc
        fn_in = sprintf('%s-%s.stc', file_stc{f_idx}, hemispeheres{h_idx});  % file name is the name from file_stc variable then a dash then the hemisphere from hemispheres variable 
        [stc_tmp, v_tmp, cc, dd] = inverse_read_stc(fn_in); % reads the stc file
        if f_idx == 1 % if you are on the first iteration there is only 1 .stc file so stc_sum = stc_tmp because there is nothing to average
            stc_sum = stc_tmp;
        else
            stc_sum = stc_sum + stc_tmp; % adding stc_tmp where the values of the .stc file are temporarily stored to the sum that will include the values from all listed .stc files
        end
    end
    stc_avg = stc_sum ./length(file_stc); % ./ mean to do the operation to each element in the matrix individually, this line averages the stc_sum by the number of .stc files inputed (in this case 3)
    fn_out = sprintf('%s-%s.stc', output_stem, hemispeheres{h_idx}); % fn_out is the output name where the beginning is from the output stem and hemisphere from the h_idx
    inverse_write_stc(stc_avg, v_tmp, cc, dd, fn_out); % this saves the averaged .stc to a .stc file
end
etc_render_fsbrain_stc({output_stem},[1 5],'flag_overlay_pos_only',1);
print('-dpng',sprintf('%s.png', output_stem));

fprintf('data save complete...\n');



