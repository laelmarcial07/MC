**** Programa MENS16x2SH32_I2C ***
*** Al ejecutarse despliega en el renglón 1 del LCD
*** un texto rotatorio colocado a partir de la etiqueta inimens
*** El programa corre en FLASH
*** Este programa se ejecuta en forma autónoma y se carga a partir
*** de la dirección $8000

             org $8000 
		 lda #$21
		 sta $1802 ;Se deshabilita COP
             
		jsr init_icc
            jsr inilcd 


inicio:      ldhx #inimens 
otraven:     lda #$80
             jsr copiadis
             jsr ret200ms
             jsr ret200ms
*             jsr ret200ms
*             jsr ret200ms
 

            
 
             aix #$01  ;h:x <-- h:x +1
             cphx #finmens
             bne otraven
             bra inicio

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

ret200ms:    psha
             lda #$0a
otroret20ms: jsr ret20ms
             deca
             bne otroret20ms
             pula
             rts



$include "c:\Libs_aux_chipbas8\conop_iics08sh.asm" ;Ojo,aquí hay que poner la ruta donde esté el archivo
;                                                      en la computadora donde se trabaje

$include "c:\Libs_aux_chipbas8\iic-lcd_pcf8574.asm" ;Ojo,aquí hay que poner la ruta donde esté el archivo
;                                                      en la computadora donde se trabaje



*                  1234567890123456
inimens:      fcc "                "
              fcc "Este es un demo de un mensaje rotatorio, mostrado "
etiq:         fcc "en un LCD de 16x2 conectado a la interfaz para desplegado "
              fcc "de la tarjeta MINICON_08SH32, basada en el MCU MC9S08SH32. "
              fcc "Se usa el BIOS para el LCD contenido en el archivo "
              fcc "mdam8a05.asm, que contempla los caracteres: 'á','é','í','ó' "
              fcc "'ú','ü','ñ' y 'Ñ', propios de la lengua española. "
              fcc "El programa asociado fue escrito el 27 de febrero de 2019."
finmens:      fcc "                "


		  org $d7fe
		  dw  $8000
		             

