;***********************************************
;**                                           **
;**  Mouse movement recorder (MoRe) 0.1       **
;**  based on the idea of AHK script writer   **
;**  written by garath                        **
;**                                           **
;***********************************************

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
#Persistent
CoordMode, Mouse, Screen
SetBatchLines, -1

#SingleInstance,FORCE 

;*************************************+*********
;**                                           **
;**           #F1 Start recording              **
;**           #F2 Stop  recording              **
;**           #F3 Replay                       **
;**                                           **
;***********************************************




SetDefaultMouseSpeed, 0
SetMouseDelay, 0


~WheelDown::Wheel_down += A_EventInfo
~Wheelup::Wheel_up += A_EventInfo

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;~ initial. very wrong
xLeft:=A_ScreenWidth
xRight:=0
yTop:=A_ScreenHeight
yBottom:=0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


#f1::
  FileDelete, Mausbewegungen.txt
  Mouse_moves =
  Wheel_up =
  Wheel_down =
  
  Time_old := A_TickCount
  TimeIndexPseudo:=0
  
  SetTimer, WatchMouse, Off
  SetTimer, WatchMouse, 10
  SetTimer, WatchMouse, on
Return

#f2::
  SetTimer, WatchMouse, Off
  ToolTip
Return

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#f3::
  MouseGetPos, xf3pos, yf3pos, idf3, Controlf3
  MsgBox, , Start moving , Start moving  , 2

  ; dont allow execution into recorded area
  ; if you want you could allow it
  borderPx:=30
  if( ( xLeft - borderPx > xf3pos OR xf3pos > xRight + borderPx ) AND ( yf3pos < yTop - borderPx OR yf3pos > yBottom + borderPx ) )
    Gosub, replay


  Sleep,600
  WinActivate, ahk_id %idf3%
  MouseMove, %xf3pos%, %yf3pos%
  



Return
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


;******************************************

WatchMouse:

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;~ by using of TimeIndexPseudo it moves without breaks
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Time_Index := A_TickCount - Time_old
  ;TimeIndexPseudo:=Time_Index
  
  MouseGetPos, xpos, ypos, id, Control
  GetKeyState, lButt, LButton
  GetKeyState, mButt, MButton
  GetKeyState, rButt, RButton
  Mouse_Data = %xpos%|%ypos%|%lButt%|%mButt%|%rButt%|%Wheel_up%|%Wheel_down%|%ID%|%TimeIndexPseudo%`n
  ;Mouse_Data = %xpos%|%ypos%|%lButt%|%mButt%|%rButt%|%Wheel_up%|%Wheel_down%|%ID%|%Time_Index%`n
  ;If (xpos<>xpos_old OR ypos<>ypos_old )
  xd:=Abs(xpos - xpos_old)
  yd:=Abs(ypos - ypos_old)
  xdyd:= (xd) * (yd) ; exponetial
  
  if(lButt="D")
    sensitivity:=50
  else
    sensitivity:=500
  
  If ( xdyd > sensitivity OR Wheel_up OR Wheel_down OR lButt<>Lbutt_old OR mButt<>mButt_old OR rButt<>rButt_old)
{ 
  ;If (xpos<>xpos_old OR ypos<>ypos_old OR Wheel_up OR Wheel_down OR lButt<>Lbutt_old OR mButt<>mButt_old OR rButt<>rButt_old)

      if(xLeft > xpos)
        xLeft := xpos
      
      if(yTop < ypos)
        yTop := ypos
      

      if( not xLeft )
        xLeft := xpos
      if( not yTop)
        yTop := ypos

      

      if(xRight < xpos)
        xRight := xpos
      
      if(yBottom > ypos)
        yBottom := ypos

      ToolTip, recording %xdyd% lButt=%lButt%
      FileAppend, %Mouse_data%, Mausbewegungen.txt
      xpos_old  := xpos
      ypos_old  := ypos
      lButt_old := lButt
      mButt_old := mButt
      rButt_old := rButt
      Wheel_up =
      Wheel_down =
      TimeIndexPseudo:=TimeIndexPseudo+1
    }
Return

;*******************************************

replay:
  FileRead,Mouse_moves, Mausbewegungen.txt
  StringReplace, Mouse_data, Mouse_moves, `n, @, All
  StringSplit, Mouse_data_, Mouse_data , @
  Loop, %Mouse_data_0%
      StringSplit, Mouse_data_%A_Index%_, Mouse_data_%A_Index% ,|
  Data_Index = 1
  Data_Index_old := 1
  id := Mouse_data_1_8
  WinActivate, ahk_id %id%
  Time_old := A_TickCount
  SetTimer, Replaytimer, Off
  SetTimer, Replaytimer, 1
  SetTimer, Replaytimer, on
Return

;********************************************

replaytimer:

  mouseSleepMiliSec:=0

  Time_Index := A_TickCount - Time_old
  Mouse_data_%Data_Index%_9 += 0

  If (Time_Index > Mouse_data_%Data_Index%_9)
    {
      mouseSleepMiliSec:=0
      MouseMove, Mouse_data_%Data_Index%_1, Mouse_data_%Data_Index%_2,%mouseSleepMiliSec%
      ;MouseMove, X, Y [, Speed, R]
      lButt := Mouse_data_%Data_Index%_3
      mButt := Mouse_data_%Data_Index%_4
      rButt := Mouse_data_%Data_Index%_5
      wheel_up := Mouse_data_%Data_Index%_6
      wheel_down := Mouse_data_%Data_Index%_7

      If (Mouse_data_%Data_Index_old%_3 <> Mouse_data_%Data_Index%_3)
          MouseClick , Left ,,,,, %lButt%
      If (Mouse_data_%Data_Index_old%_4 <> Mouse_data_%Data_Index%_4)
          MouseClick , middle ,,,,, %mButt%
      If (Mouse_data_%Data_Index_old%_5 <> Mouse_data_%Data_Index%_5)
          MouseClick , Right ,,,,, %rButt%
      If (Mouse_data_%Data_Index%_6)
          MouseClick, WheelUp, , , %wheel_up%       
      If (Mouse_data_%Data_Index%_7)
          MouseClick, Wheeldown, , , %wheel_down%       

      Data_Index_old := Data_Index
      Data_Index += 1
      If (Data_Index = Mouse_data_0)
        {
          SetTimer Replaytimer, Off
          Data_Index = 0
        }
    }
;~  x := Mouse_data_%Data_Index%_9
;~  tooltip %Time_Index%_%A_TickCount% - %Time_old% __%x%

Return
