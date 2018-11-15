
//-----------------------------------------------------------------------------------------------
Function atualizador_qtd()

//-----------------------------------------------------------------------------------------------
	
Ajanela := GetDesktopWidth() //* 0.78125
Ljanela := GetDesktopHeight() //* 0.78125 

SET BROWSESYNC ON	

	
 
   
IF ISWINDOWDEFINED(NFE_EMITIDA_dowd)
    RESTORE WINDOW NFE_EMITIDA_dowd
ELSE
      DEFINE WINDOW NFE_EMITIDA_dowd;
       AT 0100, 200 ;
       WIDTH 400;
       HEIGHT 350;
       TITLE "nFe/nfc_e Emitidas " ;
       icon cPathImagem+'JUMBO1.ico';
       MODAL;   
       NOSIZE
	   

   
  DEFINE TEXTBOX  numero_i
           ROW    40
           COL    10
            WIDTH  100
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX 
	
	  
	  DEFINE TEXTBOX  serie_i
           ROW    40
           COL   125
            WIDTH  20
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX 
	
	  
	  
   
   @ 40, 180  label ate ;
   WIDTH 30 HEIGHT         30 ;
   VALUE "Ate";
   FONT "Ms Sans Serif" SIZE 12.00 ;
   FONTCOLOR { 255, 000, 000 };
   BACKCOLOR { 244, 244, 244 }
      


  DEFINE TEXTBOX numero_f
           ROW    40
           COL    240
            WIDTH  100
            HEIGHT 40
            VALUE ""
            FONTSIZE 15
            FONTBOLD .T.
            FONTITALIC .T.
            VISIBLE .T.
            TRANSPARENT .F.
            AUTOSIZE .F.
            *BACKCOLOR {191,1225,255}
  		    *FONTCOLOR { 225, 000, 000 }
			FONTCOLOR { 255, 000, 000 }
            BACKCOLOR { 203, 225, 252} 
          *  ON GOTFOCUS This.BackColor:=clrBack 
           * ON LOSTFOCUS This.BackColor:=clrNormal 
            BORDER .T.
            CLIENTEDGE .T.
            HSCROLL .F.
            VSCROLL .F.
            BLINK .F.
            RIGHTALIGN .F.
  END TEXTBOX   
  
 
   
     define buttonex confirma
                       row 100
                       col 010
                       width 110
                       height 030
                       caption 'Confirma'
                       picture cPathImagem+'ok.bmp'
                       fontbold .T.
                       lefttext .F.
                      action  atualizador()
                end buttonex
   
   
   
   
   @ 170, 10   LABEL oSay5 ;
   WIDTH 150 ;
   HEIGHT 016 ;
   VALUE "Diretorio"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
   
   
   @ 190, 10   TEXTBOX oGet1 ;
   WIDTH 250 HEIGHT         34 ;
   VALUE '' ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }



   @ 190, 280 BUTTON oBut3 ;
   CAPTION "Escolher Dir"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
  ACTION  {|| Reconectar(),	Criadir_XML(), pega_dir_d()}
   
   
   
                      ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela

					  
					  
       
END WINDOW
CENTER WINDOW NFE_EMITIDA_dowd
ACTIVATE WINDOW NFE_EMITIDA_dowd
ENDIF
Return Nil






*________________________________________________________________________________________________
function atualizador()
 local nLinha   := 0
 local nPagina  := 1
 local mtotal   :=0
 LOCAL oprint,dirimp:=GetCurrentFolder()
 PUBLIC NUMERO:=xSEQ_TEF := strzero(day(date() ),2 ) + strzero(month(date() ), 2 ) + strtran(time(), ':','' )
 PUBLIC cNombre
  cNumero:=RTRIM(STRTRAN(NUMERO,"/","_",1,len(NUMERO)))
  cNombre:="Relatorios"+"_"+cNumero

vnumero :=NFE_EMITIDA_dowd.numero_i.value
vnumero1:=NFE_EMITIDA_dowd.numero_f.value
serie_i :=NFE_EMITIDA_dowd.serie_i.value

   path:=alltrim(NFE_EMITIDA_dowd.oGet1.value)
 
*-------------------------------------------------*
    
               
               
page = 1
F=60
Xtotal=0


oQuery :=oServer:Query( "SELECT CbdcProd,CbdqCOM FROM ITEMNFCE WHERE CbdNtfNumero >= "+vnumero+" and CbdNtfNumero <= "+vnumero1+" and CbdNtfSerie="+serie_i+" Order By CbdNtfNumero" )
If oQuery:NetErr()												
  MsGInfo("ERROR AO SELECIONAR TABELA11")
  RETURN NIL 
Endif
REG:=0
For i := 1 To oQuery:LastRec()
oRow          := oQuery:GetRow(i)
ccodigo        :=(oRow:fieldGet(1))
public cqtd     :=oRow:fieldGet(2)
PUBLIC C_CODIGO  :=oRow:fieldGet(1)
public tqtd:=cqtd

///////////////////pega a qtd no estoque
  pQuery:= oServer:Query( "Select qtd From produtos WHERE CODBAR = " + (Ccodigo))
   If pQuery:NetErr()
  	MsgStop(pQuery:Error())
    MsgInfo("Por Favor Selecione o registroKKK ")
    Return Nil
  Endif
  aRow	          :=pQuery:GetRow(1)
   Xqtd           :=aRow:fieldGet(1)
 RQTD:=Xqtd+cqtd
  
 ///////////////////atualiza a qtd no estoque
cQuery := "UPDATE produtos SET QTD = '"+NTRIM(rqtd)+"' WHERE CODBAR = " +(cCodigo)
aQuery:=oServer:Query(cQuery)
If aQuery:NetErr()												
 MsgStop(aQuery:Error())
 MsgInfo("Por Favor Selecione o registro LINHA 302 ") 
 else
 MsgInfo("ok ") 
Endif		
oQuery:Destroy()
msginfo( "Geração com sucesso")
ThisWindow.release
Return Nil

