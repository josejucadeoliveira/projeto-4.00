
// Browse para MySQL
// Autor : Roberto Evangelista
//
#include "MiniGUI.ch"

#define SB_CTL	2
#define LVS_REPORT              0x0001
#define LVS_SINGLESEL           0x0004
#define LVS_SHOWSELALWAYS       0x0008
#define LVS_EX_HEADERDRAGDROP   0x00000010
#define LVS_EX_FULLROWSELECT    0x00000020 // applies to report mode only

#define LVM_FIRST               0x1000      // ListView messages
#define LVM_SETEXTENDEDLISTVIEWSTYLE (LVM_FIRST+54)   // optional wParam == mask

#define WS_CHILD		0x40000000
#define WS_TABSTOP	0x10000
#define WS_VISIBLE	0x10000000
#define WS_BORDER		0x800000

#define EM_SETSEL		177
#define WM_VSCROLL	277	// 0x0115
#define WM_HOTKEY   786
#define WM_CTLCOLOREDIT   307
#define WM_MOUSEWHEEL   0x20A
#define WM_MOUSEHOVER   0x2a1
#define WM_NOTIFY    78
#define WM_COMMAND      0x0111
#define SB_PAGEDOWN	3
#define SB_PAGEUP		2
#define nMyRecno     22

#define LVN_KEYDOWN (-155)

#define NM_DBLCLK   (-3)
#define LBN_DBLCLK   2

#define SB_CTL   2
#define SB_VERT   1
#define SB_LINEUP   0
#define SB_LINEDOWN   1
#define SB_LINELEFT   0
#define SB_LINERIGHT   1
#define SB_PAGEUP   2
#define SB_PAGEDOWN   3
#define SB_PAGELEFT   2
#define SB_PAGERIGHT   3
#define SB_THUMBPOSITION   4
#define SB_THUMBTRACK   5
#define SB_ENDSCROLL   8
#define SB_LEFT   6
#define SB_RIGHT   7
#define SB_BOTTOM   7
#define SB_TOP   6

Memvar aresult , l, aWhen , aWhenVarNames, cMacroVar, _nMySQL_Recno
MemVar _oMySQL_Query, _oMySQL_Server, _oMySQL_Row


*-----------------------------------------------------------------------------*
function _MySQL_DefineMBrowse (ControlName, ParentFormName, x, y, w, h, aHeaders, aWidths, aFields, value, fontname, fontsize,;
                         tooltip, change, dblclick, aHeadClick, gotfocus, lostfocus, WorkArea, Delete, nogrid,;
                         aImage, aJust, HelpId, bold, italic, underline, strikeout, break, backcolor, fontcolor,;
                         lock, inplace, novscroll, appendable, readonly, valid, validmessages, edit,;
                         dynamicforecolor, dynamicbackcolor, aWhenFields, nId, aImageHeader, NoTabStop, oSocket, ;
                         cVariavel, cOrder, cWhere, aImputMask)
*-----------------------------------------------------------------------------*
   Local i , ParentFormHandle, blInit , mVar , DeltaWidth , k := 0, Style := 0
	Local ControlHandle, FontHandle, aFont, hsum := 0, cVariavel1 := ""
	private _nMySQL_Recno := 1, vPosFields := {}
   private _oMySQL_Query := nil, _oMySQL_Server := nil, _oMySQL_Row := nil
	
   SET EVENTS FUNCTION TO _MySQL_MyEvents
   DEFAULT notabstop TO FALSE
   
   if ((FontHandle := GetFontHandle (FontName)) != 0)
      aFont := GetFontParam(FontHandle)
      FontName      := aFont[1]
      FontSize      := aFont[2]
      bold          := aFont[3]
      italic        := aFont[4]
      underline     := aFont[5]
      strikeout     := aFont[6]
   endif

	if (_HMG_BeginWindowActive .or. _HMG_BeginDialogActive)
		ParentFormName := if(_HMG_BeginDialogActive, _HMG_ActiveDialogName, _HMG_ActiveFormName)
		
		if (!Empty (_HMG_ActiveFontName) .and. ValType (FontName) == "U")
			FontName := _HMG_ActiveFontName
		endIf
		
		if (!Empty (_HMG_ActiveFontSize) .and. ValType (FontSize) == "U")
			FontSize := _HMG_ActiveFontSize
		endIf
		
	endif
	
	if (_HMG_FrameLevel > 0)
		x 	:= x + _HMG_ActiveFrameCol [_HMG_FrameLevel]
		y 	:= y + _HMG_ActiveFrameRow [_HMG_FrameLevel]
		ParentFormName := _HMG_ActiveFrameParentFormName [_HMG_FrameLevel]
	endIf

	if (!_IsWindowDefined (ParentFormName) .and. !_HMG_DialogInMemory)
		MsgMiniGuiError("Window: "+ ParentFormName + " não definida. Programa Terminado")
	endif

	if (_IsControlDefined (ControlName,ParentFormName) .and. !_HMG_DialogInMemory)
		MsgMiniGuiError ("Controle: " + ControlName + " de " + ParentFormName + " NÆo definido. Programa Terminado" )
	endif

	if (valtype (value) == "U")
		value := 1
	endif
	
	if (valtype (aFields) == "U")
		aFields := {}
	endif
	
	if (valtype (aJust) == "U")		// Browse+
		aJust := Array (len (aFields))
		aFill (aJust, 0)
	else
		aSize (aJust, len (aFields))
		aEval (aJust, {|x, i| aJust[i] := iif (x==NIL, 0, x)})
	endif
	
	if (valtype (aImage) == "U")
		aImage := {}
	endif

	if (valtype (aImageHeader) == "U")
		aImageHeader := {}
	endif

	if (!novscroll)
		DeltaWidth := GETVSCROLLBARWIDTH ()
	else
		DeltaWidth := 0
	endIf

	if (valtype (change) == "U")
		change := ""
	endif

	if (valtype (dblclick) == "U")
		dblclick := ""
	endif

	if (valtype (aHeadClick) == "U")
		aHeadClick := {}
	endif

   if (valtype (cVariavel) != "C")
      cVariavel := ""
   endif


   if (valtype (cOrder) != "C")
      cOrder := nil
   endif
   
   if (valtype (cWhere) != "C")
      cWhere := nil
   endif
   
   if (valtype (aImputMask) != "A")
      aImputMask := nil
   endif
   
   mVar := '_'+ParentFormName+'_'+ControlName
   k := _GetControlFree ()

   if (_HMG_BeginDialogActive)
      ParentFormHandle := _HMG_ActiveDialogHandle
      style := LVS_SINGLESEL+LVS_SHOWSELALWAYS+WS_BORDER+WS_CHILD+WS_VISIBLE+LVS_REPORT

      if (!NoTabStop)
         Style += WS_TABSTOP
      endif

      if (_HMG_DialogInMemory)         // Dialog Template
         blInit := {|x, y, z| _MySQL_InitDialogMBrowse (x, y, z)}
         aadd (_HMG_aDialogItems, {nId, k, "SysListView32", style, 0, x, y, w-DeltaWidth, ;
			      h, "", HelpId, tooltip, FontName, FontSize, bold, italic, underline, ;
					strikeout, blInit, _HMG_BeginTabActive, .F., _HMG_ActiveTabPage})
         
			if (_HMG_aDialogTemplate[3])   // Modal
            _HMG_aControlDeleted [k] := .T.
            return Nil
         endif
         
      else
         ControlHandle := GetDialogItemHandle (ParentFormHandle, nId)
         SetWindowStyle (ControlHandle, style)

         x := GetWindowCol (Controlhandle)
         y := GetWindowRow (Controlhandle)
         w := GetWindowWidth  (Controlhandle)
         h := GetWindowHeight (Controlhandle)
      endif

   else
    	ParentFormHandle := GetFormHandle (ParentFormName)

      if (valtype(w) == "U")
		   w := 240
	   endif

	   if (valtype(h) == "U")
		   h := 120
	   endif

      if (valtype(x) == "U" .or. valtype(y) == "U")
   	   // If splitboxed force no vertical scrollbar
		   novscroll := .T.
   
	  	   if (_HMG_SplitLastControl == 'TOOLBAR')
	    	   Break := .T.
		   endIf

		   _HMG_SplitLastControl := 'GRID'
		   i := GetFormIndex (ParentFormName)

		   if (i > 0)
		      ControlHandle := InitBrowse (ParentFormHandle, 0, x, y, w - DeltaWidth, h, '', 0, iif (nogrid, 0, 1 ), NoTabStop) // Browse+
    		   x := GetWindowCol (Controlhandle)
	    	   y := GetWindowRow (Controlhandle)
	    	   AddSplitBoxItem (Controlhandle, _HMG_aFormReBarHandle[i], w, break, , , , _HMG_ActiveSplitBoxInverted)
		   endIf

      else
         ControlHandle := InitBrowse (ParentFormHandle, 0, x, y, w - DeltaWidth , h , '', 0, iif (nogrid, 0, 1 ), NoTabStop) // Browse+
      endif
      
   endif

   if (!_HMG_DialogInMemory)

      If (ValType (backcolor) != 'U')
	    	ListView_SetBkColor (ControlHandle, backcolor[1], backcolor[2], backcolor[3])
		   ListView_SetTextBkColor (ControlHandle , backcolor[1], backcolor[2], backcolor[3])
      EndIf

      if (ValType (fontcolor) != 'U')
		   ListView_SetTextColor (ControlHandle, fontcolor[1], fontcolor[2], fontcolor[3])
      EndIf

	if (FontHandle != 0)
		_SetFontHandle(ControlHandle, FontHandle)
	else
	   
		if (valtype (fontname) != "U" .and. valtype (fontsize) != "U")
		   FontHandle := _SetFont (ControlHandle, FontName, FontSize, bold, italic, underline, strikeout)
		else
    		FontHandle := _SetFont (ControlHandle, _HMG_DefaultFontName, _HMG_DefaultFontSize, bold, italic, underline, strikeout)
			Fontname :=_HMG_DefaultFontName
			FontSize :=_HMG_DefaultFontSize
		endif
		
	endIf

   if (valtype(tooltip) != "U")
	   SetToolTip (ControlHandle, tooltip, GetFormToolTipHandle (ParentFormName))
   endif

   endif

	Public &mVar. := k

	_HMG_aControlType [k] := "MYSQLBROWSE"
	_HMG_aControlNames [k] :=   ControlName
	_HMG_aControlHandles [k] :=   ControlHandle
	_HMG_aControlParenthandles [k] :=   ParentFormHandle
	_HMG_aControlIds  [k] :=  nId
	_HMG_aControlProcedures  [k] :=  aWidths
	_HMG_aControlPageMap   [k] := aHeaders
	_HMG_aControlValue   [k] := Value
	_HMG_aControlInputMask   [k] := Lock
	_HMG_aControllostFocusProcedure  [k] :=  lostfocus
	_HMG_aControlGotFocusProcedure  [k] :=  gotfocus
	_HMG_aControlChangeProcedure  [k] :=  change
	_HMG_aControlDeleted   [k] := .F.
	_HMG_aControlBkColor  [k] :=  aImage // Browse+
	_HMG_aControlFontColor   [k] := inplace
	_HMG_aControlDblClick   [k] := dblclick
	_HMG_aControlHeadClick   [k] := aHeadClick
	_HMG_aControlRow   [k] := y
	_HMG_aControlCol   [k] := x
	_HMG_aControlWidth   [k] := w
	_HMG_aControlHeight   [k] := h
	_HMG_aControlSpacing   [k] := upper (WorkArea)
	_HMG_aControlContainerRow  [k] :=  iif ( _HMG_FrameLevel > 0 ,_HMG_ActiveFrameRow [_HMG_FrameLevel] , -1 )
	_HMG_aControlContainerCol  [k] :=  iif ( _HMG_FrameLevel > 0 ,_HMG_ActiveFrameCol [_HMG_FrameLevel] , -1 )
	_HMG_aControlPicture   [k] :=  aImageHeader // Browse+
	_HMG_aControlContainerHandle   [k] := 0
	_HMG_aControlFontName   [k] :=  fontname
	_HMG_aControlFontSize   [k] :=  fontsize
	_HMG_aControlFontAttributes   [k] :=  {bold,italic,underline,strikeout}
	_HMG_aControlToolTip    [k] :=  tooltip
	_HMG_aControlRangeMin   [k] :=  aFields
	_HMG_aControlRangeMax   [k] :=  aJust
	_HMG_aControlCaption  [k] :=  aHeaders
	_HMG_aControlVisible  [k] :=  .t.
	_HMG_aControlHelpId  [k] :=   HelpId
	_HMG_aControlFontHandle   [k] :=  FontHandle
	_HMG_aControlBrushHandle  [k] :=  0
	_HMG_aControlEnabled   [k] :=  .T.
	_HMG_aControlMiscData1 [k] := {0, ;
                                  appendable, ;
                                  readonly, ;
                                  valid, ;
                                  validmessages, ;
                                  edit, ;
                                  nogrid, ;
                                  novscroll, ;
                                  dynamicforecolor, ;
                                  dynamicbackcolor, ;
                                  aWhenFields, ;
                                  Delete, ;
                                  oSocket, ;
                                  nil, ;
                                  cVariavel1, ;
                                  cOrder, ;
                                  vPosFields, ;
                                  cWhere, ;
                                  aImputMask}
   // 14-refere-se ao a Query
   // 15-variavel que sera uasada para a procura
   // 16-Coluna de ordenação dos dados
   // 17-Vetor de Posi‡Æo dos Campos
   // 18-Clausula Where
   // 19-Clasula Imput Mask
   
   if (!_HMG_DialogInMemory)
      _MySQL_InitDialogMBrowse (ParentFormName, ControlHandle, k)
   endif
   
return (nil)

*-----------------------------------------------------------------------------*
function _MySQL_InitDialogMBrowse (ParentName, ControlHandle, i)
*-----------------------------------------------------------------------------*
	Local x , w , y , h , z , ParentFormHandle , ScrollBarHandle , wBitmap
	Local hsum := 0, dynamicforecolor , dynamicbackcolor , aWhenFields
	Local aImageHeader , ScrollBarButtonHandle , nogrid
	
	x := _HMG_aControlCol[i]
	w := _HMG_aControlWidth[i]
	y := _HMG_aControlRow[i]
	h := _HMG_aControlHeight[i]
	
	ParentFormHandle := _HMG_aControlParenthandles[i]
	nogrid           := _HMG_aControlMiscData1[i, 7]
	dynamicforecolor := _HMG_aControlMiscData1[i, 9]
	dynamicbackcolor := _HMG_aControlMiscData1[i, 10]
	aWhenFields      := _HMG_aControlMiscData1[i, 11]
	aImageHeader     := _HMG_aControlPicture[i]
	
	SendMessage (ControlHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, iif (nogrid, 0, 1)+LVS_EX_FULLROWSELECT+LVS_EX_HEADERDRAGDROP)
	
	wBitmap := iif ( len (_HMG_aControlBkColor[i])>0, AddListViewBitmap (ControlHandle, _HMG_aControlBkColor[i]), 0) // Add Bitmap Column
	_HMG_aControlProcedures[i, 1] := max (_HMG_aControlProcedures[i, 1], wBitmap+2 ) // Set Column 1 width to Bitmap width
	
	if (len (aImageHeader)>0)
	   AddListViewBitmapHeader (ControlHandle, aImageHeader) // Add Header Bitmaps
	endif
	
	InitListViewColumns (ControlHandle, _HMG_aControlCaption[i], _HMG_aControlProcedures[i], _HMG_aControlRangeMax[i])
	
	// Add to browselist array to update on window activation
	aAdd (_HMG_aFormBrowseList[GetFormIndex (ParentName)], i)
	
	for z := 1 To Len (_HMG_aControlProcedures[i])
	   hsum += ListView_GetColumnWidth (_HMG_aControlHandles[i], z-1)
	   _HMG_aControlProcedures[i][z] := ListView_GetColumnWidth (_HMG_aControlHandles [i] , z - 1 )
	next z
	
	// Add Vertical scrollbar
	
	if (!_HMG_aControlMiscData1 [i, 8])
	
	   if (hsum>w- GETVSCROLLBARWIDTH ()-4)
	      ScrollBarHandle := InitVScrollBar (  ParentFormHandle, x+w- GETVSCROLLBARWIDTH (), y, GETVSCROLLBARWIDTH (), h- GETHSCROLLBARHEIGHT ())
	      ScrollBarButtonHandle := InitVScrollBarButton (ParentFormHandle, x+w- GETVSCROLLBARWIDTH (), y+h - GETHSCROLLBARHEIGHT() , GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() )
	   else
	      ScrollBarHandle := InitVScrollBar (ParentFormHandle , x+w-GETVSCROLLBARWIDTH () , y , GETVSCROLLBARWIDTH (), h)
	      ScrollBarButtonHandle := InitVScrollBarButton (ParentFormHandle, x+w- GETVSCROLLBARWIDTH (), y+h-GETHSCROLLBARHEIGHT (), 0, 0)
	   endIf
	
	   if (_HMG_BeginTabActive)
	      aadd (_HMG_ActiveTabCurrentPageMap, {ControlHandle, ScrollBarHandle, ScrollBarButtonHandle})
	   endIf
	
   else
	   ScrollBarHandle := 0
	
	   if (_HMG_BeginTabActive)
	      aAdd (_HMG_ActiveTabCurrentPageMap, ControlHandle)
	   endIf
	
	endIf
	
	_HMG_aControlIds[i] := ScrollBarHandle
	_HMG_aControlMiscData1[i, 1] := ScrollBarButtonHandle
	
	__MVPUBLIC ('_HMG_'+alltrim (str (_HMG_aControlhandles[i]))+'_DYNAMICFORECOLOR')
	__MVPUT ('_HMG_'+alltrim (str (_HMG_aControlhandles[i]))+'_DYNAMICFORECOLOR', dynamicforecolor)
	
	__MVPUBLIC ('_HMG_'+alltrim (str (_HMG_aControlhandles[i]))+'_DYNAMICBACKCOLOR')
	__MVPUT ('_HMG_'+alltrim (str (_HMG_aControlhandles[i]))+'_DYNAMICBACKCOLOR', dynamicbackcolor)
	
	__MVPUBLIC ('_HMG_'+alltrim (str (_HMG_aControlhandles[i]))+'_WHEN' )
	__MVPUT ('_HMG_'+alltrim (str (_HMG_aControlhandles[i]))+'_WHEN', aWhenFields)
	
   _MySQL_BrowseRefresh ('', '', i)
return (nil)


*-----------------------------------------------------------------------------*
function _MySQL_BrowseRefresh (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   local i, s, _Alias, _RecNo, _BrowseArea, _DeltaScroll := {Nil, Nil, Nil, Nil}, ;
         v, nA, Fields, _cMySQL_Query := "", _oMySQL_Query := nil, _cMySQL_Order := "", ;
         _oMySQL_Socket := nil, _nMySQL_Order, vPosFields := {}, cMySQL_Where := "", ;
         _nMySQL_TotalLinhas := 0
   Private cMacroVar

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	v := _MySQL_BrowseGetValue ('', '', i)

	_DeltaScroll := ListView_GetSubItemRect (_HMG_aControlhandles[i], 0, 0) 

	s := LISTVIEW_GETFIRSTITEM (_HMG_aControlHandles[i])

	_Alias := ""
	_BrowseArea := _HMG_aControlSpacing[i]

   if (empty (_BrowseArea))
		ListViewReset (_HMG_aControlhandles[i])
		return
	endIf
      
   //
   _oMySQL_Socket := _HMG_aControlMiscData1[i, 13]
   _cMySQL_Order := _HMG_aControlMiscData1[i, 16]
   _cMySQL_Where := _HMG_aControlMiscData1[i, 18]
   Fields := _HMG_aControlRangeMin[i]
   _cMySQL_Query := "SELECT "
   
   for nA := 1 to len (Fields)
      _cMySQL_Query += upper (Fields[nA])
      _cMySQL_Query += if (nA < len (Fields), ", ", "")
   next nA
   
   _cMySQL_Query += " FROM "+&_BrowseArea
   
   if (_cMySQL_Where != nil)
      _cMySQL_Where := strTran (_cMySQL_Where, "*", "%")
      _cMySQL_Query += " "+_cMySQL_Where
   endif

   if (_cMySQL_Order != nil)
      _cMySQL_Query += " ORDER BY "+_cMySQL_Order
   endif

   //
   if (_cMySQL_Where != nil)
   
      if (_cMySQL_Where == "#NOT#")
         return (0)
      endif
      
   endif
   
   // Executa a Query
   _oMySQL_Query := _oMySQL_Socket:Query (_cMySQL_Query)
   
   // Armazena a posi‡Æo dos campos do vetor
   for nA := 1 to len (Fields)
      aadd (vPosFields, _oMySQL_Query:FieldPos (Fields[nA]))
   next nA

   // Armazena a Query
   _HMG_aControlMiscData1[i, 14] := _oMySQL_Query
   _HMG_aControlMiscData1[i, 17] := vPosFields
   
   v := _MySQL_BrowseGetValue ('', '', i)
   _RecNo := _MySQL_RecNo (i)
   
	if (v <= 0)
		v := _RecNo
	endIf

	_MySQL_GoTo (v, i)

   if (_MySQL_Eof (i))
      ListViewReset ( _HMG_aControlhandles[i] )
		_MySQL_GoTo (_RecNo, i)
		return (_nMySQL_TotalLinhas)
	endIf

	_MySQL_BrowseVscrollUpdate (i)
	
	if (s != 0)
		_MySQL_Skip (-s+1)
	endIf
	
   _nMySQL_TotalLinhas := _oMySQL_Query:Lastrec ()
   _MySQL_BrowseUpdate ('', '', i)
   
	ListView_Scroll (_HMG_aControlHandles[i], _DeltaScroll[2]*(-1), 0)
	ListView_SetCursel (_HMG_aControlHandles[i], ascan (_HMG_aControlRangeMax[i], v))
	_MySQL_GoTo (_RecNo, i)
return (_nMySQL_TotalLinhas)

*-----------------------------------------------------------------------------*
function _MySQL_BrowseUpdate (ControlName, ParentName, z, lUpdate)
*-----------------------------------------------------------------------------*
   local PageLength, aTemp := {}, cTemp, Fields, _BrowseRecMap := {}, i, ;
         x , j , First , Image , _Rec, aHeaders
   local dBc, dFc, processdbc, processdfc, ColorMap, ColorRow, fcolormap, ;
         fcolorrow
   local _oMySQL_Query := nil, _oMySQL_Row := nil, nRec, nPosField, vPosFields, ;
         _vMySQL_ImputMask := {}, _nRec1 := 0
   
	if (pcount () == 2)
		i := GetControlIndex(ControlName, ParentName)
	else
		i := z
	endIf

	dbc := __MVGET ('_HMG_'+ALLTRIM (STR (_HMG_aControlhandles[i]))+'_DYNAMICBACKCOLOR')
	processdbc := if (valtype (dbc) == 'A' , .T. , .F.)

	dfc := __MVGET ('_HMG_'+ALLTRIM (STR (_HMG_aControlhandles[i]))+'_DYNAMICFORECOLOR' )
	processdFc := if (valtype (dFc) == 'A', .T. , .F. )

	_HMG_aControlContainerHandle[i] := 0

	
	
	First := iif  (len (_HMG_aControlBkColor[i]) == 0, 1, 2) // Browse+ ( 2= bitmap definido, se cargan campos a partir de 2º )

   aHeaders := _HMG_aControlCaption[i]
   Fields := _HMG_aControlRangeMin[i]
   vPosFields := _HMG_aControlMiscData1[i, 17]
   
	ListViewReset (_HMG_aControlhandles[i])
	PageLength := ListViewGetCountPerPage (_HMG_aControlhandles[i])

	if (processdfc)
		fcolormap := {}  ;  fcolorrow := {}
	endif

	if (processdbc)
		colormap := {}  ;  colorrow := {}
	endif
	
	_oMySQL_Query := _HMG_aControlMiscData1[i, 14]
	_vMySQL_ImputMAsk := _HMG_aControlMiscData1[i, 19]
	
	lUpdate := iif (lUpdate == nil, .F., lUpdate)
	//
	nRec1 := _HMG_aControlRangeMax[i]

   if (lUpdate)

      if (nRec1[1] > 0)
         _MySQL_GoTo (nRec1[1], i)
	   endif
	   
   endif
	
	for x := 1 to PageLength 
	   nRec := _MySQL_Recno (i)
      _oMySQL_Row := _oMySQL_Query:GetRow (nRec)
      aTemp := {}

		if (First == 2)						// Browse+
			cTemp := Fields[1]
		
			if (valType (cTemp) == 'N')				// ..
			   image := &cTemp
			elseif (valType (cTemp) == 'L')			// ..
				image := iif( &cTemp, 1, 0)
			else						// ..
				image := 0
			endif						// ..
			
			aadd (aTemp, NIL)

			if (processdbc)
			
				if (valtype (dbc) == 'A' .and. len (dbc) == len (Fields))
					aadd (colorrow, -1)
				endif
				
			endif

			if (processdfc)
			
				if (valtype (dfc) == 'A' .and. len (dfc) == Len (Fields))
					aadd (fcolorrow, -1)
				endif
				
			endif

		endIf							// Browse+

		for j := First To Len (aHeaders) //Fields)
		   cTemp := _oMySQL_Row:fieldGet (j)
		   
         if (valtype (_vMySQL_ImputMask) == "A")

            if (valtype (_vMySQL_ImputMask[j]) == "C")
               cTemp := trans (cTemp, _vMySQL_ImputMask[j])
            elseif (valtype (_vMySQL_ImputMask[j]) == "B")
               cTemp := eval (_vMySQL_ImputMask[j])
            endif
            
         endif
         
         if (ValType (cTemp) == 'N')
            aadd (aTemp, lTrim (str (cTemp)))
         elseIf (ValType (cTemp) == 'D')
				aadd (aTemp, Dtoc (cTemp))
			elseIf (ValType (cTemp) == 'L')
				aadd (aTemp, iif (cTemp, '.T.' , '.F.'))
			elseIf (ValType (cTemp) == 'C')
				aadd (aTemp, rTrim (cTemp))
			elseIf (ValType (cTemp) == 'M')
				aadd (aTemp, '<Memo>')
			else
				aadd (aTemp, 'Nil')				
			endIf

			if (processdfc)
			
				if (valtype (dfc) == 'A' .and. len (dfc) == Len (Fields))
					aadd (fcolorrow, if (valtype (dfc[j]) == 'B', eval (dfc[j]), -1))
				endif

			endif

			if (processdbc)

				if (valtype (dbc) == 'A' .and. len (dbc) == Len (Fields))
               aadd (colorrow, if (valtype (dbc[j]) == 'B', eval (dbc[j]), -1))
            endif

			endif

		next j

		AddListViewItems (_HMG_aControlhandles[i], aTemp, Image)
		_Rec := _MySQL_Recno (i)
		
		aadd (_BrowseRecMap, _Rec)

		if (processdfc)
			aadd (fcolormap, fcolorrow)
			fcolorrow := {}
		endif

		if (processdbc)
			aadd (colormap, colorrow)
			colorrow := {}
		endif

		_MySQL_Skip (1, i)



      if (_MySQL_Eof (i))
         _HMG_aControlContainerHandle[i] := 1
			exit
		endIf
		
	next x



	__MVPUBLIC ('_HMG_'+ALLTRIM (STR (_HMG_aControlhandles[i]))+'_DBC')
	__MVPUBLIC ('_HMG_'+ALLTRIM (STR (_HMG_aControlhandles[i]))+'_DFC')

	if (processdbc == .t.)
		__MVPUT ('_HMG_'+ALLTRIM (STR (_HMG_aControlhandles[i]))+'_DBC', colormap)
	else
		__MVPUT ('_HMG_'+ALLTRIM (STR (_HMG_aControlhandles[i]))+'_DBC', Nil)
	endif

	if (processdfc == .t.)
		__MVPUT ('_HMG_'+ALLTRIM (STR (_HMG_aControlhandles[i]))+'_DFC', fcolormap)
	else
		__MVPUT ('_HMG_'+ALLTRIM (STR (_HMG_aControlhandles[i]))+'_DFC', Nil)
	endif
   
   _HMG_aControlRangeMax[i] := _BrowseRecMap
return (nil)

*------------------------------------------------------------------------------*
procedure _MySQL_BrowseVscrollUpdate (i)
*------------------------------------------------------------------------------*
local ActualRecord , RecordCount , KeyCount 
	// If vertical scrollbar is used it must be updated
	
	if (_HMG_aControlIds [i] != 0)
		KeyCount := _MySQL_Lastrec (i)
		
		if (KeyCount > 0)
			ActualRecord := _MySql_Recno (i)
         RecordCount := KeyCount
		else
			ActualRecord := _MySql_Recno (i)
         RecordCount := _MySQL_OrdKeyCount (i)
		endIf

		_HMG_aControlBrushHandle [i] := RecordCount

		if (RecordCount < 100)
			SetScrollRange (_HMG_aControlIds [i], 2, 1, RecordCount, .T.)
			SetScrollPos ( _HMG_aControlIds [i], 2, ActualRecord, 1 )
		else
			SetScrollRange (_HMG_aControlIds [i], 2, 1, 100, .T.)
			SetScrollPos (_HMG_aControlIds[i], 2, Int (ActualRecord*100/RecordCount), 1)
		endIf

	endIf

return


*------------------------------------------------------------------------------*
procedure _MySQL_BrowseVscrollFastUpdate (i, d)
*------------------------------------------------------------------------------*
   local ActualRecord, RecordCount 

	// Atualiza a barra vertical
	if (_HMG_aControlIds[i] != 0)
		RecordCount := _HMG_aControlBrushHandle[i]

		if (!ISNUMBER (RecordCount) .or. RecordCount==0)
			return
		endIf

		if (RecordCount < 100)
			ActualRecord := GetScrollPos (_HMG_aControlIds[i], 2)
			ActualRecord := ActualRecord+d
			SetScrollRange (_HMG_aControlIds[i], 2, 1, RecordCount, .T.)
			SetScrollPos (_HMG_aControlIds[i], 2, ActualRecord, 1)
		endIf

	endIf

return


*-----------------------------------------------------------------------------*
procedure _MySQL_BrowseUp (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   local i, s, _Alias, _RecNo, _BrowseArea, _BrowseRecMap, ;
         _DeltaScroll := {Nil, Nil, Nil, Nil}

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	_DeltaScroll := ListView_GetSubItemRect (_HMG_aControlhandles[i], 0, 0) 
	_BrowseRecMap := _HMG_aControlRangeMax[i] 
	s := LISTVIEW_GETFIRSTITEM (_HMG_aControlHandles[i]) 

	if (s == 1)
		_RecNo := _MySQL_Recno (i)
		_MySQL_GoTo (_BrowseRecMap[1])
		_MySQL_Skip (-1, i)
  		_MySQL_BrowseVscrollUpdate (i)
  		_MySQL_BrowseUpdate (ControlName, ParentForm, i)
		ListView_Scroll (_HMG_aControlHandles[i], _DeltaScroll[2]*(-1), 0)
		_MySQL_GoTo (_RecNo, i)
		ListView_SetCursel (_HMG_aControlHandles[i], 1)		
	else
		ListView_SetCursel (_HMG_aControlHandles[i], s-1)
		_MySQL_BrowseVscrollFastUpdate (i, -1)
	endIf

	_MySQL_BrowseOnChange (i)
return


*-----------------------------------------------------------------------------*
procedure _MySQL_BrowseDown (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   local i, PageLength, s, _Alias, _RecNo, _BrowseArea, _BrowseRecMap, ;
         _DeltaScroll := {Nil, Nil, Nil, Nil}
	
   if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	_DeltaScroll := ListView_GetSubItemRect (_HMG_aControlhandles[i], 0, 0) 
	_BrowseRecMap := _HMG_aControlRangeMax[i] 
	s := LISTVIEW_GETFIRSTITEM (_HMG_aControlHandles[i]) 
	PageLength := LISTVIEWGETCOUNTPERPAGE (_HMG_aControlhandles[i])

	if (s == PageLength)

		if (_HMG_aControlContainerHandle[i] != 0)
			Return
		endIf

		_RecNo := _MySQL_Recno (i)
      _MySQL_GoTo (_BrowseRecMap[1], i)
      _MySQL_Skip (, i)
      _MySQL_BrowseUpdate (ControlName, ParentForm, i)
		_MySQL_BrowseVscrollUpdate (i)
		ListView_Scroll (_HMG_aControlHandles[i], _DeltaScroll[2]*(-1), 0)
      _MySQL_GoTo (_RecNo, i)
      ListView_SetCursel (_HMG_aControlHandles[i], Len (_HMG_aControlRangeMax[i]))
	else
      ListView_SetCursel (_HMG_aControlHandles[i], s+1)
		_MySQL_BrowseVscrollFastUpdate (i, 1)
	endIf

	_MySQL_BrowseOnChange (i)
return


*-----------------------------------------------------------------------------*
Procedure _MySQL_BrowsePrior (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   Local i, _Alias, _RecNo, _BrowseArea, _BrowseRecMap, _DeltaScroll := {Nil, Nil, Nil, Nil}

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	_DeltaScroll := ListView_GetSubItemRect (_HMG_aControlhandles[i], 0, 0)
	_BrowseRecMap := _HMG_aControlRangeMax[i]

	if (LISTVIEW_GETFIRSTITEM (_HMG_aControlHandles[i]) == 1)
		_RecNo := _MySQL_RecNo (i)

		_MySQL_GoTo (_BrowseRecMap[1])
		_MySQL_Skip (-LISTVIEWGETCOUNTPERPAGE (_HMG_aControlhandles[i])+1)
		_MySQL_BrowseVscrollUpdate (i)
		_MySQL_BrowseUpdate (ControlName, ParentForm, i)
		ListView_Scroll(_HMG_aControlHandles[i], _DeltaScroll[2]*(-1), 0)
		_MySQL_GoTo (_RecNo, i)
	else
		_MySQL_BrowseVscrollFastUpdate (i, 1-LISTVIEW_GETFIRSTITEM (_HMG_aControlHandles[i]))
	endIf

	ListView_SetCursel (_HMG_aControlHandles[i], 1)		
	_MySQL_BrowseOnChange (i)
Return


*-----------------------------------------------------------------------------*
Procedure _MySQL_BrowseNext (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   Local i , PageLength , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll := { Nil , Nil , Nil , Nil } , s 

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_aControlhandles[i],0 , 0)
	_BrowseRecMap := _HMG_aControlRangeMax[i]
	PageLength := LISTVIEWGETCOUNTPERPAGE (_HMG_aControlhandles[i])

	s := LISTVIEW_GETFIRSTITEM (_HMG_aControlHandles [i])

	if  (s == PageLength)

		if (_HMG_aControlContainerHandle[i] != 0)
			return
		endIf

		_RecNo := _MySQL_Recno (i)

		_MySQL_GoTo (_BrowseRecMap[PageLength]) //Go _BrowseRecMap [PageLength] 
		_MySQL_BrowseUpdate (ControlName, ParentForm, i)
		_MySQL_BrowseVscrollUpdate (i)
		ListView_Scroll (_HMG_aControlHandles[i], _DeltaScroll[2] * (-1), 0)
		ListView_SetCursel (_HMG_aControlHandles[i], len (_HMG_aControlRangeMax [i]))
		_MySQL_GoTo (_RecNo, i)
	else
		ListView_SetCursel (_HMG_aControlHandles[i], len (_BrowseRecMap))
		_MySQL_BrowseVscrollFastUpdate (i, PageLength - s)
	endIf

	_MySQL_BrowseOnChange (i)
return


*-----------------------------------------------------------------------------*
Procedure _MySQL_BrowseHome (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   Local i, _Alias, _RecNo, _BrowseArea, _DeltaScroll := {Nil, Nil, Nil, Nil}

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	_DeltaScroll := ListView_GetSubItemRect (_HMG_aControlhandles[i], 0, 0)

	_RecNo := _MySQL_RecNo (i)
	_MySQL_GoTop (i)
	_MySQL_BrowseVscrollUpdate (i)
	_MySQL_BrowseUpdate (ControlName, ParentForm, i)
	ListView_Scroll (_HMG_aControlHandles[i], _DeltaScroll[2] * (-1), 0)
	_MySQL_GoTo (_RecNo, i)
	
	ListView_SetCursel (_HMG_aControlHandles[i], 1)
	_MySQL_BrowseOnChange (i)
return


*-----------------------------------------------------------------------------*
Procedure _MySQL_BrowseEnd (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   local i, _Alias, _RecNo, _BrowseArea, _DeltaScroll := {Nil, Nil, Nil, Nil}, _BottomRec

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	_DeltaScroll := ListView_GetSubItemRect (_HMG_aControlhandles[i], 0, 0) 

	_RecNo := _MySQL_RecNo(i)
	_MySQL_GoBottom (i)
	_BottomRec := _MySQL_RecNo (i)

	_MySQL_BrowseVscrollUpdate (i)
	_MySQL_Skip (-LISTVIEWGETCOUNTPERPAGE (_HMG_aControlhandles[i]) + 1)
	_MySQL_BrowseUpdate (ControlName, ParentForm, i)
	ListView_Scroll ( _HMG_aControlHandles[i], _DeltaScroll[2] * (-1), 0)
	_MySQL_GoTo (_RecNo, i)

	ListView_SetCursel (_HMG_aControlHandles[i], ascan (_HMG_aControlRangeMax[i], _BottomRec))
	_MySQL_BrowseOnChange (i)
Return


*------------------------------------------------------------------------------*
procedure _MySQL_BrowseOnChange (i)
*------------------------------------------------------------------------------*
	_MySQL_BrowseSync (i)
	_DoControlEventProcedure (_HMG_aControlChangeProcedure[i], i)
return


*------------------------------------------------------------------------------*
Procedure _MySQL_BrowseSync (i)
*------------------------------------------------------------------------------*
   Local _Alias, _BrowseArea, _RecNo, _CurrentValue

	if (_HMG_BrowseSyncStatus)
		_RecNo := _MySQL_RecNo (i)
		_CurrentValue := _MySQL_BrowseGetValue ('', '', i)

		if (_RecNo != _CurrentValue)
			_MySQL_GoTo (_CurrentValue, i)
		EndIf

	endIf

return


*-----------------------------------------------------------------------------*
function _MySQL_BrowseSetValue (ControlName, ParentForm, Value, z, mp)
*-----------------------------------------------------------------------------*
   Local i, _Alias, _RecNo, _BrowseArea, _DeltaScroll := {Nil, Nil, Nil, Nil}, m
   Private cMacroVar

	if (Value <= 0)
		return
	endIf

	if (valtype (z) == 'U')
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	if (_HMG_ThisEventType == 'MYSQLBROWSE_ONCHANGE')

      if (i == _HMG_THISINDEX)
			MsgMiniGuiError ("MySQLBROWSE: Value property can't be changed inside ONCHANGE event. Program Terminated" )
		endIf
		
	endIf

	_Alias := ""
	_BrowseArea := _HMG_aControlSpacing[i]

	if (Value == (_MySQL_LastRec (i) + 1))
		_HMG_aControlValue [i] := Value
		ListViewReset (_HMG_aControlhandles[i])
		_MySQL_BrowseOnChange (i)
		return
	endIf

	if (Value > (_MySQL_LastRec ()+1))
		return
	endIf

	if (valtype (mp) == 'U')
		m := int (ListViewGetCountPerPage (_HMG_aControlhandles[i]) / 2)
	else
		m := mp
	endif

	_DeltaScroll := ListView_GetSubItemRect (_HMG_aControlhandles[i], 0, 0) 
	_RecNo := _MySQL_RecNo (i)
	_MySQL_GoTo (Value, i)

	if (_MySQL_Eof (i))
		_MySQL_GoTo (_RecNo, i)
		return
	else
		if (pcount () < 5)
			_MySQL_BrowseVscrollUpdate (i)
		endIf
		
      _MySQL_Skip (-m + 1, i)
	endIf

	_HMG_aControlValue[i] := Value
	_MySQL_BrowseUpdate ('', '', i)
	_MySQL_GoTo (_RecNo, i)

	ListView_Scroll (_HMG_aControlHandles[i], _DeltaScroll[2] * (-1), 0)
	ListView_SetCursel (_HMG_aControlHandles[i], ascan (_HMG_aControlRangeMax[i], Value))

	_HMG_ThisEventType := 'MYSQLBROWSE_ONCHANGE'
	_MySQL_BrowseOnChange (i)
	_HMG_ThisEventType := ''
return (nil)


*-----------------------------------------------------------------------------*
function _MySQL_BrowseGetValue (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   local i, RetVal, _BrowseRecMap, _BrowseArea

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

	_BrowseArea := _HMG_aControlSpacing[i]
	_BrowseRecMap := _HMG_aControlRangeMax[i] 

	if (LISTVIEW_GETFIRSTITEM (_HMG_aControlHandles[i]) != 0)
		RetVal := _BrowseRecMap[LISTVIEW_GETFIRSTITEM (_HMG_aControlHandles[i])]
		
		if (RetVal > _MySQL_LastRec (i))
         RetVal := 1
		endif
		
	else
		RetVal := 0
	endIf

return (RetVal)


*-----------------------------------------------------------------------------*
function _MySQL_BrowseSetVariavel (ControlName, ParentForm, cVariavel, z)
*-----------------------------------------------------------------------------*
   local i, _BrowseRecMap, _BrowseArea

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf
	
	if (cVariavel != nil)
	   _HMG_aControlMiscData1[i, 15] := cVariavel
   endif
   
return (nil)


*-----------------------------------------------------------------------------*
function _MySQL_BrowseGetVariavel (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
   local i, _BrowseRecMap, _BrowseArea, cVariavel

	if (pcount() == 2)
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf
	
	cVariavel := _HMG_aControlMiscData1[i, 15]
return (cVariavel)


//----------------------------------------------------------------------------//
// Traz a quantidade de registros
//
function _MySQL_OrdKeyCount (z)
return (_MySQL_Lastrec (z))


//----------------------------------------------------------------------------//
// Traz o registro padrão
//
function _MySQL_Recno (z)
   local recno := 0
   i := if (z != nil, z, ascan (_HMG_aControlhandles, GetFocus ()))
   
   if (i > 0)

      if (_HMG_aControlType[i]=="MYSQLBROWSE")
         recno := _HMG_aControlValue[i]
      endif
      
   endif
   
return (recno)

//----------------------------------------------------------------------------//
// Avança ou retrocede um registro
//
function _MySQL_Skip (recno, z)
   loca nRecAnt := 0, nRec := 0, nRecTotal := 0, i
   recno := if (recno == nil, 1, recno)
   i := if (z != nil, z, ascan (_HMG_aControlhandles, GetFocus ()))
   
   if (i > 0)
   
      if (_HMG_aControlType[i] == "MYSQLBROWSE")
         nRecAnt := _HMG_aControlValue[i]
         nRec := _HMG_aControlValue[i]
         nRecTotal := _MySQL_Lastrec (i)
         _MySQL_Recno := nRec
         
         if (recno > 0)
            nRec += recno

            if (nRec > (nRecTotal + 1))
               nRec := nRecTotal
            endif
            
         elseif (recno < 0)
            recno := abs (recno)
            nRec -= recno

            if (nRec < 1)
               nRec := 1
            endif
            
         endif
   
         _HMG_aControlValue[i] := nRec
      endif
      
   endif
   
return (nRec)

//----------------------------------------------------------------------------//
//  Traz a quantidade de regsitros ou linha do banco de dados
//
function _MySQL_Reccount (z)
return (_MySQL_Lastrec (z))

//----------------------------------------------------------------------------//
//  Traz a quantidade de regsitros ou linha do banco de dados
//
function _MySQL_Lastrec (z)
   local rec := 1, i, _oMySQL_Query := nil
   i := if (z != nil, z, Ascan (_HMG_aControlhandles, GetFocus ()))
   
   if (i > 0)

      if (_HMG_aControlType[i] == "MYSQLBROWSE")
         _oMySQL_Query := _HMG_aControlMiscData1[i, 14]
         rec := _oMySQL_Query:LastRec ()
      endif
      
   endif
   
return (rec)

//----------------------------------------------------------------------------//
//  Verifica se o apontador chegou no inicio do banco de dados
//
function _MySQL_Bof (z)
   local nRec, lResult := .F.
   i := if (z != nil, z, ascan (_HMG_aControlhandles, GetFocus ()))
   
   if (i > 0)

      if (_HMG_aControlType[i] == "MYSQLBROWSE")
         nRec := _HMG_aControlValue[i]
         lResult := (nRec <= 1)
      endif
      
   endif
   
return (lResult)

//----------------------------------------------------------------------------//
//  Verifica se o apontador chegou no final do banco de dados
//
function _MySQL_Eof (z)
   local nRec, nTotal, lResult := .F., _oMySQL_Query := nil, i
   i := if (z!=nil, z, ascan (_HMG_aControlhandles, GetFocus ()))
   
   if (i > 0)

      if (_HMG_aControlType[i] == "MYSQLBROWSE")
         _oMySQL_Query := _HMG_aControlMiscData1[i, 14]
         nRec := _HMG_aControlValue[i]
         nTotal := _oMySQL_Query:LastRec ()
         lResult := (nRec>(nTotal))
      endif
      
   endif
   
return (lResult)

//----------------------------------------------------------------------------//
// Coloca o apontador de registro no inicio do banco de dados
//
function _MySQL_GoTop (z)
   local i, nRec := 1
   i := if (z != nil, z, ascan (_HMG_aControlhandles, GetFocus ()))
   
   if (i > 0)
   
      if (_HMG_aControlType[i] == "MYSQLBROWSE")
         _HMG_aControlValue[i] := nRec
      endif
      
   endif
   
return (nRec)


//----------------------------------------------------------------------------//
// Coloca o apontador no final do banco de dados
//
function _MySQL_GoBottom (z)
   local nRec := 1, i
   i := if (z != nil, z, ascan (_HMG_aControlhandles, GetFocus ()))
   nRec := _MySQL_Recno (i)
   
   if (i > 0)
   
      if (_HMG_aControlType[i] == "MYSQLBROWSE")
         _HMG_aControlValue[i] := _MySQL_Lastrec ()
         nRec := _HMG_aControlValue[i]
      endif
      
   endif
   
return (nRec)


//----------------------------------------------------------------------------//
// Coloca o apontador em um determinado registro do banco de dados
//
function _MySQL_GoTo (nRec, z)
   local rec, i
   
   if (nRec > 0)
      i := if (z != nil, z, ascan (_HMG_aControlhandles, GetFocus ()))
   
      if (i > 0)
         if (_HMG_aControlType[i] == "MYSQLBROWSE")
            _HMG_aControlValue[i] := nRec
         endif
      endif
      
   endif
   
   
return (nRec)


//----------------------------------------------------------------------------//
// Procura
//
function _MySQL_Seek (cSeek, z)
   local lResult := .F.
   
   if (cSeek == nil)
      return (.F.)
   endif
      
   if (!empty (cSeek))
      i := if (z != nil, z, ascan (_HMG_aControlhandles, GetFocus ()))

      if (i > 0)
         if (_HMG_aControlType[i] == "MYSQLBROWSE")
         endif
      endif
      
   endif
   
return (lResult)


//----------------------------------------------------------------------------//
function _MySQL_Events (i, nVirtKey, cKey)
//----------------------------------------------------------------------------//
   LOCAL nLastRec := 1, cPressedKeys := ""

   Do Case
   Case nVirtKey == 46 // DEL

      if (MsgYesNo( _HMG_BRWLangMessage [1] , _HMG_BRWLangMessage [2] ) == .t.)
         //_BrowseDelete ('', '', i)
      EndIf
      
   Case nVirtKey == 36 // HOME
      _MySQL_BrowseHome ('', '', i)
      Return 1
   Case nVirtKey == 35 // END
      _MySQL_BrowseEnd ('', '', i)
      Return 1
   Case nVirtKey == 33 // PGUP
      _MySQL_BrowsePrior ('', '', i)
      Return 1
   Case nVirtKey == 34 // PGDN
      _MySQL_BrowseNext ('', '', i)
      Return 1
   Case nVirtKey == 38 // UP
      _MySQL_BrowseUp ('', '', i)
      Return 1
   Case nVirtKey == 40 // DOWN
      _MySQL_BrowseDown ('', '', i)
      return 1
   Case len (cKey) > 0 .or. nVirtKey == 8
      cPressedKeys := _HMG_aControlMiscData1[i, 15]
      
      if (nVirtKey == 8) // BackSpace
         cPressedKeys := left (cPressedKeys, len (cPressedKeys)-1)
      elseif len (cKey) > 0
         cPressedKeys := cPressedKeys+cKey
      endif

      nLastRec := _MySQL_RecNo (i)
      _HMG_aControlMiscData1[i, 15] := cPressedKeys
      _MySQL_BrowseOnChange (i)
      return (1)
   EndCase

return (0)


*-----------------------------------------------------------------------------*
function _MySQL_BrowseSetWhere (ControlName, ParentForm, cWhere, z)
*-----------------------------------------------------------------------------*
   local i, _BrowseRecMap, _BrowseArea

	if (valtype (z) == 'U')
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

   if (i > 0)
   
      if (cWhere != nil)
	     _HMG_aControlMiscData1[i, 18] := cWhere
      endif
      
   endif
   
return (nil)


*-----------------------------------------------------------------------------*
function _MySQL_BrowseGetWhere (ControlName, ParentForm, z)
*-----------------------------------------------------------------------------*
return (nil)


*-----------------------------------------------------------------------------*
function _MySQL_BrowseGetCol (ControlName, ParentForm, nCol, z)
*-----------------------------------------------------------------------------*
   local i, _oMySQL_Query := nil, _oMySQL_Row := nil, _cMySQL_Row := "", ;
         cTemp := "", aTemp := {}, cRet := "", nRec := 0

	if (valtype (z) == 'U')
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

   if (i > 0)
      _oMySQL_Query := _HMG_aControlMiscData1[i, 14]
      nRec := _MySQL_BrowseGetValue ("", "", i)

      if (nRec <= 0)
         nRec := _mYSQL_Recno (i)
      endif

      if (_oMySQL_Query != nil)
         _oMySQL_Row := _oMySQL_Query:GetRow (nRec)
         cTemp := _oMySQL_Row:fieldGet (nCol)
      endif
      
   endif
   
return (cTemp)


//----------------------------------------------------------------------------//
//
function _MySQL_QueryRefresh (ControlName, ParentForm, z)
   local i, _oMySQL_Query := nil, _Rec

	if (valtype (z) == 'U')
		i := GetControlIndex (ControlName, ParentForm)
	else
		i := z
	endIf

   if (i > 0)
      _Rec := _MySQL_Recno (i)
      _oMySQL_Query := _HMG_aControlMiscData1[i, 14]
      _oMySQL_Query:Refresh()
      _MySQL_BrowseUpdate ("", "", i, .T.)
      _MySQL_GoTo (_Rec)
      ListView_SetCursel (_HMG_aControlHandles[i], ascan (_HMG_aControlRangeMax[i], _Rec))
   endif

return (nil)


//----------------------------------------------------------------------------//
function _MySQL_MyEvents (hWnd, nMsg, wParam, lParam)
//----------------------------------------------------------------------------//
   LOCAL i, nVirtKey, cKey, Result := 0, _BroseArea, _BackRec, RecordCount, SkipCount
   LOCAL cFormName := "", cControlName := ""
   static _ActiveMenu := .F.
   
   if (nMsg == WM_NOTIFY)
      i := Ascan ( _HMG_aControlhandles, GetFocus())
      
      if (i > 0)
      
         if (_HMG_aControlType[i] == "MYSQLBROWSE")
            
            if (GetNotifyCode (lParam) == LVN_KEYDOWN)
               nVirtKey := GetGridvKey (lParam)
               cKey := _MySQL_KeyToChar (nVirtKey)
               //i := Ascan (_HMG_aControlHandles, GetHwndFrom (lParam))
               //if (_HMG_aControlType[i]=="MBROWSE")
               result := _MySQL_Events (i, nVirtKey, cKey)
               return (result)
            elseif (GetNotifyCode (lParam) == NM_DBLCLK)
               _DoControlEventProcedure (_HMG_aControlDblClick[i], i)
            endif
         
         endif
         
      endif
      
   elseif (nMsg == WM_COMMAND)
      // Processa o ON CHANGE
      i := Ascan ( _HMG_aControlhandles, GetFocus())
      
      if (i > 0)
         // Tecla enter pressionada
         
         if (_HMG_aControlType[i]=="MYSQLBROWSE" .and. HiWord (wParam)==0 .and. LoWord (wParam)==1)
             _DoControlEventProcedure (_HMG_aControlDblClick[i], i)
         endif
         
      endif
   
   elseif (nMsg == WM_HOTKEY)
      // Processa as teclas de atalhos
      /*
      i := Ascan ( _HMG_aControlhandles, GetFocus())
      
      if (i>0)
      
         if _HMG_aControlType[i]="MYSQLBROWSE" //HOTKEY"
            
            if (_HMG_aControlParentHandles[i]==GetActiveWindow() .And. _ActiveMenu==.F.)
               if (_DoControlEventProcedure (_HMG_aControlProcedures[i], i))
                  //msgbox ("aqui")
                  return (0)
               endif
            endif
            
         endif
      endif
      */   
   elseif (nMsg == WM_VSCROLL)
      i := Ascan ( _HMG_aControlhandles, GetFocus())
      
      if (i>0)
      
         if (_HMG_aControlType[i] == "MYSQLBROWSE")
         
            if (LoWord (wParam) == SB_LINEDOWN)
               setfocus (_HMG_aControlHandles[i])
               InsertDown ()
            endIf
             
            if (LoWord (wParam) == SB_LINEUP)
               setfocus(_HMG_aControlHandles[i])
               InsertUp ()
            endIf

            if (LoWord (wParam) == SB_PAGEUP)
               setfocus ( _HMG_aControlHandles[i])
               InsertPrior ()
            endIf

            if (LoWord (wParam) == SB_PAGEDOWN)
               setfocus (_HMG_aControlHandles[i])
               InsertNext ()
            endIf
            
            if (LoWord (wParam) == SB_THUMBPOSITION)
               _BrowseArea := _HMG_aControlSpacing[i]

               if (!empty (_BrowseArea))
                  _BackRec := _MySQL_RecNo (i)

                  if (_MySQL_OrdKeyCount ()>0)
                     RecordCount := _MySQL_OrdKeyCount (i)
                  else
                     RecordCount := _MySQL_RecCount (i)
                  endIf

                  SkipCount := Int (HIWORD (wParam)*RecordCount/GetScrollRangeMax (_HMG_aControlIds[i], 2))

                  if (SkipCount > (RecordCount/2))
                     _MySQL_GoBottom (i)
                     _MySQL_Skip (-(RecordCount-SkipCount), i)
                  else
                     _MySQL_GoTop (i)

                     if (SkipCount>1)
                        _MySQL_Skip (SkipCount-_MySQL_RecCount()/100, i)
                     endif
                     
                  endIf

                  if (_MySQL_Eof (i))
                     _MySQL_Skip (-1, i)
                  endIf

                  nr := _MySQL_RecNo (i)

                  SetScrollPos (_HMG_aControlIds[i], 2, HIWORD (wParam), 1)
                  _MySQL_GoTo (_BackRec, i)
                  _MySQL_BrowseSetValue ('', '', nr, i)
               endif

            endif
            
         endif
         
      endif

   endif
   
   result := Events (hWnd, nMsg, wParam, lParam)
return (result)


//----------------------------------------------------------------------------//
static function _MySQL_KeyToChar (nVirtKey)
//----------------------------------------------------------------------------//
   LOCAL i, cRetChar := ""
   LOCAL nKeyboardMode := GetKeyboardMode ()
   LOCAL lShift := CheckBit (GetKeyState (16), 32768)
   LOCAL aKeysNumPad := {96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 109, 110, 111}
   LOCAL cKeysNumPad := "0123456789*+-./"
   LOCAL aKeys1 := {192, 189, 187, 219, 221, 220, 186, 222, 188, 190, 191}
   LOCAL cKeys1US := "`-=[]\;',./"
   LOCAL cKeys1ShiftUS := '~_+{}|:"<>?'
   LOCAL cKeys1RU := "¨-=ÕÚ\ÆÝÁÞ."
   LOCAL cKeys1ShiftRU := "¨_+ÕÚ/ÆÝÁÞ,"
   LOCAL cKeys2US := "1234567890QWERTYUIOPASDFGHJKLZXCVBNM "
   LOCAL cKeys2ShiftUS := "!@#$%^&*()QWERTYUIOPASDFGHJKLZXCVBNM "
   LOCAL cKeys2RU := "1234567890ÉÖÓÊÅÍÃØÙÇÔÛÂÀÏÐÎËÄß×ÑÌÈÒÜ "
   LOCAL cKeys2ShiftRU := '!"¹;%:?*()ÉÖÓÊÅÍÃØÙÇÔÛÂÀÏÐÎËÄß×ÑÌÈÒÜ '

   i := ascan (aKeysNumPad, nVirtKey)
   
   if i > 0
      return (substr (cKeysNumPad, i, 1))
   endif

   i := ascan (aKeys1, nVirtKey)
   
   if (i > 0)

      if (nKeyboardMode == 1033) // US
         if (lShift)
            cRetChar := substr (cKeys1ShiftUS, i, 1)
         else
            cRetChar := substr (cKeys1US, i, 1)
         endif
         
      elseif (nKeyboardMode == 1049) // RU

         if (lShift)
            cRetChar := substr (cKeys1ShiftRU, i, 1)
         else
            cRetChar := substr (cKeys1RU, i, 1)
         endif
         
      endif
      
      return (cRetChar)
   endif

   i := at (chr (nVirtKey), cKeys2US)
   
   if (i > 0)

      if (nKeyboardMode == 1033) // US

         if (lShift)
            cRetChar := substr (cKeys2ShiftUS, i, 1)
         else
            cRetChar := substr (cKeys2US, i, 1)
         endif
         
      elseif (nKeyboardMode == 1049) // RU
      
         if (lShift)
            cRetChar := substr (cKeys2ShiftRU, i, 1)
         else
            cRetChar := substr (cKeys2RU, i, 1)
         endif
         
      else

         if (lShift)
            cRetChar := substr (cKeys2ShiftUS, i, 1)
         else
            cRetChar := substr (cKeys2US, i, 1)
         endif
         
      endif
   
   endif

return (cRetChar)

//----------------------------------------------------------------------------//
// Inicio da Estrutura em C
#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"

HB_FUNC (GETKEYBOARDMODE)
{
   HKL kbl;
   HWND CurApp;
   DWORD idthd;
   int newmode;

   CurApp = GetForegroundWindow();
   idthd = GetWindowThreadProcessId(CurApp,NULL);

   kbl=GetKeyboardLayout(idthd);
   newmode=(int)LOWORD(kbl);

   hb_retnl(newmode);
}


#pragma ENDDUMP
// Fim da Estrutura em C
//----------------------------------------------------------------------------//