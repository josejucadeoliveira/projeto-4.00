STATIC wLojaEstq := '01'
#INCLUDE "MINIGUI.CH"
************************************
func importa_xml()

***********************************
local varios := .t.   && selecionar varios arquivos
local arq_cas := {}, i, n_for, File_cas, m_rat
nTela:=1
x_Diretorio       :=DiskName()+":\"+CurDir()+"\"
cCurDir := x_Diretorio
Public cCurDir := x_Diretorio

*else
*	Public cCurDir := "\onde\"
*end

p_GetFile := cCurDir///iif( empty( p_GetFile ) , GetMyDocumentsFolder() , p_GetFile )

if nTela==1
arq_cas := GetFile ( { ;
	{'Arquivo XML' , '*-nfe.XML'} },;
	'Abre Arquivos' , p_GetFile , varios , .t. )
else
arq_cas := GetFile ( { ;
	{'Arquivo XML' , '*.XML'} },;
	'Abre Arquivos' , p_GetFile , varios , .t. )
end
if len( arq_cas ) = 0
	return nil
endif


m_rat = rat('\',arq_cas[1])
p_GetFile := left( arq_cas[1] , m_rat-1 )
 
col:=len(p_GetFile)+2
 
PUBLIC cNomeArquivo:=(substr(arq_cas[1],col,70))
public cFileDanfe:=arq_cas[1]
if nTela==1
*		form_1.arquivo.value := arq_cas[1]
end

Lerxml_importo(nTela,cFileDanfe) 

retu nil


//------------------------------------------------------------
Function Lerxml_importo(nTela,cFileDanfe)
 		  Local nCounter:= 0
Local oRow
Local i
local tot :=0
Local oQuery
local iRow 
local aRow
local pegacodigo1
local pegacodigo2
local pegacodigo3
local cWindow:='NFe'
local c_encontro
Local Estru     := {  {'Id'        ,'C', 44,0},;
                      {'ErroJAF'   ,'l', 01,0},;  //
                      {'Ocorrenc'  ,'C', 20,0},;  //
                      {'CNPJ'      ,'C', 14,0},;  //
                      {'cProd'     ,'C', 16,0},;
                      {'xProd'     ,'C', 60,0},;  // Codigo Interno
                      {'cEAN'      ,'C', 16,0},;
                      {'qCom'      ,'N', 13,3},;
                      {'vProd'     ,'N', 13,2},;
                      {'vUnCom'    ,'N', 11,3},;
                      {'vIcms'     ,'N', 11,3},;
                      {'vPis'      ,'N', 11,3},;
                      {'vCofins'   ,'N', 11,3},;
                      {'vIpi'      ,'N', 11,3} }



    If cFileDanfe==Nil
       msginfo('Informe o nome do Danfe em xml')
       Return nil
    Endif

    If ! file(cFileDanfe)
         msginfo('Arquivo nao Localizado'+cFileDanfe)
         Return nil
    Endif
Reconectar_A()


    cPegaChave := Space(47)
    Linha       := Memoread(cFileDanfe)
    nLinhalidas := 0
    Linhatotal  := Len(Linha)
    cLinhaTxt   :=Linha
    X_xml       :=LinhA
	
    //-- Pega Id da Nota Fiscal
    nPos1 := At('Id="',Linha)
    If nPos1==0
       msginfo('Erro no Arquivo '+cFileDanfe+Chr(10)+;
               'Id=')
       Return nil
    Endif
	
	
	   //[DADOS DO EMITENTE]
       cLIDOS1:=[] ; LINHA1:=[]
   
	
		   
       nPos1 := nPos1+Len('Id="')
       cChave:= Substr(Linha,nPos1,50)
       m_cNF   := PegaDados('nNF'   ,Alltrim(Linha),.f. )
       m_serie := PegaDados('serie' ,Alltrim(Linha),.f. )
       m_dEmi  := PegaDados('dEmi'  ,Alltrim(Linha),.f. )
       m_Razao := PegaDados('xNome' ,Alltrim(Linha),.f. )
       m_vBC   := Val(PegaDados('vBC'   ,Alltrim(Linha),.f. ))
       m_vICMS := Val(PegaDados('vICMS' ,Alltrim(Linha),.f. ))
       m_vProd := Val(PegaDados('vProd' ,Alltrim(Linha),.f. ))
       mvNFvalor   := Val(PegaDados('vNF'   ,Alltrim(Linha),.f. ))
       m_vOutro:= Val(PegaDados('vOutro',Alltrim(Linha),.f. ))


	
abreDADOSNFE()

         SELE DADOSNFE
         OrdSetFocus('NUMSEQ')
m_cNF:=val(m_cNF)   
		   
	
	 
	    	if (!EOF())
                    If LockReg()  
		    	       DADOSNFE-> TOTAL_VEN  := mvNFvalor
                       DADOSNFE-> VALOR_TOT  :=mvNFvalor
					  * DADOSNFE-> TOTAL_VEN  := mvNFvalor
                      * DADOSNFE-> VALOR_TOT  :=mvNFvalor
					  * DADOSNFE-> chave      :=cChave
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
	                Unlock
		          ENDIF                 
          else
                  
					 
	                   DADOSNFE->(dbappend())
			   		   DADOSNFE-> TOTAL_VEN  := mvNFvalor
                       DADOSNFE-> VALOR_TOT  :=mvNFvalor
			         * DADOSNFE-> chave      :=cChave
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
                    endif
				


	   

	   //[DADOS DO EMITENTE]
       cLIDOS1:=[] ; LINHA1:=[]

       cLidos1 := PegaDados('emit',Alltrim(cLinhaTxt),.t.,'emit')
       Linha1   := cLidos1
       
	   cCGCEmit  := PegaDados( [CNPJ]	 ,Alltrim(Linha1) ,.f.)
       xNome     := PegaDados( [xNome]   ,Alltrim(Linha1),.f. )
       xLgr      := PegaDados( [xLgr]    ,Alltrim(Linha1),.f. )
       nro       := PegaDados( [nro]     ,Alltrim(Linha1),.f. )
       xBairro   := PegaDados( [xBairro] ,Alltrim(Linha1),.f. )
       cMun      := PegaDados( [cMun]    ,Alltrim(Linha1),.f. )
       xMun      := PegaDados( [xMun]    ,Alltrim(Linha1),.f. )
       UF        := PegaDados( [UF]      ,Alltrim(Linha1),.f. )
       CEP       := PegaDados( [CEP]     ,Alltrim(Linha1),.f. )
       cPais     := PegaDados( [cPais]   ,Alltrim(Linha1),.f. )
       xPais     := PegaDados( [xPais]   ,Alltrim(Linha1),.f. )
       fone      := PegaDados( [fone]    ,Alltrim(Linha1),.f. )
       IE        := PegaDados( [IE]      ,Alltrim(Linha1),.f. )
 
nitem:=0

         SELE DADOSNFE
         OrdSetFocus('NUMSEQ')
   
		   
*msginfo(xNome)

				* 	if (!EOF())
                    If LockReg()  
		               DADOSNFE-> NUM_SEQ    :=m_cNF 
					   DADOSNFE-> NOM_CLI    :=xNome
				       DADOSNFE-> NUM_SEQ    :=m_cNF 
					   DADOSNFE-> NOM_CLI    :=xNome
			   		   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
                    endif
				


	   //[DADOS DO DESTINATARIO]
       cLIDOS1:=[] ; LINHA1:=[]

       cLidos1 := PegaDados('dest',Alltrim(cLinhaTxt),.t.,'dest')
       Linha1   := cLidos1

       dest_CNPJ      := PegaDados( [CNPJ]    ,Alltrim(Linha1),.f. )
       dest_xNome     := PegaDados( [xNome]   ,Alltrim(Linha1),.f. )
       dest_xLgr      := PegaDados( [xLgr]    ,Alltrim(Linha1),.f. )
       dest_nro       := PegaDados( [nro]     ,Alltrim(Linha1),.f. )
       dest_xBairro   := PegaDados( [xBairro] ,Alltrim(Linha1),.f. )
       dest_cMun      := PegaDados( [cMun]    ,Alltrim(Linha1),.f. )
       dest_xMun      := PegaDados( [xMun]    ,Alltrim(Linha1),.f. )
       dest_UF        := PegaDados( [UF]      ,Alltrim(Linha1),.f. )
       dest_CEP       := PegaDados( [CEP]     ,Alltrim(Linha1),.f. )
       dest_cPais     := PegaDados( [cPais]   ,Alltrim(Linha1),.f. )
       dest_xPais     := PegaDados( [xPais]   ,Alltrim(Linha1),.f. )
       dest_fone      := PegaDados( [fone]    ,Alltrim(Linha1),.f. )
       dest_IE        := PegaDados( [IE]      ,Alltrim(Linha1),.f. )

	   //[DADOS DO RETORNO SEFAZ]
       cLidos1 := PegaDados('infProt',Alltrim(cLinhaTxt),.t.,'infProt')
       Linha1   := cLidos1
       
       nProt     := PegaDados( [nProt]   ,Alltrim(Linha1),.f. )
       digVal    := PegaDados( [digVal]  ,Alltrim(Linha1),.f. )
       cStat     := PegaDados( [cStat]   ,Alltrim(Linha1),.f. )
       xMotivo   := 'Autorizado o uso da NF-e'
       linha :=[] ; cLIDOS:=[] ; nsize:=nLinhaLidas:=0
   
		
	   //[DADOS faturamento]
       cLIDOS1:=[] ; LINHA1:=[]

       cLidos1 := PegaDados('fat',Alltrim(cLinhaTxt),.t.,'fat')
       Linha1   := cLidos1
       xmnFat      :=val(PegaDados( [nFat]    ,Alltrim(Linha1),.f. ))
       linha :=[] ; cLIDOS:=[] ; nsize:=nLinhaLidas:=0
 *	msginfo(xmnFat)
	
 cPesq   := Substr(cChave,4,44)
 X1:=0
 
* msginfo(cPesq)
Do While .t.
          cLidos := PegaDados('det nItem',Alltrim(cLinhaTxt),.t.,'det' )
          Linha  := cLidos
           
          If Linha=='0'
             Exit
          Endif
X1++
		  
          mxProd     := PegaDados('xProd',Alltrim(Linha) ,.f.)
		  mnItem  := (PegaDados('nItem ',Alltrim(Linha) ,.f.))
	      mcprod  := PegaDados('cProd',Alltrim(Linha) ,.f.)
          mUnid   := PegaDados('uCom' ,Alltrim(Linha) ,.f.) 
          mNCM    := PegaDados('NCM' ,Alltrim(Linha) ,.f.) 
          mqcom   := Val(PegaDados('qCom' ,Alltrim(Linha) ,.f.) )
          mvprod  := Val(PegaDados('vProd',Alltrim(Linha) ,.f.) )
		  cEANTrib  := PegaDados('cEANTrib' ,Alltrim(Linha) ,.f.)
		  cEAN  := PegaDados('cEAN' ,Alltrim(Linha) ,.f.)
          mceanbar:= PegaDados('cEAN' ,Alltrim(Linha) ,.f.)
		  mcst    := PegaDados('orig' ,Alltrim(Linha) ,.f.)
		  mvuncom := val(PegaDados('vUnCom' ,Alltrim(Linha) ,.f.) )
          mvBaseIcms  := val(PegaDados('vBC' ,Alltrim(Linha) ,.f.) )
          mpIcms  := val(PegaDados('pICMS' ,Alltrim(Linha) ,.f.) )
          mvIcms  := val(PegaDados('vICMS' ,Alltrim(Linha) ,.f.) )
          mVpis   := val(PegaDados('vPIS' ,Alltrim(Linha) ,.f.) )
          pVpis   := val(PegaDados('pPIS' ,Alltrim(Linha) ,.f.) )
          mcEnq   := (PegaDados('cEnq' ,Alltrim(Linha) ,.f.) )
          mVipi   := val(PegaDados('vIPI' ,Alltrim(Linha) ,.f.) )
		  mpIPI   := val(PegaDados('pIPI' ,Alltrim(Linha) ,.f.) )
        	CST   :=     pEgaDados('CST'     ,Alltrim(Linha) ,.f.)
		  pmodBC  := val(PegaDados('modBC' ,Alltrim(Linha) ,.f.) )
		  vTotTrib:= val(PegaDados('vTotTrib' ,Alltrim(Linha) ,.f.) )
          vFRETE := val(PegaDados('vFrete' ,Alltrim(Linha) ,.f.) )

		  mvDesc  := val(PegaDados('vDesc' ,Alltrim(Linha) ,.f.) )
	      mVCofins:= val(PegaDados('vCOFINS' ,Alltrim(Linha) ,.f.) )
          PVCofins:= val(PegaDados('pCOFINS' ,Alltrim(Linha) ,.f.) )
          mRBC    := val(PegaDados('pRedBC' ,Alltrim(Linha) ,.f.) )
		  nDup    := val(PegaDados('vDup' ,Alltrim(Linha) ,.f.) )
	
         * cPesq   := Substr(cChave,4,44)
		  desc:=mvDesc/mvprod*100
	


GTOTAL:=mvuncom*mqcom
PFRETE:=VFRETE/GTOTAL*100

xSEQ_TEF := strzero(day(date() ),2 ) + strzero(month(date() ), 2 ) + strtran(time(), ':','' )
xSEQ_TEF:=val(xSEQ_TEF)
mnItem:=vaL(mnItem)

                ITEMNFE->(DBAPPEND())
                 ITEMNFE->PRODUTO :=mcprod
                 ITEMNFE->cod_prod:=val(mcprod)
                 ITEMNFE->descricao   :=mxProd  
                 ITEMNFE->QUANT    := mqcom
  			     ITEMNFE->cEANTrib   :=cEANTrib 
                 ITEMNFE->cEAN    := cEAN
				 ITEMNFE->qtd      := mqcom
				 ITEMNFE->ncm      := mNCM
		         ITEMNFE->SUBTOTAL :=mvuncom*mqcom
                 ITEMNFE->unid     :=mUnid
	         	 ITEMNFE->valor    := (mvuncom) 
                 ITEMNFE->preco    := (mvuncom) 
				 ITEMNFE->STB      := 900
                 ITEMNFE->st       := '101'
				 ITEMNFE->nseq_orc :=m_cNF
                 ITEMNFE->vICMS    :=mvIcms
                 ITEMNFE->ICMS     := mpIcms
				 ITEMNFE->VCofins  := mVCofins
                 ITEMNFE->pCofins  := pVCofins
                 ITEMNFE->vPIS     := mVpis
		         ITEMNFE->pPIS     := pVpis
		      	 ITEMNFE->vBC      := mvBaseIcms
				 ITEMNFE->N_IBPT   :=vTotTrib
				 ITEMNFE->seq_t    :=(xSEQ_TEF)+X1
				 ITEMNFE->FRETE    :=vFRETE
				 ITEMNFE->FRETEP   :=PFRETE
				 ITEMNFE->ModalST  :=pmodBC
				 ITEMNFE->orig     :=ALLTRIM(mcst)
				  ITEMNFE->cEnq    :=mcEnq
	    		  ITEMNFE->Vipi    :=mVipi	 
				  ITEMNFE->pIPI    :=mpIPI
				  ITEMNFE->CSTIPI  :='50'
				IF mpIPI = 0
			 	 ITEMNFE->VBCIPI      :=0
				 ELSE
			  ITEMNFE->VBCIPI      :=mvBaseIcms
				ENDIF
	      	     ITEMNFE->(DBCOMMIT())
	             ITEMNFE->(DBUNLOCK())
				 
				 

					
          nSize         := Linhatotal-nLinhaLidas
          cLinha        := Right(cLinhaTxt,nSize)
          cLinhaTxt     := cLinha
          If nLinhaLidas > Linhatotal
             Exit
          Endif

          If nLinhaLidas = Linhatotal
             msginfo(dest_ie)
             exit
          Endif
		  



 Enddo

 


    cLIDOS1:=[] ; LINHA1:=[]

       cLidos1 := PegaDados('total',Alltrim(cLinhaTxt),.t.,'total')
       Linha1   := cLidos1

        xvTotTrib      := PegaDados( [vTotTrib]    ,Alltrim(Linha1),.f. )
        mvICMS         := PegaDados( [vICMS]   ,Alltrim(Linha1),.f. )
        vvBC           := PegaDados( [vBC]    ,Alltrim(Linha1),.f. )
        mvPIS          := PegaDados( [vPIS]     ,Alltrim(Linha1),.f. )
        vCOFINS        := PegaDados( [vCOFINS] ,Alltrim(Linha1),.f. )
        mvTotTrib      := PegaDados( [vTotTrib]    ,Alltrim(Linha1),.f. )
        vvNF           := PegaDados( [vNF]    ,Alltrim(Linha1),.f. )
          MvIPI        := PegaDados( [vIPI]      ,Alltrim(Linha1),.f. )
   

	abreDADOSNFE()

sele dadosnfe
	* 	if (!EOF())
                    If LockReg()  
		               DADOSNFE-> total_imp    :=val(xvTotTrib)
					   DADOSNFE-> VBC    :=val( vvBC)
					   DADOSNFE-> vICMS  :=val( mvICMS)
					   DADOSNFE-> Vpis   :=val( mvPIS)
					   DADOSNFE-> vconfins:=val( vCOFINS)
					   DADOSNFE->vTotTrib :=val( mvTotTrib)
					   DADOSNFE-> chave      :=cPesq
					   DADOSNFE->vIPI        :=val(MvIPI)
					   DADOSNFE-> TOTAL_VEN  := val(vvNF)
                       DADOSNFE-> VALOR_TOT  :=val(vvNF)
					   DADOSNFE->(dbcommit())
                       DADOSNFE->(dbunlock())
                    endif
				


 
 
Return nil

