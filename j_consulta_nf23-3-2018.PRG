#include 'minigui.ch'
#INCLUDE "WINPRINT.CH"
*#include "FastRepH.CH"
#include "lang_pt.ch"
#include 'i_textbtn.ch'
#define CLR_AZUL     RGB(0,0  , 255)  //azul forte 
#define CLR_AZULf     {00,  00, 135}  //azul fraco
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte  
#define    _VERMELHO  {255,  0, 0  } //vermelho forte  
#define CLR_VERMELHO  {255,  0, 0  } //vermelho forte  
#define CLR_VERMELHO1 {255,140, 0  } //vermelho forte  
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte  
#define CLR_AZUL     RGB(0,0  , 255)  //azul forte 
#define CLR_verde    RGB(0,190, 255)  //verde forte
#define CLR_amarelo    {255, 255, 0}   //amarelo forte
#define _AMARELO       {255, 255, 0}   //amarelo forte
#define CLR_AZULf     {00,  00, 135}  //azul fraco
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define CHAR_REMOVE  "/;-:,\.(){}[] "
*#include "MiniGui.ch"
#define _use_CallDLL
#define IDC_BTN_1   1001
#define IDC_BTN_2   1002
#define IDC_BTN_3   1003
#define IDC_BTN_4   1004
#define IDC_BTN_5   1005
#define IDC_BTN_6   1006
#define IDC_BTN_7   1007
#define IDC_BTN_8   1008
#define IDC_BTN_9   1009
#define IDC_BTN_10  1010
#define IDC_BTN_11  1011



//---------------------------------------------------------
Function Consulta_NFEc() 
//-------------------------------------------
Local oRow
Local i
local c_nf
Local oQuery

*ANNOUNCE RDDSYS
Memvar _usuario
Memvar _senha
Memvar _smtp
Memvar _ident
Memvar _de
Memvar _autentica
nCbx1 := 0
aCbx1 := { "Nome","Numero" }
cGet1 := Space( 10 )
tipo :="1"



 Abre_conexao_MySql()     
My_SQL_Database_Connect(cDataBase)



DEFINE WINDOW janelanfe;
      AT 00, 00 ;
        width Ajanela; 
         height Ljanela-40;
       TITLE "Cupom emitidos" ;
       MODAL;   
       NOSIZE;
	  ON INIT {||busca_data()  } 
	  
 ON KEY ESCAPE ACTION janelanfe.release //tecla ESC para fechar a janela

//------------------------------------
	   
      @ 540, 670   LABEL oSay1  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Total R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 


   @ 530, 810  FRAME oGrp2 ;
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

    DEFINE LABEL Total_Geral1
            ROW    618
            COL    810
            WIDTH  180
            HEIGHT 34
            VALUE ""
            FONTNAME 'Times New Roman' 
            FONTSIZE 25
            FONTBOLD .T.
            BACKCOLOR {255,255,0} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.
     END LABEL  
	 
   DEFINE LABEL Total_Geral
            ROW    540
            COL    810
            WIDTH  180
            HEIGHT 34
            VALUE ""
            FONTNAME 'Times New Roman' 
            FONTSIZE 25
            FONTBOLD .T.
            BACKCOLOR {255,255,0} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.
	END LABEL  
//-------------------------------------
   @ 570, 670   FRAME oGrp11 ;
   CAPTION ""  ;
   WIDTH 120 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

      @ 580, 670 LABEL oSay11  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Desconto R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 
//---------------------------------------------
   @ 570, 810  FRAME oGrp13 ; 
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

   DEFINE LABEL Total_desc
            ROW    580
            COL    810
            WIDTH  180
            HEIGHT 34
            VALUE ""
            FONTNAME 'Times New Roman' 
            FONTSIZE 25
            FONTBOLD .T.
            BACKCOLOR {255,255,0} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.
     END LABEL  
//-------------------------------------
   @ 610, 670   FRAME oGrp12 ;
   CAPTION ""  ;
   WIDTH 120 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

      @ 618, 670 LABEL oSay12  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Total R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 
 
 @ 610, 810  FRAME oGrp22 ;
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

  DEFINE LABEL Total_Geral1
            ROW    618
            COL    810
            WIDTH  180
            HEIGHT 34
            VALUE ""
            FONTNAME 'Times New Roman' 
            FONTSIZE 25
            FONTBOLD .T.
            BACKCOLOR {255,255,0} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.

	  
	
 @ 480, 000 LABEL Label_Search_codigo ;
      WIDTH 120 ;
      HEIGHT 034 ;
       VALUE "Pesquisa nome" ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 
	
  @ 480,170 TEXTBOX cSearch ;
    WIDTH 200 ;
    MAXLENGTH 400 ;
    UPPERCASE  ;
    backcolor _AMARELO;
   ON enter iif( !Empty(janelanfe.cSearch.Value), Grid_notas(), janelanfe.cSearch.SetFocus )
 
	/*	
		
@ 520, 00 BUTTONEX &("" + hb_ntos(IDC_BTN_1)) ;
      CAPTION "Inutilizacao" ;
      WIDTH 120  ;
      HEIGHT 40 ;
      FONTCOLOR BLUE ;
      BACKCOLOR YELLOW ;
	  FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      GRADIENTFILL { { { 200, 160, 0 }, { 255, 255, 0 } } } ;
       Action  F_InUtilizacao();
      TOOLTIP "Inutilizacao" NOXPSTYLE		
*/

  @ 520,00 BUTTONEX OButton_2 ;
      WIDTH 120 ;
      HEIGHT 40 ;
      CAPTION "Inutilizacao"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Inutilizacao" ;
      ACTION  {|| F_InUtilizacao() }

	  

 /*
		
		
@ 580, 00 BUTTONEX &("" + hb_ntos(IDC_BTN_2)) ;
      CAPTION "Duplicatas" ;
      WIDTH 120  ;
      HEIGHT 40 ;
      FONTCOLOR BLUE ;
      BACKCOLOR YELLOW ;
	  FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      GRADIENTFILL { { { 200, 160, 0 }, { 255, 255, 0 } } } ;
      Action  duplcas_do_nfe() ;
      TOOLTIP "Duplicatas" NOXPSTYLE		
	
	
*/				
	
	@ 580,00 BUTTONEX OButton_3 ;
      WIDTH 120 ;
      HEIGHT 40 ;
      CAPTION "Duplicatas"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Duplicatas" ;
      ACTION  {||  duplcas_do_nfe()}

/*	  
@ 630, 00 BUTTONEX &("" + hb_ntos(IDC_BTN_3)) ;
      CAPTION "Voltar" ;
      WIDTH 120  ;
      HEIGHT 40 ;
      FONTCOLOR BLUE ;
      BACKCOLOR YELLOW ;
	  FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      GRADIENTFILL { { { 200, 160, 0 }, { 255, 255, 0 } } } ;
     Action  janelanfe.RELEASE ;
      TOOLTIP "Voltar" NOXPSTYLE			
*/	
	
	@ 630,00 BUTTONEX OButton_4 ;
      WIDTH 120 ;
      HEIGHT 40 ;
      CAPTION "Voltar"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Voltar" ;
      ACTION  {||  janelanfe.RELEASE}
	

@ 520,150 BUTTONEX OButton_5 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Reenviar_xml _acbr"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Reenviar_xml" ;
      ACTION  {||  busca_data_if_acbr() }
		
	
@ 520,350 BUTTONEX OButton_6 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Exportar Cont."  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Exportar" ;
      ACTION  {|| busca_contigencia()}
				
				
	
@ 520,520 BUTTONEX OButton_66 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Importar XML"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Importar" ;
	  ACTION  {||  NFe_Check()}
	  
     * ACTION  {|| Importar_XML_BancoDeDados_saida_nfce()}
				

				
	
@ 580,150 BUTTONEX OButton_7 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Consulta nfce class"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Consulta nfce" ;
      ACTION  {||  busca_data_if_class()   }
	
 
@ 580,350 BUTTONEX OButton_8 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Por Datas"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Por Datas" ;
      ACTION  {|| busca_data_10()}
				
 

@ 630,150 BUTTONEX OButton_9 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Conaultas nfe "  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Consulta" ;
      ACTION  {|| ConsultanfCe()}
				
 
 @ 630,350 BUTTONEX OButton_10 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "recupera_recriar_xml"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Imprime_Cancelamento" ;
      ACTION  {|| recupera_recriar_xml()}
				
 
 
 
@ 580,520 BUTTONEX OButton_18 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Por Numero"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Por Numero" ;
      ACTION  {|| busca_numero()}
 
	  
 
 @ 630,520 BUTTONEX OButton_11 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Reimprimir"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Visualizar-NFce" ;
      ACTION  {||  lerxml()}
				
 
  
  DEFINE GRID Grid_notas
            ROW    05
            COL    00
			WIDTH  AJANELA-10
            HEIGHT 200
            WIDTHS {80,50,250,100,100,100,350,200,200,400,400,300}
		    HEADERS {"N Nfc-e","Serie","Consumidor","Cnpj/Cpf","data","Horas","Chave","Autorização","XML","Chave do Evento","NOTATXT","nfcedaruma"}
            Justify {0,0,0,0,0,0,0,0,0,0,0,0}
      	    FONTNAME "Arial Baltic"
            FONTSIZE 11
           * on dblclick duplcas_do_nfe();
	        ON CHANGE { acha_itens(),TOTAL() }
		END GRID  
DEFINE GRID Grid_itens
            ROW    235 
            COL    003  
            WIDTH  AJANELA-10
            HEIGHT 200
            WIDTHS {40,80,80,400,80,80,80,100,100}
            HEADERS {'Itens','NºNfe','Código','Produtos','Ncm','Cfop','Qtd','Unit','Total'}
            Justify {1,1,0,0,0,1,1,1,1,1,1,1,1,1}
            FONTNAME "Arial Baltic"
            FONTSIZE 11
		END GRID 
		   

	
	     
			  @ 010,630 LABEL    lData    VALUE "DATA" ;
			  BOLD AUTOSIZE TRANSPARENT
			  
            //  @ 010,680 TEXTBOX  tData    VALUE DATE() BOLD DATE ON ENTER CarregaGridDATA()
	
	
 DEFINE STATUSBAR of janelanfe
          STATUSITEM "Conectado no IP: "+C_IPSERVIDOR WIDTH 150
          DATE
          CLOCK
          KEYBOARD
      END STATUSBAR
	  

janelanfe.cSearch.SetFocus

END WINDOW
ACTIVATE WINDOW janelanfe
Return Nil
*--------------------------------------------------------------*
STATIC Function Grid_notas()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(janelanfe.cSearch.Value ))+'%" '           
Local nCounter:= 0
Local oRow
Local i
local c_nf
Local oQuery
local c_encontro
DELETE ITEM ALL FROM Grid_notas Of janelanfe

oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horas,Chave,autorizacao,nt_retorno,Cbdcheveevento,NOTATXT,nfcedaruma From NFCE WHERE CbdNtfNumero ="+cSearch+" Order By CbddEmi" )
	 
			   
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0

oRow := oQuery:GetRow(1)
* oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horas,Chave,autorizacao,nt_retorno,Cbdcheveevento,NOTATXT,nfcedaruma From NFCE WHERE CbdNtfNumero = "+c_nf+" Order By CbddEmi" )
janelanfe.cSearch.setfocus
janelanfe.cSearch.Value:=""

For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12)} TO Grid_notas Of janelanfe
 oQuery:Skip(1)
  Next
oQuery:Destroy()
*janelanfe.cSearch.SetFocus  
janelanfe.Grid_notas.value:=1
janelanfe.Grid_notas.setfocus
Return Nil

*--------------------------------------------------------------*
STATIC Function busca_data()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(janelanfe.cSearch.Value ))+'%" '           
Local nCounter:= 0
Local oRow
Local i
local c_nf
Local oQuery
local c_encontro
DELETE ITEM ALL FROM Grid_notas Of janelanfe

oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horaS,Chave,autorizacao,nt_retorno,Cbdcheveevento,NOTATXT,nfcedaruma From NFCE WHERE CbddEmi ="+dtos(date())+" Order By HORAS" )
	 
	   
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12)} TO Grid_notas Of janelanfe
  oQuery:Skip(1)
 Next
oQuery:Destroy()
*janelanfe.cSearch.SetFocus  
janelanfe.Grid_notas.value:=1
janelanfe.Grid_notas.setfocus
Return Nil




*--------------------------------------------------------------*
STATIC Function busca_data_10()                     
*--------------------------------------------------------------*

	
Ajanela := GetDesktopWidth() //* 0.78125
Ljanela := GetDesktopHeight() //* 0.78125 

SET BROWSESYNC ON	

IF ISWINDOWDEFINED(NFE_EMITIDA_CONTIGENCIA)
    RESTORE WINDOW NFE_EMITIDA_CONTIGENCIA
ELSE
      DEFINE WINDOW NFE_EMITIDA_CONTIGENCIA;
       AT 0100, 200 ;
       WIDTH 400;
       HEIGHT 350;
       TITLE "nFe/nfc_e Emitidas " ;
       icon cPathImagem+'JUMBO1.ico';
       MODAL;   
       NOSIZE
	   
	   
   @ 10, 010  FRAME oGrp22 ;
   CAPTION "Pesquisa Data"  ;
   WIDTH 350 ;
   HEIGHT 150 ;
   FONT "MS Sans Serif" SIZE 14.00 ;
   FONTCOLOR { 255, 255, 000 };
 
   
 @ 40, 10  datepicker dpi_001 ;
   WIDTH 126 HEIGHT         30 ;
   VALUE date();
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
   
   
   @ 40, 170  label ate ;
   WIDTH 30 HEIGHT         30 ;
   VALUE "Ate";
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
      
 @ 40, 230  datepicker dpi_002 ;
   WIDTH 126 HEIGHT         30 ;
   VALUE date();
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }

   
   
    @ 170, 10   LABEL oSay5 ;
   WIDTH 450 ;
   HEIGHT 30 ;
   VALUE ""  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   
     define buttonex confirma
                       row 100
                       col 010
                       width 110
                       height 030
                       caption 'Confirma'
                       picture cPathImagem+'ok.bmp'
                       fontbold .T.
                       lefttext .F.
                      action busca_data_20() 
                end buttonex
     
   
     
   
                      ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela

					  
					  
       
END WINDOW
CENTER WINDOW NFE_EMITIDA_CONTIGENCIA
ACTIVATE WINDOW NFE_EMITIDA_CONTIGENCIA
ENDIF
Return Nil





*--------------------------------------------------------------*
STATIC Function busca_data_if_acbr()                     
*--------------------------------------------------------------*

	
Ajanela := GetDesktopWidth() //* 0.78125
Ljanela := GetDesktopHeight() //* 0.78125 

SET BROWSESYNC ON	

IF ISWINDOWDEFINED(NFE_EMITIDA_CONTIGENCIA)
    RESTORE WINDOW NFE_EMITIDA_CONTIGENCIA
ELSE
      DEFINE WINDOW NFE_EMITIDA_CONTIGENCIA;
       AT 0100, 200 ;
       WIDTH 400;
       HEIGHT 350;
       TITLE "nFe/nfc_e Emitidas " ;
       icon cPathImagem+'JUMBO1.ico';
       MODAL;   
       NOSIZE
	   
	   
   @ 10, 010  FRAME oGrp22 ;
   CAPTION "Pesquisa Data"  ;
   WIDTH 350 ;
   HEIGHT 150 ;
   FONT "MS Sans Serif" SIZE 14.00 ;
   FONTCOLOR { 255, 255, 000 };
 
   
 @ 40, 10  datepicker dpi_001 ;
   WIDTH 126 HEIGHT         30 ;
   VALUE date();
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
   
   
   @ 40, 170  label ate ;
   WIDTH 30 HEIGHT         30 ;
   VALUE "Ate";
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
      
 @ 40, 230  datepicker dpi_002 ;
   WIDTH 126 HEIGHT         30 ;
   VALUE date();
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }

   
   
    @ 170, 10   LABEL oSay5 ;
   WIDTH 450 ;
   HEIGHT 30 ;
   VALUE ""  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   
     define buttonex confirma
                       row 100
                       col 010
                       width 110
                       height 030
                       caption 'Confirma'
                       picture cPathImagem+'ok.bmp'
                       fontbold .T.
                       lefttext .F.
                      action reenviar_acbr() 
                end buttonex
     
   
     
   
                      ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela

					  
					  
       
END WINDOW
CENTER WINDOW NFE_EMITIDA_CONTIGENCIA
ACTIVATE WINDOW NFE_EMITIDA_CONTIGENCIA
ENDIF
Return Nil



*--------------------------------------------------------------*
STATIC Function busca_data_if_class()                     
*--------------------------------------------------------------*

	
Ajanela := GetDesktopWidth() //* 0.78125
Ljanela := GetDesktopHeight() //* 0.78125 

SET BROWSESYNC ON	

IF ISWINDOWDEFINED(NFE_EMITIDA_CONTIGENCIA)
    RESTORE WINDOW NFE_EMITIDA_CONTIGENCIA
ELSE
      DEFINE WINDOW NFE_EMITIDA_CONTIGENCIA;
       AT 0100, 200 ;
       WIDTH 400;
       HEIGHT 350;
       TITLE "nFe/nfc_e Emitidas " ;
       icon cPathImagem+'JUMBO1.ico';
       MODAL;   
       NOSIZE
	   
	   
   @ 10, 010  FRAME oGrp22 ;
   CAPTION "Pesquisa Data"  ;
   WIDTH 350 ;
   HEIGHT 150 ;
   FONT "MS Sans Serif" SIZE 14.00 ;
   FONTCOLOR { 255, 255, 000 };
 
   
 @ 40, 10  datepicker dpi_001 ;
   WIDTH 126 HEIGHT         30 ;
   VALUE date();
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
   
   
   @ 40, 170  label ate ;
   WIDTH 30 HEIGHT         30 ;
   VALUE "Ate";
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
      
 @ 40, 230  datepicker dpi_002 ;
   WIDTH 126 HEIGHT         30 ;
   VALUE date();
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }

   
   
    @ 170, 10   LABEL oSay5 ;
   WIDTH 450 ;
   HEIGHT 30 ;
   VALUE ""  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   
     define buttonex confirma
                       row 100
                       col 010
                       width 110
                       height 030
                       caption 'Confirma'
                       picture cPathImagem+'ok.bmp'
                       fontbold .T.
                       lefttext .F.
                      action reenviar_class() 
                end buttonex
     
   
     
   
                      ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela

					  
					  
       
END WINDOW
CENTER WINDOW NFE_EMITIDA_CONTIGENCIA
ACTIVATE WINDOW NFE_EMITIDA_CONTIGENCIA
ENDIF
Return Nil





*--------------------------------------------------------------*
STATIC Function busca_data_20()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(janelanfe.cSearch.Value ))+'%" '           
Local nCounter:= 0
Local oRow
Local i
local c_nf
Local oQuery
local c_encontro
DELETE ITEM ALL FROM Grid_notas Of janelanfe
  vdata:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_001.value)
  vdata1:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_002.value)
  


  oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,HORAS,Chave,autorizacao,nt_retorno,Cbdcheveevento,NOTATXT,nfcedaruma From NFCE WHERE CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+"  Order By CbddEmi" )

	
*WHERE DVENCIM >= "+vdata+" and DVENCIM <= "+vdata1+"	
	   
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12)} TO Grid_notas Of janelanfe
 oQuery:Skip(1)
  Next
oQuery:Destroy()
*janelanfe.cSearch.SetFocus  
janelanfe.Grid_notas.value:=1
janelanfe.Grid_notas.setfocus
ThisWindow.release
Return Nil


*--------------------------------------------------------------*
STATIC Function acha_itens()                     
*--------------------------------------------------------------*
Local pCode    := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local Txt_SERIE:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
Local nCounter:= 0
Local oRow
Local i
Local oQuery
local c_encontro


DELETE ITEM ALL FROM Grid_itens Of janelanfe
XUNIT1=0
XQUANT1=0
REG:=0
NTOTAL=0
oQuery := oServer:Query( "Select CbdNtfNumero,CbdcProd,CbdxProd,CbdNCM ,CbdCFOP,CbdqCOM,CbdvUnCom,CbdvProd From ITEMNFCE WHERE CbdNtfNumero LIKE "+pcode+" and CbdNtfSerie = "+alltrim(Txt_SERIE)+" Order By CbdxProd" )
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  REG=REG+1
  ADD ITEM { strzero(reg,4),strzero(oRow:fieldGet(1),8),LPAD(STR(val(oRow:fieldGet(2))),6,[0]),(oRow:fieldGet(3)),(oRow:fieldGet(4)),str(oRow:fieldGet(5),8),transform((oRow:fieldGet(6)),"@R 99,999.99"),transform((oRow:fieldGet(7)),"@R 99,999.99"),transform((oRow:fieldGet(8)),"@R 99,999.99") } TO Grid_itens Of janelanfe
  oQuery:Skip(1)
Next
oQuery:Destroy()
Return Nil

*--------------------------------------------------------------*
STATIC Function TOTAL()                     
*--------------------------------------------------------------*
Local pCode    := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local Txt_SERIE:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
Local nCounter:= 0
Local oRow
Local i
Local oQuery
local c_encontro
XUNIT1=0
XQUANT1=0
REG:=0
NTOTAL=0
NFRETE=0
NNTOTAL=0
NDESCONTO=0

if val(pcode)=0
msginfo("Não Encontrado")
return .f.
endif
 oQuery:=oServer:Query( "SELECT CbdvProd_ttlnfe,CbdvDesc_ttlnfe,CbdvNF,MSCANCELAMENTO FROM NFCE WHERE CbdNtfNumero = "+pcode+" and CbdNtfSerie ="+(Txt_SERIE)+" " )
 If oQuery:NetErr()
    MsGInfo("linha 422 " + oServer:Error() )
    Return Nil
  Endif



oRow   := oQuery:GetRow(1)
      MODIFY CONTROL Total_Geral    OF janelanfe Value ''+TransForm(oRow:fieldGet(1),"@R 999,999.99")
      MODIFY CONTROL Total_desc     OF janelanfe VALUE ''+TransForm(oRow:fieldGet(2),"@R 999,999.99")     	 
      MODIFY CONTROL Total_Geral1   OF janelanfe VALUE ''+TransForm(oRow:fieldGet(3),"@R 999,999.99")  

	  
If !Empty(oRow:fieldGet(4)) // 
   MsgInfo(oRow:fieldGet(4) , "ATENÇÃO")
else
EndIf
oQuery:Destroy()
Return Nil



*--------------------------------------------------------------*
 STATIC Function GetColValue( xObj, xForm, nCol)
*--------------------------------------------------------------*
  Local nPos:= GetProperty(xForm, xObj, 'Value')
  Local aRet:= GetProperty(xForm, xObj, 'Item', nPos)
Return aRet[nCol]

*--------------------------------------------------------------*
STATIC Function ConsultanfCe()
*--------------------------------------------------------------*
Local Pachave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 7))))
Local pnumero:= (val((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local pserie := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
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

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+Pachave+")")
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

MY_WAIT( 2 ) 

if cCStat="613"


endif


if cCStat="100"
*msginfo(c_cNProt)
endif


xx_xchavenfce:=c_cChNFe

if c_CStat="217"
msginfo(cXMotivo +"               Vamos Enviar Agora")
*return(.f.)
*reenviar()


MY_WAIT( 1 ) 

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+xx_xchavenfce+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 


BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI

MY_WAIT( 1 ) 

public  c_CStat   :=cCStat
public c_cChNFe   :=cChNFe
public c_cNProt   :=cNProt
AUTO              :=c_cNProt
*msginfo(cNProt)
xx_xchavenfce:=c_cChNFe

C_CbdNtfNumero:=SUBSTR(pachave, 44, 9)
pnumero       :=val(C_CbdNtfNumero)

XML           :=SUBSTR(pachave, 20, 55)
fxml          :="C:\ACBrMonitorPLUS\"+xml
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
endif


Reconectar_A() 

C_CbdNtfNumero:=SUBSTR(pachave, 44, 9)
C_CbdNtfNumero:=val(C_CbdNtfNumero)

XML           :=SUBSTR(pachave, 20, 55)
fxml          :="C:\ACBrMonitorPLUS\"+xml
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
  
  
  
RETURN


Function ProcedureescreverINI()
    cDestino := "C:\ACBrMonitorPLUS\ACBrMonitor.INI"
	lRetStatus:=EsperaResposta(cDestino) 
	
	BEGIN INI FILE cDestino
      SET SECTION "DANFE"  ENTRY "Modelo"  TO '1'
    END INI
	MY_WAIT( 3 )    
	ProcedureLerINI()
return
	
	
*--------------------------------------------------------------*
STATIC Function lerxml_evento()                   
*--------------------------------------------------------------*
Local pacode        := (GetColValue( "Grid_notas", "janelanfe", 1 ))
Local CHAVEEVENTO   := ALLTRIM(GetColValue( "Grid_notas", "janelanfe",10 ))
Local paserie       := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
LOCAL cOrigem       := 'C:\ACBrMonitorPLUS\ent.txt'
Local nCounter:= 0
local ppchave:=""
Local oRow
Local i
Local oQuery
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local FC_NORMAL
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()

Reconectar_A() 
c_CFileDanfe:=""
xANO     := dtoS(date())
xANO     :=ALLTRIM(SUBSTR(XANO,0,6))
 
  oQuery:=oServer:Query( "SELECT CHAVE,retorno_evento  FROM nfce WHERE CbdNtfNumero = "+AllTrim(pACode)+" and CbdNtfSerie ="+(paserie)+" Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
oRow:= oQuery:GetRow(1)
	

If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
    ///////////////////////////////////////////////////
MY_WAIT( 2 )

xANO     := dtoS(date())
xANO     :=ALLTRIM(SUBSTR(XANO,0,6))
	
cFileDanfe:="C:\ACBrMonitorPlus\ACBrMonitor.INI"
////RETORNO////
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathEvento"
END INI
public  cCFileDanfe    :=c_CFileDanfe

PathEvento:=cCFileDanfe+"\"+"NFCe"+"\"+xANO+"\"+"EVENTO"+"\"+"CANCELAMENTO"+"\"
ARQEVENTO:=PathEvento+CHAVEEVENTO+"-procEventoNFe.XML"
*cRet := MON_ENV("NFe.ImprimirEvento("+ARQEVENTO+")")
ffxml              :=memoread(ARQEVENTO)
HANDLE :=  FCREATE ("EVENTO.XML",0)// cria o arquivo
FWRITE(Handle,ffxml)
fclose(handle)  
public cTXT     :=PATH+"\EVENTO.XML"

   	IF (Handle := FCREATE(cOrigem, FC_NORMAL)) == -1
             MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
		     Return
           ENDIF 
           FWRITE(Handle,"NFe.ImprimirEvento("+cTXT+")")
           FCLOSE(Handle) 
	

Return Nil



*--------------------------------------------------------------*
STATIC Function pega_chave()                     
*--------------------------------------------------------------*
Local pchave   := (GetColValue( "Grid_notas", "janelanfe", 7 ))
Local paCode   := (GetColValue( "Grid_notas", "janelanfe", 1 ))
Local paserie  := (GetColValue( "Grid_notas", "janelanfe", 2 ))
local aArqGet, x
Local nCounter:= 0
local ppchave:=""
Local oRow,ninfEventoId
Local i
Local oQuery
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()
local cNFe, cJus, cENT, cSAI, cTMP 
LOCAL cCmd, cRet
local FC_NORMAL   
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
   

  oQuery:=oServer:Query( "SELECT CHAVE,MSCANCELAMENTO FROM nfce WHERE CbdNtfNumero = "+AllTrim(pACode)+" and CbdNtfSerie ="+(paserie)+" Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
  	oRow          :=oQuery:GetRow(1)
If !Empty(oRow:fieldGet(2)) // 
   MsgInfo("Evento Já Registrado" , "ATENÇÃO")
janelanfe.RELEASE
RETURN(.F.)
EndIf	

	
	
If !Empty(pchave) // se nao encontra vale a pesq pro nota fiscal
   else
     MsgInfo("Nao Enntrado: " , "ATENÇÃO")
   Return .f. 
	 *CANCELA_NFe.RELEASE   
 EndIf
ERASE "C:\ACBrMonitorPLUS\sai.txt"

cJus :=" Venda nao concretizada"

cRet       := MON_ENV("NFE.CancelarNFe("+pchave+","+cJus+","+'84712611000152'+")")



  cFileDanfe:="C:\ACBrMonitorPLUS\SAI.TXT"
  lRetStatus:=EsperaResposta(cFileDanfe) 
   if lRetStatus==.t.  ////pego os dados
     end
cFileDanfe := 'C:\ACBrMonitorPLUS\sai.txt'

BEGIN INI FILE cFileDanfe
      ////CANCELAMENTO//////////////////////////////////////////////////////
       GET cCStat          SECTION  "CANCELAMENTO"       ENTRY "CStat"
	   GET cXMotivo        SECTION  "CANCELAMENTO"       ENTRY "XMotivo"
       GET cDhRecbto       SECTION  "CANCELAMENTO"       ENTRY "DhRecbto"
	   GET cNProt          SECTION  "CANCELAMENTO"       ENTRY "NProt"
	   GET ninfEventoId    section  "CANCELAMENTO"       ENTRY "<infEvento Id"
	   
   	 /////////////////////////////////////////////////////////////
END INI

public  c_CStat   :=cCStat
public C_XMotivo  :=cXMotivo
public c_DhRecbto :=cDhRecbto
public c_NProt    :=cNProt
PUBLIC  cPesqEVENT:= Substr(ninfEventoId,4,52)

ccPesqEVENT :=cPesqEVENT
 

cFileSaida         := "C:\ACBrMonitorPLUS\"+cPesqEVENT+"-procEventoNFe.XML"
ffxml              :=memoread(cFileSaida)

HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,ffxml)
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"
	ProcedureLerINI()

   	IF (Handle := FCREATE(cOrigem, FC_NORMAL)) == -1
             MsgInfo("Falha na Criação do Arquivo:","ENT.TXT")
		     Return
           ENDIF 
           FWRITE(Handle,"NFe.ImprimirEvento("+cTXT+")")
           FCLOSE(Handle) 
	
if c_CStat="579"
    Return .f.
 	Msginfo(cXMotivo)
	*CANCELA_NFe.RELEASE
    janelanfe.RELEASE
EndIf									
										
										
if c_CStat="573"
* Msginfo(cXMotivo)
 c_XMotivo:='Cancelamento registrado e vinculado a NF-e '
	
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+c_XMotivo+"',RETORNO_EVENTO= '"+(AllTrim(ffxml))+"',Cbdcheveevento ='"+alltrim(ccPesqEVENT)+"' WHERE CbdNtfNumero = "+(alltrim(paCode))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+paserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
  Endif
ENDIF


if c_CStat="271"
* 	Msginfo(cXMotivo)
EndIf


if c_CStat="135"


*Msginfo(cXMotivo)
c_XMotivo:='Evento registrado e vinculado a NF-e'
	
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+c_XMotivo+"',RETORNO_EVENTO= '"+(AllTrim(ffxml))+"',Cbdcheveevento ='"+alltrim(ccPesqEVENT)+"' WHERE CbdNtfNumero = "+(alltrim(paCode))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+paserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
  Endif


  
  
endif
///////////////////pega a qtd nos itens 
*oQuery :=oServer:Query( "Select CbdcEAN,CbdqCOM From ITEMNFCE WHERE CbdNtfNumero = " + AllTrim(paCode))
 oQuery :=oServer:Query( "SELECT CbdcEAN,CbdqCOM FROM ITEMNFCE WHERE CbdNtfNumero = "+AllTrim(paCode)+" and CbdNtfSerie ="+(paserie)+" Order By CbdNtfNumero" )

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
	*MSGINFO(C_CODIGO)
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

cNomeArqTXT:=cFileSaida

janelanfe.RELEASE
Return Nil



*--------------------------------------------------------------*
STATIC Function lerxml()                   
*--------------------------------------------------------------*

Local paSERIE   := (GetColValue( "Grid_notas", "janelanfe", 2 ))
Local paCode    := (GetColValue( "Grid_notas", "janelanfe", 1 ))

Local nCounter:= 0
local ppchave:=""
Local oRow
Local i
Local oQuery
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
//Local cDoc:='nfe.xml'
local path :=DiskName()+":\"+CurDir()

Reconectar_A() 


oQuery        :=oServer:Query( "SELECT CHAVE,nt_retorno FROM NFCE WHERE CbdNtfNumero = "+pACode+" AND  cbdmod= "+"65"+" and CbdNtfSerie = "+paSERIE+"  Order By CbdNtfNumero" )
oRow          := oQuery:GetRow(1)
xchave        :=ALLTRIM(oRow:FieldGet(1))

	
If Empty(oRow:FieldGet(2))
XML:=(xchave)

fxml:="C:\ACBrMonitorPLUS\"+xml+"-nfe.XML"
cRet       := MON_ENV("NFE.ImprimirDanfe("+fxml+",1,1,0,1)")


ELSE
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"
cRet       := MON_ENV("NFE.ImprimirDanfe("+cTXT+",1,1,0,1)")
ENDIF

Return Nil


#Include "Minigui.ch"
//-----------------------------------------------------------------------
Function F_InUtilizacao()
Local paSERIE   := (GetColValue( "Grid_notas", "janelanfe", 2 ))
Local paCode   := (GetColValue( "Grid_notas", "janelanfe", 1 ))


xSEQ_TEF := strzero(year(date() ),4)
 
xSEQ_TEF:=SUBSTR(xSEQ_TEF,3,2)

*msginfo(xSEQ_TEF)


Define WINDOW unitilizacao ;
       AT 318, 122 ;
       WIDTH 788 ;
       HEIGHT 340 ;
       TITLE "unitilizacao" ;
	   MODAL;   
       NOSIZE;
	   BACKCOLOR { 240, 240, 240 } 
	 
 ON KEY ESCAPE ACTION unitilizacao.release //tecla ESC para fechar a janela


  @ 040, 046   LABEL oSay1 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Cnpj"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }

	   
   @ 60, 029   TEXTBOX oGet1 ;
   WIDTH 120 HEIGHT         20 ;
   VALUE '84712611000152' ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }
***************************
@ 40, 176   LABEL oSay2 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Justificativa"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   @ 60, 169   TEXTBOX oGet2 ;
   WIDTH 191 HEIGHT         20 ;
   VALUE 'Erro na sequencia de emissao' ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }
   
************************************************


   @ 040, 372   LABEL oSay3 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Ano"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   @ 060, 373   TEXTBOX oGet3 ;
   WIDTH  43 HEIGHT         20 ;
   VALUE xSEQ_TEF ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }

**********************************



   @ 40, 454   LABEL oSay4 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Modelo"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 60, 429   TEXTBOX oGet4 ;
   WIDTH  51 HEIGHT         19 ;
   VALUE "65" ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }
******************************************

   @ 040, 519   LABEL oSay5 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Serie"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 060, 488   TEXTBOX oGet5 ;
   WIDTH  68 HEIGHT         20 ;
   VALUE paSERIE ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }

  ************************************************
  
  

   @ 040, 577   LABEL oSay6 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Nºinicial"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }

   
   @ 60, 567   TEXTBOX oGet6 ;
   WIDTH  67 HEIGHT         20 ;
   VALUE ALLTRIM(paCode);
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }
   
   
   ********************************************
   
   
   @ 40, 666   LABEL oSay7 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Nº Final"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   

   @ 60, 641   TEXTBOX oGet7 ;
   WIDTH  75 HEIGHT         20 ;
   VALUE ALLTRIM(paCode) ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }


   @ 175, 579   BUTTON oBut1 ;
   CAPTION "Confirma"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
   Action env_InUtilizacao1()


   @ 175, 057   BUTTON oBut2 ;
   CAPTION "Voltar"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
   ACTION unitilizacao.release 
   


END WINDOW
ACTIVATE WINDOW unitilizacao

Return NIL






//-----------------------------------------------------------------------
Function env_InUtilizacao1()
//-----------------------------------------------------------------------
local aArqGet, x
Local nCounter:= 0
local pachave:=""
Local oRow,ninfEventoId
Local FC_NORMAL
Local oQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()
LOCAL cChNFe :=""
local anomes:=""
Local pCCHAVE := ALLTRIM(GetColValue( "Grid_notas", "janelanfe", 7 ))
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
  
ccnpj:=alltrim(unitilizacao.oGet1.value)
cJus :=alltrim(unitilizacao.oGet2.value)
nAno :=alltrim(unitilizacao.oGet3.value)
nMod :=alltrim(unitilizacao.oGet4.value)
nSer :=alltrim(unitilizacao.oGet5.value)
nIni :=alltrim(unitilizacao.oGet6.value)
nFin :=alltrim(unitilizacao.oGet7.value)
*NFe_INU( ccnpj, cJus, nAno, nMod, nSer, nIni, nFin)

*NFE.InutilizarNFe
cRet := MON_ENV("NFE.InutilizarNFe("+ccnpj+","+cJus+","+nAno+","+nMod+","+nSer+","+nIni+","+nFin+")")

MY_WAIT( 1 ) 
cFileDanfe := "C:\ACBrMonitorPLUS\SAI.TXT"
xcml:=memoread(cFileDanfe)
variavel1 :=SUBSTR(xcml,0,4)
variavel :=SUBSTR(xcml,0,100)

IF "ERRO"=ALLTRIM(variavel1)
msginfo(variavel)
return(.f.)
ENDIF





MY_WAIT( 1 ) 

BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "INUTILIZACAO"       ENTRY "CStat"
	   get cChNFe          section  "INUTILIZACAO"       ENTRY "ChNFe"
	   get cNProt          section  "INUTILIZACAO"       ENTRY "NProt"
	   get cXMotivo        section  "INUTILIZACAO"       ENTRY "XMotivo"
END INI


public  c_CStat   :=VAL(cCStat)
public c_cChNFe   :=cChNFe
public c_cNProt   :=cNProt

AUTO:=c_cNProt
c_XMotivo:=cXMotivo



if c_CStat=102
MSGINFO(c_XMotivo)
*ELSE
*MSGINFO(c_XMotivo)
*Return .F.
ENDIF


if c_CStat=102
*msginfo('Inutilizacao de numero homologado')
Reconectar_A() 
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+c_XMotivo+"' ,AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+nIni+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+nSer+" "

 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif

endif
unitilizacao.release 
janelanfe.cSearch.value:=nIni
janelanfe.cSearch.SetFocus

Return NIL

Function reenviar()
* reenviar_acbr()

IF   GERA_NFE_NFCE=1
   *  cRet       := MON_ENV_POS("ESCPOS.ativar(")
   *  MY_WAIT( 1 ) 
    * BEGIN INI FILE "C:\ACBrMonitorPLUS\ACBrMonitor.INI"
    *  SET SECTION "DANFE"  ENTRY "Copias"  TO '1'
    *END INI
* ProcedureLerINI()
busca_data_if_acbr()

ELSE 
busca_data_if_class()
ENDIF 


Return NIL



*--------------------------------------------------------------*
STATIC Function reenviar_acbr()
*--------------------------------------------------------------*
local xJust:="Sem acesso a Internet" 
LOCAL nSeconds := 0, nCount := 4, lLoop := .T.
local cStat     :="" 
LOCAL cNProt     :=""
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt '
Local FC_NORMAL
local path :=DiskName()+":\"+CurDir()
local cXMotivo:=""
local R_CStat:=''
local xchave:=""
Criadir_nfce()



/*
oQuery        :=oServer:Query( "SELECT CHAVE,nt_retorno,NOTATXT FROM NFCE WHERE CbdNtfNumero = "+NTRIM(pnumero)+" AND  cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+"  Order By CbdNtfNumero" )
oRow          := oQuery:GetRow(1)
HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)  
public cTXT     :=PATH+"\NFCE.TXT"
bRetornaXML:=""
*/


Reconectar_A()

 *vdata:=dtos(date())
 *vdata1:=dtos(date())
 
  vdata:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_001.value)
  vdata1:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_002.value)

  tQuery := oServer:Query( "Select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO,NOTATXT From NFCE WHERE  (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" and nt_retorno=''  ) Order By CbddEmi" )
 * tQuery := oServer:Query( "Select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO,NOTATXT From NFCE WHERE CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" Order By CbdNtfNumero" )
If tQuery:NetErr()
    MsgInfo("Nao foi encontrado nada")
    Return Nil
  Endif
For i := 1 To tQuery:LastRec()
  oRow       :=tQuery:GetRow(i)
   pnumero   := (oRow:fieldGet(1))
 cChave      :=ALLTRIM(oRow:fieldGet(2))
 Xnt_retorno :=oRow:fieldGet(3)
pserie       :=oRow:fieldGet(4)
 XAUTORIZACAO:=oRow:fieldGet(5)
***********************************************************
HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(6))
fclose(handle)  
public cTXT     :=PATH+"\NFCE.TXT"
bRetornaXML:=""

 
public cTXT     :=PATH+"\NFCE.TXT"
bRetornaXML:=""
*******************************************************
******************************************************
Ret       := MON_ENV("NFe.CriarNFe("+cTXT+","+bRetornaXML+")")
MY_WAIT(1 )
//////////////////consultar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+cchave+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 

             lRetStatus:=EsperaResposta(cDestino)
       if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
      *  *MSGINFO(memoread(cDestino))
          cEnvio_XML:=.f.
      
       else
       BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cNProt         section  "CONSULTA"       ENTRY "NProt"
	 
END INI
end
end


public  CCStat  :=cStat
public  xProt   :=cNProt



iF  CCStat $ "100,101,150,301,302"
cXml     :="C:\ACBrMonitorPLUS\"+cchave+"-nfe.XML"
cXml     :=Memoread(cXml)
MY_WAIT( 1 )
HANDLE :=  FCREATE (cSubDir+cchave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,cXml)
fclose(handle)  
MY_WAIT( 1 )

cQuery := "UPDATE NFCE SET AUTORIZACAO='"+xProt+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
   HB_Cria_Log_nfce(CCStat,Cchave+"  Gravado no DB  :"+cNProt)
Endif

*********************************************************
********************************************************** 
ELSEIF  CCStat == "217"  // nao consta na base de dados
*********************************************************
// gerar contigencia 
  BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
	 SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
	 END INI
 MY_WAIT( 1 ) 
 cRet       := MON_ENV("NFE.CriarEnviarNFe("+cTXT+",1,0,0,0)")
MY_WAIT( 1 ) 

       lRetStatus:=EsperaResposta(cDestino)
       if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
       * *MSGINFO(memoread(cDestino))
          cEnvio_XML:=.f.
      
		else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET R_CStat          SECTION  "RETORNO"               ENTRY "CStat"
	   GET cNProt           SECTION  "NFE"+ntrim(pnumero)    ENTRY "NProt"   
       GET xchave           SECTION  "NFE"+ntrim(pnumero)    ENTRY "ChNFe"    	   
END INI
endif
endif


public  xCStat  :=R_CStat
public  xxProt   :=cNProt
public  xcChNFe   :=xchave


iF  xCStat $ "100,101,150,301,302"


cXml     :="C:\ACBrMonitorPLUS\"+cchave+"-nfe.XML"
cXml     :=Memoread(cXml)
HANDLE :=  FCREATE (cSubDir+cchave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,cXml)
fclose(handle)  


cQuery := "UPDATE NFCE SET CHAVE='"+xcChNFe+"',AUTORIZACAO='"+xxProt+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
     HB_Cria_Log_nfce(xCStat,xcChNFe+"  Gravado no DB  :"+cXml)
  Endif
endif
**************************************************
*********************************************** 
 
ELSEIF  CCStat == "225" /// ERRO NO SCHEMAS
// gerar contigencia 
  BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
	 SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
	 END INI
 MY_WAIT( 1 ) 
 cRet       := MON_ENV("NFE.CriarEnviarNFe("+cTXT+",1,0,0,0)")
MY_WAIT( 1 ) 

       lRetStatus:=EsperaResposta(cDestino)
       if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
       * *MSGINFO(memoread(cDestino))
          cEnvio_XML:=.f.
      
		else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET R_CStat          SECTION  "RETORNO"               ENTRY "CStat"
	   GET cNProt           SECTION  "NFE"+ntrim(pnumero)    ENTRY "NProt"   
       GET xchave           SECTION  "NFE"+ntrim(pnumero)    ENTRY "ChNFe"    	   
END INI
endif
endif


public  xCStat  :=R_CStat
public  xxProt   :=cNProt
public  xcChNFe   :=xchave


iF  xCStat $ "100,101,150,301,302"

cXml     :="C:\ACBrMonitorPLUS\"+cchave+"-nfe.XML"
cXml     :=Memoread(cXml)
HANDLE :=  FCREATE (cSubDir+cchave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,cXml)
fclose(handle)  


cQuery := "UPDATE NFCE SET CHAVE='"+xcChNFe+"',AUTORIZACAO='"+xxProt+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  msginfo('0')
  Endif
endif
**************************************************
*********************************************** 
 
ELSEIF  CCStat $ "526" /// NFE FORA DE PRAZO

cCStat :=""       
cNProt :=""        
cXMotivo:=""  


ccnpj  :="84712611000152"
cJus   :="Erro na sequencia de emissao"
nMod   :="65"
nIni   :=val(SUBSTR(cChave,26,9)) 
nSer   :=val(SUBSTR(cChave,23,3)) 
cAno   := '20'+substr(cChave,3,2)
cRet   := MON_ENV("NFE.InutilizarNFe("+ccnpj+","+cJus+","+cAno+","+nMod+","+ntrim(nSer)+","+ntrim(nIni)+","+ntrim(nIni)+")")

  lRetStatus:=EsperaResposta(cDestino)
       if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
        **MSGINFO(memoread(cDestino))
          cEnvio_XML:=.f.
 	else
BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "INUTILIZACAO"       ENTRY "CStat"
	   get cNProt          section  "INUTILIZACAO"       ENTRY "NProt"
	   get cXMotivo        section  "INUTILIZACAO"       ENTRY "XMotivo"
END INI
endif
endif

public  c_CStat   :=cCStat
public c_cNProt   :=cNProt

if c_CStat="102"

c_XMotivo:=cXMotivo
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+c_XMotivo+"'  WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  msginfo('0')
  Endif
endif



ELSEIF  CCStat == "613" ///CHAVE DE ACESSO DIFERENTE DA EXISTENTE  
//////////////////consultar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+cchave+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 
xcchave:=""

       lRetStatus:=EsperaResposta(cDestino)
       if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         *MSGINFO(memoread(cDestino))
         cEnvio_XML:=.f.
      
		else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
 	  * get xcchave         section  "CONSULTA"       ENTRY "ChNFe"
 	    get xcchave         section  "CONSULTA"       ENTRY "XMotivo"
	   END INI
endif
ENDIF

public Agchave   :=SUBSTR(xcchave,91, 44)

public TPemis    :=SUBSTR(Agchave,35, 1)

if TPemis="1"
 BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
*	 SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
 END INI

******************************************************
Ret       := MON_ENV("NFe.CriarNFe("+cTXT+","+bRetornaXML+")")
MY_WAIT(1 )
endif

//////////////////consultar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+Agchave+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 

             lRetStatus:=EsperaResposta(cDestino)
       if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         *MSGINFO(memoread(cDestino))
          cEnvio_XML:=.f.
      
       else
       BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cNProt         section  "CONSULTA"       ENTRY "NProt"
	 
END INI
end
end



public txtx :=PATH+"\NFCE.TXT"
xcml            :=memoread(txtx) 

cXml     :="C:\ACBrMonitorPLUS\"+Agchave+"-nfe.XML"
cXml     :=Memoread(cXml)
HANDLE :=  FCREATE (cSubDir+Agchave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,cXml)
fclose(handle)  

*MSGINFO(Agchave)
cQuery := "UPDATE NFCE SET chave='"+Agchave+"',NOTATXT='"+AllTrim(xcml)+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
endif
Endif

Next
tQuery:Destroy()
*janelanfe.release
Return Nil







*--------------------------------------------------------------*
Function reenviar_Class()
*--------------------------------------------------------------*
Local cchave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 7))))
Local pnumero:= (val((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local pserie := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
Local pTEXTE := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 11 ))))
local xJust:="Sem acesso a Internet" 
LOCAL nSeconds := 0, nCount := 4, lLoop := .T.
local cStat     :="" 
LOCAL cNProt     :=""
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt '
Local FC_NORMAL
local path :=DiskName()+":\"+CurDir()
local cXMotivo:=""
local R_CStat:=''
local xchave:=""
LOCAL cUF:=''
LOCAL cCertificado:=""
Criadir_nfce()
xnt_retorno:=""
*/
oQuery        :=oServer:Query( "SELECT CHAVE,nt_retorno,NOTATXT FROM NFCE WHERE CbdNtfNumero = "+NTRIM(pnumero)+" AND  cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+"  Order By CbdNtfNumero" )
oRow          := oQuery:GetRow(1)
HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)

*/

 
* vdata:=dtos(date()-20)
* vdata1:=dtos(date())

 vdata:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_001.value)
 vdata1:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_002.value)
 
 
tQuery := oServer:Query( "Select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO,NOTATXT From NFCE WHERE  (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" or nt_retorno='' or autorizacao='0') Order By CbddEmi" )
If tQuery:NetErr()
    MsgInfo("Nao foi encontrado nada")
    Return Nil
  Endif
For i := 1 To tQuery:LastRec()
  oRow       :=tQuery:GetRow(i)
   pnumero   := (oRow:fieldGet(1))
 cChave      :=ALLTRIM(oRow:fieldGet(2))
 Xnt_retorno :=oRow:fieldGet(3)
pserie       :=oRow:fieldGet(4)
 XAUTORIZACAO:=oRow:fieldGet(5)
***********************************************************
HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(6))
fclose(handle)  
public cTXT     :=PATH+"\NFCE.TXT"
bRetornaXML:=""


public cTXT     :=PATH+"\NFCE.TXT"
*****************************************************
*** vamos gera outro xml para prevesao futuras 
******************************************************

   oNfe:= hbNfe()
   oNFe:cUFWS      := '11' // UF WebService
   oNFe:tpAmb      := cAmbiente // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNfe:cPastaSchemas :=DiskName()+":\"+CurDir()+"\"+"Schemas"
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=cSubDirTMP
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:=PATH+"\NFCE.TXT"
   oIniToXML := hbNFCeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oValida := hbNFeValida()
   oIniToXML:IDToken := alltrim(vcIdToken)
   oIniToXML:Token := alltrim(mgIDToken)
   oIniToXML:lValida := .T.
   aRetorno  := oIniToXML:execute()
   oValida:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML := Nil	
   Cchave    :=(aRetorno['cChaveNFe'])
   xCbdNtfSerie:=SUBSTR(Cchave,23,3)
   xnumero     :=SUBSTR(Cchave,26,9)
   cnumero     :=SUBSTR(Cchave,26,9)
   cTexto      :=Cchave+"-nfe.XML"
   
*******************************************************************
   BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI
*******************************************************
  *********Verifica serviço******************
*******************************************************
oSefaz     := SefazClass():New()
oSefaz:cUF := cUF
oSefaz:cAmbiente:=cAMBIENTE
cXmlRetorno := oSefaz:NfeStatus()
hb_MemoWrit( "servico.xml", oSefaz:cXmlRetorno )
cFileDanfe:= "servico.xml"
Linha   := Memoread(cFileDanfe)
xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha), .f. )
********************************************* 
if cambiente='1'
 ambiente:="Produção"
 else
   ambiente:="Homologação"
 endif
****************************************************
if xcStat="107"  
ELSE
 xxmotivo:="Serviço Solicitado não Esta Ativo, ou sem Conecção na Internet"
 HB_Cria_Log_nfce(xcStat,xxmotivo+"  Amb.:"+ambiente)
   HB_Cria_Log_nfce(xcStat,xxmotivo+"  Amb.:"+ambiente)
 Return .f.
 ThisWindow.release 
endif
HB_Cria_Log_nfce(xcStat,xxmotivo+"  Amb.:"+ambiente)
***************************************************************
********* se tem servicao ******  vamos consultar
 ******************************************
 
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cNFCE:='S' 	 

   oSefaz:NFeConsultaProtocolo( cChave, cCertificado , cAmbiente )
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
   xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha),.f. )
   chNFe     := PegaDados('chNFe' ,Alltrim(Linha),.f. )
   nProt     := PegaDados('nProt' ,Alltrim(Linha),.f. )
   HB_Cria_Log_nfce(xcStat,xxmotivo+"  Consulta..:"+ambiente,NPROT)
   cTexto          :=Cchave+"-nfe.XML"
   cArquivo        :=memoread(cSubDirTMP+cTexto)
   cArquivo_Destino:=cSubDir+cChave+"-nfe.xml"
	
 IF  oSefaz:cStatus $ "100,101,150,301,302"
 
  oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )
  hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
  cXml     :=Memoread(cArquivo_Destino)
  HANDLE :=  FCREATE (cSubDir+cchave+"-nfe.XML",0)// cria o arquivo
  FWRITE(Handle,cXml)
  fclose(handle)  

 HB_Cria_Log_nfce(Cnumero,Cchave+"  Gravado no DB .:"+cArquivo_Destino) 
  cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("LINHA 1958 PROPLEMA")
  else
HB_Cria_Log_nfce(Cnumero,Cchave+"  Gravado no DB .:"+NTRIM(pnumero))
Endif


*********************************************************
********************************************************** 
ELSEIF  oSefaz:cStatus == "217"  // nao consta na base de dados
*********************************************************
// gerar contigencia 
  BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
	 SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
	 END INI
 MY_WAIT( 1 ) 
 
 ********************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI
******************************************************************	 
***********************************************************************************
	 //////////////////enviar/////////////////////////
********************************************************************************** 
   xCbdNtfSerie:=SUBSTR(Cchave,23,3)
   xnumero     :=SUBSTR(Cchave,26,9)
   cnumero     :=SUBSTR(Cchave,26,9)
   cTexto      :=Cchave+"-nfe.XML"
   cXml:= MEMOREAD(cSubDirTMP+cTexto)
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 
   oSefaz:cIdToken :=alltrim(vcIdToken)   
   
   oSefaz:cCSC     :=alltrim(mgIDToken)
  oSefaz:NFeLoteEnvia( @cXml, '1', cUF, ALLTRIM(cCertificado), cAmbiente )
   HB_Cria_Log_nfce(Cnumero,Cchave+"  Enviando...:"+oSefaz:cStatus)
   cArquivo_Destino:=cSubDir+CChave+"-nfe.xml"
   HB_Cria_Log_nfce(Cnumero,Cchave+"  Criando arquivo Assinado:"+cArquivo_Destino)

 	 
 IF  oSefaz:cStatus $ "100,101,150,301,302"
               oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )
				hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )

  hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo) 
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   hb_MemoWrit( "cXmlDocumento.xml", oSefaz:cXmlDocumento )
   hb_MemoWrit( "xmlRecibo.xml", oSefaz:cXmlRecibo )
   XmlProtocolo:= "XmlProtocolo.xml"
   XmlProtocolo   := Memoread(XmlProtocolo)
   HB_Cria_Log_nfce(Cnumero,Cchave+"  se deu tudo ok :"+oSefaz:cStatus)

   cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   CcSta   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
   CNPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )


   

 cArquivo_Destino:=cSubDir+CChave+"-nfe.xml"
 cXml:=Memoread( cArquivo_Destino)
  HB_Cria_Log_nfce(Cnumero,Cchave+"  Protocolo.:"+CNPROT)
 Query := "UPDATE NFCE SET CHAVE='"+Cchave+"',AUTORIZACAO='"+CNPROT+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else

  Endif
HB_Cria_Log_nfce(Cnumero,Cchave+"  Gravado no DB .:"+NTRIM(pnumero))
endif

oSefaz:NFeConsultaProtocolo( cChave, cCertificado , cAmbiente )
CcSta:= XmlNode(XmlNode(oSefaz:cXmlProtocolo, [infProt]), [cStat])
*msginfo(CcSta)
  
  
  
IF  CcSta  =="704"
     
  cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+"inutilizada"+"',AUTORIZACAO='"+"inutilizada"+"'  WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 HB_Cria_Log_nfce(Cnumero,Cchave+"  gravado...:"+oSefaz:cMotivo)
 * MsgInfo("sem PROPLEMA")
 Endif
endif 


**************************************************
ELSEIF  oSefaz:cStatus == "225" /// ERRO NO SCHEMAS
****************************************************


// gerar contigencia 
  BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
	 SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
	 END INI
 MY_WAIT( 1 ) 
 cRet       := MON_ENV("NFE.CriarEnviarNFe("+cTXT+",1,0,0,0)")
MY_WAIT( 1 ) 
   xCbdNtfSerie:=SUBSTR(Cchave,23,3)
   xnumero     :=SUBSTR(Cchave,26,9)
   cnumero     :=SUBSTR(Cchave,26,9)
   cTexto      :=Cchave+"-nfe.XML"
   cXml:= MEMOREAD(cSubDirTMP+cTexto)
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 
   oSefaz:cIdToken :=alltrim(vcIdToken)   
   
   oSefaz:cCSC     :=alltrim(mgIDToken)
  oSefaz:NFeLoteEnvia( @cXml, '1', cUF, ALLTRIM(cCertificado), cAmbiente )
   HB_Cria_Log_nfce(Cnumero,Cchave+"  Enviando...:"+oSefaz:cStatus)
   cArquivo_Destino:=cSubDir+CChave+"-nfe.xml"
   HB_Cria_Log_nfce(Cnumero,Cchave+"  Criando arquivo Assinado:"+cArquivo_Destino)

 	 
 IF  oSefaz:cStatus $ "100,101,150,301,302"
               oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )
				hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )

  hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo) 
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   hb_MemoWrit( "cXmlDocumento.xml", oSefaz:cXmlDocumento )
   hb_MemoWrit( "xmlRecibo.xml", oSefaz:cXmlRecibo )
   XmlProtocolo:= "XmlProtocolo.xml"
   XmlProtocolo   := Memoread(XmlProtocolo)
   HB_Cria_Log_nfce(Cnumero,Cchave+"  se deu tudo ok :"+oSefaz:cStatus)

   cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   CcSta   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
   CNPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )

 cArquivo_Destino:=cSubDir+CChave+"-nfe.xml"
 cXml:=Memoread( cArquivo_Destino)
  HB_Cria_Log_nfce(Cnumero,Cchave+"  Protocolo.:"+CNPROT)
 Query := "UPDATE NFCE SET CHAVE='"+Cchave+"',AUTORIZACAO='"+CNPROT+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else

  Endif
HB_Cria_Log_nfce(Cnumero,Cchave+"  Gravado no DB .:"+NTRIM(pnumero))
endif

**************************************************
*********************************************** 
ELSEIF  oSefaz:cStatus $ "526" /// NFE FORA DE PRAZO
*******************************************************
*******************************************************
cCStat :=""       
cNProt :=""        
cXMotivo:=""  


ccnpj  :="84712611000152"
cJus   :="Erro na sequencia de emissao"
nMod   :="65"
nIni   :=val(SUBSTR(cChave,26,9)) 
nSer   :=val(SUBSTR(cChave,23,3)) 
nAno   := '20'+substr(cChave,3,2)

oSefaz := SefazClass():New()
oSefaz:cNFCE:='S' 
oSefaz:NFeInutiliza( nAno, cCnpj, nMod, nSer, nIni, nFin, cJus, cUF, cCertificado, cAmbiente  )
   
IF oSefaz:cStatus $ "102"
   c_CStat:="102"
   hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo )
   hb_MemoWrit( "xmlautorizado.xml", oSefaz:cXmlAutorizado )
   hb_MemoWrit( "xmloriginal.xml", oSefaz:cXmlDocumento )
   hb_MemoWrit( "xmlretorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:="xmlretorno.xml"
    Linha   := Memoread(cFileDanfe)
     auto   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
 c_XMotivo  := PegaDados('xMotivo' ,Alltrim(Linha), .f. )
 
c_XMotivo:=cXMotivo
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+c_XMotivo+"'  WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 * msginfo('0')
  Endif
endif


ELSEIF  oSefaz:cStatus == "613" ///CHAVE DE ACESSO DIFERENTE DA EXISTENTE  



   hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo )
   hb_MemoWrit( "xmlautorizado.xml", oSefaz:cXmlAutorizado )
   hb_MemoWrit( "xmloriginal.xml", oSefaz:cXmlDocumento )
   hb_MemoWrit( "xmlretorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:="xmlretorno.xml"
    Linha   := Memoread(cFileDanfe)
    auto   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
 xcchave   := PegaDados('xMotivo' ,Alltrim(Linha), .f. )

 
public Agchave   :=SUBSTR(xcchave,91, 44)
public TPemis    :=SUBSTR(Agchave,35, 1)
*msginfo(Agchave)


if TPemis="1"
 BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
*	 SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
 END INI
endif

 
  oNfe:= hbNfe()
   oNFe:cUFWS      := '11' // UF WebService
   oNFe:tpAmb      := cAmbiente // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNfe:cPastaSchemas :=DiskName()+":\"+CurDir()+"\"+"Schemas"
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=cSubDirTMP
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:=PATH+"\NFCE.TXT"
   oIniToXML := hbNFCeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oValida := hbNFeValida()
   oIniToXML:IDToken := alltrim(vcIdToken)
   oIniToXML:Token := alltrim(mgIDToken)
   oIniToXML:lValida := .T.
   aRetorno  := oIniToXML:execute()
   oValida:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML := Nil	
   Cchave    :=(aRetorno['cChaveNFe'])
   xCbdNtfSerie:=SUBSTR(Cchave,23,3)
   xnumero     :=SUBSTR(Cchave,26,9)
   cnumero     :=SUBSTR(Cchave,26,9)
   cTexto      :=Cchave+"-nfe.XML"
  

   oSefaz:NFeConsultaProtocolo( Agchave, cCertificado , cAmbiente )
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "XmlRetorno.xml"

 cFileDanfe:="xmlretorno.xml"
 Linha   := Memoread(cFileDanfe)
 auto   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
 xMotivo   := PegaDados('xMotivo' ,Alltrim(Linha), .f. )
    cTexto          :=Cchave+"-nfe.XML"
   cArquivo        :=memoread(cSubDirTMP+cTexto)
   cArquivo_Destino:=cSubDir+cChave+"-nfe.xml"
	
 IF  oSefaz:cStatus $ "100,101,150,301,302"
 
  oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )
  hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
  cXml     :=Memoread(cArquivo_Destino)
  HANDLE :=  FCREATE (cSubDir+cchave+"-nfe.XML",0)// cria o arquivo
  FWRITE(Handle,cXml)
  fclose(handle)  

 HB_Cria_Log_nfce(Cnumero,Cchave+"  Gravado no DB .:"+cArquivo_Destino) 
  cQuery := "UPDATE NFCE SET AUTORIZACAO='"+nProt+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("LINHA 1958 PROPLEMA")
  else
HB_Cria_Log_nfce(Cnumero,Cchave+"  Gravado no DB .:"+NTRIM(pnumero))
Endif
endif
Endif

Next
tQuery:Destroy()
janelanfe.release
Return Nil

	

			
Function TESTE613()
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt '
			//////////////////consultar/////////////////////////
*cchave:="11180384712611000152650020000212829000000010"
 pnumero:=21282
 pserie:='2'
 cchave:="11180384712611000152650020000212821000000015"
*XMotivo=Rejeicao: Codigo Numerico informado na Chave de Acesso difere do Codigo Numerico da NF-e [

xcchave:=""		
 cRet       := MON_ENV("NFE.ConsultarNFe("+cchave+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 
xcchave:=""

       lRetStatus:=EsperaResposta(cDestino)
       if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         *MSGINFO(memoread(cDestino))
         cEnvio_XML:=.f.
      
		else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
 	  * get xcchave         section  "CONSULTA"       ENTRY "ChNFe"
 	   get xcchave         section  "CONSULTA"       ENTRY "XMotivo"
	   END INI
endif
ENDIF

public Agchave   :=SUBSTR(xcchave,91, 44)
public TPemis    :=SUBSTR(Agchave,35, 1)

*MSGINFO(TPemis)


cQuery := "UPDATE NFCE SET chave='"+Agchave+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
endif
RETURN

			
			
			
*--------------------------------------------------------------*
STATIC Function Reimprimir()
*--------------------------------------------------------------*
Local pachave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe",6))))
Local pnumero:= (val((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local pserie := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
Local pxml   := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 9 ))))
Local pTXT   := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 12))))
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
local cCStat    :=""//2
local c_VerAplic:=""//SVRS20100811185009
local cXMotivo :=""//Autorizado o uso da NF-e
local c_ChNFe   :=""//11110384712611000152550010000004201000004201
local c_DhRecbto:=""//29/03/2011 07:47:33
local c_NProt   :=""//311110000010110
LOCAL nSeconds := 0, nCount := 4, lLoop := .T.
LOCAL Ret_Status_Servico:=.T.
LOCAL nLote    := '0'
local R_DigVal:=''
local R_DhRecbto:='' 
local r_CodigoERRO:=""
local xJust:="Sem acesso a Internet" 
Local r_ChNFe    :="" 
local r_Stat     :="" 
LOCAL cNProt     :=""
local r_MensagemERRO:=""
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
Local FC_NORMAL
local path :=DiskName()+":\"+CurDir()
LOCAL IRetorno:=""
 lRetorno_Internet:=IsInternet()
 if lRetorno_Internet==.f.
   mCbdtpEmis:="0"
	NFe_EMISSAO(mCbdtpEmis)
     else
    mCbdtpEmis:="1"
	NFe_EMISSAO(mCbdtpEmis)
end
 
oQuery        :=oServer:Query( "SELECT CHAVE,nt_retorno,nfcedaruma FROM NFCE WHERE CbdNtfNumero = "+NTRIM(pnumero)+" AND  cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+"  Order By CbdNtfNumero" )
oRow          := oQuery:GetRow(1)
xchave        :=ALLTRIM(oRow:FieldGet(1))
  
HANDLE :=  FCREATE ("nfcedaruma1.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)  

public dDestino      :=PATH+"\nfcedaruma1.TXT"
nfcedaruma1          :=memoread(dDestino) 

IRetorno:=iImprimirTexto_DUAL_DarumaFramework(nfcedaruma1)
   
RETURN
			

						

*--------------------------------------------------------------*
STATIC Function busca_numero()                     
*--------------------------------------------------------------*

	
Ajanela := GetDesktopWidth() //* 0.78125
Ljanela := GetDesktopHeight() //* 0.78125 

SET BROWSESYNC ON	

IF ISWINDOWDEFINED(NFE_EMITIDA_CONTIGENCIA)
    RESTORE WINDOW NFE_EMITIDA_CONTIGENCIA
ELSE
      DEFINE WINDOW NFE_EMITIDA_CONTIGENCIA;
       AT 0100, 200 ;
       WIDTH 400;
       HEIGHT 350;
       TITLE "nFe/nfc_e Emitidas " ;
       icon cPathImagem+'JUMBO1.ico';
       MODAL;   
       NOSIZE
	   
	   
   @ 10, 010  FRAME oGrp22 ;
   CAPTION "Pesquisa numero"  ;
   WIDTH 350 ;
   HEIGHT 150 ;
   FONT "MS Sans Serif" SIZE 14.00 ;
   FONTCOLOR { 255, 255, 000 };

 
 
   
  DEFINE TEXTBOX  numero_i
           ROW    40
           COL    10
            WIDTH  100
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX 
	
	  
	  DEFINE TEXTBOX  serie_i
           ROW    40
           COL   125
            WIDTH  20
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX 
	
	  
	  
   
   @ 40, 180  label ate ;
   WIDTH 30 HEIGHT         30 ;
   VALUE "Ate";
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
      


  DEFINE TEXTBOX numero_f
           ROW    40
           COL    240
            WIDTH  100
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX   
  
    @ 170, 10   LABEL oSay5 ;
   WIDTH 450 ;
   HEIGHT 30 ;
   VALUE ""  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   
     define buttonex confirma
                       row 100
                       col 010
                       width 110
                       height 030
                       caption 'Consulta'
                       picture cPathImagem+'ok.bmp'
                       fontbold .T.
                       lefttext .F.
                      action busca_numero_1() 
                end buttonex
     
   
   
   
     define buttonex deleta
                       row 100
                       col 200
                       width 110
                       height 030
                       caption 'Deleta'
                       picture cPathImagem+'ok.bmp'
                       fontbold .T.
                       lefttext .F.
                      action deleta() 
                end buttonex
     
   
     
   
                      ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela

					  
					  
       
END WINDOW
CENTER WINDOW NFE_EMITIDA_CONTIGENCIA
ACTIVATE WINDOW NFE_EMITIDA_CONTIGENCIA
ENDIF
Return Nil



*--------------------------------------------------------------*
STATIC Function busca_numero_1()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(janelanfe.cSearch.Value ))+'%" '           
Local nCounter:= 0
Local oRow

Local i
local c_nf
Local oQuery
local c_encontro
DELETE ITEM ALL FROM Grid_notas Of janelanfe
 * vdata:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_001.value)
 *vdata1:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_002.value)
  
vnumero :=NFE_EMITIDA_CONTIGENCIA.numero_i.value
vnumero1:=NFE_EMITIDA_CONTIGENCIA.numero_f.value
serie_i :=NFE_EMITIDA_CONTIGENCIA.serie_i.value

  
  

  oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,HORAS,Chave,autorizacao,nt_retorno,Cbdcheveevento,NOTATXT,nfcedaruma From NFCE WHERE CbdNtfNumero >= "+vnumero+" and CbdNtfNumero <= "+vnumero1+" and CbdNtfSerie="+serie_i+" Order By CbdNtfNumero" )
*  cQuery:= "DELETE FROM NFCE  WHERE CODIGO = " + AllTrim(gCode)   

	
 
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12)} TO Grid_notas Of janelanfe
 oQuery:Skip(1)
  Next
oQuery:Destroy()
*janelanfe.cSearch.SetFocus  
janelanfe.Grid_notas.value:=1
janelanfe.Grid_notas.setfocus
ThisWindow.release
Return Nil


*--------------------------------------------------------------*
STATIC Function deleta()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(janelanfe.cSearch.Value ))+'%" '           
Local nCounter:= 0
Local oRow
Local i
local c_nf
Local oQuery
local c_encontro
DELETE ITEM ALL FROM Grid_notas Of janelanfe

vnumero :=NFE_EMITIDA_CONTIGENCIA.numero_i.value
vnumero1:=NFE_EMITIDA_CONTIGENCIA.numero_f.value
serie_i :=NFE_EMITIDA_CONTIGENCIA.serie_i.value 
  

   cQuery:= "DELETE FROM NFCE WHERE CbdNtfNumero >= "+vnumero+" and CbdNtfNumero <= "+vnumero1+" and CbdNtfSerie="+serie_i+" Order By CbdNtfNumero" 
  *cQuery:= "DELETE FROM NFCE  WHERE CODIGO = " + AllTrim(gCode)   

  oQuery:=oServer:Query( cQuery )
   If oQuery:NetErr()
    MsgInfo("Por Favor Selecione o registro que deseja alterar")
 else
    oQuery:Destroy()			 																			
    MsgInfo("Registro deletado!")
  EndIf
  
  


  cQuery:= "DELETE FROM ITEMNFCE WHERE CbdNtfNumero >= "+vnumero+" and CbdNtfNumero <= "+vnumero1+" and CbdNtfSerie="+serie_i+" Order By CbdNtfNumero" 
  oQuery:=oServer:Query( cQuery )
   If oQuery:NetErr()
    MsgInfo("Por Favor Selecione o registro que deseja alterar")
  else   
    oQuery:Destroy()			 																			
    MsgInfo("Registro deletado!")
  EndIf
 
 
ThisWindow.release
Return Nil






*________________________________________________________________________________________________
STATIC Function busca_contigencia()  
 local nLinha   := 0
 local nPagina  := 1
 local mtotal   :=0
 
close all 
USE ((ONDETEMP)+"CONTIGE.DBF") VIA "DBFCDX" new alias CONTIGE exclusive    // arquivo que vai ter todo o conteudo do TXT
zap
PACK

abrecontige()
SELE contige 

  vdata:=dtos(date())
  vdata1:=dtos(date())

	*   oQuery := oServer:Query( "SELECT CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horaS,Chave,autorizacao,nt_retorno,Cbdcheveevento,NOTATXT,nfcedaruma From NFCE " )
	   oQuery := oServer:Query( "SELECT CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horaS,Chave,autorizacao,nt_retorno,Cbdcheveevento,NOTATXT,nfcedaruma From NFCE WHERE  CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+"  Order By CbdNtfNumero" )


       If !oQuery:eof()
          For i:=1 to oQuery:LastRec()
             oRow := oQuery:GetRow(i)
	      x_doc        := oRow:fieldGet(1)
          x_serie        := oRow:fieldGet(2)
          X_xml      := oRow:fieldGet(9)
  	      x_chave       := oRow:fieldGet(7) 
  


                       SELE contige 
                  	   contige->(dbappend())
		               contige->chave  :=x_chave
					  * contige->serie  :=val(x_serie)
					   contige->NUMERO := (x_doc)
				        contige->(dbunlock())
	
	Next i
	oQuery:Destroy()
    EndIf

dbselectarea('CONTIGE')
CONTIGE->(dbgotop())
while .not. eof()
  CONTIGE->(ordsetfocus('CONTIGE'))
cQuery := "INSERT INTO nfCE_CONTIGENCIA (CbdNtfNumero,Chave,CbdEmpCodigo,CbdNtfSerie) VALUES ('"+NTRIM(contige->NUMERO)+"','"+contige->chave+"','"+"1"+"','"+NTRIM(contige->serie)+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 MsgInfo("Por Favor Selecione o registro ffff ") 
else	
*MSGINFO("OK GRAVA ")
ENDIF
Contige->(dbskip())
end

Return Nil





Function importaxml_acbr()
local xJust:="Sem acesso a Internet" 
LOCAL nSeconds := 0, nCount := 4, lLoop := .T.
local cStat     :="" 
LOCAL cNProt     :=""
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt '
Local FC_NORMAL
local path :=DiskName()+":\"+CurDir()
local cXMotivo:=""
local R_CStat:=''
local xchave:=""
LOCAL cUF:=''
LOCAL cCertificado:=""

*******************************************************************
   BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI
	 
PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFCe")
pdf   :=alltrim(zNUMERO+xxANO+"-pdfNFCe")
tmp  :=alltrim(zNUMERO+xxANO+"-tmpNFCe")

      public   cSubDir := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	public   cSubDirTMP:= DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+tmp+"\"
  		 nError := MakeDir( cSubDirTMP )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF


Reconectar_A()

 vdata:=dtos(date()-23)
 vdata1:=dtos(date())
 
 * vdata:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_001.value)
 * vdata1:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_002.value)

  tQuery := oServer:Query( "Select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO,NOTATXT From NFCE WHERE  (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" and nt_retorno=''  ) Order By CbddEmi" )
 * tQuery := oServer:Query( "Select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO,NOTATXT From NFCE WHERE CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" Order By CbdNtfNumero" )
If tQuery:NetErr()
    MsgInfo("Nao foi encontrado nada")
    Return Nil
  Endif
For i := 1 To tQuery:LastRec()
  oRow       :=tQuery:GetRow(i)
   pnumero   := (oRow:fieldGet(1))
 xChave      :=ALLTRIM(oRow:fieldGet(2))
 Xnt_retorno :=oRow:fieldGet(3)
pserie       :=oRow:fieldGet(4)
 XAUTORIZACAO:=oRow:fieldGet(5)
***********************************************************
HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(6))
fclose(handle)  
public cTXT     :=PATH+"\NFCE.TXT"
bRetornaXML:=""
public cTXT     :=PATH+"\NFCE.TXT"
bRetornaXML:=""
/*
   oNfe:= hbNfe()
   oNFe:cUFWS      := '11' // UF WebService
   oNFe:tpAmb      := cAmbiente // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNfe:cPastaSchemas :=DiskName()+":\"+CurDir()+"\"+"Schemas"
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=cSubDirTMP
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:=PATH+"\NFCE.TXT"
   oIniToXML := hbNFCeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oValida := hbNFeValida()
   oIniToXML:IDToken := alltrim(vcIdToken)
   oIniToXML:Token := alltrim(mgIDToken)
   oIniToXML:lValida := .T.
   aRetorno  := oIniToXML:execute()
   oValida:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML := Nil	
   Cchave    :=(aRetorno['cChaveNFe'])
   xCbdNtfSerie:=SUBSTR(Cchave,23,3)
   xnumero     :=SUBSTR(Cchave,26,9)
   cnumero     :=SUBSTR(Cchave,26,9)
   cTexto      :=Cchave+"-nfe.XML"
   cTexto          :=Cchave+"-nfe.XML"
   cArquivo        :=memoread(cSubDirTMP+cTexto)
   cArquivo_Destino:=cSubDir+Cchave+"-nfe.xml"
  */
  
  
 * HB_Cria_Log_nfce( pnumero,xChave+"  CHAVE CONSULTADA.:"+NTRIM( pnumero))
 
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 
   oSefaz:cIdToken :=alltrim(vcIdToken)   
   
  oSefaz:NFeConsultaProtocolo( xChave, cCertificado , cAmbiente )
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "XmlRetorno.xml"
   cFileDanfe:="xmlretorno.xml"
    Linha   := Memoread(cFileDanfe)

	

if  oSefaz:cStatus == "613" ///CHAVE DE ACESSO DIFERENTE DA EXISTENTE  

   hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo )
   hb_MemoWrit( "xmlautorizado.xml", oSefaz:cXmlAutorizado )
   hb_MemoWrit( "xmloriginal.xml", oSefaz:cXmlDocumento )
   hb_MemoWrit( "xmlretorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:="xmlretorno.xml"
    Linha   := Memoread(cFileDanfe)
    auto   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
 xcchave   := PegaDados('xMotivo' ,Alltrim(Linha), .f. )

 
public Agchave   :=SUBSTR(xcchave,91, 44)
public TPemis    :=SUBSTR(Agchave,35, 1)

HB_Cria_Log_nfce(Cnumero,Agchave+"  DEPOIS DA CONSULAR:"+oSefaz:cStatus)
HB_Cria_Log_nfce(Cnumero,Agchave+"  CHAVE CERTA .:"+NTRIM(pnumero))



if TPemis="1"
 BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
*	 SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
 END INI
endif

 
   oNfe:= hbNfe()
   oNFe:cUFWS      := '11' // UF WebService
   oNFe:tpAmb      := cAmbiente // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
  * oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNfe:cPastaSchemas :=DiskName()+":\"+CurDir()+"\"+"Schemas"
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=cSubDirTMP
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:=PATH+"\NFCE.TXT"
   oIniToXML := hbNFCeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oValida := hbNFeValida()
   oIniToXML:IDToken := alltrim(vcIdToken)
   oIniToXML:Token := alltrim(mgIDToken)
   oIniToXML:lValida := .T.
   aRetorno  := oIniToXML:execute()
   oValida:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML := Nil	
   Cchave    :=(aRetorno['cChaveNFe'])
   xCbdNtfSerie:=SUBSTR(Cchave,23,3)
   xnumero     :=SUBSTR(Cchave,26,9)
   cnumero     :=SUBSTR(Cchave,26,9)
   cTexto      :=Cchave+"-nfe.XML"
   cArquivo        :=memoread(cSubDirTMP+cTexto)
   cArquivo_Destino:=cSubDir+Cchave+"-nfe.xml"
  
  
HB_Cria_Log_nfce(Cnumero,Cchave+" SEGUNDA GERACAO CHAVE CERTA .:"+NTRIM(pnumero))


   oSefaz:NFeConsultaProtocolo( Agchave, cCertificado , cAmbiente )
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "XmlRetorno.xml"

   
   
 cFileDanfe:="xmlretorno.xml"
 Linha   := Memoread(cFileDanfe)
 auto   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
 xMotivo   := PegaDados('xMotivo' ,Alltrim(Linha), .f. )
 chNFeAUT  := PegaDados('chNFe' ,Alltrim(Linha), .f. )
 

 *   cTexto          :=chNFeAUT+"-nfe.XML"
 *  cArquivo        :=memoread(cSubDirTMP+cTexto)
 *  cArquivo_Destino:=cSubDir+chNFeAUT+"-nfe.xml"
	
 IF  oSefaz:cStatus $ "100,101,150,301,302"
 
  oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )
  hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
  cXml     :=Memoread(cArquivo_Destino)
  HANDLE :=  FCREATE (cSubDir+chNFeAUT+"-nfe.XML",0)// cria o arquivo
  FWRITE(Handle,cXml)
  fclose(handle)  

 HB_Cria_Log_nfce(Cnumero,chNFeAUT+"  Gravado no DB .:"+cArquivo_Destino) 
  cQuery := "UPDATE NFCE SET CHAVE = '"+chNFeAUT+"',AUTORIZACAO='"+auto+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("LINHA 1958 PROPLEMA")
  else
HB_Cria_Log_nfce(Cnumero,chNFeAUT+"  Gravado no DB .:"+NTRIM(pnumero))
Endif
endif
Endif

Next
tQuery:Destroy()
janelanfe.release
Return Nil




Procedure NFe_Check( cRef )                    
             LOCAL oQuery_NFe:=""
			 Local aNFe		:={}  
      	     oNfe:=hbNfe()           
		  
vdata:=dtos(date()-23)
vdata1:=dtos(date())
 *tQuery := oServer:Query( "Select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO,NOTATXT From NFCE WHERE  (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" and nt_retorno=''  ) Order By CbddEmi" )
  oQuery_NFe:=oServer:Query("select CbdNtfNumero,CbddEmi,Chave FROM nfce where (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" AND nt_retorno='' )  order by cbddemi")
         	If oQuery_NFe:NetErr()												
			*      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe:Error())
	         Endif
           
				For NFe := 1 To oQuery_NFe:LastRec()
					  oRow := oQuery_NFe:GetRow(NFe)
			 			aadd(aNFe,{oRow:fieldGet(1) , oRow:fieldGet(2), oRow:fieldGet(3) })
 			   Next
			   oQuery_NFe:Destroy()
				For x := 1 To len(aNFe)
					   Envia_Contigencia( aNFe[x,1] , aNFe[x,2], aNFe[x,3] ) 
 			   Next
      
          Return Nil          
/*
*/
Procedure Envia_Contigencia( cNUMERO , dEmissao , cChave )  

		Execute_Consulta(  cNUMERO , dEmissao , cChave ) 

Return Nil          



Procedure Execute_Consulta(  cNUMERO , dEmissao , cChave )  
  
cUF:=''
cCertificado:=""

*******************************************************************
   BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI

	 
PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFCe")
pdf   :=alltrim(zNUMERO+xxANO+"-pdfNFCe")
tmp  :=alltrim(zNUMERO+xxANO+"-tmpNFCe")

      public   cSubDir := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	public   cSubDirTMP:= DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+tmp+"\"
  		 nError := MakeDir( cSubDirTMP )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF



cPasta:=CurDrive()+":\"+ CurDir() + '\'
cModelo:=substr(cChave,21,2)
cArquivo_Destino:=cSubDir

If !Empty(cChave)

				oQuery_NFe:=oServer:Query("select  nt_retorno  FROM nfce where  Chave='"+cChave+"'")
 	
         	If oQuery_NFe:NetErr()												
			      HB_Cria_Log_SQL('Envio Contigencia',oServer:Query:Error())
	         Endif

				oRow:= oQuery_NFe:GetRow(1)

	  		 	HANDLE :=  FCREATE (cPasta+"NOTA.XML",0)// cria o arquivo
			   FWRITE(Handle,oRow:FieldGet(1))
			  fclose(handle) 
							 
				cArquivo  :=memoread(cPasta+"NOTA.XML")

				ano:= substr(dtos(dEmissao),0,4)
				mes:= substr(dtos(dEmissao),5,2)

 
			*cPasta_NFe:=Criar_Pasta_NFe(substr(cChave,21,2),substr(cChave,5,2),'20'+substr(cChave,3,2))
	    	cPasta_NFe:=cPasta
		*	cPasta_NFe:=Criar_Pasta_NFe(substr(cChave,21,2),substr(cChave,5,2),'20'+substr(cChave,3,2))
		
			cArquivo_Destino:=cPasta_NFe+cChave+"-nfe.xml"

		   oSefaz:= SefazClass():New()
		  oSefaz:cUF := cUF                                                                
		   oSefaz:cAmbiente:='1'
		 /*
		   if cModelo=='65'
		   	oSefaz:cNFCE:='S'
         end
      */
	  
cUF:=''
cCertificado:=""

*******************************************************************
   BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI


if substr(cChave,35,1)=='1'    						  
 
			oSefaz:NFeConsultaProtocolo(  cChave, cCertificado, '1'  )

			hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
 
 			 // msginfo(oSefaz:cStatus+"-"+  oSefaz:cMotivo)
		   IF  oSefaz:cStatus $ "100,101,150,301,302"

 				oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )

				hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
				
         * 	If oQuery_NFe:NetErr()												
			*      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe:Error())
	        * Endif
/*
		 		oQuery_NFe:=oServer_NFe:Query("UPDATE nfce SET CBDStatus='"+oSefaz:cMotivo+"',CBDProtocolo='"+ XmlNode( oSefaz:cXmlRetorno, "nProt" ) +;
				 			"',xml='" +oSefaz:cXmlAutorizado+"' WHERE CbdChave='"+cChave+"'"  )  
*/

        *  	If oQuery_NFe:NetErr()	 											
		*	      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe:Error())
	     *    Endif
		   ELSEIF  oSefaz:cStatus == "217"  // nao consta na base de dados

		   MSGINFO("217")
		   
	    *    Gera_Arquivo_TXT(cChave,dEmissao,'9')  

		   ELSEIF  oSefaz:cStatus == "225" /// ERRO NO SCHEMAS
		      MSGINFO("225")
			  
	         *Gera_Arquivo_TXT(cChave,dEmissao,'9')  

		   ELSEIF  oSefaz:cStatus $ "526" /// NFE FORA DE PRAZO

		     MSGINFO("526")
			 
           *  Inutiliza_NFCe_Class(cChave,oSefaz:cMotivo)

		   ELSEIF  oSefaz:cStatus == "613" ///CHAVE DE ACESSO DIFERENTE DA EXISTENTE

 /*
		   	cNovaChave:=substr(oSefaz:cMotivo,91,44)

		 		oQuery_NFe:=oServer_NFe:Query("UPDATE nfce SET CBDChave='"+cNovaChave+"' WHERE CbdChave='"+cChave+"'"  )  

          	If oQuery_NFe:NetErr()	 											
			      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe:Error())
	         Endif
			 
	*/		 
ENDIF 

MSGINFO("613")
  
			
elseif substr(cChave,35,1)=='9'    						  

MSGINFO("Gera_Arquivo_TXT")

    *     Gera_Arquivo_TXT(cChave,dEmissao,substr(cChave,35,1))  

End         
END

Return          
