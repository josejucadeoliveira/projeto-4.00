#INCLUDE "MINIGUI.CH"
Procedure Check_nfce_B_ACBR( ) 

IF ISWINDOWDEFINED(Tela_Check_nfce_A)
  *  maximize WINDOW Tela_Check_nfce_A 
    RESTORE WINDOW Tela_Check_nfce_A
ELSE


Define WINDOW Tela_Check_nfce_A ;
     AT 10, 100 ;
     WIDTH 850;
     HEIGHT 640;
     TITLE "Reenviar NFCE PELO ACBR" ;
     icon cPathImagem+'jumbo1.ico';
     MODAL;   
     NOSIZE;
	 BACKCOLOR {255,255,191};
	 ON INIT {||Reconectar_A(),Check_nfce_CC_acbr_B() }
	   
      

   @ 10, 010  FRAME oGrp22 ;
   CAPTION "Nfce em contigencia pelo acbr  "  ;
   WIDTH 820;
   HEIGHT 550 ;
   FONT "MS Sans Serif" SIZE 14.00 ;
   FONTCOLOR { 255, 255, 000 };
 
    
	 
  @40,50 LISTBOX ListBox_1;
  WIDTH 750;
  HEIGHT 500
 
            ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela
					  
END WINDOW
ACTIVATE WINDOW Tela_Check_nfce_A
endif
Return NIL

******************************************
*------------------------------------------*
***********************************************


proc cas_addi(cchave)
local nn := Tela_Check_nfce_A.ListBox_1.ItemCount + 1
*Tela_Check_nfce_A.ListBox_1.AddItem( cchave +    "N"+alltrim(str( nn )) )
 Tela_Check_nfce_A.ListBox_1.AddItem( cchave )
Tela_Check_nfce_A.ListBox_1.value := nn
return
*---------------------------------------------*
static function ntrim( nValue )
*-------------------------------------------------------------*
return alltrim(str(nValue))


*--------------------------------------------------------------*
Function Check_nfce_CC_acbr_B()
*-----------------------------------------------------------*
local aArqGet, x
Local nCounter:= 0
local ppchave:=""
Local oRow,ninfEventoId
Local i
Local oQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()
LOCAL cChNFe :=""
local anomes:=""
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt'
ERASE "C:\ACBrMonitorPLUS\sai.txt"
vdata:=dtos(date())
vdata1:=dtos(date())

cSearch:= ' "'+Upper(AllTrim(""))+'%" '   
tQuery := oServer:Query( "SELECT CHAVE,nt_retorno,NOTATXT,CbdNtfNumero,CbdNtfSerie FROM `NFCE` WHERE (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" and autorizacao=''  ) Order By CbddEmi" )
If tQuery:NetErr()
    MsgInfo("Nao foi encontrado nada")
    Return Nil
  Endif
For i := 1 To tQuery:LastRec()
  oRow       :=tQuery:GetRow(i)
xchave       :=ALLTRIM(oRow:FieldGet(1))
pnumero      :=ntrim(oRow:FieldGet(4))
pserie       :=alltrim(oRow:FieldGet(5))

HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)  
Destinotxt :=PATH+"\NFCE.TXT"
  MY_WAIT( 1 )  

/////////////////criando///////////////////////////	
cRet       := MON_ENV("NFe.CriarNFe("+Destinotxt+","+""+")")  
     MY_WAIT( 1 ) 
   
   vNFE      := substr(xchave, 26, 09)
cSerie      :=val(SUBSTR(xChave,23,3))
nnfe        :="NFE"+ALLTRIM(vNFE)


//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
  MY_WAIT( 1 ) 
       lRetStatus:=EsperaResposta(cDestino)
          if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
       *  MSGINFO(memoread(cDestino))
           cEnvio_XML:=.f.
        else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI
end
end
public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO              :=c_cNProt
MY_WAIT( 1 ) 



*****************************************************************************
IF  c_CStat == "613" 
cNovaChave:=substr(cXMotivo,91,44)
//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(cNovaChave)+")")
MY_WAIT( 2 ) 
cas_addi(pnumero   +"   "+ xchave  +"   " +c_CStat )
       lRetStatus:=EsperaResposta(cDestino)
          if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread(cDestino))
           cEnvio_XML:=.f.
        else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI
end
END
public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO              :=c_cNProt

cas_addi(pnumero   +"   "+ xchave  +"   " +cXMotivo )
 cQuery := "UPDATE NFCE SET CHAVE='"+cNovaChave+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
      cas_addi(pnumero   +"   "+ "Xml gravado no BD   ok       ")
 Endif
xchave:= cNovaChave

ENDIF
 
//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
  MY_WAIT( 1 ) 
       lRetStatus:=EsperaResposta(cDestino)
          if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
       *  MSGINFO(memoread(cDestino))
           cEnvio_XML:=.f.
        else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI
end
end
public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO              :=c_cNProt
MY_WAIT( 1 ) 

 
if  c_CStat == "100"
fxml:="C:\ACBrMonitorPLUS\"+xchave+"-nfe.xml"
ffxml    :=memoread(fxml)
cXml     :=Memoread(fxml)
 cQuery := "UPDATE NFCE SET chave='"+xchave+"' , AUTORIZACAO='"+auto+"' ,nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
   cas_addi(pnumero   +"   "+ "Xml gravado no BD   ok       ")
   Endif
endif
cas_addi(pnumero   +"   "+ xchave  +"   " +cXMotivo )

//////////////////enviar/////////////////////////
IF  c_CStat == "217"
//////////////////enviar/////////////////////////
cTexto      :="C:\ACBrMonitorPLUS"+"\"+xchave+"-nfe.XML" 
***************************************************************
 cRet       := MON_ENV("NFe.EnviarNFe("+cTexto+",1,0,0,1)") 
************************************************************** 
vNFE         := substr(xchave, 26, 09)
cSerie      :=val(SUBSTR(xChave,23,3))
vNFE:=VAL(vNFE)
nnfe        :="NFE"+NTRIM(vNFE)

MY_WAIT( 2 )
      cDestino:="C:\ACBrMonitorplus\sai.txt"	
       lRetStatus:=EsperaResposta(cDestino)
      BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET cXMotivo       SECTION  "RETORNO"       ENTRY "XMotivo"
       GET cNProt          SECTION  nnfe           ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
 END INI
 ccCStat :=cCStat
 RR_CStat:=cCStat
CNPROT    :=cNProt
AUTO      :=CNPROT
 public  c_CStat   :=cCStat

 
cas_addi(pnumero   +"   "+ xchave  +"   " +c_CStat )
if  c_CStat='297' .OR. c_CStat='866' .OR. c_CStat='865'.or. c_CStat='704'.or. c_CStat='526'.or. c_CStat='778'.or. c_CStat='767'.or. c_CStat='537'.or. c_CStat='610'.or. c_CStat='869'.or. c_CStat='225'
***************************************************************************
xSEQ_TEF := strzero(year(date() ),4)
nAno:=SUBSTR(xSEQ_TEF,3,2)
ccnpj:='84712611000152'
cJus :='Erro na sequencia de emissao'
nMod :="65"
nSer :=pserie
nIni :=(pnumero)
nFin :=(pnumero)
cRet := MON_ENV("NFE.InutilizarNFe("+ccnpj+","+cJus+","+nAno+","+nMod+","+nSer+","+nIni+","+nFin+")")
MY_WAIT( 1 ) 
BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "INUTILIZACAO"       ENTRY "CStat"
	   get cNProt          section  "INUTILIZACAO"       ENTRY "NProt"
	   get cXMotivo        section  "INUTILIZACAO"       ENTRY "XMotivo"
END INI

public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO:=c_cNProt
cXml:=""
c_XMotivo:=cXMotivo
cas_addi(pnumero   +"   "+ xchave  +"   " +cXMotivo )
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+"Inutilizada"+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro 381 PROPLEMA")
  else
    cas_addi(pnumero   +"   "+ "Xml gravado no BD   ok       ")
Endif 
endif
***************************************************************************

if  c_CStat == "100"
fxml:="C:\ACBrMonitorPLUS\"+xchave+"-nfe.xml"
ffxml    :=memoread(fxml)
cXml     :=Memoread(fxml)
 cQuery := "UPDATE NFCE SET chave='"+xchave+"' , AUTORIZACAO='"+auto+"' ,nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+(NTRIM(vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
   cas_addi(pnumero   +"   "+ "Xml gravado no BD   ok       ")
   Endif
endif  
ENDIF
Next
tQuery:Destroy()
ThisWindow.release 
RETURN





