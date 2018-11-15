// --------------------------------------------------------------------------.
FUNCTION ENVIAR_NFcE_class()
// --------------------------------------------------------------------------.
Local cValue := ""
Local teste  := ""
Local teste1  := ""
Local teste3  := ""
local datahorarec:=""
local RETORNO:=""
local xstatus:=""
local FC_NORMAL 
LOCAL ARQEVENTO:=""
////////[STATUS]
LOCAL S_Versao  :=""  //SVRS20101110174320
LOCAL S_TpAmb   :=""  //1
LOCAL S_VerAplic:=""  //SVRS20101110174320
*LOCAL S_CStat   :=""  //107
Local sCStat  :="" //107
LOCAL S_XMotivo :=""  //Servico em Operacao
LOCAL S_DhRecbto:=""  //29/03/2011 07:22:22
LOCAL S_TMed    :=""  //1
LOCAL S_DhRetorno:="" //30/12/1899
LOCAL S_XObs     :=""
///////FIM///////////////
//////[ENVIO]//////////////
LOCAL E_Versao  :=""  //SVRS20100210155347
LOCAL E_TpAmb   :="" //1
LOCAL E_VerAplic:="" //SVRS20100210155347
LOCAL E_CStat   :="" // 103
LOCAL E_XMotivo :="" //Lote recebido com sucesso
LOCAL E_NRec    :="" //113000263213135
LOCAL E_DhRecbto:="" //29/03/2011 07:22:35
LOCAL E_TMed    :="" //1
///////FIM///////////////
/////[RETORNO]//////////
LOCAL R_Versao  :=""  //SVRS20110322100218
LOCAL R_TpAmb   :="" //1
local sXMotivo:=""  //Servico em Operacao
LOCAL R_VerAplic:="" //SVRS20110322100218
LOCAL R_NRec    :="" //113000263213135
LOCAL R_CStat   :="" //100
LOCAL R_XMotivo :="" //=Autorizado o uso da NF-e
///////FIM///////////////
//////[CONSULTA]///////////
local c_Versao  :=""//SVRS20100811185009
local c_TpAmb   :=""//2
local c_VerAplic:=""//SVRS20100811185009
local c_CStat   :=""//100
local cXMotivo :=""//Autorizado o uso da NF-e
local c_CUF     :=""//11
local c_ChNFe   :=""//11110384712611000152550010000004201000004201
local c_DhRecbto:=""//29/03/2011 07:47:33
local c_NProt   :=""//311110000010110
LOCAL nSeconds := 0, nCount := 4, lLoop := .T.
LOCAL Ret_Status_Servico:=.T.
LOCAL nLote    := '0'
local R_DigVal:=''
local R_DhRecbto:='' 
local r_CodigoERRO:=""
local xJust:="Sem acesso a Internet" 
Local r_ChNFe    :="" 
local r_Stat     :="" 
LOCAL ArquivoX:=""
local cx_nuNFe:=""
local xchave:=""
LOCAL XFormaEmissao:=""
local r_MensagemERRO:=""
LOCAL VMODELO:="65"
LOCAL vNFE      :=0
LOCAL vCHAVENFE :=""
local c_CFileDanfe:=""
LOCAL nOpc := 1, GetList := {}, cTexto := "", nOpcTemp
LOCAL cCnpj := Space(14), cChave := Space(44), cCertificado := "", cUF := "RO", cXmlRetorno
LOCAL oSefaz, cXml, oDanfe, cTempFile, nHandle
local path :=DiskName()+":\"+CurDir()
LOCAL ximpressora:=1
abreNFCE()
abreITEMNFCE()
abreseq_nfe()



PUBLIC zNUMERO:=xSEQ_TEF :=strzero(month(date() ), 2 )
SET DATE FORMAT "dd/mm/yyyy" // Define o formato da data (postgreSQL)
xxANO     := dtoS(date())
xxANO     :=ALLTRIM(SUBSTR(xXANO,0,4))

Xml   :=alltrim(zNUMERO+xxANO+"-NFCe")
pdf   :=alltrim(zNUMERO+xxANO+"-pdfNFCe")
tmp  :=alltrim(zNUMERO+xxANO+"-tmpNFCe")

         cSubDir := DiskName()+":\"+CurDir()+"\"+xml+"\"
  		 nError := MakeDir( cSubDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	  cSubDirTMP:= DiskName()+":\"+CurDir()+"\"+tmp+"\"
  		 nError := MakeDir( cSubDirTMP )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF

	
  PdfbDir := DiskName()+":\"+CurDir()+"\"+pdf+"\"
  		 nError := MakeDir( PdfbDir )
            IF nError == 0
         *   msginfo( "Diretório criado com sucesso", cSubDir, "Diretório criado com sucesso")
            ELSEIF nError == 5
           *  msginfo( "Já existe Diretorio Criado", cSubDir, "Já existe Diretorio Criado")
            ELSE
        * msginfo( "Erro de Criação do Diretório" )  ////, cSubDir, LTrim( Str( nError ) ) 
    ENDIF
	
 MODIFY CONTROL Servico_AVISO of oForm2 VALUE   'A G U A R D E -G E R A Ç Ã O - X M L  '  

*msginfo(cambiente) 

*******************************************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
			 
	 END INI
******************************************************************	 
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
    cXmlAutorizado:= cTexto
   cXml:= MEMOREAD(cTexto)
   lRetorno_Internet:=.T.

 
*********Verifica serviço******************
cXmlRetorno := oSefaz:NfeStatus()
 hb_MemoWrit( "servico.xml", oSefaz:cXmlRetorno )
 cFileDanfe:= "servico.xml"
   Linha   := Memoread(cFileDanfe)
  xcStat   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
 xxmotivo  := PegaDados('xMotivo' ,Alltrim(Linha), .f. )
 
if cambiente='1'
 ambiente:="Produção"
 else
   ambiente:="Homologação"
 endif
 
HB_Cria_Log_nfce(xcStat,xxmotivo+"  Amb.:"+ambiente)
 

 if xcStat='107'   

MODIFY CONTROL ok1 OF oForm2  Value  'Ok   '

//////////////////SE TEM INTERNET CRIA E ENVIA *****************************
   oNfe:= hbNfe()
   oNFe:cUFWS := '11' // UF WebService
   oNFe:tpAmb := cAmbiente // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
  *oNFe:versaoDados := '3.10'  ///versaoDados // Versao
   oNFe:tpEmis := '1' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNfe:cPastaSchemas :=DiskName()+":\"+CurDir()+"\"+"Schemas"
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=cSubDirTMP
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:=PATH+"\NFCE.TXT"
   oIniToXML := hbNFCeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oValida := hbNFeValida()
   oIniToXML:lValida := .T.
   aRetorno  := oIniToXML:execute()
   oValida:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML := Nil
    xchave      :=(aRetorno['cChaveNFe'])
  
     
   
 *        *MODIFY CONTROL Servico_AVISO of oForm2 VALUE   'A G U A R D E -G E R A Ç Ã O - X M L  '  
          SetProperty('oForm2','Servico_AVISO ','Value','A G U A R D E -G E R A Ç Ã O - X M L  ')
         SetProperty('oForm2','mostra_XML','Value',"" +  xchave)
          SetProperty('oForm2','mostra_XML','BLINK',.T.)    
	
	
   xCbdNtfSerie:=SUBSTR(xchave,23,3)
   xnumero     :=SUBSTR(xchave,26,9)
   cTexto      :=xchave+"-nfe.XML"
   cXml:= MEMOREAD(cSubDirTMP+cTexto)
   cXmlAutorizado:=cTexto
   
       oValida:cXML := cXml // Arquivo XML ou ConteudoXML
        aRetorno := oValida:execute()
	*msginfo:=(oValida:execute) 
		
        oValida := Nil
        IF aRetorno['OK'] == .F.
        retornox:=( aRetorno['MsgErro'])
            ELSE
         retornox :="VALIDO"
        HB_Cria_Log_nfce(cTexto,+" Retorno.:"+retornox)
	    ENDIF
      
MODIFY CONTROL ok2 OF oForm2  Value  'Ok   '
 
   vNFE        :=val(xnumero)
   xCbdNtfSerie:=val(xCbdNtfSerie)
   
   cString     :=strzero(vNFE,9)
   outras      :=strzero(xCbdNtfSerie,3)
   
  
     HB_Cria_Log_nfce(cString,xchave+"  Serie.:"+outras)
	 
   *MODIFY CONTROL mostra_XML OF oForm2  VALUE   ' '+alltrim(xchave) 

 			
*******************************************************************
    BEGIN INI FILE "CERTIFICADO.ini"
             GET cCertificado  SECTION "NOME"   ENTRY "NOME"
			 GET cUF           SECTION "Estado"   ENTRY "cUF"
			 
	 END INI
***********************************************************************************
	 /////////////////criando//////////////////enviar/////////////////////////
********************************************************************************** 
   oSefaz     := SefazClass():New()
   oSefaz:cUF := cUF
   oSefaz:cAmbiente:=cAMBIENTE
   oSefaz:cNFCE:='S' 
   oSefaz:NFeLoteEnvia( @cXml, '1', cUF, ALLTRIM(cCertificado), cAmbiente )
   hbNFeDaNFe( oSefaz:cXmlAutorizado )
    hb_MemoWrit( cSubDir+cXmlAutorizado, oSefaz:cXmlAutorizado )
   hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo) 
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "XmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   CNPROT   := PegaDados('cStat'   ,Alltrim(Linha),.f. )
    
HB_Cria_Log_nfce(cString,xchave+"  cStat.:"+oSefaz:cStatus+"  "+oSefaz:cMotivo)
If oSefaz:cStatus $ [102,103,104,105,106,107,108,109,110,111,112,124,128,135,136,137,138,139,140,142,150,151,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,301,302,303,304,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,349,350,351,352,353,354,355,356,357,358,359,360,361,362,364,365,366,367,368,369,370,372,373,374,375,376,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,401,402,403,404,405,406,407,408,409,410,411,417,418,420,450,451,452,453,454,455,461,462,463,464,465,466,467,468,471,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,496,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,567,568,569,570,571,572,573,574,575,576,577,578,579,580,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,650,651,653,654,655,656,657,658,660,661,662,663,678,679,680,681,682,683,684,685,686,687,688,689,690,691,693,694,695,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,740,741,742,743,745,746,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,798,799,800,805,806,807,999,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879]
* MsgExclamation( "Erro " + oSefaz:cXmlRetorno )
 msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
  HB_Cria_Log_nfe(cString,xchave+"  Erro.:"+oSefaz:cMotivo)	 
 return(.f.)
endif
   
   
   
   

MODIFY CONTROL ok3 OF oForm2  Value  'Ok   '
MODIFY CONTROL ok4 OF oForm2  Value  'Ok   '


IF oSefaz:cStatus $ "204,539"

           SELE NFCE 
                    If LockReg()  
                       NFCE->NUM_SEQ := vNFE+1
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                 Unlock
                 ENDIF   
				 
     Select ITEMNFCE
      go top
       OrdSetFocus('item')
     
   
 Do While ! ITEMNFCE->(Eof())
	  If LockReg()  
         ITEMNFCE->nseq_orc  := vNFE+1
		 ITEMNFCE->(DBCOMMIT())
		 ITEMNFCE->(DBUNLOCK())
          Unlock
         ENDIF            
ITEMNFCE->(dbskip())
LOOP
ENDD
   return(.f.)
ENDIF


RRCStat:=oSefaz:cStatus
*msginfo(RRCStat)
if RRCStat='201' .or. RRCStat='501' .or. RRCStat='202' .OR. RRCStat= "203" .or. RRCStat="205" .or. RRCStat="206" .or. RRCStat="207" .or. RRCStat="208" .or. RRCStat="209" .OR. RRCStat='210' .or. RRCStat='211' .or. RRCStat='212' .or. RRCStat='213' .or. RRCStat='214' .or. RRCStat='215' .or. RRCStat='216' .or. RRCStat='217' .or. RRCStat='218' .or. RRCStat='219' .or. RRCStat='220' .or. RRCStat='221' .or. RRCStat='222' .or. RRCStat='223' .or. RRCStat='224' .or. RRCStat='225' .or. RRCStat='226' .or. RRCStat='227' .or. RRCStat='229' .or. RRCStat='230' .or. RRCStat='231' .or. RRCStat='232' .or. RRCStat='233' .or. RRCStat='234' .or. RRCStat='235' .or. RRCStat='236' .or. RRCStat='237' .or. RRCStat='238' .or. RRCStat='239' .or. RRCStat='240' .or. RRCStat='241' .or. RRCStat='242' .or. RRCStat='243' .or. RRCStat='244' .or. RRCStat='245' .or. RRCStat='246' .or. RRCStat='247' .or. RRCStat='248' .or. RRCStat='249' .or. RRCStat='250'  .or. RRCStat='251' .or. RRCStat='252' .or. RRCStat='253' .or. RRCStat='254' .or. RRCStat='255' .or. RRCStat='256' .or. RRCStat='257' .or. RRCStat='258' .or. RRCStat='259' .or. RRCStat='260' .or. RRCStat='261' .or. RRCStat='262' .or. RRCStat='263' .or. RRCStat='264' .or. RRCStat='265' .or. RRCStat='266'  .or. RRCStat='267' .or. RRCStat='268' .or. RRCStat='269' .or. RRCStat='270' .or. RRCStat='271' .or. RRCStat= '272' .or. RRCStat='273' .or. RRCStat='274' .or. RRCStat='275' .or. RRCStat='276' .or. RRCStat='277' .or. RRCStat='278' .or. RRCStat='279' .or. RRCStat='280' .or. RRCStat='281' .or. RRCStat='282'  .or. RRCStat='283' .or. RRCStat='284' .or. RRCStat='285' .or. RRCStat='286' .or. RRCStat='287' .or. RRCStat='288' .or. RRCStat='289' .or. RRCStat='290' .or. RRCStat='291' .or. RRCStat='292' .or. RRCStat='293' .or. RRCStat='294' .or. RRCStat='295' .or. RRCStat='296' .or. RRCStat='297' .or. RRCStat='298' .or. RRCStat='299' .or. RRCStat='401' .or. RRCStat='402' .or. RRCStat='403' .or. RRCStat='404' .or. RRCStat='405' .or. RRCStat='406' .or. RRCStat='407' .or. RRCStat='409' .or. RRCStat='410' .or. RRCStat='411' .or. RRCStat='420' .or. RRCStat='450' .or. RRCStat='451' .or. RRCStat='452' .or. RRCStat='453'  .or. RRCStat='454' .or. RRCStat='478' .or. RRCStat='502' .or. RRCStat='503' .or. RRCStat='504' .or. RRCStat='505' .or. RRCStat='506' .or. RRCStat='507' .or. RRCStat='508' .or. RRCStat='509' .or. RRCStat='510' .or. RRCStat='511' .or. RRCStat='512' .or. RRCStat='513' .or. RRCStat='514' .or. RRCStat='515' .or. RRCStat='516' .or. RRCStat='517' .or. RRCStat='518' .or. RRCStat='519' .or. RRCStat='520' .or. RRCStat='521' .or. RRCStat='522' .or. RRCStat='523'  .or. RRCStat='524' .or. RRCStat='525' .or. RRCStat='526' .or. RRCStat='527' .or. RRCStat='528' .or. RRCStat='529' .or. RRCStat='530' .or. RRCStat='531'  .or. RRCStat='532' .or. RRCStat='534' .or. RRCStat='535' .or. RRCStat='536' .or. RRCStat='537' .or. RRCStat='538' .or. RRCStat='540' .or. RRCStat='541' .or. RRCStat='542' .or. RRCStat='544' .or. RRCStat='545' .or. RRCStat='546' .or. RRCStat='547' .or. RRCStat='548' .or. RRCStat='549' .or. RRCStat='550' .or. RRCStat='551' .or. RRCStat='552' .or. RRCStat='553' .or. RRCStat='554' .or. RRCStat='555' .or. RRCStat='556' .or. RRCStat='557' .or. RRCStat='558'  .or. RRCStat='559' .or. RRCStat='560' .or. RRCStat='561' .or. RRCStat='562' .or. RRCStat='564' .or. RRCStat='565' .or. RRCStat='567' .or. RRCStat='568' .or. RRCStat='569' .or. RRCStat='570' .or. RRCStat='571' .or. RRCStat='572' .or. RRCStat='573' .or. RRCStat='574' .or. RRCStat='575' .or. RRCStat='576' .or. RRCStat='577' .or. RRCStat='578' .or. RRCStat='579' .or. RRCStat='580' .or. RRCStat='587' .or. RRCStat='588' .or. RRCStat='589' .or. RRCStat='590' .or. RRCStat='591' .or. RRCStat='592' .or. RRCStat='593' .or. RRCStat='594' .or. RRCStat='595' .or. RRCStat='596' .or. RRCStat='597' .or. RRCStat='598'  .or. RRCStat='599' .or. RRCStat='601' .or. RRCStat='602' .or. RRCStat='603' .or. RRCStat='604' .or. RRCStat='605' .or. RRCStat='606' .or. RRCStat='607' .or. RRCStat='608' .or. RRCStat='609' .or. RRCStat='610' .or. RRCStat='611' .or. RRCStat='612' .or. RRCStat='613' .or. RRCStat='614' .or. RRCStat='615' .or. RRCStat='616' .or. RRCStat='617' .or. RRCStat='618' .or. RRCStat='619' .or. RRCStat='620' .or. RRCStat='621' .or. RRCStat='622' .or. RRCStat='623' .or. RRCStat='624' .or. RRCStat='625' .or. RRCStat='626' .or. RRCStat='627' .or. RRCStat='628' .or. RRCStat='629' .or. RRCStat='630' .or. RRCStat='631'  .or. RRCStat='632' .or. RRCStat='634' .or. RRCStat='635' .or. RRCStat='650' .or. RRCStat='651' .or. RRCStat='653' .or. RRCStat='654' .or. RRCStat='655' .or. RRCStat='656' .or. RRCStat='657' .or. RRCStat='658' .or. RRCStat='660' .or. RRCStat='661' .or. RRCStat='662'  .or. RRCStat='663' .or. RRCStat='678' .or. RRCStat='679' .or. RRCStat='680' .or. RRCStat='681' .or. RRCStat='682' .or. RRCStat='683' .or. RRCStat='684' .or. RRCStat='685' .or. RRCStat='686' .or. RRCStat='687' .or. RRCStat='688' .or. RRCStat='689' .or. RRCStat='690' .or. RRCStat='691' .or. RRCStat='700'  .or. RRCStat='701' .or. RRCStat='702' .or. RRCStat='703' .or. RRCStat='704' .or. RRCStat='705' .or. RRCStat='706' .or. RRCStat='707' .or. RRCStat='708' .or. RRCStat='709' .or. RRCStat='710' .or. RRCStat='711' .or. RRCStat='712' .or. RRCStat='713' .or. RRCStat='714' .or. RRCStat='715' .or. RRCStat='716' .or. RRCStat='717' .or. RRCStat='718' .or. RRCStat='719' .or. RRCStat='720' .or. RRCStat='721' .or. RRCStat='723' .or. RRCStat='724' .or. RRCStat='725' .or. RRCStat='726' .or. RRCStat='727' .or. RRCStat='728' .or. RRCStat='729' .or. RRCStat='730' .or. RRCStat='731' .or. RRCStat='732' .or. RRCStat='733'   .or. RRCStat='734' .or. RRCStat='735' .or. RRCStat='736' .or. RRCStat='737' .or. RRCStat='738' .or. RRCStat='739' .or. RRCStat='740' .or. RRCStat='741' .or. RRCStat='742' .or. RRCStat='743' .or. RRCStat='745' .or. RRCStat='746' .or. RRCStat='748' .or. RRCStat='749' .or. RRCStat='750' .or. RRCStat='751' .or. RRCStat='752' .or. RRCStat='753' .or. RRCStat='754' .or. RRCStat='755' .or. RRCStat='756' .or. RRCStat='757' .or. RRCStat='758' .or. RRCStat='759' .or. RRCStat='760' .or. RRCStat='762' .or. RRCStat='763' .or. RRCStat='764' .or. RRCStat='765' .or. RRCStat='766' .or. RRCStat='767' .or. RRCStat='768'  .or. RRCStat='769' .or. RRCStat='770' .or. RRCStat='771' .or. RRCStat='772' .or. RRCStat='773' .or. RRCStat='774' .or. RRCStat='775' .or. RRCStat='776' .or. RRCStat='777' .or. RRCStat='778' .or. RRCStat='779' .or. RRCStat='780' .or. RRCStat='781' .or. RRCStat='782' .or. RRCStat='783' .or. RRCStat='784' .or. RRCStat='785' .or. RRCStat='786' .or. RRCStat='787' .or. RRCStat='788' .or. RRCStat='789' .or. RRCStat='790' .or. RRCStat='791' .or. RRCStat='792' .or. RRCStat='793' .or. RRCStat='794' .or. RRCStat='795' .or. RRCStat='796' .or. RRCStat='999' 
msginfo(oSefaz:cMotivo)
return(.f.)
endif


 IF oSefaz:cStatus $ "100"
 
MODIFY CONTROL ok2 OF oForm2  Value  'Ok   '
MODIFY CONTROL ok3 OF oForm2  Value  'Ok   '
MODIFY CONTROL ok4 OF oForm2  Value  'Ok   '

   hbNFeDaNFe( oSefaz:cXmlAutorizado )
   hb_MemoWrit( cSubDir+cXmlAutorizado, oSefaz:cXmlAutorizado )
   hb_MemoWrit( "cXmlRetorno.xml", oSefaz:cXmlRetorno )
   cFileDanfe:= "cXmlRetorno.xml"
   Linha   := Memoread(cFileDanfe)
   ffxml   := Memoread(cXmlAutorizado)
   CNPROT   := PegaDados('nProt'   ,Alltrim(Linha),.f. )
   R_DhRecbto := PegaDados('DhRecbto'   ,Alltrim(Linha),.f. )
   hb_MemoWrit( "XmlRetorno.xml", oSefaz:cXmlRetorno )
   hb_MemoWrit( "XmlProtocolo.xml", oSefaz:cXmlProtocolo) 

    HB_Cria_Log_nfce(cString,xchave+"  nPROT.:"+CNPROT+"  "+R_DhRecbto)
   
   
chave   := substr(cXml , 0, 48)
cXml    :=cSubDir+xchave+"-nfe.xml"
ffxml   :=Memoread(cXml)

if ximpressora=1

oPDF    := hbnfeDaNfe():New()
oDanfe  := hbNFeDaGeral():New()
*oPDF:SetEanOff()
oDanfe:ToPDF(  Memoread( cXml ) ,PdfbDir+ xchave+"-nfe.pdf" )
cpdf:=PdfbDir+xchave+"-nfe.pdf" 
*PDFOpen(cpdf)
*imprimidaruma(xchave,xnumero,R_DhRecbto)

cRet := MON_ENV("NFE.ImprimirDanfe("+cXml+")")
HB_Cria_Log_nfce(cpdf,cRet)
else

oPDF    := hbnfeDaNfe():New()
oDanfe  := hbNFeDaGeral():New()
*oPDF:SetEanOff()
oDanfe:ToPDF(  Memoread( cXml ) ,PdfbDir+ xchave+"-nfe.pdf" )
cpdf:=PdfbDir+xchave+"-nfe.pdf" 
*PDFOpen(cpdf)
MSGINFO('NFE.ImprimirDanfebbbbbb')

imprimidaruma(xchave,xnumero,R_DhRecbto)

endif 

 cQuery := "UPDATE NFCE SET  horaS='"+Time()+"',CHAVE='"+xchave +"',nt_retorno= '"+(AllTrim(ffxml))+"',autorizacao= '"+CNPROT+"' WHERE CbdNtfNumero = "+ntrim(vNFE)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(xCbdNtfSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4904 PROPLEMA")
    Return Nil
endif


SELE NFCE 
                    If LockReg()  
                       NFCE->NUM_SEQ := 0 
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                 Unlock
                 ENDIF   
		



MODIFY CONTROL mostra_auto OF oForm2  VALUE   ' '+alltrim(CNPROT) 
GRAVA_nfCe1()
		
************************************************************************  
ELSE    /////SE DEU ALGO ERRADO  

************************************************************************  
msginfo("ATENÇAO TENTE REFAZER O PROCESSO"+ CRLF +oSefaz:cMotivo )
 HB_Cria_Log_nfce(cString,xchave+"  Erro.:"+oSefaz:cMotivo)
 

return(.f.)
endif


***********************************************************************
else    //'Serviço não Esta Ativo, ENTRA CONTIGENCIA
***********************************************************************


CONTIGENCIA:=1
xJust      :="Sem acesso a Internet" 
xcStat  :='Off-Line'
dt_server:=date()
hora_server:=time()  
MODIFY CONTROL ok1 OF oForm2  Value  'Off-Line'
  
  HB_Cria_Log_nfe(xcStat,xJust+"  Amb.:"+ambiente)
 
    BEGIN INI FILE path+"\NFCE.TXT"
     SET SECTION "Identificacao"  ENTRY "tpEmis"  TO '9' ///contingencia para NFCe
     SET SECTION "Identificacao"  ENTRY "dhCont"  TO dtoc(dt_server)+" "+hora_server ///contingencia para NFCe
     SET SECTION "Identificacao"  ENTRY "xJust"   TO xJust ///contingencia para NFCe
	* aadd(DADOS_NFe,{'hSaiEnt='+(TIME())})
   END INI


    oNfe := hbNfe()
   oNFe:cUFWS := '11' // UF WebService
   oNFe:tpAmb := cAMBIENTE // Tipo de Ambiente
   oNFe:versaoDados := XVERSAONFCE  ///versaoDados // Versao
  * oNFe:versaoDados := '3.10'  ///versaoDados // Versao
   oNFe:tpEmis := '9' //normal/scan/dpec/fs/fsda
   oNFe:cUTC    := '-04:00' 
   oNFe:empresa_UF := '11'
   oNFe:empresa_cMun := '1100304'
   oNFe:empresa_tpImp := '1'
   oNFe:versaoSistema := '2.00'
   oNFe:pastaNFe :=cSubDirTMP
   oNFe:cSerialCert := '50211706083EBA4C'
   cIniAcbr:=PATH+"\NFCE.TXT"
   oIniToXML := hbNFCeIniToXML()
   oIniToXML:ohbNFe := oNfe // Objeto hbNFe
   oIniToXML:cIniFile := cIniAcbr
   oIniToXML:lValida := .T.
   aRetorno  := oIniToXML:execute()
   oIniToXML := Nil
   xchave      :=(aRetorno['cChaveNFe'])
   xCbdNtfSerie:=SUBSTR(xchave,23,3)
   xnumero     :=SUBSTR(xchave,26,9)
   cTexto      :=cSubDirTMP+xchave+"-nfe.XML"
   vNFE        :=val(xnumero)
   xCbdNtfSerie:=val(xCbdNtfSerie)
   cXmlAutorizado:= cTexto
   cXml:= MEMOREAD(cTexto)
   
     cString     :=strzero(vNFE,9)
     outras      :=strzero(xCbdNtfSerie,3)
   

 HB_Cria_Log_nfe(cString,xchave+"  Serie.:"+outras)
	
 

 *public cTXT     :=cSubDirTMP+"\"+x_CHAVE+"-nfe.XML"
*F=F+4 
*xmlassinado:=x_CHAVE+"-nfe.XML"

MODIFY CONTROL mostra_auto OF oForm2  VALUE   'Contigencia ' 
MODIFY CONTROL mostra_XML OF oForm2  VALUE   ''+alltrim(xchave) 


 cQuery := "UPDATE NFCE  SET horaS='"+Time()+"',AUTORIZACAO='"+"CONTIGENCIA"+"',CONTIGENCIA='"+NTRIM(CONTIGENCIA)+"', CHAVE='"+(xchave)+"',nt_retorno= '"+(AllTrim(cXml))+"' WHERE CbdNtfNumero = "+ntrim(vNFE)+" AND cbdmod= "+"65"+" and CbdNtfSerie = "+ntrim(xCbdNtfSerie)+" "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
    ELSE
  *  MSGINFO("OK")
  Endif

cQuery := "INSERT INTO nfCE_CONTIGENCIA (CbdNtfNumero,Chave,CbdEmpCodigo,CbdNtfSerie,nt_retorno,nSeqEvento) VALUES ('"+ntrim(vNFE)+"','"+(xchave)+"','"+"1"+"','"+ntrim(xCbdNtfSerie)+"','"+(AllTrim(cXml))+"','"+"0"+"')" 
oQuery:=oServer:Query(cQuery)
If oQuery:NetErr()												
 MsgStop(oQuery:Error())
 MsgInfo("Por Favor Selecione o registro ffff ") 
else	
*MSGINFO("OK GRAVA ")
ENDIF


abrecontige()
SELE contige 
abreserienfce()
SELE serienfce             
fSerie := serienfce->serie
                     abrecontige()
                       SELE contige 
                  	   contige->(dbappend())
		               contige->chave  :=xchave
					   contige->serie  :=xCbdNtfSerie
					   contige->NUMERO :=(vNFE)
			           contige->(dbunlock())

 *MODIFY CONTROL MOSTRA_impressora    OF oForm2  Value   '           Localizando a Impessora Aguarde...'
 MODIFY CONTROL ok5 OF oForm2  Value  'Ok   '
if ximpressora=1
*imprimidaruma_contigencia(cC_ChNFe,vNFE,CCC_DhRecbto,CCC_DigVal,CCC_NProt)
*msginfo('imprimidaruma_contigencia')
cString   :="impressao ok"

cRet := MON_ENV("NFE.ImprimirDanfe("+cTexto+")")
HB_Cria_Log_nfe(cString,cRet)
	
else
*cRet := MON_ENV("NFE.ImprimirDanfe("+fxml+")")
*msginfo('NFE.ImprimirDanfe')
endif

                  SELE NFCE 
                    If LockReg()  
                       NFCE->NUM_SEQ := 0 
                       NFCE->(dbcommit())
                       NFCE->(dbunlock())
                 Unlock
                 ENDIF   
			 

endif
RETURN