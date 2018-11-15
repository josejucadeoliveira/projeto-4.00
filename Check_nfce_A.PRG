#INCLUDE "MINIGUI.CH"
Procedure Check_nfce_B( ) 

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
	 BACKCOLOR {255,255,191}
	 
	*ON INIT {||Reconectar_A(),Check_nfce_C()}
	   
   
   @ 10, 010  FRAME oGrp22 ;
   CAPTION "Pesquisa Data  ou Numeros "  ;
   WIDTH 820;
   HEIGHT 150 ;
   FONT "MS Sans Serif" SIZE 14.00 ;
   FONTCOLOR { 255, 255, 000 };
 
   
 @ 40, 10  datepicker dpi_001 ;
   WIDTH 126 HEIGHT         30 ;
   VALUE date();
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
   
   
   @ 40, 170  label ate ;
   WIDTH 30 HEIGHT         30 ;
   VALUE "Ate";
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
      
 @ 40, 230  datepicker dpi_002 ;
   WIDTH 126 HEIGHT         30 ;
   VALUE date();
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }

  
   
  DEFINE TEXTBOX  numero_i
           ROW    80
           COL    10
            WIDTH  100
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX 
	
	  
	  DEFINE TEXTBOX  serie_i
           ROW    80
           COL   125
            WIDTH  30
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX 
	
	 
	 @ 80, 170  label atea;
   WIDTH 30 HEIGHT         30 ;
   VALUE "Ate";
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
   
   
  DEFINE TEXTBOX numero_f
           ROW    80
           COL    240
            WIDTH  100
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX   
  
 
   DEFINE RADIOGROUP RdG_Ambiente_NFCe       
               ROW    40
               COL    400
               WIDTH  110
               HEIGHT 29
               OPTIONS {'Tudos os Xml','Autozição vazio','Por Codigo'}
               VALUE 1
               HORIZONTAL .F.
		       BACKCOLOR {255,255,128}
        END RADIOGROUP  
  
     
   
     define buttonex confirma
                       row 80
                       col 600
                       width 110
                       height 030
                       caption 'Confirma'
                       picture cPathImagem+'ok.bmp'
                       fontbold .T.
                       lefttext .F.
                      action  {||Reconectar_A(),Check_nfce_C()}
                end buttonex
     
  @200,50 LISTBOX ListBox_1;
  WIDTH 750;
  HEIGHT 400
  
  
  
            ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela
					  
END WINDOW
ACTIVATE WINDOW Tela_Check_nfce_A
endif
Return NIL

******************************************
*------------------------------------------*
***********************************************

proc cas_addi(cchave)
local nn := Tela_Check_nfce_A.ListBox_1.ItemCount + 1
*Tela_Check_nfce_A.ListBox_1.AddItem( cchave +    "N"+alltrim(str( nn )) )
 Tela_Check_nfce_A.ListBox_1.AddItem( cchave )
Tela_Check_nfce_A.ListBox_1.value := nn
return



***********************************************
#INCLUDE "MINIGUI.CH"
Procedure Check_nfce_C( )  
******************************************
local cUF,cCertificado:=""
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
*********************************************************************
   		   *oNfe:=hbNfe()           
           *vdata:=dtos(date()-3)
          * vdata1:=dtos(date())
          * tQuery := oServer:Query("select CbdNtfNumero,CbddEmi,Chave, nt_retorno,NOTATXT,CbdNtfSerie FROM nfce where (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" )  order by cbddemi")
   		*	For NFe := 1 To tQuery:LastRec()
		   * oRow := tQuery:GetRow(NFe)

			
vdata   :=dtos(Tela_Check_nfce_A.dpi_001.value)
vdata1  :=dtos(Tela_Check_nfce_A.dpi_002.value)
vnumero :=Tela_Check_nfce_A.numero_i.value
vnumero1:=Tela_Check_nfce_A.numero_f.value
serie_i :=Tela_Check_nfce_A.serie_i.value


IF Tela_Check_nfce_A.RdG_Ambiente_NFCe.VALUE == 1
TQuery := oServer:Query( "Select CbdNtfNumero,CbddEmi,Chave, nt_retorno,NOTATXT,CbdNtfSerie From NFCE WHERE  (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" ) Order By CbddEmi" )
ELSEIF  Tela_Check_nfce_A.RdG_Ambiente_NFCe.VALUE == 2
TQuery := oServer:Query( "Select CbdNtfNumero,CbddEmi,Chave, nt_retorno,NOTATXT,CbdNtfSerie From NFCE WHERE  (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" and autorizacao=''  ) Order By CbddEmi" )
ELSEIF  Tela_Check_nfce_A.RdG_Ambiente_NFCe.VALUE == 3
TQuery := oServer:Query( "CbdNtfNumero,CbddEmi,Chave, nt_retorno,NOTATXT,CbdNtfSerie From NFCE WHERE  CbdNtfNumero >= "+vnumero+" and CbdNtfNumero <= "+vnumero1+" and CbdNtfSerie="+serie_i+" Order By CbdNtfNumero")
endif		
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
	cas_addi(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  +"   "+ XmlNode( oSefaz:cXmlRetorno, "nProt" )) 
	HB_Cria_Log_nfce_reenvio(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  +"   "+ XmlNode( oSefaz:cXmlRetorno, "nProt" ))

	cArquivo_Destino:=cSubDir+xChave+"-nfe.XML"
	hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
	cas_addi(pnumero   +"   "+ "Gerado Assinado autorizado          ok ") 
	HB_Cria_Log_nfce_reenvio(pnumero   +"   "+ "Gerado Assinado autorizado          ok ")

	fxml     :=cSubDir+xChave+"-nfe.XML"
	ffxml    :=memoread(fxml)
	
	cQuery := "UPDATE NFCE SET  AUTORIZACAO='"+XmlNode( oSefaz:cXmlRetorno, "nProt" )+"', nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "
  oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  cas_addi(pnumero   +"   "+ "Xml gravado no BD   ok       ")
  HB_Cria_Log_nfce_reenvio(pnumero   +"   "+ "Xml gravado no BD   ok       ")

endif

	
ELSEIF  cStatus == "217" 
    	cas_addi(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  )  
        cas_addi(oSefaz:cMotivo)
		HB_Cria_Log_nfce_reenvio(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  )  
		
    oSefaz:NFeLoteEnvia( @cXml, '1', cUF, ALLTRIM(cCertificado), cAmbiente )
     hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo) 
    cArquivo_Destino:=cSubDir+xChave+"-nfe.XML"
	hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
IF oSefaz:cStatus $ "100,101,150,301,302"
	cas_addi(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  +"   "+ XmlNode( oSefaz:cXmlRetorno, "nProt" ))  
	HB_Cria_Log_nfce_reenvio(pnumero   +"   "+xChave +"             "+oSefaz:cMotivo  +"   "+ XmlNode( oSefaz:cXmlRetorno, "nProt" ))  
	
    fxml     :=cSubDir+xChave+"-nfe.XML"
	ffxml    :=memoread(fxml)
	cQuery := "UPDATE NFCE SET  AUTORIZACAO='"+XmlNode( oSefaz:cXmlRetorno, "nProt" )+"', nt_retorno='"+alltrim(ffxml)+"' WHERE CbdNtfNumero = "+(pnumero)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+(pserie)+" "

oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  cas_addi(pnumero   +"   "+ "Xml gravado no BD   ok       ")
endif
ENDIF


ELSEIF  cStatus == "613"   

   public cNovaChave:=substr(oSefaz:cMotivo,91,44)
    cNumero :=(SUBSTR(cNovaChave,26,9)) 
    cSerie  :=alltrim(SUBSTR(cNovaChave,23,3)) 
    HB_Cria_Log_nfce_reenvio((cNumero ),cNovaChave,  +"   " +oSefaz:cMotivo)
  cas_addi(pnumero   +"   "+ cNovaChave  +"   " +oSefaz:cMotivo  )
  
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
   
   
    cas_addi(pnumero   +"   "+ oSefaz:cStatus  +"   " +oSefaz:cMotivo  )
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
    cas_addi(pnumero   +"   "+ "Xml gravado no BD   ok       ")
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
Return Nil          

	  
