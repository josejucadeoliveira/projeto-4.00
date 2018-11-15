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
#define NTRIM( n ) LTrim( Str( n ) )
//-----------------------------------------------------------------------
Function enviar_pendencia_ACBR()     
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
	   ON INIT {||Reconectar_A(),enviar_pendencia_ACBR_1()};

	   
   @ 50, 010  LABEL oSay4 ;
   WIDTH 400;
   HEIGHT 30 ;
   VALUE "Verificando Contigencia"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   @ 80, 10   LABEL oSay1 ;
   WIDTH 400 ;
   HEIGHT 40 ;
   VALUE ""  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
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
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }




            ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela
					  
END WINDOW
ACTIVATE WINDOW enviar_contigencia
endif
Return NIL



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
#define NTRIM( n ) LTrim( Str( n ) )
*--------------------------------------------------------------*
Function enviar_pendencia1()                     
*--------------------------------------------------------------*
   
Local nCounter:= 0
Local oRow
Local i
local nms
local c_barras
Local oQuery
local t_pago:=0
local mtotal1:=0
local c_encontro
local cCertificado:=''
local cuf:='RO'

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
///////FIM////////

mtotal:=0
mtotalg:=0
mtotalb:=0
tipoemissao:='1'
DE:="T"


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
   oNfe:= hbNfe()
   oNFe:cUFWS := '11' // UF WebService
    oSefaz:cNFCE:='S' 
   oNFe:tpAmb := cAmbiente // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao

 oSefaz:NFeStatusServico( "RO", cCertificado, cAmbiente )
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



if xcStat="107"  

MODIFY CONTROL oSay1 OF enviar_contigencia  Value   ' SERVIÇO OK'

ELSE
 xxmotivo:="Serviço Solicitado não Esta Ativo, ou sem Conecção na Internet"
 *MODIFY CONTROL oSay1 OF enviar_contigencia  Value   ' SEM SERVIÇO '
 HB_Cria_Log_nfce(xcStat,xxmotivo+"  Amb.:"+ambiente)
* ThisWindow.release 
 Return .f.
 ThisWindow.release 
endif

cSearch:= ' "'+Upper(AllTrim("CONTIGENCIA"))+'%" '   
tQuery := oServer:Query( "SELECT CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO FROM `NFCE` WHERE AUTORIZACAO LIKE "+cSearch+" Order By CbdNtfNumero" )
If tQuery:NetErr()
    MsgInfo("Nao foi encontrado nada")
    Return Nil
  Endif
For i := 1 To tQuery:LastRec()
  oRow       :=tQuery:GetRow(i)
XCbdNtfNumero :=oRow:fieldGet(1)
 cChave      :=ALLTRIM(oRow:fieldGet(2))
 Xnt_retorno :=oRow:fieldGet(3)
 XCbdNtfSerie:=oRow:fieldGet(4)
 XAUTORIZACAO:=oRow:fieldGet(5)
***********************************************************
 nnfe:=ntrim(XCbdNtfNumero)
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 	  
	   
 oSefaz: NFeConsultaProtocolo( cChave, cCertificado , cAmbiente )
 hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
  HB_Cria_Log_nfce(ntrim(XCbdNtfNumero),cChave+"  situacao...:"+XAUTORIZACAO)
  MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'CONSULTA SE JA FOI ENVIADA...:' +''+TransForm(XAUTORIZACAO  ,  "@!") 
  MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'CONSULTA '+''+TransForm(cChave  ,  "@!")

 
 cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha),.f. )
 chNFe     := PegaDados('chNFe' ,Alltrim(Linha),.f. )
 nProt     := PegaDados('nProt' ,Alltrim(Linha),.f. )
 HB_Cria_Log_nfce(xcStat,xxmotivo+"  Estatus.:"+oSefaz:cStatus)

MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Protocolo......'+''+TransForm(cChave  ,  "@!")

MY_WAIT(2) 



IF xcStat $ "100" .and. val(nProt) >0
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"' WHERE CbdNtfNumero = "+(NTRIM(XCbdNtfNumero))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(XCbdNtfSerie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'Atualizando no banco de dados '
 MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Retorno....: '+TransForm(nProt ,  "@!")
*  MsgInfo("OK")
 ENDIF 
ENDIF

 
  
HANDLE :=FCREATE (cSubDirTMP+"\"+cChave+"-nfe.XML",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(3) )
ffxml  :=memoread(oRow:FieldGet(3))
FWRITE(Handle,RETORNO)
fclose(handle)  
public cTXT     :=cSubDirTMP+"\"+cChave+"-nfe.XML"

xmlassinado:=cChave+"-nfe.XML"

BEGIN INI FILE "CERTIFICADO.ini"
  GET cCertificado  SECTION "NOME"   ENTRY "NOME"
  GET cUF   SECTION "Estado"   ENTRY "cUF"
END INI

If oSefaz:cStatus $ [217]

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
   HB_Cria_Log_nfce(ntrim(XCbdNtfNumero),cChave+"  Serie.:"+XCbdNtfSerie)
 MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'ESTATUS '+TransForm(oSefaz:cStatus ,  "@!")
 MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'CRIANDO ENVIANDO '+TransForm(xMotivo ,  "@!")
  cFileDanfe:= "cXmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   NPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
   
   
   
IF oSefaz:cStatus $ "100"  .and. val(NPROT) >0   
    hb_MemoWrit( cSubDir+"\"+xmlassinado, oSefaz:cXmlAutorizado )
	 HB_Cria_Log_nfce(ntrim(XCbdNtfNumero),R_XMotivo+"  Protocolo......"+nProt)
	 MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Retorno...: '+TransForm(R_XMotivo ,  "@!")
     MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'ESTATUS '+TransForm(oSefaz:cStatus ,  "@!")
    MY_WAIT( 2 ) 
    ffxml   := Memoread(cSubDir+"\"+xmlassinado)
 
 HB_Cria_Log_nfce(ntrim(XCbdNtfNumero), +" "+cChave+"  nPROT.:"+nProt+"  "+R_XMotivo)
  MY_WAIT( 2 ) 
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"',nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+ntrim(XCbdNtfNumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(XCbdNtfSerie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'Atualizando no banco de dados '
 * MsgInfo("ok")
 Endif
 endif
 endif

 
 
If oSefaz:cStatus $ [613,464]
//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.EnviarNFe("+cTXT+",1,1,0,1)")
///////////////////////////////////////////////////
MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'ENVIANDO XML '
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
MY_WAIT( 2 ) 
if R_CStat=='100'  .or.  R_CStat=='150' .or. R_CStat=='539' 
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"',chave='"+alltrim(c_ChNFe)+"' WHERE CbdNtfNumero = "+ntrim(XCbdNtfNumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(XCbdNtfSerie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'Atualizando no banco de dados '  +c_ChNFe
  
  * MsgInfo("ok")
  Endif
endif
endif
tQuery:Skip(1)
Next
tQuery:Destroy()
ThisWindow.release 
Return Nil




*---------------------------------------------*
function ntrim( nValue )
*-------------------------------------------------------------*
return alltrim(str(nValue))



*---------------------------------------------*
function teste_enviar
*---------------------------------------------*
local cUF :=""
local cCertificado:=''
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
ERASE "C:\ACBrMonitorPLUS\sai.txt"



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


BEGIN INI FILE "CERTIFICADO.ini"
  GET cCertificado  SECTION "NOME"   ENTRY "NOME"
  GET cUF   SECTION "Estado"   ENTRY "cUF"
END INI


*cSearch:= ' "'+Upper(AllTrim("                        "))+'%" '   
*tQuery := oServer:Query( "SELECT CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO FROM `NFCE` WHERE AUTORIZACAO LIKE "+cSearch+" Order By CbdNtfNumero" )
*tQuery := oServer:Query( "SELECT CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO FROM `NFCE` WHERE AUTORIZACAO LIKE "+cSearch+" Order By CbdNtfNumero" )

 vdata:=dtos(date()-1)
 vdata1:=dtos(date())
  
tQuery := oServer:Query( "Select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO From NFCE WHERE CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" Order By CbdNtfNumero" )
If tQuery:NetErr()
    MsgInfo("Nao foi encontrado nada")
    Return Nil
  Endif
For i := 1 To tQuery:LastRec()
  oRow       :=tQuery:GetRow(i)
XCbdNtfNumero :=oRow:fieldGet(1)
 cChave      :=ALLTRIM(oRow:fieldGet(2))
 Xnt_retorno :=oRow:fieldGet(3)
 XCbdNtfSerie:=oRow:fieldGet(4)
 XAUTORIZACAO:=oRow:fieldGet(5)
***********************************************************

 nnfe:=ntrim(XCbdNtfNumero)
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 	  
	   
 oSefaz: NFeConsultaProtocolo( cChave, cCertificado , cAmbiente )
 hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
  HB_Cria_Log_nfce(ntrim(XCbdNtfNumero),cChave+"  situacao...:"+Xnt_retorno)
 
 cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha),.f. )
 chNFe     := PegaDados('chNFe' ,Alltrim(Linha),.f. )
 nProt     := PegaDados('nProt' ,Alltrim(Linha),.f. )
 HB_Cria_Log_nfce(xcStat,xxmotivo+"  Estatus.:"+nProt)
MY_WAIT(2) 


IF xcStat $ "100" .and. val(nProt) >0
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"' WHERE CbdNtfNumero = "+(NTRIM(XCbdNtfNumero))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(XCbdNtfSerie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 *MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'Atualizando no banco de dados '
 *MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Retorno....: '+TransForm(nProt ,  "@!")
*  MsgInfo("OK")
 HB_Cria_Log_nfce(xcStat,xxmotivo+"  Estatus.:"+'Atualizando no banco de dados')
 ENDIF 
ENDIF 
 
 
 
 
 

BEGIN INI FILE "CERTIFICADO.ini"
  GET cCertificado  SECTION "NOME"   ENTRY "NOME"
  GET cUF   SECTION "Estado"   ENTRY "cUF"
END INI

If oSefaz:cStatus $ [217]


HANDLE :=FCREATE (cSubDirTMP+"\"+cChave+"-nfe.XML",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(3) )
ffxml  :=memoread(oRow:FieldGet(3))
FWRITE(Handle,RETORNO)
fclose(handle)  
public cTXT     :=cSubDirTMP+"\"+cChave+"-nfe.XML"

xmlassinado:=cChave+"-nfe.XML"


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
   HB_Cria_Log_nfce(ntrim(XCbdNtfNumero),cChave+"  Serie.:"+XCbdNtfSerie)
 *MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'ESTATUS '+TransForm(oSefaz:cStatus ,  "@!")
 *MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'CRIANDO ENVIANDO '+TransForm(xMotivo ,  "@!")
  cFileDanfe:= "cXmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   NPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
   
   
   
IF oSefaz:cStatus $ "100"  .and. val(NPROT) >0   
    hb_MemoWrit( cSubDir+"\"+xmlassinado, oSefaz:cXmlAutorizado )
	 HB_Cria_Log_nfce(ntrim(XCbdNtfNumero),R_XMotivo+"  Protocolo......"+nProt)
	 MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Retorno...: '+TransForm(R_XMotivo ,  "@!")
     MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'ESTATUS '+TransForm(oSefaz:cStatus ,  "@!")
    MY_WAIT( 2 ) 
    ffxml   := Memoread(cSubDir+"\"+xmlassinado)
 
 HB_Cria_Log_nfce(ntrim(XCbdNtfNumero), +" "+cChave+"  nPROT.:"+nProt+"  "+R_XMotivo)
  MY_WAIT( 2 ) 
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"',nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+ntrim(XCbdNtfNumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(XCbdNtfSerie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 *MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'Atualizando no banco de dados '
 * MsgInfo("ok")
 Endif
 endif
 endif



/*

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+cChave+")")
///////////////////////////////////////////////////
MY_WAIT( 2 ) 


BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI

public  c_CStat   :=cCStat
public c_cChNFe   :=cChNFe
public c_cNProt   :=cNProt
AUTO              :=c_cNProt

*/


/*

IF c_CStat $ "100" .and. val(AUTO) >0
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+(NTRIM(XCbdNtfNumero))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(XCbdNtfSerie)+" "
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 *MODIFY CONTROL oSay1 OF enviar_contigencia  Value   'Atualizando no banco de dados '
 *MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Retorno....: '+TransForm(nProt ,  "@!")
*  MsgInfo("OK")
 ENDIF 
ENDIF
*/

Next
tQuery:Destroy()
*ThisWindow.release 
Return Nil


*--------------------------------------------------------------*
Function enviar_pendencia_ACBR_1()
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
pnumero      :=(oRow:FieldGet(4))
pserie       :=(oRow:FieldGet(5))
HANDLE :=  FCREATE ("C:\ACBrMonitorPLUS\"+xchave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  

HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)  
Destinotxt :=PATH+"\NFCE.TXT"

/////////////////criando///////////////////////////	
cRet       := MON_ENV("NFe.CriarNFe("+Destinotxt+","+""+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 
bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xchave      :=SUBSTR(variavel1,24,44)
vNFE        := substr(xchave, 26, 09)
cSerie      :=val(SUBSTR(xChave,23,3))

MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'CONSULTA '+''+TransForm(xchave  ,  "@!")
vNFE        := substr(xchave, 26, 09)
cSerie      :=val(SUBSTR(xChave,23,3))
nnfe        :="NFE"+ALLTRIM(vNFE)


//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
  MY_WAIT( 1 ) 
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
end
public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO              :=c_cNProt
MY_WAIT( 1 ) 


//////////////////enviar/////////////////////////
IF  c_CStat == "217"
//////////////////enviar/////////////////////////
cTexto      :="C:\ACBrMonitorPLUS"+"\"+xchave+"-nfe.XML" 
***************************************************************
 cRet       := MON_ENV("NFe.EnviarNFe("+cTexto+",1,0,0,1)") 
************************************************************** 
  
MY_WAIT( 1 ) 

    cDestino:="C:\ACBrMonitorplus\sai.txt"	
       lRetStatus:=EsperaResposta(cDestino)
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread("Atenção Favor refazer o Processo   "+cDestino))
       return(.f.)
  endif

  if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread(cDestino))
         cEnvio_XML:=.f.
       else
       BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
        GET cCStat          SECTION  "RETORNO"       ENTRY "CStat"
 END INI
 end
end
	  
public  RR_CStat :=cCStat

//////////////////enviar/////////////////////////
IF  RR_CStat == "704"
//////////////////enviar/////////////////////////
dt_server:=date()
hora_server:=time() 

xJust      :="Sem acesso a Internet OU Portal sem Retorno " 
    BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
     SET SECTION "Identificacao"  ENTRY "dhCont"  TO dtoc(dt_server)+" "+hora_server ///contingencia para NFCe
     SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
  END INI

Destinotxt :=PATH+"\NFCE.TXT"
      
/////////////////criando///////////////////////////	
cRet       := MON_ENV("NFe.CriarNFe("+Destinotxt+","+""+")")
MY_WAIT( 1 )
bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xchave      :=SUBSTR(variavel1,24,44)
vNFE        := substr(xchave, 26, 09)
cSerie      :=val(SUBSTR(cChave,23,3))
nnfe:="NFE"+ALLTRIM(vNFE)
MY_WAIT( 1 ) 

cTexto      :="C:\ACBrMonitorPLUS"+"\"+xchave+"-nfe.XML" 


***************************************************************
 cRet       := MON_ENV("NFe.EnviarNFe("+cTexto+",1,0,0,1)") 
************************************************************** 
MY_WAIT( 2 )
ERASE "C:\ACBrMonitorPLUS\sai.txt"
MY_WAIT( 2 )

MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Retorno 217 '+''+TransForm(xchave  ,  "@!")


//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
MY_WAIT( 2 ) 
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
ENDIF

MY_WAIT( 2 )
ERASE "C:\ACBrMonitorPLUS\sai.txt"
MY_WAIT( 2 )

MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Retorno 217 '+''+TransForm(xchave  ,  "@!")


//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
MY_WAIT( 2 ) 
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
    *   GET cCStat          SECTION  "RETORNO"       ENTRY "CStat"

END INI
end
END
public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO              :=c_cNProt
ENDIF



****************************************************************************
***************************************************************************
xSEQ_TEF := strzero(year(date() ),4)
nAno:=SUBSTR(xSEQ_TEF,3,2)
ccnpj:='84712611000152'
cJus :='Erro na sequencia de emissao'
nMod :="65"
nSer :=pserie
nIni :=ntrim(pnumero)
nFin :=ntrim(pnumero)

IF  c_CStat $ [767,526,225]
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
c_XMotivo:=cXMotivo
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+"Inutilizada"+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro 381 PROPLEMA")
  else
   Endif 
   
 *************repor quantidade estoque
 
///////////////////pega a qtd nos itens 
 oQuery :=oServer:Query( "SELECT CbdcProd,CbdqCOM FROM ITEMNFCE WHERE CbdNtfNumero = "+ntrim(pnumero)+" and CbdNtfSerie = "+pserie+"  Order By CbdNtfNumero" )

If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 MsgInfo("Por Favor Selecione o registro deu zebra ") 
Endif

For i := 1 To oQuery:LastRec()
oRow := oQuery:GetRow(i)
ccodigo        :=(oRow:fieldGet(1))
public cqtd     :=oRow:fieldGet(2)
PUBLIC C_CODIGO  :=oRow:fieldGet(1)
public tqtd:=cqtd
*	MSGINFO(C_CODIGO)
///////////////////pega a qtd no estoque
  pQuery:= oServer:Query( "Select qtd From produtos WHERE CODBAR = " + (Ccodigo))
   If pQuery:NetErr()
  	MsgStop(pQuery:Error())
    MsgInfo("Por Favor Selecione o registroKKK ")
    Return Nil
  Endif
  aRow	          :=pQuery:GetRow(1)
   Xqtd           :=aRow:fieldGet(1)
 RQTD:=Xqtd+cqtd
  
 ///////////////////atualiza a qtd no estoque
cQuery := "UPDATE produtos SET QTD = '"+NTRIM(rqtd)+"' WHERE CODBAR = " +(cCodigo)
aQuery:=oServer:Query(cQuery)
If aQuery:NetErr()												
 MsgStop(aQuery:Error())
 MsgInfo("Por Favor Selecione o registro LINHA 302 ") 
 else
* MsgInfo("ok ") 
Endif		
oQuery:Skip(1)
Next
oQuery:Destroy() 
ENDIF

/*

IF  c_CStat="526"
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
c_XMotivo:=cXMotivo
cQuery := "UPDATE NFCE SET  AUTORIZACAO='"+"Inutilizada"+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro 381 PROPLEMA")
  else
Endif 




ENDIF

IF  c_CStat="225"
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
c_XMotivo:=cXMotivo
cQuery := "UPDATE NFCE SET  AUTORIZACAO='"+"Inutilizada"+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro 381 PROPLEMA")
  else
Endif 
ENDIF
*/



***************************************************************************
*****************************************************************************
IF  c_CStat == "613" 
cNovaChave:=substr(cXMotivo,91,44)
//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(cNovaChave)+")")
MY_WAIT( 2 ) 

MODIFY CONTROL oSay2 OF enviar_contigencia  Value   'Nova chave 613 '+''+TransForm(cNovaChave  ,  "@!")

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
 cQuery := "UPDATE NFCE SET CHAVE='"+cNovaChave+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 Endif
xchave:= cNovaChave
ENDIF

			   
IF c_CStat == "100"
fxml:="C:\ACBrMonitorPLUS\"+xchave+"-nfe.xml"
ffxml    :=memoread(fxml)
cXml     :=Memoread(fxml)
 cQuery := "UPDATE NFCE SET chave='"+xchave+"' , AUTORIZACAO='"+c_cNProt+"' ,nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
   Endif
 ENDIF
 Next
tQuery:Destroy()
enviar_contigencia.release
RETURN





