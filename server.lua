KeyPIDAccounts = {}

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
    end
end

-- เหตุการ เมื่อผู้เล่นล็อกอินเข้าเกม หรือ สมัครสมาชิก
addEventHandler( "onPlayerLogin", root, 
function ( thePreviousAccount, theCurrentAccount )

    local PID = getAllAccountData( theCurrentAccount, "PID" )
    if PID then
        -- ผู้เล่นเก่าล็อกอินเข้าเกม

        -- โหลดข้อมูลสถานะผู้เล่น
        loadStatusPlayer( source )

        -- สปอว์นผู้เล่น สำหรับล็อกอิน โดยใช้ ข้อมูลจากฐานข้อมูล
        local defaultSpawn = getDefultSpawnDataAccount ( theCurrentAccount )
        spawnPlayer( source, defaultSpawn.x, defaultSpawn.y, defaultSpawn.z + configServer[ "HeightSpawnLogin" ], defaultSpawn.rz, defaultSpawn.model )
        fadeCamera( source, true, 1 )
        setCameraTarget ( source, source )

        setElementDimension( source, defaultSpawn.dimension )
        setElementInterior( source, defaultSpawn.interior )

        -- เซ็ตค่าสถานะต้านทานความเสียหายทั้งหมด สำหรับล็อกอิน (ชั่วคราว)
        if configServer[ "SuperArmorLoginTimer" ] and configServer[ "SuperArmorLoginTimer" ] > 0 then
            setElementData( source, "SuperArmor", true )
            setTimer( setElementData, configServer[ "SuperArmorLoginTimer" ], 1, source, "SuperArmor", false )
        end

        -- ส่งทิกเกอร์เมื่อผู้เล่นล็อกอินเข้าเกมแล้ว
        triggerEvent( "onPlayerLoginGamemode", source )
        triggerClientEvent( source, "onClientPlayerLoginGamemode", source )
    else
        -- ผู้เล่นใหม่สมัครสมาชิก
        setAccountData( theCurrentAccount, "PID", generateRandomID ( 12 ) )

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

-- เหตุการณ์เมื่อผู้เล่นออกจากเกม
addEventHandler( "onPlayerQuit", root,
function ( )

    saveStatusSpawnPlayer ( source )

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