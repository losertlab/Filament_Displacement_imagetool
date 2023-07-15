% This function allows a researcher to analyze the dynamics of filaments in
% a dense MT networks
%
%%%% USAGE: function [logOF,LogFilt,dsOG] = LoGOFTool_fixedPad(imSeq,paramsLog,paramsOF,padSize)
%
%%%% INPUTS
% for LoG and OF params consults Log_fixedPad_imseq.m and
% LKxOptFlow_allFrames.m
%
%%%% OUTPUTS
% logOF - the output for quantifying lateral motion
% LogFilt - the output of LoG only (to be used for further downstream
% analysis of relative angles)
% dsOG - the original data adjusted such that overlays of results agree on
% a pixel-pixel basis
% DEPENDENCIES
% Log_fixedPad_imseq.m - generate the anisotropic LoG output
% LKxOptFlow_allFrames.m - Lucas-Kanade optical flow as developed by Lenny
%                           Campanello in the Losert Lab (see Lee et. al)

% Original function by Nick Mennona
% Please direct all correspondence to:
% nmennona@umd.edu or wlosert@umd.edu
%%
function [logOF,LogFilt,dsOG] = LoGOFTool_fixedPad(imSeq,paramsLog,paramsOF,padSize)
% find motion perpendicular to those pixels identified as filaments in an
% image


%INPUT:
% imSeq-image sequence for processing/analysis
% paramsLog:
%  
        % logparams.filSig
        % logparams.numSig
        % logparams.numAngs
        % logparams.filterThreshold
% paramsOF:
        % xySig
        % tSig
        % wSig 

    
    numFrames = size(imSeq,3);

   
    [LogFilt, dsOG] = Log_fixedPad_imseq(imSeq, paramsLog,padSize);

    gaussSig=1.5;
    filtVid = gaussianTopHat(dsOG,gaussSig);

    xySig = paramsOF.xySig;
    tSig = paramsOF.tSig;
    wSig = paramsOF.wSig;
    [vxMat, vyMat, relMat] = LKxOptFlow_allFrames(filtVid, xySig, tSig, wSig);
    of_Magnitude = sqrt(vxMat.^2+vyMat.^2);
    of_Orientation = atan2(vyMat,vxMat);

    
    for tt=1:numFrames
        tempOr = of_Orientation(:,:,tt);
        tempOr(tempOr==0)=nan;
        tempOr(tempOr<0)=pi+tempOr(tempOr<0);
        tempMag = of_Magnitude(:,:,tt);
        tempMag(tempMag==0)=nan;
        tempLOG = LogFilt(:,:,tt);
        
        % now we have all of the necessary matrices
        comFrame = abs(tempOr-tempLOG);
        logOF(:,:,tt)=tempMag.*sin(comFrame);
        if mod(tt,10)==0
            disp(['Reading Frame ' num2str(tt)])
        end
    end
end
