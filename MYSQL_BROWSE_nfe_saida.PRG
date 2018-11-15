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
function MYSQL_BROWSE_nfe_saida()
         
publ path :=DiskName()+":\"+CurDir() 
public m_ver := GetStartupFolder() + '\_cas_ver.JPG', p_GetFile := ''

nCbx1 := 0
aCbx1 := { "Nome", "Numero", "Cnpj","Codigo" }
cGet1 := Space( 10 )


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
	




    HB_LANGSELECT("PT") 
  	SET DATE BRITISH
	SET CENTURY ON             
	SET DELETE ON
	SET BROWSESYNC ON
	SET EPOCH TO 2010
	SET LANGUAGE TO PORTUGUESE  


   private cServidor, cUsuario, cSenha, cBanco, cTabela, vCabecalho := {} ,vLargura  := {}, vCampos := {}, cOrdem := ""
   
  private                                     cTabelaitens, vCabecalhoitens := {}, vLarguraitens := {}, vCampositens := {}, cOrdemitens := ""

   public oConexao
   
   
cHostName:= AllTrim(cHostName)
cUser    := AllTrim(cUser )
cPassWord:= AllTrim(cPassWord)
   
   
cServidor :=cHostName                         // Local de conexão
cUsuario  := cUser                               // Usuario
cSenha    := cPassWord                         // Senha do usuario
cBanco    := cnomedobanco                               // Banco de dados
  

    cTabela := "NFE20"                            // Tabela que será usada no browse
    vCabecalho:= {"Numero","Serie","nome","Cnpj","Cpf","data","CHAVE","nt_retorno","ARQUIVO_TXT","AUTORIZACAO","CANCELAMENTO","RETORNO_EVENTO"}
    vLargura := {80,50, 350,150,150,100,350,200,200,300,300,300}                       // Largura das colunas do Browse
 	vCampos  := {"CbdNtfNumero","CbdNtfSerie","CbdxNome_dest","CbdCNPJ_dest","CbdCPf_dest","CbddEmi","Chave","nt_retorno","ARQUIVO_TXT","AUTORIZACAO","MSCANCELAMENTO","NOTATXT"}
    cOrdem   := "CbddEmi"                                 // Browse Ordenado pela 2ª coluna nome do cliente
    	
    cTabelai   := "NFEITEM"                            // Tabela que será usada no browse
    vCabecalhoi:= {'Itens','NºNfe','Código','Produtos','Ncm','Cfop','Qtd','Unit','Total'}
    vLargurai  := {40,80,80,400,80,80,80,100,110}    	// Largura das colunas do Browse
     vCamposi  := {"CbdNtfNumero","CbdcProd","CbdxProd","CbdNCM" ,"CbdCFOP","CbdqCOM","CbdvUnCom","CbdvProd"}
     cOrdemi   := "CbdcProd"                                 // Browse Ordenado pela 2ª coluna nome do cliente
 
  // Funão de conexão com o MySQL
 
 Conecta (cServidor, cUsuario, cSenha, cBanco)
 
DEFINE WINDOW janelanfe;
      AT 00, 00 ;
         width Ajanela; 
         height Ljanela-40;
       TITLE "Notas Saida" ;
       MODAL;   
       NOSIZE
    
 @ 500,00  COMBOBOX oCbx1 ;
   WIDTH 108 HEIGHT 120 ;
   ITEMS  aCbx1;
   VALUE  1  ;
   FONT "Ms Sans Serif" SIZE 12.00

   
  @ 500,190 TEXTBOX oTb_Busca ;
    WIDTH 200 ;
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

			
  
	 DEFINE BUTTON Button_52
           ROW   600
           COL    00
           WIDTH  250
           HEIGHT 28
           CAPTION "Imprime_Evento"
          Action lerxml_CANCELAMNETO()                
     END BUTTON  

	 
	 DEFINE BUTTON Button_5422
           ROW   550
           COL    00
           WIDTH  150
           HEIGHT 28
           CAPTION "Conaultar nfe no Site"
           Action  ConsultanfeSITE()         
     END BUTTON 
	   
	 DEFINE BUTTON Button_5423
           ROW   550
           COL   200
           WIDTH  120
           HEIGHT 28
           CAPTION "Consultar nfe "
           Action    Consultanfe()
  
     END BUTTON  
	  	 DEFINE BUTTON Button_5433
           ROW   550
           COL   320
           WIDTH  120
           HEIGHT 28
           CAPTION "PEGA CHAVE "
           Action  ENCHE_CHAVE()
     END BUTTON  

	  	 DEFINE BUTTON Button_5439
           ROW  550
           COL   500
           WIDTH  120
           HEIGHT 28
           CAPTION "IMPORTAR XML "
		  Action  Importar_XML_BancoDeDados_saida_nfce_NFE()
      END BUTTON  
  
  
  

	 DEFINE BUTTON Button_542
           ROW   600
           COL    300
           WIDTH  250
           HEIGHT 28
           CAPTION "Imprime_carta_correção"
           Action   lerxml_cce_1()        
     END BUTTON  

  
  
    DEFINE BUTTON Button_3
           ROW   650
           COL    00
           WIDTH  100
           HEIGHT 28
           CAPTION "Voltar"
       Action  janelanfe.RELEASE
     END BUTTON  

 
  DEFINE BUTTON Button_reenviar
           ROW     650
           COL   110
           WIDTH 100
           HEIGHT 28
           CAPTION "Reenviar_xml"
           Action  reenviar()       
     END BUTTON  
	 
  DEFINE BUTTON Button_4
           ROW    650
           COL    220
           WIDTH  200
           HEIGHT 28
           CAPTION "Visualizar-Imprimir-NFe"
           Action  lerxml()         
     END BUTTON  

  DEFINE BUTTON Button_6
           ROW    650
           COL    420
           WIDTH  200
           HEIGHT 28
           CAPTION "Enviar Email "
           Action  enviar_xml()         
     END BUTTON  


		@ 660,650 LABEL tEnvio VALUE "" WIDTH 500      
		
	   // Browse para exebição dos dados da Tabela
  	   @ 35,00 MySQLBROWSE oBrw_Cliente ;
         WIDTH  AJANELA-10;
         HEIGHT 200 ;
         HEADERS vCabecalho ;
	     WIDTHS vLargura ;
      	 FIELDS vCampos ;
         ORDER BY cOrdem ;
         WORKAREA cTabela ;
         SOCKET oConexao;
		 FONT "Arial Baltic" ;
         SIZE 11 ;
         BOLD ;
	     ON CHANGE { acha_itens(),TOTAL() }
	
		   
		   
 DEFINE GRID Grid_itens
            ROW    235 
            COL    003  
           WIDTH  AJANELA-10
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



*--------------------------------------------------------------*
STATIC Function acha_anexo()                     
*--------------------------------------------------------------*
local pcode   := (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
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
oQuery := oServer:Query( "Select num_seq,nome,dc_anexo,TIPOARQ,nt_retorno,CHAVE,NF From anexo WHERE num_seq LIKE "+pcode+"" )
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
local pcode   := NTRIM(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
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

oQuery := oServer:Query( "Select CbdvProd_ttlnfe,CbdvDesc_ttlnfe,CbdvNF,MSCANCELAMENTO From NFE20 WHERE CbdNtfNumero LIKE "+pcode+" Order By CbddEmi" )
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
 *  local cProcura := alltrim (janelanfe.oTb_Busca.Value), oTime, nTotalReg
 *  local cProcura := alltrim (janelanfe.oTb_Busca.Value), oTime, nTotalReg
    cProcura  := str(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
  
 * msginfo(cProcura)

  if (len (cProcura) > 0)
     define TIMER oTime OF janelanfe INTERVAL 100 ACTION Gira()
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
*local pcnpj  := (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 3))
local pCode  := NTRIM(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))

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
 oQuery := oServer:Query( "Select CbdNtfNumero,CbdcProd,CbdxProd,CbdNCM ,CbdCFOP,CbdqCOM,CbdvUnCom,CbdvProd From NFEITEM WHERE CbdNtfNumero LIKE "+pcode+" Order By CbdxProd" )
	

For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
*msginfo((oRow:fieldGet(11)))

  REG=REG+1
  ADD ITEM { str(reg,4),str(oRow:fieldGet(1),11),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),str(oRow:fieldGet(5),8),transform((oRow:fieldGet(6)),"@R 99,999.99"),transform((oRow:fieldGet(7)),"@R 99,999.99"),transform((oRow:fieldGet(8)),"@R 99,999.99") } TO Grid_itens Of janelanfe
  oQuery:Skip(1)
Next
oQuery:Destroy()
Return Nil




//----------------------------------------------------------------------------//
// Funçao de Busca
//
static function Busca ()
   local cProcura := alltrim (janelanfe.oTb_Busca.Value), oTime, nTotalReg
   
if janelanfe.oCbx1.value == 1 //nº da OS
 
    if (len (cProcura) > 0)
*      define TIMER oTime OF janelanfe INTERVAL 100 ACTION Gira ()
      cProcura += iif (("*"$right (cProcura, 1)) .or. ("%"$right (cProcura, 1)), "", "%")
     _MySQL_BrowseSetWhere ("oBrw_Cliente", "janelanfe", "WHERE CbdxNome_dest LIKE "+'"'+cProcura+'"')
      nTotalReg := _MySQL_BrowseRefresh ("oBrw_Cliente", "janelanfe")   
      _MySQL_BrowseSetValue ("oBrw_Cliente", "janelanfe", 1)
	    iif (nTotalReg > 0, doMethod ("janelanfe", "oBrw_Cliente", "SetFocus"), doMethod ("janelanfe", "oTb_Busca", "SetFocus"))
*	doMethod ("janelanfe", "oTime", "release")
   else
      doMethod ("janelanfe", "oTb_Busca", "SetFocus")
  endif
  
ELSEIF janelanfe.oCbx1.value == 2
   if (len (cProcura) > 0)
*     define TIMER oTime OF janelanfe INTERVAL 100 ACTION Gira ()
     cProcura += iif (("*"$right (cProcura, 1)) .or. ("%"$right (cProcura, 1)), "", "")
      _MySQL_BrowseSetWhere ("oBrw_Cliente", "janelanfe", "WHERE CbdNtfNumero LIKE "+'"'+cProcura+'"')
      nTotalReg := _MySQL_BrowseRefresh ("oBrw_Cliente", "janelanfe")   
      _MySQL_BrowseSetValue ("oBrw_Cliente", "janelanfe", 1)
	   iif (nTotalReg > 0, doMethod ("janelanfe", "oBrw_Cliente", "SetFocus"), doMethod ("janelanfe", "oTb_Busca", "SetFocus"))
*    doMethod ("janelanfe", "oTime", "release")
   else
   doMethod ("janelanfe", "oTb_Busca", "SetFocus")
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

//----------------------------------------------------------------------------//
// Função de animação do botão Buscar
//
static function Gira ()
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



STATIC Function ConsultanfeSITE()
LOCAL cOrigem  := 'C:\ACBrMonitorplus\ent.txt' 
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
   cQuery	:= oServer:Query( "UPDATE nfe20 SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = " +(ntrim(C_CbdNtfNumero)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
EndIf
RETURN
			
			
			
*--------------------------------------------------------------*
STATIC Function Consultanfe()
*--------------------------------------------------------------*
*Local pachave:=(AllTrim((GetColValue( "Grid_notas", "janelanfe", 6))))
local  pachave:= alltrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 7))
local  panumero:= (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
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
local cUF:=""
local cCertificado:=""
LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt'


vNFE        := substr(pachave, 26, 09)
cSerie      :=val(SUBSTR(pachave,23,3))

oQuery        :=oServer:Query( "SELECT CHAVE,nt_retorno FROM NFE20 WHERE CbdNtfNumero = "+vNFE+" AND  CbdNtfSerie = "+NTRIM(cSerie)+"  Order By CbdNtfNumero" )
oRow          := oQuery:GetRow(1)
HANDLE :=  FCREATE ("C:\ACBrMonitorPLUS\"+pachave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  



IF   GERA_NFE_NFCE=1
//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+pachave+")")
///////////////////////////////////////////////////
MY_WAIT( 2 ) 
BEGIN INI FILE "C:\ACBrMonitorplus\SAI.TXT"
      GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI

public  c_CStat   :=cCStat
public c_cChNFe   :=cChNFe
public c_cNProt   :=cNProt
AUTO:=c_cNProt
c_XMotivo:='Evento registrado e vinculado a NF-e'
fxml:="C:\ACBrMonitorPLUS\"+cChNFe+"-nfe.xml"
ffxml    :=memoread(fxml)

vNFE        := substr(cChNFe, 26, 09)
cSerie      :=val(SUBSTR(cChNFe,23,3))
MY_WAIT( 1 ) 
   
IF c_CStat == "101"
cXml     :=Memoread(fxml)
 cQuery := "UPDATE NFE20 SET nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+((vNFE))+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 * MSGINFO("OK")
   Endif
 ENDIF



******************************************
ELSE //////consulta pela class
******************************************
oSefaz     := SefazClass():New()
BEGIN INI FILE "CERTIFICADO.ini"
  GET cCertificado  SECTION "NOME"   ENTRY "NOME"
  GET cUF   SECTION "Estado"   ENTRY "cUF"
END INI
 *****************************************************
 ******Consulta xml chave************************
 *****************************************************
   oSefaz: NFeConsultaProtocolo( pachave, cCertificado , cAmbiente )
  *  oSefaz: NFeConsultaRecibo(  pachave, cCertificado, cAmbiente )
  hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
 *  hbNFeDaNFe( oSefaz:cXmlAutorizado )
  * hb_MemoWrit( cXmlAutorizado, oSefaz:cXmlAutorizado )
 
 cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha),.f. )
 chNFe     := PegaDados('chNFe' ,Alltrim(Linha),.f. )
  
 msginfo(xcStat+","+xxmotivo +","+chNFe)
 * MsgInfo( iif( oSefaz:cStatus == "100", "Nota autorizada", "Nota Denegada"  ) )
 
public  c_CStat   :=xcStat
public c_cChNFe   :=cChNFe
public c_cNProt   :=cNProt
AUTO:=c_cNProt
c_XMotivo:='Evento registrado e vinculado a NF-e'
cXMotivo:=xxmotivo
ENDIF 


IF   GERA_NFE_NFCE=1
*msginfo(c_CStat)
if c_CStat="101"
*Msginfo(cXMotivo)
*c_XMotivo:='Evento registrado e vinculado a NF-e'
cQuery := "UPDATE NFE20 SET MSCANCELAMENTO  = '"+c_XMotivo+"' WHERE CbdNtfNumero = "+ntrim(panumero)+""
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
  Endif
endif
*msginfo(cXMotivo)





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
/*
* cQuery := "UPDATE NFCE SET CHAVE='"+cNovaChave+"' WHERE CbdNtfNumero = "+((vNFE))+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(cSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
 Endif
*/
 
xchave:= cNovaChave
ENDIF






if c_CStat="217"
msginfo(cXMotivo)
return(.f.)
endif
*msginfo(cXMotivo)
Reconectar_A() 

C_CbdNtfNumero:=SUBSTR(pachave, 44, 9)
C_CbdNtfNumero:=val(C_CbdNtfNumero)

XML           :=SUBSTR(pachave, 20, 55)
fxml          :="C:\ACBrNFeMonitor\"+xml
*msginfo(fxml)
ffxml         :=memoread(pachave)
   cQuery	:= oServer:Query( "UPDATE nfe20 SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE chave = " +(alltrim(pachave)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
EndIf



cQuery := "UPDATE NFE20 SET AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+ntrim(panumero)+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+"1"+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif

else

*****CLASS


endif


RETURN
			

  
*--------------------------------------------------------------*
STATIC Function lerxml()                   
*--------------------------------------------------------------*
local pacode        :=ntrim (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local xCbdNtfSerie   :=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))
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
    oQuery   :=oServer:Query( "SELECT CHAVE,nt_retorno FROM nfe20 WHERE CbdNtfNumero = "+AllTrim(pACode)+" AND  cbdmod= "+"55"+" and CbdNtfSerie = "+(xCbdNtfSerie)+"  Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
 oRow	          :=oQuery:GetRow(1)
 xchave           := oRow:FieldGet(1)	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
    
    
 HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
 FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"
 
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
	  
oDanfe:ToPDF(  Memoread( cTXT) , xchave+".pdf" )
cpdf:= xchave+".pdf" 
cArquivo:=cpdf
PDFOpen(cpdf)
*ENDIF

Return Nil


  
*--------------------------------------------------------------*
STATIC Function lerxml_cce_1()                      
*--------------------------------------------------------------*
local pacode   :=ntrim (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
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
LOCAL cOrigem  := 'C:\ACBrMonitorplus\ent.txt' 
LOCAL nHandle, fC_NORMAL
	 
   My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
  cQuery:= "select CHAVE,retorno_cce,CHAVE_EVENTO FROM carta_correcao  WHERE CbdNtfNumero = " + AllTrim(pACode)      
  oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("NÃO EXISTE CARTA DE CORREÇÃO EM ANEXO !!","Consultas")
  Return(.f.)
EndIf
    

*NCHAVE_EVENTO:=oRow:FieldGet(3)
NCHAVE_EVENTO:=SUBSTR(oRow:FieldGet(3),0,66)

NCHAVE_EVENTO:=ALLTRIM(NCHAVE_EVENTO)	
	
	
HANDLE :=  FCREATE (NCHAVE_EVENTO,0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\"+NCHAVE_EVENTO
	
		   
*FWRITE(Handle,"NFe.ImprimirEvento("+cTXT+")")
 *FCLOSE(Handle) 

			   

     
	 ERASE "C:\ACBrNFeMonitor\sai.txt"
	 
        IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
           MsgInfo("File cannot be created:","ENT.TXT")
           Return
        ENDIF 

		FWRITE(nHandle,'NFe.ImprimirEvento("'+cTXT+'")')
      FCLOSE(nHandle) 

Return Nil

*--------------------------------------------------------------*
STATIC Function lerxml_CANCELAMNETO()                      
*--------------------------------------------------------------*
local pacode   :=  ntrim (_MySQL_BrowseGetCol ("oBrw_Cliente","janelanfe", 1))
Local paserie  := AllTrim(_MySQL_BrowseGetCol ("oBrw_Cliente","janelanfe", 2))

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
LOCAL cOrigem  := 'C:\ACBrMonitorplus\ent.txt' 
LOCAL nHandle, fC_NORMAL
	
Reconectar_A() 
oQuery:=oServer:Query( "SELECT CHAVE,notatxt,nt_retorno FROM nfe20 WHERE CbdNtfNumero = "+AllTrim(pACode)+" and CbdNtfSerie ="+(paserie)+" Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
  	oRow          :=oQuery:GetRow(1)
	cchave        :=alltrim(oRow:fieldGet(1))
    Cbdcheveevento:=alltrim(oRow:fieldGet(2))
   	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("NÃO EXISTE ANEXO !!","Consultas")
  Return(.f.)
EndIf

   ///////////////////////////////////////////////////
MY_WAIT( 2 )
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(3))
fclose(handle)  
public cXML_NOTA         :=PATH+"\NOTA.XML"
public cTXT              :=PATH+"\NOTA.XML"
    
NCHAVE_EVENTO:=SUBSTR(oRow:FieldGet(1),0,44)
NCHAVE_EVENTO:=ALLTRIM(NCHAVE_EVENTO)	
HANDLE :=  FCREATE (NCHAVE_EVENTO,0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cXml     :=PATH+"\"+NCHAVE_EVENTO

   cRet := MON_ENV("NFe.ImprimirEventoPDF("+cXml+","+cXML_NOTA+")")
   MY_WAIT( 2  ) 
  cRet := MON_ENV("NFe.ImprimirEvento("+cXml+","+cXML_NOTA+")")


  Imprimir_Evento_Danfe( cXML, cChave ,cXML_NOTA)
  
  
/*

     numero:= substr(cXml , 0, 48)
     oDanfe     := hbnfeDaEvento():New()
      RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
    * oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
     *oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  

*oDanfe:ToPDF(  Memoread( cXml ) , numero+".pdf" )
oDanfe:ToPDF(  Memoread( cXml ) , numero+".pdf", cXML_NOTA )
cteste:= numero+".pdf" 
PDFOpen(cteste)
*/

Return Nil






*--------------------------------------------------------------*
STATIC Function enviar_xml()                   
*--------------------------------------------------------------*
local pacode   :=ntrim (_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local xnome    :=AllTrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 3))
local Serie_nfe   :=AllTrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 2))

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
local path   :=DiskName()+":\"+CurDir()
local expath :=DiskName()+":\"+CurDir()

	oQuery   :=oServer:Query( "SELECT CHAVE,nt_retorno FROM nfe20 WHERE CbdNtfNumero = "+AllTrim(pACode)+" AND  cbdmod= "+"55"+" and CbdNtfSerie = "+(Serie_nfe)+"  Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
   oRow	          :=oQuery:GetRow(1)
 xcHAVE:=alltrim(oRow:FieldGet(1))
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
 HANDLE :=  FCREATE (xcHAVE+".XML",0)// cria o arquivo
 FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\"+xcHAVE+".XML"
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
cEnviaPDF:="1"
cArqXMLEvento:=cTXT
cEmailDestino:=eemail

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
	  
oDanfe:ToPDF(  Memoread( cTXT) , xchave+".pdf" )
cpdf:= xchave+".pdf" 
 

cXml_envia    :=PATH+"\"+xcHAVE+".xml"
ffxml_envia   :=Memoread(cXml_envia)
ARQEVENTO     :=PATH+"\"+xcHAVE+".xml"
 
	     SetProperty('janelanfe','tEnvio','Value','ENVIADANDO EMAIL')
        SetProperty('janelanfe','tEnvio','BLINK',.T.)


cString:="PDF ok Impressão  ok" 


Envia_Email('1', ARQEVENTO, ' ')

Email:="Enviado para....:"+  cEmailDestino
HB_Cria_Log_nfe(cString,Email)



fQuery:Destroy()
Return Nil



STATIC FUNCTION enche_chave()  
Local oQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()
LOCAL cChNFe :=""
local anomes:=""
Local lRet:=.t.
LOCAL c_CFileDanfe:=""
cFileDanfe:="C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
xANO     := dtoS(date())
xANO     :=ALLTRIM(SUBSTR(XANO,0,6))


BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathNFe"
END INI
public  cCFileDanfe   :=c_CFileDanfe
X_pathacbr:=cCFileDanfe+"\"+"NFe"+"\"+xANO+"\"+"NFe"+"\"
            
*msginfo(X_pathacbr)

     
Reconectar_A() 

	
	  
aArqCli   := Array( ADir( alltrim(X_pathacbr )+'*-nfe.XML' ) )
aDirCli   := ADir( alltrim(X_pathacbr)+'*-nfe.XML', aArqCli )
TOTAL_ARQ := Len( aArqCli )


TOTAL_ARQ := Len( aArqCli )

COPIADOS  := 0
for pqrs  := 1 to Len( aArqCli )
    vNFE      := substr( aArqCli[pqrs] , 26, 09)
    vserie   := substr( aArqCli[pqrs] , 23, 3)
  
 vCHAVENFE := substr( aArqCli[pqrs] , 01, 44)
     vNFE:=val(vNFE)
    vMODELO := substr(vCHAVENFE,21,2)

*msginfo(vserie)
vserie:=val(vserie)
*msginfo(vMODELO  )

XML:=vCHAVENFE
NFe_CON(XML)


fxml:=X_pathacbr+xml+"-nfe.xml"



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

ffxml:=memoread(fxml)
*msginfo(ffxml)


     
*msginfo(cXMotivo)
IF c_CStat="101"
c_XMotivo:='Evento registrado e vinculado a NF-e'
ELSE
c_XMotivo:=''
ENDIF
 IF VMODELO="55"
          
cQuery := "UPDATE NFE20 SET MSCANCELAMENTO  = '"+c_XMotivo+"', AUTORIZACAO='"+AUTO+"',CHAVE='"+vCHAVENFE+"', nt_retorno='"+ffxml+"' WHERE CbdNtfNumero = "+ntrim(vNFE)+" AND cbdmod= "+"55"+" and CbdNtfSerie = "+"1"+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
    ELSE
* MSGINFO("OK")
  Endif
  ENDIF
Next
RETU





*--------------------------------------------------------------*
STATIC Function reenviar()
*--------------------------------------------------------------*
local pnumero   :=(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 1))
local pTEXTE   :=AllTrim(_MySQL_BrowseGetCol ("oBrw_Cliente" , "janelanfe", 8))
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


oQuery        :=oServer:Query( "SELECT CHAVE,nt_retorno,ARQUIVO_TXT FROM NFE20 WHERE CbdNtfNumero = "+NTRIM(pnumero)+"  Order By CbdNtfNumero" )
oRow          := oQuery:GetRow(1)
xchave        :=ALLTRIM(oRow:FieldGet(1))
HANDLE :=  FCREATE ("nota.TXT",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(3) )
FWRITE(Handle,RETORNO)
fclose(handle)  

PUBLIC Destinotxt :=PATH+"\nota.TXT"
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
fxml:="C:\ACBrMonitorPLUS\"+xchavenfce+"-nfe.xml"
ffxml    :=memoread(fxml)
//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+xchavenfce+")")
///////////////////////////////////////////////////
MY_WAIT( 1 ) 
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
endif



if c_CStat="217"
 XMotivo=cXMotivo
endif


if c_CStat="100"
*MsgInfo("ok tem")
cQuery := "UPDATE NFE20 SET nt_retorno= '"+(AllTrim(ffxml))+"', CHAVE='"+xchavenfce+"',AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+""
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
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
	  
oDanfe:ToPDF(  Memoread( fxml) , xchavenfce+".pdf" )
cpdf:= xchavenfce+".pdf" 
cArquivo:=cpdf
PDFOpen(cpdf)
else
*MsgInfo("nao tem")
 *************************************************************
nnfe:=ntrim(pnumero)
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
cQuery := "UPDATE NFE20 SET nt_retorno= '"+(AllTrim(ffxml))+"',CHAVE='"+xchavenfce+"',AUTORIZACAO='"+c_NProt+"' WHERE CbdNtfNumero = "+ntrim(pnumero)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
endif
RETURN
			
