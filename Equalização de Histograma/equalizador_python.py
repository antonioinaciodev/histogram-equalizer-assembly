from PIL import Image
from collections import Counter
import numpy as np
import sys

# Abre a imagem JPEG e converte para escala de cinza (L)
try:
    img = Image.open("Imagem.jpg").convert("L")
    print("open file success")
except FileNotFoundError:
    print("open file error")
    sys.exit()

img.save("Imagem_PB.jpg")

# Converte a imagem para um array numpy de uint8
array_bytes_Y = np.array(img, dtype=np.uint8)

# Salva o array como bytes puros em um arquivo .bin
array_bytes_Y.tofile("Imagem_Y_alto_nivel.bin")

# Calcula o histograma com Counter
histograma = Counter(array_bytes_Y.flatten())

# Frequência acumulada
frequencia_acumulada = 0
lut = np.zeros(256, dtype=np.uint8)
total_pixels = array_bytes_Y.size  # automático agora

for i in range(256):
    frequencia_acumulada += histograma.get(i, 0)
    valor_eq = (frequencia_acumulada * 255) / total_pixels
    lut[i] = int(round(valor_eq))

# Aplica a LUT (lookup table) para gerar a imagem equalizada
equalizada_array = np.take(lut, array_bytes_Y)

# Salva a imagem equalizada
Image.fromarray(equalizada_array).save("Imagem_PB_equalizada_altonivel.jpg")

# Salva o histograma equalizado em um arquivo .txt
with open("histograma_equalizado.txt", "w") as f:
    for i in range(256):
        f.write(f"Pixel {i} - Ocorrencia {lut[i]}\n")

print("Equalização concluída com sucesso.")
