#include "minigui.ch"
#include "DbStruct.ch"
#INCLUDE "hbsetup.CH"
#include 'i_textbtn.ch'
#INCLUDE "TSBROWSE.CH"
#INCLUDE "INKEY.CH"
#include "minigui.ch"
#Include "F_sistema.ch"
#Include "JUMBOII.ch"
#include "common.ch"
#include "winprint.ch"
#define CLR_VERDE  RGB( 180, 255, 165)
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte 
#define CHAR_REMOVE  "/;-:,\.(){}[] "
//-----------------------------------------------------------------------
Function enviar_contigencia()
//-----------------------------------------------------------------------

IF ISWINDOWDEFINED(enviar_contigencia)
    maximize WINDOW enviar_contigencia 
    RESTORE WINDOW enviar_contigencia
ELSE
  



Define WINDOW enviar_contigencia ;
       AT 150, 400 ;
       WIDTH 450 ;
       HEIGHT 350 ;
       TITLE "Enviar contigencia" ;
       BACKCOLOR { 240, 240, 240 };
	   ON INIT {||Reconectar_A(),F_contigencia()};

	   
   @ 50, 010  LABEL oSay4 ;
   WIDTH 400;
   HEIGHT 30 ;
   VALUE "Verificando Xml em Contigencia"  ;
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   @ 80, 10   LABEL oSay1 ;
   WIDTH 400 ;
   HEIGHT 40 ;
   VALUE ""  ;
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }

   
   @ 150, 10   LABEL oSay2 ;
   WIDTH 431 ;
   HEIGHT 040 ;
   VALUE ""  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 190, 150   LABEL oSay3 ;
   WIDTH 400 ;
   HEIGHT 040 ;
   VALUE "Aguarde"  ;
   FONT "Ms Sans Serif" SIZE 15.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }




            ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela
					  
END WINDOW
ACTIVATE WINDOW enviar_contigencia
endif

Return NIL


Function F_contigencia()

IF GERA_NFE_NFCE=1
F_enviar_contigencia()
else
 F_enviar_contigencia_class()
endif
 


//---------------------------------------------------------
* Autor: JOSE JUCA DE OLIVEIRA
* MINIGUI:Extended/Xharbour
* DATA 07/05/2017
*-----------------------------------------------------------
//-----------------------------------------------------------------------------------------------
Function F_enviar_contigencia()
//-----------------------------------------------------------------------------------------------
local nLinha   := 0
local nPagina  := 1
local mtotal   :=0
LOCAL oprint,dirimp:=GetCurrentFolder()
LOCAL R_Versao  :=""  //SVRS20110322100218
LOCAL R_TpAmb   :="" //1
LOCAL R_VerAplic:="" //SVRS20110322100218
LOCAL R_NRec    :="" //113000263213135
LOCAL R_CStat   :="" //100
LOCAL R_XMotivo :="" //=Autorizado o uso da NF-e
LOCAL R_DigVal  :="" //=Autorizado o uso da NF-e
LOCAL c_ChNFe:=""
LOCAL cNProt:=""
//////[CONSULTA]///////////
local c_Versao  :=""//SVRS20100811185009
local c_TpAmb   :=""//2
local c_VerAplic:=""//SVRS20100811185009
local cCStat   :=""//100
local Cc_XMotivo :=""//Autorizado o uso da NF-e
local c_CUF     :=""//11
LOCAL c_NProt:=""
local c_DhRecbto:=""//29/03/2011 07:47:33
LOCAL sCStat:=""
xCbdtpEmis:="9"
///////FIM///////////////

***********************************************************
MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'VERIFICANDO SERVIÇO AGUARDE'

consulta_protocolo_class()
	
	
	
	//////[VERIFICA SERVIÇOS]///////////
cRet       := MON_ENV("NFE.StatusServico")

cFileDanfe:="C:\ACBrMonitorplus\SAI.TXT"
 lRetStatus:=EsperaResposta(cFileDanfe) 
     if lRetStatus==.t.  ////pego os dados
     end
cFileDanfe := 'C:\ACBrMonitorplus\sai.txt'

  
BEGIN INI FILE cFileDanfe
      ////STATUS////////////////////////////
GET sCStat          SECTION  "STATUS"       ENTRY "CStat" 
  /////////////////////////////////////////////////////////////
END INI
*PUBLIC s_CStat:=val(sCStat)

if sCStat="107"
ELSE
  MsgInfo("Serviço Solicitado não Esta Ativo, ou sem Conecção na Internet")
  Return .f.
endif

MODIFY CONTROL oSay1 OF enviar_contigencia  Value   ' SERVIÇO OK'
	
  path:=alltrim("C:\ACBrMonitorPLUS")
*-------------------------------------------------*
page = 1
F=60
Xtotal=0

CQuery:= "select CbdNtfNumero,CbdvNF,CbddEmi,CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe,chave,MSCANCELAMENTO,nt_retorno,CbdNtfSerie FROM NFCE_CONTIGENCIA"  

	oQuery_Item:=oServer:Query( cQuery )
	If oQuery_Item:NetErr()												
       MsgStop(oQuery_Item:Error())
       Return .f.
	End 
	
REG:=0
For i := 1 To oQuery_Item:LastRec()
  oRow := oQuery_Item:GetRow(i)
  oQuery_Item:Skip(1)
          x_doc        := NTRIM(oRow:fieldGet(1))
          X_valor      := oRow:fieldGet(2)
  	      x_venc       := oRow:fieldGet(3) 
		  x_CHAVE      :=ALLTRIM(oRow:fieldGet(7)) 
        XMSCANCELAMENTO  := oRow:fieldGet(8) 
       paserie           := oRow:fieldGet(10)
  nnfe             :=   "NFE"+((x_doc))
HANDLE :=FCREATE (PATH+"\"+x_CHAVE+".XML",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(9) )
ffxml  :=memoread(oRow:FieldGet(9))
FWRITE(Handle,RETORNO)
fclose(handle)  
public cTXT     :=PATH+"\"+x_CHAVE+".XML"
F=F+4 
*msginfo(cTXT)
MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'CONSULTA SE JA FOI ENVIADA'


///////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+x_CHAVE+")")
///////////////////////////////////////////////////
MY_WAIT( 2 ) 

BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
END INI
AUTO              :=cCStat


MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Retorno autorização             '+TransForm(cNProt  ,  "@!")


MY_WAIT(1) 
if cCStat=='100'  .or.  cCStat=='150'
 	cQuery := "UPDATE NFCE SET AUTORIZACAO='"+cNProt+"' WHERE CbdNtfNumero = "+((x_doc))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(paserie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
	
ELSE
////////////////////////NAO CONSTA VAMOS ENCIAR//////////////////


//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.EnviarNFe("+cTXT+",1,1,0,1)")
///////////////////////////////////////////////////
MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'ENVIANDO XML AGUARDE'


	cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
	lRetStatus:=EsperaResposta(cDestino) 
	    if lRetStatus==.t.
		////RETORNO////
		BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
	   GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
	   GET c_NProt          SECTION  nnfe            ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
	   GET c_DhRecbto       SECTION  "ENVIO"         ENTRY "DhRecbto"   // DADA E HORA 
	   GET c_ChNFe          SECTION  nnfe            ENTRY "ChNFe"      // chave nfe  
	   GET R_DigVal         SECTION  nnfe            ENTRY "DigVal"      
	/////////////////////////////////////////////////////////////
END INI
End


MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'CONSULTA SE JS FOI ENVIADA'+''+TransForm(c_NProt  ,  "@!")

cQuery := "UPDATE NFCE SET AUTORIZACAO='"+c_NProt+"' WHERE CbdNtfNumero = "+((x_doc))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(paserie)+" "

 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
ENDIF
Next
oQuery_Item:Destroy()

   Reconectar_A() 
cQuery:= "DELETE FROM nfCE_CONTIGENCIA "         
   oQuery:=oServer:Query( cQuery )
   If oQuery:NetErr()
    MsgInfo("Por Favor Selecione o registro que deseja alterar")
    Return Nil
   endif
ThisWindow.release 
Return Nil


//---------------------------------------------------------
* Autor: JOSE JUCA DE OLIVEIRA
* MINIGUI:Extended/Xharbour
* DATA 17/09/2017
*-----------------------------------------------------------
//-----------------------------------------------------------------------------------------------
Function F_enviar_contigencia_class()
//-----------------------------------------------------------------------------------------------
local nLinha   := 0
local nPagina  := 1
local mtotal   :=0
LOCAL oprint,dirimp:=GetCurrentFolder()
LOCAL R_Versao  :=""  //SVRS20110322100218
LOCAL R_TpAmb   :="" //1
LOCAL R_VerAplic:="" //SVRS20110322100218
LOCAL R_NRec    :="" //113000263213135
LOCAL R_CStat   :="" //100
LOCAL R_XMotivo :="" //=Autorizado o uso da NF-e
LOCAL R_DigVal  :="" //=Autorizado o uso da NF-e
LOCAL c_ChNFe:=""
LOCAL cNProt:=""
//////[CONSULTA]///////////
local c_Versao  :=""//SVRS20100811185009
local c_TpAmb   :=""//2
local c_VerAplic:=""//SVRS20100811185009
local cCStat   :=""//100
local Cc_XMotivo :=""//Autorizado o uso da NF-e
local c_CUF     :=""//11
LOCAL c_NProt:=""
local c_DhRecbto:=""//29/03/2011 07:47:33
LOCAL sCStat:=""
local path :=DiskName()+":\"+CurDir()
local xCbdtpEmis:="9"
local cCertificado:=''
local cuf:=''
///////FIM///////////////

***********************************************************
MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'VERIFICANDO SERVIÇO AGUARDE'
PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFCe")
pdf   :=alltrim(zNUMERO+xxANO+"-pdfNFCe")
tmp  :=alltrim(zNUMERO+xxANO+"-tmpNFCe")

       cSubDir := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	  cSubDirTMP:= DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+tmp+"\"
  		 nError := MakeDir( cSubDirTMP )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	
  PdfbDir := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+pdf+"\"
  		 nError := MakeDir( PdfbDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF
	
		//////[VERIFICA SERVIÇOS]///////////

 
 
 *******************************************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI
******************************************************************	 

*********Verifica serviço******************
  oSefaz     := SefazClass():New()
cXmlRetorno := oSefaz:NfeStatus()
 hb_MemoWrit( "servico.xml", oSefaz:cXmlRetorno )
 cFileDanfe:= "servico.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha), .f. )

if cambiente='1'
 ambiente:="Produção"
 else
   ambiente:="Homologação"
 endif
 
HB_Cria_Log_nfce(xcStat,xxmotivo+"  Amb.:"+ambiente)
 

if xcStat="107"  
ELSE
  MsgInfo("Serviço Solicitado não Esta Ativo, ou sem Conecção na Internet")
  Return .f.
  ThisWindow.release 
endif

MODIFY CONTROL oSay1 OF enviar_contigencia  Value   ' SERVIÇO OK'
	
*-------------------------------------------------*
page = 1
F=60
Xtotal=0

CQuery:= "select CbdNtfNumero,CbdvNF,CbddEmi,CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe,chave,MSCANCELAMENTO,nt_retorno,CbdNtfSerie FROM NFCE_CONTIGENCIA"  

	oQuery_Item:=oServer:Query( cQuery )
	If oQuery_Item:NetErr()												
       MsgStop(oQuery_Item:Error())
       Return .f.
	End 
	

REG:=0

For i := 1 To oQuery_Item:LastRec()
  oRow := oQuery_Item:GetRow(i)
  oQuery_Item:Skip(1)
          x_doc        := NTRIM(oRow:fieldGet(1))
          X_valor      := oRow:fieldGet(2)
  	      x_venc       := oRow:fieldGet(3) 
		  x_CHAVE      :=ALLTRIM(oRow:fieldGet(7)) 
        XMSCANCELAMENTO  := oRow:fieldGet(8) 
       paserie           := oRow:fieldGet(10)
	  

 oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 	  
	   
 oSefaz:NFeConsultaProtocolo( x_CHAVE, cCertificado , cAmbiente )
 hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
 
 
 cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha),.f. )
 chNFe     := PegaDados('chNFe' ,Alltrim(Linha),.f. )
 nProt     := PegaDados('nProt' ,Alltrim(Linha),.f. )

HB_Cria_Log_nfce(x_doc,x_CHAVE+"  XML RETORNO.:"+Linha)
 MY_WAIT( 1) 
HB_Cria_Log_nfce( x_doc +" "+ x_CHAVE, +"  Consulta...:"+oSefaz:cMotivo)


 
IF xcStat $ "100" 

 HB_Cria_Log_nfce(x_doc,x_CHAVE+"  Protocolo"+nProt)
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"' WHERE CbdNtfNumero = "+((x_doc))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(paserie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
HB_Cria_Log_nfce( x_doc +" "+ x_CHAVE, +"  UPDATE..:"+"ok")

 Endif
cSearch:= ' "'+Upper(AllTrim(x_CHAVE))+'%" '   
oQuery := oServer:Query( "DELETE From nfCE_CONTIGENCIA  WHERE chave LIKE "+cSearch+" Order By CbdNtfNumero" )
If oQuery:NetErr()												
 MsgInfo("error ao selecionar tabela " + oQuery:Error())
else
HB_Cria_Log_nfce( x_doc +" "+ x_CHAVE, +"  DELETE From nfCE_CONTIGENCIA..."+"ok")
Endif


ThisWindow.release 
End

 
	   
nnfe             :=   "NFE"+((x_doc))
HANDLE :=FCREATE (cSubDirTMP+"\"+x_CHAVE+"-nfe.XML",0)// cria o arquivo

RETORNO:=UnMaskBinData( oRow:FieldGet(9) )
ffxml  :=memoread(oRow:FieldGet(9))
FWRITE(Handle,RETORNO)
fclose(handle)  
*public cTXT     :=PATH+"\"+x_CHAVE+".XML"
public cTXT     :=cSubDirTMP+"\"+x_CHAVE+"-nfe.XML"

F=F+4 
xmlassinado:=x_CHAVE+"-nfe.XML"

BEGIN INI FILE "CERTIFICADO.ini"
  GET cCertificado  SECTION "NOME"   ENTRY "NOME"
  GET cUF   SECTION "Estado"   ENTRY "cUF"
END INI

 MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'ENVIANDO XML AGUARDE'
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 
   cXml     :=MEMOREAD(cTXT)
  oSefaz:NFeLoteEnvia( @cXml, '1', cUF, ALLTRIM(cCertificado), cAmbiente )
   hbNFeDaNFe( oSefaz:cXmlAutorizado )
   hb_MemoWrit( "cXmlRetorno.xml", oSefaz:cXmlRetorno )
   hb_MemoWrit( "xmlRecibo.xml", oSefaz:cXmlRecibo )
   hb_MemoWrit(  "xmlprotocolo.xml", oSefaz:cXmlProtocolo )
   cFileDanfe:= "xmlprotocolo.xml"
   Linha      := Memoread(cFileDanfe)
   xMotivo     := PegaDados('xMotivo'   ,Alltrim(Linha),.f. ) 
  MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'ENVIADA.....:'+''+TransForm(x_CHAVE  ,  "@!")

  HB_Cria_Log_nfce(x_doc,x_CHAVE+"  Serie.:"+paserie)

IF oSefaz:cStatus $ "100" 
 cFileDanfe:= "cXmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   NPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'ENVIANDO XML AGUARDE'

hb_MemoWrit( cSubDir+"\"+xmlassinado, oSefaz:cXmlAutorizado )
MY_WAIT( 1 ) 
ffxml   := Memoread(cSubDir+"\"+xmlassinado)
 
 *HB_Cria_Log_nfce(x_doc, +" "+x_CHAVE+"  Serie.:"+paserie)
  HB_Cria_Log_nfce(x_doc, +" "+x_CHAVE+"  nPROT.:"+nProt+"  "+xMotivo)
 MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'ENVIADA.PROTOCOLO...........:'+''+TransForm(nProt  ,  "@!")
 
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"',nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+((x_doc))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(paserie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 MsgInfo("ok")
  Endif
  
    cQuery:= "DELETE FROM nfCE_CONTIGENCIA WHERE chave = " + (x_CHAVE)         
   oQuery:=oServer:Query( cQuery )
 If oQuery:NetErr()
   MsgInfo("Por Favor Selecione o registro que deseja alterar")
   else
   endif

 else 
*msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
 HB_Cria_Log_nfce( x_doc +" "+ x_CHAVE, +"  Erro.:"+oSefaz:cMotivo)
return nil
endif
 Next
oQuery_Item:Destroy()
ThisWindow.release 
Return Nil





//---------------------------------------------------------
* Autor: JOSE JUCA DE OLIVEIRA
* MINIGUI:Extended/Xharbour
* DATA 17/09/2017
*-----------------------------------------------------------
//-----------------------------------------------------------------------------------------------
Function consulta_protocolo_class()
//-----------------------------------------------------------------------------------------------
local nLinha   := 0
local nPagina  := 1
local mtotal   :=0
LOCAL oprint,dirimp:=GetCurrentFolder()
LOCAL R_Versao  :=""  //SVRS20110322100218
LOCAL R_TpAmb   :="" //1
LOCAL R_VerAplic:="" //SVRS20110322100218
LOCAL R_NRec    :="" //113000263213135
LOCAL R_CStat   :="" //100
LOCAL R_XMotivo :="" //=Autorizado o uso da NF-e
LOCAL R_DigVal  :="" //=Autorizado o uso da NF-e
LOCAL c_ChNFe:=""
LOCAL cNProt:=""
//////[CONSULTA]///////////
local c_Versao  :=""//SVRS20100811185009
local c_TpAmb   :=""//2
local c_VerAplic:=""//SVRS20100811185009
local cCStat   :=""//100
local Cc_XMotivo :=""//Autorizado o uso da NF-e
local c_CUF     :=""//11
LOCAL c_NProt:=""
local c_DhRecbto:=""//29/03/2011 07:47:33
LOCAL sCStat:=""
local path :=DiskName()+":\"+CurDir()
local xCbdtpEmis:="9"
local cCertificado:=''
local cuf:=''
///////FIM///////////////

Reconectar_A()


***********************************************************
*MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'VERIFICANDO SERVIÇO AGUARDE'
PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFCe")
pdf   :=alltrim(zNUMERO+xxANO+"-pdfNFCe")
tmp  :=alltrim(zNUMERO+xxANO+"-tmpNFCe")
   cSubDir := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	  cSubDirTMP:= DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+tmp+"\"
  		 nError := MakeDir( cSubDirTMP )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	
  PdfbDir := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+pdf+"\"
  		 nError := MakeDir( PdfbDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF
	
		//////[VERIFICA SERVIÇOS]///////////

 
 
 *******************************************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI
******************************************************************	 

*********Verifica serviço******************
  oSefaz     := SefazClass():New()
cXmlRetorno := oSefaz:NfeStatus()
 hb_MemoWrit( "servico.xml", oSefaz:cXmlRetorno )
 cFileDanfe:= "servico.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha), .f. )

if cambiente='1'
 ambiente:="Produção"
 else
   ambiente:="Homologação"
 endif
 
HB_Cria_Log_nfce(xcStat,xxmotivo+"  Amb.:"+ambiente)
 

if xcStat="107"  
ELSE
 xxmotivo:="Serviço Solicitado não Esta Ativo, ou sem Conecção na Internet"
 MODIFY CONTROL oSay1 OF enviar_contigencia  Value   ' SEM SERVIÇO '
 HB_Cria_Log_nfce(xcStat,xxmotivo+"  Amb.:"+ambiente)
  ThisWindow.release 
 Return .f.
endif

	
*-------------------------------------------------*
page = 1
F=60
Xtotal=0

CQuery:= "select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie FROM NFCE_CONTIGENCIA"  
  
	oQuery_Item:=oServer:Query( cQuery )
	If oQuery_Item:NetErr()												
       MsgStop(oQuery_Item:Error())
       Return .f.
	End 

nCount=0 
For i := 1 To oQuery_Item:LastRec()
  oRow := oQuery_Item:GetRow(i)
  oQuery_Item:Skip(1)
  pACode           :=STR(oRow:fieldGet(1))
  cChave           :=   alltrim(oRow:fieldGet(2))
  paserie          :=    oRow:fieldGet(4)
  nnfe             :=   "NFE"+alltrim((pACode))

 
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 	  
	   
 oSefaz: NFeConsultaProtocolo( cChave, cCertificado , cAmbiente )
 hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
 
 
 cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha),.f. )
 chNFe     := PegaDados('chNFe' ,Alltrim(Linha),.f. )
 nProt     := PegaDados('nProt' ,Alltrim(Linha),.f. )

HB_Cria_Log_nfce(nnfe,cChave+"protocolo"+nProt+"  XML RETORNO.:"+Linha)

MY_WAIT( 2 ) 


IF xcStat $ "100" 

 HB_Cria_Log_nfce(pACode,cCHAVE+"  Protocolo"+nProt)
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"' WHERE CbdNtfNumero = "+((pACode))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(paserie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
* MsgInfo("ok")
 Endif
cSearch:= ' "'+Upper(AllTrim(cCHAVE))+'%" '   
oQuery := oServer:Query( "DELETE From nfCE_CONTIGENCIA  WHERE chave LIKE "+cSearch+" Order By CbdNtfNumero" )
If oQuery:NetErr()												
 MsgInfo("error ao selecionar tabela " + oQuery:Error())
return nil
Endif
End
oQuery_Item:Skip(1)
Next
oQuery_Item:Destroy()
*ThisWindow.release 
Return Nil


