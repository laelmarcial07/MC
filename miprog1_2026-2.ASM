 
; Este programa coloca 7 en el puerto C


            org $0100

            mov #$0f,$05 ;pc0 a pc3 son salida

            mov #$07,$04

fin:        jmp fin



