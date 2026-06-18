BASE:I("----------------------------------------LOADING THE AIRBOSS TRAINING MISSION -------------------------------------------------")
trigger.action.outText('-----------------LOADING THE AIRBOSS TRAINING MISSION------------------', 15)



-- SETUP DEBUGGING AND TRACING
RedDebug = true
RedVerbosity = 6

BlueDebug = true
BlueVerbosity = 6

if RedDebug or BlueDebug then
    trigger.action.outText('DEBUG IS ACTIVE', 10)
    BASE:TraceLevel(4)
    BASE:TraceClass("AIRBOSS")
    --BASE:TraceClass("AUFTRAG")
    --BASE:TraceClass("AIRWING")
    --BASE:TraceClass("BRIGADE")
    --BASE:TraceClass("CHIEF")
    --BASE:TraceClass("FLOTILLA")
    --BASE:TraceClass("FLEET")
    BASE:TraceOnOff(true)
    --BASE:TraceClass("AIRBOSS")
end



--Seed the Random Function a few times
math.random(100)
math.random(100)
math.random(100)
math.random(100)
math.random(100)
math.random(100)


-- SETUP ALL OF THE PRIMARY ZONES
local BlueBorderZones = SET_ZONE:New():FilterPrefixes("BlueBorder"):FilterOnce()
local RedBorderZones = SET_ZONE:New():FilterPrefixes("RedBorder"):FilterOnce()
local ConflictZones = SET_ZONE:New():FilterPrefixes("ConflictZone"):FilterOnce()

if BlueDebug then BlueBorderZones:DrawZone(-1, {0,0,1} , 1, {0,0,1}) end
if RedDebug then RedBorderZones:DrawZone(-1, {1,0,0} , 1, {1,0,0}) end
if BlueDebug then ConflictZones:DrawZone(-1, {0,1,0} , 1, {0,1,0}) end
if RedDebug then ConflictZones:DrawZone(-1, {0,1,0} , 1, {0,1,0}) end



-- SETUP THE GW AIRBOSS
local abConfig = {}
abConfig.carriername = "USS George Washington"
abConfig.carrieralias = "GW"
abConfig.tacan = 73
abConfig.icls = 1
abConfig.lsoRadio = 260
abConfig.marshalRadio = 261
abConfig.case = 1
abConfig.cca = 50
abConfig.skill = "Flight Student"
abConfig.radioRelayLso = "USS Ted Stevens"
abConfig.radioRelayMarshal = "USS Viksburg"

-- No MOOSE settings menu. Comment out this line if required.
_SETTINGS:SetPlayerMenuOff()

-- S-3B Recovery Tanker spawning in air.
local tanker=RECOVERYTANKER:New("USS George Washington", "Tanker")
tanker:SetTakeoffAir()
tanker:SetRadio(250)
tanker:SetModex(511)
tanker:SetTACAN(1, "TKR")
tanker:__Start(1)

-- E-2D AWACS spawning on Stennis.
local awacs=RECOVERYTANKER:New("USS George Washington", "Blue AWACS")
awacs:SetAWACS()
awacs:SetRadio(251)
awacs:SetAltitude(20000)
awacs:SetCallsign(CALLSIGN.AWACS.Wizard)
awacs:SetRacetrackDistances(30, 15)
awacs:SetModex(611)
awacs:SetTACAN(2, "WIZ")
awacs:__Start(1)






local airbossGW=AIRBOSS:New(abConfig.carriername, abConfig.carrieralias)
  airbossGW:SetDespawnOnEngineShutdown()
  airbossGW:SetTACAN(abConfig.tacan, "X", abConfig.carrieralias)
  airbossGW:SetLSORadio(abConfig.lsoRadio, "AM")
  airbossGW:SetMarshalRadio(abConfig.marshalRadio, "AM")
  airbossGW:SetRecoveryCase(abConfig.case)
  airbossGW:SetCarrierControlledArea(abConfig.cca)
  airbossGW:SetDefaultPlayerSkill(abConfig.skill)
  airbossGW:SetSoundfilesFolder("AirbossSoundfiles/")
  airbossGW:SetVoiceOversMarshalByGabriella("AirbossSoundfiles/MarshalGabriella/")
  airbossGW:SetVoiceOversLSOByRaynor("AirbossSoundfiles/LSORaynor/")
  airbossGW:SetMenuSingleCarrier()
  airbossGW:SetMenuRecovery(30, 20, false)
  airbossGW:SetDebugModeON()
  airbossGW:Load()
  airbossGW:SetAutoSave()
  airbossGW:SetTrapSheet()
  airbossGW:SetRadioRelayMarshal(abConfig.radioRelayMarshal)
  airbossGW:SetRadioRelayLSO(abConfig.radioRelayLso)
  airbossGW:AddRecoveryWindow("7:00", "9:30", 1)
airbossGW:__Start(2)






local Rescuehelo=RESCUEHELO:New(UNIT:FindByName(abConfig.carriername), "Rescue Helo")
Rescuehelo:SetTakeoffHot()





function airbossGW:OnAfterRecoveryStart(From, Event, To, Case, Offset)
  MESSAGE:New("USS George Washington recovery starting", 120):ToAll()
  StartRescueHelo()
end

function airbossGW:OnAfterRecoveryStop(From, Event, To)
  MESSAGE:New("USS George Washington recovery stopping", 120):ToAll()
  Rescuehelo:RTB()
end

function Rescuehelo:onafterRTB(From, Event, To, airbase)
    MESSAGE:New("Rescue Helo is RTB", 120):ToAll()
end

function Rescuehelo:onafterStatus(From, Event, To)
    local text=string.format("Rescue Helo Status: From %s, Event %s, To %s", From, Event, To)
    MESSAGE:New(text, 120):ToAll()
end

function tanker:OnAfterStart(From,Event,To)
  airbossGW:SetRecoveryTanker(tanker)
end

--- Function called when AWACS is started.
function awacs:OnAfterStart(From,Event,To)
  airbossGW:SetAWACS(awacs)
end


function BeginRecovery()
    StartRescueHelo()
    airbossGW:RecoveryStart(1 )
end

function StopRecovery()
    airbossGW:CloseCurrentRecoveryWindow()
    Rescuehelo:RTB()
end

function StartRescueHelo()
    if Rescuehelo:IsStopped() then
        Rescuehelo:Start()
    end
end

-- local RecoveryMenu=MENU_MISSION:New("Recovery Menu")--#MENU
-- local RecoveryMenu1 = MENU_MISSION_COMMAND:New("Begin Recovery", RecoveryMenu, BeginRecovery)--#MENU
-- local RecoveryMenu2 = MENU_MISSION_COMMAND:New("Stop Recovery", RecoveryMenu, StopRecovery)--#MENU







local BLUE={}
BLUE.Wing={}--Ops.AirWing#AIRWING
BLUE.Squad={}--Ops.Squadron#SQUADRON
BLUE.Fleet={}--Ops.Fleet#FLEET
BLUE.Flotilla={}--Ops.Flotilla#FLOTILLA
BLUE.Brigade={}--Ops.Brigade#BRIGADE
BLUE.Platoon={}

local navcentPort = ZONE:New("ZonePort5thFleet")
local navcentSpawn = ZONE:New("ZoneSpawn5thFleet")
local navcentPatrol = ZONE:New("ZonePatrol5thFleet")

local BlueLogisticsZones = {}
BlueLogisticsZones.AwacsZone= ZONE:New("AwacsZone")
BlueLogisticsZones.missleZone = ZONE:New("missleZone")
BlueLogisticsZones.missleZone2 = ZONE:New("missleZone")

local BlueStrategicZones = {}
BlueStrategicZones.Platforms = OPSZONE:New(ZONE:FindByName("StrategicZone-1"), coalition.side.RED)

local BlueIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.BLUE):FilterStart()
local BlueChief = CHIEF:New(coalition.side.BLUE, BlueIntelProviders, "Blue Chief")

BlueChief:SetBorderZones(BlueBorderZones)
BlueChief:SetDefcon(CHIEF.DEFCON.GREEN)
BlueChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
--RedChief:SetStrategy(CHIEF.Strategy.AGGRESSIVE)
BlueChief:SetThreatLevelRange(1, 1000)
BlueChief:SetConflictZones(ConflictZones)
BlueChief:AddStrategicZone(BlueStrategicZones.Platforms, nil , 1)



BLUE.Wing.AlDhafra = AIRWING:New("Al Dhafra AFB", "Al Dhafra AFB") --Ops.AirWing#AIRWING

if BlueDebug then
    BLUE.Wing.AlDhafra:SetVerbosity(BlueVerbosity)
    BLUE.Wing.AlDhafra:SetMarker(true)
end

--Add Squadrons 
BLUE.Squad.AlDhafra={}


--AWACS
BLUE.Squad.AlDhafra.e3=SQUADRON:New("E3", 4, "E3 AlDhafra") --Ops.Squadron#SQUADRON
BLUE.Squad.AlDhafra.e3:AddMissionCapability({AUFTRAG.Type.AWACS, AUFTRAG.Type.ALERT5}, 100)
BLUE.Squad.AlDhafra.e3:SetFuelLowThreshold(0.1)
BLUE.Squad.AlDhafra.e3:SetTurnoverTime(10,20)
BLUE.Squad.AlDhafra.e3:SetMissionRange(500)
BLUE.Squad.AlDhafra.e3:SetSkill(AI.Skill.AVERAGE)
BLUE.Squad.AlDhafra.e3:SetRadio(251)
BLUE.Squad.AlDhafra.e3:SetCallsign(CALLSIGN.AWACS.Darkstar,1)
BLUE.Squad.AlDhafra.e3:SetTakeoffHot()


-- Add Squads to AlDhafra Airwing
for _,squad in pairs(BLUE.Squad.AlDhafra) do
    BLUE.Wing.AlDhafra:AddSquadron(squad)
end


-- Add Payloads
BLUE.Wing.AlDhafra:NewPayload("E3",-1, {AUFTRAG.Type.AWACS},100)





BLUE.Fleet.fifthfleet = FLEET:New("NAVCENT", "NAVCENT 5th Fleet")
BLUE.Fleet.fifthfleet:SetPortZone(navcentPort)
BLUE.Fleet.fifthfleet:SetSpawnZone(navcentSpawn)
BLUE.Fleet.fifthfleet:SetPathfinding(true)
BLUE.Fleet.fifthfleet:Start()

BLUE.Flotilla.DDG1 = FLOTILLA:New("DDG", 2, "DDG1")
BLUE.Flotilla.DDG1:AddMissionCapability({AUFTRAG.Type.PATROLZONE}, 60)
BLUE.Flotilla.DDG1:AddMissionCapability({AUFTRAG.Type.ARTY}, 80)
BLUE.Flotilla.DDG1:AddMissionCapability({AUFTRAG.Type.NAVELENGAGEMENT}, 100)
BLUE.Flotilla.DDG1:AddWeaponRange(20, 700, ENUMS.WeaponFlag.CruiseMissle)
BLUE.Flotilla.DDG1:AddWeaponRange(2.7, 13, ENUMS.WeaponFlag.Cannons)
BLUE.Flotilla.DDG1:SetSkill("Excellent")
BLUE.Flotilla.DDG1:SetRadio(251.00, radio.modulation.AM)
BLUE.Fleet.fifthfleet:AddFlotilla(BLUE.Flotilla.DDG1)

BLUE.Flotilla.Sub = FLOTILLA:New("Sub", 2, "Sub1")
BLUE.Flotilla.Sub:AddMissionCapability({AUFTRAG.Type.PATROLZONE}, 60)
BLUE.Flotilla.Sub:AddMissionCapability({AUFTRAG.Type.ARTY}, 80)
BLUE.Flotilla.Sub:AddMissionCapability({AUFTRAG.Type.NAVELENGAGEMENT}, 100)
BLUE.Flotilla.Sub:AddWeaponRange(20, 700, ENUMS.WeaponFlag.CruiseMissle)
BLUE.Flotilla.Sub:SetSkill("Excellent")
BLUE.Flotilla.Sub:SetRadio(251.00, radio.modulation.AM)
BLUE.Fleet.fifthfleet:AddFlotilla(BLUE.Flotilla.Sub)

-- +-----------------------------+
-- |       BLUE ACTIVATION       |
-- +-----------------------------+
-- Add squadrons to airwing.
for _,Wing in pairs(BLUE.Wing) do
    BlueChief:AddAirwing(Wing)

    if BlueDebug then
        Wing:SetVerbosity(BlueVerbosity)
        Wing:SetMarker(true)
    end
end

for _,Fleet in pairs(BLUE.Fleet) do
    BlueChief:AddFleet(Fleet)
    if BlueDebug then
        Fleet:SetVerbosity(BlueVerbosity)
        Fleet:SetMarker(true)
    end
end



--AWACS
local BlueAWACS = AUFTRAG:NewAWACS(BlueLogisticsZones.AwacsZone:GetCoordinate(), 30000, 300, 180, 20)
      BlueAWACS:SetRepeat(99)
      BlueAWACS:SetName("Blue AWACS")
      BlueChief:AddMission(BlueAWACS)

-- local missionFleetPatrol = AUFTRAG:NewPATROLZONE(navcentPatrol, 15)
--       missionFleetPatrol:SetRequiredAssets(1)
--       missionFleetPatrol:AssignCohort(BLUE.Flotilla.DDG1)
--       BlueChief:AddMission(missionFleetPatrol)

local RedEwrGroup = UNIT:FindByName("RedEWR-1")
if not RedEwrGroup then
  env.error(string.format(
    "[NAVAL STRIKE] Target group '%s' not found - check the name in the Mission Editor.",
    TARGET_GROUP_NAME))
  return
end
local missionFleetPatrol = AUFTRAG:NewARTY(RedEwrGroup:GetCoordinate(), 2)
--local missionFleetPatrol = AUFTRAG:NewNAVALENGAGEMENT(RedEwrGroup, 18)
      missionFleetPatrol:SetRequiredAssets(2, 2)
      missionFleetPatrol:AssignCohort(BLUE.Flotilla.DDG1)
      missionFleetPatrol:SetWeaponType(ENUMS.WeaponFlag.CruiseMissile)
      missionFleetPatrol:SetMissionWaypointCoord(BlueLogisticsZones.missleZone2:GetCoordinate())
      missionFleetPatrol:SetMissionSpeed(30)
      BlueChief:AddMission(missionFleetPatrol)

local subStrike = AUFTRAG:NewARTY(RedEwrGroup:GetCoordinate(), 2)
--local missionFleetPatrol = AUFTRAG:NewNAVALENGAGEMENT(RedEwrGroup, 18)
      subStrike:SetRequiredAssets(1, 1)
      subStrike:AssignCohort(BLUE.Flotilla.DDG1)
      subStrike:SetWeaponType(ENUMS.WeaponFlag.CruiseMissile)
      subStrike:SetMissionWaypointCoord(BlueLogisticsZones.missleZone:GetCoordinate())
      subStrike:SetMissionSpeed(20)
      BlueChief:AddMission(missionFleetPatrol)




local RED={}
RED.Wing={}--Ops.AirWing#AIRWING
RED.Squad={}--Ops.Squadron#SQUADRON
RED.Fleet={}--Ops.Fleet#FLEET
RED.Flotilla={}--Ops.Flotilla#FLOTILLA
RED.Brigade={}--Ops.Brigade#BRIGADE
RED.Platoon={}

local RedLogisticsZones = {}
local RedStrategicZones = {}
RedStrategicZones.Platforms = OPSZONE:New(ZONE:FindByName("StrategicZone-1"), coalition.side.RED)

local RedIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.RED):FilterStart()
local RedChief = CHIEF:New(coalition.side.RED, RedIntelProviders, "Red Chief")

RedChief:SetBorderZones(RedBorderZones)
RedChief:SetDefcon(CHIEF.DEFCON.GREEN)
RedChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
RedChief:SetThreatLevelRange(1, 1000)
RedChief:SetConflictZones(ConflictZones)
RedChief:AddStrategicZone(RedStrategicZones.Platforms, nil , 1)

RED.Fleet.BandarLengeh = FLEET:New("Bandar Lengeh", "Bandar Lengeh")
RED.Fleet.BandarLengeh:SetPortZone(ZoneBandarLengeh)
RED.Fleet.BandarLengeh:SetSpawnZone(ZoneBandarLengeh)
RED.Fleet.BandarLengeh:SetPathfinding(true)
RED.Fleet.BandarLengeh:Start()

RED.Flotilla.fastattack = FLOTILLA:New("RedFastAttack", 12, "FastAttack")
RED.Flotilla.fastattack:AddMissionCapability({AUFTRAG.Type.PATROLZONE}, 60)
RED.Flotilla.fastattack:AddMissionCapability({AUFTRAG.Type.ARTY}, 80)
RED.Flotilla.fastattack:AddMissionCapability({AUFTRAG.Type.NAVELENGAGEMENT}, 100)
-- RED.Flotilla.fastattack:AddWeaponRange(20, 700, ENUMS.WeaponFlag.CruiseMissle)
-- RED.Flotilla.fastattack:AddWeaponRange(2.7, 13, ENUMS.WeaponFlag.Cannons)
RED.Flotilla.fastattack:SetSkill("Excellent")
RED.Flotilla.fastattack:SetRadio(251.00, radio.modulation.AM)
RED.Fleet.BandarLengeh:AddFlotilla(RED.Flotilla.fastattack)



if BlueDebug then
    BlueChief:SetVerbosity(BlueVerbosity)
    BlueChief:SetClusterAnalysis(true,true)   -- Enable Intel clusters and markers
    BlueChief:SetTacticalOverviewOn()
end
if RedDebug then
    RedChief:SetVerbosity(RedVerbosity)
    RedChief:SetClusterAnalysis(true,true)   -- Enable Intel clusters and markers
    RedChief:SetTacticalOverviewOn()
end

BlueChief:__Start(10)
RedChief:__Start(10)



myredmantis = MANTIS:New("myredmantis","Red SAM","Red EWR",nil,"red",false)
myredmantis:AddZones(RedBorderZones,BlueBorderZones,ConflictZones)
myredmantis:Start()




-- local rat737 = RAT:New("Rat-737")
-- rat737:SetTakeoff("cold")
-- rat737:Spawn(2)

-- local rat757 = RAT:New("Rat-757")
-- rat757:SetTakeoff("cold")
-- rat757:Spawn(2)

-- local ratA320 = RAT:New("Rat-A320")
-- ratA320:SetTakeoff("cold")
-- ratA320:Spawn(2)





--StartRescueHelo()





BASE:I("----------------------------------------AIRBOSS TRAINING MISSION LOAD COMPLETE-------------------------------------------------")
trigger.action.outText('-----------------AIRBOSS TRAINING MISSION LOAD COMPLETE------------------', 15)