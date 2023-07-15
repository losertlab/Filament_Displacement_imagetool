function [bulkMask,bndryMask] = getBndryBulk(avgCellMask,seRad_dil,NanMask)%%
% avgCellMask = mask.exactAvgMask;
% INPUT: input a binarized form of the cell shape
% OUTPUT: bulk and boundary masks
seRad_dil = floor(seRad_dil);
% dilate 10 pix
% seRad_dil = 10;
disp('Starting Dilation')
se_dil = strel('disk',seRad_dil);
% se_dil = strel('sphere',seRad_dil);
dilMask = imdilate(avgCellMask, se_dil);
disp('Dilation Complete')

% erode 10 pix
% seRad_erd = 10;
disp('Starting Erosion')
% se_erd = strel('sphere',seRad_dil);
se_erd = strel('disk',seRad_dil);
erdMask = imerode(avgCellMask, se_erd);
disp('Erosion Complete')


bulkMask = erdMask;
bndryMask = dilMask - erdMask;

%make sure we are only getting actual boundary of the cell (5/10/22)
% BOUNDARY CONFIRMATION/ADDITIONAL SHRINKAGE
bndryMask = im2double(bndryMask);
bndryMask = bndryMask.*NanMask;
bndryMask = bndryMask==1;
end
