#INCLUDE "MINIGUI.CH"
Procedure Check_nfce_BB( ) 

IF ISWINDOWDEFINED(Tela_Check_nfce_A)
  *  maximize WINDOW Tela_Check_nfce_A 
    RESTORE WINDOW Tela_Check_nfce_A
ELSE


Define WINDOW Tela_Check_nfce_A ;
     AT 10, 100 ;
     WIDTH 850;
     HEIGHT 640;
     TITLE "Reenviar NFCE" ;
     icon cPathImagem+'jumbo1.ico';
     MODAL;   
     NOSIZE;
	 BACKCOLOR {255,255,191};
	 ON INIT {||Reconectar_A(),Check_nfce_CC()}
	   
   

   @ 10, 010  FRAME oGrp22 ;
   CAPTION "Nfce em contigencia  "  ;
   WIDTH 820;
   HEIGHT 550 ;
   FONT "MS Sans Serif" SIZE 14.00 ;
   FONTCOLOR { 255, 255, 000 };
 
    
	 
  @40,50 LISTBOX ListBox_1;
  WIDTH 750;
  HEIGHT 500
  
  
  
            ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela
					  
END WINDOW
ACTIVATE WINDOW Tela_Check_nfce_A
endif
Return NIL

******************************************
*------------------------------------------*
***********************************************


proc cas_addiI(cchave)
local nn := Tela_Check_nfce_A.ListBox_1.ItemCount + 1
*Tela_Check_nfce_A.ListBox_1.AddItem( cchave +    "N"+alltrim(str( nn )) )
 Tela_Check_nfce_A.ListBox_1.AddItem( cchave )
Tela_Check_nfce_A.ListBox_1.value := nn
return



***********************************************
#INCLUDE "MINIGUI.CH"
Procedure Check_nfce_CC( )  
******************************************
local cUF,cCertificado:=""
local cSerialNumber:=""
Local aNFe		:={}

local oQuery_NFe,Query
local path :=DiskName()+":\"+CurDir()
LOCAL cJustificativa  :="ERROS NA EMISSAO "

***********************************************************************
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
zNUMERO        :=xSEQ_TEF :=strzero(month(date() ), 2 )
xxANO          := dtoS(date())
xxANO          :=ALLTRIM(SUBSTR(xXANO,0,4))
Xml            :=alltrim(zNUMERO+xxANO+"-XML")
EVENTO_NFCE    :=alltrim(zNUMERO+xxANO+"-EVENTO_NFCE")
tmp            :=alltrim(zNUMERO+xxANO+"-tmp")
sSubDir        := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+xml+"\"
cSubDirTMP     := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+tmp+"\"
cSubDirevento  := DiskName()+":\"+CurDir()+"\"+"NFCe"+"\"+EVENTO_NFCE+"\"

**************************************************************			 
 BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	END INI
	
	
*******************************************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
			 get cSerialNumber SECTION "SerialNumber"   ENTRY "SerialNumber"
			 
			 
	 END INI
*********************************************************************
oNfe:=hbNfe()
vdata :=dtos(date())
vdata1:=dtos(date())           
TQuery := oServer:Query( "Select CbdNtfNumero,CbddEmi,Chave, nt_retorno,NOTATXT,CbdNtfSerie From NFCE WHERE  (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" and autorizacao=''  ) Order By CbddEmi" )
ERASE "NFCE.TXT"
 For NFe := 1 To tQuery:LastRec()
		    oRow := tQuery:GetRow(NFe)
********************************************************
HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,oRow:fieldGet(5) )
fclose(handle)
***********************************************************
HANDLE :=  FCREATE (cSubDirTMP+alltrim(oRow:fieldGet(3)) +"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,oRow:fieldGet(4) )
fclose(handle)  	
cChave:=alltrim(oRow:fieldGet(3))	
cserie:=alltrim(oRow:fieldGet(6))

   oNfe:= hbNfe()
   oNFe:cUFWS := '11' // UF WebService
   oNFe:tpAmb := cAmbiente // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNfe:cPastaSchemas :=DiskName()+":\"+CurDir()+"\"+"Schemas"
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=cSubDirTMP
   oNFe:cSerialCert := cSerialNumber
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
   xchave    :=(aRetorno['cChaveNFe'])
  	  if aRetorno['OK'] == .F.
   		   msginfo(aRetorno['MsgErro'])
	      return
       end  
   pserie      :=SUBSTR(xchave,23,3)
   xnumero     :=SUBSTR(xchave,26,9)
   pnumero     :=SUBSTR(xchave,26,9)
   cTexto      :=xchave+"-nfe.XML"
   cXml        := MEMOREAD(cSubDirTMP+cTexto)
cXmlAutorizado :=cTexto

        oValida:cXML := cXml // Arquivo XML ou ConteudoXML
        aRetorno := oValida:execute()
        oValida := Nil
        IF aRetorno['OK'] == .F.
        retornox:=( aRetorno['MsgErro'])
            ELSE
         retornox :="VALIDO"
			HB_Cria_Log_nfce(pnumero,cTexto+"   Retorno.:"+retornox)
	    ENDIF
cTexto         :=cSubDirTMP+xchave+"-nfe.XML"
*cXML           :=MEMOREAD(cSubDirTMP+cChave+"-nfe.XML")
cXml           := MEMOREAD(cSubDirTMP+xchave+"-nfe.XML")

oSefaz       := SefazClass():New()
oSefaz:cNFCE:='S' 
oSefaz:NFeConsultaProtocolo( xchave,cCertificado, cAmbiente,cUF,cserie )
hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
hbNFeDaNFe( oSefaz:cXmlAutorizado )
oSefaz:NFeGeraAutorizado( cXML , oSefaz:cXmlRetorno  )
    cFileDanfe:= "XmlRetorno.xml"
    Linha    := Memoread(cFileDanfe)
   cStatus  := PegaDados('cStat'   ,Alltrim(Linha),.f. )
   CNPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )

IF  cStatus $ "100,101,150,301,302"
	cas_addiI(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  +"   "+ XmlNode( oSefaz:cXmlRetorno, "nProt" ))  
	cArquivo_Destino:=cSubDir+xChave+"-nfe.XML"
	hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
	cas_addiI(pnumero   +"   "+ "Gerado Assinado autorizado          ok ") 
	fxml     :=cSubDir+xChave+"-nfe.XML"
	ffxml    :=memoread(fxml)
	
	cQuery := "UPDATE NFCE SET  AUTORIZACAO='"+XmlNode( oSefaz:cXmlRetorno, "nProt" )+"', nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "
  oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  cas_addiI(pnumero   +"   "+ "Xml gravado no BD   ok       ")
endif

	
ELSEIF  cStatus == "217" 
    	cas_addiI(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  )  
        cas_addiI(oSefaz:cMotivo)
    oSefaz:NFeLoteEnvia( @cXml, '1', cUF, ALLTRIM(cCertificado), cAmbiente )
     hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo) 
    cArquivo_Destino:=cSubDir+xChave+"-nfe.XML"
	hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
IF oSefaz:cStatus $ "100,101,150,301,302"
	cas_addiI(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  +"   "+ XmlNode( oSefaz:cXmlRetorno, "nProt" ))  
    fxml     :=cSubDir+xChave+"-nfe.XML"
	ffxml    :=memoread(fxml)
	cQuery := "UPDATE NFCE SET  AUTORIZACAO='"+XmlNode( oSefaz:cXmlRetorno, "nProt" )+"', nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "

oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  cas_addiI(pnumero   +"   "+ "Xml gravado no BD   ok       ")
endif
ENDIF


ELSEIF  cStatus == "613"   

   public cNovaChave:=substr(oSefaz:cMotivo,91,44)
    cNumero :=(SUBSTR(cNovaChave,26,9)) 
    cSerie  :=alltrim(SUBSTR(cNovaChave,23,3)) 
    HB_Cria_Log_nfce_reenvio((cNumero ),cNovaChave,  +"   " +oSefaz:cMotivo)
  cas_addiI(pnumero   +"   "+ cNovaChave  +"   " +oSefaz:cMotivo  )
  
 IF substr(cNovaChave,35,1)=='9' 
 BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
  END INI   
 ENDIF
 
PUBLIC Destinotxt :=PATH+"\NFCE.TXT"
NFCETXT:=memoread(Destinotxt)

  
oSefaz     := SefazClass():New()
oSefaz:cNFCE:='S' 

oSefaz:NFeConsultaProtocolo( cNovaChave,cCertificado, cAmbiente,cUF,Cserie )
************************************************************************************
  hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "XmlRetorno.xml"
    Linha    := Memoread(cFileDanfe)
   cStatus  := PegaDados('cStat'   ,Alltrim(Linha),.f. )
   CNPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
  
  cTexto          :=cNovaChave+"-nfe.XML"
   xml_temporario  :=memoread(cSubDirTMP+cTexto)
   cxml_autorizado:=cSubDir+cNovaChave+"-nfe.xml" 
   
   
    cas_addiI(pnumero   +"   "+ oSefaz:cStatus  +"   " +oSefaz:cMotivo  )
 	  IF  oSefaz:cStatus $ "100,101,150,301,302"
			oSefaz:NFeGeraAutorizado( xml_temporario, oSefaz:cXmlRetorno  )
		hb_MemoWrit( cxml_autorizado, oSefaz:cXmlAutorizado )
        cxml_autorizado:=memoread(cxml_autorizado)	
      endif	  
	  	  
 cQuery:=("UPDATE nfce SET NOTATXT= '"+(AllTrim(NFCETXT))+"',AUTORIZACAO='"+ XmlNode( oSefaz:cXmlRetorno, "nProt" ) +"',nt_retorno='" +oSefaz:cXmlAutorizado+"',CHAVE='"+cNovaChave+"' WHERE CbdNtfNumero = "+(Cnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(Cserie)+"  "  )  
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
    cas_addiI(pnumero   +"   "+ "Xml gravado no BD   ok       ")
  Endif
  
 ELSEIF  oSefaz:cStatus $ "526"
         

  BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
			 
	 END INI

 nCbdNtfNumero   :=(SUBSTR(cChave,26,9)) 
  cCbdNtfSerie   :=(SUBSTR(cChave,23,3)) 
  cAno			 := '20'+substr(cChave,3,2)
	ccnpj        :="84712611000152"	
		
		   oSefaz:= SefazClass():New()
			oSefaz:cUF:=cUF                                                                  
		   oSefaz:cAmbiente:=cAMBIENTE
		   oSefaz:cNFCE:='S'
nCbdNtfNumero:=val(nCbdNtfNumero)
cCbdNtfSerie:=val(cCbdNtfSerie)

oSefaz:NFeInutiliza( cAno, ccnpj, '65',  str(cCbdNtfSerie), str(nCbdNtfNumero), str(nCbdNtfNumero), cJustificativa, cUF, cCertificado, cAMBIENTE )
    
   CTexto      :=cSubDirevento+cChave+"-ProcEvento.xml"	
   hb_MemoWrit( "xmlretorno.xml"   , oSefaz:cXmlRetorno )
  status:= XmlNode( oSefaz:cXmlRetorno, "cStat" )
   HB_Cria_Log_nfce_reenvio(str(nCbdNtfNumero),cChave, oSefaz:cStatus+" "+oSefaz:cMotivo)
   
if status $ '102'
   hb_MemoWrit( cTexto, oSefaz:cXmlAutorizado )
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+oSefaz:cMotivo+"' ,AUTORIZACAO='"+"INUTILIZADA"+"' WHERE CbdNtfNumero = "+str(nCbdNtfNumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+str(cCbdNtfSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
  ELSE
   HB_Cria_Log_nfce_reenvio(str(nCbdNtfNumero),cChave, oSefaz:cStatus)
Endif
  
      
ELSEIF  oSefaz:cStatus $ "778"
          
      
	

  BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
			 
	 END INI

 nCbdNtfNumero   :=(SUBSTR(cChave,26,9)) 
  cCbdNtfSerie   :=(SUBSTR(cChave,23,3)) 
  cAno			 := '20'+substr(cChave,3,2)
	ccnpj        :="84712611000152"	
		
		   oSefaz:= SefazClass():New()
			oSefaz:cUF:=cUF                                                                  
		   oSefaz:cAmbiente:=cAMBIENTE
		   oSefaz:cNFCE:='S'
nCbdNtfNumero:=val(nCbdNtfNumero)
cCbdNtfSerie:=val(cCbdNtfSerie)

oSefaz:NFeInutiliza( cAno, ccnpj, '65',  str(cCbdNtfSerie), str(nCbdNtfNumero), str(nCbdNtfNumero), cJustificativa, cUF, cCertificado, cAMBIENTE )
    
   CTexto      :=cSubDirevento+cChave+"-ProcEvento.xml"	
   hb_MemoWrit( "xmlretorno.xml"   , oSefaz:cXmlRetorno )
  status:= XmlNode( oSefaz:cXmlRetorno, "cStat" )
   HB_Cria_Log_nfce_reenvio(str(nCbdNtfNumero),cChave, oSefaz:cStatus+" "+oSefaz:cMotivo)
   
if status $ '102'
   hb_MemoWrit( cTexto, oSefaz:cXmlAutorizado )
cQuery := "UPDATE NFCE SET MSCANCELAMENTO  = '"+oSefaz:cMotivo+"' ,AUTORIZACAO='"+"INUTILIZADA"+"' WHERE CbdNtfNumero = "+str(nCbdNtfNumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+str(cCbdNtfSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif
  ELSE
   HB_Cria_Log_nfce_reenvio(str(nCbdNtfNumero),cChave, oSefaz:cStatus)
Endif
 endif
Next

tQuery:Destroy()
ThisWindow.release 

Return Nil          
	  
Function F_contigencia_acbr_class()

IF GERA_NFE_NFCE=1
Check_nfce_B_ACBR( ) 
else
Check_nfce_BB( ) 
endif
 
