/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-09 Roberto Lopez <harbourminigui@gmail.com>
 * http://harbourminigui.googlepages.com/
 *
 * Copyright 2003-2009 Grigory Filatov <gfilatov@inbox.ru>
*/


#include "minigui.ch"
#include "fileio.ch"

*--------------------------------------------------------*
Function Importar_XML_BancoDeDados_saida()
*--------------------------------------------------------*
x_Diretorio       :=DiskName()+":\"+CurDir()+"\"

IF .NOT. ISWINDOWDEFINED(Importa_XML)

DEFINE WINDOW Importa_XML AT 0 , 0 WIDTH 800 HEIGHT 530 TITLE "Importar XMLs" modal nosize

     ON KEY ESCAPE OF Importa_XML ACTION {|| Importa_XML.RELEASE}
  
 		DEFINE STATUSBAR	FONT 'Verdana' SIZE 7		
			STATUSITEM "Manutenção do Inventário"
		END STATUSBAR
		
      
    DEFINE TOOLBAR Toolbar_1 CAPTION "Toolbar_1" BUTTONSIZE 50,40 FONT "Arial" SIZE 9
            BUTTON Novo   CAPTION "&Abrir"   PICTURE "open" ACTION  {||f_importar_saida()}
            BUTTON Novo   CAPTION "&Gravar"   PICTURE "BMPGRAVA" ACTION  {||f_grava_saida("Importa_XML", "Grid_1")}
            BUTTON Sair   CAPTION "&Sair"   PICTURE "BMPRETORNA" ACTION  Importa_XML.release 
     END TOOLBAR

     DEFINE GRID Grid_1
            ROW    70
            COL    10
            WIDTH  770
            HEIGHT 400
            WIDTHS {765}
            HEADERS {'Column1'}
     END GRID  

END WINDOW
 

 
	CENTER WINDOW Importa_XML

	*** Ativa janela		
	ACTIVATE WINDOW Importa_XML

ELSE
   Importa_XML.MINIMIZE
   Importa_XML.RESTORE
ENDIF

//***************************************
static func f_importar_saida()

local varios := .t.   && selecionar varios arquivos
local arq_cas := {}, i, n_for, File_cas, m_rat,xQuant  

Public cCurDir := x_Diretorio

p_GetFile := cCurDir///iif( empty( p_GetFile ) , GetMyDocumentsFolder() , p_GetFile )

 
arq_cas := GetFile ( { ;
	{'Arquivo XML' , '*.XML'} },;
	'Abre Arquivos' , p_GetFile , varios , .t. )
 
if len( arq_cas ) = 0
	return nil
endif
  
  xQuant:=0 
  DELETE ITEM ALL FROM Grid_1 Of Importa_XML
  If Len(arq_cas) > 0
	for i = 1 to Len(arq_cas)
      ADD ITEM {arq_cas[i]  } TO Grid_1 Of Importa_XML
      xQuant++
      Importa_XML.StatusBar.Item(1) := " Selecionando Nota ["+ alltrim(str(xQuant))+"] "+  arq_cas[i]

	next
  EndIf

 	    Importa_XML.StatusBar.Item(1) := "["+alltrim(str(xQuant))+"] Notas Selecionadas"


Return
//***************************************
static func f_grava_saida(cParentForm , cControlName)

   Local i 
   Local Row
   Local ic := GetProperty ( cParentForm , cControlName , "ItemCount" )

   For Row := 1 to ic
     LerDanfe_SAIDA(_GetGridCellValue ( cControlName , cParentForm ,Row , 1 ))
   next
   
  DELETE ITEM ALL FROM Grid_1 Of Importa_XML
   
Return


//*********************************************
//------------------------------------------------------------
Static Function LerDanfe_saida(cFileDanfe)
 		  Local nCounter:= 0
Local oRow
Local i
local tot :=0
Local oQuery
local iRow 
local aRow
local pegacodigo1
local pegacodigo2
local pegacodigo3
local cWindow:='NFe'
local c_encontro
Local Estru     := {  {'Id'        ,'C', 44,0},;
                      {'ErroJAF'   ,'l', 01,0},;  //
                      {'Ocorrenc'  ,'C', 20,0},;  //
                      {'CNPJ'      ,'C', 14,0},;  //
                      {'cProd'     ,'C', 16,0},;
                      {'xProd'     ,'C', 60,0},;  // Codigo Interno
                      {'cEAN'      ,'C', 16,0},;
                      {'qCom'      ,'N', 13,3},;
                      {'vProd'     ,'N', 13,2},;
                      {'vUnCom'    ,'N', 11,3},;
                      {'vIcms'     ,'N', 11,3},;
                      {'vPis'      ,'N', 11,3},;
                      {'vCofins'   ,'N', 11,3},;
                      {'vIpi'      ,'N', 11,3} }



    If cFileDanfe==Nil
       msginfo('Informe o nome do Danfe em xml')
       Return nil
    Endif

    If ! file(cFileDanfe)
         msginfo('Arquivo nao Localizado'+cFileDanfe)
         Return nil
    Endif
   * Reconectar()


    cPegaChave := Space(47)
    Linha       := Memoread(cFileDanfe)
    nLinhalidas := 0
    Linhatotal  := Len(Linha)
    cLinhaTxt   :=Linha
    X_xml       :=LinhA
	
    //-- Pega Id da Nota Fiscal
    nPos1 := At('Id="',Linha)
    If nPos1==0
       msginfo('Erro no Arquivo '+cFileDanfe+Chr(10)+;
               'Id=')
       Return nil
    Endif
       nPos1 := nPos1+Len('Id="')
       cChave:= Substr(Linha,nPos1,47)
       m_cNF   := PegaDados('nNF'   ,Alltrim(Linha),.f. )
       m_serie := PegaDados('serie' ,Alltrim(Linha),.f. )
       m_dEmi  := PegaDados('dEmi'  ,Alltrim(Linha),.f. )
       m_Razao := PegaDados('xNome' ,Alltrim(Linha),.f. )
       m_vBC   := Val(PegaDados('vBC'   ,Alltrim(Linha),.f. ))
       m_vICMS := Val(PegaDados('vICMS' ,Alltrim(Linha),.f. ))
       m_vProd := Val(PegaDados('vProd' ,Alltrim(Linha),.f. ))
       m_vNF   := Val(PegaDados('vNF'   ,Alltrim(Linha),.f. ))
       m_vOutro:= Val(PegaDados('vOutro',Alltrim(Linha),.f. ))
	   
	   
	      cLidos1 := PegaDados('ICMSTot',Alltrim(cLinhaTxt),.t.,'ICMSTot')
       Linha1   := cLidos1
       
	  xvtotTrib   := PegaDados( [vtotTrib]	 ,Alltrim(Linha1) ,.f.)
     *  xNome     := PegaDados( [xNome]   ,Alltrim(Linha1),.f. )
     *  xLgr      := PegaDados( [xLgr]    ,Alltrim(Linha1),.f. )
     *  nro       := PegaDados( [nro]     ,Alltrim(Linha1),.f. )
      * xBairro   := PegaDados( [xBairro] ,Alltrim(Linha1),.f. )
     *  cMun      := PegaDados( [cMun]    ,Alltrim(Linha1),.f. )
     *  xMun      := PegaDados( [xMun]    ,Alltrim(Linha1),.f. )
     *  UF        := PegaDados( [UF]      ,Alltrim(Linha1),.f. )
     *  CEP       := PegaDados( [CEP]     ,Alltrim(Linha1),.f. )
     *  cPais     := PegaDados( [cPais]   ,Alltrim(Linha1),.f. )
     *  xPais     := PegaDados( [xPais]   ,Alltrim(Linha1),.f. )
    *   fone      := PegaDados( [fone]    ,Alltrim(Linha1),.f. )
    *   IE        := PegaDados( [IE]      ,Alltrim(Linha1),.f. )
	*   msginfo(m_cNF)
	   

	   //[DADOS DO EMITENTE]
       cLIDOS1:=[] ; LINHA1:=[]

       cLidos1 := PegaDados('emit',Alltrim(cLinhaTxt),.t.,'emit')
       Linha1   := cLidos1
       
	   cCGCEmit  := PegaDados( [CNPJ]	 ,Alltrim(Linha1) ,.f.)
       xNome     := PegaDados( [xNome]   ,Alltrim(Linha1),.f. )
       xLgr      := PegaDados( [xLgr]    ,Alltrim(Linha1),.f. )
       nro       := PegaDados( [nro]     ,Alltrim(Linha1),.f. )
       xBairro   := PegaDados( [xBairro] ,Alltrim(Linha1),.f. )
       cMun      := PegaDados( [cMun]    ,Alltrim(Linha1),.f. )
       xMun      := PegaDados( [xMun]    ,Alltrim(Linha1),.f. )
       UF        := PegaDados( [UF]      ,Alltrim(Linha1),.f. )
       CEP       := PegaDados( [CEP]     ,Alltrim(Linha1),.f. )
       cPais     := PegaDados( [cPais]   ,Alltrim(Linha1),.f. )
       xPais     := PegaDados( [xPais]   ,Alltrim(Linha1),.f. )
       fone      := PegaDados( [fone]    ,Alltrim(Linha1),.f. )
       IE        := PegaDados( [IE]      ,Alltrim(Linha1),.f. )
 
nitem:=0



*cQuery	:= oServer:Query( "UPDATE nfe20 SET CbdvProd_ttlnfe='"+(AllTrim(vprod))+"',CbdCNPJ_dest='"+(AllTrim(dest_CNPJ))+"',CbddEmi='"+(AllTrim(m_dEmi))+"',chave='"+(AllTrim(dest_chNFe))+"',nt_retorno='"+(AllTrim(ffxml))+"',CbdxNome_dest='"+dest_xNome+"' WHERE CbdNtfNumero = " +(alltrim(m_cNF)))
cQuery	:= oServer:Query( "UPDATE nfe20 SET nt_retorno='"+(AllTrim(X_xml))+"' WHERE CbdNtfNumero = " +(alltrim(m_cNF)))

 	If cQuery:NetErr()		
   *     MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
*Msginfo("ok")
EndIf

Return nil

//------------------------------------------------------

	