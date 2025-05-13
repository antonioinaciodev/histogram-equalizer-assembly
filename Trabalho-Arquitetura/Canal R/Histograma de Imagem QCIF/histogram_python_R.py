from PIL import Image
from collections import Counter
import numpy as np
import sys


def get_img(path):
    try:
        img = Image.open(path).convert("RGB")
        print("open file success")
        return img
    except FileNotFoundError:
        print("open file error")
        sys.exit()


def histograma(img):
    array_bytes_image = np.array(img, dtype=np.uint8)
    array_bytes_image.tofile("bins/Imagem_R.bin")
    return Counter(array_bytes_image.flatten())


def main():
    path = "imagens/Imagem.jpg"

    Imagem = get_img(path)
    canal_r, canal_g, canal_b = Imagem.split()
    Histograma = histograma(canal_r)

    print("Histogram R Channel:")

    for i in range(256):
        ocorrencias = Histograma.get(i, 0)
        print(f"Pixel {i} - Ocorrencia {ocorrencias}")


if __name__ == "__main__":
    main()
