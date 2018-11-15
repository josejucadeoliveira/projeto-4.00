#include "minigui.ch"

Procedure HB_Cria_Log_nfce(cString,atividade)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [logNfce.TXT])
      cArq:= fcreate(PATHDADOS + [logNfce.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
      *fwrite(cArq, dtoc(date()) + time() +[ chave:] + cString +  atividade + CRLF)
	   fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [ Chave: ] + atividade + CRLF)
 
     * fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [logNfce.TXT], 2 + 64)
      fseek(cArq, -1,2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1,2)
      Endif
	* fwrite(cArq, dtoc(date()) + time() + cString + atividade + CRLF)
      fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [ Chave: ] + atividade + CRLF)
      * fwrite(cArq,[Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario:] + cString + [ Atividade: ] + atividade +outras + CRLF)
     * fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Endif

  
Return (Nil)

#include "minigui.ch"

Procedure HB_Cria_Log_nfe(cString,atividade)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [LogNfe.TXT])
      cArq:= fcreate(PATHDADOS + [LogNfe.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
      *fwrite(cArq, dtoc(date()) + time() +[ chave:] + cString +  atividade + CRLF)
	   fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [ Chave: ] + atividade + CRLF)
 
     * fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [LogNfe.TXT], 2 + 64)
      fseek(cArq, -1,2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1,2)
      Endif
	* fwrite(cArq, dtoc(date()) + time() + cString + atividade + CRLF)
      fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [ Chave: ] + atividade + CRLF)
      * fwrite(cArq,[Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario:] + cString + [ Atividade: ] + atividade +outras + CRLF)
     * fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Endif

  
Return (Nil)



#include "minigui.ch"

Procedure HB_Cria_Log(cString,atividade)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [log.TXT])
      cArq:= fcreate(PATHDADOS + [log.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
      fwrite(cArq, [Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario: ] + cString + [ Atividade: ] + atividade + CRLF)
      fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [log.TXT], 2 + 64)
      fseek(cArq, -1, 2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1, 2)
      Endif
      fwrite(cArq,[Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario:] + cString + [ Atividade: ] + atividade + CRLF)
      fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Endif

   If !File(PATHDADOS + [JUMBONEW_ACESSO.INI])
      Cria_File_Ini(PATHDADOS + [JUMBONEW_ACESSO.INI])
   Else
     BEGIN INI FILE PATHDADOS + [JUMBONEW_ACESSO.INI]
     SET SECTION [Segurança] ENTRY [Data Último Acesso] To DtoC(Date())
     SET SECTION [Segurança] ENTRY [Hora Último Acesso] To Time()
     SET SECTION [Segurança] ENTRY [Usuário]            To strzero(nUser, 8)
      END INI    
   Endif
Return (Nil)





#include "minigui.ch"

Procedure HB_Cria_TXT(cString,atividade)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [FECHA.TXT])
      cArq:= fcreate(PATHDADOS + [FECHA.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
      fwrite(cArq, [DATA]+LIMPA(dtoc(date()))+cString+atividade+CRLF)
    * fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [FECHA.TXT], 2 + 64)
      fseek(cArq, -1, 2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1, 2)
      Endif
  *    fwrite(cArq,[Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario:] + cString + [ Atividade: ] + atividade + CRLF)
      fwrite(cArq, [DATA]+LIMPA(dtoc(date()))+cString+atividade+CRLF)
    *  fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Endif

Return (Nil)


Procedure HB_Cria_Log_nfce_reenvio(cString,atividade,atividade2)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [logNfce_reenvio.TXT])
      cArq:= fcreate(PATHDADOS + [logNfce_reenvio.TXT], 0)
      fwrite(cArq, [log de renvio da nfce] + CRLF)
       fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString +CRLF)
 
     * fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [logNfce_reenvio.TXT], 2 + 64)
      fseek(cArq, -1,2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1,2)
      Endif
     *  fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [ Chave: ] + atividade + [  Status  ] + atividade2 +CRLF)
        fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString +CRLF)
      
	 fclose(cArq)
   Endif
  
Return (Nil)

#include "minigui.ch"

Procedure HB_Cria_Log_venda(cString,atividade,ITENS)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [Logvenda.TXT])
      cArq:= fcreate(PATHDADOS + [Logvenda.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
	  fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS +CRLF)
	 
	      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [Logvenda.TXT], 2 + 64)
      fseek(cArq, -1,2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1,2)
      Endif
	* fwrite(cArq, dtoc(date()) + time() + cString + atividade + CRLF)
      fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS+ CRLF)
	  
      * fwrite(cArq,[Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario:] + cString + [ Atividade: ] + atividade +outras + CRLF)
     * fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Endif
 
Return (Nil)


#include "minigui.ch"

Procedure HB_Cria_Log_baixa(cString,atividade,ITENS)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [Logbaixa.TXT])
      cArq:= fcreate(PATHDADOS + [Logbaixa.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
	  fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS +CRLF)
	      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [Logbaixa.TXT], 2 + 64)
      fseek(cArq, -1,2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1,2)
      Endif
      fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS+ CRLF)
      fclose(cArq)
   Endif
Return (Nil)



#include "minigui.ch"

Procedure HB_Cria_Log_cancela(cString,atividade,ITENS)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
   If !File(PATHDADOS + [log_cancelamento.TXT])
      cArq:= fcreate(PATHDADOS + [log_cancelamento.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
	  fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS +CRLF)
	      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [log_cancelamento.TXT], 2 + 64)
      fseek(cArq, -1,2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1,2)
      Endif
      fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS+ CRLF)
      fclose(cArq)
   Endif
Return (Nil)




#include "minigui.ch"

Procedure Log_vendanfce(cString,atividade,ITENS)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
   If !File(PATHDADOS + [venda_nfce_65.TXT])
      cArq:= fcreate(PATHDADOS + [venda_nfce_65.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
	  fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS +CRLF)
	      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [venda_nfce_65.TXT], 2 + 64)
      fseek(cArq, -1,2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1,2)
      Endif
      fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS+ CRLF)
      fclose(cArq)
   Endif
Return (Nil)




#include "minigui.ch"

Procedure Log_vendanfe_55(cString,atividade,ITENS)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
   If !File(PATHDADOS + [venda_nfe_55.TXT])
      cArq:= fcreate(PATHDADOS + [venda_nfe_55.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
	  fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS +CRLF)
	      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [venda_nfe_55.TXT], 2 + 64)
      fseek(cArq, -1,2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1,2)
      Endif
      fwrite(cArq, dtoc(date()) + [ :  ] + time() + [ No.:] + cString + [  ] + atividade + [  ]+ ITENS+ CRLF)
      fclose(cArq)
   Endif
Return (Nil)


