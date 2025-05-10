from PIL import Image
from collections import Counter
import numpy as np
import sys

# Abre a imagem JPEG e converte para escala de cinza (L)
try:
    img = Image.open("imagens/Imagem.jpg").convert("L")
    print("open file success")
except FileNotFoundError:
    print("open file error")
    sys.exit()

# Converte a imagem para um array numpy de uint8
array_bytes_Y = np.array(img, dtype=np.uint8)

# Salva o array como bytes puros em um arquivo .bin
array_bytes_Y.tofile("Imagem_Y.bin")

# Calcula o histograma com o Counter
histograma = Counter(array_bytes_Y.flatten())

# Imprime o histograma ordenado por valor de pixel
print("Histogram Y Channel:")
for i in range(256):
    ocorrencias = histograma.get(i, 0)
    print(f"Pixel {i} - Ocorrencia {ocorrencias}")
print()
