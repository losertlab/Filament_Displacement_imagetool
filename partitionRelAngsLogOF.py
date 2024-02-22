import numpy as np

def partitionRelAngsLogOF(LogOF, LogVid, nbins, maskReg, boundary):
    # FUNCTION USE: take the generated LOGOF video and the generated LogVID
    # image sequences and only take out the angle specific portions of the
    # LOGOF vid, i.e., use the LogVID to find pixels associated with certain
    # angles and only pick those relevant pixels out from the LOGOF video
    # INPUT:
    # LogOF-generated LOGOF image sequence
    # LogVid -generated LOG image sequence. same size as above
    # nbins- number of angle partitions
    # maskReg- region of interest (logical datatype)
    # boundary - axis for relative angle conversion
    # OUTPUT:
    # AngPartLOGOF - list with nbins videos of relative angles for the maskReg

    # RELATIVE ANGLE CONVERSION
    numFramesProto = LogVid.shape[2]
    relRegion = np.zeros_like(LogVid)

    for tt in range(numFramesProto):
        tempFrame = LogVid[:, :, tt]
        maskRegion = maskReg.astype(float)
        maskRegion[maskRegion == 0] = np.nan
        maskFrame = tempFrame * maskRegion
        relRegion[:, :, tt] = relBoundaryAngles(maskFrame, boundary)
        print(f'On Frame {tt}')

    AngPartLOG = partitionAngleRanges(relRegion, nbins, np.pi / 2)

    # ACQUIRE THE PIXELS AND EXTRACT IMPORTANT DATA FROM LogOF
    AngPartLOGOF = [np.zeros_like(LogOF) for _ in range(nbins)]

    for nn in range(nbins):
        tempAngVid = AngPartLOG[nn]
        logRel = np.zeros_like(tempAngVid)
        numFrames = tempAngVid.shape[2]

        for tt in range(numFrames):
            tempLOGOF = LogOF[:, :, tt]
            tempRelAng = tempAngVid[:, :, tt]
            logRel[:, :, tt] = tempLOGOF * tempRelAng

        AngPartLOGOF[nn] = logRel

    return AngPartLOGOF
