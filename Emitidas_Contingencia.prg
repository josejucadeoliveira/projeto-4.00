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


memvar oConexao
//*******************************************
FUNCTION Emitidas_Contingencia()  
//********************************************
   private cServidor, cUsuario, cSenha, cBanco, cTabela, vCabecalho := {} ,vLargura  := {}, vCampos := {}, cOrdem := ""
   private                                     cTabelaitens, vCabecalhoitens := {}, vLarguraitens := {}, vCampositens := {}, cOrdemitens := ""
   public oConexao

cHostName:= AllTrim(cHostName)
cUser    := AllTrim(cUser )
cPassWord:= AllTrim(cPassWord)
   
   
cServidor :=cHostName                         // Local de conexão
cUsuario  := cUser                               // Usuario
cSenha    := cPassWord                         // Senha do usuario
cBanco    := cnomedobanco                               // Banco de dados

    cTabela := "NFCE_contigencia"                            // Tabela que será usada no browse
    vCabecalho:= {"Numero","SERIE","CHAVE","XML"}
    vLargura := {100,80,400,250}                       // Largura das colunas do Browse
 	vCampos  := {"CbdNtfNumero","CbdNtfSerie","Chave","nt_retorno"}
    cOrdem   := "CbddEmi"                                 // Browse Ordenado pela 2ª coluna nome do cliente
  
    Conecta (cServidor, cUsuario, cSenha, cBanco)
	



DEFINE WINDOW Contingencia AT 00 , 00;
 WIDTH 1020;
 HEIGHT 560 ;
 TITLE "Notas Fiscal Emitidas em Ambiente de Contigência";
 MODAL ;
 FONT "Arial" SIZE 10 
                                      

     ON KEY ESCAPE  OF Contingencia ACTION { || Contingencia.RELEASE } 

 		DEFINE STATUSBAR FONT 'Verdana' SIZE 7			
			STATUSITEM "Contingencia"
      		END STATUSBAR
	
     DEFINE BUTTONEX ButtonEX_1
            ROW    10
            COL    10
            WIDTH  252
            HEIGHT 24
            CAPTION "Consulta Disponibilidade dos Serviços"
			ACTION Consulta_status_servico()
     END BUTTONEX  

     DEFINE BUTTONEX ButtonEX_2
            ROW    10
            COL    270
            WIDTH  120
            HEIGHT 24
            CAPTION "Enviar Todas"
				ACTION Enviar_XML()
     END BUTTONEX  
	 
  	
		
		
	   // Browse para exebição dos dados da Tabela
  	    @ 40,10 MySQLBROWSE browsenfe ;
		WIDTH 1000 ;
		HEIGHT 375  ;	
         HEADERS vCabecalho ;
	     WIDTHS vLargura ;
      	 FIELDS vCampos ;
         ORDER BY cOrdem ;
         WORKAREA cTabela ;
         SOCKET oConexao;
		 FONT "Arial Baltic" ;
         SIZE 11 ;
         BOLD 
		 
			
     DEFINE BUTTONEX ButtonEX_3
            ROW    430
            COL   10
            WIDTH  120
            HEIGHT 24
            CAPTION "ESC-&Sair"
            FONTNAME 'Arial'
            action Contingencia.RELEASE
     END BUTTONEX
	    
     DEFINE LABEL Label_index
            ROW    430
            COL    150
            WIDTH  868
            HEIGHT 24
            FONTCOLOR {210,0,0}
     END LABEL
	    
END WINDOW
  	

 
  	Contingencia.Center
	Contingencia.Activate
  
RETURN nil




//-----------------------------------------------------------------------------.
FUNCTION  consulta_status_servico() 
//-----------------------------------------------------------------------------.
 
Local lRet:=.t.
 	
 		lRetorno_Internet:=IsInternet()
 		
  		if lRetorno_Internet==.f.
			msginfo("Sem acesso a Internet, Favor verificar sua Conexão")                 
			lRet:=.f.
		   return
 		 end                 

 		lStatus:=ProcedureStatus() 	 
		if lStatus==.f.
			msginfo("ERRO: WebService Inativo ou Inoperante tente novamente!")
			lRet:=.f.                                                    
		   return
		end
			msginfo("Serviço em Operação!")
    ERASE("*-ped-rec.xml","C:\ACBrMonitorPLUS")
Return  lRet

//-----------------------------------------------------------------------------.
FUNCTION Enviar_XML()  
//-----------------------------------------------------------------------------.
Local lRet:=.f.
/////[RETORNO]//////////
LOCAL R_Versao  :=""  //SVRS20110322100218
LOCAL R_TpAmb   :="" //1
LOCAL R_VerAplic:="" //SVRS20110322100218
LOCAL R_NRec    :="" //113000263213135
LOCAL R_CStat   :="" //100
LOCAL R_XMotivo :="" //=Autorizado o uso da NF-e
LOCAL R_DigVal  :="" //=Autorizado o uso da NF-e
LOCAL c_ChNFe:=""
LOCAL cNProt:=""
//////[CONSULTA]///////////
local c_Versao  :=""//SVRS20100811185009
local c_TpAmb   :=""//2
local c_VerAplic:=""//SVRS20100811185009
local c_CStat   :=""//100
local Cc_XMotivo :=""//Autorizado o uso da NF-e
local c_CUF     :=""//11
LOCAL c_NProt:=""
local c_DhRecbto:=""//29/03/2011 07:47:33
LOCAL sCStat:=""
xCbdtpEmis:="9"
///////FIM///////////////
 publ path :=DiskName()+":\"+CurDir()  
lRet:=.t.
Reconectar_A() 
abrecontige()

*lRet:=consulta_status_servico()

***********************************************************
	//////[VERIFICA SERVIÇOS]///////////
cRet       := MON_ENV("NFE.StatusServico")
  *    cRet := MON_ENV( "NFE.StatusServico")
   
CFileDanfe := 'C:\ACBrMonitorPLUS\sai.txt'

MY_WAIT( 1 ) 
bRetornaXML :="C:\ACBrMonitorPLUS\sai.txt" 
variavel1   :=Traz_Linha(bRetornaXML)
xservico   :=SUBSTR(variavel1,0,5)
xxservico   :=SUBSTR(variavel1,0,200)

cfile    :="C:\ACBrMonitorPLUS\sai.txt" 
cTexto    := Memoread ( cFile )
variavel :=SUBSTR(cTexto,0,5)

  

BEGIN INI FILE cFileDanfe
      ////STATUS////////////////////////////
       GET sCStat          SECTION  "STATUS"       ENTRY "CStat" 
	  /////////////////////////////////////////////////////////////
END INI
PUBLIC s_CStat:=val(sCStat)
if xservico="12007" 
*MSGINFO("SEM ok")
lRetorno_Internet:=.F.
 else 
lRetorno_Internet:=.T.
*MSGINFO("ok")
endif

if s_CStat=107 
*MSGINFO("SEM ok")
lRetorno_Internet:=.F.
 else 
lRetorno_Internet:=.T.
*MSGINFO("ok")
endif

if xservico="12002" 
*MSGINFO("SEM ok")
lRetorno_Internet:=.F.
 else 
lRetorno_Internet:=.T.
*MSGINFO("ok")
endif

if variavel="ERRO"
*MSGINFO("SEM ok")
lRetorno_Internet:=.F.
 else 
lRetorno_Internet:=.T.
*MSGINFO("ok")
endif


 if lRetorno_Internet=.F.
  MsgStop("SEM SERVIÇOS")
   Contingencia.RELEASE
   Return .f.
ENDIF
	   
	 *  MSGINFO(lRetorno_Internet)

 if lRetorno_Internet=.T.
	CQuery:= "select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie FROM NFCE_CONTIGENCIA"  
  
	oQuery_Item:=oServer:Query( cQuery )
	If oQuery_Item:NetErr()												
       MsgStop(oQuery_Item:Error())
       Return .f.
	End 

nCount=0 
For i := 1 To oQuery_Item:LastRec()

  oRow := oQuery_Item:GetRow(i)
  oQuery_Item:Skip(1)
  pACode           :=STR(oRow:fieldGet(1))
  cChave           :=    oRow:fieldGet(2)
  paserie          :=    oRow:fieldGet(4)
  nnfe             :=   "NFE"+alltrim((pACode))
  Contingencia.Label_index.value:="Enviando NFe "+alltrim((pACode))+" - "+cChave+" AGUARDE..."	
  
 oQuery:=oServer:Query( "SELECT nt_retorno FROM nfce WHERE CbdNtfNumero = "+AllTrim(pACode)+" and CbdNtfSerie ="+(paserie)+" Order By CbdNtfNumero" )
 If oQuery:NetErr()
    MsGInfo("linha 1855 " + oServer:Error() )
    Return Nil
  Endif
  	oRow          :=oQuery:GetRow(1)
	PXML         :=oRow:fieldGet(1)
 
 HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
 FWRITE(Handle,PXML)
fclose(handle)  

public cTXT     :=PATH+"\NOTA.XML"
*NFe_ENV(alltrim(cTXT))

//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.EnviarNFe("+cTXT+",1,1,0,1)")
///////////////////////////////////////////////////
 
	cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
	lRetStatus:=EsperaResposta(cDestino) 
	    if lRetStatus==.t.
		////RETORNO////
		BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
	   GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
	   GET c_NProt          SECTION  nnfe            ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
	   GET c_DhRecbto       SECTION  "ENVIO"         ENTRY "DhRecbto"   // DADA E HORA 
	   GET c_ChNFe          SECTION  nnfe            ENTRY "ChNFe"      // chave nfe  
	   GET R_DigVal         SECTION  nnfe            ENTRY "DigVal"      
	/////////////////////////////////////////////////////////////
END INI
End
	
	
public CR_CStat :=R_CStat
public C_XMotivo :=R_XMotivo
public Cc_ChNFe  :=c_ChNFe
*public c_nuNFe   :=nuNFe
*public cR_DigVal :=R_DigVal
public cc_NProt   :=ALLTRIM(c_NProt)
public cc_DhRecbto:=c_DhRecbto


if CR_CStat=='150'  

        dbselectarea('Contige')
       Contige->(ordsetfocus('numero'))
       Contige->(dbgotop())
  
	   
    while .not. CONTIGE->(eof())
      dbselectarea('Contige')
	   if CONTIGE->NUMERO=VAL(PACODE)
             If LockReg()  
                Contige->(dbdelete())
                Contige->(dbunlock())
                Contige->(dbgotop())
         endif
	
	    endif
        Contige->(dbskip())
       end
endif
			 


if CR_CStat=='100'  

        dbselectarea('Contige')
       Contige->(ordsetfocus('numero'))
       Contige->(dbgotop())
  
	   
    while .not. CONTIGE->(eof())
      dbselectarea('Contige')
	   if CONTIGE->NUMERO=VAL(PACODE)
             If LockReg()  
                Contige->(dbdelete())
                Contige->(dbunlock())
                Contige->(dbgotop())
         endif
	
	    endif
        Contige->(dbskip())
       end
endif
			 

if CR_CStat=='204'  

ERASE "C:\ACBrMonitorPLUS\sai.txt"

MY_WAIT( 1 )
//////////////////enviar/////////////////////////
 cRet       := MON_ENV("NFE.ConsultarNFe("+cChave+")")
///////////////////////////////////////////////////
MY_WAIT( 2 ) 


BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
     get cNProt          section  "CONSULTA"       ENTRY "NProt"
END INI

MSGINFO(AUTO)

public c_cNProt   :=cNProt
AUTO:=c_cNProt
 

cQuery := "UPDATE NFCE SET AUTORIZACAO='"+AUTO+"' WHERE CbdNtfNumero = "+(pACode)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+paserie+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
  else
  Endif

       dbselectarea('Contige')
       Contige->(ordsetfocus('numero'))
       Contige->(dbgotop())
  
   
    while .not. CONTIGE->(eof())
      dbselectarea('Contige')
	   if CONTIGE->NUMERO=VAL(PACODE)
             If LockReg()  
                Contige->(dbdelete())
                Contige->(dbunlock())
                Contige->(dbgotop())
         endif
	
	    endif
        Contige->(dbskip())
       end
endif
			 			

if CR_CStat=='539'  

        dbselectarea('Contige')
       Contige->(ordsetfocus('numero'))
       Contige->(dbgotop())
  
	   
    while .not. CONTIGE->(eof())
      dbselectarea('Contige')
	   if CONTIGE->NUMERO=VAL(PACODE)
             If LockReg()  
                Contige->(dbdelete())
                Contige->(dbunlock())
                Contige->(dbgotop())
         endif
	
	    endif
        Contige->(dbskip())
       end
endif
			 	
			
if CR_CStat=='100'  .or.  CR_CStat=='150'
   ffxml:="C:\ACBrMonitorPLUS\"+Cc_ChNFe+"-nfe.XML"
   ffxml         :=memoread(ffxml)
    cQuery	:= oServer:Query( "UPDATE NFCE SET CbdStatus='"+C_XMotivo+"',AUTORIZACAO='"+cc_NProt+"',nt_retorno='"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = " +(ALLTRIM(pACode)))
 	If cQuery:NetErr()		
         MsgInfo("SQL SELECT error: 2473  " + cQuery:Error())	
     	MsgStop(cQuery:Error())
	 Else
endif	
	
nCount++  
endif

oQuery_Item:Skip(1)
Next
oQuery_Item:Destroy()
Contingencia.Label_index.value:=alltrim(str(nCount))+"-->> Notas Fiscais Enviadas"
msginfo("Processo concluido com sucesso...")
Contingencia.RELEASE
endif
Return 




Function ProcedureStatus() 
LOCAL lRetStatus,lRet:=.f.
LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
LOCAL FC_NORMAL:=""
ERASE "C:\ACBrMonitorPLUS\sai.txt"

     IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
         MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
         Return
     ENDIF 
     FWRITE(nHandle,'NFE.StatusServico("")' )
     FCLOSE(nHandle)
 
		vArq:="C:\ACBrMonitorPLUS\SAI.TXT" 
		lRetStatus:=EsperaResposta(vArq,2) 
      if lRetStatus==.t.
			cTexto := Memoread ( "C:\ACBrMonitorPLUS\SAI.TXT" )
	
			if alltrim(SUBSTR(alltrim ( memoline ( cTexto,80,1 )  ) , 1,4) )=='ERRO'
				lRet:=.f.
			else
				lRet:=.t.
			end
  
		else
			msginfo('Erro na leitura do arquivo!!!')
		end
		
Return lRet 


*       // Função para Cancelar o XML
        Function ProcedureEnviarXML(oArq)
               LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
		         LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
					LOCAL nLote    := '0'
					//////[RETORNO]///////////
					local r_ChNFe    :="" 
					local r_Stat     :="" 
					LOCAL FC_NORMAL:=""
               Public cEnvio_XML:=.t.
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			      Return
               ENDIF 
					  
              FWRITE(nHandle,"NFe.EnviarNFe("+oArq+","+nLote+",1,0")
              FCLOSE(nHandle) 

				lRetStatus:=EsperaResposta(cDestino) 
		      if lRetStatus==.t.
					   if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
						   MSGINFO(memoread(cDestino))
			   		   cEnvio_XML:=.f.
					   else
							BEGIN INI FILE "C:\ACBrMonitorPLUS\SAI.TXT"
								   GET r_Stat           SECTION  "RETORNO"       ENTRY "CStat"       
								   GET r_ChNFe          SECTION  "RETORNO"       ENTRY "ChNFe"       
							END INI
				      end
				end
			  RETURN                                         

        Function ProcedureImprimirEvento(oArq)
		      LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
				LOCAL nLote    := '0'

               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
              FWRITE(nHandle,"NFe.ImprimirEvento(C:\ACBrMonitorPLUS\"+oArq+")")
              FCLOSE(nHandle) 

			RETURN

        Function ProcedureEmitirDANFE(oArq,sChave)
		      LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
				LOCAL nLote    := '0'
				if !file(oArq)
               ProcedureEmitirDANFE_BaseDados(sChave)
            else
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
              FWRITE(nHandle,"NFE.ImprimirDanfe("+oArq+")")
              FCLOSE(nHandle) 
            end
			RETURN
			
        Function ProcedureEmitirDANFE_BaseDados(sChave)
		      LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
				LOCAL nLote    := '0'
		
			  cQuery:= "select xml FROM "+c_Tabela_NFe_ACBr+"  WHERE CbdChave = '" + sChave+"' "     
			  oQuery:=oServer:Query( cQuery )
			    If oQuery:NetErr()												
			      MsgInfo("erro sql: " , "ATENÇÃO")
			      Return Nil
			    EndIf
				oRow:= oQuery:GetRow(1)
				
				
			If Empty(oRow:FieldGet(1))
			    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
			  	 Return(.f.)
			EndIf                     	    
				    
  		 	HANDLE :=  FCREATE (CurDrive()+":\mgi\NOTA.XML",0)// cria o arquivo
		   FWRITE(Handle,oRow:FieldGet(1))
			fclose(handle) 
			 
			public cTXT     :=CurDrive()+":\mgi\NOTA.XML"
		
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
              FWRITE(nHandle,"NFE.ImprimirDanfe("+alltrim(cTXT)+")")
              FCLOSE(nHandle) 
		
			Return Nil


*       // Função para carregar resposta na Tela
		  Static Function ProcedureEsperaResposta()
               LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
					MY_WAIT( 3 )
					Public xRet_NFe:=memoread(cDestino) 
					Return
 
*       // Função para Guardar o Retorno do SEFAZ
        Static Function ProcedureGuardaRetorno(xret)
        		cQuery:="UPDATE retorno_nfe SET retorno = '"+xret+"'"
 			*	SQL_Error_oQuery()
		   		oQuery:Destroy()

					Return


*       // Função para Cancelar o XML
        Static Function ProcedureGeraXML(cTXT)
		      LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
				LOCAL cDestino := 'C:\ACBrMonitorPLUS\sai.txt'
				LOCAL nLote    := '0'
	   		  Public cSAIDA_XML:=''
   			  Public cCHAVE_XML:=''

		  		ERASE "C:\ACBrMonitorPLUS\sai.txt"

				IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
					MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			        Return
				ENDIF 
				FWRITE(nHandle,"NFE.CriarNFe("+cTXT+")")
				FCLOSE(nHandle) 
 	//	msginfo('1')
	     
				lRetStatus:=EsperaResposta(cDestino) 
		      if lRetStatus==.t.
			   /*
					   if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
						   MSGINFO(memoread(cDestino))
					   else
			   		  cSAIDA_XML:=SUBSTR(memoread(cDestino), 5, 70)
		   			  cCHAVE_XML:=SUBSTR(memoread(cDestino), 23, 44)
					   end
		      */
		      cTexto := Memoread ( cDestino )
				f := MLCount( memoread(cDestino) )
				x:=1
				achou:=.f.    
				FOR i := 1 TO f
 				   cStr := alltrim ( memoline ( cTexto,100,x )  )
 				   if alltrim(cStr) =="OK:"
 				   	achou:=.t.
   				end
			   	cSAIDA_XML:=SUBSTR(cStr, 5, 70)
		   		cCHAVE_XML:=SUBSTR(cStr, 23, 44)
				   x++
				NEXT x
				if achou==.t.
  				      msginfo("Enter para Tentar novamente"	)
				
		 		 	   MY_WAIT( 5 )
				      cTexto := Memoread ( cDestino )
						f := MLCount( memoread(cDestino) )
						x:=1
						achou:=.f.    
						FOR i := 1 TO f
		 				   cStr := alltrim ( memoline ( cTexto,100,x )  )
		 				   if alltrim(cStr) =="OK:"
		 				   	achou:=.t.
		   				end
					   	cSAIDA_XML:=SUBSTR(cStr, 5, 70)
				   		cCHAVE_XML:=SUBSTR(cStr, 23, 44)
						   x++
						NEXT x
				   
				end

				if achou==.t.
  				      msginfo("Enter para Tentar novamente"	)
				
		 		 	   MY_WAIT( 10 )
				      cTexto := Memoread ( cDestino )
						f := MLCount( memoread(cDestino) )
						x:=1
						achou:=.f.    
						FOR i := 1 TO f
		 				   cStr := alltrim ( memoline ( cTexto,100,x )  )
		 				   if alltrim(cStr) =="OK:"
		 				   	achou:=.t.
		   				end
					   	cSAIDA_XML:=SUBSTR(cStr, 5, 70)
				   		cCHAVE_XML:=SUBSTR(cStr, 23, 44)
						   x++
						NEXT x
				   
				end
				else
				*	MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+"  Erro na leitura do arquivo!!!, ESC para Retornar" 
				end

			  
RETURN



static function Conecta (cServidor, cUsuario, cSenha, cBanco)
   local  lRetorno := .F.
   oConexao := TMySQLServer ():New (cServidor, cUsuario, cSenha)
   lRetorno := (!oConexao:NetErr ())
   
   if (lRetorno)
      oConexao:selectDB (cBanco)
   endif
   
return (lRetorno)

static function BUSCA

cProcura:="9"

 if (len (cProcura) > 0)
     define TIMER oTime OF Contingencia INTERVAL 100 ACTION Gira ()
     cProcura += iif (("*"$right (cProcura, 1)) .or. ("%"$right (cProcura, 1)), "", "")
      _MySQL_BrowseSetWhere ("oBrw_Cliente", "Contingencia", "WHERE CbdtpEmis = "+'"'+cProcura+'"')
      nTotalReg := _MySQL_BrowseRefresh ("oBrw_Cliente", "Contingencia")   
      _MySQL_BrowseSetValue ("oBrw_Cliente", "Contingencia", 1)
	   iif (nTotalReg > 0, doMethod ("Contingencia", "oBrw_Cliente", "SetFocus"), doMethod ("Contingencia", "oTb_Busca", "SetFocus"))
    doMethod ("Contingencia", "oTime", "release")
   else
   doMethod ("Contingencia", "oTb_Busca", "SetFocus")
  endif

return (nil)


//----------------------------------------------------------------------------//
// Função de animação do botão Buscar
//
static function Gira ()
   local cGira := ""
   static nGira := 1
   nGira++
   cGira := iif (nGira == 1, "Carrega_20x20_1", cGira)
   cGira := iif (nGira == 2, "Carrega_20x20_2", cGira)
   cGira := iif (nGira == 3, "Carrega_20x20_3", cGira)
   cGira := iif (nGira == 4, "Carrega_20x20_1", cGira)
 * janelanfe.oBt_Busca.Picture := cGira
   domethod ("Contingencia", "show")
   nGira := iif (nGira >= 4, 1, nGira)
return (cGira)



static function SQL_Error_oQuery(  )
  
Public Retorno_SQL:=.t.

 
   oQuery:=oServer:Query( cQuery )
 
	If oQuery:NetErr()												
       MsgStop("Erro SQL: "+oQuery:Error())
	    Retorno_SQL:=.f.

				if Retorno_SQL==.f.
			      HB_Cria_Log_SQL(cUsuario,cQuery+chr(13)+chr(10)+oQuery:Error())
				end                                                                       
	    
       Return .f.
	End 

return Retorno_SQL



#include "minigui.ch"

Procedure HB_Cria_Log_SQL(cString,atividade)    	
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [LogSQL.TXT])
      cArq:= fcreate(PATHDADOS + [LogSQL.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - MGI] + CRLF)
      fwrite(cArq, [Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario: ] + cString + [ Atividade: ] + atividade + CRLF)
      fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [LogSQL.TXT], 2 + 64)
      fseek(cArq, -1, 2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1, 2)
      Endif
      fwrite(cArq,[Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario:] + cString + [ Atividade: ] + atividade + CRLF)
      fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Endif
 
Return (Nil)



function Verifica_Emitidas_Contingencia1()
   Reconectar_A() 
/* 
 cQuery:= "DELETE FROM nfCE_CONTIGENCIA "         
   oQuery:=oServer:Query( cQuery )
   If oQuery:NetErr()
    MsgInfo("Por Favor Selecione o registro que deseja alterar")
    Return Nil
   endif
*/


abrecontige()
        
	   dbselectarea('Contige')
       Contige->(ordsetfocus('numero'))
       Contige->(dbgotop())
 while .not. eof()
xCbdNtfNumero:=contige->numero
xChave       :=contige->chave
xnt_retorno  :=contige->xml
xserie       :=NTRIM(contige->serie)
cQuery := "INSERT INTO nfCE_CONTIGENCIA (CbdNtfNumero,Chave,CbdEmpCodigo,CbdNtfSerie,nt_retorno) VALUES ('"+ntrim(xCbdNtfNumero)+"','"+alltrim(XChave)+"','"+"1"+"','"+xserie+"','"+xnt_retorno+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 MsgInfo("Por Favor Selecione o registro ffff ") 
else	
*MSGINFO("OK GRAVA ")
ENDIF

contige->(dbskip())
LOOP
ENDD

 
*CLOSE ALL 
*USE ((ondetemp)+"contige.DBF") new alias contige exclusive    // arquivo que vai ter todo o conteudo do TXT
*zap
*PACK

Emitidas_Contingencia()

   
RETURN

