#include %A_LineFile%\..\..\..\SharedFunctions\ObjRegisterActive.ahk

global g_PS_SettingsPath := A_LineFile . "\..\PotionSustain_Settings.json"

GUIFunctions.AddTab("Potion Sustain")
global g_PotionSustain := new IC_PotionSustain_Component
global g_PS_Running := false
global g_PS_StatusText
global g_PS_ChestSmallThreshMin
global g_PS_ChestSmallThreshMax
global g_PS_AutomateThreshMin
global g_PS_AutomateThreshMax

Gui, ICScriptHub:Tab, Potion Sustain
GUIFunctions.UseThemeTextColor("HeaderTextColor")
Gui, ICScriptHub:Font, w700
Gui, ICScriptHub:Add, Text, x15 y+15, Potion Sustain:
GUIFunctions.UseThemeTextColor("DefaultTextColor")
Gui, ICScriptHub:Font, w400
Gui, ICScriptHub:Add, Button, x145 y+-15 w100 vg_PotionSustainSave_Clicked, `Save Settings
buttonFunc := ObjBindMethod(g_PotionSustain, "SaveSettings")
GuiControl,ICScriptHub: +g, g_PotionSustainSave_Clicked, % buttonFunc
Gui, ICScriptHub:Add, Text, x5 y+10 w130 +Right, Status:
Gui, ICScriptHub:Add, Text, vg_PS_StatusText x145 y+-13 w400, Waiting for Gem Farm to start
Gui, ICScriptHub:Add, GroupBox, x15 y+10 Section w500 h115, Sustain Smalls
Gui, ICScriptHub:Add, Text, xs165 ys15 w50, Minimum
Gui, ICScriptHub:Add, Text, xs235 y+-13 w50, Maximum
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Small Potion Thresholds:
GUIFunctions.UseThemeTextColor("InputBoxTextColor")
Gui, ICScriptHub:Add, Edit, vg_PS_ChestSmallThreshMin xs160 y+-17 w60 +Right, 
Gui, ICScriptHub:Add, Edit, vg_PS_ChestSmallThreshMax xs230 y+-21 w60 +Right, 
GUIFunctions.UseThemeTextColor("DefaultTextColor")
Gui, ICScriptHub:Add, Text, xs300 y+-17, (For deciding to buy Silvers or Golds)
Gui, ICScriptHub:Add, Text, xs20 y+15 w130 +Right, Can Sustain Smalls:
Gui, ICScriptHub:Add, Text, vg_PS_AbleSustainSmallStatus xs160 y+-13 w200, Unknown
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Currently Buying Silvers:
Gui, ICScriptHub:Add, Text, vg_PS_BuyingSilversStatus xs160 y+-13 w200, Unknown
Gui, ICScriptHub:Add, GroupBox, x15 ys120 Section w500 h180, Automate Modron Potions
Gui, ICScriptHub:Add, Checkbox, vg_PS_Checkbox_EnableAlternating xs15 ys25, Enable automating potions in the modron?
Gui, ICScriptHub:Add, Text, xs165 y+10 w50, Minimum
Gui, ICScriptHub:Add, Text, xs235 y+-13 w50, Maximum
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Modron Potion Thresholds:
GUIFunctions.UseThemeTextColor("InputBoxTextColor")
Gui, ICScriptHub:Add, Edit, vg_PS_AutomateThreshMin xs160 y+-17 w60 +Right, 
Gui, ICScriptHub:Add, Edit, vg_PS_AutomateThreshMax xs230 y+-21 w60 +Right, 
GUIFunctions.UseThemeTextColor("DefaultTextColor")
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Sustain Bracket:
Gui, ICScriptHub:Add, Text, vg_PS_SustainBracketStatus xs160 y+-13 w130, Unknown
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Automation Status:
Gui, ICScriptHub:Add, Text, vg_PS_AutomationStatus xs160 y+-13 w330, Unknown
Gui, ICScriptHub:Add, Checkbox, vg_PS_Checkbox_DisableLarges xs15 y+15, Disable the use of Large potions?
Gui, ICScriptHub:Add, Checkbox, vg_PS_Checkbox_DisableHuges xs245 y+-13, Disable the use of Huge potions?
GUIFunctions.UseThemeTextColor("TableTextColor")
Gui, ICScriptHub:Add, ListView, xs300 ys15 w190 h100 vg_PS_AutomateList, Priority|Alternating|Status
GUIFunctions.UseThemeListViewBackgroundColor("g_PS_AutomateList")
GUIFunctions.UseThemeTextColor("DefaultTextColor")
Gui, ICScriptHub:Add, GroupBox, x15 ys185 Section w500 h140, Current Potion Amounts
Gui, ICScriptHub:Add, Text, xs20 ys+20 w130 +Right, Smalls:
Gui, ICScriptHub:Add, Text, vg_PS_SmallPotCountStatus xs160 y+-13 w60 +Right, Unknown
Gui, ICScriptHub:Add, Text, vg_PS_SmallPotWaxingStatus xs240 y+-13 w240, Unknown
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Mediums:
Gui, ICScriptHub:Add, Text, vg_PS_MediumPotCountStatus xs160 y+-13 w60 +Right, Unknown
Gui, ICScriptHub:Add, Text, vg_PS_MediumPotWaxingStatus xs240 y+-13 w240, Unknown
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Larges:
Gui, ICScriptHub:Add, Text, vg_PS_LargePotCountStatus xs160 y+-13 w60 +Right, Unknown
Gui, ICScriptHub:Add, Text, vg_PS_LargePotWaxingStatus xs240 y+-13 w240, Unknown
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Huges:
Gui, ICScriptHub:Add, Text, vg_PS_HugePotCountStatus xs160 y+-13 w60 +Right, Unknown
Gui, ICScriptHub:Add, Text, vg_PS_HugePotWaxingStatus xs240 y+-13 w240, Unknown
Gui, ICScriptHub:Add, Text, xs20 y+10 w130 +Right, Gem Hunters:
Gui, ICScriptHub:Add, Text, vg_PS_GemHunterPotCountStatus xs160 y+-13 w60 +Right, Unknown
Gui, ICScriptHub:Add, Text, vg_PS_GemHunterStatus xs240 y+-13 w240, Unknown
;Gui, ICScriptHub:Add, Button, x145 y+15 w100 vg_Test_Clicked, `Test
;buttonFunc := ObjBindMethod(g_PotionSustain, "Test")
;GuiControl,ICScriptHub: +g, g_Test_Clicked, % buttonFunc

if(IsObject(IC_BrivGemFarm_Component))
    g_PotionSustain.InjectAddon()
else
{
    GuiControl, ICScriptHub:Text, g_PS_StatusText, WARNING: This addon needs IC_BrivGemFarm enabled.
    Gui, Submit, NoHide
    return
}

g_PotionSustain.Init()

/*  IC_PotionSustain_Component
    Class that manages the GUI for IC_PotionSustain.

*/
Class IC_PotionSustain_Component
{
    Settings := ""
    TempSettings := new IC_PotionSustain_Component._IC_PotionSustain_TempSettings
    TimerFunctions := ""
	SanitySize := 5000
	Testing := false
	TestIndex := 0
	TestResetZone := 1300
	
	UserData := ""
	RunsCount := -1
	ModronResetZone := -1
	PotIDs := {"s":74,"m":75,"l":76,"h":77,"gh":1723}
	PotAmounts := {"s":-1,"m":-1,"l":-1,"h":-1,"gh":0}
	ChestSmallPotMinThresh := 50
	ChestSmallPotMaxThresh := 100
	ChestSmallPotWaxing := false
	AutomatePotMinThresh := 50
	AutomatePotMaxThresh := 500
	ChestSmallPotBuying := false
	SustainSmallAbility := "Unknown"
	EnableAlternating := false
	WaxingPots := {"s":false,"m":false,"l":false,"h":false}
	Using := "Using"
	NotEnough := "Not Enough"
	Blocked := "Blocked"
	ListSize := 0
	SaveModronParams := ""
	ModronCallParams := ""
	InstanceId := ""
	ForceChange := false
	FoundHighAreaPot := false
	DisableLarge := false
	DisableHuge := false
	GemHunter := 0
	ModronSaveCallResponse := ""
	PendingCall := false

    InjectAddon()
    {
        splitStr := StrSplit(A_LineFile, "\")
        addonDirLoc := splitStr[(splitStr.Count()-1)]
        addonLoc := "#include *i %A_LineFile%\..\..\" . addonDirLoc . "\IC_PotionSustain_Addon.ahk`n"
        FileAppend, %addonLoc%, %g_BrivFarmModLoc%
        OutputDebug, % addonLoc . " to " . g_BrivFarmModLoc
    }
	
    ; GUI startup
    Init()
    {
        Global
        Gui, Submit, NoHide
		this.LoadSettings()
        GuiControl, ICScriptHub:, g_PS_StatusText, Waiting for Gem Farm to start.
		GuiControl, ICScriptHub:, g_PS_SmallPotCountStatus, Unknown
        this.CreateTimedFunctions()
		this.RunsCount := g_SF.Memory.ReadResetsCount()
		g_ServerCall.UpdatePlayServer()
        g_SF.ResetServerCall()
		this.CalculateSmallPotionSustain()
        this.Start()
		this.ForceChange := true
		this.OverrideGemFarmBuyOpenCheckboxes()
    }
	
	OverrideGemFarmBuyOpenCheckboxes()
	{
		GuiControl, ICScriptHub:Text, BuySilversCheck, Buy silver chests? (Overridden by Potion Sustain)
		GuiControl, ICScriptHub:Text, BuyGoldsCheck, Buy gold chests? (Overridden by Potion Sustain)
		GuiControl, ICScriptHub:Text, OpenSilversCheck, Open silver chests? (Overridden by Potion Sustain)
		GuiControl, ICScriptHub:Text, OpenGoldsCheck, Open gold chests? (Overridden by Potion Sustain)
		GuiControl, ICScriptHub:Move, BuySilversCheck,w400
		GuiControl, ICScriptHub:Move, BuyGoldsCheck,w400
		GuiControl, ICScriptHub:Move, OpenSilversCheck,w400
		GuiControl, ICScriptHub:Move, OpenGoldsCheck,w400
		GuiControl, ICScriptHub:Disable, BuySilversCheck
		GuiControl, ICScriptHub:Disable, BuyGoldsCheck
		GuiControl, ICScriptHub:Disable, OpenSilversCheck
		GuiControl, ICScriptHub:Disable, OpenGoldsCheck
	}
	
    ; Loads settings from the addon's setting.json file.
    LoadSettings()
    {
		Global
        Gui, Submit, NoHide
        writeSettings := False
        this.Settings := g_SF.LoadObjectFromJSON(g_PS_SettingsPath)
        if(!IsObject(this.Settings) OR this.Settings["SmallThresh"] != "")
        {
            this.DefaultSettings()
            writeSettings := True
        }
        if(writeSettings)
        {
            g_SF.WriteObjectToJSON(g_PS_SettingsPath, this.Settings)
        }
        GuiControl, ICScriptHub:, g_PS_ChestSmallThreshMin, % this.Settings["SmallThreshMin"]
        GuiControl, ICScriptHub:, g_PS_ChestSmallThreshMax, % this.Settings["SmallThreshMax"]
		GuiControl, ICScriptHub:, g_PS_AutomateThreshMin, % this.Settings["AutomateThreshMin"]
		GuiControl, ICScriptHub:, g_PS_AutomateThreshMax, % this.Settings["AutomateThreshMax"]
		GuiControl, ICScriptHub:, g_PS_Checkbox_EnableAlternating, % this.Settings["Alternate"]
		GuiControl, ICScriptHub:, g_PS_Checkbox_DisableLarges, % this.Settings["DisableLarges"]
		GuiControl, ICScriptHub:, g_PS_Checkbox_DisableHuges, % this.Settings["DisableHuges"]
		this.ChestSmallPotMinThresh := this.Settings["SmallThreshMin"]
		this.ChestSmallPotMaxThresh := this.Settings["SmallThreshMax"]
		this.AutomatePotMinThresh := this.Settings["AutomateThreshMin"]
		this.AutomatePotMaxThresh := this.Settings["AutomateThreshMax"]
		this.EnableAlternating := this.Settings["Alternate"]
		this.DisableLarge := this.Settings["DisableLarges"]
		this.DisableHuge := this.Settings["DisableHuges"]
        this.UpdateGUI()
    }
    
    ; Saves settings to addon's setting.json file.
    SaveSettings()
    {
		Global
        Gui, Submit, NoHide
        this.Settings["SmallThreshMin"] := g_PS_ChestSmallThreshMin
        this.Settings["SmallThreshMax"] := g_PS_ChestSmallThreshMax
        this.Settings["AutomateThreshMin"] := g_PS_AutomateThreshMin
        this.Settings["AutomateThreshMax"] := g_PS_AutomateThreshMax
		this.Settings["Alternate"] := g_PS_Checkbox_EnableAlternating
		this.Settings["DisableLarges"] := g_PS_Checkbox_DisableLarges
		this.Settings["DisableHuges"] := g_PS_Checkbox_DisableHuges
		this.ChestSmallPotMinThresh := g_PS_ChestSmallThreshMin
		this.ChestSmallPotMaxThresh := g_PS_ChestSmallThreshMax
		this.AutomatePotMinThresh := g_PS_AutomateThreshMin
		this.AutomatePotMaxThresh := g_PS_AutomateThreshMax
		this.EnableAlternating := g_PS_Checkbox_EnableAlternating
		this.DisableLarge := g_PS_Checkbox_DisableLarges
		this.DisableHuge := g_PS_Checkbox_DisableHuges
		if (!this.EnableAlternating)
		{
			this.ModronCallParams := ""
			try ; avoid thrown errors when comobject is not available.
			{
				SharedRunData := ComObjActive(g_BrivFarm.GemFarmGUID)
				SharedRunData.PSBGF_SetModronCallParams(this.ModronCallParams)
			}
		}
        g_SF.WriteObjectToJSON(g_PS_SettingsPath, this.Settings )
		this.ForceChange := true
        this.UpdateGUI()
    }
	
	DefaultSettings()
	{
		Global
		this.Settings := {}
		this.Settings["SmallThreshMin"] := 150
		this.Settings["SmallThreshMax"] := 200
		this.Settings["AutomateThreshMin"] := 100
		this.Settings["AutomateThreshMax"] := 150
		this.Settings["Alternate"] := false
		this.Settings["DisableLarges"] := false
		this.Settings["DisableHuges"] := false
	}

    ; Adds timed functions to be run when briv gem farm is started
    CreateTimedFunctions()
    {
        this.TimerFunctions := {}
        fncToCallOnTimer := ObjBindMethod(this, "UpdateTick")
        this.TimerFunctions[fncToCallOnTimer] := 500
        g_BrivFarmAddonStartFunctions.Push(ObjBindMethod(this, "Start"))
        g_BrivFarmAddonStopFunctions.Push(ObjBindMethod(this, "Stop"))
    }
	
	Test()
	{
		; Testing stuff
	}

    ; Updates status on a timer
    UpdateTick()
    {
		this.UpdateAutomationStatus("Idle.")
		currRuns := this.Testing ? this.TestIndex : g_SF.Memory.ReadResetsCount()
		this.SaveModronParams := ""
		if (currRuns > 0 AND (this.PotAmounts["s"] < 0 OR (this.ListSize == 0 AND this.EnableAlternating) OR this.RunsCount != currRuns))
		{
			this.RunsCount := currRuns
			;this.GemHunter := this.ReadActiveGemHunter()
			oldPotAmounts := this.ObjFullyClone(this.PotAmounts)
			size := g_SF.Memory.ReadInventoryItemsCount()
			if (this.PotAmounts["s"] < 0 OR (size >= 1 AND size <= this.SanitySize))
			{
				this.UpdateAutomationStatus("Updating Potion Amounts")
				loop, %size%
				{
					buffID := g_SF.Memory.ReadInventoryBuffIDBySlot(A_Index)
					amount := g_SF.Memory.ReadInventoryBuffCountBySlot(A_Index)
					for k,v in this.PotIDs
					{
						if (buffID==v)
							this.PotAmounts[k] := amount
					}
				}
				for k,v in this.PotAmounts
				{
					if (v == -1)
						this.PotAmounts[k] = 0
				}
				smalls := this.PotAmounts["s"]
				if (smalls >= 0 AND smalls <= this.ChestSmallPotMinThresh AND this.ChestSmallPotMinThresh >= 0)
					this.ChestSmallPotBuying := true
				else if (smalls >= this.ChestSmallPotMaxThresh)
					this.ChestSmallPotBuying := false
			}
			needAChange := false
			for k,v in this.PotAmounts
			{
				if (((oldPotAmounts[k] > this.AutomatePotMinThresh AND v <= this.AutomatePotMinThresh) OR (oldPotAmounts[k] < this.AutomatePotMaxThresh AND v >= this.AutomatePotMaxThresh) OR (v < oldPotAmounts[k] AND oldPotAmounts[k] <= this.AutomatePotMinThresh)) AND !this.AreObjectsEqual(oldPotAmounts, this.PotAmounts))
				{
					needAChange := true
					break
				}
			}
			Random,randChance,1,100
			if ((this.ListSize == 0 OR needAChange OR this.ForceChange OR randChance <= 25) AND g_PS_Running AND this.EnableAlternating)
			{
				this.UpdateAutomationStatus("Recalculating...")
				needAChange := false
				this.ForceChange := false
				this.GemHunter := 0
				this.UserData := g_ServerCall.CallUserDetails()
				if(IsObject(this.UserData) AND this.UserData.success)
					this.GemHunter := this.CheckUserDataForGemHunter(this.UserData.details.buffs)
				calcAuto := this.CalculateAutomationBuffs()
				if(IsObject(this.UserData) AND this.UserData.success)
					this.SaveModronParams := this.GetSaveModronParams(this.UserData.details.modron_saves,calcAuto)
			}
		}
        try ; avoid thrown errors when comobject is not available.
        {
			this.ModronResetZone := this.Testing ? this.TestResetZone : g_SF.Memory.GetModronResetArea()
			this.CalculateSmallPotionSustain()
            SharedRunData := ComObjActive(g_BrivFarm.GemFarmGUID)
            if (SharedRunData.PSBGF_Running() == "") ; Addon running check
            {
                GuiControl, ICScriptHub:Text, g_PS_StatusText, Not running. Loaded after Gem Farm script. Stop and Start.
            }
			else if (SharedRunData.PSBGF_Running())
			{
                GuiControl, ICScriptHub:Text, g_PS_StatusText, Running.
				g_PS_Running := true
				this.PendingCall := SharedRunData.PSBGF_GetIsDifferentCall()
				instanceId := g_SF.Memory.ReadInstanceID()
				if (instanceId != this.InstanceId AND instanceId != "" AND instanceId > 0)
				{
					this.InstanceId := instanceId
					SharedRunData.PSBGF_SetInstanceId(instanceId)
				}
				if (this.ChestSmallPotBuying != SharedRunData.PSBGF_GetBuySilvers())
					SharedRunData.PSBGF_SetBuySilvers(this.ChestSmallPotBuying)
				if (this.EnableAlternating AND this.SaveModronParams != "" AND this.SaveModronParams != this.ModronCallParams)
				{
					this.ModronCallParams := this.SaveModronParams
					SharedRunData.PSBGF_SetModronCallParams(this.SaveModronParams)
					this.PendingCall := SharedRunData.PSBGF_GetIsDifferentCall()
				}
				this.ModronSaveCallResponse := SharedRunData.PSBGF_GetResponse()
			}
			else
			{
				this.UpdateAutomationStatus("Connection to gem farm script is broken.")
				GuiControl, ICScriptHub:Text, g_PS_StatusText, Connection to gem farm script is broken.
				GuiControl, ICScriptHub:Text, g_PS_AbleSustainSmallStatus, Unknown
				GuiControl, ICScriptHub:Text, g_PS_SmallPotCountStatus, Unknown
			}
        }
        catch
        {
			this.UpdateAutomationStatus("Not Running")
            GuiControl, ICScriptHub:Text, g_PS_StatusText, Waiting for Gem Farm to start.
			GuiControl, ICScriptHub:Text, g_PS_AbleSustainSmallStatus, Unknown
            GuiControl, ICScriptHub:Text, g_PS_SmallPotCountStatus, Unknown
        }
		this.UpdateGUI()
    }
	
	UpdateAutomationStatus(status)
	{
		if (!this.EnableAlternating)
			GuiControl, ICScriptHub:Text, g_PS_AutomationStatus, Off
		else if (status == "Idle.")
		{
			if (this.ModronSaveCallResponse != "")
				status := "Warning: Modron save call seems to have failed. Check logs."
			else if (this.FoundHighAreaPot)
				status := "Warning: A potion in the Modron has a zone greater than 1."
			else if (this.PendingCall)
				status := "Pending potion swapping. Waiting for next offline stack."
		}
		GuiControl, ICScriptHub:Text, g_PS_AutomationStatus, % status
		Gui, Submit, NoHide
	}

    Start()
    {
		this.UpdateTick()
        for k,v in this.TimerFunctions
            SetTimer, %k%, %v%, 0
        GuiControl, ICScriptHub:Text, g_PS_StatusText, Running.
    }

    Stop()
    {
        for k,v in this.TimerFunctions
        {
            SetTimer, %k%, Off
            SetTimer, %k%, Delete
        }
        GuiControl, ICScriptHub:Text, g_PS_StatusText, Waiting for Gem Farm to start
		GuiControl, ICScriptHub:Text, g_PS_AbleSustainSmallStatus, Unknown
        GuiControl, ICScriptHub:Text, g_PS_SmallPotCountStatus, Unknown
		GuiControl, ICScriptHub:Text, g_PS_SustainBracketStatus, Unknown
		GuiControl, ICScriptHub:Text, g_PS_AutomationStatus, Unknown
		Gui, Submit, NoHide
    }
	
	UpdateGUI()
	{
		waxing := "Unavailable. Restocking."
		waning := "Available."
		blocked := "Blocked by user."
		GuiControl, ICScriptHub:Text, g_PS_SmallPotCountStatus, % this.PotAmounts["s"]
		GuiControl, ICScriptHub:Text, g_PS_MediumPotCountStatus, % this.PotAmounts["m"]
		GuiControl, ICScriptHub:Text, g_PS_LargePotCountStatus, % this.PotAmounts["l"]
		GuiControl, ICScriptHub:Text, g_PS_HugePotCountStatus, % this.PotAmounts["h"]
		GuiControl, ICScriptHub:Text, g_PS_GemHunterPotCountStatus, % this.PotAmounts["gh"]
		GuiControl, ICScriptHub:Text, g_PS_SmallPotWaxingStatus, % this.WaxingPots["s"] ? waxing : waning
		GuiControl, ICScriptHub:Text, g_PS_MediumPotWaxingStatus, % this.WaxingPots["m"] ? waxing : waning
		GuiControl, ICScriptHub:Text, g_PS_LargePotWaxingStatus, % this.Settings["DisableLarges"] ? blocked : this.WaxingPots["l"] ? waxing : waning
		GuiControl, ICScriptHub:Text, g_PS_HugePotWaxingStatus, % this.Settings["DisableHuges"] ? blocked : this.WaxingPots["h"] ? waxing : waning
		GuiControl, ICScriptHub:Text, g_PS_GemHunterStatus, % this.GemHunter > 0 ? "Active: " . (this.FmtSecs(this.GemHunter)) . " remaining." : "Inactive."
		GuiControl, ICScriptHub:Text, g_PS_AbleSustainSmallStatus, % this.SustainSmallAbility
		GuiControl, ICScriptHub:Text, g_PS_BuyingSilversStatus, % this.ChestSmallPotBuying ? "Yes." : "No."
		Gui, Submit, NoHide
	}
	
	CalculateSmallPotionSustain()
	{
		smallSustain := this.GemHunter > 0 ? 475 : 655
		rz := this.ModronResetZone
		if (rz < 1 OR rz == "")
			this.SustainSmallAbility := "Unknown"
		else if (this.ModronResetZone < smallSustain)
			this.SustainSmallAbility := "Modron reset of z" . rz . " is too low to sustain. " . smallSustain . "+ needed."
		else
			this.SustainSmallAbility := "Modron reset of z" . rz . " allows sustaining."
	}
	
	CalculateAutomationBuffs()
	{
        restore_gui_on_return := GUIFunctions.LV_Scope("ICScriptHub", "g_PS_AutomateList")
        LV_Delete()
		this.ListSize := 0
		; Bad modron read - flee.
		if (this.ModronResetZone < 1)
			return
		; Bad threshold read - flee.
		if (this.AutomatePotMinThresh < 0 OR this.AutomatePotMaxThresh < 0)
			return
		; Bad pot reads - flee.
		for k,v in this.PotAmounts
		{
			if (v < 0)
				return
		}
		; Deal with waxing.
		for k,v in this.PotAmounts
		{
			if (v <= this.AutomatePotMinThresh)
				this.WaxingPots[k] := true
			if (v >= this.AutomatePotMaxThresh)
				this.WaxingPots[k] := false
		}
		; Sustaining mediums.
		; Only use if modron reset is 1175+ (or 885+GH) and medium pots are above the minimum threshold.
		lZone := 3025
		mZone := 1175
		sZone := 655
		if (this.GemHunter > 0)
		{
			lZone := 2290
			mZone := 885
			sZone := 475
		}
		calcAuto := {}
		; Sustaining larges.
		; Only use if modron reset is 3025+ (or 2290+GH) and large pots are above the minimum threshold and large pots are not disabled.
		if (this.ModronResetZone >= lZone AND this.PotAmounts["l"] > this.AutomatePotMinThresh AND !this.DisableLarge)
			calcAuto := this.CalculateSustainLarges()
		; Sustaining mediums.
		; Only use if modron reset is 1175+ (or 885+GH) and medium pots are above the minimum threshold.
		else if (this.ModronResetZone >= mZone AND this.PotAmounts["m"] > this.AutomatePotMinThresh)
			calcAuto := this.CalculateSustainMediums()
		; Sustaining smalls.
		; Only use if modron reset is 655+ (or 475+GH) and small pots are above the minimum threshold.
		else if (this.ModronResetZone >= sZone AND this.PotAmounts["s"] > this.AutomatePotMinThresh)
			calcAuto := this.CalculateSustainSmalls()
		; Sustaining nothing.
		; Only use as a last resort.
		else
			calcAuto := this.CalculateSustainNone()
		LV_ModifyCol(1, 45)
		LV_ModifyCol(2, 65)
		LV_ModifyCol(3, 75)
		Gui, Submit, NoHide
		return calcAuto
	}
	
	CalculateSustainLarges()
	{
		; Set can use larges.
		GuiControl, ICScriptHub:Text, g_PS_SustainBracketStatus, Larges + Others.
		calcAuto := {this.PotIDs["l"]:1}
		status := ["---","---","---","---"]
		if (this.PotAmounts["m"] >= this.AutomatePotMinThresh AND !this.WaxingPots["m"])
		{
			calcAuto[this.PotIDs["m"]] := 1
			status[1] := this.Using
		}
		else if (!this.DisableHuge AND this.PotAmounts["h"] >= this.AutomatePotMinThresh AND !this.WaxingPots["h"])
		{
			calcAuto[this.PotIDs["h"]] := 1
			status[1] := this.NotEnough
			status[2] := this.Using
		}
		else if (this.PotAmounts["s"] >= this.AutomatePotMinThresh AND !this.WaxingPots["s"])
		{
			calcAuto[this.PotIDs["s"]] := 1
			status[1] := this.NotEnough
			status[2] := this.DisableHuge ? this.Blocked : this.NotEnough
			status[3] := this.Using
		}
		else
		{
			status[1] := this.NotEnough
			status[2] := this.DisableHuge ? this.Blocked : this.NotEnough
			status[3] := this.NotEnough
			status[4] := this.Using
		}
		LV_Add(,1,"l + m",status[1])
		LV_Add(,2,"l + h",status[2])
		LV_Add(,3,"l + s",status[3])
		LV_Add(,4,"l",status[4])
		this.ListSize := 4
		return calcAuto
	}
	
	CalculateSustainMediums()
	{
		; Set can use mediums.
		GuiControl, ICScriptHub:Text, g_PS_SustainBracketStatus, Mediums + Others.
		calcAuto := {this.PotIDs["m"]:1}
		status := ["---","---","---","---"]
		if (!this.DisableLarge AND this.PotAmounts["l"] >= this.AutomatePotMinThresh AND !this.WaxingPots["l"])
		{
			calcAuto[this.PotIDs["l"]] := 1
			status[1] := this.Using
		}
		else if (!this.DisableHuge AND this.PotAmounts["h"] >= this.AutomatePotMinThresh AND !this.WaxingPots["h"])
		{
			calcAuto[this.PotIDs["h"]] := 1
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.Using
		}
		else if (this.PotAmounts["s"] >= this.AutomatePotMinThresh AND !this.WaxingPots["s"])
		{
			calcAuto[this.PotIDs["s"]] := 1
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.DisableHuge ? this.Blocked : this.NotEnough
			status[3] := this.Using
		}
		else
		{
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.DisableHuge ? this.Blocked : this.NotEnough
			status[3] := this.NotEnough
			status[4] := this.Using
		}
		LV_Add(,1,"m + l",status[1])
		LV_Add(,2,"m + h",status[2])
		LV_Add(,3,"m + s",status[3])
		LV_Add(,4,"m",status[4])
		this.ListSize := 4
		return calcAuto
	}
	
	CalculateSustainSmalls()
	{
		; Set can use smalls.
		GuiControl, ICScriptHub:Text, g_PS_SustainBracketStatus, Smalls + Others.
		calcAuto := {this.PotIDs["s"]:1}
		status := ["---","---","---","---"]
		if (!this.DisableLarge AND this.PotAmounts["l"] >= this.AutomatePotMinThresh AND !this.WaxingPots["l"])
		{
			calcAuto[this.PotIDs["l"]] := 1
			status[1] := this.Using
		}
		else if (!this.DisableHuge AND this.PotAmounts["h"] >= this.AutomatePotMinThresh AND !this.WaxingPots["h"])
		{
			calcAuto[this.PotIDs["h"]] := 1
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.Using
		}
		else if (this.PotAmounts["m"] >= this.AutomatePotMinThresh AND !this.WaxingPots["m"])
		{
			calcAuto[this.PotIDs["m"]] := 1
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.DisableHuge ? this.Blocked : this.NotEnough
			status[3] := this.Using
		}
		else
		{
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.DisableHuge ? this.Blocked : this.NotEnough
			status[3] := this.NotEnough
			status[4] := this.Using
		}
		LV_Add(,1,"s + l",status[1])
		LV_Add(,2,"s + h",status[2])
		LV_Add(,3,"s + m",status[3])
		LV_Add(,4,"s",status[4])
		this.ListSize := 4
		return calcAuto
	}
	
	CalculateSustainNone()
	{
		; Set can use smalls.
		GuiControl, ICScriptHub:Text, g_PS_SustainBracketStatus, Anything available.
		calcAuto := {}
		status := ["---","---","---","---"]
		if (!this.DisableLarge AND this.PotAmounts["l"] >= this.AutomatePotMinThresh AND !this.WaxingPots["l"])
		{
			calcAuto[this.PotIDs["l"]] := 1
			status[1] := this.Using
		}
		else if (!this.DisableHuge AND this.PotAmounts["h"] >= this.AutomatePotMinThresh AND !this.WaxingPots["h"])
		{
			calcAuto[this.PotIDs["h"]] := 1
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.Using
		}
		else if (this.PotAmounts["m"] >= this.AutomatePotMinThresh AND !this.WaxingPots["m"])
		{
			calcAuto[this.PotIDs["m"]] := 1
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.DisableHuge ? this.Blocked : this.NotEnough
			status[3] := this.Using
		}
		else
		{
			calcAuto[this.PotIDs["s"]] := 1
			status[1] := this.DisableLarge ? this.Blocked : this.NotEnough
			status[2] := this.DisableHuge ? this.Blocked : this.NotEnough
			status[3] := this.NotEnough
			status[4] := this.Using
		}
		LV_Add(,1,"l",status[1])
		LV_Add(,2,"h",status[2])
		LV_Add(,3,"m",status[3])
		LV_Add(,4,"s",status[4])
		this.ListSize := 4
		return calcAuto
	}
	
	CheckUserDataForGemHunter(buffs)
	{
		for k,v in buffs
		{
			if (v.buff_id == 1723)
				return v.remaining_time
		}
		return 0
	}
	
	GetSaveModronParams(saves,calcAuto)
	{
		userId := g_SF.Memory.ReadUserID()
		userHash := g_SF.Memory.ReadUserHash()
		networkId := g_SF.Memory.ReadPlatform()
		version := g_SF.Memory.ReadBaseGameVersion()
		gameInstanceId := g_SF.Memory.ReadActiveGameInstance()
		params := ""
		this.FoundHighAreaPot := false
		for k,v in saves
		{
			if (v.instance_id != gameInstanceId)
				continue
			if (!this.AreObjectsEqual(calcAuto,v.buffs))
			{
				; Add non speed pots that might be included.
				for j,w in v.buffs
				{
					if (w > 1 AND !this.FoundHighAreaPot)
						this.FoundHighAreaPot := true
					if (!this.HasValue(this.PotIDs,j))
						calcAuto[j] := w
				}
			}
			if (!this.AreObjectsEqual(calcAuto,v.buffs))
				this.ForceChange := true
			params .= "&core_id=" . (v.core_id) . "&grid=" . (this.JsonifyArray(v.grid)) . "&game_instance_id=" . gameInstanceId . "&formation_saves=" . (this.JsonifyObject(v.formation_saves)) . "&area_goal=" . (v.area_goal) . "&buffs=" . (this.JsonifyObject(calcAuto)) . "&checkin_timestamp=" . (this.GetNowEpoch() + 600000) . "&properties={""formation_enabled"":true,""toggle_preferences"":{""formation"":true,""reset"":true,""buff"":true}}"
			break
		}
		params .= "&user_id=" . userID . "&hash=" . userHash . "&language_id=1&timestamp=0&request_id=0&network_id=" . networkId . "&mobile_client_version=" . version . "&include_free_play_objectives=true&instance_key=1&offline_v2_build=1&localization_aware=true"
		return params
	}
	
	GetSaveModronParamsFromMemory(calcAuto)
	{
		gameInstanceId := g_SF.Memory.ReadActiveGameInstance()
		params := ""
		
		modronSaveIndex := g_SF.Memory.GetCurrentModronSaveSlot()
		modronSaves := g_SF.Memory.GameManager.game.gameInstances[gameInstanceId].Controller.userData.ModronHandler.modronSaves[modronSaveIndex]
		calcAuto := this.JsonifyObject(this.ModifyCallBuffsBasedOnCurrentBuffs(modronSaves.Buffs,calcAuto))
		forms := this.JsonifyDictionary(modronSaves.FormationSaves)
		if (calcAuto == "" OR calcAuto == "{}" OR forms == "" OR forms == "{}")
			return ""
		
		params .= "&core_id=" . (modronSaves.CoreID.Read())
		;params .= "&grid=" . (g_SF.ReadModronGridArray(modronSaves))
		params .= "&game_instance_id=" . gameInstanceId
		params .= "&formation_saves=" . forms
		params .= "&area_goal=" . (modronSaves.targetArea.Read())
		params .= "&buffs=" . calcAuto
		params .= "&checkin_timestamp=" . (this.GetNowEpoch() + 600000)
		params .= "&properties={""formation_enabled"":true,""toggle_preferences"":{""formation"":true,""reset"":true,""buff"":true}}"
		
		params .= "&user_id=" . (g_SF.Memory.ReadUserID()) . "&hash=" . (g_SF.Memory.ReadUserHash()) . "&language_id=1&timestamp=0&request_id=0&network_id=" . (g_SF.Memory.ReadPlatform()) . "&mobile_client_version=" . (g_SF.Memory.ReadBaseGameVersion()) . "&include_free_play_objectives=true&instance_key=1&offline_v2_build=1&localization_aware=true"
		return params
	}
	
	ModifyCallBuffsBasedOnCurrentBuffs(currentBuffs,calcAuto)
	{
		buffsObj := this.ObjectifyDictionary(currentBuffs,,200)
		this.FoundHighAreaPot := false
		if (!this.AreObjectsEqual(buffsObj, calcAuto))
		{
			for j,w in buffsObj
			{
				if (w > 1 AND !this.FoundHighAreaPot)
					this.FoundHighAreaPot := true
				if (!this.HasValue(this.PotIDs,j))
					calcAuto[j] := w
			}
		}
		return calcAuto
	}
	
	ReadActiveGemHunter()
	{
		buffs := g_SF.Memory.GameManager.game.gameInstances[g_SF.Memory.GameInstance].BuffHandler.activeBuffs
		buffsSize := buffs.size.Read()
		if(buffsSize <= 0 OR buffsSize > 1000)
            return 0
		loop, %buffsSize%
		{
			if (buffs[A_Index - 1].BaseEffectString.Read() == "increase_boss_gems_percent,50")
				return buffs[A_Index - 1].RemainingTime.Read()
		}
		return 0
	}
	
	EncodeDecodeURI(str, encode := true, component := true) {
		static Doc, JS
		if !Doc {
			Doc := ComObjCreate("htmlfile")
			Doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
			JS := Doc.parentWindow
			( Doc.documentMode < 9 && JS.execScript() )
		}
		ret := JS[ (encode ? "en" : "de") . "codeURI" . (component ? "Component" : "") ](str)
		StringLower, ret, ret
		return ret
	}
	
    AreObjectsEqual(obj1 := "", obj2 := "")
    {
        if (obj1.Count() != obj2.Count())
            return false
        if (!IsObject(obj1))
            return !IsObject(obj2) && (obj1 == obj2)
        for k, v in obj1
        {
            if (IsObject(v) && !this.AreObjectsEqual(obj2[k], v))
                return false
            else if (!IsObject(v) && obj2[k] != v && obj2.HasKey(k))
                return false
        }
        return true
    }
	
	ObjFullyClone(obj)
	{
		nobj := obj.Clone()
		for k,v in nobj
			if IsObject(v)
				nobj[k] := A_ThisFunc.(v)
		return nobj
	}
	
	HasValue(obj,val)
	{
		for k,v in obj
			if (v == val)
				return true
		return false
	}
	
	JsonifyObject(obj)
	{
		if (!IsObject(obj))
			return obj
		jsonObj := "{"
		first := true
		for k,v in obj
		{
			if (first)
				first := false
			else
				jsonObj .= ","
			if (IsObject(v))
				jsonObj .= """" k """:" (this.JsonifyObject(v))
			else
				jsonObj .= """" k """:" v
		}
		jsonObj .= "}"
		return jsonObj
	}
	
	JsonifyArray(arr)
	{
		if (!IsObject(arr))
			return arr
		size := arr.MaxIndex()
		jsonArr := "["
		loop, %size%
		{
			if (A_Index > 1)
				jsonArr .= ","
			if (IsObject(arr[A_Index]))
				jsonArr .= (this.JsonifyArray(arr[A_Index]))
			else
				jsonArr .= arr[A_Index]
		}
		jsonArr .= "]"
		return jsonArr
	}
	
	JsonifyDictionary(dict, sanityMin := 0, sanityMax := 50000)
	{
		dictSize := dict.size.Read()
		if (dictSize < sanityMin OR dictSize > sanityMax)
			return ""
		json := "{"
		loop, %dictSize%
		{
			if (A_Index > 1)
				json .= ","
			key := dict["key", A_Index - 1, true].Read()
			json .= """" key """:"
			if (dict[key].size.Read() > 0)
				json .= this.JsonifyDictionary(dict[key])
			else
				json .= dict[key].Read()
		}
		json .= "}"
		return json
	}
	
	ObjectifyDictionary(dict, sanityMin := 0, sanityMax := 50000)
	{
		dictSize := dict.size.Read()
		if (dictSize < sanityMin OR dictSize > sanityMax)
			return ""
		obj := {}
		loop, %dictSize%
		{
			key := dict["key", A_Index - 1, true].Read()
			if (dict[key].size.Read() > 0)
				obj[key] := this.ObjectifyDictionary(dict[key])
			else
				obj[key] := dict[key].Read()
		}
		return obj
	}
	
	GetNowEpoch()
	{
		nowUTC := A_NowUTC
		nowUTC -= 19700101000000, S
		return nowUTC
	}
	
	FmtSecs(T, Fmt:="{:}d {:02}h {:02}m {:02}s") { ; v0.50 by SKAN on D36G/H @ tiny.cc/fmtsecs
		local D, H, M, HH, Q:=60, R:=3600, S:=86400
		return Format(Fmt, D:=T//S, H:=(T:=T-D*S)//R, M:=(T:=T-H*R)//Q, T-M*Q, HH:=D*24+H, HH*Q+M)
	}
	
}
