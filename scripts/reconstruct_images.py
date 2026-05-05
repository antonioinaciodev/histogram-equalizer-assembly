import sys
import numpy as np
from PIL import Image

def load_bin_to_matrix(path, width=176, height=120):
    try:
        with open(path, 'rb') as f:
            data = f.read()
        img_array = np.frombuffer(data, dtype=np.uint8)
        return img_array.reshape((height, width))
    except FileNotFoundError:
        sys.exit(1)

def reconstruct_grayscale(y_path, output_path):
    y_matrix = load_bin_to_matrix(y_path)
    image = Image.fromarray(y_matrix, mode='L')
    image.save(output_path)

def reconstruct_rgb(r_path, g_path, b_path, output_path):
    r_matrix = load_bin_to_matrix(r_path)
    g_matrix = load_bin_to_matrix(g_path)
    b_matrix = load_bin_to_matrix(b_path)
    
    rgb_matrix = np.stack((r_matrix, g_matrix, b_matrix), axis=2)
    image = Image.fromarray(rgb_matrix, mode='RGB')
    image.save(output_path)

def main():
    source = "asm" 
    
    y_bin = f"channels/channel_y_eq_{source}.bin"
    r_bin = f"channels/channel_r_eq_{source}.bin"
    g_bin = f"channels/channel_g_eq_{source}.bin"
    b_bin = f"channels/channel_b_eq_{source}.bin"
    
    reconstruct_grayscale(y_bin, "images/equalized_grayscale.jpg")
    reconstruct_rgb(r_bin, g_bin, b_bin, "images/equalized_color.jpg")

if __name__ == "__main__":
    main()