import sys
import numpy as np
from PIL import Image

def load_image(path):
    try:
        return Image.open(path)
    except FileNotFoundError:
        sys.exit(1)

def save_channel_to_bin(channel_image, output_path):
    img_array = np.array(channel_image, dtype=np.uint8)
    img_array.tofile(output_path)

def main():
    image_path = "images/raw_image.jpg"
    image = load_image(image_path)
    
    image_rgb = image.convert("RGB")
    r, g, b = image_rgb.split()
    y = image.convert("L")
    
    channels = {'r': r, 'g': g, 'b': b, 'y': y}
    
    for name, channel_data in channels.items():
        output_path = f"channels/channel_{name}.bin"
        save_channel_to_bin(channel_data, output_path)

if __name__ == "__main__":
    main()