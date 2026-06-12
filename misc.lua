assert(loadfile("C:\\Users\\chad\\Saved Games\\DCS\\Scripts\\Moose_.lua"))()


assert(loadfile("C:\\Users\\chad\\OneDrive\\Documents\\Github\\DCS\\ground_training.lua"))()

parashoo = {}
-- remove parachuted pilots after landing
function parashoo:onEvent(event)
    if event.id == 31 then -- landing_after_eject
        if event.initiator then 
            Unit.destroy(event.initiator)
        end
    end
end
-- add event handler
world.addEventHandler(parashoo)

local truman = AIRBOSS:New("CVN_75","Grumpy")
truman:SetICLS(2,"TRM")
truman:SetTACAN(75,"X","TRM")
truman:SetAirbossRadio(127.5)
truman:SetSoundfilesFolder("Airboss Soundfiles/")
truman:SetLSORadio(230)
truman:SetMarshalRadio(231)
truman:SetRadioRelayMarshal("DDG 02")
truman:SetRadioRelayLSO("DDG 01")
truman:__Start(1)