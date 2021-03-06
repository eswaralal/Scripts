'==========================================================================
'
' VBScript Source File -- Created with SAPIEN Technologies PrimalScript 2011
'
' NAME: RunAllScriptsAndImportAllREGs.vbs
'
' AUTHOR: BrianG , 
' DATE  : 11/26/2013
'
' COMMENT: Script runs all .CMD files in the script directory as well as
'	imports all .reg files.
'
'==========================================================================
On Error Resume Next
'Setup Objects and Constants
Const cForReading = 1, cForWriting = 2, cForAppending = 8
sScriptVersion = "11.26.2013"
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oShell = WScript.CreateObject("WScript.Shell")
sScriptFolPath = oFSO.GetParentFolderName(Wscript.ScriptFullName) 'No trailing backslash
sLogFilePath = "C:\Windows\Temp\RunAllScriptsAndImportAllREGs.log"

'Main Execution section of script
'==========================================================================
Set oLogFile = oFSO.OpenTextFile(sLogFilePath, cForWriting, True)
oLogFile.WriteLine "RunAllScriptsAndImportAllREGs script (v" & sScriptVersion & ") has begun on " & Date

Set oFolder = oFSO.GetFolder(sScriptFolPath)
Set cFiles = oFolder.Files
For Each oFile in cFiles
      If UCase(oFSO.GetExtensionName(oFile.name)) = "CMD" Then
            Wscript.Echo oFile.Name
			'oShell.Run "%ComSpec% /c """ & oFile.Name & """", 1, True
      End If
Next

For Each oFile in cFiles
      If UCase(oFSO.GetExtensionName(oFile.name)) = "REG" Then
            Wscript.Echo oFile.Name
			'oShell.Run "%ComSpec% /c reg.exe import """ & sScriptFolPath & "\" & oFile.Name & """", 1, True
      End If
Next

oLogFile.WriteLine "RunAllScriptsAndImportAllREGs script has completed."