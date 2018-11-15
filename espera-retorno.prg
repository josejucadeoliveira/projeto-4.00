 oSefaz := SefazClass()
   oSefaz:cAmbiente := CTE_AMBIENTE
   oSefaz:CteLoteEnvia( cTxtXml, "1", "SP", NomeCertificado( "CARBOLUB" ) )
   DO WHILE .T.
      IF oSefaz:cStatus $ "100,101,202,302"
         hb_MemoWrit( hb_cwd() + "..\CARBOLUB\IMPORTA\CTE-" + cCteNum + "-" + oSefaz:cStatus + "-Autorizado.xml", oSefaz:cXmlAutorizado )
         oXmlPdf := XmlPdfClass():New()
         oXmlPdf:cChave := cCteChave
         oXmlPdf:cXmlEmissao := oSefaz:cXmlAutorizado
         oXmlPdf:GeraPdf()
         MsgExclamation( iif( oSefaz:cStatus == "100", "CTE Autorizado", "CTE Denegado" ) )
         EXIT
      ENDIF
      IF oSefaz:cStatus $ "105" // em processamento
         Mensagem( "Problemas na SEFAZ. Nova tentativa em 1 minuto, ESC abandona" )
         IF Inkey(100) != K_ESC
            Mensagem( "Tentando novamente" )
            oSefaz:CTeConsultaRecibo()
            LOOP
         ENDIF
      ENDIF
      hb_MemoWrit( "NFE\CTE-" + cCteNum + "-02-Assinado.xml",  oSefaz:cXmlDocumento )
      hb_MemoWrit( "NFE\CTE-" + cCteNum + "-03-Envelope.xml",  oSefaz:cXmlSoap )
      hb_MemoWrit( "NFE\CTE-" + cCteNum + "-04-Recibo.xml",    oSefaz:cXmlRecibo )
      hb_MemoWrit( "NFE\CTE-" + cCteNum + "-05-Protocolo.xml", oSefaz:cXmlProtocolo )
      hb_MemoWrit( "NFE\CTE-" + cCteNum + "-06-Retorno.xml",   oSefaz:cXmlRetorno )
      IF ! Empty( oSefaz:cMotivo )
         MsgExclamation( "Erro " + oSefaz:cStatus + " " + oSefaz:cMotivo )
      ELSE
         MsgExclamation( "Erro desconhecido " + Pad( oSefaz:cXmlProtocolo, 1000 ) )
      ENDIF
      EXIT
   ENDDO