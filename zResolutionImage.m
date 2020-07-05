close all
clear
clc

geometryNumber = 5;             %Change from 1 to 5 depending on desired geometry
fileName = '75_5mm_calcs.xlsx';   %Options 30mm, 57_5mm and 75_5mm

zResolution = zeros(3527, 2823);
geometryNumberAsString = num2str(geometryNumber);
fileNameForText = strcat(' Calcs 75mm Goemetry- ',  geometryNumberAsString);

filePath = strcat('/Users/lucasmeader/Downloads/',fileName);
calcTable = readtable(filePath);
calcMatrix = table2array(calcTable);
geometryArray = calcMatrix(:,geometryNumber);
geometryArray = geometryArray';

firstX = 182;
firstY = 900;

c = 1;                  % count for matrix 
y = firstY;                % Starting y coordinate

for a = 1:4             % Step in y direction
x = firstX;                % Starting x coordinate
    for b = 1:4         % Step in x direction
         zResolution(y,x) = calcMatrix(c,1);
         geometryArray(2,c) = x;
         geometryArray(3,c) = y;
    x = x+589;                  % Step 589pxls in x direction
    c = c+1;                    % Matrix increment step in x direction
    end
    
x = firstX;                        % Reset x to 182 for next interation
y = y+589;                      % Step of 589pxls in y direction

end

figure('Renderer', 'painters', 'Position', [200 400 2000 800]);

%%-- Plot Contrast
subplot(1,2,1);
x = geometryArray(2,:);
y = geometryArray(3,:);
z = geometryArray(1,:);
xlin = 1:33:2823;   % x axis length and step size in form start:step:finish
ylin = 1:33:3527;   % y axis length and step size in form start:step:finish
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)

%%-- Azimuth elivation
view(   10,     -48)                                                       
title(strcat('\fontsize{16}Z-resolution: ', fileNameForText));
xlabel('Image x values', 'FontSize', 12);
ylabel('Image y values', 'FontSize', 12);
zlabel('z-resolution', 'FontSize', 12);
c = colorbar;
% caxis([0 5])
c.Label.String = 'colorbar';
c.Label.String = 'z-resolution';
c.Label.FontSize = 12;

%%-- Plot Contrast Zenith View
subplot(1,2,2);
x = geometryArray(2,:);
y = geometryArray(3,:);
z = geometryArray(1,:);
xlin = 1:33:2823;
ylin = 1:33:3527;
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)

%%-- Azimuth elivation
view(     0,    -90)
title('\fontsize{16}Z-resolution Zenith View');
xlabel('Image x values', 'FontSize', 12);
ylabel('Image y values', 'FontSize', 12);
zlabel('z-resolution', 'FontSize', 12);
c = colorbar;
% caxis([0 5])
c.Label.String = 'colorbar';
c.Label.String = 'z-resolution';
c.Label.FontSize = 12;
