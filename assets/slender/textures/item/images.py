#!/usr/bin/env python3

import numpy as np
from PIL import Image

page_names = ["page_" + str(i) + ".png" for i in range(2,8)]

# Load images
images = []
for name in page_names:
    images.append(np.array(Image.open(name)))

# Stack the 3 images into a 4d sequence
sequence = np.stack(images, axis=3)

# Repace each pixel by mean of the sequence
result = np.median(sequence, axis=3).astype(np.uint8)

# Save to disk
Image.fromarray(result).save('result.png')