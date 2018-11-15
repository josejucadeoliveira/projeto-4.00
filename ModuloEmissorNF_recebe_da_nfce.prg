// Harbour MiniGUI                 
// (c)2011 -José juca 
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
abreseq_nfeD()


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
   
USE ((ondeTEMP)+"SEQ_NFED.DBF") new alias SEQ_NFED exclusive   
  
IF SEQ_NFED->SEQNFE=0
close all 
USE ((ondetemp)+"SEQ_NFED.DBF") new alias SEQ_NFED exclusive    // arquivo que vai ter todo o conteudo do TXT
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
abreseq_nfeD()


oQuery  :=oServer:Query( "SELECT max(CbdNtfNumero) FROM NFE20 WHERE cbdmod= "+"55"+" and CbdNtfSerie = "+ntrim(Serie_nfe)+"  Order By CbdNtfNumero" )
oRow := oQuery:GetRow(1)
oRow          := oQuery:GetRow(1)
C_CbdNtfNumero:=((oRow:fieldGet(1)))
C_CbdNtfNumero:=C_CbdNtfNumero+1 

 SELE SEQ_NFED
C_CbdNtfNumero:=C_CbdNtfNumero+SEQ_NFED->SEQNFE

	
	
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
            OPTIONS {'Cupom','Davs/Orc','Devolução' ,'Conserto','Outras'}
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
        HEADERS {'Itens','Codigo','Descrição','Ncm','Und.','Qtd','Valor R$','Desc.R$','Sub-Total R$','%Icms','STB','CFOP','ICMS','CEST' };
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
			  HEIGHT 40;
		     ACTION {||boleto_salvap(),Refresh_boleto(),geranosso()}
     

	
	
		 
	   	   @ 320,150 BUTTON   btgera  ;
		   CAPTION "Gerar boleto";  
		   FONT "Cambria";
		   SIZE 12 BOLD ;
		   WIDTH 110 ;
		   HEIGHT 40 ;
	       ACTION {|| multiimpressao()}
	  

	
         @ 320,280 BUTTON Excluir ;
		   CAPTION "Excluir";  
		   FONT "Cambria";
		   SIZE 12 BOLD ;
		   WIDTH 110 ;
		  HEIGHT 40 ;
	   ACTION ( DELETE_BOLETO(),Refresh_boleto()  ) 
		  
		   
  END PAGE

  
                END TAB
				
                @ 600,010 LABEL    LabelPesoLiq        VALUE "Peso Liquido"      AUTOSIZE
                @ 600,130 LABEL    LabelPesoBru        VALUE "Peso Bruto"        AUTOSIZE
                @ 600,250 LABEL    LabelVolumes        VALUE "Volumes"           AUTOSIZE
                @ 600,330 LABEL    LabelSubTotal       VALUE "Sub Total"         AUTOSIZE
                @ 600,430 LABEL    LabelDesTotal1      VALUE "Descontos %"       AUTOSIZE 
				@ 600,530 LABEL    LabelDesTotal       VALUE "Descontos R$"      AUTOSIZE
                @ 600,650 LABEL    LabelGerTotal       VALUE "Total nfe"         AUTOSIZE
                @ 600,770 LABEL    LabelICMTotal       VALUE "Total ICMS"        AUTOSIZE
                @ 600,890 LABEL    LabelPISTotal       VALUE "Total IPI"         AUTOSIZE

                @ 620,010 TEXTBOX  tPesoLiq            VALUE 0.000        WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "99,999.999" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,130 TEXTBOX  tPesoBru            VALUE 0.000        WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "99,999.999" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,250 TEXTBOX  tVolumes            VALUE 0            WIDTH 60  HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999"         ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,330 TEXTBOX  Txt_total            VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,430 TEXTBOX  Txt_desconto1       VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,530 TEXTBOX  Txt_desconto        VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
             
 			 @ 620,650 TEXTBOX  Txt_valortotal;
			 VALUE 0.00  ;
			 WIDTH 100;
			 HEIGHT 28;
			 BOLD BACKCOLOR {191,225,255};
			 NUMERIC INPUTMASK "999,999.99";
			 ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP

  			    @ 620,770 TEXTBOX  tValorICMS          VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 620,890 TEXTBOX  tValorIPI           VALUE 0.00         WIDTH 100 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NUMERIC INPUTMASK "999,999.99" FORMAT "E" ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS setControl(.F.) NOTABSTOP
                @ 650,005 BUTTON   btGravar           CAPTION "Gera Nfe"           FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION {||nfe.btGravar.Enabled := .f.,gravavda_CLI(),GRAVAENVIA2(),SAIR_nfe() }
                @ 650,136 BUTTON   btExcluir           CAPTION "Exclui Itens"      FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION  wn_excluiitem()
     			@ 650,880 BUTTON   btCancelar          CAPTION "Voltar"            FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION nfe.Release
         *      ON KEY ESCAPE ACTION nfe.Release
         END WINDOW
  CENTER WINDOW nfe
ACTIVATE WINDOW nfe
endif
Return 

 	  
	  
	  
	  
FUNCTION DisableAllButtons()
    gravavda_CLI()
	GRAVAENVIA2()
*GRAVA_nfe1()
    SAIR_nfe()
  RETURN NIL
	  
	  
	  
	  
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
else

 	  cQuery := "INSERT INTO  peganfe (CbdNtfNumero) VALUES ('"+C_CbdNtfNumero+"')" 
 	   	 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
	*	msginfo("ok")
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
 +"Valor crédito do ICMS        "     +   TOTALICMS       + "          aliquota De      " +  NTOTAL  +  "   pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)" +   "  " +LIN_21
endif

//NFE.Edit_Aplicacao.VALUE:="Valor crédito do ICMS        "     +   TOTALICMS       + "          aliquota De      " +  NTOTAL  + "%"+ "   pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)"

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
                        *ITEMNFE->NSEQ_ORC      := ITEMNFcE->NSEQ_ORC  
						ITEMNFE->NSEQ_ORC       := NFe.Txt_NOTA.VALUE
						ITEMNFE->ncm            := ITEMNFcE->ncm
		             	ITEMNFE->qtd            := ITEMNFcE->qtd  
                        ITEMNFE->quant          := ITEMNFcE->quant 
                        ITEMNFE->valor          := ITEMNFcE->valor
                        ITEMNFE->preco          := ITEMNFcE->preco
                        ITEMNFE->unid           := ITEMNFcE->unid   
					 	ITEMNFE->cfop           := ITEMNFcE->cfop 
						ITEMNFE->aliquota       := ITEMNFcE->aliquota
						ITEMNFE->total          := ITEMNFCE->total
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
		   
		   
		  * DADOSNFE->num_seq
				 	if (!EOF())
                    If LockReg()  
		               DADOSNFE-> NUM_SEQ    :=NFe.Txt_NOTA.VALUE
					   DADOSNFE-> DATA_ORC   :=NFCE-> DATA_ORC
                       DADOSNFE-> COD_CLI    :=NFCE-> COD_CLI
                       DADOSNFE-> NOM_CLI    :=NFCE-> NOM_CLI
                       DADOSNFE-> CL_CGC     :=NFCE-> CL_CGC 
                       DADOSNFE-> RGIE       :=NFCE-> RGIE
                       DADOSNFE->CL_END      :=NFCE->CL_END 
                       DADOSNFE-> CL_ISENTO  :=NFCE-> CL_PESSOA
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
	   	               DADOSNFE-> NUM_SEQ    :=NFe.Txt_NOTA.VALUE
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
					   DADOSNFE-> TROCO      :=NFCE-> TROCO
					
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
            VALUE "Endereço Cidade estado"
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



IF nfe.oRad3.VALUE == 5  /// vai nfce 
*IF  C_UF=="RO" .and. xCbdvAliq=0
*XCbdCFOP:=5949
*xst     :="500" 
*xstb    :=500 
*ELSEIF C_UF=="RO" 
xCbdCFOP:=5949
xst     :="101" 
xstb    :=101 
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
*private mPEDIDO:="",aFormaPagamento:=0,nEmail:=''
public path :=DiskName()+":\"+CurDir()
xxxx:=1
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
xXTROCO:=0
NTOTAL   :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')
vv_total :=(DADOSNFE->VALOR_TOT)
TOTALICMS:=vv_total*DADOSNFE->ALIQUOTA/100
VV_VALOR:=DADOSNFE->TOTAL_IMP/Vv_total*100
 
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
	   if  empty(DADOSNFE->RGIE) .or. DADOSNFE->RGIE='ISENTO' .or. DADOSNFE->RGIE='0' 
		 elseif empty(mInscricaoEstadual)
	       mInscricaoEstadual:='ISENTO'
		 if mEstado_Destinatario=='AM' .or. mEstado_Destinatario=='BA' .or. mEstado_Destinatario=='CE' .or. mEstado_Destinatario=='GO' .or. mEstado_Destinatario=='MG' .or. mEstado_Destinatario=='MS' .or. mEstado_Destinatario=='MT' .or. mEstado_Destinatario=='PE' .or. mEstado_Destinatario=='RN' .or. mEstado_Destinatario=='SE' .or. mEstado_Destinatario=='SP'  
 	       	mindIEDest:='9'
	     	mgindFinal:='0'
		      	else
	       mindIEDest:='9'
       	end
		end
	endif	

	
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
          mgCODIGO       :=1
	     mgCODIGO       :=alltrim(str(mgCODIGO))
		 
	      DADOS_NFe:={}
		  aadd(DADOS_NFe,{'NFE.CriarEnviarNFe'})
		  aadd(DADOS_NFe,{'[infNFe]'})
		 aadd(DADOS_NFe,{'infNFe='+XVERSAONFCE})
		 aadd(DADOS_NFe,{'[Identificacao]'})
		 aadd(DADOS_NFe,{'NaturezaOperacao='+Natu})
		 aadd(DADOS_NFe,{'Modelo=55'})
	     aadd(DADOS_NFe,{'Codigo='+mgCODIGO})
		 aadd(DADOS_NFe,{'Numero='+C_CbdNtfNumero})
	
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
         aadd(DADOS_NFe,{'indPres=1'})  /// Indicador de presença do comprador no estabelecimento comercial no momento da operação 
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
// gravaçoes  destinatarios

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
XValor_DESC:=Round (XValor_DESC,2)
 
        registro              :=registro+1
        M->CbdvCredICMSSN     := 0
		NTOTAL                :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')
	    M->CbdvCredICMSSN     :=ITEMNFE->UNIT_DESC*C_ALIQUOTA/100
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
		 aadd(DADOS_NFe,{'Codigo =' +strzero(ITEMNFE->cod_prod,13) })
		 
		 
if substr(ITEMNFE->PRODUTO,0,3)=='789' 
	   aadd(DADOS_NFe,{'cEANTrib=' +ALLTRIM(ITEMNFE->PRODUTO) })
	   aadd(DADOS_NFe,{'EAN=     ' +ALLTRIM(ITEMNFE->PRODUTO) })
     else
       aadd(DADOS_NFe,{'cEANTrib='+("SEM GTIN ")})
       aadd(DADOS_NFe,{'EAN='     +("SEM GTIN ")})
    endif

		
		 
	 	 aadd(DADOS_NFe,{'Descricao=' +Alltrim(ITEMNFE->DESCRICAO) })
	 	 aadd(DADOS_NFe,{'indAdProd='   +ALLTRIM(xindAdProd )})
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
         aadd(DADOS_NFe,{'[ICMS'+strzero(registro,3)+']' })
		
   xICMS:='ICMSSN'
  	IF  mindIEDest=='2'  //nao permite aproveitamento de credito para pessoa fisica
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
* endif
 

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
 
DESCONTO_X:=DESCONTO_X+ITEMNFE->SubTotal*DADOSNFE->DESC1/100
VV_IBPT:=VV_IBPT+ITEMNFE->N_IBPT+ITEMNFE->m_IBPT+ITEMNFE->E_IBPT
DESCONTO_X:=Round (DESCONTO_X,2)

ITEMNFE->(dbskip())
ENDD  
*MSGINFO(DESCONTO_X)

         // Total da nota
	   
			nTotal_Itens   :=DADOSNFE-> VALOR_TOT 
			nTotalBase     :=DADOSNFE-> VALOR_TOT -DESCONTO_X
			mValor_Desconto:=DESCONTO_X
			nImpostos_Cupom:=DADOSNFE->TOTAL_IMP
			xXTROCO        :=DADOSNFE-> TROCO 
			mValor_Frete   :=0
			nTotal_ICMS    :=0
			nTotalBaseA    :=0
			nTotal_BaseST  :=0
			nIcms_ST       :=0
			mValor_IPI     :=0
			nTotal_Pis     :=0
			nTotal_Cofins  :=0
	       mValor_Desconto:=Round (mValor_Desconto,2)
	
	    aadd(DADOS_NFe,{'[Total]' })
        aadd(DADOS_NFe,{'BaseICMSSubstituicao='+ALLTRIM(TRANSFORM((nTotal_BaseST),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorICMSSubstituicao='+ALLTRIM(TRANSFORM((nIcms_ST),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorProduto='+ALLTRIM(TRANSFORM((nTotal_Itens),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorNota='+ALLTRIM(TRANSFORM((nTotalBase),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorDesconto='+ALLTRIM(TRANSFORM((mValor_Desconto),"@! 999999999999.99999")) })
        aadd(DADOS_NFe,{'ValorIPI='+ALLTRIM(TRANSFORM((mValor_IPI),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorPIS='+ALLTRIM(TRANSFORM((nTotal_Pis),"@! 999999999999.99")) })
        aadd(DADOS_NFe,{'ValorCOFINS='+ALLTRIM(TRANSFORM((nTotal_Cofins),"@! 999999999999.99")) })
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

abreserienfce()
SELE serienfce             
xCbdNtfSerie := NTRIM(serienfce->serie)
CbdNtfSerie  := serienfce->serie

vdata1       :=dtos(DATE())
xtpIntegra:='2'
tt=0
abreFORMA()
GO TOP
OrdSetFocus('codigo')
Do While ! forma->(Eof())
nFormaDePagamento   :=FORMA->codigo
  if FORMA->VALOR<1
      forma->(dbskip())
    loop
   end if
MTOTALForma:=0
 
 
 IF nfe.oRad2.VALUE == 1 
*	 aadd(DADOS_NFe,{'indPag=1'})
xindPag=1	 
     ELSE
*	 aadd(DADOS_NFe,{'indPag=0'})
xindPag=0
 ENDIF

 
	IF  nFormaDePagamento=1
	tt++
		xtPag:='01'
		 MTOTALForma :=FORMA->VALOR
   	    MDESCRICAO  :=FORMA->DESCRICAO
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
     	 aadd(DADOS_NFe,{'indPag='+(strzero(xindPag))})		
        aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
		aadd(DADOS_NFe,{'vTroco='+TRANSFORM(xXTROCO,"@! 99999999.99") })	

		
//****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
elseif  nFormaDePagamento==2
	tt++
		MTOTALForma      :=FORMA->VALOR-xXTROCO
  	    MDESCRICAO       :=FORMA->DESCRICAO
	
		xtPag:='02'
        aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })
	

//****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
		
	elseif  nFormaDePagamento=3
	tt++
		xtPag:='03'
		MTOTALForma      :=FORMA->VALOR-xXTROCO
 	    MDESCRICAO  :=FORMA->DESCRICAO

		aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
	     aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
	
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
		
	elseif  nFormaDePagamento==4
		tt++
		MTOTALForma      :=FORMA->VALOR-xXTROCO
        MDESCRICAO       :=FORMA->DESCRICAO

		xtPag:='04'
        aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
**********		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()

elseif  nFormaDePagamento==5
		tt++
		MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO

		xtPag:='05'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
   	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
	 //****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
 
 
 
elseif  nFormaDePagamento==10
		tt++
		MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO

		xtPag:='10'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
   	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
	 
   //****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
 
 
 
elseif  nFormaDePagamento==11
		tt++
		MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO

		xtPag:='11'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
   	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
	 
  //****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
 
 
 
elseif  nFormaDePagamento==12
		tt++
		MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO

		xtPag:='12'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
   	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
	 
  //****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
 
 
elseif  nFormaDePagamento==13
		tt++
		MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO

		xtPag:='13'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
   	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
	//****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
 
 
elseif  nFormaDePagamento==14
		tt++
		MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO

		xtPag:='14'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
        aadd(DADOS_NFe,{'indPag='+(strzero(xindPag,1))})		
       aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
 
 
 
elseif  nFormaDePagamento==15
		tt++
		MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO

		xtPag:='15'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
   	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		
//****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
 
 
 
elseif  nFormaDePagamento==90
		tt++
		MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO

		xtPag:='90'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
   	    aadd(DADOS_NFe,{'tpIntegra='+(xtpIntegra)})		

//****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma

cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
 
 
 
elseif  nFormaDePagamento==99
		tt++
		MTOTALForma :=FORMA->VALOR
    * 	MTOTALForma :=FORMA->VALOR-xXTROCO
        MDESCRICAO  :=FORMA->DESCRICAO
		xtPag:='99'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTALForma,"@! 99999999.99") })	
	 	aadd(DADOS_NFe,{'vTroco='+TRANSFORM(xXTROCO,"@! 99999999.99") })	
//****************		
oQuery  :=oServer:Query( "SELECT venda_dia FROM abcaixa WHERE ab_data = "+vdata1+" AND caixa = "+(xCbdNtfSerie)+"  and cod_pag ="+alltrim(xtPag)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
  xvenda_dia      :=oRow:fieldGet(1)
  XVENDA_DIA      :=XVENDA_DIA+MTOTALForma
cQuery := "UPDATE abcaixa SET venda_dia ='"+ntrim(XVENDA_DIA)+"' WHERE  ab_data = "+vdata1+"  AND caixa = "+(xCbdNtfSerie)+" and cod_pag ="+(xtPag)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 3077 PROPLEMA")
    Return Nil
  Endif
oQuery:Destroy()
ENDIF
MTOTALForma:=0
FORMA->(dbskip())
ENDDO
	 
mValor_Desconto:=mValor_Desconto
 
 
   IF nfe.oRad2.VALUE == 1 
	     aadd(DADOS_NFe,{'[Fatura]'})
   	     aadd(DADOS_NFe,{'Numero=     '+c_CbdNtfNumero})
		 aadd(DADOS_NFe,{'ValorOriginal='+ALLTRIM(TRANSFORM((nTotal_Itens ),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'vDesc='+ALLTRIM(TRANSFORM((mValor_Desconto ),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorLiquido='+ALLTRIM(TRANSFORM((nTotal_Itens-mValor_Desconto),"@! 999999999999.99")) })
        Sele boleto
OrdSetFocus('vencimento')
xDup:=1
GO Top
do while !boleto->(eof())

			    aadd(DADOS_NFe,{'[Duplicata'+strzero(xDup,3)+']' })
			*	aadd(DADOS_NFe,{'Numero='+(c_CbdNtfNumero)+'-'+strzero(xDup,2)})
			* 	aadd(DADOS_NFe,{'nDup='+(c_CbdNtfNumero)+'-'+strzero(xDup,3)})
				aadd(DADOS_NFe,{'nDup=     '+strzero(xDup,3)})
				aadd(DADOS_NFe,{'DataVencimento='+dtoc(boleto->vcto)})
				aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM((boleto->valor),"@! 9999999999.999"))}) 
		
	xDup++
	
 dbskip()
enddo
ENDIF
	
xQTD_VOLUMES:=NFE.tVolumes.VALUE
m->Cbdesp   :=""
xMarca      :="" 
xNUMERO_VOL :=NTRIM(NFE.tVolumes.VALUE)
xPESOBRUTO  :=NFE.tPesoBru.VALUE 
xPESOLIQ    :=NFE.tPesoLiq.VALUE
Serie_nfe   :=VAL(NFE.Txt_SERIE.VALUE)

 xCbdinfCpl	  	 	  := NFE.Edit_Aplicacao.VALUE +"   "+NFE.Edit_Aplicacao_2.VALUE  

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
abreseq_nfe()
abreNFCE()
abreseq_dav()
IF   GERA_NFE_NFCE=1
*ENVIAR_NFE()
ENVIAR_NFE_ACBR()
ELSE 
ENVIAR_NFE_class()
ENDIF 
RETURN
	






//------------------------------------------------------------------
FUNCTION SAIR_nfe
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
*private mPEDIDO      :="",aFormaPagamento:=0,nEmail:=''
cPedido              := DADOSNFE->num_seq
registro:=0
nNumeroOrc := cPedido
 
sele ITEMNFE
OrdSetFocus('DESCRICAO')
GO Top
ITEMNFE->(dbskip(-1))
do while !ITEMNFE->(eof())
SELE ITEMNFE
FOR nLoop2 := 1 TO ITEMNFE->ITENS
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
  Return Nil
  else
Endif
	
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
   descricaogrande:=oRow:fieldGet(2)
   unidadefdcx    :=oRow:fieldGet(3)   
   sst            :=oRow:fieldGet(4)
   cncm           :=oRow:fieldGet(5)
   ccst           :=oRow:fieldGet(6) 
   XICMS          :=oRow:fieldGet(10)
   Xicms          :=TransForm(Xicms,"99")
   Aqtd           :=(oRow:fieldGet(7))
 
   if Aqtd< 1
   Aqtd:=xCbdqCOM
   endif
  
 
TOTAL_QTD         :=aqtd-xCbdqCOM
xcncm             :=VAL(cncm)
IF Xcncm=0
cncm:="48059100"
ELSE
cncm             :=cncm  
ENDIF

 * Log_vendanfe_55(xCbdcEAN, +"       Quantidade Vendidade          " ,+  ntrim( xCbdqCOM))
   Log_vendanfe_55(xCbdcEAN, +"       Quantidade Vendidade          " ,+  ntrim(xCbdqCOM) +"   Produtos..:" + alltrim(descricaogrande))
    
  TOTAL_QTD         :=aqtd-xCbdqCOM
  * Log_vendanfe_55(xCbdcEAN  , +"  Quantidade em Estoque             " ,+  ntrim(Aqtd))
    Log_vendanfe_55(xCbdcEAN,  +"       Quantidade em Estoque             " ,+  ntrim(Aqtd) )
   oQuery:Destroy()

cQuery := "UPDATE PRODUTOS SET NCM ='"+CNCM+"',qtd ='"+NTRIM(TOTAL_QTD)+"' WHERE CODBAR = " + AllTrim(xCbdcEAN)
 eQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  Return Nil
  else
  
    Log_vendanfe_55(xCbdcEAN,  +"       Quantidade Atualizado no DB          " ,+  ntrim( TOTAL_QTD))
    Log_vendanfe_55((xCbdNtfNumero)+"  itens Vendido  "+ntrim(nLoop2),+" ================================================================================ " ,+  "")

Endif
ITEMNFE->(dbskip())
Next
eQuery:Destroy()
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




// Fim da fun‡Æo de gerar tela de splash ------------------------------------.
// --------------------------------------------------------------------------.
FUNCTION ENVIAR_NFE_class()
LOCAL nOpc := 1, GetList := {}, cTexto := "", nOpcTemp
LOCAL cCnpj := Space(14), cChave := Space(44), cCertificado := "", cUF := "RO", cXmlRetorno
LOCAL oSefaz, cXml, oDanfe, cTempFile, nHandle
LOCAL i, j, aSubDir, nfeSubDir, nError,nfePdfbDir
lOCAL aNewDir := { "temp" }
local xdia := strzero(day(date() ),2 )
   
cCertificado:=''

Criadir_nfe()
   
zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFE")
pdf   :=alltrim(zNUMERO+xxANO+"-pdf")
tmp  :=alltrim(zNUMERO+xxANO+"-tmp")

   
         nfeSubDir   := DiskName()+":\"+CurDir()+"\"+"NFe"+"\"+xml+"\"
  		 nError      := MakeDir( nfeSubDir )
         nfeSubDirTMP:= DiskName()+":\"+CurDir()+"\"+"NFe"+"\"+tmp+"\"
  		 nError      := MakeDir( nfeSubDirTMP )
         nfePdfbDir  := DiskName()+":\"+CurDir()+"\"+"NFe"+"\"+pdf+"\"
  		 nError      := MakeDir( nfePdfbDir )	
	


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
 
 
if cambiente='1'
 ambiente:="Produção"
 else
   ambiente:="Homologação"
 endif
 
HB_Cria_Log_nfe(xcStat,xxmotivo+"  Amb.:"+ambiente)
 
if xcStat="107"
*  	  MsgInfo("Serviço ok")
     else 
  	  MsgInfo("ATENÇÃO SEM SERVIDOR NO SISTEMA NACIONAL DE RECEPÇÃO DE NFES" +CRLF + xxmotivo )
return .F. 
ENDIF


vNFE:=NFe.Txt_NOTA.VALUE
numeronfe    :=NFe.Txt_NOTA.VALUE
path:=DiskName()+":\"+CurDir() 
   oNfe := hbNfe()
   oNFe:cUFWS := '11' // UF WebService
   oNFe:tpAmb := nfe.Txt_Ambiente.value // Tipo de Ambiente 1=producao 2 homologacao
   oNFe:versaoDados := XVERSAONFCE   ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=nfeSubDirTMP
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:= path:=+'\NFC-E-v-3-plus-4.00\NOTA.TXT'
   oIniToXML := hbNFeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oNfe:cPastaSchemas :=DiskName()+":\"+CurDir()+"\"+"Schemas"
   oIniToXML:lValida := .T.
   aRetorno := oIniToXML:execute()
   oIniToXML := Nil
	xcha:=(aRetorno['cChaveNFe'])
    cTexto:=xcha+"-nfe.XML"
    oSefaz     := SefazClass():New()
    oSefaz:cUF := cUF
   cXmlAutorizado:=cTexto
   cXml:= MEMOREAD(nfeSubDirTMP+cTexto)
    XCHAVENFCE:=(aRetorno['cChaveNFe'])
   oValida := hbNFeValida()
   oValida:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML := Nil
   xchave    :=(aRetorno['cChaveNFe'])

   
   
	  if aRetorno['OK'] == .F.
   		   msginfo(aRetorno['MsgErro'])
	      return
       end  
	   
	   
	    oValida:cXML := cXml // Arquivo XML ou ConteudoXML
        aRetorno := oValida:execute()
        oValida := Nil
        IF aRetorno['OK'] == .F.
        retornox:=( aRetorno['MsgErro'])
            ELSE
         retornox :="VALIDO"
		*msginfo(retornox)
*   	HB_Cria_Log_nfe(Cnumero,cTexto+"   Retorno.:"+retornox)
	    ENDIF
	   
	
	 xCbdNtfSerie:=SUBSTR(XCHAVENFCE,23,3)
     xnumero     :=SUBSTR(XCHAVENFCE,26,9)
     zxnumero    :=val(xnumero)
	  cString     :=strzero(zxnumero,9)
      outras      :=strzero(Serie_nfe,3)
   
  
     HB_Cria_Log_nfe(cString,xchavenfce+"  Serie.:"+outras)
	 
	
	 *    MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML ENVIADO.:' + xchavenfce  
                        SetProperty('nfe','gerando_xml','Value','Processado!!!'+xchavenfce)
                        SetProperty('NFE','gerando_xml','BLINK',.F.)
						
*	MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML ENVIADO.:' + xchavenfce  
oSefaz:NFeLoteEnvia( @cXml, '1', 'RO', ALLTRIM(cCertificado), cAmbiente )
hbNFeDaNFe( oSefaz:cXmlAutorizado )
  HB_Cria_Log_nfe(cString,xchavenfce+"  cStat.:"+oSefaz:cStatus+"  "+oSefaz:cMotivo)
  
  
If oSefaz:cStatus $ [102,103,104,105,106,107,108,109,110,111,112,124,128,135,136,137,138,139,140,142,150,151,201,202,203,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,301,302,303,304,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,349,350,351,352,353,354,355,356,357,358,359,360,361,362,364,365,366,367,368,369,370,372,373,374,375,376,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,401,402,403,404,405,406,407,408,409,410,411,417,418,420,450,451,452,453,454,455,461,462,463,464,465,466,467,468,471,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,496,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,567,568,569,570,571,572,573,574,575,576,577,578,579,580,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,650,651,653,654,655,656,657,658,660,661,662,663,678,679,680,681,682,683,684,685,686,687,688,689,690,691,693,694,695,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,740,741,742,743,745,746,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,798,799,800,805,806,807,999,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879]
* MsgExclamation( "Erro " + oSefaz:cXmlRetorno )
 msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
  HB_Cria_Log_nfe(cString,xchavenfce+"  Erro.:"+oSefaz:cMotivo)	 
 return(.f.)
endif
  
  
  
IF oSefaz:cStatus $ "100,102"
   hbNFeDaNFe( oSefaz:cXmlAutorizado )
   hb_MemoWrit( nfeSubDir+cXmlAutorizado, oSefaz:cXmlAutorizado )
   hb_MemoWrit( nfePdfbDir+cXmlAutorizado, oSefaz:cXmlAutorizado )
   hb_MemoWrit( "cXmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "cXmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   ffxml   := Memoread(cXmlAutorizado)
   
   
  CNPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
 
   HB_Cria_Log_nfe(cString,xchavenfce+"  nPROT.:"+CNPROT)
   
                        SetProperty('nfe','gerando_xml1','Value','PROTOCOLO..:' +  CNPROT)
                        SetProperty('NFE','gerando_xml1','BLINK',.F.)
					

ELSE
hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo )

   IF .NOT. Empty( oSefaz:cMotivo )
    *  MsgExclamation( "Problema " + oSefaz:cMotivo )
	  msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
	  
	   HB_Cria_Log_nfe(cString,xchavenfce+"  Erro.:"+oSefaz:cMotivo)
	  
return(.f.)
   ELSE
    *  MsgExclamation( "Erro " + oSefaz:cXmlRetorno )
	  msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
	  HB_Cria_Log_nfe(cString,xchavenfce+"  Erro.:"+oSefaz:cMotivo)	 


IF oSefaz:cStatus $ "204"
	  nfe.Txt_NOTA.value:=zxnumero+1
	  nfe.Txt_NOTA.setfocus
  endif
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
cXml:=nfeSubDir+xcha+"-nfe.xml"
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
      RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
      oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  

oDanfe:ToPDF(  Memoread( cXml ) ,nfePdfbDir+ xcha+"-nfe.pdf" )
cpdf:=nfePdfbDir+xcha+"-nfe.pdf" 
PDFOpen(cpdf)
*imprimir_class(cpdf)

cXml_envia:=nfeSubDir+xcha+"-nfe.xml"
ffxml_envia   :=Memoread(cXml_envia)
ARQEVENTO     :=nfePdfbDir+xcha+"-nfe.xml"

*fDanfe('1',ARQEVENTO)

cEnviaPDF:="1"
eemail         :=ALLTRIM(nfe.Txt_email.value)
PUBLIC cEmailDestino  :=ALLTRIM(nfe.Txt_email.value)
cString:="PDF ok Impressão  ok" 


Envia_Email('1', ARQEVENTO, ' ')

Email:="Enviado para....:"+  cEmailDestino
HB_Cria_Log_nfe(cString,Email)

abreDADOSNFE()

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
				  
			
*MODIFY CONTROL gerando_xml OF nfe  VALUE   'XML ENVIADO.:' + xchavenfce  
	
abreDADOSNFE()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
abreseq_dav()
abreNFCE()
abreITEMNFCE()
abregra_chave()
abreseq_nfe()



*MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
*MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
vvSeq:=NFe.Txt_NOTA.VALUE
ZERA_NFE()
SELE SEQ_NFE
  If LockReg()  
		              SEQ_NFE-> SEQNFE :=vvSeq
				      SEQ_NFE->(dbcommit())
                      SEQ_NFE->(dbunlock())
	                Unlock
		          ENDIF           

SAIR_nfeh()
return(.f.)
returN

********************************************************************PELO ACBR
// --------------------------------------------------------------------------.
FUNCTION ENVIAR_NFE_ACBR()
LOCAL S_Versao  :=""  //SVRS20101110174320
LOCAL S_TpAmb   :=""  //1
LOCAL S_VerAplic:=""  //SVRS20101110174320
*LOCAL S_CStat   :=""  //107
Local sCStat ,cChNFe :="" //107
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
LOCAL E_NRec,cNProt    :="" //113000263213135
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
local cXMotivo :=""//Autorizado o uso da NF-e
local c_CUF     :=""//11
local c_ChNFe ,cCStat  :=""//11110384712611000152550010000004201000004201
local c_DhRecbto:=""//29/03/2011 07:47:33
local c_NProt   :=""//311110000010110
LOCAL nSeconds := 0, nCount := 4, lLoop := .T.
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
LOCAL nLote:="1" 
Public cEnvio_XML:=.t.
public nnfe:="NFE"+NTRIM(NFe.Txt_NOTA.VALUE)

Criadir_nfe()
zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))
Xml   :=alltrim(zNUMERO+xxANO+"-NFE")
pdf   :=alltrim(zNUMERO+xxANO+"-pdf")
tmp  :=alltrim(zNUMERO+xxANO+"-tmp")
  
         nfeSubDir   := DiskName()+":\"+CurDir()+"\"+"NFe"+"\"+xml+"\"
  		 nError      := MakeDir( nfeSubDir )
         nfeSubDirTMP:= DiskName()+":\"+CurDir()+"\"+"NFe"+"\"+tmp+"\"
  		 nError      := MakeDir( nfeSubDirTMP )
         nfePdfbDir  := DiskName()+":\"+CurDir()+"\"+"NFe"+"\"+pdf+"\"
  		 nError      := MakeDir( nfePdfbDir )	
         vNFE        :=NFe.Txt_NOTA.VALUE
          numeronfe  :=NFe.Txt_NOTA.VALUE
          path       :=DiskName()+":\"+CurDir() 
	
	
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
 lRetorno_Internet:=.T.
     else 
  	  MsgInfo("ATENÇÃO SEM SERVIDOR NO SISTEMA NACIONAL DE RECEPÇÃO DE NFES" +CRLF + "Tente Novamente mais Tarde" )
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
xcha        :=SUBSTR(variavel1,24,44)
vNFE        := substr(xcha, 26, 09)
XARQUIVO    :=SUBSTR(variavel1,4,90)
XARQUIVO    :=ALLTRIM(XARQUIVO)
zxnumero    :=val(vNFE)
SetProperty('nfe','gerando_xml','Value','Processado!!!'+xcha)
SetProperty('NFE','gerando_xml','BLINK',.F.)
MY_WAIT( 0.5 ) 

	cTexto        :=xcha+"-nfe.XML"
    cXmlAutorizado:=cTexto
    cXml           := MEMOREAD(nfeSubDirTMP+cTexto)
	 xCbdNtfSerie:=SUBSTR(xcha,23,3)
     xnumero     :=SUBSTR(xcha,26,9)
     zxnumero    :=val(xnumero)
	  cString     :=strzero(zxnumero,9)
     Serie_nfe    :=strzero(Serie_nfe,3)
	 Serie_nfe  :=VAL(Serie_nfe)
    SetProperty('nfe','gerando_xml','Value','Processado!!!'+xcha)
    SetProperty('NFE','gerando_xml','BLINK',.F.)
	
/////////////////enviar/////////////////////////
cRet       := MON_ENV("NFE.EnviarNFe("+XARQUIVO+",1,1,0,1)")
///////////////////////////////////////////////////
    SetProperty('nfe','gerando_xml1','Value','Processado!!!')
    SetProperty('NFE','gerando_xml1','BLINK',.F.)
						
					  
cFileDanfe:="C:\ACBrMonitorPLUS\SAI.TXT"
 lRetStatus:=EsperaResposta(cFileDanfe) 
  cFileDanfe := 'C:\ACBrMonitorPLUS\sai.txt'
MY_WAIT( 1 ) 

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
PUBLIC cDhRecbto :=c_DhRecbto

public xANO      := dtoS(date())
public xANO      :=ALLTRIM(SUBSTR(XANO,0,6))
public c_CFileDanfe:=""




If RCStat $ [103,104,105,106,107,108,109,110,111,112,124,128,135,136,137,138,139,140,142,150,151,201,202,203,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,301,302,303,304,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,349,350,351,352,353,354,355,356,357,358,359,360,361,362,364,365,366,367,368,369,370,372,373,374,375,376,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,401,402,403,404,405,406,407,408,409,410,411,417,418,420,450,451,452,453,454,455,461,462,463,464,465,466,467,468,471,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,496,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,567,568,569,570,571,572,573,574,575,576,577,578,579,580,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,650,651,653,654,655,656,657,658,660,661,662,663,678,679,680,681,682,683,684,685,686,687,688,689,690,691,693,694,695,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,740,741,742,743,745,746,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,798,799,800,805,806,807,999,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879]
  msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +C_XMotivo)
 return(.f.)
endif
MY_WAIT( 1 ) 

		
 //////////////////////////////////////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+xcha+")")
///////////////////////////////////////////////////
MY_WAIT( .5 ) 
       cDestino:="C:\ACBrMonitorplus\sai.txt"	
       lRetStatus:=EsperaResposta(cDestino)
BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET R_CStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cNProt           section  "CONSULTA"       ENTRY "NProt"
	   get R_XMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI
		
RCStat	:=R_CStat	
cNovaChave:=substr(R_XMotivo,91,44)
*****************************************************************************
IF  RCStat == "613" 

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(cNovaChave)+")")
MY_WAIT( 1) 
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
xcha:= cNovaChave

		   
IF c_CStat == "100"
fxml:="C:\ACBrMonitorPLUS\"+xcha+"-nfe.xml"
ffxml   :=Memoread(cXml)
ARQEVENTO:="C:\ACBrMonitorPLUS\"+xcha+"-nfe.XML"
ffxml           :=memoread(ARQEVENTO)
nfeSubDir       :="C:\ACBrMonitorPLUS\"
nfePdfbDir      :="C:\ACBrMonitorPLUS\"
      oPDF    := hbnfeDaNfe():New()
      oDanfe  := hbNFeDaGeral():New()
      RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
      oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE

oDanfe:ToPDF(  Memoread( ffxml ) ,nfePdfbDir+ xcha+"-nfe.pdf" )
cpdf:=nfePdfbDir+xcha+"-nfe.pdf" 
PDFOpen(cpdf)			 


cTXT     :=PATH+"\NOTA.TXT"
xml      :=memoread(CTXT)

 cQuery := "UPDATE nfe20 SET ARQUIVO_TXT ='"+AllTrim(FFxml)+"', chave='"+xcha+"' , AUTORIZACAO='"+auto+"' ,nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+ntrim(Serie_nfe)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
MSGINFO('OK')  
   Endif
 ENDIF
ENDIF



 IF RCStat $ "204" 
     msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +C_XMotivo )
	 * nfe.Txt_NOTA.value:=zxnumero+1
         abreseq_nfeD()
                SELE SEQ_NFED
                    If LockReg()  
                      SEQ_NFED->SEQNFE :=1
                      SEQ_NFED->(dbcommit())
                      SEQ_NFED->(dbunlock())
                 Unlock
                 ENDIF   
//////////////////////////////////////				 
	*MSGINFO()			 
	  oPDF    := hbnfeDaNfe():New()
      oDanfe  := hbNFeDaGeral():New()
      RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
      oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathNFe"
END INI
cCFileDanfe    :=c_CFileDanfe
PathNFE:=cCFileDanfe+"\"+"NFE"+"\"+xANO+"\"+"NFE"+"\"
cXml    :=PathNFE+xcha+"-nfe.xml"
ffxml   :=Memoread(cXml)
ARQEVENTO:=PathNFE+xcha+"-nfe.XML"
cCFileDanfe    :=c_CFileDanfe
fxml           :=cCFileDanfe+xcha+"-nfe.xml"
ffxml           :=memoread(ARQEVENTO)
nfeSubDir       :=PathNFE	
nfePdfbDir      :=PathNFE
oDanfe:ToPDF(  Memoread( ffxml ) ,nfePdfbDir+ xcha+"-nfe.pdf" )
cpdf:=nfePdfbDir+xcha+"-nfe.pdf" 
PDFOpen(cpdf)			 
//////////////////////////////////////	
			 
nfe.Txt_NOTA.setfocus
ELSE
 abreseq_nfeD()
                SELE SEQ_NFED
                    If LockReg()  
                      SEQ_NFED->SEQNFE :=0
                      SEQ_NFED->(dbcommit())
                      SEQ_NFED->(dbunlock())
                 Unlock
                 ENDIF   
				 
endif



  
IF RCStat $ "100,102"
     SetProperty('nfe','gerando_xml1','Value','PROTOCOLO..:' +  c_NProt)
     SetProperty('NFE','gerando_xml1','BLINK',.F.)
CBDMOD:="55"
xCbdEmpCodigo:="1"      
cCbdvNF      :=ntrim(nfe.Txt_valortotal.value)
cCbdvDesc_cob:=ntrim(NFE.Txt_desconto1.value)
cCbdvProd_ttlnfe:=ntrim(NFE.Txt_total.value)
ClienteTxtCGC:=nfe.Txt_CNPJ.value
CCbdxNome_dest:=nfe.Txt_NOMECLI.value	

xCbddEmi     := dtos(date())
*vvNFE:=(vNFE)
*MSGINFO(vNFE)
vvNFE:=(vNFE)
 oQuery   :=oServer:Query( "SELECT CbdNtfNumero FROM nfe20 WHERE CbdNtfNumero = "+(vvNFE)+" AND  cbdmod= "+"55"+" and CbdNtfSerie = "+NTRIM(Serie_nfe)+"  Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
   XCODIGO        :=ALLTRIM(STR(oRow:fieldGet(1)))
chave:= substr(cXml , 0, 48)
cFileDanfe:="C:\ACBrMonitorPlus\ACBrMonitor.INI"
////RETORNO////
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathNFe"
END INI
cCFileDanfe    :=c_CFileDanfe
PathNFE:=cCFileDanfe+"\"+"NFE"+"\"+xANO+"\"+"NFE"+"\"
cXml    :=PathNFE+xcha+"-nfe.xml"
ffxml   :=Memoread(cXml)
ARQEVENTO:=PathNFE+xcha+"-nfe.XML"
cCFileDanfe    :=c_CFileDanfe
fxml           :=cCFileDanfe+xcha+"-nfe.xml"
ffxml           :=memoread(ARQEVENTO)
nfeSubDir       :=PathNFE	
nfePdfbDir      :=PathNFE

IF ntrim(numeronfe)=XCODIGO 
else
cQuery := "INSERT INTO nfe20 (CbdvProd_ttlnfe,CbdvDesc_cob,CbdvNF, cbdmod, CbdCnpj_dest ,chave,CbdNtfNumero,CbdNtfSerie,CbdEmpCodigo,CbddEmi,CbdxNome_dest ,nt_retorno,AUTORIZACAO)  VALUES ('"+cCbdvProd_ttlnfe+"','"+cCbdvDesc_cob+"','"+cCbdvNF+"', '"+cbdmod+"', '"+ClienteTxtCGC+"','"+xcha+"','"+ntrim(numeronfe)+"','"+NTRIM(Serie_nfe)+"','"+xCbdEmpCodigo+"','"+xCbddEmi+"' ,'"+CCbdxNome_dest+"','"+(AllTrim(ffxml))+"','"+c_NProt+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
MsgStop(oQuery:Error())
MsgInfo("Por Favor Selecione o registro SOS nfe20 LINHA 5658")
Endif	
endif


cTXT     :=PATH+"\NOTA.TXT"
 cQuery := "UPDATE nfe20 SET ARQUIVO_TXT ='"+ALLTRIM(MaskBinData(MemoRead(cTXT)))+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+ntrim(Serie_nfe)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
*MSGINFO('OK')  
   Endif

SetProperty('nfe','gerando_xml1','Value','VAMOS VISUALIZAR:' +  c_NProt)
SetProperty('NFE','gerando_xml1','BLINK',.F.)
	

      oPDF    := hbnfeDaNfe():New()
      oDanfe  := hbNFeDaGeral():New()
      RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
      oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  

oDanfe:ToPDF(  Memoread( cXml ) ,nfePdfbDir+ xcha+"-nfe.pdf" )
cpdf:=nfePdfbDir+xcha+"-nfe.pdf" 
PDFOpen(cpdf)
cXml_envia:=nfeSubDir+xcha+"-nfe.xml"
ffxml_envia   :=Memoread(cXml_envia)
ARQEVENTO     :=nfePdfbDir+xcha+"-nfe.xml"
cEnviaPDF:="1"
eemail         :=ALLTRIM(nfe.Txt_email.value)
PUBLIC cEmailDestino  :=ALLTRIM(nfe.Txt_email.value)
cString:="PDF ok Impressão  ok" 
Envia_Email('1', ARQEVENTO, ' ')
Email:="Enviado para....:"+  cEmailDestino
HB_Cria_Log_nfe(cString,Email)
GRAVA_nfe1()
abreDADOSNFE()

      SELE DADOSNFE
               If LockReg()  
		              DADOSNFE -> NUM_SEQ    :=VAL(vNFE)
		         	  DADOSNFE -> CHAVE      :=xcha
		         	  DADOSNFE -> MODELO     :=55
				      DADOSNFE->(dbcommit())
                      DADOSNFE->(dbunlock())
	                Unlock
		          ENDIF                 
				  
			
abreDADOSNFE()
abrePEGAGT()
abrePEGAICMS()
abreboleto()
abreseq_dav()
abreNFCE()
abreITEMNFCE()
abregra_chave()
abreseq_nfe()
vvSeq          :=NFe.Txt_NOTA.VALUE
ZERA_NFE()
SELE SEQ_NFE
  If LockReg()  
		              SEQ_NFE-> SEQNFE :=vvSeq
				      SEQ_NFE->(dbcommit())
                      SEQ_NFE->(dbunlock())
	                Unlock
		          ENDIF           

SAIR_nfeh()
endif
return

//------------------------------------------------------------------
STATIC FUNCTION SAIR_nfeh
//---------------------------------------------
NFE.RELEASE
SAIR_nfCe()
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







