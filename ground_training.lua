BASE:I("----------------------------------------LOADING THE GROUND TRAINING MISSION -------------------------------------------------")
trigger.action.outText('-----------------LOADING THE GROUND TRAINING MISSION------------------', 15)



--dofile("./bin/jsDb_init.lua"
--assert(loadfile("D:DCS MooseMISSIONSMoose_Include_StaticMoose_.lua"))()

-- +-----------------------------+
-- |    SETUP & DEBUG OPTIONS    |
-- +-----------------------------+

RedDebug = true
RedVerbosity = 6

BlueDebug = true
BlueVerbosity = 6

if RedDebug or BlueDebug then
	trigger.action.outText('DEBUG IS ACTIVE', 10)
	BASE:TraceLevel(3)
	BASE:TraceClass("AUFTRAG")
	BASE:TraceClass("AIRWING")
	BASE:TraceClass("CHIEF")
end

--Seed the Random Function a few times
math.random(100)
math.random(100)
math.random(100)
math.random(100)
math.random(100)
math.random(100)

--General settings for Moose functions
_SETTINGS:SetPlayerMenuOff() -- Player can't change Moose settings
_SETTINGS:SetImperial() -- we want NM and Knots
_SETTINGS:SetA2A_BRAA() -- A2A will be with BRAA format
_SETTINGS:SetA2G_BR() --  A2G good enough as BR
_SETTINGS:SetEraModern() -- We're modern
_SETTINGS:SetMenutextShort(true) -- shorter menus for VR

-- +-----------------------------+
-- |      DEFINE ALL ZONES       |
-- +-----------------------------+

--BORDERS
local BlueBorderZones = ZONE_POLYGON:New("Blue Border",GROUP:FindByName("BlueBorder"))        --Core.Zone#ZONE
if BlueDebug then BlueBorderZones:DrawZone(-1, {0,0,1} , 1, {0,0,1}) end
local RedBorderZones = ZONE_POLYGON:New("Red Border",GROUP:FindByName("RedBorder"))           --Core.Zone#ZONE
local ConflictZones = SET_ZONE:New():FilterPrefixes("ConflictZone"):FilterOnce()              --#SET_ZONE
--local RedAttackZones = SET_ZONE:New():FilterPrefixes("RedAttackZone"):FilterOnce()



-- +-----------------------------+
-- |     CONFIGURE BLUE CHIEF    |
-- +-----------------------------+ 
--Logistics Zones
local BlueLogisticsZones = {}
BlueLogisticsZones.TexacoZone= ZONE:New("TexacoZone")
BlueLogisticsZones.ShellZone= ZONE:New("ShellZone")
BlueLogisticsZones.AwacsZone= ZONE:New("AwacsZone")
BlueLogisticsZones.DroneZone= ZONE:New("DroneZone")

if BlueDebug then
	for _,zone in pairs(BlueLogisticsZones) do
		zone:DrawZone(-1, {0,0,1})
	end
end

local AwacsCoord = BlueLogisticsZones.AwacsZone:GetCoordinate()

local BlueIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.BLUE):FilterStart()
local BlueChief = CHIEF:New(coalition.side.BLUE, BlueIntelProviders, "Blue Chief")

BlueChief:SetBorderZones(BlueBorderZones)
BlueChief:SetDefcon(CHIEF.DEFCON.GREEN)
BlueChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
BlueChief:SetThreatLevelRange(1, 1000)

if BlueDebug then
	BlueChief:SetVerbosity(BlueVerbosity)
	BlueChief:SetClusterAnalysis(true,true)   -- Enable Intel clusters and markers
	BlueChief:SetTacticalOverviewOn()
end


BASE:I("----------------------------------------BLUE CHIEF SET-------------------------------------------------")
trigger.action.outText('BLUE CHIEF LOADED', 10)

-- Blue (US/NATO) side.
local US={}
US.Wing={}--Ops.AirWing#AIRWING
US.Squad={}--Ops.Squadron#SQUADRON
US.Fleet={}--Ops.Fleet#FLEET
US.Flotilla={}--Ops.Flotilla#FLOTILLA
US.Brigade={}--Ops.Brigade#BRIGADE




-- +-----------------------------+
-- |        Nellis AIRWING    |
-- +-----------------------------+
BASE:I("----------------------------------------BLUE NELLIS AIRWING LOADING-------------------------------------------------")
--Set Up Blue Airwing
US.Wing.Nellis = AIRWING:New("Nellis AFB", "Nellis AFB") --Ops.AirWing#AIRWING

if BlueDebug then
	US.Wing.Nellis:SetVerbosity(BlueVerbosity)
	US.Wing.Nellis:SetMarker(true)
end

--Add Squadrons 
US.Squad.Nellis={}

--F15s for various tasks
US.Squad.Nellis.fsq01=SQUADRON:New("F15Es", 10, "F15Es Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.fsq01:AddMissionCapability({AUFTRAG.Type.BAI, AUFTRAG.Type.BOMBING, AUFTRAG.Type.BOMBRUNWAY, AUFTRAG.Type.GCICAS, AUFTRAG.Type.STRIKE}, 100)
US.Squad.Nellis.fsq01:SetMissionRange(500)
US.Squad.Nellis.fsq01:SetSkill(AI.Skill.EXCELLENT)
US.Squad.Nellis.fsq01:SetFuelLowRefuel(true)
US.Squad.Nellis.fsq01:SetFuelLowThreshold(35)
US.Squad.Nellis.fsq01:SetTurnoverTime(10,15)

US.Squad.Nellis.fsq02=SQUADRON:New("F15Cs", 10, "F15Cs Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.fsq02:AddMissionCapability({AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.fsq02:SetMissionRange(500)
US.Squad.Nellis.fsq02:SetSkill(AI.Skill.EXCELLENT)
US.Squad.Nellis.fsq02:SetFuelLowRefuel(true)
US.Squad.Nellis.fsq02:SetFuelLowThreshold(35)
US.Squad.Nellis.fsq02:SetTurnoverTime(10,15)

--Tanker 1
US.Squad.Nellis.tsqTEX=SQUADRON:New("Texaco", 4, "Texaco Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.tsqTEX:AddMissionCapability({AUFTRAG.Type.TANKER, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.tsqTEX:SetFuelLowRefuel(true)
US.Squad.Nellis.tsqTEX:SetFuelLowThreshold(0.1)
US.Squad.Nellis.tsqTEX:SetTurnoverTime(10,20)
US.Squad.Nellis.tsqTEX:SetMissionRange(500)
US.Squad.Nellis.tsqTEX:SetSkill(AI.Skill.AVERAGE)
US.Squad.Nellis.tsqTEX:SetRadio(251)
US.Squad.Nellis.tsqTEX:SetCallsign(CALLSIGN.Tanker.Texaco,1)
US.Squad.Nellis.tsqTEX:AddTacanChannel(51,51)

--Tanker 2
US.Squad.Nellis.tsqSHL=SQUADRON:New("Shell", 4, "Shell Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.tsqSHL:AddMissionCapability({AUFTRAG.Type.TANKER, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.tsqSHL:SetFuelLowRefuel(true)
US.Squad.Nellis.tsqSHL:SetFuelLowThreshold(0.1)
US.Squad.Nellis.tsqSHL:SetTurnoverTime(10,20)
US.Squad.Nellis.tsqSHL:SetMissionRange(500)
US.Squad.Nellis.tsqSHL:SetSkill(AI.Skill.AVERAGE)
US.Squad.Nellis.tsqSHL:SetRadio(256)
US.Squad.Nellis.tsqSHL:SetCallsign(CALLSIGN.Tanker.Shell,1)
US.Squad.Nellis.tsqSHL:AddTacanChannel(56,56)

--AWACS
US.Squad.Nellis.esqE3=SQUADRON:New("E3", 4, "E3 Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.esqE3:AddMissionCapability({AUFTRAG.Type.AWACS, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.esqE3:SetFuelLowThreshold(0.1)
US.Squad.Nellis.esqE3:SetTurnoverTime(10,20)
US.Squad.Nellis.esqE3:SetMissionRange(500)
US.Squad.Nellis.esqE3:SetSkill(AI.Skill.AVERAGE)
US.Squad.Nellis.esqE3:SetRadio(255)
US.Squad.Nellis.esqE3:SetCallsign(CALLSIGN.AWACS.Darkstar,1)

--Apaches Nellis
US.Squad.Nellis.AtkHelos=SQUADRON:New("Apaches", 20, "Apaches Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.AtkHelos:AddMissionCapability({AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.AtkHelos:SetFuelLowThreshold(0.1)
US.Squad.Nellis.AtkHelos:SetTurnoverTime(10,20)
US.Squad.Nellis.AtkHelos:SetSkill(AI.Skill.AVERAGE)



-- Add Squads to Nellis Airwing
for _,squad in pairs(US.Squad.Nellis) do
	US.Wing.Nellis:AddSquadron(squad)
end


	  
--Add Payloads
local F15sLoadout=US.Wing.Nellis:NewPayload(GROUP:FindByName("F15Cs"), -1, {AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
US.Wing.Nellis:NewPayload("E3",-1,{AUFTRAG.Type.AWACS},100)
US.Wing.Nellis:NewPayload("Apaches",-1,{AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE, AUFTRAG.Type.ALERT5},100)



--ASSIGN ESCORTS
function US.Wing.Nellis:OnAfterFlightOnMission(From, Event, To, Flightgroup, Mission)
	self:E({From, Event, To, Flightgroup, Mission})
	local flightgroup = Flightgroup -- Ops.FlightGroup#FLIGHTGROUP
    local mission = Mission -- Ops.Auftrag#AUFTRAG
    local flightgroupname = flightgroup:GetName()

    if mission:GetType() == AUFTRAG.Type.TANKER or mission:GetType() == AUFTRAG.Type.AWACS then
    	local EscortGroup = flightgroup:GetGroup()
		local auftrag = AUFTRAG:NewESCORT(EscortGroup,{x=-300, y=200, z=300},25,nil)
		auftrag:SetMissionRange(500)
		auftrag:SetRequiredAssets(0,1)
		BlueChief:AddMission(auftrag)
    end

--[[	if type == AUFTRAG.Type.AWACS then
		Bluemantis:SetAwacs(flightgroup.groupname)
		BASE:I("---------Blue AWACS Prefix Set as "..flightgroup.groupname)
	end]]

	--- Function called when the flight group gets low on fuel (default < 25% fuel remaining). 
    function flightgroup:OnAfterFuelLow(From, Event, To)
		local text=string.format("Running low on fuel %.2f. Returning to base!", flightgroup:GetFuelMin())
		env.info(string.format("FF %s: %s", flightgroup:GetName(), text))
		MESSAGE:New(text, 120, flightgroup:GetName()):ToAll()
	end

end
	  
	  
if BlueDebug then
	--- Display mission status on screen.
	local function MissionStatus()

		local text="Nellis Missions:"
		for _,_mission in pairs(US.Wing.Nellis.missionqueue) do
			local m=_mission --Ops.Auftrag#AUFTRAG
			text=text..string.format("- %s %s %s*%d/%d [%d %%]  (%s*%d/%d)",
			m:GetName(), m:GetState():upper(), m:GetTargetName(), m:CountMissionTargets(), m:GetTargetInitialNumber(), m:GetTargetDamage(), m:GetType(), m:CountOpsGroups(), m:GetNumberOfRequiredAssets())
		end

		-- Payloads
		text=text.."Available Payloads:"
		for _,aname in pairs(AUFTRAG.Type) do
			local n=US.Wing.Nellis:CountPayloadsInStock({aname})
			if n>0 then
				text=text..string.format("%s %d", aname, n)
			end
		end

		-- Info message to all.
		MESSAGE:New(text, 25):ToAll()
	end

	-- Display primary and secondary mission status every 60 seconds.
	TIMER:New(MissionStatus):Start(5, 30)
end



BASE:I("----------------------------------------NELLIS AIRWING LOADED-------------------------------------------------")	  
	  
	  
BASE:I("----------------------------------------BLUE CREECH AIRWING LOADING-------------------------------------------------")
--Set Up Blue Airwing
US.Wing.Creech = AIRWING:New("Creech AFB", "Creech AFB")

if BlueDebug then
	US.Wing.Creech:SetVerbosity(BlueVerbosity)
	US.Wing.Creech:SetMarker(true)
end

--Add Squadrons 
US.Squad.Creech={}

--F16s for various tasks
US.Squad.Creech.fsq02=SQUADRON:New("F16s", 10, "F16s Creech") --Ops.Squadron#SQUADRON
US.Squad.Creech.fsq02:AddMissionCapability({AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Creech.fsq02:SetMissionRange(500)
US.Squad.Creech.fsq02:SetSkill(AI.Skill.EXCELLENT)
US.Squad.Creech.fsq02:SetFuelLowRefuel(true)
US.Squad.Creech.fsq02:SetFuelLowThreshold(35)
US.Squad.Creech.fsq02:SetTurnoverTime(10,15)

--Apaches Creech
US.Squad.Creech.AtkHelos=SQUADRON:New("DAPs", 20, "DAPs Creech") --Ops.Squadron#SQUADRON
US.Squad.Creech.AtkHelos:AddMissionCapability({AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE}, 100)
US.Squad.Creech.AtkHelos:SetFuelLowThreshold(0.1)
US.Squad.Creech.AtkHelos:SetTurnoverTime(10,20)
US.Squad.Creech.AtkHelos:SetSkill(AI.Skill.EXCELLENT)


-- Add Squads to Creech Airwing
for _,squad in pairs(US.Squad.Creech) do
	US.Wing.Creech:AddSquadron(squad)
end


local F16sGroundLoadout=US.Wing.Creech:NewPayload(GROUP:FindByName("F16sGround"), -1, {AUFTRAG.Type.CAS, AUFTRAG.Type.STRIKE}, 100)
local F16sSEADoadout=US.Wing.Creech:NewPayload(GROUP:FindByName("F16sSEAD"), -1, {AUFTRAG.Type.SEAD}, 100)
local F16sAirLoadout=US.Wing.Creech:NewPayload(GROUP:FindByName("F16sAir"), -1, {AUFTRAG.Type.CAP, AUFTRAG.Type.Intercept, AUFTRAG.Type.ALERT5}, 100)
US.Wing.Creech:NewPayload("DAPs",-1,{AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE},100)


--ASSIGN ESCORTS
function US.Wing.Creech:OnAfterFlightOnMission(From, Event, To, Flightgroup, Mission)
	self:E({From, Event, To, Flightgroup, Mission})
	local flightgroup = Flightgroup -- Ops.FlightGroup#FLIGHTGROUP
   	local mission = Mission -- Ops.Auftrag#AUFTRAG
   	local flightgroupname = flightgroup:GetName()

	if mission:GetType() == AUFTRAG.Type.TANKER or mission:GetType() == AUFTRAG.Type.AWACS then
    		local EscortGroup = flightgroup:GetGroup()
		local auftrag = AUFTRAG:NewESCORT(EscortGroup,{x=-300, y=200, z=300},25,nil)
		auftrag:SetMissionRange(500)
		auftrag:SetRequiredAssets(0,1)
		BlueChief:AddMission(auftrag)
	end

--[[	if type == AUFTRAG.Type.AWACS then
		Bluemantis:SetAwacs(flightgroup.groupname)
		BASE:I("---------Blue AWACS Prefix Set as "..flightgroup.groupname)
	end]]

	--- Function called when the flight group gets low on fuel (default < 25% fuel remaining). 
	function flightgroup:OnAfterFuelLow(From, Event, To)
		local text=string.format("Running low on fuel %.2f. Returning to base!", flightgroup:GetFuelMin())
		env.info(string.format("FF %s: %s", flightgroup:GetName(), text))
		MESSAGE:New(text, 120, flightgroup:GetName()):ToAll()
	end

end

if BlueDebug then
	--- Display mission status on screen.
	local function MissionStatus()

		local text="Creech Missions:"
		for _,_mission in pairs(US.Wing.Creech.missionqueue) do
			local m=_mission --Ops.Auftrag#AUFTRAG
			text=text..string.format("- %s %s %s*%d/%d [%d %%]  (%s*%d/%d)",
			m:GetName(), m:GetState():upper(), m:GetTargetName(), m:CountMissionTargets(), m:GetTargetInitialNumber(), m:GetTargetDamage(), m:GetType(), m:CountOpsGroups(), m:GetNumberOfRequiredAssets())
		end

		-- Payloads
		text=text.."Available Payloads:"
		for _,aname in pairs(AUFTRAG.Type) do
			local n=US.Wing.Creech:CountPayloadsInStock({aname})
			if n>0 then
				text=text..string.format("%s %d", aname, n)
			end
		end

		-- Info message to all.
		MESSAGE:New(text, 25):ToAll()
	end

	-- Display primary and secondary mission status every 60 seconds.
	TIMER:New(MissionStatus):Start(5, 30)
end

BASE:I("----------------------------------------CREECH AIRWING LOADED-------------------------------------------------")







-- +-----------------------------+
-- |       Nellis PATROLS     |
-- +-----------------------------+  

local Zones = {}
Zones.VegasApproachWest = ZONE:New("VegasApproachWest")                 --Core.Zone#ZONE
Zones.VegasApproachNorth= ZONE:New("VegasApproachNorth")              --Core.Zone#ZONE
Zones.CreechApproachNW= ZONE:New("CreechApproachNW")                        --Core.Zone#ZONE
Zones.CreechApproachWest= ZONE:New("CreechApproachWest")                  --Core.Zone#ZONE
--Zones.DubaiPatriotSite1= ZONE:New("DubaiPatriotSite1")                    --Core.Zone#ZONE
--Zones.DubaiPatriotSite2= ZONE:New("DubaiPatriotSite2")                    --Core.Zone#ZONE

if BlueDebug then
	for _,zone in pairs(Zones) do
		zone:DrawZone(-1, {0,0,1})
	end
end

for _,zone in pairs(Zones) do
	local Patrol = AUFTRAG:NewPATROLZONE(zone)                              --Ops.AUFTRAG
	Patrol:AssignCohort(US.Squad.Nellis.AtkHelos)
	Patrol:SetRepeat(99)
	BlueChief:AddMission(Patrol)
end
	  
	  

-- +-----------------------------+
-- |  BlueChief Managed Missions  |
-- +-----------------------------+

BASE:I("----------------------------------------BLUE CHIEF MISSIONS-------------------------------------------------")

--AWACS
local BlueAWACS = AUFTRAG:NewAWACS(BlueLogisticsZones.AwacsZone:GetCoordinate(), 30000, UTILS.KnotsToAltKIAS(400,30000), 180, 20)
      BlueAWACS:SetRepeat(99)
      BlueAWACS:SetName("Blue AWACS")
      BlueChief:AddMission(BlueAWACS)

--TANKER
-- local RedTanker1 = AUFTRAG:NewTANKER(RedLogisticsZones.RedTankerZone:GetCoordinate(), 20000, 275, 90, 25, 1)
--       RedTanker1:SetRepeat(99)
--       RedTanker1:SetName("Red Tanker 1")
--       RedChief:AddMission(RedTanker1)





	  

-- +-----------------------------+
-- |       BLUE ACTIVATION       |
-- +-----------------------------+
-- Add squadrons to airwing.
for _,Wing in pairs(US.Wing) do
	BlueChief:AddAirwing(Wing)

	if BlueDebug then
		Wing:SetVerbosity(BlueVerbosity)
		Wing:SetMarker(true)
	end
end

for _,Brigade in pairs(US.Brigade) do
	BlueChief:AddBrigade(Brigade)
	if BlueDebug then
		Brigade:SetVerbosity(BlueVerbosity)
		Brigade:SetMarker(true)
	end
end

BlueChief:__Start(10)



-- +-----------------------------+
-- |       CHIEF LOGISTICS       |
-- +-----------------------------+

local function LaunchTexaco()
	TexacoAuftrag = AUFTRAG:NewTANKER(BlueLogisticsZones.TexacoZone:GetCoordinate(),20000,UTILS.KnotsToAltKIAS(250,20000),270,25,1)
	TexacoAuftrag:AssignCohort(US.Squad.Nellis.tsqTEX)
	TexacoAuftrag:SetRadio(251)
	TexacoAuftrag:SetTACAN(51, "TEX")
	TexacoAuftrag:SetName("Texaco Auftrag")
	TexacoAuftrag:SetRepeat(99)
	BlueChief:AddMission(TexacoAuftrag)
end

local function CancelTexaco()
	TexacoAuftrag:Cancel()
end

local function LaunchShell()
	local ShellAuftrag = AUFTRAG:NewTANKER(BlueLogisticsZones.ShellZone:GetCoordinate(),22000,UTILS.KnotsToAltKIAS(250,22000),270,25,1)
	ShellAuftrag:AssignCohort(US.Squad.Nellis.tsqSHL)
	ShellAuftrag:SetRadio(256)
	ShellAuftrag:SetTACAN(56, "SHL")
	ShellAuftrag:SetName("Shell Auftrag")
	ShellAuftrag:SetRepeat(99)
	BlueChief:AddMission(ShellAuftrag)
end

local function CancelShell()
	ShellAuftrag:Cancel()
end


-- +-----------------------------+
-- |       BLUE CHIEF MENU       |
-- +-----------------------------+
local BlueChiefMenu=MENU_MISSION:New("Blue Chief Control")--#MENU
local BlueChiefMenu1 = MENU_MISSION_COMMAND:New("Launch Texaco", BlueChiefMenu, LaunchTexaco)--#MENU
local BlueChiefMenu2 = MENU_MISSION_COMMAND:New("Texaco RTB", BlueChiefMenu, CancelTexaco)--#MENU
local BlueChiefMenu3 = MENU_MISSION_COMMAND:New("Launch Shell", BlueChiefMenu, LaunchShell)--#MENU
local BlueChiefMenu4 = MENU_MISSION_COMMAND:New("Shell RTB", BlueChiefMenu, CancelShell)--#MENU

	  
	  
	  







-- +-----------------------------+
-- |     CONFIGURE RED CHIEF    |
-- +-----------------------------+ 
--Logistics Zones
local RedLogisticsZones = {}
-- RedLogisticsZones.TexacoZone= ZONE:New("TexacoZone")
-- RedLogisticsZones.ShellZone= ZONE:New("ShellZone")
-- RedLogisticsZones.AwacsZone= ZONE:New("AwacsZone")
-- RedLogisticsZones.DroneZone= ZONE:New("DroneZone")

if RedDebug then
	for _,zone in pairs(RedLogisticsZones) do
		zone:DrawZone(-1, {0,0,1})
	end
end

local RedIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.RED):FilterStart()
local RedChief = CHIEF:New(coalition.side.RED, RedIntelProviders, "Red Chief")

RedChief:SetBorderZones(RedBorderZones)
RedChief:SetDefcon(CHIEF.DEFCON.GREEN)
RedChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
RedChief:SetThreatLevelRange(1, 1000)

if RedDebug then
	RedChief:SetVerbosity(RedVerbosity)
	RedChief:SetClusterAnalysis(true,true)   -- Enable Intel clusters and markers
	RedChief:SetTacticalOverviewOn()
end

BASE:I("----------------------------------------RED CHIEF SET-------------------------------------------------")
trigger.action.outText('RED CHIEF LOADED', 10)

-- Red side.
local RED={}
RED.Wing={}--Ops.AirWing#AIRWING
RED.Squad={}--Ops.Squadron#SQUADRON
RED.Fleet={}--Ops.Fleet#FLEET
RED.Flotilla={}--Ops.Flotilla#FLOTILLA
RED.Brigade={}--Ops.Brigade#BRIGADE












-- +-----------------------------+
-- |       RED ACTIVATION       |
-- +-----------------------------+
-- Add squadrons to airwing.
for _,Wing in pairs(RED.Wing) do
	RedChief:AddAirwing(Wing)

	if RedDebug then
		Wing:SetVerbosity(RedVerbosity)
		Wing:SetMarker(true)
	end
end

for _,Brigade in pairs(RED.Brigade) do
	RedChief:AddBrigade(Brigade)
	if RedDebug then
		Brigade:SetVerbosity(RedVerbosity)
		Brigade:SetMarker(true)
	end
end

RedChief:__Start(10)






trigger.action.outText('MISSION FILE: GROUND TRAINING...LOADED', 5)
BASE:I("----------------------------------------MISSION LOADED-------------------------------------------------")

BASE:I("----------------------------------------EVERYTHING LOADED (IT'S A MIRACLE!) -------------------------------------------------")
trigger.action.outText('-----------------EVERYTHING LOADED (ITS A MIRACLE!)------------------', 15)
	  
	  
	  






