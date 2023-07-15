function [angleSegSeq] = partitionAngleRanges(imSeq,bins,maxAng)
% INPUT: 
% imSeq--Log filtered image sequence
% bins--number of partitions you want, e.g. 3 --> 0-60, 60-120, 120-180
% OUTPUT:
% cell with dimension {3,1}

angleSegSeq = cell(bins,1);
numFrames = size(imSeq,3);
angUnit = maxAng/bins;
for aa=1:bins
    angleSegSeq{aa,1}=zeros(size(imSeq));
    angLow = (aa-1)*angUnit;
    angUp = aa*angUnit;
    for tt=1:numFrames
        tempFrame = imSeq(:,:,tt);
        mask = tempFrame>=angLow & tempFrame<angUp;
        mask = im2double(mask); mask(mask==0)=NaN;
        newAngleFrame = mask.*tempFrame;
        angleSegSeq{aa,1}(:,:,tt)=newAngleFrame;
    end
end