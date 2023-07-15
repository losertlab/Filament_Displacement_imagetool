% This function is not necessary for the use of LoGOF generally, but can be used 
% to help researchers segment specific cells by hand in a FOV

function [bulkReg, boundaryReg,gaussianMask] = findCellandBulkBoundary(rawImSeq)
% INPUT: rawImSeq-take in the raw image sequence...output from LOGOFToolv3
% this function takes the first frame from that raw image and then tries to
% get a cellMask for analysis
% OUTPUT:
% bulkReg--bulk region that is (hardcoded at this point) 85% of the cell
% mask area
% boundaryReg--the rest to be composed of as the boundary

% PLEASE FOLLOW INSTRUCTIONS ON HOW TO DRAW THE SEGMENTING POLYGON
    close all
    firstFrame = rawImSeq(:,:,1);
    figure;
    imagesc(firstFrame);truesize
    disp('Look at the image!')
    if input('Do you need to draw a polygon? 1 for Yes, 0 for No ')
        if input('Does it take up the full Screen? 1 for Yes 0 for No ')
            lineROI = drawline;
            numX = floor(lineROI.Position(1));% draw line left to right
            numXf = floor(lineROI.Position(2));
            tempGetRid = NaN(size(firstFrame));
            tempGetRid(1:end,numX:numXf)=1;
            segmentedCellRegion = tempGetRid.*firstFrame;
            imagesc(segmentedCellRegion)
%             disp('Does this look good?')
%             pause(10)
            %need to start manually changing parameters HERE
            [A,~,~]=findCellBoundary(segmentedCellRegion,50,20000);
            figure(2); imagesc(A);truesize
            X = input('Does this look good?');
            while X~=1
                newThresh = input('Enter new threshold (default was 50) ');
                newArea = input('Enter new obj area (default was 20000) ');
                [A,~,~]=findCellBoundary(segmentedCellRegion,newThresh,newArea);
                imagesc(A);truesize
                X = input('Does this look good?');
            end
            imagesc(A)
%             pause(10)
        else
            cellROI = drawpolygon;
            tempGetRid = NaN(size(firstFrame));
            % these values are based off of choosing top left, top right, bottom right,
            % bottom left in that sequence for the ROI!
            numX=floor(cellROI.Position(5)); numXf = floor(cellROI.Position(8));
            numY = floor(cellROI.Position(1));numYf = floor(cellROI.Position(2));
            close all
            tempGetRid(numX:numXf,numY:numYf)=1;
            segmentedCellRegion = tempGetRid.*firstFrame;
            [A,~,~]=findCellBoundary(segmentedCellRegion,50,20000);
            X = input('Does this look good?');
            while X~=1
                newThresh = input('Enter new threshold (default was 50) ');
                newArea = input('Enter new obj area (default was 20000) ');
                [A,~,~]=findCellBoundary(segmentedCellRegion,newThresh,newArea);
                X = input('Does this look good?');
            end
            imagesc(A)
        end
    else
        segmentedCellRegion = firstFrame;
        [bigTemp,~,~]=findCellBoundary(segmentedCellRegion,50,20000);
        bigTemp(1,:)=1; bigTemp=imfill(bigTemp,'holes');bigTemp(1,:)=0;
        bigTemp(end,:)=1;bigTemp=imfill(bigTemp,'holes');bigTemp(end,:)=0;
        A=bigTemp;
    end

    gaussianMask = imgaussfilt(im2double(A),10)>.15;
    disp('CellMask generated and smoothed! Check it out!')
    imagesc(gaussianMask)
    maskGood=0;
    while ~maskGood
        maskGood=input('Is this okay? 1 for Yes, 0 for No ');
        if maskGood==0
            filterThresh = input('Enter new threshhold ');
            sizeThresh = input('Enter new Size Threshold (orig = 20000) '); 
            [A,~,~]=findCellBoundary(segmentedCellRegion,filterThresh,sizeThresh);
            gaussianMask = imgaussfilt(im2double(A),10)>.15;
        end
        imagesc(gaussianMask)
        figure
        imagesc(firstFrame)
    end

    percentage = .25;
    [bulkReg,boundaryReg] = findPercentageBoundary(gaussianMask,percentage);
end


% 
% test = params(2).logOF;
% figure;
% imagesc(test(:,:,3))
% cellROI = drawpolygon;
% %%
% tempGetRid = NaN(size(test(:,:,1)));
% % these values are based off of choosing top left, top right, bottom right,
% % bottom left in that sequence for the ROI!
% numX=cellROI.Position(5); numXf = cellROI.Position(8);
% numY = cellROI.Position(1);numYf = cellROI.Position(2);
% tempGetRid(cellROI.Position(5):cellROI.Position(8),cellROI.Position(1):cellROI.Position(2))=1;
% imagesc(tempGetRid.*testGetRid)
% [A,B,C]=findCellBoundary(tempGetRid.*testGetRid);imagesc(A)
% %%
% % for i=1:size(dsOG,3)
% %     [bigTemp,~,~] = findCellBoundary(dsOG(:,:,i));
% %     % 4/26/22--interesting workaround I found
% % bigTemp(1,:)=1; bigTemp=imfill(bigTemp,'holes');bigTemp(1,:)=0;
% % bigTemp(end,:)=1;bigTemp=imfill(bigTemp,'holes');bigTemp(end,:)=0;
% %     labelledimages{i,1} = bigTemp;
% % end
% % disp('Found Boundary and Bulk regions')
% %% GAUSSIAN SMOOTH THE BINARIZED IMAGE TO GET A NICE SMOOTH MASK
% bigTemp=imgaussfilt(im2double(A),10)>.15;
% imagesc(bigTemp)
% %
% percentage = .25;
% [bulkReg,boundaryReg] = findPercentageBoundary(bigTemp,percentage);
% imshowpair(bulkReg,boundaryReg)










