
			//////[enviar]///////////
		       IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			      Return
               ENDIF 
					  
      ** gera e imprime      FWRITE(nHandle,"NFE.CriarEnviarNFe("+cTXT+","+nLote+",1,0")
      ** gera e nao imprime  FWRITE(nHandle,"NFE.CriarEnviarNFe("+cTXT+","+nLote+",0,0")
      
   FCLOSE(nHandle) 


       lRetStatus:=EsperaResposta(cDestino)
          if lRetStatus==.t.
        if SUBSTR(memoread(cDestino), 1, 4)=="ERRO"
         MSGINFO(memoread(cDestino))
           cEnvio_XML:=.f.
        else
       BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
       GET R_CStat          SECTION  "RETORNO"       ENTRY "CStat"
	   GET R_XMotivo        SECTION  "RETORNO"       ENTRY "XMotivo"
   	   GET c_DhRecbto       SECTION  "ENVIO"         ENTRY "DhRecbto"   // DADA E HORA 
       GET c_ChNFe          SECTION  alltrim(nnfe)   ENTRY "ChNFe"      // chave nfe  
	   GET R_DigVal         SECTION  alltrim(nnfe)   ENTRY "DigVal"      
	   GET R_DhRecbto       SECTION  nnfe            ENTRY "DhRecbto"       
       GET c_NProt          SECTION  nnfe            ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
  END INI
 end
end
	  
public  RR_CStat :=R_CStat
public C_XMotivo :=R_XMotivo
public cc_ChNFe  :=c_ChNFe
public c_nuNFe   :=str(unNFe)
public cR_DigVal :=R_DigVal
public cc_NProt  :=c_NProt
public cc_DhRecbto:=c_DhRecbto
MODIFY CONTROL mostra_XML OF oForm2  VALUE   'Criando....  '+alltrim(cc_ChNFe) 

XML:=cc_ChNFe
fxml:="C:\ACBrNFeMonitor\"+xml+"-nfe.xml"
*msginfo(fxml)
ffxml:=memoread(fxml)



if RR_CStat=="100"


*GRAVA_nfCe1(PEGO_ChNFe,nuNFe)
cQuery := "UPDATE NFCE SET AUTORIZACAO='"+cc_NProt+"',CHAVE='"+cc_ChNFe+"',nt_retorno= '"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = "+ntrim(nuNFe)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(xCbdNtfSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
  Endif

                  SELE NFCE 
                    If LockReg()  
                       NFCE->NUM_SEQ := 0 
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                 Unlock
                 ENDIF   
GRAVA_nfCe1(nuNFe,mCbdtpEmis,cc_ChNFe,c_NProt)
*msginfo(R_XMotivo)
ENDIF

//////////////////////////////////////
**********se algo errado 
//////////////////////////////////////

if RR_CStat=="204" .or. RR_CStat=="539"

*msginfo(R_XMotivo + "Favor Reemviar Novamente............." )

cQuery := "UPDATE NFCE SET AUTORIZACAO='"+cc_NProt+"',CHAVE='"+cc_ChNFe+"',nt_retorno= '"+(AllTrim(ffxml))+"' WHERE CbdNtfNumero = "+ntrim(nuNFe)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(xCbdNtfSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
  Endif
  
fxml:="C:\ACBrNFeMonitor\"+cc_ChNFe+"-nfe.XML"
NFe_IMP(alltrim(fxml)) 
  
  
  
                   SELE NFCE 
                    If LockReg()  
                       NFCE->NUM_SEQ := VAL(c_nuNFe)+1
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                 Unlock
                 ENDIF   
				 
     Select ITEMNFCE
      go top
       OrdSetFocus('item')
 Do While ! ITEMNFCE->(Eof())
	  If LockReg()  
         ITEMNFCE->nseq_orc  := VAL(c_nuNFe)+1
		 ITEMNFCE->(DBCOMMIT())
		 ITEMNFCE->(DBUNLOCK())
          Unlock
         ENDIF            
ITEMNFCE->(dbskip())
LOOP
ENDD
ENDIF
RETURN
********************************************
