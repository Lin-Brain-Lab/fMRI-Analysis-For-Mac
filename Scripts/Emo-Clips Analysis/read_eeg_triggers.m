markerFile={
    '/Users/jessica/data_analysis/emoclips/s013/eeg/s013_emoclips_002.vmrk';
    '/Users/jessica/data_analysis/emoclips/s013/eeg/s013_emoclips_003.vmrk';
    '/Users/jessica/data_analysis/emoclips/s013/eeg/s013_emoclips_004.vmrk';
    };


%these two tokens are required (but values are arbitrary) for data
%collected inside MRI
trigger_token=1e3;
sync_token=1e2;

for f_idx=1:length(markerFile)

    %read maker file
    fprintf('\treading trigger codes in %s...\n', markerFile{f_idx});
    mk=textread(markerFile{f_idx},'%s','headerlines',12,'delimiter','\n');
    if(~isempty(mk))
        for mk_idx=1:length(mk)
            tmp=strfind(mk{mk_idx},',');
            for tmp_idx=1:length(tmp)+1
                if(tmp_idx==1)
                    bb=1;
                else
                    bb=tmp(tmp_idx-1)+1;
                end
                if(tmp_idx==length(tmp)+1)
                    ee=length(mk{mk_idx});
                else
                    ee=tmp(tmp_idx)-1;
                end
                mk_tmp{tmp_idx}=mk{mk_idx}(bb:ee);
            end

            if(strcmp(mk_tmp{2},'R128')) %MRI trigger
                trigger{f_idx}.event(mk_idx)=trigger_token;
                trigger{f_idx}.time(mk_idx)=str2num(mk_tmp{3}); %data index for the trigger
            elseif(~isempty(findstr(mk_tmp{2},'Sync'))) %sync
                trigger{f_idx}.event(mk_idx)=sync_token;
                trigger{f_idx}.time(mk_idx)=str2num(mk_tmp{3}); %data index for the trigger
            else %true events
                trigger{f_idx}.event(mk_idx)=str2num(mk_tmp{2}(2:end)); %trigger
                trigger{f_idx}.time(mk_idx)=str2num(mk_tmp{3}); %data index for the trigger
            end
        end
        dummy=sort(trigger{f_idx}.event);
        events=[dummy(find(diff(dummy))),dummy(end)];
        fprintf('\t\ttotal [%d] events found : {%s}\n',length(events),mat2str(events));
    else
        trigger{f_idx}=[];
    end

    %getting ERP
    erp_event=num2cell(events);
    for event_idx=1:length(erp_event)
        tmp=erp_event{event_idx};
        trials=[];
        for ii=1:length(tmp)
            trials=union(trials,find(trigger{f_idx}.event==tmp(ii)));
        end
        fprintf('\t[%d] events found for trigger [%s]...\n',length(trials),num2str(erp_event{event_idx}));
    end

end
