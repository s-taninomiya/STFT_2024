function [S] = calcSTFT(inputSignal, args)
%-----------------------------description----------------------------------
% calcSTFT : using Short-Time Fourier Transform, calculate spectrogram
%
% [Input]
%      inputSignal : time-domain signal (signalLength x 1)
%               fs : input signal sampling frequency [Hz] (scalar, default : 44100)
%     windowLength : window length used in STFT (scalar, default : 2048)
%      shiftLength : shift length used in STFT (scalar, default : 1024)
%       windowType : select window function type (string, default : "han")
%      specVisible : select whether to display the spectrogram (logical : default true)
%    paddingMethod : select zero-padding method (string : default "both")
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
    args.windowType (1, 1) string = "han"
    args.specVisible (1, 1) logical = true;
    args.paddingMethod (1, 1) string = "both"
end
fs = args.fs;
windowLength = args.windowLength;
shiftLength = args.shiftLength;
windowType = args.windowType;
specVisible = args.specVisible;
paddingMethod = args.paddingMethod;

% calculate for input signal
ts = 1 / fs;
signalLength = length(inputSignal);
signalTime = ts * signalLength;

% generate window function
windowFunc = generateWindowFunction(windowLength, windowType);

% zero-padding of input signal
%[complementedInputSignal, timeFrames] = zeroPadding(inputSignal, signalLength, windowLength, shiftLength, paddingMethod);
complementedInputSignal = padarray(inputSignal, windowLength - 1, 0, "post");
timeFrames = ceil((signalLength - windowLength) / shiftLength) + 1;

% splitting the input signal, window function multiplication, calculate complex-value spectrogram
S = zeros(windowLength, timeFrames);
for i = 1 : timeFrames
    shortTimeSignal = complementedInputSignal(((i - 1) * shiftLength + 1) : ((i - 1) * shiftLength + windowLength));
    multipliedShortTimeSignal = shortTimeSignal .* windowFunc;
    S(:, i) = fft(multipliedShortTimeSignal);
end

% calculate and display power spectrogram
powerS = 20 * log10(abs(S) .^ 2);
if specVisible == true
    displayColorMap(powerS, signalTime, fs);
end
end

%% Local function
%--------------------------------------------------------------------------
function [windowFunc] = generateWindowFunction(windowLength, windowType)
windowFuncAxis = (linspace(0, windowLength - 1, windowLength)).';
switch windowType
    case "rect"
        windowFunc = (ones(windowLength, 1)).';
    case "han"
        windowFunc = 0.5 - 0.5 * cos((2 * pi * windowFuncAxis) / (windowLength - 1));
    case "hamming"
        windowFunc = 0.54 - 0.46 * cos((2 * pi * windowFuncAxis) / (windowLength - 1));
    case "blackman"
        windowFunc = 0.42 - 0.5 * cos((2 * pi * windowFuncAxis) / (windowLength - 1)) + 0.08 * cos((4 * pi * WindowFuncAxis) / (windowLength - 1));
end
end
%--------------------------------------------------------------------------
function [complementedInputSignal, timeFrames] = zeroPadding(inputSignal, signalLength, windowLength, shiftLength, paddingMethod)
switch paddingMethod
    case "end"
        complementedInputSignal = padarray(inputSignal, windowLength - 1, 0, "post");
        timeFrames = ceil((signalLength - windowLength) / shiftLength) + 1;
    case "both"
        complementedInputSignal = padarray(inputSignal, windowLength / 2, 0, "pre", windowLength - 1, 0, "post");
        %complementedInputSignal = padarray(complementedInputSignal, windowLength / 2, 0, "pre");
        timeFrames = ceil((signalLength * 2 - windowLength) / (shiftLength * 2)) + 1;
end
end
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