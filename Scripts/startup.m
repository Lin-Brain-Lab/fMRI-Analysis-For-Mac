%------------ FreeSurfer -----------------------------%
fshome = getenv('FREESURFER_HOME');
fsmatlab = sprintf('%s/matlab',fshome);
if (exist(fsmatlab) == 7)
    addpath(genpath(fsmatlab));  
end
clear fshome fsmatlab;

%-----------------------------------------------------%

%------------ FreeSurfer FAST ------------------------%
fsfasthome = getenv('FSFAST_HOME');
fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);
if (exist(fsfasttoolbox) == 7)
    path(path,fsfasttoolbox);
end
clear fsfasthome fsfasttoolbox;


%---------------------MNE Home-------------------------%
mnehome = getenv('MNE_ROOT');
mnematlab = sprintf('%s/share/matlab',mnehome);
if (exist(mnematlab) == 7)
    path(path,mnematlab);
end
clear mnehome mnematlab;


%---------------------FSL Setup-----------------------%
setenv( 'FSLDIR', '/Users/jessica/fsl' );
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
fsldir = getenv('FSLDIR');
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
path(path, fsldirmpath);
clear fsldir fsldirmpath;

%----------------fhlin_toolbox------------------------%

addpath (genpath ('/Users/jessica/MBP_PhD/Lin_Lab/fhlin_toolbox'));
setenv('PATH', [getenv('PATH') ':/Users/jessica/MBP_PhD/Lin_Lab/fhlin_toolbox']);

%------------------MBrecon----------------------------%
addpath('/Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/eva_toolbox');
addpath('/Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/eva_toolbox/tool_mb_recon');
addpath('/Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/eva_toolbox/tool_mb_recon');
addpath('/Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/eva_toolbox/tool_mb_recon/VB');
addpath('/Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/eva_toolbox/tool_mb_recon/VD');
addpath('/Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/eva_toolbox/tool_mb_recon/VE');
