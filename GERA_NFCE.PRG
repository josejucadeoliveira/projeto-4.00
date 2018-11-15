// Harbour MiniGUI                 
// (c)2015 -José juca 
// Modulo : Emissor de Nota Fiscal
// 14/2/2014 12:12:12
#include 'minigui.ch'
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
Function Fecha_ITEMDAV5()
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
publ cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
xxx:=1
ProcedureValidadeCertificado()
Reconectar_A() 
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

close all 
abreDADOSNFE()
abreitemnfe()

	  
DEFINE WINDOW NFe;
       at 000,000;
       WIDTH 850 ;
       HEIGHT 450;
       TITLE 'NFe' ICON "ICONE01";
       MODAL;
       NOSIZE;
	   ON INIT {||NFe.nome_Cli.SETFOCUS}
   
	   
     ON KEY ESCAPE OF NFe ACTION { ||NFe.RELEASE }
 
  		
	
   
   @ 25, 50   LABEL oSaynome ;
   WIDTH 150 ;
   HEIGHT 034 ;
   VALUE "Nome do Cliente"  ;
   FONT "MS Sans Serif" SIZE 12.00 
   

	   
  @ 25, 250   TEXTBOX nome_Cli ;
  WIDTH 380 HEIGHT         34 ;
  VALUE '';
  FONT "MS Sans Serif" SIZE 012 

 @ 75, 50  LABEL oSay14 ;
   WIDTH 090 ;
   HEIGHT 034 ;
   VALUE "Cnpj/Cpf"  ;
   FONT "MS Sans Serif" SIZE 12.00 
   
//-------------------------------------
   @ 75, 250   TEXTBOX cnpj_cpf ;
   WIDTH 150 HEIGHT         34 ;
   VALUE '' ;
   FONT "MS Sans Serif" SIZE 010 ;
  ON enter  {||wn_gravavda1(),PESQ_PVENDA()}
  
 
 
 @ 175,100  LABEL txt_DAV ;
   WIDTH 140 ;
   HEIGHT 020 ;
   VALUE  XNUMERO ;
   FONT "MS Sans Serif" SIZE 8.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 } BOLD 
	 

 
  
  /*
   
 @ 105,50 textBTN txt_DAV;
		           of nfe;
		           width 80;
                   HEIGHT 20;
                   value STR(C_CbdNtfNumero);
				   font 'verdana';
                   size 10;
                   FONTCOLOR { 255, 000, 000 };
                   BACKCOLOR { 255, 255, 255 };   
                   maxlength 40;
		           rightalign;
                   on change {||PESQ_PVENDA()}
			   
		//////////////////////////////////////////////////
*/

		@ 350,880 BUTTON   btCancelar          CAPTION "Voltar"            FONT "Cambria" SIZE 12 BOLD WIDTH 125 HEIGHT 25 FLAT ACTION nfe.Release
   
              ON KEY ESCAPE ACTION nfe.Release
         END WINDOW
 
	   ACTIVATE WINDOW nfe
	  Return NIL

 	  
	  
	  		
			
*----------------------------------
Function PESQ_PVENDA(XNUMERO)
*----------------------------------
 local cNome_Anterior := space(40)
 local PORCDESCONTO:=0
 local nn:=0
 
abreseq_dav()
ABREDAVS()
abreITEMDAV()
abreitemnfe()
abreDADOSNFE()
 
 public chave :=ntrim(DAVS->num_seq) 
 MSGINFO(chave)
 
 
Reconectar_A() 
 oQuery := oServer:Query( "Select ALIQUOTA_ICMS From empresa" )
 If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor verifique linha 5964")
    Return Nil
  Endif
  aRow	          :=oQuery:GetRow(1)
 public C_ALIQUOTA:=aRow:fieldGet(1)
      
 

DQuery := oServer:Query( "Select NUM_SEQ, NRPED, cupom, data_orc, cod_cli, nom_cli, cl_cgc ,rgie, cl_end, cl_pessoa, cl_cid, cod_ibge, ed_numero, email, cep, bairro, estado, desconto, total_ven, valor_tot, desc1, desc2 From NFCE WHERE NUM_SEQ = "+chave+" Order By emissao" )
If DQuery:NetErr()
  	MsgStop(DQuery:Error())
   MsGInfo("linha 1740  " + oServer:Error() )
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
  xTOTAL_VEN      :=dRow:fieldGet(19)
  xVALOR_TOT      :=dRow:fieldGet(20)
  xdesc1          :=dRow:fieldGet(21)
  xdesc2          :=dRow:fieldGet(22) 
//pesqbotao()
  
 
XTOTAL:=0
CREDITO_S:=0
nitem:=0
If !Empty(xnum) 
     else
   MsgInfo("Cupom Não Enntrado" , "ATENÇÃO")
     nfe.txt_dav.VALUE:=0	  
     nfe.txt_dav.SetFocus
	  Return .f.
 EndIf


 eQuery := oServer:Query( "Select COD_PROD,produto,descricao,itens,subtotal,nseq_orc,ncm,qtd,valor,unid,unid From ITEMNFCE WHERE nseq_orc ="+ntrim(xnum)+" Order By descricao" )

 If eQuery:NetErr()												
  MsgStop(eQuery:Error())
 MsgInfo("Por Favor Selecione o registro ") 
Endif

For i := 1 To eQuery:LastRec()
eRow         :=eQuery:GetRow(i)
xcod_prod    :=eRow:fieldGet(1)
xproduto     :=eRow:fieldGet(2)
xdescricao   :=eRow:fieldGet(3)
xitens       :=eRow:fieldGet(4)
xsubtotal    :=eRow:fieldGet(5)
xnseq_orc    :=eRow:fieldGet(6)
xncm         :=eRow:fieldGet(7)
xqtd         :=eRow:fieldGet(8)     
xvalor       :=eRow:fieldGet(9)
xserie       :=eRow:fieldGet(10)
xunid        :=eRow:fieldGet(11)
xCancelado   :=eRow:fieldGet(12)
      
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
 
	   
					   
                     if xCancelado="Cancelado"
                        else    
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
                        ITEMNFE->SERIE          := xSERIE 
                        ITEMNFE->unid           := xunid  
                        ITEMNFE->(DBCOMMIT())
                        ITEMNFE->(DBUNLOCK())
		             endif
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
		               DADOSNFE-> NRPED      :=xNRPED
                       DADOSNFE-> CUPOM      :=xCUPOM
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
                      * DADOSNFE-> DESCONTO   :=xDESCONTO
				       DADOSNFE-> SERIE      :=xSERIE 
                       DADOSNFE->TOTAL_IMP:=Impostos_Cupom					   
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
	                Unlock
		          ENDIF                 
               else
                     
					 
	                   DADOSNFE->(dbappend())
	   	               DADOSNFE-> NUM_SEQ    :=xnum
		               DADOSNFE-> NRPED      :=xNRPED
                       DADOSNFE-> CUPOM      :=xCUPOM
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
				       DADOSNFE-> SERIE      :=xSERIE  
					   DADOSNFE->TOTAL_IMP:=Impostos_Cupom					   
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
                    endif
					 
				      If LockReg()  
					   DADOSNFE-> TOTAL_VEN  :=xTOTAL_VEN
                       DADOSNFE-> VALOR_TOT  :=xVALOR_TOT
                       DADOSNFE-> desc1      :=xdesc1 
    		           DADOSNFE-> desc2      :=xdesc2  
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
   ITEMNFE->ncm         :=Cncm
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
 ITEMNFE->CST_C   :=CCST
ENDIF	

ELSEIF ITEMNFE->CST="000"
 CCST:=101
  If LockReg()    
 ITEMNFE->ALIQUOTA  :=C_ALIQUOTA
 ITEMNFE->CST_C   :=CCST
ENDIF	

ELSEIF ITEMNFE->CST="060"
 CCST:=102
  If LockReg()    
 ITEMNFE->CST_C     :=CCST
 ITEMNFE->UNIT_DESC :=0
 ITEMNFE->ALIQUOTA  :=0
 ENDIF	

ELSEIF ITEMNFE->CST="041"
 CCST:=103
 If LockReg()    
 ITEMNFE->UNIT_DESC :=0
 ITEMNFE->CST_C   :=CCST
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
NFe.RELEASE
STATIC Function sumatotalNFE
RETURN
///////////////////////////////////
// GRAVA_DADOS_NFCE
//////////////////////////////////////
// Harbour MiniGUI                 
// (c)2015 -José juca 
// Modulo : Emissor de Nota Fiscal
// 14/12/2014 12:12:12
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
Local1              := Chr(13) + Chr(10)
Local2              := 0
private nEmissao,nSaida:=date()
private mCFOP:=5102
private mPEDIDO:="",aFormaPagamento:=0,nEmail:=''
public path :=DiskName()+":\"+CurDir()
PUBLIC cPedido:=xnum_seq
******GERACAO NFE-C


NFe_ATV( )  
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

*vv_total:=(NFE.Txt_total.value)

VV_VALOR:=DADOSNFE->TOTAL_IMP/Vv_total*100
cDescricao:=transform((DADOSNFE->TOTAL_IMP),"@R 999,999.99")+transform((VV_VALOR),"@R 9,999.99")+"% FONTE IBPT" 
LIN_21:="Valor Aprox dos Tributos R$"+" "+cDescricao
COMPLEMENTO:=LIN_21 
 nEmissao	:=DATE()
 nNumeroOrc := cPedido

 
nFormaDePagamento:=2
 
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
		 aadd(DADOS_NFe,{'NaturezaOperacao=VENDA INTERNA'})
		 aadd(DADOS_NFe,{'Modelo=65'})
		 aadd(DADOS_NFe,{'tpImp=4'})
		 aadd(DADOS_NFe,{'indFinal=1'})  /// Indica operação com Consumidor final 
		 aadd(DADOS_NFe,{'indPres=1'})  /// Indicador de presença do comprador no estabelecimento comercial no momento da operação 
		 aadd(DADOS_NFe,{'Codigo='+C_CbdNtfNumero})
		 aadd(DADOS_NFe,{'Numero='+C_CbdNtfNumero})
		 aadd(DADOS_NFe,{'Serie=1'})

nTipo_Emissao:=2

    if nTipo_Emissao==1 ///gerar somente xml
		 aadd(DADOS_NFe,{'Emissao='+dtoc(date())})
	else
		 aadd(DADOS_NFe,{'Emissao='+dtoc(nEmissao)+time()})
	end

		 aadd(DADOS_NFe,{'tpEmis=1' })        
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
	
////////////////////////////////////////////////////////////////////////////////	 

	nTotalBase     :=DADOSNFE-> TOTAL_VEN

	nFormaDePagamento:=1
	/////Pagamentos - Na NFC-e este grupo é obrigatório
		IF  nFormaDePagamento==1
			xtPag:='01'
		elseif  nFormaDePagamento==2
			xtPag:='05'
		elseif  nFormaDePagamento==3
			xtPag:='04'
		elseif  nFormaDePagamento==4
			xtPag:='03'
		elseif  nFormaDePagamento==5
			xtPag:='02'
		else                                     	
			xtPag:='01'
		end
		
		aadd(DADOS_NFe,{'[pag001]'  })
		aadd(DADOS_NFe,{'tpag='+xtPag})
	    aadd(DADOS_NFe,{'vpag='+TRANSFORM(nTotalBase ,"@! 99999999.99") })	
		

// gravaçoes  destinatarios
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
	 aadd(DADOS_NFe,{'[Produto'+strzero(registro,3)+']' })
		 aadd(DADOS_NFe,{'CFOP=' +NTRIM(C_CFOP)})
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
 
 
ITEMNFE->(dbskip())
ENDD  

 	 
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
	 	* aadd(DADOS_NFe,{'ValorFrete='+ALLTRIM(TRANSFORM((mValor_Frete),"@! 999999999999.99")) })
	     aadd(DADOS_NFe,{'ValorIPI='+ALLTRIM(TRANSFORM((mValor_IPI),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorPIS='+ALLTRIM(TRANSFORM((nTotal_Pis),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorCOFINS='+ALLTRIM(TRANSFORM((nTotal_Cofins),"@! 999999999999.99")) })
         
		 
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
	 
	 /////Pagamentos - Na NFC-e este grupo é obrigatório
		IF  nFormaDePagamento==1
			xtPag:='01'
		elseif  nFormaDePagamento==2
			xtPag:='05'
		elseif  nFormaDePagamento==3
			xtPag:='04'
		elseif  nFormaDePagamento==4
			xtPag:='03'
		elseif  nFormaDePagamento==5
			xtPag:='02'
		else                                     	
			xtPag:='01'
		end
		aadd(DADOS_NFe,{'[pag001]'  })
		aadd(DADOS_NFe,{'tpag='+xtPag})
		aadd(DADOS_NFe,{'vpag='+TRANSFORM(nTotal_Itens-mValor_Desconto,"@! 99999999.99") })	
	 


 xCbdinfCpl	  	 	  := COMPLEMENTO

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
*******************************

       SELE DAVS 
                    If LockReg()  
                       DAVS->NUM_SEQ := 0 
                       DAVS->(dbcommit())
                       DAVS->(dbunlock())
                 Unlock
                 ENDIF   
				 SELE SEQ_DAV
			  	 If LockReg()  
                      seq_DAV-> ABERTO   :=""
                      seq_DAV->(dbcommit())
                      seq_DAV->(dbunlock())
                  Unlock
				  ENDIF
			*	 MSGINFO("OK")
							 

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

public nnfe:="NFE"+(chave)

///////FIM///////////////

*MODIFY CONTROL Servico  OF NFE VALUE   'SITUAÇÃO DO SERVIÇO.:' 
*MODIFY CONTROL Servico1  OF NFE VALUE   'AGUARDE..' 
cTXT:=PATH+"\NOTA.TXT"
////////////////////////CRIAR NOTA NFE///////////////////////
NFe_XML(cTXT )
////////////////////////////////////////////////////////////
*MODIFY CONTROL gerando_xml OF nfe  VALUE   'GERANDO XML...............:' 
NFe_SWS()
*MODIFY CONTROL gerando_xml1 OF nfe  VALUE   'OK' 
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
*MODIFY CONTROL Servico1  OF NFE  VALUE   'OK' 
      else 
   	  MsgInfo("Serviço Solicitado não Esta Ativo, ou sem Conecção na Internet")
 return(.f.)
endif
*MODIFY CONTROL VALIDANDO_XML  OF NFE  VALUE   'VALIDANDO XML.........:' 
*MODIFY CONTROL VALIDANDO_XML1 OF NFE  VALUE   'OK' 
nFe_VAL(alltrim(cSAIDA_XML))
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
*MODIFY CONTROL ASSINADO_XML  OF NFE  VALUE   'ASSINANDO XML.......:' 
*MODIFY CONTROL ASSINANDO_XML1 OF NFE  VALUE   'OK' 
NFe_ENV(alltrim(cSAIDA_XML))
else
msginfo(C_XMotivo,"ATENÇÃO")
MsgInfo('Chave não Valida', "ATENÇÃO")
return (.f.)
endif 
*MODIFY CONTROL ASSINADO_XML OF NFE  VALUE   'ASSINANDO XML.......:' 
*MODIFY CONTROL ASSINANDO_XML1 OF NFE  VALUE   'OK' 
cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
 lRetStatus:=EsperaResposta(cFileDanfe) 
       if lRetStatus==.t.  ////pego os dados
       end
cFileDanfe := 'C:\ACBrNFeMonitor\sainfe.txt'
BEGIN INI FILE cFileDanfe
       GET sCStat          SECTION  "STATUS"       ENTRY "CStat" 
	   GET sXMotivo        SECTION  "STATUS"       ENTRY "XMotivo"    // MOTIVO 
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
*MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE  "CHAVE.." + C_XMotivo 
*MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
*GRAVA_nfe1()
if RCStat="100"
*LinhaDeStatus("Aguarde..."  +C_XMotivo)
*MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
*MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
ELSE
*MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE "CHAVE.."  + C_XMotivo 
*MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
msginfo(R_XMotivo)
return(.f.)
endif
*MODIFY CONTROL AUTORIZACAO_XML OF NFE  VALUE  "CHAVE" + cChNFe
*MODIFY CONTROL PROTOCOLO_XML   OF NFE  VALUE  "PROTOCOLO.." + CNPROT
if C_XMotivo="Autorizado o uso da NF-e"
XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+xml
msginfo(C_XMotivo,"ATENÇÃO")
NFe_CON(fxml)
*MODIFY CONTROL email_XML OF NFE VALUE  "" + "Imprimindo nfe ..."
NFe_IMP(alltrim(fxml))
*MODIFY CONTROL email_XML OF NFE  VALUE  "" + "Enviando Email nfe ..."
*eemail         :=ALLTRIM(nfe.Txt_email.value)
*NFe_EMA(eemail,fxml)
ElseIf C_XMotivo="Lote recebido com sucesso"
msginfo(C_XMotivo, "ATENÇÃO")
XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+xml
*NFe_CON(fxml)
*MODIFY CONTROL email_XML OF NFE  VALUE  "Imprimindo nfe ..."
NFe_IMP(alltrim(fxml))
*If !Empty(eemail) 
*MODIFY CONTROL email_XML OF NFE  VALUE  "Enviando Email nfe ..."
*NFe_EMA(eemail,fxml)
*else
endif
SAIR_nfe()
return

******************************
Function EsperaResposta(cFile)
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
STATIC FUNCTION SAIR_nfe
//---------------------------------------------
*  Release Window ALL
  Form_dav.RELEASE
  oform2.release
*status_email.release 
RETURN 
