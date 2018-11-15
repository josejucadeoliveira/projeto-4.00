
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
     LOCAL cResIco,XDATAHORA , cResPict := NIL, bAction, cTooltip, nWidth, nHeight
     LOCAL nStRow1 := 60, nStRow2 := 188, nStRow3 := 317, nStRow4 := 447
     LOCAL aFontColor := WHITE,nMONITORacbr
     LOCAL c_Servidor_NFE:=c_baseServidor:=xCbdNtfSerie:=c_STATUS:=IMPGRAFICO:=IMP_GRAFICO:=c_BASETEF:=C_IP:=CC_DPL:=Q_MINIMA:=c_baseNFE:=C_COM1:=USAECF:=C_DOC:=c_papelparede:=c_USAECF:=c_GERAL:=c_COM1:=c_ACESSOREMOTO:=c_dados:=c_DOC := c_base:=c_TXT := c_basetmp:= c_VER_ERRO := SPACE(0) 
     LOCAL xmaishora:=picture:=xToken:=xIdToken:=C_AMBIENTE:=C_PATHACBR:=C_cValue:=pictur:=NMONITOR:=C_DESTINO1:=C_DESTINO2:=c_CAIXA:=c_basesql:=cPathImagem:=C_IPSERVIDOR:=C_senha:=C_usuario:=C_IP:=C_COM1:=USAECF:=C_DOC:=c_papelparede:=c_USAECF:=c_GERAL:=c_COM1:=c_ACESSOREMOTO:=c_dados:=c_DOC := c_base :=c_CONECTADO := c_basetmp := SPACE(0)
     Local aPictInfo := {}
     LOCAL ACbdNtfSerie:=0
	 Local cValue := ""
	 local xnwd,xnhd,xnLarguraTela,xnAlturaTela ,cVERSAONFE,cVERSAONFCE ,XDATACOMPILACAO:=""
     LOCAL mysql := .T.
     local aColors 
     Local P, RET := .T., TFIM, IP, PORTA, RESP
     local sENDER   := ''  ,;
      USODLL  := "" ,;
      XcSubDirTMP := ""  ,;
      xcSubDirXml := ''  ,;
      xcSubDirevento  := ''   ,;
      sNUMCUPOM:= ''  ,;
      sSECEST  := 0   ,;
      sESTADO  := ''

	  
 Public aBancos     := {}
  
 			aadd(aBancos,'BancoDoBrasil')
         aadd(aBancos,'Santander')                                                                                       
         aadd(aBancos,'CaixaEconômica')
         aadd(aBancos,'CaixaSicob')
         aadd(aBancos,'Bradesco')                                                                                   
         aadd(aBancos,'Itaú')
         aadd(aBancos,'BancoMercantil')
         aadd(aBancos,'Sicred')
         aadd(aBancos,'Bancoob')       
         aadd(aBancos,'Banrisul')                                                                                     
         aadd(aBancos,'Banestes')                                                                                     
         aadd(aBancos,'HSBC')                                                                                     
         aadd(aBancos,'BancoDoNordeste')                                                                                     
         aadd(aBancos,'BRB')                                                                                     
         aadd(aBancos,'BicBanco')                                                                                     
         aadd(aBancos,'BradescoSICOOB')                                                                                     
         aadd(aBancos,'BancoSafra')                                                                                     
         aadd(aBancos,'SafraBradesco')                                                                                     
         aadd(aBancos,'BancoCECRED')                                                                                     
         aadd(aBancos,'CREDSIS')
 
	 
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
Cria_contigencia_Ini()
*Criadir_nfe()

//-------------------------------------------------------------
llenarBR_Fic()
ProcedureValidadeCertificado()
	
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
 	 get nMONITORACBR     SECTION "GERA_NFE_NFCE"     ENTRY  "GERA_NFE_NFCE"
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
	 GET IMP_GRAFICO      SECTION "TIPOIMPERSSAO"   ENTRY "TIPOIMPERSSAO" 
     GET C_AMBIENTE       SECTION "AMBIENTE"         ENTRY "AMBIENTE"
     GET USODLL           SECTION "USO_DLL"          ENTRY "USO_DLL"
	 GET xCbdNtfSerie     SECTION "Serie_nfe"        ENTRY "Serie_nfe"  
	 GET c_Servidor_NFE   SECTION "SERVICO"          ENTRY "SERVICO"  
	 GET xIdToken         SECTION "IdToken"          ENTRY "IdToken"  
	 GET xToken           SECTION "Token "           ENTRY "Token"  
	 GET xnwd              SECTION "tela"             ENTRY "wd"  
	 GET xnhd              SECTION "tela"             ENTRY "hd"  
	 GET xnLarguraTela     SECTION "tela"             ENTRY "nLarguraTela"  
	 GET xnAlturaTela      SECTION "tela"             ENTRY "nAlturaTela"  
	 GET xmaishora         SECTION "maishora"          ENTRY "maishora"  
	 GET cVERSAONFCE       SECTION "VERSAONFCE"        ENTRY "VERSAONFCE"          
	 GET cVERSAONFE        SECTION "VERSAONFE"         ENTRY "VERSAONFE"         
	 GET XDATACOMPILACAO   SECTION "DATACOMPILACAO"    ENTRY "DATACOMPILACAO"  
     GET xcSubDirTMP       SECTION "cSubDirTMP"        ENTRY "cSubDirTMP"
     GET xcSubDirXml       SECTION "cSubDirXml"        ENTRY "cSubDirXml"
     GET xcSubDirevento     SECTION "cSubDirevento"    ENTRY "cSubDirevento"
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
Public oServer_NFe	:= Nil
Public cHostName:= C_IPSERVIDOR
Public cUser	:= C_usuario
Public cPassWord:= C_senha
Public cDataBase:= basesql
Public cDataBase_NFe:= 'nfe_destinadas'
PUBLIC CBASENFE      := c_baseNFE 
PUBLIC IMPGRAFICO    :=IMP_GRAFICO
PUBLIC cAMBIENTE    :=C_AMBIENTE
PUBLIC GERA_NFE_NFCE :=val(nMONITORACBR)
PUBLIC USO_DLL       :=VAL(USODLL)
PUBLIC X_CbdNtfSerie :=ACbdNtfSerie
PUBLIC X_pathacbr    :=c_pathacbr
PUBLIC X_Servidor_NFE:=VAL(c_Servidor_NFE)
PUBLIC vcIdToken     :=alltrim(xIdToken)
PUBLIC mgIDToken     :=alltrim(xToken)
public maishora      :=xmaishora
public ximpressora:=0
public nwd :=val(xnwd)
public nhd :=val(xnhd)
public nLarguraTela:=val(xnLarguraTela)
public nAlturaTela :=val(xnAlturaTela) 
PUBLIC XVERSAONFE  :=cVERSAONFE 
PUBLIC XVERSAONFCE  :=cVERSAONFCE 
public cSubDir      :=xcSubDirXml
public cSubDirTMP   :=xcSubDirTMP 
public cSubDirevento:=xcSubDirevento

PUBLIC Serie_NFE   :=val(xCbdNtfSerie)
*MSGINFO(cAMBIENTE)

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
         nLargura:=GetDesktopRealWidth()    
         nAltura:=GetDesktopRealHeight() 
*PUBLIC   nLINHA :=GetDesktopRealWidth()    
*PUBLIC   nCOLUNA:=GetDesktopRealHeight() 





DATACOMP:=SUBSTR(XDATACOMPILACAO, 79, 8)

		 
 	DEFINE WINDOW Form_0 ;
      AT GetDesktopRealTop(),GetDesktopRealLeft() ;
	   WIDTH GetDesktopRealWidth() ;
	   HEIGHT GetDesktopRealHeight();				
       MAIN ;
       title 'PDV NFCE JUMBO Sistema Versão 4.00'+"  compilação "+SUBSTR(XDATACOMPILACAO, 64, 10)+" Hs "+DATACOMP;
       icon cPathImagem+'JUMBO1.ICO';
        ON  INTERACTIVECLOSE { || MyExit() } ;
	  BACKCOLOR COLOR_DESKTOP_BRIGHT_GREEN;
	  ON INIT {||wn_splash(1),abre_caixa()}
   
                  MyPopup()

  	   nWidth  := Form_0.Width
	   nHeight := Form_0.Height
   
			
		@ 20,30 LABEL label_1 VALUE "PDV NFC-e desenvolvido por, JOSÉ JUCÁ DE OLIVEIRA , Minigui Extended "+Version()  WIDTH 900 HEIGHT 28 SIZE 15 FONTCOLOR WHITE BOLD TRANSPARENT 

linha:=nWidth
*msginfo(linha)
coluna:=nHeight

*msginfo(coluna)


		
		
		
		
		
                // the first row of tiles 
                 cResIco  := NIL  
				 cResPict := "bMail"
                 bAction  := 'VENDE_NFCE()'
                cTooltip := "Emissão Nota Eletronica Comsumidor"
		        METRO_BUTTON("OButton_1x1",nStRow1,50,247,120,"EMISSÃO NFC-e",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_DARK_BLUE,bAction,cTooltip)
        
                cResIco  := NIL 
                cResPict := "orcamento"
                bAction  := 'DAV_ORC()'
			   cTooltip := "OButton_1x2 BUTTONEX with icon"
                METRO_BUTTON("OButton_1x2",nStRow1,300+5,247,120,"Orçamento Davs",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BLUE,bAction,cTooltip)

                cResIco  := NIL
                cResPict := "bMaps"
                bAction  := 'sql_produtos() '
                cTooltip := "OButton_1x3 BUTTONEX with icon"
                METRO_BUTTON("OButton_1x3",nStRow1,554+5,247,120,"Produtos",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BRIGHT_PURPLE,bAction,cTooltip)
***********************************************************************************
							 
                // the second row of tiles 
                cResIco  := "iPeople"
                cResPict := NIL
                bAction  := 'clientes_sql()'
                cTooltip := "OButton_2x1 BUTTONEX with icon"
                METRO_BUTTON("OButton_2x1",nStRow2,50,247,120,"Cadastro de Clientes",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_PURPLE,bAction,cTooltip)
     
                cResIco  := NIL
                cResPict := 'boleto'
                bAction  := 'jj_boleto()'
                cTooltip := "Emisso de boletos"
                METRO_BUTTON("OButton_2x2",nStRow2,300+5,247,120,"Emissão de Boletos",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_RED,bAction,cTooltip)
        
		        cResIco  := NIL
                cResPict := 'moedas'
                bAction  := 'duplcas_do_nfe()'
                cTooltip := "Emisso de boletos"
                METRO_BUTTON("OButton_2x3",nStRow2,554+5,247,120,"DUPLICATAS COM HISTORICO",cResPict,cResIco,;
                        aFontColor,COLOR_BUTTONE_BRIGHT_RED,bAction,cTooltip)
						
				
	**********************************************************************************************	
	              // third row of tiles 
                cResIco  :=nil
                cResPict := 'bShop'
                bAction  := 'Consulta_DAVS()'
                cTooltip := "Consultas Davs (orçamentos"
                METRO_BUTTON("OButton_3x1",nStRow3,50,247,120,"Consulta Davs emitidas",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_ORANGE,bAction,cTooltip)

	             cResIco := nil
			    cResPict := 'consulta_nfce'
                bAction  :=  'Consulta_NFEc()'
			    cTooltip := "Consulta nfce Emitidas notas Grandes"
               METRO_BUTTON("OButton_3x2",nStRow3,300+5,247,120,"Consulta nfce Emitidas",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_RED,bAction,cTooltip)

							 
					
		        cResIco := nil
			    cResPict := 'bWeather'
                bAction  :=  'MYSQL_BROWSE_nfe_saida() '
			    cTooltip := "Consulta nfce Emitidas notas Grandes"
               METRO_BUTTON("OButton_3x3",nStRow3,554+5,247,120,"Consulta nfe Emitidas",cResPict,cResIco,;
               aFontColor,COLOR_BUTTONE_GREEN,bAction,cTooltip)
        
	 	   
		  *************************************************************************************
		  
							 

							 
                // fourth row of tiles 
                cResIco  := nil
                cResPict := "contigencia"
                bAction  := '  F_contigencia_acbr_class()'
                cTooltip := "OButton_4x1 BUTTONEX with icon"
                METRO_BUTTON("OButton_4x1",nStRow4,50,247,120,"Emissão em Contigencia",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BRIGHT_PURPLE,bAction,cTooltip)


             
			 // fourth row of tiles 
                cResIco  := nil
                cResPict := 'xml'
                bAction  := 'F_unitilizacao()'
                cTooltip := "Inutilização"
                METRO_BUTTON("OButton_4x2",nStRow4,300,247,120,"Inutilização",cResPict,cResIco,;
                            aFontColor,COLOR_BUTTONE_DARK_BLUE,bAction,cTooltip)


							 
                // Exit from the program
                cResIco  := "iExit"
                cResPict := NIL
                bAction  := 'MyExit()'  //'EXIT'
                cTooltip := "'SAIR DO PROGRAMA !"
                METRO_BUTTON("OButton_4x3",nStRow4,555+5,247,120,"SAIR DO PROGRAMA",cResPict,cResIco,;
                             aFontColor,COLOR_BUTTONE_BRIGHT_RED,bAction,cTooltip)
							 
			            
			 DEFINE STATUSBAR of form_0 	FONT "MS Sans Serif" SIZE 10
    STATUSITEM "Conectado no IP: "+C_IPSERVIDOR+" "+basesql WIDTH 150 	
          DATE
          CLOCK
          KEYBOARD
	   STATUSITEM ""+AllTrim( NetName() ) WIDTH 150 
	  END STATUSBAR

				
	END WINDOW

	CENTER WINDOW Form_0
	ACTIVATE WINDOW Form_0

Return NIL
//////////////////////////////////////////////////////////////////////
Function MyPopup1()
 
    // add an object to a form
    DEFINE MAIN MENU OF Form_0
      Popup 'File'
           Separator
           Item 'Exit' Action MyExit() Image 'EXIT'
      End Popup
      Popup '&BackColor WINDOW'
           Item 'COLOR_DESKTOP_DARK_CYAN    ' Action ( Form_0.BackColor := COLOR_DESKTOP_DARK_CYAN    ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_GREEN   ' Action ( Form_0.BackColor := COLOR_DESKTOP_DARK_GREEN   ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_PURPLE  ' Action ( Form_0.BackColor := COLOR_DESKTOP_DARK_PURPLE  ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_YELLOW  ' Action ( Form_0.BackColor := COLOR_DESKTOP_DARK_YELLOW  ,MyRefresh() )
           Item 'COLOR_DESKTOP_BRIGHT_GREEN ' Action ( Form_0.BackColor := COLOR_DESKTOP_BRIGHT_GREEN ,MyRefresh() )
           Item 'COLOR_DESKTOP_YELLOW_ORANGE' Action ( Form_0.BackColor := COLOR_DESKTOP_YELLOW_ORANGE,MyRefresh() )
      End Popup
      Popup '&Property'
           Item 'Hide STATUSBAR' Action ( Form_0.Statusbar.Visible := .F. , lStatusBar := .F.)
           Item 'Show STATUSBAR' Action ( Form_0.Statusbar.Visible := .T. , lStatusBar := .T.)
           Separator
           Item 'Hide MENU'      Action ( ClearMenu() )
      End Popup
   END MENU

Return NIL


Function MyPopup()
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
                    menuitem 'IMPRIMIR EVENTO ' Action {||IMPRIMIR_EVENTO1()}    Image cPathImagem+ 'CONSUL1.bmp'   
					 separator
             
	           end popup
                define popup 'EMISSÃO NFE DE NFCE'
                      menuitem 'EMISSÃO DE NFE 55' action nfe_direto()
                      separator
			          menuitem 'EMISSÃO DE NFE DEVOLUÇÃO DE CLIENTE' action NFE_Devolucao_da_nfce()  
					  separator
             	      menuitem 'EMISSÃO DE NFE DEVOLUÇÃO PARA FABRICA' action nfe_Devolucao_fabrica()
					  separator
             	      menuitem 'EMISSÃO DE FICHA DE CLIENTE ' action FICHA_CLI()
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
  
                  define popup 'CONFIGURAÇAO'
                       menuitem 'TROCAR TIPO DE EMISSÃO' action CONTIGENCIA_NORMAL()
                         separator
                       menuitem 'CONFIGURAÇÃO PARA EMISSAO DE NFE/NFC_e' action {||Reconectar_A(), Config() }  
                      separator
	                    menuitem 'CADASTRO EMAIL ' action{||Reconectar_A(), Cria_EMAIL_Ini(),confirguaracao_Email() }  
                      separator
	

	
	
	
     end popup
       define popup 'NFE QUINTA'
         MENUITEM '&ENVIAR CLASS ' ACTION Inutiliza_NFCe_Class()
          MENUITEM '&CONSULTA TESTE CLASS400 ' ACTION Consultar_nfe4()      
	      MENUITEM '&CONSULTA TESTE enviar ' ACTION enviar_nfe_CLASS40()      
		 MENUITEM '&Gera xml to ini ' ACTION CriaXML()
		 MENUITEM '&IMPRIMIR ' ACTION imprimir_class()
		 MENUITEM '&SERVICO   ' ACTION NFeStatusServico()
		 MENUITEM '&CRIAR XML ACBR   ' ACTION crair_acbrxml() 
		 separator
		  MENUITEM '&CRIAR-NFCE ' ACTION ENVIAR_NFcE_class()
		 separator
		  MENUITEM '&Escolher Certificado' ACTION CapicomEscolheCertificado()
		 separator
		  MENUITEM '&pega dados xml' ACTION destinada1()
		   separator
		  MENUITEM '&cancelar' ACTION fCanc_Xml()
		   separator
		  MENUITEM '&Ler_arquivos' ACTION ler_arquivo()
	   separator
   MENUITEM '&Carto de correcao' ACTION MontaCartaCorrecao()
	   separator
	   MENUITEM '&Manifestação do Destinatário' ACTION Manifestacao_Destinatario("nfe_84712611000152" )
	   separator
	  MENUITEM '&validar gtim ' ACTION {||Reconectar_A(), ValidaEAN() }     //*reenviar.prg
	      separator
	   MENUITEM '&retirar_contigencia' ACTION {||Reconectar_A(), retirar_contigencia() }     //*reenviar.prg
	         separator
	   MENUITEM '&CEP' ACTION {||Reconectar_A(), CepAberto() }     //*reenviar.prg
	         separator
	   MENUITEM '&CNPJ' ACTION {||Reconectar_A(), pegacnpj()  }     //*reenviar.prg

	 
      END POPUP
			 
		    Popup 'TROCAR COR FUNDO'
           Item 'COLOR_DESKTOP_DARK_CYAN    ' Action ( Form_0.BackColor := COLOR_DESKTOP_DARK_CYAN    ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_GREEN   ' Action ( Form_0.BackColor := COLOR_DESKTOP_DARK_GREEN   ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_PURPLE  ' Action ( Form_0.BackColor := COLOR_DESKTOP_DARK_PURPLE  ,MyRefresh() )
           Item 'COLOR_DESKTOP_DARK_YELLOW  ' Action ( Form_0.BackColor := COLOR_DESKTOP_DARK_YELLOW  ,MyRefresh() )
           Item 'COLOR_DESKTOP_BRIGHT_GREEN ' Action ( Form_0.BackColor := COLOR_DESKTOP_BRIGHT_GREEN ,MyRefresh() )
           Item 'COLOR_DESKTOP_YELLOW_ORANGE' Action ( Form_0.BackColor := COLOR_DESKTOP_YELLOW_ORANGE,MyRefresh() )
           Item 'COLOR_BUTTONE_DARK_white   ' Action ( Form_0.BackColor := COLOR_BUTTONE_DARK_white,MyRefresh() )
		   Item 'COLOR_BUTTONE_DARK_AM1     ' Action ( Form_0.BackColor := COLOR_BUTTONE_DARK_am1,    MyRefresh() )
		   Item 'COLOR_BUTTONE_DARK_AM2     ' Action ( Form_0.BackColor := COLOR_BUTTONE_DARK_am2,    MyRefresh() )
		 *  Item 'COLOR_DESKTOP_YELLOW_ORANGE' Action compilacao()

		   
    
	End Popup
 
                  define popup 'BOLETOS'
                       menuitem 'GERA BOLETO' action Escolhe_Banco(1,1,1)
                       menuitem 'LISTA BOLETOS' action LISTA_BOLETOS()
                       menuitem 'REMESSA' action GERAR_ARQUIVO_REMESSA()
					   menuitem 'IMPORTADOR BOLETOS' action Importar_Boletos()
					   
                      separator
             end popup
			 
			 
  end menu
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
   LOCAL aBackgroundColor := Form_0.BackColor

   AADD(  aObjImage , { cObject,nRow,nCol } )  // add the item to refresh

	
   DEFINE IMAGE &cObject
      PARENT            Form_0
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

   
 * MSGINFO(aObjImage)
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
       nHeight2 := nHeight -660 + aObjImage[nI,2]  
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

        DEFINE MAIN MENU OF Form_0

        END MENU

Return

////////////////////////////////////////////////////////////
FUNCTION MyExit()          // Exit programm
* enviar_contigencia()
F_contigencia_acbr_class()  
 Confirmar_Saida()
 Confirmar_backup()
 
RETURN 


Function Confirmar_Saida()
If MSGYesNo( "Confirma Saída do Sistema??" )

Confirmar_backup()
HB_GCALL()
limpamemoriaram() 
HB_GCALL()
limpamemoriaram() 
Release Window ALL
QUIT
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



////////////////////////////////////////////////////////////
FUNCTION VENDA()          // Exit programm
VENDE_NFCE()

RETURN 

Function LinhaDeStatus(cMensagem)
	cMensagem := Iif( cMensagem == Nil , "Conectado no IP "+C_IPSERVIDOR+" "+cnomedobanco , AllTrim(cMensagem) )
	*Form_0.StatusBar.Item(1) := cMensagem
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
*form_0.StatusBar.Item(1) := cMen
Return 



#include "minigui.ch"
static FUNCTION llenarBR_Fic()
    local cDir :=DiskName()+":\"+CurDir()
    LOCAL aDir := DirectoryRecurse(cDir+"\"+"NFCE4P.exe")


	
   IF LEN(aDIR)>0
  *    Ventana1.BR_Fic.DisableUpdate
      FOR N=1 TO LEN(aDIR)
      RESUTADO:=({aDIR[N,1],STR(aDIR[N,2]),DTOC(aDIR[N,3]),aDIR[N,4],aDIR[N,5]})
  BEGIN INI FILE "NFCE.INI"       
		SET SECTION "DATACOMPILACAO" ENTRY "DATACOMPILACAO"    To RESUTADO
     END INI
	NEXT
  
   ENDIF


RETURN NIL


// --------------------------------------------------------------------------.

#pragma BEGINDUMP

#define HB_OS_WIN_32_USED
#define _WIN32_WINNT 0x0400
#include <windows.h>
#include "hbapi.h"

HB_FUNC (GETDESKTOPREALTOP) 
{
	RECT rect;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

	hb_retni(rect.top);

}
HB_FUNC (GETDESKTOPREALLEFT) 
{
	RECT rect;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

	hb_retni(rect.left);

}

HB_FUNC (GETDESKTOPREALWIDTH) 
{
	RECT rect;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

	hb_retni(rect.right - rect.left);

}

HB_FUNC (GETDESKTOPREALHEIGHT) 
{
	RECT rect;
       SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

	hb_retni(rect.bottom - rect.top);
}

#pragma ENDDUMP



//
// FUNCAO     : WVW_Size()
// PARAMETROS : nWindow - N§ da janela
//              hWnd    -
//              message -
//              wParam  -
//              lParam  -
// DESCRICAO  : Funcao CALLBACK que eh chamada depois que o tamanho da janela eh
//              alterado ( como quando for maximizada ou minimizada )
// RETORNO    :
//
RETURN NIL


static function SQL_Error_oQuery(  )
 
Public Retorno_SQL:=.t.

 
 	oQuery:=oServer:Query( cQuery )
 
	Abre_conexao_MySql()

	If oQuery:NetErr()												
       MsgStop("Erro SQL: "+oQuery:Error())
	    Retorno_SQL:=.f.

				if Retorno_SQL==.f.
			        HB_Cria_Log_venda(cUsuario,cQuery+chr(13)+chr(10)+oQuery:Error())
			      *HB_Cria_Log_venda(xNSEQ_ORC +'   INSERT INTO ITEMNFCE',oQuery:Error()+ xITENS)
				end                                                                       
	    
       Return .f.
	End 
 
 
return Retorno_SQL



        
