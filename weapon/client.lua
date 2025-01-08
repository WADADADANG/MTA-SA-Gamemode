
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