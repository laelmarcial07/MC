
*** Este programa realiza un temporizador mono disparo.
*** Al oprimirse el botón conectado entre pta0 y tierra se 
*** genera un pulso de un segundo verificado en alto en ptc0.

ptad equ $00
ptcd equ $04
ptcdd equ $05
ptape equ $1840


             org $0100

             bset 0,ptcdd ;ptc0 es salida
             lda #$01
             sta ptape ;pta0 tiene pull_up
 
             jsr ret25ms ;Espera 25 mS para garantizar que la resistencia interna de pull-up esté ya conectada.

checbot:     brset 0,ptad,checbot
             bset 0,ptcd ;ptc0 <-- 1
             jsr ret1seg
             bclr 0,ptcd ;ptc0 <-- 0
             bra checbot




**- Subrutina para generar un retardo de 1 segundo **

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
