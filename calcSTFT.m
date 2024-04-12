function [S] = calcSTFT(inputSignal, args)
%-----------------------------description----------------------------------
% calcSTFT : using Short-Time Fourier Transform, calculate spectrogram
%
% [Input]
%      inputSignal : time-domain signal (signalLength x 1)
%               fs : input signal sampling frequency [Hz] (scalar, default : 44100)
%     windowLength : window length used in STFT (scalar, default : 2048)
%      shiftLength : shift length used in STFT (scalar, default : 1024)
%
% [Output]
%                S : complex-value spectrogram (windowLength x timeFrames)
%--------------------------------------------------------------------------

% check arguments and set default value
arguments
    inputSignal (:, :) double
    args.fs (1, 1) double {mustBeNonnegative} = 44100
    args.windowLength (1, 1) double {mustBeInteger, mustBeNonnegative} = 2048
    args.shiftLength (1, 1) double {mustBeInteger, mustBeNonnegative} = 1024
end
fs = args.fs;
windowLength = args.windowLength;
shiftLength = args.shiftLength;

% calculate for input signal
ts = 1 / fs;
signalLength = length(inputSignal);
signalTime = ts * signalLength;

% generate hannWindow
hannWindowAxis = (linspace(0, windowLength - 1, windowLength)).';
hannWindow = 0.5 - 0.5 * cos((2 * pi * hannWindowAxis) / (windowLength - 1));

% zero-padding of input signal
complementedInputSignal = padarray(inputSignal, windowLength - 1, 0, "post");

% splitting the input signal, window function multiplication, calculate complex-value spectrogram
timeFrames = ceil((signalLength - windowLength) / shiftLength) + 1;
S = zeros(windowLength, timeFrames);
for i = 1 : timeFrames
    shortTimeSignal = complementedInputSignal(((i - 1) * shiftLength + 1) : ((i - 1) * shiftLength + windowLength));
    multipliedShortTimeSignal = shortTimeSignal .* hannWindow;
    S(:, i) = fft(multipliedShortTimeSignal);
end

% calculate and display power spectrogram
powerS = 20 * log10(abs(S) .^ 2);
displayColorMap(powerS, signalTime, fs);
end

%% Local function
%--------------------------------------------------------------------------
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%