// Harbour MiniGUI                 
// (c)2011 -José juca 
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
Function nfexml_recebe_da_nfce(xnum_seq)
//-------------------------------------------------
Local cQuery
Local aSituacao	    := {}
LOCAL C_CbdNtfNumero:=xnum_seq
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
publ cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
  
xxx:=1

ProcedureValidadeCertificado()
ProcedureescreverINI_3()
ProcedureLerINI()


Reconectar_A() 
	 
CLOSE ALL
abreitemnfe()
abreDADOSNFE()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
abreseq_dav()
abreNFCE()
abreITEMNFCE()
abregra_chave()
abregra_chave()

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
 
USE ((ondeTEMP)+"NFCE.DBF") new alias NFCE exclusive   
  
IF NFCE->NUM_SEQ=0
close all 
USE ((ondetemp)+"NFCE.DBF") new alias NFCE exclusive    // arquivo que vai ter todo o conteudo do TXT
zap
PACK
USE ((ondetemp)+"ITEMNFCE.DBF") new alias ITEMNFCE exclusive    // arquivo que vai ter todo o conteudo do TXT
zap
PACK
endif


 
 
close all 
abreDADOSNFE()
abreitemnfe()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
Reconectar_A() 
abreNFCE()
abreITEMNFCE()


oQuery        := oServer:Query( "Select MAX(CbdNtfNumero)FROM NFE20 CbdNtfNumero")
oRow          := oQuery:GetRow(1)
C_CbdNtfNumero:=((oRow:fieldGet(1)))
C_CbdNtfNumero:=C_CbdNtfNumero+1 
C_CbdNtfSerie := '1'


cQuery  :="SELECT CbdNtfNumero FROM pegaNFE WHERE CbdNtfNumero = "+ntrim(C_CbdNtfNumero)
oQuery  :=oServer:Query( cQuery )
oRow    :=oQuery:GetRow(1)
snumero :=oRow:FieldGet(1) 

If snumero >0
If MsgYesNo( "No momento esta sendo emitida nfe em outro local quer continuar ? "+ntrim(C_CbdNtfNumero)+ " ?", "Confirma" ) 
 cQuery:= "DELETE FROM pegaNFE WHERE CbdNtfNumero = " + ntrim(C_CbdNtfNumero)         
else
return(.f.)
endif
endif
 
	  
DEFINE WINDOW NFe;
       at 000,000;
       WIDTH 1024 ;
       HEIGHT 730;
       TITLE 'NFe' ICON "ICONE01";
       MODAL;
       NOSIZE;
	   ON INIT {||PESQ_PVENDA()}
	   
	   
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
			value 1
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
            VALUE "0-Emissão Própria "
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
            VALUE "Data da Emissão"
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
            VALUE "N.º NOTA:"
            FONTBOLD .T.
            FONTSIZE 10
            FONTNAME "Arial"
     END LABEL  

     DEFINE TEXTBOX Txt_NOTA
            ROW    25
            COL    230
            WIDTH  60
			VALUE C_CbdNtfNumero
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
            VALUE "Série"
            FONTSIZE 09
            FONTNAME "Arial"
     END LABEL  

     DEFINE TEXTBOX Txt_SERIE
            ROW   50
            COL   280
            WIDTH  15
            HEIGHT 20
            VALUE  "1"
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
            WIDTH  90
			value 1
            HEIGHT 8
            OPTIONS {'Cupom','Davs/Orc','Devolução'}
            READONLY NIL
		    on gotfocus NFe.textBTN_cliente.SETFOCUS
            FONTSIZE 10
            FONTNAME "Arial"
			ON change {||MostraOBS()}
		END RADIOGROUP  
    
	
	
	
 @ 05, 410  LABEL IMPORTA ;
   WIDTH 140 ;
   HEIGHT 020 ;
   VALUE "Nº DOC."  ;
   FONT "MS Sans Serif" SIZE 8.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 } BOLD 

   
 @ 25,410 textBTN txt_DAV;
		           of nfe;
		           width 80;
                   HEIGHT 20;
                   value str(C_CbdNtfNumero);
				   font 'verdana';
                   size 10;
                   FONTCOLOR { 255, 000, 000 };
                   BACKCOLOR { 255, 255, 255 };   
                   maxlength 40;
		           rightalign;
                   ON ENTER {||PESQ_PVENDA(),NFE.textBTN_cliente.setfocus}

		//////////////////////////////////////////////////

 @ 05, 500  LABEL oSay223 ;
   WIDTH 80 ;
   HEIGHT 20;
   VALUE "F8-Procura"  ;
   FONT 'Times New Roman'SIZE 10.00 ;
   BACKCOLOR {242,242,242}
   
   
@  25,500 textBTN textBTN_cliente;
	      numeric;
	      width 65;
	      value '';
		  FONT 'Times New Roman' ;
          SIZE 12 FONTCOLOR; 
          BLUE BOLD BACKCOLOR {255,255,0};        
          tooltip 'Digite o código ou clique na LUPA para pesquisar';
		  picture cPathImagem+'lupa.bmp';
		  maxlength 8;
		  rightalign;	   
	      Action {||GetCode_cli(,NFE.textBTN_cliente.setfocus)};
		  ON enter {||iif(!Empty(NFE.textBTN_cliente.Value),pesq_cli(),NFE.textBTN_cliente.setfocus) };
          on gotfocus (CHANGETEXTBTNSTATE(GetControlHandle('textBTN_cliente','NFE'),1),(NFE.textBTN_cliente.backcolor := {255,255,196}))

		  ON KEY F8 ACTION { || GetCode_cli()} 

				
	
			    @ 25,570 TEXTBOX  Txt_NOMECLI ;
				WIDTH 440 ;
				HEIGHT 28;
				BOLD BACKCOLOR {191,225,255};
				ON GOTFOCUS setControl(.T.);
				ON LOSTFOCUS setControl(.F.) NOTABSTOP
	
	
           				
          DEFINE LABEL Lbl_CODSIT
               ROW   50
               COL  500
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
		   tooltip 'Digite o código ou clique na LUPA para pesquisar';
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
				
	  DEFINE RADIOGROUP oRad2 
            ROW  55
            COL  410
            WIDTH 60
			value 2
            HEIGHT 1
            OPTIONS {'A Prazo','Avista'}
            READONLY NIL
		    on gotfocus NFe.textBTN_cliente.SETFOCUS
            FONTSIZE 9
            FONTNAME "Arial"
		//	ON change {||boleto_salvap() }
		END RADIOGROUP  
	 
  
          DEFINE LABEL servico
               ROW  120
               COL  00
               WIDTH 200
               HEIGHT 22
			   FONTCOLOR { 0, 000, 255 }
               BACKCOLOR { 240, 240, 240 } 
             *  VALUE "SITUAÇÃO DO SERVIÇO.:"
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
               ROW  150
               COL  00
               WIDTH 200
               HEIGHT 22
			   FONTCOLOR { 000, 000, 255 }
               BACKCOLOR { 240, 240, 240 } 
             * VALUE "GERANDO XML...............:"
               FONTSIZE 10
               FONTNAME "Arial"
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
         *   BORDER .T.
          * CLIENTEDGE .T.
          *  HSCROLL .T.
          *  VSCROLL .T.
          *  BLINK .T.
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
                		
	@ 20,05 GRID fita ;
		WIDTH 1000 ;
		HEIGHT 300 ;
	    WIDTHS {50,110,380,80,50,90,100,100,80,60,80,80,60 };
        HEADERS {'Itens','Codigo','Descrição','Ncm','Und.','Qtd','Valor R$','Desc.R$','Sub-Total R$','%Icms','STB','CFOP','ICMS' };
        VALUE 1 ;			
   		FONT "Times New Roman" SIZE 10 BOLD ;
	    backcolor WHITE;  
	    fontcolor BLUE ;
		Justify {1,0,0,0,1,1,1,1,1,1,1,1,1,1,1};
		On change {||MostraOBS()} 
	

   	DEFINE EDITBOX Edit_Aplicacao
               ROW    330
               COL    05
	           VALUE   '' 
               WIDTH  1000
               HEIGHT 60
               MAXLENGTH 4000
        END EDITBOX  
		
   END PAGE

   
 
 
        PAGE "Dados do Destinatário"
		
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
			      VALUE "ENDEREÇO" ;
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
						VALUE "PAÍS" ;
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
			CAPTION "Endereço para Entrega";
			FONT "Arial" SIZE 13 Italic ;
			BACKCOLOR {191,225,255};
			FONTCOLOR {191,225,255}
		

        ******************************************************           
   				   @ 238,010 LABEL  ENDCLI ;
					   VALUE "ENDEREÇO" ;
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
                       @ 346,115 LABEL    lTransport     VALUE "RAZÃO SOCIAL"     SIZE 12 AUTOSIZE 
                       @ 346,580 LABEL    lESTA          VALUE "UF"     SIZE 12 AUTOSIZE 
                       @ 346,740 LABEL    lCNPJTrans     VALUE "CNPJ/CPF"         SIZE 12 AUTOSIZE 
				
					   
					   @ 370,015 TEXTBOX  tPLACA         WIDTH 50  HEIGHT 28 VALUE "" BACKCOLOR {191,225,255} UPPERCASE MAXLENGTH 60 NOTABSTOP ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
                       @ 370,115 TEXTBOX  tTransport     WIDTH 450 HEIGHT 28 VALUE "" BACKCOLOR {191,225,255} UPPERCASE MAXLENGTH 60 NOTABSTOP ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
                       @ 370,590 TEXTBOX  tUF            WIDTH 050 HEIGHT 28 VALUE "" BACKCOLOR {191,225,255} UPPERCASE MAXLENGTH 60 NOTABSTOP ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
                       @ 370,740 TEXTBOX  tCNPJTrans     WIDTH 235 HEIGHT 28 VALUE "" BACKCOLOR {191,225,255}                        NOTABSTOP  ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
       END PAGE
				   
	   PAGE "Dados do Boleto"

		
				   
fnfe:="NFE"+NTRIM(NFe.Txt_NOTA.VALUE)
MESN := strzero(month(date() ), 2 )
IF MESN="01"
   	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="02"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="03"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="03"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="04"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="05"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="06"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="07"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="08"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="09"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="10"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="11"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="11"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="12"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ENDIF
			
  
                       @ 25,015 LABEL      LabelPrazo         VALUE "Banco:"     AUTOSIZE
	                   @ 55 ,015 TEXTBOX    txt_banco          value "756"    WIDTH 45  HEIGHT 28   BACKCOLOR {191,223,255} NUMERIC ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS SetControl(.F.)
                               
		        	   @ 25 ,065 LABEL      LabelLimite        VALUE "Agencia"    AUTOSIZE
				       @ 55 ,065 TEXTBOX    txt_agencia        value "3325"   WIDTH 45  HEIGHT 28   BACKCOLOR {191,223,255} NUMERIC ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS SetControl(.F.)
               	     
   					   @ 25 ,115 LABEL      cedente            VALUE "Cod.Cedente"    AUTOSIZE
				       @ 55 ,115 TEXTBOX    txt_cedente        value "4260"   WIDTH 45  HEIGHT 28   BACKCOLOR {191,223,255} NUMERIC ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS SetControl(.F.)
                     
  					   @ 25 ,195 LABEL lDocumento ;
					   VALUE "Documento" ;
					   AUTOSIZE
					   
				       @ 55 ,195 TEXTBOX  txt_documento ;
					   value fnfe;
					   WIDTH 100;
					   HEIGHT 28;
					   BACKCOLOR {191,223,255};
					   ON GOTFOCUS SetControl(.T.);
					   ON LOSTFOCUS SetControl(.F.)

					   
  //////////////////////////////////////////////               	    
    @ 25 ,295 LABEL ;
    lespec;
	VALUE "Especie" ;
	AUTOSIZE
				 
					 
  DEFINE TEXTBOX txt_especie
            ROW  55
            COL  300
		 	value "DM" 
			WIDTH  40
            HEIGHT 24
            FONTNAME "Arial Baltic"
            FONTSIZE 10
			UPPERCASE .t.
            RIGHTALIGN .f.        
		    NUMERIC  .F.
		    readonly .f.
            ON GOTFOCUS This.BackColor:=clrBack  
            ON LOSTFOCUS This.BackColor:=clrNormal 
    END TEXTBOX 
	
  //////////////////////////////////////////////////////////               	
	@ 25 ,375 LABEL ;
    MOEDA;
	VALUE "Moeda" ;
	AUTOSIZE
					   
		
  
					 
  DEFINE TEXTBOX txt_moeda
            ROW  55
            COL  375
		 	value "R$" 
			WIDTH  40
            HEIGHT 24
            FONTNAME "Arial Baltic"
            FONTSIZE 10
			UPPERCASE .t.
            RIGHTALIGN .f.        
		    NUMERIC  .F.
		    readonly .f.
             ON GOTFOCUS This.BackColor:=clrBack  
            ON LOSTFOCUS This.BackColor:=clrNormal 
    END TEXTBOX 


  
	/////////////////////////////////////////////
	@ 25 ,425 LABEL  ;
	  ACEITE  ;
	  VALUE "Aceite" ;
	  AUTOSIZE

				  	     
					 
  DEFINE TEXTBOX txt_aceite
            ROW  55
            COL  425
		 	value "S" 
			WIDTH  40
            HEIGHT 24
            FONTNAME "Arial Baltic"
            FONTSIZE 10
			UPPERCASE .t.
            RIGHTALIGN .f.        
		    NUMERIC  .F.
		    readonly .f.
             ON GOTFOCUS This.BackColor:=clrBack  
            ON LOSTFOCUS This.BackColor:=clrNormal 
    END TEXTBOX 

     @ 25 ,465 LABEL nosso ;
	  VALUE "Nosso numero";
	  AUTOSIZE
	
	
 
  DEFINE TEXTBOX txt_nossonumero
            ROW  55
            COL  465
		 	value cNumero
            WIDTH  80
            HEIGHT 24
            FONTNAME "Arial Baltic"
            FONTSIZE 10
			UPPERCASE .t.
            RIGHTALIGN .f.        
		    INPUTMASK "999999999"
            NUMERIC  .t.
		    readonly .T.
            ON GOTFOCUS SetControl(.T.)
		   ON LOSTFOCUS SetControl(.F.)
    END TEXTBOX 

	
  DEFINE TEXTBOX txt_VALOR
            ROW  55
            COL  665
		 	value 0
            WIDTH  120
            HEIGHT 24
            FONTNAME "Arial Baltic"
            FONTSIZE 10
			UPPERCASE .t.
            RIGHTALIGN .f.        
		    INPUTMASK "999,9999.99"
            NUMERIC  .t.
		    readonly .f.
            ON GOTFOCUS SetControl(.T.)
		  ON LOSTFOCUS SetControl(.F.)
    END TEXTBOX 
	 	  
  					   @ 25 ,800 LABEL      vencimento         VALUE "Vencimento"    AUTOSIZE
				       @ 55 ,800 DATEPICKER vencimentot   value date()+20 WIDTH 100 HEIGHT 28  BACKCOLOR {191,223,255} ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS SetControl(.F.)
                       
				   @ 95 ,005 GRID GridTitulos;
				   WIDTH 1010;
				   HEIGHT 200;
				   HEADERS {"Banco","Agencia","Cedente","Documento","Especie","Aceite","Nosso numero","Vencimento","Valor"  };
				   WIDTHS {80,80,80,110,80,80,120,120,120};
				   FONT "Times New Roman" SIZE 10 BOLD ;
            	   BACKCOLOR {191,225,255};
	               fontcolor BLUE ;
		           Justify {1,0,0,0,0,0,0,0,0,0} 
	 
	 
             @ 320,10 BUTTON   btgravaboleto ;
			  CAPTION "Gravar" ;
			  FONT "Cambria";
			  SIZE 12 BOLD;
			  WIDTH 110;
			  HEIGHT 28;
		     ACTION {||boleto_salvap(),Refresh_boleto(),geranosso()}
     
	 
		 
	   	   @ 320,150 BUTTON   btgera  ;
		   CAPTION "Gerar boleto";  
		   FONT "Cambria";
		   SIZE 12 BOLD ;
		   WIDTH 110 ;
		   HEIGHT 28 ;
	       ACTION {|| multiimpressao()}
	  
*	  ACTION {|| multiimpressao() ,DUPL_1() }
	
         @ 320,280 BUTTON Excluir ;
		   CAPTION "Excluir";  
		   FONT "Cambria";
		   SIZE 12 BOLD ;
		   WIDTH 110 ;
		  HEIGHT 28 ;
	   ACTION ( DELETE_BOLETO(),Refresh_boleto()  ) 
		  
		   
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
                @ 620,330 TEXTBOX  Txt_total            VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
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
                @ 650,005 BUTTON   btGravar           CAPTION "Gera Nfe"           FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION {||gravavda_CLI(),GRAVAENVIA2(),SAIR_nfe()}
                @ 650,136 BUTTON   btExcluir           CAPTION "Exclui Itens"      FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION  wn_excluiitem()
     			@ 650,880 BUTTON   btCancelar          CAPTION "Voltar"            FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION nfe.Release
               ON KEY ESCAPE ACTION nfe.Release
         END WINDOW

 
		 nfe.textBTN_cfop.value:=5102
		// cNotaFiscal:=12
	   ACTIVATE WINDOW nfe
	  Return NIL

 	  
	  
	  
	  
************************************
// --------------/------------------------------------------------------------.
STATIC FUNCTION wn_excluiitem()
// Fun‡Æo....: Excluir o item atual -----------------------------------------.
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
   VALUE "Código"  ;
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
   ON ENTER  {|| w_BUSCA_ITEMW()}
   
      
END WINDOW
ACTIVATE WINDOW  Exclui_Item
RETURN(NIL)


// ---------------------------------------------------------------------------
static FUNCTION w_BUSCA_ITEMW
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
 
select ITEMNFE
SUM SUBTOTAL TO nTtFactura 

*MODIFY CONTROL Txt_valortotal OF NFE VALUE ""  +TransForm(nTtFactura   , "@R 999,999.99")       
*MODIFY CONTROL Txt_valor      OF NFE VALUE ""  +TransForm(nTtFactura   , "@R 999,999.99")       

//NFE.Text_CODBARRA.VALUE := 0
//NFE.Text_CODBARRA.SETFOCUS
Exclui_Item.RELEASE

RETURN(NIL)
// Fim da fun‡Æo de excluir o item atual ------------------------------------.

static function atualizar()
delete item all from FITA of NFE
dbselectarea('ITEMNFE')
ITEMNFE->(ordsetfocus('NUMSEQ'))
ITEMNFE->(dbgotop())
       while .not. eof()
       ADD ITEM {STR(ITEMNFE->ITENS,3),ITEMNFE->PRODUTO,ITEMNFE->descricao,ITEMNFE->ncm,ITEMNFE->unid,transform((ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->VALOR, '9,999,999.99'),transform(ITEMNFE->valor_Desc,"99,999.9999"),transform((ITEMNFE->VALOR*ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->icms,"999.99"),transform(ITEMNFE->STB,"999"),ITEMNFE->cfop,transform(ITEMNFE->icms, '999,99')}TO FITA OF NFe
        ITEMNFE->(dbskip())
       end
select ITEMNFE
SUM SUBTOTAL TO nTtFactura 
*	MODIFY CONTROL Txt_valortotal OF NFE VALUE ""  +TransForm(nTtFactura   , "@R 999,999.99")       
*	MODIFY CONTROL Txt_valor      OF NFE VALUE ""  +TransForm(nTtFactura   , "@R 999,999.99")       
   
NFE.FITA.value:=1
NFE.FITA.setfocus


return(nil)

	  
static FUNCTION DELETE_BOLETO
Local W_CODIGO:= AllTrim(GetColValue("GridTitulos", "NFE", 4 ))

 
        dbselectarea('BOLETO')
        OrdSetFocus('controle')
		BOLETO->(dbseek(W_CODIGO))
      	XNOME:=BOLETO->controle



 if MsgYesNo("Deseja Deletar este Item ?", "Produto..."+XNOME)
      IF BOLETO->(DBRLOCK())
         BOLETO->(DBDELETE())
         BOLETO->(DBCOMMIT())
         BOLETO->(DBSKIP(-1))
         endif  
        endif
 
	  
	  
function geranosso()
	  
//SELE BOLETO
//Go bott
//if BOLETO->parc<=0
//XXX=1
//ELSE
//XXX= XXX+1
//ENDIF

	   fnfe:="NFE"+NTRIM(NFe.Txt_NOTA.VALUE)+"/"+STRZERO(XXX,3)
		
	  fnfe:="NFE"+NTRIM(NFe.Txt_NOTA.VALUE)

MESN := strzero(month(date() ), 2 )
IF MESN="01"
   	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="02"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="03"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="03"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="04"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="05"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="06"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="07"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="08"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="09"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="10"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="11"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="11"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="12"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ENDIF
return

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

/*
 SELE  FIMCOPUM
    If LockReg()  
	FIMCOPUM->TOTAL_IMP:=Impostos_Cupom
    FIMCOPUM->(dbcommit())
    FIMCOPUM->(dbunlock())
*/
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
*MsgInfo("Encontrado  " )

*cQuery	:= oServer:Query( "UPDATE peganfe SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = " +((C_CbdNtfNumero)))
*If cQuery:NetErr()		
*     	MsgStop(cQuery:Error())
*	 Else
*EndIf

else
*MsgInfo("nao Encontrado  " )

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




*---------------------------------------------------------------------
static function MostraOBS()
*---------------------------------------------------------------------
LOCAL C_CODIGO :=NFE.textBTN_cliente.VALUE
local pCode:=AllTrim(str(nfe.textBTN_cfop.value))


Reconectar_A() 
 oQuery := oServer:Query( "Select ALIQUOTA_ICMS From empresa" )
 If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor verifique linha 5964")
    Return Nil
  Endif
  aRow	          :=oQuery:GetRow(1)
 public C_ALIQUOTA:=aRow:fieldGet(1)
*  msginfo(C_ALIQUOTA)
	
  sele DADOSNFE
   If LockReg()  
    DADOSNFE->aliquota     :=C_ALIQUOTA
    DADOSNFE->(dbcommit())
    DADOSNFE->(dbunlock())
   Unlock
  ENDIF 


TOTAL :=0
xtotal:=0
ztotal:=0
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
    DADOSNFE->desc1        :=ztotal
 *  DADOSNFE->TOTAL_IMP    :=DADOSNFE->TOTAL_IMP+Impostos_Cupom_1
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
*MSGINFO(TOTALICMS)


VV_VALOR:=DADOSNFE->TOTAL_IMP/Vv_total*100


cDescricao:=transform((DADOSNFE->TOTAL_IMP),"@R 999,999.99")+ " = " +transform((VV_VALOR),"@R 9,999.99")+"% FONTE IBPT" 
LIN_21:="               VALOR APROXIMADO DOS TRIBUTOS R$"+" "+cDescricao


IF nfe.oRad3.VALUE == 1			
 * NFE.Edit_Aplicacao.VALUE:=+"Valor crédito do ICMS        "     +   TOTALICMS       + "          aliquota De      " +  NTOTAL  +  "   pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)" +   "  " +LIN_21

  NFE.Edit_Aplicacao.VALUE:=+'Documento emitido por empresa optante pelo Simples Nacional, permite aproveitamento de '+;
										 'credito de ICMS no Valor de R$ '+transf(TOTALICMS,'9,999,999.99')          +  ',correspondente a Aliquota de '+;
										 transform(DADOSNFE->ALIQUOTA,'99,999,999.99')+'% nos termos do art. 23 da LC 123 ;                            '+;
										 "Valor Aproximado dos Tributos R$"+transf(DADOSNFE->TOTAL_IMP,"@R 999,999.99")+"("+transf(VV_VALOR,"999.99")+"%) Conf. Lei 12.741/2012   Fonte: Tabela IBPT (www.ibpt.com.br);  " 
 
 
 endif

IF nfe.oRad3.VALUE == 2			
 
 NFE.Edit_Aplicacao.VALUE:='NOTA FISCAL ELETRONICA REFERENTE AO CUPOM FISCAL'+"    "+"EMITIDO  PELA  A  ECF    "+DADOSNFE->SERIE  +"   COO  "+STRZERO(DADOSNFE->num_seq,6)+"    "+"CCF   "+ (DADOSNFE->CCF) ; 
 +"Valor crédito do ICMS        "     +   TOTALICMS       + "          aliquota De      " +  NTOTAL  +  "   pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)" +   "  " +LIN_21
endif

//NFE.Edit_Aplicacao.VALUE:="Valor crédito do ICMS        "     +   TOTALICMS       + "          aliquota De      " +  NTOTAL  + "%"+ "   pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)"

IF nfe.oRad3.VALUE == 3			
  
NFE.Edit_Aplicacao.VALUE:=" NOTA FISCAL DE DEVOLUCAO DE EMPRESA OPTTANTE PELO SIMPES      ";
+"GERA CREDITO DE ICMS CONF. A NOTA FISCAL  NUMERO                      EMISSAO DE                      "      ;
+"REF. A BASE DE CALCULO NO VALOR DE R$                        VALOR DO ICMS R$                         "
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
STATIC Function PESQ_PVENDA()
*----------------------------------
abreNFCE()
abreITEMNFCE()

Reconectar_A() 
 oQuery := oServer:Query( "Select ALIQUOTA_ICMS From empresa" )
 If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor verifique linha 5964")
    Return Nil
  Endif
  aRow	          :=oQuery:GetRow(1)
 public C_ALIQUOTA:=aRow:fieldGet(1)
  *   msginfo(C_ALIQUOTA)
	
  sele DADOSNFE
   If LockReg()  
    DADOSNFE->aliquota     :=C_ALIQUOTA
    DADOSNFE->(dbcommit())
    DADOSNFE->(dbunlock())
   Unlock
  ENDIF 
	
	
selec ITEMNFcE
 Do While ! ITEMNFCE->(Eof())
  XNCM:=ITEMNFcE->ncm
			  
	
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
  
 Impostos_Cupom_1:=ITEMNFcE->SUBTOTAL*aliqnac/100
 Impostos_Cupom  :=Impostos_Cupom+Impostos_Cupom_1
 XV_IBPT         :=ITEMNFcE->SUBTOTAL*aliqnac/100
					  

	 
		            	selec ITEMNFE		   
                        ITEMNFE->(DBAPPEND())
                        ITEMNFE->COD_PROD       := ITEMNFcE->COD_PROD
		              	ITEMNFE->PRODUTO        := ITEMNFcE->PRODUTO 
			            ITEMNFE->ITENS          := ITEMNFcE->ITENS 
                        ITEMNFE->SUBTOTAL       := ITEMNFcE->SUBTOTAL  
                        ITEMNFE->descricao      := ITEMNFcE->descricao
                        ITEMNFE->NSEQ_ORC       := ITEMNFcE->NSEQ_ORC  
			            ITEMNFE->ncm            := ITEMNFcE->ncm
		             	ITEMNFE->qtd            := ITEMNFcE->qtd  
                        ITEMNFE->quant          := ITEMNFcE->quant 
                        ITEMNFE->valor          := ITEMNFcE->valor
                        ITEMNFE->preco          := ITEMNFcE->preco
                        ITEMNFE->unid           := ITEMNFcE->unid   
						ITEMNFE->cfop           := ITEMNFcE->cfop 
						ITEMNFE->aliquota       := ITEMNFcE->aliquota
						ITEMNFE->icms           := ITEMNFcE->icms
						ITEMNFE->AL_IBPT        := ITEMNFcE->AL_IBPT
						ITEMNFE->UNIT_DESC      := ITEMNFcE->SUBTOTAL 
	 			        ITEMNFE->V_IBPT         := XV_IBPT
                        ITEMNFE->(DBCOMMIT())
                        ITEMNFE->(DBUNLOCK())
	
				  
				  
ITEMNFCE->(dbskip())
LOOP
ENDD




 SELEC NFCE
 Do While ! NFCE->(Eof())
 
	 M->numero=ITEMNFE->NSEQ_ORC
         SELE DADOSNFE
         OrdSetFocus('NUMSEQ')
         Seek M->numero
		   
		   
		   
				 	if (!EOF())
                    If LockReg()  
		               DADOSNFE-> NUM_SEQ    :=NFCE-> NUM_SEQ
		               DADOSNFE-> DATA_ORC   :=NFCE-> DATA_ORC
                       DADOSNFE-> COD_CLI    :=NFCE-> COD_CLI
                       DADOSNFE-> NOM_CLI    :=NFCE-> NOM_CLI
                       DADOSNFE-> CL_CGC     :=NFCE-> CL_CGC 
                       DADOSNFE-> RGIE       :=NFCE-> RGIE
                       DADOSNFE->CL_END      :=NFCE->CL_END 
                       DADOSNFE-> CL_PESSOA  :=NFCE-> CL_PESSOA
                       DADOSNFE-> CL_CID     :=NFCE-> CL_CID
                       DADOSNFE-> COD_IBGE   :=NFCE-> COD_IBGE
                       DADOSNFE-> ED_NUMERO  :=NFCE-> ED_NUMERO
    		           DADOSNFE-> CEP        :=NFCE-> CEP
                       DADOSNFE-> BAIRRO     :=NFCE-> BAIRRO 
    		           DADOSNFE-> estado     :=NFCE-> estado 
                       DADOSNFE-> DESCONTO   :=NFCE-> DESCONTO
				       DADOSNFE->TOTAL_IMP   :=Impostos_Cupom			   
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
	                Unlock
		          ENDIF                 
               else
                     
					 
	                   DADOSNFE->(dbappend())
	   	               DADOSNFE-> NUM_SEQ    :=NFCE-> NUM_SEQ
		               DADOSNFE-> DATA_ORC   :=NFCE-> DATA_ORC
                       DADOSNFE-> COD_CLI    :=NFCE-> COD_CLI
                       DADOSNFE-> NOM_CLI    :=NFCE-> NOM_CLI
                       DADOSNFE-> CL_CGC     :=NFCE-> CL_CGC 
                       DADOSNFE-> RGIE       :=NFCE-> RGIE
                       DADOSNFE->CL_END      :=NFCE->CL_END 
                       DADOSNFE-> CL_PESSOA  :=NFCE-> CL_PESSOA
                       DADOSNFE-> CL_CID     :=NFCE-> CL_CID
                       DADOSNFE-> COD_IBGE   :=NFCE-> COD_IBGE
                       DADOSNFE-> ED_NUMERO  :=NFCE-> ED_NUMERO
    		           DADOSNFE-> CEP        :=NFCE-> CEP
                       DADOSNFE-> BAIRRO     :=NFCE-> BAIRRO 
    		           DADOSNFE-> estado     :=NFCE-> estado 
                       DADOSNFE-> DESCONTO   :=NFCE-> desc1
				       DADOSNFE->TOTAL_IMP   :=Impostos_Cupom				   
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
                    endif
					
				   If LockReg()  
					   DADOSNFE-> TOTAL_VEN  :=NFCE-> TOTAL_VEN
                       DADOSNFE-> VALOR_TOT  :=NFCE-> VALOR_TOT 
                       DADOSNFE-> desc1      :=NFCE-> desc1  
    		           DADOSNFE-> desc2      :=NFCE-> desc2
		               DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
	                endif
					
					
					
        
NFCE->(dbskip())
LOOP
ENDD

atualizar()



				   
 NFE.Txt_valortotal.value   :=DADOSNFE-> TOTAL_VEN
 NFE.Txt_total.value        :=DADOSNFE-> VALOR_TOT
 NFE.Txt_desconto.value     :=DADOSNFE-> desc2 
 NFE.Txt_desconto1.value    :=DADOSNFE-> desc1 
 NFE.txt_VALOR.value        :=DADOSNFE-> TOTAL_VEN
NFe.textBTN_cliente.SETFOCUS
*NFe.RELEASE
return






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
   CAPTION "Endereço Cidade estado"  ;
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
    MsgInfo("SQL SELECT error: " , "ATENÇÃO")
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

 nfe.Txt_IECLI.setfocus
 nfe.Txt_CNPJ.setfocus
 nfe.Txt_TIPO.setfocus
 nfe.Txt_ENDCLI1.setfocus
 nfe.Txt_ENDCLI.setfocus
 nfe.Txt_NOMECLI.setfocus
 nfe.Txt_CIDCLI.setfocus
 nfe.Txt_CIDCLI1.setfocus
 nfe.Txt_NUMCLI.setfocus
 nfe.Txt_UFCLI.setfocus
 nfe.Txt_BAIRROCLI.setfocus
 nfe.Txt_BAIRROCLI1.setfocus
 nfe.Txt_CEPCLI.setfocus
 nfe.Txt_CEPCLI1.setfocus
 nfe.Txt_email.setfocus
 NFE.textBTN_IBGE.setfocus

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




IF nfe.oRad3.VALUE == 1   /// vai nfce 
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
xCbdCFOP:=6102
xst     :="202"
xstb    :=202  
elseif C_UF<>"RO"
xCbdCFOP:=6403
xst     :="201" 
xstb    :=201 
endif
endif


 nfe.Txt_IECLI.setfocus
 nfe.Txt_CNPJ.setfocus
 nfe.Txt_TIPO.setfocus
 nfe.Txt_ENDCLI1.setfocus
 nfe.Txt_ENDCLI.setfocus
 nfe.Txt_NOMECLI.setfocus
 nfe.Txt_CIDCLI.setfocus
 nfe.Txt_CIDCLI1.setfocus
 nfe.Txt_NUMCLI.setfocus
 nfe.Txt_UFCLI.setfocus
 nfe.Txt_BAIRROCLI.setfocus
 nfe.Txt_BAIRROCLI1.setfocus
 nfe.Txt_CEPCLI.setfocus
 nfe.Txt_CEPCLI1.setfocus
 nfe.Txt_email.setfocus
 NFE.textBTN_IBGE.setfocus
 

*MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	 
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj está vazio','Atenção')
	      MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	      NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj está vazio','Atenção')
	      MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	      NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   
	   
	   	   
IF EMPTY(NFE.T_NOMECLI.VALUE)
          msgexclamation('O campo nome está vazio','Atenção')
	      MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	      NFE.T_NOMECLI.VALUE := ""
          NFE.T_NOMECLI.SETFOCUS
   Return( .F. )
 endif
 
  
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
         MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	      msgexclamation('O campo cnpj está vazio','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
 
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj está vazio','Atenção')
	      MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	      NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   



 
 IF EMPTY(NFE.Txt_ENDCLI.VALUE)
        msgexclamation('O campo endereço está vazio','Atenção')
  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	     NFE.Txt_ENDCLI.VALUE := ""
         NFE.Txt_ENDCLI.SETFOCUS
   Return( .F. )
 endif



  IF EMPTY(NFE.Txt_CIDCLI.VALUE )
        msgexclamation('O campo Cidade está vazio','Atenção')
   MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	    NFE.Txt_CIDCLI.VALUE  := ""
        NFE.Txt_CIDCLI.SETFOCUS
   Return( .F. )
 endif

 
  IF EMPTY(NFE.textBTN_IBGE.VALUE)
        msgexclamation('O campo Codigo municipio esta vazio','Atenção')
	     MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	     NFE.textBTN_IBGE.VALUE  := ""
         NFE.textBTN_IBGE.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_NUMCLI.VALUE)
        msgexclamation('O campo numero logadoura está vazio','Atenção')
        MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	    NFE.Txt_NUMCLI.VALUE := ""
        NFE.Txt_NUMCLI.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_CEPCLI.VALUE)
        msgexclamation('O campo cep está vazio','Atenção')
	    MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
	     NFE.Txt_CEPCLI.VALUE := ""
         NFE.Txt_CEPCLI.SETFOCUS
   Return( .F. )
 endif
 
 IF EMPTY(NFE.Txt_BAIRROCLI.VALUE)
        msgexclamation('O campo Bairro está vazio','Atenção')
 	MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_BAIRROCLI.VALUE := ""
         NFE.Txt_BAIRROCLI.SETFOCUS
   Return( .F. )
 endif
 
 
 IF EMPTY(NFE.Txt_UFCLI.VALUE)
         msgexclamation('O campo Estado está vazio','Atenção')
	 	 MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_UFCLI.VALUE := ""
         NFE.Txt_UFCLI.SETFOCUS
   Return( .F. )
 endif

NFE.textBTN_cliente.SETFOCUS

 
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
                        ITEMNFE->cfop  :=ntrim(xCbdCFOP)
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


 nfe.Txt_IECLI.setfocus
 nfe.Txt_CNPJ.setfocus
 nfe.Txt_TIPO.setfocus
 nfe.Txt_ENDCLI1.setfocus
 nfe.Txt_ENDCLI.setfocus
 nfe.Txt_NOMECLI.setfocus
 nfe.Txt_CIDCLI.setfocus
 nfe.Txt_CIDCLI1.setfocus
 nfe.Txt_NUMCLI.setfocus
 nfe.Txt_UFCLI.setfocus
 nfe.Txt_BAIRROCLI.setfocus
 nfe.Txt_BAIRROCLI1.setfocus
 nfe.Txt_CEPCLI.setfocus
 nfe.Txt_CEPCLI1.setfocus
 nfe.Txt_email.setfocus
 NFE.textBTN_IBGE.setfocus




form_auto.Grid_22.value:=1
form_auto.Grid_22.setfocus
return(nil)

//////////////////////////////
function pesqbotao()
//////////////////////////////
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
return




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
  *  DADOSNFE->aliquota     :=C_ALIQUOTA
  *  DADOSNFE->desc1        :=ztotal
    DADOSNFE->(dbcommit())
    DADOSNFE->(dbunlock())
   Unlock
  ENDIF 
ITEMNFE->(dbskip())
enddo


xxtipo:=nfe.Txt_TIPO.value

IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo CPF está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   
	   
	   	   
IF EMPTY(NFE.T_NOMECLI.VALUE)
          msgexclamation('O campo nome está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.T_NOMECLI.VALUE := ""
          NFE.T_NOMECLI.SETFOCUS
   Return( .F. )
 endif
 
  
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
 
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   



 
 IF EMPTY(NFE.Txt_ENDCLI.VALUE)
        msgexclamation('O campo endereço está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_ENDCLI.VALUE := ""
         NFE.Txt_ENDCLI.SETFOCUS
   Return( .F. )
 endif



  IF EMPTY(NFE.Txt_CIDCLI.VALUE )
        msgexclamation('O campo Cidade está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_CIDCLI.VALUE  := ""
         NFE.Txt_CIDCLI.SETFOCUS
   Return( .F. )
 endif

 
  IF EMPTY(NFE.textBTN_IBGE.VALUE)
        msgexclamation('O campo Codigo municipio esta vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.textBTN_IBGE.VALUE  := ""
         NFE.textBTN_IBGE.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_NUMCLI.VALUE)
        msgexclamation('O campo numero logadoura está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_NUMCLI.VALUE := ""
         NFE.Txt_NUMCLI.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_CEPCLI.VALUE)
        msgexclamation('O campo cep está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_CEPCLI.VALUE := ""
         NFE.Txt_CEPCLI.SETFOCUS
   Return( .F. )
 endif
 
 IF EMPTY(NFE.Txt_BAIRROCLI.VALUE)
        msgexclamation('O campo Bairro está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_BAIRROCLI.VALUE := ""
         NFE.Txt_BAIRROCLI.SETFOCUS
   Return( .F. )
 endif
 
 
 IF EMPTY(NFE.Txt_UFCLI.VALUE)
         msgexclamation('O campo Estado está vazio','Atenção')
		 MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_UFCLI.VALUE := ""
         NFE.Txt_UFCLI.SETFOCUS
   Return( .F. )
 endif

NFE.textBTN_cliente.SETFOCUS

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
  	                    DADOSNFE->RGIE       :=""
					ENDIF
           
    		      IF xxtipo="P"
                        DADOSNFE->CL_CGC     :=xCPF   
             	        DADOSNFE->RGIE       :=xie
			   ENDIF
			   
               IF xxtipo="I"
                        DADOSNFE->CL_CGC     :=xcnpj 
             	        DADOSNFE->RGIE       :=""
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

xxxx:=1
//gravavda_CLI()
NFe_ATV( )  

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
          msgexclamation('O campo cnpj está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo CPF está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   
	   
	   	   
IF EMPTY(NFE.T_NOMECLI.VALUE)
          msgexclamation('O campo nome está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.T_NOMECLI.VALUE := ""
          NFE.T_NOMECLI.SETFOCUS
   Return( .F. )
 endif
 
  
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
 
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj está vazio','Atenção')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   



 
 IF EMPTY(NFE.Txt_ENDCLI.VALUE)
        msgexclamation('O campo endereço está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_ENDCLI.VALUE := ""
         NFE.Txt_ENDCLI.SETFOCUS
   Return( .F. )
 endif



  IF EMPTY(NFE.Txt_CIDCLI.VALUE )
        msgexclamation('O campo Cidade está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_CIDCLI.VALUE  := ""
         NFE.Txt_CIDCLI.SETFOCUS
   Return( .F. )
 endif

 
  IF EMPTY(NFE.textBTN_IBGE.VALUE)
        msgexclamation('O campo Codigo municipio esta vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.textBTN_IBGE.VALUE  := ""
         NFE.textBTN_IBGE.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_NUMCLI.VALUE)
        msgexclamation('O campo numero logadoura está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_NUMCLI.VALUE := ""
         NFE.Txt_NUMCLI.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_CEPCLI.VALUE)
        msgexclamation('O campo cep está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_CEPCLI.VALUE := ""
         NFE.Txt_CEPCLI.SETFOCUS
   Return( .F. )
 endif
 
 IF EMPTY(NFE.Txt_BAIRROCLI.VALUE)
        msgexclamation('O campo Bairro está vazio','Atenção')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_BAIRROCLI.VALUE := ""
         NFE.Txt_BAIRROCLI.SETFOCUS
   Return( .F. )
 endif
 
 
 IF EMPTY(NFE.Txt_UFCLI.VALUE)
         msgexclamation('O campo Estado está vazio','Atenção')
		 MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Atenção')
         NFE.Txt_UFCLI.VALUE := ""
         NFE.Txt_UFCLI.SETFOCUS
   Return( .F. )
 endif

  
    dbselectarea('DADOSNFE')
    ordsetfocus('NUMSEQ')
    DADOSNFE->(dbgotop())
    DADOSNFE->(dbseek(cPedido))

 If .Not. Found()           
    MsgINFO('Não Encontrada ;;Tecle ENTER')
    Return( .F. )    
 Endif

 
if nfe.textBTN_cfop.value =5102 .and. nfe.oRad3.VALUE = 3 
 MsgINFO('o cfop não confere')
 Return( .F. )  
endif

if nfe.textBTN_cfop.value =6929 .and. nfe.oRad3.VALUE = 3 
 MsgINFO('o cfop não confere')
 Return( .F. )  
endif

if nfe.textBTN_cfop.value =5102 .and. nfe.oRad3.VALUE = 3 
 MsgINFO('o cfop não confere')
 Return( .F. )  
endif

  if nfe.textBTN_cfop.value =6102 .and. nfe.oRad3.VALUE = 3 
 MsgINFO('o cfop não confere')
 Return( .F. )  
endif
  

  
TOTALICMS:=0
NTOTAL:=0
NQTD:=0
NQTD1:=0
vv_total:=0
VV_VALOR:=0
NTOTAL   :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')
vv_total :=(DADOSNFE->VALOR_TOT)
TOTALICMS:=vv_total*DADOSNFE->ALIQUOTA/100
VV_VALOR:=DADOSNFE->TOTAL_IMP/Vv_total*100

  NFE.Edit_Aplicacao.VALUE:=+'Documento emitido por empresa optante pelo Simples Nacional, permite aproveitamento de '+;
										 'credito de ICMS no Valor de R$ '+transf(TOTALICMS,'9,999,999.99')          +  ',correspondente a Aliquota de '+;
										 transform(DADOSNFE->ALIQUOTA,'99,999,999.99')+'% nos termos do art. 23 da LC 123 ;                            '+;
										 "Valor Aproximado dos Tributos R$"+transf(DADOSNFE->TOTAL_IMP,"@R 999,999.99")+"("+transf(VV_VALOR,"999.99")+"%) Conf. Lei 12.741/2012   Fonte: Tabela IBPT (www.ibpt.com.br);  " 
 

 
//////////////////////empresa 
Reconectar_A() 

 oQuery := oServer:Query( "Select razaosoc,cidade,end,cep,fone_cont,bairro,estado,insc,cgc,numero,usuario From empresa Order By usuario" )
 If oQuery:NetErr()												
  MsgInfo("Nao Encontrei a Tabela " , "ATENÇÃO")
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
	
         Local3:="C:\ACBrNFeMonitor\ENTNFE.TXT" 
 
 
        STATUS_NFe:={}
		 aadd(STATUS_NFe,{'NFE.StatusServico'})
       
		 
         FERASE(PATH+"\ENTNFE.TXT")
		 handle:=fcreate("ENTNFE.TXT")
			for i=1 to len(STATUS_NFe)
			fwrite(handle,alltrim(STATUS_NFe[i,1]))
		      fwrite(handle,chr(13)+chr(10))
			next
		fclose(handle)  


		 DADOS_NFe:={}
		
		 aadd(DADOS_NFe,{'NFE.CriarEnviarNFe'})
		 aadd(DADOS_NFe,{'[Identificacao]'})
		 aadd(DADOS_NFe,{'NaturezaOperacao='+NATU})
		 aadd(DADOS_NFe,{'Modelo=55'})
		 aadd(DADOS_NFe,{'Serie=1'})
		 aadd(DADOS_NFe,{'Codigo='+C_CbdNtfNumero})
		 aadd(DADOS_NFe,{'Numero='+C_CbdNtfNumero})
		 aadd(DADOS_NFe,{'Serie=1'})
		 aadd(DADOS_NFe,{'Emissao='+dtoc(DATE())})
		 aadd(DADOS_NFe,{'Saida='+dtoc(DATE())})
		 aadd(DADOS_NFe,{'hSaiEnt='+(TIME())})
*	     aadd(DADOS_NFe,{'Tipo=1'})


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

		 aadd(DADOS_NFe,{'Finalidade=1'})
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
 



// gravaçoes  destinatarios
tt:=0
*do while !DADOSNFE->(Eof())	

//******************************************************
 IF DADOSNFE->CL_PESSOA='J'     
	ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
	XindIEDest               :="1"
 	insc                    :=(DADOSNFE->RGIE)
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := ""
	CCbdxBairro_dest	    :=alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :=(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :=alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :=alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :=(DADOSNFE->cep)
   	CCbdcPais_dest	  	    := '1058'
   	CCbdxPais_dest	  	    := 'BRASIL'
	CCbdfone_dest	  	    := "0"
   	CCbdISUF   		  	    := ""
    mfone_Destinatario      := ""
	
		  // Dados do destinatário

		 aadd(DADOS_NFe,{'[Destinatario]' })
		 aadd(DADOS_NFe,{'CNPJ='+ClienteTxtCGC })
		 aadd(DADOS_NFe,{'indIEDest='+XindIEDest})
		 aadd(DADOS_NFe,{'IE='+insc})
		 aadd(DADOS_NFe,{'NomeRazao='+CCbdxNome_dest})
		 aadd(DADOS_NFe,{'Fantasia='  })
		 aadd(DADOS_NFe,{'Fone=' +Alltrim(mfone_Destinatario ) })
		 aadd(DADOS_NFe,{'CEP=' +CCbdCEP_dest})
		 aadd(DADOS_NFe,{'Logradouro=' +CCbdxLgr_dest})
		 aadd(DADOS_NFe,{'Numero='+CCbdnro_dest})
		 aadd(DADOS_NFe,{'Complemento='  })
         if !Empty(CCbdxBairro_dest)
		 aadd(DADOS_NFe,{'Bairro=' +Alltrim(CCbdxBairro_dest) })
         else
		 aadd(DADOS_NFe,{'Bairro=CENTRO'  })
         endif
		 aadd(DADOS_NFe,{'CidadeCod='+CCbdcMun_dest })
		 aadd(DADOS_NFe,{'Cidade='+CCbdxMun_dest})
		 aadd(DADOS_NFe,{'UF='+CCbdUF_dest})
		 aadd(DADOS_NFe,{'PaisCod=1058'})
		 aadd(DADOS_NFe,{'Pais=BRASIL'})
ENDIF

//*******************************************************
  IF DADOSNFE->CL_PESSOA='P'     
	ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
	XindIEDest               :="1"
 	insc                    :=(DADOSNFE->RGIE)
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := ""
	CCbdxBairro_dest	    :=alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :=alltrim(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :=alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :=alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :=limpa(DADOSNFE->cep)
   	CCbdcPais_dest	  	    := '1058'
   	CCbdxPais_dest	  	    := 'BRASIL'
	CCbdfone_dest	  	    := "0"
   	CCbdISUF   		  	    := ""
    mfone_Destinatario      := ""
	
		  // Dados do destinatário

    	 aadd(DADOS_NFe,{'[Destinatario]' })
		 aadd(DADOS_NFe,{'CNPJ='+ClienteTxtCGC })
         aadd(DADOS_NFe,{'indIEDest='+XindIEDest})
		 aadd(DADOS_NFe,{'IE='+insc})
		 aadd(DADOS_NFe,{'NomeRazao='+CCbdxNome_dest})
         aadd(DADOS_NFe,{'Fantasia='  })
		 aadd(DADOS_NFe,{'Fone=' +Alltrim(mfone_Destinatario ) })
		 aadd(DADOS_NFe,{'CEP=' +CCbdCEP_dest})
		 aadd(DADOS_NFe,{'Logradouro=' +CCbdxLgr_dest})
		 aadd(DADOS_NFe,{'Numero='+CCbdnro_dest})
		 aadd(DADOS_NFe,{'Complemento='  })
         if !Empty(CCbdxBairro_dest)
		 aadd(DADOS_NFe,{'Bairro=' +Alltrim(CCbdxBairro_dest) })
         else
		 aadd(DADOS_NFe,{'Bairro=CENTRO'  })
         endif
		 aadd(DADOS_NFe,{'CidadeCod='+CCbdcMun_dest })
		 aadd(DADOS_NFe,{'Cidade='+CCbdxMun_dest})
		 aadd(DADOS_NFe,{'UF='+CCbdUF_dest})
		 aadd(DADOS_NFe,{'PaisCod=1058'})
		 aadd(DADOS_NFe,{'Pais=BRASIL'})

ENDIF

//***************************************************
  IF DADOSNFE->CL_PESSOA='I'     
	ClienteTxtCGC:=(DADOSNFE->CL_CGC)
	XindIEDest               :="2"
	Insc                    :="isento"
	ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := ""
	CCbdxBairro_dest	    :=alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :=alltrim(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :=alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :=alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :=limpa(DADOSNFE->cep)
   	CCbdcPais_dest	  	    := '1058'
   	CCbdxPais_dest	  	    := 'BRASIL'
	CCbdfone_dest	  	    := "0"
   	CCbdISUF   		  	    := ""
     mfone_Destinatario     := ""
	
	  // Dados do destinatário
   	     aadd(DADOS_NFe,{'[Destinatario]' })
		 aadd(DADOS_NFe,{'CNPJ='+ClienteTxtCGC })
		 aadd(DADOS_NFe,{'indIEDest='+XindIEDest})
		 aadd(DADOS_NFe,{'IE='+insc})
		 aadd(DADOS_NFe,{'NomeRazao='+CCbdxNome_dest})
         aadd(DADOS_NFe,{'Fantasia='  })
		 aadd(DADOS_NFe,{'Fone=' +Alltrim(mfone_Destinatario ) })
		 aadd(DADOS_NFe,{'CEP=' +CCbdCEP_dest})
		 aadd(DADOS_NFe,{'Logradouro=' +CCbdxLgr_dest})
		 aadd(DADOS_NFe,{'Numero='+CCbdnro_dest})
		 aadd(DADOS_NFe,{'Complemento='  })
         if !Empty(CCbdxBairro_dest)
		 aadd(DADOS_NFe,{'Bairro=' +Alltrim(CCbdxBairro_dest) })
         else
		 aadd(DADOS_NFe,{'Bairro=CENTRO'  })
         endif
		 aadd(DADOS_NFe,{'CidadeCod='+CCbdcMun_dest })
		 aadd(DADOS_NFe,{'Cidade='+CCbdxMun_dest})
		 aadd(DADOS_NFe,{'UF='+CCbdUF_dest})
		 aadd(DADOS_NFe,{'PaisCod=1058'})
		 aadd(DADOS_NFe,{'Pais=BRASIL'})
ENDIF
//***************************************************
  IF DADOSNFE->CL_PESSOA='F'     
	ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
	Insc                    :="isento"
	XindIEDest               :="2"
	ClienteTxtCGC           :=SUBSTR(DADOSNFE->CL_CGC,1,11)
    CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := ""
	CCbdxBairro_dest	    :=alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :=alltrim(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :=alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :=alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :=alltrim(DADOSNFE->cep)
   	CCbdcPais_dest	  	    := '1058'
   	CCbdxPais_dest	  	    := 'BRASIL'
	CCbdfone_dest	  	    := "0"
   	CCbdISUF   		  	    := ""
    mfone_Destinatario      := ""
	
	  // Dados do destinatário
	     aadd(DADOS_NFe,{'[Destinatario]' })
		 aadd(DADOS_NFe,{'CNPJ='+ClienteTxtCGC })
	 	 aadd(DADOS_NFe,{'indIEDest='+XindIEDest})
		 aadd(DADOS_NFe,{'IE='+insc})
		 aadd(DADOS_NFe,{'NomeRazao='+CCbdxNome_dest})
         aadd(DADOS_NFe,{'Fantasia='  })
		 aadd(DADOS_NFe,{'Fone=' +Alltrim(mfone_Destinatario ) })
		 aadd(DADOS_NFe,{'CEP=' +CCbdCEP_dest})
		 aadd(DADOS_NFe,{'Logradouro=' +CCbdxLgr_dest})
		 aadd(DADOS_NFe,{'Numero='+CCbdnro_dest})
		 aadd(DADOS_NFe,{'Complemento='  })
         if !Empty(CCbdxBairro_dest)
		 aadd(DADOS_NFe,{'Bairro=' +Alltrim(CCbdxBairro_dest) })
         else
		 aadd(DADOS_NFe,{'Bairro=CENTRO'  })
         endif
		 aadd(DADOS_NFe,{'CidadeCod='+CCbdcMun_dest })
		 aadd(DADOS_NFe,{'Cidade='+CCbdxMun_dest})
		 aadd(DADOS_NFe,{'UF='+CCbdUF_dest})
		 aadd(DADOS_NFe,{'PaisCod=1058'})
		 aadd(DADOS_NFe,{'Pais=BRASIL'})
	
ENDIF

cPedido        := DADOSNFE->num_seq
nNumeroOrc     := cPedido
registro:=0
DESCONTO_X:=0
Sele ITEMNFE
OrdSetFocus('DESCRICAO')
GO Top
ITEMNFE->(dbskip(-1))
do while !ITEMNFE->(eof())
If  ITEMNFE->NSeq_Orc == nNumeroOrc
SELE ITEMNFE
mgREGIME:=1
 
        registro              :=registro+1
        M->CbdvCredICMSSN     := 0
		NTOTAL                :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')
	    M->CbdvCredICMSSN     := ITEMNFE->UNIT_DESC*C_ALIQUOTA/100
        nFrete_Item:=0
	
		 xCFOP:=ITEMNFE->CFOP
	     aadd(DADOS_NFe,{'[Produto'+strzero(registro,3)+']' })
		 aadd(DADOS_NFe,{'CFOP=' +(xCFOP)})
		 aadd(DADOS_NFe,{'Codigo=' +ALLTRIM(ITEMNFE->PRODUTO) })
		 aadd(DADOS_NFe,{'Descricao=' +Alltrim(ITEMNFE->DESCRICAO) })
		 aadd(DADOS_NFe,{'EAN=' })
         aadd(DADOS_NFe,{'NCM=' +LPAD(STR(val(ITEMNFE->ncm)),8,[0])})
		 aadd(DADOS_NFe,{'Unidade=' +ITEMNFE->unid})
		 aadd(DADOS_NFe,{'Quantidade=' +TRANSFORM(ITEMNFE->QTD,"@! 99999999.999") })
		 aadd(DADOS_NFe,{'ValorUnitario='+ALLTRIM(TRANSFORM(ITEMNFE->Valor,"@ 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorTotal=' +ALLTRIM(TRANSFORM(ITEMNFE->SubTotal,"@ 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorDesconto=' +ALLTRIM(TRANSFORM(ITEMNFE->SubTotal*DADOSNFE->DESC1/100,"@ 99999999999999.99999"))  })
		 aadd(DADOS_NFe,{'vFrete='+ALLTRIM(TRANSFORM((nFrete_Item),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'NumeroDI=1' })
	 	 aadd(DADOS_NFe,{'vTotTrib='+ALLTRIM(TRANSFORM(ITEMNFE->V_IBPT  ,"99,999,999.99")) })
	
	
         xCST:=(ITEMNFE->stb)
		 aadd(DADOS_NFe,{'[ICMS'+strzero(registro,3)+']' })
		 aadd(DADOS_NFe,{'CSOSN='+STR(xCST) })
		 aadd(DADOS_NFe,{'pCredSN='+alltrim(NTOTAL)})
		 aadd(DADOS_NFe,{'vCredICMSSN='+ALLTRIM(TRANSFORM(M->CbdvCredICMSSN   ,"99,999,999.99")) })
  
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
 endif
DESCONTO_X:=DESCONTO_X+ITEMNFE->SubTotal*DADOSNFE->DESC1/100

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
        aadd(DADOS_NFe,{'vTotTrib='+ALLTRIM(TRANSFORM((nImpostos_Cupom),"@! 999999999999.99")) })

	
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
	 
   IF nfe.oRad2.VALUE == 1 
	     aadd(DADOS_NFe,{'[Fatura]'})
   	     aadd(DADOS_NFe,{'Numero='+c_CbdNtfNumero})
		 aadd(DADOS_NFe,{'ValorOriginal='+ALLTRIM(TRANSFORM((nTotal_Itens ),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'Valordesconto='+ALLTRIM(TRANSFORM((mValor_Desconto ),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorLiquido='+ALLTRIM(TRANSFORM((nTotal_Itens-mValor_Desconto),"@! 999999999999.99")) })
        Sele boleto
OrdSetFocus('vencimento')
GO Top
do while !boleto->(eof())
tt++
	    aadd(DADOS_NFe,{'[duplicata'+strzero(tt,3)+']' })
        aadd(DADOS_NFe,{'numero='+c_CbdNtfNumero+"/"+strzero(tt,2)})
	    aadd(DADOS_NFe,{'DataVencimento='+dtoc(boleto->vcto)})
        aadd(DADOS_NFe,{'valor='+ALLTRIM(TRANSFORM(( boleto->valor),"@! 999999999999.99")) })
	
 dbskip()
enddo
ENDIF
	
xQTD_VOLUMES:=NFE.tVolumes.VALUE
m->Cbdesp   :=""
xMarca      :="" 
xNUMERO_VOL :=NTRIM(NFE.tVolumes.VALUE)
xPESOBRUTO  :=NFE.tPesoBru.VALUE 
xPESOLIQ    :=NFE.tPesoLiq.VALUE


		 aadd(DADOS_NFe,{'[Volume001]' })
		 aadd(DADOS_NFe,{'Quantidade='+ALLTRIM(TRANSFORM((xQTD_VOLUMES),"@! 9999999999999")) })
		 aadd(DADOS_NFe,{'Especie='+m->Cbdesp })
		 aadd(DADOS_NFe,{'Marca='+xMarca})
		 aadd(DADOS_NFe,{'Numeracao='+xNUMERO_VOL })
		 aadd(DADOS_NFe,{'PesoLiquido='+ALLTRIM(TRANSFORM((xPESOBRUTO),"@! 9999999999.999")) })
		 aadd(DADOS_NFe,{'PesoBruto='+ALLTRIM(TRANSFORM((xPESOLIQ),"@! 9999999999.999")) })
    	 xCbdcProd           := (ITEMNFE->PRODUTO)
	     xCbdnItem           := registro

//	 *MODIFY CONTROL GRAVANDO  OF NFe  Value  'Aguarde Gravando    '+TransForm(xCbdcProd ,"@!")  + TransForm(xCbdnItem ,"999")
//LinhaDeStatus('Aguarde Gravando    '+TransForm(xCbdcProd ,"@!")  + TransForm(xCbdnItem ,"999"))
//ITEMNFE->(dbskip())
//ENDD  



	

 xCbdinfCpl	  	 	  := NFE.Edit_Aplicacao.VALUE //+"    "+ COMPLEMENTO

* xCbdinfCpl	  	 	  := DADOSNFE->OBS +"    "+ COMPLEMENTO
 m->CbdinfCpl:=""
 aadd(DADOS_NFe,{'[DadosAdicionais]' })
 aadd(DADOS_NFe,{'Complemento='+xCbdinfCpl })
 aadd(DADOS_NFe,{'Fisco='+alltrim(substr(m->CbdinfCpl,1,5000))})

 HANDLE :=  FCREATE (path+"\NOTA.TXT",0)// cria o arquivo
	for i=1 to len(DADOS_NFe)
		fwrite(handle,alltrim(DADOS_NFe[i,1]))
        fwrite(handle,chr(13)+chr(10))
	next
fclose(handle)  

public cTXT     :=PATH+"\NOTA.TXT"
public cDestino :=PATH+"\NOTA.TXT"
xcml:=memoread(cDestino) 
abreseq_nfe()
abreNFCE()
abreseq_dav()



*******************************
*INICIA O ENVIO 
*******************************
ProcedureescreverINI()
status_nfe()
*SAIR_nfe()
RETURN


// Fim da fun‡Æo de gerar tela de splash ------------------------------------.
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

public nnfe:="NFE"+NTRIM(NFe.Txt_NOTA.VALUE)
abregra_chave()

///////FIM///////////////

MODIFY CONTROL Servico  OF NFE VALUE   'SITUAÇÃO DO SERVIÇO.:' 
MODIFY CONTROL Servico1  OF NFE VALUE   'AGUARDE..' 

*MODIFY CONTROL Txt_valortotal OF NFE VALUE ""  +TransForm(nTtFactura   , "@R 999,999.99") 

cTXT:=PATH+"\NOTA.TXT"
////////////////////////CRIAR NOTA NFE///////////////////////
NFe_XML(cTXT)
////////////////////////////////////////////////////////////


MODIFY CONTROL gerando_xml OF nfe  VALUE   'GERANDO XML...............:' 

            if (!EOF())
                    If LockReg()  
                       gra_chave->gchave   :=ALLTRIM(cSAIDA_XML)
					   gra_chave->(dbcommit())
                       gra_chave->(dbunlock())
                   Unlock
                  ENDIF                 
               else
                 gra_chave->(dbappend())
                       gra_chave-> gchave  :=ALLTRIM(cSAIDA_XML)
                       gra_chave->(dbcommit())
                       gra_chave->(dbunlock())
                    endif



NFe_SWS()

MODIFY CONTROL gerando_xml1 OF nfe  VALUE   'OK' 


cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
 lRetStatus:=EsperaResposta(cFileDanfe) 
        if lRetStatus==.t.  ////pego os dados
       end
cFileDanfe := 'C:\ACBrNFeMonitor\sainfe.txt'
  
BEGIN INI FILE cFileDanfe
      ////STATUS////////////////////////////
       GET sCStat          SECTION  "STATUS"       ENTRY "CStat" 
	  /////////////////////////////////////////////////////////////
END INI

PUBLIC s_CStat:=val(sCStat)

if s_CStat=107

MODIFY CONTROL Servico1  OF NFE  VALUE   'OK' 

      else 
	//COD_RETORNONFE(sXMotivo)
   	  MsgInfo("Serviço Solicitado não Esta Ativo, ou sem Conecção na Internet")
 return(.f.)
endif

MODIFY CONTROL VALIDANDO_XML  OF NFE  VALUE   'VALIDANDO XML.........:' 
MODIFY CONTROL VALIDANDO_XML1 OF NFE  VALUE   'OK' 

///////////////////////////////////////
///******valida nfe
////////////////////////////////////////
SELE gra_chave 
gra_chave->(dbgotop())
OrdSetFocus('pchave')	
gchave :=alltrim(gra_chave->gchave)
/////////////////////VALIDANDO ARQUIVO
nFe_VAL(alltrim(gchave))

////////////////////////////////////////////////////////////////////////
 ////RETORNO////
	BEGIN INI FILE cFileDanfe
       GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
	 /////////////////////////////////////////////////////////////
END INI

public  RR_CStat   :=R_CStat
public C_XMotivo :=R_XMotivo


if retorno_erro="OK:"
MODIFY CONTROL ASSINADO_XML  OF NFE  VALUE   'ASSINANDO XML.......:' 
MODIFY CONTROL ASSINANDO_XML1 OF NFE  VALUE   'OK' 
*MSGINFO(cSAIDA_XML)
MODIFY CONTROL ASSINADO_XML  OF NFE  VALUE   'ENVIANDO XML.......:' 
NFe_ENV(alltrim(chave_enviar))
else
msginfo(C_XMotivo,"ATENÇÃO")
MsgInfo('Chave não Valida', "ATENÇÃO")
return (.f.)
endif 

MODIFY CONTROL ASSINADO_XML OF NFE  VALUE   'AUTORIZADO XML.......:' 
MODIFY CONTROL ASSINANDO_XML1 OF NFE  VALUE   'OK' 



cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
 lRetStatus:=EsperaResposta(cFileDanfe) 
        if lRetStatus==.t.  ////pego os dados
       end
cFileDanfe := 'C:\ACBrNFeMonitor\sainfe.txt'

BEGIN INI FILE cFileDanfe
      ////STATUS////////////////////////////
       GET sCStat          SECTION  "STATUS"       ENTRY "CStat" 
	   GET sXMotivo        SECTION  "STATUS"       ENTRY "XMotivo"    // MOTIVO 
	  /////////////////////////////////////////////////////////////
END INI




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
MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE  "CHAVE.." + C_XMotivo 
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT

GRAVA_nfe1()


if RCStat="100"
LinhaDeStatus("Aguarde..."  +C_XMotivo)
MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT

ELSE
LinhaDeStatus("Aguarde..."  +RCStat)
MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT

msginfo(R_XMotivo)
return(.f.)
endif

MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE  "CHAVE" + cChNFe
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT



if C_XMotivo="Autorizado o uso da NF-e"
XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+xml
msginfo(C_XMotivo,"ATENÇÃO")
NFe_CON(fxml)


MODIFY CONTROL email_XML OF NFE VALUE  "" + "Imprimindo nfe ..."
NFe_IMP(alltrim(fxml))
ZERA_NFE()

MODIFY CONTROL email_XML OF NFE  VALUE  "" + "Enviando Email nfe ..."
eemail         :=ALLTRIM(nfe.Txt_email.value)
NFe_EMA(eemail,fxml)



VERIFICA_GRAVA_nfe1()
*status_email.release 

ElseIf C_XMotivo="Lote recebido com sucesso"
msginfo(C_XMotivo, "ATENÇÃO")
XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+xml
NFe_CON(fxml)



MODIFY CONTROL email_XML OF NFE  VALUE  "Imprimindo nfe ..."
NFe_IMP(alltrim(fxml))


If !Empty(eemail) 
MODIFY CONTROL email_XML OF NFE  VALUE  "Enviando Email nfe ..."
NFe_EMA(eemail,fxml)
else
endif


Reconectar_A() 

C_CbdNtfNumero:=SUBSTR(cSAIDA_XML, 44, 9)
C_CbdNtfNumero:=val(C_CbdNtfNumero)

XML           :=SUBSTR(cAuxCCe, 20, 55)
fxml          :="C:\ACBrNFeMonitor\"+xml
*msginfo(fxml)
ffxml         :=memoread(cAuxCCe)

   cQuery	:= oServer:Query( "UPDATE nfe20 SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = " +(ntrim(C_CbdNtfNumero)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
endif
SAIR_nfe()
endif


if C_XMotivo="Lote recebido com sucesso"
msginfo(C_XMotivo, "ATENÇÃO") 
XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+xml
NFe_CON(fxml)
MODIFY CONTROL email_XML OF NFE  VALUE    "Imprimindo nfe ..."
NFe_IMP(alltrim(fxml))

VERIFICA_GRAVA_nfe1()

If !Empty(eemail) 
MODIFY CONTROL email_XML  OF NFE VALUE    "Enviando Email nfe ..."
     NFe_EMA(eemail,fxml)
else
endif

Reconectar_A() 

C_CbdNtfNumero:=SUBSTR(cSAIDA_XML, 44, 9)
C_CbdNtfNumero:=val(C_CbdNtfNumero)

XML           :=SUBSTR(cAuxCCe, 20, 55)
fxml          :="C:\ACBrNFeMonitor\"+xml
*msginfo(fxml)
ffxml         :=memoread(cAuxCCe)

   cQuery	:= oServer:Query( "UPDATE nfe20 SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = " +(ntrim(C_CbdNtfNumero)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
endif
endif
SAIR_nfe()
RETURN



STATIC FUNCTION ZERA_NFE()

                     SELE NFCE 
                    If LockReg()  
                       NFCE->NUM_SEQ :=0
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                 Unlock
                 ENDIF   
				
*MSGINFO("OK")
RETURN
	


//------------------------------------------------------------------
STATIC FUNCTION SAIR_nfe
//---------------------------------------------
NFE.RELEASE
SAIR_nfCe()
RETURN 

	


static Function ProcedureescreverINI()
     cDestino := "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
	lRetStatus:=EsperaResposta(cDestino) 
		BEGIN INI FILE cDestino
      SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '1'
    END INI
	MY_WAIT( 3 )    
	ProcedureLerINI()
return
	
	
	  
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
GRAVA_nfe1()



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
XML           :=SUBSTR(cSAIDA_XML, 20, 55)
fxml          :="C:\ACBrNFeMonitor\"+xml
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
static Function GRAVA_nfe1
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
#INCLUDE "TSBROWSE.CH"
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
Local aSituacao	    := {}
local mgCODIGO:=1
local cPedido        := DADOSNFE->num_seq
LOCAL C_CFOP         :=nfe.textBTN_cfop.value
LOCAL C_CODIGO       :=NFE.textBTN_cliente.VALUE
private mCFOP        :='',mCbdnatOp:='',mCbdtpEmis:=1,mCbdfinNFe:=1
private mPEDIDO      :="",aFormaPagamento:=0,nEmail:=''

xxxx:=1

//nfe            :=allTrim(cSAIDA_XML)
*MSGINFO(eemail,nfe)
Reconectar_A() 

C_CbdNtfNumero:=NFe.Txt_NOTA.VALUE

    cQuery:= "DELETE FROM nfeitem WHERE CbdNtfNumero = " +ntrim (C_CbdNtfNumero)         
		 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
	*	  msginfo("ok")
	EndIf
  
  
    cQuery:= "DELETE FROM nfe20 WHERE CbdNtfNumero = " +ntrim (C_CbdNtfNumero)         
		 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
	*	  msginfo("ok")
	EndIf
  
  
  
//////////////////////empresa 
   oQuery := oServer:Query( "Select razaosoc,cidade,end,cep,fone_cont,bairro,estado,insc,cgc,numero,usuario From empresa Order By usuario" )
 If oQuery:NetErr()												
  MsgInfo("Nao Encontrei a Tabela " , "ATENÇÃO")
return (.f.)
Endif

         oRow         := oQuery:GetRow(1)
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

********************************************	
	// gravaçoes  nfe012 
**********************************************	

XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+xml
ffxml:=memoread(fxml)

		///////////////////////////////////////////////////////////////////////////////////////
///--->>>capa da nota
        xCbdEmpCodigo            := (mgCODIGO)
		xCbdNtfNumero         := (C_CbdNtfNumero )
		xCbdNtfSerie  	      := (C_CbdNtfSerie  )
		xCbdUsuImpPadrao      := '' 
		xCbdUsuImpCont        := '' 
		xCbdUsuModDANFE       := "0"  // 2-Para medicamentos 
		xCbdJustificativa     := '' 
		xCbdcUF               := "11"
		DIA=DAY(date())
        MES=MONTH(date())
        m->CbdcNF             := alltrim(str(dia,2,0))+alltrim(str(mes,2,0)) 
	    m->CbdcNF             := m->CbdcNF +SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2) 
		xCbdcNF			      :=(m->CbdcNF) 
		xCbdnatOp 		      := NATU
		xCbdindPag            :="0"
	   	xCbdmod  		      := '55'   ///Utilizar o código 55 para identificação da NF-e, emitida em substituição ao modelo 1 ou 1A
		xCbddEmi  		      := dtos(date())
		xCbddSaiEnt		      := dtos(DATE())    
		xCbdhrSaiEnt		  := time()   
	    xCbdtpNf 		      :="1"
	  	xCbdcMunFg  		  := (codMunEmpresa)
		xCbdtpImp  		      := "1"  // 1-Retrato ,2-Paisagem. 
   		xCbdtpEmis 		      := ntrim(mCbdtpEmis)
		xCbdfinNFe  		  := ntrim(mCbdfinNFe)   ///  1 - NF-e normal / 2 - NF-e complementar / 3 - NF-e de ajuste.
		xCbdvFrete_ttlnfe     :='0'
 		xCbdCNPJ_emit 	  	  := CNPJNFE
		xCbdCPF_emit   	      := ''
   		xCbdxNome 		  	  := nfeEmpresa
   		xCbdxFant 		  	  := nfantasia
   		xCbdxLgr  		  	  := endEmepresa
   		xCbdnro 		  	  := numLogradoro
   		xCbdxCpl 		  	  := ''
   		xCbdxBairro 		  := BairroEmpresa
   		xCbdcMun  		  	  := codMunEmpresa
   		xCbdxMun  		  	  := MunEmpresa
   		xCbdUF  			  := UfEmpresa
		xCbdCEP  		  	  := limpa(cepEmpresa)
   		xCbdcPais 		  	  := '1058'
   		xCbdxPais 		  	  := 'BRASIL'
		xCbdfone  		  	  := LIMPA(FoneEmpresa)
		xCbdFax  		  	  := LIMPA(FoneEmpresa)
   		xCbdEmail  		  	  := "MEDIAL@PS5.COM.BR"
    	xCbdIE 	 	    	  := InscEmpresa
   		xCbdIEST  		  	  := ''
   		xCbdIM  	  	 	  := ''
*       xCbdinfCpl	  	 	  := DADOSNFE->OBS +"    "+ COMPLEMENTO
   		xCbdCNAE   		  	  := ''
		chave                 :=alltrim(cChNFe)
		auto                  :=alltrim(CNPROT)
	 
    	 cQuery := "INSERT INTO  nfe20 (CbdEmpCodigo,CbdNtfNumero,CbdNtfSerie,CbdUsuImpPadrao,CbdUsuImpCont,CbdUsuModDANFE,CbdJustificativa,CbdcUF,	CbdcNF,CbdnatOp ,CbdindPag,Cbdmod,CbddEmi,CbddSaiEnt,CbdhrSaiEnt,CbdtpNf,CbdcMunFg,CbdtpImp,CbdtpEmis,CbdfinNFe ,CbdvFrete_ttlnfe, CbdCNPJ_emit,CbdCPF_emit,CbdxNome,CbdxFant,CbdxLgr,Cbdnro,CbdxCpl,CbdxBairro,CbdcMun,CbdxMun,CbdUF,CbdCEP,CbdcPais,CbdxPais,Cbdfone,CbdFax,CbdEmail,CbdIE,CbdIEST,CbdIM,CbdinfCpl,CbdCNAE,CHAVE,AUTORIZACAO,nt_retorno )  VALUES ('"+xCbdEmpCodigo+"','"+xCbdNtfNumero+"','"+xCbdNtfSerie+"','"+xCbdUsuImpPadrao+"','"+xCbdUsuImpCont+"','"+xCbdUsuModDANFE+"','"+xCbdJustificativa+"','"+xCbdcUF+"','"+xCbdcNF+"','"+xCbdnatOp+"','"+xCbdindPag+"','"+xCbdmod+"','"+xCbddEmi+"','"+xCbddSaiEnt+"','"+xCbdhrSaiEnt+"','"+xCbdtpNf+"','"+xCbdcMunFg+"','"+xCbdtpImp+"','"+xCbdtpEmis+"','"+xCbdfinNFe+"','"+xCbdvFrete_ttlnfe+"','"+xCbdCNPJ_emit+"','"+xCbdCPF_emit+"','"+xCbdxNome+"','"+xCbdxFant+"','"+xCbdxLgr+"','"+xCbdnro+"','"+xCbdxCpl+"','"+xCbdxBairro+"','"+xCbdcMun+"','"+xCbdxMun+"','"+xCbdUF+"','"+xCbdCEP+"','"+xCbdcPais+"','"+xCbdxPais+"','"+xCbdfone+"','"+xCbdFax+"','"+xCbdEmail+"','"+xCbdIE+"','"+xCbdIEST+"','"+xCbdIM+"','"+xCbdinfCpl+"','"+xCbdCNAE+"','"+chave+"','"+AUTO+"','"+(AllTrim(ffxml))+"' )" 
 	   	 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
		 // msginfo("ok")
		EndIf
	
	
	 
	dbselectarea('DADOSNFE')
    ordsetfocus('NUMSEQ')
    DADOSNFE->(dbgotop())
    DADOSNFE->(dbseek(cPedido))
	
////////////////////////////////////////////////////////////////////////////////	 


// gravaçoes  destinatarios

//do while !DADOSNFE->(Eof())	

//If DADOSNFE->num_seq == cPedido
//******************************************************
 IF DADOSNFE->CL_PESSOA='J'     
	ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
 	insc                    :=(DADOSNFE->RGIE)
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := ""
	CCbdxBairro_dest	    :=alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :=(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :=alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :=alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :=(DADOSNFE->cep)
   	CCbdcPais_dest	  	    := '1058'
   	CCbdxPais_dest	  	    := 'BRASIL'
	CCbdfone_dest	  	    := "0"
   	CCbdISUF   		  	    := ""
*MSGINFO(CCbdCEP_dest)

//totis da nfe   
        cCbdvBC_ttlnfe         :=0 //*DADOSNFE->VALOR_TOT
	    cCbdvICMS_ttlnfe       :=0 //*DADOSNFE->VALOR_TOT*17/100
		cCbdvBCST_ttlnfe       := 0
		cCbdvFrete_ttlnfe      := 0
	   *cCbdmodFrete           := 9
		CCbdmodFrete           := 9 //*0- Por conta do emitente 1- Por conta do destinatário/remetente; 2- Por conta de terceiros; 9- Sem frete.
		cCbdvST_ttlnfe         := 0
		cCbdvProd_ttlnfe       := DADOSNFE->VALOR_TOT
		cCbdvSeg_ttlnfe        := 0
		cCbdvDesc_ttlnfe       := DADOSNFE->DESCONTO
		CbdvDesc_cob           := ntrim(DADOSNFE->DESC1)
		cCbdvII_ttlnfe         := 0
		cCbdvIPI_ttlnfe        := 0
		cCbdvPIS_ttlnfe        := 0
		cCbdvCOFINS_ttlnfe     := 0
		cCbdvOutro             := 0
		cCbdvNF                := DADOSNFE->TOTAL_VEN
		cCbdEmailArquivos      :=0 
        cCbdTitGenerico        :="" 
        cCbdTxtGenerico        :="" 
		ccbdcrt                :=1  //1=SIMPLES NACIONAL 2 SIMPLES EXCESSO SUBLIMITE 3 =REGIME NORMAL 		

    oQuery	:= oServer:Query( "UPDATE nfe20 SET CbdvDesc_cob='"+CbdvDesc_cob+"', cbdcrt='"+alltrim(str(ccbdcrt))+"',CbdCnpj_dest  = '"+ClienteTxtCGC+"' , CbdIE_dest = '"+Insc+"',CbdxNome_dest = '"+cCbdxNome_dest+"' , CbdxLgr_dest ='"+cCbdxLgr_dest+"',Cbdnro_dest='"+CCbdnro_dest+"',CbdxBairro_dest='"+CCbdxBairro_dest+"' ,CbdxEmail_dest = '"+CCbdxEmail_dest+"',CbdxCpl_dest='"+CCbdxCpl_dest+"',CbdcMun_dest='"+(CCbdcMun_dest)+"',CbdxMun_dest='"+CCbdxMun_dest+"' ,CbdUF_dest='"+cCbdUF_dest+"',CbdCEP_dest='"+CCbdCEP_dest+"',CbdcPais_dest='"+cCbdcPais_dest+"',CbdxPais_dest='"+CCbdxPais_dest+"' ,Cbdfone_dest='"+CCbdfone_dest+"',CbdISUF='"+CCbdISUF+"',CbdvBC_ttlnfe='"+alltrim(str(cCbdvBC_ttlnfe))+"',CbdvICMS_ttlnfe='"+alltrim(str(cCbdvICMS_ttlnfe))+"',CbdvBCST_ttlnfe='"+alltrim(str(cCbdvBCST_ttlnfe))+"',CbdvFrete_ttlnfe='"+alltrim(str(cCbdvFrete_ttlnfe))+"',CbdmodFrete ='"+alltrim(str(cCbdmodFrete))+"',CbdvST_ttlnfe='"+alltrim(str(cCbdvST_ttlnfe))+"',CbdvProd_ttlnfe='"+alltrim(str(cCbdvProd_ttlnfe))+"',CbdvSeg_ttlnfe ='"+alltrim(str(cCbdvSeg_ttlnfe ))+"',CbdvDesc_ttlnfe='"+alltrim(str(cCbdvDesc_ttlnfe))+"',CbdvII_ttlnfe='"+alltrim(str(cCbdvII_ttlnfe))+"',CbdvIPI_ttlnfe='"+alltrim(str(cCbdvIPI_ttlnfe))+"',CbdvPIS_ttlnfe='"+alltrim(str(cCbdvPIS_ttlnfe))+"',CbdvCOFINS_ttlnfe='"+alltrim(str(cCbdvCOFINS_ttlnfe))+"',CbdvOutro='"+alltrim(str(cCbdvOutro))+"',CbdvNF='"+alltrim(str(cCbdvNF))+"',CbdEmailArquivos='"+alltrim(str(cCbdEmailArquivos))+"',CbdTitGenerico='"+alltrim((cCbdTitGenerico))+"',CbdTxtGenerico='"+alltrim(cCbdTxtGenerico)+"'  WHERE CbdNtfNumero = " +(C_CbdNtfNumero) )
 	If oQuery:NetErr()		
         MsgInfo("11111111111 " + oQuery:Error())	
     	MsgStop(oQuery:Error())
	 Else
 	//MsgStop("ok")
EndIf
ENDIF
//*******************************************************
  IF DADOSNFE->CL_PESSOA='P'     
	ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
 	insc                    :=(DADOSNFE->RGIE)
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := ""
	CCbdxBairro_dest	    :=alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :=alltrim(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :=alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :=alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :=limpa(DADOSNFE->cep)
   	CCbdcPais_dest	  	    := '1058'
   	CCbdxPais_dest	  	    := 'BRASIL'
	CCbdfone_dest	  	    := "0"
   	CCbdISUF   		  	    := ""

//totis da nfe   
        cCbdvBC_ttlnfe         :=0 //*DADOSNFE->VALOR_TOT
	    cCbdvICMS_ttlnfe       :=0 //*DADOSNFE->VALOR_TOT*17/100
		cCbdvBCST_ttlnfe       := 0
		cCbdvFrete_ttlnfe      := 0
	   *cCbdmodFrete           := 9
		CCbdmodFrete           := 9 //*0- Por conta do emitente 1- Por conta do destinatário/remetente; 2- Por conta de terceiros; 9- Sem frete.
		cCbdvST_ttlnfe         := 0
		cCbdvProd_ttlnfe       := DADOSNFE->VALOR_TOT
		cCbdvSeg_ttlnfe        := 0
		cCbdvDesc_ttlnfe       := DADOSNFE->DESCONTO
	    CbdvDesc_cob           := ntrim(DADOSNFE->DESC1)
		cCbdvII_ttlnfe         := 0
		cCbdvIPI_ttlnfe        := 0
		cCbdvPIS_ttlnfe        := 0
		cCbdvCOFINS_ttlnfe     := 0
		cCbdvOutro             := 0
		cCbdvNF                := DADOSNFE->TOTAL_VEN
		cCbdEmailArquivos      :=0 
        cCbdTitGenerico        :="" 
        cCbdTxtGenerico        :="" 
		ccbdcrt                :=1  //1=SIMPLES NACIONAL 2 SIMPLES EXCESSO SUBLIMITE 3 =REGIME NORMAL 		
	
    oQuery	:= oServer:Query( "UPDATE nfe20 SET CbdvDesc_cob='"+CbdvDesc_cob+"', cbdcrt='"+alltrim(str(ccbdcrt))+"',CbdCPF_dest  = '"+ClienteTxtCGC+"' , CbdIE_dest = '"+Insc+"',CbdxNome_dest = '"+cCbdxNome_dest+"' , CbdxLgr_dest ='"+cCbdxLgr_dest+"',Cbdnro_dest='"+CCbdnro_dest+"',CbdxBairro_dest='"+CCbdxBairro_dest+"' ,CbdxEmail_dest = '"+CCbdxEmail_dest+"',CbdxCpl_dest='"+CCbdxCpl_dest+"',CbdcMun_dest='"+CCbdcMun_dest+"',CbdxMun_dest='"+CCbdxMun_dest+"' ,CbdUF_dest='"+cCbdUF_dest+"',CbdCEP_dest='"+CCbdCEP_dest+"',CbdcPais_dest='"+cCbdcPais_dest+"',CbdxPais_dest='"+CCbdxPais_dest+"' ,Cbdfone_dest='"+CCbdfone_dest+"',CbdISUF='"+CCbdISUF+"',CbdvBC_ttlnfe='"+alltrim(str(cCbdvBC_ttlnfe))+"',CbdvICMS_ttlnfe='"+alltrim(str(cCbdvICMS_ttlnfe))+"',CbdvBCST_ttlnfe='"+alltrim(str(cCbdvBCST_ttlnfe))+"',CbdvFrete_ttlnfe='"+alltrim(str(cCbdvFrete_ttlnfe))+"',CbdmodFrete ='"+alltrim(str(cCbdmodFrete))+"',CbdvST_ttlnfe='"+alltrim(str(cCbdvST_ttlnfe))+"',CbdvProd_ttlnfe='"+alltrim(str(cCbdvProd_ttlnfe))+"',CbdvSeg_ttlnfe ='"+alltrim(str(cCbdvSeg_ttlnfe ))+"',CbdvDesc_ttlnfe='"+alltrim(str(cCbdvDesc_ttlnfe))+"',CbdvII_ttlnfe='"+alltrim(str(cCbdvII_ttlnfe))+"',CbdvIPI_ttlnfe='"+alltrim(str(cCbdvIPI_ttlnfe))+"',CbdvPIS_ttlnfe='"+alltrim(str(cCbdvPIS_ttlnfe))+"',CbdvCOFINS_ttlnfe='"+alltrim(str(cCbdvCOFINS_ttlnfe))+"',CbdvOutro='"+alltrim(str(cCbdvOutro))+"',CbdvNF='"+alltrim(str(cCbdvNF))+"',CbdEmailArquivos='"+alltrim(str(cCbdEmailArquivos))+"',CbdTitGenerico='"+alltrim((cCbdTitGenerico))+"',CbdTxtGenerico='"+alltrim(cCbdTxtGenerico)+"'  WHERE CbdNtfNumero = " +(C_CbdNtfNumero) )
 	If oQuery:NetErr()												
     	MsgStop(oQuery:Error())
		   MsgInfo("SQL SELECT error: 2524  " + oQuery:Error())	
    	 Else
 	//MsgStop("ok")
	EndIf

ENDIF
*SUBSTR(Form_PDV.txdescri.value,1,30)
//***************************************************
  IF DADOSNFE->CL_PESSOA='I'     
	ClienteTxtCGC:=(DADOSNFE->CL_CGC)
	Insc                    :="isento"
	ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := ""
	CCbdxBairro_dest	    :=alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :=alltrim(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :=alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :=alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :=limpa(DADOSNFE->cep)
   	CCbdcPais_dest	  	    := '1058'
   	CCbdxPais_dest	  	    := 'BRASIL'
	CCbdfone_dest	  	    := "0"
   	CCbdISUF   		  	    := ""
//totis da nfe   
        cCbdvBC_ttlnfe         :=0 //*DADOSNFE->VALOR_TOT
	    cCbdvICMS_ttlnfe       :=0 //*DADOSNFE->VALOR_TOT*17/100
		cCbdvBCST_ttlnfe       := 0
		cCbdvFrete_ttlnfe      := 0
	*	cCbdmodFrete           := 1
		CCbdmodFrete           := 9 //*0- Por conta do emitente 1- Por conta do destinatário/remetente; 2- Por conta de terceiros; 9- Sem frete.
		cCbdvST_ttlnfe         := 0
		cCbdvProd_ttlnfe       := DADOSNFE->VALOR_TOT
		cCbdvSeg_ttlnfe        := 0
		cCbdvDesc_ttlnfe       := DADOSNFE->DESCONTO
		CbdvDesc_cob           := ntrim(DADOSNFE->DESC1)
		cCbdvII_ttlnfe         := 0
		cCbdvIPI_ttlnfe        := 0
		cCbdvPIS_ttlnfe        := 0
		cCbdvCOFINS_ttlnfe     := 0
		cCbdvOutro             := 0
		cCbdvNF                := DADOSNFE->TOTAL_VEN
		cCbdEmailArquivos      :=0 
        cCbdTitGenerico        :="" 
        cCbdTxtGenerico        :="" 
		ccbdcrt                :=1  //1=SIMPLES NACIONAL 2 SIMPLES EXCESSO SUBLIMITE 3 =REGIME NORMAL 		
	
    oQuery	:= oServer:Query( "UPDATE nfe20 SET CbdvDesc_cob='"+CbdvDesc_cob+"',cbdcrt='"+alltrim(str(ccbdcrt))+"',CbdCnpj_dest  = '"+ClienteTxtCGC+"' , CbdIE_dest = '"+Insc+"',CbdxNome_dest = '"+cCbdxNome_dest+"' , CbdxLgr_dest ='"+cCbdxLgr_dest+"',Cbdnro_dest='"+CCbdnro_dest+"',CbdxBairro_dest='"+CCbdxBairro_dest+"' ,CbdxEmail_dest = '"+CCbdxEmail_dest+"',CbdxCpl_dest='"+CCbdxCpl_dest+"',CbdcMun_dest='"+CCbdcMun_dest+"',CbdxMun_dest='"+CCbdxMun_dest+"' ,CbdUF_dest='"+cCbdUF_dest+"',CbdCEP_dest='"+CCbdCEP_dest+"',CbdcPais_dest='"+cCbdcPais_dest+"',CbdxPais_dest='"+CCbdxPais_dest+"' ,Cbdfone_dest='"+CCbdfone_dest+"',CbdISUF='"+CCbdISUF+"',CbdvBC_ttlnfe='"+alltrim(str(cCbdvBC_ttlnfe))+"',CbdvICMS_ttlnfe='"+alltrim(str(cCbdvICMS_ttlnfe))+"',CbdvBCST_ttlnfe='"+alltrim(str(cCbdvBCST_ttlnfe))+"',CbdvFrete_ttlnfe='"+alltrim(str(cCbdvFrete_ttlnfe))+"',CbdmodFrete ='"+alltrim(str(cCbdmodFrete))+"',CbdvST_ttlnfe='"+alltrim(str(cCbdvST_ttlnfe))+"',CbdvProd_ttlnfe='"+alltrim(str(cCbdvProd_ttlnfe))+"',CbdvSeg_ttlnfe ='"+alltrim(str(cCbdvSeg_ttlnfe ))+"',CbdvDesc_ttlnfe='"+alltrim(str(cCbdvDesc_ttlnfe))+"',CbdvII_ttlnfe='"+alltrim(str(cCbdvII_ttlnfe))+"',CbdvIPI_ttlnfe='"+alltrim(str(cCbdvIPI_ttlnfe))+"',CbdvPIS_ttlnfe='"+alltrim(str(cCbdvPIS_ttlnfe))+"',CbdvCOFINS_ttlnfe='"+alltrim(str(cCbdvCOFINS_ttlnfe))+"',CbdvOutro='"+alltrim(str(cCbdvOutro))+"',CbdvNF='"+alltrim(str(cCbdvNF))+"',CbdEmailArquivos='"+alltrim(str(cCbdEmailArquivos))+"',CbdTitGenerico='"+alltrim((cCbdTitGenerico))+"',CbdTxtGenerico='"+alltrim(cCbdTxtGenerico)+"'  WHERE CbdNtfNumero = " +(C_CbdNtfNumero) )
 	If oQuery:NetErr()												
     	MsgStop(oQuery:Error())
		   MsgInfo("SQL SELECT error: 3346  " + oQuery:Error())	
	 Else
*	 	MsgStop("ok")
	EndIf
ENDIF
//***************************************************
  IF DADOSNFE->CL_PESSOA='F'     
	ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
	Insc                    :="isento"
	ClienteTxtCGC           :=SUBSTR(DADOSNFE->CL_CGC,1,11)
    *ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := ""
	CCbdxBairro_dest	    :=alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :=alltrim(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :=alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :=alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :=alltrim(DADOSNFE->cep)
   	CCbdcPais_dest	  	    := '1058'
   	CCbdxPais_dest	  	    := 'BRASIL'
	CCbdfone_dest	  	    := "0"
   	CCbdISUF   		  	    := ""
//totis da nfe   
        cCbdvBC_ttlnfe         :=0 //*DADOSNFE->VALOR_TOT
	    cCbdvICMS_ttlnfe       :=0 //*DADOSNFE->VALOR_TOT*17/100
		cCbdvBCST_ttlnfe       := 0
		cCbdvFrete_ttlnfe      := 0
	*	cCbdmodFrete           := 1
		CCbdmodFrete           := 9 //*0- Por conta do emitente 1- Por conta do destinatário/remetente; 2- Por conta de terceiros; 9- Sem frete.
		cCbdvST_ttlnfe         := 0
		cCbdvProd_ttlnfe       := DADOSNFE->VALOR_TOT
		cCbdvSeg_ttlnfe        := 0
		cCbdvDesc_ttlnfe       := DADOSNFE->DESCONTO
		CbdvDesc_cob           := ntrim(DADOSNFE->DESC1)
		cCbdvII_ttlnfe         := 0
		cCbdvIPI_ttlnfe        := 0
		cCbdvPIS_ttlnfe        := 0
		cCbdvCOFINS_ttlnfe     := 0
		cCbdvOutro              := 0
	 *  cCbdvNF                := DADOSNFE->TOTAL_VEN
		cCbdvNF                := DADOSNFE->TOTAL_VEN
		cCbdEmailArquivos      :=0 
        cCbdTitGenerico        :="" 
        cCbdTxtGenerico        :=""
		ccbdcrt                :=1  //1=SIMPLES NACIONAL 2 SIMPLES EXCESSO SUBLIMITE 3 =REGIME NORMAL 		
	//MSGINFO(xcml)	
    oQuery	:= oServer:Query( "UPDATE nfe20 SET CbdvDesc_cob='"+CbdvDesc_cob+"',cbdcrt='"+alltrim(str(ccbdcrt))+"', CbdCPF_dest  = '"+ClienteTxtCGC+"' , CbdIE_dest = '"+Insc+"',CbdxNome_dest = '"+cCbdxNome_dest+"' , CbdxLgr_dest ='"+cCbdxLgr_dest+"',Cbdnro_dest='"+CCbdnro_dest+"',CbdxBairro_dest='"+CCbdxBairro_dest+"' ,CbdxEmail_dest = '"+CCbdxEmail_dest+"',CbdxCpl_dest='"+CCbdxCpl_dest+"',CbdcMun_dest='"+CCbdcMun_dest+"',CbdxMun_dest='"+CCbdxMun_dest+"' ,CbdUF_dest='"+cCbdUF_dest+"',CbdCEP_dest='"+CCbdCEP_dest+"',CbdcPais_dest='"+cCbdcPais_dest+"',CbdxPais_dest='"+CCbdxPais_dest+"' ,Cbdfone_dest='"+CCbdfone_dest+"',CbdISUF='"+CCbdISUF+"',CbdvBC_ttlnfe='"+alltrim(str(cCbdvBC_ttlnfe))+"',CbdvICMS_ttlnfe='"+alltrim(str(cCbdvICMS_ttlnfe))+"',CbdvBCST_ttlnfe='"+alltrim(str(cCbdvBCST_ttlnfe))+"',CbdvFrete_ttlnfe='"+alltrim(str(cCbdvFrete_ttlnfe))+"',CbdmodFrete ='"+alltrim(str(cCbdmodFrete))+"',CbdvST_ttlnfe='"+alltrim(str(cCbdvST_ttlnfe))+"',CbdvProd_ttlnfe='"+alltrim(str(cCbdvProd_ttlnfe))+"',CbdvSeg_ttlnfe ='"+alltrim(str(cCbdvSeg_ttlnfe ))+"',CbdvDesc_ttlnfe='"+alltrim(str(cCbdvDesc_ttlnfe))+"',CbdvII_ttlnfe='"+alltrim(str(cCbdvII_ttlnfe))+"',CbdvIPI_ttlnfe='"+alltrim(str(cCbdvIPI_ttlnfe))+"',CbdvPIS_ttlnfe='"+alltrim(str(cCbdvPIS_ttlnfe))+"',CbdvCOFINS_ttlnfe='"+alltrim(str(cCbdvCOFINS_ttlnfe))+"',CbdvOutro='"+alltrim(str(cCbdvOutro))+"',CbdvNF='"+alltrim(str(cCbdvNF))+"',CbdEmailArquivos='"+alltrim(str(cCbdEmailArquivos))+"',CbdTitGenerico='"+alltrim((cCbdTitGenerico))+"',CbdTxtGenerico='"+alltrim(cCbdTxtGenerico)+"'  WHERE CbdNtfNumero = " +(C_CbdNtfNumero) )
 	If oQuery:NetErr()												
     	MsgStop(oQuery:Error())
      MsgInfo("SQL SELECT error: 3396  " + oQuery:Error())
		  
    
	 Else
	//	MsgStop("ok")
	EndIf
ENDIF

cPedido        := DADOSNFE->num_seq
registro:=0
nNumeroOrc := cPedido
 
sele ITEMNFE
OrdSetFocus('DESCRICAO')
GO Top
ITEMNFE->(dbskip(-1))

do while !ITEMNFE->(eof())
If  ITEMNFE->NSeq_Orc == nNumeroOrc
SELE ITEMNFE
registro:=registro+1
     xCbdEmpCodigo       := val(mgCODIGO)
  	 xCbdNtfNumero      := val(C_CbdNtfNumero) 
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
	 xCbdvDesc		    := ITEMNFE->Valor_DESC
     xCbdvAliq      	:=NTRIM(ITEMNFE->icms)
	 xcbdcsittrib		:=NTRIM(ITEMNFE->STB) 
   	 xcbdindtot         := 1
      cQuery :="INSERT INTO nfeitem (CbdcEAN,cbdcsittrib,CbdvAliq,CbdEmpCodigo, CbdNtfNumero,CbdNtfSerie, CbdnItem ,CbdcProd ,CbdxProd,CbdNCM ,CbdEXTIPI,Cbdgenero, CbdCFOP, CbduCOM,CbdqCOM,CbdvUnCom ,CbdvProd,CbduTrib,CbdqTrib,CbdvUnTrib,CbdnTipoItem, CbdvDesc, cbdindtot ) VALUES ('"+xCbdcEAN+"', '"+Xcbdcsittrib+"','"+XCbdvAliq+"' ,'"+alltrim(str(xCbdEmpCodigo ))+"' , '"+alltrim(str(xCbdNtfNumero))+ "', '"+alltrim(str(xCbdNtfSerie))+ "', '"+alltrim(str(xCbdnItem))+ "', '"+alltrim((xCbdcProd))+ "', '"+alltrim(xCbdxProd)+"','"+xCbdNCM+"','"+xCbdEXTIPI+"','"+alltrim(str(xCbdgenero))+"','"+alltrim(str(xCbdCFOP))+"','"+ xCbduCOM+"','"+alltrim(str(xCbdqCOM))+"','"+alltrim(str(xCbdvUnCom))+"','"+alltrim(str(xCbdvProd))+"','"+alltrim(xCbduTrib)+"','"+alltrim(str(xCbdqTrib))+"','"+alltrim(str(xCbdvUnTrib))+"','"+alltrim(str(xCbdnTipoItem))+"','"+alltrim(str( xCbdvDesc))+"','"+alltrim(str(xcbdindtot))+"' ) "
		oQuery	:= oServer:Query( cQuery )
	If oQuery:NetErr()												
      	MsgStop(cQuery:Error())
	   MsgInfo("SQL SELECT error: 3439  " + cQuery:Error())	
	  Else
	**  msginfo("ok nfeitem")
EndIf
endif


//---------------------- baixar do estoque
////////////////////////////////////////////////////////////////
    oQuery         :=oServer:Query( "Select CODIGO,PRODUTO,UNIT,ST,NCM,CST,QTD,DOLLAR,sit_trib,ICMS,CODBAR,MD5,und From produtos WHERE codbar = " + AllTrim(xCbdcEAN))
   If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
 
   oRow	          :=oQuery:GetRow(1)
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
 
TOTAL_QTD         :=aqtd-xCbdqCOM
xcncm             :=VAL(cncm)
IF Xcncm=0
cncm:="49001000"
ELSE
cncm             :=cncm  
ENDIF


cQuery := "UPDATE PRODUTOS SET NCM ='"+CNCM+"',qtd ='"+NTRIM(TOTAL_QTD)+"' WHERE CODBAR = " + AllTrim(xCbdcEAN)
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  Return Nil
  else
*msginfo("ok")
Endif
  
////////////////////////////////////////////////////////////////////////


ITEMNFE->(dbskip())
ENDD  
RETURN


      
/////////////////////////////////////////////////
static FUNCTION boleto_salvap()
/////////////////////////////////////////////////
LOCAL cCInstr:=""

	inst01t:= "ATENÇÃO PROTESTAR COM 5 DIAS DE VENCIDO";	        

	         IF nfe.oRad2.VALUE == 2 
				    MsgINFO ( 'Por Favor Defina a condição de pagamento como aprazo')
					return(.f.)
			endif
				   
	
SELE BOLETO			
nValMora := ROUND((nfe.Txt_valortotal.value)  * 10/ 100, 2)/30
cCInstr += " MORA DE R$ " + (Transform(nValMora, "@EB 999,999.99")) + " POR DIA DE ATRAZO"

SELE BOLETO
Go bott
*if BOLETO->parc<=0
IF EMPTY(BOLETO->parc)
XXX=1
ELSE
XXX= XXX+1
ENDIF

 IF EMPTY(NFE.textBTN_cliente.VALUE)
          msgexclamation('Não ha nota fiscal lançada verifique','Atenção')
        Return( .F. )
 endif
 

             		   boleto->(dbappend())
	   	               boleto->banco          :=756
		               boleto->vcto           :=nfe.vencimentot.value
                       boleto->data           :=date()
                       boleto->dtproc         :=DATE()
                       boleto->agencia        :=3325
                       boleto->cod_cedent     :=4260
                       boleto->DOCTO          :=nfe.txt_documento.value +"/"+STRZERO(XXX,3)
					   boleto->CONTROLE       :=nfe.txt_documento.value +"/"+STRZERO(XXX,3)
					   boleto->especie        :=nfe.txt_especie.value 
					   boleto->valor          :=nfe.txt_VALOR.value
                       boleto->inst01         :="ATENÇÃO PROTESTAR COM 5 DIAS DE VENCIDO"
                 	   boleto->inst02         :=CcInstr
				       boleto->inst03         :="ATENÇÃO NÃO RECEBER VALOR A MENOR"
                       boleto->inst04         :="" 
                       boleto->inst05         :=""
					   BOLETO->CLINUMERO      :=nfe.Txt_NUMCLI.value
		               boleto->nome_BANCO     :="SICOOB"
                       boleto->m_cedente      :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       boleto->m_sacado       :=nfe.T_NOMECLI.value
                       boleto->endereco       :=nfe.Txt_ENDCLI.value
                       boleto->cep            :=nfe.Txt_CEPCLI.value
                       boleto->bairro         :=nfe.Txt_BAIRROCLI.value
                       boleto->cidade         :=nfe.Txt_CIDCLI.value
                       boleto->estado         :=nfe.Txt_UFCLI.value
					   boleto->numero         :=nfe.txt_nossonumero.value
					   boleto->CNPJ           :="84712611000152"
					   boleto->cgc            :=nfe.Txt_CNPJ.value
					   boleto->PARC           :=STRZERO(XXX,3)
					   boleto->TIPO           :=nfe.Txt_TIPO.value  
                       boleto->(dbunlock())
                       boleto->(DBCOMMIT())
				//refresh_boleto()
				
				
	MESN := strzero(month(date() ), 2 )
IF MESN="01"
   	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="02"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="03"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="03"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="04"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="05"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="06"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="07"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="08"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="09"
  	   cNumero :=MESN+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="10"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="11"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="11"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ELSEIF MESN="12"
	   cNumero :="3"+substr(alltrim(str(HB_RANDOM(999999))),1,5)
       cNumero        := (cNumero)
ENDIF
nfe.txt_nossonumero.value :=CNumero		
//nfe.txt_documento.value   :="NFE"+NTRIM(NFe.Txt_NOTA.VALUE)+"/"+STRZERO(XXX,3)
				
RETURN 

 

static function Refresh_boleto()
Static lGridFreeze := .t.
if lGridFreeze
	nfe.GridTitulos.DisableUpdate // disable GRID update
endif

delete item all from GridTitulos of NFE
        dbselectarea('boleto')
        boleto->(dbgotop())
         while .not. eof()
//HEADERS {"Banco","Agencia","Cedente","Documento","Especie","Aceite","Nosso numero","Vencimento","Valor"  };
ADD ITEM {str(boleto->banco,5),str(boleto->agencia,6),str(boleto->cod_cedent,6),boleto->DOCTO,"DM","S",transform(boleto->numero , '99999999'),dtoc(boleto->vcto),transform(boleto->valor , '999,999.99')}TO GridTitulos OF NFe
 dbskip()
end
if lGridFreeze
nfe.GridTitulos.EnableUpdate // enable GRID update
//Form_PDV.Text_fdcx.value := 1 
//Form_PDV.Text_quant.value:=0
//Form_PDV.valor_unit.VALUE:=0

endif
return

  
   
   
   
   
		
static function Mostraboleto()
   cNumero := substr(alltrim(str(HB_RANDOM(123456,999999))),1,6)
   cNumero        := val(cNumero)			
valornfe:=1000

ADD ITEM {"756","3325","4260","nfe","DM","S",transform(boleto->numero , '99999999'),dtoc(boleto->vcto),transform(boleto->valor , '999,999.99')}TO GridTitulos OF NFe

//ADD ITEM {"756","3325","4260","nfe","DM","S",transform(boleto->valor , '999,999.99'),transform(boleto->valor , '999,999.99'),transform(boleto->valor , '999,999.99')}TO GridTitulos OF NFe

RETURN
		
		
//------------------------------------------------------
static Function PegaDados(cProc,cLinha,lItem,cTexto2)
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


*******************************
static FUNCTION PEGRETNFE( lMOSTRA )
*"C:\ACBrNFeMonitor\SAINFE.TXT"

// lMOSTRA - .T. - MOSTRA RETORNO  .F.-NAO MOSTRA
WHILE( .T. )
   cSAINFE := FOPEN( "C:\ACBrNFeMonitor\SAINFE.TXT" )
   IF FERROR()=0
      EXIT
   ENDIF
                 // TEMPORIZADOR - AGUARDA 2 SEGUNDOS ANTES DE CONTINUAR
 *  TMP(2)
ENDDO
// PEGA CONTEUDO DO ARQUIVO DE RETORNO ATÉ 1000 CARACTERES
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
       // Este arquivo que contém o estado de execução do comando 
       // enviado. 
       if file( "C:\ACBrNFeMonitor\SAINFE.TXT" ) //.and. freadstr( cDirDoMonitor+"\Status.txt" ) <> "0" 
          cECFLOG := memoread("C:\ACBrNFeMonitor\SAINFE.TXT"  ) 
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
 
 
static function VerifyINI( _section_, _entry_, _var_, _inifile_, _grava_ ) 
  //  oIni := TIni():New( _inifile_ ) 
    if _grava_ = .t. 
       oIni:Set( _section_, _entry_, _var_ ) 
    endif 
  return oIni:Get( _section_, _entry_, _var_, _var_ ) 

  
  
  
*****************************************************************************
STATIC Function DUPL_1()
*****************************************************************************
#include "winprint.ch"
#include "minigui.ch"
LOCAL aEstados := { 'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO' }
abreboleto()


COD_BANCO       :=boleto->banco                  //banco    numero banco N3
dv_bamco        :=boleto->dv_banco               //banco    digito nbanco C1
Nome_banco      :=ALLTRIM(boleto->nome_banco)    //banco    nome banco C15
agencia         :=boleto->agencia                //banco    agencia N4
Dv_Agencia      :=boleto->dv_agencia             //banco    digito agencia C1
Cod_cedente     :=boleto->cod_cedent             //banco    conta N8
Dv_cedente      :=boleto->dv_cedent             //banco    digito conta C1
Moeda           :="9" //tipo da moeda 9= R$
Modalidade      :=02 //modalidade
mNMCD           :=ALLTRIM(boleto->m_cedente)     //  Cedente  C50
mCGCD           :=ALLTRIM(boleto->cgc)          //  cnpj do cedente   C18
mDTDC           :=boleto->data                   //  data do documento   D 
Num_doc         :=boleto->docto                  //  numero do docto NF N6
especie         :=boleto->especie                //  especie/tipo  do docto C2
mACDC           :='N'                            //  aceite  C1
mDTPC           :=boleto->dtproc                 //  data do processamento   D
nosso_numero    :=boleto->numero                 //  nosso numero N8
Carteira        :=1                              //  carteira cobranca N3
Quantidade      :=1                              //  quantidade  N3
mVRMD           :=1                              //  valor da moeda  N9,2
Valor           :=boleto->valor                  //  valor N12,2
//aLnit:=                             //  Instrucoess     Array(7)(70)
Vencimento     :=boleto->vcto                   //  Data vcto D

Sacado         :=boleto->m_sacado               //  Sacado   C50
Endereco       :=boleto->endereco               //  endereco sacado C50
Bairro         :=ALLTRIM(boleto->bairro)        //  bairro sacado C20
Cidade         :=ALLTRIM(boleto->cidade)        //  Cidade do Sacado   C20 
uf             :=boleto->estado                 //  estado do Sacado   C2
Cep            :=boleto->cep                    //  CEP sacado  C9
Cnpj           :=boleto->cgc                    //  CPF / CNPJ sacado C18
parcela        :="001"

cNumeNota := Num_doc
nValoNota := Valor 
nNumeParc := 1
dDataEmis :=date()
dDataVenc := Vencimento
cCodiClie :=Sacado 
cCnpjClie := mCGCD
cIEstClie := ""
cEndeClie := Endereco
cBairClie := Bairro
cCepClien :=cep
cCidaClie :=Cidade
cEstaClie := uf
aExtenso := Extenso( nValoNota, 115, 03 )


cRegiFant:="CASA DAS EMBALAGENS"
cRegiCnpj:="84.710.611/0001-52" 
cRegiIEst:="0000000050410-2"
cRegiNome:="MEDIAL COM. DISTRIBUIDOR LTDA"
cRegiCida:="VILHENA"
cRegiEnde:="AV CAPITÃO CASTRO"
cRegiNume:="3294"
cRegiBair:="CENTRO"
cRegiFone:="69 3321 4575"
cRegiCEP :="76980-000"
cemail   :="medial@ps5.com.br"
cskype   :="jose.juca3044" 
pagina  := 001
p_linha := 037
u_linha := 260
linha   := p_linha
INIT PRINTSYS
*SELECT BY DIALOG
SELECT BY DIALOG PREVIEW
SET PAPERSIZE DMPAPER_A4 
SET UNITS ROWCOL
SET THUMBNAILS off 
SET ORIENTATION PORTRAIT
SET UNITS ROWCOL
         SET THUMBNAILS off 
		 SET PREVIEW SCALE 3
         SET PAPERSIZE DMPAPER_A4
         SET ORIENTATION PORTRAIT
         SET BIN DMBIN_FIRST
       * SET QUALITY DMRES_HIGH
         SET COLORMODE DMCOLOR_COLOR





	 
DEFINE FONT "F0" NAME  'Times New Roman'SIZE 22.00
DEFINE FONT "F1" NAME "Arial" SIZE 13 BOLD
DEFINE FONT "F2" NAME "Arial" SIZE 10
DEFINE FONT "F3" NAME "Arial" SIZE 06
DEFINE FONT "F4" NAME "Arial" SIZE 05
DEFINE FONT "F5" NAME "Arial" SIZE 07 WIDTH 2 ANGLE 270
DEFINE FONT "F6" NAME "Arial" SIZE 08 BOLD
DEFINE FONT "F7" NAME "Arial" SIZE 08 BOLD

FOR nLoop1 := 1 TO 1

START PAGE
nLinha := 1
@ nLinha,000,nLinha+18,098 RECTANGLE
nLinha += 1
@ nLinha,000,nLinha+6,095 RECTANGLE
@ nLinha,080,nLinha+6,095 RECTANGLE
@ nLinha,033,nLinha+6,055 RECTANGLE
@ nLinha,070,nLinha+6,098 RECTANGLE


nLinha += 1
@ nLinha,000 SAY cRegiFant FONT "F7" TO PRINT
@ nLinha,034 SAY "CNPJ: " + cRegiCnpj FONT "F3" TO PRINT

nLinha += 1
@ nLinha,034 SAY "Inscr. Estadual: " + cRegiIEst FONT "F3" TO PRINT

nLinha += 1
@ nLinha,000 SAY cRegiNome FONT "F7" TO PRINT
@ nLinha,034 SAY "Municipio de " + cRegiCida FONT "F3" TO PRINT
@ nLinha,056 SAY "DATA DE EMISSÃO: " FONT "F4" TO PRINT
@ nLinha,075 SAY "DUPLICATA" FONT "F1" TO PRINT
nLinha += 1
@ nLinha,000 SAY cRegiEnde + ", " + cRegiNume + " - " + cRegiBair + " - Fone:" + cRegiFone FONT "F4" TO PRINT
@ nLinha,056 SAY DTOC( DATE()) FONT "F4" TO PRINT
nLinha += 1
@ nLinha,000 SAY "Email " + cemail FONT "F3" TO PRINT

nLinha += 2
@ nLinha,000,nLinha+14,020 RECTANGLE
@ nLinha,020,nLinha+1,040 RECTANGLE
@ nLinha,030,nLinha+1,045 RECTANGLE
@ nLinha,045,nLinha+1,060 RECTANGLE
@ nLinha,060,nLinha+1,075 RECTANGLE
@ nLinha,075,nLinha+10,98 RECTANGLE



@ nLinha,020 SAY 'NF FATURA Nº' FONT "F4" TO PRINT
@ nLinha,035 SAY 'VALOR R$' FONT "F3" TO PRINT
@ nLinha,045 SAY 'DUPLICATA Nº' FONT "F4" TO PRINT
@ nLinha,065 SAY 'VENCIMENTO' FONT "F3" TO PRINT
@ nLinha,077 SAY 'PARA USO DA' FONT "F4" TO PRINT
@ nLinha,015 SAY cRegiNome FONT "F5" TO PRINT

nLinha += 1
@ nLinha,077 SAY 'INSTITUIÇÃO FINANCEIRA' FONT "F4" TO PRINT
@ nLinha,003 SAY 'Assinatura do Emitente' FONT "F5" TO PRINT
@ nLinha,005 SAY '___________________' FONT "F5" TO PRINT

@ nLinha,020,nLinha+3,040 RECTANGLE
@ nLinha,030,nLinha+3,045 RECTANGLE
@ nLinha,045,nLinha+3,060 RECTANGLE
@ nLinha,060,nLinha+3,075 RECTANGLE

nLinha += 1
@ nLinha,020 SAY cNumeNota FONT "F4" TO PRINT
@ nLinha,032 SAY TRANSFORM( nValoNota, '@E 999,999.99' ) FONT "F2" TO PRINT
@ nLinha,050 SAY ( cNumeNota ) FONT "F3" TO PRINT
@ nLinha,060 SAY DTOC( dDataVenc ) FONT "F1" TO PRINT

nLinha += 2
@ nLinha,020,nLinha+2,098 RECTANGLE

@ nLinha,021 SAY 'DESCONTO DE % SOBRE ATÉ' FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'CONDIÇÕES ESPECIAIS' FONT "F3" TO PRINT

nLinha += 1
@ nLinha,020,nLinha+5,090 RECTANGLE
@ nLinha,090,nLinha+5,098 RECTANGLE

@ nLinha,021 SAY 'NOME DO SACADO: ' + cCodiClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'ENDEREÇO: ' + cEndeClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'CEP: ' + cCepClien + ' MUNICÍPIO: ' + ALLTRIM( cCidaClie ) + ' UF: ' + cEstaClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'PRAÇA DE PAGAMENTO: ' + ALLTRIM( cCidaClie ) + ' UF: ' + cEstaClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'CNPJ(MF) / CPF Nº: ' + cCnpjClie + ' Insc.Est. / RG Nº: ' + cIEstClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,020,nLinha+3,035 RECTANGLE
@ nLinha,035,nLinha+3,098 RECTANGLE
@ nLinha,037 SAY Extenso(nValoNota) FONT "F2" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'Valor por extenso' FONT "F3" TO PRINT

nLinha += 2
@ nLinha,020 SAY 'Reconhecemos a exatidão desta Duplicata de Venda Mercantil, na importância acima que pagaremos a' FONT "F3" TO PRINT


nLinha += 1
@ nLinha,020 SAY cRegiNome + ', ou a sua ordem, na praça e vencimento indicados.' FONT "F3" TO PRINT

nLinha += 3
@ nLinha,026 SAY 'Em ____/____/_____' FONT "F3" TO PRINT
@ nLinha,075 SAY '_________________________' FONT "F3" TO PRINT

nLinha += 1
@ nLinha,000 SAY '1ª VIA' FONT "F4" TO PRINT
@ nLinha,030 SAY '( Data do Aceite )' FONT "F4" TO PRINT
@ nLinha,083 SAY 'ASSINATURA' FONT "F4" TO PRINT


nLinha += 4

@ nLinha,000 SAY '_________________________________________________________________________________________________________________' FONT "F3" TO PRINT

nLinha += 4
@ nLinha,000,nLinha+18,098 RECTANGLE
nLinha += 1
@ nLinha,000,nLinha+6,095 RECTANGLE
@ nLinha,080,nLinha+6,095 RECTANGLE
@ nLinha,033,nLinha+6,055 RECTANGLE
@ nLinha,070,nLinha+6,098 RECTANGLE


nLinha += 1
@ nLinha,000 SAY cRegiFant FONT "F7" TO PRINT
@ nLinha,034 SAY "CNPJ: " + cRegiCnpj FONT "F3" TO PRINT

nLinha += 1
@ nLinha,034 SAY "Inscr. Estadual: " + cRegiIEst FONT "F3" TO PRINT

nLinha += 1
@ nLinha,000 SAY cRegiNome FONT "F7" TO PRINT
@ nLinha,034 SAY "Municipio de " + cRegiCida FONT "F3" TO PRINT
@ nLinha,056 SAY "DATA DE EMISSÃO: " FONT "F4" TO PRINT
@ nLinha,075 SAY "DUPLICATA" FONT "F6" TO PRINT
nLinha += 1
@ nLinha,000 SAY cRegiEnde + ", " + cRegiNume + " - " + cRegiBair + " - Fone:" + cRegiFone FONT "F4" TO PRINT
@ nLinha,056 SAY DTOC( DATE()) FONT "F4" TO PRINT
nLinha += 1
@ nLinha,000 SAY "Email " + cemail FONT "F3" TO PRINT

nLinha += 2
@ nLinha,000,nLinha+14,020 RECTANGLE
@ nLinha,020,nLinha+1,040 RECTANGLE
@ nLinha,030,nLinha+1,045 RECTANGLE
@ nLinha,045,nLinha+1,060 RECTANGLE
@ nLinha,060,nLinha+1,075 RECTANGLE
@ nLinha,075,nLinha+10,98 RECTANGLE




@ nLinha,020 SAY 'NF FATURA Nº' FONT "F3" TO PRINT
@ nLinha,035 SAY 'VALOR R$' FONT "F3" TO PRINT
@ nLinha,045 SAY 'DUPLICATA Nº' FONT "F3" TO PRINT
@ nLinha,065 SAY 'VENCIMENTO' FONT "F3" TO PRINT
@ nLinha,077 SAY 'PARA USO DA' FONT "F4" TO PRINT
@ nLinha,015 SAY cRegiNome FONT "F5" TO PRINT

nLinha += 1
@ nLinha,077 SAY 'INSTITUIÇÃO FINANCEIRA' FONT "F4" TO PRINT
@ nLinha,003 SAY 'Assinatura do Emitente' FONT "F5" TO PRINT
@ nLinha,005 SAY '___________________' FONT "F5" TO PRINT

@ nLinha,020,nLinha+3,040 RECTANGLE
@ nLinha,030,nLinha+3,045 RECTANGLE
@ nLinha,045,nLinha+3,060 RECTANGLE
@ nLinha,060,nLinha+3,075 RECTANGLE

nLinha += 1
@ nLinha,020 SAY cNumeNota FONT "F3" TO PRINT
@ nLinha,032 SAY TRANSFORM( nValoNota, '@E 999,999.99' ) FONT "F2" TO PRINT
@ nLinha,050 SAY ( cNumeNota ) FONT "F3" TO PRINT
@ nLinha,060 SAY DTOC( dDataVenc ) FONT "F1" TO PRINT

nLinha += 2
@ nLinha,020,nLinha+2,098 RECTANGLE

@ nLinha,021 SAY 'DESCONTO DE % SOBRE ATÉ' FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'CONDIÇÕES ESPECIAIS' FONT "F3" TO PRINT

nLinha += 1
@ nLinha,020,nLinha+5,090 RECTANGLE
@ nLinha,090,nLinha+5,098 RECTANGLE

@ nLinha,021 SAY 'NOME DO SACADO: ' + cCodiClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'ENDEREÇO: ' + cEndeClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'CEP: ' + cCepClien + ' MUNICÍPIO: ' + ALLTRIM( cCidaClie ) + ' UF: ' + cEstaClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'PRAÇA DE PAGAMENTO: ' + ALLTRIM( cCidaClie ) + ' UF: ' + cEstaClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'CNPJ(MF) / CPF Nº: ' + cCnpjClie + ' Insc.Est. / RG Nº: ' + cIEstClie FONT "F3" TO PRINT

nLinha += 1
@ nLinha,020,nLinha+3,035 RECTANGLE
@ nLinha,035,nLinha+3,098 RECTANGLE
@ nLinha,037 SAY Extenso(nValoNota) FONT "F2" TO PRINT

nLinha += 1
@ nLinha,021 SAY 'Valor por extenso' FONT "F3" TO PRINT

nLinha += 2
@ nLinha,020 SAY 'Reconhecemos a exatidão desta Duplicata de Venda Mercantil, na importância acima que pagaremos a' FONT "F3" TO PRINT


nLinha += 1
@ nLinha,020 SAY cRegiNome + ', ou a sua ordem, na praça e vencimento indicados.' FONT "F3" TO PRINT

nLinha += 3
@ nLinha,026 SAY 'Em ____/____/_____' FONT "F3" TO PRINT
@ nLinha,075 SAY '_________________________' FONT "F3" TO PRINT

nLinha += 1
@ nLinha,000 SAY '2ª VIA' FONT "F4" TO PRINT
@ nLinha,030 SAY '( Data do Aceite )' FONT "F4" TO PRINT
@ nLinha,083 SAY 'ASSINATURA' FONT "F4" TO PRINT


END PAGE
NEXT nLoop1

END DOC
RELEASE PRINTSYS
Return NIL





******************************
static Function EsperaResposta(cFile)
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

