function logs ( meg, event )
    local sanitizedEvent = string.gsub(event, "[^%w_%-]", "_")
    local fileName = "logs/" .. sanitizedEvent .. ".log"

    local hFile = false
    if not fileExists ( fileName ) then
        hFile = fileCreate(fileName)
        assert(hFile, "Failed to open file: " .. fileName)
    else
        hFile = fileOpen( fileName )
    end

    local timestamp = getTimestampCurrent() or os.date("%Y-%m-%d %H:%M:%S")
    local text = "[" .. timestamp .. "]: " .. meg .. "\n"

    local size = fileGetSize(hFile)
    fileSetPos(hFile, size)
    fileWrite(hFile, text)
    fileFlush(hFile)
    fileClose(hFile)
    return true
end

function getInfoPlayer ( player )
    return {
        ip = getPlayerIP( player ),
        serial = getPlayerSerial( player ),
        name = getPlayerName( player ),
        ping = getPlayerPing( player ),
        version = getPlayerVersion( player ),
        position = { getElementPosition( player ) },
        rotation = { getElementRotation( player ) },
        IsOnGround = isPedOnGround( player ),
        IsInVehicle = isPedInVehicle( player ),
    }
end