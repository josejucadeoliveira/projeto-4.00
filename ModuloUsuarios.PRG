

// Harbour MiniGUI Extend
// (c)2000-2011 JOSE JUCA
// Modulo : Cadastro de Usuarios

#include "Inkey.ch"
#include "minigui.ch"

Procedure ModuloUsuarios()
          Private SISTEMA   := "Controle de Acesso"
	  Private cTitulo   := "Cadastro de Usuários"	&& Titulo desta rotina, será mostrado em formulários
	  Private lNovo	    := .F. 			&& Variável para controlar se Está Incluindo ou alterando usuários
          Private cUser     := mUser
          SET TOOLTIPBALLOON ON
*         // Cria Formulário Principal
	  DEFINE WINDOW Form_Usuarios AT 05,05 WIDTH 425 HEIGHT 460 TITLE "Cadastro de Usuários" ICON 'res/Usuario.ico'	MODAL NOSIZE

		 @ 045,010 GRID Grid_Usuarios WIDTH 400 HEIGHT 295 HEADERS {"Código","Apelido","Nome"} WIDTHS {60,120,213} VALUE 1;
		           FONT "Arial" SIZE 09 ON DBLCLICK { || Bt_Novo_usuario(2) }

		 @ 357,011 LABEL  Label_Pesquisa VALUE "Pesquisa " AUTOSIZE TRANSPARENT
                 @ 353,085 TEXTBOX TxtPesquisa	WIDTH 326 BACKCOLOR {191,225,255} TOOLTIP "Digite o Nome para Pesquisa" MAXLENGTH 40 UPPERCASE;
		           ON ENTER { || Pesquisa_Usuario() }

		 @ 397,011 BUTTON Novo_usuario	    ;
			     CAPTION '&Novo'                ;
			     ACTION { || Bt_Novo_usuario(1)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		 @ 397,111 BUTTON Editar_Usuario	  ;
			     CAPTION '&Editar'           ;
			     ACTION { || Bt_Novo_usuario(2)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		 @ 397,211 BUTTON Excluir_Usuario	 ;
			     CAPTION 'E&xcluir'          ;
			     ACTION { || Bt_Excluir_Usuario(1)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		 @ 397,311 BUTTON Bt_Sair_Usuario	       ;
			     CAPTION '&Sair'                ;
			     ACTION { || Bt_Sair_Usuario() };
			     FONT "MS Sans Serif" SIZE 09 FLAT
                 ON KEY ESCAPE ACTION ThisWindow.Release

	END WINDOW

*       // Coloca o Cursor/Foco em TxtPesquisa
	Form_Usuarios.TxtPesquisa.SetFocus
*       // Realiza pesquisa para atualizar o Grid pela primeira vez
	Renova_Pesquisa_Usuario(" ")
        SET TOOLTIP TEXTCOLOR TO WHITE  OF Form_Usuarios
        SET TOOLTIP BACKCOLOR TO BLUE   OF Form_Usuarios
*       // Centraliza Janela
	CENTER	 WINDOW Form_Usuarios

*       // Ativa Janela
	ACTIVATE WINDOW Form_Usuarios
	Return Nil

Function Bt_Novo_usuario(nTipo)
	 Local nReg	    := PegaValorDaColuna( "Grid_Usuarios" , "Form_Usuarios" , 1 )
	 Local cStatus	    := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)
	 Local aStatus	    := {}

*        // Variavel Private que controla se está sendo efetuada uma inclusão ou uma alteração
	 lNovo		    := Iif(nTipo==1,.T.,.F.)

*        // Se Tipo for 2, o usuário está Alterando/Editando um Registro
	 If nTipo == 2

*           // Se o usuário estiver editando/alterando um registro e a variável nReg estiver vazia é porque o grid não foi clicado
*           // Esta variável recebeu (veja cima) o valor do Grid em PegavalorDaColuna()
            If Empty(nReg)
               MsgExclamation("Nenhum Registro Informado para Edição!!",SISTEMA)
               Return Nil
            Else
               oQuery  := oServer:Query( "Select * From acesso WHERE CODIGO = " + AllTrim( nReg )  )
               If oQuery:NetErr()
                  MsgInfo("Erro de Pesquisa (Operação) (Select): " + oQuery:Error())
                  Return Nil
               Endif
               oRow       := oQuery:GetRow(1)
               cCodigo    := oRow:fieldGet(1)
*              // Se codigo a ser alterado foi localizado, a variável CodigoAlt Guarda o Valor do Codigo do usuário para posterior pesquisa e gravação
            EndIf
	 EndIf

*        // Cria Janela de cadastro
         DEFINE WINDOW Novo_Usuario AT 0,0 WIDTH 380 HEIGHT 570 TITLE cTitulo MODAL NOSIZE

		DEFINE STATUSBAR
			STATUSITEM "Manutenção no "+cTitulo
		END STATUSBAR

		@ 052,010 LABEL LCodigo VALUE 'Código' AUTOSIZE TRANSPARENT
		@ 050,060 TEXTBOX TxtCODIGO HEIGHT 25 WIDTH 50 FONT 'Arial' SIZE 09 BACKCOLOR {191,225,255}
                @ 052,283 LABEL LNivel VALUE 'Nível' AUTOSIZE TRANSPARENT
		@ 050,332 TEXTBOX TxtNIVEL HEIGHT 25 WIDTH 20 FONT 'Arial' SIZE 09 TOOLTIP "Digite o Nível do Usuário para o Sistema  0 a 9" MAXLENGTH 01;
                          ON ENTER Iif( Novo_Usuario.TxtNIVEL.Value $ "1234567890" ,  Novo_Usuario.TxtNOME.SetFocus , Novo_Usuario.TxtNIVEL.SetFocus ) BACKCOLOR {191,225,255} ON GOTFOCUS  {|| setControl( .T. ) } ON LOSTFOCUS {|| setControl( .F. ) }
		@ 083,010 LABEL LNome VALUE 'Nome' AUTOSIZE TRANSPARENT
		@ 080,060 TEXTBOX TxtNOME HEIGHT 25 WIDTH 300 FONT 'Arial' SIZE 09 TOOLTIP "Digite Nome do Usuário" MAXLENGTH 30 UPPERCASE;
                          ON ENTER  Iif( Empty( Novo_Usuario.TxtNOME.Value ) , Novo_Usuario.TxtNOME.SetFocus , Novo_Usuario.TxtAPELIDO.SetFocus )BACKCOLOR {191,225,255} ON GOTFOCUS  {|| setControl( .T. ) } ON LOSTFOCUS {|| setControl( .F. ) }
		@ 114,010 LABEL LApelido VALUE 'Apelido' AUTOSIZE TRANSPARENT
		@ 110,060 TEXTBOX TxtAPELIDO HEIGHT 25 WIDTH 110 FONT 'Arial' SIZE 09 TOOLTIP "Digite o Apelido para acesso do Usuário" MAXLENGTH 12 UPPERCASE BACKCOLOR {191,225,255};
                          ON GOTFOCUS  {|| setControl( .T. ) } ON LOSTFOCUS {|| setControl( .F. ), Novo_Usuario.BSalvar.Enabled := .T. }
		          ON ENTER  Iif( Empty( Novo_Usuario.TxtAPELIDO.Value ) , Novo_Usuario.TxtAPELIDO.SetFocus , Novo_Usuario.LInclui.SetFocus )
		@ 114,180 LABEL LVencto VALUE 'Vence em' AUTOSIZE TRANSPARENT
		@ 110,240 DATEPICKER DtVencto FONT "Arial" SIZE 09 BACKCOLOR {191,225,255} TOOLTIP "Data de Vencimento da Senha" ON GOTFOCUS  {|| setControl( .T. ) } ON LOSTFOCUS {|| setControl( .F. ) }
                @ 143,010 LABEL Lsenha  VALUE 'Senha' AUTOSIZE TRANSPARENT
		@ 140,060 TEXTBOX TxtSENHA   PASSWORD HEIGHT 25 WIDTH 110 FONT 'Arial' SIZE 09 TOOLTIP "Digite a Senha de Acesso do Usuário" MAXLENGTH 12 BACKCOLOR {191,225,255} ON GOTFOCUS  {|| setControl( .T. ) } ON LOSTFOCUS {|| setControl( .F. ) }
                @ 143,180 LABEL LRsenha  VALUE 'Repetir' AUTOSIZE TRANSPARENT
                @ 140,240 TEXTBOX TxtRSENHA  PASSWORD HEIGHT 25 WIDTH 110 FONT 'Arial' SIZE 09 TOOLTIP "Repita a Senha de Acesso do Usuário" MAXLENGTH 12 BACKCOLOR {191,225,255} ON GOTFOCUS  {|| setControl( .T. ) } ON LOSTFOCUS {|| setControl( .F. ) }
                @ 180,010 FRAME Frame_1 CAPTION 'Operações' WIDTH 350 HEIGHT 80 FONT 'Arial' SIZE 09

                @ 195,020 CHECKBOX lCadastro    CAPTION 'Cadastro'     WIDTH 90 HEIGHT 25 VALUE .F.
                @ 195,135 CHECKBOX lCtareceber  CAPTION 'Cta Arecebe'  WIDTH 90 HEIGHT 25 VALUE .F.
                @ 195,240 CHECKBOX lEstoque     CAPTION 'Estoque'      WIDTH 90 HEIGHT 25 VALUE .F.
                @ 225,020 CHECKBOX lProducao    CAPTION 'Producao'     WIDTH 90 HEIGHT 25 VALUE .F.
                @ 225,135 CHECKBOX lnfe      CAPTION 'Nfe'          WIDTH 90 HEIGHT 25 VALUE .F.
                @ 225,240 CHECKBOX lcpag        CAPTION 'Cta Apagar'   WIDTH 90 HEIGHT 25 VALUE .F.

		@ 475,010 BUTTON BSalvar   CAPTION '&Salvar'   ACTION Bt_Salvar_Usuarios()  WIDTH 70 HEIGHT 25 FONT "MS Sans Serif" SIZE 09 FLAT
		@ 475,090 BUTTON BExcluir  CAPTION '&Excluir'  ACTION Bt_Excluir_Usuario(2) WIDTH 70 HEIGHT 25 FONT "MS Sans Serif" SIZE 09 FLAT
		@ 475,290 BUTTON BCancelar CAPTION '&Cancelar' ACTION Novo_Usuario.Release  WIDTH 70 HEIGHT 25 FONT "MS Sans Serif" SIZE 09 FLAT

                ON KEY ESCAPE ACTION ThisWindow.Release
	END WINDOW

*       // Como o código do Usuário e gerado pelo sistema, o campo código é desabilitado
	Novo_Usuario.TxtCODIGO.Enabled := .F.

*       // Se a operação for de Alteração/Edição
	If ! lNovo
            Novo_Usuario.txtSenha.Value  := Decripta( AllTrim(oRow:fieldGet(4)) )
            Novo_Usuario.txtRsenha.Value := Decripta( AllTrim(oRow:fieldGet(4)) )
            Novo_Usuario.txtSenha.Enabled := .F.
            Novo_Usuario.txtRSenha.Enabled := .F.
*           // Preeenche o Status Atual do Usuário que será alterado
            cRet          := AllTrim(oRow:fieldGet(6) )
            Aadd( aStatus, Substr( cRet , 1 , 1) 			   ) && Nivel do Usuário
            Aadd( aStatus, CtoD(Substr( cRet , 2 , 10 ) ) ) && Data de Vencimento da Senha
			
            Aadd( aStatus, Iif( Substr( cRet ,12 , 1) == "1" , .T. , .F.  )) && Cadastros
msginfo(cret) //
            Aadd( aStatus, Iif( Substr( cRet ,13 , 1) == "1" , .T. , .F.  )) && Cta A receber
            Aadd( aStatus, Iif( Substr( cRet ,14 , 1) == "1" , .T. , .F.  )) && Estoque
            Aadd( aStatus, Iif( Substr( cRet ,15 , 1) == "1" , .T. , .F.  )) && Produção
            Aadd( aStatus, Iif( Substr( cRet ,16 , 1) == "1" , .T. , .F.  )) && nfe
            Aadd( aStatus, Iif( Substr( cRet ,17 , 1) == "1" , .T. , .F.  )) && Cta Apagar

*           // Coloca nos objetos do Formulário os dados do usuário a ser alterado
            Novo_Usuario.TxtCodigo.Value     := AllTrim(oRow:fieldGet(1))
            Novo_Usuario.TxtNIVEL.Value	     := aStatus[ 1]
            Novo_Usuario.TxtNOME.Value	     := AllTrim(oRow:fieldGet(2))
            Novo_Usuario.TxtAPELIDO.Value    := AllTrim(oRow:fieldGet(3))
            Novo_Usuario.DtVencto.Value	     := aStatus[ 2]
            Novo_Usuario.lCadastro.Value     := aStatus[ 3]
            Novo_Usuario.lCtareceber.Value   := aStatus[ 4]
            Novo_Usuario.lEstoque.Value	     := aStatus[ 5]
            Novo_Usuario.lProducao.Value     := aStatus[ 6]
            Novo_Usuario.lnfe.Value       := aStatus[ 7]
            Novo_Usuario.lcpag.value         := aStatus[ 8]
*           // Elimina Objeto Query */
            oQuery:Destroy()
	Else
*	    //	*** Caso a operação seja de inclusão, coloca valor default 9 para Nível do Usuário, Data de vencimento da Senha
*           //	*** 900 dias à partir da data do sistema, desabilita botão Excluir e Salvar.
*           //	*** O Botão Excluir nunca será habilitado porque está sendo Incluído um novo registro
*           //	*** O Botão salvar só é habilitado quando o nome do usuário é digitado e o cursor/Foco vai para o campo apelido e executa a Cláusula  ON LOSTFOCUS Novo_Usuario.BSalvar.Enabled := .T.
            Novo_Usuario.TxtNIVEL.Value	  := "9"
            Novo_Usuario.DtVencto.Value	  := Date() + 365
            Novo_Usuario.BExcluir.Enabled := .F.
            Novo_Usuario.BSalvar.Enabled  := .F.
	EndIf

*       // Coloca na barra de Status do Formulário a variavel com informação de Alteração ou Inclusão
	Novo_Usuario.StatusBar.Item(1) := cStatus
*       // Pociociona o Cursor/Foco em TxtNivel
	Novo_Usuario.TxtNIVEL.SetFocus

        SET TOOLTIP TEXTCOLOR TO WHITE  OF Novo_Usuario
        SET TOOLTIP BACKCOLOR TO BLUE   OF Novo_Usuario
*       // Centraliza janela
	CENTER   WINDOW Novo_Usuario

*       // Ativa Janela
	ACTIVATE WINDOW Novo_Usuario
	Return NIL

Function Pesquisa_Usuario()
	Local cPesq                    := ' "'+Upper(AllTrim(   Form_Usuarios.TxtPesquisa.Value ))+'%" '
	Local nTamanhoNomeParaPesquisa := Len(cPesq)
	Local i
*       // Exclui todos registros do Grid
	DELETE ITEM ALL FROM Grid_Usuarios OF Form_Usuarios
*       // Monta Objeto Query com Selecão */
        oQuery := oServer:Query( "select CODIGO , APELIDO , USUARIO, SENHA from acesso WHERE USUARIO LIKE "+cPesq+" Order By USUARIO" )
*       // Verifica se ocorreu algum erro na Pesquisa */
        If oQuery:NetErr()
            MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
            Return Nil
        Endif
*       // Adiciona as Informações do Grid
        If oQuery:LastRec() >0
           For i := 1 To oQuery:LastRec()
              oRow := oQuery:GetRow(i)
              ADD ITEM {  oRow:fieldGet(1)  , oRow:fieldGet(2) , Decripta( oRow:fieldGet(3) ) } TO Grid_Usuarios Of Form_Usuarios
           Next i
*          // Elimina Objeto Query */
           oQuery:Destroy()
        EndIf

*       // Pisiciona o cursor/Foco no campo TxtPesquisa
	Form_Usuarios.TxtPesquisa.SetFocus
	Return Nil

	
Function Renova_Pesquisa_Usuario(cNome)
	Form_Usuarios.TxtPesquisa.Value := Substr(AllTrim(cNome),1,10)
	Form_Usuarios.TxtPesquisa.SetFocus
	Pesquisa_Usuario()
	Return Nil

Function Bt_Salvar_Usuarios()
	Local cCodigo
	Local cPesq	:= AllTrim( Form_Usuarios.TxtPesquisa.Value )

*       // Se o campo Nome ou Apelido não  forem informados, enviar mensagem e posiciona cursor/Foco no campo TxtNome
	If Empty( Novo_Usuario.TxtNome.Value  )   .Or.  Empty( Novo_Usuario.TxtApelido.Value  )
	   PlayExclamation()
	   MsgInfo("Nome ou Apelido não Informado !!","Operação Inválida")
	   Novo_Usuario.txtNOME.SetFocus
	   Return Nil
	EndIf

*       // Se for um Novo registro
	If lNovo

           If AllTrim(Novo_Usuario.txtSenha.Value)==Alltrim(Novo_Usuario.txtRsenha.Value)
*             // Marca variavel lNovo como FALSE
              lNovo    := .F.

*             // Verifica Quantos Registros tem no Arquivo
              oQuery  := oServer:Query( "Select * From acesso " )
               If oQuery:NetErr()
                  MsgInfo("Erro de Pesquisa (Operação) (Select): " + oQuery:Error())
                  Return Nil
              Endif

*             // Pega Ultimo Codigo
              cCodigo  := StrZero(oQuery:LastRec()+1,4)
              oQuery:Destroy()

              cNome    := AllTrim(Novo_Usuario.txtNOME.Value)
              cApelido := AllTrim(Novo_Usuario.txtApelido.Value)
              cStat    := CriptografaStatusDoUsuario()
              cPass    := Encripta(AllTrim(Novo_Usuario.txtSenha.Value))
		*          // Grava novo Registro no Arquivo
              cQuery := "INSERT INTO acesso  VALUES ( "
              cQuery += NTRIM(cCodigo)    +" ,"
              cQuery += NTRIM(cNome)      +" ,"
			  cQuery += NTRIM(cApelido)   +" ,"
              cQuery += NTRIM(cPass)      +" ,"
              cQuery += NTRIM('')         +" ,"
              cQuery += NTRIM(cStat)      +" )"
           Else
              MsgInfo("Senha Repetida não confere com a senha informada - VERIFIQUE !!!")
              Novo_Usuario.txtRsenha.SetFocus
              Return
           EndIf
        Else
				

           cCodigo  := Novo_Usuario.TxtCodigo.Value
           cNome    := AllTrim(Novo_Usuario.txtNOME.Value)
           cApelido := AllTrim(Novo_Usuario.txtApelido.Value)
           cStat    := CriptografaStatusDoUsuario()
		   cQuery   := "UPDATE acesso SET "
           cQuery   += "Usuario = "+NTRIM(cNome)     +" ,"
           cQuery   += "Apelido = "+NTRIM(cApelido)  +" ,"
           cQuery   += "Status  = "+NTRIM(cStat)+"  WHERE CODIGO = " + NTRIM( cCodigo )
  
  Endif
*//     Aplica alterações
        oQuery  :=  oServer:Query( cQuery )
        If oQuery:NetErr()
           MsgInfo("Erro na Execução (UpDate/Insert): " + oQuery:Error())
           Return Nil
        Endif

*       // Envia mensagem para usuário
        MsgINFO("Registro Alterado/Inserido!!!")

*       //  Efetua Release do formulário de Cadastro
	Novo_Usuario.Release

*       // Envia para a Rotina de Pesquisa os Dez Primeiros caracteres do Novo Apelido
	Renova_Pesquisa_Usuario(Substr( cNome,1,10))
	Return Nil

Function CriptografaStatusDoUsuario()
	Local cSeq	:= ""
	cSeq:= Novo_Usuario.TxtNivel.Value
	cSeq+= DtoC( Novo_Usuario.DtVencto.Value )
	cSeq+=Iif( Novo_Usuario.lCadastro.Value   , "1" ,  "0"  )
	cSeq+=Iif( Novo_Usuario.lCtareceber.Value , "1" ,  "0"  )
	cSeq+=Iif( Novo_Usuario.lEstoque.Value    , "1" ,  "0"  )
	cSeq+=Iif( Novo_Usuario.lProducao.Value   , "1" ,  "0"  )
	cSeq+=Iif( Novo_Usuario.lnfe.Value     , "1" ,  "0"  )
    cSeq+=Iif( Novo_Usuario.lcpag.value       , "1" ,  "0"  )

	Return( cSeq )

Function Bt_Excluir_Usuario( nGrid )
        Local gCodigo     := AllTrim( PegaValorDaColuna( "Grid_Usuarios" , "Form_Usuarios" , 1 ) )
        Local gNome       := AllTrim( PegaValorDaColuna( "Grid_Usuarios" , "Form_Usuarios" , 2 ) )
        Local cQuery

        oQuery  := oServer:Query( "Select * From acesso WHERE CODIGO = " + AllTrim( gCodigo )  )
        If oQuery:NetErr()
           MsgInfo("Erro de Pesquisa (Operação) (Select): " + oQuery:Error())
           Return Nil
        Endif
        If oQuery:LastRec()>0
           oRow:= oQuery:GetRow(1)
           If !Empty(oRow:FieldGet(5))
              MsgInfo("Usuário já Teve primeiro acesso, não pode ser excluido","Acesso")
              oQuery:Destroy()
              Return
           EndIf
           oQuery:Destroy()
        EndIf
        If MsgYesNo( "Confirma Exclusão de: "+ gNome+ "??" )
           cQuery     := "DELETE FROM acesso WHERE CODIGO = " + AllTrim( gCodigo )
           oQuery      := oQuery  :=  oServer:Query( cQuery )
           If oQuery:NetErr()
              MsgInfo("Erro na Exclusão (Delete): " + oQuery:Error())
              Return Nil
           EndIf
           MsgInfo(  "Registro Excluído !!" )
           Renova_Pesquisa_Usuario(" ")
        EndIf
        Return Nil


Function Bt_Sair_Usuario()
	Form_Usuarios.Release
	Return Nil


* // Alteração de Senhas de Usuario
Function AlteraSenha()
        Local cPassWord		:= ""
        Local NewPassWord	:= ""
        Local ConfirmPassWord	:= ""

*       // Cria Form Nova_senha
	DEFINE WINDOW Form_Nova_senha ;
		AT 0,0 ;
		WIDTH 280 HEIGHT 235 ;
		TITLE 'Alteração de Senha de Acesso'   MODAL NOSYSMENU BACKCOLOR BLUE

		@010,030 LABEL Label_User	;
			 VALUE "Usuário Atual"	;
			 WIDTH 120		;
			 HEIGHT 35		;
			 FONT "Arial" SIZE 09	;
                                           BACKCOLOR BLUE	;
                                           FONTCOLOR WHITE BOLD

	 	 @045,030 LABEL Label_Password	;
			   VALUE "Senha       "	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	;
                                             BACKCOLOR BLUE 	;
                                             FONTCOLOR WHITE BOLD

	 	 @080,030 LABEL Label_NewPassword;
			   VALUE "Nova Senha      "	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	;
                                             BACKCOLOR BLUE 	;
                                             FONTCOLOR WHITE BOLD

	 	 @115,030 LABEL Label_ConfirmPassword;
			   VALUE "Confirmação      "	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	;
                                             BACKCOLOR BLUE 	;
                                             FONTCOLOR WHITE BOLD

                             @013,120 TEXTBOX  p_User	;
                                            HEIGHT 25		;
                                            VALUE cUser		;
                                            WIDTH 120		;
                                            FONT "Arial" SIZE 09

                             @048,120 TEXTBOX  p_password	;
                                            VALUE cPassWord	;
                                            PASSWORD		;
                                            FONT "Arial" SIZE 09	;
                                            TOOLTIP "Senha de Acesso";
 			  MAXLENGTH 12		;
			  UPPERCASE		;
			  ON ENTER  Iif(  Cheka_Senha() ,   Form_Nova_senha.newpassword.SetFocus ,  Form_Nova_senha.p_password.SetFocus )

                             @083,120 TEXTBOX  Newpassword	;
			   VALUE ""                         ;
                                            PASSWORD		;
                                            FONT "Arial" SIZE 09	;
                                            TOOLTIP "Digite sua nova senha";
			  MAXLENGTH 12		;
			  UPPERCASE		;
			  ON ENTER  Iif( ! Empty( Form_Nova_senha.newpassword.Value ) ,  Form_Nova_senha.ConfirmPassword.SetFocus,  Form_Nova_senha.NewPassword.SetFocus )

                             @118,120 TEXTBOX  Confirmpassword;
                                            VALUE ""		;
                                            PASSWORD		;
                                            FONT "Arial" SIZE 09	;
                                            TOOLTIP "Confirma s senha digitada";
  			  MAXLENGTH 12		;
			  UPPERCASE		;
			  ON ENTER  Iif( ! Empty( Form_Nova_senha.ConfirmPassword.Value )  ,  Form_Nova_senha.Bt_Confirma.SetFocus,  Form_Nova_senha.ConfirmPassword.SetFocus )

                             @ 160,030 BUTTON Bt_Confirma	;
                                            CAPTION '&Confirma'	;
                                            ACTION Confirma_Troca()	;
                                            FONT "MS Sans Serif" SIZE 09 FLAT

                             @ 160,143 BUTTON Bt_Cancela                   ;
                                             CAPTION '&Cancela'                 ;
			   ACTION Form_Nova_senha.Release	      ;
                                             FONT "MS Sans Serif" SIZE 09 FLAT

	END WINDOW

*       //* Desabilita o TextBox p_user que contém o apelido do usuário ativo
	Form_Nova_senha.p_User.Enabled := .F.
*       // Posiciona o Cursor/Foco no textBox p_passWord
	Form_Nova_senha.p_password.SetFocus
        SET TOOLTIP TEXTCOLOR TO WHITE  OF Form_Nova_Senha
        SET TOOLTIP BACKCOLOR TO BLUE   OF Form_Nova_Senha
*	// Centraliza janela
	CENTER WINDOW Form_Nova_senha
*	// Ativa Janela
	ACTIVATE WINDOW Form_Nova_senha
	Return Nil

Function Confirma_Troca()
        Local oQuery
        Local oRow   := {}

*       // Confirmação da Nova Senha Digitada
	If Form_Nova_senha.NewPassword.Value != Form_Nova_senha.ConfirmPassword.Value
		MsgInfo("Senha de Confirmação Inválida... Redigite!!","Erro na Confirmação da Senha")
		Form_Nova_senha.NewPassword.Value := ""
		Form_Nova_senha.ConfirmPassword.Value := ""
		Form_Nova_senha.NewPassword.SetFocus
		Return Nil
	Endif

*       // Solicita ao usuário que confirme a alteração da Senha
	If MsgYesNo( "Confirma Alteração de sua Senha de Acesso?" , SISTEMA )
*          // Decripta a Senha do arquivo e compara a Senha do usuário com a senha Digitada
           oQuery  := oServer:Query( "Select * From acesso WHERE APELIDO = " + AllTrim( cUser )  )
           If oQuery:NetErr()
              If ASCAN("Unknown column",oQuery:NetErr()) = 0
                 MsgInfo("Usuário não Cadastrado no Sistema")
              Else
                 MsgInfo("Erro de Pesquisa (Operação) (Select): " + oQuery:Error())
              EndIf
              Return Nil
           Endif
           cAcesso       := AllTrim(Encripta(  Form_Nova_Senha.NewPassword.Value  ))
           cQuery := "UPDATE acesso SET SENHA = '"+cAcesso+"' WHERE CODIGO = " + AllTrim( cCodigo )

*          // Envia Mensagem ao Usuário
	   MsgInfo("Sua senha foi atualizada!!" , SISTEMA )
	EndIf

	** Efetua Release no Form Nova_Senha
	Form_Nova_Senha.Release

	Return Nil

/*
*/
Function Cheka_Senha()
	Local lRet := .T.
        Local oQuery
        Local oRow   := {}

*       // Decripta a Senha do arquivo e compara a Senha do usuário com a senha Digitada
        oQuery  := oServer:Query( "Select * From acesso WHERE APELIDO = " + AllTrim( cUser )  )
        If oQuery:NetErr()
           If ASCAN("Unknown column",oQuery:NetErr()) = 0
              MsgInfo("Usuário não Cadastrado no Sistema")
           Else
              MsgInfo("Erro de Pesquisa (Operação) (Select): " + oQuery:Error())
           EndIf
           Return Nil
        Endif
        oRow          := oQuery:GetRow(1)
        cAcesso       := AllTrim( oRow:fieldGet(4) )
	If Decripta( cAcesso ) != Form_Nova_senha.p_password.Value
	   MsgInfo("Senha de acesso Inválida!!",SISTEMA)
	   lRet := .F.
	EndIf
        oQuery:Destroy()
	Return lRet

STATIC Function setControl()
 