
// Harbour MiniGUI                 
// (c)2011 -José juca 
// Modulo : Emissor de Nota Fiscal
// 14/12/2014 12:12:12
#include 'minigui.ch'
#Include "F_sistema.ch"
*#INCLUDE "TSBROWSE.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "WINPRINT.CH"
#INCLUDE "TSBROWSE.CH"
#include "FastRepH.CH"
#include "lang_pt.ch"
#include "MiniGui.ch"
#include 'i_textbtn.ch'
#include <minigui.ch>
#define K_ALT_T            iar     276   /*   Alt-T                         */
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLRNBROWN  ( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte 
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 183,255,255 )
#define CLR_NBROWN  RGB( 130, LE	99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define clrNormal  {168,255,190}
#define clrBack    {255,255,128}
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte 
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 183,255,255 )
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define clrNormal   {168,255,190}
#define clrBack     {255,255,128}
#include 'ord.ch'
*#define  CRLF Chr(10)
#define  CRLF Chr(13)+Chr(10)
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 183,255,255 )
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define clrVazio    {255, 0, 0}
#define clrNormal   {255,255,255}
#define clrBack     {255,255,200}
#define _AMARELO       {255, 255, 0}   //amarelo forte
#define CHAR_REMOVE  "/;-:,\.(){}[],',"
static lGridFreeze := .T.
#include "MiniGui.ch"
#include "Fileio.ch"
STATIC PastaxmlEnvio
STATIC PastaxmlRetorno 
STATIC PastaxmlEnviado 
STATIC PastaxmlErro    
STATIC PastaxmlBackup

//-------------------------------------------------
Function CANCELAR_55()
//-------------------------------------------------
Local cQuery
Local aSituacao	    := {}
LOCAL C_CbdNtfNumero:=0
Local cValue := ""
Local teste  := ""
Local teste1  := ""
local datahorarec:=""
local RETORNO:="" 
local sCStat  :="" //107
local IDI_COMP:=""
local sXMotivo:=""  //Servico em Operacao
Local nSubTotal:=0.00, nDesconto:=0.00, nTotal:=0.00, nValorICMS:=0.00, nValorIPI:=0.00


Private nTipo
publ path :=DiskName()+":\"+CurDir()  
PUBL printpdf:=GetDefaultPrinter()    //  Free PrimoPdf como virtual printer para criar arquivos PDF    www.primopdf.com  
PUBL printdpx:=GetDefaultPrinter() 
PUBL printmtx:=GetDefaultPrinter() 
PUBL printfax:=GetDefaultPrinter() 
PUBL printLaser:=GetDefaultPrinter() 
PUBL printPV:=.t.
publ Impostos_Cupom  :=0
publ Impostos_Cupom_1:=0
PUBL printX:="PrimoPDF"

PUBL root:= GetStartUpFolder()+'\' 
PUBL iniFile_c:=.t. 
PUBL dirstart:=root 
PUBL dirdbf:=root 
PUBL dircrm:=root 
PUBL dirpdf:=root
PUBL dirhtml:=root
PUBL dirRemessa:= root

publ cFileDaCANCELA_NFe:="C:\ACBrCANCELA_NFeMonitor\SAICANCELA_NFe.TXT"
PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )	
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))


Xml:=alltrim(zNUMERO+xxANO+"-NFE")
pdf:=alltrim(zNUMERO+xxANO+"-pdf")
tmp  :=alltrim(zNUMERO+xxANO+"-tmp")

          cSubDir := DiskName()+":\"+CurDir()+"\"+"EVENTO_NFE"+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
        *    msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
       *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
      *   msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF
	
    PdfbDir := DiskName()+":\"+CurDir()+"\"+"EVENTO_NFE"+"\"+pdf+"\"
  		 nError := MakeDir( PdfbDir )
            IF nError == 0
      *  msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
         *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
      *  msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF
	
 
 
Reconectar_A()
	  
DEFINE WINDOW CANCELA_NFe;
       at 000,000;
       WIDTH 600 ;
       HEIGHT 250;
       TITLE 'CANCELA_NFe  MODELO 55' ICON "ICONE01";
       MODAL;
       NOSIZE;
	   ON INIT {||CANCELA_NFe.txt_DAV.setfocus}
	   
	   
     ON KEY ESCAPE OF CANCELA_NFe ACTION { ||CANCELA_NFe.RELEASE }
 
 
  DEFINE STATUSBAR of CANCELA_NFe	FONT "MS Sans Serif" SIZE 10
    STATUSITEM "Conectado no IP: "+C_IPSERVIDOR+" "+basesql WIDTH 150 	
          DATE
          CLOCK
          KEYBOARD
	   STATUSITEM ""+AllTrim( NetName() ) WIDTH 150 
	  END STATUSBAR
	

	
		
 @ 05,010  LABEL IMPORTA ;
   WIDTH 140 ;
   HEIGHT 020 ;
   VALUE "Nº DOC."  ;
   FONT "MS Sans Serif" SIZE 8.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 } BOLD 

   
 @ 05,80 textBTN txt_DAV;
		           of CANCELA_NFe;
		           width 80;
                   HEIGHT 20;
                   value '';
				   font 'verdana';
                   size 10;
                   FONTCOLOR { 255, 000, 000 };
                   BACKCOLOR { 255, 255, 255 };   
                   maxlength 40;
		           rightalign
				   
              


    DEFINE LABEL Lbl_Serie
            ROW   05
            COL    180
            WIDTH  60
            HEIGHT 20
            VALUE "Série"
            FONTSIZE 09
            FONTNAME "Arial"
     END LABEL  

     DEFINE TEXTBOX Txt_SERIE
            ROW   05
            COL   220
            WIDTH  15
            HEIGHT 20
            VALUE  ""
            MAXLENGTH 3 	
            UPPERCASE  .T.
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 8
            FONTNAME "Arial"
     END TEXTBOX 
	 
	

 DEFINE BUTTON Button_422
           ROW    150
           COL    10
           WIDTH  120
           HEIGHT 28
           CAPTION "Confirma"
           Action   {||Cancelar55()}
		   
     END BUTTON  
		
DEFINE BUTTON Button_42332
           ROW    150
           COL    250
           WIDTH  120
           HEIGHT 28
           CAPTION "IMPRIMIR EVENTO"
           Action   {|| IMPRIMIR_EVENTO1()}
		   
     END BUTTON  
				


		DEFINE BUTTON Button_4222
           ROW    150
           COL    450
           WIDTH  120
           HEIGHT 28
           CAPTION "Sair"
           Action CANCELA_NFe.RELEASE()         
     END BUTTON  
		
				
				

    end WINDOW
   CANCELA_NFe.Center 
   CANCELA_NFe.Activate
return 
************************

*--------------------------------------------------------------*
STATIC Function Cancelar55()                     
*--------------------------------------------------------------*
local paCode :=(CANCELA_NFe.txt_DAV.value)
local CaCode :=VAL(CANCELA_NFe.txt_DAV.value)
local paserie:=CANCELA_NFe.Txt_SERIE.value
local cUF:=""
Local nCounter:= 0
local ppchave:=""
Local oRow,niCANCELA_NFeventoId
Local i,nChNFe
Local oQuery
Local cQuery
local c_encontro,ninfEventoId
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path     :=DiskName()+":\"+CurDir()
local cCANCELA_NFe, cJus, cENT, cSAI, cTMP 
LOCAL cCmd, cRet  
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt'
LOCAL c_CFileDanfe:=""
PUBL CC_PATH:="" 	
	
	
	
Reconectar_A() 
  oQuery:=oServer:Query( "SELECT CHAVE,MSCANCELAMENTO, nt_retorno ,AUTORIZACAO              FROM nfe20 WHERE CbdNtfNumero = "+AllTrim(pACode)+" and CbdNtfSerie ="+(paserie)+" Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
  	oRow          :=oQuery:GetRow(1)
	pchave        :=alltrim(oRow:fieldGet(1))
    Cbdcheveevento:=alltrim(oRow:fieldGet(2))
        *cXML    :=Memoread(oRow:fieldGet(3))


XNPROT    :=VAL(oRow:fieldGet(4))
If !Empty(oRow:fieldGet(2)) // 
   MsgInfo("Evento Já Registrado" , "ATENÇÃO")
CANCELA_NFe.RELEASE
RETURN(.F.)
EndIf	


HANDLE :=FCREATE (PATH+"\"+pchave+".XML",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(3) )
FWRITE(Handle,RETORNO)
fclose(handle)  
public cXML_NOTA    :=PATH+"\"+pchave+".XML"



If !Empty(pchave) // se nao encontra vale a pesq pro nota fiscal
   else
     MsgInfo("Nao Enntrado: " , "ATENÇÃO")
   Return .f. 
	 CANCELA_NFe.RELEASE   
 EndIf
ERASE "C:\ACBrMonitorPLUS\sai.txt"




cJus :=" Venda nao concretizada"
nEvento:='1'
cCNPJ  :='84712611000152'
*********************************************************************
******************************* USO MONITOR  *********************
********************************************************************

IF   GERA_NFE_NFCE=1
cRet := MON_ENV("NFe.CancelarNFe("+pchave+","+cJus+","+cCNPJ+","+nEvento+")")
MY_WAIT( 1 ) 
    cDestino:="C:\ACBrMonitorplus\sai.txt"	
      lRetStatus:=EsperaResposta(cDestino)
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread("Atenção Favor refazer o Processo   "+cDestino))
       return(.f.)
  endif

MY_WAIT( 1 ) 
  
BEGIN INI FILE cDestino
      ////CANCELAMENTO//////////////////////////////////////////////////////
       GET cCStat          SECTION  "CANCELAMENTO"       ENTRY "CStat"
	   GET cXMotivo        SECTION  "CANCELAMENTO"       ENTRY "XMotivo"
       GET cDhRecbto       SECTION  "CANCELAMENTO"       ENTRY "DhRecbto"
	   GET cNProt          SECTION  "CANCELAMENTO"       ENTRY "NProt"
	   GET ninfEventoId    section  "CANCELAMENTO"       ENTRY "XML"
       GET nChNFe          section  "CANCELAMENTO"       ENTRY "ChNFe"
	   	 /////////////////////////////////////////////////////////////
END INI
public  c_CStat   :=cCStat
public C_XMotivo  :=cXMotivo
public c_DhRecbto :=cDhRecbto
public c_NProt    :=cNProt
PUBLIC  cPesqEVENT:= Substr(ninfEventoId,112,52)
xcCStat:=val(cCStat)
RRCStat:=str(xcCStat)
	
if RRCStat='201' .or. RRCStat='202' .OR. RRCStat= "203" .or. RRCStat="205" .or. RRCStat="206" .or. RRCStat="207" .or. RRCStat="208" .or. RRCStat="209" .OR. RRCStat='210' .or. RRCStat='211' .or. RRCStat='212' .or. RRCStat='213' .or. RRCStat='214' .or. RRCStat='215' .or. RRCStat='216' .or. RRCStat='217' .or. RRCStat='218' .or. RRCStat='219' .or. RRCStat='220' .or. RRCStat='221' .or. RRCStat='222' .or. RRCStat='223' .or. RRCStat='224' .or. RRCStat='225' .or. RRCStat='226' .or. RRCStat='227' .or. RRCStat='229' .or. RRCStat='230' .or. RRCStat='231' .or. RRCStat='232' .or. RRCStat='233' .or. RRCStat='234' .or. RRCStat='235' .or. RRCStat='236' .or. RRCStat='237' .or. RRCStat='238' .or. RRCStat='239' .or. RRCStat='240' .or. RRCStat='241' .or. RRCStat='242' .or. RRCStat='243' .or. RRCStat='244' .or. RRCStat='245' .or. RRCStat='246' .or. RRCStat='247' .or. RRCStat='248' .or. RRCStat='249' .or. RRCStat='250'  .or. RRCStat='251' .or. RRCStat='252' .or. RRCStat='253' .or. RRCStat='254' .or. RRCStat='255' .or. RRCStat='256' .or. RRCStat='257' .or. RRCStat='258' .or. RRCStat='259' .or. RRCStat='260' .or. RRCStat='261' .or. RRCStat='262' .or. RRCStat='263' .or. RRCStat='264' .or. RRCStat='265' .or. RRCStat='266'  .or. RRCStat='267' .or. RRCStat='268' .or. RRCStat='269' .or. RRCStat='270' .or. RRCStat='271' .or. RRCStat= '272' .or. RRCStat='273' .or. RRCStat='274' .or. RRCStat='275' .or. RRCStat='276' .or. RRCStat='277' .or. RRCStat='278' .or. RRCStat='279' .or. RRCStat='280' .or. RRCStat='281' .or. RRCStat='282'  .or. RRCStat='283' .or. RRCStat='284' .or. RRCStat='285' .or. RRCStat='286' .or. RRCStat='287' .or. RRCStat='288' .or. RRCStat='289' .or. RRCStat='290' .or. RRCStat='291' .or. RRCStat='292' .or. RRCStat='293' .or. RRCStat='294' .or. RRCStat='295' .or. RRCStat='296' .or. RRCStat='297' .or. RRCStat='298' .or. RRCStat='299' .or. RRCStat='401' .or. RRCStat='402' .or. RRCStat='403' .or. RRCStat='404' .or. RRCStat='405' .or. RRCStat='406' .or. RRCStat='407' .or. RRCStat='409' .or. RRCStat='410' .or. RRCStat='411' .or. RRCStat='420' .or. RRCStat='450' .or. RRCStat='451' .or. RRCStat='452' .or. RRCStat='453'  .or. RRCStat='454' .or. RRCStat='478' .or. RRCStat='502' .or. RRCStat='503' .or. RRCStat='504' .or. RRCStat='505' .or. RRCStat='506' .or. RRCStat='507' .or. RRCStat='508' .or. RRCStat='509' .or. RRCStat='510' .or. RRCStat='511' .or. RRCStat='512' .or. RRCStat='513' .or. RRCStat='514' .or. RRCStat='515' .or. RRCStat='516' .or. RRCStat='517' .or. RRCStat='518' .or. RRCStat='519' .or. RRCStat='520' .or. RRCStat='521' .or. RRCStat='522' .or. RRCStat='523'  .or. RRCStat='524' .or. RRCStat='525' .or. RRCStat='526' .or. RRCStat='527' .or. RRCStat='528' .or. RRCStat='529' .or. RRCStat='530' .or. RRCStat='531'  .or. RRCStat='532' .or. RRCStat='534' .or. RRCStat='535' .or. RRCStat='536' .or. RRCStat='537' .or. RRCStat='538' .or. RRCStat='540' .or. RRCStat='541' .or. RRCStat='542' .or. RRCStat='544' .or. RRCStat='545' .or. RRCStat='546' .or. RRCStat='547' .or. RRCStat='548' .or. RRCStat='549' .or. RRCStat='550' .or. RRCStat='551' .or. RRCStat='552' .or. RRCStat='553' .or. RRCStat='554' .or. RRCStat='555' .or. RRCStat='556' .or. RRCStat='557' .or. RRCStat='558'  .or. RRCStat='559' .or. RRCStat='560' .or. RRCStat='561' .or. RRCStat='562' .or. RRCStat='564' .or. RRCStat='565' .or. RRCStat='567' .or. RRCStat='568' .or. RRCStat='569' .or. RRCStat='570' .or. RRCStat='571' .or. RRCStat='572' .or. RRCStat='573' .or. RRCStat='574' .or. RRCStat='575' .or. RRCStat='576' .or. RRCStat='577' .or. RRCStat='578' .or. RRCStat='579' .or. RRCStat='580' .or. RRCStat='587' .or. RRCStat='588' .or. RRCStat='589' .or. RRCStat='590' .or. RRCStat='591' .or. RRCStat='592' .or. RRCStat='593' .or. RRCStat='594' .or. RRCStat='595' .or. RRCStat='596' .or. RRCStat='597' .or. RRCStat='598'  .or. RRCStat='599' .or. RRCStat='601' .or. RRCStat='602' .or. RRCStat='603' .or. RRCStat='604' .or. RRCStat='605' .or. RRCStat='606' .or. RRCStat='607' .or. RRCStat='608' .or. RRCStat='609' .or. RRCStat='610' .or. RRCStat='611' .or. RRCStat='612' .or. RRCStat='613' .or. RRCStat='614' .or. RRCStat='615' .or. RRCStat='616' .or. RRCStat='617' .or. RRCStat='618' .or. RRCStat='619' .or. RRCStat='620' .or. RRCStat='621' .or. RRCStat='622' .or. RRCStat='623' .or. RRCStat='624' .or. RRCStat='625' .or. RRCStat='626' .or. RRCStat='627' .or. RRCStat='628' .or. RRCStat='629' .or. RRCStat='630' .or. RRCStat='631'  .or. RRCStat='632' .or. RRCStat='634' .or. RRCStat='635' .or. RRCStat='650' .or. RRCStat='651' .or. RRCStat='653' .or. RRCStat='654' .or. RRCStat='655' .or. RRCStat='656' .or. RRCStat='657' .or. RRCStat='658' .or. RRCStat='660' .or. RRCStat='661' .or. RRCStat='662'  .or. RRCStat='663' .or. RRCStat='678' .or. RRCStat='679' .or. RRCStat='680' .or. RRCStat='681' .or. RRCStat='682' .or. RRCStat='683' .or. RRCStat='684' .or. RRCStat='685' .or. RRCStat='686' .or. RRCStat='687' .or. RRCStat='688' .or. RRCStat='689' .or. RRCStat='690' .or. RRCStat='691' .or. RRCStat='700'  .or. RRCStat='701' .or. RRCStat='702' .or. RRCStat='703' .or. RRCStat='704' .or. RRCStat='705' .or. RRCStat='706' .or. RRCStat='707' .or. RRCStat='708' .or. RRCStat='709' .or. RRCStat='710' .or. RRCStat='711' .or. RRCStat='712' .or. RRCStat='713' .or. RRCStat='714' .or. RRCStat='715' .or. RRCStat='716' .or. RRCStat='717' .or. RRCStat='718' .or. RRCStat='719' .or. RRCStat='720' .or. RRCStat='721' .or. RRCStat='723' .or. RRCStat='724' .or. RRCStat='725' .or. RRCStat='726' .or. RRCStat='727' .or. RRCStat='728' .or. RRCStat='729' .or. RRCStat='730' .or. RRCStat='731' .or. RRCStat='732' .or. RRCStat='733'   .or. RRCStat='734' .or. RRCStat='735' .or. RRCStat='736' .or. RRCStat='737' .or. RRCStat='738' .or. RRCStat='739' .or. RRCStat='740' .or. RRCStat='741' .or. RRCStat='742' .or. RRCStat='743' .or. RRCStat='745' .or. RRCStat='746' .or. RRCStat='748' .or. RRCStat='749' .or. RRCStat='750' .or. RRCStat='751' .or. RRCStat='752' .or. RRCStat='753' .or. RRCStat='754' .or. RRCStat='755' .or. RRCStat='756' .or. RRCStat='757' .or. RRCStat='758' .or. RRCStat='759' .or. RRCStat='760' .or. RRCStat='762' .or. RRCStat='763' .or. RRCStat='764' .or. RRCStat='765' .or. RRCStat='766' .or. RRCStat='767' .or. RRCStat='768'  .or. RRCStat='769' .or. RRCStat='770' .or. RRCStat='771' .or. RRCStat='772' .or. RRCStat='773' .or. RRCStat='774' .or. RRCStat='775' .or. RRCStat='776' .or. RRCStat='777' .or. RRCStat='778' .or. RRCStat='779' .or. RRCStat='780' .or. RRCStat='781' .or. RRCStat='782' .or. RRCStat='783' .or. RRCStat='784' .or. RRCStat='785' .or. RRCStat='786' .or. RRCStat='787' .or. RRCStat='788' .or. RRCStat='789' .or. RRCStat='790' .or. RRCStat='791' .or. RRCStat='792' .or. RRCStat='793' .or. RRCStat='794' .or. RRCStat='795' .or. RRCStat='796' .or. RRCStat='999' 
msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +C_XMotivo)
return(.f.)
endif

xANO     := dtoS(date())
xANO     :=ALLTRIM(SUBSTR(XANO,0,6))
	
	cFileDanfe:="C:\ACBrMonitorPlus\ACBrMonitor.INI"
////RETORNO////
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathEvento"
END INI
public  cCFileDanfe    :=c_CFileDanfe
cRet      := MON_ENV('NFe.GetPathCan()')
MY_WAIT( 1 ) 
bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xpathcancelamento  :=SUBSTR(variavel1,4,54)
xpathcancelamento:=alltrim(xpathcancelamento)
cAuxCCe   :=cPesqEVENT+"-procEventoNFe.XML"
final:=xpathcancelamento+"\"+cAuxCCe
final:=alltrim(final)
ARQEVENTO:=final
ARQEVENTO :=final
PUBLIC C_PATH:=final
cXml        := C_PATH
 BEGIN INI FILE "SERVIDOR.INI"
    SET SECTION "PATHEVENTO" ENTRY "PATH" TO ARQEVENTO
  END INI   

 BEGIN INI FILE "SERVIDOR.INI"
   GET CC_PATH  SECTION "PATHEVENTO" ENTRY "PATH" 
  END INI
PUBLIC C_PATH:=CC_PATH
  cRet := MON_ENV("NFe.ImprimirEventoPDF("+cXml+","+cXML_NOTA+")")
  MY_WAIT( 2  ) 
  cRet := MON_ENV("NFe.ImprimirEvento("+cXml+","+cXML_NOTA+")")

ffxml              :=memoread(C_PATH)
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,ffxml)
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"


if c_CStat="135"
 Msginfo(cXMotivo)
 c_XMotivo:='Evento registrado e vinculado a NF-e'
cQuery := "UPDATE NFE20 SET MSCANCELAMENTO  = '"+c_XMotivo+"',NOTATXT='"+ALLTRIM(ffxml)+"',Cbdcheveevento ='"+alltrim(cPesqEVENT)+"' WHERE CbdNtfNumero = "+(alltrim(paCode))+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+paserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
  Endif
*  msginfo("ok")

///////////////////pega a qtd nos itens 
 oQuery :=oServer:Query( "SELECT CbdcProd,CbdqCOM,CbdcEAN FROM nfeitem WHERE CbdNtfNumero = "+AllTrim(paCode)+" and CbdNtfSerie = "+paserie+"  Order By CbdNtfNumero" )
If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 MsgInfo("Por Favor Selecione o registro deu zebra ") 
Endif

For i := 1 To oQuery:LastRec()
oRow := oQuery:GetRow(i)
ccodigo        :=(oRow:fieldGet(1))
public cqtd     :=oRow:fieldGet(2)
PUBLIC C_CODIGO  :=oRow:fieldGet(1)
XCbdcEAN         :=oRow:fieldGet(3)
public tqtd:=cqtd

XCbdcEAN:=val(XCbdcEAN)
XCbdcEAN:=alltrim(str(XCbdcEAN))
XCbdcEAN:=LPAD(STR(val(XCbdcEAN)),13,[0])
XCbdcEAN:= ' "'+Upper(AllTrim(XCbdcEAN))+'%" '  
   HB_Cria_Log_cancela(xCbdcEAN  ,  +"  Quantidade Cancelada        " ,+  ntrim( cqtd))
  * cas_atualizador_cancelamento("Quantidade Cancelada       "+ntrim(cqtd)) 
///////////////////pega a qtd no estoque
    PQuery := oServer:Query( "Select qtd From produtos WHERE codbar LIKE "+XCbdcEAN+" Order By codbar" )
   If pQuery:NetErr()
  	MsgStop(pQuery:Error())
    MsgInfo("Por Favor Selecione o registroKKK ")
    Return Nil
  Endif
  aRow	          :=pQuery:GetRow(1)
   Xqtd           :=aRow:fieldGet(1)
  HB_Cria_Log_cancela(xCbdcEAN  , +"  Quantidade em Estoque             " ,+  ntrim(Xqtd))
  * cas_atualizador_cancelamento("Quantidade em Estoque     "+ntrim(Xqtd)) 

  RQTD:=Xqtd+cqtd
 pQuery:Destroy()

cQuery := "UPDATE produtos SET QTD = '"+NTRIM(rqtd)+"' WHERE CODBAR LIKE " +(XCbdcEAN)
aQuery:=oServer:Query(cQuery)
If aQuery:NetErr()												
 MsgStop(aQuery:Error())
 MsgInfo("Por Favor Selecione o registro LINHA 302 ") 
 else
 *  cas_atualizador_cancelamento("Quantidade Atualizado no DB    "+ntrim( RQTD)) 
  HB_Cria_Log_cancela(xCbdcEAN        , +"Quantidade Atualizado no DB          " ,+  ntrim( RQTD))
  HB_Cria_Log_cancela((paCode),+" ================================================================== " ,+  "")
  
Endif	
aQuery:Destroy()
oQuery:Skip(1)
Next
oQuery:Destroy() 
ENDIF



*****************************************************
*****************USO CLASS****************
********************************************
ELSE 



xJust :=" Venda nao concretizada"
nEvento:='1'
cCNPJ  :=84712611000152

cCertificado:=''
nSequencia:=1

BEGIN INI FILE "CERTIFICADO.ini"
  GET cCertificado  SECTION "NOME"   ENTRY "NOME"
  	 GET cUF           SECTION "Estado"   ENTRY "cUF"
END INI

oSefaz := SefazClass():New()
oSefaz:cUFTimeZone:=cUF                                                                 
oSefaz:NfeEventoCancela( PChave, nSequencia,  XNPROT, xJust, cCertificado, cAmbiente )


IF oSefaz:cStatus $ "135"
   hb_MemoWrit( "NFE-Cancelamento-Autorizado.xml", oSefaz:cXmlAutorizado )
   hb_MemoWrit(cSubDir+pchave+".xml", oSefaz:cXmlAutorizado )
   hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo )
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   
   
 HB_Cria_Log_nfe(oSefaz:cStatus ,oSefaz:cMotivo)
 
   ELSE
hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo )

   IF .NOT. Empty( oSefaz:cMotivo )
    *  MsgExclamation( "Problema " + oSefaz:cMotivo )
	  msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
return(.f.)
   ELSE
    *  MsgExclamation( "Erro " + oSefaz:cXmlRetorno )
	  msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
return(.f.)
   ENDIF
ENDIF

///////////////////pega a qtd nos itens 
 oQuery :=oServer:Query( "SELECT CbdcProd,CbdqCOM FROM nfeitem WHERE CbdNtfNumero = "+AllTrim(paCode)+"  Order By CbdNtfNumero" )

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
Endif		
oQuery:Skip(1)
Next
oQuery:Destroy()

ENDIF

      cXml  := "NFE-Cancelamento-Autorizado.XML"
      Cchave:= substr(cXml , 0, 48)
      cXml  :=Cchave
	
	Imprimir_Evento_Danfe( cXml, Cchave,cXML_NOTA ) 
 
ffxml:=hb_MemoRead("NFE-Cancelamento-Autorizado.xml")
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,ffxml)
fclose(handle)  

cPesqEVENT:=""
*if c_CStat="135"
c_XMotivo:='Evento registrado e vinculado a NF-e'
cQuery := "UPDATE NFE20 SET MSCANCELAMENTO  = '"+c_XMotivo+"',RETORNO_EVENTO= '"+(AllTrim(ffxml))+"',Cbdcheveevento ='"+alltrim(cPesqEVENT)+"' WHERE CbdNtfNumero = "+(alltrim(paCode))+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+paserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
	else
  *msginfo("ok")
Endif
CANCELA_NFe.RELEASE
Return Nil


//------------------------------------------------------------
Function LerSAI(nTela,cFileDanfe)
 		  Local nCounter:= 0
Local oRow
Local i
local tot :=0
Local oQuery
local iRow 
local aRow

local c_encontro
Local Estru     := {  {'Id'        ,'C', 44,0},;
                      {'ErroJAF'   ,'l', 01,0},;  //
                      {'Ocorrenc'  ,'C', 20,0},;  //
                      {'CNPJ'      ,'C', 14,0},;  //
                      {'cProd'     ,'C', 16,0},;
                      {'xProd'     ,'C', 60,0},;  // Codigo Interno
                      {'cEAN'      ,'C', 16,0},;
                      {'qCom'      ,'N', 13,3},;
                      {'vProd'     ,'N', 13,2},;
                      {'vUnCom'    ,'N', 11,3},;
                      {'vIcms'     ,'N', 11,3},;
                      {'vPis'      ,'N', 11,3},;
                      {'vCofins'   ,'N', 11,3},;
                      {'vIpi'      ,'N', 11,3} }



	 
cFileDanfe := 'C:\ACBrMonitorPLUS\sai.txt'


    cPegaChave := Space(47)
    Linha       := Memoread(cFileDanfe)
    nLinhalidas := 0
    Linhatotal  := Len(Linha)
    cLinhaTxt   := Linha

	
//--------------------------------------------
Linha       := Memoread(cFileDanfe)
nLinhalidas := 0
Linhatotal  := Len(Linha)
cLinhaTxt   := Linha
m_cNF   := PegaDados('infEvento Id' ,Alltrim(Linha)  ,.T.)


	MSGINFO(m_cNF)
	  
	  
	  
	  
	  
//------------------------------------------------------
Function PegaDados(cProc,cLinha,lItem,cTexto2)
Local InicioDoDado :=Iif(cTexto2==Nil,"<"+cProc+">" , "<"+cProc )
Local FinalDoDado := Iif(cTexto2==Nil,"</"+cProc+">",'</'+cTexto2+'>')
Local nPosIni     := At(InicioDoDado,cLinha)
Local nPosFim     := At(FinalDoDado,cLinha)
Local cRet        := '0'
If nPosIni==0 .or. nPosFim==0
   Return cRet
Endif
cRet := Substr(cLinha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
If lItem ==.t.
   nLinhalidas  += nPosFim
Endif
Return  ( cRet)


 
