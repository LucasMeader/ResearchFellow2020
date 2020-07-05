contrastColormap = zeros(3527, 2823);
CNRColormap = zeros(3527, 2823);
SNRColormap = zeros(3527, 2823);

c = 1;                  % count for matrix 
y = 285-180;                % Starting y coordinate minus 180 so color is visable on the plot

for a = 1:6             % Step in y direction
x = 182-180;                % Starting x coordinate minus 180 so color is visable on the plot
    for b = 1:5         % Step in x direction
        for d = 1:360-1
            for e = 1:360-1
                contrastColormap(y+d,x+e) = results(1,c); % Store contrast result values on correct area of the image
                CNRColormap(y+d,x+e) = results(2,c);      % Store CNR result values on correct area of the image
                SNRColormap(y+d,x+e) = results(3,c);      % Store SNR result values on correct area of the image
            end
        end
    x = x+589;                  % Move in x direction
    c = c+1;                    % matrix increment step in x direction
    end
    
x = 182-180;                        % reset x to 182 for next interation minus 180 so color is visable on the plot
y = y+589;                      % step of 589pxls in y direction

end

%% Contrast results figure
figure('Renderer', 'painters', 'Position', [200 400 2000 600]);
subplot(1,3,1);
imagesc(contrastColormap);
j = jet;
j(1,:) = [1 1 1];
colormap(j);
colorbar;
title('\fontsize{16}Contrast Heatmap for: Al-balls-1mm/7-5mm/26-1.dcm');
xlabel('Image x values');
ylabel('Image y values');
c = colorbar;
c.Label.String = 'colorbar';
c.Label.String = 'Contrast as %';
c.Label.FontSize = 12;

%% CNR results figure
subplot(1,3,2);
imagesc(CNRColormap);
j = jet;
j(1,:) = [1 1 1];
colormap(j);
colorbar;
title('\fontsize{16}CNR Heatmap for: Al-balls-1mm/7-5mm/26-1.dcm');
xlabel('Image x values');
ylabel('Image y values');
c = colorbar;
c.Label.String = 'colorbar';
c.Label.String = 'CNR Value';
c.Label.FontSize = 12;

%% SNR results figure
subplot(1,3,3);
imagesc(SNRColormap);
j = jet;
j(1,:) = [1 1 1];
colormap(j);
colorbar;
title('\fontsize{16}SNR Heatmap for: Al-balls-1mm/7-5mm/26-1.dcm');
xlabel('Image x values');
ylabel('Image y values');
c = colorbar;
c.Label.String = 'colorbar';
c.Label.String = 'SNR Value';
c.Label.FontSize = 12;