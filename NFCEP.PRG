//--------------------------
** autor := jose´juca de oliveira
** medial:= medial@ps5.com.br
** vilhena/RO
** 69 3321 4575 
** date 11-12-2010
//---------------------------------------------------
#include "minigui.ch"
#Include "F_sistema.ch"
#define WM_MDIMAXIMIZE                  0x0225
#define WM_MDIRESTORE                   0x0223
#define c1Tab CHR(9)
#define NTrim( n ) LTRIM( STR( n, IF( n == INT( n ), 0, 2 ) ) )
#include "fileio.ch"
#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"
#include "winprint.ch"
#define PROGRAM 'Circle'
#define PI  3.1415926536
#define  ETX chr(3)
#define  CR  chr(13)
#define  LF  chr(10)
#include "inkey.ch"
#include 'ord.ch'
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


REQUEST DBFNTX
REQUEST DBFCDX
REQUEST DBFFPT
REQUEST DBFDBT
//------------------------------------
Function Main()      		
//------------------------------------
LOCAL c_Servidor_NFE:=c_baseServidor:=c_STATUS:=IMPGRAFICO:=IMP_GRAFICO:=c_BASETEF:=C_IP:=CC_DPL:=Q_MINIMA:=c_baseNFE:=C_COM1:=USAECF:=C_DOC:=c_papelparede:=c_USAECF:=c_GERAL:=c_COM1:=c_ACESSOREMOTO:=c_dados:=c_DOC := c_base:=c_TXT := c_basetmp:= c_VER_ERRO := SPACE(0) 
LOCAL xmaishora:=picture:=xToken:=xIdToken:=C_HOMOLOGACAO:=C_PATHACBR:=C_cValue:=pictur:=NMONITOR:=C_DESTINO1:=C_DESTINO2:=c_CAIXA:=c_basesql:=cPathImagem:=C_IPSERVIDOR:=C_senha:=C_usuario:=C_IP:=C_COM1:=USAECF:=C_DOC:=c_papelparede:=c_USAECF:=c_GERAL:=c_COM1:=c_ACESSOREMOTO:=c_dados:=c_DOC := c_base :=c_CONECTADO := c_basetmp := SPACE(0)
Local aPictInfo := {}
LOCAL ACbdNtfSerie:=0
local nWidth
local nHeight
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


   	    aColors := GetMenuColors()
	    aColors[ MNUCLR_SEPARATOR1 ] := RGB( 128, 128, 128 ) //linha separadora
	    aColors[ MNUCLR_IMAGEBACKGROUND1 ] := RGB( 236, 233, 216 ) //RGB( 226, 234, 247 ) //fundo bmp do ítem
	    aColors[ MNUCLR_IMAGEBACKGROUND2 ] := RGB( 236, 233, 216 ) //RGB( 226, 234, 247 ) //fundo bmp do ítem
      	aColors[ MNUCLR_MENUBARBACKGROUND1 ] := GetSysColor(15)
      	aColors[ MNUCLR_MENUBARBACKGROUND2 ] := GetSysColor(15)
      	aColors[ MNUCLR_MENUBARSELECTEDITEM1 ] := RGB( 198, 211, 239 ) //GetSysColor(15)
      	aColors[ MNUCLR_MENUBARSELECTEDITEM2 ] := RGB( 198, 211, 239 ) //GetSysColor(15)
      	aColors[ MNUCLR_MENUITEMSELECTEDTEXT ] := RGB( 000, 000, 000 )
      	aColors[ MNUCLR_MENUITEMBACKGROUND1 ] := RGB( 255, 255, 255 ) //fundo geral menu
      	aColors[ MNUCLR_MENUITEMBACKGROUND2 ] := RGB( 255, 255, 255 ) //fundo geral menu
      	aColors[ MNUCLR_SELECTEDITEMBORDER1 ] := RGB( 049, 105, 198 ) //bordas do ítem
      	aColors[ MNUCLR_SELECTEDITEMBORDER2 ] := RGB( 049, 105, 198 ) //bordas do ítem
      	aColors[ MNUCLR_SELECTEDITEMBORDER3 ] := RGB( 049, 105, 198 ) //bordas do ítem
      	aColors[ MNUCLR_SELECTEDITEMBORDER4 ] := RGB( 049, 105, 198 ) //bordas do ítem
	    aColors[ MNUCLR_MENUITEMSELECTEDBACKGROUND1 ] := RGB( 198, 211, 239 ) //fundo ítem menu
	    aColors[ MNUCLR_MENUITEMSELECTEDBACKGROUND2 ] := RGB( 198, 211, 239 ) //fundo ítem menu

         SetMenuColors( aColors )


DBSETDRIVER("DBFCDX")
RDDSETDEFAULT("DBFCDX")
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

 
			
               define window Form_0;
                at 000,000;
                width getdesktopwidth();
                height getdesktopheight();
                title 'PDV NFCE JUMBO Sistema Versão 3.0'+"  compilação "+datacpl+'  '+horacpl;
                main;
                noshow;
               icon cPathImagem+'JUMBO1.ICO';
                nosize;
                backcolor _azul_005;
				ON INIT {||wn_splash(1),abre_caixa()}
    	
				
			  define image img_fundo
    	  	  		 row 00
                     col 00
           	        height getdesktopheight()
                    width getdesktopwidth()
                	picture cPathImagem+'img_fundo.jpg'
				*	picture cPathImagem+'wallpaper.jpg'
					
				  	stretch .t.
              end image

                * menu
                define main menu of Form_0
             
			     define popup 'CONSULTAS'
                   *  menuitem 'CONSULTA EMISSÃO NFC_e NORMAL ' action {||MYSQL_BROWSE_nfC_e_saida()}    Image cPathImagem+ 'CONSUL1.bmp'   
                    * separator
                     menuitem 'CONSULTA EMISSÃO NFC_e NORMAL ' action {||Reconectar_A(), Consulta_NFEc() }    Image cPathImagem+ 'CONSUL1.bmp'   
                     separator
                     menuitem 'EMISSÃO DUPLICATAS COM HISTORICO' action {||duplcas_do_nfe()}    Image cPathImagem+ 'CONSUL1.bmp'   
                     separator
                     menuitem 'CONSULTA EMISSÃO NFC_e CONTIGENCIA' Action {||Verifica_Emitidas_Contingencia1()}    Image cPathImagem+ 'CONSUL1.bmp'   
					 separator
                     menuitem 'CONSULTA EMISSÃO DAVS' Action {||Consulta_DAVS() }    Image cPathImagem+ 'CONSUL1.bmp' 
                     separator
                     menuitem 'CONSULTA EMISSÃO NFE  ' Action {||MYSQL_BROWSE_nfe_saida() }    Image cPathImagem+ 'CONSUL1.bmp'   
					 separator
                    menuitem 'INUTILIZAÇÃO DE NFE    ' Action {||F_unitilizacao()}    Image cPathImagem+ 'CONSUL1.bmp'   
					 separator
             
	           end popup
                define popup 'EMISSÃO NFE DE NFCE'
                      menuitem 'EMISSÃO DE NFE 55' action nfe_direto()
                      separator
			          menuitem 'EMISSÃO DE NFE DEVOLUÇÃO DE CLIENTE' action NFE_Devolucao_da_nfce()  
					  separator
                end popup
  
             define popup 'CARTA DE CORREÇÃO/CANCELAMENTO'
                       menuitem 'EMISSÃO CARTA DE CORRECÃO 65 ' action carta_correcao_65()
                      separator
				       menuitem 'EMISSÃO CARTA DE CORRECÃO 55 'action carta_correcao_55()
               	  separator
                      menuitem 'CANCELAR NFC_E 65 ' action CANCELAR_65()
                      separator
				      menuitem 'CANCELAR NFE   55 'action CANCELAR_55()
                separator
             end popup
  
                  define popup 'CONFIG IMPRESSORA'
                       menuitem 'CONFIGURAÇÃO DAS IMPRESSORAS' action IMPRESSORA()
                      separator
			
             end popup

  end menu

                * botões (toolbar)
                define buttonex venda_delivery
                       parent Form_0
                       picture cPathImagem+'NFE.bmp'
                       col 000
                       row 000
                       width 170
                       height 080
                       caption 'EMISSÃO'+CRLF+'NFC-e'
                       action  {|| VENDE_NFCE()}
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _preto_001
                       vertical .F.
                       lefttext .F.
                       flat .T.
                       noxpstyle .T.
                       backcolor _branco_001
                end buttonex
								
                define buttonex venda_mesas
                       parent Form_0
                       picture cPathImagem+'mesas.bmp'
                       col 170
                       row 000
                       width 170
                       height 080
                       caption 'EMISSÃO'+CRLF+'DAVS-ORC'
                       action {||DAV_ORC()} 
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _preto_001
                       vertical .F.
                       lefttext .F.
                       flat .T.
                       noxpstyle .T.
                       backcolor _branco_001
                end buttonex
				
				    define buttonex produtos
                       parent Form_0
                       picture cPathImagem+'produtos.bmp'
                      col 340
                       row 000
                       width 170
                       height 080
                       caption 'CADASTRO'+CRLF+'PRODUTOS'
                       action sql_produtos()
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _preto_001
                       vertical .F.
                       lefttext .F.
                       flat .T.
                       noxpstyle .T.
                       backcolor _branco_001
                end buttonex
            
			    define buttonex clientes
                       parent Form_0
                       picture cPathImagem+'clientes.bmp'
                       col 510
                       row 000
                       width 170
                       height 080
                       caption 'CADASTRO'+CRLF+'CLIENTES'
                       action clientes_sql()
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _preto_001
                       vertical .F.
                       lefttext .F.
                       flat .T.
                       noxpstyle .T.
                       backcolor _branco_001
                end buttonex
            
	
                define buttonex venda_balcao
                       parent Form_0
                       picture cPathImagem+'caixa.bmp'
                       col 680
                       row 000
                       width 170
                       height 080
                       caption 'EMISSÃO'+CRLF+'BOLETOS'
                       action {||jj_boleto()} 
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _preto_001
                       vertical .F.
                       lefttext .F.
                       flat .T.
                       noxpstyle .T.
                       backcolor _branco_001
                end buttonex
            


			define buttonex sair_programa
                       parent Form_0
                       picture cPathImagem+'sair_programa.bmp'
                       col 850
                       row 000
                       width 172
                       height 080
                       caption 'ESC'+CRLF+'SAIR DO'+CRLF+'PROGRAMA'
                       action {||verificacontigencia(),Confirmar_Saida(),Confirmar_backup()}
					  *action {||Verifica_Emitidas_Contingencia1(),Confirmar_Saida(),Confirmar_backup()}
				       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _vermelho_002
                       vertical .F.
                       lefttext .F.
                       flat .T.
                       noxpstyle .T.
                       backcolor _branco_001
                end buttonex

				
					 define label softhouse_001
                       parent Form_0
                       col getdesktopwidth()-510
                       row getdesktopheight()-350
                       value 'PDV'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 020
                       fontbold .T.
                       fontcolor _fundo_get
                       transparent .T.
                end label
				
				
			
				   define image nfce
                       row getdesktopheight()-360
                       col getdesktopwidth()-440
					   height 50
                       width 110
                       picture cPathImagem+'NFCE.jpg'
                       stretch .T.
                end image
				
      
	           define image nfe
                       row getdesktopheight()-360
                       col getdesktopwidth()-320
					   height 50
                       width 110
                       picture cPathImagem+'nfe.jpg'
                       stretch .T.
                end image
				
      
	  
                define image brasil
                       row getdesktopheight()-360
                       col getdesktopwidth()-200
					   height 50
                       width 110
                       picture cPathImagem+'bandeira_brasil.jpg'
                       stretch .T.
                end image
				
	  
				* nome da softhouse
                define label softhouse_002
                       parent Form_0
                       col getdesktopwidth()-510
                       row getdesktopheight()-310
                       value 'Corporation Este software foi desenvolvido por'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _fundo_get
                       transparent .T.
                end label

			
								
								
								
				* nome da softhouse
                define label softhouse_003
                       parent Form_0
                       col getdesktopwidth()-510
                       row getdesktopheight()-290
                       value 'Minigui Extended '+Version()
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _fundo_get
                       transparent .T.
                end label

			*	
				
                 
                define label softhouse_004
                       parent Form_0
                       col getdesktopwidth()-510
                       row getdesktopheight()-275
                       value 'JOSÉ JUCÁ DE OLIVEIRA'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 014
                       fontbold .T.
                       fontcolor _letra_get_1
                       transparent .T.
                end label
				
				
				
				

            
			 DEFINE STATUSBAR of form_0 	FONT "MS Sans Serif" SIZE 10
    STATUSITEM "Conectado no IP: "+C_IPSERVIDOR+" "+basesql WIDTH 150 	
          DATE
          CLOCK
          KEYBOARD
	   STATUSITEM ""+AllTrim( NetName() ) WIDTH 150 
	  END STATUSBAR

         *       on key escape action Form_0.release
                
         end window

         Form_0.maximize
         Form_0.activate

         return(nil)
*-------------------------------------------------------------------------------



	
Function Abandona_Sistema()
     Status_Entrada_Saida("NAO")
      Close All	
Return Nil


Function LinhaDeStatus(cMensagem)
	cMensagem := Iif( cMensagem == Nil , "Conectado no IP "+C_IPSERVIDOR+" "+cnomedobanco , AllTrim(cMensagem) )
	Form_0.StatusBar.Item(1) := cMensagem
Return Nil
	
	
Function wn_mensasplash(cMensagem)
	cMensagem := Iif( cMensagem == Nil , "Conectado no IP "+C_IPSERVIDOR+" "+cnomedobanco , AllTrim(cMensagem) )
	Form_0.StatusBar.Item(1) := cMensagem
   // despues de haber declarado statusbar y  progresbar
Return Nil

	
//-------------------------------------
function size_it(hWnd)
//-------------------------------------
SetWindowPos( hWnd, 0,0, 0,;
                 GetDesktopWidth(),;
                 GetDesktopHeight() )
   BringWindowToTop(hWnd)
   SetFocus(hWnd)
return(NIL)

//----------------------------------------
Function Linhamensagen(cmen)
//-----------------------------------------
form_0.StatusBar.Item(1) := cMen
Return Nil



Function Confirmar_Saida()
If MSGYesNo( "Confirma Saída do Sistema??" )
*verificacontigencia()
Confirmar_backup()
HB_GCALL()
limpamemoriaram() 
HB_GCALL()
limpamemoriaram() 
Release Window ALL
QUIT
EndIf
Return Nil



Function FECHA_CAIXA()
If MSGYesNo( "Quer Fechar o Caixa??" )
autorizacaogeral(1)
Form_0.Release
QUIT
HB_GCALL()
limpamemoriaram() 
EndIf
Return Nil



Function Confirmar_backup()
if MSGYesNo("Por Favor Confirme para sim Fazer backup ")
EXECUTE FILE  'BACKUPT1.BAT' WAIT 
end
*resumo_caixa()
RETURN 


function verificacontigencia()
   local flag    := .F.
	   

Reconectar_A()

 /*
cQuery  :="SELECT CbdNtfNumero,CbdxNome_dest FROM NFCE_contigencia"
oQuery  :=oServer:Query( cQuery )
*If !oQuery:EOF()
*For             k:=1 to oQuery:LastRec()
*oRow           :=oQuery:GetRow(k)
oRow    :=oQuery:GetRow(1)
*/

abrecontige()
 

       dbselectarea('Contige')
       Contige->(ordsetfocus('numero'))
       Contige->(dbgotop())
	   
       while .not. eof()
	   


IF EMPTY(contige->numero)

*MsgInfo("nao tem ")
else
 Verifica_Emitidas_Contingencia1()
endif

contige->(dbskip())
LOOP
ENDD

   


return





function verificafecha()
Local oRow
Local i
local c_barras
Local oQuery
local c_encontro

IF C_CONECTADO="OFF"
ELSE
SQL_Connect() 
oQuery := oServer:Query( "Select nseq_orc From PRE_VENDA" )
For i := 1 To oQuery:LastRec()
    oRow := oQuery:GetRow(i)
if oRow:fieldGet(1) = 0 
MsgINFO(" TEM PRE-VENDA EM ABERTO", "Atenção..")
 return
Disconnect()
else   
ENDIF
oQuery:Skip(1)
Next
oQuery:Destroy()
ENDIF
Disconnect()
RETURN 

*--------------------------------------------------------------*
Function SQL_Connect()                            
*--------------------------------------------------------------*
cHostName:= AllTrim(cHostName)
cUser    := AllTrim(cUser )
cPassWord:= AllTrim(cPassWord)

oServer := TMySQLServer():New(cHostName, cUser, cPassWord )
If oServer:NetErr() 
    lConnected := .T.
     MsGInfo("Erro de Conexão com Servidor " ,SISTEMA )
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

If MSGYesNo( "Confirma Saída do Sistema??" )
   Form_0.Release
EndIf
Return Nil
*-------------------------------------------------------------------------------
static function cria_dbf_cdx()
abreoperador()
abrelibusu()
return(nil)

*-------------------------------------------------------------------------------
static function login()

       local x_senha := ''
       
       define window form_login;
              at 000,000;
              width 400;
              height 300;
              title 'Acesso ao programa';
              icon cPathImagem+'icone.ico';
              modal;
              noautorelease;
              nosize;
              nosysmenu

              define label lbl_top
                     parent form_login
                     col 000
                     row 000
                     value 'PDVNATIVO'
                     width 600
                     height 045
                     fontname 'tahoma'
                     fontsize 022
                     fontbold .T.
                     backcolor _azul_006
                     fontcolor _super
                     transparent .F.
              end label
			  
              define label lbl_top1
                     parent form_login
                     col 170
                     row 000
                     value ''
                     width 350
                     height 045
                     fontname 'tahoma'
                     fontsize 022
                     fontbold .T.
                     backcolor _azul_006
                     fontcolor _laranja_001
                     transparent .T.
              end label
              define label lbl_top2
                     parent form_login
                     col 300
                     row 010
                     value 'v.5.0, 2012'
                     width 350
                     height 020
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     backcolor _azul_006
                     fontcolor _branco_001
                     transparent .T.
              end label
              
              * senha
              define label label_login
                     col 050
                     row 070
                     value 'Digite sua senha'
                     autosize .T.
                     fontcolor _cinza_001
                     fontname 'verdana'
                     fontsize 010
                     fontbold .T.
                     transparent .T.
              end label
              @ 070,190 textbox tbox_senha;
                        of form_login;
                        height 027;
                        width 120;
                        value x_senha;
                        maxlength 010;
                        font 'verdana' size 010;
                        backcolor _branco_001;
                        fontcolor _preto_001;
                        password

*				  if l_demo
              	  define label label_senha_demo
                     	col 100
                     	row 100
                     	value 'digite a senha '
                     	autosize .T.
                     	fontcolor RED
                     	fontname 'verdana'
                     	fontsize 012
                     	fontbold .T.
                     	transparent .T.
     				  end label
*				  endif 

              * linha separadora
              define label linha_rodape
                     col 000
                     row 165
                     value ''
                     width form_login.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label

			  *              picture cPathImagem+'img_ok.bmp';
			  
              @ 170,220 buttonex btn_ok;
                        caption 'Ok';
                       flat;
                        noxpstyle;
                        width 060;
                        height 040;
                        font 'verdana';
                        size 9;
                        fontcolor BLACK;
                        bold;
                        backcolor WHITE;
                        tooltip 'Confirma a entrada no programa';
                        action confirma_entrada()
						
              @ 170,290 buttonex btnex_cancela;
                        caption 'Cancela';
                        picture cPathImagem+'img_cancela.bmp';
                        flat;
                        noxpstyle;
                        width 100;
                        height 040;
                        font 'verdana';
                        size 9;
                        fontcolor BLACK;
                        bold;
                        backcolor WHITE;
                        tooltip 'Cancela a entrada ao programa';
                        action Form_0.release

		     define label label_ecf
			            col 10
                        row 185
                     	value 'Aguarde Localizando a Ecf '
                     	autosize .T.
                     	fontcolor BLACK
                     	fontname 'verdana'
                     	fontsize 010
                     	fontbold .F.
                     	transparent .T.
				  end label

		     define label label_ecf1
			            col 05
                        row 240
                     	value ''
					    width 80
                        height 200
                     	autosize .T.
                     	fontcolor RED
                     	fontname 'verdana'
                     	fontsize 10
                     	fontbold .t.
                     	transparent .T.
				  end label				  
								     				
       end window

       form_login.setfocus
       form_login.tbox_senha.setfocus
       form_login.center
       form_login.activate

       return(nil)
	   


//////////////////////////////////////////////////////////
form_login.setfocus
form_login.tbox_senha.setfocus
return(nil)
 

	  
*-------------------------------------------------------------------------------
static function confirma_entrada()

       local x_senha := form_login.tbox_senha.value
abreoperador()
       if empty(x_senha)
          msgalert('Senha não pode ser em branco','Atenção')
          form_login.tbox_senha.setfocus
          return(nil)
       endif

	   
       dbselectarea('operadores')
       operadores->(ordsetfocus('senha'))
       operadores->(dbgotop())
       operadores->(dbseek(x_senha))

       if found()
          form_login.release
          show window form_0
          _codigo_usuario_ := operadores->codigo
          _nome_usuario_   := operadores->nome
          dbselectarea('acesso')
          acesso->(ordsetfocus('operador'))
          acesso->(dbgotop())
          acesso->(dbseek(_codigo_usuario_))
          if found()
             _a_001 := acesso->acesso_001
             _a_002 := acesso->acesso_002
             _a_003 := acesso->acesso_003
             _a_004 := acesso->acesso_004
             _a_005 := acesso->acesso_005
             _a_006 := acesso->acesso_006
             _a_007 := acesso->acesso_007
             _a_008 := acesso->acesso_008
             _a_009 := acesso->acesso_009
             _a_010 := acesso->acesso_010
             _a_011 := acesso->acesso_011
             _a_012 := acesso->acesso_012
             _a_013 := acesso->acesso_013
             _a_014 := acesso->acesso_014
             _a_015 := acesso->acesso_015
             _a_016 := acesso->acesso_016
             _a_017 := acesso->acesso_017
             _a_018 := acesso->acesso_018
             _a_019 := acesso->acesso_019
             _a_020 := acesso->acesso_020
             _a_021 := acesso->acesso_021
             _a_022 := acesso->acesso_022
             _a_023 := acesso->acesso_023
             _a_024 := acesso->acesso_024
             _a_025 := acesso->acesso_025
             _a_026 := acesso->acesso_026
             _a_027 := acesso->acesso_027
             _a_028 := acesso->acesso_028
             _a_029 := acesso->acesso_029
             _a_030 := acesso->acesso_030
             _a_031 := acesso->acesso_031
             _a_032 := acesso->acesso_032
             _a_033 := acesso->acesso_033
             _a_034 := acesso->acesso_034
             _a_035 := acesso->acesso_035
             _a_036 := acesso->acesso_036
             _a_037 := acesso->acesso_037
             _a_038 := acesso->acesso_038
             _a_039 := acesso->acesso_039
             _a_040 := acesso->acesso_040
             _a_041 := acesso->acesso_041
             _a_042 := acesso->acesso_042
             _a_043 := acesso->acesso_043
          else
             _a_001 := .F.
             _a_002 := .F.
             _a_003 := .F.
             _a_004 := .F.
             _a_005 := .F.
             _a_006 := .F.
             _a_007 := .F.
             _a_008 := .F.
             _a_009 := .F.
             _a_010 := .F.
             _a_011 := .F.
             _a_012 := .F.
             _a_013 := .F.
             _a_014 := .F.
             _a_015 := .F.
             _a_016 := .F.
             _a_017 := .F.
             _a_018 := .F.
             _a_019 := .T.
             _a_020 := .F.
             _a_021 := .F.
             _a_022 := .F.
             _a_023 := .F.
             _a_024 := .F.
             _a_025 := .F.
             _a_026 := .F.
             _a_027 := .F.
             _a_028 := .F.
             _a_029 := .F.
             _a_030 := .F.
             _a_031 := .F.
             _a_032 := .F.
             _a_033 := .F.
             _a_034 := .F.
             _a_035 := .F.
             _a_036 := .F.
             _a_037 := .F.
             _a_038 := .F.
             _a_039 := .F.
             _a_040 := .F.
             _a_041 := .F.
             _a_042 := .F.
             _a_043 := .F.
          endif
          setproperty('form_0','operador_002','value',alltrim(_nome_usuario_))
       else
          msgexclamation('Senha não confere','Atenção')
          form_login.tbox_senha.setfocus
          return(nil)
       endif
 return(nil)
   
*-------------------------------------------------------------------------------
static function libera(parametro)

       if !parametro
          return(.F.)
       endif
    return(.T.)
	   
	   

	   
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
