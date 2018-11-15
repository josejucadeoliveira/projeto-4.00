
//--------------------------------------
function dupl_nfce(cORCAMENTO)
//--------------------------------------
local nLinha   := 0
local nPagina  := 1
Local pCode:= (AllTrim((GetColValue( "Grid_notas", "janelacupom", 4 ))))
Local aIMP1,aIMP2,aIMP3, pQuery,aRow,oQuery,bRow, eQuery,eRow,NUMERORET
Local copias  := 1 
Local oRow
Local i
local NUMERO:="11" 
local c_encontro
PAG:=0
LIN:=0
MTOTAL       :=0
nQuantItens  = 0
nTOTAL       :=0
nTotORCAMENTO:=0
PUBLIC cNombre
pPedido:=pCode
cNumero:=RTRIM(STRTRAN(NUMERO,"/","_",1,len(NUMERO)))
cNombre:="Relatorios"+"_"+cNumero
*-------------------------------------------------*


         oprint:=tprint('PDFPRINT')
         oprint:init()
         oprint:setunits("MM",0) /// unidad de medida , interlineado
         oprint:selprinter(.F.,.t.,.F.,,,)
     
         if oprint:lprerror
            oprint:release()
            return nil
         endif

         oprint:begindoc(cNombre)
         oprint:setpreviewsize(1)  /// tamaño del preview  1 menor,2 mas grande ,3 mas...
         oprint:beginpage()
         page = 1
  
        oprint:printimage(00,05,30,180,"CABECARIO.jpg")
        oprint:printroundrectangle(27,1,27,200,,0.2)
		
		oprint:printdata(30,175," Pag. nº ","Courier New",10,.T.,,"R",)     
        oprint:printdata(30,182,STR(page),"Courier New",10,.F.,,"R",)  
		 
		 
       ///////////////////pega 
  pQuery:= oServer:Query( "Select NUM_SEQ,Desconto,COD_CLI,nom_cli,cl_end,cl_cid,estado,CL_CGC,RGIE,data_venc,CL_PESSOA,ED_NUMERO,bairro,cep,total_ven,CCF From CUPOM WHERE NUM_SEQ = " +(pPedido))
   If pQuery:NetErr()
  	MsgStop(pQuery:Error())
    MsgInfo("Por Favor verifique linha 5938")
    Return Nil
  Endif
   aRow	          :=pQuery:GetRow(1)
   xNumeroOrc     :=aRow:fieldGet(1)
   xdesconto      :=aRow:fieldGet(2)
   xcod_cli       :=aRow:fieldGet(3)
   xnome          :=aRow:fieldGet(4)
   xende          :=aRow:fieldGet(5)
   xcida          :=aRow:fieldGet(6)
   xuf            :=aRow:fieldGet(7)
   xCL_CGC        :=aRow:fieldGet(8)
   xRGIE          :=aRow:fieldGet(9)
   xdata_ven      :=aRow:fieldGet(10)
   xCL_PESSOA     :=aRow:fieldGet(11)
   xNUME          :=aRow:fieldGet(10)
   xBAIR          :=aRow:fieldGet(13)
   xcep           :=aRow:fieldGet(14)
   xvalor_LIQ     :=aRow:fieldGet(15)
  	     oprint:printdata(30,001, 'Emissão  :'+dtoc(date())+' : '+time() ,"Courier New",10,.T.,,"R",)
		 oprint:printdata(30,100,'Cupom Fiscal '  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(30,150, xNumeroOrc            ,"Courier New",10,.T.,,"R",)
	     oprint:printdata(35,001, "Cliente..:"            ,"Courier New",10,.T.,,"R",)
         oprint:printdata(35,025, Substr(xnome,1,40) +TRAN(xcod_cli,"99999")  ,"Courier New",10,.T.,,"R",) 
      *  oprint:printdata(35,020, TRAN(xcod_cli,"99999")  ,"Courier New",10,.T.,,"R",)              
         oprint:printdata(40,001, "Endereco.:"                  ,"Courier New",10,.T.,,"R",)  
         oprint:printdata(40,025, TRAN(xende,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,001, "Cidade...:"                  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,025, TRAN(xcida,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,150, "Est.:"                      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,170, tran(xuf,"!!")      ,"Courier New",10,.T.,,"R",)
  IF xCL_PESSOA='J'                     
       oprint:printdata(50,001,'Cnpj.....:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
   ENDI
   IF xCL_PESSOA='I'                         
       oprint:printdata(50,001,'Cnpj.....:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
ENDI
 IF xCL_PESSOA='F'                       
           oprint:printdata(50,001,'Cpf......:'                    ,"Courier New",10,.T.,,"R",)
           oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
endif
IF xCL_PESSOA='P'                      
       oprint:printdata(50,001,'Cpf......:'                      ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
endif
	
	oprint:printroundrectangle(52,1,58,200,,0.5)
   	Oprint:printroundrectangle(58,1,150,200,,0.5)   
    Oprint:printroundrectangle(52,17,150,17,,0.1)   
	Oprint:printroundrectangle(52,44,150,44,,0.1) 
	Oprint:printroundrectangle(52,111,150,111,,0.1) 
	Oprint:printroundrectangle(52,133,150,133,,0.1) 
	Oprint:printroundrectangle(52,150,150,150,,0.1) 
    Oprint:printroundrectangle(52,173,150,173,,0.1)      
	
/////////////////////////////////////////////////////////////////////////////////	
	
   oprint:printdata(56,02 ,  'Itens'  ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,18 ,  'Código',"Courier New",10,.T.,,"R",)
   oprint:printdata(56,47 ,  'Descrição Do Produto'   ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,120,  'Unidade' ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,142,  'Qtd'  ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,160,  "Valor r$" ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,185,  "Sub.Total","Courier New",10,.T.,,"R",)
  
f=62

Xtotal=0
nTotPEDIDO:=0
My_SQL_Database_Connect(cDataBase)
oQuery := oServer:Query( "Select NUMCOD,PRODUTO,DESCRICAO,UNID,QUANT,VALOR,SUBTOTAL ,icms,ST,STB,ALIQUOTA From itemcup WHERE NSEQ_ORC = "+pcode+" Order By descricao" )
For i := 1 To oQuery:LastRec()

          oRow         := oQuery:GetRow(i)
          xNUMCOD      := oRow:fieldGet(1)
          xPRODUTO     := oRow:fieldGet(2)
          XDESCRICAO   := oRow:fieldGet(3)
  	      xUNID        := oRow:fieldGet(4) 
          XQUANT       := oRow:fieldGet(5)
          XVALOR       := oRow:fieldGet(6)
          XSUBTOTAL    := oRow:fieldGet(7)
          Xicms        := oRow:fieldGet(8)
          Xst          := oRow:fieldGet(9) 
          Xstb         := oRow:fieldGet(10)  
          XALIQUOTA    := oRow:fieldGet(11)  
     		  nQuantItens++
                 oprint:printdata(F,004, Trans(nQuantItens,'999') ,"Courier New",10,.T.,,"R",)
                 oprint:printdata(F,018, xPRODUTO ,"Courier New",10,.T.,,"R",)	
                 oprint:printdata(F,047, Substr(xDESCRICAO ,1,45),"Courier New",8,.T.,,"R",)	
				 oprint:printdata(F,120, Trans(xUNID,'@!') ,"Courier New",10,.T.,,"R",)
     			 oprint:printdata(F,140, Trans(xQuant,'9,999.99'),"Courier New",10,.T.,,"R",) 
                 oprint:printdata(F,163, Trans(xValor,'@E 99,999.99') ,"Courier New",10,.T.,,"R",)
                 oprint:printdata(F,191, Trans(xSubTotal,'@E 99,999.99'),"Courier New",10,.T.,,"R",)

				 mTOTAL        :=MTOTAL+xValor*xQuant
				 NTOTAL        :=NTOTAL+xValor*xQuant
				 nTotPEDIDO +=(xQuant *xValor )
				 
F=F+4 
oQuery:Skip(1)

// IF F > (11+200)   
 IF nQuantItens=25  

 oprint:endpage()
            page = page+1
            oprint:beginpage()
		
        oprint:printimage(00,05,30,180,"CABECARIO.jpg")
        oprint:printroundrectangle(27,1,27,200,,0.2)
	     oprint:printdata(30,001, 'Emissão  :'+dtoc(date())+' : '+time() ,"Courier New",10,.T.,,"R",)
		 oprint:printdata(30,100,'Cupom Fiscal '  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(30,150, xNumeroOrc            ,"Courier New",10,.T.,,"R",)
	     oprint:printdata(35,001, "Cliente..:"            ,"Courier New",10,.T.,,"R",)
         oprint:printdata(35,025, Substr(xnome,1,40) +TRAN(xcod_cli,"99999")  ,"Courier New",10,.T.,,"R",) 
      *  oprint:printdata(35,020, TRAN(xcod_cli,"99999")  ,"Courier New",10,.T.,,"R",)              
         oprint:printdata(40,001, "Endereco.:"                  ,"Courier New",10,.T.,,"R",)  
         oprint:printdata(40,025, TRAN(xende,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,001, "Cidade...:"                  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,025, TRAN(xcida,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,150, "Est.:"                      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(45,170, tran(xuf,"!!")      ,"Courier New",10,.T.,,"R",)
  IF xCL_PESSOA='J'                     
       oprint:printdata(50,001,'Cnpj.....:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
   ENDI
   IF xCL_PESSOA='I'                         
       oprint:printdata(50,001,'Cnpj.....:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
ENDI
 IF xCL_PESSOA='F'                       
           oprint:printdata(50,001,'Cpf......:'                    ,"Courier New",10,.T.,,"R",)
           oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
endif
IF xCL_PESSOA='P'                      
       oprint:printdata(50,001,'Cpf......:'                      ,"Courier New",10,.T.,,"R",)
       oprint:printdata(50,025, Trans(xCL_CGC,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
endif
		
		
	oprint:printdata(30,175," Pag. nº ","Courier New",10,.T.,,"R",)     
    oprint:printdata(30,182,STR(page),"Courier New",10,.F.,,"R",)  
	oprint:printroundrectangle(52,1,58,200,,0.5)
   	Oprint:printroundrectangle(58,1,150,200,,0.5)   
    Oprint:printroundrectangle(52,17,150,17,,0.1)   
	Oprint:printroundrectangle(52,44,150,44,,0.1) 
	Oprint:printroundrectangle(52,111,150,111,,0.1) 
	Oprint:printroundrectangle(52,133,150,133,,0.1) 
	Oprint:printroundrectangle(52,150,150,150,,0.1) 
    Oprint:printroundrectangle(52,173,150,173,,0.1)      
	
/////////////////////////////////////////////////////////////////////////////////	
	
   oprint:printdata(56,02 ,  'Itens'  ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,18 ,  'Código',"Courier New",10,.T.,,"R",)
   oprint:printdata(56,47 ,  'Descrição Do Produto'   ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,120,  'Unidade' ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,142,  'Qtd'  ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,160,  "Valor r$" ,"Courier New",10,.T.,,"R",)
   oprint:printdata(56,185,  "Sub.Total","Courier New",10,.T.,,"R",)
  F = 62
 ENDIF
NEXT

oQuery:Destroy()

//oprint:printdata( 260,050,"Total R$","Courier New",18,.T.,,"R",)
aEstados := { 'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO' }
//aExtenso := Extenso( nValoDupl, 115, 03 )
cRegiFant:="CASA DAS EMBALAGENS"
cRegiCnpj:="84.710.611/0001-52" 
cRegiIEst:="0000000050410-2"
cRegiNome:="MEDIAL COM. DISTRIBUIDOR LTDA"
cRegiCida:="VILHENA"
cRegiEnde:="AV CAPITÃO CASTRO"
cRegiNume:="3294"
cRegiBair:="CENTRO"
cRegiFone:="69 3321 4575"
cRegiCEP :="76980-000"
cemail   :="medial@ps5.com.br"
cskype   :="jose.juca3044" 

oprint:printdata(162,001,'ITENS'+Trans(nQuantItens,'@E 9999'),"Courier New",9,.T.,,"R",)
oprint:printdata(162,040, "Total.:" +TRAN(nTotPEDIDO,"@E 999,999.99") ,"Courier New",9,.T.,,"R",)
oprint:printdata(162,100, "Desconto.:" +TRAN(xdesconto,"@E 999,999.99"),"Courier New",9,.T.,,"R",)
oprint:printdata(162,160, "T O T A L  R$" +TRAN(nTotPEDIDO-xdesconto,"@E 999,999.99"),"Courier New",9,.T.,,"R",)

oprint:printroundrectangle(155,1,260,200,,0.50)
oprint:printdata(170,005, cRegiFant ,"Courier New",15,.T.,,"R",)
oprint:printdata(175,005, cRegiNome ,"Courier New",11,.T.,,"R",)
oprint:printdata(180,005, cRegiEnde + ", " + cRegiNume + " - " + cRegiBair + " - Fone:" + cRegiFone ,"Courier New",7,.T.,,"R",)
oprint:printdata(185,005, "Email " + cemail,"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(155,80,180,80,,0.20)
oprint:printdata(170,085, "CNPJ: " + cRegiCnpj ,"Courier New",10,.T.,,"R",)
oprint:printdata(175,085, "Inscr. Estadual: " + cRegiIEst ,"Courier New",9,.T.,,"R",)
oprint:printdata(180,085, "Municipio de " + cRegiCida ,"Courier New",10,.T.,,"R",)
oprint:printdata(185,085, "Cep.." + cRegiCEP  ,"Courier New",10,.T.,,"R",)

oprint:printroundrectangle(155,140,180,140,,0.20)
oprint:printdata(170,155, "DATA DE EMISSÃO: ","Courier New",10,.T.,,"R",)
oprint:printdata(175,155, DTOC( DATE()) ,"Courier New",10,.T.,,"R",)
oprint:printdata(185,155, "DUPLICATA" ,"Courier New",15,.T.,,"R",)
oprint:printroundrectangle(180,1,180,200,,0.20)
oprint:printroundrectangle(187,001,187,110,,0.10)
oprint:printdata(195,002, 'FATURA Nº' ,"Courier New",10,.T.,,"R",)
cNumeNota:=xNumeroOrc 
oprint:printdata(203,005, cNumeNota ,"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(180,30,200,30,,0.10)
nValoDupl:=nTotPEDIDO-xdesconto

oprint:printdata(195,036, 'VALOR R$',"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(180,55,200,55,,0.10)
oprint:printdata(203,33, TRANSFORM( nValoDupl, '@E 999,999.99' ) ,"Courier New",10,.T.,,"R",)

oprint:printdata(195,059, 'DUPLICATA Nº' ,"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(180,80,200,80,,0.10)
oprint:printdata(203,065, cNumeNota ,"Courier New",10,.T.,,"R",)

dDataVenc:=DATE()+20
oprint:printdata(195,90, 'VENCIMENTO',"Courier New",10,.T.,,"R",)
oprint:printroundrectangle(180,110,200,110,,0.10)
oprint:printdata(205,87, DTOC( dDataVenc ) ,"Courier New",13,.T.,,"R",)
oprint:printdata(195,120,'PARA USO DA INSTITUIÇÃO FINANCEIRA'  ,"Courier New",11,.T.,,"R",)

oprint:printroundrectangle(200,001,200,110,,0.30)
oprint:printroundrectangle(200,030,210,200,,0.30)
oprint:printroundrectangle(210,030,225,200,,0.30)
//////////////////////////////////////////////////////
         oprint:printroundrectangle(225,030,235,200,,0.30)
		 oprint:printdata(225,032, "Nome......:"  ,"Courier New",10,.T.,,"R",)     
         oprint:printdata(225,055, Substr(xnome,1,40)   ,"Courier New",10,.T.,,"R",)  
         oprint:printdata(228,032, "Endereco..:"                  ,"Courier New",10,.T.,,"R",)  
         oprint:printdata(228,055, TRAN(xende,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,032, "Cidade....:"                  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,055, TRAN(xcida,"@!")      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,100, "Praça de Pagamento VILHENA-RO"  ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,192, "Est.:"                      ,"Courier New",10,.T.,,"R",)
         oprint:printdata(232,203, tran(xuf,"!!")      ,"Courier New",10,.T.,,"R",)
  IF xCL_PESSOA='J'                     
       oprint:printdata(236,032,'Cnpj......:'                     ,"Courier New",10,.T.,,"R",)
       oprint:printdata(236,055, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
   ENDI
   IF xCL_PESSOA='I'                         
       oprint:printdata(237,032,'Cnpj......:'                    ,"Courier New",10,.T.,,"R",)
       oprint:printdata(237,055, Trans(xCL_CGC,'@!')     +  '  IE...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
ENDI
 IF xCL_PESSOA='F'                       
           oprint:printdata(236,032,'Cpf.......:'                    ,"Courier New",10,.T.,,"R",)
           oprint:printdata(236,055, Trans(xCL_CGC,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
endif
IF xCL_PESSOA='P'                      
       oprint:printdata(236,032,'Cpf.......:'                      ,"Courier New",10,.T.,,"R",)
       oprint:printdata(236,055, Trans(xCL_CGC,'@!')     +  '  RG...: '+Trans(xRGIE,'@!')  ,"Courier New",10,.T.,,"R",)
	   endif
** 	oprint:printroundrectangle(65,1,80,200,,0.5)
  /////////////////////////////////////////////////

oprint:printroundrectangle(225,030,235,030,,0.30)
oprint:printroundrectangle(235,001,235,030,,0.30)
oprint:printroundrectangle(225,070,235,030,,0.30)
oprint:printdata(245,032, 'Valor por extenso',"Courier New",10,.T.,,"R",)
oprint:printdata(245,075, Extenso(nValoDupl),"Courier New",9,.T.,,"R",)

oprint:printdata(253,032, 'Reconhecemos a exatidão desta Duplicata de Venda Mercantil, na importância acima que pagaremos a',"Courier New",8,.T.,,"R",)
oprint:printdata(257,032, cRegiNome + ', ou a sua ordem, na praça e vencimento indicados.' ,"Courier New",8,.T.,,"R",)
oprint:printdata(269,032, 'Em ____/____/_____' ,"Courier New",10,.T.,,"R",)
oprint:printdata(269,100, '_________________________' ,"Courier New",10,.T.,,"R",)

 
         oprint:endpage()
         oprint:enddoc()
         oprint:RELEASE()
Return Nil

/////////////////////////////////////////////////////////////////////

