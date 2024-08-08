close all; clear all;

subject={
    's001';
    's002';
    's006';
    's007';
    's008';
    's009';
    's010';
    's011';
    's013';
    's014';
    's015';
    's020';
    };
    
cond_stem={
      'run_1_smsini_soa_gavg_glm_h01_tstat';
    % 'run_2_smsini_soa_gavg_glm_h01_tstat';
    % 'run_3_smsini_soa_gavg_glm_h01_tstat';
    % 'run_r_smsini_soa_gavg_glm_h01_tstat'; % only for s011-s020
};

cond_output_stem={
    'h01';
};


cond_stem_str={
    'emo';
    };

root_dir='/Users/jessica/data_analysis/emoclips';

output_stem='average_surf_080824';

for cond_idx=1:length(cond_stem)
    for hemi_idx=1:2
        switch hemi_idx
            case 1
                hemi_str='lh';
            case 2
                hemi_str='rh';
        end;
        
        for subj_idx=1:length(subject)
            [dummy,v,a,b,timeVec]=inverse_read_stc(sprintf('%s/%s/fmri_analysis/%s-%s.stc',root_dir,subject{subj_idx},cond_stem{cond_idx},hemi_str));

            stc(:,subj_idx)=dummy(:,1);
        end;
        
        z=mean(stc,2)./std(stc,0,2).*sqrt(size(stc,2));
        
        inverse_write_stc(repmat(z(:),[1:5]),v,a,b,sprintf('%s_%s-%s.stc',output_stem,cond_output_stem{cond_idx},hemi_str));
    end;
    
    etc_render_fsbrain_stc({sprintf('%s_%s',output_stem,cond_output_stem{cond_idx})},[1 5],'flag_overlay_pos_only',1);

    print('-dpng',sprintf('%s/group_level/average/fmri_surf_%s_average.png',root_dir,cond_stem_str{cond_idx}));
    
    close
end;
