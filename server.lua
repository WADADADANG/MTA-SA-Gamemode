KeyPIDAccounts = {}

function refreshAllAccountPIDs ( )
    local accounts = getAccounts()
    for _, theAccount in ipairs(accounts) do
        local PID = getAccountData( theAccount, "PID" )
        if PID then
            KeyPIDAccounts[ PID ] = theAccount
        end
    end
end

addEventHandler( "onResourceStart", resourceRoot, 
function ( res )
    refreshAllAccountPIDs ( )
end
)

function generateRandomID ( length )
    if not length or length <= 0 then
        return nil
    end

    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local id = ""
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        id = id .. chars:sub(randIndex, randIndex)
    end

    if isAccountPID ( id ) then
        return generateRandomID( length )
    end
    return id
end

function isAccountPID ( pid )
    if KeyPIDAccounts[ pid ] then
        return true
    end
    return false
end

function loadStatusPlayer( player )
    local account = getPlayerAccount( player )
    if account then
        for ElementName, Value in pairs( StatusElements ) do
            local AmountElement = getAccountData( account, ElementName )
            if AmountElement then
                setElementData( player, ElementName, AmountElement )
            end
        end
        return true
    end
    return false
end

function getDefultSpawnDataAccount ( account )
    local px = getAccountData( account, "Last_X" ) or configServer[ "Default_PositionSpawn" ][ 1 ]
    local py = getAccountData( account, "Last_Y" ) or configServer[ "Default_PositionSpawn" ][ 2 ]
    local pz = getAccountData( account, "Last_Z" ) or configServer[ "Default_PositionSpawn" ][ 3 ]
    local rotation = getAccountData( account, "Last_RZ" ) or math.random( configServer[ "Default_RotationSpawn" ][ 1 ], configServer[ "Default_RotationSpawn" ][ 2 ] )
    local ModelID = getAccountData( account, "ModelID" ) or configServer[ "DefaultModelID" ]
    local Dimension = getAccountData( account, "Dimension" ) or 0
    local Interior = getAccountData( account, "Interior" ) or 0
    return { x = px, y = py, z = pz, rz = rotation, model = ModelID, dimension = Dimension, interior = Interior } 
end

addEventHandler( "onPlayerLogin", root, 
function ( thePreviousAccount, theCurrentAccount )
    -- body

    local PID = getAllAccountData( theCurrentAccount, "PID" )
    if PID then
        -- old player login

        -- load status
        loadStatusPlayer( source )

        local defaultSpawn = getDefultSpawnDataAccount ( theCurrentAccount )
        spawnPlayer( source, defaultSpawn.x, defaultSpawn.y, defaultSpawn.z + configServer[ "HeightSpawnLogin" ], defaultSpawn.rz, defaultSpawn.model )
        fadeCamera( source, true, 1 )
        setCameraTarget ( source, source )

        setElementDimension( source, defaultSpawn.dimension )
        setElementInterior( source, defaultSpawn.interior )

        if configServer[ "SuperArmorLoginTimer" ] and configServer[ "SuperArmorLoginTimer" ] > 0 then
            setElementData( source, "SuperArmor", true )
            setTimer( setElementData, configServer[ "SuperArmorLoginTimer" ], 1, source, "SuperArmor", false )
        end

        triggerEvent( "onPlayerLoginGamemode", source )
        triggerClientEvent( source, "onClientPlayerLoginGamemode", source )
    else
        -- new player register
        setAccountData( theCurrentAccount, "PID", generateRandomID ( 12 ) )

        spawnPlayer( source, configServer[ "Default_PositionSpawn" ][ 1 ], configServer[ "Default_PositionSpawn" ][ 2 ], configServer[ "Default_PositionSpawn" ][ 3 ], 0, configServer[ "Default_ModelID" ] )
        fadeCamera( source, true, 1 )
        setCameraTarget ( source, source )

        if configServer[ "SuperArmorLoginTimer" ] and configServer[ "SuperArmorLoginTimer" ] > 0 then
            setElementData( source, "SuperArmor", true )
            setTimer( setElementData, configServer[ "SuperArmorLoginTimer" ], 1, source, "SuperArmor", false )
        end

        -- set default status
        for ElementName, newAmount in pairs( givePlayerRegisterElements ) do
            local AmountElement = getElementData( source, ElementName ) or 0
            setElementData( source, ElementName, AmountElement + newAmount )
        end

        triggerEvent( "onPlayerRegisterGamemode", source )
        triggerClientEvent( source, "onClientPlayerRegisterGamemode", source )
    end

end
)