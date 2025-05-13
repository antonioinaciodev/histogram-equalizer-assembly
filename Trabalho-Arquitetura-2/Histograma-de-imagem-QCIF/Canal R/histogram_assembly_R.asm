.data
buffer:			.space 21120		# 176x120 = pixels da imagem
.align 2
histogram:		.space 1024			# 256 * 4 = espaço da memória para 256 contadores
.align 2
histogram_eq:	.space 1024			# 256 * 4 = espaço da memória para 256 contadores
file:			.string "bins/Imagem_R.bin"
str_error:		.string "open file error\n"
str_success:	.string "open file success\n"
str_pixel:      .string "Pixel "
str_ocorrencia: .string " - Ocorrencia "
str_histogram:	.string "Histograma:\n"
str_newline:    .string "\n"
.text
.globl main
main:
	jal open_file					# abre o arquivo
	jal print_newline				# printa o newline
	jal read_file					# ler o descritor do arquivo

	jal print_str_histogram			# printa o str_histogram
	jal write_histogram				# preeche o histograma
	jal print_histogram				# printa o histograma

	j end							# finaliza o programa

open_file:
	li a7, 1024         			# syscall open
    la a0, file      				# carrega o endereço da string
    li a1, 0            			# modo leitura
    ecall							# abre o arquivo

	mv s0, a0						# guarda o conteúdo de a0 (retorno da função) em s0 (registrador de salvamento)

	bltz a0, open_error				# caso o retorno seja negativo, deu erro
	bgez a0, open_success			# caso o retorno seja positivo, deu certo

read_file:
	li a7, 63						# syscall read
    mv a0, s0           			# a0 recebe o descritor guardado em s0
    la a1, buffer       			# a1 recebe o endereço do buffer
    li a2, 21120        			# a2 recebe quantos bytes ler
    ecall                 			# lê o descritor e coloca os bytes no buffer
	ret								# retorna para o main

open_success:
	li a7, 4						# syscall printstring
	la a0, str_success				# carrega a string "str_success"
	ecall							# printa que a string foi carregada com sucesso
	ret								# retorna para o main

open_error:
	li a7, 4						# syscall printstring
	la a0, str_error				# carrega a string "str_error"
	ecall							# printa que a string não foi carregada com sucesso
	j end							# pula para o final

print_newline:
    li a7, 4						# syscall PrintString
    la a0, str_newline				# parâmetro é o "str_newline"
    ecall							# printa o "/n"
	ret								# retorna para o main

print_str_histogram:
	li a7, 4						# syscall PrintString
    la a0, str_histogram			# parâmetro é o "str_histogram"
    ecall							# printa o "Histograma: "
	ret								# retorna para o main

write_histogram:
    li s1, 0                   		# índice do buffer
    li s2, 21120               		# tamanho do buffer
    la s3, buffer              		# ponteiro para o início do buffer
    la s4, histogram           		# ponteiro para o início do histograma (256 inteiros)
	
write_histogram_loop:
    bge s1, s2, return   			# se o indice for maior ou igual o tamanho do buffer, termina o loop e vai imprimir

    add t1, s3, s1             		# t1 recebe o deslocamento que vai do inicio do buffer até o indice atual
    lbu t2, 0(t1)              		# t2 recebe o valor do byte atual (0 à 255)
	
    slli t3, t2, 2             		# t3 recebe o byte atual * 4 para encontrar o endereço correspondente no histograma já que o byte ocupa 4 espaçoes na memória
    add t4, s4, t3             		# t4 recebe o endereço do contador correspondente ao pixel

    lw t5, 0(t4)               		# t5 recebe contador que está no endereço correspondente ao pixel
    addi t5, t5, 1             		# incrementa o contador
    sw t5, 0(t4)               		# atualiza o contador no endereço

    addi s1, s1, 1             		# incrementa o índice
    j write_histogram_loop      	# repete o loop

print_histogram:
    li t0, 0             			# índice do pixel (0 a 255)
    la t1, histogram     			# endereço base do histograma
    li t2, 256						# limite da iteração

print_histogram_loop:
    beq t0, t2, return           	# se o indicie do endereço atual for igual ao limite (256) encerra o programa
    slli t3, t0, 2            		# t3 vai receber o endereço correspondente ao pixel atual, ou seja, pixel * 4
    add t4, t1, t3            		# t4 recebe o deslocamento do início do histograma até o endereço correspondente ao pixel
    lw t5, 0(t4)              		# t5 recebe o valor do contador que está no endereço t4
    	
	li a7, 4						# syscall PrintString
	la a0, str_pixel				# parâmetro str_pixel
	ecall							# printa "Pixel "

	li a7, 1						# syscall PrintInt
    mv a0, t0 						# parâmetro é o pixel do contador atual
    ecall							# printa o valor atual

	li a7, 4						# syscall PrintString
	la a0, str_ocorrencia			# parâmetro str_ocorrencia
	ecall							# printa o " - Ocorrencia "
	
	li a7, 1						# syscall PrintInt
	mv a0, t5						# parâmetro é o valor do contador atual
	ecall							# printa a ocorrencia do pixel atual
	
    li a7, 4						# syscall PrintString
    la a0, str_newline				# parâmetro é o newline
    ecall							# printa o "/n"
    	
    addi t0, t0, 1					# incrementa o indice
    j print_histogram_loop			# volta para o loop

return:
	ret								# retorna

end:
	li a7, 10						# syscall exit program
	ecall
