#Include "Minigui.ch"
//---------------------------------------------------------
* Autor: JOSE JUCA DE OLIVEIRA
* MINIGUI:Extended/Xharbour
* DATA 22/02/2015
*-----------------------------------------------------------
#include "minigui.ch"
#include "DbStruct.ch"
#INCLUDE "hbsetup.CH"
#include 'i_textbtn.ch'
#INCLUDE "TSBROWSE.CH"
#INCLUDE "INKEY.CH"
#include "minigui.ch"
#Include "F_sistema.ch"
#Include "JUMBOII.ch"
#include "common.ch"
#include "winprint.ch"
#define CLR_VERDE  RGB( 180, 255, 165)
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte 
#define CHAR_REMOVE  "/;-:,\.(){}[] "

//-----------------------------------------------------------------------------------------------
Function ATUALIZA_CONTIGENCIA()
//-----------------------------------------------------------------------------------------------
	
Ajanela := GetDesktopWidth() //* 0.78125
Ljanela := GetDesktopHeight() //* 0.78125 
SET BROWSESYNC ON	
  
IF ISWINDOWDEFINED(NFE_EMITIDA_CONTIGENCIA)
    RESTORE WINDOW NFE_EMITIDA_CONTIGENCIA
ELSE
      DEFINE WINDOW NFE_EMITIDA_CONTIGENCIA;
       AT 0100, 200 ;
       WIDTH 400;
       HEIGHT 350;
       TITLE "nFe/nfc_e Emitidas " ;
       icon cPathImagem+'JUMBO1.ico';
       MODAL;   
       NOSIZE;
	    ON INIT {||xml_NFE_EMITIDA_CONTIGENCIA()}
		
   
ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela

       
END WINDOW
CENTER WINDOW NFE_EMITIDA_CONTIGENCIA
ACTIVATE WINDOW NFE_EMITIDA_CONTIGENCIA
ENDIF
Return Nil



*________________________________________________________________________________________________
function xml_NFE_EMITIDA_CONTIGENCIA()
 local nLinha   := 0
 local nPagina  := 1
 local mtotal   :=0
 LOCAL oprint,dirimp:=GetCurrentFolder()
 PUBLIC NUMERO:=xSEQ_TEF := strzero(day(date() ),2 ) + strzero(month(date() ), 2 ) + strtran(time(), ':','' )
 PUBLIC cNombre
  cNumero:=RTRIM(STRTRAN(NUMERO,"/","_",1,len(NUMERO)))
  cNombre:="Relatorios"+"_"+cNumero
  
  vdata:=dtos(DATE)))-1
  vdata1:=dtos(DATE())
*-------------------------------------------------*
               
page = 1
F=60
Xtotal=0


oQuery := oServer:Query( "SELECT CbdNtfNumero,CbdvNF,CbddEmi,CbdvDesc_cob,CbdvOutro,CbdvDesc_ttlnfe,chave,MSCANCELAMENTO,nt_retorno,autorizacao From NFCE WHERE CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+"  Order By CbddEmi" )

If oQuery:NetErr()												
  MsGInfo("ERROR AO SELECIONAR TABELA11")
  RETURN NIL 
Endif
REG:=0
For i := 1 To oQuery:LastRec()
          oRow         := oQuery:GetRow(i)
          x_doc        := oRow:fieldGet(1)
          X_valor      := oRow:fieldGet(2)
  	      x_venc       := oRow:fieldGet(3) 
		  x_CHAVE      := oRow:fieldGet(7) 
        XMSCANCELAMENTO  := oRow:fieldGet(8) 
       
	   xautorizacao:=:= oRow:fieldGet(10) 
	
 msghinfo(xautorizacao)
 
	
/*
HANDLE :=FCREATE (PATH+"\"+x_CHAVE+".XML",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(9) )
ffxml  :=memoread(oRow:FieldGet(9))
FWRITE(Handle,RETORNO)
fclose(handle)  
public cTXT     :=PATH+"\"+x_CHAVE+".XML"

*/

F=F+4 
oQuery:Skip(1)
NEXT
/*
oQuery := oServer:Query( "SELECT chave,nt_retorno,CbdNtfNumero From NFE20 WHERE CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+"  Order By CbddEmi" )
Xmtotal:=0
If oQuery:NetErr()												
  MsGInfo("ERROR AO SELECIONAR TABELA")
  RETURN NIL 
Endif
REG:=0
For i := 1 To oQuery:LastRec()
          oRow         := oQuery:GetRow(i)
          x_CHAVE      := oRow:fieldGet(1) 
          X_CbdNtfNumero:=NTRIM(oRow:fieldGet(3)) 
	   


*HANDLE :=FCREATE (PATH+"\"+X_CbdNtfNumero+".XML",0)// cria o arquivo
HANDLE :=FCREATE (PATH+"\"+x_CHAVE+".XML",0)// cria o arquivo
RETORNO:=UnMaskBinData( oRow:FieldGet(2) )

FWRITE(Handle,RETORNO)
fclose(handle)  
public cTXT     :=PATH+"\"+x_CHAVE+".XML"
oQuery:Skip(1)
NEXT
oQuery:Destroy()
*/


msginfo( "Geração com sucesso")
ThisWindow.release
Return Nil


***********************************************************************************************
Function Criadir_XML()
 	
// Função para criar pastas e  sub-diretorios
LOCAL i, j, aSubDir, cSubDir, nError
lOCAL aNewDir := { "temp" }
PUBLIC NUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
*msginfo(NUMERO)

SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xANO     := dtoS(date())
xANO     :=ALLTRIM(SUBSTR(XANO,0,4))
resultado:=alltrim(NUMERO+xANO)

         cSubDir := DiskName()+":\"+CurDir()+"\"+resultado+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
*            msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
 *           msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
            ENDIF

Return
