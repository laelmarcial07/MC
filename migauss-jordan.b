
' Este programa resuelve un sistema de ecuaciones lineales,
' empleando el algoritmo de GAUSS-JORDAN
' Soporta hasta un sistema de 10 ecuaciones con 10 incógnitas.

' Se pide al usuario la matriz aumentada asociada,
' retorna el determinante asociado y la solución en el vector RV(.)

  defint i,j,k,l,m,n

  dim ra(10,11),rv(10) as single

      iniens
      jsr lee#car
      finens


      while 1  

      input "num ecuaciones simultaneas ";nr
       m = nr + 1
       print

      
       det=1.

     
       print "Introducir la matriz aumentada:"
       print

       for i = 0 to nr-1
       for j = 0 to m-1
       print "ra[";i+1;",";j+1;"]=";: input raux:ra(i,j)=raux

       next j
       next i


  for kp=0 to nr-1
   '   print"kp=";kp
     if ra(kp,kp)=0. then
       k=kp
       gosub intercren
         if midetnul=1 then
         print "Matriz singular"
         goto finp
         endif
     endif

     if ra(kp,kp)<>1. then
      gosub normren
     endif
   
       '  print "pasé if ra(kp,kp)<>1...."

        for kpren=0 to nr-1
           if kpren=kp then
           goto nextkpren
           endif
   
          
           pivote=ra(kp,kp)
           rakpt=ra(kpren,kp)
                    
           for jin=0 to nr

           'ratemp=ra(kp,kp)*ra(kpren,jin)-ra(kpren,kp)*ra(kp,jin)
           ra(kpren,jin)=pivote*ra(kpren,jin)-rakpt*ra(kp,jin)

           'ra(kpren,jin)=ratemp
           
           next jin


              
nextkpren:       
        
         next kpren 

    next kp

            

'Imprime matriz aumentada diagonalizada y normalizada,
'además genera vector solución.

       print
       print "La matriz diagonalizada es:"

       print

       for i = 0 to nr-1
       rv(i)=ra(i,nr)
       for j = 0 to m-1
       print "ra[";i+1;",";j+1;"]=";ra(i,j)
       next j
       next i
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       
'Imprime vector solución (rv(.)) y determinante.

       print
       print "VECTOR SOLUCIÓN"
       print
   
       for i=0 to nr-1
       print "rv[";i+1;"]=";rv(i)
       next i
       
       print
       print "DETERMINANTE"
       print
       print "det=";det


       



finp:



     wend

       end

'Subrutina intercren: Intercambia el renglón 'k' donde ra(k,k)=0,con el primer 
' rengpón encontrado,después de éste, con el elpemento ra(lp,k) diferente de cero 
' (lp>k).
' Se entra con 'k' preasignada de acuerdo con el renglón 'k' que se esté
' trabajando.
' Si k=nr-1 la matriz es singular y retorna la variable midetnul=1,
' en otro caso retorna midetnul=0.

intercren:
'             print "entré a intercren"
             midetnul=0
             if k=nr-1 then
             midetnul=1
             goto sale
             endif


             for lp=k+1 to nr-1

                 if ra(lp,k)<>0 then
                 
                 for jkol=0 to nr
'                 print "jkol=";jkol
'                 print "k=";k
'                 print "lp=";lp

                 rkt=ra(k,jkol)
                 rlt=ra(lp,jkol)


                 ra(k,jkol)=rlt
                 ra(lp,jkol)=rkt

                 next jkol 
             goto sale 

             endif



siguiente:    next lp


sale:        return


normren:
              
              for j=0 to nr-1
              if j=kp then nextjota
              ra(kp,j)=ra(kp,j)/ra(kp,kp)
nextjota:    next j

 '             print "rakpkp";ra(kp,kp)
              det=det*ra(kp,kp)


              ra(kp,nr)=ra(kp,nr)/ra(kp,kp)

              ra(kp,kp)=1.

              return




             


















