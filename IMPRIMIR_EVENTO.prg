


//--------------------------
** autor := jose´juca de oliveira
** medial:= medial@ps5.com.br
** vilhena/RO
** 69 3321 4575 
** date 11-12-2010
//---------------------------------------------------
#include "minigui.ch"
#Include "F_sistema.ch"
#define WM_MDIMAXIMIZE                  0x0225
#define WM_MDIRESTORE                   0x0223
#define c1Tab CHR(9)
#define NTrim( n ) LTRIM( STR( n, IF( n == INT( n ), 0, 2 ) ) )
#include "fileio.ch"
#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"
#include "winprint.ch"
#define PROGRAM 'Circle'
#define PI  3.1415926536
#define  ETX chr(3)
#define  CR  chr(13)
#define  LF  chr(10)
#include "inkey.ch"
#include 'ord.ch'
#define  CRLF            Chr(13)+Chr(10)
#include "common.ch"
#include "hbclass.ch"
#include "hbwin.ch"
//#include "harupdf.ch"
//#include "hbzebra.ch"
#include "hbcompat.ch"
#define CHAR_REMOVE  "/;-:,\.(){}[] "
#include "Inkey.ch"
#include "winprint.ch"
#define  CR  chr(13)
#define  LF  chr(10)
#define Crlf  CHR(13)+CHR(10)
#ifndef XHARBOUR
   #include "hbdyn.ch"
#endif

Function IMPRIMIR_EVENTO1()
        LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
        LOCAL nHandle
		local cQuery
	*	local FC_NORMAL
        LOCAL cAuxCCe  := Getfile ( { {'Arquivos','*.xml'} } , 'Carregar XML da Carta Correção' , 'c:\' , .f. , .t. )
        // Apaga Logs anteriores
        ERASE 'C:\ACBrMonitorPLUS\ent.txt'
        IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
           MsgInfo("File cannot be created:","ENT.TXT")
           Return
        ENDIF 
		
	*	msginfo(cAuxCCe)
		
 *   FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'"')
     FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'")')
      FCLOSE(nHandle) 

  
     *   FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'")')
    *   FWRITE(nHandle,'NFe.ImprimirEvento("'+cAuxCCe+'",'+cAuxNFe+')')
       * FCLOSE(nHandle) 

        Return
