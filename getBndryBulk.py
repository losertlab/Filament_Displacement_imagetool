import numpy as np
from skimage.morphology import disk, dilation, erosion
from skimage.util import img_as_ubyte

def get_bndry_bulk(avg_cell_mask, se_rad_dil, nan_mask):
    se_rad_dil = int(se_rad_dil)
    
    # Dilation
    print('Starting Dilation')
    se_dil = disk(se_rad_dil)
    dil_mask = dilation(avg_cell_mask, selem=se_dil)
    print('Dilation Complete')

    # Erosion
    print('Starting Erosion')
    se_erd = disk(se_rad_dil)
    erd_mask = erosion(avg_cell_mask, selem=se_erd)
    print('Erosion Complete')

    bulk_mask = erd_mask
    bndry_mask = img_as_ubyte(dil_mask - erd_mask)

    # Ensure we are only getting the actual boundary of the cell (5/10/22)
    # BOUNDARY CONFIRMATION/ADDITIONAL SHRINKAGE
    bndry_mask = bndry_mask * nan_mask
    bndry_mask = bndry_mask == 1

    return bulk_mask, bndry_mask

# Example usage:
# Replace 'your_avg_cell_mask', 'your_se_rad_dil', and 'your_nan_mask' with actual values
your_avg_cell_mask = np.random.randint(0, 2, (100, 100), dtype=bool)
your_se_rad_dil = 10
your_nan_mask = np.random.randint(0, 2, (100, 100), dtype=bool)

result_bulk_mask, result_bndry_mask = get_bndry_bulk(your_avg_cell_mask, your_se_rad_dil, your_nan_mask)
