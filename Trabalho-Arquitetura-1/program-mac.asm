.data
    array:      .word -1, -2, -3, -4, -5, 6, 7, 8, 9, 10
    index:      .word 0
    one:        .word 1
    two:        .word 2
    control:    .word 9
.text
MAIN:                       # Início
    LOCO array          # coloca o endereço do vetor em AC
    SWAP                # coloca o endereço do vetor em SP e AC recebe lixo
LOOP:                       # Loop para verificar valores atuais positivos ou negativos
    LODL 0              # AC recebe o valor atual do vetor
    JPOS VERIFYPOS      # verificaremos se o valor atual é positivo: se sim, verificar se é par ou impar
    JNEG VERIFYNEG      # verificaremos se o valor atual é negativo: se sim, verificar se é par ou impar
VERIFYPOS:                  # Verificar se o positivo é par ou impar
    SUBD two            # AC recebe AC - [two]:2
    JZER ISEVEN         # se AC agora for zero, é par.
    JNEG ISODD          # se AC agora for negativo, é impar.
    JUMP VERIFYPOS      # se não pulou antes, é pq nem é zero e nem é negativo, continua
VERIFYNEG:                  # Verificar se o negativo é par ou impar
    ADDD two            # AC recebe AC - [two]:2
    JZER ISEVEN         # se AC agora for zero, é par.
    JPOS ISODD          # se AC agora for positivo, é impar e negativo.
    JUMP VERIFYNEG      # se não pulou antes, é pq nem é zero e nem é negativo, continua
ISEVEN:                     # Se for par
    LODL 0              # AC recebe o valor atual do vetor
                        #PRINTLNAC            
    INSP 1              # SP avança no vetor
    JUMP INDEXINC       # Pula para index increase
ISODD:                      # Se for impar
    LODL 0              # AC recebe o valor atual do vetor
    ADDL 0              # AC recebe AC + o valor atual do vetor
    STOL 0              # O valor atual do vetor recebe 2x o valor atual do vetor
                        #PRINTLNAC
    INSP 1              # SP avança no vetor
    JUMP INDEXINC       # Pula para index increase
INDEXINC:                   # Incrementar o index
    LODD index          # AC recebe [index]
    ADDD one              # AC recebe AC + 1
    STOD index          # index é incrementado
    JUMP VERIFYEND      # verifica se é o fim do vetor
VERIFYEND:                  # Verifica se tá no fim do vetor
    LODD control        # AC recebe [control]:9
    SUBD index          # AC recebe AC - [index]
    JPOS LOOP           # Se for positivo, verifica o próximo
    JNEG END            # Se for negativo, chegou ao fim do vetor, finaliza
END:                        # Encerra o programa
    JUMP END            #HALT