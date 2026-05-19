
* Programa ej1tpm1b
* Mediante el temporizador 1 se genera
* una interrupción periódica cada 400 ms.
* La acción que se efectúa cada Tovf consiste
* en la complementación de ptc0.
* Todo lo hace la rutina de interrupción implicada.


**************************************************************

ptcd equ $04
ptcdd equ $05

tpm1sc equ $20 
tpm1modh equ $23
tpm1modl equ $24

                 org $8000

                 bset 0,ptcdd ;ptc0 es salida

                 mov #$4f,tpm1sc ;Tp = Tb,pe=128,toie <-- 1
                 mov #$f4,tpm1modh
                 mov #$23,tpm1modl ;Tovf = 400 mS ms
                 cli

fin:             bra fin

servovf:          lda tpm1sc
                  bclr 7,tpm1sc ;TOF <-- 0

                 lda ptcd
                 eor #$01
                 sta ptcd ;Se complementó ptc0
                 rti

                 org $d7e8
                 dw servovf ;coloca vector asociado



  

 