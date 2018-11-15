*  PRG......................: IMPACBR
* CLASSE...................: Impressora Fiscal com ACBrMonitor
* DESC.....................: Abre porta, envia comandos, sub porta
* PREFIXO..................: IBR
* EXPORTADORA..............: IBR_*
* CONSTRUTORA..............: IBR_INIT()
* DESTRUTORA...............: IBR_END()
* AUTOR....................: DANIEL SIMOES DE ALMEIDA
* DATA.....................: JANEIRO DE 2006
* USA......................:
* NOTAS....................: Deve ser compilada com /n uma vez que utiliza
*                            estatica externa. Nao ha construtora.
*                            Trapaceamos e inicializamos com uma estatica
*                            externa!


#include "fileio.ch"
#include "commands.ch"
#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"
#include "winprint.ch"

#define  ETX chr(3)
#define  CR  chr(13)
#define  LF  chr(10)

#define COR_ERRO RGB(0,0  , 255)  //azul forte 
#define ENT_TXT  'ENT.TXT'
#define SAI_TXT  'SAI.TXT'
#define TMP_TXT  'ENT.TMP'

#include "fileio.ch"
#include "commands.ch"

#define  ETX chr(3)
#define  CR  chr(13)
#define  LF  chr(10)

#define ENT_TXT  'ENT.TXT'
#define SAI_TXT  'SAI.TXT'
#define TMP_TXT  'ENT.TMP'


Static sENDER   := ''  ,;
       SEM_ERRO := .F. ,;
       sSECHORA := 0   ,;
       sRETHORA := ''  ,;
       sSECCOO  := 0   ,;
       sNUMCUPOM:= ''  ,;
       sSECEST  := 0   ,;
       sESTADO  := ''

#ifdef __XHARBOUR__
Static sSOCKET
#endif



************************************************************************
Function IBR_INIT(ENDERECO)   // Abre a comunicação com o ACBrmonitor
************************************************************************
Local P, RET := .T., TFIM, IP, PORTA, RESP

if ! empty(sENDER)  // J  est  aberto...
   return .t.
endif

SEM_ERRO := .F.
sENDER   := alltrim(ENDERECO)
IP       := ''
PORTA    := 0

#ifdef __XHARBOUR__
if ! (PATH_DEL $ sENDER)   /// Abrir comunicacao TCP/IP
   P := at(':',sENDER)
   if P = 0
      P := len(sENDER)+1
   endif

   IP    := substr(sENDER,1,P-1)
   if empty(IP)
      RET := .F.
   else
      PORTA := val(substr(sENDER,P+1))
      if PORTA = 0
         PORTA := 3434
      endif

      inetinit()
      RET := .F.

      TFIM := Seconds() + 5             /// Tenta conectar durante 5 segundos ///
      do while Seconds() < TFIM .and. ! RET
         sSOCKET := inetconnect(IP,PORTA)
         RET     := (ineterrorcode(sSOCKET) = 0)
      millisec(250)
  
      enddo
   endif

   if RET
      InetSetTimeout( sSOCKET, 3000 )   // Timeout de Recepção 3 seg //
      RESP := InetRecvEndBlock( sSOCKET, ETX )
      RET  := ('ACBrMonitor' $ RESP )   // Recebeu as boas vindas ?
   endif
endif
#endif

if PATH_DEL $ sENDER   /// Abrir comunicacao TXT
   if right(sENDER,1) <> PATH_DEL
      sENDER := sENDER + PATH_DEL
   endif
endif

if ! RET
   sENDER := ''
endif

return RET

************************************************************************
Function IBR_OK(RESP)   // Retorna .T. se a String inicia com OK:
************************************************************************

return (substr(RESP,1,3) == 'OK:')


***********************************************************************
Function IBR_ABRE_GAVETA()  // Abre Gaveta da Impressora, retorna .t. se abriu
***********************************************************************

   RET := IBR_COMANDO( "ECF.Ativo" )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
   endif

   if sEstado="FALSE"
   *  ycomunica_Impressora_Fiscal( "ECF.Ativar" )
   
   ENDIF

IBR_ESTADO()
IBR_COMANDO( 'AbreGaveta', , 6 )

return IBR_GAVETA_ABERTA()

***********************************************************************
Function IBR_GAVETA_ABERTA()  // Retorna .t. se Gaveta est  aberta
***********************************************************************

return (upper(substr(IBR_COMANDO( 'GavetaAberta' ),5,5)) = 'TRUE')

************************************************************************
Function IBR_LEITURAX()   // Imprime relatorio de Leitura X, retorna .t. se ok
************************************************************************


//---------------------------
ACBr_ATIVAR()
//--------------------------------------------
   RET := IBR_COMANDO( "ECF.Ativo" )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
   endif
//--------------------------------------------

   if sEstado="FALSE" 
      IBR_COMANDO( "ECF.Ativar" )
      MsgINFO("Monitor nao Ativo VERIFIQUE")  
   endif
//---------------------------------------------

if sSECEST <> seconds()
   RET := IBR_COMANDO( 'PoucoPapel' )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
      sSECEST := seconds()
XESTADO:="PAPEL OK.." 
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+XESTADO
 else
  sESTADO := ''
XESTADO:="VERIFIQUE O PAPEL "
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+XESTADO
endif
endif

//--------------------------------------------------
if sEstado="TRUE" 
MsgINFO("Pauco Papel por favor VERIFIQUE")
ENDIF

if sSECEST <> seconds()
   RET := IBR_COMANDO( 'Estado' )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
      sSECEST := seconds()
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+sESTADO
   else
      sESTADO := ''
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+sESTADO
   endif
endif

   if MsgYesNo("Tem certeza que deseja imprimir a leitura X ?", "Cupom Fiscal...")
	return IBR_OK( IBR_COMANDO( 'LeituraX', , 45 ) )
    endif

************************************************************************
Function IBR_REDUCAOZ()   // Imprime relatorio de Reducao Z, retorna .t. se ok
************************************************************************


//---------------------------
ACBr_ATIVAR()
//--------------------------------------------
   RET := IBR_COMANDO( "ECF.Ativo" )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
   endif
//--------------------------------------------

   if sEstado="FALSE" 
      IBR_COMANDO( "ECF.Ativar" )
      MsgINFO("Monitor nao Ativo VERIFIQUE")  
   endif
//---------------------------------------------

if sSECEST <> seconds()
   RET := IBR_COMANDO( 'PoucoPapel' )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
      sSECEST := seconds()
XESTADO:="PAPEL OK.." 
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+XESTADO
 else
  sESTADO := ''
XESTADO:="VERIFIQUE O PAPEL "
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+XESTADO
endif
endif

//--------------------------------------------------
if sEstado="TRUE" 
MsgINFO("Pauco Papel por favor VERIFIQUE")
ENDIF

if sSECEST <> seconds()
   RET := IBR_COMANDO( 'Estado' )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
      sSECEST := seconds()
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+sESTADO
   else
      sESTADO := ''
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+sESTADO
   endif
endif

  if MsgYesNo("Tem certeza que deseja imprimir a REDUÇÃO Z ?", "Cupom Fiscal...")
	return IBR_OK( IBR_COMANDO( 'ReducaoZ', {dtoc(date())+' '+time()}, 40 ))
   endif

***********************************************************************
Function IBR_CAN_CUPOM()  // Cancela Cupom fiscal, retorna .t. se ok
***********************************************************************



//---------------------------
ACBr_ATIVAR()
//--------------------------------------------
   RET := IBR_COMANDO( "ECF.Ativo" )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
   endif
//--------------------------------------------

   if sEstado="FALSE" 
      IBR_COMANDO( "ECF.Ativar" )
      MsgINFO("Monitor nao Ativo VERIFIQUE")  
   endif
//---------------------------------------------

if sSECEST <> seconds()
   RET := IBR_COMANDO( 'PoucoPapel' )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
      sSECEST := seconds()
XESTADO:="PAPEL OK.." 
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+XESTADO
 else
  sESTADO := ''
XESTADO:="VERIFIQUE O PAPEL "
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+XESTADO
endif
endif

//--------------------------------------------------
if sEstado="TRUE" 
MsgINFO("Pauco Papel por favor VERIFIQUE")
ENDIF

if sSECEST <> seconds()
   RET := IBR_COMANDO( 'Estado' )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
      sSECEST := seconds()
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+sESTADO
   else
      sESTADO := ''
*MODIFY CONTROL ESTADO OF FORM_PDV Value  ""+sESTADO
   endif
endif

    if MsgYesNo("Tem certeza que deseja cancelar este cupom fiscal ?", "Cupom Fiscal...")
       return IBR_OK( IBR_COMANDO( 'CancelaCupom', , 14 ) )
    endif




************************************************************************
Function IBR_INI_FECHA( WDESC_ACRES )
* Inicia FECHAMENTO de Cupom Fiscal com Formas de Pagto, retorna .t. se OK
* WDESC_ACRES -> Numerico, Desconto/Acrescimo em VALOR, concedido para o
*                cliente. Se positivo ACRESCIMO senao DESCONTO
************************************************************************

return IBR_OK( IBR_COMANDO( 'SubTotalizaCupom',{WDESC_ACRES}, 5 ))

************************************************************************
Function IBR_PAGTO( WVALOR, WCODFPG, WOBS, WVINC )
* Efetua Pagamento em Cupom. Deve ser executada apos IBR_INI_FECHA
* Retorna .t. se OK
* WVALOR -> Valor Numerico pago pela Forma de Pagamento
* WCODFPG -> Codigo da Forma de Pagamento, pode ser achado com IBR_ACHA_PG
* WOBS -> Texto de 80 caracteres para OBS
* WVINC -> Boleano, se .t. ter  Cupom NAO Fiscal vinculado a esta FPG
*          (nao ‚ necess rio na Bematech)
************************************************************************

return IBR_OK( IBR_COMANDO( 'EfetuaPagamento',{WCODFPG, WVALOR, WOBS, WVINC}) )

************************************************************************
Function IBR_FIM_FECHA( WMSG, WCOLUNAS )
* FECHA Cupom Fiscal, retorna .t. se OK
* WMSG -> String, Mensagem promocional, linhas separadas por '|'
*         checagem de colunas ‚ feita por IMF_FIM_FECHA
* WCOLUNAS -> ajustada por PAI IMF_FIM_FECHA
************************************************************************

sSECCOO := 0
return IBR_OK( IBR_COMANDO( 'FechaCupom',{WMSG}, 20 ) )

************************************************************************
Function IBR_CAN_ITEM(WITEM)  // Cancela Item do Cupom fiscal, retona .t. se ok
* WITEM -> Numerico com Codigo sequencial do Item a cancaler
*  Ex.: 1 cancela o primeiro item vendido.
************************************************************************

return IBR_OK( IBR_COMANDO( 'CancelaItemVendido',{WITEM}) )


************************************************************************
Function IBR_ESTADO()
* Retorna .t. se Iniciou o Fechamento do Cupom e estiver esperando
* Formas de Pagamento
************************************************************************
Local RET

if sSECEST <> seconds()
   RET := IBR_COMANDO( 'Estado' )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
      sSECEST := seconds()
   else
      sESTADO := ''
   endif

if sEstado=="TRUE"
  * ALERT("OK")
elseif sEstado=="FALSE"
   msgstop('Impressora nao esta pronta. VERIFIQUE','Atenção')
          
endif

If sEstado=="ESTREQUERX"
   IBR_LEITURAX()
ENDIF

If sEstado=="ESTNAOINICIALIZADA"
   RET := IBR_COMANDO( "ECF.Ativo" )
   if left(RET,3) == 'OK:'
      sESTADO := upper(alltrim(substr(RET,5)))
   endif
if sEstado="FALSE"
    *  ycomunica_Impressora_Fiscal( "ECF.Ativar" )
   ENDIF
*   ALERT("A impressora nao esta ativa; Por ative no monitor da impressora fiscal AcbrMonitor; caso nao consiga entre em contato com o suporte tacnico...")
ENDIF

endif

return sESTADO



Static Function Grava_ARQ( WARQ, WTXT )
Local HANDLE, RET := .T.

HANDLE := fcreate(WARQ, FC_NORMAL )
if HANDLE > 0
   fwrite(HANDLE, WTXT + chr(13) + chr(10) )
   RET := (ferror() = 0)

   fclose(HANDLE)
endif

RETURN RET


FUNC ERROROSMESSAGE 


Function ACBr_ATIVAR()
Local Tela1:= SaveScreen(13,25,17,60)
Local Cor:= SetColor() 
Local mCGC:= Space(18)
 //Ativa o ACBr

public CONF_SOCKET :=meuip


IBR_INIT(CONF_SOCKET)
  If !IBR_OK(IBR_COMANDO( 'Ativar', , 45 ))
   Return (.F.)
  Endif
Return (.T.)


Function ACBr_ATIVAR1()
Local Tela1:= SaveScreen(13,25,17,60)
Local Cor:= SetColor() 
Local mCGC:= Space(18)
 //Ativa o ACBr

public CONF_SOCKET :=meuip

IBR_INIT(CONF_SOCKET)
  If !IBR_OK(IBR_COMANDO( 'Ativar', , 45 ))
   Return (.F.)
  Endif
Return (.T.)


************************************************************************
Function IBR_SUBTOTAL()   // Retorna o Subtotal do cupom aberto
************************************************************************
Local WSTR

WSTR := substr(IBR_COMANDO( 'SubTotal' ),5)

return val(StrTran(WSTR,',','.'))


************************************************************************
Function IBR_vendabruto()   // Retorna o Subtotal do cupom aberto
************************************************************************
Local WSTb

WSTb := substr(IBR_COMANDO( 'vendabruta' ),5)

return val(StrTran(WSTb,',','.'))


************************************************************************
Function IBR_COMANDO(CMD,VET_PARAM,ESPERA,TENTA)
* Funcao de uso interno para enviar os comandos para a impressora e
* registrar os erros retornados pela mesma. Exibe os erros se existirem
************************************************************************
Local RET_IMP, REQ, RESP, TEMPOR, TINI, TFIM, BLOCO, BYTES, I, TIPO_PARAM

* wn_mensasplash('CUMINICANDO COM A ECF AGUARDE...')

DEFAULT VET_PARAM   to {} ,;
        ESPERA      to 0  ,;
        TENTA       to .t.

///// Codificando CMD de acordo com o protocolo /////
RET_IMP  := ''

if ! ('.' $ left(CMD,5))   // Informou o Objeto no Inicio ?
   CMD := 'ECF.'+CMD       // Se nao informou assume ECF.
endif

if len(VET_PARAM) > 0
   CMD := CMD + '(' ;

   For I := 1 to len(VET_PARAM)
     TIPO_PARAM := valtype(VET_PARAM[I])

     if TIPO_PARAM = 'C'
        // Converte aspas para simples para aspas duplas, para o ACBrMonitor
        CMD := CMD + '"'+ StrTran( RTrim(VET_PARAM[I]), '"', '""' ) + '"'

     elseif TIPO_PARAM = 'N'
        CMD := CMD + strtran(alltrim(Str(VET_PARAM[I])),',','.')

     elseif TIPO_PARAM = 'D'
        CMD := CMD + dtoc( VET_PARAM[I] )

     elseif TIPO_PARAM = 'L'
        CMD := CMD + iif( VET_PARAM[I],'TRUE','FALSE')

     endif

     CMD := CMD + ', '
   next

   CMD := substr(CMD,1,len(CMD)-2) + ')'
endif

CMD := CMD + CR+LF
    
if ! SEM_ERRO
     ESPERA := max(ESPERA,5)
else
   TENTA := .F.
  endif

if PATH_DEL $ sENDER               /// E' TXT ? ///
   REQ    := sENDER + ENT_TXT
   RESP   := sENDER + SAI_TXT
   TEMPOR := sENDER + TMP_TXT


  //////// Transmitindo o comando /////////
   TFIM := seconds() + 3    // Tenta apagar a Resposta anterior em ate 3 segundos
   do while file( RESP )
      if ferase( RESP ) = -1
         if (seconds() > TFIM)
            RET_IMP := 'ERRO: Nao foi possivel apagar o arquivo: ('+RESP+') '+;
                       ErrorOsMessage(ferror())
         else
            millisec(20)
         endif
      endif
   enddo

   do while empty(RET_IMP)
      TFIM := seconds() + 3    // Tenta apagar a Requisicao anterior em ate 3 segundos
      do while file( REQ )
         if ferase( REQ ) = -1
            if (seconds() > TFIM)
               RET_IMP := 'ERRO: Nao foi possivel apagar o arquivo: ('+REQ+') '+;
                          ErrorOsMessage(ferror())
            else
               millisec(20)
            endif
         endif
      enddo
* wn_mensasplash('CUMINICANDO COM A ECF AGUARDE...')

	 
      // Criando arquivo TEMPORARIO com a requisicao //
      if empty(RET_IMP)
         if ! Grava_ARQ(TEMPOR, CMD)

            RET_IMP := 'ERRO: Nao foi possivel criar o arquivo: ('+TEMPOR+') '+;
                       ErrorOsMessage(ferror())
         endif
      endif

      // Renomeando arquivo TEMPORARIO para REQUISICAO //
      if empty(RET_IMP)
         if frename(TEMPOR, REQ) = -1
            RET_IMP := 'ERRO: Nao foi possivel renomear ('+TEMPOR+') para ('+REQ+') '+;
                       ErrorOsMessage(ferror())
         endif
      endif

      // Espera ACBrMonitor apagar o arquivo de Requisicao em ate 7 segundos
      // Isso significa que ele LEU o arquivo de Requisicao
      TFIM := seconds() + 7
      do while empty(RET_IMP) .and. (seconds() <= TFIM) .and. file(REQ)
         millisec(20)
      enddo
		   
      if file(REQ)
         if ! TENTA
            RET_IMP := 'ERRO: ACBrMonitor nao esta ativo'
         else
       		//////////////////////////////abaixo sim ou nao 
               if ! file(REQ)  // ACBrMonitor "acordou" enquanto perguntava
                  exit
               endif
            endif
      else
         exit
      endif
   enddo

     	 
   //////// Lendo a resposta ////////
   TINI   := Seconds()
   TELA   := savescreen(23,1,23,78)
   do while empty(RET_IMP)
      if file(RESP)
         RET_IMP := alltrim(memoread( RESP ))
      endif

      if empty(RET_IMP)
         if Seconds() > (TINI + 50)
            LinhaDeStatus('Aguardando resposta do ACBrMonitor:  '+; // '('+ProcName(2)+') '+;
                         Trim(str(TINI + ESPERA - seconds(),2)),77) 
         endif
  	 
    
	  if Seconds() > (TINI + ESPERA)
              if ! TENTA
               RET_IMP := 'ERRO: Sem resposta do ACBrMonitor em '+alltrim(str(ESPERA))+;
                      ' segundos (TimeOut)'
                else
				*MsgInfo ("eCF NAO ESTA PRONTA")
						
                 if MsgInfo ('A Comunicação com a Ecf Não esta respondendo |'+;
                         'Deseja tentar novamente ?',{'SIM','NAO'}) # 1
                  RET_IMP := 'ERRO: Sem resposta do ACBrMonitor em '+alltrim(str(ESPERA))+;
                    ' segundos (TimeOut)'
                
			      else
                 TINI := Seconds()
                 endif
 

           endif
         endif
         millisec(20)
	 endif
 enddo
 
	
  ferase( strtran(RESP,'.TXT','.OLD') )
  frename( RESP, strtran(RESP,'.TXT','.OLD') )
  ferase( RESP )
   #IFDEF __XHARBOUR__
   else                                       //// TCP / IP (apenas xHarbour ) ///
   //////// Transmitindo o comando /////////
   InetSetTimeout( sSOCKET, 3000 )   // Timeout de Envio 3 seg //
   if inetsendall( sSocket, CMD ) <= 0
      RET_IMP := 'ERRO: Nao foi possivel transmitir dados para o ACBrMonitor|'+;
                 '('+AllTrim(Str(InetErrorCode( sSOCKET )))+') '+;
                 InetErrorDesc( sSOCKET ) + ETX
   endif

   //////// Lendo a resposta ////////
   InetSetTimeout( sSOCKET, 500 )
   TINI   := Seconds()
   TELA   := savescreen(23,1,23,78)
   do while (right(RET_IMP,1) <> ETX)
      BLOCO := space(64)
      BYTES   := inetrecv(sSOCKET, @BLOCO, 64)
      RET_IMP += left(BLOCO,BYTES)
	  
      if Seconds() > (TINI + 5)
          LinhaDeStatus('Aguardando resposta do ACBrMonitor:  '+; // '('+ProcName(2)+') '+;
                      Trim(str(TINI + ESPERA - seconds(),2)),77) 
          endif

      if Seconds() > (TINI + ESPERA)
         restscreen(23,1,23,78,TELA)


         if ! TENTA
            RET_IMP := 'ERRO: Sem resposta do ACBrMonitor em '+alltrim(str(ESPERA))+;
                       ' segundos (TimeOut)' + ETX
         else
if msgyesno("Deseja tentar novamente",{"Sim","Nao"})
              else
               TINI := Seconds()
            endif
         endif
      endif
   enddo
#ENDIF
endif

do while right(RET_IMP,1) $ CR+LF+ETX   // Remove sinalizadores do final
   RET_IMP := left(RET_IMP,len(RET_IMP)-1)
enddo

if ! SEM_ERRO
   MSG_ERRO := ''
   if substr(RET_IMP,1,5) == 'ERRO:'
      MSG_ERRO := 'Erro ACBrMonitor|'+;  //  'Rotina ('+ProcName(2)+')|'+;
                  strtran(strtran((substr(RET_IMP,7)),CR,''),LF,'|')
 
 RET_IMP := ''
   endif
endif
*wn_mensasplash('CUMINICANDO COM A ECF AGUARDE...')

* MsgINFO("ERRO NA COMUNICAÇÃO ECF VERIFIQUEGGGGG") 
*janela1.RELEASE
return RET_IMP




************************************************************************
Function IBR_RELATORIO(WTXT,WTXT1,WVIAS,WCOLUNAS) // Imprime relatorio Gerencial
* Retorna .T. se imprimiu com sucesso
* WTXT  -> texto a Imprimir no relatorio, quebra de linhas = '|'
* WVIAS -> Numero de vias a imprimir 1 ou 2, padrao 1
* WCOLUNAS -> Numero m ximo de colunas da impressora, ajustada por IMF_RELATORIO
************************************************************************
Local VET,A,RET,WIMP

DEFAULT WVIAS to 1

VET  := SEPARA_STR(WTXT,'|')  // Separa as linhas de WTXT
*VET  := SEPARA_STR(WTXT1,'|')  // Separa as linhas de WTXT
WIMP := 0
RET  := .T.

*WTXT:="SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"+("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")


//IBR_FIM_REL()   // Fecha se ficou algum aberto

//// Imprime relatorio gerencial ////
*MSG_SAVE('Aguarde Imprimindo Relat¢rio...')
RET := IBR_OK( IBR_COMANDO( 'AbreRelatorioGerencial', , 45 ) )

do while RET
//   A := 1
//   do while RET .and. A <= len(VET)
//      RET := IBR_OK( IBR_COMANDO( 'LinhaRelatorioGerencial',{VET[A]} ) )
//      A++
//   enddo

   RET := IBR_OK( IBR_COMANDO( 'LinhaRelatorioGerencial',{WTXT},  Int(len(VET)/1.5)+4 ) )
  * RET := IBR_OK( IBR_COMANDO( 'LinhaRelatorioGerencial',{WTXT1}, Int(len(VET1)/1.5)+4 ) )

   WIMP++

   if ! RET .or. WIMP >= WVIAS
      exit
   endif

   IBR_COMANDO( 'LinhaRelatorioGerencial',{' | | | | | | '}, 5 )
   clear typeahead
  * MSG('  **  DESTAQUE A '+trim(str(WIMP,2))+'¦ VIA **              ENTER - Imprime pr¢xima via',8)
enddo

*if RET
*   RET := IBR_FIM_REL()
*endif

clear typeahead
*MSG_REST()

return RET

**************************************************************************
Function SEPARA_STR(STR_SEPARA,DELIMITADOR,FECHA_STR,COM_FECHA)
* Retorna vetor com strings separadas entre DELIMITADOR. As strings nao
* incluem o delimitador.
* STR_SEPARA -> String a separar,
* DELIMITADOR -> Caracter que divide a string
* FECHA_STR -> Caracter que fecha abas de uma separacao. Se nulo nao usa.
*               Util para ignorar os DELIMITADORES entre os FECHA_STR
* COM_FECHA -> Logico. Se verdadeiro, inclui as caracteres FECHA_STR na
*              string de retorno.
**************************************************************************
LOCAL PROX_DELIM,VSTR := {},PROX_FECHA,TEXTO

DEFAULT DELIMITADOR to ',',;
        FECHA_STR to '',;
        COM_FECHA to .t.

do while len(STR_SEPARA) > 0
   PROX_FECHA := 1
   if len(FECHA_STR) > 0    // Se possuir FECHA_STR localiza o proximo
      PROX_FECHA := NAT(FECHA_STR,STR_SEPARA,2)
      PROX_FECHA := iif(empty(PROX_FECHA),1,PROX_FECHA)
   endif
****** Acha o proximo delimitador e adiciona o PROX_FECHA (comeco) ******
   PROX_DELIM := at(DELIMITADOR,substr(STR_SEPARA,PROX_FECHA))
   PROX_DELIM := iif(empty(PROX_DELIM),len(STR_SEPARA)+1,PROX_DELIM + PROX_FECHA - 1)
   TEXTO := substr(STR_SEPARA,1,PROX_DELIM - 1)

   if len(FECHA_STR) > 0 .and. ! COM_FECHA   // Verifica se tira os FECHA_STR
      TEXTO := strtran(TEXTO,FECHA_STR)
   endif

   TEXTO := iif(len(TEXTO) = 0,' ',TEXTO)
   aadd(VSTR,TEXTO)
   STR_SEPARA := substr(STR_SEPARA,PROX_DELIM + len(DELIMITADOR))
enddo

return VSTR

************************************************************************
Function NAT(CARACTER,TEXTO,OCORRENCIA) // Retorna a posicao da enesima
*                                          ocorrencia do caracter
* CARACTER - Caracter a ser localizado, TEXTO - Texto a ser pesquisado,
* OCORRENCIA - Numero da ocorrencia dentro do TEXTO, se a OCORRENCIA
* for 0 , retorna o numero de vezes que CARACTER aparace em TEXTO
************************************************************************
LOCAL POSICAO,RESTO,N_ACHADO,TAMTEXT,POSAT

DEFAULT OCORRENCIA to 1

N_ACHADO := 0
TAMTEXT := len(TEXTO)
POSICAO := 1
do while (N_ACHADO < OCORRENCIA) .or. (OCORRENCIA = 0)
   POSAT := at(CARACTER,substr(TEXTO,POSICAO,TAMTEXT))
   if POSAT = 0
      POSICAO := 1
      exit
   endif
   POSICAO += POSAT
   N_ACHADO++
enddo

if empty(OCORRENCIA)
   return N_ACHADO
endif

return POSICAO - 1




************************************************************************
Function IBR_FIM_REL() // Encerra relatorio Gerencial e ou C.V.
************************************************************************
local RET
SEM_ERRO := .T.
RET := IBR_OK( IBR_COMANDO( 'FechaRelatorio', , 20 ) )
SEM_ERRO := .F.
return RET





************************************************************************
Function IBR_ACHA_ALIQ(WALIQ)  // Retorna codigo do Totalizador (String 2)
* equivalente a WALIQ passada, se nao encontrar volta "  "
* WALIQ -> Numerico, % do ICMS a localizar o Totalizador.
************************************************************************
Static VET_ALIQ
Local POS:=0

if VET_ALIQ = NIL
   VET_ALIQ := IBR_ALIQ()
endif

*POS := ascan(VET_ALIQ,{|x|x[1] = WALIQ})

return iif(empty(POS),"  ",VET_ALIQ[POS,2])




************************************************************************
Function IBR_ALIQ1()  // Retorna vetor bi-dimensional com os codigos
* das aliquotas no formato {ALIQ(N 5,2),COD_ALIQ(C 2)}
* Fun‡ao de uso interno, pela funcao (IBR_ACHA_ALIQ())
************************************************************************
Local RET_IMP,VET_RET:={},P,S

RET_IMP := IBR_COMANDO( 'CarregaAliquotas', , 10 )
if IBR_OK( RET_IMP)
   RET_IMP := substr(RET_IMP,5)

   do while ! empty(RET_IMP)
      P := at('|',RET_IMP)
      if P = 0
         P := len(RET_IMP)+1
      endif

      S := substr(RET_IMP,1,P-1)

      aadd(VET_RET, {val(strtran(substr(S,6,6),',','.')), substr(S,1,4)} )
      RET_IMP := substr(RET_IMP,P+1)
   enddo
endif

return VET_RET


************************************************************************
Function IBR_achaaliq(WITEM)  // Cancela Item do Cupom fiscal, retona .t. se ok
* WITEM -> Numerico com Codigo sequencial do Item a cancaler
*  Ex.: 1 cancela o primeiro item vendido.
************************************************************************
return IBR_OK( IBR_COMANDO( 'AchaIcmsAliquota',{WITEM}) )


************************************************************************
Function IBR_SANGRIA(WITEM)  // Cancela Item do Cupom fiscal, retona .t. se ok
* WITEM -> Numerico com Codigo sequencial do Item a cancaler
*  Ex.: 1 cancela o primeiro item vendido.
************************************************************************
return IBR_OK( IBR_COMANDO( 'SANGRIA',{WITEM}) )

************************************************************************
Function IBR_SUPRIMENTO(WITEM)  // Cancela Item do Cupom fiscal, retona .t. se ok
* WITEM -> Numerico com Codigo sequencial do Item a cancaler
*  Ex.: 1 cancela o primeiro item vendido.
************************************************************************
return IBR_OK( IBR_COMANDO( 'SUPRIMENTO',{WITEM}) )
************************************************************************
Function IBR_FIM_PAPEL()  // Retorna .t. se for pouco papel
************************************************************************

return (upper(substr(IBR_COMANDO( 'SEMPAPEL' ),5,5)) = 'TRUE')


************************************************************************
Function IBR_ACHA_PG(WPAGAMENTO,WVINC)  // Retorna codigo do Totalizador (String 2)
* equivalente a Forma de Pagamento passada se nao encontrar tenta cadastrar
* se conseguir retorna o novo numero, se nao conseguir encontrar nem
* cadastrar retorna "  "
* WPAGAMENTO -> String de 16, com Pagamento a localizar/Cadastra.
* WVINC -> Passado por referencia, Informa.T. se a Forma de Pagamento pode
*          imprimir Cupom Fiscal Vinculado
************************************************************************
Local RET_IMP, RET:=''

SEM_ERRO := .T.
RET_IMP  := IBR_COMANDO( 'AchaFPGDescricao',{(WPAGAMENTO)}, 8 )
SEM_ERRO := .F.
if IBR_OK( RET_IMP )
   RET_IMP := substr(RET_IMP,5)

   if ! empty(RET_IMP)
      RET   := alltrim(substr(RET_IMP,1,4))
      WVINC := (substr(RET_IMP,5,1)<>' ')
   endif
endif

return RET

************************************************************************
Function IBR_ACHA_CNF(WDESCRICAO,WVINC)  // Retorna codigo do CNF
* WDESCRICAO -> String de 16, com CNF a localizar
* WVINC -> Passado por referencia, Informa.T. se a Forma de Pagamento pode
*          imprimir Cupom Fiscal Vinculado
************************************************************************
Static VET_CNF:={}
Local RET_IMP,P,S,RET

if empty(VET_CNF)
   SEM_ERRO := .T.
   RET_IMP := IBR_COMANDO( 'ComprovantesNaoFiscais', ,  5 )
   SEM_ERRO := .F.
   if IBR_OK( RET_IMP )
      RET_IMP := substr(RET_IMP,5)

      do while ! empty(RET_IMP)
         P := at('|',RET_IMP)
         if P = 0
            P := len(RET_IMP)+1
         endif

         S := substr(RET_IMP,1,P-1)

         aadd(VET_CNF, {substr(S,1,4), (substr(S,5,1)<>' '), Alltrim(substr(S,6))} )
         RET_IMP := substr(RET_IMP,P+1)
      enddo
   endif
endif

WDESCRICAO := ((WDESCRICAO))
POS        := ascan(VET_CNF,{|x|upper(x[3])==WDESCRICAO .and. ;
                                iif(IBR_MODELO() == 'ecfschalter',! x[2],.t.) })
WVINC      := .F.
RET        := ''
if POS > 0
   RET   := alltrim(VET_CNF[POS,1])
   WVINC := VET_CNF[POS,2]
endif

return RET

************************************************************************
Function IBR_MODELO()   // Retorna .t. se a COM ja est  aberta
************************************************************************
if empty(sMODELO)
   sMODELO := lower(alltrim(substr(IBR_COMANDO('modelo'),4)))
endif

return sMODELO



************************************************************************
Function IBR_TEF_INIT()   // Carrega na mem¢ria vetores com Planos de
*                            Pagamento e CNF
************************************************************************
*IBR_FIM_REL()
return IBR_OK( IBR_COMANDO( 'PreparaTEF', , 25 ) )


************************************************************************
Function IBR_VINCULADO(WCOO,WCODFPG,WVALOR,WTXT,WVIAS,WCOLUNAS)
* Imprime Comprovante NAO fiscal VINCULADO, Retorna .T. se imprimiu ok
* WCOO -> Numero do Cupom para Vincular
* WCODFPG -> Forma de Pagamento executada no Cupom a vincular
* WVALOR -> Valor pago atraves da Forma de Pagamento
* WTXT  -> texto a Imprimir no relatorio, quebra de linhas = '|'
* WVIAS -> Numero de vias a imprimir 1 ou 2, padrao 1
* WCOLUNAS -> Numero m ximo de colunas da impressora, ajustada por IMF_RELATORIO
************************************************************************
Local VET,A,RET,WIMP

DEFAULT WVIAS to 2

WCOO := strzero(val(WCOO),6)

//// Abrindo Comprovante NAO fiscal Vinculado ////
*MSG_SAVE('Aguarde Imprimindo Cupom Vinculado...')
RET := IBR_OK( IBR_COMANDO( 'AbreCupomVinculado',{WCOO, WCODFPG, WVALOR}, 10 ) )

*VET  := SEPARA_STR(WTXT,'|')  // Separa as linhas de WTXT
WIMP := 0

//// Imprime relatorio gerencial ////
do while RET
   A := 1
//   do while RET .and. A <= len(VET)
//      RET := IBR_OK( IBR_COMANDO( 'LinhaCupomVinculado',{VET[A]} ) )
//      A++
//   enddo

   RET := IBR_OK( IBR_COMANDO( 'LinhaCupomVinculado',{WTXT}, Int(len(VET)/1.5)+4 ) )

   WIMP++

   if ! RET .or. WIMP >= WVIAS
      exit
   endif

   IBR_COMANDO( 'LinhaCupomVinculado',{' | | | | | | | '}, 5 )
   clear typeahead
 *  MSG('  **  DESTAQUE A '+trim(str(WIMP,2))+'¦ VIA **              ENTER - Imprime pr¢xima via',8)
enddo

*if ! IBR_FIM_REL()
 *  RET := .F.
*endif

clear typeahead
*MSG_REST()

return RET


************************************************************************
Function IBR_CUPOM_ABERTO()  // Retorna .t. se cupom estiver aberto
************************************************************************
return (IBR_ESTADO() = 'ESTVENDA')


************************************************************************
Function IBR_erro()  // Retorna .t. se cupom estiver aberto
************************************************************************
return (IBR_ESTADO() = 'CorrigeEstadoErro')


************************************************************************
Function IBR_LeituraMFD()  // Retorna .t. se cupom estiver aberto
************************************************************************

return (IBR_ESTADO() = 'LeituraMFDSerial')
*ECF.IdentificaPAF( cLinha1, cLinha2 ) 



************************************************************************
Function IdentificaPAF()   // Carrega na mem¢ria vetores com Planos de
*                            Pagamento e CNF
************************************************************************
*return IBR_OK( IBR_COMANDO( 'IdentificaPAF', , 25 ) )

return IBR_OK( IBR_COMANDO( 'IdentificaPAF',{WITEM,WITEM1}) )

   



************************************************************************
Function IBR_ALIQ()  // Retorna vetor bi-dimensional com os codigos
* das aliquotas no formato {ALIQ(N 5,2),COD_ALIQ(C 2)}
* Fun‡ao de uso interno, pela funcao (IBR_ACHA_ALIQ())
************************************************************************
Local RET_IMP,VET_RET:={},P,S

RET_IMP := IBR_COMANDO( 'CarregaAliquotas', , 10 )
if IBR_OK( RET_IMP)
   RET_IMP := substr(RET_IMP,5)

   do while ! empty(RET_IMP)
      P := at('|',RET_IMP)
      if P = 0
         P := len(RET_IMP)+1
      endif

      S := substr(RET_IMP,1,P-1)

      aadd(VET_RET, {val(strtran(substr(S,6,6),',','.')), substr(S,1,4)} )
      RET_IMP := substr(RET_IMP,P+1)
   enddo
endif


MsgINFO(veT_RET)

return VET_RET


************************************************************************
Function IBR_ABERTA()   // Retorna .t. se a COM ja est  aberta
************************************************************************
return ! empty(sENDER)