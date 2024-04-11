clear; close all; clc;

%表示用の関数の定義
function [] = display(x, y, min, max)
    figure;
    plot(x, y);
    grid on;
    xlim([min, max]);
end

%定義
sinFreq = 1;
fs = 16000;
signalTime = 10;
windowLength = 2 ^ 11;
shiftLength = 2 ^ 10;

%正弦波(入力信号)の生成
signalLength = signalTime * fs;
inputSignalAxis = (linspace(0, signalTime, signalLength)).';
inputSignal = sin(2 * pi * sinFreq * inputSignalAxis);
display(inputSignalAxis, inputSignal, 0, signalTime);

%ハン窓の生成
hannWindowAxis = (linspace(0, windowLength - 1, windowLength)).';
hannWindow = 0.5 - 0.5 * cos((2 * pi * hannWindowAxis) / (windowLength - 1));
display(hannWindowAxis, hannWindow, 0, windowLength - 1);

%入力信号の零埋め,入力信号の分割,窓関数の乗算,行列化
timeFrames = ceil((signalLength - windowLength) / shiftLength) + 1;
A = zeros(windowLength, timeFrames);
complementedInputSignal = padarray(inputSignal, windowLength - 1, 0, "post");
for i = 1 : timeFrames
    shortTimeSignal = complementedInputSignal(((i - 1) * shiftLength + 1) : ((i - 1) * shiftLength + windowLength));
    multipliedShortTimeSignal = shortTimeSignal .* hannWindow;
    A(:, i) = multipliedShortTimeSignal;
end

%行列の表示
disp(A);
