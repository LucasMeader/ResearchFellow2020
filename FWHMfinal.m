clear;
close all;
clc;

%% ---- Set name for plot headers
currentImage = ' Al Balls 1mm 57.5mm 71-4.dcm';

%% ---- Load DICOM image
dicomImage = dicomread('/Users/lucasmeader/Downloads/Lucas_data/Al_balls_1mm/7_5mm/26_2.dcm');

%% --- Choose top left ball and bottom right ball 
imshow(dicomImage,[]);
[X,Y] = ginput(2);

%% --- add 50 pixel boarder around selected balls and crop that area
topLeftX = X(1)-50;
topLeftY = Y(1)-50;
width = X(2)-topLeftX+50;
hight = Y(2)-topLeftY+50;
croppedImage = imcrop(dicomImage, [topLeftX topLeftY width hight]);

%% --- apply binary mask
BW = (croppedImage > 25000);
BW2 = bwareafilt(BW,[135 200]);
imshow(BW2);

%% --- Find the center of each ball and show as blue circle so they can be checked
[centers, radii, metric] = imfindcircles(BW2,[6 15]);
viscircles(centers, radii,'EdgeColor','b');

amountOfBalls = length(centers(:,1));

%% --- initialise fwhm array
fwhm = zeros(1,amountOfBalls); % Initialise FWHM array
c = 1;
for y = 1:amountOfBalls
    
    %% ---- centre of the ball col = x position, row = y position
    col = round(centers(y,1));
    row = round(centers(y,2));
    
    %% ---- Iterate over each array and create a matrix for all balls in x and y
    startOfLineX = col-40;
    startOfLineY = row-40;
    for d = 1:80
        xMeasurementMatrix(c,d) = croppedImage(row,startOfLineX+d);
        yMeasurementMatrix(c,d) = croppedImage(startOfLineY+d,col);
    end
    c = c+1;                    % Matrix increment step in x direction
    
    %% ------ Set any value that is lower than the 
    %% ------ background mean to the background mean 
    xMeasurementMatrixFirstHalf = xMeasurementMatrix(y,1:35);                       % Create a new array containing the background information from the left of the ball
    xMeasurementMatrixSecondHalf = xMeasurementMatrix(y,56:end);                   % Create a new array containing the background information from the right of the ball
    concatBackground = [xMeasurementMatrixFirstHalf, xMeasurementMatrixSecondHalf]; % an array containing just the background information
    xBackgroundMean = mean(concatBackground);                                       % background mean
    % xMeasurementMatrix(y,1:35) = xBackgroundMean;                                   % replace backgound values with the mean background value
    % xMeasurementMatrix(y,55:end) = xBackgroundMean;                                % replace backgound values with the mean background value
    arrayLength = length(xMeasurementMatrix(y, :));                                 % determine the length of the orginal array       
    for idx = 1:arrayLength    % change all values lower than the background mean to the background mean value
        if xMeasurementMatrix(y,idx) <= xBackgroundMean
            xMeasurementMatrix(y,idx) = xBackgroundMean;
        end
    end
    
    fullArray = xMeasurementMatrix(y,30:50);
    fullArrayMinusBackground = fullArray - xBackgroundMean;
    
    %% --- First Half ---
    firstValues = double(fullArray(1:10));
    firstValues = abs(firstValues);
    firstValues = firstValues - xBackgroundMean; % values minus background
    smallOffset = 0.00001 : 0.00001 : 0.00001*length(firstValues);
    yValues = firstValues + smallOffset;
    xValues = 1:1:1*length(firstValues);
    half_max = double(max(fullArrayMinusBackground))/2;
    firstHalf = interp1(yValues, xValues, half_max);
    
    %% --- Second Half ---
    secondValues = double(fullArray(11:21));
    secondValues = abs(secondValues);
    secondValues = secondValues - xBackgroundMean; % values minus background
    smallOffset = 0.00001 : 0.00001 : 0.00001*length(secondValues);
    yValues = secondValues + smallOffset;
    xValues = 1:1:1*length(secondValues);
    half_max = double(max(fullArrayMinusBackground))/2;
    secondHalf = interp1(yValues, xValues, half_max);
    secondHalfAdjusted = secondHalf + length(firstValues);
    
    %% --- Plot ---
    figure,
    plot(fullArrayMinusBackground);
    hold on
    plot(firstHalf,half_max, 'o');
    hold on
    plot(secondHalfAdjusted,half_max, 'o');
    line([0, 20],[half_max,half_max]);
 
end   
    fwhm(y) = secondHalfAdjusted - firstHalf;
    
    %% --- Plot ---
    figure,
    plot(fullArrayMinusBackground);
    hold on
    plot(firstHalf,half_max, 'o');
    hold on
    plot(secondHalfAdjusted,half_max, 'o');
    line([0, 20],[half_max,half_max]);
    % -------------
% centers(:,1) = min(centers(:,1)) + centers(1,1); 
% centers(:,2) = min(centers(:,2)) + centers(1,2);
