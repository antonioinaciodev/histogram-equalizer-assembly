import sys
import numpy as np
from collections import Counter

def load_bin_channel(path, total_pixels=21120):
    try:
        with open(path, 'rb') as f:
            data = f.read()
        return np.frombuffer(data, dtype=np.uint8)
    except FileNotFoundError:
        sys.exit(1)

def generate_equalized_data(channel_array, total_pixels=21120):
    histogram = Counter(channel_array)
    equalized_histogram = {}
    
    for i in range(256):
        cumulative_sum = sum(histogram.get(j, 0) for j in range(i + 1))
        equalized_histogram[i] = int((cumulative_sum * 255) / total_pixels)
        
    return equalized_histogram

def save_report(equalized_histogram, output_path):
    with open(output_path, "w") as file:
        for i in range(256):
            value = equalized_histogram.get(i, 0)
            file.write(f"Pixel {i} - Occurrence {value}\n")

def save_equalized_bin(channel_array, equalized_histogram, output_path):
    equalized_array = np.vectorize(lambda x: equalized_histogram[x])(channel_array).astype(np.uint8)
    equalized_array.tofile(output_path)

def main():
    channels = ['r', 'g', 'b', 'y']
    
    for ch in channels:
        input_bin = f"channels/channel_{ch}.bin"
        output_txt = f"reports/histogram_{ch}_eq_py.txt"
        output_bin = f"channels/channel_{ch}_eq_py.bin"
        
        channel_array = load_bin_channel(input_bin)
        equalized_hist = generate_equalized_data(channel_array)
        
        save_report(equalized_hist, output_txt)
        save_equalized_bin(channel_array, equalized_hist, output_bin)

if __name__ == "__main__":
    main()