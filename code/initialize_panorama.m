function [ tforms xLimits yLimits width height] = initialize_panorama( tforms, imageSize )
%% Compute the output limits  for each transform
for i = 1:numel(tforms)           
    x_min = 1;
    y_min = 1;
    x_max = imageSize(2);
    y_max = imageSize(1);
    
    points = double(tforms(i).T') * [x_min x_max; y_min y_max; 1 1];
    points = points./repmat(points(3,:),3,1);
    
    xlim(i,:) = points(1,:);
end

avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim);

centerIdx = floor((numel(tforms)+1)/2);

centerImageIdx = idx(centerIdx);

%%
% Finally, apply the center image's inverse transform to all the others.
Tinv = invert(tforms(centerImageIdx));

for i = 1:numel(tforms)    
    tforms(i).T = Tinv.T * tforms(i).T;
end

for i = 1:numel(tforms)           
    x_min = 1;
    y_min = 1;
    x_max = imageSize(2);
    y_max = imageSize(1);
    
    points = double(tforms(i).T') * [x_min x_max; y_min y_max; 1 1];
    points = points./repmat(points(3,:),3,1);
    
    xlim(i,:) = points(1,:);
    ylim(i,:) = points(2,:);
end


% Find the minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

xLimits = [xMin xMax];
yLimits = [yMin yMax];
end

