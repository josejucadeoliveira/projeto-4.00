
#include "minigui.ch"

Procedure HB_Cria_Log(cString,atividade)
   Local cArq, nBin
   LOCAL PATHDADOS :=DiskName()+":\"+CurDir()+"\"
  * LOCAL nUser:=_codigo_usuario_
   If !File(PATHDADOS + [JUMBO.TXT])
      cArq:= fcreate(PATHDADOS + [JUMBO.TXT], 0)
      fwrite(cArq, [Arquivo de Controle do Sistema - JUMBO] + CRLF)
      fwrite(cArq, [Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario: ] + cString + [ Atividade: ] + atividade + CRLF)
      fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Else
      cArq:= fopen(PATHDADOS + [JUMBO.TXT], 2 + 64)
      fseek(cArq, -1, 2)
      nBin:= bin2i(freadstr(cArq, 1))
      If nBin == 26
         fseek(cArq, -1, 2)
      Endif
      fwrite(cArq,[Data: ] + dtoc(date()) + [  Horas: ] + time() + [ Usuario:] + cString + [ Atividade: ] + atividade + CRLF)
      fwrite(cArq, repl([-], 70) + CRLF)
      fclose(cArq)
   Endif

   If !File(PATHDADOS + [JUMBONEW_ACESSO.INI])
      Cria_File_Ini(PATHDADOS + [JUMBONEW_ACESSO.INI])
   Else
     BEGIN INI FILE PATHDADOS + [JUMBONEW_ACESSO.INI]
     SET SECTION [Segurança] ENTRY [Data Último Acesso] To DtoC(Date())
     SET SECTION [Segurança] ENTRY [Hora Último Acesso] To Time()
     SET SECTION [Segurança] ENTRY [Usuário]            To strzero(nUser, 8)
      END INI    
   Endif
Return (Nil)