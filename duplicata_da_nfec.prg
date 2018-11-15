// Harbour MiniGUI                 
// (c)2011 -José juca 
// Modulo : Emissor de Nota Fiscal
// 14/12/2014 12:12:12
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
Function duplcas_do_nfe()
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
*local pacode   :=ntrim (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
*local paserie  :=      (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))


Private nTipo
publ path :=DiskName()+":\"+CurDir()  
PUBL printpdf:=GetDefaultPrinter()    //  Free PrimoPdf como virtual printer para criar arquivos PDF    www.primopdf.com  
PUBL printdpx:=GetDefaultPrinter() 
PUBL printmtx:=GetDefaultPrinter() 
PUBL printfax:=GetDefaultPrinter() 
PUBL printLaser:=GetDefaultPrinter() 
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
 
Reconectar_A()
	  
DEFINE WINDOW NFe;
       at 000,000;
       WIDTH 600 ;
       HEIGHT 450;
       TITLE 'NFe' ICON "ICONE01";
       MODAL;
       NOSIZE;
	   ON INIT {||NFE.txt_DAV.setfocus}
	   
	   
     ON KEY ESCAPE OF NFe ACTION { ||NFe.RELEASE }
 
 
  DEFINE STATUSBAR of NFe	FONT "MS Sans Serif" SIZE 10
    STATUSITEM "Conectado no IP: "+C_IPSERVIDOR+" "+basesql WIDTH 150 	
          DATE
          CLOCK
          KEYBOARD
	   STATUSITEM ""+AllTrim( NetName() ) WIDTH 150 
	  END STATUSBAR
	

	
		
 @ 05,010  LABEL IMPORTA ;
   WIDTH 140 ;
   HEIGHT 020 ;
   VALUE "Nº DOC."  ;
   FONT "MS Sans Serif" SIZE 8.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 } BOLD 

   
 @ 05,80 textBTN txt_DAV;
		           of nfe;
		           width 80;
                   HEIGHT 20;
                   value '';
				   font 'verdana';
                   size 10;
                   FONTCOLOR { 255, 000, 000 };
                   BACKCOLOR { 255, 255, 255 };   
                   maxlength 40;
		           rightalign
				   
                  * ON enter {||PESQ_PVENDA(),peganfe()}


    DEFINE LABEL Lbl_Serie
            ROW   05
            COL    180
            WIDTH  60
            HEIGHT 20
            VALUE "Série"
            FONTSIZE 09
            FONTNAME "Arial"
     END LABEL  

     DEFINE TEXTBOX Txt_SERIE
            ROW   05
            COL   220
            WIDTH  15
            HEIGHT 20
            VALUE  ""
            MAXLENGTH 3 	
            UPPERCASE  .T.
	        ON GOTFOCUS This.BackColor:=clrBack 
   	        ON LOSTFOCUS This.BackColor:=clrNormal  
            FONTSIZE 8
            FONTNAME "Arial"
     END TEXTBOX 
	 
	
	

 @ 05, 300  LABEL oSay223 ;
   WIDTH 120 ;
   HEIGHT 20;
   VALUE "F8-Procura Clientes"  ;
   FONT 'Times New Roman'SIZE 10.00 ;
   BACKCOLOR {242,242,242}
   
   
@  05,420 textBTN textBTN_cliente;
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

				
	
			    @ 45,200 TEXTBOX  Txt_NOMECLI ;
				value "Nome";
				WIDTH 440 ;
				HEIGHT 28;
				BOLD BACKCOLOR {191,225,255}
				
 DEFINE BUTTON Button_422
           ROW    350
           COL    450
           WIDTH  120
           HEIGHT 28
           CAPTION "Imprimir"
           Action  dupl_nfec()         
     END BUTTON  
		
		 DEFINE BUTTON Button_4222
           ROW    350
           COL    10
           WIDTH  120
           HEIGHT 28
           CAPTION "Sair"
           Action NFe.RELEASE()         
     END BUTTON  
		
		
				
				

    end WINDOW
   nfe.Center 
   nfe.Activate
return 
************************

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

  
*************************


 
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
If !Empty(oRow:fieldGet(2)) 
     else
     MsgStop("CÓDIGO NÃO ENCONTRADO","ATENÇÃO")
 Return .f.

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
 
If !Empty(fRow:fieldGet(6)) 
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc ,"@!")
 else
     MsgStop("CÓDIGO NÃO ENCONTRADO","ATENÇÃO")
	 NFE.textBTN_cliente.setfocus
 Return .f.
endif
			  
fQuery:Destroy()	
Return Nil           


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
 
 fQuery:= "Select  tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + (pCode)
 
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
   
If !Empty(fRow:fieldGet(6)) 
 nfe.Txt_NOMECLI.value      := xxrazaosoc
 MODIFY CONTROL Txt_NOMECLI   OF NFe  Value  ''+TransForm( xxrazaosoc ,"@!")
 else
     MsgStop("CÓDIGO NÃO ENCONTRADO","ATENÇÃO")
	 NFE.textBTN_cliente.setfocus
 Return .f.
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
  
*****************************

 	  

function dupl_nfec(cORCAMENTO)
//--------------------------------------
local nLinha   := 0
local nPagina  := 1
LOCAL C_CODIGO :=NFE.textBTN_cliente.VALUE
local pCode    :=Alltrim(Str(NFE.textBTN_cliente.value))
local pacode   :=nfe.txt_DAV.value
local paserie  :=nfe.Txt_SERIE.value
Local copias  := 1 
Local oRow
Local i
local NUMERO:="11" 
local c_encontro

PAG:=0
LIN:=0
MTOTAL       :=0
nQuantItens  = 0
nTOTAL       :=0
nTotORCAMENTO:=0
PUBLIC cNombre
cNumero:=RTRIM(STRTRAN(NUMERO,"/","_",1,len(NUMERO)))
cNombre:="Relatorios"+"_"+cNumero
*-------------------------------------------------*

 
         oprint:=tprint('PDFPRINT')
         oprint:init()
         oprint:setunits("MM",0) /// unidad de medida , interlineado
         oprint:selprinter(.F.,.t.,.F.,,,)
     
         if oprint:lprerror
            oprint:release()
            return nil
         endif

         oprint:begindoc(cNombre)
         oprint:setpreviewsize(1)  /// tamaño del preview  1 menor,2 mas grande ,3 mas...
         oprint:beginpage()
         page = 1
  
        oprint:printimage(00,05,30,180,"CABECARIO.jpg")
        oprint:printroundrectangle(27,1,27,200,,0.2)
		
		oprint:printdata(30,175," Pag. nº ","Courier New",10,.T.,,"R",)     
        oprint:printdata(30,182,STR(page),"Courier New",10,.F.,,"R",)  
		 
nChave:=pCode
 fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + (nChave)
   fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
   NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

 fRow         :=fQuery:GetRow(1)
 xCL_PESSOA    :=fRow:fieldGet(1)
 xCL_CGC      :=fRow:fieldGet(2)
 xRGIE        :=fRow:fieldGet(3)
 xxcpf        :=fRow:fieldGet(4)
 xxrg         :=fRow:fieldGet(5)
 xnome        :=fRow:fieldGet(6)
 xende        :=fRow:fieldGet(7)
 xxnumero     :=fRow:fieldGet(8)
 xcida        :=fRow:fieldGet(9)
 xuf          :=fRow:fieldGet(10)
 xxcod_ibge   :=fRow:fieldGet(11)
 xxcodigo     :=fRow:fieldGet(12)
 xxbairro     :=fRow:fieldGet(13)
 xxemail      :=fRow:fieldGet(14)
 xxcep        :=fRow:fieldGet(15)
fQuery:Destroy()	
		
	xcod_cli:=xxcodigo	
C_CODIGO    :=xxcodigo	

DQuery := oServer:Query( "Select CbdNtfNumero,CbdvProd_ttlnfe,CbdvNF,CbddEmi,CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe From NFCE WHERE CbdNtfNumero = "+pacode+" and CbdNtfSerie ="+paserie+"" )
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
  xDESC2          :=dRow:fieldGet(5)
  xdesc1          :=dRow:fieldGet(6)
  xDESCONTO       :=dRow:fieldGet(7) 
  
   
   
   
  	     oprint:printdata(30,001, 'Emissão  :'+dtoc(date())+' : '+time() ,"Courier New",10,.T.,,"R",)
		 oprint:printdata(30,100,'Nfc_e'             ,"Courier New",10,.T.,,"R",)
         oprint:printdata(30,150, pacode            ,"Courier New",10,.T.,,"R",)
	     oprint:printdata(35,001, "Cliente..:"            ,"Courier New",10,.T.,,"R",)
         oprint:printdata(35,025, Substr(xnome,1,60) +TRAN(C_CODIGO,"99999")  ,"Courier New",10,.T.,,"R",) 
         oprint:printdata(40,001, "Endereco.:"                  ,"Courier New",10,.T.,,"R",)  
         oprint:printdata(40,025, TRAN(xende,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,001, "Cidade...:"                  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,025, TRAN(xcida,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,150, "Est.:"                      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,170, tran(xuf,"!!")      ,"Courier New",10,.T.,,"R",)
  IF xCL_PESSOA='J'                     
       oprint:printdata(50,001,'Cnpj.....:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
   ENDI
   IF xCL_PESSOA='I'                         
       oprint:printdata(50,001,'Cnpj.....:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
ENDI
 IF xCL_PESSOA='F'                       
           oprint:printdata(50,001,'Cpf......:'                    ,"Courier New",10,.T.,,"R",)
           oprint:printdata(50,025, Trans(xxcpf,'@!')     +  '  RG...: '+Trans(xxrg,'@!')  ,"Courier New",10,.T.,,"R",)
endif
IF xCL_PESSOA='P'                      
       oprint:printdata(50,001,'Cpf......:'                      ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xxcpf,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
endif
	
	oprint:printroundrectangle(52,1,58,200,,0.5)
   	Oprint:printroundrectangle(58,1,150,200,,0.5)   
    Oprint:printroundrectangle(52,17,150,17,,0.1)   
	Oprint:printroundrectangle(52,44,150,44,,0.1) 
	Oprint:printroundrectangle(52,111,150,111,,0.1) 
	Oprint:printroundrectangle(52,133,150,133,,0.1) 
	Oprint:printroundrectangle(52,150,150,150,,0.1) 
    Oprint:printroundrectangle(52,173,150,173,,0.1)      
	
/////////////////////////////////////////////////////////////////////////////////	
	
   oprint:printdata(56,02 ,  'Itens'  ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,18 ,  'Código',"Courier New",10,.T.,,"R",)
   oprint:printdata(56,47 ,  'Descrição Do Produto'   ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,120,  'Unidade' ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,142,  'Qtd'  ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,160,  "Valor r$" ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,185,  "Sub.Total","Courier New",10,.T.,,"R",)
  
f=62

Xtotal=0
nTotPEDIDO:=0
oQuery := oServer:Query( "Select CbdcProd ,CbdcEAN,CbdxProd,CbdnItem,CbdvProd,CbdNtfNumero,CbdNCM,CbdqCOM,CbdvUnCom,CbdUCom,CbdvDesc,cbdvoutro_item,CbdvAliq,CbdCFOP From itemNFCE WHERE CbdNtfNumero ="+pacode+" and CbdNtfSerie= "+paserie+" Order By CbdxProd" )
For i := 1 To oQuery:LastRec()
eRow         := oQuery:GetRow(i)
xproduto     :=eRow:fieldGet(2)
xdescricao   :=eRow:fieldGet(3)
xitens       :=eRow:fieldGet(4)
xsubtotal    :=eRow:fieldGet(5)
xnseq_orc    :=eRow:fieldGet(6)
xncm         :=eRow:fieldGet(7)
xQuant       :=eRow:fieldGet(8)     
xvalor       :=eRow:fieldGet(9)
xunid        :=eRow:fieldGet(10)
xCbdvDesc    :=eRow:fieldGet(11)
xCancelado   :=eRow:fieldGet(12)
xCbdvAliq    :=eRow:fieldGet(13)

		  
		  
     		  nQuantItens++
                 oprint:printdata(F,004, Trans(nQuantItens,'999') ,"Courier New",10,.T.,,"R",)
                 oprint:printdata(F,018, xPRODUTO ,"Courier New",10,.T.,,"R",)	
                 oprint:printdata(F,047, Substr(xDESCRICAO ,1,45),"Courier New",8,.T.,,"R",)	
				 oprint:printdata(F,120, Trans(xUNID,'@!') ,"Courier New",10,.T.,,"R",)
     			 oprint:printdata(F,140, Trans(xQuant,'9,999.99'),"Courier New",10,.T.,,"R",) 
                 oprint:printdata(F,163, Trans(xValor,'@E 99,999.99') ,"Courier New",10,.T.,,"R",)
                 oprint:printdata(F,191, Trans(xSubTotal,'@E 99,999.99'),"Courier New",10,.T.,,"R",)

				 mTOTAL        :=MTOTAL+xValor*xQuant
				 NTOTAL        :=NTOTAL+xValor*xQuant
				 nTotPEDIDO +=(xQuant *xValor )
				 
F=F+4 
oQuery:Skip(1)

// IF F > (11+200)   
 IF nQuantItens=25  

 oprint:endpage()
            page = page+1
            oprint:beginpage()
		
        oprint:printimage(00,05,30,180,"CABECARIO.jpg")
        oprint:printroundrectangle(27,1,27,200,,0.2)
	     oprint:printdata(30,001, 'Emissão  :'+dtoc(date())+' : '+time() ,"Courier New",10,.T.,,"R",)
		 oprint:printdata(30,100,'Nfc_e '  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(30,150, pacode            ,"Courier New",10,.T.,,"R",)
	     oprint:printdata(35,001, "Cliente..:"            ,"Courier New",10,.T.,,"R",)
         oprint:printdata(35,025, Substr(xnome,1,40) +TRAN(xcod_cli,"99999")  ,"Courier New",10,.T.,,"R",) 
      *  oprint:printdata(35,020, TRAN(xcod_cli,"99999")  ,"Courier New",10,.T.,,"R",)              
         oprint:printdata(40,001, "Endereco.:"                  ,"Courier New",10,.T.,,"R",)  
         oprint:printdata(40,025, TRAN(xende,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,001, "Cidade...:"                  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,025, TRAN(xcida,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,150, "Est.:"                      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,170, tran(xuf,"!!")      ,"Courier New",10,.T.,,"R",)
  IF xCL_PESSOA='J'                     
       oprint:printdata(50,001,'Cnpj.....:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
   ENDI
   IF xCL_PESSOA='I'                         
       oprint:printdata(50,001,'Cnpj.....:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
ENDI
 IF xCL_PESSOA='F'                       
           oprint:printdata(50,001,'Cpf......:'                    ,"Courier New",10,.T.,,"R",)
           oprint:printdata(50,025, Trans(xxcpf,'@!')     +  '  RG...: '+Trans(xxrg,'@!')  ,"Courier New",10,.T.,,"R",)
endif
IF xCL_PESSOA='P'                      
       oprint:printdata(50,001,'Cpf......:'                      ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xxcpf,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
endif
		
		
	oprint:printdata(30,175," Pag. nº ","Courier New",10,.T.,,"R",)     
    oprint:printdata(30,182,STR(page),"Courier New",10,.F.,,"R",)  
	oprint:printroundrectangle(52,1,58,200,,0.5)
   	Oprint:printroundrectangle(58,1,150,200,,0.5)   
    Oprint:printroundrectangle(52,17,150,17,,0.1)   
	Oprint:printroundrectangle(52,44,150,44,,0.1) 
	Oprint:printroundrectangle(52,111,150,111,,0.1) 
	Oprint:printroundrectangle(52,133,150,133,,0.1) 
	Oprint:printroundrectangle(52,150,150,150,,0.1) 
    Oprint:printroundrectangle(52,173,150,173,,0.1)      
	
/////////////////////////////////////////////////////////////////////////////////	
	
   oprint:printdata(56,02 ,  'Itens'  ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,18 ,  'Código',"Courier New",10,.T.,,"R",)
   oprint:printdata(56,47 ,  'Descrição Do Produto'   ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,120,  'Unidade' ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,142,  'Qtd'  ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,160,  "Valor r$" ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,185,  "Sub.Total","Courier New",10,.T.,,"R",)
  F = 62
 ENDIF
NEXT

oQuery:Destroy()

//oprint:printdata( 260,050,"Total R$","Courier New",18,.T.,,"R",)
aEstados := { 'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO' }
//aExtenso := Extenso( nValoDupl, 115, 03 )
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

oprint:printdata(162,001,'ITENS'+Trans(nQuantItens,'@E 9999'),"Courier New",9,.T.,,"R",)
oprint:printdata(162,040, "Total.:" +TRAN(nTotPEDIDO,"@E 999,999.99") ,"Courier New",9,.T.,,"R",)
oprint:printdata(162,100, "Desconto.:" +TRAN(xDESCONTO ,"@E 999,999.99"),"Courier New",9,.T.,,"R",)
oprint:printdata(162,160, "T O T A L  R$" +TRAN(nTotPEDIDO-xDESCONTO ,"@E 999,999.99"),"Courier New",9,.T.,,"R",)

oprint:printroundrectangle(155,1,260,200,,0.50)
oprint:printdata(170,005, cRegiFant ,"Courier New",15,.T.,,"R",)
oprint:printdata(175,005, cRegiNome ,"Courier New",11,.T.,,"R",)
oprint:printdata(180,005, cRegiEnde + ", " + cRegiNume + " - " + cRegiBair + " - Fone:" + cRegiFone ,"Courier New",7,.T.,,"R",)
oprint:printdata(185,005, "Email " + cemail,"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(155,80,180,80,,0.20)
oprint:printdata(170,085, "CNPJ: " + cRegiCnpj ,"Courier New",10,.T.,,"R",)
oprint:printdata(175,085, "Inscr. Estadual: " + cRegiIEst ,"Courier New",9,.T.,,"R",)
oprint:printdata(180,085, "Municipio de " + cRegiCida ,"Courier New",10,.T.,,"R",)
oprint:printdata(185,085, "Cep.." + cRegiCEP  ,"Courier New",10,.T.,,"R",)

oprint:printroundrectangle(155,140,180,140,,0.20)
oprint:printdata(170,155, "DATA DE EMISSÃO: ","Courier New",10,.T.,,"R",)
oprint:printdata(175,155, DTOC( DATE()) ,"Courier New",10,.T.,,"R",)
oprint:printdata(185,155, "DUPLICATA" ,"Courier New",15,.T.,,"R",)
oprint:printroundrectangle(180,1,180,200,,0.20)
oprint:printroundrectangle(187,001,187,110,,0.10)
oprint:printdata(195,002, 'FATURA Nº' ,"Courier New",10,.T.,,"R",)
cNumeNota:=pacode 
oprint:printdata(203,005, cNumeNota ,"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(180,30,200,30,,0.10)
nValoDupl:=nTotPEDIDO-xdesconto

oprint:printdata(195,036, 'VALOR R$',"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(180,55,200,55,,0.10)
oprint:printdata(203,33, TRANSFORM( nValoDupl, '@E 999,999.99' ) ,"Courier New",10,.T.,,"R",)

oprint:printdata(195,059, 'DUPLICATA Nº' ,"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(180,80,200,80,,0.10)
oprint:printdata(203,065, cNumeNota ,"Courier New",10,.T.,,"R",)

dDataVenc:=DATE()+20
oprint:printdata(195,90, 'VENCIMENTO',"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(180,110,200,110,,0.10)
oprint:printdata(205,87, DTOC( dDataVenc ) ,"Courier New",13,.T.,,"R",)
oprint:printdata(195,120,'PARA USO DA INSTITUIÇÃO FINANCEIRA'  ,"Courier New",11,.T.,,"R",)

oprint:printroundrectangle(200,001,200,110,,0.30)
oprint:printroundrectangle(200,030,210,200,,0.30)
oprint:printroundrectangle(210,030,225,200,,0.30)
//////////////////////////////////////////////////////
         oprint:printroundrectangle(225,030,235,200,,0.30)
		 oprint:printdata(225,032, "Nome......:"  ,"Courier New",10,.T.,,"R",)     
         oprint:printdata(225,055, Substr(xnome,1,40)   ,"Courier New",10,.T.,,"R",)  
         oprint:printdata(228,032, "Endereco..:"                  ,"Courier New",10,.T.,,"R",)  
         oprint:printdata(228,055, TRAN(xende,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,032, "Cidade....:"                  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,055, TRAN(xcida,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,100, "Praça de Pagamento VILHENA-RO"  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,192, "Est.:"                      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,203, tran(xuf,"!!")      ,"Courier New",10,.T.,,"R",)
  IF xCL_PESSOA='J'                     
       oprint:printdata(236,032,'Cnpj......:'                     ,"Courier New",10,.T.,,"R",)
       oprint:printdata(236,055, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
   ENDI
   IF xCL_PESSOA='I'                         
       oprint:printdata(237,032,'Cnpj......:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(237,055, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
ENDI
 IF xCL_PESSOA='F'                       
           oprint:printdata(236,032,'Cpf.......:'                    ,"Courier New",10,.T.,,"R",)
           oprint:printdata(236,055, Trans(xxcpf,'@!')     +  '  RG...: '+Trans(xxrg,'@!')  ,"Courier New",10,.T.,,"R",)
    endif
IF xCL_PESSOA='P'                      
       oprint:printdata(236,032,'Cpf.......:'                      ,"Courier New",10,.T.,,"R",)
       oprint:printdata(236,055, Trans(xxcpf,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
	   endif
** 	oprint:printroundrectangle(65,1,80,200,,0.5)
  /////////////////////////////////////////////////

oprint:printroundrectangle(225,030,235,030,,0.30)
oprint:printroundrectangle(235,001,235,030,,0.30)
oprint:printroundrectangle(225,070,235,030,,0.30)
oprint:printdata(245,032, 'Valor por extenso',"Courier New",10,.T.,,"R",)
oprint:printdata(245,075, Extenso(nValoDupl),"Courier New",9,.T.,,"R",)

oprint:printdata(253,032, 'Reconhecemos a exatidão desta Duplicata de Venda Mercantil, na importância acima que pagaremos a',"Courier New",8,.T.,,"R",)
oprint:printdata(257,032, cRegiNome + ', ou a sua ordem, na praça e vencimento indicados.' ,"Courier New",8,.T.,,"R",)
oprint:printdata(269,032, 'Em ____/____/_____' ,"Courier New",10,.T.,,"R",)
oprint:printdata(269,100, '_________________________' ,"Courier New",10,.T.,,"R",)

 
         oprint:endpage()
         oprint:enddoc()
         oprint:RELEASE()
		 NFe.RELEASE
Return Nil

/////////////////////////////////////////////////////////////////////

