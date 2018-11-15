LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
Public cEnvio_XML:=.t.
*public nnfe:="NFE"+NTRIM(chave)
public impressora:=1
cTXT:=PATH+"\NFCE.TXT"


////////////////////////CRIAR NOTA NFE///////////////////////
*PORTAC()


dt_server:=date()
hora_server:=time()
unNFe:=NFCE->NUM_SEQ 
nuNFe:=NFCE->NUM_SEQ 
public nnfe:="NFE"+NTRIM(unNFe)
ERASE "C:\ACBrMonitorPLUS\sai.txt"



**-------------------------------------
//*** VERIFICA SE TEM INTERNET 
**-------------------------------------

 lRetorno_Internet:=IsInternet()
  if lRetorno_Internet==.f.
    xJust:="Sem acesso a Internet" 
     Ret_Status_Servico:=.f.
    else
end                 


   
if Ret_Status_Servico==.f.
    BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
     SET SECTION "Identificacao"  ENTRY "dhCont"  TO dtoc(dt_server)+" "+hora_server ///contingencia para NFCe
     SET SECTION "Identificacao"  ENTRY "xJust"  TO xJust ///contingencia para NFCe
   END INI

    MY_WAIT( 2 ) 
    BEGIN INI FILE "C:\ACBrMonitorPLUS\ACBrMonitor.INI"
      SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '1'
    END INI
     ProcedureLerINI()
     cContingencia:=.t.

mCbdtpEmis:="1"  ///contingencia para NFCe
NFe_EMISSAO(mCbdtpEmis)

end       




******************************************************
* Check to see if you can connect to a Internet
******************************************************
 
Function IsInternet()
local oSock, lRet := .f.
local cServer  := "www.google.com"
local nPort    := 80
local aAddress

oSock := TSocket():New()

if oSock:Connect( cServer, nPort )
 lRet := .t.
 oSock:Close()
endif

Return lRet
 
  Function ProcedureLerINI()         
            LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
                IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                   MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
                   Return
               ENDIF 
                FWRITE(nHandle,'NFe.LerIni' )
                FCLOSE(nHandle)

     RETURN
	 
	 
         
