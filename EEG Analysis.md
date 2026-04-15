## 1. Set-Up EEGLAB Environment

1. Create a 'eeg_analysis' folder in each subjects folder to house the eeg files.
2. Enter MATLAB through tcsh shell. Set environment as usual.
3. Change directory to path of EEGLAB folder: /Users/jessica/Documents/MBP_PhD/Lin_Lab/fhlin_toolbox/eeglab2023.0
4. Open with EEGLAB in command window `eeglab`
5. 'Flie/Import data/Using EEGLAB functions and plugins/From Brain Vis. Rec. .vhdr or .ahdr file/', then select the .vhdr file you want to analyse. Select 'Ok' to the first prompt.
6. Re-name dataset to reflect the subject and run number 's001_run1'
7. Check that the number of channels align with what is expected, and that the sampling rate is 5000 Hz if simultaneous EEG-fMRI.

## 2. Re-Reference to TP9/TP10

8. 'Tools/Re-reference the data', select 'Re-reference data to channel(s):' then select the '...' icon and select TP9 & TP10. Select 'Ok' and name the file 's001_run1_REF' check 'save as' and 'browse' to the eeg_analysis folder in the subject folder you are analysing, and save.

## 3. Reject Bad Data

9. 'Plot/Channel data (scroll)'. Change scale to 200 then change the time range to 30 in 'Settings/Time range to display'. Click and drag to select noise or the beginning of experiement (before protocol starts) and at the end. After highlighting the bad data is complete, select 'Reject'. Re-name the file to add '_REJ' at the end.

NOTE: It is a good idea to do a fast fourier transform here to see the specific bandpass and notch filter needed for this data. For the most part, the filtering outline below can work.

## 4. Apply a Bandpass and Notch Filter

10. Bandpass filter: 'Tools/Filter the data/Basic FIR filter', set the low range to 1 and high range to 40. Save the file with an extra _BND.
11. Notch filter: 'ERPLAB/Filter & frequency tools/Filters for EEG data', ensure the Parks McClellan Notch is selected, filter at 60Hz. Save the file with and extra _NOT.

NOTE: A 60Hz notch filter is done when EEG is not collected in a faraday cage. If data is collected by simultaneous EEG-fMRI, it is in faraday cage. 

12. ICA (Independent Component Analysis): 'Tools/Decompoase data by ISC', leave at infomax runica.m (default). Click the 'channels...' button and select all electrodes except the ECG (if you have it), this stop will take some time.

# CONTINUE HERE
13. After ISC, to check if you chose the correct channels for vertical and horizontal head movement, go to plot/component maps/2d, vertical eyemoviement are lines right to left horizontal go up down (mostly channel 1 and 3)
14. ocular correction (blinkinh and slide to side eye movements): plot/component activation scroll, set scale to 100, settings timerange display 20ms, look for channels with eyeblinds or movemnts, click channels with these artefacts. tools/removevomponents from data, remove the ones with eye clips, plot single tiral to double chect these are the ones you want to remove, change timerange to 100 and setting timereage to display 20, red is new blue is old one, then accept and save with new _o
15. make event list: erplab/event list/create eeg event list/continue/advanced/ put event code number, the label, binn number and bin descrobtopn and update line, then apply, save, continue/overwrite if there are changes to event list, click numeric codes and applu, save with extra _eve
16. extract bin-based epoch: erplab/extract bin-based epochs/ -200 - 1000 timerannge/run, save with ectra _epoc
17. average erps how you want to categorise them: erplab/compute averaged erps/run/create new erp name (pt_oo4_eeg8_erp) save as erp/ browse for folder you want to save it
18. bin operations: erplab/erp oerations/erp bin operations/, make a new bin with your hypothesis and subtract or add bins, run. now with new bin erplab/save as new erp set/save with new hypithesis(s)
19. plot: erplab/plot erp/plot erp waveforms, selece which hypothesis you want to disply, slecet which electordes you want to display (literature review), change pos/neg is up depending on literatire, plot
20. to add more subjects/runs: load exisiting erp sets then average across erp sets
