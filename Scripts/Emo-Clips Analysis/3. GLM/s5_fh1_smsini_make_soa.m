close all; clear all;

%run1 
%face
soa_time{1}{1}=[198.89 306.88]; %the first bracket is {run number} the {stimuli type}
soa_duration{1}{1}=[11 9.8]; %s
%object/ place
soa_time{1}{2}=[30.87 92.39]; %s
soa_duration{1}{2}=[10.8 10.8]; %s
%action
soa_time{1}{3}=[108.87 150.89 219.88 438.89]; %s
soa_duration{1}{3}=[11.1 11.7 11.5 16.5]; %s
%emotion
soa_time{1}{4}=[6.89 126.88 260.39 321.89 342.89 414.89 492.88]; %s
soa_duration{1}{4}=[13.8 15.6 10.2 16.2 22.3 16 14.6]; %s
%social
soa_time{1}{5}=[50.4 173.39 236.4 375.89]; %s
soa_duration{1}{5}=[11.1 18.5 12 10.4]; %s
%pain
soa_time{1}{7}=[68.39 278.39 393.89]; %s
soa_duration{1}{7}=[12.75 18 11]; %s
%food
soa_time{1}{8}=467.37; %s
soa_duration{1}{8}=19.7; %s

%run2 
%object/place
soa_time{2}{2}=[6.87 185.39 374.37 455.87]; %s
soa_duration{2}{2}=[10 10.9 6.6 11.6]; %s
%action
soa_time{2}{3}=[125.38 207.87]; %s
soa_duration{2}{3}=[12 15.1]; %s
%emotion
soa_time{2}{4}=[84.88 228.89 359.4]; %s
soa_duration{2}{4}=[12 16.1 10]; %s
%social
soa_time{2}{5}=[24.9 297.87]; %s
soa_duration{2}{5}=[14.3 11.8]; %s
%nonsocial
soa_time{2}{6}=[48.88 65.39 104.36 389.39]; %s
soa_duration{2}{6}=[10.6 11 10.9 11.8]; %s
%pain
soa_time{2}{7}=[149.39 254.37 276.88 317.39 338.39]; %s
soa_duration{2}{7}=[10.6 10.75 15 11.1 13.6]; %s
%food
soa_time{2}{8}=[168.88 411.89 435.89]; %s
soa_duration{2}{8}=[10.3 17.5 10]; %s

%run3
%face
soa_time{3}{1}=[288.9 327.9 387.89]; %s
soa_duration{3}{1}=[11.2 11.7 12.3]; %s
%object/place
soa_time{3}{2}=213.87; %s
soa_duration{3}{2}=6.0; %s
%action
soa_time{3}{3}=[3.88 173.39]; %s
soa_duration{3}{3}=[12.1 13.7]; %s
%emotion
soa_time{3}{4}=[368.39 444.86]; %s
soa_duration{3}{4}=[11.0 11.8]; %s
%social
soa_time{3}{5}=[47.36 132.87 228.89]; %s
soa_duration{3}{5}=[11.1 10.1 14.8]; %s
%nonsocial
soa_time{3}{6}=[69.88 92.39 153.89 197.37 251.37 311.38]; %s
soa_duration{3}{6}=[11.7 10.7 11 10.7 9.9 11]; %s
%pain
soa_time{3}{7}=[266.38 405.87]; %s
soa_duration{3}{7}=[11.64 9.15]; %s
%food
soa_time{3}{8}=[21.87 110.38 347.39 425.4]; %s
soa_duration{3}{8}=[17.15 11.05 11.33 8.650]; %s

output_stem='fahu_dur_fmri_soa';


for f_idx=1:length(soa_time)
    
    %load(file_soa_mat{f_idx});
    trigger=[];
    
    for ii=1:length(soa_time{1}) %different conditions
        %for tt=1:length(soa_time{f_idx}{ii}) %onsets
            tmp.time=soa_time{f_idx}{ii};
            tmp.duration=soa_duration{f_idx}{ii};
            tmp.event=ones(1,length(tmp.time)).*ii;
            if(ii==1)
                trigger=tmp;
            else
                trigger=etc_trigger_append(trigger,tmp);
            end;
        %end;
    end;
    
    fstem=output_stem;
    file_para=sprintf('%s_%02d.para',fstem,f_idx);
    
    fprintf('writing [%s]....\n',file_para);
    fp=fopen(file_para,'w');
    
    for idx=1:length(trigger.time)
        fprintf(fp,'%2.2f\t%s\t%2.2f\n',trigger.time(idx),trigger.event{idx},trigger.duration(idx));
    end;
    
    fclose(fp);
end;
