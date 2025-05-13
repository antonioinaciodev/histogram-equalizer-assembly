import sys


def carregar_output(path):
    try:
        with open(path, "r") as file:
            return file.readlines()
    except FileNotFoundError:
        print(f"Arquivo não encontrado: {path}")
        sys.exit(1)


def verify(output1, output2):
    for i in range(256):
        if output1[i].strip() != output2[i].strip():
            return "Diferentes"
    return "Iguais"


def main():
    path_1 = "textos/output_python_histogram.txt"
    path_2 = "textos/output_assembly_histogram.txt"

    output_1 = carregar_output(path_1)
    output_2 = carregar_output(path_2)

    print("\n" + verify(output_1, output_2))


if __name__ == "__main__":
    main()
