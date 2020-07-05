clear;
close all;
clc;

currentImage = ' Al Balls 1mm 57.5mm 71-4.dcm';

% Load DICOM image
dicomImage = dicomread('/Users/lucasmeader/Downloads/Lucas_data/Al_balls_1mm/7_5mm/26_1.dcm');
% dicomImage = dicomread('/Users/lucasmeader/Downloads/Lucas_data/Al_balls_1mm/30mm/49_4.dcm');
% dicomImage = dicomread('/Users/lucasmeader/Downloads/Lucas_data/Al_balls_1mm/57_5mm/71_4.dcm');

% Set top left ball centre x,y
imshow(dicomImage,[]);
[firstX,firstY] = ginput(1);

%% Al Ball Analysis Loop. 
%Moves to each ball, analyses and stores the results in the results variable
results = zeros(5, 30); % Initialise matrix for storing results six rows of five balls
c = 1;                  % count for matrix 
y = firstY;                % Starting y coordinate

for a = 1:6             % Step in y direction
x = firstX;                % Starting x coordinate
    for b = 1:5         % Step in x direction
    [contrast, CNR, SNR] = OPTIMAM_OUTPUT_ANALYSIS(x, y, dicomImage);
    results(1,c) = contrast;    % Store contrast in results matrix
    results(2,c) = CNR;         % Store CNR in results matrix
    results(3,c) = SNR;         % Store SNR in results matrix
    results(4,c) = x;           % x coordinate for the current A1 centre being analysed
    results(5,c) = y;           % y coordinate for the current A1 centre being analysed
    x = x+589;                  % Step 589pxls in x direction
    c = c+1;                    % Matrix increment step in x direction
    end
    
x = firstX;                        % Reset x to 182 for next interation
y = y+588.5;                      % Step of 589pxls in y direction

end

%% 3D Plot Function
plot3D(results,firstX,firstY, currentImage)
figure 
%% DICOM Measurement Areas Visualisation Function
extractionAreasVisualisation(dicomImage,firstX,firstY, currentImage);

%% MEASUREMENT ANALYSIS FUNCTION
function [contrast, CNR, SNR] = OPTIMAM_OUTPUT_ANALYSIS(x, y, dicomImage)

% dicomImage = dicomread('/Users/lucasmeader/Downloads/Lucas_data/Al_balls_1mm/7_5mm/26_1.dcm');

AlCentre = imcrop(dicomImage, [x-1 y-1 2 2]);
meanSignal = mean(AlCentre,'all');
close all;

% EXTRACT 10x10 PIXEL VALUES FROM FOUR POINTS N, S, E AND WEST OF EACH TEST
% POINT
AlExternal10x10_N = imcrop(dicomImage, [x-5 y-35 9 9]); % NORTH
AlExternal10x10_E = imcrop(dicomImage, [x+25 y-5 9 9]); % EAST
AlExternal10x10_S = imcrop(dicomImage, [x-5 y+30 9 9]); % SOUTH
AlExternal10x10_W = imcrop(dicomImage, [x-35 y-5 9 9]); % WEST

% EXTRACT 3x3 PIXEL VALUES FROM FOUR POINTS N, S, E AND WEST OF EACH TEST
% POINT
AlExternal3x3_N = imcrop(dicomImage, [x-1 y-31 2 2]);    % NORTH
AlExternal3x3_E = imcrop(dicomImage, [x+29 y-1 2 2]);    % EAST
AlExternal3x3_S = imcrop(dicomImage, [x-1 y+31 2 2]);    % SOUTH
AlExternal3x3_W = imcrop(dicomImage, [x-31 y-1 2 2]);    % WEST

close all;

% CALCULATE COMBINED MEAN FOR ALL FOUR 10x10 EXTERNAL MEASUREMENT POINTS
sumAlExternal10x10_N = sum(AlExternal10x10_N, 'all');
sumAlExternal10x10_E = sum(AlExternal10x10_E, 'all');
sumAlExternal10x10_S = sum(AlExternal10x10_S, 'all');
sumAlExternal10x10_W = sum(AlExternal10x10_W, 'all');
sumTotal10x10 = sumAlExternal10x10_N + sumAlExternal10x10_E + sumAlExternal10x10_S + sumAlExternal10x10_W;
meanNoise10x10 = sumTotal10x10/400;
%centreMeanMinusTotalExternalMean = centreMean - total10x10ExternalMean;

% CALCULATE COMBINED MEAN FOR ALL FOUR 3x3 EXTERNAL MEASUREMENT POINTS
sumAlexternal3x3_N = sum(AlExternal3x3_N, 'all');
sumAlexternal3x3_E = sum(AlExternal3x3_E, 'all');
sumAlexternal3x3_S = sum(AlExternal3x3_S, 'all');
sumAlexternal3x3_W = sum(AlExternal3x3_W, 'all');
sumTotal3x3 = sumAlexternal3x3_N + sumAlexternal3x3_E + sumAlexternal3x3_S + sumAlexternal3x3_W;
meanNoise3x3 = sumTotal3x3/36;


% MEAN SIGNAL (S)
meanSignal;

% MEAN NOISE 10x10 (B)
meanNoise10x10;

% STANDARD DEVIATION SIGNAL (sigmaS)
standardDeviationSignal = std2(AlCentre);

% STANDARD DEVIATION NOISE 10x10 (sigmaB)
external10x10MeasurementSamplesMatrix = [AlExternal10x10_N AlExternal10x10_E AlExternal10x10_S AlExternal10x10_W];
standardDeviationNoise10x10 = std2(external10x10MeasurementSamplesMatrix);

% CONTRAST
contrast = (abs(meanSignal - meanNoise10x10)) / meanNoise10x10;

% CONTRAST-NOISE-RATIO
CNR = (abs(meanSignal - meanNoise10x10)) / standardDeviationNoise10x10;

% SIGNAL-NOISE-RATIO
SNR = meanSignal / standardDeviationNoise10x10;

% MEAN NOISE 3x3
meanNoise3x3;

% STANDARD DEVIATION NOISE 3x3
external3x3MeasurementSamplesMatrix = [AlExternal3x3_N AlExternal3x3_E AlExternal3x3_S AlExternal3x3_W];
standardDeviationNoise3x3 = std2(external3x3MeasurementSamplesMatrix);


end