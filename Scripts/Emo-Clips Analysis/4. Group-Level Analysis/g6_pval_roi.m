close all; clear;

%% ================= USER INPUTS =================
root_path = '/Users/jessica/data_analysis/emoclips';
subj_ids  = {'s002','s011','s013','s014','s015','s017','s018','s021','s022','s010'};
hemi_list = {'lh','rh'};
fs_subj   = 'fsaverage';
atlas     = 'aparc';

roi_list  = ["caudalmiddlefrontal","precentral","superiorfrontal","insula","bankssts", ...
             "caudalanteriorcingulate","cuneus","entorhinal","fusiform","inferiorparietal", ...
             "inferiortemporal","isthmuscingulate","lateraloccipital","lateralorbitofrontal", ...
             "lingual","medialorbitofrontal","middletemporal","parahippocampal","paracentral", ...
             "parsopercularis","parsorbitalis","parstriangularis","pericalcarine","postcentral", ...
             "posteriorcingulate","precuneus","rostralanteriorcingulate","rostralmiddlefrontal", ...
             "superiorfrontal","superiorparietal","superiortemporal","supramarginal", ...
             "frontalpole","temporalpole","transversetemporal"];

alpha = 0.05;

out_dir = fullfile(root_path,'group_level');
if exist(out_dir,'dir')~=9, mkdir(out_dir); end

%% ================= CONTRASTS (EDIT THESE LINES ONLY) =================
% Each contrast{k} is two STC stems WITHOUT -lh/-rh.stc.
% Weights apply in the same order.
%
% Examples:
%   Group - Individual : [-1  1]
%   Individual - Group : [ 1 -1]
%   Sum                : [ 1  1]

%% normalized
% 
contrast{1}        = {'Individual_Unsigned_July20','Group_Unsigned_July20'};   
contrast_weight{1} = [1 0];                                 
contrast_name{1}   = 'normunssigned_group_minus_indiv';              
output_stem        = 'bsigned';         

%% not normalized
% contrast{1}        = {'sep5_emo_vs_neu','Sep10_emovsneu'};   % sep5individual, Sep10group
% contrast_weight{1} = [1 0];                                 
% contrast_name{1}   = 'unsigned_in_minus_group';              
% output_stem        = 'bunsigned';   


%% ================= LOAD ANNOTATIONS =================
SUBJECTS_DIR = getenv('SUBJECTS_DIR');

ann = struct();
roi_val = struct();

for h = 1:numel(hemi_list)
    hemi = hemi_list{h};
    annot_path = fullfile(SUBJECTS_DIR, fs_subj, 'label', sprintf('%s.%s.annot', hemi, atlas));
    [~, label_ids, ctab] = read_annotation(annot_path);

    ann.(hemi).label_ids = label_ids;
    ann.(hemi).names     = string(cellstr(ctab.struct_names));
    ann.(hemi).vals      = ctab.table(:,5);

    for r = 1:numel(roi_list)
        nm = roi_list(r);
        idx = find(strcmpi(ann.(hemi).names, nm));
        roi_val.(hemi).(nm) = ann.(hemi).vals(idx);
    end
end

%% ================= MAIN LOOP OVER CONTRASTS =================
for contrast_idx = 1:numel(contrast)

    stems = contrast{contrast_idx};
    w = contrast_weight{contrast_idx}(:);

    if numel(stems)~=2 || numel(w)~=2
        error('This script expects exactly 2 conditions per contrast.');
    end

    % safe names for files
    safe_cname = regexprep(contrast_name{contrast_idx}, '[^a-zA-Z0-9_]', '_');

    fprintf('\n=================================================\n');
    fprintf('Contrast %d: %s\n', contrast_idx, safe_cname);
    fprintf('Definition: (%.3f * %s) + (%.3f * %s)\n', w(1), stems{1}, w(2), stems{2});
    fprintf('=================================================\n');

    %% ---------- PART A: VERTEX-WISE MAPS (SAVE STCs FOR VISUALIZATION) ----------
    for hemi_idx = 1:2
        hemi = hemi_list{hemi_idx};

        % stc_diff: [nVerts x nSubj]
        stc_diff = [];

        for si = 1:numel(subj_ids)
            s = subj_ids{si};

            fn1 = fullfile(root_path, s, 'fmri_analysis', sprintf('%s-%s.stc', stems{1}, hemi));
            fn2 = fullfile(root_path, s, 'fmri_analysis', sprintf('%s-%s.stc', stems{2}, hemi));

            if exist(fn1,'file')~=2 || exist(fn2,'file')~=2
                error('Missing STC for subject %s (%s):\n%s\n%s', s, hemi, fn1, fn2);
            end

            [tmp1, v, a, b] = inverse_read_stc(fn1);
            [tmp2, ~, ~, ~] = inverse_read_stc(fn2);

            x1 = tmp1(:,1);
            x2 = tmp2(:,1);

            stc_diff(:,si) = w(1)*x1 + w(2)*x2; %#ok<SAGROW>
        end

        nSubj = size(stc_diff,2);
        df    = nSubj - 1;

        mu = mean(stc_diff, 2, 'omitnan');
        sd = std(stc_diff, 0, 2, 'omitnan');

        t_stat = mu ./ (sd ./ sqrt(nSubj));
        p_val  = 2 * (1 - tcdf(abs(t_stat), df));   % two-sided p map

        fn_t = fullfile(out_dir, sprintf('%s_%s_t-%s.stc', output_stem, safe_cname, hemi));
        fn_p = fullfile(out_dir, sprintf('%s_%s_p-%s.stc', output_stem, safe_cname, hemi));

        inverse_write_stc(repmat(t_stat(:), [1 5]), v, a, b, fn_t);
        inverse_write_stc(repmat(p_val(:),  [1 5]), v, a, b, fn_p);

        fprintf('%s saved:\n  %s\n  %s\n', hemi, fn_t, fn_p);
    end

    %% ---------- PART B: ROI-LEVEL STATS (MATCHING THE SAME CONTRAST) ----------
    % For each ROI and subject:
    %   A = mean(beta in ROI across hemis)
    %   B = mean(beta in ROI across hemis)
    %   contrast_value = w(1)*A + w(2)*B
    %
    % Then one-sample t-test of contrast_value against 0.

    fprintf('\n--- ROI stats (one-sample t-test of contrast vs 0) ---\n');

    roi_results = {};  % {ROI, n, mean, sd, dz, t, df, p}

    for r = 1:numel(roi_list)
        nm = roi_list(r);

        x = nan(numel(subj_ids),1);

        for si = 1:numel(subj_ids)
            s = subj_ids{si};

            hemiA = nan(numel(hemi_list),1);
            hemiB = nan(numel(hemi_list),1);

            for h = 1:numel(hemi_list)
                hemi = hemi_list{h};

                fn1 = fullfile(root_path, s, 'fmri_analysis', sprintf('%s-%s.stc', stems{1}, hemi));
                fn2 = fullfile(root_path, s, 'fmri_analysis', sprintf('%s-%s.stc', stems{2}, hemi));

                [stc1, verts1] = inverse_read_stc(fn1);
                [stc2, verts2] = inverse_read_stc(fn2);

                if size(stc1,2) > 1, beta1 = mean(stc1,2); else, beta1 = stc1; end
                if size(stc2,2) > 1, beta2 = mean(stc2,2); else, beta2 = stc2; end

                roi_verts = find(ann.(hemi).label_ids == roi_val.(hemi).(nm)) - 1;

                [~, ia1] = intersect(verts1, roi_verts, 'stable');
                [~, ia2] = intersect(verts2, roi_verts, 'stable');

                hemiA(h) = mean(beta1(ia1), 'omitnan');
                hemiB(h) = mean(beta2(ia2), 'omitnan');
            end

            A = mean(hemiA, 'omitnan');
            B = mean(hemiB, 'omitnan');

            x(si) = w(1)*A + w(2)*B;
        end

        good = isfinite(x);
        xg = x(good);

        n  = numel(xg);
        mu = mean(xg,'omitnan');
        sd = std(xg,'omitnan');
        dz = mu/sd;

        if n >= 2 && isfinite(sd) && sd > 0
            [~, p, ~, stats] = ttest(xg, 0);  % one-sample against 0
            tval = stats.tstat;
            df   = stats.df;
        else
            p = NaN; tval = NaN; df = NaN;
        end

        fprintf('%-24s : n=%d, mean=%.5f, sd=%.5f, dz=%.2f, t(%g)=%.2f, p=%.6f\n', ...
            nm, n, mu, sd, dz, df, tval, p);

        roi_results(end+1,:) = {char(nm), n, mu, sd, dz, tval, df, p}; %#ok<SAGROW>
    end

    %% ---------- PART C: PRINT SIGNIFICANT ROIS ----------
    fprintf('\nROIs with p < %.2f (Contrast = %s)\n', alpha, safe_cname);
    fprintf('-------------------------------------------------\n');

    pvals = cell2mat(roi_results(:,8));
    [~, order] = sort(pvals);
    roi_results = roi_results(order,:);

    any_sig = false;
    for i = 1:size(roi_results,1)
        if isfinite(roi_results{i,8}) && roi_results{i,8} < alpha
            any_sig = true;
            fprintf('%-24s : p=%.6f, t=%.2f, dz=%.2f, mean=%.5f, sd=%.5f, n=%d\n', ...
                roi_results{i,1}, roi_results{i,8}, roi_results{i,6}, roi_results{i,5}, ...
                roi_results{i,3}, roi_results{i,4}, roi_results{i,2});
        end
    end
    if ~any_sig
        fprintf('None.\n');
    end
end

fprintf('\nDone. Vertex maps saved in:\n%s\n', out_dir);

%to visualise
%brain_stem = sprintf('%s_%s_t', 'unsigned', 'unsigned_group_minus_indiv');
%OR
%brain_stem = sprintf('%s_%s_t', 'signed', 'signed_group_minus_indiv');
%then
%etc_render_fsbrain_stc({brain_stem}, [2.7 3.5]); 
