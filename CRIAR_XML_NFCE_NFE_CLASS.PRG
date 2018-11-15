
#include "minigui.ch"
#Include "Common.CH"
#Include "Fileio.CH"  
**************************************************
FUNCTION CRIAR_XML_NFCE() 
**************************************************
LOCAL cUF:=''
LOCAL cCertificado:=""

PUBLIC path :=DiskName()+":\"+CurDir()

	Criar_Pasta_NFe()
 *******************************************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI
******************************************************************	 
   oNfe:= hbNfe()
   oNFe:cUFWS      := '11' // UF WebService
   oNFe:tpAmb      := cAmbiente // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNfe:cPastaSchemas :=DiskName()+":\"+CurDir()+"\"+"Schemas"
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=cSubDirTMP
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:=PATH+"\NFCE.TXT"
   oIniToXML := hbNFCeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oValida := hbNFeValida()
   oIniToXML:IDToken := alltrim(vcIdToken)
   oIniToXML:Token := alltrim(mgIDToken)
   oIniToXML:lValida := .T.
   aRetorno  := oIniToXML:execute()
   oValida:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML := Nil
   Cchave    :=(aRetorno['cChaveNFe'])
*************************************************************   
  
  
  
RETURN (Cchave)
   
   
*********************************************
  
FUNCTION ENVIAR_XML_NFCE(CChave) 
*********************************
LOCAL cUF:=''
LOCAL cCertificado:=""
Criar_Pasta_NFe()
 *******************************************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI
******************************************************************	 
***********************************************************************************
	 //////////////////enviar/////////////////////////
********************************************************************************** 
   xCbdNtfSerie:=SUBSTR(Cchave,23,3)
   xnumero     :=SUBSTR(Cchave,26,9)
   cnumero     :=SUBSTR(Cchave,26,9)
   cTexto      :=Cchave+"-nfe.XML"
   cXml:= MEMOREAD(cSubDirTMP+cTexto)
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 
   oSefaz:cIdToken :=alltrim(vcIdToken)                  
   oSefaz:cCSC     :=alltrim(mgIDToken)
  oSefaz:NFeLoteEnvia( @cXml, '1', cUF, ALLTRIM(cCertificado), cAmbiente )
   hbNFeDaNFe( oSefaz:cXmlAutorizado )  
  hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
		
      cArquivo        :=memoread(cSubDirTMP+cTexto)
     cArquivo_Destino:=cSubDir+CChave+"-nfe.xml"

 IF  oSefaz:cStatus $ "100,101,150,301,302"
               oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )
				hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
   hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo) 
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   hb_MemoWrit( "cXmlDocumento.xml", oSefaz:cXmlDocumento )
   hb_MemoWrit( "xmlRecibo.xml", oSefaz:cXmlRecibo )
   XmlProtocolo:= "XmlProtocolo.xml"
   XmlProtocolo   := Memoread(XmlProtocolo)
  HB_Cria_Log_nfce(Cnumero,Cchave+"  XmlProtocolo.:"+oSefaz:cStatus)
ENDIF
	
RETURN 
  
 
 
   
FUNCTION NFeConsultaProtocolo(CChave) 
*********************************
LOCAL cUF:=''
LOCAL cCertificado:=""

 *******************************************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI
************
   
     oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cNFCE:='S' 	 

   oSefaz:NFeConsultaProtocolo( cChave, cCertificado , cAmbiente )
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
   xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha),.f. )
   chNFe     := PegaDados('chNFe' ,Alltrim(Linha),.f. )
   nProt     := PegaDados('nProt' ,Alltrim(Linha),.f. )
   HB_Cria_Log_nfce(xcStat,xxmotivo+"  Consulta..:"+ambiente,NPROT)
   cTexto          :=Cchave+"-nfe.XML"
   cArquivo        :=memoread(cSubDirTMP+cTexto)
   cArquivo_Destino:=cSubDir+cChave+"-nfe.xml"

	
 IF  oSefaz:cStatus $ "100,101,150,301,302"
  oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )
  hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
  cXml     :=Memoread(cArquivo_Destino)
  HANDLE :=  FCREATE (cSubDir+cchave+"-nfe.XML",0)// cria o arquivo
  FWRITE(Handle,cXml)
  fclose(handle)  
ENDIF
RETURN (cXML)
