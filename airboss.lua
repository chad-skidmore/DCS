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



local airbossGW=AIRBOSS:New(abConfig.carriername, abConfig.carrieralias)
  airbossGW:SetDespawnOnEngineShutdown()
  airbossGW:SetTACAN(abConfig.tacan, "X", abConfig.carrieralias)
  airbossGW:SetLSORadio(abConfig.lsoRadio, "AM")
  airbossGW:SetMarshalRadio(abConfig.marshalRadio, "AM")
  airbossGW:SetRecoveryCase(abConfig.case)
  airbossGW:SetCarrierControlledArea(abConfig.cca)
  airbossGW:SetDefaultPlayerSkill(abConfig.skill)
  airbossGW:SetRadioRelayLSO(abConfig.radioRelayLso)
  airbossGW:SetRadioRelayMarshal(abConfig.radioRelayMarshal)
  airbossGW:SetSoundfilesFolder("AirbossSoundfiles/")
  airbossGW:SetVoiceOversMarshalByGabriella("AirbossSoundfiles/")
  airbossGW:SetVoiceOversLSOByRaynor("AirbossSoundfiles/")
airbossGW:Start()
airboss:SetDebugModeON()



local Rescuehelo=RESCUEHELO:New(UNIT:FindByName(abConfig.carriername), "Rescue Helo")
Rescuehelo:SetTakeoffHot()





function airbossGW:OnAfterRecoveryStart(From, Event, To, Case, Offset)
  MESSAGE:New("USS George Washington recovery starting", 120):ToAll()
end

function airbossGW:OnAfterRecoveryStop(From, Event, To)
  MESSAGE:New("USS George Washington recovery stopping", 120):ToAll()
end

function Rescuehelo:onafterRTB(From, Event, To, airbase)
    MESSAGE:New("Rescue Helo is RTB", 120):ToAll()
end

function Rescuehelo:onafterStatus(From, Event, To)
    local text=string.format("Rescue Helo Status: From %s, Event %s, To %s", From, Event, To)
    MESSAGE:New(text, 120):ToAll()
end




function BeginRecovery()
    StartRescueHelo()
    local window1=airbossGW:AddRecoveryWindow()
end

function StopRecovery()
    airbossGW:CloseCurrentRecoveryWindow()
    Rescuehelo:RTB()
    --Rescuehelo:__RTB(90)
end

function StartRescueHelo()
    if Rescuehelo:IsStopped() then
        Rescuehelo:Start()
        --TIMER:New(RescueheloStatus):Start(60, 30)
    end
end

local RecoveryMenu=MENU_MISSION:New("Recovery Menu")--#MENU
local RecoveryMenu1 = MENU_MISSION_COMMAND:New("Begin Recovery", RecoveryMenu, BeginRecovery)--#MENU
local RecoveryMenu2 = MENU_MISSION_COMMAND:New("Stop Recovery", RecoveryMenu, StopRecovery)--#MENU











Red side.
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










StartRescueHelo()
-- TIMER:New(RescueheloState):Start(5, 30)








BASE:I("----------------------------------------AIRBOSS TRAINING MISSION LOAD COMPLETE-------------------------------------------------")
trigger.action.outText('-----------------AIRBOSS TRAINING MISSION LOAD COMPLETE------------------', 15)