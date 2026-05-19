************** PROGRAMA CRONOSH32BOTB *******************
********** Ejecutable en el MCU MC9S08SH32 **************
******* Habilitado como dispositivo CHIPBAS8SH **********

* Realiza un cronómetro  que despliega en el LCD,
* horas,minutos,segundos y centésimas. Para ello se emplea
* el temporizador 1 configurado de modo que se genera una
* interrupción por overflow del contador cada 10 ms,
* que es una centésima de segundo.

* Se cuenta con botones de: arranque,paro y puesta a cero; 
* estos están asociados con sendos bits del puerto A de la 
* siguienrte forma:
* Botón de arranque está ligado al bit pta0.
* Botón de paro está ligado al bit pta1.
* Botón de puesta a cero está ligado al bit pta6.
* Las cuatro figuras de tiempo se despliegan en el LCD
* a partir del renglón uno y la columna uno.

* Así,las horas estarán a partir de la columna 1,
* los minutos estarán a partir de la columna 4,
* los segundos estarán a partir de la columna 7,
* las centésimas estarán a partir de la columna 10.




* Programa escrito por: Antonio Salvá Calleja.
* Fecha: 1/mayo/2023.

*** Sentencias equ asociadas con datos que usa el programa ***

asciip    equ $2e ;Código ASCII del caracter '.'
ascii2p   equ $3a ;Código ASCII del caracter ':'
conthor   equ $90
contmin   equ $91
contseg   equ $92
cont100   equ $93
tpm1sc    equ $20
tpm1modh  equ $23
ctope     equ $61a7 ;Cuenta tope (CT) 
pardig    equ $95
pardig2   equ $96

ptad  equ $00
ptadd equ $01
ptape equ $1840

*** Sentencias equ para definir bytes de posicionamiento requeridos ***
bypos2p1 equ $82 ;byte comando para posición de caracter ':' entre horas y minutos
bypos2p2 equ $85 ;byte comando para posición de caracter ':' entre minutos y segundos
bypospto equ $88 ;byte comando para posición de caracter '.' entre segundos y centésimas

byposhor equ $80 ;byte comando de posicionamiento para las horas
byposmin equ $83 ;byte comando de posicionamiento para los minutos
byposseg equ $86 ;byte comando de posicionamiento para los segundos
byposcent equ $89 ;byte comando de posicionamiento para las centésimas
***************************************************************

           org $8000

********** BLOQUE 1 ************


          

          lda #$43  ;Pta6,pta1 y pta0
          sta ptape ;tienen 'pull-ups' internos.
         
          jsr init_icc
          jsr inilcd ;Inicializa LCD

** Coloca caracteres fijos ':' y '.' ******          
          lda #bypos2p1
          jsr escom4  ;Posiciona siguiente escritura en renglón 1 columna 3
          lda #ascii2p
          jsr escdat4 ;Coloca caracter ':' en renglón 1 columna 3

          lda #bypos2p2
          jsr escom4  ;Posiciona siguiente escritura en renglón 1 columna 6
          lda #ascii2p
          jsr escdat4 ;Coloca caracter ':' en renglón 1 columna 6

          lda #bypospto
          jsr escom4  ;Posiciona siguiente escritura en renglón 1 columna 9
          lda #asciip 
          jsr escdat4 ;Coloca caracter '.' en renglón 1 columna 9
             

** Configura temporizador 1 para que Tovf = 10 mS sin habilitar interrupciones por overflow *******
          ldhx #ctope
          sthx tpm1modh
          mov #$0b,tpm1sc ;toie<--0,clksb:clksa <--01, pe=8,tovf=10 ms.

*** Inicializa a cero los cuatro contadores en RAM,
*** asociados con las cuatro figuras de tiempo.
*** Horas está en conthor,minutos está en contmin
*** segundos está en contseg y centésimas está en cont100

          clr conthor
          clr contmin
          clr contseg
          clr cont100

          cli  ; habilita interrupciones globalmente

**** Fin del BLOQUE 1 ************

****** BLOQUE 2 *******

lazo:     brclr 0,ptad,arranque 
          brclr 1,ptad,paro
          brclr 6,ptad,ceros
          
desple:   bsr desptemp ;Esta subrutina despliega las figuras de tiempo en el LCD.Se ejecuta en aprox 42.5 mS    
          bra lazo

arranque: bset 6,tpm1sc ;toie <-- 1 
          bra desple

paro:     bclr 6,tpm1sc ;toie <-- 0
          bra desple

ceros:    clr conthor
          clr contmin
          clr contseg
          clr cont100
          bra desple


****** Fin del BLOQUE 2 ******

          

****** BLOQUE 3 ******

**** Subrutina de interrupción **** 
sertof:    lda tpm1sc
           bclr 7,tpm1sc ;tof <-- 0

          inc cont100
          lda cont100
          cmp #$64  ;Si cont100 no ha llegado a 100 sale,
          bne salir ;si cont100 llega a 100,limpia cont100 y pasa a incrementar contseg

          clr cont100
          inc contseg
          lda contseg
          cmp #$3C    ;Si contseg no ha llegado a 60 sale,
          bne salir   ;si contseg llega a 60,limpia contseg y pasa a incrementar contmin

          clr contseg
          inc contmin
          lda contmin
          cmp #$3C    ;Si contmin no ha llegado a 60 sale,
          bne salir   ;si contmin llega a 60,limpia contmin y pasa a incrementar conthor

          clr contmin
          inc conthor
          lda conthor
          cmp #$18    ;Si conthor no ha llegado a 24 sale,
          bne salir   ;si conthor llega a 24,limpia contmin

          clr conthor

salir:    rti

*** Subrutina desptemp ***
*** Despliega en el renglón uno del LCD
*** las cuatro figuras de tiempo.
*** Horas a partir de la columna 1,(comando de posición $80).
*** Minutos a partir de la columna 4,(comando de posición $83).
*** Segundos a partir de la columna 7(comando de posición $86).
*** Centésimas a partir de la columna 10,(comando de posición $89).

desptemp: psha

despcent: lda #byposcent
          jsr escom4  ;posiciona siguiente escritura en columna 10,(posición de las centésimas)
          lda cont100 ;a <-- cuenta de centésimas
          bsr auxdesp ;pasa a generar ascii's de cuenta de centésimas en decimal y a colocar éstos en LCD
         

despseg:  lda #byposseg
          jsr escom4  ;posiciona siguiente escritura en columna 7,(posición de los segundos)
          lda contseg ;a <-- cuenta de segundos
          bsr auxdesp ;pasa a generar ascii's de cuenta de segundos en decimal y a colocar éstos en LCD


despmin:  lda #byposmin
          jsr escom4  ;posiciona siguiente escritura en columna 4,(posición de los minutos)
          lda contmin ;a <-- cuenta de minutos
          bsr auxdesp ;pasa a generar ascii's de cuenta de minutos en decimal y a colocar éstos en LCD


desphor:  lda #byposhor    
          jsr escom4  ;posiciona siguiente escritura en columna 1,(posición de las horas)
          lda conthor ;a <-- cuenta de horas
          bsr auxdesp ;pasa a generar ascii's de cuenta de horas en decimal y a colocar éstos en LCD


          pula
          rts


auxdesp:  bsr con_a  ;pasa a generar ascii's en decimal asociados con la figura de tiempo presente
          lda pardig
          jsr escdat4 ;coloca en LCD ascii de dígito izquierdo en decimal
          lda pardig2
          jsr escdat4 ;coloca en LCD ascii de dígito derecho en decimal

          rts

* Subrutina con_a
* Convierte un entero positivo menor que 100
* a su representación en decimal en
* caracteres ascii.
* Antes de invocar:
* a <-- N < 100
* Al retornar:
* pardig  <-- ascii de dígito izquierdo en decimal (decenas)
* pardig2 <-- ascii de dígito derecho en decimal (unidades)
* Se sugiere ver la funcionalidad de la instrucción 'div' en el manual del MCU.

con_a:    pshh
          pshx
          psha
                 
          clrh     ;h:a <-- N, dividendo para la instrucción div
          ldx #$0a ;x <-- divisor = 10 para la instrucción div

          div ;divide N entre 10,a <-- cociente = valor de las decenas en decimal,
;              h <-- residuo = valor de las unidades en decimal, 
              

          add #$30 ; a <-- código ascii de las decenas en decimal
          sta pardig ;pardig <-- código ascii de las decenas en decimal

          pshh
          pula     ;a <-- residuo = valor de las unidades en decimal  
          add #$30 ;a <-- código ascii de las unidades en decimal
          sta pardig2 ;pardig2 <-- código ascii de las unidades en decimal 

          pula
          pulx
          pulh
          rts

$include "c:\cals_2021-2\Libs_aux_chipbas8\conop_iics08sh.asm" ;Ojo,aquí hay que poner la ruta donde esté el archivo
;                                                      en la computadora donde se trabaje

$include "c:\cals_2021-2\Libs_aux_chipbas8\iic-lcd_pcf8574.asm" ;Ojo,aquí hay que poner la ruta donde esté el archivo
;                                                      en la computadora donde se trabaje

****** Fin del BLOQUE 3 ******

****** BLOQUE 4 ******


          org $d7e8  ;Colocación del vector de interrupción
          dw sertof  ;propio del evento de overflow del temporizador 1

          


****** Fin del BLOQUE 4 ******


         


