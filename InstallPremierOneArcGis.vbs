'//----------------------------------------------------------------------------
'// Purpose: Used to Install Arc Gis.
'// Version: 1.0 - November 27, 2013 - Brian Gonzalez
'//
'//----------------------------------------------------------------------------

'//----------------------------------------------------------------------------
'// Global constant and variable declarations
'//---------------------------------------------------------------------------- 

Dim iRetVal 

'//----------------------------------------------------------------------------
'// End declarations
'//---------------------------------------------------------------------------- 

'//----------------------------------------------------------------------------
'// Main routine
'//---------------------------------------------------------------------------- 

On Error Resume Next
iRetVal = ZTIProcess
ProcessResults iRetVal
On Error Goto 0 

'//---------------------------------------------------------------------------
'//
'// Function: ZTIProcess()
'//
'// Input: None
'// 
'// Return: Success - 0
'// Failure - non-zero
'//
'// Purpose: Perform main ZTI processing
'// 
'//---------------------------------------------------------------------------
Function ZTIProcess() 

	Dim sFile

	oLogging.CreateEntry "Install Arc Gis: Starting SQL Server 2012 installation", LogTypeInfo
	
	' Install Arc Gis
	sFile = oUtility.ScriptDir & "\PremierOne-ArcGis_10.0.3200.0.exe"

	If not oFSO.FileExists(sFile) then
		oLogging.CreateEntry "Install Arc Gis: " & sFile & " was not found, unable to Install Arc Gis", LogTypeError
		ZTIProcess = Failure
		Exit Function
	End if

	oLogging.CreateEntry """" & sFile & """", LogTypeInfo
	
	iRetVal = oUtility.RunWithHeartbeat("""" & sFile & """")

	oLogging.CreateEntry "Kicked off installer, now waiting for aioInstaller.exe to Exit.", LogTypeInfo

	sProcess = "aioInstaller.exe"
	Do Until blnRunning = "False"
		Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
		Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = '" & _
			sProcess & "'", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)
		WScript.Sleep 100 'Wait for 100 MilliSeconds
		If colItems.Count = 0 Then 'If no more processes are running, exit Loop
			blnRunning = False
		End If
	Loop

	oLogging.CreateEntry "aioInstaller.exe process no longer exists.", LogTypeInfo
	
	if (iRetVal = 0) or (iRetVal = 3010) then
		ZTIProcess = Success 
	Else 
		ZTIProcess = Failure
	End If

	oLogging.CreateEntry "Install Arc Gis: Return code from command = " & iRetVal, LogTypeInfo
	oLogging.CreateEntry "Install Arc Gis: Finished installation", LogTypeInfo
	
End Function
