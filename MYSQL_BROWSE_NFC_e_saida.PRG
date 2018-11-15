// Exemplo de Browse com MySQL
// Autor : Roberto Evangelista 
// Melhoramento jose juca
#include 'minigui.ch'
#Include "F_sistema.ch"
#INCLUDE "TSBROWSE.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "WINPRINT.CH"
#INCLUDE "TSBROWSE.CH"
#include "FastRepH.CH"
#include "lang_pt.ch"
#include "MiniGui.ch"
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

#include "i_mBrowse.ch"


memvar oConexao

//----------------------------------------------------------------------------//
// Função principal
//
function MYSQL_BROWSE_nfC_e_saida()
publ path :=DiskName()+":\"+CurDir() 
public m_ver := GetStartupFolder() + '\_cas_ver.JPG', p_GetFile := ''

nCbx1 := 0
aCbx1 := { "Numero","Nome" }
cGet1 := Space( 10 )

    HB_LANGSELECT("PT") 
  	SET DATE BRITISH
	SET CENTURY ON             
	SET DELETE ON
	SET BROWSESYNC ON
	SET EPOCH TO 2010
	SET LANGUAGE TO PORTUGUESE  

private cServidor, cUsuario, cSenha, cBanco, cTabela, vCabecalho := {} ,vLargura  := {}, vCampos := {}, cOrdem := ""
private cTabelaitens, vCabecalhoitens := {}, vLarguraitens := {}, vCampositens := {}, cOrdemitens := ""
public oConexao

  
oQuery := oServer:Query( "Select max(CbdNtfNumero)FROM NFCE CbdNtfNumero")
oRow := oQuery:GetRow(1)
ncodigo:=((oRow:fieldGet(1)))

*msginfo(ncodigo)


   
cHostName:= AllTrim(cHostName)
cUser    := AllTrim(cUser )
cPassWord:= AllTrim(cPassWord)
   
   
cServidor :=cHostName                         // Local de conexão
cUsuario  := cUser                               // Usuario
cSenha    := cPassWord                         // Senha do usuario
cBanco    := cnomedobanco                               // Banco de dados
  
 Abre_conexao_MySql()     
My_SQL_Database_Connect(cDataBase)




 Conecta (cServidor, cUsuario, cSenha, cBanco)
 *LPAD(((CbdNtfNumero)),8,[0])
 
  
    cTabela := "NFCE"                            // Tabela que será usada no browse
    vCabecalho:= {"N Nfc-e","Serie","Consumidor","Cnpj/Cpf","data","Chave","Autorização","XML","Chave do Evento"}
    vLargura := {80,50,300,150,100,250,300,200,400}                       // Largura das colunas do Browse
 	vCampos  := {"CbdNtfNumero","CbdNtfSerie","CbdxNome_dest","CbdCNPJ_dest","CbddEmi","Chave","autorizacao","nt_retorno","Cbdcheveevento"}
    cOrdem   := "CbddEmi "                                 // Browse Ordenado pela 2ª coluna nome do cliente
      

	 	 
    cTabelai   := "ITEMNFCE"                            // Tabela que será usada no browse
    vCabecalhoi:= {'Itens','NºNfe','Serie','Código','Produtos','Ncm','Cfop','Qtd','Unit','Total'}
    vLargurai  := {40,80,50,80,400,100,100,100,100,100}    	// Largura das colunas do Browse
     vCamposi  := {"CbdNtfNumero","CbdNtfSerie","CbdcProd","CbdxProd","CbdNCM" ,"CbdCFOP","CbdqCOM","CbdvUnCom","CbdvProd"}
     cOrdemi   := "CbdcProd"                                 // Browse Ordenado pela 2ª coluna nome do cliente
 
  // Funão de conexão com o MySQL


 Conecta (cServidor, cUsuario, cSenha, cBanco)
 
 
DEFINE WINDOW janelanfe;
      AT 00, 00 ;
       WIDTH 1024;
       HEIGHT 730 ;
       TITLE "Notas Saida" ;
       MODAL;   
       NOSIZE;
	    ON INIT {||buscamax()}
             
    
 @ 500,00  COMBOBOX oCbx1 ;
   WIDTH 108 HEIGHT 120 ;
   ITEMS  aCbx1;
   VALUE  1  ;
   FONT "Ms Sans Serif" SIZE 12.00

   
  @ 500,190 TEXTBOX oTb_Busca ;
    WIDTH 200 ;
	value str(ncodigo);
    MAXLENGTH 60 ;
    UPPERCASE  ;
    backcolor _AMARELO;
    ON enter iif( !Empty(janelanfe.oTb_Busca.Value), 	Busca (), janelanfe.oTb_Busca.SetFocus )
		
		




		
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

			
   
	    
  
    DEFINE BUTTON Button_3
           ROW   650
           COL    00
           WIDTH  100
           HEIGHT 28
           CAPTION "Voltar"
         Action  janelanfe.RELEASE
     END BUTTON  

	  DEFINE BUTTON Button_boleto
           ROW    600
           COL    000
           WIDTH  200
           HEIGHT 28
           CAPTION "Duplicatas com historico"
           Action  duplcas_do_nfe()       
     END BUTTON  
		
				
		
	  DEFINE BUTTON consulta_nfce
           ROW    600
           COL    200
           WIDTH  200
           HEIGHT 28
           CAPTION "Consulta nfce"
           Action  ConsultanfCe()        
     END BUTTON  
		
		
	 
	 
	 DEFINE BUTTON Button_52
           ROW   650
           COL    150
           WIDTH  150
           WIDTH  150
           HEIGHT 28
           CAPTION "Imprime_Cancelamento"
*          Action {|| ProcedureescreverINI(),ProcedureImprimirEvento_canc()}  
          Action {|| ProcedureescreverINI(), lerxml_evento()}  
        END BUTTON  

	 
 DEFINE BUTTON Button_2
           ROW   650
           COL   300
           WIDTH 100
           HEIGHT 28
           CAPTION "Cancelar-NFe"
          Action {|| pega_chave() }        
     END BUTTON  
 
  DEFINE BUTTON Button_4
           ROW    650
           COL    400
           WIDTH  200
           HEIGHT 28
           CAPTION "Visualizar-Imprimir-NFce"
           Action  lerxml()         
     END BUTTON  
		
	*		 FIELDS vCampos ;
	
 *FIELDS { 'ITENS','produto','DESCRICAO','transform((qtd),"999,999.99")','transform((Valor),+"999,999.99")','transform((SUBTOTAL),"999,999.99")','ALIQUOTA','NUMCOD','ST','CFOP'}
        		
	   // Browse para exebição dos dados da Tabela
  	   @ 35,00 MySQLBROWSE oBrw_Cliente ;
         WIDTH 1020 ;
         HEIGHT 200 ;
         HEADERS vCabecalho ;
	     WIDTHS vLargura ;
		 FIELDS vCampos;
         ORDER BY cOrdem ;
         WORKAREA cTabela ;
         SOCKET oConexao;
		 FONT "Arial Baltic" ;
         SIZE 11 ;
         BOLD ;
		 on dblclick duplcas_do_nfe();
	     ON CHANGE { acha_itens(),TOTAL() }
	
		   
		   
 DEFINE GRID Grid_itens
            ROW    235 
            COL    003  
            WIDTH  1024
            HEIGHT 265
            WIDTHS {40,80,80,400,80,80,80,100,100}
            HEADERS {'Itens','NºNfe','Código','Produtos','Ncm','Cfop','Qtd','Unit','Total'}
            Justify {1,1,0,0,0,1,1,1,1,1,1,1,1,1}
            FONTNAME "Arial Baltic"
            FONTSIZE 11
		END GRID 
		   
   janelanfe.oBrw_Cliente.SetFocus
   end WINDOW
   janelanfe.Center ; janelanfe.Activate
return (nil)

STATIC Function acha_anexo()                     
*--------------------------------------------------------------*
local pchave   := (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 6))

Local nCounter:= 0
Local oRow
Local i
Local oQuery
local c_encontro
//msginfo(pcode)
DELETE ITEM ALL FROM Grid_anexo Of janelanfe
XUNIT1=0
XQUANT1=0
REG:=0
NTOTAL=0
oQuery := oServer:Query( "Select num_seq,nome,dc_anexo,TIPOARQ,nt_retorno,CHAVE,NF From anexo WHERE chave LIKE "+pchave+"" )
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  ARQUIVO:=oRow:fieldGet(4)
  
  IF ARQUIVO="PDF"
  c_encontro:=oRow:fieldGet(3)
  ELSE
  c_encontro:=oRow:fieldGet(5)
  
  ENDIF
  
  ADD ITEM { str(oRow:fieldGet(1),8),(oRow:fieldGet(2)),c_encontro,(oRow:fieldGet(4)),(oRow:fieldGet(6)),str(oRow:fieldGet(7),8)} TO Grid_anexo Of janelanfe
  oQuery:Skip(1)
Next
oQuery:Destroy()
Return Nil







*--------------------------------------------------------------*
STATIC Function TOTAL()                     
*--------------------------------------------------------------*
local pcode     := NTRIM(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local Txt_SERIE :=      (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))

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



 *oQuery:=oServer:Query( "Select CbdvProd_ttlnfe,CbdvDesc_ttlnfe,CbdvNF,MSCANCELAMENTO From NFCE WHERE CbdNtfNumero LIKE "+pcode+" and  Order By CbddEmi" )
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



//----------------------------------------------------------------------------//
// Funçao de Busca
//
static function Busca_Itens ()
    cProcura  := str(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))

  if (len (cProcura) > 0)
   
	cProcura += iif (("*"$right (cProcura, 1)) .or. ("%"$right (cProcura, 1)), "", "")
      _MySQL_BrowseSetWhere ("oBrw_itens", "janelanfe", "WHERE CbdNtfNumero LIKE "+'"'+cProcura+'"')
      nTotalReg := _MySQL_BrowseRefresh ("oBrw_itens", "janelanfe")  
      _MySQL_BrowseSetValue ("oBrw_itens", "janelanfe", 1)

	   iif (nTotalReg > 0, doMethod ("janelanfe", "oBrw_itens", "SetFocus"), doMethod ("janelanfe", "oTb_Busca", "SetFocus"))
   doMethod ("janelanfe", "oTime", "release")
 endif
return (nil)

*--------------------------------------------------------------*
STATIC Function acha_itens()                     
*--------------------------------------------------------------*
*Local cSearch:= ' "'+Upper(AllTrim(janelanfe.cSearch.Value ))+'%" '           
*Local pCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 14 ))))
*Local pCode:= ntrim(((_MySQL_BrowseGetCol( "oBrw_Cliente", "janelanfe", 4 ))))
local Txt_SERIE :=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))
local pCode     := NTRIM(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))


Local nCounter:= 0
Local oRow
Local i
Local oQuery
local c_encontro

*msginfo(pCode)

Reconectar_A()
DELETE ITEM ALL FROM Grid_itens Of janelanfe
XUNIT1=0
XQUANT1=0
REG:=0
NTOTAL=0
*oQuery := oServer:Query( "Select itens, cod_bar,descri,QUANT,UNIT,TOTVENDA,ICMS,TOTICMS,DESCONTO, BASE_CAL,NSEQ_ORC,CODIGO From itemnf WHERE NSEQ_ORC like "+pcode+" Order By DESCRI" )
 oQuery := oServer:Query( "Select CbdNtfNumero,CbdcProd,CbdxProd,CbdNCM ,CbdCFOP,CbdqCOM,CbdvUnCom,CbdvProd From ITEMNFCE WHERE CbdNtfNumero LIKE "+pcode+" and CbdNtfSerie = "+alltrim(Txt_SERIE)+" Order By CbdxProd" )
	

For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
*msginfo((oRow:fieldGet(11)))

  REG=REG+1
  ADD ITEM { strzero(reg,4),strzero(oRow:fieldGet(1),8),LPAD(STR(val(oRow:fieldGet(2))),6,[0]),(oRow:fieldGet(3)),(oRow:fieldGet(4)),str(oRow:fieldGet(5),8),transform((oRow:fieldGet(6)),"@R 99,999.99"),transform((oRow:fieldGet(7)),"@R 99,999.99"),transform((oRow:fieldGet(8)),"@R 99,999.99") } TO Grid_itens Of janelanfe
  oQuery:Skip(1)
Next
oQuery:Destroy()
Return Nil





//----------------------------------------------------------------------------//
// Funçao de Busca
//
static function Busca ()
   local cProcura := alltrim (janelanfe.oTb_Busca.Value), oTime, nTotalReg
   
if janelanfe.oCbx1.value == 2 //nº da OS
 
    if (len (cProcura) > 0)
      cProcura += iif (("*"$right (cProcura, 1)) .or. ("%"$right (cProcura, 1)), "", "%")
     _MySQL_BrowseSetWhere ("oBrw_Cliente", "janelanfe", "WHERE CbdxNome_dest LIKE "+'"'+cProcura+'"')
      nTotalReg := _MySQL_BrowseRefresh ("oBrw_Cliente", "janelanfe")   
      _MySQL_BrowseSetValue ("oBrw_Cliente", "janelanfe", 1)
	    iif (nTotalReg > 0, doMethod ("janelanfe", "oBrw_Cliente", "SetFocus"), doMethod ("janelanfe", "oTb_Busca", "SetFocus"))
*	doMethod ("janelanfe", "oTime", "release")
   else
  *    doMethod ("janelanfe", "oTb_Busca", "SetFocus")
  endif
  
ELSEIF janelanfe.oCbx1.value == 1
   if (len (cProcura) > 0)
  *  define TIMER oTime OF janelanfe INTERVAL 100 ACTION Gira ()
     cProcura += iif (("*"$right (cProcura, 1)) .or. ("%"$right (cProcura, 1)), "", "")
      _MySQL_BrowseSetWhere ("oBrw_Cliente", "janelanfe", "WHERE CbdNtfNumero LIKE "+'"'+cProcura+'"')
      nTotalReg := _MySQL_BrowseRefresh ("oBrw_Cliente", "janelanfe")   
      _MySQL_BrowseSetValue ("oBrw_Cliente", "janelanfe", 1)
	   iif (nTotalReg > 0, doMethod ("janelanfe", "oBrw_Cliente", "SetFocus"), doMethod ("janelanfe", "oTb_Busca", "SetFocus"))
*   doMethod ("janelanfe", "oTime", "release")
   else
  * doMethod ("janelanfe", "oTb_Busca", "SetFocus")
  endif
ENDIF
return (nil)
/////////////////////////////////////////////////

static function Conecta (cServidor, cUsuario, cSenha, cBanco)
   local  lRetorno := .F.
   oConexao := TMySQLServer ():New (cServidor, cUsuario, cSenha)
   lRetorno := (!oConexao:NetErr ())
   
   if (lRetorno)
      oConexao:selectDB (cBanco)
   endif
   
return (lRetorno)



*buscamax()


static function buscamax()
   local cProcura := alltrim (janelanfe.oTb_Busca.Value), oTime, nTotalReg
   
if janelanfe.oCbx1.value == 2 //nº da OS
 
    if (len (cProcura) > 0)
      cProcura += iif (("*"$right (cProcura, 1)) .or. ("%"$right (cProcura, 1)), "", "%")
     _MySQL_BrowseSetWhere ("oBrw_Cliente", "janelanfe", "WHERE CbdxNome_dest LIKE "+'"'+cProcura+'"')
      nTotalReg := _MySQL_BrowseRefresh ("oBrw_Cliente", "janelanfe")   
      _MySQL_BrowseSetValue ("oBrw_Cliente", "janelanfe", 1)
	    iif (nTotalReg > 0, doMethod ("janelanfe", "oBrw_Cliente", "SetFocus"), doMethod ("janelanfe", "oTb_Busca", "SetFocus"))
*	doMethod ("janelanfe", "oTime", "release")
   else
  *    doMethod ("janelanfe", "oTb_Busca", "SetFocus")
  endif
  
ELSEIF janelanfe.oCbx1.value == 1
   if (len (cProcura) > 0)
  *  define TIMER oTime OF janelanfe INTERVAL 100 ACTION Gira ()
     cProcura += iif (("*"$right (cProcura, 1)) .or. ("%"$right (cProcura, 1)), "", "")
      _MySQL_BrowseSetWhere ("oBrw_Cliente", "janelanfe", "WHERE CbdNtfNumero LIKE "+'"'+cProcura+'"')
      nTotalReg := _MySQL_BrowseRefresh ("oBrw_Cliente", "janelanfe")   
      _MySQL_BrowseSetValue ("oBrw_Cliente", "janelanfe", 1)
	   iif (nTotalReg > 0, doMethod ("janelanfe", "oBrw_Cliente", "SetFocus"), doMethod ("janelanfe", "oTb_Busca", "SetFocus"))
*   doMethod ("janelanfe", "oTime", "release")
   else
  * doMethod ("janelanfe", "oTb_Busca", "SetFocus")
  endif
ENDIF
return (nil)
/////////////////////////////////////////////////




//----------------------------------------------------------------------------//
// Função de animação do botão Buscar
//
static function Gira2 ()
   local cGira := ""
   static nGira := 1
   nGira++
   cGira := iif (nGira == 1, "Carrega_20x20_1", cGira)
   cGira := iif (nGira == 2, "Carrega_20x20_2", cGira)
   cGira := iif (nGira == 3, "Carrega_20x20_3", cGira)
   cGira := iif (nGira == 4, "Carrega_20x20_1", cGira)
  janelanfe.oBt_Busca.Picture := cGira
   domethod ("janelanfe", "show")
   nGira := iif (nGira >= 4, 1, nGira)
return (cGira)



STATIC Function Consultanfe()
LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
LOCAL nHandle, cQuery,FC_NORMAL
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
LOCAL c_CFileDanfe:="C:\ACBrNFEMonitor\"
local anomes:=""
cFileDanfe:="C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"

////RETORNO////
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathNFe"
END INI

public  cCFileDanfe   :=c_CFileDanfe
*cAuxCCe  := Getfile ( { {'Arquivos','*.xml'} } , 'Consultas XML da nfe ' , +cCFileDanfe,.F. , .T. )

cAuxCCe := Getfile ( { {'Arquivos do XML NFE','*.XML'},;
{'Consultas XML da nfe','*.XML'},;
{'Todos os arquivos','*.*'} } , 'Abrir arquivo' , 'C:\ACBrNFeMonitor\' , .f. )
If !Empty (cAuxCCe)
*   MsgInfo ( "Voce escolheu o arquivo [" + cAuxCCe + "]" )
NFe_CON(cAuxCCe)
Else
*   MsgInfo ( "Nenhum arquivo escolhido" )
RETURN(.F.)
End

NFe_CON(cAuxCCe)

BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
END INI
public  c_CStat   :=cCStat
public c_cChNFe   :=cChNFe

NFe_IMP(alltrim(cAuxCCe))


Reconectar_A() 

C_CbdNtfNumero:=SUBSTR(cAuxCCe, 44, 9)
C_CbdNtfNumero:=val(C_CbdNtfNumero)

XML           :=SUBSTR(cAuxCCe, 20, 55)
fxml          :="C:\ACBrNFeMonitor\"+xml
*msginfo(fxml)
ffxml         :=memoread(cAuxCCe)
   cQuery	:= oServer:Query( "UPDATE NFCE SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = " +(ntrim(C_CbdNtfNumero)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
EndIf
RETURN
			
  
*--------------------------------------------------------------*
STATIC Function lerxml()                   
*--------------------------------------------------------------*
local pacode   :=ntrim (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local paSERIE  := (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))
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
*MSGINFO(XCHAVE)
*11150284712611000152650020000006881000000010-nfe
fxml:="C:\ACBrNFeMonitor\"+xml+"-nfe.XML"
NFe_IMP(alltrim(fxml))
ELSE
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"
*MSGINFO(cTXT)
NFe_IMP(alltrim(cTXT))
ENDIF

Return Nil

 
 
 
 
*--------------------------------------------------------------*
STATIC Function lerxml_evento()                   
*--------------------------------------------------------------*
local pacode   :=ntrim (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local paserie   :=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))
LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt'
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
//Local cDoc:='nfe.xml'
local path :=DiskName()+":\"+CurDir()

Reconectar_A() 

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
    
//MemoWrit( cDoc ,( oRow:FieldGet(2) ) )
	    
 HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
    FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"

*MSGINFO(cTXT)
*NFe_IMP(alltrim(cTXT))

*oArq:=cFileSaida

*	ProcedureLerINI()



mcodigo:=55
abreimpressora()

GO TOP

       dbselectarea('printer')
       printer->(ordsetfocus('codigo'))
       printer->(dbgotop())
       printer->(dbseek(mcodigo))
  
nomeimpressoar := (printer->nome)

*msginfo(nomeimpressoar)
*
    MY_WAIT( 2 ) 
   BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
  	  SET SECTION "Geral"           ENTRY "Impressora"            TO   nomeimpressoar
  	  SET SECTION "Geral"           ENTRY "FormaEmissao"          TO   '0'
  	  SET SECTION "DANFE"           ENTRY "MostrarPreview"        TO   "1"
     SET SECTION "DANFE"           ENTRY "Copias"                TO   "1"
  	  SET SECTION "NFCe"            ENTRY "ModoImpressaoEvento"   TO   "0"
	  SET SECTION "NFCe"            ENTRY "Modelo"                TO   "0"
	  
  END INI
     ProcedureLerINI()



	
   	IF (Handle := FCREATE(cOrigem, FC_NORMAL)) == -1
*	HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
              MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
		     Return
           ENDIF 
           FWRITE(Handle,"NFe.ImprimirEvento("+cTXT+")")
           FCLOSE(Handle) 
	
    MY_WAIT( 2 ) 
   BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
  	  SET SECTION "Geral"           ENTRY "Impressora"            TO   nomeimpressoar
  	  SET SECTION "Geral"           ENTRY "FormaEmissao"          TO   '0'
  	  SET SECTION "DANFE"           ENTRY "MostrarPreview"        TO   "1"
  	  SET SECTION "NFCe"            ENTRY "ModoImpressaoEvento"   TO   "1"
	  SET SECTION "NFCe"            ENTRY "Modelo"                TO   "1"
     SET SECTION "DANFE"           ENTRY "Copias"                TO   "2"
  END INI
     ProcedureLerINI()	   
		   
		   
		   
Return Nil


*--------------------------------------------------------------*
STATIC Function enviar_xml()                   
*--------------------------------------------------------------*
local pacode   :=ntrim (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local xnome    :=AllTrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))
Local xxnome := '"'+Upper(AllTrim(xnome))+'%" '
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

  My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
  cQuery:= "select CHAVE,nt_retorno FROM NFCE  WHERE CbdNtfNumero = " + AllTrim(pACode)      
  oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
 HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
 FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"
fQuery:= "Select email from cliente WHERE razaosoc LIKE "+xxnome 

 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
 // NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

fRow         :=fQuery:GetRow(1)
xemail       :=fRow:fieldGet(1)
eemail:= AllTrim(xemail)
*msginfo(eemail)
NFe_EMA(eemail,alltrim(cTXT))
fQuery:Destroy()
Return Nil




//**************************************
STATIC FUNCTION CANCELA_aviso()
//**************************************
  DEFINE WINDOW CANCELA_NFe;
  AT 200,400;
  WIDTH 450;
  HEIGHT 200;
  MODAL ;
  NOCAPTION
 
 
 			   
 ON KEY ESCAPE ACTION CANCELA_NFe.release //tecla ESC para fechar a janela

 
  DEFINE TEXTBOX Txt_NOTA
            ROW    30
            COL    10
            WIDTH 350
			VALUE "OPERACAO SUBISTITUIDA PELO NFE NUMERO      " 
            HEIGHT 20
         	RIGHTALIGN .F. 
	        FONTSIZE 10
            FONTNAME "Arial"
		    MAXLENGTH 300	 	
            ON enter {|| pega_chave()}
     END TEXTBOX 
 
 
 
 
 
  @ 100,010  LABEL aviso ;
   WIDTH 350;
   HEIGHT 20 ;
   VALUE ""  ;
   FONT "Perpetua Titling MT" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 } BOLD 
END WINDOW
	CENTER WINDOW CANCELA_NFe
	ACTIVATE WINDOW CANCELA_NFe

RETURN .T.

*--------------------------------------------------------------*
STATIC Function pega_chave()                     
*--------------------------------------------------------------*
local pchave :=alltrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 6))
local paCode :=ntrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local paserie:=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))
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
LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
   
Reconectar_A() 

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
	 CANCELA_NFe.RELEASE   
 EndIf
ERASE "C:\ACBrNFeMonitor\sainfe.txt"

cJus :=" Venda nao concretizada"
NFe_CAN(pchave,cJus)




  cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
  lRetStatus:=EsperaResposta(cFileDanfe) 
   if lRetStatus==.t.  ////pego os dados
     end
cFileDanfe := 'C:\ACBrNFeMonitor\sainfe.txt'

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
 

cFileSaida         := "C:\ACBrNFeMonitor\"+cPesqEVENT+"-procEventoNFe.XML"
ffxml              :=memoread(cFileSaida)

HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,ffxml)
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"
	ProcedureLerINI()

   	IF (Handle := FCREATE(cOrigem, FC_NORMAL)) == -1
             MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
		     Return
           ENDIF 
           FWRITE(Handle,"NFe.ImprimirEvento("+cTXT+")")
           FCLOSE(Handle) 
	
if c_CStat="579"
    Return .f.
 	Msginfo(cXMotivo)
	CANCELA_NFe.RELEASE
    janelanfe.RELEASE
	
	
EndIf									
										
										
if c_CStat="573"
* Msginfo(cXMotivo)
 c_XMotivo:='Evento registrado e vinculado a NF-e'
	
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



 
 

Function ProcedureImprimirEvento_canc()
LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
LOCAL nLote    := '0'
local FC_NORMAL
local pchaveevento :=alltrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 8))
local pchave       :=alltrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 5))
local paCode       :=ntrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local paserie      :=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))

cFileSaida :=pchaveevento+"-procEventoNFe.XML"
*msginfo(cFileSaida)
*oArq:=pchave+"11011101-procEventoNFe.XML"

oArq:=cFileSaida

	ProcedureLerINI()
	
   	IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
		         Return
               ENDIF 
               FWRITE(nHandle,"NFe.ImprimirEvento(C:\ACBrNFeMonitor\"+oArq+")")
              FCLOSE(nHandle) 

 
RETURN


*XML:=SUBSTR(cSAIDA_XML, 20, 55)
fxml:="C:\ACBrNFeMonitor\"+oArq

//vamos imprimir 

*NFe_IMP(alltrim(fxml))



static Function ProcedureescreverINI()
    cDestino := "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
	lRetStatus:=EsperaResposta(cDestino) 
	
	BEGIN INI FILE cDestino
      SET SECTION "DANFE"  ENTRY "Modelo"  TO '1'
    END INI
	MY_WAIT( 3 )    
	ProcedureLerINI()
return
	
	
	
Function creverINI()
	cDestino := "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
	lRetStatus:=EsperaResposta(cDestino)  
 BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
      SET SECTION "DANFE"  ENTRY "Modelo"  TO '1'
      SET SECTION "Geral"  ENTRY "DANFE"  TO '1'
    END INI
	MY_WAIT( 3 )    
return
	
	
	*--------------------------------------------------------------*
STATIC Function pega_chave_consulta()                     
*--------------------------------------------------------------*
local pchave :=alltrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 6))
local paCode :=ntrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local paserie:=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))
local aArqGet, x
Local nCounter:= 0
local ppchave:=""
Local oRow,ninfEventoId
Local i
Local oQuery
Local cQuery
local c_encontro
local R_CStat  :=""
local r_XMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()
local cNFe, cJus, cENT, cSAI, cTMP 
LOCAL cCmd, cRet
   
   
Reconectar_A() 

  oQuery:=oServer:Query( "SELECT CHAVE,MSCANCELAMENTO FROM nfce WHERE CbdNtfNumero = "+AllTrim(pACode)+" and CbdNtfSerie ="+(paserie)+" Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1146 " + oServer:Error() )
    Return Nil
  Endif
  	oRow          :=oQuery:GetRow(1)
If !Empty(oRow:fieldGet(2)) // 
   MsgInfo("Evento Já Registrado" , "ATENÇÃO")
  
CANCELA_NFe.RELEASE
janelanfe.RELEASE
RETURN(.F.)
EndIf	

	
	
If !Empty(pchave) // se nao encontra vale a pesq pro nota fiscal
   else
     MsgInfo("Nao Enntrado: " , "ATENÇÃO")
   Return .f. 
	 CANCELA_NFe.RELEASE   
 EndIf
  

ERASE "C:\ACBrNFeMonitor\sainfe.txt"



*NFe_CAN(pchave,cJus)
NFe_CON(pchave)




  cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
  lRetStatus:=EsperaResposta(cFileDanfe) 
   if lRetStatus==.t.  ////pego os dados
     end
cFileDanfe := 'C:\ACBrNFeMonitor\sainfe.txt'


////RETORNO////
BEGIN INI FILE cFileDanfe
       GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"

END INI


public  c_CStat   :=R_CStat
public C_XMotivo  :=R_XMotivo

 MSGINFO(C_XMotivo)

janelanfe.RELEASE
Return Nil




STATIC Function ConsultanfCe()
local pachave  :=alltrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 6))
local pnumero  :=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local pserie   :=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))

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
LOCAL c_CFileDanfe:="C:\ACBrNFEMonitor\"
local anomes:=""


NFe_CON(pachave)

BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI

public  c_CStat   :=cCStat
public c_cChNFe   :=cChNFe
public c_cNProt   :=cNProt
AUTO:=c_cNProt

*msginfo(cCStat)



if c_CStat="217"
msginfo(cXMotivo)
return(.f.)
endif


Reconectar_A() 

C_CbdNtfNumero:=SUBSTR(pachave, 44, 9)
C_CbdNtfNumero:=val(C_CbdNtfNumero)

XML           :=SUBSTR(pachave, 20, 55)
fxml          :="C:\ACBrNFeMonitor\"+xml
*msginfo(fxml)
ffxml         :=memoread(pachave)
   cQuery	:= oServer:Query( "UPDATE nfce SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE chave = " +(alltrim(pachave)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
EndIf

cQuery := "UPDATE NFCE SET AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+pserie+" "
*cQuery := "UPDATE NFCE SET AUTORIZACAO='"+AUTO+"' WHERE CHave = "+paChave+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+xCbdNtfSerie+" "

 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
/*
cQuery	:= oServer:Query( "UPDATE nfce SET AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = " +(ntrim(pnumero)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
EndIf
*/

RETURN
			



