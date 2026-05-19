
** Este programa realiza un juego que mide la capacidad de memoria del jugador.
** Una vez que ya se esté ejecutando se debe abrir el emulador de terminal,
** se debe oprimir cualquier tecla.
** Después se despliegan las siguientes indicaciones:
** 1. Oprime varias veces cualquier tecla que no sea <ENTER> 
**    Después de esto oprime <ENTER> 
** 2. El usuario debe oprimir varias veces cualquier tecla que no sea <ENTER>.
**    Por cada opersión aparecerá una letra en pantalla.
** 3. El usuario debe oprimir <Enter>.
** 4. Cinco segundos después se borra la pantalla y se envía el
***   siguiente mensaje:
***   Repite en el teclado los caracteres que se te mostraron 
***  Si el usuario teclea la mizma secuencia de letras previamente mostradas gana,
***  en otro caso pierde.

tpm1sc equ $20 
tpm1cnth equ $21
tpm1cntl equ $22
tpm1modh equ $23
tpm1modl equ $24

**** Equ's del sci1 *******
scibdh equ $38
scibdl equ $39
scic2  equ $3b
scis1  equ $3c
scid   equ $3f

******************************** 

dirtabcars equ $0102 
numdecars  equ $0100

                org $8000



** Se configura que el contador del temporizador 1,cuente de 0 a 25
                mov #$00,tpm1modh
                mov #$19,tpm1modl ;tope de cuenta es 25 decimal
                mov #$0f,tpm1sc 
**................................................................

               jsr rxsci
inicio:        lda #$0c
               jsr txsci ;Limpia pantalla



               ldhx #mensent
               jsr rutenvmen

               lda #$00
               sta numdecars
 
               ldhx #dirtabcars 


lazo1:          jsr rxsci
                cmp #$0d
                beq loquesigue
                jsr gen_numal
                jsr txsci
                sta ,x
                aix #$01
                lda numdecars
                inca
                sta numdecars

                lda #$20
                jsr txsci 
                bra lazo1

loquesigue:     jsr ret1seg
                lda #$0c
                jsr txsci
                ldhx #mens2
                jsr rutenvmen

                ldhx #dirtabcars
lazo2:          jsr rxsci
                jsr txsci
                cmp ,x
                bne perdiste
                lda #$20
                jsr txsci ;Transmite ascii de espacio
                aix #$01
                lda numdecars
                deca
                sta numdecars
                bne lazo2

ganaste:        lda #$0d
                jsr txsci ;salta renglón
                lda #$0d
                jsr txsci ;salta renglón

                ldhx #mensgan
                jsr rutenvmen
                bra preguntafinal

perdiste:       lda #$0d
                jsr txsci ;salta renglón
                lda #$0d
                jsr txsci ;salta renglón

                ldhx #mensper
                jsr rutenvmen

preguntafinal:  ldhx #pregfin
                jsr rutenvmen
                jsr rxsci
                cmp #$53 ;compara con ASCII de 'S'
                bne borradofinal
                jmp inicio

borradofinal:   lda #$0c
                jsr txsci ;Limpia pantalla

softreset:      jmp $fe7d ;Regresa al receptor de comandos
              
              
* Subrutina gen_numal
* Empleando el contador del temporizador 1,
* genera aleatoriamente un entero entre 1 y 6.
* Al retornar:
* a <-- número entero aleatorio comprendido entre 1 y 6  
gen_numal:      pshh
                pshx
*                psha

                ldhx tpm1cnth
                pshx
                pula ;a <-- byte bajo de cuenta,el byte alto es cero
                add #$61

*                pula
                pulx
                pulh
                rts

ret1seg:  psha            ; Guarda el valor actual del acumulador A en la pila
         lda #$28         ; Carga el valor #$28 (40 en decimal) en el acumulador A ; Esto representará 40 ciclos de ret25ms para generar un retardo de 1 segundo
otro25ms: jsr ret25ms     ; Llama a la subrutina ret25ms para un retardo de 25 ms
         deca             ; Decrementa el valor del acumulador A en 1
         bne otro25ms     ; Si el valor de A no es 0, vuelve a llamar ret25ms
         pula             ; Recupera el valor original del acumulador A de la pila
         rts              ; Retorna de la subrutina

ret25ms: pshh             ; Guarda el valor del registro H en la pila
         pshx             ; Guarda el valor del registro X en la pila
         ldhx #$c34d      ; Carga el valor #$C34D en los registros H:X (contador de 25 ms)

vuelta:  nop              ; No hace nada (consume un ciclo de reloj)
         nop              ; No hace nada (consume un ciclo de reloj)
         aix #$ff         ; Decrementa el valor de H:X en 1
         cphx #$0000      ; Compara H:X con 0
         bne vuelta       ; Si H:X no es 0, vuelve al bucle 'vuelta'

         nop              ; No hace nada (consume un ciclo de reloj)
         pulx             ; Recupera el valor original del registro X de la pila
         pulh             ; Recupera el valor original del registro H de la pila
         rts              ; Retorna de la subrutina

mensent:      fcc "Oprime varias veces cualquier tecla que no sea <ENTER> "
              db $0d
              fcc "Después de esto oprime <ENTER> "
              db $0d,$0d,$04

mens2:        fcc "Repite en el teclado los caracteres que se te mostraron "
              db $0d,$0d,$04

mensper:      fcc "  ¡¡¡ PERDISTE !!! "
              db $0d,$0d,$04


mensgan:      fcc "  ¡¡¡ GANASTE !!! "
              db $0d,$0d,$04
            
pregfin:      fcc "Si deseas seguir jugando oprime <S> mayúscula "
              db $0d
              fcc "En otro caso,oprime cualquier otra tecla "
              db $0d,$0d,$04


$include "c:\Libs_aux_chipbas8\rutenvmen.asm"  ;Ojo,aquí hay que poner la ruta donde
;                                                                     esté el archivo en la computadora
;                                                                     a donde se trabaje.



$include "c:\Libs_aux_chipbas8\txsci_rxsci.asm"  ;Ojo,aquí hay que poner la ruta donde
;                                                                     esté el archivo en la computadora
;                                                                     a donde se trabaje.
