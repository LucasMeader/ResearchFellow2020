% function [] = originalImageHeatmap(dicomImage,currentImage)
dicomImage = dicomread('/Users/lucasmeader/Downloads/Lucas_data/Al_balls_1mm/7_5mm/26_1.dcm');

imageArray = zeros(3, 9956721); % Initialise matrix for storing results six rows of five balls
c = 1;                  % count for matrix 

for a = 1:10:3527             % Step in y direction
    for b = 1:10:2823         % Step in x direction
        imageArray(1,c) = a;
        imageArray(2,c) = b;
        imageArray(3,c) = dicomImage(a,b); 
        c = c+1;           % Matrix increment step in x direction
    end
end

figure('Renderer', 'painters', 'Position', [200 400 2000 2000]);
%% Plot Image
subplot(2,3,1);
x = imageArray(1,:);
y = imageArray(2,:);
z = imageArray(3,:);
xlin = 1:33:2823;   % x axis length and step size in form start:step:finish
ylin = 1:33:3527;   % y axis length and step size in form start:step:finish
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)
%     azimuth elivation
view(   10,     -48)                                                       
title(strcat('\fontsize{16}Contrast: ', currentImage));
xlabel('Image x values', 'FontSize', 12);
ylabel('Image y values', 'FontSize', 12);
zlabel('Contrast as Percentage', 'FontSize', 12);
c = colorbar;
caxis([0.7 1.8])
c.Label.String = 'colorbar';
c.Label.String = 'Contrast as Percentage (%)';
c.Label.FontSize = 12;

% Plot Image Zenith View
subplot(2,3,4);
x = imageArray(1,:);
y = imageArray(2,:);
z = imageArray(3,:);
xlin = 1:33:2823;
ylin = 1:33:3527;
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)
%     azimuth elivation
view(     0,    -90)
title('\fontsize{16}Contrast Zenith View');
xlabel('Image x values', 'FontSize', 12);
ylabel('Image y values', 'FontSize', 12);
zlabel('Contrast as Percentage', 'FontSize', 12);
c = colorbar;
% caxis([0.7 1.8])
c.Label.String = 'colorbar';
c.Label.String = 'Contrast as Percentage (%)';
c.Label.FontSize = 12;