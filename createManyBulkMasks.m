function regions = createManyBulkMasks(bulkMask,originalBoundary,numBulkMasks)
% goal of this function is to take a bulkMask that has already been
% generated from findCellandBulkBoundary.m and create smaller versions of
% the same bulkMask by erosion to deduce regional specific differences in
% dynamics 

% as a geometric representation, the original bulkMask and all others until
% the numBulkMasks (final) mask are all ring like

% INPUT:
% bulkMask: original bulkMask to be eroded
% numBulkMasks: number of regions to be generated

% OUTPUT:
% regions: struct which contains all of the masks of interest
randomSEval=20;
regions(1).bulkMask = originalBoundary;
for i=1:numBulkMasks-1
    if i==1
        tempNanMask = im2double(bulkMask);
        tempNanMask(tempNanMask==0)=NaN;
        [newbulkMask,bndryMask]=getBndryBulk(bulkMask,randomSEval,tempNanMask);
        regions(i+1).bulkMask = bndryMask;
        tempBulk = newbulkMask;
    else
        tempNanMask = im2double(tempBulk);
        tempNanMask(tempNanMask==0)=NaN;
        [newbulkMask,bndryMask]=getBndryBulk(tempBulk,randomSEval,tempNanMask);
        regions(i+1).bulkMask = bndryMask;
        tempBulk = newbulkMask;
    end
end
regions(numBulkMasks+1).bulkMask=newbulkMask;
end
