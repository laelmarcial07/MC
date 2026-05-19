
* Programa EJ1_I2C-LCD
* Al ejecutarse se escribe la palabra APOLO en el renglón 2,empleando las subrutinas
* escom4 y escdat4.

* Mediante la subrutina copiadis,se escribe el texto Hola alumnos en el renglón 1.

* Después que se han escrito los textos en el LCD se regresa al receptor de comandos.
 
recepcom equ $fe7d

               org $0100

            jsr init_icc
            jsr inilcd
              
            lda  #$c2
            jsr escom4 ;escribe al LCD comando para posicionar despliegue a partir de renglón 2 y columna 3
            lda #$41
            jsr escdat4 ;escribe al LCD el carácter cuyo código ascii es $41 (A)
            lda #$50
            jsr escdat4 ;escribe al LCD el carácter cuyo código ascii es $50 (P)
            lda #$4f
            jsr escdat4 ;escribe al LCD el carácter cuyo código ascii es $4f (O)
            lda #$4c
            jsr escdat4 ;escribe al LCD el carácter cuyo código ascii es $4c (L)
            lda #$4f
            jsr escdat4 ;escribe al LCD el carácter cuyo código ascii es $4f (O)

              
            lda #$80
            ldhx #mensaje
            jsr copiadis

            jmp recepcom

$include "c:\Libs_aux_chipbas8\conop_iics08sh.asm"
$include "c:\Libs_aux_chipbas8\iic-lcd_pcf8574.asm"


*             1234567890123456
mensaje: fcc "  Hola alumnos  " 


