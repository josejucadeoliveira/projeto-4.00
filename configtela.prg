//--------------------------------------------------------------------------.
// Arquivo....: config tela-----------------------------------------------.
// Funcao.....: Controle de ORCAMENTs -----------------------------------------.
// Programador: jose juca ----------------------------------.
// Empresa....: Suporte Sistemas --------------------------------------------.
// Data.......: 05/06/2017  MYSQL NATIVA-------------------------------------.
// --------------------------------------------------------------------------.
#INCLUDE "INKEY.CH"
#INCLUDE "MINIGUI.CH"
#include 'i_textbtn.ch'
#define NTrim( n ) LTRIM( STR( n, IF( n == INT( n ), 0, 2 ) ) )
#include 'i_textbtn.ch'
#INCLUDE "INKEY.CH"
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte 
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 183,255,255 )
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define clrNormal   {168,255,190}
#define clrBack     {255,255,128}
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 128, 128, 192)
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define CLR_VERMELHO2 {255,140, 140} //vermelho forte 
#define CLR_PINK   RGB( 255, 128, 128)
#define CLR_NBLUE  RGB( 183,255,255 )
#define CLR_NBROWN  RGB( 130, 99, 53)
#define CLR_1 RGB( 190, 215, 190 )
#define CLR_2 RGB( 230, 230, 230 )
#define CLR_3 RGB( 217, 217, 255 )
#define clrNormal   {168,255,190}
#define clrBack     {255,255,128}
//--------------------------------------
Function configtela()
//--------------------------------------


terminal:= GetComputerName()

	WD:=GetDesktopWidth()
HD:=GetDesktopHeight()

   
 if  wd=1024 .and. hd=768
     nLarguraTela:=0
     nAlturaTela :=0
     fator       :=0
 elseif  wd=1152 .and. hd=864
     nLarguraTela:=120
     nAlturaTela:=100
	fator:=90
 elseif  wd=1280 .and. hd=720
     nLarguraTela:=256
     nAlturaTela:=0
	 fator:=160
 elseif  wd=1280 .and. hd=768
     nLarguraTela:=256
     nAlturaTela:=0
     fator:=190

 elseif  wd=1280 .and. hd=800
     nLarguraTela:=256
     nAlturaTela:=20
     fator:=190

 elseif  wd=1280 .and. hd=960
     nLarguraTela:=256
     nAlturaTela:=170
     fator:=190

 elseif  wd=1280 .and. hd=1024
     nLarguraTela:=256
     nAlturaTela:=250
	 fator:=190
 elseif  wd=1360 .and. hd=768
     nLarguraTela:=336
     nAlturaTela:=0
     fator:=270

 elseif  wd=1366 .and. hd=768
     nLarguraTela:=336
     nAlturaTela:=0
     fator:=276

 elseif  wd=1400 .and. hd=1050
      nLarguraTela:=380
      nAlturaTela:=270
       fator:=284

 elseif  wd=1440 .and. hd=900
      nLarguraTela:=416
      nAlturaTela:=120
	       fator:=324

 elseif  wd=1600 .and. hd=900
     nLarguraTela:=580
     nAlturaTela:=120
      fator:=444
	  
 elseif  wd=1680 .and. hd=1050
     nLarguraTela:=640
     nAlturaTela:=270
     fator:=464

 elseif  wd=1920 .and. hd=1080
     nLarguraTela:=900
    nAlturaTela:=280
     fator:=784
 else
    nLarguraTela:=0
    nAlturaTela:=0
	fator:=00
 end
 	 
  
xwd       :=wd
xhd       :=hd
xxterminal :=terminal
xterminal:= ' "'+Upper(AllTrim(terminal))+'" '      

/**
	If ! File("NFCE.INI")
	   MsgStop("Arquivo NFCE.INI não encontrado!!" )
	   ExitProcess(0)
	EndIf
	
       BEGIN INI FILE "NFCE.INI"       
		SET SECTION "TELA"  ENTRY "wd"                To xwd
		SET SECTION "TELA"  ENTRY "hd"                To xhd
		SET SECTION "TELA"  ENTRY "nLarguraTela"      To nLarguraTela
		SET SECTION "TELA"  ENTRY "nAlturaTela"       To nAlturaTela
        SET SECTION "TELA"  ENTRY "terminal"          To xxterminal
		
     END INI
	Return Nil
	*/
	



/*
 
oQuery  :=oServer:Query( "SELECT wd ,hd  FROM configtela WHERE terminal= "+xterminal+" and wd = "+ntrim(xwd)+" and  hd = "+ntrim(xhd)+" " )
If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro ")
    Return Nil
  Endif
  oRow	  := oQuery:GetRow(1)
  ncodigo  :=oRow:fieldGet(1)
	 

if ncodigo >0
cQuery := "UPDATE configtela SET wd  = '"+ntrim(xwd)+"',HD='"+ntrim(xhd)+"',nLarguraTela='"+ntrim(nLarguraTela)+"', nAlturaTela ='"+ntrim(nAlturaTela)+"' WHERE TERMINAL = "+xterminal+"  "
 oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()
  	MsgStop(oQuery:Error())
    MsgInfo("Por Favor Selecione o registro SS 4732 PROPLEMA")
    Return Nil
    ELSE
*MSGINFO("OK")
  Endif
ENDIF


if ncodigo =0
cQuery := "INSERT INTO configtela (wd,hd,nLarguraTela,nAlturaTela,terminal)  VALUES ( '"+ntrim(xwd)+"' , '"+ntrim(xhd)+ "' , '"+ntrim(nLarguraTela)+ "', '"+ntrim(nAlturaTela)+ "','"+xxterminal+"')"
 oQuery:=oServer:Query( cQuery )
 If oQuery:NetErr()												
 MsgInfo("SQL SELECT error: " + oQuery:Error())
 Return Nil
 else
 *MSGINFO("OKinc ")
EndIf
endif
oQuery:Destroy()
return

*/








 
 /*
 
este são os labels
     DEFINE LABEL lbl_DESCRICAO
            ROW    10
            COL    10
            WIDTH  996 +nLarguraTela
            HEIGHT 65
            FONTNAME "Times New Roman"
            FONTSIZE 39
            FONTBOLD .T.
            FONTCOLOR {128,0,0}
            BACKCOLOR {0,255,255}
            BORDER .T.
            CENTERALIGN .T.
     VALUE "" 
     END LABEL  
 

     DEFINE FRAME Frame_1
            ROW    390
            COL    10
            WIDTH  995+nLarguraTela
            HEIGHT 47
            OPAQUE .T.
     END FRAME
     DEFINE IMAGE Image_1
            ROW    440
            COL    10
            WIDTH  433 +nLarguraTela
            HEIGHT 190 +nAlturaTela
            PICTURE  "LOGOEMPRESA.BMP"
     END IMAGE  

     DEFINE BUTTONEX ButtonEX_1
            ROW    640 +nAlturaTela
            COL    10
            WIDTH  180
            HEIGHT 55
            CAPTION "Esc-&Sair"
            Action  Sair_Cupom() 
            FONTNAME "Arial Baltic"
            FONTSIZE 12
            FONTBOLD .T.
     END BUTTONEX
	 */
	 
	 