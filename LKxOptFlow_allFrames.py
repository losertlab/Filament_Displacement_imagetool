import numpy as np
from scipy.ndimage import convolve

def LKxOptFlow_allFrames(images, xySig1, tSig, wSig):
    images = images.astype(float)

    xyRange1 = np.arange(-np.ceil(3*xySig1), np.ceil(3*xySig1) + 1)
    xySig2 = xySig1 / 4
    xyRange2 = np.arange(-np.ceil(3*xySig2), np.ceil(3*xySig2) + 1)
    tRange = np.arange(-np.ceil(3*tSig), np.ceil(3*tSig) + 1)

    fx1 = np.ones(len(xyRange1))
    fy1 = np.ones(len(xyRange2))
    gx1 = xyRange1 / xySig1 / xySig1
    gy1 = 1
    xFil1 = gx1
    yFil1 = gy1

    fx2 = fx1
    fy2 = fy1
    gx2 = 1
    gy2 = xyRange1 / xySig1 / xySig1
    xFil2 = gx2
    yFil2 = gy2

    fx3 = fx1
    fy3 = fy1
    gt3 = tRange / tSig / tSig
    gx3 = 1
    gy3 = 1
    tFil3 = np.expand_dims(gt3, (1, 2))

    dxI = convolve(convolve(images, xFil1), yFil1)
    dyI = convolve(convolve(images, xFil2), yFil2)
    dtI = convolve(convolve(convolve(images, xFil3), yFil3), tFil3)

    wRange = np.arange(-np.ceil(3*wSig), np.ceil(3*wSig) + 1)
    gx = np.exp(-wRange**2 / (2 * wSig**2)) / np.sqrt(2 * np.pi) / wSig
    gy = gx
    xFil4 = gx
    yFil4 = gy

    wdx2 = convolve(convolve(dxI**2, xFil4), yFil4)
    wdxy = convolve(convolve(dxI*dyI, xFil4), yFil4)
    wdy2 = convolve(convolve(dyI**2, xFil4), yFil4)
    wdtx = convolve(convolve(dxI*dtI, xFil4), yFil4)
    wdty = convolve(convolve(dyI*dtI, xFil4), yFil4)

    determinant = (wdx2 * wdy2) - (wdxy**2)
    vx = ((determinant + np.finfo(float).eps)**-1) * ((wdy2 * -wdtx) + (-wdxy * -wdty))
    vy = ((determinant + np.finfo(float).eps)**-1) * ((-wdxy * -wdtx) + (wdx2 * -wdty))

    trace = wdx2 + wdy2
    e1 = (trace + np.sqrt(trace**2 - 4*determinant)) / 2
    e2 = (trace - np.sqrt(trace**2 - 4*determinant)) / 2
    rel = np.real(np.minimum(e1, e2))

    return vx, vy, rel
