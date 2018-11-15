// Harbour MiniGUI                 
// (c)2011 -Jos� juca 
// Modulo : Emissor de Nota Fiscal
// 14/2/2011 12:12:12
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
Function NFE_Devolucao_da_nfce()
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
*PUBL printX:=GetDefaultPrinter()
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
publ cFileDanfe:="C:\ACBrMonitorPLUS\SAI.TXT"
  
xxx:=1

*ProcedureValidadeCertificado()
*ProcedureescreverINI_3()
*ProcedureLerINI()

Reconectar_A() 

CLOSE ALL
abreitemnfe()
abreDADOSNFE()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
abreseq_dav()


CLOSE ALL 
USE ((ondetemp)+"ITEMNFE.DBF") new alias ITEMNFE exclusive  VIA "DBFCDX" 
zap
PACK
USE ((ondetemp)+"DADOSNFE.DBF") new alias DADOSNFE exclusive   VIA "DBFCDX" 
zap
PACK
USE ((ondetemp)+"PEGAGT.DBF") new alias PEGAGT exclusive   VIA "DBFCDX" 
zap
PACK
USE ((ondetemp)+"PEGAICMS.DBF") new alias PEGAICMS exclusive   VIA "DBFCDX" 
zap
PACK

USE ((ondetemp)+"BOLETO.DBF") new alias BOLETO exclusive  VIA "DBFCDX" 
zap
PACK
 
close all 
abreDADOSNFE()
abreitemnfe()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
Reconectar_A() 


abreserienfce()
SELE serienfce             
xxCbdNtfSerie := (serienfce->serie)


terminal:= GetComputerName()
xxterminal :=terminal
xterminal:= ' "'+Upper(AllTrim(terminal))+'" '      

oQuery  :=oServer:Query( "SELECT wd ,hd, nLarguraTela,nAlturaTela  FROM configtela WHERE terminal= "+xterminal+"  " )
If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	     :=oQuery:GetRow(1)
nwd          :=oRow:fieldGet(1)
nhd          :=oRow:fieldGet(2)
nLarguraTela :=oRow:fieldGet(3)
nAlturaTela  :=oRow:fieldGet(4)
  
	



oQuery  :=oServer:Query( "SELECT max(CbdNtfNumero) FROM NFE20 WHERE cbdmod= "+"55"+" and CbdNtfSerie = "+ntrim(Serie_nfe)+"  Order By CbdNtfNumero" )
oRow := oQuery:GetRow(1)
oRow          := oQuery:GetRow(1)
sSnumero:=((oRow:fieldGet(1)))
snumero:=Ssnumero+1 



if GERA_NFE_NFCE=1
 BEGIN INI FILE "C:\ACBrMonitorPLUS\ACBrMonitor.INI"
      SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '0'
    END INI	 
	 cRet       := MON_ENV("ACBr.lerini")
endif

	


DEFINE WINDOW NFe;
       at 000,000;
       WIDTH nwd ;
       HEIGHT nhd-40;
       TITLE 'NFe' ICON "ICONE01";
       MODAL;
       NOSIZE;
	   ON INIT {NFE.txt_DAV.setfocus}	
	   
     ON KEY ESCAPE OF NFe ACTION { ||NFe.RELEASE }
 
 
  DEFINE STATUSBAR of NFe	FONT "MS Sans Serif" SIZE 10
    STATUSITEM "Conectado no IP: "+C_IPSERVIDOR+" "+basesql WIDTH 150 	
          DATE
          CLOCK
          KEYBOARD
	   STATUSITEM ""+AllTrim( NetName() ) WIDTH 150 
	  END STATUSBAR
	
	
	
	
 DEFINE RADIOGROUP Rdg_TIPO
            ROW    00
            COL    21
            WIDTH  84
			value  2
            HEIGHT 17
            OPTIONS {'Saida','Entrada'}
            READONLY NIL
            ON ENTER NFe.Txt_Emitente.SETFOCUS
            FONTSIZE 8
            FONTNAME "Arial"
     END RADIOGROUP  

//***************************************	 
		 
	 
     DEFINE LABEL Lbl_Emitente
            ROW    50
            COL    21
            WIDTH  150
            HEIGHT 80
            VALUE "0-Emiss�o Pr�pria "
            FONTSIZE 8
            FONTNAME "Arial"
     END LABEL  
	 
     DEFINE LABEL Lbl_Emitente1
	        ROW    70
            COL    21
            WIDTH  150
            HEIGHT 80
            VALUE "1-Terceiros"
            FONTSIZE 8
            FONTNAME "Arial"
     END LABEL  
	 
     DEFINE TEXTBOX Txt_Emitente
            ROW    70
            COL    85
            WIDTH  30
            HEIGHT 25
            INPUTMASK "9"
            VALUE 0
            NUMERIC  .T.
	        ON GOTFOCUS This.BackColor:=clrBack 
   	         ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 10
            FONTNAME "Arial"
     END TEXTBOX 
 	 

     DEFINE LABEL Lbl_DTDOC
            ROW    05
            COL    130
            WIDTH  100
            HEIGHT 20
            VALUE "Data da Emiss�o"
            FONTSIZE 9
            FONTNAME "Arial"
     END LABEL  

     DEFINE DATEPICKER Txt_DTDOC
            ROW    25
            COL    130
            WIDTH  90
            HEIGHT 24
            VALUE DATE() 
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
		    TITLEFONTCOLOR {255,128,64}
            FONTSIZE 10
            FONTNAME "Arial"
     END DATEPICKER  

     DEFINE LABEL Lbl_DTES
            ROW    45
            COL    130
            WIDTH  100
            HEIGHT 20
            VALUE "Data da Saida"
            FONTSIZE 10
            FONTNAME "Arial"
     END LABEL  

     DEFINE DATEPICKER Txt_DTES
            ROW    65
            COL    130
            WIDTH  90
            HEIGHT 24
	        DATE .T.
	        VALUE DATE()
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 10
            FONTNAME "Arial"
     END DATEPICKER 
//////////////////////////////////////////////////////////////////
	 
		 
	//**************************
     DEFINE LABEL Lbl_NOTA
            ROW    05
            COL    230
            WIDTH  100
            HEIGHT 30
            VALUE "N.� NOTA:"
            FONTBOLD .T.
            FONTSIZE 10
            FONTNAME "Arial"
     END LABEL  

     DEFINE TEXTBOX Txt_NOTA
            ROW    25
            COL    230
            WIDTH  60
			VALUE snumero
            HEIGHT 20
            INPUTMASK "9999999"
	        NUMERIC .T.
			RIGHTALIGN .F. 
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 10
            FONTNAME "Arial"
		    MAXLENGTH 300	 	
            ON enter { ||IF (empty(NFe.Txt_NOTA.VALUE),msginfo("Favor informar o numero da nota fiscal"),nil),IF (empty(NFe.Txt_NOTA.VALUE),NFe.Txt_NOTA.setfocus,nil )}
     END TEXTBOX 

     DEFINE LABEL Lbl_Serie
            ROW   50
            COL    230
            WIDTH  60
            HEIGHT 20
            VALUE "S�rie"
            FONTSIZE 09
            FONTNAME "Arial"
     END LABEL  

     DEFINE TEXTBOX Txt_SERIE
            ROW   50
            COL   280
            WIDTH  15
            HEIGHT 20
            VALUE ntrim(Serie_NFE)
            MAXLENGTH 3 	
            UPPERCASE  .T.
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 8
            FONTNAME "Arial"
     END TEXTBOX 
	 
	
	 
     DEFINE FRAME Frame_DADOSNOTA1
            ROW    03
            COL    00
            WIDTH  118
            HEIGHT 110
            OPAQUE .T.
            FONTSIZE 10
            FONTNAME "Arial"
     END FRAME  
	 
	//*********************** 
	 
     DEFINE FRAME Frame_DADOSNOTA
            ROW    03
            COL    120
            WIDTH  280
            HEIGHT 110
            OPAQUE .T.
            FONTSIZE 10
            FONTNAME "Arial"
     END FRAME  
	 
	 
     DEFINE FRAME Frame_DADOSNOTA_3
            ROW    03
            COL   405
            WIDTH 610
            HEIGHT 110
            OPAQUE .T.
            FONTSIZE 10
            FONTNAME "Arial"
     END FRAME  
///////////////////////////////////////////

  
  
	
 ////////////////////////////////////////
      DEFINE RADIOGROUP oRad3 
            ROW 05
            COL  300
            WIDTH  100
			value 1
            HEIGHT 8
            OPTIONS {'Digite nfc_e','Digite nfe'}
            READONLY NIL
		    on gotfocus NFe.textBTN_cliente.SETFOCUS
            FONTSIZE 10
            FONTNAME "Arial"
			ON change {||MostraOBS()}
		END RADIOGROUP  
    
	
	
 ////////////////////////////////////////
      DEFINE RADIOGROUP SERIE_1
            ROW 05
            COL  520
            WIDTH  100
			value 1
            HEIGHT 8
            OPTIONS {'Digite Serie'}
            READONLY NIL
		    on gotfocus NFe.textBTN_cliente.SETFOCUS
            FONTSIZE 10
            FONTNAME "Arial"
			ON change {||MostraOBS()}
		END RADIOGROUP  
    
	
					
DEFINE RADIOGROUP oRad2 
            ROW  55
            COL  300
            WIDTH 60
			value 1
            HEIGHT 0
            OPTIONS {'Parcial','Total'}
            READONLY NIL
		    on gotfocus NFe.textBTN_cliente.SETFOCUS
            FONTSIZE 9
            FONTNAME "Arial"
			ON change {||atualizador_cliene() }
		END RADIOGROUP  	
	
	
	   
 @ 05,430 textBTN txt_DAV;
		           of nfe;
		           width 80;
                   HEIGHT 20;
                   value "";
				   font 'verdana';
                   size 10;
                   FONTCOLOR { 255, 000, 000 };
                   BACKCOLOR { 255, 255, 255 };   
                   maxlength 40;
		           rightalign
		//////////////////////////////////////////////////

	
	    DEFINE TEXTBOX Txt_SERIE_1
            ROW   05
            COL   610
            WIDTH  15
            HEIGHT 20
            VALUE ""
            MAXLENGTH 3 	
            UPPERCASE  .T.
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 8
            FONTNAME "Arial"
         ON enter {||PESQ_PVENDA_22(),peganfe()}
     END TEXTBOX 
		

		
		
          DEFINE LABEL Lbl_ambiente
               ROW   30
               COL  500
               WIDTH  60
               HEIGHT 22
               VALUE "Ambiente"
               FONTSIZE 09
               FONTNAME "Arial"
        END LABEL  	 
  
   DEFINE TEXTBOX Txt_Ambiente
            ROW   30
            COL   600
            WIDTH  25
            HEIGHT 20
            VALUE  cAMBIENTE
            MAXLENGTH 5	
            UPPERCASE  .T.
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 8
            FONTNAME "Arial"
     END TEXTBOX 
		
 @ 50,410 LABEL oSay223 ;
   WIDTH 80 ;
   HEIGHT 20;
   VALUE "F8-Procura"  ;
   FONT 'Times New Roman'SIZE 10.00 ;
   BACKCOLOR {242,242,242}
   
   
@  50,500 textBTN textBTN_cliente;
	      numeric;
	      width 65;
	      value 983;
		  FONT 'Times New Roman' ;
          SIZE 12 FONTCOLOR; 
          BLUE BOLD BACKCOLOR {255,255,0};        
          tooltip 'Digite o c�digo ou clique na LUPA para pesquisar';
		  picture cPathImagem+'lupa.bmp';
		  maxlength 8;
		  rightalign;	   
	      Action {||GetCode_cli(,NFE.textBTN_cliente.setfocus)};
		  ON ENTER {||iif(!Empty(NFE.textBTN_cliente.Value),pesq_cli(),NFE.textBTN_cliente.setfocus) };
          on gotfocus (CHANGETEXTBTNSTATE(GetControlHandle('textBTN_cliente','NFE'),1),(NFE.textBTN_cliente.backcolor := {255,255,196}))

		  ON KEY F8 ACTION { || GetCode_cli()} 

				
	
			    @ 50,570 TEXTBOX  Txt_NOMECLI ;
				WIDTH 440 ;
				HEIGHT 28;
				BOLD BACKCOLOR {191,225,255};
				ON GOTFOCUS setControl(.T.);
				ON LOSTFOCUS setControl(.F.) NOTABSTOP
	
	
           				
          DEFINE LABEL Lbl_CODSIT
               ROW 80
               COL  410
               WIDTH  60
               HEIGHT 22
               VALUE "Cfop"
               FONTSIZE 09
               FONTNAME "Arial"
        END LABEL  	 
  
	 
	   @ 80,500 textBTN textBTN_cfop;
		   numeric;
		   width 60;
		   value 5102;
		   tooltip 'Digite o c�digo ou clique na LUPA para pesquisar';
		   picture cPathImagem+'lupa.bmp';
		   maxlength 100;
		   rightalign;
           action (getcode_cfop('nfe ','textBTN_cfop'),(nfe .textBTN_cfop.value,1));
           on enter { ||PESQ_cfop()};
    	   on gotfocus (CHANGETEXTBTNSTATE(GetControlHandle('textBTN_cfop','nfe'),1),(nfe.textBTN_cfop.backcolor := {255,255,196}))
      

		   //////////////////////////////////////////////////////////////////////////////////////
			
             				
				
     DEFINE TEXTBOX  Txt_natu
            ROW  80
            COL 570
            WIDTH  440
            HEIGHT 28
            VALUE ""
            NUMERIC  .F.
			BACKCOLOR {191,225,255}
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 9
            FONTNAME "Arial"
     END TEXTBOX 

  
          DEFINE LABEL servico
               ROW  120
               COL  00
               WIDTH 200
               HEIGHT 22
			   FONTCOLOR { 0, 000, 255 }
               BACKCOLOR { 240, 240, 240 } 
             *  VALUE "SITUA��O DO SERVI�O.:"
               FONTSIZE 10
               FONTNAME "Arial"
        END LABEL  	 
  
  
       DEFINE LABEL Servico1
            ROW   120
            COL    190
            WIDTH  80
            HEIGHT 24
            VALUE ""
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .T.
            BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
          *  BORDER .T.
          * CLIENTEDGE .T.
          *  HSCROLL .T.
          *  VSCROLL .T.
          *  BLINK .T.
     END LABEL

   
      DEFINE LABEL gerando_XML
           * of oForm2
		    ROW   105
			COL    10
            WIDTH  1000
            HEIGHT 70
            VALUE "" 
			FONTNAME 'Arial'
            FONTSIZE 15
            FONTBOLD .F.
            TRANSPARENT .F.
            AUTOSIZE .f.
          * FONTCOLOR {000, 000, 164}
	   	  * BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
            BORDER .T.
            CLIENTEDGE .T.
 		  BLINK .F.
  END LABEL 
  
     DEFINE LABEL gerando_xml1
            ROW   150
            COL    190
            WIDTH  80
            HEIGHT 24
            VALUE ""
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .T.
            BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
          END LABEL
  
   DEFINE LABEL VALIDANDO_XML
               ROW  120
               COL  270
               WIDTH 200
               HEIGHT 22
			   FONTCOLOR { 00, 000, 255 }
               BACKCOLOR { 240, 240, 240 } 
             *  VALUE "VALIDANDO XML.........:"
               FONTSIZE 10
               FONTNAME "Arial"
        END LABEL  	 
 
   DEFINE LABEL VALIDANDO_XML1
            ROW   120
            COL    450
            WIDTH  80
            HEIGHT 24
            VALUE ""
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .T.
            BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
         *   BORDER .T.
          * CLIENTEDGE .T.
          *  HSCROLL .T.
          *  VSCROLL .T.
          *  BLINK .T.
     END LABEL
  
  
    DEFINE LABEL ASSINADO_XML
               ROW  150
               COL  270
               WIDTH 200
               HEIGHT 22
			   FONTCOLOR { 00, 000, 255 }
               BACKCOLOR { 240, 240, 240 } 
            *   VALUE "ASSINANDO XML.......:"
               FONTSIZE 10
               FONTNAME "Arial"
        END LABEL  	 
 
  
  
    DEFINE LABEL ASSINANDO_XML1
            ROW   150
            COL    450
            WIDTH  80
            HEIGHT 24
            VALUE ""
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .T.
            BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
         *   BORDER .T.
          * CLIENTEDGE .T.
          *  HSCROLL .T.
          *  VSCROLL .T.
          *  BLINK .T.
     END LABEL
  
  
  DEFINE LABEL email_XML
            ROW   120
            COL   480
            WIDTH  80
            HEIGHT 24
            VALUE ""
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .T.
            BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
          *  BORDER .T.
          * CLIENTEDGE .T.
          *  HSCROLL .T.
          *  VSCROLL .T.
          *  BLINK .T.
     END LABEL
  
  
     DEFINE LABEL PROTOCOLO_XML
            ROW   120
            COL   600
            WIDTH  80
            HEIGHT 24
            VALUE ""
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .T.
            BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
           * BORDER .T.
          * CLIENTEDGE .T.
          *  HSCROLL .T.
          *  VSCROLL .T.
          *  BLINK .T.
     END LABEL
  
		
   DEFINE LABEL AUTORIZACAO_XML
            ROW   150
            COL   480
            WIDTH  80
            HEIGHT 24
            VALUE ""
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .T.
            BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
      *      BORDER .T.
          * CLIENTEDGE .T.
          *  HSCROLL .T.
          *  VSCROLL .T.
          *  BLINK .T.
     END LABEL
 
 
 
 

 

DEFINE TAB Tab_Movimento AT 180,00;
 WIDTH 1020;
 HEIGHT 420;
 VALUE 1

 
 
 

 PAGE "Produtos" 
       

   	DEFINE EDITBOX Edit_Aplicacao
               ROW    20
               COL    05
	           VALUE   '' 
               WIDTH  1000
               HEIGHT 60
               MAXLENGTH 2000
        END EDITBOX  
		
	 
		
   DEFINE LABEL Txt_CLIENTE_1
            ROW  80
            COL   05
            WIDTH  80
            HEIGHT 24
            VALUE "Dados do cliente que esta Efetuando a Devolu��o (NOME e CPF"
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .T.
            BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
       END LABEL
	 
	 			
     DEFINE TEXTBOX  Txt_CLIENTE
            ROW  80
            COL 360
            WIDTH  620
            HEIGHT 28
            VALUE ""
            NUMERIC  .F.
			BACKCOLOR {191,225,255}
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 9
            FONTNAME "Arial"
		   ON ENTER  atualizador_cliene()
     END TEXTBOX 

	   
	@ 110,05 GRID fita ;
	    WIDTH 1020+nLarguraTela  ;
		HEIGHT 300 ;
	    WIDTHS {50,110,380,80,50,90,100,100,80,60,80,80,60,150 };
        HEADERS {'Itens','Codigo','Descri��o','Ncm','Und.','Qtd','Valor R$','Desc.R$','Sub-Total R$','%Icms','STB','CFOP','ICMS','ID'};
        VALUE 1 ;			
   		FONT "Times New Roman" SIZE 10 BOLD ;
	    backcolor WHITE;  
	    fontcolor BLUE ;
		on dblclick Get_Fields(2);
		Justify {1,0,0,0,1,1,1,1,1,1,1,1,1,1,1};
		On change {||MostraOBS()} 
	
   END PAGE

   
 
 
        PAGE "Dados do Destinat�rio"
		
     DEFINE TEXTBOX Txt_TIPO
            ROW   20
            COL   300
            WIDTH  40
            HEIGHT 20
            VALUE ""
            NUMERIC  .F.
	        ON GOTFOCUS This.BackColor:=clrBack 
   	         ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 9
            FONTNAME "Arial"
     END TEXTBOX 
			   
     DEFINE LABEL Lbl_TOPI
	        ROW    20
            COL   350
            WIDTH  300
            HEIGHT 20
            VALUE "F-Fisica J=Juridica P=Produtor Rual I=ISENTO"
            FONTSIZE 9
            FONTNAME "Arial"
     END LABEL  
	 
 	 
**********************************************************                
				@ 040,010 LABEL   DESTINO ;   
			      VALUE "FAVORECIDO" ;
				  SIZE 10 AUTOSIZE 
	
             	@ 040,093 TEXTBOX T_NOMECLI;
				  WIDTH 370;
				  HEIGHT 28;
				  VALUE ""  ;
				  BACKCOLOR {191,225,255};
				  UPPERCASE ;
				  ON GOTFOCUS setControl(.T.);
				  ON LOSTFOCUS setControl(.F.)

    ***********************************************

**********************************************************                
				@ 070,010 LABEL   lEndereco ;   
			      VALUE "ENDERE�O" ;
				  SIZE 10 AUTOSIZE 
	
             	@ 070,093 TEXTBOX Txt_ENDCLI;
				  WIDTH 370;
				  HEIGHT 28;
				  VALUE ""  ;
				  BACKCOLOR {191,225,255};
				  UPPERCASE ;
				  ON GOTFOCUS setControl(.T.);
				  ON LOSTFOCUS setControl(.F.)
***********************************************
	
	
	@ 063,0500 LABEL  NUMCLI ;   
			      VALUE "NUMERO" ;
				  SIZE 10 AUTOSIZE 
				  
	         	@ 060,580 TEXTBOX Txt_NUMCLI;
				  WIDTH 40;
				  HEIGHT 28;
				  VALUE ""  ;
				  BACKCOLOR {191,225,255};
				  UPPERCASE ;
				  ON GOTFOCUS setControl(.T.);
				  ON LOSTFOCUS setControl(.F.)

	
					   
					   
*****************************************************************************					   
                       @ 063,633 LABEL   lBairro ;
					   VALUE "BAIRRO" ;
					   SIZE 10 AUTOSIZE
					
					@ 060,700 TEXTBOX Txt_BAIRROCLI ;
					WIDTH 275;
					HEIGHT 28;
					VALUE "" ;
					BACKCOLOR {191,225,255};
					UPPERCASE MAXLENGTH 20 ;
					ON GOTFOCUS setControl(.T.);
					ON LOSTFOCUS setControl(.F.)
                   
**************************************************************************					   
                       @ 098,010 LABEL   lCep ;
					   VALUE "CEP"  ;
					   SIZE 10 AUTOSIZE 
					
					@ 095,093 TEXTBOX Txt_CEPCLI  ;
					WIDTH 095;
					HEIGHT 28;
					VALUE ""  ;
					BACKCOLOR {191,225,255};
					INPUTMASK "99999999";
					ON ENTER Nil;
					ON GOTFOCUS setControl(.T.);
					ON LOSTFOCUS setControl(.F.)
***********************************************************
                   @ 098,190 LABEL   lIBGE ;
				   VALUE "IBGE" ;
			       SIZE 10 AUTOSIZE
							
					@ 095,230 TEXTBOX textBTN_IBGE  ;
					WIDTH 090;
					HEIGHT 28;
					VALUE ""  ;
					BACKCOLOR {191,225,255};
					INPUTMASK "99999999";
					ON ENTER Nil;
					ON GOTFOCUS setControl(.T.);
					ON LOSTFOCUS setControl(.F.)
				
**********************************************************************************
                       @ 098,325 LABEL   lCidade ;
					   VALUE "CIDADE" ;
					   SIZE 10 AUTOSIZE
					   
                       @ 095,380 TEXTBOX Txt_CIDCLI;
 					   WIDTH 320;
					   HEIGHT 28 ;
					   VALUE "" ;
					   BACKCOLOR {191,225,255};
					   UPPERCASE MAXLENGTH 30 ;
					   ON GOTFOCUS setControl(.T.);
					   ON LOSTFOCUS setControl(.F.)
     ************************************************************************              					
	                   @ 098,710 LABEL   lTelefone ;
					   VALUE "TELEFONE" ;
					   SIZE 10 AUTOSIZE 
	
	                   @ 095,795 TEXTBOX tTelefone ;
					   WIDTH 180;
					   HEIGHT 28;
					   VALUE "" ;
					   BACKCOLOR {191,225,255};
					   INPUTMASK "99999999999999";
					   ON GOTFOCUS setControl(.T.);
					   ON LOSTFOCUS setControl(.F.)
       ***********************************************************************     

                         @ 133,490 LABEL   lUF ;
                         VALUE "UF." ;
                         SIZE 10 AUTOSIZE

                      @ 133,540 TEXTBOX Txt_UFCLI ;
					   WIDTH 40;
					   HEIGHT 28;
					   VALUE "" ;
					   BACKCOLOR {191,225,255};
					   ON GOTFOCUS setControl(.T.);
					   ON LOSTFOCUS setControl(.F.)
 
   
      **********************************************************	   
	
                       @ 133,010 LABEL   lCNPJ ;
					   VALUE "CNPJ/CPF";
					   SIZE 10 AUTOSIZE
					   
                        @ 130,093 TEXTBOX Txt_CNPJ ;
						WIDTH 165;
						HEIGHT 28;
						VALUE "" ;
						BACKCOLOR {191,225,255};
						ON GOTFOCUS setControl(.T.);
						ON LOSTFOCUS setControl(.F.)
       ************************************************************************              

	               	@ 133,290 LABEL   lIE ;
					VALUE "I.E.";
					SIZE 10 AUTOSIZE 
                   
 				   @ 130,318 TEXTBOX Txt_IECLI ;
				   WIDTH 155;
				   HEIGHT 28;
				   VALUE "" ;
				   BACKCOLOR {191,225,255};
				   MAXLENGTH 18 ;
				   ON GOTFOCUS setControl(.T.);
				   ON LOSTFOCUS setControl(.F.)
     *************************************************************
   	 				   
                       @ 168,010 LABEL   lEmail;
					   VALUE "eMail";
					   SIZE 10 AUTOSIZE 
					   
					   		
		      @ 168,93 TEXTBOX Txt_email  ;
				   WIDTH 155;
				   HEIGHT 28;
				   VALUE "" ;
				   BACKCOLOR {191,225,255};
				   MAXLENGTH 18 ;
				   ON GOTFOCUS setControl(.T.);
				   ON LOSTFOCUS setControl(.F.)
    
****************************************************************	
	             @ 168,320 LABEL   lPais  ;
						VALUE "PA�S" ;
						SIZE 10 AUTOSIZE 
						
			@ 168,380 TEXTBOX Txt_pais ;
				   WIDTH 155;
				   HEIGHT 28;
				   VALUE "BRASIL" ;
				   BACKCOLOR {191,225,255};
				   MAXLENGTH 18 ;
				   ON GOTFOCUS setControl(.T.);
				   ON LOSTFOCUS setControl(.F.)
*****************************************************************
							
  		    @ 210,005 FRAME    fDados2    ;
			WIDTH 980;
			HEIGHT 100;
			CAPTION "Endere�o para Entrega";
			FONT "Arial" SIZE 13 Italic ;
			BACKCOLOR {191,225,255};
			FONTCOLOR {191,225,255}
		

        ******************************************************           
   				   @ 238,010 LABEL  ENDCLI ;
					   VALUE "ENDERE�O" ;
					   SIZE 10 AUTOSIZE 
         
        		 @ 240,093 TEXTBOX  Txt_ENDCLI1;
					   WIDTH 580;
					   HEIGHT 28;
					   VALUE "" ;
					   BACKCOLOR {191,225,255};
					   UPPERCASE ;
					   ON GOTFOCUS setControl(.T.);
					   ON LOSTFOCUS setControl(.F.)
        ************************************
		               @ 271,010 LABEL    lCep2 ;
					   VALUE "CEP" ;
					   SIZE 10 AUTOSIZE 

				       @ 270,093 TEXTBOX  Txt_CEPCLI1 ;
					   WIDTH 095 ;
					   HEIGHT 28;
					   VALUE "" ;
					   BACKCOLOR {191,225,255};
					   INPUTMASK "99999999";
					   ON ENTER Nil;
					   ON GOTFOCUS setControl(.T.);
					   ON LOSTFOCUS setControl(.F.)
           **************************************************************                 
                       @ 271,205 LABEL    lCidade2  ;
             		   VALUE "CIDADE" ;
		               SIZE 10 AUTOSIZE
               
			          @ 270,280 TEXTBOX  Txt_CIDCLI1 ;
			          WIDTH 320;
			          HEIGHT 28 ;
			          VALUE "";
			          BACKCOLOR {191,225,255};
					  UPPERCASE;
					  MAXLENGTH 30;
					  ON GOTFOCUS setControl(.T.);
					  ON LOSTFOCUS setControl(.F.)
           **************************************************     		
		             @ 271,633 LABEL    lBairro2   ;
					 VALUE "BAIRRO" ;
					 SIZE 10 AUTOSIZE 
					   
                   @ 270,700 TEXTBOX  Txt_BAIRROCLI1 ;
				   WIDTH 275;
				   HEIGHT 28;
				   VALUE "";
				   BACKCOLOR {191,225,255};
				   UPPERCASE MAXLENGTH 20  ;
				   ON GOTFOCUS setControl(.T.);
				   ON LOSTFOCUS setControl(.F.)

			   *                      // Transportadora
                       @ 315,005 FRAME    fDados3        WIDTH 980 HEIGHT 90 CAPTION "Dados da Transportadora" FONT "Arial" SIZE 13 Italic FONTCOLOR {191,225,255}
                       @ 346,010 LABEL    lPlaca         VALUE "PLACA"          SIZE 12 AUTOSIZE 
                       @ 346,115 LABEL    lTransport     VALUE "RAZ�O SOCIAL"     SIZE 12 AUTOSIZE 
                       @ 346,580 LABEL    lESTA          VALUE "UF"     SIZE 12 AUTOSIZE 
                       @ 346,740 LABEL    lCNPJTrans     VALUE "CNPJ/CPF"         SIZE 12 AUTOSIZE 
				
					   
					   @ 370,015 TEXTBOX  tPLACA         WIDTH 50  HEIGHT 28 VALUE "" BACKCOLOR {191,225,255} UPPERCASE MAXLENGTH 60 NOTABSTOP ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
                       @ 370,115 TEXTBOX  tTransport     WIDTH 450 HEIGHT 28 VALUE "" BACKCOLOR {191,225,255} UPPERCASE MAXLENGTH 60 NOTABSTOP ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
                       @ 370,590 TEXTBOX  tUF            WIDTH 050 HEIGHT 28 VALUE "" BACKCOLOR {191,225,255} UPPERCASE MAXLENGTH 60 NOTABSTOP ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
                       @ 370,740 TEXTBOX  tCNPJTrans     WIDTH 235 HEIGHT 28 VALUE "" BACKCOLOR {191,225,255}                        NOTABSTOP  ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
       END PAGE
				   
	
  				   
 PAGE "Referenciar Notas Fiscal"
 
  
  
  @ 50,10 TEXTBOX  txt_nfecc ;
				WIDTH 60 ;
				HEIGHT 28;
				BOLD BACKCOLOR {191,225,255}
	 
  
    @ 50,250 TEXTBOX  Txt_chave ;
				WIDTH 440 ;
				HEIGHT 28;
				BOLD BACKCOLOR {191,225,255}
	 
		  
		   
  END PAGE

  
  
                END TAB
				
                @ 600,010 LABEL    LabelPesoLiq        VALUE "Peso Liquido"      AUTOSIZE
                @ 600,130 LABEL    LabelPesoBru        VALUE "Peso Bruto"        AUTOSIZE
                @ 600,250 LABEL    LabelVolumes        VALUE "Volumes"           AUTOSIZE
                @ 600,330 LABEL    LabelSubTotal       VALUE "Sub Total"         AUTOSIZE
                @ 600,430 LABEL    LabelDesTotal1      VALUE "Descontos %"       AUTOSIZE 
				@ 600,530 LABEL    LabelDesTotal       VALUE "Descontos R$"      AUTOSIZE
                @ 600,650 LABEL    LabelGerTotal       VALUE "Total Geral"       AUTOSIZE
                @ 600,770 LABEL    LabelICMTotal       VALUE "Total ICMS"        AUTOSIZE
                @ 600,890 LABEL    LabelPISTotal       VALUE "Total IPI"         AUTOSIZE

                @ 620,010 TEXTBOX  tPesoLiq            VALUE 0.000        WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "99,999.999" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,130 TEXTBOX  tPesoBru            VALUE 0.000        WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "99,999.999" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,250 TEXTBOX  tVolumes            VALUE 0            WIDTH 60  HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999"         ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,330 TEXTBOX  Txt_total           VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,430 TEXTBOX  Txt_desconto1       VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,530 TEXTBOX  Txt_desconto        VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
             
 			 @ 620,650 TEXTBOX  Txt_valortotal ;
			 VALUE 0.00  ;
			 WIDTH 100;
			 HEIGHT 28;
			 BOLD BACKCOLOR {191,225,255};
			 NUMERIC INPUTMASK "999,999.99";
			 ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP

  			    @ 620,770 TEXTBOX  tValorICMS          VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,890 TEXTBOX  tValorIPI           VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 650,005 BUTTON   btGravar           CAPTION "Gera Nfe"           FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION {||gravavda_CLI(),GRAVAENVIA2()}
                @ 650,136 BUTTON   btExcluir           CAPTION "Exclui Itens"      FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT        Action   {|| Refresh_3(),refreshprintgrid() }  
     			@ 650,880 BUTTON   btCancelar          CAPTION "Voltar"            FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION nfe.Release
               ON KEY ESCAPE ACTION nfe.Release
         END WINDOW

 
		 nfe.textBTN_cfop.value:=5102
		// cNotaFiscal:=12
	   ACTIVATE WINDOW nfe
	  Return NIL

	  
	  
*-------------------------------------------------------------------------------
static function excluir_ITENS()
Local ID      :=(VAL((GetColValue( "FITA", "NFE", 14 ))))

       dbselectarea('ITEMNFE')
       ITEMNFE->(ordsetfocus('VERIFICA'))
       ITEMNFE->(dbgotop())
       ITEMNFE->(dbseek(id))

       if .not. found()
          msgexclamation('Selecione uma informa��o','Aten��o')
          ITEMNFE->(ordsetfocus('DESCRICAO'))
          return(nil)
       else
          if msgyesno('ITEM  :'+STR(ITEMNFE->ITENS)+"   "+ITEMNFE->PRODUTO +"  "+alltrim(ITEMNFE->DESCRICAO),'Excluir')
             if lock_reg()
                ITEMNFE->(dbdelete())
                ITEMNFE->(dbunlock())
                ITEMNFE->(dbgotop())
             endif
             ITEMNFE->(ordsetfocus('DESCRICAO'))
          Refresh_2()
	   endif
       endif
return(nil)

*--------------------------------------------------------------*
STATIC Function  Get_Fields( status )    
*--------------------------------------------------------------*
Local ID      :=(VAL((GetColValue( "FITA", "NFE", 14 ))))

CLOSE ALL
abreitemnfe()
abreDADOSNFE()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
abreseq_dav()


       dbselectarea('ITEMNFE')
       ITEMNFE->(ordsetfocus('VERIFICA'))
       ITEMNFE->(dbgotop())
       ITEMNFE->(dbseek(id))

       if .not. found()
          msgexclamation('Selecione uma informa��o','Aten��o')
          ITEMNFE->(ordsetfocus('DESCRICAO'))
          return(nil)
       else
	   
   

Define WINDOW oForm2 ;
       AT 302, 285 ;
       WIDTH 535 ;
       HEIGHT 202 ;
       icon cPathImagem+'JUMBO1.ico';
       modal;
       nosize
	

      	ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela
    

   @ 012, 005   LABEL oSay1 ;
   WIDTH 056 ;
   HEIGHT 016 ;
   VALUE "Itens"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 255 };
   BACKCOLOR { 240, 240, 240 }




   @ 043, 002   LABEL oSay2 ;
   WIDTH 20 ;
   HEIGHT 016 ;
   VALUE STR(ITEMNFE->ITENS)  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
    FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 012, 40   LABEL oSayu1 ;
   WIDTH 056 ;
   HEIGHT 016 ;
   VALUE "ID"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 255 };
   BACKCOLOR { 240, 240, 240 }




   @ 043, 40   LABEL id ;
   WIDTH 70 ;
   HEIGHT 016 ;
   VALUE STR(ID)  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
    FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 012, 110   LABEL oSay3 ;
   WIDTH 061 ;
   HEIGHT 016 ;
   VALUE "Codigo"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 255 };
   BACKCOLOR { 240, 240, 240 }


   @ 042, 110 LABEL oSay4 ;
   WIDTH 098 ;
   HEIGHT 016 ;
   VALUE ITEMNFE->PRODUTO  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 009, 220   LABEL oSay5 ;
   WIDTH 072 ;
   HEIGHT 016 ;
   VALUE "Descricao"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 255 };
   BACKCOLOR { 240, 240, 240 }


   @ 042, 220  LABEL oSay6 ;
   WIDTH 250 ;
   HEIGHT 016 ;
   VALUE alltrim(ITEMNFE->DESCRICAO) ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 015, 394   LABEL oSay7 ;
   WIDTH 082 ;
   HEIGHT 016 ;
   VALUE "Quantidade"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 255 };
   BACKCOLOR { 240, 240, 240 }

   
      @ 036, 395   TEXTBOX xqtd ;
                   width 080;
                   value  ITEMNFE->qtd;
                   numeric inputmask  '99,999.999'



   @ 101, 403   BUTTON oBut1 ;
   CAPTION "Grava"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
    action  grava_qtd()


   @ 090, 012   BUTTON oBut2 ;
   CAPTION "Sair"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
   ACTION ThisWindow.release
   
   endif
   


END WINDOW
ACTIVATE WINDOW oForm2
   
return(nil)




function grava_qtd()
Local ID        :=VAL(oForm2.id.value)
Local xqtd      :=oForm2.xqtd.value
local ydesconto:=0

       dbselectarea('ITEMNFE')
       ITEMNFE->(ordsetfocus('VERIFICA'))
       ITEMNFE->(dbgotop())
       ITEMNFE->(dbseek(id))

            
xSUBTOTAL:=ITEMNFE->valor*xqtd
xdesconto:=ITEMNFE->valor_desc
ydesconto:=xSUBTOTAL*xdesconto/100                    
		


	   
        if lock_reg()
                ITEMNFE->DEVOL :=1
			    ITEMNFE->qtd   :=xqtd
				ITEMNFE->SUBTOTAL       := xSUBTOTAL 
			    ITEMNFE->(dbunlock())
                ITEMNFE->(dbgotop())
                ITEMNFE->(ordsetfocus('DESCRICAO'))
          Refresh_2()
	  endif
	  
	  
	  
	  
sele DADOSNFE
	   
        if lock_reg()
                DADOSNFE-> desc2:=ydesconto
			    DADOSNFE->(dbunlock())
                DADOSNFE->(dbgotop())
          Refresh_2()
	  endif
	  
	  
	  
	  
    ThisWindow.release
return




STATIC function refreshprintgrid()
if NFE.FITA.itemcount > 0
   NFE.FITA.value := NFE.FITA.itemcount
endif

return nil

	  
	  

function Refresh_2()
Static lGridFreeze := .t.
abreITEMNFE()
IF ISWINDOWDEFINED(NFE)
   delete item all from FITA of NFE
else 
return(.f.)
ENDIF  
XXX:=1

 dbselectarea('ITEMNFE')
    ITEMNFE->(dbgotop())
     while .not. eof()
	            
	                 If LockReg()  
                       ITEMNFE-> ITENS   :=XXX
                       ITEMNFE->(dbcommit())
                       ITEMNFE->(dbunlock())
                   Unlock
                  ENDIF  
	  XXX++
  
	 * MSGINFO(XXX)
     dbskip()
	  ITEMNFE->(ordsetfocus('DESCRICAO'))
    end

 dbselectarea('ITEMNFE')
    ITEMNFE->(dbgotop())
    while .not. eof()
     ADD ITEM {STR(ITEMNFE->ITENS,3),ITEMNFE->PRODUTO,ITEMNFE->descricao,ITEMNFE->ncm,ITEMNFE->unid,transform((ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->VALOR, '9,999,999.99'),transform(ITEMNFE->valor_Desc,"99,999.9999"),transform((ITEMNFE->VALOR*ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->icms,"999.99"),transform(ITEMNFE->STB,"999"),ITEMNFE->cfop,transform(ITEMNFE->icms, '999,99'),transform(ITEMNFE->SEQ_T,"999999999999999")}TO FITA OF NFe
    dbskip()
  end
	
	
select ITEMNFE
SUM SUBTOTAL TO nTtFactura 
 NFE.Txt_valortotal.value   :=nTtFactura
 NFE.Txt_total.value        :=nTtFactura
return(nil)




function Refresh_3()
Static lGridFreeze := .t.
abreITEMNFE()
IF ISWINDOWDEFINED(NFE)
   delete item all from FITA of NFE
else 
return(.f.)
ENDIF  
XXX:=1

 dbselectarea('ITEMNFE')
    ITEMNFE->(dbgotop())
     while .not. eof()
SELE ITEMNFE
	 IF ITEMNFE->DEVOL =0          
			  if lock_reg()
                ITEMNFE->(dbdelete())
                ITEMNFE->(dbunlock())
                ITEMNFE->(dbgotop())
             endif
		ENDIF
	  dbskip()
    end




  dbselectarea('ITEMNFE')
    ITEMNFE->(dbgotop())
    while .not. eof()
     ADD ITEM {STR(ITEMNFE->ITENS,3),ITEMNFE->PRODUTO,ITEMNFE->descricao,ITEMNFE->ncm,ITEMNFE->unid,transform((ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->VALOR, '9,999,999.99'),transform(ITEMNFE->valor_Desc,"99,999.9999"),transform((ITEMNFE->VALOR*ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->icms,"999.99"),transform(ITEMNFE->STB,"999"),ITEMNFE->cfop,transform(ITEMNFE->icms, '999,99'),transform(ITEMNFE->SEQ_T,"999999999999999")}TO FITA OF NFe
   dbskip()
  end
	
	
select ITEMNFE
SUM SUBTOTAL TO nTtFactura 
 NFE.Txt_valortotal.value   :=nTtFactura
 NFE.Txt_total.value        :=nTtFactura
return(nil)




	  
	  
	  

STATIC Function PESQ_nfec()	  
XCHAVE:=nfe.txt_nfec.value 
	  	   
DQuery := oServer:Query( "Select chave,CbdNtfNumero From NFCE WHERE CbdNtfNumero = "+XCHAVE+" Order By CbddEmi" )


If DQuery:NetErr()
  	MsgStop(DQuery:Error())
    MsgInfo("Por Favor verifique linha 1752")
    Return Nil
  Endif
  DRow	          :=dQuery:GetRow(1)
  xcahve          :=dRow:fieldGet(1)
  xnumero         :=dRow:fieldGet(2)
  DQuery:Destroy()	
*MSGINFO(xcahve)
nfe.Txt_chave.value:=xcahve 
nfe.txt_nfecc.value :=xnumero 

		 

	  

STATIC Function ProcedureescreverINI_3()
    cDestino := "C:\ACBrMonitorPlus\ACBrMonitor.INI"
	lRetStatus:=EsperaResposta(cDestino) 
	
	BEGIN INI FILE cDestino
       SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '0'
    END INI
 	MY_WAIT( 3 )    
	
return
 	  
	  
	  
	  
************************************
// --------------/------------------------------------------------------------.
STATIC FUNCTION wnexcluiitem()
// Fun��o....: Excluir o item atual -----------------------------------------.
Local gCode:= AllTrim(GetColValue("fita", "nfe", 2 ))

  
DEFINE WINDOW Exclui_Item	;
		AT 050,082	;
		WIDTH  487	;
	    HEIGHT 325	;
        title 'Excluir items ';
        icon cPathImagem+'movie.ico';
		modal;
       NOSIZE			       

  ON KEY ESCAPE  OF NFE ACTION Exclui_Item.RELEASE

@ 041, 028   LABEL oSay2 ;
   WIDTH 108 ;
   HEIGHT 033 ;
   VALUE "C�digo"  ;
   FONT "MS Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 000, 000, 128 };
   BACKCOLOR { 244, 244, 244 } BOLD 


 @ 096, 022   LABEL  Lb_PRODUTO ;
   WIDTH 450 ;
   HEIGHT 032 ;
   VALUE "Produtos"  ;
   FONT "MS Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 } BOLD 




 @ 150, 023   LABEL Lb_qtd ;
   WIDTH 237 ;
   HEIGHT 032 ;
   VALUE "Quantadade"  ;
   FONT "MS Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 } BOLD 


 @ 206, 023   LABEL Lb_PRECO ;
   WIDTH 350 ;
   HEIGHT 034 ;
   VALUE "Valor R$"  ;
   FONT "MS Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 } BOLD 


   @ 045, 145   TEXTBOX oGet1 ;
   WIDTH  115 ;
   HEIGHT  23 ;
   VALUE  gCode ;
   FONT "Ms Sans Serif" SIZE 014 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 };
   INPUTMASK "9999999999999";
   ON ENTER  {|| BUSCAITEMW()}
   
      
END WINDOW
ACTIVATE WINDOW  Exclui_Item
RETURN(NIL)


// ---------------------------------------------------------------------------
static FUNCTION BUSCAITEMW
         local nTtFactura:=0  
         local nCodigo := Exclui_Item.oGet1.VALUE

		 
abreITEMENT()
		 
	 dbselectarea('ITEMNFE')
     ordsetfocus('PRODUTO')
     ITEMNFE->(dbgotop())
     ITEMNFE->(dbseek(nCodigo))
		 
         MODIFY CONTROL Lb_PRODUTO    OF Exclui_Item VALUE 'Produto:    '  +ITEMNFE->descricao
         MODIFY CONTROL Lb_qtd      OF Exclui_Item VALUE 'Quantidade  '  +TransForm(ITEMNFE->qtd   , "@R 99,999.999")  
         MODIFY CONTROL Lb_PRECO    OF Exclui_Item VALUE 'Valor R$    '  +TransForm(ITEMNFE->VALOR  , "@R 99,999.99")     

		 
 if MsgYesNo("Deseja Deletar este Item ?", "Produto...")
      IF ITEMNFE->(DBRLOCK())
         ITEMNFE->(DBDELETE())
         ITEMNFE->(DBCOMMIT())
         ITEMNFE->(DBSKIP(-1))
         endif  
        endif
 
atualizar()
 
*select ITEMNFE
*SUM SUBTOTAL TO nTtFactura 

*MODIFY CONTROL Txt_valortotal OF NFE VALUE ""  +TransForm(nTtFactura   , "@R 999,999.99")       
*MODIFY CONTROL Txt_valor      OF NFE VALUE ""  +TransForm(nTtFactura   , "@R 999,999.99")       

//NFE.Text_CODBARRA.VALUE := 0
//NFE.Text_CODBARRA.SETFOCUS
Exclui_Item.RELEASE

RETURN(NIL)
// Fim da fun��o de excluir o item atual ------------------------------------.

static function atualizar()
delete item all from FITA of NFE
dbselectarea('ITEMNFE')
ITEMNFE->(ordsetfocus('NUMSEQ'))
ITEMNFE->(dbgotop())
ITEMNFE->(ordsetfocus('DESCRICAO'))
       while .not. eof()
       ADD ITEM {STR(ITEMNFE->ITENS,3),ITEMNFE->PRODUTO,ITEMNFE->descricao,ITEMNFE->ncm,ITEMNFE->unid,transform((ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->VALOR, '9,999,999.99'),transform(ITEMNFE->valor_Desc,"99,999.9999"),transform((ITEMNFE->VALOR*ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->icms,"999.99"),transform(ITEMNFE->STB,"999"),ITEMNFE->cfop,transform(ITEMNFE->icms, '999,99'),transform(ITEMNFE->SEQ_T,"999999999999999")}TO FITA OF NFe
        ITEMNFE->(dbskip())
       end
	   
select ITEMNFE
SUM SUBTOTAL TO nTtFactura 
NFE.FITA.value:=1
NFE.FITA.setfocus
NFE.Txt_CLIENTE.setfocus

return(nil)
	  
	  
	  
***********************************
static function Impostos_Cupom()
************************************
abreitemnfe()
abreDADOSNFE()
SELE ITEMNFE
Go Top
Do While ! ITEMNFE->(Eof())
 SELE ITEMNFE
       
xncm       :=ITEMNFE->ncm    
XSUBTOTAL  :=ITEMNFE->SUBTOTAL      
				  
  oQuery:= oServer:Query( "Select aliqnac From tabela_ibpt WHERE ncm = " + AllTrim(xncm))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	:= oQuery:GetRow(1)
  if oRow:fieldGet(1)=0
  aliqnac:=32.85
  else
  aliqnac :=oRow:fieldGet(1)
  endif
  
  
  
ITEMNFE->(dbskip())
Impostos_Cupom_1:=XSUBTOTAL*aliqnac/100
Impostos_Cupom  :=Impostos_Cupom+Impostos_Cupom_1
*msginfo(Impostos_Cupom_1)

EndDo
cEMITIDO:=0

return




static function peganfe()


C_CbdNtfNumero  :=NFe.Txt_NOTA.VALUE
C_CbdNtfNumero  :=alltrim(str(c_CbdNtfNumero))
*MsgInfo(C_CbdNtfNumero)
Reconectar_A() 


  cQuery:="SELECT CbdNtfNumero FROM pegaNFE WHERE CbdNtfNumero = "+C_CbdNtfNumero
  oQuery:=oServer:Query( cQuery )
oRow    :=oQuery:GetRow(1)
snumero :=oRow:FieldGet(1) 
  
  
If snumero >0
else
 	  cQuery := "INSERT INTO  peganfe (CbdNtfNumero) VALUES ('"+C_CbdNtfNumero+"')" 
 	   	 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
		 // msginfo("ok")
		EndIf
EndIf
return


static function atualizador_cliene()


XNFE_REFERENCIADA:=nfe.Txt_chave.value  

IF nfe.oRad2.VALUE == 2

IF nfe.oRad3.VALUE == 2
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Total "  ;
+ "Referente a NFe :"   +" Chave : = "        +XNFE_REFERENCIADA       +"   NUMERO "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])      +" Cliente  "  +nfe.Txt_CLIENTE.VALUE 

ELSE
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Total "  ;
+ "Referente a NFC_e :"   +" Chave : = "        +XNFE_REFERENCIADA     +"    NUMERO "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE 

ENDIF



NFE.Edit_Aplicacao.setfocus
 referencia:=NFE.Edit_Aplicacao.VALUE

else

IF nfe.oRad3.VALUE == 1
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Parcial "  ;
+ "Referente a NFC_e :"  +" Chave : = "        +XNFE_REFERENCIADA     +"      NUMERO  "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE     
ELSE
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Parcial "  ;
+ "Referente a Nfe :"  +" Chave : = "        +XNFE_REFERENCIADA       +"      NUMERO  "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE     
ENDIF

NFE.Edit_Aplicacao.setfocus
referencia:=NFE.Edit_Aplicacao.VALUE
endif
return



*---------------------------------------------------------------------
static function MostraOBS()
*---------------------------------------------------------------------
LOCAL C_CODIGO :=NFE.textBTN_cliente.VALUE
local pCode:=AllTrim(str(nfe.textBTN_cfop.value))

TOTAL :=0
xtotal:=0
ztotal:=0


CLOSE ALL
abreitemnfe()
abreDADOSNFE()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
abreseq_dav()


Select ITEMNFE
ITEMNFE->(dbgotop())
 do while !ITEMNFE->(eof())
if ITEMNFE->cst<>"000"
      ITEMNFE->(dbskip())
      loop
   end if
  xtotal   :=xtotal+ ITEMNFE->UNIT_DESC
  ztotal   :=xtotal*C_ALIQUOTA/100
 
  
   sele DADOSNFE
   If LockReg()  
    DADOSNFE->aliquota     :=C_ALIQUOTA
  *  DADOSNFE->desc1        :=ztotal
     DADOSNFE->TOTAL_IMP    :=DADOSNFE->TOTAL_IMP+Impostos_Cupom_1
    DADOSNFE->(dbcommit())
    DADOSNFE->(dbunlock())
   Unlock
  ENDIF 
ITEMNFE->(dbskip())
enddo
 
TOTALICMS:=0
NTOTAL:=0
NQTD:=0
NQTD1:=0

NTOTAL   :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')
vv_total :=(DADOSNFE->VALOR_TOT)
TOTALICMS:=vv_total*DADOSNFE->ALIQUOTA/100
VV_VALOR:=DADOSNFE->TOTAL_IMP/Vv_total*100
XNFE_REFERENCIADA:=nfe.Txt_chave.value  
IF nfe.oRad2.VALUE == 2
IF nfe.oRad3.VALUE == 2
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Total "  ;
+ "Referente a NFe :"   +" Chave : = "        +XNFE_REFERENCIADA       +"   NUMERO "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])      +" Cliente  "  +nfe.Txt_CLIENTE.VALUE 
ELSE
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Total "  ;
+ "Referente a NFC_e :"   +" Chave : = "        +XNFE_REFERENCIADA     +"    NUMERO "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE 
ENDIF
NFE.Edit_Aplicacao.setfocus
 referencia:=NFE.Edit_Aplicacao.VALUE

else

IF nfe.oRad3.VALUE == 1
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Parcial "  ;
+ "Referente a NFC_e :"  +" Chave : = "        +XNFE_REFERENCIADA     +"      NUMERO  "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE     
ELSE
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Parcial "  ;
+ "Referente a Nfe :"  +" Chave : = "        +XNFE_REFERENCIADA       +"      NUMERO  "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE     
ENDIF

NFE.Edit_Aplicacao.setfocus
referencia:=NFE.Edit_Aplicacao.VALUE
endif






cQuery:= "select  codigo, cfop,natureza FROM cfop  WHERE cfop = " + (pCode)         
 oQuery:=oServer:Query( cQuery )
 If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 Return Nil
 endif
 oRow:= oQuery:GetRow(1)
nfe.textBTN_cfop.value:=oRow:fieldGet(2)
nfe.Txt_natu.value     :=oRow:fieldGet(3)
oQuery:Destroy()			 																			
return(nil)
		 
*----------------------------------
STATIC Function PESQ_PVENDA_22()
*----------------------------------
 local chave
 local cNome_Anterior := space(40)
 local PORCDESCONTO:=0
// loca chave := 0
 local nn:=0
 chave := (NFe.txt_DAV.value)
 xid   :=0	
 
 
Reconectar_A() 
 oQuery := oServer:Query( "Select ALIQUOTA_ICMS From empresa" )
 If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor verifique linha 5964")
    Return Nil
  Endif
  aRow	          :=oQuery:GetRow(1)
 public C_ALIQUOTA:=aRow:fieldGet(1)
     
 xxCbdNtfSerie :=NFE.Txt_SERIE_1.VALUE

IF nfe.oRad3.VALUE == 1

DQuery := oServer:Query( "Select CbdNtfNumero,CbdvProd_ttlnfe,CbdvNF,CbddEmi,CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe,chave From NFCE WHERE CbdNtfNumero = "+chave+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ALLTRIM(xxCbdNtfSerie)+"  Order By CbddEmi" )


If DQuery:NetErr()
  	MsgStop(DQuery:Error())
    MsgInfo("Por Favor verifique linha 1752")
    Return Nil
  Endif
  DRow	          :=dQuery:GetRow(1)
  xnum            :=dRow:fieldGet(1)
  xTOTAL_VEN      :=(dRow:fieldGet(2))
  xVALOR_TOT      :=(dRow:fieldGet(3))
  xDATA_ORC       :=dRow:fieldGet(4)
  xDESCONTO       :=dRow:fieldGet(5)
  xdesc1          :=dRow:fieldGet(6)
  xdesc2          :=dRow:fieldGet(7) 
  xchave          :=dRow:fieldGet(8)
 *xcbdcsittrib    :=dRow:fieldGet(9)
  xCOD_CLI        :=983
  xNOM_CLI        :=''
  xCL_CGC         :=''
  xRGIE           :=''
  xCL_END         :=''
  xCL_PESSOA      :=''
  xCL_CID         :=''
  xCOD_IBGE       :=''
  xED_NUMERO      :=''
  xEMAIL          :=''
  xCEP            :=''
  xBAIRRO         :=''
  xestado         :=''
  xNRPED          :=""
  
  nfe.Txt_chave.value:=xchave 
  nfe.txt_nfecc.value:=chave

	
 PORCDESCONTO:=xdesc2/xVALOR_TOT*100

 *msginfo(PORCDESCONTO)
XTOTAL:=0
CREDITO_S:=0
DESCONTO_X:=0
nitem:=0
If !Empty(xnum) 
     else
   MsgInfo("Nota Entrada: " , "ATEN��O")
    nfe.txt_dav.SetFocus
    nfe.txt_dav.VALUE:=0	  
 Return .f.
 EndIf
  
 nChave:=ntrim(xCOD_CLI)
 
 fQuery:= "Select uf from cliente WHERE codigo = " + (nChave)
 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
 // NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

 fRow         :=fQuery:GetRow(1)
 xxuf         :=fRow:fieldGet(1)
 
*//msginfo(xxuf)
 
*IF  xxuf="RO"
*nfe.textBTN_cfop.value :=1202
//msginfo("xxuf")

*ELSE
//msginfo("11xxuf")
*nfe.textBTN_cfop.value :=6102
*ENDIF

fQuery:Destroy()	
endif
  
  
  
if nfe.oRad3.VALUE == 2 
 
         if empty(NFe.txt_DAV.value)
	            msgexclamation('Digite o orcamento','Aten��o')
               nfe.txt_dav.SetFocus
               nfe.txt_dav.VALUE:=0	  
               return(.f.)
         endif

DQuery := oServer:Query( "Select CbdNtfNumero,CbdvProd_ttlnfe,CbdvNF,CbddEmi,CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe,chave,CbdxNome_dest, CbdCnpj_dest,CbdIE_dest From NFE20 WHERE CbdNtfNumero = "+chave+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+ALLTRIM(xxCbdNtfSerie)+"  Order By CbddEmi" )

If DQuery:NetErr()
  	MsgStop(DQuery:Error())
   MsGInfo("linha 1740  " + oServer:Error() )
    Return Nil
  Endif
DRow	          :=dQuery:GetRow(1)
  xnum            :=dRow:fieldGet(1)
  xTOTAL_VEN      :=(dRow:fieldGet(3))
  xVALOR_TOT      :=(dRow:fieldGet(2))
  xDATA_ORC       :=dRow:fieldGet(4)
  xDESCONTO       :=dRow:fieldGet(5)
  xdesc1          :=dRow:fieldGet(5)
  xdesc2          :=dRow:fieldGet(7) 
  xCL_CGC         :=dRow:fieldGet(10)
  xchave          :=dRow:fieldGet(8)

   
 cSearch:= ' "'+Upper(AllTrim(xCL_CGC ))+'%" ' 
 oQuery := oServer:Query( "Select codigo, razaosoc, cnpj, ie, data_Cad ,tipo From cliente WHERE CNPJ LIKE "+cSearch+" Order By razaosoc" )
If oQuery:NetErr()							
 MsgInfo("SQL SELECT error: " + oQuery:Error())
return nil
Endif
oRow              := oQuery:GetRow(1)
  xCOD_CLI        :=oRow:fieldGet(1)
  xNOM_CLI        :=oRow:fieldGet(2)
  
 
If !Empty(xNOM_CLI) 
else
oQuery := oServer:Query( "Select codigo, razaosoc, cnpj, ie, data_Cad  From cliente WHERE CPF LIKE "+cSearch+" Order By razaosoc" )
For i := 1 To oQuery:LastRec()
oRow            := oQuery:GetRow(i)
xCOD_CLI        :=oRow:fieldGet(1)
xNOM_CLI        :=oRow:fieldGet(2)
 oQuery:Skip(1)
Next
oQuery:Destroy()
 
EndIf 
  
  
 xRGIE            :=""  
  xCL_END         :=''
  xCL_PESSOA      :=''
  xCL_CID         :=''
  xCOD_IBGE       :=''
  xED_NUMERO      :=''
  xEMAIL          :=''
  xCEP            :=''
  xBAIRRO         :=''
  xestado         :=''
  xNRPED          :=""

 DESCONTO_X:=xdesc2
 DESCONTO_X:=DESCONTO_X/xVALOR_TOT*100
 xDESCONTO:=DESCONTO_X
 
 
 If !Empty(xnum) 
     else
   MsgInfo("Nota Entrada: " , "ATEN��O")
    nfe.txt_dav.SetFocus
    nfe.txt_dav.VALUE:=0	  
 Return .f.
 EndI
  
nfe.Txt_chave.value:=xchave 
nfe.txt_nfecc.value:=ntrim(xnum)
nfe.textBTN_cliente.VALUE:=xCOD_CLI

endif
 
Txt_SERIE_1:=nfe.Txt_SERIE_1.value
  
IF nfe.oRad3.VALUE == 1
eQuery := oServer:Query( "Select CbdcProd ,CbdcEAN,CbdxProd,CbdnItem,CbdvProd,CbdNtfNumero,CbdNCM,CbdqCOM,CbdvUnCom,CbdUCom,CbdvDesc,cbdvoutro_item,CbdvAliq,CbdCFOP,cbdcsittrib,cbdxped_item From ITEMNFCE WHERE CbdNtfNumero ="+ntrim(xnum)+" and CbdNtfSerie = "+alltrim(Txt_SERIE_1)+" Order By CbdxProd" )
endif
IF nfe.oRad3.VALUE == 2
eQuery := oServer:Query( "Select CbdcProd ,CbdcEAN,CbdxProd,CbdnItem,CbdvProd,CbdNtfNumero,CbdNCM,CbdqCOM,CbdvUnCom,CbdUCom,CbdvDesc,cbdvoutro_item,CbdvAliq,CbdCFOP,cbdcsittrib,cbdxped_item From NFEITEM WHERE CbdNtfNumero ="+ntrim(xnum)+" and CbdNtfSerie = "+alltrim(Txt_SERIE_1)+" Order By CbdxProd" )
endif

 If eQuery:NetErr()												
  MsgStop(eQuery:Error())
 MsgInfo("Por Favor Selecione o registro ") 
Endif

For i := 1 To eQuery:LastRec()
eRow         :=eQuery:GetRow(i)

IF nfe.oRad3.VALUE == 1
xcod_prod    :=VAL(eRow:fieldGet(1))
ENDIF
IF nfe.oRad3.VALUE == 2
xcod_prod    :=VAL(eRow:fieldGet(1))
ENDIF


xproduto     :=eRow:fieldGet(2)
xdescricao   :=eRow:fieldGet(3)
xitens       :=eRow:fieldGet(4)
xsubtotal    :=eRow:fieldGet(5)
xnseq_orc    :=eRow:fieldGet(6)
xncm         :=eRow:fieldGet(7)
xqtd         :=eRow:fieldGet(8)     
xvalor       :=eRow:fieldGet(9)
xunid        :=eRow:fieldGet(10)
xCbdvDesc    :=eRow:fieldGet(11)
xCancelado   :=eRow:fieldGet(12)
xCbdvAliq    :=eRow:fieldGet(13)
Xcbdxped_item:=eRow:fieldGet(16)

IF nfe.oRad3.VALUE == 1
xCbdCFOP     :=eRow:fieldGet(14)
xcbdcsittrib :=val(eRow:fieldGet(15))

ENDIF
IF nfe.oRad3.VALUE == 2
xCbdCFOP     :=(eRow:fieldGet(14))
xcbdcsittrib :=val(eRow:fieldGet(15))
ENDIF




IF xCbdvAliq==0
xCbdCFOP :=1411
ELSE
xCbdCFOP :=1202
ENDIF



cQuery:= "select  codigo, cfop,natureza FROM cfop  WHERE cfop = " + NTRIM(xCbdCFOP)         
 oQuery:=oServer:Query( cQuery )
 If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 Return Nil
 endif
 oRow:= oQuery:GetRow(1)
nfe.textBTN_cfop.value :=oRow:fieldGet(2)
nfe.Txt_natu.value     :=oRow:fieldGet(3)
oQuery:Destroy()			 			



XSUBTOTAL=int(XSUBTOTAL*100)/100

NFe.FITA.setfocus		
Nn := NFe.fita.ItemCount+1
oQuery:= oServer:Query( "Select aliqnac From tabela_ibpt WHERE ncm = " + AllTrim(xncm))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	:= oQuery:GetRow(1)
  if oRow:fieldGet(1)=0
  aliqnac:=32.85
  else
  aliqnac :=oRow:fieldGet(1)
  endif




  
 Impostos_Cupom_1:=XSUBTOTAL*aliqnac/100
 Impostos_Cupom  :=Impostos_Cupom+Impostos_Cupom_1
 XV_IBPT         :=XSUBTOTAL*aliqnac/100
	 
					   
                        ITEMNFE->(DBAPPEND())
                        ITEMNFE->COD_PROD       := xCOD_PROD
		              	ITEMNFE->PRODUTO        := xPRODUTO
			            ITEMNFE->ITENS          := nn
                        ITEMNFE->SUBTOTAL       := xSUBTOTAL    
                        ITEMNFE->descricao      := xdescricao 
                        ITEMNFE->NSEQ_ORC       := xNSEQ_ORC
			            ITEMNFE->ncm            := xncm
		             	ITEMNFE->qtd            := xqtd 
                        ITEMNFE->quant          := xqtd 
                        ITEMNFE->valor          := (xvalor) 
                        ITEMNFE->preco          := (xvalor) 
                        ITEMNFE->unid           := xunid  
                        ITEMNFE->cfop           :=NTRIM(xCbdCFOP)
						ITEMNFE->icms           := xCbdvAliq 
					    ITEMNFE->STB            := xcbdcsittrib
						ITEMNFE->Valor_DESC     :=xCbdvDesc
						ITEMNFE->AL_IBPT        := aliqnac
	 			        ITEMNFE->N_IBPT         := XV_IBPT
						ITEMNFE->SEQ_T          :=VAL(Xcbdxped_item)  
				        ITEMNFE->(DBCOMMIT())
                        ITEMNFE->(DBUNLOCK())

					
eQuery:Skip(1)
Next
	          
atualizar()


			
	 M->numero=ITEMNFE->NSEQ_ORC
         SELE DADOSNFE
         OrdSetFocus('NUMSEQ')
         Seek M->numero
		   
		 		 
				 	if (!EOF())
                    If LockReg()  
					   DADOSNFE-> VALOR_TOT  :=xVALOR_TOT
				       DADOSNFE-> TOTAL_VEN  :=xTOTAL_VEN
		               DADOSNFE-> NUM_SEQ    :=xnum
		               DADOSNFE-> NRPED      :=xNRPED
                       DADOSNFE-> DATA_ORC   :=xDATA_ORC
                       DADOSNFE-> COD_CLI    :=xCOD_CLI
                       DADOSNFE-> NOM_CLI    :=xNOM_CLI
                       DADOSNFE-> CL_CGC     :=xCL_CGC 
                       DADOSNFE-> RGIE       :=xRGIE
                       DADOSNFE->CL_END     :=xCL_END 
                       DADOSNFE-> CL_PESSOA  :=xCL_PESSOA
                       DADOSNFE-> CL_CID     :=xCL_CID
                       DADOSNFE-> COD_IBGE   :=xCOD_IBGE
                       DADOSNFE-> ED_NUMERO  :=xED_NUMERO
    		           DADOSNFE-> EMAIL      :=xEMAIL
    		           DADOSNFE-> CEP        :=xCEP
                       DADOSNFE-> BAIRRO     :=xBAIRRO
    		           DADOSNFE-> estado     :=xestado
                       DADOSNFE-> DESCONTO   :=xDESCONTO
				       DADOSNFE-> DESC1      :=PORCDESCONTO
				       DADOSNFE->TOTAL_IMP:=Impostos_Cupom	
                       DADOSNFE->aliquota     :=C_ALIQUOTA
                       DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
	                Unlock
		          ENDIF                 
               else
                     
					 
	                   DADOSNFE->(dbappend())
					   DADOSNFE-> VALOR_TOT  :=xVALOR_TOT
				       DADOSNFE-> TOTAL_VEN  :=xTOTAL_VEN
	   	               DADOSNFE-> NUM_SEQ    :=xnum
		               DADOSNFE-> DATA_ORC    :=xDATA_ORC
                       DADOSNFE-> COD_CLI    :=xCOD_CLI
                       DADOSNFE-> NOM_CLI    :=xNOM_CLI
                       DADOSNFE-> CL_CGC     :=xCL_CGC 
                       DADOSNFE-> RGIE       :=xRGIE
                       DADOSNFE->CL_END     :=xCL_END 
                       DADOSNFE-> CL_PESSOA  :=xCL_PESSOA
                       DADOSNFE-> CL_CID     :=xCL_CID
                       DADOSNFE-> COD_IBGE   :=xCOD_IBGE
                       DADOSNFE-> ED_NUMERO  :=xED_NUMERO
    		           DADOSNFE-> EMAIL      :=xEMAIL
    		           DADOSNFE-> CEP        :=xCEP
                       DADOSNFE-> BAIRRO     :=xBAIRRO
    		           DADOSNFE-> estado     :=xestado
                       DADOSNFE-> DESCONTO   :=xDESCONTO
					   DADOSNFE-> DESC1      :=PORCDESCONTO
				       DADOSNFE->TOTAL_IMP:=Impostos_Cupom		
	                   DADOSNFE->aliquota     :=C_ALIQUOTA
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
                    endif


				

				      If LockReg()  
					   DADOSNFE-> VALOR_TOT  :=xVALOR_TOT
				       DADOSNFE-> TOTAL_VEN  :=xTOTAL_VEN
                    *  DADOSNFE-> desc1      :=PORCDESCONTO
    		           DADOSNFE-> desc2      :=xdesc2  
		               DADOSNFE-> OBS        :=NFE.Edit_Aplicacao.VALUE					
                       DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
	                endif
	
nChave:=DADOSNFE->COD_CLI
fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + ntrim(nChave)
 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
   NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

 fRow         :=fQuery:GetRow(i)
 xxtipo       :=fRow:fieldGet(1)
 xxcnpj       :=fRow:fieldGet(2)
 xxie         :=fRow:fieldGet(3)
 xxcpf        :=fRow:fieldGet(4)
 xxrg         :=fRow:fieldGet(5)
 xxrazaosoc   :=fRow:fieldGet(6)
 xxendereco   :=fRow:fieldGet(7)
 xxnumero     :=fRow:fieldGet(8)
 xxcidade     :=fRow:fieldGet(9)
 xxuf         :=fRow:fieldGet(10)
 xxcod_ibge   :=fRow:fieldGet(11)
 xxcodigo     :=fRow:fieldGet(12)
 xxbairro     :=fRow:fieldGet(13)
 xxemail      :=fRow:fieldGet(14)
 xxcep        :=fRow:fieldGet(15)
    
 IF xxtipo='J'  
 nfe.Txt_IECLI.value      :=  xxie
 nfe.Txt_CNPJ.value       :=  xxcnpj
 nfe.Txt_ENDCLI1.value      := xxendereco
 nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 nfe.T_NOMECLI.value        := xxrazaosoc
 nfe.Txt_CIDCLI.value       := xxcidade
 nfe.Txt_CIDCLI1.value      := xxcidade
 nfe.Txt_NUMCLI.value       := xxnumero
 nfe.Txt_UFCLI.value        := xxuf
 nfe.Txt_BAIRROCLI.value    :=xxbairro
 Nfe.Txt_BAIRROCLI1.value   :=xxbairro
 nfe.Txt_CEPCLI.value       := xxcep
 nfe.Txt_CEPCLI1.value      := xxcep
 nfe.Txt_email.value        :=xxemail
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge

 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL T_NOMECLI     OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
  

endif
 
IF xxtipo='F' 
 nfe.Txt_IECLI.value      := 0
 nfe.Txt_CNPJ.value       := xxcpf
 nfe.Txt_ENDCLI1.value      := xxendereco
 nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 nfe.T_NOMECLI.value        := xxrazaosoc
 nfe.Txt_CIDCLI.value       := xxcidade
 nfe.Txt_CIDCLI1.value      := xxcidade
 nfe.Txt_NUMCLI.value       := xxnumero
 nfe.Txt_UFCLI.value        := xxuf
 nfe.Txt_BAIRROCLI.value    :=xxbairro
 Nfe.Txt_BAIRROCLI1.value   :=xxbairro
 nfe.Txt_CEPCLI.value       := xxcep
 nfe.Txt_CEPCLI1.value      := xxcep
 nfe.Txt_email.value        :=xxemail
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge				
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge
 MODIFY CONTROL T_NOMECLI     OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
 

endif
	
IF xxtipo='I'                        // pode imprimir?
  nfe.Txt_IECLI.value      := 0
 nfe.Txt_CNPJ.value       := xxcnpj
 nfe.Txt_ENDCLI1.value      := xxendereco
 nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 nfe.T_NOMECLI.value      := xxrazaosoc
 nfe.Txt_CIDCLI.value       := xxcidade
 nfe.Txt_CIDCLI1.value      := xxcidade
 nfe.Txt_NUMCLI.value       := xxnumero
 nfe.Txt_UFCLI.value        := xxuf
 nfe.Txt_BAIRROCLI.value    :=xxbairro
 Nfe.Txt_BAIRROCLI1.value   :=xxbairro
 nfe.Txt_CEPCLI.value       := xxcep
 nfe.Txt_CEPCLI1.value      := xxcep
 nfe.Txt_email.value        :=xxemail
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge

 MODIFY CONTROL T_NOMECLI     OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
  

endif
  
IF xxtipo='P'                // pode imprimir?
 nfe.Txt_IECLI.value      := xxie
 nfe.Txt_CNPJ.value       := xxcpf
 nfe.Txt_ENDCLI1.value      := xxendereco
 nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 nfe.T_NOMECLI.value      := xxrazaosoc
 nfe.Txt_CIDCLI.value       := xxcidade
 nfe.Txt_CIDCLI1.value      := xxcidade
 nfe.Txt_NUMCLI.value       := xxnumero
 nfe.Txt_UFCLI.value        := xxuf
 nfe.Txt_BAIRROCLI.value    :=xxbairro
 Nfe.Txt_BAIRROCLI1.value   :=xxbairro
 nfe.Txt_CEPCLI.value       := xxcep
 nfe.Txt_CEPCLI1.value      := xxcep
 nfe.Txt_email.value        :=xxemail
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge	
 MODIFY CONTROL T_NOMECLI     OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
endif
oQuery:Destroy()	

SELE DADOSNFE
PORCDESCONTO:=DADOSNFE->desc1 
ATOTAL:=0
BTOTAL:=0
XSUBTOTAL:=0
TOTAL:=0


BTOTAL:=ITEMNFE->valor 
TOTAL:=BTOTAL*PORCDESCONTO/100

ATOTAL:=ITEMNFE->qtd*ITEMNFE->valor 
XTOTAL:=ATOTAL*PORCDESCONTO/100
*MSGINFO(ALLTRIM(STR(xTOTAL)))
totalcredito=0
CODPROD:=ITEMNFE->COD_PROD
CODPROD:=str(CODPROD)
CODPROD:=val(CODPROD)
CODPROD:=ntrim(CODPROD)
*//msginfo(CODPROD)

My_SQL_Database_Connect(cDataBase)
mQuery := oServer:Query( "Select CST,ncm From produtos WHERE codigo = "+(CODPROD) )
If mQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
return nil
Endif
mRow:=mQuery:GetRow(1)
xCST:=mRow:fieldGet(1)
CCST:=mRow:fieldGet(1)
Cncm:=mRow:fieldGet(2)
CODPROD:=val(CODPROD)
select ITEMNFE
if ITEMNFE->COD_PROD=CODPROD  
If LockReg()  
   ITEMNFE->CST         :=CCST
   ITEMNFE->ncm         :=Cncm
   ITEMNFE->UNIT_DESC   :=ITEMNFE->valor -TOTAL
   ITEMNFE->VALOR_DESC  :=XTOTAL
   ITEMNFE->(DBCOMMIT())
   ITEMNFE->(DBUNLOCK())
ENDIF		
endif
			
BTOTAL:=TOTAL+XSUBTOTAL
	
IF xCST="010"
  *CCST:=000
If LockReg()    
 ITEMNFE->ALIQUOTA  :=C_ALIQUOTA
 **ITEMNFE->STB   :=CCST
ENDIF	

ELSEIF ITEMNFE->CST="000"
 CCST:=101
  If LockReg()    
 ITEMNFE->ALIQUOTA  :=C_ALIQUOTA
* ITEMNFE->STB   :=CCST
ENDIF	

ELSEIF ITEMNFE->CST="060"
 CCST:=102
  If LockReg()    
* ITEMNFE->STB     :=CCST
 ITEMNFE->UNIT_DESC :=0
 ITEMNFE->ALIQUOTA  :=0
 ENDIF	

ELSEIF ITEMNFE->CST="041"
 CCST:=103
 If LockReg()    
 ITEMNFE->UNIT_DESC :=0
* ITEMNFE->STB   :=CCST
 ITEMNFE->ALIQUOTA :=0
 ENDIF	
ENDIF
atualizar()
*oQuery:Skip(1)
*Next

oQuery:Destroy()

XSUBTOTAL  :=0
XVALOR     :=0
XVALOR_DESC:=0
  dbselectarea('ITEMNFE')
  ITEMNFE->(dbgotop())
  dbselectarea('ITEMNFE')
SUM SubTotal,TOTAL_CD,VALOR_DESC TO XSUBTOTAL,XVALOR,XVALOR_DESC
xTOTAL_VEN:=int(xTOTAL_VEN*100)/100
xVALOR_TOT:=int(xVALOR_TOT*100)/100
XSUBTOTAL  :=0
XVALOR     :=0
XVALOR_DESC:=0
  dbselectarea('ITEMNFE')
  ITEMNFE->(dbgotop())
  dbselectarea('ITEMNFE')
SUM SubTotal,TOTAL_CD,VALOR_DESC TO XSUBTOTAL,XVALOR,XVALOR_DESC
xTOTAL_VEN:=int(xTOTAL_VEN*100)/100
xVALOR_TOT:=int(xVALOR_TOT*100)/100
	
					   
 NFE.Txt_valortotal.value   :=DADOSNFE-> TOTAL_VEN // XVALOR
 NFE.Txt_total.value        :=DADOSNFE-> VALOR_TOT //XSUBTOTAL
 
 NFE.Txt_desconto.value     :=xdesc2      //XVALOR_DESC
 NFE.Txt_desconto1.value    :=PORCDESCONTO

 
  dbselectarea('DADOSNFE')
  DADOSNFE->(dbgotop())
  C_CODIGO:=STR(DADOSNFE->COD_CLI) 
   
C_NOME:=DADOSNFE->NOM_CLI 
C_RGIE:=DADOSNFE->RGIE 
C_ENDE:=DADOSNFE->CL_END  
C_CIDA:=DADOSNFE->CL_CID
C_IBGE:=(DADOSNFE->COD_IBGE)
C_NUME:=DADOSNFE->ED_NUMERO 
C_EMIA:=DADOSNFE->EMAIL
C_CEP :=DADOSNFE->CEP 
C_BAIR:=DADOSNFE->BAIRRO
C_UF  :=DADOSNFE->estado
c_tipo:=DADOSNFE->CL_PESSOA

public P_DESCONTO:=NTRIM(NFE.Txt_desconto1.value)
 
 MODIFY CONTROL T_NOMECLI     OF NFe  Value  ''+TransForm( C_NOME   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( C_NOMe   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+c_tipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( C_ENDE   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( C_CIDA   ,"@!")
 nfe.Txt_CIDCLI.value:=( C_CIDA)
 nfe.textBTN_IBGE.Value:=(C_IBGE) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( C_NUME   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( C_EMIA   ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( C_CEP    ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( C_BAIR   ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( C_UF     ,"@!")
C_CODIGO:=STR(DADOSNFE->COD_CLI)
CCODIGO=VAL(C_CODIGO)
NFe.txt_DAV.SETFOCUS
NFe.txt_DAV.VALUE:=""
nfe.textBTN_cliente.SETFOCUS
//pesqbotao()
return( nil )
NFe.RELEASE
STATIC Function sumatotalNFE
RETURN


//--------------------------------------
static function GetCode_cfop(nValue)
//----------------------------------
local cReg := ''
Local nReg := 1

define window form_auto;
		at 000,000;
		width 820;
        height 400;
		title 'Tributacao';
		icon cPathImagem+'jumbo1.ico';
		modal;
        nosize

 @ 10,10 GRID Grid_cfop ;
    width 800;
    height 280;
    HEADERS {"Codigo", "cfop","Natureza"};
    WIDTHS  {60, 80, 500} ;
    VALUE 1 ;
   on dblclick {||find_cfop()}
   

	
  @ 310,11 LABEL  Label_Search_Generic ;
    VALUE "Search " ;
    WIDTH 70 ;
    HEIGHT 20

  @ 310,85 TEXTBOX cSearch ;
    WIDTH 120 ;
    MAXLENGTH 40 ;
    UPPERCASE  ;
    ON ENTER iif( !Empty(form_auto.cSearch.Value), Grid_cfop(), form_auto.cSearch.SetFocus )

	
 ON KEY ESCAPE ACTION form_auto.release //tecla ESC para fechar a janela
		
//form_auto.cSearch.Value:= "2" 
form_auto.cSearch.SetFocus
Grid_cfop()
end window
form_auto.center
form_auto.activate
return

static Function setControl()
 
*--------------------------------------------------------------*
static Function Grid_cfop()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(form_auto.cSearch.Value ))+'%" '           
Local nCounter:= 0
Local oRow
Local i
Local oQuery
Local GridMax:= iif(len(cSearch)== 0,  99999990, 1000000)

DELETE ITEM ALL FROM Grid_cfop Of form_auto
oQuery := oServer:Query( "Select codigo, cfop,natureza From cfop WHERE natureza LIKE "+cSearch+" Order By cfop" )
oRow := oQuery:GetRow(1)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 Return Nil
Endif

c_encontro:=oRow:fieldGet(2)

If !Empty(c_encontro) // se nao encontra 
else
c_barras:=CHARREM(form_auto.cSearch.Value)
c_barras:=CHARREM(CHAR_REMOVE,form_auto.cSearch.Value )
c_barras:=val(c_barras)
c_barras:=alltrim(str(c_barras))
c_barras:=LPAD(STR(val(c_barras)),6,[0])

//C_barras:= ' "'+Upper(AllTrim(c_barras))+'%" '  
 oQuery := oServer:Query( "Select codigo, cfop,natureza From cfop WHERE cfop = "+C_barras+" Order By cfop" )
EndIf
For i := 1 To oQuery:LastRec()
  nCounter++
  If nCounter == GridMax
    Exit
  Endif                   
  oRow := oQuery:GetRow(i)
  ADD ITEM { str(oRow:fieldGet(1),3), str(oRow:fieldGet(2),6) ,oRow:fieldGet(3) } TO Grid_cfop Of form_auto
  oQuery:Skip(1)
Next
oQuery:Destroy()
form_auto.cSearch.SetFocus  
Return 



//-------------------------------------------------
STATIC function Find_cfop()
//--------------------------------------------------
Local pCode:= (AllTrim(GetColValue( "Grid_cfop", "form_auto", 1 )))
Local ccfop:= (AllTrim(GetColValue( "Grid_cfop", "form_auto", 2 )))
Local pnome:= (AllTrim(GetColValue( "Grid_cfop", "form_auto", 3 )))
nfe.textBTN_cfop.value:=val(ccfop)
nfe.Txt_natu.value:=pnome

//nfe.CFOP.setfocus
form_AUTO.release
return(pcode)

*--------------------------------------------------------------*
static Function pesq_cfop()
*--------------------------------------------------------------*
Local cQuery      
Local oQuery      
local pCode:=AllTrim(str(nfe.textBTN_cfop.value))

cQuery:= "select  codigo, cfop,natureza FROM cfop  WHERE cfop = " + (pCode)         
 oQuery:=oServer:Query( cQuery )
 If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 Return Nil
 endif
 
  oRow:= oQuery:GetRow(1)
nfe.textBTN_cfop.value:=oRow:fieldGet(2)
nfe.Txt_natu.value :=oRow:fieldGet(3)

If !Empty(oRow:fieldGet(3)) 
     else
      msgexclamation("Nao Enntrado: " + oQuery:Error())
	  nfe.textBTN_cfop.setfocus
      Return .f.
  EndIf
oQuery:Destroy()			 																			
Return Nil           

//--------------------------------------
STATIC Function GetCode_cli(nValue)
//----------------------------------
local cReg := ''
Local nReg := 1
Reconectar_A() 


define window form_auto;
		at 000,000;
		width 1024;
        height 740;
		title 'Clientes';
		icon cPathImagem+'jumbo1.ico';
		modal;
        nosize
     
 ON KEY ESCAPE ACTION form_auto.release //tecla ESC para fechar a janela

 
 @ 440, 001   FRAME Valor_NF4 ;
   CAPTION "Nome"  ;
   WIDTH 480 ;
   HEIGHT 040 ;
   FONT "Ms Sans Serif" SIZE 9.00 
   
      @ 455, 005 LABEL oSay6 ;
      WIDTH 400 ;
      HEIGHT 024;
      VALUE ""  ;
      FONT "MS Sans Serif" SIZE 11.00 bold;
      FONTCOLOR { 255, 000, 000 }
	  
     * BACKCOLOR { 255, 255, 000 } BOLD 
	  

 @ 500, 001  FRAME Valor_NF1 ;
   CAPTION "Endere�o Cidade estado"  ;
   WIDTH 780 ;
   HEIGHT 040 ;
   FONT "Ms Sans Serif" SIZE 9.00;
   FONTCOLOR { 255, 000, 000 }
	  
   
      @ 515, 010 LABEL oSay3 ;
      WIDTH 770 ;
      HEIGHT 024;
      VALUE ""  ;
      FONT "MS Sans Serif" SIZE 11.00 bold;
      FONTCOLOR { 255, 000, 000 }	  
	  
 @ 550, 005   FRAME Valor ;
   CAPTION "Cnpj/Cpf"  ;
   WIDTH 151 ;
   HEIGHT 040 ;
   FONT "Ms Sans Serif" SIZE 12.00 


   @ 570, 010   LABEL oSay1 ;
      WIDTH 136 ;
      HEIGHT 024;
      VALUE ""  ;
      FONT "MS Sans Serif" SIZE 11.00 bold;
      FONTCOLOR { 255, 000, 000 }
	  
	  
    
 @ 550, 175   FRAME Valor_NF ;
   CAPTION "Ie/Rg"  ;
   WIDTH 151 ;
   HEIGHT 040 ;
   FONT "Ms Sans Serif" SIZE 12.00
   
  @ 570, 185  LABEL oSay2 ;
      WIDTH 136 ;
      HEIGHT 030;
      VALUE ""  ;
      FONT "MS Sans Serif" SIZE 11.00 bold;
      FONTCOLOR { 255, 000, 000 } 
	  

@ 650,20 LABEL  Label_Search_Generic ;
    VALUE "Pesquisa Nome " ;
    WIDTH 150 ;
    HEIGHT 40;
   FONT "MS Sans Serif" SIZE 11.00 bold;
   FONTCOLOR { 255, 000, 000 }

 
 
	DEFINE GRID Grid_22
            ROW    00
            COL    00
            WIDTH  1020
            HEIGHT 420
            HEADERS {"Codigo", "Name","Cnpj","Ie","Cpf","Rg"}
            WIDTHS  {60, 335,150,150,150,150} 
            VALUE 1 
	        JUSTIFY {1,0,1,1,1,1,1}
            FONTNAME "Arial Baltic"
            FONTSIZE 10
		    FONTBOLD .T.
		    WHEN 84
	        fontcolor BLACK
            on dblclick {||Find_cli()}
		  	on change mostradadoscliente()
	END GRID  

	

  @ 650,250 TEXTBOX cSearch ;
    WIDTH 326 ;
    MAXLENGTH 200 ;
    UPPERCASE  ;
    ON ENTER iif( !Empty(form_auto.cSearch.Value), pesqcli1(), form_auto.Grid_22.SetFocus )
	
 	  				   
 DEFINE STATUSBAR of form_auto FONT "MS Sans Serif" SIZE 10
    	If oServer == Nil 
    	STATUSITEM "Base de Dados: "+ONDE WIDTH 150 
        else
   STATUSITEM "Conectado no IP: "+C_IPSERVIDOR+" "+basesql WIDTH 150 	
         endif
          DATE
          CLOCK
          KEYBOARD
	   STATUSITEM ""+AllTrim( NetName() ) WIDTH 150 
  END STATUSBAR

	
form_auto.cSearch.Value:= "A" 
form_auto.cSearch.SetFocus
Grid_cli()
end window
*form_auto.center
form_auto.activate
return
*--------------------------------------------------------------*
STATIC Function  mostradadoscliente( )    
*--------------------------------------------------------------*
Local pCode:= AllTrim(GetColValue( "Grid_22", "form_auto", 1 ))
Local cCode
Local cName:= ""
Local cEMail:= ""
Local oQuery  
Local oRow
            
  oQuery:= oServer:Query( "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf From cliente WHERE codigo = " + AllTrim(pCode))
  If oQuery:NetErr()
    MsgInfo("SQL SELECT error: " , "ATEN��O")
    Return Nil
  Endif
  oRow	:= oQuery:GetRow(1)
 
IF oRow:fieldGet(1)='J'                        // pode imprimir?
   form_auto.oSay1.value  := ""+Trans(oRow:fieldGet(2),'@R 99.999.999/9999-99') 
   form_auto.oSay2.value  := ""+Trans(oRow:fieldGet(3),'@!') 
ENDI
 IF oRow:fieldGet(1)='F'                        // pode imprimir?
    form_auto.oSay1.value  := ""+Trans(oRow:fieldGet(4),'@R 999.999.999-99') 
    form_auto.oSay2.value  := ""+Trans(oRow:fieldGet(5),'@!') 
endif
 IF oRow:fieldGet(1)='I'                        // pode imprimir?
      form_auto.oSay1.value  := ""+Trans(oRow:fieldGet(2),'@R 99.999.999/9999-99') 
      form_auto.oSay2.value  := ""+Trans(oRow:fieldGet(3),'@!') 
endif

IF oRow:fieldGet(1)='P'                        // pode imprimir?
  form_auto.oSay1.value  := ""+Trans(oRow:fieldGet(4),'@R 999.999.999-99') 
   form_auto.oSay2.value  := ""+Trans(oRow:fieldGet(3),'@!') 
endif

  form_auto.oSay6.value  := ""+oRow:fieldGet(6)
  form_auto.oSay3.value  := ""+oRow:fieldGet(7) +  ' ' +Trans(oRow:fieldGet(8),'@!') +  ' ' +Trans(oRow:fieldGet(9),'@!') +  ' ' +Trans(oRow:fieldGet(10),'@!')
 oQuery:Destroy()

Return Nil

 
 //-------------------------------------------------
STATIC Function Find_cli()
//--------------------------------------------------
Local pCode:= (AllTrim(GetColValue( "Grid_22", "form_auto", 1 )))
Local pnome:= (AllTrim(GetColValue( "Grid_22", "form_auto", 2 )))
NFE.textBTN_cliente.value:=val(pcode)


  nChave:=pCode
 fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + (nChave)
 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
   NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

 fRow         :=fQuery:GetRow(1)
 xxtipo       :=fRow:fieldGet(1)
 xxcnpj       :=fRow:fieldGet(2)
 xxie         :=fRow:fieldGet(3)
 xxcpf        :=fRow:fieldGet(4)
 xxrg         :=fRow:fieldGet(5)
 xxrazaosoc   :=fRow:fieldGet(6)
 xxendereco   :=fRow:fieldGet(7)
 xxnumero     :=fRow:fieldGet(8)
 xxcidade     :=fRow:fieldGet(9)
 xxuf         :=fRow:fieldGet(10)
 xxcod_ibge   :=fRow:fieldGet(11)
 xxcodigo     :=fRow:fieldGet(12)
 xxbairro     :=fRow:fieldGet(13)
 xxemail      :=fRow:fieldGet(14)
 xxcep        :=fRow:fieldGet(15)
     

IF nfe.oRad3.VALUE == 1
IF  xxuf="RO"
nfe.textBTN_cfop.value :=5102
ELSE
nfe.textBTN_cfop.value :=6102
ENDIF
endif

IF nfe.oRad3.VALUE == 2
IF  xxuf="RO"
nfe.textBTN_cfop.value :=5102
ELSE
nfe.textBTN_cfop.value :=6102
ENDIF
endif




 IF xxtipo='J'  
  nfe.Txt_IECLI.value      :=  xxie
  nfe.Txt_CNPJ.value       :=  xxcnpj
  nfe.Txt_TIPO.value       :=  xxtipo
  nfe.Txt_IECLI.value      := xxie
  nfe.Txt_CNPJ.value       := xxcpf
  nfe.Txt_TIPO.value       :=  xxtipo
  nfe.Txt_ENDCLI1.value      := xxendereco
  nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
  nfe.Txt_CIDCLI.value       := xxcidade
  nfe.Txt_CIDCLI1.value      := xxcidade
  nfe.Txt_NUMCLI.value       := xxnumero 
  nfe.Txt_UFCLI.value        := xxuf
  nfe.Txt_BAIRROCLI.value    :=xxbairro
  nfe.Txt_BAIRROCLI1.value   :=xxbairro
  nfe.Txt_CEPCLI.value       := xxcep
  nfe.Txt_CEPCLI1.value      := xxcep
  nfe.Txt_email.value        :=xxemail
  NFE.textBTN_IBGE.VALUE	   := xxcod_ibge
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL T_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
 
endif
 
IF xxtipo='F' 
  nfe.Txt_IECLI.value      := 0
  nfe.Txt_CNPJ.value       := xxcpf
  nfe.Txt_TIPO.value       :=  xxtipo
  nfe.Txt_IECLI.value      := xxie
  nfe.Txt_CNPJ.value       := xxcpf
  nfe.Txt_TIPO.value       :=  xxtipo
  nfe.Txt_ENDCLI1.value      := xxendereco
  nfe.Txt_ENDCLI.value       := xxendereco
  nfe.Txt_NOMECLI.value      := xxrazaosoc
  nfe.Txt_CIDCLI.value       := xxcidade
  nfe.Txt_CIDCLI1.value      := xxcidade
  nfe.Txt_NUMCLI.value       := xxnumero 
  nfe.Txt_UFCLI.value        := xxuf
  nfe.Txt_BAIRROCLI.value    :=xxbairro
  nfe.Txt_BAIRROCLI1.value   :=xxbairro
  nfe.Txt_CEPCLI.value       := xxcep
  nfe.Txt_CEPCLI1.value      := xxcep
  nfe.Txt_email.value        :=xxemail
  NFE.textBTN_IBGE.VALUE	   := xxcod_ibge
   

 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")


 
endif
	
IF xxtipo='I'                        // pode imprimir?
  nfe.Txt_IECLI.value      := 0
  nfe.Txt_CNPJ.value       := xxcnpj
  nfe.Txt_TIPO.value       :=  xxtipo
  nfe.Txt_IECLI.value      := xxie
  nfe.Txt_CNPJ.value       := xxcpf
  nfe.Txt_TIPO.value       :=  xxtipo
  nfe.Txt_ENDCLI1.value      := xxendereco
  nfe.Txt_ENDCLI.value       := xxendereco
  nfe.Txt_NOMECLI.value      := xxrazaosoc
  nfe.Txt_CIDCLI.value       := xxcidade
  nfe.Txt_CIDCLI1.value      := xxcidade
  nfe.Txt_NUMCLI.value       := xxnumero 
  nfe.Txt_UFCLI.value        := xxuf
  nfe.Txt_BAIRROCLI.value    :=xxbairro
  nfe.Txt_BAIRROCLI1.value   :=xxbairro
  nfe.Txt_CEPCLI.value       := xxcep
  nfe.Txt_CEPCLI1.value      := xxcep
  nfe.Txt_email.value        :=xxemail
  NFE.textBTN_IBGE.VALUE	   := xxcod_ibge
  
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL T_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
 
endif
  
IF xxtipo='P'                // pode imprimir?
  nfe.Txt_IECLI.value      := xxie
  nfe.Txt_CNPJ.value       := xxcpf
  nfe.Txt_TIPO.value       :=  xxtipo
  nfe.Txt_ENDCLI1.value      := xxendereco
  nfe.Txt_ENDCLI.value       := xxendereco
  nfe.Txt_NOMECLI.value      := xxrazaosoc
  nfe.Txt_CIDCLI.value       := xxcidade
  nfe.Txt_CIDCLI1.value      := xxcidade
  nfe.Txt_NUMCLI.value       := xxnumero 
  nfe.Txt_UFCLI.value        := xxuf
  nfe.Txt_BAIRROCLI.value    :=xxbairro
  nfe.Txt_BAIRROCLI1.value   :=xxbairro
  nfe.Txt_CEPCLI.value       := xxcep
  nfe.Txt_CEPCLI1.value      := xxcep
  nfe.Txt_email.value        :=xxemail
  NFE.textBTN_IBGE.VALUE	   := xxcod_ibge
 MODIFY CONTROL T_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
endif
fQuery:Destroy()

form_AUTO.release
return(pcode)

*--------------------------------------------------------------*
STATIC Function Grid_cli()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(form_auto.cSearch.Value ))+'%" '            
Local nCounter:= 0
Local oRow
Local i
local c_barras
Local oQuery
local c_encontro

DELETE ITEM ALL FROM Grid_22 Of form_auto

oQuery := oServer:Query( "Select codigo,razaosoc, cnpj, ie ,cpf,rg From cliente WHERE razaosoc LIKE "+cSearch+" Order By razaosoc" )

If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 Return Nil
Endif
REG:=0

oRow := oQuery:GetRow(1)
c_encontro:=oRow:fieldGet(2)

For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  ADD ITEM { Str(oRow:fieldGet(1), 5), oRow:fieldGet(2), oRow:fieldGet(3), oRow:fieldGet(4), oRow:fieldGet(5), oRow:fieldGet(6) } TO Grid_22 Of form_auto
 oQuery:Skip(1)
  Next
oQuery:Destroy()
form_auto.cSearch.SetFocus  
Return Nil
  
  
  

*--------------------------------------------------------------*
STATIC Function pesq_cli()
*--------------------------------------------------------------*
Local cQuery      
Local oQuery  
local pCode:=Alltrim(Str(NFE.textBTN_cliente.value))
 nChave:=pCode
 fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + (nChave)
 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
   NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

 fRow         :=fQuery:GetRow(1)
 xxtipo       :=fRow:fieldGet(1)
 xxcnpj       :=fRow:fieldGet(2)
 xxie         :=fRow:fieldGet(3)
 xxcpf        :=fRow:fieldGet(4)
 xxrg         :=fRow:fieldGet(5)
 xxrazaosoc   :=fRow:fieldGet(6)
 xxendereco   :=fRow:fieldGet(7)
 xxnumero     :=fRow:fieldGet(8)
 xxcidade     :=fRow:fieldGet(9)
 xxuf         :=fRow:fieldGet(10)
 xxcod_ibge   :=fRow:fieldGet(11)
 xxcodigo     :=fRow:fieldGet(12)
 xxbairro     :=fRow:fieldGet(13)
 xxemail      :=fRow:fieldGet(14)
 xxcep        :=fRow:fieldGet(15)

  
 
 IF xxtipo='J'  
 nfe.Txt_IECLI.value      :=  xxie
 nfe.Txt_CNPJ.value       :=  xxcnpj
 nfe.Txt_TIPO.value       :=  xxtipo
 nfe.Txt_ENDCLI1.value      := xxendereco
 nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 nfe.Txt_CIDCLI.value       := xxcidade
 nfe.Txt_CIDCLI1.value      := xxcidade
 nfe.Txt_NUMCLI.value       := xxnumero 
 nfe.Txt_UFCLI.value        := xxuf
 nfe.Txt_BAIRROCLI.value    :=xxbairro
 nfe.Txt_BAIRROCLI1.value   :=xxbairro
 nfe.Txt_CEPCLI.value       := xxcep
 nfe.Txt_CEPCLI1.value      := xxcep
 nfe.Txt_email.value        :=xxemail
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge	
 MODIFY CONTROL T_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")


 
endif
 
IF xxtipo='F' 
 nfe.Txt_IECLI.value      := 0
 nfe.Txt_CNPJ.value       := xxcpf
 nfe.Txt_TIPO.value       :=  xxtipo
 nfe.Txt_ENDCLI1.value      := xxendereco
 nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 nfe.Txt_CIDCLI.value       := xxcidade
 nfe.Txt_CIDCLI1.value      := xxcidade
 nfe.Txt_NUMCLI.value       := xxnumero 
 nfe.Txt_UFCLI.value        := xxuf
 nfe.Txt_BAIRROCLI.value    :=xxbairro
 nfe.Txt_BAIRROCLI1.value   :=xxbairro
 nfe.Txt_CEPCLI.value       := xxcep
 nfe.Txt_CEPCLI1.value      := xxcep
 nfe.Txt_email.value        :=xxemail
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge	
 MODIFY CONTROL T_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")


 
endif
	
IF xxtipo='I'                        // pode imprimir?
 nfe.Txt_IECLI.value      := 0
 nfe.Txt_CNPJ.value       := xxcnpj
 nfe.Txt_TIPO.value       :=  xxtipo
 nfe.Txt_ENDCLI1.value      := xxendereco
 nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 nfe.Txt_CIDCLI.value       := xxcidade
 nfe.Txt_CIDCLI1.value      := xxcidade
 nfe.Txt_NUMCLI.value       := xxnumero 
 nfe.Txt_UFCLI.value        := xxuf
 nfe.Txt_BAIRROCLI.value    :=xxbairro
 nfe.Txt_BAIRROCLI1.value   :=xxbairro
 nfe.Txt_CEPCLI.value       := xxcep
 nfe.Txt_CEPCLI1.value      := xxcep
 nfe.Txt_email.value        :=xxemail
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge
 MODIFY CONTROL T_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
 
endif
  
IF xxtipo='P'                // pode imprimir?
 nfe.Txt_IECLI.value      := xxie
 nfe.Txt_CNPJ.value       := xxcpf
 nfe.Txt_TIPO.value       :=  xxtipo
 nfe.Txt_ENDCLI1.value      := xxendereco
 nfe.Txt_ENDCLI.value       := xxendereco
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 nfe.Txt_CIDCLI.value       := xxcidade
 nfe.Txt_CIDCLI1.value      := xxcidade
 nfe.Txt_NUMCLI.value       := xxnumero 
 nfe.Txt_UFCLI.value        := xxuf
 nfe.Txt_BAIRROCLI.value    :=xxbairro
 nfe.Txt_BAIRROCLI1.value   :=xxbairro
 nfe.Txt_CEPCLI.value       := xxcep
 nfe.Txt_CEPCLI1.value      := xxcep
 nfe.Txt_email.value        :=xxemail
 NFE.textBTN_IBGE.VALUE	   := xxcod_ibge	
 MODIFY CONTROL T_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc   ,"@!")
 MODIFY CONTROL Txt_tipo      OF NFe  Value  ''+xxtipo
 MODIFY CONTROL Txt_ENDCLI    OF NFe  Value  ''+TransForm( xxendereco   ,"@!")
 MODIFY CONTROL Txt_CIDCLI    OF NFe  Value  ''+TransForm( xxcidade   ,"@!")
 nfe.Txt_CIDCLI.value:=( xxcidade)
 nfe.textBTN_IBGE.Value:=(xxcod_ibge) 
 MODIFY CONTROL Txt_NUMCLI    OF NFe  Value  ''+TransForm( xxnumero   ,"@!")
 MODIFY CONTROL Txt_email     OF NFe  Value  ''+TransForm( xxemail    ,"@!")
 MODIFY CONTROL Txt_CEPCLI    OF NFe  Value  ''+TransForm( xxcep     ,"@!")
 MODIFY CONTROL Txt_BAIRROCLI OF NFe  Value  ''+TransForm( xxbairro  ,"@!")
 MODIFY CONTROL Txt_UFCLI     OF NFe  Value  ''+TransForm( xxuf      ,"@!")
 endif

C_UF  :=xxuf
*msginfo(c_uf)
registro:=0
Sele ITEMNFE
OrdSetFocus('DESCRICAO')
GO Top
do while !ITEMNFE->(eof())
SELE ITEMNFE
xCbdvAliq:=ITEMNFE->icms


IF nfe.oRad3.VALUE == 2   /// vai davs 
IF  C_UF=="RO" .and. xCbdvAliq=0
XCbdCFOP:=5403
xst     :="500" 
xstb    :=500 
ELSEIF C_UF=="RO" 
xCbdCFOP:=5102
xst     :="101" 
xstb    :=101 
endif


if C_UF<>"RO" .and.xCbdvAliq=0
xCbdCFOP:=6403
xst     :="500"
xstb    :=500  
elseif C_UF<>"RO"
xCbdCFOP:=6102
xst     :="201" 
xstb    :=201 
endif
endif





IF nfe.oRad3.VALUE == 1   /// vai nfce 
IF  C_UF=="RO" .and. xCbdvAliq=0
XCbdCFOP:=5949
xst     :="500" 
xstb    :=500 
ELSEIF C_UF=="RO" 
xCbdCFOP:=5949
xst     :="101" 
xstb    :=101 
endif


if C_UF<>"RO" .and.xCbdvAliq=0
xCbdCFOP:=6949
xst     :="500"
xstb    :=500  
elseif C_UF<>"RO"
xCbdCFOP:=6949
xst     :="201" 
xstb    :=201 
endif
endif




IF xCbdvAliq==0
xCbdCFOP :=1411
ELSE
xCbdCFOP :=1202
ENDIF





cQuery:= "select  codigo, cfop,natureza FROM cfop  WHERE cfop = " + NTRIM(xCbdCFOP)         
 oQuery:=oServer:Query( cQuery )
 If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 Return Nil
 endif
 oRow:= oQuery:GetRow(1)
nfe.textBTN_cfop.value :=oRow:fieldGet(2)
nfe.Txt_natu.value     :=oRow:fieldGet(3)
oQuery:Destroy()			 			




                 Sele ITEMNFE
				      If LockReg()  
                       * ITEMNFE->cfop  :=NTRIM(xCbdCFOP)
				        ITEMNFE->st    :=xst
						ITEMNFE->STB    :=xstb
						ITEMNFE->(dbcommit())
                       ITEMNFE->(dbunlock())
	                endif
	
 

ITEMNFE->(dbskip())
ENDD  

atualizar()
	    
		
			  
  fQuery:Destroy()	
Return Nil           
 
//******************************
static function Pesqcli1()
//*******************************
Local cSearch:= ' "'+Upper(AllTrim(form_auto.cSearch.Value ))+'%" '            
Local nCounter:= 0
Local oRow
Local i
local c_barras
Local oQuery
local c_encontro
Local GridMax:= iif(len(cSearch)== 0,  3000, 1000000)

DELETE ITEM ALL FROM Grid_22 Of form_auto
oQuery := oServer:Query( "Select codigo,razaosoc,cnpj,ie,cpf,rg From cliente WHERE razaosoc LIKE "+cSearch+" Order By razaosoc" )

If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
c_encontro:=oRow:fieldGet(2)
If !Empty(c_encontro) // se nao encontra vale a pesq pro nota fiscal
else
c_barras:=CHARREM(form_auto.cSearch.Value)
c_barras:=CHARREM(CHAR_REMOVE,form_auto.cSearch.Value )
c_barras:=val(c_barras)
c_barras:=alltrim(str(c_barras))
c_barras:=LPAD(STR(val(c_barras)),13,[0])
C_barras:= ' "'+Upper(AllTrim(c_barras))+'%" '  
oQuery := oServer:Query( "Select codigo,razaosoc,cnpj,ie,cpf,rg From cliente WHERE cnpj LIKE "+cSearch+" Order By razaosoc" )
EndIf

For i := 1 To oQuery:LastRec()
  nCounter++
  If nCounter == GridMax
    Exit
  Endif                   
  oRow := oQuery:GetRow(i)
   ADD ITEM { Str(oRow:fieldGet(1), 5), oRow:fieldGet(2), oRow:fieldGet(3), oRow:fieldGet(4), oRow:fieldGet(5), oRow:fieldGet(6) } TO Grid_22 Of form_auto

  oQuery:Skip(1)
Next
oQuery:Destroy()
if lGridFreeze
     form_auto.Grid_22.enableupdate
endif
form_auto.Grid_22.value:=1
form_auto.Grid_22.setfocus
return(nil)

//***********************************
STATIC Function gravavda_CLI
//*************************************
LOCAL C_CODIGO :=NFE.textBTN_cliente.VALUE
xtotal:=0
ztotal:=0
Select ITEMNFE
ITEMNFE->(dbgotop())
 do while !ITEMNFE->(eof())
if ITEMNFE->cst<>"000"
      ITEMNFE->(dbskip())
      loop
   end if
  xtotal:=xtotal+ ITEMNFE->UNIT_DESC
  ztotal:=xtotal*C_ALIQUOTA/100
//  msginfo(ztotl)
   sele DADOSNFE
   If LockReg()  
    DADOSNFE->aliquota     :=C_ALIQUOTA
  *  DADOSNFE->desc1        :=ztotal
    DADOSNFE->(dbcommit())
    DADOSNFE->(dbunlock())
   Unlock
  ENDIF 
ITEMNFE->(dbskip())
enddo


Reconectar_A() 
   
CCODIGO=(C_CODIGO)
     
 nChave:=CCODIGO
 fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + ntrim(nChave)
 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
   NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

 fRow         :=fQuery:GetRow(1)
 xxtipo       :=fRow:fieldGet(1)
 xcnpj        :=fRow:fieldGet(2)
 xie          :=fRow:fieldGet(3)
 xcpf         :=fRow:fieldGet(4)
 xrg          :=fRow:fieldGet(5)



	   SELE DADOSNFE
               If LockReg()  
    	               DADOSNFE->DATA_ORC    :=date()
					   DADOSNFE-> cod_CLI    :=NFE.textBTN_cliente.VALUE
                       DADOSNFE-> NOM_CLI    :=NFE.T_NOMECLI.VALUE
               
			   IF xxtipo="J" 
                        DADOSNFE-> CL_CGC     :=xcnpj 
              		    DADOSNFE-> RGIE       :=xie
		           ENDIF
                   IF xxtipo="F"
                        DADOSNFE->CL_CGC     :=xCPF   
  	                    DADOSNFE->RGIE       :="ISENTO"
					ENDIF
           
    		      IF xxtipo="P"
                        DADOSNFE->CL_CGC     :=xCPF   
             	        DADOSNFE->RGIE       :=xie
			   ENDIF
			   
               IF xxtipo="I"
                        DADOSNFE->CL_CGC     :=xcnpj 
             	        DADOSNFE->RGIE       :="ISENTO"
			   ENDIF
                       DADOSNFE-> CL_END     :=NFE.Txt_ENDCLI.VALUE
                       DADOSNFE-> CL_CID     :=NFE.Txt_CIDCLI.VALUE 
                       DADOSNFE-> COD_IBGE   :=(NFE.textBTN_IBGE.VALUE)
                       DADOSNFE-> ED_NUMERO  :=NFE.Txt_NUMCLI.VALUE
    			       DADOSNFE-> EMAIL      :=NFE.Txt_email.VALUE
    			       DADOSNFE-> CEP        :=NFE.Txt_CEPCLI.VALUE
                       DADOSNFE-> BAIRRO     :=NFE.Txt_BAIRROCLI.VALUE
    			       DADOSNFE-> cl_pessoa  :=NFE.Txt_tipo.VALUE
    			       DADOSNFE-> estado     :=NFE.Txt_UFCLI.VALUE
                       DADOSNFE-> DESCONTO   :=NFE.Txt_desconto.VALUE
			           DADOSNFE-> TOTAL_VEN  :=(NFE.Txt_valortotal.VALUE)
                       DADOSNFE-> VALOR_TOT  :=(NFE.Txt_total.VALUE)
					   DADOSNFE-> OBS        :=NFE.Edit_Aplicacao.VALUE					
                       DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
                  Unlock
		   ENDIF        
				  

 ********************************************************************

//---------------------
static Function GRAVAENVIA2
//---------------------
#include "MGI.ch"
#include <minigui.ch>
#define K_ALT_T                 276   /*   Alt-T                         */
#define clrNormal   {255,255,255}
#define clrBack     {255,255,200}
#INCLUDE "INKEY.CH"
#INCLUDE "MINIGUI.CH"
#INCLUDE "WINPRINT.CH"
#Include "MGI.ch"
#include "ACBr.ch"   // inicializa constantes manifestas do sistema/ACBr.
#define _SHOW_PERCENT 5
#define _SMALL_BLOCK 4096
#define _DEFAULT_BLOCK 8192
#define _LARGE_BLOCK 16384
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 183,255,255 )
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define clrNormal   {255,255,255}
#define clrBack     {255,255,200}
#define clrNormal   {255,255,255}
#define clrBack     {255,255,200}
Static sENDER   :='C:\acbrnf~1\'  
local mgCODIGO:=1
local cPedido        := DADOSNFE->num_seq
LOCAL C_CFOP   :=(nfe.textBTN_cfop.value)
LOCAL C_CODIGO :=NFE.textBTN_cliente.VALUE
Local1              := Chr(13) + Chr(10)
Local2              := 0
private mCFOP:='',mCbdnatOp:='',mCbdtpEmis:=1,mCbdfinNFe:=1
private mPEDIDO:="",aFormaPagamento:=0,nEmail:=''
public path :=DiskName()+":\"+CurDir()


XNFE_REFERENCIADA:=nfe.Txt_chave.value  

IF nfe.oRad2.VALUE == 2

IF nfe.oRad3.VALUE == 2
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Total "  ;
+ "Referente a NFe :"   +" Chave : = "        +XNFE_REFERENCIADA       +"   NUMERO "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])      +" Cliente  "  +nfe.Txt_CLIENTE.VALUE 

ELSE
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Total "  ;
+ "Referente a NFC_e :"   +" Chave : = "        +XNFE_REFERENCIADA     +"    NUMERO "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE 

ENDIF



NFE.Edit_Aplicacao.setfocus
 referencia:=NFE.Edit_Aplicacao.VALUE

else

IF nfe.oRad3.VALUE == 1
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Parcial "  ;
+ "Referente a NFC_e :"  +" Chave : = "        +XNFE_REFERENCIADA     +"      NUMERO  "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE     
ELSE
NFE.Edit_Aplicacao.VALUE:=" Nota Fiscal de Devolu��o Parcial "  ;
+ "Referente a Nfe :"  +" Chave : = "        +XNFE_REFERENCIADA       +"      NUMERO  "+ LPAD(STR(val(nfe.txt_nfecc.value)),9,[0])  +"     SERIE   "+ LPAD(STR(val(NFE.Txt_SERIE_1.VALUE)),3,[0])  +" Cliente  "  +nfe.Txt_CLIENTE.VALUE     
ENDIF

NFE.Edit_Aplicacao.setfocus
referencia:=NFE.Edit_Aplicacao.VALUE
endif

xxxx:=1
*gravavda_CLI()
*NFe_ATV( )  

Reconectar_A() 

*oQuery := oServer:Query( "Select MAX(CbdNtfNumero)FROM nfe20 CbdNtfNumero")
*oRow          := oQuery:GetRow(1)
*C_CbdNtfNumero:=((oRow:fieldGet(1)))
*C_CbdNtfNumero:=C_CbdNtfNumero+1 
C_CbdNtfNumero:=NFe.Txt_NOTA.VALUE

C_CbdNtfSerie := '1'
Reconectar_A() 

  CCODIGO=(C_CODIGO)
  nChave:=CCODIGO
 fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + ntrim(nChave)
 
 fQuery:=oServer:Query( fQuery )
   If fQuery:NetErr()												
    MsgStop(fQuery:Error())
   NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

 fRow         :=fQuery:GetRow(1)
 xxtipo       :=fRow:fieldGet(1)
 
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   
	   
	   	   
IF EMPTY(NFE.T_NOMECLI.VALUE)
          msgexclamation('O campo nome est� vazio','Aten��o')
          NFE.T_NOMECLI.VALUE := ""
          NFE.T_NOMECLI.SETFOCUS
   Return( .F. )
 endif
 
  
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
 
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   



 
 IF EMPTY(NFE.Txt_ENDCLI.VALUE)
        msgexclamation('O campo endere�o est� vazio','Aten��o')
         NFE.Txt_ENDCLI.VALUE := ""
         NFE.Txt_ENDCLI.SETFOCUS
   Return( .F. )
 endif



  IF EMPTY(NFE.Txt_CIDCLI.VALUE )
        msgexclamation('O campo Cidade est� vazio','Aten��o')
         NFE.Txt_CIDCLI.VALUE  := ""
         NFE.Txt_CIDCLI.SETFOCUS
   Return( .F. )
 endif

 
  IF EMPTY(NFE.textBTN_IBGE.VALUE)
        msgexclamation('O campo Codigo municipio esta vazio','Aten��o')
         NFE.textBTN_IBGE.VALUE  := ""
         NFE.textBTN_IBGE.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_NUMCLI.VALUE)
        msgexclamation('O campo numero logadoura est� vazio','Aten��o')
         NFE.Txt_NUMCLI.VALUE := ""
         NFE.Txt_NUMCLI.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_CEPCLI.VALUE)
        msgexclamation('O campo cep est� vazio','Aten��o')
         NFE.Txt_CEPCLI.VALUE := ""
         NFE.Txt_CEPCLI.SETFOCUS
   Return( .F. )
 endif
 
 IF EMPTY(NFE.Txt_BAIRROCLI.VALUE)
        msgexclamation('O campo Bairro est� vazio','Aten��o')
         NFE.Txt_BAIRROCLI.VALUE := ""
         NFE.Txt_BAIRROCLI.SETFOCUS
   Return( .F. )
 endif
 
 
 IF EMPTY(NFE.Txt_UFCLI.VALUE)
         msgexclamation('O campo Estado est� vazio','Aten��o')
         NFE.Txt_UFCLI.VALUE := ""
         NFE.Txt_UFCLI.SETFOCUS
   Return( .F. )
 endif

  
    dbselectarea('DADOSNFE')
    ordsetfocus('NUMSEQ')
    DADOSNFE->(dbgotop())
    DADOSNFE->(dbseek(cPedido))

 If .Not. Found()           
    MsgINFO('N�o Encontrada ;;Tecle ENTER')
    Return( .F. )    
 Endif

 
if nfe.textBTN_cfop.value =5102 .and. nfe.oRad3.VALUE = 3 
 MsgINFO('o cfop n�o confere')
 Return( .F. )  
endif

if nfe.textBTN_cfop.value =6929 .and. nfe.oRad3.VALUE = 3 
 MsgINFO('o cfop n�o confere')
 Return( .F. )  
endif

if nfe.textBTN_cfop.value =5102 .and. nfe.oRad3.VALUE = 3 
 MsgINFO('o cfop n�o confere')
 Return( .F. )  
endif

  if nfe.textBTN_cfop.value =6102 .and. nfe.oRad3.VALUE = 3 
 MsgINFO('o cfop n�o confere')
 Return( .F. )  
endif
  

  
TOTALICMS:=0
NTOTAL:=0
NQTD:=0
NQTD1:=0
vv_total:=0
VV_VALOR:=0
TOTALICMS:=transform(DADOSNFE->DESC1,'9999,999,999.99')	
NTOTAL   :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')

vv_total:=(NFE.Txt_total.value)

VV_VALOR:=DADOSNFE->TOTAL_IMP/Vv_total*100
cDescricao:=transform((DADOSNFE->TOTAL_IMP),"@R 999,999.99")+transform((VV_VALOR),"@R 9,999.99")+"% FONTE IBPT" 
LIN_21:="Valor Aprox dos Tributos R$"+" "+cDescricao


 nNumeroOrc := cPedido

 COMPLEMENTO:="Valor cr�dito do ICMS        "     +   TOTALICMS       + "          aliquota De      " +  NTOTAL  +  "   pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)" +"      "+LIN_21 
   

 
//////////////////////empresa 
Reconectar_A() 

 oQuery := oServer:Query( "Select razaosoc,cidade,end,cep,fone_cont,bairro,estado,insc,cgc,numero,usuario From empresa Order By usuario" )
 If oQuery:NetErr()												
  MsgInfo("Nao Encontrei a Tabela " , "ATEN��O")
return (.f.)
Endif

         oRow := oQuery:GetRow(1)
         codMunEmpresa:=1100304 //VILHENA RO   
         nfeEmpresa   :=alltrim(oRow:fieldGet(1))
         MunEmpresa   :=alltrim(oRow:fieldGet(2))
         endEmepresa  :=alltrim(oRow:fieldGet(3))
         cepEmpresa   :=alltrim(oRow:fieldGet(4))
         FoneEmpresa  :=alltrim(oRow:fieldGet(5))
         BairroEmpresa:=alltrim(oRow:fieldGet(6))
         UfEmpresa    :=alltrim(oRow:fieldGet(7))
         InscEmpresa  :=alltrim(oRow:fieldGet(8))
         CNPJNFE      :=alltrim(oRow:fieldGet(9))
		 numLogradoro :=ntrim(oRow:fieldGet(10))
		 nfantasia    :=alltrim(oRow:fieldGet(11))
         NATU         :=SUBSTR(nfe.Txt_natu.value,1,60)
	     mgCODIGO       :=1
	     mgCODIGO       :=alltrim(str(mgCODIGO))
        C_CbdNtfNumero  :=alltrim(str(c_CbdNtfNumero))
        C_CbdNtfSerie   :=alltrim((C_CbdNtfSerie))
        codMunEmpresa   :=alltrim(str(codMunEmpresa))  
	    VER:="JUMBO Sistema"
	
         Local3:="C:\ACBrMonitorPLUS\ENT.TXT" 
 
 
        STATUS_NFe:={}
		 aadd(STATUS_NFe,{'NFE.StatusServico'})
       
		 
         FERASE(PATH+"\ENT.TXT")
		 handle:=fcreate("ENT.TXT")
			for i=1 to len(STATUS_NFe)
			fwrite(handle,alltrim(STATUS_NFe[i,1]))
		      fwrite(handle,chr(13)+chr(10))
			next
		fclose(handle)  
		 DADOS_NFe:={}
	
if DADOSNFE->estado="RO"
mgIdDEst:="1"
ELSE
mgIdDEst:="2"
ENDIF

	   
cDataEmissao:=date()
cDataSaida:=date()	   
mgindFinal:='0'	
mindIEDest:='1'
mEstado_Destinatario:=NFE.Txt_UFCLI.VALUE
mCNPJ_DESTINATARIO:=DADOSNFE->CL_CGC
 mInscricaoEstadual:= DADOSNFE->RGIE
IF DADOSNFE->CL_PESSOA='F'  
   *if  empty(DADOSNFE->RGIE) .or. DADOSNFE->RGIE='ISENTO' .or. DADOSNFE->RGIE='0' 
		Insc  :="isento"
		  if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
 	       	mindIEDest:='9'
	     	mgindFinal:='1'
        	else
	       mindIEDest:='2'
       	end
		end
 

 IF DADOSNFE->CL_PESSOA='I'  
   *if  empty(DADOSNFE->RGIE) .or. DADOSNFE->RGIE='ISENTO' .or. DADOSNFE->RGIE='0' 
		Insc  :="isento"
		  if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
 	       	mindIEDest:='9'
	     	mgindFinal:='1'
        	else
	       mindIEDest:='2'
       	end
		end

 
  if Len(limpa(mCNPJ_DESTINATARIO))=11.AND.DADOSNFE->CL_PESSOA="F"
		       mInscricaoEstadual:='ISENTO'
		 	      if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
		 	     	mindIEDest:='9'
						mgindFinal:='1'
		        	else
			       	mindIEDest:='2'
		        	end
		  elseif DADOSNFE->CL_PESSOA="P"	   
		       mInscricaoEstadual:=DADOSNFE->RGIE
		  elseif empty(mInscricaoEstadual)
		       mInscricaoEstadual:='ISENTO'
		 	      if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
		 	       	mindIEDest:='2'
		        	else
                     mindIEDest:='9'
					 mgindFinal:='1'
		      	end
	
	
		endif
	

 IF DADOSNFE->CL_PESSOA='I'  
   *if  empty(DADOSNFE->RGIE) .or. DADOSNFE->RGIE='ISENTO' .or. DADOSNFE->RGIE='0' 
		Insc  :="isento"
		  if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
 	       	mindIEDest:='9'
	     	mgindFinal:='1'
        	else
	       mindIEDest:='2'
       	end
		end
	
	
	IF DADOSNFE->CL_PESSOA='I'  
         mInscricaoEstadual:=''
	  if mEstado_Destinatario=='RO' 
		   	mindIEDest:='2'
	     	mgindFinal:='0'
      	end
		end
	
	
	IF DADOSNFE->CL_PESSOA='I'  
         mInscricaoEstadual:=''
	  if mEstado_Destinatario=='MT' 
		   	mindIEDest:='2'
	     	mgindFinal:='1'
      	end
	end

	IF DADOSNFE->CL_PESSOA='F'  
         mInscricaoEstadual:=''
	  if mEstado_Destinatario=='MT' 
		   	mindIEDest:='9'
	     	mgindFinal:='1'
      	end
	end
 
		
 
	      DADOS_NFe:={}
		 aadd(DADOS_NFe,{'NFE.CriarEnviarNFe'})
		 aadd(DADOS_NFe,{'[infNFe]'})
		 aadd(DADOS_NFe,{'versao=4.00'})
		 aadd(DADOS_NFe,{'[Identificacao]'})
		 aadd(DADOS_NFe,{'NaturezaOperacao='+Natu})
		 aadd(DADOS_NFe,{'Modelo=55'})
		 aadd(DADOS_NFe,{'Codigo='+Alltrim((c_CbdNtfNumero))})
		 aadd(DADOS_NFe,{'Numero='+Alltrim((c_CbdNtfNumero))})
		 aadd(DADOS_NFe,{'Serie='+Alltrim(str(SERIE_NFE))})
		 aadd(DADOS_NFe,{'idDEst='+mgIdDEst})
	     aadd(DADOS_NFe,{'indFinal='+mgindFinal})
 	     aadd(DADOS_NFe,{'Emissao='+dtoc(DATE())})
		 aadd(DADOS_NFe,{'Saida='+dtoc(DATE())})
		 aadd(DADOS_NFe,{'hSaiEnt='+(TIME())})
 	  	 
        IF nfe.Rdg_TIPO.VALUE == 1
		aadd(DADOS_NFe,{'Tipo=1'})
		else
		aadd(DADOS_NFe,{'Tipo=0'})
		endif		 
		 aadd(DADOS_NFe,{'verProc='+VER})
	
     IF nfe.oRad2.VALUE == 1 
		 aadd(DADOS_NFe,{'FormaPag=1'})
     ELSE
		 aadd(DADOS_NFe,{'FormaPag=0'})
   ENDIF

	     aadd(DADOS_NFe,{'indPres=1'})  /// Indicador de presen�a do comprador no estabelecimento comercial no momento da opera��o 
		 aadd(DADOS_NFe,{'Finalidade=4'})
	
		 
		 
XNFE_REFERENCIADA:=ALLTRIM(nfe.Txt_chave.VALUE)
	  
If !Empty(XNFE_REFERENCIADA)
 xtipo:="NFE"
 aadd(DADOS_NFe,{'[NFref001]'})
 aadd(DADOS_NFe,{'tipo='+Xtipo})
 aadd(DADOS_NFe,{'refNFe='+XNFE_REFERENCIADA})
else

ENDIF

	
	
		 // Dados do emitente

		 aadd(DADOS_NFe,{'[Emitente]'})
		 aadd(DADOS_NFe,{'CNPJ='+CNPJNFE })
		 aadd(DADOS_NFe,{'IE='+InscEmpresa})
		 aadd(DADOS_NFe,{'ISUF='})
		 aadd(DADOS_NFe,{'Razao='+nfeEmpresa})
		 aadd(DADOS_NFe,{'Fantasia='+nfantasia})
		 aadd(DADOS_NFe,{'Fone=' +FoneEmpresa})
		 aadd(DADOS_NFe,{'CEP=' +cepEmpresa})
		 aadd(DADOS_NFe,{'Logradouro=' +endEmepresa})
		 aadd(DADOS_NFe,{'Numero='+numLogradoro})
		 aadd(DADOS_NFe,{'Complemento='})
		 aadd(DADOS_NFe,{'Bairro=' +BairroEmpresa})
		 aadd(DADOS_NFe,{'CidadeCod='+codMunEmpresa })
		 aadd(DADOS_NFe,{'Cidade='+MunEmpresa})
		 aadd(DADOS_NFe,{'UF='+UfEmpresa })
		 aadd(DADOS_NFe,{'PaisCod=1058'})
		 aadd(DADOS_NFe,{'Pais=BRASIL'})
         aadd(DADOS_NFe,{'CRT='+"1" })
		
	dbselectarea('DADOSNFE')
    ordsetfocus('NUMSEQ')
    DADOSNFE->(dbgotop())
    DADOSNFE->(dbseek(cPedido))
	
////////////////////////////////////////////////////////////////////////////////	 

  // aadd(DADOS_NFe,{'CNPJ=99999999000191' }) 
  // aadd(DADOS_NFe,{'NomeRazao=NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL' })
  // aadd(DADOS_NFe,{'IE='  })
 

// grava�oes  destinatarios

		 aadd(DADOS_NFe,{'[Destinatario]' })

		 aadd(DADOS_NFe,{'CNPJ='+DADOSNFE->CL_CGC })
		 aadd(DADOS_NFe,{'NomeRazao='+( Alltrim(DADOSNFE->NOM_CLI) ) })
		 aadd(DADOS_NFe,{'indIEDest ='+mindIEDest  })
 		 aadd(DADOS_NFe,{'IE='+mInscricaoEstadual })
		 aadd(DADOS_NFe,{'Fantasia='  })
		 aadd(DADOS_NFe,{'CEP=' +limpa(DADOSNFE->cep) })
 	 	 aadd(DADOS_NFe,{'Logradouro=' +alltrim(DADOSNFE->CL_END) })
		 aadd(DADOS_NFe,{'Numero='+alltrim(DADOSNFE->ED_NUMERO)})
		 aadd(DADOS_NFe,{'Complemento='  })
         if !Empty(DADOSNFE->BAIRRO)
		 aadd(DADOS_NFe,{'Bairro=' +alltrim(DADOSNFE->BAIRRO) })
         else
		 aadd(DADOS_NFe,{'Bairro=CENTRO'  })
         endif
		 aadd(DADOS_NFe,{'CidadeCod='+(DADOSNFE->COD_IBGE)})
		 aadd(DADOS_NFe,{'Cidade='+alltrim(DADOSNFE->CL_CID)})
		 aadd(DADOS_NFe,{'UF='+alltrim(DADOSNFE->estado)  })
		 aadd(DADOS_NFe,{'PaisCod=1058'})
		 aadd(DADOS_NFe,{'Pais=BRASIL'})

 
 
cPedido        := DADOSNFE->num_seq
nNumeroOrc     := cPedido
registro:=0
DESCONTO_X:=0
VV_IBPT:=0
tt=0
Sele ITEMNFE
OrdSetFocus('DESCRICAO')
GO Top
ITEMNFE->(dbskip(-1))
do while !ITEMNFE->(eof())
If  ITEMNFE->NSeq_Orc == nNumeroOrc
SELE ITEMNFE
mgREGIME:=1
XValor_DESC:=SubTotal*VAL(P_DESCONTO)/100
  
 
        registro              :=registro+1
        M->CbdvCredICMSSN     := 0
		NTOTAL                :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')
	    M->CbdvCredICMSSN     := ITEMNFE->UNIT_DESC*C_ALIQUOTA/100
        nFrete_Item:=0
	    xvBCFCPST  :="0"
        xpFCPS	   :="0" 	
	    xvFCPST    :="0"
		xvBCFCP    :="0"  
		xpFCP      :="0"
		xvFCP      :="0"
		xvBCFCPS   :="0"
		xpFCPST    :="0"
		xindAdProd :="0"
		IPI        :=0
	      xCST:=str(ITEMNFE->stb)
		 xCFOP:=ITEMNFE->CFOP
	     nCFOP:=ITEMNFE->CFOP
		xITEM:=strzero(xxx,3)
		
		 aadd(DADOS_NFe,{'[Produto'+strzero(registro,3)+']' })
		 aadd(DADOS_NFe,{'CFOP=' +limpa(nCFOP) })
		 aadd(DADOS_NFe,{'Codigo=' +ALLTRIM(ITEMNFE->PRODUTO) })
	 	 aadd(DADOS_NFe,{'Descricao=' +Alltrim(ITEMNFE->DESCRICAO) })
	 	 aadd(DADOS_NFe,{'indAdProd='   +ALLTRIM(xindAdProd )})
	   *  aadd(DADOS_NFe,{'EAN=' })
		 aadd(DADOS_NFe,{'NCM=' +LPAD(STR(val(ITEMNFE->ncm)),8,[0])})
		 
		 
 if substr(ITEMNFE->PRODUTO,0,3)=='789' 
	   aadd(DADOS_NFe,{'cEANTrib=' +ALLTRIM(ITEMNFE->PRODUTO) })
	   aadd(DADOS_NFe,{'EAN=     ' +ALLTRIM(ITEMNFE->PRODUTO) })
     else
       aadd(DADOS_NFe,{'cEANTrib='+("SEM GTIN ")})
       aadd(DADOS_NFe,{'EAN='     +("SEM GTIN ")})
    endif

		 
		 
		 
		 
		if !empty(ALLTRIM(ITEMNFE->CEST))
			if limpa(nCFOP)=='5403'.or.limpa(nCFOP)=='5401'.or.limpa(nCFOP)=='5405'.or.limpa(nCFOP)=='6401'.or.limpa(nCFOP)=='6404'.or.limpa(nCFOP)=='5656'.or. limpa(nCFOP)=='6656' .or. limpa(nCFOP)=='5929'  .or. limpa(nCFOP)=='6929'   .or. limpa(nCFOP)=='5949' .or. limpa(nCFOP)=='6949'
			 	aadd(DADOS_NFe,{'CEST='+ALLTRIM(ITEMNFE->CEST)   })
		   End
	   End
	   
		 aadd(DADOS_NFe,{'Unidade=' +ITEMNFE->unid})
		 aadd(DADOS_NFe,{'Quantidade=' +TRANSFORM(ITEMNFE->QTD,"@! 99999999.999") })
		 aadd(DADOS_NFe,{'ValorUnitario='+ALLTRIM(TRANSFORM(ITEMNFE->Valor,"@ 999999999999.999")) })
		 aadd(DADOS_NFe,{'ValorTotal=' +ALLTRIM(TRANSFORM(ITEMNFE->SubTotal,"@ 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorDesconto=' +ALLTRIM(TRANSFORM(XValor_DESC,"@ 99999999999999.99"))  })
	     aadd(DADOS_NFe,{'vFrete='+ALLTRIM(TRANSFORM((nFrete_Item),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'NumeroDI=1' })
   
   
		 // Dados do icms[xxx]
       
	
		  aadd(DADOS_NFe,{'[ICMS'+strzero(registro,3)+']' })
		*  aadd(DADOS_NFe,{'orig='+Auxilia3->origem })

*if mgREGIME==1
   xICMS:='ICMSSN'
  	IF  mindIEDest=='9'  //nao permite aproveitamento de credito para pessoa fisica
  		xCST='102' 
	End


	if xCST='400'
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	elseif xCST='101'
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
		  aadd(DADOS_NFe,{'pCredSN='+alltrim(NTOTAL)})
		  aadd(DADOS_NFe,{'vCredICMSSN='+ALLTRIM(TRANSFORM(M->CbdvCredICMSSN   ,"99,999,999.99")) })
	elseif xCST='102' 
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	elseif xCST='103'
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	elseif xCST='201'
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	elseif xCST='202' 
 		 aadd(DADOS_NFe,{'CSOSN='+xCST })
		 aadd(DADOS_NFe,{'ModalidadeST=4' }) 
		 aadd(DADOS_NFe,{'PercentualMargemST=30' }) 
		 aadd(DADOS_NFe,{'ValorBaseST='+ALLTRIM(TRANSFORM(auxilia3->TOTAL_ST ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'AliquotaST='+ALLTRIM(TRANSFORM((auxilia3->ICMS_ST/M->CbdvBC)*100   ,"@ 99.99")) })
		 aadd(DADOS_NFe,{'ValorST='+ALLTRIM(TRANSFORM(auxilia3->ICMS_ST     ,"@ 99999999999999.99")) })
	elseif xCST='900' 
 		 aadd(DADOS_NFe,{'CSOSN='+xCST })
		 aadd(DADOS_NFe,{'ModalidadeST=4' }) 
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(M->CbdvBC   ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(M->CbdpICMS   ,"@ 99.99")) }) 
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(M->CbdvICMS_icms  ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'PercentualMargemST=35' }) 
		 aadd(DADOS_NFe,{'ValorBaseST='+ALLTRIM(TRANSFORM(auxilia3->TOTAL_ST ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'AliquotaST='+ALLTRIM(TRANSFORM((auxilia3->ICMS_ST/M->CbdvBC)*100   ,"@ 99.99")) })
		 aadd(DADOS_NFe,{'ValorST='+ALLTRIM(TRANSFORM(auxilia3->ICMS_ST     ,"@ 99999999999999.99")) })
		 nTotalBase+=M->CbdvBC
		 nTotal_ICMS+=M->CbdvICMS_icms
	 else
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	end
else
   xICMS:='ICMS'
	if xCST=='60' 
		 aadd(DADOS_NFe,{'CST='+xCST })
	elseif xCST=='10'
		 aadd(DADOS_NFe,{'CST='+xCST })
		 aadd(DADOS_NFe,{'Modalidade=4' }) 
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(M->CbdvBC   ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(M->CbdpICMS   ,"@ 99.99")) }) 
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(M->CbdvICMS_icms  ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'PercentualReducao='+ALLTRIM(TRANSFORM(M->CbdpRedBC  ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'PercentualMargemST=30' }) 
		 aadd(DADOS_NFe,{'ValorBaseST='+ALLTRIM(TRANSFORM(auxilia3->TOTAL_ST ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'AliquotaST='+ALLTRIM(TRANSFORM((auxilia3->ICMS_ST/M->CbdvBC)*100   ,"@ 99.99")) })
		 aadd(DADOS_NFe,{'ValorST='+ALLTRIM(TRANSFORM(auxilia3->ICMS_ST     ,"@ 99999999999999.99")) })
		 nTotalBase+=M->CbdvBC
		 nTotal_ICMS+=M->CbdvICMS_icms
	else
		 aadd(DADOS_NFe,{'CST='+xCST })
		 aadd(DADOS_NFe,{'Modalidade=3' }) 
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(M->CbdvBC   ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(M->CbdpICMS   ,"@ 99.99")) }) 
		 if auxilia3->unit==0
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(auxilia3->toticms  ,"@ 99999999999999.99")) }) 
		 else
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(M->CbdvICMS_icms  ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'PercentualReducao='+ALLTRIM(TRANSFORM(M->CbdpRedBC  ,"@ 99999999999999.99")) })
	    end
		 nTotalBase+=M->CbdvBC
		 nTotal_ICMS+=M->CbdvICMS_icms
		  
	end
end
        

		 // Dados PIS EPP - Simples Nacional
        xCbdCST_pis      := 99
		xCbdvBC_pis      := 0
		xCbdpPis         := 0
		xCbdvPis         := 0 
		xCbdqBCProd_pis  := 0
		xCbdvAliqProd_pis:= 0
         aadd(DADOS_NFe,{'[PIS'+strzero(registro,3)+']' })
		 aadd(DADOS_NFe,{'CST='+str( xCbdCST_pis) })
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(xCbdvBC_pis ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(xCbdpPis  ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(xCbdvPis  ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Quantidade='+ALLTRIM(TRANSFORM(xCbdvAliqProd_pis  ,"@ 99999999999999.99")) })
            

         // Dados COFINS  

	 xCbdCST_cofins      := 99
     xCbdvBC_cofins      := 0
	 xCbdpCOFINS         := 0
	 xCbdvCOFINS         := 0
	 xCbdqBCProd_cofins  := 0
	 xCbdvAliqProd_cofins:= 0
		 aadd(DADOS_NFe,{'[COFINS'+strzero(registro,3)+']' })
		 aadd(DADOS_NFe,{'CST='+str(xCbdCST_cofins ) })
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(xCbdvBC_cofins ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(xCbdpCOFINS  ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(xCbdvCOFINS   ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Quantidade='+ALLTRIM(TRANSFORM(xCbdqBCProd_cofins  ,"@ 99999999999999.99")) })
         xCbdcProd           := (ITEMNFE->PRODUTO)
	     xCbdnItem           := registro
		 LinhaDeStatus('Aguarde Gravando    '+TransForm(xCbdcProd ,"@!")  + TransForm(xCbdnItem ,"999"))

 
DESCONTO_X:=DESCONTO_X+ITEMNFE->SubTotal*DADOSNFE->DESC1/100
VV_IBPT:=VV_IBPT+ITEMNFE->N_IBPT+ITEMNFE->m_IBPT+ITEMNFE->E_IBPT

ITEMNFE->(dbskip())
ENDD  
*MSGINFO(DESCONTO_X)

         // Total da nota
	   
			nTotal_Itens   :=DADOSNFE-> VALOR_TOT 
			nTotalBase     :=DADOSNFE-> VALOR_TOT -DESCONTO_X
			mValor_Desconto:=DESCONTO_X
			nImpostos_Cupom:=DADOSNFE->TOTAL_IMP
			mValor_Frete   :=0
			nTotal_ICMS    :=0
			nTotalBaseA    :=0
			nTotal_BaseST  :=0
			nIcms_ST       :=0
			mValor_IPI     :=0
			nTotal_Pis     :=0
			nTotal_Cofins  :=0
	
	    aadd(DADOS_NFe,{'[Total]' })
        aadd(DADOS_NFe,{'BaseICMSSubstituicao='+ALLTRIM(TRANSFORM((nTotal_BaseST),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorICMSSubstituicao='+ALLTRIM(TRANSFORM((nIcms_ST),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorProduto='+ALLTRIM(TRANSFORM((nTotal_Itens),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorNota='+ALLTRIM(TRANSFORM((nTotalBase),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorDesconto='+ALLTRIM(TRANSFORM((mValor_Desconto),"@! 999999999999.99999")) })
        aadd(DADOS_NFe,{'ValorIPI='+ALLTRIM(TRANSFORM((mValor_IPI),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorPIS='+ALLTRIM(TRANSFORM((nTotal_Pis),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorCOFINS='+ALLTRIM(TRANSFORM((nTotal_Cofins),"@! 999999999999.99")) })
     *  aadd(DADOS_NFe,{'vTotTrib='+ALLTRIM(TRANSFORM((VV_IBPT),"@! 999999999999.999")) })


		CCbdmodFrete           := 9
		 xCbdCNPJ_transp        :=NFE.tCNPJTrans.VALUE
		 xCbdxNome_transp       :=NFE.tTransport.VALUE
		 xCbdIE_transp          :=""
		 xCbdxEnder             :=""
		 xCbdxMun_transp        :=""
		 xCbdUF_transp          :=NFE.TUF.VALUE
		 xCbdplaca              :=NFE.tPLACA.VALUE
		 xCbdRNTC               :=""  
		 
         aadd(DADOS_NFe,{'[Transportador]' })
		 aadd(DADOS_NFe,{'FretePorConta='+STR(CCbdmodFrete) })
		 aadd(DADOS_NFe,{'CnpjCpf='+xCbdCNPJ_transp })
		 aadd(DADOS_NFe,{'NomeRazao='+xCbdxNome_transp })
		 aadd(DADOS_NFe,{'IE='+limpa(xCbdIE_transp) })
		 aadd(DADOS_NFe,{'Endereco='+alltrim(xCbdxEnder) })
		 aadd(DADOS_NFe,{'Cidade='+xCbdxMun_transp })

		 aadd(DADOS_NFe,{'UF='+xCbdUF_transp   })
		 aadd(DADOS_NFe,{'ValorServico='+ALLTRIM(TRANSFORM((mValor_Frete),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorBase=0' })
		 aadd(DADOS_NFe,{'Aliquota=0' })
		 aadd(DADOS_NFe,{'Valor=0' })
		 aadd(DADOS_NFe,{'CFOP=' })
		 aadd(DADOS_NFe,{'CidadeCod=' })
    If !empty(limpa(xCbdplaca))
		 aadd(DADOS_NFe,{'Placa='+limpa(xCbdplaca)  })
		 aadd(DADOS_NFe,{'UFPlaca='+xCbdUF_transp})
		 aadd(DADOS_NFe,{'RNTC='+xCbdRNTC	 })		 
	 end	

xtpIntegra:='2'
vdata1       :=dtos(DATE())
xtpIntegra:='2'
tt:=1
  *	tt++
	*	IndPag:='9'
		xtPag:='90'
		MTOTALForma :=0
       * MDESCRICAO  :=FORMA->DESCRICAO
		*xtPag:='Sem pagamento'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})
        aadd(DADOS_NFe,{'IndPag='+('9')})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
*		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
   	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
 	
	
xQTD_VOLUMES:=NFE.tVolumes.VALUE
m->Cbdesp   :=""
xMarca      :="" 
xNUMERO_VOL :=NTRIM(NFE.tVolumes.VALUE)
xPESOBRUTO  :=NFE.tPesoBru.VALUE 
xPESOLIQ    :=NFE.tPesoLiq.VALUE
  
  xCbdinfCpl	  	 	  := NFE.Edit_Aplicacao.VALUE //+"    "+ COMPLEMENTO

 xFCP:="0"
 aadd(DADOS_NFe,{'[DadosAdicionais]' })
 aadd(DADOS_NFe,{'Complemento='+xCbdinfCpl })
 aadd(DADOS_NFe,{'Fisco='+xFCP})
 aadd(DADOS_NFe,{'infAdic=' +xFCP})
 
 HANDLE :=  FCREATE (path+"\NOTA.TXT",0)// cria o arquivo
	for i=1 to len(DADOS_NFe)
		fwrite(handle,alltrim(DADOS_NFe[i,1]))
        fwrite(handle,chr(13)+chr(10))
	next
fclose(handle)  

public cTXT     :=PATH+"\NOTA.TXT"
public cDestino :=PATH+"\NOTA.TXT"
xcml:=memoread(cDestino) 

 cQuery := "UPDATE NFE20 SET ARQUIVO_TXT='"+AllTrim(xcml)+"' WHERE CbdNtfNumero = "+C_CbdNtfNumero+" "
 
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
    ELSE
 *MSGINFO("OK")
  EndiF
IF   GERA_NFE_NFCE=1
status_nfe()
ELSE 
ENVIAR_NFE_class_devolucao()
ENDIF 

RETURN


// Fim da fun��o de gerar tela de splash ------------------------------------.
// --------------------------------------------------------------------------.
static FUNCTION status_nfe()
Local cValue := ""
Local teste  := ""
Local teste1  := ""
Local teste3  := ""
local datahorarec:=""
local RETORNO:=""
local xstatus:=""

////////[STATUS]
LOCAL S_Versao  :=""  //SVRS20101110174320
LOCAL S_TpAmb   :=""  //1
LOCAL S_VerAplic:=""  //SVRS20101110174320
*LOCAL S_CStat   :=""  //107
Local sCStat  :="" //107
LOCAL S_XMotivo :=""  //Servico em Operacao
LOCAL S_DhRecbto:=""  //29/03/2011 07:22:22
LOCAL S_TMed    :=""  //1
LOCAL S_DhRetorno:="" //30/12/1899
LOCAL S_XObs     :=""
///////FIM///////////////
//////[ENVIO]//////////////
LOCAL E_Versao  :=""  //SVRS20100210155347
LOCAL E_TpAmb   :="" //1
LOCAL E_VerAplic:="" //SVRS20100210155347
LOCAL E_CStat   :="" // 103
LOCAL E_XMotivo :="" //Lote recebido com sucesso
LOCAL E_NRec    :="" //113000263213135
LOCAL E_DhRecbto:="" //29/03/2011 07:22:35
LOCAL E_TMed    :="" //1
///////FIM///////////////
/////[RETORNO]//////////
LOCAL R_Versao  :=""  //SVRS20110322100218
LOCAL R_TpAmb   :="" //1
local sXMotivo:=""  //Servico em Operacao
LOCAL R_VerAplic:="" //SVRS20110322100218
LOCAL R_NRec    :="" //113000263213135
LOCAL R_CStat   :="" //100
LOCAL R_XMotivo :="" //=Autorizado o uso da NF-e
///////FIM///////////////
//////[CONSULTA]///////////
local c_Versao  :=""//SVRS20100811185009
local c_TpAmb   :=""//2
local c_VerAplic:=""//SVRS20100811185009
local c_CStat   :=""//100
local cXMotivo :=""//Autorizado o uso da NF-e
local c_CUF     :=""//11
local c_ChNFe   :=""//11110384712611000152550010000004201000004201
local c_DhRecbto:=""//29/03/2011 07:47:33
local c_NProt   :=""//311110000010110
LOCAL nSeconds := 0, nCount := 4, lLoop := .T.
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
public nnfe:="NFE"+NTRIM(NFe.Txt_NOTA.VALUE)
cTXT:=PATH+"\NOTA.TXT"
////////////////////////CRIAR NOTA NFE///////////////////////
	 
PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFE")
pdf   :=alltrim(zNUMERO+xxANO+"-pdf")
tmp  :=alltrim(zNUMERO+xxANO+"-tmp")

         cSubDir := DiskName()+":\"+CurDir()+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diret�rio criado com sucesso", cSubDir, "Diret�rio criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "J� existe Diretorio Criado", cSubDir, "J� existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Cria��o do Diret�rio" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	  cSubDirTMP:= DiskName()+":\"+CurDir()+"\"+tmp+"\"
  		 nError := MakeDir( cSubDirTMP )
            IF nError == 0
         *   msginfo( "Diret�rio criado com sucesso", cSubDir, "Diret�rio criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "J� existe Diretorio Criado", cSubDir, "J� existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Cria��o do Diret�rio" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	
  PdfbDir := DiskName()+":\"+CurDir()+"\"+pdf+"\"
  		 nError := MakeDir( PdfbDir )
            IF nError == 0
         *   msginfo( "Diret�rio criado com sucesso", cSubDir, "Diret�rio criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "J� existe Diretorio Criado", cSubDir, "J� existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Cria��o do Diret�rio" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

***********************************************************
	//////[VERIFICA SERVI�OS]///////////
***********************************************************
	//////[VERIFICA SERVI�OS]///////////
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
PUBLIC s_CStat:=val(sCStat)
if s_CStat=107
*  	  MsgInfo("Servi�o ok")
 lRetorno_Internet:=.T.
     else 
  	  MsgInfo("ATEN��O SEM SERVIDOR NO SISTEMA NACIONAL DE RECEP��O DE NFES" +CRLF + "Tente Novamente mais Tarde" )
 lRetorno_Internet:=.F.
return .F.
endif

ERASE "C:\ACBrMonitorPLUS\sai.txt"
MY_WAIT( 1 ) 


ERASE "C:\ACBrMonitorPLUS\sai.txt"
MY_WAIT( 1 ) 

bRetornaXML:=""

/////////////////criando///////////////////////////	
cRet       := MON_ENV("NFe.CriarNFe("+cTXT+","+bRetornaXML+")")
///////////////////////////////////////////////////

MY_WAIT( 1 ) 
bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xchavenfce  :=SUBSTR(variavel1,24,44)
vNFE        := substr(xchavenfce, 26, 09)
XARQUIVO    :=SUBSTR(variavel1,4,90)
XARQUIVO    :=ALLTRIM(XARQUIVO)

xCbdEmpCodigo   := '1'
fxml:="C:\ACBrMonitorPLUS\"+xchavenfce+"-nfe.xml"
ffxml:=memoread(fxml)
MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML GERADO.:' +fxml
numeronfe    :=NFe.Txt_NOTA.VALUE
ClienteTxtCGC:=nfe.Txt_CNPJ.value
cCbdvNF      :=ntrim(nfe.Txt_valortotal.value)
cCbdvDesc_cob:=ntrim(NFE.Txt_desconto1.value)
cCbdvProd_ttlnfe:=ntrim(NFE.Txt_total.value)
public P_DESCONTO:=NTRIM(NFE.Txt_desconto1.value)
  

xCbdEmpCodigo:="1"
cbdmod        :="55" 
xCbddEmi     := dtos(date())
CCbdxNome_dest:=nfe.Txt_NOMECLI.value	
xserie_nfe:=(NFE.Txt_SERIE.value)
vvNFE:=val(vNFE)
 oQuery   :=oServer:Query( "SELECT CbdNtfNumero FROM nfe20 WHERE CbdNtfNumero = "+NTRIM(vvNFE)+" AND  cbdmod= "+"55"+" and CbdNtfSerie = "+(xserie_nfe)+"  Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
   XCODIGO        :=ALLTRIM(STR(oRow:fieldGet(1)))
IF ntrim(numeronfe)=XCODIGO 
else
 cQuery := "INSERT INTO nfe20 (CbdvProd_ttlnfe,CbdvDesc_cob,CbdvNF, cbdmod, CbdCnpj_dest ,chave,CbdNtfNumero,CbdNtfSerie,CbdEmpCodigo,CbddEmi,CbdxNome_dest )  VALUES ('"+cCbdvProd_ttlnfe+"','"+cCbdvDesc_cob+"','"+cCbdvNF+"', '"+cbdmod+"', '"+ClienteTxtCGC+"','"+xchavenfce+"','"+ntrim(numeronfe)+"','"+(xserie_nfe)+"','"+xCbdEmpCodigo+"','"+xCbddEmi+"' ,'"+CCbdxNome_dest+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
MsgStop(oQuery:Error())
MsgInfo("Por Favor Selecione o registro SOS nfe20 LINHA 2547")
Endif	
endif
abreitemnfe()
abreDADOSNFE()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
abreseq_dav()
abreNFCE()
abreITEMNFCE()
abregra_chave()
abreseq_nfe()

SELE DADOSNFE
               If LockReg()  
		              DADOSNFE -> NUM_SEQ    :=VAL(vNFE)
		         	  DADOSNFE -> CHAVE      :=xchavenfce
		         	  DADOSNFE -> CHAVE_1    :=ffxml
		         	  DADOSNFE -> MODELO     :=55
				      DADOSNFE->(dbcommit())
                      DADOSNFE->(dbunlock())
	                Unlock
		          ENDIF                 
      
	//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.EnviarNFe("+XARQUIVO+",1,1,0,1)")
///////////////////////////////////////////////////
			
MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML ENVIADO.:' + xchavenfce  
					  
cFileDanfe:="C:\ACBrMonitorPLUS\SAI.TXT"
 lRetStatus:=EsperaResposta(cFileDanfe) 
        if lRetStatus==.t.  ////pego os dados
       end
cFileDanfe := 'C:\ACBrMonitorPLUS\sai.txt'
////RETORNO////
BEGIN INI FILE cFileDanfe
       GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
	   GET c_NProt          SECTION    nnfe          ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
  	   GET c_DhRecbto       SECTION  "ENVIO"         ENTRY "DhRecbto"   // DADA E HORA 
	   GET c_ChNFe          SECTION  nnfe            ENTRY "ChNFe"      // chave nfe  
	 /////////////////////////////////////////////////////////////
END INI

public  RCStat   :=R_CStat
public C_XMotivo :=R_XMotivo
PUBLIC cChNFe    :=c_ChNFe
PUBLIC CNPROT    :=c_NProt
PUBLIC cDhRecbto :=c_DhRecbto
public xANO        := dtoS(date())
public xANO        :=ALLTRIM(SUBSTR(XANO,0,6))
public c_CFileDanfe:=""

MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML AUTORIZADO..:' + C_XMotivo 
MODIFY CONTROL gerando_xml OF nfe  VALUE   'PROTOCOLO..:' +  CNPROT

if RCStat='204'
Msginfo(C_XMotivo)
SAIR_nfeb()
return(.f.)
endif

if RCStat="100"
cFileDanfe:="C:\ACBrMonitorPlus\ACBrMonitor.INI"
////RETORNO////
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathNFe"
END INI
cCFileDanfe    :=c_CFileDanfe
PathNFE:=cCFileDanfe+"\"+"NFE"+"\"+xANO+"\"+"NFE"+"\"
ARQEVENTO:=PathNFE+cChNFe+"-nfe.XML"
ffxml:=memoread(ARQEVENTO)
ffxml:=memoread(ARQEVENTO)
     cQuery	:= oServer:Query( "UPDATE nfe20 SET AUTORIZACAO='"+CNPROT+"',nt_retorno='"+(AllTrim(ffxml))+"',CHAVE='"+AllTrim(xchavenfce)+"' WHERE CbdNtfNumero = " +vNFE)
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 4332  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
 *	Msginfo(cXMotivo)
EndIf
ELSE
ENDIF


if RCStat="100"
MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
MODIFY CONTROL email_XML OF NFE VALUE  "" + "Imprimindo nfe ..."

	
cFileDanfe:="C:\ACBrMonitorPlus\ACBrMonitor.INI"
////RETORNO////
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathNFe"
END INI
cCFileDanfe    :=c_CFileDanfe
PathNFE:=cCFileDanfe+"\"+"NFE"+"\"+xANO+"\"+"NFE"+"\"
ARQEVENTO:=PathNFE+cChNFe+"-nfe.XML"
ARQEVENTOa:=cChNFe+"-nfe.XML"
ARQEVENTOb:=cChNFe+"-nfe.XML"
*msginfo(ARQEVENTOa)
ffxml:=memoread(ARQEVENTO)
 
HANDLE :=  FCREATE (cSubDir+ARQEVENTOb,0)// cria o arquivo
FWRITE(Handle,ffxml)
  MY_WAIT( .2 )
  

fclose(handle)  




	  oPDF    := hbnfeDaNfe():New()
      oDanfe  := hbNFeDaGeral():New()
      RODAPE:="JUMBO SISTEMAS JOS� JUC� (SISTEMA PROPRIO)"
      oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  
oDanfe:ToPDF(  Memoread( ARQEVENTO ) ,PdfbDir+ cChNFe+"-nfe.pdf" )
cpdf:=PdfbDir+cChNFe+"-nfe.pdf" 
PDFOpen(cpdf)

HANDLE :=  FCREATE (PdfbDir+ARQEVENTOa,0)// cria o arquivo
FWRITE(Handle,ffxml)
MY_WAIT( .2 ) 
fclose(handle)  




eemail         :=ALLTRIM(nfe.Txt_email.value)
If !Empty(eemail)
*cRet       := MON_ENV("NFE.EnviarEmail("+eemail+","+ARQEVENTO+",,,)")
ELSE
*MSGINFO("NAO TEM")
ENDIF
atualiza_estoque_cancelamento()
ELSE

MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
msginfo(R_XMotivo)
return(.f.)
endif
SAIR_nfeb()
return


//------------------------------------------------------------------
STATIC FUNCTION SAIR_nfeb
//---------------------------------------------
NFE.RELEASE
*status_email.release 
RETURN 







static Function ProcedureescreverINI()
     cDestino := "C:\ACBrMonitorplus\ACBrMonitor.INI"
	lRetStatus:=EsperaResposta(cDestino) 
		BEGIN INI FILE cDestino
      SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '0'
    END INI
	MY_WAIT( 3 )    
	ProcedureLerINI()
return

//------------------------------------------------------------------
STATIC FUNCTION SAIR_nfeh
//---------------------------------------------
NFE.RELEASE
*status_email.release 
RETURN 
	  
**********************************************
static Function VERIFICA_GRAVA_nfe1()                     
*********************************************
C_CbdNtfNumero  :=NFe.Txt_NOTA.VALUE
C_CbdNtfNumero  :=alltrim(str(c_CbdNtfNumero))

*msginfo(C_CbdNtfNumero)		

My_SQL_Database_Connect(cDataBase) //BANCO JUMBO

  cQuery:="SELECT CbdNtfNumero,MSCANCELAMENTO,AUTORIZACAO FROM NFE20 WHERE CbdNtfNumero = "+C_CbdNtfNumero
    oQuery:=oServer:Query( cQuery )
   If !oQuery:EOF()
    oRow    :=oQuery:GetRow(1)
  snumero   :=oRow:FieldGet(1) 
   

If snumero >0
*MsgInfo("Encontrado  " )
REGRAVA_nfe2()
 cQuery:= "DELETE FROM pegaNFE WHERE CbdNtfNumero = " + (C_CbdNtfNumero)         
		 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
		*  msginfo("ok")
	EndIf
 
else
atualiza_estoque_cancelamento()
    cQuery:= "DELETE FROM pegaNFE WHERE CbdNtfNumero = " + (C_CbdNtfNumero)         
		 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
	*	  msginfo("ok")
	EndIf
EndIf
EndIf
Return Nil

//---------------------
static Function REGRAVA_nfe2
//---------------------
Reconectar_A() 

C_CbdNtfNumero:=NTRIM(NFe.Txt_NOTA.VALUE)
XML           :=xchavenfce
fxml          :="C:\ACBrMonitorplus\"+xml
ffxml         :=memoread(fxml)
 

   cQuery	:= oServer:Query( "UPDATE nfe20 SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = " +((C_CbdNtfNumero)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
 *	Msginfo(cXMotivo)
EndIf
*Msginfo("OK")
RETURN
	
//---------------------
Function atualiza_estoque_cancelamento()
//---------------------
#include <minigui.ch>
local mgCODIGO:=1
local C_CbdNtfSerie:="1"
local cPedido        := DADOSNFE->num_seq
LOCAL C_CFOP         :=nfe.textBTN_cfop.value
LOCAL C_CODIGO       :=NFE.textBTN_cliente.VALUE
private mCFOP        :='',mCbdnatOp:='',mCbdtpEmis:=1,mCbdfinNFe:=1
private mPEDIDO      :="",aFormaPagamento:=0,nEmail:=''
xxxx:=1
registro:=0
sele ITEMNFE
OrdSetFocus('DESCRICAO')
GO Top
ITEMNFE->(dbskip(-1))
do while !ITEMNFE->(eof())
If  ITEMNFE->NSeq_Orc == cPedido 
SELE ITEMNFE
registro:=registro+1
     xCbdEmpCodigo       := val(mgCODIGO)
  	 xCbdNtfNumero      := val(cPedido) 
	 xCbdNtfSerie       := vAL(C_CbdNtfSerie) 
	 xCbdnItem          := registro
	 xCbdcProd          := ntrim(ITEMNFE->cod_prod)
	 xCbdcEAN           := (ITEMNFE->PRODUTO)
	 xCbdxProd          := ITEMNFE->DESCRICAO
	 xCbdNCM            := (ITEMNFE->ncm)
	 xCbdEXTIPI         := ""
	 xCbdgenero         := 0 
	 xCbdCFOP           :=  C_CFOP
	 xCbduCOM           := ITEMNFE->unid
	 xCbdqCOM           := ITEMNFE->QTD
	 xCbdvUnCom         := ITEMNFE->Valor
	 xCbdvProd          := ITEMNFE->SubTotal
	 xCbduTrib          := '000001'
	 xCbdqTrib          := ITEMNFE->QTD
	 xCbdvUnTrib        := ITEMNFE->Valor
	 xCbdnTipoItem      := 0
	 xCbdvDesc		    :=ITEMNFE->Valor_DESC
     xCbdvAliq      	:=NTRIM(ITEMNFE->icms)
	 xcbdcsittrib		:=NTRIM(ITEMNFE->STB) 
	 xcbdindtot         := 1
	    cQuery :="INSERT INTO nfeitem (cbdcsittrib,CbdvAliq,CbdEmpCodigo, CbdNtfNumero,CbdNtfSerie, CbdnItem ,CbdcProd ,CbdxProd,CbdNCM ,CbdEXTIPI,Cbdgenero, CbdCFOP, CbduCOM,CbdqCOM,CbdvUnCom ,CbdvProd,CbduTrib,CbdqTrib,CbdvUnTrib,CbdnTipoItem, CbdvDesc, cbdindtot,CbdcEAN ) VALUES (  '"+Xcbdcsittrib+"','"+XCbdvAliq+"' ,'"+alltrim(str(xCbdEmpCodigo ))+"' , '"+alltrim(str(xCbdNtfNumero))+ "', '"+alltrim(str(xCbdNtfSerie))+ "', '"+alltrim(str(xCbdnItem))+ "', '"+alltrim((xCbdcProd))+ "', '"+alltrim(xCbdxProd)+"','"+xCbdNCM+"','"+xCbdEXTIPI+"','"+alltrim(str(xCbdgenero))+"','"+alltrim(str(xCbdCFOP))+"','"+ xCbduCOM+"','"+alltrim(str(xCbdqCOM))+"','"+alltrim(str(xCbdvUnCom))+"','"+alltrim(str(xCbdvProd))+"','"+alltrim(xCbduTrib)+"','"+alltrim(str(xCbdqTrib))+"','"+alltrim(str(xCbdvUnTrib))+"','"+alltrim(str(xCbdnTipoItem))+"','"+alltrim(str( xCbdvDesc))+"','"+alltrim(str(xcbdindtot))+"' ,'"+xCbdcEAN+"' ) "
		oQuery	:= oServer:Query( cQuery )
	If oQuery:NetErr()												
      	MsgStop(cQuery:Error())
	   MsgInfo("SQL SELECT error: 3439  " + cQuery:Error())	
	  Else
EndIf
endif
xCbdcEAN           := (ITEMNFE->PRODUTO)
xCbdqCOM           := ITEMNFE->QTD
NtfNumero          :=ITEMNFE->NSeq_Orc
    fQuery         :=oServer:Query( "Select CODIGO,PRODUTO,UNIT,ST,NCM,CST,QTD,DOLLAR,sit_trib,ICMS,CODBAR,MD5,und From produtos WHERE codbar = " + AllTrim(xCbdcEAN))
   If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=fQuery:GetRow(1)
   XCODIGO        :=ALLTRIM(STR(oRow:fieldGet(1)))
   xcod           :=oRow:fieldGet(1)
   descricaogrande:=oRow:fieldGet(2)
   unidadefdcx    :=oRow:fieldGet(3)   
   sst            :=oRow:fieldGet(4)
   cncm           :=oRow:fieldGet(5)
   ccst           :=oRow:fieldGet(6) 
   XICMS          :=oRow:fieldGet(10)
   Xicms          :=TransForm(Xicms,"99")
   Aqtd           :=(oRow:fieldGet(7))
   HB_Cria_Log_cancela(xCbdcEAN  , +"  Quantidade em Estoque             " ,+  ntrim(Aqtd))
TOTAL_QTD         :=aqtd+xCbdqCOM
xcncm             :=VAL(cncm)
cncm              :=cncm  
 HB_Cria_Log_cancela(xCbdcEAN  ,  +"  Quantidade Vendidade          " ,+  ntrim( xCbdqCOM))
 fQuery:Destroy()
 cQuery := "UPDATE PRODUTOS SET qtd ='"+NTRIM(TOTAL_QTD)+"' WHERE CODBAR = " + AllTrim(xCbdcEAN)
 gQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  Return Nil
  else
   HB_Cria_Log_cancela(xCbdcEAN        , +"Quantidade Atualizado no DB          " ,+  ntrim( TOTAL_QTD))
   HB_Cria_Log_cancela(ntrim(NtfNumero),+" ================================================================== " ,+  "")
Endif
ITEMNFE->(dbskip())
gQuery:Destroy()
ENDD  
RETURN
				   
*******************************
static FUNCTION PEGRETNFE( lMOSTRA )
*"C:\ACBrMonitorplus\SAI.txt"

// lMOSTRA - .T. - MOSTRA RETORNO  .F.-NAO MOSTRA
WHILE( .T. )
   cSAINFE := FOPEN( "C:\ACBrMonitorplus\SAI.txt" )
   IF FERROR()=0
      EXIT
   ENDIF
                 // TEMPORIZADOR - AGUARDA 2 SEGUNDOS ANTES DE CONTINUAR
 *  TMP(2)
ENDDO
// PEGA CONTEUDO DO ARQUIVO DE RETORNO AT� 1000 CARACTERES
cSTATUS   := FREADSTR( cSAINFE,1000 )
             // FUNCAO QUE MOSTRA O RETORNO
   msginfo( cSTATUS)

   RETURN

     
static function ACBR_NFE_Retorno(lMostra) 
    _vezes_ := 5 
  //  cPath         := cFilePath( GetModuleFileName( GetInstance() ) ) 
   // cDirDoMonitor := VerifyINI( "ACBrNFe", "REMESSA" , cPath+"\REM", cPath+"ACBrNFe.ini", .f. ) 
    do while _vezes_>0 
       // Verifica se o arquivo Status.txt existe. 
       // Este arquivo que cont�m o estado de execu��o do comando 
       // enviado. 
       if file( "C:\ACBrMonitorplus\SAI.txt" ) //.and. freadstr( cDirDoMonitor+"\Status.txt" ) <> "0" 
          cECFLOG := memoread("C:\ACBrMonitorplus\SAI.txt"  ) 
          if "ERRO" $ Upper(cECFLOG) 
           // MsgStop( cECFLOG ) 
             //return StrTran( cECFLOG, "ERRO:", "" ) 
          endif 
          if "OK" $ Upper(cECFLOG) 
             return StrTran( cECFLOG, "OK:", "" ) 
          else 
             MsgStop( cECFLOG ) 
          endif 
       endif 
    //   MyWait(1) 
       _vezes_-- 
    enddo  
    return "" 
 
 
static  function VerifyINI( _section_, _entry_, _var_, _inifile_, _grava_ ) 
  //  oIni := TIni():New( _inifile_ ) 
    if _grava_ = .t. 
       oIni:Set( _section_, _entry_, _var_ ) 
    endif 
  return oIni:Get( _section_, _entry_, _var_, _var_ ) 

 
 
 

******************************
STATIC Function EsperaResposta(cFile)
******************************
Private cTempo:=time(),oTempo,lAchou := .f.
Do while .t.

     cTempo:= Time()
      if file(cFile)
        lAchou := .t.
        exit
     endif
     inkey(.8)

 
     if GetKeyState(VK_ESCAPE) < 0
        exit
     endif

enddo
return lAchou


STATIC FUNCTION RETIRAACENTO(ts)
return alltrim(strtran(strtran(strtran(ts,[/],[],[:]),[-],[],[:]),[.],[],[:]))




// Fim da fun��o de gerar tela de splash ------------------------------------.
// --------------------------------------------------------------------------.
FUNCTION ENVIAR_NFE_class_devolucao()
LOCAL nOpc := 1, GetList := {}, cTexto := "", nOpcTemp
LOCAL cCnpj := Space(14), cChave := Space(44), cCertificado := "", cUF := "RO", cXmlRetorno
LOCAL oSefaz, cXml, oDanfe, cTempFile, nHandle
LOCAL i, j, aSubDir, cSubDir, nError,PdfbDir
lOCAL aNewDir := { "temp" }
local xdia := strzero(day(date() ),2 )

PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFE")
pdf   :=alltrim(zNUMERO+xxANO+"-pdf")
tmp  :=alltrim(zNUMERO+xxANO+"-tmp")

         cSubDir := DiskName()+":\"+CurDir()+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diret�rio criado com sucesso", cSubDir, "Diret�rio criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "J� existe Diretorio Criado", cSubDir, "J� existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Cria��o do Diret�rio" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	  cSubDirTMP:= DiskName()+":\"+CurDir()+"\"+tmp+"\"
  		 nError := MakeDir( cSubDirTMP )
            IF nError == 0
         *   msginfo( "Diret�rio criado com sucesso", cSubDir, "Diret�rio criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "J� existe Diretorio Criado", cSubDir, "J� existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Cria��o do Diret�rio" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	
  PdfbDir := DiskName()+":\"+CurDir()+"\"+pdf+"\"
  		 nError := MakeDir( PdfbDir )
            IF nError == 0
         *   msginfo( "Diret�rio criado com sucesso", cSubDir, "Diret�rio criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "J� existe Diretorio Criado", cSubDir, "J� existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Cria��o do Diret�rio" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF
	

cCertificado:=''


BEGIN INI FILE "CERTIFICADO.ini"
  GET cCertificado  SECTION "NOME"   ENTRY "NOME"
END INI

 oSefaz     := SefazClass():New()
 oSefaz: NFeStatusServico( "RO", cCertificado, cAmbiente )
cXmlRetorno := oSefaz:NFeStatusServico()
 hb_MemoWrit( "servico.xml", oSefaz:cXmlRetorno )
 cFileDanfe:= "servico.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha), .f. )
 
if xcStat="107"
*  	  MsgInfo("Servi�o ok")
     else 
  	  MsgInfo("ATEN��O SEM SERVIDOR NO SISTEMA NACIONAL DE RECEP��O DE NFES" +CRLF + xxmotivo )
return .F. 
ENDIF


vNFE:=NFe.Txt_NOTA.VALUE
numeronfe    :=NFe.Txt_NOTA.VALUE
path:=DiskName()+":\"+CurDir() 

   oNfe := hbNfe()
   oNFe:cUFWS := '11' // UF WebService
   oNFe:tpAmb := nfe.Txt_Ambiente.value // Tipo de Ambiente 1=producao 2 homologacao
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=DiskName()+":\"+CurDir() 
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:=PATH+"\NOTA.TXT"
   oIniToXML := hbNFeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oIniToXML:lValida := .T.
   aRetorno := oIniToXML:execute()
   oIniToXML := Nil
	xcha:=(aRetorno['cChaveNFe'])
    cTexto:=xcha+"-nfe.XML"
    oSefaz     := SefazClass():New()
    oSefaz:cUF := "RO"
   cXmlAutorizado:= cTexto
   cXml:= MEMOREAD(cTexto)
    XCHAVENFCE:=(aRetorno['cChaveNFe'])
	 *    MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML ENVIADO.:' + xchavenfce  
                        SetProperty('nfe','gerando_xml','Value','Processado!!!'+xchavenfce)
                        SetProperty('NFE','gerando_xml','BLINK',.F.)
						

oSefaz:NFeLoteEnvia( @cXml, '1', 'RO', ALLTRIM(cCertificado), cAmbiente )
hbNFeDaNFe( oSefaz:cXmlAutorizado )

If oSefaz:cStatus $ [102,103,104,105,106,107,108,109,110,111,112,124,128,135,136,137,138,139,140,142,150,151,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,301,302,303,304,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,349,350,351,352,353,354,355,356,357,358,359,360,361,362,364,365,366,367,368,369,370,372,373,374,375,376,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,401,402,403,404,405,406,407,408,409,410,411,417,418,420,450,451,452,453,454,455,461,462,463,464,465,466,467,468,471,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,496,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,567,568,569,570,571,572,573,574,575,576,577,578,579,580,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,650,651,653,654,655,656,657,658,660,661,662,663,678,679,680,681,682,683,684,685,686,687,688,689,690,691,693,694,695,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,740,741,742,743,745,746,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,798,799,800,805,806,807,999,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879]
 MsgExclamation( "Erro " + oSefaz:cXmlRetorno )
 msginfo("ATEN�AO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo ) 
 return(.f.)
endif
   
IF oSefaz:cStatus $ "100,102"

   hbNFeDaNFe( oSefaz:cXmlAutorizado )
   hb_MemoWrit( cSubDir+cXmlAutorizado, oSefaz:cXmlAutorizado )
   hb_MemoWrit( "cXmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "cXmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   ffxml   := Memoread(cXmlAutorizado)
   
                        CNPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
                  	    SetProperty('nfe','gerando_xml','Value','Processado!!!'+xchavenfce)
                        SetProperty('NFE','gerando_xml','BLINK',.F.)
							


*hb_MemoWrit( "XmlAutorizado.xml", oSefaz:cXmlAutorizado )
*MsgExclamation( iif( oSefaz:cStatus == "100", "Nota autorizada", "Nota Denegada"  ))
  
ELSE
hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo )

   IF .NOT. Empty( oSefaz:cMotivo )
    *  MsgExclamation( "Problema " + oSefaz:cMotivo )
	  msginfo("ATEN�AO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
return(.f.)
   ELSE
    *  MsgExclamation( "Erro " + oSefaz:cXmlRetorno )
	  msginfo("ATEN�AO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
return(.f.)
   ENDIF
ENDIF


CBDMOD:="55"
xCbdEmpCodigo:="1"      
cCbdvNF      :=ntrim(nfe.Txt_valortotal.value)
cCbdvDesc_cob:=ntrim(NFE.Txt_desconto1.value)
cCbdvProd_ttlnfe:=ntrim(NFE.Txt_total.value)
ClienteTxtCGC:=nfe.Txt_CNPJ.value
CCbdxNome_dest:=nfe.Txt_NOMECLI.value	
public P_DESCONTO:=NTRIM(NFE.Txt_desconto1.value)
 
xCbddEmi     := dtos(date())
vvNFE:=(vNFE)
 oQuery   :=oServer:Query( "SELECT CbdNtfNumero FROM nfe20 WHERE CbdNtfNumero = "+NTRIM(vvNFE)+" AND  cbdmod= "+"55"+" and CbdNtfSerie = "+NTRIM(Serie_nfe)+"  Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
   XCODIGO        :=ALLTRIM(STR(oRow:fieldGet(1)))


chave:= substr(cXml , 0, 48)
cXml:=cSubDir+xcha+"-nfe.xml"
ffxml   :=Memoread(cXml)
IF ntrim(numeronfe)=XCODIGO 
else
cQuery := "INSERT INTO nfe20 (CbdvProd_ttlnfe,CbdvDesc_cob,CbdvNF, cbdmod, CbdCnpj_dest ,chave,CbdNtfNumero,CbdNtfSerie,CbdEmpCodigo,CbddEmi,CbdxNome_dest ,nt_retorno,AUTORIZACAO)  VALUES ('"+cCbdvProd_ttlnfe+"','"+cCbdvDesc_cob+"','"+cCbdvNF+"', '"+cbdmod+"', '"+ClienteTxtCGC+"','"+xchavenfce+"','"+ntrim(numeronfe)+"','"+NTRIM(Serie_nfe)+"','"+xCbdEmpCodigo+"','"+xCbddEmi+"' ,'"+CCbdxNome_dest+"','"+(AllTrim(ffxml))+"','"+CNPROT+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
MsgStop(oQuery:Error())
MsgInfo("Por Favor Selecione o registro SOS nfe20 LINHA 2547")
Endif	
endif

                         SetProperty('nfe','gerando_xml1','Value','VAMOS VISUALIZAR:' +  CNPROT)
                        SetProperty('NFE','gerando_xml1','BLINK',.F.)
		 oPDF    := hbnfeDaNfe():New()
      oDanfe  := hbNFeDaGeral():New()
      RODAPE:="JUMBO SISTEMAS JOS� JUC� (SISTEMA PROPRIO)"
      oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  

oDanfe:ToPDF(  Memoread( cXml ) ,PdfbDir+ xcha+"-nfe.pdf" )
cpdf:=PdfbDir+xcha+"-nfe.pdf" 
PDFOpen(cpdf)
*imprimir_class(cpdf)


cXml_envia:=cSubDir+xcha+"-nfe.xml"
ffxml_envia   :=Memoread(cXml_envia)
ARQEVENTO     :=cSubDir+xcha+"-nfe.xml"

cEnviaPDF:="1"
eemail         :=ALLTRIM(nfe.Txt_email.value)
cEmailDestino  :=ALLTRIM(nfe.Txt_email.value)
*cRet       := MON_ENV("NFe.EnviarEmail("+cEmailDestino+","+alltrim(ffxml_envia)+","+cEnviaPDF+")")
cRet       := MON_ENV("NFe.EnviarEmail("+cEmailDestino+","+alltrim(ARQEVENTO)+","+cEnviaPDF+")")


      SELE DADOSNFE
               If LockReg()  
		              DADOSNFE -> NUM_SEQ    :=(vNFE)
		         	  DADOSNFE -> CHAVE      :=xchavenfce
		         	 * DADOSNFE -> CHAVE_1    :=ffxml
		         	  DADOSNFE -> MODELO     :=55
				      DADOSNFE->(dbcommit())
                      DADOSNFE->(dbunlock())
	                Unlock
		          ENDIF                 
				  
			
MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML ENVIADO.:' + xchavenfce  
atualiza_estoque_cancelamento()
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
vvSeq:=NFe.Txt_NOTA.VALUE
SAIR_nfeh()
retur




