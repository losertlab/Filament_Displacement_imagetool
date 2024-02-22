import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

def im2RGB(image, cmap, I_low, I_high):
    image = image.astype(float)
    num_colors = cmap.N
    int_im = (image - I_low) / (I_high - I_low)
    int_im[int_im < 0] = 0
    int_im[int_im > 1] = 1
    int_im = np.ceil(int_im * num_colors).astype(int)
    int_im[int_im == 0] = 1

    r_im = cmap(int_im)[:, :, 0]
    g_im = cmap(int_im)[:, :, 1]
    b_im = cmap(int_im)[:, :, 2]

    nan_idx = np.isnan(int_im)
    int_im[nan_idx] = 1
    r_im[nan_idx] = 1
    g_im[nan_idx] = 1
    b_im[nan_idx] = 1

    rgb_image = np.stack((r_im, g_im, b_im), axis=-1)

    return rgb_image

# Example usage:
# Replace 'your_image', 'your_cmap', 'your_I_low', and 'your_I_high' with actual values
your_image = np.random.rand(100, 100) * 255  # Assuming a grayscale image
your_cmap = plt.get_cmap('viridis')
your_I_low = 0
your_I_high = 255

result_rgb_image = im2RGB(your_image, your_cmap, your_I_low, your_I_high)

# Display the resulting RGB image
plt.imshow(result_rgb_image)
plt.title('RGB Image')
plt.show()
