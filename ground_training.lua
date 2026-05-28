BASE:I("----------------------------------------LOADING THE GROUND TRAINING MISSION -------------------------------------------------")
trigger.action.outText('-----------------LOADING THE GROUND TRAINING MISSION------------------', 15)

do
  local event = EVENTHANDLER:New()
  event:HandleEvent(EVENTS.LandingAfterEjection, function(EventData)
    if EventData.IniDCSUnit then
      EventData.IniDCSUnit:destroy()
    end
  end)
end

--dofile("./bin/jsDb_init.lua"
--assert(loadfile("D:DCS MooseMISSIONSMoose_Include_StaticMoose_.lua"))()

-- +-----------------------------+
-- |    SETUP & DEBUG OPTIONS    |
-- +-----------------------------+

RedDebug = false
RedVerbosity = 6

BlueDebug = true
BlueVerbosity = 6

if RedDebug or BlueDebug then
	trigger.action.outText('DEBUG IS ACTIVE', 10)
	BASE:TraceLevel(3)
	BASE:TraceClass("AUFTRAG")
	BASE:TraceClass("AIRWING")
	BASE:TraceClass("BRIGADE")
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
local RedBorderZones = ZONE_POLYGON:New("Red Border",GROUP:FindByName("RedBorder"))
if RedDebug then RedBorderZones:DrawZone(-1, {1,0,0} , 1, {1,0,0}) end           --Core.Zone#ZONE
local ConflictZones = SET_ZONE:New():FilterPrefixes("ConflictZone"):FilterOnce()              --#SET_ZONE
if BlueDebug then ConflictZones:DrawZone(-1, {0,1,0} , 1, {0,1,0}) end
if RedDebug then ConflictZones:DrawZone(-1, {0,1,0} , 1, {0,1,0}) end
--local RedAttackZones = SET_ZONE:New():FilterPrefixes("RedAttackZone"):FilterOnce()

local BlueStrategicZones = {}
BlueStrategicZones.Tonopah = OPSZONE:New(ZONE:FindByName("TonopahStrategicZone"), coalition.side.BLUE)
local BlueAttackZone = ZONE:New("BlueAttackZone")





-- +-----------------------------+
-- |     CONFIGURE BLUE CHIEF    |
-- +-----------------------------+ 
--Logistics Zones
local BlueLogisticsZones = {}
BlueLogisticsZones.TexacoZone= ZONE:New("TexacoZone")
BlueLogisticsZones.ShellZone= ZONE:New("ShellZone")
BlueLogisticsZones.AwacsZone= ZONE:New("AwacsZone")
BlueLogisticsZones.DroneZone= ZONE:New("DroneZone")
BlueLogisticsZones.CreechSpawnZone = Zone:New("CreechSpawnZone")

if BlueDebug then
	for _,zone in pairs(BlueLogisticsZones) do
		zone:DrawZone(-1, {0,0,1})
	end
end

local AwacsCoord = BlueLogisticsZones.AwacsZone:GetCoordinate()

local BlueIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.BLUE):FilterStart()
local BlueChief = CHIEF:New(coalition.side.BLUE, BlueIntelProviders, "Blue Chief")

BlueChief:SetBorderZones(BlueBorderZones)
BlueChief:SetDefcon(CHIEF.DEFCON.RED)
--BlueChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
BlueChief:SetStrategy(CHIEF.Strategy.AGGRESSIVE)
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
US.Platoon={}



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
US.Squad.Nellis.fsq01:AddMissionCapability({AUFTRAG.Type.BAI, AUFTRAG.Type.BOMBING, AUFTRAG.Type.BOMBRUNWAY, AUFTRAG.Type.STRIKE, AUFTRAG.Type.CAS, AUFTRAG.Type.CASENHANCED}, 100)
US.Squad.Nellis.fsq01:SetMissionRange(500)
US.Squad.Nellis.fsq01:SetSkill(AI.Skill.EXCELLENT)
US.Squad.Nellis.fsq01:SetFuelLowRefuel(true)
US.Squad.Nellis.fsq01:SetFuelLowThreshold(35)
US.Squad.Nellis.fsq01:SetTurnoverTime(10,15)
US.Squad.Nellis.fsq01:SetRadio(255)
US.Squad.Nellis.fsq01:SetCallsign(9,1)
US.Squad.Nellis.fsq01:SetTakeoffHot()

US.Squad.Nellis.fsq02=SQUADRON:New("F15Cs", 10, "F15Cs Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.fsq02:AddMissionCapability({AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.fsq02:SetMissionRange(500)
US.Squad.Nellis.fsq02:SetSkill(AI.Skill.EXCELLENT)
US.Squad.Nellis.fsq02:SetFuelLowRefuel(true)
US.Squad.Nellis.fsq02:SetFuelLowThreshold(35)
US.Squad.Nellis.fsq02:SetTurnoverTime(10,15)
US.Squad.Nellis.fsq02:SetRadio(305)
US.Squad.Nellis.fsq02:SetCallsign(4,1)
US.Squad.Nellis.fsq02:SetTakeoffHot()

--Tanker 1
US.Squad.Nellis.tsqTEX=SQUADRON:New("Texaco", 4, "Texaco Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.tsqTEX:AddMissionCapability({AUFTRAG.Type.TANKER, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.tsqTEX:SetFuelLowRefuel(true)
US.Squad.Nellis.tsqTEX:SetFuelLowThreshold(0.1)
US.Squad.Nellis.tsqTEX:SetTurnoverTime(10,20)
US.Squad.Nellis.tsqTEX:SetMissionRange(500)
US.Squad.Nellis.tsqTEX:SetSkill(AI.Skill.AVERAGE)
US.Squad.Nellis.tsqTEX:SetRadio(262)
US.Squad.Nellis.tsqTEX:SetCallsign(CALLSIGN.Tanker.Texaco,1)
US.Squad.Nellis.tsqTEX:AddTacanChannel(51,51)
US.Squad.Nellis.tsqTEX:SetTakeoffHot()

--Tanker 2
US.Squad.Nellis.tsqSHL=SQUADRON:New("Shell", 4, "Shell Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.tsqSHL:AddMissionCapability({AUFTRAG.Type.TANKER, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.tsqSHL:SetFuelLowRefuel(true)
US.Squad.Nellis.tsqSHL:SetFuelLowThreshold(0.1)
US.Squad.Nellis.tsqSHL:SetTurnoverTime(10,20)
US.Squad.Nellis.tsqSHL:SetMissionRange(500)
US.Squad.Nellis.tsqSHL:SetSkill(AI.Skill.AVERAGE)
US.Squad.Nellis.tsqSHL:SetRadio(261)
US.Squad.Nellis.tsqSHL:SetCallsign(CALLSIGN.Tanker.Shell,1)
US.Squad.Nellis.tsqSHL:AddTacanChannel(56,56)
US.Squad.Nellis.tsqSHL:SetTakeoffHot()

--AWACS
US.Squad.Nellis.esqE3=SQUADRON:New("E3", 4, "E3 Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.esqE3:AddMissionCapability({AUFTRAG.Type.AWACS, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.esqE3:SetFuelLowThreshold(0.1)
US.Squad.Nellis.esqE3:SetTurnoverTime(10,20)
US.Squad.Nellis.esqE3:SetMissionRange(500)
US.Squad.Nellis.esqE3:SetSkill(AI.Skill.AVERAGE)
US.Squad.Nellis.esqE3:SetRadio(251)
US.Squad.Nellis.esqE3:SetCallsign(CALLSIGN.AWACS.Darkstar,1)
US.Squad.Nellis.esqE3:SetTakeoffHot()

--Apaches Nellis
US.Squad.Nellis.AtkHelos=SQUADRON:New("Apaches", 20, "Apaches Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.AtkHelos:AddMissionCapability({AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE, AUFTRAG.Type.ALERT5}, 100)
US.Squad.Nellis.AtkHelos:SetFuelLowThreshold(0.1)
US.Squad.Nellis.AtkHelos:SetTurnoverTime(10,20)
US.Squad.Nellis.AtkHelos:SetSkill(AI.Skill.AVERAGE)
US.Squad.Nellis.AtkHelos:SetCallsign(19,1)
US.Squad.Nellis.AtkHelos:SetRadio(251)
US.Squad.Nellis.AtkHelos:SetTakeoffHot()

--Chinooks Nellis
US.Squad.Nellis.Chinooks=SQUADRON:New("Chinooks", 20, "Chinooks Nellis") --Ops.Squadron#SQUADRON
US.Squad.Nellis.Chinooks:AddMissionCapability({AUFTRAG.Type.TROOPTRANSPORT, AUFTRAG.Type.CARGOTRANSPORT, AUFTRAG.Type.HOVER, AUFTRAG.Type.OPSTRANSPORT}, 100)
US.Squad.Nellis.Chinooks:SetFuelLowThreshold(0.1)
US.Squad.Nellis.Chinooks:SetTurnoverTime(10,20)
US.Squad.Nellis.Chinooks:SetSkill(AI.Skill.AVERAGE)
US.Squad.Nellis.Chinooks:SetRadio(251)
US.Squad.Nellis.Chinooks:SetTakeoffHot()
--US.Squad.Nellis.Chinooks:SetCallsign(19,1)

-- Add Squads to Nellis Airwing
for _,squad in pairs(US.Squad.Nellis) do
	US.Wing.Nellis:AddSquadron(squad)
end


	  
--Add Payloads
local F15sLoadout = US.Wing.Nellis:NewPayload(GROUP:FindByName("F15Cs"), -1, {AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
US.Wing.Nellis:NewPayload("F15Es", -1, {AUFTRAG.Type.BAI, AUFTRAG.Type.STRIKE, AUFTRAG.Type.CAS, AUFTRAG.Type.CASENHANCED}, 100)
US.Wing.Nellis:NewPayload("E3",-1, {AUFTRAG.Type.AWACS},100)
US.Wing.Nellis:NewPayload("Apaches",-1, {AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE, AUFTRAG.Type.ALERT5},100)
US.Wing.Nellis:NewPayload("Chinooks",-1, {AUFTRAG.Type.TROOPTRANSPORT, AUFTRAG.Type.CARGOTRANSPORT, AUFTRAG.Type.HOVER, AUFTRAG.Type.OPSTRANSPORT}, 100)


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



BASE:I("----------------------------------------NELLIS BRIGADE LOADING-------------------------------------------------")
US.Brigade.Nellis = BRIGADE:New("Nellis Warehouse", "Nellis Brigade") --Ops.AirWing#AIRWING

if BlueDebug then
	US.Brigade.Nellis:SetVerbosity(BlueVerbosity)
	US.Brigade.Nellis:SetMarker(true)
end

--Add Platoons 
US.Platoon.Nellis={}
US.Platoon.Nellis.himarsHe = PLATOON:New("HIMARS-GMLRS-HE", -1, "HIMARS-HE")
US.Platoon.Nellis.himarsHe:AddMissionCapability(AUFTRAG.Type.ARTY)
US.Platoon.Nellis.himarsHe:SetSkill(AI.Skill.AVERAGE)
US.Platoon.Nellis.himarsHe:SetRadio(251)

US.Platoon.Nellis.m270 = PLATOON:New("M270A1-GMLRS", -1, "M270")
US.Platoon.Nellis.m270:AddMissionCapability(AUFTRAG.Type.ARTY)
US.Platoon.Nellis.m270:SetSkill(AI.Skill.AVERAGE)
US.Platoon.Nellis.m270:SetRadio(251)

US.Platoon.Nellis.paladin = PLATOON:New("Paladin", -1, "Paladin")
US.Platoon.Nellis.paladin:AddMissionCapability(AUFTRAG.Type.ARTY)
US.Platoon.Nellis.paladin:SetSkill(AI.Skill.AVERAGE)
US.Platoon.Nellis.paladin:SetRadio(251)

US.Platoon.Nellis.howitzer = PLATOON:New("Howitzer", -1, "Howitzer")
US.Platoon.Nellis.howitzer:AddMissionCapability(AUFTRAG.Type.ARTY)
US.Platoon.Nellis.howitzer:SetSkill(AI.Skill.AVERAGE)
US.Platoon.Nellis.howitzer:SetRadio(251)

US.Platoon.Nellis.abrams = PLATOON:New("Abrams", -1, "Abrams")
US.Platoon.Nellis.abrams:AddMissionCapability({AUFTRAG.Type.GROUNDATTACK, AUFTRAG.Type.PATROLZONE}, 100)
US.Platoon.Nellis.abrams:SetSkill(AI.Skill.AVERAGE)
US.Platoon.Nellis.abrams:SetRadio(251)

-- Add Platoons to Nellis Brigade
for _,platoon in pairs(US.Platoon.Nellis) do
	US.Brigade.Nellis:AddPlatoon(platoon)
end

--US.Platoon.Nellis:NewPayload("Abrams",-1,{AUFTRAG.Type.AWACS, AUFTRAG.Type.PATROLZONE},100)

if BlueDebug then
	--- Display mission status on screen.
	local function MissionStatus()

		local text="Nellis Ground Missions:"
		for _,_mission in pairs(US.Brigade.Nellis.missionqueue) do
			local m=_mission --Ops.Auftrag#AUFTRAG
			text=text..string.format("- %s %s %s*%d/%d [%d %%]  (%s*%d/%d)",
			m:GetName(), m:GetState():upper(), m:GetTargetName(), m:CountMissionTargets(), m:GetTargetInitialNumber(), m:GetTargetDamage(), m:GetType(), m:CountOpsGroups(), m:GetNumberOfRequiredAssets())
		end

		-- Payloads
--		text=text.."Available Payloads:"
--		for _,aname in pairs(AUFTRAG.Type) do
--			local n=US.Brigade.Nellis:CountPayloadsInStock({aname})
--			if n>0 then
--				text=text..string.format("%s %d", aname, n)
--			end
--		end

		-- Info message to all.
		MESSAGE:New(text, 25):ToAll()
	end

	-- Display primary and secondary mission status every 60 seconds.
	TIMER:New(MissionStatus):Start(5, 30)
end

BASE:I("----------------------------------------NELLIS BRIGADE LOADED-------------------------------------------------")





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
US.Squad.Creech.fsq02:AddMissionCapability({AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5, AUFTRAG.Type.CAS, AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.STRIKE, AUFTRAG.Type.SEAD}, 95)
US.Squad.Creech.fsq02:SetMissionRange(500)
US.Squad.Creech.fsq02:SetSkill(AI.Skill.EXCELLENT)
US.Squad.Creech.fsq02:SetFuelLowRefuel(true)
US.Squad.Creech.fsq02:SetFuelLowThreshold(35)
US.Squad.Creech.fsq02:SetTurnoverTime(10,15)
US.Squad.Creech.fsq02:SetCallsign(10,1)
US.Squad.Creech.fsq02:SetTakeoffHot()
--US.Squad.Creech.fsq02:SetEPLRS(true)

--Blackhawks Creech
US.Squad.Creech.AtkHelos=SQUADRON:New("Apaches", 20, "Apaches Creech") --Ops.Squadron#SQUADRON
US.Squad.Creech.AtkHelos:AddMissionCapability({AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE}, 100)
US.Squad.Creech.AtkHelos:SetFuelLowThreshold(0.1)
US.Squad.Creech.AtkHelos:SetTurnoverTime(10,20)
US.Squad.Creech.AtkHelos:SetSkill(AI.Skill.EXCELLENT)
US.Squad.Creech.AtkHelos:SetCallsign(14,1)
US.Squad.Creech.AtkHelos:SetTakeoffHot()

--US.Squad.Creech.AtkHelos:SetEPLRS(true)

--Drones Creech
US.Squad.Creech.Drones=SQUADRON:New("Drones", 20, "Drones Creech") --Ops.Squadron#SQUADRON
US.Squad.Creech.Drones:AddMissionCapability({AUFTRAG.Type.RECON, AUFTRAG.Type.FACA, AUFTRAG.Type.PATROLZONE}, 100)
US.Squad.Creech.Drones:SetFuelLowThreshold(0.1)
US.Squad.Creech.Drones:SetTurnoverTime(10,20)
US.Squad.Creech.Drones:SetSkill(AI.Skill.EXCELLENT)
US.Squad.Creech.Drones:SetCallsign(14,1)
US.Squad.Creech.Drones:SetTakeoffHot()
--US.Squad.Creech.Drones:SetEPLRS(true)

--Chinooks Creech
US.Squad.Creech.Chinooks=SQUADRON:New("Chinooks", 20, "Chinooks Creech") --Ops.Squadron#SQUADRON
US.Squad.Creech.Chinooks:AddMissionCapability({AUFTRAG.Type.TROOPTRANSPORT, AUFTRAG.Type.CARGOTRANSPORT, AUFTRAG.Type.HOVER, AUFTRAG.Type.OPSTRANSPORT}, 100)
US.Squad.Creech.Chinooks:SetFuelLowThreshold(0.1)
US.Squad.Creech.Chinooks:SetTurnoverTime(10,20)
US.Squad.Creech.Chinooks:SetSkill(AI.Skill.AVERAGE)
US.Squad.Creech.Chinooks:SetCallsign(19,1)
--US.Squad.Creech.Chinooks:SetCallsign(19,1)

-- Add Squads to Creech Airwing
for _,squad in pairs(US.Squad.Creech) do
	US.Wing.Creech:AddSquadron(squad)
end


local F16sGroundLoadout=US.Wing.Creech:NewPayload(GROUP:FindByName("F16sGround"), -1, {AUFTRAG.Type.CAS, AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.STRIKE}, 95)
local F16sSEADLoadout=US.Wing.Creech:NewPayload(GROUP:FindByName("F16sSEAD"), -1, {AUFTRAG.Type.SEAD}, 100)
local F16sAirLoadout=US.Wing.Creech:NewPayload(GROUP:FindByName("F16s"), -1, {AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 95)
US.Wing.Creech:NewPayload("Apaches",-1,{AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE},100)
US.Wing.Creech:NewPayload("Drones",-1,{AUFTRAG.Type.RECON, AUFTRAG.Type.FACA, AUFTRAG.Type.PATROLZONE},100)
US.Wing.Creech:NewPayload("Chinooks",-1,{AUFTRAG.Type.TROOPTRANSPORT, AUFTRAG.Type.CARGOTRANSPORT, AUFTRAG.Type.HOVER, AUFTRAG.Type.OPSTRANSPORT}, 100)


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



BASE:I("----------------------------------------CREECH BRIGADE LOADING-------------------------------------------------")
US.Brigade.Creech = BRIGADE:New("Creech Warehouse", "Creech Brigade") --Ops.AirWing#AIRWING
US.Brigade.Creech:SetSpawnZone(BlueLogisticsZones.CreechSpawnZone)

if BlueDebug then
	US.Brigade.Creech:SetVerbosity(BlueVerbosity)
	US.Brigade.Creech:SetMarker(true)
end

--Add Platoons 
US.Platoon.Creech={}
US.Platoon.Creech.himarsHe = PLATOON:New("HIMARS-GMLRS-HE", -1, "Creech HIMARS-HE")
US.Platoon.Creech.himarsHe:AddMissionCapability(AUFTRAG.Type.ARTY)
US.Platoon.Creech.himarsHe:SetSkill(AI.Skill.AVERAGE)

US.Platoon.Creech.m270 = PLATOON:New("M270A1-GMLRS", -1, "Creech M270")
US.Platoon.Creech.m270:AddMissionCapability(AUFTRAG.Type.ARTY)
US.Platoon.Creech.m270:SetSkill(AI.Skill.AVERAGE)

US.Platoon.Creech.paladin = PLATOON:New("Paladin", -1, "Creech Paladin")
US.Platoon.Creech.paladin:AddMissionCapability(AUFTRAG.Type.ARTY)
US.Platoon.Creech.paladin:SetSkill(AI.Skill.AVERAGE)

US.Platoon.Creech.howitzer = PLATOON:New("Howitzer", -1, "CreechHowitzer")
US.Platoon.Creech.howitzer:AddMissionCapability(AUFTRAG.Type.ARTY)
US.Platoon.Creech.howitzer:SetSkill(AI.Skill.AVERAGE)


US.Platoon.Creech.abrams = PLATOON:New("Abrams", -1, "CreechAbrams")
US.Platoon.Creech.abrams:AddMissionCapability({AUFTRAG.Type.ARTY, AUFTRAG.Type.GROUNDATTACK, AUFTRAG.TypeARMORATTACK, AUFTRAG.Type.ARMOREDGUARD, AUFTRAG.Type.CAPTUREZONE, AUFTRAG.Type.ONGUARD, AUFTRAG.Type.PATROLZONE}, 100)
US.Platoon.Creech.abrams:SetSkill(AI.Skill.AVERAGE)

US.Platoon.Creech.infantry = PLATOON:New("Infantry", -1, "CreechInfantry")
US.Platoon.Creech.infantry:AddMissionCapability({AUFTRAG.Type.ARTY, AUFTRAG.Type.GROUNDATTACK, AUFTRAG.Type.CAPTUREZONE, AUFTRAG.Type.ONGUARD, AUFTRAG.Type.PATROLZONE}, 100)
US.Platoon.Creech.infantry:SetSkill(AI.Skill.AVERAGE)

-- Add Platoons to Creech Brigade
for _,platoon in pairs(US.Platoon.Creech) do
	US.Brigade.Creech:AddPlatoon(platoon)
end

BASE:I("----------------------------------------Creech BRIGADE LOADED-------------------------------------------------")



-- +-----------------------------+
-- |       Nellis & Creech PATROLS     |
-- +-----------------------------+  

local Zones = {}
Zones.Nellis = {}
Zones.CreechAir = {}
Zones.CreechGnd = {}
Zones.Tonopah = {}

Zones.Nellis.VegasApproachWest = ZONE:New("VegasApproachWest")                 --Core.Zone#ZONE
Zones.Nellis.VegasApproachNorth= ZONE:New("VegasApproachNorth")              --Core.Zone#ZONE
Zones.CreechAir.CreechApproachNW= ZONE:New("CreechApproachNW")                        --Core.Zone#ZONE
Zones.CreechAir.CreechApproachWest= ZONE:New("CreechApproachWest")                  --Core.Zone#ZONE
Zones.CreechAir.CreechCAP = ZONE:New("CreechCAP")
Zones.CreechGnd.West = ZONE:New("CreechGndWest")
Zones.Tonopah.TonopahCAP = ZONE:New("TonopahCAP")

--Zones.DubaiPatriotSite1= ZONE:New("DubaiPatriotSite1")                    --Core.Zone#ZONE
--Zones.DubaiPatriotSite2= ZONE:New("DubaiPatriotSite2")                    --Core.Zone#ZONE

if BlueDebug then
	for _,zone in pairs(Zones.Nellis) do
		zone:DrawZone(-1, {0,0,1})
	end
	for _,zone in pairs(Zones.CreechAir) do
		zone:DrawZone(-1, {0,0,1})
	end
end

for _,zone in pairs(Zones.Nellis) do
	local Patrol = AUFTRAG:NewPATROLZONE(zone)                              --Ops.AUFTRAG
	Patrol:AssignCohort(US.Squad.Nellis.AtkHelos)
	Patrol:SetRepeat(99)
	BlueChief:AddMission(Patrol)
end

for _,zone in pairs(Zones.CreechAir) do
	local Patrol = AUFTRAG:NewPATROLZONE(zone)                              --Ops.AUFTRAG
	Patrol:AssignCohort(US.Squad.Creech.AtkHelos)
	Patrol:SetRepeat(99)
	BlueChief:AddMission(Patrol)
end

for _,zone in pairs(Zones.CreechGnd) do
	local Patrol = AUFTRAG:NewPATROLZONE(zone)                              --Ops.AUFTRAG
	Patrol:AssignCohort(US.Platoon.Creech.abrams)
	Patrol:SetRepeat(99)
	BlueChief:AddMission(Patrol)
end




-- +-----------------------------+
-- |  BlueChief Managed Missions  |
-- +-----------------------------+

BASE:I("----------------------------------------BLUE CHIEF MISSIONS-------------------------------------------------")

--AWACS
local BlueAWACS = AUFTRAG:NewAWACS(BlueLogisticsZones.AwacsZone:GetCoordinate(), 30000, 300, 180, 20)
      BlueAWACS:SetRepeat(99)
      BlueAWACS:SetName("Blue AWACS")
      BlueChief:AddMission(BlueAWACS)

local BlueDrone = AUFTRAG:NewRECON(BlueLogisticsZones.DroneZone:GetCoordinate(), 300, 21000, true, false)
	BlueDrone:SetRepeat(99)
	BlueDrone:SetName("Blue Drone")
	BlueChief:AddMission(BlueDrone)

local BlueCreechCAP = AUFTRAG:NewCAP(Zones.CreechAir.CreechCAP, 20000, 300, Zones.CreechAir.CreechCAP:GetCoordinate(), 180, 20)
	BlueCreechCAP:SetRepeat(99)
	BlueCreechCAP:SetName("Blue Creech CAP")
	BlueChief:AddMission(BlueCreechCAP)



-- local TexacoAuftrag = AUFTRAG:NewTANKER(BlueLogisticsZones.TexacoZone:GetCoordinate(),20000,UTILS.KnotsToAltKIAS(250,20000),270,25,1)
-- 	TexacoAuftrag:AssignCohort(US.Squad.Nellis.tsqTEX)
-- 	TexacoAuftrag:SetRadio(251)
-- 	TexacoAuftrag:SetTACAN(51, "TEX")
-- 	TexacoAuftrag:SetName("Texaco Auftrag")
-- 	TexacoAuftrag:SetRepeat(99)
-- 	BlueChief:AddMission(TexacoAuftrag)

-- local ShellAuftrag = AUFTRAG:NewTANKER(BlueLogisticsZones.ShellZone:GetCoordinate(),22000,UTILS.KnotsToAltKIAS(250,22000),270,25,1)
-- 	ShellAuftrag:AssignCohort(US.Squad.Nellis.tsqSHL)
-- 	ShellAuftrag:SetRadio(256)
-- 	ShellAuftrag:SetTACAN(56, "SHL")
-- 	ShellAuftrag:SetName("Shell Auftrag")
-- 	ShellAuftrag:SetRepeat(99)
-- 	BlueChief:AddMission(ShellAuftrag)

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


BlueChief:SetResponseOnTarget(1, 2, 0, TARGET.Category.AIRCRAFT)
BlueChief:SetResponseOnTarget(1, 2, 0, nil, AUFTRAG.Type.BAI, nil)
BlueChief:SetResponseOnTarget(1, 3, 0, TARGET.Category.GROUND, nil ,nil, nil)

local BlueStrategicOccupied, resourceCAS=BlueChief:CreateResource(AUFTRAG.Type.CASENHANCED, 1, 2)
BlueChief:AddToResource(BlueStrategicOccupied, AUFTRAG.Type.ARTY, 1, 2, nil, "MLRS")
BlueChief:AddToResource(BlueStrategicOccupied, AUFTRAG.Type.RECON, 1, nil, GROUP.Attribute.AIR_UAV)

local BlueStrategicEmpty, resourceInf=BlueChief:CreateResource(AUFTRAG.Type.ONGUARD, 1, 5, GROUP.Attribute.GROUND_INFANTRY)
BlueChief:AddToResource(BlueStrategicEmpty, AUFTRAG.Type.ONGUARD, 1, 3, GROUP.Attribute.GROUND_TANK)
BlueChief:AddToResource(BlueStrategicEmpty, AUFTRAG.Type.PATROLZONE, 2)
BlueChief:AddTransportToResource(resourceInf, 1, 2, GROUP.Attribute.AIR_TRANSPORTHELO)

--local tonopahStratZone = BlueChief:AddStrategicZone(BlueStrategicZones.Tonopah, nil , 1)
BlueChief:AddStrategicZone(BlueStrategicZones.Tonopah, nil , 1, BlueStrategicOccupied, BlueStrategicEmpty)
BlueChief:AddAttackZone(BlueAttackZone)

BlueChief:AllowGroundTransport()

BlueChief:__Start(10)


-- +-----------------------------+
-- |       CHIEF LOGISTICS       |
-- +-----------------------------+

local function LaunchTexaco()
	local TexacoAuftrag = AUFTRAG:NewTANKER(BlueLogisticsZones.TexacoZone:GetCoordinate(),20000,UTILS.KnotsToAltKIAS(250,20000),270,25,1)
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
-- |   INITIAL TANKERS LAUNCH    |
-- +-----------------------------+
LaunchTexaco()
LaunchShell()







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
RedChief:SetDefcon(CHIEF.DEFCON.RED)
--RedChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
RedChief:SetStrategy(CHIEF.Strategy.AGGRESSIVE)
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
RED.Platoon={}



BASE:I("----------------------------------------RED TONOPAH AIRWING LOADING-------------------------------------------------")
--Set Up RED Airwing
RED.Wing.Tonopah = AIRWING:New("Tonopah Test Range Airfield", "Tonopah Test Range Airfield") --Ops.AirWing#AIRWING

if RedDebug then
	RED.Wing.Tonopah:SetVerbosity(RedVerbosity)
	RED.Wing.Tonopah:SetMarker(true)
end

--Add Squadrons 
RED.Squad.Tonopah={}

--Hinds Tonopah
RED.Squad.Tonopah.AtkHelos=SQUADRON:New("Hinds", 20, "Hinds Tonopah") --Ops.Squadron#SQUADRON
RED.Squad.Tonopah.AtkHelos:AddMissionCapability({AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE, AUFTRAG.Type.ALERT5}, 100)
RED.Squad.Tonopah.AtkHelos:SetFuelLowThreshold(0.1)
RED.Squad.Tonopah.AtkHelos:SetTurnoverTime(10,20)
RED.Squad.Tonopah.AtkHelos:SetSkill(AI.Skill.AVERAGE)
RED.Squad.Tonopah.AtkHelos:SetTakeoffHot()

--Hips Tonopah
RED.Squad.Tonopah.Hips=SQUADRON:New("Hips", 20, "Hips Tonopah") --Ops.Squadron#SQUADRON
RED.Squad.Tonopah.Hips:AddMissionCapability({AUFTRAG.Type.TROOPTRANSPORT, AUFTRAG.Type.CARGOTRANSPORT, AUFTRAG.Type.HOVER}, 100)
RED.Squad.Tonopah.Hips:SetFuelLowThreshold(0.1)
RED.Squad.Tonopah.Hips:SetTurnoverTime(10,20)
RED.Squad.Tonopah.Hips:SetSkill(AI.Skill.AVERAGE)
RED.Squad.Tonopah.Hips:SetTakeoffHot()

--SU27s for various tasks
RED.Squad.Tonopah.SU27s=SQUADRON:New("SU27s", 10, "SU27s Tonopah") --Ops.Squadron#SQUADRON
RED.Squad.Tonopah.SU27s:AddMissionCapability({AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
RED.Squad.Tonopah.SU27s:SetMissionRange(500)
RED.Squad.Tonopah.SU27s:SetSkill(AI.Skill.AVERAGE)
RED.Squad.Tonopah.SU27s:SetFuelLowRefuel(true)
RED.Squad.Tonopah.SU27s:SetFuelLowThreshold(35)
RED.Squad.Tonopah.SU27s:SetTurnoverTime(10,15)
RED.Squad.Tonopah.SU27s:SetTakeoffHot()


-- Add Squads to Tonopah Airwing
for _,squad in pairs(RED.Squad.Tonopah) do
	RED.Wing.Tonopah:AddSquadron(squad)
end

-- Add Payloads
RED.Wing.Tonopah:NewPayload("Hinds", -1,{AUFTRAG.Type.CASENHANCED, AUFTRAG.Type.BAI, AUFTRAG.Type.PATROLZONE, AUFTRAG.Type.ALERT5},100)
RED.Wing.Tonopah:NewPayload("SU27s", -1, {AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
RED.Wing.Tonopah:NewPayload("Hips", -1,{AUFTRAG.Type.TROOPTRANSPORT, AUFTRAG.Type.CARGOTRANSPORT, AUFTRAG.Type.HOVER},100)

if RedDebug then
	--- Display mission status on screen.
	local function MissionStatus()

		local text="Tonopah Missions:"
		for _,_mission in pairs(RED.Wing.Tonopah.missionqueue) do
			local m=_mission --Ops.Auftrag#AUFTRAG
			text=text..string.format("- %s %s %s*%d/%d [%d %%]  (%s*%d/%d)",
			m:GetName(), m:GetState():upper(), m:GetTargetName(), m:CountMissionTargets(), m:GetTargetInitialNumber(), m:GetTargetDamage(), m:GetType(), m:CountOpsGroups(), m:GetNumberOfRequiredAssets())
		end

		-- Payloads
		text=text.."Available Payloads:"
		for _,aname in pairs(AUFTRAG.Type) do
			local n=RED.Wing.Tonopah:CountPayloadsInStock({aname})
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

BASE:I("----------------------------------------TONOPAH AIRWING LOADED-------------------------------------------------")





BASE:I("----------------------------------------RED TONOPAH BRIGADE LOADING-------------------------------------------------")
RED.Brigade.Tonopah = BRIGADE:New("Tonopah Brigade", "Tonopah Brigade") --Ops.Brigade#BRIGADE

if RedDebug then
	RED.Brigade.Tonopah:SetVerbosity(RedVerbosity)
	RED.Brigade.Tonopah:SetMarker(true)
end

--Add Squadrons 
RED.Platoon.Tonopah={}

--Transports Tonopah
-- RED.Platoon.Tonopah.Trucks = PLATOON:New("Transports", 6,"Transports Tonopah") --Ops.Platoon#PLATOON
-- RED.Platoon.Tonopah.Trucks:AddMissionCapability({AUFTRAG.Type.CARGOTRANSPORT}, 100)
-- RED.Platoon.Tonopah.Trucks:SetSkill(AI.Skill.AVERAGE)	
-- RED.Platoon.Tonopah.Trucks:SetTransport(20, 10, 1000, 5000, 10000)
-- RED.Platoon.Tonopah.Trucks:SetTurnoverTime(10,20)







local RedZones = {}
RedZones.TonopahApproachSE = ZONE:New("TonopahApproachSE")

if RedDebug then
	for _,zone in pairs(RedZones) do
		zone:DrawZone(-1, {0,0,1})
	end
end

for _,zone in pairs(RedZones) do
	local Patrol = AUFTRAG:NewPATROLZONE(zone)                              --Ops.AUFTRAG
	Patrol:AssignCohort(RED.Squad.Tonopah.AtkHelos)
	Patrol:SetRepeat(99)
	RedChief:AddMission(Patrol)
end


local RedTonopahCAP = AUFTRAG:NewCAP(Zones.Tonopah.TonopahCAP, 20000, 300, Zones.Tonopah.TonopahCAP:GetCoordinate(), 180, 20)
	RedTonopahCAP:SetRepeat(99)
	RedTonopahCAP:SetName("Red Tonopah CAP")
	RedChief:AddMission(RedTonopahCAP)


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







--- Function called when the DEFCON changes.
function BlueChief:OnAfterDefconChange(From, Event, To, Defcon)
  local text=string.format("Blue changed DEFCON to %s", Defcon)
  MESSAGE:New(text, 120):ToAll()    
end

function RedChief:OnAfterDefconChange(From, Event, To, Defcon)
  local text=string.format("Red changed DEFCON to %s", Defcon)
  MESSAGE:New(text, 120):ToAll()    
end

--- Function called when the STRATEGY changes.
function BlueChief:OnAfterStrategyChange(From, Event, To, Strategy)
  local text=string.format("Blue strategy changd to %s", Strategy)
  MESSAGE:New(text, 120):ToAll()
end

--- Function called when the STRATEGY changes.
function RedChief:OnAfterStrategyChange(From, Event, To, Strategy)
  local text=string.format("Red strategy changd to %s", Strategy)
  MESSAGE:New(text, 120):ToAll()
end


-- HoundTTS.Transmit("Bogey, bullseye 270 for 15",
--     { freqs = "262.0", coalition = 2, name = "GCI" },
--     { provider = "piper", voice = "en_GB_cori-high" }
-- )

trigger.action.outText('MISSION FILE: GROUND TRAINING...LOADED', 5)
BASE:I("----------------------------------------MISSION LOADED-------------------------------------------------")

BASE:I("----------------------------------------EVERYTHING LOADED (IT'S A MIRACLE!) -------------------------------------------------")
trigger.action.outText('-----------------EVERYTHING LOADED (ITS A MIRACLE!)------------------', 15)
	  
	  
	  






-- -- Drop-in STTS replacement
-- HoundTTS.TextToSpeech("Hello DCS World", "251.0", "AM", 1.0, "ATC", 2)

-- -- Piper TTS over SRS
-- HoundTTS.Transmit(
--     "Bogey, bullseye 270 for 15",
--     { freqs = "251.0", modulations = "AM", coalition = 2, name = "GCI" },
--     { provider = "piper", voice = "en_US-lessac-low" }
-- )