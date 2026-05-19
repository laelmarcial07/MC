
** Al ejecutarse este programa se coloca un contador binario en el puerto C
** del MCU.
** Hay una espera de un segundo entre cuentas.

ptcd equ $04
ptcdd equ $05

                org $0100
 
                lda #$0f
                sta ptcdd ;ptc0 a ptc3 son salida
                
                clra
otravez:        sta ptcd
                jsr ret1seg
                inca
                bra otravez

ret1seg:        psha
                lda #$32 ;a <-- 50 decimal
otro_20ms:      jsr ret20ms
                deca
                bne otro_20ms
                pula
                rts


ret20ms:        pshh  ;[2]
                pshx  ;[2]
                ldhx #$9c3d    ;Xr es un número de 16 bits ;[3]

vuelta:         nop   ;[1]                     <<
                nop   ;[1]
                aix #$ff ;h:x <-- h:x - 1 ;[2]
                cphx #$0000     ;[3] 
                bne vuelta   ;[3]        >>

                nop     ;[1]
                pulx    ;[3]
                pulh    ;[3]
                rts     ;[5]






             