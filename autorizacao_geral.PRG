//	--------------------------------------------------
* Autor: JOSE JUCA DE OLIVEIRA
* TS_BROWSE: MINIGUI:Extended/harbour 1.8.88 mysql nativa
* DATA 26/10/2010
**////////////////////////////////////
#include "minigui.ch"
#include 'i_textbtn.ch'
#INCLUDE "INKEY.CH"
#Include "F_sistema.ch"
#Include "JUMBOII.ch"
#include "winprint.ch"
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
DECLARE WINDOW janelaclientes
DECLARE WINDOW Win_Men04b
DECLARE WINDOW Win_Men05a
Static oWnd, aFont[ 5 ], aBrush[ 7 ], aBmp[ 6 ]
STATIC nWinWidth, nWinHeight
#define CHAR_REMOVE  "/;-:,\.(){}[] "

function autorizacaogeral(status)
        local Licenca    := ''
        local cQuery, i, nPos
        Local cInfName   := ''
        Local aUsers     :={}
		public status_z   :=status
		
	*msginfo(status_z)
		 
Reconectar_A() 
*     	// Inicializar ambiente
	     SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
	     SET DATE TO BRITISH          // Define a o formato padrão da data dd/mm/yyyy do sistema
	     SET EPOCH TO 1910            // Define o valor do ano base para datas que possuem somente dois dígitos para o ano
	     SET MULTIPLE OFF             // Não permite carregar varias aplicações ao mesmo tempo
	     SET LANGUAGE TO PORTUGUESE   // Habilita suporte português para o minigui
	     *SET NAVIGATION EXTENDED      // Habilita mundança de objeto por enter
	     *SET TOOLTIPBALLOON ON        // Habilita ToolTip em formato de balão
        *SET BROWSESYNC ON

*       // Carregar tela de login para validar usuário
        cQuery:="SELECT * FROM parametros"
*       // Executa Query
        oQuery:=oServer:Query( cQuery )
        If oQuery:NetErr()
           MsgInfo("SQL SELECT error:parametros " + oQuery:Error(),"Acesso")
           FinalizarSistema()
           Return
        Endif
*       // Pega informações do Parametro
        If oQuery:LastRec() > 0
           oRow    :=oQuery:GetRow(1)
           mNom :=Decripta(AllTrim( oRow:fieldGet(2) ))
           mEnd :=AllTrim( oRow:fieldGet(3) )
           mBai :=AllTrim( oRow:fieldGet(5) )
           mCep :=Transform(oRow:fieldGet(6),"@R 99999-999")
           mTel :=Transform(oRow:fieldGet(4),"@R (99) 9999-9999" )
           mCid :=AllTrim( oRow:fieldGet(7) )
           mSiglaUF:=mUF[oRow:fieldGet(8)]
           mCNPJ:=Transform(oRow:fieldGet(9),"@R 99.999.999/9999-99")
           mIE  :=Transform(oRow:fieldGet(10),"@R 999.999.999.999")
           mCRM :=Transform(oRow:fieldGet(12),"@R 999.999-!!")
		   mCNAE:=oRow:fieldGet(15)
		   mIM  :=oRow:fieldGet(16)
           mEmail:=AllTrim(oRow:FieldGet(13))
           mHome :=AllTrim(oRow:FieldGet(14))
           oQuery:Destroy()
        EndIf

		
*       Verifica o Arquivo de configuração (INI)
        If ! File("Parametros.ini")
           BEGIN INI FILE "Parametros.ini"
              SET SECTION "Acesso"           ENTRY "UserName"         To ""
              SET SECTION "Acesso"           ENTRY "Data"             To DtoC( Date() )
              SET SECTION "Acesso"           ENTRY "Hora"             To Time()
           END INI
        EndIf
*       Pega Informações do Arquivo
        BEGIN INI FILE "Parametros.ini"
           GET cInfName          SECTION "Acesso"     ENTRY "UserName"
        END INI
		*       // Varre o arquivo de Usuários
        oQuery  := oServer:Query( "Select * From acesso " )
        If oQuery:LastRec()>0
           For i := 1 To oQuery:LastRec()
              oRow := oQuery:GetRow(i)
              aadd(aUsers,AllTrim(oRow:FieldGet(3)) )
           Next i
           oQuery:Destroy()
        EndIf
*       // Verifica se ja ouve alguma acesso pelo terminal
        nPos:=ASCAN(aUsers,cInfName)
*       // Abre Login de acesso ao sistema
        DEFINE WINDOW FormLogin AT 0,0;
		WIDTH 490;
		HEIGHT 350;
		TITLE 'Acesso ao Sistema';
		MODAL;
		NOSYSMENU
		

             @ 001,001  IMAGE    Image_1          PICTURE 'res/PassWord.BMP' WIDTH 256 HEIGHT 256
             @ 015,250  LABEL    Label_User       VALUE "Usuário " FONT "Cambria" SIZE 13 AUTOSIZE TRANSPARENT
             @ 095,250  LABEL    Label_Password   VALUE "Senha   " FONT "Cambria" SIZE 13 AUTOSIZE TRANSPARENT
             @ 040,250  COMBOBOX cUsers           WIDTH 215 ITEMS aUsers VALUE nPos FONT "Arial" SIZE 11 BOLD BACKCOLOR {191,223,255} ON GOTFOCUS setControl(.T.) ON LOSTFOCUS setControl(.F.)
            @ 120,250  TEXTBOX  p_password       HEIGHT 30        VALUE '' PASSWORD WIDTH 215 FONT "Arial" SIZE 12 TOOLTIP "Senha de Acesso" BACKCOLOR {191,225,255} ;
                                                   ON ENTER  Iif( !Empty( FormLogin.p_password.Value ) , Set_Variaveis(status_z) , FormLogin.p_password.SetFocus ) ON GOTFOCUS  {|| setControl( .T. ) } ON LOSTFOCUS {|| setControl( .F. ) }
             @ 270,010  BUTTON   Bt_Login         CAPTION '&Login'        FONT "Cambria" SIZE 15 BOLD WIDTH 125 HEIGHT 35 FLAT ACTION Set_Variaveis()
             @ 270,340  BUTTON   Bt_Logoff        CAPTION '&Cancela'      FONT "Cambria" SIZE 15 BOLD WIDTH 125 HEIGHT 35 FLAT ACTION FormLogin.Release()
 
			 
        END WINDOW
        If FormLogin.cUsers.Value=0
           FormLogin.cUsers.SetFocus
        Else
           FormLogin.p_PassWord.SetFocus
        EndIf
        CENTER WINDOW FormLogin
        ACTIVATE WINDOW FormLogin
      Return Nil

	  
	 
Static Function Set_Variaveis(status_z)
*       Abre tabela de Cadastro dos Usuarios
        Local cUser        := AllTrim( FormLogin.cUsers.DisplayValue )
        Local cPassWord    := AllTrim( FormLogin.p_password.Value )
        Local cAcesso
        Local cStatusdoUsuario:= {}
        Local cRet
        Local cQuery
        Local lAchou       := .F.
        Local cCodigo
		local _nome_usuario_:=cUser
*	msginfo(status_z)
		
*       Verifica se Usuário Cadastrado
        oQuery  := oServer:Query( "Select * From acesso " )
*       Verifica a insidencia de erro
        If oQuery:NetErr()
           MsgInfo("Erro de Pesquisa (Operação) (Select): " + oQuery:Error())
           FinalizarSistema()
           Return
        EndIf
*       // Senha não pode passar em Branco
        If Empty(cPassWord)
           MsgInfo("Necessário preenchimento do campo Senha para prosseguir","Acesso")
           FormLogin.p_password.SetFocus
           Return
        EndIf
*       Varre a Query com as informações de Usuarios Verificando Nome e senha de Acesso
        If oQuery:LastRec()>0
		
           For i := 1 To oQuery:LastRec()
              oRow := oQuery:GetRow(i)
              If AllTrim(oRow:FieldGet(3))==cUser
                 lAchou := .T.
                 cCodigo:= oRow:FieldGet(1)
		          cAcesso:= AllTrim( oRow:FieldGet(4) )
                 cRet   := AllTrim( oRow:FieldGet(6) )
                 Exit
              EndIf
           Next i
           oQuery:Destroy()
        ElseIf oQuery:LastRec()=0
        cQuery := "INSERT INTO acesso  VALUES ( '0001', 'Adminstrador' , 'ADMIN' ,'"+('1234')+"' ,'','"+('91111111')+"')"
           lAchou := .T.
           cCodigo:='0001'
           cAcesso:= Encripta('97113194')
           cRet   := ''
*          // Verifica se Usuário Cadastrado
           oQuery  := oServer:Query( cQuery )
*          // Verifica a insidencia de erro
           If oQuery:NetErr()
              MsgInfo("Erro de Operação (Insert): " + oQuery:Error())
              FinalizarSistema()
              Return
           EndIf
        EndIf
		* Se não encontrar o usuario retorna ao Login
        If !lAchou
           MsgInfo("Usuário não Cadastrado no Sistema - Favor Verificar !!!","Acesso")
           Return(FormLogin.cUsers.SetFocus)
        EndIf
*       Descriptografa a Senha do usuário armazenada no arquivo e compara com a senha digitada
        If Decripta( cAcesso ) != cPassWord
*          Se for diferente, envia mensagem e posiciona o cursor no campos p_password
           MsgInfo("Senha de acesso Inválida!!","Acesso")
           FormLogin.p_password.Value:=''
           Return(FormLogin.p_password.SetFocus)
        EndIf
  	 *  cRet:=Decripta(cRet)
   *    // Define Acessos e Privilegio dos Usuarios Cadastrados
        Aadd( cStatusdoUsuario,       Substr( cRet , 1 , 1) 			   )  && Nivel do Usuário
        Aadd( cStatusdoUsuario, CtoD( Substr( cRet , 2 , 10 ) ) 	           )  && Data de Vencimento da Senha
        Aadd( cStatusdoUsuario,  Iif( Substr( cRet ,12 , 1) == "1" , .T. , .F.  )) && Financeiro
        Aadd( cStatusdoUsuario,  Iif( Substr( cRet ,13 , 1) == "1" , .T. , .F.  )) && Almoxarifado
        Aadd( cStatusdoUsuario,  Iif( Substr( cRet ,14 , 1) == "1" , .T. , .F.  )) && Producao
        Aadd( cStatusdoUsuario,  Iif( Substr( cRet ,15 , 1) == "1" , .T. , .F.  )) && Vendas
        Aadd( cStatusdoUsuario,  Iif( Substr( cRet ,16 , 1) == "1" , .T. , .F.  )) && Gerencia
        Aadd( cStatusdoUsuario,  Iif( Substr( cRet ,17 , 1) == "1" , .T. , .F.  )) && Cta Apagar
**      // 1º Posicão: Níivel do usuário: 0 à  9 - Somente os usuários de níve 0 podem acessar o cadastro de USUARIOS
		if cStatusdoUsuario[1]=="9"
	   
		
If status_z == 1
resumo_caixa(1)
Endif

	
		FormLogin.Release
		else
		MsgInfo("Este usuário não possui acesso!!","Acesso")
		FormLogin.p_password.SetFocus
        Return (.t.)
	endif
Return Nil



	
	
