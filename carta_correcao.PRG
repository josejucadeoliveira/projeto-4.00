#INCLUDE "MINIGUI.CH"
#Include "MGI.ch"
#include "i_mBrowse.ch"
#include "FastRepH.CH"
 
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 183,255,255 )
#define CLR_NBROWN  RGB( 130, 99, 53)

#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )

#define clrNormal   {255,255,255}
#define clrBack     {255,255,200}


function carta_correcao_55()

	*** Cria Formulário
    DEFINE WINDOW FormEmissorCCE AT 00,00 ;
	WIDTH 800 HEIGHT 650;
	TITLE 'Carta de Correção 	NF-e';
	MODAL NOSIZE NOSYSMENU FONT 'Arial' SIZE 10   

     ON KEY ESCAPE     OF FormEmissorCCE ACTION { || FormEmissorCCE.RELEASE } 
 		DEFINE STATUSBAR FONT 'Verdana' SIZE 7	
            statusitem 'Foumulário de Correção da NF-e'
  	END STATUSBAR
		
       * on key F3 action Calendario()

	   
	  
	  
	  

 DEFINE LABEL tNotaFiscal1
            ROW    10
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Número"
     END LABEL 
	 
 
		 DEFINE TEXTBOX tNotaFiscal
               ROW    10
               COL   125
               WIDTH  120
               HEIGHT 24
               VALUe 0
               BACKCOLOR {255,255,128}
               INPUTMASK "9999999"
               NUMERIC  .T.
               ON GOTFOCUS This.BackColor:=clrBack 
               ON LOSTFOCUS This.BackColor:=clrNormal 
	           FONTNAME 'Arial'
               FONTSIZE 12
               RIGHTALIGN .T.
             
        END TEXTBOX 
		
		
 DEFINE LABEL tNotaserie
            ROW    10
            COL    300
            WIDTH  57
            HEIGHT 24
            VALUE "Serie"
     END LABEL 
	 
	 
 
		 DEFINE TEXTBOX txtserie
               ROW    10
               COL   350
               WIDTH  80
               HEIGHT 24
               VALUe 0
               BACKCOLOR {255,255,128}
               INPUTMASK "999"
               NUMERIC  .T.
               ON GOTFOCUS This.BackColor:=clrBack 
               ON LOSTFOCUS This.BackColor:=clrNormal 
	           FONTNAME 'Arial'
               FONTSIZE 12
               RIGHTALIGN .T.
              on ENTER CarregaDadosCCE()
        END TEXTBOX 
		
 
 
	 
     DEFINE LABEL Label_1
            ROW    60
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Chave"
     END LABEL  

     DEFINE LABEL Label_2
            ROW    60
            COL    80
            WIDTH  479
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
		    VALUE 0
    		FONTSIZE 12
     END LABEL  

     DEFINE LABEL Label_seq
            ROW    60
            COL    570
            WIDTH  60
            HEIGHT 24
            VALUE "Sequencia"
     END LABEL  
/*
     DEFINE LABEL Label_seq1
            ROW    60
            COL    640
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE 2
    		FONTSIZE 12
 			RIGHTALIGN .T.
     END LABEL  
*/

		 DEFINE TEXTBOX Label_seq1
               ROW    60
               COL   640
               WIDTH  80
               HEIGHT 24
               VALUe 0
               BACKCOLOR {255,255,128}
               INPUTMASK "999"
               NUMERIC  .T.
               ON GOTFOCUS This.BackColor:=clrBack 
               ON LOSTFOCUS This.BackColor:=clrNormal 
	           FONTNAME 'Arial'
               FONTSIZE 12
               RIGHTALIGN .T.
            END TEXTBOX 
		

     DEFINE LABEL Label_3
            ROW    90
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Modelo"
     END LABEL  

     DEFINE LABEL Label_4
            ROW    90
            COL    80
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""	
     END LABEL  

     DEFINE LABEL Label_5
            ROW    90
            COL    210
            WIDTH  57
            HEIGHT 24
            VALUE "Série"
     END LABEL  

     DEFINE LABEL Label_6
            ROW    90
            COL    270
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""
			RIGHTALIGN .T.
     END LABEL  

     DEFINE LABEL Label_7
            ROW    90
            COL    400
            WIDTH  57
            HEIGHT 24
            VALUE "Emissão"
     END LABEL  

     DEFINE LABEL Label_8
            ROW    90
            COL    460
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""
 			RIGHTALIGN .T.
    END LABEL  

     DEFINE LABEL Label_9
            ROW    120
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Número"
     END LABEL  

     DEFINE LABEL Label_10
            ROW    120
            COL    80
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE 0
			RIGHTALIGN .T.
     END LABEL  

     DEFINE LABEL Label_11
            ROW    150
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Cliente"
     END LABEL  

     DEFINE LABEL Label_12
            ROW    150
            COL    80
            WIDTH  377
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""
     END LABEL  

     DEFINE LABEL Label_13
            ROW    150
            COL    460
            WIDTH  120
            HEIGHT 24
            VALUE "Valor da Nota"
     END LABEL  

     DEFINE LABEL Label_14
            ROW    150
            COL    590
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""
			RIGHTALIGN .T.
     END LABEL  

     DEFINE FRAME Frame_2
            ROW    190
            COL    10
            WIDTH  761
            HEIGHT 221
            CAPTION "Correções (no mínimo 15 caracteres)"
     END FRAME  

     DEFINE EDITBOX Edit_1
            ROW    220
            COL    20
            WIDTH  742
            HEIGHT 188
			 HSCROLLBAR .F.
    		ON CHANGE {|| IF( LEN(ALLTRIM(This.Value))>=15,FormEmissorCCE.ButtonEX_1.enabled:=.t.,FormEmissorCCE.ButtonEX_1.enabled:=.f.)}
     END EDITBOX  


     DEFINE LABEL Label_15
            ROW    430
            COL    10
            WIDTH  759
            HEIGHT 33
            VALUE "A Carta de Correção é disciplina pelo $ 1º-A do art. 7º do Convenio S/N, de 15 de dezembro de 1970 e pode ser utilizada para regularização de erro na emissão de documento fiscal, desde que o erro não esteja relacionado com:"
            FONTCOLOR {255,0,0}
     END LABEL  

     DEFINE LABEL Label_16
            ROW    460
            COL    10
            WIDTH  761
            HEIGHT 33
            VALUE "I - as variáveis que determinam o valor do imposto tais como: base de cálculo, diferença de preço, quantidade, valor da operaçao ou da prestação;"
            FONTCOLOR {255,0,0}
     END LABEL  

     DEFINE LABEL Label_17
            ROW    500
            COL    10
            WIDTH  759
            HEIGHT 21
            VALUE "II - a correção de dados cadastrais que implique mudança do remente ou do destinário;"
            FONTCOLOR {255,0,0}
     END LABEL  

     DEFINE LABEL Label_18
            ROW    530
            COL    10
            WIDTH  759
            HEIGHT 22
            VALUE "III - a data de emissão ou de saida."
            FONTCOLOR {255,0,0}
     END LABEL  

     DEFINE BUTTONEX ButtonEX_1
            ROW    560
            COL    10
            WIDTH  120
            HEIGHT 24
            CAPTION "&Confirma"
				ACTION {||Envia_CCe1_ACBR()}
     END BUTTONEX  

	 
	 /*
DEFINE BUTTON Button_42332
           ROW    560
           COL    150
           WIDTH  120
           HEIGHT 28
           CAPTION "IMPRIMIR EVENTO"
           Action   {|| IMPRIMIR_EVENTO1()}
		   
     END BUTTON  
				
			*/	
				
	 
	 
     DEFINE BUTTONEX ButtonEX_2
            ROW    560
            COL    300
            WIDTH  120
            HEIGHT 24
            CAPTION "&Cancela"
  			ACTION FormEmissorCCE.RELEASE
	  END BUTTONEX  
 
  
END WINDOW

   FormEmissorCCE.ButtonEX_1.enabled:=.f.
   CENTER WINDOW FormEmissorCCE
   ACTIVATE WINDOW FormEmissorCCE

return

function Envia_CCe1_ACBR
* // Gera e envia carta de correção para WebService
        LOCAL cQuery, i
        LOCAL cLocalCCE, cLocalXML, cLocalPDF
		local path     :=DiskName()+":\"+CurDir()
        LOCAL cCorr       := RemoveAcento(FormEmissorCCE.Edit_1.value)       // Retira os acentos do Texto
        LOCAL cAux        := FormEmissorCCE.tNotaFiscal.Value               // Numero Nota para Localização 8 pos
        LOCAL cChave      :=alltrim(FormEmissorCCE.Label_2.Value)                    // Numero da Chave de Acesso
        LOCAL cCertificado:= ''                                                      // Nome do Certificado
        LOCAL oSefaz                                                                 // Variável de Objecto
        LOCAL cRetornoCCE := ''                                                      // Retorno do XML
		LOCAL cUF
		LOCAL mgCODESTADO:=11
		local mgCNPJ:="84712611000152"
        LOCAL cConcate    := 'OK:'+HB_EOL()+'*// Carta de Correção //*'+HB_EOL()     
        LOCAL aArrayXML   := {}     
        Local numero:=ntrim(FormEmissorCCE.tNotaFiscal.value)
        Local xserie:=ntrim(FormEmissorCCE.txtserie.value)		// Array com arquivos xmls 
  	
		nSeqEvento:=(FormEmissorCCE.Label_seq1.Value+1)


cLocalXML:=DiskName()+":\"+CurDir()+"\092017-NFE\"
aArrayXML:=Directory(cLocalXML+"*-nfe.xml")        
cLocalCCE:="Carta_correcao.procEventoNFe.xml"


	
		EVENT:=LPAD(str((nSeqEvento)),3,[0])
		
	
		 DADOS_CCe:={}                    
		 aadd(DADOS_CCe,{'NFE.CARTADECORRECAO("[CCE]'})
		 aadd(DADOS_CCe,{'idLote=1'})
	   	aadd(DADOS_CCe,{'[EVENTO001]'})
	   * aadd(DADOS_CCe,{'[EVENT'+EVENT]'})
		 aadd(DADOS_CCe,{'chNFe='+cChave})
		 aadd(DADOS_CCe,{'cOrgao='+Alltrim(str(mgCODESTADO))})
		 aadd(DADOS_CCe,{'CNPJ='+(mgCNPJ)})
		 aadd(DADOS_CCe,{'dhEvento='+dtoc(DATE())+' '+time()})
		 aadd(DADOS_CCe,{'tpEvento=110110' })
		 aadd(DADOS_CCe,{'nSeqEvento='+NTRIM(nSeqEvento)})
		 aadd(DADOS_CCe,{'xCorrecao='+alltrim(cCorr)+'")'})

			handle:=fcreate("C:\ACBrMonitorPLUS\ent.txt")
			for i=1 to len(DADOS_CCe)
				fwrite(handle,alltrim(DADOS_CCe[i,1]))
				      fwrite(handle,chr(13)+chr(10))
			next
			fclose(handle)  

			HANDLE :=  FCREATE (path+"\CCE.TXT",0)// cria o arquivo
	for i=1 to len(DADOS_CCe)
		fwrite(handle,alltrim(DADOS_CCe[i,1]))
        fwrite(handle,chr(13)+chr(10))
	next
fclose(handle)  
public CCE     :=PATH+"\CCE.TXT"


************************************************************  
  Ret       := MON_ENV("NFe.EnviarEvento("+CCE+","+''+")")
**************************************************************

MY_WAIT( 1) 

cRet      := MON_ENV('NFE.GetPathCCE()')

MY_WAIT( 1) 

bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xpathcancelamento  :=SUBSTR(variavel1,4,54)
PathEvento:=alltrim(xpathcancelamento)
PathEvento:=PathEvento+"\"

cPesqEVENT  :="110110"+cChave+LPAD(NTRIM((nSeqEvento)),2,[0])
ccPesqEVENT :=cPesqEVENT

public cXML_NOTA    :=PATH+"\"+cchave+".XML"
CFileSaida         := PathEvento+cPesqEVENT+"-procEventoNFe.XML"
*cRet := MON_ENV("NFe.ImprimirEventoPDF("+CFileSaida+","+cXML_NOTA+")")
*MY_WAIT( 2  ) 
*cRet := MON_ENV("NFe.ImprimirEvento("+CFileSaida+","+cXML_NOTA+")")

    cXml  :=CFileSaida
      
      oDanfe:= hbnfeDaEvento():New()
      RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  oPDF := hbnfeDaNfe():New()
    *  oDanfe := hbNFeDaGeral():New()
      oPDF:SetEanOff()
	  
cChave:=ALLTRIM(cChave)
ffxml:=ALLTRIM(cXML_NOTA)


       oPDF:ToPDF(  Memoread( cXML) , cChave+".pdf", ffxml )
       oDanfe:ToPDF(  Memoread( cXml ) , cChave+".pdf" )
    	Imprimir_Evento_Danfe( cXml, Cchave,cXML_NOTA ) 
	
	
cQuery := "UPDATE NFE20 SET nSeqEvento  = '"+ntrim(nSeqEvento)+"' WHERE CbdNtfNumero = "+numero+" and CbdNtfSerie ="+(xserie)+" Order By CbdNtfNumero" 
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
 
nSeqEvento   :=val(FormEmissorCCE.Label_seq1.Value)
xCbdNtfNumero:=ntrim(FormEmissorCCE.tNotaFiscal.value)
* cQuery :="INSERT INTO Carta_Correcao (MODELO,CbdNtfNumero,CHAVE,retorno_cce,nt_retorno) VALUES ('"+"65"+"','"+xCbdNtfNumero+"','"+cCHAVE+"','"+ALLTRIM(ffxml)+"','"+cXMotivo+"' )" 
  cQuery :="INSERT INTO Carta_Correcao (MODELO,CbdNtfNumero,CHAVE,retorno_cce,nt_retorno) VALUES ('"+"55"+"','"+xCbdNtfNumero+"','"+cChave+"','"+ALLTRIM(ffxml)+"','"+cXMotivo+"' )" 
 	   	 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
           MsgInfo("Por Favor Selecione o registro SS 438 PROPLEMA")
 	    	RETURN NIL
		else
	* msginfo("ok")
	EndIf

FormEmissorCCE.Release
return






* // Carrega os dados da Nota Fiscal para geração da Carta de Correção
STATIC Function CarregaDadosCCE()
local aArqGet, x
Local nCounter:= 0
local ppchave:=""
Local oRow,ninfEventoId
Local i
Local oQuery
Local cQuery
local c_encontro
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()
local cNFe, cJus, cENT, cSAI, cTMP 
LOCAL cCmd, cRet
Local numero:=ntrim(FormEmissorCCE.tNotaFiscal.value)
Local xserie:=ntrim(FormEmissorCCE.txtserie.value)
Local i_CStat:=""
Public i_XMotivo:=""
Public i_NProt:=""
PUBLIC cCStat   :=""	
*oQuery := oServer:Query( "Select CbdNtfNumero,CbddEmi,CHAVE,CbdxNome_dest,CbdCNPJ_dest From nfe20 WHERE CbdNtfNumero = "+AllTrim(numero)+" and CbdNtfSerie ="+(xserie)+" Order By CbdNtfNumero" )
oQuery := oServer:Query( "Select CbdNtfNumero,CbddEmi,CHAVE,CbdxNome_dest,CbdCNPJ_dest,nSeqEvento,nt_retorno From nfe20 WHERE CbdNtfNumero = "+AllTrim(numero)+" and CbdNtfSerie ="+(xserie)+" Order By CbdNtfNumero" )
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0

For i     := 1 To oQuery:LastRec()
oRow      := oQuery:GetRow(1)
c_chave   :=ALLTRIM(oRow:fieldGet(3))
nSeqEvento:=oRow:fieldGet(6)
nSeqEvento:=nSeqEvento
              MODIFY CONTROL Label_seq1  OF FormEmissorCCE  Value   ''+TransForm(nSeqEvento , "@R 9999")
              FormEmissorCCE.Label_2.Value       := c_chave
			  

HANDLE :=FCREATE (PATH+"\"+c_chave+".XML",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(7) )
FWRITE(Handle,RETORNO)
fclose(handle)  
public cXML_NOTA    :=PATH+"\"+c_chave+".XML"
			  
			  
			  
 oQuery:Skip(1)
  Next
oQuery:Destroy()
Return


Function ImprimeDadosCCE()
        LOCAL cOrigem  := 'C:\ACBrMonitorplus\ent.txt' 
        LOCAL nHandle, cQuery,FC_NORMAL
        LOCAL cAuxCCe  := Getfile ( { {'Arquivos','*.xml'} } , 'Carregar XML da Carta Correção' , 'c:\' , .f. , .t. )
     *   LOCAL cAuxNFe  := Getfile ( { {'Arquivos','*.xml'} } , 'Carregar XML da Nota Fiscal' , 'c:\ACBrMonitorplus\' , .f. , .t. )
*       // Apaga Logs anteriores
        ERASE "C:\ACBrMonitorplus\sai.txt"
        IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
           MsgInfo("File cannot be created:","ENT.TXT")
           Return
        ENDIF 
 *   FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'"')
     FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'")')
      FCLOSE(nHandle) 

  Return
		
		
		

function carta_correcao_65()

	*** Cria Formulário
    DEFINE WINDOW FormEmissorCCE AT 00,00 ;
	WIDTH 800 HEIGHT 650;
	TITLE 'Carta de Correção 	NF-e';
	MODAL NOSIZE NOSYSMENU FONT 'Arial' SIZE 10   

     ON KEY ESCAPE     OF FormEmissorCCE ACTION { || FormEmissorCCE.RELEASE } 


 		DEFINE STATUSBAR FONT 'Verdana' SIZE 7	
            statusitem 'Foumulário de Correção da NF-e'
  	END STATUSBAR
		
     	  

 DEFINE LABEL tNotaFiscal1
            ROW    10
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Número"
     END LABEL 
	 
 
		 DEFINE TEXTBOX tNotaFiscal
               ROW    10
               COL   125
               WIDTH  120
               HEIGHT 24
               VALUe 0
               BACKCOLOR {255,255,128}
               INPUTMASK "9999999"
               NUMERIC  .T.
               ON GOTFOCUS This.BackColor:=clrBack 
               ON LOSTFOCUS This.BackColor:=clrNormal 
	           FONTNAME 'Arial'
               FONTSIZE 12
               RIGHTALIGN .T.
             
        END TEXTBOX 
		
		
 DEFINE LABEL tNotaserie
            ROW    10
            COL    300
            WIDTH  57
            HEIGHT 24
            VALUE "Serie"
     END LABEL 
	 
	 
 
		 DEFINE TEXTBOX txtserie
               ROW    10
               COL   350
               WIDTH  80
               HEIGHT 24
               VALUe 0
               BACKCOLOR {255,255,128}
               INPUTMASK "999"
               NUMERIC  .T.
               ON GOTFOCUS This.BackColor:=clrBack 
               ON LOSTFOCUS This.BackColor:=clrNormal 
	           FONTNAME 'Arial'
               FONTSIZE 12
               RIGHTALIGN .T.
              on ENTER CarregaDadosCCE2()
        END TEXTBOX 
		
 
 
	 
     DEFINE LABEL Label_1
            ROW    60
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Chave"
     END LABEL  

     DEFINE LABEL Label_2
            ROW    60
            COL    80
            WIDTH  479
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
		    VALUE 0
    		FONTSIZE 12
     END LABEL  

     DEFINE LABEL Label_seq
            ROW    60
            COL    570
            WIDTH  60
            HEIGHT 24
            VALUE "Sequencia"
     END LABEL  

     DEFINE LABEL Label_seq1
            ROW    60
            COL    640
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE 0
    		FONTSIZE 12
 			RIGHTALIGN .T.
     END LABEL  

     DEFINE LABEL Label_3
            ROW    90
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Modelo"
     END LABEL  

     DEFINE LABEL Label_4
            ROW    90
            COL    80
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""	
     END LABEL  

     DEFINE LABEL Label_5
            ROW    90
            COL    210
            WIDTH  57
            HEIGHT 24
            VALUE "Série"
     END LABEL  

     DEFINE LABEL Label_6
            ROW    90
            COL    270
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""
			RIGHTALIGN .T.
     END LABEL  

     DEFINE LABEL Label_7
            ROW    90
            COL    400
            WIDTH  57
            HEIGHT 24
            VALUE "Emissão"
     END LABEL  

     DEFINE LABEL Label_8
            ROW    90
            COL    460
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""
 			RIGHTALIGN .T.
    END LABEL  

     DEFINE LABEL Label_9
            ROW    120
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Número"
     END LABEL  

     DEFINE LABEL Label_10
            ROW    120
            COL    80
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE 0
			RIGHTALIGN .T.
     END LABEL  

     DEFINE LABEL Label_11
            ROW    150
            COL    20
            WIDTH  57
            HEIGHT 24
            VALUE "Cliente"
     END LABEL  

     DEFINE LABEL Label_12
            ROW    150
            COL    80
            WIDTH  377
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""
     END LABEL  

     DEFINE LABEL Label_13
            ROW    150
            COL    460
            WIDTH  120
            HEIGHT 24
            VALUE "Valor da Nota"
     END LABEL  

     DEFINE LABEL Label_14
            ROW    150
            COL    590
            WIDTH  120
            HEIGHT 24
            FONTBOLD .T.
            BACKCOLOR {0,255,255}
            FONTCOLOR {0,0,0}
            BORDER .T.
			VALUE ""
			RIGHTALIGN .T.
     END LABEL  

     DEFINE FRAME Frame_2
            ROW    190
            COL    10
            WIDTH  761
            HEIGHT 221
            CAPTION "Correções (no mínimo 15 caracteres)"
     END FRAME  

     DEFINE EDITBOX Edit_1
            ROW    220
            COL    20
            WIDTH  742
            HEIGHT 188
			 HSCROLLBAR .F.
    		ON CHANGE {|| IF( LEN(ALLTRIM(This.Value))>=15,FormEmissorCCE.ButtonEX_1.enabled:=.t.,FormEmissorCCE.ButtonEX_1.enabled:=.f.)}
     END EDITBOX  


     DEFINE LABEL Label_15
            ROW    430
            COL    10
            WIDTH  759
            HEIGHT 33
            VALUE "A Carta de Correção é disciplina pelo $ 1º-A do art. 7º do Convenio S/N, de 15 de dezembro de 1970 e pode ser utilizada para regularização de erro na emissão de documento fiscal, desde que o erro não esteja relacionado com:"
            FONTCOLOR {255,0,0}
     END LABEL  

     DEFINE LABEL Label_16
            ROW    460
            COL    10
            WIDTH  761
            HEIGHT 33
            VALUE "I - as variáveis que determinam o valor do imposto tais como: base de cálculo, diferença de preço, quantidade, valor da operaçao ou da prestação;"
            FONTCOLOR {255,0,0}
     END LABEL  

     DEFINE LABEL Label_17
            ROW    500
            COL    10
            WIDTH  759
            HEIGHT 21
            VALUE "II - a correção de dados cadastrais que implique mudança do remente ou do destinário;"
            FONTCOLOR {255,0,0}
     END LABEL  

     DEFINE LABEL Label_18
            ROW    530
            COL    10
            WIDTH  759
            HEIGHT 22
            VALUE "III - a data de emissão ou de saida."
            FONTCOLOR {255,0,0}
     END LABEL  

     DEFINE BUTTONEX ButtonEX_1
            ROW    560
            COL    10
            WIDTH  120
            HEIGHT 24
            CAPTION "&Confirma"
				ACTION {||Envia_CCe2()}
     END BUTTONEX  

	 				
	 
	 
     DEFINE BUTTONEX ButtonEX_2
            ROW    560
            COL    300
            WIDTH  120
            HEIGHT 24
            CAPTION "&Cancela"
  			ACTION FormEmissorCCE.RELEASE
	  END BUTTONEX  
 
  
END WINDOW

   FormEmissorCCE.ButtonEX_1.enabled:=.f.
   CENTER WINDOW FormEmissorCCE
   ACTIVATE WINDOW FormEmissorCCE

return

function envia_CCe2()
* // Gera e envia carta de correção para WebService
        LOCAL cQuery, i
        LOCAL cLocalCCE, cLocalXML, cLocalPDF
		local path     :=DiskName()+":\"+CurDir()
        LOCAL cCorr       := RemoveAcento(FormEmissorCCE.Edit_1.value)       // Retira os acentos do Texto
      *  LOCAL nSq         :=( FormEmissorCCE.Label_seq1.Value   )                            // Sequencia de Envio Lote
        LOCAL cAux        := FormEmissorCCE.tNotaFiscal.Value               // Numero Nota para Localização 8 pos
        LOCAL cChave      :=alltrim(FormEmissorCCE.Label_2.Value)                    // Numero da Chave de Acesso
     *   LOCAL cAmbiente   := cAMBIENTE                                                    // Ambiente de Emissão (1-Produção/2-Homologação)
        LOCAL cCertificado:= ''                                                      // Nome do Certificado
        LOCAL oSefaz                                                                 // Variável de Objecto
        LOCAL cRetornoCCE := ''                                                      // Retorno do XML
		LOCAL cUF
        LOCAL cConcate    := 'OK:'+HB_EOL()+'*// Carta de Correção //*'+HB_EOL()     
        LOCAL aArrayXML   := {}     
        Local numero:=ntrim(FormEmissorCCE.tNotaFiscal.value)
        Local xserie:=ntrim(FormEmissorCCE.txtserie.value)		// Array com arquivos xmls 
  	
		nSeqEvento:=val(FormEmissorCCE.Label_seq1.Value)

  BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
			 
	 END INI
	 

cLocalXML:=DiskName()+":\"+CurDir()+"\092017-NFE\"
aArrayXML:=Directory(cLocalXML+"*-nfe.xml")        
cLocalCCE:="Carta_correcao.procEventoNFe.xml"
*       // Abre Secção da Classe Nfe
        oSefaz      := SefazClass():New()
        oSefaz:cUF  := cUF
        oSefaz:cAmbiente:=cAMBIENTE
   	    oNfe:= hbNfe()
        oSefaz:cNFCE:='S' 
   
   * oSefaz:NFeLoteEnvia( @cXml, '1', cUF, ALLTRIM(cCertificado), cAmbiente )
   *oSefaz:NFeEventoCarta( cChave,nSeqEvento, cCorr, cCertificado, cAmbiente )
   cRetornoCCE := oSefaz:NFeEventoCCE( cChave,nSeqEvento, cCorr, cCertificado, cAmbiente )
    hbNFeDaNFe( oSefaz:cXmlAutorizado )
    hb_MemoWrit(cLocalCCE, oSefaz:cXmlAutorizado )
   hb_MemoWrit( "xmlRecibo.xml", oSefaz:cXmlRecibo )
   hb_MemoWrit(  "xmlprotocolo.xml", oSefaz:cXmlProtocolo )
   hb_MemoWrit( "xmloriginal.xml", oSefaz:cXmlDocumento )
   Inkey(.2)       
 
if oSefaz:cStatus $ "135,128"
      cXml  := "Carta_correcao.procEventoNFe.xml"
      
      oDanfe:= hbnfeDaEvento():New()
      RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  oPDF := hbnfeDaNfe():New()
    *  oDanfe := hbNFeDaGeral():New()
      oPDF:SetEanOff()
	  
cChave:=ALLTRIM(cChave)
ffxml:=ALLTRIM(cXML_NOTA)


       oPDF:ToPDF(  Memoread( cXML) , cChave+".pdf", ffxml )

	  
      oDanfe:ToPDF(  Memoread( cXml ) , cChave+".pdf" )
    	Imprimir_Evento_Danfe( cXml, Cchave,cXML_NOTA ) 
	

cXMotivo:=oSefaz:cMotivo		
cQuery := "UPDATE NFCE SET nSeqEvento  = '"+ntrim(nSeqEvento)+"' WHERE CbdNtfNumero = "+numero+" and CbdNtfSerie ="+(xserie)+" Order By CbdNtfNumero" 
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
 
nSeqEvento   :=val(FormEmissorCCE.Label_seq1.Value)
xCbdNtfNumero:=ntrim(FormEmissorCCE.tNotaFiscal.value)
 cQuery :="INSERT INTO Carta_Correcao (MODELO,CbdNtfNumero,CHAVE,retorno_cce,nt_retorno) VALUES ('"+"65"+"','"+xCbdNtfNumero+"','"+cCHAVE+"','"+ALLTRIM(ffxml)+"','"+cXMotivo+"' )" 
*cQuery :="INSERT INTO Carta_Correcao (MODELO,CbdNtfNumero,CHAVE,retorno_cce,nt_retorno) VALUES ('"+"55"+"','"+xCbdNtfNumero+"','"+cChave+"','"+ALLTRIM(ffxml)+"','"+cXMotivo+"' )" 
 	   	 cQuery	:= oServer:Query( cQuery )
	    	If cQuery:NetErr()												
			MsgStop(CQuery:Error())
           MsgInfo("Por Favor Selecione o registro SS 438 PROPLEMA")
 	    	RETURN NIL
		else
	* msginfo("ok")
		EndIf
else 


Msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
*HB_Cria_Log_nfce(cString,xchave+"  Erro.:"+oSefaz:cMotivo)
endif
FormEmissorCCE.Release
return


* // Carrega os dados da Nota Fiscal para geração da Carta de Correção
STATIC Function CarregaDadosCCE2()
local aArqGet, x
Local nCounter:= 0
local ppchave:=""
Local oRow,ninfEventoId
Local i
Local oQuery
Local cQuery
local c_encontro
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()
local cNFe, cJus, cENT, cSAI, cTMP 
LOCAL cCmd, cRet
Local numero:=ntrim(FormEmissorCCE.tNotaFiscal.value)
Local xserie:=ntrim(FormEmissorCCE.txtserie.value)
Local i_CStat:=""
Public i_XMotivo:=""
Public i_NProt:=""
PUBLIC cCStat   :=""	
*oQuery := oServer:Query( "Select CbdNtfNumero,CbddEmi,CHAVE,CbdxNome_dest,CbdCNPJ_dest From nfce WHERE CbdNtfNumero = "+AllTrim(numero)+" and CbdNtfSerie ="+(xserie)+" Order By CbdNtfNumero" )
oQuery := oServer:Query( "Select CbdNtfNumero,CbddEmi,CHAVE,CbdxNome_dest,CbdCNPJ_dest,nSeqEvento,nt_retorno From nfce WHERE CbdNtfNumero = "+AllTrim(numero)+" and CbdNtfSerie ="+(xserie)+" Order By CbdNtfNumero" )
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0

For i     := 1 To oQuery:LastRec()
oRow      := oQuery:GetRow(1)
c_chave   :=ALLTRIM(oRow:fieldGet(3))
nSeqEvento:=oRow:fieldGet(6)
nSeqEvento:=nSeqEvento+1
              MODIFY CONTROL Label_seq1  OF FormEmissorCCE  Value   ''+TransForm(nSeqEvento , "@R 9999")
              FormEmissorCCE.Label_2.Value       := c_chave
			  

HANDLE :=FCREATE (PATH+"\"+c_chave+".XML",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(7) )
FWRITE(Handle,RETORNO)
fclose(handle)  
public cXML_NOTA    :=PATH+"\"+c_chave+".XML"
			  
			  
			  
 oQuery:Skip(1)
  Next
oQuery:Destroy()
Return
