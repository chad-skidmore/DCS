BASE:I("----------------------------------------LOADING THE AIRBOSS TRAINING MISSION -------------------------------------------------")
trigger.action.outText('-----------------LOADING THE AIRBOSS TRAINING MISSION------------------', 15)


local abConfig = {}
abConfig.carriername = "USS George Washington"
abConfig.carrieralias = "GW"
abConfig.tacan = "73"
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
airbossGW:Start()

function airbossGW:OnAfterRecoveryStart(From, Event, To, Case, Offset)
  local text=string.format("Recovery going from %s to %s", From, To)
  MESSAGE:New(text, 120):ToAll()
end

function airbossGW:OnAfterRecoveryStop(From, Event, To)
  local text=string.format("Recovery going from %s to %s", From, To)
  MESSAGE:New(text, 120):ToAll()
end

BASE:I("----------------------------------------AIRBOSS TRAINING MISSION LOAD COMPLETE-------------------------------------------------")
trigger.action.outText('-----------------AIRBOSS TRAINING MISSION LOAD COMPLETE------------------', 15)