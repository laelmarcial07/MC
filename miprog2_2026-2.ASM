 
; Este programa coloca 7 en el puerto C
; Se usan directivas EQU
; Se ilustra funcionalidad de las directivas db y dw

ptcd equ $04
ptcdd equ $05

dato equ $01




            org $0100

            mov #$0f,ptcdd ;pc0 a pc3 son salida

            mov #dato,ptcd

fin:        jmp fin

            db $44,$a2

            org $0130 
            db $00,$01,$02

            dw $44a2,fin
 



