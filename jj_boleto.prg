
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

function  j_boleto()


Static aBar:={ "00110","10001","01001","11000","00101","10100","01100","00011","10010","01010"}
Static B_Inicio:="0000"
Static B_Fim:="100"
//Static oForm

REQUEST HB_LANG_PT    

REQUEST DBFCDX
REQUEST DBFFPT 
RDDSETDEFAULT("DBFCDX")

//SET LOGERROR ON

cNumero:=""


abreboleto()

CLOSE ALL 
USE ((ondetemp)+"BOLETO.DBF") new alias BOLETO exclusive  VIA "DBFCDX" 
zap
PACK

abreboleto()
publ path :=DiskName()+":\"+CurDir() 
PUBL printpdf:=GetDefaultPrinter()    //  Free PrimoPdf como virtual printer para criar arquivos PDF    www.primopdf.com  
PUBL printdpx:=GetDefaultPrinter() 
PUBL printmtx:=GetDefaultPrinter() 
PUBL printfax:=GetDefaultPrinter() 
*PUBL printLaser:=GetDefaultPrinter() 
PUBL printX:=GetDefaultPrinter()
PUBL printPV:=.t.
PUBL cInstr		:= ''
PUBL printLaser:="PrimoPDF"
*msginfo(printLaser)


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
  AT 010, 000;
   width Ajanela; 
   height Ljanela-40;
  TITLE "Boleto TESTE SICOOB - Homologação";
  MODAL;
  NOSIZE
   
 ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela


	  
@ 010, 05 LABEL oSay5 Value "Digite Nº NFCE";
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
		           ON enter {||PESQ_PVENDA(),mostra_linha(),oform_boleto.txt_DAV.SETFOCUS}

				  
  
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
          tooltip 'Digite o código ou clique na LUPA para pesquisar';
	      picture cPathImagem+'lupa.bmp';
	      maxlength 4;
	      rightalign;
	      Action {||GetCode_cli(boleto_salva2(),mostra_linha(),oform_boleto.textBTN_cliente.setfocus)};
	      ON enter {||iif(!Empty(oform_boleto.textBTN_cliente.Value),pesqcli(),oform_boleto.textBTN_cliente.setfocus)};
          on gotfocus (CHANGETEXTBTNSTATE(GetControlHandle('textBTN_cliente','oform_boleto'),1),(oform_boleto.textBTN_cliente.backcolor := {255,255,196}))

	      
		  
  ON KEY F8 ACTION { || GetCode_cli(),boleto_salva2(),mostra_linha()} 
  
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
 @ 010, 400 LABEL oSay2 Value "Agência";
      WIDTH 0046 HEIGHT 0013 ;
      FONT "MS Sans Serif" SIZE 0008 
    
   @ 040, 400   TEXTBOX txt_agencia;
      WIDTH  40 HEIGHT 0020 ;
      FONT "Ms Sans Serif" SIZE 008 ;
      Value "3325" ;
      READONLY
////////////////////////

   @ 010, 560 LABEL oSay4 Value "Cód.cedente";
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
	ON enter {||boleto_salva2(),mostra_linha()}
	
//////////////////////////////////////////
  
    @ 95,L1  LABEL  ldata;
	VALUE 'Data Emissão';
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
	ON enter {||boleto_salva2(),mostra_linha()}
      
  
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
	VALUE 'Número';
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
        Value "Nosso nº Gerado";
        WIDTH 0100;
	    HEIGHT 0013 ;
        FONT "MS Sans Serif" SIZE 0008 
	  
       @ 140, L1+550 label txt_nossogerado;
        autosize;
	    font "ms sans serif" size 008
		  
//////////////////////////////////////////

    @ 190,L1+460  LABEL lvalor;
	VALUE 'Valor Boleto';
	RIGHTALIGN;
	WIDTH 80 ;
	TRANSPARENT
    

    @ 190,t1+480  TEXTBOX  txt_valor;
	HEIGHT 20;
	WIDTH 90 ;
	NUMERIC INPUTMASK '99,9999.99';
	ON enter {||boleto_salva2(),mostra_linha()}
	
////////////////////////////////////////////////////////////////////////// 
    @ 140,L1 LABEL lintrucos ;
	VALUE 'Instruções' ;
	WIDTH 80;
	TRANSPARENT
    
     
    @ 155,L1 TEXTBOX  inst01t;
	HEIGHT 20;
	WIDTH 450;
	VALUE "ATENÇÃO PROTESTAR COM 5 DIAS DE VENCIDO";
	READONLY

	          
    @ 175,L1 TEXTBOX  inst02t;
	HEIGHT 20;
	VALUE "";
	WIDTH 450;
	READONLY
	
    @ 195,L1 TEXTBOX  inst03t;
	HEIGHT 20;
	VALUE "ATENÇÃO NÃO RECEBER VALOR A MENOR";
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

   @ 295,  10 LABEL oSay14 Value "LInha digitável";
      WIDTH 0078 HEIGHT 0013 OF oForm;
      FONT "MS Sans Serif" SIZE 0008
   
   @ 310, 0010      TEXTBOX txt_linhadigitavel;
      WIDTH 602 HEIGHT 0020 OF oForm;
      FONT "Ms Sans Serif" SIZE 008;
      READONLY	   

   @ 0330,  10 LABEL oSay16 Value "Código de barras";
      WIDTH 0086 HEIGHT 0013 OF oForm;
      FONT "MS Sans Serif" SIZE 0008

   @ 350, 0010      TEXTBOX txt_codigobarras;
      WIDTH 602 HEIGHT 0020 OF oForm;
      FONT "Ms Sans Serif" SIZE 008;
      READONLY	   
      
   @ 370,  10 LABEL oSay16x8 Value "Binários";
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
    
	
	 @ 460,L1+450 TEXTBOX  txt_numero;
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
     FONT "MS Sans Serif" SIZE 0008 ACTION ( boleto_multiimpressao()  )  
	 * ,guarda_boleto()
	 *,guarda_boleto()
	 
   @ 530, 0200 BUTTON oBut2 CAPTION "&Imprimir";
      WIDTH 0080 HEIGHT 0024;
	 ACTION  (printPV:= .t., boleto_imprime_hum(boleto->numero,printPdf ) ) 
	
	  
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
	           msgexclamation('Digite o numero da nfce','Atenção')
               oform_boleto.txt_dav.SetFocus
               oform_boleto.txt_dav.VALUE:=0	  
               return(.f.)
           endif

 


 DQuery := oServer:Query( "Select CbdNtfNumero,CbdvNF From NFCE WHERE CbdNtfNumero = "+chave+" Order By CbddEmi" )

If DQuery:NetErr()
  	MsgStop(DQuery:Error())
    MsgInfo("Por Favor verifique linha 573")
    Return Nil
  Endif
  DRow	          :=dQuery:GetRow(1)
  xnum            :=dRow:fieldGet(1)
  xTOTAL_VEN      :=str(dRow:fieldGet(2))
 
  oform_boleto.txt_documento.value:=str(xnum)
	XTOTAL:=0
CREDITO_S:=0
nitem:=0
If !Empty(xnum) 
     else
   MsgInfo("Cupom Não Enntrado: " , "ATENÇÃO")
    oform_boleto.txt_dav.SetFocus
    oform_boleto.txt_dav.VALUE:=0	  
 Return .f.
 EndIf
	             
nValMora := ROUND(val(xTOTAL_VEN)  * 35/ 100, 2)/30
cInstr += " MORA DE R$ " + (Transform(nValMora, "@EB 999,999.99")) + " POR DIA DE ATRAZO"
 		     
			   if (!EOF())
			        boleto->(dbrlock())  
					   boleto->vcto           :=oform_boleto.txt_vencimento.value
                       boleto->data           :=date()
                       boleto->dtproc         :=DATE()
					   boleto->DOCTO          :=ALLTRIM(oform_boleto.txt_documento.VALUE)
					   boleto->numero         :=oform_boleto.txt_nossonumero.VALUE
                       boleto->valor          :=oform_boleto.txt_valor.value
                       boleto->inst01         :="ATENÇÃO PROTESTAR COM 5 DIAS DE VENCIDO"
                       boleto->inst02         :=CcInstr
				       boleto->inst03         :="ATENÇÃO NÃO RECEBER VALOR A MENOR"
		               boleto->inst04         :="" 
                       boleto->inst05         :=""
                       boleto->m_sacado       :=alltrim(oform_boleto.txt_sacado.value)       
                       boleto->endereco       :=alltrim(oform_boleto.txt_endereco.value)      
                       boleto->bairro         :=alltrim(oform_boleto.txt_BAIRRO.value)
                       boleto->cidade         :=alltrim(oform_boleto.txt_CIDADE.value)
                       boleto->estado         :=alltrim(oform_boleto.txt_ESTADO.value)  
                       boleto->cep            :=alltrim(oform_boleto.txt_CEP.value)
                       boleto->cgc            :=alltrim(oform_boleto.txt_CPF.value)
                       boleto->CLINUMERO     :=alltrim(oform_boleto.txt_numero.value)
		               boleto->(dbunlock())
                       boleto->(DBCOMMIT())
			   
			   
			   
			        ELSE
				       boleto->(DBAPPEND())
                       boleto->(dbrlock())  
					   boleto->CONTROLE       :=oform_boleto.txt_documento.value
	   	               boleto->banco          :=val(oform_boleto.txt_banco.value)
		               boleto->vcto           :=date()+20
                       boleto->data           :=date()
                       boleto->dtproc         :=DATE()
                       boleto->agencia        :=val(oform_boleto.txt_agencia.value)
                       boleto->cod_cedent     :=val(oform_boleto.txt_cod_cedente.value) 
                       boleto->numero         :=(oform_boleto.txt_nossonumero.value)
		               boleto->valor          :=val(xTOTAL_VEN) 
                       boleto->inst01         :="ATENCAO PROTESTAR COM 5 DIAS DE VENCIDO"
                       boleto->inst02         :=cInstr
                       boleto->inst03         :="ATENCAO NÃO RECEBER VALOR A MENOR"
                       boleto->inst04         :="" 
                       boleto->inst05         :=""
		               boleto->nome_BANCO     :="SICOOB"
                       boleto->m_cedente      :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       boleto->m_sacado       :=""
                       boleto->endereco       :="" 
                       boleto->cep            :=""
                       boleto->bairro         :=""
                       boleto->cidade         :=oform_boleto.txt_cidade.value
                       boleto->estado         :=""
                       boleto->cgc            :="" 
					   boleto->CLINUMERO      :=""
					   Boleto->cNPJ           :="84712611000152"
					  boleto->(DBCOMMIT())
                     ENDIF		 

 MODIFY CONTROL txt_sacado    OF oform_boleto   Value  ''+TransForm(boleto->m_sacado   ,"@!")
 MODIFY CONTROL txt_endereco  OF oform_boleto   Value  ''+TransForm(boleto->endereco   ,"@!")
 MODIFY CONTROL txt_numero    OF oform_boleto   Value  ''+TransForm( boleto->CLINUMERO ,"@!")
 MODIFY CONTROL txt_cidade    OF oform_boleto   Value  ''+TransForm(boleto->cidade     ,"@!")
 MODIFY CONTROL txt_CEP       OF oform_boleto   Value  ''+TransForm(boleto->cep        ,"@!")
 MODIFY CONTROL txt_bairro    OF oform_boleto   Value  ''+TransForm( boleto->bairro    ,"@!")
 MODIFY CONTROL txt_estado    OF oform_boleto   Value  ''+TransForm(boleto->estado     ,"@!")


oform_boleto.txt_documento.value  :=boleto->controle
*oform_boleto.txt_documento.value  :=oform_boleto.txt_DAV.VALUE
oform_boleto.txt_vencimento.value :=boleto->vcto 
oform_boleto.inst02t.value        :=boleto->inst02 
oform_boleto.txt_valor.value      :=boleto->valor 
*oform_boleto.textBTN_cliente.value:=xCOD_CLI

nChave:=200
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
                oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       := + xxnumero
		        oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	          ENDI
 IF xxtipo='F'                        // pode imprimir?
              	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       :=  xxnumero	
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	       endif
 IF xxtipo='I'                        // pode imprimir?
    	      	oform_boleto.Txt_CPF.value          :=xxcnpj                
				oform_boleto.txt_sacado.value       := xxrazaosoc
                 oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       :=  xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	      endif
 IF xxtipo='P'                        // pode imprimir?
  	          	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       :=  xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
				
				
 endif

boleto_salva2()

return 


//--------------------------------------
STATIC Function GetCode_cli(nValue)
//----------------------------------
local cReg := ''
Local nReg := 1

*Reconectar_A() 

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
            on dblclick {||Find_cli(),boleto_salva2()   }
		  	on change mostradadoscliente()
	END GRID  

	

  @ 650,250 TEXTBOX cSearch ;
    WIDTH 326 ;
    MAXLENGTH 200 ;
    UPPERCASE  ;
    ON ENTER iif( !Empty(form_auto.cSearch.Value), pesq_cli(), form_auto.Grid_22.SetFocus )
	
 	  				   
					   
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

 


//******************************
STATIC Function pesq_cli()
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
oQuery := oServer:Query( "Select codigo,razaosoc,cnpj,ie,cpf,rg,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep,LIMITE From cliente WHERE razaosoc LIKE "+cSearch+" Order By razaosoc" )

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
oQuery := oServer:Query( "Select codigo,razaosoc,cnpj,ie,cpf,rg,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep,LIMITE From cliente WHERE cnpj LIKE "+cSearch+" Order By razaosoc" )
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
STATIC Function pesqcli()
*--------------------------------------------------------------*
Local cQuery      
Local oQuery  
local pCode:=Alltrim(Str(oform_boleto.textBTN_cliente.value))
LOCAL cCInstr :="" 
LOCAL Instr   :=""

 nChave:=pCode
 fQuery:= "Select tipo,cnpj,ie,cpf,rg,razaosoc,endereco,numero, cidade,uf,cod_ibge,codigo,bairro,email,cep,LIMITE From cliente WHERE codigo = " + (nChave)
 
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
 xlimite      :=fRow:fieldGet(16)
 xDATA_VENC   := DaTE()+xlimite 
		 
xxCEP:=limpa(xxCEP)
		
		 		 
 IF xxtipo='J'                        // pode imprimir?
	          	oform_boleto.Txt_CPF.value          :=xxcnpj             
				oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       :=  xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	          ENDI
 IF xxtipo='F'                        // pode imprimir?
              	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value      :=  xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	       endif
 IF xxtipo='I'                        // pode imprimir?
    	      	oform_boleto.Txt_CPF.value          :=xxcnpj             
				oform_boleto.txt_sacado.value       := xxrazaosoc
                 oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value        :=  xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	      endif
 IF xxtipo='P'                        // pode imprimir?
  	          	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       :=  xxnumero
	            oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
  endif
  fQuery:Destroy()	

               if (!EOF())
 	
	boleto_salva2()
	
	
	
			 ELSE
				       boleto->(DBAPPEND())
                       boleto->(dbrlock())  
					   boleto->TIPO           :=xxtipo
					   boleto->COD_CLI        :=xxcodigo
	   	               boleto->banco          :=val(oform_boleto.txt_banco.value)
		               boleto->data           :=date()
                       boleto->dtproc         :=DATE()
					   boleto->vcto           :=xDATA_VENC
					   boleto->numero         :=oform_boleto.txt_nossonumero.VALUE
                       boleto->agencia        :=val(oform_boleto.txt_agencia.value)
                       boleto->cod_cedent     :=val(oform_boleto.txt_cod_cedente.value) 
                       boleto->inst04         :="" 
                       boleto->inst05         :=""
		               boleto->nome_BANCO     :="SICOOB"
                       boleto->m_cedente      :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       boleto->m_sacado       :=oform_boleto.txt_sacado.value
                       boleto->endereco       :=oform_boleto.txt_endereco.value
                       boleto->cep            :=oform_boleto.Txt_CEP.value
                       boleto->bairro         :=oform_boleto.Txt_BAIRRO.value
                       boleto->cidade         :=oform_boleto.txt_cidade.value
                       boleto->estado         :=oform_boleto.Txt_estado.value
                       boleto->cgc            :=oform_boleto.Txt_CPF.value
					   boleto->CLINUMERO      := xxnumero
					   Boleto->cNPJ           :="84712611000152"
                       boleto->(dbunlock())
                       boleto->(DBCOMMIT())
                     ENDIF		 

					 boleto_salva2()
					
RETUR           



 
 
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
				oform_boleto.txt_numero.value       :=  xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	          ENDI
 IF xxtipo='F'                        // pode imprimir?
              	oform_boleto.Txt_CPF.value          :=xxcpf                
			    oform_boleto.txt_sacado.value       := xxrazaosoc
                 oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       :=  xxnumero
                oform_boleto.txt_cidade.value       := xxcidade
	            oform_boleto.Txt_estado.value       := xxuf
				oform_boleto.Txt_BAIRRO.value       :=xxbairro
				oform_boleto.Txt_CEP.value          :=xxcep
	       endif
 IF xxtipo='I'                        // pode imprimir?
    	      	oform_boleto.Txt_CPF.value          :=xxcnpj                
				oform_boleto.txt_sacado.value       := xxrazaosoc
                oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       :=  xxnumero
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
			    oform_boleto.txt_endereco.value     := xxendereco
				oform_boleto.txt_numero.value       :=  xxnumero
				oform_boleto.Txt_CEP.value          :=xxcep
  endif
 

  fQuery:Destroy()	
  
boleto_salva2()

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
FUNCTION boleto_salva2
/////////////////////////////////////////////////
LOCAL cCInstr:=""
	             
nValMora := ROUND((oform_boleto.txt_valor.value)  * 10/ 100, 2)/30
cCInstr += " MORA DE R$ " + (Transform(nValMora, "@EB 999,999.99")) + " POR DIA DE ATRAZO"
   
	            // if (!EOF())
				       boleto->(dbrlock())  
					   boleto->vcto           :=oform_boleto.txt_vencimento.value
                       boleto->data           :=date()
                       boleto->dtproc         :=DATE()
					   boleto->DOCTO          :=ALLTRIM(oform_boleto.txt_documento.VALUE)
					   boleto->numero         :=oform_boleto.txt_nossonumero.VALUE
                       boleto->valor          :=oform_boleto.txt_valor.value
                       boleto->inst01         :="ATENÇÃO PROTESTAR COM 5 DIAS DE VENCIDO"
                       boleto->inst02         :=CcInstr
				       boleto->inst03         :="ATENÇÃO NÃO RECEBER VALOR A MENOR"
		               boleto->inst04         :="" 
                       boleto->inst05         :=""
                       boleto->m_sacado       :=alltrim(oform_boleto.txt_sacado.value)       
                       boleto->endereco       :=alltrim(oform_boleto.txt_endereco.value)      
                       boleto->bairro         :=alltrim(oform_boleto.txt_BAIRRO.value)
                       boleto->cidade         :=alltrim(oform_boleto.txt_CIDADE.value)
                       boleto->estado         :=alltrim(oform_boleto.txt_ESTADO.value)  
                       boleto->cep            :=alltrim(oform_boleto.txt_CEP.value)
                       boleto->cgc            :=alltrim(oform_boleto.txt_CPF.value)
                       boleto->CLINUMERO     :=alltrim(oform_boleto.txt_numero.value)
		               boleto->(dbunlock())
                       boleto->(DBCOMMIT())
				
				

 MODIFY CONTROL txt_sacado    OF oform_boleto   Value  ''+TransForm(boleto->m_sacado   ,"@!")
 MODIFY CONTROL txt_endereco  OF oform_boleto   Value  ''+TransForm(boleto->endereco   ,"@!")
 MODIFY CONTROL txt_cidade    OF oform_boleto   Value  ''+TransForm(boleto->cidade     ,"@!")
 MODIFY CONTROL txt_CEP       OF oform_boleto   Value  ''+TransForm(boleto->cep        ,"@!")
 MODIFY CONTROL txt_bairro    OF oform_boleto   Value  ''+TransForm( boleto->bairro    ,"@!")
 MODIFY CONTROL txt_estado    OF oform_boleto   Value  ''+TransForm(boleto->estado     ,"@!")
 MODIFY CONTROL txt_numero    OF oform_boleto   Value  ''+TransForm( boleto->CLINUMERO ,"@!")


oform_boleto.txt_vencimento.value :=boleto->vcto 
oform_boleto.inst02t.value        :=boleto->inst02 
oform_boleto.txt_valor.value      :=boleto->valor 
RETURN 

 
FUNCTION boleto_multiimpressao
IF ISWINDOWACTIVE(wbolseq)   
   RETURN 
Endif
ww=670
wh=380 
wm=ww/2 
lb=wh-90
PUBL printLaser:="PrimoPDF"

DEFINE WINDOW wbolseq  ; 
    AT 0,0 ;
    WIDTH ww ;
    HEIGHT wh ;
    TITLE "Boleto de Cobrança" ;
    MODAL NOSIZE ;
    ON INIT bolseq_init() ;
    ON RELEASE ( boleto->(dbgotop()) )

    DEFINE STATUSBAR FONT "Arial" SIZE 9    
        STATUSITEM ' ' 
    END STATUSBAR

    @ 10,10 LABEL ldes VALUE 'Boletos disponiveis' FONTCOLOR BLUE WIDTH 150 TRANSPARENT   

   @ 25,10 GRID selecao WIDTH 640 HEIGHT 240   ; 
        HEADERS { 'Número','Sacado','VALOR' }    ; 
        WIDTHS { 60,500,120 }                      ;
	    JUSTIFY { BROWSE_JTFY_RIGHT }      
	   
	   
   aIMP:=Impresoras("PrimoPDF")

   @lb,10 LABEL lprinter ;
           VALUE 'Impresora' ;
           WIDTH 60 HEIGHT 25
           
   @lb,70 COMBOBOX cImpressora ;
            WIDTH 280 ;
            ITEMS aIMP[1] ;
            TOOLTIP 'Impresora' NOTABSTOP   ;
            ON CHANGE  printX:=wbolseq.cImpressora.displayvalue


   @ lb,500   BUTTON bconfirma CAPTION 'Continuar' FLAT  WIDTH 70  HEIGHT 20  ;
                 ACTION ( wwbolseq_confirma() )

   @ lb,580   BUTTON bcancela CAPTION 'Voltar' FLAT  WIDTH 70  HEIGHT 20  ;
                 ACTION ( anexapdf(), wbolseq.release )
  
bolseq_este()
END WINDOW
wbolseq.center
wbolseq.activate
RETURN




Static Function anexapdf()
local xnome
local xnumero

BEGIN INI FILE ('nomepdf.TXT')
   GET xnome   SECTION "nomepdf"               ENTRY "nomepdf"
   GET xnumero SECTION "numero_x"              ENTRY "numero_x"
END INI

//msginfo(xnome)

ccQuery:="select NOSSONUMERO FROM boleto WHERE numero	= " + (xnumero)         
oQuery :=oServer:Query( ccQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
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


//////////////////////////////////////////////
FUNCTION boleto_imprime_hum(nbn,npn)
/////////////////////////////////////////////
//close all
//USE ((path)+"\boleto.DBF") new alias boleto exclusive   
IF npn<>printPdf 
   IF ! msgyesno('Confirma a impressão do boleto',STR(boleto->numero))
      RETURN
  Endif 
Endif 
 
PUBL printLaser:="PrimoPDF"
 
numero_boleto:=nbn
printX:=printLaser
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
c_Cod_cedente     :=(boleto->cod_cedent)             //banco    conta N8
c_Dv_cedente      :=boleto->dv_cedent             //banco    digito conta C1
Moeda             :="9" //tipo da moeda 9= R$
c_Modalidade      :=01 //modalidade
mNMCD           :=ALLTRIM(boleto->m_cedente)     //  Cedente  C50
mCGCD           :=ALLTRIM(boleto->CNPJ)          //  cnpj do cedente   C18
mDTDC           :=boleto->data                   //  data do documento   D 
//Num_doc         :=boleto->docto                  //  numero do docto NF N6
Num_doc         :=boleto->CONTROLE                //  numero do docto NF N6
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
XCGC           :=boleto->cgc                    //  CPF / CNPJ sacado C18
parcela        :="001"

mLGBC:=PATH+'\sicooblogo.gif'
mDTBS:=ctod("07/10/1997") //   data base pata dias a vencer
mHOJE:=SUBSTR(DTOC(DATE()),1,6)+STR(YEAR(DATE()),4) 
/////////////////////////////////////////////////////
// Rotina de criação dos campos e visualização do codigo de barras
//////////////////////////////////////////////////////////////////

public mLCPG,mNSNM,mDGNN,mCPLV,mCDBR,mDGCB,mRNCB,mFTVC,mC1RN,mC2RN,mC3RN,mC4RN,mC5RN
Cod_banco   :=strzero(c_Cod_banco,3)
agencia     :=strzero(c_agencia,4) // código da agência
Cod_cedente :=strzero(c_Cod_cedente, 10)    // conta corrente
nosso_numero:=strzero(c_nosso_numero,7)


mLCPG:= [PAGÁVEL PREFERENCIALMENTE NAS COOPERATIVAS DE CRÉDITO DO SICOOB]
Carteira:= [1]                  // código da carteira: 1 (A - Simples)
mPOCD:= [02]                 // INCLUIR AQUI O CODIGO DO POSTO CEDENTE OU UNIDADE DE ATENDIMENTO
Modalidade:= [01]                  // código referente ao tipo de cobrança: 1 - com Registro, 3 - Sem Registro

 ** Num_doc:= nosso_numero
   mFTVC:=strzero(Vencimento-mDTBS,4)
   Valor:=strzero(c_Valor*100,10)
   xDTVC:=SUBSTR(DTOC(Vencimento),1,6)+STR(YEAR(Vencimento),4)       
   Vencimento:=dtoc(Vencimento)        
   aLnit:=Iif(ischaracter(aLNIT),{aLNIT,"","","","","",""},aLNIT)
//
// Monta Nosso Número (p/ Banco)
//
   
agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
cValor:=strzero(c_Valor*100,10)

   
   * Cálculo do Fator de Vencimento 
    mFTVC:= strzero((CTOD(Vencimento) - CTOD([03/07/2000])) + 1000, 4)
    mCDEM:= [3]
    mDGNN:=gerar_dv(teste)
    mNSNM:= Substr(str(year(mDTDC), 4), 3, 2) + [/] + mCDEM + nosso_numero + [-] + mDGNN
    mNSNM= nosso_numero + [-] + mDGNN
  oform_boleto.txt_nossogerado.value:=mNSNM   
	
//////////////////////////////////////////////////////////////////////
// Monta Campo Livre do Código de Barras e Linha Digitável (p/ Banco) == mCPLV
///////////////////////////////////////////////////////////////////////
// sicoob
 If val(cValor) # 0
   cFiller:= [10]
   Else
   cFiller:= [00]
 Endif
    Cod_cedente:=VAL(Cod_cedente)
    mCPLV:= modalidade + STRZERO(Cod_cedente,7) + substr(mNSNM,1,7)+substr(mNSNM,9,1)+PARCELA
	oform_boleto.txt_campolivre.VALUE:=mCPLV
    Cod_cedente:=STR(Cod_cedente)
* msginfo(mCPLV)
///////////////////////////////////////////
// Monta Código de Barras (p/ Banco)
//////////////////////////////////////////

agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
 

 gdv_barras:=cod_banco+moeda+mFTVC+cvalor+carteira+agencia1+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
*gdv_barras:=cod_banco+moeda+mFTVC+valor+carteira+agencia+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
dbbarras:=gera_dv_barra(gdv_barras)
mDGCB:=dbbarras
mCDBR:=cod_banco+moeda+mDGCB+mFTVC+cvalor+carteira+agencia1+mCPLV 

///////////////////////////////////////////////////////
// Monta Representação Númerica do Código de Barras
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
 // MSGINFO(mRNCB)
  
  oform_boleto.txt_linhadigitavel.value := mRNCB
  oform_boleto.txt_codigobarras.value   := mCDBR
  oform_boleto.txt_binarios.value       := Int25(oform_boleto.txt_codigobarras.value)

///////////////////////////////////////////////
// Emite o Bloqueto
*boleto_imprimir() 

Cria_titulo_Ini()
/////////////////////////////////////////////
///////////////////////////////////////////////
// grava o Bloqueto

*Vencimento:=limpa(Vencimento)
*xvencimento:=CTOD(Vencimento)
cCValor:=VAL(cValor)/100
*msginfo(xVencimento)
xvencimento:=boleto->vcto  

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
/////////////////////////////////////////////

*/



RETURN 

//===========================================================================//
//                                                                           //
// Retorna Dígito de Controle Módulo 10                                      //
//                                                                           //
//===========================================================================//
function BLQ_DG10(Cod_banco,mNMOG)
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
// Retorna Dígito de Controle Módulo 11 (p/ Banco)                           //                                                                           //
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
      MsgStop([Rotina BLQ_DG11 não implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)

*******************************************************************************

**************************** alterado por Malc Informática em 18/08/2010 ******
* Retorna Dígito Verificador do Nosso Número - Banco 748 Sicoob
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
      MsgStop([Rotina BLG_DG11_756_NN não implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)


*******************************************************************************


*************************** alterado por jose juca em 20/4/2010 ******
* Retorna Dígito Verificador do Campo Livre - Banco 748 Sicoob
*******************************************************************************
Function blq_dg11_756_cl(Cod_banco, mBSDG, mNMOG)
   Local mCTDG:= 1, mSMMD:= mRSDV:= 0, mSQMP:= 2, mDCMD:= []
 
   For mCTDG:= 1 to len(mNMOG)
       mSMMD+= val(substr(mNMOG, len(mNMOG) - mCTDG + 1, 1)) * (mSQMP)
       mSQMP:= Iif(mSQMP == mBSDG, 2, mSQMP + 1)
   endfor
   mRSDV:= Int(Mod(mSMMD, 11))
   If Cod_banco == [756]  // Sicoob
      mDCMD:= Iif(mRSDV <= 1, [0], str(11 - mRSDV, 1))
   Else
      MsgStop([Rotina BLG_DG11_756_CL não implementada para este Banco !] + CRLF + [Entre em contato com o Suporte.])
      Return (Nil)
   Endif
Return (mDCMD)


FUNCTION bolseq_init()
printPV:=  .F.  
boleto->(dbsetorder(1))   
boleto->(dbgobottom())
boleto->(dbskip(-6))
wbolseq.SELECAO.value:=boleto->(recno())
RETURN 


#include <minigui.ch>   
#include <common.ch> 
 
///  impressoras
Function Impresoras(nome)
   Local aIMP1,aIMP2,aIMP3,aIMP4
PUBL printLaser:="PrimoPDF"
   
   aIMP1:=aPrinters()                             // lista de  impressoras
   ASORT(aIMP1,,, { |x, y| UPPER(x) < UPPER(y) })
   aIMP2:=GetDefaultPrinter()                     // printer default
   aIMP3:=ASCAN(aIMP1, {|aVal| aVal == aIMP2})    // numero da printer default
   aIMP4:=ASCAN(aIMP1, {|aVal| aVal == nome})     // numero da printer informada
   printX:=nome
RETURN {aIMP1,aIMP2,aIMP3,aIMP4}



FUNCTION wwbolseq_confirma()
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


FUNCTION bolseq_selecao_focus 
//wbolseq.beste.enabled:= .F.
//wbolseq.bretira.enabled:=.T.
RETURN

FUNCTION bolseq_este()
wbolseq.selecao.AddItem ( { STR(boleto->numero), SUBSTR(boleto->M_SACADO,1,55),transform(boleto->VALOR,"@R 999,999.99") } )  
RETURN 

FUNCTION bolseq_retira()
IF wbolseq.selecao.value>0 
   wbolseq.selecao.DeleteItem(wbolseq.selecao.value)
Endif
RETURN 
 



function dv_nnumero(dv_nosso) 
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



STATIC procedure gerar_dv(bbarra)
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






procedure gera_dv_barra(br_barra)
  Local cCampo1, cCampo2, cCampo3, cCampo4
   Local nDv1 := nDv2 := nDv3 := 0
   Local aDv1[9], aDv2[10], aDv3[10]
   Local i, cVar, nMultiplo
   Local cbarra, aDv[43], nDv := 0
   
   **msginfo(br_barra)
   
	* Cálculo do dígito geral
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
FUNCTION boleto_imprimir()  
////////////////////////////////
*local path :=DiskName()+":\"+CurDir()
 local path :=DiskName()+":\"+CurDir()

#include "Minigui.ch"
#include "winprint.ch"
 
*nomepdf='BOL'+ALLTRIM(STR(VAL(nosso_numero)))+'.pdf'        //  se utilizar PrimoPDF para capturar impressao e gerar PDF 
*exibe_multipdf(nomepdf)
*exibe_multipdf(nomepdf,path)   

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

//  ficha de compensação          
         linha=180                                             
         FOR a=5 TO 205  
             @ linha-1,a PRINT '-' FONT "Arial"  SIZE 6  COLOR BLACK 
         NEXT a 
         boleto_mascara() 
         @ 5+linha,72 PRINT mRNCB TO 10+linha,205 RIGHT FONT "Arial" SIZE 12 COLOR BLACK          //   representacao cod barra

 
         @ 83+linha,170 PRINT ' - Ficha de compensação' FONT "Arial"  SIZE 6  COLOR BLACK       

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


**************************** alterado por Malc Informática em 19/08/2010 ******
Function boleto_mascara()
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
@ 19+linha,146 PRINT 'Agência/Código Cedente' FONT "Arial"  SIZE 6  COLOR BLACK  
 
@ 21+linha,10 PRINT mNMCD+'     -     '+ Trans(mCGCD,'@R 99.999.999/9999-99')  FONT "Arial"  SIZE 8  COLOR BLACK    
**************************** alterado por Malc Informática em 13/08/2010 ******
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
@ 25+linha,46 PRINT 'Número do Documento' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,76 PRINT 'Espécie Doc.' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,96 PRINT 'Aceite' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,116 PRINT 'Data do Processamento' FONT "Arial"  SIZE 6  COLOR BLACK  
@ 25+linha,146 PRINT 'Nosso Número' FONT "Arial"  SIZE 6  COLOR BLACK   

@ 27+linha,10 PRINT mHoje TO 31+linha,45 CENTER FONT "Arial"  SIZE 8  COLOR BLACK      // 
@ 27+linha,45 PRINT Num_doc  TO 31+linha,75 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,75 PRINT especie  TO 31+linha,95 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,95 PRINT 'NÃO'  TO 31+linha,115 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 27+linha,115 PRINT mDTPC TO 31+linha,145 CENTER FONT "Arial"  SIZE 8  COLOR BLACK  
@ 27+linha,146 PRINT mNSNM TO 31+linha,195 RIGHT FONT "Arial"  SIZE 8  COLOR BLACK     
 
@ 31+linha,10 PRINT LINE TO 31+linha,205 PENWIDTH 0.2    //-   
//@ 34+linha,145 PRINT LINE TO 34+linha,205 PENWIDTH 6 COLOR GRAY      // 
@ 31+linha,10 PRINT 'Uso do Banco' FONT "Arial"  SIZE 6  COLOR BLACK    
@ 31+linha,46 PRINT 'Carteira' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,61 PRINT 'Espécie' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,76 PRINT 'Quantidade' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,116 PRINT '(x) Valor' FONT "Arial"  SIZE 6  COLOR BLACK     
@ 31+linha,146 PRINT '( = ) Valor do Documento' FONT "Arial"  SIZE 6  COLOR BLACK     

@ 33+linha,45 PRINT Carteira  TO 37+linha,60 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 33+linha,60 PRINT 'R$'   TO 37+linha,75 CENTER FONT "Arial"  SIZE 8  COLOR BLACK     
@ 32+linha,146 PRINT transform(round(val(cValor)/100,2),"@ZE 999,999,999.99")  TO 37+linha,195 RIGHT  FONT "Arial"  SIZE 12  COLOR BLACK     

@ 37+linha,10 PRINT LINE TO 37+linha,205 PENWIDTH 0.2    //-   
@ 37+linha,10 PRINT 'Instrucoes ( Todas informações deste bloqueto são de exclusiva responsabilidade do cedente ) ' FONT "Arial"  SIZE 6  COLOR BLACK     
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
@ 83+linha,146 PRINT 'Autenticação mecânica' FONT "Arial"  SIZE 6  COLOR BLACK        
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


 
FUNCTION exibe_multipdf(cNome,cDir)   
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



FUNCTION exibe_multipdf_selecao() 
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


FUNCTION exibe_multipdf_este 
linhagrid = ( wPdfFile.arquivos.Item ( wPdfFile.arquivos.value ) )   
cArquivo=linhagrid[1]
IF EMPTY(diratual) 
   carquivo=dirpdf+carquivo
ELSE
   carquivo=dirpdf+diratual+carquivo
ENDIF 
ShellExecute(0, "open", cArquivo , , ,1 ) 
RETURN

FUNCTION wPdfFile_init
wPdfFile.arquivos.DeleteAllItems 
FOR i = 1 TO nLen 
    wPdfFile.arquivos.AddItem ( { aName[i] } )
NEXT 
RETURN





Function Int25( cCode )

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


Function mostra_linha()


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
parcela        :="001"

mLGBC:=PATH+'\sicooblogo.gif'
mDTBS:=ctod("07/10/1997") //   data base pata dias a vencer
mHOJE:=SUBSTR(DTOC(DATE()),1,6)+STR(YEAR(DATE()),4) 
/////////////////////////////////////////////////////
// Rotina de criação dos campos e visualização do codigo de barras
//////////////////////////////////////////////////////////////////

public mLCPG,mNSNM,mDGNN,mCPLV,mCDBR,mDGCB,mRNCB,mFTVC,mC1RN,mC2RN,mC3RN,mC4RN,mC5RN
Cod_banco   :=strzero(c_Cod_banco,3)
agencia     :=strzero(c_agencia,4) // código da agência
Cod_cedente :=strzero(c_Cod_cedente, 10)    // conta corrente
nosso_numero:=strzero(c_nosso_numero,7)
mLCPG:= [PAGÁVEL PREFERENCIALMENTE NAS COOPERATIVAS DE CRÉDITO DO SICOOB]
Carteira:= [1]                  // código da carteira: 1 (A - Simples)
mPOCD:= [02]                 // INCLUIR AQUI O CODIGO DO POSTO CEDENTE OU UNIDADE DE ATENDIMENTO
Modalidade:= [01]                  // código referente ao tipo de cobrança: 1 - com Registro, 3 - Sem Registro

  // Num_doc:= nosso_numero
   mFTVC:=strzero(Vencimento-mDTBS,4)
   Valor:=strzero(c_Valor*100,10)
   xDTVC:=SUBSTR(DTOC(Vencimento),1,6)+STR(YEAR(Vencimento),4)       
   Vencimento:=dtoc(Vencimento)        
   aLnit:=Iif(ischaracter(aLNIT),{aLNIT,"","","","","",""},aLNIT)
//
// Monta Nosso Número (p/ Banco)
//
   
agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
cValor:=strzero(c_Valor*100,10)

   
   * Cálculo do Fator de Vencimento 
    mFTVC:= strzero((CTOD(Vencimento) - CTOD([03/07/2000])) + 1000, 4)
    mCDEM:= [3]
    mDGNN:=gerar_dv(teste)
    mNSNM:= Substr(str(year(mDTDC), 4), 3, 2) + [/] + mCDEM + nosso_numero + [-] + mDGNN
    mNSNM= nosso_numero + [-] + mDGNN
    oform_boleto.txt_nossogerado.value:=mNSNM   
	
//////////////////////////////////////////////////////////////////////
// Monta Campo Livre do Código de Barras e Linha Digitável (p/ Banco) == mCPLV
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
// Monta Código de Barras (p/ Banco)
//////////////////////////////////////////

agencia1:=str(agencia)
Cod_cedente =LPAD(STR(VAL(Cod_cedente)),10,[0])
nosso_numero=LPAD(STR(VAL(nosso_numero)),07,[0])
agencia1     =LPAD(STR(val(agencia1)),04,[0])
teste:=agencia1+Cod_cedente+nosso_numero
 

 gdv_barras:=cod_banco+moeda+mFTVC+cvalor+carteira+agencia1+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
*gdv_barras:=cod_banco+moeda+mFTVC+valor+carteira+agencia+modalidade+substr(mCPLV,3,7)+substr(mNSNM,1,7)+substr(mNSNM,9,1)+parcela
dbbarras:=gera_dv_barra(gdv_barras)
mDGCB:=dbbarras
mCDBR:=cod_banco+moeda+mDGCB+mFTVC+cvalor+carteira+agencia1+mCPLV 

///////////////////////////////////////////////////////
// Monta Representação Númerica do Código de Barras
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




//*********************************  
STATIC Function pesq_BOLETO()
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
 * MsgInfo("Código Não Enntrado: " , "ATENÇÃO")
    Return .f.
    else
 //  MsgInfo("Código Não Enntrado: " , "ATENÇÃO")
	* MsgStop(HB_OEMTOANSI('O Campo Quantidade está vazio','Atenção'))
  //   Form_PDV.Text_CODBARRA.setfocuS  
 //Return .f.
guarda_boleto()
*MsgInfo("JA : " , "ATENÇÃO")
EndIf
 
oQuery:Destroy()

//wn_mudatamanho()
//ZERATAMANHO()

Return Nil           


Function guarda_boleto()

nValMora:=0


                       xnumero    :=ntrim(oform_boleto.txt_nossonumero.value)
					   xnosso_n   :=xnumero
					   xcod_cedent:=alltrim(oform_boleto.txt_cod_cedente.value)
                       XSACADO    :=alltrim(oform_boleto.txt_sacado.value)
					   Xcedente   :="MEDIAL COMERCIO DISTRIBUIDOR LTDA"
                       XVCTO      :=DTOS(oform_boleto.txt_vencimento.value)
			           XVALOR     :=NTRIM(oform_boleto.txt_VALOR.value)
					   XCNPJ      :="84712611000152"
					   Xnsnumero  :=ntrim(oform_boleto.txt_nossonumero.value)
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

RETURN

*******************************************************
static Function Cria_titulo_Ini()
local path :=DiskName()+":\"+CurDir()
LOCAL c_CFileDanfe:=""
************************************************************
DADOS_TITULO:={}
c_valor:=boleto->valor
nValMora:=boleto->valor
nValMora:=strzero(nValMora*15/30)
Vencimento:=dtoc(boleto->vcto)   

cFileDanfe:="C:\ACBrMonitorPLUS\ACBrMonitor.INI"
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "BOLETO"       ENTRY "BANCO"
END INI
public  cCFileDanfe   :=ALLTRIM(c_CFileDanfe)

aadd(DADOS_TITULO,{'[Titulo1]'})
aadd(DADOS_TITULO,{'NumeroDocumento='+boleto->CONTROLE})
aadd(DADOS_TITULO,{'NossoNumero    ='+str(boleto->numero)})
IF cCFileDanfe='9'
aadd(DADOS_TITULO,{'Carteira       =1'})
ELSE
aadd(DADOS_TITULO,{'Carteira       =RG'})
ENDIF
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

        * cSubDir := DiskName()+":\"+CurDir()+"\"+resultado+"\"
		  cSubDir := DiskName()+":\"+CurDir()+"\"+"BOLETOS"+"\"+resultado+"\"
  	
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
            ENDIF


Tipo_Relatorio=1


   RET := IBR_COMANDO_BOLETO( "ConfigurarDados(C:\ACBrMonitorPLUS\cedente.ini)"   )
 			*	if Retorno_AcBR==.t.
				
				  RET := IBR_COMANDO_BOLETO( "LimparLista" )
				  RET := IBR_COMANDO_BOLETO( "IncluirTitulos(C:\ACBrMonitorPLUS\\titulo.ini)"   )
		*		  RET := IBR_COMANDO_BOLETO( "IncluirTitulos(F:\NFC-E-v-3-plus\titulo.ini)"   )
		*		  RET := IBR_COMANDO_BOLETO( "IncluirTitulos(titulo.ini)"   )
		
			  *    RET := IBR_COMANDO_BOLETO( "Imprimir"  )
			      RET := IBR_COMANDO_BOLETO( "GerarPDF"  )
			  *   RET := IBR_COMANDO_BOLETO( "GerarHTML"  )
		       	 cRet := IBR_COMANDO_BOLETO("GerarRemessa("+cSubDir+")")
			
ThisWindow.release
		

boleto:="C:\ACBrMonitorPLUS\boleto.PDF"
PDFOpen(boleto)				

Return Nil





				
************************************************************************
Function IBR_COMANDO_BOLETO(CMD,VET_PARAM,ESPERA,TENTA)
* Funcao de uso interno para enviar os comandos para a impressora e
* registrar os erros retornados pela mesma. Exibe os erros se existirem
************************************************************************


#include "fileio.ch"
#include "commands.ch"
#include <minigui.ch>

#define  ETX chr(3)
#define  CR  chr(13)
#define  LF  chr(10)

#define ENT_TXT  'ENT.TXT'
#define SAI_TXT  'SAI.TXT'
#define TMP_TXT  'ENT.TMP'

*
Static sENDER   :='C:\acbrmo~1\'  ,;
       SEM_ERRO := .F. ,;
       sSECHORA := 0   ,;
       sRETHORA := ''  ,;
       sSECCOO  := 0   ,;
       sNUMCUPOM:= ''  ,;
       sNumSerie:= ''  ,;
       sSECEST  := 0   ,;
       sESTADO  := ''  ,;
       sMODELO  := ''

#ifdef __XHARBOUR__
Static sSOCKET
#endif




Local RET_IMP, REQ, RESP, TEMPOR, TINI, TFIM, BLOCO, BYTES, I, TIPO_PARAM

if empty(sENDER)
   if ! SEM_ERRO
      MSGINFO('AcbrMonitor n†o foi inicializado.')
   endif
   return ''
endif

DEFAULT VET_PARAM   to {} ,;
        ESPERA      to 0  ,;
        TENTA       to .t.

///// Codificando CMD de acordo com o protocolo /////
RET_IMP  := ''

if ! ('.' $ left(CMD,5))   // Informou o Objeto no Inicio ?
   CMD := 'BOLETO.'+CMD       // Se nao informou assume BOLETO.
endif

if len(VET_PARAM) > 0
   CMD := CMD + '(' ;

   For I := 1 to len(VET_PARAM)
     TIPO_PARAM := valtype(VET_PARAM[I])

     if TIPO_PARAM = 'C'
        // Converte aspas para simples para aspas duplas, para o ACBrMonitor
        CMD := CMD + '"'+ StrTran( RTrim(VET_PARAM[I]), '"', '""' ) + '"'

     elseif TIPO_PARAM = 'N'
        CMD := CMD + strtran(alltrim(Str(VET_PARAM[I])),',','.')

     elseif TIPO_PARAM = 'D'
        CMD := CMD + dtoc( VET_PARAM[I] )

     elseif TIPO_PARAM = 'L'
        CMD := CMD + iif( VET_PARAM[I],'TRUE','FALSE')

     endif

     CMD := CMD + ', '
   next

   CMD := substr(CMD,1,len(CMD)-2) + ')'
endif

CMD := CMD + CR+LF

if ! SEM_ERRO
   ESPERA := max(ESPERA,5)
else
   TENTA := .F.
endif

if PATH_DEL $ sENDER               /// E' TXT ? ///
   REQ    := sENDER + ENT_TXT
   RESP   := sENDER + SAI_TXT
   TEMPOR := sENDER + TMP_TXT

   //////// Transmitindo o comando /////////
   TFIM := seconds() + 3    // Tenta apagar a Resposta anterior em ate 3 segundos
   do while file( RESP )
      if ferase( RESP ) = -1
         if (seconds() > TFIM)
            RET_IMP := 'ERRO: Nao foi possivel apagar o arquivo: ('+RESP+') '+;
                       ErrorOsMessage(ferror())
         else
            millisec(20)
         endif
      endif
   enddo

   do while empty(RET_IMP)
      TFIM := seconds() + 3    // Tenta apagar a Requisicao anterior em ate 3 segundos
      do while file( REQ )
         if ferase( REQ ) = -1
            if (seconds() > TFIM)
               RET_IMP := 'ERRO: Nao foi possivel apagar o arquivo: ('+REQ+') '+;
                          ErrorOsMessage(ferror())
            else
               millisec(20)
            endif
         endif
      enddo

      // Criando arquivo TEMPORARIO com a requisicao //
      if empty(RET_IMP)
         if ! Grava_ARQ(TEMPOR, CMD)

            RET_IMP := 'ERRO: Nao foi possivel criar o arquivo: ('+TEMPOR+') '+;
                       ErrorOsMessage(ferror())
         endif
      endif

      // Renomeando arquivo TEMPORARIO para REQUISICAO //
      if empty(RET_IMP)
         if frename(TEMPOR, REQ) = -1
            RET_IMP := 'ERRO: Nao foi possivel renomear ('+TEMPOR+') para ('+REQ+') '+;
                       ErrorOsMessage(ferror())
         endif
      endif

      // Espera ACBrMonitor apagar o arquivo de Requisicao em ate 7 segundos
      // Isso significa que ele LEU o arquivo de Requisicao
      TFIM := seconds() + 7
      do while empty(RET_IMP) .and. (seconds() <= TFIM) .and. file(REQ)
         millisec(20)
      enddo

      if file(REQ)
         if ! TENTA
            RET_IMP := 'ERRO: ACBrMonitor nao esta ativo'
            EXECUTE FILE "C:\acbrmo~1\acbrmo~1.exe" WAIT
         else
            if MSGYESNO('O ACBrMonitor n†o est  ativo | Deseja tentar novamente [1] ?') 
						RET_IMP := 'ERRO: ACBrMonitor nao esta ativo'
					   EXECUTE FILE "C:\acbrmo~1\acbrmo~1.exe" WAIT
            else
                  TENTA := .F.
						exit
            endif
         endif
      else
         exit
      endif
   enddo

   //////// Lendo a resposta ////////
   TINI   := Seconds()
   do while empty(RET_IMP)
      if file(RESP)
         RET_IMP := alltrim(memoread( RESP ))
      endif

      if empty(RET_IMP)
         if Seconds() > (TINI + 5)
             @ 23, 2 say pad('Aguardando resposta do ACBrMonitor:  '+; // '('+ProcName(2)+') '+;
                         Trim(str(TINI + ESPERA - seconds(),2)),77) color "W/R+"
         endif

         if Seconds() > (TINI + ESPERA)
 
            if ! TENTA
               RET_IMP := 'ERRO: Sem resposta do ACBrMonitor em '+alltrim(str(ESPERA))+;
                          ' segundos (TimeOut)'
            else
      	  //    if MSGYESNO('O ACBrMonitor n†o est  ativo | Deseja tentar novamente [2]?') 
				//			RET_IMP := 'ERRO: ACBrMonitor nao esta ativo'
				//		   EXECUTE FILE "C:\acbrmo~1\acbrmo~1.exe" WAIT
            //   else
             //     TENTA := .F.
              //    EXIT
             //  endif
            endif
         endif
         millisec(20)
      endif
   enddo
 

//   ferase( strtran(RESP,'.TXT','.OLD') )
//   frename( RESP, strtran(RESP,'.TXT','.OLD') )
   ferase( RESP )
#IFDEF __XHARBOUR__

else                                       //// TCP / IP (apenas xHarbour ) ///
   //////// Transmitindo o comando /////////
   InetSetTimeout( sSOCKET, 3000 )   // Timeout de Envio 3 seg //
   if inetsendall( sSocket, CMD ) <= 0
      RET_IMP := 'ERRO: Nao foi possivel transmitir dados para o ACBrMonitor|'+;
                 '('+AllTrim(Str(InetErrorCode( sSOCKET )))+') '+;
                 InetErrorDesc( sSOCKET ) + ETX
   endif

   //////// Lendo a resposta ////////
   InetSetTimeout( sSOCKET, 500 )
   TINI   := Seconds()
   TELA   := savescreen(23,1,23,78)
   do while (right(RET_IMP,1) <> ETX)
      BLOCO := space(64)

      BYTES   := inetrecv(sSOCKET, @BLOCO, 64)
      RET_IMP += left(BLOCO,BYTES)

      if Seconds() > (TINI + 5)
          @ 23, 2 say pad('Aguardando resposta do ACBrMonitor:  '+; // '('+ProcName(2)+') '+;
                      Trim(str(TINI + ESPERA - seconds(),2)),77) color "W/R+"
      endif

      if Seconds() > (TINI + ESPERA)
         restscreen(23,1,23,78,TELA)

         if ! TENTA
            RET_IMP := 'ERRO: Sem resposta do ACBrMonitor em '+alltrim(str(ESPERA))+;
                       ' segundos (TimeOut)' + ETX
         else
            if MSGYESNO('O ACBrMonitor n†o est  ativo | Deseja tentar novamente [3]?') 
						RET_IMP := 'ERRO: ACBrMonitor nao esta ativo'
					   EXECUTE FILE "C:\acbrmo~1\acbrmo~1.exe" WAIT
            else
               TENTA := .F.
               EXIT
            endif
         endif
      endif
   enddo
#ENDIF
endif

//if substr(RET_IMP,1,3) <> 'OK:' .or. substr(RET_IMP,1,5) == 'ERRO:'
//   ALERTA('RETORNO INVALIDO INIFIM|'+RET_IMP+'|'+ alltrim(memoread( RESP )) )
//endif

do while right(RET_IMP,1) $ CR+LF+ETX   // Remove sinalizadores do final
   RET_IMP := left(RET_IMP,len(RET_IMP)-1)
enddo

if ! SEM_ERRO
   MSG_ERRO := ''
   if substr(RET_IMP,1,5) == 'ERRO:'
    *  MSG_ERRO := 'Erro ACBrMonitor|'+; //  'Rotina ('+ProcName(2)+')|'+;
    *              strtran(strtran( MUDA_ACENTOS(substr(RET_IMP,7)),CR,''),LF,'|')
   endif

   if ! empty(MSG_ERRO)
      MSGINFO(MSG_ERRO)
      RET_IMP := ''
   endif
endif

//if substr(RET_IMP,1,3) <> 'OK:' .or. substr(RET_IMP,1,5) == 'ERRO:'
//   ALERT('RETORNO INVALIDO FIM|'+RET_IMP+'|'+ alltrim(memoread( RESP )) )
//endif

IF TENTA==.F.
	Public Retorno_AcBR:=.F.
else
	Public Retorno_AcBR:=.T.
END
  
return RET_IMP


/*
********************************************************************************
***************INCIO DA FUNCAO DE ABRIR ARQUIVOS********************************
********************************************************************************
// Open help file with associated viewer application
FUNCTION Abre_arquivo( cHelpFile )
   LOCAL nRet, cPath, cFileName, cFileExt
   HB_FNameSplit( cHelpFile, @cPath, @cFileName, @cFileExt )
   nRet := _OpenHelpFile( cPath, cHelpFile )
RETURN nRet
*/

********************************************************************************
***************FIM DA FUNCAO DE ABRIR ARQUIVOS**********************************
********************************************************************************


Static Function Grava_ARQ( WARQ, WTXT )
Local HANDLE, RET := .T.

HANDLE := fcreate(WARQ, FC_NORMAL )
if HANDLE > 0
   fwrite(HANDLE, WTXT + chr(13) + chr(10) )
   RET := (ferror() = 0)

   fclose(HANDLE)
endif

RETURN RET

