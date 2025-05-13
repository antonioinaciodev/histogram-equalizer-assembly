import numpy as np
from PIL import Image


def bin_to_jpg(input_file, output_file):
    # Lê os dados do arquivo binário
    with open(input_file, 'rb') as f:
        data = f.read()

    # Converte os dados em um array numpy
    img_array = np.frombuffer(data, dtype=np.uint8)

    # Redimensiona para as dimensões corretas
    img_array = img_array.reshape((120, 176))

    # Cria a imagem em escala de cinza
    image = Image.fromarray(img_array)

    # Salva como JPG
    image.save(output_file)
    print(f"Imagem salva como {output_file}")


def main():
    for i in range(3):
        if i == 0:
            bin_to_jpg("bins/Imagem_B.bin", "imagens/Imagem_B.jpg")
        elif i == 1:
            bin_to_jpg("bins/Imagem_B_eq_python.bin",
                       "imagens/Imagem_B_equalizada_altonivel.jpg")
        elif i == 2:
            bin_to_jpg("bins/Imagem_B_eq_assembly.bin",
                       "imagens/Imagem_B_equalizada_baixonivel.jpg")


if __name__ == "__main__":
    main()
