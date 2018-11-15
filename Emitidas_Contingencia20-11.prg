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

FUNCTION Emitidas_Contingencia()  

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
  

 * 	HEADERS  {'NF-e','Série','Código','Cliente','Data','Valor' ,'Protocolo','Chave','Retorno'};
		
    cTabela := "NFCE"                            // Tabela que será usada no browse
    vCabecalho:= {"Numero","nome","Cnpj","Cpf","data","CHAVE","XML"}
    vLargura := {80,300,120,120,100,300,150}                       // Largura das colunas do Browse
 	vCampos  := {"CbdNtfNumero","CbdxNome_dest","CbdCNPJ_dest","CbdCPf_dest","CbddEmi","Chave","nt_retorno"}
    cOrdem   := "CbddEmi"                                 // Browse Ordenado pela 2ª coluna nome do cliente
  
    Conecta (cServidor, cUsuario, cSenha, cBanco)
	
	
Reconectar_A() 
		oQuery:= "DROP TEMPORARY TABLE IF EXISTS tmp_nfe"
	  *  oQuery:Destroy()
cQuery:= "CREATE TEMPORARY TABLE tmp_nfe select * FROM nfce where CbdtpEmis=9 and ( AUTORIZACAO is null or AUTORIZACAO='')"
 oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
       MsgStop(oQuery:Error())
      Return Nil
    EndIf
	
	
 *Verifica_Emitidas_Contingencia()
   
DEFINE WINDOW Contingencia AT 114 , 258;
 WIDTH 1038;
 HEIGHT 533 ;
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

/*
	   // Browse para exebição dos dados da Tabela
	    @ 40,10 MySQLBROWSE oBrw_Cliente ;
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
		 ON CHANGE BUSCA()
		 
*/
		 
    
			
	 // Browse para exebição dos dados da Tabela
  	   @ 40,10 MySQLBROWSE browsenfe ;
			WIDTH 1000 ;
			HEIGHT 375  ;	
			HEADERS  {'NF-e','Série','Cliente','Data','Valor' ,'Protocolo','Chave'};
			WIDTHS  { 70,50,280,80,80,120,150 } ;
			FIELDS  {'CbdNtfNumero','CbdNtfSerie','CbdxNome_dest','CbddEmi','CbdvNF','AUTORIZACAO','Chave'}	 ;
			JUSTIFY { BROWSE_JTFY_RIGHT  ,  BROWSE_JTFY_RIGHT , BROWSE_JTFY_RIGHT,BROWSE_JTFY_LEFT,BROWSE_JTFY_CENTER,;
					BROWSE_JTFY_RIGHT,  BROWSE_JTFY_RIGHT};
            ORDER BY "CbdNtfNumero" ;
            WORKAREA "tmp_nfe" ;
            FONT "Arial" ;
            SIZE 9 ;
            SOCKET oServer
	
			
     DEFINE BUTTONEX ButtonEX_3
            ROW    430
            COL    10
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
  	
//    _MySQL_BrowseRefresh ("Browse_Destinadas", "Contingencia")  

 
  	Contingencia.Center
	Contingencia.Activate
  
RETURN nil

																																									   
//-----------------------------------------------------------------------------.
FUNCTION Verifica_Emitidas_Contingencia()  
//-----------------------------------------------------------------------------.
 Local cQuery      
Local oQuery  

Reconectar_A() 
		oQuery:= "DROP TEMPORARY TABLE IF EXISTS tmp_nfe"
	  *  oQuery:Destroy()
cQuery:= "CREATE TEMPORARY TABLE tmp_nfe select * FROM nfce where CbdtpEmis=9 and ( CbdProtocolo is null or CbdProtocolo='')"
 oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
       MsgStop(oQuery:Error())
      Return Nil
    EndIf


	*	CQuery:= "select * FROM tmp_nfe"  
	*	oRow:= cQuery:GetRow(1)
    * if oQuery:LastRec()>0
   *		Emitidas_Contingencia()
  *    end

  * cQuery:= "select CHAVE,nt_retorno,cbdntfserie,cbdMod FROM nfce  WHERE CbdNtfNumero = " + (pACode)      
   CQuery:= "select * FROM tmp_nfe"  
   oQuery:=oServer:Query( cQuery )
    If oQuery:NetErr()												
       MsgStop(oQuery:Error())
      Return Nil
    EndIf
	oRow:= oQuery:GetRow(1)
  
	   oQuery:Destroy()

Return 

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
    ERASE("*-ped-rec.xml","C:\ACBrNFeMonitor")
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
LOCAL R_DhRecbto:="" //=Autorizado o uso da NF-e
///////FIM///////////////
 
//////[CONSULTA]///////////
local c_Versao  :=""//SVRS20100811185009
local c_TpAmb   :=""//2
local c_VerAplic:=""//SVRS20100811185009
local c_CStat   :=""//100
local c_XMotivo :=""//Autorizado o uso da NF-e
local c_CUF     :=""//11
local c_ChNFe   :=""//11110384712611000152550010000004201000004201
local c_DhRecbto:=""//29/03/2011 07:47:33
local c_NProt   :=""//311110000010110
xCbdtpEmis:="9"
///////FIM///////////////
 lRet:=consulta_status_servico()
 publ path :=DiskName()+":\"+CurDir()  

Reconectar_A() 

*lRet:=consulta_status_servico()

 if lRet==.t.
   CQuery:= "select CHAVE,nt_retorno,CbdNtfNumero FROM nfce"  
	oQuery_Item:=oServer:Query( cQuery )
	If oQuery_Item:NetErr()												
       MsgStop(oQuery_Item:Error())
       Return .f.
	End 

nCount=0 
For i := 1 To oQuery_Item:LastRec()

  oRow := oQuery_Item:GetRow(i)
  oQuery_Item:Skip(1)
  m->CbdNtfNumero   :=oRow:fieldGet(1)
  m->CbdNtfSerie   :=oRow:fieldGet(2)
  pACode  :=ntrim(oRow:fieldGet(3))
  nnfe:="NFE"+(pACode)
 
   cQuery:= "select CHAVE,nt_retorno,cbdntfserie,cbdMod FROM nfce  WHERE CbdNtfNumero = "+pACode+" and CbdtpEmis = "+xCbdtpEmis+"  Order By CbdNtfNumero" 
  *CQuery:= oServer:Query( "SELECT CHAVE,nt_retorno,cbdntfserie,cbdMod FROM nfce WHERE CbdNtfNumero = "+pACode+" and CbdtpEmis = "+xCbdtpEmis+"  Order By CbdNtfNumero" )
   oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  	oRow          :=oQuery:GetRow(1)
	m->CbdNtfSerie:=oRow:FieldGet(3)
	
If Empty(oRow:FieldGet(2))
    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
  Return(.f.)
EndIf
 HANDLE :=  FCREATE ("NOTA.XML",0)// cria o arquivo
 FWRITE(Handle,oRow:FieldGet(2))
fclose(handle)  

public cTXT     :=PATH+"\NOTA.XML"
NFe_ENV(alltrim(cTXT))

	cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'
	lRetStatus:=EsperaResposta(cDestino) 
	    if lRetStatus==.t.
		////RETORNO////
		BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
	   GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
	   GET c_NProt          SECTION  nnfe            ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
	   GET c_DhRecbto       SECTION  "ENVIO"         ENTRY "DhRecbto"   // DADA E HORA 
	   GET c_ChNFe          SECTION  nnfe            ENTRY "ChNFe"      // chave nfe  
	   GET R_DigVal         SECTION  nnfe            ENTRY "DigVal"      
	   GET R_DhRecbto       SECTION  nnfe            ENTRY "DhRecbto"       
	/////////////////////////////////////////////////////////////
END INI
End
	
			IF R_CStat<>'100' 
			if R_CStat<>'150'
			MSGINFO("Ret: "+R_XMotivo)
			END
			END
			if R_CStat=='100'  .or.  R_CStat=='150'
   ffxml:="C:\ACBrNFeMonitor\"+c_ChNFe+"-nfe.XML"
   ffxml         :=memoread(ffxml)
  * msginfo(ffxml)
   cQuery:="update nfce set autorizacao='"+C_NPROT+"',CbdStatus='"+R_XMotivo+"',nt_retorno='" +alltrim(ffxml)+"' where cbdntfnumero="+(m->CbdNtfNumero) +" and cbdntfserie='"+m->CbdNtfSerie +"' and cbdMod='65'"
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  Return Nil
Endif
  

		nCount++  
		   endif
		   
		  oQuery_Item:Skip(1)
		Next
	oQuery_Item:Destroy()
	
   Contingencia.Label_index.value:=alltrim(str(nCount))+"-->> Notas Fiscais Enviadas"
	msginfo("Processo concluido com sucesso...")

endif

Return 


Function ProcedureStatus() 
LOCAL lRetStatus,lRet:=.f.
LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
LOCAL FC_NORMAL:=""
ERASE "C:\ACBrNFeMonitor\sainfe.txt"

     IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
         MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
         Return
     ENDIF 
     FWRITE(nHandle,'NFE.StatusServico("")' )
     FCLOSE(nHandle)
 
		vArq:="C:\ACBrNFeMonitor\SAINFE.TXT" 
		lRetStatus:=EsperaResposta(vArq,2) 
      if lRetStatus==.t.
			cTexto := Memoread ( "C:\ACBrNFeMonitor\SAINFE.TXT" )
	
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
               LOCAL cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'
		         LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
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
							BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
								   GET r_Stat           SECTION  "RETORNO"       ENTRY "CStat"       
								   GET r_ChNFe          SECTION  "RETORNO"       ENTRY "ChNFe"       
							END INI
				      end
				end
				/*
				  MSGINFO(r_ChNFe)
           if r_Stat=='704'
           MSGINFO(SUBSTR(r_ChNFe,21,2))
           MSGINFO(SUBSTR(r_ChNFe,23,3))
           MSGINFO(SUBSTR(r_ChNFe,26,9))
	           NFe_INU( alltrim(mgCNPJ), 'FAIXA DE NUMERO NAO UTILIZADA',substr(dtos(DATE()),0,4),SUBSTR(r_ChNFe,21,2),  SUBSTR(r_ChNFe,23,3),  SUBSTR(r_ChNFe,26,9), SUBSTR(r_ChNFe,26,9),,,,DTOS(DATE()) )
			  end
			  */		 	 
			  RETURN                                         

        Function ProcedureImprimirEvento(oArq)
		      LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
				LOCAL nLote    := '0'

               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
              FWRITE(nHandle,"NFe.ImprimirEvento(C:\ACBrNFeMonitor\"+oArq+")")
              FCLOSE(nHandle) 

			RETURN

        Function ProcedureEmitirDANFE(oArq,sChave)
		      LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
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
		      LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
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
               LOCAL cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'
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
		      LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
				LOCAL cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'
				LOCAL nLote    := '0'
	   		  Public cSAIDA_XML:=''
   			  Public cCHAVE_XML:=''

		  		ERASE "C:\ACBrNFeMonitor\sainfe.txt"

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

