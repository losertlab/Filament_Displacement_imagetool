% This function serves as the downstream analysis for converting the output
% of FIDI into meaningful biological results
% Dependencies:
% relBoundaryAngles.m - finds relative angles given some boundary. use
% matlab image processing toolbox to generate boundaries after using the
% createManyBulkMasks.m or findCellandBulkBoundary.m functions

function [AngPartLOGOF,AngPartLOG] = partitionRelAngsLogOF(LogOF,LogVid, nbins,maskReg,boundary)
% FUNCTION USE: take the generated LOGOF video and the generated LogVID
% image sequences and only take out the angle specific portions of the
% LOGOF vid, ie use the LogVID to find pixels associated with certain
% angles and only pick those relavant pixels out from the LOGOF video
% INPUT:
% LogOF-generated LOGOF image sequence
% LogVid -generated LOG image sequence. same size as above
% nbins- number of angle partitions
% maskReg- region of interest (logical datatype)
% boundary - axis for relative angle conversion
% OUTPUT:
% AngPartLOGOF - cell with nbins videos of relative angles for the maskReg

    % RELATIVE ANGLE CONVERSION
    numFramesProto = size(LogVid,3);
    relRegion = zeros(size(LogVid));
    % majAx = Vrmaj(:,1:2);
    for tt=1:numFramesProto
        tempFrame=LogVid(:,:,tt);
        maskRegion = im2double(maskReg);maskRegion(maskRegion==0)=nan;
        maskFrame = tempFrame.*maskRegion;
        relRegion(:,:,tt)=relBoundaryAngles(maskFrame,boundary);
        disp(['On Frame ' int2str(tt)])
    end
    AngPartLOG = partitionAngleRanges(relRegion,nbins,pi/2);
    
    % ACQUIRE THE PIXELS AND EXTRACT IMPORTANT DATA FROM LogOF
    AngPartLOGOF = cell(nbins,1);
    for nn=1:nbins
        tempAngVid = AngPartLOG{nn,1};
        logRel = zeros(size(tempAngVid));
        numFrames = size(tempAngVid,3);
        for tt=1:numFrames
            tempLOGOF = LogOF(:,:,tt);
            tempRelAng = tempAngVid(:,:,tt);
            logRel(:,:,tt)=tempLOGOF.*tempRelAng;
        end
        AngPartLOGOF{nn,1}=logRel;
    end
end