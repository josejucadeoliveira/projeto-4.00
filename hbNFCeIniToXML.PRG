****************************************************************************************************
* Funcoes e Classes Relativas a NFE (Conversão INI formato AcBr para XML)                          *
* Usado como Base o Projeto Open ACBR e Sites sobre XML, Certificados e Afins                      *
* Qualquer modificação deve ser reportada para Fernando Athayde para manter a sincronia do projeto *
* Fernando Athayde 28/08/2011 fernando_athayde@yahoo.com.br                                        *
****************************************************************************************************
#include "common.ch"
#include "hbclass.ch"
#ifndef __XHARBOUR__
   #include "hbwin.ch"
   #include "harupdf.ch"
   #include "hbzebra.ch"
   #include "hbcompat.ch"
#endif
#include "hbnfe.ch"

CLASS hbNFCeIniToXML
   DATA ohbNFe
   DATA cIniFile
   DATA cXMLFile
   DATA lValida    // Assina e Valida
   DATA Token    // Assina e Valida
   DATA IDToken    // Assina e Valida
   
   DATA aIde
   DATA aRefNfe       // notas referenciadas - Mauricio Cruz - 18/01/2012
   DATA aEmit
   DATA aDest
   DATA aRetirada
   DATA aEntrega
   DATA autXML
   DATA aICMSTotal
  	DATA aISSTotal
  	DATA aRetTrib
  	DATA aTransp
  	DATA aRetTransp
  	DATA aVeicTransp
  	DATA aReboque
  	DATA aFatura
  	DATA aDuplicatas
  	DATA aPagamentos
  	DATA aInfAdic
  	DATA aObsCont
  	DATA aObsFisco
  	DATA aProcRef
   DATA aExporta
  	DATA aCompra
  	DATA aInfProt

   DATA aItem
   DATA aItemDI
   DATA aItemAdi
   DATA aItemICMS
   DATA aItemICMSPart
   DATA aItemICMSST
   DATA aItemICMSSN101
   DATA aItemICMSSN102
   DATA aItemICMSSN201
   DATA aItemICMSSN202
   DATA aItemICMSSN500
   DATA aItemICMSSN900
   DATA aItemIPI
   DATA aItemII
   DATA aItemPIS
   DATA aItemPISST
   DATA aItemCOFINS
   DATA aItemCOFINSST
   DATA aItemICMSUFDest
   DATA aItemISSQN
   DATA lCriaSaiNfe INIT .F.   // se deve criar ou não o SAINFE.TXT.  Mauricio Cruz - 28/11/2011
   DATA aItemCOMB
   DATA lMostra_imp_danfe INIT .F.

   DATA cXMLSaida
   METHOD execute()
   METHOD criaNFe(hIniData,cIniFile)
   METHOD incluiTag(cTag,cValor)
ENDCLASS

METHOD execute() CLASS hbNFCeIniToXML
LOCAL aRetorno := hash(), hIniData, cComando, cXML, oAssina, aRetornoAss, oValida, aRetornoVal, oCancela, aRetornoCan
   IF ::lValida = Nil
      ::lValida := .F.
   ENDIF
	 
   IF !FILE( ::cIniFile )
      aRetorno['OK'] := .F.
      aRetorno['MsgErro'] := 'Arquivo não encontrado '+::cIniFile
      RETURN(aRetorno)
   ENDIF

  
   aRetorno['OK'] := .T.

   cXML := MEMOREAD( ::cIniFile )
   cComando := SUBS( cXML, 1, AT("(", cXML )-1)
 
   hIniData := HB_ReadIni( ::cIniFile )  // ESSA FUNÇÃO ORIGINAL DO XHARBOUR TEM UM PROBLEMA E LÊ APENAS 1024 BYTS, POR ISSO FOI MUDADO PARA ESSA HBNFE_ReadIni() QUE LÊ 4096BYTS
 
//   IF "CRIAR" $ UPPER(cComando)
      aRetorno := ::criaNFe(hIniData,::cIniFile)
      IF ::lCriaSaiNfe
         IF aRetorno[ 'OK' ] = .T.
            MEMOWRIT("SAINFE.TXT", "OK: Gerado")
         ELSE
            MEMOWRIT("SAINFE.TXT", "ERRO: "+aRetorno['MsgErro'])
         ENDIF
      ENDIF
//   ENDIF

   cXML := Nil

RETURN(aRetorno)

METHOD criaNFe(hIniData,cIniFile) CLASS hbNFCeIniToXML
LOCAL oFuncoes := hbNFeFuncoes(), aRetorno := hash(), cDV, cChaveNFe, cQrCode,;
      oAssina, aRetornoAss, oValida, aRetornoVal,;
      nICob, nNICob, nItem, nNItem, nObs, nAdi, nDI, mI, mY
LOCAL nItnRef:=0      
LOCAL aMSGvld:={}
LOCAL cOBSFISCO:='', cOBSADICIONAL:='', cUTC:=''
LOCAL lERRO:=.F.

   aRetorno['OK'] := .T. 
	 

   cChaveNFe := ::ohbNFe:empresa_UF + ;
             oFuncoes:FormatDate(CTOD(hIniData['Identificacao']['Emissao']),"YYMM","") + ;
             PADL(ALLTRIM(hIniData['Emitente']['CNPJ']),14,'0') + ;
             STRZERO( VAL(hIniData['Identificacao']['Modelo']), 2) + ;
             STRZERO( VAL(hIniData['Identificacao']['Serie']), 3) + ;
             STRZERO( VAL(hIniData['Identificacao']['Numero']), 9) + ;
             ALLTRIM(hIniData['Identificacao']['tpEmis']) + ;
             STRZERO( VAL(hIniData['Identificacao']['Codigo']), 8)

   cDV := oFuncoes:modulo11( cChaveNFe, 2, 9 )
   cChaveNFe += cDV
   aRetorno['cChaveNFe'] := cChaveNFe

   ::aIde := hash()
  	::aIde[ "cUF" ] := ::ohbNFe:empresa_UF
  	::aIde[ "cNF" ] := STRZERO(VAL(hIniData['Identificacao']['Codigo']),8)
   ::aIde[ "natOp" ] := oFuncoes:parseEncode( hIniData['Identificacao']['NaturezaOperacao'] )
  	::aIde[ "indPag" ] := hIniData['Identificacao']['FormaPag']
  	::aIde[ "mod" ] := hIniData['Identificacao']['Modelo']
  	::aIde[ "serie" ] := hIniData['Identificacao']['Serie']
  	::aIde[ "nNF" ] := ALLTRIM(STR(VAL(hIniData['Identificacao']['Numero'])))
   // Guilherme Espeschit - 04/12/2014
   IF ::ohbNFe:versaoDados='3.10'     
      TRY
         ::aIde[ "hSaiEnt" ] := hIniData['Identificacao']['hSaiEnt']
      CATCH
         ::aIde[ "hSaiEnt" ] := TIME()
      END
        
        ::aIde[ "dEmi" ] := oFuncoes:FormatDate(CTOD(hIniData['Identificacao']['Emissao']),"YYYY-MM-DDThh:mm:ss","-",::ohbNFe:cUTC,::aIde[ "hSaiEnt" ])
   ELSE
	     ::aIde[ "dEmi" ] := oFuncoes:FormatDate(CTOD(hIniData['Identificacao']['Emissao']),"YYYY-MM-DD","-")
   ENDIF


      TRY
	    	::aIde[ "tpNF" ] := hIniData['Identificacao']['Tipo']
      CATCH
         ::aIde[ "tpNF" ] := '1'
      END


   IF ::ohbNFe:versaoDados='3.10'

      TRY
	      ::aIde[ "idDest" ] := hIniData['Identificacao']['idDEst']
      CATCH
         ::aIde[ "idDest" ] := '1'
      END
   ENDIF
  	::aIde[ "cMunFG" ] := hIniData['Emitente']['CidadeCod'] //::ohbNFe:empresa_cMun // codigo ibge empresa
   
   // NOTAS REFERENCIADAS   - Mauricio Cruz - 18/01/2012
    ::aRefNfe:=hash()
   WHILE .T.
      nItnRef++
      
      TRY
         ::aRefNfe['refNF'+STRZERO(nItnRef,3)]  := hIniData['NFRef'+STRZERO(nItnRef,3)]['Tipo']
      CATCH
         nItnRef--
         EXIT
      END
      ::aRefNfe['refNFe'+STRZERO(nItnRef,3)] := hIniData['NFRef'+STRZERO(nItnRef,3)]['refNFe']
      IF !hIniData['NFRef'+STRZERO(nItnRef,3)]['Tipo']='NFe'
         ::aRefNfe['refNF'+STRZERO(nItnRef,3)]  := '1A'
      ENDIF
	  TRY
         ::aRefNfe['cUF'+STRZERO(nItnRef,3)]    := hIniData['NFRef'+STRZERO(nItnRef,3)]['cUF']
         ::aRefNfe['AAMM'+STRZERO(nItnRef,3)]   := hIniData['NFRef'+STRZERO(nItnRef,3)]['AAMM']
         ::aRefNfe['CNPJ'+STRZERO(nItnRef,3)]   := hIniData['NFRef'+STRZERO(nItnRef,3)]['CNPJ']
         ::aRefNfe['mod'+STRZERO(nItnRef,3)]    := hIniData['NFRef'+STRZERO(nItnRef,3)]['Modelo']
         ::aRefNfe['serie'+STRZERO(nItnRef,3)]  := hIniData['NFRef'+STRZERO(nItnRef,3)]['Serie']
         ::aRefNfe['nNF'+STRZERO(nItnRef,3)]    := hIniData['NFRef'+STRZERO(nItnRef,3)]['nNF']
     CATCH 
     END 		 
   ENDDO
 

	::aIde[ "tpImp" ] := IF(::aIde[ "mod" ]='55',::ohbNFe:empresa_tpImp, '4' )     // 1 - retrato 2-paisagem  ||  4 - NFC-e
	::aIde[ "tpEmis" ] := hIniData['Identificacao']['tpEmis']  // 1-normal scan fsda...
     
   IF VAL(::aIde[ "tpEmis" ])=3 .OR. VAL(::aIde[ "tpEmis" ])=5 .OR. VAL(::aIde[ "tpEmis" ])=6 .OR. VAL(::aIde[ "tpEmis" ])=7 .OR. VAL(::aIde[ "tpEmis" ])=9 // SE FOR MODO SCAN / SVC...
//      ::aIde[ "dhCont" ] := ALLTRIM(STR(YEAR(CTOD(hIniData['Identificacao']['dhCont']))))+'-'+;
//                            ALLTRIM(STRZERO( MONTH(CTOD(hIniData['Identificacao']['dhCont'])),2 ))+'-'+;
//                            ALLTRIM(STRZERO( DAY(CTOD(hIniData['Identificacao']['dhCont'])),2 )) +'T'+;
//                            ALLTRIM(hIniData['Identificacao']['contHr'])+IIF(::ohbNFe:versaoDados='3.10',::ohbNFe:cUTC,'')

	  TRY
      ::aIde[ "dhCont" ] := oFuncoes:FormatDate(CTOD(hIniData['Identificacao']['dhCont']),"YYYY-MM-DDThh:mm:ss","-",::ohbNFe:cUTC,::aIde[ "hSaiEnt" ])
     CATCH 
      ::aIde[ "dhCont" ] := oFuncoes:FormatDate((DATE()),"YYYY-MM-DDThh:mm:ss","-",::ohbNFe:cUTC,::aIde[ "hSaiEnt" ])
     END 		 

	  TRY
      ::aIde[ "xJust" ] :=   hIniData['Identificacao']['xJust']
     CATCH 
      ::aIde[ "xJust" ] :=  'Sem acesso a internet'
     END 		 
   ENDIF
  
	::aIde[ "cDV" ] := cDV // Digito verificador chave nfe
	::aIde[ "tpAmb" ] := ::ohbNFe:tpAmb // 1- producao 2-homologacao                     
	IF hIniData['Identificacao']['Finalidade'] = '0'
	   ::aIde[ "finNFe" ] := '1'
	ELSE
   	::aIde[ "finNFe" ] := hIniData['Identificacao']['Finalidade'] // finalidade 1-normal/ 2-complementar/ 3- de ajuste \ 4-DEVOLUCAO
   ENDIF
   
   IF ::ohbNFe:versaoDados='3.10'   
      ::aIde[ "indFinal" ] := hIniData['Identificacao']['indFinal']  
      ::aIde[ "indPres" ] := hIniData['Identificacao']['indPres']  
   ENDIF
	::aIde[ "procEmi" ] := '0' //0 - emissão de NF-e com aplicativo do contribuinte 1 - emissão de NF-e avulsa pelo Fisco 2 - emissão de NF-e avulsa pelo contribuinte com seu certificado digital, através do site do Fisco 3- emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
	::aIde[ "verProc" ] := ::ohbNFe:versaoSistema // versao sistema


 ::aEmit := hash()
	::aEmit[ "CNPJ" ] := hIniData['Emitente']['CNPJ']
	::aEmit[ "CPF" ] := '' // avulso pelo fisco
 ::aEmit[ "xNome" ] := oFuncoes:parseEncode( hIniData['Emitente']['Razao'] )
	::aEmit[ "xFant" ] := oFuncoes:parseEncode( hIniData['Emitente']['Fantasia'] )
	::aEmit[ "xLgr" ] := oFuncoes:parseEncode( hIniData['Emitente']['Logradouro'] )
	::aEmit[ "nro" ] := hIniData['Emitente']['Numero']
	::aEmit[ "xCpl" ] := oFuncoes:parseEncode( hIniData['Emitente']['Complemento'] )
	::aEmit[ "xBairro" ] := oFuncoes:parseEncode( hIniData['Emitente']['Bairro'] )
   ::aEmit[ "cMun" ] := hIniData['Emitente']['CidadeCod']
	::aEmit[ "xMun" ] := oFuncoes:parseEncode( hIniData['Emitente']['Cidade'] )
	::aEmit[ "UF" ] := hIniData['Emitente']['UF']
	::aEmit[ "CEP" ] := hIniData['Emitente']['CEP']
	TRY
    	::aEmit[ "cPais" ] := hIniData['Emitente']['PaisCod']
    	::aEmit[ "xPais" ] := hIniData['Emitente']['Pais']
	CATCH
   	::aEmit[ "cPais" ] := '1058'
    	::aEmit[ "xPais" ] := 'BRASIL'
	END
   TRY
	   ::aEmit[ "fone" ] := oFuncoes:eliminaString(hIniData['Emitente']['Fone'], ".-/ ()")
   CATCH
      ::aEmit[ "fone" ] := ''
   END
	::aEmit[ "IE" ] := oFuncoes:eliminaString(hIniData['Emitente']['IE'], ".-/ ")
	TRY
   	::aEmit[ "IEST" ] := hIniData['Emitente']['IEST']
	CATCH
   	::aEmit[ "IEST" ] := ''
	END
	TRY
   	::aEmit[ "IM" ] := hIniData['Emitente']['IM']
	CATCH
   	::aEmit[ "IM" ] := ''
	END
	TRY
   	::aEmit[ "CNAE" ] := hIniData['Emitente']['CNAE']
	CATCH
   	::aEmit[ "CNAE" ] := ''
	END
	TRY
   	::aEmit[ "CRT" ] := hIniData['Emitente']['CRT']
	CATCH
   	::aEmit[ "CRT" ] := '1'
	END


	//ATENÇÃO: Só vai preencher os campos se tiver dados
   TRY
   ::aDest := hash()
   IF LEN( hIniData['Destinatario']['CNPJ'] ) <= 11 .AND. hIniData['Destinatario']['UF'] <>'EX'  // Mauricio Cruz - 03/10/2011
   	::aDest[ "CPF" ] := hIniData['Destinatario']['CNPJ'] 
   ELSE
   	::aDest[ "CNPJ" ] := hIniData['Destinatario']['CNPJ']
   ENDIF
   IF ::ohbNFe:tpAmb='2' .AND. hIniData['Destinatario']['UF'] <>'EX'   // Mauricio Cruz - 03/10/2011
      //::aDest[ "CNPJ" ] := '99999999000191'
   ENDIF
   
   IF ::ohbNFe:tpAmb='2'    // Mauricio Cruz - 30/09/2011
      ::aDest[ "xNome" ] := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
   ELSE
      ::aDest[ "xNome" ] := oFuncoes:parseEncode( hIniData['Destinatario']['NomeRazao'] )
   ENDIF

	::aDest[ "xLgr" ] := oFuncoes:parseEncode( hIniData['Destinatario']['Logradouro'] )

	IF !EMPTY( hIniData['Destinatario']['Numero'] )
   	::aDest[ "nro" ] := hIniData['Destinatario']['Numero']
   ELSE
   	::aDest[ "nro" ] := '0'
   ENDIF


	::aDest[ "xBairro" ] := oFuncoes:parseEncode( hIniData['Destinatario']['Bairro'] )
   IF hIniData['Destinatario']['UF']='EX'
	   ::aDest[ "cMun" ] := '9999999'
   ELSE
      ::aDest[ "cMun" ] := hIniData['Destinatario']['CidadeCod']
   ENDIF

	::aDest[ "xMun" ] := oFuncoes:parseEncode( hIniData['Destinatario']['Cidade'] )
	::aDest[ "UF" ] := hIniData['Destinatario']['UF']
   IF !EMPTY(hIniData['Destinatario']['CEP']) .AND. hIniData['Destinatario']['UF'] <>'EX'  // Mauricio Cruz - 04/10/2011 (Motivo de exportacao)
	   ::aDest[ "CEP" ] := hIniData['Destinatario']['CEP']
   ENDIF
	TRY
	   IF !EMPTY( hIniData['Destinatario']['PaisCod'] )
      	::aDest[ "cPais" ] := hIniData['Destinatario']['PaisCod']
      	::aDest[ "xPais" ] := hIniData['Destinatario']['Pais']
      ELSE
      	::aDest[ "cPais" ] := '1058'
      	::aDest[ "xPais" ] := 'BRASIL'
      ENDIF
	CATCH
   	::aDest[ "cPais" ] := '1058'
    	::aDest[ "xPais" ] := 'BRASIL'
	END

	::aDest[ "xCpl" ] := oFuncoes:parseEncode( hIniData['Destinatario']['Complemento'] )

	CATCH ///fim dos dados do cliente
	END

	::aRetirada := hash()
	TRY
    	::aRetirada[ "CNPJ" ]    := hIniData['Retirada']['CNPJ']
    	::aRetirada[ "CPF" ]     := hIniData['Retirada']['CPF']
    	::aRetirada[ "xLgr" ]    := oFuncoes:parseEncode( hIniData['Retirada']['xLgr'] )
    	::aRetirada[ "nro" ]     := hIniData['Retirada']['nro']
    	::aRetirada[ "xCpl" ]    := oFuncoes:parseEncode( hIniData['Retirada']['xCpl'] )
    	::aRetirada[ "xBairro" ] := oFuncoes:parseEncode( hIniData['Retirada']['xBairro'] )
    	::aRetirada[ "cMun" ]    := hIniData['Retirada']['cMun']
    	::aRetirada[ "xMun" ]    := oFuncoes:parseEncode( hIniData['Retirada']['xMun'] )
    	::aRetirada[ "UF" ]      := hIniData['Retirada']['UF']
	CATCH
	END

	::aEntrega := hash()
	TRY
      TRY
    	   ::aEntrega[ "CNPJ" ]    := hIniData['Entrega']['CNPJ']
      CATCH
         ::aEntrega[ "CNPJ" ]    := ''
      END
      TRY
    	   ::aEntrega[ "CPF" ]     := hIniData['Entrega']['CPF']
      CATCH
         ::aEntrega[ "CPF" ]     := ''
      END
    	::aEntrega[ "xLgr" ]    := oFuncoes:parseEncode( hIniData['Entrega']['xLgr'] )
    	::aEntrega[ "nro" ]     := hIniData['Entrega']['nro']
    	::aEntrega[ "xCpl" ]    := oFuncoes:parseEncode( hIniData['Entrega']['xCpl'] )
    	::aEntrega[ "xBairro" ] := oFuncoes:parseEncode( hIniData['Entrega']['xBairro'] )
    	::aEntrega[ "cMun" ]    := hIniData['Entrega']['cMun']
    	::aEntrega[ "xMun" ]    := oFuncoes:parseEncode( hIniData['Entrega']['xMun'] )
    	::aEntrega[ "UF" ]      := hIniData['Entrega']['UF']
	CATCH
	END
   
   
   // grupo autXML
   IF ::ohbNFe:versaoDados='3.10'
      ::autXML:={}  // HASH()
      nItem := 0
      DO WHILE .T.
         nItem ++
         TRY
            AADD(::autXML,{'CNPJ',hIniData['autXML'+STRZERO(nItem,3)]['CNPJ']})
            //::autXML[ "autXML"+STRZERO(nItem,3)+"_CNPJ" ] := hIniData['autXML'+STRZERO(nItem,3)]['CNPJ']
         CATCH
            TRY
               AADD(::autXML,{'CPF',hIniData['autXML'+STRZERO(nItem,3)]['CPF']})
               //::autXML[ "autXML"+STRZERO(nItem,3)+"_CPF" ] := hIniData['autXML'+STRZERO(nItem,3)]['CPF']
            CATCH
               nItem --
               EXIT
            END
         END
      ENDDO   
   ENDIF
   
 	::aItem := hash()
 	::aItemDI := hash()
  	::aItemAdi := hash()
 	::aItemICMS := hash()
  	::aItemIPI := hash()
  	::aItemII := hash()
  	::aItemPIS := hash()
  	::aItemPISST := hash()
	::aItemCOFINS := hash()
	::aItemCOFINSST := hash()
	::aItemICMSUFDest := hash()
	::aItemCOMB := hash()
		
   nItem := 0
   DO WHILE .T.
      nItem ++
    	TRY
       	::aItem[ "item"+STRZERO(nItem,3)+"_cProd" ] := hIniData['Produto'+STRZERO(nItem,3)]['Codigo']
    	CATCH
    	   nItem --
       	EXIT
    	END

    	TRY
       	::aItem[ "item"+STRZERO(nItem,3)+"_cEAN" ]     := hIniData['Produto'+STRZERO(nItem,3)]['EAN']
    	CATCH
       	::aItem[ "item"+STRZERO(nItem,3)+"_cEAN" ]     := ''
    	END
    	::aItem[ "item"+STRZERO(nItem,3)+"_xProd" ]    := oFuncoes:parseEncode( hIniData['Produto'+STRZERO(nItem,3)]['Descricao'] )
    	::aItem[ "item"+STRZERO(nItem,3)+"_NCM" ]      := hIniData['Produto'+STRZERO(nItem,3)]['NCM']
    	TRY
       	::aItem[ "item"+STRZERO(nItem,3)+"_EXTIPI" ]   := hIniData['Produto'+STRZERO(nItem,3)]['EXTIPI']
    	CATCH
    	END

    	TRY
       	::aItem[ "item"+STRZERO(nItem,3)+"_CEST" ]     := hIniData['Produto'+STRZERO(nItem,3)]['CEST']
    	CATCH
       	::aItem[ "item"+STRZERO(nItem,3)+"_CEST" ]     := ''
    	END

    	::aItem[ "item"+STRZERO(nItem,3)+"_CFOP" ]     := hIniData['Produto'+STRZERO(nItem,3)]['CFOP']
    	::aItem[ "item"+STRZERO(nItem,3)+"_uCom" ]     := hIniData['Produto'+STRZERO(nItem,3)]['Unidade']
    	::aItem[ "item"+STRZERO(nItem,3)+"_qCom" ]     := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['Quantidade'] , 4 )
    	::aItem[ "item"+STRZERO(nItem,3)+"_vUnCom" ]   := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['ValorUnitario'], 10 )
    	::aItem[ "item"+STRZERO(nItem,3)+"_vProd" ]    := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['ValorTotal'] )
    	TRY
       	::aItem[ "item"+STRZERO(nItem,3)+"_cEANTrib" ] := hIniData['Produto'+STRZERO(nItem,3)]['cEANTrib']
    	CATCH
       	::aItem[ "item"+STRZERO(nItem,3)+"_cEANTrib" ] := ''
    	END
    	TRY
       	::aItem[ "item"+STRZERO(nItem,3)+"_uTrib" ]    := hIniData['Produto'+STRZERO(nItem,3)]['uTrib']
      CATCH
       	::aItem[ "item"+STRZERO(nItem,3)+"_uTrib" ]    := hIniData['Produto'+STRZERO(nItem,3)]['Unidade']
     END
    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"_qTrib" ]    := hIniData['Produto'+STRZERO(nItem,3)]['Quantidade']
      CATCH
      	::aItem[ "item"+STRZERO(nItem,3)+"_qTrib" ]    := '0.00'
     END
    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"nFCI" ]    := hIniData['Produto'+STRZERO(nItem,3)]['nFCI']
      CATCH
     END
    	TRY
       	::aItem[ "item"+STRZERO(nItem,3)+"_vUnTrib" ]  := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['vUnTrib'] )
      CATCH
       	::aItem[ "item"+STRZERO(nItem,3)+"_vUnTrib" ]  := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['ValorUnitario'], 10 )
     END
    	TRY
       	::aItem[ "item"+STRZERO(nItem,3)+"_vFrete" ]   := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['vFrete'] )
    	CATCH
    	END
    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"_vSeg" ]     := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['vSeg'] )
    	CATCH
    	END
    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"_vDesc" ]    := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['ValorDesconto'] )
    	CATCH
    	END
    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"_vOutro" ]   := oFuncoes:strTostrval( hIniData['Produto'+STRZERO(nItem,3)]['vOutro'] )
    	CATCH
    	END
    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"_indTot" ]   := hIniData['Produto'+STRZERO(nItem,3)]['IndTot']
    	CATCH
      	::aItem[ "item"+STRZERO(nItem,3)+"_indTot" ]   := '1'
    	END
    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"_infAdProd" ]   := hIniData['Produto'+STRZERO(nItem,3)]['infAdProd']
    	CATCH
    	END

    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"_xPed" ]     := hIniData['Produto'+STRZERO(nItem,3)]['xPed']
    	CATCH
    	END
    	TRY
      	::aItem[ "item"+STRZERO(nItem,3)+"_nItemPed" ] := hIniData['Produto'+STRZERO(nItem,3)]['nItemPed']
    	CATCH
    	END
  
      TRY 
	     	::aItemCOMB[ "item"+STRZERO(nItem,3)+"_cProdANP" ] := hIniData['comb'+STRZERO(nItem,3)]['cProdANP']
			::aItemCOMB[ "item"+STRZERO(nItem,3)+"_CODIF" ] := hIniData['comb'+STRZERO(nItem,3)]['CODIF']
			::aItemCOMB[ "item"+STRZERO(nItem,3)+"_qTemp" ] := oFuncoes:strTostrval( hIniData['comb'+STRZERO(nItem,3)]['qTemp'] , 4 )			
			::aItemCOMB[ "item"+STRZERO(nItem,3)+"_UFCons" ] := hIniData['comb'+STRZERO(nItem,3)]['UFCons']		   
		CATCH
		END

  
      nDi := 0
      DO WHILE .T.
         nDi ++
        	TRY
            // alterado -> Mauricio Cruz - 04/10/2011
           	//::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_nDI" ] := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['nDI']
            ::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_nDI" ] := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['NumeroDI']   
        	CATCH
        	   nDi --
           	EXIT
        	END
         /* alterado -> Mauricio Cruz - 04/10/2011
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_dDI" ]         := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['dDI']
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_xLocDesemb" ]  := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['xLocDesemb']
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_UFDesemb" ]    := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['UFDesemb']
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_dDesemb" ]     := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['dDesemb']
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_cExportador" ] := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['cExportador']
         */
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_dDI" ]         := STR(YEAR(CTOD(hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['DataRegistroDI'])),4)+'-'+;
                                                                               STRZERO(MONTH(CTOD(hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['DataRegistroDI'])),2)+'-'+; 
                                                                               STRZERO(DAY(CTOD(hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['DataRegistroDI'])),2)
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_xLocDesemb" ]  := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['LocalDesembaraco']
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_UFDesemb" ]    := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['UFDesembaraco']
      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_dDesemb" ]     := STR(YEAR(CTOD(hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['DataDesembaraco'])),4)+'-'+;
                                                                               STRZERO(MONTH(CTOD(hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['DataDesembaraco'])),2)+'-'+; 
                                                                               STRZERO(DAY(CTOD(hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['DataDesembaraco'])),2)
                                                                               
       IF ::ohbNFe:versaoDados='3.10'
          ::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_tpViaTransp" ]  := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['tpViaTransp']
          ::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_vAFRMM" ]       := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['vAFRMM']
          ::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_tpIntermedio" ] := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['tpIntermedio']
          ::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_CNPJ" ]         := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['CNPJ']
          ::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_UFTerceiro" ]   := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['UFTerceiro']
       ENDIF

      	::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+"_cExportador" ] := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)]['CodigoExportador']
         

         nAdi := 0
         DO WHILE .T.
            nAdi++  //  nDi ++  Mauricio Cruz - 04/10/2011
          	TRY
               //alterado -> Mauricio Cruz - 04/10/2011
             	//::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_nAdicao" ] := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)]['nAdicao']
               ::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_nAdicao" ] := hIniData['LADI'+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)]['NumeroAdicao']
          	CATCH
          	   nAdi--   //nDi --  Mauricio Cruz - 04/10/2011
             	EXIT
          	END
            /*  alterado -> Mauricio Cruz - 04/10/2011
          	::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_nSeqAdic" ] := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)]['nSeqAdic']
          	::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_cFabricante" ] := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)]['cFabricante']
          	::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_vDescDI" ]     := hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)]['vDescDI']
            */

          	::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_nSeqAdic" ] := ALLTRIM(STR(nAdi))    //hIniData['DI'+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)]['nSeqAdic']
          	::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_cFabricante" ] := hIniData['LADI'+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)]['CodigoFabricante']
          	::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_vDescDI" ]     := hIniData['LADI'+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)]['DescontoADI']
         ENDDO
      ENDDO

      IF ::lMostra_imp_danfe
         TRY // valor aproximado do imposto
            ::aItemICMS[ "item"+STRZERO(nItem,3)+"vTotTrib" ] := hIniData['IMPOSTO'+STRZERO(nItem,3)]['vTotTrib']
         CATCH
            ::aItemICMS[ "item"+STRZERO(nItem,3)+"vTotTrib" ] := '0.00'
         END
      ENDIF

      TRY
         IF !EMPTY( hIniData['ICMS'+STRZERO(nItem,3)]['orig'] )
            ::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ]     := hIniData['ICMS'+STRZERO(nItem,3)]['orig']
         ELSE
            ::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ]     := '0'  // deixei vazio para dar erro caso informe
         ENDIF
      CATCH
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ]        := '0'  // deixei vazio para dar erro caso informe
      END

      IF ::aEmit[ "CRT" ] == '3'
        	::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ]       := ''
      	TRY
         	::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ]         := hIniData['ICMS'+STRZERO(nItem,3)]['CST']
      	CATCH
      	END
      ELSE
        	::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ]         := ''
      	TRY
         	::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ]       := hIniData['ICMS'+STRZERO(nItem,3)]['CSOSN']
      	CATCH
      	END
      ENDIF
    	TRY
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ]       := hIniData['ICMS'+STRZERO(nItem,3)]['Modalidade']
    	CATCH
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ]       := '0'
    	END
    	TRY
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ]      := hIniData['ICMS'+STRZERO(nItem,3)]['PercentualReducao']
    	CATCH
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ]      := '0.00'
    	END
    	TRY
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ]         := hIniData['ICMS'+STRZERO(nItem,3)]['ValorBase']
    	CATCH
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ]         := '0.00'
    	END
    	TRY
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ]       := hIniData['ICMS'+STRZERO(nItem,3)]['Aliquota']
    	CATCH
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ]       := '0.00'
    	END

      TRY
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSOp" ]   := hIniData['ICMS'+STRZERO(nItem,3)]['vICMSOp']
      CATCH
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSOp" ]   := '0.00'
      END
      TRY
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_pDif" ]      := hIniData['ICMS'+STRZERO(nItem,3)]['pDif']
      CATCH
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_pDif" ]      := '0.00'
      END
      TRY
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSDif" ]  := hIniData['ICMS'+STRZERO(nItem,3)]['vICMSDif']
      CATCH
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSDif" ]  := '0.00'
      END
      
    	TRY
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ]       := hIniData['ICMS'+STRZERO(nItem,3)]['Valor']
    	CATCH
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ]       := '0.00'
    	END
    	TRY
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ]     := hIniData['ICMS'+STRZERO(nItem,3)]['ModalidadeST']
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ]      := hIniData['ICMS'+STRZERO(nItem,3)]['PercentualMargemST']
    	CATCH
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ]     := '0'
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ]      := '0.00'
    	END
    	TRY
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ]    := hIniData['ICMS'+STRZERO(nItem,3)]['PercentualReducaoST']
    	CATCH    
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ]    := '0.00'    // Mauricio Cruz - 04/10/2011
    	END
    	TRY
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ]       := hIniData['ICMS'+STRZERO(nItem,3)]['ValorBaseST']
      CATCH
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ]       := '0.00'
      END
      TRY
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ]     := hIniData['ICMS'+STRZERO(nItem,3)]['AliquotaST']
      CATCH
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ]     := '0.00'
      END
      TRY
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ]     := hIniData['ICMS'+STRZERO(nItem,3)]['ValorST']
      CATCH
         ::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ]     := '0.00'
      END
      TRY
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_UFST" ]        := hIniData['ICMS'+STRZERO(nItem,3)]['UFST']
    	CATCH
       	::aItemICMS[ "item"+STRZERO(nItem,3)+"_UFST" ]        := '0.00'
    	END
    	TRY
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pBCOp" ]       := hIniData['ICMS'+STRZERO(nItem,3)]['pBCOp']
    	CATCH
    	END
    	TRY
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCSTRet" ]    := hIniData['ICMS'+STRZERO(nItem,3)]['vBCSTRet']
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSSTRet" ]  := hIniData['ICMS'+STRZERO(nItem,3)]['vICMSSTRet']
    	CATCH
      	TRY
         	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCSTRet" ]    := hIniData['ICMS'+STRZERO(nItem,3)]['vBCSTret']
         	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSSTRet" ]  := hIniData['ICMS'+STRZERO(nItem,3)]['vICMSSTret']
      	CATCH
      	END
    	END
    	TRY
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_motDesICMS" ]  := hIniData['ICMS'+STRZERO(nItem,3)]['motDesICMS']
    	CATCH
    	END
    	TRY
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pCredSN" ]     := hIniData['ICMS'+STRZERO(nItem,3)]['pCredSN']
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vCredICMSSN" ] := hIniData['ICMS'+STRZERO(nItem,3)]['vCredICMSSN']
    	CATCH
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_pCredSN" ]     := '0.00'
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vCredICMSSN" ] := '0.00'
    	END
    	TRY
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCSTDest" ]   := hIniData['ICMS'+STRZERO(nItem,3)]['vBCSTDest']
      	::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSSTDest" ] := hIniData['ICMS'+STRZERO(nItem,3)]['vICMSSTDest']
    	CATCH
    	END

     	TRY
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_clEnq" ]    := hIniData['IPI'+STRZERO(nItem,3)]['ClasseEnquadramento']
      CATCH
      END
     	TRY
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_CNPJProd" ] := hIniData['IPI'+STRZERO(nItem,3)]['CNPJProdutor']
      CATCH
      END
     	TRY
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_cSelo" ]    := hIniData['IPI'+STRZERO(nItem,3)]['CodigoSeloIPI']
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_qSelo" ]    := hIniData['IPI'+STRZERO(nItem,3)]['QuantidadeSelos']
      CATCH
      END
     	TRY
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_cEnq" ]     := hIniData['IPI'+STRZERO(nItem,3)]['CodigoEnquadramento']
      CATCH
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_cEnq" ]     := '999'
      END

     	TRY
       	::aItemIPI[ "item"+STRZERO(nItem,3)+"_CST" ]   := hIniData['IPI'+STRZERO(nItem,3)]['CST']
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_vBC" ]   := hIniData['IPI'+STRZERO(nItem,3)]['ValorBase']
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_pIPI" ]  := hIniData['IPI'+STRZERO(nItem,3)]['Aliquota']
      CATCH
      END
     	TRY
       	::aItemIPI[ "item"+STRZERO(nItem,3)+"_qUnid" ] := hIniData['IPI'+STRZERO(nItem,3)]['Quantidade']
      CATCH
      END
     	TRY
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_vUnid" ] := hIniData['IPI'+STRZERO(nItem,3)]['ValorUnidade']
      CATCH
      END
     	TRY
      	::aItemIPI[ "item"+STRZERO(nItem,3)+"_vIPI" ]  := hIniData['IPI'+STRZERO(nItem,3)]['Valor']
      CATCH
      END

     	TRY
      	::aItemII[ "item"+STRZERO(nItem,3)+"_vBC" ]      := hIniData['II'+STRZERO(nItem,3)]['ValorBase']
      	::aItemII[ "item"+STRZERO(nItem,3)+"_vDespAdu" ] := hIniData['II'+STRZERO(nItem,3)]['ValorDespAduaneiras']
      	::aItemII[ "item"+STRZERO(nItem,3)+"_vII" ]      := hIniData['II'+STRZERO(nItem,3)]['ValorII']
      	::aItemII[ "item"+STRZERO(nItem,3)+"_vIOF" ]     := hIniData['II'+STRZERO(nItem,3)]['ValorIOF']
      CATCH
      END

      TRY
      	::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] := hIniData['PIS'+STRZERO(nItem,3)]['CST']
      	IF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02'
         	::aItemPIS[ "item"+STRZERO(nItem,3)+"_vBC" ]  := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['ValorBase'] )
         	::aItemPIS[ "item"+STRZERO(nItem,3)+"_pPIS" ] := hIniData['PIS'+STRZERO(nItem,3)]['Aliquota']
      	   ::aItemPIS[ "item"+STRZERO(nItem,3)+"_vPIS" ] := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['Valor'] )
      	ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '03'
         	::aItemPIS[ "item"+STRZERO(nItem,3)+"_qBCProd" ]   := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['Quantidade'], 4 )
         	::aItemPIS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ] := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['ValorAliquota'], 4 )
      	   ::aItemPIS[ "item"+STRZERO(nItem,3)+"_vPIS" ]      := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['Valor'] )
      	ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99,49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98'
         	::aItemPIS[ "item"+STRZERO(nItem,3)+"_vBC" ]       := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['ValorBase'] )
         	::aItemPIS[ "item"+STRZERO(nItem,3)+"_vPIS" ]      := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['Valor'] )
           TRY
           	::aItemPIS[ "item"+STRZERO(nItem,3)+"_qBCProd" ]   := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['Quantidade'], 4)
           CATCH
           END
           TRY
           	::aItemPIS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ] := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['ValorAliquota'], 4 )
           CATCH
           END
           TRY
         	   ::aItemPIS[ "item"+STRZERO(nItem,3)+"_pPIS" ]      := oFuncoes:strTostrval( hIniData['PIS'+STRZERO(nItem,3)]['Aliquota'] )
           CATCH
         	   ::aItemPIS[ "item"+STRZERO(nItem,3)+"_pPIS" ]      := '0.00'
           END
        ENDIF
      CATCH
      	::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] := '99'
      	::aItemPIS[ "item"+STRZERO(nItem,3)+"_vBC" ]  := '0.00'
        	::aItemPIS[ "item"+STRZERO(nItem,3)+"_pPIS" ] := '0.00'
     	   ::aItemPIS[ "item"+STRZERO(nItem,3)+"_vPIS" ] := '0.00'
      END

     	TRY
      	::aItemPISST[ "vBC" ]       := hIniData['PISST'+STRZERO(nItem,3)]['ValorBase']
      	::aItemPISST[ "pPIS" ]      := hIniData['PISST'+STRZERO(nItem,3)]['AliquotaPerc']
      	::aItemPISST[ "vPIS" ]      := hIniData['PISST'+STRZERO(nItem,3)]['ValorPISST']
      	::aItemPISST[ "qBCProd" ]   := hIniData['PISST'+STRZERO(nItem,3)]['Quantidade']
      	::aItemPISST[ "vAliqProd" ] := hIniData['PISST'+STRZERO(nItem,3)]['AliquotaValor']
      CATCH
      END

     	TRY
        	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] := hIniData['COFINS'+STRZERO(nItem,3)]['CST']
        	IF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02'
          	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vBC" ]     := hIniData['COFINS'+STRZERO(nItem,3)]['ValorBase']
          	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_pCOFINS" ] := hIniData['COFINS'+STRZERO(nItem,3)]['Aliquota']
          	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vCOFINS" ] := oFuncoes:strTostrval( hIniData['COFINS'+STRZERO(nItem,3)]['Valor'] )
        	ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '03'
          	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_qBCProd" ]   := hIniData['COFINS'+STRZERO(nItem,3)]['Quantidade']
          	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ] := hIniData['COFINS'+STRZERO(nItem,3)]['ValorAliquota']
          	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vCOFINS" ]   := oFuncoes:strTostrval( hIniData['COFINS'+STRZERO(nItem,3)]['Valor'] )
        	ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99,49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98'
          	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vBC" ]       := oFuncoes:strTostrval( hIniData['COFINS'+STRZERO(nItem,3)]['ValorBase'] )
          	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vCOFINS" ]   := oFuncoes:strTostrval( hIniData['COFINS'+STRZERO(nItem,3)]['Valor'] )
             TRY
             	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_qBCProd" ]   := hIniData['COFINS'+STRZERO(nItem,3)]['Quantidade']
             CATCH
             END
             TRY
          	   ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ] := hIniData['COFINS'+STRZERO(nItem,3)]['ValorAliquota']
             CATCH
             END
             TRY
             	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_pCOFINS" ]   := oFuncoes:strTostrval( hIniData['COFINS'+STRZERO(nItem,3)]['Aliquota'] )
             CATCH
             	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_pCOFINS" ]   := '0.00'
             END
        	ENDIF
      CATCH
        	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ]     := '99'
        	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vBC" ]     := '0.00'
        	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_pCOFINS" ] := '0.00'
        	::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vCOFINS" ] := '0.00'
      END

     	TRY
      	::aItemCOFINSST[ "vBC" ] := hIniData['COFINSST'+STRZERO(nItem,3)]['ValorBase']
      	::aItemCOFINSST[ "pCOFINS" ] := hIniData['COFINSST'+STRZERO(nItem,3)]['AliquotaPerc']
      	::aItemCOFINSST[ "vCOFINS" ] := hIniData['COFINSST'+STRZERO(nItem,3)]['ValorCOFINSST']
      	::aItemCOFINSST[ "qBCProd" ] := hIniData['COFINSST'+STRZERO(nItem,3)]['Quantidade']
      	::aItemCOFINSST[ "vAliqProd" ] := hIniData['COFINSST'+STRZERO(nItem,3)]['AliquotaValor']
      CATCH
      END

   ENDDO
   
 	// totais da NF
	::aICMSTotal := hash()
   TRY
	   ::aICMSTotal[ "vBC" ] := oFuncoes:strTostrval( hIniData['Total']['BaseICMS'] )
   CATCH
      ::aICMSTotal[ "vBC" ] := '0.00'
   END
   TRY
	   ::aICMSTotal[ "vICMS" ] := oFuncoes:strTostrval( hIniData['Total']['ValorICMS'] )
   CATCH
      ::aICMSTotal[ "vICMS" ] := '0.00'
   END
   
   ::aICMSTotal[ "vICMSDeson" ] := '0.00'  // SYGNFE  SOMAR AQUI O TOTAL DE DESONERACAO
   
   TRY
	   ::aICMSTotal[ "vBCST" ] := oFuncoes:strTostrval( hIniData['Total']['BaseICMSSubstituicao'] )
   CATCH
      ::aICMSTotal[ "vBCST" ] := '0.00'
   END
   TRY
	   ::aICMSTotal[ "vST" ] := oFuncoes:strTostrval( hIniData['Total']['ValorICMSSubstituicao'] )
   CATCH
      ::aICMSTotal[ "vST" ] := '0.00'
   END
   TRY
	   ::aICMSTotal[ "vProd" ] := oFuncoes:strTostrval( hIniData['Total']['ValorProduto'] )
   CATCH
      ::aICMSTotal[ "vProd" ] := '0.00'
   END
   TRY
	   ::aICMSTotal[ "vFrete" ] := oFuncoes:strTostrval( hIniData['Total']['ValorFrete'] )
   CATCH
      ::aICMSTotal[ "vFrete" ] := '0.00'
   END
  	TRY
    	::aICMSTotal[ "vSeg" ] := oFuncoes:strTostrval( hIniData['Total']['ValorSeguro'] )
   CATCH
    	::aICMSTotal[ "vSeg" ] := '0.00'
   END
  	TRY
   	::aICMSTotal[ "vDesc" ] := oFuncoes:strTostrval( hIniData['Total']['ValorDesconto'] )
   CATCH
   	::aICMSTotal[ "vDesc" ] := '0.00'
   END
  	TRY
   	::aICMSTotal[ "vII" ] := oFuncoes:strTostrval( hIniData['Total']['ValorII'] )
   CATCH
   	::aICMSTotal[ "vII" ] := '0.00'
   END
  	TRY
   	::aICMSTotal[ "vIPI" ] := oFuncoes:strTostrval( hIniData['Total']['ValorIPI'] )
   CATCH
   	::aICMSTotal[ "vIPI" ] := '0.00'
   END
  	TRY
   	::aICMSTotal[ "vPIS" ] := oFuncoes:strTostrval( hIniData['Total']['ValorPIS'] )
   CATCH
   	::aICMSTotal[ "vPIS" ] := '0.00'
   END
  	TRY
   	::aICMSTotal[ "vCOFINS" ] := oFuncoes:strTostrval( hIniData['Total']['ValorCOFINS'] )
   CATCH
   	::aICMSTotal[ "vCOFINS" ] := '0.00'
   END
  	TRY
   	::aICMSTotal[ "vOutro" ] := oFuncoes:strTostrval( hIniData['Total']['ValorOutrasDespesas'] )
   CATCH
   	::aICMSTotal[ "vOutro" ] := '0.00'
   END
   TRY
  	   ::aICMSTotal[ "vNF" ] := oFuncoes:strTostrval( hIniData['Total']['ValorNota'] )
   CATCH
      ::aICMSTotal[ "vNF" ] := '0.00'
*      SHOWMSG('Houve um erro ao tentar localizar o valor total da nota fiscal.')
*      IF _USUARIO()='SYGECOM'
*         SHOWMSG_EDIT(VALTOPRG(hIniData))
*      ENDIF
   END

   IF ::lMostra_imp_danfe
      ::aICMSTotal[ "vTotTrib" ] := oFuncoes:strTostrval( hIniData['Total']['vTotTrib'] )
   ENDIF

	::aISSTotal := hash()
	TRY
    	::aISSTotal[ "vServ" ] := hIniData['Total']['ValorServicos']
    	::aISSTotal[ "vBC" ] := hIniData['Total']['ValorBaseISS']
    	::aISSTotal[ "vISS" ] := hIniData['Total']['ValorISSQN']
    	::aISSTotal[ "vPIS" ] := hIniData['Total']['ValorPISISS']
    	::aISSTotal[ "vCOFINS" ] := hIniData['Total']['ValorCONFINSISS']
	CATCH
	END

	::aRetTrib := hash()
	TRY
    	::aRetTrib[ "vRetPIS" ] := hIniData['Total']['vRetPIS']
    	::aRetTrib[ "vRetCOFINS" ] := hIniData['Total']['vRetCOFINS']
    	::aRetTrib[ "vRetCSLL" ] := hIniData['Total']['vRetCSLL']
    	::aRetTrib[ "vBCIRRF" ] := hIniData['Total']['vBCIRRF']
    	::aRetTrib[ "vIRRF" ] := hIniData['Total']['vIRRF']
    	::aRetTrib[ "vBCRetPrev" ] := hIniData['Total']['vBCRetPrev']
    	::aRetTrib[ "vRetPrev" ] := hIniData['Total']['vRetPrev']
	CATCH
	END

	::aTransp := hash()
	TRY
    	::aTransp[ "modFrete" ] := IF(::aIde[ "mod" ]='55',hIniData['Transportador']['Freteporconta'],'9')   
	CATCH
   	TRY
       	::aTransp[ "modFrete" ] := hIniData['Transportador']['FretePorConta']
      CATCH
       	::aTransp[ "modFrete" ] := '0'
      END
	END
	IF EMPTY(::aTransp[ "modFrete" ])
     	::aTransp[ "modFrete" ] := '0'
	ENDIF
	TRY
      IF LEN( hIniData['Transportador']['CnpjCpf'] ) <= 11
      	IF !EMPTY( hIniData['Transportador']['CnpjCpf'] )
          	::aTransp[ "CPF" ] := hIniData['Transportador']['CnpjCpf']
         ENDIF
      ELSE
       	::aTransp[ "CNPJ" ] := hIniData['Transportador']['CnpjCpf']
      ENDIF
   CATCH
   END
   TRY
    	::aTransp[ "xNome" ] := oFuncoes:parseEncode( hIniData['Transportador']['NomeRazao'] )
   CATCH
   END   
   TRY
    	IF !EMPTY( hIniData['Transportador']['IE'] )
       	::aTransp[ "IE" ] := hIniData['Transportador']['IE']
      ENDIF
   CATCH
   END
   TRY
    	IF !EMPTY( hIniData['Transportador']['Endereco'] )
       	::aTransp[ "xEnder" ] := oFuncoes:parseEncode( hIniData['Transportador']['Endereco'] )
      ENDIF
   CATCH
   END
   TRY
      IF !EMPTY(oFuncoes:parseEncode( hIniData['Transportador']['Cidade'] ))
    	   ::aTransp[ "xMun" ] := oFuncoes:parseEncode( hIniData['Transportador']['Cidade'] )
      ENDIF
   CATCH
   END
   TRY
     IF !EMPTY( hIniData['Transportador']['UF'] )
        ::aTransp[ "UF" ] := hIniData['Transportador']['UF']
     ENDIF
   CATCH
   END

   // retTransp
	::aRetTransp := hash()
	TRY
    	::aRetTransp[ "vServ" ] := hIniData['Transportador']['ValorServico']
    	::aRetTransp[ "vBCRet" ] := hIniData['Transportador']['ValorBase']
    	::aRetTransp[ "pICMSRet" ] := hIniData['Transportador']['Aliquota']
    	::aRetTransp[ "vICMSRet" ] := hIniData['Transportador']['Valor']
    	::aRetTransp[ "CFOP" ] := hIniData['Transportador']['CFOP']
    	::aRetTransp[ "cMunFG" ] := hIniData['Transportador']['CidadeCod']
	CATCH
	END
	// veicTransp
	::aVeicTransp := hash()
	TRY
   	::aVeicTransp[ "placa" ] := hIniData['Transportador']['Placa']
    ::aVeicTransp[ "placa" ] := STRTRAN(::aVeicTransp[ "placa" ], "-", "" )
    ::aVeicTransp[ "placa" ] := STRTRAN(::aVeicTransp[ "placa" ], " ", "" )
   CATCH
   END
	TRY
   	::aVeicTransp[ "UF" ] := hIniData['Transportador']['ufplaca']
	CATCH
   	TRY
      	::aVeicTransp[ "UF" ] := hIniData['Transportador']['UFPlaca']
      CATCH
      END
	END
	TRY
   	::aVeicTransp[ "RNTC" ] := hIniData['Transportador']['RNTC']
	CATCH
	END

	TRY
   	::aVeicTransp[ "vagao" ] := hIniData['Transportador']['vagao']
	CATCH
	END
	TRY
   	::aVeicTransp[ "balsa" ] := hIniData['Transportador']['balsa']
	CATCH
	END

	//reboque
	::aReboque := hash()
	TRY
    	::aReboque[ "placa" ] := hIniData['Reboque001']['placa']
     ::aReboque[ "placa" ] := STRTRAN(::aReboque[ "placa" ], "-", "" )
     ::aReboque[ "placa" ] := STRTRAN(::aReboque[ "placa" ], " ", "" )
    	::aReboque[ "UF" ] := hIniData['Reboque001']['UF']
	CATCH
	END
	TRY
    	::aReboque[ "RNTC" ] := hIniData['Reboque001']['RNTC']
	CATCH
	END
	// dados transportados
	TRY
      IF VAL(hIniData['Volume001']['quantidade'])>0
   	   ::aTransp[ "qVol" ] := hIniData['Volume001']['quantidade']
      ELSE
         ::aTransp[ "qVol" ] := '0'
      ENDIF
	CATCH
      ::aTransp[ "qVol" ] := '0'
	END
	TRY
      IF !EMPTY(hIniData['Volume001']['Especie'])    // Mauricio Cruz - 30/09/2011
   	   ::aTransp[ "esp" ] := hIniData['Volume001']['Especie']
      ENDIF
	CATCH 
	END
	TRY
	   IF !EMPTY( hIniData['Volume001']['Marca'] )
      	::aTransp[ "marca" ] := hIniData['Volume001']['Marca']            
      ENDIF
	CATCH 
	END
	TRY
    IF !EMPTY( hIniData['Volume001']['Numeracao'] )
       ::aTransp[ "nVol" ] := hIniData['Volume001']['Numeracao']
    ENDIF
	CATCH     
	END
	TRY
	   IF VAL( hIniData['Volume001']['PesoLiquido'] ) > 0
      	::aTransp[ "pesoL" ] := ALLTRIM( STR( VAL( hIniData['Volume001']['PesoLiquido'] ) ,20 ,3 ) )
     ENDIF
	CATCH
     	::aTransp[ "pesoL" ] := '0.000'
	END
	TRY
	   IF VAL( hIniData['Volume001']['PesoBruto'] ) > 0
      	::aTransp[ "pesoB" ] := ALLTRIM( STR( VAL( hIniData['Volume001']['PesoBruto'] ) ,20 ,3 ) )
      ENDIF
	CATCH
     	::aTransp[ "pesoB" ] := '0.000'
	END

	TRY
   	::aTransp[ "nLacre" ] := hIniData['Lacre001001']['nLacre']
	CATCH
	END
   
	::aFatura := hash()
	TRY
    	::aFatura[ "nFat" ] := hIniData['Fatura']['Numero']
    	::aFatura[ "vOrig" ] := hIniData['Fatura']['ValorOriginal']
    	::aFatura[ "vDesc" ] := hIniData['Fatura']['ValorDesconto']
    	::aFatura[ "vLiq" ] := hIniData['Fatura']['ValorLiquido']
	CATCH
	END
	//Duplicatas
 	::aDuplicatas := hash()
   nICob := 0
   DO WHILE .T.
      nICob ++
    	TRY
       	::aDuplicatas[ "dup"+STRZERO(nICob,3)+"_nDup" ] := hIniData['Duplicata'+STRZERO(nICob,3)]['Numero']
    	CATCH
    	   nICob --
       	EXIT
    	END
    	::aDuplicatas[ "dup"+STRZERO(nICob,3)+"_dVenc" ] := oFuncoes:FormatDate(CTOD(hIniData['Duplicata'+STRZERO(nICob,3)]['DataVencimento']),"YYYY-MM-DD","-")
    	::aDuplicatas[ "dup"+STRZERO(nICob,3)+"_vDup" ] := oFuncoes:strTostrval( hIniData['Duplicata'+STRZERO(nICob,3)]['Valor'] )
   ENDDO

	//Pagamentos
 	::aPagamentos := hash()
   nIPag := 0
   DO WHILE .T.
      nIPag ++
    	TRY
       	::aPagamentos[ "pag"+STRZERO(nIPag,3)+"_tpag" ] := hIniData['pag'+STRZERO(nIPag,3)]['tpag']
    	CATCH
    	   nIPag --
       	EXIT
    	END
    	::aPagamentos[ "pag"+STRZERO(nIPag,3)+"_vpag" ] := oFuncoes:strTostrval( hIniData['pag'+STRZERO(nIPag,3)]['vpag'] )
   ENDDO

	::aInfAdic := hash()
   /*
	TRY
   	::aInfAdic[ "infAdFisco" ] := oFuncoes:parseEncode( hIniData['DadosAdicionais']['Fisco'] )
   CATCH
   END
	TRY
   	::aInfAdic[ "infCpl" ] := oFuncoes:parseEncode( hIniData['DadosAdicionais']['Complemento'] )
   CATCH
   END
   */
   
   // Maurício cruz - 27/10/2011
   IF !EMPTY(SYG_GetPrivateProfileString( 'DadosAdicionais', 'Fisco', , cIniFile ))
        //::aInfAdic[ "infAdFisco" ] := CLEAR_CHAR( oFuncoes:parseEncode( SYG_GetPrivateProfileString( 'DadosAdicionais', 'Fisco', , cIniFile ),.t. ) )
       TRY
         cOBSFISCO:=hIniData['DadosAdicionais']['Fisco']
       CATCH
         cOBSFISCO:=''
       END
       IF LEFT(cOBSFISCO,1) ='"'
       		 ::aInfAdic[ "infAdFisco" ] :=  CLEAR_CHAR('"' + oFuncoes:parseEncode(SYG_GetPrivateProfileString( 'DadosAdicionais', 'Fisco', , cIniFile ),.t.  ) +;
          if ( right( alltrim(hIniData['DadosAdicionais']['Fisco']) ,1)= '"' ,'"','' ) )
       ELSE
         ::aInfAdic[ "infAdFisco" ] := CLEAR_CHAR( oFuncoes:parseEncode( SYG_GetPrivateProfileString( 'DadosAdicionais', 'Fisco', , cIniFile ),.t. ) )
  	   ENDIF
   ENDIF

   IF !EMPTY(SYG_GetPrivateProfileString( 'DadosAdicionais', 'Complemento', , cIniFile ))
       //::aInfAdic[ "infCpl" ] := CLEAR_CHAR ( oFuncoes:parseEncode( SYG_GetPrivateProfileString( 'DadosAdicionais', 'Complemento', , cIniFile ),.t. ) )
      TRY
        cOBSADICIONAL:=hIniData['DadosAdicionais']['Complemento']
      CATCH
        cOBSADICIONAL:=''
      END
      IF LEFT(cOBSADICIONAL,1) ='"'
      		 ::aInfAdic[ "infCpl" ] :=  CLEAR_CHAR('"' + oFuncoes:parseEncode(SYG_GetPrivateProfileString( 'DadosAdicionais', 'Complemento', , cIniFile ),.t.  ) + ;
      		 if ( right( alltrim(hIniData['DadosAdicionais']['Complemento']) ,1)= '"' ,'"','' ) )
   	   ELSE
         ::aInfAdic[ "infCpl" ] := CLEAR_CHAR( oFuncoes:parseEncode( SYG_GetPrivateProfileString( 'DadosAdicionais', 'Complemento', , cIniFile ),.t. ) )
 	    ENDIF
   ENDIF

	//obsCont
 	::aObsCont := hash()
   nObs := 0
   DO WHILE .T.
      nObs ++
    	TRY
       	::aObsCont[ "obs"+STRZERO(nObs,3)+"_xCampo" ] := oFuncoes:parseEncode( hIniData['infAdic'+STRZERO(nObs,3)]['Campo'] )
    	CATCH
    	   nObs --
       	EXIT
    	END
    	::aObsCont[ "obs"+STRZERO(nObs,3)+"_xTexto" ] := oFuncoes:parseEncode( hIniData['infAdic'+STRZERO(nObs,3)]['Texto'] )
   ENDDO
	//obsFisco
	::aObsFisco := hash()
   nObs := 0
   DO WHILE .T.
      nObs ++
    	TRY
       	::aObsFisco[ "obs"+STRZERO(nObs,3)+"_xCampo" ] := oFuncoes:parseEncode( hIniData['ObsFisco'+STRZERO(nObs,3)]['Campo'] )
    	CATCH
    	   nObs --
       	EXIT
    	END
    	::aObsFisco[ "obs"+STRZERO(nObs,3)+"_xTexto" ] := oFuncoes:parseEncode( hIniData['ObsFisco'+STRZERO(nObs,3)]['Texto'] )
   ENDDO

   // processo referenciado
   ::aProcRef := hash()
   nObs := 0
   DO WHILE .T.
      nObs ++
    	TRY
       	::aObsFisco[ "pref"+STRZERO(nObs,3)+"_nProc" ] := hIniData['procRef'+STRZERO(nObs,3)]['nProc']
    	CATCH
    	   nObs --
       	EXIT
    	END
    	::aObsFisco[ "pref"+STRZERO(nObs,3)+"_indProc" ] := hIniData['procRef'+STRZERO(nObs,3)]['indProc']
   ENDDO

   
	::aExporta := hash()
	TRY
      ::aExporta[ "UFEmbarq" ] := hIniData['Exporta']['UFEmbarq']
      ::aExporta[ "xLocEmbarq" ] := hIniData['Exporta']['xLocEmbarq']
	CATCH
	END

	::aCompra := hash()
	TRY
    	::aCompra[ "xNEmp" ] := hIniData['Compra']['xNEmp']
    	::aCompra[ "xPed" ] := hIniData['Compra']['xPed']
    	::aCompra[ "xCont" ] := hIniData['Compra']['xCont']
	CATCH
	END
/*   
   ::REGRAS_NFE(@aMSGvld,cChaveNFe,nItem)

   IF LEN(aMSGvld)>0
*      IF !ERROS_ALERTAS_NFE(aMSGvld)
         aRetorno['OK'] := .F.
		 cRet := ""
		 FOR nI = 1 TO LEN(aMSGvld)
		    IF aMSGvld[nI,1] = .T.
		       cRet += aMSGvld[nI,2]+CHR(13)
			ENDIF   
		 NEXT
		 IF EMPTY(cRet)
		    aRetorno['OK'] := .T.
		 ELSE
            aRetorno['MsgErro'] := cRet
            RETURN(aRetorno)
		 ENDIF	
*      ENDIF
   ENDIF
*/

   ************************************************************************************************
   *                            CRIACAO DO ARQUIVO XML                                            *
   ************************************************************************************************
   
   
	::cXMLSaida := '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">' + ;
	               '<infNFe versao="'+::ohbNFe:versaoDados+'" Id="NFe'+cChaveNFe+'">'
		::incluiTag('ide')
    	::incluiTag('cUF'     ,::aIde[ "cUF" ])
    	::incluiTag('cNF'     ,::aIde[ "cNF" ])
    	::incluiTag('natOp'   ,::aIde[ "natOp" ])
    	::incluiTag('indPag'  ,::aIde[ "indPag" ])
    	::incluiTag('mod'     ,::aIde[ "mod" ])
    	::incluiTag('serie'   ,::aIde[ "serie" ])
    	::incluiTag('nNF'     ,::aIde[ "nNF" ])
      IF ::ohbNFe:versaoDados='2.00'
    	   ::incluiTag('dEmi'    ,::aIde[ "dEmi" ])
      ELSE
         ::incluiTag('dhEmi'    ,::aIde[ "dEmi" ])
      ENDIF

    	::incluiTag('tpNF'    ,::aIde[ "tpNF" ])
      IF ::ohbNFe:versaoDados='3.10'
         ::incluiTag('idDest'  ,::aIde[ "idDest" ])
      ENDIF
    	::incluiTag('cMunFG'  ,::aIde[ "cMunFG" ])

      IF ::ohbNFe:versaoDados='2.00'
         // NOTAS REFERENCIADAS   - Mauricio Cruz - 18/01/2012   
         // ALTERADO DE POSICAO NA VERSAO 3.10
         IF nItnRef>0
            ::incluiTag('NFref')
         ENDIF
         
         FOR mI:=1 TO nItnRef
            IF !EMPTY(::aRefNfe['refNFe'+STRZERO(mI,3)])
               ::incluiTag('refNFe'  ,::aRefNfe['refNFe'+STRZERO(mI,3)])
            ELSE
               TRY
                  ::incluiTag('refNF',::aRefNfe['refNF' +STRZERO(mI,3)])
               CATCH
               END
               ::incluiTag('cUF'     ,::aRefNfe['cUF'   +STRZERO(mI,3)])
               ::incluiTag('AAMM'    ,::aRefNfe['AAMM'  +STRZERO(mI,3)])
               ::incluiTag('CNPJ'    ,::aRefNfe['CNPJ'  +STRZERO(mI,3)])
               ::incluiTag('mod'     ,::aRefNfe['mod'   +STRZERO(mI,3)])
               ::incluiTag('serie'   ,::aRefNfe['serie' +STRZERO(mI,3)])
               ::incluiTag('nNF'     ,::aRefNfe['nNF'   +STRZERO(mI,3)])
            ENDIF
         NEXT
         IF nItnRef>0
            ::incluiTag('/NFref')
         ENDIF
      ENDIF
      
      
    	::incluiTag('tpImp'   ,::aIde[ "tpImp" ])
    	::incluiTag('tpEmis'  ,::aIde[ "tpEmis" ])
    	::incluiTag('cDV'     ,::aIde[ "cDV" ])
    	::incluiTag('tpAmb'   ,::aIde[ "tpAmb" ])
    	::incluiTag('finNFe'  ,::aIde[ "finNFe" ])
      IF ::ohbNFe:versaoDados='3.10'
         ::incluiTag('indFinal' ,::aIde[ "indFinal" ])
         ::incluiTag('indPres' ,::aIde[ "indPres" ])
      ENDIF
      
    	::incluiTag('procEmi' ,::aIde[ "procEmi" ])
    	::incluiTag('verProc' ,::aIde[ "verProc" ])
      IF VAL(::aIde[ "tpEmis" ])=3 .OR. VAL(::aIde[ "tpEmis" ])=5 .OR. VAL(::aIde[ "tpEmis" ])=6 .OR. VAL(::aIde[ "tpEmis" ])=7 .OR. VAL(::aIde[ "tpEmis" ])=9
         ::incluiTag('dhCont' ,::aIde[ "dhCont" ])
         ::incluiTag('xJust' ,::aIde[ "xJust" ])
      ENDIF
      
      IF ::ohbNFe:versaoDados='3.10'
         // NOTAS REFERENCIADAS   - Mauricio Cruz - 18/01/2012   
         // ALTERADO DE POSICAO NA VERSAO 3.10

         FOR mI:=1 TO nItnRef
            IF !EMPTY(::aRefNfe['refNFe'+STRZERO(mI,3)])
               ::incluiTag('NFref')
               ::incluiTag('refNFe'  ,::aRefNfe['refNFe'+STRZERO(mI,3)])
               ::incluiTag('/NFref')
            ELSE
               ::incluiTag('NFref')
               TRY
                  //::incluiTag('refNF',::aRefNfe['refNF' +STRZERO(mI,3)])
                  ::incluiTag('refNF')
               CATCH
               END
               ::incluiTag('cUF'     ,::aRefNfe['cUF'   +STRZERO(mI,3)])
               ::incluiTag('AAMM'    ,::aRefNfe['AAMM'  +STRZERO(mI,3)])
               ::incluiTag('CNPJ'    ,::aRefNfe['CNPJ'  +STRZERO(mI,3)])
               ::incluiTag('mod'     ,::aRefNfe['mod'   +STRZERO(mI,3)])
               ::incluiTag('serie'   ,::aRefNfe['serie' +STRZERO(mI,3)])
               ::incluiTag('nNF'     ,::aRefNfe['nNF'   +STRZERO(mI,3)])
               TRY
                  ::incluiTag('/refNF')
               CATCH
               END
               ::incluiTag('/NFref')
            ENDIF
         NEXT
         
      ENDIF
      
	::incluiTag('/ide')

	::incluiTag('emit')
    	::incluiTag('CNPJ'     ,::aEmit[ "CNPJ" ])
    	::incluiTag('xNome'    ,::aEmit[ "xNome" ])
      IF !EMPTY(::aEmit[ "xFant" ])
    	   ::incluiTag('xFant'    ,::aEmit[ "xFant" ])
      ENDIF
    	::incluiTag('enderEmit')
    	::incluiTag('xLgr'     ,::aEmit[ "xLgr" ])
    	::incluiTag('nro'      ,::aEmit[ "nro" ])
     IF !EMPTY(::aEmit[ "xCpl" ])
        ::incluiTag('xCpl'     ,::aEmit[ "xCpl" ])
     ENDIF
    	::incluiTag('xBairro'  ,::aEmit[ "xBairro" ])
    	::incluiTag('cMun'     ,::aEmit[ "cMun" ])
    	::incluiTag('xMun'     ,::aEmit[ "xMun" ])
    	::incluiTag('UF'       ,::aEmit[ "UF" ])
    	::incluiTag('CEP'      ,::aEmit[ "CEP" ])
    	::incluiTag('cPais'    ,::aEmit[ "cPais" ])
    	::incluiTag('xPais'    ,::aEmit[ "xPais" ])
      IF !EMPTY(::aEmit[ "fone" ])
    	   ::incluiTag('fone'     ,::aEmit[ "fone" ])
      ENDIF
    	::incluiTag('/enderEmit')
    	::incluiTag('IE'       ,::aEmit[ "IE" ])
    	IF !EMPTY(::aEmit[ "IEST" ])
       	::incluiTag('IEST'  ,::aEmit[ "IEST" ])
      ENDIF
    	IF !EMPTY(::aEmit[ "IM" ])
       	::incluiTag('IM'    ,::aEmit[ "IM" ])
       	::incluiTag('CNAE'  ,::aEmit[ "CNAE" ])
      ENDIF
    	::incluiTag('CRT'      ,::aEmit[ "CRT" ])
	::incluiTag('/emit')

   //preencher somente se tiver cpf ou cnpj informado
 
   IF LEN(::aDest)<>0
 		::incluiTag('dest')
          TRY
            IF !EMPTY(::aDest[ "CNPJ" ])
               ::incluiTag('CNPJ'     ,::aDest[ "CNPJ" ])
            ENDIF
         CATCH
            IF !EMPTY(::aDest[ "CPF" ])
               ::incluiTag('CPF'      ,::aDest[ "CPF" ])
            ENDIF
         END
      
      TRY
	      IF ::aDest[ "UF" ]='EX' .AND. ::ohbNFe:versaoDados='3.10'
	         ::incluiTag('idEstrangeiro'    ,'')
	      ENDIF
      CATCH
      END
      
      TRY
	    	::incluiTag('xNome'    ,::aDest[ "xNome" ])
      CATCH
      END
 
      IF !EMPTY(::aDest[ "xLgr" ])
    	::incluiTag('enderDest')

	      TRY
	    	::incluiTag('xLgr'     ,::aDest[ "xLgr" ])
	    	::incluiTag('nro'      ,::aDest[ "nro" ])

	      IF !EMPTY(::aDest[ "xCpl" ])
	         ::incluiTag('xCpl'     ,::aDest[ "xCpl" ])
	      ENDIF

	    	::incluiTag('xBairro'  ,::aDest[ "xBairro" ])
	    	::incluiTag('cMun'     ,::aDest[ "cMun" ])
	    	::incluiTag('xMun'     ,::aDest[ "xMun" ])
	    	::incluiTag('UF'       ,::aDest[ "UF" ])
	      ::incluiTag('CEP'      ,::aDest[ "CEP" ])
	      
		  	::incluiTag('cPais'    ,::aDest[ "cPais" ])
	    	::incluiTag('xPais'    ,::aDest[ "xPais" ])
         CATCH
	      END
	
      
    	::incluiTag('/enderDest')
   End   
      
      ::incluiTag('indIEDest' , '9')
      
      
	::incluiTag('/dest')
  END
	   
   TRY
      IF !EMPTY(::aEntrega[ "CNPJ" ]) .OR. !EMPTY(::aEntrega[ "CPF" ])
         ::incluiTag('entrega')
      ENDIF
      
      TRY
         IF !EMPTY(::aEntrega[ "CNPJ" ])
            ::incluiTag('CNPJ',::aEntrega[ "CNPJ" ])
         ELSEIF !EMPTY(::aEntrega[ "CPF" ])
            ::incluiTag('CPF',::aEntrega[ "CPF" ])
         ENDIF
      CATCH
      END
      TRY
         IF !EMPTY(::aEntrega[ "xLgr" ])
         
            ::incluiTag('xLgr',::aEntrega[ "xLgr" ])
         ENDIF
      CATCH
      END
      TRY
         IF !EMPTY(::aEntrega[ "nro" ])
            ::incluiTag('nro',::aEntrega[ "nro" ])
         ENDIF
      CATCH
      END
      TRY
         IF !EMPTY(::aEntrega[ "xCpl" ])
            ::incluiTag('xCpl',::aEntrega[ "xCpl" ])
         ENDIF
      CATCH
      END
      TRY
         IF !EMPTY(::aEntrega[ "xBairro" ])
            ::incluiTag('xBairro',::aEntrega[ "xBairro" ])
         ENDIF
      CATCH
      END
      TRY
         IF !EMPTY(::aEntrega[ "cMun" ])
            ::incluiTag('cMun',::aEntrega[ "cMun" ])
         ENDIF
      CATCH
      END
      TRY
         IF !EMPTY(::aEntrega[ "xMun" ])
            ::incluiTag('xMun',::aEntrega[ "xMun" ])
         ENDIF
      CATCH
      END
      TRY
         IF !EMPTY(::aEntrega[ "UF" ])
            ::incluiTag('UF',::aEntrega[ "UF" ])
         ENDIF
      CATCH
      END
      IF !EMPTY(::aEntrega[ "CNPJ" ]) .OR. !EMPTY(::aEntrega[ "CPF" ])
         ::incluiTag('/entrega')
      ENDIF
   CATCH
   END
   
   // grupo  autXML - Mauricio Cruz - 26/08/2014
   IF ::ohbNFe:versaoDados='3.10'
      FOR mI:=1 TO LEN(::autXML)
         ::incluiTag('autXML')
         IF ::autXML[mI,1]='CNPJ'
            ::incluiTag('CNPJ',::autXML[mI,2])
         ELSE
            ::incluiTag('CPF',::autXML[mI,2])
         ENDIF
         ::incluiTag('/autXML')
      NEXT
   ENDIF

   nNItem := nItem
   FOR nItem = 1 TO nNItem
   	::incluiTag('det nItem="'+ALLTRIM(STR(nItem))+'"')
         ::incluiTag('prod')
         	::incluiTag('cProd'    ,::aItem[ "item"+STRZERO(nItem,3)+"_cProd" ])
            TRY
               IF oFuncoes:validaEan(::aItem[ "item"+STRZERO(nItem,3)+"_cEAN" ])[1] = .T.
                  ::incluiTag('cEAN'     ,::aItem[ "item"+STRZERO(nItem,3)+"_cEAN" ])   //<cEAN />
               ELSE
                  aRetorno['OK'] := .F.
                  aRetorno['MsgErro'] := 'Problema ao validar EAN ' + oFuncoes:validaEan(::aItem[ "item"+STRZERO(nItem,3)+"_cEAN" ])[2]
                  * RETURN(aRetorno)
               ENDIF
            CATCH
               ::incluiTag('cEAN'     ,'')   //<cEAN />
*               aRetorno['OK'] := .F.
*               aRetorno['MsgErro'] := 'Problema ao validar EAN'
*               RETURN(aRetorno)
            END
            IF aRetorno['OK'] = .F.
               RETURN(aRetorno)
            ENDIF
            
         	::incluiTag('xProd'    ,::aItem[ "item"+STRZERO(nItem,3)+"_xProd" ])
         	::incluiTag('NCM'      ,::aItem[ "item"+STRZERO(nItem,3)+"_NCM" ])
           	IF !EMPTY(::aItem[ "item"+STRZERO(nItem,3)+"_CEST" ])
         		::incluiTag('CEST'      ,::aItem[ "item"+STRZERO(nItem,3)+"_CEST" ])
            END
         	TRY
            	IF !EMPTY(::aItem[ "item"+STRZERO(nItem,3)+"_EXTIPI" ])
               	::incluiTag('EXTIPI',::aItem[ "item"+STRZERO(nItem,3)+"_EXTIPI" ])
               ENDIF
            CATCH
            END
         	::incluiTag('CFOP'     ,::aItem[ "item"+STRZERO(nItem,3)+"_CFOP" ])
         	::incluiTag('uCom'     ,::aItem[ "item"+STRZERO(nItem,3)+"_uCom" ])
         	::incluiTag('qCom'     ,::aItem[ "item"+STRZERO(nItem,3)+"_qCom" ])
         	::incluiTag('vUnCom'   ,::aItem[ "item"+STRZERO(nItem,3)+"_vUnCom" ])
         	::incluiTag('vProd'    ,::aItem[ "item"+STRZERO(nItem,3)+"_vProd" ])
            TRY
               IF oFuncoes:validaEan(::aItem[ "item"+STRZERO(nItem,3)+"_cEANTrib" ])[1] = .T.
         	      ::incluiTag('cEANTrib' ,::aItem[ "item"+STRZERO(nItem,3)+"_cEANTrib" ]) //<cEANTrib />
               ELSE
                  aRetorno['OK'] := .F.
                  aRetorno['MsgErro'] := 'Problema ao validar EANTrib ' + oFuncoes:validaEan(::aItem[ "item"+STRZERO(nItem,3)+"_cEANTrib" ])[2]
                  * RETURN(aRetorno)
               ENDIF
            CATCH
               ::incluiTag('cEANTrib'     ,'')   //<cEANTrib />
*               aRetorno['OK'] := .F.
*               aRetorno['MsgErro'] := 'Problema ao validar EANTrib'
*               RETURN(aRetorno)
            END
            IF aRetorno['OK'] = .F.
               RETURN(aRetorno)
            ENDIF
               
         	::incluiTag('uTrib'    ,::aItem[ "item"+STRZERO(nItem,3)+"_uTrib" ])
         	::incluiTag('qTrib'    ,::aItem[ "item"+STRZERO(nItem,3)+"_qTrib" ])

         	TRY
            	::incluiTag('nFCI'   ,::aItem[ "item"+STRZERO(nItem,3)+"_nFCI" ])
          CATCH
          END

         	::incluiTag('vUnTrib'  ,::aItem[ "item"+STRZERO(nItem,3)+"_vUnTrib" ])
         	TRY
            	IF !EMPTY(::aItem[ "item"+STRZERO(nItem,3)+"_vFrete" ]) .AND. VAL(::aItem[ "item"+STRZERO(nItem,3)+"_vFrete" ]) <> 0
               	::incluiTag('vFrete',::aItem[ "item"+STRZERO(nItem,3)+"_vFrete" ])
               ENDIF
            CATCH
            END
         	TRY
             	IF !EMPTY(::aItem[ "item"+STRZERO(nItem,3)+"_vSeg" ]) .AND. VAL(::aItem[ "item"+STRZERO(nItem,3)+"_vSeg" ]) <> 0
                	::incluiTag('vSeg'  ,::aItem[ "item"+STRZERO(nItem,3)+"_vSeg" ])
               ENDIF
            CATCH
            END
         	TRY
             	IF !EMPTY(::aItem[ "item"+STRZERO(nItem,3)+"_vDesc" ]) .AND. VAL(::aItem[ "item"+STRZERO(nItem,3)+"_vDesc" ]) <> 0
                	::incluiTag('vDesc' ,::aItem[ "item"+STRZERO(nItem,3)+"_vDesc" ])
               ENDIF
            CATCH
            END
         	TRY
             	IF !EMPTY(::aItem[ "item"+STRZERO(nItem,3)+"_vOutro" ]) .AND. VAL(::aItem[ "item"+STRZERO(nItem,3)+"_vOutro" ]) <> 0
                	::incluiTag('vOutro',::aItem[ "item"+STRZERO(nItem,3)+"_vOutro" ])
               ENDIF
            CATCH
            END
         	TRY
            	::incluiTag('indTot'   ,::aItem[ "item"+STRZERO(nItem,3)+"_indTot" ])
            CATCH
            END

            // DI - Mauricio Cruz - 04/10/2011
            IF nDI>0
               //TRY
                  FOR mI:=1 TO nDi
                     ::incluiTag('DI')
                        ::incluiTag('nDI'          ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_nDI" ]         )
                        ::incluiTag('dDI'          ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_dDI" ]         )
                        
                        IF !EMPTY(::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_xLocDesemb" ])
                           ::incluiTag('xLocDesemb'   ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_xLocDesemb" ]  )
                        ENDIF
                        IF !EMPTY(::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_UFDesemb" ])
                           ::incluiTag('UFDesemb'     ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_UFDesemb" ]    )
                        ENDIF
                        
                        ::incluiTag('dDesemb'      ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_dDesemb" ]     )

                        IF ::ohbNFe:versaoDados='3.10'
                           ::incluiTag('tpViaTransp'  ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_tpViaTransp" ] )
                           ::incluiTag('vAFRMM'       ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_vAFRMM" ] )
                           ::incluiTag('tpIntermedio' ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_tpIntermedio" ] )
                           IF !EMPTY(::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_CNPJ" ])
                              ::incluiTag('CNPJ'         ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_CNPJ" ] )
                           ENDIF
                           ::incluiTag('UFTerceiro'   ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_UFTerceiro" ] )
                        ENDIF

                        ::incluiTag('cExportador'  ,::aItemDI[ "item"+STRZERO(nItem,3)+STRZERO(mI,3)+"_cExportador" ] )
                        FOR mY:=1 TO nAdi
                           lERRO:=.F.
                           TRY
                              IF !EMPTY(::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_nAdicao" ])
                              ENDIF
                           CATCH
                              lERRO:=.T.
                           END
                           IF !lERRO
                              ::incluiTag('adi')
                                 ::incluiTag('nAdicao'      ,::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_nAdicao" ]     )
                                 ::incluiTag('nSeqAdic'     ,::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_nSeqAdic" ]    )
                                 ::incluiTag('cFabricante'  ,::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_cFabricante" ] )
                                 IF ALLTRIM(::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_vDescDI" ])#'0.00'
                                    ::incluiTag('vDescDI'      ,::aItemAdi[ "item"+STRZERO(nItem,3)+STRZERO(nDi,3)+STRZERO(nAdi,3)+"_vDescDI" ]     )
                                 ENDIF
                              ::incluiTag('/adi')
                           ENDIF
                        NEXT
                     ::incluiTag('/DI')
                  NEXT
               //CATCH
               //END
            ENDIF
            
          TRY
            ::incluiTag('xPed'   ,::aItem[ "item"+STRZERO(nItem,3)+"_xPed" ])
          CATCH
          END
          TRY
            ::incluiTag('nItemPed'   ,::aItem[ "item"+STRZERO(nItem,3)+"_nItemPed" ])
          CATCH
          END
				
				TRY
					IF VAL(::aItemCOMB[ "item"+STRZERO(nItem,3)+"_cProdANP" ])>0
						::incluiTag('comb')											
							::incluiTag('cProdANP' ,::aItemCOMB[ "item"+STRZERO(nItem,3)+"_cProdANP" ])						
							::incluiTag('CODIF'    ,::aItemCOMB[ "item"+STRZERO(nItem,3)+"_CODIF" ])
							::incluiTag('qTemp'    ,::aItemCOMB[ "item"+STRZERO(nItem,3)+"_qTemp" ])
							::incluiTag('UFCons'   ,::aItemCOMB[ "item"+STRZERO(nItem,3)+"_UFCons" ])
						::incluiTag('/comb')						
					ENDIF
				CATCH
				END			
			 	
      	::incluiTag('/prod')
         
      	::incluiTag('imposto')
            
       IF ::lMostra_imp_danfe
          ::incluiTag('vTotTrib',::aItemICMS[ "item"+STRZERO(nItem,3)+"vTotTrib" ])
       ENDIF
         	::incluiTag('ICMS')

         	   IF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '00,10,20,30,40,41,50,51,60,70,90'
               	IF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '40,41,50'
                  	::incluiTag('ICMS40')
               	ELSE
                  	::incluiTag('ICMS'+::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                  ENDIF
               	IF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '00'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                   	::incluiTag('modBC'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ])
                    	::incluiTag('vBC'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                    	::incluiTag('pICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ])
                    	::incluiTag('vICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '10'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                   	::incluiTag('modBC'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ])
                    	::incluiTag('vBC'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                    	::incluiTag('pICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ])
                    	::incluiTag('vICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
                   	::incluiTag('modBCST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])>0
                   	   ::incluiTag('pMVAST'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])
                     ENDIF
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])>0
                   	   ::incluiTag('pRedBCST'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])
                     ENDIF
                   	::incluiTag('vBCST'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ])
                   	::incluiTag('pICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ])
                   	::incluiTag('vICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '20'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                   	::incluiTag('modBC'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ])
                   	::incluiTag('pRedBC'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ])
                    	::incluiTag('vBC'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                    	::incluiTag('pICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ])
                    	::incluiTag('vICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '30'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                   	::incluiTag('modBCST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])>0
                   	   ::incluiTag('pMVAST'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])
                     ENDIF
                   	::incluiTag('pRedBCST'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])
                   	::incluiTag('vBCST'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ])
                   	::incluiTag('pICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ])
                   	::incluiTag('vICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '40,41,50'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                   	//::incluiTag('vICMS'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
                     // havendo valor de icms, deve-se informar o mesmo e o motivo da desoneracao (N28)
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS"]) >0    //Mauricio Cruz - 04/10/2011
                        ::incluiTag('vICMS'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
                        TRY   // Mauricio Cruz - 03/10/2011
                           IF !EMPTY(::aItemICMS[ "item"+STRZERO(nItem,3)+"_motDesICMS" ])
                              ::incluiTag('motDesICMS'  ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_motDesICMS" ])
                           ELSE
                              ::incluiTag('motDesICMS'  ,'9')
                           ENDIF
                        CATCH 
                           ::incluiTag('motDesICMS'  ,'9')
                        END
                     ENDIF
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '51'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                   	::incluiTag('modBC'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ])
                     TRY
                        IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ])>0
                   	      ::incluiTag('pRedBC'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ])
                        ENDIF
                     CATCH
                     END
                    	::incluiTag('vBC'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                    	::incluiTag('pICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ])

                     IF ::ohbNFe:versaoDados='3.10'
                        ::incluiTag('vICMSOp'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSOp" ])
                     ENDIF
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pDif" ])>0
                        ::incluiTag('pDif'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pDif" ])
                     ENDIF
                     IF ::ohbNFe:versaoDados='3.10'
                        ::incluiTag('vICMSDif'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSDif" ])
                     ENDIF
                     
                    	::incluiTag('vICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '60'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                     TRY
                   	   ::incluiTag('vBCSTRet'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCSTRet" ])
                   	   ::incluiTag('vICMSSTRet'  ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSSTRet" ])
                     CATCH
                     END
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '70'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                   	::incluiTag('modBC'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ])
                   	::incluiTag('pRedBC'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ])
                   	::incluiTag('vBC'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                   	::incluiTag('pICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ])
                   	::incluiTag('vICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
                   	::incluiTag('modBCST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])>0
                   	   ::incluiTag('pMVAST'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])
                     ENDIF
                   	::incluiTag('pRedBCST'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])
                   	::incluiTag('vBCST'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ])
                   	::incluiTag('pICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ])
                   	::incluiTag('vICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '90'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CST'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                   	::incluiTag('modBC'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ])
                     ::incluiTag('vBC'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ])>0
               	      ::incluiTag('pRedBC'   ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ])
                     ENDIF
                   	::incluiTag('pICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ])
                   	::incluiTag('vICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
                   	::incluiTag('modBCST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])>0
                        ::incluiTag('pMVAST'   ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])
                     ENDIF
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])>0
                        ::incluiTag('pRedBCST' ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])
                     ENDIF
                	   ::incluiTag('vBCST'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ])
                   	::incluiTag('pICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ])
                   	::incluiTag('vICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ])
               	ENDIF
               	IF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '40,41,50'
                  	::incluiTag('/ICMS40')
               	ELSE
                  	::incluiTag('/ICMS'+::aItemICMS[ "item"+STRZERO(nItem,3)+"_CST" ])
                  ENDIF
               ELSE
               	IF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] $ '102,103,300,400'
                  	::incluiTag('ICMSSN102')
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] $ '202,203'
                  	::incluiTag('ICMSSN202')
               	ELSE
                  	::incluiTag('ICMSSN'+::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ])
                  ENDIF
               	IF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] = '101'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CSOSN'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ])
                   	::incluiTag('pCredSN'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pCredSN" ])
                   	::incluiTag('vCredICMSSN' ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vCredICMSSN" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] $ '102,103,300,400'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CSOSN'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] = '201'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CSOSN'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ])
                   	::incluiTag('modBCST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])>0
                   	   ::incluiTag('pMVAST'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])
                     ENDIF
                     if val(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])>0
                	      ::incluiTag('pRedBCST'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])
                     endif
                   	::incluiTag('vBCST'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ])
                   	::incluiTag('pICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ])
                   	::incluiTag('vICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ])
                   	::incluiTag('pCredSN'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pCredSN" ])
                   	::incluiTag('vCredICMSSN' ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vCredICMSSN" ])
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] $ '202,203'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CSOSN'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ])
                   	::incluiTag('modBCST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ] ) >0
                   	   ::incluiTag('pMVAST'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])
                     ENDIF
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ]) >0
                   	   ::incluiTag('pRedBCST'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])
                     ENDIF
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ])>0
                   	   ::incluiTag('vBCST'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ])
                     ENDIF
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ])>0
                   	   ::incluiTag('pICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ])
                     ENDIF
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ])>0
                   	   ::incluiTag('vICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ])
                     ENDIF
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] = '500'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CSOSN'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ])
                   	TRY
                      	::incluiTag('vBCSTRet'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCSTRet" ])
                      	::incluiTag('vICMSSTRet'  ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSSTRet" ])
                     CATCH
                      	::incluiTag('vBCSTRet'    ,'0.00')
                      	::incluiTag('vICMSSTRet'  ,'0.00')
                     END
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] = '900'
                   	::incluiTag('orig'        ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_orig" ])
                   	::incluiTag('CSOSN'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ])
                   	::incluiTag('modBC'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBC" ])
                   	::incluiTag('vBC'         ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ])>0
                   	   ::incluiTag('pRedBC'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBC" ])
                     ENDIF
                   	::incluiTag('pICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMS" ])
                   	::incluiTag('vICMS'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMS" ])
                   	::incluiTag('modBCST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_modBCST" ])
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])>0
                   	   ::incluiTag('pMVAST'      ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pMVAST" ])
                     ENDIF
                     IF VAL(::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])>0
                   	   ::incluiTag('pRedBCST'    ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pRedBCST" ])
                     ENDIF
                   	::incluiTag('vBCST'       ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vBCST" ])
                   	::incluiTag('pICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pICMSST" ])
                   	::incluiTag('vICMSST'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vICMSST" ])
                   	::incluiTag('pCredSN'     ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_pCredSN" ])
                   	::incluiTag('vCredICMSSN' ,::aItemICMS[ "item"+STRZERO(nItem,3)+"_vCredICMSSN" ])
               	ENDIF
               	IF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] $ '102,103,300,400'
                  	::incluiTag('/ICMSSN102')
               	ELSEIF ::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ] $ '202,203'
                  	::incluiTag('/ICMSSN202')
               	ELSE
                  	::incluiTag('/ICMSSN'+::aItemICMS[ "item"+STRZERO(nItem,3)+"_CSOSN" ])
                  ENDIF
               ENDIF
         	::incluiTag('/ICMS')


            TRY
              IF !EMPTY( ::aItemIPI[ "item"+STRZERO(nItem,3)+"_CST" ] )
               	::incluiTag('IPI')
               	   TRY
                    	::incluiTag('clEnq'        ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_clEnq" ])
                    CATCH
                    END
               	   TRY
                    	::incluiTag('CNPJProd'     ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_CNPJProd" ])
                    CATCH
                    END
               	   TRY
                    	::incluiTag('cSelo'        ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_cSelo" ])
                    CATCH
                    END
               	   TRY
                    	::incluiTag('qSelo'        ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_qSelo" ])
                    CATCH
                    END
               	   TRY
                    	::incluiTag('cEnq'         ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_cEnq" ])
                    CATCH
                    	::incluiTag('cEnq'         ,'999')
                    END

                    	IF ::aItemIPI[ "item"+STRZERO(nItem,3)+"_CST" ] $ '00,49,50,99'
                     	::incluiTag('IPITrib')
                        	::incluiTag('CST'    ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_CST" ])
                          	::incluiTag('vBC'    ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_vBC" ])
                          	::incluiTag('pIPI'   ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_pIPI" ])
                          	::incluiTag('vIPI'   ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_vIPI" ])
                     	::incluiTag('/IPITrib')
                    	ELSEIF ::aItemIPI[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02,03,04,51,52,53,54,55'
                      	::incluiTag('IPINT')
                        	::incluiTag('CST'    ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_CST" ])
                      	::incluiTag('/IPINT')
                    	ELSEIF ::aItemIPI[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99'
                     	::incluiTag('IPIOutr')
                        	::incluiTag('CST'    ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_CST" ])
                          	::incluiTag('vBC'    ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_vBC" ])
                          	::incluiTag('pIPI'   ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_pIPI" ])
                          	::incluiTag('vIPI'   ,::aItemIPI[ "item"+STRZERO(nItem,3)+"_vIPI" ])
                     	::incluiTag('/IPIOutr')
                    	ENDIF
               	::incluiTag('/IPI')
              ENDIF
            CATCH
            END
            
            
            // Mauricio Cruz - 04/10/2011
            TRY
               IF LEFT(::aItem[ "item"+STRZERO(nItem,3)+"_CFOP" ],1)='3'   // So precisa do II se for nota de importacao
                  ::incluiTag('II')
                     ::incluiTag('vBC'     ,::aItemII[ "item"+STRZERO(nItem,3)+"_vBC" ]      )
                     ::incluiTag('vDespAdu',::aItemII[ "item"+STRZERO(nItem,3)+"_vDespAdu" ] )
                     ::incluiTag('vII'     ,::aItemII[ "item"+STRZERO(nItem,3)+"_vII" ]      )
                     ::incluiTag('vIOF'    ,::aItemII[ "item"+STRZERO(nItem,3)+"_vIOF" ]     )
                  ::incluiTag('/II')
               ENDIF
            CATCH
            END

            // Mauricio Cruz - 30/09/2011
            IF EMPTY(::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ])
               ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ]:='01'
               ::aItemPIS[ "item"+STRZERO(nItem,3)+"_vBC" ]:='0.00'
               ::aItemPIS[ "item"+STRZERO(nItem,3)+"_pPIS" ]:='0.00'
               ::aItemPIS[ "item"+STRZERO(nItem,3)+"_vPIS" ]:='0.00'
            ENDIF

            
            
            // ATENCAO!!!  OS CODIGOS CST:  49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98 PARA PIS / COFINS
            // AINDA NAO FORAM IMPLEMENTADOS NO MANULA DA NF-E E DEVEM SER USADOS COMO 99 ATE QUE SEJA IMPLEMENTADO
            // FICAR DE OLHO PARA QUANDO ISSO SAIR!  (NT2010.001.PDF)  ->  JA FAZ DOIS ANOS ISSO! RECHECAR...
         	::incluiTag('PIS')
              	IF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02'
               	::incluiTag('PISAliq')
               ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '03'
               	::incluiTag('PISQtde')
               ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '04,06,07,08,09'
               	::incluiTag('PISNT')
               ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99,49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98'
               	::incluiTag('PISOutr')
               ENDIF
             	   ::incluiTag('CST'    ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ])
                 	IF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02'
                    	::incluiTag('vBC'        ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                    	::incluiTag('pPIS'       ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_pPIS" ])
                    	::incluiTag('vPIS'       ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_vPIS" ])
                	ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '03'
                    	::incluiTag('qBCProd'    ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_qBCProd" ])
                    	::incluiTag('vAliqProd'  ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ])
                    	::incluiTag('vPIS'       ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_vPIS" ])
                	ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99,49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98'
                     TRY
                    	   ::incluiTag('vBC'        ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                     CATCH
                        ::incluiTag('vBC'        ,'0.00')
                     END
                     TRY
                    	   ::incluiTag('pPIS'       ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_pPIS" ])
                     CATCH
                        ::incluiTag('pPIS'       ,'0.00')
                     END
                     
                     //Os campos vAliqProd e qBCProd só são gerados qdo o campo vAliqProd for maior que 0. 
                    	TRY
                        IF VAL(::aItemPIS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ])>0
                      	   ::incluiTag('qBCProd'    ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_qBCProd" ])
                        ENDIF
                    	CATCH
                        //::incluiTag('qBCProd'    ,'0.00')
                    	END
                    	TRY
                        IF VAL(::aItemPIS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ])>0
                      	   ::incluiTag('vAliqProd'  ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ])
                        *ELSE
                        *  ::incluiTag('vAliqProd'  ,'0.00')
                        ENDIF
                    	CATCH
                        *::incluiTag('vAliqProd'  ,'0.00')
                    	END
                     
                     TRY
                    	   ::incluiTag('vPIS'       ,::aItemPIS[ "item"+STRZERO(nItem,3)+"_vPIS" ])
                     CATCH
                        ::incluiTag('vPIS'       ,'0.00')
                     END
                	ENDIF
              	IF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02'
               	::incluiTag('/PISAliq')
               ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '03'
               	::incluiTag('/PISQtde')
               ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '04,06,07,08,09'
               	::incluiTag('/PISNT')
               ELSEIF ::aItemPIS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99,49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98'
               	::incluiTag('/PISOutr')
               ENDIF
         	::incluiTag('/PIS')

            // Mauricio Cruz - 30/09/2011
            IF EMPTY(::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ])
               ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST"]:='01'
               ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vBC" ]:='0.00'
               ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_pCOFINS" ]:='0.00'
               ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vCOFINS" ]:='0.00'
            ENDIF
            
         	::incluiTag('COFINS')
              	IF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02'
               	::incluiTag('COFINSAliq')
               ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '03'
               	::incluiTag('COFINSQtde')
               ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '04,06,07,08,09'
               	::incluiTag('COFINSNT')
               ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99,49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98'
               	::incluiTag('COFINSOutr')
               ENDIF
                	::incluiTag('CST'    ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ])
                 	IF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02'
                    	::incluiTag('vBC'        ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                    	::incluiTag('pCOFINS'    ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_pCOFINS" ])
                    	::incluiTag('vCOFINS'    ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vCOFINS" ])
                	ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '03'
                    	::incluiTag('qBCProd'    ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_qBCProd" ])
                    	::incluiTag('vAliqProd'  ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ])
                    	::incluiTag('vCOFINS'    ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vCOFINS" ])
                	ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99,49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98'
                     TRY
                 	      ::incluiTag('vBC'        ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vBC" ])
                     CATCH
                        ::incluiTag('vBC'        ,'0.00')
                     END
                     TRY
                    	   ::incluiTag('pCOFINS'    ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_pCOFINS" ])
                     CATCH
                        ::incluiTag('pCOFINS'    ,'0.00')
                     END
                     
                     //Os campos vAliqProd e qBCProd só são gerados qdo o campo vAliqProd for maior que 0. 
                    	TRY  
                        IF VAL(::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ])>0
                      	   ::incluiTag('qBCProd'    ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_qBCProd" ])
                        ENDIF
                    	CATCH
                        //::incluiTag('qBCProd'    ,'0.00')
                    	END
                    	TRY
                        IF VAL(::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ])>0
                     	     ::incluiTag('vAliqProd'  ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vAliqProd" ])
                        *ELSE
                        *   ::incluiTag('vAliqProd'  ,'0.00')
                        ENDIF
                    	CATCH
                        *::incluiTag('vAliqProd'  ,'0.00')
                    	END
                     TRY
                    	   ::incluiTag('vCOFINS'    ,::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_vCOFINS" ])
                     CATCH
                        ::incluiTag('vCOFINS'    ,'0.00')
                     END
                	ENDIF
              	IF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '01,02'
               	::incluiTag('/COFINSAliq')
               ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '03'
               	::incluiTag('/COFINSQtde')
               ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '04,06,07,08,09'
               	::incluiTag('/COFINSNT')
               ELSEIF ::aItemCOFINS[ "item"+STRZERO(nItem,3)+"_CST" ] $ '99,49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,70,71,72,73,74,75,98'
               	::incluiTag('/COFINSOutr')
               ENDIF
         	::incluiTag('/COFINS')


      	::incluiTag('/imposto')
       	TRY
          	::incluiTag('indfAdProd'   ,::aItem[ "item"+STRZERO(nItem,3)+"_indfAdProd" ])
         CATCH
         END
   	::incluiTag('/det')
   NEXT
   
	::incluiTag('total')
    	::incluiTag('ICMSTot')
      	::incluiTag('vBC',::aICMSTotal[ "vBC" ])
      	::incluiTag('vICMS',::aICMSTotal[ "vICMS" ])
         IF ::ohbNFe:versaoDados='3.10'
            ::incluiTag('vICMSDeson',::aICMSTotal[ "vICMSDeson" ])
         ENDIF
      	::incluiTag('vBCST',::aICMSTotal[ "vBCST" ])
      	::incluiTag('vST',::aICMSTotal[ "vST" ])
      	::incluiTag('vProd',::aICMSTotal[ "vProd" ])
      	::incluiTag('vFrete',::aICMSTotal[ "vFrete" ])
      	::incluiTag('vSeg',::aICMSTotal[ "vSeg" ])
      	::incluiTag('vDesc',::aICMSTotal[ "vDesc" ])
      	::incluiTag('vII',::aICMSTotal[ "vII" ])
      	::incluiTag('vIPI',::aICMSTotal[ "vIPI" ])
      	::incluiTag('vPIS',::aICMSTotal[ "vPIS" ])
      	::incluiTag('vCOFINS',::aICMSTotal[ "vCOFINS" ])
      	::incluiTag('vOutro',::aICMSTotal[ "vOutro" ])
      	::incluiTag('vNF',::aICMSTotal[ "vNF" ])
         IF ::lMostra_imp_danfe
            ::incluiTag('vTotTrib',::aICMSTotal[ "vTotTrib" ])
         ENDIF

    	::incluiTag('/ICMSTot')
	::incluiTag('/total')

	::incluiTag('transp')
   	::incluiTag('modFrete'  ,::aTransp[ "modFrete" ])
   	TRY
   	   IF !EMPTY( ::aTransp[ "xNome" ] )
         	::incluiTag('transporta')
          	   TRY
                 	::incluiTag('CNPJ'     ,::aTransp[ "CNPJ" ])
               CATCH
            	   TRY
                   	::incluiTag('CPF'      ,::aTransp[ "CPF" ])
                  CATCH
                  END
               END
            	::incluiTag('xNome'  ,::aTransp[ "xNome" ])
           	   TRY
               	::incluiTag('IE'     ,::aTransp[ "IE" ])
               CATCH
               END
           	   TRY
               	::incluiTag('xEnder' ,::aTransp[ "xEnder" ])
               CATCH
               END
           	   TRY
               	::incluiTag('xMun'   ,::aTransp[ "xMun" ])
               CATCH
               END
           	   TRY
               	::incluiTag('UF'     ,::aTransp[ "UF" ])
               CATCH
               END
          ::incluiTag('/transporta')
         ENDIF
      CATCH
      END
      
   	TRY
   	   IF !EMPTY( ::aVeicTransp[ "placa" ] )
            IF !oFuncoes:validaPlaca( ::aVeicTransp[ "placa" ] )
               aRetorno[ 'OK' ] := .F.
               aRetorno[ 'MsgErro' ] := 'Placa inválida ' + ::aVeicTransp[ "placa" ]
            ENDIF
            ::incluiTag('veicTransp')
               ::incluiTag('placa' ,::aVeicTransp[ "placa" ])
               ::incluiTag('UF'    ,::aVeicTransp[ "UF" ])
        	   TRY
            	::incluiTag('RNTC'   ,::aVeicTransp[ "RNTC" ])
            CATCH
            END
*::aVeicTransp[ "RNTC" ] := hIniData['Transportador']['RNTC']
         	::incluiTag('/veicTransp')
      ENDIF
      CATCH
      END

      TRY
         IF !EMPTY(::aReboque[ "placa" ])
            ::incluiTag('reboque')
               ::incluiTag('placa' ,::aReboque[ "placa" ])
               ::incluiTag('UF'    ,::aReboque[ "UF" ])
            ::incluiTag('/reboque')
         ENDIF
      CATCH
      END

      IF aRetorno[ 'OK' ] = .F.
         RETURN( aRetorno )
      ENDIF
   	//TRY
*      IF  _RegEmpresa()=614    
         /*
            Juliana-05/11/2014
            adicionado a condição acima ( .OR. ( VAL(::aTransp[ "qVol" ])=0 .AND. !EMPTY(::aTransp[ "esp" ]) )) 
            para atender PARA UM CLIENTE DA SYGECOM 
            (quando é granel não pode aparecer quantidade alguns portos exigem que o volumes seja 0 (ZERO)-(solicitado por Cynthia))
         */
*         IF VAL(::aTransp[ "qVol" ])>0 .OR. ( VAL(::aTransp[ "qVol" ])=0 .and. !EMPTY(hIniData['Volume001']['Especie'])) // .AND. (!EMPTY(::aTransp[ "esp" ]) .OR. VAL(::aTransp[ "pesoL" ])>0 .OR. VAL(::aTransp[ "pesoB" ])>0) 
*         	::incluiTag('vol')
*   	      TRY
*            	::incluiTag('qVol'   ,::aTransp[ "qVol" ])
*            CATCH
*            END
*   	      TRY
*            	::incluiTag('esp'   ,::aTransp[ "esp" ])
*            CATCH
*            END
*   	      TRY
*            	::incluiTag('marca'   ,::aTransp[ "marca" ])
*            CATCH
*            END
*   	      TRY
*            	::incluiTag('nVol'   ,::aTransp[ "nVol" ])
*            CATCH
*            END
*   	      TRY
*            	::incluiTag('pesoL'   ,::aTransp[ "pesoL" ])
*            CATCH
*            END
*   	      TRY
*            	::incluiTag('pesoB'   ,::aTransp[ "pesoB" ])
*            CATCH
*            END
*         	::incluiTag('/vol')
*         ENDIF
*      ELSE
   	   IF VAL(::aTransp[ "qVol" ])>0 // .AND. (!EMPTY(::aTransp[ "esp" ]) .OR. VAL(::aTransp[ "pesoL" ])>0 .OR. VAL(::aTransp[ "pesoB" ])>0) 
         	::incluiTag('vol')
   	      TRY
            	::incluiTag('qVol'   ,::aTransp[ "qVol" ])
            CATCH
            END
   	      TRY
            	::incluiTag('esp'   ,::aTransp[ "esp" ])
            CATCH
            END
   	      TRY
            	::incluiTag('marca'   ,::aTransp[ "marca" ])
            CATCH
            END
   	      TRY
            	::incluiTag('nVol'   ,::aTransp[ "nVol" ])
            CATCH
            END
   	      TRY
            	::incluiTag('pesoL'   ,::aTransp[ "pesoL" ])
            CATCH
            END
   	      TRY
            	::incluiTag('pesoB'   ,::aTransp[ "pesoB" ])
            CATCH
            END
         	::incluiTag('/vol')
         ENDIF
      *ENDIF   
      //CATCH
      //END
	::incluiTag('/transp')

   TRY
      IF !EMPTY( ::aDuplicatas[ "dup001_nDup" ] )
      	::incluiTag('cobr')
      	nNICob := nICob
      	FOR nICob = 1 TO nNICob
         	::incluiTag('dup')
            	::incluiTag('nDup'   ,::aDuplicatas[ "dup"+STRZERO(nICob,3)+"_nDup" ])
            	::incluiTag('dVenc'  ,::aDuplicatas[ "dup"+STRZERO(nICob,3)+"_dVenc" ])
            	::incluiTag('vDup'   ,::aDuplicatas[ "dup"+STRZERO(nICob,3)+"_vDup" ])
         	::incluiTag('/dup')
      	NEXT
      	::incluiTag('/cobr')
      ENDIF
   CATCH
   END

	IF  ::ohbNFe:versaoDados == '3.10'
      	nNIPag := nIPag
      	FOR nIPag = 1 TO nNIPag
		      ::incluiTag('pag')
		      ::incluiTag('tPag',::aPagamentos[ "pag"+STRZERO(nIPag,3)+"_tpag" ])
		      ::incluiTag('vPag',::aPagamentos[ "pag"+STRZERO(nIPag,3)+"_vpag" ])
		      ::incluiTag('/pag')
      	NEXT
   ENDIF
   
	IF  ::ohbNFe:versaoDados == '4.00'
	   TRY
      IF !EMPTY( ::aPagamentos[ "pag001_tpag" ] )
		      ::incluiTag('pag')
	      	nNIPag := nIPag
	      	FOR nIPag = 1 TO nNIPag
			 		::incluiTag('detPag')
				      ::incluiTag('tPag',::aPagamentos[ "pag"+STRZERO(nIPag,3)+"_tpag" ])
				      ::incluiTag('vPag',::aPagamentos[ "pag"+STRZERO(nIPag,3)+"_vpag" ])
			      ::incluiTag('/detPag')
	      	NEXT
		      ::incluiTag('/pag')
	      ENDIF
	   CATCH
	   END
   ENDIF
   
   ::incluiTag('infAdic')

   IF VAL(::aIde[ "tpEmis" ])=3 .OR. VAL(::aIde[ "tpEmis" ])=5 .OR. VAL(::aIde[ "tpEmis" ])=6 .OR. VAL(::aIde[ "tpEmis" ])=7
      TRY
         ::aInfAdic[ "infAdFisco" ]+=' Entrada em Contigencia em '+::aIde[ "dhCont" ]+' Justificativa: '+::aIde[ "xJust" ]
      CATCH
         ::aInfAdic[ "infAdFisco" ]:='Entrada em Contigencia em '+::aIde[ "dhCont" ]+' Justificativa: '+::aIde[ "xJust" ]
      END
   ENDIF

   TRY    // Mauricio Cruz - 05/10/2011
      ::incluiTag('infAdFisco',::aInfAdic[ "infAdFisco" ])
   CATCH
   END
   TRY    // Mauricio Cruz - 30/09/2011
      ::incluiTag('infCpl',::aInfAdic[ "infCpl" ])
   CATCH
   END
   ::incluiTag('/infAdic')
   
   IF ::ohbNFe:versaoDados='3.10'
      TRY
         IF !EMPTY(::aExporta[ 'UFEmbarq' ])
            ::incluiTag('exporta')
            ::incluiTag('UFSaidaPais'   , ::aExporta[ "UFEmbarq" ] )    // UFEmbarq - alterado o nome da TAG na versao 3.10
            ::incluiTag('xLocExporta' , ::aExporta[ "xLocEmbarq" ] )     // xLocEmbarq - alterado onome da TAG na versao 3.10
            ::incluiTag('/exporta')
         ENDIF
      CATCH
      END
   ELSE
      TRY
         IF !EMPTY(::aExporta[ 'UFEmbarq' ])
            ::incluiTag('exporta')
            ::incluiTag('UFEmbarq'   , ::aExporta[ "UFEmbarq" ] )
            ::incluiTag('xLocEmbarq' , ::aExporta[ "xLocEmbarq" ] )
            ::incluiTag('/exporta')
         ENDIF
      CATCH
      END
   ENDIF

	::incluiTag('/infNFe')

	::incluiTag('/NFe')
   
   MEMOWRIT(::ohbNFe:pastaNFe+"\"+cChaveNFe+'-nfe.xml',::cXMLSaida,.F.)
 
   IF ::lValida
        oAssina := hbNFeAssina()
        oAssina:ohbNFe := ::ohbNfe // Objeto hbNFe
        oAssina:cXMLFile := ::ohbNFe:pastaNFe+"\"+cChaveNFe+'-nfe.xml'
        oAssina:lMemFile := .F.
        aRetornoAss := oAssina:execute()
        oAssina := Nil

        IF aRetornoAss['OK'] == .F.
           aRetorno['OK'] := .F.
           aRetorno['MsgErro'] := aRetornoAss['MsgErro']
           RETURN(aRetorno)
        ELSE
           aRetorno['Assinou'] := .T.
        ENDIF

   cXmlAssinado	  :=memoread(::ohbNFe:pastaNFe+"\"+cChaveNFe+'-nfe.xml' )
   cInfNFe    := XmlNode( cXmlAssinado, "infNFe", .T. )
   cSignature := XmlNode( cXmlAssinado, "Signature", .T. )

   cAmbiente  := ::aIde[ "tpAmb" ]
   cUF        := ::aEmit[ "UF" ]
 
   // 1¦ Parte ( Endereco da Consulta - Fonte: http://nfce.encat.org/desenvolvedor/qrcode/ )
   IF cAmbiente == '1'
      DO CASE
      CASE cUF == "AC" ; QRCODE_Url := "http://www.sefaznet.ac.gov.br/nfce/qrcode?"
      CASE cUF == "AL" ; QRCODE_Url := "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?"
      CASE cUF == "AP" ; QRCODE_Url := "https://www.sefaz.ap.gov.br/nfce/nfcep.php?"
      CASE cUF == "AM" ; QRCODE_Url := "http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?"
      CASE cUF == "BA" ; QRCODE_Url := "http://nfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx"
      CASE cUF == "CE" ; QRCODE_Url := "http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html"
      CASE cUF == "DF" ; QRCODE_Url := "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx"
      CASE cUF == "ES" ; QRCODE_Url := "http://app.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?"
      CASE cUF == "GO" ; QRCODE_Url := "http://nfe.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe"
      CASE cUF == "MA" ; QRCODE_Url := "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?"
      CASE cUF == "MT" ; QRCODE_Url := "http://www.sefaz.mt.gov.br/nfce/consultanfce?"
      CASE cUF == "MS" ; QRCODE_Url := "http://www.dfe.ms.gov.br/nfce/qrcode?"
      CASE cUF == "MG" ; QRCODE_Url := ""
      CASE cUF == "PA" ; QRCODE_Url := "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/nfceForm.seam?"
      CASE cUF == "PB" ; QRCODE_Url := "http://www.receita.pb.gov.br/nfce?"
      CASE cUF == "PR" ; QRCODE_Url := "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?"
      CASE cUF == "PE" ; QRCODE_Url := "http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe?"
      CASE cUF == "PI" ; QRCODE_Url := "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf?"
      CASE cUF == "RJ" ; QRCODE_Url := "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?"
      CASE cUF == "RN" ; QRCODE_Url := "http://nfce.set.rn.gov.br/consultarNFCe.aspx?"
      CASE cUF == "RS" ; QRCODE_Url := "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?"
      CASE cUF == "RO" ; QRCODE_Url := "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp?"
      CASE cUF == "RR" ; QRCODE_Url := "https://www.sefaz.rr.gov.br/nfce/servlet/qrcode?"
      CASE cUF == "SC" ; QRCODE_Url := ""
      CASE cUF == "SP" ; QRCODE_Url := "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx?"
      CASE cUF == "SE" ; QRCODE_Url := "http://www.nfce.se.gov.br/portal/consultarNFCe.jsp?"
      CASE cUF == "TO" ; QRCODE_Url := ""
      ENDCASE
   ELSE
      DO CASE
      CASE cUF == "AC" ; QRCODE_Url := "http://hml.sefaznet.ac.gov.br/nfce/qrcode?"
      CASE cUF == "AL" ; QRCODE_Url := "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?"
      CASE cUF == "AP" ; QRCODE_Url := "https://www.sefaz.ap.gov.br/nfcehml/nfce.php?"
      CASE cUF == "AM" ; QRCODE_Url := "http://homnfce.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?"
      CASE cUF == "BA" ; QRCODE_Url := "http://hnfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx"
      CASE cUF == "CE" ; QRCODE_Url := "http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html"
      CASE cUF == "DF" ; QRCODE_Url := "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx"
      CASE cUF == "ES" ; QRCODE_Url := "http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?"
      CASE cUF == "GO" ; QRCODE_Url := ""
      CASE cUF == "MA" ; QRCODE_Url := "http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?"
      CASE cUF == "MT" ; QRCODE_Url := "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce?"
      CASE cUF == "MS" ; QRCODE_Url := "http://www.dfe.ms.gov.br/nfce/qrcode?"
      CASE cUF == "MG" ; QRCODE_Url := ""
      CASE cUF == "PA" ; QRCODE_Url := "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/nfceForm.seam"
      CASE cUF == "PB" ; QRCODE_Url := "http://www.receita.pb.gov.br/nfcehom"
      CASE cUF == "PR" ; QRCODE_Url := "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?"
      CASE cUF == "PE" ; QRCODE_Url := "http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe?"
      CASE cUF == "PI" ; QRCODE_Url := "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf?"
      CASE cUF == "RJ" ; QRCODE_Url := "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?"
      CASE cUF == "RN" ; QRCODE_Url := "http://hom.nfce.set.rn.gov.br/consultarNFCe.aspx?"
      CASE cUF == "RS" ; QRCODE_Url := "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?"
      CASE cUF == "RO" ; QRCODE_Url := "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp?"
      CASE cUF == "RR" ; QRCODE_Url := "http://200.174.88.103:8080/nfce/servlet/qrcode?"
      CASE cUF == "SC" ; QRCODE_Url := ""
      CASE cUF == "SP" ; QRCODE_Url := "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx"
      CASE cUF == "SE" ; QRCODE_Url := "http://www.hom.nfe.se.gov.br/portal/consultarNFCe.jsp?"
      CASE cUF == "TO" ; QRCODE_Url := ""
      ENDCASE
   ENDIF

   // 2¦ Parte (Parametros)
   QRCODE_chNFe    := cChaveNFe
   QRCODE_nVersao  := "100"
   QRCODE_tpAmb    := cAmbiente
   QRCODE_cDest    := XmlNode( XmlNode( cInfNFe, "dest" ), "CPF" )
   IF Empty( QRCODE_cDest )
      QRCODE_cDest := XmlNode( XmlNode( cInfNFe, "dest" ), "CNPJ" )
   ENDIF
   QRCODE_dhEmi    := hb_StrToHex( XmlNode( XmlNode( cInfNFe, "ide" ), "dhEmi" ) )
   QRCODE_vNF      := XmlNode( XmlNode( XmlNode( cInfNFe, "total" ), "ICMSTot" ), "vNF" )
   QRCODE_vICMS    := XmlNode( XmlNode( XmlNode( cInfNFe, "total" ), "ICMSTot" ), "vICMS" )
   QRCODE_digVal   := hb_StrToHex( XmlNode( XmlNode( XmlNode( cSignature, "SignedInfo" ), "Reference" ), "DigestValue" ) )
   QRCODE_cIdToken := ::IDToken
   QRCODE_cCSC     := ::Token

    IF !Empty( QRCODE_chNFe ) .AND. !Empty( QRCODE_nVersao ) .AND. !Empty( QRCODE_tpAmb    ) .AND. !Empty( QRCODE_dhEmi ) .AND. !Empty( QRCODE_vNF ) .AND.;
      !Empty( QRCODE_vICMS ) .AND. !Empty( QRCODE_digVal  ) .AND. !Empty( QRCODE_cIdToken ) .AND. !Empty( QRCODE_cCSC  )

      QRCODE_chNFe    := "chNFe="    + QRCODE_chNFe    + "&"
      QRCODE_nVersao  := "nVersao="  + QRCODE_nVersao  + "&"
      QRCODE_tpAmb    := "tpAmb="    + QRCODE_tpAmb    + "&"
      // Na hipotese do consumidor nao se identificar na NFC-e, nao existira o parametro cDest no QR Code
      // e tambem nao devera ser incluido o parametro cDest na sequencia sobre a qual sera aplicado o hash do QR Code
      IF !Empty( QRCODE_cDest )
         QRCODE_cDest := "cDest="    + QRCODE_cDest    + "&"
      ENDIF
      QRCODE_dhEmi    := "dhEmi="    + QRCODE_dhEmi    + "&"
      QRCODE_vNF      := "vNF="      + QRCODE_vNF      + "&"
      QRCODE_vICMS    := "vICMS="    + QRCODE_vICMS    + "&"
      QRCODE_digVal   := "digVal="   + QRCODE_digVal   + "&"
      QRCODE_cIdToken := "cIdToken=" + QRCODE_cIdToken

      // 3¦ Parte (cHashQRCode)
      QRCODE_cHash := ( "&cHashQRCode=" +;
                        hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cCSC ) )

      // Resultado da URL formada a ser incluida na imagem QR Code
      QRCODE_cTag  := ( "<![CDATA[" +;
                        QRCODE_Url + QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cHash +;
                        "]]>" )

   	aRetorno['cQrCode'] := QRCODE_Url + QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cHash

      // XML com a Tag do QRCode
      cXmlAssinado := [<NFe xmlns="http://www.portalfiscal.inf.br/nfe">]
      cXmlAssinado += cInfNFe
      cXmlAssinado += [<]+"infNFeSupl"+[>]
      cXmlAssinado += [<]+"qrCode"+[>] + QRCODE_cTag + [</]+"qrCode"+[>]
      cXmlAssinado += [</]+"infNFeSupl"+[>]
      cXmlAssinado += cSignature
      cXmlAssinado += [</NFe>]
   
		MEMOWRIT(::ohbNFe:pastaNFe+"\"+cChaveNFe+'-nfe.xml',cXmlAssinado,.F.)
    
   ELSE
      RETURN "Erro na geracao do QRCode"
   ENDIF

        oValida := hbNFeValida()
        oValida:ohbNFe := ::ohbNfe // Objeto hbNFe
        oValida:cXML := ::ohbNFe:pastaNFe+"\"+cChaveNFe+'-nfe.xml' // Arquivo XML ou ConteudoXML
        aRetornoVal := oValida:execute()
        oValida := Nil
        IF aRetornoVal['OK'] == .F.
           aRetorno['OK'] := .F.
           aRetorno['MsgErro'] := aRetornoVal['MsgErro']
           RETURN(aRetorno)
        ELSE
           aRetorno['Validou'] := .T.
        ENDIF
   ENDIF
   aRetorno['OK'] := .T.
   aRetorno['chNFe'] := cChaveNFe
   aRetorno['cXMLRet'] := ::ohbNFe:pastaNFe+"\"+cChaveNFe+'-nfe.xml'     // Mauricio Cruz - 30/09/2011
   
RETURN(aRetorno)

METHOD incluiTag(cTag,cValor) CLASS hbNFCeIniToXML
   IF cValor = Nil
      ::cXMLSaida += '<'+cTag+'>'
   ELSEIF EMPTY(cValor)
      IF cTag == 'nro'
         ::cXMLSaida += '<'+cTag+'>'+cValor+'</'+cTag+'>'
      ELSE
         ::cXMLSaida += '<'+cTag+' />'
      ENDIF
   ELSE
      cValor:=CLEAR_CHAR(cValor)
      ::cXMLSaida += '<'+cTag+'>'+cValor+'</'+cTag+'>'
   ENDIF
RETURN Nil



STATIC FUNCTION CLEAR_CHAR(cTXT)
/*
   detona com caracteres indesejados
   Mauricio cruz - 23/11/2011
*/
LOCAL mI, cRET:=cTXT

IF VALTYPE(cRET)<>'C'
   RETURN(cRET)
ENDIF

IF DAY(CTOD(cRET))>0   // EM CASO DE DATAS
   RETURN(cRET)
ENDIF

cRET:=TIRAACENTO(cRET)

FOR mI:=1 TO 31
   IF CHR(mI)$cRET
      cRET:=StrTran( cRET, CHR(mI))
   ENDIF
NEXT
//cRET:=STRTRAN(cRET,'-')
cRET:=STRTRAN(cRET,'–')
IF CHR(145)$cRET // æ
   cRET:=StrTran( cRET, CHR(145))
ENDIF
IF CHR(146)$cRET  // Æ
   cRET:=StrTran( cRET, CHR(146))
ENDIF
IF CHR(155)$cRET  // ø
   cRET:=StrTran( cRET, CHR(155))
ENDIF
FOR mI:=156 TO 159  // £  Ø × ƒ 
   IF CHR(mI)$cRET
      cRET:=StrTran( cRET, CHR(mI))
   ENDIF
NEXT
IF CHR(166)$cRET  //  ª
   cRET:=StrTran( cRET, CHR(166))
ENDIF
IF CHR(167)$cRET    //  º
   cRET:=StrTran( cRET, CHR(167))
ENDIF
FOR mI:=169 TO 254  // ® ¬ ½ ¼ ¡ « » .....
   IF CHR(mI)$cRET
      cRET:=StrTran( cRET, CHR(mI))
   ENDIF
NEXT

cRET:=ALLTRIM(cRET)
RETURN(cRET)




STATIC FUNCTION TiraAcento(cText)
/*
   remove os acentos
   Leonardo Machado
*/
  cText:= StrTran(cText,"Ã","A")
  cText:= StrTran(cText,"Â","A")
  cText:= StrTran(cText,"Á","A")
  cText:= StrTran(cText,"Ä","A")
  cText:= StrTran(cText,"À","A")
  cText:= StrTran(cText,"ã","a")
  cText:= StrTran(cText,"â","a")
  cText:= StrTran(cText,"á","a")
  cText:= StrTran(cText,"ä","a")
  cText:= StrTran(cText,"à","a")

  cText:= StrTran(cText,"É","E")
  cText:= StrTran(cText,"Ê","E")
  cText:= StrTran(cText,"Ë","E")
  cText:= StrTran(cText,"È","E")
  cText:= StrTran(cText,"é","e")
  cText:= StrTran(cText,"ê","e")
  cText:= StrTran(cText,"ë","e")
  cText:= StrTran(cText,"è","e")
  cText:= StrTran(cText,"Í","I")

  cText:= StrTran(cText,"Î","I")
  cText:= StrTran(cText,"Ï","I")
  cText:= StrTran(cText,"Ì","I")
  cText:= StrTran(cText,"í","i")
  cText:= StrTran(cText,"î","i")
  cText:= StrTran(cText,"ï","i")
  cText:= StrTran(cText,"ì","i")

  cText:= StrTran(cText,"Ó","O")
  cText:= StrTran(cText,"Õ","O")
  cText:= StrTran(cText,"Ô","O")
  cText:= StrTran(cText,"ó","O")
  cText:= StrTran(cText,"Ö","O")
  cText:= StrTran(cText,"Ò","O")
  cText:= StrTran(cText,"õ","o")
  cText:= StrTran(cText,"ô","o")
  cText:= StrTran(cText,"ó","o")
  cText:= StrTran(cText,"ö","o")
  cText:= StrTran(cText,"ò","o")
  cText := StrTran(cText,"º","")
  cText:= StrTran(cText,CHR(176),"")

  cText:= StrTran(cText,"Û","U")
  cText:= StrTran(cText,"Ú","U")
  cText:= StrTran(cText,"Ü","U")
  cText:= StrTran(cText,"Ù","U")
  cText:= StrTran(cText,"û","u")
  cText:= StrTran(cText,"ú","u")
  cText:= StrTran(cText,"ü","u")
  cText:= StrTran(cText,"ù","u")

  cText := StrTran(cText,"Ç","C")
  cText := StrTran(cText,"ç","c")
return(cText)

 