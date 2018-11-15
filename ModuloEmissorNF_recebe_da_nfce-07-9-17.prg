// Harbour MiniGUI                 
// (c)2011 -Jos� juca 
// Modulo : Emissor de Nota Fiscal
// 14/2/2011 12:12:12
#include 'minigui.ch'
#Include "F_sistema.ch"
#include 'i_textbtn.ch'
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
//-------------------------------------------------
Function nfexml_recebe_da_nfce(xnum_seq)
//-------------------------------------------------
Local cQuery
*LOCAL C_CbdNtfNumero:=xnum_seq
Local cValue := ""
Local teste  := ""
Local teste1  := ""
local datahorarec:=""
local RETORNO:="" 
local sCStat  :="" //107
local IDI_COMP:=""
local sXMotivo:=""  //Servico em Operacao
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
abreseq_nfe()



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

USE ((ondetemp)+"gra_chave.DBF") new alias gra_chave exclusive  VIA "DBFCDX" 
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


USE ((ondeTEMP)+"SEQ_NFE.DBF") new alias SEQ_NFE exclusive    
IF EMPTY(SEQ_NFE->ABERTO)
CLOSE ALL  
USE ((ondetemp)+"SEQ_NFE.DBF") new alias SEQ_NFE exclusive    // arquivo que vai ter todo o conteudo do TXT
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
abregra_chave()
abreseq_nfe()


oQuery  :=oServer:Query( "SELECT max(CbdNtfNumero) FROM NFE20 WHERE cbdmod= "+"55"+" and CbdNtfSerie = "+ntrim(Serie_nfe)+"  Order By CbdNtfNumero" )
oRow := oQuery:GetRow(1)
oRow          := oQuery:GetRow(1)
C_CbdNtfNumero:=((oRow:fieldGet(1)))
C_CbdNtfNumero:=C_CbdNtfNumero+1 


*ncodigo:=((oRow:fieldGet(1)))
*xcodigo:=((oRow:fieldGet(1)))
*MSGINFO(xcodigo)
*ncodigo:=(ncodigo)+1
*c_codigo:=(ncodigo)
*MSGINFO(c_codigo)
*c_numero=INT(RANDOM()%999999 +1)


*oQuery        := oServer:Query( "Select MAX(CbdNtfNumero)FROM NFE20 CbdNtfNumero")
*oRow          := oQuery:GetRow(1)
*C_CbdNtfNumero:=((oRow:fieldGet(1)))
*C_CbdNtfNumero:=C_CbdNtfNumero+1 



	
	
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
  
	
	   

    BEGIN INI FILE "C:\ACBrMonitorPLUS\ACBrMonitor.INI"
      SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '0'
    END INI

	 
	 cRet       := MON_ENV("ACBr.lerini")

 *msginfo("cret")


IF ISWINDOWDEFINED(NFe)
    MINIMIZE WINDOW NFe
    RESTORE WINDOW NFe
ELSE

DEFINE WINDOW NFe;
       at 000,000;
       WIDTH nwd ;
       HEIGHT nhd-40;
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
            VALUE "S�rie"
            FONTSIZE 09
            FONTNAME "Arial"
     END LABEL  

     DEFINE TEXTBOX Txt_SERIE
            ROW   50
            COL   270
            WIDTH  25
            HEIGHT 20
            VALUE  ntrim(Serie_NFE)
            MAXLENGTH 5	
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
            OPTIONS {'Cupom','Davs/Orc','Devolu��o' ,'Conserto'}
            READONLY NIL
		    on gotfocus NFe.textBTN_cliente.SETFOCUS
            FONTSIZE 10
            FONTNAME "Arial"
			ON change {||MostraOBS()}
		END RADIOGROUP  
    
	
	
	
 @ 05, 410  LABEL IMPORTA ;
   WIDTH 140 ;
   HEIGHT 020 ;
   VALUE "N� DOC."  ;
   FONT "MS Sans Serif" SIZE 8.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 } BOLD 

 
  DEFINE TEXTBOX txt_DAV
            ROW   25
            COL    410
            WIDTH  80
			VALUE str(C_CbdNtfNumero)
            HEIGHT 20
            INPUTMASK "99999999"
	        NUMERIC .T.
			RIGHTALIGN .F. 
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 10
            FONTNAME "Arial"
		    MAXLENGTH 300	 	
            ON ENTER {||PESQ_PVENDA(),NFE.textBTN_cliente.setfocus}
     END TEXTBOX 

   
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
          tooltip 'Digite o c�digo ou clique na LUPA para pesquisar';
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
  
  
  
          DEFINE LABEL Lbl_ambiente
               ROW   50
               COL  550
               WIDTH  60
               HEIGHT 22
               VALUE "Ambiente"
               FONTSIZE 09
               FONTNAME "Arial"
        END LABEL  	 
  
   DEFINE TEXTBOX Txt_Ambiente
            ROW   50
            COL   620
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
            HEIGHT 50
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
 
 
 	
   DEFINE LABEL motra_XML
            ROW   180
            COL   410
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
		WIDTH 1020+nLarguraTela  ;
		HEIGHT 300 ;
	    WIDTHS {50,110,380,80,50,90,100,100,80,60,80,80,60,110 };
        HEADERS {'Itens','Codigo','Descri��o','Ncm','Und.','Qtd','Valor R$','Desc.R$','Sub-Total R$','%Icms','STB','CFOP','ICMS','CEST' };
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
               WIDTH  500
               HEIGHT 60
               MAXLENGTH 4000
        END EDITBOX  
		
		DEFINE EDITBOX Edit_Aplicacao_2
               ROW    330
               COL    550
	           VALUE   '' 
               WIDTH  400
               HEIGHT 60
               MAXLENGTH 4000
        END EDITBOX  
		
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
				   WIDTH 1020+nLarguraTela ;
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

 
	*	 nfe.textBTN_cfop.value:=5102
		// cNotaFiscal:=12
	   ACTIVATE WINDOW nfe
	   
	   	endif
		
	  Return NIL

 	  
	  
	  
	  
************************************
// --------------/------------------------------------------------------------.
STATIC FUNCTION wn_excluiitem()
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
// Fim da fun��o de excluir o item atual ------------------------------------.

static function atualizar()
delete item all from FITA of NFE
dbselectarea('ITEMNFE')
ITEMNFE->(ordsetfocus('NUMSEQ'))
ITEMNFE->(dbgotop())
       while .not. eof()
       ADD ITEM {STR(ITEMNFE->ITENS,3),ITEMNFE->PRODUTO,ITEMNFE->descricao,ITEMNFE->ncm,ITEMNFE->unid,transform((ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->VALOR, '9,999,999.99'),transform(ITEMNFE->valor_Desc,"99,999.9999"),transform((ITEMNFE->VALOR*ITEMNFE->qtd),"999,999.99"),transform(ITEMNFE->icms,"999.99"),transform(ITEMNFE->STB,"999"),ITEMNFE->cfop,transform(ITEMNFE->icms, '999,99'),transform(ITEMNFE->CEST, '@!')}TO FITA OF NFe
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
				  
  oQuery:= oServer:Query( "Select aliqnac,aliqimp,aliqest,ncm From tabela_ibpt WHERE ncm = " + AllTrim(xncm))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	:= oQuery:GetRow(1)
  if oRow:fieldGet(1)=0
  aliqnac:=18.85
  aliqimp:=12.85
  aliqest:=10.85
  C_ncm   :=VAL(xncm)
  else
  aliqnac :=oRow:fieldGet(1)
  aliqimp :=oRow:fieldGet(2)
  aliqest :=oRow:fieldGet(3)
  C_ncm   :=oRow:fieldGet(4)
  endif
  
ITEMNFE->(dbskip())
Impostos_Cupom_1:=XSUBTOTAL*aliqnac/100
Impostos_Cupom  :=Impostos_Cupom+Impostos_Cupom_1


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

NFE.Edit_Aplicacao.VALUE:=+'Documento emitido por empresa optante pelo Simples Nacional, permite aproveitamento de '+;
										 'credito de ICMS no Valor de R$ '+transf(TOTALICMS,'9,999,999.99')          +  ',correspondente a Aliquota de '+;
										 transform(DADOSNFE->ALIQUOTA,'99,999,999.99')+'% nos termos do art. 23 da LC 123 ;                            '+;
										 "Valor Aproximado dos Tributos R$   "+"  "+"FED:"+ transf(DADOSNFE->n_ibpt,"@R 999,999.99")+   " MUN:"+ transf(DADOSNFE->m_ibpt,"@R 999,999.99")+"  Est:"+ transf(DADOSNFE->E_ibpt,"@R 999,999.99")+" ("+transf(VV_VALOR,"999.99")+"%) Conf. Lei 12.741/2012   Fonte: Tabela IBPT (www.ibpt.com.br);  " 

										 
										 
 
 endif

IF nfe.oRad3.VALUE == 2			
 
 NFE.Edit_Aplicacao.VALUE:='NOTA FISCAL ELETRONICA REFERENTE AO CUPOM FISCAL'+"    "+"EMITIDO  PELA  A  ECF    "+DADOSNFE->SERIE  +"   COO  "+STRZERO(DADOSNFE->num_seq,6)+"    "+"CCF   "+ (DADOSNFE->CCF) ; 
 +"Valor cr�dito do ICMS        "     +   TOTALICMS       + "          aliquota De      " +  NTOTAL  +  "   pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)" +   "  " +LIN_21
endif

//NFE.Edit_Aplicacao.VALUE:="Valor cr�dito do ICMS        "     +   TOTALICMS       + "          aliquota De      " +  NTOTAL  + "%"+ "   pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)"

IF nfe.oRad3.VALUE == 3			
  
NFE.Edit_Aplicacao.VALUE:=" NOTA FISCAL DE DEVOLUCAO DE EMPRESA OPTTANTE PELO SIMPES      ";
+"GERA CREDITO DE ICMS CONF. A NOTA FISCAL  NUMERO                      EMISSAO DE                      "      ;
+"REF. A BASE DE CALCULO NO VALOR DE R$                        VALOR DO ICMS R$                         "
endif


IF nfe.oRad3.VALUE == 4	

NFE.Edit_Aplicacao.VALUE:=+"NOTA FISCAL ELETRONICA  REMESSA SIMPLES PARA CONSERTO OU REPARO NFE ENTRADA          "  
										 
										 
 
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
			  
	
oQuery:= oServer:Query( "Select aliqnac,aliqimp,aliqest,ncm From tabela_ibpt WHERE ncm = " + AllTrim(xncm))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	:= oQuery:GetRow(1)
  if oRow:fieldGet(1)=0
  aliqnac:=18.85
  aliqimp:=12.85
  aliqest:=10.85
  C_ncm   :=VAL(xncm)
  else
  aliqnac :=oRow:fieldGet(1)
  aliqimp :=oRow:fieldGet(2)
  aliqest :=oRow:fieldGet(3)
  C_ncm   :=oRow:fieldGet(4)
  endif
  
  
*Impostos_Cupom_1:=ITEMNFcE->SUBTOTAL*aliqnac/100
* Impostos_Cupom  :=Impostos_Cupom+Impostos_Cupom_1
 public XV_IBPT         :=ITEMNFCE->SUBTOTAL*aliqnac/100
 public NA_IBPT         :=ITEMNFCE->SUBTOTAL*aliqnac/100   
 public MP_IBPT         :=ITEMNFCE->SUBTOTAL*aliqimp/100   
 public ES_IBPT         :=ITEMNFCE->SUBTOTAL*aliqest/100   
Impostos_Cupom   :=Impostos_Cupom+NA_IBPT+MP_IBPT+ES_IBPT		  


	 
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
						ITEMNFE->SEQ_T          := ITEMNFCE->SEQ_T
						ITEMNFE->cest           := ITEMNFCE->CEST
	 			    	ITEMNFE->N_IBPT         := na_IBPT
					    ITEMNFE->m_IBPT         := mp_IBPT
					    ITEMNFE->E_IBPT         := es_IBPT
						ITEMNFE->st             :=ITEMNFcE->st
						ITEMNFE->STB            :=ITEMNFcE->stb
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
					   DADOSNFE->N_IBPT      :=NA_IBPT			   
					   DADOSNFE->m_IBPT      :=mp_IBPT		   
                       DADOSNFE->E_IBPT      :=es_IBPT	   
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
				       DADOSNFE->N_IBPT      :=NA_IBPT			   
					   DADOSNFE->m_IBPT      :=mp_IBPT		   
                       DADOSNFE->e_IBPT      :=es_IBPT	   
		 					   
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
					
				
     SELE DADOSNFE
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :=alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :=alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:=alltrim(DADOSNFE->ED_NUMERO)
	vNFE                    :=NTRIM(NFe.Txt_NOTA.VALUE)
    xCbdEmpCodigo           :="1"
   xCbddEmi  		        := dtos(date())
			
				
        
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
 
public P_DESCONTO:=NTRIM(NFE.Txt_desconto1.value)
 


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
		width NWD;
        height nHD-40;
		title 'Clientes';
		icon cPathImagem+'jumbo1.ico';
		modal;
        nosize
     
 ON KEY ESCAPE ACTION form_auto.release //tecla ESC para fechar a janela

 
 
  DEFINE LABEL Valor_NF4 
            ROW    430
			COL    000
            WIDTH  200
            HEIGHT 30
            VALUE "Nome"
			FONTNAME "MS Sans Serif"
            FONTSIZE 10
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .f.
           FONTCOLOR { 000, 000, 255 } 
           BACKCOLOR { 244, 244, 244 }
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  


  DEFINE LABEL oSay6 
             ROW 430
			COL  200
		    WIDTH 750
            HEIGHT 30
            VALUE ""
			FONTNAME "MS Sans Serif"
            FONTSIZE 10
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {255, 000, 00}
            BORDER .T.
            CLIENTEDGE .T.
		    RIGHTALIGN .F.
  END LABEL  
  
 
   
   
  
  DEFINE LABEL Valor_NF1 
            ROW    480
			COL    000
            WIDTH  200
            HEIGHT 30
            VALUE "Endere�o Cidade estado"
			FONTNAME "MS Sans Serif"
            FONTSIZE 10
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .f.
           FONTCOLOR { 000, 000, 255 } 
           BACKCOLOR { 244, 244, 244 }
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
   
   
   
  DEFINE LABEL oSay3
             ROW 480
			COL  200
		    WIDTH 750
            HEIGHT 30
            VALUE ""
			FONTNAME "MS Sans Serif"
            FONTSIZE 10
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {255, 000, 000}
            BORDER .T.
            CLIENTEDGE .T.
		    RIGHTALIGN .F.
  END LABEL  
  
    
  DEFINE LABEL Valor
            ROW    530
			COL    000
            WIDTH  200
            HEIGHT 30
            VALUE "Cnpj/Cpf"
			FONTNAME "MS Sans Serif"
            FONTSIZE 10
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .f.
           FONTCOLOR { 000, 000, 255 } 
           BACKCOLOR { 244, 244, 244 }
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
   
	
	

  DEFINE LABEL oSay1
             ROW 530
			COL  200
		    WIDTH 150
            HEIGHT 30
            VALUE ""
			FONTNAME "MS Sans Serif"
            FONTSIZE 10
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {255, 00, 000}
            BORDER .T.
            CLIENTEDGE .T.
		    RIGHTALIGN .F.
  END LABEL  
  
   
   
    
  DEFINE LABEL Valor_NF
            ROW    530
			COL    450
            WIDTH  100
            HEIGHT 30
            VALUE "Ie/Rg"
			FONTNAME "MS Sans Serif"
            FONTSIZE 10
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .f.
           FONTCOLOR { 000, 00, 255 } 
           BACKCOLOR { 244, 244, 244 }
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
   
      
	  
	  
  DEFINE LABEL oSay2
             ROW 530
			COL  600
		    WIDTH 150
            HEIGHT 30
            VALUE ""
			FONTNAME "MS Sans Serif"
            FONTSIZE 10
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {255, 00, 00}
            BORDER .T.
            CLIENTEDGE .T.
		    RIGHTALIGN .F.
  END LABEL  
	  
	
	

 @ 600, 000 LABEL Label_Search_codigo ;
      WIDTH 220 ;
      HEIGHT 030 ;
       VALUE "Pesquisa Nome/cnpj";
      FONT "MS Sans Serif" SIZE 10.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 
	
  @ 600,280 TEXTBOX cSearch ;
    WIDTH 200 ;
    MAXLENGTH 60 ;
    UPPERCASE  ;
    backcolor _AMARELO;
   ON ENTER iif( !Empty(form_auto.cSearch.Value), pesqcli1(), form_auto.Grid_22.SetFocus )
 

 
 
DEFINE GRID Grid_22
            ROW    00
            COL    00
            WIDTH  AJANELA-10
             HEIGHT 420
            HEADERS {"Codigo", "Name","Cnpj","Ie","Cpf","Rg"}
            WIDTHS  {60, 335,150,150,150,150} 
            VALUE 1 
	        JUSTIFY {1,0,1,1,1,1,1}
            FONTNAME 'Times New Roman'
            FONTSIZE 13
            FONTBOLD .F.
            FONTUNDERLINE .F.
            VIRTUAL .F.
            SHOWHEADERS .T.
            BACKCOLOR {185,255,185}
            FONTCOLOR {0,0,160}
		    on dblclick {||Find_cli()}
			on change mostradadoscliente()
     END GRID  
	

 
 	  				   
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

XCbdCFOP:=nfe.textBTN_cfop.value


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
xCbdCFOP:=6404
xst     :="500"
xstb    :=500 
elseif C_UF<>"RO"
xCbdCFOP:=6102
xst     :="102" 
xstb    :=102
endif
endif


IF nfe.oRad3.VALUE == 4
if C_UF<>"RO" .and.xCbdvAliq=0
XCbdCFOP:=nfe.textBTN_cfop.value
xst     :="0900"
xstb    :=0900  
elseif C_UF<>"RO"
XCbdCFOP:=nfe.textBTN_cfop.value
xst     :="0900" 
xstb    :=0900 
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
 

*MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	 
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
	      MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	      NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
	      MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	      NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   
	   
	   	   
IF EMPTY(NFE.T_NOMECLI.VALUE)
          msgexclamation('O campo nome est� vazio','Aten��o')
	      MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	      NFE.T_NOMECLI.VALUE := ""
          NFE.T_NOMECLI.SETFOCUS
   Return( .F. )
 endif
 
  
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
         MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	      msgexclamation('O campo cnpj est� vazio','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
 
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
	      MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	      NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   



 
 IF EMPTY(NFE.Txt_ENDCLI.VALUE)
        msgexclamation('O campo endere�o est� vazio','Aten��o')
  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	     NFE.Txt_ENDCLI.VALUE := ""
         NFE.Txt_ENDCLI.SETFOCUS
   Return( .F. )
 endif



  IF EMPTY(NFE.Txt_CIDCLI.VALUE )
        msgexclamation('O campo Cidade est� vazio','Aten��o')
   MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	    NFE.Txt_CIDCLI.VALUE  := ""
        NFE.Txt_CIDCLI.SETFOCUS
   Return( .F. )
 endif

 
  IF EMPTY(NFE.textBTN_IBGE.VALUE)
        msgexclamation('O campo Codigo municipio esta vazio','Aten��o')
	     MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	     NFE.textBTN_IBGE.VALUE  := ""
         NFE.textBTN_IBGE.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_NUMCLI.VALUE)
        msgexclamation('O campo numero logadoura est� vazio','Aten��o')
        MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	    NFE.Txt_NUMCLI.VALUE := ""
        NFE.Txt_NUMCLI.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_CEPCLI.VALUE)
        msgexclamation('O campo cep est� vazio','Aten��o')
	    MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
	     NFE.Txt_CEPCLI.VALUE := ""
         NFE.Txt_CEPCLI.SETFOCUS
   Return( .F. )
 endif
 
 IF EMPTY(NFE.Txt_BAIRROCLI.VALUE)
        msgexclamation('O campo Bairro est� vazio','Aten��o')
 	MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_BAIRROCLI.VALUE := ""
         NFE.Txt_BAIRROCLI.SETFOCUS
   Return( .F. )
 endif
 
 
 IF EMPTY(NFE.Txt_UFCLI.VALUE)
         msgexclamation('O campo Estado est� vazio','Aten��o')
	 	 MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
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
 numeronfe:=NFe.Txt_NOTA.VALUE
xCbdEmpCodigo:="1"
xCbddEmi     := dtos(date())
CCbdxNome_dest:=nfe.Txt_NOMECLI.value

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
          msgexclamation('O campo cnpj est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo CPF est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   
	   
	   	   
IF EMPTY(NFE.T_NOMECLI.VALUE)
          msgexclamation('O campo nome est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.T_NOMECLI.VALUE := ""
          NFE.T_NOMECLI.SETFOCUS
   Return( .F. )
 endif
 
  
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
 
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   



 
 IF EMPTY(NFE.Txt_ENDCLI.VALUE)
        msgexclamation('O campo endere�o est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_ENDCLI.VALUE := ""
         NFE.Txt_ENDCLI.SETFOCUS
   Return( .F. )
 endif



  IF EMPTY(NFE.Txt_CIDCLI.VALUE )
        msgexclamation('O campo Cidade est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_CIDCLI.VALUE  := ""
         NFE.Txt_CIDCLI.SETFOCUS
   Return( .F. )
 endif

 
  IF EMPTY(NFE.textBTN_IBGE.VALUE)
        msgexclamation('O campo Codigo municipio esta vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.textBTN_IBGE.VALUE  := ""
         NFE.textBTN_IBGE.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_NUMCLI.VALUE)
        msgexclamation('O campo numero logadoura est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_NUMCLI.VALUE := ""
         NFE.Txt_NUMCLI.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_CEPCLI.VALUE)
        msgexclamation('O campo cep est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_CEPCLI.VALUE := ""
         NFE.Txt_CEPCLI.SETFOCUS
   Return( .F. )
 endif
 
 IF EMPTY(NFE.Txt_BAIRROCLI.VALUE)
        msgexclamation('O campo Bairro est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_BAIRROCLI.VALUE := ""
         NFE.Txt_BAIRROCLI.SETFOCUS
   Return( .F. )
 endif
 
 
 IF EMPTY(NFE.Txt_UFCLI.VALUE)
         msgexclamation('O campo Estado est� vazio','Aten��o')
		 MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
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

Reconectar_A() 

*oQuery := oServer:Query( "Select MAX(CbdNtfNumero)FROM nfe20 CbdNtfNumero")
*oRow          := oQuery:GetRow(1)
*C_CbdNtfNumero:=((oRow:fieldGet(1)))
*C_CbdNtfNumero:=C_CbdNtfNumero+1 
C_CbdNtfNumero:=NFe.Txt_NOTA.VALUE

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
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo CPF est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   
	   
	   	   
IF EMPTY(NFE.T_NOMECLI.VALUE)
          msgexclamation('O campo nome est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.T_NOMECLI.VALUE := ""
          NFE.T_NOMECLI.SETFOCUS
   Return( .F. )
 endif
 
  
IF xxtipo="P" 
 IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
 
elseif xxtipo="F"
IF EMPTY(NFE.Txt_CNPJ.VALUE)
          msgexclamation('O campo cnpj est� vazio','Aten��o')
		  MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
          NFE.Txt_CNPJ.VALUE := ""
          NFE.Txt_CNPJ.SETFOCUS
   Return( .F. )
 endif
endif   



 
 IF EMPTY(NFE.Txt_ENDCLI.VALUE)
        msgexclamation('O campo endere�o est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_ENDCLI.VALUE := ""
         NFE.Txt_ENDCLI.SETFOCUS
   Return( .F. )
 endif



  IF EMPTY(NFE.Txt_CIDCLI.VALUE )
        msgexclamation('O campo Cidade est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_CIDCLI.VALUE  := ""
         NFE.Txt_CIDCLI.SETFOCUS
   Return( .F. )
 endif

 
  IF EMPTY(NFE.textBTN_IBGE.VALUE)
        msgexclamation('O campo Codigo municipio esta vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.textBTN_IBGE.VALUE  := ""
         NFE.textBTN_IBGE.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_NUMCLI.VALUE)
        msgexclamation('O campo numero logadoura est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_NUMCLI.VALUE := ""
         NFE.Txt_NUMCLI.SETFOCUS
   Return( .F. )
 endif

 IF EMPTY(NFE.Txt_CEPCLI.VALUE)
        msgexclamation('O campo cep est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_CEPCLI.VALUE := ""
         NFE.Txt_CEPCLI.SETFOCUS
   Return( .F. )
 endif
 
 IF EMPTY(NFE.Txt_BAIRROCLI.VALUE)
        msgexclamation('O campo Bairro est� vazio','Aten��o')
		MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
         NFE.Txt_BAIRROCLI.VALUE := ""
         NFE.Txt_BAIRROCLI.SETFOCUS
   Return( .F. )
 endif
 
 
 IF EMPTY(NFE.Txt_UFCLI.VALUE)
         msgexclamation('O campo Estado est� vazio','Aten��o')
		 MsgStop('CADASTRO DO CLIENTE ESTA INCOMPLETO ','Aten��o')
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
NTOTAL   :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')
vv_total :=(DADOSNFE->VALOR_TOT)
TOTALICMS:=vv_total*DADOSNFE->ALIQUOTA/100
VV_VALOR:=DADOSNFE->TOTAL_IMP/Vv_total*100
 
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
mEstado_Destinatario:=NFE.Txt_UFCLI.VALUE
mCNPJ_DESTINATARIO:=DADOSNFE->CL_CGC
 mInscricaoEstadual:= DADOSNFE->RGIE

  if Len(limpa(mCNPJ_DESTINATARIO))=11 .and. ( empty(limpa(mInscricaoEstadual)) .or. mInscricaoEstadual='ISENTO' )
       mInscricaoEstadual:='ISENTO'
	      if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
	       	mindIEDest:='9'
				mgindFinal:='1'
				xCST='102'
       	else
	       	mindIEDest:='2'
       	end
  elseif empty(limpa(mInscricaoEstadual))
       mInscricaoEstadual:='ISENTO'
	      if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
	       	mindIEDest:='9'
				mgindFinal:='1'
				xCST='102'
       	else
	       	mindIEDest:='2'
       	end
			
		if  Len(limpa(mCNPJ_DESTINATARIO))=14
       mInscricaoEstadual:=''
	      if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP' 
	       	mindIEDest:='9'
				mgindFinal:='1'
				xCST='102'
       	else
	       	mindIEDest:='2'
       	end
		end
  else
  
    if Len(limpa(DADOSNFE->CL_CGC))=11.AND.DADOSNFE->CL_PESSOA='F'
		       mInscricaoEstadual:='ISENTO'
		 	      if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
		 	       	mindIEDest:='9'
						mgindFinal:='1'
						xCST='102'
		        	else
			       	mindIEDest:='2'
		        	end
		  elseif DADOSNFE->CL_PESSOA='P'	   
		       mInscricaoEstadual:=(DADOSNFE->RGIE)
		  elseif empty((DADOSNFE->RGIE))
		       mInscricaoEstadual:='ISENTO'
		 	      if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
		 	       	mindIEDest:='9'
						mgindFinal:='1'
						xCST='102'
		        	else
			       	mindIEDest:='2'
		        	end
		  else
		       mInscricaoEstadual:=(DADOSNFE->RGIE)
		       nResposta := ConsisteInscricaoEstadual(LIMPA(mInscricaoEstadual),upper(xUF_Cliente))
		       if nResposta<>0
		           MSGINFO( "Inscri��o inv�lida para o estado de "+upper(xUF_Cliente)+"...")
				   RETURN
 		       Endif
		  end

    
  
  
  
  

    *   mInscricaoEstadual:=mInscricaoEstadual
    *   nResposta := ConsisteInscricaoEstadual(LIMPA(mInscricaoEstadual),upper(mEstado_Destinatario))
     *  if nResposta<>0
     *      MSGINFO( "Inscri��o inv�lida para o estado de "+upper(mEstado_Destinatario)+"...")
//	*	     RETURN
     *  mInscricaoEstadual:=' '     
	   
	   
	   
	      if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
	       	mindIEDest:='9'
			xCST='102'
				mgindFinal:='1'
       	else
	       	mindIEDest:='2'
       	end
       Endif
 


 
 
	      DADOS_NFe:={}
		 aadd(DADOS_NFe,{'NFE.CriarEnviarNFe'})
		 aadd(DADOS_NFe,{'[infNFe]'})
		 aadd(DADOS_NFe,{'versao=3.10'})
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
 

// grava�oes  destinatarios

		 aadd(DADOS_NFe,{'[Destinatario]' })

		 aadd(DADOS_NFe,{'CNPJ='+DADOSNFE->CL_CGC })
		 aadd(DADOS_NFe,{'NomeRazao='+( Alltrim(DADOSNFE->NOM_CLI) ) })
		 aadd(DADOS_NFe,{'indIEDest ='+mindIEDest  })
 	*IF  mindIEDest=='1'
 		 aadd(DADOS_NFe,{'IE='+mInscricaoEstadual })
  *	END
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
		 xCFOP:=ITEMNFE->CFOP
	     nCFOP:=ITEMNFE->CFOP
		xITEM:=strzero(xxx,3)
		
		 aadd(DADOS_NFe,{'[Produto'+strzero(registro,3)+']' })
		 aadd(DADOS_NFe,{'CFOP=' +limpa(nCFOP) })
		 aadd(DADOS_NFe,{'Codigo=' +ALLTRIM(ITEMNFE->PRODUTO) })
	 	 aadd(DADOS_NFe,{'Descricao=' +Alltrim(ITEMNFE->DESCRICAO) })
	 	 aadd(DADOS_NFe,{'indAdProd='   +ALLTRIM(xindAdProd )})
	     aadd(DADOS_NFe,{'EAN=' })
		 aadd(DADOS_NFe,{'NCM=' +LPAD(STR(val(ITEMNFE->ncm)),8,[0])})
		 
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
     
 		if IPI>0

			aadd(DADOS_NFe,{'[IPI'+xITEM+']' })
			aadd(DADOS_NFe,{'CST=99' })
			aadd(DADOS_NFe,{'ClasseEnquadramento=' })
			aadd(DADOS_NFe,{'CNPJProdutor=' })
			aadd(DADOS_NFe,{'CodigoSeloIPI=' })
			aadd(DADOS_NFe,{'QuantidadeSelos=' })
			aadd(DADOS_NFe,{'CodigoEnquadramento=' })
			aadd(DADOS_NFe,{'ValorBase='+str(Auxilia3->Quant*Auxilia3->Unit) })
			aadd(DADOS_NFe,{'Quantidade='+str(Auxilia3->Quant) })
			aadd(DADOS_NFe,{'ValorUnidade='+str(Auxilia3->Quant*Auxilia3->Unit) })
			aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(auxilia3->IPI,"@ 99.99")) })
			aadd(DADOS_NFe,{'Valor='+str(auxilia3->TOTIPI) })
			   
		endif

		 // Dados do icms[xxx]
        * xCST:=str(ITEMNFE->stb)
		* aadd(DADOS_NFe,{'[ICMS'+xITEM+']' })
		  aadd(DADOS_NFe,{'[ICMS'+strzero(registro,3)+']' })
		* aadd(DADOS_NFe,{'orig='+Auxilia3->origem })
msginfo(mgREGIME)
*if mgREGIME==1
   xICMS:='ICMSSN'
  	IF  mindIEDest=='9'  //nao permite aproveitamento de credito para pessoa fisica
  		xCST='102' 
	End
msginfo(xCST)

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
* endif
 
/*
 CbdvBC:=0
pICMSUFDest:=0
pICMSInter:=0
pICMSInterPart:=0
vFCPUFDest:=0
vICMSUFDest:=0
vICMSUFRemet:=0

 	        aadd(DADOS_NFe,{'[ICMSUFDest'+strzero(registro,3)+']' })
			 aadd(DADOS_NFe,{'vBCUFDest='+ALLTRIM(TRANSFORM(CbdvBC   ,"@ 99999999999999.99"))  })
			 aadd(DADOS_NFe,{'pFCPUFDest=0.00'})//+ALLTRIM(TRANSFORM(pFCPUFDest   ,"@ 99.99"))  })
			 aadd(DADOS_NFe,{'pICMSUFDest='+ALLTRIM(TRANSFORM(pICMSUFDest   ,"@ 99.99"))   })
			 aadd(DADOS_NFe,{'pICMSInter='+ALLTRIM(TRANSFORM(pICMSInter   ,"@ 99.99")) })            
			 aadd(DADOS_NFe,{'pICMSInterPart=' +ALLTRIM(TRANSFORM(pICMSInterPart   ,"@ 99.99")) })

          	 aadd(DADOS_NFe,{'vFCPUFDest='  })////+ALLTRIM(TRANSFORM(vFCPUFDest   ,"@ 99.99"))   })
			 aadd(DADOS_NFe,{'vICMSUFDest='+ALLTRIM(TRANSFORM(vICMSUFDest   ,"@ 99999999999999.99"))   })
			 aadd(DADOS_NFe,{'vICMSUFRemet='+ALLTRIM(TRANSFORM(vICMSUFRemet   ,"@ 99999999999999.99"))  })
	*/
	
 
 
 
 
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
	 
	 

xtPag:=01
ttipo:=1
	 
	    MTOTALForma :=nTotalBase
  	 	aadd(DADOS_NFe,{'[pag'+strzero(ttipo,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+strzero(xtPag)})	
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
        *aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		

	 
	 
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



	

 xCbdinfCpl	  	 	  := NFE.Edit_Aplicacao.VALUE +"   "+NFE.Edit_Aplicacao_2.VALUE  

* xCbdinfCpl	  	 	  := DADOSNFE->OBS +"    "+ COMPLEMENTO
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




*public cDestino :=PATH+"\nfcedaruma.TXT"
*xcml            :=memoread(cDestino) 

   
   
 cQuery := "UPDATE NFE20 SET ARQUIVO_TXT='"+AllTrim(xcml)+"' WHERE CbdNtfNumero = "+C_CbdNtfNumero+" "
 
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
    ELSE
 *MSGINFO("OK")
  Endif
abreseq_nfe()
abreNFCE()
abreseq_dav()


IF   MONITORACBR="NAO"
ENVIAR_NFE()
ELSE 
ENVIAR_NFE_class()
ENDIF 



RETURN
// Fim da fun��o de gerar tela de splash ------------------------------------.
// --------------------------------------------------------------------------.
static FUNCTION ENVIAR_NFE()
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
LOCAL nLote:="1" 
Public cEnvio_XML:=.t.
public nnfe:="NFE"+NTRIM(NFe.Txt_NOTA.VALUE)
cTXT:=PATH+"\NOTA.TXT"

    BEGIN INI FILE "C:\ACBrMonitorPLUS\ACBrMonitor.INI"
      SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '0'
    END INI
     ProcedureLerINI()


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


if SUBSTR(memoread("C:\ACBrMonitorplus\sai.txt"), 1, 4)=="ERRO"
 cRet       := MON_ENV("NFe.CriarNFe("+cTXT+","+bRetornaXML+")")
msginfo("Tente mais tarde")
Return(.f.) 
EndIf    




xCbdEmpCodigo   := '1'

fxml:="C:\ACBrMonitorPLUS\"+xchavenfce+"-nfe.xml"
ffxml:=memoread(fxml)
MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML GERADO.:' +fxml
numeronfe    :=NFe.Txt_NOTA.VALUE
ClienteTxtCGC:=nfe.Txt_CNPJ.value

cCbdvNF      :=ntrim(nfe.Txt_valortotal.value)
cCbdvDesc_cob:=ntrim(NFE.Txt_desconto1.value)
cCbdvProd_ttlnfe:=ntrim(NFE.Txt_total.value)
    
xCbdEmpCodigo:="1"
cbdmod        :="55" 
xCbddEmi     := dtos(date())
CCbdxNome_dest:=nfe.Txt_NOMECLI.value	

vvNFE:=val(vNFE)
 oQuery   :=oServer:Query( "SELECT CbdNtfNumero FROM nfe20 WHERE CbdNtfNumero = "+NTRIM(vvNFE)+" AND  cbdmod= "+"55"+" and CbdNtfSerie = "+ntrim(Serie_nfe)+"  Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
   XCODIGO        :=ALLTRIM(STR(oRow:fieldGet(1)))


IF ntrim(numeronfe)=XCODIGO 
else
cQuery := "INSERT INTO nfe20 (CbdvProd_ttlnfe,CbdvDesc_cob,CbdvNF, cbdmod, CbdCnpj_dest ,chave,CbdNtfNumero,CbdNtfSerie,CbdEmpCodigo,CbddEmi,CbdxNome_dest )  VALUES ('"+cCbdvProd_ttlnfe+"','"+cCbdvDesc_cob+"','"+cCbdvNF+"', '"+cbdmod+"', '"+ClienteTxtCGC+"','"+xchavenfce+"','"+ntrim(numeronfe)+"','"+ntrim(Serie_nfe)+"','"+xCbdEmpCodigo+"','"+xCbddEmi+"' ,'"+CCbdxNome_dest+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
MsgStop(oQuery:Error())
MsgInfo("Por Favor Selecione o registro SOS nfe20 LINHA 2547")
Endif	
endif



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

 
			
                     *   MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML ENVIADO.:' + xchavenfce  
                        SetProperty('nfe','gerando_xml1','Value','Processado!!!')
                        SetProperty('NFE','gerando_xml1','BLINK',.F.)
						
					  
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
public RRCStat   :=R_CStat
public C_XMotivo :=R_XMotivo
PUBLIC cChNFe    :=c_ChNFe
PUBLIC CNPROT    :=c_NProt
PUBLIC cDhRecbto :=c_DhRecbto
public xANO        := dtoS(date())
public xANO        :=ALLTRIM(SUBSTR(XANO,0,6))
public c_CFileDanfe:=""

MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML AUTORIZADO..:' + C_XMotivo 
MODIFY CONTROL gerando_xml OF nfe  VALUE   'PROTOCOLO..:' +  CNPROT


///////////////////////////////////////////
***  SE DEU ERRO VOLTA O NUMERO ***********
///////////////////////////////////////////
if RRCStat='806' .or. RRCStat='201' .or. RRCStat='202' .OR. RRCStat= "203" .or. RRCStat="205" .or. RRCStat="206" .or. RRCStat="207" .or. RRCStat="208" .or. RRCStat="209" .OR. RRCStat='210' .or. RRCStat='211' .or. RRCStat='212' .or. RRCStat='213' .or. RRCStat='214' .or. RRCStat='215' .or. RRCStat='216' .or. RRCStat='217' .or. RRCStat='218' .or. RRCStat='219' .or. RRCStat='220' .or. RRCStat='221' .or. RRCStat='222' .or. RRCStat='223' .or. RRCStat='224' .or. RRCStat='225' .or. RRCStat='226' .or. RRCStat='227' .or. RRCStat='229' .or. RRCStat='230' .or. RRCStat='231' .or. RRCStat='232' .or. RRCStat='233' .or. RRCStat='234' .or. RRCStat='235' .or. RRCStat='236' .or. RRCStat='237' .or. RRCStat='238' .or. RRCStat='239' .or. RRCStat='240' .or. RRCStat='241' .or. RRCStat='242' .or. RRCStat='243' .or. RRCStat='244' .or. RRCStat='245' .or. RRCStat='246' .or. RRCStat='247' .or. RRCStat='248' .or. RRCStat='249' .or. RRCStat='250'  .or. RRCStat='251' .or. RRCStat='252' .or. RRCStat='253' .or. RRCStat='254' .or. RRCStat='255' .or. RRCStat='256' .or. RRCStat='257' .or. RRCStat='258' .or. RRCStat='259' .or. RRCStat='260' .or. RRCStat='261' .or. RRCStat='262' .or. RRCStat='263' .or. RRCStat='264' .or. RRCStat='265' .or. RRCStat='266'  .or. RRCStat='267' .or. RRCStat='268' .or. RRCStat='269' .or. RRCStat='270' .or. RRCStat='271' .or. RRCStat= '272' .or. RRCStat='273' .or. RRCStat='274' .or. RRCStat='275' .or. RRCStat='276' .or. RRCStat='277' .or. RRCStat='278' .or. RRCStat='279' .or. RRCStat='280' .or. RRCStat='281' .or. RRCStat='282'  .or. RRCStat='283' .or. RRCStat='284' .or. RRCStat='285' .or. RRCStat='286' .or. RRCStat='287' .or. RRCStat='288' .or. RRCStat='289' .or. RRCStat='290' .or. RRCStat='291' .or. RRCStat='292' .or. RRCStat='293' .or. RRCStat='294' .or. RRCStat='295' .or. RRCStat='296' .or. RRCStat='297' .or. RRCStat='298' .or. RRCStat='299' .or. RRCStat='401' .or. RRCStat='402' .or. RRCStat='403' .or. RRCStat='404' .or. RRCStat='405' .or. RRCStat='406' .or. RRCStat='407' .or. RRCStat='409' .or. RRCStat='410' .or. RRCStat='411' .or. RRCStat='420' .or. RRCStat='450' .or. RRCStat='451' .or. RRCStat='452' .or. RRCStat='453'  .or. RRCStat='454' .or. RRCStat='478' .or. RRCStat='502' .or. RRCStat='503' .or. RRCStat='504' .or. RRCStat='505' .or. RRCStat='506' .or. RRCStat='507' .or. RRCStat='508' .or. RRCStat='509' .or. RRCStat='510' .or. RRCStat='511' .or. RRCStat='512' .or. RRCStat='513' .or. RRCStat='514' .or. RRCStat='515' .or. RRCStat='516' .or. RRCStat='517' .or. RRCStat='518' .or. RRCStat='519' .or. RRCStat='520' .or. RRCStat='521' .or. RRCStat='522' .or. RRCStat='523'  .or. RRCStat='524' .or. RRCStat='525' .or. RRCStat='526' .or. RRCStat='527' .or. RRCStat='528' .or. RRCStat='529' .or. RRCStat='530' .or. RRCStat='531'  .or. RRCStat='532' .or. RRCStat='534' .or. RRCStat='535' .or. RRCStat='536' .or. RRCStat='537' .or. RRCStat='538' .or. RRCStat='540' .or. RRCStat='541' .or. RRCStat='542' .or. RRCStat='544' .or. RRCStat='545' .or. RRCStat='546' .or. RRCStat='547' .or. RRCStat='548' .or. RRCStat='549' .or. RRCStat='550' .or. RRCStat='551' .or. RRCStat='552' .or. RRCStat='553' .or. RRCStat='554' .or. RRCStat='555' .or. RRCStat='556' .or. RRCStat='557' .or. RRCStat='558'  .or. RRCStat='559' .or. RRCStat='560' .or. RRCStat='561' .or. RRCStat='562' .or. RRCStat='564' .or. RRCStat='565' .or. RRCStat='567' .or. RRCStat='568' .or. RRCStat='569' .or. RRCStat='570' .or. RRCStat='571' .or. RRCStat='572' .or. RRCStat='573' .or. RRCStat='574' .or. RRCStat='575' .or. RRCStat='576' .or. RRCStat='577' .or. RRCStat='578' .or. RRCStat='579' .or. RRCStat='580' .or. RRCStat='587' .or. RRCStat='588' .or. RRCStat='589' .or. RRCStat='590' .or. RRCStat='591' .or. RRCStat='592' .or. RRCStat='593' .or. RRCStat='594' .or. RRCStat='595' .or. RRCStat='596' .or. RRCStat='597' .or. RRCStat='598'  .or. RRCStat='599' .or. RRCStat='601' .or. RRCStat='602' .or. RRCStat='603' .or. RRCStat='604' .or. RRCStat='605' .or. RRCStat='606' .or. RRCStat='607' .or. RRCStat='608' .or. RRCStat='609' .or. RRCStat='610' .or. RRCStat='611' .or. RRCStat='612' .or. RRCStat='613' .or. RRCStat='614' .or. RRCStat='615' .or. RRCStat='616' .or. RRCStat='617' .or. RRCStat='618' .or. RRCStat='619' .or. RRCStat='620' .or. RRCStat='621' .or. RRCStat='622' .or. RRCStat='623' .or. RRCStat='624' .or. RRCStat='625' .or. RRCStat='626' .or. RRCStat='627' .or. RRCStat='628' .or. RRCStat='629' .or. RRCStat='630' .or. RRCStat='631'  .or. RRCStat='632' .or. RRCStat='634' .or. RRCStat='635' .or. RRCStat='650' .or. RRCStat='651' .or. RRCStat='653' .or. RRCStat='654' .or. RRCStat='655' .or. RRCStat='656' .or. RRCStat='657' .or. RRCStat='658' .or. RRCStat='660' .or. RRCStat='661' .or. RRCStat='662'  .or. RRCStat='663' .or. RRCStat='678' .or. RRCStat='679' .or. RRCStat='680' .or. RRCStat='681' .or. RRCStat='682' .or. RRCStat='683' .or. RRCStat='684' .or. RRCStat='685' .or. RRCStat='686' .or. RRCStat='687' .or. RRCStat='688' .or. RRCStat='689' .or. RRCStat='690' .or. RRCStat='691' .or. RRCStat='700'  .or. RRCStat='701' .or. RRCStat='702' .or. RRCStat='703' .or. RRCStat='704' .or. RRCStat='705' .or. RRCStat='706' .or. RRCStat='707' .or. RRCStat='708' .or. RRCStat='709' .or. RRCStat='710' .or. RRCStat='711' .or. RRCStat='712' .or. RRCStat='713' .or. RRCStat='714' .or. RRCStat='715' .or. RRCStat='716' .or. RRCStat='717' .or. RRCStat='718' .or. RRCStat='719' .or. RRCStat='720' .or. RRCStat='721' .or. RRCStat='723' .or. RRCStat='724' .or. RRCStat='725' .or. RRCStat='726' .or. RRCStat='727' .or. RRCStat='728' .or. RRCStat='729' .or. RRCStat='730' .or. RRCStat='731' .or. RRCStat='732' .or. RRCStat='733'   .or. RRCStat='734' .or. RRCStat='735' .or. RRCStat='736' .or. RRCStat='737' .or. RRCStat='738' .or. RRCStat='739' .or. RRCStat='740' .or. RRCStat='741' .or. RRCStat='742' .or. RRCStat='743' .or. RRCStat='745' .or. RRCStat='746' .or. RRCStat='748' .or. RRCStat='749' .or. RRCStat='750' .or. RRCStat='751' .or. RRCStat='752' .or. RRCStat='753' .or. RRCStat='754' .or. RRCStat='755' .or. RRCStat='756' .or. RRCStat='757' .or. RRCStat='758' .or. RRCStat='759' .or. RRCStat='760' .or. RRCStat='762' .or. RRCStat='763' .or. RRCStat='764' .or. RRCStat='765' .or. RRCStat='766' .or. RRCStat='767' .or. RRCStat='768'  .or. RRCStat='769' .or. RRCStat='770' .or. RRCStat='771' .or. RRCStat='772' .or. RRCStat='773' .or. RRCStat='774' .or. RRCStat='775' .or. RRCStat='776' .or. RRCStat='777' .or. RRCStat='778' .or. RRCStat='779' .or. RRCStat='780' .or. RRCStat='781' .or. RRCStat='782' .or. RRCStat='783' .or. RRCStat='784' .or. RRCStat='785' .or. RRCStat='786' .or. RRCStat='787' .or. RRCStat='788' .or. RRCStat='789' .or. RRCStat='790' .or. RRCStat='791' .or. RRCStat='792' .or. RRCStat='793' .or. RRCStat='794' .or. RRCStat='795' .or. RRCStat='796' .or. RRCStat='999' 
msginfo("ATEN�AO TENTE REFAZER O PROCESSO"+ CRLF +C_XMotivo)

  cQuery:= "DELETE FROM nfe20  WHERE CHAVE = " + AllTrim(xchavenfce)         
    oQuery:=oServer:Query( cQuery )
    oQuery:Destroy()			 																			
  * MsgInfo("Registro deletado!")


xvvNFE=vvNFE-1
 cQuery := "UPDATE nfe20 SET CbdNtfNumero  ='"+NTRIM(xvvNFE)+"' WHERE CbdNtfNumero = "+NTRIM(vvNFE)+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+ntrim(Serie_nfe)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro linha 3192 PROPLEMA")
Endif
endif



///////////////////////////////////////////
***  SE DEU ERRO VOLTA O NUMERO ***********
///////////////////////////////////////////

MY_WAIT( 1 ) 
cDestino:="C:\ACBrMonitorplus\sai.txt"	
  lRetStatus:=EsperaResposta(cDestino)

if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
      MSGINFO(memoread("Aten��o Favor refazer o Processo   "+cDestino))
 xvvNFE=vvNFE-1
 cQuery := "UPDATE nfe20 SET CbdNtfNumero  ='"+NTRIM(xvvNFE)+"' WHERE CbdNtfNumero = "+NTRIM(vvNFE)+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+ntrim(Serie_nfe)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro linha 3192 PROPLEMA")
Endif
ENDIF

////////////////////////////////
***  TUDO CERTO VAMOS EMBORA
///////////////////////////////

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
ffxml:=memoread(ARQEVENTO)
*MSGINFO(ARQEVENTO)
cRet := MON_ENV("NFE.ImprimirDanfe("+ARQEVENTO+")")
*cRet  := MON_ENV("NFE.ImprimirDanfe("+ARQEVENTO+",1,1,0,1)")
*MSGINFO(cRet)
MY_WAIT( 1 ) 

cCFileDanfe    :=c_CFileDanfe
PathNFE:=cCFileDanfe+"\"+"NFE"+"\"+xANO+"\"+"NFE"+"\"
ARQEVENTO:=PathNFE+cChNFe+"-nfe.XML"
ffxml:=memoread(ARQEVENTO)
ffxml:=memoread(ARQEVENTO)
     cQuery	:= oServer:Query( "UPDATE nfe20 SET CbdvProd_ttlnfe='"+cCbdvProd_ttlnfe+"',CbdvDesc_cob='"+cCbdvDesc_cob+"',CbdxNome_dest='"+CCbdxNome_dest+"' ,CbdvNF='"+cCbdvNF+"',AUTORIZACAO='"+CNPROT+"',nt_retorno='"+(AllTrim(ffxml))+"',CHAVE='"+AllTrim(xchavenfce)+"' WHERE CbdNtfNumero = " +vNFE)
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 4332  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
 *MSGINFO('OK')
EndIf

cEnviaPDF:="1"
ZERA_NFE()
eemail         :=ALLTRIM(nfe.Txt_email.value)
cEmailDestino  :=ALLTRIM(nfe.Txt_email.value)

If !Empty(eemail)
cRet       := MON_ENV("NFe.EnviarEmail("+cEmailDestino+","+alltrim(ARQEVENTO)+","+cEnviaPDF+")")
ELSE
*MSGINFO("NAO TEM")
ENDIF
GRAVA_nfe1()
ELSE
MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
vvSeq:=NFe.Txt_NOTA.VALUE


SELE SEQ_NFE
  If LockReg()  
		              SEQ_NFE-> SEQNFE :=vvSeq
				      SEQ_NFE->(dbcommit())
                      SEQ_NFE->(dbunlock())
	                Unlock
		          ENDIF           
return(.f.)
endif
SAIR_nfeh()
return




//------------------------------------------------------------------
STATIC FUNCTION SAIR_nfeh
//---------------------------------------------
NFE.RELEASE
*status_email.release 
RETURN 






STATIC FUNCTION ZERA_NFE()

abreseq_nfe()

                     SELE NFCE 
                    If LockReg()  
                       NFCE->NUM_SEQ :=0
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                 Unlock
                 ENDIF   
				
				
                     SELE SEQ_NFE
                       If LockReg()  
                       SEQ_NFE-> ABERTO  :=""
                       SEQ_NFE->(dbcommit())
                       SEQ_NFE->(dbunlock())
				   Unlock
                 ENDIF   
RETURN

	






//------------------------------------------------------------------
STATIC FUNCTION SAIR_nfe
//---------------------------------------------
NFE.RELEASE
SAIR_nfCe()
RETURN 



static Function ProcedureescreverINI()
     cDestino := "C:\ACBrMonitorPLUS\ACBrMonitor.INI"
	lRetStatus:=EsperaResposta(cDestino) 
		BEGIN INI FILE cDestino
      SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '1'
    END INI
	MY_WAIT( 3 )    
	ProcedureLerINI()
return
	
	
	
//---------------------
Function GRAVA_nfe1
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
local cPedido        :=DADOSNFE->num_seq
LOCAL C_CFOP         :=nfe.textBTN_cfop.value
LOCAL C_CODIGO       :=NFE.textBTN_cliente.VALUE
private mCFOP        :='',mCbdnatOp:='',mCbdtpEmis:=1,mCbdfinNFe:=1
private mPEDIDO      :="",aFormaPagamento:=0,nEmail:=''
cPedido              := DADOSNFE->num_seq
registro:=0
nNumeroOrc := cPedido
 
sele ITEMNFE
OrdSetFocus('DESCRICAO')
GO Top
ITEMNFE->(dbskip(-1))

do while !ITEMNFE->(eof())
*If  ITEMNFE->NSeq_Orc == nNumeroOrc
SELE ITEMNFE
registro:=registro+1
     xCbdEmpCodigo       := (mgCODIGO)
  	 xCbdNtfNumero      := ntrim(cPedido)
	*xCbdNtfSerie       := serie_nfe 
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
	 xcbdxped_item      :=ntrim(ITEMNFE->SEQ_T)
   	 xcbdindtot         := 1
      cQuery :="INSERT INTO nfeitem (CbdcEAN,cbdcsittrib,CbdvAliq,CbdEmpCodigo, CbdNtfNumero,CbdNtfSerie, CbdnItem ,CbdcProd ,CbdxProd,CbdNCM ,CbdEXTIPI,Cbdgenero, CbdCFOP, CbduCOM,CbdqCOM,CbdvUnCom ,CbdvProd,CbduTrib,CbdqTrib,CbdvUnTrib,CbdnTipoItem, CbdvDesc, cbdindtot,cbdxped_item ) VALUES ('"+xCbdcEAN+"', '"+Xcbdcsittrib+"','"+XCbdvAliq+"' ,'"+alltrim(str(xCbdEmpCodigo ))+"' , '"+xCbdNtfNumero+ "', '"+alltrim(str(Serie_nfe))+ "', '"+alltrim(str(xCbdnItem))+ "', '"+alltrim((xCbdcProd))+ "', '"+alltrim(xCbdxProd)+"','"+xCbdNCM+"','"+xCbdEXTIPI+"','"+alltrim(str(xCbdgenero))+"','"+alltrim(str(xCbdCFOP))+"','"+ xCbduCOM+"','"+alltrim(str(xCbdqCOM))+"','"+alltrim(str(xCbdvUnCom))+"','"+alltrim(str(xCbdvProd))+"','"+alltrim(xCbduTrib)+"','"+alltrim(str(xCbdqTrib))+"','"+alltrim(str(xCbdvUnTrib))+"','"+alltrim(str(xCbdnTipoItem))+"','"+alltrim(str( xCbdvDesc))+"','"+alltrim(str(xcbdindtot))+"','"+xcbdxped_item+"') "
		oQuery	:= oServer:Query( cQuery )
	If oQuery:NetErr()												
      	MsgStop(cQuery:Error())
	   MsgInfo("SQL SELECT error: 3439  " + cQuery:Error())	
	  Else
	**  msginfo("ok nfeitem")
EndIf
*endif

*MSGINFO(xCbdcEAN)

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

	inst01t:= "ATEN��O PROTESTAR COM 5 DIAS DE VENCIDO";	        

	         IF nfe.oRad2.VALUE == 2 
				    MsgINFO ( 'Por Favor Defina a condi��o de pagamento como aprazo')
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
          msgexclamation('N�o ha nota fiscal lan�ada verifique','Aten��o')
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
                       boleto->inst01         :="ATEN��O PROTESTAR COM 5 DIAS DE VENCIDO"
                 	   boleto->inst02         :=CcInstr
				       boleto->inst03         :="ATEN��O N�O RECEBER VALOR A MENOR"
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




// Fim da fun��o de gerar tela de splash ------------------------------------.
// --------------------------------------------------------------------------.
FUNCTION ENVIAR_NFE_class()
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

Xml:=alltrim(zNUMERO+xxANO+"-NFE")
pdf:=alltrim(zNUMERO+xxANO+"-pdf")
         cSubDir := DiskName()+":\"+CurDir()+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
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
	
	
 * msginfo(cSubDir)
   
   
   
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
   oNFe:versaoDados := '3.10'  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=DiskName()+":\"+CurDir() 
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:= path:=+'\NFC-E-v-3-plus-4.00\NOTA.TXT'
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
						
*	MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML ENVIADO.:' + xchavenfce  
oSefaz:NFeLoteEnvia( @cXml, '1', 'RO', ALLTRIM(cCertificado), cAmbiente )
hbNFeDaNFe( oSefaz:cXmlAutorizado )
IF oSefaz:cStatus $ "100,102"

   hbNFeDaNFe( oSefaz:cXmlAutorizado )
   hb_MemoWrit( cSubDir+cXmlAutorizado, oSefaz:cXmlAutorizado )
   hb_MemoWrit( "cXmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "cXmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   ffxml   := Memoread(cXmlAutorizado)
   
   
  CNPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
 
*MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML AUTORIZADO..:' + C_XMotivo 
* MODIFY CONTROL gerando_xml OF nfe  VALUE   'PROTOCOLO..:' +  CNPROT

                        SetProperty('nfe','gerando_xml1','Value','PROTOCOLO..:' +  CNPROT)
                        SetProperty('NFE','gerando_xml1','BLINK',.F.)
						


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
				

oPDF := hbnfeDaNfe():New()
oDanfe := hbNFeDaGeral():New()
oPDF:SetEanOff()
oDanfe:ToPDF(  Memoread( cXml ) ,PdfbDir+ xcha+".pdf" )
cpdf:=PdfbDir+xcha+".pdf" 
PDFOpen(cpdf)


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
	
GRAVA_nfe1()



*MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
vvSeq:=NFe.Txt_NOTA.VALUE
ZERA_NFE()
SELE SEQ_NFE
  If LockReg()  
		              SEQ_NFE-> SEQNFE :=vvSeq
				      SEQ_NFE->(dbcommit())
                      SEQ_NFE->(dbunlock())
	                Unlock
		          ENDIF           
return(.f.)
SAIR_nfeh()
retur



