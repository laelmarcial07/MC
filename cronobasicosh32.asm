
** Este programa actualiza cada 10 mS a cuatro figuras de tiempo,
** HORAS:MINUTOS:SEGUNDOS:CENTÉSIMAS

** Para esto,se configura el temporizador uno (TPM1),
** de modo que se genere una interrupción periódica cada 10 mS.

** En la rutina de servicio se actualizan las cuatro figuras de tiempo,
** que son contadores validados en sendas direcciones de RAM de la página cero
** de la memoria del MCU MC9S08SH2, habilitado como dispositivo CHIPBAS8SH.


conthor   equ $a0 
contmin   equ $a1
contseg   equ $a2
cont100   equ $a3
tpm1sc    equ $20
tpm1modh  equ $23 
modc      equ $61a7 


                    org $8000

          ldhx #modc
          sthx tpm1modh
          mov #$4b,tpm1sc ;toie<--1,clksb:clksa <--01, pe=8,tovf=10 ms.
          clr conthor
          clr contmin
          clr contseg
          clr cont100

          
          cli

lazo:     bra lazo

   
sertof:   lda tpm1sc
          bclr 7,tpm1sc ;tof <-- 0

          inc cont100
          lda cont100
          cmp #$64
          bne salir
          clr cont100
          inc contseg
          lda contseg
          cmp #$3C
          bne salir
          clr contseg
          inc contmin
          lda contmin
          cmp #$3C
          bne salir
          clr contmin
          inc conthor
          lda conthor
          cmp #$18
          bne salir
          clr conthor
salir:    rti

           org $d7e8  ;Colocación del vector de interrupción
           dw sertof  ;propio del evento de overflow del temporizador 1
