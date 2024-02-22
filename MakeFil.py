import numpy as np

def MakeFil(x, y, sig):
    if len(sig) == 1:
        fil1 = np.exp(-x**2 / (2 * sig**2) - y**2 / (2 * sig**2)) / (2 * np.pi * sig**2)
        fil2 = -(y**2 - sig**2) / sig**4
    elif len(sig) == 2:
        fil1 = np.exp(-x**2 / (2 * sig[0]**2) - y**2 / (2 * sig[1]**2)) / (2 * np.pi * sig[0] * sig[1])
        fil2 = -(y**2 - sig[1]**2) / sig[1]**4

    fil = fil1 * fil2
    return fil
