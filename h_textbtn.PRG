/*
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/
*/

#include "minigui.ch"
#include "common.ch"
*________________________________________________________________________________________________
function _DefineTextBtn( cControlName, cParentForm, nx, ny, nWidth, nHeight, ;
                        cValue, cFontName, nFontSize, cToolTip, nMaxLenght, ;
			lUpper, lLower, lNumeric, lPassword, ;
                        uLostFocus, uGotFocus, uChange , uEnter , right  , ;
			HelpId , readonly , bold, italic, underline, ;
			strikeout , field , backcolor , fontcolor , ;
			invisible , notabstop,action, image )

	local nParentForm := 0
	local nControlHandle := 0
	local mVar
	Local FontHandle
	Local WorkArea
	Local k

	// Asign STANDARD values to optional params.
	DEFAULT nWidth     TO 120
	DEFAULT nHeight    TO 24
	DEFAULT cValue     TO ""
	DEFAULT uChange    TO ""
	DEFAULT uGotFocus  TO ""
	DEFAULT uLostFocus TO ""
	DEFAULT nMaxLenght TO 255
	DEFAULT lUpper     TO .f.
	DEFAULT lLower     TO .f.
	DEFAULT lNumeric   TO .f.
	DEFAULT lPassword  TO .f.
	DEFAULT uEnter     TO ""

	If ValType ( Field ) != 'U'
		if  at ( '>', Field ) == 0
			MsgMiniGuiError ("Control: " + cControlName + " Of " + cParentForm + " : You must specify a fully qualified field name. Program Terminated")
		Else
			WorkArea := Left ( Field , at ( '>', Field ) - 2 )
			If Select (WorkArea) != 0
				cValue := &(Field)
			EndIf
		EndIf
	EndIf

	if _HMG_BeginWindowActive = .T.
		cParentForm := _HMG_ActiveFormName
		if .Not. Empty (_HMG_ActiveFontName) .And. ValType(cFontName) == "U"
			cFontName := _HMG_ActiveFontName
		EndIf
		if .Not. Empty (_HMG_ActiveFontSize) .And. ValType(nFontSize) == "U"
			nFontSize := _HMG_ActiveFontSize
		EndIf
	endif

	if _HMG_FrameLevel > 0
		nx 	:= nx + _HMG_ActiveFrameCol [_HMG_FrameLevel]
		ny 	:= ny + _HMG_ActiveFrameRow [_HMG_FrameLevel]
		cParentForm := _HMG_ActiveFrameParentFormName [_HMG_FrameLevel]
	EndIf

	nParentForm  := GetFormHandle( cParentForm )

	// Check if the window/form is defined.
	if ( .not. _IsWindowDefined( cParentForm ) )
		MsgMiniGuiError( "Window: " + cParentForm + " is not defined. Program terminated." )
		ExitProcess( 0 )
		return Nil
	endif

	// Check if the control is already defined.
	if ( _IsControlDefined( cControlName, cParentForm ) )
		MsgMiniGuiError( "Control: " + cControlName + " of " + cParentForm + " already defined. Program Terminated." )
		ExitProcess( 0 )
		Return Nil
	endif

	mVar := '_' + cParentForm + '_' + cControlName

	// Creates the control window.
	nControlHandle := InitTextBox( nParentForm, 0, nx, ny, nWidth, nHeight, '', 0, nMaxLenght, ;
                                 lUpper, lLower, .f., lPassword , right , readonly , invisible , notabstop )

	if valtype(cfontname) != "U" .and. valtype(nfontsize) != "U"
		FontHandle := _SetFont (nControlHandle,cFontName,nFontSize,bold,italic,underline,strikeout)
	Else
		FontHandle := _SetFont (nControlHandle,_HMG_DefaultFontName,_HMG_DefaultFontSize,bold,italic,underline,strikeout)
	endif

	If _HMG_BeginTabActive = .T.
		aAdd ( _HMG_ActiveTabCurrentPageMap , nControlHandle )
	EndIf

	// Add a tooltip if param has value.
	if ( ValType( cToolTip ) != "U" )
		SetToolTip( nControlHandle, cToolTip, GetFormToolTipHandle( cParentForm ) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_aControlType [k] := if( lNumeric, "NUMTEXT", "TEXT" )
	_HMG_aControlNames  [k] :=  cControlName
	_HMG_aControlHandles  [k] :=  nControlHandle
	_HMG_aControlParenthandles  [k] :=  nParentForm
	_HMG_aControlIds  [k] :=  0
	_HMG_aControlProcedures  [k] :=  ""
	_HMG_aControlPageMap  [k] :=  Field
	_HMG_aControlValue  [k] :=  nil
	_HMG_aControlInputMask  [k] :=  ""
	_HMG_aControlLostFocusProcedure [k] :=   uLostFocus
	_HMG_aControlGotFocusProcedure  [k] := uGotFocus
	_HMG_aControlChangeProcedure  [k] :=  uChange
	_HMG_aControlDeleted  [k] :=  .F.
	_HMG_aControlBkColor  [k] :=  backcolor
	_HMG_aControlFontColor [k] :=   fontcolor
	_HMG_aControlDblClick  [k] :=  uEnter
	_HMG_aControlHeadClick  [k] :=  {}
	_HMG_aControlRow  [k] :=  ny
	_HMG_aControlCol  [k] :=  nx
	_HMG_aControlWidth   [k] := nwidth
	_HMG_aControlHeight   [k] := nheight
	_HMG_aControlSpacing  [k] :=  0
	_HMG_aControlContainerRow  [k] :=  iif ( _HMG_FrameLevel > 0 ,_HMG_ActiveFrameRow [_HMG_FrameLevel] , -1 )
	_HMG_aControlContainerCol  [k] :=  iif ( _HMG_FrameLevel > 0 ,_HMG_ActiveFrameCol [_HMG_FrameLevel] , -1 )
	_HMG_aControlPicture  [k] :=  ""
	_HMG_aControlContainerHandle  [k] :=  0
	_HMG_aControlFontName  [k] :=  cfontname
	_HMG_aControlFontSize  [k] :=  nfontsize
	_HMG_aControlFontAttributes  [k] :=  {bold,italic,underline,strikeout}
	_HMG_aControlToolTip  [k] :=   ctooltip
	_HMG_aControlRangeMin  [k] :=   0
	_HMG_aControlRangeMax  [k] :=   0
	_HMG_aControlCaption  [k] :=   ''
	_HMG_aControlVisible  [k] :=  .Not.  invisible
	_HMG_aControlHelpId  [k] :=   HelpId
	_HMG_aControlFontHandle  [k] :=   FontHandle
	_HMG_aControlBrushHandle  [k] :=   0
	_HMG_aControlEnabled  [k] :=   .T.
	_HMG_aControlMiscData1 [k] := 0

	// With NUMERIC clause, transform numeric value into a string.
	if ( lNumeric )
		If Valtype(cValue) != 'C'
			cValue := AllTrim( Str( cValue ) )
		EndIf
	EndIf

	// Fill the TEXTBOX with the text given.
	if ( Len( cValue ) > 0 )
		SetWindowText ( nControlHandle , cValue )
	endif

	if valtype ( Field ) != 'U'
		aAdd ( _HMG_aFormBrowseList	[ GetFormIndex ( cParentForm ) ] , k )
	EndIf

	_DefineButton ( "BTN"+cControlName, cParentForm, nx, ny, 'x', ;
                       action, nHeight, nHeight, cfontname, nfontsize, 'x', ;
                       ugotfocus, ulostfocus, , , ,.T. , bold, italic,;
                       underline, strikeout, )

	InsertButton(GetControlHandle(cControlName,cParentForm), GetControlHandle ("BTN"+cControlName,cParentForm), image)

return nil
*________________________________________________________________________________________________
Function _DefineMaskedTextbtn ( ControlName, ParentForm, x, y, inputmask , width , value , fontname, fontsize , tooltip , lostfocus ,gotfocus , change , height , enter , rightalign  , HelpId , Format , bold, italic, underline, strikeout , field  , backcolor , fontcolor , readonly  , invisible , notabstop,action  )

Local i, cParentForm ,c,mVar , WorkArea , k := 0
Local ControlHandle , FontHandle

* Unused Parameters
RightAlign := NIL
*

	If ValType ( Field ) != 'U'
		if  at ( '>', Field ) == 0
			MsgMiniGuiError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
		Else
			WorkArea := Left ( Field , at ( '>', Field ) - 2 )
			If Select (WorkArea) != 0
				Value := &(Field)
			EndIf
		EndIf
	EndIf

	if valtype(Format) == "U"
		Format := ""
	endif

	For i := 1 To Len (InputMask)

		c := SubStr ( InputMask , i , 1 )

        	if c!='9' .and.  c!='$' .and. c!='*' .and. c!='.' .and. c!= ','  .and. c != ' ' .and. c!='€'
			MsgMiniGuiError("@...TEXTBOX: Wrong InputMask Definition" )
			ExitProcess(0)
			Return Nil
		EndIf

	Next i

	For i := 1 To Len (Format)

		c := SubStr ( Format , i , 1 )

        	if c!='C' .and. c!='X' .and. c!= '('  .and. c!= 'E'
			MsgMiniGuiError("@...TEXTBOX: Wrong Format Definition" )
			ExitProcess(0)
			Return Nil
		EndIf

	Next i

	If ValType ( Field ) != 'U'
		Value := &(Field)
	EndIf

	if valtype(change) == "U"
		change := ""
	endif

	if valtype(gotfocus) == "U"
		gotfocus := ""
	endif

	if valtype(enter) == "U"
		enter := ""
	endif

	if valtype(lostfocus) == "U"
		lostfocus := ""
	endif

	if valtype(Width) == "U"
		Width := 120
	endif

	if valtype(height) == "U"
		height := 24
	endif

	if valtype(Value) == "U"
		Value := ""
	endif

	If .Not. Empty (Format)
		Format := '@' + AllTrim(Format)
	EndIf

	InputMask :=  Format + ' ' + InputMask

	Value := Transform ( value , InputMask )

	if _HMG_BeginWindowActive = .T.
		ParentForm := _HMG_ActiveFormName
		if .Not. Empty (_HMG_ActiveFontName) .And. ValType(FontName) == "U"
			FontName := _HMG_ActiveFontName
		EndIf
		if .Not. Empty (_HMG_ActiveFontSize) .And. ValType(FontSize) == "U"
			FontSize := _HMG_ActiveFontSize
		EndIf
	endif
	if _HMG_FrameLevel > 0
		x 	:= x + _HMG_ActiveFrameCol [_HMG_FrameLevel]
		y 	:= y + _HMG_ActiveFrameRow [_HMG_FrameLevel]
		ParentForm := _HMG_ActiveFrameParentFormName [_HMG_FrameLevel]
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgMiniGuiError("Window: "+ ParentForm + " is not defined. Program terminated" )
		ExitProcess(0)
		Return Nil
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgMiniGuiError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
		ExitProcess(0)
	        Return Nil
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	ControlHandle := InitMaskedTextBox ( ParentForm, 0, x, y, width , '' , 0  , 255 , .f. , .f. , height , .t. , readonly  , invisible , notabstop )
	if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
		FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
	Else
		FontHandle := _SetFont (ControlHandle,_HMG_DefaultFontName,_HMG_DefaultFontSize,bold,italic,underline,strikeout)
	endif

	If _HMG_BeginTabActive = .T.
		aAdd ( _HMG_ActiveTabCurrentPageMap , ControlHandle )
	EndIf

	if valtype(tooltip) != "U"
	        SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_aControlType [k] := "MASKEDTEXT"
	_HMG_aControlNames  [k] :=  ControlName
	_HMG_aControlHandles [k] :=   ControlHandle
	_HMG_aControlParenthandles [k] :=   ParentForm
	_HMG_aControlIds  [k] :=  0
	_HMG_aControlProcedures  [k] :=  ""
	_HMG_aControlPageMap [k] :=   InputMask
	_HMG_aControlValue  [k] :=  Nil
*	_HMG_aControlInputMask  [k] :=  GetNumMask ( InputMask )
	_HMG_aControllostFocusProcedure  [k] :=  lostfocus
	_HMG_aControlGotFocusProcedure  [k] :=  gotfocus
	_HMG_aControlChangeProcedure  [k] :=  Change
	_HMG_aControlDeleted  [k] :=  .F.
	_HMG_aControlBkColor  [k] :=  backcolor
	_HMG_aControlFontColor  [k] :=  fontcolor
	_HMG_aControlDblClick  [k] :=  enter
	_HMG_aControlHeadClick  [k] :=  Field
	_HMG_aControlRow  [k] :=  y
	_HMG_aControlCol  [k] :=  x
	_HMG_aControlWidth  [k] :=  width
	_HMG_aControlHeight  [k] :=  height
	_HMG_aControlSpacing  [k] :=  .F.
	_HMG_aControlContainerRow  [k] :=  iif ( _HMG_FrameLevel > 0 ,_HMG_ActiveFrameRow [_HMG_FrameLevel] , -1 )
	_HMG_aControlContainerCol  [k] :=  iif ( _HMG_FrameLevel > 0 ,_HMG_ActiveFrameCol [_HMG_FrameLevel] , -1 )
	_HMG_aControlPicture   [k] := ""
	_HMG_aControlContainerHandle  [k] :=  0
	_HMG_aControlFontName  [k] :=  fontname
	_HMG_aControlFontSize  [k] :=  fontsize
	_HMG_aControlFontAttributes  [k] :=  {bold,italic,underline,strikeout}
	_HMG_aControlToolTip   [k] :=  tooltip
	_HMG_aControlRangeMin  [k] :=   0
	_HMG_aControlRangeMax  [k] :=   0
	_HMG_aControlCaption  [k] :=   ''
	_HMG_aControlVisible  [k] :=  .Not.  invisible
	_HMG_aControlHelpId  [k] :=   HelpId
	_HMG_aControlFontHandle  [k] :=   FontHandle
	_HMG_aControlBrushHandle   [k] :=  0
	_HMG_aControlEnabled  [k] :=   .T.
	_HMG_aControlMiscData1 [k] := 0

	SetWindowText ( ControlHandle , value )

	if valtype ( Field ) != 'U'
		aAdd ( _HMG_aFormBrowseList	[ GetFormIndex ( cParentForm ) ] , k )
	EndIf

	_DefineButton ( "BTN"+ControlName, ParentForm, nx, ny, ' ', ;
                         action, nWidth, nHeight, cfontname, nfontsize, ' ', ;
                         ugotfocus, ulostfocus, , , ,.t. , bold, italic,;
                         underline, strikeout, )

	InsertButton(GetControlHandle(cControlName,cParentForm), GetControlHandle ("BTN"+cControlName,cParentForm), image)

Return Nil
*________________________________________________________________________________________________
Function _DefineCharMaskTextbtn ( ControlName, ParentForm, x, y, inputmask , width , value , fontname, fontsize , tooltip , lostfocus ,gotfocus , change , height , enter , rightalign  , HelpId , bold, italic, underline, strikeout , field  , backcolor , fontcolor , date , readonly  , invisible , notabstop,action  )

Local cParentForm, mVar, WorkArea , dateformat , k := 0
Local ControlHandle , FontHandle

	If ValType ( Field ) != 'U'
		if  at ( '>', Field ) == 0
			MsgMiniGuiError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
		Else
			WorkArea := Left ( Field , at ( '>', Field ) - 2 )
			If Select (WorkArea) != 0
				Value := &(Field)
			EndIf
		EndIf
	EndIf

	if valtype(date) == "U"
		date := .F.
	endif

	if valtype(change) == "U"
		change := ""
	endif

	if valtype(gotfocus) == "U"
		gotfocus := ""
	endif

	if valtype(enter) == "U"
		enter := ""
	endif

	if valtype(lostfocus) == "U"
		lostfocus := ""
	endif

	if valtype(Width) == "U"
		Width := 120
	endif

	if valtype(height) == "U"
		height := 24
	endif

	if valtype(Value) == "U"
		if date == .F.
			Value := ""
		else
			Value := ctod ('  /  /  ')
		endif
	endif

	dateformat := set ( _SET_DATEFORMAT )

	if date == .t.
		if lower ( left ( dateformat , 4 ) ) == "yyyy"

			if '/' $ dateformat
				Inputmask := '9999/99/99'
			Elseif '.' $ dateformat
				Inputmask := '9999.99.99'
			Elseif '-' $ dateformat
				Inputmask := '9999-99-99'
			EndIf

		elseif lower ( right ( dateformat , 4 ) ) == "yyyy"

			if '/' $ dateformat
				Inputmask := '99/99/9999'
			Elseif '.' $ dateformat
				Inputmask := '99.99.9999'
			Elseif '-' $ dateformat
				Inputmask := '99-99-9999'
			EndIf

		else

			if '/' $ dateformat
				Inputmask := '99/99/99'
			Elseif '.' $ dateformat
				Inputmask := '99.99.99'
			Elseif '-' $ dateformat
				Inputmask := '99-99-99'
			EndIf

		endif
	endif

	if _HMG_BeginWindowActive = .T.
		ParentForm := _HMG_ActiveFormName
		if .Not. Empty (_HMG_ActiveFontName) .And. ValType(FontName) == "U"
			FontName := _HMG_ActiveFontName
		EndIf
		if .Not. Empty (_HMG_ActiveFontSize) .And. ValType(FontSize) == "U"
			FontSize := _HMG_ActiveFontSize
		EndIf
	endif
	if _HMG_FrameLevel > 0
		x 	:= x + _HMG_ActiveFrameCol [_HMG_FrameLevel]
		y 	:= y + _HMG_ActiveFrameRow [_HMG_FrameLevel]
		ParentForm := _HMG_ActiveFrameParentFormName [_HMG_FrameLevel]
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgMiniGuiError("Window: "+ ParentForm + " is not defined. Program terminated" )
		ExitProcess(0)
		Return Nil
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgMiniGuiError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
		ExitProcess(0)
	        Return Nil
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	ControlHandle := InitCharMaskTextBox ( ParentForm, 0, x, y, width , '' , 0  , 255 , .f. , .f. , height , rightalign , readonly  , invisible , notabstop )
	if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
		FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
	Else
		FontHandle := _SetFont (ControlHandle,_HMG_DefaultFontName,_HMG_DefaultFontSize,bold,italic,underline,strikeout)
	endif

	If _HMG_BeginTabActive = .T.
		aAdd ( _HMG_ActiveTabCurrentPageMap , ControlHandle )
	EndIf

	if valtype(tooltip) != "U"
	        SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_aControlType [k] := "CHARMASKTEXT"
	_HMG_aControlNames [k] := ControlName
	_HMG_aControlHandles [k] := ControlHandle
	_HMG_aControlParenthandles [k] := ParentForm
	_HMG_aControlIds [k] := 0
	_HMG_aControlProcedures [k] := ""
	_HMG_aControlPageMap [k] := Field
	_HMG_aControlValue [k] := Nil
	_HMG_aControlInputMask [k] := InputMask
	_HMG_aControllostFocusProcedure [k] := lostfocus
	_HMG_aControlGotFocusProcedure [k] := gotfocus
	_HMG_aControlChangeProcedure [k] := Change
	_HMG_aControlDeleted [k] := .F.
	_HMG_aControlBkColor [k] := backcolor
	_HMG_aControlFontColor [k] := fontcolor
	_HMG_aControlDblClick [k] := enter
	_HMG_aControlHeadClick  [k] :=date
	_HMG_aControlRow [k] := y
	_HMG_aControlCol [k] := x
	_HMG_aControlWidth [k] := width
	_HMG_aControlHeight [k] := height
	_HMG_aControlSpacing [k] := 0
	_HMG_aControlContainerRow [k] := iif ( _HMG_FrameLevel > 0 ,_HMG_ActiveFrameRow [_HMG_FrameLevel] , -1 )
	_HMG_aControlContainerCol [k] := iif ( _HMG_FrameLevel > 0 ,_HMG_ActiveFrameCol [_HMG_FrameLevel] , -1 )
	_HMG_aControlPicture [k] := ""
	_HMG_aControlContainerHandle [k] := 0
	_HMG_aControlFontName [k] := fontname
	_HMG_aControlFontSize [k] := fontsize
	_HMG_aControlFontAttributes [k] := {bold,italic,underline,strikeout}
	_HMG_aControlToolTip  [k] := tooltip
	_HMG_aControlRangeMin [k] :=  0
	_HMG_aControlRangeMax [k] :=  0
	_HMG_aControlCaption [k] :=  ''
	_HMG_aControlVisible [k] := .Not.  invisible
	_HMG_aControlHelpId  [k] := HelpId
	_HMG_aControlFontHandle [k] :=  FontHandle
	_HMG_aControlBrushHandle  [k] := 0
	_HMG_aControlEnabled [k] :=  .T.
	_HMG_aControlMiscData1 [k] := 0

	if date == .F.
		SetWindowText ( ControlHandle , Value  )
	Else
		SetWindowText ( ControlHandle , dtoc ( Value ) )
	endif

	if valtype ( Field ) != 'U'
		aAdd ( _HMG_aFormBrowseList	[ GetFormIndex ( cParentForm ) ] , k )
	EndIf

	_DefineButton ( "BTN"+ControlName, ParentForm, nx, ny, ' ', ;
                         action, nWidth, nHeight, cfontname, nfontsize, ' ', ;
                         ugotfocus, ulostfocus, , , ,.t. , bold, italic,;
                         underline, strikeout, )

	InsertButton(GetControlHandle(cControlName,cParentForm),GetControlHandle ("BTN"+cControlName,cParentForm), image)

Return Nil
*________________________________________________________________________________________________
#pragma BEGINDUMP
#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbapiitm.h"

typedef struct
{
    HWND lbutt ;
    BOOL fButtonDown;    // is the button up/down?
    BOOL fMouseDown;     // is the mouse activating the button?
    BOOL fButtonActive;  // Status del Button
    WNDPROC oldproc;     // need to remember the old window procedure

    int  nButSize;	   // horizontal size of button

    // size of the current window borders.
    // given these, we know where to insert our button
    int cxLeftEdge, cxRightEdge;
    int cyTopEdge,  cyBottomEdge;
    HBITMAP hbmp;
} InsBut;

LRESULT CALLBACK InsButProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);

void GetButtonRect(InsBut *pbut, RECT *rect);
void DrawInsertedButton(HWND hwnd, InsBut *pbut, RECT *prect);

HB_FUNC (SETIMGLW)
{
    HWND hbutton = (HWND) hb_parnl(1);
    LVBKIMAGE plvbki={0};
	char *url= (char*)hb_parc(2);


    memset(&plvbki,0,sizeof(plvbki));
	plvbki.ulFlags=LVBKIF_SOURCE_URL | LVBKIF_STYLE_TILE ;
	plvbki.pszImage=url;
	plvbki.xOffsetPercent=0;
	plvbki.yOffsetPercent=0;
//    plvbki.cchImageMax = 10;
	OleInitialize(NULL);

	SendMessage(hbutton,LVM_SETTEXTBKCOLOR, 0, CLR_NONE);
														// Browse+
	SendMessage(hbutton,LVM_SETBKIMAGE,0,(LPARAM)(LPLVBKIMAGE)&plvbki);
}
HB_FUNC  (INSERTBUTTON)
{
    InsBut *pbut;
    HWND hwnd   = (HWND)hb_parnl(1);
    INT  nSize  = 18;
    HWND lbut   = (HWND)hb_parnl(2);
    HBITMAP himage;

    himage  = (HBITMAP)LoadImage(0,hb_parc(3),IMAGE_BITMAP ,0,0,LR_LOADFROMFILE | LR_LOADMAP3DCOLORS | LR_LOADTRANSPARENT );

    pbut = HeapAlloc(GetProcessHeap(), 0, sizeof(InsBut));

    if(pbut) {
       pbut->lbutt        = lbut;

       pbut->fButtonDown  = FALSE;
       pbut->fButtonActive  = FALSE;
	   pbut->nButSize     = nSize;
	   pbut->hbmp         = himage;

    // replace the old window procedure with our new one
       pbut->oldproc = (WNDPROC)SetWindowLong(hwnd, GWL_WNDPROC, (long)InsButProc);

    // associate our button state structure with the window
       SetWindowLong(hwnd, GWL_USERDATA, (long)pbut);

    // force the edit control to update its non-client area
       SetWindowPos(hwnd, 0, 0, 0, 0, 0, SWP_FRAMECHANGED|SWP_NOMOVE|SWP_NOSIZE|SWP_NOACTIVATE|SWP_NOZORDER);
    }

}

// retrieve the coordinates of an inserted button, given the
// specified window rectangle.

void GetButtonRect(InsBut *pbut, RECT *rect)
{
    rect->right  -= pbut->cxRightEdge;
    rect->top    += pbut->cyTopEdge;
    rect->bottom -= pbut->cyBottomEdge;
    rect->left    = rect->right - pbut->nButSize;

	if(pbut->cxRightEdge > pbut->cxLeftEdge)
		OffsetRect(rect, pbut->cxRightEdge - pbut->cxLeftEdge, 0);
}

void DrawInsertedButton(HWND hwnd, InsBut *pbut, RECT *prect)
{
	HDC hdc;
    HDC hdcmem = CreateCompatibleDC(0);
    HDC hold;
    RECT p1rect;

    p1rect = *prect;

    hold = (HDC)SelectObject(hdcmem, pbut->hbmp);

	hdc = GetWindowDC(hwnd);

	// now draw our inserted button:
	if(pbut->fButtonDown == TRUE)
	{
		// draw a 3d-edge around the button.
		DrawEdge(hdc, prect, EDGE_RAISED, BF_RECT | BF_FLAT | BF_ADJUST);

		// fill the inside of the button
		FillRect(hdc, prect, GetSysColorBrush(COLOR_BTNFACE));
		OffsetRect(prect, 1, 1);
        if(!hold){
 		  SetBkMode(hdc, TRANSPARENT);
		  DrawText(hdc, "...", 3, prect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
          }
        else{
          BitBlt(hdc,p1rect.left+3, p1rect.top+3, p1rect.left + 16, p1rect.top + 16, hdcmem, 0, 0 , SRCCOPY);
        }
//		DrawText(hdc, " ? ", 3, prect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
	}
	else
	{
		DrawEdge(hdc, prect, EDGE_RAISED, BF_RECT | BF_ADJUST);

		// fill the inside of the button
		FillRect(hdc, prect, GetSysColorBrush(COLOR_BTNFACE));
        if(!hold){
		  SetBkMode(hdc, TRANSPARENT);
		  DrawText(hdc, "...", 3, prect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
          }
        else{
          BitBlt(hdc,p1rect.left+2, p1rect.top+2, p1rect.left + 15, p1rect.top + 15, hdcmem, 0, 0 , SRCCOPY);
        }
//		DrawText(hdc, " ? ", 3, prect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
	}

	SelectObject(hdcmem, hold);
	DeleteDC(hdcmem);
	ReleaseDC(hwnd, hdc);
}

HB_FUNC ( CHANGETEXTBTNSTATE)
{
  InsBut *pbut;
  HWND hwnd   = (HWND)hb_parnl(1);
  BOOL lstate  ;
  lstate = hb_parni(2);
  pbut    = (InsBut *)GetWindowLong(hwnd, GWL_USERDATA);
  if(lstate){
     pbut->fButtonActive  = TRUE;
     }
  else {
     pbut->fButtonActive  = FALSE;
  }
}

LRESULT CALLBACK InsButProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	WNDPROC oldproc;
	RECT    rect, oldrect;
	RECT   *prect;
	InsBut *pbut;
	POINT   pt;
	BOOL	oldstate;

	pbut    = (InsBut *)GetWindowLong(hwnd, GWL_USERDATA);
	oldproc = pbut->oldproc;

	switch(msg)
	{
	case WM_NCDESTROY:
		HeapFree(GetProcessHeap(), 0, pbut);
		break;

	case WM_NCCALCSIZE:
		prect = (RECT *)lParam;
		oldrect = *prect;
		CallWindowProc(pbut->oldproc, hwnd, msg, wParam, lParam);
		// calculate el tamaño del borde de cada ventana
		// Para saber donde està el boton
		pbut->cxLeftEdge   = prect->left     - oldrect.left;
		pbut->cxRightEdge  = oldrect.right   - prect->right;
		pbut->cyTopEdge    = prect->top      - oldrect.top;
		pbut->cyBottomEdge = oldrect.bottom  - prect->bottom;
		prect->right -= pbut->nButSize;
		return 0;

	case WM_NCPAINT:
		CallWindowProc(pbut->oldproc, hwnd, msg, wParam, lParam);
		GetWindowRect(hwnd, &rect);
		OffsetRect(&rect, -rect.left, -rect.top);
		GetButtonRect(pbut, &rect);
		DrawInsertedButton(hwnd, pbut, &rect);
		return 0;

	case WM_NCHITTEST:

        if (pbut->fButtonActive==FALSE)
            break;
		// Consigue las coordenadas del mouse en la ventana
		pt.x = LOWORD(lParam);
		pt.y = HIWORD(lParam);
		// Consigue las coordenadas del boton
		GetWindowRect(hwnd, &rect);
		GetButtonRect(pbut, &rect);
		// Chequea que el mouse està dentro del boton
		if(PtInRect(&rect, pt))
		{
			return HTBORDER;
		}
		else
		{
			break;
		}
	case WM_NCLBUTTONDOWN:
        if (pbut->fButtonActive == FALSE)
            break;
		// Consigue las coordenadas del mouse en la ventana
		pt.x = LOWORD(lParam);
		pt.y = HIWORD(lParam);
		// Consigue las coordenadas del boton
		GetWindowRect(hwnd, &rect);
		pt.x -= rect.left;
		pt.y -= rect.top;
		OffsetRect(&rect, -rect.left, -rect.top);
		GetButtonRect(pbut, &rect);
		// Chequea que el mouse està dentro del boton
		if(PtInRect(&rect, pt))
		{
			SetCapture(hwnd);

			pbut->fButtonDown = TRUE;
			pbut->fMouseDown  = TRUE;
			//redibuja el area no cliente y refleja el cambio
			 DrawInsertedButton(hwnd, pbut, &rect);
		}

		break;

	case WM_MOUSEMOVE:

        if (pbut->fButtonActive == FALSE)
            break;
		if(pbut->fMouseDown == FALSE)
			break;

		// Consigue las coordenadas del mouse en la ventana
		pt.x = LOWORD(lParam);
		pt.y = HIWORD(lParam);
		ClientToScreen(hwnd, &pt);
		// Consigue las coordenadas del boton
		GetWindowRect(hwnd, &rect);
		pt.x -= rect.left;
		pt.y -= rect.top;
		OffsetRect(&rect, -rect.left, -rect.top);
		GetButtonRect(pbut, &rect);
		oldstate = pbut->fButtonDown;
 		// Chequea que el mouse està dentro del boton
		if(PtInRect(&rect, pt))
			pbut->fButtonDown = 1;
		else
			pbut->fButtonDown = 0;

		//redibuja el area no cliente y refleja el cambio
		// Para prevenir el parpadeo (flicker), dibujamos el boton solo si ha
		// cambiado el estado
		if(oldstate != pbut->fButtonDown)
			 DrawInsertedButton(hwnd, pbut, &rect);
		break;

	case WM_LBUTTONUP:

        if (pbut->fButtonActive == FALSE)
            break;

		if(pbut->fMouseDown == FALSE)
			break;

		// get the SCREEN coordinates of the mouse
		pt.x = LOWORD(lParam);
		pt.y = HIWORD(lParam);
		ClientToScreen(hwnd, &pt);

		// get the position of the inserted button
		GetWindowRect(hwnd, &rect);

		pt.x -= rect.left;
		pt.y -= rect.top;
		OffsetRect(&rect, -rect.left, -rect.top);

		GetButtonRect(pbut, &rect);

		// check that the mouse is within the inserted button
		if(PtInRect(&rect, pt))
		{
			PostMessage(GetParent(hwnd), WM_COMMAND, (WPARAM)BN_CLICKED, (LPARAM)pbut->lbutt);
		}

		ReleaseCapture();
		pbut->fButtonDown  = FALSE;
		pbut->fMouseDown   = FALSE;

		// redraw the non-client area to reflect the change.
		 DrawInsertedButton(hwnd, pbut, &rect);

		break;

	default:
		break;
	}

	return CallWindowProc(oldproc, hwnd, msg, wParam, lParam);
}