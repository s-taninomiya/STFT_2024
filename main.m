clear; close all; clc;

% define necessary information for STFT
windowLength = 2 ^ 11;
shiftLength = 2 ^ 10;
windowType = "han";
specVisible = true;
paddingMethod = "end";

% loading audio files
[inputSignal, fs] = audioread("guitar.wav");

% execute calcSTFT
S = calcSTFT(inputSignal, ...
             "fs", fs, ...
             "windowLength", windowLength, ...
             "shiftLength", shiftLength, ...
             "windowType", windowType, ...
             "specVisible", specVisible, ...
             "paddingMethod", paddingMethod);
