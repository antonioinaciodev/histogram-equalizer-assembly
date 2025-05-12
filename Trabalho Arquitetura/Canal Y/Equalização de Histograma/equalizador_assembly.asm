.data
.align 2
buffer:				.space 21120			# 176x120 = pixels da imagem
.align 2
buffer_eq:			.space 21120			# 176x120 = pixels da imagem
.align 2
histogram:			.space 1024				# 256 * 4 = espaço da memória para 256 contadores
.align 2
histogram_eq:		.space 1024				# 256 * 4 = espaço da memória para 256 contadores
.align 2
int_buffer:			.space 4				# 3 bytes + '\0'
file:				.asciz "bins/Imagem_Y.bin"
output_file:    	.asciz "textos/histograma_equalizado_assembly.txt"
output_bin_file:	.asciz "bins/Imagem_Y_eq_assembly.bin"
str_error:			.asciz "open file error\n"
str_success:		.asciz "open file success\n"
str_pixel:      	.asciz "Pixel "
str_ocorrencia: 	.asciz " - Ocorrencia "
str_histogrameq:	.asciz "Histograma Equalizado:\n"
str_newline:    	.asciz "\n"
.text
.globl main
main:
	jal open_file							# abre o arquivo
	jal print_newline						# printa o newline
	jal read_file							# ler o descritor do arquivo

	jal write_histogram						# preeche o histograma

	jal print_str_histogrameq				# printa o str_histogrameq
	jal write_histogram_eq					# preenche o o histograma equalizado
	jal print_histogram_eq					# printa o histrograma equalizado
	
	jal open_output_file					# abre o arquivo de saída .txt
	jal s9, write_histogrameq_output_file	# escreve no arquivo de saída
	
	jal write_buffereq						# escreve o buffer equalizado
	jal open_output_bin_file				# abre o arquivo de saída .bin
	jal write_output_bin					# escreve no arquivo de saída

	j end

open_file:
	li a7, 1024         					# syscall OpenFile
    la a0, file      						# carrega o endereço da string
    li a1, 0            					# modo leitura
    ecall									# abre o arquivo

	mv s0, a0								# guarda o conteúdo de a0 (retorno da função) em s0 (registrador de salvamento)

	bltz a0, open_error						# caso o retorno seja negativo, deu erro
	bgez a0, open_success					# caso o retorno seja positivo, deu certo

read_file:
	li a7, 63						# syscall read
    mv a0, s0           			# a0 recebe o descritor guardado em s0
    la a1, buffer       			# a1 recebe o endereço do buffer
    li a2, 21120        			# a2 recebe quantos bytes ler
    ecall                 			# lê o descritor e coloca os bytes no buffer
	ret								# retorna para o main

open_success:
	li a7, 4						# syscall printstring
	la a0, str_success				# carrega a string "success"
	ecall							# printa que a string foi carregada com sucesso
	ret								# retorna para o main

open_error:
	li a7, 4						# syscall printstring
	la a0, str_error				# carrega a string de erro
	ecall							# printa que a string não foi carregada com sucesso
	j end							# pula para o final

print_newline:
    li a7, 4						# syscall PrintString
    la a0, str_newline				# parâmetro é o newline
    ecall							# printa o "/n"	
	ret								# retorna para o main

print_str_histogrameq:
	li a7, 4						# syscall PrintString
    la a0, str_histogrameq			# parâmetro é o str_histogrameq
    ecall							# printa o "/n"	
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
    beq t0, t2, return          	# se o indicie do endereço atual for igual ao limite (256) encerra o programa
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

write_histogram_eq:
	li s1, 0                   		# índice do histograma
    li s2, 256               		# tamanho do histograma
    la s3, histogram           		# ponteiro para o início do histograma
	la s4, histogram_eq				# ponteiro para o início do histograma equalizado

write_histogram_eq_loop:
	bge s1, s2, return   			# se o indice for maior ou igual o tamanho do histograma, termina o loop

	li t0, 0                  		# t0 vai acumular o CDF
    li t1, 0                  		# índice auxiliar i

fac_loop:
	bgt t1, s1, pixel_equalizer		# se o indice do ponteiro for maior q o indicie atual, pula
	slli t2, t1, 2					# t2 recebe a distância do endereço do indice atual
	add t3, s3, t2					# t3 recebe o endereço atual do histograma
	lw t4, 0(t3)					# t4 recebe fac[i]
	add t0, t0, t4					# fac = fac += fac[i]
	addi t1, t1, 1					# incrementa o indice
	j fac_loop						# volta para o loop
	
pixel_equalizer:
	li t1, 255
	mul t5, t0, t1					# t5 recebe fac[i] * 255

	li t1, 21120
	div t6, t5, t1					# t6 recebe (fac[i] * 255) / 21120 (pixel equalizado)

	add t0, s4, t2					# t0 recebe o deslocamento s4 (inicio do hist_eq) até t2 (endereço do indice atual)
	sw t6, 0(t0)					# o endereço atual de hist_eq recebe o pixel equalizado

	addi s1, s1, 1             		# incrementa o índice
	j write_histogram_eq_loop		# volta para o loop

print_histogram_eq:
    li t0, 0             			# índice do pixel (0 a 255)
    la t1, histogram_eq     		# endereço base do histograma
    li t2, 256						# limite da iteração

print_histogram_eq_loop:
    beq t0, t2, return          	# se o indicie do endereço atual for igual ao limite (256) encerra o programa
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
    j print_histogram_eq_loop		# volta para o loop

open_output_file:
	li a7, 1024						# syscall OpenFile
	la a0, output_file				# parâmetro "output_file"
	li a1, 1						# modo de escrita
	ecall							# abre o arquivo
	mv s6, a0						# guarda o descritor em s6
	ret								# retorna ao main
	
write_histogrameq_output_file:
	li t0, 0						# indice pixel (0 a 255)
	li t6, 255						# limite da iteração
	la t1, histogram_eq				# ponteiro para o inicio do histograma equalizado
	li a1, 0

write_histogrameq_output_file_loop:
	bgt t0, t6, return_main			# se o indice for maior que 255, retorna ao main
	
									# escreve "str_pixel" no output
	li a7, 64						# syscall Write
	mv a0, s6						# parâmetro descritor do arquivo a ser escrito
	la a1, str_pixel				# parâmetro string que será escrita
	li a2, 6						# parâmetro quantos bytes serão escritos
	ecall							# escreve "Pixel " no arquivo
	
									# escreve o valor do pixel no output
	mv a1, t0						# passa como parâmtro o indice do pixel
	jal int_to_string				# converte o indice do pixel para string 
	li a7, 64						# syscall Write
	mv a1, a0						# parâmetro string que será escrita
    mv a0, s6						# parâmetro descritor do arquivo a ser escrito
    ecall							# escreve o valor do pixel no arquivo
    
    								# escreve "str_ocorrencia" no output
	li a7, 64						# syscall Write
	mv a0, s6						# parâmetro descritor do arquivo a ser escrito
	la a1, str_ocorrencia			# parâmetro string que será escrita
	li a2, 14						# parâmetro quantos bytes serão escritos
	ecall							# escreve " - Ocorrencia " no arquivo
	
									# escreve o valor da ocorrencia equalizada do pixel atual 
	lw t3, 0(t1)					# t3 recebe o valor atual da ocorrencia atual
	mv a1, t3						# passa o valor da ocorrência como parâmetro
	jal int_to_string				# converte o valor para string
	li a7, 64						# syscall Write
	mv a1, a0						# parâmetro a1 recebe o endereço do início do buffer
    mv a0, s6						# parâmetro a0 recebe o descritor do arquivo
    ecall							# escreve o valor do pixel no arquivo

    								# escreve o "newline"
    li a7, 64						# syscall Write
	mv a0, s6						# parâmetro descritor do arquivo a ser escrito
	la a1, str_newline				# parâmetro string que será escrita
	li a2, 1						# parâmetro quantos bytes serão escritos
	ecall							# escreve "\n" no arquivo
	
    addi t0, t0, 1					# incrementa o indice (0-255)
    addi t1, t1, 4					# incrementa o endereço do histograma equalizado
    j write_histogrameq_output_file_loop
    
int_to_string:
	la t4, int_buffer				# carrega um ponteiro para o buffer
	li s8, 0						# contador do tamanho da string
	addi t4, t4, 4					# t4 recebe o deslocamento do início do buffer até o final
	li t5, 0						# t5 recebe 0 (indica o final da string)
	sb t5, 0(t4)					# a pos final do buffer recebe o indicador de final de string
	mv s10, a1						# move para um registrador de salvamento o parâmetro do valor a ser escrito na string
	li s4, 10						# s4 será usado como constante 10
	
int_to_string_loop:
	remu t2, s10, s4				# t2 recebe o resto da divisão por 10
	addi t2, t2, '0'				# t2 recebe o valor ascii do valor
	addi t4, t4, -1					# volto no buffer
	sb t2, 0(t4)					# coloca no bufffer o valor ascii
	addi s8, s8, 1					# incrementa o contador do tamanho da string
	divu s10, s10, s4				# atualiza val com val/10
	bnez s10, int_to_string_loop	# se o meu valor atual não for 0, loop
	mv a2, s8						# coloca no retorno a2 o tamanho da string
	mv a0, t4						# coloca no retorno da função o endereço do início do buffer
	ret								# retorna para o loop de escrita

write_buffereq:
    li s1, 0						# s1 recebe o indice do buffer
    li s2, 21120					# s2 recebe o tamanho do buffer
    la s3, buffer					# s3 recebe o ponteiro para o inicio do buffer
    la s4, buffer_eq				# s4 recebe o ponteiro para o inicio do buffer equalizado
    la s5, histogram_eq				# s5 recebe o ponteiro para o inicio do histograma equalizado

write_buffereq_loop:
    bge s1, s2, return				# se o indice for maior ou igual ao tamanho do buffer, retorna

    add t1, s3, s1       			# t1 recebe o endereço do byte atual
    lbu t2, 0(t1)       			# t2 recebe o valor do pixel atual (0 a 255)

    slli t3, t2, 2       			# t3 recebe o endereço no histograma do pixel atual
    add t4, s5, t3       			# t4 recebe o endereço do valor equalizado do pixel
    lw t5, 0(t4)         			# t5 recebe o valor equalizado do pixel atual

    add t6, s4, s1       			# t6 recebe o endereço em buffer_eq
    sb t5, 0(t6)         			# substitui o valor antigo pelo valor equalizado em t5

    addi s1, s1, 1					# incrementa o indice
    j write_buffereq_loop

open_output_bin_file:
    li a7, 1024						# syscall OpenFile
    la a0, output_bin_file			# parâmetro arquivo a ser aberto
    li a1, 1           				# parâmetro modo de escrita
    ecall							# abre o arquivo
    mv s6, a0          				# s6 recebe o descritor
    ret								# retorna ao main

write_output_bin:
    li a7, 64           			# syscall Write
    mv a0, s6           			# parâmetro descritor de saída
    la a1, buffer_eq				# parâmetro endereço do início do buffer_eq
    li a2, 21120					# parâmetro quantos bytes devem ser escritos no arquivo
    ecall							# escreve no arquivo
    ret								# retorna ao main

return:
	ret								# retorna
	
return_main:
	mv ra, s9						# endereço de retorno recebe o endereço do main
	ret								# retorna para o main
	
end:
	li a7, 10						# syscall exit program
	ecall
