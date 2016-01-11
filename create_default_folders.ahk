;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;~ please config it in this file near line 30
;>>>>>>>>>>>>>>>>>>>>>><>>>>>>>>>>>>>>>>>>>>>>>






 


pc=30ghz
createDir("R:\backup\pc\" . pc . "\R\Zend\Apache\htdocs\")
createDir("R:\backup\pc\" . pc . "\R\xampp\htdocs\Symfony\")

pc=24ghz
createDir("R:\backup\pc\" . pc . "\R\Zend\Apache\htdocs\")
createDir("R:\backup\pc\" . pc . "\R\xampp\htdocs\Symfony\")

pc=22ghz
createDir("R:\backup\pc\" . pc . "\R\Zend\Apache\htdocs\")
createDir("R:\backup\pc\" . pc . "\R\xampp\htdocs\Symfony\")

ExitApp

createDir(dir)
{
	if(isDir(dir))
		return,true
	fileCreateDirS(dir,"")
	return
}
fileCreateDirS(dir,addSecondDir="")
{
	growingPath := ""
	Loop, parse, dir, \
	{
		if(A_Index > 1)
			growingPath := growingPath . "\" . A_LoopField
		if(A_Index = 1)
		{
			growingPath := A_LoopField
			if(!FileExist(growingPath))
			{
				MsgBox, %A_Index%: !FileExist(%growingPath%)
				ExitApp
			}
			if(StrLen(addSecondDir)>0)
				growingPath := growingPath . "\" . addSecondDir
			backUpFolderRoot:=growingPath
		}
		if(!FileExist(growingPath))
		{
			;~ MsgBox, %A_Index% is %growingPath%.
			FileCreateDir,%growingPath%
		}
	}
	;~ MsgBox, %growingPath%.
	backUpFolder := growingPath
	return,backUpFolderRoot
}
isFile(Path)
{
   Return !InStr(FileExist(Path), "D") 
}

isDir(Path)
{
   Return !!InStr(FileExist(Path), "D") 
}

