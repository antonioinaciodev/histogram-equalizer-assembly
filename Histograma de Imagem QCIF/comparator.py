import sys


def carregar_output(path):
    with open(path, "r") as python_output:
        return python_output.readlines()


def verify(output1, output2):
    for i in range(256):
        if output1[i] != output2[i]:
            return "Diferentes"
    return "Iguais"


def main():
    path_1 = "output_python_histogram.txt"
    path_2 = "output_assembly_histogram.txt"

    output_1, output_2 = carregar_output(path_1), carregar_output(path_2)

    print("\n" + verify(output_1, output_2))


if __name__ == "__main__":
    main()
