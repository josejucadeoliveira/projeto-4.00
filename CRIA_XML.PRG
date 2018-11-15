#include "inkey.ch"
#include "set.ch"
#include "hbgtinfo.ch"
#include "directry.ch"
#include "hbnfe.ch"
#include "hbxml.ch"
#include 'minigui.ch'
#INCLUDE "WINPRINT.CH"
*#include "FastRepH.CH"
#include "lang_pt.ch"
#include 'i_textbtn.ch'

procedure CriaXML()

   LOCAL nOpc := 1, GetList := {}, cTexto := "", nOpcTemp
   LOCAL cCnpj := Space(14), cChave := Space(44), cCertificado := "", cUF := "RO", cXmlRetorno
   LOCAL oSefaz, cXml, oDanfe, cTempFile, nHandle

   oNfe := hbNfe()
   oNFe:cUFWS := '11' // UF WebService
   oNFe:tpAmb := '2' // Tipo de Ambiente
   oNFe:versaoDados := '3.10'  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=DiskName()+":\"+CurDir() 
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:= 'F:\NFC-E-v-3-plus-4.00\NOTA.TXT'
   oIniToXML := hbNFeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oIniToXML:lValida := .T.
   aRetorno := oIniToXML:execute()
   oIniToXML := Nil
   xcha:=(aRetorno['cChaveNFe'])
cTexto:=xcha+"-nfe.XML"
*msginfo(cTexto)


    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
	 END INI

   oSefaz     := SefazClass():New()
   oSefaz:cUF := "RO"
   oSefaz:cAmbiente:='2'
   
   cXmlAutorizado:= cTexto
   cXml:= MEMOREAD(cTexto)
 
oSefaz := SefazClass():New()
oSefaz:NFeLoteEnvia( @cXml, '1', 'RO', ALLTRIM(cCertificado), '2' )
hbNFeDaNFe( oSefaz:cXmlAutorizado )
IF oSefaz:cStatus $ "100,102"
   hb_MemoWrit( cTexto, oSefaz:cXmlAutorizado )
  MsgExclamation( iif( oSefaz:cStatus == "100", "Nota autorizada", "Nota Denegada"  ))
  
  
  
ELSE
hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo )

   IF .NOT. Empty( oSefaz:cMotivo )
      MsgExclamation( "Problema " + oSefaz:cMotivo )
	  msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
return(.f.)
   ELSE
      MsgExclamation( "Erro " + oSefaz:cXmlRetorno )
	  msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
return(.f.)
   ENDIF
ENDIF


*************preparar para imprimir**************
cXml:=cXmlAutorizado
chave:= substr(cXml , 0, 48)
************************************************
*msginfo(chave)

oPDF := hbnfeDaNfe():New()
oDanfe := hbNFeDaGeral():New()
oPDF:SetEanOff()
oDanfe:ToPDF(  Memoread( cXml ) , chave+".pdf" )
cpdf:= chave+".pdf" 
PDFOpen(cpdf)
GRAVA_nfe1()
RETURN
		