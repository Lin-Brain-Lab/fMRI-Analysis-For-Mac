1. rename triggers in the way you want to organise them
2. make sure you are in the directory that you want the files to go in 
3. open eeglab command window 'eeglab'
4. flie/import data/using eeg pab functions and /from brainvision vhdr file/slecet the vhdr file you want to analyse
5. ok to first prompt
6. name dataset pt_s001_eeg1
7. if fmri-eeg have 5000 sampling rate, chech number of channels
8. reference to TP9 & TP10, tools/rereference data, then rereference data to channeld TP9 &TP10, ok name pt_s001_eeg1_ref save fine and browse name and save file
9. channel data scroll: reject bad data: plot/channel datascrool. change scame to 200 then settings timetrange to 30. click and drag to delete noise or beginning of experiement before protocol starts and at the end, click forward to look through and  after done highlighting then reject. one rejected label with extra underscore at the _rej

good idea to do a fast fourier transform here to see the specific bandpass and notch filter for this data

11. bandpass filter: clean up data: kind of trial and error but for the most part, tools/fileter data/bastic FIR filter, low range 1 high 40, ok. save dataset with extra _bnd and save
12. notch filter: erplab/filtering frequenct tools/ filters for eeg data, set parkmclean notch filter at 60Hz (at 60Hz done when eeg not doen in faraday cage, my data is eeg-fmri so it is in faraday cage). save dataset with extra _not and save
13. ICA (independetn component analysis): tools/decompoase data by ISC, leave at default, get rid of ECG if you have it. click use all channels select all except ECG. takes long. To cheeck if you chose the correct channel for vertical and horizontal headmovement go to plot/component maps/2d, vertical eyemoviement are lines right to left horizontal go up down (mostly channel 1 and 3)
14. ocular correction (blinkinh and slide to side eye movements): plot/component activation scroll, set scale to 100, settings timerange display 20ms, look for channels with eyeblinds or movemnts, click channels with these artefacts. tools/removevomponents from data, remove the ones with eye clips, plot single tiral to double chect these are the ones you want to remove, change timerange to 100 and setting timereage to display 20, red is new blue is old one, then accept and save with new _o
15. make event list: erplab/event list/create eeg event list/continue/advanced/ put event code number, the label, binn number and bin descrobtopn and update line, then apply, save, continue/overwrite if there are changes to event list, click numeric codes and applu, save with extra _eve
16. extract bin-based epoch: erplab/extract bin-based epochs/ -200 - 1000 timerannge/run, save with ectra _epoc
17. average erps how you want to categorise them: erplab/compute averaged erps/run/create new erp name (pt_oo4_eeg8_erp) save as erp/ browse for folder you want to save it
18. bin operations: erplab/erp oerations/erp bin operations/, make a new bin with your hypothesis and subtract or add bins, run. now with new bin erplab/save as new erp set/save with new hypithesis(s)
19. plot: erplab/plot erp/plot erp waveforms, selece which hypothesis you want to disply, slecet which electordes you want to display (literature review), change pos/neg is up depending on literatire, plot
20. to add more subjects/runs: load exisiting erp sets then average across erp sets
