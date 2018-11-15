// --------------------------------------------------------------------------.
// Arquivo....: WORCAMENTs.PRG ------------------------------------------------.
// Funcao.....: Controle de ORCAMENTs -----------------------------------------.
// Programador: jose juca ----------------------------------.
// Empresa....: Suporte Sistemas --------------------------------------------.
// Data.......: 29/12/2010  MYSQL NATIVA-------------------------------------.
// --------------------------------------------------------------------------.
#INCLUDE "INKEY.CH"
#INCLUDE "MINIGUI.CH"
#include 'i_textbtn.ch'
#define WM_MDIMAXIMIZE                  0x0225
#define WM_MDIRESTORE                   0x0223
#define c1Tab CHR(9)
#define NTrim( n ) LTRIM( STR( n, IF( n == INT( n ), 0, 2 ) ) )
#INCLUDE "TSBROWSE.CH"
#include 'i_textbtn.ch'
#INCLUDE "TSBROWSE.CH"
#INCLUDE "INKEY.CH"
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
static lGridFreeze := .T.
#define CHAR_REMOVE  "/;-:,\.(){}[] "

*SELECT *FROM PRODUTOS WHERE CODIGO LIKE  "+vPESQ+"%"


//----------------------------------------------
FUNCTION VENDE_NFCE(vpesqproduto)
//----------------------------------------------
 LOCAL  vettamanho := {'UN',HB_OEMTOANSI('CX')}
 LOCAL lJuridica   := .F.
 LOCAL cPesq       :=""
 LOCAL nKEY        := VK_RETURN
 LOCAL REC         :=0
 LOCAL NCAIXA      :=VAL(C_CAIXA)
 LOCAL XXX         :=1

PUBLIC  Impostos_Cupom_1:=0
PUBLIC  Impostos_Cupom  :=0

Abre_conexao_MySql()     
My_SQL_Database_Connect(cDataBase)
 
set date british
set century on
set epoch to 2010

RDDSETDEFAULT("DBFCDX")
//--------------------------
close all 
MCAIXA :=NCAIXA
SET LANGUAGE TO PORTUGUESE
SET INTERACTIVECLOSE OFF   ///SAIR
abreNFCE()
abreITEMNFCE()
abreseq_dav()
CLOSE ALL 


CLOSE ALL
abreitemnfe()
abreDADOSNFE()
CLOSE ALL
USE ((ondetemp)+"ITEMNFE.DBF") new alias ITEMNFE exclusive  VIA "DBFCDX" 
zap
PACK
USE ((ondetemp)+"DADOSNFE.DBF") new alias DADOSNFE exclusive   VIA "DBFCDX" 
zap
PACK


USE ((ondeTEMP)+"SEQ_DAV.DBF") new alias SEQ_DAV exclusive   
IF EMPTY(seq_DAV->ABERTO)
CLOSE ALL  
USE ((ondetemp)+"NFCE.DBF") new alias NFCE exclusive    // arquivo que vai ter todo o conteudo do TXT
zap
PACK
USE ((ondetemp)+"ITEMNFCE.DBF") new alias ITEMNFCE exclusive    // arquivo que vai ter todo o conteudo do TXT
zap
PACK
endif


USE ((ondeTEMP)+"SEQ_DAV.DBF") new alias SEQ_DAV exclusive    
IF EMPTY(seq_DAV->ABERTO)
CLOSE ALL  
USE ((ondetemp)+"SEQ_DAV.DBF") new alias SEQ_DAV exclusive    // arquivo que vai ter todo o conteudo do TXT
zap
PACK
endif
SET BROWSESYNC ON
ZERA_FORMA()


aadd(aTipoFJ,'Jurídica Cnpj')
aadd(aTipoFJ,'Física   Cpf')
 



IF ISWINDOWDEFINED(Form_Dav)
    maximize WINDOW Form_Dav 
    RESTORE WINDOW Form_Dav
ELSE
  


DEFINE WINDOW Form_Dav ;
    	        at 000,000; 
                width ajanela; 
                height ljanela-40;
                TITLE "Nota Fiscal eletronica do Consumidor " ;
                icon cPathImagem+'JUMBO1.ico';
                MODAL;
            	NOSIZE ;			
			    ON INIT {||Reconectar_A(),refresh_1()};
                 ON RELEASE CloseTable()
   
 
 
  ON KEY F10 ACTION { || Fecha_VENDA() } 
  ON KEY ESCAPE  OF Form_Dav ACTION { ||Form_dav.RELEASE } 
  ON KEY F11  OF FORM_DAV ACTION { ||wn_mudatamanho(),FORM_DAV.Text_quant.setfocus} 	
 
//------------------------------------------------

  DEFINE LABEL ITEN
            ROW    10
            COL    12
            WIDTH  40
            HEIGHT 40
            VALUE ""
            FONTSIZE 25
            FONTBOLD .T.
            FONTITALIC .F.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            BACKCOLOR {191,1225,255}
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            CENTERALIGN .T.
       END LABEL  
	
  	
  DEFINE LABEL txdescri
            ROW    10
            COL    103
            WIDTH  900
            HEIGHT 40
            VALUE ""
            FONTSIZE 25
            FONTBOLD .T.
            FONTITALIC .F.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            BACKCOLOR {191,1225,255}
  		    FONTCOLOR { 225, 000, 000 }
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
       END LABEL  
	 
		

   DEFINE LABEL oSayq
            ROW   52
			COL    03
            WIDTH  180
            HEIGHT 30
            VALUE "Quantidade"
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  

  DEFINE LABEL textQtd_1
            ROW    82
            COL    03
            WIDTH  180
            HEIGHT 40
            VALUE ""
            FONTSIZE 25
            FONTBOLD .T.
            FONTITALIC .F.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            BACKCOLOR {191,1225,255}
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .T.
       END LABEL  
	 
	 //---------------------------------------------------------
    DEFINE LABEL oSayemb
            ROW   52
			COL    270
            WIDTH  180
            HEIGHT 30
            VALUE "Embalagens"
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
   
  DEFINE LABEL UND
            ROW    82
            COL    270
            WIDTH  180
            HEIGHT 40
            VALUE ""
            FONTSIZE 25
            FONTBOLD .T.
            FONTITALIC .F.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            BACKCOLOR {191,1225,255}
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            CENTERALIGN .T.
     END LABEL  
	 

   
   
     DEFINE LABEL oSayunt
            ROW   52
			COL    510
            WIDTH  180
            HEIGHT 30
            VALUE "Pr-Unitario"
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
 
		   
DEFINE LABEL unitario
            ROW    82
            COL    510
            WIDTH  180
            HEIGHT 40
            VALUE ""
            FONTSIZE 25
            FONTBOLD .T.
            FONTITALIC .F.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            BACKCOLOR {191,1225,255}
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
    *        CENTERALIGN .F.
	        RIGHTALIGN .T.
     END LABEL  
	 

		 
//----------------------------------------------------
        DEFINE LABEL oSaystot
            ROW   52
			COL    780
            WIDTH  180
            HEIGHT 30
            VALUE "Sub_Total R$"
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  


 		   
DEFINE LABEL total
            ROW    82
            COL    780
            WIDTH  180
            HEIGHT 40
            VALUE ""
            FONTSIZE 25
            FONTBOLD .T.
            FONTITALIC .F.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            BACKCOLOR {191,1225,255}
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
       *   CENTERALIGN .F.
            RIGHTALIGN .T.
     END LABEL  
	 
		 
//----------------------------------------------------
        DEFINE LABEL oSay223
            ROW   480
			COL    00
            WIDTH  260
            HEIGHT 30
             VALUE "Barras F8-Procura"
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  

  
 DEFINE FRAME Frame_6
            ROW    500
            COL    000
            WIDTH  265
            HEIGHT 55
            CAPTION ""
            OPAQUE .T.
     END FRAME  

		
		 @ 510,03 textBTN Text_CODBARRA;
	       of Form_Dav;
		   width 260;
           HEIGHT 40;
           value 0;
		   numeric;
		   font 'verdana';
           size 20;
           FONTCOLOR { 255, 000, 000 };
           BACKCOLOR { 128, 128, 128 };
           picture cPathImagem+'lupa.bmp';
	       maxlength 13;
	       rightalign;
		   Action {||GetCode_proa(Form_Dav.Text_CODBARRA.setfocus)};
           ON enter {||iif(!Empty(Form_Dav.Text_CODBARRA.Value),pesq_proa(),Form_Dav.Text_CODBARRA.setfocus)};
           on gotfocus (CHANGETEXTBTNSTATE(GetControlHandle('Text_CODBARRA','Form_Dav'),1),(Form_Dav.Text_CODBARRA.backcolor := {255,255,196}))
		   ON KEY F8   OF Form_Dav ACTION { || GetCode_proa()} 
 


        DEFINE LABEL oSay122
            ROW   480
			COL    350
            WIDTH  180
            HEIGHT 30
            VALUE "Quantidade"
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
  

  DEFINE FRAME Frame_8
            ROW    500
            COL    350
            WIDTH  125
            HEIGHT 55
            CAPTION ""
            OPAQUE .T.
 END FRAME  

 DEFINE LABEL oSay15552 
            ROW   520
			COL    660
            WIDTH  20
            HEIGHT 30
            VALUE "=" 
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  



 
     DEFINE TEXTBOX Text_quant
               ROW   510
               COL   355
               WIDTH  120
               HEIGHT 40
               VALUE  0
               FONTCOLOR { 255, 000, 000 }
               BACKCOLOR { 255, 255,000} 
               INPUTMASK "99,999.99"
               NUMERIC  .T.
               ON GOTFOCUS This.BackColor:=clrBack 
               ON LOSTFOCUS This.BackColor:=clrNormal 
	           FONTNAME 'Arial'
               FONTSIZE 20
               RIGHTALIGN .T.
              *ON ENTER {||chkvazio(),chktotal(),gravaiteNFE(),fitaAdiciona()}  
			   ON ENTER {||gravaiteNFE(),zera_valor()}
             END TEXTBOX 
 
 
   DEFINE LABEL oSay12 
            ROW   480
			COL    505
            WIDTH  155
            HEIGHT 30
            VALUE "Valor Unitário" 
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
		 
		 DEFINE LABEL valor_unit
            ROW    510
            COL    505
            WIDTH  155
            HEIGHT 40
            VALUE ""
            FONTSIZE 25
            FONTBOLD .T.
            FONTITALIC .F.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            BACKCOLOR {191,1225,255}
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .T.
			
       END LABEL  
	
	   
	   
  DEFINE LABEL oSay1222 
            ROW   480
			COL    680
            WIDTH  155
            HEIGHT 30
            VALUE "Sub. Total"
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  

  
 		   
		   
DEFINE LABEL total1
            ROW    510
            COL    680
            WIDTH  155
            HEIGHT 40
            VALUE ""
            FONTSIZE 25
            FONTBOLD .T.
            FONTITALIC .F.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            BACKCOLOR {191,1225,255}
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
       *   CENTERALIGN .F.
            RIGHTALIGN .T.
     END LABEL  



//------------------------------

  DEFINE LABEL aTotal
            ROW 570
			COL   770
		    WIDTH 250
            HEIGHT 50
            VALUE "Total R$"
			FONTNAME "MS Sans Serif"
            FONTSIZE 25
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
		    RIGHTALIGN .F.
  END LABEL  




	   
 @ 620,770 label Label_TOT ;
         OF Form_Dav;
         VALUE "" ;
         RIGHTALIGN; 
         WIDTH 250;
         HEIGHT 55 ;
         FONT 'Times New Roman' ;
         SIZE 38 FONTCOLOR; 
         BLUE BOLD  BACKCOLOR {191,225,255}      
//------------------------------


DEFINE BUTTONEX Button_1
           ROW    580
           COL    010
           WIDTH  140
           HEIGHT 40
           CAPTION "F10-Fecha Venda"
           Action  Fecha_VENDA()          
      END BUTTONEX  


    DEFINE BUTTONEX Button_2
           ROW    580
           COL    160
           WIDTH  110
           HEIGHT 40
           CAPTION "Esc-&Sair"
          Action Form_dav.RELEASE
    END BUTTONEX  

 
    DEFINE BUTTONEX Button_3
           ROW    580
           COL    300
           WIDTH  110
           HEIGHT 40
          CAPTION "Cancelar Itens"
          Action   {|| wn_excluiitem(),Form_DAV.Text_CODBARRA.SETFOCUS}  
     END BUTTONEX 
 
 
	@ 580,520 BUTTONEX BUTTON_6 ;
		    CAPTION "F11-&Caixa/Fardo";
            action (wn_mudatamanho(),Form_DAV.Text_quant.setfocus);
		    VERTICAL ;
			WIDTH 120 ;
			HEIGHT 50
		

   @ 530, 848  LABEL davs ;
   WIDTH 80 ;
   HEIGHT 20;
   VALUE "Davs" ;
   FONT 'Times New Roman'SIZE 12.00 
   
   
/*
	 @ 530,920  TEXTBOX txt_DAVs;
      WIDTH 80;
	  HEIGHT 25 ;
      VALUE 0;
      FONT "Ms Sans Serif" SIZE 10;
      FONTCOLOR { 000, 000, 000 };
      BACKCOLOR { 255, 255, 000 };
      numeric inputmask '9999999';
     ON enter {||Filtra_davs(),Form_DAV.Text_CODBARRA.SETFOCUS, Form_DAV.txt_DAVs.VALUE:=0}
*/
		 
/*
		
 DEFINE BROWSE Browse_1
            ROW    130
            COL   00
            WIDTH 1024
            HEIGHT 350
            WORKAREA ITEMNFCE
            WIDTHS {80,150,420,95,120,140,100,130,60,80 }
            HEADERS {'Itens','Código','Descrição','Qtd.','Valor R$','Sub-Total R$','%Icms','Nº','St','CFOP' }
            FIELDS { 'ITENS','produto','DESCRICAO','transform((qtd),"999,999.99")','transform((Valor),+"999,999.99")','transform((SUBTOTAL),"999,999.99")','ALIQUOTA','NUMCOD','ST','CFOP'}
            FONTSIZE -015
			FONTNAME "Times New Roman" 
		    ON DBLCLICK Form_Davdav()
		    FONTUNDERLINE .F.
            FONTSTRIKEOUT .F.
            VSCROLLBAR .T.
            INPUTMASK .T.
            FORMAT .f.
			Justify {1,1,0,1,1,1,1,1,1,1}
			FONTCOLOR {00,000,00}
            BACKCOLOR {255,255,255}
            READONLYFIELDS .F.
		   * WHEN 0
			VALUE 1
           END BROWSE  
*/


  
 	@ 130,001 GRID fita ;
			WIDTH 1010 ;
			HEIGHT 350 ;
		    WIDTHS {90,50,125,350,70,90,110,110,125,80,60,80 };
            HEADERS {'Status','Itens','Codigo','Descrição','Und.','Qtd','Valor R$','Sub-Total R$','Desc.R$','%Icms','St' ,'CFOP'};
            VALUE 1 ;	
            FONT "Times New Roman" SIZE 12 BOLD ;
	   	    Justify {0,0,0,0,0,1,1,1};
		    backcolor WHITE;
	        fontcolor BLUE
		
		
 		  DEFINE STATUSBAR of Form_Dav
          STATUSITEM "Conectado no IP: "+C_IPSERVIDOR WIDTH 150
           DATE
          CLOCK
          KEYBOARD
      END STATUSBAR
	
Form_Dav.Text_CODBARRA.setfocus
END WINDOW
Form_Dav.Activate()
endif
return nil


//--------------------------------------
#Include "Minigui.ch"
//-----------------------------------------------------------------------
static Function Form_Davdav()
//---------------------------------------------------------------------
local  oSay1, oGet1, oSay2, oGet2, oSay3, oGet3, oSay4, oGet4, oSay5, oGet5, oBut2
cGet1 := ITEMNFCE->PRODUTO
cGet2 := ITEMNFCE->DESCRICAO
cGet3 := ITEMNFCE->QUANT
cGet4 := ITEMNFCE->VALOR
cGet5 := ITEMNFCE->subtotal
cORCAMENT :=ITEMNFCE->NUMCOD
PosiReg     := Recno()
SET INTERACTIVECLOSE OFF   ///SAIR


IF ISWINDOWDEFINED(oform5)
   MINIMIZE WINDOW oform5 
    RESTORE WINDOW oform5
ELSE

DEFINE WINDOW oform5;
       AT 200, 80 ;
       WIDTH 900 ;
       HEIGHT 300 ;
       TITLE "Alterar itens de Produtos " ;
       icon cPathImagem+'display.ico';
       modal;
       nosize
	   
//-----------------------------------------------------------
 @ 10, 010   LABEL doc;
   WIDTH 150 ;
   HEIGHT 016 ;
   VALUE "Nº Doc."  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 255, 000 }bold;
   BACKCOLOR { 00, 120, 255 }

                               
@ 30,10 TEXTBOX oSay3;
                   of Form_81;
                   WIDTH  150;
                   HEIGHT 025;
                   VALUE cORCAMENT;
                   font 'verdana';
                   size 14
				   
//---------------------------------------------------
     
 @ 10, 220   LABEL Barras;
   WIDTH 150 ;
   HEIGHT 016 ;
   VALUE "Cod_barras"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 255, 000 }bold;
   BACKCOLOR { 00, 120, 255 }

   @ 30,220   TEXTBOX oGet1 ;
   WIDTH 180 HEIGHT         25;
   VALUE cGet1 ;
   readonly;                
   FONT "MS Sans Serif" SIZE 010 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 255, 255, 255 } BOLD

//---------------------------------------------------

 @ 10, 400   LABEL produto;
   WIDTH 400 ;
   HEIGHT 016 ;
   VALUE "Descrição produto"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 255, 000 }bold;
   BACKCOLOR { 00, 120, 255 }

   @ 030, 400   TEXTBOX oGet2 ;
   WIDTH 380 HEIGHT         25 ;
   VALUE cGet2 ;
   readonly; 
   FONT "MS Sans Serif" SIZE 010 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 255, 255, 255 } BOLD 
           
//------------------------------

 @ 80,10  LABEL Generico;
   WIDTH 150 ;
   HEIGHT 016 ;
   VALUE "Itens Generico" ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 255, 000 }bold;
   BACKCOLOR { 00, 120, 255 }
	 

@ 100,10 TEXTBOX oGet33;
                  of oForm5;
                   WIDTH  120;
                   HEIGHT 030;
                   VALUE PosiReg ;
                   readonly;
                   font 'verdana';
                   size 14;                 
                   numeric inputmask '999999'

//-----------------------------------------
 @ 80, 220   LABEL quantidade;
   WIDTH 150 ;
   HEIGHT 016 ;
   VALUE "Quantidade" ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 255, 000 }bold;
   BACKCOLOR { 00, 120, 255 }

@ 100,220 TEXTBOX oGet3;
                  of oForm5;
                   WIDTH  150;
                   HEIGHT 030;
                   VALUE cGet3 ;
                   font 'verdana';
                   size 14;                 
                   numeric inputmask '99,999.999';
                   on change {||chkSUB()} 
//----------------------------------------------------


 @ 80, 400  LABEL valor;
   WIDTH 150 ;
   HEIGHT 016 ;
   VALUE "Valor R$"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 255, 000 }bold;
   BACKCOLOR { 00, 120, 255 }

   @ 100, 400  TEXTBOX oGet4 ;
   WIDTH 120 HEIGHT         30 ;
   VALUE cGet4 ;
   FONT "MS Sans Serif" SIZE 014 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 255, 255, 255 } BOLD; 
   numeric inputmask '99,999.999';
   on change {||chkSUB()} 
//----------------------------------------


 @ 080,600   LABEL totals;
   WIDTH 150 ;
   HEIGHT 016 ;
   VALUE "Sub-Total R$"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 255, 000 }bold;
   BACKCOLOR { 00, 120, 255 }

   @ 100, 600   TEXTBOX oGet5 ;
   WIDTH 120 HEIGHT         30 ;
   VALUE cGet5 ;
   FONT "MS Sans Serif" SIZE 014 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 255, 255, 255 } BOLD; 
   numeric inputmask '99,999.999'

   @ 220, 800   BUTTON oBut2 ;
   CAPTION "Confirma"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "MS Sans Serif" SIZE 009 BOLD; 
   Action OnC_oGet1( )


   @ 220,10   BUTTON oBut3 ;
   CAPTION "Voltar"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "MS Sans Serif" SIZE 009 BOLD; 
   Action  Sair3() 

   Form_Dav.Text_CODBARRA.SETFOCUS
END WINDOW
ACTIVATE WINDOW oForm5
endif
Return NIL

//------------------

//--------------------------------------------------------------------------//
STATIC FUNCTION OnC_oGet1( )
// Fun‡Æo... Gravar o item ------------------------------------------------.
sele ITEMNFCE
    If LockReg()  
     replace PRODUTO   with oForm5.oGet1.value
     replace DESCRICAO with oForm5.oGet2.value
     replace QTD       with oForm5.oGet3.value
     replace quant     with oForm5.oGet3.value
     replace NUMCOD    with oForm5.oSay3.value
     replace VALOR     with oForm5.oGet4.value
     replace preco     with oForm5.oGet4.value
     replace subtotal  with oForm5.oGet5.value
     ITEMNFCE->(dbcommit())
     ITEMNFCE->(dbunlock())
   Unlock
  ENDIF     
SELE ITEMNFCE
oForm5.RELEASE
Form_Dav.browse_1.Refresh
SUM SUBTOTAL TO nTtFactura
MODIFY CONTROL Label_TOT OF Form_Dav VALUE ""  +TransForm( nTtFactura  , "@R 99,999.99")     
RETURN(NIL)
// Fim da fun‡Æo de gravar o item --------------------
//-------------------------------------------------------


   
***********************************
STATIC FUNCTION SAIR3
       oForm5.RELEASE
RETURN

************************************
// --------------/------------------------------------------------------------.
STATIC FUNCTION wn_excluiitem()
// Fun‡Æo....: Excluir o item atual -----------------------------------------.
*local nCodigo := ITEMNFCE->produto
Local NITEM:= (((GetColValue( "FITA", "Form_Dav",2))))
Local nCodigo:= (AllTrim((GetColValue( "FITA", "Form_Dav", 3 ))))
      

DEFINE WINDOW Exclui_Item	;
		AT 050,082	;
		WIDTH  487	;
	        HEIGHT 325	;
                title 'Excluir items ';
                icon cPathImagem+'movie.ico';
		         modal;
                NOSIZE			       

  ON KEY ESCAPE  OF Form_Dav ACTION Exclui_Item.RELEASE

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
/*

   @ 045, 145   TEXTBOX oGet1 ;
   WIDTH  115 ;
   HEIGHT  23 ;
   VALUE  nCodigo ;
   FONT "Ms Sans Serif" SIZE 014 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 };
   INPUTMASK "9999999999999";
   ON ENTER  {|| w_BUSCA_ITEMW(NITEM)}
  */

     DEFINE TEXTBOX TxtItem
            ROW    10
            COL    80
            WIDTH  40
            HEIGHT 25
            FONTSIZE 14
            FONTBOLD .T.
            VALUE NITEM
            INPUTMASK "999"
            NUMERIC  .T.
	      ON ENTER  {|| BUSCA_ITEM(),refresh_1()}
     END TEXTBOX 
  
END WINDOW
ACTIVATE WINDOW  Exclui_Item
RETURN(NIL)


// ---------------------------------------------------------------------------
static FUNCTION BUSCA_ITEM(NITEM)

     Select ITEMNFCE
      go top
        OrdSetFocus('item')
        seek Exclui_Item.TxtITEM.value
				
	  If .Not. Found()
          msgexclamation('ITENS NÃO encontrada ','Atenção')
     	Exclui_Item.RELEASE
	    MSGINFO("Item não encontrado...")
        Form_DAV.FITA.setfocus	 
        Form_DAV.Text_CODBARRA.VALUE := ""
        Form_DAV.Text_CODBARRA.SETFOCUS	
		RETURN(.F.)
        ELSE
      endif

		
		
		 M->ITEM   :=ITEMNFCE->itens
        if found()
         M->ITEM   :=ITEMNFCE->itens
         wITEM     :=(ITEMNFCE->itens)
		 wITEM     :=wITEM
	   	 ITEns1    :=Exclui_Item.TxtITEM.value
         cod       :=ITEMNFCE->produto
         qtdc      :=ITEMNFCE->quant   
         numeroRET :=ITEMNFCE->nseq_orc
         cvalor    :=ITEMNFCE->valor   
      *	C_VERIFICA :=ITEMNFCE->verificado
	  *   ccvalor    :=ccvalor*qtdc
	       nCodigo := ITEMNFCE->produto
	  
		 
         MODIFY CONTROL Lb_PRODUTO  OF Exclui_Item VALUE 'Produto:    '  +ITEMNFCE->DESCRIcao
         MODIFY CONTROL Lb_qtd      OF Exclui_Item VALUE 'Quantidade  '  +TransForm(ITEMNFCE->quant   , "@R 99,999.99")  
         MODIFY CONTROL Lb_PRECO    OF Exclui_Item VALUE 'Valor R$    '  +TransForm(ITEMNFCE->valor   , "@R 99,999.99")     
 if MsgYesNo("Deseja Deletar este Item ?", "Produto...")
      IF ITEMNFCE->(DBRLOCK())
         ITEMNFCE->(DBDELETE())
         ITEMNFCE->(DBCOMMIT())
         ITEMNFCE->(DBSKIP(-1))
         endif  
        endif
 
 
Form_Dav.Text_CODBARRA.SETFOCUS
*Form_Dav.Browse_1.VALUE:= ITEMNFCE->(RECNO())
*Form_Dav.Browse_1.REFRESH
*fitaAdiciona()

Form_Dav.valor_unit.VALUE:=0
select ITEMNFCE
SUM SUBTOTAL TO nTtFactura 
*MSGINFO(nTtFactura)
MODIFY CONTROL Label_TOT OF Form_Dav VALUE ""  +TransForm( nTtFactura  , "@R 999,999.99")  


			
    XBARRA         :=LPAD(STR((Form_dav.Text_CODBARRA.VALUE)),13,[0])
    Cchave         :=NTRIM(Form_dav.Text_CODBARRA.VALUE)
    oQuery         :=oServer:Query( "Select CODIGO,PRODUTO,UNIT,ST,NCM,CST,QTD,DOLLAR,sit_trib,ICMS,CODBAR,MD5,und From produtos WHERE codbar = " + AllTrim(nCodigo))
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
 * MSGINFO(aqtd)
TOTAL_QTD         :=aqtd+qtdc
xcncm             :=VAL(cncm)
IF Xcncm=0
cncm:="49001000"
ELSE
cncm             :=cncm  
ENDIF

*MSGINFO(TOTAL_QTD)


cQuery := "UPDATE PRODUTOS SET NCM ='"+CNCM+"',qtd ='"+NTRIM(TOTAL_QTD)+"' WHERE CODBAR = " + AllTrim(nCodigo)
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  Return Nil
Endif
  
Form_Dav.Text_CODBARRA.VALUE := 0
Form_Dav.Text_CODBARRA.SETFOCUS
Exclui_Item.RELEASE
ENDIF
RETURN(NIL)

// Fim da fun‡Æo de excluir o item atual ------------------------------------.


//--------------------------------------
STATIC Function GetCode_proa(nValue)
//----------------------------------
local cReg := ''
Local nReg := 1

Ajanela := GetDesktopWidth() //* 0.78125
Ljanela := GetDesktopHeight() //* 0.78125 
  
  define window form_autoa;
    AT 000,00;
    WIDTH 1024;
    HEIGHT 740;
    Title 'Pesquisa de Produtos';
    icon cPathImagem+'jumbo1.ico';
    MODAL;
    NOSIZE;
    NOSYSMENU;
	BACKCOLOR { 00, 120, 255 }
	
	
 ON KEY ESCAPE ACTION form_autoa.release //tecla ESC para fechar a janela
 
  
@ 600,00 LABEL  Label_Search_Generic ;
    VALUE "Disgite a pesquisa " ;
    WIDTH 170 ;
    HEIGHT 20

	
 @ 600,180 TEXTBOX cSearch ;
    WIDTH 326 ;
    MAXLENGTH 40 ;
    UPPERCASE  ;
    ON ENTER iif( !Empty(form_autoa.cSearch.Value),Pesq_PROD(), form_autoa.Grid_proa.SetFocus )
         
	DEFINE GRID Grid_proa
            ROW    00
            COL    00
            WIDTH  1024
            HEIGHT 580
            headers {"Código",'Barras Gtim','Descrição','Valor R$','Unidade','Cst','Iat','Ippt','Qtd','Qtq-cc-fd','R$ cx-fd' }
            WIDTHS {80,158,500,100,120,80,50,55,100,100,100}
            VALUE 1 
	        JUSTIFY {1,0,0,1,0,0,1,1,1,1,1}
            FONTNAME "Arial Baltic"
            FONTSIZE 10
		    FONTBOLD .T.
		    WHEN 84
	        fontcolor BLACK
	         on dblclick {||Find_proa() }
        END GRID  

*	ON KEY ESCAPE OF form_autoa ACTION { ||str(Form_Dav.Text_CODBARRA.value):=(AllTrim(GetColValue( "Grid_proa", "form_autoa", 1 ))),form_autoa.release }
	ON KEY ESCAPE ACTION form_autoa.release 


	
 /*
  
				
         DEFINE BUTTONEX Button_25
           ROW    630
           COL    010
           WIDTH  110
           HEIGHT 30
           CAPTION "Incluir"
		*   action inc_pro(1)
        END BUTTONEX  
	

         DEFINE BUTTONEX Button_283
           ROW    630
           COL    130
           WIDTH  110
           HEIGHT 30
           CAPTION "alterar"
	     *   action alt_pro(2)
        END BUTTONEX  

        DEFINE BUTTONEX Button_2
           ROW    630
           COL    880
           WIDTH  110
           HEIGHT 30
           CAPTION "Esc-&Voltar"
          action form_autoa.release
        END BUTTONEX  
*/

form_autoa.cSearch.Value:= "A" 
form_autoa.cSearch.SetFocus
Grid_proa()
end window
form_autoa.center
form_autoa.activate
return


 
//-------------------------------------------------
STATIC Function Findproa()
//--------------------------------------------------
Local pCode:= (AllTrim((GetColValue( "Grid_proa", "form_autoa", 2 ))))
Local pnome:= (AllTrim(GetColValue( "Grid_proa", "form_autoa", 3 )))
Local pncm := (AllTrim(GetColValue( "Grid_proa", "form_autoa", 7 )))
Form_Dav.Text_CODBARRA.value :=val((pcode))
Form_Dav.txdescri.value:=(pnome)
*wn_mudatamanho()
form_AUTOa.release
return(pcode)



//-------------------------------------------------
STATIC Function Find_proa()
//--------------------------------------------------
Local pCode   := (AllTrim((GetColValue( "Grid_proa", "form_autoa",2 ))))
*Local pnome  := (AllTrim(GetColValue( "Grid_proa", "form_autoa", 3 )))+CRLF
Local pnome   := (AllTrim(GetColValue( "Grid_proa", "form_autoa", 3 )))
Local pncm    := (AllTrim(GetColValue( "Grid_proa", "form_autoa", 7 )))
local x_valor := (AllTrim(GetColValue( "Grid_proa", "form_autoa", 4 )))
Reconectar_A()
*msginfo(x_valor)

nTamanhoNomeParaPesquisa     :=Len(pnome)
Form_DAV.Text_CODBARRA.value :=val((pcode))
Form_DAV.txdescri.value      :=sRemove(pnome)
Form_DAV.valor_unit.value    :=x_valor

*wn_mudatamanho()
form_AUTOa.release
return(pcode)


//******************************
static function Pesq_PROD()
//*******************************
Local cSearch:= ' "'+Upper(AllTrim(form_autoa.cSearch.Value ))+'%" '            
Local nCounter:= 0
Local oRow, cPesq:=""
Local i
local c_barras
Local oQuery
local c_encontro
Local GridMax:= iif(len(cSearch)== 0,  3000, 1000000)

DELETE ITEM ALL FROM Grid_proa Of form_autoa
oQuery := oServer:Query( "Select codigo, codbar,PRODUTO,dollar,und,CST,IAT,IPPT,QTD,QTD1,Valor_cx From produtos WHERE produto LIKE "+cSearch+" Order By produto" )
If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
c_encontro:=oRow:fieldGet(2)
If !Empty(c_encontro) // se nao encontra vale a pesq pro nota fiscal
else
c_barras:=CHARREM(form_autoa.cSearch.Value)
c_barras:=CHARREM(CHAR_REMOVE,form_autoa.cSearch.Value )
c_barras:=val(c_barras)
c_barras:=alltrim(str(c_barras))
c_barras:=LPAD(STR(val(c_barras)),13,[0])
C_barras:= ' "'+Upper(AllTrim(c_barras))+'%" '  
oQuery := oServer:Query( "Select codigo, codbar,PRODUTO,dollar,und,CST,IAT,IPPT,QTD,QTD1,Valor_cx From produtos WHERE codbar LIKE "+c_barras+" Order By produto" )
 
EndIf
For i := 1 To oQuery:LastRec()
  nCounter++
  If nCounter == GridMax
    Exit
  Endif                   
  oRow := oQuery:GetRow(i)
 ADD ITEM { str(oRow:fieldGet(1),5), (LPAD(((oRow:fieldGet(2))),14,[0])), oRow:fieldGet(3),transform((oRow:fieldGet(4)),"@R 999,999.99"), oRow:fieldGet(5),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),STR(oRow:fieldGet(9),10,2),STR(oRow:fieldGet(10),10,2),STR(oRow:fieldGet(11),11,2) } TO Grid_proa Of form_autoa
  oQuery:Skip(1)
Next
oQuery:Destroy()
if lGridFreeze
     form_autoa.Grid_proa.enableupdate
endif
form_autoa.Grid_proa.value:=1
form_autoa.Grid_proa.setfocus
return(nil)

*--------------------------------------------------------------*
STATIC Function Grid_proa()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(form_autoa.cSearch.Value ))+'%" '            
Local nCounter:= 0
Local oRow
Local i
local c_barras
Local oQuery
local c_encontro

DELETE ITEM ALL FROM Grid_proa Of form_autoa

oQuery := oServer:Query( "Select  codigo, codbar,PRODUTO,dollar,und,CST,IAT,IPPT,QTD,QTD1,Valor_cx From produtos WHERE produto LIKE "+cSearch+" Order By produto" )
If oQuery:NetErr()												
  MsgStop(oQuery:Error())
 Return Nil
Endif
REG:=0

oRow := oQuery:GetRow(1)
c_encontro:=oRow:fieldGet(2)
If !Empty(c_encontro) // se nao encontra vale a pesq pro nota fiscal
else
c_barras:=CHARREM(form_autoa.cSearch.Value)
c_barras:=CHARREM(CHAR_REMOVE,form_autoa.cSearch.Value )
c_barras:=val(c_barras)
c_barras:=alltrim(str(c_barras))
c_barras:=LPAD(STR(val(c_barras)),13,[0])
c_barras:= ' "'+Upper(AllTrim(c_barras))+'%" '  

*msginfo(c_barras)

oQuery := oServer:Query( "Select  codigo, codbar,PRODUTO,dollar,und,CST,IAT,IPPT,QTD,QTD1,Valor_cx From produtos WHERE codbar LIKE "+c_barras+" Order By produto" )

form_autoa.cSearch.setfocus
form_autoa.cSearch.Value:='A'
EndIf
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)

 ADD ITEM { str(oRow:fieldGet(1),5), (LPAD(((oRow:fieldGet(2))),14,[0])), oRow:fieldGet(3),transform((oRow:fieldGet(4)),"@R 999,999.99"), oRow:fieldGet(5),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),STR(oRow:fieldGet(9),10,2),STR(oRow:fieldGet(10),10,2),STR(oRow:fieldGet(11),11,2)} TO Grid_proa Of form_autoa
 
 oQuery:Skip(1)
  Next
oQuery:Destroy()
form_autoa.cSearch.SetFocus  
*form_autoa.Grid_proa.value:=1
*form_autoa.Grid_proa.setfocus
Return Nil




STATIC FUNCTION wn_mudatamanho
LOCAL RET
   
          
  chave := NTRIM(FORM_DAV.Text_CODBARRA.VALUE)
   oQuery:= oServer:Query( "Select DOlLAR,avista,qtd1,und,valor_cx From produtos WHERE codbar = " + AllTrim(chave))

 If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
If !oQuery:EOF()
For       k:=1 to oQuery:LastRec()
oRow      :=oQuery:GetRow(k)
pre_venda   :=oRow:fieldGet(1)
pre_promocao:=oRow:fieldGet(2)
qtt_caixa   :=oRow:fieldGet(3)
und         :=oRow:fieldGet(4)

 			
    FORM_DAV.Text_quant.value:=qtt_caixa
    FORM_DAV.valor_unit.VALUE:=pre_promocao
    nTotal:=(pre_promocao*FORM_DAV.Text_quant.value)
    MODIFY CONTROL valor_unit  OF FORM_DAV  Value  ''+TransForm(pre_promocao , "@R 999,999.99")
    MODIFY CONTROL TOTal1 OF Form_Dav  Value  ''+TransForm( NTotal , "@R 999,999.99")
  * MODIFY CONTROL valor_total OF FORM_DAV  Value  ''+TransForm(ntotal 	, "@R 999,999.99")
    MODIFY CONTROL und         OF FORM_DAV  Value   ''+TransForm(UND  , "@!")

DO EVENTS

Next k
EndIf  
oQuery:Destroy()


RETURN(NIL)




STATIC FUNCTION wn_mudatamanho_1
// Fun‡Æo....: Mudar o tamanho do produto -----------------------------------.
  
  chave := NTRIM(Form_Dav.Text_CODBARRA.VALUE)
   oQuery:= oServer:Query( "Select DOlLAR,avista,qtd1 From produtos WHERE codbar = " + AllTrim(chave))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	:= oQuery:GetRow(1)

		  
IF ISWINDOWDEFINED(Form_Dav)

   w_tamanhoproduto := Form_Dav.Text_fdcx.value
 IF Form_Dav.Text_fdcx.value == 1  // G
    Form_Dav.Text_quant.value:=1
    Form_Dav.valor_unit.VALUE:=oRow:fieldGet(1)
    nTotal:=(oRow:fieldGet(1)*Form_Dav.Text_quant.value)
    MODIFY CONTROL valor_unit OF Form_Dav  Value  ''+TransForm( nTotal , "@R 999,999.99")
ELSEIF Form_Dav.Text_fdcx.value== 2  // M
    Form_Dav.Text_quant.value:=oRow:fieldGet(3)
    Form_Dav.valor_unit.VALUE:=oRow:fieldGet(2)
    nTotal:=(oRow:fieldGet(2)*Form_Dav.Text_quant.value)
    MODIFY CONTROL valor_unit OF Form_Dav  Value  ''+TransForm( oRow:fieldGet(2) , "@R 999,999.99")
 ENDIF
  DO EVENTS
ENDIF
RETURN(NIL)


//*********************************  
Function pesq_proa()
//**********************************
Local cQuery      
Local oQuery      
local cPalavra:=""
local cQtdLetras:=0
local pCode:=AllTrim(STR(FORM_DAV.Text_CODBARRA.value))

FORM_DAV.Text_quant.value:=0
FORM_DAV.valor_unit.VALUE:=0
 
  oQuery:= oServer:Query( "Select codbar,produto,NCM,cust_valor,codigo,DOlLAR,avista,qtd1,und,valor_cx From produtos WHERE codbar = " + AllTrim(pCode))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor deu erro  ")
    Return Nil
  Endif
 oRow	:= oQuery:GetRow(1)
 
FORM_DAV.Text_CODBARRA.value  :=VAL(oRow:fieldGet(1))
FORM_DAV.txdescri.value       :=oRow:fieldGet(2)
ppcodigo                      :=oRow:fieldGet(5)
pre_venda                     :=oRow:fieldGet(6)
und                           :=oRow:fieldGet(9)



If !Empty(oRow:fieldGet(2)) 
     else
     MsgStop("CÓDIGO NÃO ENCONTRADO","ATENÇÃO")
	 FORM_DAV.Text_CODBARRA.setfocuS  
 Return .f.
 EndIf
oQuery:Destroy()	
*   FORM_DAV.valor_unit.VALUE:=pre_Venda
    nTotal:=(pre_venda*FORM_DAV.Text_quant.value)
    MODIFY CONTROL valor_unit  OF FORM_DAV  Value   ''+TransForm(pre_venda , "@R 99,999.99")
    MODIFY CONTROL TOTal1 OF Form_Dav  Value  ''+TransForm( NTotal , "@R 999,999.99")
  * MODIFY CONTROL valor_total OF Form_DAV  Value   ''+TransForm(nTotal    , "@R 99,999.99")
    MODIFY CONTROL und         OF FORM_DAV  Value   ''+TransForm(UND  ,  "@!")
    MODIFY CONTROL textQtd_1 OF FORM_DAV  Value  ''+TransForm(FORM_DAV.Text_quant.value   , "@R 999,999.99")
    MODIFY CONTROL unitario  OF FORM_DAV  Value  ''+TransForm(pre_venda , "@R 999,999.99")
    MODIFY CONTROL TOTal     OF FORM_DAV  Value  ''+TransForm(nTotal , "@R 999,999.99")
   
	*pegafoto(ppcodigo)
Return Nil           



//*********************************  
STATIC Function pesqproa()
//**********************************
Local cQuery      
Local oQuery      
local pCode:=AllTrim(STR(Form_Dav.Text_CODBARRA.value))


 cQuery:= "select codbar,produto,NCM,cust_valor FROM produtos WHERE codbar	= " +(pCode)         

 oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
     MsgStop(oQuery:Error())
   Form_Dav.Text_CODBARRA.setfocuS
   Return .f.
 EndIf

oRow:= oQuery:GetRow(1)
Form_Dav.Text_CODBARRA.value  :=VAL(oRow:fieldGet(1))
Form_Dav.txdescri.value       :=oRow:fieldGet(2)
  
If !Empty(oRow:fieldGet(2)) 
     else
     MsgInfo("Código Não Enntrado: " , "ATENÇÃO")
    Form_Dav.Text_CODBARRA.setfocuS  
 Return .f.
 EndIf
oQuery:Destroy()	
wn_mudatamanho()
Return Nil           

///////////////////////////////////////
STATIC FUNCTION chkvazio()
///////////////////////////////////////
if Form_Dav.Text_QUANT.VALUE > 0 
    else   
    MsgINFO("Quantidade e do Produto ‚ obrigatorio.", "Produto...")
   Form_Dav.Text_CODBARRA.setfocuS 
  * Form_Dav.Text_QUANT.SetFocus
	 
 ENDIF
RETURN(NIL)
////////////////////////////////////////////
STATIC FUNCTION chktotal()
///////////////////////////////////////////
local nTotal	  := 0
local mTotal	  := 0
local pTotal	  := 0
local oTotal	  := 0
local oqtd      :=0
local ounida    :=0
local opreco    :=0
local jicms     :=0

        
  chave := NTRIM(Form_Dav.Text_CODBARRA.VALUE)
   oQuery:= oServer:Query( "Select DOlLAR,avista,qtd1 From produtos WHERE codbar = " + AllTrim(chave))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	:= oQuery:GetRow(1)

  

    
if Form_Dav.Text_fdcx.value=1   
  nTotal:=oRow:fieldGet(1)
  pTotal:=Form_Dav.Text_quant.value
  mTotal:= nTotal*pTotal
  oqtd      := Form_Dav.Text_quant.value
  ounida    := Form_Dav.und.value  
  opreco    := oRow:fieldGet(1)
  MODIFY CONTROL textQtd_1 OF Form_Dav  Value  ''+TransForm(  oqtd  , "@R 999,999.99")
  MODIFY CONTROL und OF Form_Dav  Value  ''+TransForm(   ounida  , "@!")
  MODIFY CONTROL unitario OF Form_Dav  Value  ''+TransForm( opreco  , "@R 999,999.99")
  MODIFY CONTROL TOTal  OF Form_Dav  Value  ''+TransForm( mTotal , "@R 999,999.99")
  MODIFY CONTROL valor_unit OF Form_Dav  Value  ''+TransForm( nTotal , "@R 999,999.99")
  MODIFY CONTROL TOTal1 OF Form_Dav  Value  ''+TransForm( mTotal , "@R 999,999.99")

elseif Form_Dav.Text_fdcx.value=2
  nTotal:=oRow:fieldGet(2)
  pTotal:=Form_Dav.Text_quant.value
  mTotal:= nTotal*pTotal
  oqtd  :=Form_Dav.Text_quant.value
 
  ounida    := Form_Dav.und.value  
  opreco    := oRow:fieldGet(1)
  MODIFY CONTROL textQtd_1 OF Form_Dav  Value  ''+TransForm(  oqtd  , "@R 999,999.99")
  MODIFY CONTROL und  OF Form_Dav  Value  ''+TransForm(   ounida  , "@!")
  MODIFY CONTROL unitario OF Form_Dav  Value  ''+TransForm(    opreco   , "@R 999,999.99")
  MODIFY CONTROL TOTal OF Form_Dav  Value  ''+TransForm( mTotal , "@R 999,999.99")
  MODIFY CONTROL valor_unit OF Form_Dav  Value  ''+TransForm( nTotal , "@R 999,999.99")
  MODIFY CONTROL TOTal1 OF Form_Dav  Value  ''+TransForm( mTotal , "@R 999,999.99")
return(nil)
endif


//-----------------------------------------------
FUNCTION gravaiteNFE
// ----------------------------------------------
LOCAL cQuery,oQuery
local nnNumO:=""
local xSEQ_TEF := strzero(day(date() ),2 ) + strzero(month(date() ), 2 ) + strtran(time(), ':','' )
**xSEQ_TEF:=val(xSEQ_TEF)
*nnNumO:=LPAD((STR(xSEQ_TEF)),10,[0])
close all  
abreNFCE()
abreITEMNFCE()
abreseq_dav()

Reconectar_A() 

IF EMPTY(SEQ_DAV->ABERTO)
oQuery := oServer:Query( "Select MAX(CbdNtfNumero)FROM NFCE CbdNtfNumero")
oRow := oQuery:GetRow(1)
ncodigo:=((oRow:fieldGet(1)))
xcodigo:=((oRow:fieldGet(1)))
*MSGINFO(xcodigo)
ncodigo:=(ncodigo)+1
c_codigo:=(ncodigo)
*MSGINFO(c_codigo)
  
    Vcodigo := c_codigo
    VnSEQ_ORC:=(vCodigo)
    nNumOS := c_codigo
    vvSeq  := c_codigo
	nNumO:=LPAD(str((nNumOS)),10,[0])
    vOBS:=Alltrim((c_CAIXA))+'/'+Alltrim((nNumO)) 

  SEGNUM:=(vOBS)
  nNumOS :=(SEGNUM)
 * msgstop("Cccccccccccccccodigo -> "+alltrim((nNumOS )))
 cQuery := "UPDATE SEQ_NFCE SET seq_DAV ='"+NTRIM(Vcodigo)+"'"
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro  kkk ")
	
    Return Nil
   Endif

else

   nNumOS    := (SEQ_DAV->NUMCOD)
   vvSeq     :=  SEQ_DAV->SEQ_DAV
   VnSEQ_ORC :=  SEQ_DAV->SEQ_DAV

ENDIF 


nNumOS := nNumOS
vvSeq  := vvSeq

sele seq_Dav
IF EMPTY(seq_dav->ABERTO)
              //  MsgInfo("vou grava ")
   		               seq_dav->(dbappend())
                       seq_dav-> NUMCOD  :=nNumOS
                       seq_dav-> SEQ_DAV :=vvSeq
					   seq_dav-> ABERTO  :="ABERTO"
                       seq_dav->(dbcommit())
                       seq_DAV->(dbunlock())
			else
          endif
       
	   
   chave := NTRIM(Form_Dav.Text_CODBARRA.VALUE)
   oQuery:= oServer:Query( "Select qtd,st,cst,ncm,codigo,icms,und From produtos WHERE codbar = " + AllTrim(chave))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	  := oQuery:GetRow(1)
  
   xst    :=oRow:fieldGet(2)
   xCST   :=oRow:fieldGet(3) 
   xNCM   :=oRow:fieldGet(4)
   xcodigo:=oRow:fieldGet(5)
   xicms  :=oRow:fieldGet(6)
   xund   :=oRow:fieldGet(7)
   xicms  :=str(xicms)
  
  IF EMPTY(xNCM)
     msgexclamation('Itens Sem NCM ','Atenção')
    return(.f.)
 endif
	
  
IF oRow:fieldGet(6)=0
   xCFOP:="5403"
  ELSE
   xCFOP:="5102"
 ENDIF
 
 
 
IF Q_MINIMA="SIM"
if oRow:fieldGet(1)< Form_Dav.Text_quant.VALUE
         msgexclamation('QTD DE PRODUTO INDISPONIVEL ','Atenção')
        *Form_Dav.Text_CODBARRA.setfocus
         Form_Dav.Text_QUANT.SetFocus
         return(.f.)
    endif
ELSE 
ENDIF
SELE ITEMNFCE
Go bott
if ITEMNFCE->ITENS<=0
XXX=1
ELSE
XXX= XXX+1
ENDIF


if Form_Dav.Text_QUANT.VALUE > 0 
    else   
    MsgINFO("Quantidade e do Produto ‚ obrigat¢rio.", "Produto...")
    Form_Dav.Text_QUANT.SetFocus
  return(.f.)
 ENDIF

 
if VAL(Form_Dav.valor_unit.VALUE) > 0 
    else   
    Form_Dav.Text_CODBARRA.SetFocus
  return(.f.)
 ENDIF
 
w_barras:=STRZERO(Form_Dav.Text_CODBARRA.VALUE,13)
           if empty(Form_Dav.valor_unit.VALUE)
	       msgexclamation('O campo Preço Unitario está vazio','Atenção')
               Form_Dav.Text_QUANT.SetFocus
	       return(nil)
            endif
    XSUBTOTAL       := Form_Dav.Text_quant.value*val(Form_Dav.valor_unit.VALUE)
	XSUBTOTAL=int(XSUBTOTAL*100)/100
  
			
                        ITEMNFCE->(DBAPPEND())
                        ITEMNFCE->nseq_orc  := seq_DAV-> SEQ_DAV
                        ITEMNFCE->produto   := w_barras
                        ITEMNFCE->SUBTOTAL  := XSUBTOTAL
                     *  ITEMNFCE->SUBTOTAL  := Form_Dav.Text_quant.value*val(Form_Dav.valor_unit.VALUE)
                        ITEMNFCE->descricao := Form_Dav.txdescri.value
                        ITEMNFCE->NUMCOD    := (nNumOS) 
                        ITEMNFCE->EMISSAO    := DATE() 
                        ITEMNFCE->qtd       := Form_Dav.Text_quant.value
                        ITEMNFCE->quant     := Form_Dav.Text_quant.value
                        ITEMNFCE->valor     := val(Form_Dav.valor_unit.VALUE)
                        ITEMNFCE->preco     := val(Form_Dav.valor_unit.VALUE)
                        ITEMNFCE->st        := xst
                        ITEMNFCE->CFOP      := xCFOP
                        ITEMNFCE->CFC       := xCST
					    ITEMNFCE->NCM       := xNCM
			            ITEMNFCE->COD_PROD  := xcodigo
                        ITEMNFCE->ALIQUOTA  := val(xicms)
                        ITEMNFCE->unid      := xund
						ITEMNFCE->unidade   := xund
                        ITEMNFCE->itens     := XXX
                        ITEMNFCE->FORMULARIO:= val(xSEQ_TEF)
				        ITEMNFCE->(DBCOMMIT())
			            ITEMNFCE->(DBUNLOCK()) 
M->numero=ITEMNFCE->NSEQ_ORC
SELE NFCE                                   // arquivo alvo do lancamento
OrdSetFocus('NUMSEQ')
Seek M->numero
    
	if (!EOF())
                    If LockReg()  
                       NFCE-> NUMCOD    :=(nNumOS)
                       NFCE-> num_seq   :=seq_DAV->seq_Dav
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                   Unlock
                  ENDIF                 
               else
                 NFCE->(dbappend())
                       NFCE-> NUMCOD   :=nNumOS
                       NFCE-> num_seq  :=seq_DAV->seq_Dav
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                    endif


select ITEMNFCE
SUM SUBTOTAL TO nTtFactura 
MODIFY CONTROL Label_TOT OF Form_Dav VALUE ""  +TransForm( nTtFactura  , "@R 99,999.99")     
			
    XBARRA         :=LPAD(STR((Form_dav.Text_CODBARRA.VALUE)),13,[0])
    Cchave         :=NTRIM(Form_dav.Text_CODBARRA.VALUE)
    oQuery         :=oServer:Query( "Select CODIGO,PRODUTO,UNIT,ST,NCM,CST,QTD,DOLLAR,sit_trib,ICMS,CODBAR,MD5,und From produtos WHERE codbar = " + AllTrim(XBARRA))
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
//////////////////////////////
Aqtd       :=oRow:fieldGet(7)
Aqtd       :=Aqtd-Form_dav.Text_quant.value 
XBARRA     :=LPAD(STR((Form_dav.Text_CODBARRA.VALUE)),13,[0])
ttt:=aqtd
xcncm:=VAL(cncm)
IF Xcncm=0
cncm:="49001000"
ELSE
cncm:=cncm  
ENDIF


cQuery := "UPDATE PRODUTOS SET NCM ='"+CNCM+"',qtd ='"+NTRIM(ttt)+"' WHERE CODBAR = " + AllTrim(XBARRA)
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  Return Nil
Endif
			
w_codpro    := SPACE(0)
m->preco    := "0.00"
Form_Dav.Text_QUANT.VALUE    :=1
Form_Dav.Text_CODBARRA.VALUE := 0
ITEMNFCE->(DBGOBOTTOM())
Form_Dav.Text_CODBARRA.SETFOCUS
*Form_Dav.Browse_1.VALUE:= ITEMNFCE->(RECNO())
*Form_Dav.Browse_1.REFRESH
Form_Dav.valor_unit.VALUE:=0
fitaAdiciona()
RETURN(NIL)



function fitaAdiciona()
Static lGridFreeze := .t.
SELE ITEMNFCE
if lGridFreeze
	Form_DAV.fita.DisableUpdate // disable GRID update
endif
*nn := Form_DAV.fita.ItemCount + 1
*xx = alltrim(strZERO( nn,3 ))
 ADD ITEM {ITEMNFCE->status,strzero(ITEMNFCE->itens,3),ITEMNFCE->PRODUTO,ITEMNFCE->DESCRICAO,ITEMNFCE->unid,transform((ITEMNFCE->qtd),"999,999.999"),transform(ITEMNFCE->valor, '9,999,999.999'),transform((ITEMNFCE->SUBTOTAL)-ITEMNFCE->total,"999,999.999"),transform(ITEMNFCE->total, '9,999,999.999'),transform((ITEMNFCE->aliquota),"9,999.99"),transform(ITEMNFCE->st, '@!'),ITEMNFCE->CFOP }TO FITA OF Form_DAV
*ADD ITEM {ITEMNFCE->status,strzero(ITEMNFCE->itens,3),ITEMNFCE->PRODUTO,ITEMNFCE->DESCRICAO,ITEMNFCE->unid,transform((ITEMNFCE->qtd),"999,999.999"),transform(ITEMNFCE->valor, '9,999,999.999'),transform((ITEMNFCE->SUBTOTAL)-ITEMNFCE->total,"999,999.999"),transform(ITEMNFCE->total, '9,999,999.999'),transform((ITEMNFCE->aliquota),"9,999.99"),transform(ITEMNFCE->st, '@!')}TO FITA OF Form_DAV

  Form_DAV.fita.value:=ITEMNFCE->(RECNO())  
if lGridFreeze
Form_DAV.fita.EnableUpdate // enable GRID update
endif

return



//-------------------------------------------------------------
function Fecha_VENDA()  
//-----------------------------------------------------------------------
#include 'i_textbtn.ch'
local nCbx1 := 1
local nCbx2 := 1
local aCbx1 := { "Dinheiro", "Cartão", "Cheque" }
local aCbx2 := { "Avista", "A Prazo" }
LOCAL C_PATH
Local bColor, fColor
Local aData
abreNFCE()
abreITEMNFCE()

SELE ITEMNFCE
*Form_Dav.browse_1.Refresh
*fitaAdiciona()
SUM SUBTOTAL TO nTtFactura	

DEFINE WINDOW FORM_FECHA;
 AT 100 ,10;
 WIDTH 700;
 HEIGHT 400;
 icon cPathImagem+'jumbo1.ico';
 MODAL;
 NOSIZE 
 
  ON KEY F8 action { ||levavalor_nfe(),Reconectar_A()}
  ON KEY F9 action { ||levavalor(),Reconectar_A() }
 
		
		 DEFINE GRID Grid_1
            ROW    10
            COL    350
            WIDTH  450
            HEIGHT 250
        	HEADERS {'Código','Descricao','Valor R$' } 
			WIDTHS {80,140 ,110 } 
		    VALUE 1 
	        JUSTIFY {0,0,1,1,0,0,1,0}
            FONTNAME "Arial Baltic"
            FONTSIZE 12
			on dblclick recebe_Valor()
		   END GRID  

************************************************************************************** 

DEFINE LABEL Label_15
            ROW   30
			COL    30
            WIDTH  150
            HEIGHT 30
            VALUE "Total  R$   "  
			FONTNAME "MS Sans Serif"
            FONTSIZE 12
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
	

DEFINE LABEL Vv_total
            ROW   30
			COL   190
            WIDTH  120
            HEIGHT 30
            VALUE nTtFactura 
		    FONTNAME 'Times New Roman' 
            FONTSIZE 18
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            BACKCOLOR {191,225,255} 
            FONTCOLOR {255,0,0}
            BORDER .T.
            CLIENTEDGE .T.
		    RIGHTALIGN .T.
  END LABEL  
	 


//---------------------------------------  
 
DEFINE LABEL Label_14
            ROW    70
			COL    30
            WIDTH  150
            HEIGHT 30
            VALUE "D........... %  "  
			FONTNAME "MS Sans Serif"
            FONTSIZE 12
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
	 
	  @ 70, 190  TEXTBOX Desconto;
	  WIDTH 120 HEIGHT         30 ;
      VALUE "" ;
      FONT "Times New Roman" SIZE 18 ;
      FONTCOLOR { 255, 000, 000 };
      BACKCOLOR { 255, 255, 000 } BOLD; 
      numeric inputmask '99,999.999';
      on change {||fazdesconto()}  
 //---------------------------------------  
  

DEFINE LABEL Label_13
            ROW    110
			COL    30
            WIDTH  150
            HEIGHT 30
            VALUE "D...........R$   "  
			FONTNAME "MS Sans Serif"
            FONTSIZE 12
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
     END LABEL  
	 
   
      @ 110, 190      TEXTBOX Valor_desc;
	  WIDTH 120 HEIGHT         30 ;
      VALUE "" ;
      FONT "Times New Roman" SIZE 18 ;
      FONTCOLOR { 255, 000, 000 };
      BACKCOLOR { 255, 255, 000 } BOLD; 
      numeric inputmask '99,999.99';  
	  on enter {||pegavalor_desc(),chktrocov(),chkTROCO(),FORM_FECHA.Grid_1.SETFOCUS}  
//--------------------------------------


DEFINE LABEL Label_12
            ROW    150
            COL    30
            WIDTH  150
            HEIGHT 30
            VALUE "Total a Receber " 
			FONTNAME "MS Sans Serif"
            FONTSIZE 12
            FONTBOLD .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
     END LABEL  
	 

 DEFINE LABEL Valor_rec
            ROW    150
            COL    190
            WIDTH  120 
			HEIGHT 30
            VALUE 0
            FONTNAME 'Times New Roman' 
            FONTSIZE 18
            FONTBOLD .T.
            BACKCOLOR {191,225,255} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.
		END LABEL  
//------------------------------

DEFINE LABEL Label_11
            ROW    190
            COL    30
            WIDTH  150
            HEIGHT 30
            VALUE "Total Recebido  " 
			FONTNAME "MS Sans Serif"
            FONTSIZE 12
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
     END LABEL  
	 

 DEFINE LABEL Valor_recebido
            ROW    190
            COL    190
            WIDTH  120 
			HEIGHT 30
            VALUE 0
            FONTNAME 'Times New Roman' 
            FONTSIZE 18
            FONTBOLD .T.
            BACKCOLOR {191,225,255} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.
		END LABEL  
//------------------------------


	 
DEFINE LABEL Label_1
            ROW   230
            COL    30
            WIDTH  150
            HEIGHT 30
            VALUE "Troco r$       "
			FONTNAME "MS Sans Serif"
            FONTSIZE 12
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {0,128,255}
            BORDER .T.
            CLIENTEDGE .T.
     END LABEL  
	
   @ 230, 190    LABEL Valor_TROCO ;
      WIDTH 120 ;
      HEIGHT 30 ;
      VALUE 0;
      RIGHTALIGN;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR {0,128,255};
      BACKCOLOR { 255, 255, 000 } BOLD
 

 	 
DEFINE LABEL aguarde
            ROW   400
            COL    00
            WIDTH  350
            HEIGHT 30
            VALUE ""
			FONTNAME "MS Sans Serif"
            FONTSIZE 12
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {255,128,255}
            BORDER .T.
            CLIENTEDGE .F.
     END LABEL  
 

DEFINE BUTTON Confirma
           ROW   300
           COL    050
           WIDTH  200
           HEIGHT 030
           CAPTION "F8 Gerar NFE Empresa"
          action { ||levavalor_nfe(),Reconectar_A()}
    END BUTTON


DEFINE BUTTON Confirma1
           ROW    300
           COL    250
           WIDTH  200
           HEIGHT 030
           CAPTION "F9 Gerar NFC-e Consumidor"
           action { ||levavalor(FORM_FECHA.Vv_total.VALUE) }
    END BUTTON

	
	 
DEFINE BUTTON tximprime
           ROW    300
           COL    450
           WIDTH  200
           HEIGHT 030
           CAPTION "(ESC)CANCELA"
           action  FORM_FECHA.release
    END BUTTON
 
///------------------------------

 ON KEY ESCAPE ACTION ThisWindow.Release()
  MODIFY CONTROL Vv_Total    OF FORM_FECHA Value  ''+TransForm( nTtFactura , "@R 9,999,999.99")
  MODIFY CONTROL Valor_REC   OF FORM_FECHA Value  ''+TransForm( nTtFactura , "@R 9,999,999.99")
Grid_fill() 
END WINDOW
ACTIVATE WINDOW FORM_FECHA
Return NIL


   
FUNCTION zera_valor()
//--------------------------
local mTotal	  := 0
local zqtd        :=0  
local z_unit      :=0
MODIFY CONTROL valor_unit  OF Form_DAV  Value  ''+TransForm( z_unit , "@R 999,999.99")
return(nil)


//------------------------
FUNCTION chkmostra()
//--------------------------
local mTotal	  := 0
local zqtd        :=0  
  zqtd        :=FORM_DAV.Text_quant.value
 z_unit       :=(FORM_DAV.valor_unit.value) 

z_unit:=CHARREM(CHAR_REMOVE,z_unit)
z_unit:=val(StrTran(z_unit,',','.'))
  
  
 mtotal    :=zqtd*(z_unit)/100
  MODIFY CONTROL TOTal1 OF Form_Dav  Value  ''+TransForm( MTotal , "@R 999,999.99")
*  MODIFY CONTROL valor_total OF FORM_DAV  Value  ''+TransForm( mTotal, "@R 999,999.99")  
* MODIFY CONTROL valor_unit  OF FORM_DAV  Value  ''z_unit
* MODIFY CONTROL valor_unit  OF FORM_DAV  Value  ''+TransForm(z_unit,  "@R 999,999.99")
  MODIFY CONTROL textQtd_1   OF FORM_DAV  Value  ''+TransForm(zqtd   , "@R 999,999.99")
* MODIFY CONTROL unitario    OF FORM_DAV  Value  ''+TransForm(z_unit , "@R 999,999.99")
  MODIFY CONTROL TOTal       OF FORM_DAV  Value  ''+TransForm(mTotal , "@R 999,999.99")
 
  
return(nil)

/////////////////////////////////
STATIC FUNCTION sRemove( cString )
//////////////////////////////////
cString := STRTRAN( cString, CHR(255), " " )
cString := STRTRAN( cString, CHR(0),   " " )
RETURN( cString )
/////////////////
************************************
Function chkSUB()
//fun‡Æo PARA SUB TOTAL -------------------------------------------.

           Local DGaTotGeral        := 0
           Local DGGTotGeral        := 0
           Local DGHTotGeral        := 0
           DGHTotGeral              := oForm5.oGet3.value
           oForm5.oGet5.value:=oForm5.oGet4.value*DGHTotGeral
   Return(Nil)

  
///////////////////////////////////
Function levavalor_nfe(VALORLIQ)
///////////////////////////////////
LOCAL VV_VALOR:=0
LOCAL B_VALOR:=0
*LOCAL VALOR_ARECEBER:=0 
Local MTOTAL        := 0
Local NTOTAL        := 0
Local DGaTotGeral   := 0
Local DGGTotGeral   := 0
Local DGHTotGeral   := 0
local FORMARPAG     :="" 
local c_dinheiro    :=""
local c_cartao_credito:=""
local c_cartao_debito:=""
local c_cheque       :=""
local c_outros       :=""
local sNumSerie      :=""
local c_path         :=""
LOCAL REG            :=0
LOCAL sNumECF        :=""

PUBLIC VALOR_ARECEBER:=VALORLIQ
*msginfo('ok')

close all
abrepegaforma()
close all 
USE ((ONDETEMP)+"pegforma.DBF") VIA "DBFCDX" new alias pegforma exclusive    // arquivo que vai ter todo o conteudo do TXT
zap
PACK
CLOSE ALL 

	
abrePEGAFECHA()
abrepegaforma()
abreFORMA()
GO TOP
Do While ! forma->(Eof())
   VV_VALOR  :=VV_VALOR+FORMA->VALOR
   FORMARPAG:=ALLTRIM(FORMA->DESCRICAO)
   MTOTAL   :=str(FORMA->VALOR)
  
if FORMA->VALOR>=1 
            PEGFORMA->(dbappend())
            PEGFORMA->codigo  :=FORMA->codigo
            PEGFORMA->forma   :=FORMA->DESCRICAO
		    PEGFORMA->valor   :=FORMA->valor
		    PEGFORMA->(dbcommit())

endif
SKIP
ENDDO

VALOR_ARECEBER            := nTtFactura-FORM_FECHA.Valor_desc.value
if VV_VALOR <VALOR_ARECEBER
  MsgINFO('O Valor Digitado Não Pode Ser Menor,, Que o Valor da Venda ','Atenção')
 FORM_FECHA.GRID_1.SETFOCUS
 RETURN(.F.)
 
else
 MODIFY CONTROL Valor_recebido OF FORM_FECHA VALUE "" +TransForm( VV_VALOR , "@R 9,999,999.99")     
 NTOTAL              :=VV_VALOR-VALOR_ARECEBER
 MODIFY CONTROL Valor_TROCO OF FORM_FECHA VALUE "" +TransForm( nTOTAL, "@R 99,999.99")    
ENDIF
abreNFCE()
XNUMERO:=NFCE->num_seq
*Fecha_ITEMNFCE(XNUMERO)
wn_gravanfe()
Return 
 
   
   
///////////////////////////////////
Function levavalor(VALORLIQ)
///////////////////////////////////
LOCAL VV_VALOR:=0
LOCAL B_VALOR:=0
*LOCAL VALOR_ARECEBER:=0 
Local MTOTAL        := 0
Local NTOTAL        := 0
Local DGaTotGeral   := 0
Local DGGTotGeral   := 0
Local DGHTotGeral   := 0
local FORMARPAG     :="" 
local c_dinheiro    :=""
local c_cartao_credito:=""
local c_cartao_debito:=""
local c_cheque       :=""
local c_outros       :=""
local sNumSerie      :=""
local c_path         :=""
LOCAL REG            :=0
LOCAL sNumECF        :=""

PUBLIC VALOR_ARECEBER:=VALORLIQ
*msginfo('ok')

close all
abrepegaforma()
close all 
USE ((ONDETEMP)+"pegforma.DBF") VIA "DBFCDX" new alias pegforma exclusive    // arquivo que vai ter todo o conteudo do TXT
zap
PACK
CLOSE ALL 

	
abrePEGAFECHA()
abrepegaforma()
abreFORMA()
GO TOP
Do While ! forma->(Eof())
   VV_VALOR  :=VV_VALOR+FORMA->VALOR
   FORMARPAG:=ALLTRIM(FORMA->DESCRICAO)
   MTOTAL   :=str(FORMA->VALOR)
  
if FORMA->VALOR>=1 
            PEGFORMA->(dbappend())
            PEGFORMA->codigo  :=FORMA->codigo
            PEGFORMA->forma   :=FORMA->DESCRICAO
		    PEGFORMA->valor   :=FORMA->valor
		    PEGFORMA->(dbcommit())

endif
SKIP
ENDDO

VALOR_ARECEBER            := nTtFactura-FORM_FECHA.Valor_desc.value
if VV_VALOR <VALOR_ARECEBER
  MsgINFO('O Valor Digitado Não Pode Ser Menor,, Que o Valor da Venda ','Atenção')
 FORM_FECHA.GRID_1.SETFOCUS
 RETURN(.F.)
 
else
 MODIFY CONTROL Valor_recebido OF FORM_FECHA VALUE "" +TransForm( VV_VALOR , "@R 9,999,999.99")     
 NTOTAL              :=VV_VALOR-VALOR_ARECEBER
 MODIFY CONTROL Valor_TROCO OF FORM_FECHA VALUE "" +TransForm( nTOTAL, "@R 99,999.99")    
ENDIF
abreNFCE()
XNUMERO:=NFCE->num_seq
Fecha_ITEMNFCE(XNUMERO)
Return 

//***************************************--------------------------------------------------------------*
STATIC Function  recebe_Valor()    
*--------------------------------------------------------------*
Local Descricao:= AllTrim(GetColValue( "Grid_1", "FORM_FECHA", 2 ))
Local pCode    := AllTrim(GetColValue( "Grid_1", "FORM_FECHA", 1 ))
Local VALOR    := (GetColValue( "Grid_1", "FORM_FECHA", 3 ))
VALOR:=val(StrTran(VALOR,',','.'))
*msginfo('ok')
DEFINE WINDOW Form_4 ;
  AT 150,350 ;
  WIDTH 450;
  HEIGHT 240 ;
  MODAL;
  NOSIZE
 
  @ 20,30 LABEL Label_Code ;
    VALUE "Descricao" ;
    WIDTH 150 ;
    HEIGHT 35 ;
    BOLD

  @ 80, 30 LABEL Label_Name ;
    VALUE "Valor Recebido" ;
    WIDTH 220 ;
    HEIGHT 35 ;
    BOLD

  @ 24,100 TEXTBOX p_Code ;
    VALUE Descricao ;
    WIDTH 180 ;			
    HEIGHT 25 ;
    ON ENTER iif( !Empty(Form_4.p_Code.Value), Form_4.p_Name.SetFocus, Form_4.p_Code.SetFocus ) 
	
	
   DEFINE TEXTBOX p_qtd
            ROW    80
            COL    180
            WIDTH  100
            HEIGHT 25
			numeric .t.
			VALUE VALOR
			INPUTMASK '999,999.99'
		   ON ENTER { ||TOTAL_Record( ),salva_Record(),Grid_fill(),MOSTRA_valor(),Form_4.Release} 
     END TEXTBOX 


  @ 165,100 BUTTON Bt_Confirm ;
    CAPTION '&Confirma' ;
    ACTION { ||TOTAL_Record( ),salva_Record(),Grid_fill(),MOSTRA_valor(),Form_4.Release} 

  @ 165,300 BUTTON Bt_Cancel ;
    CAPTION '&Cancela' ;
    ACTION Form_4.Release

END WINDOW
Form_4.p_Code.Enabled:= .F.
ACTIVATE WINDOW Form_4
Return Nil



static Function fazdesconto()
          Local DDTotGeral        := 0
          Local DFTotGeral        := 0
          Local DGGTotGeral       := 0
          Local DGTotGeral        := 0
		  VALORDESCONTO           := 0
		  ddTotGeral :=(nTtFactura*FORM_FECHA.Desconto.value)/100
          FORM_FECHA.Valor_desc.value:=ddTotGeral
          DFTotGeral :=(nTtFactura-ddTotGeral)
         FORM_FECHA.Valor_REC.value:=nTtFactura-FORM_FECHA.Valor_desc.value
	  Return(Nil)
	  
	  
STATIC Function pegavalor_desc()
VALORDESCONTO:=0
DESCONTOPORC :=0
FORM_FECHA.Valor_REC.value:=nTtFactura-FORM_FECHA.Valor_desc.value
VALORDESCONTO          :=FORM_FECHA.Valor_desc.value
DESCONTOPORC           :=VALORDESCONTO/nTtFactura	
FORM_FECHA.Desconto.value :=DESCONTOPORC*100 
Return(Nil)



STATIC Function chkTROCOv()

           Local MTOTAL        := 0
           Local NTOTAL        := 0
           Local DGaTotGeral        := 0
           Local DGGTotGeral        := 0
           Local DGHTotGeral        := 0
           NTOTAL                   := nTtFactura-FORM_FECHA.Valor_desc.value
           DGHTotGeral              := nTtFactura-FORM_FECHA.Valor_desc.value
           FORM_FECHA.Valor_TROCO.value:=DGHTotGeral+FORM_FECHA.Valor_desc.value
           DGaTotGeral:= DGHTotGeral+FORM_FECHA.Valor_desc.value
     return

		   
		   //**********************************				   
STATIC Function chkTROCO()
//**********************************
           Local DGaTotGeral        := 0
           Local DGGTotGeral        := 0
           Local DGHTotGeral        := 0
		   
           DGHTotGeral              := nTtFactura-FORM_FECHA.Valor_desc.value
           DGaTotGeral:= DGHTotGeral+FORM_FECHA.Valor_desc.value
          MODIFY CONTROL Valor_ReC   OF FORM_FECHA Value  ''+TransForm( DGHTotGeral , "@R 9,999,999.99")
    Return(DGaTotGeral)

	

//******************************
static function Grid_fill() 
//*******************************
Local nCounter:= 0
Local descricao:='DINEHIRO'
Local i
local c_barras
Local oQuery
local c_encontro
LOCAL VV_VALOR:=0
LOCAL B_VALOR:=0
*LOCAL VALOR_ARECEBER:=0 
Local MTOTAL        := 0
Local NTOTAL        := 0
Local DGaTotGeral   := 0
Local DGGTotGeral   := 0
Local DGHTotGeral   := 0
local FORMARPAG     :="" 
 abreFORMA()
        delete item all from grid_1 of FORM_FECHA

       dbselectarea('forma')
       forma->(ordsetfocus('codigo'))
       forma->(dbgotop())

       while .not. eof()
          ADD ITEM {str(Forma->Codigo,3),forma->descricao,transform((FORMA->VALOR),"999,999.999") } TO Grid_1 Of FORM_FECHA
          forma->(dbskip())
       end
FORM_FECHA.Grid_1.value:=1
FORM_FECHA.Grid_1.setfocus
return(nil)




*--------------------------------------------------------------*
STATIC Function TOTAL_Record( )
*--------------------------------------------------------------*
LOCAL REG:=0
abreFORMA()
GO TOP

Do While ! FORMA->(Eof())
if FORMA->VALOR>=1 
REG:=REG+1 
endif
SKIP
ENDDO

if REG >=2
    MsgINFO('FORMA DE PAGAMENTO LIMITADA MAXIMO  2  ','Atenção ')
    FORM_FECHA.GRID_1.SETFOCUS
 Return( .F. )
 ENDIF
RETURN 


*--------------------------------------------------------------*
STATIC Function salva_Record( )
*--------------------------------------------------------------*
Local mcodigo  := AllTrim(GetColValue( "Grid_1", "FORM_FECHA", 1 ))
Local descricao:= AllTrim(GetColValue( "Grid_1", "FORM_FECHA", 2 ))
Local VALOR:= (GetColValue( "Grid_1", "FORM_FECHA", 3 ))
Local xqtd:= Form_4.p_qtd.Value
LOCAL REG:=0
mcodigo:=val(mcodigo)
abreFORMA()
GO TOP

       dbselectarea('forma')
       forma->(ordsetfocus('codigo'))
       forma->(dbgotop())
       forma->(dbseek(mcodigo))


  if .not. found()
          msgexclamation('Selecione uma informação','Atenção')
          forma->(ordsetfocus('descricao'))
          return(nil)
       else
                if lock_reg()
                   forma->valor   :=xqtd
                   Forma->(dbunlock())
                   forma->(dbgotop())
                 endif
                forma->(ordsetfocus('codigo'))
              Grid_fill() 
          endif
  
 Return Nil           


///////////////////////////////////
Function MOSTRA_valor
///////////////////////////////////
*Local pCode:= AllTrim(GetColValue( "Grid_1", "FORM_FECHA", 1 ))

LOCAL VV_VALOR:=0
LOCAL B_VALOR:=0
LOCAL VALOR_ARECEBER:=0 
Local MTOTAL        := 0
Local NTOTAL        := 0
Local DGaTotGeral   := 0
Local DGGTotGeral   := 0
Local DGHTotGeral   := 0
local FORMARPAG     :="" 
 
abreFORMA()
GO TOP

*DO WHILE !EOF()
Do While ! forma->(Eof())
   VV_VALOR  :=VV_VALOR+FORMA->VALOR
   FORMARPAG:=FORMA->DESCRICAO
	SKIP
ENDDO
 
VALOR_ARECEBER            := nTtFactura-FORM_FECHA.Valor_desc.value
     
if VV_VALOR < VALOR_ARECEBER
  MsgINFO('O Valor Digitado Não Pode Ser Menor,, Que o Valor da Venda ','Atenção')
 FORM_FECHA.GRID_1.SETFOCUS
else
 MODIFY CONTROL Valor_recebido OF FORM_FECHA VALUE "" +TransForm( VV_VALOR , "@R 9,999,999.99")     
 NTOTAL              :=VV_VALOR-VALOR_ARECEBER
 MODIFY CONTROL Valor_TROCO OF FORM_FECHA VALUE "" +TransForm( nTOTAL, "@R 99,999.99")    
ENDIF
RETURN



function Refresh_1()
Static lGridFreeze := .t.

abreNFCE()
abreITEMNFCE()
abreseq_dav()

IF ISWINDOWDEFINED(Form_DAV)
   delete item all from FITA of Form_DAV
else 
return(.f.)
ENDIF  


 dbselectarea('ITEMNFCE')
        ITEMNFCE->(dbgotop())
         while .not. eof()
  		  ADD ITEM {ITEMNFCE->status,strzero(ITEMNFCE->itens,3),ITEMNFCE->PRODUTO,ITEMNFCE->DESCRICAO,ITEMNFCE->unid,transform((ITEMNFCE->qtd),"999,999.999"),transform(ITEMNFCE->valor, '9,999,999.999'),transform((ITEMNFCE->SUBTOTAL)-ITEMNFCE->total,"999,999.999"),transform(ITEMNFCE->total, '9,999,999.999'),transform((ITEMNFCE->aliquota),"9,999.99"),transform(ITEMNFCE->st,'@!'),ITEMNFCE->CFOP}TO FITA OF Form_DAV
	   dbskip()
     end
*Form_DAV.Text_fdcx.value := 1 
Form_DAV.Text_quant.value:=0
Form_DAV.Text_CODBARRA.VALUE := ""
Form_DAV.Text_CODBARRA.SETFOCUS
return(nil)


//-------------------------------------------------------------
function Fecha_ITEMNFCE(XNUMERO)
//-----------------------------------------------------------------------
ABRENFCE()
abreITEMNFCE()

nCbx1 := 1
aCbx1 := { "Dinheiro", "Cartão", "Cheque" }
nTtFactura:=0
select ITEMNFCE
 SUM subTotal TO nTtFactura 

    //Chequeo de posibles errores
    if nTtFactura <= 0
       MsgInfo("Valor da FATURA no pode ser Menor o Igual que zero (0)", "Cupom...")
       FORM_DAV.Text_CODBARRA.SetFocus
       RETURN .F.
    endif



Define WINDOW oForm2 ;
       AT 200, 200 ;
       WIDTH 600 ;
       HEIGHT 400 ;
       TITLE "Fechamento" ;
       icon cPathImagem+'jumbo1.ico';
       MODAL;   
       NOSIZE
	   
//---------------------------------------------
  
    DEFINE LABEL oSay122
            ROW   10
			COL    10
            WIDTH  180
            HEIGHT 30
            VALUE "Nome do Cliente"
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  
  
  
     DEFINE TEXTBOX  nome_Cli 
               ROW   10
               COL   200
               WIDTH  400
               HEIGHT 40
               VALUE  "Consumidor Final"
               FONTCOLOR { 255, 000, 000 }
               BACKCOLOR { 255, 255,000} 
          *    INPUTMASK "99,999.99"
             *  NUMERIC  .F.
               ON GOTFOCUS This.BackColor:=clrBack 
               ON LOSTFOCUS This.BackColor:=clrNormal 
	           FONTNAME 'Arial'
               FONTSIZE 20
               RIGHTALIGN .F.
             END TEXTBOX 
 
 
  DEFINE LABEL oSay14
            ROW  60
			COL    10
            WIDTH  180
            HEIGHT 30
            VALUE "Cnpj/Cpf"  
			FONTNAME "MS Sans Serif"
            FONTSIZE 16
            FONTBOLD .T.
            TRANSPARENT .T.
            AUTOSIZE .F.
            FONTCOLOR {000, 000, 164}
            BORDER .T.
            CLIENTEDGE .T.
  END LABEL  

  
   
	 @ 60,200 comboboxex Pessoa_Juridica;
                   width 120;
                   items aTipoFJ;
                   value 2
     
       		 
    @ 60,350 TEXTBOX cnpj_cpf ; 
         HEIGHT 30 ; 
         WIDTH 230 ; 
		 value "";
         FONT 'ARIAL' SIZE 15;
         TOOLTIP "Digite o CNPJ ou CPF do Cliente";
         MAXLENGTH 20;
         ON ENTER {|| valida_CGC_CPF(oForm2.cnpj_cpf.VALUE,oForm2.cnpj_cpf.setfocus="") } 
	
	 		 

//----------------------------------------------


     @ 280,10 BUTTON   btGravar ;
	 CAPTION "GERAR NFCE" ;
	 FONT "Cambria";
	 SIZE 12 BOLD;
	 WIDTH 125;
	 HEIGHT 25;
	 FLAT ACTION {||Gravanfce(),aviso_nfe(),PESQ_PVENDA65(),Sair_fecha()}
         

  
      DEFINE LABEL Servico1
           * of oForm2
		    ROW   150
			COL    150
            WIDTH  190
            HEIGHT 80
            VALUE "" 
			FONTNAME 'Arial'
            FONTSIZE 20
		    FONTSIZE 20
            FONTBOLD .T.
            TRANSPARENT .F.
            AUTOSIZE .T.
          * FONTCOLOR {000, 000, 164}
	   	  * BACKCOLOR {240,240,240}
            FONTCOLOR {255,0,00}
            BORDER .T.
            CLIENTEDGE .T.
 		  BLINK .F.
  END LABEL 

  
  		@ 280,400 BUTTON  btCancelar;
		CAPTION "Voltar";
		FONT "Cambria";
		SIZE 12 BOLD;
		WIDTH 125;
		HEIGHT 25 ;
		FLAT ACTION oform2.release()
        
		 DEFINE LABEL Label_index
            ROW    350
            COL    150
            WIDTH  868
            HEIGHT 24
            FONTCOLOR {210,0,0}
     END LABEL
	    
   
END WINDOW
ACTIVATE WINDOW oForm2
Return NIL




FUNCTION valida_CGC_CPF
if oForm2.Pessoa_Juridica.value == 2 //nº 
cic(oForm2.cnpj_cpf.VALUE)
 else
cgc(oForm2.cnpj_cpf.VALUE)
endif

  

FUNCTION cic()    // função que confere os dois últimos algarismos do número informado
PARAMETER c_ic
LOCAL d_1, d_2, x_x, con_ta, digito, res_to

d_1 := 0
d_2 := 0
x_x := 1

for con_ta := 1 TO len(c_ic) - 2
   if at(subs(c_ic,con_ta,1),"/-.") == 0
      d_1 := d_1 + (11-x_x) * val(substr(c_ic,con_ta,1))
      d_2 := d_2 + (12-x_x) * val(substr(c_ic,con_ta,1))
      x_x := x_x + 1
   endif
next

res_to  := d_1 - (int(d_1/11)*11)
dig_ito := iif(res_to < 2, 0, 11-res_to)
d_2     := d_2 + 2 * dig_ito
res_to  := d_2 - (int(d_2/11) * 11)
dig_ito := val(str(dig_ito,1) + str(iif(res_to < 2, 0, 11 - res_to),1))

if dig_ito <> val(substr(c_ic,len(c_ic)-1,2))
oForm2.cnpj_cpf.value :=0
   msgstop("CPF não conferiu") 
   return .F.
else
   return .T.
endif

return nil



FUNCTION cgc()   // Função que confere os dois últimos algarismos do CNPJ
PARAMETER c_gc
LOCAL d_1, d_4, x_x, con_ta, dig_ito, res_to
d_1  := 0
d_4  := 0
x_x  := 1

for con_ta := 1 to len(c_gc) - 2
   if at(subs(c_gc,con_ta,1),"/-.")=0
      d_1 := d_1 + val(substr(c_gc,con_ta,1))*(iif(x_x<5,6,14)-x_x)
      d_4 := d_4 + val(substr(c_gc,con_ta,1))*(iif(x_x<6,7,15)-x_x)
      x_x := x_x + 1
   endif
next

res_to  := d_1-(int(d_1/11)*11)
dig_ito := iif(res_to < 2,0, 11 - res_to)
d_4     := d_4 + 2 * dig_ito
res_to  := d_4 - (int(d_4 / 11)* 11)
dig_ito := val(str(dig_ito,1) + str(iif(res_to < 2, 0, 11 - res_to),1))

if dig_ito <> val(substr(c_gc,len(c_gc)-1,2))
oForm2.cnpj_cpf.value :=0
   msgstop("CNPJ não conferiu") 
   return .F.
else
   return .T.
endif



//----------------------
FUNCTION Gravanfce()
//----------------------------------------
local nrecno:=1
local st
Local cQuery      
Local oQuery      
LOCAL NrReg:=0 
local pCode:=ntrim(200)
numeroRET:=""
numecf   :=""     
abreseq_dav()
ABRENFCE()
abreITEMNFCE()
Reconectar_A() 


Go Top
oQuery        := oServer:Query( "Select MAX(CbdNtfNumero)FROM NFCE CbdNtfNumero")
oRow          := oQuery:GetRow(1)
C_CbdNtfNumero:=((oRow:fieldGet(1)))
C_CbdNtfNumero:=C_CbdNtfNumero+1 
C_CbdNtfSerie := '1'

                       SELECT seq_dav
					   If LockReg()  
		               seq_dav-> SEQ_DAV :=C_CbdNtfNumero
					   seq_dav->(dbcommit())
                       seq_DAV->(dbunlock())
					 Unlock
                   ENDIF       
Do While !Eof()
VALOR_DESCONTO:=0
VALOR_DESCONTO1:=0
Sele ITEMNFCE


   
                xALIQUOTA := NTRIM(ITEMNFCE->ALIQUOTA)
                xnumcod   := (ITEMNFCE->numcod) 
                xNSEQ_ORC := NTRIM(C_CbdNtfNumero)   
*               xNSEQ_ORC := NTRIM(ITEMNFCE->NSEQ_ORC)   
                xCOD_PROD := NTRIM(ITEMNFCE->COD_PROD) 
                xVALOR    := NTRIM(ITEMNFCE->VALOR) 
                xQTD      := NTRIM(ITEMNFCE->QTD) 
                xSUBTOTAL := NTRIM(ITEMNFCE->(VALOR*QTd))
                xPRODUTO  := ITEMNFCE->PRODUTO
                xDESCRICAO:= ITEMNFCE->DESCRICAO 
                xQUANT    := NTRIM(ITEMNFCE->QUANT) 
                xPRECO    := NTRIM(ITEMNFCE->VALOR)
                xST       := ITEMNFCE->ST
                xDEPART   := ITEMNFCE->DEPART
			    xNCM      :=(ITEMNFCE->NCM)
                xCFC      :=(ITEMNFCE->CFC)
			    xCFOP     :=(ITEMNFCE->CFOP)
			    xUNID     :=ITEMNFCE->UNID
				xUNIDADE  :=ITEMNFCE->UNIDADE
                xITENS    :=NTRIM(ITEMNFCE->ITENS)
	            xformulario:=ntrim(ITEMNFCE->FORMULARIO)
	            xdescontoproc:=ntrim(FORM_FECHA.Desconto.value)
	            xdescontovalor:=ntrim(FORM_FECHA.Valor_desc.value)
	xCbdEmpCodigo:="1"
    CbdNtfSerie :="1"
*	msginfo(xALIQUOTA)
	
 cQuery :="INSERT INTO ITEMNFCE (CbdvAliq,CbdNtfSerie,CbdEmpCodigo,CbdNtfNumero,CbdnItem ,CbdcProd ,CbdxProd,  CbdNCM , CbdCFOP, CbduCOM,CbdqCOM,CbdvUnCom ,CbdvProd,CbdcEAN,CbdvIOF,CbdvDesc,cbdvoutro_item) VALUES ('"+xALIQUOTA+"','"+xCbdEmpCodigo+"','"+xCbdEmpCodigo+"','"+xNSEQ_ORC+"',  '"+xITENS+"','"+xCOD_PROD+"' ,'"+xDESCRICAO+"' ,'"+xNCM+"','"+xCFOP+"', '"+xUNID+"' ,'"+xQTD+"','"+xVALOR+"' ,'"+xSUBTOTAL+"','"+xPRODUTO+"','"+xCOD_PROD+"','"+xdescontoproc+"','"+xdescontovalor+"' ) "
*cQuery :="INSERT INTO ITEMNFCE (emissao,ALIQUOTA,numcod,NSEQ_ORC,COD_PROD,VALOR,QTD,SUBTOTAL,PRODUTO,DESCRICAO,QUANT,PRECO,ST,DEPART,NCM,CFC,CFOP,UNID,ITENS,UNIDADE,FORMULARIO,desconto,total)  VALUES ('"+DTOS(DATE())+"','"+xALIQUOTA+"','"+xnumcod+"','"+xNSEQ_ORC+"','"+xCOD_PROD+"','"+xVALOR+"','"+xQTD+"','"+xSUBTOTAL+"','"+xPRODUTO+"','"+xDESCRICAO+"','"+xQUANT+"','"+xPRECO+"','"+xST+"','"+xDEPART+"','"+XNCM+"','"+XCFC+"','"+(XCFOP)+"','"+XUNID+"','"+XITENS+"','"+xUNIDADE+"','"+xFORMULARIO+"','"+xdescontoproc+"','"+xdescontovalor+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 MsgInfo("Por Favor Selecione o registro ffff ") 
Endif				
 NrReg++
  skip
EndDo


set delete on

 oQuery:= oServer:Query( "Select tipo,COD_IBGE,NUMERO,bairro,email,cep,LIMITE From cliente WHERE codigo = " + AllTrim(pCode))
  If oQuery:NetErr()
    MsgInfo("Por Favor Selecione o registro que deseja alterar")
    Return Nil
 Endif

 
oRow         := oQuery:GetRow(1)
xtipo        := oRow:fieldGet(1)
xCOD_ibge    := oRow:fieldGet(2)
xNUMERO      := oRow:fieldGet(3)
xbairro      := oRow:fieldGet(4)  
xEMAIL       := oRow:fieldGet(5) 
xcep         := oRow:fieldGet(6) 
xlimite      := oRow:fieldGet(7)
xDATA_VENC   := DaTE()+xlimite  
public xNSEQ_ORC

c_bruta:=LPAD(((FORM_FECHA.Vv_total.value)),15,[0])
c_bruta:=CHARREM(CHAR_REMOVE,c_bruta)
c_bruta:=val(StrTran(c_bruta,',','.'))/100

v_bruta:=LPAD(((FORM_FECHA.Valor_REC.value)),15,[0])
v_bruta:=CHARREM(CHAR_REMOVE,v_bruta)
v_bruta:=val(StrTran(v_bruta,',','.'))/100
 
b_troco:=LPAD(((FORM_FECHA.Valor_TROCO.value)),15,[0])
b_troco:=CHARREM(CHAR_REMOVE,b_troco)
b_troco:=val(StrTran(b_troco,',','.'))/100
 
 
 FORM_FECHA.Valor_TROCO.value
           ABRENFCE()
              If LockReg()  
			           REPLACE COD_CLI   WITH   200
                       REPLACE NOM_CLI   WITH   "CONSUMIDOR FINAL"
                       REPLACE CL_CGC    WITH   oForm2.cnpj_cpf.value
			           REPLACE desc1     WITH   FORM_FECHA.desconto.value 
                       REPLACE desc2     WITH   FORM_FECHA.Valor_desc.value 
                       REPLACE DESCONTO  WITH   FORM_FECHA.Valor_desc.value 
                       REPLACE troco     WITH   b_troco
                       REPLACE VALOR_TOT WITH   C_bruta
                       REPLACE TOTAL_VEN WITH   V_bruta
					   REPLACE num_seq   WITH   C_CbdNtfNumero 
				       REPLACE CL_PESSOA WITH   "F"
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                   Unlock
                   ENDIF                 
   
************************************
                  

                       xnrped    := seq_DAV->NUMCOD 
                       xnum_seq  := ntrim(C_CbdNtfNumero)
               *       xnum_seq  := ntrim(SEQ_DAV->SEQ_DAV)
                       xDATA_ORC :=dtos(DATE())
                       xEMISSAO  :=dtos(DATE())
                       xCOD_CLI  :=ntrim(NFCE-> COD_CLI)
                       xNOM_CLI  :=NFCE-> NOM_CLI
                       xDATA_VENC:= dtos(NFCE-> DATA_VENC)
                       xCL_CGC   := NFCE-> CL_CGC 
                       xRGIE     := NFCE-> RGIE
                       xCL_END   := NFCE-> CL_END 
                       xCL_PESSOA:= NFCE-> CL_PESSOA
                       xCL_CID   := NFCE-> CL_CID
                       xestado   := NFCE-> estado
                       xALIQUOTA := ntrim(NFCE->ALIQUOTA)
                       xCOD_IBGE := (NFCE-> COD_IBGE)
                       xCEP      := NFCE-> CEP
                       xED_NUMERO:=(NFCE-> ED_NUMERO)
                       xBAIRRO   := NFCE-> BAIRRO
					   xDESCONTO := ntrim(NFCE-> DESCONTO)
                       xTOTAL_VEN:= ntrim(NFCE-> TOTAL_VEN)
                       xVALOR_TOT:= ntrim(NFCE-> VALOR_TOT)
                       xcod_doc  := ntrim(NFCE-> cod_doc)
		               xdesc1    := ntrim(NFCE-> desc1 )
    		           xdesc2    := ntrim(NFCE-> desc2 )
    		           xtroco    := ntrim(NFCE-> troco ) 
/*
   XTROCO=0
   XTROCO:=VAL(FORM_FECHA.Valor_TROCO.value)
 */
 
   XTROCO:=(XTROCO)
*  msginfo(XTROCO)
  
cQuery := "INSERT INTO  nfCE (CbdvServ,CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe,CbdNtfSerie,CbdEmpCodigo,CbdNtfNumero,CbdvProd_ttlnfe,CbdvNF,CbddEmi,CbdxNome_dest,CbdCPF_dest)  VALUES ('"+XTROCO+"','"+xDESCONTO+"','"+xdesc1+"','"+xdesc2+"','"+xCbdEmpCodigo+"','"+xCbdEmpCodigo+"','"+xnum_seq+"','"+xTOTAL_VEN+"','"+xVALOR_TOT+"','"+xEMISSAO+"','"+xNOM_CLI+"','"+xCL_CGC+"')" 
*cQuery := "INSERT INTO NFCE (vrecebido,nrped,num_seq,DATA_ORC,EMISSAO,COD_CLI,NOM_CLI,DATA_VENC,CL_CGC,RGIE ,CL_END , CL_CID ,estado,ALIQUOTA,COD_IBGE,CEP,ED_NUMERO , BAIRRO,DESCONTO, TOTAL_VEN,VALOR_TOT,cod_doc,desc1,desc2   )  VALUES ('"+XTROCO+"','"+xnrped+"','"+xnum_seq+"','"+xDATA_ORC+"','"+xEMISSAO+"','"+xCOD_CLI+"','"+xNOM_CLI+"','"+xDATA_ORC+"','"+xCL_CGC+"','"+xRGIE+"' ,'"+xCL_END+"' ,'"+xCL_CID+"','"+xestado+"','"+xALIQUOTA+"','"+xCOD_IBGE+"','"+xCEP+"','"+xED_NUMERO+"','"+xBAIRRO+"','"+xDESCONTO+"','"+xTOTAL_VEN+"','"+xVALOR_TOT+"','"+xcod_doc+"','"+xdesc1+"','"+xdesc2+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
Endif											
RETURN(NIL)


*--------------------------------------------------------------*
STATIC Function ZERA_FORMA( )
*--------------------------------------------------------------*
LOCAL REG:=0
abreFORMA()
GO TOP

Do While ! FORMA->(Eof())
 SELE FORMA
			  	 If LockReg()  
                      FORMA->VALOR= 0
                      FORMA->(dbcommit())
                      FORMA->(dbunlock())
                  Unlock
				  ENDIF
		  SKIP
ENDDO
RETURN 

	  		
			
*----------------------------------
Function PESQ_PVENDA65(XNUMERO)
*----------------------------------
 local cNome_Anterior := space(40)
 local PORCDESCONTO:=0
 local nn:=0
 
abreseq_dav()
ABRENFCE()
abreITEMNFCE()
abreitemnfe()
abreDADOSNFE()
 
public chave :=ntrim(NFCE->num_seq) 
*MSGINFO(chave)
 
 
Reconectar_A() 
 oQuery := oServer:Query( "Select ALIQUOTA_ICMS From empresa" )
 If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor verifique linha 5964")
    Return Nil
  Endif
  aRow	          :=oQuery:GetRow(1)
 public C_ALIQUOTA:=aRow:fieldGet(1)
      
 

*DQuery := oServer:Query( "Select NUM_SEQ, NRPED, cupom, data_orc, cod_cli, nom_cli, cl_cgc ,rgie, cl_end, cl_pessoa, cl_cid, cod_ibge, ed_numero, email, cep, bairro, estado, desconto, total_ven, valor_tot, desc1, desc2 ,vrecebido From NFCE WHERE NUM_SEQ = "+chave+" Order By emissao" )
 DQuery := oServer:Query( "Select CbdNtfNumero,CbdvProd_ttlnfe,CbdvNF,CbddEmi,CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe,CbdvServ,CbdxNome_dest,CbdCPF_dest  From NFCE WHERE CbdNtfNumero = "+chave+" Order By CbddEmi" )

If DQuery:NetErr()
  	MsgStop(DQuery:Error())
   MsGInfo("linha 1740  " + oServer:Error() )
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
  XTROCO          :=dRow:fieldGet(8) 
  xCOD_CLI:=200
  xNOM_CLI        :=dRow:fieldGet(9) 
  xCL_CGC         :=dRow:fieldGet(10) 
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

 
 
XTOTAL:=0
CREDITO_S:=0
nitem:=0
eQuery := oServer:Query( "Select CbdcProd ,CbdcEAN,CbdxProd,CbdnItem,CbdvProd,CbdNtfNumero,CbdNCM,CbdqCOM,CbdvUnCom,CbdUCom,CbdvDesc,cbdvoutro_item ,CbdCFOP ,CbdvAliq,cbdcsittrib From itemNFCE WHERE CbdNtfNumero ="+ntrim(xnum)+" Order By CbdxProd" )
*eQuery := oServer:Query( "Select COD_PROD,produto,descricao,itens,subtotal,nseq_orc,ncm,qtd,valor,unid,unid,CFOP From ITEMNFCE WHERE nseq_orc ="+ntrim(xnum)+" Order By descricao" )
If eQuery:NetErr()												
  MsgStop(eQuery:Error())
 MsgInfo("Por Favor Selecione o registro vamos ver ") 
Endif

For i := 1 To eQuery:LastRec()
eRow         :=eQuery:GetRow(i)
xcod_prod    :=VAL(eRow:fieldGet(1))
xproduto     :=eRow:fieldGet(2)
xdescricao   :=eRow:fieldGet(3)
xitens       :=eRow:fieldGet(4)
xsubtotal    :=eRow:fieldGet(5)
xnseq_orc    :=eRow:fieldGet(6)
xncm         :=eRow:fieldGet(7)
xqtd         :=eRow:fieldGet(8)     
xvalor       :=eRow:fieldGet(9)
xunid        :=eRow:fieldGet(10)
xCFOP        :=STR(eRow:fieldGet(13))
xicms        :=STR(eRow:fieldGet(14))
xcbdcsittrib :=val(eRow:fieldGet(15))

*	msginfo(xncm)
oQuery:= oServer:Query( "Select aliqnac From tabela_ibpt WHERE ncm = " + AllTrim(xncm))
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro sem ncm ")
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
	
	
	   
                   *  if xCancelado="Cancelado"
                  *      else    
					//	nn:=nn+1
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
						ITEMNFE->CFOP           := xCFOP
						ITEMNFE->icms           := val(xicms)
					    ITEMNFE->STB            := xcbdcsittrib
						ITEMNFE->AL_IBPT        := aliqnac
	 			        ITEMNFE->V_IBPT         := XV_IBPT
						
				        ITEMNFE->(DBCOMMIT())
                        ITEMNFE->(DBUNLOCK())
		           *  endif
	*MSGINFO(xDESCONTO)
			
	 M->numero=ITEMNFE->NSEQ_ORC
         SELE DADOSNFE
         OrdSetFocus('NUMSEQ')
         Seek M->numero

		   
				 	if (!EOF())
                    If LockReg()  
					   DADOSNFE-> VALOR_TOT  :=xTOTAL_VEN
				       DADOSNFE-> TOTAL_VEN  :=xTOTAL_VEN
				       DADOSNFE-> DESCONTO   :=xDESCONTO
				       DADOSNFE-> NUM_SEQ    :=xnum
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
                       DADOSNFE-> TROCO      :=XTROCO
				       DADOSNFE->TOTAL_IMP:=Impostos_Cupom					   
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
	                Unlock
		          ENDIF                 
               else
                     
					 
	                   DADOSNFE->(dbappend())
	   	               DADOSNFE-> NUM_SEQ    :=xnum
		               DADOSNFE->DATA_ORC    :=xDATA_ORC
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
				       DADOSNFE-> VALOR_TOT  :=xTOTAL_VEN
				       DADOSNFE-> TOTAL_VEN  :=xTOTAL_VEN
				       DADOSNFE-> DESCONTO   :=xDESCONTO
					   DADOSNFE-> TROCO      :=XTROCO
				       DADOSNFE->TOTAL_IMP:=Impostos_Cupom					   
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
                    endif
					 
				      If LockReg()  
					   DADOSNFE-> TOTAL_VEN  :=xTOTAL_VEN
                       DADOSNFE-> VALOR_TOT  :=xVALOR_TOT
                       DADOSNFE-> desc1      :=xdesc1 
    		           DADOSNFE-> desc2      :=xdesc2  
					   DADOSNFE-> TROCO      :=XTROCO
                       DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
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
//msginfo(CODPROD)

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
   *ITEMNFE->ncm         :=Cncm
   ITEMNFE->UNIT_DESC   :=ITEMNFE->valor -TOTAL
  * ITEMNFE->TOTAL_CD    :=XSUBTOTAL
   ITEMNFE->VALOR_DESC  :=XTOTAL
   ITEMNFE->(DBCOMMIT())
   ITEMNFE->(DBUNLOCK())
ENDIF		
endif


			
BTOTAL:=TOTAL+XSUBTOTAL
	
IF xCST="010"
  CCST:=000
If LockReg()    
 ITEMNFE->ALIQUOTA  :=C_ALIQUOTA
 *ITEMNFE->CST_C   :=CCST
ENDIF	

ELSEIF ITEMNFE->CST="000"
 CCST:=101
  If LockReg()    
 ITEMNFE->ALIQUOTA  :=C_ALIQUOTA
* ITEMNFE->CST_C   :=CCST
ENDIF	

ELSEIF ITEMNFE->CST="060"
 CCST:=102
  If LockReg()    
* ITEMNFE->CST_C     :=CCST
 ITEMNFE->UNIT_DESC :=0
 ITEMNFE->ALIQUOTA  :=0
 ENDIF	

ELSEIF ITEMNFE->CST="041"
 CCST:=103
 If LockReg()    
 ITEMNFE->UNIT_DESC :=0
 *ITEMNFE->CST_C   :=CCST
 ITEMNFE->ALIQUOTA :=0
 ENDIF	
ENDIF
oQuery:Skip(1)
Next

oQuery:Destroy()
XSUBTOTAL  :=0
XVALOR     :=0
XVALOR_DESC:=0
  dbselectarea('ITEMNFE')
  ITEMNFE->(dbgotop())
  dbselectarea('ITEMNFE')

//SUM SubTotal,TOTAL_CD,VALOR_DESC TO XSUBTOTAL,XVALOR,XVALOR_DESC
SUM SubTotal,TOTAL_CD,VALOR_DESC TO XSUBTOTAL,XVALOR,XVALOR_DESC

xTOTAL_VEN:=int(xTOTAL_VEN*100)/100
xVALOR_TOT:=int(xVALOR_TOT*100)/100
GERA_NFCE(DADOSNFE->NUM_SEQ)

*NFe.RELEASE
STATIC Function sumatotalNFE
RETURN
///////////////////////////////////
// GRAVA_DADOS_NFCE
//////////////////////////////////////
// Harbour MiniGUI                 
// (c)2015 -José juca 
// Modulo : Emissor de Nota Fiscal
// 14/11/2014 12:12:12
//---------------------
Function GERA_NFCE(xnum_seq)
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
local mgCODIGO  :=1
LOCAL C_CFOP     :=5102
LOCAL C_CODIGO   :=200
LOCAL sCStat :=""
Local1              := Chr(13) + Chr(10)
Local2              := 0
private nEmissao,nSaida:=date()
private mCFOP:=5102
private mPEDIDO:="",aFormaPagamento:=0,nEmail:=''
public path :=DiskName()+":\"+CurDir()
PUBLIC cPedido:=xnum_seq
******GERACAO NFE-C

Verifica_AcBR()  


Reconectar_A() 
C_CbdNtfSerie := '1'
Reconectar_A() 
 
    dbselectarea('DADOSNFE')
    ordsetfocus('NUMSEQ')
    DADOSNFE->(dbgotop())
    DADOSNFE->(dbseek(cPedido))
  
TOTALICMS:=0
NTOTAL:=0
NQTD:=0
NQTD1:=0
vv_total:=0
VV_VALOR:=0
TOTALICMS:=transform(DADOSNFE->DESC1,'9999,999,999.99')	
NTOTAL   :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')


VV_VALOR:=DADOSNFE->TOTAL_IMP/DADOSNFE->TOTAL_VEN*100
cDescricao:=transform((DADOSNFE->TOTAL_IMP),"@R 999,999.99")     +  transform((VV_VALOR),"@R 9,999.99")+"%                    FONTE IBPT" 
LIN_21:="Valor Aprox dos Tributos R$"+" "+cDescricao

COMPLEMENTO:=LIN_21

 nEmissao	:=DATE()
 nNumeroOrc := cPedido

mgIMPRIMIR_NFCe:=.T.
public tipoimpressora:="0"

IF mgIMPRIMIR_NFCe==.T. 

   If !File("DarumaFramework.DLL")
       MsgStop("Falha carregando DarumaFramework.DLL")
   *   return .f.
   EndIf


	nRet:=rStatusImpressora_DUAL_DarumaFramework()
 
	if nRet = 0  ///.OR. EMPTY(nRet)
		MSGEXCLAMATION("Erro na Comunicação com a impressora")
		nRetorno_Velocidade:=eBuscarPortaVelocidade_DUAL_DarumaFramework()
		if nRetorno_Velocidade=0 
			msginfo("Não foi possível localizar a porta de comunicação da impressora a impressao será difecionada para o Acbr.")
public tipoimpressora:="1"

		else
			msginfo("Porta configurada com sucesso. ")
			
		end                 	

		*		return
	end
 
END





 
//////////////////////empresa 
Reconectar_A() 

 oQuery := oServer:Query( "Select razaosoc,cidade,end,cep,fone_cont,bairro,estado,insc,cgc,numero,usuario,ALIQUOTA_ICMS From empresa Order By usuario" )
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
    	 C_ALIQUOTA   :=(oRow:fieldGet(12))
         mgCODIGO       :=1
		 C_CbdNtfSerie  :="1"
	     mgCODIGO       :=alltrim(str(mgCODIGO))
        C_CbdNtfNumero  :=alltrim(str(cPedido))
        C_CbdNtfSerie   :=alltrim((C_CbdNtfSerie))
        codMunEmpresa   :=alltrim(str(codMunEmpresa))  
	    VER:="JUMBO Sistema"
	
         Local3:="C:\ACBrNFeMonitor\ENTNFE.TXT" 
 
 
		 Public DADOS_IMPRESSAO_NFCE:={}

        STATUS_NFe:={}
		 aadd(STATUS_NFe,{'NFE.StatusServico'})
       
		 
         FERASE(PATH+"\ENTNFE.TXT")
		 handle:=fcreate("ENTNFE.TXT")
			for i=1 to len(STATUS_NFe)
			fwrite(handle,alltrim(STATUS_NFe[i,1]))
		      fwrite(handle,chr(13)+chr(10))
			next
		fclose(handle)  
nfantasia:="CASA DAS EMBALAGENS"

		 DADOS_NFe:={}
		
  	     aadd(DADOS_NFe,{'NFE.CriarEnviarNFe'})
		 aadd(DADOS_NFe,{'[Identificacao]'})
		 aadd(DADOS_NFe,{'NaturezaOperacao=VENDA INTERNA'})
		 aadd(DADOS_NFe,{'Modelo=65'})
		 aadd(DADOS_NFe,{'tpImp=4'})
		 aadd(DADOS_NFe,{'indFinal=1'})  /// Indica operação com Consumidor final 
		 aadd(DADOS_NFe,{'idDest=1'})  /// Indica operação com Consumidor final 
		 aadd(DADOS_NFe,{'indPres=1'})  /// Indicador de presença do comprador no estabelecimento comercial no momento da operação 
		 aadd(DADOS_NFe,{'Codigo='+C_CbdNtfNumero})
		 aadd(DADOS_NFe,{'Numero='+C_CbdNtfNumero})
		 aadd(DADOS_NFe,{'Serie=1'})
 nFormaDePagamento=1
nTipo_Emissao:=2
mCbdtpEmis:=1

    if nTipo_Emissao==1 ///gerar somente xml
		 aadd(DADOS_NFe,{'Emissao='+dtoc(date())})
	else
		 aadd(DADOS_NFe,{'Emissao='+dtoc(nEmissao)+time()})
	end

		 aadd(DADOS_NFe,{'tpEmis='+NTRIM(mCbdtpEmis)})        
		 aadd(DADOS_NFe,{'FormaPag='+alltrim(str(nFormaDePagamento))  })
		 aadd(DADOS_NFe,{'Finalidade=1'})
		 aadd(DADOS_NFe,{'ModeloDF=moNFCe'})
		 aadd(DADOS_NFe,{'VersaoDF=ve310'})


		 // Dados do emitente

		 aadd(DADOS_NFe,{'[InfNFE]'})
		 aadd(DADOS_NFe,{'Versao=3.10'})
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
	
	
	     aadd(DADOS_IMPRESSAO_NFCE,{"<ce><e><b>"+limpa(nfantasia)+"</b></e></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><e>"+nfeEmpresa+"</e></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CNPJ:"+alltrim(CNPJNFE)+" IE:"+ALLTRIM(InscEmpresa)+"</b></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>"+alltrim(endEmepresa)+","+ALLTRIM(numLogradoro)+"-"+ALLTRIM(BairroEmpresa)+"-"+ALLTRIM(MunEmpresa)+"/"+UfEmpresa+"</b></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>"+alltrim(cepEmpresa)+"-"+ALLTRIM(FoneEmpresa)+"</b></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>DANFE NFC-e - Documento Auxiliar da Nota Fiscal Eletrônica para o Consumidor Final</b></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>Não permite aproveitamento de Crédito de ICMS</b></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<c>#  |COD  |DESCRIÇÃO        |QUANT|UND|VLR UNIT|VLR ITEM</c>"})
		 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})

 
     ClienteTxtCGC          :=(DADOSNFE->CL_CGC)
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
                 // Dados do destinatário
	     aadd(DADOS_NFe,{'[Destinatario]' })
		 aadd(DADOS_NFe,{'CNPJ='+ClienteTxtCGC })
		 aadd(DADOS_NFe,{'NomeRazao='+CCbdxNome_dest})
   
 
 
////////////////////////////////////////////////////////////////////////////////	 

tt:=0



TOTALITENS:=0
registro:=0
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
		NTOTAL   :=transform(DADOSNFE->ALIQUOTA,'99,999,999.99')
	    M->CbdvCredICMSSN     := ITEMNFE->UNIT_DESC*C_ALIQUOTA/100
        nFrete_Item:=0
		xCFOP:=ITEMNFE->CFOP
			
	     aadd(DADOS_NFe,{'[Produto'+strzero(registro,3)+']' })
		 aadd(DADOS_NFe,{'CFOP=' +(xCFOP)})
		 aadd(DADOS_NFe,{'Codigo=' +ALLTRIM(ITEMNFE->PRODUTO) })
		 aadd(DADOS_NFe,{'Descricao=' +Alltrim(ITEMNFE->DESCRICAO) })
		 aadd(DADOS_NFe,{'EAN=' })
		 aadd(DADOS_NFe,{'NCM=' +ITEMNFE->ncm })
		 aadd(DADOS_NFe,{'Unidade=' +ITEMNFE->unid})
		 aadd(DADOS_NFe,{'Quantidade=' +TRANSFORM(ITEMNFE->QTD,"@! 99999999.999") })
		 aadd(DADOS_NFe,{'ValorUnitario='+ALLTRIM(TRANSFORM(ITEMNFE->Valor,"@ 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorTotal=' +ALLTRIM(TRANSFORM(ITEMNFE->SubTotal,"@ 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorDesconto=' +ALLTRIM(TRANSFORM(ITEMNFE->Valor_DESC,"@ 99999999999999.99"))  })
		 aadd(DADOS_NFe,{'vFrete='+ALLTRIM(TRANSFORM((nFrete_Item),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'NumeroDI=1' })

         xCST:=(ITEMNFE->CST_C)
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

 TOTALITENS=TOTALITENS+ITEMNFE->SubTotal
         aadd(DADOS_IMPRESSAO_NFCE,{"<c>"+TRANSFORM(registro,"999")+" "+ALLTRIM(ITEMNFE->PRODUTO)+" "+SUBSTR(ITEMNFE->DESCRICAO,1,45)+"</c>"})
 		 aadd(DADOS_IMPRESSAO_NFCE,{"<c>                        "+TRANSFORM(ITEMNFE->QTD,"@! 999999.999")+" "+ITEMNFE->unid+" X"+TRANSFORM(ITEMNFE->Valor,"@! 9,999.99")+"="+TRANSFORM(ITEMNFE->QTD*ITEMNFE->Valor,"@! 9,999.99")+"</c>"})
    
 
ITEMNFE->(dbskip())
ENDD  
/*
          // Total da nota
	   
		           // Total da nota
	   
			nTotal_Itens   :=DADOSNFE-> VALOR_TOT 
			nTotalBase     :=DADOSNFE-> TOTAL_VEN 
			mValor_Desconto:=DADOSNFE-> DESCONTO
			mValor_Frete   :=0
			nTotal_ICMS    :=0
			nTotalBaseA    :=0
		    mValor_IPI     :=0
		    nTotal_Pis     :=0
			nTotal_Cofins  :=0
		   CCbdmodFrete    := 9
		
		 aadd(DADOS_NFe,{'[Total]' })
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM((nTotal_Itens),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'BaseICMS='+ALLTRIM(TRANSFORM((nTotalBaseA),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorICMS='+ALLTRIM(TRANSFORM((nTotal_ICMS),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorProduto='+ALLTRIM(TRANSFORM((nTotal_Itens),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorNota='+ALLTRIM(TRANSFORM((nTotalBase),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorDesconto='+ALLTRIM(TRANSFORM((mValor_Desconto),"@! 999999999999.99")) })
	     aadd(DADOS_NFe,{'ValorIPI='+ALLTRIM(TRANSFORM((mValor_IPI),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorPIS='+ALLTRIM(TRANSFORM((nTotal_Pis),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorCOFINS='+ALLTRIM(TRANSFORM((nTotal_Cofins),"@! 999999999999.99")) })
         
		*/



              // Total da nota
	   
			nTotal_Itens   :=DADOSNFE-> VALOR_TOT 
			nTotalBase     :=DADOSNFE-> TOTAL_VEN 
			mValor_Desconto:=DADOSNFE-> DESCONTO
			mValor_Frete   :=0
			nTotal_ICMS    :=0
			nTotalBaseA    :=0
		
		 aadd(DADOS_NFe,{'[Total]' })
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM((nTotal_Itens),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'BaseICMS='+ALLTRIM(TRANSFORM((nTotalBaseA),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorICMS='+ALLTRIM(TRANSFORM((nTotal_ICMS),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorProduto='+ALLTRIM(TRANSFORM((nTotal_Itens),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorNota='+ALLTRIM(TRANSFORM((nTotalBase),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorDesconto='+ALLTRIM(TRANSFORM((mValor_Desconto),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorFrete='+ALLTRIM(TRANSFORM((mValor_Frete),"@! 999999999999.99")) })
		
		  CCbdmodFrete           := 9
		 xCbdCNPJ_transp        :=""
		 xCbdxNome_transp       :=""
		 xCbdIE_transp          :=""
		 xCbdxEnder             :=""
		 xCbdxMun_transp        :=""
		 xCbdUF_transp          :=""
		 xCbdplaca              :=""
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

public xXTROCO:=DADOSNFE-> TROCO


abreFORMA()
GO TOP
OrdSetFocus('codigo')
Do While ! forma->(Eof())



nFormaDePagamento   :=FORMA->codigo

  if FORMA->VALOR<1
      forma->(dbskip())
    loop
   end if


	IF  nFormaDePagamento=1
	tt++
		xtPag:='01'
		MTOTAL  :=FORMA->VALOR-xXTROCO

		aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTAL,"@! 99999999.99") })	
	elseif  nFormaDePagamento==2
	tt++
		MTOTAL  :=FORMA->VALOR
		
		xtPag:='02'
        aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTAL,"@! 99999999.99") })	
			
	elseif  nFormaDePagamento=3
	tt++
		xtPag:='03'
		MTOTAL  :=FORMA->VALOR
		aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTAL,"@! 99999999.99") })	
		
		elseif  nFormaDePagamento==4
		tt++
		MTOTAL  :=FORMA->VALOR
		xtPag:='04'
        aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTAL,"@! 99999999.99") })	
		
	elseif  nFormaDePagamento==5
		tt++
		MTOTAL  :=FORMA->VALOR
		xtPag:='05'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTAL,"@! 99999999.99") })	
			
   
   	elseif  nFormaDePagamento==99
		tt++
		MTOTAL  :=FORMA->VALOR
		xtPag:='99'
	    aadd(DADOS_NFe,{'[pag'+strzero(tt,3)+']' })
	    aadd(DADOS_NFe,{'tpag='+(xtPag)})		
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(MTOTAL,"@! 99999999.99") })	
	ENDIF

FORMA->(dbskip())
ENDDO

 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
 		aadd(DADOS_IMPRESSAO_NFCE,{"<b>QTD. TOTAL DE ITENS                          "+TRANSFORM(registro-1 ,"999")  +"</b>"})
	if mValor_Desconto>0
 		aadd(DADOS_IMPRESSAO_NFCE,{"<b>TOTAL DOS ITENS R$                 "+TRANSFORM(nTotal_Itens ,"@! 99,999,999.99")  +"</b>"})
 		aadd(DADOS_IMPRESSAO_NFCE,{"<b>(-)DESCONTO R$                     "+TRANSFORM(mValor_Desconto,"@! 99,999,999.99")  +"</b>"})
	end
 		aadd(DADOS_IMPRESSAO_NFCE,{"<b>VALOR TOTAL R$                     "+TRANSFORM(nTotal_Itens-mValor_Desconto,"@! 99,999,999.99")  +"</b>"})
 		aadd(DADOS_IMPRESSAO_NFCE,{"<b>FORMA DE PAGAMENTO                    Valor Pago</b>"})
		aadd(DADOS_IMPRESSAO_NFCE,{"<b>Troco R                          "+TRANSFORM(XTROCO,"@! 99,999,999.99")+"</b>"})
	     ClienteTxtCGC           :=(DADOSNFE->CL_CGC)
         CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	  
		 aadd(DADOS_NFe,{'[Destinatario]' })
		 aadd(DADOS_NFe,{'indIEDest='+"9"})
		 aadd(DADOS_NFe,{'NomeRazao='+CCbdxNome_dest}) 
	 	 aadd(DADOS_NFe,{'CNPJ='+ClienteTxtCGC })

	
 xCbdinfCpl	  	 	  := COMPLEMENTO
  m->CbdinfCpl:=""
 aadd(DADOS_NFe,{'[DadosAdicionais]' })
 aadd(DADOS_NFe,{'Complemento='+xCbdinfCpl })
 aadd(DADOS_NFe,{'Fisco='+alltrim(substr(m->CbdinfCpl,1,5000))})

 
 cFileDanfe:="C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
 lRetStatus:=EsperaResposta(cFileDanfe) 
        if lRetStatus==.t.  ////pego os dados
       end
cFileDanfe := "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
XAmbiente:=""

////////////////////////////////////////////////////////////////////////
 ////RETORNO////
	BEGIN INI FILE cFileDanfe
       GET XAmbiente         SECTION  "WebService"    ENTRY "Ambiente"
	END INI


mgambiente_nfe:=ALLTRIM(XAMBIENTE)
	
		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
 	    aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>AREA DE MENSAGEM DE INTERESSE DO CONTRIBUITE</b></ce>"})
 		aadd(DADOS_IMPRESSAO_NFCE,{"<c>"+alltrim(xCbdinfCpl)+"</c>"})
 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})

		
		if mgambiente_nfe="1"
    	aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>EMTIDA EM AMBENTE DE HOMOLOGACAO - SEM VALOR FISCAL</c></ce>"})
		end                                                                                     
        aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
 	   	aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>NAO TROCAMOS MERCADORIA EXCETO QUANTO COM  DEFEITO DE FABRICACAO CONFORME ART.18 CDC  </c></ce>"})
   	    aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})

	
	
 HANDLE :=  FCREATE (path+"\NOTA.TXT",0)// cria o arquivo
	for i=1 to len(DADOS_NFe)
		fwrite(handle,alltrim(DADOS_NFe[i,1]))
        fwrite(handle,chr(13)+chr(10))
	next
fclose(handle)  
public cTXT     :=PATH+"\NOTA.TXT"
public cDestino :=PATH+"\NOTA.TXT"
xcml:=memoread(cDestino) 

*******************************

                     SELE NFCE 
                    If LockReg()  
                       NFCE->NUM_SEQ := 0 
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                 Unlock
                 ENDIF   
				 SELE SEQ_DAV
			  	 If LockReg()  
                      seq_DAV-> ABERTO   :=""
                      seq_DAV->(dbcommit())
                      seq_DAV->(dbunlock())
                  Unlock
				  ENDIF


*MSGINFO("VEJAMOS SE DEU CERTO")


status_nfe()
*INICIA O ENVIO 
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
LOCAL Ret_Status_Servico:=.T.
local R_DigVal:=''
local R_DhRecbto:='' 
public nnfe:="NFE"+(chave)

cTXT:=PATH+"\NOTA.TXT"
////////////////////////CRIAR NOTA NFE///////////////////////



dt_server:=date()
hora_server:=time()
**-------------------------------------
//*** VERIFICA SE TEM INTERNET 
**-------------------------------------
 lRetorno_Internet:=IsInternet()
  if lRetorno_Internet==.f.
   xJust:="Sem acesso a Internet" 
     Ret_Status_Servico:=.f.
    else
   end                 

   
   if Ret_Status_Servico==.f.
    BEGIN INI FILE path+"\nota.txt"
      SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
      SET SECTION "Identificacao"  ENTRY "dhCont"  TO dtoc(dt_server)+hora_server ///contingencia para NFCe
      SET SECTION "Identificacao"  ENTRY "xJust"  TO xJust ///contingencia para NFCe
    END INI
    MY_WAIT( 2 ) 
    BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
      SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '1'
    END INI
     ProcedureLerINI()
    cContingencia:=.t.
    mCbdtpEmis:=9  ///contingencia para NFCe
   end                
  
NFe_XML(cTXT )
////////////////////////////////////////////////////////////
nFe_VAL(alltrim(cSAIDA_XML))
PEGO_ChNFe:=SUBSTR(cSAIDA_XML, 20, 44)
nuNFe  :=SUBSTR(cSAIDA_XML, 55, 8)




/*

if PEGO_ChNFe="OK:"
else
msginfo(C_XMotivo,"ATENÇÃO")
MsgInfo('Chave não Valida', "ATENÇÃO")
return (.f.)
endif 

*/



oForm2.Label_index.value:=alltrim((nuNFe))+"-->> Notas Fiscais Enviadas"
 if lRetorno_Internet==.f.
    mCbdtpEmis:=9
     else
    mCbdtpEmis:=1
end



cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
 lRetStatus:=EsperaResposta(cFileDanfe) 
        if lRetStatus==.t.  ////pego os dados
       end
cFileDanfe := 'C:\ACBrNFeMonitor\sainfe.txt'


////////////////////////////////////////////////////////////////////////
 ////RETORNO////
	BEGIN INI FILE cFileDanfe
       GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
	   GET c_ChNFe          SECTION  nnfe            ENTRY "ChNFe"      // chave nfe  
	END INI
public  RR_CStat   :=R_CStat
public C_XMotivo :=R_XMotivo
public cc_ChNFe  :=PEGO_ChNFe
PUBLIC CCC_DhRecbto:=""
PUBLIC CCC_DigVal:=""
PUBLIC Ccc_NProt:=""
*MSGINFO(cc_ChNFe)
*MSGINFO(nuNFe)


**---------------------------------
//SE TEM INTERNET E VALIDOU ENVIA
*--------------------------------
if Ret_Status_Servico=.T.
                            // tiver internet
                            //vamos enviar 
NFe_ENV(alltrim(cSAIDA_XML))
else
                             //se nao tiver internet
c_NProt:=""
GRAVA_nfe1(nuNFe,mCbdtpEmis,Cc_ChNFe,c_NProt)
XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+xml
   
  
   //vamos imprimir 
if tipoimpressora="1"
msginfo("acbr")

NFe_IMP(alltrim(fxml))
*imprimidaruma_contigencia(cC_ChNFe,nuNFe,CCC_DhRecbto,CCC_DigVal,CCC_NProt)
else 
*NFe_IMP(alltrim(fxml))
imprimidaruma_contigencia(cC_ChNFe,nuNFe,CCC_DhRecbto,CCC_DigVal,CCC_NProt)
*msginfo("Daruma")
endif

endif


cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
 lRetStatus:=EsperaResposta(cFileDanfe) 
        if lRetStatus==.t.  ////pego os dados
       end
cFileDanfe := 'C:\ACBrNFeMonitor\sainfe.txt'


**---------------------------------
//SE TEM INTERNET E ENVIOU PEGA O RETORNO 
*--------------------------------

*if RR_CStat="103"   ///se enviarou 
if Ret_Status_Servico==.T.
 ////RETORNO////
	BEGIN INI FILE cFileDanfe
       GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
   	   GET c_DhRecbto       SECTION  "ENVIO"         ENTRY "DhRecbto"   // DADA E HORA 
       GET c_ChNFe          SECTION  nnfe            ENTRY "ChNFe"      // chave nfe  
	   GET R_DigVal         SECTION  nnfe            ENTRY "DigVal"      
	   GET R_DhRecbto       SECTION  nnfe            ENTRY "DhRecbto"       
       GET c_NProt          SECTION  nnfe            ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
  END INI
public  RR_CStat :=R_CStat
public C_XMotivo :=R_XMotivo
public cc_ChNFe  :=c_ChNFe
public c_nuNFe   :=nuNFe
public cR_DigVal :=R_DigVal
public cc_NProt  :=c_NProt
public cc_DhRecbto:=c_DhRecbto


if RR_CStat="100"
*msginfo("1"+R_XMotivo)
XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+xml
GRAVA_nfe1(nuNFe,mCbdtpEmis,cc_ChNFe,c_NProt)
*NFe_IMP(alltrim(fxml))
*msginfo(cc_ChNFe)
*imprimidaruma(c_ChNFe,c_nuNFe,R_DhRecbto,cR_DigVal,cc_NProt)


if tipoimpressora="1"
NFe_IMP(alltrim(fxml))
*imprimidaruma(c_ChNFe,c_nuNFe,R_DhRecbto,cR_DigVal,cc_NProt)
else 
*msginfo("2")
 imprimidaruma(c_ChNFe,c_nuNFe,R_DhRecbto,cR_DigVal,cc_NProt)
*NFe_IMP(alltrim(fxml))
endif



ELSE
msginfo(R_XMotivo)

 cQuery:= "DELETE FROM nfce WHERE CbdNtfNumero = " + (c_nuNFe)         
		 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
	*  msginfo("ok deletado nfce")
	EndIf
cQuery:= "DELETE FROM itemnfce WHERE CbdNtfNumero = " + (c_nuNFe)         
		 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
	*	  msginfo("ok itemnfce")
	EndIf
  
 
return(.f.)
endif
ENDIF
RETURN
	
//******************************************************
Function imprimidaruma(c_ChNFe,c_nuNFe ,R_DhRecbto,R_DigVal,c_NProt)	
//******************************************************
CbdNtfNumero:=val(c_nuNFe) 
CbdNtfSerie :=1
dt_server  :=date()
hora_server:=time()
mValor_Seguro:=0
mValor_Despesas:=0
nIcms_ST:=0
abreDADOSNFE()

mCNPJ_DESTINATARIO:=(DADOSNFE->CL_CGC)
nTotal_Itens      :=DADOSNFE-> VALOR_TOT 
nTotalBase        :=DADOSNFE-> TOTAL_VEN 
mValor_Desconto   :=DADOSNFE-> DESCONTO
CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
		
nTotal_ICMS:=0
nTotal_ICMS_Frete_por_ITem:=0
mValor_IPI:=0		
mValor_Seguro:=0
mValor_Despesas:=0
mValor_Frete:=0
nIcms_ST:=0


nTotal_ICMS:=0
nTotal_ICMS_Frete_por_ITem:=0
		
 
                                               m->CbdvNF := (nTotal_Itens+mValor_IPI+mValor_Seguro+mValor_Despesas+mValor_Frete+nIcms_ST)-mValor_Desconto
					                           /// Montar Hash QR Code
												sCodigoHASH_NFCe:=Gera_Codigo_HASH_NFCe(c_ChNFe,mCNPJ_DESTINATARIO,R_DhRecbto,m->CbdvNF,(nTotal_ICMS+nTotal_ICMS_Frete_por_ITem),R_DigVal)
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Numero "+strzero(m->CbdNtfNumero,9)+" Série "+strzero((m->CbdNtfSerie),3)+" Emissão "+dtoc(dt_server)+hora_server+"</c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>Consulta pela Chave de Acesso em</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp<c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CHAVE DE ACESSO</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>"+c_ChNFe+"</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CONSUMIDOR</b></ce>"})
								 		   if !empty(LIMPA(mCNPJ_DESTINATARIO))
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>CNPJ/CPF/ID Estrangeiro: "+mCNPJ_DESTINATARIO+"</ce>"})
	                                	 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>NOME DO DESTINATARIO   : "+alltrim(CCbdxNome_dest)+"</ce>"})
	                                 	 else
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>CONSUMIDOR NAO IDENTIFICADO</ce>"})    
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>SEM NUMERO</ce>"})
                                    end
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Consulta Via Leitor de QR Code</c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><qrcode><lmodulo>3</lmodulo>"+sCodigoHASH_NFCe+"</qrcode></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Protocolo Autorização "+c_NProt+" "+R_DhRecbto+"</c></ce><sl>4</sl><gui></gui><l></l>"})
		
		 								      	cTXT:=''
													for i=1 to len(DADOS_IMPRESSAO_NFCE)
													   cTXT+= alltrim(DADOS_IMPRESSAO_NFCE[i,1])+chr(13)+chr(10)
													next
													
							

			 
						 	iImprimirTexto_DUAL_DarumaFramework(cTXT)		

RETU



	
//******************************************************
Function imprimidaruma_contigencia(c_ChNFe,c_nuNFe ,R_DhRecbto,R_DigVal,c_NProt)	
//******************************************************
CbdNtfNumero:=val(c_nuNFe) 
CbdNtfSerie :=1
dt_server  :=date()
hora_server:=time()
mValor_Seguro:=0
mValor_Despesas:=0
nIcms_ST:=0
abreDADOSNFE()

mCNPJ_DESTINATARIO:=(DADOSNFE->CL_CGC)
nTotal_Itens      :=DADOSNFE-> VALOR_TOT 
nTotalBase        :=DADOSNFE-> TOTAL_VEN 
mValor_Desconto   :=DADOSNFE-> DESCONTO
nTotal_ICMS:=0
nTotal_ICMS_Frete_por_ITem:=0
mValor_IPI:=0		
mValor_Seguro:=0
mValor_Despesas:=0
mValor_Frete:=0
nIcms_ST:=0


nTotal_ICMS:=0
nTotal_ICMS_Frete_por_ITem:=0

                                               m->CbdvNF := (nTotal_Itens+mValor_IPI+mValor_Seguro+mValor_Despesas+mValor_Frete+nIcms_ST)-mValor_Desconto
					                           /// Montar Hash QR Code
												sCodigoHASH_NFCe:=Gera_Codigo_HASH_NFCe(c_ChNFe,mCNPJ_DESTINATARIO,R_DhRecbto,m->CbdvNF,(nTotal_ICMS+nTotal_ICMS_Frete_por_ITem),R_DigVal)
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Numero "+strzero(m->CbdNtfNumero,9)+" Série "+strzero((m->CbdNtfSerie),3)+" Emissão "+dtoc(dt_server)+hora_server+"</c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>Consulta pela Chave de Acesso em</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp<c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CHAVE DE ACESSO</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>"+c_ChNFe+"</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CONSUMIDOR</b></ce>"})
								 		   if !empty(LIMPA(mCNPJ_DESTINATARIO))
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>CNPJ/CPF/ID Estrangeiro: "+mCNPJ_DESTINATARIO+"</ce>"})
								 		   else
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>CONSUMIDOR NAO IDENTIFICADO</ce>"})    
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>SEM NUMERO</ce>"})
								 			end
                                           	 *   aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
 											  * 	aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>NFC-E EMITIDO EM CONTIGENCIA</c></ce>"})
                                           	  *  aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
 	
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Consulta Via Leitor de QR Code</c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><qrcode><lmodulo>3</lmodulo>"+sCodigoHASH_NFCe+"</qrcode></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		
											 if !empty(LIMPA(c_NProt))
											 aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Protocolo Autorização "+c_NProt+" "+R_DhRecbto+"</c></ce><sl>4</sl><gui></gui><l></l>"})
		 		                             else
                                             aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Protocolo Autorização "+"EMITIDO EM CONTIGENCIA"+" "+hora_server+"</c></ce><sl>4</sl><gui></gui><l></l>"})
		 		                    		 end
                                        
												
		 								      	cTXT:=''
													for i=1 to len(DADOS_IMPRESSAO_NFCE)
													   cTXT+= alltrim(DADOS_IMPRESSAO_NFCE[i,1])+chr(13)+chr(10)
													next
													
							

			 
						 	iImprimirTexto_DUAL_DarumaFramework(cTXT)		

RETU






//------------------------------------------------------------------------------ 
procedure Gera_Codigo_HASH_NFCe(edChNFe,edCPF,edData,edTotal,edICMS,edDigestVal) 
Local Texto:=''
Local Cripto:=''
mgAmbiente_NFe:=2
mgIDToken:='054298441341372018'
vcIdToken :="000001"
edData:=alltrim(  strtran(strtran(edData,[/],[-]),[ ],[T]),[.],[])+"-04:00" 
                                              
   /*
   Primeiro Passo: Concatenar todos esses campos transformando para HEXADECIMAL da DATA e o DigestVAL
   					 Colocar sempre em Caixa Alta (UPPER-Comando xHarbour)
   */
   Texto := 'chNFe=' + edChNFe + ;
      '&nVersao=100'  +;
      '&tpAmb=' + alltrim(str(mgAmbiente_NFe)) +;
      If (Len(limpa(edCPF)) > 0, '&cDest=' + limpa(edCPF) , '') +;
      '&dhEmi=' + UPPER(TextToHex(edData)) +  ;
      '&vNF=' + ALLTRIM(transf((edTotal),'99999999.99'))	  +;
      '&vICMS=' + ALLTRIM(transf((edICMS),'99999999.99'))  +  ;
      '&digVal=' + UPPER(TextToHex(edDigestVal))+;
	 '&cIdToken=' + alltrim(vcIdToken)  
   /*
	Segundo Passo: Aplicar o algoritmo SHA-1 sobre todos os parâmetros concatenados, 
						mais o Token do Contribuite
	*/
	
   Cripto := UPPER(hb_SHA1(Texto+Alltrim(mgIDToken))	)
   
   
   /*
   Terceiro Passo: Adicione o resultado sem o CSC (Token) e gere a imagem do QR Code: 
						 1º parte (endereço da consulta) + 
						 2º parte (Codigo ).

	*/
   Texto := 'http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp?' +;
      		Texto + '&cHashQRCode=' + Cripto 

		 handle:=fcreate("QRCODE.TXT")
		 Fwrite(handle,Texto)
 		 fclose(handle)  

Return Texto


//------------------------------------------------------------------------------
Static Function TextToHex(sTexto)
 
Local cTexto:=''

	for i=1 to len(sTexto)
		cN:=BIN2I(SubStr(sTexto,i,1))
		cTexto+=alltrim(( DECTOHEXA(cN) ) )
	next

return cTexto





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


//------------------------------------------------------------------
FUNCTION SAIR_nfe
//---------------------------------------------
ZERA_FORMA()

FORM_FECHA.release
Form_dav.RELEASE
CLOSE ALL 
abreseq_nfe()
CLOSE ALL 
USE ((ondeTEMP)+"SEQ_NFE.DBF") new alias SEQ_NFE exclusive   
zap
PACK

CLOSE ALL 
USE ((ondeTEMP)+"NFCE.DBF") new alias NFCE exclusive   
zap
PACK

CLOSE ALL 
USE ((ondeTEMP)+"SEQ_DAV.DBF") new alias SEQ_DAV exclusive   
zap
PACK

RETURN 






// Fim da fun‡Æo de gerar tela de splash ------------------------------------.
// --------------------------------------------------------------------------.
static FUNCTION aviso_nfe()
Local cValue := ""
Local teste  := ""
Local teste1  := ""
Local teste3  := ""
local datahorarec:=""
local RETORNO:=""
local xstatus:=""
MODIFY CONTROL Servico1 of oForm2 VALUE   'Aguarde Gerando a nfc-e' 
return
*------------------------------------------------------------------------------*
** FIM FECHAMENTO EM DINHEIRO 
*------------------------------------------------------------------------------*
STATIC Function Sair_fecha()
Form_DAV.release
FORM_FECHA.release
oForm2.release
RETURN(NIL)


//----------------------
FUNCTION wn_gravanfe()
//----------------------------------------
local nrecno:=1
local st
Local cQuery      
Local oQuery      
LOCAL NrReg:=0 
local pCode:=ntrim(200)
numeroRET:=""
numecf   :=""     
abreNFCE()
abreITEMNFCE()
abreseq_nfe()


IF EMPTY(SEQ_NFE->ABERTO)
*oQuery := oServer:Query( "Select MAX(seq_DAV)FROM SEQ_NFE seq_DAV")
oQuery        := oServer:Query( "Select MAX(CbdNtfNumero)FROM NFE20 CbdNtfNumero")
oRow := oQuery:GetRow(1)
ncodigo:=((oRow:fieldGet(1)))
xcodigo:=((oRow:fieldGet(1)))
ncodigo:=(ncodigo)+1

*MSGINFO(xcodigo)
c_codigo:=(ncodigo)

    Vcodigo := c_codigo
    VnSEQ_ORC:=(vCodigo)
    nNumOS := c_codigo
    vvSeq  := c_codigo
	nNumO:=LPAD(str((nNumOS)),10,[0])
    vOBS:=Alltrim((c_CAIXA))+'/'+Alltrim((nNumO)) 

  SEGNUM:=(vOBS)
  nNumOS :=(SEGNUM)
 * msgstop("Cccccccccccccccodigo -> "+alltrim((nNumOS )))
 cQuery := "UPDATE SEQ_NFE SET seq_DAV ='"+NTRIM(Vcodigo)+"'"
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
	
    Return Nil
   Endif

else

   nNumOS    := (SEQ_NFE->NUMCOD)
   vvSeq     :=  SEQ_NFE->SEQNFE
   VnSEQ_ORC :=  SEQ_NFE->SEQNFE

ENDIF 


nNumOS := nNumOS
vvSeq  := vvSeq

sele seq_NFE
IF EMPTY(seq_NFE->ABERTO)
              //  MsgInfo("vou grava ")
   		               seq_NFE->(dbappend())
                       seq_NFE-> NUMCOD  :=nNumOS
                       seq_NFE-> SEQNFE :=vvSeq
					   seq_NFE-> ABERTO  :="ABERTO"
                       seq_NFE->(dbcommit())
                       seq_NFE->(dbunlock())
			else
          endif
     
	 
*abreseq_NFE()
ABRENFCE()
abreITEMNFCE()
Sele ITEMNFCE
*MSGINFO(C_CbdNtfNumero)

C_CbdNtfNumero:=seq_NFE->SEQNFE
*MSGINFO(C_CbdNtfNumero)
Go Top




Do While !Eof()
VALOR_DESCONTO:=0
VALOR_DESCONTO1:=0
Sele ITEMNFCE


   
                xALIQUOTA := ntrim(ITEMNFCE->icms)
                xnumcod   := (ITEMNFCE->numcod) 
                xNSEQ_ORC := NTRIM(C_CbdNtfNumero)   
*               xNSEQ_ORC := NTRIM(ITEMNFCE->NSEQ_ORC)   
                xCOD_PROD := NTRIM(ITEMNFCE->COD_PROD) 
                xVALOR    := NTRIM(ITEMNFCE->VALOR) 
                xQTD      := NTRIM(ITEMNFCE->QTD) 
                xSUBTOTAL := NTRIM(ITEMNFCE->(VALOR*QTd))
                xPRODUTO  := ITEMNFCE->PRODUTO
                xDESCRICAO:= ITEMNFCE->DESCRICAO 
                xQUANT    := NTRIM(ITEMNFCE->QUANT) 
                xPRECO    := NTRIM(ITEMNFCE->VALOR)
                xST       := ITEMNFCE->ST
                xDEPART   := ITEMNFCE->DEPART
			    xNCM      :=(ITEMNFCE->NCM)
                xCFC      :=(ITEMNFCE->CFC)
			    xCFOP     :=(ITEMNFCE->CFOP)
			    xUNID     :=ITEMNFCE->UNID
				xUNIDADE  :=ITEMNFCE->UNIDADE
                xITENS    :=NTRIM(ITEMNFCE->ITENS)
	            xformulario:=ntrim(ITEMNFCE->FORMULARIO)
	            xdescontoproc:=ntrim(FORM_FECHA.Desconto.value)
	            xdescontovalor:=ntrim(FORM_FECHA.Valor_desc.value)
xCbdEmpCodigo:="1"
*msginfo(xALIQUOTA)

   oQuery:= oServer:Query( "SELECT CbdNtfNumero FROM `nfeitem` WHERE CbdNtfNumero = "+ntrim(C_CbdNtfNumero)+" and CbdnItem = "+xITENS+"  Order By CbdNtfNumero" )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro  ")
    Return Nil
  Endif
  oRow	:= oQuery:GetRow(1)
  xnota  :=oRow:fieldGet(1)

IF xnota=0

 *cQuery :="INSERT INTO nfeitem (CbdEmpCodigo, CbdNtfNumero,CbdNtfSerie, CbdnItem ,CbdcProd,CbdcEAN,CbdxProd,CbdNCM ,CbdEXTIPI,Cbdgenero, CbdCFOP, CbduCOM,CbdqCOM,CbdvUnCom ,CbdvProd,CbduTrib,CbdqTrib,CbdvUnTrib,CbdnTipoItem, CbdvDesc, cbdindtot ) VALUES ( '"+alltrim(str(xCbdEmpCodigo ))+"' , '"+alltrim(str(xCbdNtfNumero))+ "', '"+((xCbdNtfSerie))+ "', '"+alltrim(str(xCbdnItem))+ "', '"+alltrim(str(xCbdcProd))+ "','"+xCbdcEAN+"', '"+alltrim(xCbdxProd)+"','"+xCbdNCM+"','"+xCbdEXTIPI+"','"+alltrim(str(xCbdgenero))+"','"+alltrim((xCbdCFOP))+"','"+ xCbduCOM+"','"+alltrim(str(xCbdqCOM))+"','"+alltrim(str(xCbdvUnCom))+"','"+alltrim(str(xCbdvProd))+"','"+alltrim(xCbduTrib)+"','"+alltrim(str(xCbdqTrib))+"','"+alltrim(str(xCbdvUnTrib))+"','"+alltrim(str(xCbdnTipoItem))+"','"+alltrim(str( xCbdvDesc))+"','"+alltrim(str(xcbdindtot))+"' ) "
  cQuery :="INSERT INTO nfeitem (CbdvAliq,CbdNtfSerie,CbdEmpCodigo,CbdNtfNumero,CbdnItem ,CbdxProd,  CbdNCM , CbdCFOP, CbduCOM,CbdqCOM,CbdvUnCom ,CbdvProd,CbdvDesc,cbdvoutro_item,CbdcProd,CbdcEAN) VALUES ('"+xALIQUOTA+"','"+xCbdEmpCodigo+"','"+xCbdEmpCodigo+"','"+xNSEQ_ORC+"',  '"+xITENS+"','"+xDESCRICAO+"' ,'"+xNCM+"','"+xCFOP+"', '"+xUNID+"' ,'"+xQTD+"','"+xVALOR+"' ,'"+xSUBTOTAL+"','"+xdescontoproc+"','"+xdescontovalor+"','"+xPRODUTO+"','"+xCOD_PROD+"' ) "
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 MsgInfo("Deu Problemas nao gravou os itens ") 
endif
endif

NrReg++
skip
EndDo




set delete on

 oQuery:= oServer:Query( "Select tipo,COD_IBGE,NUMERO,bairro,email,cep,LIMITE From cliente WHERE codigo = " + AllTrim(pCode))
  If oQuery:NetErr()
    MsgInfo("Por Favor Selecione o registro que deseja alterar")
    Return Nil
 Endif

 
oRow         := oQuery:GetRow(1)
xtipo        := oRow:fieldGet(1)
xCOD_ibge    := oRow:fieldGet(2)
xNUMERO      := oRow:fieldGet(3)
xbairro      := oRow:fieldGet(4)  
xEMAIL       := oRow:fieldGet(5) 
xcep         := oRow:fieldGet(6) 
xlimite      := oRow:fieldGet(7)
xDATA_VENC   := DaTE()+xlimite  
public xNSEQ_ORC



c_bruta:=LPAD(((FORM_FECHA.Vv_total.value)),15,[0])
c_bruta:=CHARREM(CHAR_REMOVE,c_bruta)
c_bruta:=val(StrTran(c_bruta,',','.'))/100

v_bruta:=LPAD(((FORM_FECHA.Valor_REC.value)),15,[0])
v_bruta:=CHARREM(CHAR_REMOVE,v_bruta)
v_bruta:=val(StrTran(v_bruta,',','.'))/100

  
           ABRENFCE()
              If LockReg()  
			           REPLACE COD_CLI   WITH   200
                       REPLACE desc1     WITH   FORM_FECHA.desconto.value 
                       REPLACE desc2     WITH   FORM_FECHA.Valor_desc.value 
                       REPLACE DESCONTO  WITH   FORM_FECHA.Valor_desc.value 
                       REPLACE VALOR_TOT WITH  C_bruta
                       REPLACE TOTAL_VEN WITH  v_bruta
				       REPLACE CL_PESSOA WITH   "F"
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                   Unlock
                   ENDIF                 
   
************************************
                  

                       xnrped    := seq_NFE->NUMCOD 
                       xnum_seq  := ntrim(C_CbdNtfNumero)
               *       xnum_seq  := ntrim(SEQ_NFE->SEQNFE)
                       xDATA_ORC :=dtos(DATE())
                       xEMISSAO  :=dtos(DATE())
                       xCOD_CLI  :=ntrim(NFCE-> COD_CLI)
                       xNOM_CLI  :=NFCE-> NOM_CLI
                       xDATA_VENC:= dtos(NFCE-> DATA_VENC)
                       xCL_CGC   := NFCE-> CL_CGC 
                       xRGIE     := NFCE-> RGIE
                       xCL_END   := NFCE-> CL_END 
                       xCL_PESSOA:= NFCE-> CL_PESSOA
                       xCL_CID   := NFCE-> CL_CID
                       xestado   := NFCE-> estado
                       xALIQUOTA := ntrim(NFCE->ALIQUOTA)
                       xCOD_IBGE := (NFCE-> COD_IBGE)
                       xCEP      := NFCE-> CEP
                       xED_NUMERO:=(NFCE-> ED_NUMERO)
                       xBAIRRO   := NFCE-> BAIRRO
					   xDESCONTO := ntrim(NFCE-> DESCONTO)
                       xTOTAL_VEN:= ntrim(NFCE-> TOTAL_VEN)
                       xVALOR_TOT:= ntrim(NFCE-> VALOR_TOT)
                       xcod_doc  := ntrim(NFCE-> cod_doc)
		               xdesc1    := ntrim(NFCE-> desc1 )
    		           xdesc2    := ntrim(NFCE-> desc2 ) 

					   xCbdEmpCodigo:="1"

					   
					   
									
IF xnota=0
	   cQuery := "INSERT INTO  nfe20 ( CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe,CbdNtfSerie,CbdEmpCodigo,CbdNtfNumero,CbdvProd_ttlnfe,CbdvNF,CbddEmi)  VALUES ('"+xDESCONTO+"','"+xdesc1+"','"+xdesc2+"','"+xCbdEmpCodigo+"','"+xCbdEmpCodigo+"','"+xnum_seq+"','"+xTOTAL_VEN+"','"+xVALOR_TOT+"','"+xEMISSAO+"')" 
            cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
		 	 MsgInfo("Tive problemas nao gravou1111 ") 
 	    	RETURN NIL
         	EndIf
endif


nfexml()
RETURN(NIL)

******************************************************
* Check to see if you can connect to a Internet
******************************************************
 
Function IsInternet()
local oSock, lRet := .f.
local cServer  := "www.google.com"
local nPort    := 80
local aAddress

oSock := TSocket():New()

if oSock:Connect( cServer, nPort )
 lRet := .t.
 oSock:Close()
endif

Return lRet
 
  Function ProcedureLerINI()         
            LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
                IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                   MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
                   Return
               ENDIF 
                FWRITE(nHandle,'NFe.LerIni' )
                FCLOSE(nHandle)

     RETURN
	 
	 
	 //---------------------
STATIC Function GRAVA_nfe1(nuNFe,mCbdtpEmis,c_ChNFe,c_NProt)
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
*LOCAL C_CFOP         :=nfe.textBTN_cfop.value
*LOCAL C_CODIGO       :=NFE.textBTN_cliente.VALUE
*private mCFOP        :='',mCbdnatOp:=''
*private mPEDIDO      :="",aFormaPagamento:=0,nEmail:=''

xxxx:=1

Reconectar_A() 

C_CbdNtfNumero:=VAL(nuNFe)


    cQuery:= "DELETE FROM ITEMNFCE WHERE CbdNtfNumero = " +ntrim (C_CbdNtfNumero)         
		 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
             msgInfo("SQL SELECT error: " + CQuery:Error())
 	    	RETURN NIL
		else
	*	  msginfo("ok")
	EndIf
  
  
    cQuery:= "DELETE FROM NFCE WHERE CbdNtfNumero = " +ntrim (C_CbdNtfNumero)         
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
         NATU         :="VENDA INTERNA"
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

//MSGINFO(ffxml)
//cQuery+=ClipValueSQL2(AllTrim(xcml))                 +" )"
  
*XML:=SUBSTR(cSAIDA_XML, 20, 55)
*fxml:="C:\ACBrNFeMonitor\"+xml
*msginfo(C_XMotivo,"ATENÇÃO")
*NFe_CON(fxml)
*NFe_IMP(alltrim(fxml))
*VERIFICA_GRAVA_nfe1()
  
  

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
		xCbdnatOp 		      := "VENDA INTERNA"
		xCbdindPag            :="0"
	   	xCbdmod  		      := '65'   ///Utilizar o código 55 para identificação da NF-e, emitida em substituição ao modelo 1 ou 1A
		xCbddEmi  		      := dtos(date())
		xCbddSaiEnt		      := dtos(DATE())    
		xCbdhrSaiEnt		  := time()   
	    xCbdtpNf 		      :="1"
	  	xCbdcMunFg  		  := (codMunEmpresa)
		xCbdtpImp  		      := "1"  // 1-Retrato ,2-Paisagem. 
   		xCbdtpEmis 		      := ntrim(mCbdtpEmis)
		xCbdfinNFe  		  := "1"  //  1 - NF-e normal / 2 - NF-e complementar / 3 - NF-e de ajuste.
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
        xCbdinfCpl	  	 	  := DADOSNFE->OBS +"    "+ COMPLEMENTO
   		xCbdCNAE   		  	  := ''
		chave                 :=alltrim(c_ChNFe)
		auto                  :=alltrim(c_NProt)
	 
    	 cQuery := "INSERT INTO  NFCE (CbdEmpCodigo,CbdNtfNumero,CbdNtfSerie,CbdUsuImpPadrao,CbdUsuImpCont,CbdUsuModDANFE,CbdJustificativa,CbdcUF,	CbdcNF,CbdnatOp ,CbdindPag,Cbdmod,CbddEmi,CbddSaiEnt,CbdhrSaiEnt,CbdtpNf,CbdcMunFg,CbdtpImp,CbdtpEmis,CbdfinNFe ,CbdvFrete_ttlnfe, CbdCNPJ_emit,CbdCPF_emit,CbdxNome,CbdxFant,CbdxLgr,Cbdnro,CbdxCpl,CbdxBairro,CbdcMun,CbdxMun,CbdUF,CbdCEP,CbdcPais,CbdxPais,Cbdfone,CbdFax,CbdEmail,CbdIE,CbdIEST,CbdIM,CbdinfCpl,CbdCNAE,CHAVE,AUTORIZACAO,nt_retorno )  VALUES ('"+xCbdEmpCodigo+"','"+xCbdNtfNumero+"','"+xCbdNtfSerie+"','"+xCbdUsuImpPadrao+"','"+xCbdUsuImpCont+"','"+xCbdUsuModDANFE+"','"+xCbdJustificativa+"','"+xCbdcUF+"','"+xCbdcNF+"','"+xCbdnatOp+"','"+xCbdindPag+"','"+xCbdmod+"','"+xCbddEmi+"','"+xCbddSaiEnt+"','"+xCbdhrSaiEnt+"','"+xCbdtpNf+"','"+xCbdcMunFg+"','"+xCbdtpImp+"','"+xCbdtpEmis+"','"+xCbdfinNFe+"','"+xCbdvFrete_ttlnfe+"','"+xCbdCNPJ_emit+"','"+xCbdCPF_emit+"','"+xCbdxNome+"','"+xCbdxFant+"','"+xCbdxLgr+"','"+xCbdnro+"','"+xCbdxCpl+"','"+xCbdxBairro+"','"+xCbdcMun+"','"+xCbdxMun+"','"+xCbdUF+"','"+xCbdCEP+"','"+xCbdcPais+"','"+xCbdxPais+"','"+xCbdfone+"','"+xCbdFax+"','"+xCbdEmail+"','"+xCbdIE+"','"+xCbdIEST+"','"+xCbdIM+"','"+xCbdinfCpl+"','"+xCbdCNAE+"','"+chave+"','"+AUTO+"','"+(AllTrim(ffxml))+"' )" 
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

	ClienteTxtCGC           :=(NFCE->CL_CGC)
	Insc                    :="0"
	CCbdxNome_dest          :=alltrim(DADOSNFE->NOM_CLI)
	CCbdxLgr_dest	  	    :="0" //*alltrim(DADOSNFE->CL_END)
  	CCbdxEmail_dest	  	    :="0" //*alltrim(DADOSNFE->email)
   	CCbdnro_dest	  	  	:="0" //*alltrim(DADOSNFE->ED_NUMERO)
   	CCbdxCpl_dest	  	    := "0"
	CCbdxBairro_dest	    :="0"  //alltrim(DADOSNFE->BAIRRO)
   	CCbdcMun_dest	  	    :="0"  //alltrim(DADOSNFE->COD_IBGE)
   	CCbdxMun_dest	  	    :="0"  //alltrim(DADOSNFE->CL_CID)
   	CCbdUF_dest		  	    :="0"   //alltrim(DADOSNFE->estado)
   	CCbdCEP_dest		    :="0"  //alltrim(DADOSNFE->cep)
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
*,CbdxNome_dest = '"+cCbdxNome_dest+"' 
*,CbdcMun_dest='"+CCbdcMun_dest+"'
    oQuery	:= oServer:Query( "UPDATE NFCE SET cbdcrt='"+alltrim(str(ccbdcrt))+"',CbdxNome_dest = '"+cCbdxNome_dest+"', CbdCPF_dest  = '"+ClienteTxtCGC+"' , CbdIE_dest = '"+Insc+"', CbdxLgr_dest ='"+cCbdxLgr_dest+"',Cbdnro_dest='"+CCbdnro_dest+"',CbdxBairro_dest='"+CCbdxBairro_dest+"' ,CbdxEmail_dest = '"+CCbdxEmail_dest+"',CbdxCpl_dest='"+CCbdxCpl_dest+"',CbdxMun_dest='"+CCbdxMun_dest+"' ,CbdUF_dest='"+cCbdUF_dest+"',Cbdfone_dest='"+CCbdfone_dest+"',CbdISUF='"+CCbdISUF+"',CbdvBC_ttlnfe='"+alltrim(str(cCbdvBC_ttlnfe))+"',CbdvICMS_ttlnfe='"+alltrim(str(cCbdvICMS_ttlnfe))+"',CbdvBCST_ttlnfe='"+alltrim(str(cCbdvBCST_ttlnfe))+"',CbdvFrete_ttlnfe='"+alltrim(str(cCbdvFrete_ttlnfe))+"',CbdmodFrete ='"+alltrim(str(cCbdmodFrete))+"',CbdvST_ttlnfe='"+alltrim(str(cCbdvST_ttlnfe))+"',CbdvProd_ttlnfe='"+alltrim(str(cCbdvProd_ttlnfe))+"',CbdvSeg_ttlnfe ='"+alltrim(str(cCbdvSeg_ttlnfe ))+"',CbdvDesc_ttlnfe='"+alltrim(str(cCbdvDesc_ttlnfe))+"',CbdvII_ttlnfe='"+alltrim(str(cCbdvII_ttlnfe))+"',CbdvIPI_ttlnfe='"+alltrim(str(cCbdvIPI_ttlnfe))+"',CbdvPIS_ttlnfe='"+alltrim(str(cCbdvPIS_ttlnfe))+"',CbdvCOFINS_ttlnfe='"+alltrim(str(cCbdvCOFINS_ttlnfe))+"',CbdvOutro='"+alltrim(str(cCbdvOutro))+"',CbdvNF='"+alltrim(str(cCbdvNF))+"',CbdEmailArquivos='"+alltrim(str(cCbdEmailArquivos))+"',CbdTitGenerico='"+alltrim((cCbdTitGenerico))+"',CbdTxtGenerico='"+alltrim(cCbdTxtGenerico)+"'  WHERE CbdNtfNumero = " +(C_CbdNtfNumero) )
 	If oQuery:NetErr()												
     	MsgStop(oQuery:Error())
      MsgInfo("SQL SELECT error: 3396  " + oQuery:Error())
		  
    
	 Else
	//	MsgStop("ok")
	EndIf

	registro:=0
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
	 xCbdNtfSerie       := (C_CbdNtfSerie) 
	 xCbdnItem          := (registro)
	 xCbdcProd          := (ITEMNFE->cod_prod)
	 xCbdcEAN           := (ITEMNFE->PRODUTO)
	 xCbdxProd          := ITEMNFE->DESCRICAO
	 xCbdNCM            := (ITEMNFE->ncm)
	 xCbdEXTIPI         := ""
	 xCbdgenero         := 0 
	 xCbdvAliq          :=ntrim(ITEMNFE->icms)
	 xCbdCFOP           := ITEMNFE->CFOP
	 xCbduCOM           := ITEMNFE->unid
	 xCbdqCOM           := ITEMNFE->QTD
	 xCbdvUnCom         := ITEMNFE->Valor
	 xCbdvProd          := ITEMNFE->SubTotal
	 xCbduTrib          := '000001'
	 xCbdqTrib          := ITEMNFE->QTD
	 xCbdvUnTrib        := ITEMNFE->Valor
	 xCbdnTipoItem      := 0
	 xCbdvDesc		    := ITEMNFE->Valor_DESC
   	 xcbdindtot         := 1



cQuery :="INSERT INTO ITEMNFCE (CbdvAliq,CbdEmpCodigo, CbdNtfNumero,CbdNtfSerie, CbdnItem ,CbdcProd,CbdcEAN,CbdxProd,CbdNCM ,CbdEXTIPI,Cbdgenero, CbdCFOP, CbduCOM,CbdqCOM,CbdvUnCom ,CbdvProd,CbduTrib,CbdqTrib,CbdvUnTrib,CbdnTipoItem, CbdvDesc, cbdindtot ) VALUES ('"+xCbdvAliq+"', '"+alltrim(str(xCbdEmpCodigo ))+"' , '"+alltrim(str(xCbdNtfNumero))+ "', '"+((xCbdNtfSerie))+ "', '"+alltrim(str(xCbdnItem))+ "', '"+alltrim(str(xCbdcProd))+ "','"+xCbdcEAN+"', '"+alltrim(xCbdxProd)+"','"+xCbdNCM+"','"+xCbdEXTIPI+"','"+alltrim(str(xCbdgenero))+"','"+alltrim((xCbdCFOP))+"','"+ xCbduCOM+"','"+alltrim(str(xCbdqCOM))+"','"+alltrim(str(xCbdvUnCom))+"','"+alltrim(str(xCbdvProd))+"','"+alltrim(xCbduTrib)+"','"+alltrim(str(xCbdqTrib))+"','"+alltrim(str(xCbdvUnTrib))+"','"+alltrim(str(xCbdnTipoItem))+"','"+alltrim(str( xCbdvDesc))+"','"+alltrim(str(xcbdindtot))+"' ) "
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 MsgInfo("Por Favor Selecione o registro ffff ") 
Endif				
endif
ITEMNFE->(dbskip())
ENDD  
RETURN
