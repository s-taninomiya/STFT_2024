function [S] = calcSTFT(inputSignal, fs, windowLength, shiftLength)
%入力信号の取得
ts = 1 / fs;
signalLength = length(inputSignal);
signalTime = ts * signalLength;

%ハン窓の生成
hannWindowAxis = (linspace(0, windowLength - 1, windowLength)).';
hannWindow = 0.5 - 0.5 * cos((2 * pi * hannWindowAxis) / (windowLength - 1));

%入力信号の零埋め,入力信号の分割,窓関数の乗算,行列化,複素スペクトログラム化
timeFrames = ceil((signalLength - windowLength) / shiftLength) + 1;
S = zeros(windowLength, timeFrames);
complementedInputSignal = padarray(inputSignal, windowLength - 1, 0, "post");
for i = 1 : timeFrames
    shortTimeSignal = complementedInputSignal(((i - 1) * shiftLength + 1) : ((i - 1) * shiftLength + windowLength));
    multipliedShortTimeSignal = shortTimeSignal .* hannWindow;
    S(:, i) = fft(multipliedShortTimeSignal);
end

%パワースペクトログラム化,表示
powerS = 20 * log10(abs(S) .^ 2);
displayColorMap(powerS, signalTime, fs);
end

%カラーマップ表示用の関数の定義
function [] = displayColorMap(matrix, timeMax, freqMax)
figure;
imagesc([0, timeMax], [0, freqMax], matrix);
axis xy;
xlim([0, timeMax]);
ylim([0, freqMax / 2]);
xlabel("Time[s]");
ylabel("Frequency[Hz]");
set(gca, "FontSize", 18, "FontName", "Times");
end
