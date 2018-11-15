
#include "minigui.ch"
#include "miniprint.ch"

FIELD fname, lname, addr1, addr2, addr3

function IMPRESSORA()


close all
abreimpressora()

CLOSE ALL
USE ((ondetemp)+"printer.DBF") new alias printer exclusive  VIA "DBFCDX" 
zap
close all

   
   
set date british
set century on
set epoch to 2010

abreimpressora()

DEFINE WINDOW winMain;
 AT 200 , 300 ;
 WIDTH 400;
 HEIGHT 300 ;
 TITLE "Configura Impressora";
 MODAL NOSIZE  FONT "Arial Baltic" SIZE 10 
	
	  
      DEFINE MAIN MENU
         POPUP "Escolher Impressora"
            Item "Escolha" action PrintList()
            Item "E&xit" action thiswindow.release()
         END POPUP
      END MENU   
      
   END WINDOW

   winMain.center
   winMain.activate

return nil


function PrintList()

#include "winprint.ch"
#include <minigui.ch>
Local mPageNo, mLineNo, mPrinter
Private oSay1, oGet1, oSay2, oGet2, oBut1, oBut2

cGet1 := Space( 10 )
cGet2 := Space( 10 )
mPrinter := GetPrinter()


DEFINE WINDOW oForm2 AT 157 , 280 ;
WIDTH 640;
HEIGHT 250;
 TITLE "Configura Sistema";
 MODAL NOSIZE;
 FONT "Arial Baltic" SIZE 10 



   
   @ 017, 035   LABEL oSay1 ;
   WIDTH 109 ;
   HEIGHT 016 ;
   VALUE "55-NFE/65-FNC-E"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   
         @ 15,170 textbox oGet1;
                   width 080;
                   value 55;
                   HEIGHT 20;
                   numeric inputmask '999999'		   


   @ 053, 037   LABEL oSay2 ;
   WIDTH 109 ;
   HEIGHT 016 ;
   VALUE "Nome Impressora"  ;
   FONT "Ms Sans Serif" SIZE 9.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 052, 169   TEXTBOX oGet2 ;
   WIDTH 361 HEIGHT         20 ;
   VALUE mPrinter ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }

   @ 190, 160   BUTTON oBut1 ;
   CAPTION "Gravar"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
   action grava_impressora()
  

   @ 190, 412   BUTTON oBut2 ;
   CAPTION "Voltar"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
   action thiswindow.release()


END WINDOW
ACTIVATE WINDOW oForm2

return nil




function grava_impressora()  


   		               printer->(dbappend())
                       printer->NOME      :=oForm2.oGet2.value
			           printer->codigo    :=oForm2.oGet1.value
			           printer->(dbcommit())
                       printer->(dbunlock())
return nil
					 