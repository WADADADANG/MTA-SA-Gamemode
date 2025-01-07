KeyPIDAccounts = {} -- ตัวแปรเก็บข้อมูล PID ของผู้เล่นทั้งหมด
RespawnPlayerTimers = {} -- คัวแปรเก็บข้อมูล เมื่อผู้เล่นกำลังตาย และ รอสปอว์นใหม่
DownedPlayers = {} -- ตัวแปรเก็บข้อมูล ผู้เล่นล้มอยู่

-- ฟังก์ชันโหลดข้อมูล PID ของผู้เล่นทั้งหมด ลงในตัวแปร KeyPIDAccounts
function refreshAllAccountPIDs ( )
    KeyPIDAccounts = {}
    local accounts = getAccounts()
    for _, theAccount in ipairs(accounts) do
        local PID = getAccountData( theAccount, "PID" )
        if PID then
            KeyPIDAccounts[ PID ] = theAccount
        end
    end
end

-- เหตุการเมื่อระบบเริ่มทำงาน
addEventHandler( "onResourceStart", resourceRoot, 
function ( res )
    refreshAllAccountPIDs ( )
end
)

-- ฟังก์ชันสร้าง PID สุ่ม
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

-- ฟังก์ชันตรวจสอบว่าเป็น PID ของผู้เล่นหรือไม่
function isAccountPID ( pid )
    if KeyPIDAccounts[ pid ] then
        return true
    end
    return false
end

-- ฟังก์ชันโหลดข้อมูลสถานะให้กับผู้เล่น
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

-- ฟังก์ชันเรียกข้อมูลสถานะสำหรับสปอว์นผู้เล่น
function getDefaultSpawnDataAccount ( account )
    local px = getAccountData( account, "Last_X" ) or configServer[ "Default_PositionSpawn" ][ 1 ]
    local py = getAccountData( account, "Last_Y" ) or configServer[ "Default_PositionSpawn" ][ 2 ]
    local pz = getAccountData( account, "Last_Z" ) or configServer[ "Default_PositionSpawn" ][ 3 ]
    local rotation = getAccountData( account, "Last_RZ" ) or math.random( configServer[ "Default_RotationSpawn" ][ 1 ], configServer[ "Default_RotationSpawn" ][ 2 ] )
    local ModelID = getAccountData( account, "ModelID" ) or configServer[ "DefaultModelID" ]
    local Dimension = getAccountData( account, "Dimension" ) or 0
    local Interior = getAccountData( account, "Interior" ) or 0
    return { x = px, y = py, z = pz, rz = rotation, model = ModelID, dimension = Dimension, interior = Interior } 
end

-- ฟังก์ชันบันทึกสถานะผู้เล่น
function saveStatusSpawnPlayer ( player )
    local account = getPlayerAccount( player )
    if account then
        for ElementName, Value in pairs( StatusElements ) do
            local AmountElement = getElementData( player, ElementName )
            if AmountElement then
                setAccountData( account, ElementName, AmountElement )
            end
        end

        setAccountData( account, "Last_X", getElementPosition( player ) )
        setAccountData( account, "Last_Y", getElementPosition( player ) )
        setAccountData( account, "Last_Z", getElementPosition( player ) )
        setAccountData( account, "Last_RZ", getElementRotation( player ) )
        setAccountData( account, "ModelID", getElementModel( player ) )
        setAccountData( account, "Dimension", getElementDimension( player ) )
        setAccountData( account, "Interior", getElementInterior( player ) )
        local isDead = getElementData( player, "isDead" )
        if isDead then
            setAccountData( account, "isDead", isDead )
        end
    end
end

-- ฟังก์ชันตรวจสอบว่าผู้เล่นกำลังรอสปอว์นหรือไม่
function isPlayerWaitingRespawn ( player )
    if RespawnPlayerTimers[ player ] then
        return true
    end
    return false
end

-- ฟังก์ชันตรวจสอบว่าผู้เล่นล้มอยู่หรือไม่
function isPlayerDowning ( player )
    if DownedPlayers[ player ] then
        return true
    end
    return false
end

-- ฟังก์ชันเซ็ตสถานะผู้เล่นล้ม
function setPlayerDown ( player, timer, attacker, weapon, bodypart )
    if timer and type( timer ) == "number" then
        toggleControl( player, "fire", false)
        toggleControl( player, "jump", false)
        toggleControl( player, "sprint", false)
        toggleControl( player, "enter_exit", false)
        setElementFrozen( player, true)
        setPedAnimation( player, "crack", "crckidle4", -1, true, false, false, false)

        local PlayerDown = getElementData( player, "PlayerDown" )
        setElementData( player, "PlayerDown", timer )
        setElementData( player, "PlayerDown:Attacker", attacker )
        setElementData( player, "PlayerDown:Weapon", weapon )
        setElementData( player, "PlayerDown:Bodypart", bodypart )

        DownedPlayers[ player ] = true
        if not PlayerDown then
            triggerEvent( "onPlayerPlayerDowned", player, timer, attacker, weapon, bodypart )
            triggerClientEvent( player, "onClientPlayerPlayerDowned", player, timer, attacker, weapon, bodypart )
        end
    else
        toggleControl( player, "fire", true)
        toggleControl( player, "jump", true)
        toggleControl( player, "sprint", true)
        toggleControl( player, "enter_exit", true)
        setElementFrozen( player, false)
        setPedAnimation( player )

        setElementData( player, "PlayerDown", false )
        setElementData( player, "PlayerDown:Attacker", false )
        setElementData( player, "PlayerDown:Weapon", false )
        setElementData( player, "PlayerDown:Bodypart", false )
        DownedPlayers[ player ] = false
    end
end

-- ฟังก์ชันเซ็ตสถานะผู้เล่นตาย
function setPlayerDead ( player, attacker, weapon, bodypart )
    if player and DownedPlayers[ player ] then
        DownedPlayers[ player ] = nil

        setElementData( player, "isDead", true )
        setPlayerDown( player, false )
        killPed( player, attacker, weapon, bodypart )

        fadeCamera ( player, false, 5, 26, 26, 26 )
	    setCameraTarget ( player, player )

        setElementData( player, "WaitingRespawn", configServer[ "RespawnTimer" ] )
        RespawnPlayerTimers[ player ] = setTimer( respawnPlayer, configServer[ "RespawnTimer" ], 1, player )

        triggerEvent( "onPlayerDead", player, attacker, weapon, bodypart )
        triggerClientEvent( player, "onClientPlayerDead", player, attacker, weapon, bodypart )
    end
    return false
end

-- เหตุการณ์เมื่อผู้เล่นแก้ไขข้อมูล Element Data จาก Client โดยไม่ได้รับอนุญาต
addEventHandler( "onElementDataChange", root, 
function ( theKey, oldValue, newValue )
    if client then
        if source and isElement( source ) then
            local theType = getElementType( source )
            if theType == "player" then
                if StatusElements[ theKey ] then
                    setElementData( source, theKey, oldValue )

                    if isElement( client ) and getElementType( client ) == "player" then
                        if client == source then
                            logs ( "Hack Element Data Change Himself> Key: " .. theKey .. " oldValue: " .. oldValue .. " newValue: " .. newValue .. " InfoHacker: " .. toJSON( getInfoPlayer ( client ) ), "HackElementDataChangeHimself" )
                        else
                            logs ( "Hack Element Data Change Give To Other> Key: " .. theKey .. " oldValue: " .. oldValue .. " newValue: " .. newValue .. " InfoHacker: " .. toJSON( getInfoPlayer ( client ) ) .. " InfoSource: " .. toJSON( getInfoPlayer ( source ) ), "HackElementDataChangeGiveToOther" )
                        end
                    else
                        logs ( "Hack Element Data Change Client Not Element> Key: " .. theKey .. " oldValue: " .. oldValue .. " newValue: " .. newValue .. " InfoClient:" .. toJSON( client ) , "HackElementDataChangeClientNotElement" )
                    end

                end
            elseif theType == "colshape" then
                if StatusElements[ theKey ] then
                    setElementData( source, theKey, oldValue )

                    if isElement( client ) and getElementType( client ) == "player" then
                        logs ( "Hack Element Data Change(Colshape)> Key: " .. theKey .. " oldValue: " .. oldValue .. " newValue: " .. newValue .. " InfoHacker: " .. toJSON( getInfoPlayer ( client ) ) .. " InfoSource: " .. toJSON( getAllAccountData( source ) ), "ColshapeHackElementDataChange" )
                    else
                        logs ( "Hack Element Data Change Client Not Player(Colshape)> Key: " .. theKey .. " oldValue: " .. oldValue .. " newValue: " .. newValue .. " InfoClient:" .. toJSON( client ) , "ColshapeHackElementDataChangeClientNotPlayer" )
                    end

                end
            end
        end
    end
end
)

-- เหตุการ เมื่อผู้เล้นล็อกอินเข้าเกม หรือ สมัครสมาชิก
addEventHandler( "onPlayerLogin", root, 
function ( thePreviousAccount, theCurrentAccount )

    local PID = getAccountData( theCurrentAccount, "PID" )
    if PID then
        -- ผู้เล่นเก่าล็อกอินเข้าเกม

        -- โหลดข้อมูลสถานะผู้เล่น
        loadStatusPlayer( source )

        -- สปอว์นผู้เล่น สำหรับล็อกอิน โดยใช้ ข้อมูลจากฐานข้อมูล
        local defaultSpawn = getDefaultSpawnDataAccount ( theCurrentAccount )
        spawnPlayer( source, defaultSpawn.x, defaultSpawn.y, defaultSpawn.z + configServer[ "HeightSpawnLogin" ], defaultSpawn.rz, defaultSpawn.model )
        fadeCamera( source, true, 1 )
        setCameraTarget ( source, source )

        setElementDimension( source, defaultSpawn.dimension )
        setElementInterior( source, defaultSpawn.interior )

        local isDead = getAccountData( theCurrentAccount, "isDead" )
        if isDead then
            killPed( source )
        end

        -- เซ็ตค่าสถานะต้านทานความเสียหายทั้งหมด สำหรับล็อกอิน (ชั่วคราว)
        if configServer[ "SuperArmorLoginTimer" ] and configServer[ "SuperArmorLoginTimer" ] > 0 then
            setElementData( source, "SuperArmor", true )
            setTimer( setElementData, configServer[ "SuperArmorLoginTimer" ], 1, source, "SuperArmor", false )
        end

        setElementData( source, "PID", PID )

        -- ส่งทิกเกอร์เมื่อผู้เล่นล็อกอินเข้าเกมแล้ว
        triggerEvent( "onPlayerLoginGamemode", source )
        triggerClientEvent( source, "onClientPlayerLoginGamemode", source )
    else
        -- ผู้เล่นใหม่สมัครสมาชิก
        local newPID = generateRandomID ( 12 )
        setAccountData( theCurrentAccount, "PID", newPID )
        KeyPIDAccounts[ newPID ] = theCurrentAccount

        setElementData( source, "PID", newPID )

        -- สปอว์นผู้เล่น สำหรับสมัครสมาชิก โดยใช้ ข้อมูลฐานข้อมูลเริ่มต้น
        spawnPlayer( source, configServer[ "Default_PositionSpawn" ][ 1 ], configServer[ "Default_PositionSpawn" ][ 2 ], configServer[ "Default_PositionSpawn" ][ 3 ], 0, configServer[ "Default_ModelID" ] )
        fadeCamera( source, true, 1 )
        setCameraTarget ( source, source )
        
        -- เซ็ตค่าสถานะต้านทานความเสียหายทั้งหมด สำหรับสมัครสมาชิก (ชั่วคราว)
        if configServer[ "SuperArmorLoginTimer" ] and configServer[ "SuperArmorLoginTimer" ] > 0 then
            setElementData( source, "SuperArmor", true )
            setTimer( setElementData, configServer[ "SuperArmorLoginTimer" ], 1, source, "SuperArmor", false )
        end

        -- เซ็ตค่าสถานะเริ่มต้น
        for ElementName, newAmount in pairs( givePlayerRegisterElements ) do
            local AmountElement = getElementData( source, ElementName ) or 0
            setElementData( source, ElementName, AmountElement + newAmount )
        end

        -- ส่งทิกเกอร์เมื่อผู้เล่นสมัครสมาชิกแล้ว
        triggerEvent( "onPlayerRegisterGamemode", source )
        triggerClientEvent( source, "onClientPlayerRegisterGamemode", source )
    end

end
)

-- ฟังก์ชันสปอว์นผู้เล่นจากการตาย
function respawnPlayer ( player )
    if not player then return false end
    if not isElement( player ) then return false end

    local index = math.random( 1, #respawnPlayerLocation )
    local px, py, pz = respawnPlayerLocation[ index ][ 1 ], respawnPlayerLocation[ index ][ 2 ], respawnPlayerLocation[ index ][ 3 ]
    local rz = math.random( 0, 360 )
    local model = getElementModel( player )
    spawnPlayer( player, px, py, pz, rz, model )
    fadeCamera( player, true, 1 )
    setCameraTarget ( player, player )

    for ElementName, Value in pairs( resetPlayerRespawnElements ) do
        setElementData( player, ElementName, Value )
    end

    setElementData( player, "isDead", false )
    setElementData( player, "WaitingRespawn", false )
    RespawnPlayerTimers[ player ] = nil

    triggerEvent( "onPlayerRespawned", player )
    triggerClientEvent( player, "onClientPlayerRespawned", player )
    return true
end

-- เหตุการณ์เมื่อผู้เล่นออกจากเกม
addEventHandler( "onPlayerQuit", root,
function ( )

    saveStatusSpawnPlayer ( source )

    -- ยกเลิกการเรียกใช้งานตัวจับเวลา
    if RespawnPlayerTimers[ source ]
        if isTimer( RespawnPlayerTimers[ source ] ) then
            killTimer( RespawnPlayerTimers[ source ] )
        end
        RespawnPlayerTimers[ source ] = nil
    end

end
)

-- เหตุการณ์เมื่อระบบหยุดทำงาน สำหรับ ระบบนี้
addEventHandler( "onResourceStop", resourceRoot, 
function ( )

    for i,player in ipairs( getElementsByType( "player" )) do
        saveStatusSpawnPlayer ( player )
    end
    
end
)

addEventHandler( "onPlayerDamageFromClient", resourceRoot, 
function ( attacker, weapon, bodypart, loss )
    if not client then return false end

    if getElementData( client, "SuperArmor" ) then return false end
    local PlayerDown = getElementData( client, "PlayerDown" )
    if PlayerDown then
        return false
    end

    local damage = 0
    local headshot = false

    local blood = getElementData( client, "blood" ) or 0
    local armor = getElementData( client, "armor" ) or 0
    local weaponName = nil

    if damageSpecial[ weapon ] then
        if type( damageSpecial[ weapon ] ) == "number" then
            damage = damageSpecial[ weapon ]
        elseif type( damageSpecial[ weapon ] ) == "table" then
            if damageSpecial[ weapon ][ "original" ] then
                if damageSpecial[ weapon ][ "original" ] == true then
                    damage = loss
                elseif type( damageSpecial[ weapon ][ "original" ] ) == "number" then
                    damage = ( loss * damageSpecial[ weapon ][ "original" ] )
                elseif damageSpecial[ weapon ][ "original" ] == false then
                    return false
                end
            end
        end
    else
        damage = 10
    end

    local damageBody = getDamageBodyPart ( bodypart )
    damage = damage * damageBody

    if armor > 1 then
        if damage > armor then
            damage = damage - armor
            armor = 0
        else
            armor = armor - damage
            damage = 0
        end
    end

    blood = blood - damage 
    setElementData( client, "armor", armor )

    if damage == 0 then return false end
    if blood < 0 then blood = 0 end

    if blood <= 0 then
        setPlayerDown( client, 5, attacker, weaponName, bodypart )
    else
        setElementData( client, "blood", blood )
    end

end
)

setTimer( function ( )
    
    for player,_ in pairs( DownedPlayers ) do
        local PlayerDown = getElementData( player, "PlayerDown" )
        if PlayerDown then
            PlayerDown = PlayerDown - 1
            if PlayerDown <= 0 then
                local attacker = getElementData( player, "PlayerDown:Attacker" )
                local weapon = getElementData( player, "PlayerDown:Weapon" )
                local bodypart = getElementData( player, "PlayerDown:Bodypart" )
                setPlayerDead( player, attacker, weapon, bodypart )
            else
                setElementData( player, "PlayerDown", PlayerDown )
            end
        end
    end

end, 1000, 0 )