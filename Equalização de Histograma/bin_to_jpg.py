import numpy as np
from PIL import Image

input_file = 'Imagem_Y_eq_assembly.bin'
output_file = 'imagens/Imagem_PB_equalizada_altonivel.jpg'

# Lê os dados do arquivo binário
with open(input_file, 'rb') as f:
    data = f.read()

# Converte os dados em um array numpy
img_array = np.frombuffer(data, dtype=np.uint8)

# Redimensiona para as dimensões corretas
img_array = img_array.reshape((176, 120))

# Cria a imagem em escala de cinza
image = Image.fromarray(img_array)

# Salva como JPG
image.save(output_file)
print(f"Imagem salva como {output_file}")
