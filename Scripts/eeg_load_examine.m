close all; clear all;

headerFile={
    '../eeg_raw/SSVEP_out_1.vhdr';
    };

% first get the continuous data as a matlab array
eeg{1} = double(bva_loadeeg(headerFile{1}));

% meta information such as samplingRate (fs), labels, etc
[fs(1) label meta] = bva_readheader(headerFile{1}
