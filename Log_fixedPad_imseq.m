% This function uses ffts to rotate a laplacian of gaussian (LoG) filter
% around an image containing fibers.
%
%%%% USAGE: [LogFilt, dsOG] = Log_fixedPad_imseq(imSeq, params,padSize)
%
%%%% INPUTS
% for LoG params see fftLoG_fixedPad for clarification
% padSize         = [X Y] fixed pad for images
% im              = input image (designed for images containg fibers)
%
%%%% OUTPUTS
% LogFtil         = The preferred angle for each pixel in the input image.  
%                 NaN for regions that were less than the filter threshold.

% dsOG         = original image scaled to match LoG scale
%                   
%
% DEPENDENCIES
% MakeFil.m       = Function for making the filters (see Losert Lab 2d log
%                   GitHub page)
%
% CHANGE LOG
% Original Code Nick Mennona

function [LogFilt, dsOG] = Log_fixedPad_imseq(imSeq, params,padSize)
    %
    
    filSig = params.filSig;
    numSig = params.numSig;
    numAngs = params.numAngs;
    filtThresh = params.filterThreshold;
    
    LogFilt = [];
    dsOG = [];
    for tt=1:size(imSeq,3)
        tempFrame = imSeq(:,:,tt);
        [tempFil, tempOG] = fftLoG_fixedPad(filSig,numSig,numAngs,filtThresh,tempFrame,padSize);
        LogFilt = cat(3,LogFilt,tempFil);
        dsOG = cat(3,dsOG,tempOG);
        if mod(tt,10)==0
            disp(['Reading Frame ' num2str(tt)])
        end
    end
end