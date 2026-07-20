close all; clear all;

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
    


cond_stem={
        % 'Aug28_posvsneg'
        % 'Sep10_posvsneg'
        % 'group_signed' % only original, (s011, s013, s014, s015, s017, s018, s021)
        % 'june1_group_signed' %added s002, and s010
        'Group_Signed_July20'


      % 'jan1_valence_run2_fmri_surf_soa_glm_h07_beta' %low-level visual for run 2 only
      % 'jan1_valence_run1v_fmri_surf_soa_glm_h01_beta' %low-level visual run 1 & 3
      % 'jan1_valence_run3_fmri_surf_soa_glm_h01_beta' %negative only 
      % 'jan1_valence_run3_fmri_surf_soa_glm_h02_beta' %neutral only
      % 'jan1_valence_run3_fmri_surf_soa_glm_h03_beta' %positive only
      % 'jan1_valence_run3_fmri_surf_soa_glm_h04_beta' %negative vs positive
      % 'jan1_valence_run3_fmri_surf_soa_glm_h05_beta' %negative vs neutral
      % 'jan1_valence_run3_fmri_surf_soa_glm_h06_beta' %positive vs neutral


     % 'dec9_run3_fmri_surf_soa_glm_h01_beta'  %neutral vs non-neutral hypothesis{1}.rv=[1 2 3 4 5 7 8]; hypothesis{1}.cvec=[-1/5 1 1 -1/5 -1/5 -1/5 -1/5];
     % 'dec9_run3_fmri_surf_soa_glm_h02_beta' %emo vs neutral hypothesis{2}.rv=[1 2 3 4 5 7 8]; hypothesis{2}.cvec=[0 -1/2 -1/2 1 0 0 0];
     % 'dec9_run3_fmri_surf_soa_glm_h03_beta' %neutral only hypothesis{3}.rv=[1 2 3 4 5 7 8]; hypothesis{3}.cvec=[0 1 1 0 0 0 0];
     % 'dec9_run3_fmri_surf_soa_glm_h04_beta' %emotion only hypothesis{4}.rv=[1 2 3 4 5 7 8]; hypothesis{4}.cvec=[0 0 0 1 0 0 0];
     % 'dec9_run3_fmri_surf_soa_glm_h05_beta' %emotion vs everything hypothesis{5}.rv=[1 2 3 4 5 7 8]; hypothesis{5}.cvec=[-1/7 -1/7 -1/7 1 -1/7 -1/7 -1/7];


};

cond_output_stem={
    'h01';
    % 'h02';
    % 'h03';
};


cond_stem_str={
    'group_signed';
    % 'V';
    % 'AV';
    };

root_dir='/Users/jessica/data_analysis/emoclips';

output_stem='J20average_surf_fdr_031324';

for cond_idx=1:length(cond_stem)
    z_both=[];
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

        z_both=cat(1,z_both(:),z(:));
       
    end;
    p_both=1-normcdf(abs(z_both));

    [p_fdr5, p_masked] = fdr( p_both, 0.05);
    [p_fdr1, p_masked] = fdr( p_both, 0.01); %standard is 0.01
    
    %
    th_5p=norminv(1-p_fdr5);
    th_1p=norminv(1-p_fdr1);
    
    etc_render_fsbrain_stc({sprintf('%s_%s',output_stem,cond_output_stem{cond_idx})},[th_5p th_1p],'flag_overlay_pos_only',1);

    print('-dpng',sprintf('%s/group_level/%s_%s_average.png',root_dir,output_stem,cond_stem_str{cond_idx}));
    
    close

end;
