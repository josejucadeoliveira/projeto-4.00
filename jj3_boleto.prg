#define K_ALT_T            iar     276   /*   Alt-T                         */
#include 'i_textbtn.ch'
#define clrNormal   {255,255,255}
#define clrBack     {255,255,200}
static lGridFreeze := .T.
#include "resource.h"
#include "Minigui.ch"
#include "winprint.ch"
#include <miniprint.ch>
#include <common.ch>

//*********************************************
function  jj3_boleto()
//*********************************************

Static aBar:={ "00110","10001","01001","11000","00101","10100","01100","00011","10010","01010"}
Static B_Inicio:="0000"
Static B_Fim:="100"
//Static oForm

REQUEST HB_LANG_PT    

REQUEST DBFCDX
REQUEST DBFFPT 
RDDSETDEFAULT("DBFCDX")

cNumero:=""


 
abreboleto()
publ path :=DiskName()+":\"+CurDir() 
PUBL printpdf:=GetDefaultPrinter()    //  Free PrimoPdf como virtual printer para criar arquivos PDF    www.primopdf.com  
PUBL printdpx:=GetDefaultPrinter() 
PUBL printmtx:=GetDefaultPrinter() 
PUBL printfax:=GetDefaultPrinter() 
PUBL printLaser:=GetDefaultPrinter() 
*PUBL printX:=GetDefaultPrinter()
PUBL printLaser:="PrimoPDF"

PUBL printPV:=.t.
PUBL cInstr		:= ''
cXcrm:=.T.  
cXcrm_a:=.T.  
cXcrm_x:=.T.  

PUBL root:= GetStartUpFolder()+'\' 
PUBL iniFile_c:=.t. 

PUBL dirstart:=root 
PUBL dirdbf:=root 
PUBL dircrm:=root 
PUBL dirpdf:=root
PUBL dirhtml:=root
PUBL dirRemessa:= root
nNumOS:=1



 Set Exclusive OFF
 Set Delete ON
 Set Date brit
 Set Century ON
 Set Epoch TO 1920
 set navigation extended
cNumero:=""
Reconectar_A() 


/*
oQuery := oServer:Query( "Select MAX(SEQ_BOL)FROM CONTA SEQ_BOL")
oRow  := oQuery:GetRow(1)
CNumero:=((oRow:fieldGet(1)))
cNumero:=CNumero+1 
 If oQuery:NetErr()
    MsGInfo("ERROR   " + oServer:Error() )
    Return Nil
  Endif
 
*/
//cNumero := Random(999999) 

cNumero := substr(alltrim(str(HB_RANDOM(123456,999999))),1,6)
cNumero        := val(cNumero)


 c_banco                  :="756"
 c_moeda                  := "9"
 c_cod_cedente            := "4260"
 c_digito_cedente         := "0"
 c_cnpj                   := "84712611000152"
 c_valor                  := 0
 c_especie                := "OU"
 c_aceite                 := "N"
 c_vencimento             := ctod(" / /  ")
 c_agencia                := "3325"
 c_nossonumero            := Numero
 c_cpf                    := ""
 c_cedente                := "MEDIAL COMERCIO DISTRIBUIDOR LTDA"
 c_sacado                 := ""
 c_cidade                 := ""
 c_bairro                 := ""
 c_endereco               := ""
 c_documento              := ""
 c_estado                 := ""
 c_CEP                    := ""

 
// definicoes das colunas de labels e textbox 
ww= 700            // total de colunas do box  
wh= 540              // total de linhas do box
vwh=1000   //  virtual height
we=5                            
we2=we*2
we3=we*3
we4=we*4
we5=we*5
we6=we*6
 

tbc=we2
tbl=40+we2
tbw=ww-we5
tbh=wh-80-we6          //20 titulo 40 toolbar 20 statusbar  2 espacos 
vtbh=vwh-80-we6          //20 titulo 40 toolbar 20 statusbar  2 espacos 

tbu=tbw-we6

L1=we3 
L2=(ww/2)+we6 
L3=(ww/3)+we6 
L4=(ww/3*2)+we6   

Lu=tbc-we4 
Lb=tbl-30                    // linha dos botoes inferiores                 

t1=L1+70 
t2=L2+70 
t3=L3+70 
t4=L4+70
tt=tbc-L1-L1  

novoboleto:=.F.
editaboleto:=.F.    
numeroboleto:=0
lprintPdf:=.f. 
lprintPreview:=.f.
lprintDefault:=.F.
c_banco:="756"

 
  DEFINE WINDOW oform_boleto ;
  AT 000, 00;
  width Ajanela; 
  height Ljanela-40;
  TITLE "Boleto TESTE SICOOB - Homologa��o";
  MODAL;
  NOSIZE
   
   
 ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela


	  
@ 010, 05 LABEL oSay5 Value "Didigte N� Cupom(COO)";
      WIDTH 0200 HEIGHT 0013 ;
      FONT "MS Sans Serif" SIZE 08 
	  
 @ 40,05 textBTN txt_DAV;
	           width 130;
                   HEIGHT 20;
                   value "";
	                font 'verdana';
                   size 12;
                   FONTCOLOR { 255, 000, 000 };
                   BACKCOLOR { 255, 255, 255 };   
                   maxlength 40;
		           rightalign;
		           ON enter {||PESQ_PVENDA() ,mostra_linha2(),oform_boleto.txt_DAV.SETFOCUS}

				  
  
 @ 010, 150  LABEL IMPORTAp ;
   WIDTH 300 ;
   HEIGHT 024 ;
   VALUE "F8 Cliente"  ;
   FONT "MS Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 } BOLD 


@ 040,150 textBTN textBTN_cliente;
	      numeric;
	      width 70;
	      value 200;
     	   FONT 'Times New Roman' ;
           SIZE 12 FONTCOLOR; 
           BLUE BOLD BACKCOLOR {255,255,0};        
          tooltip 'Digite o c�digo ou clique na LUPA para pesquisar';
	      picture cPathImagem+'lupa.bmp';
	      maxlength 4;
	      rightalign;
	      Action {||GetCode_cli(,boleto_salva(),mostra_linha2(),oform_boleto.textBTN_cliente.setfocus)};
	      ON enter {||iif(!Empty(oform_boleto.textBTN_cliente.Value),pesq_cli(),oform_boleto.textBTN_cliente.setfocus)};
          on gotfocus (CHANGETEXTBTNSTATE(GetControlHandle('textBTN_cliente','oform_boleto'),1),(oform_boleto.textBTN_cliente.backcolor := {255,255,196}))

	      
		  
  ON KEY F8 ACTION { || GetCode_cli(),boleto_salva(),boleto_salva(),mostra_linha2()} 
  
//////////////////////////////////////////////////////////////
		  
   @ 010, 250 LABEL banco Value "Banco";
      WIDTH 0046 HEIGHT 0013 ;
      FONT "MS Sans Serif" SIZE 0008 

   @ 040, 250   TEXTBOX txt_banco;
      WIDTH  40 HEIGHT 0020 ;
      FONT "Ms Sans Serif" SIZE 008; 
      VALUE  "756"	  ;
      READONLY
///////////////////////////////////////////////
 @ 010, 400 LABEL oSay2 Value "Ag�ncia";
      WIDTH 0046 HEIGHT 0013 ;
      FONT "MS Sans Serif" SIZE 0008 
    
   @ 040, 400   TEXTBOX txt_agencia;
      WIDTH  40 HEIGHT 0020 ;
      FONT "Ms Sans Serif" SIZE 008 ;
      Value "3325" ;
      READONLY
////////////////////////

   @ 010, 560 LABEL oSay4 Value "C�d.cedente";
      WIDTH 0066 HEIGHT 0013 ;
      FONT "MS Sans Serif" SIZE 0008 

   @ 0040, 560  TEXTBOX txt_cod_cedente;
       WIDTH  70 HEIGHT 0020 ;
       FONT "Ms Sans Serif" SIZE 008 ;
       value  "4260" ;
       READONLY
      		
   ///////////////////////////////////////////////////////////////
   @ 80,L1+460  LABEL lvcto ;
	VALUE 'Vencimento';
	RIGHTALIGN;
	WIDTH 80;
	TRANSPARENT
	
	@ 80,t1+480  DATEPICKER txt_vencimento ;
	HEIGHT 20;
	WIDTH 90;
	ON enter {||boleto_salva(),mostra_linha2()}
	
//////////////////////////////////////////
  
    @ 95,L1  LABEL  ldata;
	VALUE 'Data Emiss�o';
	WIDTH 160 ;
	TRANSPARENT
    
	
    @ 110,L1  DATEPICKER dataemissao; 
	value date();
	HEIGHT 20;
	WIDTH 80
/////////////////////////////////////////////////	
    @ 95,L1+100  LABEL  ldoc ;
	VALUE 'Documento';
	WIDTH 70 ;
	TRANSPARENT
	
    @ 110,L1+100 TEXTBOX txt_documento;
    WIDTH  100 HEIGHT 0020 ;
    FONT "Ms Sans Serif" SIZE 008;
	ON enter {||boleto_salva(),mostra_linha2()}
      
  
//////////////////////////////////////////////
       @ 95,L1+200  LABEL  lespec;
	VALUE 'Esp.';
	WIDTH 60 ;
	TRANSPARENT

       @ 110,L1+200  TEXTBOX txt_especie;
        WIDTH  30;
	    HEIGHT 020 ;
        FONT "Ms Sans Serif" SIZE 008 ;
		value "DM"
		
////////////////////////////////////////////////

  @ 95,L1+260 LABEL oSay11;
       Value "Moeda";
      WIDTH 0040 ;
      HEIGHT 0013 ;
      FONT "MS Sans Serif" SIZE 0008 

   @ 110,L1+ 0260   TEXTBOX txt_moeda;
      WIDTH  30;
      HEIGHT 0020 ;
      FONT "Ms Sans Serif" SIZE 008 ;
      value "R$"

////////////////////////////////////
    
  @ 95,L1+310 label processa;
	VALUE 'Processameto';
	WIDTH 80 ;
	TRANSPARENT
	
		
    @ 110,L1+310  DATEPICKER processamento ;
	HEIGHT 20 ;
	WIDTH 80;
	value DATE() 
 ///////////////////////////////////////////////////////
 
   @ 095, 410 LABEL oSay12 Value "Aceite";
      WIDTH 0036 ;
      HEIGHT 013 ;
      FONT "MS Sans Serif" SIZE 0008 

    @ 0110, 410  TEXTBOX txt_aceite;
      WIDTH  30 HEIGHT 0020 ;
      FONT "Ms Sans Serif" SIZE 008 ;
      Value "S"
      
 ////////////////////////////////////////////////////////
    @ 110,L1+440  LABEL lnnumero;
	VALUE 'N�mero';
	RIGHTALIGN ;
	WIDTH 100 ;
	TRANSPARENT
 

      @ 0110,L1+550  TEXTBOX txt_nossonumero;
	   width 90;
       HEIGHT 20;
       value cNumero;
       numeric;
	   font 'verdana';
       size 10;
       maxlength 8;
	   rightalign
		   
////////////////////////////////////////////////////////		  
        @ 0140, 460 LABEL oSay7;
        Value "Nosso n� Gerado";
        WIDTH 0100;
	    HEIGHT 0013 ;
        FONT "MS Sans Serif" SIZE 0008 
	  
       @ 140, L1+550 label txt_nossogerado;
        autosize;
	    font "ms sans serif" size 008
		  
//////////////////////////////////////////

    @ 190,L1+460  LABEL lvalor;
	VALUE 'Valor';
	RIGHTALIGN;
	WIDTH 80 ;
	TRANSPARENT
    

    @ 190,t1+480  TEXTBOX  txt_valor;
	HEIGHT 20;
	WIDTH 90 ;
	NUMERIC INPUTMASK '99,9999.99';
	ON enter {||boleto_salva(),mostra_linha2()}
	
////////////////////////////////////////////////////////////////////////// 
    @ 140,L1 LABEL lintrucos ;
	VALUE 'Instru��es' ;
	WIDTH 80;
	TRANSPARENT
    
     
    @ 155,L1 TEXTBOX  inst01t;
	HEIGHT 20;
	WIDTH 450;
	VALUE "ATEN��O PROTESTAR COM 5 DIAS DE VENCIDO";
	READONLY

	          
    @ 175,L1 TEXTBOX  inst02t;
	HEIGHT 20;
	VALUE "";
	WIDTH 450;
	READONLY
	
    @ 195,L1 TEXTBOX  inst03t;
	HEIGHT 20;
	VALUE "ATEN��O N�O RECEBER VALOR A MENOR";
	WIDTH 450;
	READONLY
	
    @ 215,L1 TEXTBOX  inst04t ;
	HEIGHT 20;
	WIDTH 450 ;
	READONLY
	
    @ 235,L1 TEXTBOX  inst05t ;
	HEIGHT 20;
	WIDTH 450;
	READONLY
///////////////////////////////////////////////////////////


   @ 0255,  10 LABEL oSay13 Value "Campo livre";
      WIDTH 0058 HEIGHT 0013 OF oForm;
      FONT "MS Sans Serif" SIZE 0008

   @ 270, 0010      TEXTBOX txt_campolivre;
      WIDTH 602 HEIGHT 0020 OF oForm;
      FONT "Ms Sans Serif" SIZE 008;
      READONLY	   

   @ 295,  10 LABEL oSay14 Value "LInha digit�vel";
      WIDTH 0078 HEIGHT 0013 OF oForm;
      FONT "MS Sans Serif" SIZE 0008
   
   @ 310, 0010      TEXTBOX txt_linhadigitavel;
      WIDTH 602 HEIGHT 0020 OF oForm;
      FONT "Ms Sans Serif" SIZE 008;
      READONLY	   

   @ 0330,  10 LABEL oSay16 Value "C�digo de barras";
      WIDTH 0086 HEIGHT 0013 OF oForm;
      FONT "MS Sans Serif" SIZE 0008

   @ 350, 0010      TEXTBOX txt_codigobarras;
      WIDTH 602 HEIGHT 0020 OF oForm;
      FONT "Ms Sans Serif" SIZE 008;
      READONLY	   
      
   @ 370,  10 LABEL oSay16x8 Value "Bin�rios";
      WIDTH 0086 HEIGHT 0013 OF oForm;
      FONT "MS Sans Serif" SIZE 0008 

   @ 390, 0010      TEXTBOX txt_binarios;
      WIDTH 602 HEIGHT 0020 OF oForm;
      FONT "Ms Sans Serif" SIZE 008;
      READONLY	   
  
/////////////////////////////////////////////////////////////////

    @ 420,L1 LABEL lsacado;
	VALUE 'Sacado' ;
	WIDTH 80;
	TRANSPARENT
	
    @ 440,L1 TEXTBOX  txt_sacado;
	HEIGHT 20;
	WIDTH 450;
	READONLY
	

    @ 460,L1 TEXTBOX  txt_endereco;
	HEIGHT 20;
	WIDTH 450;
	READONLY
    
    @ 480,L1 TEXTBOX  txt_cep;
	HEIGHT 20;
	WIDTH 80;
	READONLY
	
	
    @ 480,L1+90 TEXTBOX  txt_bairro;
	HEIGHT 20;
	WIDTH 160;
	READONLY
	
    @ 480,L1+250 TEXTBOX  txt_cidade;
	HEIGHT 20;
	WIDTH 160;
	READONLY
	
    @ 480,L1+420 TEXTBOX  txt_estado;
	HEIGHT 20;
	WIDTH 30;
	READONLY
    
    @ 480,t1+440 TEXTBOX  txt_cpf;
	HEIGHT 20;
	WIDTH 130;
	READONLY
	  
   @ 530, 010 BUTTON oBut1 CAPTION "&Gerar Pdf";
     WIDTH 0080 HEIGHT 0024;
     FONT "MS Sans Serif" SIZE 0008 ACTION ( multiimpressao() ,guarda_boleto2() )  
	 
	 
   @ 530, 0200 BUTTON oBut2 CAPTION "&Imprimir";
      WIDTH 0080 HEIGHT 0024;
	 ACTION  (printPV:= .t., imprime_hum(boleto->numero,printPdf ),guarda_boleto2() ) 
	
	  
   @ 530, 0400 BUTTON oBut3 CAPTION "&Esc/Sair";
      WIDTH 0080 HEIGHT 0024;
	 ACTION  oform_boleto.release 

	 
 
  END WINDOW
   oform_boleto.center()
   oform_boleto.Activate()
return 
 
 
*----------------------------------
STATIC Function PESQ_PVENDA()
*----------------------------------
 local chave
 local i
 local cNome_Anterior := space(40)
 chave := 0
 chave := (oform_boleto.txt_DAV.value)
  
 
Reconectar_A() 

  if empty(oform_boleto.txt_DAV.value)
	           msgexclamation('Digite o Cupom (COO)','Aten��o')
               oform_boleto.txt_dav.SetFocus
               oform_boleto.txt_dav.VALUE:=0	  
               return(.f.)
           endif

 


DQuery := oServer:Query( "Select NUM_SEQ, NRPED, cupom, data_orc, cod_cli, nom_cli, cl_cgc ,rgie, cl_end, cl_pessoa, cl_cid, cod_ibge, ed_numero, email, cep, bairro, estado, desconto, ccf, serie, total_ven, valor_tot, desc1, desc2,data_venc From cupom WHERE NUM_SEQ = "+chave+" Order By emissao" )
If DQuery:NetErr()
  	MsgStop(DQuery:Error())
    MsgInfo("Por Favor verifique linha 5964")
    Return Nil
  Endif
  DRow	          :=dQuery:GetRow(1)
  xnum            :=dRow:fieldGet(1)
  xNRPED          :=dRow:fieldGet(2)
  xCUPOM          :=dRow:fieldGet(3)
  xDATA_ORC       :=dRow:fieldGet(4)
  xCOD_CLI        :=dRow:fieldGet(5)
  xNOM_CLI        :=dRow:fieldGet(6)
  xCL_CGC         :=dRow:fieldGet(7)
  xRGIE           :=dRow:fieldGet(8)
  xCL_END         :=dRow:fieldGet(9)
  xCL_PESSOA      :=dRow:fieldGet(10)
  xCL_CID         :=dRow:fieldGet(11)
  xCOD_IBGE       :=dRow:fieldGet(12)
  xED_NUMERO      :=dRow:fieldGet(13)
  xEMAIL          :=dRow:fieldGet(14) 
  xCEP            :=dRow:fieldGet(15)
  xBAIRRO         :=dRow:fieldGet(16)
  xestado         :=dRow:fieldGet(17)
  xDESCONTO       :=dRow:fieldGet(18)
  xCCF            :=dRow:fieldGet(19)
  xSERIE          :=dRow:fieldGet(20)  
  xTOTAL_VEN      :=str(dRow:fieldGet(21))
  xVALOR_TOT      :=str(dRow:fieldGet(22))
  xdesc1          :=str(dRow:fieldGet(23))
  xdesc2          :=str(dRow:fieldGet(24)) 
  xvencimento     :=(dRow:fieldGet(25)) 
	XTOTAL:=0
CREDITO_S:=0
nitem:=0
If !Empty(xnum) 
     else
   MsgInfo("Cupom N�o Enntrado: " , "ATEN��O")
    oform_boleto.txt_dav.SetFocus
    oform_boleto.txt_dav.VALUE:=0	  
 Return .f.
 EndIf
	             
nValMora := ROUND(val(xTOTAL_VEN)  * 10/ 100, 2)/30
cInstr += " MORA DE R$ " + (Transform(nValMora, "@EB 999,999.99")) + " POR DIA DE ATRAZO"
 		     
			   if (!EOF())
			        ELSE
				       boleto->(DBAPPEND())
                       boleto->(dbrlock())  
					   boleto->COD_CLI        :=xCOD_CLI
					   boleto->CONTROLE       :=oform_boleto.txt_documento.value
	   	               boleto->banco          :=val(oform_boleto.txt_banco.value)
		               boleto->vcto           :=xvencimento
                       boleto->data           :=date()
                       boleto->dtproc         :=DATE()
                       boleto->agencia        :=val(oform_boleto.txt_agencia.value)
                       boleto->cod_cedent     :=val(oform_boleto.txt_cod_cedente.value) 
                     // boleto->numero         :=(oform_boleto.txt_documento.value)
		               boleto->numero         :=(oform_boleto.txt_nossonumero.value)
		               boleto->valor          :=val(xTOTAL_VEN) 
                       boleto->inst01         :="ATEN��O PROTESTAR COM 5 DIAS DE VENCIDO"
                       boleto->inst02         :=cInstr
                       boleto->inst03         :="ATEN��O N�O RECEBER VALOR A MENOR"
                       boleto->inst04         :="" 
                       boleto->inst05         :=""
		               boleto->nome_BANCO     :="SICOOB"
                       boleto->m_cedente      :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       boleto->m_sacado       :=xNOM_CLI
                       boleto->endereco       :=xCL_END 
                       boleto->cep            :=xCEP
                       boleto->bairro         :=xBAIRRO
                       boleto->cidade         :=oform_boleto.txt_cidade.value
                       boleto->estado         :=xestado
                       boleto->cgc            :=xCL_CGC 
					   boleto->CLINUMERO      :=xED_NUMERO
					   Boleto->cNPJ           :="84712611000152"
                       boleto->(dbunlock())
                       boleto->(DBCOMMIT())
                     ENDIF		 

 MODIFY CONTROL txt_sacado    OF oform_boleto   Value  ''+TransForm(boleto->m_sacado   ,"@!")
 MODIFY CONTROL txt_endereco  OF oform_boleto   Value  ''+TransForm(boleto->endereco   ,"@!")
 MODIFY CONTROL txt_cidade    OF oform_boleto   Value  ''+TransForm(boleto->cidade     ,"@!")
 MODIFY CONTROL txt_CEP       OF oform_boleto   Value  ''+TransForm(boleto->cep        ,"@!")
 MODIFY CONTROL txt_bairro    OF oform_boleto   Value  ''+TransForm( boleto->bairro    ,"@!")
 MODIFY CONTROL txt_estado    OF oform_boleto   Value  ''+TransForm(boleto->estado     ,"@!")


oform_boleto.txt_documento.value  :=boleto->controle
*oform_boleto.txt_documento.value  :=oform_boleto.txt_DAV.VALUE
oform_boleto.txt_vencimento.value :=boleto->vcto 
oform_boleto.inst02t.value        :=boleto->inst02 
oform_boleto.txt_valor.value      :=boleto->valor 
oform_boleto.textBTN_cliente.value:=xCOD_CLI

nChave:=xCOD_CLI
fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + ntrim(nChave)
 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
   oform_boleto.textBTN_cliente.setfocuS
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
 	
		 
 IF xxtipo='J'                        // pode imprimir?
	          	oform_boleto.Txt_CPF.value          :=xxcnpj               
				oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco+ xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	          ENDI
 IF xxtipo='F'                        // pode imprimir?
              	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco+ xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	       endif
 IF xxtipo='I'                        // pode imprimir?
    	      	oform_boleto.Txt_CPF.value          :=xxcnpj                
				oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco+ xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	      endif
 IF xxtipo='P'                        // pode imprimir?
  	          	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco+ xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
  endif

  *--------------------------------------------------------------*
STATIC Function pesq_cli()
*--------------------------------------------------------------*
Local cQuery      
Local oQuery  
local pCode:=Alltrim(Str(oform_boleto.textBTN_cliente.value))
LOCAL cCInstr :="" 
LOCAL Instr   :=""

 nChave:=pCode
 fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + (nChave)
 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
   oform_boleto.textBTN_cliente.setfocuS
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
 	
xxCEP:=limpa(xxCEP)
		
		 		 
 IF xxtipo='J'                        // pode imprimir?
	          	oform_boleto.Txt_CPF.value          :=xxcnpj             
				oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco+ xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	          ENDI
 IF xxtipo='F'                        // pode imprimir?
              	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco+ xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	       endif
 IF xxtipo='I'                        // pode imprimir?
    	      	oform_boleto.Txt_CPF.value          :=xxcnpj             
				oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco+ xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	      endif
 IF xxtipo='P'                        // pode imprimir?
  	          	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco+ xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
  endif
  fQuery:Destroy()	

  nValMora := ROUND((oform_boleto.txt_valor.value)  * 10/ 100, 2)/30
cCInstr += " MORA DE R$ " + (Transform(nValMora, "@EB 999,999.99")) + " POR DIA DE ATRAZO"
   
                       boleto->(dbrlock())  
					   boleto->COD_CLI        :=xxcodigo 
	   	               boleto->banco          :=val(oform_boleto.txt_banco.value)
		               boleto->vcto           :=oform_boleto.txt_vencimento.value
                       boleto->data           :=date()
                       boleto->dtproc         :=DATE()
                       boleto->agencia        :=val(oform_boleto.txt_agencia.value)
                       boleto->cod_cedent     :=val(oform_boleto.txt_cod_cedente.value) 
                       boleto->numero         :=(oform_boleto.txt_nossonumero.value)
		               boleto->valor          :=oform_boleto.txt_valor.value
                       boleto->inst01         :="ATEN��O PROTESTAR COM 5 DIAS DE VENCIDO"
                       boleto->inst02         :=Instr 
					   boleto->inst02         :=CcInstr
				       boleto->inst03         :="ATEN��O N�O RECEBER VALOR A MENOR"
                       boleto->inst04         :="" 
                       boleto->inst05         :=""
		               boleto->nome_BANCO     :="SICOOB"
                       boleto->m_cedente      :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       boleto->m_sacado       :=xxrazaosoc
                       boleto->endereco       :=xxendereco
                       boleto->cep            :=xxcep
                       boleto->bairro         :=xxbairro
                       boleto->cidade         :=xxcidade
                       boleto->estado         :=xxuf
                       boleto->CGC            :=oform_boleto.Txt_CPF.value
					   boleto->CNPJ           :="84712611000152"
					   boleto->tipo           :=xxtipo
					   boleto->CLINUMERO      :=xxnumero 
                       boleto->(dbunlock())
                       boleto->(DBCOMMIT())
					
RETUR           



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
            on dblclick {||Find_cli() }
		  	on change mostradadoscliente()
	END GRID  

	

  //@ 650,250 TEXTBOX cSearch ;
  //  WIDTH 326 ;
  //  MAXLENGTH 200 ;
  //  UPPERCASE  ;
  //  ON ENTER iif( !Empty(form_auto.cSearch.Value), pesqcli1(), form_auto.Grid_22.SetFocus )
	
 	  				   
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
oform_boleto.textBTN_cliente.value:=val(pcode)

  nChave:=pCode
 fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep From cliente WHERE codigo = " + (nChave)
 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
   oform_boleto.textBTN_cliente.setfocuS
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
 	
//xxCEP:=CHARREM(xxCEP)
//xxCEP:=(CHAR_REMOVE,xxCEP)
xxCEP:=limpa(xxCEP)
//msginfo(xxcep)
 
		 
 IF xxtipo='J'                        // pode imprimir?
	          	oform_boleto.Txt_CPF.value          :=xxcnpj                
				oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	          ENDI
 IF xxtipo='F'                        // pode imprimir?
              	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	       endif
 IF xxtipo='I'                        // pode imprimir?
    	      	oform_boleto.Txt_CPF.value          :=xxcnpj                
				oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	      endif
 IF xxtipo='P'                        // pode imprimir?
  	          	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
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
  
     
      
/////////////////////////////////////////////////
static FUNCTION boleto_salva
/////////////////////////////////////////////////
chave := (oform_boleto.txt_DAV.value)
cCInstr :="" 
Instr   :="                                                        "  
Reconectar_A() 

DQuery := oServer:Query( "Select NUM_SEQ, NRPED, cupom, data_orc, cod_cli, nom_cli, cl_cgc ,rgie, cl_end, cl_pessoa, cl_cid, cod_ibge, ed_numero, email, cep, bairro, estado, desconto, ccf, serie, total_ven, valor_tot, desc1, desc2,data_venc From cupom WHERE NUM_SEQ = "+chave+" Order By emissao" )
If DQuery:NetErr()
  	MsgStop(DQuery:Error())
    MsgInfo("Por Favor verifique linha 5964")
    Return Nil
  Endif
  DRow	          :=dQuery:GetRow(1)
  xnum            :=dRow:fieldGet(1)
  xNRPED          :=dRow:fieldGet(2)
  xCUPOM          :=dRow:fieldGet(3)
  xDATA_ORC       :=dRow:fieldGet(4)
  xCOD_CLI        :=dRow:fieldGet(5)
  xNOM_CLI        :=dRow:fieldGet(6)
  xCL_CGC         :=dRow:fieldGet(7)
  xRGIE           :=dRow:fieldGet(8)
  xCL_END         :=dRow:fieldGet(9)
  xCL_PESSOA      :=dRow:fieldGet(10)
  xCL_CID         :=dRow:fieldGet(11)
  xCOD_IBGE       :=dRow:fieldGet(12)
  xED_NUMERO      :=dRow:fieldGet(13)
  xEMAIL          :=dRow:fieldGet(14) 
  xCEP            :=dRow:fieldGet(15)
  xBAIRRO         :=dRow:fieldGet(16)
  xestado         :=dRow:fieldGet(17)
  xDESCONTO       :=dRow:fieldGet(18)
  xCCF            :=dRow:fieldGet(19)
  xSERIE          :=dRow:fieldGet(20)  
  xTOTAL_VEN      :=str(dRow:fieldGet(21))
  xVALOR_TOT      :=str(dRow:fieldGet(22))
  xdesc1          :=str(dRow:fieldGet(23))
  xdesc2          :=str(dRow:fieldGet(24)) 
  xvencimento     :=(dRow:fieldGet(25)) 
	XTOTAL:=0
CREDITO_S:=0
nitem:=0
If !Empty(xnum) 
     else
   MsgInfo("Cupom N�o Enntrado: " , "ATEN��O")
    oform_boleto.txt_dav.SetFocus
    oform_boleto.txt_dav.VALUE:=0	  
 Return .f.
 EndIf
	  
SELE BOLETO
Go bott
*if BOLETO->parc<=0
IF EMPTY(BOLETO->parc)
XXX=1
ELSE
XXX= XXX+1
ENDIF

	  
	  nValMora := ROUND((oform_boleto.txt_valor.value)  * 10/ 100, 2)/30
cCInstr += " MORA DE R$ " + (Transform(nValMora, "@EB 999,999.99")) + " POR DIA DE ATRAZO"
   
	            // if (!EOF())
				       boleto->(dbrlock())  
					   boleto->banco          :=xCOD_CLI
	   	               boleto->banco          :=val(oform_boleto.txt_banco.value)
		               boleto->controle       :=oform_boleto.txt_documento.value
		               boleto->ESPECIE        :=oform_boleto.txt_especie.value
					   boleto->vcto           :=oform_boleto.txt_vencimento.value
					   boleto->data           :=date()
                       boleto->dtproc         :=DATE()
                       boleto->agencia        :=val(oform_boleto.txt_agencia.value)
                       boleto->cod_cedent     :=val(oform_boleto.txt_cod_cedente.value) 
                       boleto->numero         :=(oform_boleto.txt_nossonumero.value)
		               boleto->valor          :=oform_boleto.txt_valor.value
                       boleto->inst01         :="ATEN��O PROTESTAR COM 5 DIAS DE VENCIDO"
                       boleto->inst02         :=Instr 
					   boleto->inst02         :=CcInstr
				       boleto->inst03         :="ATEN��O N�O RECEBER VALOR A MENOR"
                       boleto->inst04         :="" 
                       boleto->inst05         :=""
		               boleto->nome_BANCO     :="SICOOB"
					   boleto->PARC           :=STRZERO(XXX,3)
					   
                      // boleto->m_cedente      :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                      // boleto->m_sacado       :=xNOM_CLI
                      // boleto->endereco       :=xCL_END 
                      // boleto->cep            :=xCEP
                      // boleto->bairro         :=xBAIRRO
                      // boleto->cidade         :=oform_boleto.txt_cidade.value
                      // boleto->estado         :=xestado
                     //  boleto->CGC            :=xCL_CGC
					  // boleto->CNPJ           :="84712611000152"
                       boleto->(dbunlock())
                       boleto->(DBCOMMIT())
					*ELSE
		           //  ENDIF
		

 MODIFY CONTROL txt_sacado    OF oform_boleto   Value  ''+TransForm(boleto->m_sacado   ,"@!")
 MODIFY CONTROL txt_endereco  OF oform_boleto   Value  ''+TransForm(boleto->endereco   ,"@!")
 MODIFY CONTROL txt_cidade    OF oform_boleto   Value  ''+TransForm(boleto->cidade     ,"@!")
 MODIFY CONTROL txt_CEP       OF oform_boleto   Value  ''+TransForm(boleto->cep        ,"@!")
 MODIFY CONTROL txt_bairro    OF oform_boleto   Value  ''+TransForm( boleto->bairro    ,"@!")
 MODIFY CONTROL txt_estado    OF oform_boleto   Value  ''+TransForm(boleto->estado     ,"@!")
 MODIFY CONTROL txt_especie   OF oform_boleto   Value  ''+TransForm(boleto->ESPECIE    ,"@!")
   
oform_boleto.txt_documento.value  :=boleto->controle
*oform_boleto.txt_documento.value  :=oform_boleto.txt_DAV.VALUE
oform_boleto.txt_vencimento.value :=boleto->vcto 
oform_boleto.inst02t.value        :=boleto->inst02 
oform_boleto.txt_valor.value      :=boleto->valor 
oform_boleto.textBTN_cliente.value:=xCOD_CLI
RETURN 



FUNCTION multiimpressao
cNumero:=""



abreboleto()
publ path :=DiskName()+":\"+CurDir() 
PUBL printpdf:=GetDefaultPrinter()    //  Free PrimoPdf como virtual printer para criar arquivos PDF    www.primopdf.com  
PUBL printdpx:=GetDefaultPrinter() 
PUBL printmtx:=GetDefaultPrinter() 
PUBL printfax:=GetDefaultPrinter() 
*PUBL printLaser:=GetDefaultPrinter() 
*PUBL printX:=GetDefaultPrinter()
PUBL printLaser:="PrimoPDF"

PUBL printPV:=.t.
PUBL cInstr		:= ''

PUBL root:= GetStartUpFolder()+'\' 
PUBL iniFile_c:=.t. 

PUBL dirstart:=root 
PUBL dirdbf:=root 
PUBL dircrm:=root 
PUBL dirpdf:=root
PUBL dirhtml:=root
PUBL dirRemessa:= root
nNumOS:=1



 Set Exclusive OFF
 Set Delete ON
 Set Date brit
 Set Century ON
 Set Epoch TO 1920
 set navigation extended
cNumero:=""
Reconectar_A()

cNumero := substr(alltrim(str(HB_RANDOM(123456,999999))),1,6)
cNumero        := val(cNumero)


 c_banco                  :="756"
 c_moeda                  := "9"
 c_cod_cedente            := "4260"
 c_digito_cedente         := "0"
 c_cnpj                   := "84712611000152"
 c_valor                  := 0
 c_especie                := "OU"
 c_aceite                 := "N"
 c_vencimento             := ctod(" / /  ")
 c_agencia                := "3325"
 c_nossonumero            := Numero
 c_cpf                    := ""
 c_cedente                := "MEDIAL COMERCIO DISTRIBUIDOR LTDA"
 c_sacado                 := ""
 c_cidade                 := ""
 c_bairro                 := ""
 c_endereco               := ""
 c_documento              := ""
 c_estado                 := ""
 c_CEP                    := ""

 
// definicoes das colunas de labels e textbox 
ww= 700            // total de colunas do box  
wh= 540              // total de linhas do box
vwh=1000   //  virtual height
we=5                            
we2=we*2
we3=we*3
we4=we*4
we5=we*5
we6=we*6
 

tbc=we2
tbl=40+we2
tbw=ww-we5
tbh=wh-80-we6          //20 titulo 40 toolbar 20 statusbar  2 espacos 
vtbh=vwh-80-we6          //20 titulo 40 toolbar 20 statusbar  2 espacos 

tbu=tbw-we6

L1=we3 
L2=(ww/2)+we6 
L3=(ww/3)+we6 
L4=(ww/3*2)+we6   

Lu=tbc-we4 
Lb=tbl-30                    // linha dos botoes inferiores                 

t1=L1+70 
t2=L2+70 
t3=L3+70 
t4=L4+70
tt=tbc-L1-L1  

novoboleto:=.F.
editaboleto:=.F.    
numeroboleto:=0
lprintPdf:=.f. 
lprintPreview:=.f.
lprintDefault:=.F.
c_banco:="756"



IF ISWINDOWACTIVE(wbolseq)   
   RETURN 
Endif
ww=670
wh=380 
wm=ww/2 
lb=wh-90
DEFINE WINDOW wbolseq  ; 
    AT 0,0 ;
    WIDTH 1000 ;
    HEIGHT 400 ;
    TITLE "Boleto de Cobran�a" ;
    MODAL NOSIZE ;
	ON INIT bolseq_init2() ;
    ON RELEASE ( boleto->(dbgotop()) )

	 //ON INIT bolseq_init2() ;
	 
    DEFINE STATUSBAR FONT "Arial" SIZE 9    
        STATUSITEM ' ' 
    END STATUSBAR

    @ 10,10 LABEL ldes VALUE 'Boletos disponiveis' FONTCOLOR BLUE WIDTH 150 TRANSPARENT   

    @ 25,10 BROWSE boleto                       ;  
      WIDTH 540                                 ;
      HEIGHT 240                                ;   
      HEADERS { 'N�mero','Sacado','Vencimento','Valor R$' }      ; 
      WIDTHS { 80,280,120,120 }                      ;
      WORKAREA  boleto                          ;
      FIELDS { 'boleto->numero','SUBSTR(boleto->M_SACADO,1,40)','boleto->vcto' ,'TransForm(boleto->valor,"@R 99,999.99")' }  ;
     JUSTIFY { 1,0,1,1 }   ;
      VALUE 1                                                       ;
      ON CHANGE ( boleto->(dbgoto(wbolseq.boleto.value)) )      ;
      ON DBLCLICK bolseq_este2()    
	  

   @ 25,590 GRID selecao;
    WIDTH 440;
    HEIGHT 240   ; 
    HEADERS { 'N�mero','Vencimento','Valor' }    ; 
    WIDTHS { 80,160,120 };
    JUSTIFY { 1,1,1 } ;
	value 0
	
       * ON GOTFOCUS bolseq_selecao_focus2(),bolseq_retira2()      ;
 
   @ 90,550  BUTTON beste CAPTION '>>' FLAT  WIDTH 30  HEIGHT 20  ; 
             ACTION  bolseq_este2()

   @120,550   BUTTON bretira CAPTION '<<' FLAT  WIDTH 30 HEIGHT 20 ;
              ACTION bolseq_retira2()

	
	   
   aIMP:=Impresoras(printlaser)

*PUBL aIMP:="PrimoPDF"

   @lb,10 LABEL lprinter ;
           VALUE 'Impresora' ;
           WIDTH 60 HEIGHT 25
           
   @lb,70 COMBOBOX cImpressora ;
            WIDTH 280 ;
            ITEMS aIMP[1] ;
            VALUE aIMP[4] ;
            TOOLTIP 'Impresora' NOTABSTOP   ;
            ON CHANGE  printX:=wbolseq.cImpressora.displayvalue


   @ lb,500   BUTTON bconfirma CAPTION 'Continuar' FLAT  WIDTH 70  HEIGHT 20  ;
                 ACTION ( confirma2() )

   @ lb,580   BUTTON bcancela CAPTION 'Voltar' FLAT  WIDTH 70  HEIGHT 20  ;
                 ACTION ( anexapdf(), wbolseq.release  )
  

  bolseq_este2()

END WINDOW
wbolseq.center
wbolseq.activate
RETURN


//////////////////////////////////////////////
FUNCTION imprime_hum(nbn,npn,numero)
/////////////////////////////////////////////

boleto->(DBGOTO(wbolseq.boleto.VALUE))
wcodigo     :=boleto->(recno())
w_numero    :=boleto->numero
*msginfo(w_numero)

*IF npn<>printPdf 
*   IF ! msgyesno('Confirma a impress�o do boleto',STR(boleto->numero))
*      RETURN
*  Endif 
*Endif 
 
numero_boleto:=nbn

*msginfo(nbn)
*msginfo(numero_boleto)
 

printX:=npn
IF EMPTY(printX)
   printX:=printlaser 
Endif   
   
SET EPOCH TO 2000
SET DATE BRIT 
boleto->(dbsetorder(1))
boleto->(dbseek(numero_boleto))

aLnit:=array(7)  
alnit[1]:=boleto->inst01
alnit[2]:=boleto->inst02
alnit[3]:=boleto->inst03
alnit[4]:=boleto->inst04
alnit[5]:=boleto->inst05
alnit[6]:=""// padroes->bol_linha6        
alnit[7]:=""  //padroes->bol_linha7

c_COD_BANCO       :=boleto->banco                  //banco    numero banco N3
C_dv_bamco        :=boleto->dv_banco               //banco    digito nbanco C1
c_Nome_banco      :=ALLTRIM(boleto->nome_banco)    //banco    nome banco C15
c_agencia         :=boleto->agencia                //banco    agencia N4
c_Dv_Agencia      :=boleto->dv_agencia             //banco    digito agencia C1
c_Cod_cedente     :=(boleto->cod_cedent)            //banco    conta N8
c_Dv_cedente      :=boleto->dv_cedent             //banco    digito conta C1
Moeda             :="9" //tipo da moeda 9= R$
c_Modalidade      :=01 //modalidade
mNMCD           :=ALLTRIM(boleto->m_cedente)     //  Cedente  C50
mCGCD           :=ALLTRIM(boleto->CNPJ)          //  cnpj do cedente   C18
mDTDC           :=boleto->data                   //  data do documento   D 
Num_doc         :=boleto->CONTROLE                //  numero do docto NF N6
especie         :=boleto->especie                //  especie/tipo  do docto C2
mACDC           :='N'                            //  aceite  C1
mDTPC           :=boleto->dtproc                 //  data do processamento   D
c_nosso_numero  :=boleto->numero                 //  nosso numero N8
Carteira        :=1                              //  carteira cobranca N3
Quantidade      :=1                              //  quantidade  N3
mVRMD           :=1                              //  valor da moeda  N9,2
c_Valor          :=boleto->valor                  //  valor N12,2
Vencimento     :=boleto->vcto                   //  Data vcto D
Sacado         :=boleto->m_sacado               //  Sacado   C50
Endereco       :=boleto->endereco               //  endereco sacado C50
Bairro         :=ALLTRIM(boleto->bairro)        //  bairro sacado C20
Cidade         :=ALLTRIM(boleto->cidade)        //  Cidade do Sacado   C20 
uf             :=boleto->estado                 //  estado do Sacado   C2
Cep            :=boleto->cep                    //  CEP sacado  C9
XCGC           :=boleto->cgc                    //  CPF / CNPJ sacado C18
parcela        :=boleto->PARC
xvencimento:=boleto->vcto        


*msginfo(Vencimento)

mLGBC:=PATH+'\sicooblogo.gif'
mDTBS:=ctod("07/10/1997") //   data base pata dias a vencer
mHOJE:=SUBSTR(DTOC(DATE()),1,6)+STR(YEAR(DATE()),4) 
/////////////////////////////////////////////////////
// Rotina de cria��o dos campos e visualiza��o do codigo de barras
//////////////////////////////////////////////////////////////////

public mLCPG,mNSNM,mDGNN,mCPLV,mCDBR,mDGCB,mRNCB,mFTVC,mC1RN,mC2RN,mC3RN,mC4RN,mC5RN
Cod_banco   :=strzero(c_Cod_banco,3)
agencia     :=strzero(c_agencia,4) // c�digo da ag�ncia
Cod_cedente :=strzero(c_Cod_cedente, 10)    // conta corrente
nosso_numero:=strzero(c_nosso_numero,7)



mLCPG:= [PAG�VEL PREFERENCIALMENTE NAS COOPERATIVAS DE CR�DITO DO SICOOB]
Carteira:= [1]                  // c�digo da carteira: 1 (A - Simples)
mPOCD:= [02]                 // INCLUIR AQUI O CODIGO DO POSTO CEDENTE OU UNIDADE DE ATENDIMENTO
Modalidade:= [01]                  // c�digo referente ao tipo de cobran�a: 1 - com Registro, 3 - Sem Registro

 ** Num_doc:= nosso_numero
   mFTVC:=strzero(Vencimento-mDTBS,4)
   Valor:=strzero(c_Valor*100,10)
   xDTVC:=SUBSTR(DTOC(Vencimento),1,6)+STR(YEAR(Vencimento),4)       
   Vencimento:=dtoc(Vencimento)        
   aLnit:=Iif(ischaracter(aLNIT),{aLNIT,"","","","","",""},aLNIT)
//
// Monta Nosso N�mero (p/ Banco)
//
   
agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
cValor:=strzero(c_Valor*100,10)

   
   * C�lculo do Fator de Vencimento 
    mFTVC:= strzero((CTOD(Vencimento) - CTOD([03/07/2000])) + 1000, 4)
    mCDEM:= [3]
    mDGNN:=gerar_dv(teste)
    mNSNM:= Substr(str(year(mDTDC), 4), 3, 2) + [/] + mCDEM + nosso_numero + [-] + mDGNN
    mNSNM= nosso_numero + [-] + mDGNN
*  oform_boleto.txt_nossogerado.value:=mNSNM   
   parcela        :=boleto->PARC

//////////////////////////////////////////////////////////////////////
// Monta Campo Livre do C�digo de Barras e Linha Digit�vel (p/ Banco) == mCPLV
///////////////////////////////////////////////////////////////////////
// sicoob
 If val(cValor) # 0
   cFiller:= [10]
   Else
   cFiller:= [00]
 Endif
    Cod_cedente:=VAL(Cod_cedente)
    mCPLV:= modalidade + STRZERO(Cod_cedente,7) + substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
	//oform_boleto.txt_campolivre.VALUE:=mCPLV
    Cod_cedente:=STR(Cod_cedente)
* msginfo(mCPLV)
///////////////////////////////////////////
// Monta C�digo de Barras (p/ Banco)
//////////////////////////////////////////

agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
 

 gdv_barras:=cod_banco+moeda+mFTVC+cvalor+carteira+agencia1+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
*gdv_barras:=cod_banco+moeda+mFTVC+valor+carteira+agencia+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
dbbarras:=gerar_dv_barra(gdv_barras)
mDGCB:=dbbarras
mCDBR:=cod_banco+moeda+mDGCB+mFTVC+cvalor+carteira+agencia1+mCPLV 

///////////////////////////////////////////////////////
// Monta Representa��o N�merica do C�digo de Barras
/////////////////////////////////////////////////////////
mC1RN:=Cod_banco+moeda+carteira+agencia1
mC1RN+=blq_dg102(Cod_banco,mC1RN)
mC2RN:=substr(mCPLV,1,10)
mC2RN+=blq_dg102(Cod_banco,mC2RN)
mC3RN=substr(mCPLV,11,20)
*MSGINFO([5 digito] +mC3RN)
mC3RN=blq_dg102(Cod_banco,mC3RN)
*MSGINFO([5 digito] +mC3RN)
mC3RNA=substr(mCPLV,11,5)
*MSGINFO([5 digito] +mC3RNA)
mC3RN1=substr(mCPLV,16,1)
*MSGINFO([dv] +mC3RN1)
mC3RN1+=mDGNN+parcela+mC3RN
mC3RN:=mC3RN1
*MSGINFO(mC3RN)
mC4RN:=mDGCB
mC5RN:=mFTVC+strzero(val(cvalor),10)
     *              1                         2                            3                       4                          5                        6                     7            8
   mRNCB:= substr(mC1RN, 1, 5) + [.] + substr(mC1RN, 6) + [ ] + substr(mC2RN, 1, 5) + [.] + substr(mC2RN, 6)+ [ ] + mC3RNA + [.] + mC3RN1+ [ ] + mC4RN + [ ] + mC5RN
 // MSGINFO(mRNCB)
  
*   oform_boleto.txt_linhadigitavel.value := mRNCB
*   oform_boleto.txt_codigobarras.value   := mCDBR
*   oform_boleto.txt_binarios.value       := Int252(oform_boleto.txt_codigobarras.value)

///////////////////////////////////////////////
// Emite o Bloqueto
*boleto_imprimir2() 
 Cria_titulo_Ini()

///////////////////////////////////////////////
// grava o Bloqueto

Vencimento:=limpa(Vencimento)
vencimento:=CTOD(Vencimento)
cCValor:=VAL(cValor)/100
*msginfo(Vencimento)
nValMora := ROUND((cCValor)  * 10/ 100, 2)/30


                       xnumero    :=ntrim(numero_boleto)
					   xnosso_n   :=mNSNM
					   xcod_cedent:=ntrim(c_Cod_cedente)
                       XSACADO    :=Sacado
					   Xcedente   :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       XVCTO      :=dtos(xVencimento)
			           XVALOR     :=NTRIM(cCValor)
					   XCNPJ      :="84712611000152"
					   Xnsnumero  :=ntrim(c_nosso_numero)
					   Xdata      :=dtos(date())
					   nValMora   :=ntrim(nValMora)
/*	
*msginfo(XVCTO)
cQuery := "INSERT INTO boleto (data,cnpj,valor,VCTO,M_CEDENTE,M_SACADO,NOSSONUMERO,numero,VRMULTA)  VALUES ('"+Xdata+"','"+Xcnpj+"','"+Xvalor+"','"+Xvcto+"','"+Xcedente+"','"+XSACADO+"','"+xnosso_n+"','"+xnumero+"','"+nValMora+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
MsgStop(oQuery:Error())
MsgInfo("Por Favor Selecione o registro ") 
ENDIF
*/

/////////////////////////////////////////////
RETURN 

*******************************************************
static Function Cria_titulo_Ini()
local path :=DiskName()+":\"+CurDir()
************************************************************
 
DADOS_TITULO:={}
c_valor:=boleto->valor
nValMora:=boleto->valor
nValMora:=strzero(nValMora*15/30)
Vencimento:=dtoc(boleto->vcto)   

aadd(DADOS_TITULO,{'[Titulo1]'})
aadd(DADOS_TITULO,{'NumeroDocumento='+boleto->CONTROLE})
aadd(DADOS_TITULO,{'NossoNumero    ='+str(boleto->numero)})
aadd(DADOS_TITULO,{'Carteira       =1'})
aadd(DADOS_TITULO,{'ValorDocumento='+ALLTRIM(TRANSFORM(boleto->valor,"@ZE 999999999.99")) })
aadd(DADOS_TITULO,{'Vencimento     ='+Vencimento})
aadd(DADOS_TITULO,{'ValorMoraJuros ='+transform(round(val(nValMora)/100,2),"@ZE 999,999,999.99")})
aadd(DADOS_TITULO,{'NumeroDocumento='+(boleto->CONTROLE)})
aadd(DADOS_TITULO,{'PercentualMulta=0'})
aadd(DADOS_TITULO,{'LocalPagamento ="Pagavel em qualquer agencia bancaria ate o vencimento"'})
aadd(DADOS_TITULO,{'Mensagem       ="ATENCAO NAO RECEBER VALOR A MENOR"'})
aadd(DADOS_TITULO,{'DataDocumento    ='+dtoc(date())})
aadd(DADOS_TITULO,{'DataProcessamento    ='+dtoc(date())})
aadd(DADOS_TITULO,{'DataAbatimento=0'})
aadd(DADOS_TITULO,{'DataDesconto=0'})
aadd(DADOS_TITULO,{'DataMoraJuros=0'})
aadd(DADOS_TITULO,{'DataProtesto=0'})
aadd(DADOS_TITULO,{'ValorAbatimento=0'})
aadd(DADOS_TITULO,{'ValorDesconto=0'})
aadd(DADOS_TITULO,{'ValorIOF=0'})
aadd(DADOS_TITULO,{'ValorOutrasDespesas=0'})
aadd(DADOS_TITULO,{'EspecieDoc=DM'})
aadd(DADOS_TITULO,{'EspecieMod=R$'})

IF BOLETO->TIPO='J'    
aadd(DADOS_TITULO,{'Sacado.CNPJCPF='+Trans(XCGC ,'@R 99.999.999/9999-99')})
*aadd(DADOS_TITULO,{'Sacado.CNPJCPF ='+ALLTRIM(TRANSFORM(XValor,"@ 999999999999.999")) })
	 
aadd(DADOS_TITULO,{'Sacado.Pessoa=1'})
ELSEIF BOLETO->TIPO='I'
aadd(DADOS_TITULO,{'Sacado.CNPJCPF='+Trans(XCGC ,'@R 99.999.999/9999-99')})
aadd(DADOS_TITULO,{'Sacado.Pessoa=1'})
ELSEIF BOLETO->TIPO='P'
aadd(DADOS_TITULO,{'Sacado.CNPJCPF='+Trans(XCGC ,'@R 999.999.999-99')})
aadd(DADOS_TITULO,{'Sacado.Pessoa=0'})
ELSEIF BOLETO->TIPO='F'
aadd(DADOS_TITULO,{'Sacado.CNPJCPF='+Trans(XCGC ,'@R 999.999.999-99')})
aadd(DADOS_TITULO,{'Sacado.Pessoa=0'})
endif

aadd(DADOS_TITULO,{'Sacado.NomeSacado='+boleto->m_sacado})
aadd(DADOS_TITULO,{'Sacado.Logradouro='+boleto->endereco})
aadd(DADOS_TITULO,{'Sacado.Numero='+boleto->CLINUMERO })
aadd(DADOS_TITULO,{'Sacado.Bairro='+boleto->bairro})
aadd(DADOS_TITULO,{'Sacado.Complemento=0'})
aadd(DADOS_TITULO,{'Sacado.Cidade='+boleto->cidade})
aadd(DADOS_TITULO,{'Sacado.UF='+boleto->estado  })
aadd(DADOS_TITULO,{'Sacado.CEP='+boleto->cep})
aadd(DADOS_TITULO,{'Aceite=n'})

HANDLE :=  FCREATE ("C:\ACBrMonitorPLUS\titulo.ini",0)// cria o arquivo
	for i=1 to len(DADOS_TITULO)
		fwrite(handle,alltrim(DADOS_TITULO[i,1]))
        fwrite(handle,chr(13)+chr(10))
	next
fclose(handle)  
public cTXT     :="C:\ACBrMonitorPLUS\TITULO.INI"

GERABOLETOSSICOOB()
ThisWindow.release	
Return Nil


static function GERABOLETOSSICOOB()
LOCAL i, j, aSubDir, cSubDir, nError
lOCAL aNewDir := { "temp" }
local xdia := strzero(day(date() ),2 )

*+ strzero(month(date() ), 2 ) + strtran(time(), ':','' )

*Criadir_remessa()

PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
*msginfo(NUMERO)

SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

resultado:=alltrim(xdia+zNUMERO+xxANO)

    *     cSubDir := DiskName()+":\"+CurDir()+"\"+resultado+"\"
	 	  cSubDir := DiskName()+":\"+CurDir()+"\"+"BOLETOS"+"\"+resultado+"\"
  	
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diret�rio criado com sucesso", cSubDir, "Diret�rio criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "J� existe Diretorio Criado", cSubDir, "J� existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Cria��o do Diret�rio" )  ////, cSubDir, LTrim( Str( nError ) ) 
            ENDIF


Tipo_Relatorio=1


   RET := IBR_COMANDO_BOLETO( "ConfigurarDados(D:\NFC-E-v-3-plus\cedente.ini)"   )
   
		
   RET := IBR_COMANDO_BOLETO( "ConfigurarDados(C:\ACBrMonitorPLUS\cedente.ini)"   )
 		
	
				  RET := IBR_COMANDO_BOLETO( "LimparLista" )
				  RET := IBR_COMANDO_BOLETO( "IncluirTitulos(C:\ACBrMonitorPLUS\\titulo.ini)"   )
	           *   RET := IBR_COMANDO_BOLETO( "Imprimir"  )
			      RET := IBR_COMANDO_BOLETO( "GerarPDF"  )
			  *   RET := IBR_COMANDO_BOLETO( "GerarHTML"  )
		       	 cRet := IBR_COMANDO_BOLETO("GerarRemessa("+cSubDir+")")
*ThisWindow.release
		
boleto:="C:\ACBrMonitorPLUS\boleto.PDF"
PDFOpen(boleto)		

Return Nil











//===========================================================================//
//                                                                           //
// Retorna D�gito de Controle M�dulo 10                                      //
//                                                                           //
//===========================================================================//
function BLQ_DG102(Cod_banco,mNMOG)
local mVLDG,mSMMD,mCTDG,mRSDV,mDCMD
mSMMD:=0
for mCTDG:=1 to len(mNMOG)
   mVLDG:=val(substr(mNMOG,len(mNMOG)-mCTDG+1,1))*Iif(mod(mCTDG,2)==0,1,2)
   mSMMD+=mVLDG-Iif(mVLDG>9,9,0)
endfor
mRSDV:=mod(mSMMD,10)
mDCMD:=Iif(mRSDV==0,"0",str(10-mRSDV,1))
return mDCMD

//===========================================================================//
// Retorna D�gito de Controle M�dulo 11 (p/ Banco)                           //                                                                           //
//===========================================================================//

static Function BLQ_DG1102(Cod_banco, mBSDG, mFGCB, mNMOG)
   Local mSMMD:= mRSDV:= mCTDG:= 0, mSQMP:= 2, mDCMD:= []
   
   If mFGCB == Nil
      mFGCB:= .F.
   Endif

   For mCTDG:= 1 to len(mNMOG)
       mSMMD+= val(substr(mNMOG, len(mNMOG) - mCTDG + 1, 1)) * mSQMP
       mSQMP:= Iif(mSQMP == mBSDG, 2, mSQMP + 1)
   EndFor
   mRSDV:= Int(mod(mSMMD, 11))
If Cod_banco == [756]      // sicoob
      mDCMD:= Iif(mRSDV <= 1 .or. mRSDV >= 10, [1], str(11 - mRSDV, 1))
  Else
      MsgStop([Rotina BLQ_DG11 n�o implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)

*******************************************************************************

**************************** alterado por Malc Inform�tica em 18/08/2010 ******
* Retorna D�gito Verificador do Nosso N�mero - Banco 748 Sicoob
*******************************************************************************
Function blq_dg11_756_nn2(Cod_banco, mBSDG, mNMOG)
   Local mCTDG:= 1, mSMMD:= mRSDV:= 0, mSQMP:= 2, mDCMD:= []
  For mCTDG:= 1 to len(mNMOG)
          mSMMD+= val(substr(mNMOG, len(mNMOG) - mCTDG + 1, 1)) * (mSQMP)
       mSQMP:= Iif(mSQMP == mBSDG, 2, mSQMP + 1)
   endfor
   
   mRSDV:= Int(Mod(mSMMD, 11))
   If Cod_banco == [756]  // Sicoob
      mDCMD:= Iif(mRSDV == 0, [0], Iif((11 - mRSDV) > 9, [0], str(11 - mRSDV, 1)))
   Else
      MsgStop([Rotina BLG_DG11_756_NN n�o implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)


*******************************************************************************


*************************** alterado por jose juca em 20/4/20110 ******
* Retorna D�gito Verificador do Campo Livre - Banco 748 Sicoob
*******************************************************************************
Function blq_dg11_756_cl2(Cod_banco, mBSDG, mNMOG)
   Local mCTDG:= 1, mSMMD:= mRSDV:= 0, mSQMP:= 2, mDCMD:= []
 
   For mCTDG:= 1 to len(mNMOG)
       mSMMD+= val(substr(mNMOG, len(mNMOG) - mCTDG + 1, 1)) * (mSQMP)
       mSQMP:= Iif(mSQMP == mBSDG, 2, mSQMP + 1)
   endfor
   mRSDV:= Int(Mod(mSMMD, 11))
   If Cod_banco == [756]  // Sicoob
      mDCMD:= Iif(mRSDV <= 1, [0], str(11 - mRSDV, 1))
   Else
      MsgStop([Rotina BLG_DG11_756_CL n�o implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)


FUNCTION bolseq_init2()
printPV:=  .F.  
//boleto->(dbsetorder(1))   
dbselectarea('BOLETO')
ordsetfocus('VENCIMENTO')
//BOLETO->(dbgotop())
boleto->(dbgobottom())
boleto->(dbskip(-1))
wbolseq.SELECAO.value:=boleto->(recno())
//wbolseq.selecao.DeleteItem(wbolseq.selecao.value)
RETURN 


#include <minigui.ch>   
#include <common.ch> 
 
///  impressoras
static Function Impresoras(nome)
   Local aIMP1,aIMP2,aIMP3,aIMP4

   aIMP1:=aPrinters()                             // lista de  impressoras
   ASORT(aIMP1,,, { |x, y| UPPER(x) < UPPER(y) })
   aIMP2:=GetDefaultPrinter()                     // printer default
   aIMP3:=ASCAN(aIMP1, {|aVal| aVal == aIMP2})    // numero da printer default
   aIMP4:=ASCAN(aIMP1, {|aVal| aVal == nome})     // numero da printer informada
   printX:=nome
RETURN {aIMP1,aIMP2,aIMP3,aIMP4}



FUNCTION confirma2()
IF wbolseq.selecao.Itemcount>=0 
   wbolseq.statusbar.item(1):='Aguarde, imprimindo boletos'
   nbb=wbolseq.selecao.Itemcount
   FOR nbp=1 to nbb
       linhagrid = wbolseq.selecao.Item ( 1 )
       numero_boleto=VAL(linhagrid[1]) 
       imprime_hum(numero_boleto,printX)
       wbolseq.selecao.DeleteItem( 1 )
   NEXT nbp
   wbolseq.statusbar.item(1):=''
ELSE
   msgstop('Nenhum boleto foi selecionado','Boleto')
Endif

*msginfo(ALLTRIM(MaskBinData(MemoRead(cLocal))))


RETURN


FUNCTION bolseq_selecao_focus2 
//wbolseq.beste.enabled:= .F.
//wbolseq.bretira.enabled:=.T.
RETURN

FUNCTION bolseq_este2()
wbolseq.selecao.DeleteItem(wbolseq.selecao.value)
DELETE ITEM ALL FROM selecao Of wbolseq
wbolseq.selecao.AddItem ( { STR(boleto->numero),TransForm(boleto->VCTO,"@D"),TransForm(boleto->valor,"@R 99,999.99") } )  
RETURN 


FUNCTION bolseq_retira2()
IF wbolseq.selecao.value>0 
   wbolseq.selecao.DeleteItem(wbolseq.selecao.value)
Endif
RETURN 
 



function dv_nnumero2(dv_nosso) 
   Local cCampo1, cCampo2, cCampo3, cCampo4,dvcampo3
   Local nDv1 := nDv2 := nDv3 := 0 ,vvDv2:=0 	
   Local aDv1[9], aDv2[10], aDv3[10],dvnosso[ 21]
   total1:=0
   resto :=0
   onze  :=11
   dvn:=0
  dv1:= val(substr(dv_nosso,1,1)) 
  dv1:=dv1*3
 dv2:= val(substr(dv_nosso,2,1))
 dv2:=dv2*1

 dv3:= val(substr(dv_nosso,3,1))
 dv3:=dv3*9
* msginfo([t0] +str(dv3)) 
 
 dv4:= val(substr(dv_nosso,4,1))
 dv4:=dv4*7
 * msginfo([t63] +str(dv4)) 
 
 ////////////////
 dv5:= val(substr(dv_nosso,5,1))
 dv5:=dv5*3

 
 dv6:= val(substr(dv_nosso,6,1))
 dv6:=dv6*1

 
 dv7:= val(substr(dv_nosso,7,1))
 dv7:=dv7*9

 
 dv8:= val(substr(dv_nosso,8,1))
 dv8:=dv8*7
  
 //////////////////////
 dv9:= val(substr(dv_nosso,9,1)) 
 dv9:=dv9*3

 
 dv10:= val(substr(dv_nosso,10,1))
 dv10:=dv3*1

 
 dv11:= val(substr(dv_nosso,11,1))
 dv11:=dv11*9

 
 dv12:= val(substr(dv_nosso,12,1))
 dv12:=dv12*7
  
 
 //////////////////////
 dv13:= val(substr(dv_nosso,13,1))
 dv13:=dv13*3

 
 dv14:= val(substr(dv_nosso,14,1))
 dv14:=dv14*1

 
 dv15:= val(substr(dv_nosso,15,1))
 dv15:=dv15*9

 
 dv16:= val(substr(dv_nosso,16,1))
 dv16:=dv16*7
  

 //////////////////////
 dv17:= val(substr(dv_nosso,17,1))
 dv17:=dv17*3

 
 dv18:= val(substr(dv_nosso,18,1))
 dv18:=dv18*1

 
 dv19:= val(substr(dv_nosso,19,1))
 dv19:=dv19*9

 
 dv20:= val(substr(dv_nosso,20,1))
 dv20:=dv20*7
    
 dv21:= val(substr(dv_nosso,21,1))
 dv21:=dv21*3
  
dvn:= 11 - ( Int(mod(total, 11)))
If dvn <= 0 .or. dvn > 9
       dvn:= 1
endif
return transform(dvn,"9")



STATIC FUNCTION gerar_dv(bbarra)
   Local cCampo1, cCampo2, cCampo3, cCampo4
   Local vDv1 := vDv2 := vDv3 := 0
   Local bDv1[9], bDv2[10], bDv3[10]
   Local i, cVar, nMultiplo
   Local cbarra, bDv[21], vDv := 0

	cbarra:=bbARRa
	
	bDv[ 1] := Val( SubStr( cBarra,  1, 1 ) ) * 3
	bDv[ 2] := Val( SubStr( cBarra,  2, 1 ) ) * 1
	bDv[ 3] := Val( SubStr( cBarra,  3, 1 ) ) * 9
	bDv[ 4] := Val( SubStr( cBarra,  4, 1 ) ) * 7
	
	bDv[ 5] := Val( SubStr( cBarra,  5, 1 ) ) * 3
	bDv[ 6] := Val( SubStr( cBarra,  6, 1 ) ) * 1
	bDv[ 7] := Val( SubStr( cBarra,  7, 1 ) ) * 9
	bDv[ 8] := Val( SubStr( cBarra,  8, 1 ) ) * 7
	
	bDv[ 9] := Val( SubStr( cBarra,  9, 1 ) ) * 3
	bDv[10] := Val( SubStr( cBarra, 10, 1 ) ) * 1
	bDv[11] := Val( SubStr( cBarra, 11, 1 ) ) * 9
	bDv[12] := Val( SubStr( cBarra, 12, 1 ) ) * 7
	
	bDv[13] := Val( SubStr( cBarra, 13, 1 ) ) * 3
	bDv[14] := Val( SubStr( cBarra, 14, 1 ) ) * 1
	bDv[15] := Val( SubStr( cBarra, 15, 1 ) ) * 9
	bDv[16] := Val( SubStr( cBarra, 16, 1 ) ) * 7
	
	bDv[17] := Val( SubStr( cBarra, 17, 1 ) ) * 3
	bDv[18] := Val( SubStr( cBarra, 18, 1 ) ) * 1
	bDv[19] := Val( SubStr( cBarra, 19, 1 ) ) * 9
	bDv[20] := Val( SubStr( cBarra, 20, 1 ) ) * 7
	bDv[21] := Val( SubStr( cBarra, 21, 1 ) ) * 3
	For i := 1 to 21
	   vDv += bDv[i]
	Next
/*	
vDv := ( 11 - ( vDv % 11 ) )
	
	If vDv > 9 .or. vDv = 0 .or. vDv = 1
	   vDv := 1
	Endif
*/


vDv:= 11 - ( Int(mod(vDv, 11)))
If vDv <= 0 .or. vDv > 9
       vDv:= 0
endif


//msginfo(vDv)
return transform(vDv,"9")



STATIC FUNCTION gerar_dv_barra(br_barra)
  Local cCampo1, cCampo2, cCampo3, cCampo4
   Local nDv1 := nDv2 := nDv3 := 0
   Local aDv1[9], aDv2[10], aDv3[10]
   Local i, cVar, nMultiplo
   Local cbarra, aDv[43], nDv := 0
   
   **msginfo(br_barra)
   
	* C�lculo do d�gito geral
	cBarra :=br_barra    //:="104" + oform.txt_moeda.value + strzero(fator_Vencimento(oform.txt_vencimento.value),4) + strzero(oform.txt_valor.value*100,10) + oform.txt_campolivre.value
	
	//oform.txt_codigobarras.value := cbarra
	
	aDv[ 1] := Val( SubStr( cBarra,  1, 1 ) ) * 4
	aDv[ 2] := Val( SubStr( cBarra,  2, 1 ) ) * 3
	aDv[ 3] := Val( SubStr( cBarra,  3, 1 ) ) * 2
	aDv[ 4] := Val( SubStr( cBarra,  4, 1 ) ) * 9
	aDv[ 5] := Val( SubStr( cBarra,  5, 1 ) ) * 8
	aDv[ 6] := Val( SubStr( cBarra,  6, 1 ) ) * 7
	aDv[ 7] := Val( SubStr( cBarra,  7, 1 ) ) * 6
	aDv[ 8] := Val( SubStr( cBarra,  8, 1 ) ) * 5
	aDv[ 9] := Val( SubStr( cBarra,  9, 1 ) ) * 4
	aDv[10] := Val( SubStr( cBarra, 10, 1 ) ) * 3
	aDv[11] := Val( SubStr( cBarra, 11, 1 ) ) * 2
	aDv[12] := Val( SubStr( cBarra, 12, 1 ) ) * 9
	aDv[13] := Val( SubStr( cBarra, 13, 1 ) ) * 8
	aDv[14] := Val( SubStr( cBarra, 14, 1 ) ) * 7
	aDv[15] := Val( SubStr( cBarra, 15, 1 ) ) * 6
	aDv[16] := Val( SubStr( cBarra, 16, 1 ) ) * 5
	aDv[17] := Val( SubStr( cBarra, 17, 1 ) ) * 4
	aDv[18] := Val( SubStr( cBarra, 18, 1 ) ) * 3
	aDv[19] := Val( SubStr( cBarra, 19, 1 ) ) * 2
	aDv[20] := Val( SubStr( cBarra, 20, 1 ) ) * 9
	aDv[21] := Val( SubStr( cBarra, 21, 1 ) ) * 8
	aDv[22] := Val( SubStr( cBarra, 22, 1 ) ) * 7
	aDv[23] := Val( SubStr( cBarra, 23, 1 ) ) * 6
	aDv[24] := Val( SubStr( cBarra, 24, 1 ) ) * 5
	aDv[25] := Val( SubStr( cBarra, 25, 1 ) ) * 4
	aDv[26] := Val( SubStr( cBarra, 26, 1 ) ) * 3
	aDv[27] := Val( SubStr( cBarra, 27, 1 ) ) * 2
	aDv[28] := Val( SubStr( cBarra, 28, 1 ) ) * 9
	aDv[29] := Val( SubStr( cBarra, 29, 1 ) ) * 8
	aDv[30] := Val( SubStr( cBarra, 30, 1 ) ) * 7
	aDv[31] := Val( SubStr( cBarra, 31, 1 ) ) * 6
	aDv[32] := Val( SubStr( cBarra, 32, 1 ) ) * 5
	aDv[33] := Val( SubStr( cBarra, 33, 1 ) ) * 4
	aDv[34] := Val( SubStr( cBarra, 34, 1 ) ) * 3
	aDv[35] := Val( SubStr( cBarra, 35, 1 ) ) * 2
	aDv[36] := Val( SubStr( cBarra, 36, 1 ) ) * 9
	aDv[37] := Val( SubStr( cBarra, 37, 1 ) ) * 8
	aDv[38] := Val( SubStr( cBarra, 38, 1 ) ) * 7
	aDv[39] := Val( SubStr( cBarra, 39, 1 ) ) * 6
	aDv[40] := Val( SubStr( cBarra, 40, 1 ) ) * 5
	aDv[41] := Val( SubStr( cBarra, 41, 1 ) ) * 4
	aDv[42] := Val( SubStr( cBarra, 42, 1 ) ) * 3
	aDv[43] := Val( SubStr( cBarra, 43, 1 ) ) * 2
	For i := 1 to 43
	   nDv += aDv[i]
	Next
	
	
nDv:= 11 - ( Int(mod(nDv, 11)))
If nDv <= 0 .or. nDv > 9
       nDv:= 1
endif

//msginfo(ndv)
return transform(ndv,"9")

/////////////////////////////////
FUNCTION boleto_imprimir2()  
////////////////////////////////
local path :=DiskName()+":\"+CurDir()
#include "Minigui.ch"
#include "winprint.ch"

nomepdf='BOLETO_'+ntrim(numero_boleto)+'.pdf'        //  se utilizar PrimoPDF para capturar impressao e gerar PDF 
exibe_multipdf2(nomepdf,path)   

If ! File("nomepdf.TXT")
BEGIN INI FILE "nomepdf.TXT"
	SET SECTION "nomepdf"            ENTRY "nomepdf"    To nomepdf
	SET SECTION "numero_x"           ENTRY "numero_x"   To numero_boleto
END INI
EndIf

BEGIN INI FILE "nomepdf.TXT"
	SET SECTION "nomepdf"           ENTRY "nomepdf"   To nomepdf
    SET SECTION "numero_x"          ENTRY "numero_x"  To numero_boleto
END INI




			
IF printPV
   SELECT PRINTER printX TO lSuccess PREVIEW
ELSE   
   SELECT PRINTER printX TO lSuccess
Endif   
   
//IF lSuccess == .T. 
   START PRINTDOC NAME nomePdf 
        START PRINTPAGE   

///  controle
         linha=1 
         boleto_mascara2()
         @ 5+linha,160 PRINT 'Controle Interno' TO 10+linha,200 RIGHT FONT "Arial"  SIZE 11  COLOR BLACK   
****    @ 5+linha,72 PRINT mRNCB TO 10+linha,205 RIGHT FONT "Arial" SIZE 12 COLOR BLACK          //   representacao cod barra 

///  recibo do safado         
         linha=95 
         FOR a=5 TO 205  
             @ linha-1,a PRINT '-' FONT "Arial"  SIZE 6  COLOR BLACK 
         NEXT a 
         boleto_mascara2() 
         @ 6+linha,150 PRINT 'Recibo do Sacado' TO 10+linha,200 RIGHT FONT "Arial"  SIZE 11  COLOR BLACK    

//  ficha de compensa��o          
         linha=180                                             
         FOR a=5 TO 205  
             @ linha-1,a PRINT '-' FONT "Arial"  SIZE 6  COLOR BLACK 
         NEXT a 
         boleto_mascara2() 
         @ 5+linha,72 PRINT mRNCB TO 10+linha,205 RIGHT FONT "Arial" SIZE 12 COLOR BLACK          //   representacao cod barra

 
         @ 83+linha,170 PRINT ' - Ficha de compensa��o' FONT "Arial"  SIZE 6  COLOR BLACK       

         //  mCDBR    codigo de barra para o banco
         
         coluna:=6
         largura:=4.55 
         
         @ 85+linha,coluna PRINT IMAGE path+'\cstart.gif' WIDTH largura HEIGHT 14 STRETCH 
       *  @ 80+linha,coluna PRINT IMAGE path+'\cstart.gif' WIDTH largura HEIGHT 14 STRETCH 
         
         X=0 ; coluna+=largura 
         FOR X := 1 TO LEN(mCDBR) STEP 2
            nGIF=SUBSTR(mCDBR,x,2)
            nomeGif:=path+'\code'+nGIF+'.gif'
            *@ 80+linha,coluna PRINT IMAGE nomeGif WIDTH largura HEIGHT 14 STRETCH 
			@ 85+linha,coluna PRINT IMAGE nomeGif WIDTH largura HEIGHT 14 STRETCH 
      
            coluna+=largura 
         NEXT X
         @ 85+linha,coluna PRINT IMAGE path+'\cstop.gif' WIDTH largura HEIGHT 14 STRETCH 
          END PRINTPAGE
   END PRINTDOC 
//Endif 





RETURN




Static Function anexapdf()
local xnome
local xnumero

BEGIN INI FILE ('nomepdf.TXT')
   GET xnome   SECTION "nomepdf"               ENTRY "nomepdf"
   GET xnumero SECTION "numero_x"              ENTRY "numero_x"
END INI


ccQuery:="select NOSSONUMERO FROM boleto WHERE numero	= " + (xnumero)         
oQuery :=oServer:Query( ccQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATEN��O")
      Return Nil
    EndIf

oRow  :=oQuery:GetRow(1)
c_nome:=oRow:fieldGet(1)
  If !Empty(c_nome) 
   cQuery	:= oServer:Query( "UPDATE boleto SET ARQUIVOPDF='"+ALLTRIM(MaskBinData(MemoRead(xnome)))+"' WHERE numero = " +((xnumero)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
  endif
else
EndIf
Return

**************************** alterado por Malc Inform�tica em 19/08/2010 ******
Function boleto_mascara2()
#include "Minigui.ch"
#include "winprint.ch"

IF FILE(mLGBC) 
   @ 2+linha,10 PRINT IMAGE mLGBC WIDTH 28 HEIGHT 7
ELSE   
   @ 4+linha,10 PRINT Nome_banco FONT "Arial"  SIZE 14  COLOR BLACK      
Endif   
 @ 3+linha,50 PRINT Cod_banco TO 10+linha,71 CENTER FONT "Arial"  SIZE 18  COLOR BLACK   

@ 4+linha,49 PRINT LINE TO 10+linha,49 PENWIDTH 0.3   // |  
@ 4+linha,72 PRINT LINE TO 10+linha,72 PENWIDTH 0.3   // |   

@ 10+linha,10 PRINT LINE TO 10+linha,205 PENWIDTH 0.3    //- 
@ 10+linha,10 PRINT 'Local de Pagamento' FONT "Arial"  SIZE 6  COLOR BLACK
@ 10+linha,146 PRINT 'Vencimento' FONT "Arial"  SIZE 6  COLOR BLACK 

@ 14+linha,10 PRINT mLCPG FONT "Arial"  SIZE 8  COLOR BLACK        //pagavel .... 
@ 12+linha,146 PRINT xDTVC TO 18+linha,195 RIGHT FONT "Arial"  SIZE 12  COLOR BLACK      // data vcto 
 
@ 19+linha,10 PRINT LINE TO 19+linha,205 PENWIDTH 0.2    //-   
@ 19+linha,10 PRINT 'Cedente' FONT "Arial"  SIZE 6  COLOR BLACK 
@ 19+linha,146 PRINT 'Ag�ncia/C�digo Cedente' FONT "Arial"  SIZE 6  COLOR BLACK  
 
@ 21+linha,10 PRINT mNMCD+'     -     '+ Trans(mCGCD,'@R 99.999.999/9999-99')  FONT "Arial"  SIZE 8  COLOR BLACK    
**************************** alterado por Malc Inform�tica em 13/08/2010 ******
Codcedente:=(c_Cod_cedente)
@ 21+linha,146 PRINT agencia1 + [/]+ntrim(Codcedente) TO 25+linha,195 RIGHT FONT "Arial"  SIZE 8  COLOR BLACK    // 
*******************************************************************************

@ 25+linha,45 PRINT LINE TO 37+linha,45 PENWIDTH 0.2   // |      
@ 31+linha,60 PRINT LINE TO 37+linha,60 PENWIDTH 0.2   // |      
@ 25+linha,75 PRINT LINE TO 37+linha,75 PENWIDTH 0.2   // |      
@ 25+linha,95 PRINT LINE TO 31+linha,95 PENWIDTH 0.2   // |      
@ 25+linha,115 PRINT LINE TO 37+linha,115 PENWIDTH 0.2   // |      
@ 10+linha,145 PRINT LINE TO 67+linha,145 PENWIDTH 0.2   // |      

@ 25+linha,10 PRINT LINE TO 25+linha,205 PENWIDTH 0.2    //-   
@ 25+linha,10 PRINT 'Data do Documento' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,46 PRINT 'N�mero do Documento' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,76 PRINT 'Esp�cie Doc.' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,96 PRINT 'Aceite' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,116 PRINT 'Data do Processamento' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,146 PRINT 'Nosso N�mero' FONT "Arial"  SIZE 6  COLOR BLACK   

@ 27+linha,10 PRINT mHoje TO 31+linha,45 CENTER FONT "Arial"  SIZE 8  COLOR BLACK      // 
@ 27+linha,45 PRINT Num_doc  TO 31+linha,75 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,75 PRINT especie  TO 31+linha,95 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,95 PRINT 'N�O'  TO 31+linha,115 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,115 PRINT mDTPC TO 31+linha,145 CENTER FONT "Arial"  SIZE 8  COLOR BLACK  
@ 27+linha,146 PRINT mNSNM TO 31+linha,195 RIGHT FONT "Arial"  SIZE 8  COLOR BLACK     
 
@ 31+linha,10 PRINT LINE TO 31+linha,205 PENWIDTH 0.2    //-   
//@ 34+linha,145 PRINT LINE TO 34+linha,205 PENWIDTH 6 COLOR GRAY      // 
@ 31+linha,10 PRINT 'Uso do Banco' FONT "Arial"  SIZE 6  COLOR BLACK    
@ 31+linha,46 PRINT 'Carteira' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,61 PRINT 'Esp�cie' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,76 PRINT 'Quantidade' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,116 PRINT '(x) Valor' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,146 PRINT '( = ) Valor do Documento' FONT "Arial"  SIZE 6  COLOR BLACK     

@ 33+linha,45 PRINT Carteira  TO 37+linha,60 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 33+linha,60 PRINT 'R$'   TO 37+linha,75 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 32+linha,146 PRINT transform(round(val(cValor)/100,2),"@ZE 999,999,999.99")  TO 37+linha,195 RIGHT  FONT "Arial"  SIZE 12  COLOR BLACK     

@ 37+linha,10 PRINT LINE TO 37+linha,205 PENWIDTH 0.2    //-   
@ 37+linha,10 PRINT 'Instrucoes ( Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente ) ' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 37+linha,146 PRINT '( - ) Desconto/Abatimento' FONT "Arial"  SIZE 6  COLOR BLACK     

@ 41+linha,10 PRINT aLNIT[1] FONT "Arial"  SIZE 8  COLOR BLACK     
@ 44+linha,10 PRINT aLNIT[2] FONT "Arial"  SIZE 8  COLOR BLACK      
@ 47+linha,10 PRINT aLNIT[3] FONT "Arial"  SIZE 8  COLOR BLACK      
@ 50+linha,10 PRINT aLNIT[4] FONT "Arial"  SIZE 8  COLOR BLACK       
@ 53+linha,10 PRINT aLNIT[5] FONT "Arial"  SIZE 8  COLOR BLACK       
@ 56+linha,10 PRINT aLNIT[6] FONT "Arial"  SIZE 8  COLOR BLACK       
@ 59+linha,10 PRINT aLNIT[7] FONT "Arial"  SIZE 8  COLOR BLACK       

 
@ 43+linha,145 PRINT LINE TO 43+linha,205 PENWIDTH 0.2    //-   

@ 49+linha,145 PRINT LINE TO 49+linha,205 PENWIDTH 0.2    //-   
@ 49+linha,146 PRINT '( + ) Mora/Multa' FONT "Arial"  SIZE 6  COLOR BLACK       

@ 55+linha,145 PRINT LINE TO 55+linha,205 PENWIDTH 0.2    //-   

@ 61+linha,145 PRINT LINE TO 61+linha,205 PENWIDTH 0.2    //-   
@ 61+linha,146 PRINT '( = ) Valor Cobrado' FONT "Arial"  SIZE 6  COLOR BLACK       

@ 67+linha,10 PRINT LINE TO 67+linha,205 PENWIDTH 0.3    //-  
@ 67+linha,10 PRINT 'Sacado' FONT "Arial"  SIZE 6  COLOR BLACK       

@ 80+linha,10 PRINT 'Sacador/Avalista' FONT "Arial"  SIZE 6  COLOR BLACK        
@ 83+linha,10 PRINT LINE TO 83+linha,205 PENWIDTH 0.3    //-  
@ 83+linha,146 PRINT 'Autentica��o mec�nica' FONT "Arial"  SIZE 6  COLOR BLACK        
@ 68+linha,30 PRINT Sacado FONT "Arial"  SIZE 9  COLOR BLACK  
     
IF BOLETO->TIPO='J'    
    @ 68+linha,150 PRINT 'CNPJ: '+Trans(XCGC ,'@R 99.999.999/9999-99')  FONT "Arial"  SIZE 9  COLOR BLACK  
ELSEIF BOLETO->TIPO='I'
    @ 68+linha,150 PRINT 'CNPJ: '+Trans(XCGC ,'@R 99.999.999/9999-99')  FONT "Arial"  SIZE 9  COLOR BLACK  
ELSEIF BOLETO->TIPO='P'
   @ 68+linha,150 PRINT 'CPF: '+Trans(xcgc,'@R 999.999.999-99') FONT "Arial"  SIZE 9  COLOR BLACK  
ELSEIF BOLETO->TIPO='F'
   @ 68+linha,150 PRINT 'CPF: '+Trans(xcgc,'@R 999.999.999-99') FONT "Arial"  SIZE 9  COLOR BLACK  
Endif   
@ 72+linha,30 PRINT Endereco+ boleto->CLINUMERO FONT "Arial"  SIZE 9  COLOR BLACK        
@ 76+linha,30 PRINT cep+'  -  '+Bairro+'  -  '+Cidade+'  -  '+Uf FONT "Arial"  SIZE 9  COLOR BLACK        
RETURN

 
FUNCTION exibe_multipdf2(cNome,cDir)   
PUBL dircrm:=root 
nomepdf:=dirpdf+cNome

*************************************************************************


diratual=cDir 
nLen := ADIR(nomepdf+"*")
IF nLen=0
   xx=nomepdf+'.pdf'
 // nao_encontrou(xx) 
ELSEIF nLen=1 
 
 nomepdf=nomepdf+'-00.pdf' 
   ShellExecute(0, "open", nomepdf , , ,1 ) 
ELSEIF nLen>1  
   exibe_multipdf_selecao2()
 ENDIF   

 

 
RETURN



FUNCTION nao_encontrou2(tt)
msgInfo(PADR('Registro n�o encontrado',50),tt)
RETURN

FUNCTION erro_consistencia2(tt)
msginfo(PADR('Erro de consistencia do registro, tarefa abortada',50),tt)
RETURN


FUNCTION exibe_multipdf_selecao2() 
aName := Array(nLen)
ADIR(nomepdf+'*', aName)
  
ww=300 
wh=170

   DEFINE WINDOW wPdfFile  ;
      AT 0,0 ;
      WIDTH ww HEIGHT wh ;
	  TITLE STR(crm->numero) ;
      MODAL ;
      NOSIZE ;
      ON INIT wPdfFile_init2()
 
      @ 10,10 GRID arquivos WIDTH ww-25 HEIGHT wh-50   ; 
        HEADERS { 'Arquivo' } ; 
        WIDTHS { ww-30 }     ;
        ON DBLCLICK ( exibe_multipdf_este2() )  
                                       
 
   END WINDOW
   wPdfFile.center 
   wPdfFile.activate  
RETURN


FUNCTION exibe_multipdf_este2
linhagrid = ( wPdfFile.arquivos.Item ( wPdfFile.arquivos.value ) )   
cArquivo=linhagrid[1]
IF EMPTY(diratual) 
   carquivo=dirpdf+carquivo
ELSE
   carquivo=dirpdf+diratual+carquivo
ENDIF 
ShellExecute(0, "open", cArquivo , , ,1 ) 

MSGINFO("OO")


RETURN

FUNCTION wPdfFile_init2
wPdfFile.arquivos.DeleteAllItems 
FOR i = 1 TO nLen 
    wPdfFile.arquivos.AddItem ( { aName[i] } )
NEXT 
RETURN





Function Int252( cCode )

    Local n,cBar:="", cIz:="",cDer:="",nLen:=0,nCheck:=0,cBarra:=""
    Local m
	local B_Inicio:="0000"
	local aBar:={ "00110","10001","01001","11000","00101","10100","01100","00011","10010","01010"}
    local B_Fim:="100"
    lMode := .f.
    cCode := Transform(cCode,"@9")
    if (nLen%2=1.and.!lMode)
       nLen++
       cCode+="0"
    end
    if lMode
       for n:=1 to len(cCode) step 2
           nCheck+=val(substr(cCode,n,1))*3+val(substr(cCode,n+1,1))
       next
       cCode += right(str(nCheck,10,0),1)
    EndIf
    nLen:=len(cCode)
    cBarra:= B_Inicio
    For n := 1 to nLen Step 2
        cIz  := aBar[ val( substr( cCode, n,1   ) ) + 1 ]
        cDer := aBar[ val( substr( cCode, n+1,1 ) ) + 1 ]
        For M:=1 to 5
            cBarra += SubStr( cIz, m, 1 ) + SubStr( cDer, m, 1 )
        Next
    Next
    cBarra += B_Fim
    For n := 1 To Len( cBarra ) Step 2
        If SubStr( cBarra, n, 1 ) = "1"
            cBar += "111"
        Else
            cBar += "1"
        EndIf
        If SubStr( cBarra, n+1, 1 ) = "1"
            cBar += "000"
        Else
            cBar += "0"
        EndIf
    Next
Return( cBar )


Function mostra_linha2()

aLnit:=array(7)  
alnit[1]:=boleto->inst01
alnit[2]:=boleto->inst02
alnit[3]:=boleto->inst03
alnit[4]:=boleto->inst04
alnit[5]:=boleto->inst05
alnit[6]:=""// padroes->bol_linha6        
alnit[7]:=""  //padroes->bol_linha7

c_COD_BANCO       :=boleto->banco                  //banco    numero banco N3
C_dv_bamco        :=boleto->dv_banco               //banco    digito nbanco C1
c_Nome_banco      :=ALLTRIM(boleto->nome_banco)    //banco    nome banco C15
c_agencia         :=boleto->agencia                //banco    agencia N4
c_Dv_Agencia      :=boleto->dv_agencia             //banco    digito agencia C1
c_Cod_cedente     :=(boleto->cod_cedent)             //banco    conta N8
c_Dv_cedente      :=boleto->dv_cedent             //banco    digito conta C1
Moeda             :="9" //tipo da moeda 9= R$
c_Modalidade      :=01 //modalidade
mNMCD           :=ALLTRIM(boleto->m_cedente)     //  Cedente  C50
mCGCD           :=ALLTRIM(boleto->CNPJ)          //  cnpj do cedente   C18
mDTDC           :=boleto->data                   //  data do documento   D 
Num_doc         :=boleto->CONTROLE   
*Num_doc         :=boleto->docto                  //  numero do docto NF N6
especie         :=boleto->especie                //  especie/tipo  do docto C2
mACDC           :='N'                            //  aceite  C1
mDTPC           :=boleto->dtproc                 //  data do processamento   D
c_nosso_numero    :=boleto->numero                 //  nosso numero N8
Carteira        :=1                              //  carteira cobranca N3
Quantidade      :=1                              //  quantidade  N3
mVRMD           :=1                              //  valor da moeda  N9,2
c_Valor          :=boleto->valor                  //  valor N12,2
Vencimento     :=boleto->vcto                   //  Data vcto D
Sacado         :=boleto->m_sacado               //  Sacado   C50
Endereco       :=boleto->endereco               //  endereco sacado C50
Bairro         :=ALLTRIM(boleto->bairro)        //  bairro sacado C20
Cidade         :=ALLTRIM(boleto->cidade)        //  Cidade do Sacado   C20 
uf             :=boleto->estado                 //  estado do Sacado   C2
Cep            :=boleto->cep                    //  CEP sacado  C9
Cnpj           :=boleto->cgc                    //  CPF / CNPJ sacado C18
*parcela        :="001"
parcela        :=boleto->PARC

mLGBC:=PATH+'\sicooblogo.gif'
mDTBS:=ctod("07/10/1997") //   data base pata dias a vencer
mHOJE:=SUBSTR(DTOC(DATE()),1,6)+STR(YEAR(DATE()),4) 
/////////////////////////////////////////////////////
// Rotina de cria��o dos campos e visualiza��o do codigo de barras
//////////////////////////////////////////////////////////////////

public mLCPG,mNSNM,mDGNN,mCPLV,mCDBR,mDGCB,mRNCB,mFTVC,mC1RN,mC2RN,mC3RN,mC4RN,mC5RN
Cod_banco   :=strzero(c_Cod_banco,3)
agencia     :=strzero(c_agencia,4) // c�digo da ag�ncia
Cod_cedente :=strzero(c_Cod_cedente, 10)    // conta corrente
nosso_numero:=strzero(c_nosso_numero,7)
mLCPG:= [PAG�VEL PREFERENCIALMENTE NAS COOPERATIVAS DE CR�DITO DO SICOOB]
Carteira:= [1]                  // c�digo da carteira: 1 (A - Simples)
mPOCD:= [02]                 // INCLUIR AQUI O CODIGO DO POSTO CEDENTE OU UNIDADE DE ATENDIMENTO
Modalidade:= [01]                  // c�digo referente ao tipo de cobran�a: 1 - com Registro, 3 - Sem Registro

  // Num_doc:= nosso_numero
   mFTVC:=strzero(Vencimento-mDTBS,4)
   Valor:=strzero(c_Valor*100,10)
   xDTVC:=SUBSTR(DTOC(Vencimento),1,6)+STR(YEAR(Vencimento),4)       
   Vencimento:=dtoc(Vencimento)        
   aLnit:=Iif(ischaracter(aLNIT),{aLNIT,"","","","","",""},aLNIT)
//
// Monta Nosso N�mero (p/ Banco)
//
   
agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
cValor:=strzero(c_Valor*100,10)

   
   * C�lculo do Fator de Vencimento 
    mFTVC:= strzero((CTOD(Vencimento) - CTOD([03/07/2000])) + 1000, 4)
    mCDEM:= [3]
    mDGNN:=gerar_dv(teste)
    mNSNM:= Substr(str(year(mDTDC), 4), 3, 2) + [/] + mCDEM + nosso_numero + [-] + mDGNN
    mNSNM= nosso_numero + [-] + mDGNN
    oform_boleto.txt_nossogerado.value:=mNSNM   
	
//////////////////////////////////////////////////////////////////////
// Monta Campo Livre do C�digo de Barras e Linha Digit�vel (p/ Banco) == mCPLV
///////////////////////////////////////////////////////////////////////
// sicoob
 If val(cValor) # 0
   cFiller:= [10]
   Else
   cFiller:= [00]
 Endif
    Cod_cedente:=VAL(Cod_cedente)
    mCPLV:= modalidade + STRZERO(Cod_cedente,7) + substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
	oform_boleto.txt_campolivre.VALUE:=mCPLV
    Cod_cedente:=STR(Cod_cedente)
* msginfo(mCPLV)
///////////////////////////////////////////
// Monta C�digo de Barras (p/ Banco)
//////////////////////////////////////////

agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
 

 gdv_barras:=cod_banco+moeda+mFTVC+cvalor+carteira+agencia1+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
*gdv_barras:=cod_banco+moeda+mFTVC+valor+carteira+agencia+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
dbbarras:=gerar_dv_barra(gdv_barras)
mDGCB:=dbbarras
mCDBR:=cod_banco+moeda+mDGCB+mFTVC+cvalor+carteira+agencia1+mCPLV 

///////////////////////////////////////////////////////
// Monta Representa��o N�merica do C�digo de Barras
/////////////////////////////////////////////////////////
mC1RN:=Cod_banco+moeda+carteira+agencia1
mC1RN+=blq_dg102(Cod_banco,mC1RN)
mC2RN:=substr(mCPLV,1,10)
mC2RN+=blq_dg102(Cod_banco,mC2RN)
mC3RN=substr(mCPLV,11,20)
*MSGINFO([5 digito] +mC3RN)
mC3RN=blq_dg102(Cod_banco,mC3RN)
*MSGINFO([5 digito] +mC3RN)
mC3RNA=substr(mCPLV,11,5)
*MSGINFO([5 digito] +mC3RNA)
mC3RN1=substr(mCPLV,16,1)
*MSGINFO([dv] +mC3RN1)
mC3RN1+=mDGNN+parcela+mC3RN
mC3RN:=mC3RN1
*MSGINFO(mC3RN)
mC4RN:=mDGCB
mC5RN:=mFTVC+strzero(val(cvalor),10)
     *              1                         2                            3                       4                          5                        6                     7            8
   mRNCB:= substr(mC1RN, 1, 5) + [.] + substr(mC1RN, 6) + [ ] + substr(mC2RN, 1, 5) + [.] + substr(mC2RN, 6)+ [ ] + mC3RNA + [.] + mC3RN1+ [ ] + mC4RN + [ ] + mC5RN
    oform_boleto.txt_linhadigitavel.value := mRNCB
   oform_boleto.txt_codigobarras.value   := mCDBR
   oform_boleto.txt_binarios.value       := Int252(oform_boleto.txt_codigobarras.value)
return




//*********************************  
STATIC Function pesq_BOLETO2()
//**********************************
Local cQuery      
Local oQuery      
xnumero    :=ntrim(oform_boleto.txt_nossonumero.value)
Xnsnumero  :=alltrim(oform_boleto.txt_nossogerado.value)

 cQuery:= "select cod_cli FROM BOLETO WHERE NUMERO= " +(Xnsnumero)         

 oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
     MsgStop(oQuery:Error())
//   Form_PDV.Text_CODBARRA.setfocuS
   Return .f.
 EndIf

oRow:= oQuery:GetRow(1)

//Form_PDV.Text_CODBARRA.value  :=VAL(oRow:fieldGet(1))
//Form_PDV.txdescri.value       :=oRow:fieldGet(2)
  
If !Empty(oRow:fieldGet(1)) 
 * MsgInfo("C�digo N�o Enntrado: " , "ATEN��O")
    Return .f.
    else
 //  MsgInfo("C�digo N�o Enntrado: " , "ATEN��O")
	* MsgStop(HB_OEMTOANSI('O Campo Quantidade est� vazio','Aten��o'))
  //   Form_PDV.Text_CODBARRA.setfocuS  
 //Return .f.
guarda_boleto2()
*MsgInfo("JA : " , "ATEN��O")

EndIf
 
oQuery:Destroy()

//wn_mudatamanho()
//ZERATAMANHO()

Return Nil           


Function guarda_boleto2()


MSGINFO(ALLTRIM(MaskBinData(MemoRead(nomepdf))))

                       xnumero    :=ntrim(oform_boleto.txt_nossonumero.value)
					   xcod_cli   :=ntrim(oform_boleto.textBTN_cliente.value)
				       xcontrole  :=alltrim(oform_boleto.txt_documento.value)
					   xbanco     :=alltrim(oform_boleto.txt_banco.value)
					   xagencia   :=alltrim(oform_boleto.txt_agencia.value)
	                   xcod_cedent:=alltrim(oform_boleto.txt_cod_cedente.value)
                       Xnome_banco:="SICCOB 756"
					   XSACADO    :=alltrim(oform_boleto.txt_sacado.value)
					   Xcedente   :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       XVCTO      :=DTOS(oform_boleto.txt_vencimento.value)
			           XCGC       :=alltrim(oform_boleto.txt_CPF.value)
					   XVALOR     :=NTRIM(oform_boleto.txt_VALOR.value)
					   XCNPJ      :="84712611000152"
					   XCIDADE    :=alltrim(oform_boleto.txt_CIDADE.value)
	                   XESTADO    :=alltrim(oform_boleto.txt_ESTADO.value)
	                   XENDERECO  :=alltrim(oform_boleto.txt_endereco.value)
	                   XBAIRRO    :=alltrim(oform_boleto.txt_BAIRRO.value)
	                   XCEP       :=alltrim(oform_boleto.txt_CEP.value)
					   Xnsnumero  :=alltrim(oform_boleto.txt_nossogerado.value)
					   Xdata      :=dtos(date())
					   
/*	
cQuery := "INSERT INTO boleto (numero,cod_cli,controle,banco,agencia,cod_cedent,NOME_BANCO,M_SACADO,M_CEDENTE,VCTO,CGC,CNPJ,VALOR,CIDADE,ENDERECO,ESTADO,BAIRRO,CEP,data,nsnumero)  VALUES ('"+xnumero+"','"+xcod_cli+"','"+xcontrole+"','"+xbanco+"','"+xagencia+"','"+xcod_cedent+"','"+xNOME_BANCO+"','"+XSACADO+"','"+XCEDENTE+"','"+XVCTO+"','"+XCGC+"','"+XCNPJ+"','"+XVALOR+"','"+XCIDADE+"','"+XENDERECO+"','"+XESTADO+"','"+XBAIRRO+"','"+XCEP+"','"+Xdata+"','"+Xnsnumero+"')" 

oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 MsgInfo("Por Favor Selecione o registro ") 
Endif		
*/
  cQuery := "UPDATE CONTA SET SEQ_BOL ='"+(xnumero)+"'"
   oQuery:=oServer:Query( cQuery )
   If oQuery:NetErr()
   MsGInfo("linha 1349  " + oServer:Error() )
Endif						
RETURN



//===========================================================================//
//                                                                           //
// Retorna D�gito de Controle M�dulo 10                                      //
//                                                                           //
//===========================================================================//
static function BLQ_DG10(Cod_banco,mNMOG)
local mVLDG,mSMMD,mCTDG,mRSDV,mDCMD
mSMMD:=0
for mCTDG:=1 to len(mNMOG)
   mVLDG:=val(substr(mNMOG,len(mNMOG)-mCTDG+1,1))*Iif(mod(mCTDG,2)==0,1,2)
   mSMMD+=mVLDG-Iif(mVLDG>9,9,0)
endfor
mRSDV:=mod(mSMMD,10)
mDCMD:=Iif(mRSDV==0,"0",str(10-mRSDV,1))
return mDCMD

//===========================================================================//
// Retorna D�gito de Controle M�dulo 11 (p/ Banco)                           //                                                                           //
//===========================================================================//

static Function BLQ_DG110(Cod_banco, mBSDG, mFGCB, mNMOG)
   Local mSMMD:= mRSDV:= mCTDG:= 0, mSQMP:= 2, mDCMD:= []
   
   If mFGCB == Nil
      mFGCB:= .F.
   Endif

   For mCTDG:= 1 to len(mNMOG)
       mSMMD+= val(substr(mNMOG, len(mNMOG) - mCTDG + 1, 1)) * mSQMP
       mSQMP:= Iif(mSQMP == mBSDG, 2, mSQMP + 1)
   EndFor
   mRSDV:= Int(mod(mSMMD, 11))
If Cod_banco == [756]      // sicoob
      mDCMD:= Iif(mRSDV <= 1 .or. mRSDV >= 10, [1], str(11 - mRSDV, 1))
  Else
      MsgStop([Rotina BLQ_DG11 n�o implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)

*******************************************************************************

**************************** alterado por Malc Inform�tica em 18/08/2010 ******
* Retorna D�gito Verificador do Nosso N�mero - Banco 748 Sicoob
*******************************************************************************
static Function blq_dg11_756_nn(Cod_banco, mBSDG, mNMOG)
   Local mCTDG:= 1, mSMMD:= mRSDV:= 0, mSQMP:= 2, mDCMD:= []
  For mCTDG:= 1 to len(mNMOG)
          mSMMD+= val(substr(mNMOG, len(mNMOG) - mCTDG + 1, 1)) * (mSQMP)
       mSQMP:= Iif(mSQMP == mBSDG, 2, mSQMP + 1)
   endfor
   
   mRSDV:= Int(Mod(mSMMD, 11))
   If Cod_banco == [756]  // Sicoob
      mDCMD:= Iif(mRSDV == 0, [0], Iif((11 - mRSDV) > 9, [0], str(11 - mRSDV, 1)))
   Else
      MsgStop([Rotina BLG_DG11_756_NN n�o implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)


*******************************************************************************


*************************** alterado por jose juca em 20/4/20110 ******
* Retorna D�gito Verificador do Campo Livre - Banco 748 Sicoob
*******************************************************************************
static Function blq_dg11_756_cl(Cod_banco, mBSDG, mNMOG)
   Local mCTDG:= 1, mSMMD:= mRSDV:= 0, mSQMP:= 2, mDCMD:= []
 
   For mCTDG:= 1 to len(mNMOG)
       mSMMD+= val(substr(mNMOG, len(mNMOG) - mCTDG + 1, 1)) * (mSQMP)
       mSQMP:= Iif(mSQMP == mBSDG, 2, mSQMP + 1)
   endfor
   mRSDV:= Int(Mod(mSMMD, 11))
   If Cod_banco == [756]  // Sicoob
      mDCMD:= Iif(mRSDV <= 1, [0], str(11 - mRSDV, 1))
   Else
      MsgStop([Rotina BLG_DG11_756_CL n�o implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)


static FUNCTION bolseq_init()
printPV:=  .F.  
boleto->(dbsetorder(1))   
boleto->(dbgobottom())
boleto->(dbskip(-6))
wbolseq.SELECAO.value:=boleto->(recno())
RETURN 


#include <minigui.ch>   
#include <common.ch> 
 
static FUNCTION wbolseq_confirma()
IF wbolseq.selecao.Itemcount>0 
   wbolseq.statusbar.item(1):='Aguarde, imprimindo boletos'
   nbb=wbolseq.selecao.Itemcount
   FOR nbp=1 to nbb
       linhagrid = wbolseq.selecao.Item ( 1 )
       numero_boleto=VAL(linhagrid[1]) 
       boleto_imprime_hum(numero_boleto,printX)
       wbolseq.selecao.DeleteItem( 1 )
   NEXT nbp
   wbolseq.statusbar.item(1):=''
ELSE
   msgstop('Nenhum boleto foi selecionado','Boleto')
Endif
RETURN


statiC FUNCTION bolseq_selecao_focus 
//wbolseq.beste.enabled:= .F.
//wbolseq.bretira.enabled:=.T.
RETURN

static FUNCTION bolseq_este()
wbolseq.selecao.AddItem ( { STR(boleto->numero), SUBSTR(boleto->M_SACADO,1,55),transform(boleto->VALOR,"@R 999,999.99") } )  
RETURN 

static FUNCTION bolseq_retira()
IF wbolseq.selecao.value>0 
   wbolseq.selecao.DeleteItem(wbolseq.selecao.value)
Endif
RETURN 
 



static function dv_nnumero(dv_nosso) 
   Local cCampo1, cCampo2, cCampo3, cCampo4,dvcampo3
   Local nDv1 := nDv2 := nDv3 := 0 ,vvDv2:=0 	
   Local aDv1[9], aDv2[10], aDv3[10],dvnosso[ 21]
   total1:=0
   resto :=0
   onze  :=11
   dvn:=0
  dv1:= val(substr(dv_nosso,1,1)) 
  dv1:=dv1*3
 dv2:= val(substr(dv_nosso,2,1))
 dv2:=dv2*1

 dv3:= val(substr(dv_nosso,3,1))
 dv3:=dv3*9
* msginfo([t0] +str(dv3)) 
 
 dv4:= val(substr(dv_nosso,4,1))
 dv4:=dv4*7
 * msginfo([t63] +str(dv4)) 
 
 ////////////////
 dv5:= val(substr(dv_nosso,5,1))
 dv5:=dv5*3

 
 dv6:= val(substr(dv_nosso,6,1))
 dv6:=dv6*1

 
 dv7:= val(substr(dv_nosso,7,1))
 dv7:=dv7*9

 
 dv8:= val(substr(dv_nosso,8,1))
 dv8:=dv8*7
  
 //////////////////////
 dv9:= val(substr(dv_nosso,9,1)) 
 dv9:=dv9*3

 
 dv10:= val(substr(dv_nosso,10,1))
 dv10:=dv3*1

 
 dv11:= val(substr(dv_nosso,11,1))
 dv11:=dv11*9

 
 dv12:= val(substr(dv_nosso,12,1))
 dv12:=dv12*7
  
 
 //////////////////////
 dv13:= val(substr(dv_nosso,13,1))
 dv13:=dv13*3

 
 dv14:= val(substr(dv_nosso,14,1))
 dv14:=dv14*1

 
 dv15:= val(substr(dv_nosso,15,1))
 dv15:=dv15*9

 
 dv16:= val(substr(dv_nosso,16,1))
 dv16:=dv16*7
  

 //////////////////////
 dv17:= val(substr(dv_nosso,17,1))
 dv17:=dv17*3

 
 dv18:= val(substr(dv_nosso,18,1))
 dv18:=dv18*1

 
 dv19:= val(substr(dv_nosso,19,1))
 dv19:=dv19*9

 
 dv20:= val(substr(dv_nosso,20,1))
 dv20:=dv20*7
    
 dv21:= val(substr(dv_nosso,21,1))
 dv21:=dv21*3
  
dvn:= 11 - ( Int(mod(total, 11)))
If dvn <= 0 .or. dvn > 9
       dvn:= 1
endif
return transform(dvn,"9")



/////////////////////////////////
static FUNCTION boleto_imprimir()  
////////////////////////////////
local path :=DiskName()+":\"+CurDir()
#include "Minigui.ch"
#include "winprint.ch"
 
nomepdf='BOL'+ALLTRIM(STR(VAL(nosso_numero)))+'.pdf'        //  se utilizar PrimoPDF para capturar impressao e gerar PDF 
                                          //  ja salva arquivo com o nome do nosso numero
exibe_multipdf(nomepdf)
			
exibe_multipdf(nomepdf,path)   
			
IF printPV
   SELECT PRINTER printX TO lSuccess PREVIEW
ELSE   
   SELECT PRINTER printX TO lSuccess
Endif   
   
//IF lSuccess == .T. 
   START PRINTDOC NAME nomePdf 
        START PRINTPAGE   

///  controle
         linha=1 
         boleto_mascara()
         @ 5+linha,160 PRINT 'Controle Interno' TO 10+linha,200 RIGHT FONT "Arial"  SIZE 11  COLOR BLACK   
****    @ 5+linha,72 PRINT mRNCB TO 10+linha,205 RIGHT FONT "Arial" SIZE 12 COLOR BLACK          //   representacao cod barra 

///  recibo do safado         
         linha=95 
         FOR a=5 TO 205  
             @ linha-1,a PRINT '-' FONT "Arial"  SIZE 6  COLOR BLACK 
         NEXT a 
         boleto_mascara() 
         @ 6+linha,150 PRINT 'Recibo do Sacado' TO 10+linha,200 RIGHT FONT "Arial"  SIZE 11  COLOR BLACK    

//  ficha de compensa��o          
         linha=180                                             
         FOR a=5 TO 205  
             @ linha-1,a PRINT '-' FONT "Arial"  SIZE 6  COLOR BLACK 
         NEXT a 
         boleto_mascara() 
         @ 5+linha,72 PRINT mRNCB TO 10+linha,205 RIGHT FONT "Arial" SIZE 12 COLOR BLACK          //   representacao cod barra

 
         @ 83+linha,170 PRINT ' - Ficha de compensa��o' FONT "Arial"  SIZE 6  COLOR BLACK       

         //  mCDBR    codigo de barra para o banco
         
         coluna:=6
         largura:=4.55 
         
         @ 85+linha,coluna PRINT IMAGE path+'\cstart.gif' WIDTH largura HEIGHT 14 STRETCH 
       *  @ 80+linha,coluna PRINT IMAGE path+'\cstart.gif' WIDTH largura HEIGHT 14 STRETCH 
         
         X=0 ; coluna+=largura 
         FOR X := 1 TO LEN(mCDBR) STEP 2
            nGIF=SUBSTR(mCDBR,x,2)
            nomeGif:=path+'\code'+nGIF+'.gif'
            *@ 80+linha,coluna PRINT IMAGE nomeGif WIDTH largura HEIGHT 14 STRETCH 
			@ 85+linha,coluna PRINT IMAGE nomeGif WIDTH largura HEIGHT 14 STRETCH 
      
            coluna+=largura 
         NEXT X
         @ 85+linha,coluna PRINT IMAGE path+'\cstop.gif' WIDTH largura HEIGHT 14 STRETCH 
          END PRINTPAGE
   END PRINTDOC 
//Endif 
RETURN


**************************** alterado por Malc Inform�tica em 19/08/2010 ******
static Function boleto_mascara()
#include "Minigui.ch"
#include "winprint.ch"

IF FILE(mLGBC) 
   @ 2+linha,10 PRINT IMAGE mLGBC WIDTH 28 HEIGHT 7
ELSE   
   @ 4+linha,10 PRINT Nome_banco FONT "Arial"  SIZE 14  COLOR BLACK      
Endif   
 @ 3+linha,50 PRINT Cod_banco TO 10+linha,71 CENTER FONT "Arial"  SIZE 18  COLOR BLACK   

@ 4+linha,49 PRINT LINE TO 10+linha,49 PENWIDTH 0.3   // |  
@ 4+linha,72 PRINT LINE TO 10+linha,72 PENWIDTH 0.3   // |   

@ 10+linha,10 PRINT LINE TO 10+linha,205 PENWIDTH 0.3    //- 
@ 10+linha,10 PRINT 'Local de Pagamento' FONT "Arial"  SIZE 6  COLOR BLACK
@ 10+linha,146 PRINT 'Vencimento' FONT "Arial"  SIZE 6  COLOR BLACK 

@ 14+linha,10 PRINT mLCPG FONT "Arial"  SIZE 8  COLOR BLACK        //pagavel .... 
@ 12+linha,146 PRINT xDTVC TO 18+linha,195 RIGHT FONT "Arial"  SIZE 12  COLOR BLACK      // data vcto 
 
@ 19+linha,10 PRINT LINE TO 19+linha,205 PENWIDTH 0.2    //-   
@ 19+linha,10 PRINT 'Cedente' FONT "Arial"  SIZE 6  COLOR BLACK 
@ 19+linha,146 PRINT 'Ag�ncia/C�digo Cedente' FONT "Arial"  SIZE 6  COLOR BLACK  
 
@ 21+linha,10 PRINT mNMCD+'     -     '+ Trans(mCGCD,'@R 99.999.999/9999-99')  FONT "Arial"  SIZE 8  COLOR BLACK    
**************************** alterado por Malc Inform�tica em 13/08/2010 ******
Codcedente:=(c_Cod_cedente)
@ 21+linha,146 PRINT agencia1 + [/]+ntrim(Codcedente) TO 25+linha,195 RIGHT FONT "Arial"  SIZE 8  COLOR BLACK    // 
*******************************************************************************

@ 25+linha,45 PRINT LINE TO 37+linha,45 PENWIDTH 0.2   // |      
@ 31+linha,60 PRINT LINE TO 37+linha,60 PENWIDTH 0.2   // |      
@ 25+linha,75 PRINT LINE TO 37+linha,75 PENWIDTH 0.2   // |      
@ 25+linha,95 PRINT LINE TO 31+linha,95 PENWIDTH 0.2   // |      
@ 25+linha,115 PRINT LINE TO 37+linha,115 PENWIDTH 0.2   // |      
@ 10+linha,145 PRINT LINE TO 67+linha,145 PENWIDTH 0.2   // |      

@ 25+linha,10 PRINT LINE TO 25+linha,205 PENWIDTH 0.2    //-   
@ 25+linha,10 PRINT 'Data do Documento' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,46 PRINT 'N�mero do Documento' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,76 PRINT 'Esp�cie Doc.' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,96 PRINT 'Aceite' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,116 PRINT 'Data do Processamento' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,146 PRINT 'Nosso N�mero' FONT "Arial"  SIZE 6  COLOR BLACK   

@ 27+linha,10 PRINT mHoje TO 31+linha,45 CENTER FONT "Arial"  SIZE 8  COLOR BLACK      // 
@ 27+linha,45 PRINT Numdoc  TO 31+linha,75 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,75 PRINT especie  TO 31+linha,95 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,95 PRINT 'N�O'  TO 31+linha,115 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,115 PRINT mDTPC TO 31+linha,145 CENTER FONT "Arial"  SIZE 8  COLOR BLACK  
@ 27+linha,146 PRINT mNSNM TO 31+linha,195 RIGHT FONT "Arial"  SIZE 8  COLOR BLACK     
 
@ 31+linha,10 PRINT LINE TO 31+linha,205 PENWIDTH 0.2    //-   
//@ 34+linha,145 PRINT LINE TO 34+linha,205 PENWIDTH 6 COLOR GRAY      // 
@ 31+linha,10 PRINT 'Uso do Banco' FONT "Arial"  SIZE 6  COLOR BLACK    
@ 31+linha,46 PRINT 'Carteira' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,61 PRINT 'Esp�cie' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,76 PRINT 'Quantidade' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,116 PRINT '(x) Valor' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,146 PRINT '( = ) Valor do Documento' FONT "Arial"  SIZE 6  COLOR BLACK     

@ 33+linha,45 PRINT Carteira  TO 37+linha,60 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 33+linha,60 PRINT 'R$'   TO 37+linha,75 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 32+linha,146 PRINT transform(round(val(cValor)/100,2),"@ZE 999,999,999.99")  TO 37+linha,195 RIGHT  FONT "Arial"  SIZE 12  COLOR BLACK     

@ 37+linha,10 PRINT LINE TO 37+linha,205 PENWIDTH 0.2    //-   
@ 37+linha,10 PRINT 'Instrucoes ( Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente ) ' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 37+linha,146 PRINT '( - ) Desconto/Abatimento' FONT "Arial"  SIZE 6  COLOR BLACK     

@ 41+linha,10 PRINT aLNIT[1] FONT "Arial"  SIZE 8  COLOR BLACK     
@ 44+linha,10 PRINT aLNIT[2] FONT "Arial"  SIZE 8  COLOR BLACK      
@ 47+linha,10 PRINT aLNIT[3] FONT "Arial"  SIZE 8  COLOR BLACK      
@ 50+linha,10 PRINT aLNIT[4] FONT "Arial"  SIZE 8  COLOR BLACK       
@ 53+linha,10 PRINT aLNIT[5] FONT "Arial"  SIZE 8  COLOR BLACK       
@ 56+linha,10 PRINT aLNIT[6] FONT "Arial"  SIZE 8  COLOR BLACK       
@ 59+linha,10 PRINT aLNIT[7] FONT "Arial"  SIZE 8  COLOR BLACK       

 
@ 43+linha,145 PRINT LINE TO 43+linha,205 PENWIDTH 0.2    //-   

@ 49+linha,145 PRINT LINE TO 49+linha,205 PENWIDTH 0.2    //-   
@ 49+linha,146 PRINT '( + ) Mora/Multa' FONT "Arial"  SIZE 6  COLOR BLACK       

@ 55+linha,145 PRINT LINE TO 55+linha,205 PENWIDTH 0.2    //-   

@ 61+linha,145 PRINT LINE TO 61+linha,205 PENWIDTH 0.2    //-   
@ 61+linha,146 PRINT '( = ) Valor Cobrado' FONT "Arial"  SIZE 6  COLOR BLACK       

@ 67+linha,10 PRINT LINE TO 67+linha,205 PENWIDTH 0.3    //-  
@ 67+linha,10 PRINT 'Sacado' FONT "Arial"  SIZE 6  COLOR BLACK       

@ 80+linha,10 PRINT 'Sacador/Avalista' FONT "Arial"  SIZE 6  COLOR BLACK        
@ 83+linha,10 PRINT LINE TO 83+linha,205 PENWIDTH 0.3    //-  
@ 83+linha,146 PRINT 'Autentica��o mec�nica' FONT "Arial"  SIZE 6  COLOR BLACK        
@ 68+linha,30 PRINT Sacado FONT "Arial"  SIZE 9  COLOR BLACK       
IF BOLETO->TIPO='J'    
    @ 68+linha,150 PRINT 'CNPJ: '+Trans(XCGC ,'@R 99.999.999/9999-99')  FONT "Arial"  SIZE 9  COLOR BLACK  
ELSEIF BOLETO->TIPO='I'
    @ 68+linha,150 PRINT 'CNPJ: '+Trans(XCGC ,'@R 99.999.999/9999-99')  FONT "Arial"  SIZE 9  COLOR BLACK  
ELSEIF BOLETO->TIPO='P'
   @ 68+linha,150 PRINT 'CPF: '+Trans(xcgc,'@R 999.999.999-99') FONT "Arial"  SIZE 9  COLOR BLACK  
ELSEIF BOLETO->TIPO='F'
   @ 68+linha,150 PRINT 'CPF: '+Trans(xcgc,'@R 999.999.999-99') FONT "Arial"  SIZE 9  COLOR BLACK  
Endif   
@ 72+linha,30 PRINT Endereco+ boleto->CLINUMERO FONT "Arial"  SIZE 9  COLOR BLACK        
@ 76+linha,30 PRINT cep+'  -  '+Bairro+'  -  '+Cidade+'  -  '+Uf FONT "Arial"  SIZE 9  COLOR BLACK        
RETURN


 
static FUNCTION exibe_multipdf(cNome,cDir)   
nomepdf:=dirpdf+cNome
diratual=cDir 
nLen := ADIR(nomepdf+"*")
IF nLen=0
   xx=nomepdf+'.pdf'
  // nao_encontrou(xx) 
ELSEIF nLen=1 
   nomepdf=nomepdf+'-00.pdf' 
   ShellExecute(0, "open", nomepdf , , ,1 ) 
ELSEIF nLen>1  
   exibe_multipdf_selecao()
ENDIF      
RETURN


static FUNCTION exibe_multipdf_selecao() 
aName := Array(nLen)
ADIR(nomepdf+'*', aName)
  
ww=300 
wh=170

   DEFINE WINDOW wPdfFile  ;
      AT 0,0 ;
      WIDTH ww HEIGHT wh ;
      TITLE STR(crm->numero) ;
      MODAL ;
      NOSIZE ;
      ON INIT wPdfFile_init()
 
      @ 10,10 GRID arquivos WIDTH ww-25 HEIGHT wh-50   ; 
        HEADERS { 'Arquivo' } ; 
        WIDTHS { ww-30 }     ;
        ON DBLCLICK ( exibe_multipdf_este() )  
                                       
 
   END WINDOW
   wPdfFile.center 
   wPdfFile.activate  
RETURN


static FUNCTION exibe_multipdf_este 
linhagrid = ( wPdfFile.arquivos.Item ( wPdfFile.arquivos.value ) )   
cArquivo=linhagrid[1]
IF EMPTY(diratual) 
   carquivo=dirpdf+carquivo
ELSE
   carquivo=dirpdf+diratual+carquivo
ENDIF 
ShellExecute(0, "open", cArquivo , , ,1 ) 
RETURN

stAtic FUNCTION wPdfFile_init
wPdfFile.arquivos.DeleteAllItems 
FOR i = 1 TO nLen 
    wPdfFile.arquivos.AddItem ( { aName[i] } )
NEXT 
RETURN





static Function Int25( cCode )

    Local n,cBar:="", cIz:="",cDer:="",nLen:=0,nCheck:=0,cBarra:=""
    Local m
	local B_Inicio:="0000"
	local aBar:={ "00110","10001","01001","11000","00101","10100","01100","00011","10010","01010"}
    local B_Fim:="100"
    lMode := .f.
    cCode := Transform(cCode,"@9")
    if (nLen%2=1.and.!lMode)
       nLen++
       cCode+="0"
    end
    if lMode
       for n:=1 to len(cCode) step 2
           nCheck+=val(substr(cCode,n,1))*3+val(substr(cCode,n+1,1))
       next
       cCode += right(str(nCheck,10,0),1)
    EndIf
    nLen:=len(cCode)
    cBarra:= B_Inicio
    For n := 1 to nLen Step 2
        cIz  := aBar[ val( substr( cCode, n,1   ) ) + 1 ]
        cDer := aBar[ val( substr( cCode, n+1,1 ) ) + 1 ]
        For M:=1 to 5
            cBarra += SubStr( cIz, m, 1 ) + SubStr( cDer, m, 1 )
        Next
    Next
    cBarra += B_Fim
    For n := 1 To Len( cBarra ) Step 2
        If SubStr( cBarra, n, 1 ) = "1"
            cBar += "111"
        Else
            cBar += "1"
        EndIf
        If SubStr( cBarra, n+1, 1 ) = "1"
            cBar += "000"
        Else
            cBar += "0"
        EndIf
    Next
Return( cBar )


static Function mostra_linha()

aLnit:=array(7)  
alnit[1]:=boleto->inst01
alnit[2]:=boleto->inst02
alnit[3]:=boleto->inst03
alnit[4]:=boleto->inst04
alnit[5]:=boleto->inst05
alnit[6]:=""// padroes->bol_linha6        
alnit[7]:=""  //padroes->bol_linha7

c_COD_BANCO       :=boleto->banco                  //banco    numero banco N3
C_dv_bamco        :=boleto->dv_banco               //banco    digito nbanco C1
c_Nome_banco      :=ALLTRIM(boleto->nome_banco)    //banco    nome banco C15
c_agencia         :=boleto->agencia                //banco    agencia N4
c_Dv_Agencia      :=boleto->dv_agencia             //banco    digito agencia C1
c_Cod_cedente     :=(boleto->cod_cedent)             //banco    conta N8
c_Dv_cedente      :=boleto->dv_cedent             //banco    digito conta C1
Moeda             :="9" //tipo da moeda 9= R$
c_Modalidade      :=01 //modalidade
mNMCD           :=ALLTRIM(boleto->m_cedente)     //  Cedente  C50
mCGCD           :=ALLTRIM(boleto->CNPJ)          //  cnpj do cedente   C18
mDTDC           :=boleto->data                   //  data do documento   D 
Numdoc          :=boleto->docto                  //  numero do docto NF N6
especie         :=boleto->especie                //  especie/tipo  do docto C2
mACDC           :='N'                            //  aceite  C1
mDTPC           :=boleto->dtproc                 //  data do processamento   D
c_nosso_numero    :=boleto->numero                 //  nosso numero N8
Carteira        :=1                              //  carteira cobranca N3
Quantidade      :=1                              //  quantidade  N3
mVRMD           :=1                              //  valor da moeda  N9,2
c_Valor          :=boleto->valor                  //  valor N12,2
Vencimento     :=boleto->vcto                   //  Data vcto D
Sacado         :=boleto->m_sacado               //  Sacado   C50
Endereco       :=boleto->endereco               //  endereco sacado C50
Bairro         :=ALLTRIM(boleto->bairro)        //  bairro sacado C20
Cidade         :=ALLTRIM(boleto->cidade)        //  Cidade do Sacado   C20 
uf             :=boleto->estado                 //  estado do Sacado   C2
Cep            :=boleto->cep                    //  CEP sacado  C9
Cnpj           :=boleto->cgc                    //  CPF / CNPJ sacado C18
parcela        :="001"

mLGBC:=PATH+'\sicooblogo.gif'
mDTBS:=ctod("07/10/1997") //   data base pata dias a vencer
mHOJE:=SUBSTR(DTOC(DATE()),1,6)+STR(YEAR(DATE()),4) 
/////////////////////////////////////////////////////
// Rotina de cria��o dos campos e visualiza��o do codigo de barras
//////////////////////////////////////////////////////////////////

public mLCPG,mNSNM,mDGNN,mCPLV,mCDBR,mDGCB,mRNCB,mFTVC,mC1RN,mC2RN,mC3RN,mC4RN,mC5RN
Cod_banco   :=strzero(c_Cod_banco,3)
agencia     :=strzero(c_agencia,4) // c�digo da ag�ncia
Cod_cedente :=strzero(c_Cod_cedente, 10)    // conta corrente
nosso_numero:=strzero(c_nosso_numero,7)


mLCPG:= [PAG�VEL PREFERENCIALMENTE NAS COOPERATIVAS DE CR�DITO DO SICOOB]
Carteira:= [1]                  // c�digo da carteira: 1 (A - Simples)
mPOCD:= [02]                 // INCLUIR AQUI O CODIGO DO POSTO CEDENTE OU UNIDADE DE ATENDIMENTO
Modalidade:= [01]                  // c�digo referente ao tipo de cobran�a: 1 - com Registro, 3 - Sem Registro

   Num_doc:= nosso_numero
   mFTVC:=strzero(Vencimento-mDTBS,4)
   Valor:=strzero(c_Valor*100,10)
   xDTVC:=SUBSTR(DTOC(Vencimento),1,6)+STR(YEAR(Vencimento),4)       
   Vencimento:=dtoc(Vencimento)        
   aLnit:=Iif(ischaracter(aLNIT),{aLNIT,"","","","","",""},aLNIT)
//
// Monta Nosso N�mero (p/ Banco)
//
   
agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
cValor:=strzero(c_Valor*100,10)

   
   * C�lculo do Fator de Vencimento 
    mFTVC:= strzero((CTOD(Vencimento) - CTOD([03/07/2000])) + 1000, 4)
    mCDEM:= [3]
    mDGNN:=gerar_dv(teste)
    mNSNM:= Substr(str(year(mDTDC), 4), 3, 2) + [/] + mCDEM + nosso_numero + [-] + mDGNN
    mNSNM= nosso_numero + [-] + mDGNN
    oform_boleto.txt_nossogerado.value:=mNSNM   
	
//////////////////////////////////////////////////////////////////////
// Monta Campo Livre do C�digo de Barras e Linha Digit�vel (p/ Banco) == mCPLV
///////////////////////////////////////////////////////////////////////
// sicoob
 If val(cValor) # 0
   cFiller:= [10]
   Else
   cFiller:= [00]
 Endif
    Cod_cedente:=VAL(Cod_cedente)
    mCPLV:= modalidade + STRZERO(Cod_cedente,7) + substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
	oform_boleto.txt_campolivre.VALUE:=mCPLV
    Cod_cedente:=STR(Cod_cedente)
* msginfo(mCPLV)
///////////////////////////////////////////
// Monta C�digo de Barras (p/ Banco)
//////////////////////////////////////////

agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
 

 gdv_barras:=cod_banco+moeda+mFTVC+cvalor+carteira+agencia1+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
*gdv_barras:=cod_banco+moeda+mFTVC+valor+carteira+agencia+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
dbbarras:=gerar_dv_barra(gdv_barras)
mDGCB:=dbbarras
mCDBR:=cod_banco+moeda+mDGCB+mFTVC+cvalor+carteira+agencia1+mCPLV 

///////////////////////////////////////////////////////
// Monta Representa��o N�merica do C�digo de Barras
/////////////////////////////////////////////////////////
mC1RN:=Cod_banco+moeda+carteira+agencia1
mC1RN+=blq_dg10(Cod_banco,mC1RN)
mC2RN:=substr(mCPLV,1,10)
mC2RN+=blq_dg10(Cod_banco,mC2RN)
mC3RN=substr(mCPLV,11,20)
*MSGINFO([5 digito] +mC3RN)
mC3RN=blq_dg10(Cod_banco,mC3RN)
*MSGINFO([5 digito] +mC3RN)
mC3RNA=substr(mCPLV,11,5)
*MSGINFO([5 digito] +mC3RNA)
mC3RN1=substr(mCPLV,16,1)
*MSGINFO([dv] +mC3RN1)
mC3RN1+=mDGNN+parcela+mC3RN
mC3RN:=mC3RN1
*MSGINFO(mC3RN)
mC4RN:=mDGCB
mC5RN:=mFTVC+strzero(val(cvalor),10)
     *              1                         2                            3                       4                          5                        6                     7            8
   mRNCB:= substr(mC1RN, 1, 5) + [.] + substr(mC1RN, 6) + [ ] + substr(mC2RN, 1, 5) + [.] + substr(mC2RN, 6)+ [ ] + mC3RNA + [.] + mC3RN1+ [ ] + mC4RN + [ ] + mC5RN
    oform_boleto.txt_linhadigitavel.value := mRNCB
   oform_boleto.txt_codigobarras.value   := mCDBR
   oform_boleto.txt_binarios.value       := Int25(oform_boleto.txt_codigobarras.value)
return




static Function guarda_boleto()


                       xnumero    :=ntrim(oform_boleto.txt_nossonumero.value)
					   xcod_cli   :=ntrim(oform_boleto.textBTN_cliente.value)
				       xcontrole  :=alltrim(oform_boleto.txt_documento.value)
					   xbanco     :=alltrim(oform_boleto.txt_banco.value)
					   xagencia   :=alltrim(oform_boleto.txt_agencia.value)
	                   xcod_cedent:=alltrim(oform_boleto.txt_cod_cedente.value)
                       Xnome_banco:="SICCOB 756"
					   XSACADO    :=alltrim(oform_boleto.txt_sacado.value)
					   Xcedente   :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       XVCTO      :=DTOS(oform_boleto.txt_vencimento.value)
			           XCGC       :=alltrim(oform_boleto.txt_CPF.value)
					   XVALOR     :=NTRIM(oform_boleto.txt_VALOR.value)
					   XCNPJ      :="84712611000152"
					   XCIDADE    :=alltrim(oform_boleto.txt_CIDADE.value)
	                   XESTADO    :=alltrim(oform_boleto.txt_ESTADO.value)
	                   XENDERECO  :=alltrim(oform_boleto.txt_endereco.value)
	                   XBAIRRO    :=alltrim(oform_boleto.txt_BAIRRO.value)
	                   XCEP       :=alltrim(oform_boleto.txt_CEP.value)
					   Xnsnumero  :=alltrim(oform_boleto.txt_nossogerado.value)
					   Xdata      :=dtos(date())
/*					   
	
cQuery := "INSERT INTO boleto (numero,cod_cli,controle,banco,agencia,cod_cedent,NOME_BANCO,M_SACADO,M_CEDENTE,VCTO,CGC,CNPJ,VALOR,CIDADE,ENDERECO,ESTADO,BAIRRO,CEP,data,nsnumero)  VALUES ('"+xnumero+"','"+xcod_cli+"','"+xcontrole+"','"+xbanco+"','"+xagencia+"','"+xcod_cedent+"','"+xNOME_BANCO+"','"+XSACADO+"','"+XCEDENTE+"','"+XVCTO+"','"+XCGC+"','"+XCNPJ+"','"+XVALOR+"','"+XCIDADE+"','"+XENDERECO+"','"+XESTADO+"','"+XBAIRRO+"','"+XCEP+"','"+Xdata+"','"+Xnsnumero+"')" 

fQuery:=oServer:Query(cQuery)
If fQuery:NetErr()												
 MsgStop(fQuery:Error())
 MsgInfo("Por Favor Selecione o registro ") 
 ENDIF
 */
 
   cQuery := "UPDATE CONTA SET SEQ_BOL ='"+(xnumero)+"'"
   fQuery:=oServer:Query( cQuery )
   If fQuery:NetErr()
   MsGInfo("linha 1349  " + oServer:Error() )
Endif				
Return Nil





Static Function Grava_ARQ( WARQ, WTXT )
Local HANDLE, RET := .T.

HANDLE := fcreate(WARQ, FC_NORMAL )
if HANDLE > 0
   fwrite(HANDLE, WTXT + chr(13) + chr(10) )
   RET := (ferror() = 0)

   fclose(HANDLE)
endif

RETURN RET

