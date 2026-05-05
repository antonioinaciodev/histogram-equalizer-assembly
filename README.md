RISC-V Image Equalizer

📌 About the Project
This repository contains a hardware-software co-design project developed for a Computer Architecture course. The core objective is to perform Digital Image Histogram Equalization directly at the bare-metal level using RISC-V Assembly, showcasing low-level memory manipulation, data processing, and optimization.

To support the Assembly algorithm, a robust Python ecosystem acts as the pre- and post-processing pipeline. It handles high-level tasks such as splitting images into separate color channels (Red, Green, Blue, and Luminance/Grayscale Y), converting them to raw binary files, and reconstructing the processed bytes back into viewable digital images.

🏗️ Project Architecture
The repository was strictly refactored to follow Clean Code principles and a modular architecture:

src/: Contains the core RISC-V Assembly algorithms (.asm) for each specific channel.

scripts/: Contains the generalized Python ecosystem.

channels/: Stores the raw input (.bin) and output (_eq_asm.bin) binary matrices.

images/: Houses the initial raw image and the final reconstructed outputs (Grayscale and RGB).

reports/: Saves the generated .txt histograms for statistical validation.

docs/: Contains the theoretical academic reports.

⚙️ The Pipeline (How to Run)
The data flows through three main execution steps:

Pre-processing (Python):
Run extract_channels.py to read images/raw_image.jpg, split it into R, G, B, and Y channels, and export the raw data into channels/.

Processing (RISC-V Assembly):
Open the src/eq_channel_*.asm files in a RISC-V simulator (like RARS or Venus). The Assembly code will read the input binaries, compute the Cumulative Distribution Function (CDF), apply the equalization math, and output the processed binaries and histogram text reports.

Post-processing (Python):
Run reconstruct_images.py to ingest the equalized .bin files and reconstruct them into equalized_grayscale.jpg and equalized_color.jpg back in the images/ directory.
(Optional: Run python_equalizer.py to generate the high-level ground-truth data for benchmarking).

🚀 Features
Full Low-Level Processing: Histogram calculation and pixel equalization implemented entirely in RISC-V Assembly.

Multi-Channel Support: Independent processing capabilities for R, G, B, and Y channels.

Automated Pipeline: Python scripts capable of batch-processing multi-dimensional arrays (tensors) into low-level readable binaries.

RGB Reconstructor: Re-stacks the individually equalized Red, Green, and Blue matrices into a unified color image.

🛠️ Tech Stack
RISC-V Assembly: Core equalization algorithm and data structures.

Python: Main scripting and pipeline automation.

NumPy: Multi-dimensional array operations and binary manipulation.

Pillow (PIL): High-level image decoding and encoding.