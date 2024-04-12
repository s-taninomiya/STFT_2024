clear; close all; clc;

%窓長,シフト長の定義
windowLength = 2 ^ 11;
shiftLength = 2 ^ 10;

%ファイルの読み込み
[inputSignal, fs] = audioread("guitar.wav");

%calcSTFT関数の実行
S = calcSTFT(inputSignal, fs, windowLength, shiftLength);
