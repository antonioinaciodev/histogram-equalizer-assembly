import numpy as np
from PIL import Image

path_R = 'bins/Imagem_R_eq_assembly.bin'
path_G = 'bins/Imagem_G_eq_assembly.bin'
path_B = 'bins/Imagem_B_eq_assembly.bin'


def carregar_canal(path):
    with open(path, 'rb') as f:
        data = f.read()
    canal = np.frombuffer(data, dtype=np.uint8)
    return canal.reshape((120, 176))


canal_R = carregar_canal(path_R)
canal_G = carregar_canal(path_G)
canal_B = carregar_canal(path_B)

img_rgb = np.stack((canal_R, canal_G, canal_B), axis=2)

imagem_colorida = Image.fromarray(img_rgb, mode='RGB')

output_path = 'imagens/Imagem_RGB_equalizada_baixonivel.jpg'
imagem_colorida.save(output_path)
print(f"Imagem RGB equalizada salva em: {output_path}")
