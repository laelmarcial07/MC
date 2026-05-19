** PROGRAMA EJEMPLO1_INTFLPTA0 **
** Está contenido en el archivo ejemplo1_intflpta0.asm **
** Por: Antonio Salvá Calleja
** 6/abril/2020


** Este programa ejemplifica el uso de la instancia de 
** interrupción 20,denotada Vporta. Véase la tabla 5-2 de la página 64
** del documento MC9S08SH32.PDF.
** El ejemplo presente muestra un caso explícito de la estructura de un
** programa que use interrupciones,usando la instancia de interrupción 20 del MCU.

** Para otras instancias de interrupción el formato es el mismo,lo que cambiaría
** sería la dirección de colocación del vector que corresponda,que se obtiene viendo
** y ajustando lo propio en la tabla 5-2. Además,según sea el caso,habría que hacer 
** lo que haya que hacer en los registros
** de configuración y operación del periférico del MCU asociado con la instancia de
** interrupción con la que se trabaje en un momento dado.

** En general,para la instancia 20,el evento de hardware asociado puede ser la detección de
** (niveles y flancos) o solo flancos en uno o varios de los siguientes 
** bits del puerto A del MCU mc9s08sh32
** pta0,pta1,pta2 y pta3.

** En este ejemplo se configura lo propio,
** de modo que el evento de hardware que detonará 
** el requerimiento de interrupción,sea únicamente la detección de 
** un flanco de bajada en el bit pta0 (pin 26 del chip).
** Como testigo de los accionamientos que se presentarán,se usa el ledpum,
** que está conectado al bit pta7 y testifica la disposición del MCU para 
** recibir comandos desde el software manejador PUMMA_EST. 

** Al ejecutarse este programa,se apreciará un 'parpadeo' del ledpum (testigo del receptor de comandos),
** con la cadencia (apagado un segundo)/(encendido 25 ms).
** Si se produce un flanco de bajada en el pin pta0 se generará el requerimiento de
** interrupción 20,lo que hará que el MCU pase a ejecutar la rutina de servicio denotada
** con la etiqueta servfl,cuya acción será simplemente encender el ledpum durante un segundo,
** después de esto,retorna de la interrupción,lo que hará que ledpum regrese al parpadeo
** con la cadencia (apagado un segundo)/(encendido 25 ms).

ptape             equ $1840
ptasc             equ $1844
ptaps             equ $1845
ptaes             equ $1846 
ptad              equ $00
ptadd             equ $01

                  org $8000
 

****************** BLOQUE 1 ******************
** Para una mejor comprensión del código en este bloque,ver la funcionalidad de los bits de 
** los registros ptasc,ptaps y ptaes en las páginas 84 y 85 del documento MC9S08SH32.PDF


                  bset 7,ptadd ;pta7 es salida 

**      Se habilita el habilitador local 20 (ptaie),sin que se modifiquen los demás 
**      bits del registro ptasc. 
                  lda ptasc
                  ora #$02
                  sta ptasc ;ptaie <-- 1
**...........................................................................
 
                  lda #$01
                  sta ptaps       ;Flanco de bajada en pta0 detona interrupción
;                                  esto porque ptaes de dejará en su default

                  sta ptape       ;pta0 tiene pull-up

**** Se regresa a cero la bandera testigo de la instancia 20 de interrupción,
**** esto se hace aquí,para evitar invocación de la interrupción debido a un flanco
**** que se pudiera haber presentado antes de la ejecución de la instrucción CLI.                   
                  lda ptasc
                  ora #$04
                  sta ptasc       ;ptaack <-- 1, esto hace que: ptaif <-- 0
**..................................................................................
** Nota: el registro ptaes se deja en su valor después de reset ($00).Esto porque se requiere 
** que el evento de hardware, que detonará la interrupción, sea un flanco de bajada.

                  cli             ;Se habilitan globalmente las interrrupciones

**************** FIN DEL BLOQUE 1 ***************

****************** BLOQUE 2 ******************

lazo:             bset 7,ptad ;Se apaga ledpum                 
                  bsr ret1seg ;durante un segundo
                  bclr 7,ptad  ;Se prende ledpum
                  bsr ret25ms  ;durante 25 ms
                  bra lazo

**************** FIN DEL BLOQUE 2 ***************

****************** BLOQUE 3 ******************

servfl:            lda ptasc
                   ora #$04
                   sta ptasc  ;ptaack <-- 1, esto hace que: ptaif <-- 0

                   bclr 7,ptad ;enciende ledpum 
                   bsr ret1seg ;espera un segundo y
                   rti         ;retorna de la interrupción.

**                              Nótese que se usa la instrucción rti y no rts para denotar
**                              el final de la rutina de servicio.

ret25ms: pshh
         pshx
         ldhx #$c34d
vuelta:  nop
         nop
         aix #$FF
         cphx #$0000
         bne vuelta
         nop
         pulx
         pulh
         rts 

ret1seg: psha
         lda #$28
otro25m: bsr ret25ms
         deca
         bne otro25m
         pula
         rts

**************** FIN DEL BLOQUE 3 ***************

****************** BLOQUE 4 ******************
** Coloca vector de interrupción en dircción apropiada para un dispositivo
** CHIPBAS8SH,que es el MCU presente en la tarjeta FACIL_08.
** Nótese que el byte alto de la dirección de colocación indicada en la instancia 20 de la 
** tabla 5-2, de la página 64 del documento MC9S08SH32.PDF,se ha cambiado de ff a d7

                  org $d7d6
                  dw servfl

**************** FIN DEL BLOQUE 4 ***************


  

