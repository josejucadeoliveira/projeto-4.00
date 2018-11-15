#include <minigui.ch>         
#include <miniprint.ch>
#include <common.ch>
//////////////////////////
FUNCTION jj_boleto()
//////////////////////////
REQUEST HB_LANG_PT    

REQUEST DBFCDX
REQUEST DBFFPT 
RDDSETDEFAULT("DBFCDX")
//SET ERRORLOG TO ('minibol.htm')  
//SET LOGERROR ON

SET DELETED on                                                                  
SET SOFTSEEK on
set cent on   
SET EPOCH TO 1990   
SET DATE BRIT    
                                                   
SET MULTIPLE OFF WARNING 
HB_LANGSELECT("PT") 

PUBL root:= GetStartUpFolder()+'\' 
PUBL iniFile_c:=.t. 

PUBL dirstart:=root 
PUBL dirdbf:=root 
PUBL dircrm:=root 
PUBL dirpdf:=root
PUBL dirhtml:=root
PUBL dirRemessa:= root
 
 
 
PUBL printpdf:=GetDefaultPrinter()    //  Free PrimoPdf como virtual printer para criar arquivos PDF    www.primopdf.com  
PUBL printdpx:=GetDefaultPrinter() 
PUBL printmtx:=GetDefaultPrinter() 
PUBL printfax:=GetDefaultPrinter() 
PUBL printLaser:=GetDefaultPrinter() 
PUBL printX:=GetDefaultPrinter()
PUBL printPV:=.t.
*msginfo(printX)
*msginfo(printpdf)

usuario:='MINIBOL' 
logo:='jpghh' 

//////////   controles  de acesso   H  
cXcadastro:=.T.   
cXcadastro_a:=.T.  
cXcadastro_x:=.T.  
cXativo:=.T.  
cXativo_a:=.T.  
cXativo_x:=.T.  
cXestoque:=.T.  
cXestoque_a:=.T.  
cXestoque_x:=.T.  
cXtabvd:=.T.  
cXtabvd_a:=.T.  
cXtabvd_x:=.T.  
cXlembrete:=.T.  
cXconfig:=.T.  
cXusuarios:=.T.   
cXserasa:=.T. 
cXserasaFull:=.T. 
cXcrm:=.T.  
cXcrm_a:=.T.  
cXcrm_x:=.T.  
cXcontrato:=.T.  
cXcontrato_a:=.T.  
cXcontrato_x:=.T.  
cXrrm:=.T.  
cXrrm_a:=.T.  
cXrrm_x:=.T.  
cXpedvd:=.T.  
cXpedvd_a:=.T.  
cXpedvd_x:=.T.  
cXpedcp:=.T.  
cXpedcp_a:=.T.  
cXpedcp_x:=.T.  
cXauxoper:=.T.  
cXnfvd:=.T.  
cXnfvd_a:=.T.  
cXnfvd_x:=.T.  
cXnfs:=.T.  
cXnfs_a:=.T.  
cXnfs_x:=.T.  
cXrecloc:=.T.  
cXrecloc_a:=.T.  
cXrecloc_x:=.T.  
cXnfes:=.T.  
cXnfes_a:=.T.  
cXnfes_x:=.T.  
cXboleto:=.T.  
cXboleto_a:=.T.  
cXboleto_x:=.T.  
cXreceber:=.T.  
cXreceber_a:=.T.  
cXreceber_x:=.T.  
cXpagar:=.T.  
cXpagar_a:=.T.  
cXpagar_x:=.T.  
cXextrato:=.T.  
cXfluxo:=.T.  
cXauxnatop:=.T.  
cXauxcf:=.T.  
cXauxsitt:=.T.  
cXauxbanco:=.T.  
cXauxboleto:=.T.  
cXauxplano:=.T.  
cXauxpagar:=.T.  
cXauxstatus:=.T.  
 

 

IF ISWINDOWACTIVE(wMinibol)   
   RETURN 
ENDIF


 	DEFINE WINDOW wMinibol ;
	        at 000,000; 
            width Ajanela; 
             height Ljanela-40;
       		TITLE "BOLETOS SICOOB 756"  ;
            MODAL;
         	NOSIZE
			
 
 ON KEY ESCAPE ACTION ThisWindow.release //tecla ESC para fechar a janela


       define splitbox
       define toolbar tb_receber of wMinibol buttonsize 110,50 flat
       button btn_01;
              caption 'Boleto Da Nfce ';
			  ACTION ( j_boleto() );   
              picture cPathImagem+'incluir.bmp';
              adjust;
              tooltip 'Incluir uma informação nesta tabela';
              separator
         
       button btn_02;
              caption 'Boleto Livre';
              picture cPathImagem+'alterar.bmp';
              adjust;
			  ACTION ( jL_boleto() );   
              tooltip 'Alterar a informação selecionada (duplo-clique)';
              separator

       button btn_03;
              caption 'Consultas';
              picture cPathImagem+'excluir.bmp';
              adjust;
			  ACTION (Consulta_boleto() );   
              tooltip 'Consulta as informações selecionada';
              separator

       button btn_04;
              caption 'Relação';
              picture cPathImagem+'imprimir.bmp';
              adjust;
              tooltip 'Imprimir relação das informações cadastradas nesta tabela';
             separator

       button btn_05;
              caption 'Atualizar';
              picture cPathImagem+'atualizar.bmp';
              adjust;
              tooltip 'Procurar automaticamente novas informações no banco de dados';
              separator

       button btn_06;
              caption 'Voltar';
              picture cPathImagem+'voltar.bmp';
              adjust;
              action wMinibol.release;
              tooltip 'Voltar para a tela anterior';
 	      separator
       end toolbar
       end splitbox
	   
    
	
END WINDOW
ACTIVATE WINDOW wMinibol
return nil


FUNCTION  minibol_init
//IF !file('conta.cdx')    ; indexconta() ; ENDIF  
//IF !file('receber.cdx')    ; indexreceber() ; ENDIF 
IF !file('boleto.cdx')    ; indexboleto() ; ENDIF 

//USE conta INDEX conta SHARED NEW 
USE boleto INDEX boleto SHARED NEW 
//USE receber INDEX receber SHARED NEW
//USE padroes SHARED NEW 
//USE config SHARED NEW 

RETURN 



FUNCTION indexreceber()   
wminibol.statusbar.item(1):='>> receber'      //1 
USE receber
PACK
INDEX on numero TAG numero TO receber        
//wminibol.statusbar.item(1):='>> receber / apelido '               //2 
INDEX on apelido+DTOS(vcto) TAG apelido TO receber 
//wminibol.statusbar.item(1):='>> receber / ncliente'                  //3 
INDEX on clinumero TAG clinumero TO receber  //+vc
//wminibol.statusbar.item(1):='>> receber / aberto'                       //4 
INDEX on vcto TAG vcto FOR EMPTY(liquida) TO receber  
//wminibol.statusbar.item(1):='>> receber / recebido'                        //5 
INDEX on liquida TAG liquida FOR !EMPTY(liquida) TO receber  
//wminibol.statusbar.item(1):='>> receber / emissao'                            //6 
INDEX on DTOS(emissao) TAG emissao  TO receber 
//wminibol.statusbar.item(1):='>> receber / pedido'                                //7 
INDEX on npedido TAG npedido TO receber    //  7
USE 
RETURN nil 

FUNCTION indexboleto()    
//wminibol.statusbar.item(1):='>> boleto'    //1
USE boleto 
PACK
INDEX on numero TAG numero To boleto 
//wminibol.statusbar.item(1):='>> boleto / apelido'   //2
INDEX on nome TAG nome To boleto 
//wminibol.statusbar.item(1):='>> boleto / controle'  //3
INDEX on controle TAG controle To boleto  
//wminibol.statusbar.item(1):='>> boleto / arquivo'  //4 
INDEX on arqremessa TAG arquivo To boleto  
USE 
RETURN nil 

 
FUNCTION indexconta() 
//wminibol.statusbar.item(1):='>> conta bancária'
USE conta
PACK
INDEX on nconta TAG conta TO conta
USE
RETURN nil       
 