# 📊 RISC-V Image Equalizer

## 📌 Sobre o Projeto
Este repositório contém um projeto de co-design de hardware e software desenvolvido para a disciplina de Arquitetura de Computadores (Ciência da Computação - UFPI) O objetivo central é realizar a Equalização de Histograma de Imagens Digitais diretamente em nível *bare-metal* utilizando **Assembly RISC-V**, demonstrando manipulação de memória em baixo nível, processamento de dados e otimização.

Para dar suporte ao algoritmo em Assembly, um ecossistema robusto em **Python** atua como *pipeline* de pré e pós-processamento[cite: 13]. Ele lida com tarefas de alto nível, como a separação de imagens em canais de cores distintos (Vermelho, Verde, Azul e Luminância/Escala de Cinza Y), a conversão desses canais para arquivos binários brutos e a reconstrução dos bytes processados de volta em imagens digitais visíveis.

## 🏗️ Arquitetura do Projeto
O repositório foi rigorosamente refatorado para seguir os princípios de arquitetura modular:

*   **`src/`**: Contém os algoritmos centrais em Assembly RISC-V (`.asm`) para cada canal específico.
*   **`scripts/`**: Contém o ecossistema generalizado em Python.
*   **`channels/`**: Armazena as matrizes binárias brutas de entrada (`.bin`) e saída (`_eq_asm.bin`).
*   **`images/`**: Abriga a imagem bruta inicial e as saídas reconstruídas finais (Escala de Cinza e RGB).
*   **`reports/`**: Salva os histogramas gerados em `.txt` para validação estatística.
*   **`docs/`**: Contém os relatórios acadêmicos teóricos.

## ⚙️ O Pipeline (Como Executar)
O fluxo de dados passa por três etapas principais de execução:

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/antonioinaciodev/histogram-equalizer-assembly.git
    cd histogram-equalizer-assembly
    ```

2.  **Pré-processamento (Python):** 
    Execute `extract_channels.py` para ler `images/raw_image.jpg`, dividi-la nos canais R, G, B e Y, e exportar os dados brutos para a pasta `channels/`.

3.  **Processamento (Assembly RISC-V):** 
    Abra os arquivos `src/eq_channel_*.asm` em um simulador RISC-V (como RARS ou Venus). O código em Assembly lerá os binários de entrada, calculará a Função de Distribuição Acumulada (CDF), aplicará a matemática de equalização e gerará os binários processados e os relatórios de texto do histograma.

4.  **Pós-processamento (Python):** 
    Execute `reconstruct_images.py` para ingerir os arquivos `.bin` equalizados e reconstruí-los em `equalized_grayscale.jpg` e `equalized_color.jpg` de volta no diretório `images/`.
    *(Opcional: Execute `python_equalizer.py` para gerar os dados de "ground-truth" em alto nível para benchmarking)*.

## 🚀 Funcionalidades
*   **Processamento Completo em Baixo Nível:** Cálculo de histograma e equalização de pixels implementados inteiramente em Assembly RISC-V.
*   **Suporte Multicanal:** Capacidades de processamento independente para os canais R, G, B e Y.
*   **Pipeline Automatizado:** Scripts em Python capazes de processar em lote matrizes multidimensionais (tensores) transformando-os em binários legíveis em baixo nível.
*   **Reconstrutor RGB:** Reagrupa as matrizes Vermelha, Verde e Azul equalizadas individualmente em uma imagem colorida unificada.

## 🛠️ Tecnologias Utilizadas
*   **Assembly RISC-V:** Algoritmo central de equalização e estruturas de dados.
*   **Python:** Scripting principal e automação do *pipeline*.
*   **NumPy:** Operações de array multidimensional e manipulação de binários.
*   **Pillow (PIL):** Decodificação e codificação de imagens em alto nível.
