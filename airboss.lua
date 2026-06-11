BASE:I("----------------------------------------LOADING THE AIRBOSS TRAINING MISSION -------------------------------------------------")
trigger.action.outText('-----------------LOADING THE AIRBOSS TRAINING MISSION------------------', 15)



-- SETUP DEBUGGING AND TRACING
RedDebug = true
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
    BASE:TraceOnOff(true)
    BASE:TraceLevel(3)
    BASE:TraceClass("AIRBOSS")
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
abConfig.radioRelayLso = "gwlsorelay"
abConfig.radioRelayMarshal = "gwmarshalrelay"

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
  airbossGW:AddRecoveryWindow("7:00", "9:30", 1)
airbossGW:Start()




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
    airbossGW:SetRadioRelayMarshal(self:GetUnitName())
end

function tanker:OnAfterStart(From,Event,To)
  airbossGW:SetRecoveryTanker(tanker)  
  airbossGW:SetRadioRelayLSO(self:GetUnitName())
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

local RecoveryMenu=MENU_MISSION:New("Recovery Menu")--#MENU
local RecoveryMenu1 = MENU_MISSION_COMMAND:New("Begin Recovery", RecoveryMenu, BeginRecovery)--#MENU
local RecoveryMenu2 = MENU_MISSION_COMMAND:New("Stop Recovery", RecoveryMenu, StopRecovery)--#MENU







local BLUE={}
BLUE.Wing={}--Ops.AirWing#AIRWING
BLUE.Squad={}--Ops.Squadron#SQUADRON
BLUE.Fleet={}--Ops.Fleet#FLEET
BLUE.Flotilla={}--Ops.Flotilla#FLOTILLA
BLUE.Brigade={}--Ops.Brigade#BRIGADE
BLUE.Platoon={}

local BlueLogisticsZones = {}

local BlueIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.BLUE):FilterStart()
local BlueChief = CHIEF:New(coalition.side.BLUE, BlueIntelProviders, "Blue Chief")

BlueChief:SetBorderZones(BlueBorderZones)
BlueChief:SetDefcon(CHIEF.DEFCON.GREEN)
BlueChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
--RedChief:SetStrategy(CHIEF.Strategy.AGGRESSIVE)
BlueChief:SetThreatLevelRange(1, 1000)
BlueChief:SetConflictZones(ConflictZones)




local RED={}
RED.Wing={}--Ops.AirWing#AIRWING
RED.Squad={}--Ops.Squadron#SQUADRON
RED.Fleet={}--Ops.Fleet#FLEET
RED.Flotilla={}--Ops.Flotilla#FLOTILLA
RED.Brigade={}--Ops.Brigade#BRIGADE
RED.Platoon={}

local RedLogisticsZones = {}

local RedIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.RED):FilterStart()
local RedChief = CHIEF:New(coalition.side.RED, RedIntelProviders, "Red Chief")

RedChief:SetBorderZones(RedBorderZones)
RedChief:SetDefcon(CHIEF.DEFCON.GREEN)
RedChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
--RedChief:SetStrategy(CHIEF.Strategy.AGGRESSIVE)
RedChief:SetThreatLevelRange(1, 1000)
RedChief:SetConflictZones(ConflictZones)





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












StartRescueHelo()
-- TIMER:New(RescueheloState):Start(5, 30)








BASE:I("----------------------------------------AIRBOSS TRAINING MISSION LOAD COMPLETE-------------------------------------------------")
trigger.action.outText('-----------------AIRBOSS TRAINING MISSION LOAD COMPLETE------------------', 15)