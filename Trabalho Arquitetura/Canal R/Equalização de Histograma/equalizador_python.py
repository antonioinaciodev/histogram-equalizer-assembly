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


def equalizer(Histograma):
    equalizado = Counter()

    for i in range(256):
        fac = 0
        for j in range(i):
            fac += Histograma.get(j, 0)
        ocorrencia_eq = (fac * 255) / 21120
        equalizado[i] = int(ocorrencia_eq)
    return equalizado


def write_txt(Histograma):
    with open("textos/histograma_equalizado_python.txt", "w") as file:

        for i in range(256):
            fac = 0
            for j in range(i):
                fac += Histograma.get(j, 0)
            ocorrencia_eq = (fac * 255) / 21120
            print(f"Pixel {i} - Ocorrencia {int(ocorrencia_eq)}")
            file.write(f"Pixel {i} - Ocorrencia {int(ocorrencia_eq)}\n")


def write_bin(img, equalizado):
    array = np.array(img, dtype=np.uint8)
    equalized_array = np.vectorize(
        lambda x: equalizado[x])(array).astype(np.uint8)
    equalized_array.tofile("bins/Imagem_R_eq_python.bin")


def main():
    path = "imagens/Imagem.jpg"

    Imagem = get_img(path)
    canal_r, canal_g, canal_b = Imagem.split()
    Histograma = histograma(canal_r)
    write_txt(Histograma)
    equalizado = equalizer(Histograma)
    write_bin(canal_r, equalizado)


if __name__ == "__main__":
    main()
