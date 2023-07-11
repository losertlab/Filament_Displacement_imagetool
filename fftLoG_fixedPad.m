% This function uses ffts to rotate a laplacian of gaussian (LoG) filter
% around an image containing fibers.
%
%%%% USAGE: prefAng = fft_LoG(filSig,numSig,numAngs,dtheta, filterThreshold,im)
%
%%%% INPUTS
% filSig          = sigma(s) for the LoG filter (related to size of fibers
%                 in image). Format: [gaussian axis, LoG axis]
% numSig          = size of the filter (as a multiple of filSig)
% numAngs         = number of angles for rotating the LoG filter
% filterThreshold = threshold for binarizing the maximum projection of all
%                   filtered images
% padSize         = [X Y] fixed pad for images
% im              = input image (designed for images containg fibers)
%
%%%% OUTPUTS
% prefAng         = The preferred angle for each pixel in the input image.  
%                 NaN for regions that were less than the filter threshold.

% imArray         = the original image scaled down to match the size of the
%                   output filter of the LoG
%
% DEPENDENCIES
% MakeFil.m       = Function for making the filters
%
% CHANGE LOG
% Original function by Lenny Campanello & Nick Mennona, May 2020
% NM edit to get the downscaled image sizes for future elementwise multiplication with LoG, Feb
% 2022

function [prefAng, origIm] = fftLoG_fixedPad(filSig,numSig,numAngs,filterThreshold,im,padSize)



    % Create filter array
    [ix, iy] = meshgrid(-max(filSig)*numSig:max(filSig)*numSig, -max(filSig)*numSig:max(filSig)*numSig);
    filArray = zeros(size(ix, 1), size(ix, 2), numAngs);
    filArray2=filArray;
    for i = 1:numAngs
        ang = pi*i/numAngs;
        ix2 = cos(ang)*ix - sin(ang)*iy;
        iy2 = sin(ang)*ix + cos(ang)*iy;
        fil = MakeFil(ix2, iy2, filSig);
        fil = fil - sum(fil(:))/numel(fil);
        filArray(:, :, i) = fil;
    end
   
    filSize = size(filArray);
    filArray2(ceil(filSize(1)/2),ceil(filSize(2)/2),:)=1;
    % Create image array
    padSize1 = ceil(filSize(1:2)/2 + 1);
    padValue1 = mean(im(:));
    imArray = padarray(im, padSize1, padValue1); % padval can be whatever you want (in this case, choose the background level)
    imSize = size(imArray);
    
    % Adjust filArray (based on size of image input)
    padValue2 = 0; % padval should be == 0 every time
    % filArray = padarray(filArray, [imSize, 0] + 1, padValue2, 'post');
    % Feb 28,22 edit
    filArray = padarray(filArray, [imSize, 0]+1, padValue2, 'post');
    filArray2 = padarray(filArray2,[imSize, 0]+1, padValue2, 'post');
    padSize2 = filSize(1:2) + 1;
    imArray = padarray(imArray, padSize2, 'post');
    
    % Create FFTs
    fftImArray = fftn(imArray);
    fftFilArray = fftn(filArray);
    fftFilArray2=fftn(filArray2);
    
    %%%%%%%%%%%%%%%%% ORIGINAL
    % Perform filtering and extract output
%     filIm = ifftn(fftImArray.*fftFilArray);
%     filIm = filIm((padSize1(1) + 1):(end - padSize1(1)), (padSize1(2) + 1):(end - padSize1(2)), :);
%     % divide by 2 based upon testing 6/23/22
%     filIm = filIm((padSize2(1) + 1):(end - padSize2(1)), (padSize2(2) + 1):(end - padSize2(2)), :);
% 
%     %downscale orig data
%     origIm = ifftn(fftImArray.*fftFilArray2);
%     origIm = origIm((padSize1(1) + 1):(end - padSize1(1)), (padSize1(2) + 1):(end - padSize1(2)), :);
%     origIm = origIm((padSize2(1) + 1):(end - padSize2(1)), (padSize2(2) + 1):(end - padSize2(2)), :);
%     origIm = origIm(:,:,1);
    %%%%%%%%%%%%%%%%%%%%
    %edit 8/5/22
    filIm = ifftn(fftImArray.*fftFilArray);
    filIm = filIm((padSize1(1) + 1):(end - padSize1(1)), (padSize1(2) + 1):(end - padSize1(2)), :);
    % divide by 2 based upon testing 6/23/22
    filIm = filIm((padSize2(1)/2 + 1):(end - padSize2(1)/2), (padSize2(2)/2 + 1):(end - padSize2(2)/2), :);

    %downscale orig data
    origIm = ifftn(fftImArray.*fftFilArray2);
    origIm = origIm((padSize1(1) + 1):(end - padSize1(1)), (padSize1(2) + 1):(end - padSize1(2)), :);
    origIm = origIm((padSize2(1)/2 + 1):(end - padSize2(1)/2), (padSize2(2)/2 + 1):(end - padSize2(2)/2), :);
    origIm = origIm(:,:,1);

%     imArray3 = imArray3((padSize1(1) + 1):(end - padSize1(1)), (padSize1(2) + 1):(end - padSize1(2)), :);
%     imArray3 = imArray3((padSize2(1) + 1):(end - padSize2(1)), (padSize2(2) + 1):(end - padSize2(2)), :);
    % See output
    % figure;
    % imagesc(max(real(filIm), [], 3));

    % Process angles
%     imArray3 = imArray3((padSize1(1) + 1):(end - padSize1(1)), (padSize1(2) + 1):(end - padSize1(2)), :);
%     imArray3 = imArray3((padSize2(1) + 1):(end - padSize2(1)), (padSize2(2) + 1):(end - padSize2(2)), :);
    mask = max(filIm, [], 3) > filterThreshold;
    [~, prefAngIm] = max(filIm, [], 3); %Not currently outputing the actual max image: [maxProjIm, prefAngIm] = max(filIm, [], 3);
    prefAng = prefAngIm;
    prefAng(~mask) = nan;
    prefAng = pi*(prefAng - 1)/numAngs;
    
%     % Remove boundary artifacts
    a = size(prefAng);
%     b = ceil(filSize/2 + 1);
%     a=[100,100];
    b=padSize;
    prefAng(1:b(1),:,:)=NaN;
    prefAng(:,1:b(2),:)=NaN;
    prefAng(a(1)-b(1)+1:a(1),:,:)=NaN;
    prefAng(:,a(2)-b(2)+1:a(2),:)=NaN;

end