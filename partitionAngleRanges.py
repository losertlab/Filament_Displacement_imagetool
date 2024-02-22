import numpy as np

def partitionAngleRanges(imSeq, bins, maxAng):
    # INPUT: 
    # imSeq--Log filtered image sequence
    # bins--number of partitions you want, e.g., 3 --> 0-60, 60-120, 120-180
    # OUTPUT:
    # cell with dimension {3,1}

    angleSegSeq = [np.zeros_like(imSeq) for _ in range(bins)]
    numFrames = imSeq.shape[2]
    angUnit = maxAng / bins

    for aa in range(bins):
        angLow = (aa - 1) * angUnit
        angUp = aa * angUnit
        for tt in range(numFrames):
            tempFrame = imSeq[:, :, tt]
            mask = (tempFrame >= angLow) & (tempFrame < angUp)
            mask = mask.astype(float)
            mask[mask == 0] = np.nan
            newAngleFrame = mask * tempFrame
            angleSegSeq[aa][:, :, tt] = newAngleFrame

    return angleSegSeq
