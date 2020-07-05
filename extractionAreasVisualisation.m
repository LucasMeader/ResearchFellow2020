function [] = extractionAreasVisualisation(dicomImage,firstX,firstY, currentImage)
imshow(dicomImage, []); 
title(strcat('DICOM showing test points: ', currentImage)); 

y = firstY;                % Starting y coordinate
for a = 1:6             % Step in y direction
x = firstX;                % Starting x coordinate
    for b = 1:5         % Step in x direction
        hold on;
        
        % CENTRE
        CX1 = x - 1;
        CY1 = y - 1;
        CX2 = x + 1;
        CY2 = y + 1;
        
        % Coordinate border for visualisation
        CXBorderPoint = [CX1, CX2, CX2, CX1, CX1];
        CYBorderPoint = [CY1, CY1, CY2, CY2, CY1];
                
        plot(CXBorderPoint, CYBorderPoint, 'b-', 'LineWidth', 1);
        
        % NORTH
        NX1 = x - 5;
        NY1 = y - 35;
        NX2 = x + 4;
        NY2 = y - 26;
        
        % Coordinate border for visualisation
        NXBorderPoint = [NX1, NX2, NX2, NX1, NX1];
        NYBorderPoint = [NY1, NY1, NY2, NY2, NY1];
                
        plot(NXBorderPoint, NYBorderPoint, 'g-', 'LineWidth', 1);
        
        % EAST
        EX1 = x + 26;
        EY1 = y - 5;
        EX2 = x + 35;
        EY2 = y + 4;
        
        % Coordinate border for visualisation
        EXBorderPoint = [EX1, EX2, EX2, EX1, EX1];
        EYBorderPoint = [EY1, EY1, EY2, EY2, EY1];
        
        plot(EXBorderPoint, EYBorderPoint, 'g-', 'LineWidth', 1);        
        
        % SOUTH
        SX1 = x - 5;
        SY1 = y + 26;
        SX2 = x + 4;
        SY2 = y + 35;
        
        % Coordinate border for visualisation
        SXBorderPoint = [SX1, SX2, SX2, SX1, SX1];
        SYBorderPoint = [SY1, SY1, SY2, SY2, SY1];
        
        plot(SXBorderPoint, SYBorderPoint, 'g-', 'LineWidth', 1);

        % WEST
        WX1 = x - 35;
        WY1 = y - 5;
        WX2 = x - 26;
        WY2 = y + 4;
        
        % Coordinate border for visualisation
        WXBorderPoint = [WX1, WX2, WX2, WX1, WX1];
        WYBorderPoint = [WY1, WY1, WY2, WY2, WY1];
        
        plot(WXBorderPoint, WYBorderPoint, 'g-', 'LineWidth', 1);
        x = x+589;        
    end
    
y = y+588.5;                      % Step of 589pxls in y direction

end

end