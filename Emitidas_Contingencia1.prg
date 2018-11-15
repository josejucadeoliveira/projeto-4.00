/******************************************************************************  
 * Sistema .....: Mgi  
 * Programa ....:   
 * Autor .......: Gilmar Brizolla dos Santos  
 * Sintese .....: Envia Notas emitidas em Contigencia  
 * Data ........: 03/09/2014 às 08:08:26  
 * Revisado em .: 03/09/2014 às 08:08:26  
 ******************************************************************************/  
#include 'common.ch'  
#include "i_mBrowse.ch"
#Include "MiniGui.ch"
declare window Thisform
  
FUNCTION Emitidas_Contingencia()  
   
DEFINE WINDOW Contingencia AT 114 , 258 WIDTH 1038 HEIGHT 533  TITLE "Notas Fiscal Emitidas em Ambiente de Contigência"  MODAL  FONT "Arial" SIZE 10 
                                      


     ON KEY ESCAPE  OF Contingencia ACTION { || Contingencia.RELEASE } 

 		DEFINE STATUSBAR FONT 'Verdana' SIZE 7			
			STATUSITEM "Contingencia"
          *  statusitem 'F8-Calculadora' width 140 icon 'calculadora.ico' action Calculadora()
          *  statusitem 'F3-Calendário' width 140 icon 'calendario.ico' action Calendario()
		END STATUSBAR
		
       on key F3 action Calendario()
       on key F8 action Calculadora()
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
			HEADERS  {'NF-e','Série','Código','Cliente','Data','Valor' ,'Protocolo','Chave','Retorno'};
			WIDTHS  { 70,50,50,280,80,80,120,150,100 } ;
			FIELDS  {'CbdNtfNumero','CbdNtfSerie','CodCli','CbdxNome_dest','CbddEmi','CbdvNF','CbdProtocolo','CbdChave','CbdStatus'}	 ;
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
 
		cQuery:= "DROP TEMPORARY TABLE IF EXISTS tmp_nfe"
		SQL_Error_oQuery()
	    oQuery:Destroy()
		cQuery:= "CREATE TEMPORARY TABLE tmp_nfe select * FROM "+c_Tabela_NFe_ACBr+" where CbdtpEmis=9 and ( CbdProtocolo is null or CbdProtocolo='')"
		SQL_Error_oQuery()
	    oQuery:Destroy()

		CQuery:= "select * FROM tmp_nfe"  
		SQL_Error_oQuery( )
		oRow:= oQuery:GetRow(1)
     if oQuery:LastRec()>0
			Emitidas_Contingencia()
      end

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
    	F_ERASE("*-ped-rec.xml","C:\ACBrNFeMonitor")
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
///////FIM///////////////
 lRet:=consulta_status_servico()
 if lRet==.t.
	CQuery:= "select CbdNtfNumero,CbdNtfSerie,CbdChave FROM tmp_nfe"  
  
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
  cChave   :=oRow:fieldGet(3)
  nnfe:="NFE"+alltrim(str(m->CbdNtfNumero))
  Contingencia.Label_index.value:="Enviando NFe "+alltrim(str(m->CbdNtfNumero))+" - "+cChave+" AGUARDE..."	
  
   							cQuery:="select xml,CbdChave  FROM "+c_Tabela_NFe_ACBr+"  WHERE CbdChave ='" + alltrim(cChave)+"'"
								SQL_Error_oQuery( )
								oRow:= oQuery:GetRow(1)
									
								If Empty(oRow:FieldGet(1))
								    MsgInfo("Não Existe anexo para a Chave "+cChave+" - Verifique!!!","Consultas")
								EndIf
		
					  		 	HANDLE :=  FCREATE ( "C:\ACBrNFeMonitor\"+cChave+"-nfe.XML",0)// cria o arquivo
							   FWRITE(Handle,oRow:FieldGet(1))
								fclose(handle)
		
							   MY_WAIT( 3 ) 
								ERASE "C:\ACBrNFeMonitor\sainfe.txt"
						  	 	ProcedureEnviarXML(  "C:\ACBrNFeMonitor\"+cChave+"-nfe.XML" )
						  	 	
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
									end
	
							
								IF R_CStat<>'100' 
								if R_CStat<>'150'

									MSGINFO("Ret: "+R_XMotivo)

								END
								END
 
			if R_CStat=='100'  .or.  R_CStat=='150'
		

			      ffxml:=memoread(  "C:\ACBrNFeMonitor\"+cChave+"-nfe.xml" )
 
					cQuery:="update "+c_Tabela_NFe_ACBr+" set CBDProtocolo='"+;
							C_NPROT+"',CbdStatus='"+R_XMotivo+"',xml='" +alltrim(ffxml)+"' where cbdntfnumero="+str(m->CbdNtfNumero) +" and cbdntfserie='"+m->CbdNtfSerie +"' and cbdMod='65'"
							
					SQL_Error_oQuery()
					oQuery:Destroy()
					nCount++  
 	
			EndIf	
					
 										                 
		  oQuery_Item:Skip(1)
		  
		Next
	oQuery_Item:Destroy()
   Contingencia.Label_index.value:=alltrim(str(nCount))+"-->> Notas Fiscais Enviadas"
	msginfo("Processo concluido com sucesso...")
    F_ERASE("*-ped-sta.xml","C:\ACBrNFeMonitor")
    F_ERASE("*-sta.xml","C:\ACBrNFeMonitor")
	Contingencia.RELEASE
 end 
Return 


