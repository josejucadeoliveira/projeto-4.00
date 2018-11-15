#INCLUDE "TSBROWSE.CH"
#include "MGI.ch"
#include "i_mBrowse.ch"
#Include "MiniGui.ch"
#include "fileio.ch"
#include "common.ch"
// includes hbnfe
#include "hbclass.ch"
#include "hbwin.ch"
#include "harupdf.ch"
#include "hbzebra.ch"
#include "hbcompat.ch"
// color degrade
#define NONE      0
#define BOX       2
#define PANEL     3

declare window Thisform

#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
 
#define LINEBUFF  1024
#define CRLF      CHR(13)+CHR(10)
#define clrNormal   {168,255,190}
#define clrBack     {255,255,128}

Function Manifestacao_Destinatario(cTabela_Destinadas)
Local nAltura:=GetDesktopRealWidth()-50
Local nLargura:=GetDesktopRealHeight()-50
Public cTabela_NFe_Destinadas:= cTabela_Destinadas
aTab:= {}
AADD( aTab, { .f., '', '', '', '','','','','',''} )
Private lCancelar := .F.

//Public aRows  [100000] [8] 

	 
  
DEFINE WINDOW Manifestacao_Destinatario AT 114 , 258 WIDTH nAltura  HEIGHT nLargura  TITLE "Manifestação do Destinatário"  MODAL  FONT "Arial" SIZE 10 ON RELEASE Desconecta_MySQL_NFe() 
                                      


     ON KEY ESCAPE  OF Manifestacao_Destinatario ACTION { || Manifestacao_Destinatario.RELEASE } 

 		DEFINE STATUSBAR FONT 'Verdana' SIZE 7			
			STATUSITEM "Manifestação do Destinatário"
		END STATUSBAR
		
        
     DEFINE FRAME Frame_1
            ROW    10
            COL    10
            WIDTH  440
            HEIGHT 206
            FONTNAME 'Arial'
            CAPTION "Seleciona NF-es Baixadas"
            OPAQUE .T.
     END FRAME  

     DEFINE RADIOGROUP RdG_Data
            ROW    30
            COL    20
            WIDTH  120
            HEIGHT 50
            OPTIONS {'Data Emissão','Data Lançamento'}
            VALUE 1
            FONTNAME 'Arial'
            TOOLTIP ''
            HORIZONTAL .T.
            ON CHANGE {|| iif( This.value==1,Manifestacao_Destinatario.Txt_INICIAL.setfocus,Manifestacao_Destinatario.Txt_INICIAL.setfocus) }
     END RADIOGROUP  

     DEFINE LABEL Label_1
            ROW    60
            COL    20
            WIDTH  80
            HEIGHT 24
            VALUE "Data Inicial"
     END LABEL  

      DEFINE LABEL Label_2
            ROW    60
            COL    240
            WIDTH  70
            HEIGHT 24
            VALUE "Data Final"
     END LABEL  

      
     DEFINE TEXTBOX Txt_INICIAL
            ROW    60
            COL    110
            WIDTH  120
            HEIGHT 24
			   DATE .T.
     END TEXTBOX 
	 
 
     DEFINE TEXTBOX Txt_FINAL
            ROW    60
            COL    320
            WIDTH  120
            HEIGHT 24
				DATE .T.
     END TEXTBOX 

     DEFINE LABEL Label_3
            ROW    90
            COL    20
            WIDTH  120
            HEIGHT 24
            VALUE "CNPJ Emitente"
     END LABEL  
 
     DEFINE TEXTBOX  TxtCNPJ
            ROW    90
            COL    150
            WIDTH  290
            HEIGHT 24
				TOOLTIP "Digite CNPJ do Fornecedor" 
				ON LOSTFOCUS {|| vcnpjcpf(This.VALUE),CRIAMASCARA() } 
     END TEXTBOX


     DEFINE LABEL Label_TPSQ
            ROW    120
            COL    20
            WIDTH  120
            HEIGHT 24
            VALUE "Tipo da Seleção"
     END LABEL  

     DEFINE COMBOBOX Combo_1
            ROW    120
            COL    150
            WIDTH  290
            HEIGHT 100
            ITEMS {"Todas","Sem manifestação do destinatário","Confirmada Operação","Desconhecida","Operação não Realizada","Ciência"}
            VALUE 1
     END COMBOBOX  
 
     DEFINE RADIOGROUP RadioGroup_1
            ROW    150
            COL    20
            WIDTH  110
            HEIGHT 50
            OPTIONS {'Todas','Notas Lançadas','Não Lançadas'}
            VALUE 3
            FONTNAME 'Arial'
            TOOLTIP ''
            HORIZONTAL .T.
     END RADIOGROUP

     DEFINE BUTTONEX ButtonEX_1
            ROW    180
            COL    20
            WIDTH  120
            HEIGHT 24
            CAPTION 'Localizar'
            ACTION Localiza_Destinadas(1,Manifestacao_Destinatario.RdG_Data.value,Manifestacao_Destinatario.Txt_INICIAL.value,Manifestacao_Destinatario.Txt_FINAL.value,Manifestacao_Destinatario.TxtCNPJ.value,Manifestacao_Destinatario.RadioGroup_1.value,cTabela_Destinadas,Browse_Destinadas)
     END BUTTONEX  
     
     DEFINE BUTTONEX ButtonEX_5
            ROW    180
            COL    140
            WIDTH  120
            HEIGHT 24
            CAPTION 'Limpa Pesquisa'
            ACTION Limpa_Destinadas( cTabela_Destinadas,Browse_Destinadas)
     END BUTTONEX  
     
     DEFINE BUTTONEX ButtonEX_8
            ROW    180
            COL    260
            WIDTH  181
            HEIGHT 24
            CAPTION 'Altera Situação da NF-e'
            ACTION AlteraDadosNFe(cTabela_Destinadas,Browse_Destinadas)
     END BUTTONEX 
	   
     DEFINE FRAME Frame_2
            ROW    10
            COL    450
            WIDTH  nLargura-110 
            HEIGHT 143
            FONTNAME 'Arial'
            CAPTION "Pesquisa NF-es Emitidas contra o meu CNPJ"
            OPAQUE .T.
     END FRAME  

     DEFINE LABEL Label_4
            ROW    30
            COL    460
            WIDTH  120
            HEIGHT 24
            VALUE "Tipo da Pesquisa"
     END LABEL  

     DEFINE COMBOBOX Combo_2
            ROW    30
            COL    590
            WIDTH  290
            HEIGHT 100
            ITEMS {"Todas as Chaves de Acesso do período","Somente as NF-e que ainda não tiveram manifestação","Item anterior inluindo NF-e que não tiveram ciência da operação"}
            FONTNAME 'Arial'
            VALUE 1
     END COMBOBOX  

     DEFINE LABEL Label_5
            ROW    60
            COL    460
            WIDTH  120
            HEIGHT 24
            VALUE "Tipo do Emissor"
     END LABEL  

     DEFINE COMBOBOX Combo_3
            ROW    60
            COL    590
            WIDTH  290
            HEIGHT 100
            ITEMS {"Todos os emitentes","Somente as NF-e emitidas por emissores que não tenham o mesmo CNPJ-Base do destinatário"}
            FONTNAME 'Arial'
            VALUE 1
     END COMBOBOX  

     DEFINE CHECKBOX Check_1
            ROW    90
            COL    460
            WIDTH  545
            HEIGHT 27
            CAPTION "Retornará unicamente as notas fiscais que tenham sido recepcionadas nos últimos 15 dias."
            FONTNAME 'Arial'
            TOOLTIP ''
     END CHECKBOX  

     DEFINE BUTTONEX ButtonEX_2
            ROW    30
            COL    890
            WIDTH  100
            HEIGHT 24
            CAPTION 'Pesquisar'
            FONTNAME 'Arial'
            TOOLTIP 'Pesquisar notas destinadas'
     END BUTTONEX 
	   
     DEFINE BUTTONEX ButtonEX_3
            ROW    60
            COL    890
            WIDTH  99
            HEIGHT 26
            CAPTION "Parar"
            FONTNAME 'Arial'
            TOOLTIP 'Abortar pesquisa de notas destinadas na SEFAZ'
            Action { || lCancelar := .T. }
     END BUTTONEX  

 
     DEFINE BUTTONEX ButtonEX_4
            ROW    160
            COL    460
            WIDTH  140
            HEIGHT 24
            CAPTION "Visualiza DANFe"
            FONTNAME 'Arial'
            TOOLTIP ''
            ACTION Imprime_Todas (1,cTabela_Destinadas)  
     END BUTTONEX
	    
     DEFINE BUTTONEX ButtonEX_6
            ROW    160
            COL    600
            WIDTH  140
            HEIGHT 24
            CAPTION 'Verifica Lançamentos'
            FONTNAME 'Arial'
            TOOLTIP ''
            ACTION VERIFICA_LANCAMENTOS_NFE(cTabela_Destinadas,Browse_Destinadas,Manifestacao_Destinatario.RdG_Data.value,Manifestacao_Destinatario.Txt_INICIAL.value,Manifestacao_Destinatario.Txt_FINAL.value)
     END BUTTONEX  

     DEFINE BUTTONEX ButtonEX_7
            ROW    160
            COL    740
            WIDTH  257
            HEIGHT 24
            CAPTION 'Manifestação do Destinatário'
            ACTION EventoManifestacaoDestinatario( cTabela_Destinadas)
     END BUTTONEX  
	    
              
     DEFINE BUTTONEX ButtonEX_Relatorio
            ROW    190
            COL    740
            WIDTH  257
            HEIGHT 24
            CAPTION 'Imprimir Relação das NFe-s Selecionadas'
            ACTION Imprime_Relacao()
     END BUTTONEX  

 /*
    DEFINE CHECKBOX Check_Selecao
           ROW    220
           COL    10
           WIDTH  210
           HEIGHT 28
           CAPTION "Selecionar Todos"
           ON CHANGE  Selecionar_Todas(This.value) 
     END CHECKBOX  
  */
           DEFINE TBROWSE Browse_Destinadas AT 250,10  ;
            OF Manifestacao_Destinatario WIDTH nAltura-40 HEIGHT nLargura-360 CELLED;
            FONT "Arial" SIZE 9

         Browse_Destinadas:SetArray( aTab ) // isto é necessário para trabalhar com matrizes
 
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 1;
            TITLE " " ;
            SIZE 30 EDITABLE  MOVE DT_MOVE_DOWN;          // this column is editable
            3DLOOK TRUE CHECKBOX ;          // Editing with Check Box
            VALID { | uVar | ! Empty( uVar ) }; // don't want empty rows
            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT  ; 
				POSTEDIT { Seleciona_Destinada(Browse_Destinadas:nAt) , Habilita_Botoes_Filtro(),Browse_Destinadas:DrawFooters() } 
            
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 2;
            TITLE "Emissão" ;
            SIZE 75   ;          
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 1 ]:bData ) ==.t.,CLR_PINK,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
	            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT
  
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 3;
            TITLE "Número" ;
            SIZE 80   ;          
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 1 ]:bData ) ==.t.,CLR_PINK,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT
  
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 4;
            TITLE "CNPJ" ;
            SIZE 110   ;          
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 1 ]:bData ) ==.t.,CLR_PINK,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT
 
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 5;
            TITLE "Inscrição" ;
            SIZE 110   ;          
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 1 ]:bData ) ==.t.,CLR_PINK,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT
 
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 6;
            TITLE "Chave" ;
            SIZE 315   ;          
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 1 ]:bData ) ==.t.,CLR_PINK,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT
 
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 7;
            TITLE "Nome" ;
            SIZE 320   ;          
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 1 ]:bData ) ==.t.,CLR_PINK,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT
 
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 8;
            TITLE "Valor" ;
            SIZE 80  ;          
				PICTURE "99,999,999.99" ;
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 1 ]:bData ) ==.t.,CLR_PINK,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
            ALIGN  DT_RIGHT
 
         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 9;
            TITLE "Evento" ;
            SIZE 120  ;          
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 9 ]:bData ) <> 'Download Realizado',CLR_HGREEN,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT

         ADD COLUMN TO TBROWSE Browse_Destinadas DATA ARRAY ELEMENT 10;
            TITLE " " ;
            SIZE 20  ;          
            3DLOOK TRUE, TRUE, TRUE ;           
            MOVE DT_MOVE_DOWN;          
            VALID { | uVar | ! Empty( uVar ) };  
            COLORS CLR_BLACK,{|| If( Eval( Browse_Destinadas:aColumns[ 1 ]:bData ) ==.t.,CLR_PINK,CLR_HGRAY)},CLR_HRED ; // marcar a linha selecionada
            ALIGN DT_LEFT, DT_CENTER, DT_RIGHT

              
        END TBROWSE
        
         Browse_Destinadas:hide()  // Activate Key DEL and confirm
         Browse_Destinadas:show()  // Activate Key DEL and confirm
         Browse_Destinadas:LoadFields( .T. )   // Activate Key DEL and confirm
         Browse_Destinadas:SetAppendMode( .T. ) // Activate Key DEL and confirm
         Browse_Destinadas:SetDeleteMode( .t., .t.)   // Activate Key DEL and confirm
         Browse_Destinadas:SetSelectMode( .f.)
 			Browse_Destinadas:HiliteCell( 1 )    //POSICIONA O CURSOR NA COL 1
			Browse_Destinadas:Refresh(.T.) 
         Browse_Destinadas:lNoResetPos := .F.

 
		           
     DEFINE BUTTONEX ButtonEX_Exporta
            ROW    nLargura-100
            COL    10
            WIDTH  140
            HEIGHT 24
            CAPTION "Exportar XML"
            TOOLTIP 'Exporta XML das Notas Fiscais Destinadas'
            ACTION Splash_Exportacao(cTabela_Destinadas)
     END BUTTONEX  
             
     DEFINE BUTTONEX ButtonEX_Imprime
            ROW    nLargura-100
            COL    150
            WIDTH  140
            HEIGHT 24
            CAPTION 'Imprimir Todas'
            ACTION Imprime_Todas(2,cTabela_Destinadas)
     END BUTTONEX  


END WINDOW

	Carrega_Destinadas(cTabela_Destinadas,Browse_Destinadas)
Localiza_Destinadas(1,Manifestacao_Destinatario.RdG_Data.value,Manifestacao_Destinatario.Txt_INICIAL.value,Manifestacao_Destinatario.Txt_FINAL.value,Manifestacao_Destinatario.TxtCNPJ.value,Manifestacao_Destinatario.RadioGroup_1.value,cTabela_Destinadas,Browse_Destinadas)
		Manifestacao_Destinatario.ButtonEX_7.Enabled := .f.
		Manifestacao_Destinatario.ButtonEX_8.Enabled := .f.
		Manifestacao_Destinatario.Browse_Destinadas.setfocus
   	Manifestacao_Destinatario.Center
	Manifestacao_Destinatario.Activate

Return
//***************************************
STATIC FUNCTION VISUALIZAR_NFe_ACBr( nNFe,cTabela_Destinadas ,cOp )

		   LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
			LOCAL nLote    := '0'
			//conecta ao banco de dados
		   Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)


	  		cQuery:= ("SELECT xml FROM "+cTabela_Destinadas+" WHERE CHAVE='"+(nNFe)+"'"  )
		   oQuery:=oServer_NFe:Query( cQuery )
			If oQuery:NetErr()												
		       MsgStop("Erro SQL: "+oQuery:Error())
		       Return .f.
			End 
			oRow:= oQuery:GetRow(1)
			If Empty(oRow:FieldGet(1))
			    MsgInfo("Não Existe anexo - Verifique!!!","Consultas")
			  Return(.f.)
			EndIf                     	    
				    
  		 	HANDLE :=  FCREATE (cBaseTemporaria+nNFe+"-nfe.XML",0)// cria o arquivo
		   FWRITE(Handle,oRow:FieldGet(1))
			fclose(handle)  

if cOp==1
	imprime_xml_acbr( cBaseTemporaria+nNFe+"-nfe.XML",nNFe )
else
	imprime_xml_pdf( cBaseTemporaria+nNFe+"-nfe.XML",nNFe )
end
 
 
 
RETURN .T.

//***************************************
Function Atualiza_Status(ultNSU)

     Manifestacao_Destinatario.StatusBar.Item(1) := str(ultNSU)//+"-"+xMotivo

Return
//***************************************
Function VERIFICA_LANCAMENTOS_NFE( cTabela_Destinadas,Browse_Destinadas,rData,dInicio,dFim  )

Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)

nCount:=0
  For i :=  1 To Len( aTab )
     
	   achou:=.f.
				 
  				cQuery:= "select CHAVE,dt_entrada,status FROM COMPRAS WHERE CHAVE='"+ (aTab[i,6]) +"'"   
  				 
	   		SQL_Error_oQuery()
				oRow:= oQuery:GetRow(1)
				
				if !empty(oRow:fieldGet(1)) .and.alltrim(oRow:fieldGet(3))=="Fechado"
					dDataEntrada:=dtos(oRow:fieldGet(2))
					achou:=.t.
				end
		  		oQuery:Destroy()
		  		if achou==.t.
	  				cQuery:=( "update "+cTabela_Destinadas+" set lancada=1,dtlancamento='"+dDataEntrada+"' WHERE CHAVE='"+ aTab[i,6] +"'"  )     
				   oQuery:=oServer_NFe:Query( cQuery )
					If oQuery:NetErr()												
				       MsgStop("Erro SQL: "+oQuery:Error())
				       Return .f.
					End 
			  		oQuery:Destroy()
			  		nCount++
		  		end
       
Next

   Limpa_Destinadas( cTabela_Destinadas,Browse_Destinadas)
 
	msginfo("Verificação concluida, "+transf(nCount,"999")+" Notas lançadas")
	nCount:=0
	if rData==2

	  				cQuery:= "select CHAVE,emissao,formulario,cnpj,nome,valor_nota FROM COMPRAS WHERE dt_entrada>='"+dtos(dInicio) +"' and dt_entrada<='"+dtos(dFim) +"'" 
 
		   		SQL_Error_oQuery()
				   aNotasLancadas:={}
				   For i := 1 To oQuery:LastRec()
					   oRow := oQuery:GetRow(i) 
						if !empty(oRow:fieldGet(1))  
			  		  		AADD( aNotasLancadas, { oRow:fieldGet(1) ,oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6)    } )
			  		  	end
					Next
					oQuery:Destroy()

					Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)
					For n :=  1 To Len( aNotasLancadas )
			  		
		  				cQuery:="Select chave from "+cTabela_Destinadas+" where CHAVE='"+ aNotasLancadas[n,1] +"'"      
	  				 
					   oQuery:=oServer_NFe:Query( cQuery )
						If oQuery:NetErr()												
					       MsgStop("Erro SQL: "+oQuery:Error())
					       Return .f.
						End 
						oRow:= oQuery:GetRow(1)
						xChave:=oRow:fieldGet(1)
 
				  		oQuery:Destroy()
				  		if empty(xChave)
							   cQuery:=("insert into "+cTabela_Destinadas+" (emissao,numero,chave,cnpj ,nome,valor) values ('"+;
								dtos(aNotasLancadas[n,2])+"','"+;
								substr(aNotasLancadas[n,3],2,10)+"','"+;
								aNotasLancadas[n,1]+"','"+;
								aNotasLancadas[n,4]+"','"+;
								aNotasLancadas[n,5]+"','"+;
								str(aNotasLancadas[n,6])+"')" )
								 
							   oQuery:=oServer_NFe:Query( cQuery )
								If oQuery:NetErr()												
							       MsgStop("Erro SQL: "+oQuery:Error())
							       Return .f.
								End 
								oQuery:Destroy()
								if Retorno_SQL==.t.
					  				nCount++
		  						end
				  		end
			 
					Next

		   Limpa_Destinadas( cTabela_Destinadas,Browse_Destinadas)
		 
			msginfo("Verificação concluida, "+transf(nCount,"999")+" Notas gravadas ")
		EndIf
	

Return
//***************************************
Static Function CARREGA_DADOS_NOTA(cChave)

DEFINE WINDOW Carrega_CHAVE AT 114 , 258 WIDTH 596 HEIGHT 91 MODAL  FONT "Arial" SIZE 10
 
     ON KEY ESCAPE  OF Carrega_CHAVE ACTION { ||Carrega_CHAVE.RELEASE } 

     DEFINE TEXTBOX Text_1
            ROW    10
            COL    10
            WIDTH  570
            HEIGHT 24
            FONTNAME 'Arial'
            VALUE cChave
     END TEXTBOX 

END WINDOW
  	Carrega_CHAVE.Center
	Carrega_CHAVE.Activate

Return

//***************************************
Function Atualiza_MySQLBrowse_Destinadas( cTabela_Destinadas ,emissao,numero,chave,cnpj,inscricao,nome,valor)
  
  AADD( aTab, { .f., emissao,numero,cnpj,inscricao,chave,nome,valor,'',.t.    } )
  ADD ITEM  { .f., emissao,numero,cnpj,inscricao,chave,nome,valor,'',.t.    }  TO Browse_Destinadas OF Manifestacao_Destinatario  
 
  Browse_Destinadas:Refresh( .t. )

Return


//***************************************

function EventoManifestacaoDestinatario( cTabela_Destinadas)

Local sChave
	for i=1 to len(aTab)
 	  if  aTab[i,1] ==.t.
 	  		sChave:=aTab[i,6]
 	  end
	Next
 
	if empty(sChave)
		msginfo('Nenhuma nota selecionada')
		return
	end
  
IF .NOT. ISWINDOWDEFINED(ManifestacaoDestinatario)
 
	*** Cria Formulário
    DEFINE WINDOW ManifestacaoDestinatario AT 00,00 ;
	WIDTH 550 HEIGHT 325 ;
	TITLE 'Manifestação do Destinatário';
	MODAL NOSIZE NOSYSMENU  FONT 'Arial' SIZE 09 

      ON KEY ESCAPE     OF ManifestacaoDestinatario ACTION { || ManifestacaoDestinatario.RELEASE } 


 		DEFINE STATUSBAR FONT 'Verdana' SIZE 7	
 		END STATUSBAR
		
 
     DEFINE LABEL Label_1
            ROW    10
            COL    10
            WIDTH  120
            HEIGHT 24
            VALUE "Chave de Acesso"
     END LABEL  

     DEFINE TEXTBOX Text_CHAVE
            ROW    10
            COL    140
            WIDTH  384
            HEIGHT 24
            VALUE sChave
     END TEXTBOX 

     DEFINE LABEL Label_2
            ROW    40
            COL    10
            WIDTH  120
            HEIGHT 24
            VALUE "Manifestação"
     END LABEL  

     DEFINE COMBOBOX Combo_1
            ROW    40
            COL    140
            WIDTH  243
            HEIGHT 100
            ITEMS {"Selecione uma Opção","Ciência da Operação","Confirmação Operação","Desconhecimento da Operação","Operação não Realizada" }
            VALUE 1
			   ON CHANGE {|| IF( This.Value<5,(ManifestacaoDestinatario.ButtonEX_1.enabled:=.t.,ManifestacaoDestinatario.Edit_1.enabled:=.f.),;
															(ManifestacaoDestinatario.ButtonEX_1.enabled:=.f.,ManifestacaoDestinatario.Edit_1.enabled:=.t.))}
     END COMBOBOX  

     DEFINE LABEL Label_3
            ROW    70
            COL    10
            WIDTH  250
            HEIGHT 24
            VALUE "Justificativa com no minímo 15 letras"
     END LABEL  

 
     DEFINE EDITBOX Edit_1
            ROW    100
            COL    10
            WIDTH  516
            HEIGHT 120
			   HSCROLLBAR .F.
			   ON CHANGE {|| IF( LEN(ALLTRIM(This.Value))>=15,ManifestacaoDestinatario.ButtonEX_1.enabled:=.t.,ManifestacaoDestinatario.ButtonEX_1.enabled:=.f.)}
     END EDITBOX  

     DEFINE BUTTONEX ButtonEX_1
            ROW    230
            COL    10
            WIDTH  120
            HEIGHT 24
            CAPTION 'Confi&rma'
            ACTION Confirma_Evento_Manifestacao(ManifestacaoDestinatario.Combo_1.VALUE,ManifestacaoDestinatario.Text_CHAVE.VALUE,ManifestacaoDestinatario.Edit_1.VALUE,cTabela_Destinadas)
     END BUTTONEX  

     DEFINE BUTTONEX ButtonEX_2
            ROW    230
            COL    130
            WIDTH  120
            HEIGHT 24
            CAPTION "&Cancelar"
			ACTION ManifestacaoDestinatario.RELEASE
     END BUTTONEX  

END WINDOW

	ManifestacaoDestinatario.ButtonEX_1.enabled:=.f.
   CENTER WINDOW ManifestacaoDestinatario
   ACTIVATE WINDOW ManifestacaoDestinatario
ELSE
   ManifestacaoDestinatario.RELEASE
ENDIF
Return

//***************************************

Function Confirma_Evento_Manifestacao(nOp,sCHAVE,sJust,cTabela_Destinadas)
Local TipoEvento,DescEvento,Jutificativa
////////[EVENTO]////////////////////////
LOCAL e_CStat   :=""  //107
LOCAL e_XMotivo :=""  //Servico em Operacao
LOCAL e_nProt   :=""  //Servico em Operacao
LOCAL e_xEvento :=""  //Servico em Operacao
LOCAL e_dhRegEvento :=""  //Servico em Operacao
///////FIM///////////////
	  /*
			cQuery:=("select `seq_evento` from Eventos_destinadas where chave='"+sCHAVE+"'")
			SQL_Error_oQuery()
			oRow:= oQuery:GetRow(1)
			xxEvento:=alltrim(oRow:fieldGet(1))
			oQuery:Destroy()
	  */
xxEvento:=''
 
if nOp==1
	msginfo('Escolha a Opção para manifestação')
	ManifestacaoDestinatario.Combo_1.setfocus
	return
elseif nOp==2
	TipoEvento:='210210'
	DescEvento:='Ciencia da Operacao'
   Jutificativa=''
			if xxEvento="Desconhecimento da Operacao"
				msginfo('Nota Fiscal com evento "Desconhecimento da Operação", não pode realizar a Confirmacao da Operação')
				return
			End
elseif nOp==3
	TipoEvento:='210200'
	DescEvento:='Confirmacao da Operacao'
   Jutificativa:=''
			if xxEvento="Desconhecimento da Operacao"
				msginfo('Nota Fiscal com evento "Desconhecimento da Operação", não pode realizar a Confirmacao da Operação')
				return
			End
elseif nOp==4
	TipoEvento:='210220'
	DescEvento:='Desconhecimento da Operacao'
	Jutificativa:=''
			if xxEvento="Confirmacao da Operacao"
				msginfo('Nota Fiscal já Confirma, não pode realizar o Desconhecimento da Operação')
				return
			End
elseif nOp==5
	TipoEvento:='210240'
	DescEvento:='Operacao nao realizada'
	Jutificativa:=sJust
			if xxEvento="Confirmacao da Operacao"
				msginfo('Nota Fiscal já Confirma, não pode realizar o Desconhecimento da Operação')
				return
			End
end
 	    /// evento manifestação do destinatário pelo acbr
		 ERASE "C:\ACBrMonitorPLUS\sai.txt"


		 DADOS_EVENTO:={}
		 aadd(DADOS_EVENTO,{'NFe.EnviarEvento("'})
		 aadd(DADOS_EVENTO,{'[Evento]'})
		 aadd(DADOS_EVENTO,{'idLote=1'})
		 aadd(DADOS_EVENTO,{'[Evento001]'})
		 aadd(DADOS_EVENTO,{'cOrgao=91'})
		 aadd(DADOS_EVENTO,{'chNFe='+sCHAVE})
		 aadd(DADOS_EVENTO,{'CNPJ='+limpa(mgCNPJ) })
		 aadd(DADOS_EVENTO,{'dhEvento='+dtoc(date())+" "+time()  })
		 aadd(DADOS_EVENTO,{'tpEvento='+TipoEvento })
		 aadd(DADOS_EVENTO,{'nSeqEvento=1' })
		 aadd(DADOS_EVENTO,{'versaoEvento=1.00' })
		if nOp==5
		 aadd(DADOS_EVENTO,{'xJust='+alltrim(Jutificativa) })
		end
		 aadd(DADOS_EVENTO,{'descEvento='+DescEvento+'")' })

 
			handle:=fcreate("C:\ACBrMonitorPLUS\ent.txt")
			for i=1 to len(DADOS_EVENTO)
				fwrite(handle,alltrim(DADOS_EVENTO[i,1]))
				fwrite(handle,chr(13)+chr(10))
			next
			fclose(handle) 

							xxx:=1
								DO WHILE XXX<=10
							
									IF !FILE("C:\ACBrMonitorPLUS\sai.txt")	
										MY_WAIT( 3 ) 
										xxx++
									ELSE
									////RETORNO////
									BEGIN INI FILE "C:\ACBrMonitorPLUS\sai.txt"
										   GET e_CStat          SECTION  "EVENTO001"       ENTRY "cStat"
										   GET e_XMotivo        SECTION  "EVENTO001"       ENTRY "xMotivo"           
										   GET e_nProt          SECTION  "EVENTO001"       ENTRY "nProt"      // PROTOCOLO DE AUTORIZACAO 
										   GET e_xEvento        SECTION  "EVENTO001"       ENTRY "xEvento"      // PROTOCOLO DE AUTORIZACAO 
										   GET e_dhRegEvento    SECTION  "EVENTO001"       ENTRY "dhRegEvento"      // PROTOCOLO DE AUTORIZACAO 
										 /////////////////////////////////////////////////////////////
									END INI
									exit
									END
								enddo
								
               
			if e_CStat='135' .or. e_CStat='136'
					//-->>salvar xml no banco de dados e na pasta

				   Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)

					oQuery:=oServer_NFe:Query("update "+cTabela_Destinadas+" set protocolo='"+e_nProt+"',xjust='"+alltrim(e_xEvento)+"', xEvento='"+e_xEvento+"',dtevento='"+e_dhRegEvento+"' where chave='"+sCHAVE+ "'")
					  If oQuery:NetErr()												
			           MsgInfo("Erro: " + oQuery:Error())
			        Endif
					oQuery:Destroy()

			         if nOp==5
								cQuery:= "update "+cTabela_Destinadas+" set lancada='1',xEvento='"+e_xEvento+"',situacao_nfe='"+e_xEvento+"' where chave='"+sCHAVE+ "'" 
						end	
							   oQuery:=oServer_NFe:Query( cQuery )
								If oQuery:NetErr()												
							       MsgStop("Erro SQL: "+oQuery:Error())
							       Return .f.
								End 
								oQuery:Destroy()
							if Retorno_SQL==.f.
								msginfo("Não foi possivel gravar o lançamento no caixa. Favor informar o responsál.")
							end                                                                       

					cQuery:= "select max(Seq_Evento) FROM Eventos_destinadas where Chave='"+sChave+"'"
					SQL_Error_oQuery()
				
					oRow:= oQuery:GetRow(1)
					if oRow:fieldGet(1)==0
						nSeqEvento   :='1'
					else
						nSeqEvento   :=str((oRow:fieldGet(1)+1)) 
					end
 
					cSerie:=substr(sChave, 23, 3)
					nNumero:=substr(sChave, 26, 9)

				   cQuery:="INSERT INTO  Eventos_destinadas (  `serie`,`modelo`  ,`numero`, `chave`,  `situacao`,  `protocolo`, `xml_evento`,emissao,`seq_evento` ) VALUES ("+;
				   			"'"+cSerie+"','55',"+(nNumero)+",'"+sChave+"','"+e_xEvento+"','"+e_nProt+"','','"+dtos(date())+"',"+(nSeqEvento)+")"
					SQL_Error_oQuery()
					oQuery:Destroy()

 			end
 			Atualiza_MySQLBrowse_Destinadas(cTabela_Destinadas )
			msginfo(e_XMotivo)
		Limpa_Destinadas( cTabela_Destinadas,Browse_Destinadas)
 			
ManifestacaoDestinatario.RELEASE
Return
 
//***************************************

static function AlteraDadosNFe(cTabela_Destinadas)
   Local sChave
	//conecta ao banco de dados
   Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)

	for i=1 to len(aTab)
 	  if  aTab[i,1] ==.t.
 	  		sChave:=aTab[i,6]
 	  end
	Next
 
	if empty(sChave)
		msginfo('Nenhuma nota selecionada')
		return
	end
	 
		  oQuery:=oServer_NFe:Query("select lancada from "+cTabela_Destinadas+" where chave='"+sCHAVE+"'" )
		  If oQuery:NetErr()												
           MsgInfo("Erro: " + oQuery:Error())
        Endif
			oRow:= oQuery:GetRow(1)
			xxLancada=oRow:fieldGet(1) 
			oQuery:Destroy()
 
IF .NOT. ISWINDOWDEFINED(AlteraDadosNFe)
 
	*** Cria Formulário
    DEFINE WINDOW AlteraDadosNFe AT 00,00 ;
	WIDTH 550 HEIGHT 216 ;
	TITLE 'Altera Situação da NF-e';
	MODAL NOSIZE NOSYSMENU  FONT 'Arial' SIZE 09 

      ON KEY ESCAPE     OF AlteraDadosNFe ACTION { || AlteraDadosNFe.RELEASE } 


 		DEFINE STATUSBAR FONT 'Verdana' SIZE 7	
 		END STATUSBAR
  
     DEFINE LABEL Label_1
            ROW    10
            COL    10
            WIDTH  120
            HEIGHT 24
            VALUE "Chave de Acesso"
     END LABEL  

     DEFINE TEXTBOX Text_chave
            ROW    10
            COL    130
            WIDTH  395
            HEIGHT 24
            VALUE sChave
     END TEXTBOX 

     DEFINE LABEL Label_2
            ROW    40
            COL    10
            WIDTH  120
            HEIGHT 24
            VALUE "Situação da NF-e"
     END LABEL  

     DEFINE COMBOBOX Combo_1
            ROW    40
            COL    130
            WIDTH  397
            HEIGHT 100
            ITEMS {"Selecione uma Opção","NF-e Cancelada","NF-e de Entrada no Fonecedor","Somente marcar como Lançada" }
            VALUE 4  
     END COMBOBOX  

     DEFINE CHECKBOX Check_1
            ROW    80
            COL    10
            WIDTH  518
            HEIGHT 28
            CAPTION "Marcar esta Nota Fiscal como Lançada no Sistema"
            VALUE xxLancada
     END CHECKBOX  

      DEFINE BUTTONEX ButtonEX_1
            ROW    120
            COL    10
            WIDTH  120
            HEIGHT 24
            CAPTION 'Confi&rma'
            ACTION Confirma_Alteracao_Situacao(AlteraDadosNFe.Combo_1.VALUE,sChave,cTabela_Destinadas )
     END BUTTONEX  

     DEFINE BUTTONEX ButtonEX_2
            ROW    120
            COL    130
            WIDTH  120
            HEIGHT 24
            CAPTION "&Cancelar"
			ACTION AlteraDadosNFe.RELEASE
     END BUTTONEX  

END WINDOW

	AlteraDadosNFe.Text_chave.setfocus
   CENTER WINDOW AlteraDadosNFe
   ACTIVATE WINDOW AlteraDadosNFe
ELSE
   AlteraDadosNFe.RELEASE
ENDIF
Return

//***************************************
//***************************************

Static Function Confirma_Alteracao_Situacao(nOp,sCHAVE,cTabela_Destinadas )
Local nLancada,cSituacao:=''
if nOp==1
	msginfo('Escolha a Opção para manifestação')
	AlteraDadosNFe.Combo_1.setfocus
	return
elseif nOp==2
   cSituacao:= 'NF-e Cancelada'
elseif nOp==3
   cSituacao:= 'NF-e de Entrada no Fonecedor'
elseif nOp==3
   cSituacao:= ' '
end

nLancada:=IIF(AlteraDadosNFe.Check_1.value==.F.,'0','1')
         if nOp==2
					cQuery:= "update "+cTabela_Destinadas+" set lancada='"+nLancada+"',xEvento='NF-e Cancelada',situacao_nfe='"+cSituacao+"' where chave='"+sCHAVE+ "'" 
			else
					cQuery:= "update "+cTabela_Destinadas+" set lancada='"+nLancada+"',situacao_nfe='"+cSituacao+"' where chave='"+sCHAVE+ "'" 
			end	
				   oQuery:=oServer_NFe:Query( cQuery )
					If oQuery:NetErr()												
				       MsgStop("Erro SQL: "+oQuery:Error())
				       Return .f.
					End 
					oQuery:Destroy()
				if Retorno_SQL==.f.
					msginfo("Não foi possivel gravar o lançamento no caixa. Favor informar o responsál.")
				end                                                                       
					
					AlteraDadosNFe.release
		Limpa_Destinadas( cTabela_Destinadas,Browse_Destinadas)
 
//               Atualiza_MySQLBrowse_Destinadas(cTabela_Destinadas )
Return

//------------------------------------------------------------------------------
Static Function Splash_Exportacao(cTabela_Destinadas )
local width := 645, height := 100
   Private cValue2
   cValue2 := "000%"


IF .NOT. ISWINDOWDEFINED(Form_Splash)
 
  DEFINE WINDOW Form_Splash ;
    AT 0,0 ;
    WIDTH 645 ;
    HEIGHT 100 ;
    MODAL ;
    FONT 'Arial' ;
    SIZE 9  NOCAPTION NOSIZE ON INIT {||  exporta_xml( cTabela_Destinadas) , Form_Splash.RELEASE} BACKCOLOR {255,242,230}


 		DRAW LINE IN WINDOW Form_Splash ;
			AT 0, 0 TO 0, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW Form_Splash ;
			AT Height, 0 TO Height, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW Form_Splash ;
			AT 0, 0 TO Height, 0 ;
			PENCOLOR BLACK ;
			PENWIDTH 2

		DRAW LINE IN WINDOW Form_Splash ;
			AT 0, Width TO Height, Width ;
			PENCOLOR BLACK ;
			PENWIDTH 2

     DEFINE LABEL Label_1
            ROW    10
            COL    10
            WIDTH  618
            HEIGHT 24
            VALUE "Aguarde Processamento da Informação"
			BACKCOLOR {255,242,230}
     END LABEL  

      @ 75,310 Label       LabPorcentagem  Value cValue2 Width  35 Height 20  Font "Calibri" Size 12 BOLD Rightalign  Transparent
      @ 40,10 ProgressBar Progress_Bar    Width 622 Height 34  Range 1,100 Backcolor { 0, 0, 160 } Forecolor { 0, 0, 0 }

  END WINDOW


  CENTER WINDOW Form_Splash
  ACTIVATE WINDOW Form_Splash

ELSE
Form_Splash.MINIMIZE
Form_Splash.RESTORE
ENDIF


Return
//-----------------------------------------------------------------------------.
static function exporta_xml(cTabela_Destinadas )

   Local PathFolder := getfolder()   ///local para gravacao dos dados
   Local   cPercent, cContador := 0, cContadorReferencia := 1000, nTotal := RecCount()
   Private cContadorRegistroGrafico  := 0
   Private cBarStepRegistro          := 100
   
	//conecta ao banco de dados
   Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)

   if empty(pathfolder)
      return nil
   endif
 
 
nCount:=0
nRecs:= Len( aTab )
  For i :=  1 To Len( aTab )
  If aTab[i,1] == .t.

					   cQuery:=("select xml,chave  FROM "+cTabela_Destinadas+"  WHERE Chave ='" + alltrim(aTab[i,6])+"'")     
					   oQuery:=oServer_NFe:Query( cQuery )
						If oQuery:NetErr()												
					       MsgStop("Erro SQL: "+oQuery:Error())
					       Return .f.
						End 
						oRow:= oQuery:GetRow(1)
							
						If Empty(oRow:FieldGet(1))
						    MsgInfo("Não Existe anexo para a Chave "+alltrim(aTab[i,6])+" - Verifique!!!","Consultas")
						    aTab[i,1]:= .f.
						EndIf

 

			  		 	HANDLE :=  FCREATE ( PathFolder+"\"+oRow:FieldGet(2)+"-nfe.XML",0)// cria o arquivo
					   FWRITE(Handle,oRow:FieldGet(1))
						fclose(handle)
						nCount++  

End  
Next
			  		oQuery:Destroy()
 
	msginfo("Exportação concluida, "+transf(nCount,"999")+" Notas Exportadas")

	if msgyesno("Deseja marcar todas como lançada ?")
	//conecta ao banco de dados
   Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)

  nCount:=0
  For i :=  1 To Len( aTab )
  
  If aTab[i,1] == .t.
     
	  				cQuery:=( "update "+cTabela_Destinadas+" set lancada=1 WHERE CHAVE='"+ aTab[i,6] +"'"  ) 
				 
				   oQuery:=oServer_NFe:Query( cQuery )
					If oQuery:NetErr()												
				       MsgStop("Erro SQL: "+oQuery:Error())
				       Return .f.
					End 
					if Retorno_SQL= .f.
						msginfo('Erro na gravação do lançamento!') 
					else
			  			nCount++
  					end
   End    
	Next
	
   Limpa_Destinadas( cTabela_Destinadas,Browse_Destinadas)
 
	msginfo("Verificação concluida, "+transf(nCount,"999")+" Notas marcadas")
	end
 return


//-----------------------------------------------------------------------------.
        Function imprime_xml_acbr(cXML )
		      LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
				LOCAL nLote    := '0'
		
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENT.TXT")
			         Return
               ENDIF 
              FWRITE(nHandle,"NFe.ImprimirDanfe("+alltrim(cXML)+")")
              FCLOSE(nHandle) 
		
			Return Nil
 


//-----------------------------------------------------------------------------.
        Function imprime_xml_pdf(cXML ,nNFe)
		      LOCAL cOrigem  := 'C:\ACBrMonitorPLUS\ent.txt' 
				LOCAL nLote    := '0'
		
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("Falha na Criação do Arquivo:","ENT.TXT")
			         Return
               ENDIF 
              FWRITE(nHandle,"NFe.ImprimirDanfePDF("+alltrim(cXML)+")")
              FCLOSE(nHandle) 
		            //         msginfo( x_Diretorio+"\NFe_Saida\"+nNFe+".PDF")

				  MY_WAIT( 1 )

			Return Nil
 

//-----------------------------------------------------------------------------.

FUNCTION DeleteTabDan(Browse_Destinadas)
	aTab:={}
   HB_SYMBOL_UNUSED( Browse_Destinadas )
   DELETE ITEM all FROM Browse_Destinadas OF Manifestacao_Destinatario
	Browse_Destinadas:Refresh( .t. )
RETURN Nil
// --------------------------------------------------------------------------.
procedure Carrega_Destinadas( cTabela_Destinadas,Browse_Destinadas)

DeleteTabDan(Browse_Destinadas)
 
	//conecta ao banco de dados
   Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)

//	cQuery:=  "select emissao,numero,cnpj,inscricao,chave,nome,valor,xevento,download FROM "+cTabela_Destinadas+"  where emissao<='"+dtos(DATE()+90) +"' and lancada=0 order by emissao"  
//	SQL_Error_oQuery_NFe( )
	   oQuery:=oServer_NFe:Query("select emissao,numero,cnpj,inscricao,chave,nome,valor,xevento,download FROM "+cTabela_Destinadas+"  where emissao<='"+dtos(DATE()+90) +"' and lancada=0 order by emissao" )
		  If oQuery:NetErr()												
           MsgInfo("Erro: " + oQuery:Error())
        Endif

 
For i := 1 To oQuery:LastRec()    
  oRow := oQuery:GetRow(i)
  AADD( aTab, { .f., oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6) ,oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9)  } )
  oQuery:Skip(1)
Next


if oQuery:LastRec()=0
  AADD( aTab, { .f., '', '', '', '','','','','','' } )
end

oQuery:Destroy()
	//desconecta do banco de dados
   Desconecta_MySQL_NFe ()

return
// --------------------------------------------------------------------------.
procedure Localiza_Destinadas( nOp, rData,dInicio,dFim,cCNPJ,nTipo,cTabela_Destinadas,Browse_Destinadas)
Local cPesq,cTipo//,dData
Local oQuery
 
if rData==1 ///tipo da selecao 1-data emissao 2-data lancamento
	dData:='emissao'
else
	dData:='dtlancamento'
end
   
if nTipo=1
	cTipo:="  "
elseif nTipo=2
	cTipo:=" and lancada=1"
elseif nTipo=3
	cTipo:=" and lancada=0"
end
if nOp==1
	if !empty(dtos(dInicio)).and.!empty(cCNPJ)
		cPesq:=" where &dData>='"+dtos(dInicio) +"' and &dData<='"+dtos(dFim) +"' and cnpj='"+limpa(cCNPJ)+"'" +cTipo+" order by emissao" 
	elseif !empty(dtos(dInicio)).and.empty(cCNPJ)
		cPesq:=" where &dData>='"+dtos(dInicio) +"' and &dData<='"+dtos(dFim) +"'" +cTipo+" order by emissao" 
	elseif empty(dtos(dInicio)).and.!empty(cCNPJ)
		cPesq:=" where cnpj='"+limpa(cCNPJ)+"'" +cTipo+" order by emissao" 
	elseif empty(dtos(dInicio)).and. empty(cCNPJ)
		cPesq:=" where &dData<='"+dtos(DATE()+90)+"' "  +cTipo+" order by emissao"  
	end
 
else
	Manifestacao_Destinatario.Txt_INICIAL.value:=''		
	Manifestacao_Destinatario.Txt_FINAL.value:=''
	Manifestacao_Destinatario.TxtCNPJ.value:=''
	cPesq:="  "  
end

 

DeleteTabDan(Browse_Destinadas)
 

	//conecta ao banco de dados
   Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)
if rData==2 ///tipo da selecao 1-data emissao 2-data lancamento
	aNFeLancadas:={}
	aNFeDestinadas:={}
	
	cQuery:= "select count(*),chave FROM compras   where dt_entrada>='"+dtos(dInicio) +"' and dt_entrada<='"+dtos(dFim) +"'"
 
	SQL_Error_oQuery()
	oRow := oQuery:GetRow(1)
	nTotal_Notas_Lancadas:=oRow:fieldGet(1)
	For i := 1 To oQuery:LastRec()
	  oRow := oQuery:GetRow(i)
	  AADD( aNFeLancadas, {  oRow:fieldGet(2)   } )
	  oQuery:Skip(1)
	Next
	
   oQuery:Destroy()
	cQuery:=  "select count(*),chave FROM "+cTabela_Destinadas+" where   &dData>='"+dtos(dInicio) +"' and &dData<='"+dtos(dFim) +"'"
	
   oQuery:=oServer_NFe:Query( cQuery )
	If oQuery:NetErr()												
       MsgStop("Erro SQL: "+oQuery:Error())
       Return .f.
	End 
	oRow := oQuery:GetRow(1)
	nTotal_Notas_Encontradas:=oRow:fieldGet(1)
	For i := 1 To oQuery:LastRec()
	  oRow := oQuery:GetRow(i)
	  AADD( aNFeDestinadas, {  oRow:fieldGet(2)   } )
	  oQuery:Skip(1)
	Next
	
   oQuery:Destroy()
 //  if (nTotal_Notas_Lancadas<> nTotal_Notas_Encontradas)<>0
		if nTotal_Notas_Lancadas<> nTotal_Notas_Encontradas
			msginfo(str(nTotal_Notas_Lancadas-nTotal_Notas_Encontradas)+" ->Notas não foram localizadas!"+QUEBRA+;
							" Qtd de Notas Lançadas-> "+str(nTotal_Notas_Lancadas)+QUEBRA+;
							" Qtd de Notas Destinadas-> "+str(nTotal_Notas_Encontradas))
		end
end	 
	cQuery:=  "select emissao,numero,cnpj,inscricao,chave,nome,valor,xevento,download FROM "+cTabela_Destinadas+cPesq
    
   oQuery:=oServer_NFe:Query( cQuery )
	If oQuery:NetErr()												
       MsgStop("Erro SQL: "+oQuery:Error())
       Return .f.
	End 


 
aTab:={}
   
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  AADD( aTab, { .f., oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6) ,oRow:fieldGet(7),oRow:fieldGet(8) ,oRow:fieldGet(9)  } )
  ADD ITEM  { .f., oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8)  ,oRow:fieldGet(9)  }  TO Browse_Destinadas OF Manifestacao_Destinatario  
  oQuery:Skip(1)
Next


if oQuery:LastRec()=0
  AADD( aTab, { .f., '', '', '', '','','','','','' } )
end

oQuery:Destroy()
	//desconecta do banco de dados
   Desconecta_MySQL_NFe ()
  Browse_Destinadas:Refresh( .t. )

return
// --------------------------------------------------------------------------.
procedure Limpa_Destinadas( cTabela_Destinadas,Browse_Destinadas)

DeleteTabDan(Browse_Destinadas)


	//conecta ao banco de dados
   Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)

	cQuery:=  "select emissao,numero,cnpj,inscricao,chave,nome,valor,xevento,download  FROM "+cTabela_Destinadas+"  where emissao<='"+dtos(DATE()+90) +"' and lancada=0 "  
   oQuery:=oServer_NFe:Query( cQuery )
	If oQuery:NetErr()												
       MsgStop("Erro SQL: "+oQuery:Error())
       Return .f.
	End 

aTab:={}

For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  AADD( aTab, { .f., oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9)    } )
  ADD ITEM  { .f., oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8) ,oRow:fieldGet(9)   }  TO Browse_Destinadas OF Manifestacao_Destinatario  
  oQuery:Skip(1)
Next


if oQuery:LastRec()=0
  AADD( aTab, { .f., '', '', '', '','','','','','' } )
end

oQuery:Destroy()
	//desconecta do banco de dados
//   Desconecta_MySQL_NFe ()
  Browse_Destinadas:Refresh( .t. )
		Manifestacao_Destinatario.ButtonEX_7.Enabled := .f.
		Manifestacao_Destinatario.ButtonEX_8.Enabled := .f.

return
// --------------------------------------------------------------------------.
procedure Imprime_Todas(cOp,cTabela_Destinadas)
Local i 
  msginfo(str(Len( aTab ))+" ->Notas Localizadas")   
  For i :=  1 To Len( aTab )
      If aTab[i,1] == .t.
			VISUALIZAR_NFe_ACBr(aTab[i,6],cTabela_Destinadas,cOp  )
       EndIf

   Next

if cOp==2
  For i :=  1 To Len( aTab )
     
       If aTab[i,1] == .t.
		 
     	  ShellExecute( x_Diretorio+"\NFeSaida\"+aTab[i,6]+".PDF", "Open", , , nil, 1)

       EndIf

  Next
End

 

Return

 
//***************************************
static function seleciona_destinada(nPos)
						 //    linha                     coluna
msginfo('Chave NF-e: '+aTab[ Browse_Destinadas:nAt,     6])

	if  aTab[nPos,1]==.f.
		aTab[nPos,1]:=.t.
	else
		aTab[nPos,1]:=.f.
	end

Retur
 

// --------------------------------------------------------------------------.
procedure Imprime_Relacao(cOp,cTabela_Destinadas)
Local i 
 
 
   ClearBuffer()

			 ARQ_TXT := "TEMP"
			 ARQ_TXT := ALLTRIM( ARQ_TXT ) + ".PRN"
			
			 FERASE("TEMP.PRN")	  
			 SET CONSOLE OFF
			 SETPRC(0,0)
			 SET PRINTER TO TEMP.PRN
			 SET DEVICE TO PRINT
			
       nPagina:=1
		@ 1,2 SAY (mgFANTASIA)  
		@ 1,117 SAY "Pagina: "+Transf(nPagina,"99999") 
 		@ 2,2   SAY 'RELATORIO DE NOTAS DESTINADAS'
 		@ 3,2   SAY RI
 		@ 4,2   SAY 'NF-e        EMISSAO   NOME DO DESTINATARIO                           VALOR  CHAVE'
 		@ 5,2   SAY RI

 
 LI:=6
 nTotal:=0
 
For i :=  1 To Len( aTab )
   If aTab[i,1] == .t.
 
	  @ LI,002 SAY  ( aTab[i,3] )  +" " +DTOC(aTab[i,2]) +" " +SUBSTR(aTab[i,7],1,40) +"   " +TRANSF(aTab[i,8] , "999,999.99")+"  " + aTab[i,6]  
	  nTotal+=aTab[i,8]                                                                    	
 	  LI++
	  IF LI=80
	    CABECALHO( )
	  ENDIF
                      
	End  
Next

	@ LI,2   SAY RI
	LI++
	@ LI,	35   SAY 'TOTAL GERAL     '+TRANSF(nTotal  , "@E  9,999,999.99" )   
 
	LI++
	@ LI,2   SAY RI

 SET DEVICE TO SCREEN
 SET CONSOLE ON
 SET PRINTER OFF

 cArq_tmp:=cBase_Itens+"p."+strtran(time(),[:],[])+".prn"
 SET CONSOLE OFF
 SETPRC(0,0)
 SET PRINTER TO &cArq_tmp
 SET DEVICE TO PRINT

 ? CHR(15)

 SET DEVICE TO SCREEN
 SET CONSOLE ON
 SET PRINTER OFF
 

// GERA_PDF("TEMP.PRN", 'S' )
   	
 

Return

//***************************************
////////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION CABECALHO( )

	  	@li,2 say ""
	  	nPagina++
		@ 1,2 SAY (mgFANTASIA)
		@ 1,117 SAY "Pagina: "+Transf(nPagina,"99999") 
 		@ 2,2   SAY 'RELATORIO DE NOTAS EMITIDAS DESTINADAS'
 		@ 3,2   SAY RI
 		@ 4,2   SAY 'NF-e        EMISSAO   NOME DO DESTINATARIO                          VALOR  CHAVE'
 		@ 5,2   SAY RI
      li:=6
      
RETURN .T.

// --------------------------------------------------------------------------.

function Selecionar_Todas(nOp)
 
if nOp==.t.
	for i=1 to len(aTab)
		aTab[i,1] :=.t.
	Next
 else                                                    	
	for i=1 to len(aTab)
		aTab[i,1] :=.f.
	Next
 end

         Browse_Destinadas:hide()   
         Browse_Destinadas:show()   
         Browse_Destinadas:LoadFields( .T. )    
         Browse_Destinadas:SetAppendMode( .T. ) // Activate Key DEL and confirm
         Browse_Destinadas:SetDeleteMode( .t., .t.)   // Activate Key DEL and confirm
         Browse_Destinadas:SetSelectMode( .f.)
 			Browse_Destinadas:HiliteCell( 1 )    //POSICIONA O CURSOR NA COL 1
			Browse_Destinadas:Refresh(.T.) 

Return
// --------------------------------------------------------------------------.

// --------------------------------------------------------------------------.
Function Habilita_Botoes_Filtro()
Local xxx:=0
	for i=1 to len(aTab)
 	  if    aTab[i,1] ==.t.
	  		xxx++
	  end
	Next
 
	if xxx==1
		Manifestacao_Destinatario.ButtonEX_7.Enabled := .t.
		Manifestacao_Destinatario.ButtonEX_8.Enabled := .t.
 	else
		Manifestacao_Destinatario.ButtonEX_7.Enabled := .f.
		Manifestacao_Destinatario.ButtonEX_8.Enabled := .f.
	end	
Return



/*
    //marcar a nota como lancada no espiao
 	if  NFe.Txt_TIPO_NOTA.Value=="S"
	   //confirma entrada da nota no banco de destinadas
		Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)
 
		cQuery:= "update nfe_"+limpa(mgCNPJ)+" set lancada=1,dtlancamento='"+dtos(NFe.TXT_DTES.VALUE)+"' WHERE CHAVE='"+ NFe.Txt_CHAVE_NFE.VALUE+"'"
	   oQuery:=oServer_NFe:Query( cQuery )
		If oQuery:NetErr()												
	       MsgStop("Erro SQL: "+oQuery:Error())
	       Return .f.
		End 
    end

*/