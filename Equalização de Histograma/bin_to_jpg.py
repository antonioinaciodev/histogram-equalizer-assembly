import numpy as np
from PIL import Image

# Parâmetros da imagem (resolução QCIF)
width = 176
height = 120  # Se for 120, mude aqui
input_file = 'Imagem_Y_eq.bin'  # Altere conforme o nome do seu .bin
output_file = 'imagens/Imagem_PB_equalizada_baixonivel.jpg'

# Lê os dados do arquivo binário
with open(input_file, 'rb') as f:
    data = f.read()

# Converte os dados em um array numpy
img_array = np.frombuffer(data, dtype=np.uint8)

# Verifica se o tamanho do array está correto
expected_size = width * height
if img_array.size != expected_size:
    raise ValueError(
        f'Tamanho incorreto: esperado {expected_size}, mas foi {img_array.size}')

# Redimensiona para as dimensões corretas
img_array = img_array.reshape((height, width))

# Cria a imagem em escala de cinza
image = Image.fromarray(img_array, mode='L')

# Salva como JPG
image.save(output_file)
print(f"Imagem salva como {output_file}")
