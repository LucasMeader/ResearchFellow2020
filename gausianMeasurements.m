clear;
close all;
clc;

%% ---- Set name for plot headers
currentImage = ' Al Balls 1mm 57.5mm 71-4.dcm';

%% ---- Load DICOM image
dicomImage = dicomread('/Users/lucasmeader/Downloads/Lucas_data/Al_balls_1mm/7_5mm/26_2.dcm');

ballRows = 3;
ballCols = 3;
amountOfBalls = ballRows*ballCols;
%% ---- Set top left (within the 9x9 region) ball centre x,y
firstX = 183;
firstY = 285;
% imshow(dicomImage,[]);
% [firstX,firstY] = ginput(1);

xMeasurementMatrix = zeros(amountOfBalls,200); % Initialise matrix for storing results 3 rows of 3 balls 200 measurements per ball
yMeasurementMatrix = zeros(amountOfBalls,200); % Initialise matrix for storing results 3 rows of 3 balls 200 measurements per ball

c = 1;                  % count for matrix 
y = firstY;             % Starting y coordinate


for a = 1:ballRows             % Step in y direction
    
    x = firstX;         % Starting x coordinate
    
    for b = 1:ballCols         % Step in x direction
        
%% ---- set top left corner value for cropped area
        topLeftX = x-100; % centre of ball minus 100 pixels in x direction
        topLeftY = y-100; % centre of ball minus 100 pixels in y direction

%% ---- find the centre of the ball within the cropped area
        cropArea = imcrop(dicomImage, [topLeftX topLeftY 199 199]); % creat new image containing one ball
        imshow(cropArea, []);
        centres = imfindcircles(cropArea,[6 15]);                   % find centre of ball using imfindcircles function between radius 7-15 pixels
        centres(1) = round(centres(1));                             % x value rounded to be at the centre of the pixel
        centres(2) = round(centres(2));                             % y value rounded to be at the centre of the pixel
        [fullImageHight, fullImageWidth, fullImageDepth] = size(cropArea);
        
        figure,
        imshow(cropArea, []); hold on; line([centres(1),centres(1)],[0,fullImageHight]); hold on; line([0, fullImageWidth],[centres(2),centres(2)]);       
        
%% ---- centre of the ball col = x position, row = y position
        col = round(centres(1)+topLeftX-1);
        row = round(centres(2)+topLeftY-1);

%% ---- Iterate over each array and create a matrix for all balls in x and y         
        startOfLineX = col-101;
        startOfLineY = row-101;    
        for d = 1:200   
            xMeasurementMatrix(c,d) = dicomImage(row,startOfLineX+d);
            yMeasurementMatrix(c,d) = dicomImage(startOfLineY+d,col);
        end
%% ---- -----------------------
        x = x+589;                  % Step 589pxls in x direction
        c = c+1;                    % Matrix increment step in x direction
    end
    
    x = firstX;                        % Reset x to 182 for next interation
    y = y+588;                      % Step of 589pxls in y direction

end

fwhm = zeros(1,amountOfBalls); % Initialise FWHM array

for y = 1:amountOfBalls
%% ------ Set any value that is lower than the 
%% ------ background mean to the background mean 
    xMeasurementMatrixFirstHalf = xMeasurementMatrix(y,1:85);                       % Create a new array containing the background information from the left of the ball
    xMeasurementMatrixSecondHalf = xMeasurementMatrix(y,120:end);                   % Create a new array containing the background information from the right of the ball
    concatBackground = [xMeasurementMatrixFirstHalf, xMeasurementMatrixSecondHalf]; % an array containing just the background information
    xBackgroundMean = mean(concatBackground);                                       % background mean
    xMeasurementMatrix(y,1:85) = xBackgroundMean;                                   % replace backgound values with the mean background value
    xMeasurementMatrix(y,120:end) = xBackgroundMean;                                % replace backgound values with the mean background value
    arrayLength = length(xMeasurementMatrix(y, :));                                 % determine the length of the orginal array       
    for idx = 1:arrayLength    % change all values lower than the background mean to the background mean value
        if xMeasurementMatrix(y,idx) <= xBackgroundMean
            xMeasurementMatrix(y,idx) = xBackgroundMean;
        end
    end
    
    fullArray = xMeasurementMatrix(y,90:110);
    fullArrayMinusBackground = fullArray - xBackgroundMean;
    
    %% --- First Half ---
    firstValues = fullArray(1:10);
    firstValues = firstValues - 18936.174; % values minus background
    smallOffset = 0.00001 : 0.00001 : 0.00001*length(firstValues);
    yValues = firstValues + smallOffset;
    xValues = 1:1:1*length(firstValues);
    half_max = max(fullArrayMinusBackground)/2;
    firstHalf = interp1(yValues, xValues, half_max);
    
    %% --- Second Half ---
    secondValues = fullArray(11:21);
    secondValues = secondValues - 18936.174; % values minus background
    smallOffset = 0.00001 : 0.00001 : 0.00001*length(secondValues);
    yValues = secondValues + smallOffset;
    xValues = 1:1:1*length(secondValues);
    half_max = max(fullArrayMinusBackground)/2;
    secondHalf = interp1(yValues, xValues, half_max);
    secondHalfAdjusted = secondHalf + length(firstValues);
    
    fwhm(y) = secondHalfAdjusted - firstHalf;
    
    %% --- Plot ---
    figure,
    plot(fullArrayMinusBackground);
    hold on
    plot(firstHalf,half_max, 'o');
    hold on
    plot(secondHalfAdjusted,half_max, 'o');
    line([0, 20],[half_max,half_max]);
    
end

BW = (dicomImage > 25000);
BW2 = bwareafilt(BW,[135 200]);
imshow(BW2);
[centers, radii, metric] = imfindcircles(BW2,[6 15]);
viscircles(centers, radii,'EdgeColor','b'); 
