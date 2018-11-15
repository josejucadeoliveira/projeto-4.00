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

SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
zNUMERO        :=xSEQ_TEF :=strzero(month(date() ), 2 )
xxANO          := dtoS(date())
xxANO          :=ALLTRIM(SUBSTR(xXANO,0,4))
Xml            :=alltrim(zNUMERO+xxANO+"-XML")
EVENTO_NFCE    :=alltrim(zNUMERO+xxANO+"-EVENTO_NFCE")
tmp            :=alltrim(zNUMERO+xxANO+"-tmp")
sSubDir        := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+xml+"\"
cSubDirTMP     := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+tmp+"\"
cSubDirevento  := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+EVENTO_NFCE+"\"			 
Reconectar_A()


DEFINE WINDOW janelanfe;
      AT 00, 00 ;
        width Ajanela; 
         height Ljanela-40;
       TITLE "Cupom emitidos" ;
       MODAL;   
       NOSIZE
	   
	  *ON INIT {||busca_data()} 
	  
 ON KEY ESCAPE ACTION janelanfe.release //tecla ESC para fechar a janela

//------------------------------------
	   
	   @ 520,670 BUTTONEX OButton_66 ;
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
	  ACTION  {||Reconectar_A() ,Importar_XML_BancoDeDados_saida_nfce_NFE()}
		   
      @ 540, 870   LABEL oSay1  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Total R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 


   @ 530, 1010  FRAME oGrp2 ;
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

    DEFINE LABEL Total_Geral1
            ROW    618
            COL    1010
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
            COL    1010
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
   @ 570, 870   FRAME oGrp11 ;
   CAPTION ""  ;
   WIDTH 120 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

      @ 580, 870 LABEL oSay11  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Desconto R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 
//---------------------------------------------
   @ 570, 1010 FRAME oGrp13 ; 
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

   DEFINE LABEL Total_desc
            ROW    580
            COL    1010
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
   @ 610, 870   FRAME oGrp12 ;
   CAPTION ""  ;
   WIDTH 120 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

      @ 618, 870 LABEL oSay12  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Total R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 
 
 @ 610, 1010 FRAME oGrp22 ;
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

  DEFINE LABEL Total_Geral1
            ROW    618
            COL   1010
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
       VALUE "Numero nfce" ;
      FONT "MS Sans Serif" SIZE 12.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 

  @ 480,170 TEXTBOX cSearch ;
    WIDTH 200 ;
    MAXLENGTH 400 ;
    UPPERCASE  ;
    backcolor _AMARELO;
   ON enter iif( !Empty(janelanfe.cSearch.Value), Grid_notas(), janelanfe.cSearch.SetFocus )

 
	
	@ 450, 480 LABEL Label_Search_data ;
      WIDTH 120 ;
      HEIGHT 034 ;
	  VALUE "Digita Data " ;
      FONT "MS Sans Serif" SIZE 12.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 

	  @ 450,670 DATEPICKER Date_5 ;
      WIDTH 180;
      TOOLTIP "Data" ;
      DATEFORMAT "dd/MM/yyyy"
 
 
	
	@ 480, 480 LABEL Label_Search_hora ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE "Digita  Hora " ;
      FONT "MS Sans Serif" SIZE 12.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 

	  @ 480,670 TIMEPICKER choras ;
      WIDTH 170;
      TOOLTIP " Time_3 TimePicker Control  " ;
      TIMEFORMAT "HH:mm:ss"
	  

	 @ 460,900 BUTTONEX OButton_p ;
      WIDTH 120 ;
      HEIGHT 40 ;
      CAPTION "Pesquisar"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Pesquisar" ;
      ACTION  {|| Grid_horas() }

	
 
	
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
      CAPTION "Reenviar_xml"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Reenviar_xml" ;
      ACTION  {||  reenviar()}
		
	
@ 520,350 BUTTONEX OButton_6 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Recriar class"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "recriar" ;
      ACTION  {|| recupera_recriar_xml_nfe_2018() }
	  
 @ 520,520 BUTTONEX OButton_20 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "recupera_xml_geral"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Recuperacao geral Xml" ;
      ACTION  {|| recupera_recriar_xml1()}			
			
	
	
@ 580,150 BUTTONEX OButton_7 ;
      WIDTH 150 ;
      HEIGHT 40 ;
      CAPTION "Consulta nfce"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Consulta nfce" ;
      ACTION  {|| ConsultanfCe()}
	
 
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
      CAPTION "Imprime_Cancelamento"  ;
      LEFTTEXT ;
      FONTCOLOR RED ;
      BACKCOLOR { { 1, { 203, 225, 252 }, { 126, 166, 225 } } } ;
      GRADIENTFILL { { 1, RGB( 251, 230, 148 ), RGB( 239, 150, 21 ) } } ;
      FLAT ;
      FONT "MS Sans serif" ;
      SIZE 11 ;
      BOLD ;
      TOOLTIP "Imprime_Cancelamento" ;
      ACTION  {|| lerxml_evento()}
				
 
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
      TOOLTIP "recupera_recriar_xml" ;
	  ACTION  {|| TIPO_CRIACAO()}
		 
 
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
      CAPTION "Reimprimir-NFce"  ;
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
            WIDTHS {80,50,250,100,100,100,100,350,200,200,400,400,300}
		    HEADERS {"N Nfc-e","Serie","Consumidor","Cnpj/Cpf","data","Horas","Valor","Chave","Autorização","XML","Evento","NOTATXT","nfcedaruma"}
            Justify {0,0,0,0,0,0,1,0,0,0,0,0}
      	    FONTNAME "Arial Baltic"
            FONTSIZE 11
            on dblclick { acha_itens(),TOTAL() }
	     *   ON CHANGE { acha_itens(),TOTAL() }
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

oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horas,cbdVNF,Chave,autorizacao,nt_retorno,MSCANCELAMENTO,NOTATXT,RETORNO_EVENTO From NFCE WHERE CbdNtfNumero ="+cSearch+" Order By CbddEmi" )
		   
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0

oRow := oQuery:GetRow(1)
* oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horas,cdbVnf,Chave,autorizacao,nt_retorno,MSCANCELAMENTO,NOTATXT,RETORNO_EVENTO From NFCE WHERE CbdNtfNumero = "+c_nf+" Order By CbddEmi" )
janelanfe.cSearch.setfocus
janelanfe.cSearch.Value:=""

For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
*  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),Str(oRow:fieldGet(7),10,2),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12),oRow:fieldGet(13)} TO Grid_notas Of janelanfe
   ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),Str(oRow:fieldGet(7),10,2),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12),oRow:fieldGet(13)} TO Grid_notas Of janelanfe

 
  oQuery:Skip(1)
  Next
oQuery:Destroy()
*janelanfe.cSearch.SetFocus  
janelanfe.Grid_notas.value:=1
janelanfe.Grid_notas.setfocus
Return Nil

*--------------------------------------------------------------*
STATIC Function Grid_horas()                     
*--------------------------------------------------------------*
Local xhoras:=(substr(janelanfe.choras.Value,1,2)) 
Local choras:= ' "'+Upper(AllTrim(xhoras ))+'%" '           
Local nCounter:= 0
Local oRow
Local i
local c_nf
Local oQuery
local c_encontro
DELETE ITEM ALL FROM Grid_notas Of janelanfe

vdata:=dtos(janelanfe.date_5.value)

*msginfo(choras)
*Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horas,Chave,autorizacao,nt_retorno,
*Cbdcheveevento,NOTATXT,nfcedaruma From NFCE WHERE
*CbddEmi='20180810' and
*horas  like "16%" Order By CbddEmi
oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horas,cbdVNF,Chave,autorizacao,nt_retorno MSCANCELAMENTO,NOTATXT,RETORNO_EVENTO From NFCE WHERE CbddEmi="+vdata+" and horas  like "+choras+"  Order By CbddEmi")
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
For i := 1 To oQuery:LastRec()
oRow := oQuery:GetRow(i)
*  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12)} TO Grid_notas Of janelanfe
   ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),Str(oRow:fieldGet(7),10,2),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12),oRow:fieldGet(13)} TO Grid_notas Of janelanfe

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

oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,horaS,cbdVNF,Chave,autorizacao,nt_retorno,MSCANCELAMENTO,NOTATXT,RETORNO_EVENTO From NFCE WHERE CbddEmi ="+dtos(date())+" Order By HORAS" )
	 
	   
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
   ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),Str(oRow:fieldGet(7),10,2),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12),oRow:fieldGet(13)} TO Grid_notas Of janelanfe
*  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12)} TO Grid_notas Of janelanfe
 oQuery:Skip(1)
  Next
oQuery:Destroy()
*janelanfe.cSearch.SetFocus  
janelanfe.Grid_notas.value:=1
janelanfe.Grid_notas.setfocus
Return Nil

Function recupera_recriar_xml1()
IF   GERA_NFE_NFCE=1

RECUPERA_XML()    
ELSE 
Check_nfce_BB()    
ENDIF 
RETURN


Function recupera_recriar_xml_nfe_CLASS()
IF   GERA_NFE_NFCE=1
recupera_recriar_xml_nfe_2018() 
ELSE 
*recupera_recriar_xml_class()  
Check_nfce_BB() 
ENDIF 
RETURN





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

   
     DEFINE RADIOGROUP RdG_Ambiente_NFCe       
               ROW    170
               COL    30
               WIDTH  148
               HEIGHT 29
               OPTIONS {'Tudos os Xml','So Com Retorno vazio'}
               VALUE 1
               HORIZONTAL .T.
		       BACKCOLOR {255,255,128}
        END RADIOGROUP  

   
   
   
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

IF NFE_EMITIDA_CONTIGENCIA.RdG_Ambiente_NFCe.VALUE == 1
  vdata:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_001.value)
  vdata1:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_002.value)
 oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,HORAS,cbdVNF,Chave,autorizacao,nt_retorno,MSCANCELAMENTO,NOTATXT,nfcedaruma From NFCE WHERE CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" Order By CbddEmi" )
ELSE
  vdata:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_001.value)
  vdata1:=dtos(NFE_EMITIDA_CONTIGENCIA.dpi_002.value)
  oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,HORAS,cbdVNF,Chave,autorizacao,nt_retorno,MSCANCELAMENTO,NOTATXT,nfcedaruma From NFCE WHERE CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" and nt_retorno=''  Order By CbddEmi" )
ENDIF

  
	
*WHERE DVENCIM >= "+vdata+" and DVENCIM <= "+vdata1+"	
	   
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
   ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),Str(oRow:fieldGet(7),10,2),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12),oRow:fieldGet(13)} TO Grid_notas Of janelanfe
 * ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12)} TO Grid_notas Of janelanfe
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
 *  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),Str(oRow:fieldGet(7),10,2),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12),oRow:fieldGet(13)} TO Grid_notas Of janelanfe

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
Local xchave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 7))))
Local pnumero:= (val((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local pserie := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
Local notatxt := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 11 ))))
local Lxml    := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 9 ))))
local aArqGet, x
Local nCounter:= 0
local ppchave:=""
Local oRow,ninfEventoId
Local i
LOCAL cCnpj := Space(14), cCertificado := "", cUF := "RO", cXmlRetorno

Local oQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()
LOCAL cChNFe :=""
local anomes:=""
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt'
ERASE "C:\ACBrMonitorPLUS\sai.txt"

oQuery        :=oServer:Query( "SELECT CHAVE,nt_retorno,notatxt FROM NFCE WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND  cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+"  Order By CbdNtfNumero" )
oRow          := oQuery:GetRow(1)

HANDLE :=  FCREATE ("C:\ACBrMonitorPLUS\"+xchave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  

HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)  
Destinotxt :=PATH+"\NFCE.TXT"
Destinotxt:=path+"\NFCE.TXT"
xChave:=oRow:FieldGet(1)


/////////////////criando///////////////////////////	
cRet       := MON_ENV("NFe.CriarNFe("+Destinotxt+","+""+")")
///////////////////////////////////////////////////
vNFE        := substr(xchave, 26, 09)
cSerie      :=val(SUBSTR(xChave,23,3))
nnfe:="NFE"+ALLTRIM(vNFE)
MY_WAIT( 1 ) 

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
  MY_WAIT( 1 ) 
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
end
public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO              :=c_cNProt
MY_WAIT( 1 ) 

fxml:="C:\ACBrMonitorPLUS\"+cChNFe+"-nfe.xml"
ffxml    :=memoread(fxml)
*MSGINFO(ffxml)
MY_WAIT( 1 ) 

 
    BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '1' ///contingencia para NFCe
  END INI
Destinotxt:=path+"\NFCE.TXT"



/////////////////criando///////////////////////////	
cRet       := MON_ENV("NFe.CriarNFe("+Destinotxt+","+""+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 
bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xchave      :=SUBSTR(variavel1,24,44)
vNFE        := substr(xchave, 26, 09)
cSerie      :=val(SUBSTR(xchave,23,3))

//////////////////enviar/////////////////////////
cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
MY_WAIT( 1 ) 

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




	   
IF c_CStat == "101"
cXml     :=Memoread(fxml)
 cQuery := "UPDATE NFCE SET nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 * MSGINFO("OK")
   Endif
 ENDIF


//////////////////enviar/////////////////////////
IF  c_CStat == "704"
//////////////////enviar/////////////////////////
xJust      :="Sem acesso a Internet" 
     
    BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
   *  SET SECTION "Identificacao"  ENTRY "dhCont"  TO dtoc(dt_server)+" "+hora_server ///contingencia para NFCe
     SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
   END INI
 
Destinotxt:=path+"\NFCE.TXT"

/////////////////criando///////////////////////////	
cRet       := MON_ENV("NFe.CriarNFe("+Destinotxt+","+""+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 
bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xchave      :=SUBSTR(variavel1,24,44)
vNFE        := substr(xchave, 26, 09)
cSerie      :=val(SUBSTR(cChave,23,3))

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
MY_WAIT( 2 ) 
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
ENDIF
****************************************************************************
***************************************************************************


//////////////////enviar/////////////////////////
IF  c_CStat == "217"
//////////////////enviar/////////////////////////
cTexto      :="C:\ACBrMonitorPLUS"+"\"+xchave+"-nfe.XML" 
***************************************************************
 cRet       := MON_ENV("NFe.EnviarNFe("+cTexto+",1,0,0,1)") 
************************************************************** 
MY_WAIT( 2 )
ERASE "C:\ACBrMonitorPLUS\sai.txt"
MY_WAIT( 2 )

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(xchave)+")")
MY_WAIT( 2 ) 
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
ENDIF
****************************************************************************
***************************************************************************
xSEQ_TEF := strzero(year(date() ),4)
nAno:=SUBSTR(xSEQ_TEF,3,2)
ccnpj:='84712611000152'
cJus :='Erro na sequencia de emissao'
nMod :="65"
nSer :=pserie
nIni :=ntrim(pnumero)
nFin :=ntrim(pnumero)


if  c_CStat='297'.OR. c_CStat="206" .OR. c_CStat="225" .OR. c_CStat='865'.or. c_CStat='704'.or. c_CStat='526'.or. c_CStat='778'.or. c_CStat='767'.or. c_CStat='537'.or. c_CStat='610'.or. c_CStat='869'.or. c_CStat='225'
cRet := MON_ENV("NFE.InutilizarNFe("+ccnpj+","+cJus+","+nAno+","+nMod+","+nSer+","+nIni+","+nFin+")")
MY_WAIT( 1 ) 



  cDestino:="C:\ACBrMonitorplus\sai.txt"	
     lRetStatus:=EsperaResposta(cDestino)
          if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread(cDestino))
           cEnvio_XML:=.f.
        else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "INUTILIZACAO"       ENTRY "CStat"
	   get cNProt          section  "INUTILIZACAO"       ENTRY "NProt"
	   get cXMotivo        section  "INUTILIZACAO"       ENTRY "XMotivo"
END INI
end
end

public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO:=c_cNProt
cXml:=""
c_XMotivo:=cXMotivo
*cas_addi(pnumero   +"   "+ xchave  +"   " +cXMotivo )
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+c_XMotivo+"', AUTORIZACAO='"+"INUTILIZADO"+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "
*cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+c_XMotivo+"' ,AUTORIZACAO='"+"INUTILIZADO"+"',nt_retorno='"+cXml+"' WHERE CbdNtfNumero = "+nIni+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+nSer+" "


 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro 381 PROPLEMA")
  else
   Endif 
ENDIF



***************************************************************************
*****************************************************************************
IF  c_CStat == "613" 
cNovaChave:=substr(cXMotivo,91,44)
//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+ALLTRIM(cNovaChave)+")")
MY_WAIT( 2 ) 

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
 cQuery := "UPDATE NFCE SET CHAVE='"+cNovaChave+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 Endif
xchave:= cNovaChave
ENDIF

			   
IF c_CStat == "100,101,150,301,302"
fxml:="C:\ACBrMonitorPLUS\"+xchave+"-nfe.xml"
ffxml    :=memoread(fxml)
cXml     :=Memoread(fxml)
 cQuery := "UPDATE NFCE SET AUTORIZACAO='"+c_cNProt+"' ,nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  MSGINFO("OK")
   Endif
 ENDIF
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
 
  oQuery:=oServer:Query( "SELECT CHAVE,nt_retorno,nfcedaruma,NOTATXT  FROM nfce WHERE CbdNtfNumero = "+AllTrim(pACode)+" and CbdNtfSerie ="+(paserie)+" Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
oRow:= oQuery:GetRow(1)

If Empty(oRow:FieldGet(3))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
    ///////////////////////////////////////////////////
MY_WAIT( 2 )
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)  
public cTXT         :=PATH+"\NOTA.XML"
public cXML_NOTA    :="C:\ACBrMonitorPLUS\"+alltrim(oRow:FieldGet(1))+"-nfe.xml"
  cXml        :=cTXT
  cRet := MON_ENV("NFe.ImprimirEventoPDF("+cXml+","+cXML_NOTA+")")
   MY_WAIT( 2  ) 
  cRet := MON_ENV("NFe.ImprimirEvento("+cXml+","+cXML_NOTA+")")
 
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
HANDLE :=  FCREATE (xchave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
fxml       :=PATH+"\"+xchave+"-nfe.XML"
cREt       := MON_ENV("NFE.ImprimirDanfe("+fxml+")")


/*
If Empty(oRow:FieldGet(2))
XML:=(xchave)
fxml:="C:\ACBrMonitorPLUS\"+xml+"-nfe.XML"
cREt       := MON_ENV("NFE.ImprimirDanfe("+fxml+")")

ELSE
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"
*cRet       := MON_ENV("NFE.ImprimirDanfe("+cTXT+",1,1,0,1)")
cREt       := MON_ENV("NFE.ImprimirDanfe("+cTXT+")")
ENDIF
*/

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
cRet := MON_ENV("NFE.InutilizarNFe("+ccnpj+","+cJus+","+nAno+","+nMod+","+nSer+","+nIni+","+nFin+")")

MY_WAIT( 1 ) 
cFileDanfe := "C:\ACBrMonitorPLUS\SAI.TXT"
xcml:=memoread(cFileDanfe)
variavel1 :=SUBSTR(xcml,0,4)
variavel :=SUBSTR(xcml,0,100)


  cDestino:="C:\ACBrMonitorplus\sai.txt"	
     lRetStatus:=EsperaResposta(cDestino)
          if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread(cDestino))
           cEnvio_XML:=.f.
        else
   BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "INUTILIZACAO"       ENTRY "CStat"
	   get cChNFe          section  "INUTILIZACAO"       ENTRY "ChNFe"
	   get cNProt          section  "INUTILIZACAO"       ENTRY "NProt"
	   get cXMotivo        section  "INUTILIZACAO"       ENTRY "XMotivo"
END INI
end
end

public  c_CStat   :=(cCStat)
public c_cChNFe   :=cChNFe
public c_cNProt   :=cNProt

AUTO:=c_cNProt
c_XMotivo:=cXMotivo
*msginfo(c_CStat)

if c_CStat="102"
msginfo('Inutilizacao de numero homologado')
Reconectar_A() 
AXml:=""
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+c_XMotivo+"' ,AUTORIZACAO='"+"INUTILIZADO"+"',nt_retorno='"+AXml+"' WHERE CbdNtfNumero = "+nIni+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+nSer+" "

 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
  *************repor quantidade estoque
 ///////////////////pega a qtd nos itens 
 oQuery :=oServer:Query( "SELECT CbdcProd,CbdqCOM FROM ITEMNFCE WHERE CbdNtfNumero = "+nIni+" and CbdNtfSerie = "+nSer+"  Order By CbdNtfNumero" )
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
 else
* MsgInfo("ok ") 
Endif		
oQuery:Skip(1)
Next
oQuery:Destroy() 

  
  
  
endif
unitilizacao.release 
janelanfe.cSearch.value:=nIni
janelanfe.cSearch.SetFocus

Return NIL


*--------------------------------------------------------------*
STATIC Function reenviar()
*--------------------------------------------------------------*
Local pachave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 7))))
Local pnumero:= (val((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local pserie := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
Local pTEXTE := (AllTrim((GetColValue( "Grid_notas", "janelanfe", 11 ))))
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
LOCAL ArquivoX :=""

dt_server  :=date()
hora_server:=time()


oQuery        :=oServer:Query( "SELECT CHAVE,nt_retorno,NOTATXT FROM NFCE WHERE CbdNtfNumero = "+NTRIM(pnumero)+" AND  cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+"  Order By CbdNtfNumero" )
oRow          := oQuery:GetRow(1)
xchave        :=ALLTRIM(oRow:FieldGet(1))
  
HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)  

  BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '1' ///contingencia para NFCe
   *  SET SECTION "Identificacao"  ENTRY "EMISSAO"  TO dtoc(dt_server)+" "+hora_server ///contingencia para NFCe
   END INI

 MY_WAIT( 2 ) 
 
 
PUBLIC Destinotxt :=PATH+"\NFCE.TXT"


bRetornaXML:=""
/////////////////criando///////////////////////////	
cRet       := MON_ENV("NFe.CriarNFe("+Destinotxt+","+bRetornaXML+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 
bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xchavenfce  :=SUBSTR(variavel1,24,44)
vNFE        := substr(xchavenfce, 26, 09)
XARQUIVO    :=SUBSTR(variavel1,4,90)
XARQUIVO    :=ALLTRIM(XARQUIVO)
*MSGINFO(XARQUIVO)
public xx_xchavenfce:=xchavenfce


MY_WAIT( 1 ) 


fxml:="C:\ACBrMonitorPLUS\"+xchavenfce+"-nfe.xml"
ffxml    :=memoread(fxml)



*NFe_CON(xchave)

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+xchavenfce+")")
///////////////////////////////////////////////////
MY_WAIT( 2 ) 

       lRetStatus:=EsperaResposta(cDestino)
          if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread(cDestino))
           cEnvio_XML:=.f.
      
       else
       BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI
end
end

public  c_CStat   :=cCStat
public c_cNProt   :=cNProt
AUTO              :=c_cNProt
	
if c_CStat="450"
 XMotivo=cXMotivo
*MsgInfo(XMotivo)
*return(.f.)
endif



if c_CStat="217"
 XMotivo=cXMotivo
*MsgInfo(XMotivo)
*return(.f.)
endif


if c_CStat="100"
*MsgInfo("ok tem")
cQuery := "UPDATE NFCE SET  CHAVE='"+xchavenfce+"',AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
else
public nnfe:="NFE"+NTRIM(pnumero)
 
//////[enviar]///////////
		       IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENT.TXT")
			      Return
               ENDIF 
					  
              FWRITE(nHandle,"NFE.CriarEnviarNFe("+Destinotxt+","+nLote+",0,0")
              FCLOSE(nHandle) 

    lRetStatus:=EsperaResposta(cDestino)
          if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread(cDestino))
           cEnvio_XML:=.f.
       else
       BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
      GET c_DhRecbto       SECTION  "ENVIO"         ENTRY "DhRecbto"   // DADA E HORA 
      GET c_ChNFe          SECTION  alltrim(nnfe)   ENTRY "ChNFe"      // chave nfe  
	   GET R_DigVal         SECTION  alltrim(nnfe)   ENTRY "DigVal"      
	   GET R_DhRecbto       SECTION  nnfe            ENTRY "DhRecbto"       
      GET c_NProt          SECTION  nnfe            ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
      GET ArquivoX         SECTION  nnfe            ENTRY "Arquivo"      // PROTOCOLO DE AUTORIZACAO 
 END INI
 end
end

cQuery := "UPDATE NFCE SET nt_retorno= '"+(AllTrim(ffxml))+"',CHAVE='"+xchavenfce+"',AUTORIZACAO='"+c_NProt+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
*GRAVA_nfCe1(nnfe,mCbdtpEmis,c_ChNFe,c_NProt)

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

  
  

  oQuery := oServer:Query( "Select CbdNtfNumero,CbdNtfSerie,CbdxNome_dest,CbdCNPJ_dest,CbddEmi,HORAS,cbdVNF,Chave,autorizacao,nt_retorno,Cbdcheveevento,NOTATXT,RETORNO_EVENTO From NFCE WHERE CbdNtfNumero >= "+vnumero+" and CbdNtfNumero <= "+vnumero1+" and CbdNtfSerie="+serie_i+" Order By CbdNtfNumero" )

 
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
*  ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12)} TO Grid_notas Of janelanfe
   ADD ITEM { str(oRow:fieldGet(1),10),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),DTOC(oRow:fieldGet(5)),oRow:fieldGet(6),Str(oRow:fieldGet(7),10,2),oRow:fieldGet(8),oRow:fieldGet(9),oRow:fieldGet(10),oRow:fieldGet(11),oRow:fieldGet(12),oRow:fieldGet(13)} TO Grid_notas Of janelanfe

 
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

