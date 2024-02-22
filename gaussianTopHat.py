import numpy as np
from skimage.morphology import disk
from skimage.filters import gaussian, rank
from skimage.util import img_as_ubyte

def gaussian_top_hat(images, gauss_sig):
    selem = disk(12)
    num_frames = images.shape[2]
    image_filt = np.zeros_like(images)

    for tt in range(num_frames):
        temp_frame = images[:, :, tt]
        original = img_as_ubyte(gaussian(temp_frame, sigma=gauss_sig))
        tophat_filtered = rank.tophat(original, selem=selem)
        image_filt[:, :, tt] = tophat_filtered

    return image_filt

# Example usage:
# Replace 'your_images' and 'your_gauss_sig' with actual values
your_images = np.random.rand(100, 100, 10)
your_gauss_sig = 1.5

result_image_filt = gaussian_top_hat(your_images, your_gauss_sig)

# Display the first frame of the resulting sequence
import matplotlib.pyplot as plt
plt.imshow(result_image_filt[:, :, 0], cmap='gray')
plt.title('First Frame - Gaussian Top Hat Filtered')
plt.show()
