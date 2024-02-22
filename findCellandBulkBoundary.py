import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from skimage.draw import polygon
from skimage.filters import gaussian
from skimage.measure import find_contours
from skimage.morphology import remove_small_objects, binary_erosion

def find_cell_and_bulk_boundary(raw_im_seq):
    # Take the first frame from the raw image sequence
    first_frame = raw_im_seq[:, :, 0]

    plt.imshow(first_frame)
    plt.axis('off')
    plt.show()

    print('Look at the image!')
    draw_polygon = input('Do you need to draw a polygon? 1 for Yes, 0 for No ')
    
    if draw_polygon:
        full_screen = input('Does it take up the full Screen? 1 for Yes, 0 for No ')

        if full_screen:
            line_roi = plt.ginput(2)
            num_x = int(line_roi[0][0])
            num_xf = int(line_roi[1][0])
            temp_get_rid = np.zeros_like(first_frame)
            temp_get_rid[:, num_x:num_xf] = 1
        else:
            cell_roi = plt.ginput(4)
            num_x = int(cell_roi[0][0])
            num_xf = int(cell_roi[2][0])
            num_y = int(cell_roi[0][1])
            num_yf = int(cell_roi[1][1])
            temp_get_rid = np.zeros_like(first_frame)
            temp_get_rid[num_x:num_xf, num_y:num_yf] = 1

        segmented_cell_region = temp_get_rid * first_frame
        plt.imshow(segmented_cell_region)
        plt.show()

        filter_thresh = 50
        size_thresh = 20000

        A = find_cell_boundary(segmented_cell_region, filter_thresh, size_thresh)
        X = input('Does this look good? (1 for Yes, 0 for No) ')

        while X != 1:
            new_thresh = int(input('Enter new threshold (default was 50): '))
            new_area = int(input('Enter new obj area (default was 20000): '))
            A = find_cell_boundary(segmented_cell_region, new_thresh, new_area)
            plt.imshow(A)
            plt.show()
            X = input('Does this look good? (1 for Yes, 0 for No) ')

    else:
        segmented_cell_region = first_frame
        filter_thresh = 50
        size_thresh = 20000

        big_temp, _, _ = find_cell_boundary(segmented_cell_region, filter_thresh, size_thresh)
        big_temp[0, :] = 1
        big_temp = remove_small_objects(big_temp, min_size=1000)  # Adjust min_size accordingly
        big_temp[-1, :] = 1
        big_temp = remove_small_objects(big_temp, min_size=1000)  # Adjust min_size accordingly

        A = big_temp

    gaussian_mask = gaussian(A.astype(float), sigma=10) > 0.15
    plt.imshow(gaussian_mask)
    plt.show()

    mask_good = False

    while not mask_good:
        mask_good = input('Is this okay? 1 for Yes, 0 for No ')

        if not mask_good:
            filter_thresh = int(input('Enter new threshold: '))
            size_thresh = int(input('Enter new Size Threshold (orig = 20000): '))
            A = find_cell_boundary(segmented_cell_region, filter_thresh, size_thresh)
            gaussian_mask = gaussian(A.astype(float), sigma=10) > 0.15

        plt.imshow(gaussian_mask)
        plt.show()

    percentage = 0.25
    bulk_reg, boundary_reg = find_percentage_boundary(gaussian_mask, percentage)

    return bulk_reg, boundary_reg, gaussian_mask


def find_cell_boundary(segmented_cell_region, filter_thresh, size_thresh):
    binary_cell_region = segmented_cell_region > filter_thresh
    labeled_cells = remove_small_objects(binary_cell_region, min_size=size_thresh)  # Adjust min_size accordingly
    return labeled_cells


def find_percentage_boundary(mask, percentage):
    labeled_cells = remove_small_objects(mask, min_size=1000)  # Adjust min_size accordingly
    labeled_cells = binary_erosion(labeled_cells)
    
    boundary_cells = mask ^ labeled_cells
    bulk_cells = labeled_cells ^ boundary_cells

    return bulk_cells, boundary_cells


# Example usage:
# Replace 'your_raw_im_seq' with the actual raw image sequence
# Adjust parameters as needed
your_raw_im_seq = np.random.rand(100, 100, 10)
bulk_region, boundary_region, gaussian_mask_result = find_cell_and_bulk_boundary(your_raw_im_seq)

plt.imshow(bulk_region)
plt.title('Bulk Region')
plt.show()

plt.imshow(boundary_region)
plt.title('Boundary Region')
plt.show()

plt.imshow(gaussian_mask_result)
plt.title('Gaussian Mask')
plt.show()
