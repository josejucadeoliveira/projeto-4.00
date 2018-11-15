
#include "winprint.ch"
#include <minigui.ch>
#include "common.ch"
#include "hbclass.ch"
#include "hbwin.ch"
#include "harupdf.ch"
//#include "hbzebra.ch"
#include "hbcompat.ch"
#define clrNormal   {168,255,190}
#define clrBack     {255,255,128}
#INCLUDE "FILEIO.CH"

Function config
	   
LOCAL carquivo := "nfe.ini"
local lNovo    := iif (file( carquivo),.f.,.t.)
Public aPrinter := GetPrinters()
Public nImpressoraNFe:=0

carrega_variaves_padrao_sistema()	
 
 	 
			xxx:=1
			
			For i := 1 To len(aPrinter)

				if alltrim(aPrinter[i])=alltrim(mgImpressora_NFe) .and. !empty(alltrim(mgImpressora_NFe))
					nImpressoraNFe:=xxx
				end
			xxx++
				
			Next
  	
    ///Dados do contador
    cQuery:= "select nome,cnpj,cpf,crc,endereco,bairro,numero,cidade,estado,codmun,email,fone,fax,CEP FROM contador"         

	 oQuery:=oServer:Query( cQuery )
		If oQuery:NetErr()												
		 MsgStop(oQuery:Error())
		Return .f.
	 EndIf

 	aRow:= oQuery:GetRow(1)
	mgNomeContador:=aRow:fieldGet(1)
	mgCNPJContador:=aRow:fieldGet(2)
	mgCPFContador:=aRow:fieldGet(3)
	mgCRCContador:=aRow:fieldGet(4)
	mgENDContador:=aRow:fieldGet(5)
	mgBAIRROContador:=aRow:fieldGet(6)
	mgNUMEROContador:=aRow:fieldGet(7)
	mgCIDADEContador:=aRow:fieldGet(8)
	mgUFContador:=aRow:fieldGet(9)
	mgCODMUNContador:=aRow:fieldGet(10)
	mgEMAILContador:=aRow:fieldGet(11)
	mgFONEContador:=aRow:fieldGet(12)
	mgFAXContador:=aRow:fieldGet(13)
	mgCEPContador:=aRow:fieldGet(14)

	If      mgRamo_Atividade == 1 
		nRAMO := 1
	ElseIf  mgRamo_Atividade == 2
		nRAMO := 2
	ElseIf  mgRamo_Atividade == 3
		nRAMO := 3
	ElseIf  mgRamo_Atividade == 4
		nRAMO := 4
	ElseIf  mgRamo_Atividade == 5
		nRAMO := 5
	ElseIf  mgRamo_Atividade == 6
		nRAMO := 6
	ElseIf  mgRamo_Atividade == 7
		nRAMO := 7
	ElseIf  mgRamo_Atividade == 8
		nRAMO := 8
	ElseIf  mgRamo_Atividade == 9
		nRAMO := 9
     Else
		nRAMO := 6
 	Endif
 
DEFINE WINDOW CONFIG AT 181 , 361 WIDTH 863 HEIGHT 580 TITLE "Configura Sistema" MODAL NOSIZE  FONT "Arial Baltic" SIZE 10 


  DEFINE TAB Tab_1 AT 20,10 WIDTH 832 HEIGHT 480 VALUE 1 FONT "Arial" SIZE 9 TOOLTIP "" FLAT  ON CHANGE NIL MULTILINE

  
      PAGE "Dados Cadastrais da &Empresa"

        DEFINE LABEL Label_Fantasia
               ROW    30
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Nome Fantasia"
               
               
        END LABEL  

        DEFINE TEXTBOX Text_FANTASIA
               ROW    30
               COL    150
               WIDTH  500
               HEIGHT 24
               
               
               UPPERCASE  .T.
               MAXLENGTH  60
               VALUE  mgFANTASIA
        END TEXTBOX 

        DEFINE LABEL Label_Razao
               ROW    70
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Razão Social"
               
               
        END LABEL  

        DEFINE TEXTBOX Text_RAZAO
               ROW    70
               COL    150
               WIDTH  500
               HEIGHT 24
               
               
               UPPERCASE  .T.
               MAXLENGTH  60
               VALUE  mgEMPRESA
        END TEXTBOX 

        DEFINE LABEL Label_End
               ROW    110
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Endereço"
               
               
        END LABEL  

        DEFINE TEXTBOX Text_ENDERECO
               ROW    110
               COL    150
               WIDTH  290
               HEIGHT 24
               
               
               UPPERCASE  .T.
               MAXLENGTH  60
               VALUE  mgENDERECO
        END TEXTBOX 

        DEFINE LABEL Label_numero
               ROW    110
               COL    450
               WIDTH  61
               HEIGHT 24
               VALUE "Número"
               
               
        END LABEL  

        DEFINE TEXTBOX Text_NUMERO
               ROW    110
               COL    530
               WIDTH  120
               HEIGHT 24
               
               
               INPUTMASK "99999"
               NUMERIC  .T.
               VALUE  mgNUMERO
        END TEXTBOX 

        DEFINE LABEL Label_Bairro
               ROW    150
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Bairro"
               
               
        END LABEL  

        DEFINE TEXTBOX Text_BAIRRO
               ROW    150
               COL    150
               WIDTH  290
               HEIGHT 24
               
               
               VALUE  mgBAIRRO
        END TEXTBOX 

        DEFINE LABEL Label_CEP
               ROW    190
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "CEP"
               
               
        END LABEL  

        DEFINE TEXTBOX Text_CEP
               ROW    190
               COL    150
               WIDTH  120
               HEIGHT 24
               
               
               VALUE  mgCEP
			   INPUTMASK '99999-999'
        END TEXTBOX 


        DEFINE LABEL Label_CNPJ
               ROW    230
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "CNPJ"
               
               
        END LABEL  

        DEFINE TEXTBOX Text_CNPJ
               ROW    230
               COL    150
               WIDTH  290
               HEIGHT 24
               VALUE  mgCNPJ
			      ON ENTER {|| vcnpjcpf(config.Text_CNPJ.VALUE),CRIAMASCARA() } 
        END TEXTBOX 

        DEFINE LABEL Label_Insc
               ROW    270
               COL    10
               WIDTH  129
               HEIGHT 24
               VALUE "Inscrição Estadual"
        END LABEL  

        DEFINE TEXTBOX txtInscricao
               ROW    270
               COL    150
               WIDTH  290
               HEIGHT 24
					MAXLENGTH 14
               VALUE  mgINSCRICAO
				   ON ENTER {|| CRIAMASCARAIE( 2,config.Txt_uf.value ) }
        END TEXTBOX 

        DEFINE LABEL Label_SUFRAMA
               ROW    270
               COL    450
               WIDTH  61
               HEIGHT 24
               VALUE "Suframa"
        END LABEL  

        DEFINE TEXTBOX Text_SUFRAMA
               ROW    270
               COL    530
               WIDTH  120
               HEIGHT 24
               
               
               INPUTMASK "999999999"
               VALUE  mgSUFRAMA
        END TEXTBOX 
		
        DEFINE LABEL Label_Tel
               ROW    310
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Telefones"
               
               
        END LABEL  

        DEFINE TEXTBOX Text_FONE1
               ROW    310
               COL    150
               WIDTH  180
               HEIGHT 24
               VALUE  mgFONE
               
               
        END TEXTBOX 

        DEFINE TEXTBOX Text_FONE2
               ROW    310
               COL    350
               WIDTH  180
               HEIGHT 24
               VALUE  mgFAX
               
               
        END TEXTBOX 

        DEFINE LABEL Label_IBGE
               ROW    350
               COL    10
               WIDTH  200
               HEIGHT 24
               VALUE "Código IBGE do Municipio: "
               
               
        END LABEL  

        DEFINE BTNTEXTBOX TXT_CODMUN
            ROW    350
            COL    210
            WIDTH  120
            HEIGHT 24
            INPUTMASK "9999999"
			MAXLENGTH 7
			
            
   	        PICTURE "busca"
			value mgCODMUN
            ON GOTFOCUS This.BackColor:=clrBack 
            ON LOSTFOCUS This.BackColor:=clrNormal 
            ACTION {|| Iif ( !empty(Config.TXT_CODMUN.value),Config.TXT_CODMUN.value:='',Config.TXT_CODMUN.value:=''), Acha_CIDADE(  'CIDADES' )}
            ON ENTER {|| Acha_CIDADE( 'cidades' ), Config.ButtonEX_1.SETFOCUS  }
        END BTNTEXTBOX 

        DEFINE LABEL Label_Cidade
               ROW    350
               COL    350
               WIDTH  120
               HEIGHT 24
               VALUE "Cidade"
               
               
        END LABEL  

        DEFINE TEXTBOX Txt_CIDADE
               ROW    350
               COL    430
               WIDTH  200
               HEIGHT 24
               
               
               VALUE  mgCIDADE
        END TEXTBOX 
		
        DEFINE TEXTBOX Txt_UF
               ROW    350
               COL    700
               WIDTH  50
               HEIGHT 24
               
               
               VALUE  mgESTADO
        END TEXTBOX 
        DEFINE LABEL Label_ramo
               ROW    390
               COL    10
               WIDTH  240
               HEIGHT 24
               VALUE "Ramo de Atividade da Empresa"
               
               
        END LABEL  

        DEFINE COMBOBOX CB_RAMO
               ROW    390
               COL    270
               WIDTH  360
               HEIGHT 200
               ITEMS {"1-Supermercado",;
						"2-Livraria",;
						"3-Farmácia",;
						"4-Assistência Técnica",;
						"5-Auto Peças",;
						"6-Varejo em Geral",;
						"7-Industria em Geral",;
						"8-Loja de Confecções",;
						"9-Oficina Mecanica "}
               VALUE nRAMO
               VALUESOURCE ""
               GRIPPERTEXT ""
        END COMBOBOX  

     DEFINE LABEL Label_vencim
            ROW    430
            COL    10
            WIDTH  120
            HEIGHT 24
            VALUE "Data Validade"
     END LABEL 

     DEFINE TEXTBOX Txt_DATA
            ROW    430
            COL    130
            WIDTH  120
            HEIGHT 24
			DATE .T.
			value mgvalido
     END TEXTBOX 
	 
    DEFINE LABEL Label_4
            ROW    430
            COL    260
            WIDTH  120
            HEIGHT 24
            VALUE "Serial"
     END LABEL  
 
     DEFINE TEXTBOX Txt_SERIAL
            ROW    430
            COL    370
            WIDTH  220
            HEIGHT 24
			UPPERCASE .T.
			value mgSerial
			ON LOSTFOCUS CONFERE_SERIAL()
     END TEXTBOX 

    END PAGE 


    PAGE "Fa&turamento"

		DEFINE CHECKBOX Chk_MANUPED
              ROW    40
              COL    10
              WIDTH  410
              HEIGHT 28
              CAPTION 'Usar manutenção de pedidos no terminal ?'
              VALUE mgMANU_PED
				  TRANSPARENT .T.
        END CHECKBOX  

       DEFINE CHECKBOX Chk_Emissao_NFe
              ROW    80
              COL    10
              WIDTH  410
              HEIGHT 28
              CAPTION "Usar impressão de NF-e neste terminal"
              VALUE mgEMI_NFe
				  TRANSPARENT .T.
        END CHECKBOX  

	     DEFINE CHECKBOX Chk_Emissao_NFCe
	           ROW    80
	           COL    450
	           WIDTH  360
	           HEIGHT 23
	           CAPTION "Usar impressão de NFC-e (Consumidor) neste terminal"
	           VALUE mgEMI_NFCe
				  TRANSPARENT .T.
	     END CHECKBOX  
	
        DEFINE LABEL Label_mensagem
               ROW    120
               COL    10
               WIDTH  210
               HEIGHT 24
               VALUE "Mensagem Padrão na Venda"
				  TRANSPARENT .T.
        END LABEL  

        DEFINE TEXTBOX Txt_MENSAGEM
               ROW    120
               COL    230
               WIDTH  410
               HEIGHT 24
			   MAXLENGTH 60
               VALUE  mgMENSAGEM
        END TEXTBOX 
		
       DEFINE CHECKBOX Chk_SomaItens
              ROW    160
              COL    10
              WIDTH  410
              HEIGHT 28
              CAPTION "Sobrescrever itens na venda"
              VALUE mgSomaItens
				  TRANSPARENT .T.
        END CHECKBOX  
		

     DEFINE CHECKBOX Chk_Tipo_Pesquisa_Item
           ROW    200
           COL    10
           WIDTH  410
           HEIGHT 23
           CAPTION "Pesquisa Letra a Letra na tela de vendas"
           VALUE mgTipo_Pesquisa_Item
			  TRANSPARENT .T.
     END CHECKBOX  

     DEFINE CHECKBOX Chk_Pesquisa_Trecho
           ROW    200
           COL    450
           WIDTH  360
           HEIGHT 23
           CAPTION "Pesquisa Techo da Descrição de Produtos"
           VALUE mgPesquisa_Trecho
			  TRANSPARENT .T.
     END CHECKBOX  
	 
     DEFINE CHECKBOX Chk_Agenda
           ROW    240
           COL    10
           WIDTH  410
           HEIGHT 23
           CAPTION "Usar Agenda"
           VALUE mgAgenda
              
              
			  TRANSPARENT .T.
     END CHECKBOX  
	 
     DEFINE CHECKBOX Chk_Bloqueia_Exclusao_PDV
           ROW    280
           COL    10
           WIDTH  410
           HEIGHT 23
           CAPTION "Solicitar Senha na Exclusão de Itens no PDV"
           VALUE mgExcluir_Itens_PDV
			  TRANSPARENT .T.
     END CHECKBOX  

     DEFINE CHECKBOX Chk_Matriz
           ROW    320
           COL    10
           WIDTH  410
           HEIGHT 23
           CAPTION "Empresa possui filiais"
           VALUE mgMatriz
			  TRANSPARENT .T.
     END CHECKBOX  
		
	END PAGE 

    PAGE "&Financeiro"

        DEFINE LABEL Label_tx
               ROW    40
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Taxa mensal de juros sobre titulos a Receber %:"
        END LABEL  

        DEFINE TEXTBOX Txt_JUROS
               ROW    40
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "99.99"
               NUMERIC  .T.
               VALUE  mgJUROS
        END TEXTBOX 

        DEFINE LABEL Label_qut
               ROW    70
               COL    10
               WIDTH  363
               HEIGHT 36
               VALUE "Quantidade de dias de carência na cobrança de juros nas duplicatas a Receber:"
               
               
        END LABEL  

        DEFINE TEXTBOX Txt_Carencia
               ROW    90
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "999"
               NUMERIC  .T.
               VALUE  mgCARENCIA
        END TEXTBOX 

        DEFINE LABEL Label_desc
               ROW    120
               COL    10
               WIDTH  354
               HEIGHT 24
               VALUE "Desconto pontualidade nas Duplicatas a  Receber:"
        END LABEL  

        DEFINE TEXTBOX Txt_PONTUALIDADE
               ROW    120
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "99.99"
               NUMERIC  .T.
               VALUE  mgDESC_PONT
        END TEXTBOX 

        DEFINE LABEL Label_cont
               ROW    150
               COL    10
               WIDTH  363
               HEIGHT 23
               VALUE "Conta Corrente Padrão do Terminal"
        END LABEL  

        DEFINE COMBOBOX Cb_CONTA
               ROW    150
               COL    380
               WIDTH  119
               HEIGHT 100
               ITEMS aContas
	            VALUE nCONTA
               FONTSIZE 9
        END COMBOBOX  

        DEFINE LABEL Label_FINANCEIRO
               ROW    180
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Taxa mensal de juros nas Vendas a Prazo %:"
        END LABEL  



        DEFINE TEXTBOX Txt_FINANCEIRO
               ROW    180
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "99.99"
               NUMERIC  .T.
               VALUE  mgFINANCEIRO
        END TEXTBOX 
        
	     DEFINE CHECKBOX Chk_Bloqueia_Financeiro
	           ROW    180
	           COL    510
	           WIDTH  300
	           HEIGHT 28
	           CAPTION "Bloqueia Percentual Financeiro Vendas a Prazo"
	           VALUE mgbloq_financeiro
				  TRANSPARENT .T.
	     END CHECKBOX  

        DEFINE LABEL Label_PARCELA_INICIAL
               ROW    210
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Cobrar Taxa financeira a partir de qual parcela:"
        END LABEL  

        DEFINE TEXTBOX Txt_PARCELA_INICIAL
               ROW    210
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "999"
               NUMERIC  .T.
               VALUE  mgPARCELA1
        END TEXTBOX 

       DEFINE CHECKBOX Chk_BAIXA
              ROW    240
              COL    10
              WIDTH  400
              HEIGHT 28
              CAPTION 'Baixar entrada automatica na venda à vista ?'
              VALUE mgBAIXA_DUPL
        END CHECKBOX  

        DEFINE LABEL Label_DESCONTO_ITEM
               ROW    280
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Percentual Limite de Desconto para Itens:"
        END LABEL  

        DEFINE TEXTBOX Txt_DESCONTO_ITEM
               ROW    280
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "99.99"
               NUMERIC  .T.
               VALUE  mgDESC_ITEM
        END TEXTBOX 

        DEFINE LABEL Label_DESCONTO_PEDIDO
               ROW    310
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Percentual Limite de Desconto para os Pedidos:"
        END LABEL  

        DEFINE TEXTBOX Txt_DESCONTO_PEDIDO
               ROW    310
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "99.99"
               NUMERIC  .T.
               VALUE  mgDESC_PED
        END TEXTBOX 		

       DEFINE CHECKBOX Chk_DESCONTO_FECHA_VENDA
              ROW    340
              COL    10
              WIDTH  400
              HEIGHT 28
              CAPTION 'Permitir desconto no fechamento da Pré-Venda ?'
              VALUE mgDESC_PREVENDA
        END CHECKBOX  

        DEFINE LABEL Label_LIMITE_PARCELAS
               ROW    380
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Quantidade Maxíma de Parcelas na Venda:"
        END LABEL  

        DEFINE TEXTBOX Txt_LIMITE_PARCELAS
               ROW    380
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "999"
               NUMERIC  .T.
               VALUE  mglimite_parcelas
        END TEXTBOX 	

		
        DEFINE LABEL Label_LIMITE_DIAS
               ROW    410
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Quantidade dias vencidos para bloqueio na Venda:"
        END LABEL  

        DEFINE TEXTBOX Txt_LIMITE_DIAS_VENCIDO
				ROW    410
               COL    380
               WIDTH  120
               HEIGHT 24
               INPUTMASK "999"
               NUMERIC  .T.
               VALUE  mglimite_dias_vencido
        END TEXTBOX 		

	END PAGE 

    PAGE "Contas a &Pagar"

		DEFINE CHECKBOX Chk_LANCAPAGAR
              ROW    40
              COL    10
              WIDTH  500
              HEIGHT 28
              CAPTION 'lança Contas a Pagar Automático na Entrada de Notas Fiscais ?'
              VALUE mglanca_pagar_nf
			  TRANSPARENT .T.
        END CHECKBOX  

    END PAGE 

    PAGE "&Estoque"

        DEFINE LABEL Label_tiposad
               ROW    40
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "[A]-Aceita [B]-Bloqueia [T]-Testa saldo do Estoque:"
        END LABEL  

        DEFINE TEXTBOX Txt_ESTOQUE
               ROW    40
               COL    380
               WIDTH  120
               HEIGHT 24
               UPPERCASE  .T.
               MAXLENGTH  1
               VALUE  mgESTOQUE
        END TEXTBOX 

        DEFINE LABEL Label_maqk
               ROW    70
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Markup Preço de Vendas: S-Simples I-Com Impostos"
        END LABEL  

        DEFINE TEXTBOX Txt_Markup
               ROW    70
               COL    380
               WIDTH  120
               HEIGHT 24
               UPPERCASE  .T.
               MAXLENGTH  1
               VALUE  mgMARKUP
        END TEXTBOX 

       DEFINE CHECKBOX Chk_Balanca
              ROW    100
              COL    10
              WIDTH  400
              HEIGHT 25
              CAPTION "Usar Balança Eletronica no terminal"
 			  		VALUE mgBALANCA
			  		TRANSPARENT .T.
        END CHECKBOX  

       DEFINE CHECKBOX Chk_tabela
              ROW    130
              COL    10
              WIDTH  400
              HEIGHT 26
              CAPTION "Usar Tabelas Adicionais de Preços"
			  VALUE mgTABELA
        END CHECKBOX  

       DEFINE CHECKBOX Chk_preco
              ROW    160
              COL    10
              WIDTH  400
              HEIGHT 28
              CAPTION "Atualizar Preço de Venda na Entrada de Produtos"
        END CHECKBOX  

        DEFINE LABEL Label_MINIMO
               ROW    200
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Prazo médio em dias para cálculo do estoque Mínimo"
        END LABEL  

        DEFINE TEXTBOX Txt_Minimo
               ROW    200
               COL    380
               WIDTH  120
               HEIGHT 24
               NUMERIC  .T.
               INPUTMASK "99999"
               VALUE  mgMINIMO
        END TEXTBOX 

        DEFINE LABEL Label_maximo
               ROW    230
               COL    10
               WIDTH  363
               HEIGHT 24
               VALUE "Percentual do estoque máximo sobre o minimo %"
         END LABEL  

        DEFINE TEXTBOX Txt_Maximo
               ROW    230
               COL    380
               WIDTH  120
               HEIGHT 24
               NUMERIC  .T.
               INPUTMASK "999.99"
               VALUE  mgMAXIMO
        END TEXTBOX 

        DEFINE FRAME Frame_Tabelas
               ROW    40
               COL    520
               WIDTH  293
               HEIGHT 221
               CAPTION "Percentuais Tabelas"
             FONTCOLOR {0,64,128}
       END FRAME  

        DEFINE LABEL Lbl_TABAVISTA
               ROW    60
               COL    530
               WIDTH  173
               HEIGHT 22
               VALUE "Desconto Preço à Vista%"
               FONTNAME 'Arial'
               FONTSIZE 9
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Txt_PRCAVISTA
               ROW    60
               COL    710
               WIDTH  93
               HEIGHT 24
               FONTNAME 'Arial'
               FONTSIZE 10
               BACKCOLOR {255,255,128}
               INPUTMASK "999.99"
               NUMERIC  .T.
	       VALUE mgPRCAVISTA
        END TEXTBOX 

        DEFINE FRAME Frame_Campos
		         ROW    270
               COL    520
               WIDTH  293
               HEIGHT 200
               CAPTION "Nome das Tabelas"
             FONTCOLOR {0,64,128}
       END FRAME 
		  
        DEFINE LABEL Lbl_NOME_TABELA1
               ROW    290
               COL    530
               WIDTH  60
               HEIGHT 22
               VALUE "Tabela 1"
               FONTNAME 'Arial'
               FONTSIZE 9
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Txt_NOME_TABELA1
               ROW    290
               COL    600
               WIDTH  200
               HEIGHT 24
               FONTNAME 'Arial'
               FONTSIZE 10
               BACKCOLOR {255,255,128}
               value mgNome_Tab1
        END TEXTBOX 

        DEFINE LABEL Lbl_NOME_TABELA2
               ROW    320
               COL    530
               WIDTH  60
               HEIGHT 22
               VALUE "Tabela 2"
               FONTNAME 'Arial'
               FONTSIZE 9
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Txt_NOME_TABELA2
               ROW    320
               COL    600
               WIDTH  200
               HEIGHT 24
               FONTNAME 'Arial'
               FONTSIZE 10
               BACKCOLOR {255,255,128}
               value mgNome_Tab2
        END TEXTBOX 

        DEFINE LABEL Lbl_NOME_TABELA3
               ROW    350
               COL    530
               WIDTH  60
               HEIGHT 22
               VALUE "Tabela 3"
               FONTNAME 'Arial'
               FONTSIZE 9
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Txt_NOME_TABELA3
               ROW    350
               COL    600
               WIDTH  200
               HEIGHT 24
               FONTNAME 'Arial'
               FONTSIZE 10
               BACKCOLOR {255,255,128}
               value mgNome_Tab3
        END TEXTBOX 
        DEFINE LABEL Lbl_NOME_TABELA4
               ROW    380
               COL    530
               WIDTH  60
               HEIGHT 22
               VALUE "Tabela 4"
               FONTNAME 'Arial'
               FONTSIZE 9
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Txt_NOME_TABELA4
               ROW    380
               COL    600
               WIDTH  200
               HEIGHT 24
               FONTNAME 'Arial'
               FONTSIZE 10
               BACKCOLOR {255,255,128}
               value mgNome_Tab4
        END TEXTBOX 
        DEFINE LABEL Lbl_NOME_TABELA5
               ROW    410
               COL    530
               WIDTH  60
               HEIGHT 22
               VALUE "Tabela 5"
               FONTNAME 'Arial'
               FONTSIZE 9
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Txt_NOME_TABELA5
               ROW    410
               COL    600
               WIDTH  200
               HEIGHT 24
               FONTNAME 'Arial'
               FONTSIZE 10
               BACKCOLOR {255,255,128}
               value mgNome_Tab5
        END TEXTBOX 

    END PAGE 

    PAGE "&ECF"

       DEFINE CHECKBOX Chk_ECF
              ROW    40
              COL    10
              WIDTH  400
              HEIGHT 28
              CAPTION 'Empresa usa Emissor de Cupom Fiscal (ECF) ?'
              VALUE mgECF
              
              
        END CHECKBOX  

		DEFINE CHECKBOX Chk_ECFVINC
              ROW    80
              COL    10
              WIDTH  400
              HEIGHT 28
              CAPTION 'Usar impressão de documento vinculado ?'
              VALUE mgECF_VINC
              
              
        END CHECKBOX  

		DEFINE CHECKBOX Chk_IMP_SERVICO
              ROW    120
              COL    10
              WIDTH  400
              HEIGHT 28
              CAPTION 'Imprimir Serviços no Cupom Fiscal ?'
              VALUE mgIMP_SV_CUPOM
        END CHECKBOX  

		DEFINE CHECKBOX Chk_POUCO_PAPEL
              ROW    160
              COL    10
              WIDTH  400
              HEIGHT 28
              CAPTION 'Desativar a Função para verificar Pouco Papel ?'
              VALUE mgPOUCO_PAPEL
        END CHECKBOX  

        DEFINE FRAME Frame_ecfs
               ROW    40
               COL    460
               WIDTH  347
               HEIGHT 125
               CAPTION "Modelos de ECFs"
              FONTCOLOR {0,64,128}
       END FRAME  
       
        DEFINE RADIOGROUP RdG_ecfs
               ROW    70
               COL    480
               WIDTH  200
               HEIGHT 50
               VALUE  (mgmodelo_ecf)
               OPTIONS {'Daruma','Bematch','ACBrMonitor'}
         END RADIOGROUP  
		
		END PAGE 


    PAGE "&Relatórios"

       DEFINE CHECKBOX Chk_LPT1
              ROW    40
              COL    10
              WIDTH  300
              HEIGHT 28
              CAPTION 'Imprimir vendas em impressora matricial ?'
              VALUE mgLPT1
              
              
        END CHECKBOX  

       DEFINE CHECKBOX Chk_Tipo_Cabo_Impressao
              ROW    40
              COL    370
              WIDTH  400
              HEIGHT 28
              CAPTION 'Cabo de Conexão com a impressora é LPT1 ?'
              VALUE cTipoCaboImp
              TRANSPARENT .F.
        END CHECKBOX  


		DEFINE CHECKBOX Chk_Impressao_Pedidos
              ROW    80
              COL    10
              WIDTH  350
              HEIGHT 28
              CAPTION 'Impressão on line para pedidos ?'
              VALUE mgIMP_PED
        END CHECKBOX  

       DEFINE CHECKBOX Chk_Imprime_Duplicata_Unica
              ROW    80
              COL    370
              WIDTH  450
              HEIGHT 28
              CAPTION 'Impressão de uma Única Duplicata para a Venda Parcelada ?'
              VALUE mgimp_unica_dup
              TRANSPARENT .F.
        END CHECKBOX  


     DEFINE LABEL Label_bancopadrao
            ROW    120
            COL    370
            WIDTH  320
            HEIGHT 24
            VALUE "Banco padrão para impressão de Boletos"
     END LABEL  

     DEFINE COMBOBOX Cb_BancoPadrao
            ROW    150
            COL    370
            WIDTH  260
            HEIGHT 200
            FONTNAME 'Arial'
            ITEMS aBancos
				DISPLAYEDIT	.T.
				VALUE val(mgBancoPadraoBol)
     END COMBOBOX  

       DEFINE CHECKBOX Chk_Impressao_Orcamentos
              ROW    120
              COL    10
              WIDTH  350
              HEIGHT 28
              CAPTION 'Impressão on line para Orcamentos ?'
              VALUE mgIMP_ORC
              
              
        END CHECKBOX  

       DEFINE CHECKBOX Chk_Impressao_NotaFiscal
              ROW    160
              COL    10
              WIDTH  350
              HEIGHT 28
              CAPTION 'Impressão on line para Nota Fiscal ?'
              VALUE mgIMP_NF
              
              
        END CHECKBOX  

       DEFINE CHECKBOX Chk_Impressao_Duplicatas
              ROW    200
              COL    10
              WIDTH  300
              HEIGHT 28
              CAPTION 'Impressão on line para Duplicatas ?'
              VALUE mgIMP_DUP
              
              
        END CHECKBOX  
		
       DEFINE CHECKBOX Chk_Impressao_Recibo
              ROW    240
              COL    10
              WIDTH  400
              HEIGHT 28
              CAPTION 'Impressão on line para Recibo de Pagamento ?'
              VALUE mgIMP_RECIBO
              
              
        END CHECKBOX  

        DEFINE FRAME Frame_3
               ROW    280
               COL    10
               WIDTH  420
               HEIGHT 180
               CAPTION "Opções da Impressão do Pedido Impressora Matricial"
        END FRAME  

        DEFINE RADIOGROUP RdG_TipoPedido
               ROW    300
               COL    20
               WIDTH  360
               HEIGHT 28
               OPTIONS {'Imprimir Código do Fornecedor','Imprimir Código de Barras','Imprimir Marca','Imprimir Locação do Produto'}
               VALUE val(mgTIPO_IMP_PED)
         END RADIOGROUP  

    END PAGE 
	
    PAGE "&Tributação"

        DEFINE FRAME Frame_PISCOFINS
               ROW    30
               COL    10
               WIDTH  816
               HEIGHT 123
               FONTNAME "Arial"
               FONTSIZE 9
               CAPTION "Regime de Tributação do PIS/CONFIS"
               FONTCOLOR {0,64,128}
        END FRAME  

        DEFINE LABEL Label_COD_INC_TRIB
               ROW    50
               COL    20
               WIDTH  147
               HEIGHT 24
               VALUE "Código da Incidência"
               FONTNAME "Arial"
               FONTSIZE 9
        END LABEL  

        DEFINE COMBOBOX Combo_COD_INC_TRIB
               ROW    50
               COL    170
               WIDTH  620
               HEIGHT 105
               ITEMS {"1-Regime não-cumulativo ","2-Regime cumulativo","3-Regimes não-cumulativo e cumulativo"}
               VALUE mgcod_inc_trib
               FONTNAME "Arial"
               FONTSIZE 9
        END COMBOBOX  

        DEFINE LABEL Label_IND_APRO_CRE
               ROW    80
               COL    20
               WIDTH  147
               HEIGHT 24
               VALUE "Método de Apropriação"
               FONTNAME "Arial"
               FONTSIZE 9
        END LABEL  

        DEFINE COMBOBOX Combo_IND_APRO_CRE
               ROW    80
               COL    170
               WIDTH  620
               HEIGHT 100
               ITEMS {"1 – Método de Apropriação Direta","2 – Método de Rateio Proporcional (Receita Bruta)"}
               VALUE mgIND_APRO_CRED
               FONTNAME "Arial"
               FONTSIZE 9
        END COMBOBOX  

        DEFINE LABEL Label_COD_TIPO_CON
               ROW    110
               COL    20
               WIDTH  147
               HEIGHT 24
               VALUE "Tipo de Contribuição"
               FONTNAME "Arial"
               FONTSIZE 9
        END LABEL  

        DEFINE COMBOBOX Combo_COD_TIPO_CON
               ROW    110
               COL    170
               WIDTH  620
               HEIGHT 100
               ITEMS {"1 – Apuração da Contribuição Exclusivamente a Alíquota Básica","2 – Apuração da Contribuição a Alíquotas Específicas (Diferenciadas e/ou por Unidade de Medida de Produto)"}
               VALUE mgCOD_TIPO_CONT
               FONTNAME "Arial"
               FONTSIZE 9
        END COMBOBOX  

		DEFINE CHECKBOX Chk_SPED
              ROW    160
              COL    10
              WIDTH  330
              HEIGHT 28
              CAPTION 'Gerar Aquivo Sped Fiscal ?'
              VALUE mggera_spedfiscal
              
              
        END CHECKBOX  

		DEFINE CHECKBOX Chk_SPEDCONTRIBUICOES
              ROW    160
              COL    380
              WIDTH  330
              HEIGHT 28
              CAPTION 'Gerar Aquivo Sped Pis/Cofins ?'
              VALUE mggera_spedpis
              
              
        END CHECKBOX  

        DEFINE FRAME Frame_regimeicms
               ROW    200
               COL    10
               WIDTH  815
               HEIGHT 140
               FONTNAME "Arial"
               FONTSIZE 9
               CAPTION "Regime de Tributação do ICMS para emissão de NF-e"
               FONTCOLOR {0,64,128}
        END FRAME  

        DEFINE LABEL Label_regime
               ROW    220
               COL    20
               WIDTH  165
               HEIGHT 24
               VALUE "Regime de Tributação:"
        END LABEL  

        DEFINE COMBOBOX Cb_regime
               ROW    220
               COL    190
               WIDTH  350
               HEIGHT 100
               ITEMS {"1-Simples Nacional ","2-Simples Nacional-excesso de sublimite de receita bruta","3-Regime Normal"}
               VALUE mgREGIME
               FONTNAME "Arial"
               FONTSIZE 9
               ON CHANGE {||IIF( This.Value==3,(Config.TXT_ALICOTA.ENABLED:=.F.,Config.Cb_regime_apuracao.visible:=.t.,Config.Label_Enquadramento.visible:=.F.),;
											(Config.TXT_ALICOTA.ENABLED:=.T.,Config.Cb_regime_apuracao.visible:=.f.,Config.Label_Enquadramento.visible:=.t.,Tabela_Simples_Nacional()))}
        END COMBOBOX  

//               ON CHANGE IF(This.Value<>3,,Config.TXT_ALICOTA.ENABLED:=.f.)

        DEFINE LABEL Label_Enquadramento
               ROW    220
               COL    550
               WIDTH  250
               HEIGHT 25
				   BORDER .T.
				   BACKCOLOR {0,255,255} 
        END LABEL   

        DEFINE COMBOBOX Cb_regime_apuracao
               ROW    220
               COL    550
               WIDTH  190
               HEIGHT 100
               ITEMS {"1-Lucro Presumido ","2-Lucro Real"}
               VALUE mgREGIME_AP
               FONTNAME "Arial"
               FONTSIZE 9
        END COMBOBOX  

        DEFINE LABEL Label_alicota
               ROW    250
               COL    20
               WIDTH  169
               HEIGHT 26
               VALUE "Aliquota do Simples:"
               
               
        END LABEL  

        DEFINE TEXTBOX TXT_ALICOTA
               ROW    250
               COL    190
               WIDTH  80
               HEIGHT 24
               INPUTMASK '999.999'
               NUMERIC  .T.
               VALUE  mgALICOTA
        END TEXTBOX 

        DEFINE LABEL Label_alicotaST
               ROW    280
               COL    20
               WIDTH  173
               HEIGHT 24
               VALUE "Aliquota ICMS ST:"
        END LABEL  

        DEFINE TEXTBOX TXT_ALICOTAST
               ROW    280
               COL    190
               WIDTH  80
               HEIGHT 24
               INPUTMASK '999.999'
               NUMERIC  .T.
               VALUE  mgALICOTAst
        END TEXTBOX 

        DEFINE LABEL Label_SERIE_NFe
               ROW    310
               COL    20
               WIDTH  172
               HEIGHT 22
               VALUE "Número de Série Saídas:"
        END LABEL  

        DEFINE TEXTBOX TXT_serie_nfe
               ROW    310
               COL    190
               WIDTH  80
               HEIGHT 24
               INPUTMASK '999'
               NUMERIC  .T.
               VALUE  mgSERIE_NFe
        END TEXTBOX 

        DEFINE LABEL Label_SERIE_NFe_Entradas
               ROW    310
               COL    375
               WIDTH  172
               HEIGHT 22
               VALUE "Número de Série Entradas:"
        END LABEL  

        DEFINE TEXTBOX TXT_SERIE_NFe_Entradas
               ROW    310
               COL    560
               WIDTH  80
               HEIGHT 24
               INPUTMASK '999'
               NUMERIC  .T.
               VALUE  mgSERIE_NFe_Ent
        END TEXTBOX 

       DEFINE CHECKBOX Chk_GERACREDITO
              ROW    250
              COL    375
              WIDTH  400
              HEIGHT 28
              CAPTION 'Gera Crédito de Icms para empresas do Simples Nacional ?'
              VALUE mgGeraCreditoIcms
              ON CHANGE {||IIF( This.Value==.t.,(Config.INFORMACAO_NFe.enabled:=.f.,Config.INFORMACAO_NFe.value:=''),Config.INFORMACAO_NFe.enabled:=.t. ),;
								   iif( Config.TXT_ALICOTA.value<=0,(msginfo('Valor da Alicota do Simples inválida para esta opção...'),Config.TXT_ALICOTA.SETFOCUS),) }
        END CHECKBOX 

       DEFINE CHECKBOX Chk_IMP_PAGAMENTO_NFe
              ROW    280
              COL    375
              WIDTH  400
              HEIGHT 28
              CAPTION 'Imprimir tipo do pagamento na NFe ?'
              VALUE mgimp_pgto_nfe
       END CHECKBOX 

        DEFINE FRAME Frame_mensagem
               ROW    350
               COL    10
               WIDTH  815
               HEIGHT 115
               FONTNAME "Arial"
               FONTSIZE 9
               CAPTION "Informações complementares padrão para NF-e"
               FONTCOLOR {0,64,128}
        END FRAME  

	   @ 370,20 EDITBOX INFORMACAO_NFe ;
	      WIDTH 800 HEIGHT 60 ;
              VALUE mgINF_NFe MAXLENGTH 300;
              FONT "ARIAL" SIZE 09
		
        DEFINE LABEL Label_inf
               ROW    440
               COL    20
               WIDTH  500
               HEIGHT 20 
               VALUE "* Somente utilizar caractes e símbolos padrão do teclado"
               FONTSIZE 9
               FONTCOLOR RED
               FONTITALIC .T.
        END LABEL  
		                                
	END PAGE 


    PAGE "NF-e" IMAGE ''


        DEFINE FRAME Frame_2
               ROW    30
               COL    20
               WIDTH  367
               HEIGHT 55
               CAPTION "Selecione o Ambiente de Destino"
        END FRAME  
			
        DEFINE RADIOGROUP RdG_ambiente_nfe
               ROW    45
               COL    30
               WIDTH  148
               HEIGHT 29
               OPTIONS {'Produção','Homologação'}
               VALUE mgambiente_nfe  
               HORIZONTAL .T.
        END RADIOGROUP   
 
     DEFINE LABEL Label_impressoranfe
            ROW    30
            COL    420
            WIDTH  220
            HEIGHT 19
            VALUE "Impressora Padrão Impressão NF-e"
     END LABEL  
     
     DEFINE COMBOBOX Combo_impressoranfe
            ROW    50
            COL    420
            WIDTH  300
            HEIGHT 100
 				ITEMS aPrinter
 				value nImpressoraNFe
     END COMBOBOX  

       DEFINE CHECKBOX Chk_NFeACBr
              ROW    85
              COL    20
              WIDTH  380
              HEIGHT 28
              CAPTION "Gerar NFe pelo ACBrMonitor?"
              VALUE mgNfe_acbr
              FONTNAME "Arial Baltic"
              FONTSIZE 12
        END CHECKBOX  

        DEFINE RADIOGROUP RdG_TipoAcBR
               ROW    85
               COL    440
               WIDTH  100
               HEIGHT 50
               VALUE mgTIPO_ACBR
               OPTIONS {'Capicom','OpenSSL'}
               HORIZONTAL .T.
         END RADIOGROUP  

        DEFINE LABEL Label_certificado
               ROW    130
               COL    20
               WIDTH  120
               HEIGHT 24
               VALUE "Certificado Digital"
        END LABEL  

        DEFINE TEXTBOX Txt_CERTIFICADO
               ROW    130
               COL    150
               WIDTH  250
               HEIGHT 24
               UPPERCASE  .T.
               MAXLENGTH  60
               VALUE  mgCERTIFICADO
        END TEXTBOX 


     DEFINE BUTTONEX ButtonEX_CERT
            ROW    130
            COL    410
            WIDTH  24
            HEIGHT 24
            PICTURE "busca"
	         ACTION BUSCACERTIFICADO()
     END BUTTONEX  

        DEFINE LABEL Label_caminhocertificado
               ROW    110
               COL    440
               WIDTH  350
               HEIGHT 24
               VALUE "Caminho Certificado Digital"
        END LABEL
		    
        DEFINE TEXTBOX Txt_CAMINHOCERTIFICADO 	
               ROW    130
               COL    440
               WIDTH  350
               HEIGHT 24
               UPPERCASE  .T.
               MAXLENGTH  60
               VALUE  mgCAMINHO_CTD
        END TEXTBOX 


     DEFINE BUTTONEX ButtonEX_CAMINHO
            ROW    130
            COL    800
            WIDTH  24
            HEIGHT 24
            PICTURE "busca"
	         ACTION localiza_certificado()
     END BUTTONEX  

        DEFINE LABEL Label_senhacertificado
               ROW    160
               COL    20
               WIDTH  120
               HEIGHT 24
               VALUE "Senha Cert. Digital"
        END LABEL  

        DEFINE TEXTBOX Txt_SENHA_CERTIFICADO
               ROW    160
               COL    150
               WIDTH  250
               HEIGHT 24
               MAXLENGTH  60
               Password     .T.
               VALUE  mgSenha_Certificado
        END TEXTBOX 


        DEFINE FRAME Frame_email
               ROW    190
               COL    10
               WIDTH  815
               HEIGHT 266
               CAPTION "Configura Email Emissão NF-e"
        END FRAME  

        DEFINE LABEL Label_smtp
               ROW    210
               COL    20
               WIDTH  120
               HEIGHT 15
               VALUE "Servidor SMTP"
        END LABEL  

        DEFINE TEXTBOX Text_smtp
               ROW    230
               COL    20
               WIDTH  282
               HEIGHT 24
               value mgsmtp_nfe
        END TEXTBOX 


        DEFINE LABEL Label_porta_email
               ROW    210
               COL    310
               WIDTH  75
               HEIGHT 15
               VALUE "Porta"
        END LABEL  

        DEFINE TEXTBOX Text_portaemail
               ROW    230
               COL    310
               WIDTH  76
               HEIGHT 24
               value mgporta_email
        END TEXTBOX 

        DEFINE LABEL Label_3
               ROW    260
               COL    20
               WIDTH  120
               HEIGHT 15
               VALUE "Usuário"
        END LABEL  

        DEFINE TEXTBOX Text_usuarioemail
               ROW    280
               COL    20
               WIDTH  210
               HEIGHT 24
               value mgusuario_email
        END TEXTBOX 

        DEFINE LABEL Label_senhaemail
               ROW    260
               COL    240
               WIDTH  120
               HEIGHT 15
               VALUE "Senha"
        END LABEL  

        DEFINE TEXTBOX Text_senhaemail
               ROW    280
               COL    240
               WIDTH  147
               HEIGHT 24
               value mgsenha_email
               Password     .T.
        END TEXTBOX 

        DEFINE LABEL Label_assunto
               ROW    310
               COL    20
               WIDTH  201
               HEIGHT 15
               VALUE "Assunto do Email Enviado"
        END LABEL  

        DEFINE TEXTBOX Text_assuntoeamil
               ROW    330
               COL    20
               WIDTH  366
               HEIGHT 23
               value mgassunto_email
        END TEXTBOX 

       DEFINE CHECKBOX Check_conexaosegura
              ROW    355
              COL    20
              WIDTH  199
              HEIGHT 28
              CAPTION "SMTP exige conexão segura"
              value mgconexao_segura
        END CHECKBOX  

        DEFINE FRAME Frame_tipoenvio
               ROW    380
               COL    20
               WIDTH  365
               HEIGHT 59
               CAPTION "Tipo de Envio"
        END FRAME  

        DEFINE RADIOGROUP RdG_tipoenvio
               ROW    400
               COL    30
               WIDTH  120
               HEIGHT 50
               OPTIONS {'Synapse','Indy'}
               VALUE mgtipoenvio_email
               HORIZONTAL .T.
        END RADIOGROUP  

        DEFINE LABEL Label_mensagememail
               ROW    200
               COL    390
               WIDTH  228
               HEIGHT 15
               VALUE "Mensagem do Email"
        END LABEL  

        DEFINE EDITBOX Edit_mensagem_email
               ROW    220
               COL    390
               WIDTH  426
               HEIGHT 180
               value mgmensagem_email
     			   HSCROLLBAR .F.
        END EDITBOX  

        DEFINE BUTTONEX ButtonEX_EMAIL
               ROW    410
               COL    390
               WIDTH  174
               HEIGHT 24
               CAPTION "Testar Envio do Email"
               FONTNAME "Times New Roman"
               FONTBOLD .T.
               ACTION teste_email()
        END BUTTONEX  

        DEFINE LABEL Label_inf2
               ROW    440
               COL    390
               WIDTH  500
               HEIGHT 20 
               VALUE "* [ATENÇÃO] - Liberar a porta de envio no Firewall do Windows"
               FONTSIZE 10
               FONTCOLOR RED
               FONTITALIC .T.
               FONTBOLD .T.
        END LABEL  

	END PAGE
	 
    PAGE "NF&C-e"
       DEFINE CHECKBOX Chk_ImprimeNFCeDaruma
              ROW    30
              COL    20
              WIDTH  380
              HEIGHT 28
              CAPTION "Imprimir NFC-e na Impressora DARUMA ?"
              VALUE mgIMPRIMIR_NFCe
        END CHECKBOX  
        
        DEFINE LABEL Label_Token
               ROW    60
               COL    20
               WIDTH  120
               HEIGHT 24
               VALUE "Token"
        END LABEL  

        DEFINE TEXTBOX Txt_Token
               ROW    60
               COL    120
               WIDTH  250
               HEIGHT 24
               UPPERCASE  .T.
               MAXLENGTH  20
               VALUE  mgToken
        END TEXTBOX 

        DEFINE LABEL Label_IDToken
               ROW    90
               COL    20
               WIDTH  120
               HEIGHT 24
               VALUE "ID Token"
        END LABEL  

        DEFINE TEXTBOX Txt_IDToken
               ROW    90
               COL    120
               WIDTH  250
               HEIGHT 24
               MAXLENGTH  20
               VALUE  mgIDToken
        END TEXTBOX 
    END PAGE 

   PAGE "Contador" IMAGE ''

        DEFINE LABEL Label_nome
               ROW    50
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Nome:"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_NomeContador
               ROW    50
               COL    140
               WIDTH  579
               HEIGHT 24
               UPPERCASE  .T.
               MAXLENGTH  100
               VALUE  mgNOMECONTADOR
        END TEXTBOX 

        DEFINE LABEL Label_CPFCONT
               ROW    90
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "CPF"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_CPFCONTADOR
               ROW    90
               COL    140
               WIDTH  228
               HEIGHT 24
               VALUE  mgCPFContador
			   ON ENTER {|| vcnpjcpf(config.Text_CPFCONTADOR.VALUE),CRIAMASCARA() } 
        END TEXTBOX 

        DEFINE LABEL Label_CNPJCONT
               ROW    130
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "CNPJ"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_CNPJCONTADOR
               ROW    130
               COL    140
               WIDTH  228
               HEIGHT 24
               HEIGHT 24
               VALUE  mgCNPJContador
			   ON ENTER {|| vcnpjcpf(config.Text_CNPJCONTADOR.VALUE),CRIAMASCARA() } 
        END TEXTBOX 

        DEFINE LABEL Label_CRC
               ROW    170
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "CRC"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_CRCContador
               ROW    170
               COL    140
               WIDTH  228
               HEIGHT 24
               VALUE  mgCRCContador
        END TEXTBOX 

        DEFINE LABEL Label_ENDCONT
               ROW    210
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Endereço"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_ENDCONTADOR
               ROW    210
               COL    140
               WIDTH  381
               HEIGHT 24
               VALUE  mgENDContador
               UPPERCASE  .T.
               MAXLENGTH  100
        END TEXTBOX 

        DEFINE LABEL Label_NUMCONT
               ROW    210
               COL    530
               WIDTH  61
               HEIGHT 24
               VALUE "Número"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_NUMEROCONTADOR
               ROW    210
               COL    600
               WIDTH  111
               HEIGHT 24
               NUMERIC .T.
               VALUE  mgNUMEROContador
               INPUTMASK '999999'
        END TEXTBOX 

        DEFINE LABEL Label_BAIRROCONT
               ROW    250
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Bairro"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_BAIRROCONTADOR
               ROW    250
               COL    140
               WIDTH  381
               HEIGHT 24
               VALUE  mgBAIRROContador
               UPPERCASE  .T.
               MAXLENGTH  60
        END TEXTBOX 

        DEFINE LABEL Label_CEPCONT
               ROW    250
               COL    530
               WIDTH  61
               HEIGHT 24
               VALUE "CEP:"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_CEPCONTADOR
               ROW    250
               COL    600
               WIDTH  111
               HEIGHT 24
               VALUE  mgCEPContador
               INPUTMASK '999999999'
        END TEXTBOX 

        DEFINE LABEL Label_MUNCONT
               ROW    290
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Código Municipio"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE BTNTEXTBOX TEXT_CODMUNCONTADOR
            ROW    290
            COL    140
            WIDTH  120
            HEIGHT 24
            INPUTMASK "9999999"
				MAXLENGTH 7
   		   PICTURE "busca"
				value mgCODMUNContador
            ON GOTFOCUS This.BackColor:=clrBack 
            ON LOSTFOCUS This.BackColor:=clrNormal 
            ACTION {|| Iif ( !empty(Config.TEXT_CODMUNCONTADOR.value),Config.TEXT_CODMUNCONTADOR.value:='',Config.TEXT_CODMUNCONTADOR.value:=''), Acha_CIDADE(  'CONTADOR' )}
            ON ENTER {|| Acha_CIDADE( 'CONTADOR' )   }
        END BTNTEXTBOX 

        DEFINE LABEL Label_CIDCONT
               ROW    290
               COL    270
               WIDTH  250
               HEIGHT 23
               VALUE "Cidade"
			   BORDER .T.
			   BACKCOLOR {0,255,255} 
               VALUE  mgCIDADEContador
        END LABEL  

        DEFINE LABEL Label_UFCONT
               ROW    290
               COL    530
               WIDTH  59
               HEIGHT 24
			   BORDER .T.
			   BACKCOLOR {0,255,255} 
               VALUE  mgUFContador
        END LABEL  

        DEFINE LABEL Label_FONECONT
               ROW    330
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Fone"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_FONECONTADOR
               ROW    330
               COL    140
               WIDTH  120
               HEIGHT 24
               VALUE  mgFONEContador
               INPUTMASK "99-9999-9999"
        END TEXTBOX 

        DEFINE TEXTBOX Text_FAXCONTADOR
               ROW    330
               COL    270
               WIDTH  120
               HEIGHT 24
               VALUE  mgFAXContador
               INPUTMASK "99-9999-9999"
        END TEXTBOX 


        DEFINE LABEL Label_EMAILCONT
               ROW    370
               COL    10
               WIDTH  120
               HEIGHT 24
               VALUE "Email"
               TRANSPARENT .T.
               RIGHTALIGN .T.
        END LABEL  

        DEFINE TEXTBOX Text_EMAILCONTADOR
               ROW    370
               COL    140
               WIDTH  572
               HEIGHT 26
               VALUE  mgEMAILContador
               MAXLENGTH  60
        END TEXTBOX 

    END PAGE  
  END TAB 

     DEFINE BUTTONEX ButtonEX_1
            ROW    515
            COL    480
            WIDTH  173
            HEIGHT 25
            CAPTION "&Grava"
            ICON NIL
            ACTION {||gravar()}
            FONTBOLD .T.
     END BUTTONEX  

     DEFINE BUTTONEX ButtonEX_2
            ROW    515
            COL    670
            WIDTH  173
            HEIGHT 25
            CAPTION "&Cancela"
            ICON NIL
            ACTION { ||config.release }
            FONTBOLD .T.
     END BUTTONEX  

END WINDOW


if mgregime<>3
	Config.Cb_regime_apuracao.visible:=.f.
	Config.TXT_ALICOTA.ENABLED:=.T.
else
	Config.TXT_ALICOTA.ENABLED:=.f.
	Config.Label_Enquadramento.ENABLED:=.f.
end

if mgEMI_NFe==.f.  .and. mgEMI_NFCe==.f.

//	Config.Frame_regimeicms.visible:=.f.
//	Config.Label_regime.visible:=.f.
//	Config.Cb_regime.visible:=.f.
//	Config.Cb_regime_apuracao.visible:=.f.
//	Config.Label_alicota.visible:=.f.
//	Config.TXT_ALICOTA.visible:=.f.
//	Config.Label_alicotaST.visible:=.f.
//	Config.TXT_ALICOTAST.visible:=.f.
	Config.Label_SERIE_NFe.visible:=.f.
	Config.TXT_serie_nfe.visible:=.f.

	Config.Label_SERIE_NFe_Entradas.visible:=.f.
	Config.TXT_serie_nfe_entradas.visible:=.f.

	Config.Chk_IMP_PAGAMENTO_NFe.visible:=.f.
	Config.Chk_GERACREDITO.visible:=.f.
	Config.Frame_mensagem.visible:=.f.
	Config.INFORMACAO_NFe.visible:=.f.
	Config.Label_inf.visible:=.f.
	Config.Frame_2.visible:=.f.
	Config.RdG_TipoAcBR.visible:=.f.
	Config.RdG_ambiente_nfe.visible:=.f.
	Config.Label_certificado.visible:=.f.
	Config.Txt_CERTIFICADO.visible:=.f.
	Config.Txt_Token.visible:=.f.
	Config.Txt_IDToken.visible:=.f.
	Config.Label_caminhocertificado.visible:=.f.
	Config.Txt_CAMINHOCERTIFICADO.visible:=.f.
	Config.ButtonEX_CERT.visible:=.f.
	Config.ButtonEX_CAMINHO.visible:=.f.
	Config.Label_senhacertificado.visible:=.f.
	Config.Txt_SENHA_CERTIFICADO.visible:=.f.
	Config.Frame_email.visible:=.f.
	Config.Label_smtp.visible:=.f.
	Config.Text_smtp.visible:=.f.
	Config.Label_porta_email.visible:=.f.
	Config.Text_portaemail.visible:=.f.
	Config.Label_3.visible:=.f.
	Config.Text_usuarioemail.visible:=.f.
	Config.Label_senhaemail.visible:=.f.
	Config.Text_senhaemail.visible:=.f.
	Config.Label_assunto.visible:=.f.
	Config.Text_assuntoeamil.visible:=.f.
	Config.Check_conexaosegura.visible:=.f.
	Config.Frame_tipoenvio.visible:=.f.
	Config.RdG_tipoenvio.visible:=.f.
	Config.Label_mensagememail.visible:=.f.
	Config.Edit_mensagem_email.visible:=.f.
	Config.ButtonEX_EMAIL.visible:=.f.
	Config.Label_inf2.visible:=.f.
	Config.Label_impressoranfe.visible:=.f.
	Config.Combo_impressoranfe.visible:=.f.
	Config.Chk_NFeACBr.visible:=.f.
	Config.Chk_ImprimeNFCeDaruma.visible:=.f.

END


 	Config.Center
	Config.Activate

Return


function Gravar
Local cImpressoraNFE:=''

if Config.Combo_impressoranfe.Value>0
	cImpressoraNFE:=aPrinter[Config.Combo_impressoranfe.Value]
end
 
///dados cadastrais da empresa
    cQuery:="UPDATE EMPRESA SET "+;
            "FANTASIA ='"+alltrim(Config.Text_FANTASIA.VALUE) +"',"+;
            "RAZAO_SOC='"+alltrim(Config.Text_RAZAO.VALUE) +"',"+;
            "ENDERECO ='"+Config.Text_ENDERECO.VALUE+"',"+;
            "NUMERO   ="+STR(Config.Text_NUMERO.VALUE)+","+;
            "BAIRRO   ='"+Config.Text_BAIRRO.VALUE+"',"+;
            "CEP      ='"+Config.tExt_CEP.VALUE+"',"+;
            "CIDADE   ='"+Config.txt_CIDADE.VALUE+"',"+;
            "ESTADO   ='"+Config.txt_UF.VALUE+"',"+;
            "CODMUN   ="+Config.txt_CODMUN.VALUE+","+;
            "MENSAGEM ='"+Config.txt_MENSAGEM.VALUE+"',"+; 
            "SUFRAMA  ='"+Config.tExt_SUFRAMA.VALUE+"',"+; 
            "CNPJ     ='"+Config.tExt_CNPJ.VALUE+"',"+;
            "INSCRICAO='"+Config.txtInscricao.VALUE+"',"+;
            "FONE     ='"+Config.Text_FONE1.VALUE+"',"+;
            "FAX      ='"+Config.Text_FONE2.VALUE+"',"+; 
				"REGIME   ="+STR(Config.CB_REGIME.VALUE)+","+;
				"REGIME_APURACAO="+STR(Config.CB_REGIME_apuracao.VALUE)+","+;
            "ALICOTA  ="+STR(Config.TXT_ALICOTA.VALUE)+","+;
            "ALICOTAst="+STR(Config.TXT_ALICOTAst.VALUE)+","+;
            "ECF      ="+IIF(config.CHK_ECF.VALUE==.F.,'0','1')+"," +;
            "JUROS    ="+STR(Config.txt_JUROS.VALUE)+","+;
            "CARENCIA ="+STR(Config.txt_CARENCIA.VALUE)+","+;
            "DESC_PONT="+STR(Config.txt_PONTUALIDADE.VALUE)+","+;
            "DESC_ITEM="+STR(Config.txt_DESCONTO_ITEM.VALUE)+","+;
            "DESC_PED ="+STR(Config.txt_DESCONTO_PEDIDO.VALUE)+","+;
            "LIMITE_PARCELAS ="+STR(Config.Txt_LIMITE_PARCELAS.VALUE)+","+;
            "DIAS_VENCIDO ="+STR(Config.Txt_LIMITE_DIAS_VENCIDO.VALUE)+","+;
            "ESTOQUE  ='"+Config.txt_ESTOQUE.VALUE+"',"+;
            "MARKUP   ='"+(Config.Txt_Markup.VALUE)+"',"+; 
            "ETQ_MINIMO="+STR(Config.Txt_Minimo.VALUE)+","+;
            "ETQ_MAXIMO="+STR(Config.Txt_Maximo.VALUE)+","+;
            "TABELA   ="+IIF(Config.CHK_TABELA.VALUE==.F.,'0','1')+","+;
            "ambiente_nfe="+str(CONFIG.RdG_ambiente_nfe.VALUE)+","+;
            "modelo_ecf="+str(CONFIG.RdG_ecfs.VALUE)+","+;
            "tipoenvio_email="+str(CONFIG.RdG_tipoenvio.VALUE)+","+;
            "smtp_nfe='"+(CONFIG.text_smtp.VALUE)+"',"+;
            "porta_email='"+(CONFIG.Text_portaemail.VALUE)+"',"+;
            "usuario_email='"+(CONFIG.Text_usuarioemail.VALUE)+"',"+;
            "senha_email='"+(CONFIG.Text_senhaemail.VALUE)+"',"+;
            "assunto_email='"+(CONFIG.Text_assuntoeamil.VALUE)+"',"+;
            "token='"+CONFIG.Txt_Token.VALUE+"',"+;
            "idtoken='"+CONFIG.Txt_idToken.VALUE+"',"+;
            "certificado='"+CONFIG.Txt_CERTIFICADO.VALUE+"',"+;
            "conexao_segura="+iif(CONFIG.Check_conexaosegura.VALUE==.F.,'0','1')+","+;
            "senha_certificado='"+CONFIG.Txt_Senha_CERTIFICADO.VALUE+"',"+;
            "mensagem_email='"+CONFIG.Edit_mensagem_email.VALUE+"',"+;
            "AVISTA   ="+STR(Config.TXT_PRCAVISTA.VALUE)+","+;
            "nome_tab1   ='"+ Config.Txt_NOME_TABELA1.VALUE +"',"+;
            "nome_tab2   ='"+ Config.Txt_NOME_TABELA2.VALUE +"',"+;
            "nome_tab3   ='"+ Config.Txt_NOME_TABELA3.VALUE +"',"+;
            "nome_tab4   ='"+ Config.Txt_NOME_TABELA4.VALUE +"',"+;
            "nome_tab5   ='"+ Config.Txt_NOME_TABELA5.VALUE +"',"+;
            "FINANCEIRO="+STR(Config.TXT_FINANCEIRO.VALUE)+","+;
            "PARCELA1 ="+STR(Config.TXT_PARCELA_INICIAL.VALUE)+","+;
            "SomaItens="+IIF(Config.Chk_SomaItens.VALUE==.F.,'0','1')+","+;
            "nfe_acbr="+IIF(Config.Chk_NFeACBr.VALUE==.F.,'0','1')+","+;
            "Tipo_Pesquisa_Item="+IIF(Config.Chk_Tipo_Pesquisa_Item.VALUE==.F.,'0','1')+","+;
            "Pesquisa_Trecho="+IIF(Config.Chk_Pesquisa_Trecho.VALUE==.F.,'0','1')+","+;
            "imp_unica_dup="+IIF(Config.Chk_Imprime_Duplicata_Unica.VALUE==.F.,'0','1')+","+;
            "lanca_pagar_nf="+IIF(Config.Chk_LANCAPAGAR.VALUE==.F.,'0','1')+","+;
            "agenda="+IIF(Config.Chk_Agenda.VALUE==.F.,'0','1')+","+;
            "matriz="+IIF(Config.Chk_Matriz.VALUE==.F.,'0','1')+","+;
            "excluir_pdv="+IIF(Config.Chk_Bloqueia_Exclusao_PDV.VALUE==.F.,'0','1')+","+;
            "imp_pgto_nfe="+IIF(Config.Chk_IMP_PAGAMENTO_NFe.VALUE==.F.,'0','1')+","+;
            "geracredito="+IIF(Config.Chk_GERACREDITO.VALUE==.F.,'0','1')+","+;
            "gera_spedfiscal="+IIF(Config.Chk_SPED.VALUE==.F.,'0','1')+","+;
            "gera_spedpis="+IIF(Config.Chk_SPEDCONTRIBUICOES.VALUE==.F.,'0','1')+","+;
            "desc_prevenda="+IIF(Config.Chk_DESCONTO_FECHA_VENDA.VALUE==.F.,'0','1')+","+;
            "bloq_financeiro="+IIF(Config.Chk_Bloqueia_Financeiro.VALUE==.F.,'0','1')+","+;
            "inf_nfe='"+(Config.INFORMACAO_NFe.value)+"',"+;
            "serie_nfe="+STR(Config.txt_serie_NFe.value)+","+;
            "serie_nfe_ent="+STR(Config.txt_serie_NFe_Entradas.value)+","+;
            "ecf_vinc ="+IIF(Config.CHK_ECFVINC.VALUE==.F.,'0','1')+","+;
				"cod_inc_trib  ="+STR(Config.Combo_COD_INC_TRIB.VALUE)+","+;
				"ind_apro_cred ="+STR(Config.Combo_IND_APRO_CRE.VALUE)+","+;
				"cod_tipo_cont ="+STR(Config.Combo_COD_TIPO_CON.VALUE)+","+;
				"Ramo_Atv="+STR(Config.CB_RAMO.VALUE)+","+;
				"impressora_nfe='"+cImpressoraNFE+"'"
 				SQL_Error_oQuery()
				oQuery:Destroy()
	
	cQuery:= "select codigo FROM contas where descricao='"+alltrim(aContas[Config.cb_conta.Value])+"'"          
	SQL_Error_oQuery()
	oRow:= oQuery:GetRow(1)
 
   mgConta :=oRow:fieldGet(1)
   oQuery:Destroy()
    
   mgBancoPadraoBol:=str(Config.Cb_BancoPadrao.Value)
	mgEMI_NFe:=Config.Chk_Emissao_NFe.VALUE 
	mgTIPO_ACBR:=Config.RdG_TipoAcBR.VALUE
	mgEMI_NFCe:=Config.Chk_Emissao_NFCe.VALUE 
	mgMANU_PED:=Config.Chk_MANUPED.VALUE
	mgIMPRIMIR_NFCe:=Config.Chk_ImprimeNFCeDaruma.VALUE
	mgIMP_PED:=Config.Chk_Impressao_Pedidos.value
	mgIMP_ORC:=Config.Chk_Impressao_Orcamentos.value
	mgIMP_DUP:=Config.Chk_Impressao_Duplicatas.VALUE
	mgIMP_NF:=Config.Chk_Impressao_NotaFiscal.VALUE
	mgIMP_RECIBO:=Config.Chk_Impressao_Recibo.VALUE
	mgTIPO_IMP_PED:=str(Config.RdG_TipoPedido.VALUE)
	mgECF:=Config.Chk_ECF.VALUE
	mgIMP_SV_CUPOM:=Config.Chk_IMP_SERVICO.VALUE
	mgPOUCO_PAPEL:=Config.Chk_POUCO_PAPEL.VALUE
	mgBAIXA_DUPL:=Config.Chk_BAIXA.VALUE
	mgBloq_Financeiro:=Config.Chk_Bloqueia_Financeiro.VALUE
	mgBALANCA:=Config.CHK_BALANCA.VALUE
	mgLPT1:=Config.Chk_LPT1.VALUE
	cTipoCaboImp:=Config.Chk_Tipo_Cabo_Impressao.VALUE
    //configura ini do sistema

    BEGIN INI FILE "MGI.INI"
      SET SECTION "SISTEMA"  ENTRY "TipoCaboImpressora"    TO IIF(Config.Chk_Tipo_Cabo_Impressao.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "ManutencaoPedidos"     TO IIF(Config.Chk_MANUPED.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "TipoImpressao"	        TO IIF(Config.Chk_LPT1.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "PedidoOnLine"	        TO IIF(Config.Chk_Impressao_Pedidos.value==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "OrcamentoOnLine"	     TO IIF(Config.Chk_Impressao_Orcamentos.value==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "DuplicataOnLine"	     TO IIF(Config.Chk_Impressao_Duplicatas.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "NotaFiscalOnLine"      TO IIF(Config.Chk_Impressao_NotaFiscal.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "ReciboOnLine"	        TO IIF(Config.Chk_Impressao_Recibo.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "PoucoPapel"		        TO IIF(Config.Chk_POUCO_PAPEL.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "TipoImpressaoPedido"   TO alltrim(str(Config.RdG_TipoPedido.VALUE))
      SET SECTION "SISTEMA"  ENTRY "EmitirNFe"   	        TO IIF(Config.Chk_Emissao_NFe.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "TipoACBR"   	        TO alltrim(STR(Config.RdG_TipoAcBR.VALUE) )
      SET SECTION "SISTEMA"  ENTRY "Caminho"   	        	  TO alltrim(CONFIG.Txt_CAMINHOCERTIFICADO.VALUE)
      SET SECTION "SISTEMA"  ENTRY "EmitirNFCe"   	        TO IIF(Config.Chk_Emissao_NFCe.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "ImprimirNFCe"          TO IIF(Config.Chk_ImprimeNFCeDaruma.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "TerminalUsaECF"	     TO IIF(Config.Chk_ECF.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "ImprimeServicoCupom"   TO IIF(Config.Chk_IMP_SERVICO.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "BaixaDuplicata"	     TO IIF(Config.Chk_BAIXA.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "CaixaTerminal" 	     TO mgConta
      SET SECTION "SISTEMA"  ENTRY "UsaBalancaChekout" 	  TO IIF(Config.CHK_BALANCA.VALUE==.F.,'0','1')
      SET SECTION "SISTEMA"  ENTRY "BancoPadraoBoleto" 	  TO Config.Cb_BancoPadrao.VALUE 
    END INI
	
 	 //configura ini nfe
if mgEMI_NFe==.t.

if mgTIPO_ACBR==1
	cCaminhoCertificado:=CONFIG.Txt_CERTIFICADO.VALUE
else
	cCaminhoCertificado:=CONFIG.Txt_CAMINHOCERTIFICADO.VALUE
end
 
  				BEGIN INI FILE "C:\ACBrNFeMonitor\ACBrNFeMonitor.INI"
				  SET SECTION "ACBrNFeMonitor"  ENTRY "Modo_TCP"  TO '0'
				  SET SECTION "ACBrNFeMonitor"  ENTRY "Modo_TXT"  TO '1'
				  SET SECTION "Geral"  ENTRY "Salvar"    TO '1'
				  SET SECTION "Geral"  ENTRY "PathSalvar"    TO 'C:\ACBrNFeMonitor'
				  SET SECTION "WebService"      ENTRY "UF"    TO alltrim(mgEstado)
				  SET SECTION "WebService"      ENTRY "Ambiente"    TO iif(CONFIG.RdG_ambiente_nfe.VALUE==1,'0','1')
				  SET SECTION "Certificado"     ENTRY "Caminho"    TO alltrim(cCaminhoCertificado)
				  SET SECTION "Certificado"     ENTRY "Senha"    TO ACBrEncripta(Config.Txt_Senha_CERTIFICADO.value    ,"tYk*5W@")
				  SET SECTION "Email"           ENTRY "Host"     TO alltrim(Config.Text_smtp.value)
				  SET SECTION "Email"           ENTRY "Port"     TO alltrim(Config.Text_portaemail.value)
				  SET SECTION "Email"           ENTRY "User"     TO alltrim(Config.Text_usuarioemail.value)
				  SET SECTION "Email"           ENTRY "Pass"     TO ACBrEncripta(Config.Text_senhaemail.value    ,"tYk*5W@")
				  SET SECTION "Email"           ENTRY "Assunto"     TO alltrim(Config.Text_assuntoeamil.value)
				  SET SECTION "Email"           ENTRY "SSL"     TO alltrim(iif(CONFIG.Check_conexaosegura.VALUE==.F.,'0','1'))
				  SET SECTION "Email"           ENTRY "Tipo"     TO alltrim(iif(CONFIG.RdG_tipoenvio.VALUE==1,'0','1'))
				  SET SECTION "Email"           ENTRY "Mensagem"     TO alltrim(CONFIG.Edit_mensagem_email.VALUE)
				  SET SECTION "DANFE"           ENTRY "Modelo"    TO '1'
				  SET SECTION "DANFE"           ENTRY "SoftwareHouse"    TO 'MGI Systens - ACBr'
				  SET SECTION "DANFE"           ENTRY "DecimaisValor"    TO '4'
				  SET SECTION "DANFE"           ENTRY "ImpDescPorc"    TO '0'
				  SET SECTION "DANFE"           ENTRY "MostrarPreview"    TO '1'
				  SET SECTION "DANFE"           ENTRY "ExibeResumo"    TO '1'
				  SET SECTION "DANFE"           ENTRY "ImprimirValLiq"    TO '1'
				  SET SECTION "DANFE"           ENTRY "Fonte"    TO '0'
				  SET SECTION "DANFE"           ENTRY "PathPDF"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "NFCe "           ENTRY "Token"    TO alltrim(CONFIG.txt_token.VALUE)
				  SET SECTION "NFCe "           ENTRY "IdToken"    TO alltrim(CONFIG.txt_idtoken.VALUE)
				  SET SECTION "Arquivos"           ENTRY "Salvar"    TO '1'
				  SET SECTION "Arquivos"           ENTRY "PastaMensal"    TO '1'
				  SET SECTION "Arquivos"           ENTRY "AddLiteral"    TO '1'
				  SET SECTION "Arquivos"           ENTRY "EmissaoPathNFe"    TO '1'
				  SET SECTION "Arquivos"           ENTRY "PathNFe"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "Arquivos"           ENTRY "PathCan"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "Arquivos"           ENTRY "PathInu"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "Arquivos"           ENTRY "PathDPEC"    TO CurDrive()+ ":\" + CurDir() + "\NFeSaida"
				  SET SECTION "Geral"           ENTRY "Impressora"    TO  cImpressoraNFE

				END INI
				 
    ProcedureLerINI()

 end
 
    msginfo('ATENÇÃO...Necessário reiniciar o sistema para as configurações terem efeito.')

///dados cadastrais do contador
    cQuery:="UPDATE contador SET "+;
			"nome='"+Config.Text_NOMECONTADOR.VALUE+"',"+;
			"cnpj='"+LIMPA(Config.Text_CNPJCONTADOR.VALUE)+"',"+;
			"cpf='"+LIMPA(Config.Text_CPFCONTADOR.VALUE)+"',"+;
			"crc='"+Config.Text_CRCCONTADOR.VALUE+"',"+;
			"endereco='"+Config.Text_ENDCONTADOR.VALUE+"',"+;
			"bairro='"+Config.Text_BAIRROCONTADOR.VALUE+"',"+;
			"cep='"+Config.Text_CEPCONTADOR.VALUE+"',"+;
			"numero="+STR(Config.Text_NUMEROCONTADOR.VALUE)+","+;
			"cidade='"+Config.Label_CIDCONT.VALUE+"',"+;
			"estado='"+Config.Label_UFCONT.VALUE+"',"+;
			"codmun='"+Config.Text_CODMUNCONTADOR.VALUE+"',"+;
			"email='"+Config.Text_EMAILCONTADOR.VALUE+"',"+;
			"fone='"+Config.Text_FONECONTADOR.VALUE+"',"+;
			"fax='"+Config.Text_FAXCONTADOR.VALUE+"'"
			
	SQL_Error_oQuery()
    oQuery:Destroy()


Config.release

RETURN

*-----------------------------------------------------------------------------*
FUNCTION SALVAR_NFE_INI( LNOVO )
*---[ DOCUMENTACAO]
*   A FUNCAO SALVAR IRA GERAR UM ARQUIVO TEXTO QUE SERA GRAVADO NO PATCH
*   DO EXECUTAVEL, E LIDO PELA FUNCAO LeNfeIni
*-----------------------------------------------------------------------------*

Local cFile := "NFe.INI"
LOCAL _QUEBRA :=HB_OSNEWLINE()

if len(alltrim( Config.ogserie.value) ) <> 3
   MsgInfo("A SERIE DA NOTA FISCAL E INVALIDA"+;
                 _QUEBRA + "VERIFIQUE POR FAVOR", Config.title)
   Config.ogModelo.SetFocus
   return
endif

 ctexto  :=  Config.ogCVersaoxmlNFe.value                    +_QUEBRA  //01

 ctexto  += Config.ogModelo.value                            +_QUEBRA  //02
 ctexto  += Config.ogSerie.value                             +_QUEBRA  //03
 ctexto  += alltrim( str( Config.cbFormaDaNFe.value  ) )     +_QUEBRA  //04
 ctexto  += alltrim( str( Config.cbtipoEmissao.value ) )     +_QUEBRA  //05
 ctexto  += alltrim( str( Config.cbTipoamb.value     ) )     +_QUEBRA  //06
 ctexto  += alltrim( str( Config.cbProcEmissao.value ) )     +_QUEBRA  //07
 ctexto  += Config.ogVerProcesso.value                       +_QUEBRA  //08
 ctexto  += Config.ogcVersaoEnvNFe.value                     +_QUEBRA  //09
 ctexto  += Config.ogcVersaoConssitNFe.value                 +_QUEBRA  //10
 ctexto  += Config.ogcVersaoConsRecINFe.value                +_QUEBRA  //11
 ctexto  += Config.ogcVersaoInutNFe.value                    +_QUEBRA  //12
 ctexto  += Config.ogcVersaoCancNFe.value                    +_QUEBRA  //13
 ctexto  += Config.ogcVersaoConsStatServ.value               +_QUEBRA  //14
 ctexto  += Config.ogcrecepcao.value                         +_QUEBRA  //15
 ctexto  += Config.ogcCancelamento.value                     +_QUEBRA  //16
 ctexto  += Config.ogcInutilizacao.value                     +_QUEBRA  //17
 ctexto  += Config.ogcConsultaProtocolo.value                +_QUEBRA  //18
 ctexto  += Config.ogcRecepcao.value                         +_QUEBRA  //19
 ctexto  += Config.ogcStatusServico.value                    +_QUEBRA  //20

 ctexto  += Config.ogPastaXmlEnvio.value                     +_QUEBRA  //40
 ctexto  += Config.ogPastaXmlRetorno.value                   +_QUEBRA  //41
 ctexto  += Config.ogPastaXmlEnviado.value                   +_QUEBRA  //42
 ctexto  += Config.ogPastaXmlErro.value                      +_QUEBRA  //43
 cTexto  += Config.ogPastaXmlRepositorio.value               +_QUEBRA  //44
 cTexto  += Config.ogPastaXmlSchema.value                             //45

X := MEMOWRIT( CFILE, CTEXTO )

MsgInfo( "Arquivo de configuracao das Notas Fiscais Eletronica"+;
        'Gravado'  )

cFile := "nfe.ini"

BEGIN INI FILE cFile

    SET SECTION "PASTAS"   ENTRY "XmlEnvio"       To alltrim(Config.ogPastaXmlenvio.value)
    SET SECTION "PASTAS"   ENTRY "XnlRetorno"     To alltrim(Config.ogPastaXmlRetorno.value)
    SET SECTION "PASTAS"   ENTRY "XmlEnviado"     To alltrim(Config.ogPastaXmlEnviado.value)
    SET SECTION "PASTAS"   ENTRY "XmlErro"        To alltrim(Config.ogPastaXmlErro.value)
    SET SECTION "PASTAS"   ENTRY "XnlRepositorio" To alltrim(Config.ogPastaXmlRepositorio.value)
    SET SECTION "PASTAS"   ENTRY "XmlSchemas"     To alltrim(Config.ogPastaXmlSchema.value)

end ini

return


*----------------------------------
static FUNCTION CONFERE_SERIAL()
nSerial:=substr( HB_MD5( Config.Text_CNPJ.VALUE+dtos(Config.Txt_DATA.VALUE) ),1,16) 
nSerial:=AllTrim( TransForm( nSerial , "@R !!!!-!!!!-!!!!-!!!!" ) )

IF ALLTRIM(nSERIAL)==alltrim(Config.Txt_SERIAL.VALUE)

  cQuery:= "update empresa set serial='"+ Config.Txt_SERIAL.VALUE+"',vencimento='"+dtos(Config.Txt_DATA.VALUE)+"'"         

		oQuery	:= oServer:Query( cQuery )
		If oQuery:NetErr()												
			MsgStop(oQuery:Error())
		EndIf
        oQuery:Destroy()
 
   msginfo('Chave gravada com sucesso!!! ')
ELSE
   MSGINFO('Chave inválida...')
   RETURN 
   
END
 
RETURN



FUNCTION BUSCACERTIFICADO()

LOCAL aRetorno, oFuncoes := hbNFeFuncoes(), SW_SHOWNORMAL := 1

   SET DATE TO BRIT
   SET CENTURY ON
   REQUEST HB_CODEPAGE_PT850 &&& PARA INDEXAR CAMPOS ACENTUADOS
   HB_SETCODEPAGE("PT850")   &&& PARA INDEXAR CAMPOS ACENTUADOS
 
   cPastaSchemas='C:\ACBrNFeMonitor\Schemas'///hIniData['hbNFe']['cPastaSchemas']

   oNfe := hbNfe()
   oNfe:cPastaSchemas := cPastaSchemas                                                                   	
   oNFe:cSerialCert :=  ALLTRIM(mgCERTIFICADO) //cSerialCert
   oNFe:cUFWS := '43' // UF WebService
   oNFe:tpAmb := '2' // Tipo de Ambiente
   oNFe:versaoDados := '2.00'  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda

   oNFe:empresa_UF := STR(mgCODESTADO)
   oNFe:empresa_cMun := mgCODMUN


   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'

	//----------------------.
        aRetorno := oNfe:escolheCertificado(.F.)
        IF aRetorno['OK'] == .F.
           msginfo( aRetorno['MsgErro'] )
        ELSE
           Config.Txt_CERTIFICADO.value:= aRetorno['Serial']  
        ENDIF
	//----------------------.
	
 
	
 

RETURN
//----------------------------------------------------------------------------
static func localiza_certificado()

local varios := .t.   && selecionar varios arquivos
local arq_cas := {}, i, n_for, File_cas, m_rat
Public cCurDir := "\mgi\"


p_GetFile := cCurDir///iif( empty( p_GetFile ) , GetMyDocumentsFolder() , p_GetFile )

 
arq_cas := GetFile ( { ;
	{'Arquivo XML' , '*.PFX'} },;
	'Abre Arquivos' , p_GetFile , varios , .t. )
 
if len( arq_cas ) = 0
	return nil
endif


m_rat = rat('\',arq_cas[1])
p_GetFile := left( arq_cas[1] , m_rat-1 )
 
//col:=len(p_GetFile)+2
 

Config.Txt_CAMINHOCERTIFICADO.value:= arq_cas[1]

 
retu nil

//----------------------------------------------------------------------------

function teste_email

f_importar()

DEFINE WINDOW teste_email AT 327 , 378 WIDTH 322 HEIGHT 116    MODAL NOSIZE

        ON KEY ESCAPE OF teste_email ACTION {||teste_email.release}

     DEFINE LABEL Label_1
            ROW    10
            COL    10
            WIDTH  120
            HEIGHT 24
            VALUE "Email do Destinatário"
     END LABEL  

     DEFINE TEXTBOX Text_1
            ROW    40
            COL    10
            WIDTH  291
            HEIGHT 22
            ON ENTER {||procedureEnviarEmail( ALLTRIM(This.Value),cFileDanfe,"1"),TESTE_EMAIL.RELEASE}
     END TEXTBOX 

END WINDOW
	teste_email.Center
	teste_email.Activate
return

		// Função para Enviar Email do XML
        Static Function ProcedureEnviarEmail(oEmail,oArq,oTipo)
		       LOCAL cOrigem  := 'C:\ACBrNFeMonitor\entnfe.txt' 
               IF (nHandle := FCREATE(cOrigem, FC_NORMAL)) == -1
                  MsgInfo("File cannot be created:","ENTNFE.TXT")
			         Return
               ENDIF 
               FWRITE(nHandle,"NFE.EnviarEmail("+oEmail+","+oArq+","+oTipo+")")
               FCLOSE(nHandle) 
			  msginfo('Enter para Confirmar o envio do Email da NF-e.')
			  MY_WAIT( 10 )
			ProcedureEsperaResposta()
			RETURN
			
		  Static Function ProcedureEsperaResposta()
               LOCAL cDestino := 'C:\ACBrNFeMonitor\sainfe.txt'
					MY_WAIT( 3 )
					Public xRet_NFe:=memoread(cDestino) 
					msginfo(xRet_NFe)

					Return

static func f_importar()

local varios := .t.   && selecionar varios arquivos
local arq_cas := {}, i, n_for, File_cas, m_rat
Public cCurDir := x_Diretorio

p_GetFile := cCurDir///iif( empty( p_GetFile ) , GetMyDocumentsFolder() , p_GetFile )

arq_cas := GetFile ( { ;
	{'Arquivo XML' , '*.XML'} },;
	'Abre Arquivos' , p_GetFile , varios , .t. )
if len( arq_cas ) = 0
	return nil
endif


m_rat = rat('\',arq_cas[1])
p_GetFile := left( arq_cas[1] , m_rat-1 )
 
col:=len(p_GetFile)+2
 
PUBLIC cNomeArquivo:=(substr(arq_cas[1],col,70))
public cFileDanfe:=arq_cas[1]

retu nil
