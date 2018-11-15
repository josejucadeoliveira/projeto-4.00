#INCLUDE "MINIGUI.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "hbcompat.CH"
#include "ACBr.ch"   // inicializa constantes manifestas do sistema/ACBr.
#define _use_CallDLL
#include <mgi.ch>


// color degrade
#define NONE      0
#define BOX       2
#define PANEL     3
STATIC PastaxmlEnvio
STATIC PastaxmlRetorno 
STATIC PastaxmlEnviado 
STATIC PastaxmlErro    
STATIC PastaxmlBackup

Function GeraArqACBr(nTela,nCliente,nObservacoes,nPedido, nCupom ,nECF,xUF_VEICULO,xModalidade_Frete,xCbdCNPJ_transp,;
					xCbdxNome_transp,xCbdIE_transp,xCbdxEnder,xCbdxMun_transp  ,xCbdUF_transp ,xCbdplaca,xCbdRNTC ,;
					xQTD_VOLUMES,xCbdesp,xMarca,xNUMERO_VOL	,xPESOBRUTO,xPESOLIQ,nEmissao,nSaida,mVlr_Frete,mVlr_Seguro,;
					mVlr_Desconto	,mVlr_IPI ,mVlr_Despesas,aFormaPagamento,mCbdnatOp, xCbdNtfNumero	,xCbdNtfSerie,nTipo_Emissao,;    ///dados do cliente daqui para baixo
					mCNPJDESTINATARIO,mxInscricaoEstadual,mNomeDestinatario,mxEnd_Destinatario,mxNumero_Destinatario,mComplemento_Destinatario,;
					mxBairro_Destinatario,mxCodMun_Destinatario,mCidade_Destinatario,mEstado_Destinatario,mCEP_Destinatario,mfone_Destinatario,;
					mSuframa_Destinatario,mEmail_Destinatario)



LOCAL oXml, cId, oArq
Public cEmail  :=mEmail_Destinatario
Public mNome_Destinatario :=mNomeDestinatario
Public mCNPJ_DESTINATARIO :=mCNPJDESTINATARIO
Public mEnd_Destinatario :=mxEnd_Destinatario
Public mBairro_Destinatario :=mxBairro_Destinatario
Public mNumero_Destinatario :=mxNumero_Destinatario
Public mCodMun_Destinatario :=mxCodMun_Destinatario
Public mInscricaoEstadual :=mxInscricaoEstadual
Public mCbdfinNFe :='0'
Public mValor_Frete       :=mVlr_Frete
Public mValor_Seguro      :=mVlr_Seguro
Public mValor_Desconto    :=mVlr_Desconto
Public mValor_IPI         :=mVlr_IPI
Public mValor_Despesas    :=mVlr_Despesas
Public Base_Calculo_Frete :=0
Public Icms_Frete         :=0
Public Gravar_Dados_Venda :=.f.
Public mModelo_NFe :='55'

 
SET DATE FORMAT TO "dd/mm/yyyy"
  
		
 		lRetorno_Internet:=IsInternet()
 		
  		if lRetorno_Internet==.f.
			msginfo("Sem acesso a Internet, Favor verificar sua Conexão")
		   return
 		 end                 

 		lStatus:=ProcedureStatus() 	 
		if lStatus==.f.
			msginfo("ERRO: WebService Inativo ou Inoperante tente novamente!")
		   return
		end
 
				BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
				  SET SECTION "DANFE"              ENTRY "PathPDF"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "Arquivos"           ENTRY "PathNFe"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "Arquivos"           ENTRY "PathCan"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "Arquivos"           ENTRY "PathInu"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "Arquivos"           ENTRY "PathDPEC"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				END INI

ProcedureLerINI()

if mgTIPO_ACBR==1
	    ProcedureSelecionaCertificado()
END

#define _SHOW_PERCENT 5
#define _SMALL_BLOCK 4096
#define _DEFAULT_BLOCK 8192
#define _LARGE_BLOCK 16384

		if xModalidade_Frete==1
  		   mModalidade_Frete            := '0'  ///0-emitente  
		elseif xModalidade_Frete==2
  		   mModalidade_Frete            := '1'  ///1-destinatario  
		else 
  		   mModalidade_Frete            := '2'  ///1-destinatario  
		end


m->CbdNtfNumero:= xCbdNtfNumero	
m->CbdNtfSerie	:= xCbdNtfSerie

 
if cAprova_Emissao==1
   msgstop('Atenção... Emissão na NFe não liberada, existem dados incorretos ou não informado...','Atenção')
   return
endif

 		cQuery:= "SELECT CbdProtocolo FROM "+c_Tabela_NFe_ACBr +" where CbdMod='55' and CbdNtfSerie="+str(nSerie_Nfe)+ " and CbdNtfNumero="+str(m->CbdNtfNumero-1) 
 		SQL_Error_oQuery()
		oRow:= oQuery:GetRow(1)
      if empty(oRow:fieldGet(1)).and.oQuery:LastRec()>0
		MSGExclamation(PadC("*** ATENCAO ***",80)+QUEBRA+;
			   PadC("A última NF-e emitida está sem Protocolo de Autorização",80)+QUEBRA+;
			   PadC("Por Favor verifique",80)+QUEBRA+;
			   PadC("Provavelmente existem outros úsuarios aguardando retorno, Aguarde...",80)+QUEBRA+;
			   PadC("Obrigado!!!",80),SISTEMA)
//			   fechar_nfe()
			   return
		end
			oQuery:Destroy()

 		cQuery:= "SELECT MAX(CbdNtfNumero) AS Numero  FROM "+c_Tabela_NFe_ACBr +" where CbdMod='55' and CbdNtfSerie="+str(nSerie_Nfe)  
 		SQL_Error_oQuery()
		oRow:= oQuery:GetRow(1)
      if oRow:fieldGet(1)==m->CbdNtfNumero
			m->CbdNtfNumero :=oRow:fieldGet(1)+1
		end
			oQuery:Destroy()

 
  sele auxilia3
  SUM SubTotal,base_icms,TOTICMS,TOTIPI,VALDES,TOTAL_ST,ICMS_ST TO nTotal_Itens,nTotalBase,nTotal_icms,nTotal_IPI,nTotal_Desc,nTotal_BaseST,nIcms_ST
  mValor_IPI 			   :=  nTotal_IPI 
  mValor_Desconto    	:=  nTotal_Desc
  nTotalBase			   :=  nTotalBase///+Base_Calculo_Frete                                                     	
  nTotal_Icms           :=  nTotal_icms///+Icms_Frete

 
if nTela=='PERDAS_ESTOQUE' .or.nTela=='BAIXA_ACOUGUE' .or.nTela=='ENTRADA_ACOUGUE'.or.nTela=='DEVOLUCAO_CUPOM'

   mEmail_Destinatario:=''
   mCNPJ_DESTINATARIO :=mgCNPJ
	mNome_Destinatario :=retiraacento(mgEmpresa)
	mEnd_Destinatario  :=retiraacento(mgEndereco)
	mNumero_Destinatario:=ALLTRIM(str(mgNumero))
	mComplemento_Destinatario:=''       
	mBairro_Destinatario:=alltrim(retiraacento(mgBairro))
	mCodMun_Destinatario:=(mgCodMun )
	mCidade_Destinatario:=retiraacento(mgCidade)
	mEstado_Destinatario:=mgEstado
	if len(limpa(mgCEP))<>8
		msginfo('CEP do cliente está incorreto...')
      cAprova_Emissao:=1
	else
	mCEP_Destinatario:=limpa(mgCEP)
	end
	if len(limpa(mgFONE))<>10.and.len(limpa(mgFONE))<>0
		msginfo('Telefone do cliente está incorreto...')
      mfone_Destinatario:=''
	else
 	mfone_Destinatario:=limpa( mgFONE )
	end
	mSuframa_Destinatario:=''
	mInformacoes_Complem :=''
   mInscricaoEstadual:=limpa(mgInscricao)
   
elseif nTela=='SELECAO'  .or.nTela=='DEVOLUCAO_NFE'    .or.nTela=='TRANSFERENCIA'

   Select_cliente(nCliente)

   mEmail_Destinatario:=xEmail_Cliente
   mCNPJ_DESTINATARIO :=xCNPJ_Cliente
	mNome_Destinatario :=retiraacento(xrazao_social_cliente)
	mEnd_Destinatario  :=retiraacento(xendereco_cliente)
	mNumero_Destinatario:=ALLTRIM(str(xNumero_cliente))
	mComplemento_Destinatario:=''       
	mBairro_Destinatario:=alltrim(retiraacento(xbairro_cliente))
	mCodMun_Destinatario:=STR(xCodMunicipio_Cliente)
	mCidade_Destinatario:=retiraacento(xcidade_Cliente)
	mEstado_Destinatario:=xUF_Cliente
	if len(limpa(xCEP_Cliente))<>8
		msginfo('CEP do cliente está incorreto...')
        cAprova_Emissao:=1
	else
	mCEP_Destinatario:=limpa(xCep_Cliente)
	end
	if len(limpa(xFONE_Cliente))<>10.and.len(limpa(xFONE_Cliente))<>0
		msginfo('Telefone do cliente está incorreto...')
      mfone_Destinatario:=''
	else
 	mfone_Destinatario:=limpa( xfone_Cliente )
	end
	mSuframa_Destinatario:=''
  
  if empty(xEndereco_Cliente).or.empty(xBairro_Cliente).or.empty(xCEP_Cliente).or.;
     empty(xCidade_Cliente).or.empty(xUF_Cliente).or.empty(xCNPJ_Cliente).or.xCodMunicipio_Cliente=0.or.empty(xCodMunicipio_Cliente)
	 msginfo("Dados do Cliente estão incompletos... Verifique antes de emitir a nota fiscal.","ERRO 002")
  endif

  vcnpjcpf(xCNPJ_Cliente)
  
  if Len(limpa(xCNPJ_Cliente))=11.AND.xTipo_Cliente="F"
       mInscricaoEstadual:='ISENTO'
  elseif xTipo_Cliente="R"	   
       mInscricaoEstadual:=xInscricao_Cliente
  elseif empty(xInscricao_Cliente)
       mInscricaoEstadual:='ISENTO'
  else
       mInscricaoEstadual:=xInscricao_Cliente
       nResposta := ConsisteInscricaoEstadual(LIMPA(mInscricaoEstadual),upper(xUF_Cliente))
       if nResposta<>0
           MSGINFO( "Inscrição inválida para o estado de "+upper(xUF_Cliente)+"...")
		   RETURN
       Endif
  end
   
else ///outras notas
 
	if len(limpa(mCEP_Destinatario))<>8
		msginfo('CEP do cliente está incorreto...')
      cAprova_Emissao:=1
	end
	if len(limpa(mfone_Destinatario))<>10.and.len(limpa(mfone_Destinatario))<>0
		msginfo('Telefone do cliente está incorreto...')
      RETURN
	end
 
  vcnpjcpf(mCNPJ_DESTINATARIO)
  
  if Len(limpa(mCNPJ_DESTINATARIO))=11 
       mInscricaoEstadual:='ISENTO'
  elseif empty(limpa(mInscricaoEstadual))
       mInscricaoEstadual:='ISENTO'
  else
       mInscricaoEstadual:=mInscricaoEstadual
       nResposta := ConsisteInscricaoEstadual(LIMPA(mInscricaoEstadual),upper(mEstado_Destinatario))
       if nResposta<>0
           MSGINFO( "Inscrição inválida para o estado de "+upper(mEstado_Destinatario)+"...")
		   RETURN
       Endif
  end

end


   if mgCNPJ=='15.564.290/0001-73' .OR. mgCNPJ=='06.993.231/0001-20'
      aadd(Obs_Nota,{99,"Nome: "+xNome_Cliente})
      aadd(Obs_Nota,{99,"Vendedor: "+cNomeVendedor})
   end
   
	mInformacoes_Complem :=strtran( alltrim(nObservacoes), chr(13)+chr(10), "" ) 

	mCbdtpEmis	         :=1  ///-->> 1 – Normal – emissão normal','2 – Contingência Formulário de Segurança','3 – Contingência SCAN','4 – Contingência DPEC','5 –  Contingência Formulário de Segurança-DA'
	mCbdfinNFe           :='0'  ///-->> 0 - Documento Regular / 3 - Documento Cancelado	
	nEmissao			 :=dt_server
   achou:=.f.
	
  			for i=1 to len(Obs_Nota)
            if Obs_Nota[i,1]=0
                 achou:=.t.
            end if
			next

	if mgRegime==1.or.mgRegime==2
	/*
		if empty(mgINF_NFe)
			if !achou
				if mgGeraCreditoIcms==.f.
				  if mCFOP<>'5.202'.or.mCFOP<>'6.202'.or.mCFOP<>'5.411'.or.mCFOP<>'6.411'.or.mCFOP<>'6.949'.or.mCFOP<>'5.949'
					aadd(Obs_Nota,{0,'Documento emitido por empresa optante pelo Simples Nacional, nao permite aproveitamento de '+;
									 'credito de IPI e de ICMS nos termos do art. 23 da LC 123'  })
				  end
				else
				  if achou_Credito_Simples==.t.
					  if mCFOP=='5.202'.or.mCFOP=='6.202'.or.mCFOP=='5.411'.or.mCFOP=='6.411'.or.mCFOP=='6.949'.or.mCFOP=='5.949'
	//					aadd(Obs_Nota,{0,'Nota fiscal de Devolucao de compra emitido por empresa optante pelo Simples Nacional, permite aproveitamento de '+;
	//									 'credito de ICMS : BASE DE CALCULO: '+transf(nTotalBase,'999,999.99')+', VALOR DO ICMS: '+;
	//									 transf(nTotal_icms,'999,999.99')  })
						end
				  else
					  if mCFOP<>'5.202'.or.mCFOP<>'6.202'.or.mCFOP<>'5.411'.or.mCFOP<>'6.411'.or.mCFOP<>'6.949'.or.mCFOP<>'5.949'
						aadd(Obs_Nota,{0,'Documento emitido por empresa optante pelo Simples Nacional, permite aproveitamento de '+;
										 'credito de ICMS no Valor de R$ '+transf(nCredito_Simples,'999,999.99')+', correspondente a Aliquota de '+;
										 transf(mgALICOTA,'999.99')+'% nos termos do art. 23 da LC 123'  })
					  end
				  end   				
				end
			end
		else

			aadd(Obs_Nota,{0,mgINF_NFe})
		end
	*/	
        
				  if mCFOP=='5.102'.or.mCFOP=='6.102'.or.mCFOP=='5.405'.or.mCFOP=='5.403'.or.mCFOP=='6.403'.or.mCFOP=='6.405' 
 
						if achou_Credito_Simples==.t.
						aadd(Obs_Nota,{0,'Documento emitido por empresa optante pelo Simples Nacional, permite aproveitamento de '+;
										 'credito de ICMS no Valor de R$ '+transf(nCredito_Simples,'999,999.99')+', correspondente a Aliquota de '+;
										 transf(mgALICOTA,'999.99')+'% nos termos do art. 23 da LC 123'  })
					  end
				  end   				

	 				aadd(Obs_Nota,{0,mgINF_NFe})

	end
			  
 
 if cAprova_Emissao==1
   msgstop('Atenção... Emissão na NFe não liberada, existem dados incorretos ou não informado...','Atenção')
   return
endif
           if nTotal_Itens=0   
		      msginfo('ATENÇÃO...Nenhum valor ou item informado. sua NF-e não será emitida...')
              return
		   end  
		 
		 
         nfeEmpresa:=RetiraAcento(mgEMPRESA)
         xEndereco:=RetiraAcento(Alltrim(mgENDERECO)) 
         EmpEndereco:=""
         EmpoNumero:="" 
         for k=1 to Len(xEndereco)
           xVar:=Substr(xEndereco,k,1)
           if xVar = ","
            EmpNumero:=Substr(xEndereco,k+1,Len(xEndereco)-k)
*            return
           else
            EmpEndereco:=EmpEndereco+xVar
           endif
         next
         codMunEmpresa:=mgCODMUN   
         nfeEmpresa:=RetiraAcento((Alltrim(mgEMPRESA)))
         MunEmpresa:=RetiraAcento((Alltrim(mgCIDADE))) 
         endEmepresa:=RetiraAcento(alltrim(mgENDERECO))  
         cepEmpresa:=limpa( mgCEP )
         FoneEmpresa:=limpa(Alltrim(mgFone)) 
         numLogradoro:=str(mgNumero) 
         BairroEmpresa:=(Alltrim(mgBairro))
         UfEmpresa:= (Alltrim(mgEstado)) 
         InscEmpresa:=limpa(Alltrim(mgInscricao))  
 
		 STATUS_NFe:={}

		 aadd(STATUS_NFe,{'NFE.StatusServico'})

		 handle:=fcreate("ENTNFE.TXT")
			for i=1 to len(STATUS_NFe)
				fwrite(handle,alltrim(STATUS_NFe[i,1]))
				      fwrite(handle,chr(13)+chr(10))
			next
		fclose(handle)  
		  
		if val(mCfop)<3
			public xCbdtpNf 		  := '0' //entrada
		else 
			public xCbdtpNf 		  := '1' //saida
		end



		If aFormaPagamento==1
			aFormaPagamento:=0
		ElseIf aFormaPagamento==2
			aFormaPagamento:=1
		else
			aFormaPagamento:=2
		end
		
		if mCfop='1.604'; ///homologacao de credito
				.or.mCfop='1.202'.or.mCfop='2.202';///devolucao de venda
				.or.mCfop='5.152'.or.mCfop='5.409';///transferencia entre notas
				.or.mCfop='5.202'.or.mCfop='6.202';///devolucao de compra
				.or.mCfop='6.915'.or.mCfop='5.915'; ///remessa para conserto
				.or.mCfop='6.916'.or.mCfop='5.916'; ///remessa consgnacao
				.or.mCfop='5.917'.or.mCfop='5.918'; ///remessa consgnacao
				.or.mCfop='5.919'  ///rremessa consgnacao
			aFormaPagamento:=2
		EndIf

		if val(mCfop)<3  ///sem pagamento para todos os tipos de entrada
			aFormaPagamento:=2
		end
   
	DADOS_NFe:={}
	if nTipo_Emissao==2		
		 aadd(DADOS_NFe,{'NFE.CriarEnviarNFe'})
	end
		 aadd(DADOS_NFe,{'[Identificacao]'})
		 aadd(DADOS_NFe,{'NaturezaOperacao='+mCbdnatOp})
		 aadd(DADOS_NFe,{'Modelo=55'})
		 aadd(DADOS_NFe,{'Codigo='+Alltrim(str(m->CbdNtfNumero))})
		 aadd(DADOS_NFe,{'Numero='+Alltrim(str(m->CbdNtfNumero))})
		 aadd(DADOS_NFe,{'Serie='+Alltrim((m->CbdNtfSerie))})

	if nTipo_Emissao==1 ///gerar somente xml
		 aadd(DADOS_NFe,{'Emissao='+dtoc(date())})
	    IF !EMPTY(DTOS(nSaida))  
			 aadd(DADOS_NFe,{'Saida='+dtoc(date())})
	    END
	else
		 aadd(DADOS_NFe,{'Emissao='+dtoc(nEmissao)})
	    IF !EMPTY(DTOS(nSaida))  
			 aadd(DADOS_NFe,{'Saida='+dtoc(nSaida)})
	    END
	end

                                 
		 aadd(DADOS_NFe,{'Tipo='+ xCbdtpNf })
		 aadd(DADOS_NFe,{'FormaPag='+str(aFormaPagamento)  })
		 aadd(DADOS_NFe,{'Finalidade=4'})
 
    If !Empty(nCupom)
		if  mgEMI_NFCe==.T.
 		 aadd(DADOS_NFe,{'[NFref001]'})
		 aadd(DADOS_NFe,{'refNFe='+nCupom})
		else
 		 aadd(DADOS_NFe,{'[NFref'+strzero(val(nECF),3)+']'})
		 aadd(DADOS_NFe,{'Tipo=ECF'})
		 aadd(DADOS_NFe,{'modECF=2D'})
		 aadd(DADOS_NFe,{'nECF='+strzero(val(nECF),3)})
		 aadd(DADOS_NFe,{'nCOO='+nCupom})
	 	end
    end

         // Dados do emitente

		 aadd(DADOS_NFe,{'[Emitente]'})
		 aadd(DADOS_NFe,{'CNPJ='+limpa(mgCNPJ) })
		 aadd(DADOS_NFe,{'IE='+InscEmpresa})
		 aadd(DADOS_NFe,{'ISUF='})
		 aadd(DADOS_NFe,{'Razao='+nfeEmpresa})
		 aadd(DADOS_NFe,{'Fantasia='})
		 aadd(DADOS_NFe,{'Fone=' +FoneEmpresa})
		 aadd(DADOS_NFe,{'CEP=' +cepEmpresa})
		 aadd(DADOS_NFe,{'Logradouro=' +EmpEndereco})
		 aadd(DADOS_NFe,{'Numero='+numLogradoro})
		 aadd(DADOS_NFe,{'Complemento='})
		 aadd(DADOS_NFe,{'Bairro=' +BairroEmpresa})
		 aadd(DADOS_NFe,{'CidadeCod='+codMunEmpresa })
		 aadd(DADOS_NFe,{'Cidade='+MunEmpresa})
		 aadd(DADOS_NFe,{'UF='+UfEmpresa })
		 aadd(DADOS_NFe,{'PaisCod=1058'}) 
		 aadd(DADOS_NFe,{'Pais=BRASIL'})
		 aadd(DADOS_NFe,{'CRT='+STR(mgREGIME) })
          // Dados do destinatário
 
		 aadd(DADOS_NFe,{'[Destinatario]' })

		 aadd(DADOS_NFe,{'CNPJ='+LIMPA(mCNPJ_DESTINATARIO) })
		 aadd(DADOS_NFe,{'NomeRazao='+( Alltrim(mNome_Destinatario) ) })
		 aadd(DADOS_NFe,{'IE='+mInscricaoEstadual })
		 aadd(DADOS_NFe,{'Fantasia='  })
		 aadd(DADOS_NFe,{'Fone=' +Alltrim(mfone_Destinatario ) })
		 aadd(DADOS_NFe,{'CEP=' +mCEP_Destinatario })
		 aadd(DADOS_NFe,{'Logradouro=' +Alltrim(mEnd_Destinatario ) })
		 aadd(DADOS_NFe,{'Numero='+Transform(Strzero(Val(Alltrim(mNumero_Destinatario)),6),"@!") })
		 aadd(DADOS_NFe,{'Complemento='  })
         if !Empty(mBairro_Destinatario)
		 aadd(DADOS_NFe,{'Bairro=' +Alltrim(mBairro_Destinatario) })
         else
		 aadd(DADOS_NFe,{'Bairro=CENTRO'  })
         endif
		 aadd(DADOS_NFe,{'CidadeCod='+(mCodMun_Destinatario) })
		 aadd(DADOS_NFe,{'Cidade='+Alltrim(mCidade_Destinatario) })
		 aadd(DADOS_NFe,{'UF='+Alltrim(mEstado_Destinatario)  })
		 aadd(DADOS_NFe,{'PaisCod=1058'})
		 aadd(DADOS_NFe,{'Pais=BRASIL'})


	
 select Auxilia3
 set order to 3
 go top
 
 xxx:=1  
 xxxvOutro:=0
 nFrete_Item :=0///mValor_Frete
 nPercentual_Frete_Item :=(	mValor_Frete/(nTotal_Itens-mValor_desconto)*100)
 nTotal_Frete_por_ITem:=0
 nTotal_ICMS_Frete_por_ITem:=0
 Public nTotal_Pis:=0
 Public nTotal_Cofins:=0
 DO WHILE .NOT.EOF()

 if Auxilia3->quant=0
    skip
    loop
 end
 
 nCfop:=limpa(Auxilia3->CFOP)
 
    m->cst_piscof:=Auxilia3->cst_piscof
	if mgREGIME==3
		if empty(m->cst_piscof)
		   m->cst_piscof:='01'
		end
    	m->CbdCST_cofins       := val(m->cst_piscof)
		if m->cst_piscof=='01'.or.m->cst_piscof=='02' .or.m->cst_piscof=='03' 
			m->CbdvBC_cofins       := Auxilia3->TOTAL_UNIT
			m->CbdpCOFINS          := auxilia3->ALIQ_COFIN
			m->CbdvCOFINS          := (Auxilia3->TOTAL_UNIT*auxilia3->ALIQ_COFIN)/100
			m->CbdqBCProd_cofins   := Auxilia3->Quant
			m->CbdvAliqProd_cofins := auxilia3->ALIQ_COFIN
		elseif m->cst_piscof=='06' 
			m->CbdCST_cofins      := 06
			m->CbdvBC_cofins      := 0
			m->CbdpCOFINS         := 0
			m->CbdvCOFINS         := 0
			m->CbdqBCProd_cofins  := 0
			m->CbdvAliqProd_cofins:= 0
		else
			m->CbdCST_cofins      := 99
			m->CbdvBC_cofins      := 0
			m->CbdpCOFINS         := 0
			m->CbdvCOFINS         := 0
			m->CbdqBCProd_cofins  := 0
			m->CbdvAliqProd_cofins:= 0
		end
	else
        m->CbdCST_cofins      := 99
		m->CbdvBC_cofins      := 0
		m->CbdpCOFINS         := 0
		m->CbdvCOFINS         := 0
		m->CbdqBCProd_cofins  := 0
		m->CbdvAliqProd_cofins:= 0
	end
	
 	nFrete_Item:=auxilia3->TOTAL_UNIT*(nPercentual_Frete_Item/100)
 	nBase_Frete_Item:=auxilia3->BASE_ICMS*(nPercentual_Frete_Item/100)
    nTotal_Frete_por_ITem:=nTotal_Frete_por_ITem+nBase_Frete_Item
    nTotal_ICMS_Frete_por_ITem:=nTotal_ICMS_Frete_por_ITem+nBase_Frete_Item*(auxilia3->alicota/100)


	if mgREGIME==3
		if empty(m->cst_piscof)
		   		   m->cst_piscof:='01'

		end
			m->CbdCST_pis       := val(m->cst_piscof)
			if m->cst_piscof=='01'.or.m->cst_piscof=='02' .or.m->cst_piscof=='03'  
				m->CbdvBC_pis       := Auxilia3->TOTAL_UNIT
				m->CbdpPIS          := auxilia3->ALIQ_PIS
				m->CbdvPIS          := (Auxilia3->TOTAL_UNIT*auxilia3->ALIQ_PIS  )/100
				m->CbdqBCProd_PIS   := Auxilia3->Quant
				m->CbdvAliqProd_PIS := auxilia3->ALIQ_PIS
			elseif m->cst_piscof=='06'
				m->CbdCST_PIS      := 06
				m->CbdvBC_PIS      := 0
				m->CbdpPIS         := 0
				m->CbdpCPIS        := 0
				m->CbdvPIS         := 0
				m->CbdqBCProd_PIS  := 0
				m->CbdvAliqProd_PIS:= 0
			else
				m->CbdCST_PIS      := 99
				m->CbdvBC_PIS      := 0
				m->CbdpPIS         := 0
				m->CbdpCPIS        := 0
				m->CbdvPIS         := 0
				m->CbdqBCProd_PIS  := 0
				m->CbdvAliqProd_PIS:= 0
			end
	else
        m->CbdCST_PIS      := 99
		m->CbdvBC_PIS      := 0
		m->CbdpPIS         := 0
		m->CbdpCPIS        := 0
		m->CbdvPIS         := 0
		m->CbdqBCProd_PIS  := 0
		m->CbdvAliqProd_PIS:= 0
	end
	

	
 if mgREGIME==3  ///REGIME NORMAL DE TRIBUTACAO
	 xCST:=stuff(auxilia3->cst,1,1,"")
	 M->CbdvBC            := auxilia3->BASE_ICMS+nBase_Frete_Item
	 M->CbdpICMS          := auxilia3->alicota
	 M->CbdvICMS_icms     := M->CbdvBC*(auxilia3->alicota/100)
	 M->CbdmodBCST        := 4
	 M->CbdpRedBC         := auxilia3->RED_BASE
	 M->CbdpCredSN		  := 0
	 M->CbdvCredICMSSN    := 0

	 
  else   ///REGIME SIMPLES
  
			 xCST:=auxilia3->cst

		  if mCFOP=='5.411'.or.mCFOP=='6.411'.or.mCFOP=='5.202'.or.mCFOP=='6.202'
			 M->CbdvBC            := auxilia3->BASE_ICMS+nBase_Frete_Item
			 M->CbdpICMS          := auxilia3->alicota
			 M->CbdvICMS_icms     := M->CbdvBC*(auxilia3->alicota/100)
			 M->CbdmodBCST        := 4
			 M->CbdpRedBC         := auxilia3->RED_BASE
			 M->CbdpCredSN		  := 0
			 M->CbdvCredICMSSN    := 0
		  else
		
			 M->CbdvBC            := auxilia3->BASE_ICMS
			 M->CbdpICMS          := 0
			 M->CbdvICMS_icms     := 0
			 M->CbdmodBCST        := 4
			 M->CbdpRedBC         := 0
			 M->CbdpCredSN		  := 0
			 M->CbdvCredICMSSN    := 0
			 IF auxilia3->cst=='101'
			    M->CbdpCredSN		  := mgALICOTA
			    M->CbdvCredICMSSN    := (auxilia3->TOTAL_UNIT*mgALICOTA)/100  
			 ELSEIF auxilia3->cst=='201'
			    M->CbdpCredSN		  := mgALICOTA
			    M->CbdvCredICMSSN    := (auxilia3->TOTAL_UNIT*mgALICOTA)/100  
			 ELSEIF auxilia3->cst=='202'
		*	    M->Base_ST            := (auxilia3->TOTAL_UNIT*mgALICOTAst)/100  
				///caso a empresa seje substituta do icms tem q preencher os campos
			 END
			 
			end
	
	end

         // Dados do ítem[xxx]
		 nx_taman := Len(Alltrim(Auxilia3->CODBARRA))
		 if nx_taman<>13
			nEAN:=''
		 end

		 if nx_taman<13
			nEAN:=''
		 end
		 
		If !ValidaEAN( Alltrim( Auxilia3->CODBARRA )).and.!empty(Auxilia3->CODBARRA)
		   MSGINFO("Código de Barra do item "+ALLTRIM(Auxilia3->DESCRICAO)+" é invalido, Corriga o cadastro do item" )
			nEAN:= '' 
		else
							   if nx_taman=13
									nEAN:= Auxilia3->CODBARRA
								end
		Endif
 
 
		 xITEM:=strzero(xxx,3)
		 aadd(DADOS_NFe,{'[Produto'+xITEM+']' })
		 aadd(DADOS_NFe,{'CFOP=' +limpa(nCFOP) })
        if mgCNPJ=='04.634.146/0001-40'
			if !empty(Auxilia3->codfor)
				aadd(DADOS_NFe,{'Codigo=' +ALLTRIM(Auxilia3->codfor) })
			else
				aadd(DADOS_NFe,{'Codigo=' +ALLTRIM(Auxilia3->codigo) })
			end
		else
		 aadd(DADOS_NFe,{'Codigo=' +ALLTRIM(Auxilia3->codigo) })
		end
		 aadd(DADOS_NFe,{'Descricao=' +Alltrim(Auxilia3->DESCRICAO) })
		 IF !EMPTY(Auxilia3->DESCR_SERV)
		 	aadd(DADOS_NFe,{'infAdProd=' +strtran( alltrim (Auxilia3->DESCR_SERV), chr(13)+chr(10), "" ) })
		 END
		 aadd(DADOS_NFe,{'EAN='+nEAN  })
		 aadd(DADOS_NFe,{'NCM=' +limpa(Auxilia3->NCM) })
		 aadd(DADOS_NFe,{'Unidade=' +Auxilia3->UNID })
		 aadd(DADOS_NFe,{'Quantidade=' +TRANSFORM(Auxilia3->Quant,"@! 99999999.9999") })
		 aadd(DADOS_NFe,{'ValorUnitario='+ALLTRIM(TRANSFORM(Auxilia3->Unit,"@ 999999999999.9999999999")) })
		 aadd(DADOS_NFe,{'ValorTotal=' +ALLTRIM(TRANSFORM(Auxilia3->Quant*Auxilia3->Unit,"@ 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorDesconto=' +ALLTRIM(TRANSFORM(Auxilia3->valdes,"@ 99999999999999.99"))  })
		if  mValor_Despesas>0 .and.xxxvOutro==0
		 aadd(DADOS_NFe,{'vOutro='+ALLTRIM(TRANSFORM((mValor_Despesas),"@! 999999999999.99")) })
		 xxxvOutro:=1
	   end
		 aadd(DADOS_NFe,{'vFrete='+ALLTRIM(TRANSFORM((nFrete_Item),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'NumeroDI=1' })

 	
		if auxilia3->IPI>0

			aadd(DADOS_NFe,{'[IPI'+xITEM+']' })
			aadd(DADOS_NFe,{'CST=99' })
			aadd(DADOS_NFe,{'ClasseEnquadramento=' })
			aadd(DADOS_NFe,{'CNPJProdutor=' })
			aadd(DADOS_NFe,{'CodigoSeloIPI=' })
			aadd(DADOS_NFe,{'QuantidadeSelos=' })
			aadd(DADOS_NFe,{'CodigoEnquadramento=' })
			aadd(DADOS_NFe,{'ValorBase='+str(Auxilia3->Quant*Auxilia3->Unit) })
			aadd(DADOS_NFe,{'Quantidade='+str(Auxilia3->Quant) })
			aadd(DADOS_NFe,{'ValorUnidade='+str(Auxilia3->Quant*Auxilia3->Unit) })
			aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(auxilia3->IPI,"@ 99.99")) })
			aadd(DADOS_NFe,{'Valor='+str(auxilia3->TOTIPI) })
			   
		endif

		 // Dados do icms[xxx]

		 aadd(DADOS_NFe,{'[ICMS'+xITEM+']' })
if mgREGIME==1.or.mgREGIME==2
    xICMS:='ICMSSN'
	if xCST='400'
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	elseif xCST='101'
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
		 aadd(DADOS_NFe,{'pCredSN='+ALLTRIM(TRANSFORM(M->CbdpCredSN ,"@ 99.99")) })
		 aadd(DADOS_NFe,{'vCredICMSSN='+ALLTRIM(TRANSFORM(M->CbdvCredICMSSN   ,"@ 99999999999999.99")) })
	elseif xCST='102'.or. xCST='103'
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	elseif xCST='201'
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	elseif xCST='202' 
 		 aadd(DADOS_NFe,{'CSOSN='+xCST })
		 aadd(DADOS_NFe,{'ModalidadeST=4' }) 
		 aadd(DADOS_NFe,{'PercentualMargemST=30' }) 
		 aadd(DADOS_NFe,{'ValorBaseST='+ALLTRIM(TRANSFORM(auxilia3->TOTAL_ST ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'AliquotaST='+ALLTRIM(TRANSFORM((auxilia3->ICMS_ST/M->CbdvBC)*100   ,"@ 99.99")) })
		 aadd(DADOS_NFe,{'ValorST='+ALLTRIM(TRANSFORM(auxilia3->ICMS_ST     ,"@ 99999999999999.99")) })
	elseif xCST='900' 
 		 aadd(DADOS_NFe,{'CSOSN='+xCST })
		 aadd(DADOS_NFe,{'ModalidadeST=4' }) 
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(M->CbdvBC   ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(M->CbdpICMS   ,"@ 99.99")) }) 
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(M->CbdvICMS_icms  ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'PercentualMargemST=35' }) 
		 aadd(DADOS_NFe,{'ValorBaseST='+ALLTRIM(TRANSFORM(auxilia3->TOTAL_ST ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'AliquotaST='+ALLTRIM(TRANSFORM((auxilia3->ICMS_ST/M->CbdvBC)*100   ,"@ 99.99")) })
		 aadd(DADOS_NFe,{'ValorST='+ALLTRIM(TRANSFORM(auxilia3->ICMS_ST     ,"@ 99999999999999.99")) })
	 else
		 aadd(DADOS_NFe,{'CSOSN='+xCST })
	end
elseif mgREGIME==3
    xICMS:='ICMS'
	if xCST=='60' 
		 aadd(DADOS_NFe,{'CST='+xCST })
	elseif xCST=='10'
		 aadd(DADOS_NFe,{'CST='+xCST })
		 aadd(DADOS_NFe,{'Modalidade=4' }) 
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(M->CbdvBC   ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(M->CbdpICMS   ,"@ 99.99")) }) 
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(M->CbdvICMS_icms  ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'PercentualReducao='+ALLTRIM(TRANSFORM(M->CbdpRedBC  ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'PercentualMargemST=30' }) 
		 aadd(DADOS_NFe,{'ValorBaseST='+ALLTRIM(TRANSFORM(auxilia3->TOTAL_ST ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'AliquotaST='+ALLTRIM(TRANSFORM((auxilia3->ICMS_ST/M->CbdvBC)*100   ,"@ 99.99")) })
		 aadd(DADOS_NFe,{'ValorST='+ALLTRIM(TRANSFORM(auxilia3->ICMS_ST     ,"@ 99999999999999.99")) })
	else
		 aadd(DADOS_NFe,{'CST='+xCST })
		 aadd(DADOS_NFe,{'Modalidade=0' }) 
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(M->CbdvBC   ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(M->CbdpICMS   ,"@ 99.99")) }) 
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(M->CbdvICMS_icms  ,"@ 99999999999999.99")) }) 
		 aadd(DADOS_NFe,{'PercentualReducao='+ALLTRIM(TRANSFORM(M->CbdpRedBC  ,"@ 99999999999999.99")) }) 
	end
end
        

              // Dados PIS EPP - Simples Nacional

         aadd(DADOS_NFe,{'[PIS'+xITEM+']' })
		 aadd(DADOS_NFe,{'CST='+strzero( m->CbdCST_PIS,2) })
		if mgREGIME==3
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(m->CbdvBC_pis ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(m->CbdpPIS  ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(m->CbdvPIS   ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Quantidade='+ALLTRIM(TRANSFORM(m->CbdqBCProd_PIS  ,"@ 99999999999999.99")) })
        end

         // Dados COFINS  

		 aadd(DADOS_NFe,{'[COFINS'+xITEM+']' })
		 aadd(DADOS_NFe,{'CST='+strzero( m->CbdCST_COFINS,2 )})
		if mgREGIME==3
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM(m->CbdvBC_COFINS ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Aliquota='+ALLTRIM(TRANSFORM(m->CbdpCOFINS  ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM(m->CbdvCOFINS   ,"@ 99999999999999.99")) })
		 aadd(DADOS_NFe,{'Quantidade='+ALLTRIM(TRANSFORM(m->CbdqBCProd_COFINS  ,"@ 99999999999999.99")) })
		end

		if !Empty(Auxilia3->codigo_anp)
         // Dados do combustivel
			aadd(DADOS_NFe,{'[Combustivel'+xITEM+']' })
         aadd(DADOS_NFe,{'cProdANP='+Auxilia3->codigo_anp })
         aadd(DADOS_NFe,{'CODIF=' })
         aadd(DADOS_NFe,{'qTemp=' })
         aadd(DADOS_NFe,{'UFCons='+mgEstado })
		EndIf


	 
       // nFrete_Item  :=0
	   // Icms_Frete   :=0
		nTotal_Pis:=nTotal_Pis+m->CbdvPIS
		nTotal_Cofins:=nTotal_Cofins+m->CbdvCOFINS
  xxx++
  select Auxilia3
  skip


ENDDO
 
          // Total da nota
		m->CbdvNF := (nTotal_Itens+mValor_IPI+mValor_Seguro+mValor_Despesas+mValor_Frete+nIcms_ST)-mValor_Desconto
		 
		 aadd(DADOS_NFe,{'[Total]' })
		 aadd(DADOS_NFe,{'ValorBase='+ALLTRIM(TRANSFORM((nTotal_Itens),"@! 999999999999.99")) })
	if mgREGIME==1.or.mgREGIME==2
	  if mCFOP=='5.411'.or.mCFOP=='6.411'.or.mCFOP=='5.202'.or.mCFOP=='6.202'
			 aadd(DADOS_NFe,{'BaseICMS='+ALLTRIM(TRANSFORM((nTotalBase+nTotal_Frete_por_ITem),"@! 999999999999.99")) })
			 aadd(DADOS_NFe,{'ValorICMS='+ALLTRIM(TRANSFORM((nTotal_ICMS+nTotal_ICMS_Frete_por_ITem),"@! 999999999999.99")) })
 		else
			 aadd(DADOS_NFe,{'BaseICMS=0' })
			 aadd(DADOS_NFe,{'ValorICMS=0'})
 		end
	else
		 aadd(DADOS_NFe,{'BaseICMS='+ALLTRIM(TRANSFORM((nTotalBase+nTotal_Frete_por_ITem),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorICMS='+ALLTRIM(TRANSFORM((nTotal_ICMS+nTotal_ICMS_Frete_por_ITem),"@! 999999999999.99")) })
	end
		 aadd(DADOS_NFe,{'BaseICMSSubstituicao='+ALLTRIM(TRANSFORM((nTotal_BaseST),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorICMSSubstituicao='+ALLTRIM(TRANSFORM((nIcms_ST),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorProduto='+ALLTRIM(TRANSFORM((nTotal_Itens),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorNota='+ALLTRIM(TRANSFORM((m->CbdvNF),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorDesconto='+ALLTRIM(TRANSFORM((mValor_Desconto),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorFrete='+ALLTRIM(TRANSFORM((mValor_Frete),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorOutrasDespesas='+ALLTRIM(TRANSFORM((mValor_Despesas),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorIPI='+ALLTRIM(TRANSFORM((mValor_IPI),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorPIS='+ALLTRIM(TRANSFORM((nTotal_Pis),"@! 999999999999.99")) })
		 aadd(DADOS_NFe,{'ValorCOFINS='+ALLTRIM(TRANSFORM((nTotal_Cofins),"@! 999999999999.99")) })
 
if nTela=="SAIDA"
 
	xUF_VEICULO:=aEstado[xUF_VEICULO]
	
	if mModalidade_Frete=='1'.or.mModalidade_Frete=='2'
		if !empty(xCbdCNPJ_transp)
			if Len(limpa(xCbdCNPJ_transp))=14		
				xCbdCNPJ_transp        :=limpa(xCbdCNPJ_transp)
			else
				xCbdCPF_transp         :=limpa(xCbdCNPJ_transp)
			endif
		end
	end

		if !empty(xUF_VEICULO)
			m->CbdUF_veictransp      := LIMPA(xUF_VEICULO)
		else
			m->CbdUF_veictransp      := 'RO'
		end


ENDIF
 

		 aadd(DADOS_NFe,{'[Transportador]' })
		 aadd(DADOS_NFe,{'FretePorConta='+mModalidade_Frete })
		 aadd(DADOS_NFe,{'CnpjCpf='+xCbdCNPJ_transp })
		 aadd(DADOS_NFe,{'NomeRazao='+xCbdxNome_transp })
		 aadd(DADOS_NFe,{'IE='+limpa(xCbdIE_transp) })
		 aadd(DADOS_NFe,{'Endereco='+retiraacento(alltrim(xCbdxEnder )) })
		 aadd(DADOS_NFe,{'Cidade='+xCbdxMun_transp })

		 aadd(DADOS_NFe,{'UF='+xCbdUF_transp   })
*		 aadd(DADOS_NFe,{'ValorServico='+ALLTRIM(TRANSFORM((mValor_Frete),"@! 999999999999.99")) })
*		 aadd(DADOS_NFe,{'ValorBase=0' })
*		 aadd(DADOS_NFe,{'Aliquota=0' })
*		 aadd(DADOS_NFe,{'Valor=0' })
*		 aadd(DADOS_NFe,{'CFOP=' })
*		 aadd(DADOS_NFe,{'CidadeCod=' })
		 if !empty(limpa(xCbdplaca))
		 aadd(DADOS_NFe,{'Placa='+limpa(xCbdplaca)  })
		 aadd(DADOS_NFe,{'UFPlaca='+m->CbdUF_veictransp  })
		 aadd(DADOS_NFe,{'RNTC='+xCbdRNTC	 })
		 end



if nTela=="SAIDA"
if xQTD_VOLUMES>0.or.xPESOBRUTO>0

		IF xCbdesp==1
			m->Cbdesp            := 'VOLUMES' 
		ELSEIF xCbdesp==2
			m->Cbdesp            := 'CAIXAS' 
		ELSEIF xCbdesp==3
			m->Cbdesp            := 'FARDOS' 
		ELSEIF xCbdesp==4
			m->Cbdesp            := 'SACOS' 
		END
		
		 aadd(DADOS_NFe,{'[Volume001]' })
		 aadd(DADOS_NFe,{'Quantidade='+ALLTRIM(TRANSFORM((xQTD_VOLUMES),"@! 9999999999999")) })
		 aadd(DADOS_NFe,{'Especie='+m->Cbdesp })
		 aadd(DADOS_NFe,{'Marca='+retiraacento(xMarca)})
		 aadd(DADOS_NFe,{'Numeracao='+xNUMERO_VOL })
		 aadd(DADOS_NFe,{'PesoLiquido='+ALLTRIM(TRANSFORM((xPESOBRUTO),"@! 9999999999.999")) })
		 aadd(DADOS_NFe,{'PesoBruto='+ALLTRIM(TRANSFORM((xPESOLIQ),"@! 9999999999.999")) })

end

ENDIF
 


		If aFormaPagamento==1.and.nTela=="SAIDA"

 
			aadd(DADOS_NFe,{'[Fatura]' })
			aadd(DADOS_NFe,{'Numero='+str(m->CbdNtfNumero)})
			aadd(DADOS_NFe,{'ValorOriginal='+ALLTRIM(TRANSFORM((m->CbdvNF),"@! 9999999999.999"))})
				*ValorDesconto=
			aadd(DADOS_NFe,{'ValorLiquido='+ALLTRIM(TRANSFORM((m->CbdvNF),"@! 9999999999.999"))})
			
       		cQuery :="select pc,vencimento,valor from Parcelas where nrped="+str(nPedido)

			SQL_Error_oQuery()
			
            nQtd_Parcelas:=0
			For i := 1 To oQuery:LastRec()
				nQtd_Parcelas++
				oQuery:Skip(1)
			Next

			//nFrete_Parcelas:=mValor_Frete/nQtd_Parcelas
    		xDup:=1
			For i := 1 To oQuery:LastRec()
			    oRow := oQuery:GetRow(i)
 				nValor_da_Parcela:=oRow:fieldGet(3)///+nFrete_Parcelas
				 ano:= substr(dtos(oRow:fieldGet(2)),0,4)
				 mes:= substr(dtos(oRow:fieldGet(2)),5,2)
				 dia:= substr(dtos(oRow:fieldGet(2)),7,2)
                nDataVencimento:=dia+'/'+mes+'/'+ano

				aadd(DADOS_NFe,{'[Duplicata'+strzero(xDup,3)+']' })
				aadd(DADOS_NFe,{'Numero='+str(m->CbdNtfNumero)+'-'+oRow:fieldGet(1)})
				aadd(DADOS_NFe,{'DataVencimento='+nDataVencimento})
				aadd(DADOS_NFe,{'Valor='+ALLTRIM(TRANSFORM((nValor_da_Parcela),"@! 9999999999.999"))}) 
				xDup++
				oQuery:Skip(1)
			Next
 
		end
  		if !empty(mInformacoes_Complem)
            aadd(Obs_Nota,{99,mInformacoes_Complem})
	    endif

			M->CbdinfCpl :=''
			for i=1 to len(Obs_Nota)
				M->CbdinfCpl     := M->CbdinfCpl+' - '+Obs_Nota[i,2]
			next

 		 aadd(DADOS_NFe,{'[DadosAdicionais]' })
		 aadd(DADOS_NFe,{'Complemento='+RETIRAACENTO(alltrim(strtran(m->CbdinfCpl,[,],[]) ))})    

 
			handle:=fcreate(CurDrive()+":\mgi\NOTA.TXT")
			for i=1 to len(DADOS_NFe)
				fwrite(handle,alltrim(DADOS_NFe[i,1]))
				      fwrite(handle,chr(13)+chr(10))
			next
			fclose(handle)  

 

	splash_nfe(1,nTela ,nPedido,oArq,nCliente,nTipo_Emissao,str(mgSERIE_NFe),mModelo_NFe)


Return

// --------------------------------------------------------------------------.
FUNCTION splash_nfe(vsplash,nTela,nPedido,oArq,nCliente,nTipo_Emissao,nSerieNFe,nModelo)
// Fun‡Æo....: Gerar tela de splash -----------------------------------------.
local width := 600, height := 350
IF vsplash == 1  // Criar
	 
   DEFINE WINDOW janelasplash AT 5,5 WIDTH 600 HEIGHT 350 MODAL NOSIZE NOCAPTION ON INIT {|| parasplash(ntela,nPedido,oArq,nCliente,nTipo_Emissao,nSerieNFe,nModelo) }

   ON KEY ESCAPE OF NFe ACTION { ||if(nTela=="SAIDA",fechar_nfe(),),janelasplash.release }

   @ 1,1 IMAGE fundologo OF janelasplash PICTURE "NFe.JPG" WIDTH 598 HEIGHT 100 STRETCH


 		DRAW LINE IN WINDOW janelasplash ;
			AT 0, 0 TO 0, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW janelasplash ;
			AT Height, 0 TO Height, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW janelasplash ;
			AT 0, 0 TO Height, 0 ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW janelasplash ;
			AT 0, Width TO Height, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2 

        DEFINE LABEL lbindexa
               ROW    100
               COL    1
               WIDTH  598
               HEIGHT 197
			   	BACKCOLOR WHITE
               FONTNAME "Arial"
               FONTSIZE  9
		END LABEL  
 
		DRAW GRADIENT IN WINDOW janelasplash AT 297,1 TO 300,598;
                                          BORDER NONE ;
                                          BEGINCOLOR {130, 0, 0} ;
                                          ENDCOLOR {250, 0, 0}  
 
 
        DEFINE LABEL lb_2
               ROW    300
               COL    1
               WIDTH  598
               HEIGHT 49
               FONTNAME "Arial"
               FONTSIZE  7
			      value 'MGI Systens - Emissor de NF-e '
		END LABEL  
 
   END WINDOW
   janelasplash.show
  if nTela<>'NFCE' 
    CENTER WINDOW janelasplash
  end
   ACTIVATE WINDOW janelasplash
ELSE
   janelasplash.RELEASE
ENDIF
RETURN(NIL)
// Fim da fun‡Æo de gerar tela de splash ------------------------------------.

static FUNCTION parasplash(nTela,nPedido,oArq,nCliente,nTipo_Emissao,nSerieNFe,nModelo)
// Fun‡Æo....: Para a tela de splash ----------------------------------------.
 
////////[STATUS]////////////////////////
LOCAL S_Versao  :=""  //SVRS20101110174320
LOCAL S_TpAmb   :=""  //1
LOCAL S_VerAplic:=""  //SVRS20101110174320
LOCAL S_CStat   :=""  //107
LOCAL S_XMotivo :=""  //Servico em Operacao
LOCAL S_DhRecbto:=""  //29/03/2011 07:22:22
LOCAL S_TMed    :=""  //1
LOCAL S_DhRetorno:="" //30/12/1899
LOCAL S_XObs     :=""
///////FIM///////////////

//////[ENVIO]//////////////
LOCAL E_Versao  :=""  //SVRS20100210155347
LOCAL E_TpAmb   :="" //1
LOCAL E_VerAplic:="" //SVRS20100210155347
LOCAL E_CStat   :="" // 103
LOCAL E_XMotivo :="" //Lote recebido com sucesso
LOCAL E_NRec    :="" //113000263213135
LOCAL E_DhRecbto:="" //29/03/2011 07:22:35
LOCAL E_TMed    :="" //1
///////FIM///////////////

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
Local Ret_Status_Servico:=.t.
Local xJust:=''
Local cContingencia:=.f.
Local mCbdtpEmis:=1

Local ninfEventoId:=""  
local oLerDANFE := NIL // cria objeto leitura do danfe

                                                      
 		lRetorno_Internet:=IsInternet()
		if lRetorno_Internet==.f.
			xJust:="Sem acesso a Internet" 
		   Ret_Status_Servico:=.f.
   	else
//	 		lStatus:=ProcedureStatus() 	 
//			if lStatus==.f.
// 				xJust:="WebService Inativo ou Inoperante"
//			   Ret_Status_Servico:=.f.
//			end
 		end                 



 	 
		if nTela=="NFCE"
			if Ret_Status_Servico==.f.
				BEGIN INI FILE xPastaSistema+"\nota.txt"
				  SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
				  SET SECTION "Identificacao"  ENTRY "dhCont"  TO dtoc(dt_server)+hora_server ///contingencia para NFCe
				  SET SECTION "Identificacao"  ENTRY "xJust"  TO xJust ///contingencia para NFCe
				END INI
				MY_WAIT( 2 ) 
				BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
				  SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '1'
				END INI
			 	ProcedureLerINI()
				cContingencia:=.t.
				mCbdtpEmis:=9  ///contingencia para NFCe
			end                
		end
 
ERASE "C:\ACBrNFeMonitor\sainfe.txt"

if nTela=='CANCELA'
	   PUBLIC nnfe:="NFE"+alltrim((nPedido))
ELSE

   	PUBLIC nnfe:="NFE"+alltrim(str(m->CbdNtfNumero))
END


if nTela=='SAIDA'.or.nTela=='SELECAO'.or.nTela=='CUPOM'.or.nTela=='TRANSFERENCIA'.or.nTela=='BAIXA_ACOUGUE'.or.nTela=='ENTRADA_ACOUGUE'.or.nTela=='NFCE'.or.nTela=='PERDAS_ESTOQUE'.or.nTela=='DEVOLUCAO_COMPRAS'.or.nTela=='DEVOLUCAO_CUPOM'.or.nTela=='DEVOLUCAO_NFE'  ///envio de nota

 		cQuery:= "SELECT CbdProtocolo,CbdChave,CbddEmi,CbdMod FROM "+c_Tabela_NFe_ACBr +" where CbdMod='"+nModelo+"' and CbdNtfSerie="+str(nSerie_Nfe)+ " and CbdNtfNumero="+str(m->CbdNtfNumero-1) 
 		SQL_Error_oQuery()
		oRow:= oQuery:GetRow(1)
      if empty(oRow:fieldGet(1)).and.oQuery:LastRec()>0
      if oRow:fieldGet(1)=="55"
		MSGExclamation(PadC("*** ATENCAO ***",80)+QUEBRA+;
			   PadC("A última NF-e emitida está sem Protocolo de Autorização",80)+QUEBRA+;
			   PadC("O Sistema irá tentar resolver o problema. ",80)+QUEBRA+;
			   PadC("Aguarde!!!",80),SISTEMA)

           	ano:= substr(dtos(oRow:fieldGet(3) ),0,4)
				mes:= substr(dtos(oRow:fieldGet(3) ),5,2)

				ProcedureConsultaXML(oRow:fieldGet(2) )       
		end
		end
			oQuery:Destroy()
 
		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Criando Arquivo xml...Aguarde" 
		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Número NF-e :" +alltrim(str(m->CbdNtfNumero)) 
		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Modelo NF-e :" +mModelo_NFe 
		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Série  NF-e :" +m->CbdNtfSerie 

		cTXT:=CurDrive()+":\mgi\NOTA.TXT"

	   janelasplash.show
	   MY_WAIT( 3 ) 
		ERASE "C:\ACBrNFeMonitor\sainfe.txt"    
		ProcedureGeraXML(cTXT)
		              	
	
	   janelasplash.show
      xxxXML:=val(cCHAVE_XML)	
		if xxxXml<=0
		   msginfo('MG:001 - Não foi possível geral o XML')
		   return
		end
		cXML:=cSAIDA_XML
		ano:= YEAR(date()) 
		mes:= MONTH(date()) 
		ano:=str(Ano)  
   
      
 
		if cCHAVE_XML=NIL .or. empty(cCHAVE_XML)  .OR. LEN(cCHAVE_XML)<>44
		   msginfo('MG:002 - Não foi possível geral o XML')
		   janelasplash.RELEASE
		   return
		end
						   
 
      ffxml:=memoread(  "C:\ACBrNFeMonitor\"+cCHAVE_XML+"-nfe.xml" )
                

					
					MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Gravando Informações da NF-e..."
 
  		 
					cQuery:="INSERT INTO "+c_Tabela_NFe_ACBr+" (cbdempcodigo,CbdtpEmis,cbdntfnumero, cbdntfserie,Cbdmod,CbdtpNf,CbdfinNFe,CbdCHAVE ,"+;
					        "codcli,CbdCNPJ_dest,CbdxNome_dest,CbdxLgr_dest,CbdcMun_dest,"+;
							  "CbdxBairro_dest,CbdIE_dest,Cbdnro_dest,CbddEmi,"+;
							  "CbdindPag,CbdvBC_ttlnfe,CbdvICMS_ttlnfe,"+;
							  "CbdvBCST_ttlnfe,CbdvFrete_ttlnfe,CbdvST_ttlnfe,CbdvProd_ttlnfe,CbdvSeg_ttlnfe,"+;
							  "CbdvDesc_ttlnfe,CbdvII_ttlnfe,CbdvIPI_ttlnfe,CbdvPIS_ttlnfe,CbdvCOFINS_ttlnfe,CbdvOutro,"+;
							  "CbdvNF,CbdinfCpl,xml"+;
							  " ) "+;
						  "VALUES "+;
							  " ( '"+;
						     str(mgCODIGO)+ "'," +   str(mCbdtpEmis)+","+str(m->CbdNtfNumero)  + ",'" + m->CbdNtfSerie +"','"+mModelo_NFe+"','"+xCbdtpNf+"','"+mCbdfinNFe+"','"+ cCHAVE_XML + "','"+;
						     nCliente +"','"+limpa(mCNPJ_DESTINATARIO)+ "','" + mNome_Destinatario+ "','"+ mEnd_Destinatario+ "','" +(mCodMun_Destinatario)+"','"+;
							  mBairro_Destinatario+"','"+mInscricaoEstadual+"','"+mNumero_Destinatario+"','"+dtos(DATE())+"',"+  ;
							  str(aFormaPagamento)+","+str(nTotalBase)+","+str(nTotal_ICMS+nTotal_ICMS_Frete_por_ITem)+","+;
							  str(nTotal_BaseST)+","+str(mValor_Frete)+","+str(nICMS_ST)+","+str(nTotal_Itens)+","+str(mValor_Seguro)+","+;
							  str(mValor_Desconto)+",0,"+str(mValor_IPI)+","+str(nTotal_Pis)+","+str(nTotal_Cofins)+","+str(mValor_Despesas)+","+;
							  str(m->CbdvNF)+",'"+M->CbdinfCpl+"','"+alltrim(ffxml)+"'"+;
							   " ) "
 
					SQL_Error_oQuery()
					oQuery:Destroy()

				   if Retorno_SQL==.t.
					 
				      if mModelo_NFe = '55'
							cQuery:="UPDATE Pedidos SET nf="+STR(m->CbdNtfNumero)+" WHERE nrped="+str(nPedido)
						else
							cQuery:="UPDATE Pedidos SET cupom="+STR(m->CbdNtfNumero)+" WHERE nrped="+str(nPedido)
						end     
							SQL_Error_oQuery()
							oQuery:Destroy()
		 
		
							cQuery:="UPDATE PARCELAS SET requisicao='"+STRZERO(m->CbdNtfNumero,6)+"',exp_contabil=1 WHERE nrped="+str(nPedido)
							SQL_Error_oQuery()
							oQuery:Destroy()
		
							cQuery:="UPDATE recebidas SET requisicao='"+STRZERO(m->CbdNtfNumero,6)+"',exp_contabil=1 WHERE nrped="+str(nPedido)
							SQL_Error_oQuery()
							oQuery:Destroy()
		
							cQuery:="delete from CBD001det where cbdntfnumero="+str(m->CbdNtfNumero)+ " and cbdntfserie='" +m->CbdNtfSerie+"'"
							SQL_Error_oQuery()
							oQuery:Destroy()
 
					select Auxilia3 
						 go top
						 xxx:=1
						 nFrete_Item :=mValor_Frete
						 DO WHILE .NOT.EOF()


						 if Auxilia3->quant=0
							skip
							loop
						 end
						 
						 nx_taman := Len(Alltrim(Auxilia3->CODBARRA))
						 if nx_taman<>13
							nEAN:=''
						 end
						 
						If !ValidaEAN( Alltrim( Auxilia3->CODBARRA )).and.!empty(nEAN)
						   MSGINFO("Código de Barra do item "+ALLTRIM(Auxilia3->DESCRICAO)+" é invalido, Corriga o cadastro do item" )
							nEAN:= '' 
						else
							nEAN:= Auxilia3->CODBARRA
						Endif
					 
						 nCfop:=limpa(Auxilia3->CFOP)



					m->cst_piscof:=Auxilia3->cst_piscof
					if mgREGIME==3
						if empty(m->cst_piscof)
						   msginfo("cst_piscof em branco")
						   return
						end
						m->CbdCST_cofins       := val(m->cst_piscof)
						if m->cst_piscof=='01'.or.m->cst_piscof=='02' .or.m->cst_piscof=='03' 
							m->CbdvBC_cofins       := Auxilia3->TOTAL_UNIT
							m->CbdpCOFINS          := auxilia3->ALIQ_COFIN
							m->CbdvCOFINS          := (Auxilia3->TOTAL_UNIT*auxilia3->ALIQ_COFIN)/100
							m->CbdqBCProd_cofins   := Auxilia3->Quant
							m->CbdvAliqProd_cofins := auxilia3->ALIQ_COFIN
								m->CbdpPIS          := auxilia3->ALIQ_PIS
								m->CbdvPIS          := (Auxilia3->TOTAL_UNIT*auxilia3->ALIQ_PIS  )/100
						elseif m->cst_piscof=='06' 
							m->CbdCST_cofins      := 06
							m->CbdvBC_cofins      := 0
							m->CbdpCOFINS         := 0
							m->CbdvCOFINS         := 0
							m->CbdqBCProd_cofins  := 0
							m->CbdvAliqProd_cofins:= 0
								m->CbdpPIS         := 0
								m->CbdvPIS         := 0
						else
							m->CbdCST_cofins      := 07
							m->CbdvBC_cofins      := 0
							m->CbdpCOFINS         := 0
							m->CbdvCOFINS         := 0
							m->CbdqBCProd_cofins  := 0
							m->CbdvAliqProd_cofins:= 0
								m->CbdpPIS         := 0
								m->CbdvPIS         := 0
						end
					else
						m->CbdCST_cofins      := 07
						m->CbdvBC_cofins      := 0
						m->CbdpCOFINS         := 0
						m->CbdvCOFINS         := 0
						m->CbdqBCProd_cofins  := 0
						m->CbdvAliqProd_cofins:= 0
								m->CbdpPIS         := 0
								m->CbdvPIS         := 0
					end

				 

						 nFrete_Item:=auxilia3->BASE_ICMS*(nPercentual_Frete_Item/100)
						 
						 cQuery:="INSERT INTO CBD001det  (cbdempcodigo, cbdntfnumero,cbdntfserie,Cbdmod,CbdnItem,"+;
								"CbdcProd,CbdcEAN,CbdcEANTrib ,CbdxProd,CbdNCM,CbdEXTIPI,Cbdgenero,CbdIndTot,"+;
								"CbdCFOP,CbduCOM,CbdqCOM,CbdvUnCom,"+;
								"CbdvProd,CbduTrib,CbdqTrib,CbdvAliqProd,"+;
								"CbdvUnTrib,CbdnTipoItem,CbdvDesc,"+;
								"CbdCST_cofins,CbdvBC_cofins,CbdpCOFINS,"+;
								"CbdvCOFINS,"+;
								"CbdpPIS,"+;
								"CbdvPIS,"+;
								"CbdvBCICMS,"+;
								"CbdvICMS,"+;
								"CbdcSitTrib,CbdvFrete,CbdCST_icms,CbddEmi "+;
								" ) "+;
							"VALUES "+;
								" ( "+;
								str(mgCODIGO)+ "," + str(m->CbdNtfNumero)+ ",'" +m->CbdNtfSerie +"','"+mModelo_NFe+"',"+str(xxx)+ ",'" +;
								Auxilia3->Codigo+ "','" +nEAN+ "','" +nEAN+"','"+alltrim(limpa_aspas(Auxilia3->DESCRICAO))+"','"+limpa(Auxilia3->ncm)+"','',0,1,"+;
								nCfop+ ",'" +Auxilia3->UNID+ "'," +str(Auxilia3->Quant)+ "," +str(Auxilia3->Unit)+ "," +;
								str(Auxilia3->Quant*Auxilia3->Unit)+ ",'" +Auxilia3->UNID+ "',"+str(Auxilia3->Quant)+ "," +str(auxilia3->alicota)+ "," +;
								str(Auxilia3->Unit-(Auxilia3->valdes/Auxilia3->Quant))+ ",0," +str(Auxilia3->valdes)+ ","+;
								str(m->CbdCST_cofins)+ "," +str(m->CbdvBC_cofins)+ "," +str(m->CbdpCOFINS)+ "," +;
								str(m->CbdvCOFINS)+ "," +;
								str(m->CbdpPIS)+ "," +;
								str(m->CbdvPIS)+ "," +;
								str(auxilia3->BASE_ICMS+nBase_Frete_Item)+ "," +;
								str((auxilia3->BASE_ICMS+nBase_Frete_Item)*(auxilia3->alicota/100))+ "," +;
								"'I',"+str(mValor_Frete)+ ",'" +;
								Auxilia3->cst+"','"+dtos(date())+"'"+;
								" ) "
 
								mValor_Frete:=0

							SQL_Error_oQuery()
							oQuery:Destroy()
					

					nFrete_Item  :=0
					Icms_Frete   :=0
			  xxx++
			  select Auxilia3
			  skip
		enddo
		else
			return
		endif ////fim do IF Retonro_SQL Verdadeiro
 	
		IF FILE("C:\ACBrNFeMonitor\"+alltrim(Ano)+strzero(Mes,2)+"\NFe\"+cCHAVE_XML+"-nfe.xml")
			MSGINFO('ATENÇÃO...Já existe um XML gerado para este número de nota. ')
			janelasplash.release
				if  nTela=="SAIDA"
					fechar_nfe()
				end
			return
		END
		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Arquivo xml gerado com sucesso..." 

 
			   
		ERASE "C:\ACBrNFeMonitor\sainfe.txt"
		if cContingencia==.f.
			
		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Enviando Arquivo..." 
					  	 	ProcedureEnviarXML( cXML )
						  	 	
						      if cEnvio_XML==.f.                                                                               
						         return
								end
									cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'
									lRetStatus:=EsperaResposta(cDestino) 
							      if lRetStatus==.t.
					      
										MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+" Aguardando Retorno SEFAZ..."+chr(13)+chr(10)
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
									   janelasplash.show
									else
										MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+"  Erro na leitura do arquivo!!!, ESC para Retornar" 
									end
	
						    	MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' +janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Retorno: "+R_XMotivo
							
								IF R_CStat<>'100'

									MSGINFO("Ret: "+R_XMotivo)
									janelasplash.RELEASE
									if  nTela=="SAIDA"
										fechar_nfe()
									end

								END
 
			if R_CStat=='100'
		

					ffxml:=memoread( cXML )
 
		    		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' +janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Gravando Retorno da NF-e..."
					cQuery:="update "+c_Tabela_NFe_ACBr+" set CBDProtocolo='"+;
							C_NPROT+"',CbdStatus='"+R_XMotivo+"',xml='" +alltrim(ffxml)+"' where cbdntfnumero="+str(m->CbdNtfNumero) +" and cbdntfserie='"+m->CbdNtfSerie +"' and cbdMod='"+nModelo+"'"
							
					SQL_Error_oQuery()
					oQuery:Destroy()

 	
	
							If nTela=="SAIDA" .OR. nTela=="NFCE"
							    
								if  nTela="NFCE".and. mgIMPRIMIR_NFCe==.T.  
												/// Montar Hash QR Code
												sCodigoHASH_NFCe:=Gera_Codigo_HASH_NFCe(c_ChNFe,mCNPJ_DESTINATARIO,R_DhRecbto,m->CbdvNF,(nTotal_ICMS+nTotal_ICMS_Frete_por_ITem),R_DigVal)
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Numero "+strzero(m->CbdNtfNumero,9)+" Série "+strzero(val(m->CbdNtfSerie),3)+" Emissão "+dtoc(dt_server)+hora_server+"</c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>Consulta pela Chave de Acesso em</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp<c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CHAVE DE ACESSO</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>"+c_ChNFe+"</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CONSUMIDOR</b></ce>"})
								 		   if !empty(LIMPA(mCNPJ_DESTINATARIO))
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>CNPJ/CPF/ID Estrangeiro: "+mCNPJ_DESTINATARIO+"</ce>"})
								 		   else
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>CONSUMIDOR NAO IDENTIFICADO</ce>"})    
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>SEM NUMERO</ce>"})
								 			end
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Consulta Via Leitor de QR Code</c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><qrcode><lmodulo>3</lmodulo>"+sCodigoHASH_NFCe+"</qrcode></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Protocolo Autorização "+c_NProt+" "+c_DhRecbto+"</c></ce><sl>4</sl><gui></gui><l></l>"})
		
		 								      	cTXT:=''
													for i=1 to len(DADOS_IMPRESSAO_NFCE)
													   cTXT+= alltrim(DADOS_IMPRESSAO_NFCE[i,1])+chr(13)+chr(10)
													next
													
													cQuery:="update "+c_Tabela_NFe_ACBr+" set TXT='" +cTXT+"' where cbdntfnumero="+str(m->CbdNtfNumero) +" and cbdntfserie='"+m->CbdNtfSerie +"' and cbdMod='"+nModelo+"'"
															
										 
													SQL_Error_oQuery()
													oQuery:Destroy()
								end
	
										IF E_CStat=='103'
										
										cQuery:= "SELECT MAX(CbdNtfNumero) AS Numero FROM "+c_Tabela_NFe_ACBr+" where CbdMod="+nModelo+" and CbdNtfSerie="+str(nSerie_Nfe)
					
										SQL_Error_oQuery()
					
										oRow:= oQuery:GetRow(1)
										m->CbdNtfNumero :=oRow:fieldGet(1)+1
										oQuery:Destroy()
					
					 
														IF m->CbdNtfNumero==0
														cQuery:="INSERT INTO "+c_Tabela_NFe_ACBr+" (cbdempcodigo,CbdtpEmis,cbdntfnumero, cbdntfserie,Cbdmod,CbdCHAVE ,CBDProtocolo,CbdStatus,codcli,CbdxNome_dest,CbddEmi,"+;
																  "CbdvBC_ttlnfe,CbdvICMS_ttlnfe,"+;
																  "CbdvBCST_ttlnfe,CbdvFrete_ttlnfe,CbdvST_ttlnfe,CbdvProd_ttlnfe,CbdvSeg_ttlnfe,"+;
																  "CbdvDesc_ttlnfe,CbdvII_ttlnfe,CbdvIPI_ttlnfe,CbdvPIS_ttlnfe,CbdvCOFINS_ttlnfe,CbdvOutro,"+;
																  "CbdvNF,CbdinfCpl"+;
																  " ) "+;
															  "VALUES "+;
																  " ( '"+;
																  str(mgCODIGO)+ "'," +  str(mCbdtpEmis)+","+ str(m->CbdNtfNumero)   + ",'" + m->CbdNtfSerie + "','"+mModelo_NFe+"','" + c_ChNFe + "','" +C_NPROT+ "','" +R_XMotivo + "','"+ nCliente + "','" + mNome_Destinatario+ "','"+dtos(DATE())+"',"+  ;
																  str(nTotalBase)+","+str(nTotal_ICMS+nTotal_ICMS_Frete_por_ITem)+","+;
																  str(nTotal_BaseST)+","+str(mValor_Frete)+","+str(nICMS_ST)+","+str(nTotal_Itens)+","+str(mValor_Seguro)+","+;
																  str(mValor_Desconto)+",0,"+str(mValor_IPI)+",0,0,"+str(mValor_Despesas)+","+;
																  str(m->CbdvNF)+",'"+M->CbdinfCpl+"'"+;
																   " ) "
											 
														SQL_Error_oQuery()
														oQuery:Destroy()
								
														END
					
										END
										IF !empty(cEmail)
									    	REENVIAR_NFe_ACBr( str(m->CbdNtfNumero),nCliente,2  )
										end 
										
										///imprimir NF-e
										IF nTela<>"NFCE" 
									   	ProcedureEmitirDANFE( cXML )
											if  nTela=="SAIDA"
												fechar_nfe()
											end
									   	
			   						end
			
										///imprimir NFC-e	
	 									iF nTela=="NFCE" .and. mgIMPRIMIR_NFCe==.T. 
							
									   //   ATUALIZA_BROWSE_MANUTENCAO_PEDIDOS()
										ELSE
									   	ProcedureEmitirDANFE( cXML )
									      ATUALIZA_BROWSE_MANUTENCAO_PEDIDOS()
										END	
								 
			
									If  nTela=="SAIDA".or.nTela=='TRANSFERENCIA'
									    ATUALIZA_BROWSE_MANUTENCAO_NFE()
									    ATUALIZA_BROWSE_MANUTENCAO_PEDIDOS()
         						end

 
					
else  ///NOTA PELA SELECAO
					
					
									      IF E_CStat=='103'
											
									 		cQuery:= "SELECT MAX(CbdNtfNumero) AS Numero FROM "+c_Tabela_NFe_ACBr+" where CbdMod="+nModelo+"  CbdNtfSerie="+str(nSerie_Nfe)
									
											SQL_Error_oQuery()
									
											oRow:= oQuery:GetRow(1)
									        m->CbdNtfNumero :=oRow:fieldGet(1)+1
											oQuery:Destroy()
											
									 
									
												IF m->CbdNtfNumero==0
												cQuery:="INSERT INTO "+c_Tabela_NFe_ACBr+" (cbdempcodigo,CbdtpEmis,cbdntfnumero, cbdntfserie,Cbdmod,CbdCHAVE ,CBDProtocolo,CbdStatus,CbdxNome_dest,CbddEmi,"+;
														  "CbdvBC_ttlnfe,CbdvICMS_ttlnfe,"+;
														  "CbdvBCST_ttlnfe,CbdvFrete_ttlnfe,CbdvST_ttlnfe,CbdvProd_ttlnfe,CbdvSeg_ttlnfe,"+;
														  "CbdvDesc_ttlnfe,CbdvII_ttlnfe,CbdvIPI_ttlnfe,CbdvPIS_ttlnfe,CbdvCOFINS_ttlnfe,CbdvOutro,"+;
														  "CbdvNF,CbdinfCpl"+;
														  " ) "+;
													  "VALUES "+;
														  " ( '"+;
													  str(mgCODIGO)+ "'," +str(mCbdtpEmis)+","+ str(m->CbdNtfNumero) + ",'" + m->CbdNtfSerie + "','"+mModelo_NFe+"','" + cCHAVE_XML + "','" +R_NProt+ "','" +R_XMotivo + "','" + mNome_Destinatario+ "','"+dtos(DATE())+"',"+  ;
														  str(nTotalBase)+","+str(nTotal_ICMS+nTotal_ICMS_Frete_por_ITem)+","+;
														  str(nTotal_BaseST)+","+str(mValor_Frete)+","+str(nICMS_ST)+","+str(nTotal_Itens)+","+str(mValor_Seguro)+","+;
														  str(mValor_Desconto)+",0,"+str(mValor_IPI)+",0,0,"+str(mValor_Despesas)+","+;
														  str(m->CbdvNF)+",'"+M->CbdinfCpl+"'"+;
														   " ) "
									 
												SQL_Error_oQuery()
												oQuery:Destroy()
									
												END
									
											END
									

											IF !empty(cEmail)
										            REENVIAR_NFe_ACBr( str(m->CbdNtfNumero),nCliente,2  )
											end      		

												ProcedureEmitirDANFE( cXML )
												
									If nTela=='BAIXA_ACOUGUE'
											cQuery:="UPDATE it_comp SET emite_nota_baixa=1 WHERE nrped="+str(nPedido)+" and item="+str(nItem)
											SQL_Error_oQuery()  
											oQuery:Destroy()

								  			cQuery:="select cod_item,quant from it_comp WHERE nrped="+str(nPedido)+" and item="+str(nItem)
											SQL_Error_oQuery()  
									 	   oRow := oQuery:GetRow(1)
											cCodigo_Item:=oRow:fieldGet(1) 
											cQtd_Item:=oRow:fieldGet(2) 
											oQuery:Destroy() 

								  			cQuery:="update produtos set saldo=saldo-"+str(cQtd_Item)+" where id_produto='"+alltrim(cCodigo_Item)+"'"
											SQL_Error_oQuery()
											oQuery:Destroy() 
									      desabilita_botao_nota_baixa()

									ELSEIf nTela=='ENTRADA_ACOUGUE'
											cQuery:="UPDATE it_comp SET emite_nota_ent=1 WHERE nrped="+str(nPedido)+" and item="+str(nItem)
											SQL_Error_oQuery()  
											oQuery:Destroy()

									      desabilita_botao_nota_entrada()
									      
									elseIf nTela=='TRANSFERENCIA'
											cQuery:= "select codcli FROM transferencias WHERE lancamento="+str(nPedido)   
											SQL_Error_oQuery()
											oRow:= oQuery:GetRow(1)
											cCodCliente:=oRow:fieldGet(1)

											cQuery:= "select sum(quant*unit) FROM it_orcam WHERE nrped="+str(nPedido)   
											SQL_Error_oQuery()
											oRow:= oQuery:GetRow(1)
											nTotal_Tansferencia:=oRow:fieldGet(1)

											cQuery:="UPDATE transferencias SET nf="+STR(m->CbdNtfNumero)+",valor="+str(nTotal_Tansferencia)+",status='FECHADO' WHERE lancamento="+str(nPedido)
											SQL_Error_oQuery()
											oQuery:Destroy()
											
 							       
 							       
 							       	   w_codvenda := wn_geracontvenda()
											     
											cQuery:="UPDATE transferencias SET nrped="+STR(w_codvenda)+" WHERE lancamento="+str(nPedido)
											SQL_Error_oQuery()
											oQuery:Destroy()

											cQuery:= "select Cod_item,descr_item,unidade,quant,unit,item FROM tmp_itens where nrped="+str(nPedido)
											oQuery_Item:=oServer:Query( cQuery )
											If oQuery_Item:NetErr()												
											   MsgStop(oQuery_Item:Error())
											   Return .f.
											End 
											
												  For i := 1 To oQuery_item:LastRec()
												  oRow := oQuery_item:GetRow(i) 
											     nSub_Total := oRow:fieldGet(5)*oRow:fieldGet(4)
									  	         select_Produto(oRow:fieldGet(1),1)
													cQuery := "INSERT INTO It_Pedid (NRPED,ITEM,COD_ITEM,DESCR_ITEM,UNIDADE,"+;
															  "CODCLI,EMISSAO,QUANT,"+;
															  "UNIT,SALDO,"+;
															  "hora,status ) "+; 
															  "VALUES "+;
															  "("+str(w_codvenda)+","+str(oRow:fieldGet(6))+",'"+(oRow:fieldGet(1))+"','"+alltrim(limpa_string(oRow:fieldGet(2)))+"','"+(limpa_string(oRow:fieldGet(3)))+"','"+;
															  cCodCliente+"','"+dtos(dt_server)+"',"+STR(oRow:fieldGet(4))+","+;
															  STR(oRow:fieldGet(5))+","+STR(xSaldo_Item-oRow:fieldGet(4))+",'"+;
															  hora_server+"','T')" 
															SQL_Error_oQuery()
															oQuery:Destroy()

															if Retorno_SQL==.t.
																cQuery:="update produtos set saldo=saldo-"+str(oRow:fieldGet(4))+",dt_alt_venda='"+dtos(dt_server)+"' where id_produto='"+oRow:fieldGet(1)+"'"
										                 
																SQL_Error_oQuery()
																oQuery:Destroy()
															else
																msginfo('Não foi possível fazer a atualização do estoque.')
															end
									
													     oQuery_item:Skip(1)
													Next
													     oQuery_item:Destroy()
 							       

											
											Espelho_NFe_RELEASE()
											SAIR_JANELA_TRANSFERENCIAS()
											
											
											
									else
												Gravar_Dados_Venda :=.t.   
												 
														for j=1 to len(_Pedidos)
															nPedido:=_Pedidos[j,1]
										
															cQuery:="UPDATE PARCELAS SET requisicao='"+STRZERO(m->CbdNtfNumero,6)+"',exp_contabil=1 WHERE nrped="+str(nPedido)
															SQL_Error_oQuery()
															oQuery:Destroy()

															cQuery:="UPDATE recebidas SET requisicao='"+STRZERO(m->CbdNtfNumero,6)+"',exp_contabil=1 WHERE nrped="+str(nPedido)
															SQL_Error_oQuery()
															oQuery:Destroy()
										
															cQuery:="UPDATE Pedidos SET nf="+STR(m->CbdNtfNumero)+" WHERE nrped="+str(nPedido)
															SQL_Error_oQuery()
															oQuery:Destroy()
														
														next
										
														
														for j=1 to len(_Pedidos)
														nPedido:=_Pedidos[j,1]
										
														Sele Parcelas_Temp
															Parcelas_Temp->(DBGoTop())
															DO WHILE !Parcelas_Temp->(EOF())
																IF Parcelas_Temp->nrped==nPedido
																	netuse()
																	Parcelas_Temp->requisicao:=STRZERO(m->CbdNtfNumero,6)
																	Parcelas_Temp->(DBUNLOCK())
																	Parcelas_Temp->(DBCOMMIT())
																ENDIF
															SELECT Parcelas_Temp
															skip
															ENDDO
										
														next
										        
												If nTela=="SELECAO" .or.  nTela=="PERDAS_ESTOQUE"  .or.nTela=='DEVOLUCAO_CUPOM'.or.nTela=='DEVOLUCAO_NFE' 
													Espelho_NFe_RELEASE()
												END

									EndIf
					
	end
							
							   sele auxilia3			 
							   auxilia3->(__DBZAP())
							
								janelasplash.release   
							

 
	  	   
		 
	  Endif
										        
												If  nTela=="BAIXA_ACOUGUE" .or.nTela=="ENTRADA_ACOUGUE"
													Espelho_NFe_RELEASE()
												END


									If  nTela=="PERDAS_ESTOQUE" 
									    ATUALIZA_BROWSE_PERDAS()
         						end

									If  nTela=="DEVOLUCAO_COMPRAS" 
										 ATUALIZA_BROWSE_DEVOLUCOES()
									    fechar_nfe()
         						end

									If  nTela=='DEVOLUCAO_CUPOM'.or.nTela=='DEVOLUCAO_NFE' 
										 FECHA_TELA_DEVOLUCOES()
         						end

	EndIf /// fim do IF para modo de emissao normal
	
						sCodigoHASH_NFCe:=Gera_Codigo_HASH_NFCe(cCHAVE_XML,mCNPJ_DESTINATARIO,R_DhRecbto,m->CbdvNF,(nTotal_ICMS+nTotal_ICMS_Frete_por_ITem),R_DigVal)
	
 						if cContingencia==.t.	

				      // criamos o objeto  
				      oLerDANFE := TLerDANFE():novo()
				       
 
				      // vamos jogar esta variavel na PROPRIEDADE do objeto
				      oLerDANFE:FileDanfe  		 := cSAIDA_XML

				      // usamos o MÉTODO DE PESQUISA POR CNPJ e conferimos o seu retorno
				      if oLerDANFE:LeDANFE(  )
					      // após recuperar os dados, vamos mostrar as PROPRIEDADES DO OBJETO EMRPESA
				         mCNPJ_DESTINATARIO	:= ''
				         R_DigVal					:= oLerDANFE:DigestValue
				         R_DhRecbto				:= strtran(strtran(oLerDANFE:DATA,[T],[ ]),[-04:00],[])
				      end
   
 
						    		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' +janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Imprimindo NFC-e...AGUARDE "
								if  nTela="NFCE".and. mgIMPRIMIR_NFCe==.T.  
												/// Montar Hash QR Code
												sCodigoHASH_NFCe:=Gera_Codigo_HASH_NFCe(cCHAVE_XML,mCNPJ_DESTINATARIO,R_DhRecbto,m->CbdvNF,(nTotal_ICMS+nTotal_ICMS_Frete_por_ITem),R_DigVal)
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>EMITIDA EM AMBIENTE DE CONTINGENCIA</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Numero "+strzero(m->CbdNtfNumero,9)+" Série "+strzero(val(m->CbdNtfSerie),3)+" Emissão "+dtoc(dt_server)+hora_server+"</c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>Consulta pela Chave de Acesso em</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp<c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CHAVE DE ACESSO</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>"+cCHAVE_XML+"</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>CONSUMIDOR</b></ce>"})
								 		   if !empty(LIMPA(mCNPJ_DESTINATARIO))                                                              
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>CNPJ/CPF/ID Estrangeiro: "+mCNPJ_DESTINATARIO+"</ce>"})
								 		   else
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>CONSUMIDOR NAO IDENTIFICADO</ce>"})    
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce>SEM NUMERO</ce>"})
								 			end
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Consulta Via Leitor de QR Code</c></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><qrcode><lmodulo>3</lmodulo>"+sCodigoHASH_NFCe+"</qrcode></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><b>------------------------------------------------</b></ce>"})
										 		aadd(DADOS_IMPRESSAO_NFCE,{"<ce><c>Protocolo Autorização "+c_NProt+" "+c_DhRecbto+"</c></ce><sl>4</sl><gui></gui><l></l>"})
		 								      	cTXT:=''
													for i=1 to len(DADOS_IMPRESSAO_NFCE)
													   cTXT+= alltrim(DADOS_IMPRESSAO_NFCE[i,1])+chr(13)+chr(10)
													next
													cQuery:="update "+c_Tabela_NFe_ACBr+" set TXT='" +cTXT+"' where cbdntfnumero="+str(m->CbdNtfNumero) +" and cbdntfserie='"+m->CbdNtfSerie +"' and cbdMod='"+nModelo+"'"
															
										 
													SQL_Error_oQuery()
													oQuery:Destroy()

								end
										///imprimir NFC-e	
										
	 									iF nTela=="NFCE" .and. mgIMPRIMIR_NFCe==.T. 
										 iImprimirTexto_DUAL_DarumaFramework(cTXT)
									    ATUALIZA_BROWSE_MANUTENCAO_PEDIDOS()
										ELSE
									    ProcedureEmitirDANFE( cXML )
									    ATUALIZA_BROWSE_MANUTENCAO_PEDIDOS()
										END	
//					MY_WAIT( 2 ) 
					BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
					  SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '0'
					END INI                   
				 	ProcedureLerINI()
				   janelasplash.release
					EndIf
	
elseif nTela=='CANCELA' /// cancelamento de nota
   if nModelo==1
   	cModelo:='55'
   else
   	cModelo:='65'
   end
	MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+"Enviando Pedido de Cancelamento..."+chr(13)+chr(10)

			cQuery:= "SELECT CbdCHAVE,CbddEmi,codcli,CbdNtfSerie FROM "+c_Tabela_NFe_ACBr+" WHERE CbdNtfNumero="+nPedido+" and cbdntfserie='" +nSerieNFe+"' and cbdMod='"+cModelo+"'"
			SQL_Error_oQuery()
			oRow:= oQuery:GetRow(1)
			m->CHAVE :=oRow:fieldGet(1) 
			nCliente:=oRow:fieldGet(3) 
			nNFe := (nPedido)
			nnSerieNFe := oRow:fieldGet(4)
			oQuery:Destroy()

	IF empty(m->CHAVE)
	    msginfo('NF-e não cadastrada na base de dados...')
		janelasplash.release
		RETURN
	END

	if len(m->chave)<44
	    msginfo('Chave Inválida...')
		janelasplash.release
		RETURN
	end
	 
	
	ano:= substr(dtos(oRow:fieldGet(2) ),0,4)
	mes:= substr(dtos(oRow:fieldGet(2) ),5,2)
  
   ERASE "C:\ACBrNFeMonitor\sainfe.txt"

	ProcedureCancelarXML(m->chave)

   if nModelo==1
		cFileSaida := "C:\ACBrNFeMonitor\"+m->chave+"11011101-procEventoNFe.XML"
	else
		cFileSaida := "C:\ACBrNFeMonitor\"+m->chave+"11011101-procEventoNFe.XML"
	end
	xml_cancelamento:=memoread(  cFileSaida  )

	if c_Ret_Cancelamento="Evento registrado e vinculado a NF-e"


   ffxml:=memoread(  x_Diretorio+"\"+Ano+Mes+"\NFe\"+m->CHAVE+"-nfe.xml" )
        
		cQuery:="UPDATE "+c_Tabela_NFe_ACBr+" SET CbdfinNFe=2,xml_can='"+xml_cancelamento+"',CBDPROTOCOLO='"+c_Prot_Cancelamento+"',CBDStatus='Cancelamento de NF-e homologado',xml='" +alltrim(ffxml)+"' WHERE CbdNtfNumero="+nPedido+" and cbdntfserie='" +nSerieNFe+"' and cbdMod='"+cModelo+"'"
		SQL_Error_oQuery()
		oQuery:Destroy()


				//--->>>consulta se foi cancelado
				ProcedureConsultaXML(m->CHAVE)
/*			 	
			 	if alltrim(Mensagem_Retorno_Consulta)="Cancelamento de NF-e homologado".or.alltrim(Mensagem_Retorno_Consulta)="Autorizado o uso da NF-e"
			    ffxml:=memoread(  x_Diretorio+"\"+Ano+Mes+"\NFe\"+m->CHAVE+"-nfe.xml" )
			                 
			 		cQuery:="UPDATE "+c_Tabela_NFe_ACBr+" SET CBDStatus='"+Mensagem_Retorno_Consulta+"',CBDProtocolo='"+Protocolo_Retorno_Consulta+"',xml='" +alltrim(ffxml)+"' WHERE CbdNtfNumero="+nNFe+" and cbdntfserie='"+nnSerieNFe  +"' and cbdMod='"+cModelo+"'"
					SQL_Error_oQuery()
					oQuery:Destroy()

			 		cQuery:="delete from cbd001det WHERE CbdNtfNumero="+nNFe+" and cbdntfserie='"+nnSerieNFe + "'"
					SQL_Error_oQuery()
					oQuery:Destroy()
					
					MSGINFO(Mensagem_Retorno_Consulta)
				else
			  	MSGINFO(Mensagem_Retorno_Consulta)
				end
*/	
 		cQuery:="SELECT email FROM clientes WHERE codcli='"+ncliente+"'"

		SQL_Error_oQuery()

		oRow:= oQuery:GetRow(1)
      cEmail :=oRow:fieldGet(1) 
		oQuery:Destroy()

		
	IF !empty(cEmail).and. !empty(mgusuario_email)
			 _smtp    :=mgsmtp_nfe
			 _emai_   :="Cancelamento de NF-e Homologado e vinculado a Nota"
			 _usuario :=mgusuario_email
			 _senha   :=mgsenha_email
			 _id      :=mgusuario_email
			 _de      :=SUBSTR(mgFANTASIA, 1,25) 
			 _assunto_:="CANCELAMENTO NF-e "+m->CHAVE+".XML"
			 _para_   :=cEmail
   		if nModelo==1
		 	 _anexo_  :="C:\ACBrNFeMonitor\"+m->chave+"11011101-procEventoNFe.XML"
	 	 	else
		 	 _anexo_  :="C:\ACBrNFeMonitor\"+m->chave+"11011101-procEventoNFe.XML"
	 	 	end
			 _autentica := .T.
			 
			EnviaEmail_(_smtp, _id, _de, _para_, _assunto_, _emai_, _anexo_, _usuario, _senha )
	end
		 
		   if nModelo==1
		        ProcedureImprimirEvento(m->CHAVE+"11011101-procEventoNFe.XML") 
			else
		        ProcedureImprimirEvento(m->CHAVE+"11011101-procEventoNFe.XML") 
			end
  
	else

  	MSGINFO("Ret: "+c_Ret_Cancelamento)
    end
	Janelasplash.RELEASE
	
    ATUALIZA_BROWSE_MANUTENCAO_NFE()

end


RETURN(NIL)
// Fim da fun‡Æo de para a tela de splash -----------------------------------.
// --------------------------------------------------------------------------.
  

// Fim da fun‡Æo de para a tela de splash -----------------------------------.
// --------------------------------------------------------------------------.
FUNCTION CANCELA_NFe_ACBR(nNF)
 
  DEFINE WINDOW CANCELA_NFe AT 251 , 397 WIDTH 540 HEIGHT 220 MODAL NOSIZE  FONT "Times New Roman" SIZE 11
		 ON KEY ESCAPE OF CANCELA_NFe ACTION {|| CANCELA_NFe.RELEASE}

     DEFINE LABEL Label_1
            ROW    30
            COL    20
            WIDTH  120
            HEIGHT 24
            VALUE "Modelo da Nota"
            RIGHTALIGN .T.
     END LABEL
	    
     DEFINE COMBOBOX cbtabela 
            ROW    30
            COL    160
            WIDTH  200
            HEIGHT 150
            ITEMS  {'55-NF-e','65-NFC-e'}
     END COMBOBOX  

     DEFINE LABEL Label_numero
            ROW    60
            COL    20
            WIDTH  125
            HEIGHT 24
            VALUE "Número NF-e/NFC-e"
            RIGHTALIGN .T.
     END LABEL  

     DEFINE LABEL Label_2
            ROW    90
            COL    20
            WIDTH  120
            HEIGHT 24
            VALUE "Série NF-e/NFC-e"
            RIGHTALIGN .T.
     END LABEL  

     DEFINE TEXTBOX Txt_NUMERO_NFe
            ROW    60
            COL    160
            WIDTH  120
            HEIGHT 24
            INPUTMASK "999999999"
            NUMERIC .T.
     END TEXTBOX 

     DEFINE TEXTBOX Txt_SERIE_NFe
            ROW    90
            COL    160
            WIDTH  120
            HEIGHT 24
            INPUTMASK "999"
 	         ON ENTER { || ENVIA_CANCELAMENTO( )	  }
     END TEXTBOX 

	 DEFINE BUTTONEX ButtonEX_2
            ROW    110
            COL    360
            WIDTH  151
            HEIGHT 55
            CAPTION "&Ok"
            PICTURE "img_ok"
 	         ACTION { || ENVIA_CANCELAMENTO( )	   }
     END BUTTONEX  

END WINDOW
   CANCELA_NFe.cbtabela.setfocus
	CENTER WINDOW CANCELA_NFe
	ACTIVATE WINDOW CANCELA_NFe

RETURN .T.
//-----------------------------------------------------

FUNCTION ENVIA_CANCELAMENTO()
PUBLIC Ret_Status_Servico:=''
NFe_ATV( )
if CANCELA_NFe.cbtabela.VALUE==0
	msginfo('Favor informar o modelo da Nota Fiscal')
   CANCELA_NFe.cbtabela.setfocus
	return
else
CANCELA_NFe.release
end
splash_nfe(1,'CANCELA',ALLTRIM(STR(CANCELA_NFe.Txt_NUMERO_NFe.VALUE)),'','',0,CANCELA_NFe.Txt_SERIE_NFe.VALUE,CANCELA_NFe.cbtabela.VALUE)

RETURN


FUNCTION VISUALIZAR_NFe_ACBr( nNFe  )
 
 		cQuery:="SELECT CbdCHAVE,CbddEmi,CbdNtfSerie FROM "+c_Tabela_NFe_ACBr+" WHERE CbdNtfNumero="+nNFe

		SQL_Error_oQuery()

		oRow:= oQuery:GetRow(1)
      m->CHAVE :=oRow:fieldGet(1) 
		m->emissao:=oRow:fieldGet(2)
		nSerieNFe:=oRow:fieldGet(3)
		oQuery:Destroy()


IF empty(m->CHAVE)
    msginfo('Nota Fiscal não Localizada...')
	RETURN
END

 ano:= substr(dtos(m->emissao),0,4)
 mes:= substr(dtos(m->emissao),5,2)
 
 
 ProcedureEmitirDANFE( x_Diretorio+"\"+Ano+Mes+"\NFe\"+m->CHAVE+"-nfe.xml",m->CHAVE )
 

RETURN .T.


FUNCTION REENVIAR_NFe_ACBr( nNFe,nCliente,nTela  )


if nTela<>1
*	return
end
 
 		cQuery:="SELECT CbdCHAVE,CbddEmi FROM "+c_Tabela_NFe_ACBr+" WHERE CbdNtfNumero="+nNFe

		SQL_Error_oQuery()

		oRow:= oQuery:GetRow(1)
      m->CHAVE :=oRow:fieldGet(1) 
		m->emissao:=oRow:fieldGet(2)
		oQuery:Destroy()


IF empty(m->CHAVE)
    msginfo('Nota Fiscal não Localizada...')
	RETURN
END

 ano:= substr(dtos(m->emissao),0,4)
 mes:= substr(dtos(m->emissao),5,2)

 		cQuery:="SELECT email FROM clientes WHERE codcli='"+ncliente+"'"

		SQL_Error_oQuery()

		oRow:= oQuery:GetRow(1)
        cEmail :=oRow:fieldGet(1) 
		oQuery:Destroy()


IF empty(cEmail) .and. empty(mgusuario_email)
   msginfo('Cliente não localizado ou sem e-mail cadastrado...')
	RETURN
end 
	ERASE "C:\ACBrNFeMonitor\sainfe.txt"

	ProcedureEnviarEmail( ALLTRIM(cEmail),x_Diretorio+"\"+Ano+Mes+"\NFe\"+m->CHAVE+"-nfe.xml","1")
	msginfo(xRet_NFe)

RETURN .T.

//----------------------------------------------------------------------------------------

function Carrega_Itens_NFe(cArea,nPedido,nTela)
Local nTotal_Nota_Impostos:=0 

				cQuery := "delete from It_TMP where nrped="+str(nPedido)
				SQL_Error_oQuery()
				oQuery:Destroy()
 
 
    if nTela=1
		cQuery:= "SELECT valor,valorliq   FROM cupom where sequencia="+str(nPedido)
		SQL_Error_oQuery()
		oRow := oQuery:GetRow(1)
		cDesc_Financ:=( (oRow:fieldGet(1) - oRow:fieldGet(2) )/oRow:fieldGet(1) )*100
		oQuery:Destroy()
 		cQuery:= "SELECT '' as Status,Cod_Item,Descr_Item,space(1) as Descr_Serv,Quant,Unit,Descfinanc,Unidade,quant*unit as totvenda   FROM "+cArea+" where sequencia="+str(nPedido) +" order by item"
    elseif nTela=2
 		cQuery:= "SELECT '' as Status,Cod_Item,Descr_Item,Descr_Serv,Quant,compra,Desconto,Unidade,totvenda  FROM "+cArea+" where nrped="+str(nPedido) +" order by item"
    elseif nTela=3 ///fecha pre venda
		cQuery:= "SELECT valor,valorliq  FROM orcament where nrped="+str(nPedido)   
		SQL_Error_oQuery()
		oRow := oQuery:GetRow(1)
		cDesc_Financ:=( (oRow:fieldGet(1)-oRow:fieldGet(2))/oRow:fieldGet(1) )*100
 		oQuery:Destroy()
 		cQuery:= "SELECT Status,Cod_Item,Descr_Item,Descr_Serv,Quant,unit,Desconto,Unidade,totvenda  FROM "+cArea+" where nrped="+str(nPedido)
    elseif nTela=4  ///emite nfe transferencia
 		cQuery:= "SELECT Status,Cod_Item,Descr_Item,Descr_Serv,Quant,unit,Desconto,Unidade,totvenda  FROM "+cArea+" where nrped="+str(nPedido)
		 
   	cDesc_Financ:=0

    elseif nTela=5  ///emite nfe desagregção açougue
 		cQuery:= "SELECT Status,Cod_Item,Descr_Item,'' as Descr_Serv,Quant,unit,Desconto,Unidade,totvenda  FROM "+cArea+" where nrped="+str(nPedido)
   	cDesc_Financ:=0

    elseif nTela=6  ///emite nfe perdas de estoque
 		cQuery:= "SELECT '' as status,lpad(a.id_produto,6,'0') as cod_item,a.Descr_Item,'' as Descr_Serv,a.Quantidade as quant,b.custo as unit,b.unidade,(b.custo*a.quantidade) as totvenda  FROM "+cArea+" a,produtos b where a.id_produto=b.id_produto and a.status=0"
   	cDesc_Financ:=0

    elseif nTela=7  ///emite nfe troca de estoque
 		cQuery:= "SELECT '' as status,lpad(a.id_produto,6,'0') as cod_item,a.Descr_Item,'' as Descr_Serv,a.Quantidade as quant,a.custo as unit,b.unidade,(a.custo*a.quantidade) as totvenda  FROM "+cArea+" a,produtos b where a.id_produto=b.id_produto and a.status=0"
   	cDesc_Financ:=0
    elseif nTela=8 ///fecha pre venda
		cQuery:= "SELECT valor,valorliq  FROM pedidos where nrped="+str(nPedido)   ///fechamento nfc-e venda rapida
		SQL_Error_oQuery()
		oRow := oQuery:GetRow(1)
		cDesc_Financ:=( (oRow:fieldGet(1)-oRow:fieldGet(2))/oRow:fieldGet(1) )*100
 		oQuery:Destroy()
 		cQuery:= "SELECT Status,Cod_Item,Descr_Item,Descr_Serv,Quant,unit,Desconto,Unidade,totvenda  FROM "+cArea+" where nrped="+str(nPedido)
	else
	
 

			cQuery:= "SELECT valor,valorliq,frete,desconto  FROM pedidos where nrped="+str(nPedido)
			SQL_Error_oQuery()
			oRow := oQuery:GetRow(1)
			if mgCNPJ<>"08.934.590/0001-31"
				nValor_Produtos_Frete:=oRow:fieldGet(1)+oRow:fieldGet(3)
			else
				nValor_Produtos_Frete:=oRow:fieldGet(1) 
			end                                       
	 
			if cArea="IT_OS"
				cDesc_Financ:=oRow:fieldGet(4)///( (nValor_Produtos_Frete - oRow:fieldGet(2) )/oRow:fieldGet(1) )*100
				xTotal_Item_Nfe:="totitem as totvenda "
			elseif cArea="IT_ORCAM"
				cDesc_Financ:=0
				xTotal_Item_Nfe:="totvenda "
			else
				cDesc_Financ:=( (nValor_Produtos_Frete - oRow:fieldGet(2) )/oRow:fieldGet(1) )*100
				xTotal_Item_Nfe:="totvenda "
			end
				oQuery:Destroy()
		 		cQuery:= "SELECT Status,Cod_Item,Descr_Item,Descr_Serv,Quant,Unit,Desconto,Unidade,"+xTotal_Item_Nfe+"  FROM "+cArea+" where  NrPed="+str(nPedido)  +" order by item"
	end
   

	SQL_Error_oQuery()
 	if oQuery:LastRec()=0
	   msginfo('Arquivo Vazio...')
	   return
	end

	salva_sql( cQuery, 'tmp_itens' )

   USE tmp_itens ALIAS Tmp_Itens EXCLUSIVE NEW
	sele Tmp_Itens
	go top                                            	
	
 XXX:=1
 do while !Tmp_Itens->(eof())
  cStatus  		:=Tmp_Itens->status
  cCod_Item		:=Tmp_Itens->cod_item
  cDescr_Item	:=Tmp_Itens->descr_item
  cDescr_Serv	:=Tmp_Itens->descr_Serv
 if cArea="IT_ORCAM"
  cQuant			:=Tmp_Itens->QUANT
 else
  cQuant			:=Tmp_Itens->TOTVENDA/Tmp_Itens->unit
 end
  cUnit			:=Tmp_Itens->unit
  if Tmp_Itens->status=="P"
	  cDesconto		:=((Tmp_Itens->unit*Tmp_Itens->quant)*cDesc_Financ)/100
  elseIF   Tmp_Itens->status=="M"
	  cDesconto		:=0
  else 
	  cDesconto		:=((Tmp_Itens->unit*Tmp_Itens->quant)*cDesc_Financ)/100
  end
  cUnidade		:=Tmp_Itens->unidade
  
  
		if cStatus=='T'
			Tmp_Itens->(dbskip())
			loop
		end
		if cStatus=='S'
			Tmp_Itens->(dbskip())
			loop
		end

    		oQuery    := MySQL_Seleciona_Dados (oServer, "produtos", "id_produto", cCod_Item)
			xCST_ORIGEM:=MySQL_Pega_Dados (oQuery, "cst_origem")
			xCST_Item:=MySQL_Pega_Dados (oQuery, "cst_icms")
			xNCM_Item:=MySQL_Pega_Dados (oQuery, "cod_ncm")
			xCodigo_Barra_Item:=MySQL_Pega_Dados (oQuery, "cod_barra")
			xCodigo_ANP:=MySQL_Pega_Dados (oQuery, "codigo_anp")
			xICMS_Venda_Item:=MySQL_Pega_Dados (oQuery, "icmsvenda")
			xDiferencial_Alicota:=MySQL_Pega_Dados (oQuery, "dif_alicot")
			xTipo_Item:=MySQL_Pega_Dados (oQuery, "tipo_item")
			xdescricao_item:=MySQL_Pega_Dados (oQuery, "descr_item")
			xPeso_Item:=MySQL_Pega_Dados (oQuery, "pespro")
			xComissao_Item:=MySQL_Pega_Dados (oQuery, "comissao")
			oQuery:Destroy()

          if empty(cUnidade)   
				cUnidade		:='UN'
		    end  
		if nTela<>12
			if xTipo_Item=='09'
				Tmp_Itens->(dbskip())
				loop
			end
		else
			if xTipo_Item=='09'
				if mgIMP_SV_CUPOM==.f.
					Tmp_Itens->(dbskip())
					loop
				end
			end
		end 	
		
         if empty(limpa(xNCM_Item)) 
		      msginfo('ATENÇÃO...O '+alltrim(xdescricao_item)+' está com a NCM inválida. sua NF-e não será emitida...')
            cAprova_Emissao:=1
		   end  

		///calcula impostos dos cupom para sair na nota tambem
		nNCM_Imposto:= val((limpa(xNCM_Item)))
 		cQuery:= "SELECT aliqnac FROM tabela_ibpt where ncm="+str(nNCM_Imposto)
		SQL_Error_oQuery()
		oRow:= oQuery:GetRow(1) 
		nPerc_Imposto:=(oRow:fieldGet(1))
		oQuery:Destroy()
 		if nPerc_Imposto==0
 		   nPerc_imposto:=32.09
      end
		
		if nTela<>3  .and. xTipo_Item<>'09'//fechamento pre venda                                                   	
         if empty(xCST_Item)   
		      msginfo('ATENÇÃO...O '+alltrim(xdescricao_item)+' está com o CST em branco. sua NF-e não será emitida...')
            cAprova_Emissao:=1
		   end  
         if len(limpa(xNCM_Item))<8   
		      msginfo('ATENÇÃO...O '+alltrim(xdescricao_item)+' está com a NCM inválida. sua NF-e não será emitida...')
            cAprova_Emissao:=1
		   end  
		end
		
       Select Auxilia3
		 nx_taman := Len(Alltrim(xCodigo_Barra_Item))
		 if nx_taman<>13
			nEAN:=''
		 else
			nEAN:=xCodigo_Barra_Item
		 end

		   	if nTela=4  ///emite nfe transferencia
					 mcfop:='5.152' 
					 xUF_Cliente:="RO"
		   	end

                  NETUSE()
                  APPEND BLANK
                if mgCNPJ=='04.634.146/0001-40'
					if !empty(xCodigo_Barra_Item)
						Auxilia3->CODFOR     := xCodigo_Barra_Item
					else
						Auxilia3->CODFOR     := cCod_item
					end
				end
 
                  Auxilia3->ITEM       := XXX
                  Auxilia3->CODIGO     := cCod_item
                  Auxilia3->CODBARRA   := nEAN 
                  Auxilia3->CODIGO_ANP := xCodigo_ANP
                  Auxilia3->QUANT      := cQUANT
                  Auxilia3->UNIT       := cUNIT
                  Auxilia3->PESO       := xPeso_Item*cQUANT
                  Auxilia3->UNID       := cUnidade
                  Auxilia3->DESCRICAO  := cDESCR_ITEM
                  Auxilia3->DESCR_SERV := cDESCR_SERV
                  auxilia3->subtotal   := cQUANT*cUNIT
                  auxilia3->desconto   := cDesconto
                  auxilia3->valdes     := cDesconto
                  Auxilia3->TOTAL_UNIT := (cQUANT*cUNIT)-auxilia3->valdes
                  Auxilia3->NCM        := xNCM_Item
                  Auxilia3->cst        := xCST_ORIGEM+xcst_item
                  Auxilia3->CFOP       := mcfop
                  Auxilia3->alicota    := xICMS_Venda_Item
                  Auxilia3->DIF_ALICOT := xDiferencial_Alicota
					nTotal_Nota_Impostos+=Auxilia3->TOTAL_UNIT
					nImpostos_Cupom+=(auxilia3->total_unit)*(nPerc_Imposto/100)
		 
			if ntela==3   .or. nTela==12.or. nTela==20
			
			
				//para impressao cupom pela pre venda
				nValor_Desconto_Item:=(cDesconto*cQUANT)
				nDescontoFinanceiro :=((nValor_Desconto_Item/cQUANT) /  cUNIT )* 100
				cQuery := "INSERT INTO It_TMP (NRPED,ITEM,COD_ITEM,DESCR_ITEM,UNIDADE,"+;
						  "QUANT,DESCONTO,VALDESC,"+;
						  "UNIT,TOTVENDA,"+;
						  "descr_serv,comissao) "+; 
						  "VALUES "+;
						  "("+STR(nPedido)+","+STR(XXX)+",'"+(cCod_item)+"','"+alltrim(limpa_string(cDESCR_ITEM))+"','"+(limpa_string(cUnidade))+"',"+;
						  STR(cQUANT)+","+STR(nDescontoFinanceiro)+","+STR(nValor_Desconto_Item)+","+;
						  STR(cUNIT)+","+STR(cUNIT*cQUANT)+",'"+;
						  limpa_string(cDESCR_SERV)+"',"+STR(  (((cUNIT*cQUANT)-nValor_Desconto_Item)*xComissao_Item/100)  )+;
						  ")"

						  XXX++ 
						SQL_Error_oQuery()
						oQuery:Destroy()

	    end
	  
		        If xUF_Cliente<>mgESTADO  .and. mgRAMO_ATIVIDADE==6
        			if stuff(auxilia3->cst,1,1,"")=="60".OR.stuff(auxilia3->cst,1,1,"")=="10"
						Auxilia3->cst        := '000'
						Auxilia3->alicota    := 17
					end
        		End

				IF mgRAMO_ATIVIDADE==7 /// cfop para industrias
				  if stuff(auxilia3->cst,1,1,"")=="10"
				     if mcfop=='5.102'.or.mcfop=='5.101'
					    Auxilia3->CFOP :='5.401'
					 elseif mcfop=='6.102'.or.mcfop=='6.101'
					    Auxilia3->CFOP :='6.401'
					 end
				  end
				  if stuff(auxilia3->cst,1,1,"")=="60"
				    if mcfop=='5.102'.or.mcfop=='5.101'
					    Auxilia3->CFOP :='5.102'
					 elseif mcfop=='6.102'.or.mcfop=='6.101'
					    Auxilia3->CFOP :='6.102'
					 end
				  end
				ELSE
				  if stuff(auxilia3->cst,1,1,"")=="60"
   			    if mcfop=='5.102'.or.mcfop=='5.101'
					    Auxilia3->CFOP :='5.405'
					 elseif mcfop=='6.102'.or.mcfop=='6.101'
					    Auxilia3->CFOP :='6.404'
					 elseif mcfop=='5.202'
					    Auxilia3->CFOP :='5.411'
					 elseif mcfop=='6.202'
					    Auxilia3->CFOP :='6.411'
					 elseif mcfop=='1.202'
					    Auxilia3->CFOP :='1.411'
					 end
				  end
				END

				///cfop para tranferencias de mercadorias entre filiais
				
				IF mcfop=='5.152' 
				  if stuff(auxilia3->cst,1,1,"")=="60"
				    Auxilia3->CFOP :='5.409'
				  end
				ELSEIF mcfop=='6.152' 
				  if stuff(auxilia3->cst,1,1,"")=="60"
				    Auxilia3->CFOP :='6.409'
				  end
				END
				
					If xUF_Cliente<>mgESTADO
					if mInscricaoEstadual<>'ISENTO'.or. mInscricaoEstadual<>''
							Auxilia3->alicota    := 12 
							Alicota_ICMS_Frete   := 12
					End
					End
 
			if stuff(auxilia3->cst,1,1,"")<>"60".or.stuff(auxilia3->cst,1,1,"")<>"40".or.stuff(auxilia3->cst,1,1,"")<>"41".or.stuff(auxilia3->cst,1,1,"")<>"50".or.stuff(auxilia3->cst,1,1,"")<>"51".or.stuff(auxilia3->cst,1,1,"")<>"90"
                        auxilia3->BASE_ICMS  := ( auxilia3->TOTAL_UNIT ) 
                        auxilia3->TOTICMS    := ( auxilia3->TOTAL_UNIT*Auxilia3->alicota )/100
 			endif
 
			if stuff(auxilia3->cst,1,1,"")=="60".or.stuff(auxilia3->cst,1,1,"")=="40" .or.stuff(auxilia3->cst,1,1,"")=="41".or.stuff(auxilia3->cst,1,1,"")=="50".or.stuff(auxilia3->cst,1,1,"")=="51".or.stuff(auxilia3->cst,1,1,"")=="90"
               auxilia3->alicota    := 0
               auxilia3->TOTICMS    := 0
			   	auxilia3->base_icms  := 0
 			endif

			///calculo do imposto para ST
 
			
				if stuff(auxilia3->cst,1,1,"")=="10" 
                    auxilia3->TOTAL_ST   := auxilia3->BASE_ICMS+((auxilia3->BASE_ICMS*Auxilia3->DIF_ALICOT )/100 )
                    auxilia3->ICMS_ST    := (  auxilia3->TOTAL_ST * auxilia3->alicota/100 )-auxilia3->TOTICMS

				end
				
            //select na tabela TIPI
			oQuery   	 		:= MySQL_Seleciona_Dados (oServer, "tipi", "ncm", xNcm_Item)
			cNCM		 	 		:= MySQL_Pega_Dados (oQuery, "ncm")
			cCST_PISCOF  		:= MySQL_Pega_Dados (oQuery, "cst_piscof")
			cCOFINS			 	:= MySQL_Pega_Dados (oQuery, "cofins")
			cPIS		 			:= MySQL_Pega_Dados (oQuery, "pis")
			cCod_Convenio_Ncm	:= MySQL_Pega_Dados (oQuery, "cod_conv")
			cConvenio_Ncm		:= MySQL_Pega_Dados (oQuery, "conv_ncm")
			oQuery:Destroy()
 
			if !empty(cNCM)
            Auxilia3->cst_piscof       := Ccst_piscof
            Auxilia3->aliq_cofin       := Ccofins
            Auxilia3->aliq_pis         := Cpis
            
 				if mgRegime_Ap==1.and.Ccofins>0
					Auxilia3->aliq_cofin := 3
					Auxilia3->aliq_pis   := 0.65
				elseif mgRegime_Ap==2.and.Ccofins>0
					Auxilia3->aliq_cofin := 7.6
					Auxilia3->aliq_pis   := 1.65
				end

			else
 				Auxilia3->cst_piscof :='01'
 				if mgRegime_Ap==1
					Auxilia3->aliq_cofin := 3
					Auxilia3->aliq_pis   := 0.65
				else
					Auxilia3->aliq_cofin := 7.6
					Auxilia3->aliq_pis   := 1.65
				end
				
			end
            Auxilia3->totalCOFIN       := (Auxilia3->TOTAL_UNIT*Auxilia3->aliq_cofin)/100
            Auxilia3->totalPIS         := (Auxilia3->TOTAL_UNIT*Auxilia3->aliq_pis)/100
 
    if  cConvenio_Ncm<>'N'.and.!empty(cConvenio_Ncm)

		if mgRegime==3    .and.  stuff(auxilia3->cst,1,1,"")=="20"

			//select na tabela convenio
			oQuery   	 := MySQL_Seleciona_Dados (oServer, "convenioicms", "codigo", str(cCod_Convenio_Ncm))
			cCodigo_Convenio	 := MySQL_Pega_Dados (oQuery, "codigo")
			Public cDescricao_Convenio	 := MySQL_Pega_Dados (oQuery, "descricao")
			crbc_vd_int	 := MySQL_Pega_Dados (oQuery, "rbc_vd_int")
			crbc_vd_ext	 := MySQL_Pega_Dados (oQuery, "rbc_vd_ext")

			oQuery:Destroy()
			if empty(cDescricao_Convenio)
					cDescricao_Convenio:='0'
			End
 			achou:=.f.
 	
			for i=1 to len(Obs_Nota)
            if Obs_Nota[i,1]=cCodigo_Convenio
                 achou:=.t.
            end if
			next
			
					if cCodigo_Convenio=1.and.Auxilia3->alicota==17
						xReducao:=Round (crbc_vd_int/Auxilia3->alicota,4)
    					auxilia3->RED_BASE   := Round (100-(xReducao*100) ,2)
	    				auxilia3->BASE_ICMS  := ( Auxilia3->TOTAL_UNIT * xReducao  )  
		    			auxilia3->TOTICMS    := ( auxilia3->BASE_ICMS*Auxilia3->alicota )/100
					elseif cCodigo_Convenio=1.and.Auxilia3->alicota==12
						xReducao:=Round (crbc_vd_ext/Auxilia3->alicota,4)
    					auxilia3->RED_BASE   := Round (100-(xReducao*100) ,2)
	    				auxilia3->BASE_ICMS  := ( Auxilia3->TOTAL_UNIT * xReducao  )  
		    			auxilia3->TOTICMS    := ( auxilia3->BASE_ICMS*Auxilia3->alicota )/100
					elseif cCodigo_Convenio=2.and.Auxilia3->alicota==17
						xReducao:=Round (crbc_vd_int/Auxilia3->alicota,4)
    					auxilia3->RED_BASE   := Round (100-(xReducao*100) ,2)
	    				auxilia3->BASE_ICMS  := ( Auxilia3->TOTAL_UNIT * xReducao  )  
		    			auxilia3->TOTICMS    := ( auxilia3->BASE_ICMS*Auxilia3->alicota )/100
					elseif cCodigo_Convenio=2.and.Auxilia3->alicota==12
						xReducao:=Round (crbc_vd_ext/Auxilia3->alicota,4)
    					auxilia3->RED_BASE   := Round (100-(xReducao*100) ,2)
	    				auxilia3->BASE_ICMS  := ( Auxilia3->TOTAL_UNIT * xReducao  )  
		    			auxilia3->TOTICMS    := ( auxilia3->BASE_ICMS*Auxilia3->alicota )/100
					elseif cCodigo_Convenio=3

						If xUF_Cliente<>mgESTADO
							if mInscricaoEstadual<>'ISENTO' .or. mInscricaoEstadual<>''
								Auxilia3->alicota    := 12 
								Alicota_ICMS_Frete   := 12
							else
								Auxilia3->alicota    := 17 
								Alicota_ICMS_Frete   := 17
							end
						else
							Auxilia3->alicota    := 0 
							Auxilia3->cst        := '040'
						end
 					
						if Auxilia3->alicota==0
							xReducao:=Round (crbc_vd_int/Auxilia3->alicota,4)
							auxilia3->RED_BASE   := 0
							auxilia3->BASE_ICMS  := 0
							auxilia3->TOTICMS    := 0
							Auxilia3->alicota    := 0
						else
   						xReducao:=Round (crbc_vd_ext/Auxilia3->alicota,4)
							Auxilia3->cst        := '020'
							auxilia3->RED_BASE   := Round (100-(xReducao*100) ,2)
							auxilia3->BASE_ICMS  := ( Auxilia3->TOTAL_UNIT * xReducao  )  
							auxilia3->TOTICMS    := ( auxilia3->BASE_ICMS*Auxilia3->alicota )/100
						end
					else
						msginfo("A NCM "+xNCM_Item+" não está classificada em nenhum convênio")
						xReducao:=0
					endif
					
					if cCodigo_Convenio=1
						auxilia3->ANEXO  := 'A-I'
					else
						auxilia3->ANEXO  := 'A-II'
					end
	

          if !achou
				aadd(Obs_Nota,{cCodigo_Convenio,'CST = '+stuff(auxilia3->cst,1,1,"")+' - '+ALLTRIM(Cdescricao_Convenio)})
          endif
		End
   	endif

		///Tributacao para o regime simples
		if mgRegime==1.or.mgRegime==2
				

			if mgGeraCreditoIcms==.t.
			
						if stuff(auxilia3->cst,1,1,"")=="10".or.stuff(auxilia3->cst,1,1,"")=="30".or.stuff(auxilia3->cst,1,1,"")=="70"
							auxilia3->cst        := '202'
						elseif stuff(auxilia3->cst,1,1,"")=="60"
							If xUF_Cliente<>mgESTADO .and. mInscricaoEstadual<>'ISENTO'  
								auxilia3->cst        := '201'
								nCredito_Simples:=nCredito_Simples+(auxilia3->TOTAL_UNIT*mgALICOTA/100)
								achou_Credito_Simples:=.t.
							else
								auxilia3->cst        := '500'
							end
						else
							auxilia3->cst        := '101'
							nCredito_Simples:=nCredito_Simples+(auxilia3->TOTAL_UNIT*mgALICOTA/100)
							achou_Credito_Simples:=.t.
						end
		
				  		if mCfop='5.411'.or.mCfop='5.202'.or.mCfop='6.411'.or.mCfop='6.202'
								auxilia3->cst        := '900'
				  		end
				
			else
			
						if stuff(auxilia3->cst,1,1,"")=="10".or.stuff(auxilia3->cst,1,1,"")=="30".or.stuff(auxilia3->cst,1,1,"")=="70"
									auxilia3->cst        := '202'
		                    auxilia3->TOTAL_ST   := auxilia3->TOTAL_UNIT+((auxilia3->TOTAL_UNIT*Auxilia3->DIF_ALICOT )/100 )
		                    auxilia3->ICMS_ST    := (( auxilia3->TOTAL_ST*auxilia3->alicota )/100)-auxilia3->TOTICMS
		
						elseif stuff(auxilia3->cst,1,1,"")=="60"
								auxilia3->cst        := '500'
						else
							auxilia3->cst        := '102'
						end
			end
			
					if stuff(auxilia3->cst,1,1,"")=="40" 
						auxilia3->cst        := '103'
					elseif stuff(auxilia3->cst,1,1,"")=="41"
						auxilia3->cst        := '400'
					elseif stuff(auxilia3->cst,1,1,"")=="90"
						auxilia3->cst        := '900'
					end
		
						Auxilia3->alicota    := 0
				      auxilia3->BASE_ICMS  := 0
		   	      auxilia3->TOTICMS    := 0

		end

 
		if mCFOP='5.915'.OR.mCFOP='5.916'.OR.mCFOP='5.917'.OR.mCFOP='5.918'.OR.mCFOP='5.919'.OR.mCFOP='6.915'.OR.mCFOP='6.916'.OR.mCFOP='5.927' .OR.mCFOP='5.922'.OR.mCFOP='6.922'
             Auxilia3->cst_piscof       := '99'
             Auxilia3->aliq_cofin       := 0
             Auxilia3->aliq_pis         := 0
	    	    auxilia3->ALICOTA    := 0
	    	    auxilia3->BASE_ICMS  := 0
		       auxilia3->TOTICMS    := 0
		end
 		   
                  commit
                  unlock

		Tmp_Itens->(dbskip())
enddo 
	  
  
			if mCFOP<>'5.926'.OR.mCFOP<>'5.927'.OR.mCFOP<>'1.926'.OR.mCFOP<>'5.915'.OR.mCFOP<>'5.916'.OR.mCFOP<>'6.915'.OR.mCFOP<>'6.916'
					aadd(Obs_Nota,{0,"Valor Aproximado dos Tributos R$"+transf(nImpostos_Cupom,"99,999.99")+"("+transf((nImpostos_Cupom/nTotal_Nota_Impostos)*100,"999.99")+"%) Conf. Lei 12.741/2012   Fonte: Tabela IBPT (www.ibpt.com.br);;"})
			END
close Tmp_Itens

return




*-----------------------------------------------------------------------------*
FUNCTION LER_RETORNO
*------[ DOCUMENTECAO ]
*        LE O ARQUIVO COM A CONFIGURA€ÇO DA NFE ELETRONICA
*        AS VARIAVEIS C... DEVEM SER DECLARADAS PRIVATE
*-----------------------------------------------------------------------------*

private cfile := "C:\ACBrNFeMonitor\sainfe.txt"

IF ! FILE( CFILE )
   RETURN .F.
ENDIF
private cTexto := Memoread ( cFile )

Ret_Status_Validacao   := alltrim ( memoline ( cTexto,80,1 )  )
R_Status_Servico	 	  := alltrim ( memoline ( cTexto,80,6 )  )
R_CStat                := alltrim ( memoline ( cTexto,80,18)  )
c_ChNFe                := alltrim ( memoline ( cTexto,80,28)  )
c_NProt                := alltrim ( memoline ( cTexto,80,30)  )
Error_Status_Validacao := alltrim ( memoline ( cTexto,80,1 )  )
Ret_Status_Servico:=R_Status_Servico
PUBLIC CNPROT   :=SUBSTR(c_NProt , 7,15)
PUBLIC cChNFe   :=SUBSTR(c_ChNFe , 7,44)
public RCStat   :=R_CStat
release ctexto

return  .T.


 

*		 // Função para Assinar o XML
		 Static Function ProcedureAssinarXML(oArq)
		         LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
               FWRITE(nHandle,"NFe.AssinarNFe("+oArq+")")
               FCLOSE(nHandle)
					RETURN

*       // Função para Validar o XML (o arquivo deve estar Assinado
        Static Function ProcedureValidarXML(oArq)
		         LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
               FWRITE(nHandle,"NFe.ValidarNFe("+oArq+")")
               FCLOSE(nHandle)
			   RETURN
					
*       // Função para Cancelar o XML
        Function ProcedureEnviarXML(oArq)
               LOCAL cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'
		         LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
					LOCAL nLote    := '0'
					//////[RETORNO]///////////
					local r_ChNFe    :="" 
					local r_Stat     :="" 
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
 				SQL_Error_oQuery()
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
					MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+"  Erro na leitura do arquivo!!!, ESC para Retornar" 
				end

			  
RETURN


 
			
*       // Função para Cancelar o XML
        Static Function ProcedureCancelarXML(oArq)
		        LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
				Public c_Ret_Cancelamento:=""  //Servico em Operacao
				Public c_Prot_Cancelamento:=""  //Servico em Operacao
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
               FWRITE(nHandle,"NFe.CancelarNFe("+oArq+",Cancelamento de NF-e homologado)")
               FCLOSE(nHandle) 
		xxx:=1
		DO WHILE XXX<=20
	
			IF !FILE("C:\ACBrNFeMonitor\SAINFE.TXT")	
				MY_WAIT( 3 ) 
				xxx++
			ELSE 

				////STATUS////
				BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
					GET c_Ret_Cancelamento        SECTION  "CANCELAMENTO"       ENTRY "XMotivo"
					GET c_Prot_Cancelamento       SECTION  "CANCELAMENTO"       ENTRY "NProt"
				END INI
 
			exit
			END
		enddo   
		// Função para Enviar Email do XML
        Function ProcedureEnviarEmail(oEmail,oArq,oTipo)
		       LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
               FWRITE(nHandle,"NFE.EnviarEmail("+oEmail+","+oArq+","+oTipo+")")
               FCLOSE(nHandle) 
			  msginfo('Enter para Confirmar o envio do Email.')
			  MY_WAIT( 3 )
			ProcedureEsperaResposta()
			RETURN

*       // Função para Cancelar o XML
        Function ProcedureConsultaXML(oArq)
				//////[CONSULTA]///////////
				local c_XMotivo :=""//Autorizado o uso da NF-e
				local c_NProt   :=""//311110000010110
				local c_Stat    :="" 
				local cArquivo  :=""
				///////FIM///////////////

		         LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
               LOCAL cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'

	  			 ERASE "C:\ACBrNFeMonitor\sainfe.txt"

 				
			 			  cQuery:= "select xml,cbdchave,CbddEmi FROM "+c_Tabela_NFe_ACBr+"  WHERE CbdChave = '" + oArq +"'"
                    
						  oQuery:=oServer:Query( cQuery )
						    If oQuery:NetErr()												
						      MsgInfo("erro sql: " , "ATENÇÃO")
						      Return Nil
						    EndIf
							oRow:= oQuery:GetRow(1)
						 
							ano:= substr(dtos(oRow:FieldGet(3)),0,4)
							mes:= substr(dtos(oRow:FieldGet(3)),5,2)

							
						If Empty(oRow:FieldGet(1))
						    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
						    Return(.f.)
						EndIf

                  cArquivo:=CurDrive()+ ":\" + CurDir() + "\NFeSaida\"+ano+mes+"\NFe\"+oRow:FieldGet(2)+"-nfe.XML"
			  		 	HANDLE :=  FCREATE (cArquivo ,0)// cria o arquivo
					   FWRITE(Handle,oRow:FieldGet(1))
						fclose(handle)  
						cTXT     := CurDrive()+ ":\" + CurDir() + "\NFeSaida\"+ano+mes+"\NFe\"+oRow:FieldGet(2)+"-nfe.XML"
				 
			               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
			                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
						         Return
			               ENDIF 
			              FWRITE(nHandle,"NFE.ConsultarNFe("+ alltrim(cTXT)+")")
			              FCLOSE(nHandle) 
																							  
						cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'
						lRetStatus:=EsperaResposta(cDestino) 
				      if lRetStatus==.t.
							////RETORNO////
							BEGIN INI FILE "C:\ACBrNFeMonitor\SAINFE.TXT"
								   GET c_XMotivo        SECTION  "CONSULTA"       ENTRY "XMotivo"
								   GET c_NProt          SECTION  "CONSULTA"       ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
								   GET c_Stat           SECTION  "CONSULTA"       ENTRY "CStat"       
							END INI
							 /////////////////////////////////////////////////////////////
						   janelasplash.show
				    		MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' +janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Retorno: "+C_XMotivo
						else
							MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+"  Erro na leitura do arquivo!!!, ESC para Retornar" 
						end
		
    			  Public Mensagem_Retorno_Consulta :=c_XMotivo
    			  Public Protocolo_Retorno_Consulta:=c_NProt

				if empty(Protocolo_Retorno_Consulta)
					lRetStatus:=EsperaResposta(cDestino) 
			      if lRetStatus==.t.
					   Protocolo_Retorno_Consulta:=memoread(cDestino)
					end
				end
				  
            if c_Stat=="100" // tenta emitir automaticamente a nota
				
				    	ffxml:=memoread(  cArquivo )
				                 
				 		cQuery:="UPDATE "+c_Tabela_NFe_ACBr+" SET CbdfinNFe=0,CBDStatus='"+c_XMotivo+"',CBDProtocolo='"+c_NProt+;
						 			"',xml='" +alltrim(ffxml)+"' WHERE CbdChave='"+oArq+"'"    
					 
						SQL_Error_oQuery()
						oQuery:Destroy()
						MSGINFO(c_XMotivo)

            elseif c_Stat=="101" // tenta emitir automaticamente a nota
				
				    	ffxml:=memoread(  cArquivo )
				                 
				 		cQuery:="UPDATE "+c_Tabela_NFe_ACBr+" SET CbdfinNFe=2,CBDStatus='"+c_XMotivo+"',CBDProtocolo='"+c_NProt+;
						 			"',xml='" +alltrim(ffxml)+"' WHERE CbdChave='"+oArq+"'"    
					 
						SQL_Error_oQuery()
						oQuery:Destroy()
						MSGINFO(c_XMotivo)
            elseif c_Stat=="217" // tenta emitir automaticamente a nota
					ERASE "C:\ACBrNFeMonitor\sainfe.txt"
			  	 	ProcedureEnviarXML( cArquivo )
  	 			else
				  	MSGINFO(c_XMotivo)
            end
            	 
	     RETURN  
			 
			 
        Function ProcedureValidadeCertificado()
		        LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
				LOCAL nLote    := '0'


               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
              FWRITE(nHandle,"NFE.CertificadoDataVencimento")
              FCLOSE(nHandle) 
				MY_WAIT( 3 ) 
						private cTexto := Memoread ( "C:\ACBrNFeMonitor\SAINFE.TXT" )
						cValidadeCertificado:=alltrim ( memoline ( cTexto,80,1 )  )
						cValidadeCertificado:=SUBSTR(cValidadeCertificado, 5, 20)
						nDIA=ctod(cValidadeCertificado)-DATE()
			          msginfo(cValidadeCertificado)
						IF ndia<=30
						   MSGEXCLAMATION("ATENCAO. Seu Certificado Digital expira em "+cValidadeCertificado+". Faltam "+alltrim(str(ndia))+" dias para vencer")
						ENDIF
			  
			RETURN
			 
			 
*       // Função para Checar Status do Serviço
		Function ProcedureSelecionaCertificado()
            LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
                IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                   MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
                   Return
               ENDIF  
 
                FWRITE(nHandle,'NFe.SetCertificado('+ALLTRIM(mgCertificado)+')' )
                FCLOSE(nHandle)
 

		   RETURN
*       // Função para Checar Status do Serviço
		Function ProcedureLerINI()         
            LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
                IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                   MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
                   Return
               ENDIF 
                FWRITE(nHandle,'NFe.LerIni' )
                FCLOSE(nHandle)

		   RETURN

////////////////////////////////////////////////////////////////////////////////
// inserido/alterado por: #toya:17/09/2011:10:24
////////////////////////////////////////////////////////////////////////////////
function ACBrDecripta(_cSenha, _cBase)

local cAux:="", cRetorno:="", c:="", Result:="", aResult:={}
local x:=0, nTamanhoSenha:=0, nTamanhoBase:=0, i:=0, pos:=0, PosLetra:=0
local n_Xor:=0, nPos:=0

//DEFAULT _cBase:="tYk*5W@"

nTamanhoBase:=len(_cBase)
Result:=HexToStr(_cSenha)
for x=1 to len(Result)
    aadd(aResult, substr(Result, x, 1))
next
nTamanhoSenha:=len(Result)
for i=1 to nTamanhoSenha
    pos:=mod(i, nTamanhoBase)
    nPos:=pos
    if pos = 0
        pos:=nTamanhoBase
    endif
    PosLetra:=NumXOR(asc(substr(Result, i, 1)), asc(substr(_cBase, pos, 1)))
    n_Xor:=PosLetra
    if PosLetra=0
        PosLetra:=asc(substr(Result, i, 1))
    endif
    c:=chr(PosLetra)
    aResult[i]:=c
    Result:=""
    for x=1 to len(aResult)
        Result+=aResult[x]
    next
next

return Result


////////////////////////////////////////////////////////////////////////////////
// inserido/alterado por: #toya:19/09/2011:07:27
////////////////////////////////////////////////////////////////////////////////
function ACBrEncripta(_cSenha, _cBase)

local cAux:="", cRetorno:="", c:="", Result:="", aResult:={}
local x:=0, nTamanhoSenha:=0, nTamanhoBase:=0, i:=0, pos:=0, PosLetra:=0
local n_Xor:=0, nPos:=0

//DEFAULT _cBase:="tYk*5W@"

nTamanhoBase:=len(_cBase)
Result:=alltrim(_cSenha)
nTamanhoSenha:=len(Result)
for i=1 to nTamanhoSenha
    pos:=mod(i, nTamanhoBase)
    nPos:=pos
    if pos = 0
        pos:=nTamanhoBase
    endif
    PosLetra:=NumXOR(asc(substr(Result, i, 1)), asc(substr(_cBase, pos, 1)))
    n_Xor:=PosLetra
    if PosLetra=0
        PosLetra:=asc(substr(Result, i, 1))
    endif
    c:=chr(PosLetra)
    cRetorno+=StrToHex(c)
next

return cRetorno


function  EnviaLote()
		         LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
               LOCAL cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'


/////[RETORNO]//////////
LOCAL R_Versao  :=""  //SVRS20110322100218
LOCAL R_TpAmb   :="" //1
LOCAL R_VerAplic:="" //SVRS20110322100218
LOCAL R_NRec    :="" //113000263213135
LOCAL R_CStat   :="" //100
LOCAL C_CStat   :="" //100
LOCAL R_XMotivo :="" //=Autorizado o uso da NF-e
LOCAL R_NProt   :="" //=Autorizado o uso da NF-e
LOCAL R_ChNFe   :="" //=Autorizado o uso da NF-e
///////FIM///////////////
   
	
close database
cQuery :="select txt,XML,CbdNtfNumero as NF, "+;
			"CbdNtfSerie as Serie,CbdChave from "+c_Tabela_NFe_ACBr+"  where   CbdPROTOCOLO IS NULL" 

 
	SQL_Error_oQuery()

    	
	salva_sql( cQuery, 'tmp' )

    USE tmp ALIAS TEMP EXCLUSIVE NEW
   
   
   ERASE "C:\ACBrNFeMonitor\sainfe.txt"
   selec temp
   go top
    DO WHILE !temp->(eof())
  
 
     	  			 ERASE "C:\ACBrNFeMonitor\sainfe.txt"
  
						If len(temp->txt)==0
						   temp->(DBSKIP()) 
						   loop
						EndIf
										  

						cTXT     := temp->txt
						
					   MODIFY CONTROL lbindexa   OF janelasplash  VALUE   " Adicionando NF-e "+alltrim(str(temp->NF))+" ao Lote...Aguarde"

			               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
			                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
						         Return
			               ENDIF 
			              FWRITE(nHandle,"Nfe.AdicionarNfe("+cTXT+",1)")
			              FCLOSE(nHandle) 
                        ERASE "C:\ACBrNFeMonitor\sainfe.txt"
							   MY_WAIT( 2 ) 
	   temp->(DBSKIP())  
	
	ENDDO
		        
					     
             	MY_WAIT( 3 )

					MODIFY CONTROL lbindexa   OF janelasplash  VALUE   '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10)+" Enviando Lote...Aguarde"+chr(13)+chr(10)
							 
                        IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
			                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
						         Return
			               ENDIF 
			              FWRITE(nHandle,"Nfe.EnviarLoteNfe(1)")
			              FCLOSE(nHandle)
	           
							 ERASE "C:\ACBrNFeMonitor\sainfe.txt"
								 
	     
				 
	SELE TEMP
   go top
   DO WHILE !temp->(eof())
  
						If len(temp->txt)==0
						   temp->(DBSKIP()) 
						   loop
						EndIf
 
   nnfe:="NFE"+alltrim(str(temp->NF))
	
							     	 
							  	xxx:=1
						 
								DO WHILE XXX<=20
							
									IF !FILE("C:\ACBrNFeMonitor\sainfe.txt")	
										MY_WAIT( 3 ) 
										xxx++
									ELSE
									////RETORNO////
									BEGIN INI FILE "C:\ACBrNFeMonitor\sainfe.txt"
										   GET R_XMotivo        SECTION  nnfe		       ENTRY "XMotivo"
										   GET R_NProt          SECTION  nnfe            ENTRY "NProt"      // PROTOCOLO DE AUTORIZACAO 
										   GET R_ChNFe          SECTION  nnfe            ENTRY "ChNFe"      // chave nfe  
										   GET R_CStat          SECTION  nnfe            ENTRY "CStat"        
										 /////////////////////////////////////////////////////////////
									END INI	
										  
                           	if   R_CStat=='100'
									
											ano:= substr(dtos(date() ),0,4)
											mes:= substr(dtos(date() ),5,2)

										   MODIFY CONTROL lbindexa   OF janelasplash  VALUE '' + janelasplash.lbindexa.VALUE+chr(13)+chr(10) +" Retono da NF-e "+alltrim(str(temp->NF))+" Gravado com Sucesso..."
										     
										   ffxml:=memoread(x_Diretorio+"\"+Ano+Mes+"\NFe\"+R_ChNFe+"-nfe.xml" )
											cQuery:="update "+c_Tabela_NFe_ACBr+" set CBDProtocolo='"+;
													R_NPROT+"',CbdStatus='"+R_XMotivo+"',xml='" +alltrim(ffxml)+"' where cbdntfnumero="+str(temp->NF) +" and cbdntfserie='"+temp->Serie + "'"
											SQL_Error_oQuery()
											oQuery:Destroy()  
   	       						 else
   	       						 	MSGINFO("ERRO: NF-e "+alltrim(str(temp->NF))+" - "+R_XMotivo )
										 end
   	       						
     						    		ERASE "C:\ACBrNFeMonitor\Lotes\lOTE1\"+R_ChNFe+"-NFE.XML" 
   	       			         
									exit
									END
								enddo
								
	   temp->(DBSKIP())  
	
	ENDDO
	
	msginfo("Envio de Lote Concluido com Sucesso...")


	SELE TEMP
   go top
   DO WHILE !temp->(eof())
  
						If len(temp->txt)==0
						   temp->(DBSKIP()) 
						   loop
						EndIf

 
			  cQuery:= "select xml FROM "+c_Tabela_NFe_ACBr+"  WHERE CbdChave='"+alltrim(temp->CbdChave)+ "'"     
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
			cTXT:=CurDrive()+":\mgi\NOTA.XML"
		
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENTNFE.TXT")
			         Return
               ENDIF 
              FWRITE(nHandle,"NFE.ImprimirDanfePDF("+alltrim(cTXT)+")")
              FCLOSE(nHandle) 
            
    if msgyesno("Deseja imprimir a NF-e "+alltrim(str(temp->NF))+" ?")
 			 MYRUN( x_Diretorio+"\"+alltrim(temp->CbdChave)+".PDF" ) 
  	 end
						
	   temp->(DBSKIP())  
	
	ENDDO
   ATUALIZA_BROWSE_MANUTENCAO_NFE()
   janelasplash.RELEASE

Return

// --------------------------------------------------------------------------.
FUNCTION splash_LoteEnvio(vsplash)
// Fun‡Æo....: Gerar tela de splash -----------------------------------------.
local width := 600, height := 350

IF vsplash == 1  // Criar

   DEFINE WINDOW janelasplash AT 0,0 WIDTH 600 HEIGHT 350 MODAL NOSIZE NOCAPTION ON INIT {||EnviaLote() }

   ON KEY ESCAPE OF NFe ACTION { ||janelasplash.release }

   @ 1,1 IMAGE fundologo OF janelasplash PICTURE "NFe.JPG" WIDTH 598 HEIGHT 100 STRETCH


 		DRAW LINE IN WINDOW janelasplash ;
			AT 0, 0 TO 0, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW janelasplash ;
			AT Height, 0 TO Height, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW janelasplash ;
			AT 0, 0 TO Height, 0 ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW janelasplash ;
			AT 0, Width TO Height, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2 

        DEFINE LABEL lbindexa
               ROW    100
               COL    1
               WIDTH  598
               HEIGHT 197
			   	BACKCOLOR WHITE
               FONTNAME "Arial"
               FONTSIZE  9
		END LABEL  
 
		DRAW GRADIENT IN WINDOW janelasplash AT 297,1 TO 300,598;
                                          BORDER NONE ;
                                          BEGINCOLOR {130, 0, 0} ;
                                          ENDCOLOR {250, 0, 0}  
 
 
        DEFINE LABEL lb_2
               ROW    300
               COL    1
               WIDTH  598
               HEIGHT 49
               FONTNAME "Arial"
               FONTSIZE  7
			   value 'MGI Systens - Emissor de NF-e '
		END LABEL  
 
   END WINDOW
   janelasplash.show
   
   CENTER WINDOW janelasplash
   ACTIVATE WINDOW janelasplash
ELSE
   janelasplash.RELEASE
ENDIF
RETURN(NIL)
// Fim da fun‡Æo de gerar tela de splash ------------------------------------.


Procedure EnviaEmail_(_smtp, _id, _de, _para_, _assunto_, _emai_, _anexo_, _usuario, _senha )
LOCAL nRet
LOCAL oMail := BlatMail():New()
   
  * Addresses and password

  oMail:cSMTPServer=_smtp		// SMTP Server address
  IF _Autentica
     oMail:cSMTPLogin=_id		// SMTP authenticated login account
     oMail:cSMTPPassword :=_senha	// Password for SMTP authenticated login - default is skip value
  ENDIF
  oMail:cSendAddress :=_id		// Sender mail address
  oMail:cAltSendAddress :=_de		// address displayed as from address - used for 'Reply To'
  oMail:cFromName :=_usuario		// Plain text name - e.g. John Doe - shown as the sender

  * Lists of recipients and flags

  oMail:cToList:=_para_			// List of recipients comma delimited
  oMail:cSubject :=_assunto_		// Subject line
  oMail:cMessageFile :=''		// File name of file containing plain message text
  oMail:cMessage :=_emai_		// Plain message text
  oMail:cAttachFiles :=_anexo_		// Attached binary files (filenames comma separated)

  oMail:lLogFile=.T.			// use a log file
  oMail:cLogFile='BlatMail.log'		// log filename - default is BlatLog.Log
    
  oMail:SetCommandLine()		// initialize command line common switches

  nRet := oMail:MailSend()		// Actually send the mail

#ifdef _use_CallDLL
  oMail:BlatUnload(.T.)			// Calling this when not using CallDLL doesn't cause harm
#endif

  IF nRet == 0
	MsgInfo( "E-Mail Enviado com successo!", "BlatMail" )
  ENDIF

RETURN


 
 ******************************************************
* Check to see if you can connect to a Internet
******************************************************
 
Function Verifica_Status_Servico(nTela)
local lRet_Servico := .f.
local lRetorno_Internet := .f.

 
	ERASE "C:\ACBrNFeMonitor\sainfe.txt"
                    
	lRetorno_Internet:=IsInternet()
	if nTela<>'NFCE'
		if lRetorno_Internet==.f.
			msginfo("Sem acesso a Internet, Favor verificar sua Conexão")
		   	Configura_Emissao_Normal()
			   lRetorno_Internet:=.t.
		   return
		end                  
	else
		if lRetorno_Internet==.f.
			if MsgYesNo("Sem acesso a Internet, Deseja Continuar a Emissão em Modo de Contingência?")
			   lRetorno_Internet:=.f.
			   Configura_Emissao_Contigencia()
		   else
		   	Configura_Emissao_Normal()
			   lRetorno_Internet:=.t.
		   end
	   else
        lRet_Servico:=ProcedureStatus()
        if lRet_Servico ==.t.
				Configura_Emissao_Normal()
            lRetorno_Internet:=.f.
            lRetorno_Internet:=.f.
        else
				if nTela<>'NFCE'
					if lRetorno_Internet==.f.
						msginfo("Sem acesso a Internet, Favor verificar sua Conexão")
					   	Configura_Emissao_Normal()
						   lRetorno_Internet:=.t.
					   return
					end                  
				else
					if MsgYesNo("Serviço Inativo ou Inoperante, Deseja Continuar a Emissão em Modo de Contingência?")
					   lRetorno_Internet:=.f.
					   Configura_Emissao_Contigencia()
				   else
				   	Configura_Emissao_Normal()
					   lRetorno_Internet:=.t.
				   end
		   	end
        end
 
		end                  
	end

Return lRetorno_Internet

******************************************************
* Check Status Serviço Portal NF-e
******************************************************
 
Function ProcedureStatus() 
LOCAL lRetStatus,lRet:=.f.
LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
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


******************************************************
* Configura emissão para Contigencia
******************************************************
Function Configura_Emissao_Contigencia

				BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
				  SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '1'
				END INI
				cFormaEmissaoNFe:='1'
				ProcedureLerINI()
Return
******************************************************
* Configura emissão Nomal
******************************************************
Function Configura_Emissao_Normal

				BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
				  SET SECTION "Geral"  ENTRY "FormaEmissao"  TO '0'
				END INI
				cFormaEmissaoNFe:='0'
				ProcedureLerINI()
				
Return


******************************
Function EsperaResposta(cFile)
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
******************************************************
* Check to see if you can connect to a Internet
******************************************************
 
Function IsInternet()
local oSock, lRet := .f.
local cServer  := "www.google.com"
local nPort    := 80
local aAddress

oSock := TSocket():New()

if oSock:Connect( cServer, nPort )
	lRet := .t.
	oSock:Close()
endif

Return lRet
 
 //------------------------------------------------------------

