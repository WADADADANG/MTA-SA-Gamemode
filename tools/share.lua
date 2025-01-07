function getTimestampCurrent ( )
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second

    local monthday = time.monthday
	local month = time.month
	local year = time.year

    return string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday, hours, minutes, seconds)
end

function getPlayerPID ( player )
    return getElementData( player, "PlayerID" )
end

function countTable ( t )
    local n = 0
    for k, v in pairs( t ) do
        n = n + 1
    end
    return n
end