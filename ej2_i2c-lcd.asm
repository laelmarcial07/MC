
* Programa EJ2_I2C-LCD
* Al ejecutarse
* 1. Durante dos degundos,se escribe el texto:
*    HOLA ALUMNOS en el renglón 1
*    ESTUDIOSOS en el renglón 2
* 2. Durante dos segundos el LCD se borra
* 3. Se regresa al paso 1

              org $0100

            jsr init_icc
            jsr inilcd
              
lazo:       lda #$80
            ldhx #mensaje1
            jsr copiadis

            lda #$c0
            ldhx #mensaje2
            jsr copiadis

            jsr ret2seg ;Espera 2 segundos

            lda #$01
            jsr escom4 ;Borra LCD
            jsr ret2seg ;Espera 2 segundos
            bra lazo

*** Subrutinas ***        


ret20ms:     pshh
             pshx
             ldhx #$9c3d
vuelta:      nop
             nop
             aix #$ff
             cphx #$0000
             bne vuelta
             pulx
             pulh
             rts

ret2seg:     psha
             lda #$64
otroret20ms: jsr ret20ms
             deca
             bne otroret20ms
             pula
             rts
         
$include "c:\Libs_aux_chipbas8\conop_iics08sh.asm"
$include "c:\Libs_aux_chipbas8\iic-lcd_pcf8574.asm"

** Texto a colocar **
*              1234567890123456
mensaje1: fcc "  HOLA ALUMNOS  " 
mensaje2: fcc "   ESTUDIOSOS   "


