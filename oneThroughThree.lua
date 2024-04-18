//Q1 - Fix or improve the implementation of the below methods
local STORAGE_SLOT = 1000 -- not sure why this is the storage to be released but macro for it
local EMPTY_SLOT_TRIGGER = -1 --ideally this would probably be a global macro
local FULL_SLOT_TRIGGER = 1 -- could this be a bool? 
local DELAY_TIME = 1000 -- 1 second in ms


local function releaseStorage(player)
    if player then -- validate player object
    player:setStorageValue(STORAGE_SLOT, -1) -- I'm assuming this is setting the storage at int(slot) to -1
end

function onLogout(player)
    if player and player:getStorageValue(STORAGE_SLOT) == FULL_SLOT_TRIGGER then
        addEvent(releaseStorage,DELAY_TIME,player) -- this should be the proper fn call for release storage now
    end
    return true
end


//Q2 - Fix or improve the implementation of the below method

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    if not resultId then --check for find guilds to print
        print("No guild matches your criteria.")
        return 
    end

    local guildName = result.getString("name")

    while guildName do -- loop through the results to print ALL guild names
        print(guildName)
        guildName = result.getNext(resultId,"name")
    end

    result.free(resultId) -- free resultId mem
end


//Q3 - Fix or improve the name and the implementation of the below method

function removeFromPlayerParty(playerId, memberName) -- other name was kickPlayerFromParty
    player = Player(playerId) -- get player from playerId
    if not player then --check for valid player
        print("Player could not be found")
        return
    end

    local party = player:getParty() -- get party from player
    if not party then --check for party
        print("Player is not in a party")
        return
    end

    local member = Player(memberName) -- get member player from name
    if not member then
        print("Could not find member")
        return
    end

    if not member:getParty() == party then --I'm assuming this comparison works, alternatively party:isPlayerInParty(member) could be implemented
        print("Cannot kick player not in your party")
        return
    end

    party:removeMember(Player(memberName))
    print('Player was successfully removed from the party')
end