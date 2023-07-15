function imageFilt = gaussianTopHat(images,gaussSig)
% preprocess raw data to smooth out filamentous structures

% INPUT:
% images: an image sequence
% gaussSig: sigma (pixels) for gaussian smoothing with imgaussfilt
% OUTPUT:
% gaussian smoothed tophat filtered image sequences
% gaussSig=1.5;

    se = strel('disk',12);
    numFrames = size(images,3);
    imageFilt = zeros(size(images));
    for tt=1:numFrames
        tempFrame = images(:,:,tt);
        original = mat2gray(imgaussfilt(tempFrame,gaussSig));
        %in order to tophat filter, the image must be grayscale or binary
        tophatFiltered = imtophat(original,se);
        imageFilt(:,:,tt)=tophatFiltered;
    end

%
% figure()
% subplot(1,2,1)
% imshow(imadjust(im2uint8(tophatFiltered)));
% subplot(1,2,2)
% imshow(mat2gray(tempData(125:175,500:550,10)))
end
