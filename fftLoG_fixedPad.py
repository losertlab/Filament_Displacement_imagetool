import numpy as np
import cv2

def fft_log(fil_sig, num_sig, num_angs, filter_threshold, im, pad_size):
    # Create filter array
    ix, iy = np.meshgrid(np.arange(-max(fil_sig) * num_sig, max(fil_sig) * num_sig + 1),
                         np.arange(-max(fil_sig) * num_sig, max(fil_sig) * num_sig + 1))

    fil_array = np.zeros((ix.shape[0], ix.shape[1], num_angs))
    fil_array2 = np.copy(fil_array)

    for i in range(num_angs):
        ang = np.pi * i / num_angs
        ix2 = np.cos(ang) * ix - np.sin(ang) * iy
        iy2 = np.sin(ang) * ix + np.cos(ang) * iy
        fil = make_fil(ix2, iy2, fil_sig)
        fil = fil - np.sum(fil) / np.prod(fil.shape)
        fil_array[:, :, i] = fil

    fil_size = fil_array.shape
    fil_array2[fil_size[0] // 2, fil_size[1] // 2, :] = 1

    # Create image array
    pad_size1 = (np.ceil(np.array(fil_size[:2]) / 2) + 1).astype(int)
    pad_value1 = np.mean(im)
    im_array = np.pad(im, ((pad_size1[0],), (pad_size1[1],)), constant_values=pad_value1)

    im_size = im_array.shape

    # Adjust fil_array (based on size of image input)
    pad_value2 = 0
    fil_array = np.pad(fil_array, ((im_size[0], 0), (im_size[1], 0), (0,)), constant_values=pad_value2)
    fil_array2 = np.pad(fil_array2, ((im_size[0], 0), (im_size[1], 0), (0,)), constant_values=pad_value2)
    pad_size2 = fil_size[:2]
    im_array = np.pad(im_array, ((pad_size2[0],), (pad_size2[1],)), constant_values=pad_value2)

    # Create FFTs
    fft_im_array = np.fft.fftn(im_array)
    fft_fil_array = np.fft.fftn(fil_array)
    fft_fil_array2 = np.fft.fftn(fil_array2)

    # Perform filtering and extract output
    fil_im = np.fft.ifftn(fft_im_array * fft_fil_array)
    fil_im = fil_im[(pad_size1[0] + 1):(im_size[0] - pad_size1[0]), (pad_size1[1] + 1):(im_size[1] - pad_size1[1]), :]

    # Downscale original data
    orig_im = np.fft.ifftn(fft_im_array * fft_fil_array2)
    orig_im = orig_im[(pad_size1[0] + 1):(im_size[0] - pad_size1[0]), (pad_size1[1] + 1):(im_size[1] - pad_size1[1]), :]
    orig_im = orig_im[(pad_size2[0] // 2 + 1):(im_size[0] - pad_size2[0] // 2),
                      (pad_size2[1] // 2 + 1):(im_size[1] - pad_size2[1] // 2), :]

    # Process angles
    mask = np.max(fil_im, axis=2) > filter_threshold
    pref_ang_im = np.argmax(fil_im, axis=2)
    pref_ang = pref_ang_im * np.pi / (num_angs - 1)
    pref_ang[~mask] = np.nan

    # Remove boundary artifacts
    pref_ang[:pad_size[0], :, :] = np.nan
    pref_ang[:, :pad_size[1], :] = np.nan
    pref_ang[-pad_size[0]:, :, :] = np.nan
    pref_ang[:, -pad_size[1]:, :] = np.nan

    return pref_ang, orig_im[:, :, 0]

def make_fil(ix, iy, fil_sig):
    return np.exp(-(ix ** 2 + iy ** 2) / (2 * fil_sig[0] ** 2)) * (1 - (ix ** 2 + iy ** 2) / (2 * fil_sig[1] ** 2))

# Example usage:
# Replace 'your_fil_sig', 'your_num_sig', 'your_num_angs', 'your_filter_threshold',
# 'your_im', and 'your_pad_size' with actual values

your_fil_sig = [1, 2]
your_num_sig = 3
your_num_angs = 8
your_filter_threshold = 0.5
your_im = np.random.rand(100, 100)
your_pad_size = [5, 5]

pref_ang_result, orig_im_result = fft_log(your_fil_sig, your_num_sig, your_num_angs, your_filter_threshold, your_im, your_pad_size)
print(pref_ang_result)
print(orig_im_result)
