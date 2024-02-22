import numpy as np
from scipy.ndimage import convolve

def Log_fixedPad_imseq(imSeq, params, padSize):
    filSig = params['filSig']
    numSig = params['numSig']
    numAngs = params['numAngs']
    filtThresh = params['filterThreshold']

    LogFilt = []
    dsOG = []
    for tt in range(imSeq.shape[2]):
        tempFrame = imSeq[:, :, tt]
        tempFil, tempOG = fftLoG_fixedPad(filSig, numSig, numAngs, filtThresh, tempFrame, padSize)
        LogFilt.append(tempFil)
        dsOG.append(tempOG)
        if tt % 10 == 0:
            print(f'Reading Frame {tt}')

    LogFilt = np.stack(LogFilt, axis=2)
    dsOG = np.stack(dsOG, axis=2)
    
    return LogFilt, dsOG

def fftLoG_fixedPad(filSig, numSig, numAngs, filtThresh, tempFrame, padSize):
    # Implementation of fftLoG_fixedPad function goes here
    pass
