#Include "Minigui.ch"
//-----------------------------------------------------------------------
Function confirguaracao_Email()


local oSay1, oGet1, oSay2, oGet2, oSay3, oGet3, oSay4, oGet4, oSay5, oRad1, oBut1, oBut2,SSERVIDOR,SEMAIL,SUSUARIO,SSSL,STLS,SPORTA, Ssenha

cGet1 := Space( 10 )
cGet2 := Space( 10 )
cGet3 := Space( 10 )
cGet4 := Space( 10 )
nRad1 := 1
nRad2 := 1

Define WINDOW Email ;
       AT 155, 343 ;
       WIDTH 535 ;
       HEIGHT 443 ;
       TITLE "Email" ;
       BACKCOLOR { 240, 240, 000 }
	   
	   *ON INIT {||Cria_EMAIL_Ini()}
	
	 ON KEY ESCAPE  OF Email ACTION { ||Email.RELEASE } 


BEGIN INI FILE "EMAIL.INI"
	 GET Semail          SECTION  "EMAIL"           ENTRY "EMAIL"
     GET Sservidor       SECTION  "SERVIDORSMTP"    ENTRY "SERVIDORSMTP" 
  	 GET sporta          SECTION  "PORTA"           ENTRY "PORTA"
     GET susuario        SECTION "USUARIO"          ENTRY "USUARIO"
     GET sssl            SECTION "SSL"              ENTRY "SSL"
  	 GET sTLS            SECTION "TLS"              ENTRY "TLS"
 END INI
	 
 
   @ 020, 020   LABEL oSay1 ;
   WIDTH 051 ;
   HEIGHT 20 ;
   VALUE "Email"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 020, 160   TEXTBOX email;
   WIDTH 288 HEIGHT         20 ;
   VALUE Semail ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }
   

    @ 055, 020   LABEL oSay25 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Usuario"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 55, 160  TEXTBOX usuario ;
   WIDTH 282 HEIGHT         20 ;
   VALUE Susuario ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }


   @ 080, 020   LABEL oSay2 ;
   WIDTH 051 ;
   HEIGHT 016 ;
   VALUE "Servidor Smtp"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 80, 160  TEXTBOX servidor ;
   WIDTH 282 HEIGHT         20 ;
   VALUE Sservidor ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }


   @ 120, 020   LABEL oSay3 ;
   WIDTH 056 ;
   HEIGHT 016 ;
   VALUE "Senha"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 100, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 120, 160   TEXTBOX senha;
   WIDTH 280 HEIGHT         20 ;
   VALUE ssenha;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }


   @ 160, 20   LABEL oSay4 ;
   WIDTH 040 ;
   HEIGHT 016 ;
   VALUE "Porta"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }


   @ 160, 160   TEXTBOX porta ;
   WIDTH 120 HEIGHT         20 ;
   VALUE sporta ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }


   @ 180, 20   LABEL oSay5 ;
   WIDTH 045 ;
   HEIGHT 016 ;
   VALUE "SSL"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }

/*
   @ 180, 160   RADIOGROUP oRadSSL ;
   OPTIONS { "SSL"} ;
   WIDTH 100 ;
   value sssl;
   SPACING 020 ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
*/


 @180, 160   TEXTBOX oRadSSL ;
   WIDTH 50 HEIGHT         20 ;
   VALUE SSSL;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }

   
   
   
   @ 200, 20   LABEL oSay52 ;
   WIDTH 045 ;
   HEIGHT 016 ;
   VALUE "TLS"  ;
   FONT "Ms Sans Serif" SIZE 10.00 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 240, 240, 240 }
 

 @ 200, 160   TEXTBOX oRadTLS ;
   WIDTH 50 HEIGHT         20 ;
   VALUE sTLS ;
   FONT "Ms Sans Serif" SIZE 009 ;
   FONTCOLOR { 000, 000, 000 };
   BACKCOLOR { 255, 255, 255 }

   
   

   @ 324, 039   BUTTON oButEMAIL1 ;
   CAPTION "Confirma"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
   ACTION {||Gravar_EMAIL()}


   @ 321, 375   BUTTON oButEMAIL2 ;
   CAPTION "Sair"  ;
   WIDTH 070 HEIGHT 024 ;
   FONT "Ms Sans Serif" SIZE 009;
   ACTION { ||EMAIL.release }
	    

END WINDOW
ACTIVATE WINDOW Email

Return NIL

Function Gravar_EMAIL()

  BEGIN INI FILE "EMAIL.INI"
		SET SECTION "EMAIL"          ENTRY "EMAIL"          To Email.email.VALUE
		SET SECTION "SERVIDORSMTP"   ENTRY "SERVIDORSMTP"   To Email.SERVIDOR.VALUE
		SET SECTION "USUARIO"        ENTRY "USUARIO"        To Email.USUARIO.VALUE
		SET SECTION "PORTA"          ENTRY "PORTA"          To Email.PORTA.VALUE
      	SET SECTION "SSL"            ENTRY "SSL"            To Email.oRadSSL.VALUE
    	SET SECTION "TLS"            ENTRY "TLS"            To Email.oRadTLS.VALUE
    	SET SECTION "SENHA"          ENTRY "SENHA"          To Email.SENHA.VALUE
	END INI	
EMAIL.release	
Return NIL



Function Cria_EMAIL_Ini()
If ! File("EMAIL.INI")
	    BEGIN INI FILE "EMAIL.INI"
	  	SET SECTION "EMAIL"        ENTRY "EMAIL"                       To 'nfemedial@gmail.com'
	  	SET SECTION "SERVIDORSMTP" ENTRY "SERVIDORSMTP"                To 'smtp.gmail.com'
	  	SET SECTION "USUARIO"      ENTRY "USUARIO"                     To 'nfemedial'
	  	SET SECTION "PORTA"        ENTRY "PORTA"                       To '465'
     	SET SECTION "SSL"          ENTRY "SSL"                         To 'SIM'
    	SET SECTION "TLS"          ENTRY "TLS"                         To ''
	END INI				
	EndIf
Return Nil
