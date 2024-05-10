close all; clear all;

%source space
file_source_fif='../../subjects/180411_PYY/bem/180411_PYY-5-src.fif';

%BEM
surfin_osk='../../subjects/180411_PYY/bem/outer_skull.surf';
surfin_isk='../../subjects/180411_PYY/bem/inner_skull.surf';
surfin_osc='../../subjects/180411_PYY/bem/outer_skin.surf';

%electrodes
file_elec_loc='../digitizer/PYY.eps';
file_elec_name='../digitizer/PYY.ela';

%output matlab file name
output_name='fwd_prep_041618.mat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[src] = mne_read_source_spaces(file_source_fif);

[verts_isk, faces_isk] = mne_read_surface(surfin_isk);
[verts_osk, faces_osk] = mne_read_surface(surfin_osk);
[verts_osc, faces_osc] = mne_read_surface(surfin_osc);

% load electrode locations
%[elec.label,elec.type,elec.elecpos(:,1),elec.elecpos(:,2),elec.elecpos(:,3)] = textread(file_elec_dat,'%s%d%f%f%f');
%elec.elecpos=elec.elecpos.*10;
elec.elecpos=load(file_elec_loc).*10; %load electrodes; variable 'elec'
elec.elecpos(:,2)=elec.elecpos(:,2)-32; %rough manual alignment
elec.elecpos(:,3)=elec.elecpos(:,3)-50; %rough manual alignment
elec.label=textread(file_elec_name,'%s'); 
points_label=elec.label;

points=[];
etc_render_topo('vol_vertex',verts_osc,'vol_face',faces_osc-1,'topo_aux_point_coords',elec.elecpos./1e3,'topo_aux_point_name',elec.label);
view(-60,20);


save(output_name,'faces_isk','faces_osk','faces_osc','verts_isk','verts_osk','verts_osc','points','src','points_label');


%%%%%%%%
%now use the GUI to do the registration by pressing "k". Upon completing
%the registration, click the "export and save" button (at the lower right corner). Select the file named with output_name to save th
% registered electrode locations to the matlab data file. Registered electrode locations will be also exported as the variabl 
% 'points' should in the matlab environment.
%%%%%%%


return;
