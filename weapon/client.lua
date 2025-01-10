
function playSoundWeapon3D ( player, itemID, status )
    local inv_data = getInventoryItemWeapon ( itemID )
    if inv_data then
        local weapon_data = inv_data.weapon
        if weapon_data then
            local weapon_status = weapon_data[ status ]
            if weapon_status and weapon_status.path_sound then
                local px, py, pz = getElementPosition( player )
                if weapon_status.bone and type( weapon_status.bone ) == "number" and weapon_status.bone >= 1 and weapon_status.bone <= 54 then
                    px, py, pz = getPedBonePosition( player, weapon_status.bone )
                end

                local sound = playSound3D( weapon_status.path_sound, px, py, pz )
                if sound then
                    setSoundMaxDistance( sound, weapon_status.max_distance or 20 )
                    setSoundVolume( sound, weapon_status.volume or 1 )
                    setSoundMinDistance( sound, weapon_status.min_distance or 1 )

                    if weapon_status.interval and type( weapon_status.interval ) == "table" and weapon_status.interval > 0 then
                        setTimer( function ( )
                            if sound and isElement( sound ) then
                                stopSound( sound )
                            end
                        end, 1000 * weapon_status.interval, 1, sound )
                    end
                    return sound
                end

            end
        end
    end
    return false
end

addEventHandler( "onClientPlayerWeaponRemoved", resourceRoot, 
function ( player, itemID )
    playSoundWeapon3D ( player, itemID, "remove" )
end
)

addEventHandler( "onClientPlayerWeaponRearmed", resourceRoot,
function ( player, itemID )
    playSoundWeapon3D ( player, itemID, "rearm" )
end
)

addEventHandler( "onClientPlayerWeaponSwitched", resourceRoot,
function ( player, itemID )
    playSoundWeapon3D ( player, itemID, "switch" )
end
)

function isPlayerInGround ( player )

    for i,state in ipairs( { "jump", "crouch" } ) do
        if getPedControlState( player, state ) then
            return false
        end
    end

    if isPedInVehicle( player ) or isElementInWater( player ) then
        return false
    end

    return isPedOnGround ( player )
end


local lastHitTime = 0
local hitCooldown = 500

function onClientPlayerWeaponFire ( )
    if isCursorShowing( ) then return end

    local player = getLocalPlayer(  )
    local weaponID = getPlayerWeaponID ( player )
    if weaponID then
        if isPlayerInGround ( player ) then

            if getTickCount(  ) > lastHitTime then
                local px, py, pz = getElementPosition( player )
                local tx, ty, tz = getPedTargetEnd( player )
                local hitElement, x, y, z = processLineOfSight ( px, py, pz, tx, ty, tz )
                setTimer( triggerEvent, 200, 1, "onClientonPlayerWeaponFired", player, weaponID, x, y, z, hitElement )

                lastHitTime = getTickCount(  ) + hitCooldown
            end

        end
    end

end

addEventHandler( "onClientKey", root,
function ( button, press )
    if button == "mouse2" and press then
        setPedControlState ( getLocalPlayer(  ), "fire", false )
        setPedAnalogControlState( getLocalPlayer(  ), "fire", 0 )
        onClientPlayerWeaponFire( )
    end
end
)

addEvent( "onClientonPlayerWeaponFired", true )
addEventHandler( "onClientonPlayerWeaponFired", root, 
function ( weaponID, tx, ty, tz, hitElement )
    setPedControlState ( source, "fire", true )
    setPedAnalogControlState( source, "fire", 1 )
    outputChatBox( "onClientonPlayerWeaponFired " .. tostring( weaponID ) .. " " .. tostring( tx ) .. " " .. tostring( ty ) .. " " .. tostring( tz ) .. " " .. tostring( hitElement ) )
end
)