
%% -- Using the results from the analysis to plot new images focused on specific measurements
%% -- Contrast, CNR and SNR

function [] = plot3D(results,firstX,firstY, currentImage)

contrastColormap = zeros(3527, 2823);
CNRColormap = zeros(3527, 2823);
SNRColormap = zeros(3527, 2823);

c = 1;                  % count for matrix 
y = firstY;             % Starting y coordinate minus 180 so color is visable on the plot

%% -- Allocation loop
for a = 1:6             % Step in y direction
x = firstX;             % Starting x coordinate minus 180 so color is visable on the plot
    for b = 1:5         % Step in x direction
        contrastColormap(y,x) = results(1,c); % Store contrast result values on correct area of the image
        CNRColormap(y,x) = results(2,c);      % Store CNR result values on correct area of the image
        SNRColormap(y,x) = results(3,c);      % Store SNR result values on correct area of the image
    x = x+589;                  % Move in x direction
    c = c+1;                    % matrix increment step in x direction
    end
    
x = firstX;                     % reset x to 182 for next interation minus 180 so color is visable on the plot
y = y+589;                      % step of 589pxls in y direction

end

figure('Renderer', 'painters', 'Position', [200 400 2000 2000]);

%% -- Plot Contrast
subplot(2,3,1);
x = results(4,:);
y = results(5,:);
z = results(1,:);
xlin = 1:33:2823;   % x axis length and step size in form start:step:finish
ylin = 1:33:3527;   % y axis length and step size in form start:step:finish
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)

% -- Azimuth elivation plot viewing angle
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

%% -- Plot Contrast Zenith View
subplot(2,3,4);
x = results(4,:);
y = results(5,:);
z = results(1,:);
xlin = 1:33:2823;
ylin = 1:33:3527;
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)
% -- Azimuth elivation plot viewing angle
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

%% -- Plot Contrast-Noise-Ratio
subplot(2,3,2);
x = results(4,:);
y = results(5,:);
z = results(2,:);
xlin = 1:33:2823;
ylin = 1:33:3527;
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)
% -- Azimuth elivation plot viewing angle
view(   10,     -48)
title(strcat('\fontsize{16}CNR: ', currentImage));
xlabel('Image x values', 'FontSize', 12);
ylabel('Image y values', 'FontSize', 12);
zlabel('Contrast-Noise-Ratio', 'FontSize', 12);
c = colorbar;
% caxis([0.7 1.8])
c.Label.String = 'colorbar';
c.Label.String = 'Contrast-Noise-Ratio';
c.Label.FontSize = 12;

% Plot CNR Zenith View
subplot(2,3,5);
x = results(4,:);
y = results(5,:);
z = results(2,:);
xlin = 1:33:2823;
ylin = 1:33:3527;
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)
% -- Azimuth elivation plot viewing angle
view(     0,    -90)
title('\fontsize{16}CNR Zenith View');
xlabel('Image x values', 'FontSize', 12);
ylabel('Image y values', 'FontSize', 12);
zlabel('Contrast-Noise-Ratio', 'FontSize', 12);
c = colorbar;
% caxis([0.7 1.8])
c.Label.String = 'colorbar';
c.Label.String = 'Contrast-Noise-Ratio';
c.Label.FontSize = 12;

%% Plot Signal-Noise-Ratio
subplot(2,3,3);
x = results(4,:);
y = results(5,:);
z = results(3,:);
xlin = 1:33:2823;
ylin = 1:33:3527;
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)
% -- Azimuth elivation plot viewing angle
view(   10,     -48)
title(strcat('\fontsize{16}SNR: ', currentImage));
xlabel('Image x values', 'FontSize', 12);
ylabel('Image y values', 'FontSize', 12);
zlabel('Signal-Noise-Ratio', 'FontSize', 12);
c = colorbar;
% caxis([0.7 1.8])
c.Label.String = 'colorbar';
c.Label.String = 'Signal-Noise-Ratio';
c.Label.FontSize = 12;

% Plot SNR Zenith View
subplot(2,3,6);
x = results(4,:);
y = results(5,:);
z = results(3,:);
xlin = 1:33:2823;
ylin = 1:33:3527;
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
hold on
plot3(x,y,z,'k.','MarkerSize', 15)
% -- Azimuth elivation plot viewing angle
view(     0,    -90)
title('\fontsize{16}SNR Zenith View');
xlabel('Image x values', 'FontSize', 12);
ylabel('Image y values', 'FontSize', 12);
zlabel('Signal-Noise-Ratio', 'FontSize', 12);
c = colorbar;
% caxis([0.7 1.8])
c.Label.String = 'colorbar';
c.Label.String = 'Signal-Noise-Ratio';
c.Label.FontSize = 12;

end