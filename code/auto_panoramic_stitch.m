% =========================================================================
%   {rjbcs,scrps}@cin.ufpe.br     
% Código desenvolvido para a disciplina de Tópicos Avançados em Mídias e
% Interfaces.
% 
% =========================================================================

clear all; 
close all;

%% Input and Outlier Removal:
% Load images.
buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
Scene = imageSet('./cenario4/');

% Display images to be stitched
montage(Scene.ImageLocation)

% Read the first image from the image set.
I{1} = read(Scene, 1);

% Initialize features for I(1)
grayImage = rgb2gray(I{1});

points = detectSURFFeatures(grayImage);
[features, points] = extractFeatures(grayImage, points);

tforms(Scene.Count) = projective2d(eye(3));

% Iterate over remaining image pairs
for n = 2:Scene.Count
    %% Store points and features for I(n-1).
    pointsPrevious = points;
    featuresPrevious = features;
    
    %% Matcher
    % Read I(n).
    I{n} = read(Scene, n);
    
    % Detect and extract SURF features for I(n).
    grayImage = rgb2gray(I{n});    
    points = detectSURFFeatures(grayImage);    
    [features, points] = extractFeatures(grayImage, points);
    
    % Find correspondences between I(n) and I(n-1).
    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);
       
    matchedPoints = points(indexPairs(:,1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);     
    
    x1 = [matchedPoints.Location'; ones(1, matchedPoints.Count)];
    x2 = [matchedPointsPrev.Location'; ones(1, matchedPointsPrev.Count)];

    figure; showMatchedFeatures(I{n-1},I{n},matchedPointsPrev,matchedPoints);

    % RANSAC
    [~, ~, idx_inl] = ransac(x1, x2);
   
    x1_inl = x1(:,idx_inl);
    x2_inl = x2(:,idx_inl);

    %% Transform image
    %apply DLT to the inliers
    H = f_dlt_norm(x1_inl, x2_inl);
    H = H./H(3,3);
%     Gauss-Newton:
    H_gn = gauss_newton(H,x1_inl,x2_inl,100);
%     H_gn = H;
    
    tforms(n) = projective2d(H_gn');
    % Compute T(1) * ... * T(n-1) * T(n)
    tforms(n).T = tforms(n-1).T * tforms(n).T; 
end

% Step 3 - Initialize the Panorama
[tforms xLimits yLimits width height] = initialize_panorama(tforms, size(I{1}));

%% Step 4 - Create the Panorama
% Use |imwarp| to map images into the panorama and use
% |vision.AlphaBlender| to overlay the images together.

blender = vision.AlphaBlender('Operation', 'Binary mask', 'MaskSource', 'Input port');  
% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', I{1});
% Create a 2-D spatial reference object defining the size of the panorama.
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:Scene.Count  
    % Transform I into the panorama.
    warpedImage = imwarp(I{i}, tforms(i), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, warpedImage(:,:,1));
end
% panorama = create_panorama(I, tforms);
figure
imshow(panorama)