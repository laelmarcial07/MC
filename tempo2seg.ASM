 



** Al ejecutarse este programa se reaiza un temporizador one shot, 
** de modo que al conectar a tierra momentaneamente el bit pa0,
** se genera un pulso verificado en alto que dura 2 segundos.

ptad equ $00
ptadd equ $01 
ptape equ $1840
ptcd equ $04
ptcdd equ $05

               org $0100
** CONFIGURACIÓN 
               bclr 0,ptadd ; pa0 es entrada 

               lda ptape ; a <-- ptape completo 
               ora #$01 ; el acumulador a tiene una copia de ptape con bit0 = 1
               sta ptape ; ptape0 <-- 1, sus otros bits no se han cambiado
*                          pa0 tiene pull-up

               jsr ret25ms ;Espera para asegurar conexión del pull-up
               
               bset 0,ptcdd ; pc0 es salida
** FIN DE CONFIGURACIÓN 

checabot:     brset 0,ptad,checabot
              bset 0,ptcd ; pc0 <-- 1
              jsr ret2seg ; espera 2 segundos
              bclr 0,ptcd ; pc0 <-- 0
              bra checabot

ret2seg:   psha ;mete a en el stack
         lda #$50 ; a <-- 80

otroret: jsr ret25ms ;Invocar subrutina ret25ms (jsr = jump to sub routine)
         deca ;a <-- a-1
         cmp #$00 ;compara a con 0
         bne otroret 
         pula ;recuperamos lo que se guardo en stack 
         rts

ret25ms: pshh  ;[2]
         pshx  ;[2]
         ldhx #$c34d    ;Xr es un número de 16 bits ;[3]

vuelta:  nop   ;[1]                     <<
         nop   ;[1]
         aix #$ff ;h:x <-- h:x - 1 ;[2]
         cphx #$0000     ;[3] 
         bne vuelta   ;[3]        >>

         nop     ;[1]
         pulx    ;[3]
         pulh    ;[3]
         rts     ;[5]




              
                

