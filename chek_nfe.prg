

Procedure NFe_Check( cRef )                    

			 Local aNFe		:={}  
          
          If lExecutando
             Return Nil
          Endif  
          lExecutando := .T.                      
   		  oNfe:=hbNfe()           
		  
vdata:=dtos(date()-23)
vdata1:=dtos(date())
 *tQuery := oServer:Query( "Select CbdNtfNumero,Chave,nt_retorno,CbdNtfSerie,AUTORIZACAO,NOTATXT From NFCE WHERE  (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" and nt_retorno=''  ) Order By CbddEmi" )
 oQuery_NFe:=oServer_NFe:Query("select CbdNtfNumero,CbddEmi,Chave FROM nfce where (CbddEmi >= "+vdata+" and CbddEmi <= "+vdata1+" AND nt_retorno='' )  order by cbddemi")
         	If oQuery_NFe:NetErr()												
			*      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe:Error())
	         Endif
           
				For NFe := 1 To oQuery_NFe:LastRec()
					  oRow := oQuery_NFe:GetRow(NFe)
			 			aadd(aNFe,{oRow:fieldGet(1) , oRow:fieldGet(2), oRow:fieldGet(3) })
 			   Next
			   oQuery_NFe:Destroy()
				For x := 1 To len(aNFe)
					   Envia_Contigencia( aNFe[x,1] , aNFe[x,2], aNFe[x,3] ) 
 			   Next
          lExecutando := .F.           

      
          Return Nil          
/*
*/
Procedure Envia_Contigencia( cNUMERO , dEmissao , cChave )  

		Execute_Consulta(  cNUMERO , dEmissao , cChave ) 

Return Nil          



Procedure Execute_Consulta(  cNUMERO , dEmissao , cChave )  
Local cPasta:=CurDrive()+":\"+ CurDir() + '\'
Local cModelo:=substr(cChave,21,2)
Local cArquivo_Destino

If !Empty(cChave)

				oQuery_NFe:=oServer_NFe:Query("select  nt_retorno  FROM nfce where  CbdChave='"+cChave+"'")
 	
         	If oQuery_NFe:NetErr()												
			      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe3:Error())
	         Endif

				oRow:= oQuery_NFe:GetRow(1)

	  		 	HANDLE :=  FCREATE (cPasta+"NOTA.XML",0)// cria o arquivo
			   FWRITE(Handle,oRow:FieldGet(1))
			fclose(handle) 
							 
				cArquivo  :=memoread(cPasta+"NOTA.XML")

				ano:= substr(dtos(dEmissao),0,4)
				mes:= substr(dtos(dEmissao),5,2)

 
			*cPasta_NFe:=Criar_Pasta_NFe(substr(cChave,21,2),substr(cChave,5,2),'20'+substr(cChave,3,2))
			cPasta_NFe:=cPasta
			cArquivo_Destino:=cPasta_NFe+cChave+"-nfe.xml"

		   oSefaz:= SefazClass():New()
			oSefaz:cUF:=mgESTADO                                                                  
		   oSefaz:cAmbiente:='1'
		   
		   if cModelo=='65'
		   	oSefaz:cNFCE:='S'
         end
         
cUF:=''
cCertificado:=""

*******************************************************************
   BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
	 END INI


if substr(cChave,35,1)=='1'    						  
 
			oSefaz:NFeConsultaProtocolo(  cChave, cCertificado, '1'  )

			hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
 
 			 // msginfo(oSefaz:cStatus+"-"+  oSefaz:cMotivo)
		   IF  oSefaz:cStatus $ "100,101,150,301,302"

 				oSefaz:NFeGeraAutorizado( cArquivo , oSefaz:cXmlRetorno  )

				hb_MemoWrit( cArquivo_Destino, oSefaz:cXmlAutorizado )
				
         * 	If oQuery_NFe:NetErr()												
			*      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe:Error())
	        * Endif
/*
		 		oQuery_NFe:=oServer_NFe:Query("UPDATE nfce SET CBDStatus='"+oSefaz:cMotivo+"',CBDProtocolo='"+ XmlNode( oSefaz:cXmlRetorno, "nProt" ) +;
				 			"',xml='" +oSefaz:cXmlAutorizado+"' WHERE CbdChave='"+cChave+"'"  )  
*/

        *  	If oQuery_NFe:NetErr()	 											
		*	      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe:Error())
	     *    Endif
		   ELSEIF  oSefaz:cStatus == "217"  // nao consta na base de dados

		   MSGINFO("217")
		   
	    *    Gera_Arquivo_TXT(cChave,dEmissao,'9')  

		   ELSEIF  oSefaz:cStatus == "225" /// ERRO NO SCHEMAS
		      MSGINFO("225")
			  
	         *Gera_Arquivo_TXT(cChave,dEmissao,'9')  

		   ELSEIF  oSefaz:cStatus $ "526" /// NFE FORA DE PRAZO

		     MSGINFO("526")
			 
           *  Inutiliza_NFCe_Class(cChave,oSefaz:cMotivo)

		   ELSEIF  oSefaz:cStatus == "613" ///CHAVE DE ACESSO DIFERENTE DA EXISTENTE

 /*
		   	cNovaChave:=substr(oSefaz:cMotivo,91,44)

		 		oQuery_NFe:=oServer_NFe:Query("UPDATE nfce SET CBDChave='"+cNovaChave+"' WHERE CbdChave='"+cChave+"'"  )  

          	If oQuery_NFe:NetErr()	 											
			      HB_Cria_Log_SQL('Envio Contigencia',oQuery_NFe:Error())
	         Endif
			ENDIF 
*/

MSGINFO("613")
  
			
elseif substr(cChave,35,1)=='9'    						  

MSGINFO("Gera_Arquivo_TXT")

    *     Gera_Arquivo_TXT(cChave,dEmissao,substr(cChave,35,1))  

End         


End 
 

Return          
