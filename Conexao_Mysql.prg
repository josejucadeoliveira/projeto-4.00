#Include "MiniGui.ch"
 
//----------------------------------------------------------------------------//
// Estabelece uma conexão com o MySQL
// Parametros:
//    cServidor - IP do servidor MySQL
//    cUsuario - Usuario de acesso ao MySQL
//    cSenha - Senha do usuario
//    cBanco - Banco de dados que será usado
//
function Conecta_MySQL_NFe (cServidor, cUsuario, cSenha, cBanco, cPorta)
   local  lRetorno := .F.
   oServer_NFe := TMySQLServer ():New (cServidor, cUsuario, cSenha, cPorta)
   lRetorno := (!oServer_NFe:NetErr ())
   if (lRetorno)
      oServer_NFe:selectDB (cBanco)
		If oServer_NFe:NetErr() 
		  MsGInfo("Erro ao conectar a base de dados "+cDataBase_NFe+": "+oServer_NFe:Error() )
		end
   else
      MsGInfo("Erro de Conexão com Servidor / <TMySQLServer> " + oServer_NFe:Error(),'MySql' )
   endif
                         
return (lRetorno)


//----------------------------------------------------------------------------//
//  Desconcta-se do MySQL
//
function Desconecta_MySQL_NFe ()
   oServer_NFe:Destroy ()
return (nil)

 
*--------------------------------------------------------------*
Function Cria_Banco_NFeDestinadas( cDataBase_NFe )
*--------------------------------------------------------------*
Local aDatabaseList
Local Nova_BaseDados:=.f.
Local oQuery         := "" 
cDataBase_NFe:= Lower(cDataBase_NFe)
  
If oServer_NFe == Nil 
  MsgInfo("Não connectado ao SQL server!")
  Return Nil
EndIf
 
aDatabaseList:= oServer_NFe:ListDBs()
If oServer_NFe:NetErr()                                                                                                 	
*  MsGInfo("verifique a base de dados  " + oServer_NFe:Error())
 RETURN NIL
Endif 
	
If AScan( aDatabaseList, Lower(cDataBase_NFe) ) == 0
	if msgyesno("Database "+cDataBase_NFe+" Banco de dados não existente! Deseja Criar ?",'MySql')
		oQuery:=oServer_NFe:Query("CREATE DATABASE " + cDataBase_NFe)
		  If oQuery:NetErr()												
           MsgInfo("Erro: " + oQuery:Error())
        Endif
		Nova_BaseDados:=.t.
	else
		Return Nil
	end
EndIf 

oServer_NFe:SelectDB( cDataBase_NFe )
If oServer_NFe:NetErr() 
  MsGInfo("Erro ao conectar a base de dados "+cDataBase_NFe+": "+oServer_NFe:Error() )
else
   if	Nova_BaseDados==.t.
    	Cria_Tabelas_NFeDestinadas( cDataBase_NFe )
	end
Endif
 
Return Nil
 
*--------------------------------------------------------------*
Function Cria_Tabelas_NFeDestinadas( cDataBase_NFe,cCNPJ )
*--------------------------------------------------------------*
Local oQuery         := "" 
//  Funão de conexão com o MySQL
Conecta_MySQL_NFe (cHostName, cUser, cPassWord, cDataBase_NFe, cPorta)
 
oQuery:=oServer_NFe:Query("SHOW Tables")

		  If oQuery:NetErr()												
           MsgInfo("Erro: " + oQuery:Error())
        Endif

achou_nfe_destinadas:=.f.
achou_empresa:=.f.
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  if alltrim(oRow:fieldGet(1))=='empresa'
	achou_empresa:=.T.
  end
	if  !empty(cCNPJ)
	  if alltrim(oRow:fieldGet(1))==cCNPJ  
		achou_nfe_destinadas:=.T.
	  end
	end
  oQuery:Skip(1)
Next
oQuery:Destroy()

if 	achou_nfe_destinadas==.f.  .and. !empty(cCNPJ)
   nfe_destinadasOpen(cCNPJ)
end
  
if 	achou_empresa==.f.
	EmpresaOpen()
end

Desconecta_MySQL_NFe()
 
Return
///-------------------------------------------------------------------------------

Function nfe_destinadasOpen( cCNPJ  )  
Local oQuery         := "" 
													  

cQuery:="CREATE TABLE `"+cCNPJ+"` ( "+;
"  `chave` varchar(44) NOT NULL,"+;
"  `cnpj` varchar(18) NOT NULL,   "+;
"  `inscricao` varchar(20) default NULL,   "+;
"  `nome` varchar(120) default NULL, "+;
"  `emissao` date default NULL,   "+;
"  `valor` decimal(12,2) default NULL, "+;
"  `xml` longblob,   "+;
"  `download` tinyint(1) default '0',"+;
"  `lancada` tinyint(1) default '0', "+;
"  `serie` varchar(3) default NULL,  "+;
"  `numero` varchar(9) default NULL,  "+;
"  `tipo_operacao` varchar(30) default NULL,  "+;
"  `situacao_nfe` varchar(30) default NULL, "+;
"  `dtevento` varchar(20) default NULL, "+;
"  `dtlancamento` date default NULL, "+;
"  `protocolo` varchar(20) default NULL, "+;
"  `xjust` text  default NULL, "+;
"  `tpEvento` varchar(30) default NULL, "+;
"  `xEvento` varchar(60) default NULL, "+;
"  `nsu` varchar(20) default NULL, "+;
"  UNIQUE KEY `chave` (`chave`)  "+;
") ENGINE=InnoDB DEFAULT CHARSET=latin1; " 
 
	SQL_Error_oQuery_NFe( )
 
	Return 

///-------------------------------------------------------------------------------
*-------------------------------------------------------------------------

Function EmpresaOpen(  )  
 
cQuery:="CREATE TABLE `empresa` ("+;
  "`codigo` int(3) NOT NULL auto_increment,"+;
  "`razao_soc` varchar(60)   default ' ',"+;
  "`estado` varchar(2)   default ' ',"+;
  "`cnpj` varchar(20)   default ' ',"+;
  "`certificado` varchar(30)   default ' ',"+;
  "`ultimo_nsu` double(30,0)   default '0',"+;
  "PRIMARY KEY  (`codigo`),"+;
  "UNIQUE KEY `codigo` (`codigo`)"+;
") ENGINE=InnoDB  CHARSET=latin1;";

 
	SQL_Error_oQuery_NFe()
	oQuery:Destroy()
 

	Return 
/* -------------------------------------------------------------------------- */
function SQL_Error_oQuery_NFe(  )
                                          
Public Retorno_SQL:=.t.

 
   oQuery:=oServer_NFe:Query( cQuery )

	If oQuery:NetErr()												
       MsgStop("Erro SQL: "+oQuery:Error())
	    Retorno_SQL:=.f.

				if Retorno_SQL==.f.
			      HB_Cria_Log_SQL(cUsuario,cQuery+chr(13)+chr(10)+oQuery:Error())
				end                                                                       
	    
       Return .f.
	End 

return Retorno_SQL
*-------------------------------------------------------------------------
function SQL_Error_oQuery(  )
  
Public Retorno_SQL:=.t.

 
   oQuery:=oServer:Query( cQuery )
 
	If oQuery:NetErr()												
       MsgStop("Erro SQL: "+oQuery:Error())
	    Retorno_SQL:=.f.

				if Retorno_SQL==.f.
			      HB_Cria_Log_SQL(cUsuario,cQuery+chr(13)+chr(10)+oQuery:Error())
				end                                                                       
	    
       Return .f.
	End 

return Retorno_SQL
*-------------------------------------------------------------------------
//---------- --------- --------- --------- --------- --------- --------- --------- ---//
// Seleciona os dados de um determinado registro da tabela especificadas.
// Os dados seram obtidos pela função: ySQL_Pega_Dados.
// Será retornado uma query contendo apenas os dados corrente do registro.
// Parametros:
//    oSocket - O numero da conexão com o MySQL.
//    cTabela - Nome da tabela
//    cCampo - Campo da tabela para a comparação
//    cVar - Os dados a serem comparados com o campo.
//   
function MySQL_Seleciona_Dados (oSocket, cTabela, cCampo, cVar)
   local oMySQL_Query := nil, cMySQL_Query := "", cWhere := ""
   cWhere := '"'+cCampo+' ='+cVar+' "'
   cMySQL_Query := "SELECT * FROM "+cTabela+" WHERE "+cCampo+"=" +'"'+cVar+ '"'
   oMySQL_Query := oSocket:Query (cMySQL_Query)
return (oMySQL_Query)
//---------- --------- --------- --------- --------- --------- --------- --------- ---//
// Retorna um dado do registro corrente
// Parametros:
//    oQuery - Uma query obtida pela funçao: MySQL_Seleciona_ Dados
//    cCampo - O campo a ter seu conteudo retornado.
//
function MySQL_Pega_Dados (oQuery, cCampo)
   local var := nil, vEstrutura := {}, cTexto := "", nPos := 0, ;
         oMySQL_Row := nil, x
   if (oQuery != nil .and. cCampo != nil)
      vEstrutura := oQuery:aFieldStruct
      if (len (vEstrutura) > 0)
         nPos := ascan (vEstrutura, {|x| x[1] == cCampo})
         if (nPos > 0)
            oMySQL_Row := oQuery:getrow (1)
            var := oMySQL_Row:fieldGet (nPos)
         endif
         
      endif
      
   endif
   
return (var)
/*

	Funcão que cria máscara para CGC e CPF e atualiza TextBox

*/
Function CriaMascara()	
 
    cWindow:=ThisWindow.Name
    cObjeto:=This.Name
    nValorObjeto:=This.Value

	cNewCGC	:= limpa(AllTrim( nValorObjeto))  && Pega dados digitados no TextBox sem nenhum espaco

	mtamanho_cod=Len(Alltrim(cNewCGC))

	IF mtamanho_cod == 11
		*** Caso contrário, coloca máscara para CPF
		MODIFY &cObjeto OF &cWindow VALUE AllTrim( TransForm( cNewCGC , "@R 999.999.999-99" ) )
	elseif mtamanho_cod == 14
		MODIFY &cObjeto OF &cWindow VALUE AllTrim( TransForm( cNewCGC , "@R 99.999.999/9999-99" ) )
	EndIf

	Return Nil

//----------------------------------------------------------------------------.
