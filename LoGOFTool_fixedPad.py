import numpy as np
from scipy.ndimage import convolve
from scipy.ndimage import gaussian_filter, gaussian_laplace
from scipy.signal import fftconvolve

def LoGOFTool_fixedPad(imSeq, paramsLog, paramsOF, padSize):
    numFrames = imSeq.shape[2]

    LogFilt, dsOG = Log_fixedPad_imseq(imSeq, paramsLog, padSize)

    gaussSig = 1.5
    filtVid = gaussianTopHat(dsOG, gaussSig)

    xySig = paramsOF['xySig']
    tSig = paramsOF['tSig']
    wSig = paramsOF['wSig']

    vxMat, vyMat, relMat = LKxOptFlow_allFrames(filtVid, xySig, tSig, wSig)
    of_Magnitude = np.sqrt(vxMat**2 + vyMat**2)
    of_Orientation = np.arctan2(vyMat, vxMat)

    logOF = np.zeros_like(of_Magnitude)

    for tt in range(numFrames):
        tempOr = of_Orientation[:, :, tt]
        tempOr[tempOr == 0] = np.nan
        tempOr[tempOr < 0] = np.pi + tempOr[tempOr < 0]
        tempMag = of_Magnitude[:, :, tt]
        tempMag[tempMag == 0] = np.nan
        tempLOG = LogFilt[:, :, tt]

        # now we have all of the necessary matrices
        comFrame = np.abs(tempOr - tempLOG)
        logOF[:, :, tt] = tempMag * np.sin(comFrame)

        if tt % 10 == 0:
            print(f'Reading Frame {tt}')

    return logOF, LogFilt, dsOG

def gaussianTopHat(images, gaussSig):
    se = np.ones((12, 12))
    numFrames = images.shape[2]
    imageFilt = np.zeros_like(images)

    for tt in range(numFrames):
        tempFrame = images[:, :, tt]
        original = gaussian_filter(tempFrame, sigma=gaussSig)
        tophatFiltered = tempFrame - original
        imageFilt[:, :, tt] = tophatFiltered

    return imageFilt

def LKxOptFlow_allFrames(images, xySig1, tSig, wSig):
    # Implementation of LKxOptFlow_allFrames function goes here
    pass

def Log_fixedPad_imseq(imSeq, params, padSize):
    # Implementation of Log_fixedPad_imseq function goes here
    pass
