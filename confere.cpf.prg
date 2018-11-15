FUNCTION cgc()   // Função que confere os dois últimos algarismos do CNPJ
PARAMETER c_gc
LOCAL d_1, d_4, x_x, con_ta, dig_ito, res_to
d_1  := 0
d_4  := 0
x_x  := 1

for con_ta := 1 to len(c_gc) - 2
   if at(subs(c_gc,con_ta,1),"/-.")=0
      d_1 := d_1 + val(substr(c_gc,con_ta,1))*(iif(x_x<5,6,14)-x_x)
      d_4 := d_4 + val(substr(c_gc,con_ta,1))*(iif(x_x<6,7,15)-x_x)
      x_x := x_x + 1
   endif
next

res_to  := d_1-(int(d_1/11)*11)
dig_ito := iif(res_to < 2,0, 11 - res_to)
d_4     := d_4 + 2 * dig_ito
res_to  := d_4 - (int(d_4 / 11)* 11)
dig_ito := val(str(dig_ito,1) + str(iif(res_to < 2, 0, 11 - res_to),1))

if dig_ito <> val(substr(c_gc,len(c_gc)-1,2))
   msgstop("CNPJ não conferiu") 
   return .F.
else
   return .T.
endif

FUNCTION cic()    // função que confere os dois últimos algarismos do número informado
PARAMETER c_ic
LOCAL d_1, d_2, x_x, con_ta, digito, res_to

d_1 := 0
d_2 := 0
x_x := 1

for con_ta := 1 TO len(c_ic) - 2
   if at(subs(c_ic,con_ta,1),"/-.") == 0
      d_1 := d_1 + (11-x_x) * val(substr(c_ic,con_ta,1))
      d_2 := d_2 + (12-x_x) * val(substr(c_ic,con_ta,1))
      x_x := x_x + 1
   endif
next

res_to  := d_1 - (int(d_1/11)*11)
dig_ito := iif(res_to < 2, 0, 11-res_to)
d_2     := d_2 + 2 * dig_ito
res_to  := d_2 - (int(d_2/11) * 11)
dig_ito := val(str(dig_ito,1) + str(iif(res_to < 2, 0, 11 - res_to),1))

if dig_ito <> val(substr(c_ic,len(c_ic)-1,2))
   msgstop("CPF não conferiu") 
   return .F.
else
   return .T.
endif

return nil


/*

   Funcão que cria máscara para CNPJ e CPF e atualiza TextBox

*/
FUNCTION CriaMascara()   
Local i          := 0
Local cCGC        := AllTrim( Novo_Cliente.TxtCGC_CPF.Value )  && Pega dados digitados no TextBox sem nenhum espaço
Local cNewCGC   := ""

*** Entra no contador de 1 até o Tamanho da varivel cCGC

For i := 1    To Len( cCGC )  

   *** Acumula na Variável cNewCGC apenas os Digitos de  0 - 9
   cNewCGC += Iif(  IsDigit( Substr( cCGC , i , 1 ) )  , Substr( cCGC , i , 1 ) , ""  )

Next

*** Se Cliente for pessoa Juridica coloca máscara para CGC
If Novo_Cliente.Pessoa_Juridica.Value

   Novo_Cliente.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 99.999.999/9999-99" ) )

Else
      
   *** Caso contrário, coloca máscara para CPF
   Novo_Cliente.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 999.999.999-99" ) )

EndIf

Return Nil
DEFINE WINDOW Novo_Cliente   ;
      AT 0,0         ;
      WIDTH  460      ;
      HEIGHT 446      ;
      TITLE cTitulo      ;
      MODAL         ;
      NOSIZE                

      DEFINE STATUSBAR      
         STATUSITEM "Manutenção no "+cTitulo
      END STATUSBAR

      @ 0,0 FRAME Dados_01 WIDTH 451 HEIGHT 175  FONT 'ARIAL'  SIZE 9

      @ 20,175 CHECKBOX Pessoa_Juridica ; 
         CAPTION 'Jurídica' ; 
         WIDTH 63 ; 
         HEIGHT 30 ; 
         VALUE lJuridica ; 
         FONT 'ARIAL'  SIZE 9

      @030,250 LABEL Lb_CGC_CPF; 
         VALUE 'CNPJ/CPF'   ; 
         WIDTH 60   ; 
         HEIGHT 30   ; 
         FONT 'ARIAL' SIZE 9         

     
					   
					   
					   
					   if Len(AllTrim(CAMPO)) = 14
   // CNPJ
else
   // CPF
end

FUNCTION conf_CGC_CPF
Local i          := 0
Local cCGC        := AllTrim( Novo_Cliente.TxtCGC_CPF.Value )  && Pega dados digitados no TextBox sem nenhum espaço
Local cNewCGC       := ""

*** Entra no contador de 1 até o Tamanho da variável cCGC

For i := 1    To Len( cCGC )  

   *** Acumula na Variável cNewCGC apenas os Dígitos de  0 - 9
   cNewCGC += Iif(  IsDigit( Substr( cCGC , i , 1 ) )  , Substr( cCGC , i , 1 ) , ""  )

Next

*** Se Cliente for pessoa Jurídica coloca máscara para CGC
If Novo_Cliente.Pessoa_Juridica.Value

   Novo_Cliente.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 99.999.999/9999-99" ) )

Else
      
   *** Caso contrário, coloca máscara para CPF
   Novo_Cliente.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 999.999.999-99" ) )

EndIf

if len(cNewCGC) == 0  // aceita digitação vazia para casos que não se conhece o CNPJ ou o CPF
   return .t.
endif 

if len(cNewCGC) > 0 .and. len(cNewCGC) < 12  // tratamento para CPF
         
   if (! cic(cNewCGC))
      msgstop("C.P.F. inválido ! ")
      return .f.
   endif
   
else

   if (! cic(cNewCGC))
      msgstop("C.N.P.J. inválido ! ")
      return .f.
   endif
   
endif

return nil


