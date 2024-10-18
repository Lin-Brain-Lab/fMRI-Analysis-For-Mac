close all; clear all;

% this script averaging 3 .stc files (one/ run) into one 

file_stc={
     'oct1_emo_run1_fmri_surf_soa_glm_h01_tstat';
     'oct1_emo_run2_fmri_surf_soa_glm_h01_tstat';
     'oct1_emo_run3_fmri_surf_soa_glm_h01_tstat';
    };

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



