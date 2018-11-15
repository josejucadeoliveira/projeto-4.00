		
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
		
*    // Procedure para Criação de Carta de Correção //
Procedure MontaCartaCorrecao()

        SET FONT TO "Arial", 12 

        DEFINE WINDOW FormEmissorCCE AT 0,0 WIDTH 1024 HEIGHT 600 TITLE "Carta de Correção" ICON "janela" MODAL 
		
              @ 018,010 LABEL    lData               VALUE "Data "            AUTOSIZE
              @ 018,125 LABEL    lNotaFiscal         VALUE "Nº N.Fiscal"      AUTOSIZE
		      @ 040,125 TEXTBOX  tNotaFiscal         WIDTH 120 HEIGHT 28 BOLD BACKCOLOR {191,225,255} INPUTMASK "9999999" 
           		  
		
		      @ 018,260 LABEL   tNotaserie            VALUE "Serie"      AUTOSIZE
			  		

					
	 
              @ 018,320 LABEL    lCFOP               VALUE "CFOP"             AUTOSIZE
              @ 018,390 LABEL    lEspeciCFOP         VALUE "Especificação"    AUTOSIZE

              @ 088,010 LABEL    lDestino            VALUE "Código"                        AUTOSIZE
              @ 088,100 LABEL    lDescDestino        VALUE "Destinatário"                  AUTOSIZE
              @ 088,795 LABEL    lCNPJCPF            VALUE "CNPJ/CPF"                      AUTOSIZE
              @ 150,010 LABEL    lPlaca              VALUE "Placa"                         AUTOSIZE
              @ 150,110 LABEL    lTransporte         VALUE "Nome Transportadora"           AUTOSIZE
              @ 150,605 LABEL    lForma              VALUE "Forma"                         AUTOSIZE
              @ 150,760 LABEL    lRem                VALUE "Rem."                          AUTOSIZE
              @ 150,820 LABEL    lVol                VALUE "Volume"                        AUTOSIZE

              @ 220,010 LABEL    lChave              VALUE "Numero da Chave de Acesso"     AUTOSIZE
              @ 220,590 LABEL    lDataCorrecao       VALUE "Data e Hora da Correção"       AUTOSIZE
              @ 220,915 LABEL    lSequencia          VALUE "Sequência."                    AUTOSIZE
              @ 298,010 LABEL    lCorrecao           VALUE "Informe o Texto para Correção" AUTOSIZE

              @ 040,010 TEXTBOX  tData               VALUE DATE() WIDTH 100 HEIGHT 28      BACKCOLOR {191,225,255} DATE NOTABSTOP                                         
         
			  
              @ 040,320 TEXTBOX  cCFOP               READONLY     WIDTH 70  HEIGHT 28 BOLD BACKCOLOR {191,223,255} NOTABSTOP  
              @ 040,390 TEXTBOX  cEspeciCFOP         READONLY     WIDTH 400 HEIGHT 28 BOLD BACKCOLOR {191,223,255} NOTABSTOP
              @ 110,010 TEXTBOX  tDestino            READONLY     WIDTH 080 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NOTABSTOP  
              @ 110,100 TEXTBOX  tDescDestino        READONLY     WIDTH 670 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NOTABSTOP
              @ 110,785 TEXTBOX  tCnpjCpf            READONLY     WIDTH 215 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NOTABSTOP

          
              @ 243,010 TEXTBOX  tChave              WIDTH 570    HEIGHT 28 BOLD BACKCOLOR {191,225,255} INPUTMASK "99999999999999999999999999999999999999999999" ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
              @ 243,590 TEXTBOX  tDataCorrecao       READONLY     WIDTH 310 HEIGHT 28 BOLD BACKCOLOR {191,225,255} NOTABSTOP  
              @ 243,915 COMBOBOX cSeq                WIDTH 75                              BACKCOLOR {191,225,255} ON GOTFOCUS SetControl(.T.) ON LOSTFOCUS SetControl(.F.) 
              @ 323,010 EDITBOX  eTextoCorrecao      WIDTH 985    HEIGHT 100 VALUE "" FONT "Arial" SIZE 11 BACKCOLOR {191,223,255} MAXLENGTH 1000 NOVSCROLL NOHSCROLL     ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)

              @ 450,010 BUTTON   BtAdicionaCCE CAPTION "Adiciona" SIZE 15 BOLD WIDTH 125 HEIGHT 35 FLAT ACTION AdicionaDadosCCE()
              @ 450,136 BUTTON   BtEnviaCCE    CAPTION "Enviar"   SIZE 15 BOLD WIDTH 125 HEIGHT 35 FLAT ACTION ExibeLogCCE()
              @ 450,875 BUTTON   BtCancelaNF   CAPTION "Sair"     SIZE 15 BOLD WIDTH 125 HEIGHT 35 FLAT ACTION FormEmissorCCE.Release
              ON KEY ESCAPE ACTION FormEmissorCCE.Release
        END WINDOW
/*
        DISABLE CONTROL tData          OF FormEmissorCCE
        DISABLE CONTROL tNotaFiscal    OF FormEmissorCCE
        DISABLE CONTROL cCFOP          OF FormEmissorCCE
        DISABLE CONTROL cEspeciCFOP    OF FormEmissorCCE
        DISABLE CONTROL tDestino       OF FormEmissorCCE
        DISABLE CONTROL tDescDestino   OF FormEmissorCCE
        DISABLE CONTROL tCnpjCpf       OF FormEmissorCCE
        DISABLE CONTROL BtAdicionaCCE  OF FormEmissorCCE
        DISABLE CONTROL BtEnviaCCE     OF FormEmissorCCE
        DISABLE CONTROL eTextoCorrecao OF FormEmissorCCE
       *DISABLE CONTROL tPlaca         OF FormEmissorCCE 
      * DISABLE CONTROL tTranspor      OF FormEmissorCCE 
        *dISABLE CONTROL cViaTransporte OF FormEmissorCCE 
      *  DISABLE CONTROL tRem           OF FormEmissorCCE 
      *  DISABLE CONTROL tVolume        OF FormEmissorCCE 
      *  DISABLE CONTROL BtAtualizaCCE  OF FormEmissorCCE 
      *  DISABLE CONTROL tChave         OF FormEmissorCCE
		*  DISABLE CONTROL tDataCorrecao  OF FormEmissorCCE
      *  DISABLE CONTROL cSeq           OF FormEmissorCCE
      *  FormEmissorCCe.tNotaFiscal.SetFocus
*/
        SET TOOLTIP TEXTCOLOR TO WHITE  OF FormEmissorCCE
        SET TOOLTIP BACKCOLOR TO BLUE   OF FormEmissorCCE
        CENTER   WINDOW FormEmissorCCE
        ACTIVATE WINDOW FormEmissorCCE
        RETURN NIL
     
STATIC Function AdicionaDadosCCE()
        LOCAL nSq:=FormEmissorCCE.cSeq.ItemCount
        If Len(AllTrim(FormEmissorCCE.tChave.Value))<44
           MsgInfo("Necessário preenchimento da Chave de Acesso","Nota Fiscal")
           Return(FormEmissorCCE.tChave.SetFocus)
        EndIf   
        FormEmissorCCE.cSeq.AddItem(StrZero(nSq+1,2),2)
	     SetProperty('FormEmissorCCE','eTextoCorrecao','Value','')
		  SetProperty('FormEmissorCCE','cSeq','Value',nSq+1)
        ENABLE CONTROL BtEnviaCCE     OF FormEmissorCCE
        ENABLE CONTROL eTextoCorrecao OF FormEmissorCCE
//      DISABLE CONTROL BtAdicionaCCE OF FormEmissorCCE
		  Return(FormEmissorCCE.eTextoCorrecao.SetFocus)
	  

	  
	  
	  
	  
	  
	  
	  
	  
* // Gera e envia carta de correção para WebService
STATIC Function ExibeLogCCE()
        LOCAL cQuery, i
        LOCAL cLocalCCE, cLocalXML, cLocalPDF
        LOCAL cCorr       := RemoveAcento(FormEmissorCCE.eTextoCorrecao.Value)       // Retira os acentos do Texto
        LOCAL nSq         := FormEmissorCCE.cSeq.Value                               // Sequencia de Envio Lote
        LOCAL cAux        := RIGHT(FormEmissorCCE.tNotaFiscal.Value,8)               // Numero Nota para Localização 8 pos
        LOCAL cChave      := AllTrim(FormEmissorCCE.tChave.Value)                    // Numero da Chave de Acesso
        LOCAL cAmbiente   := '1'                                                     // Ambiente de Emissão (1-Produção/2-Homologação)
        LOCAL cCertificado:= ''                                                      // Nome do Certificado
        LOCAL oSefaz                                                                 // Variável de Objecto
        LOCAL cRetornoCCE := ''                                                      // Retorno do XML
        LOCAL cConcate    := 'OK:'+HB_EOL()+'*// Carta de Correção //*'+HB_EOL()     
        LOCAL aArrayXML   := {}                                                      // Array com arquivos xmls 


		
  BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
			 
	 END INI

*       Localiza o Arquivo XML para anexar
      *  cLocalXML+=STR(YEAR(FormNotaFiscal.tData.Value),4)+STRZERO(MONTH(FormNotaFiscal.tData.Value),2)+'\'
	    cLocalXML:=DiskName()+":\"+CurDir()+"\092017-NFE\"
        aArrayXML:=Directory(cLocalXML+"*.xml")        

		
*       // Vasculha os arquivos encontrados atras da NFe Para Continuação
        For i:=1 TO Len(aArrayXML)
           If cAux == SUBSTR(aArrayXML[i,1],27,8)
              cLocalXML+=AllTrim(aArrayXML[i,1])  // Define nome do Arquivo XML
              Exit
           EndIf
        Next i
        
*       // Só continua se o arquivo XML foi encontrado
        If !File(cLocalXML)
           MsgInFo('Arquivo XML não Localizado, impossível prosseguir','Carta de Correção')
           Return
        EndIf   


		
        // Nome do XML de Retorno'
		  cLocalCCE+='110110'+cChave+STRZERO(nSq,2)+'-procEventoNFe.xml'  
      
        SetProperty('FormXML','tEnvio','Value','A G U A R D E ! ! !')

*       // Abre Secção da Classe Nfe
        oSefaz      := SefazClass():New()
        oSefaz:cUF  := mSiglaUF

        cRetornoCCE := oSefaz:NFeEventoCCE( cChave, nSq, cCorr, cCertificado, cAmbiente )
        Inkey(.7)       

        cStatus := Pad( XmlNode( cRetornoCCE, "cStat" ), 3 ) // garante a existência do bloco protNFe

        IF (cStatus $ "135,128")

           SetProperty('FormXML','tEnvio','Value','Carta de Correção Processada')

           If hb_at( '<cStat>135</cStat>' , cRetornoCCE )>0     // Procura Validação do Retorno

              cConcate+= 'Ambiente: '   +XmlNode( cRetornoCCE,"tpAmb" )     + HB_EOL()
              cConcate+= 'Versão: '     +XmlNode( cRetornoCCE,"verAplic" )  + HB_EOL()
              cConcate+= 'UF: '         +XmlNode( cRetornoCCE,"cOrgao" )    + HB_EOL()
              cConcate+= 'Motivo: '     +XmlNode( cRetornoCCE,"xMotivo" )   + HB_EOL()
              cConcate+= 'Chave: '      +XmlNode( cRetornoCCE,"chNFe" )     + HB_EOL()
              cConcate+= 'Tipo Evento: '+XmlNode( cRetornoCCE,"tpEvento" )  + HB_EOL()
              cConcate+= 'Evento: '     +XmlNode( cRetornoCCE,"xEvento" )   + HB_EOL()
              cConcate+= 'Sequencia: '  +XmlNode( cRetornoCCE,"nSeqEvento" )+ HB_EOL()
              cConcate+= 'Correção: '   +XmlNode( XmlNode( cRetornoCCE, "detEvento" ), "xCorrecao" )+ HB_EOL()
              cConcate+= 'CNPJ Dest.: ' +XmlNode( cRetornoCCE,"CNPJDest" )  + HB_EOL()
              cConcate+= 'Email Dest.: '+XmlNode( cRetornoCCE,"emailDest" ) + HB_EOL()
              cConcate+= 'Data Evento: '+XmlNode( cRetornoCCE,"dhRegEvento")+ HB_EOL()
              cConcate+= 'Protocolo: '  +XmlNode( cRetornoCCE,"nProt")      + HB_EOL() + HB_EOL() + HB_EOL() +oRetorno
              oRetorno:= cConcate
           *   SetProperty('FormXML','RetornoXML','Value', HtmlToAnsi(cConcate) )
              DO EVENTS

		endif
		endif
		
		
			  
        FormEmissorCCE.Release
        RETURN
	
	