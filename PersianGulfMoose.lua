

BASE:I("----------------------------------------LOADING THE PERSIAN GULF MISSION -------------------------------------------------")
trigger.action.outText('-----------------LOADING THE PERSIAN GULF MISSION------------------', 15)



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
   BASE:TraceClass("MANTIS")
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
-- |      HELPER FUNCTIONS       |
-- +-----------------------------+

--- Function returns true, is a unit of a give name is dead.
local function UnitDead(name)
  local unit=UNIT:FindByName(name)
  if not unit then
    return true
  else
    return not unit:IsAlive()
  end
end






-- +-----------------------------+
-- |      DEFINE ALL ZONES       |
-- +-----------------------------+
BASE:I("----------------------------------------DEFINING ALL ZONES-------------------------------------------------")

local BlueBorderZones = ZONE_POLYGON:New("BlueBorder",GROUP:FindByName("Blue Border"))
local RedBorderZones = ZONE_POLYGON:New("RedBorder",GROUP:FindByName("Red Border"))
local ConflictZones = SET_ZONE:New():FilterPrefixes("ConflictZone"):FilterOnce()
local RedAttackZones = SET_ZONE:New():FilterPrefixes("RedAttackZone"):FilterOnce()


--Logistics Zones
   local BlueLogisticsZones = {}
      BlueLogisticsZones.TexacoZone= ZONE:New("TexacoZone")--Core.Zone#ZONE
      BlueLogisticsZones.ShellZone= ZONE:New("ShellZone")--Core.Zone#ZONE
      BlueLogisticsZones.AwacsZone= ZONE:New("AwacsZone")--Core.Zone#ZONE
   local AwacsCoord = BlueLogisticsZones.AwacsZone:GetCoordinate()

if BlueDebug then BlueBorderZones:DrawZone(-1, {0,0,1} , 1, {0,0,1}) end
if BlueDebug then ConflictZones:DrawZone(-1, {0,1,0} , 1, {0,1,0}) end
if RedDebug then RedBorderZones:DrawZone(-1, {1,0,0} , 1, {1,0,0}) end
if RedDebug then ConflictZones:DrawZone(-1, {0,1,0} , 1, {0,1,0}) end
if BlueDebug then
   for _,zone in pairs(BlueLogisticsZones) do
      zone:DrawZone(-1, {0,0,1})
   end
end

BASE:I("----------------------------------------ZONES SET--------------------------------------------------")



BASE:I("----------------------------------------RED CHIEF--------------------------------------------------")
-- +-----------------------------+
-- |     CONFIGURE RED CHIEF     |
-- +-----------------------------+ 

local RedIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.RED):FilterStart()
local RedChief = CHIEF:New(coalition.side.RED, RedIntelProviders, "Red Chief")
RedChief:SetBorderZones(RedBorderZones)
RedChief:SetConflictZones(ConflictZones)
--RedChief:SetDefcon(CHIEF.DEFCON.GREEN)
RedChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
RedChief:SetThreatLevelRange(0, 1000)
RedChief:SetDetectStatics(true)


if RedDebug then
   RedChief:SetVerbosity(RedVerbosity)
   RedChief:SetClusterAnalysis(true,true)
   RedChief:SetTacticalOverviewOn()
end

BASE:I("----------------------------------------RED CHIEF SET-------------------------------------------------")
trigger.action.outText('RED CHIEF LOADED', 10)


BASE:I("----------------------------------------RED ELEMENTS--------------------------------------------------")
-- +-----------------------------+
-- |   CONFIGURE RED ELEMENTS    |
-- +-----------------------------+ 

local Red={}
      Red.Wing={}
      Red.Squad={}
      Red.Fleet={}
      Red.Flotilla={}
      Red.Brigade={}
      Red.Platoon={}
      Red.Target={} 

Red.Squad.BandarAbbas={}

BASE:I("----------------------------------------RED ELEMENTS SET-------------------------------------------------")



BASE:I("----------------------------------------RED AIRWING LOADING-------------------------------------------------")
-- +-----------------------------+
-- |   CONFIGURE RED AIRWINGS    |
-- +-----------------------------+ 




BASE:I("----------------------------------------BandarAbbas LOADING-------------------------------------------------")


Red.Wing.BandarAbbas=AIRWING:New("BandarAbbas Airwing","BandarAbbas Airwing")

Red.Squad.BandarAbbas={}
    Red.Squad.BandarAbbas.fsq01=SQUADRON:New("SU-24M", 15, "BandarAbbas SU-24M" )                --Ops.Squadron#SQUADRON
    Red.Squad.BandarAbbas.fsq01:SetSkill(AI.Skill.EXCELLENT)
    Red.Squad.BandarAbbas.fsq01:SetFuelLowThreshold(15)
    Red.Squad.BandarAbbas.fsq01:SetTurnoverTime(5,10)
    Red.Squad.BandarAbbas.fsq01:AddMissionCapability({AUFTRAG.Type.ANTISHIP, AUFTRAG.Type.ALERT5},100)

    Red.Squad.BandarAbbas.fsq02=SQUADRON:New("MiG-29A", 15, "BandarAbbas MiG-29A" )                --Ops.Squadron#SQUADRON
    Red.Squad.BandarAbbas.fsq02:SetSkill(AI.Skill.AVERAGE)
    Red.Squad.BandarAbbas.fsq02:SetFuelLowThreshold(15)
    Red.Squad.BandarAbbas.fsq02:SetTurnoverTime(5,10)
    Red.Squad.BandarAbbas.fsq02:AddMissionCapability({AUFTRAG.Type.ESCORT, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5},100)

    Red.Squad.BandarAbbas.fsq03=SQUADRON:New("F-4E-SEAD", 30, "BandarAbbas F-4E" )                --Ops.Squadron#SQUADRON
    Red.Squad.BandarAbbas.fsq03:SetSkill(AI.Skill.EXCELLENT)
    Red.Squad.BandarAbbas.fsq03:SetFuelLowThreshold(15)
    Red.Squad.BandarAbbas.fsq03:SetTurnoverTime(5,10)
    Red.Squad.BandarAbbas.fsq03:AddMissionCapability({AUFTRAG.Type.SEAD, AUFTRAG.Type.ALERT5},80)

    Red.Squad.BandarAbbas.fsq04=SQUADRON:New("F-14A", 10, "BandarAbbas F-14A" )                --Ops.Squadron#SQUADRON
    Red.Squad.BandarAbbas.fsq04:SetSkill(AI.Skill.AVERAGE)
    Red.Squad.BandarAbbas.fsq04:SetFuelLowThreshold(15)
    Red.Squad.BandarAbbas.fsq04:SetTurnoverTime(5,10)
    Red.Squad.BandarAbbas.fsq04:AddMissionCapability({AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5},100)

    Red.Squad.BandarAbbas.fsq05=SQUADRON:New("F-5E", 22, "BandarAbbas F-5E" )                --Ops.Squadron#SQUADRON
    Red.Squad.BandarAbbas.fsq05:SetSkill(AI.Skill.AVERAGE)
    Red.Squad.BandarAbbas.fsq05:SetFuelLowThreshold(15)
    Red.Squad.BandarAbbas.fsq05:SetTurnoverTime(5,10)
    Red.Squad.BandarAbbas.fsq05:AddMissionCapability({AUFTRAG.Type.ESCORT, AUFTRAG.Type.ALERT5},100)

   -- Add squadrons to airwing.
   for _,squad in pairs(Red.Squad.BandarAbbas) do
     Red.Wing.BandarAbbas:AddSquadron(squad)
   end

   --Add Payloads
   Red.Wing.BandarAbbas:NewPayload("SU-24M", 100, {AUFTRAG.Type.ANTISHIP, AUFTRAG.Type.ALERT5}, 100)
   Red.Wing.BandarAbbas:NewPayload("SU-24M-SEAD", 100, {AUFTRAG.Type.SEAD, AUFTRAG.Type.ALERT5}, 100)
   Red.Wing.BandarAbbas:NewPayload("MiG-29A", 100, {AUFTRAG.Type.ESCORT, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 80)
   Red.Wing.BandarAbbas:NewPayload("F-4E", 100, {AUFTRAG.Type.ESCORT, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.CAP, AUFTRAG.Type.ALERT5}, 100)
   Red.Wing.BandarAbbas:NewPayload("F-4E-SEAD", 100, {AUFTRAG.Type.SEAD, AUFTRAG.Type.ALERT5}, 100)
   Red.Wing.BandarAbbas:NewPayload("F-14A", 100, {AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 90)
   Red.Wing.BandarAbbas:NewPayload("F-5E", 100, {AUFTRAG.Type.ESCORT, AUFTRAG.Type.CAP, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 95)

  function Red.Wing.BandarAbbas:OnAfterFlightOnMission(From, Event, To, Flightgroup, Mission)
    self:E({From, Event, To, Flightgroup, Mission})
    local flightgroup = Flightgroup -- Ops.FlightGroup#FLIGHTGROUP
    local mission = Mission -- Ops.Auftrag#AUFTRAG
    local type = mission:GetType()

      --FLIGHTGROUP SETTINGS
      flightgroup:GetGroup():CommandEPLRS(true,5)
      flightgroup:SetEngageDetectedOn(25,{"Air"},RedBorderZones, BlueBorderZones)
      flightgroup:GetGroup():OptionROTEvadeFire()
      flightgroup:SetDefaultAltitude(25000)

      function flightgroup:OnAfterHolding(From,Event,To)
        self:ClearToLand(5)
      end

      --A2A Escort Criteria      
      if type == AUFTRAG.Type.CASENHANCED or type == AUFTRAG.Type.BAI or type == AUFTRAG.Type.STRIKE or type == AUFTRAG.Type.BOMBING or type == AUFTRAG.Type.BOMBRUNWAY then
          BASE:I("----------------------------------------BandarAbbas: ESCORTED MISSION TYPE-------------------------------------------------")
          local EscortGroup = flightgroup:GetGroup()
          local A2AEscortAuftrag = AUFTRAG:NewESCORT(EscortGroup, {x=-100, y=600, z=200}, 25, nil)
          A2AEscortAuftrag:SetMissionRange(1000)
          A2AEscortAuftrag:SetRequiredAssets(0,1)
          Red.Wing.BandarAbbas:AddMission(A2AEscortAuftrag)
        end
    end

    if RedDebug then
      --- Display mission status on screen.
      local function MissionStatus()
          local text="BandarAbbas Missions:"
          for _,_mission in pairs(Red.Wing.BandarAbbas.missionqueue) do
            local m=_mission --Ops.Auftrag#AUFTRAG
            text=text..string.format("\n- %s %s %s*%d/%d [%d %%]  (%s*%d/%d)",
            m:GetName(), m:GetState():upper(), m:GetTargetName(), m:CountMissionTargets(), m:GetTargetInitialNumber(), m:GetTargetDamage(), m:GetType(), m:CountOpsGroups(), m:GetNumberOfRequiredAssets())
          end

            -- Payloads
            --text=text.."\n\nAvailable Payloads:"  
            for _,aname in pairs(AUFTRAG.Type) do
              local n=Red.Wing.BandarAbbas:CountPayloadsInStock({aname})
              if n>0 then
                --text=text..string.format("\n%s %d", aname, n)
            end
       end

        -- Info message to all.
        MESSAGE:New(text, 25):ToAll()
      end --end of RedDebug

      -- Display primary and secondary mission status every 60 seconds.
      TIMER:New(MissionStatus):Start(5, 30)
  end --end of OnAfterFlightOnMission


BASE:I("----------------------------------------BandarAbbas LOADED-------------------------------------------------")







BASE:I("----------------------------------------AIRWING SPECIFIC MISSIONS-------------------------------------------------")


-- +-----------------------------+
-- |    BandarAbbas ALERT 5s     |
-- +-----------------------------+

local BandarAbbasAlert5=AUFTRAG:NewALERT5(AUFTRAG.Type.INTERCEPT)
      :SetRequiredAssets(2)
      :SetMissionRange(1000)
Red.Wing.BandarAbbas:AddMission(BandarAbbasAlert5)






 
BASE:I("----------------------------------------RED MANTIS-------------------------------------------------------")
-- +-----------------------------+
-- |     CONFIGURE RED MANTIS    |
-- +-----------------------------+
-- MANTIS:New(name, samprefix, ewrprefix, hq, Coalition, dynamic, awacs, EmOnOff, Padding, Zones)
Redmantis = MANTIS:New("Red-MANTIS","Red SAM","Red EWR",nil,"red",true)
Redmantis.automode = true
Redmantis:AddZones({RedBorderZones},{BlueBorderZones}, {ConflictZones})

function Redmantis:OnAfterSeadSuppressionPlanned(From,Event,To,Group,Name,SuppressionStartTime,SuppressionEndTime,Attacker)
  self:E({From,Event,To,Group,Name,SuppressionStartTime,SuppressionEndTime,Attacker})
  BASE:I("----------------------------------------INTERCEPT TRIGGERED VIA SEAD-------------------------------------------------")
  -- get after the SEAD plane
  if Attacker:GetCoalition() == coalition.side.BLUE then
    local redintercept = AUFTRAG:NewINTERCEPT(Attacker)
    redintercept:SetName("Red SEAD Intercept")
    redintercept:SetMissionAltitude(30000)
    redintercept:SetMissionRange(250)
    redintercept:SetRequiredAssets(0,1)
    RedChief:AddMission(redintercept)
  end
end

if RedDebug then

  function Redmantis:OnAfterSeadSuppressionPlanned(From, Event, To, Group, Name, SuppressionStartTime, SuppressionEndTime)
  self:E({From, Event, To, Group, Name, SuppressionStartTime, SuppressionEndTime})
  MESSAGE:New("SAM Suppression planned! "..Name.. " is planning to shut down.",10):ToAll()
  env.info("SAM Suppression planned! "..Name.. " is planning to shut down.")
  end

  function Redmantis:OnAfterSeadSuppressionStart(From, Event, To, Group, Name)
  self:E({From, Event, To, Group, Name})
  MESSAGE:New("SAM Suppressed! "..Name.. " is suppressed.",10):ToAll()
  env.info("SAM Suppressed! "..Name.. "is suppressed!" )
  end

  function Redmantis:OnAfterRedState(From,Event,To,Group)
  self:E({From, Event, To, Group})
    local Name = Group:GetName()
    MESSAGE:New("SAM "..Name.. " switched to RED",10):ToAll()
    env.info("SAM "..Name.. " switched to RED" )
  end

  function Redmantis:OnAfterGreenState(From,Event,To,Group)
  self:E({From, Event, To, Group})
    local Name = Group:GetName()
    MESSAGE:New("SAM "..Name.. " switched to GREEN",10):ToAll()
    env.info("SAM "..Name.. " switched to GREEN" )
  end

  function Redmantis:OnAfterShoradActivated(From,Event,To,Name,Radius,Ontime)
  self:E({From,Event,To,Name,Radius,Ontime})
    MESSAGE:New("SHORAD for "..Name.. " going online!",10):ToAll()
    env.info("SHORAD for "..Name.. " going online!" )
  end

end

Redmantis:__Start(5)



BASE:I("----------------------------------------RED MANTIS SET-------------------------------------------------")



-- +-----------------------------+
-- |   CHIEF STRATEGY MENU       |
-- +-----------------------------+
local ChiefMenu=MENU_MISSION:New("Red Chief Control")

  function ChiefSetPriorityPassive()
    RedChief:SetStrategy(CHIEF.Strategy.PASSIVE)
      if RedDebug then trigger.action.outText("CHIEF: PASSIVE SET", 10) end
    Redmantis:AddZones({},{},{})
    Redmantis.usezones = false
    Redmantis.usezones = true
    Redmantis:AddZones(nil,{BlueBorderZones}) --accept and reject zones
      if RedDebug then trigger.action.outText("MANTIS: NO TARGETS ARE FAIR GAME", 10) end
  end

  function ChiefSetPriorityDefensive()
    RedChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
      if RedDebug then trigger.action.outText("CHIEF: DEFENSIVE SET", 10) end
    Redmantis:AddZones({},{},{})
    Redmantis.usezones = false
    Redmantis.usezones = true
    Redmantis:AddZones({RedBorderZones},{BlueBorderZones}) --accept and reject zones
      if RedDebug then trigger.action.outText("MANTIS: ONLY TARGETS WITHIN RED BORDERS ARE FAIR GAME", 10) end
  end

  function ChiefSetPriorityOffensive()
    RedChief:SetStrategy(CHIEF.Strategy.OFFENSIVE)
      if RedDebug then trigger.action.outText("CHIEF: OFFENSIVE SET", 10) end
    Redmantis:AddZones({},{},{})
    Redmantis.usezones = false
    Redmantis.usezones = true
    Redmantis:AddZones({RedBorderZones, ConflictZones},{BlueBorderZones, RedAttackZones}) --accept and reject zones
      if RedDebug then trigger.action.outText("MANTIS: TARGETS WITHIN RED BORDERS AND CONFLICT ZONES ARE FAIR GAME", 10) end
  end

  function ChiefSetPriorityAggressive()
    RedChief:SetStrategy(CHIEF.Strategy.AGGRESSIVE)
      if RedDebug then trigger.action.outText("CHIEF: AGGRESSIVE SET", 10) end
    Redmantis:AddZones({},{},{})
    Redmantis.usezones = false
    Redmantis.usezones = true
    Redmantis:AddZones({RedBorderZones, ConflictZones, RedAttackZones},{BlueBorderZones}) --accept and reject zones
      if RedDebug then trigger.action.outText("MANTIS: TARGETS WITHIN RED BORDERS, CONFLICT ZONES, AND ATTACK ZONES FAIR GAME", 10) end
  end

  function ChiefSetPriorityTotalWar()
    RedChief:SetStrategy(CHIEF.Strategy.TOTALWAR)
      if RedDebug then trigger.action.outText("CHIEF: TOTAL WAR SET", 10) end
    Redmantis:AddZones({},{},{})
    Redmantis.usezones = false
      if RedDebug then trigger.action.outText("MANTIS: ALL TARGETS FAIR GAME", 10) end
  end


    local chiefMenu1 = MENU_MISSION_COMMAND:New("Set Passive Strategy", ChiefMenu, ChiefSetPriorityPassive)--#MENU
    local chiefMenu2 = MENU_MISSION_COMMAND:New("Set Defensive Strategy", ChiefMenu, ChiefSetPriorityDefensive)--#MENU
    local chiefMenu3 = MENU_MISSION_COMMAND:New("Set Offensive Strategy", ChiefMenu, ChiefSetPriorityOffensive)--#MENU
    local chiefMenu4 = MENU_MISSION_COMMAND:New("Set Aggressive Strategy", ChiefMenu, ChiefSetPriorityAggressive)--#MENU
    local chiefMenu5 = MENU_MISSION_COMMAND:New("Set Total War Strategy", ChiefMenu, ChiefSetPriorityTotalWar)--#MENU
    local chiefAttack1 = MENU_MISSION:New("Attack Specific Targets", ChiefMenu)--#MENU
    local chiefAttack1A = MENU_MISSION_COMMAND:New("Attack Carrier With Subs", chiefAttack1, AttackCSGWithSubs)--#MENU
    local chiefAttack1B = MENU_MISSION_COMMAND:New("Attack Carrier With Iranian Jets", chiefAttack1, AttackCSGWithJets)--#MENU
    local chiefAttack1C = MENU_MISSION_COMMAND:New("Attack Carrier With Gulf Jets", chiefAttack1, GulfStateAntiShip)--#MENU
    local chiefAttack1D = MENU_MISSION_COMMAND:New("Massed SEAD Strike", chiefAttack1, MassSEAD)--#MENU
    local chiefAttack1E = MENU_MISSION_COMMAND:New("Submarine Patrols", chiefAttack1, SubPatrol)--#MENU

BASE:I("----------------------------------------MENU SET-------------------------------------------------")





-- +-----------------------------+
-- |       RED ACTIVATION        |
-- +-----------------------------+
-- Add squadrons to airwing.
   for _,Wing in pairs(Red.Wing) do
      RedChief:AddAirwing(Wing)
      --Wing:SetTakeoffHot()
      --Fleet Add by table, not yet implemented
      if RedDebug then
        Wing:SetVerbosity(RedVerbosity)
        Wing:SetMarker(true)
      end
   end
--[[   
    for _,Fleet in pairs(Red.Fleet) do
      RedChief:AddFleet(Fleet)
      --Fleet Add by table, not yet implemented
      if RedDebug then 
        Fleet:SetVerbosity(RedVerbosity)
        Fleet:SetMarker(true)
        Fleet:SetPathfinding(true)
      end
   end
--]]
--[[   
    for _,Brigade in pairs(Red.Brigade) do
      RedChief:AddBrigade(Brigade)
      --Fleet Add by table, not yet implemented
      if RedDebug then 
        Brigade:SetVerbosity(RedVerbosity)
        Brigade:SetMarker(true)
      end
   end
]]
RedChief:__Start(5)
ChiefSetPriorityDefensive()


































BASE:I("----------------------------------------BLUE CHIEF--------------------------------------------------")
-- +-----------------------------+
-- |    CONFIGURE BLUE CHIEF     |
-- +-----------------------------+ 

local BlueIntelProviders = SET_GROUP:New():FilterCoalitions(coalition.side.BLUE):FilterStart()
local BlueChief = CHIEF:New(coalition.side.BLUE, BlueIntelProviders, "Blue Chief")
BlueChief:SetBorderZones(BlueBorderZones)
BlueChief:SetDefcon(CHIEF.DEFCON.GREEN)
BlueChief:SetStrategy(CHIEF.Strategy.DEFENSIVE)
BlueChief:SetThreatLevelRange(5, 10)
BlueChief:SetConflictZones(ConflictZones)

if BlueDebug then
   BlueChief:SetVerbosity(BlueVerbosity)
   BlueChief:SetClusterAnalysis(true,true)
   BlueChief:SetTacticalOverviewOn()
end

BASE:I("----------------------------------------BLUE CHIEF SET-------------------------------------------------")
trigger.action.outText('BLUE CHIEF LOADED', 10)


BASE:I("----------------------------------------BLUE ELEMENTS--------------------------------------------------")
-- +-----------------------------+
-- |  CONFIGURE BLUE ELEMENTS    |
-- +-----------------------------+ 

local Blue={}
Blue.Wing={}
Blue.Squad={}
Blue.Fleet={}
Blue.Flotilla={}
Blue.Brigade={}
Blue.Platoon={}


BASE:I("---------------------------------------BLUE ELEMENTS SET-------------------------------------------------")







BASE:I("----------------------------------------BLUE MANTIS-------------------------------------------------------")
-- +-----------------------------+
-- |     CONFIGURE BLUE MANTIS    |
-- +-----------------------------+
-- MANTIS:New(name, samprefix, ewrprefix, hq, Coalition, dynamic, awacs, EmOnOff, Padding, Zones)
Bluemantis = MANTIS:New("Blue-MANTIS","Blue SAM","Blue EWR",nil,"blue",true)
Bluemantis.automode = true
Bluemantis:AddZones({BlueBorderZones},{RedBorderZones}, {ConflictZones})

function Bluemantis:OnAfterSeadSuppressionPlanned(From,Event,To,Group,Name,SuppressionStartTime,SuppressionEndTime,Attacker)
  self:E({From,Event,To,Group,Name,SuppressionStartTime,SuppressionEndTime,Attacker})
  BASE:I("----------------------------------------INTERCEPT TRIGGERED VIA SEAD-------------------------------------------------")
  -- get after the SEAD plane
  if Attacker:GetCoalition() == coalition.side.RED then
    local blueintercept = AUFTRAG:NewINTERCEPT(Attacker)
    blueintercept:SetName("Blue SEAD Intercept")
    blueintercept:SetMissionAltitude(30000)
    blueintercept:SetMissionRange(250)
    blueintercept:SetRequiredAssets(0,1)
    BlueChief:AddMission(blueintercept)
  end
end

if BlueDebug then

  function Bluemantis:OnAfterSeadSuppressionPlanned(From, Event, To, Group, Name, SuppressionStartTime, SuppressionEndTime)
  self:E({From, Event, To, Group, Name, SuppressionStartTime, SuppressionEndTime})
  MESSAGE:New("SAM Suppression planned! "..Name.. " is planning to shut down.",10):ToAll()
  env.info("SAM Suppression planned! "..Name.. " is planning to shut down.")
  end

  function Bluemantis:OnAfterSeadSuppressionStart(From, Event, To, Group, Name)
  self:E({From, Event, To, Group, Name})
  MESSAGE:New("SAM Suppressed! "..Name.. " is suppressed.",10):ToAll()
  env.info("SAM Suppressed! "..Name.. "is suppressed!" )
  end

  function Bluemantis:OnAfterRedState(From,Event,To,Group)
  self:E({From, Event, To, Group})
    local Name = Group:GetName()
    MESSAGE:New("SAM "..Name.. " switched to RED",10):ToAll()
    env.info("SAM "..Name.. " switched to RED" )
  end

  function Bluemantis:OnAfterGreenState(From,Event,To,Group)
  self:E({From, Event, To, Group})
    local Name = Group:GetName()
    MESSAGE:New("SAM "..Name.. " switched to GREEN",10):ToAll()
    env.info("SAM "..Name.. " switched to GREEN" )
  end

  function Bluemantis:OnAfterShoradActivated(From,Event,To,Name,Radius,Ontime)
  self:E({From,Event,To,Name,Radius,Ontime})
    MESSAGE:New("SHORAD for "..Name.. " going online!",10):ToAll()
    env.info("SHORAD for "..Name.. " going online!" )
  end

end

Bluemantis:__Start(5)



BASE:I("----------------------------------------RED MANTIS SET-------------------------------------------------")


























BASE:I("----------------------------------------BLUE AIRWING LOADING-------------------------------------------------")
-- +-----------------------------+
-- |  CONFIGURE BLUE AIRWINGS    |
-- +-----------------------------+ 


Blue.Wing.AlDhafra = AIRWING:New("Al Dhafra Airwing", "Al Dhafra Airwing")
   --Add Squadrons 
   Blue.Squad.AlDhafra={}

      Blue.Squad.AlDhafra.fsq01=SQUADRON:New("F15s", 30, "F15s AlDhafra")
         Blue.Squad.AlDhafra.fsq01:AddMissionCapability({AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
         Blue.Squad.AlDhafra.fsq01:SetMissionRange(500)
         Blue.Squad.AlDhafra.fsq01:SetSkill(AI.Skill.EXCELLENT)
         Blue.Squad.AlDhafra.fsq01:SetFuelLowRefuel(true)
         Blue.Squad.AlDhafra.fsq01:SetFuelLowThreshold(35)
         Blue.Squad.AlDhafra.fsq01:SetTurnoverTime(10,15)

      Blue.Squad.AlDhafra.tsqTEX=SQUADRON:New("Texaco", 6, "Texaco AlDhafra")
        Blue.Squad.AlDhafra.tsqTEX:AddMissionCapability({AUFTRAG.Type.TANKER}, 100)
        Blue.Squad.AlDhafra.tsqTEX:SetFuelLowRefuel(true)
        Blue.Squad.AlDhafra.tsqTEX:SetFuelLowThreshold(0.1)
        Blue.Squad.AlDhafra.tsqTEX:SetTurnoverTime(10,20)
        Blue.Squad.AlDhafra.tsqTEX:SetMissionRange(500)
        Blue.Squad.AlDhafra.tsqTEX:SetSkill(AI.Skill.AVERAGE)
        Blue.Squad.AlDhafra.tsqTEX:SetRadio(255)
        Blue.Squad.AlDhafra.tsqTEX:SetCallsign(CALLSIGN.Tanker.Texaco,1)
        Blue.Squad.AlDhafra.tsqTEX:AddTacanChannel(51,51)
        Blue.Squad.AlDhafra.tsqTEX:SetTakeoffHot()

      Blue.Squad.AlDhafra.tsqSHL=SQUADRON:New("Shell", 6, "Shell AlDhafra")
        Blue.Squad.AlDhafra.tsqSHL:AddMissionCapability({AUFTRAG.Type.TANKER}, 100)
        Blue.Squad.AlDhafra.tsqSHL:SetFuelLowRefuel(true)
        Blue.Squad.AlDhafra.tsqSHL:SetFuelLowThreshold(0.1)
        Blue.Squad.AlDhafra.tsqSHL:SetTurnoverTime(10,20)
        Blue.Squad.AlDhafra.tsqSHL:SetMissionRange(500)
        Blue.Squad.AlDhafra.tsqSHL:SetSkill(AI.Skill.AVERAGE)
        Blue.Squad.AlDhafra.tsqSHL:SetRadio(256)
        Blue.Squad.AlDhafra.tsqSHL:SetCallsign(CALLSIGN.Tanker.Shell,1)
        Blue.Squad.AlDhafra.tsqSHL:AddTacanChannel(56,56)
        Blue.Squad.AlDhafra.tsqSHL:SetTakeoffHot()

      Blue.Squad.AlDhafra.esqE3=SQUADRON:New("Blue EWR E3", 6, "E3 AlDhafra")
        Blue.Squad.AlDhafra.esqE3:AddMissionCapability({AUFTRAG.Type.AWACS}, 100)
        Blue.Squad.AlDhafra.esqE3:SetFuelLowThreshold(0.1)
        Blue.Squad.AlDhafra.esqE3:SetTurnoverTime(10,20)
        Blue.Squad.AlDhafra.esqE3:SetMissionRange(500)
        Blue.Squad.AlDhafra.esqE3:SetSkill(AI.Skill.AVERAGE)
        Blue.Squad.AlDhafra.esqE3:SetRadio(251)
        Blue.Squad.AlDhafra.esqE3:SetCallsign(CALLSIGN.AWACS.Darkstar,1)
        Blue.Squad.AlDhafra.esqE3:SetTakeoffHot()

   -- Add Squads to Al Dhafra Airwing
      for _,squad in pairs(Blue.Squad.AlDhafra) do
         Blue.Wing.AlDhafra:AddSquadron(squad)
      end

   --Add Payloads
   Blue.Wing.AlDhafra:NewPayload("F15s",100, {AUFTRAG.Type.CAP, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.ESCORT, AUFTRAG.Type.GCICAP, AUFTRAG.Type.ALERT5}, 100)
   Blue.Wing.AlDhafra:NewPayload("Blue EWR E3",100,{AUFTRAG.Type.AWACS},100)
   Blue.Wing.AlDhafra:NewPayload("Texaco",100,{AUFTRAG.Type.TANKER}, 100)
   Blue.Wing.AlDhafra:NewPayload("Shell",100,{AUFTRAG.Type.TANKER}, 100)


   function Blue.Wing.AlDhafra:OnAfterFlightOnMission(From, Event, To, Flightgroup, Mission)
      self:E({From, Event, To, Flightgroup, Mission})
        local flightgroup = Flightgroup -- Ops.FlightGroup#FLIGHTGROUP
        local mission = Mission -- Ops.Auftrag#AUFTRAG
        local flightgroupname = flightgroup:GetName()

      if mission:GetType() == AUFTRAG.Type.TANKER or mission:GetType() == AUFTRAG.Type.AWACS then
         local EscortGroup = flightgroup:GetGroup()
         local auftrag = AUFTRAG:NewESCORT(EscortGroup,{x=-300, y=200, z=300},25,nil)
         auftrag:SetMissionRange(500)
         auftrag:SetRequiredAssets(0,2)
         BlueChief:AddMission(auftrag)
      end

      if type == AUFTRAG.Type.AWACS then
         Bluemantis:SetAwacs(flightgroup.groupname)
         BASE:I("---------Blue AWACS Prefix Set as "..flightgroup.groupname)
      end

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

      local text="Al Dhafra Missions:"
      for _,_mission in pairs(Blue.Wing.AlDhafra.missionqueue) do
         local m=_mission --Ops.Auftrag#AUFTRAG
         text=text..string.format("\n- %s %s %s*%d/%d [%d %%]  (%s*%d/%d)",
         m:GetName(), m:GetState():upper(), m:GetTargetName(), m:CountMissionTargets(), m:GetTargetInitialNumber(), m:GetTargetDamage(), m:GetType(), m:CountOpsGroups(), m:GetNumberOfRequiredAssets())
      end

      -- Payloads
         text=text.."\n\nAvailable Payloads:"
         for _,aname in pairs(AUFTRAG.Type) do
            local n=Blue.Wing.AlDhafra:CountPayloadsInStock({aname})
            if n>0 then
               text=text..string.format("\n%s %d", aname, n)
            end
         end

      -- Info message to all.
         MESSAGE:New(text, 25):ToAll()
   end

   -- Display primary and secondary mission status every 60 seconds.
   TIMER:New(MissionStatus):Start(5, 30)
end








Blue.Wing.CSG10 = AIRWING:New("USS George H. W. Bush", "CSG-10")

if BlueDebug then
   Blue.Wing.CSG10:SetVerbosity(BlueVerbosity)
   Blue.Wing.CSG10:SetMarker(true)
end

 
BASE:I("----------------------------------------BLUE AIRWING SET-------------------------------------------------")





BASE:I("----------------------------------------BLUE CHIEF MISSIONS-------------------------------------------------")
-- +-----------------------------+
-- |  BlueChief Managed Missions  |
-- +-----------------------------+
--AWACS
local BlueAWACS = AUFTRAG:NewAWACS(BlueLogisticsZones.AwacsZone:GetCoordinate(), 30000, 300, 180, 20)
      BlueAWACS:SetRepeat(99)
      BlueAWACS:SetName("Blue AWACS")
      BlueChief:AddMission(BlueAWACS)

BASE:I("----------------------------------------AIRWING SPECIFIC MISSIONS-------------------------------------------------")


-- +-----------------------------+
-- |      AlDhafra ALERT 5s      |
-- +-----------------------------+

local AlDhafraAlert5=AUFTRAG:NewALERT5(AUFTRAG.Type.INTERCEPT)
      :SetRequiredAssets(2)
      :SetMissionRange(1000)
Blue.Wing.AlDhafra:AddMission(AlDhafraAlert5)

 



-- +-----------------------------+
-- |       CHIEF LOGISTICS       |
-- +-----------------------------+

local function LaunchTexaco()
      local TexacoAuftrag = AUFTRAG:NewTANKER(BlueLogisticsZones.TexacoZone:GetCoordinate(),20000,UTILS.KnotsToAltKIAS(250,20000),360,40,0)
            TexacoAuftrag:AssignCohort(Blue.Squad.AlDhafra.tsqTEX)
            TexacoAuftrag:SetRadio(255)
            TexacoAuftrag:SetTACAN(55, "TEX")
            TexacoAuftrag:SetName("Texaco Auftrag")
            TexacoAuftrag:SetRepeat(99)
      BlueChief:AddMission(TexacoAuftrag)
end

local function LaunchShell()
      local ShellAuftrag = AUFTRAG:NewTANKER(BlueLogisticsZones.ShellZone:GetCoordinate(),22000,UTILS.KnotsToAltKIAS(250,22000),180,40,1)
            ShellAuftrag:AssignCohort(Blue.Squad.AlDhafra.tsqSHL)
            ShellAuftrag:SetRadio(256)
            ShellAuftrag:SetTACAN(56, "SHL")
            ShellAuftrag:SetName("Shell Auftrag")
            ShellAuftrag:SetRepeat(99)
      BlueChief:AddMission(ShellAuftrag)
end













-- +-----------------------------+
-- |       BLUE ACTIVATION       |
-- +-----------------------------+
-- Add squadrons to airwing.
for _,Wing in pairs(Blue.Wing) do
   BlueChief:AddAirwing(Wing)

   if BlueDebug then
      Wing:SetVerbosity(RedVerbosity)
      Wing:SetMarker(true)
   end
end






BlueChief:__Start(10)
LaunchShell()
LaunchTexaco()







--- Function called when the DEFCON changes.
-- function BlueChief:OnAfterDefconChange(From, Event, To, Defcon)
--   local text=string.format("Blue changed DEFCON to %s", Defcon)
--   MESSAGE:New(text, 120):ToAll()    
-- end

function RedChief:OnAfterDefconChange(From, Event, To, Defcon)
  local text=string.format("Red changed DEFCON to %s", Defcon)
  MESSAGE:New(text, 120):ToAll()    
end

--- Function called when the STRATEGY changes.
-- function BlueChief:OnAfterStrategyChange(From, Event, To, Strategy)
--   local text=string.format("Blue strategy changd to %s", Strategy)
--   MESSAGE:New(text, 120):ToAll()
-- end

--- Function called when the STRATEGY changes.
function RedChief:OnAfterStrategyChange(From, Event, To, Strategy)
  local text=string.format("Red strategy changd to %s", Strategy)
  MESSAGE:New(text, 120):ToAll()
end




BASE:I("----------------------------------------EVERYTHING LOADED (IT'S A MIRACLE!) -------------------------------------------------")
trigger.action.outText('-----------------EVERYTHING LOADED (ITS A MIRACLE!)------------------', 15)