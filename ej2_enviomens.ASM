
**** Equ's del sci *******
scibdh equ $38
scibdl equ $39
scic2  equ $3b
scis1  equ $3c
scid   equ $3f  

********************************

** Al ejecutarse este programa,cada vez que se oprime una tecla en la terminal,
** se despliega en ésta el mensaje:

** Hola alumnos etusiastas de los microcontroladores.
** Se les saluda desde el MCU MC9S08SH32 habilitado como"
** dispositivo CHIPBAS8SH.
** Se usan subrutinas de biblioteca contenidas en los archivos rutenvmen.asm y txsci_rxsci.asm

** Este programa se diseñó el 5/marzo/2024, por Antonio Salvá Calleja



           org $0100
       
otravez:  bsr rxsci
          ldhx #mensaje
          bsr rutenvmen
          bra otravez 
  

$include "c:\Libs_aux_chipbas8\rutenvmen.asm"
$include "c:\Libs_aux_chipbas8\txsci_rxsci.asm"

mensaje: fcc "Hola alumnos entusiastas de los microcontroladores."
         db $0d,$0a
         fcc "Se les saluda desde el MCU MC9S08SH32 habilitado como"
         db $0d,$0a
         fcc "dispositivo CHIPBAS8SH."
         db $0d,$0a,$0d,$0a,$04


