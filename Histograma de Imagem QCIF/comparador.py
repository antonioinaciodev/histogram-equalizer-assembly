import sys


def carregar_output(path):
    with open(path, "r") as python_output:
        return python_output.readlines()


def extrair_ocorrencias(linhas):
    ocorrencias = {}
    for linha in linhas:
        if "Ocorrencia" in linha:
            partes = linha.split("Ocorrencia")
            try:
                pixel = int(partes[0].replace(
                    "Pixel", "").strip().replace("-", ""))
                valor = int(partes[1].strip())
                ocorrencias[pixel] = valor
            except ValueError:
                continue
    return ocorrencias


def somar_ocorrencias(entrada):
    soma = 0
    for linha in entrada:
        if "Ocorrencia" in linha:
            partes = linha.split("Ocorrencia")
            try:
                ocorrencias = int(partes[1].strip())
                soma += ocorrencias
            except ValueError:
                continue
    return soma


def main():
    path_1 = "output_python_histogram.txt"
    path_2 = "output_assembly_histogram.txt"

    output_1, output_2 = carregar_output(path_1), carregar_output(path_2)

    ocorrencias_1, ocorrencias_2 = extrair_ocorrencias(
        output_1), extrair_ocorrencias(output_2)

    print(f"FAC 1: {somar_ocorrencias(output_1)}")
    print(f"FAC 2: {somar_ocorrencias(output_2)}")

    # Comparar pixel por pixel
    for i in range(256):
        py = ocorrencias_1.get(i, 0)
        rv = ocorrencias_2.get(i, 0)
        if py != rv:
            print("Diferentes")
            sys.exit()
    print("Iguais")


if __name__ == "__main__":
    main()

"hist=eq[i] = acumulada de [i] * 255 / 21120"
