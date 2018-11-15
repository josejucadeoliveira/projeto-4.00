Function MenuNFe( SysOperation )
******************************
* Mostra menu de opcoes de NFe
* Operacoes disponiveis :
*     1 StatusServico
*     2 CriarNFe
*     3 AssinarNFe
*     4 ValidarNFe
*     5 EnviarNFe
*     6 CriarEnviarnNFe
*     7 ConsultarNFe
*     8 CancelarNFe
*     9 ImprimirDANFe
*    10 InutilizarNFe
*    11 EnviarEmail
*    12 NFE.RECIBONFE("nREC")    Imprime recibo ***
**********************************************************
* Arquivos que devem ser guardados:
* -nfe.xml, -can.xml, -ped-can.xml, -inu.xml, -ped-inu.xml
**********************************************************

save screen to TELA_NFe
ArqAntNFe := dbf()

if !setup->OnNFe
   MsgAlert('M¢dulo NFe-Nota Fiscal Eletr“nica DESATIVADA...')
   return(.f.)
endif

do while .t.
   *** Vai para o arquivo anterior ao modulo (CADVENDA,CADOS,CADPEDc) ***
   select (ArqAntNFe)

   *** Entra fechando transacao NFe para evitar problemas ***
   ACBR_FechaNFe()
   CONTACF     := 0
   MUDAFPG     := .f.
   SairPgto    := .f.
   CupomAberto := .f.
   OPC2        := 1
   vNROVENDA   := space(7)

   if !file('C:\MONITOR\ACBRNFEMONITOR.EXE')
      MsgAlert('ATEN€ÇO este terminal NÇO esta configurado para emitir NFe...')
      exit
   endif
   
   if !FrmMenuNFe()
      exit
   endif

   menus('05','18','23','72',' Opera‡äes com NFe ')
   @ 06,20 prompt ' 1 þ Verifica Status dos WebServices               '  // 1
   @ 07,20 prompt ' 2 þ Gerar Nova NFe e Enviar                       '  // 2
   @ 08,20 prompt ' 3 þ Gerar NFe e Enviar (Mesmo N§ NFe)             '  // 3
   @ 09,20 prompt ' 4 þ Imprimir DANFE                                '  // 4
   @ 10,20 prompt ' 5 þ Consultar NFe                                 '  // 5
   @ 11,20 prompt ' 6 þ Cancelar NFe                                  '  // 6
   @ 12,20 prompt ' 7 þ Inutilizar NFe                                '  // 7
   @ 13,20 prompt ' 8 þ Enviar NFe por email                          '  // 8
   @ 14,20 prompt ' 9 þ Enviar NFe Gerada em Contingˆncia             '  // 9
   @ 15,20 prompt ' A þ Recuperar/Cadastrar Chave NFe                 '  // 10
   @ 16,20 prompt ' B þ Imprimir DANFE de NFe Cancelada               '  // 11
   @ 17,20 prompt ' C þ Mover NFe para Diret¢rio do Mes               '  // 12
   @ 18,20 prompt ' D þ Mudar S‚rie NFe Geradas DE/PARA Contingencia  '  // 13
   @ 19,20 prompt ' E þ Copiar NFe geradas para contador              '  // 14
   @ 20,20 prompt ' F þ Gerar e Enviar Carta Corre‡Æo Eletr“nica (CCe)'  // 15
   @ 21,20 prompt ' G þ Recuperar XML de NFe Emitida                  '  // 16
   @ 22,20 prompt ' H þ Imprimir Carta de Corre‡Æo Eletr“nica (CCe)   '  // 16
   menu to OPC2
   if lastkey() == 27
      restore screen from TELA_NFe
      exit
   endif

   *** Se Emissao ou Impressao DANFE
   if OPC2 == 2  .or.  ;      // Gerar Nova NFe
      OPC2 == 3  .or.  ;      // Gerar NFe com mesmo numero
      OPC2 == 4  .or.  ;      // Imprimir DANFE
      OPC2 == 6  .or.  ;      // Cancelar  NFe
      OPC2 == 10              // Recupera Chave

      if !Funcao_Buscar_Venda_NFe()
         loop
      endif

      *** Se for impressao de DANFE ou CONSULTA ***
      oNUMERO   := 0
      oSERIE    := vSERIE := space(3)
      oDATA     := ctod('')
      oNFE_RAND := space(10)
      oNROVENDA := space(07)
      oORIGEM   := space(04)

      if !Funcao_Gerar_DBF_NFe()
         loop
      endif

   endif

   *** Abre arquivos temporarios de controle da NFe ***
   if !ACBR_AbreNFe()
      loop
   endif

   do case
      case OPC2 == 1
           if !ACBR_StatusServicoNFe()
              loop
           endif

      case OPC2 == 2
           *** Gera nota fiscal ***
           if !Funcao_Gerar_INI_NFe()
              loop
           endif

      case OPC2 = 3
           *** Gera com mesmo numero ***
           if !Funcao_Gerar_INI_NFe()
              loop
           endif

		case OPC2 = 4
		     if !Funcao_Imprimir_DANFE()
              loop
           endif

      case OPC2 = 5
           if !Funcao_Consultar_NFe()
              loop
           endif

      case OPC2 = 6
           if !Funcao_Cancelar_NFe()
              loop
           endif

      case OPC2 = 7
           if !Funcao_Inutilizar_NFe()
              loop
           endif

      case OPC2 = 8
           if !Funcao_Enviar_Email_NFe()
              loop
           endif

      case OPC2 = 9
           if !Funcao_Enviar_Contingencia_NFe()
              loop
           endif

      case OPC2 = 10
           if !Funcao_Recupera_Chave_NFe()
              loop
           endif

      case OPC2 = 11
           if !Funcao_Imprimir_NFe_Canceladas()
              loop
           endif

      case OPC2 = 12
           *** Mover NFe para Diretorio do Mes de emissao ***
           if !MLINE_Mudar_NFe()
              loop
           endif

      case OPC2 = 13
           if !MLINE_Trocar_Serie_Contingencia()
              loop
           endif

      case OPC2 = 14
           *** Copiar NFe para Diretorio da CONTABILIDADE ***
           if MLINE_Enviar_NFe_Contador()
              loop
           endif

      case OPC2 = 15
           if !Funcao_Gerar_CCe()
              loop
           endif

      case OPC2 = 16
           if !Funcao_RecuperarXML()
              loop
           endif

      case OPC2 = 17
           if !Funcao_Imprimir_CCe()
              loop
           endif
   endcase

   ACBR_FechaNFe()
   restore screen from TELA_NFe
enddo
ACBR_FechaNFe()
return(.t.)



Function Funcao_Buscar_Venda_NFe()
****************************************************
* Executa Busca de OS/PEDIDO/FATURA P/EMISSAO DE NFE
****************************************************
if dbf()<>'CADVENDA'
   do case
      case dbf()         == 'CADPEDC'
           vArquivoVenda := 'PEDC'
           
      case dbf()         == 'CADOS'
           vArquivoVenda := 'OS'
           
      case dbf()         == 'FATURAS'
           vArquivoVenda := 'FAT'
           
      otherwise
           vArquivoVenda := 'VND'
   endcase

   vFILIAL_CLI := vFILIAL_VEN := oFILIAL
   vCOD_VEND   := vCOD_CLI    := vLIQUIDO := 0
   vDATA       := ctod('')
   vNROVENDA   := space(7)
   vPRAZO      := space(1)

   if !FrmTelaBusca_OS_PED_FAT( vArquivoVenda )
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()
      select (ArqAntNFe)
      return(.f.)
   endif

   if lastkey()=27
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()
      select (ArqAntNFe)
      return(.f.)
   endif
   
endif
select (ArqAntNFe)
igual_var()

*** Busco CFOP para ter certeza da operacao ***
p_cfop(vCFOP,.f.)
select (ArqAntNFe)
reglock(.f.)
return(.t.)




Function Funcao_Gerar_DBF_NFe( vSERIE )
*********************************************************
* Funcao Gerar a NF e localiza a NF gerada para operacoes
* Nesta Funcao Cria os DBF (NF.DBF e ITEMNF.DBF)
*********************************************************

*** Verifica se o sistema est  em contigencia SCAN ***
*** Se for impressao de DANFE ou CONSULTA ***
do case
   case dbf() == 'CADVENDA'
        if !empty(COD_FAT) .and. NF_VENDA == 0 .and. NF_SERV == 0
           MsgAlert('Or‡amento est  na fatura '+COD_FAT+' NFe nÆo pode ser gerada...')
           *** Fecha arquivo de transacao da NFe ***
           ACBR_FechaNFe()

           select (ArqAntNFe)
           return(.f.)
        endif

        if NF_VENDA == 0 .or. (SERIE <> 'NFE' .and. SERIE <> '900' )
           p_cfop(cadvenda->CFOP,.f.)
           
           if !nivel('GERARNFE')
              *** Fecha arquivo de transacao da NFe ***
              ACBR_FechaNFe()

              select (ArqAntNFe)
              return(.f.)
           endif

           *** Gera o DBF da Nota e dos Itens ***
           GerarNFVenda(cadvenda->NRO_VENDA, cfop->ENTRA_SAI , vSERIE )

        endif

        select (ArqAntNFe)
        vNF_VENDA := NF_VENDA
        oNUMERO   := NF_VENDA
        oSERIE    := SERIE
        oNFE_RAND := NFE_RAND
        oDATA     := DATA
        oNROVENDA := strzero(NRO_VENDA,7)
        oORIGEM   := 'VND'

   case dbf() == 'CADOS' .or. dbf() == 'CADPEDC'
        if !empty(COD_FAT)
           MsgAlert('Registro est  na fatura '+COD_FAT+' NFe nÆo pode ser gerada...')
           *** Fecha arquivo de transacao da NFe ***
           ACBR_FechaNFe()

           select (ArqAntNFe)
           return(.f.)
        endif
        if NF_VENDA == 0 .or. (SERIE<>'NFE' .and. SERIE<>'900')

           if !nivel('GERARNFE')
              *** Fecha arquivo de transacao da NFe ***
              ACBR_FechaNFe()

              select (ArqAntNFe)
              return(.f.)
           endif

           if dbf() == 'CADOS'
              p_cfop(cados->CFOP,.f.)
              GerarNFOS(cados->COD_OS    , cfop->ENTRA_SAI, vSERIE)
           else
              p_cfop(cadpedc->CFOP,.f.)
              GerarNFpedido(cadpedc->COD_PED, cfop->ENTRA_SAI, vSERIE )
           endif
        endif
        select (ArqAntNFe)
        set order to 1
        seek oFILIAL + vNROVENDA
        vNF_VENDA := NF_VENDA
        oNUMERO   := NF_VENDA
        oSERIE    := SERIE
        oNFE_RAND := NFE_RAND
        oDATA     := iif(dbf() == 'CADOS', DATA_OS, DATA_PED)
        oNROVENDA := iif(dbf() == 'CADOS', COD_OS , COD_PED)
        oORIGEM   := iif(dbf() == 'CADOS', 'OS'   , 'PED')

   case dbf() == 'FATURAS'
        if NF_VENDA == 0 .or. (SERIE <> 'NFE' .and. SERIE <> '900')
           if !nivel('GERARNFE')
              *** Fecha arquivo de transacao da NFe ***
              ACBR_FechaNFe()

              select (ArqAntNFe)
              return(.f.)
           endif
           p_cfop(faturas->CFOP,.f.)
           GerarNFFT(faturas->COD_FAT, cfop->ENTRA_SAI, vSERIE )

        endif
        select (ArqAntNFe)
        set order to 1
        seek oFILIAL + vNROVENDA
        vNF_VENDA := NF_VENDA
        oNUMERO   := NF_VENDA
        oSERIE    := SERIE
        oNFE_RAND := NFE_RAND
        oDATA     := DATA_FAT
        oNROVENDA := COD_FAT
        oORIGEM   := 'FAT'
endcase

*** Se for qualquer operacao com NFe ja emitida ***
select NF
set order to 1
seek oFILIAL + str(oNUMERO,9) + oSERIE
if eof()
   MsgAlert('NÇo foi gerado NFe para este registro...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif
if CANCELADA
   MsgAlert('NFe foi cancelada...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif
if nf->COD_CLI>0
   p_cliente(nf->COD_CLI, nf->FILIAL_CLI, .f.)
endif
return(.t.)



Function Funcao_Gerar_INI_NFe()
********************************************
* Rotina para Gerar NFe de vendas/os/ped/fat
********************************************
if !nivel('GERARNFE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** 0=Normal                                2.00
*** 1=Normal                       <-- 0    3.10
*** 2=Contingencia FS-IA           <-- 1
*** 3=Contingencia SCAN            <-- 2
*** 4=Contingencia DPEC            <-- 3
*** 5=Contingencia FS-DA           <-- 4
*** 6=Contingencia SVC-AN            NEW
*** 7=Contingencia SVC-RS            NEW
*** 8=Contingencia Off-Line da NFCe  NEW

if (nf->ModoNFE=2 .or. nf->ModoNFE=5) .and. (setup->ModoNFE<>2 .and. setup->ModoNFE<>5)
    MsgAlert('ATEN€ÇO !!! NFe gerada em contingˆncia utilizando Formul rio de '  +;
             'Seguran‡a, e o sistema MicroLine NÇO ESTµ em contingˆncia. Negado '+;
             'a gera‡Æo da NFe pois a Chave de Acesso sofrer  altera‡Æo. ')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** Se foi gerado a CHAVE mais a NF nao foi autorizada ***
if !empty(nf->CHAVENFE) .and. !empty(nf->STATUSNFE)
   MsgAlert('Aten‡Æo !!! J  existe NFe com a chave '+nf->CHAVENFE+;
            ' e n§ '+strzero(nf->NUMERO,9)+'-'+nf->SERIE+' gerada para este registro...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

select (ArqAntNFe)

if setup->VersaoNFe == 2
   ACBR_GerarIniNFeV2_00(oNUMERO, oSERIE, oORIGEM, .f.)
else
   ACBR_GerarIniNFeV3_10(oNUMERO, oSERIE, oORIGEM, .f.)
endif

*** Verifica se tem XML desta NF ***
if empty( nf->CHAVENFE )
   ACBR_RecuperaGravaChaveNFe()
endif

*** Verifica se o cliente gera e NFe e envia por email automatico ***
if setup->EMAILNFE_A .and. !empty(nf->CHAVENFE) .and. nf->STATUSNFE == '100'
   ACBR_EnviarEmailAutomatico()
endif
return(.t.)




Function Funcao_Imprimir_DANFE()
************************************************************
* Funcao que imprime o DANFE de NFe gerada autorizada ou nÆo
************************************************************

* if !nivel('IMPRIMIRDANFE')
*    *** Fecha arquivo de transacao da NFe ***
*    ACBR_FechaNFe()
*
*    select (ArqAntNFe)
*    return(.f.)
* endif

select (ArqAntNFe)

if NF_VENDA = 0
   MsgAlert('NÇO Foi gerado NFe para este registro, execute recuperar chave...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

vARQ_XML    := alltrim(setup->XMLNFe) + nf->CHAVENFE+"-nfe.xml"

*** Verifica se o XML ja foi transferido ***
if month(nf->DT_EMIS) <> month(date())
   vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3)+'\'+ nf->CHAVENFE+"-nfe.xml"
endif

*** 1=Normal                       <-- 0
*** 2=Contingencia FS-IA           <-- 1
*** 3=Contingencia SCAN            <-- 2
*** 4=Contingencia DPEC            <-- 3
*** 5=Contingencia FS-DA           <-- 4
*** 6=Contingencia SVC-AN            NEW
*** 7=Contingencia SVC-RS            NEW
*** 8=Contingencia Off-Line da NFCe  NEW

*** Se for EMISSAO NORMAL ou CONTINGENCIA SCAN ***
if (nf->MODONFE = 0 .or. nf->MODONFE = 1 .or. nf->MODONFE = 3) .and. empty(nf->CHAVENFE) .or.;
   (nf->MODONFE = 0 .or. nf->MODONFE = 1 .or. nf->MODONFE = 3) .and.       nf->STATUSNFE<>'100'
   MsgAlert('ATEN€ÇO !!! ESTA NFe NÇO ESTµ AUTORIZADA E NÇO PODERµ SER UTILIZADA PARA '+;
            'CIRCULAR A MERCADORIA, IMPRIMA O DANFE E VERIFIQUE O MOTIVO DA NÇO AUTORIZACAO...')
   if 'WAGNER '   $ vUSUARIO .or.;
      'MICROLINE' $ vUSUARIO
      ACBR_ImprimirDANFe( vARQ_XML )
   endif
else
   ACBR_ImprimirDANFe( vARQ_XML )
endif
return(.t.)



Function Funcao_Consultar_NFe( vSERIE )
*******************************
* Funcao para Consultar uma NFe
*******************************
if !nivel('CONSULTANFE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** 1=Normal                       <-- 0
*** 2=Contingencia FS-IA           <-- 1
*** 3=Contingencia SCAN            <-- 2
*** 4=Contingencia DPEC            <-- 3
*** 5=Contingencia FS-DA           <-- 4
*** 6=Contingencia SVC-AN            NEW
*** 7=Contingencia SVC-RS            NEW
*** 8=Contingencia Off-Line da NFCe  NEW

select (ArqAntNFe)
do case
   case setup->ModoNFe == 0 .and. setup->VersaoNFe == 2 .or.;  // Normal = 2.00
        setup->ModoNFe == 1 .and. setup->VersaoNFe == 3        // Normal = 3.10
        vSERIE         := 'NFE'

   case setup->ModoNFe == 2 .and. setup->VersaoNFe == 2 .or.;  // SCAN = 2.00
        setup->ModoNFe == 3 .and. setup->VersaoNFe == 3        // SCAN = 3.10
        vSERIE         := '900'

   case setup->ModoNFe == 8
        vSERIE         := 'NFC'

   otherwise
        vSERIE         := 'NFE'
endcase

vNFE       := 0
vVALOR_NF  := 0
vEVENTO    := 0
vDT_EMIS   := ctod('')
vCLIENTE   := space(50)
vNROVENDA  := space(07)
vEMAIL_CONT:= space(40)

if !FrmTelaNFeConsulta('Consulta')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

vARQ_XML    := alltrim(setup->XMLNFe) + nf->CHAVENFE+"-nfe.xml"

*** Verifica se o XML ja foi transferido ***
if month(nf->DT_EMIS) <> month(date())
   vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3)+'\'+ nf->CHAVENFE+"-nfe.xml"
endif

ACBR_ConsultarNFe( vARQ_XML )
return(.t.)



Function Funcao_Cancelar_NFe( )
******************************
* Funcao para cancelar uma NFe
******************************
if !nivel('CANCELANFE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

select (ArqAntNFe)

if NF_VENDA = 0
   MsgAlert('NÇO Foi gerado NFe para este registro, execute recuperar chave...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

if MsgAlert('ATENCÇO !!! O processo de cancelamento de NFe ‚ irrevers¡vel e ap¢s o cancelamento junto ao fisco, '+;
            'a movimenta‡Æo f¡sica dos produtos e os lan‡amentos financeiros referente a venda '+;
            'serÆo cancelados e nÆo poderÆo serem recuperados...',' Cancelamento de NFe ',{' Abandona ',' Continua '})<>2
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

vDiasEmissao := date() - nf->DT_EMIS
if vDiasEmissao > setup->DiasCancNF
   MsgAlert('Aten‡Æo !!! NFe '+strzero(nf->NUMERO,9)+' da S‚rie '+nf->SERIE+' tem '+strzero(vDiasEmissao,2)+' dias de emitida... Negado Cancelamento')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif


*** 1=Normal                       <-- 0
*** 2=Contingencia FS-IA           <-- 1
*** 3=Contingencia SCAN            <-- 2
*** 4=Contingencia DPEC            <-- 3
*** 5=Contingencia FS-DA           <-- 4
*** 6=Contingencia SVC-AN            NEW
*** 7=Contingencia SVC-RS            NEW
*** 8=Contingencia Off-Line da NFCe  NEW

if empty(nf->PROTOCNFE) .and. (nf->ModoNFE == 2 .or. nf->ModoNFE == 5 .or. nf->ModoNFE == 8 )
   MsgAlert('NFe emitida em contingˆncia FS (Formul rio de Seguran‡a) e ainda '+;
            'nÆo foi transmitida para SEFIN. Imposs¡vel cancelamento...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

select (ArqAntNFe)

oNFe        := nf->NUMERO
oSERIE      := nf->SERIE
vHISTORICO  := 'CANCTO NFe-'+oNROVENDA+'-'+dtoc(oDATA)+'-'+transf(vLIQUIDO,'@E 99,999.99')

auditoria(vHISTORICO)
vMOT_EXC    := auditor->MOT_EXC
vTAM_MSG    := len(alltrim(vMOT_EXC))
if vTAM_MSG < 15
   vMOT_EXC := alltrim(vMOT_EXC) + repli('*',16-vTAM_MSG)
endif

*** Verifica se o XML ja foi transferido ***
vARQ_XML    := alltrim(setup->XMLNFe) + nf->CHAVENFE + "-nfe.xml"
if month(nf->DT_EMIS) <> month(date())
   vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3)+'\'+ nf->CHAVENFE + "-nfe.xml"
endif

ACBR_CancelarNFe(nf->CHAVENFE, vMOT_EXC)
*** Realiza a consulta para gravar no XML o protocolo de cancelamento ***

MensRede('Aguarde... Confirmando cancelamento')
ACBR_ConsultarNFe( vARQ_XML )

*** Realiza o cancelamento da movimentacao da NFe ***
if nf->CANCELADA .and. (nf->STATUSNFE == '101' .or. nf->STATUSNFE == '102')

   *** Volta para o Arquivo original da venda ***
   select (ArqAntNFe)
   
   *** Cancela a NFe de Produtos ***
   CANC_NF( oNFe, oSERIE , 'NFE' )

   *** Enviando por email a NFe cancelada ***
   MensRede('Aguarde... Enviando NFe cancelada por email')
   if !empty(cadcli->EMAIL)
      ACBR_EnviarNFeEmail(alltrim(cadcli->EMAIL), vARQ_XML, 1, alltrim(cadcli->EMAILCC))
   endif
   MensRede()

   vARQ_EVENTO    := alltrim(setup->XMLNFe) + nf->CHAVENFE + "11011101-ProcEventoNFe.xml"
   if month(nf->DT_EMIS) <> month(date())
      vARQ_EVENTO := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3)+'\'+ nf->CHAVENFE + "11011101-ProcEventoNFe.xml"
   endif


   *** Volta para o Arquivo original da venda ***
   select (ArqAntNFe)

   *** Cancela a RPS de SERVICOS ***
   if NF_SERV > 0
      CANC_NF( NF_SERV, SERIE_SERV, 'RPS' )
   endif

   if !file(vARQ_EVENTO)
      MsgAlert('Arquivo de Evento do Cancelamento NÆo encontrado')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif

   if !file(vARQ_XML)
      MsgAlert('Arquivo de NFe NÆo encontrado')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif
   ACBR_ImprimirEvento( vARQ_EVENTO, vARQ_XML )

endif

Return(.t.)



Function Funcao_Inutilizar_NFe( vSERIE )
****************************************************
* Funcao para Inutilizar intervalo de numeros de NFe
****************************************************
if !nivel('INUTILIZANFE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

select (ArqAntNFe)

vArqAntInu := dbf()
vCNPJ      := setup->CGCEMP
vAno       := year(date())

if vSERIE  == 'NFE' .or. vSERIE == '900'
   vModelo := 55
else
   vModelo := 65
endif

vNFE       := 0
vDT_EMIS   := ctod('')
vCLIENTE   := space(50)
vVALOR_NF  := 0
vNROVENDA  := space(7)
vEVENTO    := 0

if !FrmTelaNFeConsulta('Inutiliza‡Æo ')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

ESCINUT := MsgAlert('ATEN€ÇO !!! A continuidade da opera‡Æo ir  inutilizar o intervalo '+;
                    'de c¢digo informado e os n£meros informados serÆo inutilizados. Continua ?',' Inutiliza‡Æo de NFe ',{' NÆo ',' Sim '})
if ESCINUT == 2
   select NF
   do case
      case nf->SERIE == 'NFE'
           vSERIE    := 1
      case nf->SERIE == 'NFC'
           vSERIE    := 100
      case nf->SERIE == '900'
           vSERIE    := 900
   endcase

   vHISTORICO  := 'INUTILIZAR NFe '+strzero(nf->NUMERO,9)+'-Serie='+nf->SERIE+'-'+dtoc(nf->DT_EMIS)+'-'+transf(nf->VLR_NF,'@E 99,999.99')
   auditoria(vHISTORICO)
   vMOT_EXC    := auditor->MOT_EXC
   ACBR_InutilizarNFe(vCNPJ, vMOT_EXC, vAno, vModelo, vSERIE, nf->NUMERO, nf->NUMERO )
   select (vArqAntInu)
endif
return(.t.)



Function Funcao_Enviar_Email_NFe()
********************************
* Enviar email das NFes enviadas
********************************
if !nivel('EMAILNFE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

do while .t.
   vDT_INI    := vDT_FIM     := ctod('')
   vCOD_CLI   := vNFE        := 0
   vFILIAL    := vFILIAL_CLI := oFILIAL
   vEMAIL_CONT:= space(40)
   vSERIE     := '   '

   if !FrmTelaNFeEmail()
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif
/*
   if !FrmNFE_Envio_Email('Envio de Email')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif
*/
   mCOD_CLI    := vCOD_CLI
   mFILIAL_CLI := vFILIAL_CLI
   mNFE        := vNFE
   mSERIE      := vSERIE
   vACHEI      := .f.

   if mNFE > 0                    // Se foi informado N£mero da NFE pesquisa por ela e envia
      select NF
      set order to 1
      seek oFILIAL + str(mNFE,9) + mSERIE
      if eof()
         MsgAlert ("Nota Fiscal: " + str(mNFE,9) + "S‚rie: " + mSERIE + " nÆo foi encontrada! Verifique...")
         loop
      endif

      select NF
      vARQ_XML    := alltrim(setup->XMLNFE) + nf->CHAVENFE + "-nfe.xml"

      *** Verifica se o XML ja foi transferido ***
      if month(nf->DT_EMIS) <> month(date())
         vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE + "-nfe.xml"
      endif

      if !file(vARQ_XML)
         MsgAlert ("Arquivo XML: " + vARQ_XML + " nÆo foi encontrado! Verifique...")
         loop
      endif

      vCOD_CLI    := COD_CLI
      vFILIAL_CLI := FILIAL_CLI
      p_cliente(vCOD_CLI, vFILIAL_CLI, .f.)

      vEMAIL_DEST := iif (!empty(alltrim(vEMAIL_CONT)), alltrim(vEMAIL_CONT), cadcli->EMAIL)

      ACBR_EnviarNFeEmail(alltrim(vEMAIL_DEST), vARQ_XML, 1,'')

      loop
      
   endif
   
   select NF
   set order to 2
   set softseek on
   seek oFILIAL + dtos(vDT_INI)
   set softseek off

   vQUANTNOTAS := 0

   if !empty(alltrim(vEMAIL_CONT))
      do while !eof() .and. nf->DT_EMIS <= vDT_FIM
         if mCOD_CLI > 0 .and. COD_CLI <> mCOD_CLI .and. FILIAL_CLI <> mFILIAL_CLI
            skip
            loop
         endif
         if empty(CHAVENFE)
            skip
            loop
         endif

         vCOD_CLI    := COD_CLI
         vFILIAL_CLI := FILIAL_CLI
         p_cliente(vCOD_CLI, vFILIAL_CLI, .f.)

         select NF
         vARQ_XML    := alltrim(setup->XMLNFE) + nf->CHAVENFE+"-nfe.xml"

         *** Verifica se o XML ja foi transferido ***
         if month(nf->DT_EMIS) <> month(date())
            vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE+"-nfe.xml"
         endif

         if !file(vARQ_XML)
            skip
            loop
         endif

         ACBR_EnviarNFeEmail(alltrim(vEMAIL_CONT), vARQ_XML, 1,'')

         vQUANTNOTAS++

         select NF
         skip
      enddo
   else
      do while !eof() .and. nf->DT_EMIS <= vDT_FIM

         if mCOD_CLI > 0 .and. COD_CLI <> mCOD_CLI .and. FILIAL_CLI <> mFILIAL_CLI
            skip
            loop
         endif

         vCOD_CLI    := COD_CLI
         vFILIAL_CLI := FILIAL_CLI
         p_cliente(vCOD_CLI, vFILIAL_CLI, .f.)
         if empty(cadcli->EMAIL)
***         MsgAlert('O Cadastro do cliente '+vFILIAL_CLI+'/'+strzero(cadcli->COD_CLI,5)+'-'+alltrim(cadcli->CLIENTE)+' nÆo possui eMail cadastrado...')
            select NF
            skip
            loop
         endif

         select NF
         if empty(CHAVENFE)
            skip
            loop
         endif

         *** Busca email da transportadora ***
         EMAIL_TRANSP := .f.
         if COD_TRAN  > 0
            p_transp(nf->COD_TRAN, nf->FILIAL_TRA, .f.)
            if !empty(transp->EMAIL_TRAN)
               EMAIL_TRANSP := .t.
            endif
         endif
         vARQ_XML    := alltrim(setup->XMLNFE) + nf->CHAVENFE+"-nfe.xml"

         *** Verifica se o XML ja foi transferido ***
         if month(nf->DT_EMIS) <> month(date())
            vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE+"-nfe.xml"
         endif

         if !file(vARQ_XML)
            skip
            loop
         endif

         select NF
         if reglock(.f.)
            replace JA_EMAIL   with .t.     ,;
                    DT_EMAIL   with date()  ,;
                    QUEM_EMAIL with vUSUARIO
            AuditAlt( procname() )
            dbcommit()
            if EMAIL_TRANSP
               ACBR_EnviarNFeEmail(alltrim(cadcli->EMAIL), vARQ_XML, 1, alltrim(transp->EMAIL_TRAN))
            else
               ACBR_EnviarNFeEmail(alltrim(cadcli->EMAIL), vARQ_XML, 1, alltrim(cadcli->EMAILCC))
            endif
            nf->( dbunlock() )
         endif
         vQUANTNOTAS++
         skip
      enddo
   endif
***   if vACHEI
***      MsgAlert('O Email da NFe '+strzero(mNFE,9)+' solicitada foi enviado...')
***   endif
   if vQUANTNOTAS > 0
      MsgAlert('Foram enviados ' + strzero(vQUANTNOTAS, 6)+' e-mails referentes Notas Fiscais...')
   endif
enddo
return(.t.)


Function Funcao_Enviar_Contingencia_NFe()
*********************************************
* Enviar arquivos XML gerados em contingencia
*********************************************
if !nivel('ENVIARNFE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

if setup->ModoNFE <> 0 .and. setup->ModoNFE <> 1
   MsgAlert('Sistema em Modo de Contingˆncia... Negado envio de NFe pendentes...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif
do while .t.
   vDT_INI  := vDT_FIM :=ctod('')
   vCOD_CLI := vNFE    := 0
   vFILIAL  := vFILIAL_CLI := oFILIAL
   vSERIE   := '   '

   if !FrmTelaNFeCancelada('Envio Contingˆncia ')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif

   mCOD_CLI    := vCOD_CLI
   mFILIAL_CLI := vFILIAL_CLI
   mNFE        := vNFE
   mSERIE      := vSERIE

   select NF
   set order to 2
   set softseek on
   seek oFILIAL + dtos(vDT_INI)
   set softseek off
   do while !eof() .and. nf->DT_EMIS<=vDT_FIM
      select NF
      if empty(CHAVENFE) .or. (nf->ModoNFE<>2 .and. nf->ModoNFE<>5)
         skip
         loop
      endif
      *** Verifica se o XML ja foi transferido ***

      vARQ_XML    := alltrim(setup->XMLNFe) + nf->CHAVENFE+"-nfe.xml"
      if month(nf->DT_EMIS) <> month(date())
         vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE+"-nfe.xml"
      endif

      if !file(vARQ_XML)
         skip
         loop
      endif
      if reglock(.f.)
         nLote    := 1
         nAssina  := 0
         nImprime := 1
         *** Busca o numero do LOTE NFe ***
         select ARQUIVOS
         set exact on
         seek 'NFELOTE '
         reglock(.f.)
         replace ULT_COD with ULT_COD+1
         dbcommit()
         nLOTE := ULT_COD
         arquivos->( dbunlock() )
         set exact off
         ACBR_EnviarNFe( vARQ_XML, nLote, nAssina, nImprime )
      endif
      select NF
      nf->( dbunlock() )
      skip
   enddo
enddo
return(.t.)


Function Funcao_Recupera_Chave_NFe()
*******************************************
* Funcao para Recuperar/Gravar chave de NFe
*******************************************
if !nivel('CHAVENFE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

select (ArqAntNFe)

if NF_VENDA = 0
   MsgAlert('NÇO Foi gerado NFe para este registro, execute recuperar chave...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

if !empty(nf->CHAVENFE)
   MsgAlert('J  existe Chave de NFe gravada no N£mero de NF '+strzero(nf->NUMERO,9)+'...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

vCHAVENFE := nf->CHAVENFE
if val(alltrim(vCHAVENFE))=44
   MsgAlert('J  existe Chave da NFe '+vCHAVENFE+'...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** Recupera a chave da NFe ***
ACBR_RecuperaGravaChaveNFe()
return(.t.)


Function Funcao_Imprimir_NFe_Canceladas()
***********************************
* Imprimir Notas Fiscais Canceladas
***********************************
if !nivel('IMPNFECANC')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif
do while .t.
   vDT_INI  := vDT_FIM     := ctod('')
   vCOD_CLI := vNFE        := 0
   vSERIE   := '   '
   vFILIAL  := vFILIAL_CLI := oFILIAL

   if !FrmTelaNFeCancelada('ImpressÆo DANFE Cancelado')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif

   mCOD_CLI    := vCOD_CLI
   mFILIAL_CLI := vFILIAL_CLI
   mNFE        := vNFE
   mSERIE      := vSERIE
   vACHEI      := .f.

   select NF
   set order to 2
   set softseek on
   seek oFILIAL + dtos(vDT_INI)
   set softseek off
   do while !eof() .and. nf->DT_EMIS <= vDT_FIM
      vCOD_CLI    := COD_CLI
      vFILIAL_CLI := FILIAL_CLI
      p_cliente(vCOD_CLI, vFILIAL_CLI, .f.)

      if mCOD_CLI>0 .and. mCOD_CLI <> COD_CLI .or.;
         mNFE    >0 .and. mNFE     <> NUMERO .and. mSERIE <> SERIE
         skip
         loop
      endif

      select NF
      if empty(CHAVENFE) .or. !CANCELADA
         skip
         loop
      endif

      *** Verifica se o XML ja foi transferido ***
      vARQ_XML       := alltrim(setup->XMLNFe) + nf->CHAVENFE +"-nfe.xml"
**** 13/12/2014   vARQ_EVENTO    := alltrim(setup->XMLNFe) + nf->CHAVENFE + "11011101-procEventoNFe.xml"
      vARQ_EVENTO    := alltrim(setup->XMLNFe) + nf->CHAVENFE + "1101111-procEventoNFe.xml"

      if month(nf->DT_EMIS) <> month(date())
         vARQ_XML    := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3)+'\'+ nf->CHAVENFE+"-nfe.xml"
         *** 13/12/2014   vARQ_EVENTO := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3)+'\'+ nf->CHAVENFE + "11011101-ProcEventoNFe.xml"
         vARQ_EVENTO := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3)+'\'+ nf->CHAVENFE + "1101111-ProcEventoNFe.xml"
      endif

      ACBR_ConsultarNFe(   vARQ_XML )
      ACBR_ImprimirDANFe(  vARQ_XML )
      ACBR_ImprimirEvento( vARQ_EVENTO, vARQ_XML )
      skip
   enddo
enddo
return(.t.)


Function Funcao_Gerar_CCe()
**********************************************
* Funcao para Gerar e Enviar Carta de Correcao
**********************************************
if !nivel('CARTACORRECAO')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

select (ArqAntNFe)

vArqAntInu := dbf()
select CORRECAO
vCOD_CARTA := 0
vNFE       := 0
vEVENTO    := 0
vVALOR_NF  := 0
vSERIE     := space(3)
vDATA_NF   := ctod('')
vCLIENTE   := space(10)
vNROVENDA  := space(7)
vCLIENTE   := ''
vTXT_CCE   := ''
vTXT_CCE   += OemToAnsi('A Carta de Corre‡Æo ‚ disciplinada pelo par grafo 1o-A do art. 7§ do Convˆnio S/N, de 15 de')+chr(13)+chr(10)
vTXT_CCE   += OemToAnsi('dezembro de 1970 e pode ser utilizada para regulariza‡Æo de erro ocorrido na emissÆo de ')   +chr(13)+chr(10)
vTXT_CCE   += OemToAnsi('documento fiscal, desde que o erro nÆo esteja relacionado com: ') +chr(13)+chr(10)
vTXT_CCE   += OemToAnsi('    I - as vari veis que determinam o valor do imposto tais como: ')       +chr(13)+chr(10)
vTXT_CCE   += OemToAnsi('        a) Base de c lculo, aliquota, diferenca de preco, quantidade, valor da operacao ou da prestacao;') + chr(13)+chr(10)
vTXT_CCE   += OemToAnsi('    II - a corre‡Æo de dados cadastrais que implique mudan‡a do remetente ou do destinatario; ' ) + chr(13)+chr(10)
vTXT_CCE   += OemToAnsi('    III - a data de emissÆo ou de sa¡da')

if !FrmTelaCCe('Gera‡Æo')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

ESCINUT := MsgAlert('ATEN€ÇO !!! A continuidade da opera‡Æo ir  gerar Carta de Corre‡Æo de acordo com '+;
                    'os eventos informados Continua ?',' Carta de Corre‡Æo ',{' NÆo ',' Sim '})
if ESCINUT=2
   select CORRECAO
   if !reglock(.f.)
      AuditAlt( procname() )

      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif

   select NF
   set order to 1
   seek oFILIAL + str(vNFE,9) + vSERIE
   if eof()
      MsgAlert('NFe '+strzero(vNFE,9)+' da S‚rie '+vSERIE+' nÆo foi encontrada...')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif

   ACBR_GerarIniCCe( nf->NUMERO, nf->SERIE, nf->NROVENDA )

   *** Verifica se o XML ja foi transferido ***
   vARQ_XML    := alltrim(setup->XMLNFe) + nf->CHAVENFE + "-nfe.xml"
   vARQ_CCE    := alltrim(setup->XMLNFe) + nf->CHAVENFE + alltrim(nf->TpEvento) + alltrim(strzero(correcao->SEQUENCIA,2)) +"-ProcEventoNFe.xml"
   if month(nf->DT_EMIS) <> month(date())
      vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4) + '-' + left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE + "-nfe.xml"
      *** Se nao encontrar arquivo de evento no mes atual, busca no mes da emissao da NFe ***
      if !file(vARQ_CCE)
         vARQ_CCE := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4) + '-' + left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE + alltrim(nf->TpEvento) + alltrim(strzero(correcao->SEQUENCIA,2)) + "-ProcEventoNFe.xml"
      endif
   endif

   *** Verifica se o cliente gera e NFe e envia por email automatico ***
   if !empty(nf->CHAVENFE) .and. nf->STATUSNFE == '100'
      ACBR_EnviarEmailAutomaticoCCe()
   endif

   *** Carta de Correcao ***
   ACBR_ImprimirEvento( vARQ_CCE, vARQ_XML )

   select (vArqAntInu)
endif
return(.t.)



Function MLINE_Trocar_Serie_Contingencia()
***************************************************
* Trocar a SERIE de NF geradas DE/PARA contingencia
***************************************************
if !nivel('CONTINGENCIA')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif
if MsgAlert('A troca da S‚rie de NFe s¢ poder  ser realizada se a op‡Æo escolhida '   +;
            'for SCAN NACIONAL, ou seja, o envio da NFe ser  redirecionado ao sitio ' +;
            'da Receita Federal, NÇO UTILIZANDO FORMULµRIO DE SEGURAN€A.',' Mudan‡a S‚rie NFe ',{' EmissÆo Via SCAN ',' EmissÆo via FS '})<>1
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

do while .t.
   *** 1=Normal                       <-- 0
   *** 2=Contingencia FS-IA           <-- 1
   *** 3=Contingencia SCAN            <-- 2
   *** 4=Contingencia DPEC            <-- 3
   *** 5=Contingencia FS-DA           <-- 4
   *** 6=Contingencia SVC-AN            NEW
   *** 7=Contingencia SVC-RS            NEW
   *** 8=Contingencia Off-Line da NFCe  NEW

   do case
      case setup->ModoNFe == 0 .or.;  // v2.00
           setup->ModoNFe == 1        // v3.10
           vSERIE         := 'NFE'

      case setup->ModoNFe == 2
           vSERIE         := '900'

      case setup->ModoNFe == 8
           vSERIE         := 'NFC'

      other
           vSERIE         := 'NFE'
   endcase
   vNFE       := 0
   vVALOR_NF  := 0
   vEVENTO    := 0
   vDT_EMIS   := ctod('')
   vCLIENTE   := space(50)
   vNROVENDA  := space(7)

   if !FrmTelaNFeConsulta('Contingˆncia')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif

   if nf->STATUSNFE == '100' .or.;   // Autorizada o USO
      nf->STATUSNFE == '101' .or.;   // Cancelada
      nf->STATUSNFE == '102' .or.;   // Inutilizada
      nf->STATUSNFE == '110'         // Denegada
      MsgAlert('O status da NFe '+strzero(vNUMERO,9)+' nÆo permite excluir a NFe...')
      loop
   endif

   if vNROVENDA<>NROVENDA
      MsgAlert('Venda informada est  diferente da localizada na NFe...')
      loop
   endif

   do case
      case left(vNROVENDA,1)='P'
           select CADPEDc
           set order to 1
           seek oFILIAL + vNROVENDA

      case left(vNROVENDA,1)='O'
           select CADOS
           set order to 1
           seek oFILIAL + vNROVENDA

      case left(vNROVENDA,1)='F'
           select FATURAS
           set order to 1
           seek oFILIAL + vNROVENDA
      other
           select CADVENDA
           set order to 1
           seek oFILIAL + str(val(vNROVENDA),7)
   endcase
   
   if !eof() .and. vNFE == NF_VENDA .and. vSERIE == SERIE
      reglock(.f.)
      AuditAlt( procname() )

      replace NF_VENDA with 0, SERIE with '   '
      dbcommit()
      dbunlock()

      *** Grava LOG de auditoria ***
      vHISTORICO := 'INUTILIZACAO NFe '+strzero(vNFe,9)+'   SERIE='+vSERIE+' P/CONTINGENCIA'
      auditoria(vHISTORICO)
      MsgAlert('O registro '+vNROVENDA+' teve a NFe '+strzero(vNFE,9)+' excluida para emissÆo em contingˆncia...')
   endif
enddo
Return(.t.)


Function Funcao_RecuperarXML()
************************
* Recuperar o XML da NFe
************************
if !nivel('RECUPERARXML')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** 1=Normal                       <-- 0
*** 2=Contingencia FS-IA           <-- 1
*** 3=Contingencia SCAN            <-- 2
*** 4=Contingencia DPEC            <-- 3
*** 5=Contingencia FS-DA           <-- 4
*** 6=Contingencia SVC-AN            NEW
*** 7=Contingencia SVC-RS            NEW
*** 8=Contingencia Off-Line da NFCe  NEW

do case
   case setup->ModoNFe == 1
        vSERIE         := 'NFE'

   case setup->ModoNFe == 2
        vSERIE         := '900'

   case setup->ModoNFe == 8
        vSERIE         := 'NFC'

   other
        vSERIE         := 'NFE'
endcase

vNFE       := 0
vDT_EMIS   := ctod('')
vCLIENTE   := space(50)
vVALOR_NF  := 0
vNROVENDA  := space(7)
vEMAIL_CONT:= space(40)
vEVENTO    := 0

if !FrmTelaNFeConsulta('Recuperar XML')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** Busco pela NF a venda ***
do case
   case left(vNROVENDA,1)='P'
        select CADPEDc
        set order to 1
        seek oFILIAL + vNROVENDA

   case left(vNROVENDA,1)='O'
        select CADOS
        set order to 1
        seek oFILIAL + vNROVENDA

   case left(vNROVENDA,1)='F'
        select FATURAS
        set order to 1
        seek oFILIAL + vNROVENDA
   other
        select CADVENDA
        set order to 1
        seek oFILIAL + str(val(vNROVENDA),7)
endcase

if eof()
   select (ArqAntNFe)
   return(.f.)
endif
igual_var()

select NF
vARQ_XML    := alltrim(setup->XMLNFe) + nf->CHAVENFE+"-nfe.xml"

*** Verifica se o XML ja foi transferido ***
if month(nf->DT_EMIS) <> month(date())
   vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3)+'\'+ nf->CHAVENFE+"-nfe.xml"
endif

if file(vARQ_XML)
   MsgAlert('O XML da NFe '+strzero(nf->NUMERO,9) + ' Serie '+nf->SERIE + ' j  existe...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** Pego o Nome do XML na pasta Local ***
vARQ_XML_LOCAL  := alltrim(setup->XMLNFe) + nf->CHAVENFE+"-nfe.xml"

*** Gero o XML ***

if setup->VersaoNFe == 2
   ACBR_GerarIniNFeV2_00(nf->NUMERO, nf->SERIE, '' , .f.)
else
   ACBR_GerarIniNFeV3_10(nf->NUMERO, nf->SERIE, '' , .f.)
endif

*** Consulto XML criado pasta local para Autorizar ***
ACBR_ConsultarNFe( vARQ_XML_LOCAL )

if file( vARQ_XML_LOCAL ) .and. nf->STATUSNFE == '100' .and. !empty(nf->PROTOCNFE)
   vARQ_ORIGEM  := vARQ_XML_LOCAL
   vARQ_DESTINO := vARQ_XML

   if vARQ_ORIGEM == vARQ_DESTINO
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif

   TENTA := 0
   do while TENTA<100
      @ 16,26 say 'Tamanho Arquivo ('+strzero(FileCopy( vARQ_ORIGEM, vARQ_DESTINO )/1024,7)+') Kbytes'
      inkey(0.4)
      if file( vARQ_DESTINO )
         fErase( vARQ_ORIGEM )
         exit
      endif
      TENTA++
   enddo
   if TENTA>=100
      MsgAlert('ATEN€ÇO !!! Aconteceu um erro GRAVE na copia dos arquivos XML, reinicie TODAS as maquinas e execute '+;
               'o procedimento novamente...')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAntNFe)
      return(.f.)
   endif
endif
return(.t.)


Function Funcao_Imprimir_CCe()
****************************
* Imprimir Carta de Correcao
****************************
if !nivel('IMPRIMIRCCE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** 1=Normal                       <-- 0
*** 2=Contingencia FS-IA           <-- 1
*** 3=Contingencia SCAN            <-- 2
*** 4=Contingencia DPEC            <-- 3
*** 5=Contingencia FS-DA           <-- 4
*** 6=Contingencia SVC-AN            NEW
*** 7=Contingencia SVC-RS            NEW
*** 8=Contingencia Off-Line da NFCe  NEW

do case
   case setup->ModoNFe == 1
        vSERIE         := 'NFE'

   case setup->ModoNFe == 2
        vSERIE         := '900'

   case setup->ModoNFe == 8
        vSERIE         := 'NFC'

   other
        vSERIE         := 'NFE'
endcase

vNFE       := 0
vDT_EMIS   := ctod('')
vCLIENTE   := space(50)
vVALOR_NF  := 0
vNROVENDA  := space(7)
vEMAIL_CONT:= space(40)
vEVENTO    := 0

if !FrmTelaNFeConsulta('Imprimir CCe')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** Verifica se o XML ja foi transferido ***
vARQ_XML   := alltrim(setup->XMLNFe) + nf->CHAVENFE + "-nfe.xml"
vARQ_CCE   := alltrim(setup->XMLNFe) + nf->CHAVENFE + alltrim(nf->TpEvento) + alltrim(strzero(vEVENTO,2)) +"-ProcEventoNFe.xml"

if !file(vARQ_XML)
   if month(nf->DT_EMIS) <> month(date())
      vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4) + '-' + left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE + "-nfe.xml"
   endif
endif

if !file(vARQ_CCE)
   if month(nf->DT_EMIS) <> month(date())
      vARQ_CCE := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4) + '-' + left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE + alltrim(nf->TpEvento) + alltrim(strzero(vEVENTO,2)) + "-ProcEventoNFe.xml"
   endif
endif

if !file(vARQ_CCE)
   FrmMsgErro(OemToAnsi('Arquivo de Carta de Corre‡Æo NÆo encontrado no caminho '+vARQ_CCE))
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

if !file(vARQ_XML)
   FrmMsgErro(OemToAnsi('Arquivo de NFe NÆo encontrado no caminho '+vARQ_CCE))
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAntNFe)
   return(.f.)
endif

*** Verifica se o cliente gera e NFe e envia por email automatico ***
if !empty(nf->CHAVENFE) .and. nf->STATUSNFE == '100'
   ACBR_EnviarEmailAutomaticoCCe()
endif

*** Impressao da CCe por evento ***
ACBR_ImprimirEvento( vARQ_CCE, vARQ_XML )
return(.f.)


Function ACBR_ExecutaNFe( vOPERACAO_NFE , vPARAMETRO_NFE )
*********************************************************************
* Funcao para gravar arquivo com solicitacao de venda ou cancelamento
* Parametros :
*      OPERACAO  = Tipo da operacao que sera realizada 
*      PARAMETRO = Parametros para execucao da operacao
* Grava solicitacao em :
*             C:\MONITOR\REM\REMESSA.TXT
*********************************************************************

*** Cria protocolo de linha do arquivo texto ***
FimLinNFe      := chr( 13 ) + chr( 10 )
vPARAMETRO_NFE := iif(ValType( vPARAMETRO_NFE )#"C","",vPARAMETRO_NFE)
vCOMANDO_NFE   := vOPERACAO_NFE + iif( len( vPARAMETRO_NFE ) =0, "()", "(" + vPARAMETRO_NFE + ")") + FimLinNFe

*** Desativa as chamadas em Backgroud ***
HB_BackGroundDel( nTask )

TENTATIVA=0
do while .t.
   *** cria o arquivo de comandos em diretorio temporario ***
   vNFeArq     := fcreate( "C:\TEMP\REMESSA.TXT" , 0 )
   if fError()<>0
      MsgAlert('Erro na criacao do arquivo de REMESSA...Vou tentar novamente')
      loop
   endif
   vPathOrigem := "C:\TEMP\REMESSA.TXT"

   *** grava comandos no arquivo ***
   Fwrite(vNFeArq , @vCOMANDO_NFE , len(vCOMANDO_NFE) )

   *** fecha o arquivo ***
   fClose( vNFeArq )
   inkey(1)

   *** envia o arquivo para diretorio do gerenciador ***
   __CopyFile ( vPathOrigem , "C:\MONITOR\REM\REMESSA.TXT" )
   inkey(1)

   *** apagando arquivo de comandos ***
   ferase( vPathOrigem )
   exit
enddo
return(.t.)



Function ACBR_RetornoNFe()
*************************************************************
* Recebe resposta do monitor da transacao iniciada
* e realiza o tratamento do retorno e mensagens
* Retorno em :
*    C:\MONITOR\RET\RETORNO.TXT
* Parametro :
*    RotinaOri = Indica o programa Chamador se Orcamento ou PDV
*************************************************************
*** Desativa as chamadas em Backgroud ***
HB_BackGroundDel( nTask )

TENTATIVA := CONTADOR  := iLinArq:=0
vNFeArq   := vDADOSNFe := ''
limpa(24)

if !file( "C:\MONITOR\ACBrNFeMonitor.EXE" )
   MsgAlert('O Arquivo EXE nÆo encontrado na pasta padrÆo...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

*** Verifica se esta em Contingencia ***
CONTINGENCIA := .f.

*** 1=Normal                       <-- 0
*** 2=Contingencia FS-IA           <-- 1
*** 3=Contingencia SCAN            <-- 2
*** 4=Contingencia DPEC            <-- 3
*** 5=Contingencia FS-DA           <-- 4
*** 6=Contingencia SVC-AN            NEW
*** 7=Contingencia SVC-RS            NEW
*** 8=Contingencia Off-Line da NFCe  NEW

do case
   case setup->ModoNFe == 2
        MsgAlert('Aten‡Æo !!! NFe est  sendo emitida em contingˆncia, modo Formul rio de Seguran‡a, vocˆ ter  72 horas '+;
                 'da emissÆo da NFe para enviar o arquivo XML para a SEFIN/RFB...')
        CONTINGENCIA   := .t.

   case setup->ModoNFe == 3
        MsgAlert('Aten‡Æo !!! NFe est  sendo emitida em contingencia, modo SCAN Nacional,'+;
                 'e est  sendo enviada diretamente para a RFB...')
        CONTINGENCIA   := .t.

   case setup->ModoNFe == 4
        MsgAlert('Aten‡Æo !!! NFe est  sendo emitida em contingencia, modo DPEC, arquivo XML dever  ser '+;
                 'enviado em at‚ 72 horas de emissÆo da NFe para a SEFIN/RFB...')
        CONTINGENCIA   := .t.

   case setup->ModoNFe == 5
        MsgAlert('Aten‡Æo !!! NFe est  sendo emitida em contingˆncia, modo Formul rio de Seguran‡a, vocˆ ter  72 horas '+;
                 'da emissÆo da NFe para enviar o arquivo XML para a SEFIN/RFB...')
        CONTINGENCIA   := .t.

   case setup->ModoNFe == 6
        MsgAlert('Aten‡Æo !!! NFe est  sendo emitida em contingˆncia, modo SVC-AN, vocˆ ter  72 horas '+;
                 'da emissÆo da NFe para enviar o arquivo XML para a SEFIN/RFB...')
        CONTINGENCIA   := .t.

   case setup->ModoNFe == 7
        MsgAlert('Aten‡Æo !!! NFe est  sendo emitida em contingˆncia, modo SVC-RS, vocˆ ter  72 horas '+;
                 'da emissÆo da NFe para enviar o arquivo XML para a SEFIN/RFB...')
        CONTINGENCIA   := .t.

   case setup->ModoNFe == 8
        MsgAlert('Aten‡Æo !!! NFe est  sendo emitida em contingˆncia, modo SVC-RS, vocˆ ter  72 horas '+;
                 'da emissÆo da NFe para enviar o arquivo XML para a SEFIN/RFB...')
        CONTINGENCIA   := .t.
endcase

QuadroMensagem('Comunicando com Monitor de NFe','Aguardando resposta do Monitor de NFe...')
hwg_doevents()

do while .t.
   CONTADOR++
   inkey(.5)
   if CONTADOR > 20000
      *** Ativa funcoes em background ***
      oRelogio(.t.,.f.)
      QuadroMensagem()
      return(.f.)
   endif
   if file("C:\MONITOR\RET\RETORNO.TXT")
      vNFeArq := MemoRead( "C:\MONITOR\RET\RETORNO.TXT" )
      if fError()<>0
         MensNFe(11, 'Erro ao Ler arquivo RETORNO.TXT '+str(fError()))
         inkey(.5)
         do while fError()<>0
            vNFeArq := MemoRead( "C:\MONITOR\RET\RETORNO.TXT" )
         enddo
      endif
      iLinArq := MlCount(vNFeArq, 52)
      if iLinArq = 0
         MensNFe(11, 'Arquivo RETORNO.TXT esta vazio...')        
         inkey(.5)
      endif
		exit
   endif
enddo
QuadroMensagem()

*** Apago o arquivo de requisicao para o gerenciador nao entrar no ar novamente ***
if file("C:\MONITOR\REM\REMESSA.TXT")
   ferase( "C:\MONITOR\REM\REMESSA.TXT" )
endif

vTxtERRO   := vStatus      := ''
vVERSAO    := vTipoAmb     := vVerAplic := vMotivo := vChaveNFe := ''
vProtocolo := vNroRec      := vDataRec  := vDigito := vTpEvento := ''
ErroNFe    := GravaRetorno := .f.

select NF
reglock(.f.)
AuditAlt( procname() )

vDADOSNFe      := ''
vERRO          := ''
vCartaCorrecao := .f.
vCancelamento  := .f.
vPrimeiraVez   := .f.

for iCONTA := 1 to iLinArq
    vDADOSNFe      := memoline(vNFeArq , 52, iCONTA, .F.)

    *** Comando executado ***
    if 'OK:'       $ vDADOSNFe
       vRETORNO    := substr(vDADOSNFe,04,40)

       if substr(alltrim(vRETORNO),3,1) == '/'
          MsgAlert('A validade do certificado ‚ '+vRETORNO)
          select SETUP
          reglock(.f.)
          replace VALID_A1 with ctod(alltrim(vRETORNO))
          unlock
       endif
       
    endif

    *** Erro na execucao comando ***
    if 'ERRO:'     $ vDADOSNFe
       vStatus     := alltrim(substr(vDADOSNFe,07,20))
       for iERRO := iCONTA to iLinArq
           vDADOSNFe := memoline(vNFeArq , 52, iERRO, .F.)
           vERRO     += left(alltrim(vDADOSNFe) + space(60),60)
       next
       MsgAlert(vERRO)
       if !CONTINGENCIA
          exit
       endif
    endif

    *** Tipo do evento (CCe ou Cancto de NFe) ***
    if 'tpEvento=' $ vDADOSNFe
       vTpEvento  := alltrim(substr(vDADOSNFe,10,20))
       replace nf->TpEvento with vTpEvento
       *msgalert('gravei vTpEvento = '+vTpEvento)
    endif

    if '[CANCELAMENTO]' $ vDADOSNFe
       vCancelamento := .t.
    endif
    
    *** Status da operacao (Campo para saber se NF foi autorizada) ***
    *** No caso de Inutilizacao NAO grava retorno ***
    if 'CStat='    $ vDADOSNFe .or.;   // NFe
       'cStat='    $ vDADOSNFe         // CCe
       vStatus     := alltrim(substr(vDADOSNFe,07,20))
       
       if val(vStatus)>200
          select ERROSNFE
          locate for val(vStatus) == CODIGO
          if !eof()
             MsgAlert('Aten‡Æo !!! Ocorreu algo de anormal no processamento da '+iif('CStat' $ vDADOSNFe, 'NFe ','CCe ' )+;
                      'que gerou o erro ('+strzero(CODIGO)+') e a mensagem : ('+alltrim(DESCRICAO)+'). PARE o '+;
                      'o uso do sistema, e corrija o erro conforme no arquivo correspondente ou caso nÆo identifique '+;
                      'o erro, pare o uso do sistema e informe o ocorrido ao suporte t‚cnico...')
             select NF
             exit
          endif
       endif
       if val(vStatus) == 100 .or.;   // Autorizado Uso                      --> Cod.Sit=00
          val(vStatus) == 101 .or.;   // Cancelamento autorizado             --> Cod.Sit=02
          val(vStatus) == 102 .or.;   // Inutilizacao de NFe Autorizado      --> Cod.Sit=05
		    val(vStatus) == 110 .or.;   // Uso Denegado                        --> Cod.Sit=04
		    val(vStatus) == 111 .or.;   // Consulta cadastro com  1 ocorrencia
		    val(vStatus) == 112 .or.;   // Consulta cadastro com +1 ocorrencia
          val(vStatus) == 108 .or.;   // Servico paralisado (curto prazo)
          val(vStatus) == 109 .or.;   // Servico paralisado sem previsao
          CONTINGENCIA
          replace nf->StatusNFe with vStatus
          if val(vStatus) == 107
             MsgAlert('ATEN€ÇO !!! Servi‡o de Autoriza‡Æo de NFe com problemas t‚cnicos (curto prazo)')
          endif
          if val(vStatus) == 108
             MsgAlert('ATEN€ÇO !!! Servi‡o de Autoriza‡Æo de NFe com problemas t‚cnicos (sem previsÆo de retorno)')
          endif
          if val(vStatus) == 101 .or. val(vStatus) == 102 .or. val(vStatus) == 110
             *** Cancela/Inutiliza a NF de acordo com o Codigo SPED ***
             do case
                case vSTATUS    == '101'
                     *** Cancelada ***
                     vSIT_DOCTO := '02'
                     vTIPO_CANC := 'C'

                case vSTATUS    == '102'
                     *** Inutilizada ***
                     vSIT_DOCTO := '02'
                     vTIPO_CANC := 'I'

                case vSTATUS    == '110'
                     *** Denegada ***
                     vSIT_DOCTO := '02'
                     vTIPO_CANC := 'D'
             endcase
             replace nf->SIT_DOCTO with vSIT_DOCTO ,;
                     nf->DT_CANC   with date()     ,;
                     nf->CANCELADA with .t.        ,;
                     nf->TIPO_CANC with vTIPO_CANC
             do case
                case left(nf->NROVENDA,1) == 'F'
                     select FATURAS
                     set order to 1
                     seek nf->FILIAL + nf->NROVENDA

                case left(nf->NROVENDA,1) == 'P'
                     select CADPEDc
                     set order to 1
                     seek nf->FILIAL + nf->NROVENDA

                case left(nf->NROVENDA,1) == 'O'
                     select CADOS
                     set order to 1
                     seek nf->FILIAL + nf->NROVENDA
                other
                     select CADVENDA
                     set order to 1
                     seek nf->FILIAL + str(val(nf->NROVENDA),7)
             endcase
             reglock(.f.)
             AuditAlt( procname() )

             *** So zera a NF se o Numero da NF for igual ao numero da Venda ***
             if nf->NUMERO == NF_VENDA  .and. nf->SERIE == SERIE
                replace NF_VENDA with 0        ,;
                        SERIE    with '   '    ,;
                        NFE_RAND with space(10)
                dbcommit()
             endif
          endif
          select NF
          nf->(dbcommit())
          GravaRetorno := .t.
       endif
       vTXT_STATUS     := ''
       vMOSTRA_STATUS  := .f.
       do case
          case val(vSTATUS)   == 100
               vTXT_STATUS    := '(NFe Autorizada)'
               vMOSTRA_STATUS := .t.
               
          case val(vSTATUS)   == 101
               vTXT_STATUS    := '(NFe Cancelada) '
               vMOSTRA_STATUS := .t.
               
          case val(vSTATUS)   == 102
               vTXT_STATUS    := '(Inutiliza‡Æo de N£meros de NFe Homologado)'
               vMOSTRA_STATUS := .t.
               
          case val(vSTATUS)   == 107
               vTXT_STATUS    := '(Servi‡o em Opera‡Æo)'
               vMOSTRA_STATUS := .t.
               
          case val(vSTATUS)   == 108
               vTXT_STATUS    := '(Servi‡o Paralisado Temporariamente)'
               vMOSTRA_STATUS := .t.
               
          case val(vSTATUS)   == 109
               vTXT_STATUS    := '(Servi‡o Paralisado Sem PrevisÆo)'
               vMOSTRA_STATUS := .t.
               
          case val(vSTATUS)   == 110
               vTXT_STATUS    := '(NFe Denegada)  '
               vMOSTRA_STATUS := .t.
               
          case val(vSTATUS)   == 115
               vTXT_STATUS    := '(Evento Registrado Mas NÇO Vinculado-FORA DO PRAZO)'
               vMOSTRA_STATUS := .t.
               vCartaCorrecao := .t.

          case val(vSTATUS)   == 135
               vTXT_STATUS    := '(Evento Registrado e Vinculado a NFe)'
               vMOSTRA_STATUS := .t.
               vCartaCorrecao := .t.
               
          case val(vSTATUS)   == 136
               vTXT_STATUS    := '(Evento Registrado Mas NÇO Vinculado a NFe)'
               vMOSTRA_STATUS := .t.
               vCartaCorrecao := .t.
               
          case CONTINGENCIA
               vTXT_STATUS    := '(NFe Emitida em Contingˆncia)'
               vMOSTRA_STATUS := .t.
       endcase
       if vMOSTRA_STATUS
          if !vTXT_STATUS $ vTxtErro
             vTxtErro    += 'Status=' + vStatus + '  ' + vTXT_STATUS + space(10)
          endif
       endif
    endif

    *** Versao do retorno ***
    if 'Versao='   $ vDADOSNFe
       vVersao     := alltrim(substr(vDADOSNFe,08,20))
       *** vTxtErro+='Versao='+vVersao+'  '
       *** MsgAlert('vVersao='+vVersao)
	 endif

    *** Tipo de ambiente (1=Produ‡Æo   2=Homologa‡Æo)
    if 'TpAmb='    $ vDADOSNFe .or.;   // NFe
       'tpAmb='    $ vDADOSNFe         // CCe
       vTipoAmb    := alltrim(substr(vDADOSNFe,07,20))
       *** vTxtErro+='Ambiente='+vTipoAmb+'  '
       *** MsgAlert('vTipoAmb='+vTipoAmb)
	 endif

    *** Se for STATUS acrescenta ambiente na mensagem ***
    if val(vSTATUS) == 107 .and. !vPrimeiraVez
       vTxtErro     := alltrim(vTxtErro) + ' em Ambiente de '+iif(vTipoAmb='1','Produ‡Æo','Homologa‡Æo')
       vPrimeiraVez := .t.
    endif
    
    *** moeda do movimento ***
    if 'VerAplic=' $ vDADOSNFe .or.;   // NFe
       'verAplic=' $ vDADOSNFe         // CCe
       vVerAplic   := substr(vDADOSNFe,10,20)
       *** vTxtErro+='Versao Aplic='+vVerAplic+'  '
       *** msgalert('vVerAplic='+vVerAplic)
	 endif

    *** Motivo (Campo para saber se NF foi autorizada) ***
    if 'xMotivo='  $ vDADOSNFe
       vMotivo     := alltrim(substr(vDADOSNFe,09,37))
       if !vMotivo                     $ vTxtErro .and. ;
          !'Lote de Evento Processado' $ vDADOSNFe          // CCe
          vTxtErro +='Motivo=' + vMotivo + '  '
          *** msgalert('vMotivo='+vMotivo) ***
       endif
    endif

    *** Chave da NFe ***
    if 'ChNFe'     $ vDADOSNFe .and. (val(vStatus) == 100 .or.;   // Autorizada
                                      val(vStatus) == 101 .or.;   // Cancelada
                                      val(vStatus) == 102 .or.;   // Inutilizada
                                      val(vStatus) == 110 .or.;   // Denegada
                                      CONTINGENCIA)
       vChaveNFe   := substr(vDADOSNFe,07,44)
       replace nf->CHAVENFE      with vChaveNFe
       nf->(dbcommit())
       vTxtErro    += 'ChaveNFe='+vChaveNFe+'  '
    endif

    *** Chave da NFe para CCe ***
    if 'chNFe'     $ vDADOSNFe .and. (val(vStatus) == 135 .or.;   // Autorizada CCe e vinculada
                                      val(vStatus) == 136 )       // Autorizada CCe mas NAO vinculada
       vChaveNFe   := substr(vDADOSNFe,07,44)
       vTxtErro    += 'NFe='+vChaveNFe+'  '
    endif

    *** Numero do Protocolo ***
    if 'NProt='    $ vDADOSNFe .or.;      // NFe
       'nProt='    $ vDADOSNFe            // CCe
       vProtocolo  := substr(vDADOSNFe,07,20)
       if !vProtocolo $ vTxtErro
          vTxtErro    +='Protocolo='+vProtocolo+'  '
       endif
       *** MsgAlert('dentro do retorno ACBR vProtocolo='+vProtocolo)
    endif

    *** Numero do recebimento da NFe  (gravar no banco)***
    if 'NRec='     $ vDADOSNFe
       vNroRec     := substr(vDADOSNFe,06,20)
       *** vTxtErro    += 'NroRecibo='+vNroRec+'  '
       *** MsgAlert('vNroRec='+vNroRec)
    endif

    *** Data do recebimento  (gravar no banco) ***
    if 'DhRecbto='    $ vDADOSNFe .or.;  // NFe
       'dhRegEvento=' $ vDADOSNFe        // CCe
       vDataRec    := substr(vDADOSNFe,10,20)
       *** vTxtErro+='DhRebcto='+vDataRec+'  '
       *** msgalert('vDataRec='+vDataRec)
    endif

    *** Digito da transacao ***
    if 'DigVal='   $ vDADOSNFe
       vDigito     := substr(vDADOSNFe,07,20)
	    *** vTxtErro+='DigVal='+vDigito+'  '
       *** MsgAlert('vDigito='+vDigito)
    endif
next

if !vCANCELAMENTO .and. ( val(vSTATUS) == 135 .or. val(vSTATUS) == 136 )
   *** 135 = (CCe Registrada e Vinculada a NFe)       ***
   *** 136 = (CCe Registrada Mas NÇO Vinculada a NFe) ***
   select CORRECAO
   reglock(.f.)
   AuditAlt( procname() )

   replace correcao->VersaoNFe with vVERSAO   ,;
           correcao->AmbNFe    with vTipoAmb  ,;
           correcao->vAplicNFe with vVerAplic ,;
           correcao->MotivoNFe with vMotivo   ,;
           correcao->ProtocNFe with vProtocolo,;
           correcao->RecNFe    with vNroRec   ,;
           correcao->DthRecNFe with vDataRec  ,;
           correcao->DigValNFe with vDigito   ,;
           correcao->ChaveNFe  with vChaveNFe ,;
           correcao->TpEvento  with vTpEvento
   correcao->( dbcommit() )
   correcao->( dbunlock() )
endif

if GravaRetorno
   replace nf->VersaoNFe with vVERSAO   ,;
           nf->AmbNFe    with vTipoAmb  ,;
           nf->vAplicNFe with vVerAplic ,;
           nf->MotivoNFe with vMotivo   ,;
           nf->ProtocNFe with vProtocolo,;
           nf->RecNFe    with vNroRec   ,;
           nf->DthRecNFe with vDataRec  ,;
           nf->DigValNFe with vDigito
   if !empty(vChaveNfe)
      replace nf->CHAVENFE  with vChaveNFe
   endif
   nf->( dbcommit() )
   nf->( dbunlock() )
endif

*** Fecha o arquivo com comprovante ***
fClose(vNFeArq)

*** Apago o arquivo de retono ***
if file("C:\MONITOR\RET\RETORNO.TXT")
   ferase( "C:\MONITOR\RET\RETORNO.TXT" )
endif

if val(vStatus)<>103 .and.;
   val(vStatus)<>104 .and.;
   val(vStatus)<>105 .and.;
   !empty(vTxtErro)
   MsgAlert(vTxtErro)
endif

if 'Email enviado' $ vDADOSNFe
   MsgAlert(alltrim(substr(vDADOSNFe,04,40))+' NFe '+strzero(nf->NUMERO,9))
endif

return(.T.)



Function ACBR_AbreNFe()
**************************************
* Cria arquivo DBF para transacoes NFe
**************************************
ArqAntFuncao := dbf()

if len(ArqAntFuncao) >0
   select (ArqAntFuncao)
endif
return(.t.)



Function ACBR_FechaNFe()
*******************************************
* Apaga arquivo temporario de transacao NFe
*******************************************

*** Apagando arquivo de NFe gerado pelo GerarININFeV2 ***
if file("C:\TEMP\NFE.DBF")
   ferase( "C:\TEMP\NFE.DBF" )
   if fError()<>0
      ErrosDOS(fError(), procname(), procline(), "C:\TEMP\NFE.DBF" )
   endif
endif
if file("C:\MONITOR\REM\REMESSA.TXT" )
   ferase( "C:\MONITOR\REM\REMESSA.TXT" )
   if fError()<>0
      ErrosDOS(fError(), procname(), procline(), "C:\MONITOR\REM\REMESSA.TXT" )
   endif
endif
if file("C:\MONITOR\RET\RETORNO.TXT" )
   ferase( "C:\MONITOR\RET\RETORNO.TXT" )
   if fError()<>0
      ErrosDOS(fError(), procname(), procline(), "C:\MONITOR\RET\RETORNO.TXT" )
   endif
endif

select (ArqAntNFe)

return(.t.)



Function MensNFe(LI, vTxtNFe)
*********************************************
* Apresenta mensagens na tela para o operador
*********************************************
local CORANT := setcursor()
setcolor('R+/R','GR/R')
CI := (80 - len(vTxtNFe)) / 2
@ LI, CI clea to LI+2, CI + len(vTxtNFe) + 2
@ LI, CI      to LI+2, CI + len(vTxtNFe) + 2 
sombra(LI, CI  , LI+2, CI + len(vTxtNFe) + 2 )
setcolor('W+/R*')
@ LI+1,CI+2 say vTXTNFe
setcolor(CORANT)
return(.t.)


Function ACBR_RecuperaGravaChaveNFe()
***************************************
* Verifica em todos os XML da pasta qual
* corresponde a NF em questÆo e grava a chave
* da NFe no arquivo de NF
***************************************
aArqCli   := Array( ADir( alltrim(setup->XMLNFE)+'*-nfe.XML' ) )
aDirCli   := ADir( alltrim(setup->XMLNFE)+'*-nfe.XML', aArqCli )
TOTAL_ARQ := Len( aArqCli )
COPIADOS  := 0
for pqrs  := 1 to Len( aArqCli )
    vNFE      := substr( aArqCli[pqrs] , 26, 09)
    vCHAVENFE := substr( aArqCli[pqrs] , 01, 44)
    if nf->SERIE == 'NFE'
       vMODELO   := '55'
    else
       vMODELO   := '65'
    endif
    if nf->NUMERO == val(vNFE) .and. empty(nf->CHAVENFE) .and. vMODELO == substr(vCHAVENFE,21,2)
       MsgAlert('Foi encontrado o Arquivo XML para a NFe '+strzero(nf->NUMERO,9)+' Serie '+vMODELO+;
                   ' com a Chave ' + aArqCli[pqrs]+'  e ser  gravada na NF.')
       ARQANTNF := dbf()

       select NF
       reglock(.f.)
       AuditAlt( procname() )

       replace CHAVENFE with vCHAVENFE
       nf->( dbcommit() )
       nf->( dbunlock() )
       select (ARQANTNF)
    endif
next
return(.t.)



Function ACBR_AtivarMonitorNFe()
*****************************************
* Verifica se o Monitor de NFe esta ativo
* Retorna .F. se Nao estiver ativo ou
*         .T. se Estiver ativo
*****************************************
vVEZES      := 0

MensRede('Aguarde...Ativando o Monitor de NFe...')
inkey(.5)

*** Carregando gerenciador ***
run C:\MONITOR\ACBrNFeMonitor.EXE
MensRede()
return(.t.)





Function ACBR_StatusServicoNFe()
*************************************
* Verifica se WebServices estao ativos
*************************************
if !nivel('WEBSERVICE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif
cCmd    := ""
ACBR_ExecutaNFe( "NFE.StatusServico", ["]+cCmd+["] )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_FecharMonitorNFe()
**********************************
* Fecha o monitor apos alterar INI
**********************************
cCmd    := ""
ACBR_ExecutaNFe( "NFE.EncerrarMonitor", ["]+cCmd+["] )
return(RETORNO)


Function ACBR_CriarXMLNFe( cINI, cXML)
***************************************************
* Criar um XML da NFe baseada em arquivo INI
* cINI = Variavel com Dados da NFe em formato INI 
* xXML = Flag se retorna ou nao o arquivo XML
***************************************************
cCmd    := iif(cINI=nil,"",cINI)
ACBR_ExecutaNFe( "NFE.CriarNFe", ["]+cCmd+["] )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_CriarXMLEnviarNFe( cINI, nLote, nImprime )
***************************************************
* Criar um XML da NFe baseada em arquivo INI
* cINI     = Variavel com Dados da NFe em formato INI 
* nNumLOte = Numero do Lote de NFe
***************************************************
nLote    := alltrim(str( nLote ))
nImprime := alltrim(str( nImprime ))
cCmd     := ["]+cINI+[",]+nLote+[,]+nImprime
ACBR_ExecutaNFe( "NFE.CriarEnviarNFe", cCmd )
RETORNO  := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_CriarXMLEnviarCCe( cINI, nLote, nImprime )
***************************************************
* Criar um XML da CCe baseada em arquivo INI
* cINI     = Variavel com Dados da CCe em formato INI
* nNumLOte = Numero do Lote de CCe
***************************************************
nLote    := alltrim(str( nLote ))
nImprime := alltrim(str( nImprime ))
cCmd     := ["]+cINI+[",]+nLote+[,]+nImprime
ACBR_ExecutaNFe( "NFE.CARTADECORRECAO", cCmd )
RETORNO  := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_AssinarNFe( cXML )
******************************************
* Assinar uma NF gerada 
* cXML = Local e nome do arquivo XML de NF
******************************************
cCmd    := iif(cXML=nil,"",cXML)
msgalert('recebi='+cXML)
ACBR_ExecutaNFe( "NFE.AssinarNFe", ["]+cCmd+["] )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_ValidarNFe( cXML )
******************************************
* Validar uma NF gerada 
* cXML = Local e nome do arquivo XML de NF
* OBS : O arquivo a ser validado ja deve ter
*       sido Assinado
******************************************
cCmd    := iif(cXML=nil,"",cXML)
ACBR_ExecutaNFe( "NFE.ValidarNFe", ["]+cCmd+["] )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_ConsultarNFe( cNFe )
******************************************
* Consulta uma NF gerada 
* cNFe = Chave da NFe a ser consulta
******************************************
cCmd    := iif(cNFe=nil,"",cNFe)
ACBR_ExecutaNFe( "NFE.ConsultarNFe", ["]+cCmd+["] )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_CancelarNFe( cNFe,cMOTIVO )
******************************************
* Cancelar uma NF gerada 
* cNFe = Chave da NFe a ser consulta
* cMOTIVO = Motivo do cancelamento da NFe
******************************************
cCmd    := ["]+cNFe+[",] + cMOTIVO
ACBR_ExecutaNFe( "NFE.CancelarNFe", cCmd )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_EnviarEventoNFe( cNFe,cMOTIVO )
******************************************
* Cancelar uma NF gerada
* cNFe = Chave da NFe a ser consulta
* cMOTIVO = Motivo do cancelamento da NFe
******************************************
/*
NFE.ENVIAREVENTO("[EVENTO]
idLote=XXX                    // a mesma sequencia da NFe
[EVENTO001]
chNFe=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
cOrgao=XX                     // o codigo do teu estado
CNPJ=XXXXXXXXXXXXXX           // do emissor
dhEvento=01/04/13 16:30:00    // data e hora do evento
tpEvento=1101101               // Este codigo para cancelamento
nSeqEvento=
versaoEvento=
descEvento=
xCorrecao=
xCondUso=
nProt=415130000008688         //Protocolo de autorizacao da NFE
xJust=Motivo do Cancelamento da NFe")
*/
return(.f.)


Function ACBR_ImprimirDANFe( cXML )
**********************************************
* Imprime o DANFE de uma NF gerada
* cXML = Nota Fiscal em formato de arquivo XML
**********************************************
cCmd    := iif(cXML=nil,"",cXML)
ACBR_ExecutaNFe( "NFE.ImprimirDANFe", ["]+cCmd+["] )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_ImprimirEvento( cEVENTO, cXML )
**********************************************
* Imprime o Evento de uma NF gerada (CCe e Cancelamento)
* cEvento = Evento da NFe (CCe ou Cancelamento)
* cXML    = Nota Fiscal em formato de arquivo XML
**********************************************
cCmd        := ["]+cEVENTO+["]
if pcount() == 2
   cCmd     := ["]+cEVENTO+[",] + ["]+cXML+["]
endif

ACBR_ExecutaNFe( "NFE.ImprimirEvento", cCmd )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_ImprimirDANFEPDF( cXML )
**********************************************
* Imprime o DANFE de uma NF gerada no formato PDF
* cXML = Nota Fiscal em formato de arquivo XML
**********************************************
cCmd    := iif(cXML=nil,"",cXML)
ACBR_ExecutaNFe( "NFE.ImprimirDANFEPDF", ["]+cCmd+["] )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_InutilizarNFe( cCNPJ, cJustificativa, nAno, nModelo, nSerie, nNumInicial, nNumFinal )
*****************************************************
* Inutiliza um intervalor de numeros de NFe
* cCNPJ          = CNPJ do Emitente da NFe
* cJustificativa = Motivo da inutilizacao
* nAno           = Ano que foi inutilizado a numeracao
* nModelo        = Modelo da NF
* nSerie         = Serie da NF
* nNumInicial    = Numero inicial a ser inutilizado
* nNumFinal      = Numero final a ser inutilizado
*****************************************************
cCNPJ          := NoMask(iif( cCNPJ=nil,"XXXXXXXXXXXXXX",cCNPJ ))
cJustificativa := iif( cJustificativa=nil,"ERRO NA GERACAO DA NFe",cJustificativa )
nAno           := alltrim(str( nAno ))
nModelo        := alltrim(str( nModelo ))
nSerie         := alltrim(str( nSerie ))
nNumInicial    := alltrim(str( nNumInicial ))
nNumFinal      := alltrim(str( nNumfinal ))
cCmd           := ["]+cCNPJ+[","]+cJustificativa+[",]+nAno+[,]+nModelo+[,]+nSerie+[,]+nNumInicial+[,]+nNumFinal

****MsgAlert('Ano='+nAno+'   Modelo='+nModelo+'  Serie='+nSerie+'   Inicial='+nNumInicial +'  Final='+nNumfinal)

ACBR_ExecutaNFe( "NFE.InutilizarNFe", cCmd )
RETORNO        := ACBR_RetornoNFe()
return(RETORNO)


Function ACBR_EnviarNFe( cArquivo, nLote, nAssina, nImprime )
********************************************************
* Enviar arquivo gerado de NF em formato XML
* cArquivo = 
* nLote    = Numero do lotes das NF
* nAssina  = (0) Nao assina arquivo e (1) Assina arquivo
* nImprime = (1) Imprime o DANFE apos envio da NFe
********************************************************
nLote          := alltrim(str( nLote ))
nAssina        := alltrim(str( nAssina ))
nImprime       := alltrim(str( nImprime ))
cCmd           := ["]+cArquivo+[",]+nLote+[,]+nAssina+[,]+nImprime
ACBR_ExecutaNFe( "NFE.EnviarNFe", cCmd )
RETORNO := ACBR_RetornoNFe()
Return(RETORNO)


Function ACBR_ConsultaContribuinte(vESTADO,vDOCUMENTO)
****************************************
* vESTADO    = Estado do contribuinte
* vDOCUMENTO = CNPJ ou CPF
****************************************
cCmd := []+vESTADO+[,]+vDOCUMENTO

MsgAlert('vCMD='+cCMD)

** ACBR_ExecutaNFe( "NFE.ConsultaCadastro", ["]+cCmd+["] )
ACBR_ExecutaNFe( "NFE.ConsultaCadastro", 'RO','04428897000100' )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)



Function ACBR_ConsultaValidadeCertificado()
****************************************
* vESTADO    = Estado do contribuinte
* vDOCUMENTO = CNPJ ou CPF
****************************************
ACBR_ExecutaNFe( 'NFe.CertificadoDataVencimento' )
RETORNO := ACBR_RetornoNFe()
return(RETORNO)



Function ACBR_EnviarNFeEmail( cEMAIL, cNFe, nPDF, cEmailCopia )
***************************************************************************************
* Enviar por Email a NFe gerada
*------------------------------
* cEMAIL      = Email do destinatario
* cNFE        = Caminho do arquivo de NFe
* nPDF        = 0 para NAO mandar e 1 se for para ir o PDF
* cEmailCopia = enderecos de email para enviar copia separados por ;
* cMostraConfirmacao = Mostra alert com a confirmacao ou nao se foi enviado com sucesso
***************************************************************************************
cEMAIL     := alltrim( cEMAIL )
cNFE       := alltrim( cNFE )
nPDF       := alltrim(str( nPDF ))
cEmailCopia:= alltrim( cEmailCopia )
cCmd       := ["]+cEMAIL+[",]+cNFE+[,]+nPDF+[,,]+cEmailCopia
ACBR_ExecutaNFe( "NFE.EnviarEmail", cCmd )
RETORNO  := ACBR_RetornoNFe()
return(RETORNO)




Function ACBR_EnviarNFeEmailEvento( cEmail, cArqEvento, cArqNFe, cEnviaPDF, cAssunto, cEmailCopia )
***************************************************************************************
* Enviar por Email a CCe gerada
*------------------------------
* cEMAIL      = Email do destinatario
* cArqCCe     = Caminho do arquivo de Evento da CCe
* cArqNFe     = Caminho do arquivo de NFe
* nPDF        = 0 para NAO mandar e 1 se for para ir o PDF
* cEmailCopia = enderecos de email para enviar copia separados por ;
* cMostraConfirmacao = Mostra alert com a confirmacao ou nao se foi enviado com sucesso
***************************************************************************************
cEMAIL     := alltrim( cEMAIL )
cArqEvento := alltrim( cArqEvento )
cArqNFe    := alltrim( cArqNFe )
cEnviaPDF  := alltrim( cEnviaPDF )
nPDF       := alltrim(str( nPDF ))
cEmailCopia:= alltrim( cEmailCopia )
cAssunto   := alltrim( cAssunto )

cCmd       := ["]+cEMAIL+[",]+cArqNFe+[,]+nPDF+[,,]+cEmailCopia
ACBR_ExecutaNFe( "NFE.EnviarEmailEvento", cCmd )
RETORNO    := ACBR_RetornoNFe()
return(RETORNO)




Function NFeMod11(vChaveNFe)
**********************************************
* Calcular o digito da chave NFe com Modulo 11
**********************************************
xMULT = 2
xDIG  = 0
ContaLaco = len(vChaveNFe)
do while ContaLaco > 0
   xDIG  = xDIG  + (xMULT * val(substr(vChaveNFe, ContaLaco, 1)))
   xMULT = xMULT + 1
   if xMULT >9
      xMULT =2
   endif
   ContaLaco--
enddo
xDIG = mod(xDIG,11)
xDIG = iif(xDIG=0.or.xDIG=1, 0, 11-xDIG)
retu(xDIG)


Function NFeRandomico()
***********************************************
* Gera codigo numerico para compor chave da NFe
***********************************************
vCodNumNFe := HB_RandomInt (1,999999999)
return(strzero(vCodNumNFe,9))


Function NFeNumero()
**********************
* Gerar a chave da NFe
**********************
return(.t.)


Function ACBR_GerarNFe(vNROVENDA)
******************************************************************
* PROGRAMA   : GerarNFe.PRG
* FINALIDADE : Gerar Registro com os Dados da NFe - VENDA DE BALCAO
* MODELO 55 
******************************************************************
if setup->VersaoNFe == 2
   ACBR_GerarIniNFeV2_00()
else
   ACBR_GerarIniNFeV3_10()
endif
return(.t.)


Function GravaLinhaNFe(vLinhaNFe)
*********************************************
* Grava linha com instrucoes para arquivo INI
*********************************************
select DBFNFe
append blank
replace LinhaNFe with vLinhaNFe
select ItemNF
return(.t.)


Function GravaLinhaCCe(vLinhaCCe)
*********************************************
* Grava linha com instrucoes para arquivo INI
*********************************************
local ArqAntCCe:=dbf()
select DBFCCe
append blank
replace LinhaCCe with vLinhaCCe
select (ArqAntCCe)
return(.t.)


Function TrocaParse(vTXTCONV)
****************************************************
* Verifica se existe os caracteres especiais e troca
* Onde for :        Vai para :
*             <   --->   &lt;
*             >   --->   &gt;
*             &   --->   &amp;
*             "   --->   &quot;
*             '   --->   &#39;
****************************************************
vTXTCONV := strtran( vTXTCONV , '<'  , ' &lt; ' )
vTXTCONV := strtran( vTXTCONV , '>'  , ' &gt; ' )
vTXTCONV := strtran( vTXTCONV , '&'  , ' &amp; ' )
vTXTCONV := strtran( vTXTCONV , '"'  , ' &quot; ' )
vTXTCONV := strtran( vTXTCONV , "'"  , ' &#39; ' )
vTXTCONV := strtran( vTXTCONV , "`"  , ' &#39; ' )
return(vTXTCONV)


Function LimpaPlaca(vTXTCONV)
****************************************************
* Verifica se existe os caracteres especiais e troca
* Usado por exemplo campo PLACA
****************************************************
vTXTCONV := strtran( vTXTCONV , '-' , '' )
vTXTCONV := strtran( vTXTCONV , '/' , '' )
vTXTCONV := strtran( vTXTCONV , '=' , '' )
vTXTCONV := strtran( vTXTCONV , '\' , '' )
vTXTCONV := strtran( vTXTCONV , '.' , '' )
vTXTCONV := strtran( vTXTCONV , ' ' , '' )
return(vTXTCONV)


Function P_MotivoDesICMS()
**********************************************
* Modalidade de Desoneracao do ICMS do produto
**********************************************
local CAP:=setcolor()
do case
   case vMotDesICMS == 1
        @ row(),col()+1 say '1-T xi             '
   case vMotDesICMS == 2
        @ row(),col()+1 say '2-Deficiente F¡sico'
   case vMotDesICMS == 3
        @ row(),col()+1 say '3-Prod.Agropecu rio'
   case vMotDesICMS == 4
        @ row(),col()+1 say '4-Frotista/Locadora'
   case vMotDesICMS == 5
        @ row(),col()+1 say '5-Diplom ta/Consul '
   case vMotDesICMS == 6
        @ row(),col()+1 say '6-Utilit rio na ALC'
   case vMotDesICMS == 7
        @ row(),col()+1 say '7-SUFRAMA          '
   case vMotDesICMS == 8
        @ row(),col()+1 say '8-Vnd àrgÆo P£blico'
   case vMotDesICMS == 9
        @ row(),col()+1 say '9-Outros           '
   otherwise
        TabelasSPED('DESONERACAOICMS' ,vMotDesICMS  , row(), col()+1, 'Desoneracao ICMS'  , 'vMotDesICMS'  , 'N', 0, .t., 1, 9 )
        return(.f.)
endcase
setcolor(CAP)
return(.t.)



Function P_ModalICMS()
*******************************
* Modalidade do ICMS do produto
*******************************
local CAP:=setcolor()
static GETLIST:={}
do case
   case vModalICMS == '0'
        @ row(),col()+1 say 'Margem Vlr Agregado'
   case vModalICMS == '1'
        @ row(),col()+1 say 'Pauta (Valor)      '
   case vModalICMS == '2'
        @ row(),col()+1 say 'Pre‡o Tabelado Max '
   case vModalICMS == '3'
        @ row(),col()+1 say 'Valor da Opera‡Æo  '
   case vModalICMS == ' '
        @ row(),col()+1 say 'Sem Modalidade ICMS'
	otherwise
        TabelasSPED('MODALIDADEICMS'     ,vModalICMS  , row(), col()+1, 'Modalidade ICMS'  , 'vModalICMS'  , 'N', 0, .t., 0, 3 )
        vModalICMS := strzero(vModalICMS,1)
        return(.f.)
endcase
if vModalICMS == '1'
   save screen to TPAUTA
   CORPAUTA := setcolor()
   quadro('09','25','12','58',' Valor da Pauta ','W+/B+')
   @ 11,27 say 'Valor da Pauta Äþ ' get vVLR_PAUTA pict '99999999.99'
   read
   restore screen from TPAUTA
   setcolor(CORPAUTA)
endif
return(.t.)


Function P_ModalSubs()
***************************************
* Modalidade da Substituicao Tributaria
***************************************
local CAP:=setcolor()
static GETLIST:={}
do case
   case vModalSUBS == '0'
        @ row(),col()+1 say 'Pre‡o Tabelado          '
   case vModalSUBS == '1'
        @ row(),col()+1 say 'Lista Negativa (Vlr)    '
   case vModalSUBS == '2'
        @ row(),col()+1 say 'Lista Positiva (Vlr)    '
   case vModalSUBS == '3'
        @ row(),col()+1 say 'Lista Neutra (Vlr)      '
   case vModalSUBS == '4'
        @ row(),col()+1 say 'Margem Vlr Agregado     '
   case vModalSUBS == '5'
        @ row(),col()+1 say 'Pauta (Vlr)             '
   case vModalSUBS == ' '
        @ row(),col()+1 say 'Sem Modal.p/Substitui‡Æo'
   otherwise
        TabelasSPED('MODALIDADESUBSTIT'     ,vModalSubs  , row(), col()+1, 'Modalidade Substitui‡Æo'  , 'vModalSubs'  , 'N', 0, .t., 0, 5 )
        vModalSUBS := strzero(vModalSUBS,1)
        return(.f.)
endcase
if vModalSUBS == '5'
   save screen to TPAUTA
   CORPAUTA   := setcolor()
   quadro('09','25','12','58',' Valor da Pauta ','W+/B+')
   @ 11,27 say 'Valor da Pauta Äþ ' get vVLR_PAUTA pict '99999999.99'
   read
   restore scree from TPAUTA
   setcolor(CORPAUTA)
endif
return(.t.)


Function P_Modal()
**********************************
* Modalidade da Entrada no estoque
**********************************
local CAP := setcolor()
do case
   case vMODALID    == 0
        @ row(),col()+1 say 'p/Estoque(Revenda) '
        vCONTA_CONT := '101030101'
   case vMODALID    == 1
        @ row(),col()+1 say 'Mat‚ria Prima      '
        vCONTA_CONT := '101030102'
   case vMODALID    == 2
        @ row(),col()+1 say 'Embalagem          '
        vCONTA_CONT := '101030400'
   case vMODALID    == 3
        @ row(),col()+1 say 'Produto em Processo'
        vCONTA_CONT := '101030103'
   case vMODALID    == 4
        @ row(),col()+1 say 'Produto Acabado    '
        vCONTA_CONT := '101030104'
   case vMODALID    == 5
        @ row(),col()+1 say 'Subproduto         '
        vCONTA_CONT := '101030400'
   case vMODALID    == 6
        @ row(),col()+1 say 'Prod.Intermedi rio '
        vCONTA_CONT := '101030400'
   case vMODALID    == 7
        @ row(),col()+1 say 'Mat.Uso/Combust¡vel'
        vCONTA_CONT := '101030400'
   case vMODALID    == 8
        @ row(),col()+1 say 'Ativo Imobilizado  '
        vCONTA_CONT := '101030400'
   case vMODALID    == 9
        @ row(),col()+1 say 'Servi‡os           '
        vCONTA_CONT := '101030105'
   case vMODALID    == 10
        @ row(),col()+1 say 'Outros Insumos     '
        vCONTA_CONT := '101030102'
   case vMODALID    == 88
        @ row(),col()+1 say 'Conhec.Transportes '
   case vMODALID    == 99
        @ row(),col()+1 say 'Outras             '
        vCSIAD      := 'N'
   other
        TabelasSPED('MODALIDADEPRODUTO'     ,vMODALID  , row(), col()+1, 'Modalidade Produto'  , 'vMODALID'  , 'N', 0, .t., 0, 99 )
        do case
           case vMODALID    == 0
                vCONTA_CONT := '101030101'
           case vMODALID    == 1
                vCONTA_CONT := '101030400'
           case vMODALID    == 2
                vCONTA_CONT := '101030103'
           case vMODALID    == 3
                vCONTA_CONT := '101030104'
           case vMODALID    == 4
                vCONTA_CONT := '101030400'
           case vMODALID    == 5
                vCONTA_CONT := '101030400'
           case vMODALID    == 6
                vCONTA_CONT := '101030400'
           case vMODALID    == 7
                vCONTA_CONT := '101030400'
           case vMODALID    == 8
                vCONTA_CONT := '101030105'
           case vMODALID    == 9
                vCONTA_CONT := '101030102'
           case vMODALID    == 10
                vCONTA_CONT := '101030101'
           case vMODALID    == 11
                vCONTA_CONT := '101030101'
        endcase
        return(.f.)
endcase
return(.t.)


Function P_LEI116(vCOD_SERV, MOSTRA)
************************************
* Pesquisar SERVICOS DA LEI 116/2003
************************************
local COR_ANT, TELA_ANT, ARQ_ANT
if empty(vCOD_SERV) .and. left(vCOD_FABRI,3)='MAO'
   return(.f.)
endif
if empty(vCOD_SERV) .and. left(vCOD_FABRI,3)<>'MAO'
	return(.t.)
endif
COR_ANT := setcolor()
ARQ_ANT := dbf()
select CADSERV
set order to 1
seek vCOD_SERV
if eof()
   set order to 2
   vCampoGrid := "COD_SERV;NOME;'    '+iif(TIPO='A','NAO','SIM')"
   vTitGrid   := "C¢digo;Nome;Aceita Lacto ?"
   GridPadrao()
   setcolor(COR_ANT)
   return(.F.)
endif
igual_var()
setcolor(COR_ANT)
if MOSTRA
   @ row(),col()+2 say NOME
endif
if !empty(ARQ_ANT)
   select (ARQ_ANT)
endif
keyboard chr(0)
return(.T.)


Function TabelasSPED(vNomeTabela, vCodigoTabela, vLinhaTela, vColunaTela, vDescTabela, vNomeVariavel, vTipoVariavel, vTamVariavel, vMostrarLinha, vIntervaloIni, vIntervaloFim )
***************************************************************************
* Abre consulta padrao para TODAS as tabelas auxiliares do SPED
***************************************************************************
* Ex Chamada    = TabelasSPED('CSTPISCOFINS', vCST_PIS_E , row(), col()+1, 'PIS'   , 'vCST_PIS_E'  , 'N', 0, .t., 10, 50 ))
*******************************************************************************************************************
* vNomeTabela   = Nome do campo que ser  localizado
* vCodigoTabela = Variavel enviada com conteudo da memoria para localizar na tabela
* LinhaTela     = Linha da tela que ser  retornado
* vColunaTela   = Coluna da tela
* vDescTabela   = Descricao da Tabela
* vNomeVariavel = Nome da variavel que sera atualizado o conteudo do campo
* vTipoVariavel = Tipo da variavel (caracter ou numerico)
* vTamVariavel  = Tamanho da varavel p/retorno
* vMostrarLinha = (.T.)-> Mostra linha tabela ou (.F.)-> NÆo mostra linha tabela
* vIntervaloIni = Intervalo Inicial de codigo para tabela
* vIntervaloFim = Intervalo Final de codigo para tabela
************************************************************************
local ArqDBFAnt  := dbf()
local CorAnt     := setcolor()

select TABELAS
if vTipoVariavel =='C'
   vCodigoTabela := val(vCodigoTabela)
endif

*** Verifica se estou recebendo parametros de intervalo de codigos para CST ***
if pcount() < 10
   vIntervaloIni := vIntervaloFim := 0
endif

*** MsgAlert('NomeTabela='+vNomeTabela+'  CodigoTabela='+str(vCodigoTabela)+'    NomeVariavel='+vNomeVariavel+'   Intervalo ='+str( vIntervaloIni ) +' a '+ str(vIntervaloFim))
vNomeTabela    := left(vNomeTabela+space(20),20)
select TABELAS
set order to 1
seek vNomeTabela + str(vCodigoTabela,4)
if eof()
   vARQTEMP   := 'C:\TEMP\SQL'+NFeRandomico()

   if vIntervaloIni>=0 .and. vIntervaloFim>0
      copy to (vArqTemp) for vNomeTabela $ NomeTabela .and. TabCodigo>=vIntervaloIni .and. TabCodigo <= vIntervaloFim
   else
      copy to (vArqTemp) for vNomeTabela $ NomeTabela
   endif
   use (vArqTemp) alias TabTemp new exclusive
   go top
   vCampoGrid := "TABCODIGO;TABDESC"
   vTitGrid   := "C¢digo;Descri‡Æo Tabela ("+vDescTabela+")"

   GridPadrao()

   if lastkey()<>27
      if vTipoVariavel  == 'N'
         &vNomeVariavel := TABCODIGO
      else
         &vNomeVariavel := strzero(TABCODIGO, vTamVariavel)
      endif
      *** Obriga a busca para setar o arquivo com o resultado da busca ***
      vCodigoTabela     := TABCODIGO

      *** locate for alltrim(vNomeTabela)==alltrim(NomeTabela) .and. vCodigoTabela=TABCODIGO
      select TABELAS
      set order to 1
      seek vNomeTabela + str(vCodigoTabela,4)
      select TabTemp
   endif
endif
setcolor( CorAnt )
if vMostrarLinha
   @ vLinhaTela, vColunaTela say RESUMIDO
endif
if select ('TabTemp') > 0
   select TabTemp
   use
endif
** set filter to
if !empty ( ArqDBFAnt )
   select ( ArqDBFAnt )
endif
setcolor( CorAnt )
return(.t.)


Function CondicaoVinNFe(vCONDVIN)
*********************************
* Motra tabela de Condi‡Æo do VIN
*********************************
local CAP:=setcolor()
do case
   case vCONDVIN == 'R'
	     @ row(),col()+1 say 'Remarcado  '
   case vCONDVIN == 'N'
	     @ row(),col()+1 say 'Normal     '
   other
        save screen to TTRIB
        quadro('09','23','12','40',' Condi‡Æo do VIN ', 'W+/B')
        @ 10,24 prompt ' N-Normal     '
        @ 11,24 prompt ' R-Remarcado  '
        menu to vESC_VIN
        vVIN        := 'N'
        if vESC_VIN ==  2
           vVIN     := 'R'
        endif
        restore screen from TTRIB
        setcolor(CAP)
        return(.f.)
endcase
setcolor(CAP)
return(.t.)


Function DadosVeiculo()
*****************************************************
* Motra Tela com dados do Veiculo para emissÆo de NFe
*****************************************************
static GETLIST:={}
local TELA_ANT
save screen to TELA_ANT
quadro('05','00','21','78',' Dados do Ve¡culo ', 'W+/N' )
@ 06,01 say '    Tipo Opera‡Æo Äþ ' get vTIPOOP    pict '9'       valid(TabelasSPED('OPERACAOVEICNFE'   , vTIPOOP    , row(), col()+1, 'Tipo de Opera‡Æo', 'vTIPOOP' , 'C', 1, .t. ))
@ 07,01 say '           Chassi Äþ ' get vCHASSI                   valid(!empty(vCHASSI))
@ 08,01 say ' Cor na Montadora Äþ ' get vCOR
@ 09,01 say '    Descri‡Æo Cor Äþ ' get vDESC_COR
@ 10,01 say '   Potˆncia Motor Äþ ' get vPOTENCIA                 valid(val(vPOTENCIA)>0)
@ 11,01 say '       Cilindrada Äþ ' get vCM3       pict '9999'    valid(val(vCM3)>0)
@ 12,01 say '     Peso L¡quido Äþ ' get vPESO_LIQ  pict '999999'
@ 13,01 say '       Peso Bruto Äþ ' get vPESO_BRU  pict '999999'
@ 14,01 say '         N§ S‚rie Äþ ' get vSERIAL
@ 15,01 say '      Combust¡vel Äþ ' get vTIPO_COMB pict '99'      valid(TabelasSPED('COMBUSTIVELNFE'   , vTIPO_COMB , row(), col()+1, 'Combustivel', 'vTIPO_COMB'    , 'C', 2, .t. ))
@ 16,01 say '      N§ do Motor Äþ ' get vNRO_MOTOR
@ 17,01 say 'Cap.M x.Tra‡Æo(t) Äþ ' get vCMT       pict '999999999'
@ 18,01 say '  Distƒncia Eixos Äþ ' get vDIST_EIXO pict '9999'
@ 19,01 say '   Ano Modelo Fab Äþ ' get vANO_MOD   pict '9999'    valid(vANO_MOD>2008)
@ 20,01 say '   Ano Fabrica‡Æo Äþ ' get vANO_FAB   pict '9999'    valid(vANO_FAB>2008)

@ 07,40 say '  Tipo da Pintura Äþ ' get vTIPO_PINT pict '!'       valid(!empty(vTIPO_PINT))
@ 08,40 say '  Tipo do Ve¡culo Äþ ' get vTIPO_VEIC pict '99'      valid(TabelasSPED('TIPOVEICULONFE'   , vTIPO_VEIC , row(), col()+1, 'Tipo do Ve¡culo' , 'vTIPO_VEIC', 'C', 2, .t. ))
@ 10,40 say '  Esp‚cie Ve¡culo Äþ ' get vESP_VEIC  pict '9'       valid(TabelasSPED('ESPECIEVEICULONFE', vESP_VEIC  , row(), col()+1, 'Esp‚cie Ve¡culo' , 'vESP_VEIC' , 'C', 1, .t. ))
@ 11,40 say '     Condi‡Æo VIN Äþ ' get vVIN       pict '!'       valid(CondicaoVinNFe(vVIN))
@ 12,40 say ' Condi‡Æo Ve¡culo Äþ ' get vCOND_VEIC pict '9'       valid(TabelasSPED('CONDICAOVEICNFE'  , vCOND_VEIC , row(), col()+1, 'Condi‡Æo Ve¡culo', 'vCOND_VEIC', 'C', 1, .t. ))
@ 13,40 say '  C¢digo da Marca Äþ ' get vCOD_MOD   pict '999999'  valid(!empty(vCOD_MOD))
@ 16,40 say '    C¢digo da Cor Äþ ' get vCOD_COR   pict '99'      valid(TabelasSPED('CORVEICULONFE'    , vCOD_COR   , row(), col()+1, 'Cor do Ve¡culo'  , 'vCOD_COR'  , 'C', 2, .t. ))
@ 17,40 say 'Capac.M x.Lota‡Æo Äþ ' get vCAPAC_LOT pict '999'
@ 18,40 say '        Restri‡Æo Äþ ' get vRESTRICAO pict '9'       valid(TabelasSPED('RESTRICAONFE'     , vRESTRICAO , row(), col()+1, 'Restricao NFe'   , 'vRESTRICAO', 'C', 1, .t. ))
read
if lastkey()=27
   select (vFILEANT)
   restore screen from TELA_ANT
   return(.f.)
endif
return(.t.)



Function MLINE_Mudar_NFe(vAUTOMATICO)
**************************************************************************
* Pega os arquivos de NFe emitidos no periodo especifiado e remaneja para
* a pasta especificada
* vAUTOMATICO = Flag sinalizador para indicar se executa processo automatico
**************************************************************************
if !nivel('MUDARNFE')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

ArqAnt := dbf()
if pcount()=0
   vAUTOMATICO:=.F.
endif
if !vAUTOMATICO

   vDT_INI  := vDT_FIM :=ctod('')
   vCOD_CLI := vNFE    := 0
   vFILIAL  := vFILIAL_CLI := oFILIAL
   vSERIE   := space(3)
   
   if !FrmTelaNFeCancelada('Remanejamento ')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAnt)
      return(.f.)
   endif

   mCOD_CLI    := vCOD_CLI
   mFILIAL_CLI := vFILIAL_CLI

   if month(vDT_INI)<>month(vDT_FIM)
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAnt)
      MsgAlert('O mˆs do per¡odo deve se igual nas duas datas...')
      return(.f.)
   endif
   if vDT_INI>vDT_FIM
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()

      select (ArqAnt)
      MsgAlert('Per¡odo inv lido...')
      return(.f.)
   endif
   if month(vDT_INI) == month(date()) .and. year(vDT_INI) == year(date())
      MsgAlert('ATEN€ÇO !!! Esta opera‡Æo NÇO pode ser executada antes do final do mˆs...',' Remanejamento de NFe ')
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()
      return(.f.)
   endif
else
   vDT_INI := PriDiaMes( date() )
   vDT_FIM := UltDiaMes( date() )
endif
if !Abre_Arq()
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif
vDIR       := alltrim(setup->XMLNFE) + strzero(year(vDT_FIM),4) + '-' + left(Roti_Mes(vDT_FIM),3)

*** Atribue o formulario a Variavel para posterior uso ***
oForm      := FrmTelaNFeProcessamento('Copiando XML para Pasta do Mˆs')

oForm:oLblDataInicial:caption  := dtoc(vDT_INI)
oForm:oLblDataFinal:caption    := dtoc(vDT_FIM)
oForm:oLblPastaOrigem:caption  := alltrim(setup->XMLNFE)
oForm:oLblPastaDestino:caption := vDIR

ErrorDir   := MakeDir(vDIR)
if ErrorDir <> 0
   if ErrorDir=5
      MsgAlert('Pasta '+vDIR+' j  existe...')
   else
      ErrosDOS(ErrorDir, procname(), procline(), 'Dir '+vDIR )
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()
      return(.f.)
   endif
endif
aArqCli   := Array( ADir( alltrim(setup->XMLNFE)+'*.XML' ) )
aDirCli   := ADir( alltrim(setup->XMLNFE)+'*.XML', aArqCli )
TOTAL_ARQ := Len( aArqCli )
COPIADOS  := 0

oForm:oLblTotalArquivos:caption := strzero(TOTAL_ARQ,6)

for pqrs := 1 to Len( aArqCli )
    *** Mostra arquivos copiados ***
    oForm:oLblArquivosCopiados:caption := strzero(COPIADOS,6)
    cArq1 := aArqCli[pqrs]

    *** Mostra o Nome do arquivo que esta sendo copiado ***
    oForm:oLblNomeArquivo:caption := cArq1

    vDateArq := FileDate(alltrim(setup->XMLNFE)+cArq1)
    if vDateArq < vDT_INI .or.;
       vDateArq > vDT_FIM
       loop
    endif

    vORIGEM  := alltrim(setup->XMLNFE)+cArq1
    vDESTINO := vDIR+'\'+cArq1

    if upper('-ped-sit.xml') $ upper(cArq1) .or.;
       upper('-sit.xml'    ) $ upper(cArq1) .or.;
       upper('-ped-sta.xml') $ upper(cArq1) .or.;
       upper('-sta.xml'    ) $ upper(cArq1) .or.;
       upper('-ped-cce.xml') $ upper(cArq1)
       oForm:oLblMensagem:caption := 'Apagando arquivos de status de NFe '+vORIGEM+'...'
       fErase( vORIGEM )
       inkey(.1)
       limpa(24)
       MensRede()
       loop
    endif
    COPIADOS++
    TENTA := 0
    do while TENTA<100
       COPIADOS++
       oForm:oLblMensagem:Caption := 'Tamanho do Arquivo ('+strzero(FileCopy( vORIGEM, vDESTINO )/1024,7)+') Kbytes'
       inkey(0.4)
       if file( vDESTINO )
          fErase( vORIGEM )
          exit
       endif
       TENTA++
    enddo
    if TENTA>=100
       MsgAlert('ATEN€ÇO !!! Aconteceu um erro GRAVE na copia dos arquivos XML, reinicie TODAS as maquinas e execute '+;
                'o procedimento novamente...')
       *** Fecha arquivo de transacao da NFe ***
       ACBR_FechaNFe()
       return(.f.)
    endif
next
oForm:close()
MsgAlert('Opera‡Æo para mover aquivos de NFe para pasta especifica concluida com sucesso !!!')
return(.t.)



Function MLINE_Enviar_NFe_Contador(vAUTOMATICO)
**************************************************************************
* Pega os arquivos de NFe emitidos no periodo especifiado e copia para \CONTADOR
**************************************************************************
if !nivel('CONTADOR')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

ArqAnt := dbf()
if pcount()=0
   vAUTOMATICO := .F.
endif

vDT_INI  := vDT_FIM :=ctod('')
vCOD_CLI := vNFE    := 0
vFILIAL  := vFILIAL_CLI := oFILIAL

if !FrmTelaNFeCancelada('Copiar Arquivos para Contador')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAnt)
   return(.f.)
endif

mCOD_CLI    := vCOD_CLI
mFILIAL_CLI := vFILIAL_CLI

if vDT_INI > vDT_FIM .or. month(vDT_INI) <> month(vDT_FIM)
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select (ArqAnt)
   MsgAlert('Per¡odo inv lido...')
   return(.f.)
endif
if !Abre_Arq()
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   return(.f.)
endif
vDIR     := "\CONTADOR\"
oForm    := FrmTelaNFeProcessamento('Copiando ARQUIVOS XML para Contador')

oForm:oLblDataInicial:caption  := dtoc(vDT_INI)
oForm:oLblDataFinal:caption    := dtoc(vDT_FIM)
oForm:oLblPastaOrigem:caption  := alltrim(setup->XMLNFE)
oForm:oLblPastaDestino:caption := vDIR

ErrorDir := MakeDir(vDIR)
if ErrorDir <> 0
   if ErrorDir == 5
      MsgAlert('Pasta '+vDIR+' j  existe...')
   else
      ErrosDOS(fError(), procname(), procline(), 'Dir '+vDIR )
      *** Fecha arquivo de transacao da NFe ***
      ACBR_FechaNFe()
      return(.f.)
   endif
endif

*** Deletando arquivos da pasta C:\CONTADOR ***
aArqCli   := Array( ADir( '\CONTADOR\*.XML' ) )
aDirCli   := ADir( '\CONTADOR\*.XML', aArqCli )
for pqrs  := 1 to Len( aArqCli )
    cArq1 := aArqCli[pqrs]
    oForm:oLblMensagem:caption := 'Apagando arquivos NFe da pasta CONTADOR ('+cArq1+')...'
    fErase( cArq1 )
    inkey(.1)
next

vDIR_XML  := alltrim(setup->XMLNFe)

*** Verifica se o XML ja foi transferido ***
if month(vDT_INI) <> month(date())
   vDIR_XML := alltrim(setup->XMLNFE) + strzero(year(vDT_INI),4)+'-'+left(Roti_Mes(vDT_INI),3)+"\"
endif

vARQ_XML  := vDIR_XML + "*.XML"
aArqCli   := Array( ADir( vARQ_XML ) )
aDirCli   := ADir( vARQ_XML, aArqCli )

TOTAL_ARQ := Len( aArqCli )
COPIADOS  := 0

*** Mostra o total de arquivos copiados ***
oForm:oLblTotalArquivos:caption := strzero(TOTAL_ARQ,6)

oForm:oLblMensagem:Caption := 'Copiando arquivos para destino...'
for pqrs := 1 to Len( aArqCli )
    *** Mostra arquivos copiados ***
    oForm:oLblArquivosCopiados:caption := strzero(COPIADOS,6)
    cArq1 := aArqCli[pqrs]

    *** Mostra o Nome do arquivo que esta sendo copiado ***
    oForm:oLblNomeArquivo:caption := cArq1
    vDateArq := FileDate( vDIR_XML + cArq1)
    if vDateArq < vDT_INI .or.;
       vDateArq > vDT_FIM
       loop
    endif

    vORIGEM  := vDIR_XML + cArq1
    vDESTINO := vDIR     + cArq1

    if '-ped-sit.xml' $ cArq1 .or.;
       '-sit.xml'     $ cArq1 .or.;
       '-ped-sta.xml' $ cArq1 .or.;
       '-sta.xml'     $ cArq1 .or.;
       '-ped-cce.xml' $ cArq1
       oForm:oLblMensagem:caption := 'Apagando arquivos de status de NFe '+vORIGEM+'...'
       fErase( vORIGEM )
       inkey(.1)
       MensRede()
       loop
    endif
    
    COPIADOS++
    oForm:oLblMensagem:Caption := 'Tamanho do Arquivo ('+strzero(FileCopy( vORIGEM, vDESTINO )/1024,7)+') Kbytes'
    inkey(0.4)
next
oForm:close()

MsgAlert('Opera‡Æo para copiar aquivos de NFe para pasta CONTADOR concluida com sucesso !!!')
return(.t.)




Function ACBR_EnviarEmailAutomatico()
***************************************
* Envia email automatico apos gerar NFe
***************************************

*** Busca email da transportadora ***
EMAIL_TRANSP :=.f.
if nf->COD_TRAN>0
   p_transp(nf->COD_TRAN, nf->FILIAL_TRA, .f.)
   if !empty(transp->EMAIL_TRAN)
      EMAIL_TRANSP=.t.
   endif
endif

vARQ_XML    := alltrim(setup->XMLNFE) + alltrim(nf->CHAVENFE)+"-nfe.xml"

*** Verifica se o XML ja foi transferido ***
if month(nf->DT_EMIS) <> month(date())
   vARQ_XML := alltrim(setup->XMLNFE) + strzero(year(nf->DT_EMIS),4)+'-'+left(Roti_Mes(nf->DT_EMIS),3) + '\' + nf->CHAVENFE+"-nfe.xml"
endif

if !file(vARQ_XML)
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

select NF
if reglock(.f.)
   AuditAlt( procname() )
   replace JA_EMAIL   with .t.     ,;
           DT_EMAIL   with date()  ,;
           QUEM_EMAIL with vUSUARIO
   dbcommit()
   if EMAIL_TRANSP
      ACBR_EnviarNFeEmail(alltrim(cadcli->EMAIL), vARQ_XML, 1, alltrim(transp->EMAIL_TRAN))
   else
      ACBR_EnviarNFeEmail(alltrim(cadcli->EMAIL), vARQ_XML, 1, alltrim(cadcli->EMAILCC))
   endif
   nf->( dbunlock() )
endif
return(.t.)



Function ACBR_EnviarEmailAutomaticoCCe()
***************************************
* Envia email automatico apos gerar CCe
***************************************

if !file( vARQ_CCe )
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

select CORRECAO
if reglock(.f.)
   AuditAlt( procname() )
   replace JA_EMAIL   with .t.     ,;
           DT_EMAIL   with date()  ,;
           QUEM_EMAIL with vUSUARIO
   dbcommit()
   ACBR_EnviarNFeEmail(alltrim(cadcli->EMAIL), vARQ_CCE, 0, alltrim(cadcli->EMAILCC))
   correcao->( dbunlock() )
endif
return(.t.)


Function ACBR_GerarINICCe(oNUMERO, oSERIE, oORIGEM )
*************************************************
* Gerar um Arquivo TXT no formato de arquivos INI
* oNUMERO -> Numero da NF gravada no arquivo
* oSerie  -> Serie da NF gravada
* oOrigem -> Origem da Venda (VND, OS, PED)
* oREIMPRESSAO -> .F. se NAO for reimpressao (gera nova NFE e XML)
*                 .T. se FOR reimpressao (NAO gera nova NFE e XML)
* VERSAO PARA XML 2.0
*************************************************

*** Desativa as chamadas em Backgroud ***
HB_BackGroundDel( nTask )

*** Cria protocolo de linha do arquivo texto ***
FimLin    := chr( 13 ) + chr( 10 )
ARQCCe    := "C:\TEMP\CCE"
VetorStru := {}
aadd(VetorStru, {'LINHACCE' , 'C' , 900, 0 })

if !TrataErroCriacao( ARQCCe, procname(), procline(), 'D' )
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

use (ARQCCe) alias DBFCCe new exclu

select NF
if !reglock(.f.)
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   select DBFCCe
   use
   select (ArqAntNFe)
	return(.f.)
endif

*** Busca o numero do LOTE NFe ***
select ARQUIVOS
set exact on
seek 'CCELOTE'
reglock(.f.)
replace ULT_COD with ULT_COD + 1
dbcommit()
vLOTE := ULT_COD
arquivos->( dbunlock() )
set exact off
p_estado(setup->ESTEMP, .f.)

select CORRECAO

*** Identificacao do documento ***
GravaLinhaCCe( "[CCE]")
GravaLinhaCCe( "idLote="  + alltrim(str(vLOTE)))

vCONTADOR := 1
GEROU     := .f.
vCORRECAO := ''
do while !eof() .and. nf->NUMERO == correcao->NF .and. vCONTADOR<6
   vCAMPO := 'MOT_CORR' + alltrim(str(vCONTADOR))
   if !empty(&vCAMPO)
      vCORRECAO += alltrim(&vCAMPO)+'-'
   endif
   vCONTADOR++
enddo

if empty(vCORRECAO)
   MsgAlert('NÆo foi informado nenhuma corre‡Æo a ser feita...')
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   select DBFCCe
   use
   select (ArqAntNFe)
	return(.f.)
endif

GravaLinhaCCe( "[EVENTO001]" )
GravaLinhaCCe( "chNFe="      + nf->CHAVENFE )
GravaLinhaCCe( "cOrgao="     + estados->IBGE_UF )
GravaLinhaCCe( "CNPJ="       + NoMask(setup->CGCEMP) )
GravaLinhaCCe(	"dhEvento="   + dtoc(date())+time())

replace correcao->SEQUENCIA with correcao->SEQUENCIA + 1
GravaLinhaCCe(	"nSeqEvento=" + alltrim(str(correcao->SEQUENCIA)))
GravaLinhaCCe(	"xCorrecao="  + alltrim(vCORRECAO))

select DBFCCe
go top

vLinhaINI := ''
do while !eof()
   *** grava comandos na Variavel INI ***
   vLinhaINI += alltrim(DBFCCe->LinhaCCe) + FimLin
   skip
enddo
inkey(.5)

select DBFCCe
use

if 'WAGNER ' $ vUSUARIO .or. 'MICROLINE' $ vUSUARIO
    FrmMsgErro( vLinhaINI )
endif

*** Cria XML e enviar ***
ACBR_CriarXMLEnviarCCe(vLinhaINI, vLOTE, 0)
select (ArqAntNFe)
return(.t.)




Function ACBR_GerarIniNFeV2_00(oNUMERO, oSERIE, oORIGEM, oREIMPRESSAO)
*************************************************
* Gerar um Arquivo TXT no formato de arquivos INI
* oNUMERO -> Numero da NF gravada no arquivo
* oSerie  -> Serie da NF gravada
* oOrigem -> Origem da Venda (VND, OS, PED)
* oREIMPRESSAO -> .F. se NAO for reimpressao (gera nova NFE e XML)
*                 .T. se FOR reimpressao (NAO gera nova NFE e XML)
* VERSAO PARA XML 2.0
*---------------------------------------------------------------------------------
* Conforme NOTA TECNICA 0002/2011 e com a versao do monitor 0.6.2.b (15/06/2011)
* quando o sistema estiver gerando NFe em homologacao o monitor ira trocar auto
* maticamente 3 dados para atender a NT.
* NOME DESTINATARIO = NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL
* CNPJ DESTINATARIO = 99.999.999/0001-91 - Para opera‡äes no Brasil e vazio para opera‡oes no exterior
* IE DESTINATARIO   = Conteudo vazio
*************************************************

*** Busca Layout da NF para pegar ordem de impressao ***
if !LayoutNF(vCOMPANY)
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   return(.f.)
endif

*** Desativa as chamadas em Backgroud ***
HB_BackGroundDel( nTask )

*** Cria protocolo de linha do arquivo texto ***
FimLin    := chr( 13 ) + chr( 10 )
ARQNF     := "C:\TEMP\ININFE"+NFeRandomico()
VetorStru := {}
aadd(VetorStru, {'LINHANFE' , 'C' , 900, 0 })

if !TrataErroCriacao( ARQNF, procname(), procline(), 'D' )
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

use (ARQNF) alias DBFNFe new exclusive

select NF
if !reglock(.f.)
   AuditAlt( procname() )

   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
	return(.f.)
endif
set exact off

*** Verificar ate aqui o que deve ser retirado em producao ***
igual_var()
p_cfop(vCFOP,.f.)
TabelasSPED('MODALIDADEPGTOVENDA', vMODPGTO  , row(), col()+1, 'MODALIDADE', 'vMODPGTO'  , 'N', 0, .f.)

ImprimeBaseCalculo := .t.
if vCRT == 1
   *** Se for Super Simples ZERA ICMS ***
   ImprimeBaseCalculo := .f.
   if setup->RAMO=14 .and. cfop->ICMS_SUBST>0
      *** Imprime base para Simples Nacional abaixo sublimite somente se :
      *** for Industria e CFOP tiver calculo de substituicao tributaria ***
      ImprimeBaseCalculo := .t.
   endif
endif

*** Guarda percentual de retencao do CFOP ***
vPERC_RET     := cfop->PERC_RET

*** Se for reimpressao mostra tela da NF ***
if oREIMPRESSAO
   vULT_NF    := NUMERO
   vDATA_NF   := DT_EMIS
   vHORA_EMIS := HORA
   vDT_SAIDA  := DT_SAIDA
   vCLIENTE   := CONSUM
   vIE        := iif(PESSOA == 'F', 'ISENTO', IE)
   vEND       := iif(PESSOA == 'F', END_RES , END_COM)
   vNRO       := iif(PESSOA == 'F', NRO_RES , NRO_COM)
   vFONE      := iif(PESSOA == 'F', FONE_RES, FONE_COM)
   vQUANTEMB  := QUANTPROD
   vVLR_ACESS := VLR_ACESS
   Tela_NF('ReimpressÆo de NF ')
   select NF
   vHORA      := vHORA_EMIS
   repl_var()
endif

*** Identificacao do documento ***

/*
Dica de configuração para que o componente gere o XML no modelo e versão correta:
ACBrNFe.Configuracoes.Geral.ModeloDF := moNFe;
ACBrNFe.Configuracoes.Geral.VersaoDF := ve200;
No exemplo acima o XML a ser gerado vai ser o da NF-e na versão 2.00
Valores aceitos pela propriedade ModeloDF: moNFe e moNFCe.
Quando o modelo for moNFe, os valores aceitos pela propriedade VersaoDF são: ve200 e ve310.
Quando o modelo for moNFCe, os valores aceitos pela propriedade VersaoDF são: ve300 e ve310.
*/

GravaLinhaNFe( "[Identificacao]" )
GravaLinhaNFe( "NaturezaOperacao="+cfop->DESCRICAO )
GravaLinhaNFe( "Modelo=55" )       // 55=NFe   65=NFCe
GravaLinhaNFe( "Serie="      +        iif(nf->SERIE='NFE','1','900'))
GravaLinhaNFe( "Codigo="     +            nf->NFE_RAND)
GravaLinhaNFe(	"Numero="     +  ltrim(str(nf->NUMERO,9)) )
GravaLinhaNFe(	"Emissao="    +       dtoc(nf->DT_EMIS ))
GravaLinhaNFe(	"Saida="      + iif(!empty(nf->DT_SAIDA),dtoc(nf->DT_SAIDA),'') )
GravaLinhaNFe(	"Tipo="       +        iif(nf->TIPO='S',"1","0") )
GravaLinhaNFe(	"FormaPag="   +    strzero(nf->IND_PAG,1) )    // 0=A Vista  1=A Prazo  2=Outros

*** Criar controle da Finalidade da NFe ****
GravaLinhaNFe(	"finNFe="     + nf->FINALNFE )              // 1=Normal   2=Complementar  3=de Ajuste  4=Devolucao/Retorno
if !empty(NoMask(nf->HORA))
   GravaLinhaNFe(	"hSaiEnt=" + nf->HORA )                  // Hora da saida/entrada
endif

GravaLinhaNFe(	"indFinal="   + strzero(nf->indFINAL,1))    // Consumidor Final -> 0=NÆo 1=Sim
GravaLinhaNFe(	"indPres="    + strzero(nf->indPRES ,1))    // 0=NÆo se aplica  1=Presencial  2=NÆo Presencial (Internet)  3=NÆo Presencial(telemarketing)  4=NFCe   9=NÆo Presencial
GravaLinhaNFe(	"procEmi=0" )                               // 0=Emissao NFe com aplicativo do contribuinte

*** Informacoes da Contingencia ***
if !empty(nf->DTCONTNFE)
   GravaLinhaNFe( "dhCont="  + dtoc(nf->DTCONTNFE) )        // Data e hora da contingencia
   GravaLinhaNFe( "xJust="   + nf->MOTCONTNFE )             // Motivo da contingencia
endif

*** Informacao das NF referenciadas (devolucao por exemplo)
if nf->CUPOM>0
   *** Informa‡äes do Cupom Fiscal ***
   GravaLinhaNFe( "[NFRef001]")                             // Relacao de NFs canceladas/devolvidas
   GravaLinhaNFe( "Tipo=ECF")                               // Modelo do Cupom Fiscal
   GravaLinhaNFe( "ModECF=2D")                              // Modelo do Cupom Fiscal
   GravaLinhaNFe( "nECF="    + strzero(nf->INRO_ECF,3) )    // Numero sequencial da IF
   GravaLinhaNFe( "nCOO="    + strzero(nf->CUPOM   ,6) )    // Numero sequencial do CUPOM
endif
if !empty(nf->CHAVE_NFR)
   GravaLinhaNFe( "[NFref001]" )
   GravaLinhaNFe( "refNFe="   + nf->CHAVE_NFR )             // Nota Fiscal Referenciada para devolucao
   *** Linhas abaixo quando NAO for NFe ***
   *** GravaLinhaNFe( "cUF="     + nf->UF_NFR    )          // UF do emitente da NF
   *** GravaLinhaNFe( "AAMM="    + nf->AAMM_NFR  )          // Ano e mes da emissao NF
   *** GravaLinhaNFe( "CNPJ="    + nf->CNPJ_NFR  )          // do Emitente da NF
   *** GravaLinhaNFe( "Modelo="  + nf->MOD_NFR   )          // Modelo da NF
   *** GravaLinhaNFe( "Serie="   + nf->SERIE_NFR )          // Serie da NF
   *** GravaLinhaNFe( "nNF="     + nf->NF_NFR    )          // Numero da NF
endif

*** Dados do Emitente ***
p_cidade(setup->CIDEMP    , .f., setup->ESTEMP)
vUF_IBGE_EMIT := cidades->IBGE_CID                          // Usada na UF TAG de servicos
p_paises(cidades->COD_PAIS, .f.)

GravaLinhaNFe( "[Emitente]" )
GravaLinhaNFe( "CNPJ="       +                     NoMask(setup->CGCEMP    ))
GravaLinhaNFe( "IE="         +                     NoMask(setup->IEEMP     ))
GravaLinhaNFe( "Razao="      +        TrocaParse( alltrim(setup->RAZSOC_NFE)) )
GravaLinhaNFe( "Fantasia="   +        TrocaParse( alltrim(setup->DESCRI    )) )
GravaLinhaNFe( "Fone="       +        left(NoMask(alltrim(setup->FONEEMP   )),10) )
GravaLinhaNFe( "CEP="        +                     NoMask(setup->CEPEMP    ))
GravaLinhaNFe( "Logradouro=" + alltrim(TrocaParse(alltrim(setup->END_NFE   ))))
GravaLinhaNFe( "Numero="     +                    strzero(setup->NROEMP,6  ))
GravaLinhaNFe( "Complemento="+        TrocaParse( alltrim(setup->COMPEMP   )) )
GravaLinhaNFe( "Bairro="     +                 TrocaParse(setup->BAIRROEMP ))
GravaLinhaNFe( "CidadeCod="  + cidades->IBGE_CID )
GravaLinhaNFe( "Cidade="     + setup->CIDEMP )
GravaLinhaNFe( "UF="         + setup->ESTEMP )
GravaLinhaNFe( "PaisCod="    + ltrim(str(cidades->COD_PAIS)) )
GravaLinhaNFe( "Pais="       + paises->NOME )
if !empty(setup->IMUNICEMP)
   GravaLinhaNFe( "IM="      +                     NoMask(setup->IMUNICEMP ))
endif
GravaLinhaNFe( "CNAE="       +                     NoMask(setup->CNAEEMP   ))
GravaLinhaNFe( "CRT="        + strzero(nf->CRT_A,1) )

*** Dados do Destinatario ***
if nf->COD_CLI>0
   p_cliente(nf->COD_CLI  , nf->FILIAL_CLI, .f. )
endif
p_cidade(cadcli->CIDADE   , .f., cadcli->ESTADO)
p_estado(cadcli->ESTADO   , .f. )
p_paises(cidades->COD_PAIS, .f. )
vCLIENTE     := alltrim(cadcli->CLIENTE)
if nf->PESSOA='F'
   vDOCTO1   := cadcli->CPF
   vDOCTO2   := cadcli->RG
   vENDERECO := cadcli->END_RES
   vNRO_END  := cadcli->NRO_RES
   vFONE     := cadcli->FONE_RES
   vCOMPLEM  := cadcli->COMP_RES
else
   vDOCTO1   := cadcli->CGC
   vDOCTO2   := cadcli->IE
   vENDERECO := cadcli->END_COM
   vNRO_END  := cadcli->NRO_COM
   vFONE     := cadcli->FONE_COM
   vCOMPLEM  := cadcli->COMP_COM
endif

GravaLinhaNFe( "[Destinatario]" )

if 'EXTERIOR' $ vCIDADE
   *** Gerar TAGs sem conteudo ***
   GravaLinhaNFe( "CNPJ=")
   GravaLinhaNFe( "IE=" )
else
   GravaLinhaNFe( "CNPJ="     + NoMask(vDOCTO1) )
   if nf->PESSOA='J'
      if !'ISENTO' $ upper(vDOCTO2)
         GravaLinhaNFe( "IE="    + NoMask(vDOCTO2) )
      else
         if setup->DT_ATUAL > ctod('19/03/2013')
            GravaLinhaNFe( "IE=ISENTO" )
         endif
      endif
   else
      if empty(cadcli->PROD_RURAL)
         *** Desabilitado devido a Nota Tecnica 04/2011 ***
         if setup->DT_ATUAL > ctod('19/03/2013')
            GravaLinhaNFe( "IE=ISENTO" )
         endif
      else
         GravaLinhaNFe( "IE=" + Nomask(cadcli->PROD_RURAL))
      endif
   endif
endif

GravaLinhaNFe( "NomeRazao="   + TrocaParse(vCLIENTE) )
GravaLinhaNFe( "Fone="        + left(alltrim(NoMask(vFONE)),10) )
GravaLinhaNFe( "CEP="         + NoMask(vCEP) )
GravaLinhaNFe( "Logradouro="  + TrocaParse(vENDERECO) )
GravaLinhaNFe( "Numero="      + strzero(vNRO_END,6) )
GravaLinhaNFe( "Complemento=" + TrocaParse(vCOMPLEM) )
GravaLinhaNFe( "Bairro="      + TrocaParse(vBAIRRO) )
GravaLinhaNFe( "CidadeCod="   + cidades->IBGE_CID )
GravaLinhaNFe( "Cidade="      + vCIDADE )
GravaLinhaNFe( "UF="          + vESTADO )
GravaLinhaNFe( "PaisCod="     + strzero(cidades->COD_PAIS,4) )
GravaLinhaNFe( "Pais="        + paises->NOME )
if !empty(cadcli->SUFRAMA)
   GravaLinhaNFe(	"ISUF="     + NoMask(cadcli->SUFRAMA) )
endif
if !empty(cadcli->EMAIL)
   GravaLinhaNFe(	"Email="    + cadcli->EMAIL )
endif
Mostrar := .f.
if Mostrar
   GravaLinhaNFe( "[Retirada]" )
   if !empty(CNPJ)
      GravaLinhaNFe( "CNPJ="  + NoMask(vDOCTO1) )
   else
      GravaLinhaNFe( "CPF="   + NoMask(vDOCTO1) )
   endif
   GravaLinhaNFe( "xLgr="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "nro="      + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xCpl="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xBairro="  + NoMask(vDOCTO1) )
   GravaLinhaNFe( "cMun="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xMun="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "UF="       + NoMask(vDOCTO1) )

   GravaLinhaNFe( "[Entrega]" )
   GravaLinhaNFe( "CNPJ="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xLgr="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "nro="      + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xCpl="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xBairro="  + NoMask(vDOCTO1) )
   GravaLinhaNFe( "cMun="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xMun="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "UF="       + NoMask(vDOCTO1) )
endif

*** Gerar Itens da NFe ***
select ItemNF
set order to 1
set exact off
seek oFILIAL + str(oNUMERO,9) + oSERIE
set exact on

if eof()
   MsgAlert('NÆo foram encontrados Itens para NFe '+strzero(oNUMERO,9)+'...')
endif

ContaProd      := 1
vVLR_PIS_ISS   := vVLR_COFINS_ISS := vVLR_IPI     := 0
vCOMSUBST      := vCOMISEN        := vCOMSUSP     := .f.
vBRUTO_SERV    := vDESC_SERV      := vBRUTO_PROD  := vDESC_PROD := 0
vSUSPENSAO_PIS := vSUSPENSAO_COF  := vDIFERIMENTO := .F.
do while !eof() .and. oFILIAL = FILIAL .and. oNUMERO=NUMERO .and. oSERIE=SERIE
   Igual_Var()
   *** Busca o CFOP do item ***
   p_cfop(vCFOP_ITEM,.f.)

   select GERAL
   set order to 8
   seek str(vCODIGO,6)
   if eof()
      select ItemNF
      skip
      loop
   endif
	vCAT_RED     := CAT_RED
   *** 09/04/2013 - Considerar o trecho abaixo pelo CST/CSOSN e nÆo pelo campo de tributacao ***
   if SUBST     == 'S'
      vCOMSUBST := .t.
   endif
   if TRIBFEST  == 'S' .and. cfop->FORAEST == 'S'
      vCOMSUBST := .f.
   endif
   if ISENTO    == 'S'
      vCOMISEN  := .t.
   endif
   if SUSPENSAO == 'S'
      vCOMSUSP  := .t.
   endif

	p_reducao(vCAT_RED,.f.)
	vPERC_RED    := iif(reducao->PERC=1, 0 , reducao->PERC)

   *** verifico se possui Descricao Complementar ***
   select GERALTXT
   set order to 1
   seek oFILIAL + vNROVENDA + str(vCODIGO,6) + str(vREG,9)

   TEM_COMPLEMENTO    :=.F.
   if !eof()
      TEM_COMPLEMENTO :=.T.
   endif

   select ItemNF
   *** Dados do produto ***
   do case
      case layouts->NFCOMCOD == 'S'
           vCODIGO_PRODUTO   := ltrim(str(ItemNF->CODIGO,6))

      case layouts->NFCOMCOD == 'F' .or. layouts->NFCOMCOD == ' '
           vCODIGO_PRODUTO   := ItemNF->COD_FABRI

      case layouts->NFCOMCOD == 'O'
           vCODIGO_PRODUTO   := geral->COD_ORIG                // Pego cadastro Produto pois nÆo tem o campo

      otherwise
           vCODIGO_PRODUTO   := ltrim(str(ItemNF->CODIGO,6))
   endcase

   GravaLinhaNFe( "[Produto"       + strzero(ContaProd,3)+"]")
   GravaLinhaNFe( "Codigo="        + vCODIGO_PRODUTO )
   if !Tem_Complemento
      GravaLinhaNFe( "Descricao="  + TrocaParse(ItemNF->DISCRIM) )
   else
      *** Descricao Complementar do produto ***
      vDESC_COMP := ''
      LIN_MEMO   := mlcount(geraltxt->MEMO, 450)
      for IJKL = 1 to LIN_MEMO
          if IJKL = 1
             vDESC_COMP := substr(alltrim(memoline(geraltxt->MEMO, 450, IJKL, .F.)),1,120)
          endif
      next
      GravaLinhaNFe( "Descricao="+vDESC_COMP)
   endif

   CodigoBarra    := .f.
   vTamanhoCodigo := len(alltrim(vCOD_FABRI))
   if vTamanhoCodigo=13 .and. left(vCOD_FABRI,2)='78'
      for XYZ := 1 to vTamanhoCodigo
          if type(substr(vCOD_FABRI,XYZ,1))<>'N'
             CodigoBarra := .f.
             exit
          endif
      next
      CodigoBarra := .t.
   endif
   *** Verificar quando tem EAN tem que ter unidade tributavel do EAN ***
   if CodigoBarra
      GravaLinhaNFe( "EAN="      + alltrim(ItemNF->COD_FABRI) )
      GravaLinhaNFe( "cEANTrib=" + alltrim(ItemNF->COD_FABRI) )
   endif

   if !empty(geral->COD_NCM)
      * if geral->MODALID=9               // Servicos
      *    GravaLinhaNFe( "NCM=99" )      // se for exportacao OBRIGATORIO NCM
      * else
         GravaLinhaNFe( "NCM="      + NoMask(geral->COD_NCM) )         // se for exportacao OBRIGATORIO NCM
      * endif
   endif

   TemDesconto    := .f.
   vDESC_ITEM     := vSOMA_DESC := 0
   *** Verifica abaixo todos os possiveis descontos da NFe ***
   p_cfop(nf->CFOP,.f.)
   if nf->VLR_DESC + nf->VLRDESCMO + nf->VLR_ALC + iif(cfop->DED_ICMS='S', nf->VLR_ISEN, 0 ) + nf->VLR_RET + nf->VLR_IRRF > 0
      TemDesconto := .t.
      vDESC_ITEM  := ItemNF->ALC_ITEM  + iif(ItemNF->DED_ISEN='S', ItemNF->ISEN_ITEM, 0 ) + ItemNF->RET_ITEM
   endif
   *** Variavel para mostrar informacoes complementares ***
   vSOMA_DESC     += vDESC_ITEM + ItemNF->VLR_DESC

   vCFOP_ITEM     := left( NoMask(ItemNF->CFOP_ITEM),4)
   vUNIDADE       := iif( empty(ItemNF->UND), 'UN', ItemNF->UND)
   vQUANT         := ItemNF->QUANT
   vVLR_UNITARIO  := ItemNF->VLR_LIQ
   vVLR_TOTAL     := ItemNF->VLR_TOTAL  // - vDESC_ITEM

   GravaLinhaNFe( "CFOP="                + ltrim(vCFOP_ITEM) )
   GravaLinhaNFe( "Unidade="             + ltrim(vUNIDADE) )
   GravaLinhaNFe( "uTrib="               + ltrim(vUNIDADE) )
   GravaLinhaNFe( "qTrib="               + ltrim(str(vQUANT       , 11  , vDEC_EST)) )
   GravaLinhaNFe( "Quantidade="          + ltrim(str(vQUANT       , 11  , vDEC_EST)) )
   GravaLinhaNFe( "ValorUnitario="       + ltrim(str(vVLR_UNITARIO, 15  , 5)) )
   GravaLinhaNFe( "ValorTotal="          + ltrim(str(vVLR_TOTAL   , 15  , 2)) )
   GravaLinhaNFe( "ValorDesconto="       + ltrim(str(vDESC_ITEM   , 15  , 2)) )

   if left(COD_FABRI,3)='MAO'           // .and. VLR_DESC > 0   Desativei para somar TODOS OS ITENS
      vBRUTO_SERV +=  ItemNF->VLR_UNIT * ItemNF->QUANT
      vDESC_SERV  += (ItemNF->VLR_DESC * ItemNF->QUANT) + vDESC_ITEM
   endif
   if left(COD_FABRI,3)<>'MAO'          // .and. VLR_DESC > 0   Desativei para somar TODOS OS ITENS
      vBRUTO_PROD +=  ItemNF->VLR_UNIT * ItemNF->QUANT
      vDESC_PROD  += (ItemNF->VLR_DESC * ItemNF->QUANT) + vDESC_ITEM
   endif

   if ItemNF->ACESS_ITEM>0
      GravaLinhaNFe( "vOutro="          + ltrim(str(ItemNF->ACESS_ITEM  ,15,2)) )    // Outras Despesas acessorias
   endif

   if ItemNF->FRETE_ITEM>0
      GravaLinhaNFe( "vFrete="          + ltrim(str(ItemNF->FRETE_ITEM,15,2)) )    // Frete rateado no item
   endif

   GravaLinhaNFe( "indTot="             + ltrim(str(ItemNF->SOMA_ITEM)) )         // 0=Item nÆo compoe o vlr total NFe  1=Item compoe o valor da NFe
   if !empty(nf->PED_COMPRA)
      GravaLinhaNFe( "xPed= "           + nf->PED_COMPRA)                         // Numero do pedido de compra
      GravaLinhaNFe( "nItemPed="        + strzero(ItemNF->ITEMPED,6) )            // Item do pedido de compra
   endif

   *** Impostos Federais ***
   GravaLinhaNFe( "vTotTrib="           + ltrim(str(ItemNF->IMP_ITEM,15,2)) )

   *** Descricao Complementar do produto ***
   if TEM_COMPLEMENTO
      vDESC_COMP := ''
      LIN_MEMO   := mlcount(geraltxt->MEMO, 450)
      for IJKL := 1 to LIN_MEMO
          if IJKL == 1
             vDESC_COMP += substr(alltrim(memoline(geraltxt->MEMO, 450, IJKL, .F.)),120)
          else
             vDESC_COMP += alltrim(memoline(geraltxt->MEMO, 450, IJKL, .F.))
          endif
      next
      GravaLinhaNFe( "infAdProd="        + vDESC_COMP)
   endif

	Mostrar := .f.
	if Mostrar
      *** Dados da Importacao de produtos (OPCIONAL) ***
      GravaLinhaNFe( "NumeroDI="             + vUND )       //  Nro Docto Importacao
      GravaLinhaNFe( "DataRegistroDI="       + vUND )       //  Data do documento
      GravaLinhaNFe( "LocalDesembaraco="     + vUND )       //
      GravaLinhaNFe( "UFDesembaraco="        + vUND )       //
      GravaLinhaNFe( "DataDesembaraco="      + vUND )       //
      GravaLinhaNFe( "CodigoExportador="     + vUND )       //

      *** Dados da Importacao de produtos (OPCIONAL) ***
      for ContaAdi=1 to TotalAdicao
          GravaLinhaNFe( "LADI"              + strzero(ContaProd,3)+Strzero(ContaAdi,3)+"]")
          GravaLinhaNFe( "NumeroAdicao="     + vUND )
          GravaLinhaNFe( "CodigoFabricante=" + vUND )    // Codigo do fabricante estrangeiro no sistema
          GravaLinhaNFe( "DescontoADI="      + vUND )
       next
   endif

   *** Detalhamento especifico de VEICULOS ***
   if !empty(GeralTXT->CHASSI)
	   GravaLinhaNFe( "[Veiculo"         + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "tpOP="            + GeralTXT->TIPOOP )                   //  Tipo Operacao 1-Venda Concessionaria 2-Faturamento Direto 3-Venda Direta 0-Outros
      GravaLinhaNFe( "chassi="          + GeralTXT->CHASSI )                   //  Data do documento
      GravaLinhaNFe( "cCor="            + GeralTXT->COR )                      //  Codigo da Cor de cada montadora
      GravaLinhaNFe( "xCor="            + GeralTXT->DESC_COR )                 //  Descricao da cor
      GravaLinhaNFe( "pot="             + GeralTXT->POTENCIA )                 //  Potencia
      GravaLinhaNFe( "Cilin="           + GeralTXT->CM3 )                      //  Cilindrada
      GravaLinhaNFe( "pesoL="           + ltrim(str(GeralTXT->PESO_LIQ,9)) )   //  Peso liquido
      GravaLinhaNFe( "pesoB="           + ltrim(str(GeralTXT->PESO_BRU,9)) )   //  Peso Bruto
      if !empty(GeralTXT->SERIAL)
         GravaLinhaNFe( "nSerie="       + GeralTXT->SERIAL )                   //  Numero de Serie
      endif
      GravaLinhaNFe( "tpComb="          + GeralTXT->TIPO_COMB )                //  Tipo de combustivel
      if !empty(GeralTXT->NRO_MOTOR)
         GravaLinhaNFe( "nMotor="       + GeralTXT->NRO_MOTOR )                //  Numero do motor
      endif
      if !empty(GeralTXT->DIST_EIXO)
         GravaLinhaNFe( "dist="         + GeralTXT->DIST_EIXO )                //  Distancia entre eixos
      endif
      GravaLinhaNFe( "anoMod="          + ltrim(str(GeralTXT->ANO_MOD,4)) )    //  Ano modelo de fabricacao
      GravaLinhaNFe( "anoFab="          + ltrim(str(GeralTXT->ANO_FAB,4)) )    //  Ano de fabricacao
      GravaLinhaNFe( "tpPint="          + GeralTXT->TIPO_PINT )                //  Tipo de pintura
      GravaLinhaNFe( "tpVeic="          + GeralTXT->TIPO_VEIC )                //  Tipo de veiculo (Tabela RENAVAM)
      GravaLinhaNFe( "espVeic="         + GeralTXT->ESP_VEIC )                 //  Especie do veiculo (Tabela RENAVAM)
      GravaLinhaNFe( "VIN="             + GeralTXT->VIN )                      //  Identificacao do Numero do Veiculo
      GravaLinhaNFe( "condVeic="        + GeralTXT->COND_VEIC )                //  1-Acabado 2-Inacabado 3-Semi-Acabado
      if !empty(GeralTXT->COD_MOD)
         GravaLinhaNFe( "cMod="         + GeralTXT->COD_MOD )                  //  Codigo Marca Modelo (Tabela RENAVAM)
      endif
      if !empty(GeralTXT->CMT)
         GravaLinhaNFe( "CMT="          + GeralTXT->CMT )             // Carga maxima de tracao
      endif
      if !empty(GeralTXT->COD_COR)
         GravaLinhaNFe( "cCorDENATRAN=" + GeralTXT->COD_COR  )        // Codigo da cor
      endif
      if !empty(GeralTXT->CAPAC_LOT)
         GravaLinhaNFe( "lota="         + GeralTXT->CAPAC_LOT)        // capacidade de lotacao
      endif
      if !empty(GeralTXT->RESTRICAO)
         GravaLinhaNFe( "tpRest="       + GeralTXT->RESTRICAO)        // 0=Nao ha, 1=Alienacao fiduciaria, 2=Arrendamento mercantil, 3=Reserva Dominio, 4=Penhor veiculos, 9=outras
      endif
   endif

   *** Detalhamento especifico de MEDICAMENTOS ***
   if setup->RAMO=8
      if !empty(ItemNF->COR_GRADE) .or. !empty(ItemNF->TAM_GRADE)
         vFAB_LOTE := iif(empty(ItemNF->FABRIC)  , '' , ItemNF->FABRIC   )
         vVAL_LOTE := iif(empty(ItemNF->VALIDADE), '' , ItemNF->VALIDADE )
   	   GravaLinhaNFe( "[Medicamento"  + strzero(ContaProd,3)+"001]")
         GravaLinhaNFe( "nLote="        + ltrim(    ItemNF->COR_GRADE ))        //  Nro Docto Importacao
         GravaLinhaNFe( "qLote="        + ltrim(str(ItemNF->QUANT    ,11,3)) )  //  Data do documento
         GravaLinhaNFe( "dFab="         +      dtoc(ItemNF->DATA_FABRI) )       //  Data da fabricacao
         GravaLinhaNFe( "dVal="         +      dtoc(ItemNF->DATA_VALID ) )      //  Data de validade
         GravaLinhaNFe( "vPMC="         + ltrim(str(ItemNF->VLR_UNIT ,15,2 )) ) //  Preco maximo ao consumidor
      endif
	endif

   *** Detalhamento especifico para combustiveis ***
   if setup->RAMO=13 .and. left(geral->COD_ORIG,4)='ANP-'
      GravaLinhaNFe( "[Combustivel"     + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "cProdANP="        +         right(geral->COD_ORIG,12))         //  Codigo da ANP
      GravaLinhaNFe( "UFCons="          + vESTADO )

      *** GravaLinhaNFe( "[ICMSCons"    + strzero(ContaProd,3)+"]")
      *** GravaLinhaNFe( "CODIF="       + ltrim(str(ItemNF->QUANT    ,11,3)) )  //  Data do documento
      *** GravaLinhaNFe( "qTemp="       +           ItemNF->FABRIC )            //  Data da fabricacao
      *** GravaLinhaNFe( "[CIDE"        + strzero(ContaProd,3)+"]")
      *** GravaLinhaNFe( "qBCprod="     +           ItemNF->TAM_GRADE )         //  Nro Docto Importacao
      *** GravaLinhaNFe( "vAliqProd="   + ltrim(str(ItemNF->QTD_GRADE,11,3)) )  //  Data do documento
      *** GravaLinhaNFe( "vCIDE="       +           ItemNF->FABRIC )            //  Data da fabricacao
   endif

   *** Dados tributacao do produto (ICMS) ***
   vORIGEM_PRO :=                ItemNF->ORIGEM_PRO
   vSIT_TRIB   := substr(strzero(ItemNF->SIT_TRIB  ,3),2,2)
   vCSOSN      :=                ItemNF->CSOSN_ITEM


	*** So grava TAGs se for Produto ***
   if left(ItemNF->COD_FABRI,3)<>'MAO' .and. left(ItemNF->COD_FABRI,4)<>'SOFT'
      *** Total dos Impostos Federais da NF ***
      *** GravaLinhaNFe( "vTotTrib"+  )
      GravaLinhaNFe( "[ICMS"   + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "Origem=" + strzero(vORIGEM_PRO,1) )

      *** Se empresa esta no SIMPLES NACIONAL ***
      if nf->CRT_A == 1
         GravaLinhaNFe( "CSOSN="                       + strzero(vCSOSN,3) )
         do case
            case vCSOSN == 101
                 GravaLinhaNFe( "pCredSN="             + ltrim(str(ItemNF->ICMS_SN   , 06 ,2)) )                        // Aliquota do Super Simples aplicada
                 GravaLinhaNFe( "vCredICMSSN="         + ltrim(str(ItemNF->ICMSITEMSN, 15 ,2)) )                        // Valor do credito ICMS que pode ser aproveitado

            case vCSOSN == 102 .or.;
                 vCSOSN == 103 .or.;
                 vCSOSN == 300 .or.;
                 vCSOSN == 400

            case vCSOSN == 201
                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS) , '0',geral->MODALSUBS) )          // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG , 06 ,2)) )
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     , 06 ,2)) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15 ,2)) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST, 06 ,2)) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15 ,2)) )                         // O ICMS do item ja esta calculado sobre o total do item
                 GravaLinhaNFe( "pCredSN="             + ltrim(str(ItemNF->ICMS_SN   , 06 ,2)) )                         // Aliquota do Super Simples aplicada
                 GravaLinhaNFe( "vCredICMSSN="         + ltrim(str(ItemNF->ICMSITEMSN, 15 ,2)) )                         // Valor do credito ICMS que pode ser aproveitado

            case vCSOSN == 202 .or.;
                 vCSOSN == 203
                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS) , '0',geral->MODALSUBS) )          // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG , 06 ,2)) )
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     , 06 ,2)) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15 ,2)) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST, 06 ,2)) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15 ,2)) )                         // O ICMS do item ja esta calculado sobre o total do item

            case vCSOSN == 500
                 GravaLinhaNFe( "vBCSTReT="            + ltrim(str(ItemNF->BASE_ITEMS, 15 ,2)) )
                 GravaLinhaNFe( "vICMSSTRet="          + ltrim(str(ItemNF->SUBS_ITEM , 15 ,2)) )                         // O ICMS do item ja esta calculado sobre o total do item

            case vCSOSN == 900
                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS) ,'0',geral->MODALSUBS) )          // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG , 06 ,2)) )
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     , 06 ,2)) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15 ,2)) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST, 06 ,2)) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15 ,2)) )                         // O ICMS do item ja esta calculado sobre o total do item
                 GravaLinhaNFe( "pCredSN="             + ltrim(str(ItemNF->ICMS_SN   , 06 ,2)) )                         // O ICMS do item ja esta calculado sobre o total do item
                 GravaLinhaNFe( "vCredICMSSN="         + ltrim(str(ItemNF->ICMSITEMSN, 15 ,2)) )                         // O ICMS do item ja esta calculado sobre o total do item
         endcase
      else
         *** Se NÆo for SUPER SIMPLES considera CST ***
         GravaLinhaNFe( "CST="    + vSIT_TRIB )
         do case
            case vSIT_TRIB == "00"
                 *** Se for Tributada Integralmente ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM,15,2)))
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS     ,06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM,15,2)))                           // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "10"
                 *** Se for tributada e com cobranca do ICMS por substituicao ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM,15,2)))
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS     ,06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM,15,2)))                           // O ICMS do item ja esta calculado sobre o total do item

                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS) ,'0',geral->MODALSUBS) )          // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG ,06,2)) )
                 ***  GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     ,06,2)) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS,15,2)) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST,06,2)) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM ,15,2)) )                         // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "20"
                 *** Se for com Reducao de Base de Calculo ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "PercentualReducao="   + ltrim(str(vPERC_RED*100     ,06,2 )) )
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM ,15,2 )) )
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS      ,06,2 )) )
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM ,15,2 )) )                        // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "30"
                 *** Se for Isenta ou Nao Tributada e com cobranca de ICMS por substituicao ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS),'0',geral->MODALSUBS) )           // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG ,06,2 )) )
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     ,06,2 )) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS,14,2 )) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST,06,2 )) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM ,15,2 )) )                        // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "40" .or. vSIT_TRIB="41" .or. vSIT_TRIB="50"
                 *** Se for Isenta, Nao Tributada ou Supenso de ICMS ***
                 *** Campos abaixo sao do Novo Layout ***
                 if (setup->RAMO=2 .or. setup->RAMO=3) .and. ItemNF->MotDesICMS>0
                    *** Concessionaria de Veiculo ou Trator ***
                    GravaLinhaNFe( "Valor="            + ltrim(str(ItemNF->ICMS_ITEM ,15,2 )) )                        // O ICMS do item ja esta calculado sobre o total do item
                    GravaLinhaNFe( "motDesICMS="       + ltrim(str(ItemNF->MotDesICMS,1)) )
                 endif

            case vSIT_TRIB == "51"
                 *** Se for com diferimento de ICMS ***
                 vDIFERIMENTO := .T.
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 *** GravaLinhaNFe( "PercentualReducao="   + ltrim(str(vPERC_RED*100     , 06,2)))
                 *** GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM , 15,2)))
                 *** GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS      , 06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "60"
                 *** ICMS cobrador anteriormente por Substituicao Tributaria ***
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15,2)))
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "70"
                 *** Se for com reducao de base de calculo e ICMS por substituicao ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "PercentualReducao="   + ltrim(str(vPERC_RED * 100   , 06,2)))
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM , 15,2)))
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS      , 06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS),'0',geral->MODALSUBS) )           // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG , 06,2)))
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED * 100   , 06,2)))
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15,2)))
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST, 06,2)))                         // Aliquota ICMS SUBSTITUICAO
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "90"
                 *** Se for outras situacoes tributarias ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM , 15,2)))
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     , 06,2)))
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS      , 06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS),'0',geral->MODALSUBS) )           // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG , 06,2)))
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     , 06,2)))
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15,2)))
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST, 06,2)))
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item
         endcase
      endif

      **** Dados tributacao do produto (IPI) ***
      GravaLinhaNFe( "[IPI"                    + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "CST="                    + strzero(ItemNF->CST_IPI,2) )
      if ItemNF->IPI_ITEM>0
         if !empty(geral->CLASSE_IPI)
            GravaLinhaNFe( "ClasseEnquadramento=" + ltrim(geral->CLASSE_IPI) )
         endif
         if !empty(geral->CNPJ_IPI)
            GravaLinhaNFe( "CNPJProduto="         + ltrim(NoMask(geral->CNPJ_IPI)) )
         endif
         if !empty(geral->SELO_IPI)
            GravaLinhaNFe( "CodigoSeloIPI="       + ltrim(geral->SELO_IPI) )
         endif
         if !empty(geral->Q_SELO_IPI)
            GravaLinhaNFe( "QuantidadeSelos="     + ltrim(str(geral->Q_SELO_IPI, 10,0)))
         endif
         if !empty(geral->CODENQ_IPI)
            GravaLinhaNFe( "CodigoEnquadramento=" + ltrim(geral->CODENQ_IPI) )
         endif
         if ItemNF->CST_IPI == 50 .or.;
            ItemNF->CST_IPI == 99
            *** Se a modalidade de calculo for por Aliquota ***
            if geral->MODO_IPI='A'
               GravaLinhaNFe( "ValorBase="        + ltrim(str(ItemNF->BASE_LIQ  , 15,2)))
               GravaLinhaNFe( "Aliquota="         + ltrim(str(ItemNF->IPI       , 06,2)))
            else
               GravaLinhaNFe( "Quantidade="       + ltrim(str(ItemNF->QUANT     , 12,4)))
               GravaLinhaNFe( "ValorUnidade="     + ltrim(str(ItemNF->VLR_LIQ   , 15,2)))
            endif
            GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->IPI_ITEM  , 15,2)))
         endif
         vVLR_IPI += ItemNF->IPI_ITEM * ItemNF->QUANT
      endif
      /*
      *** Dados tributacao do produto (Exportacao)
      if left(ItemNF->CFOP_ITEM,1)='7'
         GravaLinhaNFe( "[II"         + strzero(ContaProd,3)+"]")
         GravaLinhaNFe( "ValorBase="    )
         GravaLinhaNFe( "ValorDespAduaneiras="    )
         GravaLinhaNFe( "ValorII="      )
         GravaLinhaNFe( "ValorIOF="     )
      endif
	   */
   endif

	*** Dados Tributacao do ISS ***
   if left(vCOD_FABRI,3)='MAO' .or. left(vCOD_FABRI,4)='SOFT'
      vBASE_SERVICO    := ItemNF->BASE_ITEM
      *** Se for Simples Nacional ***
      if vCRT=1
         vBASE_SERVICO := ItemNF->BASEITEMSN
      endif        0
      GravaLinhaNFe( "[ISSQN"                + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "Origem="               + strzero(vORIGEM_PRO,1) )
      GravaLinhaNFe( "CST=90")
      GravaLinhaNFe( "ValorBase="            + iif(ItemNF->ISS_ITEM>0, ltrim(str(vBASE_SERVICO,10,2) ),''))
      GravaLinhaNFe( "Aliquota="             + ltrim(str(vISS              ,06,2) ))
      GravaLinhaNFe( "ValorISSQN="           + ltrim(str(ItemNF->ISS_ITEM  ,15,2) ))
      GravaLinhaNFe( "MunicipioFatoGerador=" + vUF_IBGE_EMIT )
      GravaLinhaNFe( "CodigoServico="        + ltrim(str(val(NoMask(geral->COD_SERV )))) )
      GravaLinhaNFe( "cSitTrib="             + iif(vPERC_RET>0,'R','N') )      // N=Normal   R=Retida   S=Substituta   I=Isenta
      vVLR_PIS_ISS    += ItemNF->PIS_ITEM
      vVLR_COFINS_ISS += ItemNF->COF_ITEM
	endif

   *** Dados tributacao do produto (PIS)
   vCST_PIS           := ItemNF->CST_PIS    // Codigo da Situacao Tributaria
   vBASE_PIS          := ItemNF->BASE_LIQ   // Base de Calculo do PIS
   vPIS_ITEM          := ItemNF->PIS_ITEM   // Valor do PIS do item
   vP_PIS             := ItemNF->P_PIS      // Percentual do PIS
   vSUSPENSAO_PIS     := .f.
   if vCST_PIS=9                           // Operacao COM SUSPENSAO
      vSUSPENSAO_PIS  := .t.
   endif

   GravaLinhaNFe( "[PIS"                     + strzero(ContaProd,3) + "]")
   GravaLinhaNFe( "CST="                     + strzero(vCST_PIS ,2) )
   GravaLinhaNFe( "ValorBase="               + ltrim(str(vBASE_PIS          ,15,2)) )
   GravaLinhaNFe( "Aliquota="                + ltrim(str(vP_PIS             ,06,2)) )
   GravaLinhaNFe( "Valor="                   + ltrim(str(vPIS_ITEM          ,15,2)) )

   *** Dados tributacao do produto (PIS sobre Substituicao Tributaria) ***
   if ItemNF->PIS_ITEMST>0
      GravaLinhaNFe( "[PISST"                + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "ValorBase="            + ltrim(str(ItemNF->SUBS_ITEM  ,15,2)) )
      GravaLinhaNFe( "AliquotaPerc="         + ltrim(str(vP_PIS             ,06,2)) )
      GravaLinhaNFe( "ValorPISST="           + ltrim(str(ItemNF->PIS_ITEMST ,15,2)) )
   endif

   *** Dados tributacao do produto (COFINS) ***
   vCST_COFINS       := ItemNF->CST_COFINS  // Codigo Situacao Tributaria
   vBASE_COFINS      := ItemNF->BASE_LIQ    // Base de Calculo
   vCOF_ITEM         := ItemNF->COF_ITEM    // Valor do COFINS do item
   vP_COFINS         := ItemNF->P_COFINS    // Percentual do COFINS
   vSUSPENSAO_COF    := .f.
   if vCST_COFINS=9                         // Operacao COM SUSPENSAO
      vSUSPENSAO_COF := .t.
   endif

   GravaLinhaNFe( "[COFINS"                  + strzero(ContaProd,3)+"]")
   GravaLinhaNFe( "CST="                     + strzero(vCST_COFINS ,2) )
   GravaLinhaNFe( "ValorBase="               + ltrim(str(vBASE_COFINS      ,10,2)) )
   GravaLinhaNFe( "Aliquota="                + ltrim(str(vP_COFINS         ,06,2)) )
   GravaLinhaNFe( "Valor="                   + ltrim(str(vCOF_ITEM         ,10,2)) )

   *** Dados tributacao do produto (PIS sobre Substituicao Tributaria) ***
	if ItemNF->COF_ITEMST>0
      GravaLinhaNFe( "[COFINSST"             + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "ValorBase="            + ltrim(str(ItemNF->SUBS_ITEM ,10,2)) )
      GravaLinhaNFe( "AliquotaPerc="         + ltrim(str(vP_COFINS         ,06,2)) )
      GravaLinhaNFe( "ValorCOFINSST="        + ltrim(str(ItemNF->COF_ITEMST,10,2)) )
   endif

   select ItemNF
   skip
   ContaProd++
enddo

*** Dados dos totalizadores da NFe ***
GravaLinhaNFe(	"[Total]" )

*** Caso seja SUPER SIMPLES ou Venda para ALC CALCULA BASE ICMS ***
if nf->CRT_A<>1 .or. cfop->DESC_ALC>0 .or. ImprimeBaseCalculo
   GravaLinhaNFe( "BaseICMS="              + ltrim(str(nf->BASE_ICMS,15,2)) )
   GravaLinhaNFe( "ValorICMS="             + ltrim(str(nf->VLR_ICMS ,15,2)) )
endif
if nf->BASE_SUBS>0
   GravaLinhaNFe( "BaseICMSSubstituicao="  + ltrim(str(nf->BASE_SUBS,15,2)) )
   GravaLinhaNFe( "ValorICMSSubstituicao=" + ltrim(str(nf->VLR_SUBS ,15,2)) )
endif
GravaLinhaNFe(    "ValorProduto="          + ltrim(str(nf->VLR_PROD ,15,2)) )
if nf->VLR_FRETE>0
   GravaLinhaNFe( "ValorFrete="            + ltrim(str(nf->VLR_FRETE,15,2)) )
endif
if nf->VLR_SEG>0
   GravaLinhaNFe( "ValorSeguro="           + ltrim(str(nf->VLR_SEG  ,15,2)) )
endif

*** Busca o CFOP da NF para pegar tributacao ***
p_cfop(nf->CFOP,.f.)

**** Verifica abaixo todos os possiveis descontos da NFe ***
*** vTOT_DESCONTO    := vSOMA_DESC + nf->VLR_DESC + nf->VLRDESCMO + nf->VLR_ALC
vTOT_DESCONTO    := 0

*** Deduz a ISENCAO DE ICMS ***
if cfop->DED_ICMS == 'S'
   vTOT_DESCONTO  += nf->VLR_ISEN
endif

if cfop->DESC_ALC >0
   vTOT_DESCONTO  += nf->VLR_ALC
endif

*** Deduz retencao e deduz do valor da NF ***
if cfop->PERC_RET>0
   vTOT_DESCONTO += nf->VLR_RET
endif

*** Deduz o Valor do IRRF ***
if cfop->IRRF>0
   vTOT_DESCONTO += nf->VLR_IRRF
endif

if vTOT_DESCONTO >0
   *** Somo tudo que foi dado como DESCONTO ***
   GravaLinhaNFe( "ValorDesconto="       + ltrim(str(vTOT_DESCONTO,15,2)) )
endif

*** Nao sei que campo e este ***
*** GravaLinhaNFe( "ValorII=" + ltrim(str(vVLR_DESC ,14,2)) )

if nf->VLR_IPI>0
   GravaLinhaNFe( "ValorIPI="            + ltrim(str(nf->VLR_IPI   ,15,2)) )
endif
if nf->VLR_PIS>0
   GravaLinhaNFe( "ValorPIS="            + ltrim(str(nf->VLR_PIS   ,15,2)) )
endif
if nf->VLR_COFINS>0
   GravaLinhaNFe( "ValorCOFINS="         + ltrim(str(nf->VLR_COFINS,15,2)) )
endif
if nf->VLR_ACESS>0
   GravaLinhaNFe( "ValorOutrasDespesas=" + ltrim(str(nf->VLR_ACESS ,15,2)) )
endif

*** Dados dos totalizadores de ISS ***
if nf->BASE_ISS > 0
   GravaLinhaNFe( "ValorServicos="       + ltrim(str(nf->BASE_ISS   ,15,2)) )
   if nf->VLR_ISS > 0
      GravaLinhaNFe( "ValorBaseISS="     + ltrim(str(nf->BASE_ISS   ,15,2)) )
   endif
   GravaLinhaNFe( "ValorISSQN="          + ltrim(str(nf->VLR_ISS    ,15,2)) )
   GravaLinhaNFe( "ValorPISISS="         + ltrim(str(vVLR_PIS_ISS   ,15,2)) )
   GravaLinhaNFe( "ValorCONFINSISS="     + ltrim(str(vVLR_COFINS_ISS,15,2)) )
endif
*** Impostos Federais ***
GravaLinhaNFe( "vTotTrib="               + ltrim(str(nf->VLR_IMP,15,2)) )
GravaLinhaNFe( "ValorNota="              + ltrim(str(nf->VLR_NF ,15,2)) )

*** Dados do Transportador ***
GravaLinhaNFe( "[Transportador]" )
GravaLinhaNFe( "FretePorConta="          + nf->Q_PG_FRETE )

if nf->COD_TRAN=0
   GravaLinhaNFe( "CnpjCpf=" )
   GravaLinhaNFe( "NomeRazao=")
   GravaLinhaNFe( "IE=")
   GravaLinhaNFe( "Endereco=")
   GravaLinhaNFe( "Cidade=")
   GravaLinhaNFe( "UF=" )
else
   p_transp(nf->COD_TRAN, nf->FILIAL_TRA, .f.)
   p_cidade(transp->CID_TRAN, .f., transp->UF_TRAN)

   GravaLinhaNFe( "CnpjCpf="        + iif(!empty(NoMask(transp->CGC_TRAN)),NoMask(transp->CGC_TRAN), NoMask(transp->CPF_TRAN)) )
   GravaLinhaNFe( "NomeRazao="      + transp->NOME_TRAN )
   GravaLinhaNFe( "IE="             + NoMask(transp->IE_TRAN) )
   GravaLinhaNFe( "Endereco="       + transp->END_TRAN )
   GravaLinhaNFe( "Cidade="         + transp->CID_TRAN )
   GravaLinhaNFe( "UF="             + transp->UF_TRAN )
 * GravaLinhaNFe( "ValorServico="  )
 * GravaLinhaNFe( "ValorBase="   )
 * GravaLinhaNFe( "Aliquota="  )
 * GravaLinhaNFe( "Valor="  )
 * GravaLinhaNFe( "CFOP="     )
 * GravaLinhaNFe( "CidadeCod="      + cidades->IBGE_CID )

   *** Dados do veiculo ***
   if !empty(nf->PLACA_VEIC)
      GravaLinhaNFe( "Placa="   + LimpaPlaca(nf->PLACA_VEIC ))
   endif
   if !empty(nf->UF_VEIC)
      GravaLinhaNFe( "UFPlaca=" + nf->UF_VEIC )
   endif
   if !empty(nf->ANTT_VEIC)
      GravaLinhaNFe( "RNTC="    + LimpaPlaca(nf->ANTT_VEIC) )
   endif

   *** Dados do reboque ***
   if !empty(nf->PLACA_REB)
      GravaLinhaNFe( "[Reboque]" )
      GravaLinhaNFe( "placa="   + LimpaPlaca(nf->PLACA_REB) )
      if !empty(nf->UF_REB)
         GravaLinhaNFe( "UF="   + nf->UF_REB  )
      endif
      if !empty(nf->ANTT_REB)
         GravaLinhaNFe( "RNTC=" + LimpaPlaca(nf->ANTT_REB) )
      endif
      *** GravaLinhaNFe( "vagao"+ LimpaPlaca(nf->ANTT_REB) )
      *** GravaLinhaNFe( "balsa"+ LimpaPlaca(nf->ANTT_REB) )
   endif
endif

*** Dados dos volumes *** (verificar se e por produto ou no total NF)
GravaLinhaNFe( "[Volume001]" )
GravaLinhaNFe( "Quantidade="    + ltrim(str(nf->QUANTPROD,15)) )
GravaLinhaNFe( "Especie="       +           nf->ESPECIE )
GravaLinhaNFe( "Marca="         +           nf->MARCA          )
GravaLinhaNFe( "Numeracao="     + ltrim(str(nf->QUANTVOL ,15)) )
GravaLinhaNFe( "PesoLiquido="   + ltrim(str(nf->P_LIQUIDO,15,3)) )
GravaLinhaNFe( "PesoBruto="     + ltrim(str(nf->P_BRUTO  ,15,3)) )

*** Volta o arquivo para o do Inicio da Operacao ***
select (ArqAntNFe)

*** Atribuo o Valor da NF aqui para calcular parcelas ***
vLIQUIDO  := nf->VLR_NF

*** Dados do Faturamento ***
*** Somente se for venda e NAO for zerar os valores da NF ***
if (cfop->NATUREZA=='A' .or. cfop->NATUREZA=='G' .or. cfop->NATUREZA=='I') .and. (ArqAntNFe)->MODPGTO=1 .and. cfop->ZERARVLR <>'S'
   GravaLinhaNFe(	"[Fatura]" )
   GravaLinhaNFe( "Numero="        + ltrim(str(nf->NUMERO,9)) )
   GravaLinhaNFe( "ValorOriginal=" + ltrim(str(nf->VLR_NF,14,2)) )
   GravaLinhaNFe( "ValorLiquido="  + ltrim(str(nf->VLR_NF,14,2)) )

   *** Dados das Duplicatas ***
   select (ArqAntNFe)

   *** Gerar NFe com Servicos (conjugada) ***
   vImprimeParcelas := .f.
   BuscaVenctos(nf->NROVENDA, nf->FILIAL)
   select CadPgtos
   vTotalVenda := 0
   do while !eof() .and. nf->NROVENDA == NROVENDA .and. nf->FILIAL == FILIAL
      vTotalVenda += VALOR
      skip
   enddo
   *** Compara Valor da NF com Valor de Parcelas so imprime vencimentos se forem IGUAIS ***
   if vTotalVenda == nf->VLR_NF
      vImprimeParcelas := .t.
   endif

   if vImprimeParcelas
      BuscaVenctos(nf->NROVENDA, nf->FILIAL)
      select CadPgtos
      do while !eof() .and. nf->NROVENDA == NROVENDA .and. nf->FILIAL == FILIAL
         GravaLinhaNFe( "[Duplicata"      +     strzero(cadpgtos->NUM_PARC,3)+"]")
         GravaLinhaNFe( "Numero="         + ltrim(strzero(vNUMERO,8))+'-'+strzero(cadpgtos->NUM_PARC,2)+'/'+strzero(cadpgtos->TOT_PARC,2) )
         GravaLinhaNFe( "DataVencimento=" +        dtoc(cadpgtos->DATA_VENC) )
         GravaLinhaNFe( "Valor="          + alltrim(str(cadpgtos->VALOR)))
         select CadPgtos
         skip
      enddo
   endif

endif

select (ArqAntNFe)

*** Se for Exportacao Grava local embarque ***
if left(vCFOP,1)='7'
   GravaLinhaNFe( "[Exporta]")
   GravaLinhaNFe( "UFembarq="   + setup->ESTEMP )
   GravaLinhaNFe( "xLocEmbarq=" + setup->CIDEMP )
endif

*** Se for de veiculo ***
vDADOS_VEIC := ""
if !empty(GeralTXT->CHASSI)
   do case
      case GeralTXT->VIN == 'R'
	        vTXT_VIN      := 'Remarcado'
      case GeralTXT->VIN == 'N'
	        vTXT_VIN      := 'Normal   '
      other
           vTXT_FIN      := ''
   endcase

   do case
      case GeralTXT->RESTRICAO='0' .or. GeralTXT->RESTRICAO=' '
           vTXT_REST := 'NAO HA'
      case GeralTXT->RESTRICAO='1'
           vTXT_REST := 'ALIENACAO FIDUCIARIA'
      case GeralTXT->RESTRICAO='2'
           vTXT_REST := 'ARRENDAMENTO'
      case GeralTXT->RESTRICAO='3'
           vTXT_REST := 'RESERVA DOMINIO'
      case GeralTXT->RESTRICAO='4'
           vTXT_REST := 'PENHOR VEICULO'
      case GeralTXT->RESTRICAO='9'
           vTXT_REST := 'OUTRAS'
   endcase
   vDADOS_VEIC :="Chassi : "  + alltrim(GeralTXT->CHASSI)                                                        +;  //  Data do documento
                 iif( empty(GeralTXT->COR      ), "" , "   Cor : "             + alltrim(  ItemNf->COR))          +;  //  Codigo da Cor de cada montadora
                 iif( empty(GeralTXT->DESC_COR ), "" , "   Descricao Cor : "   + alltrim(  ItemNf->DESC_COR))     +;  //  Descricao da cor
                 iif( empty(GeralTXT->POTENCIA ), "" , "   Potencia : "        + alltrim(  ItemNf->POTENCIA))     +;  //  Potencia
                 iif( empty(GeralTXT->CM3      ), "" , "   Cil : "             + alltrim(  ItemNf->CM3))          +;  //  Potencia
                 iif( empty(GeralTXT->PESO_LIQ ), "" , "   Peso Liquido : "    + ltrim(str(ItemNf->PESO_LIQ,9)))  +;  //  Peso liquido
                 iif( empty(GeralTXT->PESO_BRU ), "" , "   Peso Bruto  : "     + ltrim(str(ItemNf->PESO_BRU,9)))  +;  //  Peso Bruto
                 iif( empty(GeralTXT->SERIAL   ), "" , "   Nro. Serie : "      + alltrim(  ItemNf->SERIAL))       +;  //  Numero de Serie
                 iif( empty(GeralTXT->TIPO_COMB), "" , "   Combustivel : "     + alltrim(  ItemNf->TIPO_COMB))    +;  //  Tipo de combustivel
                 iif( empty(GeralTXT->NRO_MOTOR), "" , "   Nro Motor : "       + alltrim(  ItemNf->NRO_MOTOR))    +;  //  Numero do motor
                 iif( empty(GeralTXT->CMT      ), "" , "   CMT : "             + alltrim(  ItemNf->CMT))          +;  //
		           iif( empty(GeralTXT->DIST_EIXO), "" , "   Entre Eixos : "     + alltrim(  ItemNf->DIST_EIXO))    +;  //  Distancia entre eixos
                 iif( empty(GeralTXT->ANO_MOD  ), "" , "   Ano/Modelo : "      + ltrim(str(ItemNf->ANO_MOD,4)))   +;  //  Ano modelo de fabricacao
                 iif( empty(GeralTXT->ANO_FAB  ), "" , "   Ano/Fabricacao : "  + ltrim(str(ItemNf->ANO_FAB,4)))   +;  //  Ano de fabricacao
                 iif( empty(GeralTXT->TIPO_PINT), "" , "   Tipo Pintura : "    + alltrim(  ItemNf->TIPO_PINT))    +;  //  Tipo de pintura
                 iif( empty(GeralTXT->TIPO_VEIC), "" , "   Tipo Veiculo : "    + alltrim(  ItemNf->TIPO_VEIC))    +;  //  Tipo de veiculo (Tabela RENAVAM)
                 iif( empty(GeralTXT->ESP_VEIC ), "" , "   Especie Veiculo : " + alltrim(  ItemNf->ESP_VEIC))     +;  //  Especie do veiculo (Tabela RENAVAM)
                 iif( empty(GeralTXT->VIN      ), "" , "   VIN : "             + alltrim(  ItemNf->VIN))              //  Identificacao do Numero do Veiculo
                 iif( empty(GeralTXT->RESTRICAO), "" , "   Restricao : "       + vTXT_REST)                           //  Tipo de restricao
endif
FimLin    := chr( 13 ) + chr( 10 )

select DBFNFe
go top

vLinhaINI := ''
do while !eof()
   *** grava comandos na Variavel INI ***
   vLinhaINI += alltrim(DBFNFe->LinhaNFe) + FimLin
   skip
enddo
inkey(.5)

select DBFNFe
use

*** Seta Arquivo de Origem ***
select (ArqAntNFe)
Igual_var()

TabelasSPED('MODALIDADEPGTOVENDA', vMODPGTO  , row(), col()+1, 'MODALIDADE', 'vMODPGTO'  , 'N', 0, .f.)
p_vendedor(vCOD_VEND, vFILIAL_VEN, .f.)
p_cfop(vCFOP,.f.)

*** Codificacao das Mensagens SPED ***
vCODMSG         :=''

*** Informacoes adicionais ***
vLinhaINI       += '[DadosAdicionais]'  + FimLin

*** SP0450 - Codigo 5001
vCODMSG         += '5001'
vLinhaINI       += "Complemento=Pz -> " + nf->PRAZO+"    ("+nf->NROVENDA+");"

*** SP0450 - Codigo 5002
vCODMSG         += '5002'
vLinhaINI       += 'ModPgto: '+str(vMODPGTO,2)+'-'+tabelas->RESUMIDO+'     '+iif(nf->CUPOM>0,'CUPOM FISCAL '+strzero(nf->CUPOM,6),'')+'    Vend : '+vFILIAL_VEN+'/'+strzero(vCOD_VEND,4)+'-' + vendedor->NOME + ";"

CriaDBFTotVendas('CADVENDA')
TotalizaFormasPgto(nf->FILIAL, nf->NROVENDA, .f. )
select TotalizaPGTOS
go top
CONTAFPG := 0
do while !eof()
   CONTAFPG++
   p_formapag(COD_PAG,.f.)
   vLinhaINI    += str(COD_PAG,2)+'-'+left(formapag->NOME,20)+'-'+transf(VLR_PROD,'@E 999,999.99')
   skip
   if !eof()
      CONTAFPG++
      p_formapag(COD_PAG,.f.)
      vLinhaINI += str(COD_PAG,2)+'-'+left(formapag->NOME,20)+'-'+transf(VLR_PROD,'@E 999,999.99')
   endif
   if CONTAFPG>3 .or. eof()
      vLinhaINI += ';'
      CONTAFPG  := 0
   endif
   skip
enddo
FechaDBFTotVendas()
FechaPgtos()

*** SP0450 - Codigo 5003
if !empty(nf->DADOS)
   vCODMSG      += '5003'
   vTXT1        := substr(nf->DADOS ,001,080)
   vTXT2        := substr(nf->DADOS ,081,080)
   vTXT3        := substr(nf->DADOS ,161,100)
   vLinhaINI    += iif(!empty(vTXT1), vTXT1+';','') + iif(!empty(vTXT2), vTXT2+';','') + iif(!empty(vTXT3), vTXT3+';','')
endif

if !empty(nf->DADOS2)
   vLinhaINI    += nf->DADOS2 + ';'
endif

*** SP0450 - Codigo 5004 (Todos os descontos abaixo no mesmo codigo)
if vDESC_PROD > 0
   vCODMSG      += '5004'
   *** o desconto sera calculado em cima do VALOR BRUTO DO ORCAMENTO ***
   vLinhaINI    += '* VLR BRUTO PROD='+transf(vBRUTO_PROD,'@E 9999,999.99')+'    DESCONTO='+transf(vDESC_PROD,'@E 999,999.99')+' *'
endif

if vDESC_SERV > 0
   vCODMSG      += '5005'
   vLinhaINI    += '* VLR BRUTO SERV='+transf(vBRUTO_SERV,'@E 9999,999.99')+'    DESCONTO='+transf(vDESC_SERV,'@E 999,999.99')+' *;'
endif

*** Dados do Cliente ***
vCODMSG         += '5006'
vLinhaINI       += 'Cliente : '+nf->FILIAL_CLI+'/'+strzero(nf->COD_CLI,5)+'-'+cadcli->FANTASIA

****************** REGISTROS ABAIXO TRATAM O SP0460 *************

*** SP0460 - Codigo 6001
if !empty(cfop->MENS_CFOP)
   vCODMSG      += '6001'
   vLinhaINI    += 'Mens CFOP : '+cfop->MENS_CFOP  + ";"
endif

*** verifica se o CFOP tem ISENCAO p/Deduzir ***
*** SP0460 - Codigo 6002
if nf->VLR_ISEN>0 .and. cfop->DED_ICMS='S'
   vCODMSG      += '6002'
   vLinhaINI    += '* Desconto Ref ICMS -> '+transf(nf->VLR_ISEN,'@E 99,999.99')+' *;'
endif

*** verifica se a NF tem BASE DE CALCULO REDUZIDA ***
*** SP0460 - Codigo 6003
if nf->REDUCAO
   vCODMSG      += '6003'
   vLinhaINI    += '* Base de Calculo Reduzida '+trim(mensagem->M_BASERED)+' *;'
endif

*** Calcula o % de retencao de imposto ***
*** SP0460 - Codigo 6004
if nf->VLR_RET>0
   vCODMSG      += '6004'
   vLinhaINI    += '* Retencao '+transf(cfop->PERC_RET,'@E 999.99%')+'='+transf(nf->VLR_RET,'@E 999,999.99')+' '+trim(mensagem->M_RET)+' *;'
endif

*** Calcula o % de Desconto da ALC ***
*** SP0460
if nf->VLR_ALC>0
  vCODMSG       += '6005'
  vLinhaINI     += '* Incentivo ALC('
  if cfop->ICMS_ALC>0
     vLinhaINI  += 'Base ICMS='   + transf(nf->BASE_ALC  ,'@E 999,999.99') + '  '+;
                   'Desc.ICMS='   + transf(cfop->ICMS_ALC,'@E 999.99%')+'='+alltrim(transf(nf->VLRICMSALC,'@E 999,999.99'))+' '
  endif
  if cfop->PIS_ALC>0
     vCODMSG    += '6006'
     vLinhaINI  += '*Desc.PIS='   + transf(cfop->PIS_ALC ,'@E 999.99%')+'='+alltrim(transf(nf->VLRPISALC ,'@E 999,999.99'))+' '
  endif
  if cfop->COF_ALC>0
     vCODMSG    += '6007'
     vLinhaINI  += '*Desc.COFINS='+ transf(cfop->COF_ALC ,'@E 999.99%')+'='+alltrim(transf(nf->VLRCOFALC ,'@E 999,999.99'))+';'
  endif
  vLinhaINI     += ') '+trim(mensagem->M_DESC_ALC)+';'
  if !empty(cadcli->SUFRAMA)
      vCODMSG   += '6008'
      vLinhaINI += 'SUFRAMA : '+NoMask(cadcli->SUFRAMA)+';'
  endif
endif

*** SP0460 - Codigo 6009
if nf->VLR_IRRF>0
   vCODMSG      += '6009'
   vLinhaINI    += '*Desconto Ref. IRRF='+transf(nf->VLR_IRRF,'@E 999,999.99')+' Sobre os Servicos *;'
endif

*** SP0460 - Codigo 6010
if vCOMSUBST .and. left(vCFOP,1)<>'7'
   vCODMSG      += '6010'
   vLinhaINI    += '*Substituicao Tributaria ' + trim(mensagem->M_SUBST)+' *;'
endif

*** SP0460 - Codigo 6011
if vCOMISEN
   vCODMSG      += '6011'
   vLinhaINI    += '*Isencao de ICMS '  + trim(mensagem->M_ISENCAO)+' *;'
endif

*** SP0460 - Codigo 6012
if vCOMSUSP
   vCODMSG      += '6012'
   vLinhaINI    += '*Suspensao de ICMS '+ trim(mensagem->M_SUSP)+' *;'
endif

if nf->CRT_A == 1 .or. nf->CRT_A == 2
   vCODMSG      += '6013'
   vLinhaINI    += '*Empresa Optante Simples Nacional*;'
   ***vLinhaINI += 'NF emitida nos termos Art.57 Parag.10o Resolucao 94/2011'
   if nf->CRT_A=1 .and. nf->VLRICMS_SN > 0 .and. cfop->NATUREZA='A'  //  VENDA
      vLinhaINI += 'Base ICMS=' + transf(nf->BASE_SN ,'@E 999,999.99') + '  '+;
                   'Aliq ICMS=' + transf(nf->ICMS_SN ,'@E 99.99%')+'='+alltrim(transf(nf->VLRICMS_SN,'@E 999,999.99'))+' '
   endif
endif

if vSUSPENSAO_PIS .or.;
   vSUSPENSAO_COF
   vCODMSG      += '6014'
   vLinhaINI    += '*Suspensao PIS/COFINS '+trim(mensagem->M_DESC_ALC )+' *;'
endif

*** Mensagens Adicionais
*** vCODMSG     := 6015 --> Diferencial de Aliquota Ativo Permanente
*** vCODMSG     := 6016 --> Diferencial de Aliquota Uso e Consumo

if vDIFERIMENTO
   vCODMSG      += '6017'
   vLinhaINI    += '*Diferimento ICMS '+trim(mensagem->M_DIF )+' *;'
endif

*** Grava os codigos das Mensagens da NF ***
select NF
replace CODMSG with vCODMSG

*** Se for venda calcula o imposto e mostra a mensagem ***
if nf->VLR_IMP > 0
   vLinhaINI    += 'Vlr Aprox Tributos de acordo Tabela IBPT'
endif

if 'WAGNER ' $ vUSUARIO .or. 'MICROLINE' $ vUSUARIO
    FrmMsgErro( vLinhaINI )
endif

*** Busca o numero do LOTE NFe ***
select ARQUIVOS
set exact on
seek 'NFELOTE '
reglock(.f.)
replace ULT_COD with ULT_COD+1
dbcommit()
vLOTE := ULT_COD
arquivos->( dbunlock() )
set exact off

*** Cria XML e enviar ***
ACBR_CriarXMLEnviarNFe(vLinhaINI, vLOTE, 0)
select (ArqAntNFe)
return(.t.)


*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*
**************************************************************
*                                                            *
* ATENCAO QUE APARTIR DAQUI MUDA A CRIACAO DO INI PARA 3.10  *
*                                                            *
**************************************************************
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*


Function ACBR_GerarIniNFeV3_10(oNUMERO, oSERIE, oORIGEM, oREIMPRESSAO)
*************************************************
* Gerar um Arquivo TXT no formato de arquivos INI
* oNUMERO -> Numero da NF gravada no arquivo
* oSerie  -> Serie da NF gravada
* oOrigem -> Origem da Venda (VND, OS, PED)
* oREIMPRESSAO -> .F. se NAO for reimpressao (gera nova NFE e XML)
*                 .T. se FOR reimpressao (NAO gera nova NFE e XML)
* VERSAO PARA XML 2.0
*---------------------------------------------------------------------------------
* Conforme NOTA TECNICA 0002/2011 e com a versao do monitor 0.6.2.b (15/06/2011)
* quando o sistema estiver gerando NFe em homologacao o monitor ira trocar auto
* maticamente 3 dados para atender a NT.
* NOME DESTINATARIO = NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL
* CNPJ DESTINATARIO = 99.999.999/0001-91 - Para opera‡äes no Brasil e vazio para opera‡oes no exterior
* IE DESTINATARIO   = Conteudo vazio
*************************************************

*** Busca Layout da NF para pegar ordem de impressao ***
if !LayoutNF(vCOMPANY)
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()

   return(.f.)
endif

*** Desativa as chamadas em Backgroud ***
HB_BackGroundDel( nTask )

*** Cria protocolo de linha do arquivo texto ***
FimLin    := chr( 13 ) + chr( 10 )
ARQNF     := "C:\TEMP\ININFE"+NFeRandomico()
VetorStru := {}
aadd(VetorStru, {'LINHANFE' , 'C' , 900, 0 })

if !TrataErroCriacao( ARQNF, procname(), procline(), 'D' )
   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
   return(.f.)
endif

use (ARQNF) alias DBFNFe new exclusive

select NF
if !reglock(.f.)
   AuditAlt( procname() )

   *** Fecha arquivo de transacao da NFe ***
   ACBR_FechaNFe()
	return(.f.)
endif
set exact off

*** Verificar ate aqui o que deve ser retirado em producao ***
igual_var()
p_cfop(vCFOP,.f.)
TabelasSPED('MODALIDADEPGTOVENDA', vMODPGTO  , row(), col()+1, 'MODALIDADE', 'vMODPGTO'  , 'N', 0, .f.)

ImprimeBaseCalculo := .t.
if vCRT == 1
   *** Se for Super Simples ZERA ICMS ***
   ImprimeBaseCalculo := .f.
   if setup->RAMO=14 .and. cfop->ICMS_SUBST>0
      *** Imprime base para Simples Nacional abaixo sublimite somente se :
      *** for Industria e CFOP tiver calculo de substituicao tributaria ***
      ImprimeBaseCalculo := .t.
   endif
endif

*** Guarda percentual de retencao do CFOP ***
vPERC_RET     := cfop->PERC_RET

*** Se for reimpressao mostra tela da NF ***
if oREIMPRESSAO
   vULT_NF    := NUMERO
   vDATA_NF   := DT_EMIS
   vHORA_EMIS := HORA
   vDT_SAIDA  := DT_SAIDA
   vCLIENTE   := CONSUM
   vIE        := iif(PESSOA == 'F', 'ISENTO', IE)
   vEND       := iif(PESSOA == 'F', END_RES , END_COM)
   vNRO       := iif(PESSOA == 'F', NRO_RES , NRO_COM)
   vFONE      := iif(PESSOA == 'F', FONE_RES, FONE_COM)
   vQUANTEMB  := QUANTPROD
   vVLR_ACESS := VLR_ACESS

   Tela_NF('ReimpressÆo de NF ')
   select NF
   vHORA      := vHORA_EMIS
   repl_var()
endif

*** Identificacao do documento ***
do case
   case nf->SERIE    == 'NFE' .or. nf->SERIE == '900'
        vModeloDF    := 'moNFE'
        vCodigoDF    := '55'
        if setup->VersaoNFe == 2
           vVersaoDF := 've200'
        else
           vVersaoDF := 've310'
        endif
        if nf->SERIE == 'NFE'
           vSerieDF  := '1'
        else
           vSerieDF  := '900'
        endif

   case nf->SERIE    == 'NFC'
        vModeloDF    := 'moNFCe'
        vCodigoDF    := '65'
        if setup->VersaoNFe == 2
           vVersaoDF := 've200'
        else
           vVersaoDF := 've310'
        endif
        vSerieDF     := '100'
endcase

GravaLinhaNFe( "[InfNFE]" )
if setup->VersaoNFe == 2
   GravaLinhaNFe( "Versao=2.00" )
else
   GravaLinhaNFe( "Versao=3.10" )
endif

GravaLinhaNFe( "[Identificacao]" )
GravaLinhaNFe( "NaturezaOperacao="+cfop->DESCRICAO )
GravaLinhaNFe( "Modelo="     +     vCodigoDF       )
GravaLinhaNFe( "Serie="      +     vSerieDF        )
GravaLinhaNFe( "Codigo="     +            nf->NFE_RAND)
GravaLinhaNFe(	"Numero="     +  ltrim(str(nf->NUMERO,9)) )
GravaLinhaNFe(	"Emissao="    +       dtoc(nf->DT_EMIS ) + ' ' + nf->HORA )

if nf->SERIE <> 'NFC'
   GravaLinhaNFe(	"Saida="   + iif(!empty(nf->DT_SAIDA), dtoc(nf->DT_SAIDA)  + ' ' + time() , '') )
   GravaLinhaNFe(	"Tipo="    +        iif(nf->TIPO == 'S',"1","0") )
endif

GravaLinhaNFe(	"FormaPag="   +    strzero(nf->IND_PAG,1) )     // 0=A Vista  1=A Prazo  2=Outros
GravaLinhaNFe(	"ModeloDF="   + vModeloDF  )
GravaLinhaNFe(	"VersaoDF="   + vVersaoDF  )

*** Criar controle da Finalidade da NFe ****
GravaLinhaNFe(	"finNFe="     + nf->FINALNFE )                  // 1=Normal
                                                               // 2=Complementar
                                                               // 3=de Ajuste
                                                               // 4=Devolucao/Retorno

*** Criar controle da Finalidade da NFe ****
GravaLinhaNFe(	"idDest="     + strzero(nf->IdDest,1))          // 1=Operacao Interna
                                                               // 2=Operacao Interestadual
                                                               // 3=Operacao com Exterior

if oSERIE == 'NFC'
   GravaLinhaNFe(	"indFinal=1")                                // SEMPRE Consumidor Final -> 0=NÆo 1=Sim
else
   GravaLinhaNFe(	"indFinal="   + strzero(nf->indFINAL,1))     // Consumidor Final -> 0=NÆo 1=Sim
endif

GravaLinhaNFe(	"indPres="       + strzero(nf->indPRES ,1))     // 0=NÆo se aplica
                                                               // 1=Presencial
                                                               // 2=NÆo Presencial (Internet)
                                                               // 3=NÆo Presencial(telemarketing)
                                                               // 4=NFCe
                                                               // 9=NÆo Presencial

GravaLinhaNFe(	"procEmi=0" )                                   // 0=Emissao NFe com aplicativo do contribuinte

if nf->SERIE == 'NFC'
   GravaLinhaNFe(	"tpImp=4" )                                  // 0=Sem Geracao DANFE
else                                                           // 1=DANFE Normal Retrato
   GravaLinhaNFe(	"tpImp=1" )                                  // 2=DANFE Normal Paisagem
endif                                                          // 3=DANFE Simplificado
                                                               // 4=DANFE NFCe
                                                               // 5=DANFE NFCe em Mensagem Eletronica

GravaLinhaNFe( "tpemis=1" )                                    // 1=Normal
                                                               // 2=Contingencia FS-IA
                                                               // 3=Contingencia SCAN
                                                               // 4=Contingencia DPEC
                                                               // 5=Contingencia FS-DA
                                                               // 6=Contingencia SVC-AN
                                                               // 7=Contingencia SVC-RS
                                                               // 8=Contingencia Off-Line da NFCe

*** Informacoes da Contingencia ***
if !empty(nf->DTCONTNFE)
   GravaLinhaNFe( "dhCont="  + dtoc(nf->DTCONTNFE) + ' ' + time() )  // Data e hora da contingencia
   GravaLinhaNFe( "xJust="   + nf->MOTCONTNFE )                      // Motivo da contingencia
endif

*** Informacao das NF/CF referenciadas (devolucao por exemplo)
if nf->CUPOM_REF>0
   *** Informa‡äes do Cupom Fiscal ***
   GravaLinhaNFe( "[NFref001]")                                // Relacao de NFs canceladas/devolvidas
   GravaLinhaNFe( "Tipo=ECF")                                  // Modelo do Cupom Fiscal
   GravaLinhaNFe( "ModECF=2D")                                 // Modelo do Cupom Fiscal
   GravaLinhaNFe( "nECF="    + strzero(nf->INRO_ECF ,3) )      // Numero sequencial da IF
   GravaLinhaNFe( "nCOO="    + strzero(nf->CUPOM_REF,6) )      // Numero sequencial do CUPOM
endif

if !empty(nf->CHAVE_NFR)
   GravaLinhaNFe( "[NFref001]" )
   GravaLinhaNFe( "Tipo=NFe")                                  // Modelo da NOTA FISCALl
   GravaLinhaNFe( "refNFe="   + nf->CHAVE_NFR )                // Nota Fiscal Referenciada para devolucao
   *** Linhas abaixo quando NAO for NFe ***
   *** GravaLinhaNFe( "cUF="     + nf->UF_NFR    )             // UF do emitente da NF
   *** GravaLinhaNFe( "AAMM="    + nf->AAMM_NFR  )             // Ano e mes da emissao NF
   *** GravaLinhaNFe( "CNPJ="    + nf->CNPJ_NFR  )             // do Emitente da NF
   *** GravaLinhaNFe( "Modelo="  + nf->MOD_NFR   )             // Modelo da NF
   *** GravaLinhaNFe( "Serie="   + nf->SERIE_NFR )             // Serie da NF
   *** GravaLinhaNFe( "nNF="     + nf->NF_NFR    )             // Numero da NF
endif


*** Dados do Emitente ***
p_cidade(setup->CIDEMP    , .f., setup->ESTEMP)
vUF_IBGE_EMIT := cidades->IBGE_CID                             // Usada na UF TAG de servicos
p_paises(cidades->COD_PAIS, .f.)

GravaLinhaNFe( "[Emitente]" )
GravaLinhaNFe( "CNPJ="       +                     NoMask(setup->CGCEMP    ))
GravaLinhaNFe( "IE="         +                     NoMask(setup->IEEMP     ))
GravaLinhaNFe( "Razao="      +        TrocaParse( alltrim(setup->RAZSOC_NFE)) )
GravaLinhaNFe( "Fantasia="   +        TrocaParse( alltrim(setup->DESCRI    )) )
GravaLinhaNFe( "Fone="       +        left(NoMask(alltrim(setup->FONEEMP   )),10) )
GravaLinhaNFe( "CEP="        +                     NoMask(setup->CEPEMP    ))
GravaLinhaNFe( "Logradouro=" + alltrim(TrocaParse(alltrim(setup->END_NFE   ))))
GravaLinhaNFe( "Numero="     +                    strzero(setup->NROEMP,6  ))
GravaLinhaNFe( "Complemento="+        TrocaParse( alltrim(setup->COMPEMP   )) )
GravaLinhaNFe( "Bairro="     +                 TrocaParse(setup->BAIRROEMP ))
GravaLinhaNFe( "CidadeCod="  + cidades->IBGE_CID )
GravaLinhaNFe( "Cidade="     + setup->CIDEMP )
GravaLinhaNFe( "UF="         + setup->ESTEMP )
GravaLinhaNFe( "PaisCod="    + ltrim(str(cidades->COD_PAIS)) )
GravaLinhaNFe( "Pais="       + paises->NOME )
if !empty(setup->IMUNICEMP)
   GravaLinhaNFe( "IM="      +                     NoMask(setup->IMUNICEMP ))
endif
GravaLinhaNFe( "CNAE="       +                     NoMask(setup->CNAEEMP   ))
GravaLinhaNFe( "CRT="        + strzero(nf->CRT_A,1) )

*** Dados do Destinatario ***
if nf->COD_CLI>0
   p_cliente(nf->COD_CLI  , nf->FILIAL_CLI, .f. )

   p_cidade(cadcli->CIDADE   , .f., cadcli->ESTADO)
   p_estado(cadcli->ESTADO   , .f. )
   p_paises(cidades->COD_PAIS, .f. )
   vCLIENTE     := alltrim(cadcli->CLIENTE)

   if nf->PESSOA=='F'
      vDOCTO1   := cadcli->CPF
      vDOCTO2   := cadcli->RG
      vENDERECO := cadcli->END_RES
      vNRO_END  := cadcli->NRO_RES
      vFONE     := cadcli->FONE_RES
      vCOMPLEM  := cadcli->COMP_RES
   else
      vDOCTO1   := cadcli->CGC
      vDOCTO2   := cadcli->IE
      vENDERECO := cadcli->END_COM
      vNRO_END  := cadcli->NRO_COM
      vFONE     := cadcli->FONE_COM
      vCOMPLEM  := cadcli->COMP_COM
   endif

   GravaLinhaNFe( "[Destinatario]" )
   GravaLinhaNFe( "indIEDest="+strzero(nf->IndIEDest,1))       // 1=Contribuinte ICMS
                                                               // 2=Contribuinte Isento de IE
                                                               // 9=Nao Contribuinte tendo ou NAO IE
   if 'EXTERIOR' $ vCIDADE
      *** Gerar TAGs sem conteudo ***
      GravaLinhaNFe( "CNPJ=")
      if setup->VersaoNFe == 2
         GravaLinhaNFe( "IE=ISENTO" )
      endif
   else
      GravaLinhaNFe( "CNPJ="     + NoMask(vDOCTO1) )
      if nf->PESSOA='J'
         if !'ISENTO' $ upper(vDOCTO2)
            *** So passa a IE se NAO FOR NFCE ***
            if nf->SERIE <> 'NFC'
               GravaLinhaNFe( "IE="    + NoMask(vDOCTO2) )
            endif
         else
            *** Somente envia ISENTO se for na versao 2.0 ***
            if setup->VersaoNFe == 2
               GravaLinhaNFe( "IE=ISENTO" )
            endif
         endif
      else
         if empty(cadcli->PROD_RURAL)
            *** Somente envia ISENTO se for na versao 2.0 ***
            if setup->VersaoNFe == 2
               GravaLinhaNFe( "IE=ISENTO" )
            else
               if nf->SERIE <> 'NFC'
                  GravaLinhaNFe( "IE=" )
               endif
            endif
         else
            GravaLinhaNFe( "IE=" + Nomask(cadcli->PROD_RURAL))
         endif
      endif
   endif

   GravaLinhaNFe( "NomeRazao="   + TrocaParse(vCLIENTE) )
   GravaLinhaNFe( "Fone="        + left(alltrim(NoMask(vFONE)),10) )
   GravaLinhaNFe( "CEP="         + NoMask(vCEP) )
   GravaLinhaNFe( "Logradouro="  + TrocaParse(vENDERECO) )
   GravaLinhaNFe( "Numero="      + strzero(vNRO_END,6) )
   GravaLinhaNFe( "Complemento=" + TrocaParse(vCOMPLEM) )
   GravaLinhaNFe( "Bairro="      + TrocaParse(vBAIRRO) )
   GravaLinhaNFe( "CidadeCod="   + cidades->IBGE_CID )
   GravaLinhaNFe( "Cidade="      + vCIDADE )
   GravaLinhaNFe( "UF="          + vESTADO )
   GravaLinhaNFe( "PaisCod="     + strzero(cidades->COD_PAIS,4) )
   GravaLinhaNFe( "Pais="        + paises->NOME )
   if nf->SERIE <> 'NFC'
      if !empty(cadcli->SUFRAMA)
         GravaLinhaNFe(	"ISUF="  + NoMask(cadcli->SUFRAMA) )
      endif
   endif
   if !empty(cadcli->EMAIL)
      GravaLinhaNFe(	"Email="    + cadcli->EMAIL )
   endif
else
   *** Grava o tipo de Destinatario de mercadoria ***
   GravaLinhaNFe( "[Destinatario]" )
   GravaLinhaNFe( "indIEDest="+strzero(nf->IndIEDest,1))       // 1=Contribuinte ICMS
   GravaLinhaNFe( "CNPJ="        +                      iif(nf->PESSOA == 'F', NoMask(nf->CPF), NoMask(nf->CGC)))
   GravaLinhaNFe( "NomeRazao="   +               TrocaParse(nf->CONSUM) )
   GravaLinhaNFe( "Fone="        + left(alltrim(NoMask( iif(nf->PESSOA == 'F', nf->FONE_RES, nf->FONE_COM ))), 10))
   GravaLinhaNFe( "CEP="         +                   NoMask(nf->CEP) )
   GravaLinhaNFe( "Logradouro="  + TrocaParse(          iif(nf->PESSOA == 'F', nf->END_RES , nf->END_COM  )    ))
   GravaLinhaNFe( "Numero="      + strzero(             iif(nf->PESSOA == 'F', nf->NRO_RES , nf->NRO_COM  ), 7 ))
***   GravaLinhaNFe( "Complemento=" + TrocaParse(vCOMPLEM) )
   GravaLinhaNFe( "Bairro="      +               TrocaParse(nf->BAIRRO) )
   GravaLinhaNFe( "CidadeCod="   + cidades->IBGE_CID )
   GravaLinhaNFe( "Cidade="      + nf->CIDADE )
   GravaLinhaNFe( "UF="          + nf->ESTADO )
   GravaLinhaNFe( "PaisCod="     + strzero(cidades->COD_PAIS,4) )
   GravaLinhaNFe( "Pais="        + paises->NOME )

endif

Mostrar := .f.
if Mostrar
   GravaLinhaNFe( "[Retirada]" )
   if !empty(CNPJ)
      GravaLinhaNFe( "CNPJ="  + NoMask(vDOCTO1) )
   else
      GravaLinhaNFe( "CPF="   + NoMask(vDOCTO1) )
   endif
   GravaLinhaNFe( "xLgr="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "nro="      + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xCpl="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xBairro="  + NoMask(vDOCTO1) )
   GravaLinhaNFe( "cMun="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xMun="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "UF="       + NoMask(vDOCTO1) )

   GravaLinhaNFe( "[Entrega]" )
   GravaLinhaNFe( "CNPJ="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xLgr="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "nro="      + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xCpl="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xBairro="  + NoMask(vDOCTO1) )
   GravaLinhaNFe( "cMun="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "xMun="     + NoMask(vDOCTO1) )
   GravaLinhaNFe( "UF="       + NoMask(vDOCTO1) )
endif

*** Tag que grava autorizacoes de quem pode baixar XML ***
vDownLoadXML:=.f.
if vDownloadXML
   GravaLinhaNFe( "[autXML]" )
   if !empty(CliNFe->CPF)
      GravaLinhaNFe( "CPF="   + NoMask(vDOCTO1) )
   endif

   if !empty(CliNFe->CNPJ)
      GravaLinhaNFe( "CNPJ="   + NoMask(vDOCTO1) )
   endif
endif


*** Gerar Itens da NFe ***
select ItemNF
set order to 1
set exact off
seek oFILIAL + str(oNUMERO,9) + oSERIE
set exact on

if eof()
   MsgAlert('NÆo foram encontrados Itens para NFe '+strzero(oNUMERO,9)+'...')
endif

ContaProd      := 1
vVLR_PIS_ISS   := vVLR_COFINS_ISS := vVLR_IPI     := 0
vCOMSUBST      := vCOMISEN        := vCOMSUSP     := .f.
vBRUTO_SERV    := vDESC_SERV      := vBRUTO_PROD  := vDESC_PROD := 0
vSUSPENSAO_PIS := vSUSPENSAO_COF  := vDIFERIMENTO := .F.
do while !eof() .and. oFILIAL == FILIAL .and. oNUMERO == NUMERO .and. oSERIE == SERIE
   Igual_Var()
   *** Busca o CFOP do item ***
   p_cfop(vCFOP_ITEM,.f.)

   select GERAL
   set order to 8
   seek str(vCODIGO,6)
   if eof()
      select ItemNF
      skip
      loop
   endif
	vCAT_RED     := CAT_RED
   *** 09/04/2013 - Considerar o trecho abaixo pelo CST/CSOSN e nÆo pelo campo de tributacao ***
   if SUBST     == 'S'
      vCOMSUBST := .t.
   endif
   if TRIBFEST  == 'S' .and. cfop->FORAEST='S'
      vCOMSUBST := .f.
   endif
   if ISENTO    == 'S'
      vCOMISEN  :=.t.
   endif
   if SUSPENSAO == 'S'
      vCOMSUSP  := .t.
   endif

	p_reducao(vCAT_RED,.f.)
	vPERC_RED    := iif(reducao->PERC=1, 0 , reducao->PERC)

   *** verifico se possui Descricao Complementar ***
   select GERALTXT
   set order to 1
   seek oFILIAL + vNROVENDA + str(vCODIGO,6) + str(vREG,9)

   TEM_COMPLEMENTO    :=.F.
   if !eof()
      TEM_COMPLEMENTO :=.T.
   endif

   select ItemNF
   *** Dados do produto ***
   do case
      case layouts->NFCOMCOD == 'S'
           vCODIGO_PRODUTO   := ltrim(str(ItemNF->CODIGO,6))

      case layouts->NFCOMCOD == 'F' .or. layouts->NFCOMCOD == ' '
           vCODIGO_PRODUTO   := ItemNF->COD_FABRI

      case layouts->NFCOMCOD == 'O'
           vCODIGO_PRODUTO   := geral->COD_ORIG                // Pego cadastro Produto pois nÆo tem o campo

      otherwise
           vCODIGO_PRODUTO   := ltrim(str(ItemNF->CODIGO,6))

   endcase

   GravaLinhaNFe( "[Produto"       + strzero(ContaProd,3)+"]")
   GravaLinhaNFe( "Codigo="        + vCODIGO_PRODUTO )
   if !Tem_Complemento
      GravaLinhaNFe( "Descricao="  + TrocaParse(ItemNF->DISCRIM) )
   else
      *** Descricao Complementar do produto ***
      vDESC_COMP := ''
      LIN_MEMO   := mlcount(geraltxt->MEMO, 450)
      for IJKL = 1 to LIN_MEMO
          if IJKL = 1
             vDESC_COMP := substr(alltrim(memoline(geraltxt->MEMO, 450, IJKL, .F.)),1,120)
          endif
      next
      GravaLinhaNFe( "Descricao="+vDESC_COMP)
   endif

   CodigoBarra    := .f.
   vTamanhoCodigo := len(alltrim(vCOD_FABRI))
   if vTamanhoCodigo == 13 .and. left(vCOD_FABRI,2) == '78'
      for XYZ := 1 to vTamanhoCodigo
          if type(substr(vCOD_FABRI,XYZ,1)) <> 'N'
             CodigoBarra := .f.
             exit
          endif
      next
      CodigoBarra := .t.
   endif
   *** Verificar quando tem EAN tem que ter unidade tributavel do EAN ***
   if CodigoBarra
      GravaLinhaNFe( "EAN="      + alltrim(ItemNF->COD_FABRI) )
      GravaLinhaNFe( "cEANTrib=" + alltrim(ItemNF->COD_FABRI) )
   endif

   if !empty(geral->COD_NCM)
      if geral->MODALID=9               // Servicos
         GravaLinhaNFe( "NCM=00" )      // se for exportacao OBRIGATORIO NCM
      else
         GravaLinhaNFe( "NCM="   + NoMask(geral->COD_NCM) )         // se for exportacao OBRIGATORIO NCM
      endif
   endif

   TemDesconto    := .f.
   vDESC_ITEM     := vSOMA_DESC := 0
   *** Verifica abaixo todos os possiveis descontos da NFe ***
   p_cfop(nf->CFOP,.f.)
   if nf->VLR_DESC + nf->VLRDESCMO + nf->VLR_ALC + iif(cfop->DED_ICMS='S', nf->VLR_ISEN, 0 ) + nf->VLR_RET + nf->VLR_IRRF > 0
      TemDesconto := .t.
      vDESC_ITEM  := ItemNF->ALC_ITEM  + iif(ItemNF->DED_ISEN='S', ItemNF->ISEN_ITEM, 0 ) + ItemNF->RET_ITEM
   endif
   *** Variavel para mostrar informacoes complementares ***
   vSOMA_DESC     += vDESC_ITEM + ItemNF->VLR_DESC

   vCFOP_ITEM     := left( NoMask(ItemNF->CFOP_ITEM),4)
   vUNIDADE       := iif( empty(ItemNF->UND), 'UN', ItemNF->UND)
   vQUANT         := ItemNF->QUANT
   vVLR_UNITARIO  := ItemNF->VLR_LIQ
   vVLR_TOTAL     := ItemNF->VLR_TOTAL  // - vDESC_ITEM

   GravaLinhaNFe( "CFOP="               + ltrim(vCFOP_ITEM) )
   GravaLinhaNFe( "Unidade="            + ltrim(vUNIDADE) )
   GravaLinhaNFe( "uTrib="              + ltrim(vUNIDADE) )
   GravaLinhaNFe( "qTrib="              + ltrim(str(vQUANT       , 11  , vDEC_EST)) )
   GravaLinhaNFe( "Quantidade="         + ltrim(str(vQUANT       , 11  , vDEC_EST)) )
   GravaLinhaNFe( "ValorUnitario="      + ltrim(str(vVLR_UNITARIO, 15  , 5)) )
   GravaLinhaNFe( "ValorTotal="         + ltrim(str(vVLR_TOTAL   , 15  , 2)) )
   GravaLinhaNFe( "ValorDesconto="      + ltrim(str(vDESC_ITEM   , 15  , 2)) )

   if left(COD_FABRI,3) == 'MAO'           // .and. VLR_DESC > 0   Desativei para somar TODOS OS ITENS
      vBRUTO_SERV +=  ItemNF->VLR_UNIT * ItemNF->QUANT
      vDESC_SERV  += (ItemNF->VLR_DESC * ItemNF->QUANT) + vDESC_ITEM
   endif
   if left(COD_FABRI,3) <> 'MAO'          // .and. VLR_DESC > 0   Desativei para somar TODOS OS ITENS
      vBRUTO_PROD +=  ItemNF->VLR_UNIT * ItemNF->QUANT
      vDESC_PROD  += (ItemNF->VLR_DESC * ItemNF->QUANT) + vDESC_ITEM
   endif

   if ItemNF->ACESS_ITEM>0
      GravaLinhaNFe( "vOutro="          + ltrim(str(ItemNF->ACESS_ITEM  ,15,2)) )    // Outras Despesas acessorias
   endif

   if ItemNF->FRETE_ITEM>0
      GravaLinhaNFe( "vFrete="          + ltrim(str(ItemNF->FRETE_ITEM,15,2)) )    // Frete rateado no item
   endif

   GravaLinhaNFe( "indTot="             + ltrim(str(ItemNF->SOMA_ITEM)) )         // 0=Item nÆo compoe o vlr total NFe  1=Item compoe o valor da NFe
   if !empty(nf->PED_COMPRA)
      GravaLinhaNFe( "xPed= "           + nf->PED_COMPRA)                         // Numero do pedido de compra
      GravaLinhaNFe( "nItemPed="        + strzero(ItemNF->ITEMPED,6) )            // Item do pedido de compra
   endif

   *** Impostos Federais ***
   GravaLinhaNFe( "vTotTrib="           + ltrim(str(ItemNF->IMP_ITEM,15,2)) )

   *** Descricao Complementar do produto ***
   if TEM_COMPLEMENTO
      vDESC_COMP := ''
      LIN_MEMO   := mlcount(geraltxt->MEMO, 450)
      for IJKL := 1 to LIN_MEMO
          if IJKL == 1
             vDESC_COMP += substr(alltrim(memoline(geraltxt->MEMO, 450, IJKL, .F.)),120)
          else
             vDESC_COMP += alltrim(memoline(geraltxt->MEMO, 450, IJKL, .F.))
          endif
      next
      GravaLinhaNFe( "infAdProd="       + vDESC_COMP)
   endif

	Mostrar := .f.
	if Mostrar
      *** Dados da Importacao de produtos (OPCIONAL) ***
      GravaLinhaNFe( "NumeroDI="             + vUND )       //  Nro Docto Importacao
      GravaLinhaNFe( "DataRegistroDI="       + vUND )       //  Data do documento
      GravaLinhaNFe( "LocalDesembaraco="     + vUND )       //
      GravaLinhaNFe( "UFDesembaraco="        + vUND )       //
      GravaLinhaNFe( "DataDesembaraco="      + vUND )       //
      GravaLinhaNFe( "CodigoExportador="     + vUND )       //

      *** Dados da Importacao de produtos (OPCIONAL) ***
      for ContaAdi=1 to TotalAdicao
          GravaLinhaNFe( "LADI"              + strzero(ContaProd,3)+Strzero(ContaAdi,3)+"]")
          GravaLinhaNFe( "NumeroAdicao="     + vUND )
          GravaLinhaNFe( "CodigoFabricante=" + vUND )    // Codigo do fabricante estrangeiro no sistema
          GravaLinhaNFe( "DescontoADI="      + vUND )
       next
   endif

   *** Detalhamento especifico de VEICULOS ***
   if !empty(GeralTXT->CHASSI) .and. nf->SERIE <> 'NFC'
	   GravaLinhaNFe( "[Veiculo"         + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "tpOP="            + GeralTXT->TIPOOP )                   //  Tipo Operacao 1-Venda Concessionaria 2-Faturamento Direto 3-Venda Direta 0-Outros
      GravaLinhaNFe( "chassi="          + GeralTXT->CHASSI )                   //  Data do documento
      GravaLinhaNFe( "cCor="            + GeralTXT->COR )                      //  Codigo da Cor de cada montadora
      GravaLinhaNFe( "xCor="            + GeralTXT->DESC_COR )                 //  Descricao da cor
      GravaLinhaNFe( "pot="             + GeralTXT->POTENCIA )                 //  Potencia
      GravaLinhaNFe( "Cilin="           + GeralTXT->CM3 )                      //  Cilindrada
      GravaLinhaNFe( "pesoL="           + ltrim(str(GeralTXT->PESO_LIQ,9)) )   //  Peso liquido
      GravaLinhaNFe( "pesoB="           + ltrim(str(GeralTXT->PESO_BRU,9)) )   //  Peso Bruto
      if !empty(GeralTXT->SERIAL)
         GravaLinhaNFe( "nSerie="       + GeralTXT->SERIAL )                   //  Numero de Serie
      endif
      GravaLinhaNFe( "tpComb="          + GeralTXT->TIPO_COMB )                //  Tipo de combustivel
      if !empty(GeralTXT->NRO_MOTOR)
         GravaLinhaNFe( "nMotor="       + GeralTXT->NRO_MOTOR )                //  Numero do motor
      endif
      if !empty(GeralTXT->DIST_EIXO)
         GravaLinhaNFe( "dist="         + GeralTXT->DIST_EIXO )                //  Distancia entre eixos
      endif
      GravaLinhaNFe( "anoMod="          + ltrim(str(GeralTXT->ANO_MOD,4)) )    //  Ano modelo de fabricacao
      GravaLinhaNFe( "anoFab="          + ltrim(str(GeralTXT->ANO_FAB,4)) )    //  Ano de fabricacao
      GravaLinhaNFe( "tpPint="          + GeralTXT->TIPO_PINT )                //  Tipo de pintura
      GravaLinhaNFe( "tpVeic="          + GeralTXT->TIPO_VEIC )                //  Tipo de veiculo (Tabela RENAVAM)
      GravaLinhaNFe( "espVeic="         + GeralTXT->ESP_VEIC )                 //  Especie do veiculo (Tabela RENAVAM)
      GravaLinhaNFe( "VIN="             + GeralTXT->VIN )                      //  Identificacao do Numero do Veiculo
      GravaLinhaNFe( "condVeic="        + GeralTXT->COND_VEIC )                //  1-Acabado 2-Inacabado 3-Semi-Acabado
      if !empty(GeralTXT->COD_MOD)
         GravaLinhaNFe( "cMod="         + GeralTXT->COD_MOD )                  //  Codigo Marca Modelo (Tabela RENAVAM)
      endif
      if !empty(GeralTXT->CMT)
         GravaLinhaNFe( "CMT="          + GeralTXT->CMT )             // Carga maxima de tracao
      endif
      if !empty(GeralTXT->COD_COR)
         GravaLinhaNFe( "cCorDENATRAN=" + GeralTXT->COD_COR  )        // Codigo da cor
      endif
      if !empty(GeralTXT->CAPAC_LOT)
         GravaLinhaNFe( "lota="         + GeralTXT->CAPAC_LOT)        // capacidade de lotacao
      endif
      if !empty(GeralTXT->RESTRICAO)
         GravaLinhaNFe( "tpRest="       + GeralTXT->RESTRICAO)        // 0=Nao ha, 1=Alienacao fiduciaria, 2=Arrendamento mercantil, 3=Reserva Dominio, 4=Penhor veiculos, 9=outras
      endif
   endif

   *** Detalhamento especifico de MEDICAMENTOS ***
   if setup->RAMO=8 .and. nf->SERIE <> 'NFC'
      if !empty(ItemNF->COR_GRADE) .or. !empty(ItemNF->TAM_GRADE)
         vFAB_LOTE := iif(empty(ItemNF->FABRIC)  , '' , ItemNF->FABRIC   )
         vVAL_LOTE := iif(empty(ItemNF->VALIDADE), '' , ItemNF->VALIDADE )
   	   GravaLinhaNFe( "[Medicamento"  + strzero(ContaProd,3)+"001]")
         GravaLinhaNFe( "nLote="        + ltrim(    ItemNF->COR_GRADE ))        //  Nro Docto Importacao
         GravaLinhaNFe( "qLote="        + ltrim(str(ItemNF->QUANT    ,11,3)) )  //  Data do documento
         GravaLinhaNFe( "dFab="         +      dtoc(ItemNF->DATA_FABRI) )       //  Data da fabricacao
         GravaLinhaNFe( "dVal="         +      dtoc(ItemNF->DATA_VALID ) )      //  Data de validade
         GravaLinhaNFe( "vPMC="         + ltrim(str(ItemNF->VLR_UNIT ,15,2 )) ) //  Preco maximo ao consumidor
      endif
	endif

   *** Detalhamento especifico para combustiveis ***
   if setup->RAMO=13 .and. left(geral->COD_ORIG,4)='ANP-'
      GravaLinhaNFe( "[Combustivel"     + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "cProdANP="        +         right(geral->COD_ORIG,12))         //  Codigo da ANP
      GravaLinhaNFe( "UFCons="          + vESTADO )

      *** GravaLinhaNFe( "[ICMSCons"    + strzero(ContaProd,3)+"]")
      *** GravaLinhaNFe( "CODIF="       + ltrim(str(ItemNF->QUANT    ,11,3)) )  //  Data do documento
      *** GravaLinhaNFe( "qTemp="       +           ItemNF->FABRIC )            //  Data da fabricacao
      *** GravaLinhaNFe( "[CIDE"        + strzero(ContaProd,3)+"]")
      *** GravaLinhaNFe( "qBCprod="     +           ItemNF->TAM_GRADE )         //  Nro Docto Importacao
      *** GravaLinhaNFe( "vAliqProd="   + ltrim(str(ItemNF->QTD_GRADE,11,3)) )  //  Data do documento
      *** GravaLinhaNFe( "vCIDE="       +           ItemNF->FABRIC )            //  Data da fabricacao
   endif

   *** Dados tributacao do produto (ICMS) ***
   vORIGEM_PRO :=                ItemNF->ORIGEM_PRO
   vSIT_TRIB   := substr(strzero(ItemNF->SIT_TRIB  ,3),2,2)
   vCSOSN      :=                ItemNF->CSOSN_ITEM

	*** So grava TAGs se for Produto ***
   if left(ItemNF->COD_FABRI,3) <> 'MAO' .and. left(ItemNF->COD_FABRI,4) <> 'SOFT'
      *** Total dos Impostos Federais da NF ***
      *** GravaLinhaNFe( "vTotTrib"+  )
      GravaLinhaNFe( "[ICMS"   + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "Origem=" + strzero(vORIGEM_PRO,1) )

      *** Se empresa esta no SIMPLES NACIONAL ***
      if nf->CRT_A=1
         GravaLinhaNFe( "CSOSN="                       + strzero(vCSOSN,3) )
         do case
            case vCSOSN=101
                 GravaLinhaNFe( "pCredSN="             + ltrim(str(ItemNF->ICMS_SN   ,06,2)) )                        // Aliquota do Super Simples aplicada
                 GravaLinhaNFe( "vCredICMSSN="         + ltrim(str(ItemNF->ICMSITEMSN,15,2)) )                        // Valor do credito ICMS que pode ser aproveitado

            case vCSOSN=102 .or.;
                 vCSOSN=103 .or.;
                 vCSOSN=300 .or.;
                 vCSOSN=400

            case vCSOSN=201
                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS) ,'0',geral->MODALSUBS) )          // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG ,06,2)) )
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     ,06,2)) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS,15,2)) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST,06,2)) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM ,15,2)) )                         // O ICMS do item ja esta calculado sobre o total do item
                 GravaLinhaNFe( "pCredSN="             + ltrim(str(ItemNF->ICMS_SN   ,06,2)) )                         // Aliquota do Super Simples aplicada
                 GravaLinhaNFe( "vCredICMSSN="         + ltrim(str(ItemNF->ICMSITEMSN,15,2)) )                         // Valor do credito ICMS que pode ser aproveitado

            case vCSOSN=202 .or.;
                 vCSOSN=203
                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS) ,'0',geral->MODALSUBS) )          // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG ,06,2)) )
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     ,06,2)) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS,15,2)) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST,06,2)) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM ,15,2)) )                         // O ICMS do item ja esta calculado sobre o total do item

            case vCSOSN=500
                 GravaLinhaNFe( "vBCSTReT="            + ltrim(str(ItemNF->BASE_ITEMS,15,2)) )
                 GravaLinhaNFe( "vICMSSTRet="          + ltrim(str(ItemNF->SUBS_ITEM ,15,2)) )                         // O ICMS do item ja esta calculado sobre o total do item

            case vCSOSN=900
                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS) ,'0',geral->MODALSUBS) )          // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG ,06,2)) )
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     ,06,2)) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS,15,2)) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST,06,2)) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM ,15,2)) )                         // O ICMS do item ja esta calculado sobre o total do item
                 GravaLinhaNFe( "pCredSN="             + ltrim(str(ItemNF->ICMS_SN   ,06,2)) )                         // O ICMS do item ja esta calculado sobre o total do item
                 GravaLinhaNFe( "vCredICMSSN="         + ltrim(str(ItemNF->ICMSITEMSN,15,2)) )                         // O ICMS do item ja esta calculado sobre o total do item
         endcase
      else
         *** Se NÆo for SUPER SIMPLES considera CST ***
         GravaLinhaNFe( "CST="    + vSIT_TRIB )
         do case
            case vSIT_TRIB == "00"
                 *** Se for Tributada Integralmente ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM,15,2)))
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS     ,06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM,15,2)))                           // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "10"
                 *** Se for tributada e com cobranca do ICMS por substituicao ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM,15,2)))
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS     ,06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM,15,2)))                           // O ICMS do item ja esta calculado sobre o total do item

                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS) ,'0',geral->MODALSUBS) )          // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG ,06,2)) )
                 ***  GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     ,06,2)) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS,15,2)) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST,06,2)) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM ,15,2)) )                         // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "20"
                 *** Se for com Reducao de Base de Calculo ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "PercentualReducao="   + ltrim(str(vPERC_RED*100     ,06,2 )) )
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM ,15,2 )) )
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS      ,06,2 )) )
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM ,15,2 )) )                        // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "30"
                 *** Se for Isenta ou Nao Tributada e com cobranca de ICMS por substituicao ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS),'0',geral->MODALSUBS) )           // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG ,06,2 )) )
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     ,06,2 )) )
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS,14,2 )) )
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST,06,2 )) )
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM ,15,2 )) )                        // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "40" .or. vSIT_TRIB="41" .or. vSIT_TRIB="50"
                 *** Se for Isenta, Nao Tributada ou Supenso de ICMS ***
                 *** Campos abaixo sao do Novo Layout ***
                 if (setup->RAMO=2 .or. setup->RAMO=3) .and. ItemNF->MotDesICMS>0
                    *** Concessionaria de Veiculo ou Trator ***
                    GravaLinhaNFe( "Valor="            + ltrim(str(ItemNF->ICMS_ITEM ,15,2 )) )                        // O ICMS do item ja esta calculado sobre o total do item
                    GravaLinhaNFe( "motDesICMS="       + ltrim(str(ItemNF->MotDesICMS,1)) )
                 endif

            case vSIT_TRIB == "51"
                 *** Se for com diferimento de ICMS ***
                 vDIFERIMENTO := .T.
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 *** GravaLinhaNFe( "PercentualReducao="   + ltrim(str(vPERC_RED*100     , 06,2)))
                 *** GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM , 15,2)))
                 *** GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS      , 06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "60"
                 *** ICMS cobrador anteriormente por Substituicao Tributaria ***
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15,2)))
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "70"
                 *** Se for com reducao de base de calculo e ICMS por substituicao ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "PercentualReducao="   + ltrim(str(vPERC_RED * 100   , 06,2)))
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM , 15,2)))
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS      , 06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS),'0',geral->MODALSUBS) )           // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG , 06,2)))
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED * 100   , 06,2)))
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15,2)))
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST, 06,2)))                         // Aliquota ICMS SUBSTITUICAO
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

            case vSIT_TRIB == "90"
                 *** Se for outras situacoes tributarias ***
                 GravaLinhaNFe( "Modalidade="          + iif(empty(geral->MODALICMS),'3',geral->MODALICMS) )           // Se Nao foi informado considera valor da operacao
                 GravaLinhaNFe( "ValorBase="           + ltrim(str(ItemNF->BASE_ITEM , 15,2)))
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     , 06,2)))
                 GravaLinhaNFe( "Aliquota="            + ltrim(str(ItemNF->ICMS      , 06,2)))
                 GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->ICMS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item

                 *** Modalidades para Base de Calculo da Substituicao Tributaria ***
                 GravaLinhaNFe( "ModalidadeST="        + iif(empty(geral->MODALSUBS),'0',geral->MODALSUBS) )           // Se nao foi informado considera PRECO TABELADO
                 GravaLinhaNFe( "PercentualMargemST="  + ltrim(str(geral->PERC_AGREG , 06,2)))
                 GravaLinhaNFe( "PercentualReducaoST=" + ltrim(str(vPERC_RED*100     , 06,2)))
                 GravaLinhaNFe( "ValorBaseST="         + ltrim(str(ItemNF->BASE_ITEMS, 15,2)))
                 GravaLinhaNFe( "AliquotaST="          + ltrim(str(ItemNF->ICMS_SUBST, 06,2)))
                 GravaLinhaNFe( "ValorST="             + ltrim(str(ItemNF->SUBS_ITEM , 15,2)))                         // O ICMS do item ja esta calculado sobre o total do item
         endcase
      endif

      **** Dados tributacao do produto (IPI) ***
      if ItemNF->IPI_ITEM > 0
         GravaLinhaNFe( "[IPI"                    + strzero(ContaProd,3)+"]")
         GravaLinhaNFe( "CST="                    + strzero(ItemNF->CST_IPI,2) )
         if !empty(geral->CLASSE_IPI)
            GravaLinhaNFe( "ClasseEnquadramento=" + ltrim(geral->CLASSE_IPI) )
         endif
         if !empty(geral->CNPJ_IPI)
            GravaLinhaNFe( "CNPJProduto="         + ltrim(NoMask(geral->CNPJ_IPI)) )
         endif
         if !empty(geral->SELO_IPI)
            GravaLinhaNFe( "CodigoSeloIPI="       + ltrim(geral->SELO_IPI) )
         endif
         if !empty(geral->Q_SELO_IPI)
            GravaLinhaNFe( "QuantidadeSelos="     + ltrim(str(geral->Q_SELO_IPI, 10,0)))
         endif
         if !empty(geral->CODENQ_IPI)
            GravaLinhaNFe( "CodigoEnquadramento=" + ltrim(geral->CODENQ_IPI) )
         endif
         if ItemNF->CST_IPI == 50 .or.;
            ItemNF->CST_IPI == 99
            *** Se a modalidade de calculo for por Aliquota ***
            if geral->MODO_IPI='A'
               GravaLinhaNFe( "ValorBase="        + ltrim(str(ItemNF->BASE_LIQ  , 15,2)))
               GravaLinhaNFe( "Aliquota="         + ltrim(str(ItemNF->IPI       , 06,2)))
            else
               GravaLinhaNFe( "Quantidade="       + ltrim(str(ItemNF->QUANT     , 12,4)))
               GravaLinhaNFe( "ValorUnidade="     + ltrim(str(ItemNF->VLR_LIQ   , 15,2)))
            endif
            GravaLinhaNFe( "Valor="               + ltrim(str(ItemNF->IPI_ITEM  , 15,2)))
         endif
         vVLR_IPI += ItemNF->IPI_ITEM * ItemNF->QUANT
      endif
      /*
      *** Dados tributacao do produto (Exportacao)
      if left(ItemNF->CFOP_ITEM,1)='7'
         GravaLinhaNFe( "[II"         + strzero(ContaProd,3)+"]")
         GravaLinhaNFe( "ValorBase="    )
         GravaLinhaNFe( "ValorDespAduaneiras="    )
         GravaLinhaNFe( "ValorII="      )
         GravaLinhaNFe( "ValorIOF="     )
      endif
	   */
   endif

	*** Dados Tributacao do ISS ***
   if left(vCOD_FABRI,3) == 'MAO' .or. left(vCOD_FABRI,4) == 'SOFT'
      vBASE_SERVICO      := ItemNF->BASE_ITEM
      *** Se for Simples Nacional ***
      if vCRT == 1
         vBASE_SERVICO   := ItemNF->BASEITEMSN
      endif
      GravaLinhaNFe( "[ISSQN"                + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "ValorBase="            + iif(ItemNF->ISS_ITEM>0, ltrim(str(vBASE_SERVICO,10,2) ),''))
      GravaLinhaNFe( "vAliq="                + ltrim(str(vISS              ,06,2) ))
      GravaLinhaNFe( "vISSQN="               + ltrim(str(ItemNF->ISS_ITEM  ,15,2) ))
      GravaLinhaNFe( "cMunFG="               + vUF_IBGE_EMIT )
      GravaLinhaNFe( "cListServ="            + ltrim( geral->COD_SERV ) )
      GravaLinhaNFe( "indISS=1")                                               // 1=Exigivel 2=Nao Incidencia 3=Isencao 4=Exportacao 5=Imunidade  6=suspensa por decisao judicial  7=suspensa por processo administrativo
      GravaLinhaNFe( "indIncentivo=2")                                         // 1=SIM      2=NAO
      GravaLinhaNFe( "cServico="             + ltrim( geral->COD_SERV ) )
      GravaLinhaNFe( "cMun="                 + vUF_IBGE_EMIT )
      GravaLinhaNFe( "cSitTrib="             + iif(vPERC_RET>0,'R','N') )      // N=Normal   R=Retida   S=Substituta   I=Isenta

      vVLR_PIS_ISS    += ItemNF->PIS_ITEM
      vVLR_COFINS_ISS += ItemNF->COF_ITEM

   endif

      *** Dados tributacao do produto (PIS)
      vCST_PIS           := ItemNF->CST_PIS    // Codigo da Situacao Tributaria
      vBASE_PIS          := ItemNF->BASE_LIQ   // Base de Calculo do PIS
      vPIS_ITEM          := ItemNF->PIS_ITEM   // Valor do PIS do item
      vP_PIS             := ItemNF->P_PIS      // Percentual do PIS
      vSUSPENSAO_PIS     := .f.
      if vCST_PIS=9                           // Operacao COM SUSPENSAO
         vSUSPENSAO_PIS  := .t.
      endif

      GravaLinhaNFe( "[PIS"                     + strzero(ContaProd,3) + "]")
      GravaLinhaNFe( "CST="                     + strzero(vCST_PIS ,2) )
      GravaLinhaNFe( "ValorBase="               + ltrim(str(vBASE_PIS          ,15,2)) )
      GravaLinhaNFe( "Aliquota="                + ltrim(str(vP_PIS             ,06,2)) )
      GravaLinhaNFe( "Valor="                   + ltrim(str(vPIS_ITEM          ,15,2)) )

      *** Dados tributacao do produto (PIS sobre Substituicao Tributaria) ***
      if ItemNF->PIS_ITEMST>0
         GravaLinhaNFe( "[PISST"                + strzero(ContaProd,3)+"]")
         GravaLinhaNFe( "ValorBase="            + ltrim(str(ItemNF->SUBS_ITEM  ,15,2)) )
         GravaLinhaNFe( "AliquotaPerc="         + ltrim(str(vP_PIS             ,06,2)) )
         GravaLinhaNFe( "ValorPISST="           + ltrim(str(ItemNF->PIS_ITEMST ,15,2)) )
      endif

      *** Dados tributacao do produto (COFINS) ***
      vCST_COFINS       := ItemNF->CST_COFINS  // Codigo Situacao Tributaria
      vBASE_COFINS      := ItemNF->BASE_LIQ    // Base de Calculo
      vCOF_ITEM         := ItemNF->COF_ITEM    // Valor do COFINS do item
      vP_COFINS         := ItemNF->P_COFINS    // Percentual do COFINS
      vSUSPENSAO_COF    := .f.
      if vCST_COFINS=9                         // Operacao COM SUSPENSAO
         vSUSPENSAO_COF := .t.
      endif

      GravaLinhaNFe( "[COFINS"                  + strzero(ContaProd,3)+"]")
      GravaLinhaNFe( "CST="                     + strzero(vCST_COFINS ,2) )
      GravaLinhaNFe( "ValorBase="               + ltrim(str(vBASE_COFINS      ,10,2)) )
      GravaLinhaNFe( "Aliquota="                + ltrim(str(vP_COFINS         ,06,2)) )
      GravaLinhaNFe( "Valor="                   + ltrim(str(vCOF_ITEM         ,10,2)) )

      *** Dados tributacao do produto (PIS sobre Substituicao Tributaria) ***
   	if ItemNF->COF_ITEMST > 0
         GravaLinhaNFe( "[COFINSST"             + strzero(ContaProd,3)+"]")
         GravaLinhaNFe( "ValorBase="            + ltrim(str(ItemNF->SUBS_ITEM ,10,2)) )
         GravaLinhaNFe( "AliquotaPerc="         + ltrim(str(vP_COFINS         ,06,2)) )
         GravaLinhaNFe( "ValorCOFINSST="        + ltrim(str(ItemNF->COF_ITEMST,10,2)) )
      endif

   select ItemNF
   skip
   ContaProd++
enddo

*** Dados dos totalizadores da NFe ***
GravaLinhaNFe(	"[Total]" )

*** Caso seja SUPER SIMPLES ou Venda para ALC CALCULA BASE ICMS ***
if nf->CRT_A <> 1 .or. cfop->DESC_ALC > 0 .or. ImprimeBaseCalculo
   GravaLinhaNFe( "BaseICMS="              + ltrim(str(nf->BASE_ICMS,15,2)) )
   GravaLinhaNFe( "ValorICMS="             + ltrim(str(nf->VLR_ICMS ,15,2)) )
endif
if nf->BASE_SUBS > 0
   GravaLinhaNFe( "BaseICMSSubstituicao="  + ltrim(str(nf->BASE_SUBS,15,2)) )
   GravaLinhaNFe( "ValorICMSSubstituicao=" + ltrim(str(nf->VLR_SUBS ,15,2)) )
endif
GravaLinhaNFe(    "ValorProduto="          + ltrim(str(nf->VLR_PROD ,15,2)) )
if nf->VLR_FRETE > 0
   GravaLinhaNFe( "ValorFrete="            + ltrim(str(nf->VLR_FRETE,15,2)) )
endif
if nf->VLR_SEG   > 0
   GravaLinhaNFe( "ValorSeguro="           + ltrim(str(nf->VLR_SEG  ,15,2)) )
endif

*** Busca o CFOP da NF para pegar tributacao ***
p_cfop(nf->CFOP,.f.)

**** Verifica abaixo todos os possiveis descontos da NFe ***
*** vTOT_DESCONTO    := vSOMA_DESC + nf->VLR_DESC + nf->VLRDESCMO + nf->VLR_ALC
vTOT_DESCONTO    := 0

*** Deduz a ISENCAO DE ICMS ***
if cfop->DED_ICMS == 'S'
   vTOT_DESCONTO  += nf->VLR_ISEN
endif

if cfop->DESC_ALC > 0
   vTOT_DESCONTO  += nf->VLR_ALC
endif

*** Deduz retencao e deduz do valor da NF ***
if cfop->PERC_RET > 0
   vTOT_DESCONTO += nf->VLR_RET
endif

*** Deduz o Valor do IRRF ***
if cfop->IRRF > 0
   vTOT_DESCONTO += nf->VLR_IRRF
endif

if vTOT_DESCONTO > 0
   *** Somo tudo que foi dado como DESCONTO ***
   GravaLinhaNFe( "ValorDesconto="       + ltrim(str(vTOT_DESCONTO,15,2)) )
endif

*** Nao sei que campo e este ***
*** GravaLinhaNFe( "ValorII=" + ltrim(str(vVLR_DESC ,14,2)) )

if nf->VLR_IPI    > 0
   GravaLinhaNFe( "ValorIPI="            + ltrim(str(nf->VLR_IPI   ,15,2)) )
endif
if nf->VLR_PIS    > 0
   GravaLinhaNFe( "ValorPIS="            + ltrim(str(nf->VLR_PIS   , 15,2 )) )
endif
if nf->VLR_COFINS > 0
   GravaLinhaNFe( "ValorCOFINS="         + ltrim(str(nf->VLR_COFINS, 15,2 )) )
endif
if nf->VLR_ACESS  > 0
   GravaLinhaNFe( "ValorOutrasDespesas=" + ltrim(str(nf->VLR_ACESS ,15,2)) )
endif

*** Impostos Federais ***
GravaLinhaNFe( "vTotTrib="               + ltrim(str(nf->VLR_IMP,15,2)) )
GravaLinhaNFe( "vNF="                    + ltrim(str(nf->VLR_NF ,15,2)) )


*** Dados dos totalizadores de ISS ***
if nf->BASE_ISS > 0
   GravaLinhaNFe( "[ISSQNtot]" )
   GravaLinhaNFe( "vServ="               + ltrim(str(nf->BASE_ISS   ,15,2)) )
   if nf->VLR_ISS > 0
      GravaLinhaNFe( "vBC="              + ltrim(str(nf->BASE_ISS   ,15,2)) )
   endif
   GravaLinhaNFe( "vISS="                + ltrim(str(nf->VLR_ISS    ,15,2)) )
   GravaLinhaNFe( "vPIS="                + ltrim(str(vVLR_PIS_ISS   ,15,2)) )
   GravaLinhaNFe( "vCOFINS="             + ltrim(str(vVLR_COFINS_ISS,15,2)) )
   GravaLinhaNFe( "dCompet="             + dtoc(nf->DT_EMIS) )
   GravaLinhaNFe( "cRegTrib=1" )                                              // 1=Microempresa 2=Estimativa 3=sociedade profissional 4=cooperativa 5=MEI  6=ME/EPP
endif


*** Dados do Transportador ***
GravaLinhaNFe( "[Transportador]" )
if nf->SERIE == 'NFC'
   GravaLinhaNFe( "FretePorConta=9" )    // NFCe = 9 (sem frete)
else
   GravaLinhaNFe( "FretePorConta="       + nf->Q_PG_FRETE )
   if nf->COD_TRAN=0
      GravaLinhaNFe( "CnpjCpf=" )
      GravaLinhaNFe( "NomeRazao=")
      GravaLinhaNFe( "IE=")
      GravaLinhaNFe( "Endereco=")
      GravaLinhaNFe( "Cidade=")
      GravaLinhaNFe( "UF=" )
   else
      p_transp(nf->COD_TRAN, nf->FILIAL_TRA, .f.)
      p_cidade(transp->CID_TRAN, .f., transp->UF_TRAN)

      GravaLinhaNFe( "CnpjCpf="        + iif(!empty(NoMask(transp->CGC_TRAN)),NoMask(transp->CGC_TRAN), NoMask(transp->CPF_TRAN)) )
      GravaLinhaNFe( "NomeRazao="      + transp->NOME_TRAN )
      GravaLinhaNFe( "IE="             + NoMask(transp->IE_TRAN) )
      GravaLinhaNFe( "Endereco="       + transp->END_TRAN )
      GravaLinhaNFe( "Cidade="         + transp->CID_TRAN )
      GravaLinhaNFe( "UF="             + transp->UF_TRAN )
    * GravaLinhaNFe( "ValorServico="  )
    * GravaLinhaNFe( "ValorBase="   )
    * GravaLinhaNFe( "Aliquota="  )
    * GravaLinhaNFe( "Valor="  )
    * GravaLinhaNFe( "CFOP="     )
    * GravaLinhaNFe( "CidadeCod="      + cidades->IBGE_CID )

      *** Dados do veiculo ***
      if !empty(nf->PLACA_VEIC)
         GravaLinhaNFe( "Placa="   + LimpaPlaca(nf->PLACA_VEIC ))
      endif
      if !empty(nf->UF_VEIC)
         GravaLinhaNFe( "UFPlaca=" + nf->UF_VEIC )
      endif
      if !empty(nf->ANTT_VEIC)
         GravaLinhaNFe( "RNTC="    + LimpaPlaca(nf->ANTT_VEIC) )
      endif

      *** Dados do reboque ***
      if !empty(nf->PLACA_REB)
         GravaLinhaNFe( "[Reboque]" )
         GravaLinhaNFe( "placa="   + LimpaPlaca(nf->PLACA_REB) )
         if !empty(nf->UF_REB)
            GravaLinhaNFe( "UF="   + nf->UF_REB  )
         endif
         if !empty(nf->ANTT_REB)
            GravaLinhaNFe( "RNTC=" + LimpaPlaca(nf->ANTT_REB) )
         endif
         *** GravaLinhaNFe( "vagao"+ LimpaPlaca(nf->ANTT_REB) )
         *** GravaLinhaNFe( "balsa"+ LimpaPlaca(nf->ANTT_REB) )
      endif
   endif

   *** Dados dos volumes *** (verificar se e por produto ou no total NF)
   GravaLinhaNFe( "[Volume001]" )
   GravaLinhaNFe( "Quantidade="    + ltrim(str(nf->QUANTPROD,15)) )
   GravaLinhaNFe( "Especie="       +           nf->ESPECIE )
   GravaLinhaNFe( "Marca="         +           nf->MARCA          )
   GravaLinhaNFe( "Numeracao="     + ltrim(str(nf->QUANTVOL ,15)) )
   GravaLinhaNFe( "PesoLiquido="   + ltrim(str(nf->P_LIQUIDO,15,3)) )
   GravaLinhaNFe( "PesoBruto="     + ltrim(str(nf->P_BRUTO  ,15,3)) )
endif

*** Volta o arquivo para o do Inicio da Operacao ***
select (ArqAntNFe)

*** Atribuo o Valor da NF aqui para calcular parcelas ***
vLIQUIDO  := nf->VLR_NF

*** Dados do Faturamento ***
*** Somente se for venda e NAO for zerar os valores da NF ***
if nf->SERIE == 'NFC'
   GravaLinhaNFe(	"[PAG001]" )
   GravaLinhaNFe( "tpag="             + ltrim(str( (ArqAntNFe)->MODPGTO )) )
   GravaLinhaNFe( "vpag="             + ltrim(str(nf->VLR_NF,14,2       )) )
else
   if (cfop->NATUREZA == 'A' .or. cfop->NATUREZA == 'G' .or. cfop->NATUREZA=='I') .and. (ArqAntNFe)->MODPGTO=1 .and. cfop->ZERARVLR <>'S'
      GravaLinhaNFe(	"[Fatura]" )
      GravaLinhaNFe( "Numero="        + ltrim(str(nf->NUMERO,9)) )
      GravaLinhaNFe( "ValorOriginal=" + ltrim(str(nf->VLR_NF,14,2)) )
      GravaLinhaNFe( "ValorLiquido="  + ltrim(str(nf->VLR_NF,14,2)) )

      *** Dados das Duplicatas ***
      select (ArqAntNFe)

      *** Gerar NFe com Servicos (conjugada) ***
      vImprimeParcelas := .f.
      BuscaVenctos(nf->NROVENDA, nf->FILIAL)
      select CadPgtos
      vTotalVenda := 0
      do while !eof() .and. nf->NROVENDA == NROVENDA .and. nf->FILIAL == FILIAL
         vTotalVenda += VALOR
         skip
      enddo
      *** Compara Valor da NF com Valor de Parcelas so imprime vencimentos se forem IGUAIS ***
      if round(vTotalVenda,2) == round(nf->VLR_NF,2)
         vImprimeParcelas := .t.
      endif

      if vImprimeParcelas
         BuscaVenctos(nf->NROVENDA, nf->FILIAL)
         select CadPgtos
         do while !eof() .and. nf->NROVENDA == NROVENDA .and. nf->FILIAL == FILIAL
            GravaLinhaNFe( "[Duplicata"      +     strzero(cadpgtos->NUM_PARC,3)+"]")
            GravaLinhaNFe( "Numero="         + ltrim(strzero(vNUMERO,8))+'-'+strzero(cadpgtos->NUM_PARC,2)+'/'+strzero(cadpgtos->TOT_PARC,2) )
            GravaLinhaNFe( "DataVencimento=" +        dtoc(cadpgtos->DATA_VENC) )
            GravaLinhaNFe( "Valor="          + alltrim(str(cadpgtos->VALOR)))
            select CadPgtos
            skip
         enddo
      endif
   endif
endif
select (ArqAntNFe)

*** Se for Exportacao Grava local embarque ***
if left(vCFOP,1)='7'
   GravaLinhaNFe( "[Exporta]")
   GravaLinhaNFe( "UFembarq="   + setup->ESTEMP )
   GravaLinhaNFe( "xLocEmbarq=" + setup->CIDEMP )
endif

*** Se for de veiculo ***
vDADOS_VEIC := ""
if !empty(GeralTXT->CHASSI)
   do case
      case GeralTXT->VIN == 'R'
	        vTXT_VIN      := 'Remarcado'
      case GeralTXT->VIN == 'N'
	        vTXT_VIN      := 'Normal   '
      other
           vTXT_FIN      := ''
   endcase

   do case
      case GeralTXT->RESTRICAO == '0' .or. GeralTXT->RESTRICAO=' '
           vTXT_REST           := 'NAO HA'
      case GeralTXT->RESTRICAO == '1'
           vTXT_REST           := 'ALIENACAO FIDUCIARIA'
      case GeralTXT->RESTRICAO == '2'
           vTXT_REST           := 'ARRENDAMENTO'
      case GeralTXT->RESTRICAO == '3'
           vTXT_REST           := 'RESERVA DOMINIO'
      case GeralTXT->RESTRICAO == '4'
           vTXT_REST           := 'PENHOR VEICULO'
      case GeralTXT->RESTRICAO == '9'
           vTXT_REST           := 'OUTRAS'
   endcase
   vDADOS_VEIC :="Chassi : "  + alltrim(GeralTXT->CHASSI)                                                        +;  //  Data do documento
                 iif( empty(GeralTXT->COR      ), "" , "   Cor : "             + alltrim(  ItemNf->COR))          +;  //  Codigo da Cor de cada montadora
                 iif( empty(GeralTXT->DESC_COR ), "" , "   Descricao Cor : "   + alltrim(  ItemNf->DESC_COR))     +;  //  Descricao da cor
                 iif( empty(GeralTXT->POTENCIA ), "" , "   Potencia : "        + alltrim(  ItemNf->POTENCIA))     +;  //  Potencia
                 iif( empty(GeralTXT->CM3      ), "" , "   Cil : "             + alltrim(  ItemNf->CM3))          +;  //  Potencia
                 iif( empty(GeralTXT->PESO_LIQ ), "" , "   Peso Liquido : "    + ltrim(str(ItemNf->PESO_LIQ,9)))  +;  //  Peso liquido
                 iif( empty(GeralTXT->PESO_BRU ), "" , "   Peso Bruto  : "     + ltrim(str(ItemNf->PESO_BRU,9)))  +;  //  Peso Bruto
                 iif( empty(GeralTXT->SERIAL   ), "" , "   Nro. Serie : "      + alltrim(  ItemNf->SERIAL))       +;  //  Numero de Serie
                 iif( empty(GeralTXT->TIPO_COMB), "" , "   Combustivel : "     + alltrim(  ItemNf->TIPO_COMB))    +;  //  Tipo de combustivel
                 iif( empty(GeralTXT->NRO_MOTOR), "" , "   Nro Motor : "       + alltrim(  ItemNf->NRO_MOTOR))    +;  //  Numero do motor
                 iif( empty(GeralTXT->CMT      ), "" , "   CMT : "             + alltrim(  ItemNf->CMT))          +;  //
		           iif( empty(GeralTXT->DIST_EIXO), "" , "   Entre Eixos : "     + alltrim(  ItemNf->DIST_EIXO))    +;  //  Distancia entre eixos
                 iif( empty(GeralTXT->ANO_MOD  ), "" , "   Ano/Modelo : "      + ltrim(str(ItemNf->ANO_MOD,4)))   +;  //  Ano modelo de fabricacao
                 iif( empty(GeralTXT->ANO_FAB  ), "" , "   Ano/Fabricacao : "  + ltrim(str(ItemNf->ANO_FAB,4)))   +;  //  Ano de fabricacao
                 iif( empty(GeralTXT->TIPO_PINT), "" , "   Tipo Pintura : "    + alltrim(  ItemNf->TIPO_PINT))    +;  //  Tipo de pintura
                 iif( empty(GeralTXT->TIPO_VEIC), "" , "   Tipo Veiculo : "    + alltrim(  ItemNf->TIPO_VEIC))    +;  //  Tipo de veiculo (Tabela RENAVAM)
                 iif( empty(GeralTXT->ESP_VEIC ), "" , "   Especie Veiculo : " + alltrim(  ItemNf->ESP_VEIC))     +;  //  Especie do veiculo (Tabela RENAVAM)
                 iif( empty(GeralTXT->VIN      ), "" , "   VIN : "             + alltrim(  ItemNf->VIN))              //  Identificacao do Numero do Veiculo
                 iif( empty(GeralTXT->RESTRICAO), "" , "   Restricao : "       + vTXT_REST)                           //  Tipo de restricao
endif
FimLin    := chr( 13 ) + chr( 10 )

select DBFNFe
go top

vLinhaINI := ''
do while !eof()
   *** grava comandos na Variavel INI ***
   vLinhaINI += alltrim(DBFNFe->LinhaNFe) + FimLin
   skip
enddo
inkey(.5)

select DBFNFe
use

*** Seta Arquivo de Origem ***
select (ArqAntNFe)
Igual_var()

TabelasSPED('MODALIDADEPGTOVENDA', vMODPGTO  , row(), col()+1, 'MODALIDADE', 'vMODPGTO'  , 'N', 0, .f.)
p_vendedor(vCOD_VEND, vFILIAL_VEN, .f.)
p_cfop(vCFOP,.f.)

*** Codificacao das Mensagens SPED ***
vCODMSG         :=''

*** Informacoes adicionais ***
vLinhaINI       += '[DadosAdicionais]'  + FimLin

*** SP0450 - Codigo 5001
vCODMSG         += '5001'
vLinhaINI       += "Complemento=Pz -> " + nf->PRAZO+"    ("+nf->NROVENDA+");"

*** SP0450 - Codigo 5002
vCODMSG         += '5002'
vLinhaINI       += 'ModPgto: '+str(vMODPGTO,2)+'-'+tabelas->RESUMIDO+'     '+iif(nf->CUPOM>0,'CUPOM FISCAL '+strzero(nf->CUPOM,6),'')+'    Vend : '+vFILIAL_VEN+'/'+strzero(vCOD_VEND,4)+'-' + vendedor->NOME + ";"

CriaDBFTotVendas('CADVENDA')
TotalizaFormasPgto(nf->FILIAL, nf->NROVENDA, .f. )
select TotalizaPGTOS
go top
CONTAFPG := 0
do while !eof()
   CONTAFPG++
   p_formapag(COD_PAG,.f.)
   vLinhaINI    += str(COD_PAG,2)+'-'+left(formapag->NOME,20)+'-'+transf(VLR_PROD,'@E 999,999.99')
   skip
   if !eof()
      CONTAFPG++
      p_formapag(COD_PAG,.f.)
      vLinhaINI += str(COD_PAG,2)+'-'+left(formapag->NOME,20)+'-'+transf(VLR_PROD,'@E 999,999.99')
   endif
   if CONTAFPG>3 .or. eof()
      vLinhaINI += ';'
      CONTAFPG  := 0
   endif
   skip
enddo
FechaDBFTotVendas()
FechaPgtos()

*** SP0450 - Codigo 5003
if !empty(nf->DADOS)
   vCODMSG      += '5003'
   vTXT1        := substr(nf->DADOS ,001,080)
   vTXT2        := substr(nf->DADOS ,081,080)
   vTXT3        := substr(nf->DADOS ,161,100)
   vLinhaINI    += iif(!empty(vTXT1), vTXT1+';','') + iif(!empty(vTXT2), vTXT2+';','') + iif(!empty(vTXT3), vTXT3+';','')
endif

if !empty(nf->DADOS2)
   vLinhaINI    += nf->DADOS2 + ';'
endif

*** SP0450 - Codigo 5004 (Todos os descontos abaixo no mesmo codigo)
if vDESC_PROD > 0
   vCODMSG      += '5004'
   *** o desconto sera calculado em cima do VALOR BRUTO DO ORCAMENTO ***
   vLinhaINI    += '* VLR BRUTO PROD='+transf(vBRUTO_PROD,'@E 9999,999.99')+'    DESCONTO='+transf(vDESC_PROD,'@E 999,999.99')+' *'
endif

if vDESC_SERV > 0
   vCODMSG      += '5005'
   vLinhaINI    += '* VLR BRUTO SERV='+transf(vBRUTO_SERV,'@E 9999,999.99')+'    DESCONTO='+transf(vDESC_SERV,'@E 999,999.99')+' *;'
endif

*** Dados do Cliente ***
vCODMSG         += '5006'
vLinhaINI       += 'Cliente : '+nf->FILIAL_CLI+'/'+strzero(nf->COD_CLI,5)+'-'+cadcli->FANTASIA

****************** REGISTROS ABAIXO TRATAM O SP0460 *************

*** SP0460 - Codigo 6001
if !empty(cfop->MENS_CFOP)
   vCODMSG      += '6001'
   vLinhaINI    += 'Mens CFOP : '+cfop->MENS_CFOP  + ";"
endif

*** verifica se o CFOP tem ISENCAO p/Deduzir ***
*** SP0460 - Codigo 6002
if nf->VLR_ISEN>0 .and. cfop->DED_ICMS='S'
   vCODMSG      += '6002'
   vLinhaINI    += '* Desconto Ref ICMS -> '+transf(nf->VLR_ISEN,'@E 99,999.99')+' *;'
endif

*** verifica se a NF tem BASE DE CALCULO REDUZIDA ***
*** SP0460 - Codigo 6003
if nf->REDUCAO
   vCODMSG      += '6003'
   vLinhaINI    += '* Base de Calculo Reduzida '+trim(mensagem->M_BASERED)+' *;'
endif

*** Calcula o % de retencao de imposto ***
*** SP0460 - Codigo 6004
if nf->VLR_RET>0
   vCODMSG      += '6004'
   vLinhaINI    += '* Retencao '+transf(cfop->PERC_RET,'@E 999.99%')+'='+transf(nf->VLR_RET,'@E 999,999.99')+' '+trim(mensagem->M_RET)+' *;'
endif

*** Calcula o % de Desconto da ALC ***
*** SP0460
if nf->VLR_ALC>0
  vCODMSG       += '6005'
  vLinhaINI     += '* Incentivo ALC('
  if cfop->ICMS_ALC>0
     vLinhaINI  += 'Base ICMS='   + transf(nf->BASE_ALC  ,'@E 999,999.99') + '  '+;
                   'Desc.ICMS='   + transf(cfop->ICMS_ALC,'@E 999.99%')+'='+alltrim(transf(nf->VLRICMSALC,'@E 999,999.99'))+' '
  endif
  if cfop->PIS_ALC>0
     vCODMSG    += '6006'
     vLinhaINI  += '*Desc.PIS='   + transf(cfop->PIS_ALC ,'@E 999.99%')+'='+alltrim(transf(nf->VLRPISALC ,'@E 999,999.99'))+' '
  endif
  if cfop->COF_ALC>0
     vCODMSG    += '6007'
     vLinhaINI  += '*Desc.COFINS='+ transf(cfop->COF_ALC ,'@E 999.99%')+'='+alltrim(transf(nf->VLRCOFALC ,'@E 999,999.99'))+';'
  endif
  vLinhaINI     += ') '+trim(mensagem->M_DESC_ALC)+';'
  if !empty(cadcli->SUFRAMA)
      vCODMSG   += '6008'
      vLinhaINI += 'SUFRAMA : '+NoMask(cadcli->SUFRAMA)+';'
  endif
endif

*** SP0460 - Codigo 6009
if nf->VLR_IRRF>0
   vCODMSG      += '6009'
   vLinhaINI    += '*Desconto Ref. IRRF='+transf(nf->VLR_IRRF,'@E 999,999.99')+' Sobre os Servicos *;'
endif

*** SP0460 - Codigo 6010
if vCOMSUBST .and. left(vCFOP,1)<>'7'
   vCODMSG      += '6010'
   vLinhaINI    += '*Substituicao Tributaria '+trim(mensagem->M_SUBST)+' *;'
endif

*** SP0460 - Codigo 6011
if vCOMISEN
   vCODMSG      += '6011'
   vLinhaINI    += '*Isencao de ICMS '+trim(mensagem->M_ISENCAO)+' *;'
endif

*** SP0460 - Codigo 6012
if vCOMSUSP
   vCODMSG      += '6012'
   vLinhaINI    += '*Suspensao de ICMS '+trim(mensagem->M_SUSP)+' *;'
endif

if nf->CRT_A=1 .or. nf->CRT_A=2
   vCODMSG      += '6013'
   vLinhaINI    += '*Empresa Optante Simples Nacional*;'
   ***vLinhaINI += 'NF emitida nos termos Art.57 Parag.10o Resolucao 94/2011'
   if nf->CRT_A=1 .and. nf->VLRICMS_SN > 0 .and. cfop->NATUREZA='A'  //  VENDA
      vLinhaINI += 'Base ICMS=' + transf(nf->BASE_SN ,'@E 999,999.99') + '  '+;
                   'Aliq ICMS=' + transf(nf->ICMS_SN ,'@E 99.99%')+'='+alltrim(transf(nf->VLRICMS_SN,'@E 999,999.99'))+' '
   endif
endif

if vSUSPENSAO_PIS .or.;
   vSUSPENSAO_COF
   vCODMSG      += '6014'
   vLinhaINI    += '*Suspensao PIS/COFINS '+trim(mensagem->M_DESC_ALC )+' *;'
endif

*** Mensagens Adicionais
*** vCODMSG     := 6015 --> Diferencial de Aliquota Ativo Permanente
*** vCODMSG     := 6016 --> Diferencial de Aliquota Uso e Consumo

if vDIFERIMENTO
   vCODMSG      += '6017'
   vLinhaINI    += '*Diferimento ICMS '+trim(mensagem->M_DIF )+' *;'
endif

*** Grava os codigos das Mensagens da NF ***
select NF
replace CODMSG with vCODMSG

*** Se for venda calcula o imposto e mostra a mensagem ***
if nf->VLR_IMP > 0
   vLinhaINI    += 'Vlr Aprox Tributos de acordo Tabela IBPT'
endif

if 'WAGNER ' $ vUSUARIO .or. 'MICROLINE' $ vUSUARIO
    FrmMsgErro( vLinhaINI )
endif

*** Busca o numero do LOTE NFe ***
select ARQUIVOS
set exact on
seek 'NFELOTE '
reglock(.f.)
replace ULT_COD with ULT_COD+1
dbcommit()
vLOTE := ULT_COD
arquivos->( dbunlock() )
set exact off

*** Cria XML e enviar ***
ACBR_CriarXMLEnviarNFe(vLinhaINI, vLOTE, 0)
select (ArqAntNFe)
return(.t.)






/*

Primeira consulta. Resultou vazia porque no intervalo de 50.000 notas
iniciadas com o NSU que informei, nenhuma delas foi destinada ao meu CNPJ:

23/04/2013 17:17:32 - Nfe.ConsultaNFeDest("99999999999999","0","0","6943982783")
 OK:
 versao=1.01
 tpAmb=1
 verAplic=1.0.0
 cStat=137
 xMotivo=Nenhum documento localizado para o destinatario
 dhResp=23/04/2013 17:17:16
 indCont=1
 ultNSU=6944482783



Dentro do loop, acaba acontecendo de surgir uma ou mais notas:

23/04/2013 17:17:34 - Nfe.ConsultaNFeDest("99999999999999","0","0","6944482782")
 OK:
 versao=1.01
 tpAmb=1
 verAplic=1.0.0
 cStat=138
 xMotivo=Documento localizado para o destinatario
 dhResp=23/04/2013 17:17:18
 indCont=1
 ultNSU=6944982782

 [RESNFE001]
 NSU=6944644777
 chNFe=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

CNPJ=99999999999999
 xNome=EXEXRXCXL - XLXTXIXA XOXEXCXAX LTDA
 IE=999999999
 dEmi=23/04/2013
 tpNF=1
 vNF=390,31
 digVal=mV7T+ck85A9lVRADBOQQUgRQEOU=
 dhRecbto=23/04/2013 15:36:26
 cSitNFe=3
 cSitConf=0

 [RESCANC001]
 NSU=6944933322
 chNFe=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

CNPJ=99999999999999

xNome=EXEXRXCXL - XLXTXIXA XOXEXCXAX LTDA

IE=999999999

dEmi=23/04/2013
 tpNF=1
 vNF=390,31
 digVal=mV7T+ck85A9lVRADBOQQUgRQEOU=
 dhRecbto=23/04/2013 15:36:26
 cSitNFe=3
 cSitConf=0


Repare que no arquivo de resposta as notas resultantes recebem
numeração sequencial dentro da consulta no exemplo,.
RESNFE001 representa a primeira nota resultante na página.
Se retornasse outra nota, a mesma receberia a identificação RESNFE002,
e assim sucessivamente até o limite de RESNFE050. Repare que, no caso
do retorno RESNFE001, logo em seguida vem a informação de que a nota
foi cancelada, confirmando a  cSitNFe=3 e permitindo que você armazene
os dados de cancelamento, se quiser. Entenda que o tratamento deve ser
linha-a-linha, semelhante ao que se faz no TEF.









Membros
PipPip
60 posts
LocalizaçãoVitória - ES


Postado 29 April 2013 - 05:53 PM


O mais correto é utilizar o retorno indCont. Enquanto ele for = '1' existem notas a serem consultadas, quando ele retornar '0' indicará o verdadeiro fim da consulta.



Entre o '1' e o '0', chegarão alguns retornos vazios e alguns com notas. Isso se dá porque a consulta é sequencial no servidor da SEFAZ e é paginada de 50.000 em 50.000 notas na ordem em que forão recebidas e autorizadas. O limite do retorno é de 50 por consulta. Nenhuma nota será retornada pela consulta, apenas os dados básicos para identificação dela:



nsu = Número Sequencial Único da nota, gerado em ordem de chegada no servidor da SEFAZ;
 chnfe= Chave da NFe;
 cnpj= CNPJ do Emitente da NFe;
 xnome= Razão Social do Emitente da NFe;
 ie= Inscrição Estadual do Emitente da NFe;

demi= Data da Emissão da NFe;
 tpnf= Tipo da NFe 0 = Entrada 1 = Saída;
 vnf=' Valor da NFe;
 digval = Dígitos de Validação;
 dhrecbto = Data/Hora em que a NFe foi recebida pela SEFAZ;
 csitnfe = Situação da NFe  (1=Normal 3=Cancelada);
 csitconf = Situação da Confirmação da NFe (0=Não Manifestada, 1=Confirmada, 2=Desconhecimento 3=Não Realizada 4=Ciência da Operação);




 outro exemplo



NFE.ENVIAREVENTO("[EVENTO]

idLote=1

[EVENTO001]

chNFe=111306XXXXXXXXXXXXXXXXX0XXXXXXXXXX4246

CNPJ=0XXXXXXXXXX67

dhEvento=25/06/13 11:35:38

tpEvento=210210

")

*/

