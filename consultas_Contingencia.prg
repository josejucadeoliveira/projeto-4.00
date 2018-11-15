/******************************************************************************  
 * Sistema .....: Mgi  
 * Programa ....:   
 * Autor .......: Gilmar Brizolla dos Santos  
 * Sintese .....: Envia Notas emitidas em Contigencia  
 * Data ........: 03/09/2014 às 08:08:26  
 * Revisado em .: 03/09/2014 às 08:08:26  
 ******************************************************************************/  
// Exemplo de Browse com MySQL
// Autor : Roberto Evangelista 
// Melhoramento jose juca
#include 'minigui.ch'
#Include "F_sistema.ch"
#INCLUDE "TSBROWSE.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "WINPRINT.CH"
#INCLUDE "TSBROWSE.CH"
#include "FastRepH.CH"
#include "lang_pt.ch"
#include "MiniGui.ch"
#include 'i_textbtn.ch'
#define CLR_AZUL     RGB(0,0  , 255)  //azul forte 
#define CLR_AZULf     {00,  00, 135}  //azul fraco
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte  
#define    _VERMELHO  {255,  0, 0  } //vermelho forte  
#define CLR_VERMELHO  {255,  0, 0  } //vermelho forte  
#define CLR_VERMELHO1 {255,140, 0  } //vermelho forte  
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte  
#define CLR_AZUL     RGB(0,0  , 255)  //azul forte 
#define CLR_verde    RGB(0,190, 255)  //verde forte
#define CLR_amarelo    {255, 255, 0}   //amarelo forte
#define _AMARELO       {255, 255, 0}   //amarelo forte
#define CLR_AZULf     {00,  00, 135}  //azul fraco
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define CHAR_REMOVE  "/;-:,\.(){}[] "
#include "i_mBrowse.ch"

FUNCTION consultas_Contingencia()  
Local lRet:=.t.
publ path :=DiskName()+":\"+CurDir()

   Reconectar_A() 
   cQuery:= "DELETE FROM nfCE_CONTIGENCIA "         
   oQuery:=oServer:Query( cQuery )
   If oQuery:NetErr()
    MsgInfo("Por Favor Selecione o registro que deseja alterar")
    Return Nil
   endif

 *s msginfo("ok")
  
  
*CQuery:= "select * FROM nfce"  
Reconectar_A() 
cQuery:= "select CbdNtfNumero,CbdNtfSerie,CbdEmpCodigo,CbdxNome_dest,CbddEmi,CbdvNF,AUTORIZACAO,Chave,nt_retorno FROM nfce "
SQL_Error_oQuery( )
oRow:= oQuery:GetRow(1)
For i:=1 to oQuery:LastRec()
oRow := oQuery:GetRow(i)
if oQuery:LastRec()>0
xCbdNtfNumero   :=NTRIM(oRow:fieldGet(1))
xCbdNtfSerie    :=(oRow:fieldGet(2))
XCbdEmpCodigo  	:=NTRIM(oRow:fieldGet(3))
XCbdxNome_dest  :=ALLTRIM(oRow:fieldGet(4))
XCbddEmi        :=DTOS(oRow:fieldGet(5))
XCbdvNF         :=NTRIM(oRow:fieldGet(6))
XAUTORIZACAO    :=(oRow:fieldGet(7))
XChave          :=(oRow:fieldGet(8))
xnt_retorno     :=(oRow:fieldGet(9))
 
*msginfo(XAUTORIZACAO)

If !Empty(XAUTORIZACAO) // se nao encontra vale a pesq pro nota fiscal
    * msginfo(XAUTORIZACAO)
 
else

*msginfo(XAUTORIZACAO)
eQuery := "INSERT INTO nfCE_CONTIGENCIA (CbdNtfNumero,CbdNtfSerie,CbdEmpCodigo,CbdxNome_dest,CbddEmi,CbdvNF,AUTORIZACAO,Chave,nt_retorno) VALUES ('"+xCbdNtfNumero+"','"+XCbdNtfSerie+"','"+XCbdEmpCodigo+"','"+XCbdxNome_dest+"','"+(XCbddEmi)+"','"+XCbdvNF+"','"+XAUTORIZACAO+"','"+XChave+"','"+xnt_retorno+"')" 
dQuery:=oServer:Query(eQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 MsgInfo("Deu Problemas nao gravou os itens ") 
 endif
dQuery:Destroy() 
end
oQuery:Skip(1)
endif
	
Next
*oQuery:Destroy()	
 enviar_XML_CONSULTA() 
RETURN




//-----------------------------------------------------------------------------.
FUNCTION Enviar_XML_CONSULTA()  
//-----------------------------------------------------------------------------.
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
LOCAL c_ChNFe :=""
LOCAL c_CFileDanfe:="C:\ACBrMonitorPLUS\"
local R_CStat:=""
publ path :=DiskName()+":\"+CurDir() 
Reconectar_A() 

ProcedureLerINI()
	CQuery:= "select CbdNtfNumero,CbdNtfSerie,Chave,nt_retorno FROM NFCE_CONTIGENCIA"  
  
	oQuery_Item:=oServer:Query( cQuery )
	If oQuery_Item:NetErr()												
       MsgStop(oQuery_Item:Error())
       Return .f.
	End 

nCount=0 
For i := 1 To oQuery_Item:LastRec()

  oRow := oQuery_Item:GetRow(i)
  oQuery_Item:Skip(1)
  pACode           :=NTRIM(oRow:fieldGet(1))
  xCbdNtfSerie     :=ALLTRIM(oRow:fieldGet(2))
  cChave           :=oRow:fieldGet(3)
 HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
 FWRITE(Handle,oRow:FieldGet(4))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"

NFe_ENV(alltrim(cTXT))

NFe_CON(ALLTRIM(cChave))

	cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
	lRetStatus:=EsperaResposta(cDestino) 
	    if lRetStatus==.t.
		////RETORNO////
	
BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
       GET R_CStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get c_ChNFe          section  "CONSULTA"       ENTRY "ChNFe"
	   get cNProt          section  "CONSULTA"       ENTRY "NProt"
	   get cXMotivo        section  "CONSULTA"       ENTRY "XMotivo"
END INI
End
	
public CR_CStat :=R_CStat
public C_XMotivo :=cXMotivo
public Cc_ChNFe  :=c_ChNFe
	*MSGINFO(cNProt)
	
   cQuery := "UPDATE NFCE SET AUTORIZACAO='"+cNProt+"' WHERE CbdNtfNumero = "+pACode+" and CbdNtfSerie = "+xCbdNtfSerie+" "

 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  *MsgInfo("ok")
  Endif
nCount++  
oQuery_Item:Skip(1)
Next
oQuery_Item:Destroy()
Return 





FUNCTION consultas_Contingencia_1()  

lRetorno_Internet:=IsInternet()
  if lRetorno_Internet==.f.
    xJust:="Sem acesso a Internet" 
     Ret_Status_Servico:=.f.
    else
end                 
if lRetorno_Internet==.f.
else 
consultas_Contingencia() 
endif
RETURN


