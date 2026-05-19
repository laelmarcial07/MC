
* Programa ECO1_21-1
* Recibe un byte por el puerto serie y lo transmite de regreso
* Ejecutable en RAM del MCU MC9S08SH32
* marzo 10 de 2021-1

**** Equ's del sci1 *******
scibdh equ $38
scibdl equ $39
scic2  equ $3b
scis1  equ $3c
scid   equ $3f 

********************************

             org $0100

; Inicializa puerto serie
              ldhx #$0082  ;BR=130 para 
              sthx scibdh  ;9600 bps, @Fbus=20 MHz

                         
               mov #$0c,scic2  ;habilita tx y rx
;.........................................
ciclo:      bsr rxsci
            bsr txsci
            bra ciclo


               
***********************************************

** Subrutina txsci
** Antes de invocar:
** a <-- byte a transmitir
** Al retornar:
** Se ha iniciado la transmisión del byte implicado 
txsci:         brclr 6,scis1,txsci
               sta scid
               rts

** Subrutina rxsci
** Recibe un byte por el puerto serie (SCI)
** Al retornar:
** a <-- byte recibido 
rxsci:         brclr 5,scis1,rxsci
               lda scid
               rts

