close all; clear all;
% this script makes a .para file for each run
headerFile = {
    % '../eeg/s008_emoclips_0001.vhdr';
    % '../eeg/s008_emoclips_0002.vhdr';
      '../eeg/s008_emoclips_0003.vhdr';
    };

markerFile={
    % '../eeg/s008_emoclips_0001.vmrk';
    % '../eeg/s008_emoclips_0002.vmrk';
      '../eeg/s008_emoclips_0003.vmrk';
    };
%erp_event={1e3, [1 10]}; % input the unique triggers for your dataset here. [] means treat these
%triggers as the same condition. 1e3 is the MRI trigger
erp_event={1e3, [1 2 3 4 5], [11 12 13 14 15 16 17], [51 52 53 54 55 56 57 58], [61 62 63 64 65 66 67 68 69 70 71 72], [81 82 83 84 85 86 87 88 89], [90 91 92 93 94 95 96 97 98 99], [100 101 102 103 104 105 106 107 108 109], [111 112 113 114 115 116 117 118]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EEG setup
%

TR=2; %second

%these two tokens are required (but values are arbitrary) for data
%collected inside MRI
trigger_token=1e3;
sync_token=1.5e2;
newseg_token=1.5e3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for f_idx=1:length(headerFile)
    [dummy,fstem]=fileparts(headerFile{f_idx});
    fprintf('reading [%s]...\n',fstem);


    % meta information such as samplingRate (fs), labels, etc
    [fs(f_idx) label meta] = bva_readheader(headerFile{f_idx});



    %read maker file
    fprintf('\treading triggers...\n');
    mk=textread(markerFile{f_idx},'%s','headerlines',12,'delimiter','\n');
    if(~isempty(mk))
        for mk_idx=1:length(mk)
            tmp=strfind(mk{mk_idx},',');
            for tmp_idx=1:length(tmp)+1
                if(tmp_idx==1)
                    bb=1;
                else
                    bb=tmp(tmp_idx-1)+1;
                end;
                if(tmp_idx==length(tmp)+1)
                    ee=length(mk{mk_idx});
                else
                    ee=tmp(tmp_idx)-1;
                end;
                mk_tmp{tmp_idx}=mk{mk_idx}(bb:ee);
            end;

            if(strcmp(mk_tmp{2},'V  1')) | (strcmp(mk_tmp{2},'R128')) %MRI trigger (check if the volume trigger is denoted at R128 or V  1)
                trigger{f_idx}.event(mk_idx)=trigger_token;
                trigger{f_idx}.time(mk_idx)=str2num(mk_tmp{3}); %data index for the trigger
            elseif(~isempty(findstr(mk_tmp{2},'Sync'))) %sync
                trigger{f_idx}.event(mk_idx)=sync_token;
                trigger{f_idx}.time(mk_idx)=str2num(mk_tmp{3}); %data index for the trigger
            elseif(isempty(mk_tmp{2})) %new segment, empty between comma in mk
                trigger{f_idx}.event(mk_idx)=newseg_token;
                trigger{f_idx}.time(mk_idx)=str2num(mk_tmp{3}); %data index for the trigger
            else %true events
                trigger{f_idx}.event(mk_idx)=str2num(mk_tmp{2}(2:end)); %trigger
                trigger{f_idx}.time(mk_idx)=str2num(mk_tmp{3}); %data index for the trigger
            end;
        end;
        dummy=sort(trigger{f_idx}.event);
        events=[dummy(find(diff(dummy))),dummy(end)];
        fprintf('\t\ttotal [%d] events found : {%s}\n',length(events),mat2str(events));
    else
        trigger{f_idx}=[];
    end;

    for event_idx=1:length(erp_event)
        tmp=erp_event{event_idx};
        trials=[];
        for ii=1:length(tmp)
            trials=union(trials,find(trigger{f_idx}.event==tmp(ii)));
        end;
        fprintf('\t[%d] events found for trigger [%s]...\n',length(trials),num2str(erp_event{event_idx}));
    end;


    file_para=sprintf('%s_soa.para',fstem);

    fprintf('writing [%s]....\n',file_para);
    fp=fopen(file_para,'w');

    soa_offset=0; %adjustment for slice-timing correction; second
    mri_idx=find(trigger{f_idx}.event==1e3);
    soa_start=min(trigger{f_idx}.time(mri_idx)./fs(f_idx));

    for idx=1:length(trigger{f_idx}.time)
        fprintf(fp,'%2.2f\t%d\n',trigger{f_idx}.time(idx)./fs(f_idx)+soa_offset-soa_start,trigger{f_idx}.event(idx));
        %fprintf(fp,'%2.2f\t%d\n',round((trigger{f_idx}.time(idx)./fs(f_idx)+soa_offset-soa_start)/TR)*TR,trigger{f_idx}.event(idx));
    end;

    fclose(fp);

end;


return;
