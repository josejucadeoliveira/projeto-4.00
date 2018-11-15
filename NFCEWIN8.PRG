//--------------------------
** autor := jose´juca de oliveira
** medial:= medial@ps5.com.br
** vilhena/RO
** 69 3321 4575 
** date 11-10-2015
//---------------------------------------------------
#include "minigui.ch"
#include "metrocolor.ch"
#define  CRLF            Chr(13)+Chr(10)
#include "common.ch"
#include "hbclass.ch"
#include "hbwin.ch"
//#include "harupdf.ch"
//#include "hbzebra.ch"
#include "hbcompat.ch"
#define CHAR_REMOVE  "/;-:,\.(){}[] "
#include "Inkey.ch"
#include "winprint.ch"
#define  CR  chr(13)
#define  LF  chr(10)
#define Crlf  CHR(13)+CHR(10)
#ifndef XHARBOUR
#include "hbdyn.ch"
#endif
        
		
#define PROGRAM 'ButtonEx with METRO color background (1)'
#define COPYRIGHT ' (c) 2013 Andrey Verchenko, Russia, Dmitrov. ' + MiniGUIVersion()
STATIC aObjButton := {},  aObjImage := {}, lStatusBar := .T.



REQUEST DBFNTX
REQUEST DBFCDX
REQUEST DBFFPT
REQUEST DBFDBT
//-------------


Function Main()
     LOCAL cResIco, cResPict := NIL, bAction, cTooltip, nWidth, nHeight
     LOCAL nStRow1 := 60, nStRow2 := 188, nStRow3 := 317, nStRow4 := 447
     LOCAL aFontColor := WHITE
     LOCAL c_Servidor_NFE:=c_baseServidor:=c_STATUS:=IMPGRAFICO:=IMP_GRAFICO:=c_BASETEF:=C_IP:=CC_DPL:=Q_MINIMA:=c_baseNFE:=C_COM1:=USAECF:=C_DOC:=c_papelparede:=c_USAECF:=c_GERAL:=c_COM1:=c_ACESSOREMOTO:=c_dados:=c_DOC := c_base:=c_TXT := c_basetmp:= c_VER_ERRO := SPACE(0) 
     LOCAL xmaishora:=picture:=xToken:=xIdToken:=C_HOMOLOGACAO:=C_PATHACBR:=C_cValue:=pictur:=NMONITOR:=C_DESTINO1:=C_DESTINO2:=c_CAIXA:=c_basesql:=cPathImagem:=C_IPSERVIDOR:=C_senha:=C_usuario:=C_IP:=C_COM1:=USAECF:=C_DOC:=c_papelparede:=c_USAECF:=c_GERAL:=c_COM1:=c_ACESSOREMOTO:=c_dados:=c_DOC := c_base :=c_CONECTADO := c_basetmp := SPACE(0)
     Local aPictInfo := {}
     LOCAL ACbdNtfSerie:=0
	 Local cValue := ""
LOCAL mysql := .T.
local aColors
Local P, RET := .T., TFIM, IP, PORTA, RESP
local sENDER   := ''  ,;
       USODLL  := "" ,;
       sSECHORA := 0   ,;
       sRETHORA := ''  ,;
       sSECCOO  := 0   ,;
       sNUMCUPOM:= ''  ,;
       sSECEST  := 0   ,;
       sESTADO  := ''


	 
       	 REQUEST HB_LANG_PT
       	 REQUEST HB_CODEPAGE_PT850
       	 HB_LANGSELECT('PT')
       	 HB_SETCODEPAGE('PT850')

       	 set autoadjust on
       	 set deleted on
       	 set interactiveclose query
       	 set date british
       	 set century on
       	 set epoch to 1980
       	 set browsesync on
       	 set multiple off warning
       	 set navigation extended
       	 set codepage to portuguese
       	 set language to portuguese
         SET MENUSTYLE EXTENDED
	     SET MENUCURSOR FULL
	     SET MENUSEPARATOR SINGLE RIGHTALIGN
	     SET MENUITEM BORDER 3D


		 
	
	
//-----------------------------------------------------------
Cria_File_ini()		
//-------------------------------------------------------------

	
//-------------------------------------------------------------

BEGIN INI FILE "NFCE.INI"
	 GET cValue           SECTION  "Segurança"       ENTRY "Exit"
     GET c_geral          SECTION "Config"           ENTRY "Pastaempresa" 
  	 GET c_dados          SECTION "Pasta_imagens"    ENTRY "pastaimagens"
     GET c_baseServidor   SECTION "Base Servidor"    ENTRY "Base Servidor"
     GET c_base           SECTION "basetabela"       ENTRY "basetabela"
  	 GET c_basetmp        SECTION "basetmp"          ENTRY "basetmp"
 	 GET c_TXT            SECTION "baseTXT"          ENTRY "basetXT"
     GET C_BASETEF        SECTION "BASETEF"          ENTRY "BASETEF" 	 
     GET c_papelparede    SECTION "Pasta_Fundotela"  ENTRY "Papelparede"
	 GET c_CAIXA          SECTION "CAIXA          "  ENTRY "CAIXA"
	 GET C_ACESSOREMOTO   SECTION "ACESSOREMOTO"     ENTRY "ACESSOREMOTO"
 	 get nMONITOR         SECTION "MONITOR"          ENTRY  "MONITOR"
	 GET C_IP             SECTION "IP"               ENTRY "IP"
 	 GET C_PATHACBR       SECTION "PATHACBR"         ENTRY "PATHACBR"
 	 GET USAECF           SECTION "USAECF"           ENTRY "USAECF"
     GET c_Doc            SECTION "cDocumento  "     ENTRY "cDocumento" 
     GET Cc_DPL           SECTION "DPL        "      ENTRY " DPL" 
     GET Q_MINIMA         SECTION "QMINIMA"          ENTRY "QMINIMA"
     GET C_STATUS         SECTION "STATUS"           ENTRY "STATUS"
     GET C_VER_ERRO       SECTION "VER_ERRO"         ENTRY "VER_ERRO"
     GET C_IPSERVIDOR     SECTION "IPSERVIDOR"       ENTRY "IPSERVIDOR"
 	 GET C_usuario        SECTION "cusuario"         ENTRY "cusuario"
 	 GET C_senha          SECTION "csenha"           ENTRY "csenha"
     GET c_basesql        SECTION "nomebasesql"      ENTRY "nomebasesql"
	 GET c_baseNFE        SECTION "nomebaseNFE"      ENTRY "nomebaseNFE"
   	 GET C_DESTINO1       SECTION "DESTINO1"         ENTRY "DESTINO1"
     GET C_DESTINO2       SECTION "DESTINO2"         ENTRY "DESTINO2"
	 GET IMP_GRAFICO      SECTION "IMPRIMEGRAFICO"   ENTRY "IMPRIMEGRAFICO" 
     GET C_HOMOLOGACAO    SECTION "NFE-HOMOLOGACAO"  ENTRY "NFE-HOMOLOGACAO"
     GET USODLL           SECTION "USO_DLL"          ENTRY "USO_DLL"
	 GET ACbdNtfSerie     SECTION "Serie_nfce"       ENTRY "Serie_nfce"  
	 GET c_Servidor_NFE   SECTION "SERVICO"          ENTRY "SERVICO"  
	 GET xIdToken         SECTION "IdToken"          ENTRY "IdToken"  
	 GET xToken           SECTION "Token "           ENTRY "Token"  
	 GET xmaishora        SECTION "maishora"         ENTRY "maishora"  
 END INI
ONDE  := c_base 




ondeservidor     := c_baseServidor
ondeTEMP         := c_basetmp
basetXT          := c_TXT
BASETEF          := c_BASETEF
cPathImagem      := c_dados 
NCAIXA           := C_CAIXA
C_DOCUMENTO      := C_DOC 
public c_acesso  :=C_AcessoRemoto  
public C_USAECF  :=USAECF
public CCDPL     :=CC_DPL
public        xxx:=1

public C_VER_ERRO:=C_VER_ERRO
PUBLIC Q_MINIMA  :=Q_MINIMA  
PUBLIC C_STATUS  :=C_STATUS  
PUBLIC C_IPSERVIDOR:=C_IPSERVIDOR
PUBLIC C_usuario  :=C_usuario
PUBLIC C_senha    :=C_senha
PUBLIC  basesql   :=c_basesql
PUBLIC C_cValue   := cValue
PUBLIC DESTINO1   := c_DESTINO1
PUBLIC DESTINO2   := c_DESTINO2
Public oServer	:= Nil
Public cHostName:= C_IPSERVIDOR
Public cUser	:= C_usuario
Public cPassWord:= C_senha
Public cDataBase:= basesql
PUBLIC CBASENFE      := c_baseNFE 
PUBLIC IMPGRAFICO    :=IMP_GRAFICO
PUBLIC C_HOMOLOGACAO
public c_MONITOR:=nMONITOR
PUBLIC USO_DLL       :=VAL(USODLL)
PUBLIC X_CbdNtfSerie :=ACbdNtfSerie
PUBLIC X_pathacbr    :=c_pathacbr
PUBLIC X_Servidor_NFE:=VAL(c_Servidor_NFE)
PUBLIC vcIdToken     :=alltrim(xIdToken)
PUBLIC mgIDToken     :=alltrim(xToken)
public maishora      :=xmaishora

*MSGINFO(maishora)

Public lLogin	:= .F.
lConnected := "OFF"
PUBLIC oservidormysql,cnomeservidor,cusuario,cpassword,cporta,cerrosql,cnomedobanco
basesql := {}
IF c_acesso ="SIM"
MEUIP:= C_IP 
ENDIF
IF c_acesso="NAO"
MEUIP:=C_COM1 
ENDIF
cnomeservidor:=C_IPSERVIDOR
cporta       :="3306"
cusuario     :=C_usuario
cpassword    :=C_senha  
basesql      :=c_basesql
cnomedobanco := basesql  

Ajanela := GetDesktopWidth() //* 0.78125
Ljanela := GetDesktopHeight() //* 0.78125 
IF ajanela=800 .and. ljanela=600
 MsgINFO('Configure a Resolução de Video para 1024 x 768')
Endif
xdia:=strzero(day(date() ),2 ) 
*msginfo(xdia)
xdia:=val(xdia)
*msginfo(xdia)

datacpl:=DtoC( Date() )
horacpl:=Time()


  public _branco_001     := {255,255,255}
         public _preto_001      := {000,000,000}
         public _azul_001       := {108,108,255}
         public _azul_002       := {000,000,255}
         public _azul_003       := {032,091,164}
         public _azul_004       := {023,063,115}
         public _azul_005       := {071,089,135}
         public _azul_006       := {000,073,148}
         public _laranja_001    := {255,163,070}
         public _verde_001      := {000,094,047}
         public _verde_002      := {000,089,045}
         public _cinza_001      := {128,128,128}
         public _cinza_002      := {192,192,192}
         public _cinza_003      := {229,229,229}
         public _cinza_004      := {226,226,226}
         public _cinza_005      := {245,245,245}
         public _vermelho_001   := {255,000,000}
         public _vermelho_002   := {160,000,000}
         public _vermelho_003   := {190,000,000}
         public _amarelo_001    := {255,255,225}
         public _amarelo_002    := {255,255,121}
         public _marrom_001     := {143,103,080}
         public _ciano_001      := {215,255,255}
         public _grid_001       := _branco_001
         public _grid_002       := {210,233,255}
         public _super          := {128,128,255}
         public _acompanhamento := {255,255,220}
         public _numero_serie_    := 'CP62431348BR'
         public _fundo_get   := {255,255,255}
         public _letra_get_1 := {000,000,255}
         public aTipoFJ     := {}

	DEFINE WINDOW Form_0 ;
      at 000,000;
	  width getdesktopwidth();
      height getdesktopheight();
       MAIN ;
        title 'PDV NFCE JUMBO Sistema Versão 3.0'+"  compilação "+datacpl+'  '+horacpl;
        icon cPathImagem+'JUMBO1.ICO';
        ON  INTERACTIVECLOSE { || MyExit() } ;
	     BACKCOLOR COLOR_DESKTOP_DARK_YELLOW ;
		 ON INIT {||wn_splash(1),abre_caixa()}
  

                MyPopup()

  	        nWidth  := Form_1.Width
	        nHeight := Form_1.Height

		@ 20,30 LABEL label_1 VALUE "Start" WIDTH 120 HEIGHT 28 SIZE 18 FONTCOLOR WHITE BOLD TRANSPARENT 

                // the first row of tiles 
                cResIco  := NIL  ; cResPict := "bMail"
                bAction  := 'MsgInfo("PRESS OButton_1x1 BUTTONEX")'
                cTooltip := "OButton_1x1 BUTTONEX with icon"
                METRO_BUTTON("OButton_1x1",nStRow1,50,247,120,"Mail",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_DARK_BLUE,bAction,cTooltip)
        
                cResIco  := NIL 
                cResPict := "bWeather"
                bAction  := 'MsgInfo("PRESS OButton_1x2 BUTTONEX")'
                cTooltip := "OButton_1x2 BUTTONEX with icon"
                METRO_BUTTON("OButton_1x2",nStRow1,300+5,247,120,"Weather",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BLUE,bAction,cTooltip)

                cResIco  := NIL
                cResPict := "bMaps"
                bAction  := 'MsgInfo("PRESS OButton_1x3 BUTTONEX")'
                cTooltip := "OButton_1x3 BUTTONEX with icon"
                METRO_BUTTON("OButton_1x3",nStRow1,554+5,121,120,"Maps",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BRIGHT_PURPLE,bAction,cTooltip)
        
                cResIco  := NIL
                cResPict := "bSkyDrive"
                bAction  := 'MsgInfo("PRESS OButton_1x4 BUTTONEX")'
                cTooltip := "OButton_1x4 BUTTONEX with icon"
                METRO_BUTTON("OButton_1x4",nStRow1,683+5,121,120,"SkyDrive",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BLUE_BLUE,bAction,cTooltip)

                // the second row of tiles 
                cResIco  := "iPeople"
                cResPict := NIL
                bAction  := 'MsgInfo("PRESS OButton_2x1 BUTTONEX")'
                cTooltip := "OButton_2x1 BUTTONEX with icon"
                METRO_BUTTON("OButton_2x1",nStRow2,50,247,120,"People",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_PURPLE,bAction,cTooltip)
        
                cResPict := "Desktop"
                bAction  := 'MsgInfo("PRESS OImage_2x2 IMAGE")'
                METRO_IMAGE("OImage_2x2",nStRow2,300+5,247,120,"Desktop",cResPict,;
                             aFontColor,bAction)

                cResIco  := NIL
                cResPict := "bNews"
                bAction  := 'MsgInfo("PRESS OButton_2x3 BUTTONEX")'
                cTooltip := "OButton_2x3 BUTTONEX with icon"
                METRO_BUTTON("OButton_2x3",nStRow2,555+5,247,120,"News",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_RED,bAction,cTooltip)
        
                // third row of tiles 
                cResIco  := "iMusic"
                cResPict := NIL
                bAction  := 'MsgInfo("PRESS OButton_3x1 BUTTONEX")'
                cTooltip := "OButton_3x1 BUTTONEX with icon"
                METRO_BUTTON("OButton_3x1",nStRow3,50,247,120,"Music",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_ORANGE,bAction,cTooltip)

                cResIco  := NIL
                cResPict := "bIE"
                bAction  := 'MsgInfo("PRESS OButton_3x2 BUTTONEX")'
                cTooltip := "OButton_3x2 BUTTONEX with icon"
                METRO_BUTTON("OButton_3x2",nStRow3,300+5,121,120,"Internet Explorer",;
                             cResPict,cResIco,aFontColor,COLOR_BUTTONE_DARK_PURPLE,bAction,cTooltip)
        
                cResIco  := NIL
                cResPict := "bShop"
                bAction  := 'MsgInfo("PRESS OButton_1x4 BUTTONEX")'
                cTooltip := "OButton_3x3 BUTTONEX with icon"
                METRO_BUTTON("OButton_3x3",nStRow3,427+5,121,120,"Shop",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_GREEN,bAction,cTooltip)

                cResIco  := NIL
                cResPict := "MyFoto"
                bAction  := 'MsgInfo("PRESS OImage_3x4 IMAGE")'
                METRO_IMAGE("OImage_3x4",nStRow3,555+5,247,120,"My Foto",cResPict,;
                             aFontColor,bAction)

                // fourth row of tiles 
                cResIco  := "iMessage"
                cResPict := NIL
                bAction  := 'MsgInfo("PRESS OButton_4x1 BUTTONEX")'
                cTooltip := "OButton_4x1 BUTTONEX with icon"
                METRO_BUTTON("OButton_4x1",nStRow4,50,247,120,"Message",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BRIGHT_PURPLE,bAction,cTooltip)

                cResIco  := NIL
                cResPict := "Bing"
                bAction  := 'MsgInfo("PRESS OImage_4x2 IMAGE")'
                METRO_IMAGE("OImage_4x2",nStRow4,300+5,247,120,"Bing",cResPict,;
                             aFontColor,bAction)

                // Exit from the program
                cResIco  := "iExit"
                cResPict := NIL
                bAction  := 'MyExit()'  //'EXIT'
                cTooltip := "OButton_4x3 - Exit programm !"
                METRO_BUTTON("OButton_4x3",nStRow4,555+5,247,120,"Exit",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BRIGHT_RED,bAction,cTooltip)

                DEFINE STATUSBAR  SIZE 10 BOLD
                    STATUSITEM COPYRIGHT
                    CLOCK
                    DATE
                END STATUSBAR

	END WINDOW

	CENTER WINDOW Form_1
	ACTIVATE WINDOW Form_1

Return NIL
//////////////////////////////////////////////////////////////////////
Function MyPopup()
 
    // add an object to a form
    DEFINE MAIN MENU OF Form_1
      Popup 'File'
           Separator
           Item 'Exit' Action MyExit() Image 'EXIT'
      End Popup
      Popup '&BackColor WINDOW'
           Item 'COLOR_DESKTOP_DARK_CYAN    ' Action ( Form_1.BackColor := COLOR_DESKTOP_DARK_CYAN    ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_GREEN   ' Action ( Form_1.BackColor := COLOR_DESKTOP_DARK_GREEN   ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_PURPLE  ' Action ( Form_1.BackColor := COLOR_DESKTOP_DARK_PURPLE  ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_YELLOW  ' Action ( Form_1.BackColor := COLOR_DESKTOP_DARK_YELLOW  ,MyRefresh() )
           Item 'COLOR_DESKTOP_BRIGHT_GREEN ' Action ( Form_1.BackColor := COLOR_DESKTOP_BRIGHT_GREEN ,MyRefresh() )
           Item 'COLOR_DESKTOP_YELLOW_ORANGE' Action ( Form_1.BackColor := COLOR_DESKTOP_YELLOW_ORANGE,MyRefresh() )
      End Popup
      Popup '&Property'
           Item 'Hide STATUSBAR' Action ( Form_1.Statusbar.Visible := .F. , lStatusBar := .F.)
           Item 'Show STATUSBAR' Action ( Form_1.Statusbar.Visible := .T. , lStatusBar := .T.)
           Separator
           Item 'Hide MENU'      Action ( ClearMenu() )
      End Popup
   END MENU

Return NIL
//////////////////////////////////////////////////////////////////////
Function METRO_BUTTON( cObject,nRow,nCol,nWidth,nHeight,cCaption,cResPicture,cResIco,;
                       aFontColor,aBACKCOLOR,bAction,cTooltip)

    AADD( aObjButton , { cObject,nRow,nCol } )  // add the item to refresh

    DEFINE BUTTONEX &cObject
    	ROW  nRow
            COL  nCol
            WIDTH  nWidth
            HEIGHT nHeight
            PICTURE cResPicture 
            ICON cResIco 
            CAPTION cCaption
            ACTION IIF(bAction=='EXIT',ThisWindow.Release,&(bAction))
            VERTICAL .T.
            LEFTTEXT .F. 
            FLAT .F.
            FONTSIZE  10
            FONTBOLD .t.
            FONTCOLOR aFontColor
            BACKCOLOR aBACKCOLOR
            UPPERTEXT .F.
            TOOLTIP cTooltip
            NOHOTLIGHT .F.
            NOXPSTYLE .t.
    END BUTTONEX

Return NIL
//////////////////////////////////////////////////////////////////////
Function METRO_IMAGE( cObject,nRow,nCol,nWidth,nHeight,cCaption,cResPicture,;
                      aFontColor,bAction)
   LOCAL aBackgroundColor := Form_1.BackColor

   AADD(  aObjImage , { cObject,nRow,nCol } )  // add the item to refresh

   DEFINE IMAGE &cObject
      PARENT            Form_1
      ROW               nRow
      COL               nCol
      WIDTH             nWidth
      HEIGHT            nHeight
      PICTURE           cResPicture
      ACTION            IIF(bAction=='EXIT',ThisWindow.Release,&(bAction))
      STRETCH           .T.
      TRANSPARENT       .F. 
      BACKGROUNDCOLOR   aBackgroundColor
      ADJUSTIMAGE       .F.
   END IMAGE

   @ nRow + 90,nCol+20 LABEL &( "Label_" + cObject ) VALUE cCaption ;
      WIDTH nWidth-20 HEIGHT 20 SIZE 10 FONTCOLOR aFontColor BOLD TRANSPARENT 

Return NIL
////////////////////////////////////////////////////////////
FUNCTION MyRefresh()          
   LOCAL nI, cWnd := _HMG_ThisFormName, cObj
   LOCAL nHeight, nHeight2, nWidth, nWidth2

   nHeight := GetProperty( cWnd, "Height") 
   nWidth  := GetProperty( cWnd, "Width")  

   //  refresh METRO_BUTTON
   FOR nI := 1 TO LEN(aObjButton)
       cObj := aObjButton[nI,1]
       nHeight2 := nHeight - 660 + aObjButton[nI,2] 
       nWidth2  := (nWidth - 870)/2 + aObjButton[nI,3] 
       SetProperty( cWnd, cObj, "Visible" , .F. )
       SetProperty( cWnd, cObj, "Row"     , nHeight2 ) 
       SetProperty( cWnd, cObj, "Col"     , nWidth2 ) 
       SetProperty( cWnd, cObj, "Visible" , .T. )
   NEXT
   //  refresh METRO_IMAGE
   FOR nI := 1 TO LEN(aObjImage)
       cObj := aObjImage[nI,1]
       nHeight2 := nHeight - 660 + aObjImage[nI,2]  
       nWidth2  := (nWidth  - 870)/2 + aObjImage[nI,3] 
       SetProperty( cWnd, cObj, "Visible" , .F. )
       SetProperty( cWnd, cObj, "Row"     , nHeight2 ) 
       SetProperty( cWnd, cObj, "Col"     , nWidth2 ) 
       SetProperty( cWnd, cObj, "Visible" , .T. )

       cObj := "Label_" + aObjImage[nI,1]
       nHeight2 := nHeight - 660 + aObjImage[nI,2] + 90
       nWidth2  := (nWidth  - 870)/2 + aObjImage[nI,3] + 20
       SetProperty( cWnd, cObj, "Visible" , .F. )
       SetProperty( cWnd, cObj, "Row"     , nHeight2 ) 
       SetProperty( cWnd, cObj, "Col"     , nWidth2 ) 
       SetProperty( cWnd, cObj, "Visible" , .T. )
   NEXT

   nHeight := GetProperty( cWnd, "Height") - 660 + 20 
   SetProperty( cWnd, "Label_1", "Visible" , .F. )
   SetProperty( cWnd, "Label_1", "Row"     , nHeight ) 
   SetProperty( cWnd, "Label_1", "Visible" , .T. )

   IF lStatusBar 
      SetProperty( cWnd, "STATUSBAR", "Visible" , .F. )
      SetProperty( cWnd, "STATUSBAR", "Visible" , .T. )
   ENDIF

Return NIL
////////////////////////////////////////////////////////////
Procedure ClearMenu()

        DEFINE MAIN MENU OF Form_1

        END MENU

Return
////////////////////////////////////////////////////////////
FUNCTION MyExit()          // Exit programm
   LOCAL lExit, cMess

   cMess := ';Do you really want to exit?  ; ;'
   cMess := AtRepl( ";", cMess, CRLF )
   lExit := MsgYesNo( cMess, "Exit", .F. )
   IF lExit
      RELEASE WINDOW ALL
   ENDIF

RETURN lExit


Function LinhaDeStatus(cMensagem)
	cMensagem := Iif( cMensagem == Nil , "Conectado no IP "+C_IPSERVIDOR+" "+cnomedobanco , AllTrim(cMensagem) )
	Form_0.StatusBar.Item(1) := cMensagem
Return Nil
	   
	   
*--------------------------------------------------------------*
Function Reconectar_A()                            
*--------------------------------------------------------------*
*cHostName:= AllTrim(  Form_login.p_HostName.Value )
*cUser:= AllTrim( Form_login.p_User.Value )
//cPassWord:= AllTrim( Form_login.p_password.Value )

cHostName:= AllTrim(cHostName)
cUser    := AllTrim(cUser )
cPassWord:= AllTrim(cPassWord)

oServer := TMySQLServer():New(cHostName, cUser, cPassWord )
If oServer:NetErr() 
    lConnected := .T.
 *  MsGInfo("Erro na conecção com o Servidor SQL: " + oServer:Error() )
  BEGIN INI FILE "SERVIDOR.INI"
    SET SECTION "SERVIDOR" ENTRY "CONECTADO" TO "OFF"
  END INI   

  BEGIN INI FILE "SERVIDOR.INI"
   GET C_CONECTADO  SECTION "SERVIDOR" ENTRY "CONECTADO" 
  END INI
PUBLIC C_CONECTADO
*MSGBOX(C_CONECTADO)
	
  RETURN .F.
  ENDI
   BEGIN INI FILE "SERVIDOR.INI"
    SET SECTION "SERVIDOR" ENTRY "CONECTADO" TO "ON"
  END INI

 BEGIN INI FILE "SERVIDOR.INI"
   GET C_CONECTADO  SECTION "SERVIDOR" ENTRY "CONECTADO" 
  END INI
PUBLIC C_CONECTADO

*MSGBOX(C_CONECTADO)

  cria_tabela()
lLogin := .T.
Return Nil               


*--------------------------------------------------------------*
Function  My_SQL_Database_Create( cDatabase )
*--------------------------------------------------------------*
Local aDatabaseList

cDatabase:=Lower(cDatabase)

aDatabaseList:= oServer:ListDBs()
If oServer:NetErr() 
  MsGInfo("Error verifying database list: " + oServer:Error())
return(.f.)
ENDIF

If AScan( aDatabaseList, Lower(cDatabase) ) != 0
 * MsgINFO( "Database allready exists!")
  Return Nil
EndIf 

oServer:CreateDatabase( cDatabase )
If oServer:NetErr() 
  MsGInfo("Error ao criar  base de dados " + oServer:Error() )
  Release Window ALL
  Quit
Endif 

Return Nil



*--------------------------------------------------------------*
Function My_SQL_Database_Connect( cDatabase )
*--------------------------------------------------------------*
Local aDatabaseList

cDatabase:= Lower(cDatabase)
If oServer == Nil 
  MsgInfo("Not connected to SQL server!")
  Return .F.
EndIf

aDatabaseList:= oServer:ListDBs()
If oServer:NetErr() 
  MsGInfo("verifique a base de dados  " + oServer:Error())
 RETURN NIL
Endif 

If AScan( aDatabaseList, Lower(cDatabase) ) == 0
  Return Nil
EndIf 

oServer:SelectDB( cDatabase )
If oServer:NetErr() 
  MsGInfo("Error connecting to database "+cDatabase+": "+oServer:Error() )
Endif 
Return Nil


************************************************************************************************************************************
Function  Abre_conexao_MySql()                            
************************************************************************************************************************************				
              
			  *----- Verifica se já está conectado
                 If oServer != Nil ; Return Nil ; Endif

              *----- Abre Conexao com MySql  
                 oServer := TMySQLServer():New(cHostName, cUser, cPassWord )
			
              
			  *----- Verifica se ocorreu algum erro na Conexão
              If oServer:NetErr() 
                 MsGInfo("Erro de Conexão com Servidor / <TMySQLServer> " + oServer:Error(),SISTEMA )
                 Release Window ALL
                 Quit
              Endif 
				
				//MsgInfo("Conexão  Concluida",SISTEMA)
				//MsgInfo("Conexão Com Servidor MySql Completada!!",SISTEMA)
              *** Obs: a Variável oServer será sempre a referência em todo o sistema para qualquer tipo de operação
            
Return nil




*-------------------------------------------------------------*
function Disconnect()
*-------------------------------------------------------------*
oServer:Destroy()
return nil


//----------------------------------------
Function Linhamensagen(cmen)
//-----------------------------------------
form_0.StatusBar.Item(1) := cMen
Return Nil
