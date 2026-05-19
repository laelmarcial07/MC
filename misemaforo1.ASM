*Este programa realiza un semáforo de 6 luces , de acuerdo a la tabla descrita en nuestra clase 
est_1 equ $21 
est_2 equ $11
est_3 equ $0c
est_4 equ $0a
ptcd equ $04 
ptcdd equ $05

		org $0100
		mov #$0f,ptcdd ; pc0 a pc5 son salidas

      
		
lazo:       mov #est_1,ptcd
            jsr ret30s 
            mov #est_2,ptcd
            jsr ret5s
            mov #est_3,ptcd
            jsr ret30s
            mov #est_4,ptcd
            jsr ret5s
            bra lazo

ret25ms:        pshh  ;[2]
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

ret5s:  psha
        lda #$c8 ;a se carga con 200 decimal 

otro25m: jsr ret25ms
         deca
         bne otro25m
         pula 
         rts
         
ret30s:  jsr ret5s
         jsr ret5s
         jsr ret5s
         jsr ret5s
         jsr ret5s
         jsr ret5s
         rts



 		