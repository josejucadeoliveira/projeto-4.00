#include 'minigui.ch'
#INCLUDE "WINPRINT.CH"
*#include "FastRepH.CH"
#include "lang_pt.ch"
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
*#include "MiniGui.ch"
#define _use_CallDLL

//---------------------------------------------------------
Function Consulta_NFEc() 
//-------------------------------------------
Local oRow
Local i
local c_nf
Local oQuery

*ANNOUNCE RDDSYS
Memvar _usuario
Memvar _senha
Memvar _smtp
Memvar _ident
Memvar _de
Memvar _autentica


cHostName:= AllTrim(cHostName)
cUser    := AllTrim(cUser )
cPassWord:= AllTrim(cPassWord)
oServer := TMySQLServer():New(cHostName, cUser, cPassWord )
If oServer:NetErr() 
 MsGInfo("Erro na conecção com o Servidor SQL: " + oServer:Error() )
  RETURN .F.
*   Form_0.Release
 Endif               	

 IsInternet_1()

DEFINE WINDOW janelanfe;
      AT 00, 00 ;
       WIDTH 1024 ;
       HEIGHT 740 ;
       TITLE "Cupom emitidos" ;
       MODAL;   
       NOSIZE
	   
	   
 ON KEY ESCAPE ACTION janelanfe.release //tecla ESC para fechar a janela

//------------------------------------
	   
      @ 540, 670   LABEL oSay1  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Total R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 


   @ 530, 810  FRAME oGrp2 ;
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

    DEFINE LABEL Total_Geral1
            ROW    618
            COL    810
            WIDTH  180
            HEIGHT 34
            VALUE ""
            FONTNAME 'Times New Roman' 
            FONTSIZE 25
            FONTBOLD .T.
            BACKCOLOR {255,255,0} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.
     END LABEL  
	 
   DEFINE LABEL Total_Geral
            ROW    540
            COL    810
            WIDTH  180
            HEIGHT 34
            VALUE ""
            FONTNAME 'Times New Roman' 
            FONTSIZE 25
            FONTBOLD .T.
            BACKCOLOR {255,255,0} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.
	END LABEL  
//-------------------------------------
   @ 570, 670   FRAME oGrp11 ;
   CAPTION ""  ;
   WIDTH 120 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

      @ 580, 670 LABEL oSay11  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Desconto R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 
//---------------------------------------------
   @ 570, 810  FRAME oGrp13 ; 
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

   DEFINE LABEL Total_desc
            ROW    580
            COL    810
            WIDTH  180
            HEIGHT 34
            VALUE ""
            FONTNAME 'Times New Roman' 
            FONTSIZE 25
            FONTBOLD .T.
            BACKCOLOR {255,255,0} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.
     END LABEL  
//-------------------------------------
   @ 610, 670   FRAME oGrp12 ;
   CAPTION ""  ;
   WIDTH 120 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

      @ 618, 670 LABEL oSay12  ;
      WIDTH 120 ;
      HEIGHT 034 ;
      VALUE " Total R$"  ;
      FONT "MS Sans Serif" SIZE 18.00 ;
      FONTCOLOR { 000, 000, 255 };
      BACKCOLOR { 192, 192, 192 } BOLD 
 
 @ 610, 810  FRAME oGrp22 ;
   CAPTION ""  ;
   WIDTH 180 ;
   HEIGHT 044 ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 064, 128, 128 }

  DEFINE LABEL Total_Geral1
            ROW    618
            COL    810
            WIDTH  180
            HEIGHT 34
            VALUE ""
            FONTNAME 'Times New Roman' 
            FONTSIZE 25
            FONTBOLD .T.
            BACKCOLOR {255,255,0} 
            FONTCOLOR {255,0,0}
            RIGHTALIGN .T.

			
@ 500,00 LABEL  Label_Search_Generic ;
    VALUE "Pesquisa Nome/Barras " ;
    WIDTH 150 ;
    HEIGHT 40

  @ 500,190 TEXTBOX cSearch ;
    WIDTH 200 ;
    MAXLENGTH 60 ;
    UPPERCASE  ;
    backcolor _AMARELO;
    ON enter iif( !Empty(janelanfe.cSearch.Value), Grid_notas(), janelanfe.cSearch.SetFocus )
  
  
	 DEFINE BUTTON Button_52
           ROW   600
           COL    00
           WIDTH  250
           HEIGHT 28
           CAPTION "Imprime_Cancelamento"
           Action  lerxml_cancelamento()         
     END BUTTON  

	 
	 DEFINE BUTTON Button_5422
           ROW   550
           COL    00
           WIDTH  250
           HEIGHT 28
           CAPTION "Conaultar nfe no Site"
           Action  Consulta_nfe()         
     END BUTTON  
	  
	 DEFINE BUTTON Button_54222
           ROW   550
           COL    300
           WIDTH  250
           HEIGHT 28
           CAPTION "Conaultar nfe no Site"
           Action   imprime_cce()         
     END BUTTON  
	 
	* imprime_cce()
	 
  
  
	 DEFINE BUTTON Button_542
           ROW   600
           COL    300
           WIDTH  250
           HEIGHT 28
           CAPTION "Imprime_carta_correção"
           Action   lerxml_cce()        
     END BUTTON  

  
  
    DEFINE BUTTON Button_3
           ROW   650
           COL    00
           WIDTH  100
           HEIGHT 28
           CAPTION "Voltar"
         Action  janelanfe.RELEASE
     END BUTTON  

 DEFINE BUTTON Button_2
           ROW   650
           COL   110
           WIDTH  100
           HEIGHT 28
           CAPTION "Cancelar-NFe"
           Action {|| CANCELA_aviso() }        
     END BUTTON  
 
  DEFINE BUTTON Button_4
           ROW    650
           COL    220
           WIDTH  200
           HEIGHT 28
           CAPTION "Visualizar-Imprimir-NFe"
           Action  lerxml()         
     END BUTTON  

  DEFINE BUTTON Button_6
           ROW    650
           COL    420
           WIDTH  200
           HEIGHT 28
           CAPTION "Enviar Email "
           Action  enviar_xml()         
     END BUTTON  


 
  
  DEFINE GRID Grid_notas
            ROW    36
            COL    00
		    WIDTH  1020
            HEIGHT 200
            WIDTHS {100,400,150,150,150,110,110,110,400,120,200,200}
            HEADERS {'NºNfe','Clientes','Cnpj','Cpf','Inscricao','valor R$','Desconto','Total','Chave','Emissão','xml',"Email"}        
            JUSTIFY {1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1}
            FONTNAME "Arial Baltic"
            FONTSIZE 11
           ON CHANGE { acha_itens1C(),TOTAL()   }
	END GRID  

 DEFINE GRID Grid_itens
            ROW    235 
            COL    003  
            WIDTH  1024
            HEIGHT 265
            WIDTHS {40,80,80,400,80,80,80,100,5100}
            HEADERS {'Itens','Código','NºNfe','Produtos','Ncm','Cfop','Qtd','Unit','Total'}
            Justify {1,1,0,0,0,1,1,1,1,1,1,1,1,1}
            FONTNAME "Arial Baltic"
            FONTSIZE 10
	END GRID  

	
	     
			  @ 010,630 LABEL    lData    VALUE "DATA" ;
			  BOLD AUTOSIZE TRANSPARENT
			  
            //  @ 010,680 TEXTBOX  tData    VALUE DATE() BOLD DATE ON ENTER CarregaGridDATA()
	
	
 DEFINE STATUSBAR of janelanfe
          STATUSITEM "Conectado no IP: "+C_IPSERVIDOR WIDTH 150
          DATE
          CLOCK
          KEYBOARD
      END STATUSBAR
janelanfe.cSearch.Value:= "A" 
janelanfe.cSearch.SetFocus
Grid_notas()
END WINDOW
ACTIVATE WINDOW janelanfe
Return Nil
*--------------------------------------------------------------*
STATIC Function Grid_notas()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(janelanfe.cSearch.Value ))+'%" '           
Local nCounter:= 0
Local oRow
Local i
local c_nf
Local oQuery
local c_encontro
DELETE ITEM ALL FROM Grid_notas Of janelanfe

My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
oQuery := oServer:Query( "Select CbdNtfNumero,CbdxNome_dest,CbdCNPJ_dest,CbdCPf_dest,CbdIE_dest,CbdvProd_ttlnfe,CbdvDesc_ttlnfe,CbdvNF,chave,CbddEmi,nt_retorno,CbdxEmail_dest From NFE20 WHERE CbdxNome_dest like "+cSearch+" Order By CbddEmi" )
		   
				   
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif
REG:=0
oRow := oQuery:GetRow(1)
c_encontro:=oRow:fieldGet(1)

If !Empty(c_encontro) // se nao encontra vale a pesq pro nota fiscal
else
c_nf:=CHARREM(janelanfe.cSearch.Value)
c_nf:=CHARREM(CHAR_REMOVE,janelanfe.cSearch.Value )
c_nf:=val(c_nf)
c_nf:=alltrim(str(c_nf))
c_nf:=LPAD(STR(val(c_nf)),8,[0])
c_nf:= ' "'+Upper(AllTrim(c_nf))+'%" '         

 oQuery := oServer:Query( "Select CbdNtfNumero,CbdxNome_dest,CbdCNPJ_dest,CbdCPf_dest,CbdIE_dest,CbdvProd_ttlnfe,CbdvDesc_ttlnfe,CbdvNF,CbddEmi,nt_retorno,CbdxEmail_dest From NFE20 WHERE CbdNtfNumero like "+c_nf+" Order By CbddEmi" )
 
janelanfe.cSearch.setfocus
janelanfe.cSearch.Value:='A'
EndIf

For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  ADD ITEM { STR(oRow:fieldGet(1),11),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),(oRow:fieldGet(5)),transform((oRow:fieldGet(6)),"@R 99,999.99"),transform((oRow:fieldGet(7)),"@R 99,999.99"),transform((oRow:fieldGet(8)),"@R 99,999.99"),oRow:fieldGet(9),transform((oRow:fieldGet(10)),"D"),(oRow:fieldGet(11)),(oRow:fieldGet(12)) } TO Grid_notas Of janelanfe
 oQuery:Skip(1)
  Next
oQuery:Destroy()
*janelanfe.cSearch.SetFocus  
janelanfe.Grid_notas.value:=1
janelanfe.Grid_notas.setfocus
Return Nil

*--------------------------------------------------------------*
Function acha_itens1C()                     
*--------------------------------------------------------------*
//Local cSearch:= ' "'+Upper(AllTrim(janelanfe.cSearch.Value ))+'%" '           
Local pCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local nCounter:= 0
Local oRow
Local i
Local oQuery
local c_encontro
DELETE ITEM ALL FROM Grid_itens Of janelanfe
XUNIT1=0
XQUANT1=0
REG:=0
NTOTAL=0
*oQuery:Destroy()

My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
 oQuery := oServer:Query( "Select CbdNtfNumero,CbdcProd,CbdxProd,CbdNCM ,CbdCFOP,CbdqCOM,CbdvUnCom,CbdvProd From NFEITEM WHERE CbdNtfNumero LIKE "+pcode+" Order By CbdxProd" )
		   
If oQuery:NetErr()												
  MsgInfo("ERROR NO SEVIDOR MYSQL " + oQuery:Error())
 Return Nil
Endif

  
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
REG=REG+1
  ADD ITEM { str(reg,4),str(oRow:fieldGet(1),11),(oRow:fieldGet(2)),(oRow:fieldGet(3)),(oRow:fieldGet(4)),str(oRow:fieldGet(5),8),transform((oRow:fieldGet(6)),"@R 99,999.99"),transform((oRow:fieldGet(7)),"@R 99,999.99"),transform((oRow:fieldGet(8)),"@R 99,999.99") } TO Grid_itens Of janelanfe
  oQuery:Skip(1)
Next
oQuery:Destroy()
Return Nil




*--------------------------------------------------------------*
STATIC Function TOTAL()                     
*--------------------------------------------------------------*
Local pCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local nCounter:= 0
Local oRow
Local i
Local oQuery
local c_encontro
XUNIT1=0
XQUANT1=0
REG:=0
NTOTAL=0
NFRETE=0
NNTOTAL=0
NDESCONTO=0

My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
oQuery := oServer:Query( "Select CbdvProd_ttlnfe,CbdvDesc_ttlnfe,CbdvNF,MSCANCELAMENTO From NFE20 WHERE CbdNtfNumero LIKE "+pcode+" Order By CbddEmi" )

oRow  := oQuery:GetRow(1)
      MODIFY CONTROL Total_Geral    OF janelanfe Value ''+TransForm(oRow:fieldGet(1),"@R 999,999.99")
      MODIFY CONTROL Total_desc     OF janelanfe VALUE ''+TransForm(oRow:fieldGet(2),"@R 999,999.99")     	 
      MODIFY CONTROL Total_Geral1   OF janelanfe VALUE ''+TransForm(oRow:fieldGet(3),"@R 999,999.99")  
	  
	  
If !Empty(oRow:fieldGet(4)) // 
   MsgInfo(oRow:fieldGet(4) , "ATENÇÃO")
  //  Return .f. 
   else
 //   MsgInfo("Nao Enntrado: " , "ATENÇÃO")
  // CANCELA_NFe.RELEASE   
  
 EndIf
 
 
oQuery:Destroy()
Return Nil


*--------------------------------------------------------------*
 STATIC Function GetColValue( xObj, xForm, nCol)
*--------------------------------------------------------------*
  Local nPos:= GetProperty(xForm, xObj, 'Value')
  Local aRet:= GetProperty(xForm, xObj, 'Item', nPos)
Return aRet[nCol]




//**************************************
STATIC FUNCTION CANCELA_aviso()
//**************************************
  DEFINE WINDOW CANCELA_NFe;
  AT 200,400;
  WIDTH 350;
  HEIGHT 50;
  MODAL ;
  NOCAPTION;
 ON INIT {|| pega_chave()}
 
  @ 10,010  LABEL aviso ;
   WIDTH 350;
   HEIGHT 20 ;
   VALUE ""  ;
   FONT "Perpetua Titling MT" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 } BOLD 
END WINDOW
	CENTER WINDOW CANCELA_NFe
	ACTIVATE WINDOW CANCELA_NFe

RETURN .T.


*--------------------------------------------------------------*
STATIC Function pega_chave()                     
*--------------------------------------------------------------*
Local pchave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 9 ))))
Local paCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local pemail:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 12 ))))
local aArqGet, x
Local nCounter:= 0
local ppchave:=""
Local oRow,ninfEventoId
Local i
Local oQuery
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
local path :=DiskName()+":\"+CurDir()

   My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
  cQuery:= "select CHAVE FROM nfe20  WHERE CbdNtfNumero = " + AllTrim(pACode)      
  oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
	
If !Empty(pchave) // se nao encontra vale a pesq pro nota fiscal
   else
     MsgInfo("Nao Enntrado: " , "ATENÇÃO")
   CANCELA_NFe.RELEASE   
   Return .f. 
 EndIf
  
 MODIFY CONTROL AVISO OF CANCELA_NFe VALUE   'Solicitando o Cancelamento Aguarde...' 

ERASE "C:\ACBrNFeMonitor\sainfe.txt"

NFe_CAN(pchave)

ProcedureLerINI_1()



  cFileDanfe:="C:\ACBrNFeMonitor\SAINFE.TXT"
  lRetStatus:=EsperaResposta_A(cFileDanfe) 
   if lRetStatus==.t.  ////pego os dados
     end
cFileDanfe := 'C:\ACBrNFeMonitor\sainfe.txt'
BEGIN INI FILE cFileDanfe
      ////CANCELAMENTO//////////////////////////////////////////////////////
       GET cCStat          SECTION  "CANCELAMENTO"       ENTRY "CStat"
	   GET cXMotivo        SECTION  "CANCELAMENTO"       ENTRY "XMotivo"
       GET cDhRecbto       SECTION  "CANCELAMENTO"       ENTRY "DhRecbto"
	   GET cNProt          SECTION  "CANCELAMENTO"       ENTRY "NProt"
	   get ninfEventoId    section  "CANCELAMENTO"       ENTRY "<infEvento Id"
	   
   	 /////////////////////////////////////////////////////////////
END INI

public  c_CStat   :=cCStat
public C_XMotivo  :=cXMotivo
public c_DhRecbto :=cDhRecbto
public c_NProt    :=cNProt
PUBLIC  cPesqEVENT:= Substr(ninfEventoId,4,53)

 
jfxml  :="C:\ACBrNFeMonitor\SAINFE.TXT"
ffxml :=memoread(jfxml)
serial             :='Evento'
cFileSaida         := "C:\ACBrNFeMonitor\"+pchave+"11011101-procEventoNFe.XML"
*msginfo(cFileSaida)
ffxml             :=memoread(cFileSaida)
serial:='Evento'
cFileSaida := "C:\ACBrNFeMonitor\"+pchave+"11011101-procEventoNFe.XML"
                                        

	
if c_CStat="579"
    Return .f.
 	Msginfo(cXMotivo)
	CANCELA_NFe.RELEASE
    janelanfe.RELEASE
	
	
EndIf									
										
										
if c_CStat="573"
 	Msginfo(cXMotivo)
	c_XMotivo:='Evento registrado e vinculado a NF-e'
 
   cQuery	:= oServer:Query( "UPDATE nfe20 SET MSCANCELAMENTO  = '"+c_XMotivo+"' ,RETORNO_EVENTO  = '"+ffxml+"' , DATAHORA = '"+c_DhRecbto+"' WHERE CbdNtfNumero = " +(alltrim(paCode)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
 	Msginfo(cXMotivo)
EndIf
ENDIF


if c_CStat="271"
 	Msginfo(cXMotivo)
EndIf


if c_CStat="135"
   cQuery	:= oServer:Query( "UPDATE nfe20 SET CANCELAMENTO='"+alltrim(c_NProt)+"',MSCANCELAMENTO  = '"+C_XMotivo+"' ,RETORNO_EVENTO  = '"+ffxml+"' , DATAHORA = '"+c_DhRecbto+"' WHERE CbdNtfNumero = " +(alltrim(paCode)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
 	Msginfo(cXMotivo)
EndIf
endif



if c_CStat="135"

cNomeArqTXT:=cFileSaida
/*
cArquivo:= MEMOREAD(cNomeArqTXT)
HANDLE :=  FCREATE (path+"\"+serial+".XML",0)// cria o arquivo
IF HANDLE = -1
  MsgINFO ( 'houve erro na criação do arquivo')
ELSE
   FWRITE (HANDLE, ALLTRIM(cArquivo))
ENDIF
FCLOSE(HANDLE)
*/


 _smtp   :="smtp.gmail.com"
 _emai_  :=ffxml
 _usuario:="medialcomercio@gmail.com"
 _senha  := "jo1801" 
  _id    := "medialcomercio@gmail.com"
 _de     := "CASA DAS EMBALAGENS"
_assunto_:= pchave+".XML"
_para_   := pemail
_anexo_  :="Evento.XML"
_autentica := .T.
cEnviaPDF:='1'
cEmailsCopias:='1'
cTMP:='10'
NFe_EMAevento(pemail,cFileSaida)
endif
CANCELA_NFe.RELEASE
janelanfe.RELEASE
Return Nil



*--------------------------------------------------------------*
STATIC Function lerxml_RETORNO()                   
*--------------------------------------------------------------*
Local pchave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 9 ))))
Local paCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))

Local nCounter:= 0
local ppchave:=""
Local oRow,FC_NORMAL
Local i
Local oQuery
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
//Local cDoc:='nfe.xml'
local path :=DiskName()+":\"+CurDir()

   My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
  cQuery:= "select CHAVE,retorno_EVENTO FROM nfe20  WHERE CbdNtfNumero = " + AllTrim(pACode)      
  oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
    
//MemoWrit( cDoc ,( oRow:FieldGet(2) ) )
	    
 HANDLE :=  FCREATE ("CANCELAMENTO.XML",0)// cria o arquivo
    FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\CANCELAMENTO.XML"
*MSGINFO(cTXT)
*NFe_IMP(alltrim(cTXT))
 *  HB_SendMail("servidor.com.br",25,"remetente@exemplo.com.br",{"destinatario@@exemplo.com.br"}, , ,"CORPO","ASSUNTO", {"ANEXO.TXT"} , "usuario@exemplo.com.br", "123456","servidor.com.br", 3 , .F.,.F.,.F.)

Return Nil


   
*--------------------------------------------------------------*
STATIC Function lerxml()                   
*--------------------------------------------------------------*
Local pchave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 9 ))))
Local paCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))

Local nCounter:= 0
local ppchave:=""
Local oRow
Local i
Local oQuery
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
//Local cDoc:='nfe.xml'
local path :=DiskName()+":\"+CurDir()

   My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
  cQuery:= "select CHAVE,nt_retorno FROM nfe20  WHERE CbdNtfNumero = " + AllTrim(pACode)      
  oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
    
//MemoWrit( cDoc ,( oRow:FieldGet(2) ) )
	    
 HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
    FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"
*MSGINFO(cTXT)
NFe_IMP(alltrim(cTXT))
Return Nil



*--------------------------------------------------------------*
STATIC Function enviar_xml()                   
*--------------------------------------------------------------*
Local pchave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 9 ))))
Local paCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local xnome:=  (AllTrim((GetColValue( "Grid_notas", "janelanfe", 2 ))))
Local xxnome := '"'+Upper(AllTrim(xnome))+'%" '

*Local eemail:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))
Local nCounter:= 0
local ppchave:=""
Local oRow
Local i
Local oQuery
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
//Local cDoc:='nfe.xml'
local path :=DiskName()+":\"+CurDir()

  My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
  cQuery:= "select CHAVE,nt_retorno FROM nfe20  WHERE CbdNtfNumero = " + AllTrim(pACode)      
  oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
 HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
 FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  
public cTXT     :=PATH+"\NOTA.XML"


*nChave:=ntrim(xCOD_CLI)
fQuery:= "Select email from cliente WHERE razaosoc LIKE "+xxnome 

* fQuery := oServer:Query( "Select email, codigo, razaosoc, cnpj, ie ,data_Cad  From cliente WHERE razaosoc LIKE "+xxnome+"" )

 
 fQuery:=oServer:Query( fQuery )
    If fQuery:NetErr()												
     MsgStop(fQuery:Error())
 // NFE.textBTN_cliente.setfocuS
   Return .f.
 EndIf

fRow         :=fQuery:GetRow(1)
xemail       :=fRow:fieldGet(1)
eemail:= AllTrim(xemail)
*msginfo(eemail)
NFe_EMA(eemail,alltrim(cTXT))
fQuery:Destroy()
Return Nil















FUNCTION COD_RETORNONFE(R_CStat)
//CÓDIGO E RESULTADO DO PROCESSAMENTO DA SOLICITAÇÃO


if R_CStat ='101' // - Cancelamento de NF-e homologado
msginfo(C_XMotivo)


elseif R_CStat ='100' // - Inutilização de número homologado
msginfo(C_XMotivo)

elseif R_CStat ='102' // - Inutilização de número homologado
msginfo(C_XMotivo)

elseif R_CStat ='103' // Lote recebido com sucesso
msginfo(C_XMotivo)

elseif R_CStat ='104'  // Lote processado
msginfo(C_XMotivo)

elseif R_CStat ='105' // Lote em processamento
msginfo(C_XMotivo)

elseif R_CStat ='106' // Lote não localizado
msginfo(C_XMotivo)

elseif R_CStat ='107' // Serviço em Operação
msginfo(C_XMotivo)

elseif R_CStat ='108'// Serviço Paralisado Momentaneamente (curto prazo)
msginfo(C_XMotivo)

elseif R_CStat ='109' // Serviço Paralisado sem Previsão
msginfo(C_XMotivo)

elseif R_CStat ='110' //  Uso Denegado
msginfo(C_XMotivo)

elseif R_CStat ='111'// Consulta cadastro com uma ocorrência
msginfo(C_XMotivo)

elseif R_CStat ='112' // Serviço Paralisado sem Previsão
msginfo(C_XMotivo)
/////////////////////////////////////////
//CÓDIGO E MOTIVOS DE NÃO ATENDIMENTO DA SOLICITAÇÃO
/////////////////////////////////////////////////////
elseif R_CStat ='201' // Rejeição: O numero máximo de numeração de NF-e a inutilizar ultrapassou o limite
msginfo(C_XMotivo)

elseif R_CStat ='202' // Rejeição: Falha no reconhecimento da autoria ou integridade do arquivo digital
msginfo(C_XMotivo)

elseif R_CStat ='203' // Rejeição: Emissor não habilitado para emissão da NF-e
msginfo(C_XMotivo)

elseif R_CStat ='204'//204 Rejeição: Duplicidade de NF-e
msginfo(C_XMotivo)

elseif R_CStat ='205' //Rejeição: NF-e está denegada na base de dados da SEFAZ
msginfo(C_XMotivo)

elseif R_CStat ='206' //Rejeição: NF-e já está inutilizada na Base de dados da SEFAZ
msginfo(C_XMotivo)

elseif R_CStat ='207' //Rejeição: CNPJ do emitente inválido
msginfo(C_XMotivo)

elseif R_CStat ='208' //Rejeição: CNPJ do destinatário inválido
msginfo(C_XMotivo)

elseif R_CStat ='209' //Rejeição: IE do emitente inválida
msginfo(C_XMotivo)

elseif R_CStat ='210' //Rejeição: IE do destinatário inválida
msginfo(C_XMotivo)

elseif R_CStat ='211' //Rejeição: IE do substituto inválida
msginfo(C_XMotivo)

elseif R_CStat ='212' //Rejeição: Data de emissão NF-e posterior a data de recebimento
msginfo(C_XMotivo)

elseif R_CStat ='213' //Rejeição: CNPJ-Base do Emitente difere do CNPJ-Base do Certificado Digital
msginfo(C_XMotivo)

elseif R_CStat ='214' // Rejeição: Tamanho da mensagem excedeu o limite estabelecido
msginfo(C_XMotivo)

elseif R_CStat ='215' // Rejeição: Falha no schema XML
msginfo(C_XMotivo)

elseif R_CStat ='216' // Rejeição: Chave de Acesso difere da cadastrada
msginfo(C_XMotivo)

elseif R_CStat ='217' // Rejeição: NF-e não consta na base de dados da SEFAZ
msginfo(C_XMotivo)

elseif R_CStat ='218' // Rejeição: NF-e já esta cancelada na base de dados da SEFAZ
msginfo(C_XMotivo)

elseif R_CStat ='219' // Rejeição: Circulação da NF-e verificada
msginfo(C_XMotivo)

elseif R_CStat ='220' // Rejeição: NF-e autorizada há mais de 60 dias
msginfo(C_XMotivo)

elseif R_CStat ='221' // Rejeição: Confirmado o recebimento da NF-e pelo destinatário
msginfo(C_XMotivo)

elseif R_CStat ='222' // Rejeição: Protocolo de Autorização de Uso difere do cadastrado
msginfo(C_XMotivo)

elseif R_CStat ='223' // Rejeição: CNPJ do transmissor do lote difere do CNPJ do transmissor da consulta
msginfo(C_XMotivo)

elseif R_CStat ='224' // Rejeição: A faixa inicial é maior que a faixa final
msginfo(C_XMotivo)

elseif R_CStat ='225' // Rejeição: Falha no Schema XML da NFe
msginfo(C_XMotivo)

elseif R_CStat ='226' // Rejeição: Código da UF do Emitente diverge da UF autorizadora
msginfo(C_XMotivo)

elseif R_CStat ='227' // Rejeição: Erro na Chave de Acesso - Campo ID
msginfo(C_XMotivo)

elseif R_CStat ='228' // Rejeição: Falha no Schema XML da NFe
msginfo(C_XMotivo)

elseif R_CStat ='229' // Rejeição: IE do emitente não informada
msginfo(C_XMotivo)

elseif R_CStat ='230' // Rejeição: IE do emitente não cadastrada
msginfo(C_XMotivo)

elseif R_CStat ='231' // Rejeição: IE do emitente não vinculada ao CNPJ
msginfo(C_XMotivo)

elseif R_CStat ='232' //  Rejeição: IE do destinatário não informada
msginfo(C_XMotivo)

elseif R_CStat ='233' // Rejeição: IE do destinatário não cadastrada
msginfo(C_XMotivo)

elseif R_CStat ='234' // Rejeição: IE do emitente não vinculada ao CNPJ
msginfo(C_XMotivo)

elseif R_CStat ='235' // Rejeição: Inscrição SUFRAMA inválida
msginfo(C_XMotivo)

elseif R_CStat ='236' // Rejeição: Chave de Acesso com dígito verificador inválido
msginfo(C_XMotivo)

elseif R_CStat ='237' // Rejeição: CPF do destinatário inválido
msginfo(C_XMotivo)

elseif R_CStat ='238' // Rejeição: Cabeçalho - Versão do arquivo XML superior a Versão vigente
msginfo(C_XMotivo)

elseif R_CStat ='239' // Rejeição: Cabeçalho - Versão do arquivo XML não suportada
msginfo(C_XMotivo)

elseif R_CStat ='240' // Rejeição: Cancelamento/Inutilização - Irregularidade Fiscal do Emitente
msginfo(C_XMotivo)

elseif R_CStat ='241' // Rejeição: Um número da faixa já foi utilizado
msginfo(C_XMotivo)

elseif R_CStat ='242' // Rejeição: Cabeçalho - Falha no Schema XML
msginfo(C_XMotivo)

elseif R_CStat ='243' // Rejeição: XML Mal Formado
msginfo(C_XMotivo)

elseif R_CStat ='244' // Rejeição: CNPJ do Certificado Digital difere do CNPJ da Matriz e do CNPJ do Emitente
msginfo(C_XMotivo)

elseif R_CStat ='245' // Rejeição: CNPJ Emitente não cadastrado
msginfo(C_XMotivo)

elseif R_CStat ='246' // Rejeição: CNPJ Destinatário não cadastrado
msginfo(C_XMotivo)

elseif R_CStat ='247' // Rejeição: Sigla da UF do Emitente diverge da UF autorizadora
msginfo(C_XMotivo)

elseif R_CStat ='248' //  Rejeição: UF do Recibo diverge da UF autorizadora
msginfo(C_XMotivo)

elseif R_CStat ='249' //  Rejeição: UF do Recibo diverge da UF autorizadora
msginfo(C_XMotivo)

elseif R_CStat ='250' //  Rejeição: UF diverge da UF autorizadora
msginfo(C_XMotivo)

elseif R_CStat ='251' //  Rejeição: UF/Município destinatário não pertence a SUFRAMA
msginfo(C_XMotivo)

elseif R_CStat ='252' // Rejeição: Ambiente informado diverge do Ambiente de recebimento
msginfo(C_XMotivo)

elseif R_CStat ='253' //  Rejeição: Digito Verificador da chave de acesso composta inválida
msginfo(C_XMotivo)

elseif R_CStat ='254' //  Rejeição: NF-e referenciada não informada para NF-e complementar
msginfo(C_XMotivo)

elseif R_CStat ='255' //  Rejeição: Informada mais de uma NF-e referenciada para NF-e complementar
msginfo(C_XMotivo)

elseif R_CStat ='256' //  Rejeição: Uma NF-e da faixa já está inutilizada na Base de dados da SEFAZ
msginfo(C_XMotivo)

elseif R_CStat ='257' //  Rejeição: Solicitante não habilitado para emissão da NF-e
msginfo(C_XMotivo)

elseif R_CStat ='258' //  Rejeição: CNPJ da consulta inválido
msginfo(C_XMotivo)

elseif R_CStat ='259' //   Rejeição: CNPJ da consulta não cadastrado como contribuinte na UF
msginfo(C_XMotivo)

elseif R_CStat ='260' //  Rejeição: IE da consulta inválida
msginfo(C_XMotivo)

elseif R_CStat ='261' // 261 Rejeição: IE da consulta não cadastrada como contribuinte na UF
msginfo(C_XMotivo)

elseif R_CStat ='262' // 262 Rejeição: UF não fornece consulta por CPF
msginfo(C_XMotivo)

elseif R_CStat ='263' // 263 Rejeição: CPF da consulta inválido
msginfo(C_XMotivo)

elseif R_CStat ='264' //264 Rejeição: CPF da consulta não cadastrado como contribuinte na UF
msginfo(C_XMotivo)

elseif R_CStat ='265' // 265 Rejeição: Sigla da UF da consulta difere da UF do Web Service
msginfo(C_XMotivo)

elseif R_CStat ='266' // 266 Rejeição: Série utilizada não permitida no Web Service
msginfo(C_XMotivo)

elseif R_CStat ='267' // 267 Rejeição: NF Complementar referencia uma NF-e inexistente
msginfo(C_XMotivo)

elseif R_CStat ='268' // 268 Rejeição: NF Complementar referencia uma outra NF-e Complementar
msginfo(C_XMotivo)

elseif R_CStat ='269' //269 Rejeição: CNPJ Emitente da NF Complementar difere do CNPJ da NF Referenciada
msginfo(C_XMotivo)

elseif R_CStat ='270' //270 Rejeição: Código Município do Fato Gerador: dígito inválido
msginfo(C_XMotivo)

elseif R_CStat ='271' // 271 Rejeição: Código Município do Fato Gerador: difere da UF do emitente
msginfo(C_XMotivo)

elseif R_CStat ='272' // 265 Rejeição: Sigla da UF da consulta difere da UF do Web Service
msginfo(C_XMotivo)

elseif R_CStat ='273' //273 Rejeição: Código Município do Emitente: difere da UF do emitente
msginfo(C_XMotivo)

elseif R_CStat ='274' // 274 Rejeição: Código Município do Destinatário: dígito inválido
msginfo(C_XMotivo)

elseif R_CStat ='275' // 275 Rejeição: Código Município do Destinatário: difere da UF do Destinatário
msginfo(C_XMotivo)

elseif R_CStat ='276' // 276 Rejeição: Código Município do Local de Retirada: dígito inválido
msginfo(C_XMotivo)

elseif R_CStat ='277' // 277 Rejeição: Código Município do Local de Retirada: difere da UF do Local de Retirada
msginfo(C_XMotivo)

elseif R_CStat ='278' //278 Rejeição: Código Município do Local de Entrega: dígito inválido
msginfo(C_XMotivo)

elseif R_CStat ='279' // 279 Rejeição: Código Município do Local de Entrega: difere da UF do Local de Entrega
msginfo(C_XMotivo)

elseif R_CStat ='280' // 280 Rejeição: Certificado Transmissor inválido
msginfo(C_XMotivo)

elseif R_CStat ='281' // 281 Rejeição: Certificado Transmissor Data Validade
msginfo(C_XMotivo)

elseif R_CStat ='282' // 282 Rejeição: Certificado Transmissor sem CNPJ
msginfo(C_XMotivo)

elseif R_CStat ='283' // 283 Rejeição: Certificado Transmissor - erro Cadeia de Certificação
msginfo(C_XMotivo)

elseif R_CStat ='284' //284 Rejeição: Certificado Transmissor revogado
msginfo(C_XMotivo)

elseif R_CStat ='285' // 285 Rejeição: Certificado Transmissor difere ICP-Brasil
msginfo(C_XMotivo)

elseif R_CStat ='286' // 286 Rejeição: Certificado Transmissor erro no acesso a LCR
msginfo(C_XMotivo)

elseif R_CStat ='287' // 287 Rejeição: Código Município do FG - ISSQN: dígito inválido
msginfo(C_XMotivo)

elseif R_CStat ='288' // 288 Rejeição: Código Município do FG - Transporte: dígito inválido
msginfo(C_XMotivo)

elseif R_CStat ='289' // 289 Rejeição: Código da UF informada diverge da UF solicitada
msginfo(C_XMotivo)

elseif R_CStat ='290' // 290 Rejeição: Certificado Assinatura inválido
msginfo(C_XMotivo)

elseif R_CStat ='291' // 291 Rejeição: Certificado Assinatura Data Validade
msginfo(C_XMotivo)

elseif R_CStat ='292' //292 Rejeição: Certificado Assinatura sem CNPJ
msginfo(C_XMotivo)

elseif R_CStat ='293' // 293 Rejeição: Certificado Assinatura - erro Cadeia de Certificação
msginfo(C_XMotivo)

elseif R_CStat ='294' // 294 Rejeição: Certificado Assinatura revogado
msginfo(C_XMotivo)

elseif R_CStat ='295' // 295 Rejeição: Certificado Assinatura difere ICP-Brasil
msginfo(C_XMotivo)

elseif R_CStat ='296' //296 Rejeição: Certificado Assinatura erro no acesso a LCR
msginfo(C_XMotivo)

elseif R_CStat ='297' // 297 Rejeição: Assinatura difere do calculado
msginfo(C_XMotivo)

elseif R_CStat ='298' // 298 Rejeição: Assinatura difere do padrão do Projeto
msginfo(C_XMotivo)

elseif R_CStat ='299' // 299 Rejeição: XML da área de cabeçalho com codificação diferente de UTF-8
msginfo(C_XMotivo)

elseif R_CStat ='401' // 401 Rejeição: CPF do remetente inválido
msginfo(C_XMotivo)

elseif R_CStat ='402' // 402 Rejeição: XML da área de dados com codificação diferente de UTF-8
msginfo(C_XMotivo)

elseif R_CStat ='403' //403 Rejeição: O grupo de informações da NF-e avulsa é de uso exclusivo do Fisco
msginfo(C_XMotivo)

elseif R_CStat ='404' //404 Rejeição: Uso de prefixo de namespace não permitido
msginfo(C_XMotivo)

elseif R_CStat ='405' // 405 Rejeição: Código do país do emitente: dígito inválido
msginfo(C_XMotivo)

elseif R_CStat ='406' // 406 Rejeição: Código do país do destinatário: dígito inválido
msginfo(C_XMotivo)


elseif R_CStat ='407' // 407 Rejeição: O CPF só pode ser informado no campo emitente para a NF-e avulsa
msginfo(C_XMotivo)

elseif R_CStat ='420' // Rejeicao: Cancelamento para NF-e ja cancelada
msginfo(C_XMotivo)

elseif R_CStat ='523' // Rejeicao: CFOP nao e de Operacao Estadual e UF emitente igual a UF destinatario.
msginfo(C_XMotivo)

elseif R_CStat ='557' //XMotivo=Rejeicao: A Justificativa de entrada em contingencia deve ser informada.
msginfo(C_XMotivo)

elseif R_CStat ='598' //XMotivo=Rejeicao: A Justificativa de entrada em contingencia deve ser informada.
msginfo(C_XMotivo)
elseif R_CStat ='999' // 999 Rejeição: Erro não catalogado (informar a mensagem de erro capturado no tratamento da exceção)
msginfo(C_XMotivo)
endif
//janelasplash.release 
return
*********************************************************

/*
 * Autor : Claudinei de Lima
 * data  : 07.09.2004
 * msn   : claudinei@vsp.com.br
 * e-mail: climadc@brturbo.com
 * Dois Irmãos - RS
 *
 * Revized: Grigory Filatov <gfilatov@inbox.ru>
 * Date: 01/30/2007
 * Lib HMG 1.3 Extended Build 31
 *
 * Fixed: Grigory Filatov <gfilatov@inbox.ru>
 * Date: 05/11/2007
 * Lib HMG 1.4 Extended Build 46
*/



Procedure EMAIL()
  Private _usuario   := "medialcomercio@gmail.com"
  Private _senha     := "jo1801"
  Private _smtp      := "smtp.gmail.com"
  Private _ident     := "medialcomercio@gmail.com"
  Private _de        := "josejuca"
  Private _autentica := .F.

  IF File("demo.ini")
    BEGIN INI FILE ("demo.ini")
       GET _smtp       SECTION "E-Mail" ENTRY "SMTP"
       GET _usuario    SECTION "E-Mail" ENTRY "Conta"
       GET _ident      SECTION "E-Mail" ENTRY "Rementente"
       GET _de         SECTION "E-Mail" ENTRY "De"
       GET _senha      SECTION "E-Mail" ENTRY "Senha"
    END INI
    _Autentica := !EMPTY(_senha)
  ENDIF
  
  DEFINE WINDOW Form_Email ;
      AT 00, 00 ;
       WIDTH 546 ;
       HEIGHT 560 ;
       TITLE "EMAIL " ;
       MODAL;   
       NOSIZE	
	
	
    @014,020 LABEL  Label_T_smtp      ;
       VALUE "Serv.SMTP:"             ;
       WIDTH 110                      ;
       HEIGHT 27                      ;
       FONT "Courier New" Size 10

    @010,130 TEXTBOX T_smtp;
       WIDTH 390           ;
       VALUE _smtp         ;
       TOOLTIP "Informe o Servidor de saídas de E-mails(SMTP).";
       FONT "Courier New" Size 10     ;
       ON ENTER DoMethod("Form_Email","T_usuario","SetFocus");
       MAXLENGTH 60 LOWERCASE

    @044,020 LABEL  Label_T_usuario   ;
       VALUE "Sender Name:"           ;
;//    VALUE "Conta....:"             ;
       WIDTH 110                      ;
       HEIGHT 27                      ;
       FONT "Courier New" Size 10

    @040,130 TEXTBOX T_usuario        ;
       WIDTH 390                      ;
       VALUE _usuario                 ;
       TOOLTIP "Informe o usuario."   ;
       FONT "Courier New" Size 10     ;
       ON ENTER DoMethod("Form_Email","T_id","SetFocus");
       MAXLENGTH 60

    @074,020 LABEL  Label_T_id        ;
       VALUE "Sender Addr:"           ;
       WIDTH 110                      ;
       HEIGHT 27                      ;
       FONT "Courier New" Size 10

    @070,130 TEXTBOX T_id ;
       WIDTH 390          ;
       VALUE _ident       ;
       TOOLTIP "Informe o nome pelo qual você será identificado pelo desetinatário.";
       FONT "Courier New" Size 10     ;
       ON ENTER DoMethod("Form_Email","T_De","SetFocus");
       MAXLENGTH 60 LOWERCASE

    @104,020 LABEL  Label_T_De        ;
       VALUE "Reply To:"              ;
;//       VALUE "De.....:"            ;
       WIDTH 090                      ;
       HEIGHT 27                      ;
       FONT "Courier New" Size 10

    @100,110 TEXTBOX T_De ;
       WIDTH 410          ;
       VALUE _de          ;
       TOOLTIP "Informe o endereço de E-Mail do pessoa que está enviando.";
       FONT "Courier New" Size 10     ;
       ON ENTER DoMethod("Form_Email","T_Para","SetFocus");
       MAXLENGTH 60 LOWERCASE


    @134,020 LABEL  Label_T_Para      ;
       VALUE "To.....:"               ;
;//       VALUE "Para...:"            ;
       WIDTH 090                      ;
       HEIGHT 27                      ;
       FONT "Courier New" Size 10

    @130,110 TEXTBOX T_Para ;
       WIDTH 410           ;
       TOOLTIP "Informe o endereço de E-Mail do pessoa para quem está enviando.";
       FONT "Courier New" Size 10     ;
       ON ENTER DoMethod("Form_Email","T_Assunto","SetFocus");
       MAXLENGTH 60 LOWERCASE

    @164,020 LABEL  Label_T_Assunto   ;
       VALUE "Subject:"               ;
;//       VALUE "Assunto:"            ;
       WIDTH 090                      ;
       HEIGHT 27                      ;
       FONT "Courier New" Size 10

    @160,110 TEXTBOX T_Assunto        ;
       WIDTH 410                      ;
       TOOLTIP "Informe/Confirme o Assunto do E-Mail a ser enviado.";
       FONT "Courier New" Size 10     ;
       ON ENTER DoMethod("Form_Email","ECorpo","SetFocus");
       MAXLENGTH 60

    @194,020 LABEL  Label_T_Axeno     ;
       VALUE "Attach file(s):"        ;
       WIDTH 060                      ;
       HEIGHT 54                      ;
       FONT "Courier New" Size 10

    @190,077 BUTTONEX BAnexar         ;
       PICTURE "B_Anexar"             ;
       ACTION Anexar()                ;
       WIDTH 32 HEIGHT 32

    @190,110 LISTBOX L_Anexo          ;
       WIDTH 410                      ;
       HEIGHT 070                     ;
       FONT "Courier New" Size 10     ;
       ON DBLCLICK Dele_Anexo()       ;
       ON GOTFOCUS DoMethod("Form_Email","ECorpo","SetFocus")

    @270,020 EDITBOX ECorpo ;
       WIDTH 500 ;
       HEIGHT 200 ;
       TOOLTIP 'EditBox' ;
       FONT "Courier New" Size 10 ;
       MAXLENGTH 500 ;
       NOVSCROLL NOHSCROLL

    DEFINE CHECKBOX vAutenticar
       ROW   494
       COL   265
       CAPTION "Authentication"
       WIDTH 130
       HEIGHT 18
       VALUE _Autentica
       FONTNAME "Courier New"
       FONTSIZE 11
       TOOLTIP "Informe se seu servidor exige Auteticação."
       ON CHANGE Ativa_senha()
    END CHECKBOX

    @490,400 TEXTBOX T_Senha ;
       WIDTH 120 ;
       VALUE _senha ;
       TOOLTIP "Informe/Confirme a Senha." ;
       FONT "Courier New" Size 10 ;
       PASSWORD ;
       ON ENTER DoMethod("Form_Email","BEnviar","SetFocus");
       MAXLENGTH 12

    @484,020 BUTTONEX BEnviar ;
       PICTURE "B_Enviar" ;
       CAPTION "S&END" ;
       FONT "Courier New" Size 10 BOLD ;
       ACTION  Enviar_email() ;
       WIDTH 100 HEIGHT 38

    @484,140 BUTTONEX BSair ;
       PICTURE "B_Sair" ;
       CAPTION "E&XIT" ;
       FONT "Courier New" Size 10 BOLD ;
       ACTION DoMethod("Form_Email","Release") ;
       WIDTH 100 HEIGHT 38

  END WINDOW

  ON KEY ESCAPE OF Form_Email ACTION DoMethod("Form_Email","Release")

  SetProperty("Form_Email","T_Senha","Enabled",_Autentica)
  DoMethod("Form_Email","T_smtp","SetFocus")

  CENTER   WINDOW Form_Email
  ACTIVATE WINDOW Form_Email

Return
/*
*/

Function Enviar_email()
  Local _anexo_ := ''
  Local _id
  Local _para_
  Local _assunto_
  Local _emai_
  Local nanexos_, x

  _para_ := Alltrim(GetProperty("Form_Email","T_Para","Value"))
  IF EMPTY(_para_)
	Return Nil
  ENDIF
  _id := Alltrim(GetProperty("Form_Email","T_id","Value"))
  _de := Alltrim(GetProperty("Form_Email","T_De","Value"))
  _assunto_ := Alltrim(GetProperty("Form_Email","T_Assunto","Value"))
  _emai_ := GetProperty("Form_Email","ECorpo","Value")
  _smtp  := Alltrim(GetProperty("Form_Email","T_smtp","Value"))
  _usuario := Alltrim(GetProperty("Form_Email","T_usuario","Value"))
  _senha := Alltrim(GetProperty("Form_Email","T_senha","Value"))
  nanexos_ := GetProperty("Form_Email","L_Anexo","ItemCount")
  IF nanexos_ > 0
	FOR x = 1 TO nanexos_
		_anexo_ += _GetShortPathName(GetProperty("Form_Email","L_Anexo","Item",x)) + if(x<nanexos_,",","")
	NEXT
  ENDIF
*  EnviaEmail_(_smtp, _id, _de, _para_, _assunto_, _emai_, _anexo_, _usuario, _senha )
  Salvar_dados()
  SetProperty("Form_Email","T_Para","Value","")
  SetProperty("Form_Email","T_Assunto","Value","")
  SetProperty("Form_Email","ECorpo","Value","")
  DELETE ITEM ALL FROM L_Anexo OF Form_Email
  DoMethod("Form_Email","T_smtp","SetFocus")
Return Nil
/*
*/
Function Anexar()
  Local aArqGet, x
  aArqGet := Getfile( { {"Todos os Arquivos (*.*)", "*.*"} }, "Anexar arquivo...", , .T. )
  If Len(aArqGet) > 0
	for x = 1 to Len(aArqGet)
		ADD ITEM aArqGet[x] TO L_Anexo OF Form_Email
	next
  EndIf
Return NIL
/*
*/
Function Dele_Anexo()
  Local oanexo := GetProperty("Form_Email","L_Anexo","Value")
  DELETE ITEM oanexo FROM L_Anexo OF Form_Email
  DoMethod("Form_Email","L_Anexo","SetFocus")
Return Nil
/*
*/

Function Salvar_dados()
  _smtp      := Alltrim(GetProperty("Form_Email","T_smtp","Value"))
  _usuario   := Alltrim(GetProperty("Form_Email","T_usuario","Value"))
  _ident     := Alltrim(GetProperty("Form_Email","T_id","Value"))
  _de        := Alltrim(GetProperty("Form_Email","T_De","Value"))
  _senha     := Alltrim(GetProperty("Form_Email","T_Senha","Value"))
  BEGIN INI FILE ("demo.ini")
     SET SECTION "E-Mail"        ENTRY "SMTP"       To _smtp
     SET SECTION "E-Mail"        ENTRY "Conta"      To _usuario
     SET SECTION "E-Mail"        ENTRY "Rementente" To _ident
     SET SECTION "E-Mail"        ENTRY "De"         To _de
     SET SECTION "E-Mail"        ENTRY "Senha"      To _senha
  END INI
Return Nil
/*
*/
Function Ativa_senha()
  _Autentica := GetProperty("Form_Email","vAutenticar","Value")
  SetProperty("Form_Email","T_Senha","Enabled",_Autentica)
Return Nil


 
*--------------------------------------------------------------*
STATIC Function lerxml_cce()                   
*--------------------------------------------------------------*
Local pchave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 9 ))))
Local paCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))

Local nCounter:= 0
local ppchave:=""
Local oRow
Local i
Local oQuery,nHandle,FC_NORMAL
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
//Local cDoc:='nfe.xml'
local path :=DiskName()+":\"+CurDir()

   My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
  cQuery:= "select CHAVE,Retorno_cce FROM nfe20  WHERE CbdNtfNumero = " + AllTrim(pACode)      
  oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
    
//MemoWrit( cDoc ,( oRow:FieldGet(2) ) )
	    
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
*FWRITE(Handle,'NFe.ImprimirEvento("'+oRow:FieldGet(2)+'")')
fclose(handle)  

public cTXT     :=PATH+"\NOTA.XML"
*MSGINFO(cTXT)
*NFe_IMPEVENT(alltrim(cTXT))
*FWRITE(Handle,'NFe.ImprimirEvento("'+cTXT+'")')
*FCLOSE(nHandle) 

cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
cAuxCCe  := cTXT

ERASE "C:\ACBrNFeMonitor\sainfe.txt"
IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
         MsgInfo("File cannot be created:","ENTNFE.TXT")
        Return
       ENDIF 
    FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'")')
FCLOSE(nHandle) 

Return Nil



 
*--------------------------------------------------------------*
STATIC Function lerxml_cancelamento()                   
*--------------------------------------------------------------*
Local pchave:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 9 ))))
Local paCode:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 1 ))))

Local nCounter:= 0
local ppchave:=""
Local oRow
Local i
Local oQuery,nHandle,FC_NORMAL
Local cQuery
local c_encontro
local cCStat   :=""
local cXMotivo :="" 
local cDhRecbto:="" //31/03/2011 11:10:23
local cNProt   :=""//311110000011051
//Local cDoc:='nfe.xml'
local path :=DiskName()+":\"+CurDir()

   My_SQL_Database_Connect(cDataBase) //BANCO JUMBO
  cQuery:= "select CHAVE,RETORNO_EVENTO FROM nfe20  WHERE CbdNtfNumero = " + AllTrim(pACode)      
  oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
      MsgInfo("erro sql: " , "ATENÇÃO")
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
	
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
    
//MemoWrit( cDoc ,( oRow:FieldGet(2) ) )
	    
HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
FWRITE(Handle,oRow:FieldGet(2))
*FWRITE(Handle,'NFe.ImprimirEvento("'+oRow:FieldGet(2)+'")')
fclose(handle)  

public cTXT     :=PATH+"\NOTA.XML"
*MSGINFO(cTXT)
*NFe_IMPEVENT(alltrim(cTXT))
*FWRITE(Handle,'NFe.ImprimirEvento("'+cTXT+'")')
*FCLOSE(nHandle) 

cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
cAuxCCe  := cTXT

ERASE "C:\ACBrNFeMonitor\sainfe.txt"
IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
         MsgInfo("File cannot be created:","ENTNFE.TXT")
        Return
       ENDIF 
    FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'")')
FCLOSE(nHandle) 

Return Nil


Function Consulta_nfe()
LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
LOCAL nHandle, cQuery,FC_NORMAL
*Local pemail:= (AllTrim((GetColValue( "Grid_notas", "janelanfe", 12 ))))
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
LOCAL c_CFileDanfe:="C:\ACBrNFEMonitor\"
local anomes:=""
cFileDanfe:="C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"


////RETORNO////
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathNFe"
END INI

public  cCFileDanfe   :=c_CFileDanfe
*cAuxCCe  := Getfile ( { {'Arquivos','*.xml'} } , 'Consultas XML da nfe ' , +cCFileDanfe,.F. , .T. )

cAuxCCe := Getfile ( { {'Arquivos do XML NFE','*.XML'},;
{'Consultas XML da nfe','*.XML'},;
{'Todos os arquivos','*.*'} } , 'Abrir arquivo' , 'C:\ACBrNFeMonitor\' , .f. )
If !Empty (cAuxCCe)
*   MsgInfo ( "Voce escolheu o arquivo [" + cAuxCCe + "]" )
NFe_CON(cAuxCCe)
Else
*   MsgInfo ( "Nenhum arquivo escolhido" )
RETURN(.F.)
End

NFe_CON(cAuxCCe)

BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
END INI
public  c_CStat   :=cCStat
public c_cChNFe   :=cChNFe

NFe_IMP(alltrim(cAuxCCe))


Reconectar_A() 

C_CbdNtfNumero:=SUBSTR(cAuxCCe, 44, 9)
C_CbdNtfNumero:=val(C_CbdNtfNumero)

XML           :=SUBSTR(cAuxCCe, 20, 55)
fxml          :="C:\ACBrNFeMonitor\"+xml
*msginfo(fxml)
ffxml         :=memoread(cAuxCCe)

   cQuery	:= oServer:Query( "UPDATE nfe20 SET nt_retorno='"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = " +(ntrim(C_CbdNtfNumero)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
EndIf
RETURN
			

			
   
   
STATIC Function imprime_cce()
*--------------------------------------------------------------*

LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
LOCAL nHandle, cQuery,FC_NORMAL
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
LOCAL c_CFileDanfe:="C:\ACBrNFEMonitor\"
local anomes:=""
cFileDanfe:="C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"


////RETORNO////
BEGIN INI FILE cFileDanfe
       GET c_CFileDanfe     SECTION  "Arquivos"       ENTRY "PathNFe"
END INI

public  cCFileDanfe   :=c_CFileDanfe
cAuxCCe := Getfile ( { {'Arquivos do XML NFE','*.XML'},;
{'Consultas XML da nfe','*.XML'},;
{'Todos os arquivos','*.*'} } , 'Abrir arquivo' , 'C:\ACBrNFeMonitor\' , .f. )
If !Empty (cAuxCCe)
*   MsgInfo ( "Voce escolheu o arquivo [" + cAuxCCe + "]" )
NFe_CON(cAuxCCe)
Else
*   MsgInfo ( "Nenhum arquivo escolhido" )
RETURN(.F.)
End

*NFe_CON(cAuxCCe)

cArquivo:= MEMOREAD(cAuxCCe)
*MsgInfo ( cArquivo)
 

ERASE "C:\ACBrNFeMonitor\sainfe.txt"
IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
         MsgInfo("File cannot be created:","ENTNFE.TXT")
        Return
       ENDIF 
    FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'")')
FCLOSE(nHandle) 



BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
       GET cCStat          SECTION  "CONSULTA"       ENTRY "CStat"
	   get cChNFe          section  "CONSULTA"       ENTRY "ChNFe"
END INI
public  c_CStat   :=cCStat
public c_cChNFe   :=cChNFe

*NFe_IMP(alltrim(cAuxCCe))



/*
Reconectar_A() 

C_CbdNtfNumero:=SUBSTR(cAuxCCe, 44, 9)
C_CbdNtfNumero:=val(C_CbdNtfNumero)

XML           :=SUBSTR(cAuxCCe, 20, 55)
fxml          :="C:\ACBrNFeMonitor\"+xml
*msginfo(fxml)
ffxml         :=memoread(cAuxCCe)
*/









RETURN
			

			






Function IsInternet_1()
local oSock, lRet := .f.
local cServer  := "www.google.com"
local nPort    := 80
local aAddress

oSock := TSocket():New()

if oSock:Connect( cServer, nPort )
* MsgInfo(lRet)
 lRet := .t.
 oSock:Close()
endif
*  MsgInfo(lRet)
  
  IF lRet := .T.
 
ELSE

 MsgInfo("Sem Internet")

 ENDIF   
           
		   
Return lRet



******************************
Function EsperaResposta_A(cFile)
******************************
*
*
Private cTempo:=time(),oTempo,lAchou := .f.

Do while .t.

     cTempo:= Time()
      if file(cFile)
        lAchou := .t.
        exit
     endif
     inkey(.8)

 
     if GetKeyState(VK_ESCAPE) < 0
        exit
     endif

enddo

 
return lAchou


lRetStatus:=EsperaResposta_A(cDestino) 
if lRetStatus==.t.  ////pego os dados
end
cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'


///----------------------------------------------------------------------------.
*       // Função para Checar Status do Serviço
		Function ProcedureLerINI_1()         
        LOCAL FC_NORMAL
		LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
                IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                   MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
                   Return
               ENDIF 
                FWRITE(nHandle,'NFe.LerIni' )
                FCLOSE(nHandle)

		   RETURN
