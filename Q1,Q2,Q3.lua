--Q1
-- Assuming that this is a networking script and contains events pertaining to network operations, there would ideally be a section 
-- in the script where all the time-related variables are defined. Changes to any of these variables can be made in this block

------------------ TIME VARIABLES --------------------
local releaseDelay = 1000 -- delay time(in miliseconds) before releasing player storage

---------------

-- passing the storage key in addition to player object would make the function more modular and can be used by other functions as well, therefore justifying it's name
-- the different keys can be handled with a bunch of conditional statements
local function releaseStorage(player, storageKey)

	player:setStorageValue(storageKey, -1)
end

--------------

function onLogout(player)

	-- create a local reference of the storage key so that it is easier to change it later if needed
	local storageKey = 1000 

	if player:getStorageValue(storageKey) == 1 then
		addEvent(releaseStorage, releaseDelay, player, storageKey) -- pass storage key as an additional argument
	end

	return true
end

-- --------------------------------------------------------------
--Q2
-- this method is supposed to print names of all guilds that have less than memberCount max members
function printSmallGuildNames(memberCount)

	local guildName -- string that stores names of all variables

	-- Shrinked three lines of code into one removing 2 excess variables in the process  
	local resultId = db.storeQuery(string.format("SELECT name FROM guilds WHERE max_members < %d;", memberCount))

	-- error handling to account for failed executions
	if resultId then
		-- iterate through every entry retrieved until there is none left, and display the names one by one
		repeat
            local guildName = result.getString(resultId, "name")
            print(guildName)
		until not result.next(resultId)

		-- free the result set
		result.free(resultId)
	end
end

-- --------------------------------------------------------------
-- Q3
--the method removes a member player from the player's party based on the member name passed
function removeMemberFromPlayerParty(playerId, memberName)

	local player = Player(playerId) -- local keyword added to player variable to limit its scope within the function
	local memberToBeRemoved = Player(memberName) -- A local reference of member player is created to avoid multiple function calls
	local party = player:getParty()

	for k,v in pairs(party:getMembers()) do
		if v == memberToBeRemoved then
			party:removeMember(memberToBeRemoved)
		end
	end
end

-- --------------------------------------------------------------
