#INCLUDE "MINIGUI.CH"
Procedure Check_nfce_B( ) 

IF ISWINDOWDEFINED(Tela_Check_nfce_A)
    maximize WINDOW Tela_Check_nfce_A 
    RESTORE WINDOW Tela_Check_nfce_A
ELSE


Define WINDOW Tela_Check_nfce_A ;
       AT 150, 400 ;
       WIDTH 450 ;
       HEIGHT 350 ;
       TITLE "Enviar contigencia" ;
       BACKCOLOR { 240, 240, 240 };
	   ON INIT {||Reconectar_A(),Check_nfce_b()};

	   
   @ 10, 010  LABEL oSay4 ;
   WIDTH 400;
   HEIGHT 30 ;
   VALUE "Verificando Contigencia"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   @ 050,50 GRID fita_retorno ;
			WIDTH 400 ;
			HEIGHT 200 ;
			HEADERS {'Operação  '} ;
			WIDTHS {350} ;
            VALUE 1 ;			
			FONT "Verdana" SIZE 8 BOLD ;
			NOLINES NOHEADERS
  
  
            ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela
					  
END WINDOW
ACTIVATE WINDOW Tela_Check_nfce_A
endif
Return NIL

******************************************
*------------------------------------------*
***********************************************
function fita_retorno(fitaMensagem,fitaOperador,tipo)
nn := Tela_Check_nfce_A.fita_retorno.ItemCount + 1
xx = alltrim(str( nn ))
ADD ITEM { fitaMensagem } TO FITA_retorno OF Tela_Check_nfce_A
Tela_Check_nfce_A.fita_retorno.value := nn
return

******************************************
*------------------------------------------*
***********************************************
#INCLUDE "MINIGUI.CH"
Procedure Check_nfce_C( )                    
			 Local aNFe		:={}
			 local oQuery_NFe

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
			 
			 
   		   oNfe:=hbNfe()           
           vdata:=dtos(date()-1)
           vdata1:=dtos(date())
           tQuery := oServer:Query("select CbdNtfNumero,CbddEmi,Chave, nt_retorno,NOTATXT,CbdNtfSerie FROM nfce where (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" )  order by cbddemi")
   			For NFe := 1 To tQuery:LastRec()
				  oRow := tQuery:GetRow(NFe)
		 			aadd(aNFe,{oRow:fieldGet(1) , oRow:fieldGet(2), oRow:fieldGet(3), oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6) })
 			   Next
			   tQuery:Destroy()
				For x := 1 To len(aNFe)
			   Envia_Contigencia_nfce( aNFe[x,1] , aNFe[x,2], aNFe[x,3], aNFe[x,4], aNFe[x,5],aNFe[x,6] ) 
 			   Next
  
      Return Nil          

	  

Procedure Envia_Contigencia_nfce( cNUMERO , dEmissao , cChave ,cxml  ,notatxt,cserie )  
		recuperacao_nfce(  cNUMERO , dEmissao , cChave, cxml, notatxt ,cserie) 
Return Nil          

*--------------------------------------------------------------*
Function recuperacao_nfce(cNUMERO , dEmissao , cChave ,cxml  ,notatxt,cserie )
*--------------------------------------------------------------*
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
local bRetornaXML:=""
local cUF,cCertificado:=""

ERASE "C:\ACBrMonitorPLUS\sai.txt"

cChave:=alltrim(cChave)
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
HANDLE :=  FCREATE ("NFCE.TXT",0)// cria o arquivo
FWRITE(Handle,notatxt)
fclose(handle)

HANDLE :=  FCREATE (cSubDirTMP+cChave+"-nfe.XML",0)// cria o arquivo
FWRITE(Handle,cXml)

fita_retorno("Consultando..."+xchave)
	
 BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
			 
	 END INI

oSefaz     := SefazClass():New()
oSefaz:cNFCE:='S' 
oSefaz:NFeConsultaProtocolo( cChave,cCertificado, cAmbiente,cUF,cserie )
hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
cStat:= XmlNode( oSefaz:cXmlRetorno, "cStat" )
fita_retorno("Retorno Consultando..."+cStat)
    cTexto        :=cSubDir+cChave+"-nfe.XML"
 	  IF  oSefaz:cStatus $ "100,101,150,301,302"
			oSefaz:NFeGeraAutorizado( cXml, oSefaz:cXmlRetorno  )
		hb_MemoWrit(cSubDir+cTexto, oSefaz:cXmlAutorizado )
		 cTexto:=memoread(cTexto)
         endif
	
return



