BASE:I("----------------------------------------LOADING THE AIRBOSS TRAINING MISSION -------------------------------------------------")
trigger.action.outText('-----------------LOADING THE AIRBOSS TRAINING MISSION------------------', 15)


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

local Rescuehelo=RESCUEHELO:New(UNIT:FindByName(abConfig.carriername), "Rescue Helo")
Rescuehelo:SetTakeoffHot()

function airbossGW:OnAfterRecoveryStart(From, Event, To, Case, Offset)
  MESSAGE:New("USS George Washington recovery starting", 120):ToAll()
end

function airbossGW:OnAfterRecoveryStop(From, Event, To)
  MESSAGE:New("USS George Washington recovery stopping", 120):ToAll()
end

local function BeginRecovery()
    StartRescueHelo()
    local window1=airbossGW:AddRecoveryWindow(nil, nil, abConfig.case, nil, true, 25)
end

local function StopRecovery()
    airbossGW:DeleteRecoveryWindow(window1, 30)
    Rescuehelo:__RTB(90)
end

function StartRescueHelo()
    if Rescuehelo:IsStopped() then
        Rescuehelo:Start()
    end
end

local RecoveryMenu=MENU_MISSION:New("Recovery Menu")--#MENU
local RecoveryMenu1 = MENU_MISSION_COMMAND:New("Begin Recovery", RecoveryMenu, BeginRecovery)--#MENU
local RecoveryMenu2 = MENU_MISSION_COMMAND:New("Stop Recovery", RecoveryMenu, StopRecovery)--#MENU


StartRescueHelo()

BASE:I("----------------------------------------AIRBOSS TRAINING MISSION LOAD COMPLETE-------------------------------------------------")
trigger.action.outText('-----------------AIRBOSS TRAINING MISSION LOAD COMPLETE------------------', 15)