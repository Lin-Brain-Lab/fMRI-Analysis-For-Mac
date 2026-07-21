
%script used to calculate number of subjects needed to increase power to 80% at 0.05 alpha based on beta values from emoclips GLM

%% ====== USER INPUTS ======
base = '/Users/jessica/data_analysis/emoclips';
subj_ids  = {'s002','s010','s011','s013','s014','s015','s017','s018','s021','s022'};
hemi_list = {'lh','rh'};
atlas     = 'aparc'; 
roi_list  = ["caudalmiddlefrontal","precentral","superiorfrontal","insula","bankssts","caudalanteriorcingulate","cuneus","entorhinal","fusiform","inferiorparietal","inferiortemporal","isthmuscingulate","lateraloccipital","lateralorbitofrontal","lingual","medialorbitofrontal","middletemporal","parahippocampal","paracentral","parsopercularis","parsorbitalis","parstriangularis","pericalcarine","postcentral","posteriorcingulate","precuneus","rostralanteriorcingulate","rostralmiddlefrontal","superiorfrontal","superiorparietal","superiortemporal","supramarginal","frontalpole","temporalpole","transversetemporal"]; % cMFG, PreCG
fs_subj   = 'fsaverage';

FN.unsigned.personal.lh = 'Individual_Unsigned_July20-lh.stc';
FN.unsigned.personal.rh = 'Individual_Unsigned_July20-rh.stc';
FN.unsigned.group   .lh = 'Group_Unsigned_July20-lh.stc';
FN.unsigned.group   .rh = 'Group_Unsigned_July20-rh.stc';

FN.signed.personal.lh = 'Individual_Signed_July20-lh.stc';
FN.signed.personal.rh = 'Individual_Signed_July20-rh.stc';
FN.signed.group   .lh = 'Group_Signed_July20-lh.stc';
FN.signed.group   .rh = 'Group_Signed_July20-rh.stc';

%% ====== LOAD ANNOTATIONS ======
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

%% ====== LOOP OVER ALL SUBJECTS/CONDITIONS/ROIS ======
rows = {};
for si = 1:numel(subj_ids)
    s = subj_ids{si};
    for vtype = ["unsigned","signed"]
        for rtype = ["personal","group"]
            for r = 1:numel(roi_list)
                nm = roi_list(r);
                hemi_vals = [];
                for h = 1:numel(hemi_list)
                    hemi = hemi_list{h};
                    fn = FN.(vtype).(rtype).(hemi);
                    stc_path = fullfile(sprintf('%s/%s/fmri_analysis', base, s), fn);
                    [stc_data, stc_verts] = inverse_read_stc(stc_path);
                    if size(stc_data,2) > 1
                        stc_beta = mean(stc_data,2);
                    else
                        stc_beta = stc_data;
                    end
                    roi_verts = find(ann.(hemi).label_ids == roi_val.(hemi).(nm)) - 1;
                    [~, ia] = intersect(stc_verts, roi_verts,'stable');
                    hemi_vals(end+1) = mean(stc_beta(ia), 'omitnan');
                end
                roi_mean = mean(hemi_vals,'omitnan');
                rows(end+1,:) = {s, char(vtype), char(rtype), char(nm), roi_mean};
            end
        end
    end
end

%% ====== OUTPUT TABLE ======
T = cell2table(rows, 'VariableNames', {'Subject','Valence','Rating','ROI','MeanBeta'});
disp(T);


%% ====== PERSONAL − GROUP DIFFERENCES + COHEN'S dz ======
rois = unique(T.ROI);
vals = unique(T.Valence);

for v = 1:numel(vals)
    vtype = vals{v};
    fprintf('\n--- Personal − Group (Valence = %s) ---\n', vtype);
    for r = 1:numel(rois)
        nm = rois{r};
        % grab personal rows
        tP = T(strcmp(T.Valence,vtype) & strcmp(T.Rating,'personal') & strcmp(T.ROI,nm), :);
        % grab group rows
        tG = T(strcmp(T.Valence,vtype) & strcmp(T.Rating,'group') & strcmp(T.ROI,nm), :);
        % align by subject
        [~, ia, ib] = intersect(tP.Subject, tG.Subject, 'stable');
        diffs = tP.MeanBeta(ia) - tG.MeanBeta(ib);

        mu = mean(diffs,'omitnan');
        sd = std(diffs,'omitnan');
        dz = mu/sd;

        fprintf('%-24s : n=%d, mean=%.5f, sd=%.5f, dz=%.2f\n', nm, numel(diffs), mu, sd, dz);
    end
end
%% ====== POWER ANALYSIS (SIGNIFICANT ROIs ONLY) ======
alpha = 0.05;
power_target = 0.80;

rois = unique(T.ROI);
vals = unique(T.Valence);

for v = 1:numel(vals)
    vtype = vals{v};
    fprintf('\n--- Significant ROIs (Valence = %s, p < %.2f) ---\n', vtype, alpha);

    sig_found = false;

    for r = 1:numel(rois)
        nm = rois{r};

        % Personal rows
        tP = T(strcmp(T.Valence,vtype) & strcmp(T.Rating,'personal') & strcmp(T.ROI,nm), :);

        % Group rows
        tG = T(strcmp(T.Valence,vtype) & strcmp(T.Rating,'group') & strcmp(T.ROI,nm), :);

        % Align subjects
        [~, ia, ib] = intersect(tP.Subject, tG.Subject, 'stable');
        diffs = tP.MeanBeta(ia) - tG.MeanBeta(ib);

        mu = mean(diffs,'omitnan');
        sd = std(diffs,'omitnan');

        if sd==0 || ~isfinite(sd)
            continue
        end

        dz = mu/sd;

        % Paired t-test
        [~, p, ~, stats] = ttest(diffs);

        % Only report significant ROIs
        if p < alpha

            sig_found = true;

            n_req = sampsizepwr('t',[0 sd],mu,power_target,[], ...
                'Alpha',alpha);

            fprintf('%-24s : p=%.5f, t(%d)=%.2f, dz=%.2f, Required N=%d\n', ...
                nm, p, stats.df, stats.tstat, dz, ceil(n_req));

        end
    end

    if ~sig_found
        fprintf('No ROIs reached p < %.2f\n', alpha);
    end
end