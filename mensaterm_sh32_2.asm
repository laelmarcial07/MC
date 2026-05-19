* Programa MENSATERM_SH32
* Ejecutable en RAM del MCU MC9S08SH32
* Despliega repetitivamente en el emulador
* de terminal el mensaje:

* Hola alumnos desde el MCU MC9S08SH32.
* Habilitado como dispositivo CHIPBAS8SH.

* Se usa la subrutina de librería rutenvmen,
* incluída con una directiva include

* Se usa la librería txsci_rxsci que contiene
* las subrutinas txsci y rxsci
 

* Por: Antonio Salvá Calleja
* Fecha: abril 22,2016

**** Equ's del sci1 *******
scibdh equ $38
scibdl equ $39
scic2  equ $3b
scis1  equ $3c
scid   equ $3f

********************************



              org $0100

; Inicializa puerto serie
              ldhx #$0082  ;BR=130 para 
              sthx scibdh  ;9600 bps, @Fbus=20 MHz
              mov #$0c,scic2  ;habilita tx y rx
;.........................................
              
ciclot:        bsr rxsci
               ldhx #textmens
               jsr rutenvmen
               bra ciclot

***********************************************

textmens:      fcc "Hola alumnos desde el MCU MC9S08SH32."
               db $0d
               fcc "Habilitado como dispositivo CHIPBAS8SH."
               db $0d,$0d,$04

$include "c:\Libs_aux_chipbas8\rutenvmen.asm"  ;Ojo,aquí hay que poner la ruta donde
;                                                                     esté el archivo en la computadora
;                                                                     a donde se trabaje.



$include "c:\Libs_aux_chipbas8\txsci_rxsci.asm"  ;Ojo,aquí hay que poner la ruta donde
;                                                                     esté el archivo en la computadora
;                                                                     a donde se trabaje.




