close all; clear all;
%script aims to contrast personal and group
subject={
    's011';
    's013';
    's014';
    's015';
    's017';
    's018';
    's021';
    };

contrast{1}={'sep5_pos_vs_neg', 'Sep10_posvsneg'}; %sep 5 is individual, sep 10 is group
contrast_weight{1}=[1 -1];
contrast_name{1}='signed_individual_vs_group';
% 
% contrast{1}={'sep5_emo_vs_neu','Sep10_emovsneu'};
% contrast_weight{1}=[1 -1];
% contrast_name{1}='unsigned_individual_vs_group';

output_stem='signed';
root_path='/Users/jessica/data_analysis/emoclips';

% ensure PNG folder exists
if exist(fullfile(root_path,'group_level'),'dir')~=7
    mkdir(fullfile(root_path,'group_level'));
end

for contrast_idx=1:length(contrast)

    z_both = []; % collect both hemispheres for global FDR

    for hemi_idx=1:2
        switch hemi_idx
            case 1
                hemi='lh';
            case 2
                hemi='rh';
        end;

        stc=[];
        for subj_idx=1:length(subject)
            for cond_idx=1:length(contrast{contrast_idx})
                fn=sprintf('%s/%s/fmri_analysis/%s-%s.stc',root_path,subject{subj_idx},contrast{contrast_idx}{cond_idx},hemi);
                [tmp,v,a,b]=inverse_read_stc(fn);
                stc(:,cond_idx,subj_idx,hemi_idx)=tmp(:,1);
            end;
        end;

        stc_2d=reshape(stc(:,:,:,hemi_idx),[size(stc,1) size(stc,2)*size(stc,3)]);

        contrast_cond=kron(ones(length(subject),1),eye(length(contrast{contrast_idx})));
        contrast_subject=kron(eye(length(subject)),ones(length(contrast{contrast_idx}),1));
        %contrast_subject=[];
        D=cat(2,contrast_cond,contrast_subject(:,1:end-1));

        beta=inv(D'*D)*D'*stc_2d.';
        error=(stc_2d.'-D*beta);
        error_sig2=sum(error.^2,1)./(size(stc_2d,2)-size(D,2));
        df=size(stc_2d,2)-rank(D);

        cc=zeros(size(D,2),1);
        cc(1:length(contrast{contrast_idx}))=contrast_weight{contrast_idx};

        t_stat=cc'*beta./sqrt(error_sig2.*(cc'*inv(D'*D)*cc));
        effect=cc'*beta;

        fn=sprintf('%s_%s_t-%s.stc',output_stem,contrast_name{contrast_idx},hemi);
        inverse_write_stc(repmat(t_stat(:),[1 5]),v,a,b,fn);

        % collect for FDR
        z_both = [z_both; t_stat(:)];
    end;

    % ---------- FDR correction (global across lh+rh) ----------
    p_both=1-normcdf(abs(z_both));
    % pos_idx=find(z_both>0);
    % p_both(pos_idx)=1-tcdf(z_both(pos_idx),df);
    % neg_idx=find(z_both<0);
    % p_both(neg_idx)=tcdf(z_both(neg_idx),df);
    
    [p_fdr5, ~] = fdr(p_both, 0.05);
    [p_fdr1, ~] = fdr(p_both, 0.01); % standard is 0.01

    th_5p=norminv(1-p_fdr5);
    th_1p=norminv(1-p_fdr1);

    % ---------- Display + save PNG ----------
    % stem BEFORE "-lh/-rh": "<output_stem>_<contrast_name>_t"
    brain_stem = sprintf('%s_%s_t', output_stem, contrast_name{contrast_idx});

    % If SUBJECTS_DIR set and you want to be explicit, use:
    % etc_render_fsbrain_stc({brain_stem},[th_5p th_1p],'subject',subject_surf,'surf',surf_name,'flag_overlay_pos_only',1);
    etc_render_fsbrain_stc({brain_stem},[th_5p th_1p],'flag_overlay_pos_only',1);

    print('-dpng',sprintf('%s/group_level/%s_%s_FDR.png',root_path,output_stem,contrast_name{contrast_idx}));
    close;

end;

return;
