redIADS = SkynetIADS:create('RED IADS')


---debug settings remove from here on if you do not wan't any output on what the IADS is doing by default
local iadsDebug = redIADS:getDebugSettings()
iadsDebug.IADSStatus = true
iadsDebug.radarWentDark = true
iadsDebug.contacts = true
iadsDebug.radarWentLive = true
iadsDebug.noWorkingCommmandCenter = true
iadsDebug.samNoConnection = true
iadsDebug.jammerProbability = true
iadsDebug.addedEWRadar = true
iadsDebug.harmDefence = true
---end remove debug ---



redIADS:addSAMSitesByPrefix('Red SAM')
redIADS:addEarlyWarningRadarsByPrefix('Red EWR')
--redIADS:getSAMSiteByGroupName('Red SAM-1'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(40)

-- Draw "Engagement_Zone" in the ME as a Quad Point zone (not circular)
-- redIADS is your SkynetIADS network, already populated with SAM sites
-- (e.g. via redIADS:addSAMSitesByPrefix('SAM'))

local function getZoneVertices(zoneName)
    for _, zoneData in ipairs(env.mission.triggers.zones) do
        if zoneData.name == zoneName and zoneData.verticies then
            local vertices = {}
            for _, v in ipairs(zoneData.verticies) do
                -- mission editor stores 2D points as x/y; DCS 3D points use x/y/z,
                -- so map the zone's y onto the DCS z axis and leave altitude open
                table.insert(vertices, { x = v.x, y = 0, z = v.y })
            end
            return vertices
        end
    end
    return nil
end

-- cache once, so we're not re-parsing the mission table on every evaluation
local zoneVertices = getZoneVertices("Engagement_Zone")

local function onlyFireInZone(contact)
    if not zoneVertices then return false end -- fail-safe: don't fire if the zone is missing

    local contactPoint = contact:getPosition().p
    return mist.pointInPolygon(contactPoint, zoneVertices)
end

-- apply the constraint to every SAM site currently in the network
for _, samSite in ipairs(redIADS:getSAMSites()) do
    samSite:addGoLiveConstraint('only-fire-in-zone', onlyFireInZone)
end

redIADS:addRadioMenu()

redIADS:activate()