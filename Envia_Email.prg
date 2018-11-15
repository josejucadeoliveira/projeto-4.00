
*Procedure Envia_Email(cTipo, cArquivo, cArquivo1)
*fEnviaEmail('1', 'F:\NFC-E-v-3-plus-4.00\11170984712611000152550010000085251000085253.xml', ' ')
*return



#Include "Minigui.ch"
Procedure Envia_Email(cTipo, cArquivo, cArquivo1)
local SSERVIDOR,SEMAIL,SUSUARIO,SSSL,STLS,SPORTA, Ssenha
BEGIN INI FILE "EMAIL.INI"
	 GET Semail          SECTION  "EMAIL"           ENTRY "EMAIL"
     GET Sservidor       SECTION  "SERVIDORSMTP"    ENTRY "SERVIDORSMTP" 
  	 GET sporta          SECTION  "PORTA"           ENTRY "PORTA"
     GET susuario        SECTION "USUARIO"          ENTRY "USUARIO"
     GET sssl            SECTION "SSL"              ENTRY "SSL"
  	 GET ssenha          SECTION "senha"            ENTRY "senha"
 END INI
Envia_Email2(cTipo, cArquivo, cArquivo1,SSERVIDOR,SEMAIL,SUSUARIO,SSSL,STLS,SPORTA, Ssenha)
retur




Procedure Envia_Email2(cTipo, cArquivo, cArquivo1,SSERVIDOR,SEMAIL,SUSUARIO,SSSL,STLS,SPORTA, Ssenha)
   Local cStilo:= "<style> "                    +;
                  "body{ "                      +;
                   "font-family: Courier New;"  +;
                   "background-color: #ffffff;" +;
                   "font-size: 75%;"            +;
                   "color: #000000;"            +;
                   "}"                          +;
                  "h1{"                         +;
                   "font-family: Courier New;"  +;
                   "font-size: 150%;"           +;
                   "color: #0000cc;"            +;
                   "font-weight: bold;"         +;
                   "background-color: #f0f0f0;" +;
                   "}"                          +;
                  ".updated{"                   +;
                   "font-family: Courier New;"  +;
                   "color: #cc0000;"            +;
                   "font-size: 110%;"           +;
                   "}"                          +;
                  ".normaltext{"                +;
                   "font-family: Courier New;"  +;
                   "font-size: 100%;"           +;
                   "color: #000000;"            +;
                   "font-weight: normal;"       +;
                   "text-transform: none;"      +;
                   "text-decoration: none;"     +;
                   "}"                          +;
                  "</style>", oEmail, cTextoCab

		*		  msginfo(sEMAIL)
   hb_Default(@cArquivo1, [])
   
	cEmail_Cliente:=cEmailDestino
   If !Empty(cEmail_Cliente)
      oEmail:= hbNFeEmail()

      If cTipo == [1]     // Nfe
         cTextoCab:= hb_ansitooem([Nota Fiscal Eletrônica (NF-e)])
      Elseif cTipo == [2] // CCe
         cTextoCab:= hb_ansitooem([Carta de Correção Eletrônica (CC-e)])
      Elseif cTipo == [3] // Cancelamento
         cTextoCab:= hb_ansitooem([Nota Fiscal Eletrônica de Cancelamento])
      Endif
	  
      oEmail:cSubject:= cTextoCab + [ recebida de ] + XmlNode(XmlNode(hb_MemoRead(cArquivo), "emit"), "xNome")
      oEmail:cMsgHTML:= '<html><head><title>' + hb_ansitooem([Envio Automático de ]) + cTextoCab + '</title></head>' + cStilo + '<body>' + hb_OsNewLine() + ;
                        '<h1 Align=Center>' + hb_ansitooem([Envio Automático de ]) + cTextoCab + '</h1><br>' + ;
                        '<dt><div align="center"><font face="Courier New" size="3"><b>' + hb_ansitooem([** Esse é um e-mail automático. Não é necessário respondê-lo **]) + '</b></font><dt><br>' + ;
                        '<dt><div align="left"><font face="Courier New" size="3">Prezado(a) Sr(a),</font></div><br>' + hb_OsNewLine() + ;
                        '<dt><div align="left"><font face="Courier New" size="3">' + hb_ansitooem([Você está recebendo em anexo o arquivo XML e Pdf referente a uma ]) + cTextoCab + [.] + '</font></div><br>' + ;
                        '<dt><div align="center"><font face="Courier New" size="3" color="red">' + hb_ansitooem([Este é um email automático e respostas devem ser enviadas diretamente ao emissor da ]) + cTextoCab + [.] + '</font></div><br>' + ;
                        '<dt><div align="left"><font face="Courier New" size="3">' + hb_ansitooem([Como consultar o status da sua ]) + cTextoCab + [:] + '</font></div><br>' + ;
                        '<dt><div align="left"><font face="Courier New" size="3">' + hb_ansitooem([Acesse o Portal da Nota Fiscal Eletrônica do Ministério da Fazenda em www.nfe.fazenda.gov.br e clique em Consultar NF-e Completa. Digite a chave de acesso: ] + Substr(hb_MemoRead(cArquivo), At([Id=], hb_MemoRead(cArquivo)) + 7, 44) + [ para acessar todas as informações da mesma.]) + '</font></div><br><br><br>' + ;
                        '<dt><div align="left"><font face="Courier New" size="4">Documento emitido por:</font></div><br>' + ;
                        '<dt><div align="left"><font face="Courier New" size="2" color="blue">' + hb_ansitooem('JUMBO VERSAO 4.00 Systens') + '</font></div><br></body></html>'
/*
	
*/	 
						
						
//      oEmail:cMsgTexto:= 'NFE EMTIDA'
      oEmail:cServerIP:= SSERVIDOR
      oEmail:cFrom    :=  XmlNode(XmlNode(hb_MemoRead(cArquivo), "emit"), "xNome") + [<] + sEMAIL  + [>]
      oEmail:cUser    := SUSUARIO
      oEmail:cPass    := Ssenha
      oEmail:nPortSMTP:= SPORTA
      oEmail:lConf    := .t. ///Iif(AllTrim(f_AcessaIni(PATHDADOS + [MALC.INI], [Email], [Confirma]))  == [SIM], .T., .F.)
      oEmail:lSSL     := .t. ///Iif(AllTrim(f_AcessaIni(PATHDADOS + [MALC.INI], [Email], [Ssl])) == [SIM], .T., .F.)
      oEmail:lAut     := .t.  //Iif(AllTrim(f_AcessaIni(PATHDADOS + [MALC.INI], [Email], [Autentica])) == [SIM], .T., .F.)

      If cTipo == [1] // Nfe
         oEmail:aFiles:= {cArquivo, StrTran(cArquivo, [xml], [pdf])}
      Elseif cTipo == [2] .or. cTipo == [3] // CCe e Cancelamento
         oEmail:aFiles:= {cArquivo1, StrTran(cArquivo1, [xml], [pdf])}
      Endif

      oEmail:aTo      := cEmail_Cliente
      aRetorno        := oEmail:execute()

      If aRetorno['OK'] == .F.
         MsgInfo(aRetorno['MsgErro'], 'CASA DAS EMBALAGENS VILHENA')
      Endif
   Endif
Return (Nil)


Procedure imprimir_testeclass(cTipo, cArquivo, cArquivo1)
*fDanfe('1', 'F:\NFC-E-v-3-plus-4.00\092017-pdf\11170984712611000152550020000001821000001828-nfe.xml', ' ')
* fDanfe(1, 'F:\NFC-E-v-3-plus-4.00\092017-pdf\CANCELADA.XML', ' ')

*ntipo:=1
return



FUNCTION imprimir_class( cFile )
   local WIN_SW_SHOWNORMAL
   *local SW_SHOWNORMAL:=1
   local RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
      oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "MEDIALCOMERCIO@GMAIL.COM "
      oDanfe:cSiteEmitente    := "WWW.CASADASEMBALAGENSVILHENA.COM.BR"
      oDanfe:cDesenvolvedor   := RODAPE
	  oDanfe:ToPDF(hb_MemoRead(cFile), StrTran(cFile, [xml], [pdf]))
  IF File( cFile )
     * WAPI_ShellExecute( NIL, "open", cFile, "",, WIN_SW_SHOWNORMAL )
	  WAPI_SHELLEXECUTE(StrTran(cFile, [xml], [pdf]),, StrTran(cFile, [xml], [pdf]),,, SW_SHOWNORMAL)
      Inkey(1)
   ENDIF
RETURN NIL
 


procedure imprimir_class2(nTipo, cArquivo) // usada em ecfwin.prg e svv11.prg
   Local oDanfe, cArquivoTmp
 *  local SW_SHOWNORMAL:=0
   
PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFE")
pdf   :=alltrim(zNUMERO+xxANO+"-pdf")
tmp  :=alltrim(zNUMERO+xxANO+"-tmp")

         cSubDir := DiskName()+":\"+CurDir()+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	  cSubDirTMP:= DiskName()+":\"+CurDir()+"\"+tmp+"\"
  		 nError := MakeDir( cSubDirTMP )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	
  PdfbDir := DiskName()+":\"+CurDir()+"\"+pdf+"\"
  		 nError := MakeDir( PdfbDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF
	

   
   
   
   
   
 *  TESTE:='F:\NFC-E-v-3-plus-4.00\092017-pdf\CANCELADA.XML'
  *MSGINFO(hb_MemoRead(TESTE))
   RODAPE:="JUMBO SISTEMAS JOSÉ JUCÁ (SISTEMA PROPRIO)"
   PATHNFESRETORNO:=DiskName()+":\"+CurDir()+PdfbDir+"\"
   hb_Default(@cArquivo, [])
  
   If !Empty(cArquivo)
      oDanfe                  := hbnfeDanfe():new()
      oDanfe:cLogoFile        := cPathImagem + [CABECARIO.JPG]       // Arquivo da Logo Marca em jpg 
      oDanfe:nLogoStyle       := 3                            // 1-esquerda, 2-direita, 3-expandido
      oDanfe:lLaser           := .T.                            // laser .t., jato .f. (laser maior aproveitamento do papel)
      oDanfe:cFonteNFe        := [Courier]
      oDanfe:cEmailEmitente   := "casa das "
      oDanfe:cSiteEmitente    := "casa das em"
      oDanfe:cDesenvolvedor   := RODAPE
      oDanfe:cTelefoneEmitente:= XmlNode(hb_MemoRead(cArquivo), [fone])

      If [NFE.XML] $ Upper(cArquivo)
         oDanfe:ToPDF(hb_MemoRead(cArquivo), StrTran(cArquivo, [xml], [pdf]))
		 Email:="impressao ok"
		 HB_Cria_Log_nfe(oDanfe:cRetorno,Email)
      *   fEnviaEmail([1], cArquivo)
      Elseif [CCE.XML] $ Upper(cArquivo) .or. [CANCELADA.XML] $ Upper(cArquivo)
         oDanfe     := hbnfeDaEvento():New()
         cArquivoNfe:= Directory(PATHNFESRETORNO + XmlNode(hb_MemoRead(cArquivo), [chNFe]) + [-nfe.xml])        
         If Len(cArquivoNfe) == 0
            MsgInfo([Arquivo Xml da Nfe Não Encontrado. Verifique!!!], 'cSistema')
      *   _Fim
		 Endif
         cArquivoTmp:= PATHNFESRETORNO + AllTrim(cArquivoNfe[1, 1])
         cArquivoNfe:= hb_MemoRead(PATHNFESRETORNO + AllTrim(cArquivoNfe[1, 1])) 
         oDanfe:cTelefoneEmitente:= XmlNode(cArquivoNfe, [fone])
         oDanfe:cDesenvolvedor   := RODAPE
         If [CCE.XML] $ Upper(cArquivo)
            oDanfe:ToPDF(hb_MemoRead(cArquivo), StrTran(cArquivo, [xml], [pdf]), cArquivoNfe)
          *  fEnviaEmail([2], cArquivoTmp, cArquivo)
         Elseif [CANCELADA.XML] $ Upper(cArquivo)
            oDanfe:= hbnfeDanfe():new()
            oDanfe:cDesenvolvedor   := RODAPE
            oDanfe:ToPDF(cArquivoNfe, StrTran(cArquivo, [xml], [pdf]), hb_MemoRead(cArquivo))
          *  fEnviaEmail([3], cArquivoTmp, cArquivo)
        Endif
      Endif

      If oDanfe:cRetorno # [OK]
         MsgInfo(oDanfe:cRetorno, "casa das embalagens")
		 Email:=""
		 HB_Cria_Log_nfe(oDanfe:cRetorno,Email)
      Else
         WAPI_SHELLEXECUTE(StrTran(cArquivo, [xml], [pdf]),, StrTran(cArquivo, [xml], [pdf]),,, SW_SHOWNORMAL)
      Endif
   Endif
Return (Nil)




 Procedure fCanc_Xml()
 
#include 'minigui.ch'
#INCLUDE "WINPRINT.CH"
*#include "FastRepH.CH"
#include "lang_pt.ch"
#include 'i_textbtn.ch'
#define CHAR_REMOVE  "/;-:,\.(){}[] "
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
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RG168,255,190}
#define clrBack     {255,255,128}
#define CLR_PINK   RGB( 255, 128, 128)


PATHDADOS:=DiskName()+":\"+CurDir()
PATHIMAGENS:=DiskName()+":\"+CurDir()
PATHNFESRETORNO:=DiskName()+":\"+CurDir()

 
 
 
cChave:='11170984712611000152550020000001901000001900'
xJust:='lllllllllllllllllllllllllllllllllllllllllllllll'
cMotivo:='lllllllllllllllllllllllllllllllllllllllllllllll'



   If Empty(cChave) .or. Len(AllTrim(cChave)) < 44 .or. Len(AllTrim(cChave)) > 44
      MsgInfo([Chave Inválida. Verifique!!!],' cSistema')
      _SetFocus([Txt_Chave], [fCanc])
   Endif

  * cArquivoNfe:= Directory(PATHNFESRETORNO + cChave + [-nfe.xml])
  cArquivoNfe :='11170984712611000152550020000001901000001900'
   If Len(cArquivoNfe) == 0
      MsgInfo([Arquivo Xml da Nfe Não Encontrado. Verifique!!!],' cSistema')
   Endif
   cArquivoNfe:= hb_MemoRead(cArquivoNfe) 
teste:=XmlNode(XmlNode(cArquivoNfe, [protNFe]), [chNFe]) + [-06-Cancelada.xml]
msginfo(teste)

   If Empty(cMotivo) .or. Len(cMotivo) < 15 .or. Len(cMotivo) > 255
       MsgInfo([Informe o Motivo!!!], cSistema)
      _SetFocus([Ed_TextoCorrecao], [fCanc])
   Endif

*   oSefaz:cCertificado:= AllTrim(f_AcessaIni(PATHDADOS + [MALC.INI], [NFe], [Certificado]))
  
  nSequencia:=1
  XNPROT:=''
oSefaz := SefazClass():New()
oSefaz:NfeEventoCancela( cChave, nSequencia,  XNPROT, xJust, cCertificado, cAmbiente )

  
  * cXmlProtocolo:= oSefaz:NFeEventoCancela(XmlNode(XmlNode(cArquivoNfe, [protNFe]), [chNFe]), 1, Val(XmlNode(XmlNode(cArquivoNfe, [protNFe]), [nProt])), Upper((cMotivo)), oSefaz:cCertificado, AllTrim((PATHDADOS + [MALC.INI], [NFe], [Ambiente])))
   Inkey(.7)

   cStatus      := Pad(XmlNode(XmlNode(cXmlProtocolo, [infEvento]), [cStat]), 3) /// garante a existência do bloco protNFe
   If cStatus $ [128, 135, 155]  // Evento Processado e Cancelado
      hb_MemoWrit(PATHNFESRETORNO + XmlNode(XmlNode(cArquivoNfe, [protNFe]), [chNFe]) + [-06-Cancelada.xml], oSefaz:cXmlAutorizado)
      MsgInfo([Nfe Cancelada com Sucesso], cSistema)

     * fDanfe(2, PATHNFESRETORNO + XmlNode(XmlNode(cArquivoNfe, [protNFe]), [chNFe]) + [-06-Cancelada.xml])
   Else
      MsgExclamation([Erro no Cancelamento:]                                                               + hb_OsNewLine() + ;
                     [Tipo de Ambiente: ] + XmlNode(XmlNode(cXmlProtocolo, [infEvento]), [tpAmb])          + hb_OsNewLine() + ;
                     [Versão da Aplicação: ] + XmlNode(XmlNode(cXmlProtocolo, [infEvento]), [verAplic])    + hb_OsNewLine() + ;
                     [Chave de Acesso: ] + XmlNode(XmlNode(cXmlProtocolo, [infEvento]), [chNFe])           + hb_OsNewLine() + ;
                     [Data de Recebimento: ] + XmlNode(XmlNode(cXmlProtocolo, [infEvento]), [dhRegEvento]) + hb_OsNewLine() + ;
                     [Status: ] + XmlNode(XmlNode(cXmlProtocolo, [infEvento]), [cStat])                    + hb_OsNewLine() + ;
                     [Motivo: ] + XmlTransform(XmlNode(XmlNode(cXmlProtocolo, [infEvento]), [xMotivo])), cSistema)
   Endif
Return (Nil)