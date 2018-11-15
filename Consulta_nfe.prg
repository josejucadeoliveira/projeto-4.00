			
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
			
