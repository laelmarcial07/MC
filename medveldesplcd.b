' Programa MEDVELDESPLCD en MINIBAS,compilable con MINIBAS8A.
' Ejecutable en un MCU MC9S08SH32 habilitado 
' como dispositivo CHIPBAS8SH.

' Mide la velocidad de un movil que pasa entre dos sensores 
' de paso, separados por una distancia de cien metros.
' Se usa la instancia de interrupción por overflow del contador
' del temporizador uno.

' Se supone que los sensores generan un pulso verificado en bajo,
' al detectarse el paso del movil.
' El primer sensor estaría conectado al bit pta1 del puerto A.
' El segundo sensor estaría conectado al bit pta0 del puerto A.

' Se usa un LCD de 16x2 para indicar al usuario:
' 1 Estado de espera por el paso del movil por el sensor 1
' 2 El movil ha pasado por el sensor 1 
' 3 Estado de espera por el paso del movil por el sensor 2
' 4 El movil ha pasado por el sensor 2
' 5 Cuando pasa el movil por el sensor 2
' 6 Cuanto fue la velocidad promedio del movil
' 7 Para hacer otra medición,se indica al usuario que
'   oprima el botón cuyos electrodos están conectados uno con tierra y el otro
'   con el bit Pta6.



' Escrito por: Antonio Salvá Calleja
' Fecha: Abril/17/2023


defvarbptr tpm1sc   &h20
defvarbptr tpm1modh &h23
defvarbptr tpm1modl &h24
defvarbptr ptad     &h0
defvarbptr ptape    &h1840



              iniens
tpm1sc@ equ $20
ptad@   equ $00
 '             jsr lee#car ' Esto equivale a un getchar(); de C
              finens

              gosub init_icc
              gosub inilcd
 

'              input"Dar distancia entre sensores en metros-->",dentse
              dentse = 100.              
              
              ptape=&h43 'Pullups en bits 6,1 y 0 del puerto A
              tpm1modh=&h4e
              tpm1modl=&h1f 'modulo de cuenta=19999,para que Tovf=1 ms,con pe=1.

              tpm1sc=&h8 'toie<--0,clksb:clksa<--01, pe=1.
              
              iniens
              cli
              finens
  
              while 1

              contms%=0 'Inicializa contador de milisegundos 

              ren% = 1
              col% = 1
'                  1234567890123456
              num$ = " Espera paso S1 "
              gosub despstr_i2clcd 
 

              iniens
espsens1:     brset 1,ptad@,espsens1 
              bset 6,tpm1sc@  'toie<--1 
              finens 
 '                    1234567890123456              
              num$ = " Movil pasó S1  "
              gosub despstr_i2clcd  

             

   
              iniens
espsens2:     brset 0,ptad@,espsens2
              bclr 6,tpm1sc@  'toie<--0 
              finens

 '                    1234567890123456              
              num$ = " Movil pasó S2  "
              gosub despstr_i2clcd 


                iniens
                ldhx #$07d0 'h:x <-- 2000 decimal
                jsr retnms_0 'espera dos segundos
                finens

             

              vprom=3600.*dentse/contms%

'               num$ = "Velocidad"

             num$ = "Vp = " + str$(vprom) 
              
               gosub despstr_i2clcd
              
             num$ = " Km/h"
             col% = 12

                gosub despstr_i2clcd
                       
   
              
              ren% = 2
              col% = 1
              num$ =  "Oprimir botón B"
              gosub despstr_i2clcd

              iniens
espsens3:     brset 6,ptad@,espsens3
              lda #$01
              jsr escom4 
              finens


              
              wend

servovf:
             glip
             
             byaux~=tpm1sc
             tpm1sc=tpm1sc and &h7f 'tof<--0

             contms% = contms% + 1


             relip

             retint

#include "c:\Libs_aux_chipbas8\despstr_i2c-lcd.lib" 


             dataw &hd7e8 servovf ' Colocación de vector de usuario 
                                  ' asociado con la instancia de interrupción
                                  ' de overflow del temporizador 1

      


  


   

   



