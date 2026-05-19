
* Programa ej1tpm1b_4seg
* Mediante el temporizador 1 se genera
* una interrupción periódica cada 400 ms.

* Empleando este valor de Tovf se efectua una acción cada
* cuatro segundos.

* La acción que se efectúa cada cuatro segundos consiste
* en la complementación de ptc0.

* Todo lo hace la rutina de interrupción implicada.


**************************************************************

ptcd equ $04
ptcdd equ $05

tpm1sc equ $20 
tpm1modh equ $23
tpm1modl equ $24

cont10 equ $a0
                 org $8000

                 bset 0,ptcdd ;ptc0 es salida

                 mov #$4f,tpm1sc ;Tp = Tb,pe=128,toie <-- 1
                 mov #$f4,tpm1modh
                 mov #$23,tpm1modl ;Tovf = 400 mS ms
                 cli
		     
                 clr cont10 ;cont10 <-- 0

fin:             bra fin

servovf:          lda tpm1sc
                  bclr 7,tpm1sc ;TOF <-- 0

			inc cont10 ;cont10 <-- cont10+1
			lda cont10 ;a <-- cont10
			cmp #$0A ;Compara cuenta con 10
			bne salir

			clr cont10 ;cont10 <-- 0

* 			Accionamiento que se efectuará cada 4s

                 lda ptcd
                 eor #$01
                 sta ptcd ;Se complementó ptc0

salir:           rti

                 org $d7e8
                 dw servovf ;coloca vector asociado



  

 